---
id: gfx-icon-system-and-weight-match
title: Icons that match the type — one style, one stroke rung, and the three cases where an icon beats a word
skill: motion
type: graphic
family: visual-system
tags: [skill/motion, type/graphic, family/visual-system, engine/hyperframes, engine/remotion, source/editing-kt, source/sfx-kt-2, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "visual — contact sheet, doodle inserts"
    quote: "[NOT SPOKEN — observed on screen] Flat vector doodle illustrations — a cartoon face on mint green, a filmstrip-and-scissors icon in outline style on a purple/blue gradient — intercut with dense screen recordings."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "visual — contact sheet, concept cards"
    quote: "[NOT SPOKEN — observed on screen] A waveform glyph set beside the label 'Vocals Vol / −3 to 0dB' — the glyph carries 'this is audio' and the type carries the number."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "visual — contact sheet, concept cards"
    quote: "[NOT SPOKEN — observed on screen] One abstract visual per card in a single muted accent — a pie, an arc with diamond nodes, a waveform — never a photograph, never two visuals."
research_refs:
  - https://www.designsystems.com/iconography-guide/
  - https://primer.style/octicons/design-guidelines/
  - https://en.wikipedia.org/wiki/Dual-coding_theory
  - https://edtechuvic.ca/wp-content/uploads/sites/11/2022/09/principles-for-reducing-extraneous-processing-in-multimedia-learning-coherence-signaling-redundancy-spatial-contiguity-and-temporal-contiguity-principles.pdf
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
difficulty: medium
detectable_from: video
---

# Icons that match the type — one style, one stroke rung, and the three cases where an icon beats a word

## What it is

Two separate problems that get treated as one. **Whether to use an icon at all** is an information-design question with a defensible answer. **How to draw it so it belongs** is a geometry question with an exact answer. This note settles both.

### When an icon beats a word — three cases, and only three

An icon is a **fast, imprecise** signifier. It is recognised in less time than a word is read and it is understood less precisely. That trade is worth taking in exactly three situations:

1. **The referent is a physical thing or a well-worn convention** and the word for it is longer than the picture. A waveform means "audio" instantly; the word "audio" is not faster and is less specific about *which* audio. A play triangle, a magnifier, a trash can, a lock, a filmstrip, a microphone. If the convention is not already in the viewer's head, an icon does not put it there — it just costs a beat.
2. **The same slot repeats and the label would repeat with it.** In a list of five rows each carrying a category, five identical words is noise and five distinguishable glyphs is a scan. This is the case where icons genuinely earn their keep, because the value is in the *difference between them*, not in any one of them.
3. **The label would collide with the type system.** A 12-character word at `s-1` in a 13 %-wide column does not fit; a glyph in a `2.4 u` box does. This is a real and common case in 9:16, where the columns are narrow.

And the cases where an icon loses, which are more numerous:

- **The referent is abstract.** There is no icon for "retention", "consistency", "leverage" or "the algorithm". A generic gear, lightbulb, rocket or target next to an abstract noun carries zero information and reads as a template. The correct object for an abstract concept is a card whose *visual asserts something* — a proportion, a cycle, a relation ([[motion-abstract-concept-card]]).
- **The icon would be the only thing in the slot.** An unlabelled icon is a guess. Published icon guidance treats the label as the meaning and the icon as the accelerator.
- **It is decoration.** An icon added because the row looked empty is the seductive-detail class that measures against you: Mayer's coherence principle carries a median **d = 0.86 across 23 studies, supported 23 of 23**, and it says remove what does not serve the goal.

**Icon plus label is the default pairing, not icon alone.** The gain is real — dual coding gives two retrieval routes rather than one — but it is a gain on top of the word, not instead of it.

### How to draw it so it belongs — the geometry

**Stroke weight is the whole game.** An outline icon whose stroke is lighter than the stem of the word beside it reads as a different voice, and this is the single most common icon failure in video graphics. The rule from [[gfx-stroke-weight-and-corner-radius]]: the icon's stroke sits on the `body` rung **scaled to the step of the type it accompanies**, and the target is the measured stem width of that type **within ±15 %**. Beside `s0` type that is `0.45 u`; beside `s2` type it is `0.45 × (7.03 ÷ 4.50) = 0.70 u`.

**One style for the whole set**, and the published guidance is blunt about which choices are closed: strokes all at one weight; do not mix stroked and filled icons in one set; one corner treatment (mitered, beveled or rounded) across the set; a maximum of two colours, and three or more makes it an illustration rather than an icon; internal filled shapes proportional to the stroke — *"if you have a stroke weight of 2px, you don't want filled shapes that are bigger than 4x4px"*; and the space between two strokes must never be thinner than the stroke itself. That last one is the constraint that kills detail: at video sizes it means an icon can carry about four strokes across its box and no more.

**Optical sizing: build large, simplify down.** Published guidance is to start at the largest size and *remove* detail as the icon gets smaller, never to add detail as it grows. In this pipeline the relevant "size" is the frame-height percentage, and the practical rule is that an icon below about `2 u` of box height must be a silhouette — one closed shape, no interior strokes.

**The box, the keyline, and optical alignment.** Icons live in a square box whose side is set from the type: `icon_box = 1.6 × cap height` of the accompanying step. The *drawn* content occupies a keyline area inset by the stroke width (published guidance: padding equal to the stroke weight, or double it for a 1 px stroke), so that a circular icon and a square icon at the same nominal size read as the same size — a circle inscribed in the same box as a square looks smaller, which is why keyline shapes exist. And the icon is **optically centred to the type's cap height, not to its line box**: align the icon box's centre to the midpoint of the cap height, which sits above the line-box centre by roughly `(ascender − cap) ÷ 2`.

## When to use it

- **Once per style profile**, as a style declaration plus a stroke rung per step plus a closed inventory of glyphs actually used.
- **When designing a list, a comparison or a step indicator** — the repeating-slot case, where icons do real work.
- **When a label does not fit a 9:16 column** — the geometry case.
- **Not** beside an abstract noun. Use a card whose visual asserts something instead.
- **Not** without a label, except in a step indicator where position carries the meaning.
- **Not** more than about **six distinct glyphs** in one video. Past that the set stops being learnable and each glyph is just a small picture.
- **Not** as a mixed set. If one icon in the video is filled, they all are.

## How to recognise it in a reference video

- **Measure stroke against stem.** Pull a native-resolution frame; measure the icon's stroke width and the stem width of the adjacent word. **Within ±15 % ⇒ matched.** The icon lighter than the type is the standard failure; the icon heavier than the type is rarer and reads as a badge.
- **Count styles.** Are all icons stroked, or all filled? A mixed set is a mixed set even if each icon is good.
- **Count colours per icon.** 1 is a product icon, 2 is a marketing icon, **3+ is an illustration** — which is a legitimate different object (the observed flat-vector doodles are illustrations, not icons) but must not sit in an icon slot beside real icons.
- **Count distinct glyphs across the video.** ≤6 ⇒ a set. 12+ ⇒ a stock library was opened.
- **Check the box, not the drawing.** Measure the bounding box of several icons. A designed set has **equal boxes** and unequal drawn extents (the keyline at work). Equal drawn extents and unequal boxes means no keyline and the round icons will look small.
- **Check the interior stroke gaps.** Zoom to 300 %. Any gap thinner than the stroke will close under compression, and that is where an icon turns into a smudge.
- **Check vertical alignment against cap height.** Overlay a horizontal line at the cap midpoint of the adjacent word. A matched icon's box centre sits on it. Alignment to the line-box centre puts the icon visibly low.
- **Check whether the icon is doing work.** Cover the icon. If the row still says the same thing, the icon is decoration. Do this on every icon in the reference and count how many survive — that ratio is a better style-profile fact than the glyph names.
- **Check whether the icon set is one *voice*.** Same terminal treatment (round vs flat), same corner radius on internal rectangles, same optical weight for a dense glyph and a sparse one. A dense glyph drawn at the same stroke as a sparse one *looks* heavier; a designed set thins the dense one very slightly or simplifies it.
- **Contrast:** an icon is a graphical object, so 3:1 (WCAG 1.4.11) against whatever is behind it, at the worst frame — not the mean.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `style` | stroked | stroked / filled | One per project. Published guidance: never mixed in a set. |
| `stroke_rung` | `body`, scaled to the accompanying step | — | `0.45 u` beside `s0`; `0.45 × (step ÷ s0)` elsewhere. |
| `stroke_match_tolerance` | ±15 % of stem width | ±15 % | The measurable target. This is the whole "belongs" test. |
| `stroke_uniformity` | 1 width per icon | 1 | Every stroke in one glyph is the same width. |
| `icon_box` | 1.6 × cap height | 1.4–1.8× | Square. Beside `s0` (cap 3.24 u) that is `5.2 u`. |
| `keyline_inset` | 1 × stroke width | 1–2× | Published: padding equal to the stroke, double for a 1 px stroke. Makes circles and squares read as one size. |
| `min_interior_gap` | 1 × stroke width | ≥1× | Published constraint. Anything tighter closes under compression. |
| `max_strokes_across` | 4 | 3–5 | Falls out of the interior-gap rule at video sizes. |
| `silhouette_below` | 2 u of box height | — | Below this, one closed shape, no interior strokes. |
| `colours_per_icon` | 1 | 1–2 | 3+ makes it an illustration, which is a different object. |
| `glyph_inventory` | ≤6 | 3–8 | Closed list, written into the profile. |
| `corner_treatment` | rounded | mitered / beveled / rounded | One across the set, with equal radius on all internal rectangles. |
| `linecap` / `linejoin` | round | round / butt+miter | Same values as the diagram geometry; icons and diagrams are one vocabulary. |
| `vertical_alignment` | cap-height midpoint | — | Not the line-box centre, which sits the icon visibly low. |
| `gap_icon_to_label` | 0.45 × cap height | 0.35–0.6× | In `em` of the label's own type so it scales. |
| `label_required` | yes | yes / no | `no` only in a step indicator, where position carries meaning. |
| `abstract_noun_icons` | forbidden | — | No gears, lightbulbs, rockets or targets beside abstract nouns. Use a card with an asserting visual. |
| `contrast_vs_background` | ≥3:1 | ≥3:1 | WCAG 1.4.11, at the worst frame in the icon's window. |
| `cover_test_pass_rate` | 100 % | 100 % | Cover the icon: the row must lose something. |
| `animation` | none, or one draw-on | — | An icon that animates every time it appears is a tic. Draw-on ≤0.35 s, once, on first appearance only ([[motion-annotation-draw-on]]). |

## Reproduction prompt

```
Specify the icon system for {{PROJECT}}, whose type scale, weights and stroke
rungs are already fixed.

1. DECIDE PER SLOT WHETHER AN ICON IS EARNED. An icon is fast and imprecise.
   Use one ONLY in these three cases:
     (a) the referent is a physical thing or a worn convention (waveform, play,
         lock, filmstrip, microphone) AND the picture is faster than the word;
     (b) the slot REPEATS and the labels would repeat with it - a list of five
         categories, where the value is the difference between the glyphs;
     (c) the label does not fit the column - a 12-character word at s-1 in a 13%
         column of a 9:16 frame.
   Reject an icon when the referent is ABSTRACT. There is no icon for retention,
   consistency, leverage or "the algorithm"; a gear, lightbulb, rocket or target
   beside an abstract noun carries zero information and reads as a template. The
   correct object there is a card whose visual ASSERTS something - a proportion,
   a cycle, a relation.
   Reject an icon that would be alone in its slot: an unlabelled icon is a guess.
   Icon PLUS label is the default; icon instead of label is the exception.

2. RUN THE COVER TEST on every icon you kept: cover it, and if the slot still
   says the same thing, delete it.

3. PICK ONE STYLE for the whole set - stroked or filled, never mixed. One corner
   treatment. One colour per icon (two maximum; three or more is an illustration,
   which is a different object and must not sit in an icon slot beside icons).

4. MATCH THE STROKE TO THE TYPE, per step:
     stroke = 0.45u x (accompanying_step / s0)
   Target: within 15% of the MEASURED stem width of the adjacent word. An icon
   lighter than its label is the commonest icon failure in the medium.

5. GEOMETRY per icon:
     square box, side = 1.6 x cap height of the accompanying step;
     drawn content inset from the box by one stroke width (the keyline), so a
       circular icon and a square icon at the same nominal size read the same;
     no interior gap thinner than the stroke - which caps an icon at about four
       strokes across its box at video sizes;
     below 2u of box height, silhouette only: one closed shape, no interior
       strokes;
     vertical alignment to the CAP-HEIGHT MIDPOINT of the label, not the
       line-box centre;
     gap to the label 0.45 x cap height, expressed in em.

6. BUILD LARGE AND SIMPLIFY DOWN. Draw at the largest size the project uses and
   REMOVE detail for smaller instances. Never add detail as an icon grows.

7. CLOSE THE INVENTORY. List every glyph the video uses - six or fewer. Past
   that the set stops being learnable and each glyph is just a small picture.

8. VERIFY 3:1 (WCAG 1.4.11 non-text contrast) against whatever sits behind each
   icon, at the WORST frame in its window.

ACCEPTANCE TEST:
(a) for each icon-label pair, measured stroke width is within 15% of measured
    stem width;
(b) every icon's bounding box is the same size within 2%, while drawn extents
    differ - proof the keyline is real;
(c) zoom to 300%: no interior gap is thinner than the stroke;
(d) cover each icon in turn - every one must cost the row information;
(e) count distinct glyphs: <= 6;
(f) all icons are the same style and the same colour count;
(g) overlay a line at the label's cap midpoint - every icon box centre sits on
    it.
```

## Execution spec

**Inline SVG, one `<symbol>` per glyph, `currentColor` for the fill/stroke.** This is the shape that makes an icon inherit the type's colour and the step's stroke rung automatically, which is what keeps the match from drifting.

```html
<svg style="display:none" aria-hidden="true">
  <symbol id="ic-wave" viewBox="0 0 24 24">
    <!-- drawn on a 24-unit box, content inset by 2 units = one stroke width -->
    <path d="M2 12h3l2-6 3 12 3-9 2 4h7"/>
  </symbol>
</svg>

<div class="row">
  <svg class="icon" aria-hidden="true"><use href="#ic-wave"/></svg>
  <span class="t-body">Dialogue</span>
</div>
```

```css
[data-composition-id="gfx"] .row{
  display:flex; align-items:center; gap:0.45em;    /* em of the row's own type */
}
[data-composition-id="gfx"] .icon{
  /* box from the type, not from a pixel constant */
  inline-size: calc(1.6 * 3.24 * var(--u));
  block-size:  calc(1.6 * 3.24 * var(--u));
  fill:none;
  stroke: currentColor;                             /* follows the label's colour */
  stroke-width: calc(24 * var(--sw-body) / (1.6 * 3.24 * var(--u)));  /* user units */
  stroke-linecap: round; stroke-linejoin: round;
  /* optical alignment to the cap midpoint rather than the line box */
  transform: translateY(calc(-0.06em));
}
```

The `stroke-width` expression is the part worth reading twice: an SVG's `stroke-width` is in **user units of its own viewBox**, so a `24`-unit box rendered at `H` pixels draws a stroke of `stroke-width × H ÷ 24` pixels. To hit a target rung you invert that. The simpler alternative — and the one to prefer in practice — is `vector-effect="non-scaling-stroke"` plus `stroke-width` in px, which makes the stroke a screen quantity independent of the viewBox.

Constraints:

- **`vector-effect="non-scaling-stroke"` interacts with entrance scaling.** With it, a `scale: 0.94 → 1` entrance keeps the stroke constant, which is right for a persistent diagram and slightly wrong for a pop-in (the stroke should grow with the shape). Pick per component and write it down.
- **Animate `stroke-dashoffset` for a draw-on, never geometry.** Set `stroke-dasharray` from the path length **once at setup**; do not call `getTotalLength()` at tween time — *"compute coordinates once at composition setup and reuse."*
- **Never tween `stroke-width`.** Re-rasterises every frame and fights `vector-effect`.
- **Transform aliases only** (`x`, `y`, `scale`, `rotation`); `width`/`height`/`top`/`left` tweens are forbidden. Transformed elements must be block-level and sized — an inline `<svg>` needs `display:block` or an explicit `inline-size`/`block-size` as above.
- **`fromTo`, never `from`**; `autoAlpha` on non-clip elements only; land the last tween before `data-duration` because the visibility window is half-open.
- **A CSS `transform` on a GSAP-tweened element is `gsap_css_transform_conflict` (error)** — note the `translateY` in the CSS above, which is exactly this trap: if the icon will be tweened on `y`, move the optical offset onto a wrapper instead, or apply it as `y` in a zero-duration `tl.set()`.
- **No icon fonts.** A ligature-based icon font is a font file with no fallback, no per-glyph control of stroke, and no way to satisfy the keyline rule; it also re-introduces the banned network-font path. Inline SVG symbols only.
- **No external SVG sprites over the network.** Everything inline or local; the egress allowlist blocks CDNs, and a composition that pulls an asset it cannot reach renders blank or bare.
- Named animation rule citable here without quoting its code: `svg-icon-enrichment`, `svg-path-draw`.

**Remotion.** The same inline `<symbol>`/`<use>` pattern inside a React component, with `strokeWidth` computed from `useVideoConfig().height`.

## Pairs with
[[gfx-stroke-weight-and-corner-radius]] · [[gfx-modular-type-scale]] · [[gfx-weight-and-optical-size]] · [[gfx-palette-ground-ink-accent]] · [[gfx-list-card-enumeration]] · [[gfx-progress-step-indicator]] · [[gfx-diagram-node-geometry]] · [[motion-abstract-concept-card]] · [[motion-annotation-draw-on]] · [[gfx-three-channel-division-of-labour]] · [[gfx-channel-decision-procedure]]

## Failure modes
- **An icon beside an abstract noun.** A lightbulb next to "insight" is the most reliable single indicator that a graphic was decorated rather than designed.
- **The icon lighter than its label.** The row reads as two voices. Correction: match the stroke to the measured stem within 15 %.
- **Mixed stroked and filled.** The set stops being a set.
- **Three-colour "icons".** Those are illustrations. They can be great — the observed flat-vector doodles are — but they cannot sit in an icon slot beside icons.
- **No keyline.** Circular icons look smaller than square ones at the same nominal size, and the row's rhythm goes soft.
- **Interior gaps thinner than the stroke.** Close under compression; the glyph becomes a smudge at exactly the moment the viewer glances at it.
- **Detail added at larger sizes.** Produces a set where the small icons are the big ones badly scaled.
- **Twelve glyphs.** A stock library was opened. Nothing is learnable.
- **Aligned to the line box.** Every icon sits visibly low and no single one looks wrong.
- **An unlabelled icon carrying meaning.** A guess dressed as information.
- **An icon font.** No stroke control, no keyline, and a font dependency.
- **An icon that animates on every appearance.** A tic. Draw it on once, the first time, and let it simply exist afterwards.
- **Known gap:** there is no comprehension data for any specific glyph in this library, and published symbol-testing standards (ISO 9186-1) deliberately leave the pass threshold to the adopting body rather than fixing a percentage. So "this icon is understood" is an assertion, not a measurement. The cover test and a small informal check on someone outside the project is the only evidence available here, and it should be recorded as such.
