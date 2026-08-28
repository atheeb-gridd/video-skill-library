---
id: sfx-cut-on-the-beat
title: Beat-locked cuts, from the audio side — the grid, the tolerance, and the collision with the kick
skill: sound-design
type: music
family: beat-grid
tags: [skill/sound-design, type/music, family/beat-grid, layer/music, layer/sfx, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/high]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:53
    quote: "And I definitely try to make sure every single cut in my video is synced to some beat of the music."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:45
    quote: "One more thing I do is: even when my B-rolls are running, I try to sync them to the beat of my music."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:38
    quote: "Every track has a little warm-up at the start — ignore that and start straight from the main beat."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:07:02
    quote: "It creates a vibe, it creates a whole flow."
research_refs:
  - https://librosa.org/doc/latest/generated/librosa.beat.beat_track.html
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://www.epidemicsound.com/music/search/
difficulty: high
detectable_from: audio
---

# Beat-locked cuts, from the audio side — the grid, the tolerance, and the collision with the kick

## What it is
When cuts are snapped to the bed's beat grid, the sound design inherits the grid whether you plan for it or not. Every cut that gets a sound — a whoosh, a transient, a hit — now places that sound on a beat, which is exactly where the bed already has its loudest events. Two transients arriving on the same frame do not add up to twice the impact; the louder one masks the quieter, and the usual casualty is your effect.

So this note is the audio half of a technique whose picture half lives in [[pace-cut-on-the-beat]] and whose grid extraction lives in [[pace-beat-grid-extraction]]. It covers three things those notes do not: where the grid actually comes from in this stack (an exact integer BPM on the fetched recording, plus an anchor you must find), what counts as on-beat perceptually, and what to do about the collision between your effects and the bed's own drums.

**Style.** No `sfx/` style tag: this is a grid-collision rule that applies to whatever accent lands on the beat — most often a motion whoosh or transient ([[sfx-peak-on-the-cut]]), sometimes an aesthetic hit ([[sfx-cinematic-hit-emphasis]]).

## When to use it
- **Any section with a bed under it where cuts have been snapped to the grid.** The moment the picture is quantised, the sound pass has to be planned rather than improvised.
- **Montage and B-roll runs**, which is where the source applies it most explicitly, and where SFX density is highest.
- **At a section boundary**, where the new track's first main beat is being landed on the first frame of the section ([[sfx-track-change-at-section-boundary]]) — the boundary is the one place a hit on the beat is *wanted*, because the collision reads as emphasis.
- **When beat-locked cuts sound flat despite being perfectly aligned.** That is the masking symptom, not a timing problem, and moving the cut will not fix it.
- **Not on A-roll speech cuts.** Language wins: a jump cut in narration goes where the clause ends. Snap only if a beat happens to fall within ±120 ms of the natural seam.
- **Not in a rest window.** With no bed there is no grid, and imposing one is arbitrary ([[sfx-music-rest-windows]]).

