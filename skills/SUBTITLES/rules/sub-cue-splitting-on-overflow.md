---
id: sub-cue-splitting-on-overflow
title: Split the cue that breaks a cap — never shrink the type and never rewrite the words
skill: subtitles
type: caption-timing
family: cue-limits
tags: [skill/subtitles, type/caption-timing, family/cue-limits, engine/hyperframes, source/research, source/hyperframes, difficulty/high]
source:
  - video: "research"
    timestamp: n/a
    quote: "Netflix English Timed Text Style Guide: 'Maximum two lines', '42 characters per line', and line breaks 'after punctuation marks, before conjunctions, before prepositions'."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "`white-space: nowrap` + `overflow: hidden` + a 5-word grouping is a text-fit hazard. A long 5-word line silently clips rather than wrapping."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
difficulty: high
detectable_from: transcript+video
---

# Split the cue that breaks a cap — never shrink the type and never rewrite the words

## What it is

A cue can fail three caps: **reading rate** (over 17–20 CPS), **line length** (over 42 characters on a line, or over two lines), and **duration ceiling** (over 5–7 s). There are only four possible responses, and they have a strict priority order:

1. **Split the cue** into two cues at the best syntactic point inside it.
2. **Extend the cue's end** into the following gap, if there is one and the next cue's word onset allows it.
3. **Re-break the lines** — the cue is legal by rate but its two lines are unbalanced, so it only failed the length cap.
4. **Flag for a human.**

And there are three responses that look like fixes and are not: shrinking the type, rewording the speech, and letting the renderer clip. All three trade a measurable failure for an invisible one.

**Splitting is the primary move because it is the only one that adds display time.** A 46-character cue at 2.0 s is 23 CPS. Split into 24 and 22 characters over 1.0 s each, it is still 23 CPS — *splitting alone does not lower the rate*. This is the trap. Splitting lowers the rate only when the split **also buys time**: from the following gap, from a tail hold, or from a neighbouring cue that has slack. So the real algorithm is split-then-redistribute, and if there is no time to redistribute, the cue genuinely cannot be fixed by timing and the flag is the correct output.

**Where to split.** The same priority as phrase assembly: at terminal punctuation, then at a comma/colon/semicolon, then before a conjunction or preposition, then at the last legal point that keeps both halves under both caps — never inside a never-split pair (number + unit, first name + surname, article + noun, adjective + noun, hyphenated compound, negation + verb).

**Line length is a rendered measurement, not a string length.** 42 characters is a proxy that assumes a proportional face at a known size. What actually matters is the rendered box against the safe width, and in the reference implementation the caption text is set with `white-space: nowrap` and `overflow: hidden`, which means an over-long line **silently clips** rather than wrapping. Validate the box, not the count.

## When to use it

- As the standard repair whenever [[sub-reading-speed-hard-cap]] or [[sub-line-length-and-line-count]] fails a cue.
- After every merge, snap or duration repair, since each of those can push a cue over a cap it previously passed.
- On imported cue sheets from a client or a third-party captioner, which routinely arrive over cap.
- **Do not** use it on a chained word-level track, where cue boundaries are locked to word onsets — there, an over-cap cue means the *model* is wrong, not the cue.

## How to recognise it in a reference video

- **Longest-line measurement.** Sample 20 cues, count characters per line, and take the max. That number is the creator's real line cap; it is usually 30–42 for horizontal and **20–28 for vertical** short-form, because the safe width is narrower.
- **Rendered width as a percentage of frame width.** More portable than characters. Well-behaved caption blocks occupy **60–85 % of frame width**; anything at 95 %+ is at risk of clipping on a device with a different safe area.
- **Split evidence.** Find a long sentence in the transcript and see where the cue boundary fell. A syntax-driven split lands before a conjunction or after a comma; a width-driven split lands mid-phrase and is visible as an awkward read.
- **Clipping.** Look for a cue whose last word is cut off at the box edge, or an ellipsis that is not in the transcript. Both mean the fit failed and nothing caught it.
- **Balance.** In a two-line cue, measure both lines. A 41/6 split is a generator that filled line one and dumped the remainder; a good break is within about 30 % of balanced.
- **Rate after split.** Compute CPS for both halves of a split pair. If both are still over cap, the split bought nothing and the track has a systemic timing problem.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `split_priority` | syntax | syntax / width | Width-only splitting produces legal, unreadable cues. |
| `chars_per_line_h` | 42 | 32–42 | Netflix's cap for horizontal delivery. |
| `chars_per_line_v` | 24 | 18–28 | Vertical short-form; derived from safe width, not from a standard. |
| `lines_max` | 2 | 1–2 | Three lines occlude picture and break the caption zone. |
| `line_balance` | ±30 % | ±20–40 % | Difference between the two lines' lengths. |
| `box_width_max` | 85 % frame width | 70–90 % | The portable form of the character cap. |
| `redistribute_from` | following gap | gap / tail / neighbour | Splitting only helps if time comes with it. |
| `max_borrow` | 15 frames | 6–15 f | DCMP describes borrowing 15 frames before or after the audio as hardly noticeable. |
| `never_split` | see prompt | — | number+unit, name pairs, article+noun, adjective+noun, hyphenates, negations. |
| `split_iterations` | 2 | 1–3 | If two passes cannot fix a cue, flag it. |
| `forbidden_fixes` | shrink type, reword, clip | — | All three are failures dressed as fixes. |
| `validate` | rendered box | box / string | Measure `getBoundingClientRect`, not `text.length`. |

