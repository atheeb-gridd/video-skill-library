---
id: sfx-ambience-establishes-location
title: Ambience tells the viewer where they are — building the bed, not just finding it
skill: sound-design
type: sfx
family: ambience
tags: [skill/sound-design, type/sfx, family/ambience, engine/hyperframes, engine/epidemic, engine/ffmpeg, sfx/diegetic, layer/ambience, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:00:54
    quote: "If I play you traffic noise, you'll tell me without even looking that this video was shot on a road. If I play a train sound, you'll say it was recorded inside a train."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:00:44
    quote: "So to add some, here comes layer number two: ambient sounds. These are the sounds that build your scene."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:09:41
    quote: "Even in movies they use the sounds of that real location, so that you feel like you're actually there."
research_refs:
  - https://en.wikipedia.org/wiki/Room_tone
  - https://en.wikipedia.org/wiki/Walla
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (ambience-- shelf slugs, loop-tagged titles and durations probed live, 2026-08-28)
difficulty: low
detectable_from: audio
---

# Ambience tells the viewer where they are — building the bed, not just finding it

## What it is
Layer 2's job is scene construction, and its defining property is that it works **with the picture switched off**: *"If I play you traffic noise, you'll tell me without even looking that this video was shot on a road."* Location information travels in the ambience channel independently of the image, which makes a bed the cheapest way to make a scene feel like a real place — and its absence is one of the named sound-design mistakes in the source corpus.

This note is the **placement** half of the job: level, continuity, looping, seams, and filtering. The **selection** half — the `<place> + ambience` search formula and the three cases where it fails (walla, room tone, nature-by-place) — lives in [[sfx-ambience-search-formula]]. Fetch there; lay the bed here.

Four properties separate a bed that works from a file that plays:

1. **It is continuous across cuts.** A bed belongs to the *place*, not to the shot, so its clip spans every cut inside that place. Cutting the bed at the picture cut is what produces the noise-floor step that makes an edit sound like an edit ([[sfx-hard-cut-audio-seam]]).
2. **It is quiet enough to be information and not texture.** A bed sits **under** the music, which already sits ~22 dB under dialogue. That puts ambience around **−28 dB relative to dialogue**; loud enough to change how the scene feels, too quiet to compete.
3. **It is eventless, or its events are chosen.** A bed with a distinctive horn, laugh or bark becomes a *loop* the moment it repeats — the same event at an exact interval is the single clearest tell of a short file on repeat. Long, diffuse recordings and true room tone are the safe material; anything with a signature event needs a file at least as long as the scene.
4. **It stays out of the voice's way.** Crowd murmur (**walla**) is by nature concentrated in the 300–3400 Hz speech band, so it masks dialogue far more efficiently than traffic rumble does at the same level. Masking research is blunt about the asymmetry: low-frequency maskers are *"effective over a wide frequency range"* while *"high frequency maskers are only effective over a narrow range"*, and the spread of masking runs **upward** in frequency as level rises. Practical consequence: rumble-heavy beds need a high-pass; speech-band beds need to be 4–8 dB quieter than you first think.

## When to use it
- **Under every shot that claims a location.** Talking-head in a room, a street B-roll, a café sequence, a car. If the viewer can see where they are, they should be able to hear it.
- **Under a talking-head A-roll shot in one room**, at the bottom of the range, purely as glue: it hides the floor step at every jump cut and pause removal ([[sfx-pause-removal-breath-and-room-tone]]).
- **Under any music rest or hard stop.** When the bed drops out for a serious line, the ambience is what stops the moment reading as a digital dropout ([[sfx-music-rest-windows]], [[sfx-music-hard-stop]]).
- **Across split edits**, so the *space* crossfades even while the words cut hard.
- **When a location change needs to be felt** — this is the one place in the library where a genuine crossfade is correct: spaces dissolve into each other, they do not butt-join.
- **Not under pure graphics sequences** with no implied space, and not under stylised montages that are deliberately dry.
- **Not as a substitute for foley.** Ambience is the room; footsteps and object handling are Layer 3 ([[sfx-diegetic-action-inventory]]).

## How to recognise it in a reference video
- **Measure the floor in the speech gaps.**
  ```bash
  ffmpeg -i ref.mp4 -vn -ar 48000 ref.wav
  ffmpeg -i ref.wav -af "silencedetect=n=-45dB:d=0.35" -f null -            # find the gaps
  ffmpeg -i ref.wav -af "asetnsamples=n=4800,astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
  ```
  A bed is present when the gap floor sits **20–30 dB under the dialogue RMS** rather than collapsing to the recording's own noise floor.
- **Test continuity across cuts, which is the placement tell.** Compare the gap floor either side of each cut. **≤3 dB step and no change in spectral character = one continuous bed.** A step of 6 dB or more, or a change in tone at every cut, means there is no bed and you are hearing camera audio.
- **Find the loop period.** Pick a distinctive event, note its timecode, and look for recurrences: a fixed interval (typically 20–60 s) is a looped short file. On a spectrogram (`ffmpeg -i ref.wav -lavfi showspectrumpic=s=2048x512 spec.png`) a loop shows as a visually repeating column pattern.
- **Score the location changes.** At each change of place, measure the crossfade: **12–24 frames (0.4–0.8 s)** is the deliberate treatment. 0 frames means the space snapped, which is either a mistake or a smash cut; over ~2 s and the two places are audible together, which reads as a mix error.
- **Spectral identification of the bed type:** traffic = broad energy under 500 Hz with pass-by sweeps · walla = 300–3400 Hz with no intelligible words · park/forest = sparse transients above 2 kHz over a quiet floor · room tone = near-flat and eventless · interior vehicle = strong 40–150 Hz rumble.
- **High-pass tell.** If the bed has visible energy below ~60 Hz, it has not been filtered — a defect worth logging, because it eats headroom that the voice and the impacts need.
- **Transcript cross-check.** The bed should change where the *script* changes place ("so I went down to the workshop"), not where the shot changes.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `level` | −28 dB → `data-volume="0.04"` | −32 to −24 dB (0.025–0.063) | Under the music bed. Walla-type beds: use the quiet end. |
| `walla_penalty` | −4 dB below the default | −8 to 0 dB | Speech-band content masks dialogue disproportionately. |
| `continuity` | one clip spanning the whole location | — | Never cut the bed at a picture cut. |
| `location_crossfade` | 18f (0.6 s) | 12–24f (0.4–0.8 s) | Spaces dissolve. Author as overlap + mirrored volume lanes. |
| `min_file_length` | scene length, or ≥60 s | 30–380 s | Verified: `ambience--office` holds **96 files ≥60 s**, longest **381 s**. |
| `loop_crossfade` | 1.5 s | 1.0–3.0 s | Equal-power (`qsin`), when a file must be looped to cover a long scene. |
| `highpass` | 90 Hz, `poles: 2` | 60–120 Hz | Removes rumble that steals headroom. Note the node's own default is 300 Hz — set it explicitly. |
| `lowpass (interior/muffled)` | none | 2–8 kHz when the scene is enclosed | For "heard through a wall/door" beds only. |
| `fade_in` / `fade_out` | 1.0 s | 0.5–2.0 s | At the very start and end of a location, so the bed arrives rather than switches on. |
| `beds_per_video` | 1 per location | 1–6 | A talking-head video usually has exactly one; a location-hopping video has one each. |
| `carve` | none | — | Do **not** carve the bed. A carve is for music; a bed at −28 dB does not need one, and `data-fx-carve` on non-music adds a moving spectral hole to the room. |

## Reproduction prompt

```
Lay the ambience bed for the location that runs from {{IN}} to {{OUT}}
(composition seconds).

1. IDENTIFY THE PLACE from the picture and the transcript, and fetch the bed
   using the search formula in the ambience-search note. Prefer ONE file whose
   duration is at least ({{OUT}} - {{IN}}); a long file beats a looped short one.
2. PLACE IT AS A SINGLE CLIP: data-start = {{IN}}, data-duration =
   {{OUT}} - {{IN}}. It must span EVERY cut inside this location. Do not cut
   the bed at picture cuts. Give it an id and data-audio-group="ambience" on
   track index 11.
3. SET GAIN to 0.04 (-28 dB relative to dialogue). If the bed is crowd murmur
   or anything else concentrated in the 300-3400 Hz speech band, use 0.025
   (-32 dB) instead.
4. HIGH-PASS IT at 90 Hz, poles 2. The node's own default is 300 Hz, so write
   the frequency explicitly. Do not add anything else - no compressor, no
   carve.
5. FADE IN AND OUT over 1.0s each with a volume lane. Include an explicit
   t:0 point: a lane holds its first value backwards to the clip start, so a
   missing t:0 leaves the bed already faded.
6. IF THE FILE IS SHORTER THAN THE SCENE, do not repeat the clip end-to-end -
   the seam will click and any distinctive event will expose the loop. Instead
   pre-build a longer file offline with a 1.5s equal-power crossfade between
   copies, then place the result as one clip.
7. IF THE LOCATION CHANGES at {{OUT}}, overlap the next bed by 18 frames
   (0.6s): next.data-start = {{OUT}} - 0.6, with mirrored volume lanes so one
   falls as the other rises. Spaces dissolve; they do not butt-join.
8. VERIFY THE FLOOR STEP: measure RMS in a speech gap before and after each
   cut inside the location. Any step above 3 dB means the bed is not actually
   spanning that cut - check the clip boundaries.

ACCEPTANCE TEST: mute the picture and play 20 seconds. A listener must be able
to name the location. Then unmute and play a run of three cuts: the room must
not change at any of them. Then mute the BED only and play the same run - the
video should immediately sound thinner and more edited. If muting the bed
changes nothing, the level is too low; if any word became clearer, it is too
high.
```

## Execution spec

**HyperFrames — one long clip, one high-pass, two fades, no carve.**

```html
<!-- one bed for the whole café sequence, 48.00s -> 96.40s, spanning 11 cuts -->
<audio id="amb-cafe" src=".media/audio/sfx/ambience-cafe.wav"
       data-audio-group="ambience"
       data-start="48.00" data-duration="48.40" data-media-start="12.00"
       data-track-index="11" data-volume="0.025"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:90,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.0,&quot;v&quot;:1},{&quot;t&quot;:47.4,&quot;v&quot;:1},{&quot;t&quot;:48.4,&quot;v&quot;:0}]}]}"></audio>

<!-- location change at 96.40s: 18-frame dissolve between two spaces -->
<audio id="amb-street" src=".media/audio/sfx/ambience-street.wav"
       data-audio-group="ambience"
       data-start="95.80" data-duration="40.00"
       data-track-index="12" data-volume="0.04"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;params&quot;:{&quot;frequency&quot;:90,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.6,&quot;v&quot;:1}]}]}"></audio>
```

Contract points that decide the result:
- **The two beds overlap by 0.6 s, so they must be on different `data-track-index` values** — two `<audio>` elements sharing a track index *and* overlapping in time raise `duplicate_audio_track`.
- **`data-media-start` picks the usable stretch of a long recording** without cutting a file; if the first 12 s of the source has a car horn in it, start after it.
- **Lane `t` is clip-local seconds**, and *"a lane holds its first value backwards to the clip start and its last value forward to the end"* — hence the explicit `t:0`.
- **`highpass` defaults to 300 Hz**, which would thin the bed audibly. Always write `frequency`. `poles: 2` is the usual 12 dB/oct; `1` is a gentler 6 dB/oct.
- **Do not carve the bed.** Carve is for music under narration and its settings *"live on the bed, never on a voice"* — but a −28 dB ambience layer needs room, not a spectral hole, and putting an ambience clip inside the `voiceover` carve group *"poisons the next re-analysis silently."* Keep it in its own `ambience` group.
- **In modular projects the bed lives at the host root**, not inside a scene sub-comp: *"Keep audio at the root, visual segments as sub-comps"* so playback survives scene cuts. This is exactly the continuity requirement above, expressed in composition structure.
- **No panner and no width control exists in the FX registry** (filters, dynamics, nonlinear, delay/reverb/chorus/phaser — no pan). The bed's stereo image is whatever the source file has; change it with ffmpeg before import or not at all. **Known gap.**
- **`chainTailSeconds`:** if you add `reverb` to a bed (rarely useful) it will ring past `data-duration`.

**ffmpeg — loop building, which is the one thing the composition cannot do.** There is no loop attribute for audio clips, so a bed shorter than its scene must be pre-built:
```bash
# seamless double: 1.5s equal-power crossfade of a file onto itself
ffmpeg -i amb.wav -i amb.wav -filter_complex "acrossfade=d=1.5:c1=qsin:c2=qsin" amb.x2.wav
# repeat, then trim to length (aloop works in samples: 48000 Hz * seconds)
ffmpeg -i amb.wav -af "aloop=loop=3:size=2880000" -t 180 amb.180s.wav
# rumble filter and level, baked (only for assets leaving the pipeline)
ffmpeg -i amb.wav -af "highpass=f=90:poles=2,volume=-28dB" amb.bed.wav
# mono-fold a bed whose stereo image has a distracting point source
ffmpeg -i amb.wav -ac 1 amb.mono.wav
# floor measurement for the acceptance test
ffmpeg -i mix.wav -af "silencedetect=n=-45dB:d=0.35" -f null -
```
`acrossfade` curve set includes `tri, qsin, hsin, esin, log, nofade` — `qsin` is the quarter-sine equal-power shape, correct for two decorrelated copies. Register the derived file: `resolve --from amb.180s.wav --type sfx --project .`

**Epidemic Sound — verified shelves for beds, and the loop-friendly ones.** Live probes, 2026-08-28: slugs follow `<family>--<subtype>`, and the shelf is deep. `ambience--forest`, `ambience--office`, `ambience--urban`, `ambience--desert`, `ambience--room-tone`, `ambience--designed`, `rain--general` all confirmed. `ambience--room-tone` + `ambience--indoor` + `ambience--designed` = **582** files; `ambience--office` with `duration.min = 60000` = **96** files, the longest **381 s**.

```
# a long, single-file bed - always prefer this to looping
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ALL, values: ["ambience--office"] },
            duration: { min: 60000 } },
  sort: { by: DURATION, order: DESCENDING }, first: 20 }

# room tone for glue under a talking head - titles are explicitly loop-ready
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ALL, values: ["ambience--room-tone"] },
            duration: { min: 30000 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }
# e.g. "Ambience, Room Tone, Hotel Corridor, Loop" (44.0 s)
```
Sort by `DURATION DESCENDING` whenever the scene is long — it is the fastest way to avoid the loop problem entirely. `SearchSimilarToSoundEffect { id }` finds alternate takes of the same place, which is how a multi-shot location keeps one identity. Download with `DownloadSoundEffect` into `.media/audio/sfx/`.

**Remotion:** an `<Audio loop>` spanning the scene's frame range. Concept only; no Remotion runtime in this project.

## Pairs with
[[sfx-ambience-search-formula]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-hard-cut-audio-seam]] · [[sfx-five-layers-build-order]] · [[sfx-layer-volume-targets]] · [[sfx-pause-removal-breath-and-room-tone]] · [[sfx-music-rest-windows]] · [[sfx-music-hard-stop]] · [[sfx-diegetic-action-inventory]] · [[sfx-second-sense-doctrine]] · [[sfx-smash-cut-audio-contrast]] · [[cut-continuity-pass]]

