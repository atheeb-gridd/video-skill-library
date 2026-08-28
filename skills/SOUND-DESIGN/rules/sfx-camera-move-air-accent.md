---
id: sfx-camera-move-air-accent
title: Air on the camera — sounding zooms, push-ins and body movement so it is felt, not noticed
skill: sound-design
type: sfx
family: aesthetic-sfx
tags: [skill/sound-design, type/sfx, family/aesthetic-sfx, sfx/aesthetic, layer/sfx, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:41"
    quote: "But if I'm moving, if the camera is zooming, if I'm rolling my eyes, adding a whoosh or an air sound effect to all of that adds an aesthetic to the video."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:32"
    quote: "Cinematic hits, rises, textures."
research_refs:
  - https://gsap.com/docs/v3/Eases/
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Shutter_speed
  - https://en.wikipedia.org/wiki/Envelope_(music)
difficulty: medium
detectable_from: audio
---

# Air on the camera — sounding zooms, push-ins and body movement so it is felt, not noticed

## What it is
The aesthetic pass applied to **camera moves and human movement** — the two categories nobody would say need a sound. [[sfx-air-on-micro-movement]] establishes the class and its defining property (an aesthetic accent is defined by **level and spectrum**, not by choice of file: the same whoosh 10 dB louder with its low end intact becomes a motion effect and is heard as one). This note is the camera-and-body half, and its specific contribution is the **placement arithmetic**: where in a zoom the accent goes, derived from the zoom's own curve rather than eyeballed.

The distinction that matters: in this stack a camera move is not captured, it is **authored** — a punch-in is a `scale` tween with a named ease and a known duration. That means the velocity and acceleration profiles are not something to measure from frames; they are readable off the ease. A push-in on `sine.inOut` has its fastest moment at the exact midpoint; a punch on `expo.out` has it in the first two frames. Put the accent's loudest moment there and it disappears into the move. Put it anywhere else and the viewer cannot say what is wrong, only that something is.

## When to use it
- **On every authored camera move over ~4% scale travel**: a punch-in on an important A-roll line, a slow push under a section, a pull-out at a reveal, a reframe between two crops of the same shot.
- **On body movement that crosses or reframes**: a hand entering frame, a shoulder turn, a lean in, a head turn, an eye roll. The source names the eye roll specifically because it is the smallest movement anyone would think of sounding, and it works.
- **On captured camera motion** in B-roll: a handheld swing, a gimbal move, a rack focus, a drone push.
- **As a finishing pass**, after the sound-pass budget has already assigned diegetic and motion effects. Aesthetic accents are the last layer added and the first cut if the mix is crowded.
- **Not** on ambient drift. A still moving at 1.5%/s has no onset and no peak; sounding it produces an accent with nothing to attach to ([[motion-silent-motion-tier]]).
- **Not** where dialogue is dense and important. The accent will either be masked (wasted) or audible (a distraction). Prefer the gaps.
- **Not** as a substitute for a proper motion effect. If the thing moving is a graphic, it belongs to [[motion-whoosh-bound-entrance-and-traverse]] at motion-effect level, not here.

## How to recognise it in a reference video
Aesthetic accents are, by design, hard to hear. Detection is therefore mostly a **level and coincidence** test rather than a listening test.

- **The mute test is the primary signal.** Find a stretch with several camera moves and body gestures. If removing the effects layer makes the section feel flatter without any identifiable sound going missing, aesthetic accents are present. If you can name what disappeared, they were too loud and were functioning as motion effects.
- **Measure the level gap.** Take short-window loudness during the accent and during nearby dialogue. Aesthetic accents sit roughly **15–25 LU below dialogue** — considerably below the −12 to −15 dB band that motion effects occupy. Anything within 10 LU of dialogue is not an aesthetic accent.
- **Look for coincidence with movement, not with cuts.** Extract the section at 30 fps and mark every frame where the framing scale changes or a limb crosses. Then look for broadband energy in **500 Hz–8 kHz** at those frames. Coincidence with movement and *not* with cuts is the signature; coincidence with cuts means you are looking at [[sfx-whoosh-transition-movement-reveal]].
- **Check the low end.** An aesthetic accent is high-passed: essentially nothing below ~400 Hz. A move accent with weight under 200 Hz has been left un-filtered and will be heard.
- **Where is the peak, relative to the move?** Extract the move's per-frame scale or position and find its fastest frame. In careful work the accent's loudest 100 ms window contains that frame within ±1 frame.
- **Density.** Count accents per minute. This class can run denser than motion effects because it lives below the noticed threshold, but two overlapping accents cancel the effect — they become one audible swell. Above roughly **10 per minute** you are back in overload territory.
- **Log the negative.** Many creators never do this pass. A reference with clean motion effects and no aesthetic layer is a legitimate and cheaper style; write it into the profile rather than assuming it was an oversight.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `level` | −20 dB | −18 … −24 dB | Against dialogue at 0 to −3 dB. **This is the parameter that defines the class.** Motion effects live at −12 to −15; an accent at −14 is a motion effect. |
| `highpass` | 500 Hz | 300–1000 Hz | Removes the weight so the sound reads as air. The FX registry's `highpass` defaults to 300 Hz with `q` 0.707 and `poles: 2` (12 dB/oct); `poles: 1` is a gentler 6 dB/oct. |
| `lowpass` | none | 10–14 kHz | Optional, to stop a bright swish reading as hiss on small speakers. |
| `body_length` | 1.15 × the move | 1.0–1.3× | Same ratio as any motion sound; reverb tail may run past. |
| `peak_position` | at the move's fastest frame | ±1 f | Derived from the ease, see the table below. |
| `sync_offset` | 0 f | 0 to +1 f **late** | Never early. Sound leading picture is detected from about 45 ms; lagging only from about 125 ms. |
| `reverb` | 10% wet | 5–20% | So the accent exists in the room rather than on top of it. The FX `reverb` node convolves a *generated* impulse — reproducible without shipping a file. |
| `min_travel_scale` | 1.04× | 1.03–1.06× | Below this scale change, do not accent. |
| `min_travel_position` | 6% of frame width | 4–10% | For a pan or a body gesture. |
| `max_density` | 10 / min | 4–14 / min | And never two overlapping. |
| `pitch_by_size` | down 1–3 st for full-frame moves | ±1–3 st | A whole-frame camera move is a large object; pitch it down. A hand gesture is small; pitch it up. |
| `pitch_direction` | follows travel | ±2–5 st | Push-in / zoom-in → rising. Pull-out → falling. |

**Where the accent's peak goes, by camera-move type.** Read the fastest frame off the ease rather than guessing:

| Move | Typical spec | Ease | Peak at | Sound character |
|---|---|---|---|---|
| **Slow push** (ambient) | scale 1.00→1.06 over 4–8 s | `sine.inOut` / `none` | 50% (or no peak on `none`) | Sustained texture, **no transient at all**. −22 dB. |
| **Punch-in** (emphasis) | scale 1.00→1.15 over 4–7 f | `expo.out` / `power4.out` | **5–15%** — the first 1–2 frames | Short air with a soft front. 0.25–0.4 s. |
| **Reframe / crop change** | scale + position over 8–14 f | `power3.out` | 10–20% | Short air. |
| **Pull-out / reveal** | scale 1.12→1.00 over 12–24 f | `power2.inOut` | 45–55% | Falling-pitch air. |
| **Snap / whip zoom** | scale 1.00→1.4 over 5–8 f | `expo.in` then cut | **85–100%** | This is past air — use a real whoosh at motion-effect level. |
| **Handheld swing** (captured) | measured from footage | n/a | at the optical-flow magnitude peak | Air with a rise-fall contour. |
| **Body gesture / head turn** | 6–15 f of limb travel | n/a | at the frame of maximum limb displacement | Short cloth or air, 0.2–0.5 s. |
| **Eye roll / micro-gesture** | 4–8 f | n/a | on the middle frame | Very short, very quiet: −24 dB, 0.15–0.25 s. |

## Reproduction prompt

```
Run the aesthetic air pass over {{SECTION}} ({{IN}} to {{OUT}}).

1. INVENTORY THE MOVES. List every camera move and body movement in the
   section, from two sources:
     (a) the composition's own tweens - every scale/x/y tween on a clip
         wrapper or a video element IS a camera move, with a known start,
         duration and ease;
     (b) the footage - extract at 30fps and mark frames where a limb crosses,
         the head or shoulders turn, or the framing changes.
   Discard any move under 1.04x scale or under 6% of frame width. Those go in
   the silent tier.

2. FOR EACH REMAINING MOVE, derive the peak frame:
     authored move -> read it off the ease:
        *.out family        -> 0.15 * duration (expo.out: 0.08)
        *.in family         -> 0.92 * duration
        *.inOut / sine.inOut-> 0.50 * duration
        none (linear)       -> no peak: use a SUSTAINED texture, no transient
     captured move -> the frame of maximum measured displacement.

3. FETCH ONE FAMILY OF AIR and reuse it across the whole section with
   variations. Do not fetch a different file per move.

4. PLACE:
     data-start so the file's LOUDEST sample lands on the peak frame - measure
       the file's own peak, do not assume it is at the head:
       ffmpeg -i air.wav -af ebur128=metadata=1,ametadata=print:key=lavfi.r128.M \
         -f null - 2>&1 | grep -B1 pts_time
     data-duration = 1.15 * the move's duration (trim in place, do not cut a
       file)
     data-volume set for -20 dB relative to dialogue at 0 to -3 dB
     data-audio-group = "sfx" (never the voiceover carve group)

5. FILTER IT INTO THE AESTHETIC CLASS. On each accent, or better on an
   <hf-audio-group> shared by all of them, apply an fx chain:
       highpass 500 Hz, q 0.707, poles 2   (removes weight -> reads as air)
       reverb wet 0.10                     (puts it in the room)
   The high-pass is not optional. It is what separates this class from a
   motion effect.

6. DENSITY CHECK. No two accents may overlap. If the section has more than ~10
   moves per minute, keep the accents on the moves that coincide with a
   spoken emphasis and drop the rest.

7. VARY. Across the section, step pitch +/-1-3 semitones and vary duration so
   the same file never repeats identically. Remember data-playback-rate is
   PITCH-PRESERVED, so it varies length only; pitch variation must be
   preprocessed with ffmpeg.

ACCEPTANCE TEST:
(1) Play the section at normal level. You must NOT be able to name any of the
accents. If you can name one, it is 4-8 dB too loud or not high-passed.
(2) Mute the effects track and play again. The section must feel flatter, with
nothing identifiably missing. If nothing changes, the accents are too quiet or
badly placed; if something identifiably disappears, they are too loud.
(3) For each accent, confirm its loudest 100ms window contains the move's
fastest frame within one frame.
(4) Check the spectrum: essentially no energy below 400 Hz.
(5) Confirm no two accents overlap in time.
```

## Execution spec

**HyperFrames.** The right structure is a **bus**, not per-clip chains: the high-pass and the reverb are the same treatment on every accent, and *"a compressor cannot ride a sequence it only hears a third of"* — the same logic applies to a shared filter.

```html
<hf-audio-group id="air" data-label="Aesthetic air" data-volume="0.10"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;a1&quot;,&quot;label&quot;:&quot;Remove Weight&quot;,
     &quot;params&quot;:{&quot;frequency&quot;:500,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
    {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;a2&quot;,&quot;label&quot;:&quot;Room&quot;,
     &quot;params&quot;:{&quot;size&quot;:0.45,&quot;damping&quot;:0.5,&quot;wet&quot;:0.10,&quot;dry&quot;:0.9}}]}"></hf-audio-group>

<!-- punch-in on an A-roll line: scale 1.00 -> 1.15 over 0.20s on expo.out at 74.60 -->
<!-- expo.out peaks at 0.08 * 0.20 = 0.016 -> peak_time 74.616; file peak is 0.09s in -->
<audio id="air-punch-1" src="assets/sfx/air-soft.wav" data-audio-group="air"
       data-start="74.526" data-duration="0.23" data-track-index="14"
       data-volume="0.10"></audio>
```

```js
// the move the accent belongs to
tl.fromTo("#aroll-2", { scale: 1.00 }, { scale: 1.15, duration: 0.20, ease: "expo.out" }, 74.60);
```

Contract points that bind this:
- **Membership alone (`data-audio-group`) is enough to carve against; adding the `<hf-audio-group>` element makes it a real bus** — one chain, one fader, one automation clock for every member. This is the correct reach: a shared treatment across many clips.
- **A bus's automation clock is COMPOSITION time**, not clip-local — the opposite of a clip lane, where `t: 0` is the clip's own start. Worth remembering if you automate the group's level across a section.
- **`data-fx-carve` is clip-only** and must never appear on an `<hf-audio-group>` (`audio_group_carve_attr`). Also: keep the carve group voices only — an SFX clip inside the `voiceover` group poisons the next re-analysis silently.
- **Escaping is load-bearing.** Double-quote the JSON attributes with `&quot;` inside; `carve.mjs` locates them with a `name="..."` regex and a single-quoted attribute is invisible to it.
- **`highpass` is automatable** (`frequency` and `q` are both **AUTO**), and so are `reverb`'s `wet`/`dry` — but `reverb`'s `size` and `damping` regenerate the impulse and are **not** automatable, and `compressor`/`limiter`/`gate`/`bitcrush` have **zero** automatable parameters (they are AudioWorklets configured wholesale). Automate a `gain` stage around those instead.
- **Out-of-range params are clamped on read**, so anything that parses is safe to realise; but **nothing validates the chain at all** — render refuses an unparseable chain outright while preview plays it **dry**, so "it sounded fine in preview" is not evidence the chain ran.
- **Every `<audio>` needs an `id`** or it is never mixed — silent render.
- **`duplicate_audio_track`** warns on two `<audio>` sharing a track index *and* overlapping. Since accents must not overlap anyway, one index for the whole class is fine.
- **`data-playback-rate` is a constant in `0.1..5`, pitch-preserved.** It varies length, not pitch. **There is no rate envelope** and no pitch node — pitch variations are ffmpeg preprocesses producing new files.
- **Audio lives at the host root** in modular projects so playback survives scene cuts, while the camera tween lives inside the scene. If the move is in a sub-comp at scene-local `t`, the accent's `data-start = t + the slot's data-start`.
- **Diagnosis rule:** *"The absolute spectrum of a single unknown voice cannot be diagnosed."* Judge the accent's level against the dialogue **in the same file**, never against an absolute target.

**Epidemic Sound.** One family, reused:

```
SearchSoundEffects { query: { term: "subtle air whoosh short light movement" },
                     filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--whoosh", "swooshes--swish"] },
                               duration: { max: 1200 } } }
