---
id: motion-emphasis-scale-step
title: The emphasis scale step — a ramped push that points, and the ladder it lives on
skill: motion
type: camera
family: punch-in
tags: [skill/motion, type/camera, family/punch-in, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:22"
    quote: "You can also make more abrupt scale changes to pull attention to specific things."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:27"
    quote: "For example, when I'm saying something important in an A-roll segment, I zoom in close on my face to subtly tell the viewer to listen up."
research_refs:
  - https://en.wikipedia.org/wiki/Digital_zoom
  - https://en.wikipedia.org/wiki/Ken_Burns_effect
  - https://www.nngroup.com/articles/animation-duration/
  - https://carbondesignsystem.com/elements/motion/overview/
  - https://en.wikipedia.org/wiki/Twelve_basic_principles_of_animation
difficulty: medium
detectable_from: transcript+video
---

# The emphasis scale step — a ramped push that points, and the ladder it lives on

## What it is
An **abrupt but ramped** change of scale inside a single continuous shot, used as a pointer rather than as movement. The source separates it explicitly from the slow drift it has just described ("slowly change the scale or the position") — drift is meant not to be noticed, this is meant to be noticed, and what the viewer notices is *listen to this*. Mechanically it is authored geometry on one source: `scale` goes from one ladder level to the next over 8–14 frames on an out-ease, anchored on the thing being pointed at, and then nothing moves for at least a second and a half.

This note owns the **motion spec and the ladder**: which levels exist, how much scale the source's pixels can pay for, where the transform origin sits, and how the step is authored in a composition where there is no second camera and no cut. Three siblings own the neighbouring durations: [[cut-punch-in-emphasis]] owns the 0-frame version (a hard cut between two framings, and the editorial decision of *which line* gets one), [[motion-snap-zoom-punch]] owns the 3–6 frame violent snap, and [[motion-still-image-drift]] owns everything 20 frames and slower, where the move stops being a pointer and becomes texture.

## When to use it
- On the **one clause in a segment that carries the claim**, when the delivery is sincere and a snap zoom would read as a joke. The ramp is the "serious" member of the family: it says *lean in*, where a snap says *bang*.
- On a **still, screenshot or graphic**, stepping in on the region the narration has just named — the same gesture pointed at an image instead of a face. Pair it with [[motion-spotlight-mask-reveal]] when the surround must stay visible as evidence, and with [[motion-key-region-animate-in]] when a specific line is being lifted out.
- On the **first line back** from B-roll or a sponsor block, to re-establish the speaker and re-mark attention.
- **Not** as anti-boredom filler. A step that lands on an ordinary line teaches the viewer the signal is meaningless, and the next real one is ignored.
- **Not** when the source has no pixels to spare (see `source_headroom`), and not on a shot the viewer is being asked to read — text going soft under an upscale is worse than no emphasis at all.

## How to recognise it in a reference video
- **Step frame-by-frame across the change.** Extract at 30 fps and measure a fixed feature (interpupillary distance, shoulder width, a logo's width). Intermediate scales across **8–14 frames** = this technique. 0 frames = a cut ([[cut-punch-in-emphasis]]). 3–6 frames = a snap ([[motion-snap-zoom-punch]]). 20+ frames with no dead stop = drift.
- **Per-frame deltas are front-loaded.** The first two frames should carry 35–55 % of the total scale change; that signature is an out-ease. Even deltas mean a linear ramp, which reads mechanical and is worth logging as a style choice.
- **Total ratio.** `scale_ratio = feature_width_after / feature_width_before`. **1.10–1.20** for a "same shot, tighter" mark; **1.25–1.40** for a real emphasis step; **>1.5** only from a 4K source in a 1080 timeline.
- **Count the levels used across the whole video.** Two (100/125) is the norm; three (100/115/135) is the practical ceiling. Four or more and the viewer loses the reference framing — log it as a fault, not a style.
- **Find the anchor.** Compute the fixed point of the transform: it should sit on the eyes (roughly `50% 38%` of the element box) or on the named region. If the eyes ride up toward the top edge as the step lands, the origin was frame centre — a reliable amateur tell.
- **Check for a settle or a bounce.** The ramp must end dead. Any overshoot-and-return is a spring and belongs to a playful register the source does not use here.
- **Check for upscale softening.** Compare high-frequency energy (Laplacian variance, or an edge count) before and after. A drop of more than ~20 % with no change of focus means the reference is enlarging beyond its source resolution.
- **Bind to the transcript.** A real emphasis step starts within **±6 frames** of the onset of a stressed word or the start of the claim clause. Steps at even intervals unrelated to the words are a rhythm device, not emphasis.
- **Density.** Count events per minute of A-roll: **1–3** is emphasis, above 4 the signal is spent.
- **Audio:** about half carry a low sub or a soft air move in the 8–14 frame window; a whip crack on a 10-frame ramp is the wrong sound and marks a copied preset.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `step_scale` | 1.25 | 1.10–1.40 native · up to 2.00 from 4K in 1080 | Linear scale factor, not area. |
| `ladder` | `[1.00, 1.25]` | 2 levels; 3 max (`[1.00, 1.15, 1.35]`) | One ladder for the whole video. Do not invent a new level per segment. |
| `ramp` | 0.35 s (10 f) | 0.27–0.47 s (8–14 f) | Below 8 f it is a snap; above 14 f it stops pointing. NN/g's "substantial change" band is 200–300 ms; this sits just above it because it is content, not UI. |
| `ease` | `power2.out` | `power2.out` · `power3.out` | Long tail, dead stop. Never `back`/`elastic`: overshoot reads playful and fights "pay attention". |
| `transform_origin` | `50% 38%` | 50 % x · 30–45 % y | Eyeline. For a region on a still, the region's centre in % of the element box. |
| `hold` | 1.5 s | 1.0–5.0 s | Minimum time at the new level. Under 1.0 s it reads as a glitch. |
| `pre_hold` | 0.5 s | 0.3–2.0 s | Stillness before the step is what makes it land. |
| `return` | hard cut back | cut · 0.30 s `power2.inOut` pull | Return on a clause boundary, never mid-word. A pull-back that is longer than the step reads as a mistake. |
| `source_headroom` | ≥ `step_scale` × composition width | ≥1.0× | 1.25 × 1920 = 2400 px of real source. A 2160p source gives up to **2× lossless** in a 1080p timeline. |
| `density` | 2 per minute of A-roll | 1–4 | Above 4 the device is noise. |
| `sfx` | soft air, −15 dB | none · −13 to −18 dB | 0.3–0.6 s whoosh, transient on frame 1–2 ([[sfx-air-on-micro-movement]]). Not a whip. |
| `origin_drift_check` | required | — | No face tracking exists in this stack; the origin is a constant. If the subject moves more than ~4 % of frame width during the hold, re-anchor or shorten the hold. |

## Reproduction prompt

```
Author an emphasis scale step on {{TARGET}} at {{T}} seconds, marking the line
"{{LINE}}". Author seconds; frame counts @30fps are derived comments.

STEP 0 — HEADROOM. Read the source's pixel width. It must be at least
step_scale x composition width (1.25 x 1920 = 2400px). If it is not, lower
step_scale to what the pixels pay for, or drop the step. Never upscale.

STEP 1 — ANCHOR. Set transformOrigin on the media element to the focal point
as a percentage of its own box: "50% 38%" for a face on the eyeline, or the
named region's centre on a still. Put NO CSS transform on this element —
transformOrigin only, or lint raises gsap_css_transform_conflict.

STEP 2 — QUIET, THEN STEP. Ensure nothing else animates for 0.5s before {{T}}.
  tl.fromTo("{{TARGET}}", { scale: 1.0 },
    { scale: 1.25, duration: 0.35, ease: "power2.out",
      transformOrigin: "50% 38%" }, {{T}});
No second tween, no settle, no overshoot, no return-by-animation.

STEP 3 — BIND TO THE WORD. Move {{T}} so the step starts on the onset of the
stressed word, taken from the word-level transcript, within +/- 0.2s. If the
step cannot be bound to a word, delete it.

STEP 4 — HOLD 1.5s at the new level with nothing else moving. Return by
cutting to the wide framing on a clause boundary, or with a single 0.30s
power2.inOut pull back to scale 1.0.

STEP 5 — SOUND (optional). A 0.3–0.6s air whoosh at -15 dB, transient on the
first frame of the ramp; never a whip.

ACCEPTANCE TEST: extract frames from {{T}}-0.2 to {{T}}+0.8 at 30fps. The
change must occupy 8–14 frames, the first two frames must carry 35–55% of it,
the final two frames must be within 0.5% of each other, and the anchor feature
must stay within 2px across the whole move. Measure edge density before and
after: a drop over 20% means the source ran out of pixels.
```

## Execution spec

**HyperFrames.** The step is a `scale` tween on the media element inside a timed wrapper. Time the wrapper *or* the video, never both — `video_nested_in_timed_element` is a hard error.

```html
<div id="shot-claim" class="clip" data-start="82.0" data-duration="7.0" data-track-index="0">
  <video id="v-claim" src="assets/aroll/take-09.mp4" muted playsinline
         data-media-start="415.2" style="width:100%;height:100%;object-fit:cover"></video>
</div>
```

```js
// emphasis step at global t = 84.10 — 0.35s = 10f @30fps
tl.fromTo("#v-claim", { scale: 1.0 },
  { scale: 1.25, duration: 0.35, ease: "power2.out", transformOrigin: "50% 38%" }, 84.10);
// optional pull-back on the clause boundary at 88.30
tl.to("#v-claim", { scale: 1.0, duration: 0.30, ease: "power2.inOut" }, 88.30);
```

Contract points that bind this note:
- **Seconds only.** There is no frame attribute; 10 f @30fps is authored as `0.35`.
- `scale` and `transformOrigin` are transform-space properties and are lint-clean on the master timeline. `width`/`height`/`top`/`left` tweens are forbidden.
- Use `fromTo`, never `from` — `from()` sets `immediateRender: true` and writes its start state at construction, which flashes under the render engine's non-linear seek.
- Land the resolved scale at least 2 frames before the clip's `data-duration`; the visibility window is half-open.
- **No automatic face tracking exists** in this stack ("pan/Ken Burns is authored geometry"). The origin is a hand-authored constant — re-check it with a snapshot if the subject moves.
- A step that must also change footage speed cannot be done in-composition: `data-playback-rate` is a constant 0.1–5 with **no rate envelope**. Preprocess with ffmpeg.

**ffmpeg — headroom audit and preprocessing.**

```bash
# what resolution do I actually have?
ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 take-09.mp4
# frame-by-frame audit of the authored step
ffmpeg -ss 83.9 -i render.mp4 -t 1.0 -vf fps=30 /tmp/step/%03d.png
# only if the deliverable must be a pre-cropped file (a 1.25 centre crop, then back to 1080)
ffmpeg -i take-09.mp4 -vf "crop=iw/1.25:ih/1.25:(iw-iw/1.25)/2:(ih-ih/1.25)*0.38,scale=1920:1080" tighter.mp4
```

**Epidemic Sound.** Only if the step is sounded:
`SearchSoundEffects { query: { term: "soft air whoosh subtle movement" }, filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--swish"] }, duration: { max: 900 } } }` — then place per [[sfx-whoosh-short-vs-long]] with the transient on the ramp's first frame.

**Remotion.** `interpolate(frame, [0, 10], [1, 1.25], { easing: Easing.out(Easing.quad) })` with `transformOrigin` on the wrapper. Concept only — Remotion is not a runtime here.

## Pairs with
[[cut-punch-in-emphasis]] · [[motion-snap-zoom-punch]] · [[motion-still-image-drift]] · [[motion-spotlight-mask-reveal]] · [[motion-key-region-animate-in]] · [[motion-screen-recording-cursor-punch-in]] · [[pace-a-roll-burst-rationing]] · [[sfx-air-on-micro-movement]] · [[motion-sound-bound-motion-event]] · [[motion-attention-transient]] · [[motion-parallax-depth-move]]

## Failure modes
- **Stepping past the source's resolution.** 1.4× on a 1080p source in a 1080p timeline is a 40 % upscale, and it is visible on anything with text in it. Correction: measure the source first; shoot or source at ≥1.5× delivery.
- **Centre anchor.** The face rides up and out of frame as the step lands. Correction: `transformOrigin: "50% 38%"`, or the region's own centre.
- **Ramp that never stops.** A push that keeps creeping through the hold is drift wearing an emphasis costume, and the pointer is lost. Correction: one tween, dead stop, then stillness.
- **Overshoot.** `back.out` on a sincere line reads as a cartoon. Correction: `power2.out`, no bounce.
- **Unbound to the words.** Steps on a timer rather than on a stressed word train the viewer to ignore them. Correction: bind every step to a transcript word onset within ±0.2 s.
- **Ladder inflation.** Every segment adds a level until the framing is arbitrary. Correction: one ladder of two (max three) levels for the whole video.
- **Whip crack on a 10-frame ramp.** The sound announces a snap that never happens. Correction: soft air, or nothing.
- **Known gap — moving subjects.** With no face tracking and no rate envelope, a step on a subject who then moves cannot be re-anchored automatically. Correction: shorten the hold, or pre-crop a stabilised segment with ffmpeg and re-import.
