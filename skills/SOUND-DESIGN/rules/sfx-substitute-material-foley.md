---
id: sfx-substitute-material-foley
title: Substitute-material foley — build the sound you cannot record from two you can
skill: sound-design
type: sfx
family: foley
tags: [skill/sound-design, type/sfx, family/foley, engine/epidemic, engine/ffmpeg, engine/hyperframes, sfx/diegetic, layer/sfx, source/sfx-kt-1, source/research, difficulty/high]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:09:06
    quote: "And let me give you another Foley example: if you need the sound of a bone breaking, you can take the sound of wood breaking"
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:09:11
    quote: "and mix it with a water splash. Or you can take the sound of a cucumber snapping -"
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:09:17
    quote: "[older pass only] The sounds that can't really be recorded in real life, you can fake them this way. Or if you can't find a sound effect anywhere, you can recreate it like this."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:07:17
    quote: "Put it one way, they're fake sound effects that sound completely real, but they're actually recorded sitting inside a studio."
research_refs:
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (wood--break and gore--bone probed live, 2026-08-28)
difficulty: high
detectable_from: audio
---

# Substitute-material foley — build the sound you cannot record from two you can

## What it is
The classical Foley "specifics" trick, stated plainly by the source: a bone break is **wood breaking plus a water splash**; a cucumber snapping works too. The principle underneath is that a sound the ear accepts as one event is usually two components — a **transient** that carries the material and the violence, and a **body/texture** that carries the wetness, mass or resonance. Neither component has to come from the real object. Feature-film Foley has done this for a century: corn starch in a leather pouch for footsteps in snow, coconut shells for horse hooves.

This is the counterpart to [[sfx-mouth-foley-record-and-process]]. The mouth is good at air; it is useless at material. When the sound you need is a *material event* that cannot be recorded — because the thing does not exist, cannot be broken, or is not in the room — you build it out of two library files whose transients you align on the same frame.

Two things make it work and both are measurable: the two components must be **transient-aligned to within about 1 frame**, and they must occupy **different frequency bands** so the composite reads as one richer event rather than two overlapping sounds.

## When to use it
- **The event cannot be recorded.** Bone, flesh, fantasy creatures, sci-fi mechanisms, a building collapsing, an object that would be destroyed by recording it.
- **The library genuinely has no match.** Check first — see the Execution spec's live finding, which is that a subscription catalogue often *does* have the "impossible" sound.
- **The library match is right in character but thin.** Adding a second component is the cheapest way to give an existing file weight or wetness without pitching it.
- **You want an identity.** A composite is a sound nobody else has, which makes it a good candidate for a recurring signature effect in a profile.
- **Not for common diegetic actions.** A door, a keyboard, footsteps, cloth — these exist in every library in twenty variants, and building them from parts is wasted time ([[sfx-diegetic-action-inventory]]).
- **Not for motion or aesthetic effects.** A whoosh does not need a substitute material; it needs the right length ([[sfx-whoosh-transition-movement-reveal]]).
- **Not with three or more components** on a first attempt. Two lands; four turns to mush.

## How to recognise it in a reference video
- **Look for two transients within one or two frames on a single "event".** Isolate the moment and print per-frame peaks:
  ```bash
  ffmpeg -ss <t> -t 0.6 -i ref.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
   ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
  ```
  A composite shows a single peak frame but a **two-part decay**: a fast crack decaying in 3–6 frames plus a slower wet or resonant component running 10–30 frames. A single-file effect decays once, monotonically.
