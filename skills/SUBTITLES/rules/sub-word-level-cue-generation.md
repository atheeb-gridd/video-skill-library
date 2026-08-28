---
id: sub-word-level-cue-generation
title: Build word-level cues from word onsets, and let the next onset end the cue
skill: subtitles
type: caption-timing
family: timing-model
tags: [skill/subtitles, type/caption-timing, family/timing-model, engine/hyperframes, source/hyperframes, source/research, difficulty/high]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "A word-level `script` array literal: 46 entries of `{ \"text\", \"start\", \"end\" }`, in seconds, three decimals. This is a whisper/Parakeet word transcript inlined into the file."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "For per-word rather than per-line captions, the mechanism is the `per-word kinetic typography` technique with `timings` taken from the same transcript array."
research_refs:
  - https://github.com/m-bain/whisperX
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
  - https://aegisub.org/docs/latest/ass_tags/
difficulty: high
detectable_from: transcript+video
---

# Build word-level cues from word onsets, and let the next onset end the cue

## What it is

The generation rule for a word-level track, stated exactly, because the obvious version is wrong.

An ASR word array gives every word a `start` and an `end`. The naive generator uses both: `cue.start = word.start`, `cue.end = word.end`. That produces a track that flickers, because `word.end` is the acoustic offset of the word and the gap to the next word's onset is dead air with no caption in it. Speech has 40–300 ms of inter-word silence in normal delivery, and a caption that respects it blinks on every word.

The correct rule is **onset-to-onset**:

```
cue[i].start = word[i].start - pad_head
cue[i].end   = word[i+1].start          (within a breath group)
cue[last].end = word[last].end + tail_hold
```

The cue therefore *owns* the silence that follows its word. The plate never clears mid-sentence, the text simply swaps, and the swap lands exactly on the next onset — which is the frame the viewer's ear expects it. This is the same contract ASS karaoke uses: `\k` durations tile the line with no gaps, in centiseconds, each syllable's duration running to the start of the next.

Two corrections then apply on top. **Short words merge**: runs of function words produce 4–7 frame cues, below the fusion threshold, and read as a stutter rather than as text. **Breath groups break**: at a terminal punctuation mark or a silence longer than `breath_gap`, the chain stops, the last cue takes a tail hold, and the plate is allowed to clear.

## When to use it

- Any track whose model is **word-level** per [[sub-timing-model-selection]], including 1–3 word cards.
- The **highlight stream** of a hybrid track — the card timing comes from [[sub-phrase-cue-assembly]], but the highlight advance is exactly this onset-to-onset rule.
- Whenever a reference video shows the plate persisting across text swaps. That persistence is the visible signature of onset-to-onset generation.
- **Do not** use it for a sidecar deliverable. SRT and VTT cues at this density are unusable in a player and, at 20–40 cues per 10 seconds, will be rejected by most QC tools.
- **Do not** use raw `word.end` as `cue.end` anywhere except the last cue of a breath group.

## How to recognise it in a reference video

- **Plate persistence across a swap.** Extract every frame across a mid-sentence cue boundary (`select='between(n,N1,N2)'`, `-fps_mode passthrough`). Onset-to-onset generation shows the plate at 100 % opacity in every frame with only the glyphs changing. A blink of even **1–2 frames** means `word.end` was used.
- **Swap frame vs. audio onset.** Line the swap frame up against the waveform. Correct generation puts the swap within **±2 frames** of the acoustic onset. Consistently 3–8 frames late is the `word.end` bug; consistently early is over-padding.
- **Cue duration distribution.** Onset-to-onset cues run **6–45 frames** with a mode near **0.30–0.55 s** at conversational rate. A histogram with a spike below 5 frames means no merge pass ran.
- **Silence handling.** Find a 1.5 s pause in the audio. Onset-to-onset with a breath-group break clears the plate; without one, the last word sits on screen for the whole pause. Either can be a house choice — log which.
- **Cue count.** Word count ÷ cue count should be **1.0–3.0**. Above 3.0 the track is phrase-level.
- **Reading rate.** Chained word tracks land at **25–35 CPS** measured over on-screen characters, well above the 20 CPS broadcast ceiling, and are only defensible sound-on.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `end_rule` | next onset | next onset / word end | Word end is correct only for the last cue in a breath group. |
| `pad_head` | 0.04 s (1 f @30) | 0–0.08 s | The card is up as the word starts, never after. Over 2 frames reads as a spoiler. |
| `tail_hold` | 0.35 s | 0.20–0.60 s | Held after the last word of a breath group before the plate clears. |
| `breath_gap` | 0.45 s | 0.30–0.80 s | Inter-word silence above this ends the chain. Measure the real distribution with `silencedetect` first. |
| `min_cue_chained` | 0.20 s (6 f) | 0.17–0.30 s | Below this a swap is subliminal. Merge, do not stretch. |
| `min_cue_isolated` | 0.83 s (20 f @24) | 0.70–1.20 s | Netflix's 5/6-second minimum event, binding whenever the plate fades in and out. |
| `merge_target` | ≤3 words | 1–3 | Merge a short cue into the neighbour with fewer words. |
| `max_cue_words` | 3 | 1–3 | Above 3 it is a phrase, not a word cue. |
| `terminal_break` | `. ? ! …` | — | Always ends a chain regardless of gap length. |
| `onset_source` | forced alignment | alignment / ASR | Raw ASR onsets drift; see [[sub-forced-alignment-word-timings]]. |
| `unaligned_token_policy` | interpolate + flag | interpolate / drop | Numerals, currency and non-dictionary romanised tokens often come back with no timing. |
| `swap_type` | hard `set` | set only | Never crossfade two chained cues — 3 frames of double exposure. |

