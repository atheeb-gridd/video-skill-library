---
id: sub-line-length-and-line-count
title: Two lines maximum, 42 characters each — and validate the rendered box, not the string
skill: subtitles
type: caption-style
family: line-breaking
tags: [skill/subtitles, type/caption-style, family/line-breaking, engine/hyperframes, source/hyperframes, source/research, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "white-space: nowrap + overflow: hidden + a 5-word grouping is a text-fit hazard. A long 5-word line silently clips rather than wrapping. The layout audit measures getBoundingClientRect at sampled timestamps and overflow: hidden clips the visual but does not suppress a layout finding."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Line grouping — a fixed for loop, 5 words per line, text joined with spaces, start = first word's start, end = last word's end."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://www.w3.org/TR/WCAG22/
difficulty: medium
detectable_from: video
---

# Two lines maximum, 42 characters each — and validate the rendered box, not the string

## What it is

Three coupled budgets that decide whether a cue fits: characters per line, lines per cue, and how the fit is actually checked.

**42 characters per line** is the broadcast consensus, and Netflix states it as a hard limit alongside a hard maximum of **two lines**. The number is not arbitrary — it is roughly the width at which a reader can take in a line with a single fixation sweep, and it is also the width Netflix explicitly ties font size to: *"relative to video resolution and ability to fit 42 characters across screen."* Size and line length are one decision.

**Two lines maximum** is the harder rule and the more frequently broken. A third line pushes the top of the block into the picture, costs vertical space that on a 9:16 frame is already constrained by the platform UI band, and — the real reason — a three-line caption exceeds what can be read in the time a cue is on screen at any tolerable reading rate. Netflix caps an event at 7 seconds; three lines at 42 characters is 126 characters, which at 20 CPS needs 6.3 s, leaving no margin.

**Short-form burned-in captions run much shorter than broadcast.** A vertical caption at 4.5–5.5 % of frame height with a box at 80 % of frame width fits roughly **20–28 characters** per line, not 42. That is a consequence of size, not a different rule: the same 42-character sweep applies, but the type is much larger relative to the frame because the frame is much smaller relative to the viewer. Design to the *measured* fit, and use 42 as the calibration check on your size token rather than as the target.

**The fit must be validated on the rendered box, not on the string.** This is where the staged implementation is actively dangerous. `compositions/captions.html` groups words with a fixed loop of five per line, then sets `white-space: nowrap` with `overflow: hidden` on a box capped at 80 % width. A five-word line of long words silently clips — no ellipsis, no wrap, no error. Counting characters in the string does not catch it, because the string is fine; it is the *rendered width in the chosen face at the chosen tracking* that overflows. Two cues with identical character counts can differ by 30 % in rendered width.

## When to use it

- On every cue, as a hard constraint rather than a target. A cue that violates it gets **split, not shipped** — that is the skill's own non-negotiable.
- Re-run the whole check after **any** change to `--cap-size`, `--cap-tracking`, `--cap-max-width` or the typeface. All four change which cues fit, and a face swap can change rendered width by 15 % at identical character counts.
- The character budget is derived once per format; the rendered-width check runs per cue, mechanically.

## How to recognise it in a reference video

| Measurement | Method | Reading |
|---|---|---|
| Characters per line | Count on the widest cue you can find | 20–28 = short-form vertical. 32–42 = broadcast or 16:9. >42 = over budget. |
| Lines per cue | Sample 15 cues | Max 2. A single 3-line cue is a defect, not a variant. |
| Rendered width | Box width as % of frame width on the widest cue | Should approach but not reach `max-width`. Hitting it exactly on several cues means clipping. |
| **Clipping** | Look at the right edge of the widest cues for a glyph cut mid-stroke | The `nowrap`/`overflow:hidden` failure. No ellipsis, so it is easy to miss. |
| Width variance | Widest cue width / narrowest cue width | >2.5× on a plated track means the plate strobes; see [[sub-caption-plate-geometry]]. |
| Line balance on 2-line cues | Longer line / shorter line | 1.0–1.6 is balanced. >2.5 is a width-greedy break; see [[sub-syntactic-line-breaking]]. |
| Which line is longer | Compare | Top line longer, or roughly equal, reads better than a long bottom line. |
| 42-char calibration | At the measured size and box width, how many characters fit? | If far from ~42, size and line budget were decided independently. |

To find the worst cue programmatically, render every cue and measure — do not eyeball. The widest cue is rarely the one with the most characters; it is the one with the most wide glyphs (`m`, `w`, `M`, `W`) and the fewest narrow ones (`i`, `l`, `t`).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `max_lines` | 2 | 1–2 | Netflix's hard limit and a hard limit here. Three lines cannot be read inside a legal cue duration. |
| `chars_per_line_broadcast` | 42 | 32–42 | The broadcast consensus, and the calibration figure for size. |
| `chars_per_line_shortform` | 24 | 20–28 | What a 4.5–5.5 % type size in an 80 %-wide box actually fits at 9:16. |
| `chars_per_line_source` | measured | — | Derive from the rendered box, do not assume. |
| `max_chars_per_cue` | 2 × line budget | — | 84 broadcast, ~48 short-form. |
| `line_balance_ratio` | ≤1.6 | 1.0–2.0 | Longer line over shorter. Above 2.5 the break was width-greedy. |
| `preferred_longer_line` | top | top / equal | A long bottom line drags the eye down and away from the picture. |
| `single_line_preference` | strong | — | If a cue fits on one line, use one. Two lines is a fallback, not a default. |
| `white_space` | `normal` | `normal` | **Change from the reference's `nowrap`.** |
| `overflow` | `visible` | `visible` | **Change from the reference's `hidden`.** Hidden hides the symptom. |
| `fit_validation` | rendered `getBoundingClientRect` | rendered only | A character count is necessary and not sufficient. |
| `fit_margin` | 4 % of frame width | 2–8 % | Headroom between the widest rendered cue and `max_width`, to absorb a face or tracking change. |
| `overflow_action` | split the cue | split | Never shrink the type for one cue, never clip, never scroll. |
| `words_per_group` | derived from fit | — | The staged 5-word fixed loop is a placeholder, not a rule. Group by measured width. |
| `recheck_trigger` | size, tracking, face or max-width change | — | All four change the fit. |

## Reproduction prompt

```
Set the line budget for the caption track in {{PROJECT}} and validate every cue
against it, given type at {{SIZE_PERCENT}}% of frame height in {{FAMILY}} at
{{TRACKING}}em, in a box capped at {{MAX_WIDTH}}% of frame width.

Step 1 — derive the real character budget by MEASURING. Render representative
mixed-width text at the specified size, face and tracking inside the box, and
report how many characters fit. Cross-check against 42: Netflix ties font size to
fitting 42 characters across the screen. If your fit is far from 42, size and
line length were decided independently — reconcile them.

Step 2 — cap every cue at 2 lines, hard. Three lines cannot be read inside a
legal cue duration: 3 x 42 characters at 20 CPS needs 6.3 seconds against a
7-second maximum event, with no margin.

Step 3 — validate EVERY cue on rendered width, not character count. Identical
character counts can differ 30% in width by glyph mix. Report the widest cue and
require >=4% of frame width of headroom.

Step 4 — any cue that does not fit gets SPLIT into two cues. Never shrink the type
for one cue, never clip, never scroll. Re-check timing after every split.

Do not use white-space: nowrap with overflow: hidden — that combination truncates
silently mid-word with no ellipsis.

Acceptance test: zero cues exceed max-width, zero render three lines, the widest
leaves >=4% headroom. Then raise --cap-size 10% and re-run: the number of new
failures tells you how little margin the design had.
```

## Execution spec

The staged grouping loop is the thing to replace:

```js
// STAGED (captions.html) — fixed 5 words per line. A placeholder, not a rule.
for (let i = 0; i < script.length; i += 5) {
  const group = script.slice(i, i + 5);
  lines.push({ text: group.map(w => w.text).join(" "),
               start: group[0].start, end: group.at(-1).end });
}
```

Replace it with a **measured** grouping: build each candidate line, measure it, and close the group when the next word would overflow.

```js
const probe = document.querySelector("#caption-text");
function fits(text) {
  probe.textContent = text;
  return probe.getBoundingClientRect().width <= maxTextWidth;
}
```

Constraints that make this work in this stack:

- **Measure after `document.fonts.ready`.** Measuring against the fallback face gives widths that do not match the render, which is the single most likely way this check passes and the video still clips.
- **`white-space: normal` and `overflow: visible`.** The layout audit measures `getBoundingClientRect` at sampled timestamps, and **`overflow: hidden` clips the visual without suppressing the finding** — so switching to `visible` does not create findings, it stops hiding a real one from your own eyes.
- **Do not reach for `data-layout-allow-overflow` to silence a fit finding.** Its blast radius suppresses `text-clipping`, `content-cramped-container` and `foreground-over-panel` for every descendant. If the object is an intentional lower third, the narrow opt-out is `data-layout-allow-caption-zone`.
- **Splitting a cue changes timing.** The new pair must still satisfy the minimum event duration (Netflix's floor is 5/6 s) and the reading-rate cap. Re-run [[sub-cue-segmentation-three-word]]'s checks after any split.
- **`snapshot --at <cue midpoints>` is the visual confirmation**, and it is required for projects with sub-compositions anyway. Look at the widest cues specifically, not a uniform sample.

## Pairs with

- [[sub-syntactic-line-breaking]] — where the break goes once you know you need one
- [[sub-caption-plate-geometry]] — the box that constrains the fit
- [[sub-size-as-frame-height-percentage]] — the 42-character calibration
- [[sub-tracking-and-caption-line-height]] — tracking changes which cues fit
- [[sub-cue-segmentation-three-word]] — splitting a cue re-opens the timing checks
- [[sub-hinglish-reading-rate]] — romanised Hinglish runs longer per unit meaning
- [[sub-typeface-selection-for-captions]] — a face swap changes rendered width at the same character count
- [[sub-safe-area-and-caption-zone]] — a second line moves the block's top edge

## Failure modes

- **`white-space: nowrap` plus `overflow: hidden`.** Silent truncation, mid-word, with no ellipsis. Reviewers reading the script never see it.
- **Validating character count instead of rendered width.** "MMMMMMMM" and "iiiiiiii" are both eight characters and differ by more than 3× in width.
- **Measuring before fonts load.** The check passes against fallback metrics and the render clips.
- **A fixed words-per-line loop.** Five words is between 15 and 45 characters depending on the words. The staged file's loop is a demo, not a rule.
- **Three lines "just this once".** It does not fit in a legal cue duration and it pushes the block into the picture.
- **Shrinking type for one long cue.** The caption visibly changes size mid-video, which reads as a bug even when it is deliberate.
- **Splitting without re-checking timing.** A split can produce a cue under the minimum event duration, which flashes.
- **Forgetting to re-run the check after a tracking or face change.** Both change the fit and neither changes a single character.
- **Balancing lines by width when syntax says otherwise.** Fit is a constraint; the break position is a separate decision — see [[sub-syntactic-line-breaking]].
