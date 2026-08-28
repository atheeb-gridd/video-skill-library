---
id: sfx-missing-ambience-audit
title: Missing ambience — the audit, the bed, and the width it needs
skill: sound-design
type: mix
family: ambience
tags: [skill/sound-design, type/mix, family/ambience, engine/epidemic, engine/hyperframes, engine/ffmpeg, sfx/diegetic, layer/ambience, layer/dialogue, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:09:41
    quote: "Even in movies they use the sounds of that real location, so that you feel like you're actually there."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:09:45
    quote: "On a platform like Epidemic you get ambience sounds for every kind of location. Rain, marketplace, forest, office, everything."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:02:16
    quote: "In life, if anything is too perfect, it feels off - it doesn't feel natural. Same with your video: if there's no noise in it at all, then it feels too perfect."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:02:40
    quote: "[older pass only] - So they should use a better mic, no? - The point isn't that the noise is there because the mic is bad."
research_refs:
  - https://en.wikipedia.org/wiki/Room_tone
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (ambience--room-tone probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Missing ambience — the audit, the bed, and the width it needs

## What it is
The second named sound-design mistake: skipping layer 2 entirely. The source's defence of it is the strongest available — feature films deliberately lay the real location's sound under scenes *so that you feel like you're actually there* — and its diagnosis is the sharper half: **if there is no noise at all, the video feels too perfect, and too perfect feels wrong.** The counter-argument the video anticipates and rejects ("so use a better mic, no?") is worth keeping, because it names the misconception exactly: ambience is not tolerated noise, it is placed content.

There are actually **two different beds** under this one heading, and conflating them is why home mixes still sound empty after someone "added ambience":
- **Room tone** (also called *presence*): the character of the room with nothing happening in it, recorded in the same mic position and orientation as the dialogue, **usually mono**, and living on the *same track as its dialogue*. Its job is continuity — filling gaps, hiding edits, and stopping the noise floor from stepping at every splice. It is distinguished from ambience precisely by its **lack of explicit background events**.
- **Ambience / atmos**: the location's audible events — traffic, chatter, birds, rain. **Stereo and wide.** Its job is place, not continuity.

A video with ambience but no room tone still steps at every cut. A video with room tone but no ambience still feels like nowhere. The audit checks both.

This note is the *audit and deployment* half; [[sfx-ambience-search-formula]] is the sourcing half.

## When to use it
- **As a required gate at the end of every sound pass.** It is a checklist item, not a creative choice: run it before the mix is called done.
- **On any location-shot footage**, indoor or outdoor. Interiors need it more, not less — a silent room is more obviously wrong than a silent street.
- **Immediately after any pause-removal pass**, because stripping gaps also strips the room and creates the exact floor steps a bed hides ([[sfx-pause-removal-breath-and-room-tone]]).
- **Wherever the picture asserts a place** the audio does not corroborate — the source's own examples: a market with no market noise, a road with no traffic, a cafe with no chatter.
- **Not over a music-driven montage** where the bed is doing the work of place. Two beds fighting is worse than one missing; if music runs wall-to-wall, ambience is redundant and only adds mud.
- **Not as an excuse for a bad dialogue recording.** Ambience masks a *floor step*, not hiss under words. There is no fix for hiss beneath the words except a better source.
- **Not loud.** The correct level is one where removing it is obvious and hearing it is not.

## How to recognise it in a reference video
- **The floor-step test — this is the audit.** Find speech gaps either side of every cut and compare the noise floor:
  ```bash
  ffmpeg -i ref.wav -af "silencedetect=noise=-40dB:d=0.15" -f null - 2>&1 | grep silence_
  # then, per gap, measure the floor
  ffmpeg -ss <gap_start> -t 0.3 -i ref.wav -af "astats=metadata=1:reset=0" -f null - 2>&1 | grep RMS_level
  ```
  **A bed is present when gap floors across the whole sequence sit within about 3 dB of each other.** Steps of 6 dB or more at cut points mean no bed — the single most reliable measurable signature of this mistake.
- **The floor level itself.** A room-tone bed typically puts the gap floor at **−45 to −35 dBFS RMS**. Below about −55 dBFS the track is digitally silent between words, which is the "too perfect" condition; audiences read true silence *"not as silence, but as a failure of the sound system."*
- **Spectral shape of the gaps.** Room tone is broadband and mostly low — energy under 500 Hz with a gentle tilt. Digital silence has no spectrum. A gap with a *narrow* peak (a hum at 50/60 Hz or a whine) is not a bed, it is a defect.
- **Place corroboration, shot by shot.** List each location the picture asserts and check whether the audio names it. In competent work every location change brings an audible bed change; in sloppy work one bed (or none) runs across five locations.
- **Stereo width.** Compare left and right in the gaps: `ffmpeg -i ref.wav -af "channelsplit"` and correlate. **Room tone should be near-mono** (high correlation); **ambience should be wide** (correlation well below 1). A perfectly mono "ambience" reads as a recording played back rather than a place you are in; a *wide room tone* under a centred voice smears the voice's position.
- **Continuity across cuts.** Does the bed cross the cut, or restart? A bed that restarts per shot is audible as a tick at every edit ([[sfx-ambience-bridge-across-cut]]).
- **Loop detection.** Long videos with short beds loop. Compare 20-second windows for identical waveforms; a period under about 30 seconds is audible.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `room_tone_level` | 0.0316 (≈−30 dB) | −35 to −25 dB | Relative to dialogue at 0/−3 dB. Enough to mask a floor step, never enough to identify. |
| `ambience_level` | 0.056 (≈−25 dB) | −30 to −20 dB | Audible as place. Under narration, closer to −28; in a narration-free establishing beat, up to −18 for 2–3 seconds then back. |
| `target_gap_floor` | −40 dBFS RMS | −45 to −35 dBFS | What the audit measures. The number to hit, rather than a fader position. |
| `max_floor_step` | 3 dB | 0–4 dB | Across every cut in the sequence. Above this, the bed is missing or discontinuous. |
| `room_tone_width` | mono | mono only | Recorded and used in the same mic position as the dialogue. A wide room tone smears a centred voice. |
| `ambience_width` | stereo, ~90% | 60–100% | Wide enough to be a place, not so wide that it pulls attention off centre. |
| `bed_highpass` | 80 Hz | 60–120 Hz | Cuts rumble the bed contributes but nothing needs. Below 60 Hz a bed only steals headroom. |
| `bed_lowpass` | none | none, or 8 kHz | Low-pass an *interior* bed to 8 kHz to place it outside a window or behind a wall ([[sfx-filter-character-and-distance]]). |
| `bed_carve` | not against voice | — | Do **not** carve ambience against the voice. Carve is for music; a −30 dB bed does not need intelligibility room, and carving it makes the mask stop working exactly when speech arrives. |
| `fade_in` / `fade_out` | 0.5 s / 1.0 s | 0.3–2.0 s | Long enough that the bed's arrival is not an event. Out longer than in. |
| `min_bed_length` | 60 s | 30–300 s | Shorter loops audibly. Catalogue room tones are frequently exactly 120 s. |
| `beds_per_location` | 1 | 1–2 | One continuous bed per location. Two only when the location genuinely has two layers (a room tone plus street through a window). |
| `variants_for_long_runs` | 2 | 1–3 | For runs over 5 minutes, alternate two similar beds rather than looping one. |
| `music_present` | check | — | If music runs wall-to-wall in a section, drop ambience there. Two beds is mud. |

## Reproduction prompt

```
Audit and fix the ambience layer across the whole timeline.

AUDIT
1. LIST THE PLACES. Watch on mute and write one row per location the picture
   asserts, with its in/out in seconds. A location change with no audio
   change is a finding.
2. MEASURE EVERY GAP FLOOR. Run
   ffmpeg -i mix.wav -af "silencedetect=noise=-40dB:d=0.15" -f null -
   and for each gap measure RMS over 0.3 s. Tabulate. Two findings:
   - any gap floor below -55 dBFS  -> digital silence, "too perfect"
   - any pair of adjacent gaps differing by more than 3 dB -> a floor step,
     which means no continuous bed
3. CHECK WIDTH. Room tone must read near-mono; ambience must read wide.
   A wide room tone under a centred voice is a defect, not a bonus.

FIX
4. LAY ONE ROOM TONE BED spanning the ENTIRE timeline - not per shot - at
   -30 dB (data-volume 0.0316), mono, high-passed at 80 Hz. This alone
   removes every floor step. Fade 0.5 s in, 1.0 s out. Use a bed of at least
   60 s so it does not loop audibly.
5. LAY ONE AMBIENCE BED PER LOCATION at -25 dB (data-volume 0.056), stereo,
   matched to the place the picture asserts: road -> traffic, cafe -> people
   chattering, outdoors -> birds. Cross-fade adjacent location beds by 0.5 s
   so the change is a transition, not a cut.
6. DO NOT CARVE the ambience against the voice. Carve is for music. A -30 dB
   bed carved against speech stops masking exactly when speech arrives, which
   is the moment it was there for.
7. WHERE MUSIC RUNS WALL-TO-WALL, remove the ambience for that stretch. Two
   beds is mud, and the music is already carrying place.
8. RE-RUN THE AUDIT. Every gap floor must now sit within 3 dB of every other
   and land between -45 and -35 dBFS.

ACCEPTANCE TEST: two passes. First, listen to 60 continuous seconds spanning
at least three cuts and confirm you cannot hear the floor change at any of
them. Second - the real test - MUTE the ambience group and listen to the same
60 seconds. It must sound obviously, immediately worse and emptier. If muting
it changes nothing, it is too quiet. If un-muting it draws your attention to
the ambience itself, it is too loud.
```

## Execution spec

**Epidemic Sound — the two beds are two different searches.** Verified live 2026-08-28: room tone is its own subcategory, `ambience--room-tone`, and the titles are explicit about the space and the mechanical source:
```
# ROOM TONE - query the space, filter hard on duration so you get a bed not a one-shot
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["ambience--room-tone"]},
                              duration:{min:60000,max:300000} },
                     query:{term:"office room tone"},
                     sort:{by:DURATION,order:DESCENDING}, first:24 }
#   real titles: "Ambience, Room Tone, Office Room Tone, AC" (120 s) ·
#     "Ambience, Room Tone, Office Kitchen Room Tone 01" (120 s) ·
#     "Ambience, Room Tone, Small Sized Room, Hum 01/02/03" (120 s) ·
#     "Ambience, Room Tone, Hotel Room, Airy, Copenhagen 02" (235 s) ·
#     "Ambience, Room Tone, Corridor Room Tone (Multimono)" (153 s)
#   >>> "(Multimono)" marks a mono recording spread across channels - which is
#       EXACTLY what a room tone bed under a centred voice should be. Prefer it.
#   >>> Numbered siblings (01/02/03) are the variant set for a long run, free.
# AMBIENCE - query the place plus the word "ambience", per the family formula
SearchSoundEffects { query:{term:"traffic ambience city street"},
                     filter:{duration:{min:60000}}, first:24 }
#   also: "people chattering ambience cafe" · "birds ambience forest morning" ·
#         "rain ambience" · "marketplace ambience" · "office ambience"
SearchSimilarToSoundEffect { id:<uuid>, first:12 }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Always **WAV**: mp3 encoder artefacts are most audible on near-silent broadband material, which is exactly what a room tone is. Filter on `duration` first — it is the difference between a bed and a one-shot, and the single most common sourcing error in this family is fetching a 4-second "ambience" and looping it.

**HyperFrames — one bed at the root, spanning everything.** The contract's own guidance for modular projects is *"Keep audio at the root, visual segments as sub-comps"* so playback survives scene cuts. That is precisely what a bed needs:
```html
<!-- ROOM TONE: one clip, whole timeline, mono, -30 dB, high-passed -->
<audio id="amb-room-tone" src="assets/sfx/diegetic/room-tone/room_tone_corridor_multimono_01.wav"
       data-audio-group="ambience"
       data-start="0" data-duration="540" data-track-index="14" data-volume="0.0316"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:80,&quot;poles&quot;:&quot;2&quot;}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.5,&quot;v&quot;:1},{&quot;t&quot;:539,&quot;v&quot;:1},{&quot;t&quot;:540,&quot;v&quot;:0}]}]}"></audio>

