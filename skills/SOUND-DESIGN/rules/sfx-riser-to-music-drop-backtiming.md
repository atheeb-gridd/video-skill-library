---
id: sfx-riser-to-music-drop-backtiming
aliases: [sfx-riser-to-drop-alignment]
title: Back-time the riser from the music's drop — and use it to bridge two tracks
skill: sound-design
type: sfx
family: riser
tags: [skill/sound-design, type/sfx, family/riser, sfx/aesthetic, layer/sfx, layer/music, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/sfx-kt-2, source/editing-kt, source/editing-kt-3, source/research, difficulty/high]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:02:06
    quote: "Riser sounds are essential to build anticipation and tension. Before a jumpscare, before a big reveal, or before a drop in the music, a riser teases that something big is about to happen."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:06:58
    quote: "So first of all, if you're putting a sound effect on a cut, place the highest peak of the sound effect on the cut."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:24
    quote: "then stop the first track, put in a riser sound, and start the second track at the end of the riser."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:38
    quote: "Every track has a little warm-up at the start — ignore that and start straight from the main beat."
research_refs:
  - https://en.wikipedia.org/wiki/Drop_(music)
  - https://en.wikipedia.org/wiki/Precedence_effect
  - https://librosa.org/doc/latest/generated/librosa.beat.beat_track.html
  - https://aubio.org/manual/latest/cli.html
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://ffmpeg.org/ffmpeg-filters.html#ebur128
  - https://unison.audio/how-to-create-risers/
  - https://add.app/sound-effects/sound-design-for-trailers-hits-rises-drones-pulses/
  - mcp://Epidemic_sounds/EditRecording (requiredRegionsAtOffsets contract read from the live schema, 2026-08-28)
difficulty: high
detectable_from: audio
---

# Back-time the riser from the music's drop — and use it to bridge two tracks

## What it is
The riser has exactly three canonical destinations — a jumpscare, a big reveal, and a **drop in the music** — and the third is the only one where the destination is **not under your control**. A reveal happens on the frame you decide; a drop happens on the frame the composer decided, buried somewhere inside a three-minute file. So this placement inverts the usual workflow: **you find the drop first, then back-time the riser and, if necessary, the picture to meet it.**

A drop is structurally a release: a build-up of repeating elements, rising drum density and swelling volume, sometimes a bar of silence, then a sudden change of rhythm or bass line that is the loudest part of the track. Your riser is a second build sitting on top of the track's own build — which is why the level relationship matters as much as the timing.

**Two mechanisms make this possible and this note covers both.** The **measurement** route finds the drop in the audio and lays the edit against it. The **re-versioning** route goes the other way and makes the library move the drop: Epidemic's `EditRecording` accepts `requiredRegionsAtOffsets`, which forces a named region of the source recording to appear at a specified offset in the output. That turns "the drop is at 68.4 s and I need it at 42.0 s" from an intractable problem into one API call.

The same arithmetic covers the source's **track-to-track bridge**: when two sections' music is too different for a "find similar" handover, you *"stop track A, run a riser across the gap, and start track B from its first main beat at the end of the riser"* — skipping the track's warm-up with a media offset rather than a cut. Here the "drop" is track B's first downbeat.

The general riser doctrine — ramp lengths, the pre-peak notch, the density budget, the "a riser must be answered" rule — lives in [[sfx-riser-anticipation-build]] and is not repeated here.

## When to use it
- **A section boundary lands on or near a real drop** and you want the picture change to feel like the music caused it. The highest-value use, and it is worth moving the picture cut by up to half a second to get it.
- **The track's own build is weak** for the length of screen time you need. A library riser layered over the track's build gives you a build of any length.
- **Two tracks will not blend at a section change** — different key, different BPM band, different mood; a crossfade would sound like a mistake and `SearchSimilarToRecording` returned nothing usable. Stop track A, run the riser across the gap, start track B **on the riser's last frame** ([[sfx-beat-aligned-handover]], [[sfx-track-change-at-section-boundary]]).
- **A new section starts and you want its first frame to coincide with the incoming track's first main beat** — the strongest available section marker in a video with music.
- **The reveal and the drop are more than ~1 s apart and cannot both be moved.** Pick one. Two builds resolving a second apart is worse than either alone.

