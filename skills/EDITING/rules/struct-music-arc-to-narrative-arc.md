---
id: struct-music-arc-to-narrative-arc
title: Land the music drop on the problem-to-solution turn
skill: editing
type: structure
family: music-sync
tags: [skill/editing, type/structure, family/music-sync, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/editing-kt, source/editing-kt-3, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:13:43
    quote: "Don't just match the mood of the song to the tone of the segment, level up your music by syncing the highs and lows of the song to the video. In this segment, for example, I introduced the problem right here and started explaining the solution here. I arrange things so the music drops in at exactly that moment."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:32
    quote: "Whenever you're starting a new section, try to make the opening beat of your music line up with that section."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:05:15
    quote: "And the craziest thing — go to Create Version and you can pull out an edited track by adding or removing sections however you want."
research_refs:
  - https://www.toolsforfilm.com/blog/bpm-and-picture-editors-guide
  - https://www.epidemicsound.com/tools/customize/
  - https://www.scoringnotes.com/tips/video-tempo-and-time-oh-my/
difficulty: high
detectable_from: transcript+video
---

# Land the music drop on the problem-to-solution turn

## What it is
Mood-matching picks a track whose feel suits a segment. This is the level above it: the song's **dynamic arc** — build, drop, breakdown, outro — is aligned frame-accurately to the script's **narrative arc**, so the drop lands on the structural turn. In the source video the turn is problem → solution, and the drop is placed at exactly the frame the solution starts. It pays twice: the drop marks the topic change without a word being spent on it, and the solution segment inherits the song's energy lift.

## When to use it
Any segment that contains a *turn* the viewer needs to feel: problem → solution, before → after, the reveal at the end of a build, the pivot into the last third. It is also the correct move at every section boundary in a sectioned video, where the new track's first main beat is aligned to the first frame of the new section. Do not use it where there is no turn — a drop landing mid-explanation is worse than no drop, because it promises a change that does not arrive. It also needs a bed with a real arc; a flat loop has no drop to land.

## How to recognise it in a reference video
- **Find the turn from the transcript first.** Look for the pivot phrase: "so what do you do", "here's the fix", "but then", "and that's when". Note its frame.
- **Find the drop from the audio.** Plot short-term energy and look for the step change:
  `ffmpeg -i ref.mp4 -af "highpass=f=60,lowpass=f=180,astats=metadata=1:reset=15" -f null - 2>&1 | grep RMS_level`
  A drop shows as a ≥4 dB step in low-band RMS inside one analysis window, usually with the kick and bass entering together.
- **The test is the offset.** `|drop_frame − turn_frame| ≤ 4 frames (133 ms)` is a deliberate sync. 5–15 frames reads as "nearly", which the viewer feels as sloppiness. >15 frames is coincidence, not technique.
- **Corroborating signals at the same frame:** a hard picture cut, a scale change or B-roll entry, and often a whoosh or riser whose tail ends on the drop.
- **Riser leading in.** Check the 30–90 frames (1–3s) before the drop for a rising broadband sweep. A riser into the drop is the strong form of this technique.
- **Section boundaries.** In a sectioned video, log the offset between each new track's first main beat and the section's first frame. A consistent 0–3 frame offset across several sections is a signature, not luck.
- **Warm-up tell.** If a new track's ambient intro (pads, reverse cymbal, no kick) is audible *before* the section starts and the main beat lands on the section's first frame, the editor is trimming past the warm-up deliberately. If the warm-up occupies the first 2–4s *of* the section, they are not.
- **Music stop as the inverse.** A hard music stop on a serious line is the same idea inverted; check that the stop lands on a waveform peak rather than in a trough.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `drop_to_turn_offset` | 0f | −4f to +2f | Negative = drop leads picture. Audio leading is far less forgiving than lagging: detectability begins around 45 ms lead (≈1.3f) vs 125 ms lag (≈3.75f), so err late, never early. |
| `alignment_method` | slip the music | slip music \| trim picture \| re-version track | Slip first — it costs nothing. Trim picture only if the slip breaks a downstream sync. |
| `max_music_slip` | 2.0s | 0–8s | Beyond 8s you are usually better re-versioning the track. |
| `max_picture_adjust` | 12f (0.4s) | 0–30f | Extend or trim the outgoing shot; if the gap is larger, insert a B-roll beat rather than stretching a hold. |
| `warmup_trim` | trim to first main beat | 0–8s of source | Author as `data-media-start`. Find the first kick, not the first sound. |
| `riser_length` | 45f (1.5s) | 30–90f (1–3s) | Riser tail ends ON the drop frame, not after it. |
| `bed_level_pre_drop` | 0.079 (≈−22 dB) | 0.056–0.100 (−25 to −20 dB) | Linear `data-volume`; under narration, carve rather than duck. |
| `bed_level_post_drop` | 0.100 (≈−20 dB) | 0.079–0.126 (−22 to −18 dB) | A 2 dB lift on the drop is plenty; the arrangement does the work. |
| `section_boundary_tolerance` | 0f | 0–3f | For new-track-on-new-section alignment. |
| `crossover_style` | riser bridge | riser bridge \| find-similar butt-join \| hard stop + silence | Use find-similar when the vibe is continuous; riser when the vibe changes. |

## Reproduction prompt

```
Align the music's dynamic arc to this segment's narrative arc.

1. From the transcript, identify the structural turn (problem -> solution,
   before -> after, build -> reveal). Set {{TURN}} = the frame of the first
   word of the solution/after/reveal clause. State it in the design doc.
2. In the chosen track, find the drop: the frame where the low band steps
   up >=4 dB and the kick and bass enter. Set {{DROP_SRC}} = that offset in
   seconds from the head of the source file. Also find {{BEAT1_SRC}}, the
   first main beat after the track's warm-up.
3. Compute music_start = {{TURN}}/30 - {{DROP_SRC}}. If music_start >= 0,
   place the bed at that composition time with data-media-start = 0.
   If music_start < 0, place the bed at 0 and set
   data-media-start = {{DROP_SRC}} - {{TURN}}/30, which also trims the
   warm-up. Never let the warm-up run inside the segment.
4. Verify the resulting offset: |drop_frame - {{TURN}}| must be <= 4 frames,
   and the drop must not LEAD the picture by more than 1 frame.
5. If the slip needed is > 8s, or the drop lands before the segment starts,
   re-version the track instead: request an edit whose target duration
   equals the segment length with the drop region pinned to the offset
   {{TURN}} inside the edit.
6. Optional riser: place a 45-frame (1.5s) riser so its LOUDEST frame is
   {{TURN}}, i.e. it starts 45 frames earlier. Riser at -15 dB relative to
   dialogue; kill the bed's tail under it if they fight.
7. ACCEPTANCE TEST: render 3 seconds either side of {{TURN}} and listen once
   with your eyes closed, then once watching. The drop and the picture
   change must be indistinguishable in time. If you can hear which came
   first, it is wrong. Also confirm no warm-up pad is audible before
   {{TURN}} - 90 frames.
```

## Execution spec

**Epidemic Sound (sourcing and re-versioning).** `EditRecording` *is* the "Create Version" feature, and its `requiredRegionsAtOffsets` field is the exact mechanism for landing a drop on a target frame:
```
SearchRecordings { query.topic: "cinematic build drop uplifting", filter.bpm {min:100,max:120},
                   filter.vocals: false, sort {by: RELEVANCE, order: DESCENDING} }
SearchSimilarToRecording { id: <chosen id> }          # for the next section's track
EditRecording { id: <recording id>, input: {
  targetDurationMs: <segment length ms>,
  forceDuration: true,
  requiredRegionsAtOffsets: [ { startMs: <DROP_SRC ms>, endMs: <DROP_SRC+20000 ms>,
                                offsetMsInEdit: <TURN ms> } ],
  preferenceRegions: [ { startMs: 0, endMs: <warmup ms>, preferenceType: AVOID } ],
  downloadAudioFormat: WAV, skipStems: true } }
```
Then `PollEditRecordingJob` until `COMPLETED`, and `DownloadRecordingEdit`. `recording.bpm` comes back on every search hit — record it, [[pace-cut-on-the-beat]] needs it. Stems (`DRUMS`, `BASS`, `MELODY`, `INSTRUMENTS`) are the fallback when no version lands cleanly: run the melody stem before the turn and add drums+bass at the turn, which manufactures a drop at an arbitrary frame.

**HyperFrames (placement).** Seconds only; the frame count is a comment. Turn at frame 1290 = 43.0s, drop 12.4s into the source:
```html
<audio id="bed-solution" src=".media/audio/bgm/solution-bed.wav"
       data-audio-group="music"
       data-start="30.6"            <!-- 43.0 - 12.4 : drop lands at 43.0s = frame 1290 -->
       data-duration="64"
       data-media-start="0"
       data-track-index="11"
       data-volume="0.079"          <!-- ~-22 dB -->
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:12.4,&quot;v&quot;:1},{&quot;t&quot;:12.5,&quot;v&quot;:1.27},{&quot;t&quot;:62,&quot;v&quot;:1.27},{&quot;t&quot;:64,&quot;v&quot;:0}]}]}"></audio>
```
Three contract facts that bite here: automation `t` is **clip-local seconds** and the lane **holds its first value backwards to the clip start**, so the `t:0` point is mandatory or the bed opens already at the wrong level; lane `v` on `volume` is 0..1 of the track's own level and *replaces* nothing (a GSAP `volume` tween would conflict — `audio_volume_double_automation`); and the `&quot;`-escaped double-quoted form is the one `carve.mjs` can see. Run `node <SKILL_DIR>/scripts/carve.mjs --comp index.html` after placement so the bed keeps its low end under narration instead of being ducked flat.

The picture-side counterpart is authored at the same number: the cut, punch-in or transition at the turn goes at `43.0` on the same timeline. There is no audio-follows-animation attribute — the coupling is the author writing 43.0 twice. If the visual turn lives in a sub-composition at scene-local `t`, the root-level bed needs `data-start = t + host data-start`.

**ffmpeg (measurement and any bake).** Locate the drop precisely by exporting the low band and reading RMS in 250 ms windows:
```bash
ffmpeg -i bed.wav -af "lowpass=f=180,astats=metadata=1:reset=8" -f null - 2>&1 | grep -n RMS_level
```
Physical trims are only needed for assets leaving the pipeline: `ffmpeg -i bed.wav -ss 12.4 -c copy bed.fromdrop.wav`.

**Riser bridge between mismatched tracks.** `SearchSoundEffects { query.term: "riser build up", filter.duration {min:1000,max:3000} }`; place per [[sfx-whoosh-transition-movement-reveal]]'s offset discipline with the peak on the turn frame.

**Remotion:** same arithmetic, frames native; no runtime in this project.

## Pairs with
[[pace-bpm-matched-music-selection]] · [[pace-cut-on-the-beat]] · [[pace-cut-density-from-viewer-intent]] · [[sfx-whoosh-transition-movement-reveal]] · [[struct-numbered-list-mid-roll-sponsor]] · [[cut-punch-in-emphasis]] · [[sfx-riser-anticipation-build]] · [[sfx-music-audition-against-picture]]

## Failure modes
- **Drop leads the picture.** Even 3 frames early reads as a mistake, because audio-early is roughly 3× more detectable than audio-late. Fix: bias the offset to 0 or +1 frame, never negative beyond 1.
- **The warm-up runs inside the new section.** Two seconds of pad before the beat makes the section start feel soft. Fix: `data-media-start` at the first main beat, or `preferenceRegions: AVOID` over the intro when re-versioning.
- **Lifting the bed level to create the drop.** A +6 dB fader move is not a drop, it is a volume jump; the viewer hears the mix, not the song. Fix: use the arrangement (real drop, or drums+bass stems entering), and keep the fader change ≤2 dB.
- **Ducking the whole bed under narration instead of carving.** The bed loses its low end exactly where the drop needs it. Fix: `data-fx-carve` against the `voiceover` group at `strength: 0.25`; if it sounds notched rather than quieter, the strength is too high.
- **Stretching a picture hold to reach the drop.** Produces a dead 20-frame stare. Fix: slip the music (free) or insert a B-roll beat; cap picture adjustment at 12 frames.
- **Known gap:** nothing in this stack does automatic beat or drop detection. The drop frame is found by measurement (`astats`) or by hand, and there is no waveform-sync or drift correction to fall back on. Record `{{DROP_SRC}}` in the design document so the number survives a re-cut.
