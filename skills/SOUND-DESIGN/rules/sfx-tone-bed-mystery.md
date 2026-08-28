---
id: sfx-tone-bed-mystery
title: Tones — the sustained bed that colours a passage with mystery and dread
skill: sound-design
type: sfx
family: aesthetic-bed
tags: [skill/sound-design, type/sfx, family/aesthetic-bed, engine/epidemic, engine/hyperframes, engine/ffmpeg, sfx/aesthetic, layer/design, source/editing-kt, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:11:48
    quote: "Last but not least, tones."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:11:49
    quote: "These create a feeling of mystery and intrigue."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:11:52
    quote: "They're more for darker moods and they build a lot of underlying tension."
research_refs:
  - https://en.wikipedia.org/wiki/Drone_(music)
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Shepard_tone
  - mcp://Epidemic_sounds/SearchSoundEffects (designed--drone and designed--tonal probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Tones — the sustained bed that colours a passage with mystery and dread

## What it is
The third of the source's three emotion-hijacking effects, and the only one that is **not an event**. A riser is a ramp with an end; a hit is a transient. A tone is a **bed**: a sustained, mostly static layer that runs underneath a whole passage and changes what everything above it means. Musically it is a drone — *"a harmonic or monophonic effect or accompaniment where a note or chord is continuously sounded throughout most or all of a piece"*, achieved *"through a sustained sound or through repetition of a note"*, and it works because it *"most often establishes a tonality upon which the rest of the piece is built."*

The catalogue's own vocabulary splits it three ways, and they behave differently:

- **Pitched drone** — a held low note or cluster. Establishes a tonal centre, so it makes any music above it sound like it belongs to a key. This is the one that reads as *dread*.
- **Granular / textural drone** — noise-derived, no clear pitch. No tonal centre, so it reads as *unease* without committing to a mood. This is the one that reads as *mystery*.
- **Tonal / pure tone** — a single sine-ish pitch, often high. Reads as *wrongness* — the tinnitus after a blast, the moment before the character understands.

The two things that make a tone bed work are both invisible by design. It must be **frequency-slotted** so it does not eat the music or the voice, and it must **enter and leave below the threshold at which a level change is noticed** — if the viewer hears it start, it stopped being a mood and became an effect.

## When to use it
- **A dark or serious passage that has no event to punctuate.** The whole point of a tone is that it works where there is nothing to hit. If there is a moment, use [[sfx-cinematic-hit-emphasis]]; if there is an arrival, use [[sfx-riser-anticipation-build]].
- **Before the reveal, not on it.** A tone under the setup is what makes the eventual hit land. It is the accumulating half of a tension arc.
- **A stretch of narration that is factually heavy and emotionally flat** — a statistic, a mechanism, a warning. The tone supplies the stakes the words state but do not carry.
- **Under a cross-cut**, as the single continuous layer that asserts the two strands are one event ([[sfx-cross-cut-audio-strategy]]).
- **When the music has to stop but the passage cannot go dead.** A tone is the cheapest replacement for a killed music bed ([[sfx-music-hard-stop]], [[sfx-music-rest-windows]]).
- **Not on an upbeat video.** A tone under hopeful content reads as sarcasm or as a mistake. There is no neutral drone.
- **Not for more than about 35% of a video's runtime.** A permanent tone stops being felt within roughly 40–60 seconds of continuous exposure and becomes a level problem you can no longer hear.
- **Not stacked with a second tone.** Two drones at different pitches beat against each other and the result is heard as a fault.

## How to recognise it in a reference video
- **Look at a spectrogram, not the waveform.** A tone bed is nearly invisible on a waveform — it adds no transients and barely moves RMS. On a spectrogram it is an unbroken horizontal band, usually below 250 Hz and/or a thin line above 4 kHz, that **persists across picture cuts**. Persistence across cuts is the single strongest tell: ambience changes when the location changes, a tone does not.
- **Measure the low-band energy in and out of the passage.** High-pass-invert the mix and compare RMS in the suspect passage versus a neutral passage. A tone bed typically adds **3–8 dB of 40–160 Hz energy** with no corresponding increase in mid-band level.
- **Check the entrance for a level ramp with no onset.** Print RMS at 0.5 s resolution across the 10 s before the passage. A tone bed shows a **monotonic rise of roughly 0.5–2 dB per second over 3–8 seconds** and no transient at any point. A music cue, by contrast, starts on a beat.
- **Listen for what stops.** Tones almost always end *under* something — a hit, a cut, or a line of dialogue — because that is how you hide the exit. If the low-band energy vanishes within 2 frames of a transient, the transient is masking a tone out-point ([[sfx-transient-masked-outpoint]]).
- **Content signal in the transcript.** Mark the passages where the narration turns to threat, cost, failure, secrecy or the unknown. In this creator's corpus, tone beds sit under those and essentially nowhere else.
- **Distinguish from ambience.** Ambience carries events (a car, a bird, a voice) and identifies a place. A tone carries nothing and identifies nothing. If you can name the location from the layer, it is layer 2, not layer 5.
- **Log it as:** start, end, in-fade, out-fade, approximate centre frequency band, and level relative to dialogue. Nothing else about a tone is reproducible.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `bed_length` | length of the passage | 8–120 s | Never shorter than 8 s — below that it reads as an effect, not a mood. Match a script beat, not a shot. |
| `level_rel_dialogue` | −30 dB (`data-volume` 0.032) | −34 to −26 dB | Below music (−20/−25) by 5–10 dB. If you can name it while watching, it is 4 dB too loud. |
| `fade_in` | 5 s | 3–8 s | The entrance must be slower than ~2 dB/s or the viewer hears it arrive. Use `sine.inOut`-shaped curvature (`curve: 0.4`). |
| `fade_out` | 4 s | 2–6 s | Or 0.2 s if the out-point is masked by a hit or a hard cut. |
| `highpass` | 35 Hz | 25–45 Hz | Removes sub-audible energy that costs headroom and does nothing. Always on. |
| `lowpass` | 4 kHz (pitched/granular) | 2–8 kHz | Keeps the drone out of the presence band where the voice lives. Omit for a deliberate high pure tone. |
| `carve_notch` | 250–600 Hz, −3 dB, Q 1.2 | −2 to −5 dB | The "Mud" band. A drone and a music bed collide here first. Notch the **drone**, never the music. |
| `voice_duck` | −4 dB under narration | −2 to −6 dB | Small. A tone that ducks hard becomes audible by its ducking. |
| `pitch_shift` | 1.0 | 0.6–1.0 | Down only. Pitching a drone up thins it and exposes its loop. |
| `coverage` | ≤35% of runtime | 10–40% | Fatigue ceiling. Split into 2–4 separate beds rather than one long one. |
| `stacking` | 1 tone | 1 | Two pitched drones beat. One pitched plus one *granular* is the only legal pair, and only 6 dB apart. |

## Reproduction prompt

```
Lay a tone bed under the passage running {{IN}} to {{OUT}} (seconds).

1. CLASSIFY THE PASSAGE FIRST. Read the transcript between {{IN}} and {{OUT}}.
   - threat / cost / consequence  -> PITCHED drone (dread)
   - secret / unknown / question  -> GRANULAR drone (mystery)
   - shock / aftermath / realisation -> PURE TONE (wrongness)
   If none of the three fit, do not place a tone. There is no neutral drone.
2. FETCH a file at least 1.3x the passage length so you never loop. Prefer
   240 s+ assets; they exist. Pull 3 candidates and audition against picture
   with the dialogue playing, never in isolation.
3. PLACE it as one clip from {{IN}} - 5 to {{OUT}} + 4 on the design track,
   in its own audio group "design". It must span every picture cut inside
   the passage; do NOT cut the bed at a picture cut.
4. FILTER before you level: high-pass 35 Hz, low-pass 4000 Hz, and a
   peaking notch at 400 Hz, -3 dB, Q 1.2 so it does not collide with the
   music bed's mud band. Limiter last.
5. LEVEL to -30 dB relative to dialogue (linear 0.032).
6. ENVELOPE, in clip-local seconds, with an explicit point at t=0:
   t=0 v=0 ; t=5 v=1 (curve 0.4) ; t=(len-4) v=1 ; t=len v=0
   The lane holds its first value backwards, so the t=0 point is mandatory
   or the bed starts already up.
7. HIDE THE EXIT. If there is a hit, hard cut or loud transient within 12
   frames of {{OUT}}, move the out-point onto it and shorten fade_out to
   0.2 s. A masked exit is always better than a fade.
8. RE-CHECK THE MUSIC. Play the passage with the tone muted, then unmuted.
   The music must not sound quieter or muddier - only the mood should change.
   If the music lost weight, deepen the notch, do not lower the tone.

ACCEPTANCE TEST: play from {{IN}} - 10 to {{OUT}} + 5 once at full speed
and write down the moment the tone starts. If you can name a second, the
fade is too fast - add 2 s. Then play it again watching only the picture:
the passage must feel heavier without you being able to say why.
```

## Execution spec

**Epidemic Sound.** The tag to know is `designed--drone` — probed live 2026-08-28, **975 assets**, and the durations are the reason to use the tag rather than a term search: sorted by duration descending it returns 200–423 s files, which is long enough to cover a whole passage without looping. Real titles from that probe: `Designed, Drone, Dark Space` (210 s), `Designed, Drone, Dark Orchestral` (210 s), `Designed, Drone, Eerie, Mysterious, Light Granular` (240 s), `Designed, Drone, Metallic Oscillation Pad 02` (423 s), `Designed, Drone, Dark, Synth Melody 01` (253 s), `Designed, Drone, Slow Shards Loop` (273 s).

```
# PITCHED / dread - long files, sorted so the longest come first
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["designed--drone"]},
                              duration:{min:60000} },
                     query:{term:"dark space orchestral"},
                     sort:{by:DURATION, order:DESCENDING}, first:24 }

# GRANULAR / mystery - the descriptor words the catalogue actually uses are
# "Eerie", "Mysterious", "Granular", "Psychedelic", "Ambient", "Soundscape"
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["designed--drone"]},
                              duration:{min:60000} },
                     query:{term:"eerie mysterious granular"}, first:24 }

# PURE TONE / wrongness - a different slug entirely
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["designed--tonal"]} },
                     query:{term:"tone"}, first:24 }
#   verified title: "Designed, Tonal, Tinnitus, Classic Tone" (20.3 s)

SearchSimilarToSoundEffect { id:<uuid>, first:12 }   # keeps a profile's tone palette coherent
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Read `audioFile.durationInMilliseconds` and reject anything under `1.3 x passage length` — looping a drone is the one failure the viewer notices, because a granular texture repeats audibly. A term search without the tag slug pulls in `designed--riser`, `designed--impact` and `musical--stinger` (verified: `"dark drone tone tension"` returned mostly hits and risers out of 2620 results), so **filter by slug first and use the term only to steer within it**.

**HyperFrames.** One clip, own group, filters before the limiter, an explicit `t:0` envelope point. Passage 42.0 s → 78.0 s, so the clip runs 37.0 → 82.0 (45 s):

```html
<audio id="tone-dread-01" src="assets/sfx/design/drone_dark_space.wav"
       data-audio-group="design"
       data-start="37" data-duration="45" data-media-start="12"
       data-track-index="14" data-volume="0.032"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Kill sub&quot;,&quot;params&quot;:{&quot;frequency&quot;:35,&quot;poles&quot;:&quot;2&quot;}},
         {&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Reduce Mud&quot;,&quot;params&quot;:{&quot;frequency&quot;:400,&quot;gain&quot;:-3,&quot;q&quot;:1.2}},
         {&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;label&quot;:&quot;Out of the voice band&quot;,&quot;params&quot;:{&quot;frequency&quot;:4000,&quot;poles&quot;:&quot;2&quot;}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n4&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:5,&quot;v&quot;:1,&quot;curve&quot;:0.4},
         {&quot;t&quot;:41,&quot;v&quot;:1},{&quot;t&quot;:45,&quot;v&quot;:0}]}]}"></audio>
