---
id: motion-overlay-stack-choreography
title: The overlay stack — z-order bands, safe area, and staggered arrival over live footage
skill: motion
type: graphic
family: overlay-stack
tags: [skill/motion, type/graphic, family/overlay-stack, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:48"
    quote: "Next, layer a bunch of visual elements over your footage."
research_refs:
  - https://tech.ebu.ch/docs/r/r095.pdf
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://www.nngroup.com/articles/animation-duration/
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: video
---

# The overlay stack — z-order bands, safe area, and staggered arrival over live footage

## What it is
The additive alternative to cutting: instead of replacing the shot, you stack elements on top of it — a title, a stat, a screenshot card, an arrow, a progress spine, captions — and refresh the frame by bringing them in and out. This note is the composition spec for that stack: which band of z-order each element type occupies, where in the frame it is allowed to sit, how much contrast treatment it needs to survive over arbitrary moving footage, and the arrival choreography that makes three simultaneous elements read as one beat instead of three collisions. The editorial decision to spend an overlay instead of a cut lives in [[pace-overlay-instead-of-cut]]; this is how the stack is actually built.

## When to use it
- **The shot is still worth watching** but the beat needs a new visual event — the A-roll line is important, the presenter is mid-sentence, or the B-roll has 4+ seconds of life left.
- **A number, name, term or URL is spoken** and must be readable, not just heard.
- **You have run out of coverage.** No B-roll for this beat; an overlay is the only visual variety available ([[pace-visual-variety-density-audit]]).
- **The information is comparative or cumulative** — a growing list, a two-up, a labelled screenshot — where cutting away and back would lose the accumulation.
- **Not** when the overlay would cover the presenter's face or the focal point of the shot, and not when three overlays are already live.

## How to recognise it in a reference video
- **Count concurrently visible non-footage elements.** Excluding burned-in captions: **1–3** is the working band; 4+ live at once is a title-card moment, not an overlay stack.
- **Look for band discipline.** Screenshot/card elements sit mid-frame or in one third; small labels hug the same corner every time; captions own the lower band and nothing else enters it.
- **Measure the inset.** Overlay bounding boxes in competent work stay within **5% of each edge** (EBU R95 graphics safe area; 3.5% is action safe). Vertical formats add a bigger bottom reserve (18–22% of height) for platform UI.
- **Look for a scrim.** Any text laid over moving footage almost always has one: a flat black plate at **40–65% opacity**, a **gradient** from ~70% to 0 over 25–35% of frame height, or a **blurred plate** (backdrop blur 12–24 px). Absence of a scrim over busy footage is a fault signal.
- **Time the arrivals.** Elements of one group arrive **3–5 frames apart** (0.1–0.17 s), total group stagger **≤0.5 s**. Arrivals more than ~0.6 s apart are separate beats, not a stack.
- **Entrances are longer than exits.** Typically **0.35–0.5 s in, 0.2–0.3 s out**. If in and out are the same length, log it.
- **Check whether overlays exit at all.** Many stacks are cleared by the next cut rather than an exit animation — this is the correct default in a multi-scene composition.
- **Overlay lifetime:** short label **1.2–2.0 s**; stat card **2.5–4 s**; screenshot with annotation **3–6 s**. Under 1 s nothing is read.
- **Audio track:** each arriving element usually carries a small motion sound (soft whoosh, tick, click) at **−12 to −15 dB**; a whole group often gets **one** sound, not three ([[motion-silent-motion-tier]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `max_concurrent` | 3 | 1–4 | Captions excluded. 4 only for a deliberate "dashboard" beat. |
| `safe_inset` | 5% | 3.5–6% | EBU R95. Applies to the element's full travel, not just its rest pose. |
| `bottom_reserve_vertical` | 20% | 18–22% | 1080×1920 only: platform UI. Keep the caption band above it. |
| `z_band_footage` | 0 | — | Base video. |
| `z_band_scrim` | 10 | 5–19 | Contrast treatment, always directly under its own element. |
| `z_band_cards` | 20 | 20–39 | Screenshots, stat cards, images. |
| `z_band_labels` | 40 | 40–59 | Small text labels, chips, badges. |
| `z_band_annotation` | 60 | 60–79 | Circles, arrows, underlines ([[motion-annotation-draw-on]]). |
| `z_band_captions` | 80 | 80–89 | Burned-in captions. |
| `z_band_transition` | 90 | 90+ | Full-frame transition overlays ([[motion-light-leak-overlay-transition]]). |
| `scrim_opacity` | 0.55 | 0.40–0.65 | Flat plate under text. |
| `scrim_gradient_height` | 30% h | 25–35% | Bottom-up gradient, target colour at zero alpha (never the `transparent` keyword). |
| `contrast_min_text` | 4.5:1 | ≥4.5:1 | Against the darkest and lightest frame the element sits over. |
| `contrast_min_graphic` | 3:1 | ≥3:1 | WCAG 1.4.11 for graphical objects. |
| `entrance_duration` | 0.4 s (12 f) | 0.25–0.6 s | Contract craft band: medium = 0.3–0.5 s. |
| `exit_duration` | 0.25 s (8 f) | 0.15–0.35 s | Entrances need longer than exits. |
| `sibling_stagger` | 0.12 s (4 f) | 0.08–0.17 s | `stagger.each`. |
| `group_stagger_total` | 0.36 s | ≤0.5 s | Hard cap: items × stagger ≤ ~0.5 s. |
| `entrance_offset` | 22 px @1080p | 16–40 px | 1.5–3.7% of frame height. Direction: from the nearest frame edge. |
| `lifetime` | 2.5 s | 1.2–6 s | Under 1.2 s the element is not read. |
| `overlay_events_per_10s` | 3 | 1–6 | Counts toward the transient budget in [[motion-attention-transient]]. |

## Reproduction prompt

```
Build an overlay stack over the existing shot at {{IN}}..{{OUT}} without
cutting away.

LAYOUT. Every element's full travel stays inside a 5% inset from all edges
(add a 20% bottom reserve if the frame is 1080x1920). Assign z-index by band:
scrim 10, cards 20, labels 40, annotation 60, captions 80. Do not use track
index for layering - it is display-only in this engine.

CONTRAST. Any text over footage gets its own scrim directly beneath it at the
same position: a flat plate at 0.55 alpha, or a bottom-up gradient over 30% of
frame height using the target colour at zero alpha (never the transparent
keyword). Verify 4.5:1 for text and 3:1 for graphic marks against both the
brightest and darkest frame in the window.

CHOREOGRAPHY. Order the elements by importance, not DOM order. Arrive them as
ONE beat: translate 22px from the nearest edge plus autoAlpha 0->1, duration
0.4s, ease power3.out, stagger each 0.12s, total stagger <= 0.36s. Start the
first arrival at {{IN}}+0.15s, never exactly at {{IN}}. Give the group ONE
motion sound at the first arrival, -12 to -15 dB, not one per element.

EXIT. Prefer no exit: let the next cut clear the stack. If the stack must
clear inside the shot, exit at 0.25s with autoAlpha to 0 and half the entrance
offset, and land the exit at least 2 frames before the clip's data-duration.

ACCEPTANCE TEST: at most 3 non-caption elements are ever live at once; step
{{IN}}+0.1s .. {{IN}}+0.8s and confirm the arrivals read as one wave; sample
the busiest footage frame under each text element and confirm it is still
legible.
```

## Execution spec

**HyperFrames.** The stack is clips plus z-index; the choreography is one staggered tween set.

```html
<!-- overlay stack over a running shot; layering is CSS z-index, NOT data-track-index -->
<video id="broll" src="assets/broll-01.mp4" muted
       data-start="0" data-duration="8" data-track-index="0"></video>

<div id="stack" class="clip" data-start="2" data-duration="4" data-track-index="2"
     style="position:absolute; inset:0;">
  <div class="scrim" style="position:absolute; left:0; right:0; bottom:0; height:30%;
       z-index:10; background:linear-gradient(to top, rgba(0,0,0,0.72), rgba(0,0,0,0));"></div>
  <div id="stack-card"  style="position:absolute; z-index:20; left:6%; top:14%; width:44%;">…</div>
  <div id="stack-label" style="position:absolute; z-index:40; left:6%; top:62%;">Retention</div>
  <div id="stack-chip"  style="position:absolute; z-index:40; left:6%; top:70%;">+38%</div>
</div>
```

```js
// one beat, three elements. Group start 0.15s after the clip opens.
// 0.4s = 12f @30fps; stagger 0.12s = ~4f; total stagger 0.24s.
tl.fromTo(["#stack-card", "#stack-label", "#stack-chip"],
  { y: 22, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.4, ease: "power3.out",
    stagger: { each: 0.12, from: "start" } },
  2.15);
```

Contract points that bind this:
- **`data-track-index` is display only** — *"It is not read by the render, and it constrains nothing."* Layering is CSS `z-index`. Use track index only as a Studio-readable convention (0 base video, 1+ overlays, 10+ audio).
- The stack wrapper carries `data-start`, so it **clamps its descendants**: children cannot be visible outside the wrapper's window. That is the feature — one attribute clears the whole stack.
- A root-level timed clip is auto-`position:absolute; inset:0`; an **untimed** wrapper is not, and needs its own `position:absolute; inset:0` or it collapses.
- `autoAlpha` (not `display`/`visibility`) and only on non-clip inner elements — the framework owns clip visibility and lint rejects tweening it.
- Lower-third copy that legitimately sits in the caption band needs `data-layout-allow-caption-zone` to pass `check`; prefer it over `data-layout-allow-overflow`, whose blast radius suppresses `text-clipping`, `content-cramped-container` and `foreground-over-panel` for **every descendant**.
- Gradients: no `transparent` keyword (use the target colour at zero alpha), no gradient below 0.15 opacity, and no gradient on elements thinner than 4 px — mandatory if the project uses shader transitions, harmless otherwise.
- Stagger `from: "start"|"end"|"center"|"edges"|index`; order by importance. Cap: items × stagger ≤ ~0.5 s.
- Named rules citable here (do not quote their code): `waterfall-entry`, `depth-scatter-assemble`, `anchored-layout-expand`, `svg-icon-enrichment`.

**ffmpeg.** Only for the audit and for baking a stack into a delivered file:

```bash
# worst-case legibility check: grab the brightest and busiest frames under the stack
ffmpeg -i ref.mp4 -ss 2.0 -t 4 -vf "fps=2,scale=960:-1" /tmp/stack/%03d.png
# baked overlay (leaving the pipeline only): scrim + PNG card
ffmpeg -i base.mp4 -i card.png -filter_complex \
 "[0:v]drawbox=x=0:y=ih*0.7:w=iw:h=ih*0.3:color=black@0.55:t=fill[bg];\
  [bg][1:v]overlay=x=W*0.06:y=H*0.14:enable='between(t,2,6)'" out.mp4
```

**Remotion:** one `<AbsoluteFill>` per band with explicit `zIndex`, and a `delay = index * 4` frames on each child's spring — concept only.

## Pairs with
[[pace-overlay-instead-of-cut]] · [[motion-attention-transient]] · [[motion-annotation-draw-on]] · [[motion-image-focal-point-direction]] · [[motion-list-item-marker-card]] · [[motion-silent-motion-tier]] · [[sfx-air-on-micro-movement]] · [[motion-look-finishing-pass]]

## Failure modes
- **No scrim.** Text over moving footage flickers between legible and illegible as the shot changes luminance. Correction: a plate or gradient bound to the element, checked against the brightest frame in the window.
- **Four or more live elements.** The frame becomes a dashboard and the beat is lost. Correction: cap at 3 non-caption elements; retire one before adding another.
- **Independent arrivals.** Three elements entering 0.8 s apart is three transients and reads as fidgeting. Correction: one staggered group, ≤0.36 s total.
- **Layering by track index.** Silently ignored by the render; painted in CSS order instead, so the overlay ends up behind the footage. Correction: explicit `z-index` bands.
- **Overlay over the face or focal point.** Correction: place opposite the subject; if the subject moves, keep the overlay in the third the subject never enters.
- **Exit animations everywhere.** In a multi-scene composition exits are banned except on the final scene — *"the transition IS the exit."* Correction: let the cut clear the stack.
- **Travel that starts outside the safe area.** The first 3 frames of the entrance are cropped on some players. Correction: start the offset inside the 5% inset.
- **A sound per element.** Three whooshes in 0.36 s is the SFX-overload mistake. Correction: one sound for the group ([[sfx-density-fatigue-audit]]).
