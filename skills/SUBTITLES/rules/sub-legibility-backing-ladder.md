---
id: sub-legibility-backing-ladder
title: Pick one backing — stroke, shadow, plate or blur — and know the contrast floor each actually guarantees
skill: subtitles
type: caption-style
family: caption-contrast
tags: [skill/subtitles, type/caption-style, family/caption-contrast, engine/hyperframes, source/hyperframes, source/research, difficulty/high]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: ".caption-box — background-color: #7a6248; padding: 12px 32px; border-radius: 24px; box-shadow: 0 4px 15px rgba(0,0,0,.2). .caption-text — color: #f5f0e0."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "check — the composite gate: lint + runtime + layout + motion + contrast. Target is \"0 findings\"."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://developer.mozilla.org/en-US/docs/Web/CSS/text-shadow
  - https://developer.mozilla.org/en-US/docs/Web/CSS/backdrop-filter
difficulty: high
detectable_from: video
---

# Pick one backing — stroke, shadow, plate or blur — and know the contrast floor each actually guarantees

## What it is

A caption sits over content the designer does not control and cannot predict. Somewhere in every video there is a frame where the background is exactly the colour of the caption. The **backing** is whatever mechanism guarantees a contrast floor at that frame.

There are four, and they are not interchangeable. The critical difference is **whether the floor is guaranteed or merely likely**:

| Backing | Mechanism | Contrast floor over worst-case video | Guaranteed? |
|---|---|---|---|
| **Opaque plate** | A filled box behind the text | Exactly the text-to-plate ratio, e.g. `#f5f0e0` on `#7a6248` = **6.4:1** | **Yes.** The video is never visible behind the text. |
| **Blur-behind + tint** | `backdrop-filter: blur()` on a translucent box | Depends on tint alpha. At 0.6 alpha over worst case, roughly **2.5–4:1** | **No.** Blur removes detail, not luminance. A blurred white sky is still white. |
| **Stroke** | `-webkit-text-stroke` or layered `text-shadow` at 0 offset | The **stroke-to-text** ratio at the letter edge, ~13:1 for black-on-white text; but the *counters* fall back to text-vs-video | Partly. Edges yes, counters no. |
| **Drop shadow** | Offset, blurred `text-shadow` | 1:1 in the worst case — a shadow offset down-right does nothing when the background matches the text on the up-left side | **No.** |

The consequence: **only an opaque plate guarantees a contrast ratio over arbitrary video.** Everything else is a probabilistic improvement. That does not make the others wrong — it makes them choices you make knowing the floor, with a fallback for the frames where they fail.

The second rule is **exactly one**. Stroke plus shadow plus plate is the signature of a caption designed by adding fixes until it looked okay on one frame. It thickens the letterforms, fills the counters, and costs contrast rather than buying it: a black stroke on a plate reduces the effective ratio, because the stroke sits between the text and the plate.

## When to use it

Choose the backing once, per the identity ([[sub-caption-identity-token-set]]), driven by the footage:

- **Opaque plate** — when the footage is unpredictable, when there is an accessibility obligation, when the caption is a full track rather than a mark, or when the video will be watched muted in a feed. It is the default and it is the boring correct answer.
- **Stroke** — when the caption must not occlude the picture, and the footage is mostly mid-tone. Standard for karaoke-style word-level captions ([[sub-karaoke-active-word-highlight]]) where a plate would flicker in size on every word swap.
- **Blur-behind** — when the design wants to feel embedded in the image rather than stamped on it, and the footage is known. Expensive and fragile in this stack; see the execution spec.
- **Drop shadow** — as a *secondary* separator on top of a plate, at very low opacity, to lift the plate off the picture. The reference file does exactly this: `box-shadow: 0 4px 15px rgba(0,0,0,.2)` on the **box**, not on the text. That is legal because it is not the contrast mechanism.

Reopen the choice when the footage changes character — a section that cuts to white screen recordings will break a stroke design that worked over interviews.

## How to recognise it in a reference video

Backings are identifiable from single frames, but the *worst-case* frame is what matters, so sample deliberately rather than evenly.

**The worst-case-frame method.** Do not sample uniformly. Find the frames most likely to break the caption:

```bash
# 1. crop the caption band only, for the whole video
ffmpeg -i in.mp4 -vf "crop=iw:ih*0.18:0:ih*0.79" -an band.mp4
# 2. per-frame luminance stats on that band
ffmpeg -i band.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG" -f null - 2> yavg.txt
# 3. pull the brightest and darkest frames and look at them
```

The frames with the highest and lowest band luminance are the two that decide whether the backing works. A caption that survives both survives the video.