# for body / cloth movement specifically
SearchSoundEffects { query: { term: "cloth movement soft flap short" },
                     filter: { tagSlugs: { matchType: "ANY", values: ["cloth--flap"] },
                               duration: { max: 1200 } } }
```
Typical returns in this band run **390–1200 ms**, which covers every move in the table without trimming beyond `data-duration`. Fetch two or three and use `SearchSimilarToSoundEffect` rather than accumulating a folder of one-offs.

**ffmpeg — measuring and varying.**

```bash
# the file's own loudest moment, for alignment
ffmpeg -i air.wav -af ebur128=metadata=1,ametadata=print:key=lavfi.r128.M -f null - 2>&1 | grep -B1 pts_time
# a pitched variation (+2 semitones, length preserved)
ffmpeg -i air.wav -af "asetrate=48000*1.122,aresample=48000,atempo=0.891" air.up2.wav
# a baked high-pass, if you want the filtering in the asset rather than the chain
ffmpeg -i air.wav -af "highpass=f=500:poles=2" air.hp.wav
# measure the level gap between an accent and nearby dialogue, in the same file
ffmpeg -i mix.wav -af "ebur128=metadata=1,ametadata=print:key=lavfi.r128.M" -f null -
```

**Remotion.** Same arithmetic, frame-native: `peakFrame = moveStart + Math.round(peakFraction * moveFrames)`. Concept only.

## Pairs with
[[sfx-air-on-micro-movement]] · [[motion-whoosh-bound-entrance-and-traverse]] · [[sfx-envelope-matched-to-easing-curve]] · [[cut-punch-in-emphasis]] · [[motion-screen-recording-cursor-punch-in]] · [[motion-still-image-drift]] · [[motion-parallax-depth-move]] · [[motion-silent-motion-tier]] · [[sfx-sound-pass-order]] · [[sfx-density-fatigue-audit]] · [[sfx-synthetic-family-catalogue]] · [[sfx-layered-approach-and-impact]] · [[sfx-av-sync-binding-window]]

## Failure modes
- **Too loud.** The single defining failure: at −14 dB the accent is a motion effect, the viewer hears a whoosh on a zoom, and the polish becomes a gimmick. Correction: −18 to −24 dB, and the "can you name it" test.
- **Not high-passed.** Low-end weight makes a small move sound heavy and instantly audible. Correction: high-pass at 500 Hz, `poles: 2`.
- **Peak in the wrong place.** Putting the loudest moment at the middle of an `expo.out` punch-in means the camera has already arrived when the sound peaks. Correction: read the peak fraction off the ease; punch-ins peak in the first two frames.
- **Sounding ambient drift.** A 1.5%/s drift has no onset and no fastest frame, so the accent floats free of the picture. Correction: silent tier.
- **Overlapping accents.** Two air sounds at once stop being subliminal and become one audible swell. Correction: never overlap; drop the lesser move.
- **One file, sixty times.** Even below the noticed threshold, exact repetition builds a pattern the ear finds. Correction: pitch and length variations across the section.
- **Accents under dense dialogue.** Masked and wasted, or audible and distracting. Correction: prefer the gaps; drop the rest.
- **Adding this pass before the others.** Aesthetic accents on a video with no ambience and missing diegetic sounds is polishing a hollow mix. Correction: Layers 2 and 3 first; this pass is last.
- **Known gap:** this stack has **no optical-flow or motion-vector extraction**, so the "frame of maximum displacement" for a *captured* handheld swing or body gesture must be found by an analysis pass on extracted frames and written into the design document as a literal timecode. For *authored* camera moves the peak is computable from the ease and needs no measurement at all — which is a strong argument for authoring the camera move rather than baking it into the footage.