Do **not**:
- **Bridge two tracks that *do* blend.** That is what a similar-track handover is for, and a riser there announces an edit the audience did not need to notice. BPM delta ≤12 and matching mood → handover, not riser.
- **Stack a riser on a track that already builds.** An eight-bar EDM build plus a riser is two things saying "wait for it" and reads as mud. Use the track's build and put your effort into the ducking.
- **Aim at something that is not a real structural turn.** A loud chorus is not a drop; back-timing a riser into it spends the device on nothing ([[sfx-riser-credibility-budget]]).
- **Bridge with a riser more than once or twice in a video.** It is a loud device.

## How to recognise it in a reference video
**Find the drop by measurement, not by ear — two detectors, and their units are different, so do not carry a threshold between them.**

*Detector 1 — per-frame RMS step (finest resolution).* A drop is the largest positive RMS step in the track:
```bash
# per-frame RMS at 30fps (n=1600 @48kHz == one frame)
ffmpeg -i bed.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null \
 | grep -o '[-0-9.]*$' > rms.txt
awk 'NR>1{d=$1-p; if(d>m){m=d; f=NR}} {p=$1} END{printf "drop at frame %d = %.3f s, step %.1f dB\n", f, f/30, m}' rms.txt
```
A genuine drop shows a **single-frame step of ≥6 dB** with **≥1.5 s of monotonic rise immediately before it**, and often a 0.2–0.8 s dip (the "bar of silence") in the last two bars of the build.

*Detector 2 — short-term loudness step (matches broadcast practice).*
```bash
ffmpeg -i bed.wav -af ebur128=peak=true:framelog=verbose -f null - 2>&1 | grep "S:"
```
A drop shows **+3 to +8 LU** within one beat period (beat = 60/BPM seconds). A gradual +2 LU over four bars is a **build**, not a drop. The short-term window is 3 s, so its step is necessarily smaller than the single-frame RMS step — **+3 LU here and ≥6 dB there describe the same event.**

**Cross-check against the grid — a drop always lands on a downbeat.** Compute the bar length from the declared BPM (`bar = 240 / BPM` seconds in 4/4 — 2.4 s at 100 BPM, 2.0 s at 120 BPM) and confirm the detected time is an integer number of bars from the first downbeat. If it is not, you found a **fill**, not the drop. Where a beat tracker is available (`aubiotempo` for BPM, `aubiotrack` for beat times), the drop should sit within **±40 ms** of a beat; off-grid means it is an edit, not the track's own drop.

