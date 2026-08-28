---
id: sub-forced-alignment-word-timings
title: Forced alignment is what produces trustworthy word timings — ASR decoder timestamps are not
skill: subtitles
type: caption-timing
family: alignment
tags: [skill/subtitles, type/caption-timing, family/alignment, engine/hyperframes, engine/ffmpeg, source/hyperframes, source/research, difficulty/high]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Transcription — default is Parakeet-TDT via parakeet-mlx, not whisper... Emits `{ text, words:[{text,start,end}] }`."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: n/a
    quote: "sfx kt 1 burns in captions like `parr naam kya search karu??` — Latin script, not Devanagari."
research_refs:
  - https://github.com/m-bain/whisperX
  - https://docs.pytorch.org/audio/main/tutorials/forced_alignment_tutorial.html
  - https://montreal-forced-aligner.readthedocs.io/en/latest/first_steps/index.html
  - https://en.wikipedia.org/wiki/Forced_alignment
difficulty: high
detectable_from: transcript+video
---

# Forced alignment is what produces trustworthy word timings — ASR decoder timestamps are not

## What it is

Forced alignment is the process of segmenting an audio signal against a **known** transcript: you already have the words, and you are solving only for where each one begins and ends. That is a much easier problem than recognition, and it is solved to a much tighter tolerance.

The mechanism, as implemented in the standard CTC aligner: an acoustic model emits a frame-wise log-probability over labels; a **trellis** is built whose cells hold the probability that transcript label *j* is being spoken at frame *t*; each cell allows two moves — stay on the current label, or advance to the next; and **Viterbi backtracking** from the end of the trellis recovers the single highest-probability path. Merging repeated labels gives per-token segments of `{label, start_frame, end_frame, score}`, where the score is the average frame probability across the segment. Multiply frames by the frame duration and you have word timings with a per-word confidence attached.

This matters because the alternative is worse in a specific way. A Whisper-family decoder's timestamps are a **by-product of autoregressive decoding**, not a measurement; they are emitted at segment granularity and interpolated across words, and they drift, particularly at segment edges and after a long pause. WhisperX exists precisely to fix this: it re-aligns Whisper's text against the audio with a **phoneme-level wav2vec2 model** to get word timings that actually correspond to onsets.

Two families, and they answer different needs:

