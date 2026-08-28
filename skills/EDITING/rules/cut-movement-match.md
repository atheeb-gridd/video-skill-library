---
id: cut-movement-match
title: Movement match — carry camera, character or object motion across the cut
skill: editing
type: cut
family: match-cut
tags: [skill/editing, type/cut, family/match-cut, engine/ffmpeg, engine/hyperframes, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:36"
    quote: "movement, with camera, character or object movement matching;"
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:17"
    quote: "The match cut is a cut that matches action, shape, colour, framing or even audio of two shots, seamlessly bringing the viewer into the next scene."
research_refs:
  - https://netflixtechblog.com/match-cutting-at-netflix-finding-cuts-with-smooth-visual-transitions-31c3fc14ae59
  - https://en.wikipedia.org/wiki/30-degree_rule
  - https://www.filmsupply.com/articles/cutting-on-action-editing/
  - https://ayosec.github.io/ffmpeg-filters-docs/8.0/Filters/Video/vidstabdetect.html
  - https://github.com/georgmartius/vid.stab/blob/master/README.md
difficulty: high
detectable_from: video
---

# Movement match — carry camera, character or object motion across the cut

## What it is
One of the three match-cut subtypes in the source taxonomy (graphic / **movement** / audio). The cut is placed so that a motion vector present at the last frame of shot A is continued by a motion vector at the first frame of shot B: a left-to-right pan continues into a left-to-right pan, a hand reaching down continues into a hand reaching down, an object travelling screen-left keeps travelling screen-left. What is matched is not the *content* but the **direction, speed, screen position and blur state of the movement**. Because the eye tracks motion before it identifies objects, a correctly matched vector makes two unrelated shots read as one continuous gesture.

## When to use it
Use it where you need to move the viewer between two shots that share an *action* but not a place, and you want the transition to be invisible rather than announced. Concretely: joining two takes of the same gesture from different angles; travelling from a demonstration to its result; passing from an establishing move into a detail; disguising a jump in time inside a continuous action. It requires footage that actually contains motion at both edit points — if either shot is static at the cut, this is not the technique, and you want a straight cut, a graphic match, or [[cut-on-action]] instead. Do not use it more than a handful of times per video: an invisible technique used repeatedly becomes visible.

## How to recognise it in a reference video
Detect candidates mechanically, then verify on frame pairs — scene detection finds *where*, your eyes classify *what*.

- **Two-frame test.** Extract the last frame of A and the first frame of B. Overlay them mentally: the dominant moving element should be at roughly the same screen position and travelling in roughly the same direction. If a viewer can draw one arrow across both frames, it is a movement match.
- **Angular continuity.** Motion-vector direction differs by **≤ 20°** in a clean match; **20–35°** is tolerable when the moving element is small in frame; **> 45°** reads as a clash, and **~180°** is a screen-direction reversal (a mistake, not a style).
- **Velocity continuity.** On-screen speed within **±25%** across the cut reads as continuous. **±25–40%** is noticeable. **> 50%** reads as a speed jump and the illusion collapses.
- **Position continuity.** The moving element's centroid sits within **10–15% of frame width** of where it was on the last frame of A.
- **Scale continuity.** The moving element's on-screen size within **±30%**.
- **Blur state matches.** Both edge frames carry motion blur, or neither does. A sharp frame butted against a smeared one is the commonest tell that a match was *attempted* and missed.
- **Cut position within the arc.** The cut lands **40–60% through** the movement — mid-gesture, never at the start or the completion. A cut on the completed movement is a different (slower, emphatic) technique.
- **No transition present.** A movement match is always a hard cut. If there is a dissolve or a whip-pan overlay, it is a transition doing the work, not a match.
- **Audio corroboration.** Usually a *continuous* bed or ambience across the cut with **no** SFX marking it — the point is that the cut is not announced. A whoosh on a movement match is a sign the editor did not trust it.
- **Inverting the 30-degree rule as a test.** The 30-degree rule says two shots of the same subject must differ by more than 30° of camera position or the cut reads as an unmotivated jump. A movement match deliberately wants the *motion* to differ by well under 30° while the *subject* changes. If both the subject and the vector are near-identical, you are looking at a jump cut, not a match.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `angular_tolerance` | 20° | 0–35° | Measured between dominant motion vectors at the two edge frames |
| `velocity_tolerance` | ±25% | ±10–40% | On-screen px/frame of the tracked element |
| `centroid_tolerance` | 12% of frame width | 5–15% | 230 px at 1920 wide |
| `scale_tolerance` | ±30% | ±10–40% | On-screen size of the moving element |
| `arc_position` | 50% | 40–60% | Where in the movement the cut falls |
| `min_motion_speed` | 2% frame width/frame | 1–20% | 38 px/frame at 1920. Below this there is not enough motion to match |
| `whip_pan_speed` | 15% frame width/frame | 10–30% | Threshold above which both frames blur and tolerances triple |
| `handle_frames` | 6 f (0.2 s) | 4–12 f | Extra source either side, kept for re-timing the cut point |
| `search_window` | ±8 f (±0.27 s) | ±4–15 f | How far to slide the cut while hunting the best match |
| `blur_streak_assist` | 0 f | 0–3 f | Optional 2–3 frame directional streak to bridge a near-miss |
| `matches_per_video` | 2 | 1–5 | An invisible device used often stops being invisible |

## Reproduction prompt

```
Build a movement match cut between shot A and shot B at 30fps.

1. Probe real fps first (`ffprobe -select_streams v:0 -show_entries stream=r_frame_rate`) and
   rescale every number below if it is not 30.

2. Name ONE tracked element per shot (camera pan, a limb, or one object) and measure its motion.
   Camera: `ffmpeg -i A.mp4 -vf vidstabdetect=shakiness=10:accuracy=15:result=A.trf -f null -`
   and read per-frame relative translation/rotation. Object: extract frames around the candidate
   (`select='between(n,{{A_N}}-8,{{A_N}}+8)'`) and measure the centroid in pixels. Record
   direction in degrees and speed in px/frame for both shots.

3. Place the cut so ALL six hold at the boundary (A out frame -> B in frame):
   direction differs <=20 deg; speed differs <=25%; centroid differs <=12% of frame width
   (230 px at 1920); on-screen size differs <=30%; both frames carry motion blur or neither does;
   the cut sits 40-60% through the movement in BOTH shots - never at rest, never on completion.
   Slide the cut +/-8 f on each side until all six pass. Log A_out = {{A_N}}, B_in = {{B_N}}.

4. Cut it HARD. No dissolve, no transition, no SFX on the cut. Keep the bed or ambience running
   continuous across the boundary.

5. If direction passes but the boundary still flickers, add a 2-3 frame directional motion-blur
   streak on the shared vector and nothing more. A whip-pan transition is a different technique.

Acceptance test: at 1x a first-time viewer cannot say which frame the cut is on; frame-stepping
shows the element continuing along the same line with no jump over 12% of frame width and no
visible change in blur.
```

## Execution spec

**ffmpeg — measurement (this is the part that makes the note usable unattended):**

```bash
# 1. cut candidates
ffmpeg -i ref.mp4 -vf "select='gt(scene,0.3)',showinfo" -vsync vfr -f null - 2>&1 | grep showinfo

# 2. global (camera) motion, per frame, as relative translation + rotation
ffmpeg -i shotA.mp4 -vf vidstabdetect=shakiness=10:accuracy=15:stepsize=6:result=A.trf -f null -
head -5 A.trf     # confirm the field layout of your build before parsing it programmatically

# 3. visual sanity check of block motion vectors
ffmpeg -flags2 +export_mvs -i shotA.mp4 -vf codecview=mv=pf+bf+bb A_mv.mp4

# 4. edge frames for the two-frame test
ffmpeg -i shotA.mp4 -vf "select='eq(n\,412)'" -vsync 0 A_out.png
ffmpeg -i shotB.mp4 -vf "select='eq(n\,88)'"  -vsync 0 B_in.png
```

`vidstabdetect` is documented as pass 1 of the vid.stab deshake pair and writes a file of *relative translation and rotation transforms between subsequent frames* — which is exactly a per-frame camera motion vector. Object motion is not covered by it; use the frame-pair centroid measurement for that. Netflix's own match-cut pipeline uses temporally-averaged optical flow plus cosine similarity for motion matching, and reports that background pixels dominate — which is why camera-motion matches surface far more readily than limb matches, and why you should track a *named element*, not the whole frame.

**HyperFrames — assembly.** A movement match is two clips butted together with no transition. There is no frame attribute, so convert: **`seconds = (frame + 0.5) / fps`** — the half-frame offset puts the value at the centre of the intended frame and stops a rounding error from selecting its neighbour.

```html
<!-- A out at source frame 412, B in at source frame 88, cut at composition t = 8.0s -->
<video id="shot-a" src="assets/shotA.mp4"
       data-start="4.0" data-duration="4.0" data-media-start="9.7500"
       data-track-index="0" muted playsinline style="z-index:0"></video>
<video id="shot-b" src="assets/shotB.mp4"
       data-start="shot-a" data-duration="3.5" data-media-start="2.9500"
       data-track-index="1" muted playsinline style="z-index:0"></video>
```

- `data-start="shot-a"` means "start when shot-a ends" — spaces around any `+`/`-` offset are **required**, and an unresolved or duration-less reference resolves silently to `0`. Snapshot the boundary and confirm it actually starts where you meant.
- Clips can be authored back to back with no overlapping frame because the visibility window is half-open `[start, start+duration)`.
- Put the two clips on **different** `data-track-index` values by convention only; layering is CSS `z-index`.
- Videos are `muted` with a separate `<audio>` element for sound, per the project's key rule. For a movement match, keep **one continuous** `<audio>` bed spanning the boundary rather than two.
- The optional blur streak is a GSAP tween on the incoming wrapper — `filter: "blur(6px)" → "blur(0px)"` over 0.1 s (3 f) — and `filter` is lint-clean on the master timeline.
- No transition from the registry applies here. If you find yourself reaching for `zoom-through` or a whip pan, you are replacing the match, not assisting it.

**Epidemic Sound**: none by default. The absence of an SFX is part of the technique. If the shared movement is diegetic (a whoosh of a real arm, a door), source the *diegetic* sound and let it run continuous across the cut rather than accenting the cut.

**Remotion**: two `<Sequence>`s with frame-exact `from`/`durationInFrames` and no transition component; Remotion's native frame model makes the frame arithmetic easier but it is not part of this stack.

## Pairs with
[[cut-graphic-match]] · [[cut-on-action]] · [[cut-audio-match]] · [[pace-overlay-instead-of-cut]] · [[pace-cut-on-the-beat]] · [[struct-stimulation-budget]] · [[sfx-whoosh-transition-movement-reveal]] (the sound you must *not* put on this cut) · [[cut-match-cut]] · [[motion-filmstrip-comparison-strip]]

## Failure modes
- **Matching content instead of vector.** Two shots of a hand doing different things at different speeds is not a match. Correction: measure direction and speed; if they miss tolerance, use a straight cut and stop pretending.
- **Reversing screen direction.** Left-to-right cut to right-to-left reads as the action undoing itself. Correction: mirror-flip the incoming shot only if no text, no faces and no handedness give it away; otherwise re-pick the shot.
- **Cutting on the completed movement.** The vector is zero at completion, so there is nothing to carry. Correction: move the cut back to 40–60% of the arc.
- **Blur mismatch.** A crisp frame against a smeared one. Correction: pick edge frames with comparable blur, or add a 2–3 frame directional streak to the sharper side — never more than 3 frames, or it becomes a transition.
- **Putting a whoosh on it.** Announces the cut you spent effort hiding. Correction: silence at the cut; keep the bed continuous.
- **Rounding the frame conversion.** `412/30 = 13.7333…` truncated to `13.73` can land on frame 411. Correction: use `(frame + 0.5) / fps` and at least four decimals.
- **`--copy` on the ffmpeg trim.** Stream copy snaps to keyframes and can move your carefully chosen frame by many frames, or swallow the cut entirely. Correction: re-encode for frame-accurate cuts; if you must use `--copy`, read the script's `copy_drift` report.
- **Overuse.** Four movement matches in ninety seconds reads as a showreel. Correction: cap at 2 per video by default.
- **Known gap:** this stack has no automatic optical-flow readout and no face/object tracker. Motion measurement is either `vidstabdetect` (camera only) or a manual centroid read off extracted frames. Budget for that.
