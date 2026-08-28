---
id: motion-still-image-drift
title: Drift a still — the minimum scale/position ramp that stops an image reading as a freeze
skill: motion
type: camera
family: still-image-motion
tags: [skill/motion, type/camera, family/still-image-motion, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:13"
    quote: "First, give boring still images some movement. Either slowly change the scale or the position. Or even better, make things more interesting with a change in perspective."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:04"
    quote: "A lot of the time you don't even need to cut to a different clip to make your video more interesting."
research_refs:
  - https://en.wikipedia.org/wiki/Ken_Burns_effect
  - https://en.wikipedia.org/wiki/Image_scaling
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://gsap.com/docs/v3/Eases/
  - https://en.wikipedia.org/wiki/Shutter_speed
difficulty: low
detectable_from: video
---

# Drift a still — the minimum scale/position ramp that stops an image reading as a freeze

## What it is
A slow, single-direction affine ramp applied to any still that sits on screen for more than about a second: scale climbs (or falls) a few percent, and/or the frame translates a few percent, across the whole hold. Historically the **Ken Burns effect** — "slow zooming and panning effects" that crop to a detail and travel across it. The source treats a motionless still as a *defect* rather than a neutral choice: the eye reads an unmoving frame as playback having stopped, and attention leaves. This is the floor treatment, applied to every still by default; [[motion-parallax-depth-move]] is the upgrade the source explicitly prefers ("or even better... a change in perspective").

The whole craft is in the rate. Too slow and it does nothing; too fast and it announces itself as an effect. The usable band is narrow and measurable: **roughly 1–2.5% of frame dimension per second**, sustained, in one direction only.

## When to use it
- **Every `<img>` clip held longer than ~1.0s.** Below that, the drift cannot accumulate enough displacement to be perceived and you may as well cut.
- **Screenshots, photos, tweets, charts, diagrams, thumbnails, book covers, logos** — anything inserted as a flat frame under narration.
- **A held final frame of a video clip** that has been frozen — the freeze is what needs disguising.
- **Under a long narration beat** where no cut is available or wanted: drift is the cheapest way to keep the visual-change clock ticking without a cut ([[pace-visual-change-clock]], [[pace-overlay-instead-of-cut]]).
- **Not** on a still that is already carrying another motion event — a region animating in ([[motion-key-region-animate-in]]), an annotation drawing on ([[motion-annotation-draw-on]]), a spotlight opening ([[motion-spotlight-mask-reveal]]). One ambient motion per breathe phase; a second one is clutter.
- **Not** as a substitute for a punch-in. A drift is ambient; an abrupt scale change to pull attention is a different move with different numbers ([[cut-punch-in-emphasis]]).

## How to recognise it in a reference video
- **Extract at 30fps across the hold and difference consecutive frames.** A drifting still produces a *uniform global* residual — every feature moves by the same affine transform, with **zero local motion** anywhere in the frame. That signature separates a drifting still from actual footage instantly.
- **Measure the rate.** Track two high-contrast corners across the first and last frame of the hold. Scale ratio = distance(end) / distance(start). Divide by the hold duration in seconds. Typical professional value lands in **1.0–2.5%/s**; below 0.6%/s the move is invisible and effectively absent, above ~4%/s it reads as a deliberate push rather than ambient drift.
- **One direction, no reversal.** In competent work the scale is monotonic across the hold. A zoom in that reverses to a zoom out inside one clip is an amateur tell.
- **The tween runs to the clip's last frame.** If displacement stops 10+ frames before the cut, the tail reads as a freeze and the whole effect is wasted.
- **Check the corners for parallax.** If near-field elements travel further than far-field ones, it is not this note — it is [[motion-parallax-depth-move]].
- **Look for softness at maximum scale.** A source scaled past 100% shows interpolation mush on hard edges (text, chart gridlines). Its presence is a resolution failure, not a style.
- **Transform origin.** Is the zoom centred, or anchored on a subject? An off-centre anchor (the zoom converging on a face or a headline) is the more considered version and tells you the reference names focal points.
- **Density check:** count what fraction of stills in the reference carry any drift at all. A creator who does this consistently is at or near 100%; that number belongs in the style profile.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `drift_rate` | 1.5 %/s | 0.8–2.5 %/s | Of frame dimension. At 30fps that is 0.05%/frame — deliberately below the per-frame detection threshold. |
| `scale_from` → `scale_to` | 1.00 → 1.06 | travel 0.03–0.20 | For a 4s hold at 1.5%/s. Compute `scale_to = scale_from × (1 + rate × hold)`. |
| `direction` | in (scale up) | in \| out | Zoom **in** for build/emphasis, **out** for reveal-the-context or a closing beat. Never both in one clip. |
| `pan_travel` | 0 | 0–8 % of frame | `x`/`y` in px. Combine with scale only when the subject is off-centre; a simultaneous zoom + pan needs `scale_padding`. |
| `scale_padding` | `1 + pan_travel` | 1.02–1.12 | Base scale so a pan never exposes an edge. Applied on top of `scale_from`. |
| `ease` | `sine.inOut` | `sine.inOut` \| `none` \| `power1.inOut` | `sine.inOut` for holds ≤5s (soft in, soft out). `none` (linear) for long moves and for camera moves with timed counterpoint. Never an out-ease — it front-loads the travel and the tail dies. |
| `transform_origin` | `50% 50%` | any | Anchor on the focal point when there is one. Set once with `tl.set`, never in CSS beside a GSAP transform. |
| `tween_end` | `hold − 0.05s` | `hold − 0.1s` … `hold − 0.03s` | The clip window is half-open; land the end state *before* `data-duration` or the final frame never renders. |
| `min_hold` | 1.0 s | 0.8–1.5 s | Below this, skip the drift; there is no time to accumulate perceptible displacement. |
| `source_headroom` | 1.20 × output × `scale_to` | ≥1.0× | Resolution rule, below. |
| `blur_at_rest` | 0 | 0 | Do not add motion blur. At these rates per-frame displacement is ~1 px; a 180° shutter at 30fps is a 1/60s exposure, so real blur would be sub-pixel. |

**Resolution headroom** — the number that prevents the commonest failure. A still scaled to `S` needs at least `S ×` the output's pixel width to avoid upscaling artefacts, plus ~20% safety for a pan:

| Output | Max scale 1.06 | 1.15 | 1.30 | 1.50 |
|---|---|---|---|---|
| 1920×1080 | ≥ 2442 px wide | ≥ 2650 | ≥ 2995 | ≥ 3456 |
| 1080×1920 (vertical) | ≥ 1374 px wide | ≥ 1490 | ≥ 1685 | ≥ 1944 |
| 3840×2160 | ≥ 4884 px wide | ≥ 5300 | ≥ 5990 | ≥ 6912 |

If the source is smaller, either lower `scale_to`, start at `scale_from < 1` and zoom **out** to 1.0 (which never upscales past native), or replace the asset. Do not upscale and hope.

## Reproduction prompt

```
Apply a drift to the still {{SRC}}, which is held from {{IN}} to {{OUT}}
(hold = {{OUT}} - {{IN}} seconds).

0. GATE. If hold < 1.0s, do not drift - the displacement will not be
   perceptible. Log it and move on.

1. RESOLUTION CHECK FIRST. Read the source's pixel width. Required width =
   1.20 * output_width * scale_to. If the source is smaller, either reduce
   scale_to until it fits, or invert the move (start at 1.06 and end at 1.00,
   which never samples above native), or flag the asset for replacement. Never
   scale a source above its native pixel count and accept the softness.

2. PICK THE TRAVEL. rate = 1.5%/s (accept 0.8-2.5). scale_to = 1.00 + rate *
   hold. Example: a 4s hold gives 1.00 -> 1.06. Direction is IN by default;
   use OUT when the beat is a reveal of context or a closing line.

3. ANCHOR IT. If the image has a named focal point, set transformOrigin to
   that point as a percentage pair. Otherwise 50% 50%. Set it once with a
   zero-duration tl.set, never as CSS transform-origin alongside a GSAP
   transform.

4. WRITE ONE TWEEN. gsap fromTo on `scale` (and `x`/`y` if panning), from
   scale_from to scale_to, duration = hold - 0.05, ease "sine.inOut" for holds
   <= 5s or "none" for longer, positioned at composition second {{IN}}. Use
   fromTo, never from. Never tween width/height/top/left.

5. IF PANNING, add base scale = 1 + pan_travel_fraction so no frame exposes an
   edge, and tween x/y in px, not left/top.

6. ONE MOTION ONLY. If this still already carries a region reveal, an
   annotation, a spotlight or a colour shift, skip the drift.

ACCEPTANCE TEST: render and step frames {{IN}}, {{IN}}+15, midpoint,
{{OUT}}-3, {{OUT}}-1. (1) Every one of those frames must differ from the last
- no frozen tail. (2) Difference the first and last frame: the displacement
must be a single uniform affine transform with no local motion. (3) Measured
scale ratio / hold must fall in 0.8-2.5 %/s. (4) At the maximum-scale frame,
any text in the image must still read crisply; if it is soft, the resolution
gate in step 1 was not honoured. (5) No frame may show background at an edge.
```

## Execution spec

**HyperFrames.** A still is an `<img>` clip: `data-start` and `data-duration` are **required** on it (an `img` has no intrinsic duration and without one it stays visible for the rest of the composition). Motion is a GSAP tween on the composition's single paused timeline; there is no `data-ease` or `data-animation` attribute.

```html
<img id="still-pricing" class="clip" src="assets/img/pricing-page@4k.png"
     data-start="18.4" data-duration="4.2" data-track-index="1">
```

```js
// hold = 4.2s; rate 1.5%/s -> scale 1.00 -> 1.063; tween ends 0.05s early
tl.set("#still-pricing", { transformOrigin: "62% 38%" }, 0);
tl.fromTo("#still-pricing",
  { scale: 1.0 },
  { scale: 1.063, duration: 4.15, ease: "sine.inOut" },
  18.4
);
```

Contract points that bind this:
- **Author seconds.** There is no frame-based attribute; `data-fps` is a hint and `render --fps` can override it. 4.15 s is 124.5 frames at 30 and 99.6 at 24 — the *rate* is the durable spec, the frame count is not.
- **`fromTo`, never `from`.** `gsap.from()` sets `immediateRender: true` and writes the "from" state at construction, before the clip's `data-start` is active; under the render engine's non-linear seek that flashes or skips.
- **No `width`/`height`/`top`/`left` tweens** — forbidden. Use `scale`, `x`, `y`.
- **No CSS `transform` on the element** alongside the GSAP tween — that is `gsap_css_transform_conflict`, a lint **error**, and a lint error silently switches off the layout and contrast audits.
- **`transformOrigin` goes in a `tl.set`,** not in CSS, for the same reason.
- **Half-open window `[start, start+duration)`.** Land the end state before `data-duration`, or its last frame is never rendered.
- **Root-level clips get automatic layout** (forced `position:absolute`, sized to 100%), but only when they carry `data-start`. An untimed background needs its own `position:absolute; inset:0`.
- **Overflow.** Scale past 1.0 pushes pixels outside the frame. The composition root should `overflow: hidden`; if the layout audit complains about the intentional crop, `data-layout-bleed="true"` is the narrow opt-out — prefer it to `data-layout-allow-overflow`, whose blast radius covers the whole subtree.
- **`class="clip"`** is a convention but keep it: the scaffold's `.clip { position:absolute; inset:0 }` is what gives the element a full-frame box, and lint warns `timed_element_missing_clip_class` without it.
- **Do not measure at tween time.** No `getBoundingClientRect()` in a multi-scene montage — later clips may not be laid out. Compute from authored constants.

**ffmpeg — when the still must become a file** (rare; prefer doing it in the composition). `zoompan` jitters badly if it zooms the source directly, so pre-scale up, zoom, then scale down:

```bash
# 4.2s at 30fps = 126 frames; 1.00 -> 1.063 linear
ffmpeg -loop 1 -i still.png -t 4.2 -vf \
"scale=7680:-2,zoompan=z='min(1+0.0005*on,1.063)':d=126:\
x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1920x1080:fps=30,\
scale=1920:1080:flags=lanczos" -pix_fmt yuv420p drift.mp4
```
`flags=lanczos` on the down-scale is what keeps text crisp. Re-ledger the output with `resolve --from drift.mp4 --type image` if the project uses the media ledger.

**Epidemic Sound.** A drift is deliberately **silent** — it is ambient, below the sound threshold, and sounding it would violate the sound budget ([[motion-silent-motion-tier]]). The still's *arrival* may take a soft transient if it is a hard insert; the drift itself takes nothing.

**Remotion.** `const s = interpolate(frame, [0, dur], [1, 1.063], { easing: Easing.inOut(Easing.sin) })` on a `scale` transform — concept only; Remotion is not a runtime in this project.

## Pairs with
[[motion-parallax-depth-move]] · [[motion-image-focal-point-direction]] · [[motion-key-region-animate-in]] · [[cut-punch-in-emphasis]] · [[pace-visual-change-clock]] · [[pace-overlay-instead-of-cut]] · [[motion-silent-motion-tier]] · [[motion-broll-slot-tier-selection]] · [[cut-stock-footage-substitute]] · [[motion-spotlight-mask-reveal]]

## Failure modes
- **Rate too high.** Above ~4%/s the drift stops being ambient and starts competing with the narration; the viewer watches the move instead of the image. Correction: hold 0.8–2.5%/s.
- **Rate too low.** Below 0.6%/s nothing accumulates and the still still reads as a freeze — you paid for a tween and got nothing. Correction: raise the rate, or shorten the hold and cut.
- **Frozen tail.** The tween ends well before the clip does, so the last half-second is a genuine freeze right where the eye is about to move on. Correction: `duration = hold − 0.05`.
- **Upscaled source.** A 1200px screenshot pushed to 1.15 in a 1080p frame turns hard text into mush and looks worse than no drift at all. Correction: apply the headroom table, or invert to a zoom-out.
- **Zoom that reverses.** In then out inside one clip reads as indecision. Correction: one direction per clip.
- **Every still drifting the same way.** Ten consecutive stills all zooming in at the same rate from centre becomes a visible template. Correction: alternate in/out, vary the rate inside the band, and anchor origins on actual focal points.
- **Edge exposure on a pan.** Panning without base scale reveals page background for a frame or two. Correction: `scale_padding = 1 + pan_travel`.
- **Drift stacked on another motion.** Drift plus a region reveal plus an annotation is three ambient motions in a breathe phase where the doctrine allows exactly one. Correction: drop the drift when the still carries a designed motion event.
- **Known gap:** nothing in this stack chooses the transform origin for you. There is *no automatic face tracking or content-aware reframe* — pan and Ken Burns are authored geometry. The focal point must be named in the design document by a human or an analysis pass, not discovered at render time.
