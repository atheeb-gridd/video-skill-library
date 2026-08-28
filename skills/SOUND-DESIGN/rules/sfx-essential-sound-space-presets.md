---
id: sfx-essential-sound-space-presets
title: Put the sound in a place — the eight named space presets, and their in-stack equivalents
skill: sound-design
type: mix
family: space-and-distance
tags: [skill/sound-design, type/mix, family/space-and-distance, sfx/diegetic, layer/sfx, layer/dialogue, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "visual — contact sheet, Premiere Essential Sound panel"
    quote: "[NOT SPOKEN — read off screen] Preset dropdown: Default · Explosion · From Outside · From the Left · In a Large Room · Make Close Up · Make Distant · Make Medium Shot"
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:10:04"
    quote: "Change the reverb, change the pitch, change the duration - change all of these and you can make a unique number of variations out of one single sound effect."
research_refs:
  - https://en.wikipedia.org/wiki/Reverberation
  - https://en.wikipedia.org/wiki/Inverse-square_law
  - https://en.wikipedia.org/wiki/Low-pass_filter
  - https://en.wikipedia.org/wiki/Sound_localization
  - _meta/visual-kt-delta.md
difficulty: medium
detectable_from: audio
---

# Put the sound in a place — the eight named space presets, and their in-stack equivalents

## What it is
The narration in `sfx kt 1` names **reverb** as one of three levers for making variations from one file, and stops there. The screen shows what "reverb" actually means in that workflow: Premiere's Essential Sound panel with its preset dropdown open, reading

```
Default · Explosion · From Outside · From the Left · In a Large Room ·
Make Close Up · Make Distant · Make Medium Shot
```

That list is worth more than the word it replaces, because it is not a list of reverbs — it is a list of **placements**. Six of the eight describe where the sound is *relative to the camera and the room*: outside, to the left, in a large room, close up, medium, distant. The panel's own vocabulary is **shot language applied to sound**, and that is the useful idea: an effect is not "wet" or "dry", it is at a distance, in a room, on a side.

Three physical cues do all the work, and they are why the presets differ from one another rather than being one knob:

1. **Direct-to-reverberant ratio.** Distance is heard as the balance between the direct sound and the room's reflections, far more than as level. Reverberation is reflections arriving *"in a sequence of less than approximately 50 ms"*; past that they separate into audible echoes. More wet = further away.
2. **High-frequency loss.** Air, walls and distance are low-pass filters. A sound from outside, or through a door, or across a room, loses its top before it loses its body ([[sfx-filter-character-and-distance]]).
3. **Level, following the inverse-square law** — roughly **−6 dB per doubling of distance** for a point source in free field. This is the smallest of the three cues and the one people over-use: turning an effect down does not make it distant, it makes it quiet.

`Make Close Up` inverts all three: dry, full top, plus a little low-frequency weight — the proximity effect a close mic gives. `From the Left` is not a space at all but a **position**, and it is the one preset with no equivalent in this stack. `Explosion` is a character preset wearing a space name.

This note owns the **placement decision and its parameter mapping**. The general argument for gluing library effects into the scene's room lives in [[sfx-reverb-glue]]; tail length as perceived size lives in [[sfx-reverb-size-and-tail]]; filter-as-distance lives in [[sfx-filter-character-and-distance]].

## When to use it
- **On any library effect dropped into a shot with a visible room.** A dry catalogue file in a reverberant kitchen is the single most common "sounds pasted on" tell.
- **When a DIY or performed effect needs finishing.** The mouth-recorded whoosh chain ends dry; a space preset is what makes it belong ([[sfx-foley-family]]).
- **To generate variations from one file.** Space is the third lever alongside pitch and duration, and the cheapest of the three because it does not touch the transient ([[sfx-variation-set-generator]]).
- **To place a sound off screen.** `From Outside` and `Make Distant` are how a sound says "this is happening elsewhere" without a cutaway ([[sfx-diegetic-spotting-list]]).
- **On dialogue for a POV or a memory** — the same presets are how a phone-call futz or a flashback is built ([[sfx-phone-call-cross-cut-treatment]]).
- **Not on the music bed.** Beds arrive with their own space; adding a room to a bed muddies the low mids and eats the carve's headroom.
- **Not to fix a level problem.** If the effect is too loud, lower it; distance is not a volume control.

## How to recognise it in a reference video
- **Compare the effect's tail with the room on screen.** Freeze on a wide interior and listen to the decay of the nearest effect. A tail near zero in a tiled or large room means the sound was never placed.
- **Listen for consistency across a scene.** All effects sharing one space is a designed mix; some dry and some wet inside a single location is an unfinished one.
- **Off-screen sounds should be duller than on-screen ones.** If a sound the picture says is outside has the same top end as one on the desk, no placement was applied.
- **Check for the close-up cue.** A deliberately close sound has extra 100–250 Hz weight and no room. If everything in a video sounds close, that is a house style — log it.
- **Measure it if you need certainty.** Compare spectral tilt above 5 kHz between an on-screen and an off-screen instance of the same family: `ffmpeg -i ref.wav -af aspectralstats=measure=centroid -f null -`. A distant instance should show a centroid several hundred Hz lower.
- **Stereo position is a separate axis.** A sound that sits left while the object is left is placement; a sound that wanders is an artefact of the file, not a choice.

## Parameters

The mapping from each named preset to this stack's own parameters. `reverb` here is the FX-registry node (`size` 0.05–1, `damping` 0–1, `wet` 0–1, `dry` 0–1); the presets `room-tight`, `room-natural`, `hall`, `slap-echo`, `dub-throw` are the shipped equivalents and the **Space** one-knob profile drives `size`/`wet`/`dry` together, level-matched.

| Preset | What it means | `reverb` | Filter | Level | Nearest shipped preset |
|---|---|---|---|---|---|
| **Default** | No placement — the file as fetched | none | none | 0 dB | — |
| **Make Close Up** | At the mic, in your ear | `wet 0.05, dry 1.0, size 0.2` | `lowshelf 200 Hz +2 dB` | +1 dB | `room-tight` at low amount |
| **Make Medium Shot** | Same room, a few metres | `wet 0.18, dry 0.9, size 0.5, damping 0.5` | `lowpass 9 kHz` | −3 dB | `room-natural` |
| **Make Distant** | Far side of the room | `wet 0.45, dry 0.55, size 0.8, damping 0.6` | `lowpass 4.5 kHz` | −9 dB | `room-natural` at high amount |
| **In a Large Room** | Hall, warehouse, church | `wet 0.35, dry 0.7, size 0.9, damping 0.35` | `lowpass 12 kHz` | −2 dB | `hall` |
| **From Outside** | Through a wall or window | `wet 0.25, dry 0.8, size 0.7, damping 0.7` | `lowpass 1.5 kHz` + `highpass 120 Hz` | −8 dB | `room-natural` + heavy LP |
| **From the Left** | Position, not space | unchanged | optional `highshelf −2 dB` | unchanged | **no in-stack equivalent** — see below |
| **Explosion** | Character, not a room | `wet 0.4, dry 0.9, size 1.0, damping 0.25` | `lowshelf 80 Hz +4 dB` | +2 dB, limiter last | `hall` + [[sfx-bass-drop-under-impact]] |

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `distance_level_law` | −6 dB per doubling | −4 to −7 | Inverse-square, free field. Indoors the reverberant field flattens it, so lean on wet/dry instead. |
| `wet_step_per_shot_size` | +0.15 | 0.1–0.2 | The usable increment between close, medium and distant. Smaller is not perceptible. |
| `lp_step_per_shot_size` | ÷2 | — | Halve the low-pass corner per step outward: 9 k → 4.5 k → 2 k. |
| `space_consistency` | one room per scene | — | Every effect in a location shares `size` and `damping`; only `wet`/`dry` and the filter move per object. |
| `tail_vs_cut` | tail ≤ shot length | — | A 2 s tail on a 1 s shot rings across the cut ([[sfx-reverb-size-and-tail]], [[sfx-hard-cut-audio-seam]]). |

## Reproduction prompt

```
Place effect {{SFX}} in the space the picture shows, using the preset mapping.

1. NAME THE PLACEMENT IN SHOT LANGUAGE first, from the picture, not from the
   sound: close up / medium / distant / large room / outside / off left.
   If you cannot name it, the answer is Default and you are finished.
2. LOOK UP the row in the mapping table and take its reverb, filter and level
   as the starting point.
3. SET ONE ROOM PER SCENE. Pick `size` and `damping` once per location and
   reuse them for every effect in it; vary only wet/dry, the low-pass corner
   and the level per object. Two different rooms in one scene is the error.
4. FILTER BEFORE REVERB in the chain - subtract before you add. Order is
   signal order: highpass/lowpass, then reverb, then any gain, limiter last.
5. CHECK THE TAIL against the shot: if the reverb tail is longer than the
   remaining shot, shorten `size` or accept that it will ring over the cut.
6. A/B AGAINST DRY at matched loudness. If the placed version is merely
   quieter and duller with no sense of location, raise wet by 0.1 and lower
   the low-pass by an octave rather than pulling the fader further.

ACCEPTANCE TEST: mute the picture and play the scene's effects alone. A
listener should be able to say which sounds are near, which are far, and
which are outside - without seeing anything.
```

## Execution spec

**HyperFrames — the chain, in signal order.** `Make Distant` on a door slam:

```html
<audio id="sfx-door-distant" src="assets/sfx/door-slam.wav"
       data-audio-group="sfx" data-start="18.20" data-duration="2.40"
       data-track-index="12" data-volume="0.045"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Distance HF Loss&quot;,&quot;params&quot;:{&quot;frequency&quot;:4500,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Far Side Of The Room&quot;,&quot;params&quot;:{&quot;size&quot;:0.8,&quot;damping&quot;:0.6,&quot;wet&quot;:0.45,&quot;dry&quot;:0.55}}]}"></audio>
```
Facts that govern this: **order is signal order**, and the doctrine is *"subtract before you add, level after you filter… character and ceiling last"*. `params` are in human units and **out-of-range values are clamped on read**, so nothing here can fail at runtime — it can only sound wrong. Reverb convolves a **generated** impulse, identical in preview and render, so a room is reproducible without shipping an impulse file. `size` and `damping` **regenerate the impulse and are therefore not automatable**; `wet` and `dry` automate fine, which is how a sound *moves* through a space — automate wet/dry, never size. Every `<audio>` needs an `id` or it is silently never mixed. Write JSON attributes double-quoted with `&quot;`.

To place a whole location's worth of effects, put them in one `<hf-audio-group>` and hang the reverb on the bus: *"one chain, one fader, one automation clock for every member"* — which is also the cheapest way to guarantee one room per scene.

**Shipped space presets.** `room-tight`, `room-natural`, `hall`, `slap-echo`, `dub-throw` write ordinary nodes tagged `fromPreset`; applying appends, re-applying replaces its own nodes in place. `presetAmount` (0..1) fades the whole preset and **`fx.preset.<id>`** is the only automation target that moves a preset as a unit. Do not stack two character presets — *"these are costumes."*

**`From the Left` has no in-stack route.** There is no panner in the FX registry, so stereo position must be baked before the file enters the composition:
```bash
# hard-ish left, with a small HF loss on the far side
ffmpeg -i door-slam.wav -af "pan=stereo|c0=0.85*c0|c1=0.35*c0,highshelf=f=6000:g=-2" door-left.wav
# bake a distance placement for an asset leaving the pipeline
ffmpeg -i door-slam.wav -af "lowpass=f=4500,aecho=0.8:0.7:60:0.35,volume=-9dB" door-distant.wav
```
Measure rather than trust the ear alone: `ffmpeg -i placed.wav -af aspectralstats=measure=centroid -f null -`.

**Premiere, for reference.** The eight names above are the Essential Sound panel's own list; this note reproduces their *intent*, not their internals, and no claim is made about the exact impulse or EQ Adobe uses.

**Remotion.** Volume only; every filter and reverb has to be baked into the file first.

## Pairs with
[[sfx-reverb-glue]] · [[sfx-reverb-size-and-tail]] · [[sfx-filter-character-and-distance]] · [[sfx-variation-set-generator]] · [[sfx-foley-family]] · [[sfx-ambience-layer-stack]] · [[sfx-diegetic-spotting-list]] · [[sfx-phone-call-cross-cut-treatment]] · [[sfx-library-quality-gate]] · [[sfx-ten-family-catalogue]]

## Failure modes
- **Reading the preset list as reverb amounts.** They are placements. Choose from the picture — close, medium, distant, outside — not from a wetness slider.
- **Two rooms in one scene.** Different `size`/`damping` per effect inside one location reads as an error even to untrained listeners. Fix with a bus.
- **Distance by fader.** Level is the weakest of the three cues; without the HF loss and the wet increase it just sounds quiet.
- **Reverb before filtering.** Filtering after the reverb dulls the tail as well as the source and collapses the sense of room. Subtract first.
- **Automating `size`.** Not automatable — it regenerates the impulse. Automate `wet`/`dry` to move a sound through a space.
- **Long tails on short shots.** A `size 0.9` hall on a 20-frame cutaway rings straight over the seam.
- **Placing the music bed.** Beds carry their own space; a room on top eats the low mids the voice needs.
- **Stacking two character presets.** `telephone` plus `megaphone` is not twice the character, it is unintelligible.
- **Known gap:** there is **no panner** in this stack, so `From the Left` — the one purely positional preset — cannot be expressed in-composition and must be baked with ffmpeg before placement.
