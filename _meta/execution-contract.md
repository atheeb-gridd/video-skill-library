---
name: execution-contract
description: What actually runs. The real primitives of HyperFrames, Epidemic Sound MCP, and ffmpeg in this project — attribute names, command names, transition names, and the constraints that break a spec. Every technique note must be expressible in these terms.
type: reference
---

# The execution contract

A technique note is only useful if the spec it emits can be executed. This document is the boundary of the executable: the real attributes, the real command names, the real transition names, quoted from the HyperFrames skill files staged in this project. Anything not in here is not known to run.

**Provenance.** Everything below is extracted from these files (staged under `/mnt/user-data/uploads/video editing/hyperframes/`):

| Source | Owns |
|---|---|
| `CLAUDE.md` | project commands, key rules |
| `.claude/skills/hyperframes/SKILL.md` | router, domain-skill map, creator-edit routing table |
| `.claude/skills/hyperframes-core/SKILL.md` | composition contract, lint gotchas, non-negotiables |
| `hyperframes-core/references/data-attributes.md` | **the attribute table** |
| `hyperframes-core/references/tracks-and-clips.md` | tracks, relative timing |
| `hyperframes-core/references/creator-editing-recipes.md` | cut/trim/crossfade/duck recipes |
| `hyperframes-core/references/composition-patterns.md` | monolithic vs modular, sub-comp archetypes |
| `hyperframes-core/references/storyboard-format.md` | `STORYBOARD.md` plan layer |
| `hyperframes-animation/SKILL.md`, `rules-index.md`, `techniques.md` | motion rules, runtimes |
| `hyperframes-animation/adapters/gsap-easing-and-stagger.md` | eases, stagger, spring |
| `hyperframes-animation/transitions/TRANSITION-REGISTRY.md`, `overview.md` | transitions |
| `hyperframes-audio/SKILL.md` + `references/{attributes,presets,fx-registry}.md` | the mix |
| `hyperframes-creative/references/{typography,motion-principles}.md` | craft guardrails |
| `media-use/SKILL.md` + `references/{operations,audio}.md` + `scripts/transcript-cut.mjs` | raw media, ffmpeg |
| `hyperframes-cli/references/preview-render.md` | preview/play/render/publish flags |
| `compositions/captions.html` | the one real composition file in the project |

Where a referenced file was **not** staged, this document says so rather than inventing its contents.

**Two sections have different provenance, and it is better provenance.** §5A and §7A were added after the original pass and are **not** derived from the staged files above — the agent that wrote the first version read only the HyperFrames set, which is why the Epidemic Sound surface was missing entirely and the analysis toolchain was undocumented.

| Section | Provenance |
|---|---|
| **§5A — the Epidemic Sound MCP surface** | Read directly off the **live MCP tool schemas in this environment**: parameter names, nesting, required fields, enum members and return-type fields are quoted from them. The six filter facets come from `visual-kt-delta.md`, read off screen recordings in the reference videos. Gaps are stated plainly in §5A.8 rather than guessed. |
| **§7A — the analysis toolchain** | **Executed in this container.** Each entry is marked **[verified]** (the command was run here and the quoted output is what it printed) or **[unverified]** (documented from knowledge, not executed). The container's ffmpeg version is stated in §7A.0. |

---

## 1. Stack map — who owns what

| Job | Owner | Boundary |
|---|---|---|
| Composition, layout, timing, tracks, clips | **HyperFrames core** (`data-*` attributes in HTML) | Owns *when* something is on screen and *what source range it plays*. Never owns pixels of a source file. |
| Motion, easing, transitions, captions-as-motion | **HyperFrames animation** (one paused GSAP timeline per composition) | Owns *how* an element moves inside its clip window. Cannot change which source frames play. |
| Mixing: gain, fades, ducking, EQ/compression, submix | **HyperFrames audio** (`data-fx-chain`, `data-automation`, `data-fx-carve`, `<hf-audio-group>`) | Owns *placed* tracks only. Does not source or generate audio. |
| Sourcing / generating media (BGM, SFX, voice, images, icons, logos, grades, LUTs) | **`media-use`** (`resolve.mjs`, HeyGen CLI) — **and in this project, Epidemic Sound via MCP** | Produces a frozen local file. Stops at the file. |
| Raw file operations: physical trim, concat, reframe, speed, loudness, transcription, transcript cut | **ffmpeg / `media-use` scripts** | Operates on files outside the composition. Anything it produces re-enters as a `src`. |
| Preview, validation, render, publish | **`hyperframes` CLI** | `check` gates; `render` is the only thing that produces an MP4. |
| Remotion | **not present in this project** | Only referenced as a *source* format to port *from* (`/remotion-to-hyperframes`). See §10. |

**Two hard boundary rules worth memorising, both quoted from the skills:**

- In-composition trimming needs no new file: *"a clip plays a sub-window via `data-media-start` + `data-duration` ... Only cut a physical file when exporting/assembling outside the composition."* (`media-use/references/operations.md`)
- Ducking is declared, not baked: *"Declare inside compositions. Bake only for assets leaving the hyperframes pipeline."* (same file)

Where Epidemic Sound fits: it replaces the *sourcing* half of `media-use` for SFX/music/voiceover. Its output is a file path. Placement, gain and timing are then pure HyperFrames — §5 gives the exact handoff.

---

## 2. HyperFrames composition anatomy

### What a composition file is

An HTML file. *"HyperFrames renders video from HTML. A composition is an HTML file whose DOM declares timing with `data-*` attributes, whose animation runtime is seekable, and whose media playback is owned by the framework."* (`hyperframes-core/SKILL.md`)

Project structure (`CLAUDE.md`):

```
index.html        — main composition (root timeline)
compositions/     — sub-compositions referenced via data-composition-src
meta.json         — project metadata (id, name)
transcript.json   — whisper word-level transcript (if generated)
```

### Two root forms — not interchangeable

- **Standalone** (top-level `index.html`): root `<div data-composition-id="…">` sits **directly in `<body>`, no `<template>` wrapper**. Wrapping it hides all content and lint rejects it: `standalone_composition_wrapped_in_template` (error).
- **Sub-composition** (loaded via `data-composition-src`): the root **is** wrapped in `<template>`.

Transport rule for templated sub-comps: the assembler **drops the file's own `<head>` `<style>`/`<script>`**, so put them **inside** the template. `<link>` is hoisted either way.

Host-id convention: the host slot, the inner template root, and the `window.__timelines["<id>"]` key should all use the **same id**. A mismatch is supported but silent.

### One paused timeline per composition

```js
window.__timelines = window.__timelines || {};
window.__timelines["composition-id"] = gsap.timeline({ paused: true });
```

- Exactly **one** `gsap.timeline({ paused: true })` per composition, keyed by the root's `data-composition-id`.
- Register **only after the build completes**. Building inside `document.fonts.ready` is supported.
- `window.__timelines = window.__timelines || {}` is no longer required — *"the runtime creates the registry before your inline scripts run, and `lint` no longer asks for it."* (Harmless to keep; `captions.html` and the recipes still write it.)
- **Do not manually nest sub-timelines** into the host. *"the runtime auto-nests registered child timelines."*

### The timing model — seconds, with fps as a hint

This is the single most important fact for note authors:

> **All authored time is in SECONDS. There is no frame-based data attribute.**

- `data-start` — start time in **seconds**, measured from the start of the *composition*.
- `data-duration` — duration in **seconds**.
- `data-media-start` — offset into the media source, in **seconds**.
- `data-fps` — *"Optional frame rate hint. CLI render flags can override output fps."*
- Render fps comes from `npx hyperframes render --fps 24|30|60`, default **30**.

Consequence for technique notes: **express a duration in frames only as a derived comment, and author the seconds.** A "12-frame ease-out slide" at 30fps is `duration: 0.4`. See §3 for the exact tween.

**Render length is the root's `data-duration`, not the timeline's length.** A timeline running past it is cut off; one ending early holds its last frame. Root `data-duration` is *"Read once at compile time, like `data-width` / `data-height`"* — a script or `--variables` **cannot** change render length. A **clip's** `data-duration` is different: re-read from the live DOM, so scripts/variables can drive it.

Omit the root `data-duration` and length is inferred (registered GSAP timeline, finite CSS animation, finite WAAPI `element.animate()`, or registered Lottie). It is **required** for Three.js, for infinite/unbounded CSS or WAAPI animations, and for any composition with no animation signal at all — enforced by lint rule `root_composition_missing_duration_source`.

### The visibility window is half-open

> **`[start, start + duration)`** — a clip shows while `start ≤ t < start + duration` and is hidden at exactly `t = start + duration`.

Two consequences, both quoted:

- *"Land an animation's resolved end state slightly **before** `data-duration`, not on it, or its last frame is never rendered."*
- *"Two clips can therefore be authored back to back (`b.start === a.start + a.duration`) with no overlapping frame."*

### Clips and tracks

`data-start` is what makes an element a clip: *"The runtime collects `[data-start]` and drives visibility off that attribute."*

`class="clip"` is a **convention, not a runtime requirement** — but keep it: the scaffold's shared `.clip { position: absolute; inset: 0 }` rule is what gives a scene its full-frame box, Studio uses it as an edit hint, and lint warns `timed_element_missing_clip_class`. Omit it on `<video>` and `<audio>`.

Nesting is allowed. A timed ancestor **clamps** its descendants — a child cannot be visible while its timed ancestor is hidden.

**Root-level clips get automatic layout:** direct children of the root carrying `data-start` are forced to `position: absolute`, anchored `top: 0; left: 0`, sized to 100% when they have no computed size. Elements **without** `data-start` are skipped entirely — an untimed full-bleed background needs its own `position: absolute; inset: 0` or it collapses to zero height.

`data-track-index` is **display only**: *"It is not read by the render, and it constrains nothing."* Two clips on the same track may overlap in time; both render, painted in CSS order. **Layering is CSS `z-index`, not track index.** Conventional layout: track `0` base video, `1+` visual scenes/overlays/captions, `10+` audio.

The one place track index carries meaning: two `<audio>` elements sharing a track index **and** overlapping in time raise lint warning `duplicate_audio_track`.

### Relative timing (and its four silent failures)

`data-start` accepts a clip **id** instead of a number, meaning "start when that clip ends". `+ N` / `- N` offsets; negative produces overlap (crossfades).

```html
<video id="intro"   data-start="0"           data-duration="10" data-track-index="0" src="..."></video>
<video id="main"    data-start="intro"       data-duration="20" data-track-index="0" src="..."></video>
<video id="scene-a" data-start="intro + 2"   data-duration="20" data-track-index="0" src="..."></video>
<video id="scene-b" data-start="intro - 0.5" data-duration="20" data-track-index="1" src="..."></video>
```

Nothing in lint checks any of these. Each failure resolves silently to `0`:

1. **Spaces around the operator are required.** `"intro-0.5"` parses as an id literally named `intro-0.5` → clip starts at 0.
2. **An unresolved reference resolves to 0**, it does not error.
3. **If the target has no resolvable duration, the reference lands on the target's START, not its end.**
4. **A cycle resolves to 0.**

Also: lookup is **document-wide** (`getElementById`, then `[data-composition-id]`), so a reference can reach another composition on the assembled page. Keep reference and target in the same file. *"snapshot a reference-timed composition and check the clip actually starts where you meant."*

### How sub-compositions nest

Host slot in `index.html`:

```html
<div id="el-intro"
     data-composition-id="intro"
     data-composition-src="compositions/intro.html"
     data-start="0" data-duration="6" data-track-index="1"></div>
```

The sub-comp's internal timeline runs from the host's `data-start` to `data-start + data-duration`. Inside the sub-comp, its own clip `data-start` values are **scene-local**.

Architecture choice (`composition-patterns.md`):

| | Monolithic | Modular |
|---|---|---|
| Layout | `index.html` only | `index.html` + `compositions/<scene>.html` |
| Scenes | inline `<section class="clip">` siblings | one `<template>`-wrapped file each |
| Timelines | one, keyed at root id | thin/near-empty root + one per sub-comp |

Pick modular when there are clear scene cuts, scenes over ~100 lines, reusable scenes, or a continuous audio track over multiple visual segments (*"Keep audio at the root, visual segments as sub-comps"*). *"If a monolithic project is approaching three or more scene cuts, prefer modularizing before adding the next scene."*

**The hard nesting limit: a sub-comp timeline cannot animate host-root elements.** A global selector or `document.querySelector` does not resolve across the boundary. Two ways out (archetype B):

- Put the media/element inside the sub-comp and drive it from the sub-comp's own timeline; or
- Put it as a **host-root sibling** and drive it on the main timeline at **global time = scene-local time + the slot's `data-start`**.

Other archetypes: **C. Multi-scene merge** — when several beats share continuous state (a growing chat thread, one canvas with phase changes), collapse them into one sub-comp with internal `.phase` divs rather than several slots. **D. Audio at root, reactive visual inside** — audio always at the host root so playback survives scene cuts; the visual reads a **pre-baked** frequency curve and must remain a function of `tl.time()`, never `audio.currentTime`.

Id hygiene: *"Keep every `id` unique across the **assembled** page (prefix sub-comp ids with the composition id, `#<id>-hero`)."* The compiler stamps a document-unique `data-hf-render-id` on every `video[src]`/`audio[src]`/`img[src]`, **but media using `<source>` children instead of a `src` attribute is not stamped**, so unique ids still matter there.

### Determinism bans (silent-bug class)

- No render-time clocks (`Date.now()`, `performance.now()`), no unseeded `Math.random()`, no network fetches, no input-state.
- No `repeat: -1` — use a finite count.
- Never tween `display` or raw `visibility` **on a clip element** — the framework owns clip visibility and lint rejects it. Use GSAP `autoAlpha`, or a zero-duration boundary `tl.set()` on a **non-clip** element/wrapper.
- No `<br>` in body text; transformed elements must be block-level + sized.
- No timeline construction inside `async` / `setTimeout` / `Promise`.
- Never derive positions from `getBoundingClientRect()` at tween time — *"compute coordinates once at composition setup and reuse."* In a **multi-scene** montage, do not measure at all: later clips may not be laid out yet, so use authored CSS-matched constants.
- **No iframes for captured content** — they do not seek with the timeline.
- **Ambient pulses must attach to the seekable `tl`, never bare `gsap.to()`** — standalone tweens run on wallclock and are absent from the render.

### First-pass lint gotchas (each is a guaranteed first-build failure)

| Rule | Trigger | Severity |
|---|---|---|
| `gsap_css_transform_conflict` | CSS initial `transform` + a GSAP tween on the same property. Use `gsap.fromTo(el, { x: -40 }, { x: 0 })` instead of CSS `translateX(-40px)`. | error |
| `media_crossorigin_breaks_preview` | `crossorigin` on `<video>`/`<audio>`. **No suppression exists.** | error |
| `video_nested_in_timed_element` | a `<video data-start>` whose ancestor also carries `data-start`. Time the wrapper **or** the video. | error |
| `media_missing_id` | any `<audio>`/`<video>` without an `id`. An id-less `<audio>` is **never mixed → silent render**. | error |
| `root_composition_missing_duration_source` | no root `data-duration` and no inferable duration source | error |
| `timed_element_missing_clip_class` | timed element without `class="clip"` | warning |
| `studio_missing_editable_id` | non-media timed element without an `id` | warning |
| `duplicate_audio_track` | two `<audio>` sharing a track index and overlapping | warning |
| `duplicate_media_discovery_risk` | two media elements sharing `src` + `data-start` | benign |
| `audio_volume_double_automation` | a `volume` automation lane **and** a GSAP `volume` tween on one track — the lane wins | lint |
| `audio_volume_tween_overrides_gain` | authored `data-volume` on a track whose `volume` is tweened — the tween is absolute and replaces the gain | lint |
| `audio_carve_ungrouped_sources` | a carve `sources` list naming two or more plain clip ids instead of a group | lint |
| `audio_group_carve_attr` | `data-fx-carve` written onto an `<hf-audio-group>` | lint |
| `standalone_composition_wrapped_in_template` | standalone root inside a `<template>` | error |

**Critical:** *"A lint **error** also switches off the layout and contrast audits: `check` then reports `0 sample(s)` and `0/0 text checks`, which reads like a clean file but means nothing ran."*

### Root sizing (silent layout bug)

The standalone root needs an explicit **sized box** in px, and every ancestor down to a `height:100%` element must have a resolved height — otherwise a flex/`100%` child collapses to ~0 and content piles into the top-left corner. *"Do not rely on automated gates alone to catch this; inspect a snapshot."*

### The plan layer — `STORYBOARD.md`

Optional but real, and parsed: `@hyperframes/core/storyboard` → `StoryboardManifest`; read API `GET /api/projects/<id>/storyboard`; Studio renders it as a contact sheet (`?view=storyboard` ahead of the hash).

Frontmatter keys: `format`, `duration`, `message`, `arc`, `audience`, `mode`.
Per-frame heading `## Frame N — Title` (`Frame` / `Beat` / `Scene` at H2/H3), metadata as `- key: value` bullets, free-form narrative below. Frame keys: `status` (`outline` → `built` → `animated`), `src`, `duration`, `transition_in` (alias `transition`), `scene` (aliases `description`/`summary`/`caption`), `voiceover` (aliases `vo`/`voice_over`/`narration`), `poster`. Unknown keys are preserved under `extra`. The parser *"never throws"* and records surprises as `warnings`.

Structured review feedback: `.hyperframes/frame-comments.json` with `version`, `pass` (`storyboard`/`sketch`/`final`), `submitted_at`, and `comments[].{frame,src,title,text}`. Contract: *"revise exactly the frames named, delete the file, re-present."*

`SCRIPT.md` (locked narration for TTS) exists but is **not** parsed into the manifest; its format lives in `references/script-format.md`, **not staged**.

---

## 3. Data attribute reference

This is the lookup table a technique note resolves its spec against. Everything here is quoted or directly transcribed from `hyperframes-core/references/data-attributes.md`, `tracks-and-clips.md`, and `hyperframes-audio/references/attributes.md`.

### 3.1 Composition root

| Attribute | Required | Meaning |
|---|---|---|
| `data-composition-id` | Yes | Unique ID. Must match the animation registry key on `window.__timelines`. |
| `data-width` / `data-height` | Yes | Pixel frame size. Common values: `1920x1080`, `1080x1920`, `1080x1080`. |
| `data-duration` | Conditional | Render duration in **seconds**, not the GSAP timeline length. Read **once at compile time** — scripts and `--variables` cannot change it. |
| `data-fps` | No | Optional frame rate hint. CLI render flags can override output fps. |
| `data-composition-variables` | No | JSON **array of declarations** (`{id, type, label, default}`), on `<html>`. |

The root should be `position: relative`, have explicit pixel dimensions, and hide overflow unless intentionally composing outside the frame.

### 3.2 Clip attributes (the timing core)

| Attribute | Required | Meaning |
|---|---|---|
| `id` | Yes on `<video>`/`<audio>`, else recommended | `media_missing_id` is an error; an id-less `<audio>` is never mixed → **silent render**. Elsewhere warning `studio_missing_editable_id`. |
| `data-start` | Yes | Start time in **seconds**, or a clip-id reference (`<id>`, `<id> + <n>`, `<id> - <n>`). **This attribute is what marks the element as timed.** |
| `data-duration` | Required for `div`, `img`, sub-compositions | Duration in seconds. Video/audio can default to media duration. Without any resolvable duration the element **has no end and stays visible for the rest of the composition**. |
| `data-track-index` | No | Studio timeline lane, **display only**. Render never reads it; clips on one track may overlap. |
| `data-media-start` | No | Offset into the media source, in seconds. |
| `data-volume` | No | Static audio gain, default `1` (0 dB). `0` is silence; above `1` boosts **up to `3.98` (+12 dB)**. A `volume` tween's own values **replace this baseline entirely**. |
| `data-has-audio` | No (`<video>` only) | `"true"` to declare the video carries an audio track when auto-detection would miss it. |
| `data-playback-rate` | No | Constant rate, normalized **`0.1..5`**. Render-safe for picture and **pitch-preserved** sound. **No rate envelope exists** — speed ramps must be preprocessed. |
| `data-audio-group` | No | Names the `<hf-audio-group>` bus / carve group this track belongs to. |
| `data-hidden` | No | Hides the element in **both preview and render**, overriding its time window. Non-destructive, reversible, toggled by Studio's timeline eye icon. |

### 3.3 Sub-composition host attributes

| Attribute | Required | Meaning |
|---|---|---|
| `data-composition-id` | Recommended | The composition ID of the loaded file. A mismatch resolves silently. |
| `data-composition-src` | Yes | Path to the sub-composition HTML file. |
| `data-width` / `data-height` | No | Per-instance render dimensions; compiler backfills from the loaded file's root. |
| `data-variable-values` | No | Per-instance variable overrides as JSON. |
| `data-var-src` | No | Binds the element's `src` to a declared variable id (authored src = fallback). |
| `data-var-text` | No | Binds the element's own text to a scalar variable id; children preserved. |

### 3.4 Audio attributes (JSON-encoded, on the media element or the bus)

| Attribute | Holds | Scope |
|---|---|---|
| `data-fx-chain` | the effects, in signal order | clip **or** `<hf-audio-group>` |
| `data-automation` | envelopes on this track's volume or its effect parameters | clip (clip-local `t`) **or** bus (**composition-time** `t`) |
| `data-fx-carve` | the carve's own settings, so it can be re-derived | **clip only** |

`<hf-audio-group>` bus attributes: `data-fx-chain`, `data-automation`, `data-volume` (one fader for every member, default `1`), `data-label` (display name, falls back to id), `data-hidden` (drops every member from the mix).

**Escaping rule, load-bearing:** *"Write these attributes double-quoted, with the JSON's own quotes as `&quot;`."* `scripts/carve.mjs` finds them with a `name="..."` regex — a single-quoted attribute is **invisible to it** and the carve silently overwrites work it could not see. `&` becomes `&amp;`.

(Note: the staged `creator-editing-recipes.md` examples themselves use single-quoted `data-automation='{…}'`. Both parse in the browser; the double-quoted+`&quot;` form is the one that survives `carve.mjs`.)

### 3.5 Layout-audit escape hatches