- **CTC / phoneme re-alignment** (WhisperX, torchaudio's aligner). Needs audio + text only. Fast, no pronunciation dictionary, works on arbitrary tokens as long as their characters are in the model's alphabet.
- **HMM aligners with a lexicon** (Montreal Forced Aligner). Needs audio + text + a **pronunciation dictionary** + an **acoustic model**, and outputs TextGrid tiers for words *and* phones. Higher fidelity, and it will tell you exactly which words were out-of-vocabulary. OOV words are handled by generating pronunciations with a G2P model and adding them to the dictionary (`mfa model add_words`), after `mfa validate` flags them.

**The Hinglish consequence is the whole reason this note is high difficulty.** The reference creator burns in romanised Hindi in Latin script — `parr naam kya search karu??`. Every token in that line is out-of-dictionary for an English lexicon. WhisperX states the failure plainly: transcript words whose characters are not in the alignment model's dictionary "cannot be aligned and therefore are not given a timing". That is silent data loss at exactly the words that carry the meaning. Either use a multilingual/character-level alignment model, or add the romanised tokens to a lexicon via G2P, or accept interpolation and flag every interpolated token.

## When to use it

- Always, before any **word-level** or **hybrid** track. A per-word highlight sitting on decoder timestamps will visibly lag.
- Whenever the transcript has been **hand-corrected**. Correcting an ASR error invalidates its timings for that region; re-align, do not nudge.
- Whenever the audio was **recut** after transcription — realign against the recut audio rather than slipping the old timings.
- Whenever the content is **romanised Hinglish, code-mixed, or heavy with names, numbers and units**, because those are exactly the tokens that come back untimed.
- **Skip it** only for a phrase-level track over clean, slow English where cue boundaries are ±150 ms tolerant — and even then, run the QC pass in [[sub-alignment-qc-pass]].

## How to recognise it in a reference video

You cannot see the aligner, but you can see whether one was used.

- **Highlight-to-onset error.** Extract every frame across five word transitions (`select='between(n,N1,N2)'`, `-fps_mode passthrough`, never `fps=`), and compare the swap frame to the acoustic onset in the waveform. Aligned tracks hold **±2 frames**; decoder-timestamp tracks show **4–12 frames** of error and, critically, the error **grows across a long take** and resets at each pause.
- **Error signature after silence.** Find a pause over 1.5 s. Unaligned timings typically resume 5–15 frames late on the word right after it.
- **Numbers and names.** Watch a spoken figure ("two thousand fourteen", "₹13.60"). A track built on unaligned tokens shows those words either mistimed or fused into a neighbour.
- **Per-word treatments at all.** If the reference shows a per-word colour change that never once lands wrong across a 60-second sample, an aligner is in the pipeline. Sustained ±2 frames over hundreds of words is not achievable by hand.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `aligner` | CTC phoneme re-align | CTC / HMM+lexicon | WhisperX-style for speed; MFA when you need phone tiers or explicit OOV reporting. |
| `alignment_tolerance` | ±0.066 s (2 f @30) | ±0.033–0.10 s | The acceptance band for a per-word highlight. |
| `min_word_confidence` | 0.55 | 0.4–0.8 | Average frame probability from the aligner's score. Below it, flag for review. |
| `oov_policy` | G2P then re-align | G2P / interpolate / flag | Never drop and never re-spell — see [[sub-orthography-protection-no-autocorrect]]. |
| `interpolation_flag` | on | on/off | Every interpolated token goes to an exceptions list. |
| `vad_preroll` | 0.20 s | 0.1–0.5 s | VAD is on by default in WhisperX; over-tight VAD clips word onsets. |
| `language_model` | match the spoken language | — | For Hinglish, a multilingual or character-level model, not `en`. |
| `realign_after_edit` | required | — | Any transcript edit or audio recut invalidates the timings for that region. |
| `frame_duration` | from `ffprobe` | — | fps is read per file, never assumed; the reference set runs at 60, 25 and 29.97. |
| `segment_batch` | ≤10 min | 1–15 min | Align in chunks on long programmes; memory grows with the trellis. |

## Reproduction prompt

```
Produce trustworthy word-level timings for {{AUDIO}} before any cue is cut.

1. TRANSCRIBE. Run the project transcriber to get {text, words:[{text,start,
   end}]}. Treat these word timings as PROVISIONAL - decoder timestamps are a
   by-product of decoding, not a measurement.
2. CORRECT THE TEXT FIRST. Fix clear ASR errors now and log each correction.
   Do NOT alter romanised or non-dictionary spellings; they are correct as
   heard, not misspellings.
3. FORCE-ALIGN the corrected text against the audio with a phoneme or
   character-level alignment model for {{LANGUAGE}}. Emit per word:
   {text, start, end, score}.
4. HANDLE OOV. List every token the aligner could not time (numerals,
   currency, non-dictionary romanised tokens). For each: generate a
   pronunciation via G2P and re-align if the aligner supports a lexicon,
   otherwise linearly interpolate between the neighbouring aligned words and
   mark interpolated=true. Never drop a token, never re-spell one.
5. WRITE {{OUT}}.align.json with every word carrying start, end, score and
   the interpolated flag, plus a summary: total words, OOV count, mean score,
   and the count below {{MIN_CONF}}=0.55.

ACCEPTANCE TEST: word starts strictly increase; no word has end <= start;
every corrected-transcript token appears exactly once with unchanged
spelling; OOV count and interpolated count are reported explicitly; and on
five randomly chosen words the aligned start is within {{TOL}}=2 frames of
the onset measured from the waveform.
```

## Execution spec

**HyperFrames.** `npx hyperframes transcribe <file>` (or `scripts/transcribe.mjs`) emits `{ text, words:[{text,start,end}] }`. Parakeet-TDT is the documented default and is a **MLX / Apple-silicon path**, so on a linux ARM64 host expect the whisper.cpp fallback — which means decoder timestamps, which means alignment is not optional if you are building a word-level track. The aligner itself is **outside** the stack: nothing in HyperFrames aligns audio, and nothing reads a transcript at render time. The aligner's output is a build-time artefact whose only job is to become the inlined `script` array in the caption composition, three decimals, in seconds.

**ffmpeg** does the measurement work around it:

```bash
# extract the speech-only audio the aligner should see
ffmpeg -v error -i in.mp4 -vn -ac 1 -ar 16000 speech.wav

# where the words actually are, to sanity-check the aligner's pauses
ffmpeg -hide_banner -i speech.wav -af "silencedetect=noise=-40dB:d=0.3" -f null - 2>&1 | grep silence

# ground truth for a single word: every frame in a 0.3s window, native rate
ffmpeg -v error -i in.mp4 -vf "select='between(n,58,64)'" -fps_mode passthrough -an out/n_%03d.png
```

Set `noise=` about 6–10 dB above the measured room floor, and read fps per file with `ffprobe` — never assume it. Prefer `between(n,…)` over `between(t,…)` for frame-accurate checks; `t` re-introduces the rounding you are trying to measure.

**Recut interaction.** `transcript-cut.mjs` is a compiler that removes ranges from picture and transcript together. After any cut list is applied, the alignment must be regenerated against the new audio; time-shifting the old alignment by the removed duration is wrong wherever a cut fell mid-phrase.

## Pairs with
[[sub-alignment-qc-pass]] · [[sub-word-level-cue-generation]] · [[sub-karaoke-active-word-highlight]] · [[sub-orthography-protection-no-autocorrect]] · [[sub-romanised-hinglish-latin-face]] · [[sub-latency-and-offset-correction]] · [[sub-verbatim-misspeak-correction]] · [[pace-partial-pause-removal]] · [[sfx-av-sync-binding-window]]

## Failure modes
- **Shipping decoder timestamps as word timings.** The highlight lags by 4–12 frames and the lag grows through a take. Correction: re-align.
- **Aligning the uncorrected transcript.** You get precise timings for the wrong words, and fixing the text afterwards invalidates them. Correction: correct, then align.
- **Silent OOV loss.** Untimed tokens quietly disappear from the cue array, editing the transcript by omission. Correction: explicit OOV list, G2P or interpolation, always flagged.
- **Running an English lexicon over romanised Hinglish.** Nearly every content word is OOV. Correction: multilingual/character-level model, or G2P-extended lexicon.
- **Trusting the aligner on overlapping speech or music-heavy beds.** Alignment degrades badly where two voices overlap; those regions need manual review.
- **Aligning against the mixed master.** Music and SFX under the voice raise the error floor. Correction: align against the isolated voice stem where one exists.
- **Not recording the fps used.** Frame-indexed checks silently drift on a 29.97 file. Correction: read fps per file and store it beside the alignment.