- **Band-split the event and listen to each half.** High-passed at 2 kHz you hear the crack; low-passed at 500 Hz you hear the body. If those two halves sound like *different materials*, it is a composite.
- **Compare against the picture's material.** A screen event whose sound has more high-frequency crack than the object could produce (a soft object cracking, a small object booming) is built, not recorded. That mismatch is the technique, not an error.
- **Recurrence with variation.** Composites are expensive to build, so a creator who has one uses it repeatedly with pitch and length variation. The same two-part decay shape appearing at three different pitches across a video is the signature.
- **Log the components, not the sound.** For the design document, the useful finding is "impact = sharp wood crack + wet body, ratio about 1:1 with a 4-frame body offset", because that is reproducible. "Bone break sound" is not.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `components` | 2 | 2–3 | Transient + body. A third component is only for a genuinely long event (a collapse), never for a snap. |
| `transient_align` | 0f | −1f to +1f | The two components' peaks on the same frame at 30 fps. This is the hard requirement — beyond ±1 f the ear separates them. |
| `body_offset` | +2f (0.066 s) | 0 to +5f | Deliberately delaying the wet/resonant component by a frame or two reads as the *consequence* of the crack. Beyond 5 f it is a second event. |
| `band_split_crossover` | 1.2 kHz | 700 Hz–2 kHz | High-pass the transient, low-pass the body. The rule that keeps a composite from being mud. |
| `transient_level` | 0.211 (≈−13.5 dB) | −15 to −11 dB | The component carrying the material identity gets the level. |
| `body_level` | 0.150 (≈−16.5 dB) | −19 to −14 dB | Always *below* the transient. A body louder than its crack sounds like a splash with a click on it. |
| `body_tail` | 15f (0.5 s) | 6–45f | Frames from the peak to −20 dB. This is what makes it feel wet or heavy. |
| `transient_tail` | 5f (0.17 s) | 2–9f | Short by definition. |
| `composite_pitch` | 1.0 | 0.7–1.15 | Pitch the *whole composite* after bouncing, not the components separately — separate shifts break the alignment. |
| `variants` | 4 | 3–6 | Built by pitching and re-timing the bounced composite. |
| `bounce` | yes | yes/no | Bounce the composite to one file before placing. Two live clips that must stay 2 frames apart is a maintenance liability across re-edits. |

## Reproduction prompt

```
Build the sound for the on-screen event at {{EVENT}} (seconds) that cannot be
recorded: {{EVENT_DESCRIPTION}}.

1. SEARCH THE CATALOGUE FIRST, honestly. Query the literal thing
   ("bone break snap", "bone crack"). Subscription libraries carry many
   "impossible" sounds outright, and a single well-recorded file beats a
   composite every time. Only continue if nothing usable comes back.
2. DECOMPOSE THE EVENT INTO TWO COMPONENTS, in words, before searching:
   - TRANSIENT: what does the violence sound like? (a crack, a snap, a
     splinter, a tear) -> gives the material and the attack.
   - BODY: what does the substance sound like? (wet, hollow, dense, metallic)
     -> gives the mass and the aftermath.
   Worked example from the source: bone = wood snapping (transient) + water
   splash (body). Or a single cucumber snap, which carries both.
3. FETCH EACH COMPONENT SEPARATELY. Transient: duration 200-1500 ms, short
   and dry. Body: duration 500-3000 ms, with a tail. Three candidates each.
4. MEASURE EACH FILE'S PEAK OFFSET from its head (peak_t). You need both.
5. ALIGN. Place the transient so its peak lands on {{EVENT}}:
   start_transient = {{EVENT}} - peak_t_transient
   Place the body 2 frames later (0.066 s):
   start_body = {{EVENT}} + 0.066 - peak_t_body
6. BAND-SPLIT so they do not fight: high-pass the transient at 1.2 kHz,
   low-pass the body at 1.2 kHz. Use gentle 6 dB/oct slopes (poles 1) if the
   split sounds surgical.
7. SET LEVELS: transient 0.211, body 0.150. The body must sit BELOW the
   transient. If the composite sounds like two sounds, the body is too loud
   or the alignment is off by more than a frame - fix alignment first.
8. AUDITION AGAINST PICTURE, then BOUNCE to a single WAV, peak-normalise to
   -6 dBTP, name it diegetic_<event>_composite_01.wav and ingest it into the
   library with both source ids recorded.
9. GENERATE VARIANTS from the bounced file by pitch (x0.85, x1.1) and length
   (+/-15%), never by re-mixing the components.

ACCEPTANCE TEST: play the shot at full speed once. You must hear ONE event.
If you hear two, reduce the body_offset to 0 frames and drop the body 3 dB.
Then play it three times in a row: the composite must still read as the
material on screen and not as "wood and water", which means the crossover is
doing its job.
```

