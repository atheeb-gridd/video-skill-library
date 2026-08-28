---
id: sub-syntactic-line-breaking
title: Break the line on syntax, not on width — the break is a comprehension decision
skill: subtitles
type: caption-style
family: line-breaking
tags: [skill/subtitles, type/caption-style, family/line-breaking, engine/hyperframes, source/hyperframes, source/research, difficulty/high]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Line grouping — a fixed for loop, 5 words per line, text joined with spaces."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "white-space: nowrap + overflow: hidden + a 5-word grouping is a text-fit hazard."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://www.w3.org/WAI/media/av/captions/
  - https://www.w3.org/TR/WCAG22/
difficulty: high
detectable_from: video
---

# Break the line on syntax, not on width — the break is a comprehension decision

## What it is

Where a caption line breaks changes how fast it is understood. A break at a syntactic boundary lets the reader close one phrase before opening the next; a break in the middle of a phrase forces them to hold an incomplete structure across a line jump and resolve it afterwards. The cost is small per cue and enormous across a video, because it applies to every line the viewer reads.

Browsers break on width. Width is the wrong criterion — it is a *constraint*, not a decision. The correct process is: establish the width budget ([[sub-line-length-and-line-count]]), then choose the **best syntactic break that fits inside it**, which is almost never the last one that fits.

Netflix's timed-text guidance encodes the rule set precisely, and it transfers directly. Prefer to break:

- **after punctuation**
- **before a conjunction** (`and`, `but`, `so`, `because`)
- **before a preposition** (`in`, `on`, `with`, `to`, `for`)

Never break so as to separate:

- an **article from its noun** — `the / signal`
- an **adjective from its noun** — `low / frequency`
- a **first name from a last name**
- a **verb from its subject pronoun** — `he / said`
- a **prepositional verb from its preposition** — `look / at`
- a **verb from its auxiliary, reflexive pronoun, or negation** — `is / not`, `has / been`

The negation case is the one worth calling out, because it is the most damaging. Breaking `is / not ready` puts an affirmative-looking fragment on screen for a beat before the negation arrives. On a short cue that beat is a quarter of the cue's life, and the viewer reads the wrong meaning first.

The same logic governs **cue boundaries**, not just line breaks. A cue that ends mid-phrase and continues in the next cue has all the same problems plus a fade in between. The rules here apply to both; [[sub-cue-segmentation-three-word]] carries the cue-level version with its own never-split list.

One more principle beyond the Netflix set: **prefer the earlier legal break.** Given two legal breaks that both fit, take the one that puts more of the sentence's structure on the first line. A slightly short top line reads better than a maximally packed one, because the reader's eye returns to the left margin sooner.

## When to use it

- On every two-line cue. A one-line cue has no break, which is one more reason to prefer one line.
- Applied **after** the width budget is known and **before** timing is finalised, because a break decision can force a cue split, and a split changes durations.
- Re-run after any change to size, tracking, face or box width — all of them change which breaks fit.
- The rules are language-specific. The list above is for English and transfers well to romanised Hinglish with one important addition; see [[sub-romanised-hinglish-latin-face]].

## How to recognise it in a reference video

Read the two-line cues and classify each break. This is a judgement per cue, but the aggregate is a number.

| Signal | Measure | Reading |
|---|---|---|
| Legal breaks | % of two-line cues broken at a legal position | ≥90 % = syntax-driven. 40–70 % = width-driven with occasional luck. |
| Article/adjective splits | Count of `the / noun`, `low / frequency` | Any at all indicates browser wrapping is doing the breaking. |
| Negation splits | Count of `is / not`, `does / not`, `never / going` | The most damaging class. Should be zero. |
| Line balance | Longer / shorter line | 1.0–1.6 balanced. A syntax-driven break is often *less* balanced than a width-driven one, and that is correct. |
| Top line fullness | Top line width / max width | 100 % on most cues = width-greedy. 75–95 % with variation = syntax-driven. |
| Break-before-conjunction | Count breaks immediately before `and`/`but`/`so` | Present = the rule set is in use |
| Break-after-punctuation | Count breaks immediately after `,` `.` `?` | Present = the rule set is in use |
| Cue-boundary quality | Apply the same test at cue ends | Mid-phrase cue ends are the same defect with a fade added |

The **top line fullness** metric is the fastest diagnostic and the least obvious. A width-driven design produces top lines that are all almost exactly at the maximum, because that is what the algorithm optimises. A syntax-driven design produces varied top-line lengths, because the break lands where the grammar says. Uniformly full top lines is the signature of nobody having made a decision.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `break_criterion` | syntax, constrained by width | syntax | Width is a filter over legal breaks, never the selector. |
| `prefer_break_after` | `. ? ! , ; :` | — | Punctuation first, always. |
| `prefer_break_before` | conjunctions, prepositions | — | `and but so because` / `in on with to for of at`. |
| `never_split` | article+noun, adjective+noun, first+last name, verb+subject pronoun, prepositional verb+preposition, verb+auxiliary, verb+reflexive, **verb+negation** | — | The Netflix set. Negation is the most damaging. |
| `also_never_split` | number+unit, hyphenated compound, proper-noun phrase | — | `−3 / dB`, `lower / third`, `Essential / Sound`. |
| `earlier_break_preference` | on | on / off | Given two legal fitting breaks, take the earlier one. |
| `balance_target` | ≤1.6 | 1.0–2.0 | A soft preference. Syntax outranks balance. |
| `balance_is_soft` | yes | — | Never move a break to a worse syntactic position to improve balance. |
| `preferred_longer_line` | top | top / equal | The eye returns to the left margin sooner. |
| `legal_break_rate` | ≥90 % | ≥85 % | Of all two-line cues. |
| `negation_split_count` | 0 | 0 | Hard zero. |
| `fallback_when_no_legal_break_fits` | split the cue | split / accept | If no legal break fits the width, the cue is too long — split it in time, do not break it badly. |
| `applies_to_cue_boundaries` | yes | — | The same rules govern where one cue ends and the next begins. |
| `browser_wrapping` | disabled | — | Insert explicit breaks; never let `white-space: normal` choose. |