Then:
- **Measure the riser's peak against the drop frame.** Competent work puts them on the **same frame (±1)**. This is the single diagnostic that separates a designed alignment from a dragged-in file.
- **A layered riser is visible as a second envelope.** During the last 2–4 s before the drop the 2–8 kHz band rises faster than the full-band RMS. The track's own build is broadband; a library riser is bright.
- **Ramp length is readable from the spectrogram** — audible start to maximum. Clusters at **30 f (1 s)**, **60 f (2 s)**, **120 f (4 s)**, **240 f (8 s)**; beyond ~300 f it is a build with a musical reason.
- **The dip before the drop.** Look for a **4–8 dB** reduction in the bed 0.3–1.0 s before it. That is either the track's own arrangement or the editor's duck; either way it is what makes the drop land.
- **Tail behaviour at the join.** With the peak on the event frame, the riser's tail **necessarily overlaps** what follows: **0.10–0.30 s** of overlap is normal and correct. A riser that stops one frame *before* the payoff leaves an audible hole you hear as a stumble — the exception is a payoff that is a deliberate silence.
- **Picture correlation.** The picture cut, the riser's peak and the drop should be the **same frame ±1**. If picture and drop are 5+ frames apart the edit was not back-timed and it reads as a near-miss.
- **For the bridge variant, look for the gap.** Track A stops, **0.5–2.5 s** of riser-only (often with no bed at all), then track B enters. Two extra tells: track A stops **on a waveform peak**, not in a trough (a stop in a trough is heard as sudden), and track B's first audible content is its **main beat, not its intro pad**.
- **Density.** Count riser bridges: **0–2 per video**. Two within 60 s means the device is spent.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `T_DROP` | measured | — | The frame of the largest RMS step, snapped to the nearest downbeat. **Never estimated by scrubbing.** |
| `drop_step_min` (per-frame RMS) | +6 dB | +5 to +12 dB | Single-frame positive step, with ≥1.5 s of monotonic rise before it. |
| `drop_step_min` (short-term LU) | +3 LU | +2 to +8 LU | Within one beat period. A different metric from the row above — not interchangeable. |
| `grid_tolerance` | ±40 ms | ±0–60 ms | Drop-to-nearest-beat distance. Beyond this it is an edit, not the track's drop. |
| `riser_body` — bed running (the normal case) | 2 bars | 1–4 bars | **Bar-locked, not seconds-locked**, because the destination is musical. 2 bars = 4.8 s @100 BPM, 4.0 s @120 BPM. |
| `riser_body` — no usable grid | 2.0 s (60 f) | 1.0–8.0 s | The ladder: 1 s micro · 2 s standard · 4 s section change · 8 s act break. |
| `peak_vs_T_DROP` | 0 frames | −1 to 0 frames | **Err early, never late.** Not for detectability reasons — for collision: a drop is a payoff with its own transient, and a riser peak landing *after* it muddies both. (This is the same rule as a riser into a hit; a riser into a purely *visual* reveal errs the other way — see [[sfx-riser-anticipation-build]].) |
| `tail_overlap` | 0.15–0.20 s (4–6 f) | 0.10–0.30 s | Let the decay run under the drop's first beat so the seam is not audibly chopped. Set to **0 only** when the payoff is a deliberate silence. |
| `picture_cut_vs_T_DROP` | 0 frames | −1 to +1 frames | If picture cannot move, move the music instead (`requiredRegionsAtOffsets`). |
| `max_picture_slip` | 0.5 s (15 f) | 0–0.7 s | Beyond this the cut stops working for its own reasons; re-version the track instead. |
| `bed_dip_before_drop` | −5 dB (lane `v` 0.56) | −8 to −4 dB | From `T_DROP − riser_body + 0.2` to `T_DROP`, restored **on** the drop frame. Skip if the track already dips. |
| `riser_peak_level` | −13 dB rel. dialogue (`data-volume` 0.224) | −12 to −15 dB | Drop to −15 if the track's own build is strong; you are adding brightness, not level. |
| `pre_peak_notch` | −4 dB over 3 f | −3 to −6 dB, 2–4 f | Trailer-mix convention; makes the payoff read louder without more level. |
| `riser_low_trim` | `highpass` 80 Hz | 60–120 Hz | Higher than usual: **the drop's own sub must be unobstructed.** |
| `bridge_gap` | 1.2 s | 0.5–2.5 s | Riser-only window between track A's stop and track B's entry. |
| `a_stop_rule` | on a waveform peak | peak \| beat | Stop track A on a peak, not in a trough. |
| `b_entry` | first main beat | — | Skip the warm-up with a media offset; do not cut the file. |
| `b_media_start` | measured | 0–16 s | Offset into track B at which its main beat begins. |
| `bpm_delta_tolerance` | 12 BPM | 0–20 BPM | Within this and with matching moods, prefer a similar-track handover over a riser bridge. |
| `bridges_per_video` | 1 | 0–2 | Never two inside 60 s. |
| `targetDurationMs` on a re-version | section length + 4 s | ≤ 300000 | Hard API ceiling of 300 s. |

