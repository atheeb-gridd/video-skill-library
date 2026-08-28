---
id: motion-key-region-animate-in
title: Animate in the key region — lift the one line or area that matters out of the image
skill: motion
type: graphic
family: image-treatment
tags: [skill/motion, type/graphic, family/image-treatment, engine/hyperframes, engine/ffmpeg, engine/epidemic, engine/remotion, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:49"
    quote: "Animate in the most important line of text or the most important part of the image you're highlighting."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:38"
    quote: "Here are six methods I use for that which go beyond just scaling and repositioning."
research_refs:
  - https://developer.mozilla.org/en-US/docs/Web/CSS/clip-path
  - https://gsap.com/docs/v3/Eases/
  - https://en.wikipedia.org/wiki/Image_scaling
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
difficulty: medium
detectable_from: transcript+video
---

# Animate in the key region — lift the one line or area that matters out of the image

## What it is
Method 1 of the six focal-point treatments ([[motion-image-focal-point-direction]] is the umbrella rule): rather than presenting a screenshot, tweet, chart or photo whole and hoping the viewer finds the payload, you **duplicate the payload region as its own layer** and bring it in on its own animation, timed to the narration word that names it. The base image is present the whole time; the region arrives. The eye is delivered to the answer instead of searching for it.

Two builds, and they read differently:
- **Reveal in place** — the region is masked out of the base image (or the base is dimmed) and the copy fades/rises into exact register. The image looks continuous; the region just *arrives*. This is the default.
- **Lift out** — the region copy scales up 4–10% and gains a shadow, so it sits visibly above the plane of the image. More emphatic, more artificial; use for a single number or headline, not for body text.

Critically, this is a **registration** problem before it is an animation problem. The copy must sit at exactly the coordinates it occupies in the base image, or the frame reads as a mistake for the whole settle.

## When to use it
- **Any inserted image whose meaning lives in one region**: a headline in a screenshot, a single row in a table, one metric in a dashboard, one reply in a thread, a face in a group photo, a clause in a contract.
- **When the narration names the region.** The trigger is a spoken phrase you can point at in the transcript — "look at the third line", "this number here", "and then he says". If nothing in the narration names it, the reveal has nothing to sync to and you probably want a static highlight instead.
- **When the image is dense.** The denser the source, the higher the payoff; a screenshot with forty words of chrome around six words of substance is the ideal case.
- **Stacked with a surround treatment.** A dim or blur on the surround plus the region animating in is the standard pair, not a redundancy: the dim says *not there*, the animation says *here*.
- **Not** on an image whose whole frame is the point (a landscape, a portrait, a single-object product shot). There is no region to lift.
- **Not** more than **two** regions per image. Three sequential reveals on one still turns an insert into a slideshow and blows the shot's time budget.
- **Not** at the same time as a drift ([[motion-still-image-drift]]) — one designed motion per still.

## How to recognise it in a reference video
- **The frame is static except for one rectangle.** Difference consecutive frames across the insert: a region reveal produces residual confined to a bounded box while the rest of the frame is numerically identical. That box is your region.
- **The region is pixel-identical to the base beneath it once settled.** Extract the settled frame and the pre-reveal frame; inside the box, after the dim is accounted for, the content must match the underlying image exactly. If it does not, the "region" is a rebuilt graphic, which is a different (and more expensive) technique.
- **Word sync is the diagnostic signal.** Pull word-level timestamps and find the word that names the region. In competent work the reveal **starts 2–5 frames before that word's onset** and is settled within 8–12 frames after it. A reveal that starts *after* the word has finished is the amateur pattern and reads as the edit lagging the script.
- **Duration 9–15 frames** (0.3–0.5s at 30fps) from first appearance to settled. Longer than ~18 frames and the reveal competes with the sentence.
- **Front-loaded deltas.** Measure per-frame opacity or position change: an out-ease (big first frame, decaying) is the norm. Symmetric or back-loaded deltas mean a different ease was used and should be logged as such.
- **Travel is small.** 8–20 px of `y`, or 4–8% of scale. Large travel breaks registration and is a tell that the region was rebuilt rather than lifted.
- **Look for the surround pair.** Is the rest of the image dimmed to roughly 55–70% luminance, or blurred 4–10 px, while the region stays at 100%? Log the treatment and its value.
- **Audio:** a soft, short transient (60–200 ms) at the settle, −14 to −18 dB. Many creators leave this silent; log which.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `duration` | 0.4 s (12 f) | 0.3–0.5 s (9–15 f) | The "professional, most content" speed band. |
| `ease` | `power3.out` | `power3.out` \| `power2.out` \| `power4.out` | House entrance ease. Never `back`/`elastic` — a bouncing region breaks registration with the base image visibly. |
| `lead_time` | −0.08 s | −0.15 … 0.0 s | Reveal start relative to the naming word's onset. At 0.08 s into a 0.4 s `power3.out` the element is already ~54% arrived, so it reads as present *on* the word. Never positive. |
| `entry_property` | `y` + `autoAlpha` | `y` \| `scale` \| `clip-path inset` | `y` for a line of text, `scale` for a number or badge, an animated `inset()` wipe for a row or a bar. |
| `y_travel` | 14 px @1080p | 8–20 px | Scale with frame height (≈1.3% of height). |
| `scale_from` | 0.96 | 0.92–1.00 | For the scale variant. Below 0.92 the copy is visibly a different size from the base beneath it during the settle. |
| `lift_scale` | 1.06 | 1.03–1.10 | **Lift-out variant only.** With a drop shadow `0 8px 24px rgba(0,0,0,.35)`. |
| `opacity_ease` | `power2.out` | — | Split opacity onto its own gentler tween at the same position; keep overshooting curves off opacity entirely. |
| `surround_dim` | 0.62 | 0.50–0.75 | Base image brightness while the region is at 1.0. |
| `surround_blur` | 0 px | 0–10 px | Alternative to dim. Both together is usually too much. |
| `dim_duration` | 0.3 s | 0.25–0.5 s | Starts `lead_time` before the region, so the darkening is already underway when the region arrives. |
| `stagger` | 0.10 s | 0.06–0.14 s | For 2–4 sibling lines. Hard cap: `items × stagger ≤ 0.5 s` so the arrival reads as one beat. |
| `max_regions` | 2 | 1–2 | Per image. |
| `hold_after_settle` | 0.8 s | ≥0.6 s | Minimum time the settled state is on screen before the cut, or the reveal was pointless. |
| `sfx_level` | −16 dB | −14 … −18 dB | Against dialogue at 0 to −3 dB. Optional; see the silent tier. |

## Reproduction prompt

```
On the still {{SRC}} (clip {{IN}} -> {{OUT}}), animate in the key region
{{REGION}} = the rectangle x,y,w,h in source-image pixels, timed to the
narration word {{WORD}} whose onset in the transcript is {{WORD_T}}.

1. REGISTER FIRST. Place a second copy of {{SRC}} directly over the base copy,
   identical size and position, and mask it to {{REGION}} with
   clip-path: inset(top right bottom left) expressed as percentages of the
   image box, so the mask survives any scaling of the layer. Verify at rest
   that the two copies are pixel-identical - freeze the composition, toggle the
   top copy's opacity, and confirm nothing moves. Registration errors are
   invisible in a still and glaring in motion.

2. LAYER ORDER, bottom to top:
     z1 base image
     z2 scrim (full-frame black at the dim amount, or a blur on the base)
     z3 masked region copy
     z4 any annotation (circle, arrow, underline)
   Layering is CSS z-index. data-track-index is display only and constrains
   nothing.

3. TIMING. reveal_start = {{WORD_T}} - 0.08. Never later than {{WORD_T}}.
   dim_start = reveal_start - 0.05.

4. TWEENS at reveal_start:
     region copy: fromTo { y: 14, autoAlpha: 0 } -> { y: 0, autoAlpha: 1 },
       duration 0.4, ease "power3.out". Split opacity to its own power2.out
       tween at the same position if you use any overshooting curve.
     scrim: to { opacity: 0.38 }, duration 0.3, ease "power2.out",
       positioned at dim_start (0.38 scrim = base at ~0.62 brightness).
   For a number or badge, swap y for scale 0.96 -> 1.0.
   For a table row or a bar, animate clip-path inset() from a zero-width right
   edge to the full region - inset() to inset() is animatable; inset() to
   circle() is not.

5. HOLD. The settled state must be on screen at least 0.8s before {{OUT}}.
   If it is not, extend the clip or drop the reveal.

6. SOUND. Optional soft transient at reveal_start + 0.06 (the peak of a
   power3.out sits at ~15% of its duration), 60-200ms, -16dB. If the video's
   sound-pass budget puts image treatments in the silent tier, leave it silent
   and say so.

ACCEPTANCE TEST: step reveal_start-2f .. reveal_start+16f.
(1) At the settled frame, the region must be pixel-identical to the same
rectangle of the untouched source - no offset, no scale mismatch, no seam at
the mask edge.
(2) The word {{WORD}} must be audible while the region is at or past 50%
opacity, and the region must be fully settled no more than 12 frames after the
word ends.
(3) The rest of the frame must be numerically static across the whole reveal.
(4) The mask edge must not be visible as a hard rectangle against the dimmed
surround - if it is, the dim is too strong or the mask needs feathering.
```

## Execution spec

**HyperFrames.** Two `<img>` elements sharing a `src`, a scrim `<div>` between them, all inside one timed wrapper. Timing lives on the wrapper only.

```html
<div id="shot-thread" class="clip" data-start="41.2" data-duration="4.6" data-track-index="1">
  <img id="thread-base" src="assets/img/thread.png"
       style="position:absolute; inset:0; width:100%; height:100%; object-fit:contain;">
  <div id="thread-scrim"
       style="position:absolute; inset:0; background:#000; opacity:0;"></div>
  <img id="thread-region" src="assets/img/thread.png"
       style="position:absolute; inset:0; width:100%; height:100%; object-fit:contain;
              clip-path: inset(38% 12% 46% 14%);"></img>
</div>
```

```js
const WORD_T = 43.10;                 // onset of the naming word, from transcript.json
const REVEAL = WORD_T - 0.08;         // 43.02
tl.to("#thread-scrim", { opacity: 0.38, duration: 0.30, ease: "power2.out" }, REVEAL - 0.05);
tl.fromTo("#thread-region",
  { y: 14, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.40, ease: "power3.out" },
  REVEAL
);
```

Contract points that bind this:
- **`clip-path: inset()` is animatable, but only to the same shape function.** `inset()` → `inset()` and `polygon()` → `polygon()` (matching vertex counts) interpolate; `inset()` → `circle()` does not, and a `url(#svgClip)` reference is not animatable at all. Any non-`none` `clip-path` also creates a stacking context, which is usually what you want here.
- **`autoAlpha`, not `visibility` or `display`** — and only on a non-clip element. `#thread-region` is an inner child, not the clip, so this is legal; applying it to `#shot-thread` would be rejected because the framework owns clip visibility.
- **`fromTo`, never `from`.** `from()` writes its start state at construction, before the clip's `data-start` is active, and the render engine's non-linear seek then flashes or skips the entrance.
- **No CSS `transform` on `#thread-region`** — `clip-path` in CSS is fine, a `transform` is `gsap_css_transform_conflict` (error).
- **`data-track-index` is display only.** Real layering is `z-index` / document order. Two clips on one track may overlap and both render.
- **Word timestamps come from the transcript, and nothing else.** `npx hyperframes transcribe <file>` (Parakeet default, whisper.cpp fallback) emits `{ text, words:[{text,start,end}] }` in seconds. Those `start` values are the only legitimate source for `WORD_T`. Note the Parakeet path is Apple-silicon MLX and unavailable on this linux ARM64 authoring VM — the whisper fallback is what runs here.
- **Sub-comp boundary.** If the still lives in a sub-composition, its timeline is **scene-local**: `REVEAL` inside the sub-comp is `WORD_T − slot data-start − 0.08`. A sub-comp timeline cannot animate host-root elements and a global selector does not cross the boundary.
- **`studio_missing_editable_id`** is a warning on any non-media timed element without an `id` — give the wrapper one.
- **`duplicate_media_discovery_risk`** is benign but will fire on two `<img>` sharing `src` + `data-start`; both copies here are untimed children of one timed wrapper, which avoids it.
- **Layout audit:** the masked copy overflows nothing, but the dim may trip contrast checks on any text drawn over it. `data-layout-allow-caption-zone` is the narrow opt-out for an intentional lower-third; do not reach for `data-layout-allow-overflow` unless you actually have overflow.

**ffmpeg — only if the region must be a separate asset.** Prefer masking in the composition; cut a file only when the crop is leaving the pipeline:

```bash
# crop the region out at native resolution (x,y,w,h in source pixels)
ffmpeg -i thread.png -vf "crop=980:210:120:640" thread-region.png
```

**Epidemic Sound.** A short, soft, non-percussive arrival:
```
SearchSoundEffects { query: { term: "soft ui pop text appear subtle" },
                     filter: { tagSlugs: { matchType: "ANY", values: ["user-interface--click"] },
                               duration: { max: 600 } } }
```
Place with the transient on `REVEAL + 0.06` (the velocity peak of a `power3.out` sits at ~15% of its duration — see [[sfx-envelope-matched-to-easing-curve]]), `data-volume` around 0.18, on its own `sfx` group.

**Remotion.** `spring()`/`interpolate` on `translateY` and `opacity` with a `clipPath` string built from the region rect — concept only.

## Pairs with
[[motion-image-focal-point-direction]] · [[motion-spotlight-mask-reveal]] · [[motion-annotation-draw-on]] · [[motion-subject-glow-separation]] · [[motion-colour-shift-connotation]] · [[motion-still-image-drift]] · [[motion-progressive-information-build]] · [[sfx-envelope-matched-to-easing-curve]] · [[motion-silent-motion-tier]] · [[sub-emphasis-caption-three-words]] · [[cut-screen-recording-proof-insert]]

## Failure modes
- **Misregistration.** The copy sits 3 px off the base and the settled frame shows a doubled edge. This is the failure that makes the whole technique look broken. Correction: build the mask from the *same* element geometry as the base, verify by toggling opacity at rest, and keep travel small.
- **Reveal after the word.** The narration has already moved on when the graphic arrives, so the viewer connects it to the wrong sentence. Correction: `lead_time` of −0.08 s, never positive.
- **Travel too large.** 60 px of rise means the copy spends most of the animation visibly out of register with the image behind it. Correction: 8–20 px.
- **Overshoot ease.** `back.out` on a region lifted from a photograph reads as a rendering error, because the base image does not overshoot with it. Correction: `power3.out`, and keep any overshoot off opacity entirely.
- **Three or more reveals on one image.** The insert becomes its own scene and the video stalls. Correction: cap at two, or split into two separate inserts with a cut between.
- **Hard mask edge against a strong dim.** At `surround_dim` below ~0.5 the rectangle reads as a pasted box. Correction: raise the dim toward 0.62–0.70, or feather the mask, or switch the surround to blur.
- **No hold.** The region settles and the shot cuts 4 frames later; the viewer sees motion but never reads the payload. Correction: ≥0.8 s settled hold.
- **Reveal with nothing to sync to.** If the narration never names the region, the timing is arbitrary and the reveal reads as decoration. Correction: use a static treatment (dim, circle, glow) instead.
- **Known gap:** nothing in this stack finds the region for you. There is no OCR pass, no saliency detection and no content-aware reframe — the region rect and the naming word are both authored inputs, produced by the analysis pass and written into the design document.