## How to recognise it in a reference video
- **Get the tempo, then the anchor, then test.** `librosa.beat.beat_track` gives both tempo and a beat list in one pass; convert with `librosa.frames_to_time`. Do not add a step size repeatedly — use absolute positions, or rounding drifts.
- **Score cuts against the grid** exactly as [[pace-beat-grid-extraction]] describes, but also score the **sound events**: run the per-frame peak trace, list every transient rising ≥8 dB above its 10-frame neighbourhood, and measure each one's distance to the nearest beat.
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
   ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
  ```
- **The diagnostic ratio is `sfx_on_beat_fraction`.** In a beat-locked reference, cut sounds sit on beats because the cuts do; what separates a good mix from a mushy one is that the *effects are still audible there*. Check by soloing: if a transient is within 2 frames of a beat and rises less than 6 dB above the bed at that frame, it is being masked.
- **Listen for what was done about it.** Three signatures, all detectable:
  1. **Spectral separation** — the effect lives above 2 kHz where the kick is not (a bright swish over a low kick).
  2. **Sub-beat offset** — the effect sits deliberately 3–6 frames before the beat, arriving *into* it.
  3. **Stem thinning** — the bed's drum content drops for 0.2–0.4 s around the hit. Visible as a level dip in the 60–120 Hz band with no dip in the mids.
- **Bar-level, not beat-level, is the norm.** At 100–120 BPM a beat is 500–600 ms; cutting every beat is 100–120 cuts a minute. Real long-form locks to bars (2.0–2.4 s at those tempos).
- **Warm-up check.** Look at whether the section's first frame coincides with the track's first *main* beat rather than its first audible sound. A 0.5–3 s intro swell that was not trimmed is the commonest reason a whole section sits off-grid.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Beat period | `60 ÷ BPM` s | — | At 100 BPM = 0.600 s; 110 = 0.545 s; 120 = 0.500 s. Bars are 4×. |
| Grid subdivision for cuts | 1 bar | ½ bar – 1 bar | Beat-level only in genuine montage. |
| On-beat tolerance | ±1 frame (33 ms @30fps) | ±0 … ±2 frames | Grounded in AV-sync detectability: audio leading picture is detectable from 45 ms, lagging from 125 ms. Two frames early is already at the edge; two frames late is safe. |
| Snap threshold | 80 ms | 60–120 ms | If the content's natural cut point is further than this from a beat, leave it where the content wants it. Do not drag a cut a quarter of a second to hit a beat. |
| SFX offset when colliding | −4 frames | −6 … 0 frames | Arriving into the beat rather than on it. Never place the effect *after* the beat to dodge the kick. |
| Required SFX headroom over bed | 6 dB | 4–10 dB | At the effect's own peak frame, measured with the bed soloed vs the effect soloed. |
| Drum-stem dip around a hit | −6 dB for 0.3 s | −4 … −9 dB, 0.2–0.4 s | Only available when the track was fetched with stems. |
| Anchor precision | ±1 frame | — | Find the first main downbeat by hand or by tracker; the whole grid inherits this error. |
| Coordinate conversion | required | — | `composition_time = bed.data-start + (file_time − bed.data-media-start)`. |

## Reproduction prompt
```
Plan the sound pass for a section whose cuts are locked to the bed's beat grid.

1. GET THE GRID.
   a. Take BPM from the fetched recording's metadata (Epidemic returns
      recording.bpm as an exact integer). beat_period = 60 / BPM.
   b. Find the anchor: the composition time of the first MAIN downbeat after the
      track's warm-up. Do not use the file's first audible sample. If unsure, run
      librosa.beat.beat_track on the bed file and take the first stable beat.
   c. Convert file time to composition time:
      composition_time = bed.data-start + (file_time - bed.data-media-start)
   d. Emit grid[n] = anchor + n * beat_period as ABSOLUTE seconds. Never add the
      period repeatedly; rounding accumulates.
2. QUANTISE ONLY WHAT SHOULD BE QUANTISED. Snap B-roll, graphic and transition
   cuts to the nearest grid position when the move is <= 80 ms. Leave A-roll
   speech cuts on their clause boundaries.
3. LIST THE SOUND EVENTS that now fall on beats: every cut with a whoosh, every
   hit, every transition sound.
4. RESOLVE COLLISIONS, one of three ways, chosen per event:
   - SEPARATE: pick an effect whose energy is above 2 kHz (a bright swish rather
     than a low whoosh) when the bed's kick is on that beat. Preferred default.
   - OFFSET: move the effect 3-6 frames EARLIER so its body arrives into the beat
     and its peak lands on it. Never later.
   - THIN: if the track was fetched with stems, duck the DRUMS stem by 6 dB for
     0.3 s around the hit via a volume lane, leaving MELODY and BASS untouched.
   Use at most one bass-heavy event per bar; two low transients in a bar is mud.
5. VERIFY HEADROOM. At each event's peak frame the effect must be at least 6 dB
   above the bed. If it is not, apply one more resolution step - do not simply
   raise the effect, which breaks the -12/-15 dB SFX band.
6. ACCEPTANCE TEST: (a) every quantised cut is within 1 frame of a grid position;
   (b) no effect sits later than its beat; (c) each effect clears the bed by >= 6 dB
   at its peak; (d) with the picture muted, the effects sound like part of the
   arrangement, not like taps on top of it.
```

## Execution spec

**Epidemic Sound.** The grid starts at fetch time, not at edit time. `SearchRecordings` returns `recording.bpm` as an exact integer on every node, so the tempo never has to be estimated for a library bed:
```json
{ "filter": { "bpm": { "min": 100, "max": 120 }, "vocals": false,
              "moodSlugs": { "matchType": "ANY", "values": ["epic"] } },
  "sort": { "by": "BPM", "order": "ASCENDING" }, "first": 20 }
