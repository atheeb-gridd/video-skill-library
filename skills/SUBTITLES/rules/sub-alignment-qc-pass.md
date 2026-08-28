---
id: sub-alignment-qc-pass
title: Sanity-check the word timings before they become cues — five machine checks that fail the build
skill: subtitles
type: caption-timing
family: alignment
tags: [skill/subtitles, type/caption-timing, family/alignment, engine/ffmpeg, engine/hyperframes, source/hyperframes, source/research, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "silencedetect measures so you can choose the threshold; transcript-cut.mjs --cut-silence <N> applies it. Run this first, look at the distribution, then set --cut-silence. Going straight to --cut-silence is guessing."
research_refs:
  - https://docs.pytorch.org/audio/main/tutorials/forced_alignment_tutorial.html
  - https://github.com/m-bain/whisperX
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
difficulty: medium
detectable_from: transcript+video
---

# Sanity-check the word timings before they become cues — five machine checks that fail the build

## What it is

An alignment can be wrong in exactly five ways that a machine can catch cheaply, and every one of them turns into a visible caption defect if it reaches the cue generator. Run these before segmentation, not after — a bad word timing propagates into every cue that contains it, and debugging it from the rendered video costs an order of magnitude more.

**1. Monotonicity.** `start[i] < end[i] <= start[i+1]` for every word. Aligners occasionally emit a word whose end precedes its start, or two words that cross, usually around a disfluency or an overlap. Any violation is a hard fail.

**2. Duration outliers.** A word's duration should be plausible for its length. English content words run roughly **0.2–0.6 s**; function words **0.06–0.25 s**. Flag anything under **0.05 s** (the aligner collapsed it) or over **1.2 s** for a single short word (the aligner stretched it across a silence). The classic signature is a token that absorbed a two-second pause.

**3. Silence agreement.** Cross-check the alignment against `silencedetect`. Every silent region longer than the threshold should fall **between** words, not inside one. A word whose span overlaps a detected silence by more than ~40 % of its duration is mistimed.

**4. Confidence floor.** CTC aligners return a per-segment score — the average frame probability across the merged segment. Sort ascending and read the bottom 2 %: that list is, in practice, a list of the words the aligner guessed at. Anything under **0.55** goes to review; anything under **0.30** should be treated as unaligned.

**5. Coverage and identity.** Every token in the corrected transcript appears exactly once, in order, spelled identically. This is the check that catches OOV drops and, crucially for romanised Hinglish, any tool in the chain that "helpfully" corrected `karu` to `karma`.

A sixth, cheap, whole-file check belongs beside these: **global offset**. Take the first ten confident words and the last ten, and compare aligned onsets against measured onsets. A constant error is an offset ([[sub-latency-and-offset-correction]]); an error that grows linearly is a sample-rate or frame-rate mismatch.

## When to use it

- After every alignment, before any cue is generated. It costs seconds.
- After any transcript correction or audio recut — both invalidate timings locally.
- As a **gate in a batch pipeline**: a long video's alignment must pass before the cue generator runs, or you will QC 900 cues instead of 12 words.
- Whenever a rendered caption "feels late" and you need to know whether the fault is the alignment, the cue rule, or a global offset.

## How to recognise it in a reference video

The QC pass is invisible in a reference, but its **absence** has a fingerprint you can measure:

- **Isolated late words.** Most of the track lands within ±2 frames but a handful of words are 8–20 frames off. That scatter pattern (rather than a constant bias) is unrepaired alignment noise, not an offset.
- **A word that holds through a pause.** A caption word that stays highlighted across an obvious 1–2 s silence is a duration outlier that was never flagged.
- **A missing word.** Compare the burned-in text against the audio for 60 seconds. A dropped numeral or currency figure is the OOV failure reaching the screen.
- **A silently corrected romanisation.** In the Hinglish reference set the caption reads `parr naam kya search karu??`. If your regenerated track spells any of those tokens differently, a spell-corrector is in the chain and the coverage check would have caught it.
- **Measurement method.** Dense frame extraction only — `select='between(n,N1,N2)'` with `-fps_mode passthrough`. Never put `fps=` in the chain; resampling destroys exactly the information being measured. A contact sheet is a survey tool, not a measurement tool.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `monotonic_check` | hard fail | — | `start[i] < end[i] <= start[i+1]`, no exceptions. |
| `min_word_duration` | 0.05 s | 0.03–0.08 s | Below this the aligner collapsed the word. |
| `max_word_duration` | 1.20 s | 0.8–2.0 s | For a single short word. Long compound names legitimately exceed it — review, do not auto-fix. |
| `content_word_band` | 0.20–0.60 s | — | Expected duration for a stressed content word at conversational rate. |
| `silence_overlap_max` | 40 % | 25–60 % | Of the word's own duration overlapping a detected silence. |
| `silence_threshold` | −40 dB, d=0.3 s | −50 to −30 dB | Set `noise` 6–10 dB above the measured room floor. |
| `min_confidence_review` | 0.55 | 0.40–0.80 | Aligner score; below it, human review. |
| `min_confidence_reject` | 0.30 | 0.20–0.40 | Treat as unaligned and interpolate. |
| `coverage_check` | exact | — | Token-for-token, order-preserving, spelling-identical. |
| `global_offset_tolerance` | ±0.045 s | ±0.02–0.08 s | ITU-R BT.1359-1 puts detectability at 45 ms audio lead / 125 ms lag. |
| `drift_tolerance` | 0.001 s per s | — | A linearly growing error is a rate mismatch, not an offset. |
| `outlier_budget` | 2 % of words | 0–5 % | Above this, re-align rather than repair by hand. |

## Reproduction prompt

```
QC the word alignment {{ALIGN_JSON}} for {{AUDIO}} before generating cues.
Emit a report and a pass/fail.

CHECK 1 MONOTONIC: assert start<end for every word and end[i] <=
start[i+1]. Any violation = FAIL, list the indices.
CHECK 2 DURATION: flag words shorter than {{MIN_DUR}}=0.05s or longer than
{{MAX_DUR}}=1.20s. Report each with its text, index and duration.
CHECK 3 SILENCE: run
  ffmpeg -hide_banner -i {{AUDIO}} -af "silencedetect=noise={{NOISE}}dB:d=0.3"
  -vn -f null - 2>&1 | grep silence
Parse the start/end pairs. Flag any word overlapping a silent region by more
than {{OVERLAP}}=40% of its own duration.
CHECK 4 CONFIDENCE: sort by score; list every word under {{REVIEW}}=0.55 and
mark every word under {{REJECT}}=0.30 as unaligned.
CHECK 5 COVERAGE: diff the alignment's token sequence against the corrected
transcript. Any missing, extra, reordered or RESPELLED token = FAIL. Report
respellings separately - they mean a spell-corrector is in the pipeline.
CHECK 6 OFFSET: for the 10 highest-confidence words in the first 30s and the
last 30s, compare aligned onset to the onset measured by extracting frames
with select='between(n,..)' at native fps. Report mean offset for each group;
a constant difference is an offset, a growing one is a rate mismatch.

ACCEPTANCE TEST: checks 1 and 5 pass absolutely; flagged words from checks 2
and 3 total under {{BUDGET}}=2% of all words; mean confidence is reported;
the global offset is within {{TOL}}=45ms or a correction value is written
into the report for [[sub-latency-and-offset-correction]] to apply.
```

## Execution spec

This runs entirely outside HyperFrames, on the build artefacts, before the cue array is inlined into the composition. Nothing here changes at render time.

The measurement tools are the ones the analysis toolchain already documents as verified in this container:

```bash
# room floor first - the threshold is derived, not guessed
ffmpeg -hide_banner -i speech.wav -af astats -f null - 2>&1 | grep -i "Noise floor"

# then silence regions, with -vn so ffmpeg does not decode the video
ffmpeg -hide_banner -i in.mp4 -af "silencedetect=noise=-40dB:d=0.3" -vn -f null - 2>&1 | grep silence

# fps is read per file, never assumed
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of csv=p=0 in.mp4
```

Every region `silencedetect` reports comes as a matched `silence_start` / `silence_end` pair, and a region running to the end of file is still closed with a final `silence_end` at the file duration — a parser does not need to special-case an unterminated last region.

The QC report is a build artefact, not a document for humans to skim: it should be machine-readable, and in a batch pipeline it should **gate** the cue generator, as in [[sub-batch-generation-and-qc]]. Note the parallel with the lint contract on the composition side: a lint **error** in HyperFrames also switches off the layout and contrast audits, so `check` reports "0 samples" and reads like a clean file. Same trap here — a QC pass that silently skipped four of six checks looks identical to one that passed them. Print the count of checks actually run.

## Pairs with
[[sub-forced-alignment-word-timings]] · [[sub-word-level-cue-generation]] · [[sub-latency-and-offset-correction]] · [[sub-batch-generation-and-qc]] · [[sub-orthography-protection-no-autocorrect]] · [[sub-verbatim-misspeak-correction]] · [[pace-subtractive-first-pass]] · [[pace-partial-pause-removal]]

## Failure modes
- **QC'ing the rendered video instead of the timings.** You find the same defect ten steps downstream at ten times the cost. Correction: gate at the alignment.
- **Auto-repairing outliers.** Clamping a 2.4 s word to 1.2 s hides the real problem, which is that the aligner lost the thread there. Correction: flag, review, re-align that region.
- **Setting the silence threshold before measuring the floor.** If the room floor is above `noise=`, nothing is ever silent and check 3 returns clean on a broken alignment. Correction: `astats` first.
- **Treating scatter as offset.** Averaging a set of noisy per-word errors produces a plausible-looking offset that fixes nothing. Correction: distinguish constant bias from scatter before applying any global shift.
- **Ignoring respellings in the coverage check.** The most damaging failure in a romanised-Hinglish track, and the easiest to miss because the text still reads as words. Correction: exact-string comparison, respellings reported separately.
- **A QC pass that skips checks silently.** Correction: report how many checks ran, as well as their results.
- **Running QC on the mixed master.** Music under the voice moves the silence floor and the confidence scores at once. Correction: QC against the voice stem.
