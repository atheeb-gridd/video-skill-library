---
id: gfx-progress-step-indicator
title: The progress indicator — persistent, unmoving, and the reason it must not animate
skill: motion
type: graphic
family: orientation
tags: [skill/motion, type/graphic, family/orientation, engine/hyperframes, engine/remotion, source/research, difficulty/low]
source:
  - video: "research"
    timestamp: "n/a"
    quote: "The motion library specified a counter's digit swap but nothing specified what the counter looks like or where it lives."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
difficulty: low
detectable_from: video
---

# The progress indicator — persistent, unmoving, and the reason it must not animate

## What it is

A small persistent element telling the viewer **where they are in a sequence** — 3 of 7, four dots with the second filled, a thin bar. It answers "how much longer" without the speaker saying it.

Its defining property is the one that gets broken: it is **an anchor, not an event.** It must stay in exactly the same place, at the same size, for the whole run. The instant it moves or animates for its own sake it stops being furniture the eye ignores and becomes something the eye must re-read.

## When to use it

When the video is explicitly enumerated — "ten points", "three types", a countdown — and the list is long enough that a viewer loses their place. Below about four items, the spoken ordinal is enough and an indicator is clutter.

It carries **position in a sequence**, which a caption cannot: the caption shows the current words, not the shape of the whole. That is its channel justification (`[[gfx-three-channel-division-of-labour]]`).

Note the interaction with `[[gfx-structure-duplicates-prose-does-not]]`: showing "3" while the speaker says "third" is *structural* duplication and it aids recall. That is licensed. Showing the item's whole title while the caption shows it is not.

## How to recognise it in a reference video

- **Persistence.** Sample frames 5 s apart across a section. Is it in the identical pixel position each time? Any drift means it is being re-laid-out per beat, which is the failure.
- **Form:** dots, numerals, fraction (`3/7`), bar, or stacked ticks.
- **Size** as % of frame height — it should be at or below the smallest step on the type scale.
- **Position** as % from the frame edges, and whether it clears the platform safe area.
- **Contrast** against the *most varied* background it sits over across the run, not the average.
- **Transition on advance:** does the change itself animate, and over how many frames? Anything over ~6 frames is drawing attention it should not.
- **Opacity.** Frequently 60–80 %, which is the tell that it is deliberately subordinate.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `form` | dots ≤7 items · fraction >7 | — | Dots stop being countable at a glance past ~7. |
| `size` | 1.6 %H | 1.2–2.2 %H | At or below the smallest step in `[[gfx-modular-type-scale]]`. |
| `position` | top-right | top-right, top-centre | Must clear the safe area — see `[[gfx-vertical-grid-and-margins]]`. |
| `margin` | 6 %W / 8 %H | — | From the grid; do not set locally. |
| `opacity` | 0.7 | 0.55–0.85 | Subordinate by design. |
| `contrast_floor` | 3.0 : 1 | ≥3.0 : 1 | Against the busiest background in the run. |
| `advance_frames` | 4 | 0–6 | The state change only. Never a move or a scale. |
| `min_items` | 4 | — | Below this, drop the indicator; the spoken ordinal suffices. |
| `backing` | none, or minimal scrim | — | Ladder in `[[gfx-plate-and-scrim-ladder]]`. |

## Reproduction prompt

```
Add a progress indicator for a {{N}}-item sequence.

1. If {{N}} < 4, do not add one. The spoken ordinal is enough and this
   would be clutter. Say so and stop.
2. Form: dots if {{N}} <= 7, fraction ("{{i}}/{{N}}") if greater.
3. Size 1.6% of frame height. Position top-right at the profile's grid
   margin. Compute the position ONCE and reuse it for every state — do
   not re-lay-out per item.
4. Opacity 0.7. Verify >= 3:1 contrast against the BUSIEST frame the
   indicator sits over anywhere in the run, not a representative one.
   If it fails, add the minimum backing from the scrim ladder rather
   than raising opacity.
5. On advance, cross-fade the state over 4 frames. Do NOT translate,
   scale, bounce or re-colour the whole element. Only the state changes.
6. Hold it on screen continuously through the enumerated section. Remove
   it at the section boundary, not between items.
7. ACCEPTANCE TEST: extract the frame at each item's start and diff the
   indicator's bounding box across all of them. Every box must be
   pixel-identical in position and size. Any difference is the bug.
```

## Execution spec

**HyperFrames.** One element outside any per-beat container, so it cannot be re-laid-out by a beat's timeline:

```html
<div class="progress" data-start="12" data-duration="96"
     style="position:absolute; top:8%; right:6%; opacity:.7;
            display:flex; gap:.6vh; align-items:center">
  <span class="dot on"></span><span class="dot"></span><span class="dot"></span>
</div>
```

Advance by toggling a class on the dots, never by rebuilding the row — a rebuild reflows and shifts subpixel positions:

```js
tl.to("#dot-2", { duration: 0.133, onStart(){ dot2.classList.add("on") } }, 18.4);
```

Size in `vh` so it scales with the frame rather than with a parent. Living outside the beat containers is what guarantees the acceptance test passes.

**Remotion:** a component rendered above the sequence, driven by frame index — same constraint, keep it out of per-scene containers.

## Pairs with
[[gfx-list-card-enumeration]] · [[gfx-structure-duplicates-prose-does-not]] · [[gfx-attention-budget-simultaneity]] · [[gfx-vertical-grid-and-margins]] · [[gfx-plate-and-scrim-ladder]] · [[gfx-modular-type-scale]]

## Failure modes

- **Animating the indicator itself.** A bounce or slide on advance converts furniture into an event and steals the beat from whatever actually matters. Fix: 4-frame state cross-fade, nothing else.
- **Re-laying-out per beat.** Subpixel drift the viewer registers as instability without being able to name. Fix: one element, outside beat containers.
- **Too large.** Above ~2.2 %H it competes with content. It should be findable, not noticeable.
- **Contrast checked against one background.** Passes at 0:30 and vanishes at 2:10. Fix: check the busiest frame in the run.
- **Dots past seven.** Uncountable at a glance, so it conveys nothing. Fix: switch to a fraction.
- **Left on past the section.** Implies a sequence that has ended. Remove at the boundary.
