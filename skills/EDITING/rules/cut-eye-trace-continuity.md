---
id: cut-eye-trace-continuity
title: Eye trace — keep the viewer's eye in the same place across the cut
skill: editing
type: cut
family: continuity
tags: [skill/editing, type/cut, family/continuity, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:26"
    quote: "I just made a cut, and in doing it I broke the most important rule of cutting. In the last frame of that first clip, the viewer is looking me right in the eyes. A tiny fraction of a second later, in the first frame of the second clip, the viewer is suddenly supposed to look over here."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:42"
    quote: "If you can create a seamless flow of images, there are no rough edges, no spots where distractions can creep in."
research_refs:
  - https://filmdaft.com/walter-murchs-rule-of-six-the-editors-formula-for-choosing-the-right-cut/
  - https://www.studiobinder.com/blog/walter-murch-rule-of-six/
  - https://artlist.io/blog/eye-trace-and-rule-of-six-editing/
  - https://nofilmschool.com/2018/08/editing-eye-trace-mind-rule-six-incorrect
  - https://homepages.inf.ed.ac.uk/rhill2/pubs/Mital_(2011)_Clustering_of_gaze_during_dynamic_scene_viewing.pdf
  - https://bop.unibe.ch/JEMR/article/download/2264/3460
  - https://air.io/en/youtube-hacks/advanced-retention-editing-cutting-patterns-that-keep-viewers-past-minute-8
difficulty: medium
detectable_from: video
---

# Eye trace — keep the viewer's eye in the same place across the cut

## What it is
A test applied to exactly two frames: the **last frame of the outgoing shot** and the **first frame of the incoming shot**. Locate the thing the viewer is looking at in each. If the two positions are far apart, the cut forces a physical eye movement, and that movement is felt as a bump — the source's own diagnosis, made against its own edit: eyes locked on the presenter's face, then "suddenly supposed to look over here". The device is named **eye trace** in the professional vocabulary and sits fourth in Walter Murch's Rule of Six at a nominal **7%** weight, behind emotion (51%), story (23%) and rhythm (10%). That weighting is contested for modern short-form: with average shot lengths under a second, one television editor's position is that in a fast montage eye trace "may even be the single most important factor when choosing the next edit". The cost compounds — one mismatched cut is a bump, a whole sequence of them is what makes an edit tiring to watch without the viewer being able to say why.

## When to use it
As a check on **every** cut, and as a design constraint on any beat where you control the framing or the graphic placement. It escalates from a check to the deciding factor when: shot lengths drop under about 1.5 s, because there is no time to re-find the subject; you are cutting between shots with strongly off-centre subjects; the incoming shot is a graphic, screenshot, chart or text card, where you own the focal point completely; you are cutting between two speakers or two framings that sit on opposite sides of frame; or you are cutting into or out of an overlay that occupies one side. It is also the first thing to check when a section "feels choppy" while measuring correctly on cut density and shot-length distribution. The one legitimate exception is a deliberate jolt — a smash cut, a pattern interrupt, or the first frame of a new act — where the jump *is* the effect and should be the only one in that neighbourhood.

## How to recognise it in a reference video
- **The two-frame test, run mechanically.** Export the frame before and the frame after every cut, and mark one point of interest in each. Position is what you log, in fractions of frame width and height.
  ```bash
  ffmpeg -i ref.mp4 -vf "select='eq(n\,{{N}})'"   -vsync 0 -frames:v 1 out_last.png
  ffmpeg -i ref.mp4 -vf "select='eq(n\,{{N}}+1)'" -vsync 0 -frames:v 1 in_first.png
  ```
- **How to find the point of interest, in priority order.** A visible face (eyes specifically) beats everything; then the only moving element; then the highest-contrast/sharpest region against a soft background; then the largest text; then screen centre by default. A cheap saliency proxy with ffmpeg alone: `ffmpeg -i in_first.png -vf "edgedetect=low=0.1:high=0.3,scale=8:8,format=gray" -f rawvideo -pix_fmt gray -` and take the brightest cell of the 8×8 grid as the busiest region.
- **Displacement is the parameter.** Compute Euclidean displacement between the two points as a fraction of frame width. **≤ 10%** is a match (one published retention guide states the subject should stay within ~10% of its previous frame position for a smooth cut); **10–20%** is a small saccade the viewer absorbs; **> 25%** is the bump the source is complaining about; **> 40%**, or a cross-frame swap (left third to right third), is a hard break.
- **The re-orientation window is measurable, and short.** Gaze clusters most tightly in the **first ~200 ms** after a cut, peak clustering persists through about **533 ms**, and a **central bias appears around 333 ms** — after a cut viewers saccade toward screen centre regardless of image content. At 30 fps that is: frames **1–6** are where eye trace is decided, frames **1–16** are still converging, and the default landing zone is the middle of frame. Two consequences: an incoming focal point placed near centre is nearly always safe, and an incoming element that only *arrives* after frame 10 has already lost the audience's first look.
- **Repetition is the real signal.** Log displacement for every cut in a 60-second window and take the median and p90. A reference video edited with eye trace in mind has median displacement **under 12%** with few outliers; an unmanaged edit shows a flat spread up to 50%+.
- **Graphic and caption anchoring.** In a managed edit, lower thirds, captions, callouts and stat cards appear in the **same** screen zone every time; the eye learns one place to look. Log the anchor zones and count distinct ones — more than three is unmanaged.
- **Eye-trace-by-motion.** Look for the outgoing shot *leading* the eye to the incoming position (a pan, a gesture, a moving graphic ending where the next shot's subject begins). That is the professional solution when the positions genuinely cannot match, and it is visible as motion in the last 6–15 frames of the outgoing shot.
- **Do not confuse it with eyeline match, and do not over-claim.** Eyeline match is about *whose gaze* and *what they are looking at*; eye trace is about *where on the screen* the audience's own eyes are. Honest caveat from the lab: in the edit-blindness study, cuts constructed with gaze/eyeline continuity were spotted *fastest* (mean 410 ms, only 10.9% missed) while action-matched cuts were the best hidden (32.4% missed) — so screen-position matching should be sold as comfort and comprehension, not as invisibility. Invisibility comes from [[cut-on-action]].

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `poi_displacement_max` | 10% of frame width | 5–20% | 192 px at 1920 wide. Matches the 10–15% centroid tolerance used for [[cut-movement-match]]. |
| `poi_displacement_hard_fail` | 25% of frame width | 20–35% | Above this the viewer performs a visible saccade; fix the framing rather than the timing. |
| `decision_window` | 6 f (0.20 s) | 3–10 f | Frames after the cut during which the incoming focal point must already be present and readable. |
| `convergence_window` | 16 f (0.53 s) | 10–20 f | Full gaze-clustering window after a cut. Nothing important should *start* later than this. |
| `centre_safe_zone` | inner 30% of frame | 20–40% | Post-cut gaze drifts toward centre from ~333 ms; a focal point here is safe from any outgoing position. |
| `lead_motion_len` | 12 f (0.40 s) | 6–20 f | Length of an outgoing move used to walk the eye to the incoming position. |
| `graphic_anchor_count` | 2 | 1–3 | Distinct screen zones allowed for overlays/captions across a whole video. |
| `reframe_scale_max` | 1.25× | 1.0–1.45× | Punch-in allowed while re-centring a focal point before framing loss shows. |
| `reposition_max` | 12% of frame width | 0–18% | Offset applied to an incoming clip to move its focal point; beyond this, edges show. |
| `median_displacement_target` | ≤ 12% | 8–18% | Section-level acceptance number, measured across all cuts. |

## Reproduction prompt

```
Enforce eye-trace continuity across every cut in {{SECTION}} at 30fps.

1. For each cut at composition time {{CUT}}, export the outgoing last frame
   and the incoming first frame:
     ffmpeg -ss <t> -i <src> -frames:v 1 -vsync 0 last.png
     ffmpeg -ss <t> -i <src> -frames:v 1 -vsync 0 first.png
2. Mark ONE point of interest per frame, in normalised coordinates (0-1 on
   both axes). Priority: visible eyes > only moving element > highest-contrast
   sharp region > largest text > frame centre.
3. Compute displacement D as a fraction of frame width.
   D <= 0.10  -> pass, do nothing.
   0.10 < D <= 0.25 -> fix with the cheapest available move (step 4).
   D > 0.25   -> must fix, unless this cut is flagged in the design document
                 as a deliberate jolt (smash cut / pattern interrupt / act break).
4. Fix, cheapest first:
   a. Move the INCOMING clip's focal point toward the OUTGOING position with a
      transform offset: x/y up to 12% of frame width, or scale up to 1.25x with
      a matching offset. Never animate width/height/top/left.
   b. If the incoming shot is a graphic, screenshot, chart or text card, simply
      lay it out so its focal point sits where the eye already is - you own
      this completely, so it should never fail.
   c. If neither is possible, place the incoming focal point in the inner 30%
      of frame (post-cut gaze goes to centre from ~333ms anyway).
   d. If the eye genuinely has to travel, LEAD it: add a 12-frame motion in the
      OUTGOING shot (pan, gesture, or a moving element) that ends where the
      incoming focal point will be. Motion in the outgoing tail, never a jump
      in the incoming head.
5. The incoming focal point must be present and readable within 6 frames of
   {{CUT}}. If it is animated in, its arrival must complete by frame 6; if the
   element cannot arrive that fast, cut later instead.
6. Anchor every overlay, caption and callout in the video to at most 2 screen
   zones, and keep those zones identical across the section.

ACCEPTANCE TEST: (a) median displacement across the section <= 0.12 of frame
width, p90 <= 0.25, with every exceedance named in the design document;
(b) step through each boundary one frame at a time - your own eyes should not
have to move; (c) play the section at 1x twice, once watching the left half of
frame and once the right - neither pass should feel like it is missing the
subject; (d) no important element first appears later than 16 frames after
any cut.
```

## Execution spec

**HyperFrames (primary).** Eye trace is executed as **authored geometry** on the incoming clip plus consistent layout for graphics. The contract is explicit that there is **no automatic face tracking and no content-aware reframe** — pan/scale is *"authored geometry, not automatic face tracking"* — so the focal-point positions come from your measured frames and are written as constants.

```html
<!-- picture cut at 12.00s; incoming clip nudged so the face lands where the last one was -->
<video id="shot-a" src="assets/a.mp4" muted playsinline class="clip"
       data-start="8.00" data-duration="4.00" data-media-start="2.00" data-track-index="0"></video>

<div id="wrap-b" class="clip" data-start="12.00" data-duration="5.00" data-track-index="0">
  <video id="shot-b" src="assets/b.mp4" muted playsinline></video>
</div>
```
```js
// Static reframe of the incoming shot: focal point measured at x=0.68, needs to sit at 0.52.
// 0.16 x 1920 = 307px to the left, with a 1.12 scale so no edge is exposed.
tl.set("#wrap-b", { scale: 1.12, x: -307, transformOrigin: "50% 50%" }, 12.0);
```
Four contract details that make or break this:
- **Never tween or set `width`/`height`/`top`/`left`** — forbidden. Use the transform aliases `x`, `y`, `scale`, `rotation` only.
- **A CSS `transform` on the same element as a GSAP transform tween is lint error `gsap_css_transform_conflict`.** Author the offset in GSAP (`tl.set` / `fromTo`), not in CSS.
- **Wrap the video** if you need the offset on a timed element: a `<video data-start>` inside another `data-start` ancestor is lint error `video_nested_in_timed_element`. Either time the wrapper (as above, with the inner `<video>` untimed) or time the video and put the transform on the video itself.
- The lead-the-eye move is an ordinary tween on the **outgoing** clip and must land before the clip's `data-duration`, because the visibility window is half-open `[start, start+duration)` and the final frame of a tween that ends exactly on the boundary is never rendered.

A lead-the-eye tail on the outgoing shot, 12 frames = 0.40 s at 30 fps:
```js
// walk the eye from centre to where B's subject will be, finishing 1 frame before the cut
tl.to("#wrap-a", { x: -160, duration: 0.40, ease: "power2.inOut" }, 12.0 - 0.40 - (1/30));
```
`power2.inOut` rather than the house `power3.out`: the move is a camera-like drift, and the contract reserves `power3.out`/`power4.out` for entrances.

For graphics, the anchoring rule is a CSS rule, not a per-clip decision: define two anchor classes (e.g. `.anchor-lower-left`, `.anchor-upper-right`) in the composition's scoped styles and use only those. Lower-third copy that trips `caption_zone_collision` gets `data-layout-allow-caption-zone` — the narrow opt-out — not `data-layout-allow-overflow`, whose blast radius suppresses text-clipping and cramped-container findings for the whole subtree.

**ffmpeg — measurement, and a physical reframe only if the clip is leaving the pipeline.**
```bash
# edge frames either side of a cut at 12.00s (source-relative times)
ffmpeg -ss 11.967 -i a.mp4 -frames:v 1 -vsync 0 last.png
ffmpeg -ss 2.000  -i b.mp4 -frames:v 1 -vsync 0 first.png

# 8x8 "busyness" grid as a saliency proxy — brightest cell is the likely focal point
ffmpeg -i first.png -vf "edgedetect=low=0.1:high=0.3,scale=8:8,format=gray" -f rawvideo -pix_fmt gray - | xxd -p

# only when a re-encode is the deliverable: crop-and-scale reframe (1.12x, shifted left 307px)
ffmpeg -i b.mp4 -vf "crop=iw/1.12:ih/1.12:(iw-iw/1.12)/2+274:(ih-ih/1.12)/2,scale=1920:1080" b_reframed.mp4
```
Prefer the in-composition transform: the contract's rule is that crop/reframe is done with `clip-path` or transforms at render time and a file is cut *only* when the deliverable is a re-encode.

**Epidemic Sound.** Not involved — and that is worth stating in a design document, because the reflex fix for a bumpy cut is to throw a whoosh on it. A whoosh masks a rhythm problem, not a geometry problem; fix the geometry ([[sfx-whoosh-transition-movement-reveal]] for when the whoosh is actually right).

**Remotion:** conceptually a wrapping `<div>` with a `transform` derived from an interpolated value per `<Sequence>`; no Remotion runtime exists in this project.

## Pairs with
[[cut-on-action]] · [[cut-invisible-storytelling-doctrine]] · [[cut-movement-match]] · [[cut-graphic-match]] · [[cut-punch-in-emphasis]] · [[motion-image-focal-point-direction]] · [[pace-visual-variety-density-audit]] · [[pace-overlay-instead-of-cut]] · [[motion-list-item-marker-card]]

## Failure modes
- **Fixing eye trace at the expense of the story.** Murch's ordering is not decoration: emotion and story outrank eye trace by a factor of seven. A better-matched cut on the wrong frame is worse than a bumpy cut on the right one. Fix: choose the cut point first, then reconcile geometry.
- **Reframing so hard the framing breaks.** Pushing past ~1.25× to re-centre a face gives you a soft, badly composed shot and exposed edges. Fix: cap at `reframe_scale_max`, then fall back to placing the focal point at centre, then to leading the eye.
- **Animating the incoming focal point in.** A callout that slides in over 20 frames is invisible during the exact window when the audience is looking. Fix: complete any incoming arrival within 6 frames, or cut later.
- **A different graphic anchor every time.** Three lower-third positions, two callout corners and a floating stat card means the eye is hunting on every insert. Fix: two anchors for the whole video, defined as CSS classes.
- **Chasing zero displacement everywhere.** An edit where every focal point sits in the same pixel is inert; variety of composition is also a value. Fix: hold the *median* under 12% and let individual cuts breathe.
- **Using a whoosh or a flash to cover a mismatch.** It converts a geometry problem into a geometry problem with a sound on it. Fix the frames.
- **Claiming invisibility.** Screen-position matching buys comfort; the measured invisibility champion is action continuity (32.4% of match-action cuts went unnoticed versus 9.4% for scene-change cuts). Report eye trace as comfort, not as an invisibility guarantee.
- **Known gap:** the stack has no face detection, no saliency model and no automatic reframe, and the browser-dependent tools that would let you eyeball a `snapshot` cannot run on the authoring VM. Focal-point coordinates must therefore be measured off the source frames with ffmpeg and written as constants — and any note that promises automatic tracking is promising something this stack cannot do.