## Reproduction prompt

```
Generate word-level caption cues for {{PROJECT}} from the word-level
transcript (entries of {text,start,end} in seconds, monotonic).

RULE 1 - ONSET TO ONSET. For each cue i inside a breath group:
  start = word[i].start - {{PAD_HEAD}} (0.04s, clamped to >= previous end)
  end   = word[i+1].start
The cue owns the silence after its word, so the plate never blinks.

RULE 2 - BREATH GROUPS. Close the chain when a word ends with . ? ! or an
ellipsis, or when word[i+1].start - word[i].end > {{BREATH_GAP}} (0.45s).
The closing cue gets end = word.end + {{TAIL_HOLD}} (0.35s).

RULE 3 - MERGE SHORT CUES. Any chained cue under {{MIN_CHAINED}} (0.20s)
merges with the adjacent cue holding fewer words, up to a 3-word ceiling.
Never merge across a breath-group boundary. Repeat until stable.

RULE 4 - UNALIGNED TOKENS. A word with no timing (numerals, currency,
non-dictionary romanised tokens) inherits a linear interpolation between its
neighbours and is written to an exceptions list for review. Never drop it and
never alter its spelling.

Text is verbatim. No rewording, no invented punctuation, no case changes.

ACCEPTANCE TEST: cue starts strictly increase; for every consecutive pair
inside a breath group end[i] == start[i+1] exactly; no chained cue is under 6
frames at {{FPS}}; every transcript word appears in exactly one cue in
transcript order; and stepping frame by frame across three mid-sentence
swaps, the plate is present in every frame.
```

## Execution spec

The cue array is **inlined into the composition** as a literal, exactly as `compositions/captions.html` inlines its 46-entry `script` array of `{text, start, end}` in seconds to three decimals. Nothing reads a transcript at render time — no `audio.currentTime`, no fetch, and a fetch would be a determinism ban anyway.

Onset-to-onset chaining forbids the reference file's four-tween cycle, which fades out at `line.end` and back in at the next `line.start`. Author one element per cue inside a non-clip wrapper and hand over with zero-duration sets:

```js
// 12 frames @30fps = 0.40s. Chained handover: no fade, no overlap.
tl.set("#cap-0041", { autoAlpha: 1 }, 8.120);
tl.set("#cap-0041", { autoAlpha: 0 }, 8.470);   // == next cue's start
tl.set("#cap-0042", { autoAlpha: 1 }, 8.470);
tl.to("#cap-0042", { autoAlpha: 0, duration: 0.10, ease: "power2.in" }, 9.180);
```

Contract points that bind here:

- `tl.set()` on `autoAlpha` is legal because these spans are **not** the clip element — the clip is the sub-comp host. Never write `display`/`visibility` on a `.clip`; lint rejects it.
- Only the **first cue in** and **last cue out** of a breath group get the 0.1 s fade, and caption fades belong to the gentle eases (`power2.out` / `power2.in`), *not* the `power3.out` entrance default.
- The visibility window is **half-open**, `[start, start+duration)`. Land the final tween before the clip's `data-duration` or its last frame never renders.
- Absolutely position the cue spans on top of each other, or hidden cues still occupy layout and the centring jumps.
- Above ~600 cues, split the track into per-scene sub-comps rather than one file — one element per cue on a 10-minute video is a large DOM.
- Transcription: `npx hyperframes transcribe <file>` emits `{ text, words:[{text,start,end}] }`. Parakeet is the documented default but is an Apple-silicon MLX path, so expect the whisper.cpp fallback on this host.

**ffmpeg.** Only for a baked deliverable. ASS is the right carrier: `\k` durations are centiseconds and tile a line without gaps, which is the same contract as onset-to-onset. Burn in with `-vf "subtitles=cues.ass"` (libass; options include `force_style`, `fontsdir`, `charenc`, `alpha`, `wrap_unicode` — verified from `ffmpeg -h filter=subtitles`).

## Pairs with
[[sub-timing-model-selection]] · [[sub-cue-segmentation-three-word]] · [[sub-forced-alignment-word-timings]] · [[sub-alignment-qc-pass]] · [[sub-inter-cue-gap-and-chaining]] · [[sub-cue-duration-floor-and-ceiling]] · [[sub-karaoke-active-word-highlight]] · [[sub-orthography-protection-no-autocorrect]] · [[pace-partial-pause-removal]] · [[motion-single-word-topic-card]]

## Failure modes
- **`cue.end = word.end`.** The single most common bug. Produces a 1–4 frame blink between every word, which reads as a flicker defect, not as text. Correction: next onset.
- **No merge pass.** "and it is a" becomes four 5-frame cues. Correction: merge below 6 frames, up to a 3-word ceiling.
- **Chaining through a long pause.** The last word before a 2-second silence sits on screen alone, implying the speaker is still saying it. Correction: `breath_gap` break with a tail hold.
- **Over-padding the head.** More than 2 frames of lead and the caption reads as a spoiler; the word appears before it is heard.
- **Dropping unaligned tokens.** WhisperX states plainly that words whose characters are outside the alignment model's dictionary — "2014." or "£13.60", and equally a romanised Hinglish token — cannot be aligned and get no timing. Dropping them silently edits the transcript. Correction: interpolate and flag.
- **Crossfading chained cues.** Two 0.1 s fades overlap into a legible double exposure for about 3 frames. Correction: hard `set`.
- **Regenerating cues after a picture recut by slipping times.** Every cue after the cut is wrong by the removed duration. Correction: regenerate from the recut transcript.