<!-- LOCATION AMBIENCE: one per place, cross-faded 0.5 s at the boundary -->
<audio id="amb-street" src="assets/sfx/diegetic/ambience/traffic_city_street_01.wav"
       data-audio-group="ambience"
       data-start="0" data-duration="126.5" data-track-index="13" data-volume="0.056"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.5,&quot;v&quot;:1},{&quot;t&quot;:126,&quot;v&quot;:1},{&quot;t&quot;:126.5,&quot;v&quot;:0}]}]}"></audio>
<audio id="amb-cafe" src="assets/sfx/diegetic/ambience/cafe_chatter_01.wav"
       data-audio-group="ambience"
       data-start="126" data-duration="98" data-track-index="12" data-volume="0.056"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.5,&quot;v&quot;:1},{&quot;t&quot;:97.5,&quot;v&quot;:1},{&quot;t&quot;:98,&quot;v&quot;:0}]}]}"></audio>
```
Contract points that decide whether this works:
- **The `t: 0` point is mandatory on every lane.** *"A lane holds its first value backwards to the start of its clip and its last value forward to the end… So a bed that begins before the voice needs an explicit 'no cut' point at `t: 0`, or it starts out already ducked."* A bed without it opens at full level with no fade.
- **The two location beds overlap by 0.5 s and sit on different `data-track-index` values** (13 and 12) — two `<audio>` sharing a track index *and* overlapping raise `duplicate_audio_track`.
- **Lanes cap at 512 points**, which is plentiful here but relevant if you automate a bed's level shot by shot across a long video. Prefer a single-member `<hf-audio-group>` in that case: a bus's automation clock is **composition time**, so one lane can describe the whole timeline instead of clip-local segments.
- **Do not put ambience in the `voiceover` group** — *"a bed or an SFX clip inside the named group poisons the next re-analysis silently."* And do not put `data-fx-carve` on it: carve is for the music bed, and *"skip it only when there is no narration for the music to sit under"* is advice about music, not ambience.
- **`data-media-start`** trims into a long bed without cutting a file; use it to start a 120 s room tone at a quiet point rather than at whatever its head happens to be.
- **A `<video>` carrying usable location sound can *be* the bed**: unmute it, or better, place a separate `<audio>` with the same `src`, `data-start`, `data-duration` and `data-media-start` (the project's own convention is *"videos use `muted` with a separate `<audio>` element"*).

**ffmpeg — width, loop-proofing, and the audit.** Stereo width is the one parameter in this note that **has no HyperFrames node**: the FX registry's "space and width" family is `delay`, `reverb`, `chorus`, `phaser` — there is no widener, no panner and no M/S tool. So width is a **bake**:
```bash
# collapse a stereo room tone to true mono, then re-spread as multimono (the bed case)
ffmpeg -i room.wav -af "pan=mono|c0=0.5*c0+0.5*c1" room.mono.wav
ffmpeg -i room.mono.wav -af "pan=stereo|c0=c0|c1=c0" room.multimono.wav
# widen an ambience bed to about 130% via M/S (the atmos case). Check for phase weirdness.
ffmpeg -i amb.wav -af "stereotools=slev=1.3" amb.wide.wav
# make a long, non-looping bed from a short one: forward + reversed + forward
ffmpeg -i amb.wav -filter_complex "[0:a]areverse[r];[0:a][r][0:a]concat=n=3:v=0:a=1,\
 afade=t=in:d=0.5,loudnorm=I=-23:TP=-1" amb.long.wav