## Reproduction prompt
```
Land a riser on the music's drop at section boundary {{BOUNDARY}}, or use it to
bridge two tracks.

PART A - FIND THE TARGET FRAME
1. MEASURE THE DROP - do not scrub for it. Export the bed to WAV and run the
   per-frame RMS trace; take the largest single-frame positive step:
     ffmpeg -i bed.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
      ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
   Record T_DROP_FILE (seconds from file start). Cross-check with the short-term
   loudness curve (ffmpeg ebur128, look for >= +3 LU inside one beat period).
2. SANITY-CHECK IT: >= 1.5 s of rising level immediately before the step, and
   T_DROP_FILE an integer number of bars from the first downbeat, where
   bar = 240 / BPM. Take BPM from the Epidemic recording's bpm field. If bpm is
   0 the track is rubato and has no drop. If nothing qualifies, the track has no
   drop - do NOT invent one; use a reveal or a cut as the payoff instead.
3. CONVERT to the composition timeline:
     T_DROP_COMP = bed.data-start - bed.data-media-start + T_DROP_FILE

PART B - DECIDE WHO MOVES
4. (a) Picture can slip up to 0.5 s -> move the cut onto T_DROP_COMP.
   (b) Picture cannot move -> RE-VERSION the track. EditRecording with
       targetDurationMs (<= 300000), downloadAudioFormat "WAV",
       forceDuration true, skipStems true, maxResults 3, and
         requiredRegionsAtOffsets: [{
           startMs: T_DROP_FILE*1000 - 8000,
           endMs:   T_DROP_FILE*1000 + 12000,
           offsetMsInEdit: (T_CUT - bed_start)*1000 - 8000 }]
       Poll PollEditRecordingJob to COMPLETED, DownloadRecordingEdit
       {jobId, editId}, then RE-MEASURE the drop in the returned file - the
       arrangement changed and the old offset is meaningless.

PART C - PLACE THE RISER
5. SIZE IT IN BARS: body = 2 * (240 / BPM) seconds. Fetch with
   filter.tagSlugs ALL ["designed--riser"], duration min body*900 max 12000,
   term "clean sub build no impact". Prefer a title containing "No Impact" /
   "No Hit" - the drop supplies the impact.
6. MEASURE the riser file's own peak (same trace); call it RISER_PEAK. Then:
     data-start       = T_DROP_COMP - body
     data-media-start = max(0, RISER_PEAK - body)   (if negative, longer file)
     data-duration    = body + 0.20                  (tail OVERLAPPING the drop -
                                                      do NOT end one frame early)
     data-volume      = 0.224 ; group "sfx" ; its own track index
7. VOLUME LANE (clip-local seconds, explicit t=0 point mandatory):
     t=0 v=0.05..0.25 ; t=body*0.6 v=0.6 ; t=body-0.10 v=1.0 ;
     t=body-0.03 v=0.63 (the -4 dB pre-peak notch) ; t=body v=1.0 ;
     t=body+0.20 v=0
   Add a highpass node at 80 Hz so the drop's sub stays clear. If you must miss
   the frame, miss EARLY by one frame - a late peak collides with the drop's own
   transient.
8. DIP THE BED. On the bed's lane author an explicit v=1 point FIRST (a lane
   holds its first value backwards, so without it the bed starts already
   ducked), then v=0.56 shortly after the riser begins, hold, and v=1 ON the
   drop frame. Skip entirely if the track already dips into its own drop.

PART D - THE TRACK BRIDGE (only if you are changing tracks)
9. If the two tracks' BPMs are within 12 of each other and the moods match,
   STOP: use a similar-track handover instead.
10. Stop track A on a waveform peak, not in a trough. Trim its clip so its last
    sample is at that peak; do not fade it out over a trough.
11. Leave a gap of 1.2 s in which only the riser plays.
12. Find track B's first MAIN beat (typically 2-16 s in) and set its
    data-media-start to that time, so its first audible frame is the main beat.
    Set track B's data-start so that beat lands on T_DROP_COMP - the end of the
    riser.

ACCEPTANCE TEST: render and step the boundary frame by frame. (a) the riser's
loudest frame, the drop's first frame and the picture cut are the SAME frame
(+/-1); (b) the riser's tail overlaps the drop by 3-9 frames - no silent gap;
(c) riser soloed, the climb is monotonic apart from the authored notch;
(d) track B's first audible frame is a beat, not a pad; (e) mute the riser and
listen - the drop must still land; if the riser is the only thing making the
section change feel like a section change, the section change is not real;
(f) across 8 s the drop should feel inevitable, not startling - if it startles,
the riser was too short or too quiet, not too loud.
```

## Execution spec

**Placement spec.**

| | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Riser | starts `2 bars` early; **peak on the drop frame, 0 to −1 frames**; tail 4–6 frames past | −13 dB (`data-volume` 0.224), −15 dB if the track's own build is strong | bed −5 dB from riser start +0.2 s, restored **on** the drop frame |
| Bed (the drop itself) | its drop frame **is** the visual event frame, 0 offset | −22 dB (`data-volume` 0.079), carved against `voiceover` | returns to full at the drop |