| Attribute | Effect |
|---|---|
| `data-layout-allow-overflow` | Tells `hyperframes check` that overflow here or in descendants is intentional. **Blast radius:** inherited down the subtree — also suppresses `text-clipping`, `content-cramped-container`, and `foreground-over-panel` for every descendant. `primary-offscreen` and `foreground-over-panel` deliberately still run. |
| `data-layout-bleed="true"` | Narrower opt-out for one intentional primary-text crop. |
| `data-layout-ignore` | Exclude this element from layout audits entirely. |
| `data-layout-allow-caption-zone` | Opt out of `--caption-zone` / `caption_zone_collision` for intentional lower-third copy (element + descendants, via `closest`). Does **not** suppress overflow/overlap/occlusion audits. |
| `data-no-capture` | Shader-transition only: the html2canvas capture skips this element (present in live DOM, absent from the shader texture). |
| `data-root="true"` | Names the composition root explicitly, when compositions nest ambiguously. |
| `data-hf-id` / `data-hf-render-id` | Framework-stamped stable targets. Prefer `selection.target.hfId` from `preview --context`. |

### 3.6 Legacy / removed

| Legacy name | Use instead |
|---|---|
| `data-layer` | `data-track-index` |
| `data-end` | `data-duration` |

### 3.7 Motion is JS, not attributes

There is **no** `data-ease`, `data-transition`, `data-animation` attribute. Motion is authored as GSAP tweens on the composition's single paused timeline, positioned in seconds.

Built-in eases (`gsap-easing-and-stagger.md`): `power1`, `power2`, `power3`, `power4`, `back`, `bounce`, `circ`, `elastic`, `expo`, `sine`, `none` — each with `.in`, `.out`, `.inOut`.

| Ease | Use for |
|---|---|
| `power1.out`, `power2.out` | Gentle motion for secondary elements. **NOT the entrance default.** |
| `power3.out` (house default), `power4.out` | The standard long-tail settle. Entrances, title cards, hero reveals. |
| `sine.inOut` | Long, slow, calm motion. Crossfades, ambient drift. |
| `back.out(1.7)` | Overshoot then settle. **RARE** — explicitly-playful register only. |
| `elastic.out(1, 0.3)` | Springy bounce. Same playful-only rule. |
| `expo.inOut` | Snappy, dramatic. Quick transitions between hero scenes. |
| `none` (linear) | Camera moves with timed counterpoint, mechanical motion. |
| `steps(N)` | Discrete jumps. Typing, cursor blink, counter ticks. |

Doctrine, verbatim: *"**Smooth beats bouncy**"* — entrances default to `power3.out` or the baked critically-damped spring; overshoot (`back`/`elastic`/`bounce`) is *"a rare, explicitly-playful register, never the house style."* Vary **within** the smooth families by energy (`sine`/`power1` calm → `power3` standard → `power4`/`expo` punch). *"One ease everywhere reads flat; bounce everywhere reads cheap — the second failure is worse."* Aim for ~3 easing characters per composition.

Timeline-scoped defaults are preferred over global:

```js
const tl = gsap.timeline({
  paused: true,
  defaults: { duration: 0.6, ease: "power3.out" },
});
```

Stagger: prefer `stagger` over N manual-delay tweens. Object form keys: `each`, `from` (`"start" | "end" | "center" | "edges" | "random" | index`), `amount` (total, overrides `each`), `grid: "auto"`, `axis: "x" | "y"`. Hard cap from the rules contract: **`items × stagger ≤ ~0.5s`** so an arrival reads as one beat.

Function-based values: any var can be `(index, target, targets) => value`.

Baked spring ease (`springEase({ response, dampingFraction })`) exists in `gsap-easing-and-stagger.md` as a **pure function of progress** — seek-safe by construction, because *"an interactive spring is a stateful integrator ... which cannot be seeked deterministically."* Take **both** the ease and the `duration` from the helper. `dampingFraction` 1.0 = house settle (no overshoot), 0.80–0.85 = iOS register, 0.60–0.70 = explicitly playful, `< 0.55` = don't. `response` 0.25–0.35 tight snap, 0.35–0.50 standard entrance, 0.50–0.70 weighted hero landing. **At ζ<1, overshooting curves go on transforms only** — never `opacity` or color; split opacity onto its own `power2.out` tween at the same position.

### 3.8 Worked lookup — "how do I express a 12-frame ease-out slide?"

At the render default of 30fps, 12 frames = **0.4s**. There is no frame unit; author seconds.

```js
// 12 frames @30fps = 0.4s. Slide in from the left, house settle, starting at t=1.2s.
tl.fromTo("#card",
  { x: -40, autoAlpha: 0 },
  { x: 0, autoAlpha: 1, duration: 0.4, ease: "power3.out" },
  1.2
);
```

Why each piece is what it is:

- `fromTo`, not `from` — *"`gsap.from()` sets `immediateRender: true` by default, which writes the 'from' state at timeline construction — before the `.clip` scene's `data-start` is active."* Under non-linear seek (which the render engine does) `from()` elements flash, start wrong, or skip their entrance.
- `x`, not `left` — spatial motion uses GSAP transform aliases only (`x`, `y`, `scale`, `rotation`). `width`/`height`/`top`/`left` tweens are **forbidden**.
- No CSS `transform: translateX(-40px)` on `#card` — that is `gsap_css_transform_conflict` (error).
- `autoAlpha`, not raw `visibility`/`display` — and only on a non-clip element or an inner wrapper.
- Third argument `1.2` is the **absolute position in composition seconds**, not a delay.
- The tween must land **before** the clip's `data-duration`, per the half-open window.
- No CSS `transition` on the element — *"they interpolate independently of seek and flicker."*

If the parent clip is 3s starting at 5s, the same slide 12 frames after the clip opens sits at `tl` position `0.0` inside a **sub-comp** timeline, or `5.0` on the **main** timeline. Sub-comp time is scene-local; main-timeline time is global.

### 3.9 Speed / duration craft numbers

From `motion-principles.md` — usable as spec defaults:

| Band | Seconds | Reads as |
|---|---|---|
| Fast | 0.15–0.3 | energy, urgency, confidence |
| Medium | 0.3–0.5 | professional, most content |
| Slow | 0.5–0.8 | gravity, luxury, contemplation |
| Very slow | 0.8–2.0 | cinematic, emotional, atmospheric |

Plus: *"The slowest scene should be 3× slower than the fastest."* · *"Don't start at t=0. Offset the first animation 0.1-0.3s."* · Scene structure **build (0–30%) / breathe (30–70%) / resolve (70–100%)** with exactly ONE ambient motion in breathe · *"Entrances need longer than exits"* (0.4s in, 0.25s out) · total stagger sequence under 500ms regardless of item count · stagger in order of **importance**, not DOM order.

### 3.10 Motion rule library (names only — recipe files not staged)

`hyperframes-animation/rules-index.md` indexes atomic recipes at `rules/<name>.md`. **The `rules/` directory itself was not staged**, so only names + tags are known here. A note may cite a rule by name; it must not quote its code.

- **Text & Typography:** `hacker-flip-3d`, `vertical-spring-ticker`, `counting-dynamic-scale`, `discrete-text-sequence`, `asr-keyword-glow`, `3d-text-depth-layers`, `context-sensitive-cursor`, `dynamic-content-sequencing`, `kinetic-beat-slam`, `gradient-text-sweep`, `chromatic-glitch`
- **Data & Stats:** `counting-dynamic-scale`, `stat-bars-and-fills`, `chart-scrub-readout`
- **Camera & Viewport:** `coordinate-target-zoom`, `camera-cursor-tracking`, `multi-phase-camera`, `viewport-change`, `3d-camera-flight`, `depth-of-field-blur`
- **Layout & Network:** `avatar-cloud-network`, `3d-page-scroll`, `center-outward-expansion`, `split-tilt-cards`, `orbit-3d-entry`, `ai-tracking-box`, `depth-scatter-assemble`, `anchored-layout-expand`
- **SVG & Icons:** `svg-icon-enrichment`, `svg-path-draw`
- **Idle & Ambient:** `sine-wave-loop`, `ambient-glow-bloom`
- **Transition & Motion:** `reactive-displacement`, `press-release-spring`, `physics-press-reaction`, `cursor-click-ripple`, `cursor-drag`, `multi-cursor-choreography`, `control-target-sync`, `scale-swap-transition`, `card-morph-anchor`, `theme-crossfade-morph`, `spring-pop-entrance`, `motion-blur-streak`, `waterfall-entry`, `particle-burst`, `nudge-curve`
- **Effect recipes:** `gsap-effects`, `css-marker-patterns`

The 13 broader techniques in `techniques.md` (fully staged, code included): SVG path drawing · Canvas 2D procedural art · CSS 3D transforms · per-word kinetic typography · Lottie · video compositing · character-by-character typing · variable font axis animation · GSAP MotionPathPlugin · velocity-matched transitions · audio-reactive animation · clip-path reveal masks · WebGL fragment shader art. *"every composition should use at least 2-3 of."*

**Runtime adapters** (7): GSAP (default, ~95% of motion work), Lottie (`window.__hfLottie`), Three.js (`AnimationMixer`, `hf-seek`), Anime.js (`window.__hfAnime`), CSS keyframes, WAAPI (`element.animate()`), TypeGPU/WebGPU. Multiple runtimes may coexist; each registers on its global so HyperFrames seeks all of them in one pass. Lottie requires `autoplay: false` + `loop: false` + `window.__hfLottie.push(anim)` — anything left on autoplay/loop *"runs in wall-clock and renders non-deterministically."*

---

## 4. Transition registry

Two distinct things live under "transitions", and conflating them produces unrunnable specs.

### 4.1 The machine registry — 5 transitions, Tier-B ready

`TRANSITION-REGISTRY.md` is *"Single source of truth for **PLV scene-to-scene transitions**"* — a curated subset that is *"pure transform / opacity / filter on the two scene **clip wrappers** (`#el-<sid>`), no injected overlay DOM, no per-scene cooperation."*

| `name` | tier | energy | `default_duration_s` | directions | source file |
|---|---|---|---|---|---|
| `crossfade` | b | any | 0.5 | — | `css-dissolve.md` |
| `blur-crossfade` | b | calm | 0.6 | — | `css-dissolve.md` |
| `push-slide` | b | medium | 0.5 | `LEFT`, `RIGHT`, `UP`, `DOWN` (default `LEFT`) | `css-push.md` |
| `zoom-through` | b | high | 0.4 | — | `css-scale.md` |
| `squeeze` | b | medium | 0.4 | — | `css-push.md` |

Registry globals: `tier_a_types: ["morph", "shared-element"]` · `default_high_energy: "zoom-through"` · `default_calm: "blur-crossfade"` · **`max_duration_s: 2.0`**.

`blur-crossfade` carries a note worth quoting: *"Default when the two scenes' `#root` backgrounds differ a lot — the blur masks the background-color clash a plain crossfade would expose."*

Actual GSAP for the two most useful, verbatim from the registry templates (tokens: `__OLD__` = `"#el-<from>"`, `__NEW__` = `"#el-<to>"`, `__T__` = overlap-start seconds, `__DUR__` = duration):

```js
// crossfade
tl.to(__OLD__, { opacity: 0, duration: __DUR__, ease: "power2.inOut" }, __T__);
tl.fromTo(__NEW__, { opacity: 0 }, { opacity: 1, duration: __DUR__, ease: "power2.inOut" }, __T__);

// zoom-through
tl.to(__OLD__, { scale: 2.5, opacity: 0, filter: "blur(8px)", duration: __DUR__, ease: "power3.in" }, __T__);
tl.fromTo(__NEW__, { scale: 0.5, opacity: 0, filter: "blur(8px)" },
                  { scale: 1, opacity: 1, filter: "blur(0px)", duration: __DUR__, ease: "power3.out" }, __T__);
```

How the injector applies one at a `break` boundary: (1) extends `#el-<from>` `data-duration` by `duration_s` so it holds its final frame; (2) pulls `#el-<to>` `data-start` **earlier** by `duration_s` to create the overlap; (3) reassigns all `data-track-index` as a 0/1 ping-pong so the overlapping wrappers never share a track — *"a readability convention, not a render constraint"*; (4) stamps the template into `window.__timelines["main"]` at `T = overlap-start`.

Planner budget: *"Pick **2-3 types for the whole video** and repeat them — repetition is what reads as professional."* The Tier-A `shared-element` morph is exempt. Planner syntax in a storyboard:

```
**Transition:** blur-crossfade
**Transition:** push-slide LEFT
**Transition:** zoom-through 0.3s
```

Note `filter` / `scaleX` / `transformOrigin` are lint-clean **on the master timeline** — the `x/y/scale/rotation/opacity` whitelist is a *scene-worker prompt rule only*, it does not bind `index.html`.

### 4.2 The broad catalog — ~40 names, code NOT staged

`overview.md` describes *"`catalog.md` + `css-*.md` (≈40 CSS + shader)"* — **none of those files were staged.** The names below are real and citable; their implementations are not available here. A technique note must not emit code for these; it can name one and point at `catalog.md`.

| Category | CSS | Shader (WebGL) |
|---|---|---|
| Push/slide | push slide, vertical push, elastic push, squeeze | whip pan |
| Scale/zoom | zoom through, zoom out, gravity drop, 3D flip | cinematic zoom, gravitational lens |
| Reveal/mask | circle iris, diamond iris, diagonal split, clock wipe, shutter | SDF iris |
| Dissolve | crossfade, blur crossfade, focus pull, color dip | cross-warp morph, domain warp |
| Cover | staggered blocks, horizontal blinds, vertical blinds | — |
| Light | light leak, overexposure burn, film burn | light leak (shader), thermal distortion |
| Distortion | glitch, chromatic aberration, ripple, VHS tape | glitch (shader), chromatic split, ridged burn, ripple waves, swirl vortex |
| Pattern | grid dissolve, morph circle | — |

**Explicitly do not work in CSS:** star iris, tilt-shift, lens flare, hinge/door.

Selection tables (usable verbatim in a spec):

| Energy | CSS primary | Accent | Duration | Easing |
|---|---|---|---|---|
| Calm | blur crossfade, focus pull | light leak, circle iris | 0.5–0.8s | `sine.inOut`, `power1` |
| Medium | push slide, staggered blocks | squeeze, vertical push | 0.3–0.5s | `power2`, `power3` |
| High | zoom through, overexposure | staggered blocks, gravity drop | 0.15–0.3s | `power4`, `expo` |

Blur intensity by energy: calm 20–30px over 0.8–1.2s (hold 0.3–0.5s) · medium 8–15px over 0.4–0.6s (hold 0.1–0.2s) · high 3–6px over 0.2–0.3s (no hold).

Named presets: `snappy` 0.2s `power4.inOut` · `smooth` 0.4s `power2.inOut` · `gentle` 0.6s `sine.inOut` · `dramatic` 0.5s `power3.in`→out · `instant` 0.15s `expo.inOut` · `luxe` 0.7s `power1.inOut`.

Narrative position: opening = most distinctive, 0.4–0.6s · between related points = primary, 0.3s · topic change = something different from primary · climax = boldest accent · wind-down = 0.5–0.7s gentle · outro = 0.6–1.0s slowest/simplest.

### 4.3 The four non-negotiable multi-scene rules

Quoted from `overview.md`:

1. **Every composition uses transitions.** No exceptions.
2. **Every scene uses entrance animations** — via `gsap.fromTo()`, because `from()` animates *to* current CSS and pairing it with CSS `opacity: 0` is a 0→0 noop.
3. **Exit animations are BANNED** except on the final scene. *"The transition IS the exit."* Outgoing content must be fully visible when the transition starts.
4. **Final scene exception:** the last scene may fade out.

The banned pattern and the correct one, verbatim:

```js
// ❌ BANNED — a jump cut with a dip, not a transition.
tl.to("#s1", { opacity: 0, duration: 0.4 }, 4.0);
tl.from("#s2 .headline", { y: 40, opacity: 0 }, 4.4);

// ✅ CORRECT — outgoing and incoming animate AT THE SAME TIME T.
const T = 4.0;
tl.to("#s1", { yPercent: -100, filter: "blur(8px)", duration: 0.5, ease: "power3.in" }, T);
tl.fromTo("#s2", { yPercent: 100 }, { yPercent: 0, duration: 0.5, ease: "power3.out" }, T);
```

Catalog's own hard ordering rule: *"position new scene → animate outgoing → swap → animate incoming → clean up overlays."*

### 4.4 Shader transitions

Provided by the **`@hyperframes/shader-transitions`** package (*"import from the package instead of writing raw GLSL"*). API surface as shown:

```js
var tl = HyperShader.init({
  bgColor: "#000",
  accentColor: "#6366f1",
  scenes: ["s1", "s2", "s3", "s4"],
  transitions: [
    { time: 4.0, shader: "sdf-iris", duration: 0.7 },  // WebGL shader
    { time: 8.5, duration: 0.8 },                      // no shader → CSS crossfade
    { time: 13.0, shader: "domain-warp", duration: 0.6 },
  ],
});
```

