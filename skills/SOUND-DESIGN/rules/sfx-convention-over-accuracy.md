---
id: sfx-convention-over-accuracy
title: Convention beats accuracy — the whip, the punch, and why fake sounds read as real
skill: sound-design
type: sfx
family: diegetic-convention
tags: [skill/sound-design, type/sfx, family/diegetic-convention, engine/epidemic, engine/hyperframes, engine/ffmpeg, sfx/diegetic, layer/sfx, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:06:56
    quote: "In old-school action scenes, this same sound effect used to be used as well."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:07:17
    quote: "Put it one way, they're fake sound effects that sound completely real, but they're actually recorded sitting inside a studio."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:07:23
    quote: "Footsteps, clothes, or a door creak — this creates realism in the scene,"
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:07:00
    quote: "And when you layer it with a whoosh, you'll end up with all kinds of unique sounds."
research_refs:
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Audio_to_video_synchronization
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (fight--impact, swooshes--whoosh, designed--riser shelves probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Convention beats accuracy — the whip, the punch, and why fake sounds read as real

## What it is
The rule that makes the diegetic layer work, and the one that sounds wrong until you have tried it: **the viewer's reference for what something sounds like is other films, not the world.** So a physical action beat is sold by the *conventional* sound, not the accurate one. The source gives both halves of this. The whip crack is named as a sound that *"in old-school action scenes … used to be used as well"* — genre memory doing the work — and the Foley definition is blunt about the mechanism: *"they're fake sound effects that sound completely real, but they're actually recorded sitting inside a studio"*, and *"this creates realism in the scene."* Fake, made elsewhere, and *therefore* real-sounding.

Foley practice is a catalogue of exactly this trade. The craft's three categories are **feet**, **moves** (*"the swishing of clothing when two actors walk past each other"*) and **specifics**, and the specifics are almost all substitutions: *"corn starch in a leather pouch makes the sound of snow crunching"*, *"a pair of gloves sounds like bird wings flapping"*, *"frozen romaine lettuce makes bone cracking noises"*, *"cellophane creates crackling fire effects"*, *"coconut shells cut in half and stuffed with padding make horse hoof noises"*, *"a heavy staple gun combined with other small metal sounds make convincing gun noises."* Nobody records a real breaking bone. The lettuce is more real than the bone, because the lettuce matches what the audience has been taught a breaking bone sounds like.

Two reasons the real recording usually loses:
- **Perspective and level.** A real event recorded at a real distance has room, reflections and a modest transient; screen sound needs the close, dry, transient-forward version that no natural listening position provides.
- **Transient shape.** Convention favours a fast rise and a shaped tail. A real punch is a dull thud with no crack; the film punch is a leather/meat impact layered with a crack, which is why it reads as a punch on a 4-inch phone speaker.

Modern practice does not use the literal whip sample for an action beat either — it uses a **hybrid**, and the source says so in one line: *"when you layer it with a whoosh, you'll end up with all kinds of unique sounds."* The action hit is a three-part construction: **approach** (air/whoosh, leading the impact), **crack** (the impulsive transient, on the impact frame), **tail** (decay, debris or sub, after). Each part comes from a different shelf, and the assembly is what sounds like a single real event.

**Style.** Filed `sfx/diegetic`: the convention is being used to sell an object or a body the viewer can point at. The whip crack fired on a *cut* rather than on an action is a motion sound and lives in [[sfx-whip-crack-on-snap-cut]].

## When to use it
Ask one question per diegetic sound: *what does the audience expect this to sound like?* — then place it in one of three tiers.

- **Tier 1 — strong convention. Use the convention, not the recording.** Punches and body impacts, whip cracks, sword draws, gunshots, bone breaks, camera shutters, arrows, slaps, fires, horse hooves, sci-fi anything. These have a canonical film sound and the real recording will read as wrong.
- **Tier 2 — weak convention. Use the real or near-real sound.** Specific objects your video is actually about: this laptop's keys, this kettle, this door, this bike. Here plausibility beats genre, and the convention route sounds like a stock library.
- **Tier 3 — no referent at all.** Graphic and abstract motion; there is nothing to be accurate about, so the choice is free and governed by envelope-matching instead ([[sfx-real-vs-invented-sound-rule]], [[sfx-arbitrary-sound-motion-sync]]).

Trigger conditions for reaching for this note specifically:
- **A physical action beat** — someone hits, throws, swings, slams, falls. Build the three-part hit.
- **A shot whose audio was unusable** and the real sound is thin. Replace, do not repair; *"there is no fallback for hiss beneath the words"* and the same holds for a limp impact.
- **A period or genre gesture** — the whip on a fast cut, the reel-change tick, the film-projector rattle. The sound *is* the reference.
- **Not on comedy beats**, where the convention you want is the cartoon one instead ([[sfx-cartoon-comedy-family]]).
- **Not where the accurate sound is the joke or the point** — a video about how quiet an electric car is must use the quiet.

## How to recognise it in a reference video
- **Look for the three-part envelope on every action beat.** On a waveform, a constructed hit shows: a **rising broadband swell of 200–500 ms**, then a **near-vertical transient**, then a **decay of 200–800 ms** (often with energy below 100 Hz that the swell did not have). A single-part hit — transient only, no approach, no tail — is an unlayered library drop and is the commonest amateur tell.
- **Measure the transient rise time.** `ffmpeg -i ref.wav -af "asetnsamples=n=48,astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null -` (1 ms windows). A conventional crack rises to peak in **under 5 ms**; a real-world recording of the same event typically takes 15–40 ms and sounds soft by comparison.
- **Check the peak lands on the impact frame.** *"The peak of my hit sound effect should land exactly on the impact frame."* Expect **0 to −1 frame**, never late; the approach layer starts 6–15 frames earlier.
- **Listen for perspective mismatch.** A conventional sound is close and dry; if the picture is a wide shot and the sound is intimate, the creator has chosen convention over accuracy deliberately — log it, because that choice *is* the style.
- **Spot the substitution.** Sounds that are conspicuously *not* what the picture shows: a metallic ring on a wooden impact, a whip crack on a cut where no whip exists, cloth on a graphic move. The source is explicit that hits come *"in different variations, like metal, wood — so wherever you need a certain feel, use that one there."* Feel, not material.
- **Count the layers per beat.** Two or three simultaneous clips on the hero beats and one on the minor ones is the signature of a considered diegetic pass. Everything single-layered means the pass was rushed.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `tier_decision` | ask "what does the audience expect?" | — | Tier 1 convention · Tier 2 real · Tier 3 free. Decide before searching. |
| `approach_lead` | −10f (−333 ms) | −6f to −15f | Where the air/whoosh layer starts relative to impact. |
| `approach_len` | 0.35 s | 0.20–0.50 s | Ends at or just past the impact frame. |
| `crack_anchor` | 0f (peak on the impact frame) | 0 to −1f | Never late. Film sync practice is ±22 ms. |
| `crack_rise` | <5 ms to peak | 1–8 ms | The property that makes it read as a crack rather than a thud. |
| `tail_len` | 0.5 s | 0.20–0.80 s | Debris/decay, starts on the impact frame, runs past it. |
| `sub_layer` | optional, −6 dB under the crack | 0 to −10 dB rel. crack | Below 100 Hz. Adds weight on a phone speaker where the crack alone is thin. |
| `crack_gain` | −12 dB (`0.251`) | −15 to −9 dB | −9 dB for a hero beat only. |
| `approach_gain` | −18 dB (`0.126`) | −20 to −15 dB | The approach should be felt, not heard ([[sfx-felt-not-noticed]]). |
| `layers_per_hero_beat` | 3 | 2–4 | Approach + crack + tail. Above 4 the beat turns to mush. |
| `layers_per_minor_beat` | 1 | 1–2 | Not every impact is a hero beat. |
| `reverb_wet` | 0.12 | 0.05–0.25 | Puts the studio-made sound in the shot's room ([[sfx-reverb-glue]]). |

## Reproduction prompt

```
Sound the physical action beat whose impact frame is at {{IMPACT}}
(composition seconds).

1. DECIDE THE TIER. Is this an event with a strong film convention (punch,
   whip, slam, gunshot, bone break, sword, shutter)? If YES, use the
   conventional sound and do NOT try to match the real object. If it is a
   specific object the video is about (this keyboard, this kettle), use the
   real or near-real sound instead and skip to step 5.
2. FETCH THREE LAYERS, from three different shelves:
     APPROACH - an air/whoosh 0.20-0.50s long
     CRACK    - the impulsive impact itself, chosen by FEEL not material
                (metal / wood / body variants exist; pick the feel you want)
     TAIL     - a decay, debris or low boom 0.20-0.80s
   Optionally a SUB layer below 100 Hz for weight on small speakers.
3. PLACE THE CRACK FIRST. Find its peak offset in the source, then
   data-start = {{IMPACT}} - PEAK_OFFSET. The peak must land on {{IMPACT}},
   or at most 1 frame (0.033s) early. Never late.
4. PLACE THE APPROACH so it starts at {{IMPACT}} - 0.333 (10 frames) and ends
   at or just past {{IMPACT}}. Its own peak should sit 1-2 frames BEFORE the
   crack, not on it - two peaks on one frame read as one blunt event.
5. PLACE THE TAIL with data-start = {{IMPACT}}, running past it. If it has a
   sharp head of its own, trim it with data-media-start so only the decay
   plays.
6. SET GAINS: crack 0.251 (-12 dB), approach 0.126 (-18 dB), tail 0.178
   (-15 dB), sub 6 dB under the crack. Each layer on its own track index -
   overlapping clips on one index raise duplicate_audio_track.
7. GLUE with reverb wet 0.12 on the crack and tail so they belong to the room
   rather than to the library. Skip reverb on the sub.
8. VERIFY: play the beat at normal volume once. It must read as ONE event. If
   you can hear three sounds, either the peaks are not aligned or the approach
   is too loud - realign, then lower the approach 3 dB.

ACCEPTANCE TEST: play the beat on a phone speaker as well as headphones. On
the phone the crack must still be present (that is what the sub layer and the
fast rise are for); on headphones the three layers must still read as one
event. Then ask someone what they heard: "a punch" is a pass, "a whoosh and a
bang" is a fail.
```

## Execution spec

**HyperFrames — three clips, three track indices, one aligned peak.**

```html
<!-- impact frame at 74.20s. Crack peak is 0.05s into its file. -->
<audio id="sfx-hit-approach" src=".media/audio/sfx/whoosh-air.wav" data-audio-group="sfx"
       data-start="73.867" data-duration="0.40" data-track-index="14" data-volume="0.126"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.2},{&quot;t&quot;:0.33,&quot;v&quot;:1},{&quot;t&quot;:0.40,&quot;v&quot;:0}]}]}"></audio>

<audio id="sfx-hit-crack" src=".media/audio/sfx/impact-body.wav" data-audio-group="sfx"
       data-start="74.150" data-duration="0.60" data-track-index="15" data-volume="0.251"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Shot Room&quot;,&quot;params&quot;:{&quot;size&quot;:0.5,&quot;damping&quot;:0.5,&quot;wet&quot;:0.12,&quot;dry&quot;:0.92}}]}"></audio>

<audio id="sfx-hit-tail" src=".media/audio/sfx/low-boom.wav" data-audio-group="sfx"
       data-start="74.200" data-duration="0.70" data-media-start="0.08" data-track-index="16" data-volume="0.178"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Weight Only&quot;,&quot;params&quot;:{&quot;frequency&quot;:120,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"></audio>
```
`74.150 = 74.20 − 0.05 (peak offset)`. `73.867 = 74.20 − 0.333 (10f lead)`. Keep the arithmetic in comments — it is the only record of intent.

Contract points that decide the result:
- **Seconds only, no frame attribute.** 1f = `0.033`, 10f = `0.333` at 30 fps.
- **Each layer gets its own `data-track-index`.** Overlapping `<audio>` on one index raises `duplicate_audio_track`. Track index is otherwise *display only* — *"It is not read by the render, and it constrains nothing."*
- **`data-media-start` trims a tail layer's own attack off** without cutting a file.
- **`lowpass` defaults to 8000 Hz, `highpass` to 300 Hz.** Always write `frequency` explicitly. The sub layer is a `lowpass` at 100–120 Hz, `poles: 2`.
- **`reverb` convolves a *generated* impulse** — *"preview and render generate the same one, so a room is reproducible without shipping an impulse file"* — and it adds `chainTailSeconds`, so the rendered clip runs past `data-duration`. Expected.
- **Do not compress the hit to make it bigger.** `compressor` and `limiter` have **zero automatable parameters** (AudioWorklets configured wholesale), so anything dynamic must be a `gain` stage envelope instead. And chain doctrine keeps the limiter last, as a ceiling only.
- **Keep every layer in the `sfx` group, never `voiceover`** — a non-voice member in the carve group *"poisons the next re-analysis silently."*
- **If the visual impact lives in a sub-composition**, the audio at the root needs `data-start = scene-local t + the slot's data-start`; a sub-comp timeline cannot reach host-root elements and a mistyped relative reference silently resolves to `0`.

**Epidemic Sound — three shelves, one beat.** Live-verified 2026-08-28 unless noted:

```
# CRACK - body/fight impacts, including the cartoony end
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ALL, values: ["fight--impact"] },
            duration: { min: 200, max: 4000 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }
# verified titles: "Fight, Impact, Punch, Face" (3.91 s),
#                  "Fight, Impact, Slap, Short, Fast, Cartoony" (3.56 s)

# APPROACH - air
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ANY, values: ["swooshes--whoosh","swooshes--swish"] },
            duration: { min: 300, max: 1200 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }
# verified: "Swooshes, Whoosh, Designed, Generic, Air" (0.55 s), "Swooshes, Whoosh, Wind" (1.64 s)

# TAIL / WEIGHT
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ALL, values: ["designed--boom"] },
            duration: { min: 1000, max: 3500 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }

# THE PERIOD GESTURE - the literal whip, for when the convention IS the point
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ALL, values: ["weapons--whip"] } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }
```
`weapons--whip` is the shelf recorded by [[sfx-whip-crack-on-snap-cut]]; treat the layered hybrid above as the default for action beats and the bare whip as the deliberate genre quotation. Search by **feel words in the title** — *"Punch, Face"*, *"Slap, Short, Fast"*, *"Air"*, *"Wind"* — because the catalogue's titles encode the convention better than any tag does. Then `SearchSimilarToSoundEffect { id }` for variants so the third punch is not the first punch again ([[sfx-density-fatigue-audit]]). `DownloadSoundEffect` into `.media/audio/sfx/`.

**ffmpeg — build a reusable hybrid asset once, instead of three clips every time.** For a hit you will use repeatedly, bake the stack and register it:
```bash
# align and sum three layers into one asset (approach leads by 333 ms, tail on the impact)
ffmpeg -i whoosh-air.wav -i impact-body.wav -i low-boom.wav -filter_complex \
 "[0]volume=-6dB,adelay=0|0[a];[1]volume=0dB,adelay=333|333[b];[2]volume=-3dB,lowpass=f=120,adelay=383|383[c];\
  [a][b][c]amix=inputs=3:normalize=0,alimiter=limit=-1dB[out]" -map "[out]" hit-hybrid.wav
node <SKILL_DIR>/scripts/resolve.mjs --from hit-hybrid.wav --type sfx --project .
# rise-time check (1 ms windows)
ffmpeg -i hit-hybrid.wav -af "asetnsamples=n=48,astats=metadata=1:reset=1" -f null -
```
Baking is only for assets that will be reused or that leave the pipeline; in-composition layering stays editable and is the default (*"Bake only for assets leaving the hyperframes pipeline."*)

**Remotion:** three `<Audio>` elements at computed frame offsets. Concept only; no Remotion runtime in this project.

## Pairs with
[[sfx-whip-crack-on-snap-cut]] · [[sfx-diegetic-action-inventory]] · [[sfx-real-vs-invented-sound-rule]] · [[sfx-layered-approach-and-impact]] · [[sfx-bass-drop-under-impact]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-reverb-glue]] · [[sfx-peak-on-impact-frame]] · [[sfx-felt-not-noticed]] · [[sfx-cartoon-comedy-family]] · [[sfx-density-fatigue-audit]] · [[cut-on-action]] · [[motion-camera-shake-impact]]

## Failure modes
- **Using the accurate sound on a Tier 1 event.** A real punch is a dull thud; the audience hears "wrong", not "authentic". Fix: use the convention and layer it.
- **Using the conventional sound on a Tier 2 event.** A stock "keyboard typing" over a video *about* a specific keyboard sounds like a library cue. Fix: record or source the near-real sound.
- **One layer per hit.** No approach, no tail; the beat has no size. Fix: three layers on hero beats.
- **Two peaks on the same frame.** Approach and crack peaking together read as one blunt smear rather than an arrival. Fix: approach peaks 1–2 frames before the crack.
- **A late crack.** Even 3 frames late reads as broken, well outside the ±22 ms film tolerance. Fix: measure the peak offset in the source and subtract it.
- **Approach layer too loud.** The viewer hears a whoosh followed by a bang, i.e. two events. Fix: approach at −18 dB, 6 dB under the crack.
- **Dry hits under a reverberant shot.** Studio-made sounds announce themselves. Fix: reverb wet 0.05–0.25, matched to the room.
- **The same punch three times.** Mistake number three. Fix: variants at fetch time.
- **Known gap:** the "old-school action scenes" attribution is the source's claim and is consistent with Foley practice, but no primary film-history citation was verified here for the whip specifically — treat the *heritage* claim as the creator's, and the *mechanism* claim (conventions and substitutions outperform accurate recordings) as the documented part.