```
Results also carry `stems[]` with `DRUMS`, `BASS`, `MELODY`, `INSTRUMENTS` (and `VOCALS`/`CLEAN_VOCALS` where present) — that is what makes the "thin the drums under the hit" resolution possible at all, and it must be decided at fetch time because a stereo bounce cannot be un-mixed later. `DownloadRecording` for the mix, or the stem you need. **Known environment gap:** in this project `audiocdn.epidemicsound.com` is blocked by the egress allowlist (verified: 403 on CONNECT), so the signed `assetUrl` has to be fetched from a host that allows it before placement.

**Hyperframes.** Authored time is seconds, so the grid is written directly as `data-start` values — there is no frame attribute and no snapping. Compute the seconds, write them, and keep the arithmetic visible in a comment:
```html
<!-- 112 BPM, beat = 0.5357 s, bar = 2.1429 s, anchor 4.310 s -->
<video id="broll-3" src="..." muted playsinline
       data-start="8.596" data-duration="2.143" data-track-index="0"></video>

<!-- swish arriving INTO the beat: peak at 8.596, 4 frames of body before it -->
<audio id="sfx-swish-3" src="assets/sfx/swish-bright.wav" data-audio-group="sfx"
       data-start="8.463" data-duration="0.55" data-media-start="0.08"
       data-track-index="12" data-volume="0.5"></audio>
```
Thinning the drum stem is a `volume` lane on the drums clip, in clip-local seconds, with an explicit `t: 0` point so the lane does not hold the dip backwards to the start:
```
{"version":1,"lanes":[{"target":"volume","points":[
 {"t":0,"v":1},{"t":8.4,"v":1},{"t":8.55,"v":0.5},{"t":8.85,"v":0.5},{"t":9.0,"v":1}]}]}
```
Write these attributes double-quoted with `&quot;` so `carve.mjs` can see them, and never pair a `volume` lane with a GSAP `volume` tween on the same element — the lane silently wins.

**ffmpeg / analysis.**
```python
import librosa
y, sr = librosa.load("bed.wav")
tempo, beats = librosa.beat.beat_track(y=y, sr=sr)
times = librosa.frames_to_time(beats, sr=sr)   # file seconds -> convert to comp time
```
For the collision check, the per-frame peak trace above, run once on the bed alone and once on the effect alone, and subtract.

**Remotion.** Same arithmetic, expressed in frames because Remotion is frame-native (`fps × 60 / BPM` frames per beat). Portability note only; Remotion is not part of this stack.

## Pairs with
[[pace-cut-on-the-beat]] · [[pace-beat-grid-extraction]] · [[sfx-track-change-at-section-boundary]] · [[sfx-music-stem-layering]] · [[sfx-bpm-filter-first]] · [[sfx-emotion-and-pace-diagnosis]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-bass-drop-under-impact]] · [[sfx-full-screen-transition-sound-layer]] · [[sfx-density-fatigue-audit]] · [[motion-beat-quantised-animation]] · [[sfx-riser-anticipation-build]]

## Failure modes
- **Effects on beats, inaudible.** The commonest outcome of naive beat-locking: every whoosh lands exactly where the kick is and disappears under it. Fix by spectral separation first, offset second, stem thinning third — not by turning the effect up.
- **Nudging effects late to dodge the kick.** Audio arriving after its picture event is tolerated up to 125 ms, but a *late* effect on a beat-locked cut reads as sloppy sync rather than as a design choice. Offset early, into the beat.
- **Anchoring on the file's first sample.** The track's warm-up is not the downbeat. Every downstream cut inherits the error, and the section sits uniformly off by the length of the intro.
- **Adding the beat period repeatedly.** At 128 BPM (0.469 s) the accumulated rounding is visible within a minute. Emit absolute positions.
- **Beat-level cutting in an explainer.** 100–120 cuts a minute is unwatchable regardless of how well it is synced. Lock to bars.
- **Dragging speech cuts onto the grid.** Clipped syllables and unnatural pauses. The grid governs B-roll and graphics; language governs A-roll.
- **Forgetting the coordinate conversion.** A tracker reports file time; the bed is placed at `data-start` and trimmed with `data-media-start`. Skipping the subtraction offsets the entire grid by the trim.
- **Known gap:** nothing in the stack snaps, quantises, or validates against a beat grid. It is arithmetic the author performs and writes into `data-start`; the only verification is a render and a listen, on a browser-capable host.
