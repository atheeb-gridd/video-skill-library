---
id: motion-parallax-depth-move
title: The perspective move — cut a still into depth planes and fly a camera through it
skill: motion
type: camera
family: still-image-motion
tags: [skill/motion, type/camera, family/still-image-motion, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:19"
    quote: "Or even better, make things more interesting with a change in perspective."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:13"
    quote: "First, give boring still images some movement. Either slowly change the scale or the position."
research_refs:
  - https://en.wikipedia.org/wiki/Ken_Burns_effect
  - https://developer.mozilla.org/en-US/docs/Web/CSS/perspective
  - https://developer.mozilla.org/en-US/docs/Web/CSS/clip-path
  - https://en.wikipedia.org/wiki/Image_scaling
  - https://gsap.com/docs/v3/Eases/
difficulty: high
detectable_from: video
---

# The perspective move — cut a still into depth planes and fly a camera through it

## What it is
The upgrade the source explicitly prefers over a flat scale or pan: instead of moving the *image*, you move a **camera** through it. The still is cut into two to four depth planes — foreground subject, midground, background — the holes left behind the cutouts are filled in, the planes are pushed apart along z, and a perspective projection is applied. Any camera translation then produces **differential** screen motion: near planes travel further than far ones, edges occlude and reveal, and the flat photograph acquires volume. Wikipedia's own description of the Ken Burns family names exactly this: *"By employing simulated parallax, a two-dimensional image can appear as 3D, with the viewpoint seeming to enter the picture and move among the figures."*

The difference from [[motion-still-image-drift]] is not degree, it is kind. A drift is one affine transform applied to the whole frame; a perspective move is **N transforms with different rates**, and that ratio is the entire effect. It is the single highest-value treatment available for a static asset and the most expensive to build.

## When to use it
- **The hero still of a section** — the one image the video is actually about, held 3–6 seconds. Not every still: this costs asset prep, so budget one or two per video.
- **A photo with obvious depth**: a person in front of a scene, a product on a surface, a building against sky, a screenshot with a floating modal over a page. Depth must exist in the picture for the move to be honest.
- **The opening or closing frame** of a video, where an extra beat of production value is worth the build cost.
- **Where a drift has already been used on the neighbouring stills** and this one needs to feel like the important one — the register change *is* the emphasis.
- **Not** on flat graphics: a chart, a block of text, a full-bleed screenshot with no layered content. Fake depth on genuinely flat material reads as a warped photograph.
- **Not** on a still held under 2 seconds; the differential needs time to accumulate before the occlusion reads.
- **Not** in a composition that uses `@hyperframes/shader-transitions` on the same scene — the shader path captures the DOM through html2canvas, and 3D-transformed subtrees do not reliably survive that capture.

## How to recognise it in a reference video
- **Differential displacement is the definitive test.** Extract the hold at 30fps. Track one foreground feature and one background feature between the first and last frame. Compute `ratio = displacement_near / displacement_far`. A flat drift gives **exactly 1.0** (within tracking error). A perspective move gives **1.3–2.5**; above ~3.0 it usually reads as exaggerated.
- **Occlusion reveal at the cutout boundary.** Watch the silhouette edge of the foreground subject: as the camera travels, background that was hidden behind the subject becomes visible. This is impossible with any affine transform and is the cleanest single tell. It is also where bad builds fail — see failure modes.
- **Straight lines change their convergence.** If the move includes a `rotateY`/`rotateX` component, horizontals and verticals in the picture visibly change angle across the hold. Pure `translateX` with perspective produces displacement without convergence change; both are legitimate.
- **Plane count.** Step frames and count how many distinct displacement rates you can measure. Two rates = subject + background. Three = a real build. Four or more is unusual outside dedicated motion-design work.
- **Edge softness on the cut-out.** Look at the subject's silhouette at 200%: a clean build has a 1–2 px feathered matte; a rushed one has hard jaggies or a halo of background colour.
- **Rate.** Same band as a drift for the *slowest* plane: **0.8–2.5%/s**. The near plane runs at the ratio above that, so 2–5%/s.
- **Log it as a negative too.** A reference that never does this — every still flat-drifted — is telling you its motion budget, and that belongs in the style profile.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `plane_count` | 3 | 2–4 | Foreground / midground / background. Two is the honest minimum; above four the prep cost explodes for no visible gain. |
| `perspective` | 1400 px | 800–2000 px | On the container, for a 1920-wide frame. MDN's own calibration: 500px is dramatic, 1000px moderate, 2000px subtle. Scale proportionally for other frame widths. |
| `z_background` | −600 px | −400 … −1000 px | With `perspective: 1400`, `z=−600` gives an apparent scale of `1400/2000 = 0.70`. |
| `z_midground` | 0 px | −200 … +100 px | The reference plane; keep the main subject near z=0 so it stays sharp and correctly sized. |
| `z_foreground` | +250 px | +120 … +400 px | Apparent scale `1400/1150 = 1.217`. Do not exceed ~+0.3×perspective or the plane blows past the frame. |
| `compensating_scale` | `(perspective − z) / perspective` | — | **Mandatory.** Pre-scale each plane by this so it occupies its authored size despite the projection. Background at z=−600, p=1400 → pre-scale `2000/1400 = 1.4286`. Foreground at +250 → `1150/1400 = 0.8214`. |
| `camera_travel_x` | 3 % of frame width | 1.5–6 % | As `x` on the container, or as an opposite-sign translate on the plane group. 3% of 1920 = 58 px. |
| `camera_rotateY` | 0° | 0–3° | Optional. Adds convergence change. Above 3° a photograph starts to look like a warped plane. |
| `camera_dolly_z` | 0 px | 0–180 px | A push *into* the scene. Combines with travel for the "moving among the figures" read. |
| `parallax_ratio` | ~1.9 | 1.3–2.5 | Derived, not authored: `(p − z_far) / (p − z_near)`. With the defaults, `2000/1150 = 1.74`. Measure it, do not guess it. |
| `duration` | 4.0 s | 2.5–6.0 s | Below 2.5s the occlusion has no time to read. |
| `ease` | `sine.inOut` | `sine.inOut` \| `none` | A camera move is calm. Never an out-ease, never `back`/`elastic`. |
| `inpaint_margin` | 1.5 × max relative displacement | ≥1.0× | How far the background plane must be filled in behind each cutout. With 58 px travel and ratio 1.74, relative displacement is ~25 px → inpaint ≥ 38 px beyond every silhouette edge. |
| `matte_feather` | 1.5 px @1080p | 1–3 px | On the cutout alpha. Hard mattes read as stickers. |
| `plane_blur` | 0 px | 0–4 px on the far plane | A touch of blur on the background sells depth and hides inpaint seams. Keep off the subject. |

## Reproduction prompt

```
Build a perspective (2.5D) camera move on the still {{SRC}}, held {{IN}} to
{{OUT}} (duration {{D}} = {{OUT}} - {{IN}}).

0. GATE. Require {{D}} >= 2.5s and a picture with real depth (a subject in
   front of a scene). If the image is flat - a chart, a text card, a
   full-bleed screenshot - do NOT do this; apply a plain drift instead.

1. PREPARE ASSETS (outside the composition). Produce 3 PNGs with alpha:
     plane-fg.png  - the nearest subject, cut out, matte feathered 1.5px
     plane-mid.png - the middle band, cut out
     plane-bg.png  - the full background, with the regions behind BOTH
                     cutouts filled in / inpainted at least 1.5x the maximum
                     relative displacement (compute in step 3) beyond every
                     silhouette edge.
   Every plane must be at least 1.5x the output width in pixels, because the
   compensating scale in step 4 magnifies the far plane.

2. SET THE CAMERA. Container gets perspective: 1400px (for a 1920-wide frame;
   scale proportionally otherwise), perspective-origin: 50% 50%, and
   transform-style: preserve-3d. Every plane is a block-level, explicitly
   sized, absolutely positioned child.

3. SET DEPTHS. bg z = -600, mid z = 0, fg z = +250.
   parallax_ratio = (1400 + 600) / (1400 - 250) = 2000 / 1150 = 1.74.
   camera_travel = 0.03 * frame_width (58px at 1920).
   max relative displacement = camera_travel * (1 - 1/1.74) = ~25px.
   inpaint_margin = 1.5 * 25 = ~38px. Feed that back into step 1.

4. COMPENSATE SCALE. Each plane is pre-scaled by (1400 - z) / 1400:
     bg  -> 2000/1400 = 1.4286
     mid -> 1.0
     fg  -> 1150/1400 = 0.8214
   Apply these with a zero-duration tl.set on the timeline, together with
   translateZ. Do NOT write them as CSS transforms - that is a lint error
   against the GSAP tween.

5. MOVE THE CAMERA, NOT THE PLANES. One tween on the container:
   x from -29 to +29 (half the travel each way), duration {{D}} - 0.05,
   ease "sine.inOut", positioned at {{IN}}. Optionally add rotateY -1.2 -> +1.2
   and/or z 0 -> 120 on the same tween for a dolly-in.

6. DEPTH CUES. Optional: 2px blur on the background plane, held constant. No
   blur on the subject.

ACCEPTANCE TEST: render and step {{IN}}, midpoint, {{OUT}}-2f.
(1) Track one foreground and one background feature; displacement_near /
displacement_far must measure between 1.3 and 2.5 - if it is 1.0 you have
built a drift, not a perspective move.
(2) At the extreme frames, inspect the silhouette edges at 200%: background
revealed by the move must be real filled pixels, never a hole, a smear, or a
repeated edge column.
(3) The subject must stay sharp; only the far plane may carry blur.
(4) No plane may expose the frame edge at any point in the move.
(5) Mute and watch: the move must read as a camera, not as an image being
distorted. If the picture appears to bend, rotateY is too high.
```

## Execution spec

**HyperFrames.** CSS 3D transforms are one of the 13 fully-staged broader techniques, and the animation rule library names `3d-camera-flight`, `depth-scatter-assemble` and `orbit-3d-entry` for this territory (names only — those recipe files are not staged, so cite them, do not quote code from them).

```html
<div id="depth-shot" class="clip" data-start="18.4" data-duration="4.2" data-track-index="1"
     style="perspective:1400px; perspective-origin:50% 50%; overflow:hidden;">
  <div id="depth-cam" style="position:absolute; inset:0; transform-style:preserve-3d;">
    <img id="p-bg"  src="assets/img/hero-bg-inpainted.png"  style="position:absolute; inset:0; width:100%; height:100%; object-fit:cover;">
    <img id="p-mid" src="assets/img/hero-mid.png"           style="position:absolute; inset:0; width:100%; height:100%; object-fit:cover;">
    <img id="p-fg"  src="assets/img/hero-fg.png"            style="position:absolute; inset:0; width:100%; height:100%; object-fit:cover;">
  </div>
</div>
```

```js
const P = 1400;
const comp = z => (P - z) / P;               // compensating scale

tl.set("#p-bg",  { z: -600, scale: comp(-600), filter: "blur(2px)" }, 0);  // 1.4286
tl.set("#p-mid", { z:    0, scale: comp(0)   }, 0);                        // 1.0
tl.set("#p-fg",  { z:  250, scale: comp(250) }, 0);                        // 0.8214

// move the camera group, not the planes
tl.fromTo("#depth-cam",
  { x: -29, rotationY: -1.2 },
  { x:  29, rotationY:  1.2, duration: 4.15, ease: "sine.inOut" },
  18.4
);
```

Contract points that bind this:
- **`transform-style: preserve-3d` and `perspective` live in CSS on the container; every animated transform lives on the timeline.** Putting a `transform` in CSS on an element GSAP also tweens is `gsap_css_transform_conflict` — a lint **error**, and an error switches off the layout and contrast audits so `check` reports `0 sample(s)` and looks clean while nothing ran.
- **Transformed elements must be block-level and explicitly sized.** That is a stated determinism rule, and a 3D-transformed `<img>` without a resolved box is the classic collapse-to-zero bug.
- **`z` and `rotationY` are GSAP transform aliases** and are legal alongside `x`/`y`/`scale`. `width`/`height`/`top`/`left` tweens remain forbidden.
- **The clip wrapper carries `data-start` and `data-duration`; the inner camera group must not.** A timed ancestor clamps its descendants, and `video_nested_in_timed_element` is an error for video specifically — keep the timing on exactly one level.
- **Half-open window:** land the move before `data-duration`.
- **No `getBoundingClientRect()` at tween time.** All the numbers above are authored constants derived from the perspective value, exactly as the determinism rules require.
- **Shader transitions are incompatible on the same scene.** The shader path rasterises the DOM through html2canvas; 3D-transformed subtrees are not reliably captured. If the composition uses `@hyperframes/shader-transitions`, either keep this scene off the shader path or fall back to [[motion-still-image-drift]].
- **`data-layout-bleed="true"`** on the wrapper for the intentional crop, in preference to `data-layout-allow-overflow` (which inherits down the whole subtree and also suppresses `text-clipping` and `content-cramped-container`).
- **Vendoring:** GSAP must load from a local path. `cdn.jsdelivr.net` is blocked by the egress allowlist and a CDN `<script>` renders a blank composition.

**Asset prep — ffmpeg and local tools only.** The cut-out and the inpaint are the real work and neither is a HyperFrames capability:

```bash
# subject matte (u2net, local, free)
npx hyperframes remove-background hero.png          # -> hero-fg.png with alpha
# upscale a too-small plane before compensating scale magnifies it
realesrgan-ncnn-vulkan -i hero-bg.png -o hero-bg-4x.png -s 4
```
There is **no inpainting tool in this stack.** Filling the background behind the cutout is an external step (a paint pass, or a generative fill outside the pipeline) and must be scheduled as an asset dependency in the design document. Note also that `realesrgan-ncnn-vulkan` is not verified present in this environment.

**Epidemic Sound.** A camera move of this scale sits at the boundary of the silent tier. If it is sounded, use a sustained texture rather than a transient, matched to the whole duration:
```
SearchSoundEffects { query: { term: "air movement texture sustained low drone" },
                     filter: { duration: { min: 3000 } } }
```
at −18 to −22 dB — quieter than a motion effect, because the move has no onset ([[sfx-camera-move-air-accent]]).

**Remotion.** Same geometry, frame-native: `interpolate(frame, [0, dur], [-29, 29])` on the camera group's `translateX` with the planes at fixed `translateZ`. Concept only; Remotion is not a runtime here.

## Pairs with
[[motion-still-image-drift]] · [[motion-image-focal-point-direction]] · [[motion-key-region-animate-in]] · [[sfx-camera-move-air-accent]] · [[motion-silent-motion-tier]] · [[motion-spotlight-mask-reveal]] · [[motion-broll-slot-tier-selection]] · [[motion-format-promise-motion-budget]] · [[motion-storyboard-motion-spec]]

## Failure modes
- **No inpaint behind the cutout.** The single most common failure: the camera moves, the subject shifts, and a hole or a smeared edge-column appears where the background should be. Correction: fill the background plane at least 1.5× the maximum relative displacement beyond every silhouette, computed from the parallax ratio *before* the asset is cut.
- **No compensating scale.** Planes pushed to negative z simply appear smaller and the image looks like three mismatched pictures stacked. Correction: pre-scale every plane by `(perspective − z) / perspective`.
- **Perspective too aggressive.** Below ~800px on a 1920 frame the projection distorts the picture and the photograph visibly bends. Correction: 1400px default; only go under 1000px for a deliberately dramatic register.
- **Hard matte.** An unfeathered cutout reads as a sticker pasted on a backdrop. Correction: 1–3 px feather, and a touch of blur on the far plane to break the seam.
- **Ratio too high.** Above ~3.0 the near plane skates across the far one and the brain reads it as a videogame layer, not a photograph. Correction: keep 1.3–2.5.
- **Too-small source planes.** The background is pre-scaled by ~1.43, so a 1920px background becomes an effective 1344px of real detail in a 1920 frame. Correction: every plane at ≥1.5× output width.
- **Overuse.** Three of these in a row and the video reads as a template. Correction: one or two per video, on the stills that carry the argument.
- **Known gap:** this stack has **no automatic depth estimation, no matting beyond u2net background removal, and no inpainting at all**. The three planes are an authored asset dependency, produced outside the pipeline. A note that assumes the composition can generate its own depth planes is writing against something that does not exist here.