**Detection (offline).** Nothing in HyperFrames detects a drop. `aubio`'s documented defaults, if it is available: `aubiotempo` hopsize **512** / bufsize **1024**; `aubiotrack` hopsize **256** / bufsize **512** / silence **−90 dB**; `aubioonset` method **hfc**, hopsize 256, bufsize 512; `aubiocut` threshold **0.3**. `librosa.beat.beat_track` returns `(tempo, beat_frames)`. **Both are in the "not verified present in this environment" category** (linux ARM64, no sudo), so treat the detection step as a documented pass whose *outputs* — BPM, beat grid, drop time — get written into the design document as constants. The Epidemic `bpm` field plus the ffmpeg step detector always work and should be the default route.

**Epidemic Sound.** Two calls: one to buy the riser, one to move the drop.

```json
// riser leg
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["designed--riser"] },
              "duration": { "min": 3000, "max": 12000 } },
  "query":  { "term": "clean sub build no impact" },
  "sort":   { "by": "POPULARITY", "order": "DESCENDING" }, "first": 12 }
```

```jsonc
// re-version the bed so its drop lands where the edit needs it
// EditRecording -> PollEditRecordingJob -> DownloadRecordingEdit
{ "id": "<recordingId>",
  "input": {
    "targetDurationMs": 96000,            // <= 300000, hard ceiling
    "downloadAudioFormat": "WAV",
    "forceDuration": true,
    "skipStems": true,                    // faster when you only need the mix
    "maxResults": 3,
    "requiredRegionsAtOffsets": [
      { "startMs": 60400, "endMs": 80400, "offsetMsInEdit": 34000 }
    ],
    "preferenceRegions": [
      { "startMs": 0, "endMs": 12000, "preferenceType": "AVOID" }
    ] } }
```

`requiredRegionsAtOffsets` is the capability that makes this note possible: it guarantees the named source region appears at `offsetMsInEdit` in the output. **Include ~8 s of the build before the drop and ~12 s after it inside the region**, or the join can land mid-phrase. `preferenceRegions` with `AVOID` keeps a long intro out of a short edit; `PREFER` pulls a favourite section in. `loopable: true` produces a seamless repeat when the section length is unknown. The job is asynchronous — poll `PollEditRecordingJob` for `COMPLETED` (statuses `PENDING`, `IN_PROGRESS`, `COMPLETED`, `FAILED`) then `DownloadRecordingEdit` with both `jobId` and `editId`. **Re-measure the drop in the returned file.**

For track B in a bridge, pick by BPM so the bridge is not also a tempo lurch:
```
SearchRecordings({ query: { term: "driving section change" },
                   filter: { bpm: { min: 100, max: 120 }, vocals: false }, first: 8 })
```
`Recording.bpm` comes back on every result — write it into the vibe brief. When the two tracks *are* compatible, use `SearchSimilarToRecording` on track A instead of a riser bridge. For a second riser later in the video use `SearchSimilarToSoundEffect` rather than the same file. Verified slugs: `designed--riser`, `designed--impact`, `designed--boom`; titles containing "No Impact" / "No Hit" are dry-ending risers, the right choice here. An unrecognised tag slug returns `meta.total: 0` — it fails closed.

**HyperFrames — the full bridge.** Three clips whose numbers all derive from one target frame:

