---
id: sub-semantic-colour-assignment
title: One colour, one meaning, held for the whole video — and never carried by colour alone
skill: subtitles
type: caption-style
family: caption-colour
tags: [skill/subtitles, type/caption-style, family/caption-colour, engine/hyperframes, source/research, source/editing-kt, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: n/a
    quote: "Red strikethrough as the signature rhetorical device: S̶T̶IMULATING, captions just to ~~jack up the visual variety~~, and BORING stamped in red across a YouTube analytics screenshot. Struck-through or red-overlaid text = a claim being negated."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Title cards whose type treatment matches the content — SMASH CUT in a rough eroded chalk face. The typeface is doing semantic work."
research_refs:
  - https://en.wikipedia.org/wiki/Color_blindness
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://www.w3.org/TR/WCAG22/
  - https://en.wikipedia.org/wiki/Closed_captioning
difficulty: high
detectable_from: video
---

# One colour, one meaning, held for the whole video — and never carried by colour alone

## What it is

Semantic colour is colour used as a **code** rather than as decoration: the viewer learns, without being told, that this hue means this thing, and then reads it instantly for the rest of the video. It is one of the highest-leverage devices in caption design and one of the easiest to destroy, because it depends entirely on consistency and scarcity.

Three rules make it work, and violating any one of them collapses it:

**Bijection.** One colour maps to one meaning, and one meaning maps to one colour. The moment the accent hue marks both "this is the key term" and "this is a number worth remembering", the viewer has to consciously decide which reading applies, and the whole speed advantage is gone. Two meanings need two colours or, better, one colour and one non-colour device.

**Persistence.** The mapping holds for the entire video, and ideally for the entire channel. Semantic colour is a learned code; it costs the viewer a few seconds to acquire and pays back over the remaining minutes. Changing it at the halfway point spends the acquisition cost twice and returns nothing.

**Redundancy.** Colour is never the only carrier. About **8 % of males and 0.5 % of females** have a congenital colour deficiency; deuteranomaly alone accounts for about **5 % of males**. Red-green codes in particular are, in the literature's own words, *"almost always undifferentiable to deutans or protans"*. So a red word and a green word are, for one viewer in twelve, two identical words. This is not a compliance footnote — in a caption, where the whole point is instant recognition, a code that fails for 8 % of the audience is a code that fails.

Redundancy is cheap. Weight, a strikethrough line, a bracket, a position, a preceding glyph, a plate — any of these carries the same distinction and costs nothing. The correct formulation is: **colour is the fast channel; the redundant cue is the reliable one.** Design so that greyscale still works, then add the colour so that it works faster.

## When to use it

Semantic colour earns its place when there is a **recurring, binary or small-set distinction** the viewer needs to make repeatedly:

- **Negation** — a claim being marked as wrong. This is the strongest case and the one this vault has evidence for; see [[sub-red-strikethrough-negation]].
- **Term versus explanation** — the accent marks the word the section is named after ([[sub-term-definition-lockup]]).
- **Active versus spoken versus unspoken** in a karaoke track ([[sub-karaoke-active-word-highlight]]) — a three-state code, and the only place where three states is defensible, because position in the line is a fully redundant cue.
- **Quantities worth remembering** — a dB figure, a BPM, a price.

It does **not** earn its place for:

- **Speaker identity.** Broadcast does this because CEA-608 had eight colours and nothing else. Burned-in captions have prefixes and position. See [[sub-speaker-and-non-speech-annotation]].
- **Sections or chapters.** The viewer does not need a colour to know the topic changed; the cut and the title card already said so.
- **Mood.** That is the grade's job.

## How to recognise it in a reference video

The test is whether the mapping is **recoverable** from the video without explanation.

1. Sample 15–25 frames containing coloured caption text across the whole duration.
2. Cluster the text colours by hue. Ignore luminance variation from compression.
3. For each cluster, write down what the coloured words have in common — grammatically, semantically, or structurally.
4. If you can state a rule per cluster in one sentence, the colour is semantic. If the best you can do is "important words", it is decoration.

| Signal | Semantic | Decorative |
|---|---|---|
| Distinct hues | 1–3, each with a stateable rule | 4+, or 2 with the same rule |
| Consistency | Every instance of the category is coloured | Some instances coloured, some not |
| Exclusivity | The hue appears on nothing outside its category | The hue also shows up on a random adjective |
| Redundant cue present | Colour co-occurs with a mark, weight change, bracket or position | Colour alone |
| Greyscale test | Convert a frame to greyscale — the distinction survives | Greyscale flattens it to nothing |
| First occurrence | The code is established early, on an unambiguous case | First use is on an ambiguous word, so the code never lands |
| Density | Under ~10 % of words carry any hue | 30 %+ — see [[sub-over-emphasis-audit]] |

The greyscale test is the whole note in one operation: `ffmpeg -i frame.png -vf format=gray out.png`. If the frame stops making sense, the design is failing 8 % of its audience and probably a lot more on a phone in sunlight.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `semantic_hues` | 1 | 1–3 | Each with a written rule. Three only when position is fully redundant, as in karaoke. |
| `mapping` | bijective | bijective | One hue, one meaning, both directions. |
| `persistence_scope` | whole video | video / channel | Channel-level is better. Never sub-video. |
| `redundant_cue` | required | required | Weight, strike, bracket, glyph, position or plate. Named per hue, not implied. |
| `greyscale_survival` | required | — | Convert to grey; every distinction must remain readable. |
| `establish_by` | first 20 % of runtime | 0–30 % | The code must be introduced on an unambiguous instance early, or it never gets learned. |
| `first_use_unambiguous` | required | — | Establish "red = negated" on a claim that is obviously being rejected, not on a subtle one. |
| `category_coverage` | 100 % | ≥90 % | If the rule is "numbers are accented", every number is accented. Partial application destroys the code. |
| `hue_exclusivity` | 100 % | 100 % | The hue appears on nothing outside its category. One stray use and the rule is gone. |
| `coloured_word_share` | ≤10 % | 5–15 % | Above 15 % the code inflates. See [[sub-over-emphasis-audit]]. |
| `red_green_pair` | forbidden | — | Undifferentiable to deutans and protans, who are ~7 % of males combined. If you need two hues, use blue/orange or blue/yellow. |
| `deficiency_prevalence` | 8 % M / 0.5 % F | — | Deuteranomaly ~5 % of males; protan types ~2 %; tritan <0.01 %. |
| `contrast_per_state` | ≥4.5:1 | ≥4.5:1 | Every semantic colour must clear the threshold against the plate independently. |
| `speaker_colour_coding` | off | off | A broadcast palette workaround, not a design. |
| `documented_in` | `design-subtitles.md` emphasis map | — | The rule is written down, with the redundant cue, before any cue is styled. |

## Reproduction prompt

```
Assign semantic colour for the captions in {{PROJECT}}. The recurring
distinctions the viewer must make are: {{LIST THEM}}.

For each, decide whether it deserves a colour at all. It does only if it recurs
at least {{4}} times, is binary or small-set, and cannot be carried more cheaply
by position or weight. Speaker identity and section topic do not qualify — they
have cheaper carriers.

Emit a mapping table, one row per hue: the hue; its meaning in one sentence; the
RULE deciding membership, written so a second person applying it to the
transcript gets the same answer; the REDUNDANT NON-COLOUR CUE; and the hue's
contrast ratio against the plate.

Use at most three hues. The mapping must be bijective — no hue with two meanings,
no meaning with two hues — and must hold for the entire video. Never pair red
against green: the two are almost always undifferentiable to deutan and protan
viewers, about 7% of the male audience. Every hue must clear 4.5:1 against the
plate on its own.

Then apply the rule to the transcript and count. If more than 15% of words carry
any hue, the rules are too loose — tighten them and re-count, do not hand-prune.

Acceptance test: render six cues spanning every state and convert to greyscale
with `ffmpeg -vf format=gray`. Every distinction must remain readable from the
redundant cue alone. Then hand the mapping table and a fresh page of transcript
to a second pass and confirm it colours the same words.
```

## Execution spec

Semantic states are classes on spans inside `.caption-text`, and the class name carries the meaning — never the colour:

```css
/* Class names name the MEANING. .term, not .cyan. A colour-named class
   guarantees that the next person who changes the palette breaks the code. */
[data-composition-id="captions"] .caption-text .term    { color: var(--cap-accent); font-weight: var(--cap-weight-emph); }
[data-composition-id="captions"] .caption-text .negated { color: var(--cap-negate); text-decoration: line-through; }
[data-composition-id="captions"] .caption-text .figure  { color: var(--cap-accent); }
```

Note the redundant cue is baked into the rule: `.term` also gets a weight step, `.negated` also gets a line. Neither relies on hue alone.

Stack-specific:

- **The staged caption implementation writes `textContent`**, which cannot contain spans. Semantic colour therefore requires switching to `innerHTML` with pre-escaped markup, or — better and safer — to a **per-word element model** where each word is its own `<span>` created at build time and the timeline only toggles classes. The per-word model is also the seek-robust alternative to the single-box design, whose known fragility is that a backwards seek does not restore the correct text because `onStart` fires only on forward entry.
- **Toggle classes with `tl.set()`, not by tweening colour.** Semantic states are discrete.
- **`--strict-variables` is the guard for a per-episode palette.** Expose the hues as composition variables and let a wrong key fail the render rather than silently fall through to a default.
- **The contrast audit checks each declared colour against its declared background**, so it will catch a semantic hue that fails against the plate. It cannot check the greyscale test — that is a manual `snapshot` plus `ffmpeg -vf format=gray`.
- Record the mapping in the **Emphasis map** table of `_templates/design-subtitles.md`. That table has a `Rule` column precisely so the rule, not the list, is the artefact.

## Pairs with

- [[sub-caption-colour-token-system]] — the palette these meanings are assigned to
- [[sub-red-strikethrough-negation]] — the fully worked instance of a semantic colour
- [[sub-emphasis-selection-rule]] — the same "rule not list" discipline for emphasis
- [[sub-over-emphasis-audit]] — the density ceiling that keeps a code readable
- [[sub-karaoke-active-word-highlight]] — the three-state case
- [[sub-speaker-and-non-speech-annotation]] — why speaker identity should not take a hue
- [[sub-caption-contrast-accessibility]] — per-state ratio requirements
- [[motion-colour-shift-connotation]] — the same argument in motion graphics
- [[sub-term-definition-lockup]] — a term label that shares the accent

## Failure modes

- **One hue, two meanings.** The viewer has to disambiguate consciously and the speed advantage — the only reason to use colour — is gone.
- **The code changes mid-video.** The acquisition cost is paid twice and never amortised.
- **Colour alone.** Fails for roughly 8 % of male viewers outright, and for everyone on a bad phone screen in sunlight.
- **A red/green pair.** The single worst choice available, and the most commonly reached for because of the good/bad convention.
- **Partial application.** The rule says "all numbers"; the video colours some of them. The viewer concludes there is no rule and stops reading the colour.
- **Colour-named CSS classes.** `.cyan` instead of `.term`. The next palette change silently decouples the name from the meaning.
- **Establishing the code on an ambiguous case.** If the first red word is one the viewer is not sure is being negated, the code never lands.
- **Speaker colour-coding.** Burns the accent budget on a job a dash does for free.
- **Trusting `textContent` to carry markup.** It will render your spans as literal text. The per-word element model is the real fix, and it fixes the seek fragility too.
