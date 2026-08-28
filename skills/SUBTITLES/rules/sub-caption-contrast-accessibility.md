---
id: sub-caption-contrast-accessibility
title: Hold 4.5:1 against the worst frame — WCAG does not cover burned-in captions, so you are the standard
skill: subtitles
type: caption-style
family: accessibility
tags: [skill/subtitles, type/caption-style, family/accessibility, engine/hyperframes, source/research, source/hyperframes, difficulty/high]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "check — the composite gate: lint + runtime + layout + motion + contrast. Target is \"0 findings\"."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "A lint error also switches off the layout and contrast audits: check then reports 0 sample(s) and 0/0 text checks, which reads like a clean file but means nothing ran."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://www.w3.org/TR/WCAG22/
  - https://en.wikipedia.org/wiki/Color_blindness
difficulty: high
detectable_from: video
---

# Hold 4.5:1 against the worst frame — WCAG does not cover burned-in captions, so you are the standard

## What it is

There is a gap in the accessibility standards exactly where burned-in captions sit, and knowing its shape is what makes this note actionable rather than a checklist.

**What WCAG actually says.** SC 1.4.3 requires a contrast ratio of at least **4.5:1** for text, or **3:1** for large text, where large means at least 18 pt or 14 pt bold — approximately **24 px and 18.5 px**. SC 1.4.11 requires **3:1** for graphical objects and UI components, and is explicit that the computed value must not be rounded: *"2.999:1 would not meet the 3:1 threshold."* SC 1.2.2 requires captions for prerecorded synchronised media at Level A.

**What WCAG does not say.** It has essentially nothing about text over video. The Understanding document for 1.4.3 does not address moving backgrounds; the one exemption it offers — *"text that is part of a picture that contains significant other visual content"* — is about incidental text in a photograph, not about deliberate overlay. And 1.4.11 advises authors to take colours *"from the user agent, or the underlying markup and stylesheets, rather than the non-text elements as presented on screen"*, which is sound advice for a web page and useless for a caption, because a video frame has no stylesheet.

So the practical position is:

- **The thresholds are sound and worth adopting.** 4.5:1 for the text against whatever is actually behind it.
- **The measurement method is not given, so you supply one.** The method is the worst-frame method: measure against the brightest and darkest frames in the caption band, not against a swatch or a representative frame.
- **Do not take the large-text 3:1 allowance.** Almost every caption qualifies as large text on the pixel definition, so the allowance is available — and it should be declined. The allowance assumes static text on a static background that the reader can dwell on. A caption is on screen for a second, over motion, in peripheral vision, often on a phone in daylight. Design to 4.5:1.
- **Contrast is necessary and not sufficient.** About **8 % of males and 0.5 % of females** have a colour deficiency; deuteranomaly alone is roughly **5 % of males**. A pair of colours can pass 4.5:1 and still be indistinguishable to those viewers if the distinction is carried by hue. Every semantic hue needs a redundant non-colour cue ([[sub-semantic-colour-assignment]]).

## When to use it

- On every caption design, as a gate before render rather than as a review comment.
- On **every state**, not just the resting one: resting, accent, active, dim, negated. Designs routinely check the accent and forget the dim state, which is on screen far longer.
- Re-run after any colour, plate, backing or grade change.
- With special care when the deliverable has a stated accessibility obligation ([[sub-caption-role-decision]]) — at which point the caption stops being a design element and becomes the accessible alternative for the audio, which also brings speaker IDs and non-speech annotation into scope ([[sub-speaker-and-non-speech-annotation]]).

## How to recognise it in a reference video

The measurement is the note. It has two halves: the declared ratio, and the real one.

**Declared ratio** — text colour against plate colour, straight from the CSS. This is what `hyperframes check`'s contrast audit computes and it is the easy half.

**Real ratio** — text against what is actually behind it, at the worst frame:

