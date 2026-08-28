---
id: motion-velocity-matched-transition
title: Velocity-matched handoff — measure the outgoing vector, then leave at the same speed
skill: motion
type: transition
family: match-cut
tags: [skill/motion, type/transition, family/match-cut, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:36"
    quote: "movement, with camera, character or object movement matching;"
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:17"
    quote: "The match cut is a cut that matches action, shape, colour, framing or even audio of two shots, seamlessly bringing the viewer into the next scene."
research_refs:
  - https://en.wikipedia.org/wiki/Optical_flow
  - https://docs.opencv.org/4.x/d4/dee/tutorial_optical_flow.html
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Twelve_basic_principles_of_animation
  - https://carbondesignsystem.com/elements/motion/overview/
difficulty: high
detectable_from: video
---

# Velocity-matched handoff — measure the outgoing vector, then leave at the same speed

## What it is
The motion-side half of the movement match. [[cut-movement-match]] owns the editorial move — placing a cut so a gesture in shot A is continued by a gesture in shot B — and [[motion-continuity-across-the-seam]] owns the audit that sweeps every seam for stops and reversals. This note owns the **arithmetic in between**: how to measure the motion already present in the footage as a vector in px/frame, and how to author the thing on the other side of the seam — another shot, a transition, or a graphic — so that it *leaves at the same speed and in the same direction*.

The reason it needs arithmetic is that an eased tween has no single speed. A `power3.out` slide covering 200 px in 0.4 s averages 500 px/s but **starts at 1500 px/s**, because the derivative of `1-(1-p)³` at p=0 is 3. Matching "the animation to the footage" without knowing that number is guesswork; with it, the handoff is a one-line calculation, and the seam disappears.

**Initial/terminal speed multipliers** — multiply average speed (`distance / duration`) by these to get the speed at the join:

| Ease | Speed at the **start** | Speed at the **end** |
|---|---|---|
| `none` (linear) | 1.0× | 1.0× |
| `sine.out` | 1.57× | 0 |
| `power2.out` | 2.0× | 0 |
| `power3.out` | 3.0× | 0 |
| `power4.out` | 4.0× | 0 |
| `expo.out` | ≈6.9× | ≈0 |
| `power2.in` | 0 | 2.0× |
| `power3.in` | 0 | 3.0× |
| `sine.inOut` / `power2.inOut` | 0 | 0 (peak 1.57×/2.0× at the midpoint) |

## When to use it
- **Whenever a cut, a transition or an element hands motion to something else** and you want the join to be invisible: a pan continuing into a pan, a hand reaching continuing into a hand reaching, a whip pan whose direction has to agree with the shot it leaves ([[motion-whip-pan-transition]]).
- **When a graphic enters over moving footage.** A card sliding right over a shot panning left is the single loudest unmotivated-motion fault in editorial motion graphics; matching the vector fixes it for free.
- **When choosing a transition's direction and duration.** `push-slide` takes `LEFT/RIGHT/UP/DOWN`: derive it from the measured vector rather than from habit.
- **When a montage of drifting stills cuts shot to shot** — consecutive Ken-Burns drifts that reverse direction rock the frame at every cut ([[motion-still-image-drift]], [[motion-dissolve-opacity-curve]]).
- **Not** where a designed discontinuity is the point: a smash cut, a pattern-interrupt jolt, a hard reset on new information ([[pace-deliberate-continuity-break]], [[motion-pattern-interrupt-jolt]]).
- **Not** on static footage. If neither side carries measurable motion there is nothing to match, and a straight cut is the correct move.

## How to recognise it in a reference video
- **Measure the vector on both sides.** Take the last 5 frames of the outgoing and the first 5 of the incoming. Dense optical flow (Farnebäck, `cv.calcOpticalFlowFarneback`) or the codec's own motion vectors give a per-pixel field; the dominant vector is the modal direction weighted by magnitude. Report it as **degrees and px/frame**.
- **Angle agreement.** **≤20°** reads as one motion. 20–35° is tolerable when the moving element is small. **>45°** clashes; **~180°** is a reversal, the loudest fault in the whole audit.
- **Speed agreement.** Within **±25 %** reads as continuous, 25–40 % is noticeable, **>50 %** reads as a speed jump.
- **Compare the graphic against the plate.** For an element animating over footage, convert its authored travel to px/frame at the join (`distance / duration / fps × ease multiplier`) and compare with the plate's flow. A 1500 px/s title over a 200 px/s pan is four sides of a stylistic argument the viewer can feel.
- **Dead frames.** Count frames from the seam to the first measurable change on the incoming side. **0–2 frames is continuous; 6+ reads as a stall.**
- **Blur agreement.** Both edge frames blurred, or neither. A crisp graphic travelling 40 px/frame over motion-blurred footage reads as two different media.
- **Whip band.** Above roughly **15 % of frame width per frame** neither side is resolvable, tolerances triple, and what you are looking at is a covered cut, not a match.
- **Audio tell.** A true movement match usually has **no** SFX on the seam — the ambience or bed simply continues. A whoosh on a movement match is a sign the editor did not trust it ([[sfx-ambience-bridge-across-cut]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `angle_tolerance` | 20° | 0–35° | Between dominant vectors at the two edge frames. |
| `speed_tolerance` | ±25 % | ±10–40 % | On-screen px/frame. |
| `join_speed_formula` | `distance / duration × multiplier` | — | Multiplier from the table above. Report in px/s, compare in px/frame at the render fps. |
| `min_measurable_motion` | 2 % frame width/frame (38 px @1920) | 1–20 % | Below this there is nothing to match. |
| `whip_threshold` | 15 % frame width/frame | 10–30 % | Above it, cover the seam instead of matching it. |
| `dead_frames_after` | 0 f | 0–2 f | The incoming must already be moving. |
| `graphic_entry_speed` | match the plate ±25 % | — | Solve for `distance` or `duration` — do not change the ease to fix speed. |
| `transition_direction` | from the measured vector | — | `push-slide LEFT/RIGHT/UP/DOWN`; the outgoing travels *with* the vector. |
| `transition_duration` | 0.5 s | 0.15–0.3 s high energy · 0.3–0.5 s medium · **max 2.0 s** | Registry defaults; `max_duration_s: 2.0` is a hard registry limit. |
| `flow_window` | 5 f each side | 3–8 f | Frames sampled for the vector estimate. |
| `search_window` | ±8 f | ±4–15 f | How far to slide the seam while hunting the best match. |
| `blur_assist` | 0 f | 0–3 f | A 2–3 frame directional streak bridges a near-miss ([[motion-travel-reveal-streak]]). |

## Reproduction prompt

```
Make the handoff at {{T}} seconds velocity-matched.

1. MEASURE THE OUTGOING VECTOR. Export the 5 frames before {{T}}:
     ffmpeg -ss {{T-0.2}} -i {{SOURCE}} -t 0.2 -vf fps=30 /tmp/a/%03d.png
   Compute dense optical flow between consecutive pairs (Farneback) and report
   the dominant motion as ANGLE (degrees, 0 = screen-right) and SPEED
   (px/frame at the composition width). If SPEED < 2% of frame width per
   frame, stop: there is nothing to match, use a straight cut.

2. MEASURE OR AUTHOR THE INCOMING.
   a) Shot-to-shot: measure the first 5 frames of the incoming the same way.
      Accept if |dAngle| <= 20 deg and |dSpeed| <= 25%. Otherwise slide the cut
      within +/-8 frames and re-measure; if still failing, do not force it.
   b) Transition: set push-slide direction to the measured angle rounded to
      the nearest of LEFT/RIGHT/UP/DOWN and duration 0.3-0.5s (0.15-0.3s if
      the vector is above 10% frame width/frame).
   c) Graphic over footage: choose the ease first, then solve for geometry.
      join_speed = distance / duration * multiplier
        (linear 1.0, sine.out 1.57, power2.out 2.0, power3.out 3.0,
         power4.out 4.0, expo.out 6.9)
      Set join_speed to the measured plate speed in px/s (px/frame x fps),
      within 25%, by changing DISTANCE or DURATION — never by swapping to a
      flatter ease, which changes the character of the move.
      Travel in the SAME direction as the plate, never against it.

3. NO DEAD FRAMES. The incoming must already be in motion on its first frame:
   start ambient motion before the clip opens, or begin the tween at the
   clip's data-start exactly.

4. SOUND: leave the seam unsounded and let ambience or the bed run through it.
   Add a whoosh only if the vector exceeds the whip threshold.

ACCEPTANCE TEST: re-measure flow across {{T}}-5f to {{T}}+5f. Angle delta
<= 20 deg, speed delta <= 25%, zero reversal, 0-2 dead frames, and no
frame where a sharp graphic sits over motion-blurred plate.
```

## Execution spec

**HyperFrames.** There is no motion-analysis primitive in the stack — the vector is measured **outside**, and the number is carried into the composition by hand.

```js
// Plate pans screen-right at 9 px/frame @30fps = 270 px/s at 1920 wide.
// A title entering from the left with power3.out must leave at ~270 px/s:
//   270 = distance / duration * 3   ->  distance = 90 * duration
//   duration 0.40s  ->  distance 36px      (a nudge that matches the plate)
tl.fromTo("#title", { x: -36, autoAlpha: 0 },
  { x: 0, autoAlpha: 1, duration: 0.40, ease: "power3.out" }, 12.30);
```

```js
// Seam at T: push-slide LEFT because the plate is travelling screen-left.
const T = 18.0, DUR = 0.45;
tl.to("#el-shot-a", { xPercent: -100, duration: DUR, ease: "power3.in" }, T);
tl.fromTo("#el-shot-b", { xPercent: 100 }, { xPercent: 0, duration: DUR, ease: "power3.out" }, T);
```

Contract points:
- **Outgoing and incoming animate at the same position `T`.** Fading the outgoing out first and animating the incoming in afterwards is the banned jump-cut-with-a-dip pattern; *"the transition IS the exit."*
- The injector's shape for an overlap: extend the outgoing clip's `data-duration` by the transition length, pull the incoming clip's `data-start` **earlier** by the same amount, and ping-pong `data-track-index` so the two wrappers do not share a lane (a readability convention, not a render constraint — layering is `z-index`).
- Registry transitions available here: `crossfade`, `blur-crossfade`, `push-slide` (LEFT/RIGHT/UP/DOWN), `zoom-through`, `squeeze`. `max_duration_s: 2.0`.
- Transform aliases only (`x`, `y`, `xPercent`, `scale`, `rotation`); `filter` is legal on the master timeline.
- **Never derive positions from `getBoundingClientRect()` at tween time** — compute constants once at setup, and in a multi-scene montage do not measure at all.
- Relative timing (`data-start="shot-a - 0.45"`) creates the overlap, but the spaces around the operator are load-bearing: `"shot-a-0.45"` parses as an id and silently resolves to 0.

**ffmpeg — measuring the vector.**

```bash
# frames either side of the seam
ffmpeg -ss 17.83 -i a.mp4 -t 0.17 -vf fps=30 /tmp/a/%03d.png
ffmpeg -ss 18.00 -i b.mp4 -t 0.17 -vf fps=30 /tmp/b/%03d.png

# the codec's own motion vectors, drawn on the picture (quick visual read)
ffmpeg -flags2 +export_mvs -i a.mp4 -vf codecview=mv=pf+bf+bb -an /tmp/mv.mp4

# generate vectors where the source has none usable (e.g. all-I-frame or after a re-encode)
ffmpeg -i a.mp4 -vf "mestimate=epzs:mb_size=16:search_param=7,codecview=mv=pf" -an /tmp/mv2.mp4

# a quantitative read: dense flow with OpenCV
python3 -c "import cv2,numpy as np;print('cv.calcOpticalFlowFarneback -> per-pixel (u,v); take magnitude/angle via cv2.cartToPolar')"
```

`codecview` visualises only what the bitstream carries (`mv=pf|bf|bb`, `frame_type`), so it is a fast triage; `mestimate` (methods `esa|tss|tdls|ntss|fss|ds|hexbs|epzs|umh`, `mb_size` default 16, `search_param` default 7) computes vectors independently. For numbers you can put in a spec, use dense flow and report degrees + px/frame.

**Epidemic Sound.** Usually nothing — the match's whole value is that it is not announced. If the vector exceeds the whip threshold and the seam must be covered, `SearchSoundEffects { query: { term: "fast whoosh transition swish" }, filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--whoosh"] }, duration: { max: 2000 } } }`.

**Remotion.** `interpolate()` with an explicit `Easing`, and the same derivative arithmetic — the multiplier table above is a property of the curve, not of the runtime. Concept only.

## Pairs with
[[cut-movement-match]] · [[motion-continuity-across-the-seam]] · [[motion-whip-pan-transition]] · [[cut-on-action]] · [[cut-graphic-match]] · [[motion-still-image-drift]] · [[motion-dissolve-opacity-curve]] · [[motion-entrance-vocabulary]] · [[motion-travel-reveal-streak]] · [[sfx-ambience-bridge-across-cut]] · [[pace-deliberate-continuity-break]] · [[cut-eye-trace-continuity]]

## Failure modes
- **Matching direction but not speed.** Both sides travel screen-left, one at 4 px/frame and one at 18 px/frame; the viewer reads a speed jump even though the vectors agree. Correction: bring speeds inside ±25 % by sliding the cut or retiming the graphic.
- **Fixing speed by flattening the ease.** Swapping `power3.out` for `linear` to hit a number destroys the move's character. Correction: solve for distance or duration and keep the ease.
- **Averaging instead of taking the join speed.** Comparing a tween's average velocity with the plate's velocity is wrong by 2–7×. Correction: use the multiplier table.
- **A reversal.** The incoming travels back against the outgoing. This is the one fault every viewer sees. Correction: mirror the incoming, or pick a different shot.
- **Dead first frames.** The incoming sits still for 8 frames while the eye waits. Correction: start its motion before the clip opens.
- **A whoosh on a successful match.** Announces the seam you spent the effort hiding. Correction: leave it silent, run ambience through it.
- **Measuring on a re-encode.** Codec motion vectors from a heavily compressed proxy are unreliable. Correction: measure on the source, or use `mestimate`/dense flow.
- **Known gap — no in-composition motion analysis.** HyperFrames has no optical-flow or auto-sync primitive; every number here is measured externally and pasted in as a constant. Re-measure after any retime, because nothing will warn you that the constant is now stale.
