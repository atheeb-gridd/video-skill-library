---
id: sfx-ambience-layer-stack
title: Building the ambience as a stack — bed, character layer, spot events, per location
skill: sound-design
type: sfx
family: ambience
tags: [skill/sound-design, type/sfx, family/ambience, sfx/diegetic, layer/ambience, layer/sfx, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:02:49
    quote: "If you're standing on a road, then traffic; sitting in a cafe, then the sound of people talking; if you're outdoors somewhere, then birds chirping — including these creates the feel of an atmosphere."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:01:20
    quote: "Ambient sounds are the sounds that build your scene and tell the viewer the location."
research_refs:
  - https://en.wikipedia.org/wiki/Sound_effect
  - https://en.wikipedia.org/wiki/Sound_design
  - https://en.wikipedia.org/wiki/Diegesis
  - mcp://Epidemic_sounds/SearchSoundEffects (ambience--* and crowds--* slugs probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Building the ambience as a stack — bed, character layer, spot events, per location

## What it is
The rule is simple and the source states it plainly: the ambience must be the ambience of the **place on screen** — road → traffic, cafe → people talking, outdoors → birds. [[sfx-ambience-search-formula]] is how you find that file, and [[sfx-ambience-establishes-location]] is how you place, level and loop it. **This note is the construction**: what happens when one file is not enough, which is most of the time.

A single continuous ambience file reads as a **texture**, not a place. What makes a viewer believe they are somewhere is discrete, identifiable events happening at irregular intervals — the horn, the cup, the door, the one bird. The library's own guidance is that *"the most common sound design tool is the use of layering to create a new, interesting sound out of two or three old, average sounds"*, and the same is true one level up: a convincing location is two or three average ambiences plus a handful of one-shots.

So an ambience is built in **three tiers**, and the tiers do different jobs:

| Tier | What it is | Continuity | Job | Level rel. dialogue |
|---|---|---|---|---|
| **1 — Bed** | one long featureless recording; the formal *backgrounds* class — sounds that *"do not explicitly synchronize with the picture, but indicate setting to the audience"* | continuous, spans every cut in the location | supplies the noise floor and the room's size | **−28 dB** |
| **2 — Character** | the recurring texture that names the place: walla, passing traffic, birdsong, market hubbub | semi-continuous, 40–80 % duty | tells the viewer *which* place | **−24 dB** |
| **3 — Spot events** | individual identifiable one-shots at irregular times: a horn, a door, a cup, a distant shout | sparse, 2–6 per minute | makes the place *live* rather than recorded | **−20 dB** (−16 dB in a speech gap) |

Roughly **4–6 dB between tiers**, and every tier at least 12 dB under dialogue. The stack is what separates a scene that sounds like it has ambience from a scene that sounds like it is *in* a place — and its absence is one of the source's named mistakes.

One stack-specific constraint shapes tier 3 badly if you ignore it: HyperFrames bans render-time randomness — no unseeded `Math.random()`, no clocks — so the "random" spot events must be **authored at irregular times by hand**. Evenly spaced one-shots are worse than none; the ear detects a period of 3–4 s almost immediately and the place collapses back into a loop.

## When to use it
- **Any shot with a visible location that is not a neutral studio.** Street, market, cafe, office, park, car, workshop. The picture asserts a place; the sound has to agree or the viewer does not believe it.
- **Whenever a bed alone has been tried and the scene still sounds flat.** That is the diagnostic: correct file, no life. Add tier 2 first, tier 3 second.
- **Whenever a location has to carry more than ~20 seconds.** Under 20 s a bed can hold it. Over 20 s the ear needs events, or it habituates to the texture and stops hearing the place at all.
- **When the location is the *point*** — a market vlog, a travel piece, a "shot on location" claim. Then the stack is the evidence, and a full 3-tier build with 4–6 spot events per minute is proportionate.
- **Reduce to one tier** for a talking-head interior: one room-tone bed at −28 dB, no character layer, no spot events. Life in a studio reads as distraction.
- **Not under a montage cut to music.** Beds do not survive rapid cutting between locations; either commit to one place per section or drop ambience and let music carry ([[sfx-music-primacy-doctrine]]).

## How to recognise it in a reference video
- **Count the tiers by listening to the gaps.** In a speech pause, how many distinct continuous textures can you name? One = bed only. Two = bed + character. Three or more = a full stack.
- **Measure the noise floor in the gaps.** A bed-only scene shows a flat floor with <2 dB variation across 10 s. A stacked scene shows the same floor plus **discrete 4–10 dB excursions** at irregular intervals — those excursions are tier 3, and their count per minute is the finding.
- **Test the intervals for periodicity.** Log the timecodes of the spot events across 2 minutes and take the differences. Human-authored irregularity looks like `7.2, 4.1, 11.6, 3.4, 9.8`; a loop looks like `8.0, 8.0, 8.1, 8.0`. Periodicity within ±0.3 s over three consecutive gaps means somebody looped a file and called it ambience.
- **Check continuity across cuts.** In a stacked scene the bed **does not change at picture cuts inside the same location** — the floor is identical either side. A floor that steps at every cut means the ambience is riding on the production sound instead of being authored.
- **Measure the tier separation.** Short-window RMS on the bed vs on a spot event vs on dialogue. Expect roughly **dialogue 0 dB / spots −20 / character −24 / bed −28**; a scene where spot events are within 10 dB of dialogue is over-mixed and will read as a radio play.
- **Check where the spots land.** In a competent mix, tier-3 events sit in **speech gaps**, not under words. Overlay the spot timecodes on the transcript's word timings: >70 % in gaps is deliberate.
- **Location changes.** At a real location change the bed **crossfades over 12–24 frames**, it does not hard-cut. A hard bed cut at a location change is audible even when both files are right.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Tier count (talking-head interior) | 1 | 1–2 | Room tone only. Life reads as distraction. |
| Tier count (single exterior location) | 2 | 2–3 | Bed + character. |
| Tier count (location is the point) | 3 | 3–5 | Market/travel. Above 5 layers you are mixing a scene, not a video. |
| Tier 1 bed level | −28 dB → `data-volume="0.04"` | −32 … −24 dB | Under the music bed. Walla-heavy beds go to the quiet end. |
| Tier 2 character level | −24 dB → `data-volume="0.063"` | −28 … −20 dB | 4–6 dB above the bed. |
| Tier 3 spot level (under speech) | −20 dB → `data-volume="0.1"` | −24 … −18 dB | |
| Tier 3 spot level (in a speech gap) | −16 dB → `data-volume="0.158"` | −20 … −12 dB | The gap is where a spot can actually be heard. |
| Spot events per minute | 4 | 2–6 | Above 8/min it becomes a sound-effects reel. |
| Spot interval irregularity | ≥2:1 ratio between the shortest and longest gap | 1.5:1 … 5:1 | Authored, not generated — render-time randomness is banned. |
| Spots landing in speech gaps | ≥70 % | 60–100 % | Check against the transcript's word timings. |
| Tier separation | 4 dB | 3–6 dB | Less than 3 dB and the tiers fuse into one texture. |
| Dialogue headroom | ≥12 dB above the loudest ambience element | 12–20 dB | Non-negotiable. Dialogue wins. |
| Bed continuity | one clip per location, spanning every internal cut | — | Never cut the bed at a picture cut. |
| Location crossfade | 18 f (0.6 s) | 12–24 f | Spaces dissolve; they do not cut. |
| Loop crossfade (pre-built) | 1.5 s equal-power (`qsin`) | 1.0–3.0 s | Only when no single file is long enough. |
| High-pass on every tier | 90 Hz, `poles: 2` | 60–120 Hz | The node's own default is 300 Hz — always write the frequency. |
| Carve | **none** | — | Never carve an ambience layer, and never put one in the `voiceover` group. |

**Per-location recipes** — verified Epidemic slugs, with the tiers filled in:

| Location | Tier 1 bed | Tier 2 character | Tier 3 spots (2–6 /min) |
|---|---|---|---|
| **Road / street** | `ambience--traffic` "distant traffic hum", 60 s+ | `ambience--urban` city texture | single car pass, horn, motorcycle, brake squeal |
| **Café / bar** (no `ambience--cafe` slug exists) | `ambience--room-tone` interior, 60 s+ | `crowds--walla` interior conversation, 60 s+ | cup on saucer (`mechanical--click`), chair scrape, espresso machine, door |
| **Market** | `ambience--market` village/street market | `crowds--walla` dense | vendor call, hammering, bell, scooter, coins |
| **Park / outdoors** | `ambience--park` or `ambience--suburban` | `ambience--forest` birdsong | one distinct bird, dog, distant child, footsteps on gravel |
| **Office** | `ambience--office` | `crowds--walla` low + `computers--keyboard-mouse` | printer, door, chair, phone buzz |
| **Studio / interior talking head** | `ambience--room-tone` | *(none)* | *(none)* |

## Reproduction prompt
```
Build a 3-tier ambience stack for the location running {{T_IN}} to {{T_OUT}}
(composition seconds). 30 fps: 1 frame = 0.0333 s.

0. DECIDE THE TIER COUNT FIRST.
   Studio talking head        -> 1 tier  (room tone only). Stop after step 1.
   One exterior location      -> 2 tiers.
   Location is the point      -> 3 tiers.
   More layers is not more real; it is more masking.

1. TIER 1 - THE BED. One file, longer than {{T_OUT}}-{{T_IN}} if at all possible.
   SearchSoundEffects tagSlugs ALL ["<place slug>"], duration.min 60000, sort by
   DURATION DESCENDING. Place as ONE clip spanning every cut inside this location:
   data-start {{T_IN}}, data-duration {{T_OUT}}-{{T_IN}}, data-volume 0.04.
   Add highpass 90 Hz poles 2 (the node defaults to 300 Hz - write it). Fade 1.0 s in
   and out via a volume lane with an explicit t=0 point.
   NEVER cut the bed at a picture cut. If no file is long enough, pre-build a loop
   with ffmpeg acrossfade - do not loop by repeating the clip.

2. TIER 2 - THE CHARACTER LAYER. The texture that NAMES this place (walla for a cafe,
   birds for a park, city hum for a road). One more long file, own track index,
   data-volume 0.063, same highpass, offset its data-media-start by 20-40 s from the
   bed's so the two do not correlate. Duty cycle 40-80%: either let it run, or lane it
   down to v=0.3 for 10-20 s stretches so the place breathes.

3. TIER 3 - SPOT EVENTS. Target 4 per minute. For each:
   - Choose a time IN A SPEECH GAP. Read the transcript word timings; aim for >=70%
     of spots landing in gaps.
   - Space them IRREGULARLY. The ratio of your longest to shortest gap must be at
     least 2:1. Do NOT generate these times at render - unseeded randomness is banned
     in this stack. Author them, e.g. +7.2, +11.3, +4.1, +9.8, +3.4 seconds.
   - data-volume 0.158 in a gap, 0.1 under speech. Length 0.3-2.0 s. Own track index
     per overlapping pair.
   - Rotate assets: never the same spot file twice in a row.

4. LEVELS. Verify the ladder: dialogue 0 dB, spots -20/-16, character -24, bed -28.
   4-6 dB between tiers. Every ambience element at least 12 dB under dialogue.

5. NEVER carve an ambience layer and never add one to the voiceover group. Carve is
   for music under narration; a bed inside the voiceover group poisons the next
   carve re-analysis silently.

ACCEPTANCE TEST.
(a) Mute the picture. A listener names the place inside 3 seconds.
(b) In a 10 s speech gap you can name 2 (or 3) distinct continuous textures.
(c) Take the differences between spot-event times: longest/shortest >= 2. If any
    three consecutive gaps are within 0.3 s of each other, re-author them.
(d) The noise floor 0.5 s either side of every internal picture cut differs by <=2 dB.
(e) Dialogue is fully intelligible with the whole stack at level.
```

## Execution spec

**Placement spec (the three numbers, per tier).**

| | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Tier 1 bed | starts 0.3 s before the location's first frame, ends 0.3 s after its last | −28 dB (`data-volume` 0.04) | **none** — never carve a bed |
| Tier 2 character | same window as the bed, `data-media-start` decorrelated by 20–40 s | −24 dB (0.063) | none; optional slow `volume` lane for duty cycle |
| Tier 3 spot | on its authored time; **in a speech gap** | −16 dB in gap (0.158) / −20 dB under speech (0.1) | none |
| Location change | 18-frame crossfade between two beds on different track indices | — | mirrored `volume` lanes |

**HyperFrames — three tiers, three or more clips, one group, no carve.**

```html
<!-- market location, 62.00 s -> 121.00 s -->
<hf-audio-group id="ambience" data-label="Ambience" data-volume="1"></hf-audio-group>

<!-- tier 1: bed, one clip across every internal cut -->
<audio id="amb-market-bed" src=".media/audio/sfx/ambience-market-183s.wav"
       data-audio-group="ambience" data-track-index="11"
       data-start="62.00" data-duration="59.00" data-media-start="8.00"
       data-volume="0.04"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:90,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.0,&quot;v&quot;:1},{&quot;t&quot;:58.0,&quot;v&quot;:1},{&quot;t&quot;:59.0,&quot;v&quot;:0}]}]}"></audio>

<!-- tier 2: character layer, decorrelated by 31 s of media offset -->
<audio id="amb-market-walla" src=".media/audio/sfx/walla-dense-223s.wav"
       data-audio-group="ambience" data-track-index="12"
       data-start="62.00" data-duration="59.00" data-media-start="39.00"
       data-volume="0.063"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;params&quot;:{&quot;frequency&quot;:90,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.5,&quot;v&quot;:1},{&quot;t&quot;:24,&quot;v&quot;:1},{&quot;t&quot;:27,&quot;v&quot;:0.35},{&quot;t&quot;:38,&quot;v&quot;:0.35},{&quot;t&quot;:41,&quot;v&quot;:1},{&quot;t&quot;:57.5,&quot;v&quot;:1},{&quot;t&quot;:59,&quot;v&quot;:0}]}]}"></audio>

<!-- tier 3: authored, irregular, in speech gaps. Track indices differ where they overlap. -->
<audio id="amb-spot-01" src=".media/audio/sfx/scooter-pass.wav"  data-audio-group="ambience"
       data-track-index="13" data-start="69.20" data-duration="1.80" data-volume="0.158"></audio>
<audio id="amb-spot-02" src=".media/audio/sfx/vendor-call.wav"   data-audio-group="ambience"
       data-track-index="14" data-start="80.50" data-duration="1.20" data-volume="0.158"></audio>
<audio id="amb-spot-03" src=".media/audio/sfx/hammering.wav"     data-audio-group="ambience"
       data-track-index="13" data-start="84.60" data-duration="0.90" data-volume="0.100"></audio>
<audio id="amb-spot-04" src=".media/audio/sfx/bell-small.wav"    data-audio-group="ambience"
       data-track-index="14" data-start="94.40" data-duration="1.40" data-volume="0.158"></audio>
<audio id="amb-spot-05" src=".media/audio/sfx/coins.wav"         data-audio-group="ambience"
       data-track-index="13" data-start="97.80" data-duration="0.70" data-volume="0.158"></audio>
```

The details that make this work rather than merely parse:
- **Spot gaps: 11.3, 4.1, 9.8, 3.4 s.** Longest/shortest = 3.3:1. That irregularity is authored deliberately; **unseeded `Math.random()` is banned** and a render-time clock would not be deterministic anyway.
- **`data-media-start` decorrelates tier 2 from tier 1.** Two copies of the same recording, or two recordings starting at the same point, phase-lock in the ear. A 20–40 s offset is free and fixes it.
- **Overlapping clips need different `data-track-index` values** — two `<audio>` sharing an index *and* overlapping raises `duplicate_audio_track`. Spots alternate 13/14 for exactly that reason.
- **Every `<audio>` needs an `id`.** No id → never mixed → **silent render** (lint error `media_missing_id`).
- **A lane holds its first value backwards to the clip start and its last forward to the end**, so both the `t:0` point and the final point are load-bearing.
- **`highpass` defaults to 300 Hz** — writing `frequency: 90` explicitly is the difference between a bed and a thin hiss.
- **No carve, no `voiceover` group.** *"Keep the carve group voices only: a bed or an SFX clip inside the named group poisons the next re-analysis silently."* An ambience stack at −28 dB needs room, not a moving spectral hole.
- **Audio lives at the host root** in a modular project — *"Keep audio at the root, visual segments as sub-comps"* — which is exactly what bed continuity across scene cuts requires.
- **Known limit: there is no loop attribute.** A bed shorter than its scene must be pre-built with ffmpeg; repeating the clip produces an audible seam at every join.
- **Known limit: no panner or width control** exists in the FX registry (filters, dynamics, nonlinear, delay/reverb/chorus/phaser — no pan). Spot events cannot be placed left/right in-composition. Bake the position with ffmpeg or accept centre.

**Epidemic Sound — the stack, tier by tier.** All slugs below probed live 2026-08-28; an unknown slug **fails closed** at `meta.total: 0`.

```
# TIER 1 - long, featureless, place-named
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["ambience--market"] },
                               duration: { min: 60000 } },
                     sort: { by: DURATION, order: DESCENDING }, first: 15 }
# verified shelves: ambience--market (364) · ambience--traffic · ambience--park ·
#   ambience--urban · ambience--suburban · ambience--forest · ambience--desert ·
#   ambience--office · ambience--room-tone
# NOT VALID (0 results): ambience--cafe, ambience--restaurant. For a cafe use
#   ambience--room-tone as the bed and crowds--walla as the character layer.

# TIER 2 - the texture that names the place
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["crowds--walla"] },
                               duration: { min: 60000 } },
                     query: { term: "interior conversations neutral" }, first: 12 }
# verified: crowds--walla at duration.min 60000 holds 367 files.

# TIER 3 - one-shots, fetched per event, rotated
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["mechanical--click"] },
                               duration: { min: 200, max: 3000 } },
                     query: { term: "close variations" }, first: 8 }
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["footsteps--human"] },
                               duration: { min: 2000, max: 20000 } },
                     query: { term: "street gravel" }, first: 8 }
```
Prefer titles containing **"Variations"** for tier 3 — one download then supplies the whole rotation set ([[sfx-repetition-variant-rotation]]). Use `SearchSimilarToSoundEffect(id)` to build a coherent spot palette for one location. Download WAV.

**ffmpeg — the two things the composition cannot do: loop, and position.**
```bash
# seamless double of a bed, 1.5 s equal-power crossfade onto itself
ffmpeg -i amb.wav -i amb.wav -filter_complex "acrossfade=d=1.5:c1=qsin:c2=qsin" amb.x2.wav
# build a 3-minute bed from a 60 s file (aloop counts SAMPLES: 48000 * 60)
ffmpeg -i amb.wav -af "aloop=loop=2:size=2880000" -t 180 amb.180s.wav
# decorrelate a second copy for tier 2 if you have only one recording
ffmpeg -i amb.wav -af "atrempo=1.0,areverse" amb.rev.wav      # reversed = decorrelated
# bake a spot event slightly off-centre, since there is no panner in-composition
ffmpeg -i horn.wav -af "pan=stereo|c0=0.85*c0|c1=0.35*c1" horn.left.wav
# floor check for the acceptance test
ffmpeg -i mix.wav -af "silencedetect=n=-45dB:d=0.35" -f null -
```
Register derived files: `node <SKILL_DIR>/scripts/resolve.mjs --from amb.180s.wav --type sfx --project .`

**Remotion.** Three `<Audio>` layers with constant volumes plus an array of one-shot `<Sequence>`s at authored frames. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-ambience-establishes-location]] · [[sfx-ambience-search-formula]] · [[sfx-missing-ambience-audit]] · [[sfx-noise-floor-target]] · [[sfx-hard-cut-audio-seam]] · [[sfx-three-types-classification]] · [[sfx-five-layers-build-order]] · [[sfx-layer-volume-targets]] · [[sfx-diegetic-action-inventory]] · [[sfx-repetition-variant-rotation]] · [[sfx-filter-character-and-distance]] · [[sfx-narration-over-reenactment]] · [[sfx-dialogue-gate]] · [[cut-stock-footage-substitute]]