## Reproduction prompt

```
Repair every over-cap cue in the cue sheet for {{PROJECT}}.

For each cue failing {{CPS_CAP}} = 17 characters per second, {{LINE_CAP}} =
42 characters per line, {{LINES}} = 2 lines, or {{MAX_DUR}} = 5.0s, apply in
order and stop at the first that succeeds:

1. RE-BREAK. If the cue passes the rate cap and fails only line length or
   balance, re-break the lines at the best syntactic point so both lines are
   within 30% of each other.
2. SPLIT + REDISTRIBUTE. Split at the best syntactic point - terminal
   punctuation, then comma/colon/semicolon, then before a conjunction or
   preposition - never inside a never-split pair (number+unit, name pairs,
   article or adjective + noun, hyphenates, negation+verb). Then buy time:
   take up to {{BORROW}} = 15 frames from each adjacent gap, never pushing a
   cue start more than 2 frames before its first word onset and never leaving
   a gap in the forbidden 1-frame band.
3. EXTEND into the following gap up to the borrow limit.
4. FLAG with index, text, duration, CPS and the caps failed.

Never shrink the type, reword, or let the renderer clip. Re-run all caps
after every repair.

ACCEPTANCE TEST: every cue passes the rate, line and duration caps or appears
in the exceptions list with a reason; no cue text differs by one character
from the transcript; no split falls inside a never-split pair; and the
rendered caption box occupies no more than {{BOX_MAX}} = 85% of frame
width.
```

## Execution spec

The repair happens on the cue array before it is inlined. The **validation**, though, has to happen against the rendered composition, because character counts are a proxy and the real constraint is the box.

`hyperframes check` runs a layout audit that measures `getBoundingClientRect` at sampled timestamps. Three facts about it bind here:

- **`overflow: hidden` hides the clip visually but does not suppress the finding** — so a clipped caption still reports, which is the behaviour you want. Do not reach for `data-layout-allow-overflow` to silence it: its blast radius is the whole subtree and it also suppresses `text-clipping`, `content-cramped-container` and `foreground-over-panel`. For an intentional lower-third the narrower opt-out is `data-layout-allow-caption-zone`, which does not suppress overflow at all.
- **A lint error switches off the layout and contrast audits entirely**, after which `check` reports "0 sample(s)" and "0/0 text checks" — which reads like a clean file and means nothing ran. Always confirm the sample count is non-zero before trusting a pass.
- The reference `.caption-text` sets `white-space: nowrap; overflow: hidden; max-width: 1600px`. For any track that allows two lines, remove `nowrap`. If you keep two lines, `text-wrap: balance` gives a balanced break for free (Chromium balances up to 6 lines, Firefox up to 10) — but do not rely on it for the *cue* split, only for the *line* break.

Sizing interacts: the character cap is a function of the type size, and the type size is fixed by the frame-height percentage rule and the legibility floor. That is why shrinking the type is not available as a fix — the size is set by [[sub-size-as-frame-height-percentage]] and the caption's job, not by the longest line in the sheet.

## Pairs with
[[sub-reading-speed-hard-cap]] · [[sub-line-length-and-line-count]] · [[sub-syntactic-line-breaking]] · [[sub-phrase-cue-assembly]] · [[sub-cue-duration-floor-and-ceiling]] · [[sub-size-as-frame-height-percentage]] · [[sub-batch-generation-and-qc]] · [[sub-safe-area-and-caption-zone]]

## Failure modes
- **Splitting without redistributing time.** Two cues at the same CPS as the one they replaced. The most common false fix. Correction: borrow time, or flag.
- **Shrinking the type to fit.** Breaks the legibility floor and the identity, and it will be inconsistent with the rest of the track. Correction: split.
- **Rewording to fit.** A correctness bug. Captions match the transcript. Correction: split or flag.
- **Trusting `text.length`.** A 40-character line of capitals in a wide face overflows where 46 characters of lowercase would not. Correction: validate the rendered box.
- **Silencing the audit with `data-layout-allow-overflow`.** Suppresses three other checks across the whole subtree. Correction: fix the fit; use `data-layout-allow-caption-zone` only for a deliberate lower-third.
- **Reading a green `check` after a lint error.** "0 samples" is not a pass. Correction: assert the sample count.
- **Repairing in one pass.** A split changes gaps, which changes snapping, which changes durations, which changes rate. Correction: iterate and re-check all caps.
