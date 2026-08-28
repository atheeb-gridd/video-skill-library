---
id: motion-spotlight-mask-reveal
title: Darken and blur the surround — the animated spotlight on an image's focal point
skill: motion
type: graphic
family: image-treatment
tags: [skill/motion, type/graphic, family/image-treatment, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:24"
    quote: "If you just throw the whole image up there, that's boring and, more importantly, confusing. To make things crystal clear and add visual variety, direct the viewer's attention to the focal point of the image."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:56"
    quote: "Darken or blur the area surrounding the focal point of the image."
research_refs:
  - https://pyimagesearch.com/2018/07/16/opencv-saliency-detection/
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Blend_modes
  - https://www.nngroup.com/articles/animation-duration/
  - https://en.wikipedia.org/wiki/Shutter_angle
difficulty: medium
detectable_from: video
---

# Darken and blur the surround — the animated spotlight on an image's focal point

## What it is
Two of the creator's six focal-point methods — *darken the area surrounding the focal point* and *blur the area surrounding the focal point* — are one mechanism with two fills: a **full-frame treatment layer with a hole in it**, animated in so the viewer watches the frame narrow onto the point. Darken fills the layer with black at 45–70 % opacity; blur fills it with a blurred copy of the same image. The hole is a soft-edged radial or rounded-rect mask centred on the focal point. [[motion-image-focal-point-direction]] owns the decision that *every* inserted image gets treated; [[motion-annotation-draw-on]] and [[motion-subject-glow-separation]] own the additive methods. This note owns the subtractive one: the geometry of the hole, the ramp that closes it, and the resolution-dependent numbers that make it look like a lighting choice rather than a filter.

It is the strongest of the six because it removes information rather than adding it. Nothing competes with the focal point once the surround is 55 % darker and 8 px softer — and unlike a crop, the viewer still sees the whole image, so the context survives.

## When to use it
- A **screenshot with one relevant line**, a **chart with one relevant series**, a **photo with one relevant face or object** — anywhere the image is larger than the point being made.
- The image must stay whole because the surround is evidence ("this is a real page, here is the bit that matters"). If the surround is not evidence, crop instead — it is cheaper and sharper.
- A **dense** image (UI, spreadsheet, document, thumbnail grid): darken *and* blur together; either alone leaves too much competing detail.
- A **clean** image (a face, one object on a plain ground): darken only, at the low end (0.40–0.50). Blur on a clean image reads as a mistake in the source photo.
- Not on footage of a person speaking — vignetting a talking head reads as a look ([[motion-look-finishing-pass]]), not as direction.

## How to recognise it in a reference video
- **Corner-vs-centre luminance.** Sample mean luma in a 10 %-of-frame patch at each corner and at the focal region across the shot. A spotlight shows the corners **falling 25–50 %** while the focal patch holds within ±5 %. A global fade drops both.
- **The hole moves or the hole is static.** Track the bright region's centroid across the shot: a static hole means the image is treated as a still; a hole that drifts with a Ken-Burns push means the mask is parented to the image.
- **Ramp length.** Time the corner luma from 100 % to its floor: **10–18 frames @30fps** is the working band. Instant (1 frame) means it was baked into the still, not animated — a different, weaker pattern worth logging.
- **Blur signature.** Crop the surround and measure high-frequency energy (edge density, or a Laplacian variance): a blurred surround loses 60–90 % of it while the focal region does not. Also check the **boundary** — a hard edge between sharp and blurred means no feather and is an amateur tell.
- **Feather width.** Measure the transition band between full treatment and no treatment: **8–12 % of the hole's radius** looks natural; under 3 % looks like a cut-out.
- **Word binding.** The ramp should start within **±0.3 s of the keyword** naming the thing in the hole.
- **Release.** Note whether the treatment lifts before the cut (rare, deliberate) or the shot simply cuts away with the spotlight still on (common).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `scrim_opacity` | 0.55 | 0.40–0.70 | Black scrim over the surround. Above 0.75 the surround stops being evidence. |
| `scrim_colour` | `#000` | `#000`–`#0a0f18` | A very slightly blue-black reads cleaner over warm screenshots. Never pure white. |
| `blur_sigma` | 0.8 % of frame width | 0.5–1.2 % | **Scale with resolution**: 15 px at 1920 wide, 30 px at 3840. A fixed px value looks right in preview and wrong in a 4K render. |
| `hole_diameter` | 28 % of frame height | 22–35 % | For a face. For a text region: the bbox plus 4 % of frame height of padding on each side. |
| `hole_shape` | radial | radial · rounded-rect | Rounded-rect (radius 24 px @1080p) for text blocks and UI panels; radial for faces and objects. |
| `feather` | 10 % of hole radius | 8–12 % | The `radial-gradient` stop spread. |
| `ramp_in` | 0.45 s (13 f) | 0.35–0.60 s | `power2.out`. Inside NN/g's "substantial change" band (200–400 ms) with headroom because it is content, not UI. |
| `iris_close` | 1.35 → 1.00 | 1.2–1.6 start | Optional: the hole starts larger and closes onto the point over `ramp_in + 0.1 s`, `power3.out`. Reads as the frame narrowing. |
| `hold` | 1.4 s | 1.0–4.0 s | Time the spotlight sits still before anything else happens. |
| `release` | none | 0–0.35 s | Default is to cut away treated. If lifting, 0.30 s `power2.inOut`. |
| `focal_bias` | rule of thirds | — | If the detected focal point is within 8 % of frame edge, pan the image so the hole sits at least 12 % inside the frame — a spotlight touching the frame edge reads as a crop error. |
| `keyword_offset` | −0.15 s | −0.35 to +0.10 s | Treatment leads the word slightly. |

## Reproduction prompt

```
Treat the image at {{IN}}–{{OUT}} with an animated spotlight on its focal
point. Author time in SECONDS; frame counts @30fps are derived comments.

STEP 1 - LOCATE THE FOCAL POINT, in this priority order, and record it as a
normalised (fx, fy) in 0..1 plus a normalised radius fr:
  (a) a face, if the image contains one (largest face box, centre, r = 0.9x
      the box's larger side);
  (b) the text region the narration names, via OCR bounding box (union of the
      matched lines, plus 4% of frame height padding);
  (c) otherwise the saliency peak: OpenCV StaticSaliencyFineGrained, Otsu
      threshold, largest contour centroid, r = sqrt(area/pi) x 1.4.
If (fx, fy) lands within 0.08 of any edge, translate the image so the hole
sits at least 0.12 inside the frame.

STEP 2 - BUILD THE STACK, bottom to top, all pinned to the same box:
  L0  the image (sharp)
  L1  a copy of the image, blurred sigma = 0.008 x frame_width, masked so it
      is TRANSPARENT inside the hole
  L2  a solid #000 rectangle at final opacity 0.55, masked with the same hole
  L3  annotations / captions (above the treatment, never under it)
Both masks are radial-gradient(circle at {{fx}}% {{fy}}%, transparent
{{fr*90}}%, black {{fr*110}}%) - a 10% feather band.

STEP 3 - ANIMATE, starting at (keyword onset - 0.15):
  tl.fromTo("#scrim", { autoAlpha: 0 }, { autoAlpha: 1, duration: 0.45,
            ease: "power2.out" }, T);
  tl.fromTo("#blurlayer", { autoAlpha: 0 }, { autoAlpha: 1, duration: 0.45,
            ease: "power2.out" }, T);
  Optional iris: tl.fromTo("#maskwrap", { scale: 1.35 }, { scale: 1.0,
            duration: 0.55, ease: "power3.out" }, T);
Hold everything still for at least 1.4s after the ramp completes. Do not
also animate the base image during the ramp - one change at a time.

STEP 4 - SOUND. One soft low-frequency swell or a short reverse whoosh on
the ramp, 300-700ms, at -18 dB relative to dialogue. Not a hit.

ACCEPTANCE TEST: sample mean luma in a 10%-frame patch at all four corners
and in the focal region, before T and 20 frames after T. Corners must drop
40-60%; the focal patch must stay within +/-5%. The sharp/blurred boundary
must span at least 8% of the hole radius - no hard edge anywhere.
```

## Execution spec

**HyperFrames.** Three stacked elements inside one timed wrapper. The masks are CSS; the animation is opacity and scale only, which keeps it inside the transform whitelist.

```html
<div id="shot-screenshot" class="clip" data-start="88.0" data-duration="6.0" data-track-index="1">
  <img id="shot-base" src="assets/img/dashboard.png">
  <img id="shot-blur"  src="assets/img/dashboard.png">
  <div id="shot-scrim"></div>
</div>
<style>
  #shot-screenshot { position: absolute; inset: 0; }
  #shot-base, #shot-blur { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; }
  /* 0.8% of 1920 = 15px */
  #shot-blur  { filter: blur(15px); opacity: 0; }
  #shot-scrim { position: absolute; inset: 0; background: #000; opacity: 0; }
  #shot-blur, #shot-scrim {
    -webkit-mask-image: radial-gradient(circle at 62% 41%, rgba(0,0,0,0) 25%, rgba(0,0,0,1) 31%);
            mask-image: radial-gradient(circle at 62% 41%, rgba(0,0,0,0) 25%, rgba(0,0,0,1) 31%);
  }
</style>
```

```js
const T = 88.6;                                   // keyword onset 88.75 - 0.15
tl.to("#shot-blur",  { opacity: 1,    duration: 0.45, ease: "power2.out" }, T);
tl.to("#shot-scrim", { opacity: 0.55, duration: 0.45, ease: "power2.out" }, T);
// optional iris close on a wrapper that carries BOTH masked layers
tl.fromTo("#shot-maskwrap", { scale: 1.35 }, { scale: 1.0, duration: 0.55, ease: "power3.out" }, T);
```

Contract points and traps:
- `filter` is **lint-clean on the master timeline** (the `x/y/scale/rotation/opacity` whitelist binds scene-worker prompts, not `index.html`), so a `blur()` layer is legal — but tweening `filter` per frame is expensive; prefer a **static** blur and tween the layer's `opacity`.
- The wrapper carries `data-start`, so the framework forces it `position: absolute; inset: 0`. The inner layers are **not** timed, so they need their own `position: absolute; inset: 0` or they collapse.
- Do not put a CSS `transform` on `#shot-maskwrap` if you also tween `scale` — `gsap_css_transform_conflict` is a hard error.
- Land the ramp's end state at least 2 frames before `data-duration` (half-open window).
- **Known gap:** if the composition uses shader transitions, the two treatment layers are captured to a WebGL texture via html2canvas, and CSS `mask-image` support there is unreliable. In a shader-transition composition, bake the treatment with ffmpeg into a still and place that instead, or mark decoratives `data-no-capture` and accept a plain crossfade at that boundary.
- Blur is a **look**, so it must survive the layout audit — the treated image is still an `<img>` in the layout, so no `data-layout-*` opt-out is needed unless the annotation on top overflows.

**ffmpeg — baking the treatment (for a still, or for a shader-transition composition).**

```bash
# darken the surround only, centred on the focal point (x0,y0 in pixels)
ffmpeg -i shot.png -vf "vignette=x0=1190:y0=443:angle=PI/4" shot.spot.png

# darken AND blur the surround with an explicit radial alpha mask
ffmpeg -i shot.png -f lavfi -i "color=black:s=1920x1080" \
  -filter_complex "\
   [0:v]split=2[base][b1];[b1]gblur=sigma=15[bl];\
   [base][bl]blend=all_expr='A*(1-M)+B*M'" -y shot.blurred.png   # M = your mask input

# measure the result: corner vs centre luma
ffmpeg -i shot.spot.png -vf "crop=192:108:0:0,signalstats,metadata=print" -f null -
```

`vignette` takes `x0`/`y0`, so an off-centre spotlight is a one-liner; `angle` (default `PI/5`) controls falloff — `PI/4` is a stronger, tighter darkening.

**Focal-point detection (offline, produces the (fx, fy, fr) the spec needs).**

```python
import cv2, numpy as np
img = cv2.imread("shot.png")
sal = cv2.saliency.StaticSaliencyFineGrained_create()      # output already 0..255
ok, m = sal.computeSaliency(img)
m = (m * 255).astype("uint8") if m.max() <= 1.0 else m.astype("uint8")
_, th = cv2.threshold(m, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)
c = max(cv2.findContours(th, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[0], key=cv2.contourArea)
M = cv2.moments(c); fx, fy = M["m10"]/M["m00"], M["m01"]/M["m00"]
fr = (cv2.contourArea(c) / np.pi) ** 0.5 * 1.4
```

Run a face detector first and prefer its box; run OCR (any engine) and prefer the line matching the narration's keyword. Saliency is the fallback, not the first choice — it finds *contrast*, which on a screenshot is usually the header, not the point.

**Remotion.** Same three-layer stack with `interpolate` on the two opacities; `mask-image` behaves identically in a Chromium render. Concept only.

## Pairs with
[[motion-image-focal-point-direction]] · [[motion-annotation-draw-on]] · [[motion-subject-glow-separation]] · [[motion-colour-shift-connotation]] · [[motion-screen-recording-cursor-punch-in]] · [[motion-attention-transient]] · [[motion-look-finishing-pass]] · [[cut-screen-recording-proof-insert]] · [[motion-sfx-pass-manifest]]

## Failure modes
- **Fixed-pixel blur.** 15 px is right at 1920 and invisible at 3840. Correction: express sigma as a fraction of frame width and compute it.
- **No feather.** A hard-edged hole reads as a badly cut-out sticker. Correction: 8–12 % of the hole radius as a gradient band.
- **Scrim too heavy.** At 0.8 the surround stops being evidence and the shot might as well be a crop. Correction: 0.55, and crop instead if the surround is genuinely irrelevant.
- **Hole on the wrong thing.** Saliency finds the brightest contrast, which on a UI screenshot is often the nav bar. Correction: OCR/face first, saliency last, and always verify against the narration keyword.
- **Hole at the frame edge.** Reads as a framing mistake. Correction: pan the image so the hole sits ≥12 % inside.
- **Treating a talking head.** A vignette on A-roll is a grade decision, not direction, and doing it per-shot makes the grade inconsistent. Correction: put it in the look pass.
- **Animating the image and the treatment at once.** Two simultaneous changes split attention ([[motion-attention-transient]]). Correction: land the treatment, hold, then start any drift.
- **Baking the treatment into the source PNG when the composition also pushes in on the image.** The spotlight then scales with the image and drifts off the point. Correction: keep the mask in a wrapper that does not scale, or parent it deliberately and say so.
