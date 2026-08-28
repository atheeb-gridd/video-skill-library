---
id: sfx-intimate-proximity-sounds
title: Intimate sounds — collapsing the distance between viewer and subject
skill: sound-design
type: sfx
family: intimacy
tags: [skill/sound-design, type/sfx, family/intimacy, sfx/aesthetic, layer/sfx, layer/design, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:34
    quote: "Whether you want to make the audience feel anxiety, tension or intimacy — to elevate this type of emotion we generally use very intimate sounds. Meaning those sounds that are only audible when you come very near or close."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:54
    quote: "A fast heartbeat creates tension. Slow breathing gives a moment a personal feel. Fast breathing reads as the character being terrified."
research_refs:
  - https://en.wikipedia.org/wiki/Proximity_effect_(audio)
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Precedence_effect
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (human--heartbeat, human--breath, clocks--tick probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Intimate sounds — collapsing the distance between viewer and subject

## What it is
A category defined by **proximity**, not by object: sounds you could only hear if you were physically inside someone's personal space — a heartbeat, a breath, a swallow, a clock two feet away. Using one places the viewer at that distance whether the picture agrees or not, and the collapsed distance is what produces anxiety, tension or intimacy. The object matters less than the closeness; a heartbeat mixed as if it were across the room is just a drum.

Which of the three emotions you get is decided by **rate**, and the source video is precise about it: a fast heartbeat creates tension, slow breathing reads as personal, fast breathing reads as terror. Same file family, three different meanings, selected by beats or breaths per minute.

The engineering half is what makes it work. Perceived distance in a mix is carried by four cues, and an intimate sound has to win all four: it must be **dry** (near-zero reverberant content — this is the dominant cue), **bright** (no high-frequency roll-off, because air absorption is what makes distant sounds dull), **bass-lifted** (the microphone proximity effect that the ear reads as "close"), and **centred and narrow** (a wide stereo image reads as a space around you; a mono centre image reads as inside your head). Miss any one and the sound is merely loud.

**Style.** Filed `sfx/aesthetic`: the sound is placed to collapse distance and produce a feeling, whether or not the picture agrees a microphone was ever that close. A breath or a swallow that genuinely belongs to a visible body on screen is diegetic Foley instead ([[sfx-foley-three-element-checklist]]).

## When to use it
- **Under a held close-up** where nothing is happening visually and the tension has to come from somewhere. This is the highest-value use: it converts a static shot into a pressure shot at zero editorial cost.
- **In the last 2–5 seconds before a reveal or a decision**, layered under or instead of a riser. A heartbeat accelerating is a build that does not announce itself the way a riser does ([[sfx-riser-anticipation-build]]).
- **On a personal or confessional beat** — the presenter admitting something, a story turning inward. Slow breath, one or two cycles, very quiet. This is the "intimacy" mode and it is almost always overdone.
- **Under a silence you deliberately made** by stopping the music ([[sfx-music-hard-stop]], [[sfx-music-rest-windows]]). An intimate sound needs an empty frequency field; it is the least competitive sound in the library.
- **On a cross-cut** where one strand should feel closer than the other ([[sfx-cross-cut-audio-strategy]]).
- **Not with a music bed running at full level.** A heartbeat under a busy bed is inaudible or, worse, audible only as a low thud that muddies the bass.
- **Not for more than about 12 seconds continuously.** Proximity is a state change; held too long the viewer habituates and it becomes a bed.
- **Not on a wide shot** unless you are deliberately contradicting the picture for a subjective effect — and if you are, say so in the design document, because it will read as an error otherwise.
- **Not more than twice per video.** The device works by contrast with everything around it.

## How to recognise it in a reference video
- **A low, periodic, non-musical pulse under a quiet passage.** Detect it by rate, not by ear: band-limit to the heartbeat range and count onsets.
  ```bash
  # isolate the sub band and trace per-frame level (n=1600 @48kHz == 1 frame @30fps)
  ffmpeg -i ref.mp4 -ar 48000 -af "lowpass=f=200,asetnsamples=n=1600,\
   astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" \
   -f null - 2>/dev/null
  ```
  A heartbeat reads as **paired transients** (lub–dub, 0.10–0.16 s apart) repeating at a steady interval. Convert the interval to BPM and read the emotion off it.
- **Rate is the finding, not presence.** Log it as a number: 60–80 BPM = calm/intimate; 90–110 = unease; 110–140 = tension; accelerating across the shot = a build. Same for breath: 12–16 cycles/min = personal; 20–28 = anxious; 28–40 = terror.
- **Dryness test.** An intimate sound has **no audible tail** — the level falls to the noise floor within 100–200 ms of each transient. If you can hear a room decaying after it, it was placed as an ambience, not as an intimacy, and that is a defect worth logging.
- **Spectral shape.** Close-mic'd breath keeps energy above 6 kHz (the "air" of the exhale) *and* below 150 Hz. A breath that has been low-passed reads as behind a wall.
- **Stereo width.** Sum-to-mono and compare: an intimate sound loses almost nothing, because it was already centred. A wide ambience partially cancels.
- **What else is playing.** In a compliant reference, the music is out or below −28 dB and there is no other SFX in the window. If a heartbeat is competing with a whoosh, the editor did not understand the category.
- **Duration**: 3–12 s. Longer than ~15 s and it has become a tension bed, which is a different note.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Heartbeat rate — intimacy | 68 BPM | 60–80 | Resting human rate. Reads as presence, not threat. |
| Heartbeat rate — unease | 100 BPM | 90–110 | |
| Heartbeat rate — tension | 125 BPM | 110–140 | Above ~150 it stops reading as a heart and starts reading as a drum machine. |
| Heartbeat acceleration | +20 BPM over 4 s | +10…+40 | The build variant. Achieved by chaining two files or by an `atempo` ramp baked in ffmpeg. |
| Breath rate — personal | 14 cycles/min | 12–16 | Slow, full, one or two cycles only. |
| Breath rate — anxious | 24 cycles/min | 20–28 | |
| Breath rate — terrified | 32 cycles/min | 28–40 | Short inhales, audible mouth noise. |
| Clock tick rate | 1.0 Hz | 0.9–1.2 Hz | Anything off 1 Hz reads as wrong; it is the one sound everyone knows the tempo of. |
| Level | −11 dB rel. dialogue (`data-volume` 0.282) | −14 … −8 dB | **Hotter than the standard SFX tier on purpose.** Proximity is partly a level cue; at −15 dB it is not close, it is distant and quiet. |
| Reverb `wet` | 0.0 | 0.0–0.05 | The dominant distance cue. Near-zero or the illusion collapses. Explicitly *do not* apply [[sfx-reverb-glue]] to this category. |
| Low-shelf (proximity lift) | 150 Hz, +4 dB | 120–200 Hz, +3…+6 dB | Emulates the microphone proximity effect. Above +6 dB it booms and fights the bed. |
| High-frequency handling | leave intact | no `lowpass` | Air absorption dulls distant sounds; a low-passed intimate sound reads as behind glass. |
| Highpass | 40 Hz | 30–60 Hz | Only to remove rumble; keep the body of the thump. |
| Stereo width | mono / centred | — | Choose a source described as "Close" or "Isolated"; a wide stereo take cannot be narrowed in this stack. |
| Duration | 6 s | 3–12 s | Past ~15 s it is a tension bed, not an intimacy. |
| Music under it | out, or −28 dB (`data-volume` 0.04) | −32 … −26 dB | Not a carve — a real reduction, or silence. |
| Uses per 10 minutes | 2 | 1–3 | |

## Reproduction prompt
```
Place an intimate sound under the beat at {{T_IN}}..{{T_OUT}} (composition seconds).

1. NAME THE EMOTION AND CONVERT IT TO A RATE. This is the whole selection decision.
     intimacy / personal -> breath at 12-16 cycles/min, OR heartbeat at 60-80 BPM
     unease              -> heartbeat at 90-110 BPM
     tension             -> heartbeat at 110-140 BPM, or a 1 Hz clock tick
     terror              -> breath at 28-40 cycles/min, short inhales
   Write the number down. If you cannot pick one, this beat does not want an
   intimate sound.

2. FETCH. Anchor on a verified tag slug; free-text search in this catalogue is
   unreliable (a probe for "clock ticking" returned camera shutters first).
     heartbeat: filter.tagSlugs ALL ["human--heartbeat"]
     breath:    filter.tagSlugs ALL ["human--breath"], duration min 3000
     clock:     filter.tagSlugs ALL ["clocks--tick"],  duration min 10000
   Rank with query.term and PREFER TITLES CONTAINING "Close" OR "Isolated" - those
   are the close-mic'd, dry takes and they are the only ones that work here.
   Download WAV.

3. CHECK THE RATE OF WHAT YOU GOT, do not trust the title. Trace per-frame RMS,
   count onsets, compute BPM. If it is within +/-10% of target, keep it. If not,
   retime it with ffmpeg atempo (range 0.5-2.0, pitch preserved, chainable) -
   target_rate / actual_rate is the tempo factor. Do NOT use asetrate for this:
   it shifts pitch and a pitch-shifted heartbeat stops sounding like a body.

4. PLACE. <audio id="sfx-intimate-{{N}}" data-audio-group="sfx"
   data-track-index="14" data-start="{{T_IN}}"
   data-duration="{{T_OUT}} - {{T_IN}}" data-volume="0.282">
   Volume lane, clip-local seconds, with fades that hide the loop seam:
     t=0 v=0, t=0.5 v=1, t=(dur-0.8) v=1, t=dur v=0.
   Land the fade-in and fade-out in the GAP BETWEEN two beats, never on a thump.

5. TREAT FOR PROXIMITY. data-fx-chain, in signal order:
     highpass  40 Hz
     lowshelf  150 Hz, gain +4      (the proximity lift)
     limiter   limit -1             (last; ceiling only)
   Add NO reverb node. Do not add a lowpass. If the composition has a global
   reverb-glue pass, exclude this clip from it explicitly.

6. CLEAR THE FIELD. In {{T_IN}}..{{T_OUT}}: stop the music bed, or dip its volume
   lane to 0.04 (-28 dB); and place no other sound effect. This sound cannot
   compete and must not be asked to.

7. ACCEPTANCE TEST. (a) Sum to mono and play on a phone speaker - it should still
   be there; if it vanishes, the source was too wide or too low. (b) Count the
   onsets in the placed window and confirm the rate matches the emotion you named
   in step 1. (c) There is no audible room decay after each transient. (d) Nothing
   else is playing above -28 dB. (e) The window is under 12 s.
```

## Execution spec

**Placement spec.**

| | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Intimate bed | starts **on** the first frame of the close shot (0 frames); 15-frame fade-in landing between two beats | **−11 dB** (`data-volume` 0.282), range −14…−8 | music **stopped or −28 dB** for the whole window; all other SFX suppressed |
| Accelerating variant | last beat lands on the payoff frame, 0 to −1 frames | ramps −14 → −8 dB across the build | music out from the start of the acceleration |

**Epidemic Sound.** Verified slugs and what the catalogue actually holds:

```json
// heartbeat — slug human--heartbeat (verified)
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["human--heartbeat"] } },
  "query":  { "term": "heartbeat close muffled" },
  "sort":   { "by": "POPULARITY", "order": "DESCENDING" }, "first": 8 }

// breath — slug human--breath (verified; note it is "breath", NOT "breathing")
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["human--breath"] },
              "duration": { "min": 3000 } },
  "query":  { "term": "close isolated heavy breathing long inhale exhale" },
  "sort":   { "by": "RELEVANCE", "order": "DESCENDING" }, "first": 8 }

// clock — slug clocks--tick (verified; NOT household--clock, which returns 0)
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["clocks--tick"] },
              "duration": { "min": 10000 } },
  "query":  { "term": "tick tock loop slow" },
  "sort":   { "by": "POPULARITY", "order": "DESCENDING" }, "first": 8 }
```

Confirmed live: `human--heartbeat` returns *Human, Heartbeat* (9.8 s) and *Human, Heartbeat, Eerie Heartbeat, Muffled* (180 s — a full three-minute bed, ideal for a long window); `human--breath` returns *Human, Breath, Breathing Mask, **Close, Isolated**, Heavy Breathing, Long Inhale & Exhale* (19.9 s and 111 s) and *Human, Breath, Male, Sports Breathing, Runner, Mouth Breathing, Heavy, **Close Perspective*** (21.6 s); `clocks--tick` returns *Clocks, Tick, Tick Tock, **Loop*** (15.8 s) and *Clocks, Tick, Designed, Ticking Clock, Slow, Loop* (14.5 s). Two guesses that **fail closed at zero** and must not be used: `human--breathing` and `household--clock`. The words **"Close"**, **"Isolated"**, **"Close Perspective"** and **"Muffled"** in a title are the catalogue's own proximity descriptors — they are the single most reliable selection signal for this category. Prefer titles containing **"Loop"** for anything you need to run longer than the file. `DownloadSoundEffect` with `{"fileType":"WAV"}`; use `SearchSimilarToSoundEffect` for a second variant so a repeated use is not the same file ([[sfx-repetition-variant-rotation]]).

**HyperFrames.**

```html
<audio id="sfx-heartbeat-01" src="assets/audio/sfx/heartbeat-close.wav"
       data-audio-group="sfx" data-track-index="14"
       data-start="64.0" data-duration="6.0" data-media-start="0.0"
       data-volume="0.282"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.5,&quot;v&quot;:1},{&quot;t&quot;:5.2,&quot;v&quot;:1},{&quot;t&quot;:6,&quot;v&quot;:0}]}]}"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Rumble Cut&quot;,&quot;params&quot;:{&quot;frequency&quot;:40}},{&quot;type&quot;:&quot;lowshelf&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Proximity Lift&quot;,&quot;params&quot;:{&quot;frequency&quot;:150,&quot;gain&quot;:4}},{&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>
```

Chain order is signal order and follows the house doctrine — *subtract before you add, level after you filter, character and ceiling last*. `lowshelf` takes `frequency` 20–2000 Hz and `gain` −40…+40 dB and has **no `q`**. `limiter` has **zero automatable parameters** (it is an AudioWorklet configured wholesale), so if you need the level to move, automate a `gain` stage around it instead. Out-of-range `params` are clamped on read, so anything that parses is safe. Write JSON attributes double-quoted with `&quot;`. Every `<audio>` needs an `id` or it is never mixed and renders silent. Put this clip on its own `data-track-index` — it will overlap the music bed.

To dip the music for the window, add points to the **bed's** `volume` lane with an explicit `v: 1` before the dip (a lane holds its first value backwards to its clip start, so without it the bed begins already ducked).

**ffmpeg.** Rate correction and the accelerating variant:
```bash
# retime a 72 BPM heartbeat to 120 BPM, pitch preserved (atempo 0.5–2.0, chainable)
ffmpeg -i heartbeat.wav -af "atempo=1.667" heartbeat_120.wav

# an accelerating heartbeat: concatenate three retimed segments, crossfaded in the gaps
ffmpeg -i hb_80.wav -i hb_100.wav -filter_complex "[0][1]acrossfade=d=0.05:c1=tri:c2=tri" hb_build.wav

# verify dryness: RT60-ish check — how fast does level fall after a transient?
ffmpeg -i heartbeat.wav -ar 48000 -af "asetnsamples=n=480,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
```
Use `atempo`, never `asetrate`, for rate changes here: `asetrate` shifts pitch, and a pitch-shifted heartbeat stops reading as a body. Keep the crossfade in an **inter-beat gap** and under 50 ms so the two segments fuse rather than flamming (the precedence window for complex sounds runs to ~40 ms).

**Remotion.** An `<Audio>` with a volume callback for the fades. Portability note only — Remotion is not part of this stack.

## Pairs with
[[sfx-felt-not-noticed]] · [[sfx-music-hard-stop]] · [[sfx-music-rest-windows]] · [[sfx-riser-anticipation-build]] · [[sfx-reverb-glue]] · [[sfx-filter-character-and-distance]] · [[sfx-cross-cut-audio-strategy]] · [[sfx-edge-fades-click-free]] · [[sfx-repetition-variant-rotation]] · [[sfx-emotion-music-lookup-table]] · [[sfx-layer-volume-targets]] · [[cut-punch-in-emphasis]] · [[motion-snap-zoom-punch]] · [[struct-emotional-arc-drives-retention]]

## Failure modes
- **Reverb on it.** The single fastest way to destroy the effect. Direct-to-reverberant ratio is the dominant distance cue; any audible tail moves the sound across the room. If your project has a global reverb-glue pass, this category is the documented exception.
- **Low-passing it "to make it feel internal".** Backwards. High-frequency loss is what *distance* sounds like; a muffled heartbeat reads as being behind a wall, not inside a chest.
- **Mixing it at the standard SFX tier.** At −15 dB it is a distant quiet thud. Proximity is partly a level cue — −11 dB is the default for a reason.
- **Running it under a full bed.** The heartbeat's fundamental sits under 150 Hz, straight into the bed's bass. Either you cannot hear it or it muddies the low end. Stop the music or take it to −28 dB.
- **Wrong rate for the emotion.** A 68 BPM heartbeat under a chase is limp; a 130 BPM heartbeat under a confession is melodramatic. The rate *is* the meaning.
- **Fading in or out on a thump.** A fade that lands mid-transient sounds like a dropout. Land both fades in the gap between beats.
- **Holding it for 20 seconds.** It stops being a state change and becomes a bed, at which point it is just noise in the sub. Cap at 12 s.
- **A wide stereo take.** Reads as a space around the viewer rather than as contact. Choose "Close" / "Isolated" sources; there is no width control in this stack to fix it afterwards.
- **Known gap:** the FX registry has **no pitch, no stereo-width and no panning node**, so pitch and image must both be baked with ffmpeg before placement. `reverb`'s `size` and `damping` are also non-automatable (they regenerate the impulse), which is irrelevant here only because the correct reverb setting is none.