Let `HyperShader` create the timeline (don't pass `timeline:` into `init()`); add beat animations to the returned `tl` after the call. Mixing shader and CSS transitions in one composition is supported.

Shader-compatible CSS rules (they capture DOM to WebGL textures via html2canvas): no `transparent` keyword in gradients (use target color at zero alpha) · no gradient backgrounds on elements thinner than 4px · no CSS `var()` on elements visible during capture · mark uncapturable decoratives `data-no-capture` · no gradient opacity below 0.15 · every `.scene` div needs an explicit `background-color` **matching** the `bgColor` passed to `init()`.

Also relevant from core: a full-screen fill on the composition **root** is dropped on the layered-composite path (HDR content, or any composition using shader transitions) — put the fill on a full-bleed **child** (`position:absolute; inset:0`).

Blanket warning: *"Avoid transitions that create visible repeating geometric patterns ... Organic noise (FBM, domain warping) is good because it's irregular. Geometric repetition is bad because the eye instantly sees the grid."*

---

## 5. Audio model

> **CORRECTION (verified by measurement, 2026-08-28).** `astats`'s `reset` parameter is a
> **frame count, not seconds** — `-h filter=astats` says "number of frames". A value like
> `reset=0.4` truncates to `0`, which means *never reset*, so the filter reports a single
> running cumulative figure that looks like a level trace and is not one. For a windowed
> RMS curve, set the frame size explicitly first:
> `asetnsamples=n=1600,astats=metadata=1:reset=1` (1600 samples @48kHz ≈ 33ms per frame).

> **CORRECTION (verified by measurement, 2026-08-28).** The `sidechaincompress` threshold
> numbers previously given here are **not portable** — the threshold gates on the *key*
> signal's level, so one fixed value behaves completely differently on a quiet versus a
> loud voice. Measured against a key whose speech RMS was −22.4 dBFS: `threshold=0.1`
> produced a 1.3 dB duck, `threshold=0.05` produced 6.3 dB. A hardcoded `0.03` would be a
> ~10 dB hole on a quiet voice and do nothing on a loud one. **Measure the dialogue's RMS
> first, then set `threshold` ≈ 4 dB below it.** See the
> `talking-head-editor` skill's `sound-design-pass.md` for the measured sweep table.
>
> Also measured: `afade`/`acrossfade`'s default `curve=tri` dips **3.97 dB** at a join on
> uncorrelated material, not the ~3 dB stated below. Use `curve=qsin` (equal-power,
> measured 1.07 dB) for any join you do not want to hear.


### 5.1 Where audio lives

Audio is `<audio>` (or an unmuted `<video>` declaring `data-has-audio="true"`) placed as a clip like any other, with `data-start` / `data-duration` / `data-media-start` in seconds. Conventions:

- **Videos use `muted` with a separate `<audio>` element for the audio track** (`CLAUDE.md` key rule 4). The recipes note this is *"the pattern to reach for when picture and sound are cut independently"* — an unmuted `<video data-has-audio="true">` is also mixed, so a separate track is *"a choice, not a requirement."*
- **Every `<audio>` needs an `id`.** No id → never mixed → **silent render**.
- Audio sits on a track index well above visuals (`10+`) so the linter's overlap rules stay clear.
- In modular projects, **audio lives at the host root** so playback survives scene cuts.
- `<video>`/`<audio>` are found by a flat document query and seek/decode at **any nesting depth**, including inside a sub-comp `<template>`. The one hard limit is `video_nested_in_timed_element`.

### 5.2 Gain and fades — three mechanisms, one precedence order

| Mechanism | What it is | Notes |
|---|---|---|
| `data-volume` | static gain, default `1` (0 dB), max `3.98` (+12 dB) | Studio's fader writes this |
| `data-automation` lane `target: "volume"` | breakpoint envelope, `t` in **clip-local seconds**, `v` in 0..1 | the modern way to fade/duck |
| GSAP tween on `volume` | timeline tween | **absolute** — replaces `data-volume` entirely |

Precedence and its two lint rules: `audio_volume_double_automation` — a `volume` lane **and** a GSAP `volume` tween on one track: *"the lane wins and the tween is ignored."* `audio_volume_tween_overrides_gain` — an authored `data-volume` on a track whose `volume` is tweened: *"the tween's values are absolute and replace that gain instead of scaling it."*

Automation lane semantics (`hyperframes-audio/references/attributes.md`):

```json
{ "version": 1, "lanes": [
  { "target": "volume", "points": [ {"t":0,"v":1}, {"t":2.5,"v":0.4} ] },
  { "target": "fx.n2.gain", "points": [ {"t":0,"v":0}, {"t":1,"v":-6,"curve":0.4} ] }
]}
```

- `target` = `volume`, or `fx.<nodeId>.<param>`.
- `t` = **seconds from the start of the clip**, not the composition. A bed at `data-start="8"` has `t: 0` at composition time 8. **On an `<hf-audio-group>` bus, `t` is COMPOSITION time** — a bus has no `data-start`.
- `v` is in the parameter's own unit: dB for a gain, Hz for a frequency, 0..1 for volume.
- **A lane holds its first value backwards to the start of its clip and its last value forward to the end.** *"So a bed that begins before the voice needs an explicit 'no cut' point at `t: 0`, or it starts out already ducked."*
- `curve` (−1..1) bends the segment **leaving** a point. `viaX`/`viaY` name an interior point and supersede `curve`.
- **512 points per lane, maximum.**
- A lane whose node is gone is **pruned on read**, not an error — *"a typo'd `nodeId` costs you the envelope silently."*
- **A lane on a non-automatable parameter is silently inert.**

Copyable fade/duck envelope from `creator-editing-recipes.md` (fade-in 0–1, duck down 2–2.2, hold to 3, up by 3.2, fade-out 4–5):

```html
<audio id="music-bed" src="music.wav" data-start="0" data-duration="5" data-track-index="10"
  data-automation='{"version":1,"lanes":[{"target":"volume","points":[
    {"t":0,"v":0},{"t":1,"v":1},{"t":2,"v":1},{"t":2.2,"v":0.3},
    {"t":3,"v":0.3},{"t":3.2,"v":1},{"t":4,"v":1},{"t":5,"v":0}]}]}'></audio>
```

### 5.3 Ducking — three routes, ranked

1. **Voiceover carve (the intended answer for music-under-voice).** Not a duck: *"The reflex is to duck the whole bed, which works and costs the bed all of its presence... Carve takes only those [bands the voice occupies], and the bed keeps its low end and its top."*

   ```html
   <audio id="vo-intro"  data-audio-group="voiceover" …></audio>
   <audio id="vo-middle" data-audio-group="voiceover" …></audio>
   <audio id="music"
     data-fx-carve='{"enabled":true,"sources":["voiceover"],"strength":0.25}' …></audio>
   ```

   Invariants: settings live on the **bed**, never on a voice (*"A voice carved against itself is a bug"*). `sources` is a **list**. **Carve against a group, not a list of clip ids** — `audio_carve_ungrouped_sources`. Keep the carve group voices only: a bed or an SFX clip inside the named group poisons the **next** re-analysis silently. `data-fx-carve` is **clip-only**, never on a bus (`audio_group_carve_attr`).

   `strength` is 0..1 and derives everything (cut depth, band count, width, intelligibility bias, level drop, target headroom). **Default `0.25`** = *"a 6 dB dip in three bands with 6 dB of level room, audible without sounding like a hole."* At `0.5` the dip reaches 10 dB — *"where a carve starts being heard as an effect rather than as room for the voice."* `0` is spectral only. There is **no static mode** and no `dynamic` field: *"every carve follows the speech now."* A stored `dynamic` is ignored.

   Level matching is part of it — the carve also writes a `gain` stage, envelope-driven, releasing slowly on purpose.

   Headless invocation: `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`. Flags: `--bed` / `--voice` (repeatable), `--strength`, `--dry-run`. Needs **`ffmpeg` on PATH** and `@hyperframes/core` installed (`npm i -D @hyperframes/core`). It *"refuses when it cannot tell which track is the bed."* Nodes it writes are tagged `fromCarve` — a re-run replaces exactly those and leaves hand-built effects and hand-drawn lanes alone. **Never set `fromCarve` by hand** — the next carve deletes it.

   *"Carve by default. A bed playing under narration wants a carve... Skip it only when there is no narration for the music to sit under."*

2. **A `volume` automation lane** — the plain duck. Use when there is no voice to analyse, or the duck is a design gesture rather than intelligibility.

3. **Generated GSAP volume keyframes** — `media-use/scripts/audio-duck.mjs`:

   ```bash
   node <SKILL_DIR>/scripts/audio-duck.mjs --meta audio_meta.json --target "#bgm" --composition index.html
   ```

   ```js
   // auto-duck: #bgm under narration (generated; base volume 0.6)
   tl.to("#bgm", { volume: 0.15, duration: 0.15 }, 3.42);
   tl.to("#bgm", { volume: 0.6, duration: 0.4 }, 9.87);
   ```

   Beware: a `volume` tween is absolute and beats `data-volume`, and loses to a `volume` lane.

4. **Baked sidechain (export only)** — `ffmpeg … sidechaincompress=threshold=0.03:ratio=8:attack=200:release=400`. *"Bake only for assets leaving the hyperframes pipeline."*

### 5.4 The submix bus — `<hf-audio-group>`

Membership alone (`data-audio-group`) is enough to *carve against*. Adding the element makes it a real bus: *"one chain, one fader, one automation clock for every member."*

```html
<hf-audio-group id="voiceover" data-label="Voiceover" data-volume="0.9"
  data-fx-chain='{"version":1,"nodes":[
    {"type":"compressor","id":"g1","params":{"threshold":-18,"ratio":3}},
    {"type":"peaking","id":"g2","params":{"frequency":3000,"gain":2,"q":1}}]}'></hf-audio-group>
```

Reach for it when the same treatment belongs on several tracks — *"a compressor cannot ride a sequence it only hears a third of."* Per-clip chains stay right for genuinely per-clip problems. **One clip is not a bus** — except for one reason: a bus's automation clock is composition time, so a single-member bus is how a lane on that clip gets composition-time timing.

### 5.5 The FX chain

```json
{ "version": 1, "nodes": [
  { "type": "highpass", "id": "n1", "label": "Remove Rumble",
    "params": { "frequency": 120, "q": 0.707, "poles": "2" } },
  { "type": "peaking", "id": "n2", "fromCarve": true,
    "params": { "frequency": 1600, "gain": -6, "q": 1.4 } },
  { "type": "limiter", "id": "n3", "enabled": false,
    "params": { "limit": -1, "attack": 5, "release": 50, "level_out": 0 } }
]}
```

- **Order is signal order.** Each node processes what the previous produced.
- `params` are in human units (dB, ms, Hz); **out-of-range values are clamped on read**, so anything that parses is safe to realise.
- `id` is a stable handle — automation addresses nodes **by id, never by position**. A node with no id loads but cannot be automated. Studio hands out `n1`, `n2`, …
- `label` replaces the effect's display name. Write one whenever the node does a named job.
- `enabled: false` is bypass (node stays in chain, out of signal path).
- `fromCarve: true` is carve-owned. Do not write it by hand.

Chain order doctrine: *"Subtract before you add, level after you filter, relationships after level, character and ceiling last."* Corrective filtering early, character middle, **limiter last** where it can act as a ceiling.

### 5.6 FX registry (generated from `HF_AUDIO_FX` in `@hyperframes/core/audio-fx`)

Format: `param` min–max unit (default) — **AUTO** marks an automatable parameter.

**Filter — which frequencies a track may occupy**

| Effect | Parameters |
|---|---|
| `highpass` | `frequency` 20–20000 Hz (300, log) **AUTO** · `q` 0.1–20 (0.707, log) **AUTO** · `poles` `1`\|`2` (2) |
| `lowpass` | `frequency` 100–20000 Hz (8000, log) **AUTO** · `q` 0.1–20 (0.707, log) **AUTO** · `poles` `1`\|`2` (2) |
| `peaking` | `frequency` 20–20000 Hz (1000, log) **AUTO** · `gain` −40–40 dB (0) **AUTO** · `q` 0.1–20 (1, log) **AUTO** |
| `lowshelf` | `frequency` 20–2000 Hz (200, log) **AUTO** · `gain` −40–40 dB (0) **AUTO** |
| `highshelf` | `frequency` 500–20000 Hz (4000, log) **AUTO** · `gain` −40–40 dB (0) **AUTO** |

`q` is bandwidth (higher = narrower). `poles`: `2` = usual biquad (12 dB/oct), `1` = gentler (6 dB/oct). Shelving filters have no `q`.

**Dynamics — how level behaves over time**

| Effect | Parameters |
|---|---|
| `gain` | `gain` −60–12 dB (0) **AUTO** |
| `compressor` | `threshold` −60–0 dB (−24) · `ratio` 1–20 (4) · `attack` 0.01–2000 ms (20, log) · `release` 0.01–9000 ms (250, log) · `knee` 1–8 (2.83) · `makeup` 0–36 dB (0) · `mix` 0–1 (1) |
| `limiter` | `limit` −24–0 dB (−1) · `attack` 0.1–80 ms (5) · `release` 1–8000 ms (50, log) · `level_out` −24–24 dB (0) |
| `gate` | `threshold` −80–0 dB (−35) · `range` −80–0 dB (−24) · `ratio` 1–20 (10) · `attack` 0.01–9000 ms (1, log) · `release` 0.01–9000 ms (100, log) · `knee` 1–8 (2.83) |

**Nonlinear — changes the waveform's shape**

| Effect | Parameters |
|---|---|
| `saturate` | `type` `tanh`\|`atan`\|`cubic`\|`exp`\|`alg`\|`quintic`\|`sin`\|`erf`\|`hard` (tanh) · `threshold` −40–0 dB (−6) · `output` −24–24 dB (0) **AUTO** · `oversample` 1–8× (4) |
| `bitcrush` | `bits` 1–32 (8) · `samples` 1–250× (1) · `mix` 0–1 (1) |

**Time — space and width**

| Effect | Parameters |
|---|---|
| `delay` | `time` 1–5000 ms (250, log) **AUTO** · `feedback` 0.01–0.95 (0.35) **AUTO** · `mix` 0–1 (0.4) **AUTO** |
| `reverb` | `size` 0.05–1 (0.7) · `damping` 0–1 (0.5) · `wet` 0–1 (0.35) **AUTO** · `dry` 0–1 (0.7) **AUTO** |
| `chorus` | `delay` 1–100 ms (7) **AUTO** · `depth` 0–10 ms (2) **AUTO** · `speed` 0.01–10 Hz (1) **AUTO** · `mix` 0–1 (0.5) **AUTO** |
| `phaser` | `in_gain` 0–1 (0.4) **AUTO** · `out_gain` 0–2 (0.74) **AUTO** · `delay` 0.1–5 ms (3) · `decay` 0–0.99 (0.4) · `speed` 0.1–2 Hz (0.5) **AUTO** · `type` `0`\|`1` (0) |

Reverb convolves a **generated** impulse — preview and render generate the same one, so a room is reproducible without shipping an impulse file.

**Why some parameters cannot be automated:** automation is native `AudioParam` scheduling. **`compressor`, `limiter`, `gate` and `bitcrush` are AudioWorklets configured wholesale — none of their parameters are automatable at all.** `saturate`'s `type`/`threshold`/`oversample` rebuild a WaveShaper curve; only `output` is a real param. `reverb`'s `size`/`damping` regenerate the impulse; `wet`/`dry` automate fine. **Workaround:** *"automate a `gain` stage around it instead."*

### 5.7 Presets, jobs, one-knob profiles

Presets write ordinary nodes tagged `fromPreset`; applying one **appends**; re-applying replaces its own nodes in place.

- **Voice:** `voice-clean` (Remove Rumble → Reduce Mud → Even Out Loudness → Add Clarity → Peak Ceiling — *"the default answer to 'fix this voiceover'"*) · `voice-broadcast` (adds Reduce Boxiness, Add Air, Warmth) · `voice-warm` (Add Weight instead of cutting)
- **Repair:** `rumble-cut`, `room-gate` (*"Does not remove noise — room tone under speech stays"*), `boom-tame`, `harsh-tame`
- **Character:** `telephone`, `radio-am`, `megaphone`, `lofi-tape`, `pa-system`, `intercom`, `doofus-worble` — *"These are costumes... Do not stack two."*
- **Space:** `room-tight`, `room-natural`, `hall`, `slap-echo`, `dub-throw`

A preset's nodes are wrapped in a wet/dry blend: `presetAmount` (0..1) fades the whole thing, and **`fx.preset.<id>`** is an automation target. *"This is the only way to automate a preset as a unit."*

**Jobs** — five named `peaking` filters with the frequency pre-chosen. Carry the name in `label`.

| Job | Symptom | Sets |
|---|---|---|
| Tame Boominess | Too much chest — it booms | 200 Hz, −4 dB, Q 1.4 |
| Reduce Mud | Muffled, like behind cardboard | 250 Hz, −3 dB, Q 1.2 |
| Reduce Boxiness | Sounds like a small room, or a box | 400 Hz, −3 dB, Q 1.4 |
| Add Clarity | Words are hard to make out | 3 kHz, +2.5 dB, Q 1 |
| Soften Harshness | Harsh and tiring to listen to | 3.2 kHz, −3 dB, Q 1.6 |

**Double-application trap:** *"`voice-clean` plus a Reduce Mud job is −6 dB at 250 Hz where −3 was meant."* Check what a preset already contains.

**One-knob profiles** (0..1, derived): `compressor` → **Evenness** (threshold, ratio, attack, release, makeup) · `gate` → **Tightness** (threshold, range, release) · `saturate` → **Warmth** (threshold, output) · `reverb` → **Space** (size, wet, dry) · `bitcrush` → **Crush** (bits, samples, mix). Evenness, Warmth and Space are **level-matched**; Tightness and Crush are not. The chain stores the mechanism values; the knob is read back by inverting the curve.

**Band vocabulary** (the names the rack shows): 20–80 Hz Rumble · 80–250 Hz Weight · 250–600 Hz Mud · 600–2000 Hz Middle · 2000–5000 Hz Presence · 5000–10000 Hz Edge · 10000–20000 Hz Air.

**Measured, not fixed-chain:** voiceover carve, and **Even Out Levels** (`levellingResult`) — measures the track's own speaking windows and writes a gain envelope targeting *"the 80th percentile of that track, not an absolute level, so an already-even track is left alone."*

### 5.8 Placing an Epidemic-fetched file on the timeline

**The full Epidemic Sound tool surface — all sixteen tools, their real parameters, the six filter facets and the async edit and voiceover pipelines — is §5A.** This section covers only what happens *after* a file exists.

Epidemic Sound MCP (`SearchSoundEffects` / `DownloadSoundEffect`, `SearchRecordings` / `DownloadRecording`, `GenerateVoiceover` / `DownloadVoiceover`, and the `Similar*` searches) sits exactly where `media-use resolve --type sfx|bgm|voice` sits: **it produces a local file and stops.** Everything after is HyperFrames.

The handoff, step by step:

1. **Fetch** — download to a project-local path (convention from `media-use`: assets under `.media/audio/{voice,bgm,sfx}` or `assets/`). Keep the file inside the project so the compiler and render can reach it.
2. **Optionally register it** so it lands in the ledger and global cache like any other asset: `node <SKILL_DIR>/scripts/resolve.mjs --from <downloaded file> --type sfx --project .`
3. **Place it as a clip.** `data-start` = composition seconds where the hit lands. `data-duration` may be omitted for media (defaults to media duration when known) but author it when you want a hard out. `data-media-start` trims into the source without touching the file. **Give it an `id`.** Put it on a high `data-track-index` (10+).
4. **Set gain.** `data-volume` for a static level (default `1` = 0 dB, max `3.98` = +12 dB). For anything that moves, use a `data-automation` `volume` lane with clip-local `t` — remembering the lane **holds its first value backwards** to the clip start.
5. **Relate it to the voice.** If it is a music bed under narration: put the narration clips in `data-audio-group="voiceover"`, then carve the bed with `data-fx-carve` against the **group**, and run `carve.mjs`. If it is an SFX hit, give it its own group (`sfx`) — never the voice group.
6. **Treat it if needed** with a `data-fx-chain` (limiter last).
7. **Verify by rendering and listening** — see §5.9.

A one-shot SFX example in the real shape (a whoosh at a scene break at t=4.0s, trimmed 0.12s into the file, −6 dB-ish, fading its tail):

```html
<audio id="sfx-whoosh"
       src="assets/sfx/whoosh.wav"
       data-audio-group="sfx"
       data-start="4"
       data-duration="0.8"
       data-media-start="0.12"
       data-track-index="12"
       data-volume="0.5"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.6,&quot;v&quot;:1},{&quot;t&quot;:0.8,&quot;v&quot;:0}]}]}"></audio>
```

Note: `data-volume="0.5"` is the baseline **and** the lane's `v` is 0..1 volume — per the attribute docs, a lane on `volume` is the track's own level; do not also GSAP-tween `volume` on this element (`audio_volume_double_automation`).

**A music bed under narration, the canonical arrangement:**

```html
<audio id="vo-1" src=".media/audio/voice/line-01.wav" data-audio-group="voiceover"
       data-start="0.5" data-track-index="10"></audio>
<audio id="vo-2" src=".media/audio/voice/line-02.wav" data-audio-group="voiceover"
       data-start="6.2" data-track-index="10"></audio>

<audio id="music-bed" src=".media/audio/bgm/bed.mp3"
       data-audio-group="music"
       data-start="0" data-duration="30" data-track-index="11" data-volume="0.6"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```

then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`, which prints what it decided (bed, voice, strength, bands, level envelope) and writes the `fromCarve` peaking nodes + `gain` stage + lanes onto `#music-bed`.

**Timing an SFX to a visual event.** There is no audio-follows-animation attribute. The two are coupled by the author writing the same number twice: the tween's timeline position and the `<audio data-start>`. If the visual event lives in a **sub-comp** at scene-local `t`, the audio at the root needs `data-start = t + slot data-start`. Relative timing (`data-start="el-intro + 0.2"`) can express the second half of that, with the four silent-zero failure modes from §2 in force.

### 5.9 Verification

*"Almost no static gate covers the mix."* The linter reads `data-automation` for exactly two conflicts (`audio_volume_double_automation`, `audio_volume_tween_overrides_gain`), plus the two carve-arrangement rules. **Nothing validates the chain or the effect lanes at all.**

Asymmetry by design: *"a chain it cannot parse fails the whole mix rather than quietly writing the dry signal"* on **render**; **preview** plays an unreadable chain **dry** so the composition stays workable.

Effects with a tail (`reverb`, `delay`) make the rendered track **longer** than its source — the mix is told how much via `chainTailSeconds`. *"So a bed with reverb no longer ends exactly at its `data-duration`; that is expected, not a bug."*

Carve failure mode with an obvious sound: *"If the bed sounds notched rather than simply quieter under the voice, the strength is too high."*

**Diagnosis rule worth carrying into every note:** *"The absolute spectrum of a single unknown voice cannot be diagnosed."* Compare against something **inside the same file** — the clean original, or the pauses. `references/diagnosis.md` holds the commands and is **not staged**.

---

## 5A. The Epidemic Sound MCP surface

§5.8 shows where an Epidemic-fetched file lands on the timeline. It does not say how to obtain one, because the document that preceded this section was assembled from the staged HyperFrames files only, and the Epidemic surface is not in them. That gap made every correct note citing `EditRecording`, `PollEditRecordingJob` or `DownloadRecordingEdit` look like an invention. **It was not. This section documents the surface properly.**

**Provenance and confidence.** Everything in §5A.1–§5A.7 is read **directly off the live MCP tool schemas in this environment** — parameter names, nesting, required fields, enum members and return-type fields are quoted from them, not inferred. Where the schema does not state something, §5A.8 says so instead of guessing. The filter-facet observations come from `visual-kt-delta.md`, which read them off screen recordings in the reference videos.

Where this sits in the stack: exactly where `media-use resolve --type sfx|bgm|voice` sits, per §1. **Epidemic sources and stops at a URL.** Placement, gain, timing and ducking are pure HyperFrames — §5.8 owns the handoff.

### 5A.1 The sixteen tools

| Tool | What it does | Reach for it when |
|---|---|---|
| `SearchSoundEffects` | Search the **sound effects** catalogue by term, tag slugs and duration | You want a discrete event: a whoosh, an impact, a click, a riser |
| `DownloadSoundEffect` | Resolve a sound effect id to a downloadable `assetUrl` | You have picked one and need the file |
| `SearchSimilarToSoundEffect` | Neighbours of a known sound effect | You have one whoosh that works and need the rest of the video's whooshes to match it |
| `SearchRecordings` | Search the **music/recordings** catalogue — the six-facet surface | You want a bed, a track, a musical cue |
| `DownloadRecording` | Resolve a recording id (and a stem) to an `assetUrl` | You have picked a track |
| `SearchSimilarToRecording` | Neighbours of a known recording | The chosen bed is right and you need alternates or a second cue in the same world |
| `EditRecording` | **Async.** Submit a job to produce cut-down versions of a recording at a target duration | A 3-minute track has to become a 45-second bed that still ends musically |
| `PollEditRecordingJob` | Poll that job until `COMPLETED` | Always, after `EditRecording` — see §5A.5 |
| `DownloadRecordingEdit` | Resolve a completed edit to an `assetUrl` | After the poll returns `COMPLETED` |
| `GenerateVoiceover` | **Async.** Submit a TTS job | The design calls for narration you do not have a recording of |
| `PollVoiceoverGenerationStatus` | Poll the voiceover until `DONE` | Always, after `GenerateVoiceover` |
| `GetVoiceover` | Fetch the voiceover's metadata — including **`durationMs`** and a preview URL | Before writing `data-duration`; also to audition |
| `DownloadVoiceover` | Resolve the voiceover to a high-quality `assetUrl` | Once you are keeping it |
| `ListVoices` | The voice-artist catalogue, with gender/location/biography/characteristics | Choosing a voice; discovering which `languageCode` values are supported |
| `ListUserGeneratedVoices` | Custom/cloned voices on the account | The project has a house voice |
| `SearchExternalReferences` | Turn a free-text query (e.g. an artist name) into external IDs — currently **Spotify track IDs only** | Seeding a search from a reference track that is *not* in the Epidemic catalogue |

**Every download tool returns a URL, not a file.** The result field is `assetUrl` (`DownloadVoiceover` documents it as *"The URL to download the voiceover"*). Fetching it to disk is a separate step, and §5.8 step 1's rule applies: put it inside the project so the compiler and render can reach it.

### 5A.2 Sound effects versus recordings — the split that governs everything

These are **two different catalogues with two different filter surfaces**, and picking the wrong one is the most common way a fetch recipe fails.

| | Sound effects | Recordings (music) |
|---|---|---|
| Search | `SearchSoundEffects` | `SearchRecordings` |
| Download | `DownloadSoundEffect` | `DownloadRecording` |
| Similarity | `SearchSimilarToSoundEffect` | `SearchSimilarToRecording` |
| Query forms | `query.term` only | `query.term` **or** `query.topic` **or** `query.externalID` — *"Specify exactly one"* |
| Filters available | `tagSlugs`, `duration`, `soundEffectIDs` | `bpm`, `duration`, `moodSlugs`, `taxonomySlugs`, `musicalKeys`, `vocals`, `featuredInstrumentSlugs`, `artistSlugs`, `tagSlugs`, `recordingIDs` |
| Sort keys | `RELEVANCE POPULARITY DATE DURATION TITLE` | the same **plus `BPM`** |
| Result carries | `id`, `title`, `audioFile{durationInMilliseconds, lqmp3Url, waveformUrl}`, `tags[]{id, displayName, slug}` | `id`, `title`, **`bpm`**, `coverArtUrl`, `audioFile{…}`, `stems[]`, `tags[]{displayName, dimension{name}}`, `credits[]` |
| Stems | none | `DRUMS BASS MELODY INSTRUMENTS CLEAN_VOCALS VOCALS` |

**The sound-effects surface has no BPM, no mood, no genre and no key.** Only `tagSlugs` and `duration`. So the six facets described below are the **recordings** surface, and a note that tries to filter a whoosh by mood is writing a spec that cannot execute.

**Two verified gotchas on this table:**

- **`DownloadRecording.options.stemType` is required**, and its enum is **narrower than the search result's**: download accepts only `FULL | BASS | DRUMS | INSTRUMENTS`, while a search result may advertise a `MELODY`, `CLEAN_VOCALS` or `VOCALS` stem. You can *see* stems you cannot fetch through this parameter. For a normal full-track fetch, pass `stemType: FULL` — omitting it fails the call.
- **Recording tags carry no `slug`.** `SoundEffect`'s `Tag` is `{id, displayName, slug}`; `Recording`'s `Tag` is `{displayName, dimension{name}}`. So you **cannot round-trip a recording's tag straight back into `tagSlugs`** — you get a display name and its taxonomy dimension, and the slug has to be inferred or discovered. See §5A.8.

### 5A.3 The six facets, mapped to real parameters

`visual-kt-delta.md` records the Epidemic web UI's filter bar, read directly off `editing kt 3`:

```
Moods | Genres | Duration | BPM | Vocals | Key
```

with the Vocals facet expanded showing `Vocals 291` / `Instrumentals 2529`, and `editing kt` independently showing a results list with a **BPM column** (91, 114, 90, 120, 80). **Queries in this library are expressed against these facets, not as free text alone.** The creator's own workflow is: mood or term in the query box, then narrow by BPM and Vocals.

Each facet maps onto a real `SearchRecordings.filter` field:

| UI facet | Parameter | Shape |
|---|---|---|
| **Moods** | `filter.moodSlugs` | `{ matchType: ALL\|ANY\|NOT_ANY, values: [slug] }` |
| **Genres** | `filter.taxonomySlugs` | same shape. The schema notes this dimension also carries **Decade** (`1980s`, `2000s`, `2010s`) and **World Country** (`cuba`, `france`, `african-continent`, `australia`) alongside genre (`rock`, `pop`, `jazz`) |
| **Duration** | `filter.duration` | `{ min, max }` — **milliseconds** |
| **BPM** | `filter.bpm` | `{ min, max }` — integers |
| **Vocals** | `filter.vocals` | **boolean.** `true` = the Vocals side, `false` = Instrumentals |
| **Key** | `filter.musicalKeys` | `[slug]` — a plain array, **not** a matchType object. Schema examples: `c-minor`, `d-major`, `a-major` |

**The `vocals` boolean is the single most important one for this library.** `visual-kt-delta.md` is explicit: the vocals/instrumental decision is *a filter, not a judgement call*. Any bed sitting under narration is `vocals: false`, always, and a fetch recipe that omits it is relying on luck.

**A seventh filter the UI did not show, and it is a good one:** `filter.featuredInstrumentSlugs` (`{matchType, values}`, schema examples `acoustic-guitar`, `accordion`, `electronic-drums`). This is the direct API expression of the reference set's own `Instruments` card with its `Suspense/Tension` sub-label — tying an instrument to an emotion. It is available and under-used.

**`matchType` semantics:** `ALL` = every value must match, `ANY` = at least one, `NOT_ANY` = exclusion. `NOT_ANY` is the honest way to write "not that" — e.g. excluding a genre the profile rejects — rather than filtering the results afterwards.

**Pagination.** Searches are cursor-based: pass `first` for page size, read `pageInfo.endCursor`, pass it back as `after`. `meta.total` gives the result count. The voice lists are **offset-based instead** (`limit`/`offset`, with `pageInfo.hasMoreItems`). Do not carry a cursor into `ListVoices`.

### 5A.4 Similarity search — the identity tool

**This is the single most under-used capability on the surface, and it deserves more than a line.**

`SearchSimilarToSoundEffect(id, first?, after?)` and `SearchSimilarToRecording(id, first?, after?)` each take **one asset id** and return its neighbours in the catalogue.

The point is not convenience. It is **coherence**. A style profile's sound palette is not a list of individual sounds; it is a *family* — a tonal character that makes every transition in a video sound like it came from the same place. Free-text search cannot deliver that. Two searches for "whoosh transition" run twenty minutes apart return two different neighbourhoods of a very large catalogue, and a video assembled from them sounds assembled. Similarity search returns **the same neighbourhood, deliberately**.

**The anchor-and-family workflow**, and where it sits in `pipeline.md`:

1. **PROFILE** — find *one* asset that matches the style profile's palette. This is the expensive, judgement-heavy step, and it happens once. Record its **UUID** in `PROFILE.md`. That UUID is now part of the profile — it is the most compact possible statement of "this creator's transition sound".
2. **DESIGN** — `design-sound.md` rows name the anchor id rather than re-describing the sound in words. A row that says *"whoosh, similar-to `<anchor-uuid>`"* is executable; a row that says *"a punchy whoosh"* is a re-litigation of the palette on every fetch.
3. **HANDOFF** — the fetch step calls `SearchSimilarToSoundEffect` once against the anchor with a `first` large enough to cover the video's needs, and assigns from that pool. One call, one coherent family, every transition in the video.

The same shape works for music: one bed establishes the world, `SearchSimilarToRecording` supplies the second cue, the sting and the outro so they belong to it. Combined with §5A.5's edit pipeline, a single anchor recording can supply a 45-second bed for one section and a 20-second variant for another that still sounds like the same piece.

**Its one real limit:** similarity takes a **UUID**, so it only works on an asset already found *in the catalogue*. There is no "similar to this local file". The closest thing to seeding from outside is `SearchExternalReferences(term)` → a `SPOTIFY_TRACK` id → `SearchRecordings(query.externalID: {type: SPOTIFY_TRACK, id})`, which the schema describes as the way to *"find similar sounding music"* to something outside Epidemic. That path is **Spotify-only** — `RecordingExternalReferenceIDType` has exactly one member — and it has no sound-effects equivalent.

### 5A.5 The edit pipeline is asynchronous — three calls, not one

**`EditRecording` does not return audio. It returns a job.** A note that treats it as synchronous will look for an `assetUrl` that is not there, and a loop written around that assumption will hang. This is the shape:

```
1. EditRecording(id: <recordingId>, input: {...})
      -> RecordingEditJob { id: <jobId>, status: PENDING }

2. PollEditRecordingJob(id: <jobId>)                     <- the JOB id, not the recording id
      -> { id, status: PENDING | IN_PROGRESS | COMPLETED | FAILED, edit: {...} }
      repeat until COMPLETED or FAILED

3. DownloadRecordingEdit(input: { jobId: <jobId>, editId: <editId> })
      -> { assetUrl }
```

**Step 3 needs both ids.** Unlike every other download on this surface, `DownloadRecordingEdit` takes no top-level `id` — it takes `input: {jobId, editId}`, and **both are required**. That is because one job can produce several candidate edits (`input.maxResults`), each with its own `editId`.

**`EditRecording.input` — verified fields:**

| Field | Required | Meaning |
|---|---|---|
| `targetDurationMs` | **yes** | Target length in ms. Schema states **maximum 300000ms** — five minutes is the hard ceiling |
| `downloadAudioFormat` | **yes** | `MP3` or `WAV` |
| `forceDuration` | no | *"Whether to force the exact duration specified in targetDurationMs"* |
| `loopable` | no | *"Whether the outputs should be loopable — i.e., seamless when repeated"* |
| `maxResults` | no | *"Maximum number of track edits to return"* |
| `skipStems` | no | *"Whether to skip generating individual stems, useful for faster creating edits"* — the speed lever |
| `preferenceRegions` | no | `[{ startMs, endMs, preferenceType: PREFER \| AVOID }]` — steer the edit toward or away from regions of the original |
| `requiredRegionsAtOffsets` | no | `[{ startMs, endMs, offsetMsInEdit }]` — **pin a region of the original to a specific offset in the output** |

**`requiredRegionsAtOffsets` is the one worth knowing about.** It is how a musical event gets aligned to a picture event: take the drop at 1:12 in the source and require it at 8000ms in the edit, and the bed is now cut to the picture rather than the picture cut to the bed. That is the API doing by hand what §5.8 says nothing else does — there is no audio-follows-animation attribute anywhere in HyperFrames, so alignment is authored, and this is the authoring tool for the music side.

**Practical rules for a note that uses this:**

- **Read `durationMs` back off the completed edit before writing `data-duration`.** Without `forceDuration: true`, `targetDurationMs` is a *target*. `RecordingEdit` carries a real `durationMs`; use that number, not the one you asked for.
- Set `forceDuration: true` when the bed sits under a locked picture section.
- Set `loopable: true` when the bed is shorter than the section it covers and will repeat.
- Set `skipStems: true` unless you actually want stems — it is documented as the faster path.
- A bed longer than **5 minutes cannot be produced this way.** Fall back to §7's file operations, or to `data-media-start` + `data-duration` on the full track (§5.8), which needs no edit job at all. **Check whether you need an edit before submitting one** — in-composition trimming is free and §1's boundary rule prefers it.

**`PollEditRecordingJob`'s completed payload is the one thing here I cannot fully pin down.** The exposed `RecordingEditJob` type documents a single `edit: RecordingEdit` field, populated when `status` is `COMPLETED` — and that field is **marked deprecated in the schema itself**, with the note *"Use 'edits' field instead to get all generated edits"*. The `edits` field is referenced but is **not present in the type as exposed here**. So: inspect the actual poll response before parsing it, and do not hard-code a path to the edit list on the strength of this document. `RecordingEdit` itself is stable and carries `{ id, fullMixPreviewUrl, durationMs }` — `id` is the `editId` step 3 needs.

### 5A.6 Voiceover generation

Also asynchronous, but with a **different shape from the edit pipeline** — and the difference matters:

```
1. GenerateVoiceover(input: { voiceId, text, languageCode?, speed? })
      -> VoiceoverGenerateStatus { id, status: GENERATING, failedReason }

2. PollVoiceoverGenerationStatus(id)
      -> { id, status: DONE | GENERATING | FAILED, failedReason }

3. GetVoiceover(id)      -> { text, speed, languageCode,
                              audio: { playbackUrl, durationMs },
                              waveform: { signedUrl } }

4. DownloadVoiceover(input: { id })  -> { assetUrl }
```

**There is no separate job id.** The `id` returned by `GenerateVoiceover` is the **voiceover's own id**, and the same id is used in all four calls. Contrast §5A.5, where the poll takes a job id and the download needs a job id *and* an edit id. Getting these two pipelines confused is an easy mistake and produces a not-found rather than a useful error.

**`GenerateVoiceover.input` — verified fields:**

| Field | Required | Notes |
|---|---|---|
| `voiceId` | **yes** | UUID from `ListVoices` or `ListUserGeneratedVoices` |
| `text` | **yes** | The text to speak |
| `languageCode` | no | `GetVoiceover` documents this as an **IETF BCP 47** code |
| `speed` | no | **Range −1 to 1, where `0.0` is the default speed** |

**`speed` is not a multiplier.** It is a −1..1 offset with 0 as normal. A note that writes `speed: 1.5` is out of range, and `speed: 1.0` is the *maximum*, not "normal". This is exactly the kind of parameter that reads plausibly and fails at runtime, so it is worth stating in any note that touches TTS.

**`GetVoiceover` before `DownloadVoiceover`, always.** `GetVoiceover` gives you `audio.durationMs` — the number §5.8 step 3 needs for `data-duration`, and the number the caption timing in §6.3 has to agree with. It also gives `playbackUrl` for auditioning and a `waveform.signedUrl`. `DownloadVoiceover` gives only the high-quality `assetUrl`.

**Choosing a voice.** `ListVoices(limit?, offset?)` returns `{ id, title, exampleAudioUrl, artwork, languageCode, languages[], metadata { gender, location, biography, characteristics } }`. `languages[]` is the field to check before assuming a language is supported. `ListUserGeneratedVoices` returns a thinner `{ id, title, languageCode }` for custom voices on the account.

**Cross-reference to the reference set.** `visual-kt-delta.md` records an ElevenLabs-style TTS panel visible in `editing kt 3` — voice `Benjamin`, a language selector, a speed control and a Create button. That is the same four inputs as `GenerateVoiceover`. AI voiceover is in the observed workflow; this is the in-project route to it, and per §9 it is the sanctioned one, since the HeyGen TTS path is a blocked network dependency.

**Hinglish caveat.** `visual-kt-delta.md` establishes that the house style is **romanised Hindi in a Latin face**, not Devanagari. Whether any voice on this account speaks Hindi, and what `languageCode` it wants, is **not determinable from the schema** — check `ListVoices`' `languages[]` before a note promises it. Note also that romanised Hindi fed to an English voice will be pronounced as English; that is a real failure mode, not a nuance.

### 5A.7 Worked queries against the six facets

Three examples, aimed at the asset classes this library actually fetches. Shown as parameter trees rather than invented call syntax.

**1. A transition whoosh** — sound-effects surface, so the six facets do **not** apply.

```
SearchSoundEffects
  query:  { term: "whoosh transition" }
  filter: { duration: { max: 1500 } }              # ms — a transition SFX is short by definition
  sort:   { by: RELEVANCE, order: DESCENDING }
  first:  20

  -> pick one, then:
DownloadSoundEffect
  id:      <soundEffectId>
  options: { fileType: WAV }                        # WAV for anything that will be processed

  -> then, for every other transition in the video:
SearchSimilarToSoundEffect
  id:    <the chosen soundEffectId>                 # the anchor from §5A.4
  first: 12
```

The `duration.max` is doing real work: it removes the long ambience beds that a term search for "whoosh" otherwise returns, without needing a mood filter the surface does not have.

**2. A tension riser** — available on **both** surfaces, and they are different tools.

As a discrete event, timed to a cut:

```
SearchSoundEffects
  query:  { term: "riser tension" }
  filter: { duration: { min: 2000, max: 8000 } }    # long enough to build, short enough to land
  sort:   { by: RELEVANCE, order: DESCENDING }
```

As a musical cue that has to sit in the mix:

```
SearchRecordings
  query:  { term: "tension" }
  filter: { moodSlugs: { matchType: ANY, values: ["suspense", "dark", "tense"] },
            vocals:    false,                        # a riser under narration is never vocal
            duration:  { min: 10000, max: 60000 } }
  sort:   { by: RELEVANCE, order: DESCENDING }
```

**The slug values above are illustrative and are not confirmed** — see §5A.8. Run the query with `term` alone first, read the returned `tags[].displayName` and `tags[].dimension.name`, and build the filter from what the catalogue actually says.

**3. An instrumental bed at a target BPM** — the canonical fetch for this library, and the one the reference set demonstrates.

```
SearchRecordings
  query:  { term: "chill lo-fi" }
  filter: { bpm:      { min: 86, max: 96 },          # target 91, +-5
            vocals:   false,                         # Instrumentals side of the facet
            duration: { min: 60000 },                # long enough to cover the section
            taxonomySlugs: { matchType: ANY, values: ["lo-fi", "chill"] } }
  sort:   { by: POPULARITY, order: DESCENDING }
  first:  20

  -> read `bpm` off each node, pick, then:
DownloadRecording
  id:      <recordingId>
  options: { fileType: WAV, stemType: FULL }         # stemType is REQUIRED
```

The `bpm` window is the point. `visual-kt-delta.md` records the BPM column visible in `editing kt`'s results list — 91, 114, 90, 120, 80 — which is what a real result set looks like when BPM is a column rather than a filter. Narrowing it before the results come back is the difference between choosing a bed and auditioning twenty. And if the video is cutting to the bed, §7A.7's cross-check applies in reverse: `Recording.bpm` is ground truth for librosa's tempo estimate, not the other way round.

If the chosen track is 3 minutes and the section is 45 seconds, **do not fetch and trim blindly** — decide between §5.8's free in-composition trim (`data-media-start` + `data-duration`) and §5A.5's `EditRecording`, which costs a job round-trip but ends musically instead of mid-phrase.

### 5A.8 What I do not know, stated plainly

A note author reading an invented parameter writes a spec that fails at runtime. These are the things the tool schemas in this environment **do not** tell me, and I have not guessed at any of them.

- **The slug vocabularies.** `moodSlugs`, `taxonomySlugs`, `tagSlugs`, `musicalKeys`, `featuredInstrumentSlugs` and `artistSlugs` all take slug strings, and **no enumeration endpoint is exposed on this surface.** The schema offers examples only — `c-minor` / `d-major` / `a-major`; `acoustic-guitar` / `accordion` / `electronic-drums`; `rock` / `pop` / `jazz`; `1980s` / `2000s` / `2010s`; `cuba` / `france` / `african-continent` / `australia`. Every slug used in a fetch recipe should be **discovered**, by running a term-only search and reading back `tags[].displayName` and `tags[].dimension.name`, and then recorded in the note. Do not copy slugs from the worked examples in §5A.7 as if they were verified.
- **How to turn a recording's tag back into a slug.** Recording tags expose `displayName` and `dimension.name` but **no `slug`** (§5A.2). The lower-casing/hyphenation convention is an obvious guess and it is still a guess.
- **The default and maximum page size.** `first` is an untyped integer with no stated default or cap.
- **Whether `assetUrl` expires.** Not stated. The voiceover waveform field is named `signedUrl`, which hints at time-limited URLs across this API. **Download promptly and do not store an `assetUrl` in a design document as if it were a stable address** — store the UUID, which is stable, and re-resolve.
- **Poll intervals and typical latency** for `PollEditRecordingJob` and `PollVoiceoverGenerationStatus`. Neither schema states a cadence or a timeout. Any note specifying a polling loop should say its interval is a chosen value, not a documented one, and must handle `FAILED` (both types carry a `failedReason` / terminal `FAILED` state) as well as success.
- **The completed shape of `PollEditRecordingJob`** — the `edit` / `edits` deprecation described in §5A.5.
- **Rate limits, quotas, and licensing or attribution obligations.** Nothing on this surface describes them. They exist as a matter of course for a commercial catalogue; this document simply does not know what they are.
- **Whether the download hosts are reachable from this environment.** §9's second constraint is an egress allowlist, and **no `assetUrl` was actually fetched while writing this section.** The MCP tools returning a URL is not proof that the URL can be retrieved from here. Test the fetch leg once before a build depends on it, and treat a failure as an allowlist question rather than a bad id.
- **`SearchRecordings.query.topic`** — a distinct field from `term`, with no description beyond *"Specify exactly one of term, topic or externalID"*. What it does differently is unknown.
- **Whether `EditRecording` preserves the source's BPM.** For a bed that a cut sequence is timed to, this matters; the schema does not say.

---

## 6. Caption / subtitle mechanics

### 6.1 There is no caption primitive

Critical for note authors: **HyperFrames has no `data-caption`, no SRT/VTT ingest attribute, and no built-in subtitle renderer.** A caption is an ordinary composition — usually a sub-composition — whose GSAP timeline writes `textContent` and animates a box. The staged `compositions/captions.html` is the working reference implementation, and it is entirely hand-authored.

The only caption-adjacent framework surfaces are:

- the layout audit's `--caption-zone` / `caption_zone_collision` check, and its opt-out `data-layout-allow-caption-zone` (element + descendants, via `closest`);
- the typography guardrail that caption fades belong to the gentle eases (`power1.out` / `power2.out`, *"NOT the entrance default"*).

Caption *authoring* pipelines live outside core: the `/embedded-captions` workflow (footage + captions, footage untouched), `media-use` → `audio/references/captions/` (**not staged**), and `npx hyperframes transcribe`.

### 6.2 What `compositions/captions.html` actually does

Anatomy, top to bottom:

1. **`<template id="captions-template">`** wrapping the root — the sub-composition form.
2. **Root:** `data-composition-id="captions"`, `data-width="1920"`, `data-height="1080"`, `data-duration="10"`.
3. **DOM:** three nested elements only — `.captions-container` → `#caption-box.caption-box` → `#caption-text.caption-text`. **One box, one span, reused for every line.** Nothing is created or destroyed.
4. **Scoped CSS inside the template**, every rule prefixed `[data-composition-id="captions"]` — the pattern that keeps a sub-comp's styles from leaking, and the reason the styles survive the assembler's `<head>`-dropping rule.
5. **`<script src="https://cdn.jsdelivr.net/npm/gsap@3.14.2/dist/gsap.min.js">`** — see §9; **this exact line is blocked in this project** and must be replaced.
6. **A word-level `script` array literal**: 46 entries of `{ "text", "start", "end" }`, in seconds, three decimals. This is a whisper/Parakeet word transcript inlined into the file.
7. **Line grouping** — a fixed `for` loop, 5 words per line, `text` joined with spaces, `start` = first word's start, `end` = last word's end.
8. **A paused timeline**, one 4-tween cycle per line, registered as `window.__timelines["captions"]`.

### 6.3 What drives caption timing

**The word timestamps in the inlined `script` array — nothing else.** There is no external transcript read at runtime, no audio analysis, no `audio.currentTime`. The chain is:

```
transcript.json (word-level: text, start, end)
   → inlined `script` array in captions.html
   → grouped into lines (5 words/line)
   → line.start / line.end become GSAP timeline positions in SECONDS
```

Per line, the timeline does exactly four things (verbatim structure):

```js
tl.set(box, { visibility: "visible" }, line.start);
tl.to(box, { opacity: 1, duration: 0.1, ease: "power2.out",
             onStart: () => { textEl.textContent = line.text; } }, line.start);
tl.to(box, { opacity: 0, duration: 0.1, ease: "power2.in" }, line.end);
tl.set(box, { opacity: 0, visibility: "hidden" }, line.end + 0.1);
```

Reading it as a contract:

- **Text swap happens in `onStart`** of the fade-in tween, at `line.start`.
- **Fade in / fade out are 0.1s**, `power2.out` in / `power2.in` in the correct direction per the ease doctrine.
- **The trailing `tl.set`** at `line.end + 0.1` is the *"hard kill to ensure caption is hidden"* — the explicit-boundary `visibility` exception described in `motion-principles.md`. It is legal **because `#caption-box` is not the clip element** — the clip is the sub-comp host. Never apply it to a `.clip` container.
- **Cost of the single-element design:** because the box is reused and text is set in `onStart`, a **backwards seek** or a seek that lands between lines does not necessarily restore the correct text — `onStart` fires on forward entry. This is the known fragility of the pattern; a per-line element with per-line opacity envelopes is the seek-robust alternative. (The staged files do not discuss this trade-off; this is an observation about the code, flagged as such.)
- `data-duration="10"` on the root while the transcript runs to **16.02s** — the composition is authored shorter than its data. Per the timing model, *"a timeline that runs past it is cut off."* Whether that is intentional in this demo file is **not stated anywhere in the staged files.**

### 6.4 What is stylable

Everything, because it is CSS. From the file:

| Element | Properties actually used | Values in this file |
|---|---|---|
| `.captions-container` | `width`, `height`, `display:flex`, `justify-content`, `align-items`, `padding-bottom`, `pointer-events` | `100%`/`100%`, center, `flex-end`, `230px` (comment: *"Position at y: 850 (1080 - 230 = 850)"*), `none` |
| `.caption-box` | `background-color`, `padding`, `border-radius`, `display:flex`, `min-width`, `max-width`, `opacity`, `box-shadow` | `#7a6248`, `12px 32px`, `24px`, `100px`, `80%`, `0`, `0 4px 15px rgba(0,0,0,.2)` |
| `.caption-text` | `color`, `font-family`, `font-size`, `font-weight`, `text-align`, `line-height`, `white-space`, `max-width`, `overflow` | `#f5f0e0`, `"Inter", sans-serif`, `48px`, `700`, center, `1.2`, `nowrap`, `1600px`, `hidden` |

Positioning is by flex anchoring (`align-items: flex-end` + `padding-bottom`), **not** absolute coordinates — the reason the file can annotate a target y in a comment.

Three caption-specific constraints that come from other staged files, not from `captions.html`:

- **`white-space: nowrap` + `overflow: hidden` + a 5-word grouping is a text-fit hazard.** A long 5-word line silently clips rather than wrapping. The layout audit measures `getBoundingClientRect` at sampled timestamps and **`overflow: hidden` clips the visual but does not suppress a layout finding** — the escape hatch is `data-layout-allow-overflow`, with the blast radius noted in §3.5. For an intentional lower-third, `data-layout-allow-caption-zone` is the narrower opt-out.
- **`Inter` is a bundled font** (weights 400 · 700 · 900, so `700` here is a real cut) — but it is also on the **Banned monoculture list**. Safe-and-distinctive bundled picks: Montserrat, Oswald, League Gothic, Archivo Black, Space Mono, IBM Plex Mono, JetBrains Mono, Source Code Pro, Noto Sans JP.
- **Video type sizes, not web sizes.** Full-screen viewing: body ≥20px, headlines 60px+, data labels 16px. **In-feed viewing** (X / LinkedIn / Instagram): body ≥32px, headlines ≥90px, data labels ≥24px. `48px` caption text sits comfortably in the full-screen band. Also: tracking −0.03em to −0.05em at display sizes, because *"Video encoding compresses letter detail."* On dark backgrounds, drop body weight (350 not 400) and add 0.05–0.1 line-height.

For per-word rather than per-line captions, the mechanism is the `per-word kinetic typography` technique (§3.10 / `techniques.md`) with `timings` taken from the same transcript array, plus the `asr-keyword-glow` rule for keyword emphasis synced to ASR timestamps. `techniques.md` example uses a decaying slide distance (80→12px) — *"mimics a camera settling."*

---

## 7. Raw media operations

`media-use/references/operations.md` is explicit that it is **guidance, not a wrapper layer**: *"it does not wrap every action as a bespoke command. Instead it points you at the right local tool."* All tools are local and free; **ffmpeg is assumed present** (*"it backs the engine already"*) — and in this container it now **is** present and verified, see §7A.0. After any operation: `resolve --from <output> --type <type>` to ledger it.

**This section covers the operations that change a file. §7A covers the ones that measure it** — shot-boundary detection, silence detection, level and spectral measurement, audio-as-image, loudness measurement, frame extraction and beat detection. That is the toolchain the ANALYSE stage of `pipeline.md` runs on.

**The decision that comes first: do you need a file at all?**

| Want | Do it in the composition | Cut a file |
|---|---|---|
| Trim / sub-window | `data-media-start` + `data-duration` | only when exporting/assembling outside the composition |
| Crop / reframe | `clip-path` on the element (render-time, source untouched) | only when the deliverable is a re-encode |
| Constant speed | `data-playback-rate` (0.1..5, pitch-preserved) | **speed ramps must be preprocessed — no rate envelope exists** |
| Freeze | still `<img>` clip, or hold the final frame | arbitrary **mid-source** freeze requires a preprocessed still/segment |
| Duck | `data-fx-carve` / `volume` lane | only for assets leaving the pipeline |

### The commands

**Cut / trim (keep a slice)**

```bash
ffmpeg -i in.mp4 -ss 00:00:12 -to 00:00:20 -c copy out.mp4   # 0:12–0:20, no re-encode
```

**Reframe / crop (change aspect ratio)**

```bash
# 16:9 -> 9:16, crop centered
ffmpeg -i in.mp4 -vf "crop=ih*9/16:ih,scale=1080:1920" out.mp4
```

**Montage / stitch (join clips)**

```bash
printf "file '%s'\n" a.mp4 b.mp4 c.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy out.mp4
```

**Silence-cut / scene detection**

```bash
auto-editor in.mp4 --edit audio:threshold=4% -o tight.mp4   # pip install auto-editor
scenedetect -i in.mp4 detect-adaptive list-scenes           # pip install scenedetect
```

**Transcription** — default is **Parakeet-TDT via parakeet-mlx**, not whisper: *"avg WER ~6.05% vs 7.44%... and is 5-10x faster."* Emits `{ text, words:[{text,start,end}] }`.

```bash
node <SKILL_DIR>/scripts/transcribe.mjs --input talk.mp4 --out talk.transcribe.json
npx hyperframes transcribe talk.mp4 --engine parakeet   # or --engine auto (default)
```

Auto-falls-back to whisper.cpp (99 languages) when parakeet-mlx is absent or the language is outside Parakeet's English + 25 European. Note `parakeet-mlx` is an **MLX (Apple silicon)** path — see §9 for why that matters here.

**Text-based editing (transcript cut)** — `transcript-cut.mjs` is *"a compiler, not a wrapper"*, and is the one script this file ships. Verified flags from the source:

```bash
node <SKILL_DIR>/scripts/transcript-cut.mjs \
  --input talk.mp4 --transcript talk.transcribe.json \
  --remove "12.41-15.02,88.3-91.7" \
  --remove-fillers "um,uh,like" \
  --cut-silence 0.8 \
  --out talk.cut.mp4
```

Full option set (from `parseArgs` in the script): `--input`, `--transcript`, `--remove` (second ranges `a-b,c-d`), `--remove-words` (word-**index** ranges), `--remove-fillers`, `--cut-silence` (removes inter-word gaps longer than N seconds), `--keep` (inverse mode, mutually exclusive with removal), `--copy`, `--plan`, `--out`, `--json`, `--help`.

Mechanism, from the code: it compiles a kept-segment list (`compileCutList`), cuts each segment with `ffmpeg -ss … -to …`, writes a concat list, then `ffmpeg -f concat -safe 0 -i list.txt -c copy` into `<out>.part<ext>` and **atomic-renames** — *"so a SIGKILL mid-encode can't leave a truncated outPath."* Per-container codecs: `.wav` → `pcm_s16le`, `.mp3` → `libmp3lame -q:a 2`, `.m4a`/`.aac` → `aac`, `.flac` → `flac`, otherwise `libx264 -preset veryfast -crf 18` + `aac` + `+faststart`. Comment worth heeding: *"Audio-only outputs must not get the video-centric aac/x264 set (aac inside .wav breaks timing entirely)."*

**`--copy` has a real trap, and the script measures it:** stream copy cuts only on keyframes; on sparse-keyframe footage the snap *"can silently swallow the whole cut."* It compares produced vs expected duration and, on >1s drift, warns on stderr and reports `copy_drift: {produced_s, expected_s}` in `--json`. *"drop --copy for frame-accurate cuts."*

Use `--plan` first to inspect the kept-segment JSON before encoding.

**Audio slip / alignment.** There is no auto-sync: *"HyperFrames does not provide automatic waveform sync or drift correction."* Alignment is authored — picture and sound share `data-start`, `data-duration`, `data-media-start` **and** `data-playback-rate`:

```html
<video id="shot-1" src="take.mp4" data-start="3" data-duration="2" data-media-start="8"
       data-playback-rate="2" data-track-index="0" muted playsinline></video>
<audio id="shot-1-audio" src="take.mp4" data-start="3" data-duration="2" data-media-start="8"
       data-playback-rate="2" data-track-index="10"></audio>
```

The global math for any retime, verbatim: **consumed source = timeline duration × rate**; **natural timeline duration = remaining source / rate**.

**Loudness (two-pass `loudnorm`)** — measure, then apply the measured values:

```bash
# pass 1 — measure
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -

# pass 2 — apply (socials, -14 LUFS)
ffmpeg -i mix.wav \
  -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=<input_i>:measured_TP=<input_tp>:measured_LRA=<input_lra>:measured_thresh=<input_thresh>:offset=<target_offset>:linear=true:print_format=summary \
  mix.social.wav
```

Podcast target is the same with `I=-16` → `mix.podcast.wav`.

**Baked ducking (export only)**

```bash
ffmpeg -i bgm.mp3 -i voice.wav \
  -filter_complex "[0][1]sidechaincompress=threshold=0.03:ratio=8:attack=200:release=400[ducked]" \
  -map "[ducked]" bgm.ducked.wav
```

**Error-diffusion dither** (`scripts/dither.mjs`) — for looks that specifically call for a sequential algorithm rather than the realtime Bayer shader. Algorithms: `floyd-steinberg` (default), `atkinson`, `jarvis-judice-ninke`, `stucki`, `burkes`, `sierra`, `sierra-lite`, `two-row-sierra`. Flags: `--input`, `--out`, `--algorithm`, `--palette` (2–6 `#rrggbb`, dark-to-light), `--point-size` (1–20px), `--brightness` / `--contrast` (0.5–2), `--detail` (0.1–1). Handles SDR images and MP4, preserves audio, emits BT.709, and **rejects tagged PQ/HLG input rather than silently tone-mapping it**.

**Background removal / upscale / lipsync / translate**

| Op | Local (free) | HeyGen CLI (quality) |
|---|---|---|
| Background removal | `hyperframes remove-background in.png` (u2net) | `heygen background-removal` |
| Upscale | `realesrgan-ncnn-vulkan -i in.png -o out.png -s 4` | n/a |
| Lipsync (dub) | n/a | `heygen lipsync` |
| Translate | n/a | `heygen video-translate` |

**HEVC / H.265** needs **no conversion**: render pre-decodes all input video via FFmpeg, and preview auto-proxies to a cached H.264 copy on first use (disable with `--no-proxy` or `media.autoProxy: false` in `hyperframes.json`). A manual proxy remains available: `ffmpeg -i in.mp4 -c:v libx264 -crf 18 proxy.mp4`.

**The `media-use` resolve verb** (the sourcing side, for completeness):

```bash
node <SKILL_DIR>/scripts/resolve.mjs --type <type> --intent "<description>" --project <dir>
```

Types: `bgm`, `sfx`, `image`, `icon`, `logo`, `voice`, `grade`, `lut`. Returns one line: `resolved <id> → <path> (<type>, <metadata>)`. `--candidates` lists reusable candidates; `--from <file>` ingests an external file; `--doctor` verifies setup; `--local-only` skips network paths. First run needs the `heygen` CLI installed and signed in.

The shared audio engine takes a neutral request file:

```bash
node <SKILL_DIR>/audio/scripts/audio.mjs --request ./audio_request.json --out ./audio_meta.json
```

Request: `{ provider?, lang?, speed?, lines: [{ id, text, sfx?: [names] }], bgm: { mode?, query?, prompt? } }` where `bgm.mode` = `retrieve | generate | none`. Output `audio_meta.json` is id-keyed: `voices[].{path,duration_s,words[]}` (**word timestamps for captions**), `sfx[]`, `bgm`, `total_duration_s`. `--only tts,bgm,sfx` runs a subset. If `bgm_pending: true`, run `audio/scripts/wait-bgm.mjs` before final render.

**In this project, Epidemic Sound MCP substitutes for the `bgm` / `sfx` / `voice` resolve paths.** The rest of the chain — `audio_meta.json`-shaped bookkeeping, placement, gain, carve — is unchanged, but note that `audio_duck.mjs` and `carve.mjs` expect their own inputs (`--meta audio_meta.json`, and a composition respectively), so an Epidemic-sourced project should either produce an equivalent meta file or drive the carve directly off the composition.

---

## 7A. The analysis toolchain

§7 covers the operations that **change** a file — trim, reframe, concat, loudness. This section covers the operations that **measure** one. It exists because the ANALYSE stage of `pipeline.md` is detection, not interpretation, and detection needs commands that produce numbers and pictures rather than opinions.

**Everything in this section was checked against the ffmpeg in this container.** Marker convention:

- **[verified]** — the command was executed here and the quoted output shape is what it actually printed.
- **[unverified]** — documented from knowledge; not executed here. Treat as a hypothesis, exactly as `pipeline.md` requires of any unconfirmed observation.

### 7A.0 The ffmpeg in this container — now verified

§10 previously listed ffmpeg/ffprobe as *"not verified as present in this environment."* **They are present.** **[verified]**

```
ffmpeg version 6.1.1-3ubuntu5   (Ubuntu, gcc 13)
libavutil   58.29.100
libavcodec  60.31.102
/usr/bin/ffmpeg   /usr/bin/ffprobe
```

Every filter this section names was confirmed present via `ffmpeg -filters`: `scdet`, `silencedetect`, `astats`, `aspectralstats`, `showspectrumpic`, `showwavespic`, `ebur128`, `loudnorm`, `select`, `showinfo`, `volumedetect`, `blackdetect`, `freezedetect`, `signalstats`, `thumbnail`. **[verified]**

This is the *container's* ffmpeg. §9's third constraint still stands: the device VM is a different host, and `visual-kt-delta.md` records that contact sheets were generated there because it has ffmpeg too. **State which host a measurement was taken on** — the binaries are not guaranteed to be the same build.

> **One correction to `pipeline.md`, verified.** Its ANALYSE command uses `-vsync vfr`. This ffmpeg prints `-vsync is deprecated. Use -fps_mode`. Write **`-fps_mode vfr`**. Same behaviour, no warning. **[verified]**

---

### 7A.1 Shot-boundary detection — `scdet` and `select='gt(scene,N)'`

Two mechanisms. They answer the same question on **two different scales**, and confusing them is the most likely way to get this wrong.

| | `scdet` | `select='gt(scene,N)'` |
|---|---|---|
| Role | reports boundaries | selects frames at boundaries |
| Metric | `lavfi.scd.score` | `lavfi.scene_score` (the `scene` variable) |
| Scale | roughly 0–100 | 0–1 |
| Output | log lines | actual frames you can look at |

**They are not convertible.** Measured on one file, at the same two boundaries: **[verified]**

| Boundary | `select` `scene` | `scdet` `scd.score` |
|---|---|---|
| Hard cut (entirely different content) | **0.683** | **26.66** |
| Punch-in (1.2x scale on identical content) | **0.160** | **6.26** |

The *ratio* between the two events happens to agree on both metrics (4.27x and 4.26x), but the **absolute scales differ by roughly 39x**. So the ranking is portable and the threshold is not. Never carry a threshold value from one filter to the other.

**The commands** — all four executed here. **[verified]**

```bash
# 1. report boundaries with scores (decode only, no output file)
ffmpeg -hide_banner -i in.mp4 -vf "scdet=threshold=10" -an -f null - 2>&1 | grep scd.time
#    -> [scdet @ ...] lavfi.scd.score: 85.547, lavfi.scd.time: 2

# 2. per-frame score dump — threshold=0 reports every frame
ffmpeg -v error -i in.mp4 \
  -vf "scdet=threshold=0,metadata=print:key=lavfi.scd.score:file=-" -an -f null -

# 3. extract one frame at each boundary (this is pipeline.md's idiom, corrected)
ffmpeg -v error -i in.mp4 \
  -vf "select='gt(scene,0.1)',showinfo" -fps_mode vfr -an /tmp/cuts/%04d.png

# 4. per-frame scene score from select's own metric
ffmpeg -v error -i in.mp4 \
  -vf "select='gte(scene,0)',metadata=print:key=lavfi.scene_score:file=-" -an -f null -
```

Command 2 and 4 print two lines per frame — a `frame:N pts:… pts_time:X` line and a `key=value` line. `paste - -` joins them into one row before parsing.

#### Threshold choice is a recall decision

Measured sweep over a file containing exactly two boundaries — a punch-in at t=2.0 and a hard cut at t=4.0: **[verified]**

| `select` threshold | punch-in (scene 0.160) | hard cut (scene 0.683) |
|---|---|---|
| `gt(scene,0.05)` | caught | caught |
| `gt(scene,0.10)` | caught | caught |
| `gt(scene,0.20)` | **missed** | caught |
| `gt(scene,0.30)` | **missed** | caught |
| `gt(scene,0.40)` | **missed** | caught |

| `scdet` threshold | boundaries reported (of 2) |
|---|---|
| `threshold=3` | 2 |
| `threshold=5` | 2 |
| `threshold=10` | 1 |
| `threshold=20` | 1 |
| `threshold=40` | 0 |

**Why a punch-in needs a lower threshold than a hard cut.** The scene metric measures how much of the frame stopped correlating with the previous frame. A hard cut replaces every pixel at once, so it saturates the metric. A punch-in re-frames *the same content*: the subject is still there, the background is merely larger, and most of the picture still correlates. In the measurement above the punch-in scored **0.160 against the cut's 0.683 — 4.3x lower on the same file**. A threshold set for cuts cannot see it.

So `pipeline.md`'s `gt(scene,0.3)` is a **hard-cut detector**. That is the right tool for shot-length statistics and the wrong tool for anything softer. Run the pass twice:

- **`gt(scene,0.3)`** — hard cuts only, high precision. Use this for median/p90 shot length in `PROFILE.md`.
- **`gt(scene,0.08)`–`gt(scene,0.12)`** — cuts *plus* punch-ins, match cuts on similar framing, and whip-pan boundaries. Expect false positives from camera movement, flash frames and hard lighting changes, so **every hit at this threshold must be visually confirmed against its extracted frame** before it enters the observation log. That is `pipeline.md`'s "observation before assertion" invariant applied at the filter level.

Two further limits worth writing into any note that cites this:

- **A dissolve or crossfade produces no spike.** The change is spread over N frames, so no single frame crosses either threshold; a crossfade appears in the per-frame dump as a **plateau of mid-range scores**, not a peak. Boundary lists will miss it entirely. Use the per-frame dump (commands 2 and 4) when the reference is suspected of using dissolves.
- **Thresholds do not transfer between files.** `source-media.md` records that `editing kt 3` is 854x480; compression noise raises the score floor on low-bitrate material. Sweep per file, and record the threshold used next to every logged boundary.

Related detectors, present but not swept here: `blackdetect` (black frames, useful for finding chapter breaks), `freezedetect` (held frames, useful for finding the freeze-frame device), `thumbnail` (picks representative frames from a window). **[unverified]** — confirmed present in `-filters`, not executed.

---

### 7A.2 Dead space and pauses — `silencedetect`

This is what drives the **subtractive first pass** — the "cut the dead air before you cut anything else" move that the reference set treats as step one of an edit.

```bash
ffmpeg -hide_banner -i in.mp4 -af "silencedetect=noise=-40dB:d=0.3" -vn -f null - 2>&1 | grep silence
```

Verified output shape on a file of tone / silence / tone / silence: **[verified]**

```
[silencedetect @ ...] silence_start: 0.999979
[silencedetect @ ...] silence_end: 2.00004 | silence_duration: 1.00006
[silencedetect @ ...] silence_start: 2.99998
[silencedetect @ ...] silence_end: 5 | silence_duration: 2.00002
```

- `noise=` is the level below which audio counts as silent (dB, or a linear value without the suffix).
- `d=` is the **minimum** silent duration in seconds; shorter gaps are ignored.
- Every region is reported as a matched `silence_start` / `silence_end` pair, and **a region that runs to the end of the file is still closed** — the final `silence_end: 5` above is the file duration. A parser does not need to handle an unterminated last region. **[verified]**
- `-vn` matters. Without it ffmpeg decodes the whole video stream to measure the audio.

**Choosing `noise=`.** −40 dB is a sane default for clean speech in a quiet room. It is not a universal constant: if the room floor is above the threshold, nothing is ever "silent" and the pass returns nothing. Measure the floor first with `astats`' `Noise floor dB` (§7A.3) and set `noise` about 6–10 dB above it.

**Choosing `d=`.** This is a craft parameter, not a technical one. `d=0.3` finds breath-length gaps and produces a very aggressive cut list. `d=0.8`–`1.0` finds only real dead air. The value that matches a given creator is an *observation*, not a default — log the distribution of gap lengths and put the number in `PROFILE.md`.

**Relationship to §7.** `silencedetect` **measures** so you can choose the threshold; `transcript-cut.mjs --cut-silence <N>` **applies** it. Run this first, look at the distribution, then set `--cut-silence`. Going straight to `--cut-silence` is guessing.

---

### 7A.3 Level and spectral measurement — `astats` and `aspectralstats`

**`astats` — overall summary** **[verified]**

```bash
ffmpeg -hide_banner -i in.wav -af "astats=measure_perchannel=none" -f null -
```

Keys observed in this container's output (the full set is larger; these are the ones this project needs):

```
Peak level dB: -18.063656
RMS level dB:  -25.291387
RMS peak dB:   -21.069771
RMS trough dB: -39.591575
Flat factor:    0.000000
Noise floor dB: -33.066106
Noise floor count: 27.000000
```

`measure_overall=Peak_level+RMS_level+Noise_floor` narrows the output to named measures. Note: a measure name that this build does not recognise is **silently dropped rather than erroring**, so confirm a key appears in the output before writing a note that parses it. **[verified]**

**`astats` — windowed, which is the form that matters** **[verified]**

```bash
ffmpeg -v error -i in.wav \
  -af "astats=metadata=1:reset=24,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" \
  -f null -
```

`metadata=1` exports measurements as frame metadata; `reset=N` restarts the running measurement every N frames, which turns a single summary into a **level curve over time**. Verified output is one `pts_time` line plus one `RMS_level` line per audio frame.

This is the command behind a real ducking observation. `visual-kt-delta.md` records that ducking is *demonstrated but never named* in the reference set — a keyframed volume ramp visible on a Premiere audio clip. Turning that into a rule note means a number: RMS of the music bed **during** speech versus **between** speech, differenced, is the duck depth in dB. That is what `design-sound.md` can execute against §5.3's carve strength; "the music gets quieter" is not.

**`aspectralstats` — per-frame spectral descriptors** **[verified]**

```bash
ffmpeg -v error -i in.wav \
  -af "aspectralstats=measure=centroid+spread+flatness+rolloff,ametadata=print:file=-" -f null -
```

Verified key shape — note the channel index in the middle of the key:

```
lavfi.aspectralstats.1.centroid=396.32
lavfi.aspectralstats.1.spread=1186.66
lavfi.aspectralstats.1.flatness=0.0237969
lavfi.aspectralstats.1.rolloff=351.562
```

- **centroid** — spectral centre of mass in Hz; tracks *brightness*. This is how you separate the KT's own `Metal Hit` from its `Wood Hit` without listening.
- **flatness** — near 0 for tonal content, near 1 for noise-like. Separates a tonal riser from a broadband whoosh.
- **spread**, **rolloff** — bandwidth and the frequency below which most energy sits.

**Honest limit, and it is §5.9's rule restated:** *"The absolute spectrum of a single unknown voice cannot be diagnosed."* The same applies to every number here. A centroid of 396 Hz means nothing on its own. These figures are only usable **compared within one file or across one consistent set** — this SFX against that SFX, speech against the pauses around it, the reference's bed against the new video's bed. A note that states an absolute spectral target is writing a spec that cannot be checked.

---

### 7A.4 Looking at audio — `showspectrumpic` and `showwavespic`

**This is how sound events get detected, because an agent cannot listen but it can look.**

```bash
ffmpeg -y -i in.wav -lavfi \
  "showspectrumpic=s=1024x512:legend=1:mode=combined:color=intensity:scale=log" spec.png

ffmpeg -y -i in.wav -lavfi \
  "showwavespic=s=1600x300:colors=white:split_channels=0" wave.png
```

Both executed here, and the spectrogram was then **read back visually in this session**. **[verified]** With `legend=1` the image carries a labelled time axis, a frequency axis and a dBFS colour scale, and all three events in the test file — a 220 Hz tone, a broadband noise burst, an 1800 Hz tone — were individually identifiable **from the picture alone**, including their start and end times to within the axis resolution. The claim that an agent can detect sound events by looking is not a hope; it was demonstrated.

**The working loop:**

1. `showwavespic` across the **whole file** — transient spikes tell you *where* the events are.
2. Cut a window around each event (`-ss <t> -t <len>`) and `showspectrumpic` **that window** — the spectrogram tells you *what* the event is: a whoosh sweeps, a riser climbs, an impact is a vertical broadband stripe with a decaying tail, a tonal sting is a horizontal line.
3. Pair the audio timecode with the frame extracted at the same timecode (§7A.6). An SFX that lands on a cut and one that lands 4 frames after it are different techniques, and this is how you tell them apart.

**Practicalities:**

- **`legend=1` is what makes the image measurable.** Without it there are no axes and you can only read shape, not time. Always set it when the picture is going to be looked at rather than shown.
- **Render windows, not whole files, for placement.** A 10-minute file at `s=1024` is roughly 0.6 s per pixel — far too coarse to place a hit on a frame boundary. Survey wide, then measure narrow.
- `mode=combined` sums channels; `mode=separate` stacks them. `scale=log` on the amplitude axis is what makes quiet detail visible; the default linear scale hides everything below the loudest event.
- `showwavespic` is cheap and fast — run it first, always.

---

### 7A.5 Programme loudness — `ebur128` and `loudnorm`

§7 documents the two-pass `loudnorm` that **hits** a target. `ebur128` is its read-only counterpart, and it is the one ANALYSE wants: it **characterises** a reference without changing anything.

```bash
ffmpeg -hide_banner -i mix.wav -af ebur128=peak=true -f null -
```

Verified summary shape: **[verified]**

```
Integrated loudness:  I: -23.4 LUFS   Threshold: -34.3 LUFS
Loudness range:       LRA: 5.9 LU     LRA low: -29.5 LUFS   LRA high: -23.6 LUFS
True peak:            Peak: -18.1 dBFS
```

> **On a deliverable, run this on the muxed MP4, not on `mix.wav`.** A dBTP target cannot be guaranteed by anything
> upstream of the AAC encode — `alimiter` limits *sample* peaks and the encoder adds overshoot of its own. See §7B,
> *`alimiter`'s `limit` is a sample-peak limit*, for the measured numbers and the guard → mux → measure → correct →
> re-mux order.


**`loudnorm` pass 1 JSON — the exact field names**, since §7's pass-2 command consumes them as placeholders: **[verified]**

```json
{ "input_i", "input_tp", "input_lra", "input_thresh",
  "output_i", "output_tp", "output_lra", "output_thresh",
  "normalization_type", "target_offset" }
```

`normalization_type` came back `"dynamic"` on the test file. Pass 2's `measured_*` arguments map one-to-one onto the `input_*` fields, and `offset=` takes `target_offset`.

**`volumedetect`** also verified — prints `mean_volume`, `max_volume` and a dB histogram. **[verified]** It is cheaper than `astats` when all you want is a peak/mean pair, but it is a **sample-domain mean, not loudness**. Never compare a `volumedetect` figure to a LUFS figure; they are different units measuring different things.

**Profiling use.** `LRA` is the number behind claims like "this creator's mix is squashed" or "this creator lets the music breathe". Measure it per reference and record it in `PROFILE.md` next to the `−3 to 0 dB` dialogue target that `visual-kt-delta.md` confirms twice on screen. `I` is what tells you whether the reference was mastered for the −14 LUFS socials target §7 normalises to.

---

### 7A.6 Frame extraction for motion timing

Reading motion timing means looking at **consecutive** frames. So the first rule is: **do not resample.** Putting `fps=` in the chain destroys exactly the information being measured — a 14-frame entrance sampled at 2 fps is not an entrance, it is two pictures.

All four idioms below were executed here. **[verified]**

```bash
# every frame in a time window, at native rate — the motion-timing idiom
ffmpeg -v error -i in.mp4 -vf "select='between(t,1.9,2.2)'" \
  -fps_mode passthrough -an out/f_%03d.png
#    -> 10 files from a 0.3s window on a 30fps file. Correct.

# by frame index instead of time — no rounding at all, both ends inclusive
ffmpeg -v error -i in.mp4 -vf "select='between(n,58,64)'" \
  -fps_mode passthrough -an out/n_%03d.png
#    -> 7 files. Inclusive at both ends.

# one frame at an exact time (fast seek: -ss BEFORE -i)
ffmpeg -v error -ss 4.0 -i in.mp4 -frames:v 1 -update 1 one.png

# contact sheet — survey only, never measurement
ffmpeg -v error -i in.mp4 -vf "fps=2,scale=160:-1,tile=4x3" -frames:v 1 sheet.png
```

**Prefer `between(n,…)` for motion measurement.** It removes the fps question from the extraction step entirely: count the frames you got, then divide by the fps you read from `ffprobe`. `between(t,…)` re-introduces the rounding you are trying to avoid, and on a 29.97 file it will drift.

**`-ss` placement.** Before `-i` is the fast seek and lands on a decoded frame near the request; after `-i` is exact but decodes from the start of the file. For an illustrative reference frame the fast form is fine. **For the frame *at* a cut, extract the window and pick from it — never trust a single fast seek to land on the right side of a boundary.**

**The contact sheet is a survey tool.** `visual-kt-delta.md` is explicit about this and it is worth repeating here: 30 frames across a 10-minute video is one frame per 20 seconds — enough to read format and graphic vocabulary, **not** enough to measure cut rhythm or motion timing. Those need the dense windows above.

---

### 7A.7 Beat and tempo — `librosa` (Python, separate install)

**`librosa` is not part of ffmpeg and is not installed in this container.** **[verified]** — `import librosa` returns `ModuleNotFoundError: No module named 'librosa'`.

It **is** installable here: `pip download librosa` succeeded and fetched `librosa-0.11.0`, so PyPI is reachable through the proxy. `numpy 2.4.4` and `scipy 1.17.1` are already present. **[verified]** The install itself has not been run, so **everything below is [unverified]** — documented from knowledge, not executed.

```python
import librosa

y, sr = librosa.load("bed.wav", sr=None, mono=True)   # sr=None keeps the native rate

tempo, beats = librosa.beat.beat_track(y=y, sr=sr, units="time")   # beat positions, seconds
onsets = librosa.onset.onset_detect(y=y, sr=sr, units="time")      # transient positions, seconds
```

`beat_track` returns an estimated tempo plus a regular beat grid. `onset_detect` returns transients — **where something actually happens**, which is usually the better anchor for a cut, since a beat grid is regular by construction and an onset is not.

**Why this belongs in the contract at all.** §10 records that HyperFrames has no beat-detection surface, and `hyperframes-creative/scripts/extract-audio-data.py` is not staged. The reference set's entire music segment is about matching cuts to a bed. So if a design doc wants to cut to music, the beat grid has to come from outside the stack, and this is the route.

**Two cautions that belong in any note citing it:**

- **Tempo estimates halve and double.** A 91 BPM bed is regularly reported as 182 or 45.5. But this project has a free ground truth: the Epidemic catalogue hands you `Recording.bpm` on every search result (§5A.2). Cross-check against it. That downgrades librosa from a *tempo* detector to a *phase* detector — where beat one actually falls — which is both the harder problem and the one you actually need.
- **Where to run it.** An install is a network path, and §9's third constraint says the device VM is linux ARM64 without sudo. Do the librosa leg in the container, not on the device.

Output is in **seconds**. Convert to the project frame grid per §7A.8, not before.

---

### 7A.8 fps is read per file, and never assumed

This subsection exists because the reference set runs at **three different frame rates across five files** — 60, 25 and 29.97 fps. See **`source-media.md`**, which is the authority; this is the toolchain-level restatement.

```bash
ffprobe -v error -select_streams v:0 \
  -show_entries stream=r_frame_rate,avg_frame_rate,width,height,nb_frames,duration \
  -of default=noprint_wrappers=1 "<video>"
```

Verified output shape in this container: **[verified]**

```
width=640
height=360
r_frame_rate=30/1
avg_frame_rate=30/1
duration=6.000000
nb_frames=180
```

**Which commands in this section care, and which do not.** This is the practical form of the rule:

| Reports | fps-dependent? | Examples from this section |
|---|---|---|
| **Seconds** | No — safe | `scdet`'s `scd.time`, `silencedetect`'s `silence_start`/`silence_end`, `showinfo`'s `pts_time`, `ametadata`'s `pts_time`, librosa's `units="time"` |
| **Frame indices** | **Yes — meaningless without the rate** | `select`'s `between(n,…)`, `showinfo`'s `n:`, `ffprobe`'s `nb_frames` |

So: **measure in seconds, record the source fps beside every measurement, and convert to frames only at authoring time at the target project fps.** This is `source-media.md`'s rule, and §10's "no frame-based timing attribute" means HyperFrames only accepts seconds anyway — the conversion exists purely so a rule note can state a timing a human can reason about.

Three further points:

- **`r_frame_rate` and `avg_frame_rate` can disagree.** `r_frame_rate` is the base rate; `avg_frame_rate` is frames divided by duration. When they differ the file is variable-frame-rate, `between(n,…)` no longer maps linearly onto time, and the measurement must fall back to `between(t,…)` — and say so in the observation log. **Read both, every time.**
- **`29.97` is `30000/1001`.** `ffprobe` will report it as that fraction, not as `29.97`. Parse the fraction; do not round it before doing timeline maths. `source-media.md` puts the drift at ~1.1s over a 10-minute file against a naive 30 fps assumption — irrelevant for one entrance, material when aligning a whole music bed.
- **Never inherit fps from a sibling file**, and never from another video by the same creator. `editing kt.mp4` is 60 fps and `editing kt 2.mp4` is 25 fps; they are the same creator's neighbours in the same folder.

---

## 7B. The manipulation filters

§7 covers the operations that **change** a file at the container level — trim, reframe, concat, loudness. §7A covers the ones that **measure** it. This section covers the third group: the **filters that change the signal**, cited by **151 Execution specs** (86 sound-design, 30 editing, 24 motion, 11 subtitles) and, until now, absent from this contract. That mattered because of this document's own house rule — *anything not in here is not known to run* — which meant 46% of the library's Execution specs cited something unverified.

**Every filter named in this section was executed in this container on real media, not merely looked up in `ffmpeg -filters`.** The marker convention is §7A's:

- **[verified]** — the command was run here and did what the text says.
- **[unverified]** — documented from knowledge; not executed here. Treat as a hypothesis.

### 7B.0 Headline result — and two corrections to the build report

**All 31 filters are present and all but one run in this container.** `ffmpeg 6.1.1-3ubuntu5`, the same binary §7A.0 verified. **[verified]**

The build report (ISSUE-A) predicted that `rubberband` and `subtitles` would be missing because they need build flags "a stock ffmpeg lacks". **On this host they are both present**, because this is Ubuntu's `--enable-gpl` build and it carries the flags:

```
--enable-librubberband   --enable-libass   --enable-libfreetype   --enable-libfontconfig   --enable-libsoxr
```

So the report's *risk* was real and its *conclusion for this host* was wrong. The distinction matters and is the reason the table below has a separate **Build flag** column: these three filters are present here and are the first things to break on a different host. Three, not two — the report missed `drawtext`, which needs `--enable-libfreetype`.

Two further corrections, both found by running the filters rather than reading about them:

1. **`atempo` is not limited to 0.5–2.0 in this build.** The widely-cited 2.0 ceiling was true of older FFmpeg; here the filter reports its own range as **`from 0.5 to 100`**, and `atempo=2.5` and `atempo=3.0` both ran clean. `atempo=0.4` was rejected: `Value 0.400000 for parameter 'tempo' out of range [0.5 - 100]`. **[verified]** The floor of 0.5 is real and is the one that forces chaining — see §7B.1.
2. **`arnndn` is present but unusable as cited.** It is the one filter in the set that does not run. It has no built-in model; `-af arnndn` fails with `Error initializing filters` because `model` is a required string option and no `.rnnn` file ships with the binary. **[verified]** The one note citing it is specifying something that cannot execute here. See §7B.6.

### 7B.1 Verification table — all 31 filters

Status values: **runs here** = executed successfully in this container. **Present, needs data** = in `ffmpeg -filters` but failed to run without an external file. The **Substitute** column is what to use *on a host that lacks the filter* — for the three flag-dependent rows that is a live concern, for the rest it is belt-and-braces.

| Filter | Purpose | Status in this container | Build flag needed | Substitute if absent |
|---|---|---|---|---|
| `asetrate` | Varispeed — reinterprets the sample rate, moving pitch **and** length together | **runs here** [verified] | none (core) | none needed; it is the fallback itself |
| `aresample` | Resample back to the working rate after `asetrate` | **runs here** [verified] | none (core; `--enable-libsoxr` only improves quality) | `-ar 48000` on the output |
| `atempo` | Length without pitch — corrects the speed `asetrate` introduced | **runs here** [verified] | none (core) | `rubberband=tempo=` |
| `afade` | Fade in/out, 24 curve types | **runs here** [verified] | none (core) | `volume` with an expression envelope |
| `acrossfade` | Fade one audio stream out while the next fades in, in one filter | **runs here** [verified] | none (core) | two `afade`s + `adelay` + `amix` |
| `rubberband` | Pitch shift with length preserved (and vice versa) | **runs here** [verified] | **`--enable-librubberband`** | `asetrate` + `aresample` + `atempo` chain (§7B.2) — lower quality, no formant control |
| `amix` | Sum N audio streams into one | **runs here** [verified] | none (core) | `amerge` + `pan`, or repeated two-input mixes |
| `atrim` | Keep a time window of an audio stream inside a filtergraph | **runs here** [verified] | none (core) | `-ss` / `-t` at the container level (§7) |
| `eq` | Contrast / brightness / saturation / gamma grade | **runs here** [verified] | none (core) | `curves`, or `colorbalance` |
| `setpts` | Rewrite video timestamps — the video speed control | **runs here** [verified] | none (core) | `-r` re-timing, lossier |
| `subtitles` | Burn subtitles into the picture | **runs here** [verified] | **`--enable-libass`** | `drawtext` per cue (no styling, no positioning model), or author captions as a composition (§6) |
| `alimiter` | True-peak-ish ceiling; stops overs | **runs here** [verified] | none (core) | `acompressor` at a high ratio, or `loudnorm`'s own TP |
| `xfade` | Video cross-transition, 56 named transitions | **runs here** [verified] | none (core) | `blend` + manual `setpts` offsets |
| `boxblur` | Fast box blur | **runs here** [verified] | none (core) | `gblur` |
| `pad` | Add letterbox/pillarbox around the frame | **runs here** [verified] | none (core) | `scale` + `overlay` onto a `color` source |
| `gblur` | Gaussian blur, better quality than box | **runs here** [verified] | none (core) | `boxblur` with `luma_power=2..3` |
| `drawtext` | Burn text into the picture | **runs here** [verified] | **`--enable-libfreetype`** (+ `libfontconfig` to name a font instead of a file) | `subtitles` from a generated ASS file, or author the text as a composition (§6) |
| `rotate` | Rotate by an arbitrary angle (expression-driven) | **runs here** [verified] | none (core) | `transpose` for exact 90° steps only |
| `tblend` | Blend each frame with the previous — motion trails, echo | **runs here** [verified] | none (core) | `lagfun`, or `framerate` interpolation |
| `vignette` | Darken toward the frame edge | **runs here** [verified] | none (core) | `overlay` a pre-rendered radial PNG |
| `equalizer` | Parametric peaking EQ band | **runs here** [verified] | none (core) | `biquad`, or `bandpass`/`bandreject` |
| `afftdn` | FFT denoise — broadband hiss | **runs here** [verified] | none (core) | `anlmdn`, or a `highpass`/`lowpass` pair |
| `acompressor` | Downward compression | **runs here** [verified] | none (core) | `compand` |
| `zoompan` | Ken Burns — animated zoom and pan over a still or clip | **runs here** [verified] | none (core) | `scale` + `crop` with expressions on `t` |
| `agate` | Noise gate — close the gaps between phrases | **runs here** [verified] | none (core) | `compand` with a steep low-level slope |
| `stereotools` | Mid/side width, balance, phase | **runs here** [verified] | none (core) | `pan` with explicit M/S coefficients |
| `arnndn` | RNN speech denoise | **Present, needs data** — **does not run without a model file** [verified] | none (core), but requires an external `.rnnn` model | `afftdn` (present, runs) — the practical answer here |
| `amerge` | Combine N inputs into one multi-channel stream (not a sum) | **runs here** [verified] | none (core) | `join` |
| `adelay` | Delay one or more channels by milliseconds | **runs here** [verified] | none (core) | `apad` + `atrim`, or `aresample=async` |
| `aecho` | Echo / slapback | **runs here** [verified] | none (core) | `adelay` + `amix` at reduced gain |
| `areverse` | Reverse an audio stream | **runs here** [verified] | none (core) | none — buffers the whole stream by design |

**Totals: 30 of 31 run here. 1 (`arnndn`) is present but needs an external model. 0 absent. 3 are build-flag-dependent** — `rubberband`, `subtitles`, `drawtext`.

> **Portability warning, the same one §7A.0 gives.** This is the *container's* ffmpeg. §9's third constraint stands: the device VM is a different host with a different build. A note that specs `rubberband`, `subtitles` or `drawtext` will build here and can fail there. **State which host a media operation was run on**, and prefer the substitute chain when the note has to be portable.

Two naming collisions worth stating so nobody documents the wrong thing twice: **`highpass` and `lowpass` are cited by 60 and 44 notes respectively, but almost always as HyperFrames FX-chain node types, not as ffmpeg filters** — those are §5.6's registry, and the ffmpeg filters of the same name also exist. Likewise `volume` is both a `data-automation` lane target (§5.2) and an ffmpeg filter. Read the fence: if it is `data-fx-chain` JSON it is §5.6; if it is a `-af` string it is here.

### 7B.2 Pitch and speed

This is the largest group in the library — `asetrate` (50 notes), `aresample` (47), `atempo` (43), `rubberband` (21) — and the one most often written down wrongly, because the three-filter chain looks redundant until you know what each filter undoes.

**Why the pitch-shift chain is three filters.** There is no "shift the pitch" filter in core ffmpeg. There is only varispeed, so the chain fakes pitch shifting by doing varispeed and then undoing the speed:

| Step | What it does | Effect on pitch | Effect on length |
|---|---|---|---|
| `asetrate=48000*R` | Relabels the stream's sample rate as `48000*R` without touching a single sample — the tape-speed trick | **× R** (the point) | **÷ R** (the side effect) |
| `aresample=48000` | Resamples back to the working rate so the file is playable and mixable | unchanged | unchanged — still ÷ R |
| `atempo=1/R` | Stretches/squeezes time only, pitch-preserved | unchanged | **× R** → back to original |

So: **`asetrate` gets you the pitch and breaks the length; `atempo` puts the length back; `aresample` exists so the intermediate stream is at a rate the rest of the graph can use.** Drop `aresample` and downstream filters see a 38.4 kHz stream and the mix rate is wrong. Drop `atempo` and you have varispeed, which is a different (and sometimes wanted) effect.

Measured here on a 5.000 s 48 kHz source at `R=0.8`: **[verified]**

| Stage | Stream rate | Duration |
|---|---|---|
| source | 48000 | 5.000 s |
| `asetrate=48000*0.8` | **38400** | **6.250 s** (= 5 ÷ 0.8) |
| `+ aresample=48000` | 48000 | 6.250 s |
| `+ atempo=1.25` | 48000 | **4.9985 s** |

The residual 1.5 ms is `atempo`'s frame granularity, not an error.

```bash
# Pitch down 20% (R=0.8), length preserved — the core-only chain
ffmpeg -i in.wav -af "asetrate=48000*0.8,aresample=48000,atempo=1.25" out.wav

# Pitch UP 20% (R=1.2): atempo takes 1/1.2 = 0.8333
ffmpeg -i in.wav -af "asetrate=48000*1.2,aresample=48000,atempo=0.8333" out.wav

# Varispeed on purpose — deeper AND longer, no atempo
ffmpeg -i in.wav -af "asetrate=48000*0.6,aresample=48000" out.wav      # 5.000s -> 8.333s [verified]
```

**Always read the source rate first** — `48000` is hardcoded above and is wrong for a 44.1 kHz asset. `ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate -of csv=p=0 in.wav`.

**`rubberband` — the quality option, when the host has it.** One filter, no chain, and the length is preserved *exactly* rather than to within a frame: `rubberband=pitch=0.6` on the same 5.000 s source returned **5.000000 s**. **[verified]** Confirmed options, read from `-h filter=rubberband`: **[verified]**

| Option | Values | Note |
|---|---|---|
| `pitch` | 0.01–100 (default 1) | scale factor, not semitones |
| `tempo` | 0.01–100 (default 1) | independent of `pitch` |
| `transients` | `crisp` (default) · `mixed` · `smooth` | `crisp` protects impacts |
| `detector` | `compound` (default) · `percussive` · `soft` | |
| `phase` | `laminar` (default) · `independent` | |
| `window` | `standard` (default) · `short` · `long` | |
| `smoothing` | `off` (default) · `on` | |
| `formant` | `shifted` (default) · `preserved` | `preserved` keeps a voice from turning chipmunk |
| `pitchq` | `speed` (default) · `quality` · `consistency` | |
| `channels` | `apart` (default) · `together` | `together` keeps a stereo image coherent |

```bash
# The library's pitch-ratio-0.6 move, as sfx-pitch-ratio-point-six specs it
ffmpeg -i whoosh_raw.wav -af "rubberband=pitch=0.6:formant=shifted:pitchq=quality" whoosh_06.wav
```

**Choosing between them.** `rubberband` for anything tonal, anything with a voice, and any shift beyond about ±15% where the core chain's artefacts start to show. The `asetrate` chain when the note must run on an unknown host, when the material is a short transient (a whoosh, an impact — a phase vocoder has little to work with in 300 ms anyway), or when varispeed *is* the aesthetic.

**The `atempo` range limit, and chaining past it.** The floor is the real constraint: **`atempo` will not go below 0.5**, verified above. To slow further, chain — the factors multiply:

```bash
ffmpeg -i in.wav -af "atempo=0.5,atempo=0.5" out.wav    # 0.25x -> 5.000s became 19.94s [verified]
ffmpeg -i in.wav -af "atempo=0.5,atempo=0.8" out.wav    # 0.40x
```

Above 1.0 this build needs no chaining (`atempo=3.0` ran clean), but chaining two moderate factors instead of one extreme one is still the better-sounding choice for large speed-ups, and it is what keeps a note portable to a build with the old 2.0 ceiling. **[unverified]** — the quality claim is documentation and ear, not something measured here.

> **Worked example — a whoosh pitched down 20%.** The library's own finishing chain, from `sfx-pitch-ratio-point-six`, on a 0.72 s whoosh. Note the reverse-fade idiom: `afade` only does fade-*in* cheaply at an arbitrary point, so a tail fade is written as reverse → fade-in → reverse. **[verified]**
>
> ```bash
> ffmpeg -i whoosh_raw.wav -af "\
>   atrim=start=0.2:end=0.92,asetpts=PTS-STARTPTS,\
>   asetrate=48000*0.8,aresample=48000,atempo=1.25,\
>   highpass=f=50,lowpass=f=7500,\
>   afade=t=in:d=0.02,areverse,afade=t=in:d=0.05,areverse" \
>   whoosh_final.wav
> ```
>
> Trim to the audible event, shift down 20%, restore the length, clear the rumble and the sibilance, then a 20 ms head fade and a 50 ms tail fade so neither end clicks. On a host with librubberband, swap the middle line for `rubberband=pitch=0.8:pitchq=quality`.

### 7B.3 Fades and joins

**`afade`** — 35 notes. Confirmed options: `type`/`t` (`in`|`out`), `start_time`/`st`, `duration`/`d`, `start_sample`/`ss`, `nb_samples`/`ns`, `curve`/`c`. **[verified]**

**The curve default is a trap.** `curve` defaults to **`tri`** (linear) on both `afade` and `acrossfade`. A linear crossfade dips roughly **3 dB at the midpoint** on uncorrelated material, because two uncorrelated signals at half amplitude sum to less than one at full. `qsin` (quarter sine) is the equal-power curve and holds the level across the join — which is why `cut-audio-match` specifies `qsin` and calls `tri` out by name. **Write the curve explicitly; do not take the default.**

The full confirmed curve set, 24 values — `nofade` `tri` `qsin` `esin` `hsin` `log` `ipar` `qua` `cub` `squ` `cbr` `par` `exp` `iqsin` `ihsin` `dese` `desi` `losi` `sinc` `isinc` `quat` `quatr` `qsin2` `hsin2`. **[verified]** In practice the library needs four: **`qsin`** equal-power (joins), **`tri`** linear (level-matched or correlated material), **`log`** (natural-sounding fade-out of a tail), **`exp`** (slow start).

```bash
# Head and tail fades, equal-power, explicit
ffmpeg -i in.wav -af "afade=t=in:st=0:d=0.2:curve=qsin,afade=t=out:st=4.8:d=0.2:curve=qsin" out.wav
```

**`acrossfade`** — 22 notes. Two inputs, one output. Confirmed options: `nb_samples`/`ns`, `duration`/`d`, `overlap`/`o` (default **true**), `curve1`/`c1`, `curve2`/`c2`. **[verified]**

`overlap=1` (the default) means the join **shortens the total**: two 5.000 s files crossfaded at `d=0.2` produced **9.800 s**, not 10.0 s. **[verified]** That is almost always what you want, and it is the number to use when computing a timeline position for whatever follows.

**`concat`** — 19 notes, and already covered in §7 in its *demuxer* form (`-f concat -safe 0 -i list.txt -c copy`), which is the fast, no-re-encode path. The **filter** form is the one to use when the streams differ or when the join sits inside a filtergraph:

```bash
# concat FILTER — re-encodes, but tolerates differing formats
ffmpeg -i a.wav -i b.wav -filter_complex "[0:a][1:a]concat=n=2:v=0:a=1[o]" -map "[o]" out.wav
ffmpeg -i a.mp4 -i b.mp4 -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0[o]" -map "[o]" out.mp4
```
Use the §7 demuxer form when the inputs are already identical in codec and format — it is a copy, not a re-encode.

**`xfade`** — 5 notes, the video counterpart. `offset` is the time **in the output** at which the transition starts, so it is `(duration of A) − (transition duration)`. Two 3.0 s clips with `duration=0.4:offset=2.6` produced **5.600 s** = 2.6 + 3.0. **[verified]** The 56 confirmed transition names: `custom fade wipeleft wiperight wipeup wipedown slideleft slideright slideup slidedown circlecrop rectcrop distance fadeblack fadewhite radial smoothleft smoothright smoothup smoothdown circleopen circleclose vertopen vertclose horzopen horzclose dissolve pixelize diagtl diagtr diagbl diagbr hlslice hrslice vuslice vdslice hblur fadegrays wipetl wipetr wipebl wipebr squeezeh squeezev zoomin fadefast fadeslow hlwind hrwind vuwind vdwind coverleft coverright coverup coverdown`. **[verified]** These are **ffmpeg's** names and are a different namespace from §4's HyperFrames transition registry — do not cross-cite them.

> **Worked example — a 6-frame audio crossfade at 30 fps.** 6 ÷ 30 = **0.2 s**. Equal-power both sides, which is the library's default for a join between two unrelated sounds. **[verified]**
>
> ```bash
> ffmpeg -i sceneA.wav -i sceneB.wav \
>   -filter_complex "[0][1]acrossfade=d=0.2:c1=qsin:c2=qsin[o]" -map "[o]" join.wav
> ```
>
> Frame-count conversions at the rates this vault actually meets — and always convert at the *source's* rate, per §7A.8: **6 f @ 30 fps = 0.200 s** · 6 f @ 25 fps = 0.240 s · 6 f @ 60 fps = 0.100 s · 6 f @ 29.97 fps = 0.2002 s. `cut-audio-match`'s researched 8–15 frame band is 0.27–0.50 s at 30 fps.

### 7B.4 Level and dynamics

**`volume`** — static gain, and the single most-cited audio filter in the library. Takes dB or a linear factor: `volume=-6dB` or `volume=0.5`. Confirmed options: `volume`, `precision`, `eval`, `replaygain`, `replaygain_preamp`, `replaygain_noclip`. **[verified]** With `eval=frame` the value may be an expression in `t`, which is the poor man's automation lane — but inside HyperFrames use a `data-automation` lane instead (§5.2); this filter is for baked exports only.

**`loudnorm` and `ebur128`** — both already documented, and this section does **not** restate them. `loudnorm`'s two-pass form is in **§7**; `ebur128` measurement and the loudness targets are in **§7A.5**. The one thing to add here is ordering: **`loudnorm` goes last**, after every other filter in the chain, because it normalises what it is handed.

**`alimiter`** — 7 notes. A ceiling, not a sound. Confirmed options: `level_in`, `level_out`, `limit`, `attack`, `release`, `asc`, `asc_level`, `level`, `latency`. **[verified]** `limit` is **linear, not dB**: −1 dBFS is `0.891`, −0.5 dBFS is `0.944`, −2 dBFS is `0.794`. Set `level=disabled` or the filter auto-gains the output up to the ceiling, which is rarely wanted after a `loudnorm` pass.

```bash
ffmpeg -i in.wav -af "alimiter=limit=0.891:attack=5:release=50:level=disabled" out.wav   # -1 dBFS ceiling
```

**`alimiter`'s `limit` is a sample-peak limit, and a true-peak target cannot be guarded on the master WAV.** **[measured
on real media]** This is the correction that a real build forced, and it invalidates the obvious workflow of limiting the
mix and calling the number final. Two overshoots stack *after* the master is written:

