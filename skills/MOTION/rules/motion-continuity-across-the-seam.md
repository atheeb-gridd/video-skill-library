---
id: motion-continuity-across-the-seam
title: Motion continuity — never let animation restart, stop or reverse at a boundary
skill: motion
type: motion
family: continuity
tags: [skill/motion, type/motion, family/continuity, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:37"
    quote: "If you can create a seamless flow of images, there are no rough edges, no spots where distractions can creep in. There's no point where the viewer loses immersion. The goal of this pillar is for every moment to flow seamlessly into the next. The editing should be invisible, the experience captivating."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:31"
    quote: "Pillar number three is visual continuity."
research_refs:
  - https://en.wikipedia.org/wiki/Match_cut
  - https://gsap.com/docs/v3/Eases/
  - https://en.wikipedia.org/wiki/Motion_blur
  - https://en.wikipedia.org/wiki/Shutter_speed
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: high
detectable_from: video
---

# Motion continuity — never let animation restart, stop or reverse at a boundary

## What it is
Pillar 3 read as a motion problem rather than a picture problem. [[cut-continuity-pass]] audits the *image* across every join — angle, screen direction, scale, luma, colour, framing, room tone. This note audits the *motion state* across the same joins, and it catches a different class of rough edge: animation that **stops** at a boundary and restarts on the other side, transform state that **jumps** because an element re-entered instead of persisting, velocity that **reverses** across a cut, and dead first frames where the incoming scene sits still for a beat before anything moves.

The stack encodes one half of this as a hard rule already: **exit animations are banned except on the final scene** — *"the transition IS the exit"*, and outgoing content must be fully visible when the transition starts. That rule exists precisely because an exit animation is a motion stop: the outgoing scene decelerates to nothing, and the seam becomes a visible full stop rather than a handoff. This note generalises the rule into a checkable pass over every adjacent pair in the timeline.

## When to use it
- **Once, as a pass, after cuts and motion are both placed** — the same position in the pipeline as the picture-side continuity pass, run against the same adjacency list.
- **Whenever an element appears in two consecutive scenes** — a logo, a counter, a persistent lower third, a progress bar, a background gradient. Every one of these is a shared-element candidate and a jump risk.
- **Whenever a transition is inserted.** The transition's own motion has to agree with the motion already running in both scenes.
- **On any montage or B-roll run** where each clip carries a drift: consecutive drifts that reverse direction produce a visible rock at every cut.
- **Not** as a licence to smooth everything. A deliberate discontinuity — a smash cut, a pattern-interrupt jolt, a hard silence — is a designed rough edge and is exempt ([[pace-deliberate-continuity-break]], [[motion-pattern-interrupt-jolt]]).

## How to recognise it in a reference video
Work the adjacency list. For each cut at time `T`, extract `T−10f` … `T+10f` at 30fps and measure:

- **Velocity across the seam.** Estimate the dominant motion vector in the last 5 frames of the outgoing shot and the first 5 of the incoming. In continuous work the **directions agree within about ±25°** and the **magnitudes within about ±35%**. A reversal (angle difference >120°) is the loudest rough edge in the whole audit and is instantly visible even to a non-editor.
- **Dead frames after the cut.** Count frames from the cut to the first measurable change in the incoming shot. **0–2 frames is continuous; 6+ frames reads as a stall.** The commonest cause is a still that starts drifting only after its clip opens rather than arriving already in motion.
- **Motion stop before the cut.** Same measurement on the outgoing side: an animation that has fully settled more than ~10 frames before the cut leaves a static tail, which is the picture-side equivalent of a dropped sentence.
- **Transform jump on a persistent element.** If a logo, counter or lower third exists on both sides, measure its position/scale in `T−1f` and `T+1f`. Any delta above ~1% of frame dimension is a re-entry, not a persistence, and will be seen.
- **Re-entry animation on a persistent element.** If the element fades or slides in again on the incoming side, that is the classic template failure: the viewer sees the same object introduced twice.
- **Luma step.** Mean luma of the last outgoing frame vs the first incoming frame. A delta above roughly **12% of full range** makes the join announce itself, and is the exact condition the transition registry names for `blur-crossfade`: *"Default when the two scenes' `#root` backgrounds differ a lot — the blur masks the background-color clash a plain crossfade would expose."*
- **Motion blur consistency.** Real footage at a 180° shutter carries blur proportional to velocity (1/60 s exposure at 30fps). A graphic travelling 40 px/frame with zero blur cut against footage with blur reads as two different media. Log whether the reference blurs its fast graphics.
- **Transition-type inventory.** Count distinct transition types across the whole video. Professional practice as encoded in this stack is **2–3 types repeated**; a video using eight different transitions is signalling the opposite of continuity.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `vector_angle_tolerance` | ±25° | ±15–40° | Between outgoing and incoming dominant motion vectors. |
| `vector_magnitude_tolerance` | ±35% | ±20–50% | Speed match. Beyond this the cut reads as a speed change. |
| `reversal_threshold` | 120° | 90–150° | Angle difference above which the seam reads as a bounce. Never ship one unintentionally. |
| `dead_frames_after_cut` | ≤2 f | 0–4 f | Frames between the cut and the first measurable change in the incoming scene. |
| `static_tail_before_cut` | ≤8 f | 0–12 f | Frames of fully settled stillness before the cut. |
| `persistent_element_jump` | 0 % | ≤1% of frame dim | Any persistent overlay's positional delta across the seam. |
| `luma_step` | ≤12% | 8–18% | Above this, cover the seam rather than cutting. |
| `exit_animations` | banned | — | Except on the final scene. Hard rule; the transition is the exit. |
| `transition_types_per_video` | 2–3 | 2–4 | Repetition is what reads as professional. |
| `overlap_authoring` | extend + pull | — | Extend `#el-<from>` `data-duration` by the transition duration; pull `#el-<to>` `data-start` earlier by the same amount. |
| `covered_seam_duration` | 0.4–0.6 s | 0.15–2.0 s | Registry `max_duration_s` is 2.0. Calm 0.5–0.8, medium 0.3–0.5, high 0.15–0.3. |
| `motion_blur_threshold` | 12 px/frame | 8–20 px/frame | Above this per-frame displacement on a graphic cut against footage, add a streak or the media mismatch shows. At 30fps a 180° shutter is a 1/60 s exposure. |
| `drift_direction_alternation` | alternate | — | Consecutive drifting stills should not all zoom the same way *or* strictly alternate; both patterns become visible. Vary within the rate band. |

## Reproduction prompt

```
Run the motion-continuity pass over {{COMPOSITION}}.

1. BUILD THE ADJACENCY LIST. From the composition's clips, produce every
   ordered pair (A, B) where B.data-start <= A.data-start + A.data-duration and
   they occupy the same visual layer. Record the seam time T for each.

2. FOR EACH SEAM, measure six things by rendering or snapshotting T-10f
   through T+10f at 30fps:
     a. dominant motion vector in A's last 5 frames and B's first 5
     b. frames from T until B first changes         (target <= 2)
     c. frames of settled stillness in A before T   (target <= 8)
     d. mean luma of A's last frame and B's first   (target delta <= 12%)
     e. position/scale of every element present on BOTH sides (target 0 jump)
     f. whether A runs any exit animation at all    (target: none)

3. CLASSIFY EACH FAILURE and apply the matching fix:
     REVERSAL (angle delta > 120 deg)  -> reorder the clips, mirror one shot,
        or cover the seam with a transition travelling in A's direction.
     STALL (dead frames >= 6)          -> start B's ambient motion BEFORE its
        clip opens, so B is already moving on its first visible frame. Author
        the tween from a position earlier than B's data-start; the clip window
        clips the picture, the timeline keeps running.
     STATIC TAIL (>= 12f)              -> extend A's motion to end at
        A.data-duration - 0.05, or trim A.
     LUMA STEP (> 12%)                 -> replace the hard cut with
        blur-crossfade, 0.6s, per the registry's own note about clashing
        backgrounds.
     JUMP ON A PERSISTENT ELEMENT      -> hoist that element out of both
        scenes to the host root so it is ONE element with ONE continuous
        timeline, spanning both. Do not animate it in twice.
     EXIT ANIMATION FOUND              -> delete it. Outgoing content must be
        fully visible when the transition starts. The only legal exit is on
        the final scene.

4. AFTER FIXES, re-measure. Do not accept a fix on inspection alone: a fix
   applied in a sub-composition can silently resolve its timing to 0.

5. GLOBAL CHECKS: count distinct transition types (target 2-3, repeated);
   confirm no drift-direction pattern is visible across any run of 4+ stills;
   confirm the longest gap with no motion event anywhere on screen is under
   the value the style profile records.

ACCEPTANCE TEST: produce a table of every seam with its six measurements and a
PASS/FAIL per column. Ship at zero unexplained FAILs. Every remaining FAIL must
be annotated as a deliberate discontinuity with the beat it serves named.
```

## Execution spec

**HyperFrames.** Three contract facts do most of the work here.

**1. Overlap is authored in the timing attributes, not in a transition object.** The injector's own procedure: extend `#el-<from>`'s `data-duration` by the transition duration so it holds its final frame, pull `#el-<to>`'s `data-start` earlier by the same amount, ping-pong the `data-track-index` values so the overlapping wrappers do not share a lane (a readability convention — real layering is `z-index`), and stamp the tween pair onto the master timeline at the overlap start.

```js
// the correct shape: outgoing and incoming animate AT THE SAME TIME T
const T = 12.0;
tl.to("#el-s1",    { yPercent: -100, filter: "blur(8px)", duration: 0.5, ease: "power3.in" }, T);
tl.fromTo("#el-s2",{ yPercent: 100 }, { yPercent: 0,       duration: 0.5, ease: "power3.out" }, T);
```
```js
// the banned shape: a jump cut with a dip, not a transition
tl.to("#s1", { opacity: 0, duration: 0.4 }, 4.0);
tl.from("#s2 .headline", { y: 40, opacity: 0 }, 4.4);
```

**2. A stall is fixed by starting the tween before the clip opens.** The clip's half-open window `[start, start+duration)` governs *visibility*; the timeline keeps running regardless. Position an ambient tween 0.3–0.5 s earlier than the clip's `data-start` and the scene is already in motion on its first visible frame.

```js
// clip opens at 20.0; drift starts at 19.6 so frame 1 is already moving
tl.fromTo("#still-b", { scale: 1.0 }, { scale: 1.07, duration: 4.4, ease: "none" }, 19.6);
```

**3. A persistent element must be one element, at the host root.** A sub-composition timeline **cannot animate host-root elements** — a global selector or `document.querySelector` does not resolve across the boundary. So a lower third or counter that must survive a scene cut is either (a) placed as a host-root sibling and driven on the main timeline at *global* time = scene-local time + the slot's `data-start`, or (b) the several beats are collapsed into **one** sub-composition with internal `.phase` divs. Duplicating it into both scenes guarantees the jump this note is trying to prevent.

Other binding points:
- **Relative timing has four silent zero-failures**, none linted: spaces around the operator are mandatory (`"intro-0.5"` parses as an id), an unresolved reference resolves to 0, a target with no resolvable duration lands you on its **start** not its end, and a cycle resolves to 0. Lookup is document-wide, so a reference can reach into another composition on the assembled page. **Snapshot and verify** rather than trusting a reference-timed seam.
- **`snapshot --at <midpoints>` is required** for projects with sub-compositions and is the only real defence against those silent zeros — but it is browser-dependent, and this authoring VM is linux ARM64 without sudo, so the snapshot leg runs elsewhere.
- **`blur-crossfade` (0.6 s, tier B, calm)** is the registry's named answer to a luma/background clash; `crossfade` is 0.5 s; `push-slide` 0.5 s with LEFT/RIGHT/UP/DOWN; `zoom-through` 0.4 s high-energy; `squeeze` 0.4 s. `max_duration_s` is 2.0. `filter`, `scaleX` and `transformOrigin` are lint-clean on the master timeline.
- **Every scene uses entrance animations, via `gsap.fromTo()`** — `from()` animates *to* current CSS, so pairing it with a CSS `opacity: 0` is a 0→0 noop.
- **Ambient motion must attach to the seekable `tl`**, never a bare `gsap.to()`; standalone tweens run on wallclock and are simply absent from the render — which looks exactly like a stall.
- **`animation-map.mjs`** (`node skills/hyperframes-animation/scripts/animation-map.mjs <dir> --out <dir>/.hyperframes/anim-map`) reads every registered timeline, enumerates tweens and samples bounding boxes — it is the natural machine input for steps 2e and 2f above. It needs a live browser, so it runs off-VM.

**ffmpeg — measuring the seam without a browser.** The picture-side measurements can be taken from a rendered file:

```bash
# frames around a seam at t=12.0
ffmpeg -ss 11.66 -i out.mp4 -t 0.66 -vf fps=30 /tmp/seam/%03d.png
# mean luma per frame, for the luma-step test
ffmpeg -ss 11.66 -i out.mp4 -t 0.66 -vf "fps=30,signalstats,metadata=print:key=lavfi.signalstats.YAVG" -f null -
# scene-change score across the whole file, to find seams automatically
ffmpeg -i out.mp4 -vf "select='gt(scene,0.2)',metadata=print" -f null -
```

**Epidemic Sound.** Continuity has an audio half that belongs to the sound library: a room tone or ambience bed carried *across* the seam is the cheapest continuity device in the whole video ([[sfx-ambience-bridge-across-cut]]). Nothing to fetch for the motion pass itself.

**Remotion.** A `<Sequence>`-based composition has the same failure: `from` on a sequence resets local frame to 0. The equivalent fix is hoisting shared elements above the sequence boundary. Concept only.

## Pairs with
[[cut-continuity-pass]] · [[cut-invisible-storytelling-doctrine]] · [[motion-graphic-match-alignment-transform]] · [[motion-dissolve-opacity-curve]] · [[cut-movement-match]] · [[cut-on-action]] · [[cut-eye-trace-continuity]] · [[motion-still-image-drift]] · [[motion-overlay-stack-choreography]] · [[motion-persistent-item-counter]] · [[sfx-ambience-bridge-across-cut]] · [[pace-deliberate-continuity-break]] · [[motion-whip-pan-transition]]

## Failure modes
- **Exit animations.** The single most common motion-continuity failure and the one the stack bans outright: the outgoing scene fades or slides away, then the incoming one animates in, producing a visible dip in the middle. Correction: delete the exit; both scenes animate at the same time `T`.
- **Stall on the incoming frame.** The new scene's first 8 frames are motionless while the eye waits. Correction: start the ambient tween before the clip's `data-start`.
- **Persistent element re-entering.** A counter that fades in again after every cut tells the viewer the video is assembled from parts. Correction: hoist it to the host root as one element.
- **Reversal.** Outgoing pans left, incoming pans right, and the seam bounces. Correction: reorder, mirror, or cover with a transition travelling in the outgoing direction.
- **Transition variety mistaken for craft.** Eight different transitions read as a template pack, not as continuity. Correction: 2–3 types repeated for the whole video.
- **Smoothing a deliberate break.** Applying this pass mechanically will sand off the smash cut and the pattern interrupt that the structure depends on. Correction: annotate deliberate discontinuities before the pass and exempt them.
- **Fixing a seam inside a sub-composition and never verifying it.** Relative timing fails to 0 silently and lint checks none of it. Correction: `snapshot --at` the seam and look.
- **Known gap:** nothing in this stack measures motion vectors, luma steps or transform jumps automatically. `check` covers lint, runtime, layout, motion and contrast, and `animation-map.mjs` enumerates tweens — but the six seam measurements above are an authored analysis, and both `check`'s browser-backed audits and `animation-map.mjs` require a browser this VM cannot run. Treat the measurement table as a deliverable produced on the render host, not on the authoring machine.
