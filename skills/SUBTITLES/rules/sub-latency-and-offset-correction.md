---
id: sub-latency-and-offset-correction
title: Measure the offset, correct it once globally, and only then go looking for drift
skill: subtitles
type: caption-timing
family: alignment
tags: [skill/subtitles, type/caption-timing, family/alignment, engine/ffmpeg, engine/hyperframes, source/research, source/hyperframes, difficulty/high]
source:
  - video: "research"
    timestamp: n/a
    quote: "ITU-R BT.1359-1: 'the threshold for detectability is 45 ms lead to 125 ms lag'. EBU R37: end-to-end +40 ms to -60 ms."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "fps is read per file, and never assumed — the reference set runs at three different frame rates across five files: 60, 25 and 29.97 fps."
research_refs:
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://en.wikipedia.org/wiki/SMPTE_timecode
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://github.com/m-bain/whisperX
difficulty: high
detectable_from: video
---

# Measure the offset, correct it once globally, and only then go looking for drift

## What it is

Captions drift out of sync in exactly three ways, and they need three different fixes. Applying the wrong one makes it worse, so the diagnosis comes first.

**1. Constant offset.** Every cue is late (or early) by the same amount. Causes: an alignment run against a differently-trimmed audio file, a head trim applied to picture but not to the transcript, a container with a non-zero start timestamp, a VAD pre-roll swallowing onsets. The fix is a **single global shift** applied to every cue.

**2. Linear drift.** The error grows proportionally with time. Causes: a frame-rate mismatch, almost always the 1000/1001 family. **NTSC's 29.97 fps means an hour of non-drop timecode is 3.6 seconds longer than an hour of wall clock** — that is 0.1 %, and it is exactly the drift you get when a cue sheet authored against a 30 fps assumption is played against a 29.97 fps master. It is invisible in the first 30 seconds and a full second out by minute 17. The fix is a **rate correction**, `t' = t × (30/30000·1001)` or the equivalent, not a shift.

**3. Scatter.** Individual cues are wrong by varying amounts with no trend. Cause: bad alignment, not bad sync. There is no global fix; go back to [[sub-alignment-qc-pass]].

**The tolerance to correct into.** Lip-sync perception research is the right yardstick even though captions are not lips, because the viewer is comparing a visual event to a heard word. ITU-R BT.1359-1 puts the **detectability threshold at 45 ms audio lead to 125 ms lag**; EBU R37 sets an acceptable end-to-end range of **+40 ms to −60 ms**; ATSC recommends audio leading video by no more than 15 ms and lagging by no more than 45 ms. The asymmetry is the useful part: **a caption arriving slightly late is far less noticeable than one arriving early**, because early text is a spoiler and the brain has no model for seeing a word before hearing it. So target a residual of **0 to +2 frames late**, never early.

DCMP's borrowing tolerance corroborates from the other direction: shifting captions **15 frames** before or after the audio is described as "hardly noticeable to the viewer" — that is 0.5 s at 30 fps, and it is the outer bound of what a deliberate shift can hide.

## When to use it

- After every alignment, as check six of the QC pass.
- Whenever the video has been **re-encoded, re-trimmed or conformed** to a different frame rate — 24 ↔ 23.976, 30 ↔ 29.97, 25 ↔ 24 all produce drift.
- Whenever a burned-in track and a sidecar disagree, or a client reports "the captions are late" without a timecode.
- Before shipping any programme over ~5 minutes, because linear drift is invisible in a short sample.
- **Do not** apply a global shift to fix a scatter problem; it moves the good cues off and leaves the bad ones bad.

## How to recognise it in a reference video

- **Measure at three places, not one.** Take five confident word onsets near the start, five near the middle, five near the end. For each, extract every frame around the caption change (`select='between(n,N1,N2)'`, `-fps_mode passthrough` — never `fps=`, which destroys the measurement) and compare the caption's change frame to the audio onset.
- **Read the pattern.** Constant error at all three points = offset. Error growing linearly = drift; compute the slope in ms per minute and compare it to 0.1 % (60 ms per minute) which is the 1000/1001 signature. Random signs and magnitudes = scatter.
- **Reference bands.** A well-synced creator track measures within **±2 frames** of the onset throughout. **3–6 frames late** is common and passes unnoticed by most viewers. **Anything early is conspicuous** even at 2 frames.
- **The end-of-file check.** The single fastest drift test: measure one cue in the last 30 seconds. If it is fine and the middle was fine, there is no drift.
- **fps discipline.** Read the fps of the file you are measuring with `ffprobe` before converting anything. The reference set alone spans 60, 25 and 29.97.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `target_residual` | +1 frame late | 0 to +2 f | Late is cheap, early is conspicuous. |
| `detect_threshold_lead` | 45 ms | — | ITU-R BT.1359-1 detectability, audio lead. |
| `detect_threshold_lag` | 125 ms | — | ITU-R BT.1359-1 detectability, audio lag. |
| `acceptable_band` | +40 / −60 ms | — | EBU R37 end-to-end. |
| `max_deliberate_shift` | 15 frames | 6–15 f | DCMP's "hardly noticeable" borrowing bound. |
| `sample_points` | 3 × 5 words | 3 × 3–10 | Start, middle, end of programme. |
| `drift_signature` | 0.1 % (60 ms/min) | — | The 1000/1001 frame-rate family. |
| `drift_fix` | rate scale | scale / re-align | Never fix drift with a shift. |
| `offset_fix` | global shift | shift | Applied to every cue start and end equally. |
| `scatter_fix` | re-align | — | No global correction exists. |
| `post_fix_recheck` | required | — | A shift can push cues into the forbidden gap band or below the duration floor. |
| `fps_source` | `ffprobe` per file | — | Never assumed, never carried between files. |

## Reproduction prompt

```
Diagnose and correct caption sync for {{VIDEO}} against {{CUE_SHEET}}.