1. `limit` constrains **sample** peaks. True peak is measured on the 4×-oversampled reconstruction, so inter-sample
   peaks sit above the last sample the limiter saw. A file held at `limit=0.841` (−1.5 dBFS) can still measure worse
   than −1.5 dBTP.
2. The **AAC encode adds its own overshoot** on top of that — lossy quantisation moves waveform peaks, in either
   direction, and nothing in the audio chain knows it is coming.

The consequence for the pipeline: **the true-peak number moves after the guard runs**, so a guard on `mix.wav` is
necessary and not sufficient. The order that actually converges is

```
guard (alimiter / loudnorm TP) → mux → measure ebur128=peak=true on the DELIVERABLE → correct → re-mux
```

and the re-mux costs almost nothing, because the picture is stream-copied and only the audio is re-encoded (see
`build-and-render.md` §4). Aiming the guard ~0.5 dB under the target lands about **−1.6 dBTP** against a −1.5 dBTP
spec on real media.

Two rules follow, and both are the kind that get quietly broken:

- **Measure the deliverable, never the master**, whenever the target is stated in dBTP.
- **Give the gate no tolerance above the target.** A gate written as "≤ −1.5 dBTP, +0.1 allowed" passes a file measuring
  −1.4 dBTP — a gate tolerating exactly the failure it exists to catch.