| Signal | Measure | Reading |
|---|---|---|
| Plate present | Sample 5 points inside the box on a busy frame | Identical RGB = opaque plate. Varying = translucent or blur. |
| Plate alpha | Compare plate RGB over a bright cue and a dark cue | Same = opaque. Different = translucent; compute alpha from the delta. |
| Blur-behind | Look at the box edge on a high-detail frame | Detail smeared inside the box but luminance preserved = `backdrop-filter`. |
| Stroke width | Measure the dark rim on a stem, in px, divide by cap height | 0.04–0.09 of cap height is designed. Above 0.12 the counters are filling. |
| Stroke or shadow | Is the dark rim symmetric around the glyph? | Symmetric = stroke. Offset to one side = drop shadow. |
| Stacking | Count distinct dark treatments on one glyph | More than one = stacked backing; a defect. |
| Counter integrity | Look inside `e`, `a`, `o` at 200 % | Filled counters = stroke too heavy for the size. |

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `backing` | plate | plate / stroke / blur / none | Exactly one. `none` only when the caption sits on a graphic you control. |
| `backings_stacked` | 1 | 1 | Hard rule. A box-shadow on the *box* is not a second backing. |
| `plate_colour` | `#7a6248` | — | The reference value. Any colour; the ratio is what matters. |
| `plate_alpha` | 1.0 | 0.85–1.0 | Below 0.85 the floor is no longer guaranteed. Below 0.7 it is decorative. |
| `text_on_plate_ratio` | 6.4:1 | ≥4.5:1 | `#f5f0e0` on `#7a6248` computes to about 6.4:1. 4.5:1 is the WCAG 1.4.3 normal-text threshold; 3:1 is the large-text threshold and most captions qualify as large text. Design to 4.5:1 anyway — the large-text allowance assumes a static page, not motion. |
| `plate_vs_video_ratio` | ≥3:1 | ≥3:1 | The plate is a graphical object under WCAG 1.4.11 and wants 3:1 against what is behind it, or its edge disappears. |
| `stroke_width` | 0.06 em | 0.04–0.09 em | ~3 px at 48 px. Above 0.12 em counters fill. |
| `stroke_colour` | `#000` at 0.85 alpha | — | Pure black at full alpha reads as a sticker. |
| `stroke_edge_ratio` | ~13:1 | ≥7:1 | Text-to-stroke at the edge. High is easy; the counters are the problem. |
| `stroke_counter_floor` | 1:1 | — | Be honest: inside a counter there is no stroke, so the floor is text-vs-video. This is why stroke is not a guarantee. |
| `shadow_offset` | 0 | 0 to 0.04 em | At offset 0 with blur, a `text-shadow` behaves as a soft stroke and is far better than an offset shadow. |
| `shadow_blur` | 0.25 em | 0.15–0.5 em | 12 px at 48 px. |
| `shadow_layers` | 3 | 1–4 | `text-shadow` accepts a comma list, stacked front-to-back. Three low-alpha layers at offset 0 make a soft halo worth ~2 stops. |
| `blur_radius` | 12 px | 8–24 px | `backdrop-filter: blur()`. Blur removes detail, not luminance. |
| `blur_tint_alpha` | 0.55 | 0.4–0.7 | The tint is doing the contrast work; the blur is doing the aesthetics. |
| `blur_worst_case_ratio` | 2.5–4:1 | — | Measure it. Do not assume blur bought you a floor. |
| `box_shadow_on_box` | `0 4px 15px rgba(0,0,0,.2)` | — | Separation from the picture, not contrast. The reference value. |

## Reproduction prompt

```
Choose and specify the caption legibility backing for {{PROJECT}}, over footage
that is {{unpredictable|mostly mid-tone|controlled graphics}}, delivered
{{muted-first|sound-on}}, with {{no|WCAG-A}} accessibility obligation.

Choose exactly ONE of: opaque plate, stroke, blur-behind, or none. Do not stack
them. A box-shadow on the box for separation from the picture is not a second
backing and is permitted.

State the contrast floor your choice guarantees over WORST-CASE video, not over a
representative frame, and say honestly whether it is a guarantee or a
probability. Only an opaque plate guarantees a ratio, because it is the only
option where video is never visible behind the glyph. A stroke guarantees the
letter edge and nothing inside the counters. Blur removes detail but not
luminance — a blurred white sky is still white. An offset drop shadow guarantees
nothing.

Find the worst case empirically: crop the caption band for the whole video, dump
per-frame luminance with ffmpeg signalstats YAVG, pull the brightest and darkest
frames in that band, and compute the actual ratio at both.

If the choice is not an opaque plate, specify the fallback for frames where the
floor is not met — a conditional plate on named cues, a reposition, or a scrim.
"It'll probably be fine" is not a fallback.

Acceptance test: both extreme frames must clear 4.5:1. Inspect the counters of e,
a and o at 200% on the darkest frame — they must be open. Then confirm `check`
reports a non-zero text-check count; 0/0 means a lint error disabled the audit.
```

