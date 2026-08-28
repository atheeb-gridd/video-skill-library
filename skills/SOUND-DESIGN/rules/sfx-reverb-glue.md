---
id: sfx-reverb-glue
title: Reverb is what puts a library effect inside the room
skill: sound-design
type: mix
family: sfx-treatment
tags: [skill/sound-design, type/mix, family/sfx-treatment, engine/hyperframes, engine/epidemic, engine/ffmpeg, sfx/diegetic, layer/sfx, layer/ambience, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:08:28"
    quote: "There's a really easy way to mix them in: add reverb. Because without reverb, sound effects feel like they were recorded in a studio, it doesn't feel like they exist in a real environment."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:08:23"
    quote: "If your sound effects still feel separate from the video, if they're sticking out, if they feel really odd..."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:10:04"
    quote: "Then use the techniques I told you about: reverb, changing the pitch, or changing the duration — change all of these and you can make a unique number of variations out of one single sound effect."
research_refs:
  - https://en.wikipedia.org/wiki/Convolution_reverb
  - https://en.wikipedia.org/wiki/Reverberation
  - https://en.wikipedia.org/wiki/Precedence_effect
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://en.wikipedia.org/wiki/Auditory_masking
difficulty: medium
detectable_from: audio
---

# Reverb is what puts a library effect inside the room

## What it is
Library effects are recorded close and dry, on purpose, so they can be used anywhere. That means they carry **no information about a space** — and the picture always shows one. The mismatch is what people describe as effects "sticking out", "feeling odd" or sounding studio-recorded: the sound is in front of the image rather than inside it. A small amount of reverb supplies the missing information — early reflections and a decaying tail consistent with the room on screen — and the effect stops being an overlay and becomes an event in the scene.

Film sound solves this properly with convolution: engineers "record impulse responses of sets and locations so sounds can be added in post-production with realistic reverberation". This stack has an algorithmic reverb rather than an impulse loader, so the job here is to **match by parameter** instead: pick a size and damping that agree with the room the shot shows, keep the wet amount low enough to be glue rather than effect, and verify against a location ambience clip playing in the same mix.

The other half of the note is that reverb is one of the three cheap variation controls (with pitch and duration) that turn one file into a set — so the same reverb send that glues effects into the room also stops them sounding like the same file used twice.

**Style.** Filed `sfx/diegetic`: glue is realism work — it puts a dry library file inside the room the picture shows. Reverb used to make a moment feel *bigger* than its room is the aesthetic use of the same processor and is kept in a separate note, [[sfx-reverb-size-and-tail]].

## When to use it
- **On the whole SFX bus, by default, for any interior shot.** One room for every effect is what makes them belong to the same place; per-clip reverb is for genuinely per-clip problems.
- **On diegetic effects always.** They are the ones being judged against a real space.
- **On motion and aesthetic effects lightly** — 5–8 % wet. They are not pretending to be in the room, but a completely dry designed effect over a reverberant shot still reads as pasted on.
- **As a repair move** when an effect has been correctly chosen, correctly timed and still feels wrong. Check reverb before you go looking for another file.
- **Not on exteriors.** Open air has almost no reflection; the correct treatment there is ambience, not reverb (2–5 % at most, mostly to take the edge off).
- **Not on the music bed.** It arrives with its own space already.

## How to recognise it in a reference video
- **Compare an effect's decay against the room's decay.** Find a natural transient in the location audio (a hand clap, a door, a hard consonant) and measure how long it takes to fall ~60 dB; then measure the same on a library effect in the same scene. Matched work has the two within a factor of about 1.5. A dry effect in a reverberant room is the tell.
- **Listen for the tail on the SFX bus specifically.** Solo-ing is impossible on a finished video, but in a gap between words a designed effect's tail is audible. No tail at all, on an interior, means no glue pass.
- **Check consistency across effects.** All effects sharing one tail character = a bus reverb (the good pattern). Different tails on different effects in one scene = per-clip reverb applied unevenly, which reads as several sounds from several places.
- **Look for the pre-delay cue.** A tail that starts *immediately* on the transient reads as a very small or very close space; one that starts 20–40 ms later reads as a larger room. On a wide shot of a big space, an immediate tail is a mismatch.
- **Check the low end.** Competent glue is high-passed before the reverb — a full-range send muddies the 100–300 Hz region and eats the voice's weight. Muddy interiors with clear effects usually mean no high-pass.
- **Exterior check.** Effects with an audible room in an outdoor shot is the inverse error and is just as detectable.

## Parameters

Physical anchors, so the numbers are derivable rather than taste: sound travels ~343 m/s, so the first reflection from a surface `d` metres away arrives about `2d / 343` seconds after the direct sound — 17 ms for a 3 m wall, 35 ms for a 6 m wall. The precedence effect fuses a delayed copy with the direct sound up to roughly **50 ms** (clicks) and further for music, which is why pre-delays in that range read as room size rather than as an echo. RT60 from the Sabine relation is proportional to volume and inversely proportional to absorption, giving the decay bands below.

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Where it lives | one `reverb` node on the `sfx` **bus** | bus (preferred) or clip | *"A compressor cannot ride a sequence it only hears a third of"* — same logic: one room, one node. |
| `wet` (glue) | 0.10 | 0.05–0.18 | Registry default is **0.35**, which is an effect, not glue. Always lower it. |
| `dry` | 1.0 | 0.9–1.0 | Keep the direct sound intact; glue is additive. |
| `size` — small treated room / booth | 0.20 | 0.15–0.28 | ≈ RT60 0.25–0.4 s. |
| `size` — ordinary room, office, bedroom | 0.30 | 0.25–0.40 | ≈ RT60 0.4–0.7 s. The default for talking-head interiors. |
| `size` — large room, studio, hall | 0.55 | 0.45–0.70 | ≈ RT60 1.0–2.0 s. |
| `size` — cathedral, warehouse | 0.85 | 0.75–1.0 | ≈ RT60 2–4 s. Rarely correct for creator content. |
| `damping` | 0.6 | 0.4–0.8 | Higher = darker tail = soft furnishings, carpet, curtains. Lower = brighter = tile, glass, concrete. |
| High-pass before the reverb | 250 Hz | 180–350 Hz | Stops low-end mush. Use a separate `highpass` node **before** the reverb in the chain. |
| Pre-delay | not available (see below) | — | Approximate with a `delay` node at `time` 15–35 ms, `mix` 0.15–0.25, `feedback` 0.02, placed before the reverb. Flag it as an approximation. |
| Exterior treatment | `wet` 0.03 + ambience | 0.0–0.05 | Reverb is the wrong tool outdoors. |
| Variation use | ±0.05 `wet`, ±2 st pitch, ±15 % duration | — | Three knobs, one file, several usable variants. |
| Level compensation | −1 dB on the bus after adding reverb | 0 to −2 dB | Wet signal adds energy; re-check against dialogue. |

## Reproduction prompt

```
Glue the sound-effects layer into the scene's space.

1. READ THE ROOM FROM THE PICTURE. Classify the dominant location:
     booth / small treated room     -> size 0.20, damping 0.65
     ordinary room, office, bedroom -> size 0.30, damping 0.60
     large room, studio, hall       -> size 0.55, damping 0.45
     cathedral, warehouse           -> size 0.85, damping 0.35
     exterior                       -> DO NOT add reverb; add ambience instead
   Hard surfaces (tile, glass, concrete) -> lower damping by 0.15.
   Soft surfaces (carpet, curtains, sofa) -> raise damping by 0.15.

2. PUT IT ON THE BUS, NOT ON EACH CLIP. On <hf-audio-group id="sfx">, author a
   data-fx-chain in signal order:
     highpass  frequency 250          (label "Clear Mud")
     reverb    size <from step 1>, damping <from step 1>, wet 0.10, dry 1
   Attributes must be double-quoted with &quot; entities, or carve.mjs cannot
   see them.

3. SET THE WET BY EAR AGAINST A KNOWN REFERENCE, not in isolation. Put a
   location ambience clip for the same room in the mix at -26 dB, then raise
   wet from 0.05 in 0.02 steps until the effects stop sounding in front of the
   picture. Stop the moment you can HEAR the reverb as an effect - that is one
   step too far. Typical landing point: 0.08-0.12.

4. EXEMPT WHAT SHOULD BE DRY. Move any effect that must stay in the viewer's
   face - a hard hit, a record scratch, a caption tick - to its own group
   ("sfx-dry") with no reverb node. Do not fight the bus with per-clip settings.

5. DO NOT AUTOMATE size OR damping. They regenerate the impulse and are not
   automatable. If the room must change at a scene cut, use TWO groups (one per
   room) and place each scene's effects in the right one.

6. RE-CHECK LEVELS. Reverb adds energy: drop the sfx bus data-volume by about
   1 dB (multiply by 0.89) and confirm dialogue still sits 12-15 dB above the
   effects.

7. EXPECT A LONGER RENDER TAIL. A track with reverb no longer ends exactly at
   its data-duration; the mix is told how much via chainTailSeconds. That is
   expected, not a bug - but leave 0.5-1.0 s of composition after the last
   effect so the tail is not cut off.

ACCEPTANCE TEST: A/B the sfx bus with the reverb node enabled and bypassed
(enabled:false). Bypassed, the effects sit on top of the picture. Enabled, they
sit inside it - and you cannot name the reverb as an effect. Play the interior
and any exterior shots back to back: the exterior effects have no audible tail.
Nothing in the 100-300 Hz region has got muddier.
```

## Execution spec

**Hyperframes.** The `reverb` node convolves a **generated** impulse — *"preview and render generate the same one, so a room is reproducible without shipping an impulse file."* Parameters: `size` 0.05–1 (default 0.7), `damping` 0–1 (0.5), `wet` 0–1 (0.35, **AUTO**), `dry` 0–1 (0.7, **AUTO**). Bus form:

```html
<hf-audio-group id="sfx" data-label="Sound effects" data-volume="0.89"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;g1&quot;,&quot;label&quot;:&quot;Clear Mud&quot;,&quot;params&quot;:{&quot;frequency&quot;:250,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
    {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;g2&quot;,&quot;label&quot;:&quot;Room Glue&quot;,&quot;params&quot;:{&quot;size&quot;:0.3,&quot;damping&quot;:0.6,&quot;wet&quot;:0.1,&quot;dry&quot;:1}}]}"></hf-audio-group>
```

Every effect then just needs `data-audio-group="sfx"`. Chain order doctrine applies: *"Subtract before you add, level after you filter … character and ceiling last"* — the high-pass precedes the reverb, and any limiter goes last. `enabled: false` bypasses a node without removing it, which is how you A/B in step 7. There is also a **`room-tight` / `room-natural` / `hall` preset family** in the Space group; a preset writes ordinary nodes tagged `fromPreset` and can be faded as a unit via `presetAmount`, automatable at `fx.preset.<id>` — that is the only way to automate a preset as one thing, and it is the right route if the room needs to change over time.

Three constraints to respect:
- **`size` and `damping` are not automatable** (they regenerate the impulse); only `wet` and `dry` are. Automate a `gain` stage or the preset amount instead.
- **Effects with a tail make the rendered track longer than its `data-duration`** — `chainTailSeconds` handles it, and a bed with reverb ending past its nominal out is expected behaviour.
- Nothing validates the chain. Render **refuses** an unparseable chain, but preview plays it **dry** — so a chain that silently does nothing in preview is a real failure mode. Check the JSON escaping.

**Known gap — pre-delay and true IR matching.** The registry's `reverb` exposes no pre-delay, and there is **no impulse-response loader**, so the film-post approach of capturing an IR on location and convolving effects through it cannot be executed in this stack. Two honest workarounds: (1) place a `delay` node before the reverb with `time` 15–35 ms, `mix` 0.15–0.25, `feedback` 0.02 — a single slap the reverb then smears, which approximates the initial time delay gap; (2) accept the immediate tail and use `size`/`damping` alone, which is adequate for the small-to-ordinary rooms most creator content shows. State whichever you used in the design document.

**Epidemic Sound.** Reverb is not fetched, but the **verification reference is**: pull a room-tone bed for the same location and mix it in while setting `wet`. Verified shelf (2026-08-27): `tagSlugs ALL ["ambience--room-tone"]` returns uniformly 120 000 ms beds — *Ambience, Room Tone, Office 01 / 03*, *Office Room Tone, AC*, *Office Hallway 01*, *Office Kitchen Room Tone 01*. Query `room tone <place> ambience`. That bed is both the reference for judging the reverb and the layer that does the outdoor equivalent of this job.

**ffmpeg.** For a baked version (only for assets leaving the pipeline), `aecho` is the crude route and `afir` the correct one if you have an impulse file: `ffmpeg -i sfx.wav -i room-ir.wav -filter_complex "[0][1]afir=dry=10:wet=1" sfx.wet.wav`. Measuring a room's decay from location audio: `ffmpeg -ss <transient> -t 1.5 -i loc.wav -af "astats=metadata=1:reset=0.02" -f null -` and read how many 20 ms windows the RMS takes to fall 60 dB.

**Remotion.** No built-in reverb; port this by pre-rendering wet versions of the effects with `afir`/`aecho` and referencing those files.

## Pairs with
[[sfx-diegetic-action-inventory]] · [[sfx-real-vs-invented-sound-rule]] · [[sfx-motion-sound-selection]] · [[sfx-ambience-search-formula]] · [[sfx-layer-volume-targets]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-appearance-transient]] · [[sfx-whip-crack-on-snap-cut]] · [[sfx-five-layers-build-order]] · [[sfx-sound-pass-order]] · [[sfx-essential-sound-space-presets]]