**`acompressor`** — 2 notes. Confirmed options: `level_in`, `mode`, `threshold`, `ratio`, `attack`, `release`, `makeup`, `knee`, `link`, `detection`, `level_sc`, `mix`. **[verified]** `threshold` is linear too (`0.03` ≈ −30 dBFS, `0.125` ≈ −18 dBFS). `attack`/`release` are **milliseconds**.

**`compand`** — the general-purpose transfer-curve compressor. Not cited by any note in the library; documented here because it is the substitute for `acompressor` and `agate` on a build that somehow lacks them, and because its `points` form does things a ratio-and-threshold compressor cannot. Confirmed options: `attacks`, `decays`, `points`, `soft-knee`, `gain`, `volume`, `delay`. **[verified]**

```bash
ffmpeg -i in.wav -af "compand=attacks=0.1:decays=0.3:points=-90/-90|-30/-15|0/-6" out.wav
```
`points` is a dB-in/dB-out transfer curve: below −30 dB is untouched, −30 dB maps to −15 dB, 0 dB maps to −6 dB.

**`agate`** — 1 note. Confirmed options: `level_in`, `mode`, `range`, `threshold`, `ratio`, `attack`, `release`, `makeup`, `knee`, `detection`, `link`, `level_sc`. **[verified]** Note this is the ffmpeg gate; §10 is explicit that HyperFrames' own `room-gate` *"closes gaps; noise under speech is untouched"* — the same limitation applies here, and neither is a noise remover.

