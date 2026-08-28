---
id: motion-colour-shift-connotation
title: Push the image's colour to load it with a verdict — red negative, yellow-green positive
skill: motion
type: graphic
family: image-treatment
tags: [skill/motion, type/graphic, family/image-treatment, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:02"
    quote: "Shift the image's color so it goes red, giving it a negative connotation."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:07"
    quote: "You can also shift it to yellow or green to give it a positive spin."
research_refs:
  - https://journals.sagepub.com/doi/10.1177/0956797620948810
  - https://en.wikipedia.org/wiki/Color_psychology
  - https://en.wikipedia.org/wiki/Blend_modes
  - https://ffmpeg.org/ffmpeg-filters.html#colorbalance
  - https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html
difficulty: medium
detectable_from: video
---

# Push the image's colour to load it with a verdict — red negative, yellow-green positive

## What it is
A **semantic** grade, not an aesthetic one. An inserted image — a screenshot, a competitor's thumbnail, a chart, a headline — is pushed toward red to mark it as the bad example, or toward yellow/green to mark it as the good one. The push is animated in, usually over the same window as the rest of the image's treatment, so the viewer sees the verdict arrive rather than finding the image pre-judged. It lets a graphic carry a judgment the narration never has to state, which is why it works so well in comparison beats: two screenshots side by side, one warm-green, one red, and the argument is made before a word lands.

Two things separate a working push from a broken grade: it changes **hue and saturation while leaving luminance alone**, and it is **redundantly coded** — the colour is never the only carrier of the verdict.

## When to use it
- **Comparison beats**: this-not-that, before/after, our-way vs their-way. The strongest use, and the one where both directions appear in the same shot or in adjacent shots.
- **A named bad example**: the ugly timeline, the failing metric, the mistake. Red push plus one mark.
- **A payoff**: the result, the fixed version, the finished edit. Warm/green push.
- **Never on a face you are not deliberately editorialising about.** A red push on skin reads as sunburn or fury; a green push on skin reads as illness — the valence inverts on people. Push the background, the UI, or the chart, not the person.
- **Never as the video's whole grade.** This device needs a neutral baseline to read against. If the entire piece is teal-and-orange, a warm push carries no information.

## How to recognise it in a reference video
- **Compare the inserted image on screen to the original asset** when you can find it. Failing that, compare the insert's colour statistics to the A-roll around it — the A-roll is your neutral reference inside the same file.
- **Measure mean hue and saturation, and check luminance is unchanged.** A semantic push in competent work shows a **hue rotation of 8–25°** and a **saturation lift of 5–15%**, with mean luma within **±3%** of the untreated image. If luma moved a lot, you are looking at a mood grade or an exposure change, not a verdict.
  ```bash
  ffmpeg -ss <t> -i ref.mp4 -frames:v 1 -update 1 /tmp/a.png
  ffmpeg -i /tmp/a.png -vf "signalstats,metadata=print" -f null - 2>&1 | grep -E "HUEAVG|SATAVG|YAVG"
  ```
- **Check whether the push is animated.** Frame-step the image's first 20 frames: a push that ramps in over **8–20 frames** is deliberate; a push present on frame one may just be the asset.
- **Look for the opposite push nearby.** The tell of the semantic use is *pairing*: a red-pushed image within a few seconds of a green-pushed one. A single warm image is probably just a grade.
- **Look for redundant coding.** A working example also carries an X/tick, a strike, a red mark, a word, or a downward arrow. If colour is the only carrier, log it as a defect, not as the technique.
- **Transcript correlation.** The push should land within **±6 frames** of the evaluative word — "mistake", "wrong", "better", "clean" — not at the image's arrival.
- **Watch for skin.** If people are in frame and pushed, note it: it is either a deliberate editorial choice about that person, or a mistake.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `direction` | — | `negative` · `positive` | Required. Derived from the design document's verdict for this insert, never from taste. |
| `hue_rotate_negative` | +14° toward red | 8–25° | Beyond 25° it reads as a broken LUT rather than a connotation. |
| `hue_rotate_positive` | −16° toward yellow/green | 8–25° | Yellow (warm-positive) and green (approval-positive) are different reads; pick one per project and keep it. |
| `saturation_lift` | 1.10 | 1.05–1.20 | Above 1.2, JPEG/H.264 chroma subsampling shows blocking on flat areas. |
| `tint_alpha` | 0.12 | 0.06–0.22 | If tinting with an overlay instead of a hue rotation. Above 0.22 you are recolouring, not annotating. |
| `blend_mode` | `color` | `color` · `soft-light` · `hue` | `color` **preserves the luma of the layer beneath while adopting the overlay's hue and chroma** — the correct mode for a verdict. `multiply` darkens and is wrong here. |
| `luma_drift_tolerance` | ±3% | ±0–5% | Mean luma before vs after. Exceeding it means you changed exposure, which changes meaning. |
| `push_in_duration` | 0.40 s (12 f) | 0.27–0.67 s (8–20 f) | Ease `power2.out`. Colour is a non-spatial property — no overshoot curves. |
| `push_delay` | 0.30 s (9 f) | 0.20–0.60 s | After the image lands, so the viewer sees the neutral image first and the verdict second. |
| `redundant_mark` | required | — | X, tick, strike, arrow, or the evaluative word. Colour must never be the sole carrier (WCAG 1.4.1). |
| `neutral_baseline` | required | — | At least one untreated insert in the same section, or the push has nothing to be measured against. |
| `skin_exclusion` | on | on/off | Mask faces/hands out of the push unless the verdict is about that person. |

## Reproduction prompt

```
Apply a semantic colour push to the insert {{IMG}} that lands at {{IN}} and
holds to {{OUT}}. The design document states its verdict as {{DIRECTION}}
(negative or positive).

1. Hold the image NEUTRAL for the first 0.30s after {{IN}} so the viewer reads
   the image before the verdict.
2. From {{IN}}+0.30s, ramp the push over 0.40s with ease power2.out:
     negative -> hue-rotate +14deg, saturate 1.10
     positive -> hue-rotate -16deg, saturate 1.10
   Animate the CSS filter on a WRAPPER around the image, not on the clip
   element, and not on the same element that carries any transform tween.
3. Do not change exposure. Mean luminance after the push must stay within 3%
   of before. If you use an overlay instead of a filter, use blend mode
   "color" (which preserves the underlying luma) at alpha 0.12 - never
   multiply.
4. Mask out skin. If a face or hands occupy more than about 10% of the insert
   and the verdict is not about that person, apply the push to a masked copy
   that excludes them, or drop the push and use the mark alone.
5. Add exactly ONE redundant mark carrying the same verdict: a red X or strike
   for negative, a tick or upward arrow for positive, animated in at
   {{IN}}+0.30s over 0.35s, power3.out. Colour alone is never sufficient.
6. Ensure at least one untreated insert exists in the same section as a
   neutral baseline.

ACCEPTANCE TEST: show a mid-hold frame to someone who cannot distinguish red
from green - the verdict must still be readable from the mark. Then check mean
luma drift is under 3%, hue rotation is within 8-25deg, and the push begins
after the image, not with it.
```

## Execution spec

**HyperFrames.** Colour is CSS; the animation is a GSAP tween on `filter`, which the contract confirms is lint-clean on the master timeline.

```html
<div id="insert-bad" class="clip" data-start="34.0" data-duration="3.6" data-track-index="1">
  <!-- the filter wrapper carries colour only; a separate inner element carries any transform -->
  <div id="insert-bad-grade" style="position:absolute; inset:0;">
    <img id="insert-bad-img" src="assets/img/competitor-timeline.png"
         style="position:absolute; inset:0; width:100%; height:100%; object-fit:cover;">
  </div>
  <div id="insert-bad-x" style="position:absolute; left:44%; top:40%; width:12%; height:12%;
       background:#e5484d; clip-path:polygon(20% 0,50% 30%,80% 0,100% 20%,70% 50%,100% 80%,
       80% 100%,50% 70%,20% 100%,0 80%,30% 50%,0 20%);"></div>
</div>
```

```js
const T = 34.0;
// neutral for 9 frames, then the verdict arrives over 12 frames
tl.fromTo("#insert-bad-grade",
  { filter: "hue-rotate(0deg) saturate(1)" },
  { filter: "hue-rotate(14deg) saturate(1.1)", duration: 0.4, ease: "power2.out" },
  T + 0.30);
// redundant mark, same beat
tl.fromTo("#insert-bad-x", { autoAlpha: 0, scale: 0.6 },
  { autoAlpha: 1, scale: 1, duration: 0.35, ease: "power3.out" }, T + 0.30);
```

Contract points that bind this:
- **Split colour and transform onto different elements.** A CSS initial `transform` plus a GSAP tween on the same property is lint error `gsap_css_transform_conflict`; keeping the grade wrapper transform-free and the image transform-only avoids fighting over one element.
- **`fromTo`, never `from`** — `from()` sets `immediateRender: true` and writes its start state at construction, before the clip's `data-start` is active, which makes the entrance flash or skip under the render's non-linear seek.
- **`autoAlpha` on the mark, and only because the mark is not the clip element.** Never tween `display` or raw `visibility` on a clip.
- **`data-duration` is required on this clip** (it contains an `img` and a `div`); without a resolvable duration the element stays visible for the rest of the composition.
- Land the push **before** `data-duration` — the window is half-open and the last frame is never rendered.
- **`mix-blend-mode` caveat.** The `color` blend mode is the theoretically correct tool, but the contract's shader-transition path captures the DOM to WebGL textures through html2canvas with a documented list of CSS restrictions, and blend modes are not on the supported list. In any composition using shader transitions, prefer `filter: hue-rotate() saturate()` or a **pre-graded asset**, and mark decoratives that cannot be captured with `data-no-capture`.
- Named rules that may be cited, not quoted: `theme-crossfade-morph`, `gradient-text-sweep`, `ambient-glow-bloom`.

**ffmpeg — when the push should be baked into the asset.** Three routes, in increasing precision:

```bash
# 1. hue rotation + saturation (fast, global)
ffmpeg -i insert.png -vf "hue=h=14:s=1.10" insert.neg.png       # negative
ffmpeg -i insert.png -vf "hue=h=-16:s=1.10" insert.pos.png      # positive

# 2. tonal-range control: push midtones only, leave shadows/highlights alone
#    colorbalance rs/gs/bs (shadows) rm/gm/bm (mids) rh/gh/bh (highs), each -100..100
ffmpeg -i insert.png -vf "colorbalance=rm=12:gm=-4:bm=-8" insert.neg.png
ffmpeg -i insert.png -vf "colorbalance=rm=-4:gm=10:bm=-6" insert.pos.png

# 3. verify luma did not move
ffmpeg -i insert.png    -vf "signalstats,metadata=print" -f null - 2>&1 | grep YAVG
ffmpeg -i insert.neg.png -vf "signalstats,metadata=print" -f null - 2>&1 | grep YAVG
```
`colortemperature=temperature=<K>:mix=<0..1>` is the cleanest route for a warm-positive push specifically, because it moves along the black-body axis and therefore looks like light rather than like a filter.

**Epidemic Sound.** The push is a motion event and wants a small sound if it is visible enough to notice — a soft riser tail or a low tonal swell for negative, a light UI confirm for positive: `SearchSoundEffects { query: { term: "ui confirm soft" }, filter: { tagSlugs: { matchType: "ANY", values: ["user-interface--click"] }, duration: { max: 800 } } }` (real durations in that tag run 197–663 ms). Keep it under −15 dB; a colour change is a quiet event.

**Remotion:** `interpolate()` driving a `filter` string on a wrapping div — conceptually identical; Remotion is not a runtime here.

## Pairs with
[[motion-image-focal-point-direction]] · [[struct-inverse-pair-teaching]] · [[struct-demo-before-label]] · [[motion-instant-appearance-sfx-justified]] · [[cut-graphic-match]] · [[motion-format-promise-motion-budget]] · [[sfx-record-scratch-punctuation]]

## Failure modes
- **Push too strong.** Beyond 25° of hue rotation or 0.22 overlay alpha it stops reading as a verdict and reads as a broken grade or a wrong LUT. Correction: 8–25°, and check it against an untreated insert in the same section.
- **Exposure changed with the colour.** A red push that also darkens is a mood grade; the viewer reads "night", not "bad". Correction: `color` blend or hue rotation only; verify mean luma within ±3%.
- **Pushed skin.** Red on a face reads as anger or sunburn; green reads as nausea — the positive direction *inverts* on people. Correction: mask people out, or use the mark alone.
- **Colour as the only carrier.** Red/green valence is invisible to a large share of viewers with colour vision deficiency, and to anyone on a monochrome or badly calibrated display; WCAG 1.4.1 is explicit that colour must not be the sole means of conveying information. Correction: always ship a mark, a word, or an arrow with the push.
- **No neutral baseline.** If everything is pushed, nothing is marked. Correction: at least one untreated insert per section.
- **Push present on arrival.** The viewer never sees the unjudged image, so the push carries no event. Correction: 9-frame neutral hold first.
- **Known gap — the cultural mapping is not universal.** The largest cross-national dataset available (4,598 participants, 30 nations, 22 native languages) finds colour–emotion associations that are strongly shared — pattern similarity **r = .88** across nations — *and* finds that nation predicts associations **above and beyond** the universal component, with similarity higher between linguistically or geographically close nations. Red–anger is among the more robust associations across the sampled nations; other pairings are not (purple–anger appeared only for Polish participants, jealousy–yellow only for German ones). Practical consequence: red-negative is defensible for a broad Western-facing audience, green/yellow-positive is weaker and more variable, and neither is safe as the *only* signal for a global audience. Record the target audience in the design document, and always ship the redundant mark.