```bash
# 1. isolate the caption band for the whole video
ffmpeg -i in.mp4 -vf "crop=iw:ih*0.20:0:ih*0.76" -an band.mp4

# 2. per-frame luminance of that band
ffmpeg -i band.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG" \
       -f null - 2> yavg.txt

# 3. also get the extremes, not just the average — YMIN/YMAX per frame
ffmpeg -i band.mp4 -vf "signalstats,metadata=print" -f null - 2> stats.txt

# 4. pull the frames at the brightest and darkest band timestamps and measure
ffmpeg -ss <t_bright> -i in.mp4 -frames:v 1 worst_bright.png
ffmpeg -ss <t_dark>   -i in.mp4 -frames:v 1 worst_dark.png
```

| Measurement | Threshold | Notes |
|---|---|---|
| Text vs plate (declared) | ≥4.5:1 | The easy half; the audit does it. |
| Text vs worst-case background | ≥4.5:1 | The real requirement. On an opaque plate these are the same number, which is the whole argument for a plate. |
| Plate vs busiest frame | ≥3:1 | 1.4.11 territory — below this the plate's edge dissolves. |
| Every state independently | ≥4.5:1 | Resting, accent, active, negated. Dim ≥3:1. |
| Greyscale distinguishability | must survive | `ffmpeg -vf format=gray` |
| Large-text allowance taken | should be no | Available on the pixel definition; decline it. |
| Post-encode ratio | ≥4.5:1 | Measure on the *delivered* file. Chroma subsampling and quantisation both cost contrast. |

The post-encode row is the one people skip and it is real: a ratio measured on a PNG export can drop measurably on a 4:2:0 H.264 delivery, especially for a coloured accent against a coloured plate, because the chroma planes are quarter-resolution.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `text_contrast_target` | 4.5:1 | ≥4.5:1 | WCAG 1.4.3 normal-text threshold. |
| `large_text_allowance` | declined | declined | 3:1 is available (most captions exceed 24 px) and should not be taken. |
| `large_text_definition` | 18 pt / 14 pt bold ≈ 24 px / 18.5 px | — | The pixel equivalents from the Understanding document. |
| `graphical_object_target` | 3:1 | ≥3:1 | WCAG 1.4.11, for the plate against the picture. |
| `rounding` | none | none | *"2.999:1 would not meet the 3:1 threshold."* |
| `measured_against` | worst frame in the caption band | worst, not typical | The method WCAG does not supply. |
| `states_checked` | all | all | Resting, accent, active, dim, negated. |
| `dim_state_target` | 3:1 | ≥3:1 | Still has to be readable. |
| `post_encode_check` | required | — | Measure on the delivered file, not the PNG. |
| `greyscale_check` | required | — | Contrast passing does not mean hue distinctions survive. |
| `colour_deficiency_prevalence` | 8 % M / 0.5 % F | — | Deuteranomaly ~5 % of males alone. |
| `redundant_cue_per_hue` | required | — | Contrast is necessary, not sufficient. |
| `audit_sample_count` | must be > 0 | — | `0/0 text checks` means a lint error disabled the audit. |
| `wcag_sc_referenced` | 1.4.3, 1.4.11, 1.2.2 | — | 1.2.2 is the Level A requirement that captions exist at all. |
| `text_spacing_sc` | not applicable | — | 1.4.12's 1.5 line-height is about reflowable text surviving user restyling. |

## Reproduction prompt

```
Verify the contrast accessibility of the caption design for {{PROJECT}} against
{{FOOTAGE}}.

Adopt WCAG's thresholds without adopting its measurement assumptions. SC 1.4.3
asks 4.5:1 for text and 1.4.11 asks 3:1 for graphical objects, but neither gives
a method for text over video — 1.4.11 advises taking colours from the stylesheet,
which a video frame does not have. So supply the method.

Do NOT take the large-text 3:1 allowance. Most captions exceed the 24px threshold
and qualify, but that allowance assumes static text a reader can dwell on. A
caption is on screen for a second, over motion, in peripheral vision. Design to
4.5:1.

Find the worst case empirically: crop the caption band, dump per-frame luminance
with ffmpeg signalstats, and pull the brightest and darkest band frames. Compute
the ratio at both.

Check EVERY state independently — resting, accent, active, dim, negated. Dim may
sit at 3:1; everything else clears 4.5:1. Do not round: 4.499:1 fails. Then check
the PLATE against the busiest frame at 3:1.

Then measure again on the ENCODED delivery file, not a PNG export — 4:2:0 chroma
subsampling costs measurable contrast on coloured text.

Finally convert a frame carrying every state to greyscale. About 8% of male
viewers have a colour deficiency, so every semantic hue needs a redundant
non-colour cue.

Acceptance test: a table of every state x {brightest frame, darkest frame,
post-encode} with unrounded ratios, no text cell under 4.5:1, no plate cell under
3:1, plus a greyscale frame in which every distinction still reads.
```