## Execution spec

**Epidemic Sound — and a finding that changes the advice.** Probed live 2026-08-28: the catalogue carries both components *and* the target sound. `"wood break snap crack"` returns `Wood, Break, Wooden Panel, Snap 01` (1183 ms), `Wood, Break, Stick, Branch, Snap In Two` (3250 ms), `Wood, Break, Panel, Plywood, Bend, Splinter, Snap` (2281 ms) — all tagged `wood--break`. But the same query *also* returns `Gore, Bone, Break, Snap 03` tagged **`gore--bone`**. In other words the transcript's flagship example — "you can't record a bone breaking, so build it" — is a technique from an era of thinner libraries. On a subscription catalogue, **search the impossible sound first; it is often simply there.**

```
# 1. the honest first check - is the target sound already in the catalogue?
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["gore--bone"]} }, first:24 }
# 2. the transient component
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["wood--break"]},
                              duration:{min:200,max:1500} },
                     sort:{by:POPULARITY,order:DESCENDING}, first:24 }
# 3. the body component
SearchSoundEffects { query:{term:"water splash short"},  filter:{duration:{min:400,max:2500}}, first:24 }
# other verified component sources worth knowing
#   fight--impact  (punch, face - flesh transients)
#   cloth--movement (fabric texture as a body layer under a movement)
#   footsteps--human (titles carry Close / Distant variants - perspective for free)
SearchSimilarToSoundEffect { id:<uuid>, first:12 }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Read `audioFile.durationInMilliseconds` to pick a transient short enough not to have a tail of its own, and `audioFile.waveformUrl` to see roughly where each peak sits before downloading. **WAV only** — you are aligning two transients to a single frame, which is exactly what mp3 pre-echo destroys. Note the descriptor vocabulary the catalogue actually uses in titles: `Break`, `Snap`, `Splinter`, `Bend`, `Crunchy`, `Impact`, `Various`, plus mic notes like `MKH8060 (Shotgun)` — a shotgun-mic recording is drier and better as a transient; a room recording is better as a body.

**HyperFrames — align, split, then bounce.** Two clips, band-split, on separate track indices so no `duplicate_audio_track` warning fires. Event at 96.40 s; transient peaks 0.09 s into its file, body peaks 0.14 s in:
```html
<audio id="sfx-bone-crack" src="assets/sfx/diegetic/object/wood_panel_snap_01.wav"
       data-audio-group="sfx"
       data-start="96.31"            <!-- 96.40 - 0.09 : peak on the event frame -->
       data-duration="0.34" data-track-index="20" data-volume="0.211"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Crack only&quot;,&quot;params&quot;:{&quot;frequency&quot;:1200,&quot;poles&quot;:&quot;1&quot;}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>

<audio id="sfx-bone-body" src="assets/sfx/diegetic/object/water_splash_short_02.wav"
       data-audio-group="sfx"
       data-start="96.326"           <!-- 96.40 + 0.066 - 0.14 : body 2 frames late -->
       data-duration="0.62" data-track-index="21" data-volume="0.150"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Wet body only&quot;,&quot;params&quot;:{&quot;frequency&quot;:1200,&quot;poles&quot;:&quot;1&quot;}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>
