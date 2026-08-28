---
id: sfx-real-vs-invented-sound-rule
title: Real objects dictate their sound, invented ones don't — the plausibility rule
skill: sound-design
type: sfx
family: sound-selection
tags: [skill/sound-design, type/sfx, family/sound-selection, engine/epidemic, engine/hyperframes, engine/ffmpeg, layer/sfx, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:20"
    quote: "[...] is the sound effect, and if you put a water sound effect in its place, it'll just feel weird."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:23"
    quote: "But for things that don't even exist in real life, you can creatively use any sound effect you want. The speed and timing just have to match."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:09:06"
    quote: "If you need the sound of a bone breaking, you can take the sound of wood breaking and mix it with a water splash. Or you can take the sound of a cucumber snapping."
research_refs:
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://en.wikipedia.org/wiki/Diegetic_music
  - https://en.wikipedia.org/wiki/Convolution_reverb
  - https://blog.prosoundeffects.com/sound-layering
  - mcp://Epidemic_sounds/SearchSoundEffects (material-variant searching verified live, 2026-08-27)
difficulty: medium
detectable_from: transcript+video
---

# Real objects dictate their sound, invented ones don't — the plausibility rule

## What it is
This is the gate that sorts a moment into one of the three styles before any searching happens. Ask one question about the thing on screen: **could a viewer point at what is making this sound?**

- **Yes** — a door, a page, a phone, a footstep, a mug. The choice is **constrained**. The viewer holds an expectation of what that object sounds like, and a wrong sound is not neutral, it is actively wrong: put a water sound where a paper sound belongs and "it'll just feel weird". This is the `sfx/diegetic` group.
- **No** — a title sliding in, a bar filling, an abstract line animating, a card flipping, a graph growing. The choice is **free**. There is no referent to be faithful to, so any sound works provided its **speed and timing match** the motion. This is the `sfx/motion` and `sfx/aesthetic` territory, and the envelope, not the label, is what has to be right.

The refinement research adds is important and easy to miss: the constraint on real objects is on the **result**, not the **source**. Foley has always been substitution — coconut shells for hooves, cornstarch for snow, frozen lettuce for bone — and the source video's own recipe (wood snap plus water splash for a breaking bone, or a snapping cucumber) is exactly that tradition. So "real object" does not mean "recording of that object". It means the sound must satisfy the viewer's expectation on three axes: **material, size/mass, and force/speed.** Match those three and no one can tell what actually made the noise.

**Style.** No `sfx/` style tag by construction: this note is the sorter that *assigns* one, and its yes/no question is the boundary between `sfx/diegetic` on one side and `sfx/motion` plus `sfx/aesthetic` on the other ([[sfx-three-types-classification]]).

## When to use it
Apply the gate **once per sound-design row, before searching**. It is the first column of the design document, and it determines everything downstream: which family to search, how much licence you have, how to judge a candidate, and how tightly to sync.

Two secondary rules follow from it and are worth applying deliberately:
- **A partially-real object inherits the constraint.** A stylised, illustrated phone still has to ring like a phone. Recognisability, not photorealism, is what triggers the constraint.
- **Invented objects need a vocabulary, not a free-for-all.** The licence is per-object, not per-instance: once an invented element has a sound, the *same* element gets the *same* sound family every time it appears in the video. Otherwise the piece has no sonic grammar and every appearance reads as a new thing.

## How to recognise it in a reference video
- **Build a two-column list** while scrubbing: real-referent events and invented-graphic events. The **ratio** is a strong style signature — heavy diegetic with sparse design reads documentary; heavy design with no diegetic reads "cheap"; the source creator's own balance is roughly even.
- **Test the real column for material match.** Does the sound's spectral character agree with the visible material? Wood/paper = mid-band with fast decay; metal = ringing partials, long decay; glass = bright transient plus high partials; cloth = broadband, no pitch. A mismatch here is the "feels weird" failure and is audible to everyone even though almost no one can name it.
- **Test the real column for size.** Bigger objects read darker (lower spectral centroid, more energy below 200 Hz). A large door with a thin, bright click is a size mismatch.
- **Test the invented column for envelope match, not literal match.** Compare effect duration to motion duration (**1.0–1.3×** the motion), and check where the effect's peak sits relative to the motion's fastest frame. Literal correspondence is irrelevant here; sync is what creates the meaning. Detail lives in [[sfx-envelope-matched-to-easing-curve]].
- **Check consistency in the invented column.** Does the same graphic get the same sound each time? Inconsistency is a defect to log even when each individual choice is good.
- **Look for substitution evidence in the real column.** Hyper-real, larger-than-life object sounds (a mechanical keyboard that sounds like a rifle bolt, a swipe that sounds like a blade) mean the creator is substituting deliberately for a heightened register. That is a style decision to reproduce, not an error.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Gate question | "can the viewer point at the source?" | — | Answer it before searching. One answer per design row. |
| Real-object axes that must match | material, size, force | all three | Substitution is legal; a mismatch on any of the three is not. |
| Real-object sync | peak on the contact frame, 0 to +1 f | −0 to +2 f | Tighter than the invented case; the viewer has a prior. |
| Invented-object sync | peak at the motion's fastest frame | ±1 f | Read the peak position off the easing curve, not from "the middle". |
| Invented-object duration ratio | 1.15× the motion | 1.0–1.3× (body) | Tail may exceed. |
| Real-object level | −13 dB hero, −20 dB background | −12 to −24 dB | See [[sfx-diegetic-action-inventory]]. |
| Invented-object level | −13 dB | −12 to −15 dB | Standard SFX tier. |
| Reuse rule (invented) | same element → same family, every time | — | Vary the take, not the family. |
| Substitution layers | 2 | 1–3 (max 5) | E.g. wood snap + water splash for a break. |
| Pitch as a size control | ±0 | −5 to +5 st | Down = larger/heavier; up = smaller/lighter. |

## Reproduction prompt

```
Classify every sound row in design-sound.md with the plausibility gate, then
apply the matching selection procedure.

FOR EACH ROW:
1. ASK: could a viewer point at the thing making this sound?
     YES -> CONSTRAINED. Continue at step 2.
     NO  -> FREE. Continue at step 4.

2. CONSTRAINED: write down the three axes before searching.
     material = wood | paper | metal | glass | plastic | cloth | liquid | flesh
     size     = tiny | hand-held | body | large | huge
     force    = light | normal | hard | violent
   Search the noun chain in catalogue order (Category, Object, Descriptors):
     SearchSoundEffects { query:{term:"<material> <object> <action>"},
       filter:{ tagSlugs:{matchType:ALL,values:["<family slug>"]},
                duration:{min:150,max:3000} }, first:8 }
3. CONSTRAINED: judge candidates ONLY on the three axes. If nothing in the
   catalogue matches, SUBSTITUTE - build it from two or three files whose
   combined material/size/force reads correctly (e.g. bone break = wood snap +
   water splash). Do not settle for a plausibly-named file that sounds wrong.
   Place the contact transient on the contact frame, 0 to +1 frame.

4. FREE: do NOT search for the object's name - it has none. Search by the
   ENVELOPE you need, derived from the motion spec:
     duration  = motion duration x 1.15
     peak      = the frame of maximum visual velocity (read off the ease:
                 out-ease -> 10-20% in; inOut -> 50%; in-ease -> 85-100%)
     attack    = snappy motion (<0.3 s) -> <20 ms; calm motion -> 80-200 ms
     direction = up/out/growing -> rising pitch; down/in/settling -> falling
5. FREE: check the video's existing vocabulary. If this element type already has
   a sound elsewhere in the video, REUSE THAT FAMILY and vary only the take or
   the pitch. Log the element->family mapping so later rows can honour it.
6. BOTH: set data-volume "0.224" (-13 dB) unless the row says otherwise, put it
   in data-audio-group "sfx", and route it through the group's shared reverb so
   it belongs to the same space as everything else.

ACCEPTANCE TEST: play each constrained row muted, then unmuted, and ask a
one-word question of the sound: "what is it?" If the answer is not the object on
screen, the row fails - change it, do not lower it. For each free row, mute the
picture: the sound alone should tell you how fast and in which direction
something moved. Finally, scan the video for any invented element that has two
different sounds on two appearances, and unify them.
```

## Execution spec

**Hyperframes.** The gate itself is a planning decision, not an attribute — but it decides which mechanisms you use downstream.

- **Constrained rows** are placed on contact frames with measured peak offsets and get the SFX bus's shared reverb so they share the scene's space (see [[sfx-reverb-glue]]).
- **Free rows** are placed against the animation's timeline position, which is authored by hand at the same number as the tween: there is no audio-follows-animation attribute. Their duration is fitted with `data-media-start` + `data-duration`, or with `data-playback-rate` (constant, `0.1..5`, pitch-preserved) — **there is no rate envelope**, so a speed ramp on an effect must be preprocessed as a file.
- Substitution layers are simply two or three `<audio>` clips sharing a `data-start`, each with its own `id` and a **different `data-track-index`** (two `<audio>` on one track index overlapping in time raises `duplicate_audio_track`).

```html
<!-- constrained + substituted: "bone break" = wood snap (material) + water splash (flesh) -->
<audio id="sfx-break-wood" src="assets/audio/sfx/wood-snap-dry.wav"
       data-audio-group="sfx" data-start="34.108" data-duration="0.5"
       data-track-index="12" data-volume="0.224"></audio>
<audio id="sfx-break-wet" src="assets/audio/sfx/water-splash-short.wav"
       data-audio-group="sfx" data-start="34.112" data-duration="0.45"
       data-track-index="13" data-volume="0.126"></audio>
```

For an invented element, the character controls in the FX registry are the ones the source video names as the mixing toolkit: `highpass` (300–800 Hz) to make an effect feel sharp, `lowpass` (1500–3000 Hz) to make it muffled and distant, `saturate` for weight, `reverb` for space. Order is signal order and any limiter goes last. Note that `saturate`'s `type`/`threshold`/`oversample` and `reverb`'s `size`/`damping` are **not automatable** — automate a `gain` stage around them instead.

**Epidemic Sound.** Two different search strategies, one per branch of the gate:

- **Constrained:** search the **noun chain in catalogue order**. Titles are built `Category, Subcategory, Object, Descriptors, Variant NN`, so `paper handle notepad page turn` beats `page flip sound`. Verified shelves include `paper--handle`, `computers--keyboard-mouse`, `communications--camera`, `clocks--tick`, `human--breath`, `human--heartbeat`, `ambience--room-tone`. Material variants are usually siblings on the same shelf (the source video's own note that hits come in "metal, wood" variations holds in the catalogue), so find one hit, read `tags[].slug`, and re-search filtered to that slug.
- **Free:** search the **envelope and register**, not the object — `whoosh transition fast light`, `designed impact low sub`, `riser tension build`, `swish short bright` — on the designed shelves (`designed--whoosh`, `swooshes--whoosh`, `swooshes--swish`, `user-interface--click`). Then use `SearchSimilarToSoundEffect` to build the family the element will keep for the rest of the video.

**ffmpeg.** Building a substitution: `ffmpeg -i wood.wav -i water.wav -filter_complex "[0]volume=1[a];[1]volume=0.5,adelay=4|4[b];[a][b]amix=inputs=2:normalize=0" break.wav` — bake the composite only when the two-clip in-composition version is unwieldy. Size adjustment by pitch: `ffmpeg -i door.wav -af "asetrate=48000*0.88,aresample=48000" door.big.wav`.

**Remotion.** Same idea, two `<Audio>` elements inside one `<Sequence>` for a substitution; the free/constrained distinction is authorial and has no API surface.

## Pairs with
[[motion-abstract-object-sound-contract]] · [[sfx-envelope-matched-to-easing-curve]] · [[sfx-diegetic-action-inventory]] · [[sfx-three-types-classification]] · [[sfx-reverb-glue]] · [[sfx-name-before-search]] · [[sfx-layered-approach-and-impact]] · [[sfx-motion-sound-selection]] · [[sfx-five-layers-build-order]]

## Failure modes
- **Taking the licence on a real object.** The commonest version: a generic whoosh on a door, a UI click on a physical button. The viewer cannot name the error but registers it as the video feeling off.
- **Assuming "real object" means "recording of that object".** It does not, and insisting on it wastes hours. Match material, size and force; substitute freely.
- **A material match with the wrong size.** A correct-material file at the wrong scale (a small metal click for a big metal gate) is as wrong as the wrong material. Pitch it down 3–5 semitones or find the larger sibling.
- **Treating "any sound works" as "no thought needed".** The freedom is only on identity; duration, peak position, attack and pitch direction are all still constrained by the motion. Getting those wrong is the reason an invented-object sound feels "slightly off" while seeming correctly chosen.
- **No vocabulary.** The same abstract element sounding different on each appearance destroys the sense that the video has a designed sound world. Log element → family and honour it.
- **Substituting in a sober register.** Hyper-real substitution reads as heightened; in documentary or corporate registers it reads as fake. Match the substitution's boldness to the piece.
- **Known gap:** nothing in the stack checks material/size/force plausibility or vocabulary consistency. Both are manual review steps; put "plausibility check" and "vocabulary check" in the build manifest as named tasks.