## Failure modes
- **Periodic spot events.** The single most damaging error, because it converts a place back into a loop. Three consecutive gaps within ±0.3 s of each other is audible to a naive viewer as "the sound is repeating". Author irregular gaps with a ≥2:1 ratio.
- **Stacking without separating levels.** Three layers all at −24 dB fuse into one loud texture that masks dialogue and names nothing. The 4–6 dB ladder is what keeps them legible as separate things.
- **Two copies of the same file, or two files starting at the same offset.** They phase-lock and sound like one louder file. Offset `data-media-start` by 20–40 s.
- **Spot events under stressed syllables.** They fight the words and lose, so you raise them, and now they fight the words and win. Move them into gaps instead.
- **Cutting the bed at picture cuts.** Produces a noise-floor step at every cut inside one location and is the classic "sounds like an edit" defect.
- **Hard-cutting between locations.** Spaces dissolve. An 18-frame crossfade costs nothing and removes the entire problem.
- **Carving the ambience, or filing it under `voiceover`.** Both are silent corruption: the first puts a moving spectral hole in the room, the second poisons the music carve's next analysis with non-voice material.
- **Over-building a studio interior.** Birds and traffic under a talking head in a bedroom is a location the picture contradicts. One room tone, nothing else.
- **Known gap — no loop primitive and no panner.** Long beds and any stereo placement must be pre-built with ffmpeg and re-imported. Budget the render step, and remember the vault cannot delete, so keep the intermediates outside the mount.
