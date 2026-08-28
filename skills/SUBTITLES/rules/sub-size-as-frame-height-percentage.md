---
id: sub-size-as-frame-height-percentage
title: Size captions as a percentage of frame height — point sizes do not survive an aspect change
skill: subtitles
type: caption-style
family: caption-type
tags: [skill/subtitles, type/caption-style, family/caption-type, engine/hyperframes, source/hyperframes, source/research, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Video type sizes, not web sizes. Full-screen viewing: body ≥20px, headlines 60px+, data labels 16px. In-feed viewing (X / LinkedIn / Instagram): body ≥32px, headlines ≥90px, data labels ≥24px. 48px caption text sits comfortably in the full-screen band."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "--resolution ... supersample via Chrome deviceScaleFactor; aspect must match composition; scale must be integer."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://www.w3.org/TR/ttml-imsc1.1/
  - https://en.wikipedia.org/wiki/X-height
difficulty: medium
detectable_from: video
---

# Size captions as a percentage of frame height — point sizes do not survive an aspect change

## What it is

A caption's size is only meaningful relative to the frame it sits in, because the frame is what the viewer's screen is filled with. Two consequences follow, and they are the whole note.

**Points are meaningless.** A point is 1/72 inch, and there is no inch anywhere in this pipeline. A rendered video has no physical size; it is scaled to whatever container plays it. "24 pt" has no referent. The nearest useful thing is pixels, and pixels are only meaningful once you also say the frame height — which is the same as expressing it as a percentage of frame height and saving a step. The broadcast standards already concluded this: Netflix's timed-text spec requires TTML files to use **percentage values exclusively, no pixel measurements**, with `tts:fontSize` defined as `100%`, and specifies font size as *"relative to video resolution and ability to fit 42 characters across screen"*. IMSC maps every region to the root container region, so position and extent are proportions of the frame by construction.

**Height, not width, and not diagonal.** This is the part that gets got wrong. A caption sized as a percentage of frame *width* is correct at 16:9 and 78 % too large at 9:16. A caption sized against the diagonal is wrong at both. Height is the right denominator because reading distance is governed by how much of the viewer's visual field the frame occupies, and on a phone in portrait the frame's height is what fills the screen. The reference implementation's `48px` on a 1080-tall composition is **4.44 % of frame height** — and that same 4.44 % at portrait 1920 tall is 85 px, which is the correct in-feed size. Express it as the percentage and both cases come out right for free. Express it as `48px` and the portrait version is unreadable.

There is a second denominator worth carrying alongside it: **cap height**, not `font-size`. `font-size` is the em box, which includes space the letters do not occupy; the cap-height ratio varies from about 0.68 to 0.74 across faces. Two captions both set at 4.5 % of frame height in different faces are visibly different sizes. Record both numbers.

## When to use it

Every time. There is no case in this pipeline where a fixed pixel caption size is correct, because:

- `--resolution` supersamples via Chrome's `deviceScaleFactor` — landscape, portrait, `landscape-4k`, `portrait-4k`, `square`. The **aspect must match the composition and the scale must be an integer**, so a 4K render of a 1080p composition scales everything by 2 uniformly. A percentage token survives that; so does a px value, in that specific case. But the moment somebody authors a 9:16 variant of the same design, only the percentage survives.
- The same design gets repurposed across formats constantly. A 16:9 YouTube cut and a 9:16 Shorts cut of the same content is the normal case, not the exception.
- Two viewing contexts have different floors — **full-screen** and **in-feed** — and the gap between them is roughly 60 %. A percentage lets you state one token and one context; a pixel value hides which context it was designed for.

## How to recognise it in a reference video

This is the measurement that is easiest to get precisely right from a single frame, and the one worth reporting to two decimal places.

1. Extract a mid-cue frame: `ffmpeg -ss <t> -i <video> -frames:v 1 -q:v 2 frame.png`.
2. Read the frame height `H` from `ffprobe`.
3. Measure **cap height** in pixels on a capital letter with a flat top and bottom — `H`, `T`, `E`. Not `O` (overshoot), not `A` (apex), not a lowercase letter.
4. Report `cap_height / H` as a percentage.
5. Separately measure x-height and report `x_height / H`, because that is what actually governs legibility.
6. Derive the `font-size` percentage as `cap_height_pct / cap_ratio_of_the_face` — around 0.72 for most grotesques.

| Reading | Interpretation |
|---|---|
| cap height 2.5–3.5 % of H | Full-screen-viewing caption. 27–38 px at 1080p. |
| cap height 3.5–5 % of H | In-feed vertical caption. 67–96 px at 1920 tall. |
| cap height under 2 % of H | Either a label rather than a caption, or a design that will not read on a phone. |
| cap height over 6 % of H | An emphasis mark or a topic card, not a track. |
| Identical **px** size in a 16:9 cut and a 9:16 cut of the same content | Somebody hard-coded pixels. The vertical cut is 44 % too small. |
| Identical **percentage** across both cuts | A percentage token. |

Cross-check by counting characters: Netflix's 42-characters-across figure is a useful calibration. If the caption's `max-width` band fits about 42 characters at the measured size, the size and the line-length budget agree with each other.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `size_denominator` | frame height | height only | Width is wrong at 9:16; diagonal is wrong everywhere. |
| `font_size_pct` | 4.5 % of frame height | 3.5–6 % | 48.6 px at 1080p — the reference file's `48px` is 4.44 %. 86 px at 1920 tall. |
| `cap_height_pct` | 3.2 % of frame height | 2.5–4.3 % | The number the eye actually reads. Derived: `font_size_pct × cap_ratio`. |
| `cap_ratio` | 0.72 | 0.68–0.74 | Face-dependent. Measure it once per family; do not assume. |
| `x_height_pct` | 2.4 % of frame height | 1.9–3.2 % | The best single legibility predictor. |
| `full_screen_floor_px` | 20 px body / 60 px headline / 16 px label | — | The project's stated full-screen video type floors, at 1080p. |
| `in_feed_floor_px` | 32 px body / 90 px headline / 24 px label | — | In-feed floors, roughly 60 % higher. A caption track is body-register. |
| `in_feed_min_pct` | 3.0 % of frame height | ≥3.0 % | 32 px of 1080, or 58 px of 1920. Below this an in-feed caption is decorative. |
| `emphasis_size_pct` | 5.5–9 % of frame height | 5–12 % | Headline register. In-feed headline floor is ≥90 px. |
| `size_ratio_track_to_emphasis` | 1.6× | 1.4–2.5× | Below 1.4× the emphasis object reads as part of the track. |
| `resolution_scale_integer` | required | — | `--resolution` supersampling requires an integer scale and a matching aspect. A 1080p composition renders to 4K at exactly 2×. |
| `px_values_permitted` | none | — | Outside the token block, zero. Netflix's TTML rule is the same instinct: percentages only. |
| `point_sizes_permitted` | none | — | There is no inch in the pipeline. |
| `characters_across_calibration` | 42 | 32–45 | Netflix's figure. If the max-width band does not fit ~42 characters at the chosen size, size and line budget disagree. |

## Reproduction prompt

```
Specify caption type sizes for {{PROJECT}}, which ships as {{ASPECT RATIOS AND
RESOLUTIONS}}, viewed {{in-feed|full-screen}}.

Express every type size as a percentage of FRAME HEIGHT. Not width, not diagonal,
not points, not pixels. Height, because that is the dimension filling the
viewer's screen in both landscape and portrait, so a height percentage is the
only expression that is correct in both without being re-decided. Width is right
at 16:9 and 78% oversized at 9:16.

For each type object emit four numbers: font-size as a % of frame height; the
face's cap-height ratio; the resulting cap height as a % of frame height; and the
pixel value at each shipping resolution, as a derived check rather than as the
specification.

Respect the floors. Full-screen: body >=20px, headline >=60px, label >=16px at
1080p. In-feed: body >=32px, headline >=90px, label >=24px. A caption track is
body-register, an emphasis mark headline-register. If any derived pixel value at
any shipping resolution falls under its floor, raise the percentage and re-derive.

Calibrate against line length: at the specified size and box max-width, count how
many characters fit on one line. Target about 42. If it is far off, size and line
budget disagree and one is wrong.

Acceptance test: compute the pixel values at every shipping resolution from the
single percentage token and confirm each clears its floor. Then change the
composition's data-height alone and confirm every derived size changes with it,
and that no value in the emitted CSS outside the token block is a bare px or pt.
```

## Execution spec

There is no CSS unit that means "percent of composition height" — `vh` refers to the browser viewport, which during a render is the Chrome window, not necessarily the composition. So the composition height is declared once as a unitless token and everything is `calc()`ed from it:

```css
[data-composition-id="captions"] {
  --cap-h: 1080;                                        /* MUST equal root data-height */
  --unit: calc(var(--cap-h) / 100 * 1px);               /* 1 unit = 1% of frame height */
  --cap-size: calc(4.5 * var(--unit));                  /* 48.6px @1080, 86.4px @1920 */
  --cap-size-emph: calc(7.5 * var(--unit));
  --cap-bottom: calc(11 * var(--unit));
}
```

Constraints:

- **`--cap-h` duplicates the root `data-height`** and nothing enforces the agreement. If they drift, everything scales wrong and `check` reports it as a layout finding rather than as a mismatch. `snapshot --at <midpoint>` and an actual look at the frame is the cheap guard.
- **Do not use `vh`.** During `preview` the viewport happens to match; during `render` under a `--resolution` supersample it does not, and the captions come out the wrong size only in the final MP4.
- **`--resolution` scaling is uniform and integer.** A 1080p composition at `landscape-4k` scales by exactly 2 via `deviceScaleFactor`, so percentages and pixels both survive *that* transform. The percentage is what survives the *aspect* change, which is the case that actually breaks designs.
- **The root `data-duration` is compile-time-locked** and cannot be varied via `--variables`, but `--cap-size` can: declare it in `data-composition-variables` on `<html>` and have the script write it as an inline custom property on the root. That is the sanctioned way to ship one composition at two sizes.
- **A cue's fit depends on this token**, so any size change re-opens line breaking ([[sub-line-length-and-line-count]]) and the `white-space: nowrap` / `overflow: hidden` clipping hazard in the reference implementation.

## Pairs with

- [[sub-caption-identity-token-set]] — where `--cap-size` and `--unit` live
- [[sub-typeface-selection-for-captions]] — the cap-height ratio that converts font-size to what the eye sees
- [[sub-tracking-and-caption-line-height]] — both must be in `em` so they follow this token
- [[sub-line-length-and-line-count]] — the 42-character calibration
- [[sub-safe-area-and-caption-zone]] — position uses the same percentage discipline
- [[sub-platform-ui-overlap-map]] — the bands this size has to fit between
- [[sub-caption-contrast-accessibility]] — WCAG's large-text threshold is a px figure and needs converting
- [[motion-format-promise-motion-budget]] — the same resolution-independence argument for motion

## Failure modes

- **Percent of frame width.** Correct at 16:9, 78 % oversized at 9:16. The most seductive wrong denominator because it is right in the format you designed in.
- **`vh` units.** Right in preview, wrong in a supersampled render, and the failure appears only in the final file.
- **`--cap-h` out of sync with `data-height`.** Everything scales by a constant wrong factor and looks like a design decision.
- **Specifying points.** No inch exists. Anybody who hands you a point size is describing a design tool's UI, not the deliverable.
- **Designing at 1080p and shipping at 4K without re-checking.** The integer-scale supersample is uniform, so this usually works — which trains people to trust pixel values, which then break on the aspect change.
- **Ignoring the cap-height ratio.** Two faces at "4.5 %" differ by up to 9 % in apparent size. If the profile records only `font-size`, a face swap silently resizes the captions.
- **Meeting the full-screen floor for an in-feed deliverable.** 20 px body is fine full-screen and unreadable in a feed. The floors differ by about 60 %; pick the right pair before sizing.
- **Changing size without re-running the fit check.** With `white-space: nowrap` and `overflow: hidden`, a size increase clips cues silently rather than wrapping them.
