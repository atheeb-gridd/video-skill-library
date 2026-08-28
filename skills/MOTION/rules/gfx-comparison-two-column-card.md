---
id: gfx-comparison-two-column-card
title: The comparison card — two columns at 16:9, stacked rows at 9:16, and the character count that decides
skill: motion
type: graphic
family: graphic-components
tags: [skill/motion, type/graphic, family/graphic-components, engine/hyperframes, engine/ffmpeg, engine/remotion, source/sfx-kt-2, source/editing-kt-2, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "visual — contact sheet, labels over live action"
    quote: "[NOT SPOKEN — observed on screen] 'Metal Hit' / 'Wood Hit' stacked as two rows in one slot, identical treatment — a two-item comparison built from stacked labels rather than columns."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, filmstrip"
    quote: "[NOT SPOKEN — observed on screen] A sequence rendered as four perforated film frames in a row, so the matched shape sits side by side in one static image."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "visual — contact sheet, negation devices"
    quote: "[NOT SPOKEN — observed on screen] Red strikethrough and red overlay marking a claim as rejected — the verdict is carried by one side only."
research_refs:
  - https://link.springer.com/content/pdf/10.1007/s10648-018-9435-9.pdf
  - https://edtechuvic.ca/wp-content/uploads/sites/11/2022/09/principles-for-reducing-extraneous-processing-in-multimedia-learning-coherence-signaling-redundancy-spatial-contiguity-and-temporal-contiguity-principles.pdf
  - https://legibility.info/rules-for-text-in-videos
  - https://www.cambridge.org/core/journals/behavioral-and-brain-sciences/article/magical-number-4-in-shortterm-memory-a-reconsideration-of-mental-storage-capacity/44023F1147D4A1D44BDC0AD226838496
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
difficulty: high
detectable_from: transcript+video
---

# The comparison card — two columns at 16:9, stacked rows at 9:16, and the character count that decides

## What it is

The most common explainer component there is, and the one where the vertical frame changes the answer completely.

A comparison card puts **two named things side by side, differing along named dimensions**, so the viewer sees the difference in space instead of holding the first thing in working memory while the second is described. That is its entire justification and it is a good one: speech can only present two options serially, and a serial comparison costs a working-memory slot per attribute.

**Anatomy:**

- **Two column heads** — the names of the things. Type step `s2`, ≤3 words each.
- **2–4 attribute rows** — the dimensions on which they differ. Row labels at `s-1` in `--ink-dim`, values at `s0`.
- **One divider** — a `--stroke-hair` vertical rule, running the **height of the content**, not the height of the frame.
- **One verdict mark, on one side only** — the accent, or a check, or (if the video's semantic map already claims red for negation) a red strike on the rejected side. Marking both sides means marking neither.

### The character-count test, which is the load-bearing content of this note

**Two columns do not fit a 9:16 frame at body type, and the arithmetic is not close.**

At 1080 wide with the project's grid — 6 % side margins, 2 % gutter — the content width is 88 % = `950 px`, and two columns are `464 px` each. Average character advance in a grotesque is about `0.5 em`, and body type at `s0` on a 1920-tall frame is `86 px`. So:

> `464 px ÷ (0.5 × 86 px)` = **about 11 characters per column.**

Eleven characters is one or two words. Published video-text guidance caps a line at **30 characters**; eleven is a third of that. A two-column comparison in 9:16 can therefore carry **a one- or two-word label per cell and nothing else.** Any cell needing a phrase overflows, wraps to three lines, or gets set at a step too small to read.

At 16:9 the same arithmetic comes out completely differently. 1920 wide, 5 % margins, 1.5 % gutter: content `1728 px`, columns `849 px`, `s0` on a 1080-tall frame is `48.6 px`, so:

> `849 px ÷ (0.5 × 48.6 px)` = **about 35 characters per column.** Workable.

**So the rule is:**

| Aspect | Cell content | Layout |
|---|---|---|
| 16:9 | Up to ~30 characters | **Two columns.** The classic form. |
| 9:16, cells ≤ 2 words | ≤11 characters | **Two columns.** Tight but legal. |
| 9:16, cells > 2 words | — | **Stacked: A above B**, full width each, with the attribute rows repeated. Or split into two beats. |

The stacked form loses the simultaneity that made the comparison worth building — the viewer's eye travels vertically instead of horizontally, and a vertical comparison is closer to a serial one. That loss is real, and it is why the honest third option is often better: **split the comparison into two beats and let the picture do the comparing** ([[motion-filmstrip-comparison-strip]] puts both states in one static frame; [[cut-graphic-match]] and [[motion-graphic-match-alignment-transform]] make the comparison happen across a cut).

**Parallelism is the other half of readability, and it is a writing rule.** Both column heads must be the same part of speech, roughly the same length (**within ±3 characters**), and the attribute rows must be in the **same order** with the **same phrasing** on both sides. `Fast / Slower to set up` is not parallel; `Fast / Slow` is. A non-parallel comparison forces the viewer to work out what is being compared before they can compare it, which costs exactly the working-memory slot the card existed to save.

**Attribute rows are capped at four**, for the same working-memory reason as the list card: Cowan's limit is near four chunks, and this library's own element census is `4 ± 1` at a build's final frame. Two things × four attributes is eight cells, which is at the ceiling already.

## When to use it

- **The transcript contains "versus", "on one hand… on the other", "the difference is", "A does X, B does Y".**
- **Two options, two approaches, two tools, before/after.**
- **A verdict is being delivered** — the card's job is often to make the winner obvious, and the accent does that in one glance.
- **In 16:9, freely.** It is the default explainer component there.
- **In 9:16, only after the character count passes.** Otherwise stack, or split into beats, or use the filmstrip.
- **Not** for three things. Three columns in any aspect is a table, and a table on video is a poster.
- **Not** when the two things differ on one dimension only — that is two labels, stacked, which is the cheapest component in the library and reads better ([[gfx-label-callout-over-footage]]).
- **Not** when the comparison is of two *shots* — that is the filmstrip.

## How to recognise it in a reference video

- **Measure the column width as a percentage of frame width**, then compute characters per line at the measured type size: `chars ≈ column_px ÷ (0.5 × font_px)`. **Under 12** means the design is at the vertical limit and every cell must be one or two words; **over 40** means the columns are too wide and the eye has to travel.
- **Check parallelism on the heads.** Same part of speech, lengths within ±3 characters. Non-parallel heads are the single commonest content fault.
- **Check row order and phrasing across the two sides.** Same order, same words. A card where the left side says `Cost` and the right says `How much it costs` was written twice.
- **Count attribute rows.** 2–4. Five or more is a table.
- **Find the divider and measure its extent.** A divider running the full frame height is a decoration that splits the frame; one running the content height is doing the job. Measure its width and divide by the row's cap height — around **0.04–0.06** puts it on the `hair` rung, which is what keeps it from competing.
- **Count verdict marks.** One side only. Marks on both sides is a card that has not decided.
- **Check for the red trap.** If red appears on the losing side and red *also* appears elsewhere in the video meaning something else, the semantic map is broken. In the observed reference material red means negated, everywhere ([[sub-red-strikethrough-negation]], [[gfx-palette-ground-ink-accent]]).
- **Check the build order against the transcript.** In a competent build, side A's cells arrive as A is described and side B's as B is described — each within **±0.2 s** of its naming word — rather than the whole table arriving at once. A card that lands complete and is then talked through is a weaker variant; log it.
- **Element census at the final frame.** 2 heads + up to 8 cells + 4 row labels is 14 objects, which is over the poster line — which is why the row labels are usually dimmed to near-invisibility once the card is built, and why four rows is a hard ceiling rather than a guideline.
- **Dwell.** `total_chars ÷ 13` is the floor, ×2.5 if a caption is live. A comparison card with 60 characters needs **4.6 s** alone and **11.5 s** under a caption — which is usually the real reason to split it into two beats.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `sides` | 2 | 2 | Three is a table. |
| `layout_16x9` | two columns | — | ~35 characters per column at `s0`. |
| `layout_9x16` | two columns if cells ≤2 words, else stacked | — | ~11 characters per column at `s0`. |
| `chars_per_column` | computed | 12–35 | `column_px ÷ (0.5 × font_px)`. Below 12 the cells must be 1–2 words. |
| `chars_per_line_ceiling` | 30 | 24–36 | Published video-text rule. |
| `head_step` | `s2` (7.03 % of frame height) | `s1`–`s2` | ≤3 words. |
| `value_step` | `s0` (4.5 %) | `s-1`–`s0` | The cells. |
| `row_label_step` | `s-1` (3.60 %) | `s-2`–`s-1` | In `--ink-dim`. |
| `attribute_rows` | 3 | 2–4 | Working-memory ceiling. |
| `head_length_parity` | ±3 characters | ±3 | Parallelism is measurable. |
| `row_phrasing` | identical both sides | required | Same order, same words. |
| `divider` | `--stroke-hair` (0.15 u) | 0.12–0.18 u | Ratio to ground 1.5–2.5:1. **The one pair with a contrast ceiling.** |
| `divider_extent` | content height | — | Not frame height. |
| `gutter` | 2 % of frame width | 2–4 % | The grid's gutter. |
| `verdict_marks` | 1 | 1 | One side only. |
| `verdict_mechanism` | accent on the winning side | accent / check / red strike on loser | Red only if the video's semantic map already assigns red to negation. |
| `red_semantics` | negation | — | Global. A red losing column in a video where red means negated is consistent; in a video where red means "important" it is broken. |
| `build_order` | A's cells, then B's | — | Each cell within ±0.2 s of its naming word. |
| `stage_interval` | 1.2–2.5 s | 0.8–3.0 s | Tracks the narration. |
| `entrance` | 0.40 s, `power3.out`, 0.10 s stagger | — | Per side. Total stagger ≤0.5 s. |
| `dwell` | `total_chars ÷ 13` s | ≥3.0 s | ×2.5 if a caption is live. This is usually what forces the split. |
| `stacked_fallback` | A above B, full width | — | Repeat the attribute rows. Loses simultaneity — consider two beats instead. |
| `symmetry` | exact | required | Equal column widths, equal row pitch, equal padding. Asymmetry reads as a verdict nobody intended. |

## Reproduction prompt

```
Build a comparison of {{A}} versus {{B}} on {{DIMENSIONS}}, at {{ASPECT}}
{{WIDTH}}x{{HEIGHT}}.

1. RUN THE CHARACTER-COUNT TEST FIRST. It decides the layout and it is not a
   close call:
     content_width = frame_width x 0.88   (6% margins each side)
     column_px     = (content_width - gutter) / 2
     chars         = column_px / (0.5 x font_px_at_s0)
   At 9:16 1080x1920 this comes out at about 11 characters per column. At 16:9
   1920x1080 it comes out at about 35.
     chars >= 24            -> TWO COLUMNS. The classic form.
     chars 12-23            -> two columns, cells of 1-2 words ONLY.
     chars < 12, cells short-> two columns, 1-2 words per cell.
     chars < 12, cells long -> DO NOT use two columns. Either stack A above B at
                               full width with the attribute rows repeated, or
                               split into two beats and let a cut do the
                               comparing (see the filmstrip strip and the graphic
                               match notes).
   Write the computed number into the design doc so the choice is auditable.

2. WRITE IT PARALLEL, and treat this as a hard requirement rather than style:
     both heads the same part of speech, lengths within 3 characters;
     the same attribute rows, in the same order, phrased identically on both
       sides.
   `Fast / Slower to set up` is not parallel. `Fast / Slow` is. A non-parallel
   comparison forces the viewer to work out what is being compared before they
   can compare it, which spends the working-memory slot the card existed to save.

3. CAP THE ROWS AT FOUR. Two things x four attributes is eight cells, which is
   already at the working-memory ceiling of about four chunks.

4. ONE DIVIDER, on the --stroke-hair rung (0.15u), running the height of the
   CONTENT, not the height of the frame, at 1.5-2.5:1 against the ground. This is
   the one contrast pair with a CEILING: a divider above 3:1 competes with the
   content.

5. ONE VERDICT MARK, ON ONE SIDE. The accent on the winner, or a check, or - only
   if this video's semantic map already assigns red to negation - a red strike on
   the loser. Marking both sides means marking neither. Do not introduce red here
   if red means something else anywhere in the video.

6. BUILD IT IN THE ORDER IT IS SPOKEN: A's head, then A's cells as A is
   described; then B's head, then B's cells. Each within +/-0.2s of its naming
   word. Rows persist and dim; nothing is removed. A card that lands complete and
   is then talked through is a weaker variant - use it only when the beat is
   under about 6s.

7. SYMMETRY IS EXACT: equal column widths, equal row pitch, equal padding.
   Asymmetry reads as a verdict, and it will be a verdict you did not intend.

8. COMPUTE THE DWELL: total_chars / 13 seconds, multiplied by 2.5 if a caption is
   live. If the beat cannot afford it, split the comparison - do not shrink the
   type.

ACCEPTANCE TEST:
(a) the computed characters-per-column is in the design doc and the layout matches
    the branch it selects;
(b) no cell wraps to more than two lines, verified on a snapshot;
(c) head lengths are within 3 characters and are the same part of speech;
(d) attribute rows are in the same order with identical phrasing on both sides;
(e) <= 4 attribute rows;
(f) the divider measures 1.5-2.5:1 against the ground and does not run past the
    content;
(g) exactly one verdict mark, on one side;
(h) the two columns are equal in width to the pixel;
(i) on-screen time >= total_chars/13, x2.5 if a caption overlaps.
```

## Execution spec

**HyperFrames.** A CSS grid whose column count is the branch decision, so the same sub-composition serves both aspects with one variable.

```html
<div id="cmp" class="clip" data-start="304.20" data-duration="8.60" data-track-index="3">
  <div class="cmp two-col">            <!-- or class="cmp stacked" at 9:16 -->
    <div class="cmp-head" id="cmp-h-a">Hard cut</div>
    <div class="cmp-head" id="cmp-h-b">Dissolve</div>
    <div class="cmp-rowlab">Feel</div>
    <div class="cmp-cell" id="cmp-a1">Abrupt</div>
    <div class="cmp-cell" id="cmp-b1">Soft</div>
    <div class="cmp-rowlab">Time</div>
    <div class="cmp-cell" id="cmp-a2">None</div>
    <div class="cmp-cell" id="cmp-b2">Passes</div>
    <div class="cmp-divider" aria-hidden="true"></div>
  </div>
</div>
```

```css
[data-composition-id="gfx"] .cmp{
  position:absolute; left:calc(6 * var(--w)); right:calc(6 * var(--w));
  bottom:calc(30 * var(--u));
}
[data-composition-id="gfx"] .cmp.two-col{
  display:grid;
  grid-template-columns: 1fr 1fr;                     /* exactly equal */
  column-gap: calc(2 * var(--w));
  row-gap: calc(1.4 * var(--u));
}
[data-composition-id="gfx"] .cmp.stacked{
  display:grid; grid-template-columns: 1fr;           /* the 9:16 fallback */
  row-gap: calc(1.4 * var(--u));
}
[data-composition-id="gfx"] .cmp-head{ font-size:var(--s2); color:var(--ink); }
[data-composition-id="gfx"] .cmp-cell{ font-size:var(--s0); color:var(--ink); }
[data-composition-id="gfx"] .cmp-rowlab{
  grid-column: 1 / -1; font-size:var(--s-1); color:var(--ink-dim);
  text-transform:uppercase;
  letter-spacing:calc(var(--track-body) + var(--track-caps-adj));
}
[data-composition-id="gfx"] .cmp-divider{
  position:absolute; top:0; bottom:0; left:50%;
  inline-size: var(--sw-hair);                        /* the hair rung */
  background: var(--hairline);                        /* 1.5-2.5:1 on ground */
  transform: translateX(-50%);
}
[data-composition-id="gfx"] .cmp .is-winner{ color: var(--accent); }
```

```js
// build in spoken order; each cell lands on its naming word (from transcript.json)
const P = { hA:304.35, a1:305.10, a2:306.40, hB:307.80, b1:308.50, b2:309.90 };
const IN = { y: 18, autoAlpha: 0 }, OUT = { y: 0, autoAlpha: 1, duration: 0.40, ease: "power3.out" };
tl.fromTo("#cmp-h-a", IN, OUT, P.hA);
tl.fromTo("#cmp-a1",  IN, OUT, P.a1);
tl.fromTo("#cmp-a2",  IN, OUT, P.a2);
tl.fromTo("#cmp-h-b", IN, OUT, P.hB);
tl.fromTo("#cmp-b1",  IN, OUT, P.b1);
tl.fromTo("#cmp-b2",  IN, OUT, P.b2);
// the verdict, once, at the end. Colour tween on a non-overshooting ease.
tl.to("#cmp-h-b", { color: "var(--accent)", duration: 0.30, ease: "power2.out" }, 310.60);
```

Contract points:

- **`grid-template-columns: 1fr 1fr` guarantees exact equality**, which hand-set percentages do not once padding enters. Asymmetry in a comparison reads as a verdict.
- **The divider is absolutely positioned with `translateX(-50%)`** — which is a **CSS transform on the element**. If the divider will ever be tweened (a draw-on `scaleY`, for instance) that raises `gsap_css_transform_conflict` (error). Move the centring onto a wrapper, or set `left: calc(50% - var(--sw-hair)/2)` and keep the element transform-free.
- **Never tween `width`/`height`** to draw the divider. Use `scaleY` from `transform-origin: top` on a transform-free element, or `clip-path`.
- **The row label spans both columns** (`grid-column: 1 / -1`), which is what makes the attribute name apply to both sides without being written twice — the parallelism rule expressed as layout.
- **`fromTo`, never `from`**; land the last tween before `data-duration` (310.90 vs 312.80 here); `autoAlpha` on inner elements only, never on the clip.
- **Cells must not wrap unpredictably.** Do **not** use `white-space: nowrap` with `overflow: hidden` — that clips silently rather than wrapping, which is the reference implementation's known text-fit hazard. Let it wrap and verify on a snapshot; the character-count test is what stops it wrapping in the first place.
- **Two aspects, two roots.** Give each aspect its own `index.html` with its own `data-width`/`data-height`, hosting this sub-composition and passing `two-col` or `stacked` via `data-variable-values`. `--resolution` is a supersample, not a reframe.
- **Colour tweens take a non-overshooting ease** — overshooting curves go on transforms only.
- **The layout audit will catch a cramped cell** (`content-cramped-container`) and a clipped one (`text-clipping`) — but only if lint is clean, because a lint **error** switches the layout and contrast audits off and `check` then reports `0 sample(s)`, which reads clean and means nothing ran.
- **Sound:** one transient per stage at −18 to −24 dBFS relative to the mix, not a whoosh per cell.

**ffmpeg — the fit audit:**

```bash
# does any cell wrap to three lines, or clip? look at the built frame.
ffmpeg -ss 310.0 -i out.mp4 -frames:v 1 -q:v 2 /tmp/c/built.png
# column symmetry: crop both columns and compare their widths
ffmpeg -ss 310.0 -i out.mp4 -frames:v 1 -vf "crop=iw*0.43:ih*0.30:iw*0.06:ih*0.34" /tmp/c/left.png
ffmpeg -ss 310.0 -i out.mp4 -frames:v 1 -vf "crop=iw*0.43:ih*0.30:iw*0.51:ih*0.34" /tmp/c/right.png
```

**Remotion.** The same grid in a component whose `columns` prop comes from the character-count branch; `useVideoConfig()` supplies the width the test needs.

## Pairs with
[[gfx-vertical-grid-and-margins]] · [[gfx-modular-type-scale]] · [[gfx-list-card-enumeration]] · [[gfx-stat-card-layout]] · [[gfx-palette-ground-ink-accent]] · [[gfx-stroke-weight-and-corner-radius]] · [[gfx-attention-budget-simultaneity]] · [[gfx-channel-decision-procedure]] · [[motion-filmstrip-comparison-strip]] · [[motion-graphic-match-alignment-transform]] · [[motion-progressive-information-build]] · [[cut-graphic-match]] · [[struct-inverse-pair-teaching]] · [[sub-red-strikethrough-negation]]

## Failure modes
- **Two columns in 9:16 with phrases in the cells.** Eleven characters per column. The cells wrap to three lines or get set at a step nobody can read, and the card is unusable at exactly the moment it matters.
- **Non-parallel heads or rows.** The viewer spends their working memory working out the comparison instead of making it.
- **Five or more attribute rows.** A table. On video, a table is a poster.
- **A divider at full ink.** Splits the frame in half and competes with both columns. The hairline has a contrast *ceiling*, not just a floor.
- **A divider running the frame height.** Decoration masquerading as structure.
- **Verdict marks on both sides.** The card has not decided, so neither has the viewer.
- **Introducing red for the losing side in a video where red means something else.** The semantic map is global and one stray use destroys it retroactively.
- **Unequal columns.** Reads as a verdict you did not intend, and no single frame looks wrong.
- **The whole card arriving at once.** The viewer parses a table while the voice keeps moving. Build it in spoken order.
- **Under-dwelling.** 60 characters needs 4.6 s alone and 11.5 s under a live caption. A card that cannot afford its dwell should be two beats.
- **`nowrap` plus `overflow:hidden`.** Clips silently instead of wrapping; the failure is invisible in the markup and obvious on screen.
- **Comparing two shots in a card.** That is the filmstrip's job, and the filmstrip preserves order and adjacency, which a card does not.
- **Known gap:** the reference set contains no built two-column comparison — the observed comparisons are stacked labels and the four-frame filmstrip, both of which are consistent with the character-count finding and neither of which confirms the column geometry. The `0.5 em` average character advance is a grotesque approximation and varies by ±15 % across families; measure the real advance for the chosen face before trusting a borderline result.
