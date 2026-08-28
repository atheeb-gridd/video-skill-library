---
id: sub-caption-graphic-collision
title: Cross-check the cue sheet against the motion design, and resolve every collision by moving the caption
skill: subtitles
type: caption-motion
family: safe-area
tags: [skill/subtitles, type/caption-motion, family/safe-area, engine/hyperframes, source/hyperframes, source/editing-kt, source/research, difficulty/high]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "the layout audit's `--caption-zone` / `caption_zone_collision` check, and its opt-out `data-layout-allow-caption-zone` (element + descendants, via `closest`)."
  - video: "assets/videos/editing kt.mp4"
    timestamp: n/a
    quote: "Hand-drawn white curved arrows annotating B-roll, with a caps label — RECORDING B-ROLL."
research_refs:
  - https://www.w3.org/TR/webvtt1/
  - https://support.google.com/youtube/answer/2734698
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
  - https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html
difficulty: high
detectable_from: video
---

# Cross-check the cue sheet against the motion design, and resolve every collision by moving the caption

## What it is

Captions are authored last, which means every other element already owns its screen position. A caption sitting under a lower third, behind an annotation arrow, or on top of a list marker is the most common avoidable defect in a finished video — and it is avoidable precisely because both sides are known at build time. This is a **cross-check between two design documents**, `design-subtitles.md` and `design-motion.md`, run as a timed overlap test rather than as a look-at-it review.

The check is mechanical:

1. Build a list of every **graphic occupancy window**: element id, its bounding box as percentages of frame width and height, and its `[start, end)` in seconds. Lower thirds, list markers, annotation arrows, attribution labels, corner watermarks, screen-recording PiPs, full-frame cards.
2. Build the same list for every **cue**: bounding box (which for captions is a band, not a point) and `[start, end)`.
3. Intersect in **three dimensions** — x, y and *t*. Two elements that share screen space at different times do not collide.
4. Resolve every intersection.

**Resolution order, and it is not symmetric.** The caption moves. The graphic does not. Three reasons: the graphic's position usually carries meaning (an arrow points at something; a marker sits beside its item), the caption's position is a style parameter rather than a semantic one, and the caption is the element that recurs hundreds of times — moving it is one change, moving the graphics is many.

The resolution ladder, in order:

- **Move the caption vertically** to a secondary band recorded in the profile (typically from ~18 % from the bottom to ~30 %, or above the graphic entirely). One move for the graphic's whole window plus a margin, animated as a single translate at the window's edges — never re-positioned per cue, which reads as jitter.
- **Shorten the caption's window** so it clears before the graphic enters and returns after it leaves. Only legal where the speech allows it; a caption suppressed while the speaker is talking is a worse defect than the overlap.
- **Suppress the caption** for the graphic's duration — legitimate only when the graphic *contains* the words, which is exactly the full-frame single-word topic card case.
- **Change the graphic's slot** — last resort, and it goes back to the motion design as a change request, not a caption-side fix.

**A z-index fix is not a fix.** Putting the caption on top of a lower third makes both unreadable; putting it underneath makes it invisible. Overlap in space is the defect; layering only chooses which half of it you lose.

## When to use it

- Once per project, after both design docs exist and before authoring, as a required gate.
- Again after any change to either document — adding a B-roll pass, a new annotation layer, or moving the caption band all invalidate the previous result.
- On **reference analysis**, to record where the creator's captions moved and what pushed them.
- Especially for **vertical** deliverables, where the platform UI already claims the bottom band and there is far less room to move into.

## How to recognise it in a reference video

- **Sample at the graphic windows, not uniformly.** Find every graphic's on-screen window, then sample frames inside each one. A uniform sample will miss a 1.5-second lower third entirely.
- **Measure the caption band and every graphic box** as percentages of frame width and height. Record the caption's baseline as a percentage from the bottom — typically **12–22 %** for horizontal, **18–30 %** for vertical where the platform UI pushes it up.
- **Look for the move.** A creator who handles collisions shows the caption band **jumping once** when a lower third appears and returning after. Measure the jump size (usually 8–15 % of frame height) and its duration (a translate of 0.2–0.4 s, or an instant move at a cut).
- **Look for the failure.** Text overlapping text, a caption plate cutting an arrow in half, a caption's stroke reading against a graphic's background instead of the picture. Any of these in a published video tells you the pass did not run.
- **Check the margin.** A caption that clears a lower third by 1 % of frame height is technically not overlapping and still reads as crowded. **3–5 % of frame height** is the comfortable clearance.
- **Check the transition frames.** A collision that only exists during the graphic's 12-frame entrance is easy to miss and very visible in motion.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `check_dimensions` | x, y, t | — | Time is the dimension people forget. |
| `clearance_margin` | 4 % frame height | 3–6 % | Below 3 % reads as crowded even without overlap. |
| `resolution_order` | move caption → shorten → suppress → change graphic | — | The graphic moves last, and only as a request. |
| `secondary_band` | 30 % from bottom | 25–40 % | Recorded in the profile, not invented per collision. |
| `move_animation` | 0.30 s translate | 0.2–0.4 s | One move per graphic window, at its edges. |
| `move_ease` | `power2.out` | `power1.out`–`power2.out` | The caption band. |
| `move_granularity` | per graphic window | — | Never per cue; per-cue repositioning is jitter. |
| `suppress_allowed` | only if graphic carries the words | — | Otherwise a suppression is a missing caption. |
| `z_index_fix` | forbidden | — | Layering chooses which element you lose. |
| `entrance_window_check` | required | — | Check the graphic's animate-in frames, not just its held state. |
| `vertical_headroom` | check platform UI first | — | The bottom band may already be gone. |
| `recheck_trigger` | any change to either doc | — | The result is only valid for the pair it was run on. |

