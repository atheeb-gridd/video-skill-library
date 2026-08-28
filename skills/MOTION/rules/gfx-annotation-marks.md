---
id: gfx-annotation-marks
title: Annotation marks — circle, arrow, underline, strikethrough, and why a perfect circle fails
aliases: [gfx-annotation-mark-set]
skill: motion
type: graphic
family: annotation
tags: [skill/motion, type/graphic, family/annotation, engine/hyperframes, engine/remotion, source/editing-kt, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:38"
    quote: "Circles, arrows and underlines."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "n/a"
    quote: "Red strikethrough used consistently as negation — observed across the contact sheet, recorded in _meta/visual-kt-delta.md."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
  - https://en.wikipedia.org/wiki/Principles_of_grouping
difficulty: low
detectable_from: video
---

# Annotation marks — circle, arrow, underline, strikethrough, and why a perfect circle fails

## What it is

Marks drawn *over* existing imagery to point at part of it. Four forms carry almost all the work: **circle** (this thing), **arrow** (that thing, from here), **underline** (this text matters), **strikethrough** (this is wrong).

`[[motion-annotation-draw-on]]` covers the reveal — masking the stroke and revealing it over 6–10 frames. This note covers the mark's geometry, and one non-obvious rule: **a geometrically perfect circle reads as a vector overlay, not as an annotation.** The eye reads annotation as *a human pointed at this*, and perfection destroys that.

## When to use it

When the referent is already on screen and the job is directing attention to part of it. An annotation adds a *pointer*, which no caption can do — a caption can say "the third column" but cannot indicate it (`[[gfx-three-channel-division-of-labour]]`).

Never as decoration. An annotation on a frame with one obvious subject tells the viewer you did not trust them.

## How to recognise it in a reference video

- **Stroke weight** in px at 1080 wide. Annotation stroke is typically *heavier* than diagram stroke — it sits over busy imagery.
- **Circle closure.** Does the stroke overshoot past its start point, or close exactly? Overshoot = hand-drawn intent. Measure the overshoot as a % of circumference.
- **Circle eccentricity.** Perfectly round, or slightly ovoid? Note the ratio.
- **Arrow-head proportion** relative to stroke weight.
- **Colour.** One accent for attention, and check whether a *second* colour is reserved for negation. This library's reference creator uses **red strikethrough as negation** consistently enough to be a rule.
- **Strikethrough position** as a fraction of cap height from the baseline.
- **Underline offset** below the baseline, in px, and whether it clears descenders.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `stroke_weight` | 6 px @1080w | 5–10 px | Heavier than diagram stroke — it competes with footage. |
| `circle_overshoot` | 8 % of circumference | 5–15 % | The single detail that sells "hand-drawn". 0 % reads as vector. |
| `circle_eccentricity` | 1.15 : 1 | 1.05–1.3 : 1 | Slightly ovoid. A true circle looks machine-made. |
| `circle_margin` | 0.4× subject width | 0.25–0.6× | Too tight strangles the subject; too loose points at nothing. |
| `arrowhead_len` | 3.5× stroke | 3–4× stroke | Same lock as `[[gfx-diagram-primitives]]` — one system. |
| `underline_offset` | 0.18× cap height | 0.12–0.25× | Must clear descenders or it reads as a strikethrough on the line below. |
| `strike_position` | 0.42× cap height | 0.38–0.5× | Above true centre — optical centre of lowercase sits high. |
| `strike_weight` | 0.09× cap height | 0.07–0.12× | Scale with type, not with the frame. |
| `colour_attention` | accent | — | From `[[gfx-palette-ground-ink-accent]]`. |
| `colour_negation` | red | — | Reserved. If red also means "attention" the negation signal is dead. |

## Reproduction prompt

```
Annotate {{SUBJECT}} in the frame at {{OUT_TC}} with a {{MARK_TYPE}}.

1. Pick the colour by MEANING, not by contrast: accent for attention,
   red for negation. If the profile uses red for both, negation loses
   its signal — raise this rather than proceeding.
2. Stroke weight 6px at 1080 wide, scaled proportionally at other
   widths. Verify contrast >= 3:1 against the busiest region the mark
   crosses, sampling the actual frame, not an average.
3. CIRCLE: draw as an ellipse at 1.15:1, long axis following the
   subject's long axis. Margin 0.4x the subject's width. Overshoot the
   start point by 8% of circumference — do NOT close it exactly.
4. ARROW: single segment, no curve unless avoiding an obstruction. Head
   length 3.5x stroke weight, 40 degrees included. Tail starts in empty
   frame, not on another element.
5. UNDERLINE: offset 0.18x cap height below baseline; confirm it clears
   every descender in the underlined run.
6. STRIKETHROUGH: 0.42x cap height above baseline, weight 0.09x cap
   height, extending 0.1x cap height past the text on both sides.
7. Hand off the reveal to [[motion-annotation-draw-on]]. Do not animate
   here.
8. ACCEPTANCE TEST: view the frame at 20% scale. The mark must still
   read as pointing at ONE thing. If ambiguous, the margin is too loose.
```

## Execution spec

**HyperFrames.** Inline SVG over the media element. Use `stroke-dasharray`/`stroke-dashoffset` for the draw-on so the geometry here and the motion there stay separable.

```html
<svg viewBox="0 0 1080 1920" style="position:absolute;inset:0;pointer-events:none">
  <!-- overshoot: sweep past the start angle rather than closing the path -->
  <path d="M 620 780 A 180 156 0 1 1 619 779 A 180 156 0 0 1 660 800"
        fill="none" stroke="var(--accent)" stroke-width="6"
        stroke-linecap="round"/>
</svg>
```

Two arcs, the second a short continuation past the start point, is how you get overshoot without hand-drawing a path. `stroke-linecap="round"` matters — butt caps read mechanical.

**Negation red** should be a distinct token (`--negate`), never `--accent`, so a palette change cannot collapse the two meanings.

**Remotion:** identical SVG.

## Pairs with
[[motion-annotation-draw-on]] · [[gfx-diagram-primitives]] · [[gfx-palette-ground-ink-accent]] · [[gfx-contrast-over-moving-footage]] · [[gfx-three-channel-division-of-labour]] · [[gfx-label-callout-over-footage]]

## Failure modes

- **The perfect circle.** Reads as a template overlay. Fix: 8 % overshoot, 1.15 : 1 ellipse.
- **Red doing double duty.** If red means both "look here" and "this is wrong", neither lands. Reserve it.
- **Underline colliding with descenders.** Reads as a strikethrough on the wrong line. Fix: measure against the actual glyphs.
- **Annotating the obvious.** A circle around the only object in frame is noise, and it teaches the viewer to ignore the next one.
- **Stroke too thin over busy footage.** Survives your monitor, dies after platform re-encode. Fix: 5 px floor at 1080, and sample contrast on the busiest crossing.
- **Arrow tail starting on another element**, which makes the arrow look attached to it. Start tails in empty frame.
