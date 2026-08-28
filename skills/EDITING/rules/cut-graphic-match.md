---
id: cut-graphic-match
title: Graphic match — cut between shots whose visual elements align
skill: editing
type: cut
family: match-cut
tags: [skill/editing, type/cut, family/match-cut, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:01:31
    quote: "The three types of match cuts are: graphic, with visual elements matching;"
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:01:17
    quote: "The match cut is a cut that matches action, shape, colour, framing or even audio of two shots, seamlessly bringing the viewer into the next scene."
research_refs:
  - https://www.studiobinder.com/blog/match-cuts-creative-transitions-examples/
  - https://en.wikipedia.org/wiki/Match_cut
  - https://fiveable.me/introduction-to-film-theory/key-terms/graphic-match-cuts
difficulty: high
detectable_from: video
---

# Graphic match — cut between shots whose visual elements align

## What it is
A hard cut between two shots whose **composition survives the cut** while their content does not: a circle to a circle, a horizon to a horizon, a silhouette to a silhouette, one dominant colour field to another. Because the eye's fixation point does not have to move, the cut is nearly invisible as a cut and reads instead as a transformation — which is why graphic matches carry metaphor almost automatically ("these two things are the same thing"). It is one of the three match-cut types the source names, alongside movement match and audio match.

## When to use it
At a boundary you want the viewer to cross *without* registering a break: a topic change you want to feel like a continuation, a time or place jump, or an argument where two things must be equated (the tool and the result, the problem's shape and the solution's shape). In explainer editing the highest-value use is the transition from a real-world object into its diagram — the object's silhouette becomes the graphic's shape. Do not use it as decoration between unrelated points; a graphic match with nothing to say is the most conspicuous kind of clever.

## How to recognise it in a reference video
- **Freeze the two frames either side.** This is the only reliable test:
  `ffmpeg -ss <t-0.034> -i ref.mp4 -frames:v 1 a.png; ffmpeg -ss <t> -i ref.mp4 -frames:v 1 b.png`
- Measure four things on the dominant subject in each frame and check the tolerances:
  - **Centroid offset** ≤5% of frame width and height (mismatch becomes visible above ~8%).
  - **Subject area ratio** within ±15% (bounding-box area of b ÷ a between 0.85 and 1.15).
  - **Dominant edge orientation** within ±8° (a horizon, a table edge, a limb axis).
  - **Mean hue of the dominant field** within ~20° for a colour-led match.
- **Scene detection will flag it, classification will not.** The `select='gt(scene,0.3)'` pass usually fires, because the *content* changed. Only frame inspection tells you the composition held.
- **Fixation test.** Look at the pair at speed. If your eye has to travel to find the new subject, it is not a graphic match — it is a cut that happens to be near one.
- **Check for correction.** A slight scale or position drift in the last 10 frames before the cut, or the first 10 after, means the editor nudged one shot into alignment with a transform. That is normal practice, and worth logging as a parameter.
- **Transcript correlation.** A real graphic match usually sits on a sentence boundary and often on a metaphor in the narration. If it lands mid-clause, suspect coincidence.
- **Distinguish from the neighbours:** a **movement match** aligns motion vectors and typically has motion blur on both sides; a **cut on action** aligns the phase of a gesture; an **audio match** carries a shared sound across. A graphic match can be static on both sides.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `centroid_tolerance` | 3% of frame | 0–5% (visible >8%) | Measured on the matched element's centre, both axes. House tolerance calibrated from practice, not a published standard. |
| `area_ratio_tolerance` | ±10% | ±5% to ±15% | Bounding-box area of the matched element. |
| `orientation_tolerance` | ±5° | 0–8° | For linear matches (horizon, edge, limb). |
| `hue_tolerance` | 15° | 0–25° | Colour-led matches only. |
| `max_corrective_scale` | 8% | 0–12% | Transform applied to force the match. Above 12% the reframe is visible as a crop change. |
| `max_corrective_position` | 3% of frame | 0–4% | Same limit logic. |
| `cut_type` | hard cut, 0f | 0f, or 6–12f dissolve | A dissolve makes the match explicit and slower; use it when time has passed. |
| `pre_hold` | 12f (0.4s) | 8–20f | Frames of stillness before the cut so the eye locks onto the shape. |
| `post_hold` | 15f (0.5s) | 10–24f | Frames after, before any new motion starts. The match needs a beat to land. |
| `sfx` | none or soft whoosh | — | A whoosh sells it; a hit oversells it. See `sfx_offset` in [[sfx-whoosh-transition-movement-reveal]]. |

## Reproduction prompt

```
Build a graphic match cut at the section boundary {{CUT}}.

1. Choose the matched element. Name it explicitly in the design doc (e.g.
   "the coffee cup rim in shot A matches the record label in shot B"). If
   you cannot name it in one clause, you do not have a graphic match.
2. Extract the last frame of shot A ({{CUT}}-1) and the first frame of shot
   B ({{CUT}}) as PNGs and measure, on the matched element in each:
   centroid as % of frame width/height, bounding-box area, and dominant
   edge angle.
3. Correct the SMALLER offender only, using a static transform on ONE of
   the two shots: scale within 8% and translate within 3% of frame. Set
   transform-origin on the matched element's centroid, not frame centre. If
   correction beyond scale 12% / position 4% is required, reject the pair
   and pick different shots.
4. Give the cut room: hold shot A still for 12 frames before {{CUT}} (no
   camera move, no punch-in, no overlay animating) and hold shot B still for
   15 frames after. Start any new motion only after that.
5. Cut hard at {{CUT}} - 0 frames of dissolve - unless narrative time has
   passed, in which case use a 9-frame dissolve.
6. Optional: one soft whoosh, transient 2 frames before {{CUT}}, at -15 dB
   relative to dialogue. No impact hit.
7. ACCEPTANCE TEST: play the 1 second either side at full speed three times.
   Your eye must not travel at the cut. Then step frame by frame: the
   matched element's centre must move <=3% of frame width and its area must
   change <=10%. If a viewer would describe it as "a cool transition"
   rather than not noticing it, the correction was too aggressive or the
   holds were too short.
```

## Execution spec

**Measurement (ffmpeg).** Extract the pair and, if useful, a difference map to see whether the shapes overlay:
```bash
T=00:01:12.400
ffmpeg -ss $T -i ref.mp4 -frames:v 1 -update 1 b.png
ffmpeg -sseof -0 -ss $(python3 -c "print(72.400-1/30)") -i ref.mp4 -frames:v 1 -update 1 a.png
ffmpeg -i a.png -i b.png -filter_complex "blend=all_mode=difference" -update 1 diff.png
```
A graphic match shows the matched element's edges cancelling toward black in `diff.png`; a coincidental cut shows two bright, separated silhouettes.

**HyperFrames (assembly).** Two clips authored back to back — the half-open window `[start, start+duration)` means `b.start === a.start + a.duration` produces a true hard cut with no overlap and no gap:
```html
<video id="shot-a" src="a.mp4" muted playsinline class="clip"
       data-start="18.0" data-duration="3.4" data-media-start="12.0" data-track-index="0"></video>
<video id="shot-b" src="b.mp4" muted playsinline class="clip"
       data-start="21.4" data-duration="4.0" data-media-start="2.6" data-track-index="0"></video>
<!-- cut at 21.4s = frame 642 @30fps -->
```
The corrective reframe is a **static** transform, so it belongs in inline CSS on the media element — not a GSAP tween — and there must be no GSAP tween on the same property or lint raises `gsap_css_transform_conflict`:
```html
<video id="shot-b" style="transform: scale(1.06) translate(-1.2%, 0.8%); transform-origin: 46% 41%;" ...>
```
If you also need the shot to punch in later, drop the CSS transform and do **all** of it in GSAP: `tl.set("#shot-b", { scale: 1.06, x: "-1.2%", y: "0.8%", transformOrigin: "46% 41%" }, 21.4)`. Use `x`/`y`, never `left`/`top`.

Do **not** reach for a registry transition here. The five machine transitions (`crossfade`, `blur-crossfade`, `push-slide`, `zoom-through`, `squeeze`) all animate the scene wrappers and would destroy the match. A graphic match is a hard cut; the only legal soft variant is a short `crossfade` at `duration: 0.3`.

For the dissolve variant, the overlap is created by pulling `#shot-b`'s `data-start` earlier by the dissolve length and crossfading the wrappers:
```js
const T = 21.1; // 9f dissolve ending at 21.4
tl.to("#shot-a", { opacity: 0, duration: 0.3, ease: "power2.inOut" }, T);
tl.fromTo("#shot-b", { opacity: 0 }, { opacity: 1, duration: 0.3, ease: "power2.inOut" }, T);
```
Note the exit-animation ban applies to scene transitions, not to a deliberate dissolve pair authored at the same T — outgoing and incoming must animate at the same position, which this does.

**Epidemic Sound:** `SearchSoundEffects { query.term: "soft whoosh subtle transition", filter.duration {max: 1200} }`.

**Remotion:** two sequences with a static transform on one; concept only, no runtime here.

## Pairs with
[[cut-fade-to-white]] · [[cut-punch-in-emphasis]] · [[sfx-whoosh-transition-movement-reveal]] · [[pace-cut-density-from-viewer-intent]] · [[struct-music-arc-to-narrative-arc]] · [[cut-movement-match]] · [[cut-match-cut]]

## Failure modes
- **Forcing the match with a big transform.** A 25% scale correction changes the shot's apparent focal length and the audience sees a zoom, not a match. Fix: reject the pair; the fix is in shot selection or reshooting, not in the transform panel.
- **No holds.** Cutting into or out of a moving frame hides the match entirely — the eye is tracking motion, not shape. Fix: 12 frames of stillness before, 15 after.
- **Matching for its own sake.** A graphic match between two unrelated points makes the video feel like a showreel. Fix: require a one-clause statement of what the match asserts; if it asserts nothing, use a hard cut.
- **Over-scoring it.** An impact hit on a graphic match tells the viewer to notice the edit, which is the opposite of the effect. Fix: nothing, or a soft whoosh at −15 dB.
- **Trusting scene detection.** It flags graphic matches and misses none, but it also flags every ordinary cut; the classification is always visual. Fix: extract and inspect the frame pair for every candidate.
- **Known gap:** these tolerances are house numbers derived from practice and from the compositional guidance in the cited references; no published standard specifies a centroid tolerance for a graphic match. Treat them as review thresholds, and let a human override with a reason rather than pushing a pair through by loosening the numbers.
