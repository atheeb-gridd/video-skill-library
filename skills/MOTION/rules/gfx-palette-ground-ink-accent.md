---
id: gfx-palette-ground-ink-accent
title: Ground, ink, one accent — the five-token palette and the discipline of a single accent
skill: motion
type: graphic
family: visual-system
tags: [skill/motion, type/graphic, family/visual-system, engine/hyperframes, engine/ffmpeg, engine/remotion, source/sfx-kt-2, source/editing-kt-3, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "visual — contact sheet, concept cards"
    quote: "[NOT SPOKEN — observed on screen] A dark teal/navy ground with a muted cyan accent, the same ground across every concept card in the video; a small orange sub-label used for exactly one job."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "visual — contact sheet, negation devices"
    quote: "[NOT SPOKEN — observed on screen] Red strikethrough as the signature rhetorical device — 'BORING' stamped in red across a YouTube analytics screenshot. Struck-through or red-overlaid text = a claim being negated."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: ".caption-box — background-color: #7a6248 … .caption-text — color: #f5f0e0."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://edtechuvic.ca/wp-content/uploads/sites/11/2022/09/principles-for-reducing-extraneous-processing-in-multimedia-learning-coherence-signaling-redundancy-spatial-contiguity-and-temporal-contiguity-principles.pdf
  - https://en.wikipedia.org/wiki/Contrast_(vision)
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: video
---

# Ground, ink, one accent — the five-token palette and the discipline of a single accent

## What it is

Five tokens. Not a palette of twelve swatches with a usage note; five named roles, each of which answers a question the renderer will ask.

| Token | Role | The question it answers |
|---|---|---|
| `--ground` | The field everything sits on | What colour is the frame when the graphic owns it? |
| `--ink` | Primary type and primary marks | What colour is something the viewer must read? |
| `--ink-dim` | De-emphasised type and marks | What colour is something that has been said already, or has not been said yet? |
| `--accent` | **Exactly one hue.** The current focus | What colour is the one thing the sentence is about *right now*? |
| `--hairline` | Dividers, rules, grid, node borders | What colour is structure that must be present and must not be looked at? |

Everything else is derived: a plate is `--ground` at a stated alpha, a scrim is `--ground` at zero alpha ramping to an alpha, a chip is `--ground` lightened one step, a bar's track is `--hairline` and its fill is `--accent`. There is no sixth token, and a sixth colour appearing in the CSS is a bug, not an idea.

**Why the accent is singular, and what "singular" costs.** An accent is a *pointer*: its meaning is "look here, this is the thing being talked about". A pointer only points if there is one of it. Two accent hues in a frame is not two pointers; it is zero, plus a decision the viewer now has to make about what the difference between them means. The observed house style is unusually strict about this — one dark ground for the whole video, one muted cyan carrying every graphic element, and a second hue (orange) reserved for exactly one recurring job (tying a concept to the emotion it maps to). That is not two accents; that is one accent plus one **semantic** hue with a written rule. The distinction is the whole discipline:

- **An accent** is positional. It moves to whatever is currently in focus. It has no fixed meaning.
- **A semantic hue** is bijective. It means one thing, always, in both directions, for the whole video — red means negated, and nothing else is red, and everything negated is red.

You may have one accent and at most two semantic hues, and the semantic hues are **shared with the caption layer, not invented separately**. The subtitles library already owns the semantic map ([[sub-semantic-colour-assignment]], [[sub-red-strikethrough-negation]]); a graphic that uses red for a chart bar in a video where red means "rejected" has just rejected the bar.

**The coherence argument is not aesthetic.** Mayer's coherence principle — remove everything that does not serve the instructional goal — carries a median effect size of **d = 0.86 across 23 studies, supported in 23 of 23**. A decorative second hue is exactly the seductive-detail class that measures against you. The palette is small because small measures better, not because minimalism is in fashion.

**Contrast is a property of pairs, and every pair must be computed, not assumed.** Five tokens make ten pairs; four of them are load-bearing and all four have a floor:

| Pair | Floor | Why |
|---|---|---|
| `--ink` on `--ground` | **≥ 7:1** | WCAG AAA for normal text. Design one level above the 4.5:1 requirement so that every derived value (dimmed ink, ink over a plate over footage) still clears 4.5:1 after its own loss. |
| `--ink-dim` on `--ground` | **≥ 4.5:1** | It is still text. "Dimmed" is not permission to be illegible. This is the pair people skip. |
| `--accent` on `--ground`, as text | **≥ 4.5:1** | WCAG 1.4.3. |
| `--accent` on `--ground`, as a mark | **≥ 3:1** | WCAG 1.4.11 non-text contrast: a graphical object needs 3:1 against what is adjacent, or its edge disappears. |
| `--hairline` on `--ground` | **1.5–2.5:1** | The only pair with a **ceiling**. A hairline that clears 3:1 is not a hairline, it is a line, and it will compete. |

The hairline ceiling is the one that surprises people, and it is the reason a "clean" diagram often reads as busy: every border was drawn at full ink.

## When to use it

- **Once per style profile.** Five hex values, ten computed ratios, and the semantic map. Recorded before any component exists.
- **At the end of Mode A**, by sampling. "Dark blue with a cyan accent" is not a profile; five hex values and the measured ratios are.
- **Whenever a component sits on footage rather than on `--ground`.** The tokens do not change, but the *ratios* do, and the pairs must be recomputed against the worst frame ([[gfx-contrast-over-moving-footage]]).
- **Whenever a second semantic hue is proposed.** The proposal must state the referent, the bijection, the redundant non-colour cue, and where in the first 20 % of runtime the code gets established. If any of the four is missing, the answer is no.
- **Not** per component. A stat card does not get "its own colour".
- **Not** as a gradient set. A gradient is `--ground` to a lightened `--ground`, and never crosses hues; a two-hue gradient is two accents with the argument hidden inside a smooth ramp.

## How to recognise it in a reference video

- **Sample the ground on three separate cards.** `ffmpeg -ss <t> -i ref.mp4 -frames:v 1 f.png`, then read RGB at five points inside the ground area of each. Within a few percent across all three ⇒ a system. Different each time ⇒ decoration. This is the single cheapest style-profile measurement that exists.
- **Count distinct hues in the graphic layer, not in the footage.** Crop to the graphic's bounding box and quantise:
  ```bash
  ffmpeg -ss <t> -i ref.mp4 -frames:v 1 -vf "crop=iw*0.88:ih*0.42:iw*0.06:ih*0.30,palettegen=max_colors=8" pal.png
  ```
  Read the generated palette. **2–4 significant entries** (ground, ink, accent, hairline) is a system. **6+** is not.
- **Measure the accent's share.** Threshold the crop to the accent hue and compute the covered fraction. In competent work the accent covers **2–8 %** of the graphic's non-ground area. Above ~15 % the accent has become a second ground and stopped pointing.
- **Check whether the accent moves.** Sample three frames across a build. If the accent is on a different element in each — the element currently being narrated — it is a real accent. If it is nailed to the same element for the whole graphic, it is branding, which is a different (weaker) thing.
- **Greyscale survival test.** `ffmpeg -i f.png -vf "format=gray" g.png`. Every distinction the graphic makes must still be readable. Colour that carries meaning alone fails the test and fails ~8 % of male viewers.
- **Look for a red/green pair.** Deuteranomaly is about 5 % of males and protan types about 2 %; a red/green pair is undifferentiable to them. Blue/orange or blue/yellow is the substitute.
- **Measure the hairline ratio.** Sample the divider and the ground. **1.5–2.5:1** is designed. **>3:1** means the borders are competing with the content. **<1.2:1** means the structure is invisible and the layout will read as floating.
- **Find the semantic hue's exceptions.** Grep the video for every appearance of the semantic hue. One stray use — a red arrow that means "look here" in a video where red means "wrong" — destroys the code, and the destruction is retroactive.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `tokens` | 5 | 5 | `--ground`, `--ink`, `--ink-dim`, `--accent`, `--hairline`. A sixth is a bug. |
| `ground` | `#10222b` | — | The observed house dark teal/navy band is `#10222b`–`#0d1b2a`. One value for the whole video. |
| `ink` | `#f5f0e0` | — | The reference implementation's caption ink. **Never pure `#ffffff` on a dark ground** — it blooms under compression and reads as a clipped highlight. |
| `ink_dim` | `--ink` at 62 % over `--ground` | 55–70 % | Composite it and measure; do not use `opacity`, which also dims any plate behind. |
| `accent` | one muted hue | 1 | Muted cyan in the observed style. Positional, not semantic. |
| `hairline` | `--ink` at 14 % over `--ground` | 10–20 % | Target ratio 1.5–2.5:1. |
| `accent_count` | 1 | 1 | Hard. |
| `semantic_hues` | 0 | 0–2 | Each needs a referent, a bijection, a redundant non-colour cue, and an establishing use in the first 20 % of runtime. |
| `semantic_map_owner` | `skills/SUBTITLES` | — | Shared with the caption layer; never a second map. See [[sub-semantic-colour-assignment]]. |
| `red_means` | negation | — | Established by the reference material. If red is used at all, it means negated — including on marks and bars. |
| `ratio_ink_ground` | ≥7:1 | ≥7:1 | AAA. One level above the requirement, so derived values still clear 4.5:1. |
| `ratio_inkdim_ground` | ≥4.5:1 | ≥4.5:1 | The pair everybody skips. |
| `ratio_accent_text` | ≥4.5:1 | ≥4.5:1 | WCAG 1.4.3. |
| `ratio_accent_mark` | ≥3:1 | ≥3:1 | WCAG 1.4.11 non-text contrast. |
| `ratio_hairline` | 2.0:1 | 1.5–2.5:1 | The one pair with a **ceiling**. |
| `accent_area_share` | 5 % | 2–8 % | Of the graphic's non-ground area. Above 15 % it is a second ground. |
| `greyscale_survival` | required | — | Convert to grey; every distinction must survive. |
| `red_green_pair` | forbidden | — | ~7 % of males cannot separate them. Use blue/orange or blue/yellow. |
| `gradients` | same-hue only | — | `--ground` to lightened `--ground`. Never cross hues. **Never the `transparent` keyword** — use the target colour at zero alpha. |
| `gradient_min_opacity` | 0.15 | ≥0.15 | Below this a gradient bands visibly at social bitrates. |
| `pure_white` | forbidden as `--ink` | — | Blooms and clips. `#f5f0e0`-class off-whites hold. |
| `pure_black` | forbidden as `--ground` | — | Crushes to a banding floor in dark scenes. Use `#0d1b2a`-class near-blacks. |

## Reproduction prompt

```
Produce the palette for {{PROJECT}}, whose graphics sit on {{a dark card ground
| live footage | both}}, and whose caption identity already declares
{{--cap-colour, --cap-plate, --cap-accent}}.

1. DECLARE EXACTLY FIVE TOKENS and nothing else:
     --ground   the field
     --ink      primary type and marks
     --ink-dim  de-emphasised type and marks
     --accent   ONE hue, positional: whatever is in focus right now
     --hairline dividers, rules, node borders
   Derive everything else from them: plates are --ground at an alpha, chips are
   --ground lightened one step, bar tracks are --hairline, bar fills are
   --accent. A sixth colour in the emitted CSS is a bug.

2. READ THE CAPTION IDENTITY FIRST and reuse it. --ink SHOULD equal the caption
   ink; --accent SHOULD equal the caption accent. Captions and graphics share
   one palette. Two palettes in one frame is the fastest way for a competent
   video to look amateur. If you must diverge, write down why.

3. COMPUTE FIVE RATIOS and reject the palette if any fails:
     --ink on --ground        >= 7:1   (AAA - design one level above the need)
     --ink-dim on --ground    >= 4.5:1 (it is still text)
     --accent as text         >= 4.5:1
     --accent as a mark       >= 3:1   (WCAG 1.4.11 non-text contrast)
     --hairline on --ground   1.5-2.5:1  <-- this pair has a CEILING. A hairline
                              above 3:1 is a line and it will compete.

4. THE ACCENT IS POSITIONAL, NOT DECORATIVE. Write the rule down: the accent
   marks the element the narration is on RIGHT NOW, and it moves. Cap its area
   at 8% of the graphic's non-ground pixels. Above 15% it has become a second
   ground and points at nothing.

5. SEMANTIC HUES, if any: at most two, and each needs four things written down -
   the referent, the bijection (one hue one meaning, both directions), the
   redundant non-colour cue (weight, strike, glyph, position, plate), and the
   place in the first 20% of runtime where the code is established on an
   unambiguous instance. Take the map from the SUBTITLES emphasis map; do not
   write a second one. If red appears anywhere in this video it means NEGATED,
   including on marks and bars.

6. FORBIDDEN: pure #ffffff ink (blooms and clips under compression), pure
   #000000 ground (bands), any red/green pair (~7% of males cannot separate
   them - use blue/orange), cross-hue gradients (two accents hidden in a ramp),
   the CSS `transparent` keyword in a gradient (use the target colour at zero
   alpha), and any gradient stop below 0.15 opacity.

7. GREYSCALE TEST: convert every graphic to grey. Every distinction the graphic
   makes must still be readable. If a distinction disappears, add the redundant
   cue rather than changing the hue.

ACCEPTANCE TEST:
(a) grep the emitted CSS for hex and rgb() values outside the token block -
    zero matches passes;
(b) compute all five ratios with a contrast calculator and paste them into the
    profile;
(c) quantise one frame of each graphic to 8 colours and confirm 2-4 significant
    entries in the graphic layer;
(d) threshold the accent hue and confirm <= 8% of the graphic's non-ground area;
(e) convert three frames to greyscale and confirm every distinction survives;
(f) grep the whole project for the semantic hue and confirm zero uses outside
    its declared category.
```

## Execution spec

**Tokens on the composition root, and never a literal colour anywhere else.** This is what makes a profile change one edit instead of forty.

```css
[data-composition-id="gfx"]{
  --ground:   #10222b;
  --ink:      #f5f0e0;                                   /* not #fff */
  --ink-dim:  #9fa8ab;                                   /* composited, not opacity */
  --accent:   #62c6d8;
  --hairline: #24363e;                                   /* ~1.9:1 on --ground */

  /* derived, never new colours */
  --plate:      color-mix(in srgb, var(--ground) 92%, black);
  --chip:       color-mix(in srgb, var(--ground) 88%, var(--ink) 12%);
  --scrim-stop: rgba(16, 34, 43, 0);                     /* --ground at zero alpha */
  --scrim-peak: rgba(16, 34, 43, 0.72);
}
[data-composition-id="gfx"] .card   { background: var(--ground); color: var(--ink); }
[data-composition-id="gfx"] .dimmed { color: var(--ink-dim); }
[data-composition-id="gfx"] .focus  { color: var(--accent); }
[data-composition-id="gfx"] .rule   { background: var(--hairline); }
[data-composition-id="gfx"] .scrim  {
  background: linear-gradient(to top, var(--scrim-peak), var(--scrim-stop));
}
```

Constraints and traps:

- **Dim by compositing, not by `opacity`.** `opacity: 0.6` on a labelled node also dims the node's plate, its border and anything behind it, and it makes the element a **backdrop root** — which silently disables any `backdrop-filter` inside or behind it until opacity reaches exactly 1. Set `color: var(--ink-dim)` instead. When a whole group must dim, tween `color` and `borderColor`, or dim a dedicated overlay.
- **Tweening colour is legal; tweening it with an overshooting ease is not.** The contract is explicit: at damping fractions below 1, overshooting curves go **on transforms only** — never on `opacity` or colour. Split a colour change onto its own `power2.out` tween at the same timeline position.
- **Gradients:** never the `transparent` keyword (it resolves to transparent *black* in some engines and produces a grey ramp on a coloured ground) — use the target colour at zero alpha, as above. No gradient stop below `0.15` opacity, and no gradient on an element thinner than 4 px. These are mandatory if the project uses shader transitions and harmless otherwise.
- **`color-mix()` is fine in Chrome**, which is the render engine, but resolve the mixes to literals in the profile document so the numbers are auditable; a computed colour whose ratio nobody has measured is a colour outside the contract.
- **The contrast audit inside `check` compares text to its *declared* CSS background.** Over `--ground` that is exactly right and the audit is trustworthy. Over footage the declared background is transparent and the audit has nothing to compare — it will pass an illegible frame. Use the worst-frame method.
- **A lint error switches the contrast and layout audits off entirely**, after which `check` reports `0 sample(s)` and `0/0 text checks`. Read the sample count.
- **Semantic hues must survive greyscale**, which means each one carries a non-colour cue in the markup — a strike, a weight change, a glyph, a bracket, a plate — not just a class name.

**ffmpeg — palette extraction and the greyscale test**, both cheap and both worth running on every reference:

```bash
# 1. what colours does the graphic layer actually use?
ffmpeg -ss 96.5 -i ref.mp4 -frames:v 1 \
  -vf "crop=iw*0.88:ih*0.42:iw*0.06:ih*0.30,palettegen=max_colors=8" /tmp/p/pal.png
# 2. does every distinction survive greyscale?
ffmpeg -ss 96.5 -i ref.mp4 -frames:v 1 -vf "format=gray" /tmp/p/grey.png
# 3. ground stability: sample the same point on three cards
for t in 96.5 141.0 208.2; do
  ffmpeg -ss $t -i ref.mp4 -frames:v 1 -vf "crop=8:8:120:900" -f rawvideo -pix_fmt rgb24 - \
  | xxd -l 24 -g 3
done
```

**Remotion.** The same five tokens as a TypeScript constant object imported by every component; nothing here is stack-specific.

## Pairs with
[[gfx-modular-type-scale]] · [[gfx-contrast-over-moving-footage]] · [[gfx-plate-and-scrim-ladder]] · [[gfx-stroke-weight-and-corner-radius]] · [[gfx-icon-system-and-weight-match]] · [[sub-caption-colour-token-system]] · [[sub-semantic-colour-assignment]] · [[sub-red-strikethrough-negation]] · [[sub-caption-contrast-accessibility]] · [[motion-abstract-concept-card]] · [[motion-colour-shift-connotation]] · [[gfx-annotation-mark-set]]

## Failure modes
- **A second accent.** The system's recognisability *is* one hue. A second one makes every card look like a different video, and neither hue points at anything.
- **An accent that never moves.** Then it is branding, not signalling, and the graphic has no way to say "this bit, now".
- **`--ink-dim` never measured.** Dimmed text at 3:1 is the most common accessibility failure in graphic design, because it looks intentional.
- **A hairline at full ink.** Every border competes with the content and the diagram reads as busy even though nothing is wrong with the layout. Correction: the 1.5–2.5:1 ceiling.
- **Pure white ink on a dark ground.** Blooms under compression and reads as a clipped highlight; off-white holds.
- **Pure black ground.** Bands in the dark parts of the ramp at social bitrates.
- **A red bar in a video where red means "wrong".** The semantic map is global; a chart cannot opt out of it.
- **A red/green pair.** Undifferentiable to about 7 % of male viewers, and no amount of labelling fixes the first-glance read.
- **Colour as the only cue.** Fails the greyscale test, fails colour-deficient viewers, and fails on any player with an aggressive display profile.
- **Cross-hue gradients.** Two accents with the argument hidden in a smooth ramp.
- **The `transparent` keyword in a gradient.** Produces a grey ramp over a coloured ground in some engines. Use the target colour at zero alpha.
- **Dimming with `opacity`.** Dims the plate too, and silently turns the element into a backdrop root, which disables any blur behind it.
- **Known gap:** exact hex values for a specific creator are not recoverable from a contact sheet — the *relationships* (one ground, one accent, a reserved second hue) are observable, the numbers here are this library's defaults. Sample real frames at native resolution before matching a target.