```
Contract points that decide whether this runs: every `<audio>` **needs an `id`** or it is never mixed and the render is silently missing the bed; `t` in a clip lane is **clip-local seconds**, and *"a lane holds its first value backwards to the start of its clip"*, which is why the `t:0, v:0` point is not optional; `curve` (−1..1) bends the segment **leaving** its point, so the 0.4 on the `t:5` point is inert — put curvature on `t:0` if you want the ramp shaped, or accept the linear ramp, which at 5 s is already below the audibility threshold. Order is signal order and the **limiter goes last**. Do **not** also GSAP-tween `volume` on this element — `audio_volume_double_automation` means the lane wins and the tween is silently ignored.

Two more contract facts worth planning around: a tone bed is exactly the case for a **single-member `<hf-audio-group>`**, because *"a bus's automation clock is composition time"* — if you would rather write the envelope in composition seconds than clip-local seconds, wrap it. And **do not put the tone in the `voiceover` carve group**; carve `sources` must be voices only, and *"a bed or an SFX clip inside the named group poisons the next re-analysis silently."* The tone is a bed: give it its own `data-fx-carve` against `voiceover` at a low `strength` (0.15) if the narration is dense, or take the −4 dB duck with a second automation lane if it is not.

**ffmpeg.** Only for preparing the asset, never for the mix:
```bash
# pitch a drone DOWN without changing length (0.85 = about -2.8 semitones)
ffmpeg -i drone.wav -af "asetrate=48000*0.85,aresample=48000,atempo=1.1765" drone.low.wav
# stitch a too-short file into a long bed with an equal-power crossfade, no seam
ffmpeg -i drone.wav -i drone.wav -filter_complex "acrossfade=d=6:c1=qsin:c2=qsin" drone.x2.wav
# measure the low-band energy a candidate actually adds, before committing
ffmpeg -i drone.wav -af "lowpass=f=250,astats=measure_overall=RMS_level" -f null -
```
A 6-second crossfade is the right length for a drone — long enough that the granular texture never lines up with itself audibly. Keep intermediates **outside the mounted vault**, which cannot delete files.

**Remotion.** One long `<Audio>` in a `<Sequence>` spanning the passage, with an interpolated volume ramp. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-riser-anticipation-build]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-cross-cut-audio-strategy]] · [[sfx-intensify-without-referent]] · [[sfx-felt-not-noticed]] · [[sfx-music-rest-windows]] · [[sfx-music-hard-stop]] · [[sfx-heartbeat-tension-dial]] · [[sfx-transient-masked-outpoint]] · [[sfx-layer-volume-targets]] · [[sfx-density-fatigue-audit]] · [[sfx-filter-character-and-distance]] · [[struct-cross-cutting-parallel-action]] · [[sfx-two-taxonomies-of-sound]]

## Failure modes
- **The viewer hears it start.** The commonest fault, and it converts a mood into an effect. Fix: fade in over at least 3 s, and start the fade under a line of dialogue rather than in a pause.
- **Too loud.** A tone you can name while watching is 4–6 dB over. Fix: pull to −30 dB relative to dialogue and re-audition; the test is whether the *music* still sounds full, not whether the tone is audible.
- **No high-pass.** Drone files routinely carry 20–30 Hz content that is inaudible on every device the viewer owns but eats limiter headroom on the master and makes the whole mix sound smaller. Fix: high-pass at 35 Hz, always.
- **Colliding with the music bed.** Both live in the 250–600 Hz mud band; summed, the music loses its body and everyone blames the music. Fix: notch the **tone** at 400 Hz, −3 dB, Q 1.2. Never fix it by lowering the music.
- **Looping a short file.** A granular texture repeats audibly at intervals as long as 20 s. Fix: fetch a file at least 1.3× the passage, or crossfade two copies with a 6 s `acrossfade`.
- **Running under the whole video.** Continuous exposure kills the effect in under a minute and leaves only the level cost. Fix: cap at ~35% of runtime, in 2–4 separate beds with real gaps.
- **Two pitched drones at once.** They beat, and the beating is heard as a fault rather than as tension. Fix: one pitched drone; a granular texture may join it 6 dB down.
- **A tone under upbeat content.** Reads as unintentional. Fix: classify the passage from the transcript before fetching; if none of the three categories fit, place nothing.
- **Cutting the bed at a picture cut.** Produces a noise-floor step exactly where the edit is, which advertises the edit ([[sfx-hard-cut-audio-seam]]). Fix: one clip spanning the whole passage.
- **Known gap:** nothing in this stack validates an FX chain or an automation lane — *"Nothing validates the chain or the effect lanes at all."* A typo'd node id silently prunes the envelope, and preview plays an unparseable chain **dry** while render refuses it. So a tone bed that sounds right in preview can still fail the render, and a bed with no audible envelope in preview may simply have lost its lane. Verify by rendering a 20 s excerpt and measuring the low band, not by trusting preview.
