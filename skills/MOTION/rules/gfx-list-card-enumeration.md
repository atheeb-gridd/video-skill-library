---
id: gfx-list-card-enumeration
title: The list card — four rows, an ordinal gutter, and the current-row signal that makes it a build
skill: motion
type: graphic
family: graphic-components
tags: [skill/motion, type/graphic, family/graphic-components, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt-2, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:16"
    quote: "So in this video, we're gonna dive into 10 important editing cuts every filmmaker should know."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:35"
    quote: "Number nine is cross cutting."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "visual — contact sheet, concept cards"
    quote: "[NOT SPOKEN — observed on screen] Left-aligned labels stacked in one slot — 'Metal Hit' / 'Wood Hit' — same treatment, one above the other."
research_refs:
  - https://www.cambridge.org/core/journals/behavioral-and-brain-sciences/article/magical-number-4-in-shortterm-memory-a-reconsideration-of-mental-storage-capacity/44023F1147D4A1D44BDC0AD226838496
  - https://edtechuvic.ca/wp-content/uploads/sites/11/2022/09/principles-for-reducing-extraneous-processing-in-multimedia-learning-coherence-signaling-redundancy-spatial-contiguity-and-temporal-contiguity-principles.pdf
  - https://link.springer.com/content/pdf/10.1007/s10648-018-9435-9.pdf
  - https://legibility.info/rules-for-text-in-videos
  - https://www.cambridge.org/core/books/abs/multimedia-learning/segmenting-principle/37240877DDA0362355ADB39936027982
difficulty: medium
detectable_from: transcript+video
---

# The list card — four rows, an ordinal gutter, and the current-row signal that makes it a build

## What it is

The component for the STRUCTURE payload when the whole set has to be visible at once: **"there are five layers of sound", "it breaks down into three parts"**. Rows in a fixed rhythm, an ordinal in a fixed gutter, and exactly one row marked as current.

It is a different object from the **item marker** ([[motion-list-item-marker-card]]) and the two are constantly confused. The marker says *"we are now on item 4"*, appears at each boundary, and is gone within four seconds. The list card says *"here is the whole set, and we are on item 4 of it"*, and persists across the item. A video can have both; it usually should not have both on screen simultaneously, because they carry the same structural information and one of them is then a duplicate ([[gfx-attention-budget-simultaneity]]).

**Four rows, five at most, and it is a working-memory ceiling rather than a layout one.** Cowan's reconsideration puts the pure capacity limit near **four chunks**, not seven, and this library has independently converged on the same figure from the other direction: [[motion-explainer-beat-animation]] specifies an element census of **4 ± 1** at a build's final frame, and *"8+ means the graphic is a poster, not an explanation."* A ten-item video does not get a ten-row list card. It gets item markers, and possibly a progress indicator ([[gfx-progress-step-indicator]]).

**The ordinal gutter is what makes rows align.** Ordinals sit in a fixed-width column — **4 u** wide — so every row's label starts at the same x regardless of whether the ordinal is `1` or `10`. Without the gutter, `10.` pushes its label right and the list develops a ragged left edge on exactly the row the viewer is looking at. With tabular figures ([[gfx-stat-card-layout]]) and a fixed gutter, the column is exact.

**The current-row signal must be two cues, not one.** Colour alone fails the greyscale test and fails colour-deficient viewers; opacity alone is weak at a glance. The house pair is **full-opacity ink plus the accent** on the current row, against **`--ink-dim` at 45–60 %** on the others — which is signalling (median **d = 0.41** across 28 studies, supported in 24 of 28) applied to a list. Prior rows dimming rather than disappearing is what keeps the final frame containing the whole argument, which is the defining property of a build rather than a slideshow.

**Rows are labels, not sentences.** ≤4 words, no finite verb. A row carrying its own definition is prose duplication and cannot be read at 13 characters per second while somebody is talking ([[gfx-structure-duplicates-prose-does-not]]).

**Row rhythm is derived from the type, not chosen.** Row height = **2.2 × cap height** of the row's step. At `s0` (cap 3.24 u) that is `7.1 u` per row; four rows plus the card's padding is `~34 u` — which fits the 9:16 graphic band's 32 % budget only just, and does not fit five rows with a title. That arithmetic is the reason the ceiling is four.

## When to use it

- **A set is being named as a set**, with the count spoken: "five layers", "three things", "four steps".
- **The set is small** — 3 to 5 members.
- **The set will be walked through**, so the current-row signal has somewhere to go. A list card that never advances is a static list and could be a card with a title.
- **The members are short.** If a member needs more than four words, it needs its own beat, and the list card is the wrong shape.
- **As the recap** after the items have been walked, with every row at full opacity — the one legitimate use with no current row.
- **Not** for 6+ items. Use item markers plus a persistent counter.
- **Not** simultaneously with an item marker for the same set.
- **Not** when the members have an ordering that matters *causally* — that is a RELATION and it wants a diagram with connectors, because a list asserts membership and a diagram asserts flow.

## How to recognise it in a reference video

- **Count the rows.** 3–5 ⇒ a designed list. 7+ ⇒ a poster, or a screenshot of a document.
- **Measure row pitch** (baseline to baseline) and divide by cap height. **2.0–2.4** is the designed band. Under 1.8 the rows crowd; over 2.8 the list stops reading as one object.
- **Check the label left edge across rows.** Identical to the pixel ⇒ an ordinal gutter exists. Ragged ⇒ the ordinals are inline and `10.` is pushing its row.
- **Count the cues on the current row.** Two ⇒ designed. One ⇒ it will fail in greyscale or at a glance. Convert a frame to grey and check that the current row is still identifiable:
  ```bash
  ffmpeg -ss <t> -i ref.mp4 -frames:v 1 -vf "format=gray" /tmp/l/grey.png
  ```
- **Measure the dim level.** Non-current rows at **45–60 %** effective opacity against the ground, and — this is the part usually skipped — still clearing **4.5:1**. A dimmed row at 3:1 is an accessibility failure that looks intentional.
- **Check persistence.** Do earlier rows stay? A list where each row *replaces* the last is a slideshow, which is a weaker pattern — log it as such.
- **Check the advance against the transcript.** The current-row signal should move within **±0.2 s** of the word that names the new row. A signal that advances on a timer rather than on a word is a template running.
- **Word count per row.** Median ≤3, max 4. Rows carrying clauses mean the list is a paragraph with bullets.
- **Check whether the ordinals are spoken.** If the narration says "number three" and the card shows `3`, that is the licensed structural duplication. If the card shows the row's *definition* while the narration says the same words, it is prose duplication.
- **Stage interval.** 1.2–3.0 s between advances, tracking the narration rather than a constant.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `rows` | 4 | 3–5 | Working-memory ceiling; matches the library's 4 ± 1 element census. |
| `row_step` | `s0` (4.5 % of frame height) | `s-1`–`s1` | Body register. |
| `row_pitch` | 2.2 × cap height | 2.0–2.4× | `7.1 u` at `s0`. Derived, not chosen. |
| `ordinal_gutter` | 4 u | 3.5–5 u | Fixed width, so labels align regardless of ordinal width. |
| `ordinal_step` | `s0` | `s-1`–`s0` | Same step as the row, or one below. Never larger — that is an item marker. |
| `ordinal_numerals` | `tabular-nums` | required | So `1` and `10` occupy the same advance. |
| `words_per_row` | 3 | 1–4 | No finite verb. |
| `current_row_cues` | 2 | 2 | Full-opacity ink **and** the accent. Never colour alone. |
| `dim_level` | 55 % | 45–60 % | Effective opacity of non-current rows against the ground. |
| `dim_contrast` | ≥4.5:1 | ≥4.5:1 | Dimmed is not permission to be illegible. Composite and measure. |
| `dim_method` | `color: var(--ink-dim)` | — | Not `opacity` — that dims the plate too and makes the element a backdrop root. |
| `persistence` | all rows visible | required | Rows dim, they do not disappear. Otherwise it is a slideshow. |
| `title` | optional, `s2` | — | The set's name. Counts against the band budget: 4 rows + title ≈ 41 u. |
| `advance_offset` | +0.15 s from the naming word | −0.2 to +0.4 s | Signalling lands on the word, not on a timer. |
| `advance_duration` | 0.30 s | 0.2–0.4 s | Colour cross-fade on `power2.out`. Not an overshooting ease. |
| `stage_interval` | 1.2–3.0 s | 0.8–4.0 s | Tracks the narration. |
| `entrance` | rows staggered 0.10 s | 0.08–0.14 s | Total stagger ≤0.5 s: 4 rows × 0.10 = 0.40 s. |
| `entrance_duration` | 0.40 s, `power3.out` | 0.30–0.50 s | Translate 2 u + `autoAlpha`. |
| `stagger_order` | by importance, then top-down | — | For a list, top-down *is* importance order. |
| `recap_state` | all rows full opacity | — | The one legitimate no-current-row state. |
| `concurrent_with_item_marker` | forbidden | — | Same structural information twice. |
| `total_height_budget` | ≤34 u (4 rows) / ≤41 u (with title) | ≤ graphic band | At 9:16 the graphic band is ~32 % of frame height. This is why the ceiling is 4. |

## Reproduction prompt

```
Build a list card for the set {{TITLE}} with members {{MEMBER 1..N}}, walked
through by the narration.

1. CHECK N. Three to five rows. If N >= 6, STOP - this is the wrong component.
   Use item markers plus a persistent counter instead. The ceiling is a working-
   memory limit (about four chunks), not a layout preference, and the height
   arithmetic agrees: 4 rows at 2.2x cap pitch plus padding is ~34u, and the 9:16
   graphic band is only ~32% of frame height.

2. WRITE THE ROWS as labels: <= 4 words each, no finite verb. A row carrying its
   own definition is prose duplication and cannot be read at 13 characters per
   second while somebody is talking. The definition is spoken; the row is a name.

3. BUILD THE GRID:
     ordinal gutter, fixed 4u wide, tabular figures, so every label starts at the
       same x whether the ordinal is 1 or 10;
     row pitch = 2.2 x cap height of the row's type step (7.1u at s0);
     one left edge for every label, at the project's 6%-of-frame-width margin.

4. TWO CUES FOR THE CURRENT ROW, never one:
     current      = --ink at full opacity AND --accent (on the ordinal, or as a
                    left rule on that row)
     non-current  = --ink-dim, composited to 45-60% - set `color`, do NOT use
                    `opacity`, which also dims the plate and turns the element
                    into a backdrop root.
   Verify: convert a frame to greyscale and confirm the current row is still
   identifiable, and confirm the DIMMED rows still clear 4.5:1. Dimmed is not
   permission to be illegible.

5. ROWS PERSIST. Earlier rows dim; they do not disappear. The last frame of the
   build must contain the whole set. A list where each row replaces the last is a
   slideshow and is a weaker pattern.

6. ADVANCE ON THE WORD, not on a timer: move the current-row signal within
   +/-0.2s of the word naming the new row, cross-fading colour over 0.30s
   power2.out. Stage interval 1.2-3.0s, following the narration.

7. ENTRANCE: rows translate 2u plus autoAlpha over 0.40s power3.out, staggered
   0.10s top-down. Four rows x 0.10s = 0.40s total, inside the 0.5s cap that keeps
   an arrival reading as one beat.

8. DO NOT put an item marker for the same set on screen at the same time. That is
   the same structural information twice.

ACCEPTANCE TEST:
(a) 3-5 rows, each <= 4 words, none containing a finite verb;
(b) every label's left edge is identical to the pixel;
(c) row pitch divided by cap height is between 2.0 and 2.4;
(d) the current row is identifiable in a greyscale conversion;
(e) dimmed rows measure >= 4.5:1 against the ground;
(f) every row present at the first advance is still present at the last frame;
(g) each advance lands within +/-0.2s of its naming word in the transcript;
(h) the whole card fits inside the graphic band with >= 4% of frame height of
    clearance to the caption band.
```

## Execution spec

**HyperFrames.** A CSS grid with a fixed first column is the ordinal gutter; the current-row signal is a class swap driven by zero-duration `tl.set()` calls plus a colour tween.

```html
<div id="list" class="clip" data-start="212.40" data-duration="14.0" data-track-index="3">
  <div class="list-card">
    <div class="list-title">The five layers</div>
    <div class="row" id="row-1"><span class="ord">1</span><span class="lbl">Dialogue</span></div>
    <div class="row" id="row-2"><span class="ord">2</span><span class="lbl">Ambience</span></div>
    <div class="row" id="row-3"><span class="ord">3</span><span class="lbl">Music</span></div>
    <div class="row" id="row-4"><span class="ord">4</span><span class="lbl">Effects</span></div>
  </div>
</div>
```

```css
[data-composition-id="gfx"] .list-card{
  position:absolute; left:calc(6 * var(--w)); right:calc(6 * var(--w));
  bottom:calc(30 * var(--u));
}
[data-composition-id="gfx"] .list-title{
  font-size:var(--s2); color:var(--ink); margin-bottom:calc(2 * var(--u));
}
[data-composition-id="gfx"] .row{
  display:grid;
  grid-template-columns: calc(4 * var(--u)) 1fr;    /* the ordinal gutter */
  align-items:baseline;
  block-size: calc(7.1 * var(--u));                 /* 2.2 x cap height at s0 */
  color: var(--ink-dim);                            /* default state: dim */
}
[data-composition-id="gfx"] .row .ord{
  font-size:var(--s0); font-variant-numeric: lining-nums tabular-nums;
}
[data-composition-id="gfx"] .row .lbl{ font-size:var(--s0); }
[data-composition-id="gfx"] .row.is-current{ color: var(--ink); }
[data-composition-id="gfx"] .row.is-current .ord{ color: var(--accent); }
```

```js
// advances taken from transcript.json, absolute composition seconds
const ADVANCE = [213.10, 216.40, 219.90, 223.80];
ADVANCE.forEach((t, i) => {
  // colour cross-fade, 0.30s power2.out. Colour tweens never take an overshooting ease.
  if (i > 0) tl.to(`#row-${i}`,     { color: "var(--ink-dim)", duration: 0.30, ease: "power2.out" }, t);
  tl.to(`#row-${i + 1}`,            { color: "var(--ink)",     duration: 0.30, ease: "power2.out" }, t);
  tl.to(`#row-${i + 1} .ord`,       { color: "var(--accent)",  duration: 0.30, ease: "power2.out" }, t);
  if (i > 0) tl.to(`#row-${i} .ord`,{ color: "var(--ink-dim)", duration: 0.30, ease: "power2.out" }, t);
});
```

Contract points:

- **Dim with `color`, never `opacity`.** `opacity < 1` makes the element a **backdrop root** (killing any `backdrop-filter` behind it) and also dims the row's plate and its ordinal's accent together, which destroys the two-cue signal.
- **Class toggles are not seek-safe; property tweens are.** A `classList.add()` inside a callback fires on forward entry only and does not reverse on a backwards seek — the same fragility the reference caption implementation carries with `onStart`. Tween the properties instead, as above, so every state is a function of `tl.time()`.
- **Colour tweens take a non-overshooting ease.** At damping fractions below 1, overshooting curves go **on transforms only** — never on opacity or colour.
- **Never tween `height` to reveal rows.** `width`/`height`/`top`/`left` tweens are forbidden. Reveal with `autoAlpha` plus a `y` translate, or clip with a mask.
- **Stagger cap:** `items × stagger ≤ ~0.5 s`, so four rows at 0.10 s is at the edge and five rows needs 0.10 s or less. Stagger *in order of importance*, which for a list is top-down.
- **`fromTo`, never `from`**; `autoAlpha` on inner elements only; land the last tween before `data-duration`.
- **The wrapper carries `data-start` and clamps its descendants**, so one attribute retires the whole card.
- **`grid-template-columns` with a fixed first track is the gutter**, and it survives a type-size change because the track is in `u`. Do not use `padding-left` on the label — it moves when the ordinal's width changes.
- **A CSS `transform` on a GSAP-tweened element raises `gsap_css_transform_conflict` (error)**, and a lint error disables the layout and contrast audits entirely (`0 sample(s)`, `0/0 text checks`).
- **Sound:** one soft transient per advance — a tick or pop at **−18 to −24 dBFS relative to the mix**, not a whoosh; a whoosh on every stage reads as noise ([[motion-progressive-information-build]], [[sfx-appearance-transient]]).

**ffmpeg — the persistence and signal audits:**

```bash
# element count must be monotonically non-decreasing across the build
ffmpeg -ss 212.4 -t 14 -i out.mp4 -vf fps=1 -q:v 2 /tmp/l/%02d.png
# greyscale check on the current-row signal
ffmpeg -ss 217.0 -i out.mp4 -frames:v 1 -vf "format=gray" /tmp/l/grey.png
```

**Remotion.** Rows as a mapped array with `interpolate` driving each row's colour from the advance schedule; the state is a pure function of the frame, which sidesteps the seek trap entirely.

## Pairs with
[[motion-list-item-marker-card]] · [[gfx-structure-duplicates-prose-does-not]] · [[gfx-progress-step-indicator]] · [[motion-progressive-information-build]] · [[motion-explainer-beat-animation]] · [[gfx-modular-type-scale]] · [[gfx-palette-ground-ink-accent]] · [[gfx-attention-budget-simultaneity]] · [[gfx-channel-decision-procedure]] · [[motion-persistent-item-counter]] · [[struct-enumerated-promise-and-counter]] · [[sub-list-marker-caption-lockup]] · [[sfx-five-layers-build-order]]

## Failure modes
- **Seven rows.** A poster. Nobody holds seven chunks, and the card will not fit the graphic band anyway.
- **Inline ordinals.** `10.` pushes its label and the left edge goes ragged on exactly the row being read.
- **One cue for the current row.** Fails in greyscale, fails for colour-deficient viewers, and is weak at a glance.
- **Dimming with `opacity`.** Dims the plate and the accent together, so the two-cue signal collapses to one, and it silently disables any blur behind.
- **Dimmed rows below 4.5:1.** An accessibility failure that looks like a design decision.
- **Rows that replace each other.** A slideshow. The last frame no longer contains the argument.
- **Advancing on a timer.** The signal drifts off the narration within three items and the card stops being about the speech.
- **Rows carrying definitions.** Prose duplication, unreadable at 13 cps, and the reason the four-word ceiling exists.
- **A list card and an item marker for the same set.** The same structural information twice, competing for one fovea.
- **A class toggle for the current row.** Not seek-safe; a backwards seek leaves the wrong row lit.
- **A causal set in a list.** A list asserts membership. If the order is causal, the viewer needs arrows, and arrows mean a diagram.
- **Known gap:** no list card appears in the reference set — the observed material uses stacked labels for pairs and full-frame markers for a ten-item list, which is consistent with the ceiling this note derives but does not confirm the row geometry. The pitch, gutter and dim numbers are derived from the type scale and the working-memory limit, not measured from a creator.