## Execution spec

All four are plain CSS in the scoped caption style block. What differs is how badly each interacts with this stack.

```css
/* PLATE — the guaranteed option. The reference implementation. */
[data-composition-id="captions"] .caption-box {
  background-color: var(--cap-plate);          /* #7a6248, alpha 1 */
  box-shadow: 0 4px 15px rgba(0,0,0,.2);       /* separation, NOT contrast */
}

/* STROKE — soft halo via layered text-shadow at zero offset.
   Preferred over -webkit-text-stroke: the stroke property is non-standard,
   centres on the outline (eating half the stem), and has no paint-order
   control, so a heavy stroke thins the glyph. */
[data-composition-id="captions"] .caption-text {
  text-shadow:
    0 0 0.12em rgba(0,0,0,.9),
    0 0 0.25em rgba(0,0,0,.75),
    0 2px 0.10em rgba(0,0,0,.6);
}

/* BLUR-BEHIND — read the caveat below before using this. */
[data-composition-id="captions"] .caption-box {
  background-color: rgba(20,18,16,.55);
  backdrop-filter: blur(12px) saturate(120%);
}
```

**The blur-behind caveat is disqualifying in the reference implementation as written.** `backdrop-filter` only filters content between the element and its nearest **backdrop root**, and an element with `opacity < 1` *is* a backdrop root. The staged caption timeline animates the box's opacity from 0 to 1 on every cue:

```js
tl.to(box, { opacity: 1, duration: 0.1, ease: "power2.out", ... }, line.start);
```

So during every fade the box is its own backdrop root and the blur has nothing to blur; it pops in only once opacity reaches exactly 1. To use blur-behind you must **split the elements**: animate opacity on an outer wrapper and put `backdrop-filter` on an inner box that never leaves opacity 1 — or animate `autoAlpha` on the wrapper and leave the blurring box untouched. `backdrop-filter` is also GPU-expensive per frame in a headless render, and rendering happens off the authoring VM anyway (linux ARM64, no sudo, no Chrome).

Two further stack notes:

- **The contrast audit inside `check` is browser-backed**, so it does not run on the device VM. And a lint **error** switches the layout and contrast audits off entirely — `check` then reports `0 sample(s)` and `0/0 text checks`, which reads clean and means nothing ran. Always read the sample count, not just the finding count.
- **The audit checks text against its declared background**, per WCAG's own guidance to use the colours from the markup rather than what is on screen. It therefore *passes* a stroke-backed caption over a white sky, because the declared background is transparent. The audit cannot see the video. The worst-case-frame method above is not optional; it is the only thing that measures the real case.

## Pairs with

- [[sub-caption-plate-geometry]] — once you have chosen a plate, its shape
- [[sub-caption-contrast-accessibility]] — the WCAG thresholds and what they do and do not cover
- [[sub-caption-colour-token-system]] — the plate and text colours the ratio is computed from
- [[sub-caption-identity-token-set]] — where `--cap-backing` is recorded
- [[sub-karaoke-active-word-highlight]] — why word-level captions usually take a stroke, not a plate
- [[sub-typeface-selection-for-captions]] — counter size determines how much stroke the face survives
- [[motion-subject-glow-separation]] — the same separation problem solved for a subject rather than text
- [[motion-spotlight-mask-reveal]] — a scrim as an alternative to a plate

## Failure modes

- **Stacking all three.** Stroke plus shadow plus plate. Letterforms thicken, counters fill, and the black stroke between the text and the plate actively lowers the measured ratio.
- **Treating stroke as a guarantee.** The edge is fine; the counters are text-vs-video. On a busy frame the inside of every `e` becomes noise.
- **Treating blur as contrast.** Blur removes spatial detail. Luminance is untouched. White text on a blurred white sky is white on white.
- **`backdrop-filter` on the element whose opacity is animated.** Opacity < 1 makes the element a backdrop root; the blur silently does nothing until the fade completes, so it pops.
- **Designing on a representative frame.** Every video has a worst frame and it is never the one you looked at.
- **Reading `0/0 text checks` as a pass.** It means a lint error disabled the audit.
- **Trusting the contrast audit over video.** It compares text to its declared CSS background, not to the picture. Over a transparent background it has nothing meaningful to compare.
- **An offset drop shadow as the sole backing.** It defends one side of each glyph. Backgrounds do not agree to only appear on that side.
- **`-webkit-text-stroke` at a heavy width.** It centres on the outline, so half the stroke eats into the stem: the glyph gets thinner as the stroke gets heavier. Layered `text-shadow` at zero offset does not have this problem.