## Failure modes
- **Leaving the registry default `wet: 0.35`.** That is reverb as an effect; the scene sounds like it is in a bathroom. Glue lives at 0.05–0.18.
- **Per-clip reverb applied unevenly.** Every effect in its own space is worse than every effect dry, because now the scene contains several contradictory rooms. Put it on the bus.
- **Reverb without a high-pass.** The 100–300 Hz build-up eats the voice's weight and the mix gets muddier as more effects are added. High-pass at 250 Hz before the reverb.
- **Reverb on an exterior.** Instantly reads as a mistake. Outdoors wants ambience and near-zero wet.
- **Trying to automate `size` or `damping`.** Silently inert — *"a lane on a non-automatable parameter is silently inert"*. Use two groups, or the preset amount.
- **Forgetting the tail is longer than the clip.** The last effect of a composition gets cut off if the root duration ends on it. Leave 0.5–1.0 s.
- **Single-quoted JSON attributes.** They parse in the browser but are invisible to `carve.mjs`, which then silently overwrites work it could not see. Use `&quot;`.
- **Reaching for reverb when the real problem is level or timing.** Reverb fixes "sounds studio-recorded"; it does not fix "arrives late" or "too loud". Diagnose in the order timing → level → space.
- **Known gap:** no impulse-response loading and no pre-delay parameter, so location-matched convolution is out of reach in this stack. The `delay`-before-`reverb` trick is an approximation, and should be labelled as one wherever it is used.
