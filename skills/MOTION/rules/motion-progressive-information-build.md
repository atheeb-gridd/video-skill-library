---
id: motion-progressive-information-build
title: The information build — one idea per stage, held long enough to read
skill: motion
type: graphic
family: explainer-graphics
tags: [skill/motion, type/graphic, family/explainer-graphics, engine/hyperframes, engine/ffmpeg, engine/epidemic, engine/remotion, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:04:16"
    quote: "Any attempt to use A-roll or regular B-roll in that moment would have been either too slow or horribly confusing, and either one would have cost viewers. But an animation explained it crystal clear and fast."
research_refs:
  - https://sites.google.com/site/cognitivetheorymmlearning/segmenting-principle
  - https://www.nngroup.com/articles/animation-duration/
  - https://en.wikipedia.org/wiki/Words_per_minute
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/360051554394-Timed-Text-Style-Guide-Subtitle-Timing-Guidelines
  - https://gsap.com/resources/getting-started/Staggers/
difficulty: high
detectable_from: transcript+video
---

# The information build — one idea per stage, held long enough to read

## What it is
The animation form that carries an important-but-boring beat: the graphic is delivered as a **sequence of discrete stages**, each of which adds exactly one new element, animates it in over 0.2–0.45 s, and then **holds completely still** while the narration says the words that element illustrates. Nothing is removed until the build resolves, so the last frame of the build contains the whole argument. [[motion-explainer-beat-animation]] owns the editorial decision to spend an animation here at all; this note owns the choreography — the stage grammar, the hold arithmetic, and the word-to-stage binding.

It is the opposite of a *reveal*. A reveal presents a finished diagram at once and asks the viewer to parse it while the voice keeps moving; a build presents one relation at a time and never lets the picture run ahead of the sentence. The evidence behind that is the **segmenting principle**: Mayer, Dow & Mayer (2003) found learners given a segmented, learner-advanced animation of an electric motor outperformed learners given the same content continuously, at a reported **effect size of ~1.0**. A video edit cannot hand over pacing control, so the build has to segment *for* the viewer — which makes the hold time the load-bearing parameter, not the animation.

## When to use it
- The transcript beat is **information the story needs and the eye cannot get from footage**: a flow, a hierarchy, a before/after, a comparison, a mechanism, a set of relations between named things.
- Literal B-roll of the thing would be confusing (three logos on a desk does not show a flow) and A-roll of the presenter explaining it would be slow.
- The beat has **3–7 nameable parts**. Two parts do not need a build (one card and a highlight is enough); more than seven means the beat should be split into two builds or cut down.
- The narration for the beat runs **6–25 s**. Under 6 s there is no room for stages; over 25 s the graphic goes stale and needs a cut or a camera move on it.
- Do **not** use it for a beat whose value is emotional rather than informational — a build is a clarity device and it drains tension.

## How to recognise it in a reference video
- **Stepwise element count.** Extract frames at 1 fps across the graphic (`ffmpeg -vf fps=1`) and count distinct labelled elements per frame. A build shows a **monotonically non-decreasing** count, typically +1 every 1–2 s. A reveal shows the final count on frame 1.
- **Plateaus in the difference signal.** `ffmpeg -vf "select='gt(scene,0.06)',metadata=print"` over the graphic prints a **cluster of frames at each stage entrance and nothing in between**. Alternating spike/plateau is the fingerprint. Continuous motion across the whole graphic means it is not a build.
- **Nothing is removed.** Compare the first and last frame of the graphic: every element present at 3 s should still be present at the end, possibly dimmed. Elements disappearing mid-build is a different (weaker) pattern — log it as such.
- **Word binding.** For each stage entrance, find the nearest content word in the transcript. In a competent build the entrance sits within **−0.3 s to +0.2 s of the keyword** — the graphic may lead the voice slightly, it must not lag it by more than ~6 frames.
- **Hold length.** Measure the still interval after each entrance. Expect **0.8–4.0 s**, with the average tracking the number of new words in that stage divided by ~3 words/s.
- **Prior-stage dimming.** Look for earlier elements dropping to roughly **40–70 % opacity** as a new one arrives; that is the build telling you where to look without deleting context.
- **Connector direction.** Arrows/lines between elements are usually drawn *after* both endpoints exist, in the reading direction, over 0.25–0.45 s ([[motion-annotation-draw-on]]).
- **Audio track.** Each stage entrance typically carries a short, quiet transient (pop/click, −18 to −24 dBFS relative to the mix) rather than a whoosh; a whoosh on every stage reads as noise ([[motion-sfx-pass-manifest]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `stage_count` | 5 | 3–7 | Nameable parts. >7 → split the beat into two builds. |
| `stage_in_duration` | 0.30 s (9 f) | 0.20–0.45 s (6–14 f) | Inside NN/g's 100–400 ms working band; 500 ms+ "feels like a real drag". |
| `stage_hold` | 1.2 s (36 f) | 0.8–4.0 s | **Floor is a hard floor**: 0.8 s ≈ Netflix's 20-frame minimum on-screen text duration, scaled for the 24→30 fps difference. |
| `hold_formula` | `new_words / 3.0 + 0.3 s` | — | 3 words/s ≈ 180 wpm, the low end of the verified reading-aloud band (184 ± 29 wpm across 17 languages; 228 ± 30 for English). Read-aloud rate is the safe proxy because the narration is being spoken over it. |
| `stage_ease` | `power3.out` | `power2.out`–`power4.out` | House settle. Never `back`/`elastic` on an explainer — it reads as a toy. |
| `element_travel` | 24 px @1080p (2.2 % frame h) | 16–40 px (1.5–3.7 %) | Enough to be a transient ([[motion-attention-transient]]); short enough not to be a journey. |
| `intra_stage_stagger` | `each: 0.06` | 0.04–0.09, `amount` ≤ 0.30 | For a stage containing 2–4 sub-parts (a row of icons). Engine cap: items × stagger ≤ ~0.5 s. |
| `connector_draw` | 0.35 s (10 f) | 0.25–0.45 s | `stroke-dashoffset` 100 %→0 %, `power2.inOut`. |
| `keyword_offset` | 0.00 s | −0.30 to +0.20 s | Negative = graphic leads voice. Never exceed +0.20 s (6 f) late. |
| `dim_prior_opacity` | 0.55 | 0.40–0.70 | Applied over 0.25 s at the same time the new stage enters. |
| `total_build` | 12 s | 6–25 s | Beyond 25 s add a camera move or cut away and return. |
| `camera_on_build` | 1.00 → 1.06 scale | 1.00–1.10 over the whole build | Optional slow push, `none` ease, keeps a long build from going dead. Drift band, not a transient. |
| `resolve_hold` | 1.0 s | 0.6–2.0 s | The finished diagram must sit complete and undimmed before the cut away. |

## Reproduction prompt

```
Build the beat at {{IN}}–{{OUT}} as a staged information build inside a
HyperFrames sub-composition. Author all time in SECONDS; frame counts below
are @30fps and are derived comments only.

STEP 1 - SEGMENT. Read the transcript between {{IN}} and {{OUT}}. Split it
into 3-7 stages, one per nameable part. Write the stage list as: stage index,
the exact keyword whose onset it binds to (with its transcript timestamp),
the element type (FRAME | NODE | CONNECTOR | VALUE | VERDICT), and its new
word count. Refuse to continue if the beat yields fewer than 3 or more than 7
stages: fewer means use a single card, more means split the beat.

STEP 2 - PLACE. Stage 1 (the FRAME: container, axis, board) enters at
{{IN}} + 0.15. Every later stage enters at (its keyword onset - 0.10),
quantised to the frame grid (round to the nearest 1/30 s). Verify each hold
= next entrance - this entrance is at least max(0.8, new_words / 3.0 + 0.3);
if it is not, merge the two stages.

STEP 3 - ANIMATE. Per stage: tl.fromTo(el, { y: 24, autoAlpha: 0 },
{ y: 0, autoAlpha: 1, duration: 0.30, ease: "power3.out" }, t_stage).
Sub-parts inside one stage use stagger { each: 0.06, from: "start" } ordered
by importance, total under 0.30s. CONNECTOR stages tween strokeDashoffset
from its path length to 0 over 0.35s, power2.inOut. At each entrance also
tl.to(previous stage elements, { opacity: 0.55, duration: 0.25 }, t_stage).

STEP 4 - RESOLVE. At the last stage + 0.25 restore every element to opacity
1 over 0.30s. Hold the complete diagram still for 1.0s before {{OUT}}.
Optionally scale the whole build wrapper 1.00 -> 1.06 across the full window
with ease "none". Land every tween's end state at least 2 frames before the
clip's data-duration.

STEP 5 - SOUND. One short transient per stage entrance (pop or click, 150-500
ms file), at the entrance frame, at -18 to -24 dB relative to dialogue. No
whoosh per stage. One optional impact on the resolve.

ACCEPTANCE TEST: render, then extract 1 fps stills across {{IN}}-{{OUT}}.
The visible element count must be non-decreasing, must increase exactly
stage_count times, and the final still must contain every element at full
opacity. For each stage, the entrance frame must be within 6 frames of its
bound keyword and no earlier than 9 frames before it.
```

## Execution spec

**HyperFrames.** One build = one sub-composition, hosted by a slot in `index.html`. Use archetype C from the contract (*multi-scene merge*): the stages share continuous state, so they are `.phase` divs inside **one** sub-comp, not one slot per stage.

```html
<!-- index.html: the host slot -->
<div id="el-build" data-composition-id="build" data-composition-src="compositions/build.html"
     data-start="42.0" data-duration="13.0" data-track-index="1" class="clip"></div>
```

```html
<!-- compositions/build.html -->
<template id="build-template">
  <div data-composition-id="build" data-width="1920" data-height="1080" data-duration="13">
    <div class="board">
      <div class="stage" id="build-frame">…</div>
      <div class="stage" id="build-node-1">…</div>
      <svg class="stage" id="build-link-1"><path id="build-link-1-p" d="…" fill="none"/></svg>
      <div class="stage" id="build-node-2">…</div>
      <div class="stage" id="build-verdict">…</div>
    </div>
  </div>
  <style>[data-composition-id="build"] .stage { opacity: 0; } /* no transform here */</style>
  <script>
    const tl = gsap.timeline({ paused: true, defaults: { duration: 0.30, ease: "power3.out" } });
    // scene-LOCAL seconds. Global time = these + the host slot's data-start (42.0).
    const STAGES = [
      { sel: "#build-frame",   t: 0.15 },
      { sel: "#build-node-1",  t: 1.40 },
      { sel: "#build-link-1",  t: 3.05, link: "#build-link-1-p" },
      { sel: "#build-node-2",  t: 4.60 },
      { sel: "#build-verdict", t: 7.90 },
    ];
    STAGES.forEach((s, i) => {
      if (s.link) {
        const L = document.querySelector(s.link).getTotalLength();
        tl.set(s.sel, { opacity: 1 }, s.t);
        tl.fromTo(s.link, { strokeDasharray: L, strokeDashoffset: L },
                          { strokeDashoffset: 0, duration: 0.35, ease: "power2.inOut" }, s.t);
      } else {
        tl.fromTo(s.sel, { y: 24, autoAlpha: 0 }, { y: 0, autoAlpha: 1 }, s.t);
      }
      if (i > 0) tl.to(STAGES.slice(0, i).map(p => p.sel),
                       { opacity: 0.55, duration: 0.25 }, s.t);
    });
    const last = STAGES[STAGES.length - 1].t;
    tl.to(STAGES.map(s => s.sel), { opacity: 1, duration: 0.30 }, last + 0.25);
    tl.fromTo(".board", { scale: 1.0 }, { scale: 1.06, duration: 12.6, ease: "none" }, 0.1);
    window.__timelines["build"] = tl;
  </script>
</template>
```

Contract points this leans on, each of which breaks the build if ignored:
- **`fromTo`, never `from`** — `from()` writes its start state at construction, before the clip is active, and misbehaves under the render engine's non-linear seek.
- **Transform aliases only** (`x`, `y`, `scale`, `rotation`). No `top`/`left`/`width`/`height` tweens, and **no CSS `transform` on any element you also tween** (`gsap_css_transform_conflict`, error).
- **The hold is a gap in the timeline, not a tween.** Do not author a 1.2 s `duration: 1.2` no-op; just position the next tween later.
- **Land end states before `data-duration`** — the window is half-open `[start, start+duration)`.
- `getTotalLength()` is measured **once at setup**, which is the contract's rule about never deriving geometry at tween time. In a multi-scene montage, do not measure at all — author the path length as a literal.
- Keep ids prefixed with the composition id (`#build-…`) so they stay unique on the assembled page.
- `data-duration` on the **host slot** is what bounds the build; the sub-comp's own root `data-duration` is read at compile time and cannot be scripted.

**ffmpeg — the audit side.**

```bash
# stage-count check: one still per second across the build
ffmpeg -i out.mp4 -ss 42 -t 13 -vf fps=1 /tmp/build/%02d.png
# entrance detection: cluster-and-plateau signature
ffmpeg -i out.mp4 -ss 42 -t 13 -vf "select='gt(scene,0.06)',metadata=print" -f null -
```

**Epidemic Sound.** One quiet transient per stage: `SearchSoundEffects` with `filter.tagSlugs { matchType: "ANY", values: ["cartoon--pop", "mechanical--click"] }` and `filter.duration { min: 120, max: 600 }`. Rotate at least three different files across the stages of one build — the same pop five times is the source's own third sound-design mistake.

**Remotion.** One `<Sequence>` per stage with `from` = the stage's frame and no `durationInFrames` shortening (stages persist); `spring()` or `interpolate` with an ease-out over 9 frames. Concept only.

## Pairs with
[[motion-explainer-beat-animation]] · [[motion-broll-slot-tier-selection]] · [[motion-number-rollup-stat-reveal]] · [[motion-annotation-draw-on]] · [[motion-attention-transient]] · [[motion-storyboard-motion-spec]] · [[motion-overlay-stack-choreography]] · [[motion-sfx-pass-manifest]] · [[struct-name-define-demonstrate]] · [[struct-progressive-layer-demo]]

## Failure modes
- **The build outruns the voice.** Every element on screen before the sentence that names it, so the viewer reads ahead and stops listening. Correction: bind each entrance to its keyword onset − 0.10 s and verify against the transcript, not against feel.
- **Holds too short.** Stages 0.4 s apart look like an animation and read like nothing. Correction: enforce the `new_words / 3.0 + 0.3` floor and the hard 0.8 s minimum; merge stages rather than shortening holds.
- **Elements deleted as the build progresses.** The final frame no longer contains the argument, so the beat cannot be screenshotted or remembered. Correction: dim to 0.55, never remove; restore all on resolve.
- **Continuous motion under the whole build.** A drift plus per-stage entrances is fine; a build where things are always moving destroys the plateau that makes each stage readable. Correction: exactly one ambient motion (the 1.06 push), everything else static between stages.
- **Eight or more stages.** Element count exceeds working memory and the diagram becomes the thing you have to explain. Correction: split into two builds separated by a cut, or promote three stages into one grouped stage with an internal stagger.
- **Playful eases.** `back.out` on an explainer node contradicts the beat's job. Correction: `power3.out`.
- **A whoosh per stage.** Nine whooshes in 12 s is fatigue, not sound design. Correction: short pops at low level, one impact on resolve.
- **Known gap:** nothing in `hyperframes check` verifies that a stage entrance matches a transcript timestamp. The word binding is only as good as the acceptance test you run; treat the 1 fps still extraction as mandatory, not optional.
