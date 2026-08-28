---
id: sub-phrase-cue-assembly
title: Assemble phrase cues on clause boundaries, then hand the timing back to the first and last word
skill: subtitles
type: caption-timing
family: timing-model
tags: [skill/subtitles, type/caption-timing, family/timing-model, engine/hyperframes, source/hyperframes, source/research, difficulty/high]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Line grouping — a fixed `for` loop, 5 words per line, `text` joined with spaces, `start` = first word's start, `end` = last word's end."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
difficulty: high
detectable_from: transcript+video
---

# Assemble phrase cues on clause boundaries, then hand the timing back to the first and last word

## What it is

Phrase-level generation is a grouping problem with a timing tail. Group the word array into clause-sized cues, then derive each cue's timing from the words it actually contains: `cue.start = first_word.start - pad_head`, `cue.end = last_word.end + tail_hold`. The grouping decision comes first and the timing follows it — never the reverse, and never a fixed word count.

The reference `compositions/captions.html` groups with **a fixed `for` loop at 5 words per line**. That is the thing to replace. A fixed count splits "120 / BPM", "Martin / Scorsese" and "the / cut" on a schedule, and every such split is visible to a reader because the eye parses a caption as a syntactic unit, not as a five-word window.

The grouping rule that works is the broadcast one, in priority order:

