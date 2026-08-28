---
id: sfx-peak-at-motion-midpoint
title: On a motion, the peak goes at the velocity peak — not the file start, not always the middle
skill: sound-design
type: sfx
family: sync
tags: [skill/sound-design, type/sfx, family/sync, engine/hyperframes, engine/ffmpeg, engine/epidemic, sfx/motion, layer/sfx, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:07:04
    quote: "And if you're putting a sound effect on a motion, then match the peak of the sound effect to the middle of the motion."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:07:08
    quote: "And match the length of the sound effect with the motion. Either by changing the speed, or by layering multiple sound effects."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:06:58
    quote: "So first of all, if you're putting a sound effect on a cut, place the highest peak of the sound effect on the cut."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:07:02
    quote: "And you can find the peak just by looking at the waveform."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://librosa.org/doc/latest/generated/librosa.onset.onset_detect.html
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://en.wikipedia.org/wiki/Inbetweening
difficulty: high
detectable_from: audio
---

# On a motion, the peak goes at the velocity peak — not the file start, not always the middle

## What it is
The source states two placement rules back to back and they are **different rules**: on a **cut**, the sound's loudest peak goes on the cut frame; on a **motion**, the peak goes at *"the middle of the motion"*. The cut case is covered by [[sfx-peak-on-the-cut]]. This note is the motion case, and it exists because "the middle" is right for only some motions.

The reason is easing. A sound effect's peak reads as the moment of maximum *movement*, and where the maximum movement happens is a property of the easing curve, not of the clip window:

- **Symmetric eases** (`sine.inOut`, `power2.inOut`, `expo.inOut`) have their velocity maximum exactly at the halfway point. For these, the source's rule is literally correct.
- **Ease-outs** — which include `power3.out`, the house default for entrances — have their velocity maximum at the **very start**. The element leaves fast and settles slowly, so the peak of the *sound* belongs near the front, not the centre. Anchoring at the midpoint on a `power3.out` entrance puts the accent where the element has almost stopped, and it reads as late even though nothing about the sound is late.
- **Ease-ins** (`power3.in`, typically an exit or a fall) peak at the **end**, which is why they usually want an impact rather than a sweep.
- **Linear** (`none`) has no velocity peak at all; the midpoint is the correct default by elimination.

The second half of the rule — match the sound's **length** to the motion's length, by changing speed or by layering — is the part most edits skip, and it is the one that decides whether the pair reads as one event.

## When to use it
- **Every sound placed because something moved** rather than because something cut: a title entrance, a card sliding, a graphic traversing, a scale punch, a mask wipe, an on-screen number rolling up, a line drawing itself.
- **On an impact inside a motion** — the source's own example is a hand coming down: a whoosh for the travel plus a hit whose peak lands on the impact frame. The travel sound follows this note; the impact follows [[sfx-peak-on-impact-frame]].
- **When a motion event already exists in the design document** with a known easing and duration, because then the anchor is computable rather than auditioned.
- **Not on a cut with no movement.** That is the other rule, and mixing them puts sweeps on static edits.
- **Not on a bed, drone, tone or ambience.** Those have no meaningful peak and are placed by onset and level.
- **Not where the length mismatch is more than about 25%.** Fix the length first; anchoring a 1.5 s whoosh on a 6-frame slide is a well-anchored mistake.

## How to recognise it in a reference video
- **Get the motion window, then the audio peak, then subtract.** Motion windows come from the picture; sample the frames and find where the element's displacement per frame is highest. Audio peaks come from a per-frame peak trace:
  ```bash
  # per-frame PEAK level; n=1600 @48 kHz is exactly one frame @30fps
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
   ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
  ```
  A placed motion effect shows as a local maximum rising **≥8 dB** above the surrounding 10 frames.
- **Report the anchor as a fraction of the motion, not in frames.** `anchor_fraction = (sfx_peak_frame − motion_start_frame) ÷ motion_length_frames`. This is the number that makes references comparable across motions of different lengths, and it is the finding to log:
  - **0.10–0.25** → anchored to an ease-out's velocity peak. Expect `power3.out`-family entrances in the motion design.
  - **0.40–0.60** → the midpoint. Expect symmetric eases, or a creator applying the rule literally.
  - **0.75–1.00** → anchored to arrival. Expect ease-ins, impacts, or reverse/riser-shaped sounds.
  - **Above 1.0** → the sound peaks after the motion has finished. A defect, and the most common one.
- **Read the easing off the picture to confirm.** Plot the element's position per frame. A long tail with a fast start is an ease-out; an S-curve is `inOut`; a straight line is linear. The audio anchor should sit at the steepest part of that curve.
- **Measure the length ratio.** `sfx_duration ÷ motion_duration`. Auditioned work sits at **0.8–1.25**. Above 1.5 the sound outlives the picture; below 0.6 the motion continues in silence.
- **Look for the layered pair.** A long motion often carries two files: a sweep across the travel plus a transient at the arrival. Two peaks in one motion window, the second at `anchor_fraction ≈ 1.0`, is that pattern and it is a good sign, not a defect.
- **Check the direction of error.** A late peak is heard as sloppy; an early peak is heard as broken. Audio *lagging* picture is detectable from around 125 ms, audio *leading* from around 45 ms — roughly three times tighter. If a reference errs, note which way.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `anchor_fraction` | see the easing table below | 0.0–1.0 | Position of the SFX peak within the motion window, as a fraction. This replaces "the middle" as the spec. |
| — `sine.inOut`, `power2.inOut`, `expo.inOut` | 0.50 | 0.45–0.55 | The source's rule, correct here. |
| — `power3.out`, `power4.out`, `expo.out` (house entrance default) | 0.18 | 0.10–0.25 | Velocity maximum is at t=0; give the sound a little body before the peak rather than anchoring at exactly 0. |
| — `power1.out`, `power2.out` | 0.25 | 0.18–0.35 | Gentler ease-out, later peak. |
| — `power3.in`, `power4.in` | 0.88 | 0.75–1.00 | Velocity maximum at the end. Usually wants an impact, not a sweep. |
| — `none` (linear) | 0.50 | 0.40–0.60 | No velocity peak; midpoint by elimination. |
| — `back.out(1.7)`, `elastic.out` | 0.15 | 0.10–0.22 | Fast departure; the overshoot may earn a second, quieter transient at the settle. |
| — baked `springEase` (ζ = 1.0) | 0.20 | 0.15–0.28 | Behaves like a `power3.out`. Take both ease and duration from the helper. |
| `length_ratio` | 1.0 | 0.8–1.25 | `sfx_duration ÷ motion_duration`. Enforce at fetch with the duration filter, not by stretching. |
| `speed_correction` | 1.0 | 0.8–1.25 | If a fetched file is the wrong length, `data-playback-rate` corrects it and is **pitch-preserved**, which is exactly right here. Beyond ±25% the envelope audibly changes character. |
| `layer_instead_of_stretch` | when ratio < 0.6 | — | A motion much longer than any available file wants two files (sweep + arrival), not one stretched one. |
| `max_lag` | +3f (0.10 s) | 0 to +3f | Frames at 30 fps. Late is forgiven. |
| `max_lead` | −1f (0.033 s) | −1f to 0 | Early is not. Never place a motion sound more than one frame early. |
| `level` | 0.211 (≈−13.5 dB) | −15 to −12 dB | The SFX slot. |
| `sub_comp_offset` | required | — | If the motion lives in a sub-composition, the audio at the root needs `data-start = scene_local_t + host data-start`. |

## Reproduction prompt

```
Place a motion sound effect on the animation at {{MOTION_START}} (seconds,
composition time) lasting {{MOTION_LEN}} frames at 30 fps, eased with
{{EASE}}.

1. READ THE MOTION off the design document, not off the picture: start time,
   length in frames, and the easing name. If the easing is unknown, plot the
   element's position per frame and classify it: fast-start-long-tail =
   ease-out; S-curve = inOut; straight = linear.
2. COMPUTE THE ANCHOR FRACTION from the easing - this is the whole technique:
     sine.inOut / power2.inOut / power3.inOut / expo.inOut -> 0.50
     power3.out / power4.out / expo.out / springEase       -> 0.18
     power1.out / power2.out                              -> 0.25
     power3.in / power4.in                                -> 0.88
     none (linear)                                        -> 0.50
     back.out / elastic.out                               -> 0.15
   Then:
     anchor_time = {{MOTION_START}} + ({{MOTION_LEN}} / 30) * anchor_fraction
   Do NOT default to the midpoint on an ease-out entrance. The element has
   nearly stopped by then and the accent will read as late.
3. FETCH BY LENGTH FIRST. motion_ms = {{MOTION_LEN}} / 30 * 1000. Search with
   a duration filter of 0.8*motion_ms to 1.25*motion_ms milliseconds. Pull 3
   candidates. If nothing exists in that band, do NOT stretch a long file -
   layer instead (step 7).
4. MEASURE THE CHOSEN FILE'S PEAK OFFSET from its head, in seconds:
   {{PEAK_T}}. Never assume it is 0 - swept effects peak 40-70% of the way
   in. Use the per-frame peak print or numpy argmax.
5. PLACE:
     data-start = anchor_time - {{PEAK_T}}
   If that start falls before the shot begins, trim into the file with
   data-media-start rather than moving the peak. The peak may sit up to 3
   frames LATE and at most 1 frame EARLY.
6. LENGTH-CORRECT IF NEEDED. If the file is 10-25% off, set
   data-playback-rate = sfx_duration / motion_duration (valid 0.1-5, and
   pitch-preserved, so only the length changes). Recompute {{PEAK_T}} after:
   the peak's position scales with the rate.
7. LAYER FOR LONG MOTIONS instead of stretching: one sweep with its peak at
   the computed anchor, plus one transient with its peak at anchor_fraction
   1.0 (the arrival frame). Put them on different track indices and drop the
   pair 2 dB so the stack does not exceed a single hit.
8. SET GAIN to 0.211 and group "sfx" - never "voiceover".

ACCEPTANCE TEST: play the motion three times. On pass one, the sound and the
movement must feel like one event. On pass two, if you can say "early" or
"late", move the anchor by 1 frame in that direction and repeat - and if you
had to move it more than 3 frames, your easing classification is wrong, so go
back to step 1. On pass three, watch only the END of the motion: if the sound
is still going after the element has settled, the length ratio is above 1.25
and you need a shorter file, not a fade.
```

## Execution spec

**Finding the peak — three routes, in order of availability.**
```bash
# 1. ffmpeg only, per-frame peak trace; read off the maximum's frame index
ffmpeg -i sfx.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
# 2. ffmpeg whole-file summary, to confirm the absolute value
ffmpeg -i sfx.wav -af "astats=measure_overall=Peak_level+RMS_level" -f null -
# 3. python, exact peak time in one line (plus onsets, for the layered case)
python3 - <<'PY'
import numpy as np, soundfile as sf
y, sr = sf.read("sfx.wav", always_2d=True); y = y.mean(axis=1)
peak_t = int(np.argmax(np.abs(y))) / sr
print(f"PEAK_T={peak_t:.4f}s  frame@30={round(peak_t*30)}  dur={len(y)/sr:.3f}s")
PY
```
Neither `numpy`/`soundfile` nor `librosa` is verified present in this environment, so **route 1 always works and is the one to write into a spec**. `librosa.onset.onset_detect(y=..., sr=..., units="time")` is the right tool if you need *all* the transients in a file (the layered case, or picking one hit out of a `Various`/`x6` compilation); `argmax(abs(y))` is the right tool for a single anchor.

**Store `peak_t` once, in the library index.** Measuring it at ingest ([[sfx-library-build-and-taxonomy]]) removes the most-skipped step from every future placement — and skipping it is exactly how an accent lands 5–10 frames late.

**HyperFrames — the placement, and the one attribute that is genuinely right here.** All authored time is in **seconds**; there is no frame attribute, so convert at authoring time and leave the frame count as a comment.
```html
<!-- Motion: title entrance at 41.00 s, 18 frames (0.60 s), power3.out.
     anchor_fraction 0.18  ->  anchor_time = 41.00 + 0.60*0.18 = 41.108
     chosen swoosh peaks 0.09 s into the file  ->  data-start = 41.018 -->
<audio id="sfx-title-in" src="assets/sfx/motion/swish/motion_swish_bright-short_02.wav"
       data-audio-group="sfx"
       data-start="41.018" data-duration="0.56" data-media-start="0"
       data-track-index="22" data-volume="0.211"></audio>

<!-- Length correction: a 0.72 s file on a 0.60 s motion -> rate 1.2 -->
<audio id="sfx-card-slide" src="assets/sfx/motion/whoosh/motion_whoosh_short_04.wav"
       data-audio-group="sfx"
       data-start="52.86" data-duration="0.60"
       data-playback-rate="1.2"        <!-- pitch-PRESERVED: only length changes -->
       data-track-index="22" data-volume="0.211"></audio>
```
and the motion it is bound to, on the same timeline, at the same numbers:
```js
// 18 frames @30fps = 0.60 s. Entrance, house settle, at t = 41.00 s.
tl.fromTo("#title", { y: 40, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.60, ease: "power3.out" }, 41.00);
```
The contract facts that make or break this:
- **`data-playback-rate` is 0.1–5, constant, and pitch-preserved** — which is unusually well suited to length matching, because length is the only thing you want to change. But there is **no rate envelope**: *"Source speed ramps are not supported… preprocess a derived synchronized asset."* And after a rate change, **`peak_t` scales**: `peak_t_effective = peak_t / rate`. Recompute or the correction moves the anchor.
- **There is no audio-follows-animation attribute.** Picture and sound are coupled *by the author writing the same number twice* — the tween's position and the `<audio data-start>`. This is the single most important sentence in this note's execution.
- **A sub-comp timeline cannot animate host-root elements**, and sub-comp time is scene-local. If the motion lives in `compositions/scene-3.html` at scene-local `t = 1.20` and the host slot starts at `28.00`, the root-level audio's anchor is `29.20 + …`. Relative timing (`data-start="el-scene-3 + 1.2"`) can express it, but **spaces around the operator are required** and every parse failure resolves silently to `0`.
- **Use `gsap.fromTo`, never `gsap.from`** — `from()` sets `immediateRender: true` and writes its start state at construction, before the clip's `data-start` is active, so under the render engine's non-linear seek the element flashes or skips its entrance. A motion that did not happen cannot be synced to.
- **Land the tween slightly before the clip's `data-duration`** — the visibility window is half-open, so an animation resolving exactly on `data-duration` never renders its last frame.
- **Every `<audio>` needs an `id`** or it is never mixed → silent render, no error. Two overlapping `<audio>` on one `data-track-index` raise `duplicate_audio_track`, so the layered pair goes on 22 and 23.
- **Stagger cap:** if the motion is a staggered group, the whole arrival is meant to read as one beat (`items × stagger ≤ ~0.5 s`), so it takes **one** sound anchored to the group's velocity peak — not one per item.

**Epidemic Sound — fetch by length, because length is the parameter you cannot fix well.**
```
# motion of 18 frames = 600 ms  ->  480-750 ms
SearchSoundEffects { query:{term:"whoosh transition fast"},
                     filter:{duration:{min:480,max:750}},
                     sort:{by:POPULARITY,order:DESCENDING}, first:20 }
# by verified slug, when you know the family
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["swooshes--swish"]},
                              duration:{min:480,max:750} }, first:24 }
# the arrival transient for a layered long motion
SearchSoundEffects { query:{term:"impact short dry"},   filter:{duration:{min:200,max:900}}, first:20 }
# a sweep that builds INTO the arrival (reveals)
SearchSoundEffects { query:{term:"reverse whoosh"},     filter:{duration:{min:600,max:1500}}, first:20 }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
`audioFile.durationInMilliseconds` is the number you match; `audioFile.waveformUrl` shows roughly where the peak sits before you download. **WAV always** — mp3 pre-echo smears the exact transient you are aligning to a frame.

**Remotion:** an `<Audio>` in a `<Sequence>` whose `from` is `round((anchor_time − peak_t) × fps)`; Remotion's native frame model makes this arithmetic direct. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-peak-on-the-cut]] · [[sfx-peak-on-impact-frame]] · [[sfx-envelope-matched-to-easing-curve]] · [[sfx-av-sync-binding-window]] · [[sfx-arbitrary-sound-motion-sync]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-swoosh-vs-whoosh]] · [[sfx-motion-sound-selection]] · [[sfx-unsounded-motion-audit]] · [[sfx-layered-approach-and-impact]] · [[sfx-library-build-and-taxonomy]] · [[motion-sound-bound-motion-event]] · [[motion-impact-frame-quantisation]] · [[motion-entrance-vocabulary]] · [[motion-whoosh-bound-entrance-and-traverse]] · [[motion-sfx-pass-manifest]]

## Failure modes
- **Anchoring at the midpoint on an ease-out entrance.** The literal reading of the rule, and wrong for the most common easing in the stack. The element has nearly settled by 50%, so the accent reads late. Fix: 0.18 for the `power3.out` family.
- **Assuming the file's peak is at its head.** Places the effect late by the length of its attack, typically 5–10 frames. Fix: measure `peak_t`; store it at ingest.
- **Stretching a long file to length.** Changes the envelope's character and usually turns a whoosh into a wobble. Fix: fetch inside the duration band, or layer sweep + arrival.
- **Forgetting that `data-playback-rate` moves the peak.** A rate of 1.2 divides `peak_t` by 1.2, so the anchor shifts by that difference. Fix: recompute `peak_t / rate` after any rate change.
- **Trying to ramp the rate.** No rate envelope exists. Fix: preprocess a derived asset with ffmpeg.
- **Placing early.** The direction the ear catches first — audible from about 45 ms, versus about 125 ms for late. Fix: `max_lead` of one frame, and bias late when unsure.
- **One sound per item in a staggered group.** Turns a single arrival beat into a machine-gun. Fix: one sound at the group's velocity peak.
- **Using `gsap.from()` for the motion.** The entrance may not happen at all under seek, so there is nothing for the sound to be synced to, and the bug looks like a sound problem. Fix: `fromTo`.
- **Scene-local time written as composition time.** The sound lands at the sub-comp's local offset instead of the global one, which is usually a wildly wrong place. Fix: `scene_local_t + host data-start`, and if using relative timing, remember the four silent-zero failure modes.
- **Known gap:** no cited study measures the perceptually ideal anchor point within a motion. The easing table is derived analytically — the velocity maximum of each named GSAP ease from the execution contract's own list — and the ±window is derived from broadcast A/V sync thresholds (roughly 45 ms lead to 125 ms lag detectability) applied by analogy from lip-sync. Treat the anchor fractions as computed defaults and a human ear as the authority; the one figure that is *not* a derivation is that the source itself says "the middle", which this note keeps as correct for symmetric eases.
