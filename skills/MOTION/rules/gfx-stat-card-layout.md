---
id: gfx-stat-card-layout
title: The stat card — one number, one unit, one qualifier, and the tabular figures that stop the jitter
skill: motion
type: graphic
family: graphic-components
tags: [skill/motion, type/graphic, family/graphic-components, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "visual — contact sheet, analytics-as-proof"
    quote: "[NOT SPOKEN — observed on screen] YouTube Studio screenshots with real figures — 239,516 views, 14.9K, +6.5K, $916.71 — used as evidence rather than as decoration."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "visual — contact sheet, title cards"
    quote: "[NOT SPOKEN — observed on screen] A title card reading 'Vocals Vol / −3 to 0dB' with a waveform glyph, cut against a Premiere audio meter — the number is the payload and the glyph carries the category."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:24"
    quote: "Sound is half of your video."
research_refs:
  - https://developer.mozilla.org/en-US/docs/Web/CSS/font-variant-numeric
  - https://link.springer.com/content/pdf/10.1007/s10648-018-9435-9.pdf
  - https://legibility.info/rules-for-text-in-videos
  - https://uxdesign.cc/legibility-how-to-make-text-convenient-to-read-7f96b84bd8af
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
difficulty: medium
detectable_from: transcript+video
---

# The stat card — one number, one unit, one qualifier, and the tabular figures that stop the jitter

## What it is

The component for the QUANTITY payload: **one number, made unmissable.** Three type objects and nothing else.

| Slot | Content | Type step | Role |
|---|---|---|---|
| **Value** | The number, formatted as it is spoken | `s5` (13.73 % of frame height) | The payload |
| **Unit** | `views`, `dB`, `%`, `seconds`, `$` | `s2` (7.03 %) | What kind of quantity it is |
| **Qualifier** | `in 30 days`, `after the change`, `per video` | `s-1` (3.60 %) | The condition that makes it true |

The ratios are `s5 : s2 : s-1` = **1 : 0.51 : 0.26**. Three steps and three steps apart — well clear of the 1.4× floor in both gaps, which is why a stat card reads instantly as a hierarchy rather than as three sizes.

**The single most reliable amateur tell in the medium is horizontal jitter in the value.** If the digits are proportional figures, `1` is narrower than `8`, so the number's box changes width as the digits change — and any counted roll-up ([[motion-number-rollup-stat-reveal]]) shifts its own left edge, its unit, and everything after it, on nearly every frame. The fix is one CSS declaration, `font-variant-numeric: lining-nums tabular-nums`, which activates the OpenType `lnum` and `tnum` features: *"the set of figures where numbers are all of the same size, allowing them to be easily aligned like in tables."* It costs nothing and it is the difference between a graphic that looks built and one that looks generated.

**Tabular figures are necessary and not sufficient.** A number counting from `0` to `41,000` gains digits, and a digit-count change widens the box even with tabular figures. So the value's box is **reserved at its final width** — right-aligned inside a fixed box sized to the target string, or centred inside a box whose width is `ch`-derived from the longest intermediate state. Reserve first, animate second.

**Unit placement is a baseline decision, not a layout decision.** A unit set beside the value aligns **baseline to baseline** if it is a word (`views`, `seconds`) and **cap to cap** if it is a symbol that reads as a superscript (`%`, `°`). A `$` prefix aligns cap-to-cap and sits before the value. Getting this wrong is the thing that makes a stat card look like a web dashboard rather than like a designed frame.

**Spatial contiguity applies to the unit and the qualifier.** They belong *next to* the number — meta-analysed at `g = 0.63` across 58 comparisons (n = 2426) — not in a legend, not in the caption, and not implied by context. `41,000` alone is not a stat; `41,000 views in 30 days` is.

**One number per card, and the reason is mechanical.** The eye cannot track two changing digit fields, so two counters running together means neither lands. Two numbers that are *both* static can share a card only as a comparison, and then it is a comparison card, which has a divider and a parallel structure ([[gfx-comparison-two-column-card]]).

**The delta chip is the one permitted fourth object.** A change (`+38 %`, `▲ 6.5K`) set at `s-1` in `--accent`, in a chip, adjacent to the value. It is a second quantity, so it must be a *derived* one — the change in the value on the card, never an unrelated second statistic.

## When to use it

- **The beat's payload is a number and the narration says it out loud.** If the voice does not say the number, put it up statically or not at all — animating a number nobody says is animation for its own sake.
- **The number is the verdict** of a comparison or the punchline of a claim.
- **The number is evidence.** The observed analytics-as-proof device is a stat card whose value happens to be a screenshot; when the credibility comes from the source being real, prefer the real screenshot plus an annotation mark over a rebuilt card ([[struct-analytics-screenshot-proof]], [[gfx-annotation-mark-set]]).
- **A bar or fill is growing** — then its label counts in lockstep and both land on the same frame.
- **Not** for an identifier: a year, a version, a phone number, a price to copy down. Counting to `2024` reads as a bug.
- **Not** two at once.
- **Not** when the qualifier would need a clause. `41,000 views, which was up from 400 before we changed the thumbnail` is prose; the clause belongs to the voice.

## How to recognise it in a reference video

- **Count type objects on the card.** 3, or 4 with a delta chip. Five or more is a dashboard.
- **Measure the three sizes and take ratios.** Value : unit ≈ **2:1**, value : qualifier ≈ **4:1**. Ratios under 1.4× anywhere mean two objects will read as one level.
- **Check the value's cap height** as a percentage of frame height: **9–13 %** is the `s5` band. Above 15 % it is a hero number owning the frame; below 7 % it is a chip, not a card.
- **The jitter test, and it is decisive.** Extract at full frame rate across the reveal and watch the value's **left edge and the unit's position**:
  ```bash
  ffmpeg -ss 96.2 -t 1.5 -i ref.mp4 -vf fps=30 -q:v 2 /tmp/s/%03d.png
  ```
  If either moves as digits change, the figures are proportional or the box was not reserved. This single test separates competent from generated.
- **Check for real counting.** Read the digits frame by frame. Monotonic intermediate values ⇒ a genuine roll-up; the final value on frame 1 with only a scale/opacity animation ⇒ a fake, which is a legitimate weaker variant — log it as such.
- **Check the landing frame against the transcript.** The final value should be reached within **±3 frames** of the spoken number's onset, and never *after* the word has finished.
- **Check the unit's alignment.** Overlay a baseline through the value: a word unit sits on it, a `%` sits above it at cap height. A word unit floating above the baseline is the standard mistake.
- **Check the qualifier exists at all.** A bare number with no unit and no condition is a number the viewer cannot use, and it is the commonest content failure in stat cards.
- **Check the pop.** A scale bump of **4–8 % over 5–6 frames** on the landing frame is the conventional punctuation; measure the value's cap height across three frames.
- **Audio.** A rising tick or riser under the count and a short hit on the landing frame. Silence under a 1 s count is a detectable omission.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `numbers_per_card` | 1 | 1 | Hard. Two changing digit fields means neither is read. |
| `type_objects` | 3 | 3–4 | Value, unit, qualifier; plus an optional delta chip. |
| `value_step` | `s5` (13.73 % of frame height) | `s4`–`s6` | Cap height 9–13 %. |
| `unit_step` | `s2` (7.03 %) | `s1`–`s3` | Value : unit ≈ 2:1. |
| `qualifier_step` | `s-1` (3.60 %) | `s-2`–`s0` | Value : qualifier ≈ 4:1. |
| `value_weight` | display cut (400–500 on dark) | 400–650 | Display steps take the lighter cut ([[gfx-weight-and-optical-size]]). |
| `numerals` | `lining-nums tabular-nums` | required | The `lnum`/`tnum` OpenType features. **Not optional.** |
| `box_reserved` | at the final string's width | required | Tabular figures do not fix a digit-count change. Reserve, then animate. |
| `value_alignment` | right, or centred in a reserved box | — | A left-aligned counting value moves its own right edge, which drags the unit. |
| `unit_alignment` | baseline (word) / cap (symbol) | — | `views` on the baseline; `%`, `°` at cap height; `$` before the value at cap height. |
| `unit_gap` | 0.25 em of the value | 0.15–0.4 em | In `em` so it scales. |
| `qualifier_gap` | 1.2 u below the value's baseline | 1–2 u | Directly under, not in a corner. |
| `delta_chip` | optional, 1 | 0–1 | `s-1` in `--accent`, in a chip, adjacent. Must be the change **in this value**. |
| `qualifier_words` | ≤4 | 1–5 | No finite verb. A condition, not a clause. |
| `count_duration` | 0.8 s (24 f) | 0.5–1.5 s | 15–45 f is the working band; over 45 f the count is watched, not read. |
| `count_ease` | `power2.out` | `power1.out`–`power3.out` | Decelerating. A linear count reads mechanical. |
| `landing_offset` | 0 f from the spoken number | ±3 f | Never after the word has finished. |
| `pop` | +6 % scale over 5 f | +4 to +8 % | On the landing frame. Transform only, never on opacity or colour. |
| `dwell_after_landing` | max(2.0 s, chars ÷ 13) | ≥2.0 s | ×2.5 if a caption is live ([[gfx-attention-budget-simultaneity]]). |
| `identifiers` | forbidden | — | Years, versions, phone numbers, prices to copy. |
| `contrast_value` | ≥4.5:1 | ≥4.5:1 | At the worst frame if the card is over footage. |
| `sfx` | tick/riser under + hit on landing | — | Silence under a count is a detectable omission. |

## Reproduction prompt

```
Build a stat card for the value {{VALUE}} {{UNIT}}, qualified by {{QUALIFIER}},
landing on the spoken number at {{T_WORD}}.

1. THREE TYPE OBJECTS, and no more (four with a delta chip):
     VALUE     step s5 (13.73% of frame height), display weight cut
     UNIT      step s2 (7.03%)   - what kind of quantity this is
     QUALIFIER step s-1 (3.60%)  - the condition that makes it true, <=4 words,
                                   NO finite verb
   A bare number with no unit and no condition is a number the viewer cannot use.

2. SET TABULAR FIGURES on the value:
     font-variant-numeric: lining-nums tabular-nums;
   Proportional figures make 1 narrower than 8, so the box changes width as
   digits change and the unit and everything after it shift on almost every
   frame. That horizontal jitter is the single most reliable amateur tell in the
   medium and it costs one declaration to remove.

3. RESERVE THE BOX at the FINAL string's width and right-align (or centre) the
   value inside it. Tabular figures fix digit WIDTH, not digit COUNT: counting
   from 0 to 41,000 gains characters, and the box must already be that wide
   before the count starts.

4. ALIGN THE UNIT BY KIND, not by eye: a word unit (views, seconds) sits on the
   value's BASELINE; a symbol that reads as a superscript (%, degrees) aligns
   CAP-TO-CAP; a $ prefix sits before the value, cap-aligned. Gap 0.25em of the
   value's own size. The qualifier sits 1.2u directly BELOW the value's baseline -
   adjacent, never in a corner and never left to the caption (spatial contiguity,
   g = 0.63 over 58 comparisons).

5. ONE NUMBER PER CARD. Two changing digit fields cannot both be tracked, so
   neither lands. If the beat needs two numbers, it is a comparison and it needs
   the comparison card.

6. ANIMATE: count over 0.8s with power2.out so the per-frame deltas shrink, and
   land the final value within +/-3 frames of the spoken number's onset - never
   after the word has finished. Add a +6% scale pop over 5 frames on the landing
   frame, on TRANSFORM only (never on opacity or colour). Hold
   max(2.0s, chars/13) afterwards, multiplied by 2.5 if a caption is live.

7. DO NOT COUNT AN IDENTIFIER. A year, a version, a phone number or a price the
   viewer must copy is not a quantity; counting to 2024 reads as a bug.

8. SOUND: a rising tick or riser under the count, a short hit on the landing
   frame. Silence under a count is a detectable omission.

ACCEPTANCE TEST:
(a) extract every frame across the reveal and confirm the value's left edge and
    the unit's position do not move by a single pixel;
(b) intermediate digit values are monotonic (a real count, not a fake);
(c) the final value is reached within +/-3 frames of the spoken number;
(d) exactly one number, one unit and one qualifier are on the card;
(e) value:unit is about 2:1 and value:qualifier about 4:1, both gaps above 1.4x;
(f) grep for font-variant-numeric on the value element - missing fails;
(g) if the card sits over footage, the value clears 4.5:1 at the worst frame.
```

## Execution spec

**HyperFrames.** The reserved box is the part worth building carefully; everything else is three divs.

```html
<div id="stat" class="clip" data-start="96.20" data-duration="4.20" data-track-index="3">
  <div class="stat-wrap">
    <div class="stat-row">
      <span class="stat-value" id="stat-v">0</span>
      <span class="stat-unit">views</span>
    </div>
    <div class="stat-qual">in 30 days</div>
  </div>
</div>
```

```css
[data-composition-id="gfx"] .stat-row{ display:flex; align-items:baseline; gap:0.25em; }
[data-composition-id="gfx"] .stat-value{
  font-size: var(--s5);
  font-weight: var(--w-display);
  font-variant-numeric: lining-nums tabular-nums;   /* lnum + tnum. Mandatory. */
  letter-spacing: var(--track-display);
  line-height: 0.95;
  /* reserve the FINAL width: 6 characters for "41,000" */
  min-inline-size: 6ch;
  text-align: right;
  font-feature-settings: "tnum" 1, "lnum" 1;        /* belt and braces */
}
[data-composition-id="gfx"] .stat-unit{ font-size: var(--s2); font-weight: var(--w-body); }
[data-composition-id="gfx"] .stat-qual{
  font-size: var(--s-1); color: var(--ink-dim);
  margin-top: calc(1.2 * var(--u));
}
```

```js
// 24 frames @30fps = 0.8s. Count, then pop. Landing frame = the spoken number.
const T_LAND = 97.00;                       // from transcript.json
const counter = { n: 0 };
const fmt = new Intl.NumberFormat("en-US"); // deterministic; no locale sniffing
tl.to(counter, {
  n: 41000, duration: 0.80, ease: "power2.out",
  onUpdate: () => { document.getElementById("stat-v").textContent =
                    fmt.format(Math.round(counter.n)); }
}, T_LAND - 0.80);
// the pop: transform only
tl.fromTo("#stat-v", { scale: 1 }, { scale: 1.06, duration: 0.17, ease: "power2.out" }, T_LAND);
tl.to("#stat-v", { scale: 1, duration: 0.20, ease: "power2.inOut" }, T_LAND + 0.17);
```

Contract points, several of which are traps specific to counters:

- **`min-inline-size: 6ch` is the reservation.** `ch` is the width of the `0` glyph, which with `tnum` active is the width of *every* digit — so `6ch` is exactly the width of `41,000` minus the comma's narrower advance. Verify on a snapshot rather than trusting the arithmetic, and widen by `0.5ch` if the comma pushes it.
- **The counter is a plain object tweened by GSAP, with `onUpdate` writing `textContent`.** This is the sanctioned shape; the contract names `counting-dynamic-scale` and `vertical-spring-ticker` as existing animation rules for the two mechanisms (interpolated count and odometer roll), and their code is not staged, so do not quote it.
- **Do not tween `font-size`, `width` or `height`.** The pop is `scale`. Transformed elements must be block-level and sized — `span` needs `display:inline-block` or the transform is ignored.
- **The pop goes on a transform, never on opacity or colour.** The contract is explicit that at damping fractions below 1, overshooting curves go on transforms only; and a scale pop on `opacity` would fight the entrance.
- **`Intl.NumberFormat` is deterministic and safe.** What is *not* safe: `Date.now()`, `performance.now()`, unseeded `Math.random()`, network fetches. A counter must be a pure function of `tl.time()`.
- **The backwards-seek trap.** Writing `textContent` in `onUpdate` is seek-safe *while the tween is active*, but a seek landing **before** the tween leaves the last-written value on screen. Add a zero-duration `tl.set()` at the tween's start writing the initial string, so a backwards seek restores it. This is the same class of fragility the reference caption implementation carries with `onStart`.
- **`fromTo`, never `from`**; `autoAlpha` on inner elements only; land the last tween before `data-duration` (4.20 here, with the pop ending at 97.37 − 96.20 = 1.17 s in, comfortably inside).
- **`data-track-index` layers nothing** — use CSS `z-index`; cards sit in the 20 band.
- **If the value is real evidence, prefer the screenshot.** A rebuilt number is a claim; a screenshot with an annotation mark is evidence, and the credibility difference is the whole point of the analytics-as-proof device.

**ffmpeg — the jitter test, which is the acceptance test that matters:**

```bash
ffmpeg -ss 96.2 -t 1.4 -i out.mp4 -vf fps=30 -q:v 2 /tmp/s/%03d.png
# crop a 4px column at the value's left edge across all frames; any change = jitter
for f in /tmp/s/*.png; do
  ffmpeg -loglevel error -i "$f" -vf "crop=4:120:210:980" -f rawvideo -pix_fmt gray - | md5sum
done | sort -u | wc -l     # expect 1 for the held state, few for the count
```

**Remotion.** `interpolate(frame, ...)` into a formatted string, with the same `tabular-nums` and the same reserved box; nothing here is stack-specific except the seek trap, which Remotion avoids by deriving the value from `useCurrentFrame()` rather than writing it in a callback.

## Pairs with
[[motion-number-rollup-stat-reveal]] · [[gfx-modular-type-scale]] · [[gfx-weight-and-optical-size]] · [[gfx-comparison-two-column-card]] · [[gfx-annotation-mark-set]] · [[gfx-attention-budget-simultaneity]] · [[gfx-channel-decision-procedure]] · [[motion-progressive-information-build]] · [[struct-analytics-screenshot-proof]] · [[struct-credibility-anchor]] · [[sfx-riser-hit-pair]] · [[sfx-peak-on-impact-frame]] · [[motion-persistent-item-counter]]

## Failure modes
- **Proportional figures.** The value's box breathes as digits change and the unit walks. One declaration fixes it; nothing else does.
- **Tabular figures without a reserved box.** Digit *width* is fixed, digit *count* is not, so a count from `0` to `41,000` still grows the box.
- **A bare number.** No unit, no condition. The viewer cannot use it and the card asserts nothing.
- **The unit or qualifier in the caption instead of on the card.** Throws away the spatial-contiguity benefit and makes the card depend on a channel the muted viewer may not be reading.
- **A word unit aligned to cap height.** Floats above the baseline; the commonest small mistake in the component.
- **Two numbers counting.** Neither is tracked, neither lands.
- **Counting an identifier.** `2024` ticking up reads as a bug, not as emphasis.
- **Landing after the word.** The graphic is now trailing the voice, which is the one direction that reads as a mistake rather than as anticipation.
- **A linear count.** Constant per-frame deltas read mechanical. Decelerate.
- **A 2 s count.** The viewer watches the counting instead of reading the number.
- **The pop on opacity.** Fights the entrance and, at an overshooting ease, is explicitly banned on non-transform properties.
- **A backwards seek showing the wrong value.** `onUpdate`-written text is not restored by a seek that lands before the tween. Add the zero-duration `tl.set()`.
- **Rebuilding a number that should be a screenshot.** Loses the credibility that was the reason for showing it.
- **Known gap:** whether the observed analytics figures were animated or static is not recoverable from a contact sheet — they appear as screenshots, which suggests static. The counting numbers in this note are the library's own animation band, taken from [[motion-number-rollup-stat-reveal]]; the *layout* numbers are derived from the type scale. Neither is a measurement of a specific creator's stat card, because the reference set does not contain a rebuilt one.