1. Close at terminal punctuation (`.` `?` `!`).
2. Otherwise close at a clause boundary — after a comma, semicolon or colon.
3. Otherwise close **before** a conjunction or a preposition (Netflix's own line-break principles: "after punctuation marks, before conjunctions, before prepositions").
4. Otherwise close at the last legal point that keeps the cue under both the character cap and the reading-rate cap.

Then two limits bind the result: **42 characters per line, maximum two lines** and a reading rate at or under the cap. A cue that fails either is split by [[sub-cue-splitting-on-overflow]], not shrunk and not rewritten.

The tail hold is the part everyone forgets. A cue that ends exactly on `last_word.end` disappears the instant the speaker stops, which is roughly 300 ms before a viewer has finished the last fixation on it. A 0.4–0.8 s hold past the audio costs nothing and measurably reduces re-reading.

## When to use it

- Any track whose model is **phrase-level**, and the **card stream** of a hybrid track.
- Every sidecar deliverable — SRT, VTT and TTML players expect clause-sized cues.
- Long-form horizontal video, and anything where the viewer is also reading on-screen graphics and needs read-ahead time.
- **Do not** use it as the highlight stream of a hybrid track; that is [[sub-word-level-cue-generation]].
- **Do not** keep the reference file's 5-word loop "for now". It ships.

## How to recognise it in a reference video

- **Words per cue.** Sample 20 cues. Phrase cues show **5–14 words** with a mode around 7–9, and a *variable* count — a flat count of exactly 5 or 7 everywhere is a fixed-loop signature and is itself a finding.
- **Boundary vs. syntax.** Line the cue sheet up against the transcript. Real phrase grouping never splits an article from its noun, a number from its unit, a name pair, or a preposition from its object. A fixed loop does all four within 30 seconds of any video.
- **Cue duration.** **1.2–5.0 s**, mode near 2.0–2.8 s. Netflix's floor is 5/6 s (20 frames at 24 fps) and its ceiling is 7 s per event; a real phrase track rarely reaches either.
- **Tail past the audio.** Find the frame where the speaker's last word ends acoustically and count frames until the plate clears. **12–24 frames (0.4–0.8 s)** is a deliberate hold. Zero is a generator that used `last_word.end` raw.
- **Reading rate per cue.** Characters ÷ duration should be **≤17–20 CPS**. Compute it per cue, not as a mean — a mean hides the three cues that fail.
- **Line count and length.** Two lines maximum, ≤42 characters each. Count the longest line in the reference; it tells you the cap the creator actually used.
- **Gap between cues.** Phrase tracks blank the plate for **2–8 frames** between cues; see [[sub-inter-cue-gap-and-chaining]].

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `group_rule` | syntax | syntax / fixed-N | Fixed-N is the reference file's behaviour and is always wrong. |
| `chars_per_line` | 42 | 32–42 | Netflix's cap. Below 32 the cue count doubles for no gain. |
| `lines_max` | 2 | 1–2 | Three lines occlude the picture. |
| `words_per_cue` | 8 | 5–14 | Derived from the syntax rule, never set directly. |
| `pad_head` | 0.06 s (2 f @30) | 0–0.12 s | Cue up as the phrase starts. |
| `tail_hold` | 0.55 s | 0.35–0.90 s | Held past `last_word.end`. The single cheapest comprehension win. |
| `min_cue_duration` | 0.83 s | 0.70–1.20 s | Netflix minimum event, 20 frames at 24 fps. |
| `max_cue_duration` | 5.0 s | 1.2–7.0 s | Netflix's hard ceiling is 7 s; past 5 s a held cue reads as a stall. |
| `reading_rate_cap` | 17 CPS | 12–20 CPS | 20 adult / 17 children (Netflix). DCMP: 130/140/160 wpm. |
| `merge_below` | 1.0 s | 0.83–1.5 s | Merge a short cue forward if the merge stays under both caps. |
| `never_split` | see prompt | — | number+unit, name pairs, article+noun, adjective+noun, hyphenates, negations. |
| `orphan_word_policy` | merge back | merge / keep | A one-word trailing cue almost always belongs to the previous cue. |

## Reproduction prompt

```
Assemble phrase-level caption cues for {{PROJECT}} from the word-level
transcript ({text,start,end} in seconds).

PASS 1 - GROUP. Close a cue at, in priority order: (a) terminal punctuation
. ? ! ; (b) a comma, colon or semicolon; (c) immediately BEFORE a conjunction
or preposition; (d) the last legal point that keeps the cue within
{{CHARS_PER_LINE}}=42 chars x {{LINES}}=2 lines. NEVER split number+unit,
name pairs, article or adjective + noun, hyphenates, or negation+verb. Text
is verbatim.

PASS 2 - TIME. cue.start = first word's start - {{PAD_HEAD}} (0.06s);
cue.end = last word's end + {{TAIL_HOLD}} (0.55s), clamped so it never
reaches the next cue's start minus the minimum gap.

PASS 3 - REPAIR. (a) Any cue under {{MIN}} (0.83s) merges forward if the
merged cue stays under both caps, else extends to 0.83s. (b) Any cue over
{{MAX}} (5.0s) has its tail trimmed, not its text. (c) Any cue over
{{CPS}}=17 characters per second is split at the best syntactic point inside
it. (d) A trailing one-word cue merges back into its predecessor.

ACCEPTANCE TEST: every cue is <=2 lines of <=42 chars, between 0.83s and
5.0s, and at or under 17 CPS; cue starts strictly increase with no overlap;
every transcript word appears exactly once, in order, spelled exactly as
transcribed; and no cue boundary falls inside a never-split pair.
```

## Execution spec

Phrase cues are the one model the reference implementation supports as written. `compositions/captions.html` builds lines, then runs one four-tween cycle per line on a single reused box:

```js
tl.set(box, { visibility: "visible" }, line.start);
tl.to(box, { opacity: 1, duration: 0.1, ease: "power2.out",
             onStart: () => { textEl.textContent = line.text; } }, line.start);
tl.to(box, { opacity: 0, duration: 0.1, ease: "power2.in" }, line.end);
tl.set(box, { opacity: 0, visibility: "hidden" }, line.end + 0.1);
```

Keep the shape, replace the grouping loop, and know the cost: the text is written in `onStart`, which fires on **forward entry only**, so a backward seek in Studio can leave the wrong words on screen. The seek-robust alternative is one element per cue with its own opacity envelope — more DOM, no `onStart`. Choose per project; for a long video the single-box form is worth keeping and the seek fragility is a preview-only artefact of authoring.

Other binding points:

- The trailing hard kill at `line.end + 0.1` is legal only because `#caption-box` is **not** the clip element. Never do this on a `.clip`.
- `.caption-text` in the reference sets `white-space: nowrap` with `overflow: hidden`. At two lines of 42 characters that silently clips. Remove `nowrap` for a phrase track, or the layout audit will report an overflow finding that `overflow: hidden` hides visually but does not suppress.
- Caption sizing is video sizing, not web sizing: 48 px at 1080p sits in the full-screen band; in-feed wants ≥32 px body and larger. Express as a percentage of frame height — see [[sub-size-as-frame-height-percentage]].
- All times are seconds, three decimals, inlined. `data-duration` on the root is read once at compile time; the reference file's root is 10 s while its transcript runs to 16.02 s, and per the timing model the extra is simply cut off. Set the root duration from the last cue's end, plus the tail.

## Pairs with
[[sub-timing-model-selection]] · [[sub-syntactic-line-breaking]] · [[sub-line-length-and-line-count]] · [[sub-cue-splitting-on-overflow]] · [[sub-reading-speed-hard-cap]] · [[sub-cue-duration-floor-and-ceiling]] · [[sub-inter-cue-gap-and-chaining]] · [[sub-karaoke-active-word-highlight]] · [[sub-sidecar-timing-fidelity]] · [[cut-outpoint-inpoint-alignment]]

## Failure modes
- **The fixed 5-word loop.** Inherited straight from the reference file. Splits names, numbers and articles on a schedule. Correction: the syntax priority order.
- **No tail hold.** The cue vanishes on the last phoneme, cutting the final fixation short. Correction: 0.4–0.8 s past `last_word.end`.
- **Tail hold that eats the next cue.** Clamp the hold against the next cue's start minus the minimum gap, or cues overlap and the plate double-draws.
- **Mean reading rate instead of per-cue.** A 14 CPS mean can hide three cues at 26 CPS, and those three are the ones the viewer notices. Correction: per-cue check, hard fail.
- **Splitting to fit the character cap without checking syntax.** Produces a legal cue that reads as gibberish. Correction: split at the best syntactic point inside the cue, then re-check the cap.
- **`white-space: nowrap` inherited into a two-line track.** Long cues clip invisibly. Correction: remove it and validate the rendered box, not the string.
- **Cues generated from a sentence-level ASR array.** Sentence timings are coarse and their boundaries are guesses; always group from the word array.