# THE AUDIT, as one command over the finished mix
ffmpeg -i mix.wav -af "silencedetect=noise=-40dB:d=0.15" -f null - 2>&1 | grep silence_
```
Note `silencedetect`'s documented defaults are `noise=-60dB` and `duration=2.0` — both wrong for this job, and using them makes the audit "pass" by finding nothing. Always pass both explicitly. Keep all bake intermediates **outside the mounted vault**, which cannot delete files.

**Remotion:** one `<Audio>` outside all `<Sequence>`s for the room tone, one per location inside its own sequence. Concept only; no Remotion runtime here.

## Pairs with
[[sfx-ambience-search-formula]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-pause-removal-breath-and-room-tone]] · [[sfx-foley-replacement-pass]] · [[sfx-five-layers-build-order]] · [[sfx-layer-volume-targets]] · [[sfx-filter-character-and-distance]] · [[sfx-dialogue-gate]] · [[sfx-cross-cut-audio-strategy]] · [[sfx-music-rest-windows]] · [[sfx-second-sense-doctrine]] · [[sfx-demo-clip-loudness-handover]] · [[sfx-sound-pass-order]] · [[sfx-diegetic-action-inventory]] · [[cut-continuity-pass]]

## Failure modes
- **No bed at all.** The named mistake. Measurable as 6 dB+ floor steps at cuts and gap floors below −55 dBFS. Fix: one root-level room tone spanning the whole timeline. This single clip fixes more than anything else in the note.
- **Confusing room tone with ambience.** Adding traffic and thinking layer 2 is done, while the floor still steps at every splice. Fix: both. Room tone for continuity, ambience for place.
- **A bed per shot.** Restarts at every cut, which is audible as a tick and defeats the purpose. Fix: one continuous bed; cross-fade only at genuine location changes.
- **Ambience too loud.** Once you can identify the bed, you are listening to it instead of the video. Fix: −25 dB, and the mute test — un-muting must not draw attention.
- **Ambience too quiet.** The most common outcome of being careful. Fix: if muting it changes nothing, it is doing nothing.
- **Wide room tone.** Smears the centred voice's image. Fix: mono, or the catalogue's `(Multimono)` variants.
- **Carving the ambience against the voice.** Turns the mask off exactly when speech arrives, which is when the floor step would otherwise be hidden. Fix: carve music only.
- **A 4-second loop.** Audible within 20 seconds and unmistakable within a minute. Fix: `duration.min` of 60000 ms at fetch, or the reverse-concat trick.
- **Ambience under wall-to-wall music.** Mud with no benefit. Fix: drop the ambience for that stretch.
- **Using ambience to hide a bad dialogue recording.** It masks a *step*, not hiss under words. There is no fix for hiss beneath the words except a better source. Fix: [[sfx-dialogue-gate]].
- **Using `silencedetect` at its defaults** for the audit. Finds nothing, so the audit appears to pass. Fix: `noise=-40dB:d=0.15`.
- **Known gap:** HyperFrames has **no stereo width, pan or M/S node**. Every width decision in this note must be baked with ffmpeg before the file enters the composition, and a bed's width is therefore fixed at ingest and cannot be automated across a video. If a spec needs a bed that narrows under speech and widens in a gap, that capability does not exist here — bake two variants and cross-fade the clips instead.
