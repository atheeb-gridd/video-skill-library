---
id: sub-emphasis-selection-rule
title: Write the rule that picks the emphasised word, not the list of words
skill: subtitles
type: caption-style
family: emphasis-caption
tags: [skill/subtitles, type/caption-style, family/emphasis-caption, engine/hyperframes, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:02"
    quote: "So I only use captions when I want the viewer to catch specific words and pay extra attention to them."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:20"
    quote: "Also keep it to three words or fewer, since that makes them easier to read."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://www.w3.org/WAI/media/av/captions/
  - https://en.wikipedia.org/wiki/Color_blindness
difficulty: high
detectable_from: transcript+video
---

# Write the rule that picks the emphasised word, not the list of words

## What it is

Every caption design that emphasises anything has an implicit rule for which words get lifted. Most of the time nobody writes it down, so the rule is "whatever felt important while scrubbing", and the result is inconsistent across a video and unreproducible across a series.

The rule is the artefact. A list of emphasised words does not transfer to the next video; a rule does. And a rule can be **counted**, which is the only way to know whether the emphasis has inflated ([[sub-over-emphasis-audit]]).

A good emphasis rule has four properties:

**It is stated in terms the transcript can be scanned for** — parts of speech, semantic categories, structural position — not in terms of feeling. "Nouns that name a thing the viewer must remember" is scannable. "The important bits" is not.

**It is exclusive.** A rule that admits 40 % of words is not a rule. The most useful rules have a hard structural gate — one per sentence, one per beat, one per list item — because a per-unit cap keeps the rate bounded regardless of how the content varies.

**It produces the same answer twice.** Hand the rule and a fresh page of transcript to a second pass and compare. Disagreement above about 15 % means the rule is underspecified.

**It survives being wrong occasionally.** A rule that needs case-by-case override is a list with extra steps.

The default rule that works across most explainer content, in priority order:

1. **The named term** — the label the section will use afterwards. One per section.
2. **The quantity** — any number with a unit that the viewer might act on. `−3 dB`, `120 BPM`, `42 characters`.
3. **The promise or payoff word** — the noun in the sentence that states what the viewer gets.
4. **The negated claim** — handled by a different mark entirely; see [[sub-red-strikethrough-negation]].

Everything else defaults to no emphasis. Note what is deliberately absent: verbs, adjectives, intensifiers ("really", "massively", "huge"), and profanity. Intensifiers are the single biggest source of emphasis inflation, because they *sound* emphatic in the audio and so the editor reaches for the accent — but they carry no information the viewer needs to retain, and the audio has already delivered the emphasis.

## When to use it

- Written **before any cue is styled**, at the top of the Emphasis map in `_templates/design-subtitles.md`. That table has a `Rule` column for exactly this reason.
- Applied mechanically to the whole transcript in one pass, then counted, then tightened if the count is over budget. **Never hand-pruned** — hand-pruning is how a rule silently becomes a list again.
- Re-derived per format, not per video. A 40-second vertical clip and a 12-minute landscape explainer have different budgets, so the same rule with the same gate produces the right density in both only if the gate is per-sentence rather than per-minute.
- Skipped entirely when the caption role is a full accessibility track with no emphasis layer ([[sub-caption-role-decision]]).

## How to recognise it in a reference video

You are reverse-engineering a rule, so work from the transcript and the frames together.

1. Sample every cue that contains a differently-treated word — 15–30 instances.
2. Write down each lifted word with its part of speech and its role in the sentence.
3. Look for the gate: is it one per sentence? Per cue? Per beat?
4. Write a candidate rule, then apply it to a section you did not sample and compare.

| Signal | Rule present | No rule |
|---|---|---|
| Part-of-speech distribution | Concentrated: 70 %+ nouns and numerals | Even spread across nouns, verbs, adjectives, adverbs |
| Intensifiers lifted | ~0 | Several — the clearest tell of "whatever felt important" |
| Per-sentence count | Almost always ≤1 | Two or three in one sentence |
| Emphasised share of words | 5–15 % | 25 %+ |
| Repeat behaviour | A term is lifted on first mention only | The same word lifted every time it occurs |
| Predictive test | Your candidate rule predicts ≥85 % of an unseen section | Below 70 % — there is no rule |
| Treatment count | One treatment carries emphasis | Colour on some, scale on others, weight on a third — three codes for one meaning |

The repeat behaviour test is the most diagnostic and the least noticed. A rule-driven design lifts a term the **first** time it is named and lets it be ordinary afterwards, because by then the viewer knows it. A feel-driven design lifts it every time, which is how a track ends up 30 % accented.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `rule_written` | required | — | In the design doc, before styling. |
| `gate` | 1 per sentence | 1 per sentence / cue / beat | A structural gate bounds density regardless of content. |
| `emphasised_share_of_words` | 8 % | 5–15 % | Above 15 % the mark stops marking. Count, do not estimate. |
| `events_per_minute` | 5 | 3–8 | Hard ceiling 8, consistent with [[sub-emphasis-caption-three-words]]. |
| `min_gap_between_events` | 2.0 s | 1.2–4.0 s | Below 1.2 s two marks read as a caption track starting. |
| `pos_whitelist` | noun, proper noun, numeral | — | Plus the unit attached to a numeral — `dB` goes with `−3`. |
| `pos_blacklist` | adverb, intensifier, verb, adjective | — | Intensifiers are the primary inflation source. |
| `first_mention_only` | yes | yes/no | Lift a term on first naming; leave subsequent mentions plain. |
| `words_per_event` | ≤3 | 1–3 | The source's own rule, verbatim: three words or fewer. |
| `never_split` | number + unit, first + last name | — | `−3 dB` is one emphasis unit, not two. |
| `treatments_used` | 1 | 1–2 | One treatment for emphasis. A second only for a genuinely different meaning. |
| `treatment` | accent colour + weight step | — | Colour plus a redundant non-colour cue, per [[sub-semantic-colour-assignment]]. |
| `simultaneous_marks` | 1 | 1 | Never two lifted words visible at once. |
| `reproducibility_threshold` | ≥85 % agreement | — | Two independent applications of the rule to the same page. |
| `hand_override_budget` | 0 | 0–2 per video | Every override is evidence the rule is wrong. Fix the rule. |

## Reproduction prompt

```
Derive the emphasis selection rule for {{PROJECT}} from {{TRANSCRIPT}}, then
apply it.

Step 1 — write the RULE, not the list. State it as a scannable test over the
transcript: parts of speech, semantic category, structural position. Include a
structural GATE — at most one emphasis per {{sentence}} — so density stays
bounded whatever the content does.

Start from this default and adapt it: lift (a) the term a section is named after,
on FIRST mention only; (b) any numeral with a unit the viewer might act on; (c)
the noun stating the payoff of the sentence. Never lift adverbs, intensifiers
("really", "massively"), verbs or adjectives. Intensifiers sound emphatic in the
audio, carry no retainable information, and are the single largest source of
emphasis inflation.

Step 2 — apply the rule MECHANICALLY across the whole transcript in one pass. Do
not skip a hit that feels unnecessary or add one that feels important. Emit every
hit with timecode, the lifted span (<=3 words, never splitting a number from its
unit), and which clause fired.

Step 3 — count. Emphasised share of words and events per minute. Targets: <=15%
and <=8/min. If either is over, TIGHTEN THE RULE and re-run step 2 from scratch.
Hand-pruning converts a rule back into a list and destroys the point.

Step 4 — assign exactly one treatment, with a redundant non-colour cue alongside
any hue.

Acceptance test: hand the rule and one unseen transcript page to a second
independent application. Agreement must be >=85%; below that, rewrite the rule
rather than averaging outputs. Confirm no sentence has two lifted spans and no
two events fall within 1.2s.
```

## Execution spec

The rule produces a list of `(start, end, span, rule_clause)` tuples against the word-level transcript. That is the same array the caption timing is built from — `npx hyperframes transcribe` emits word-level `{text, start, end}`, and the staged implementation inlines exactly that shape.

```js
// The transcript array is the single source for both timing and emphasis.
const script = [ { text: "minus", start: 12.340, end: 12.560 },
                 { text: "three", start: 12.560, end: 12.810 },
                 { text: "dB",    start: 12.810, end: 13.090 }, ... ];

// Emphasis spans are indices into it, produced by the rule, stored alongside.
const emphasis = [ { from: 41, to: 43, clause: "numeral+unit" } ];
```

Rendering requires a **per-word element model**: each word gets its own `<span>` at build time, and the timeline only toggles classes. The staged single-span `textContent` design cannot carry a marked-up sub-span, and the per-word model additionally fixes the known seek fragility — because text is set in `onStart` on a reused element, a backwards seek or a seek landing between lines does not necessarily restore the correct text.

```js
tl.set(`#w${i}`, { className: "+=emph" }, emphasisStart);
```

Further stack notes:

- **Toggle with `set`, not a tween.** Emphasis is a discrete state.
- **If the treatment includes a scale step**, that is a transform on the word span only, `power2.out`, and the surrounding line will reflow unless the span is `display:inline-block` — reflow on emphasis is a visible jitter across the whole cue. Cap the step at about 1.06 ([[motion-emphasis-scale-step]]).
- **`asr-keyword-glow`** is the named HyperFrames animation rule for keyword emphasis synced to ASR timestamps; cite it by name, do not quote code — the `rules/` directory is not staged.
- Record the rule and every hit in the **Emphasis map** table of `_templates/design-subtitles.md`. The `Rule` column is the reproducible artefact; the `Word / phrase` column is just the audit trail.

## Pairs with

- [[sub-over-emphasis-audit]] — the count that validates the rule
- [[sub-emphasis-caption-three-words]] — the three-word ceiling and the opportunity-cost argument
- [[sub-semantic-colour-assignment]] — the treatment the rule drives
- [[sub-red-strikethrough-negation]] — the negative mark, which is a separate rule
- [[sub-caption-role-decision]] — whether an emphasis layer exists at all
- [[sub-karaoke-active-word-highlight]] — emphasis inside a held phrase
- [[sub-cue-segmentation-three-word]] — cue boundaries constrain where a span can sit
- [[motion-emphasis-scale-step]] — the animated treatment
- [[motion-key-region-animate-in]] — the same "one thing at a time" discipline

## Failure modes

- **A word list instead of a rule.** Works for one video, transfers to nothing, and cannot be counted.
- **Hand-pruning the output.** The commonest way a rule quietly reverts to taste. If the count is over, the rule is wrong — fix the rule.
- **Lifting intensifiers.** "REALLY", "MASSIVE", "INSANE". They feel emphatic because the audio is emphatic. They carry nothing the viewer needs to retain and they double the density.
- **No structural gate.** A rule with no per-sentence cap produces four marks in one dense sentence and none in the next paragraph.
- **Lifting every mention of a term.** First mention teaches; the rest is noise.
- **Two marks visible at once.** Neither is a mark any more.
- **Three treatments for one meaning.** Colour here, scale there, weight elsewhere. The viewer cannot learn a code with three encodings.
- **Splitting a number from its unit.** `−3` lifted and `dB` plain reads as a different number.
- **Skipping the reproducibility check.** An underspecified rule looks like a rule right up until a second person applies it.
