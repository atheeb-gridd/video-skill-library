---
id: pace-partial-pause-removal
title: Partial pause removal — the entertainment/authenticity dial
skill: editing
type: pacing
family: pause-removal
tags: [skill/editing, type/pacing, family/pause-removal, engine/ffmpeg, engine/hyperframes, source/editing-kt, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:01:56
    quote: "For example, if you cut out every pause so you're talking non-stop, that's by far the biggest thing you can do for entertainment."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:02:03
    quote: "But it comes at the cost of authenticity."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:00:56
    quote: "You may also see a lot of jump cuts in talking head videos on YouTube, to help remove pauses and mistakes."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html#silencedetect
  - https://github.com/WyattBlue/auto-editor/blob/master/README.md
  - https://www.mdpi.com/2226-471X/8/1/23
  - https://www.rendi.dev/docs/silence-detection-removal
  - https://www.retentionrabbit.com/blog/2025-youtube-audience-retention-benchmark-report
difficulty: medium
detectable_from: transcript+video
---

# Partial pause removal — the entertainment/authenticity dial

## What it is
Pause removal is the removal of the silent gaps between words and sentences in A-roll, joined back together as jump cuts. The source names it as the single highest-impact entertainment move in the whole edit **and** the single biggest authenticity cost, which makes it a **dial, not a switch**. The dial is one number — how much silence you are willing to leave at a join — and the professional move is to set it per *boundary class* (hesitation, clause, sentence, section) rather than globally. An all-or-nothing strip is the amateur setting at both ends: nothing removed reads as unedited; everything removed reads as an auctioneer. Pause removal is one of the four removals in the subtractive first pass ([[pace-subtractive-first-pass]]); this note is the dial itself, in depth.

## When to use it
On every talking-head A-roll pass, before any B-roll, graphics or music decisions are made — because pace determines cut density, music BPM and how much B-roll you need. Set the dial high (aggressive) for entertainment-first, fast-delivery formats and for the first 60 seconds of any video, where **about 55% of the audience is lost by the 60-second mark**. Set it low (conservative) where the value proposition *is* the person — interviews, vulnerable stories, authority-by-calm — and on the specific lines where a pause is doing work: before a reveal, after a punchline, around a number. Never run the dial at maximum through a whole video; a video with no air anywhere has no emphasis anywhere, because emphasis is made of contrast.

## How to recognise it in a reference video
- **Measure the residual gaps, not the cuts.** Get a word-level transcript, compute every inter-word gap, and histogram it. That histogram *is* the dial setting:
  `node <SKILL_DIR>/scripts/transcribe.mjs --input ref.mp4 --out ref.transcribe.json`
  then read `words[].start/end`.
- **Interpretation of the histogram:**
  - A hard wall at **0.00–0.10 s** with almost nothing above 0.25 s → maximum strip. Expect audible breath removal and near-continuous speech.
  - A cluster at **0.12–0.20 s** with a second cluster at **0.30–0.60 s** → the professional setting: hesitations gone, sentence boundaries preserved.
  - Gaps commonly above **0.8 s** → little or no pause removal.
- **Reference point for "unedited".** In measured read speech, silent pauses run **median ≈ 398 ms, mean ≈ 487 ms (SD ≈ 351 ms)**, and pause length scales with the size of the structural boundary it sits on. Anything materially under that median across the whole file has been cut.
- **Count the jump cuts on the A-roll track.** Frame-step the boundaries: a pause-removal cut shows a **1-frame discontinuity in the subject's head position/posture** with the background static. Count them per minute — 15–40/min is a normal aggressive talking-head edit; over ~60/min the picture is being held together by masking, not by the cut.
- **What masks the cut tells you the intent.** Alternating punch-in scale (see [[cut-punch-in-emphasis]]), a B-roll overlay landing exactly on the join (see [[pace-overlay-instead-of-cut]]), or a bare visible jump. A bare jump every time is the entertainment-first signature.
- **Breath audit.** Solo the audio and listen at the joins. Breaths present but reduced = partial removal. Breaths entirely absent = full strip; this is the strongest authenticity tell and the fastest thing to hear.
- **Transcript-side signal.** Filler words gone entirely ("um", "uh", "like") while sentence rhythm survives means a filler pass ran separately from the silence pass. That is two dials, and worth logging as two.
- **Effective speaking rate.** Words in the finished cut ÷ runtime of speech. Under ~150 wpm is conversational; 175–200 wpm is a stripped fast-delivery edit. (House thresholds — treat as review flags, not published limits.)

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `silence_floor_db` | −32 dBFS | −40 to −26 dBFS | Detection threshold. ffmpeg `silencedetect` ships **−60 dB**, which is a *digital-silence* threshold and finds almost no speech pauses — you must override it. `auto-editor`'s default `threshold=0.04` (4% of full scale ≈ −28 dBFS) is the better starting point for voice. |
| `min_silence_s` | 0.35 s | 0.25–0.80 s | Minimum gap that counts as a removable pause. ffmpeg's `silencedetect` default `duration` is **2.0 s** — also useless for this job. `transcript-cut.mjs --cut-silence` takes this number directly; the contract's own example uses `0.8`. |
| `keep_floor_hesitation` | 0.08 s (2–3 f) | 0.00–0.12 s | What survives at a within-clause hesitation. `0` is the maximum-entertainment setting. |
| `keep_floor_clause` | 0.15 s (4–5 f) | 0.10–0.25 s | Comma-level boundary. |
| `keep_floor_sentence` | 0.25 s (7–8 f) | 0.18–0.45 s | Sentence boundary. Below ~0.18 s sentences start to run together. |
| `keep_floor_section` | 0.60 s (18 f) | 0.40–1.20 s | Section/topic boundary. This is where the video breathes; do not strip it. |
| `pad_lead_in` | 0.06 s (2 f) | 0.03–0.10 s | Handle kept **before** the first word of the incoming segment, so the plosive is not clipped. |
| `pad_tail` | 0.10 s (3 f) | 0.06–0.20 s | Handle kept **after** the last word, so the word's decay survives. `auto-editor` calls this `--margin` and defaults it to **0.2 s** both sides. |
| `breath_policy` | `duck` | `keep` \| `duck` \| `cut` | `duck` = leave the breath, attenuate **−6 to −9 dB**. This is the cheapest authenticity purchase in the whole technique. |
| `entertainment_dial` | 0.6 | 0.0–1.0 | Single knob the design doc sets; drives every keep_floor (see mapping in the prompt). |
| `protected_ranges` | — | list of `a-b` | Beats where the pause IS the content: pre-reveal, post-punchline, dramatic hold. Excluded from the pass. |
| `cuts_per_minute_cap` | 40 | 20–60 | Review flag on A-roll jump-cut density. |

## Reproduction prompt

```
Run a partial pause-removal pass on the A-roll. Do NOT strip all silence.

INPUT: {{SRC}} (talking-head A-roll), a word-level transcript, and
ENTERTAINMENT_DIAL = {{DIAL}} in 0.0..1.0 (default 0.6).

1. Transcribe to word level and build the gap list: for every consecutive word
   pair, gap = word[i+1].start - word[i].end.

2. Classify each gap from the transcript text that precedes it:
     - ends mid-clause, no punctuation      -> HESITATION
     - ends on , ; : or a coordinator       -> CLAUSE
     - ends on . ? !                        -> SENTENCE
     - is a topic/section boundary in the script -> SECTION

3. Derive keep floors from the dial (linear interpolation, seconds):
     HESITATION  keep = 0.16 - 0.16*DIAL      (0.16s at 0.0 -> 0.00s at 1.0)
     CLAUSE      keep = 0.30 - 0.20*DIAL      (0.30 -> 0.10)
     SENTENCE    keep = 0.50 - 0.28*DIAL      (0.50 -> 0.22)
     SECTION     keep = 1.00 - 0.45*DIAL      (1.00 -> 0.55)
   Never let SECTION fall below 0.40s no matter the dial.

4. For each gap, remove only (gap - keep) and only if that excess exceeds
   0.12s - a shorter removal is not worth a visible jump cut. Keep a 0.06s
   lead-in handle before the incoming word and a 0.10s tail handle after the
   outgoing word; both handles come OUT of the keep budget, not on top of it.

5. Skip every gap inside {{PROTECTED_RANGES}} entirely. If the design doc
   names no protected ranges, protect: the gap immediately before any number,
   result or reveal; the gap immediately after any punchline; and the last
   gap before each section transition.

6. Breaths: do not delete them. Attenuate audible breaths by 7 dB. If a
   breath sits inside a gap you are shortening, keep the breath and cut the
   silence around it.

7. Emit the kept-segment list as JSON before cutting anything, and record in
   the design doc: DIAL used, gaps removed, total time removed, resulting
   jump-cut count per minute, and effective words-per-minute.

ACCEPTANCE TEST: (a) jump cuts on the A-roll track <= 40 per minute; (b) the
gap histogram of the OUTPUT still has a visible cluster at or above 0.18s -
if every gap has collapsed under 0.12s the dial ran away and the pass must be
re-run lower; (c) listen to 30 seconds with your eyes shut: you must hear the
speaker breathe at least twice; (d) every protected range is still intact,
frame-checked.
```

## Execution spec

**ffmpeg / detection.** Two routes. `silencedetect` for a fast map on an audio-only extract — note both defaults must be overridden:

```bash
# -32 dBFS floor, 0.35s minimum gap. Prints silence_start / silence_end / silence_duration.
ffmpeg -i src.mp4 -af "silencedetect=noise=-32dB:d=0.35" -f null - 2>&1 | grep silence_
```

The word-level transcript is the better input, because it gives boundary *class* as well as gap length; `silencedetect` gives length only.

**The cut itself — `transcript-cut.mjs`** (the one script the contract ships):

```bash
# 1. plan only, inspect the kept segments before encoding
node <SKILL_DIR>/scripts/transcript-cut.mjs \
  --input src.mp4 --transcript src.transcribe.json \
  --cut-silence 0.35 --remove-fillers "um,uh,you know" \
  --plan --json

# 2. commit. Do NOT add --copy: stream copy snaps to keyframes and can
#    "silently swallow the whole cut" on sparse-keyframe footage.
node <SKILL_DIR>/scripts/transcript-cut.mjs \
  --input src.mp4 --transcript src.transcribe.json \
  --cut-silence 0.35 --remove-fillers "um,uh,you know" \
  --out src.cut.mp4 --json
```

`--cut-silence N` removes inter-word gaps longer than N seconds — it is a **single global floor**, so it cannot express per-class keep floors on its own. To get the graded dial, compute the per-class removals yourself and pass them as explicit second ranges via `--remove "a-b,c-d,…"`. `--remove-words` takes word-index ranges if you are working from indices. Keep scratch output **outside the vault mount** — the mount cannot delete files, so temp dirs cannot be cleaned up there.

**HyperFrames — the better architecture for a live dial.** Do not bake the cut if you may want to change the dial later. Author each kept segment as its own clip pair, trimming with `data-media-start` instead of re-encoding: the source file is untouched and the dial is one edit away.

```html
<!-- kept segment 1: source 4.12-9.80 -> timeline 0.00-5.68 -->
<video id="a-01" src="assets/aroll/take.mp4" muted playsinline class="clip"
       data-start="0" data-duration="5.68" data-media-start="4.12" data-track-index="0"></video>
<audio id="a-01-au" src="assets/aroll/take.mp4" data-audio-group="voiceover"
       data-start="0" data-duration="5.68" data-media-start="4.12" data-track-index="10"></audio>

<!-- kept segment 2: source 10.34-14.02 -> timeline 5.68-9.36  (0.54s of pause removed) -->
<video id="a-02" src="assets/aroll/take.mp4" muted playsinline class="clip"
       data-start="5.68" data-duration="3.68" data-media-start="10.34" data-track-index="0"></video>
<audio id="a-02-au" src="assets/aroll/take.mp4" data-audio-group="voiceover"
       data-start="5.68" data-duration="3.68" data-media-start="10.34" data-track-index="10"></audio>
```

Contract points that bind this:
- **Picture and sound are aligned by writing the same numbers twice** — there is no auto-sync and no drift correction. `data-start`, `data-duration`, `data-media-start` (and `data-playback-rate` if used) must match on both elements.
- The half-open window `[start, start+duration)` means `a-02.start === a-01.start + a-01.duration` is a true frame-exact hard cut with no overlap and no gap.
- Every `<audio>` needs an `id` — an id-less audio element is **never mixed** and renders silent (`media_missing_id`).
- Convention is `muted` video + a separate `<audio>` for the track; that is also what lets you keep picture and sound cut points independent, which is what a J/L cut needs.
- Do not nest a timed `<video>` inside another timed element (`video_nested_in_timed_element`, error).
- Put the voice clips in `data-audio-group="voiceover"` so a music bed can carve against the group later (see [[pace-bpm-matched-music-selection]]).
- Author seconds. There is no frame attribute; 2 frames at 30fps is `0.0667`.

**Breath ducking** is a `volume` automation lane on the segment's audio clip, with `t` in **clip-local** seconds — and remember a lane **holds its first value backwards to the clip start**, so write an explicit `t:0` point:

```html
data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:2.10,&quot;v&quot;:1},{&quot;t&quot;:2.16,&quot;v&quot;:0.45},{&quot;t&quot;:2.42,&quot;v&quot;:0.45},{&quot;t&quot;:2.48,&quot;v&quot;:1}]}]}"
```
`0.45` ≈ −7 dB. Do **not** also GSAP-tween `volume` on that clip — the lane wins and the tween is silently ignored (`audio_volume_double_automation`).

**Epidemic Sound:** not involved in the cut itself, but the finished pace decides the bed. Take the effective words-per-minute from the acceptance test into `SearchRecordings { filter: { bpm: { min, max } } }` — see [[pace-bpm-matched-music-selection]].

**Remotion:** one `<Sequence>` per kept segment with `startFrom` on an `<OffthreadVideo>`; concept only, Remotion is not a runtime in this project.

## Pairs with
[[pace-subtractive-first-pass]] · [[cut-punch-in-emphasis]] · [[pace-overlay-instead-of-cut]] · [[pace-cut-density-from-viewer-intent]] · [[pace-silent-demonstration-window]] · [[pace-bpm-matched-music-selection]] · [[struct-stimulation-budget]] · [[cut-dissolve]] · [[struct-handbook-reframe]]

## Failure modes
- **All-or-nothing strip.** Every gap under 0.10 s: the speaker sounds panicked, sentence boundaries vanish, and emphasis becomes impossible because nothing is slower than anything else. Correction: run the dial at 0.6, not 1.0, and keep `keep_floor_section` at ≥0.40 s.
- **Breaths deleted.** The most reliable authenticity tell in existence, and the one viewers describe as "AI voice" without knowing why. Correction: `breath_policy: duck` at −7 dB.
- **Clipped plosives and swallowed word tails.** Cutting exactly on `word.end` removes the consonant's decay. Correction: 0.06 s lead-in and 0.10 s tail handles, always.
- **A pause removed where the pause was the joke.** Correction: the `protected_ranges` list is not optional; build it from the script before the pass, not after.
- **Using ffmpeg's `silencedetect` defaults.** `noise=-60dB:d=2.0` finds digital silence over two seconds long and will report almost nothing on a voice track, which reads as "there were no pauses". Correction: always pass `noise=-32dB:d=0.35` or similar.
- **`--copy` on the cut.** Stream copy snaps to keyframes; the script itself warns on >1 s drift and reports `copy_drift`. Correction: drop `--copy` for frame-accurate cuts.
- **Jump cuts left bare at high density.** Above ~40 A-roll jumps per minute the picture reads as a glitch reel. Correction: alternate punch-in scale, or land B-roll on the joins.
- **Known gap:** the words-per-minute and cuts-per-minute caps here are house review thresholds, not published standards. The pause-duration reference numbers come from measured read speech and set the "unedited" baseline only; spontaneous delivery runs longer.