## Reproduction prompt

```
Break every two-line caption cue in {{PROJECT}} on syntax, within the width
budget of {{CHARS}} characters per line.

Per cue: enumerate every break that FITS the budget, score each by the rules
below, take the highest scorer. Width filters candidates; it never chooses.

Prefer, in descending order: (1) immediately after . ? ! , ; : (2) immediately
before a conjunction (and, but, so, because, or) (3) immediately before a
preposition (in, on, with, to, for, of, at, from) (4) any other clause boundary.

Never break so as to separate: an article from its noun; an adjective from its
noun; a first name from a last name; a verb from its subject pronoun; a
prepositional verb from its preposition; a verb from its auxiliary, reflexive
pronoun, or NEGATION. Also never separate a number from its unit, a hyphenated
compound, or a multi-word proper noun.

The negation rule matters most: "is / not ready" puts an affirmative fragment on
screen for a quarter of the cue's life and the viewer reads it wrong first.

Given two legal breaks that both fit, take the EARLIER one. Line balance is a
soft preference (target <=1.6); never move a break to a worse syntactic position
to improve it.

If NO legal break fits, split the cue in time, then re-check both halves against
the minimum event duration and the rate cap. Emit explicit break positions; do
not rely on browser wrapping, which optimises width.

Acceptance test: >=90% of breaks at legal positions, ZERO splitting a negation,
article+noun, adjective+noun or number+unit. Then check top-line fullness: if
every top line is within 3% of maximum width, the breaks are still width-driven.
```

## Execution spec

Breaks are explicit, which means the grouped line text carries them and `white-space` never decides:

```js
// Break positions come from the rule, not from the browser.
// Emit an explicit <br>, or two spans, or a \n with white-space: pre-line.
const lineHtml = `${topLine}<br>${bottomLine}`;
```

Three stack-specific consequences:

- **This forces `innerHTML` or a per-line element model.** The staged implementation writes `textContent`, which renders `<br>` as literal text. The safe options are (a) `white-space: pre-line` with a `\n` in `textContent` — which preserves the verbatim string and is the cheapest fix — or (b) two child spans, one per line, which is more controllable and also seek-robust. Option (a) is worth knowing because it is the only way to break a line while keeping `textContent` and therefore keeping the verbatim record intact, which matters for [[sub-orthography-protection-no-autocorrect]].

```css
[data-composition-id="captions"] .caption-text {
  white-space: pre-line;   /* honours \n, still collapses runs of spaces */
  overflow: visible;
}
```

- **Measure candidate breaks after `document.fonts.ready`**, for the same reason as the width check: fallback metrics do not match render metrics.
- **A forced cue split re-opens timing.** The two halves must each clear the minimum event duration (Netflix's floor is 5/6 s) and the reading-rate cap, and the split point should sit at a clause boundary too. Loop back through [[sub-cue-segmentation-three-word]].
- **Do not let `hyphens: auto` anywhere near a caption.** Hyphenating a word across a caption line break is never correct, and it is catastrophic for romanised Hinglish, where the hyphenation dictionary has no idea what the words are. Set `hyphens: none` explicitly.

## Pairs with

- [[sub-line-length-and-line-count]] — the width budget that filters candidates
- [[sub-cue-segmentation-three-word]] — the cue-level version of the same rules
- [[sub-hinglish-reading-rate]] — segmenting romanised Hinglish, where dictionaries fail
- [[sub-romanised-hinglish-latin-face]] — additional never-split cases for code-mixed text
- [[sub-orthography-protection-no-autocorrect]] — why `pre-line` and `textContent` is the safe path
- [[sub-tracking-and-caption-line-height]] — tracking changes which breaks fit
- [[sub-verbatim-misspeak-correction]] — verbatim text constrains what can be rearranged
- [[cut-outpoint-inpoint-alignment]] — the same "boundary is a decision" discipline in the edit

## Failure modes

- **Letting the browser wrap.** It optimises width. Width is the constraint, not the goal, and the result splits articles from nouns about a third of the time.
- **Splitting a negation.** `is / not ready`. The viewer reads the affirmative first. The most damaging single break error and the easiest to check for.
- **Splitting a number from its unit.** `−3 / dB` reads as a bare number for a beat.
- **Optimising balance over syntax.** A perfectly balanced cue broken mid-phrase is worse than a lopsided one broken cleanly.
- **Uniformly full top lines.** The signature of nobody deciding. Check the fullness distribution, not just the legality rate.
- **`hyphens: auto`.** Never correct in a caption, and actively destructive on non-dictionary tokens.
- **Breaking badly to avoid a cue split.** If no legal break fits, the cue is too long. Split it in time.
- **Applying line rules and ignoring cue boundaries.** A cue that ends mid-phrase has the same defect with a fade added to it.
- **`<br>` written into `textContent`.** Renders as the literal characters. Use `pre-line` with `\n`, or real elements.