## Execution spec

Two layers of verification, and they check different things.

**Layer 1 — the framework audit.** `npx hyperframes check` runs lint, runtime, layout, motion and contrast together, targeting *"0 findings"*. Its contrast audit compares declared foreground and background colours, so it will correctly catch an accent that fails against the plate. It will not catch anything about the video, because the video is not a CSS colour.

Two traps:

- **A lint *error* switches the layout and contrast audits off.** `check` then reports `0 sample(s)` and `0/0 text checks`, which reads like a clean file and means nothing ran. **Always read the sample count**, not just the findings count. Fix lint errors first, then re-run.
- **The audit is browser-backed**, so it does not run on this project's device VM (linux ARM64, no sudo, no Chrome). Author and lint locally; run `check`'s browser audits elsewhere.

**Layer 2 — the worst-frame measurement.** A static-image operation, so it runs anywhere:

```bash
npx hyperframes snapshot --at <worst_bright_t>,<worst_dark_t>
# then compute the ratio between the sampled text pixels and the sampled
# background pixels on each frame
```

`snapshot` is required for projects with sub-compositions anyway, and a caption is normally a sub-composition, so this is not extra work — it is the existing step pointed at the right timestamps.

Further notes:

- **Sample a block, not a pixel.** Antialiasing at glyph edges gives intermediate values; WCAG's guidance notes that antialiasing reduces apparent contrast. Sample the interior of a thick stem.
- **`render --strict` fails on lint errors and `--strict-all` on warnings too.** Use `--strict` in any automated path so a lint error cannot silently disable the audits and then produce an MP4 anyway.
- **The correction is a design change, not an escape hatch.** `data-layout-allow-caption-zone` opts out of the caption-zone collision check; there is no equivalent for contrast, and there should not be.

## Pairs with

- [[sub-legibility-backing-ladder]] — the mechanism that delivers the ratio
- [[sub-caption-colour-token-system]] — the colours being measured
- [[sub-semantic-colour-assignment]] — why contrast alone is insufficient
- [[sub-caption-plate-geometry]] — the plate whose edge needs 3:1
- [[sub-open-vs-closed-captions]] — the other half of caption accessibility
- [[sub-speaker-and-non-speech-annotation]] — what a WCAG-A caption must additionally carry
- [[sub-caption-role-decision]] — where the accessibility obligation is declared
- [[sub-size-as-frame-height-percentage]] — the px thresholds that define large text

## Failure modes

- **Reading `0/0 text checks` as a pass.** A lint error disabled the audit. This is the single most dangerous false negative in the toolchain.
- **Measuring against a representative frame.** Every video has a worst frame and it is never the one you looked at.
- **Taking the large-text 3:1 allowance.** Technically available, wrong for moving text seen peripherally for a second.
- **Checking only the resting state.** The dim and active states are on screen too, and the dim state is the one that fails.
- **Rounding.** 4.49:1 is not 4.5:1, and the standard says so explicitly.
- **Measuring on a PNG export.** The delivered file has quarter-resolution chroma and loses contrast on coloured text.
- **Sampling a single pixel at a glyph edge.** Antialiasing gives a value between foreground and background; the number is meaningless.
- **Passing contrast and failing greyscale.** Two colours at 5:1 against the plate can be identical to a deuteranope.
- **Trusting the framework audit over video.** It compares declared colours. Over a transparent background it has nothing meaningful to compare.
- **Treating contrast as a review comment rather than a gate.** By the time it is a comment, the palette is committed.
