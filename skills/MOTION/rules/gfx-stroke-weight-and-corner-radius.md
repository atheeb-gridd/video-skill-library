---
id: gfx-stroke-weight-and-corner-radius
title: Stroke and radius are one system — four stroke rungs derived from the type, and the concentric radius rule
skill: motion
type: graphic
family: visual-system
tags: [skill/motion, type/graphic, family/visual-system, engine/hyperframes, engine/ffmpeg, engine/remotion, source/sfx-kt-2, source/editing-kt, source/hyperframes, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "visual — contact sheet, concept cards"
    quote: "[NOT SPOKEN — observed on screen] A 50/50 pie chart with thin leader lines; an isolated waveform inside a rounded rectangle; a circular arc with diamond nodes — all stroke-only, all at one apparent weight."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "visual — contact sheet, annotation"
    quote: "[NOT SPOKEN — observed on screen] Hand-drawn white curved arrows annotating B-roll — a slightly wobbly, variable-width curve, visibly heavier than the diagrammatic strokes elsewhere."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: ".caption-box — padding: 12px 32px; border-radius: 24px."
research_refs:
  - https://www.designsystems.com/iconography-guide/
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://developer.mozilla.org/en-US/docs/Web/CSS/border-radius
  - https://legibility.info/rules-for-text-in-videos
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: video
---

# Stroke and radius are one system — four stroke rungs derived from the type, and the concentric radius rule

## What it is

Two quantities that look like details and are actually the reason a graphic set reads as one system or as a pile of assets. Both are **derived**, neither is chosen.

### Stroke: four rungs, anchored on the type's stem width

The mistake is to pick stroke widths in pixels. A pixel value is wrong at the other resolution, wrong at the other aspect, and — worse — has no relationship to the type it sits beside, so an icon looks bolder or thinner than the word next to it for no reason anybody can name.

The anchor is the **stem width of the body type**. A 700-weight grotesque has a stem-to-cap ratio of about 0.15 ([[gfx-weight-and-optical-size]]); at step `s0` (4.5 % of frame height, cap height 3.24 %) the stem is `0.15 × 3.24 = 0.49 %` of frame height. Round to **0.45 u** and that is the rung an icon must sit on to match its label. Everything else is a ratio off it:

| Rung | Width | px @1080 tall | px @1920 tall | Ratio to previous | Used for |
|---|---|---|---|---|---|
| `hair` | 0.15 u | 1.6 → **2** | 2.9 → **3** | — | Dividers, table rules, grid lines, axis lines |
| `thin` | 0.28 u | 3.0 | 5.4 | 1.87× | Diagram geometry, leader lines, chart strokes, connectors |
| `body` | 0.45 u | 4.9 | 8.6 | 1.61× | Icons matched to `s0` type, node borders, arrow shafts, progress bars |
| `mark` | 0.70 u | 7.6 | 13.4 | 1.56× | Annotation marks over footage, hand-drawn arrows, underlines |

The rung ratios sit at **1.55–1.9×**, which is deliberately above the 1.4× discrimination floor the type scale uses: two stroke weights closer than that read as one weight applied carelessly. Four rungs is the whole vocabulary; a fifth is drift.

**The 2 px absolute floor is not superstition.** A 1 px line at the render resolution does not survive H.264: the deblocking filter treats a one-pixel luminance step as a block artefact and softens it, and on a saturated accent 4:2:0 chroma subsampling halves the colour resolution across the line. A hairline that measures 1 px at 1080 will shimmer between frames and vanish in the darker parts of the ramp. Clamp every rung to a minimum of 2 px at the *render* resolution, and remember that a `--resolution` supersample is uniform, so a design that clears 2 px at 1080 clears 4 px at 4K for free.

**`thin` validates against the reference material.** [[motion-abstract-concept-card]] records a `3 px` visual stroke at 1080, which is `0.28 u` exactly — the `thin` rung. [[motion-annotation-draw-on]] records `6–10 px` at 1080 for the hand-drawn arrow, which is `0.56–0.93 u`, straddling the `mark` rung at `0.70 u`. Two independently-observed values land on two rungs of one ladder.

### Radius: one style, and the concentric rule

**Pick one corner style for the whole video** — square (`0`), small (a stated radius), or pill (`999px`) — and apply it to every rectangle. Mixing a 4 u card radius with a 1 u chip radius is the untokenised-design smell; mixing square cards with pill chips is a deliberate two-register decision that has to be written down or it reads as an accident.

Radius is expressed in two different units depending on what the box is:

- **A box that wraps type** takes its radius in `em` of its own type, so the plate scales with the text. The reference caption plate is `border-radius: 24px` at `font-size: 48px` = **0.5 em**, and that is the house value. A pixel radius on a type-wrapping box is exactly the tell the subtitles library names: *"A design where radius is a fixed pixel value while type size changes has been re-typed per object."*
- **A box that does not wrap type** — a card, a panel, an image mask — takes its radius in `u`: `1.5 u` for a card, `2.5 u` for a full-frame panel, `0` for a diagram node unless the whole set is rounded.

**The concentric rule is geometry, not preference.** When one rounded box sits inside another with padding `p`, the inner radius must be `outer_radius − p` for the two arcs to stay concentric. Get it wrong and the gap between the two curves varies around the corner — a distortion the eye reads instantly as "cheap" without being able to say why. If `outer − p ≤ 0`, the inner box is square. There is no third option.

**Stroke and radius interact, and the interaction has a floor.** A stroked box's radius must be at least `2 × stroke_width`, or the corner arc is shorter than the stroke is wide and the join renders as a blob. At the `body` rung (0.45 u) that means a minimum radius of 0.9 u on any stroked box.

## When to use it

- **Once per style profile**, as four stroke tokens and two-to-three radius tokens, written down with their derivations.
- **Whenever an icon is placed next to a word.** The icon's stroke goes on the `body` rung, matched to that word's step — an icon beside `s2` type needs a stroke scaled to `s2`'s stem, not the `s0` value ([[gfx-icon-system-and-weight-match]]).
- **Whenever a diagram is built.** Nodes take `body`, connectors take `thin`, and the difference is what makes the connectors read as connectors ([[gfx-diagram-node-geometry]], [[gfx-diagram-connector-geometry]]).
- **Whenever a stroke crosses onto footage.** A `thin` line at 3:1 against a card ground can drop below 3:1 against footage, and WCAG 1.4.11 wants 3:1 for the parts of a graphic needed to understand it. Over footage, promote one rung or add a backing — do not just change the colour.
- **Not** as a way to fix legibility. A heavier stroke on a mark over footage is the same mistake as a heavier type weight ([[gfx-contrast-over-moving-footage]]).
- **Not** per component. A component picks rungs; it does not pick widths.

## How to recognise it in a reference video

- **Count distinct stroke widths in the graphic layer.** Pull a native-resolution frame per component and measure every stroke in pixels. **2–4 distinct values** ⇒ a system. **5+** with no ratio between them ⇒ strokes chosen per object.
- **Divide the widths and look for a ratio.** A designed ladder shows consecutive ratios of 1.5–1.9×. Ratios of 1.1–1.3× mean two rungs are doing one job and the difference will not read.
- **Normalise by cap height, not by frame.** Measure the stroke of an icon and the stem width of the word beside it. **A matched pair is within ±15 %.** This is the measurement that catches the commonest icon fault: an outline icon at 1.5 px beside 700-weight type at a 6 px stem, which reads as a different, lighter voice.
- **Check the hairline in pixels at native resolution.** Under 2 px ⇒ it will shimmer. Look at two consecutive frames of the same static graphic: a sub-2 px line visibly changes value between them.
- **Measure radius and divide by cap height.** A *constant ratio* across objects of different type sizes ⇒ radius came out of a token set. **Constant pixels** across different type sizes ⇒ each object was typed by hand. This is the sharpest single test for whether a design system exists.
- **Check concentricity.** Find any nested rounded pair — a chip inside a card, an image inside a panel. Measure the gap between the two curves at the corner apex and at the straight run. **Equal ⇒ concentric.** Unequal ⇒ the inner radius was guessed, and it will be the same guess everywhere.
- **Check the stroke/radius floor.** On any stroked rounded box, is the radius at least twice the stroke width? Below that the corner joins look thickened.
- **Look for mixed corner styles.** Square cards with pill chips is legal *if* consistent; square cards with rounded cards is not.
- **Look for stroke-only versus filled discipline.** The observed diagram vocabulary is stroke-only throughout (pie with leader lines, arc with nodes, waveform in a rounded rectangle). Mixing stroked and filled icons in one set is the published-guidance failure: *"don't mix both styles in the same set."*

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `stroke_rungs` | 4 | 3–4 | `hair`, `thin`, `body`, `mark`. A fifth is drift. |
| `stroke_hair` | 0.15 u | 0.12–0.18 u | Dividers, rules, axes. Clamp to ≥2 px at render resolution. |
| `stroke_thin` | 0.28 u | 0.24–0.32 u | Diagram geometry, connectors, chart strokes. Matches the observed 3 px @1080. |
| `stroke_body` | 0.45 u | 0.40–0.52 u | Derived: `0.15 × cap height of s0` = `0.15 × 3.24 u`. The icon-matches-type rung. |
| `stroke_mark` | 0.70 u | 0.60–0.95 u | Annotation over footage. Straddles the observed 6–10 px @1080. |
| `rung_ratio` | 1.6× | ≥1.5× | Above the 1.4× discrimination floor, so two rungs read as two. |
| `px_floor` | 2 px at render resolution | ≥2 px | Below this, deblocking softens the line and 4:2:0 subsampling eats a saturated one. It shimmers frame to frame. |
| `stroke_matches_type` | ±15 % of stem width | ±15 % | For any icon sitting beside a word. Scale the rung to that word's step. |
| `stroke_over_footage` | +1 rung, or a backing | — | 3:1 (WCAG 1.4.11) against the worst frame, not the mean. |
| `stroke_style` | stroke-only | stroke-only / filled | One style per set. Never mixed. |
| `linecap` | round | round / butt | One value per project. Round reads friendlier and hides a wobble. |
| `linejoin` | round | round / miter | Miter on a sharp angle spikes; cap it or use round. |
| `radius_style` | small | square / small / pill | One per video. A second style needs a written register rule. |
| `radius_type_box` | 0.5 em | 0–0.75 em | Boxes that wrap type. The reference plate's `24px` at `48px`. **In `em`, never px.** |
| `radius_card` | 1.5 u | 1–2.5 u | Boxes that do not wrap type. |
| `radius_panel` | 2.5 u | 2–4 u | Full-frame or near-full-frame panels. |
| `radius_node` | 0 | 0–1 u | Diagram nodes. Square unless the whole set is rounded. |
| `radius_concentric` | `outer − padding` | exact | Geometry, not taste. If `≤ 0`, the inner box is square. |
| `radius_vs_stroke` | ≥2 × stroke | ≥2× | Below this the corner join renders as a blob. |
| `radius_in_px` | forbidden outside tokens | — | A px radius on a type-wrapping box is the untokenised-design smell. |
| `dash_patterns` | 1 | 0–1 | At most one dash pattern in the whole video, with a stated meaning (usually "provisional" or "inferred"). Two dash patterns is two vocabularies. |
| `dash_length` | 2× stroke on, 1.5× off | — | Expressed in multiples of the stroke, so it scales. |

## Reproduction prompt

```
Produce the stroke and radius tokens for {{PROJECT}}, whose type scale and
weights are already fixed.

1. DERIVE THE STROKE ANCHOR, do not choose it. Take the cap height of type step
   s0 as a percentage of frame height (typically 3.24%) and multiply by the
   face's stem-to-cap ratio (typically 0.15 for a 700 grotesque). That product,
   rounded, is the `body` stroke rung - the width at which an icon looks like it
   belongs beside body type. Then build four rungs at ~1.6x apart:
     hair 0.15u   dividers, rules, axes
     thin 0.28u   diagram geometry, connectors, chart strokes
     body 0.45u   icons matched to s0 type, node borders, arrow shafts
     mark 0.70u   annotation marks over footage, underlines
   Keep the ratio between rungs at or above 1.5x: below 1.4x two rungs read as
   one weight applied carelessly.

2. CLAMP EVERY RUNG TO >= 2px at the RENDER resolution. A 1px line does not
   survive H.264: the deblocking filter softens a one-pixel luminance step and
   4:2:0 chroma subsampling halves the colour resolution across a saturated
   line, so it shimmers between frames and disappears in the dark parts of the
   ramp. Emit the px value at every shipping resolution as a check.

3. SCALE THE STROKE TO THE TYPE IT SITS BESIDE. An icon next to step s2 type
   takes a stroke scaled to s2's stem width, not the s0 value. Emit the rung per
   step, not one global number.

4. PICK ONE CORNER STYLE for the whole video: square, small, or pill. Then emit
   the radius tokens in the right unit for each kind of box:
     boxes that WRAP TYPE       -> radius in em of their own type (house 0.5em)
     boxes that do NOT wrap type -> radius in u (card 1.5u, panel 2.5u, node 0)
   A pixel radius on a type-wrapping box is the single sharpest sign that a
   design was typed per object rather than tokenised.

5. APPLY THE CONCENTRIC RULE wherever one rounded box sits inside another:
     inner_radius = outer_radius - padding
   If that is <= 0, the inner box is square. This is geometry - it is what keeps
   the two arcs concentric so the gap between them is constant around the corner.

6. APPLY THE STROKE/RADIUS FLOOR: any stroked rounded box needs
   radius >= 2 x stroke_width, or the corner join renders as a blob.

7. OVER FOOTAGE, promote strokes one rung OR add a backing, and verify 3:1
   (WCAG 1.4.11 non-text contrast) against the WORST frame in the element's
   window - not the mean. Do not solve it by making the stroke heavier and
   leaving the colour alone; that is the same error as fixing type legibility
   with weight.

ACCEPTANCE TEST:
(a) count distinct stroke widths in the emitted CSS/SVG - 4 or fewer passes;
(b) every rung's px value at every shipping resolution is >= 2;
(c) for each icon-beside-word pair, measured stroke width is within 15% of the
    measured stem width of that word;
(d) grep for `border-radius` with a px value outside the token block - zero
    matches passes;
(e) for every nested rounded pair, inner radius == outer radius - padding
    exactly;
(f) every stroked rounded box has radius >= 2 x its stroke;
(g) render two consecutive frames of a static graphic and diff them - a
    hairline that changes value between them is under the px floor.
```

## Execution spec

**HyperFrames.** Tokens on the root; SVG consumes them through `stroke-width`, boxes through `border-radius`.

```css
[data-composition-id="gfx"]{
  --u: calc(var(--fh) / 100 * 1px);
  /* four rungs, each clamped to the 2px render floor */
  --sw-hair: max(2px, calc(0.15 * var(--u)));
  --sw-thin: max(2px, calc(0.28 * var(--u)));
  --sw-body: max(2px, calc(0.45 * var(--u)));
  --sw-mark: max(2px, calc(0.70 * var(--u)));
  /* radius: em for type boxes, u for everything else */
  --r-type:  0.5em;
  --r-card:  calc(1.5 * var(--u));
  --r-panel: calc(2.5 * var(--u));
  --r-node:  0px;
}
[data-composition-id="gfx"] .rule  { height: var(--sw-hair); background: var(--hairline); }
[data-composition-id="gfx"] .chip  { border-radius: var(--r-type); padding: 0.25em 0.67em; }
[data-composition-id="gfx"] .card  { border-radius: var(--r-card); padding: calc(2 * var(--u)); }
/* concentric: a chip inside a card with 2u padding */
[data-composition-id="gfx"] .card > .inner {
  border-radius: max(0px, calc(var(--r-card) - 2 * var(--u)));
}
[data-composition-id="gfx"] svg .geo  { fill:none; stroke:var(--ink);   stroke-width:var(--sw-thin);
                                        stroke-linecap:round; stroke-linejoin:round; }
[data-composition-id="gfx"] svg .icon { fill:none; stroke:currentColor; stroke-width:var(--sw-body); }
```

Constraints:

- **SVG is the right primitive for anything stroked** — it scales, it is one file, and its stroke can read a CSS custom property. Set `vector-effect="non-scaling-stroke"` **only if** you intend the stroke to stay constant while the shape scales; without it, a `scale` tween on an SVG group scales the stroke too, which is usually what you want for an entrance and never what you want for a persistent diagram.
- **Animate `stroke-dashoffset`, never geometry.** It is a legitimate non-transform property because it does not force layout — the mechanism behind every draw-on. Set `stroke-dasharray` to the path length once at setup; do **not** call `getTotalLength()` at tween time, in line with *"compute coordinates once at composition setup and reuse."*
- **Never tween `stroke-width`.** It re-rasterises the path every frame and, on a scaled group, interacts with `vector-effect` unpredictably. If a stroke must appear to thicken, scale the group or cross-fade two paths.
- **`width`/`height`/`top`/`left` tweens are forbidden**, so a box that must grow uses `scaleX`/`scaleY` — which distorts a `border-radius` and a stroke. For a genuinely resizing rounded box, the contract's own answer is the `anchored-layout-expand` rule (cited by name; its code is not staged). Alternatively give the box `0` radius while it grows.
- **A CSS `transform` on a GSAP-tweened element raises `gsap_css_transform_conflict`** (error), and a lint error disables the layout and contrast audits, after which `check` reports `0 sample(s)` and `0/0 text checks`.
- **`max()` inside `calc()` is fine in Chrome**, which is the render engine — but resolve the clamped px values into the profile document so the 2 px floor is auditable rather than implicit.
- **No gradient on an element thinner than 4 px**, and no gradient stop below `0.15` opacity — which effectively means hairlines and thin strokes are flat colours, never gradients. Mandatory if the project uses shader transitions.
- Named animation rules citable here without quoting their code: `svg-path-draw`, `svg-icon-enrichment`, `anchored-layout-expand`.

**ffmpeg — the shimmer test**, which is the only stroke check that needs motion:

```bash
# two consecutive frames of a static graphic; a sub-2px line changes value between them
ffmpeg -ss 96.50 -i out.mp4 -frames:v 1 -q:v 2 /tmp/s/a.png
ffmpeg -ss 96.533 -i out.mp4 -frames:v 1 -q:v 2 /tmp/s/b.png
ffmpeg -i /tmp/s/a.png -i /tmp/s/b.png -filter_complex "blend=all_mode=difference" -update 1 /tmp/s/d.png
```

**Remotion.** Same tokens as constants; `strokeWidth={height * 0.0045}` and the concentric radius computed in JS. Nothing here is stack-specific except the lint rules.

## Pairs with
[[gfx-modular-type-scale]] · [[gfx-weight-and-optical-size]] · [[gfx-icon-system-and-weight-match]] · [[gfx-palette-ground-ink-accent]] · [[gfx-diagram-node-geometry]] · [[gfx-diagram-connector-geometry]] · [[gfx-annotation-mark-set]] · [[gfx-plate-and-scrim-ladder]] · [[motion-annotation-draw-on]] · [[motion-abstract-concept-card]] · [[sub-caption-plate-geometry]]

## Failure modes
- **Stroke widths in pixels.** Wrong at the other resolution, wrong at the other aspect, and unrelated to the type beside them.
- **An icon lighter than its label.** A 1.5 px outline icon beside a 700-weight word. The icon reads as a different voice, and nobody can say why the row looks wrong.
- **Five stroke widths.** Or four widths whose ratios are 1.2×, which is the same thing with extra steps.
- **A 1 px hairline.** Shimmers frame to frame under H.264 and vanishes in dark regions. The floor is 2 px at the render resolution.
- **A pixel radius on a type-wrapping box.** The sharpest single sign of an untokenised design: change the type size and the plate's proportions change.
- **Non-concentric nesting.** The gap between two rounded boxes varies around the corner. Instantly reads as cheap; nobody can name it.
- **Radius smaller than twice the stroke.** The corner join thickens into a blob.
- **Mixed corner styles without a rule.** Rounded cards and square cards in one video reads as two designs.
- **Mixed stroked and filled icons.** The published guidance is explicit; the set stops reading as a set.
- **A stroke promoted to fix contrast over footage.** Same error as fixing type with weight: it raises the mean and does nothing at the failing frames.
- **Two dash patterns.** Two vocabularies for "different from solid", and now the viewer has to work out which is which.
- **`scaleX` on a rounded stroked box.** Distorts both the radius and the stroke; the box arrives looking like a different component.
- **Known gap:** the 2 px floor is derived from how H.264 deblocking and 4:2:0 subsampling behave, not from a published threshold for this pipeline. It is conservative and it has been chosen to be safe at social bitrates; a high-bitrate master will carry a thinner line. Verify on the encoded deliverable with the difference test rather than trusting the number.