**`sidechaincompress` — the real ducking primitive.** This is the one that deserves the space, because the library now carries a ducking note (`sfx-ducking-keyframed-dip`) and because it is the only mechanism here that ducks *automatically off the voice* rather than off an envelope somebody drew.

It takes **two inputs and returns one**: input 0 is the signal that gets compressed (the music bed), input 1 is the **sidechain key** that triggers it (the dialogue). The key is only listened to — it is not in the output. Getting the order backwards ducks the voice under the music, which is the classic failure and is silent.

Confirmed options, from `-h filter=sidechaincompress`: **[verified]**

| Option | Meaning | Note |
|---|---|---|
| `threshold` | key level above which ducking starts | **linear**: `0.03` ≈ −30 dBFS |
| `ratio` | depth of the duck | 8–20 for a firm duck under narration |
| `attack` | ms to duck **down** | short (5–50) so the first syllable is not lost |
| `release` | ms to come **back up** | long (200–500); short releases pump audibly |
| `makeup` | output gain after the duck | |
| `knee` | how gradually the ratio engages | |
| `link` | `average` · `maximum` | how the key's channels are combined |
| `detection` | `peak` · `rms` | `rms` follows speech energy; `peak` chases consonants |
| `mode` | `downward` · `upward` | `downward` is ducking |
| `level_in`, `level_sc`, `mix` | input trim, key trim, dry/wet | |

