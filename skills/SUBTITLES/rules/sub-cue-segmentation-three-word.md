---
id: sub-cue-segmentation-three-word
title: Segment the transcript into three-word cards, then repair the timing
skill: subtitles
type: caption-timing
family: cue-segmentation
tags: [skill/subtitles, type/caption-timing, family/cue-segmentation, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:20"
    quote: "Also keep it to three words or fewer, since that makes them easier to read."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://developer.mozilla.org/en-US/docs/Web/CSS/text-wrap-style
  - https://aegisub.org/docs/latest/ass_tags/
difficulty: high
detectable_from: transcript+video
---

# Segment the transcript into three-word cards, then repair the timing

## What it is
A three-word ceiling changes the whole authoring problem. Broadcast subtitling is a **line-breaking** problem — fit up to 42 characters on a line, two lines per event, break before conjunctions and prepositions, keep articles with their nouns. At three words or fewer none of that binds: a three-word card is roughly 12–22 characters, so it never wraps. What replaces it is a **segmentation** problem over the word-level transcript: where do the card boundaries fall, and what do you do about the cards that come out too short to read?

The mechanics are two passes. Pass one groups words into cards of one to three words on linguistic boundaries. Pass two repairs the timing, because raw word timings produce cards of 180 ms on runs of short function words, which flickers. The repair is the interesting half, and it has one governing insight: the broadcast minimum-duration rule (Netflix: 5/6 of a second per event) exists to stop a caption object **appearing and disappearing** too fast. If cards chain with no blank between them, the box never disappears — only its text swaps — so a chained card can run far shorter than an isolated one. Chained mode and isolated mode therefore get different floors.

## When to use it
- Any **full track** where the profile calls for word-level or near-word-level cards (the short-form register: one to three words, large, centred, chained). The role is decided first in [[sub-caption-role-decision]].
- Any **emphasis layer** — its chunks obey the same three-word cap and the same never-split rules, just with 2 s of air between events instead of chaining.
- Whenever a reference video shows small chunks covering all the speech. That is a karaoke/chained track, not emphasis, and it needs this note plus [[sub-karaoke-active-word-highlight]].
- **Do not** use three-word cards when the delivery is a genuine accessibility subtitle for a large screen or a broadcast-style deliverable — there, use two lines up to 42 characters and the standard break rules, because the reader is scanning ahead and three-word cards deny them that.
- **Switch away from it** when sustained speech exceeds ~200 wpm. Chained cards inherit the speaker's rate by construction, so at very fast delivery the viewer cannot finish a card before it swaps. Above that threshold move to phrase cards with an active-word highlight.

## How to recognise it in a reference video
- **Words per card.** Sample 20 caption events across the video and count. A three-word ceiling shows a distribution of **1–3 with a mode at 2–3** and no event above 3. A broadcast track shows 5–9 words per line.
- **Card duration.** Measure in frames from text-swap to text-swap. Chained short-form cards run **9–45 frames (0.30–1.50 s)** at 30fps with a mode near 0.6–0.9 s. Any card under 9 frames is a flicker defect, and it is visible: the eye reads it as a stutter, not as text.
- **Gap between cards.** In chained mode the box **never** disappears between cards within a sentence — hold a frame at the boundary and the plate is still there. If the plate blinks off for 1–3 frames between every card, the segmentation was done without a repair pass.
- **Card boundaries against the transcript.** Line up the cue sheet with the word timings. A properly segmented track never splits a number from its unit ("120 BPM"), a first name from a surname, an article from its noun, or a hyphenated compound. If it does, the segmentation was a fixed *N*-words-per-card loop, which is what the reference `captions.html` does with 5.
- **Sentence-end behaviour.** Look for a clear gap of **4–12 frames** where the speaker's sentence ends. A track that chains straight through full stops reads as one endless sentence.
- **Reading rate.** Sum on-screen characters, divide by seconds. Chained short-form frequently sits at **25–35 CPS**, well above the 20 CPS broadcast cap — legitimate only because the viewer is also hearing the words. If the deliverable is muted-first, recompute against 17 CPS and expect to fail.
- **Punch-in correlation.** Cards that reset exactly on a picture cut indicate the segmentation respected cut boundaries; cards that ride through indicate it did not. Log which, it is a profile parameter.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `max_words_per_card` | 3 | 1–3 | Source rule, verbatim. A fourth word turns a mark into a sentence fragment. |
| `target_words_per_card` | 2.4 | 2.0–3.0 | Mean across the track. Below 2.0 the swap rate gets tiring. |
| `min_card_duration_chained` | 0.30 s (9 f) | 0.25–0.45 s | Floor for a card whose neighbours touch it. Below ~0.25 s the swap is subliminal. |
| `min_card_duration_isolated` | 0.83 s (25 f) | 0.70–1.20 s | Netflix minimum event duration is 5/6 s; use it whenever the box fades in and out. |
| `max_card_duration` | 3.0 s | 1.5–7.0 s | Netflix caps an event at 7 s; a 3-word card held 3 s already reads as a stall — extend the previous card instead. |
| `chain_gap` | 0 s | 0–0.07 s | Within a sentence, `card[n+1].start == card[n].end`. Any positive gap under 2 frames is a blink. |
| `sentence_gap` | 0.20 s (6 f) | 0.13–0.40 s | At `.` `?` `!` and at hard picture cuts if the profile breaks on cuts. |
| `reading_rate_cap_sound_on` | 30 CPS | 25–35 CPS | Only valid because the audio carries the meaning. |
| `reading_rate_cap_muted` | 17 CPS | 15–20 CPS | Netflix: 20 CPS adult, 17 children. DCMP: 130–160 wpm. Binding for a muted-first deliverable. |
| `speech_rate_switch_point` | 200 wpm | 180–220 wpm | Above this, abandon chained 3-word cards for phrase + active word. |
| `never_split` | see prompt | — | number+unit, name pairs, article+noun, adjective+noun, hyphenates, negations ("not ready"). |
| `break_bonus_after` | `. ? ! , ;` | — | Prefer a card boundary immediately after punctuation, then before a conjunction or preposition. |
| `cut_boundary_policy` | ride through | ride / reset | Resetting on every cut looks tidy but costs you the chain; decide once per profile. |
| `pad_head` | 0.04 s (1 f) | 0–0.07 s | Optional lead so the card is up as the word starts, never after. |

## Reproduction prompt

```
Build the caption cue sheet for {{IN}}-{{OUT}} from the word-level transcript
(entries of {text, start, end} in seconds). Two passes, in this order.

PASS 1 - SEGMENT. Walk the words in order, emitting cards of at most 3 words.
Close a card immediately after a word ending in . ? ! , or ; . Otherwise
prefer to close before a conjunction or a preposition. NEVER split: a number
from its unit ("120 BPM"), a first name from a surname, an article or
adjective from its noun, a hyphenated compound, or a negation from its verb.
Text is verbatim from the transcript - no rewording, no punctuation invented.

PASS 2 - REPAIR TIMING. card.start = first word's start (minus {{PAD_HEAD}}=
0.04s), card.end = last word's end. Then:
 a) Within a sentence, set card[n].end = card[n+1].start so the box never
    blinks. At sentence ends leave a 0.20s gap.
 b) Any chained card shorter than 0.30s: merge it into the neighbour with the
    smaller word count, provided the merge stays <=3 words. If both neighbours
    are full, extend the card to 0.30s and pull the next card's start.
 c) Any isolated card (fading in and out) shorter than 0.83s: extend the end.
 d) Any card longer than 3.0s: extend the previous card into it instead of
    holding a stale one.
 e) Recompute characters-per-second per card. If the deliverable is
    muted-first, no card may exceed 17 CPS - split its words differently or
    hold it longer.

ACCEPTANCE TEST: no card exceeds 3 words; no chained card is under 9 frames at
30fps; card starts are monotonic with no overlaps; every card's text appears
verbatim in the transcript in the same order; and stepping frame by frame
across a sentence, the caption plate never disappears between cards.
```

## Execution spec

**HyperFrames.** Word timings come from `npx hyperframes transcribe <file>` (word-level; Parakeet is the documented default but is an Apple-silicon MLX path, so on this linux ARM64 host expect the whisper.cpp fallback). Nothing reads that file at render time — the cue array is **inlined into the composition**, exactly as `compositions/captions.html` inlines its 46-entry `script` array. The reference file then groups with a fixed `for` loop at 5 words per line; replace that loop with the two passes above.

The reference file's per-line timeline is four tweens on a single reused box:

```js
tl.set(box, { visibility: "visible" }, line.start);
tl.to(box, { opacity: 1, duration: 0.1, ease: "power2.out",
             onStart: () => { textEl.textContent = line.text; } }, line.start);
tl.to(box, { opacity: 0, duration: 0.1, ease: "power2.in" }, line.end);
tl.set(box, { opacity: 0, visibility: "hidden" }, line.end + 0.1);
```

For a **chained** track that shape is wrong twice over. It fades out and back in between every card — the blink this note is built to remove — and the text is written in `onStart`, which fires on forward entry only, so a backward seek can leave the wrong words on screen. Author instead one element per card, all inside one non-clip wrapper, each with its own opacity envelope:

```html
<div class="clip" data-start="0" data-duration="{{DURATION}}" data-track-index="6">
  <div class="cap-stack">
    <span class="cap-card" id="cap-0017">only three</span>
    <span class="cap-card" id="cap-0018">words</span>
  </div>
</div>
```

```js
// chained pair: card n hands straight over to card n+1
tl.set("#cap-0017", { autoAlpha: 1 }, 12.40);
tl.set("#cap-0017", { autoAlpha: 0 }, 13.06);
tl.set("#cap-0018", { autoAlpha: 1 }, 13.06);
tl.to("#cap-0018", { autoAlpha: 0, duration: 0.10, ease: "power2.in" }, 13.92);
```

Binding contract points:
- **Zero-duration `tl.set()` on a non-clip element** is the legal way to hard-swap; the framework owns clip visibility and lint rejects `display`/`visibility` writes on a `.clip`. The reference file's hard kill is legal only because `#caption-box` is not the clip.
- **Chained swaps must be `set`, not `to`.** Two 0.1 s crossfading cards produce a legible double-exposure for 3 frames.
- Only the **first card in** and the **last card out** of a sentence get the 0.1 s `power2.out` / `power2.in` fade. Caption fades belong to the gentle eases, not the `power3.out` entrance default.
- **All authored time is seconds.** There is no frame attribute; convert at authoring time (9 frames @30fps = 0.30 s) and leave the frame count as a comment.
- **Land the last fade before the clip's `data-duration`** — the visibility window is half-open, so a tween resolving exactly on the boundary never renders its final frame.
- **`white-space: nowrap` + `overflow: hidden`** in the reference file silently clips a long line. At three words it is safe; do not inherit it into a wide-line track. If you allow two lines, `text-wrap: balance` balances them (Chromium ≤6 lines, Firefox ≤10).
- Absolute-position the cards on top of each other in the stack, or a hidden card still occupies layout and the centring jumps.
- With one element per card, a long video makes a large DOM. Above ~600 cards, split the track into per-scene sub-comps rather than one file.

**ffmpeg.** Only when a baked file must leave the pipeline. `transcript-cut.mjs` is the staged script for transcript-driven cutting; if the picture is recut, the cue sheet must be regenerated from the recut transcript, never time-shifted by hand. Burn-in: `-vf "subtitles=cards.ass"` — the ASS format is the right carrier here because it holds per-event `\fad(100,100)` and positioning, and `force_style` can override `FontName`/`FontSize`/`Outline` at encode time.

**Epidemic Sound.** A chained track is silent. Do not put a tick on every card swap — at 60–90 swaps a minute that is the density-fatigue failure in [[sfx-density-fatigue-audit]].

**Remotion.** Same cue array, mapped to frame ranges with a per-card component and `interpolate()` on opacity; frame-native, so the 9-frame floor ports as a literal constant.

## Pairs with
[[sub-caption-role-decision]] · [[sub-karaoke-active-word-highlight]] · [[sub-emphasis-caption-three-words]] · [[sub-verbatim-misspeak-correction]] · [[sub-mixed-script-hinglish-stack]] · [[sub-safe-area-and-caption-zone]] · [[pace-partial-pause-removal]] · [[sfx-density-fatigue-audit]]

## Failure modes
- **Fixed N-words-per-card loop.** The reference implementation's own approach. It splits "120 / BPM", "Martin / Scorsese", "the / cut", and every such split is visible. Correction: run pass one with the punctuation and never-split rules.
- **Raw word timings, no repair.** Runs of function words produce 4–7 frame cards that flicker. Correction: the 0.30 s chained floor with merge-then-extend.
- **A blink between every card.** Fading out and in per card, which is what happens when the reference's four-tween cycle is applied per card. Correction: `tl.set` handovers within a sentence, fades only at sentence edges.
- **Chaining through full stops.** Removes all sentence structure and makes the track exhausting. Correction: 0.20 s gap at terminal punctuation.
- **Reading rate ignored for muted delivery.** A 30 CPS chained track is fine sound-on and unreadable muted. Correction: recompute at 17 CPS and hold cards longer, accepting that the track then lags the voice slightly.
- **Editing the words to make them fit.** Rewriting speech to hit three words is a correctness bug, not a style choice. Correction: change the boundary, not the text; if a phrase genuinely needs four words, it is not a card, it is a graphic.
- **Cue sheet not regenerated after a recut.** Every cue after the recut point is wrong by the removed duration. Correction: regenerate from the recut transcript; never slip cues by hand.
- **Backward-seek text corruption.** Any design that writes `textContent` in `onStart` will show stale text under a backward seek in Studio. Correction: one element per card.
