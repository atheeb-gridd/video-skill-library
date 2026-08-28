---
id: motion-graphics-broll-slot
title: Motion graphics fill the B-roll slot when the beat is important but boring
skill: motion
type: graphic
family: b-roll
tags: [skill/motion, type/graphic, family/b-roll, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:53"
    quote: "A few variations of B-roll are stock footage, which is basically the easy version, and motion graphics."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:04:20"
    quote: "Motion graphics and animation are the variation that explains important but boring parts crystal clear and fast."
research_refs:
  - https://legibility.info/rules-for-text-in-videos
  - https://vsubtitle.com/subtitle-font-size-and-reading-speed-2026/
  - https://docs.manim.community/en/stable/tutorials/output_and_config.html
  - https://www.designer-daily.com/motion-graphics-that-actually-communicate-lessons-from-explainer-videos-213110
difficulty: high
detectable_from: video
---

# Motion graphics fill the B-roll slot when the beat is important but boring

## What it is
A motion graphic is B-roll you build rather than shoot. It sits in exactly the same slot — a cutaway that gives the eye something new while the voice keeps talking — but it is the only option that can show a thing that has **no photograph**: a process, a comparison, a number changing, a relationship between parts, a before/after. The distinguishing property is that it is *made of the argument*. Stock shows you a server rack; a motion graphic shows you what the request does when it reaches the rack. That is why the source singles it out for the "important but boring" beats: those are exactly the beats where footage exists but explains nothing.

## When to use it
Four triggers, and they are all in the transcript rather than in the footage. **(1) A mechanism** — the sentence contains "because", "which means", "so then", or a chain of steps. **(2) A comparison or a quantity** — two options, a percentage, a change over time, a list with structure. **(3) A term being defined** ([[struct-name-define-demonstrate]]) — the label wants to appear as an object, not as a caption. **(4) A beat that is load-bearing but visually inert** — pricing, policy, architecture, workflow. Do *not* reach for one when a real shot exists and would be clearer: a motion graphic of a person opening a laptop is worse than a shot of a person opening a laptop, and costs an order of magnitude more. Budget accordingly — a graphic is the most expensive item per second in the edit, so spend it on the two or three beats the whole video turns on, and let stock and shot B-roll carry the rest ([[cut-stock-footage-substitute]]).

## How to recognise it in a reference video
- **Non-photographic frames under continuous narration.** Flat fills, vector edges, no lens noise, no grain, perfect geometry. Sample a frame and look at the histogram: a designed graphic has spikes at a handful of exact values where footage has continuous distributions.
- **Elements enter, they do not appear.** Look for staggered arrivals: 3–7 items landing **60–150 ms apart**, total arrival under ~0.5 s. A cut to a fully-formed diagram is a slide; a staggered build is a motion graphic.
- **The build tracks the sentence.** Align the transcript. In a well-made graphic each element arrives on or just after the word that names it, within **±6 f (±0.2 s)**. If the whole diagram arrives at once and the voice then walks through it, log that as a weaker variant.
- **Dwell time versus text volume.** Count characters in the largest text block and divide by 13 characters/second — that is the published minimum reading dwell. A graphic holding 60 characters for less than ~4.6 s is unreadable, and that is a measurable failure, not a taste call.
- **Text scale.** At 1080p, body text in a graphic runs **40–60 px**, titles at least 50% larger. In-feed (vertical/social) reference material runs much larger — body ≥32 px and headlines ≥90 px at the composition's own resolution.
- **Duration band.** Full-frame graphic beats sit on screen **90–360 f (3–12 s)** — long enough to build, hold and read. Overlay graphics on top of A-roll run shorter, **45–120 f**.
- **Easing character.** Smooth, long-tailed settles (a `power3.out`-shaped arrival) read as house style; overshoot and bounce read as a playful register and should be logged as a deliberate choice, not assumed.
- **Focal-point direction.** Check whether the graphic tells you where to look at each moment — highlight, dim, arrow, scale ([[motion-image-focal-point-direction]]). A diagram that presents all its parts at equal weight for 8 seconds is a slide with animation on it.
- **Return path.** Note what the edit cuts back to after the graphic — a punch-in on the presenter is the standard resolve ([[cut-punch-in-emphasis]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `beat_len` | 180 f (6.0 s) | 90–360 f (3–12 s) | Full-frame graphic. Overlay variants 45–120 f. |
| `dwell_per_text` | chars ÷ 13 s | ≥ 2.3 s per 30-char line | Published minimum reading dwell is 13 characters/second; add 30% if the graphic is also animating. |
| `line_budget` | ≤ 30 chars/line, ≤ 3 lines | — | Above this the frame is a document, not a graphic. |
| `body_px` | 48 px @1080p | 40–60 px | Titles ≥ 1.5× body. In-feed viewing: body ≥ 32 px, headline ≥ 90 px. |
| `tracking` | −0.04 em | −0.03 to −0.05 em | At display sizes, because video encoding compresses letter detail. |
| `element_count` | 5 | 3–7 | Items in one build. Beyond 7, split into two beats. |
| `stagger_each` | 0.09 s | 0.06–0.15 s | Total arrival `items × stagger ≤ ~0.5 s` — a hard cap, so the arrival reads as one beat. |
| `entrance_dur` | 0.4 s (12 f) | 0.3–0.5 s | House settle `power3.out`. Exits shorter, 0.25 s — and only on the final scene. |
| `word_sync_tolerance` | ±6 f (±0.2 s) | ±0–9 f | Element arrival versus the word that names it. |
| `phase_split` | build 0–30% / breathe 30–70% / resolve 70–100% | — | Exactly ONE ambient motion during breathe. |
| `graphics_per_10min` | 3 | 2–6 | The most expensive item per second in the edit. Ration it. |
| `ease_characters` | 3 | 2–4 | Distinct easing characters per composition. One everywhere reads flat. |

## Reproduction prompt

```
Build a motion graphic to fill the beat at {{IN}}-{{OUT}} (seconds, 30fps).

1. WRITE THE ONE SENTENCE the graphic must make true, taken verbatim from
   the transcript between {{IN}} and {{OUT}}. If you cannot write it, the
   beat does not need a graphic - use footage instead and stop here.
2. NAME THE ELEMENTS: 3-7 objects, no more. Each must correspond to a
   noun the voice actually says in this window. Delete anything decorative.
3. CHECK THE READING BUDGET before designing: total characters in the
   largest simultaneous text block divided by 13 gives the minimum seconds
   that block must stay on screen. If that exceeds {{OUT}}-{{IN}}, cut text
   or split into two graphic beats.
4. BUILD as a sub-composition sized to the project frame. Structure it in
   three phases across its own duration: build 0-30%, breathe 30-70%,
   resolve 70-100%. Exactly one ambient motion during breathe.
5. ANIMATE with fromTo tweens only, never from(). Entrances: duration 0.4,
   ease power3.out, transform properties only (x, y, scale, rotation) plus
   opacity via autoAlpha on non-clip wrappers. Stagger multi-element
   arrivals with each: 0.09 and keep items x stagger under 0.5s total.
   Order the stagger by IMPORTANCE, not DOM order.
6. SYNC each element's arrival to the word that names it, within 6 frames
   (0.2s), using the word-level transcript timings offset into this
   composition's local time.
7. DIRECT ATTENTION at every moment: exactly one element is brightest,
   largest or highlighted. Dim or desaturate the rest rather than adding
   arrows on top of everything.
8. NO exit animations except on the final element - the cut back to
   picture is the exit.
9. ACCEPTANCE TEST: (a) mute the audio and read the graphic cold - the
   sentence from step 1 must be recoverable; (b) every text block satisfies
   the 13-chars-per-second dwell; (c) no element arrives more than 6 frames
   away from its word; (d) the last animation lands BEFORE the composition
   duration, not on it; (e) at any frozen frame, one thing is obviously the
   focal point.
```

## Execution spec

**HyperFrames (primary — the motion graphic IS a composition).** This is the one B-roll variant that needs no external renderer: build it as a `<template>`-wrapped sub-composition and slot it into the timeline where the cutaway goes.

```html
<!-- index.html: the graphic occupies the B-roll slot 41.20 -> 47.20 -->
<div id="el-flow" data-composition-id="flow"
     data-composition-src="compositions/flow.html"
     data-start="41.20" data-duration="6.00" data-track-index="1"></div>
```

```html
<!-- compositions/flow.html -->
<template id="flow-template">
  <div data-composition-id="flow" data-width="1920" data-height="1080" data-duration="6">
    <div class="clip" id="flow-stage">
      <div class="step" id="flow-s1">Request</div>
      <div class="step" id="flow-s2">Queue</div>
      <div class="step" id="flow-s3">Worker</div>
    </div>
  </div>
  <style>
    [data-composition-id="flow"] .step { font-size:48px; letter-spacing:-0.04em; font-weight:700; }
  </style>
  <script src="../vendor/gsap.min.js"></script>
  <script>
    const tl = gsap.timeline({ paused: true, defaults: { duration: 0.4, ease: "power3.out" } });
    // scene-local seconds. 0.09s stagger x 3 items = 0.27s total arrival (cap ~0.5s)
    tl.fromTo("#flow-stage .step", { y: 32, autoAlpha: 0 },
              { y: 0, autoAlpha: 1, stagger: { each: 0.09, from: "start" } }, 0.2);
    tl.to("#flow-s2", { scale: 1.08, duration: 0.5, ease: "sine.inOut" }, 2.4); // one ambient move
    window.__timelines["flow"] = tl;
  </script>
</template>
```

Contract details this leans on, each of which silently breaks the build if ignored:
- **Sub-composition roots are wrapped in `<template>`; standalone roots are not** (`standalone_composition_wrapped_in_template` is an error).
- Put `<style>`/`<script>` **inside** the template — the assembler drops a sub-comp file's own `<head>`.
- **Scope every CSS rule** with `[data-composition-id="flow"]` and prefix ids so they stay unique across the assembled page.
- **`cdn.jsdelivr.net` is blocked in this project** — GSAP must be vendored locally, as above. Never emit a CDN `<script>`.
- Use `fromTo`, never `from` (`immediateRender` writes the from-state at construction and flashes under seek). Spatial motion is `x`/`y`/`scale`/`rotation` only; `width`/`height`/`top`/`left` tweens are forbidden.
- **A sub-comp timeline cannot animate host-root elements.** Anything the graphic must move lives inside the graphic.
- Land the final state slightly **before** `data-duration` — the visibility window is half-open `[start, start+duration)`.
- Fonts: the pre-bundled families only (`Inter` is bundled but on the banned monoculture list; Montserrat, Oswald, Archivo Black, League Gothic are safe picks). Google Fonts is a network path and is unavailable here.

**ffmpeg.** Only relevant for a graphic rendered *outside* the composition and re-entering as a file — e.g. an alpha overlay:
```bash
# composite a pre-rendered alpha graphic over footage (leaving the pipeline only)
ffmpeg -i base.mp4 -i graphic.mov -filter_complex "[0][1]overlay=0:0:format=auto" -c:a copy out.mp4
```
Prefer building it in the composition; this stack renders HTML, so an external render is a lossy round-trip and forfeits seekability.

**Portability note.** Manim renders a scene to `media/videos/<scene>/<quality>/<scene>.mp4` with quality flags `-ql` 854×480/15fps, `-qm` 1280×720/30fps, `-qh` 1920×1080/60fps, `-qk` 4K/60fps, and can emit an alpha `.mov`; its output would re-enter here as a plain `src`. **Remotion:** conceptually the same build as a React `<Sequence>` with `useCurrentFrame()` — but Remotion is not part of this project and none of its APIs exist here. Neither path is verified installed on this ARM64 host; treat both as porting notes, not as instructions.

## Pairs with
[[cut-stock-footage-substitute]] · [[cut-b-roll-coverage-from-transcript]] · [[motion-image-focal-point-direction]] · [[struct-name-define-demonstrate]] · [[struct-progressive-layer-demo]] · [[cut-punch-in-emphasis]] · [[sfx-unsounded-motion-audit]] · [[motion-look-finishing-pass]] · [[pace-visual-variety-density-audit]]

## Failure modes
- **A slide with animation on it.** Everything arrives at once, then sits while the voice explains. Fix: stagger the build to the words; nothing appears before it is named.
- **Text that cannot be read in the time it is up.** The commonest defect and the easiest to measure. Fix: characters ÷ 13 = minimum seconds; cut text or extend the beat.
- **Seven ideas in one graphic.** The viewer reads nothing. Fix: 3–7 objects, one sentence, split into two beats if it will not fit.
- **Bounce everywhere.** `back`/`elastic`/`bounce` on every entrance reads cheap; one ease everywhere reads flat. The second failure is worse than the first, but both are failures. Fix: 2–4 easing characters, `power3.out` as the default settle.
- **Silent motion.** A graphic that builds without a sound is the exact case the brain flags as fake. Fix: one motion sound per arrival group, not per element ([[sfx-unsounded-motion-audit]]).
- **Animating the composition root's background.** A full-screen fill on the root is dropped on the layered-composite path; put the fill on a full-bleed child with `position:absolute; inset:0`.
- **CDN script tags.** Copied straight from upstream examples, they fail closed under this project's egress allowlist. Fix: vendor GSAP locally.
- **Known gap:** no automated check reads text dwell time or word-sync offsets. `hyperframes check` covers layout, contrast and motion lifecycle; the reading budget has to be computed by hand or in the design document.
