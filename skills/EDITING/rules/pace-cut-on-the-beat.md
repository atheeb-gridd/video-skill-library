---
id: pace-cut-on-the-beat
title: Put every cut on a beat of the bed
skill: editing
type: pacing
family: music-sync
tags: [skill/editing, type/pacing, family/music-sync, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:53
    quote: "And I definitely try to make sure every single cut in my video is synced to some beat of the music."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:45
    quote: "One more thing I do is: even when my B-rolls are running, I try to sync them to the beat of my music."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:32
    quote: "Whenever you're starting a new section, try to make the opening beat of your music line up with that section."
research_refs:
  - https://www.toolsforfilm.com/blog/bpm-and-picture-editors-guide
  - https://support.audacityteam.org/music/aligning-music-to-beats-and-measures
  - https://vidpros.com/video-clip-length/
difficulty: medium
detectable_from: transcript+video
---

# Put every cut on a beat of the bed

## What it is
Once a bed's tempo is fixed, the beat grid becomes the timeline's ruler: every B-roll entry, every B-roll exit and ideally every hard cut lands on a beat. The creator states both halves — B-roll cut to the beat, and "every single cut in my video is synced to some beat of the music" — and gives the reason: "it creates a vibe, it creates a whole flow." This is the placement counterpart to [[pace-bpm-matched-music-selection]]'s selection step. It is arithmetic, not feel: at 30fps, **frames per beat = 1800 ÷ BPM**, and a bar is four of those.

## When to use it
In any montage, B-roll sequence, list-item run, or high-energy section that has a bed underneath. Use it at **bar** level (every 4 beats) for explanatory and emotional passages, and at **beat** level only for genuine montage and action runs — cutting on every beat of a 120 BPM bed is a cut every 15 frames, which is a 4 CPS rhythm no explainer can sustain. Do **not** beat-lock A-roll dialogue cuts that must fall on clause boundaries: language wins over the grid, and the correct move there is to snap only the *B-roll* layer to the grid while the dialogue cuts stay where the words are.

## How to recognise it in a reference video
- **Build the grid, then test the cuts against it.** Establish the bed's BPM and the frame of one known downbeat (`anchor`). Grid frames are `anchor + n × 1800/BPM`.
- **Score every detected cut** by its distance to the nearest grid frame. Report the distribution, not a vibe:
  - median |offset| ≤ 2 frames → beat-locked, deliberate.
  - median 3–5 frames → loosely locked, or locked to a grid you have mis-estimated.
  - median > 6 frames, uniform distribution → not beat-locked.
- **Check which subdivision.** Compute offsets against beat, half-bar (2 beats) and bar (4 beats) grids and take the one with the tightest median. Bar-level locking is far more common than beat-level in long-form.
- **Layer split is a signature.** If B-roll entries are tight to the grid (≤2f) while A-roll cuts are loose (>6f), the editor locked one layer and not the other. Log both numbers separately.
- **Drift tells you the method.** Offsets that grow steadily across the section mean cuts were placed by counting frames from the previous cut (accumulating rounding error); offsets that stay flat mean they were placed from an absolute timecode list or snapped to markers. At 11.25 f/beat, 64 beats of counting accumulates roughly 16 frames of drift.
- **Section starts.** Check whether each new section's first frame coincides with the new bed's first main beat (not its first audible sound). A 0–3 frame offset there is the "opening beat lines up with the section" move.
- **Non-integer BPM tell.** If the bed is 100 or 120 BPM at 30fps, exact-frame locking is possible; a perfectly locked 128 BPM bed at 30fps (14.06 f/beat) means marker snapping, since counting could not have produced it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `subdivision` | bar (4 beats) | beat · half-bar (2) · bar (4) · 2-bar (8) | Bar for explanation, beat for montage. |
| `frames_per_beat` | 1800 ÷ BPM @30fps | 100 BPM → 18f · 110 → 16.36f · 120 → 15f · 128 → 14.06f | 1440 ÷ BPM at 24fps; 3600 ÷ BPM at 60fps. |
| `bar_frames` | 4 × frames_per_beat | 100 BPM → 72f (2.4s) · 120 BPM → 60f (2.0s) | The practical unit for long-form. |
| `snap_tolerance` | ±2f | 0–3f | A 2-frame shift on a single cut is invisible to all but the most analytical viewer. |
| `layers_locked` | B-roll only | B-roll only · B-roll + transitions · everything | "Everything" only in montage sections with no dialogue. |
| `anchor_frame` | first downbeat after warm-up | — | One absolute reference for the whole section. Never chain from cut to cut. |
| `max_accumulated_drift` | 2f | 0–4f | Recompute absolute grid positions rather than adding; if the grid is non-integer, expect and budget for this. |
| `section_start_offset` | 0f | 0–3f | Offset between a section's first frame and the bed's first main beat. |
| `beat_cut_min_length` | 15f (0.5s) | 12–30f | Do not beat-lock into shots shorter than 12 frames; they read as flashes. |
| `offbeat_use` | none | occasional | Landing a cut on the "and" (half-beat) is a deliberate accent; if it happens by accident it just reads as a miss. |

## Reproduction prompt

```
Beat-lock the cuts in section {{SECTION}} to the bed {{BED_ID}}.

1. Get the bed's BPM (the library reports it; otherwise count kicks over 20s
   x3). Compute frames_per_beat = 1800 / BPM at 30fps and bar_frames =
   4 x frames_per_beat. Write both into the design doc.
2. Find {{ANCHOR}}: the exact frame of the first main downbeat after the
   track's warm-up. This is the single reference for the whole section - do
   NOT chain offsets from cut to cut.
3. Generate an absolute grid as a list: {{ANCHOR}} + n * bar_frames for the
   whole section (use the beat grid instead only if this is a montage with
   no dialogue). Round each entry to the nearest whole frame at generation
   time, from the absolute value, never cumulatively.
4. Snap the B-roll layer: move every B-roll entry and exit to its nearest
   grid frame, provided the move is <= 6 frames. If a required move exceeds
   6 frames, leave that cut where the content demands and mark the row
   "content-led" in the design doc.
5. Leave A-roll dialogue cuts on their clause boundaries. Do not drag a word
   to hit a beat.
6. Sanity-check lengths: no beat-locked shot shorter than 12 frames. If the
   grid produces shots that short, step up one subdivision (beat -> half-bar
   -> bar).
7. ACCEPTANCE TEST: compute |cut_frame - nearest_grid_frame| for every
   snapped cut. Median must be <= 2 frames and no single snapped cut may
   exceed 3 frames. Then play the section start-to-finish at full speed and
   listen for the moment the cuts and the music separate - full-speed
   playback reveals drift that frame-stepping hides. Finally confirm the
   section's first frame sits within 3 frames of the bed's first main beat.
```

## Execution spec

**Generate the grid (shell).** Deterministic, absolute, no accumulation:
```bash
BPM=100; FPS=30; ANCHOR_F=3780; BARS=24
python3 - <<PY
bpm, fps, anchor, bars = $BPM, $FPS, $ANCHOR_F, $BARS
fpb = fps*60/bpm                      # frames per beat
for n in range(bars*4):
    f = round(anchor + n*fpb)          # absolute, not cumulative
    print(n, f, round(f/fps, 3))       # beat index, frame, seconds
PY
```
The seconds column is what HyperFrames consumes; the frame column is for the design document and the acceptance test.

**HyperFrames (assembly).** All authored time is in seconds — there is no frame attribute — so convert the grid once and paste seconds. A 100 BPM bar is 2.4s exactly, which is why 100 and 120 BPM are the friendliest choices at 30fps:
```html
<!-- B-roll run, bars of 2.4s, anchor at 126.0s -->
<video id="broll-1" src="b1.mp4" muted playsinline class="clip"
       data-start="126.0" data-duration="2.4" data-media-start="1.0" data-track-index="1"></video>
<video id="broll-2" src="b2.mp4" muted playsinline class="clip"
       data-start="128.4" data-duration="2.4" data-media-start="4.2" data-track-index="1"></video>
<video id="broll-3" src="b3.mp4" muted playsinline class="clip"
       data-start="130.8" data-duration="4.8" data-media-start="0.0" data-track-index="1"></video>
<!-- 2.4s = 72f, 4.8s = 144f (2 bars) @30fps -->
```
Relative timing can express the chain (`data-start="broll-1"` means "start when broll-1 ends"), which removes rounding error between adjacent clips — but it has four silent failure modes that all resolve to `0`: spaces around the operator are mandatory (`"broll-1 - 0.2"`, never `"broll-1-0.2"`), an unresolved id resolves to 0, a target with no resolvable duration lands you on its *start*, and a cycle resolves to 0. Nothing in lint checks any of it, so snapshot and verify. For a beat grid, absolute seconds are safer and self-documenting.

`data-track-index` is display only — it does not layer anything. B-roll over A-roll is CSS `z-index`.

If cuts carry transitions, budget the transition duration inside the bar: a `zoom-through` at its 0.4s default eats 12 frames of a 72-frame bar. Registry transitions extend the outgoing clip's `data-duration` and pull the incoming clip's `data-start` earlier by the transition length, which moves the visible cut point off the grid — so place the transition's **midpoint** on the beat, meaning `data-start` of the incoming clip = grid_frame − duration/2.

**ffmpeg.** Only if a beat-locked montage must be baked as a file: cut each shot with `-ss/-to` to the grid times and concat. `--copy`-style stream copy snaps to keyframes and will silently move your cuts off the beat; re-encode for frame accuracy.
```bash
printf "file '%s'\n" s1.mp4 s2.mp4 s3.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c:v libx264 -preset veryfast -crf 18 -c:a aac out.mp4
```

**Epidemic Sound.** Prefer a track whose reported `bpm` gives an integer frames-per-beat at your output fps (90/100/120/150 at 30fps): `SearchRecordings { filter: { bpm: {min:100,max:100} }, sort: {by: BPM, order: ASCENDING} }`. `EditRecording` with `loopable: true` gives a bed that can be extended without a seam if the section outgrows the track.

**Remotion:** frames are native, so the grid is expressed directly; no runtime in this project.

## Pairs with
[[pace-bpm-matched-music-selection]] · [[struct-music-arc-to-narrative-arc]] · [[pace-cut-density-from-viewer-intent]] · [[sfx-whoosh-transition-movement-reveal]] · [[cut-punch-in-emphasis]] · [[sfx-music-audition-against-picture]] · [[pace-beat-grid-extraction]] · [[pace-speech-rate-to-bpm-map]]

## Failure modes
- **Beat-locking dialogue.** Dragging a cut 8 frames to hit a beat clips a word or leaves a stutter; the viewer hears the compromise. Fix: lock B-roll, leave dialogue on clause boundaries, and mark those rows content-led.
- **Chaining offsets.** Adding frames-per-beat cut after cut accumulates rounding error — over 64 beats at a non-integer grid this exceeds half a second. Fix: generate absolute positions from a single anchor.
- **Cutting on every beat in an explainer.** 15-frame shots at 120 BPM is a 4 CPS rhythm that shreds comprehension. Fix: step up to bar level; reserve beat-level for montage.
- **Locking to the wrong anchor.** Anchoring on the track's first audible sound instead of its first main beat puts the whole grid off by the length of the warm-up. Fix: anchor on the first kick; trim the warm-up with `data-media-start`.
- **Forgetting the transition eats the bar.** A 0.5s crossfade centred on the next beat makes every shot 15 frames short of its slot. Fix: centre the transition on the grid frame and subtract half its duration from the incoming `data-start`.
- **Known gap:** this stack has no beat detection and no waveform sync. BPM comes from the library's metadata or from manual counting, and the anchor frame is found by eye/ear. Record BPM and anchor in the design document so a re-cut does not have to rediscover them.
