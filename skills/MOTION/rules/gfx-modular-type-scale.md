---
id: gfx-modular-type-scale
title: The modular type scale — one ratio, eight steps, every step a percentage of frame height
skill: motion
type: type-motion
family: visual-system
tags: [skill/motion, type/type-motion, family/visual-system, engine/hyperframes, engine/remotion, source/hyperframes, source/sfx-kt-2, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Video type sizes, not web sizes. Full-screen viewing: body ≥20px, headlines 60px+, data labels 16px. In-feed viewing (X / LinkedIn / Instagram): body ≥32px, headlines ≥90px, data labels ≥24px. 48px caption text sits comfortably in the full-screen band."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, item marker cards"
    quote: "[NOT SPOKEN — observed on screen] A large ordinal set against a much smaller item label, the same two sizes on every item card in the video."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "visual — contact sheet, concept cards"
    quote: "[NOT SPOKEN — observed on screen] A script-face concept title with a small second-accent sub-label directly beneath it — two sizes, repeated card to card."
research_refs:
  - https://www.typographymaster.com/guide/type-scale-systems
  - https://uxdesign.cc/legibility-how-to-make-text-convenient-to-read-7f96b84bd8af
  - https://legibility.info/font-size-calculator
  - https://legibility.info/rules-for-text-in-videos
  - https://pmc.ncbi.nlm.nih.gov/articles/PMC8093538
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
difficulty: medium
detectable_from: video
---

# The modular type scale — one ratio, eight steps, every step a percentage of frame height

## What it is

The design layer's first artefact: a **closed list of eight type sizes**, generated from one ratio, each expressed as a percentage of frame height, from which every piece of on-screen type in the video is drawn. Nothing is sized by eye and nothing is sized per component. A stat number is step 5. A list row is step 0. A callout label is step −1. If a size is not on the list, it does not get used.

Two decisions make the scale, and this note fixes both.

**The unit is a percentage of frame height, never a point size and never a bare pixel.** A point is 1/72 inch and there is no inch anywhere in this pipeline; a rendered video has no physical size. A pixel is meaningful only once you also state the frame height, which is the same as stating a percentage and saving a step. Height rather than width is the right denominator because height is the dimension that fills the viewer's screen in both orientations — a size expressed as a percentage of frame *width* is correct at 16:9 and 78 % oversized at 9:16. The subtitles library reached this conclusion for captions first ([[sub-size-as-frame-height-percentage]]); this note is the same rule extended to every graphic, and it deliberately uses **the same `--unit` token**, so captions and graphics scale together rather than in parallel.

**The anchor is the caption track, not a headline.** This is the load-bearing choice. The caption track is the one type object that is on screen for most of the runtime, that has a research-backed size floor, and that a viewer reads hundreds of times. Anchoring the scale on anything else guarantees a graphic system whose sizes sit *between* the caption sizes, which is exactly how two type systems in one frame come to look like two videos. Step 0 is therefore the caption body size: **4.5 % of frame height**, which is `48.6 px` at 1080 tall and `86.4 px` at 1920 tall — and the reference implementation's hand-authored `font-size: 48px` on a 1080-tall composition is 4.44 %, i.e. step 0 to within 1.3 %.

At ratio **1.25** (the major third) anchored on 4.5 %, the scale is:

| Step | % of frame height | px @1080 tall | px @1920 tall | Cap height (×0.72) | Role |
|---|---|---|---|---|---|
| `s-2` | 2.88 | 31 | 55 | 2.07 % | Micro-label, axis tick, attribution. **16:9 only.** |
| `s-1` | 3.60 | 39 | 69 | 2.59 % | Callout label, annotation label, secondary line |
| `s0` | 4.50 | 49 | 86 | 3.24 % | **Anchor.** Caption track, body, list row |
| `s1` | 5.63 | 61 | 108 | 4.05 % | Sub-head, lower-third name, emphasis caption |
| `s2` | 7.03 | 76 | 135 | 5.06 % | Card title, comparison column head |
| `s3` | 8.79 | 95 | 169 | 6.33 % | Statement line, section title, concept-card title |
| `s4` | 10.99 | 119 | 211 | 7.91 % | Quote line, stat unit |
| `s5` | 13.73 | 148 | 264 | 9.89 % | Stat number |
| `s6` | 17.17 | 185 | 330 | 12.36 % | Topic word, hero ordinal |

That is nine rows for eight usable steps plus the 16:9-only micro step — inside the published guidance that a working scale carries eight to ten steps from caption to display.

**The scale validates against the library's existing observed numbers, which is the reason to trust it rather than a different ratio.** [[motion-abstract-concept-card]] records a `96 px` title at 1080 = 8.89 %, and `s3` is 8.79 %. [[motion-list-item-marker-card]] records a `180 px` ordinal at 1080 = 16.67 % against `s6` at 17.17 %, and a `64 px` label = 5.93 % against `s1` at 5.63 %. The reference caption file's `48 px` is `s0`. Four independently-observed sizes from three sources land within 6 % of four steps of one 1.25 scale. The scale is not invented; it is the scale the reference material was already using.

**The one hard adjacency rule.** Two type objects one step apart do **not** read as different levels — 1.25 is below the discrimination threshold the subtitles library already measured, where an emphasis mark under 1.4× the track size "reads as part of the track". So: **inside one visual group, never use adjacent steps. Jump two.** Two steps of 1.25 is 1.5625×, which clears 1.4×. The observed pairs obey this — `s6`/`s1` on the marker card is a five-step jump; `s3`/`s0` on the concept card is three.

## When to use it

Once per style profile, before any component is laid out, and then never re-decided.

- **At the start of Mode B**, as the first row of the visual system, alongside the palette ([[gfx-palette-ground-ink-accent]]) and the grid ([[gfx-vertical-grid-and-margins]]).
- **At the end of Mode A**, as the deliverable of the type-measurement pass: nine numbers and a ratio, not "the titles are big".
- **Whenever a second aspect ratio is added.** The percentages carry over unchanged; that is the whole point of the unit.
- **Whenever a new component is designed.** It picks steps, it does not pick sizes.
- **Pick a different ratio, not a different method,** when the content demands it: `1.25` for information-dense work (lists, comparisons, diagrams, dashboards — more usable levels in a limited range), `1.333` for statement-led work (title cards, quotes, single-idea beats), `1.5` only for a card-driven format with 4–5 levels total. Do not exceed `1.5` in a 9:16 frame: at `1.618`, `s3` is already 18.9 % of frame height and a three-word line will not fit the measure.
- **Not** as a licence to use all nine steps in one composition. Three steps per card, four per video section.

## How to recognise it in a reference video

Every signal here is measurable from a **single frame** plus `ffprobe`, which is what makes type scale the cheapest thing to profile.

1. `ffmpeg -ss <t> -i ref.mp4 -frames:v 1 -q:v 2 f.png` for 8–12 frames chosen to include the largest and smallest type in the video.
2. Read frame height `H` from `ffprobe`.
3. On each type object, measure **cap height** in pixels on a flat-topped capital — `H`, `T`, `E`, `I`. Never `O` (overshoot), never `A` (apex), never a lowercase letter.
4. Report `cap_height / H` as a percentage, to two decimals. Derive `font-size %` as `cap % ÷ cap-ratio` (≈ 0.72 for most grotesques; measure it once per family).

| Reading | Interpretation |
|---|---|
| Distinct cap-height values across the whole video: **3–5** | A scale exists and is being used with discipline. |
| Distinct values: **6–9** | A scale exists and is being over-used. |
| Distinct values: **10+**, none repeating | No scale. Sizes chosen per object. |
| Ratio between consecutive distinct values, sorted | Constant within ±4 % ⇒ a modular scale; divide to recover the ratio. `1.24–1.26` = major third, `1.32–1.34` = perfect fourth, `1.48–1.52` = perfect fifth. |
| Two sizes in one frame whose ratio is **< 1.4** | Adjacent steps used in one group — the hierarchy will not read. Log it as a fault, not a style. |
| The same cap-height % recurring in two different components | The anchor step. Usually the caption track. |
| Identical **px** sizes in a 16:9 cut and a 9:16 cut of the same content | Hard-coded pixels; the vertical cut is 44 % too small relative to its frame. |
| Identical **percentages** across both cuts | A percentage token survived the reframe. |

Two cross-checks worth running because they catch different faults. **Character count:** at the measured size and the measured text box width, count how many characters fit on one line. Netflix calibrates timed text at about 42 characters across; video-graphic practice caps a line at 30. A box that fits 60 characters at the measured size means the size and the measure disagree and one of them is wrong. **Visual-angle floor:** see the parameters table — it is a floor, not a target, and almost nothing in real work is near it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `unit` | 1 % of frame height | — | `--unit: calc(var(--fh) / 100 * 1px)`. **The same token the caption identity uses** ([[sub-caption-identity-token-set]]). Declare once on the composition root. |
| `denominator` | frame height | height only | Width is wrong at 9:16 by 78 %; diagonal is wrong everywhere. |
| `ratio` | 1.25 (major third) | 1.25 / 1.333 / 1.5 | 1.25 information-dense, 1.333 statement-led, 1.5 card-driven with ≤5 levels. Above 1.5 the top steps do not fit a 9:16 measure. |
| `anchor_step` | `s0` = 4.5 % | 4.0–5.5 % | The caption body size. The reference file's `48 px` on 1080 is 4.44 %. In-feed designs may anchor at 5.0 %. |
| `steps_defined` | 9 (`s-2`…`s6`) | 8–10 | Published guidance: eight to ten steps caption-to-display. |
| `steps_per_card` | 3 | 2–3 | Three type sizes on one card. A fourth is drift. |
| `steps_per_video` | 5 | 4–6 | Across all components. Six distinct sizes is the upper bound of "a system". |
| `min_adjacent_ratio` | 1.5625 (2 steps) | ≥1.4 | Never adjacent steps in one visual group. 1.4 is the discrimination floor from [[sub-size-as-frame-height-percentage]]. |
| `cap_ratio` | 0.72 | 0.68–0.74 | Face-dependent. Measure once per family; two faces at "4.5 %" differ by up to 9 % apparent size. |
| `cap_height_comfort_floor` | 1.6 % of frame height | ≥1.6 % | Derived: ISO 9241-303 puts comfortable reading at **20–22 arcmin** of cap height; measured mean smartphone viewing distance is **36.8 ± 6.6 cm** (n = 233). `2 × 368 mm × tan(10.5′) = 2.25 mm`, over a ~140 mm phone display height = 1.6 %. |
| `cap_height_absolute_floor` | 1.2 % of frame height | ≥1.2 % | Same derivation at ISO's **16 arcmin** minimum: 1.71 mm ÷ 140 mm. Convergent across contexts: a 16:9 laptop frame at 60 cm gives 1.49 %, a 55″ TV at 2.5 m gives 1.70 %. **This is why frame-height percentage is the correct unit** — the acuity floor is nearly constant in it. |
| `px_floor_full_screen` | 20 body / 60 headline / 16 label | — | The project's stated full-screen floors, at the composition's own resolution. |
| `px_floor_in_feed` | 32 body / 90 headline / 24 label | — | In-feed floors, ~60 % higher. Check every derived px value against the pair that applies. |
| `line_char_max` | 30 | 24–36 | Published video-text rule. 42 is Netflix's timed-text calibration for a caption track specifically. |
| `lines_max` | 3 | 1–3 | Published video-text rule. |
| `dwell_floor` | chars ÷ 13 per second | ≥13 cps | Published minimum dwell for on-screen text: 1 s per 13 characters. A 30-character line needs ≥2.3 s **stationary**. |
| `steps_below_s0_in_9x16` | 1 (`s-1` only) | — | `s-2` at 2.88 % is a 16:9 step. At 9:16 it survives acuity but not glanceability. |
| `pt_values_permitted` | none | — | There is no inch in the pipeline. |
| `px_values_permitted` | inside the token block only | — | Everywhere else, `calc()` off `--unit`. |

## Reproduction prompt

```
Produce the modular type scale for {{PROJECT}}, delivered at {{ASPECT}}
{{WIDTH}}x{{HEIGHT}}, viewed {{in-feed|full-screen}}.

1. PICK THE UNIT. One unit = 1% of frame height. Declare it once on the
   composition root as
     --fh: {{HEIGHT}};                        /* must equal root data-height */
     --unit: calc(var(--fh) / 100 * 1px);
   Every type size in the project is calc(<step> * var(--unit)). No point
   sizes: a point is 1/72 inch and there is no inch in this pipeline. No bare
   pixels outside the token block. Not percent of frame WIDTH - that is right
   at 16:9 and 78% oversized at 9:16.

2. PICK THE ANCHOR. Step 0 is the CAPTION BODY SIZE, not a headline: 4.5% of
   frame height for full-screen, 5.0% for in-feed. This is deliberate - the
   caption track and the graphics must be steps of ONE scale, not two systems
   sharing a frame. If a caption identity already exists, read --cap-size from
   it and use that number as step 0 verbatim.

3. PICK THE RATIO.
     information-dense (lists, comparisons, diagrams)  -> 1.25
     statement-led (title cards, quotes, one idea)      -> 1.333
     card-driven, <=5 levels total                      -> 1.5
   Do not exceed 1.5 in a 9:16 frame; the top steps stop fitting the measure.

4. EMIT THE TABLE. Nine rows, s-2 .. s6, geometric from the anchor. For each
   row give: step name, % of frame height, px at every shipping resolution,
   derived cap height (% x the face's cap ratio, ~0.72 - measure it, do not
   assume), and the role it is reserved for.

5. CHECK THE FLOORS, and raise the anchor if any fails.
     - Cap height >= 1.6% of frame height for comfortable reading
       (ISO 9241-303's 20-22 arcmin at a 36.8 cm mean phone viewing distance).
       Absolute floor 1.2% (16 arcmin).
     - Derived px at every shipping resolution >= the platform floor:
       full-screen 20 body / 60 headline / 16 label;
       in-feed     32 body / 90 headline / 24 label.
     - In 9:16, do not define anything below s-1.

6. CHECK THE MEASURE. For each step you actually intend to set text at, compute
   characters-per-line at the grid's content width: chars ~= content_px /
   (0.5 x font_px). Reject any pairing over 30 characters per line, or under 12
   (the step is too big for that column - use a smaller step or a wider box).

7. WRITE THE ADJACENCY RULE INTO THE PROFILE. Inside one visual group, never
   use adjacent steps: 1.25 is below the 1.4x discrimination floor, so two
   adjacent steps read as one size set sloppily. Jump two steps (1.5625x).
   Three steps per card, five per video.

ACCEPTANCE TEST:
(a) grep the emitted CSS for `pt`, and for any numeric font-size outside the
    token block - zero matches passes;
(b) change --fh alone to the other shipping height and confirm every type size
    changes with it and no value needs editing;
(c) list every (component, step) pairing in the project and confirm no card
    uses two adjacent steps and no card uses more than three steps;
(d) for the smallest step actually used, compute cap height as a % of frame
    height and confirm >= 1.6%;
(e) render one frame per component, measure cap height in pixels on a flat-
    topped capital, divide by frame height, and confirm the measured value
    matches the specified step within 2%.
```

## Execution spec

**There is no CSS unit meaning "percent of composition height."** `vh` refers to the browser viewport, which during `preview` happens to match the composition and during a `--resolution` supersampled `render` does not — so `vh` produces captions and graphics that are the wrong size **only in the final MP4**. The composition height is therefore declared once as a unitless token and everything is `calc()`ed from it.

```html
<template id="visual-system-template">
  <div data-composition-id="gfx" data-width="1080" data-height="1920"
       data-duration="{{DURATION}}"
       style="position:relative; width:1080px; height:1920px; overflow:hidden;">
    <style>
      [data-composition-id="gfx"]{
        /* ---- the one shared primitive. Same token name as the caption identity. ---- */
        --fh: 1920;                                  /* MUST equal root data-height */
        --unit: calc(var(--fh) / 100 * 1px);         /* 1 unit = 1% of frame height */

        /* ---- the scale: ratio 1.25, anchored on the caption body size ---- */
        --s-2: calc(2.88 * var(--unit));   /* 16:9 only */
        --s-1: calc(3.60 * var(--unit));
        --s0:  calc(4.50 * var(--unit));   /* anchor === --cap-size */
        --s1:  calc(5.63 * var(--unit));
        --s2:  calc(7.03 * var(--unit));
        --s3:  calc(8.79 * var(--unit));
        --s4:  calc(10.99 * var(--unit));
        --s5:  calc(13.73 * var(--unit));
        --s6:  calc(17.17 * var(--unit));

        /* the caption track reads the SAME step, it does not declare its own size */
        --cap-size: var(--s0);
      }
      [data-composition-id="gfx"] .t-label { font-size: var(--s-1); }
      [data-composition-id="gfx"] .t-body  { font-size: var(--s0);  }
      [data-composition-id="gfx"] .t-title { font-size: var(--s2);  }
      [data-composition-id="gfx"] .t-stat  { font-size: var(--s5);  }
    </style>
    <!-- components consume steps; they never declare sizes -->
  </div>
</template>
```

Contract points that bind this:

- **Scope every rule to `[data-composition-id="…"]` and keep the `<style>` inside the `<template>`.** The assembler drops a sub-composition file's own `<head>` `<style>`/`<script>`; only `<link>` is hoisted. An unscoped rule leaks into sibling compositions on the assembled page.
- **`--fh` duplicates the root `data-height` and nothing enforces the agreement.** If they drift, every size is wrong by a constant factor and it looks like a design decision rather than a bug. There is no lint rule for it; `snapshot --at <midpoint>` and an actual look at the frame is the only guard.
- **Do not use `vh`.** Correct in preview, wrong in a supersampled render, and the failure only appears in the deliverable.
- **`--resolution` supersampling is uniform and integer** (via Chrome's `deviceScaleFactor`; the aspect must match the composition and the scale must be an integer), so a 1080p composition at `landscape-4k` scales by exactly 2 and both percentages and pixels survive *that* transform. The percentage is what survives the **aspect** change, which is the case that actually breaks designs.
- **Shipping two aspects:** give each aspect its own root `index.html` with its own `data-width`/`data-height`, hosting the same sub-compositions. Root `data-duration` is read once at compile time and **cannot** be changed by a script or `--variables`; `--cap-size`-style tokens **can** — declare them in `data-composition-variables` on `<html>` and have the script write them as inline custom properties on the root.
- **Font sizes are not animated.** If a size must change on screen, tween `scale` on the element, not `font-size` — `width`/`height`/`top`/`left` tweens are forbidden and `font-size` tweens force layout every frame. A scale tween from `s2` to `s3` is `scale: 1.25`.
- **A CSS `transform` on an element GSAP will tween raises `gsap_css_transform_conflict` (error)** — and a lint error switches off the layout and contrast audits entirely, after which `check` reports `0 sample(s)` and `0/0 text checks`, which reads clean and means nothing ran.
- **Fonts are local or bundled.** The implicit Google Fonts fetch is a blocked network path under the egress allowlist and fails closed in distributed renders. Pick from the 18 pre-bundled families or embed a local `@font-face`; do not use `Inter` (bundled, but on the project's banned monoculture list). Safe picks: Montserrat, Oswald, League Gothic, Archivo Black, Space Mono, IBM Plex Mono, JetBrains Mono, Source Code Pro, Noto Sans JP. Verify the weight cut physically exists — see [[gfx-weight-and-optical-size]].

**ffmpeg — the measurement leg only.** Frame extraction for the cap-height measurement, and a contact sheet to find the extremes of type size across a reference:

```bash
# every distinct type object: pull 12 frames spread across the video
ffmpeg -i ref.mp4 -vf "fps=1/20,scale=1080:-1" /tmp/type/%03d.png
# then one exact frame at full resolution for measurement
ffmpeg -ss 96.5 -i ref.mp4 -frames:v 1 -q:v 2 /tmp/type/measure.png
ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 ref.mp4
```

**Remotion.** `useVideoConfig().height` supplies `H`; every size is `H * step / 100`. The scale itself is stack-independent.

## Pairs with
[[sub-size-as-frame-height-percentage]] · [[sub-caption-identity-token-set]] · [[gfx-weight-and-optical-size]] · [[gfx-vertical-grid-and-margins]] · [[gfx-palette-ground-ink-accent]] · [[gfx-stroke-weight-and-corner-radius]] · [[gfx-full-frame-statement-card]] · [[gfx-stat-card-layout]] · [[motion-abstract-concept-card]] · [[motion-list-item-marker-card]] · [[motion-type-treatment-matches-content]] · [[sub-typeface-selection-for-captions]] · [[sub-tracking-and-caption-line-height]]

## Failure modes
- **Percent of frame width.** Right at 16:9, 78 % oversized at 9:16. The most seductive wrong denominator, because it is correct in whichever format you designed in.
- **A separate graphic scale beside the caption scale.** Two type systems in one frame is the single most common way a competent video looks amateur. Correction: the caption body size *is* step 0; the caption identity reads `--cap-size: var(--s0)` rather than declaring a number.
- **Adjacent steps in one group.** A title at `s1` over body at `s0` is a 1.25× difference, below the 1.4× discrimination floor: it reads as one size, badly set. Correction: jump two steps.
- **Nine steps in one composition.** A scale is a constraint, not a menu. Correction: three per card, five per video.
- **`vh` units.** Correct in preview, wrong in a supersampled render, visible only in the MP4.
- **`--fh` out of sync with `data-height`.** Everything scales by a constant wrong factor. No lint rule catches it.
- **Point sizes.** Anybody handing you a point size is describing a design tool's UI, not the deliverable.
- **Designing at 1080p and shipping at 4K without re-checking.** The integer supersample is uniform so this usually works — which trains people to trust pixels, which then break on the aspect change.
- **Meeting the full-screen floor for an in-feed deliverable.** 20 px body is fine full-screen and unreadable in a feed; the floors differ by about 60 %.
- **Ignoring the cap-height ratio.** Two faces at "4.5 %" differ by up to 9 % in apparent size, so a face swap silently resizes the whole video.
- **Sizing to the acuity floor.** 1.2 % of frame height is legible to a stationary reader with time. Video type is read in a fixed window while listening, so real sizes sit 2–3× above the floor. The floor is a *reject* test, never a target.
- **Known gap:** the browser-backed contrast and layout audits, `snapshot` and `render` cannot run on the authoring VM (linux ARM64, no sudo, no Chrome). Every measured acceptance test in this note has to be performed on the render host, and the pipeline must not assume it ran locally.