1. READ fps with ffprobe and record it. Convert nothing until it is known.
2. MEASURE at three sample points - the first 30s, the middle, the last 30s.
   At each, take 5 confident word onsets, extract frames with
   select='between(n,N1,N2)' and -fps_mode passthrough, find the frame where
   the caption changes, and compute error = caption_time - onset_time. Report
   mean and standard deviation per point.
3. DIAGNOSE. Three means agreeing within {{TOL}} = 1 frame -> CONSTANT
   OFFSET. Means growing monotonically with a slope near 0.1% of elapsed time
   -> LINEAR DRIFT from a 1000/1001 frame-rate mismatch. Standard deviation
   above 2 frames inside any point -> SCATTER.
4. CORRECT. Offset: subtract the mean error from every cue start and end,
   leaving a residual of +{{RESIDUAL}} = 1 frame late rather than zero.
   Drift: scale all cue times by the ratio of true to assumed frame rate; do
   NOT shift. Scatter: stop and re-run forced alignment.
5. RE-CHECK the duration floor, the forbidden 1-frame gap band and cut
   snapping - a global shift invalidates all three.

ACCEPTANCE TEST: post-correction error at all three points is between 0 and
+2 frames; no cue is early anywhere; the diagnosis and correction are written
into the QC report with the measured numbers; and no cue fell below the floor
or into the forbidden gap band as a result.
```

## Execution spec

**Nothing in HyperFrames corrects sync at render time.** There is no offset attribute, no caption sync surface, and `data-media-start` shifts *media into a clip*, not a cue array. The correction is arithmetic on the inlined cue array, applied once, before authoring.

That has one very useful consequence: because cue times are authored as literal seconds in the composition, a global shift is a one-line transform over the array and is trivially auditable. Apply it to the array, regenerate the composition, and keep the pre-correction array — never hand-edit the timeline positions in the GSAP code, because the cue array and the tween positions must not disagree.

The measurement tooling is the verified analysis chain:

```bash
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of csv=p=0 in.mp4
ffmpeg -v error -i in.mp4 -vf "select='between(n,1740,1770)'" -fps_mode passthrough -an out/n_%03d.png
ffmpeg -hide_banner -i in.mp4 -af "silencedetect=noise=-40dB:d=0.3" -vn -f null - 2>&1 | grep silence
```

Prefer `between(n,…)` to `between(t,…)`: frame indices remove the fps question from the extraction step, while `t` re-introduces exactly the rounding you are trying to measure and will drift on a 29.97 file. `-ss` before `-i` is a fast seek that lands near the request — never trust it to land on the correct side of a boundary; extract the window and pick from it.

**Recut interaction.** If the picture is recut, do not shift — regenerate. `transcript-cut.mjs` removes ranges from picture and transcript together, and after a mid-phrase removal there is no single offset that is correct on both sides of the cut. The same applies to `--cut-silence`: shortening inter-word gaps changes every subsequent word's time non-uniformly.

Cross-skill: the same ±2-frame binding window governs sound effects against picture in [[sfx-av-sync-binding-window]], and the two should agree — if the SFX pass and the caption pass disagree about where a beat is, one of them is measuring a different frame rate.

## Pairs with
[[sub-alignment-qc-pass]] · [[sub-forced-alignment-word-timings]] · [[sub-shot-change-snapping]] · [[sub-batch-generation-and-qc]] · [[sub-inter-cue-gap-and-chaining]] · [[sfx-av-sync-binding-window]] · [[pace-partial-pause-removal]] · [[motion-impact-frame-quantisation]]

## Failure modes
- **Shifting to fix drift.** Correct in the middle, wrong at both ends. Correction: diagnose first, scale for drift.
- **Shifting to fix scatter.** Moves the good cues off sync and leaves the bad ones bad. Correction: re-align.
- **Correcting to zero residual.** Half the cues then land early, which is the conspicuous direction. Correction: aim for +1 frame late.
- **Measuring at one point.** Cannot distinguish offset from drift. Correction: three sample points, always.
- **Measuring with `fps=` in the filter chain.** Resampling destroys the frame-level information being measured. Correction: `select='between(n,…)'` with `-fps_mode passthrough`.
- **Assuming 30 fps on a 29.97 master.** 60 ms of drift per minute; 3.6 seconds per hour. Correction: `ffprobe` per file.
- **Hand-editing timeline positions instead of the cue array.** The array and the composition disagree, and the next regeneration silently reverts the fix. Correction: correct the array, regenerate.
- **Shifting after snapping to cuts.** Every snap is now off by the shift. Correction: correct sync first, snap second.