**Where this belongs in the stack.** §5.3 ranks three in-pipeline ducking routes and §7's decision table says bake *"only for assets leaving the pipeline."* That still holds — inside a composition, use `data-fx-carve` or a `volume` lane. `sidechaincompress` is for the export leg, for a bed handed to another tool, or for **measuring what depth actually sounds right** before writing the lane values into the composition.

> **Worked example — a music bed ducked under dialogue.** Bed trimmed to the library's `data-volume="0.079"` neighbourhood is a composition concern; here the bed is set to 0.6 and ducked 8:1 off the voice. `attack=20` catches the first word, `release=300` returns between phrases without pumping, `detection=rms` follows speech energy rather than consonant peaks. **[verified]**
>
> ```bash
> ffmpeg -i bed.wav -i vo.wav -filter_complex "\
>   [0]volume=0.6[bed];\
>   [bed][1]sidechaincompress=threshold=0.03:ratio=8:attack=20:release=300:\
> makeup=1:detection=rms:link=average[duck]" \
>   -map "[duck]" bed_ducked.wav
> ```
>
> Then verify rather than trust it, using §7A's measurement filters — `silencedetect` on the voice gives the trigger windows, `astats` with a reset interval gives the RMS actually achieved inside and outside them:
> ```bash
> ffmpeg -i vo.wav -af silencedetect=noise=-35dB:d=0.4 -f null -
> ffmpeg -i bed_ducked.wav -af asetnsamples=n=1600,astats=metadata=1:reset=1 -f null - 2>&1 | grep RMS
> ```
> `sfx-ducking-keyframed-dip` specs `release=400` and a 0.5 lane factor (≈ −6 dB); the 200–500 ms band is the one to stay inside.

**Other audio shaping in the cited set**, all **[verified]** as running here:

```bash
ffmpeg -i in.wav -af "equalizer=f=1000:t=q:w=1:g=-3" out.wav        # one parametric band; g in dB
ffmpeg -i in.wav -af "afftdn=nr=12:nf=-25" out.wav                   # broadband denoise; nf is the noise floor in dB
ffmpeg -i in.wav -af "stereotools=mlev=1:slev=1.2" out.wav           # widen by lifting the side signal
ffmpeg -i in.wav -af "adelay=0|18:all=0" out.wav                     # 18 ms on the right only — Haas widening
ffmpeg -i in.wav -af "aecho=0.8:0.88:60:0.4" out.wav                 # in_gain:out_gain:delays(ms):decays
ffmpeg -i in.wav -af "areverse" out.wav                              # buffers the whole stream
ffmpeg -i in.wav -af "atrim=start=0.2:end=0.92,asetpts=PTS-STARTPTS" out.wav   # -> 0.720s
ffmpeg -i a.wav -i b.wav -filter_complex "[0][1]amix=inputs=2:duration=longest:weights=1 0.5:normalize=0[o]" -map "[o]" out.wav
```

Three traps in that block, each verified or documented as marked:
- **`atrim` without `asetpts=PTS-STARTPTS` leaves the timestamps where they were**, so the trimmed audio starts late in the output. Always pair them. **[verified]** — the 0.720 s result above is with the pair.
- **`amix` normalises by default.** `normalize=1` (the default) divides by the number of inputs, so mixing two files quietly halves both. Set `normalize=0` and control level with `weights`. **[verified]** that both options parse and run.
- **`amerge` is not `amix`.** `amerge` stacks inputs into a multi-channel stream (2 stereo in → 4 channels out); `amix` sums them. One note cites `amerge`; if what it wants is a sum, it wants `amix`.

### 7B.5 Analysis — see §7A

Deliberately not duplicated. The measurement filters this section's workflows depend on are all documented, and in most cases verified, in **§7A**:

| Need | Section |
|---|---|
| Shot boundaries — `scdet`, `select='gt(scene,N)'` | §7A.1 |
| Silence and pause windows — `silencedetect` | §7A.2 |
| Level and spectral measurement — `astats`, `aspectralstats` | §7A.3 |
| Audio as a picture — `showspectrumpic`, `showwavespic` | §7A.4 |
| Programme loudness — `ebur128`, `loudnorm` | §7A.5 |
| Frame extraction for motion timing | §7A.6 |
| Beat and tempo — `librosa` (not installed here) | §7A.7 |
| Reading fps, and never assuming it | §7A.8 |

The rule that joins the two sections: **measure with §7A before and after every §7B operation.** A pitch shift that also moved the loudness, a duck that never reached its target depth, and a crossfade that clicks are all invisible without a measurement, and all three are cheap to check.

### 7B.6 Video

Eight video filters in the cited set beyond §7's `crop`/`scale`/`concat`. All **[verified]** as running here on a 640×360 30 fps test source.

```bash
# Grade — contrast/brightness/saturation/gamma
ffmpeg -i in.mp4 -vf "eq=contrast=1.06:saturation=1.12:gamma=0.98" out.mp4

# Speed — setpts multiplies the timestamps: 0.5*PTS is 2x FASTER, 2.0*PTS is 2x slower
ffmpeg -i in.mp4 -vf "setpts=0.5*PTS" -an out.mp4

# Blur — gblur is better, boxblur is faster
ffmpeg -i in.mp4 -vf "gblur=sigma=8" out.mp4
ffmpeg -i in.mp4 -vf "boxblur=luma_radius=4:luma_power=1" out.mp4

# Letterbox to 9:16 without cropping
ffmpeg -i in.mp4 -vf "scale=1080:-2,pad=1080:1920:(ow-iw)/2:(oh-ih)/2:color=black" out.mp4

# Rotate — angle in RADIANS, expression may use t
ffmpeg -i in.mp4 -vf "rotate=2*PI*t/8:fillcolor=black" out.mp4

# Vignette, and motion trails
ffmpeg -i in.mp4 -vf "vignette=angle=PI/5" out.mp4
ffmpeg -i in.mp4 -vf "tblend=all_mode=average:all_opacity=0.5" out.mp4

# Ken Burns — zoompan. d=1 with an explicit fps is the per-frame form.
ffmpeg -i in.mp4 -vf "zoompan=z='min(zoom+0.0015,1.15)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=640x360:fps=30" -an out.mp4

# Burn-in text (needs libfreetype) and burn-in subtitles (needs libass)
ffmpeg -i in.mp4 -vf "drawtext=text='HELLO':fontcolor=white:fontsize=48:x=(w-tw)/2:y=(h-th)/2" out.mp4
ffmpeg -i in.mp4 -vf "subtitles=cues.srt:force_style='FontName=DejaVu Sans,Fontsize=28,PrimaryColour=&H00FFFFFF&'" out.mp4
```

Notes on the two flag-dependent ones, both **[verified]** here:

- **`drawtext`** ran both with and without `fontfile=`, because this build has `--enable-libfontconfig` and can resolve a font by name. On a build with libfreetype but *without* fontconfig, **`fontfile=` is mandatory** and the bare form fails. Write `fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf` in any note that must be portable. Confirmed options include `fontfile`, `text`, `textfile`, `fontcolor`, `boxcolor`, `bordercolor`, `shadowcolor`, `box`, `boxborderw`, `line_spacing`, `fontsize`, `text_align`, `x`, `y`, `borderw`, `shadowx`, `shadowy`, `alpha`, `enable`. **[verified]**
- **`subtitles`** confirmed options: `filename`/`f`, `original_size`, `fontsdir`, `alpha`, `charenc`, `stream_index`/`si`, `force_style`, `wrap_unicode`. **[verified]** `force_style` takes ASS style keys. **Set `original_size` when the subtitle file was authored against a different resolution than the video**, or the type is scaled wrongly with no warning.

**The standing caveat for all eleven subtitle-citing notes:** §6.1 says HyperFrames has **no caption primitive** and §10 repeats it. `subtitles` and `drawtext` burn pixels into a file — they are an *export* path, not a way to get captions into a composition. A note that specs `subtitles=` is specifying a baked deliverable; a note that wants captions in the timeline wants §6.

> **Worked example — a 12-frame video cross-dissolve at 30 fps.** 12 ÷ 30 = **0.4 s**. `offset` is where the transition begins in the output, which for a 3.0 s first clip is 3.0 − 0.4 = **2.6**. Produced 5.600 s from two 3.0 s clips. **[verified]**
>
> ```bash
> ffmpeg -i shotA.mp4 -i shotB.mp4 \
>   -filter_complex "[0][1]xfade=transition=fade:duration=0.4:offset=2.6[o]" \
>   -map "[o]" -an dissolve.mp4
> ```
>
> Both inputs must share resolution, pixel format and frame rate or `xfade` refuses the graph; `scale` and `fps` them first. Inside a composition, use §4's transition registry instead — this is the export path.

### 7B.7 Not available here

Short, and every entry was established by running something.

- **`arnndn` cannot run in this container.** It is in `ffmpeg -filters`, but it has no bundled model and `model` has no usable default: `ffmpeg -i in.wav -af arnndn out.wav` fails with `Error initializing filters`. **[verified]** Models are separate `.rnnn` files from the `rnnoise-models` project and none is present. **Use `afftdn` instead** — it runs here, needs no external data, and `afftdn=nr=12:nf=-25` is a reasonable starting point for broadband hiss. The single note citing `arnndn` should either switch to `afftdn` or state the model file as a prerequisite. Note §10's harder truth still applies: neither filter removes noise *under* speech, and *"a source with audible hiss needs a better source."*
- **No core pitch-shift filter.** If `librubberband` is missing, there is no one-filter pitch shift; the `asetrate` + `aresample` + `atempo` chain of §7B.2 is the whole answer, at lower quality and with no formant preservation.
- **`atempo` will not go below 0.5** in a single instance. **[verified]** Chain it.
- **`librosa` is still not installed** — §7A.7 and §10 already record this; nothing in §7B depends on it.
- **Nothing here is verified on the device VM.** Every result in this section is from the container's `ffmpeg 6.1.1-3ubuntu5`. The three flag-dependent filters — `rubberband`, `subtitles`, `drawtext` — are exactly the ones to re-check before a build depends on them elsewhere.