```html
<!-- T_DROP_COMP = 184.00s. Track A stops on a peak at 182.80. Riser 2.0s. -->

<!-- Track A: hard out on a waveform peak, no trough fade -->
<audio id="bed-a" src=".media/audio/bgm/track-a.mp3" data-audio-group="music"
       data-start="96.0" data-duration="86.8" data-media-start="6.4"
       data-track-index="11" data-volume="0.079"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.5,&quot;v&quot;:1},{&quot;t&quot;:86.8,&quot;v&quot;:1}]}]}"></audio>

<!-- Riser: PEAK measured 2.40s, body 2.0s -> media-start 0.40, start 182.00 -->
<audio id="sfx-riser-bridge" src="assets/sfx/riser-clean-no-hit.wav" data-audio-group="sfx"
       data-start="182.0" data-duration="2.20" data-media-start="0.40"
       data-track-index="13" data-volume="0.224"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.05},{&quot;t&quot;:1.60,&quot;v&quot;:0.85},{&quot;t&quot;:1.90,&quot;v&quot;:1.0},{&quot;t&quot;:1.97,&quot;v&quot;:0.63},{&quot;t&quot;:2.00,&quot;v&quot;:1.0},{&quot;t&quot;:2.20,&quot;v&quot;:0}]}]}"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Clear the Drop&quot;,&quot;params&quot;:{&quot;frequency&quot;:80}}]}"></audio>

<!-- Track B: enters on its own main beat, which sits 7.85s into the file -->
<audio id="bed-b" src=".media/audio/bgm/track-b.mp3" data-audio-group="music"
       data-start="184.0" data-duration="120.0" data-media-start="7.85"
       data-track-index="12" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```

`182.0 + 2.0 = 184.0` — the identity that makes it a back-timed riser.

Contract points that bind this:
- **`data-media-start` is how you "ignore the track's warm-up"** — an offset into the source in seconds, no file cut, fully reversible.
- **Lane `t` is clip-local seconds** and a lane **holds its first value backwards to the clip start** and its last value forward to the end — hence the explicit `t:0` points on every lane, and the explicit final point on `bed-a` so it does not fade. A lane on an `<hf-audio-group>` bus is **composition** time; do not mix the two up.
- **All authored time is seconds**; there is no frame attribute. Convert at authoring time.
- **`bed-a`, `bed-b` and the riser are on different track indices.** Two `<audio>` on one index overlapping in time raise `duplicate_audio_track` — the beds do not overlap here by design, but the riser overlaps both.
- **The riser goes in the `sfx` group, never in `voiceover`**: a non-voice clip inside the carve group silently poisons the next carve re-analysis. Carve settings live on the **bed**, `sources` names a **group**, and `data-fx-carve` is clip-only (never on an `<hf-audio-group>`). Combining a `volume` lane with `data-fx-carve` on the same bed is fine — the carve writes its own `gain` stage and `fromCarve` nodes, separate from the lane; never hand-edit anything tagged `fromCarve`.
- **Never GSAP-tween `volume`** on a clip that has a `volume` lane — the lane wins and the tween is silently ignored (`audio_volume_double_automation`).
- **Every `<audio>` needs an `id`**, or it is never mixed → silent render.
- **There is no audio-follows-animation attribute.** `T_DROP_COMP` appears as a literal in three places: the riser's arithmetic, `bed-b`'s `data-start`, and the picture cut's timeline position. If the payoff lives in a sub-composition at scene-local `t`, the root-level audio needs `data-start = t + slot data-start`. Relative timing (`data-start="bed-a + 1.2"`) can express part of it — but **spaces around the operator are required**, an unresolved reference silently resolves to **0**, and a target with no resolvable duration lands on the target's **start**. Prefer literals and verify with a snapshot.
- **Avoid `reverb` / `delay` on the riser.** Effects with a tail make the rendered track longer than `data-duration` (`chainTailSeconds`) — expected, but it smears the drop.
- Max **512 points per lane**; out-of-range values are clamped on read; a lane whose `nodeId` is typo'd is **pruned on read** with no error. **Nothing validates the chain or the lanes** — render refuses an unparseable chain, preview plays it dry. Verify by rendering and listening.

**ffmpeg** — measurement, length-fitting, and baking:
```bash
# largest positive RMS step == the drop
ffmpeg -i bed.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
# short-term loudness curve, the cross-check
ffmpeg -i bed.wav -af ebur128=peak=true:framelog=verbose -f null -
# peak location inside the riser file
ffmpeg -i riser.wav -af "astats=metadata=1:reset=1:length=0.05,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
# fit a 3.9 s riser to a 4.8 s bar pair, pitch preserved (atempo 0.5-2.0, chainable)
ffmpeg -i riser.wav -af "atempo=0.8125" riser_4s8.wav
# pre-trimmed riser, if it must leave the pipeline
ffmpeg -i riser.wav -ss 0.40 -t 2.20 -af "volume=-13dB,afade=t=out:st=2.00:d=0.20" riser.cut.wav
```

