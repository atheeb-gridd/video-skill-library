---
id: motion-graphic-match-alignment-transform
title: Landing a graphic match — the alignment transform, its tolerances and its budget
skill: motion
type: transition
family: match-cut
tags: [skill/motion, type/transition, family/match-cut, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:31"
    quote: "The three types of match cuts are: graphic, with visual elements matching;"
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:17"
    quote: "A match cut is a cut between two shots that match in action, shape, colour, framing or audio."
research_refs:
  - https://en.wikipedia.org/wiki/Match_cut
  - https://en.wikipedia.org/wiki/Image_scaling
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://gsap.com/docs/v3/Eases/
  - https://developer.mozilla.org/en-US/docs/Web/CSS/clip-path
difficulty: high
detectable_from: video
---

# Landing a graphic match — the alignment transform, its tolerances and its budget

## What it is
[[cut-graphic-match]] is the editorial decision: cut between two shots whose composition survives the cut while their content does not. This note is the **geometry** that makes it land, because a graphic match almost never arrives pre-aligned. Real footage gives you a circle at 62% of frame height in shot A and 48% in shot B, at different sizes and slightly different angles, and the cut between them reads as *nearly* a match — which is worse than not attempting it.

The fix is an **alignment transform**: a static scale, translation and (rarely) rotation applied to one or both shots so that the matched element's centroid, size and orientation coincide across the seam. It is a motion operation with a hard budget, because every unit of correction is either resolution you are spending or a reframe the viewer can detect as a reframe. This note gives the tolerances that define "matched", the budget that defines "affordable", and the animated variant (a shared-element morph) for when the two elements are close but not close enough to hard-cut.

## When to use it
- **Whenever a graphic match is planned.** Assume alignment work is required; the pre-aligned match is the exception.
- **Between two stills or two graphics you control** — a chart becoming another chart, a product becoming a logo, one screenshot's button becoming another's. Here the tolerances are achievable exactly and the match should be perfect.
- **Between a shot and a graphic** — a real circular object cutting to a circular UI element. The most reliable place to build a match, because half the pair is authored.
- **Between two pieces of found footage** only when both have resolution headroom (4K source into a 1080p delivery gives you 2× to spend).
- **As the animated variant** (morph, not cut) when the elements match in shape but sit too far apart in the frame for a hard cut: the registry names `morph` and `shared-element` as its **tier-A** transition types, and the animation rule library names `card-morph-anchor`.
- **Not** to force a match between shapes that are only loosely similar. A forced graphic match reads as a mistake, and the source's own framing — "the composition holds while the content changes" — is the test: if the composition does not hold, do not cut there.
- **Not** when the correction needed exceeds the budget below. Then it is a dissolve ([[motion-dissolve-opacity-curve]]) or a covered seam ([[cut-full-screen-transition]]), not a match.

## How to recognise it in a reference video
Extract the last frame of shot A and the first frame of shot B, at full resolution, and measure the matched element in both:

- **Centroid offset.** Distance between the element's centroid in A and in B, as a percentage of frame **diagonal**. **≤3% reads as a true match** (the eye never moves). 3–6% reads as intentional but slightly loose. Above ~8% the viewer's fixation has to travel and the match stops working.
- **Size delta.** `|size_B − size_A| / size_A` on the element's bounding box or dominant radius. **≤8% is invisible**; 8–15% reads as a deliberate scale change; above 20% the two shapes are not the same shape any more.
- **Orientation delta.** Dominant edge or axis angle. **≤5°** for an invisible match. A visible rotation across a graphic match is a stylistic choice, not a match.
- **Aspect / eccentricity delta.** A circle cutting to an ellipse at 1.3 eccentricity is not a graphic match; keep within ~15%.
- **Luma and colour of the matched element.** Continuity of the *shape* survives a big luma change; continuity of the *composition* does not. Mean luma delta above ~15% inside the element makes the cut visible even when the geometry is perfect.
- **Hold either side.** The matched framing should be stable for **≥6 frames before** the cut and **≥6 frames after**, so the eye can register the correspondence. A match reached for one frame and immediately abandoned is invisible in the wrong way.
- **Look for the correction itself.** Signs a transform was applied: an unusually tight crop on one side of the cut, edge softness on the reframed shot only, a subject sitting off the rule-of-thirds in a way the rest of the video never does, or a visible aspect stretch. A well-budgeted correction leaves none of these.
- **Motion state.** If either shape is moving, the vectors should agree within ±25° — a graphic match over mismatched motion becomes a movement mismatch ([[cut-movement-match]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `centroid_tolerance` | 3% of frame diagonal | 1–6% | The primary criterion. At 1920×1080 the diagonal is 2203 px, so 3% ≈ 66 px. |
| `size_tolerance` | 8% | 3–15% | Of the element's bounding dimension. |
| `orientation_tolerance` | 5° | 0–8° | Dominant axis. |
| `eccentricity_tolerance` | 15% | 5–20% | Shape ratio; guards against circle-to-oval. |
| `luma_tolerance` | 15% | 8–20% | Mean luma inside the element. |
| `hold_before` | 6 f (0.2 s) | 4–12 f | Frames the matched framing is stable before the cut. |
| `hold_after` | 6 f (0.2 s) | 4–12 f | And after. |
| `scale_correction_budget` | ≤1.15× | 1.0–1.15× (HD source) | Above 1.15 on a same-resolution source, upscaling softness becomes visible on hard edges. With 4K into 1080p the budget rises to ~2.0×. |
| `position_correction_budget` | ≤8% of frame width | 0–12% | Beyond this the reframe changes the shot's composition enough to notice. |
| `rotation_correction_budget` | ≤3° | 0–5° | Rotation needs overscan: `scale ≥ 1 + sin(θ)·(aspect+1)/2`. At 3° on 16:9 that is ≈1.08. |
| `overscan` | 1.06 | 1.03–1.12 | Base scale so no correction exposes an edge. |
| `correction_split` | 100% on one shot | 0–100% | Prefer correcting the *less important* shot, or the one with more resolution headroom. Splitting 50/50 halves each shot's visible reframe. |
| `morph_duration` | 0.45 s | 0.3–0.7 s | Animated variant. |
| `morph_ease` | `power3.inOut` | `power2.inOut`–`expo.inOut` | A shared element travelling wants symmetric ease; the eye is tracking it. |
| `sfx` | optional | — | A hard graphic match usually takes **no** sound; the whole point is that it is not perceived as an event. A morph takes a soft transient. |

## Reproduction prompt

```
Land the graphic match between shot A ({{A_SRC}}, out-point {{A_OUT}}) and
shot B ({{B_SRC}}, in-point {{B_IN}}), matching on the element {{ELEMENT}}
(e.g. "the circular clock face" / "the horizon line" / "the silhouette").

1. MEASURE BOTH SIDES. Extract A's last frame and B's first frame at full
   resolution. For {{ELEMENT}} in each, record: centroid (x, y) in pixels,
   bounding box (w, h), dominant axis angle, mean luma.

2. COMPUTE THE CORRECTION that maps B's element onto A's (or vice versa):
     scale    = A_size / B_size
     dx, dy   = A_centroid - (B_centroid * scale)
     rotation = A_angle - B_angle

3. CHECK THE BUDGET before applying anything:
     |scale|    must be <= 1.15 unless the corrected shot's source is at least
                2x the delivery width, in which case <= 2.0
     |dx|,|dy|  must be <= 8% of frame width
     |rotation| must be <= 3 degrees
   If any exceeds budget, SPLIT the correction across both shots (apply half of
   each, in opposite directions) and re-check. If it still exceeds budget, this
   is not a graphic match - abandon it and use a dissolve or a covered seam.

4. APPLY as a STATIC transform on the clip wrapper, not an animation: a
   zero-duration tl.set of scale, x, y and rotation, plus overscan base scale
   1.06 so no correction exposes an edge. Never tween these - a graphic match
   is a cut, and a moving correction is a different technique.

5. VERIFY THE TOLERANCES after correction:
     centroid offset    <= 3% of frame diagonal
     size delta         <= 8%
     orientation delta  <= 5 degrees
     mean luma delta    <= 15%
   If luma is out of tolerance, grade one side toward the other before
   accepting the cut.

6. HOLD. Ensure the matched framing is stable for at least 6 frames on each
   side of the cut. If either shot is still settling into the matched framing
   at the cut, move the cut.

7. ANIMATED VARIANT (only if centroid offset stays above 6% after correction
   and the shapes genuinely match): instead of cutting, overlap the two clips
   and tween the shared element from A's geometry to B's over 0.45s on
   power3.inOut, cross-fading the two backgrounds underneath it on the same
   position. This is a tier-A shared-element morph, not a registry transition.

8. SOUND: a hard graphic match takes NO sound effect. Its value is that it is
   not perceived as an event, and a whoosh on it announces the cut you spent
   the effort hiding. Sound the morph variant only, softly.

ACCEPTANCE TEST: build a 12-frame strip centred on the cut ({{CUT}}-6f ..
{{CUT}}+6f) and view it as an animation at 30fps and again frame by frame.
(1) The matched element's centre must not visibly move across the seam.
(2) Its size must not visibly change.
(3) No frame may show background at any edge from the correction.
(4) Show the strip to someone cold: they should describe a transformation, not
a cut. If they describe "the shot changed", the match failed.
(5) Confirm no reframed shot shows softness a neighbouring shot does not.
```

## Execution spec

**HyperFrames.** The alignment transform is a static `tl.set` on the clip wrapper. There is no crop primitive and no reframe attribute — crop is `clip-path` on the element (render-time, source untouched) and reframe is scale + translate.

```html
<video id="shot-a" class="clip" src="assets/a.mp4" muted playsinline
       data-start="30.0" data-duration="2.4" data-media-start="4.1" data-track-index="0"></video>
<video id="shot-b" class="clip" src="assets/b.mp4" muted playsinline
       data-start="shot-a" data-duration="3.0" data-media-start="11.6" data-track-index="1"></video>
```

```js
// correction that maps B's circle onto A's: scale 1.09, dx -38px, dy +21px
tl.set("#shot-b", { transformOrigin: "50% 50%", scale: 1.06 * 1.09, x: -38, y: 21 }, 0);
tl.set("#shot-a", { scale: 1.06 }, 0);   // matching overscan so neither side is softer
```

Contract points that bind this:
- **`data-start="shot-a"` means "start when shot-a ends"** and is the cleanest way to author a hard cut with no overlapping frame — the window is half-open, so `b.start === a.start + a.duration` produces exactly zero shared frames. **Spaces around any `+`/`−` offset are mandatory**; `"shot-a-0.5"` parses as an id and resolves silently to 0, and none of the four relative-timing failures are linted.
- **Trim into the source with `data-media-start` + `data-duration`.** Only cut a physical file when exporting outside the composition. Moving the cut point by one frame is a change to `data-media-start`, not a re-encode.
- **`transformOrigin` and the transform both live on the timeline**, never in CSS alongside a GSAP tween (`gsap_css_transform_conflict`, error — and a lint error switches off the layout and contrast audits, so `check` then reports `0 sample(s)` and looks clean while nothing ran).
- **`video_nested_in_timed_element` is an error:** time the wrapper *or* the video, not both. The example times the videos directly.
- **`data-track-index` is display only** — the 0/1 assignment above is readability, not layering. Real layering is `z-index`.
- **Videos are `muted` with a separate `<audio>` element** for their sound, per the project's key rule; every `<audio>` needs an `id` or it is never mixed (silent render).
- **Resolution headroom is real and unforgiving.** A 1.15 correction on a 1920-wide source in a 1920 frame samples 1.15× above native. If the delivery is 1080p and the source is 4K, render with `--resolution landscape` and the correction is free. `--resolution` supersamples via Chrome's `deviceScaleFactor`, the aspect must match the composition, and the scale must be an integer.
- **The morph variant is tier A.** `tier_a_types: ["morph", "shared-element"]` — the registry's five machine-ready transitions (`crossfade`, `blur-crossfade`, `push-slide`, `zoom-through`, `squeeze`) are all tier B, and the tier-A morph is explicitly exempt from the "2–3 transition types per video" budget. The animation rule library names `card-morph-anchor` and `scale-swap-transition` for this territory; those recipe files are not staged, so cite them and do not quote code.
- **Determinism:** compute the correction once at authoring time from measured frames. Never derive it from `getBoundingClientRect()` at tween time.

**ffmpeg — measuring and, if necessary, baking.**

```bash
# the two frames to measure
ffmpeg -ss 32.39 -i a.mp4 -frames:v 1 -q:v 1 /tmp/a_last.png
ffmpeg -ss 11.60 -i b.mp4 -frames:v 1 -q:v 1 /tmp/b_first.png

# bake a correction into a file only if the shot is leaving the pipeline:
# scale 1.09 about centre, then translate -38,+21, then crop back to frame
ffmpeg -i b.mp4 -vf "scale=iw*1.09:ih*1.09,crop=1920:1080:(iw-1920)/2+38:(ih-1080)/2-21,\
setsar=1" -c:v libx264 -crf 18 b_aligned.mp4
```
Note the crop offsets carry the opposite sign to the layer translate, because cropping moves the window, not the picture.

**Epidemic Sound.** Nothing for a hard match — it should be inaudible as an event. For the morph variant, a soft short air:
```
SearchSoundEffects { query: { term: "soft whoosh transition subtle short" },
                     filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--whoosh"] },
                               duration: { max: 1200 } } }
```
at −18 to −22 dB, transient on the morph's midpoint (`power3.inOut` peaks at ~50%).

**Remotion.** Same static correction expressed as a CSS transform string on the clip, with a `<Sequence>` boundary at the cut. Concept only.

## Pairs with
[[cut-graphic-match]] · [[cut-match-cut]] · [[cut-movement-match]] · [[cut-audio-match]] · [[motion-continuity-across-the-seam]] · [[cut-eye-trace-continuity]] · [[cut-outpoint-inpoint-alignment]] · [[motion-dissolve-opacity-curve]] · [[cut-full-screen-transition]] · [[motion-still-image-drift]] · [[cut-invisible-storytelling-doctrine]]

## Failure modes
- **Nearly matched.** A 10% centroid offset is the worst possible outcome: close enough that the viewer sees the intent, far enough that the eye has to move. Correction: hit ≤3%, or abandon the match.
- **Correction over budget.** Pushing a 1.4× scale onto a same-resolution source to force alignment makes one shot visibly softer than its neighbours, which is a continuity failure of its own. Correction: split the correction across both shots, use a higher-resolution source, or choose a different transition.
- **Aspect stretch.** Correcting size with independent x and y scale to make two shapes match distorts the whole frame. Correction: uniform scale only; if the shapes need different scales in x and y they are not the same shape.
- **Rotation without overscan.** A 3° correction on a full-frame shot exposes triangular corners. Correction: `scale ≥ 1 + sin(θ)·(aspect+1)/2`, ≈1.08 at 3° on 16:9.
- **No hold.** The match exists for one frame while both shots are moving through it. Correction: ≥6 frames of stable matched framing each side, or move the cut.
- **Sounding it.** A whoosh on a graphic match announces the very cut the technique exists to hide. Correction: leave it silent; sound only the morph variant.
- **Luma ignored.** Perfect geometry across a 40% luma step still reads as a cut. Correction: grade one side toward the other, or accept it as a stylistic hard cut rather than a match.
- **Match hunting.** Building matches wherever two shapes are vaguely similar produces a video full of near-misses. Correction: a graphic match is a structural device — one or two per video, on beats where the metaphor is real.
- **Known gap:** nothing in this stack detects shapes, centroids or edge orientations. There is no saliency, no tracking, no content-aware reframe — *"pan/Ken Burns is authored geometry, not automatic face tracking."* All six measurements are produced by an analysis pass on extracted frames and written into the design document as literal numbers.