```
Contract points: all time in **seconds** (frames are comments); every `<audio>` needs an `id` or it is never mixed and the render is silently missing it; `highpass`/`lowpass` accept `poles` `1` (6 dB/oct) or `2` (12 dB/oct) and `1` is usually the better crossover here; order is signal order with **limiter last**; keep both in `data-audio-group="sfx"`, never in `voiceover`.

**Bounce the composite with ffmpeg once it is right.** Two live clips that must stay 2 frames apart survive exactly until the next re-edit slips one of them.
```bash
# align, band-split and sum in one graph. adelay is in milliseconds per channel.
ffmpeg -i wood_panel_snap_01.wav -i water_splash_short_02.wav -filter_complex "\
 [0:a]highpass=f=1200:poles=1,volume=-13.5dB[t];\
 [1:a]lowpass=f=1200:poles=1,adelay=66|66,volume=-16.5dB[b];\
 [t][b]amix=inputs=2:duration=longest:dropout_transition=0,\
 alimiter=limit=0.891,afade=t=out:st=0.60:d=0.06" \
 -ar 48000 -c:a pcm_s24le diegetic_bone-break_composite_01.wav

# then pitch-variant the BOUNCE, not the components (x0.85 = about -2.8 st)
ffmpeg -i diegetic_bone-break_composite_01.wav \
  -af "asetrate=48000*0.85,aresample=48000,atempo=1.1765" diegetic_bone-break_composite_02.wav

node <SKILL_DIR>/scripts/resolve.mjs --from diegetic_bone-break_composite_01.wav --type sfx --project .
```
`adelay=66|66` is the 2-frame body offset expressed in milliseconds, per channel. `amix` halves the level of each input by default in some builds — check the output peak and compensate with the `volume` stages rather than assuming. Keep the intermediates **outside the mounted vault**, which cannot delete files.

**Remotion:** two `<Audio>` elements in one `<Sequence>` with frame offsets, or the bounced file. Concept only.

## Pairs with
[[sfx-mouth-foley-record-and-process]] · [[sfx-foley-replacement-pass]] · [[sfx-diegetic-action-inventory]] · [[sfx-real-vs-invented-sound-rule]] · [[sfx-layered-approach-and-impact]] · [[sfx-bass-drop-under-impact]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-peak-at-motion-midpoint]] · [[sfx-library-build-and-taxonomy]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-filter-character-and-distance]] · [[sfx-source-licensing-and-clearance]] · [[motion-camera-shake-impact]] · [[sfx-foley-family]]

## Failure modes
- **Building a sound the catalogue already has.** The transcript's own example is now solvable with one query (`gore--bone`). Fix: search the target literally before decomposing it. Thirty seconds saves twenty minutes.
- **Misalignment beyond ±1 frame.** The ear separates the components and hears two sounds, which is worse than either alone. Fix: measure both `peak_t` values; never align by file start.
- **No band split.** Two full-range sounds summed is mud with a click on it. Fix: crossover at 1.2 kHz, high-pass one and low-pass the other.
- **Body louder than the transient.** Reads as a splash with a tick, not as a break. Fix: body at least 3 dB below.
- **Body offset over 5 frames.** Becomes a second event, and on a fast cut the viewer hears the aftermath over the next shot. Fix: 0–2 frames.
- **Pitching the components separately.** Breaks the alignment, because a pitch shift that preserves length still shifts the internal peak position. Fix: bounce first, pitch second.
- **Leaving the composite as two live clips.** The next re-edit slips one and nobody notices until the render. Fix: bounce, ingest, place one file.
- **Three or more components on a snap.** Mush. Fix: two, and only add a third for a long event.
- **Using it for a common object.** Doors and keyboards exist in every library. Fix: composites are for the impossible only.
- **Known gap:** no measurement exists for the exact alignment tolerance at which two transients fuse into one perceived event. The ±1 frame (±33 ms) figure here is derived from the same audio/video binding thresholds used elsewhere in this library (detectability from roughly 45 ms lead to 125 ms lag) applied by analogy to two audio events. Treat it as a working tolerance and the single-event acceptance test as the authority.
