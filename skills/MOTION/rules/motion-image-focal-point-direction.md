---
id: motion-image-focal-point-direction
title: Never drop a whole image on screen unguided — name its focal point
skill: motion
type: graphic
family: image-treatment
tags: [skill/motion, type/graphic, family/image-treatment, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:07:26
    quote: "If you just throw the whole image up there, that's boring and, more importantly, confusing."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:07:32
    quote: "To make things crystal clear and add visual variety, direct the viewer's attention to the focal point of the image."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:07:49
    quote: "Animate in the most important line of text or the most important part of the image you're highlighting."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:07:56
    quote: "Darken or blur the area surrounding the focal point of the image."
research_refs:
  - https://pyimagesearch.com/2018/07/16/opencv-saliency-detection/
  - https://medium.com/data-science/opencv-static-saliency-detection-in-a-nutshell-404d4c58fee4
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/4406208331923-Title-Safe-and-Safe-Action-Best-Practices
  - https://www.adobe.com/creativecloud/video/discover/how-to-blur-a-video.html
  - https://cloudinary.com/guides/image-effects/ken-burns-effect-complete-guide-and-how-to-apply-it
difficulty: medium
detectable_from: video
---

# Never drop a whole image on screen unguided — name its focal point

## What it is
A rule with a pipeline attached: **no screenshot, photo, chart or tweet ever appears at full frame untreated.** Every inserted image gets a named focal point and at least one treatment that points at it. The source's argument is that the failure is not primarily aesthetic — an unguided image is *confusing*, because the viewer spends the shot hunting for what they are supposed to look at, and the narration has moved on by the time they find it. The seven named treatments are: animate in the important line or part; darken the surround; blur the surround; shift colour toward red for a negative reading; toward yellow/green for a positive one; circles, arrows and underlines; and — as a bonus — make the subject glow.

## When to use it
Every time an image, screenshot, UI capture, chart, comment, headline or document enters the timeline. The trigger is mechanical: if the clip's source is a still, the rule fires. Escalate the treatment with how much the image matters and how dense it is — a full-page screenshot with one relevant line needs crop **plus** darken **plus** an animated highlight; a single product photo needs only a slow scale and a soft vignette. The one exception is a deliberate "here is the whole thing, and its scale is the point" beat (a huge spreadsheet, a wall of comments) — and even there, the treatment is a punch-in *after* two seconds of the whole, not instead of it.

## How to recognise it in a reference video
- **Extract the still and compare it to the source asset.** If the on-screen image is cropped tighter than the original, or repositioned off-centre, the shot has been reframed to a focal point:
  `ffmpeg -ss <t> -i ref.mp4 -frames:v 1 -update 1 shot.png`
- **Look for a luminance gradient that does not belong to the image.** Sample mean luma in a centre box and in the four corners of the same frame. A surround darkened for attention typically sits **35–60% below** the focal region's luma. An image's own vignette is symmetric; an attention vignette is *offset toward the focal point*.
- **Look for a sharpness gradient.** Compute variance-of-Laplacian in the focal box vs the surround. A blur treatment drops surround sharpness by **60%+** while the focal box stays sharp. Blur radius in practice: **8–16 px at 1080p** for a soft separation, 20–30 px when the surround is meant to be unreadable.
- **Look for a colour shift with no diegetic cause.** Mean hue pushed toward red (negative framing) or toward yellow/green (positive). A **10–25° hue rotation with 5–15% saturation lift** is the practical band; more than that reads as a broken grade.
- **Frame-step for the reveal order.** The tell of a competent treatment is that the *surround appears first and the highlight arrives second*, 6–15 frames later, so the viewer sees context then target. Simultaneous arrival is weaker and much more common in amateur work.
- **Look for movement on a still.** Any still that holds for more than ~1.5 s in professional work is moving: a scale or position ramp of roughly **1.5–2.5% per second**, linear or `sine.inOut`, or a harder punch-in on an emphasis line.
- **Look for drawn marks:** circles, arrows, underlines. Animated in (a stroke that draws on over 8–14 frames) rather than cut in.
- **Transcript correlation.** The highlight's arrival frame should sit within **±6 frames** of the spoken word it names. If it lands a second late, log it as a defect, not as the technique.
- **Count the untreated stills.** This is the cheapest quality metric available for an explainer: untreated full-frame stills per minute. Good work is at 0.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `focal_box` | — | — | `x,y,w,h` in source-image pixels. Required. Everything else derives from it. |
| `crop_headroom` | 1.4× | 1.15–2.0× | Focal box is scaled up until it occupies this fraction of the frame's short axis. Above 2.0× you need a higher-resolution source. |
| `source_res_floor` | frame_w × max_scale | — | An image scaled to 1.6× on a 1920-wide frame needs ≥3072 px of width or it softens visibly. Check before designing the move. |
| `surround_darken` | 0.45 | 0.30–0.65 | Alpha of a black overlay outside the focal region. Below 0.30 it does not read; above 0.65 the context is destroyed. |
| `surround_blur` | 12 px | 6–30 px @1080p | 6–10 soft separation · 12–16 standard · 20–30 make-unreadable. Scale linearly with frame height. |
| `vignette_feather` | 12% of frame width | 6–20% | Hard edges look like a mask; feather them. |
| `hue_shift_negative` | +14° toward red | 8–25° | Plus 5–12% saturation. |
| `hue_shift_positive` | −16° toward yellow/green | 8–25° | Same saturation range. |
| `highlight_in_dur` | 0.35 s (10 f) | 0.25–0.50 s | Entrance of the mark/box/underline. House ease `power3.out`. |
| `highlight_delay` | 0.30 s (9 f) | 0.20–0.50 s | Delay after the image lands, so context reads first. |
| `stroke_draw_dur` | 0.40 s (12 f) | 0.27–0.60 s | For a circle or underline that draws on. |
| `still_drift_rate` | 2%/s | 1.2–3%/s | Scale or position ramp on a held still. |
| `punch_in_scale` | 1.18× | 1.10–1.35× | The harder emphasis push on a specific detail. |
| `punch_in_dur` | 0.45 s (13 f) | 0.30–0.60 s | `power3.out`. |
| `glow_strength` | 0.35 | 0.2–0.5 | Bonus treatment; a drop-shadow/blur bloom behind the subject. |
| `min_hold` | 1.2 s | 0.8–4 s | An image on screen for less than 0.8 s cannot be read, treated or not. |
| `title_safe` | 90% of frame | 90–93% | Netflix/SMPTE: title safe **90%**, action safe **93%** of the 16:9 frame. Marks and labels stay inside title safe. |

## Reproduction prompt

```
Treat the still {{IMG}} that lands at {{IN}} and holds until {{OUT}}. It must
never appear untreated at full frame.

1. NAME THE FOCAL POINT. Write it in the design doc as one clause ("the
   'retention' column header", "the face at frame left"). Then resolve it to a
   pixel box FOCAL = x,y,w,h in the source image's own coordinates. Derive it
   in this priority order:
     a) an explicit box in the design document;
     b) if the image contains the text the narration is reading, the OCR
        bounding box of that text, dilated 12px;
     c) a face box if the subject is a person;
     d) an OpenCV saliency map (StaticSaliencyFineGrained), Otsu-thresholded,
        largest contour's bounding rect.
   If none of these yields a box that covers less than 60% of the image, the
   image is too busy to insert - crop it into two inserts instead.

2. REFRAME. Scale the image so FOCAL fills 1.4x of the frame's short axis, and
   translate so FOCAL's centre sits at frame centre, clamped so no image edge
   pulls inside the frame. Verify the source has at least frame_width * scale
   pixels of width; if not, get a bigger asset - do not upscale into softness.

3. TREAT THE SURROUND. Apply BOTH:
     - a black overlay at alpha 0.45 outside FOCAL, feathered 12% of frame
       width;
     - a 12px (at 1080p) blur outside FOCAL.
   If the design doc assigns a valence, also rotate hue: +14 deg toward red for
   negative, -16 deg toward yellow/green for positive, with +8% saturation.

4. POINT AT IT. At {{IN}} + 0.30s, animate in exactly ONE mark: an animated
   underline, a drawn circle, an arrow, or the highlighted line of text
   itself. Duration 0.35s, ease power3.out, drawn strokes 0.40s. One mark
   only - two marks means two focal points, which means none.

5. GIVE IT MOTION. Ramp scale by 2% per second of hold (ease sine.inOut, or
   none for a mechanical read) for the whole {{IN}}..{{OUT}} window. If the
   narration emphasises a detail inside FOCAL, add one punch to 1.18x over
   0.45s, power3.out, landing within 6 frames of the spoken word.

6. Keep every mark and label inside 90% title safe.

ACCEPTANCE TEST: show a single frame from the middle of the hold to someone
who has not heard the narration and ask "what am I looking at?" - they must
name the focal point in under two seconds. Then check: (a) the mark's arrival
is 6-15 frames after the image lands, not simultaneous; (b) surround luma is
35-60% below focal luma; (c) nothing animates in the last 2 frames of the
clip's window, because the half-open visibility window means the final frame
is never rendered.
```

## Execution spec

**Focal-point detection (offline, before authoring).** OpenCV's static saliency is the fallback when there is no text and no face:

```python
import cv2
img = cv2.imread("shot.png")
sal = cv2.saliency.StaticSaliencyFineGrained_create()      # or StaticSaliencySpectralResidual_create()
ok, m = sal.computeSaliency(img)
m = (m * 255).astype("uint8")
th = cv2.threshold(m, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
cnts, _ = cv2.findContours(th, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
x, y, w, h = cv2.boundingRect(max(cnts, key=cv2.contourArea))   # -> FOCAL
```

Prefer OCR when the narration is reading the image (text-region box is exact, saliency is a guess), and a face box when the subject is a person. **Note the contract: there is no automatic face tracking or content-aware reframe in this stack** — detection is an authoring-time step whose output is baked into the composition as constants, and the result must be recorded in the design document.

**HyperFrames — the whole treatment is one clip plus CSS plus GSAP.** Layer order inside a single timed wrapper, bottom to top: the image, the darkened+blurred duplicate masked to the *inverse* of the focal box, then the mark.

```html
<div id="img-retention" class="clip" data-start="42.0" data-duration="4.2" data-track-index="1">
  <!-- base image, statically reframed to FOCAL -->
  <img id="img-retention-base" src="assets/img/dashboard.png"
       style="position:absolute; inset:0; width:100%; height:100%; object-fit:cover;
              transform: scale(1.42) translate(-8.4%, 3.1%); transform-origin: 61% 38%;">
  <!-- surround: same image, blurred + darkened, punched through at the focal box -->
  <div id="img-retention-surround"
       style="position:absolute; inset:0; background:#000; opacity:.45;
              -webkit-mask-image: radial-gradient(ellipse 26% 18% at 50% 50%,
                    transparent 60%, #000 100%);
                      mask-image: radial-gradient(ellipse 26% 18% at 50% 50%,
                    transparent 60%, #000 100%);"></div>
  <div id="img-retention-underline"
       style="position:absolute; left:34%; top:56%; width:32%; height:6px;
              background:#ffd24a; transform-origin: left center;"></div>
</div>
```

```js
const T = 42.0;                                  // clip data-start, in composition seconds
// context first, mark second: 0.30s = 9 frames @30fps
tl.fromTo("#img-retention-underline", { scaleX: 0 },
          { scaleX: 1, duration: 0.40, ease: "power3.out" }, T + 0.30);
// movement on the still: 2%/s over a 4.2s hold, landing BEFORE data-duration
tl.to("#img-retention-base", { scale: 1.42 * 1.084, duration: 4.0, ease: "sine.inOut" }, T);
```

Contract points that bind this:
- **`gsap_css_transform_conflict` is an error.** The base image carries a CSS `transform` *and* a GSAP `scale` tween above — that is the forbidden pattern. Pick one: either move the static reframe into a zero-duration `tl.set("#img-retention-base", { scale: 1.42, x: "-8.4%", y: "3.1%", transformOrigin: "61% 38%" }, T)` and keep the tween, or keep the CSS and animate a **wrapper** instead. The example above is written to be split this way; do not ship it as-is.
- Use **`x`/`y`/`scale`**, never `width`/`height`/`top`/`left` — those tweens are forbidden.
- `data-duration` is **required** on an `<img>` clip; without a resolvable duration the element has no end and stays visible for the rest of the composition.
- Land the drift's end state **before** `data-duration` — the visibility window is `[start, start+duration)` and the final frame is never rendered.
- `filter: blur()` is lint-clean on the master timeline. If you animate the blur, do it on a non-clip inner element.
- A full-screen background fill on the composition **root** is dropped on the layered-composite path — put fills on a full-bleed child (`position:absolute; inset:0`).
- Never tween `display` or raw `visibility` on the clip element; `autoAlpha` on an inner wrapper only.
- Marks must sit inside 90% title safe or the layout audit's caption-zone / overflow checks will fire; the narrow opt-out is `data-layout-allow-caption-zone`, and `data-layout-allow-overflow` has a wide blast radius across the whole subtree — prefer fixing the geometry.
- Related named motion rules exist in the animation library and may be cited but not quoted: `coordinate-target-zoom`, `depth-of-field-blur`, `ai-tracking-box`, `svg-path-draw`, `ambient-glow-bloom`.

**ffmpeg — only when the treated image must become a file** (e.g. it leaves the pipeline). Crop, blur-and-composite, and hue-shift in one pass:

```bash
# crop to FOCAL with 1.4x headroom, then blurred/darkened surround behind a sharp inset
ffmpeg -i dashboard.png -filter_complex "\
 [0:v]scale=3072:-1,split=2[base][sur];\
 [sur]boxblur=12:1,eq=brightness=-0.18[surb];\
 [base]crop=1120:640:980:410[foc];\
 [surb][foc]overlay=(W-w)/2:(H-h)/2,scale=1920:1080" treated.png
# negative valence hue push
ffmpeg -i treated.png -vf "hue=h=14:s=1.08" treated.neg.png
```

**Epidemic Sound:** the highlight's arrival wants a small motion sound, not a hit — the brain expects a sound when something moves. `SearchSoundEffects { query: { term: "subtle ui tick soft pop" }, filter: { duration: { max: 700 } } }`, placed at the mark's arrival frame, −12 to −15 dB. See [[sfx-whoosh-transition-movement-reveal]].

**Remotion:** an `<Img>` inside a `<Sequence>` with an interpolated scale and a masked overlay div; concept only — Remotion is not a runtime here.

## Pairs with
[[cut-punch-in-emphasis]] · [[pace-overlay-instead-of-cut]] · [[motion-list-item-marker-card]] · [[sfx-whoosh-transition-movement-reveal]] · [[struct-name-define-demonstrate]] · [[pace-cut-density-from-viewer-intent]] · [[cut-graphic-match]]

## Failure modes
- **Two highlights on one image.** Two focal points is zero focal points; the viewer's eye ping-pongs. Correction: one mark per image; if the image genuinely has two subjects, make it two inserts.
- **Highlight arrives with the image.** The viewer never sees context, so the highlight has nothing to be a highlight *of*. Correction: 9–15 frames of delay.
- **Surround treatment too strong.** At alpha >0.65 or blur >30 px the surround is gone, and with it the reason to show an image rather than a text card. Correction: 0.45 and 12 px, then adjust once against the render.
- **Upscaling into mush.** Reframing at 1.6× on a 1280-wide screenshot produces a soft frame that reads as low production value regardless of the treatment. Correction: check `source_res_floor` first; re-capture the asset at 2–3× frame width.
- **Colour push mistaken for a grade error.** A 40° hue rotation looks like a broken LUT, not a connotation. Correction: stay in 8–25°.
- **Static still held long.** Any still over ~1.5 s without movement reads as a stalled video. Correction: 2%/s drift minimum.
- **Mark outside title safe.** Correction: 90% box, and check a snapshot — the browser-dependent layout audit may not be runnable on the authoring machine.
- **Known gap:** the darken/blur/hue numbers here are house values calibrated from practice and from the transition-catalog blur bands in the execution contract; no published standard specifies them. The saliency route is a *fallback* — it is measurably worse than an OCR or face box, and any note-driven pipeline should record which route produced the focal box so a human can override it.
