---
id: sub-weight-case-and-optical-size
title: One weight for the track, one cut above for emphasis — and sentence case by default
skill: subtitles
type: caption-style
family: caption-type
tags: [skill/subtitles, type/caption-style, family/caption-type, engine/hyperframes, source/hyperframes, source/research, difficulty/low]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: ".caption-text — font-weight: 700. Inter is a bundled font (weights 400 · 700 · 900, so 700 here is a real cut)."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "On dark backgrounds, drop body weight (350 not 400) and add 0.05–0.1 line-height."
research_refs:
  - https://en.wikipedia.org/wiki/X-height
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://www.w3.org/TR/WCAG22/
difficulty: low
detectable_from: video
---

# One weight for the track, one cut above for emphasis — and sentence case by default

## What it is

Three type decisions that get made carelessly and then constrain everything downstream.

**Weight.** Captions live over unpredictable, moving, often bright content. A 400 body weight that is perfectly legible on a page disappears over a window. The reference implementation uses `700`, and that is roughly correct as a floor for a caption on a plate — but the interaction with the ground matters and cuts both ways. Light text on a dark ground **optically gains weight**: the light letterform bleeds into the dark field, and stems look thicker than they are. The project's own guidance encodes this: on dark backgrounds, drop the body weight (350 rather than 400) and add 0.05–0.1 to line-height. Dark text on a light ground loses weight and needs a cut more. So "700" is not a universal answer; "one cut heavier than the same face would need on paper, minus a step if the ground is dark" is.

**Case.** All-caps has one real advantage — a uniform rectangle, easy to plate, no descender collisions — and one fatal one: it deletes word shape. Reading in peripheral vision is silhouette recognition, and in all-caps every word is the same silhouette. The degradation is not linear; it is a cliff at roughly **four words**. One or two words in caps reads as a mark. A seven-word sentence in caps has to be read letter by letter.

**Optical size.** A real optical-size axis (`opsz`) redraws the letterform for its intended size: larger x-height, wider spacing, thicker hairlines at small sizes. Almost none of the bundled families expose it, and even where a variable font does, HyperFrames' variable-font-axis animation technique treats it as an animation target rather than a static design choice. **The practical position for captions is: there is no optical size knob. Compensate with tracking and weight instead** — which is exactly what [[sub-tracking-and-caption-line-height]] is for. Saying this plainly matters, because "just use the optical size axis" is advice that will not execute in this stack.

## When to use it

- **Weight:** decided once with the face, then held. It is a token, not a per-cue property.
- **Case:** decided per *object*, not per video. A track is sentence case; a one-word topic card ([[sub-single-word-topic-card]]) is caps; a term label ([[sub-term-definition-lockup]]) is caps. That is three different objects with three different cases and it is coherent, because each object has a consistent case.
- **A second weight cut** is introduced only when there is a real emphasis layer to carry ([[sub-emphasis-selection-rule]]). Two cuts is the design. Three cuts is drift.
- Revisit weight whenever the backing changes, because a stroke adds apparent weight and a plate does not.

## How to recognise it in a reference video

| Signal | How to measure it | Reading |
|---|---|---|
| Stem width as % of cap height | Measure the vertical stem of `H` or `l`, divide by cap height | ~0.11–0.13 = 400. ~0.16–0.19 = 700. ~0.21+ = 800/900. |
| Number of distinct stem widths in the video | Measure at 8 sampled cues | 1 = flat. 2 = a designed emphasis layer. 3+ = drift. |
| Case | Read it | Caps for ≤4 words = a mark. Caps for a full sentence = a mistake or an intentionally shouty channel. |
| Synthetic bold | Look at the joins on `a`, `e`, `g` under magnification | Synthetic bold thickens uniformly and clogs joins. A real cut redraws the join. |
| Ground-dependent weight | Compare stem width on a bright cue vs a dark cue | If they are identical, weight was not tuned per ground. That is normal and usually acceptable on a plate. |
| Caps + descender-free plate | Is the plate the same height on every cue? | Caps gives a constant-height plate; sentence case gives a plate that grows when a `g` or `y` appears, unless padding is set in `em` to absorb it. |

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `track_weight` | 700 | 600–800 | The reference file's value, and a real cut in bundled Inter. Verify the cut exists in the chosen family. |
| `track_weight_dark_ground` | 650 | 350–700 | Light-on-dark bleeds. The project's own rule: drop body weight (350 not 400) on dark grounds; the same one-step drop applies at caption weights. |
| `emphasis_weight` | 900 | 800–900 | Exactly one cut above the track. If the family ships 400/700/900, the pair is 700/900. |
| `weight_cuts_used` | 2 | 1–2 | Hard ceiling. A third cut is drift, not hierarchy. |
| `synthetic_bold` | forbidden | — | Any `font-weight` not physically shipped is synthesised. Check the family's cut list. |
| `track_case` | sentence | sentence / upper | Sentence case for anything over 4 words. |
| `caps_word_ceiling` | 4 | 1–4 | Above 4 words, all-caps costs more than the tidy rectangle is worth. |
| `caps_tracking_bonus` | +0.02 em | +0.01 to +0.03 em | All-caps needs *less* negative tracking than lowercase — caps are drawn with more sidebearing already. If the track runs −0.04 em, a caps object runs −0.02 em. |
| `mark_case` | UPPER | upper | Emphasis captions, topic cards and term labels: caps, no terminal full stop. |
| `sentence_case_terminal_punctuation` | omit | omit / keep | A full stop at the end of a 3-word cue reads as a typo. Keep `?` and `!` — they carry prosody. |
| `optical_size_axis` | unavailable | — | Not exposed by the bundled families. Do not write a spec that depends on `opsz`. |
| `small_caps` | forbidden | — | Synthesised small caps (`font-variant: small-caps` without a real cut) scales the caps down and destroys stroke weight. |
| `plate_height_stability` | `em` padding | — | Padding in `em` plus a fixed `line-height` keeps the plate the same height whether or not the cue has a descender. |

