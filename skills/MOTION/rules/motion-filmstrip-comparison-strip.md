---
id: motion-filmstrip-comparison-strip
title: The filmstrip strip — put the whole cut in one static frame so the match is visible at once
skill: motion
type: graphic
family: teaching-visual
tags: [skill/motion, type/graphic, family/teaching-visual, family/match-cut, layer/design, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, movement match cut segment"
    quote: "[NOT SPOKEN — observed on screen] Filmstrip motif: a sequence rendered as four perforated frames in a row, used for the movement match cut so the matched shape is visible across the cut in one static graphic."
research_refs:
  - https://en.wikipedia.org/wiki/Match_cut
  - https://en.wikipedia.org/wiki/Contact_print
  - https://en.wikipedia.org/wiki/Dual-coding_theory
  - https://ffmpeg.org/ffmpeg-filters.html#tile
  - _meta/visual-kt-delta.md
difficulty: medium
detectable_from: video
---

# The filmstrip strip — put the whole cut in one static frame so the match is visible at once

## What it is
A match cut is invisible at speed. That is the point of it in a film and the problem with it in a tutorial: the viewer sees shot A, then shot B, and the *relationship* between them — the shape, the movement, the graphic rhyme — has to be reconstructed from memory across the seam. `editing kt 2` solves it by rendering the sequence as **four perforated film frames in a row**, so the matched shape sits side by side in one static image and the comparison happens in space instead of in time.

The mechanism is simple and general: **replace a temporal comparison with a spatial one.** Working memory does not have to hold shot A while shot B plays; both are present. The perforated-filmstrip framing does a second job — it says "these are frames from a sequence, in order" without a caption, borrowing a century-old convention that needs no explanation.

It differs from a plain side-by-side in one important way: the strip preserves **order and adjacency**. A/B comparisons say "these two are alike"; a filmstrip says "this became that, in this direction, across this cut". For a movement match cut, direction is half the lesson ([[cut-movement-match]], [[cut-graphic-match]], [[motion-graphic-match-alignment-transform]]).

Use it as the **still** counterpart to the running timeline overlay ([[motion-timeline-overlay-explainer]]): the overlay shows *when* the cut happens, the strip shows *what survives* it.

## When to use it
- **Any match cut, graphic match or movement match** — the case it was observed on, and the strongest one.
- **Before/after comparisons** where the change is a shape or a composition rather than a colour or a level.
- **To show a sequence's rhythm** — four frames at equal intervals says "fast" or "slow" without a number.
- **When the matched element is small.** Adjacent frames let a viewer's eye do the comparison; a cut at speed does not.
- **As a recap** after the live demonstration, to freeze what was just shown ([[struct-name-define-demonstrate]]).
- **Not for a colour, level or audio claim.** Those need a graded comparison or a waveform, not frames.
- **Not with more than about six frames.** Past that each frame is too small for its content to read.
- **Not as a decorative motif.** A filmstrip border around unrelated B-roll is a 1990s title-template tell.

## How to recognise it in a reference video
- **Frames in a row with sprocket perforations** along the top and bottom edges, usually 3–5 of them.
- **The frames are real stills from the clip just played**, not stock images — check that a distinctive element in the live clip appears in the strip.
- **The matched shape sits in the same screen position across at least two adjacent frames.** That alignment is the whole claim; if it does not hold, the reference is illustrating rather than teaching.
- **It is static and held** — 2.5–5 s — often with a highlight (a circle, an arrow, or a colour tint) drawn on the matched element ([[motion-annotation-draw-on]]).
- **It appears after or beside the live clip**, not instead of it.
- **The order reads left to right** with even gaps; uneven gaps usually mean the strip is a layout, not a sequence.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `frame_count` | 4 | 3–6 | Four is the observed value and the practical maximum for 1080p legibility. |
| `frame_width` | 380 px @1080p | 300–460 px | Derived: `(frame_width × n) + (gap × (n−1)) ≤ 1720` to keep margins. |
| `frame_aspect` | source aspect | — | Never crop differently per frame; the comparison depends on identical framing. |
| `gap` | 18 px | 12–28 px | Even. Uneven gaps read as grouping and imply a claim you are not making. |
| `perforation_pitch` | 34 px | 28–44 px | Sprocket holes top and bottom; 4–6 px corner radius. |
| `strip_rotation` | 0° | −3° to +3° | A slight tilt is a style choice; past 3° it costs legibility. |
| `sample_points` | 2 before, 2 after the cut | — | The default: two frames of shot A, two of shot B. |
| `sample_offsets` | −0.40 s, −0.07 s, +0.07 s, +0.40 s | ±0.03–1.0 s | Relative to the cut. The two inner frames must straddle the seam tightly. |
| `highlight` | 1 per strip | 0–1 | One circle, arrow or tint marking the matched element. Two highlights = two lessons. |
| `dwell` | 3.5 s | 2.5–5 s | Long enough to compare four images. |
| `entry_stagger` | 0.08 s per frame | 0.06–0.12 s | Frames arrive left to right — the direction the sequence runs. |
| `ease` | `power3.out`, 0.35 s | — | No overshoot; a strip is a document, not a flourish. |

## Reproduction prompt

```
Build a filmstrip comparison for the {{CUT}} at {{T_CUT}} in {{CLIP}}.

1. EXTRACT the frames at exact times, not by scrubbing:
   for t in $(T_CUT-0.40) $(T_CUT-0.07) $(T_CUT+0.07) $(T_CUT+0.40); do
     ffmpeg -ss $t -i clip.mp4 -frames:v 1 -y frame_$t.png
   done
   The two inner frames MUST straddle the cut - verify by eye that one is
   the outgoing shot and the next is the incoming one.
2. CHECK THE MATCH BEFORE BUILDING. Open the two inner frames and confirm
   the matched shape occupies the same screen region in both. If it does not,
   this is not a match cut and the strip will prove that rather than the
   claim you wanted.
3. LAY OUT four frames in a row, equal size, even 18 px gaps, sprocket
   perforations top and bottom, on the same dark ground the rest of the
   video's graphics use.
4. ADD ONE HIGHLIGHT on the matched element - the same shape and colour in
   both inner frames, so the eye jumps between them.
5. ANIMATE: frames fade/rise in left to right, 0.08 s apart, 0.35 s each,
   power3.out; highlight last. Then hold 3.5 s, static.
6. PLACE IT AFTER the live clip has played at least once at speed.

ACCEPTANCE TEST: freeze on the strip and ask a viewer to point at what stays
the same across the cut. If they need the voiceover to find it, either the
highlight is missing or the two inner frames are too far from the seam.
```

## Execution spec

**ffmpeg — extract, and optionally compose.**
```bash
# exact single frames (fast seek: -ss BEFORE -i)
ffmpeg -ss 41.68 -i clip.mp4 -frames:v 1 -y assets/img/fs_a1.png
ffmpeg -ss 42.01 -i clip.mp4 -frames:v 1 -y assets/img/fs_a2.png
ffmpeg -ss 42.15 -i clip.mp4 -frames:v 1 -y assets/img/fs_b1.png
ffmpeg -ss 42.48 -i clip.mp4 -frames:v 1 -y assets/img/fs_b2.png
# or pre-compose the row (layout in the composition is usually better - it stays editable)
ffmpeg -i assets/img/fs_%d.png -filter_complex "scale=380:-1,tile=4x1:padding=18:color=black" -frames:v 1 strip.png
```
Frame-index extraction (`select='between(n,N1,N2)'`) is available when you need exactness with no rounding at all — worth it when the cut is one frame from a fast pan.

**HyperFrames — layout in the composition, not in the PNG.** Keeping the frames as separate `<img>` elements means the stagger, the highlight and the gaps stay editable, and the strip can be re-used with different stills.

```html
<div class="clip" id="fs-strip" data-start="96.00" data-duration="4.20" data-track-index="2">
  <div class="fs-row">
    <img class="fs-frame" id="fs1" src="assets/img/fs_a1.png" alt="">
    <img class="fs-frame" id="fs2" src="assets/img/fs_a2.png" alt="">
    <img class="fs-frame" id="fs3" src="assets/img/fs_b1.png" alt="">
    <img class="fs-frame" id="fs4" src="assets/img/fs_b2.png" alt="">
  </div>
  <div class="fs-highlight" id="fs-hl"></div>
</div>
```
```js
const IN = 96.0;
tl.fromTo(".fs-frame", { autoAlpha: 0, y: 14 },
  { autoAlpha: 1, y: 0, duration: 0.35, ease: "power3.out", stagger: 0.08 }, IN);
tl.fromTo("#fs-hl", { autoAlpha: 0, scale: 0.9 },
  { autoAlpha: 1, scale: 1, duration: 0.3, ease: "power3.out" }, IN + 0.55);
```
`stagger` is the correct primitive for a row arriving in order — do not write four tweens. **`fromTo`, never `from`**; transform aliases only; `autoAlpha` never on the clip element; last tween lands before `data-duration`. Perforations are CSS (a repeating gradient or a mask), not images, so they scale with the frame size.

**Sub-composition it** if the video teaches more than one match cut: same strip, four different `src` values and one highlight position.

**Remotion.** Four `<Img>` with an interpolated stagger; identical structure.

## Pairs with
[[cut-movement-match]] · [[cut-graphic-match]] · [[cut-match-cut]] · [[motion-graphic-match-alignment-transform]] · [[motion-timeline-overlay-explainer]] · [[motion-annotation-draw-on]] · [[motion-attribution-label-inset-clip]] · [[struct-name-define-demonstrate]] · [[struct-recognisable-clip-evidence]] · [[motion-continuity-across-the-seam]]

## Failure modes
- **Inner frames too far from the cut.** Sample at ±2 s and the two shots have moved on; the match is no longer visible and the strip disproves the claim.
- **Different crops per frame.** Any change of framing between cells destroys the spatial comparison the technique exists for.
- **More than six frames.** Each cell becomes a thumbnail and the matched element disappears.
- **No highlight.** For a subtle match, the viewer will not find it in 3.5 seconds unaided.
- **Two highlights.** Two lessons in one graphic; neither lands. Make a second strip.
- **Using it for a colour or audio claim.** Frames cannot show a level, a tail or a grade difference reliably at thumbnail size.
- **Uneven gaps.** Reads as grouping — the viewer infers a claim about pairs that you did not make.
- **Filmstrip as decoration.** Perforations around unrelated footage is a template motif, not a teaching device.
- **Known gap:** the reference's exact sample offsets are not measurable from a contact sheet; the ±0.07 / ±0.40 s defaults here are derived from what a straddling pair needs, not observed.