## Reproduction prompt

```
Run the caption/graphic collision check for {{PROJECT}} between
design-subtitles.md and design-motion.md, and resolve every hit.

1. BUILD the graphic occupancy table from design-motion.md: for every timed
   graphic - lower thirds, list markers, arrows, attribution labels,
   watermarks, PiPs, full-frame cards - record id, bounding box as
   percentages of frame width and height INCLUDING entrance and exit extent,
   and [start, end) in seconds.
2. BUILD the same table for the caption band, per cue.
3. INTERSECT in x, y and t, expanding every graphic box by {{MARGIN}} = 4% of
   frame height. Report each hit as cue index, graphic id, overlap seconds
   and overlap area.
4. RESOLVE in order, stopping at the first that works: (a) move the caption
   band to {{SECONDARY}} = 30% from the bottom for the graphic's window plus
   {{PAD}} = 0.3s either side, as ONE {{MOVE_DUR}} = 0.30s power2.out
   translate at each edge - never per cue; (b) shorten the caption's window,
   only if no speech falls in the gap; (c) suppress the caption, only if the
   graphic itself carries those words; (d) raise a change request against
   design-motion.md. Never resolve with z-index.
5. RE-RUN afterwards: a moved band can collide with something else or leave
   the safe area.

ACCEPTANCE TEST: zero unresolved intersections including entrance and exit
frames; every move is one translate per graphic window; the moved band stays
inside the platform safe area; hyperframes check reports a non-zero sample
count and no unintended caption_zone_collision; and every suppression names
the graphic carrying its words.
```

## Execution spec

The framework provides exactly one caption-aware audit and it is worth using precisely: `hyperframes check` runs a **`--caption-zone` / `caption_zone_collision`** check, with the opt-out **`data-layout-allow-caption-zone`**, which applies to the element and its descendants via `closest`. That opt-out is the right tool for a *deliberate* lower-third that lives in the caption band — and it is narrow by design: it does **not** suppress the overflow, overlap or occlusion audits. Do not reach for `data-layout-allow-overflow` instead; its blast radius covers the whole subtree and it also silences `text-clipping`, `content-cramped-container` and `foreground-over-panel`.

Two audit facts that decide whether you can trust the result:

- **A lint error switches the layout and contrast audits off entirely**, after which `check` reports `0 sample(s)` and `0/0 text checks` — which reads like a pass and means nothing ran. Assert the sample count.
- The audit measures `getBoundingClientRect` **at sampled timestamps**, so a collision that exists only between samples can be missed. Sample the graphic windows explicitly rather than relying on the default sampling.

Composition-side points:

- **Layering is CSS `z-index`, not `data-track-index`** — track index is display only and constrains nothing. So the tempting "put captions on track 12" does nothing at all.
- A caption track authored as a **host-root sub-composition** sits above the scene stack and is not swept up by scene transitions; a caption nested inside a scene inherits that scene's clip window.
- The band move must be a **transform** (`y`, not `top`) on a non-clip wrapper, authored as `fromTo` at the window edges. Never derive the target position from `getBoundingClientRect()` at tween time — compute coordinates once at setup, and in a multi-scene montage use authored CSS-matched constants because later clips may not be laid out yet.
- Root-level clips get automatic absolute positioning only if they carry `data-start`; an untimed full-bleed backing needs its own `position: absolute; inset: 0`.

The safe-area interaction is not optional: after any vertical move, re-check against the platform UI map, since the secondary band on a vertical deliverable is squeezed between the caption zone and whatever the platform draws.

## Pairs with
[[sub-safe-area-and-caption-zone]] · [[sub-platform-ui-overlap-map]] · [[sub-fast-cut-sequence-captions]] · [[sub-list-marker-caption-lockup]] · [[sub-single-word-topic-card]] · [[sub-caption-plate-geometry]] · [[motion-overlay-stack-choreography]] · [[motion-graphics-broll-slot]] · [[motion-list-item-marker-card]] · [[motion-annotation-draw-on]] · [[motion-key-region-animate-in]]

## Failure modes
- **Checking position without time.** Two elements that share a band at different moments are reported as colliding, so the real hits get lost in the noise. Correction: intersect in t as well.
- **Ignoring entrance and exit extents.** A lower third that slides in from the left overlaps the caption for 12 frames and not thereafter. Correction: include animation extents in the box.
- **Fixing with z-index.** Both elements are still in the same place; you have only chosen which one to lose. Correction: move the caption.
- **Moving the caption per cue.** The band jitters up and down through the section. Correction: one move per graphic window.
- **Moving the caption out of the safe area.** The fix pushes it under platform UI, where it does not exist at all. Correction: re-check the safe band after every move.
- **Suppressing captions to clear a graphic.** A missing caption during speech is worse than an overlap. Correction: suppress only when the graphic carries the words.
- **Blanket `data-layout-allow-overflow`.** Silences three unrelated audits across the subtree. Correction: `data-layout-allow-caption-zone` for a deliberate lower-third, nothing for a real collision.
- **Trusting a green check after a lint error.** `0 sample(s)` is not a pass. Correction: assert the denominator.
- **Running the check once and not again after the motion design changed.** Correction: re-run on any change to either document.
