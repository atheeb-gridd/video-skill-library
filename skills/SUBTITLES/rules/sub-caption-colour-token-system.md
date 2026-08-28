---
id: sub-caption-colour-token-system
title: Six colour tokens, one accent, and never pure white
skill: subtitles
type: caption-style
family: caption-colour
tags: [skill/subtitles, type/caption-style, family/caption-colour, engine/hyperframes, source/hyperframes, source/research, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: ".caption-text — color: #f5f0e0. .caption-box — background-color: #7a6248."
  - video: "assets/videos/editing kt.mp4"
    timestamp: n/a
    quote: "Creator A (the Hinglish house style) — abstract diagram cards on dark ground ... a dark teal/navy ground with a muted cyan accent."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://en.wikipedia.org/wiki/Color_blindness
  - https://en.wikipedia.org/wiki/Closed_captioning
difficulty: medium
detectable_from: video
---

# Six colour tokens, one accent, and never pure white

## What it is

A caption colour system is six named values and a rule about how many of them may appear at once:

| Token | Job | Reference value |
|---|---|---|
| `--cap-colour` | Resting text | `#f5f0e0` |
| `--cap-plate` | The backing | `#7a6248` |
| `--cap-accent` | The one emphasis hue | — |
| `--cap-active` | Karaoke active word, if any | — |
| `--cap-dim` | Already-spoken or de-emphasised text | — |
| `--cap-negate` | Struck-through / negated text | — |

Two design claims sit underneath the list.

**Never pure `#ffffff`, and never pure `#000000`.** The reference implementation uses `#f5f0e0` — a warm off-white — and not white, and this is correct for reasons that are mechanical rather than aesthetic. Pure white text is the brightest possible signal in the frame, so on an SDR delivery it clips the encoder's headroom: the letterforms bloom, the negative tracking that was supposed to make them survive quantisation instead makes them merge, and on any display with even mild overshoot the caption glows. Pulling to about 94–96 % luminance costs almost nothing in contrast — `#f5f0e0` on `#7a6248` still computes to roughly 6.4:1 — and removes the bloom entirely. Warm off-white also sits more comfortably over the skin tones and interior light that dominate talking-head footage than a blue-white does.

**One accent.** Not one accent per section, not one per meaning: one, for the whole video, unless a second is doing genuinely different semantic work ([[sub-semantic-colour-assignment]]). The reason is the same reason [[sub-over-emphasis-audit]] exists: a highlight is defined by its scarcity. Two accent colours halve the salience of each and the viewer stops reading them as marks and starts reading them as decoration.

Note what this system deliberately does **not** inherit: the broadcast caption tradition of colour-coding speakers (white / yellow / cyan / green in CEA-608 and in European teletext practice). That convention exists because those systems had a fixed eight-colour palette and no other way to distinguish speakers. In a burned-in caption you have position, prefix and typography available, and colour is a scarcer resource better spent on emphasis. See [[sub-speaker-and-non-speech-annotation]].

## When to use it

- At identity time, alongside the type tokens ([[sub-caption-identity-token-set]]). Colour is not decided per cue.
- The palette is derived **from the video's existing colour language**, not invented. Creator A's house style is a dark teal/navy ground with a muted cyan accent; a caption accent in that video is cyan, because anything else introduces a colour the video does not otherwise contain.
- `--cap-active` and `--cap-negate` are declared only if the video actually uses those devices. An unused token in the block is a future temptation.
- Re-derive `--cap-plate` if the grade changes. A plate colour chosen against a warm grade reads muddy against a cool one.

## How to recognise it in a reference video

Colour is the easiest caption property to sample and the easiest to misreport, because encoding shifts it. Sample from a **high-bitrate source or an I-frame** where possible, and sample a block of pixels rather than one.

| Measurement | Method | Reading |
|---|---|---|
| Resting text luminance | Sample the interior of a thick stem, 5×5 px average | 240–250 (94–98 %) = an off-white system. 255 = pure white, expect bloom. |
| Text hue | Convert the sample to HSL | Hue 30–60° at low saturation = warm off-white. Hue ~210° = cool white. Saturation 0 = pure grey. |
| Plate colour | Sample 5 points inside the box, away from the text | Identical = opaque. Spread = translucent. |
| Computed ratio | Run the two samples through the WCAG contrast formula | Report it. 4.5:1 is the normal-text threshold; large text is allowed 3:1. |
| Distinct accent hues | Collect every non-resting text colour across 12 sampled cues, cluster by hue | 1 = disciplined. 2 = check whether they mean different things. 3+ = decoration. |
| Accent-to-plate ratio | Same formula, accent vs plate | Often the failure: an accent chosen against the *text* colour rather than against the plate can be beautiful and illegible. |
| Dim state | Sample an already-spoken word on a karaoke track | Below 60 % of the resting luminance and read-back is destroyed. |
| Red usage | Is any red present, and is it doing negation? | See [[sub-red-strikethrough-negation]]. |

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `resting_text` | `#f5f0e0` | L* 92–97 | The reference value. Warm off-white. Never `#ffffff`. |
| `pure_white_permitted` | no | — | Clips SDR headroom, blooms, and merges under negative tracking. |
| `pure_black_permitted` | no | — | Use `#0d0c0b`-ish for a dark plate; pure black crushes and shows banding on gradients. |
| `plate` | `#7a6248` | — | Reference value. Chosen against the grade, not from a swatch library. |
| `text_vs_plate_ratio` | 6.4:1 | ≥4.5:1 | The reference pair computes to about 6.4:1. Design to 4.5:1 even where the large-text 3:1 allowance would apply — the allowance assumes static text. |
| `plate_vs_video_ratio` | ≥3:1 | ≥3:1 | The plate is a graphical object under WCAG 1.4.11; below 3:1 its edge dissolves. |
| `accent_count` | 1 | 1–2 | Two only if the second carries a distinct, stated meaning. |
| `accent_vs_plate_ratio` | ≥4.5:1 | ≥4.5:1 | The commonest palette bug: the accent was checked against the text, not against what it sits on. |
| `accent_source` | the video's existing palette | — | Derive from the grade and the graphics, do not invent. |
| `active_word_colour` | accent | — | Karaoke active state. Both the active and the resting state must clear 4.5:1 against the plate. |
| `dim_state` | 70 % luminance of resting | 60–85 % | Below 60 % read-back is gone. Dim by luminance, not by opacity, if the backing is a stroke — opacity thins the stroke too. |
| `negate_colour` | a red at L* 45–55 | — | Only if the video uses the negation device. Never as the *sole* carrier of meaning. |
| `hue_count_total` | ≤3 | 1–3 | Resting, accent, negate. Plate is not a hue in this count. |
| `speaker_colour_coding` | off | off | A CEA-608 broadcast convention with a fixed 8-colour palette. In burned-in captions, spend colour on emphasis. |
| `colour_alone_carries_meaning` | never | — | 8 % of males and 0.5 % of females have red-green colour deficiency; deuteranomaly alone is about 5 % of males. Colour is always redundant with a second cue. |

## Reproduction prompt

```
Derive the caption colour token set for {{PROJECT}}, whose grade is {{describe}}
and whose graphic language already uses {{hues present}}.

Emit exactly six tokens: --cap-colour, --cap-plate, --cap-accent, --cap-active,
--cap-dim, --cap-negate. Omit any whose device this video does not use; do not
emit a token speculatively.

Resting text is an off-white in the L* 92-97 band, never #ffffff — pure white
clips SDR encoder headroom, blooms, and merges under the negative tracking
captions require. Dark values bottom out around #0d0c0b, never #000000.

Use exactly ONE accent hue for the whole video, drawn from the colour language
the video already has rather than invented. If you propose a second, state the
distinct meaning it carries and confirm that meaning cannot be carried by
position, weight or a mark instead.

Compute and report three contrast ratios: resting text vs plate (>=4.5:1); accent
vs plate (>=4.5:1 — check the accent against what it SITS ON, not against the
resting text); and plate vs the three busiest frames of the footage (>=3:1).

No colour may be the sole carrier of any meaning. For every semantic use of
colour, name the redundant non-colour cue carrying the same information — about
8% of male viewers have a red-green deficiency and will not see the hue at all.

Acceptance test: render one cue in every state — resting, accent, active, dim,
negated — over the brightest and darkest caption-band frames. Every state must
clear 4.5:1 against its backing at both. Then convert to greyscale: every
semantic distinction must still be readable.
```

## Execution spec

```css
[data-composition-id="captions"] {
  --cap-colour: #f5f0e0;      /* warm off-white, L* ~94 */
  --cap-plate:  #7a6248;
  --cap-accent: #6fd3d8;      /* the one accent, drawn from the video's cyan */
  --cap-active: var(--cap-accent);
  --cap-dim:    #b9b0a2;      /* ~72% of resting luminance */
  --cap-negate: #d9483f;
}
[data-composition-id="captions"] .caption-text        { color: var(--cap-colour); }
[data-composition-id="captions"] .caption-text .emph  { color: var(--cap-accent); }
[data-composition-id="captions"] .caption-text .spent { color: var(--cap-dim); }
```

Stack-specific notes:

- **Colour is animatable, and mostly should not be.** GSAP will tween `color`, but a caption's state changes are discrete — a word is active or it is not — and a crossfade between two text colours reads as lag rather than as motion. Use `tl.set()` for state swaps and reserve tweening for the box opacity. The one exception is a deliberate slow reveal ([[motion-colour-shift-connotation]]).
- **Dim by colour, not by opacity, when the backing is a stroke.** `opacity: 0.7` on a word thins its stroke too, so the dimmed word loses contrast twice. Setting `color: var(--cap-dim)` leaves the stroke intact.
- **The contrast audit inside `check` compares declared colours.** It will correctly catch `--cap-accent` failing against `--cap-plate`, because both are declared. It will not catch anything about the accent over video, because the video is not a CSS colour. That case is the worst-case-frame method in [[sub-legibility-backing-ladder]].
- **Colour tokens are the natural thing to expose as composition variables.** Declared in `data-composition-variables` on `<html>`, overridden per render with `--variables '{"capAccent":"#6fd3d8"}'`, and validated with `--strict-variables`. This is how one caption composition serves a series with per-episode accents without forking the file.
- **Sample the grade, do not eyedrop a compressed export.** 4:2:0 chroma subsampling means a colour sampled from a delivered MP4 is a quarter-resolution average of its neighbourhood. Take palette values from the graded source.

## Pairs with

- [[sub-semantic-colour-assignment]] — what each colour is allowed to mean
- [[sub-red-strikethrough-negation]] — the one place red is licensed
- [[sub-legibility-backing-ladder]] — the ratios are computed against the backing
- [[sub-caption-plate-geometry]] — the plate this palette sits on
- [[sub-caption-identity-token-set]] — where the six tokens live
- [[sub-karaoke-active-word-highlight]] — where `--cap-active` and `--cap-dim` are used
- [[sub-caption-contrast-accessibility]] — the thresholds these ratios are measured against
- [[motion-colour-shift-connotation]] — colour carrying meaning in motion graphics
- [[motion-colour-dip-transition]] — the video's broader colour language

## Failure modes

- **Pure white text.** Blooms, clips SDR headroom, and merges under negative tracking. The fix costs 4 % luminance and no measurable contrast.
- **Checking the accent against the text colour.** The accent sits on the plate. An accent that contrasts beautifully with the resting white and poorly with the plate is invisible exactly where it is used.
- **Two accents.** Each is now half as salient. Emphasis becomes decoration.
- **Speaker colour-coding carried over from broadcast.** It burns the accent budget on a job that a dash prefix does for free.
- **Colour as the only carrier.** About 8 % of male viewers will not see it. Every semantic hue needs a redundant shape, position or mark.
- **Eyedropping a delivered MP4.** Chroma subsampling averages the colour over a 2×2 block; the value you read is not the value that was authored.
- **Dimming by opacity over a stroke.** Thins the stroke, so the dim state loses contrast twice and can drop below the floor.
- **Tweening text colour on a state change.** Reads as lag. Discrete states want `set`, not `to`.
- **A `--cap-negate` token in a video that never negates anything.** It will get used for something else within two episodes.