## Reproduction prompt

```
Specify weight and case for the caption objects in {{PROJECT}}, set in
{{FAMILY}} whose shipped cuts are {{LIST THE CUTS}}, over ground that is
predominantly {{light|dark|mixed}}.

Assign exactly one weight to the track and at most one cut above it for emphasis.
Both must be cuts the family physically ships — name them from the list. If the
intended weight is not shipped, take the nearest shipped cut and say so; never
emit a font-weight the family lacks, because the browser synthesises it and
synthetic bold clogs the joins at caption size.

If the ground is predominantly dark, drop the track weight one step and add
0.05-0.1 to line-height, because light-on-dark letterforms optically gain
weight.

Assign case per object, not per video: sentence case for any object over four
words; UPPER for emphasis marks, one-word topic cards and term labels, with no
terminal full stop. If an object is set in caps, reduce its negative tracking by
about 0.02em relative to the lowercase track — caps carry more sidebearing.

Do not specify an optical-size axis; it is not exposed by the bundled families
in this project. Compensate with tracking and weight instead.

Acceptance test: render one cue per object over a bright frame and a dark frame
from the actual footage. Measure the stem width of a capital H in each and
divide by cap height. The track must land 0.16-0.19; the emphasis object must be
at least 0.03 higher. Count the distinct stem widths across the whole video: two
passes, three fails.
```

## Execution spec

Weight and case are tokens on the caption root, consumed by the text rule and overridden only by a named variant class:

```css
[data-composition-id="captions"] {
  --cap-weight: 700;
  --cap-weight-emph: 900;
  --cap-tracking: -0.04em;
}
[data-composition-id="captions"] .caption-text {
  font-weight: var(--cap-weight);
  letter-spacing: var(--cap-tracking);
  text-transform: none;              /* sentence case is the default */
}
[data-composition-id="captions"] .caption-text .emph {
  font-weight: var(--cap-weight-emph);
}
[data-composition-id="captions"] .caption-text--mark {
  text-transform: uppercase;
  letter-spacing: calc(var(--cap-tracking) + 0.02em);
}
```

Two HyperFrames-specific notes:

- **`text-transform: uppercase` changes the rendered string but not `textContent`.** The reference implementation writes `textEl.textContent = line.text` in the fade-in tween's `onStart`. If you uppercase in CSS, the transcript string in the DOM stays verbatim — which is what you want for [[sub-orthography-protection-no-autocorrect]] and what any downstream extraction reads. Uppercasing in JS instead destroys the verbatim record. **Always transform in CSS, never in the string.**
- **Weight is not animatable across static cuts.** Tweening `fontWeight` from 700 to 900 against a family that ships only those two cuts snaps at 50 % rather than interpolating. If a weight change needs to animate, use a variable font with a real `wght` axis, or animate `scale` instead ([[motion-emphasis-scale-step]]). Do not put a weight tween in a caption timeline and assume it interpolates.

Verify with `snapshot --at <cue midpoints>` and look at the frames; the contrast audit inside `check` will catch a too-light weight over a light plate but will not catch synthetic bold.

## Pairs with

- [[sub-typeface-selection-for-captions]] — which cuts are even available
- [[sub-tracking-and-caption-line-height]] — the compensation for the missing optical-size axis
- [[sub-caption-identity-token-set]] — where the two cuts are recorded
- [[sub-emphasis-selection-rule]] — what the second cut is allowed to mark
- [[sub-single-word-topic-card]] — an object that is legitimately all-caps at weight 800
- [[sub-term-definition-lockup]] — term in caps, definition in sentence case
- [[motion-emphasis-scale-step]] — the animated alternative to a weight change

## Failure modes

- **A weight the family does not ship.** The commonest single caption bug in this stack. `600` against 400/700/900 synthesises, and at 48 px the join of `a` fills in solid.
- **All-caps for the whole track.** Tidy plates, unreadable in peripheral vision, and it reads as shouting for the entire video. The four-word cliff is real.
- **Three weights.** 400 body, 700 normal, 900 emphasis. The middle cut carries no meaning and the emphasis stops reading as emphasis.
- **Uppercasing the string instead of the CSS.** Destroys the verbatim transcript record, breaks the ASR-correction log, and mangles romanised Hinglish proper nouns.
- **Tweening font-weight.** Snaps rather than interpolating unless a real `wght` axis exists.
- **Ignoring the ground.** A 700 designed on a dark plate looks correct; the same 700 as unplated dark text over a bright sky looks a cut too light. Weight is relative to what is behind it.
- **All-caps at the track's lowercase tracking.** Caps at −0.05 em collide. Caps need a good 0.02 em back.
- **A plate that changes height per cue.** Sentence case with `padding` in px and no fixed `line-height` gives a taller box whenever a descender appears, so the caption visibly jitters vertically across cues.
