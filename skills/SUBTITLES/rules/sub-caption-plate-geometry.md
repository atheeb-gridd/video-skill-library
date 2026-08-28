---
id: sub-caption-plate-geometry
title: Give the plate em-relative padding and radius so it scales with the type, and never let it clip
skill: subtitles
type: caption-style
family: caption-contrast
tags: [skill/subtitles, type/caption-style, family/caption-contrast, engine/hyperframes, source/hyperframes, source/research, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: ".caption-box — background-color: #7a6248; padding: 12px 32px; border-radius: 24px; display:flex; min-width: 100px; max-width: 80%; opacity: 0; box-shadow: 0 4px 15px rgba(0,0,0,.2)."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "white-space: nowrap + overflow: hidden + a 5-word grouping is a text-fit hazard. A long 5-word line silently clips rather than wrapping."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://developer.mozilla.org/en-US/docs/Web/CSS/text-shadow
difficulty: medium
detectable_from: video
---

# Give the plate em-relative padding and radius so it scales with the type, and never let it clip

## What it is

Once a plate is the chosen backing ([[sub-legibility-backing-ladder]]), its geometry is five numbers: horizontal padding, vertical padding, corner radius, minimum width, maximum width. All five must be expressed relative to the type, not in absolute pixels, or the plate stops being part of the design the first time the type size changes.

The reference implementation gives concrete values — `padding: 12px 32px`, `border-radius: 24px`, `min-width: 100px`, `max-width: 80%` — at a `font-size: 48px`. Converted to `em`, those are **0.25 em vertical, 0.67 em horizontal, 0.5 em radius**. Those ratios are good defaults. The pixels are not, because the same composition rendered at portrait 1920 needs 86 px type and would keep a 24 px radius, which at that size reads as a nearly square box.

Three geometry facts about caption plates that are not obvious:

**Horizontal padding must be much larger than vertical.** The reference's 32:12 ratio, about 2.7:1, is not arbitrary. The line box already contains leading — at `line-height: 1.2` there is 0.1 em of space above the cap and below the baseline built in — so the *optical* vertical padding is larger than the declared value, while horizontal padding gets no such bonus. Set them equal and the plate looks vertically fat and horizontally cramped.

**`min-width` exists to stop the plate collapsing on a one-word cue.** Word-level captions swap between "the" and "specification", and a plate that snaps between two very different widths on every swap is a strobe. `min-width: 100px` at 1080p is about 9 % of frame width. The better modern answer for a word-level track is to abandon the per-cue plate entirely.

**`max-width` is a fit constraint, not a wrap instruction.** In the reference implementation the box has `max-width: 80%` and the text inside has `white-space: nowrap` and `overflow: hidden`. Those three together mean a long cue **silently clips** — the box stops at 80 % and the sentence continues past the edge, invisibly. This is the single most dangerous default in the staged caption model.

## When to use it

- Whenever `--cap-backing` is `plate`. The geometry is part of the identity, decided once.
- Recompute the derived pixels — never the ratios — whenever `--cap-size` changes.
- Revisit `min-width` when the cue segmentation changes. A three-word-card design ([[sub-cue-segmentation-three-word]]) has far more width variance than a five-word-line design, so it needs either a larger `min-width` or no per-cue plate at all.
- Revisit `max-width` whenever the safe area changes: the plate's outer edge, not the text, is what must clear the platform UI band.

## How to recognise it in a reference video

| Signal | How | Reading |
|---|---|---|
| Radius / cap height | Measure the corner radius in px, divide by measured cap height | Constant across differently-sized text objects = tokenised in `em`. Constant in *pixels* across different sizes = hard-coded. |
| Horizontal / vertical padding ratio | Measure box edge to glyph edge on both axes | 2–3:1 is designed. 1:1 looks wrong and usually is. |
| Plate width variance | Measure box width on the narrowest and widest cue | Variance under 15 % = a `min-width` is doing work, or the cues are length-normalised. Variance over 60 % on a word-level track = the plate strobes. |
| Clipping | Look for a cue whose last word is cut mid-glyph at the box edge | The `nowrap`/`overflow:hidden` failure. It is subtle because there is no ellipsis. |
| Plate edge vs safe band | Measure the box's bottom edge, not the baseline, as % from frame bottom | The **box** is what has to clear the UI band. |
| Radius style | Fully rounded (radius = half box height) vs soft | Pill = a mark; soft radius = a track. Consistency across cues matters more than which. |
| Plate vs video contrast | Sample plate colour vs adjacent video on a busy frame | Under 3:1 and the plate edge dissolves — WCAG 1.4.11 territory for a graphical object. |

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `pad_x` | 0.67 em | 0.5–1.0 em | 32 px at 48 px type — the reference value converted. |
| `pad_y` | 0.25 em | 0.2–0.4 em | 12 px at 48 px. Looks small because `line-height: 1.2` adds 0.1 em optically at each end. |
| `pad_ratio_x_to_y` | 2.7 : 1 | 2:1–3.5:1 | Equal padding reads as vertically fat. |
| `radius` | 0.5 em | 0–0.75 em | 24 px at 48 px. Set to `999px` for a full pill; anything between 0.75 em and a pill is an awkward middle. |
| `radius_unit` | `em` | `em` only | A px radius is the untokenised-plate smell. |
| `min_width` | 9 % of frame width | 0–14 % | 100 px at 1920 wide. Only needed if cue lengths vary a lot. |
| `max_width` | 80 % of frame width | 70–86 % | The reference value. This is the **box**, and the box is what must clear the safe area. |
| `text_max_width` | 84 % of box | 70–90 % | The reference caps `.caption-text` at 1600 px inside 1920 — a second, tighter constraint. |
| `white_space` | `normal` | `normal` | **Change this from the reference's `nowrap`.** With `nowrap` a long cue clips silently. |
| `overflow` | `visible` | `visible` | **Change this from the reference's `hidden`.** `hidden` hides the symptom, not the cause. |
| `plate_vs_video_contrast` | ≥3:1 | ≥3:1 | The plate is a graphical object; below 3:1 its edge vanishes into the picture. |
| `box_shadow` | `0 4px 15px rgba(0,0,0,.2)` | — | Separation from the picture. Not a contrast mechanism. |
| `height_stability` | fixed `line-height` + `em` padding | — | Keeps the plate the same height whether or not the cue has a descender. |
| `two_line_plate` | one box | one box / per-line | One box behind both lines is calmer. Per-line ragged plates are a distinct look and are much harder to keep out of the safe band. |
| `layout_opt_out` | `data-layout-allow-caption-zone` | — | The narrow opt-out for an intentional lower third. Prefer it over `data-layout-allow-overflow`, whose blast radius covers the whole subtree. |

## Reproduction prompt

```
Specify the caption plate geometry for {{PROJECT}}, with type at
{{SIZE_PERCENT}}% of frame height in {{FAMILY}}, cue lengths from {{MIN}} to
{{MAX}} words.

Express padding and border-radius in em so they scale with the type token. Never
px. Set horizontal padding 2-3x vertical, because line-height already contributes
optical vertical space and horizontal padding gets no such bonus. Start from the
reference ratios: 0.67em horizontal, 0.25em vertical, 0.5em radius.

Set max-width on the BOX as a percentage of frame width, and treat the box's
outer edge — not the text baseline — as the thing that must clear the platform
safe band.

Do NOT use white-space: nowrap with overflow: hidden. The staged reference does,
and it truncates a long cue mid-word with no ellipsis and no error. Set
white-space: normal and overflow: visible, and make cue segmentation own the fit.

If cue word-count varies by more than 2x, either set a min-width so the plate
does not strobe between cues, or drop the per-cue plate for a fixed band or a
stroke.

Emit the em values, the derived px at each shipping resolution as a check, and
the plate's contrast ratio against the three busiest frames — it must clear 3:1
or the plate edge dissolves into the picture.

Acceptance test: render the longest and shortest cue. Neither may clip a glyph;
both plates must be the same height even if one has a descender; neither may move
vertically. Then change --cap-size by 25% and confirm padding, radius and
min-width all move with it.
```

## Execution spec

```css
[data-composition-id="captions"] {
  --cap-pad-x: 0.67em;
  --cap-pad-y: 0.25em;
  --cap-radius: 0.5em;
}
[data-composition-id="captions"] .caption-box {
  background-color: var(--cap-plate);
  padding: var(--cap-pad-y) var(--cap-pad-x);
  border-radius: var(--cap-radius);
  min-width: calc(9 * var(--unit-w));
  max-width: 80%;
  box-shadow: 0 4px 15px rgba(0,0,0,.2);
  opacity: 0;
}
[data-composition-id="captions"] .caption-text {
  white-space: normal;        /* NOT nowrap — the reference's nowrap clips silently */
  overflow: visible;          /* NOT hidden */
  text-align: center;
  line-height: var(--cap-leading);
}
```

Notes that only matter in this stack:

- **`em` on the box resolves against the box's own font-size, which is inherited.** `.caption-box` has no `font-size` of its own in the reference, so it inherits from `.captions-container`, which inherits from the root — **not** from `.caption-text` inside it. If the size token is set on `.caption-text` only, the box's `em` padding resolves against the wrong size. Set `font-size: var(--cap-size)` on `.caption-box` and let `.caption-text` inherit it.
- **The layout audit measures `getBoundingClientRect` at sampled timestamps**, and `overflow: hidden` clips the visual **without suppressing the finding**. So switching to `overflow: visible` does not create new findings; it makes existing ones visible instead of silent. If a lower third is genuinely intended to sit in the caption band, the narrow opt-out is `data-layout-allow-caption-zone`, which applies to the element and its descendants via `closest` and does **not** suppress overflow, overlap or occlusion audits. Avoid `data-layout-allow-overflow` — its blast radius also suppresses `text-clipping`, `content-cramped-container` and `foreground-over-panel` for every descendant.
- **The plate's size is animated only by opacity**, per the staged timeline's four-tween cycle. Do not tween `width` or `padding` — the project forbids `width`/`height`/`top`/`left` tweens outright, and a plate that resizes per cue reflows the text inside it on every frame of the tween.
- **`box-shadow` on the box is fine; `filter: drop-shadow()` on the box is not** — `filter` establishes a backdrop root and will break any `backdrop-filter` in the subtree, and it is markedly more expensive per rendered frame.

## Pairs with

- [[sub-legibility-backing-ladder]] — the decision that makes this note apply
- [[sub-size-as-frame-height-percentage]] — the size token everything here is relative to
- [[sub-line-length-and-line-count]] — what actually prevents the clip
- [[sub-safe-area-and-caption-zone]] — the box edge is what must clear the band
- [[sub-caption-colour-token-system]] — the plate colour and its ratio
- [[sub-caption-identity-token-set]] — where the five numbers live
- [[sub-cue-segmentation-three-word]] — cue length variance drives `min-width`
- [[motion-overlay-stack-choreography]] — the plate is one object in a stack

## Failure modes

- **`white-space: nowrap` plus `overflow: hidden`.** The reference default. Long cues lose their last words with no ellipsis, no error and no visual cue that anything is missing. It survives review because reviewers read the script, not the frame.
- **Padding and radius in px.** They stop scaling with type and the plate's proportions change silently on a size or format change.
- **Equal horizontal and vertical padding.** Optically wrong, because leading already pads vertically.
- **`em` resolving against the wrong font-size.** Set `font-size` on the box, not only on the text inside it.
- **A strobing plate on a word-level track.** Width swings by 3× between "the" and "specification". Either `min-width` it or do not plate a word-level track.
- **Measuring the baseline against the safe band instead of the box edge.** The plate extends below the baseline by the descender plus the padding; that is what the platform UI covers.
- **Per-line plates on a two-line cue.** Ragged, and the lower plate's bottom edge is much lower than a single box's would be, so it eats into the UI band.
- **`data-layout-allow-overflow` used to silence a fit finding.** It silences three other checks for every descendant too, and the caption will still be clipped.
