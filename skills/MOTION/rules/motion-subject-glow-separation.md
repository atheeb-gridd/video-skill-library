---
id: motion-subject-glow-separation
title: Make the subject glow — separate the focal point with light, not with contrast
skill: motion
type: graphic
family: image-treatment
tags: [skill/motion, type/graphic, family/image-treatment, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:15"
    quote: "Oh, and one bonus: make the subject glow."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:32"
    quote: "To make things crystal clear and add visual variety, direct the viewer's attention to the focal point of the image."
research_refs:
  - https://helpx.adobe.com/after-effects/using/stylize-effects.html
  - https://developer.mozilla.org/en-US/docs/Web/CSS/filter
  - https://github.com/PeterL1n/RobustVideoMatting
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: high
detectable_from: video
---

# Make the subject glow — separate the focal point with light, not with contrast

## What it is
The bonus seventh method in the focal-direction set ([[motion-image-focal-point-direction]]). Instead of darkening or blurring what surrounds the subject, you add light *to the subject*, so it separates from its background the way a practical rim light separates an actor from a wall. Mechanically it is three things in sequence: **isolate** the subject as an alpha matte, **bloom** that matte (blur it and add it back), and **animate** the bloom in so the viewer sees the light arrive. The reason it works where a plain brightness lift does not is that a bloom spreads *outside* the subject's silhouette, which reads as luminance in the air rather than as an exposure change — the eye interprets it as depth.

It is the most expensive of the seven methods and the easiest to overcook. The two things that separate a working glow from a cheap one: the glow sits **behind** the subject so the silhouette edge stays crisp, and its radius stays small relative to the frame.

## When to use it
- **A subject inside a busy or low-contrast still**: a face in a crowd, one app icon in a grid, one product on a shelf, one name in a leaderboard. Use it when darkening the surroundings would lose information you still need on screen.
- **A hero reveal**: the thing the whole section is about, arriving. This is where the animated ramp earns its cost — the glow is the reveal, not a treatment.
- **The final state of a build**: several elements arrive, one of them is the answer, and the glow marks which.
- **A cut-out subject composited on a designed plate** — this is the cheapest case, because the matte already exists.
- **Do not use it** on a photograph where the light direction is legible and contradicts the glow: a face lit hard from screen-left with an even all-round glow reads as a compositing error. Use a one-sided glow (`Glow Dimensions: horizontal`, or a directional offset) instead.
- **Do not use it as the standing treatment for every insert.** Like all the focal methods, it needs untreated inserts nearby to read against.

## How to recognise it in a reference video
- **Look for luminance outside the silhouette with no light source to explain it.** Sample a line of pixels crossing the subject's edge into the background and look for a smooth luminance ramp **8–48 px wide at 1080p** falling away from the edge. A hard step is a matte with no bloom; a ramp wider than about 5 % of frame height is a vignette or a background gradient, not a subject glow.
- **Check whether it tracks.** Step 10–20 frames. A real subject glow follows the subject's outline every frame (a per-frame matte); a static soft blob behind a moving subject is a radial gradient and a different, cheaper move — log which one you saw.
- **Check the silhouette edge.** In competent work the subject's own edge stays sharp and the glow is *behind* it. If the subject's edge is also soft and lifted, the glow was composited on top and the shot will look milky.
- **Look for the ramp-in.** Extract frames at 30 fps across the insert's first second: a deliberate glow builds over **15–24 frames** and often holds with a slow breathe. A glow present on frame one is baked into the asset.
- **Look for the halo tell of a bad matte:** a thin bright outline that follows hair, glasses, fingers or a microphone with visible stair-stepping, or a fringe of background colour trapped inside the glow. That is a matting artefact, not the technique.
- **Audio correlation.** A hero glow reveal is almost always sounded — a soft swell, a rise, or a shimmer — arriving with the ramp, not with the cut. A silent glow is usually a graded still.
- **Transcript correlation.** The ramp should start within **±6 frames** of the word that names the subject.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `matte_source` | per-frame alpha | alpha matte · luma key · hand mask | Stills: `remove-background` (u2net). Footage: a video matting model. A luma key only works on already-bright subjects against dark plates. |
| `matte_edge_feather` | 1.5 px @1080p | 1–3 px | Under 1 px the glow stair-steps along the matte; over 3 px the subject edge goes soft. |
| `glow_threshold` | 70 % brightness | 55–85 % | Percentage brightness **below which glow is not applied**. Lower spreads glow across more of the image; higher restricts it to the brightest areas only. |
| `glow_radius` | 24 px @1080p (2.2 % of frame height) | 8–48 px (0.7–4.5 %) | The distance the glow extends from bright areas. Beyond ~5 % of frame height it stops reading as light and becomes fog. |
| `glow_intensity` | 0.45 | 0.20–0.75 | Brightness of the glow. Above 0.75 the bloom clips and the subject loses its own detail. |
| `glow_layers` | 2 | 1–3 | Two stacked blooms (tight+bright, wide+dim) read as real light; one reads as a filter. Cost scales — 3 is the ceiling. |
| `composite_mode` | Behind | Behind · On Top · None | **Behind** keeps the silhouette crisp; On Top gives an overexposed dreamy register; None isolates the glow for separate treatment. |
| `glow_dimensions` | both | both · horizontal · vertical | Use one axis to imply a directional source that matches the shot's key light. |
| `glow_colour` | sampled from the subject's brightest area, desaturated 30 % | — | A neutral or key-light-matched colour reads as light. An off-palette saturated colour reads as a sticker. |
| `ramp_in_duration` | 0.60 s (18 f) | 0.50–0.80 s (15–24 f) | `power2.out`. Light arriving is a **slow** gesture — the 0.5–0.8 s "gravity" band, not the 0.15–0.3 s punch band. |
| `ramp_in_delay` | 0.30 s (9 f) | 0.20–0.60 s | After the insert lands, so the viewer reads the image first and the emphasis second. |
| `breathe` | ±8 % intensity, 2.4 s cycle | ±5–12 %, 1.8–3.2 s | Optional, `sine.inOut`, and it must be the composition's **one** ambient motion in the breathe phase. |
| `hold_after_ramp` | ≥0.8 s | 0.8–3.0 s | The point of the glow is to be looked at; give it time. |
| `background_suppression` | 0 | 0 to −12 % brightness | Optional 6–12 % dip on the background under the ramp. Doubles the separation for free and is cheaper than a bigger glow. |

## Reproduction prompt

```
Glow the subject of the insert {{IMG}} (clip {{IN}}-{{OUT}}) to separate it
from its background.

1. ISOLATE. Produce an alpha matte of the subject. Still image: run the local
   background-removal tool to get an RGBA cut-out. Footage: run a video
   matting model to get a per-frame alpha; a per-frame matte is required if
   the subject moves more than ~2% of frame width across the clip. Feather the
   matte edge by 1.5px at 1080p. Inspect the matte alone at 3 timestamps -
   hair, glasses, fingers and hand-held objects are where it fails.
2. BLOOM, BEHIND THE SUBJECT. Build the stack bottom-to-top:
     (a) background plate (untouched, or dipped 8% in brightness)
     (b) GLOW LAYER: the matte, filled with the glow colour, blurred - two
         passes: sigma 12px at 55% opacity and sigma 32px at 30% opacity
     (c) the sharp subject cut-out on top
   The subject's own edge must never be blurred. Glow threshold 70%: do not
   let the bloom lift midtones inside the subject.
3. COLOUR. Sample the subject's brightest region, desaturate that colour by
   30%, use it as the glow. Do not invent a colour. If the shot has a legible
   key direction, drive the glow on one axis only, matching that direction.
4. ANIMATE. Hold neutral for 0.30s after {{IN}}. Then ramp glow opacity 0 ->
   0.45 over 0.60s, ease power2.out. Optionally add ONE ambient breathe:
   +/-8% on the glow opacity, 2.4s cycle, sine.inOut, finite repeat count -
   never an infinite repeat. Hold at least 0.8s before {{OUT}}. Do NOT animate
   the blur radius; animate opacity or intensity only.
5. SOUND. One soft swell or shimmer whose peak lands at the END of the ramp
   (that is where the visual event completes), 250-800ms, -15 to -18 dB.

ACCEPTANCE TEST: at the ramp's midpoint, the subject edge must still be as
sharp as it was on the untreated frame - compare a 200% crop of the edge
before and after. Measure the luminance ramp crossing the edge into the
background: it must fall to background level within 5% of frame height. Then
show a full frame to someone and ask what they looked at first; if the answer
is not the subject, the glow is too small or the background is too busy for
this method - switch to darkening or blurring the surround instead.
```

## Execution spec

**HyperFrames.** A glow is CSS filters on a stacked set of elements, animated by GSAP on the composition's single paused timeline. The contract confirms `filter` is lint-clean on the master timeline.

```html
<div id="ins-hero" class="clip" data-start="52.0" data-duration="4.0" data-track-index="1">
  <img id="ins-hero-bg"   src="assets/img/crowd.jpg"        style="position:absolute; inset:0; width:100%; height:100%; object-fit:cover;">
  <!-- glow layer: the SAME cut-out, blurred, sitting behind the sharp copy -->
  <img id="ins-hero-glow" src="assets/img/subject-cutout.png"
       style="position:absolute; inset:0; width:100%; height:100%; object-fit:contain;
              filter: blur(12px) brightness(1.6) saturate(0.7); opacity:0;">
  <img id="ins-hero-glow2" src="assets/img/subject-cutout.png"
       style="position:absolute; inset:0; width:100%; height:100%; object-fit:contain;
              filter: blur(32px) brightness(1.9) saturate(0.6); opacity:0;">
  <img id="ins-hero-fg"   src="assets/img/subject-cutout.png"
       style="position:absolute; inset:0; width:100%; height:100%; object-fit:contain;">
</div>
```

```js
const T = 52.0;
tl.to("#ins-hero-glow",  { opacity: 0.55, duration: 0.60, ease: "power2.out" }, T + 0.30);
tl.to("#ins-hero-glow2", { opacity: 0.30, duration: 0.60, ease: "power2.out" }, T + 0.30);
tl.to("#ins-hero-bg",    { filter: "brightness(0.92)", duration: 0.60, ease: "power2.out" }, T + 0.30);
// ONE ambient breathe, attached to the seekable timeline, finite repeat
tl.to("#ins-hero-glow", { opacity: 0.47, duration: 1.2, ease: "sine.inOut",
                          repeat: 2, yoyo: true }, T + 0.95);
```

Contract points that bind this:
- **Never `gsap.to()` outside the timeline for the breathe.** A bare tween runs on wallclock and is absent from the render. Ambient pulses must attach to the seekable `tl`.
- **No `repeat: -1`.** Finite counts only.
- **Animate `opacity`, not `blur`.** Tweening `blur()` re-rasterises every frame and is the most expensive thing you can put in a render; a fixed blur with an animated opacity is visually equivalent for a bloom.
- **`fromTo` or `to` with an authored CSS start state — never `from`.** `from()` sets `immediateRender: true` and writes its start state before the clip's `data-start` is active.
- **`filter` is fine on the master timeline.** The `x/y/scale/rotation/opacity` whitelist is a scene-worker prompt rule, not a binding constraint on `index.html`.
- **No `crossorigin` on any media** — hard lint error with no suppression, and this technique tempts it because canvas/WebGL matting wants pixel readback. Keep every asset project-local.
- **`data-duration` is required** on this `div`/`img` clip, and the ramp must land before it (half-open window).
- **Shader-transition compatibility.** If the composition uses shader transitions, the DOM is captured to WebGL textures via html2canvas, which has documented CSS restrictions — no `transparent` keyword in gradients, no gradient backgrounds under 4 px, no `var()` on captured elements, no gradient opacity below 0.15. A blurred `<img>` captures fine; a CSS-gradient fake glow may not. Mark uncapturable decoratives `data-no-capture`.
- Named rules that may be cited, not quoted: `ambient-glow-bloom`, `asr-keyword-glow`, `depth-of-field-blur`, `particle-burst`.

**Matting.** Stills: `npx hyperframes remove-background subject.png` (u2net) is the local, no-network route the contract documents; `heygen background-removal` is the quality path but is a network path and unavailable here. Footage: a video matting model is the right tool — Robust Video Matting takes **no trimap and no green screen**, outputs a foreground and an alpha (`fgr`, `pha`) plus recurrent state, and reports 172 fps at 1920×1080 and 154 fps at 3840×2160 on an RTX 3090 at FP16, with `downsample_ratio=0.25` for HD and `0.125` for 4K. **Note the environment gap:** this project's device VM is linux ARM64 without sudo, so GPU matting must run elsewhere and the alpha sequence (or a pre-composited RGBA MOV/WebM) enters the composition as a `src`.

**ffmpeg — baking the glow when the asset should arrive finished.**

```bash
# 1. two-layer bloom from an RGBA cut-out, screened over the background
ffmpeg -i bg.jpg -i subject.png -filter_complex "\
 [1]split=3[fg][g1][g2]; \
 [g1]gblur=sigma=12,eq=brightness=0.10:saturation=0.7[b1]; \
 [g2]gblur=sigma=32,eq=brightness=0.16:saturation=0.6[b2]; \
 [0][b2]blend=all_mode=screen:all_opacity=0.30[t1]; \
 [t1][b1]blend=all_mode=screen:all_opacity=0.55[t2]; \
 [t2][fg]overlay[out]" -map "[out]" glow.png

# 2. verify the edge did not soften: crop the same 200px box from both
ffmpeg -i subject.png -vf "crop=200:200:<x>:<y>" edge-before.png
ffmpeg -i glow.png    -vf "crop=200:200:<x>:<y>" edge-after.png
```
`gblur` sigma is the direct analogue of Glow Radius; `blend=all_mode=screen` is the "add the bloom back" step; `eq=brightness` stands in for Glow Intensity. For a threshold-driven bloom on footage with no matte, `lumakey` or `curves` can isolate the highlights first — but a highlight bloom glows *the bright parts of the whole frame*, which is a different and much weaker move than glowing the subject.

**Epidemic Sound.** `SearchSoundEffects { query: { term: "shimmer swell magic reveal" }, filter: { duration: { min: 400, max: 1500 } } }` for the hero case; `{ term: "soft riser short" }` when the glow is the tail of a build. Place the file so its **peak lands at the end of the ramp**, −15 to −18 dB, per [[sfx-envelope-matched-to-easing-curve]].

**Remotion.** Same stack, with `interpolate(frame, [0, 18], [0, 0.55])` driving the glow layers' opacity — conceptually identical; Remotion is not a runtime here.

## Pairs with
[[motion-image-focal-point-direction]] · [[motion-colour-shift-connotation]] · [[motion-annotation-draw-on]] · [[motion-anticipation-build-to-reveal]] · [[motion-attention-transient]] · [[sfx-riser-anticipation-build]] · [[sfx-envelope-matched-to-easing-curve]] · [[motion-look-finishing-pass]] · [[motion-broll-slot-tier-selection]]

## Failure modes
- **Halo from a bad matte.** A bright fringe stair-stepping along hair, glasses or fingers. This is the single most common failure and it is a matting problem, not a glow problem. Correction: inspect the matte alone at three timestamps, feather 1–3 px, and if the matte still fails, switch to darkening or blurring the surround instead.
- **Glow on top of the subject.** Softens the silhouette and makes the whole insert look milky and low-contrast. Correction: composite the bloom **Behind**; keep the sharp cut-out as the top layer.
- **Radius too large.** Past ~5 % of frame height the glow reads as fog or as a badly-made vignette and stops pointing at anything. Correction: 0.7–4.5 % of frame height, and add a small background dip instead of a bigger radius.
- **Intensity clipping.** At high intensity the bloom eats the subject's own highlights, so the thing you were pointing at loses detail. Correction: cap intensity at 0.75, raise the threshold, or dim the background.
- **Glow that contradicts the shot's light.** Even all-round glow on a hard-keyed face. Correction: one-axis glow matching the key direction, or drop the method.
- **Animated blur radius.** Visually indistinguishable from an opacity ramp and dramatically more expensive to render; on heavy compositions it is a `--browser-timeout` risk. Correction: fixed blur, animated opacity.
- **The breathe becomes the composition's third ambient motion.** Everything drifting at once reads as a screensaver. Correction: exactly one ambient motion in the breathe phase; if the scene already drifts, hold the glow static.
- **Glow on every insert.** Removes the baseline the emphasis reads against. Correction: at most one glowed insert per section, with untreated inserts around it.
- **Known gap.** There is no matting, keying, rotoscoping or tracking primitive inside HyperFrames, and no automatic face tracking or content-aware reframe. Every matte is produced **outside** the composition and enters as an RGBA asset; the GPU model needed for per-frame video matting cannot run on this project's authoring VM. Budget that as a separate preprocessing step with its own host, and record the produced asset path in the design document.