**Remotion.** Measure the drop's frame, place the riser sequence `bodyFrames` before it: `<Audio src={riser} startFrom={12} />` inside `<Sequence from={dropFrame - 60} durationInFrames={66}>`. Portability note only.

## Pairs with
[[sfx-riser-anticipation-build]] · [[sfx-riser-hit-pair]] · [[sfx-riser-credibility-budget]] · [[sfx-music-drop-on-structure-turn]] · [[sfx-beat-aligned-handover]] · [[sfx-track-change-at-section-boundary]] · [[sfx-track-reversion-to-edit-length]] · [[sfx-cut-on-the-beat]] · [[sfx-peak-offset-measurement]] · [[sfx-bass-drop-under-impact]] · [[pace-beat-grid-extraction]] · [[pace-cut-on-the-beat]] · [[motion-beat-quantised-animation]] · [[sfx-vibe-brief]] · [[pace-bpm-matched-music-selection]] · [[struct-music-arc-to-narrative-arc]] · [[cut-audio-match]] · [[motion-list-item-marker-card]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-music-fade-out-section-signal]]

## Failure modes
- **Estimating the drop by scrubbing.** A drop is a single frame; scrubbing gets you within 5–10 frames, which is exactly the range where a near-miss reads as sloppiness. Measure it.
- **Riser placed by its start.** Rounding the in-point to a whole second lets the peak drift past the drop, and the payoff is heard as a stumble. Solve `data-start` from the measured peak, never place by ear.
- **Riser ends one frame before the drop.** Leaves an audible hole exactly where the momentum must be highest. 0.10–0.30 s of tail overlapping the drop; end early **only** when the payoff is a deliberate silence.
- **Riser peak late.** A drop is a payoff with its own transient; a riser peaking after it muddies both. Err early by a frame if you must miss.
- **Mistaking a chorus or a fill for a drop.** Without ≥1.5 s of monotonic build before the step, it is not a drop, and a riser into it makes a promise the track does not keep. A +1.5 LU swell over four bars is a build.
- **Off-grid alignment.** Landing the riser on a visually convenient frame 90 ms off the beat makes the whole join feel loose even when the picture cut is right. Snap within 40 ms; move the picture, not the music.
- **Forgetting to re-measure after `EditRecording`.** The edit is a different arrangement. Reusing the original drop offset puts the riser somewhere arbitrary.
- **Stacking a riser on a track that already builds.** Two builds cancel; the drop then arrives out of noise rather than out of tension.
- **No dip before the drop.** A drop is heard as *contrast*. If the bed runs flat into it, the arrangement's own dynamic range is the only contrast available, and on a phone speaker that is not much.
- **Riser sub fighting the drop's sub.** Both live below 120 Hz. Highpass the riser at 80 Hz or the drop's impact is halved.
- **Track B entering on its intro pad.** The section change is inaudible because nothing happens for two seconds. `data-media-start` at the first main beat.
- **Track A stopped in a trough.** Heard as a sudden cut-off. Stop on a waveform peak.
- **Riser bridge between compatible tracks.** Announces an edit that a similar-track handover would have hidden.
- **Two bridges close together.** Reads as a nervous tic and devalues both. 0–2 per video, never inside 60 s.
- **Exceeding the 300 s `targetDurationMs` ceiling.** The API refuses; a long-form video needs multiple edits, or the full track with in-composition trimming (`data-media-start` + `data-duration`, which costs nothing).
- **Known gap:** there is **no beat/downbeat detection in the stack** — no bundled analyser, and `aubio`/`librosa`/`madmom` are unverified on this ARM64 VM, with no-sudo blocking installation. The bar grid comes from arithmetic on the declared BPM, which fails on tracks with tempo changes; for those, back-time by measurement only and do not trust the grid. The detection pass must be treated as possibly running on another host, with BPM, beat grid and drop time recorded as constants in the design document.
- **Known gap:** no published standard specifies whether a riser's tail should overlap its payoff. The rule here derives from the creator's own convention (peak of the effect on the cut, which forces the overlap) plus general trailer-mix practice of trimming the tail short. It is a house rule, and a human may override it with a reason.