## Failure modes
- **No bed at all.** Named mistake number two in the source corpus. The video sounds like it was shot in a vacuum and every cut is audible. Fix: one bed per location, always.
- **Cutting the bed at every picture cut.** This *creates* the floor step the bed exists to hide. Fix: one clip per location, spanning all its cuts.
- **A bed at −18 dB.** Now it is a texture competing with the content, and on a walla bed it directly masks dialogue in the speech band. Fix: −28 dB, −32 for crowd.
- **Looping a 20-second file with a car horn in it.** The horn returns every 20 seconds and the illusion dies on the second repeat. Fix: sort by duration and take a long file, or pre-build a crossfaded loop from an eventless stretch.
- **End-to-end repeats with no crossfade.** Every seam clicks. Fix: 1.5 s equal-power crossfade, built offline.
- **Unfiltered rumble.** A bed with energy at 30 Hz steals headroom from everything and shows up as an inexplicably low true-peak margin. Fix: high-pass at 90 Hz, and remember the node's default is 300.
- **Butt-joining two locations.** The space snaps and reads as a mix error rather than a move. Fix: 12–24 frame dissolve on different track indices.
- **Carving the bed.** A moving spectral hole in the room tone is audible as breathing. Fix: no carve on ambience; carve is for music.
- **Known gap:** there is no pan, width or channel-layout control anywhere in the audio FX registry, so a bed whose stereo image is wrong for the shot can only be fixed by pre-processing the file with ffmpeg. Say so in the design document rather than trying to solve it in the composition.
