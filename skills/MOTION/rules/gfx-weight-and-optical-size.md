---
id: gfx-weight-and-optical-size
title: Weight is a function of size and ground — two cuts, and the compensation the missing opsz axis forces
skill: motion
type: type-motion
family: visual-system
tags: [skill/motion, type/type-motion, family/visual-system, engine/hyperframes, engine/remotion, source/hyperframes, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "tracking −0.03em to −0.05em at display sizes, because \"Video encoding compresses letter detail.\" On dark backgrounds, drop body weight (350 not 400) and add 0.05–0.1 line-height."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Inter is a bundled font (weights 400 · 700 · 900, so 700 here is a real cut) — but it is also on the Banned monoculture list."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, title cards"
    quote: "[NOT SPOKEN — observed on screen] 'Movement Match Cut', 'J Cut', 'L Cut', 'IN POINT' in clean type; 'SMASH CUT' in a rough eroded chalk face."
research_refs:
  - https://uxdesign.cc/legibility-how-to-make-text-convenient-to-read-7f96b84bd8af
  - https://legibility.info/font-size-calculator
  - https://pmc.ncbi.nlm.nih.gov/articles/PMC8093538
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
  - https://developer.mozilla.org/en-US/docs/Web/CSS/font-variant-numeric
difficulty: medium
detectable_from: video
---

# Weight is a function of size and ground — two cuts, and the compensation the missing opsz axis forces

## What it is

Weight is not a style choice made once. It is a **function of three inputs** — the step on the type scale, whether the type sits light-on-dark or dark-on-light, and whether it sits over footage — and the whole note is the three corrections that function applies.

**Correction 1: weight falls as size rises.** A grotesque at `s0` (4.5 % of frame height) needs `700` to hold its edges through H.264. The same face at `s6` (17.2 %) at `700` is a slab: the stems are so wide relative to the counters that the word reads as a shape rather than as letters. Print typography solves this with optical sizes — a display cut with thinner strokes, tighter spacing and sharper detail. **This project has no optical-size axis**: none of the bundled families expose `opsz`, and the subtitles library already records this as a hard unavailability. So the compensation is manual, and it is one step of weight per two steps of scale:

| Steps | Weight (light-on-dark) | Weight (dark-on-light) |
|---|---|---|
| `s-2`, `s-1` | 700 | 700 |
| `s0`, `s1` | 700 | 700 |
| `s2`, `s3` | 700 | 700 → 800 permitted |
| `s4`, `s5`, `s6` | **400–500** | **600–700** |

**Correction 2: light-on-dark bleeds, dark-on-light chokes.** This is a real optical effect (irradiation): a light glyph on a dark ground spreads into the ground and reads heavier than the same glyph in reverse. The project's own typography guidance states the rule directly — *drop body weight (350 not 400) on dark backgrounds, and add 0.05–0.1 line-height.* That is one weight cut down and a leading increase, and it applies at every step, not only at body size. The graphic system's ground is usually dark (the observed house style is a dark teal/navy card ground), so the dark-ground column is the default column.

**Correction 3: over footage, weight cannot substitute for a backing.** The temptation at every legibility problem is to add weight. It buys almost nothing: a heavier stem raises the *mean* contrast of the glyph's interior against the picture but does nothing to the frames where the picture matches the ink, and it fills the counters, which is where legibility actually lives. Weight is not a contrast mechanism. A plate or a scrim is ([[gfx-plate-and-scrim-ladder]], [[gfx-contrast-over-moving-footage]]).

**Two cuts, ever.** The subtitles library caps the caption identity at two weight cuts and calls a third "drift, not hierarchy". The graphic system inherits the cap and shares the cuts: if the video's family ships `400 / 700 / 900`, the pair is `700` (everything) and `400` (display steps `s4`–`s6` on dark ground) — and `900` is available only as the emphasis cut the captions already claimed. Three cuts across captions *and* graphics combined; not three each.

**Synthetic weight is forbidden and is the failure nobody looks for.** A `font-weight: 600` request against a family shipping `400 / 700 / 900` is synthesised by the browser — the renderer smears the 400 outline — and at video sizes under compression it is mush with soft, asymmetric stems. Check the family's physical cut list before writing a number.

Case, tracking and the semantic use of a *different face* are settled elsewhere and are not re-decided here: case and caps rules in [[sub-weight-case-and-optical-size]], tracking and leading in [[sub-tracking-and-caption-line-height]], and the choice to break the house face for meaning in [[motion-type-treatment-matches-content]]. This note owns **weight as a function of step and ground**, and it owns it for graphics as well as captions so the two cannot diverge.

## When to use it

- **Once per style profile**, immediately after the type scale, as a table mapping every step to a weight and a tracking value. Two tables if the video has both a dark card ground and light-on-footage type.
- **Every time a new step is used for the first time.** `s5` appearing in a stat card is the moment the display-weight correction gets applied — not later, when the card "looks heavy".
- **Whenever the ground flips.** A component moving from a dark card to a light screenshot changes weight column. It is the same component with a different weight, not two components.
- **Whenever the family changes.** Weight numbers are family-specific; `700` in Oswald and `700` in Montserrat are different apparent weights because the cap-to-stem ratios differ.
- **Not** as the answer to a legibility problem over footage. That is a backing decision.
- **Not** at three or more cuts. If the hierarchy needs a third weight, it needs a bigger size jump instead.

## How to recognise it in a reference video

All of this is single-frame work at native resolution.

- **Measure the stem-to-cap ratio.** On a straight vertical stem (`I`, `H`, `L`, `T`), measure stem width in px and divide by the cap height of the same glyph. This is the only weight metric that is comparable across sizes and faces.

  | Stem ÷ cap | Reads as |
  |---|---|
  | 0.09–0.12 | Regular (400–500) |
  | 0.13–0.17 | Bold (700) |
  | 0.18–0.23 | Black (800–900) |
  | > 0.25 | Either a display face at black weight, or a stroke has been added |

- **Check whether the ratio changes with size.** Measure the largest and the smallest type object in the video. A designed system shows the *display* object at a **lower** stem-to-cap ratio than the body object. Equal ratios across a 4× size range means one weight was used everywhere and the display type will read as a slab.
- **Check the ground correction.** Find one light-on-dark object and one dark-on-light object at the same step. In competent work the light-on-dark one is one cut *lighter*. Same weight in both directions means the correction was not applied; the light-on-dark type will look heavier on screen than its counterpart.
- **Look for synthetic bold.** Zoom to 400 %. A synthesised weight shows **asymmetric stem thickening** — the vertical stems grow but the joins and the thin parts of curves do not, and terminals go soft and rounded. A real cut has consistent contrast and crisp terminals.
- **Count weight cuts in the whole video**, captions included. **2** is the target, **3** is the ceiling, **4+** means no system.
- **Check the counters at the smallest step.** Look inside `e`, `a`, `o`, `s` at 200 %. Filled or nearly-filled counters at body size mean the weight is too heavy for the size, the tracking is too tight, or a stroke has been stacked on top of a plate.
- **Measure tracking.** Take a repeated letter pair and measure advance width minus glyph width. At display steps expect **−0.03 to −0.05 em**; caps objects sit **+0.02 em** looser than the lowercase objects in the same video, because caps are drawn with more sidebearing already.
- **Compression tell.** Compare the same type object on a keyframe and on a frame late in a GOP (`ffmpeg -skip_frame nokey` versus a normal extract). If the stems visibly soften on the late frame, the weight-plus-size combination is at the edge of what the bitrate carries, and the fix is a bigger step, not a heavier cut.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `weight_cuts_total` | 2 | 1–3 | Across captions **and** graphics combined, not each. Third cut is drift. |
| `weight_body` | 700 | 600–800 | Steps `s-2`…`s3`. The reference caption file's value and a real cut in bundled Inter. |
| `weight_display_dark_ground` | 450 | 400–550 | Steps `s4`–`s6` light-on-dark. Manual substitute for the missing `opsz` axis. |
| `weight_display_light_ground` | 650 | 600–700 | Steps `s4`–`s6` dark-on-light. One cut heavier than the dark-ground column. |
| `ground_correction` | −1 cut on dark | — | Project rule: *"drop body weight (350 not 400) on dark backgrounds"*. Applies at every step. |
| `leading_correction_dark` | +0.075 | +0.05 to +0.10 | Project rule: add 0.05–0.1 line-height on dark grounds. |
| `weight_step_per_2_scale_steps` | −1 cut | — | The compensation rate. Two scale steps up ⇒ one weight cut down. |
| `stem_to_cap_body` | 0.15 | 0.13–0.17 | The measurable target for a 700 grotesque. |
| `stem_to_cap_display` | 0.11 | 0.09–0.13 | The measurable target at `s4`–`s6`. |
| `synthetic_weight` | forbidden | — | Any `font-weight` not physically shipped. Verify the cut list; there is no lint rule. |
| `opsz_axis` | unavailable | — | Not exposed by any bundled family. Do not write a spec that depends on it. |
| `small_caps` | forbidden | — | Synthesised small caps scale the caps down and destroy stroke weight. |
| `tracking_display` | −0.04 em | −0.03 to −0.05 em | Video encoding compresses letter detail; display type needs the tightening. |
| `tracking_caps_bonus` | +0.02 em | +0.01 to +0.03 em | Caps need *less* negative tracking. If lowercase runs −0.04, caps run −0.02. |
| `tracking_below_s0` | 0 em | −0.01 to +0.01 em | Do not tighten small type. Negative tracking at `s-1` closes counters. |
| `numeral_style` | `lining-nums tabular-nums` | — | Mandatory anywhere a number can change on screen. See [[gfx-stat-card-layout]]. |
| `weight_as_contrast_fix` | forbidden | — | Weight is not a backing. Use a plate or scrim. |
| `italic` | real cut or none | — | Synthesised obliques shear the outline. The italic serif attribution convention needs a real italic file ([[motion-attribution-label-inset-clip]]). |
| `family_count` | 2 | 1–3 | One clean face, plus at most one expressive face and one metadata face — the closed set from [[motion-type-treatment-matches-content]]. |

## Reproduction prompt

```
Produce the weight-and-tracking table for {{PROJECT}}, whose type scale is
already fixed and whose family is {{FAMILY}} shipping cuts {{CUT LIST}}.

1. VERIFY THE CUTS PHYSICALLY EXIST. List the weights the font file actually
   ships. Any weight you specify that is not on that list will be SYNTHESISED -
   smeared stems, soft terminals, mush under video compression. There is no lint
   rule for this. If the family ships 400/700/900, your usable numbers are
   exactly 400, 700 and 900.

2. PICK TWO CUTS FOR THE WHOLE PROJECT, captions included. Body cut and display
   cut. Not two for graphics and two for captions - two in total, three at the
   absolute ceiling.

3. BUILD THE TABLE, one row per type step in use, with these columns:
   step | ground (dark|light) | weight | tracking (em) | line-height |
   stem-to-cap target.
   Apply three corrections:
     (a) SIZE: one weight cut DOWN per two scale steps UP. Steps s4-s6 take the
         display cut, not the body cut. There is no opsz axis in this project,
         so this is the only optical-size compensation available.
     (b) GROUND: light-on-dark bleeds and reads heavier. On a dark ground drop
         one cut and add 0.05-0.10 to line-height.
     (c) CASE: caps take +0.02em relative to the lowercase tracking in the same
         video. Do not apply negative tracking below step s0 at all.

4. STATE THE PROHIBITION EXPLICITLY IN THE PROFILE: weight is not a contrast
   mechanism. Type over footage gets a plate or a scrim; adding weight raises
   mean contrast slightly and fills the counters, which is a net loss.

5. NUMERALS: anywhere a digit can change on screen, set
   font-variant-numeric: lining-nums tabular-nums. Proportional figures shift
   the box as digits change; that horizontal jitter is the most reliable
   amateur tell in the whole medium.

ACCEPTANCE TEST:
(a) count distinct font-weight values in the emitted CSS across captions AND
    graphics - 2 passes, 3 is a warning, 4 fails;
(b) every weight value appears in the family's physical cut list;
(c) render one frame per step, measure stem width divided by cap height, and
    confirm the display steps measure LOWER than the body steps;
(d) render the same step light-on-dark and dark-on-light and confirm the
    light-on-dark instance is one cut lighter in the CSS;
(e) inspect the counters of e, a, o at the smallest step at 200% zoom - open
    passes, filled fails;
(f) grep for `font-variant-numeric` on every element that can display a
    changing number - missing fails.
```

## Execution spec

**All of it is CSS, declared once as tokens beside the scale.** The pattern is a weight token per band, not a weight per component — a component that hard-codes `font-weight: 700` is a component that will not follow a family change.

```css
[data-composition-id="gfx"]{
  --face: "Montserrat";            /* bundled. NOT Inter - banned monoculture list */
  --w-body: 700;                   /* physical cut */
  --w-display: 400;                /* physical cut. Dark ground; use 700 on light */
  --track-body: -0.03em;
  --track-display: -0.04em;
  --track-caps-adj: 0.02em;        /* ADDED to the negative value, i.e. looser */
  --lh-body: 1.2;
  --lh-body-dark: 1.28;            /* +0.075, the dark-ground correction */
  --lh-display: 1.05;
}
[data-composition-id="gfx"] .t-body{
  font-family: var(--face), sans-serif;      /* one family + one generic. Never a stack */
  font-size: var(--s0);
  font-weight: var(--w-body);
  letter-spacing: var(--track-body);
  line-height: var(--lh-body-dark);
}
[data-composition-id="gfx"] .t-stat{
  font-size: var(--s5);
  font-weight: var(--w-display);              /* the size correction, applied */
  letter-spacing: var(--track-display);
  line-height: var(--lh-display);
  font-variant-numeric: lining-nums tabular-nums;
}
[data-composition-id="gfx"] .t-caps{
  text-transform: uppercase;
  letter-spacing: calc(var(--track-body) + var(--track-caps-adj));
}
```

Constraints:

- **Fonts must be bundled or local `@font-face`.** The implicit Google Fonts fetch is a network path under the egress allowlist and *"fail[s]-closed in distributed/cloud renders"*. The 18 pre-bundled families are the supported route; safe-and-distinctive picks are Montserrat, Oswald, League Gothic, Archivo Black, Space Mono, IBM Plex Mono, JetBrains Mono, Source Code Pro, Noto Sans JP. `Inter` is bundled and banned.
- **One family plus one generic in the stack, never a long fallback list.** A long stack guarantees that a missing glyph silently renders in a different face at a different x-height mid-line — harder to spot than a tofu box.
- **Build the timeline inside `document.fonts.ready` if any measurement depends on metrics**, and never derive positions from `getBoundingClientRect()` at tween time — *"compute coordinates once at composition setup and reuse."* In a multi-scene montage, do not measure at all: later clips may not be laid out yet. Use authored CSS-matched constants.
- **Do not tween `font-weight`.** A variable-weight axis animation is possible in principle via `font-variation-settings`, but no bundled family here exposes a `wght` axis reliably and a synthesised interpolation is mush. If a word must gain weight on screen, cross-fade two absolutely-positioned copies at the two real cuts, on `autoAlpha`, on a non-clip wrapper.
- **Do not tween `font-size`.** Tween `scale` on a block-level, explicitly-sized element. Transformed elements must be block-level and sized, and a CSS `transform` on a GSAP-tweened element raises `gsap_css_transform_conflict` (error).
- **A lint error disables the layout and contrast audits.** `check` then reports `0 sample(s)` and `0/0 text checks` — clean-looking and meaningless. Read the sample count, not the finding count.
- **The contrast audit compares text to its *declared* CSS background**, per WCAG's own guidance, so it cannot see the video. A weight or a stroke over footage will pass the audit and fail on screen. Only the worst-frame method measures the real case ([[gfx-contrast-over-moving-footage]]).

**ffmpeg — the compression check**, which is the one measurement that cannot be done from a static design:

```bash
# keyframes only, then all frames, same window: compare stem crispness
ffmpeg -skip_frame nokey -ss 42 -t 2 -i ref.mp4 -vsync 0 -q:v 2 /tmp/w/key_%02d.png
ffmpeg -ss 42 -t 2 -i ref.mp4 -vf fps=30 -q:v 2 /tmp/w/all_%03d.png
```

**Remotion.** Identical CSS; weight is a prop on the text component, and the same "verify the cut ships" rule applies because the failure is in the font file, not the framework.

## Pairs with
[[gfx-modular-type-scale]] · [[sub-weight-case-and-optical-size]] · [[sub-tracking-and-caption-line-height]] · [[sub-typeface-selection-for-captions]] · [[motion-type-treatment-matches-content]] · [[gfx-contrast-over-moving-footage]] · [[gfx-plate-and-scrim-ladder]] · [[gfx-stat-card-layout]] · [[gfx-icon-system-and-weight-match]] · [[motion-attribution-label-inset-clip]]

## Failure modes
- **One weight at every size.** The display steps read as slabs and the video looks like a template. Correction: one cut down per two steps up.
- **Ignoring the ground.** Light-on-dark type at the same weight as its dark-on-light counterpart looks heavier on screen, and the two objects stop reading as one system.
- **Synthetic bold.** A `600` against a `400/700/900` family. Asymmetric stems, soft terminals, mush at video bitrates, and nothing in lint says a word. Correction: verify the physical cut list.
- **Weight as a legibility fix.** Adds mean contrast, closes the counters, does nothing on the frames where the picture matches the ink. Correction: a backing.
- **Three or four cuts.** Correction: two, across captions and graphics together. If the hierarchy still does not read, the sizes are too close — jump two scale steps.
- **Negative tracking on small type.** `−0.04 em` at `s-1` closes the counters and the label degrades faster than the headline. Correction: zero tracking below `s0`.
- **All-caps at lowercase tracking.** Caps carry their own sidebearing; the same negative value crams them. Correction: `+0.02 em` relative.
- **Proportional figures on a changing number.** The box jitters horizontally as digits change. Correction: `tabular-nums`, always.
- **Synthesised italics and small caps.** Sheared outlines and destroyed stroke weight. Correction: a real cut, or a different device.
- **Trusting the contrast audit over footage.** It reads the declared CSS background, not the picture. Over a transparent background it has nothing meaningful to compare.
- **Known gap:** the `opsz` axis genuinely does not exist here, so every display-size correction in this note is a manual approximation of what an optical cut would do. It is a good approximation at 9:16 phone sizes and a rough one on a 55″ screen; if the deliverable is a large-screen master, sample a real frame at 100 % and judge the display step by eye rather than trusting the table.
