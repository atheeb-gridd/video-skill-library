---
id: gfx-diagram-primitives
title: Diagram primitives — box, arrow, connector, and the node ceiling in 9:16
aliases: [gfx-diagram-node-geometry, gfx-diagram-connector-geometry]
skill: motion
type: graphic
family: diagram-system
tags: [skill/motion, type/graphic, family/diagram-system, engine/hyperframes, engine/remotion, source/research, difficulty/medium]
source:
  - video: "research"
    timestamp: "n/a"
    quote: "No existing note covered diagram geometry; the motion library specified how a diagram animates but not what it is."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
  - https://en.wikipedia.org/wiki/Principles_of_grouping
difficulty: medium
detectable_from: video
---

# Diagram primitives — box, arrow, connector, and the node ceiling in 9:16

## What it is

A diagram is three primitives — a **node** (box), a **link** (connector), and a **direction marker** (arrow head) — plus the whitespace between them. This note fixes their geometry. `[[motion-annotation-draw-on]]` and the entrance notes cover how they arrive; this is what arrives.

The single thing that kills diagrams on a phone is not styling, it is **node count**. A diagram that reads on a laptop becomes a grey texture at 1080×1920 viewed at arm's length.

## When to use it

When the beat is a *relationship* — A causes B, A versus B, A becomes B, A contains B. Relationship is the one thing a caption genuinely cannot carry, which is what earns a diagram its place on screen (`[[gfx-three-channel-division-of-labour]]`).

Not for a list — that is `[[gfx-list-card-enumeration]]`. Not for a single quantity — that is `[[gfx-stat-card-layout]]`.

## How to recognise it in a reference video

Measurable from one frame:

- **Node count.** Count boxes. Three or fewer is the norm in vertical; five is the practical ceiling; more than five means the reference is either not vertical or is failing.
- **Node fill vs stroke.** Filled boxes read at smaller sizes than outlined ones; note which.
- **Stroke weight** in px at 1080 wide, measured on a connector.
- **Arrow-head length** as a multiple of stroke weight — measure both and divide.
- **Connector routing:** orthogonal (right angles only) or direct (any angle). Orthogonal reads as system/process; direct reads as causal/organic.
- **Gap between nodes** as % of frame width.
- **Label placement:** inside the node, or beside it. Inside forces short labels and is the vertical-friendly choice.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `node_count` | 3 | 2–5 | Above 5 in 9:16, split across beats instead. |
| `node_min_height` | 9 %H | 7–14 %H | Below 7 %H the label inside it breaks the type floor. |
| `node_padding` | 0.5× cap height | 0.4–0.8× | Padding scales with type, not with the box. |
| `stroke_weight` | 4 px @1080w | 3–6 px | Below 3 px it disappears after platform re-encode. |
| `arrowhead_len` | 3.5× stroke | 3–4× stroke | Locking to stroke is what keeps a diagram coherent when scaled. |
| `arrowhead_angle` | 40° included | 30–50° | Narrower reads technical, wider reads casual. |
| `node_gap` | 8 %W | 6–12 %W | Gestalt proximity: gap must exceed node padding or the nodes group visually. |
| `corner_radius` | inherit | — | From `[[gfx-stroke-weight-and-corner-radius]]`. Do not set locally. |
| `label_max_chars` | 14 | 8–20 | Inside a node. Longer, and move the label beside it or shorten the copy. |

## Reproduction prompt

```
Build a diagram of {{N}} nodes expressing {{RELATIONSHIP}} at {{OUT_TC}}.

1. If {{N}} > 5, STOP and split across two beats. A 9:16 frame does not
   hold six nodes legibly.
2. Take the type step for node labels from the profile's scale; take
   stroke weight and corner radius from the profile, not locally.
3. Size each node to at least 9% of frame height. Pad interior by 0.5x
   the label's cap height on all sides.
4. Space nodes at least 8% of frame width apart. Verify the gap exceeds
   node padding — if it does not, the nodes read as one group.
5. Draw connectors at the profile stroke weight. Route orthogonally for
   a process or system; direct for cause and effect. Do not mix routings
   in one diagram.
6. Arrow heads: length = 3.5x stroke weight, 40 degrees included angle.
   Every arrow head in the diagram identical.
7. Labels inside nodes, max 14 characters. If any label exceeds it,
   shorten the copy — do not shrink the type below the profile floor.
8. ACCEPTANCE TEST: export the frame, scale it to 20% of its pixel
   width, and look at it. Node boundaries and arrow directions must
   still be distinguishable. If they are not, reduce node count.
```

## Execution spec

**HyperFrames.** Nodes are divs, connectors are inline SVG in one absolutely-positioned overlay covering the frame — one SVG, not one per connector, so all connectors share a coordinate space. Arrow heads as a single `<marker>` referenced by every path, which enforces identical geometry:

```html
<svg class="diagram-links" viewBox="0 0 1080 1920" style="position:absolute;inset:0">
  <defs>
    <marker id="ah" markerWidth="14" markerHeight="14" refX="12" refY="7"
            orient="auto" markerUnits="userSpaceOnUse">
      <path d="M0,1 L14,7 L0,13 Z" fill="var(--ink)"/>
    </marker>
  </defs>
  <path d="M540,700 L540,860" stroke="var(--ink)" stroke-width="4"
        fill="none" marker-end="url(#ah)"/>
</svg>
```

`markerUnits="userSpaceOnUse"` is required — the default `strokeWidth` scales the head with the line and breaks the 3.5× lock.

**ffmpeg:** not applicable; this is a composition element.
**Remotion:** same SVG, same marker — the geometry is engine-independent.

## Pairs with
[[motion-annotation-draw-on]] · [[gfx-stroke-weight-and-corner-radius]] · [[gfx-modular-type-scale]] · [[gfx-three-channel-division-of-labour]] · [[gfx-list-card-enumeration]] · [[gfx-vertical-grid-and-margins]]

## Failure modes

- **Too many nodes.** The commonest failure and the least recoverable. Fix: split across beats; the diagram is a sequence, not a picture.
- **Arrow heads scaled by stroke width.** Thin lines get invisible heads, thick lines get blobs. Fix: `markerUnits="userSpaceOnUse"`.
- **Mixed connector routing** in one diagram reads as carelessness. Pick orthogonal or direct.
- **Gap smaller than padding.** Nodes visually merge into one block — Gestalt proximity beats your intent. Measure both.
- **Labels shrunk to fit.** Shrinking below the profile's type floor to accommodate long copy trades legibility for completeness, and the viewer gets neither. Shorten the words.
- **Known gap:** nothing in this stack auto-routes connectors. Node positions and paths are authored geometry; if a node moves, every connector touching it must be updated by hand.
