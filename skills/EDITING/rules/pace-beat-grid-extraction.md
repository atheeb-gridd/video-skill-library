---
id: pace-beat-grid-extraction
title: Extract the beat grid before you snap anything to it
skill: editing
type: pacing
family: music-sync
tags: [skill/editing, type/pacing, family/music-sync, layer/music, engine/ffmpeg, engine/epidemic, engine/hyperframes, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:45"
    quote: "I even try to make sure every single cut in my video is synced to some beat of the music."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:38"
    quote: "Every track has a little warm-up at the start — ignore that and start straight from the main beat."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:47"
    quote: "Well, you'll find that out by playing the music along with the video."
research_refs:
  - https://librosa.org/doc/latest/generated/librosa.beat.beat_track.html
  - https://aubio.org/manual/latest/cli.html
  - https://ffmpeg.org/ffmpeg-filters.html#lowpass
  - https://ffmpeg.org/ffmpeg-filters.html#astats
difficulty: medium
detectable_from: audio
---

# Extract the beat grid before you snap anything to it

## What it is
The measurement step that [[pace-cut-on-the-beat]] presumes and this stack does not provide. Beat-locking cuts requires two numbers — a **tempo** and an **anchor**, one absolute frame where a known downbeat lands — and everything else is arithmetic. Getting those two numbers wrong is invisible at author time and obvious at full speed: the whole section sits a few frames off the music and nobody can say why.

There are three ways to obtain the grid, and they are a ladder. Take the highest rung the material allows and record which rung you used:

1. **Metadata + hand-found anchor.** The library reports the BPM (`Recording.bpm`); you find the frame of the first main downbeat after the track's warm-up; the grid is `anchor + n × (1800 ÷ BPM)` frames at 30 fps. Exact, free, and correct for the great majority of library beds, which are produced to a constant grid.
2. **Beat tracking.** Run a tracker over the bed file and take the beat timestamps it emits. Necessary when the BPM is unknown, when the track has tempo drift or a rubato section, or when you are analysing a **reference video's** bed and have no metadata at all.
3. **By ear.** Count kicks over 20 seconds, three times, average. The method the source implies. It gives a tempo but no anchor precision, and it cannot follow drift.

The grid's payload is a list of absolute positions — never a step size to add repeatedly. At 128 BPM a beat is 14.06 frames at 30 fps; adding that number cut after cut accumulates about **16 frames of drift over 64 beats**, which is more than half a second of visible slip. Absolute positions cost nothing and cannot drift.

The other half of the job, and the one that silently ruins grids, is the **coordinate change**. A tracker reports times in the *bed file's* timeline. The bed sits in the composition at `data-start` and is trimmed into with `data-media-start`. So:

```
composition_time(beat n) = bed.data-start + ( file_time(beat n) − bed.data-media-start )
```

Skip that subtraction and every cut is off by the length of the warm-up you trimmed.

## When to use it
- Before any beat-locked sequence, montage, list run or B-roll section — this note runs first, [[pace-cut-on-the-beat]] runs second.
- Whenever a bed's BPM metadata is missing, or you suspect it is reported at half or double the felt pulse.
- In Mode A, on a reference video, to test whether its cuts are actually beat-locked. You cannot score cuts against a grid you have not built.
- When a beat-locked section that used to feel tight has drifted after a re-cut — re-extract rather than nudging cuts individually.
- When the bed is not machine-steady: a live-played track, a track with a tempo change at the drop, or a track assembled from stems. Rung 1 will be wrong on all of these.

Skip it entirely when nothing is being locked to the music. A bed under narration with content-led cuts needs a mood and a level, not a grid.

## How to recognise it in a reference video
Two distinct questions: *was this cut to a grid*, and *what grid*.

- **Build both candidate grids and score against each.** Synthesize a constant-BPM grid from the metadata plus a hand-found anchor, and separately extract a tracked grid. Score every detected cut by `|cut_frame − nearest_grid_frame|` against both.
  - Median offset **≤ 2 frames against the constant grid** → the editor used a fixed BPM grid. This is the common case.
  - Median **≤ 2 frames against the tracked grid but > 5 against the constant grid** → the bed drifts and the editor followed it. That is a DAW-marker workflow; it cannot be done by counting, so it is a strong craft signature.
  - Median **> 6 frames on both, uniformly distributed** → not beat-locked at all.
- **Check the subdivision before concluding anything.** Score against beat, half-bar (2 beats) and bar (4 beats) grids and take the tightest median. Bar-level locking is far more common in long-form than beat-level, and a video scored only against the beat grid will look "loosely locked" when it is in fact tightly locked to bars.
- **Inter-beat-interval stability tells you which rung you need.** From the tracked beat list, compute the standard deviation of successive intervals. **σ < 15 ms** over a 60-second window is a machine-steady library bed — rung 1 is sufficient and more accurate than the tracker. **σ > 40 ms** means real tempo movement and rung 1 will be wrong.
- **Octave errors are the tracker's characteristic failure.** If the extracted tempo is almost exactly 2× or 0.5× the metadata BPM, or the inter-beat interval implies a tempo far outside the band derived in [[pace-speech-rate-to-bpm-map]], the tracker has locked to the wrong metrical level. Re-run with the expected tempo as a prior rather than accepting it.
- **The anchor is the other characteristic failure.** Check whether the reference's section starts coincide with the bed's **first main beat** rather than its first audible sound. A consistent offset equal to the length of the track's intro across every section is the signature of an anchor set on the warm-up.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `rung` | 1 (metadata + anchor) | 1 · 2 (tracker) · 3 (by ear) | Record which one was used, in the design document. |
| `frames_per_beat` | 1800 ÷ BPM @30fps | 90→20 f · 100→18 f · 120→15 f · 150→12 f · 75→24 f | 1440 ÷ BPM at 24 fps; 3600 ÷ BPM at 60 fps. |
| `anchor` | first main downbeat after the warm-up | — | One absolute frame for the whole section. Never chain from cut to cut. |
| `grid_generation` | absolute (`anchor + n × fpb`, rounded per entry) | — | Round each entry from the absolute value, never cumulatively. |
| `subdivision_emitted` | beat, half-bar, bar | — | Emit all three columns; the consumer picks. |
| `tracker_hop` | 256 samples | 128–512 | aubio default. At 44.1 kHz, 256 = 5.8 ms = 0.17 frames at 30 fps — well inside tolerance. |
| `tracker_onset_method` | `specflux` | `default` · `hfc` · `energy` · `complex` · `specflux` | `hfc` and `specflux` are the useful ones for a percussive bed. `energy` fails on beds with a sustained pad. |
| `tempo_prior` | the BPM target from the speech-rate map | ±25% of it | Seeding the tracker with the expected tempo is the cheapest defence against octave errors. |
| `kick_isolation_filter` | `lowpass=f=180` | 120–250 Hz | Low-pass before tracking when the bed has dense mids, or when tracking a full mix. |
| `ibi_sigma_gate` | 15 ms | 10–40 ms | Above 40 ms, do not use a constant-BPM grid. |
| `grid_verification_span` | 32 beats | 16–64 beats | Compare the synthesized grid against the tracked beats over this span; disagreement must stay under 2 frames. |

## Reproduction prompt

```
Extract and verify the beat grid for bed {{BED_FILE}} as used in composition
{{COMP}}. Emit an absolute grid the cut pass can snap to. 30fps.

1. Record the bed's placement from the composition: BED_START (data-start,
   seconds) and BED_MEDIA_START (data-media-start, seconds). You will need
   both to convert file time to composition time.
2. RUNG 1 - try metadata first. Take BPM from the library result
   (Recording.bpm). Compute frames_per_beat = 1800 / BPM and
   bar_frames = 4 * frames_per_beat.
3. Find the ANCHOR. Locate the first main downbeat AFTER the track's warm-up,
   in file time, to the frame. Do not anchor on the first audible sound.
   Verify by extracting a 2-second window around it and reading the waveform
   or the astats peak trace:
     ffmpeg -ss <t-1> -t 2 -i {{BED_FILE}} -af "lowpass=f=180,astats=metadata=1:reset=1:length=0.02,
       ametadata=print:key=lavfi.astats.Overall.Peak_level" -f null -
   The frame with the first large peak after the warm-up is the anchor.
4. VERIFY the constant grid before trusting it. Run a tracker over the same
   file and compare 32 consecutive beats:
     aubiotrack -i {{BED_FILE}} -O specflux -H 256
   Compute the standard deviation of successive inter-beat intervals. If
   sigma < 15 ms AND the synthesized grid agrees with the tracked beats to
   within 2 frames over 32 beats, keep RUNG 1 and discard the tracked list.
   Otherwise fall back to RUNG 2 and use the tracked beat times directly.
5. Check for an octave error: the implied tempo must land within 25% of the
   BPM target derived from the speech-rate map. If it is almost exactly 2x or
   0.5x, re-run the tracker seeded with the expected tempo and take that.
6. Emit the grid as an absolute table, generated from the anchor, rounded per
   entry, never cumulatively. Columns: beat index, file seconds, composition
   seconds, composition frame, and a bar flag every 4 beats. Compute
   composition seconds as:
     comp_t = BED_START + (file_t - BED_MEDIA_START)
7. Write the table, the BPM, the anchor and the rung used into the design
   document. HyperFrames consumes the seconds column; the acceptance tests
   use the frame column.
8. ACCEPTANCE TEST: pick beats 1, 16, 32 and 64 from the emitted grid and
   check each against the audio by extracting a still of the waveform or by
   listening to a 0.5-second window centred on it - the transient must be
   inside the window. Then confirm the grid's last entry is within 2 frames
   of where the same beat would land if computed directly as
   anchor + n * frames_per_beat, proving no accumulated drift.
```

## Execution spec

**Rung 1 — synthesize (shell). Deterministic, absolute, no accumulation.**
```bash
BPM=100; FPS=30; ANCHOR_FILE_T=3.780; BED_START=126.0; BED_MEDIA_START=3.400; BEATS=128
python3 - <<PY
bpm, fps = $BPM, $FPS
anchor, bstart, bmedia, n = $ANCHOR_FILE_T, $BED_START, $BED_MEDIA_START, $BEATS
spb = 60.0/bpm
print("beat\tfile_s\tcomp_s\tcomp_f\tbar")
for i in range(n):
    ft = anchor + i*spb                      # absolute, not cumulative
    ct = bstart + (ft - bmedia)              # the coordinate change
    print(f"{i}\t{ft:.3f}\t{ct:.3f}\t{round(ct*fps)}\t{'BAR' if i%4==0 else ''}")
PY
```

**Rung 2 — track (external tools).** Both are documented and both are **listed in the execution contract as not verified present in this environment** — check before writing a spec that depends on them.
```bash
# aubio: beat timestamps in seconds, one per line
aubio tempo -i bed.wav                                   # single BPM estimate
aubiotrack -i bed.wav -O specflux -H 256 -B 512          # beat times
# low-pass first when the bed is dense or you are tracking a full mix
ffmpeg -i bed.wav -af "lowpass=f=180" -ar 44100 bed.kick.wav
aubiotrack -i bed.kick.wav -O hfc -H 256
```
```python
# librosa: tempo + beat times, seeded against octave errors
import librosa
y, sr = librosa.load("bed.wav", sr=22050, mono=True)
tempo, beats = librosa.beat.beat_track(
    y=y, sr=sr, hop_length=512,
    start_bpm=120.0,      # seed with the target from pace-speech-rate-to-bpm-map
    tightness=100,        # raise for a machine-steady bed, lower to follow drift
    units="time")
print(float(tempo), beats[:16])
```
`start_bpm` defaults to 120.0 and `hop_length` to 512 (≈23 ms at 22.05 kHz, ≈0.7 frames at 30 fps — acceptable, but re-run at `hop_length=256` if you need sub-half-frame anchors). `tightness` controls how strictly beats stick to the estimated tempo; a produced library bed wants it high, a live performance low.

**ffmpeg.** Isolation and anchor-finding only; this note never re-encodes picture.
```bash
# peak trace in 20 ms windows, kick band only - the anchor finder
ffmpeg -i bed.wav -af "lowpass=f=180,astats=metadata=1:reset=1:length=0.02,\
ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null -
```
`astats` reports Peak level, RMS level, Crest factor, Flat factor, Peak count and Noise floor; the `reset` option restarts the statistics every N windows, which is what turns it into a time series.

**HyperFrames.** The grid is consumed, not stored — **all authored time is seconds and there is no frame attribute**, so the seconds column is what gets pasted into `data-start` / `data-duration`. Two constraints to carry through:

- The **coordinate change is permanent**: if you later change the bed's `data-media-start` to fix its warm-up, every grid position moves. Recompute; do not nudge.
- Relative timing (`data-start="broll-1"`, meaning "start when that clip ends") removes rounding between adjacent clips, but has four silent failure modes that all resolve to `0` and none of which lint checks: **spaces around the operator are mandatory** (`"broll-1 - 0.2"`, never `"broll-1-0.2"`), an unresolved id resolves to 0, a target with no resolvable duration lands on the target's *start*, and a cycle resolves to 0. For a beat grid, absolute seconds are safer and self-documenting. Snapshot and verify either way.

**Epidemic Sound.** `SearchRecordings` returns `Recording.bpm` on every node, which is rung 1's input; sorting `{ by: "BPM", order: "ASCENDING" }` with `filter.bpm {min,max}` finds a track at an fps-friendly tempo. `Recording.stems` exposes DRUMS / BASS / MELODY / INSTRUMENTS — **the DRUMS stem is the single best input a beat tracker can have**, and taking it is cheaper and more reliable than low-passing the full mix. `EditRecording` with `loopable: true` extends a bed without a seam; re-extract the grid afterwards, because an edit changes the file's timeline.

**Remotion:** the grid would be a frame array consumed by `<Sequence from={...}>`; frames are native there. Not present in this project.

## Pairs with
[[pace-cut-on-the-beat]] · [[pace-speech-rate-to-bpm-map]] · [[pace-bpm-matched-music-selection]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-track-change-at-section-boundary]] · [[sfx-peak-on-the-cut]] · [[struct-music-arc-to-narrative-arc]] · [[motion-explainer-beat-animation]] · [[pace-split-edit-cadence]]

