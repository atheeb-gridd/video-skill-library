---
id: motion-impact-frame-quantisation
title: Find the impact frame, then quantise the motion to the frame grid
skill: motion
type: motion
family: sync-placement
tags: [skill/motion, type/motion, family/sync-placement, sfx/diegetic, sfx/motion, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, engine/remotion, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:14"
    quote: "Now the peak of my hit sound effect should land exactly on the impact frame of my hand."
research_refs:
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://gsap.com/docs/v3/Eases
  - https://www.nngroup.com/articles/animation-duration/
difficulty: high
detectable_from: video
---

# Find the impact frame, then quantise the motion to the frame grid

## What it is
Two jobs that must be done in order. First, **identify the single frame of contact** in the footage — the frame where the hand meets the table, the object lands, the door shuts, the logo hits its rest pose. Second, **quantise every authored motion and sound around it to the frame grid**, because this engine authors time in seconds while the render samples in frames: a value that is not a whole multiple of `1/fps` lands on whichever frame the sampler happens to hit, and a one-frame error in either direction is visible.

[[sfx-peak-on-impact-frame]] owns the audio side of the same moment (align the sound's peak, not its file start). This note owns the picture side: how the contact frame is found, and how a seconds-based composition is made frame-exact.

## When to use it
- **Any diegetic impact** in the footage that will carry a hit, a shake, or a graphic ([[motion-camera-shake-impact]]).
- **Any authored slam** — a title, number or logo arriving at a hard stop.
- **Any transition whose swap frame is the event** — the mid-point of a whip pan, the plateau of a light leak ([[motion-whip-pan-transition]], [[motion-light-leak-overlay-transition]]).
- **Any beat-locked animation**, where a music transient defines the frame ([[pace-cut-on-the-beat]]).
- **Before changing render fps.** A composition authored on the 30 fps grid is off-grid at 24 fps; requantise before rendering.

## How to recognise it in a reference video
- **Step the frames around contact.** `ffmpeg -i ref.mp4 -vf "select='between(n,140,160)',showinfo" -vsync 0 -frame_pts 1 /tmp/f/%d.png` prints each frame's `n` and `pts_time` and writes it out, so the frame number you pick is the frame number you can convert to seconds.
- **Use motion blur as the cue.** With a normal shutter, the frames *approaching* contact carry the longest blur streaks; the contact frame is typically the **first frame where the streak collapses** — the object has decelerated to near zero. The frame after usually shows deformation, recoil or dust.
- **Displacement test.** Measure the moving object's displacement per frame. The contact frame is the first frame where displacement drops below ~25% of the previous frame's.
- **Sound test on the reference.** Locate the loudest sample within ±0.5 s; competent work has it on the same frame as the collapse of blur, ±1. This also tells you the reference's own tolerance.
- **Check the graphic's extreme.** If a title slams, its most-displaced/most-scaled frame should be a single frame, not a smear across three — a soft extreme means the motion was not quantised.
- **Look for off-grid symptoms:** an impact that reads 1 frame late on every playback, or a shake whose first frame is half-strength (the sampler caught the tween mid-rise).
- **Check the fps.** `ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate,avg_frame_rate ref.mp4`. A 24 fps source cut into a 30 fps timeline has contact frames that do not coincide with the output grid — expect ±1 frame slop and log it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `fps` | 30 | 24 / 30 / 60 | Render default is 30; `--fps` overrides. Pin it before authoring. |
| `frame_time` | 0.0333 s | 0.0417 (24) / 0.0333 (30) / 0.0167 (60) | `1/fps`. |
| `quantise_rule` | `round(t*fps)/fps` | — | Apply to every impact, swap and sound placement. |
| `portable_grid` | 1/6 s | — | Only multiples of 0.1667 s sit on the 24, 30 and 60 grids simultaneously. Everything else is fps-specific. |
| `impulse_form` | `tl.set` at t | — | An instantaneous displacement, not a 1-frame tween — a tween can be sampled mid-rise. |
| `settle_duration` | 0.40 s (12 f) | 0.27–0.50 s | Author as an exact frame multiple: 12/30 = 0.4, 10/24 = 0.4167. |
| `align_tolerance` | ±1 f | −3 f to +1 f | ITU-R BT.1359-1: detectability ≈ +45 ms lead / −125 ms lag; acceptability +90 / −185 ms. |
| `pre_impact_lead` | 0 f | 0–2 f | Anticipation (squash/wind-up) ends **on** the impact frame, never after. |
| `verification_pass` | required | — | Render, step, correct by ±1 frame if needed, re-render. |
| `blur_collapse_ratio` | 0.25 | 0.15–0.35 | Displacement drop that identifies contact. |

## Reproduction prompt

```
Lock the motion at {{IMPACT}} to a single frame.

STEP 1 - FIND THE FRAME. Export frames around the event with their numbers and
timestamps:
  ffmpeg -i {{SRC}} -vf "select='between(n,{{N0}},{{N1}})',showinfo" -vsync 0 -frame_pts 1 /tmp/f/%d.png
Pick the contact frame N: the first frame where the moving object's motion blur
collapses and its displacement drops below 25% of the previous frame's. Note
its pts_time.

STEP 2 - CONVERT AND QUANTISE. Compute t = N / fps and use that number
verbatim. Quantise every related value the same way: round(value * fps) / fps.
At 30fps, frame 181 = 6.0333s; a 12-frame settle = 0.4s; a 4-frame stagger =
0.1333s. Never author 0.35s or 0.45s at 30fps - they are 10.5 and 13.5 frames.

STEP 3 - AUTHOR THE EXTREME AS AN IMPULSE. Put the displaced pose on the
timeline with a zero-duration set at t, then start the settle at the same
position: tl.set(target, {extreme}, t); tl.to(target, {rest, duration: 0.4,
ease: power3.out}, t). Do not use a 1-frame tween to reach the extreme - the
sampler can catch it mid-rise and the impact reads half-strength.

STEP 4 - BIND THE SOUND. Place the hit so its loudest sample is at t: set
data-start = t - (transient offset inside the file), and trim pre-roll with
data-media-start. Never align the file's start.

STEP 5 - VERIFY AND CORRECT. Render, then step frames N-2..N+15. If the
extreme appears on N+1, subtract one frame time from t and re-render; if on
N-1, add one. Repeat until the extreme, the sound's peak and the contact frame
are the same frame.

ACCEPTANCE TEST: exactly one frame shows the full extreme; the audio transient
sits within 1 frame of it and never more than 1 frame early; and if the render
fps changes, every quantised value has been recomputed against the new grid.
```

## Execution spec

**HyperFrames.** The engine's own words: *"All authored time is in SECONDS. There is no frame-based data attribute."* Everything below is the discipline that makes that safe.

```js
const FPS = 30, F = 1 / FPS;                 // pin this to the render's --fps
const q = (t) => Math.round(t * FPS) / FPS;  // quantiser
const IMPACT = q(181 / FPS);                 // frame 181 -> 6.0333…s

// impulse, then settle. 12 frames @30 = 0.4s exactly.
tl.set("#camera", { x: 18, y: -12, rotation: 0.8 }, IMPACT);
tl.to ("#camera", { x: 0, y: 0, rotation: 0, duration: 12 * F, ease: "power3.out" }, IMPACT);

// a graphic that slams to rest on the same frame: anticipation ENDS on IMPACT
tl.fromTo("#title", { scale: 1.18, autoAlpha: 0 },
  { scale: 1.0, autoAlpha: 1, duration: 6 * F, ease: "expo.out" }, IMPACT - 6 * F);
```

```html
<!-- hit: file transient measured at 0.043s in, so data-start = IMPACT - 0.043 -->
<audio id="sfx-hit" src="assets/sfx/impact.wav" data-audio-group="sfx"
       data-start="5.9903" data-duration="2.0" data-media-start="0"
       data-track-index="12" data-volume="0.45"></audio>
```

Contract points that bind this:
- `data-fps` is only an *"optional frame rate hint"* — **CLI render flags override it** (`npx hyperframes render --fps 24|30|60`, default 30). Pin the value you author against and render with the same flag, or requantise.
- Only multiples of **1/6 s** sit on the 24, 30 and 60 grids at once; anything else is fps-specific. Treat a fps change as a re-authoring pass, not a flag change.
- The visibility window is half-open — `[start, start + duration)` — so a clip is hidden at exactly `start + duration`. An impact placed on a clip's last frame is never rendered. Keep impacts ≥2 frames inside the window.
- Two clips can be authored back to back (`b.start === a.start + a.duration`) with **no overlapping frame** — that is how a hard swap lands exactly on the contact frame.
- Relative timing (`data-start="shot-a - 0.5"`) resolves silently to 0 on any error, and **spaces around the operator are mandatory**. For frame-critical work prefer absolute numbers.
- `data-playback-rate` is a constant, normalized 0.1–5, with **no rate envelope** — a speed ramp into an impact must be pre-processed in ffmpeg before it enters the composition.
- Determinism: no wallclock, no `getBoundingClientRect()` at tween time; compute constants at setup.

**ffmpeg — find, verify, and pre-process.**

```bash
# 1. frame numbers + timestamps around the event
ffmpeg -i src.mp4 -vf "select='between(n,170,195)',showinfo" -vsync 0 -frame_pts 1 /tmp/f/%d.png
# 2. confirm source fps before converting frames to seconds
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate,avg_frame_rate,nb_frames src.mp4
# 3. audio side: find the transient's offset inside the SFX file
ffmpeg -i impact.wav -af "astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.Peak_level" -f null -
# 4. speed ramp into the impact must be baked (no rate envelope in the engine)
ffmpeg -i src.mp4 -filter_complex "[0:v]setpts='if(lt(T,6.0), 1.6*PTS, PTS)'[v]" -map "[v]" ramped.mp4
# 5. verification: step the render
ffmpeg -i render.mp4 -vf "select='between(n,179,196)',showinfo" -vsync 0 -frame_pts 1 /tmp/r/%d.png
```

**Epidemic Sound.** `SearchSoundEffects { query: { term: "hard impact hit punch" }, filter: { tagSlugs: { matchType: "ANY", values: ["designed--boom"] }, duration: { max: 4000 } } }`, then measure the downloaded file's peak offset (command 3 above) and back-time `data-start` by it.

**Remotion:** frames are the native unit — `const IMPACT = 181;` and `frame === IMPACT` for the impulse; the quantisation problem largely disappears, which is a useful cross-check when porting.

## Pairs with
[[sfx-peak-on-impact-frame]] · [[motion-camera-shake-impact]] · [[motion-sound-bound-motion-event]] · [[motion-whip-pan-transition]] · [[sfx-av-sync-binding-window]] · [[cut-on-action]] · [[pace-cut-on-the-beat]] · [[motion-waveform-playhead-scrub]]

## Failure modes
- **Authoring round seconds instead of frame multiples.** 0.35 s at 30 fps is 10.5 frames; the extreme lands on whichever side the sampler picks, and it changes between renders of different fps. Correction: quantise everything with `round(t*fps)/fps`.
- **Reaching the extreme with a short tween.** A 1–2 frame ramp can be sampled mid-rise, producing a half-strength impact. Correction: `tl.set` at the impact frame, settle afterwards.
- **Picking the frame after contact.** The most dramatic-looking frame is usually the recoil, one frame late; a hit placed there feels sluggish. Correction: the frame where blur collapses is the frame.
- **Audio early.** More detectable than late (+45 ms vs −125 ms). Correction: never more than 1 frame early; when unsure, be 1 frame late.
- **Changing fps after authoring.** Every impact silently slips by up to half a frame. Correction: requantise, then re-verify by stepping.
- **Impact on a clip boundary.** The half-open window means it never renders. Correction: 2+ frames of headroom.
- **Anticipation that overshoots past contact.** A wind-up still resolving after the impact frame destroys the sense of a hard stop. Correction: the anticipation ends **on** the impact frame.
- **Known gap:** the execution contract does not state the render sampler's phase (whether frame *n* is sampled at `n/fps` or at the frame centre), so the last frame of alignment must be established empirically with the verify-and-shift loop in step 5. Treat any note that claims sub-frame precision without that loop as unproven.