**What this section closes.** All 31 filters cited by the library's Execution specs are now documented, 30 of them verified as running here and one (`arnndn`) verified as *not* running with a stated substitute. The house rule — *anything not in here is not known to run* — now holds across the ffmpeg surface: §7 for container operations, §7A for measurement, §7B for signal manipulation.

---

## 8. CLI surface

All commands are `npx hyperframes <cmd>`; the project's `package.json` wraps the common ones and **pins an exact `hyperframes@X.Y.Z`** so renders stay reproducible.

### Project scripts (`CLAUDE.md`)

```bash
npm run dev          # human-operated foreground preview (blocks until stopped)
npm run check        # lint + runtime + layout + motion + contrast (one command)
npm run render       # render to MP4
npm run publish      # publish and get a shareable link
```

### The agent-facing forms

```bash
npx hyperframes preview --background   # agent-safe persistent Studio preview
npx hyperframes preview --status       # verify the persistent preview is listening
npx hyperframes preview --stop         # stop it when review is finished
npx hyperframes lint --verbose         # include info-level findings
npx hyperframes lint --json            # machine-readable output for CI
npx hyperframes docs <topic>           # reference docs in terminal (no network)
```

`docs` topics: `data-attributes`, `gsap`, `compositions`, `rendering`, `examples`, `troubleshooting`.

**Agents must use `preview --background`, not a `run_in_background` wrapper around `npm run dev`** — *"that foreground process remains owned by the invoking session and can disappear while the browser stays open, leaving refreshes at `ERR_CONNECTION_TIMED_OUT`."*

### What each command gates

| Command | Gates / produces |
|---|---|
| `lint` | Static rules only. An **error** switches off the layout and contrast audits (see §2) — `check` then reports `0 sample(s)` / `0/0 text checks`, which looks clean and means nothing ran. |
| `check` | The composite gate: **lint + runtime + layout + motion + contrast**. Target is *"0 findings"*. *"Fix all errors before presenting the result. Warnings should be reviewed before rendering."* |
| `snapshot --at <midpoints>` | Frame stills. **Required** for projects with sub-compositions, and the only real defence against the silent root-sizing bug and the silent relative-timing zeros. |
| `preview` (Studio) | The **review surface**, not just a viewer — full timeline editor, user can edit by hand before rendering. Default port **3002**. |
| `play` | Lightweight `<hyperframes-player>` player, default port **3003**. No editor. |
| `render` | The only thing that makes an MP4. *"Render only after the user has reviewed in `preview` and approved. Don't auto-render when the checks pass."* |
| `publish` | Uploads source (HTML + assets), returns a stable public URL that renders in the browser. Lint findings are surfaced but **do not block**. |
| `feedback` | One line per task after a verified render. `--rating` 0–10 (required), `--comment`. |
| `transcribe` | Word-level transcript (Parakeet default, whisper fallback). |
| `remove-background` | u2net background removal. |
| `media-treatment` | Footage treatment capabilities/analysis/persistence (`--capabilities --json`, `--capability <id>`, `--selector '#hero' --analyze --json`). |
| `skills update <name>` | Installs/refreshes one skill. Bare `skills update` refreshes the core set plus everything already installed. **Restart the agent session** so new skills load. |
| `upgrade --project . --check` | Read-only probe of the pinned CLI version against latest; without `--check` it rewrites the pins. Always run as `npx hyperframes@latest`. Keep the explicit `.`. |

**Handing back a preview URL** — the Studio project URL, not the file path:

```
http://localhost:<port>/#project/<project-name>
```

Storyboard view instead of the timeline: `http://localhost:<port>/?view=storyboard#project/<project-name>`. Two ways a handed URL is dead: missing the `#project/<name>` hash, or the server is not running. Verify HTTP 200.

**Agent bridge into a running Studio** — for deictic instructions ("change this", "the card I clicked"):

```bash
npx hyperframes preview --context --json --context-fields selection
npx hyperframes preview --context --json --context-fields lint
npx hyperframes preview --selection --json
```

Payload includes source file, composition path, current timeline time, `data-hf-id` / selector target, bounding box, text, thumbnail URL. **Prefer `selection.target.hfId`**; fall back to `selection.target.selector`. `--context-detail full` only when you need `computedStyles` / `inlineStyles` / `dataAttributes`. Failure codes: `preview-not-running`, `ambiguous-preview-server`, `preview-port-mismatch`, `no-selection`, `selection-unavailable`. *"Do not infer the target from a screenshot when the CLI can give a stable element target."*

### `render` flags (the full staged table)

| Flag | Options | Default | Notes |
|---|---|---|---|
| `dir` (positional) | path | cwd | project directory |
| `--composition`, `-c` | path | `index.html` | render a specific sub-composition file |
| `--output`, `-o` | path | `renders/<project>_<YYYY-MM-DD>_<HH-MM-SS>.<ext>` | timestamped so runs don't clobber |
| `--fps` | 24, 30, 60 | **30** | 60fps doubles render time |
| `--quality` | draft, standard, high | standard | draft while iterating, standard for review, high for final |
| `--format` | mp4, webm, mov, gif, png-sequence | mp4 | WebM/MOV render with transparency; gif = two-pass palette, fps capped 30 (prefer `--fps 15`), **no audio**, 1-bit transparency, HDR→SDR; png-sequence writes RGBA frames |
| `--gif-loop` | 0–65535 | 0 | `0` loops forever; gif only |
| `--resolution` | landscape, portrait, landscape-4k, portrait-4k, square, square-4k (+ `1080p`, `4k`, `uhd`) | — | supersample via Chrome `deviceScaleFactor`; aspect must match composition; scale must be integer; not with `--hdr` |
| `--crf` | 0–51 | — | mutually exclusive with `--video-bitrate` |
| `--video-bitrate` | e.g. `10M`, `5000k` | — | mutually exclusive with `--crf` |
| `--hdr` / `--sdr` | flag | off | force HDR (MP4 only) / force SDR |
| `--workers` | number or `auto` | auto | each worker spawns Chrome (~256 MB) |
| `--docker` | flag | off | **byte-identical / reproducible across hosts** |
| `--gpu` | flag | off | GPU FFmpeg encoding (NVENC / VideoToolbox / VAAPI / QSV) |
| `--browser-gpu` / `--no-browser-gpu` | flag | auto (local), off (docker) | host GPU for Chrome/WebGL capture |
| `--browser-timeout` | seconds 0.001–86400 | 60 | Puppeteer navigation timeout; raise for heavy compositions |
| `--quiet` | flag | off | |
| `--strict` | flag | off | fail on lint **errors** |
| `--strict-all` | flag | off | fail on errors **and warnings** |
| `--variables` | JSON object keyed by id | — | overrides `data-composition-variables` defaults |
| `--variables-file` | path | — | alternative to `--variables` |
| `--strict-variables` | flag | off | fail on undeclared keys or type mismatches |

Parametrized renders: the composition declares the **schema** on `<html>` as `data-composition-variables` (a JSON **array** of `{id, type, label, default}`); scripts read resolved values via `window.__hyperframes.getVariables()`; `--variables '{"title":"Q4 Report"}'` is a JSON **object keyed by id**. Missing keys fall through. Sub-comp hosts override per-instance with `data-variable-values`. **Remember the root `data-duration` is compile-time-locked and cannot be varied this way.**

`preview` and `play` can also launch an explicit Chromium: `--browser-path`, `--user-data-dir` (requires `--browser-path`), `--remote-debugging-port` (requires **both** of the former, *"so a CDP endpoint cannot leak into your main profile by accident"*). *"HyperFrames itself does not own CDP automation"* — it only exposes the endpoint. Not to be confused with `--browser-gpu`.

`play`'s `playback-rate` attribute is clamped to `[0.1, 5]`; values ≤0 or non-finite fall back to `1`. It is a **preview knob**, not a composition attribute — *"authored motion still renders at 1×."*

### Validation checklist (from `hyperframes-core/SKILL.md`)

- [ ] `npx hyperframes check` passes (0 findings across lint, runtime, layout, motion, contrast)
- [ ] Projects with sub-compositions: `npx hyperframes snapshot --at <midpoints>` and eyeball each frame
- [ ] `npx hyperframes preview --background` for review
- [ ] `npx hyperframes render` **only after the user approves**

Also available: `node skills/hyperframes-animation/scripts/animation-map.mjs <composition-dir> --out <dir>/.hyperframes/anim-map` — reads every registered timeline, enumerates tweens, samples bboxes, outputs `animation-map.json`. Use it to audit choreography (dead zones, stagger consistency, lifecycle warnings) **after** authoring.

---

## 9. Known constraints in this project

**Record these verbatim. They are the difference between a spec that runs and one that does not.**

> - the mounted vault folder cannot delete files
> - cdn.jsdelivr.net is blocked by the egress allowlist so compositions must not load GSAP or any library from a CDN
> - the device VM is linux ARM64 without sudo so browser-dependent rendering must happen elsewhere

### What each one costs, concretely

**1. The mounted vault folder cannot delete files.**

Everything is append-or-overwrite. Consequences for the note library and for any pipeline that writes into the vault:

- Never design a workflow whose correctness depends on removing a file. The `.hyperframes/frame-comments.json` lifecycle in `storyboard-format.md` explicitly says *"revise exactly the frames named, **delete the file**, re-present"* — **that delete step cannot be performed in the vault.** Use a status field, a `pass` marker, or a superseding file instead, and say so in any note that touches the storyboard review loop.
- Same for `transcript-cut.mjs`'s temp-dir cleanup (`rmSync(tmpDir, …)`) and any `--out` overwrite pattern: keep scratch work **outside** the mount.
- Superseding a note means writing a new version and updating the index, not removing the old one.

**2. `cdn.jsdelivr.net` is blocked — compositions must not load GSAP or any library from a CDN.**

This directly breaks two staged files as written:

- `compositions/captions.html` line: `<script src="https://cdn.jsdelivr.net/npm/gsap@3.14.2/dist/gsap.min.js"></script>`
- `composition-patterns.md`'s modular orchestrator skeleton, same line.
- `techniques.md` also shows `https://cdnjs.cloudflare.com/.../lottie.min.js` and `https://cdn.jsdelivr.net/npm/gsap@3.14.2/dist/MotionPathPlugin.min.js`.

**Every one of those must become a local script reference.** GSAP has to be vendored into the project and loaded from a relative path. Any note that emits composition HTML must emit a local `<script src="…">` (or an inline bundle), never a CDN URL — and any note that quotes the upstream skeletons must annotate the substitution.

Knock-on effects to state in notes:

- `@hyperframes/shader-transitions` and GSAP plugins (`MotionPathPlugin`) must likewise be local packages, not CDN scripts.
- Fonts: the typography reference's *implicit build-time Google Fonts fetch* is a network path. Under an egress allowlist, treat it as unavailable — **use one of the 18 pre-bundled families, or embed your own `@font-face` with a local file**. The reference already warns the implicit path is *"fail-closed in distributed/cloud renders."*
- `techniques.md`'s font guidance already agrees: *"Load the captured local variable font — do NOT use Google Fonts @import."*
- The font-discovery script (`curl -s 'https://fonts.google.com/metadata/fonts'`) is a network call and may not work here.
- `media-use`'s HeyGen-CLI paths, `--doctor`, catalog retrieval, and `resolve --type bgm|sfx|image|voice` are all network paths. In this project **Epidemic Sound MCP is the sanctioned audio-sourcing route**; do not write specs that assume the HeyGen catalog is reachable.
- `hyperframes.heygen.com/llms.txt` (the full docs index) is a network fetch. Use `npx hyperframes docs <topic>` — explicitly *"no network required"* — as the offline substitute.

**3. The device VM is linux ARM64 without sudo — browser-dependent rendering must happen elsewhere.**

`render` drives Chrome via Puppeteer (`--workers` *"each worker spawns Chrome (~256 MB)"*, `--browser-gpu`, `--browser-timeout` is a *"Puppeteer page-navigation timeout"*). `snapshot`, `preview`/Studio, and the layout/contrast/perception audits inside `check` are all browser-dependent. The audio render path is likewise browser-hosted: *"an `OfflineAudioContext` in the headless browser."* And `animation-map.mjs` reads live timelines, so it too needs a browser.

Therefore, on the device VM:

- **Author, lint (static rules), and plan** — yes.
- **`check`'s browser-backed audits, `snapshot`, `preview`, `play`, `render`, `publish`-preview, `animation-map.mjs`, and shader/html2canvas capture** — must run **elsewhere**. `--docker` (*"reproducible output across hosts"*) is the natural target for the render leg, but Docker itself needs privileges this VM lacks.
- No `sudo` means no `apt`; anything needing a system install (Chrome/Chromium, ffmpeg if absent, `realesrgan-ncnn-vulkan`, `auto-editor`/`scenedetect` via pip) cannot be installed here as root.
- ARM64 rules out several documented paths: `parakeet-mlx` and `mflux`/FLUX-on-MLX and `ltx-2-mlx` are **Apple-silicon MLX** stacks — not available on linux ARM64. So the transcription default (Parakeet) and the local image/video generation ladders in `operations.md` are out; whisper.cpp fallback and non-local paths are what remain, subject to constraint 2.
- Practical rule for notes: **a technique note may specify a render, but must not assume the render happens on the authoring machine.** Treat the composition HTML + assets as the deliverable, and the MP4 as a downstream step with its own host.

---

## 10. What is NOT available

Honest gaps. A note author writing against anything in this list is writing a spec that cannot execute.

### Not in HyperFrames at all

- **No frame-based timing attribute.** No `data-frame`, no `data-start-frame`. Everything is seconds; `data-fps` is a hint the CLI can override. Frame counts must be converted at authoring time.
- **No speed-ramp envelope.** `data-playback-rate` is a **constant** in `0.1..5`. *"Source speed ramps are not supported because there is no rate envelope; preprocess a derived synchronized asset."*
- **No automatic waveform sync or drift correction.** Picture/sound alignment is authored by writing the same numbers on both elements.
- **No arbitrary mid-source freeze.** Requires a preprocessed still or segment.
- **No caption/subtitle primitive.** No `data-caption`, no SRT/VTT ingest, no built-in subtitle renderer. Captions are hand-authored compositions (§6).
- **No automatic face tracking or content-aware reframe.** Pan/Ken Burns is *"authored geometry, not automatic face tracking."*
- **No `width`/`height`/`top`/`left` tweens.** Forbidden; use scale/translate proxies, masks, or the `anchored-layout-expand` rule.
- **No CSS `transition` on animated elements** — they interpolate independently of seek.
- **No `repeat: -1`.** Finite counts only.
- **No render-time randomness or clocks.** Index-derived pseudo-random and baked schedules only.
- **No interactive/stateful spring solvers.** *"an interactive spring is a stateful integrator ... which cannot be seeked deterministically ... This is also why interaction-lib spring solvers are banned in compositions."*
- **No iframes for captured content.**
- **No `crossorigin` on media**, ever — *"There is no suppression."* Including for canvas/WebGL/WebAudio readback.
- **A sub-comp timeline cannot animate host-root elements.** Selectors do not cross the boundary.
- **The root `data-duration` cannot be varied per render.** Compile-time-locked; `--variables` and scripts cannot change render length.

### Not available in audio

- **De-essing.** *"`harsh-tame` is a broad always-on cut centred a band too low, not a de-esser."* Honest fallback: a narrow `peaking` cut in the Edge band — sweep 5–9 kHz, Q 3–4, −3 to −5 dB, always-on, costs a little air on every word.
- **Tone matching** one track to another. Fallback: the Tone EQ by hand.
- **Noise removal.** `room-gate` closes gaps; noise under speech is untouched. *"There is no fallback for hiss beneath the words — a source with audible hiss needs a better source, and saying so is the whole answer."*
- **Automation on `compressor`, `limiter`, `gate`, `bitcrush`** — zero automatable parameters (AudioWorklets configured wholesale). Also `saturate.type/threshold/oversample` and `reverb.size/damping`. Automate a `gain` stage around them instead.
- **A static carve mode.** *"There is no static mode."* Every carve follows speech.
- **Chain / lane validation.** *"Nothing validates the chain or the effect lanes at all."* Lint reads `data-automation` for exactly two conflicts. Render refuses an unparseable chain; preview plays it dry.
- **`data-fx-carve` on a bus.** Clip-only.

### Not staged in this project (names known, contents unknown)

Do not quote code or claim exact behaviour from these — they were referenced but not provided:

- `hyperframes-animation/rules/*.md` — all ~46 atomic rule recipes. Only names + tags are known (§3.10).
- `hyperframes-animation/transitions/catalog.md` and `css-*.md` — the ≈40-transition catalog with the actual GSAP. Only names are known (§4.2).
- `hyperframes-animation/blueprints-index.md` + `blueprints/*.md` — multi-phase scene templates.
- `hyperframes-animation/adapters/*` except `gsap-easing-and-stagger.md` — `gsap.md`, `gsap-transforms-and-perf.md`, `gsap-timeline-and-labels.md`, `lottie.md`, `three.md`, `animejs.md`, `css-animations.md`, `waapi.md`, `typegpu.md`, `html-in-canvas-patterns.md`, `animate-text.md` (the 24 named text effects live in an **external `animate-text` skill**).
- `hyperframes-core/references/` — `minimal-composition.md`, `sub-compositions.md`, `variables-and-media.md`, `determinism-rules.md`, `full-screen-motion.md`, `review-loop.md`, `production-loop.md`, `brief-format.md`, `script-format.md`, `subagent-dispatch.md`, `frame-worker-core.md`, `tailwind.md`. (`brief-contract.md` **is** staged but was not in the read set for this document.)
- `hyperframes-audio/references/diagnosis.md`, and `scripts/carve.mjs` itself.
- `media-use/references/` — `resolve.md`, `grading.md`, `media-treatments.md`, `setup-providers.md`, `memory.md`, `meta.md`; and `audio/references/{tts,bgm,sfx,transcribe,remove-background}.md` + `captions/`.
- `media-use/scripts/` — `resolve.mjs`, `audio-duck.mjs`, `dither.mjs`, `transcribe.mjs`, `audio.mjs`, `wait-bgm.mjs`, `lib/cutlist.mjs`. Only `transcript-cut.mjs` is staged.
- All workflow skills (`/product-launch-video`, `/faceless-explainer`, `/embedded-captions`, `/talking-head-recut`, `/pr-to-video`, `/motion-graphics`, `/music-to-video`, `/slideshow`, `/general-video`, `/remotion-to-hyperframes`), plus `/hyperframes-keyframes`, `/hyperframes-registry`, `/figma`, and the rest of `/hyperframes-cli` beyond `preview-render.md`.
- `hyperframes/references/` — `intent-interview.md`, `routes/*.md`, `skill-lifecycle.md`.
- `hyperframes-creative/references/{beat-direction,audio-reactive}.md` and `scripts/extract-audio-data.py`.

### Not verified as present in this environment

- **The `hyperframes` CLI itself, and the project's pinned `hyperframes@X.Y.Z`.** Nothing in the staged set proves it is installed here.
- ~~**ffmpeg / ffprobe.**~~ **Superseded — both are now verified present in this container**, `ffmpeg 6.1.1-3ubuntu5` at `/usr/bin/ffmpeg` and `/usr/bin/ffprobe`, along with every analysis filter §7A names. See §7A.0. What remains unverified is whether the **device VM** carries the same build; `visual-kt-delta.md` records contact sheets being generated there, so it has *an* ffmpeg, but not necessarily this one. State which host a measurement was taken on.
- **`librosa`.** Not installed in this container (`ModuleNotFoundError`, verified). It *is* installable — `pip download librosa` reached PyPI and fetched 0.11.0 — but the install has not been run, so nothing in §7A.7 has been executed.
- **The Epidemic Sound asset hosts.** The MCP tools themselves are present and their schemas are read in §5A, but **no `assetUrl` was fetched while writing this document.** A tool returning a URL is not proof the URL is retrievable through the egress allowlist (constraint 2). Test the fetch leg once before a build depends on it.
- **`@hyperframes/core`** — `carve.mjs` requires it in the project (`npm i -D @hyperframes/core`) and *"cannot be borrowed"* from the CLI.
- **GSAP as a local package.** Required by constraint 2, and the staged compositions do not have it.
- **`@hyperframes/shader-transitions`.**
- **`heygen` CLI + auth**, and everything behind it (TTS, catalog retrieval, avatar video, background-removal quality path, lipsync, translate).
- **Optional tools** referenced in `operations.md`: `auto-editor`, `scenedetect`, `realesrgan-ncnn-vulkan`, `parakeet-mlx`, `mflux`, `ltx-2-mlx`, `codex` CLI, `whisper.cpp`.
- **Remotion.** Not part of this stack. It appears only as a **source format to port from** via `/remotion-to-hyperframes` (*"a source migration, separate from the creation workflows"*), and that workflow skill is not staged. Any note assuming a Remotion runtime, a `<Composition>` component, `useCurrentFrame()`, or Remotion's `fps`-native frame model is writing against something that **does not exist in this project.**

### Ambiguities in the staged set — flagged, not guessed

- `compositions/captions.html` has root `data-duration="10"` while its transcript runs to `16.02s`. The staged files do not say whether this is deliberate. Per the timing model, the extra 6s of timeline would be cut off.
- `hyperframes-core/SKILL.md` says `window.__timelines = window.__timelines || {}` is no longer needed, while `captions.html`, `composition-patterns.md`, and `creator-editing-recipes.md` all still write it. Harmless either way; not a contradiction to resolve, just a version skew to expect in examples.
- `attributes.md` requires audio JSON attributes to be **double-quoted with `&quot;`** for `carve.mjs`'s regex, while `creator-editing-recipes.md` uses single quotes throughout. Both parse in the browser; only the first survives `carve.mjs`. Which one a given tool wrote is not recoverable from the file.
- The staged `TRANSITION-REGISTRY.md` describes an injector at `product-launch-video/scripts/inject-transitions.mjs` and a planner at `product-launch-video/agents/visual-design.md`. **Neither is staged**, so the injector's behaviour is known only from the registry's own description (which does cite verified render evidence dated 2026-05-31).
- `push-slide`'s templates reference `__DXIN__` / `__DYIN__` tokens that are **not listed** in the registry's placeholder table (which documents `__DX__` / `__DY__`). Presumably the incoming element's opposite-sign travel; the staged file does not define them.