## Failure modes
- **Anchoring on the warm-up.** Every library track has an intro — a riser, a sparse bar, a fade-in. Anchoring on the first audible sound puts the entire grid off by the length of that intro, consistently, across the whole section. Fix: anchor on the first main downbeat, and skip the warm-up with `data-media-start`.
- **Forgetting the coordinate change.** File time is not composition time. `comp_t = data-start + (file_t − data-media-start)`. Fix: compute it once in the grid generator, never by hand per cut.
- **Chaining the step size.** Adding frames-per-beat cut after cut accumulates rounding error — roughly 16 frames over 64 beats at a non-integer grid. Fix: generate absolute positions from the anchor, rounding each entry from the absolute value.
- **Accepting an octave error.** A tracker reporting 172 BPM for an 86 BPM bed produces a grid that is right twice as often as it should be, so every second cut looks correct and the section still feels wrong. Fix: seed the tracker with the expected tempo and sanity-check against the speech-rate-derived band.
- **Using a tracker on a machine-steady bed.** Trackers introduce a few milliseconds of jitter that a constant grid does not have. On a bed with σ < 15 ms of inter-beat variation, rung 1 is *more* accurate than rung 2. Fix: verify, then discard the tracked list.
- **Tracking the full mix instead of the bed.** Narration transients confuse onset detection badly. Fix: analyse the bed's own file, or the DRUMS stem; low-pass at 180 Hz only as a last resort.
- **Re-cutting without re-extracting.** Any change to the bed's placement or trim invalidates the whole grid. Fix: store the anchor and BPM in the design document and regenerate, rather than nudging individual cuts.
- **Known gap:** neither `aubio` nor `librosa` is verified present in this environment, and the execution contract states plainly that HyperFrames provides **no beat detection and no automatic waveform sync**. Rung 1 with a hand-found anchor is the only path guaranteed to work on the authoring VM. Say which rung was used in the design document, and treat rung 2 as an optional accelerator, not a dependency.
