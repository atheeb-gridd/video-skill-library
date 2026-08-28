---
id: gfx-lower-third-anatomy
title: The lower third — two lines at a 0.64 ratio, an accent rule, and the band it must not enter
skill: motion
type: graphic
family: graphic-components
tags: [skill/motion, type/graphic, family/graphic-components, engine/hyperframes, engine/ffmpeg, engine/remotion, source/sfx-kt-1, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "visual — contact sheet, location lower-third"
    quote: "[NOT SPOKEN — observed on screen] A location lower-third reading 'YAAS Office, Bangalore'."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, attribution"
    quote: "[NOT SPOKEN — observed on screen] Every film clip labelled top-left in small italic serif — The Departed, Forrest Gump, The Wolf of Wall Street — clips letterboxed and inset on a dark ground."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:45"
    quote: "Number two, the jump cut."
research_refs:
  - https://tech.ebu.ch/docs/r/r095.pdf
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/4406208331923-Title-Safe-and-Safe-Action-Best-Practices
  - https://infinitecreation.io/tutorial-lower-thirds
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://legibility.info/rules-for-text-in-videos
difficulty: medium
detectable_from: video
---

# The lower third — two lines at a 0.64 ratio, an accent rule, and the band it must not enter

## What it is

The component that identifies **a person, a place, a role or a source** while the picture keeps running. Two lines, one accent element, one slot, one entrance.

Its anatomy is fixed and the ratios are not arbitrary:

- **Primary line** — the name. Type step `s1` (5.63 % of frame height).
- **Secondary line** — the role, the place, the qualifier. Type step `s-1` (3.60 %).
- **The ratio between them is `3.60 ÷ 5.63 = 0.64`**, which is the published lower-third secondary ratio (0.60–0.75) and which the library has independently recorded as `secondary_ratio: 0.65` in [[motion-list-item-marker-card]]. Two steps apart on a 1.25 scale is `1.5625×`, above the 1.4× discrimination floor — so the two lines read as two levels rather than as one size set sloppily. This is the whole reason to derive a lower third from the type scale instead of picking sizes.
- **One accent element**, and exactly one: a vertical rule at the left edge (`--stroke-body`, full height of the text block), *or* a horizontal underline under the primary, *or* the primary line set in `--accent`. Never two.
- **One backing rung**, chosen by measurement — usually a scrim over the block's box, because a lower third is wide and sits at a frame edge, which is exactly the scrim case.

**The band problem is the reason this component is difficult.** In 9:16 the caption track owns 18–26 % of frame height and the platform UI owns the bottom 18 %. A "lower third" in a vertical frame therefore cannot be in the lower third: its lowest glyph sits at **26–32 %** of frame height, above the caption band, with the mandatory 4 % clearance between them. In 16:9 it lives where it always did — lowest glyph at **14–20 %**, above the caption band at 8–14 %. Same component, two completely different vertical positions, and a design scaled rather than re-resolved lands it under the platform chrome.

**The name is not a caption and must not be spoken-verbatim.** `YAAS Office, Bangalore` is a place; a caption saying "we're here at the office in Bangalore" is speech. The lower third carries the NAMING payload and it is licensed to duplicate at marker length: a name, a place, a role — no finite verb, ≤3 words per line.

**Attribution is a variant, not the same component.** The observed attribution convention — small italic serif, top-left, over a letterboxed inset clip — is a *metadata* register with its own face, its own corner and its own note ([[motion-attribution-label-inset-clip]]). Do not merge them: a lower third asserts "this is who you are watching", an attribution asserts "this material is not mine". Different claims, different registers, and the type system already reserves an italic serif for metadata ([[motion-type-treatment-matches-content]]).

## When to use it

- **The first time a person appears**, and only the first time. A second lower third for the same person is a template being exercised, not information.
- **A location or a source establishing shot.**
- **A section or item boundary in a list**, where the item's name has to appear while a demo keeps running — the middle rung of the marker ladder, for items running 20–45 s ([[motion-list-item-marker-card]]).
- **A credential moment** — a claim whose weight depends on who is making it ([[struct-credibility-anchor]]).
- **Not** for a term being defined. That is a label callout or a concept card.
- **Not** as a persistent watermark. A lower third that never leaves is furniture; a corner mark is a different, smaller thing.
- **Not** twice in 30 s. Two lower thirds close together read as a broadcast package rather than as a video.
- **Not** at all in a frame where the caption track and a READ graphic are both live — see the attention budget.

## How to recognise it in a reference video

- **Measure the lowest glyph's height as a percentage from the bottom of the frame.** Not the plate, the glyph. **26–32 %** for vertical, **14–20 %** for 16:9. Below 20 % in a vertical cut and it is inside the platform UI band and nobody read it.
- **Measure the clearance to the caption band** in percent of frame height. **4 %** is comfortable, **3 %** is the floor, and anything under that reads as crowded even with no overlap.
- **Measure the two type sizes and divide.** `secondary ÷ primary` between **0.60 and 0.75** is designed. Above 0.8 the two lines read as one; below 0.5 the secondary is a footnote nobody reads.
- **Measure the left edge against the project's margin.** A lower third at a different left edge from the labels and the list rows means there is no grid.
- **Count accent elements.** One rule, one underline, or one coloured line. Two means the component was decorated.
- **Measure the accent rule's width** in px and divide by the primary's cap height. Around **0.13–0.17** ⇒ it is on the `body` stroke rung and matches the type. Much thinner and it reads as a hairline that got lost; much thicker and it reads as a badge.
- **Total block height** as a percentage of frame height: **9–13 %** for two lines plus padding. Above 15 % it is a card, not a lower third.
- **Entrance:** 0.40–0.60 s, translate from the left by 2–4 u plus `autoAlpha`, `power3.out`, with the secondary line staggered 0.08–0.12 s after the primary. Published lower-third practice is 15–25 frames at 25 fps with the exit mirroring the reveal; in this library exits are shorter than entrances (0.40 in / 0.25 out is the house ratio) or absent entirely.
- **Offset from the spoken name:** the card should arrive within **±0.5 s**, and published practice places a lower third about **0.5 s after** the speaker begins.
- **Hold:** **2.5–5.0 s** — long enough to read twice.
- **Safe area:** the whole travel inside the 5 % EBU graphics inset (Netflix/SMPTE title safe 90 %, safe action 93 %). At 1080×1920 that is x 54…1026.
- **Sound:** one soft transient on the entrance at −12 to −15 dB. A silent lower third reads hollow because the brain expects a sound with motion.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `lines` | 2 | 1–2 | A third line is a card. |
| `primary_step` | `s1` (5.63 % of frame height) | `s1`–`s2` | The name. |
| `secondary_step` | `s-1` (3.60 %) | `s-1`–`s0` | The role, place or qualifier. |
| `secondary_ratio` | 0.64 | 0.60–0.75 | Derived: two scale steps apart. Published practice, and the library's existing 0.65. |
| `words_per_line` | 3 | 1–4 | No finite verb. A name, not a sentence. |
| `baseline_from_bottom_9x16` | 28 % of frame height | 26–32 % | Above the caption band, clear of the platform UI. |
| `baseline_from_bottom_16x9` | 17 % of frame height | 14–20 % | Above the caption band at 8–14 %. |
| `clearance_to_caption` | 4 % of frame height | ≥3 % | Below 3 % reads crowded even with no overlap. |
| `left_edge` | 6 % of frame width | 5–8 % | The project's margin. The same edge as every other left-aligned object. |
| `block_height` | 11 % of frame height | 9–13 % | Two lines plus padding. Above 15 % it is a card. |
| `accent_elements` | 1 | 1 | A left rule, an underline, or the primary in `--accent`. Never two. |
| `accent_rule_width` | `--stroke-body` (0.45 u) | 0.40–0.52 u | Matches the primary's stem width within ±15 %. |
| `accent_rule_height` | full text block | — | Not the plate. The rule brackets the type. |
| `backing` | scrim | scrim / plate | Wide object at a frame edge ⇒ the scrim case. One rung only. |
| `entrance` | 0.50 s, `power3.out` | 0.40–0.60 s | Translate 3 u from the left + `autoAlpha`. Published: 15–25 f @25fps. |
| `line_stagger` | 0.10 s | 0.08–0.12 s | Primary first. Total stagger well under the 0.5 s cap. |
| `exit` | 0.25 s, or none | 0–0.35 s | Entrances need longer than exits. In a multi-scene composition prefer no exit. |
| `hold` | 3.5 s | 2.5–5.0 s | Long enough to read twice. |
| `offset_from_spoken_name` | +0.30 s | −0.30 to +0.60 s | Published practice ≈ +0.5 s after the speaker begins. |
| `instances_per_person` | 1 | 1 | The first appearance only. |
| `min_gap_between_instances` | 30 s | ≥20 s | Two close together reads as a broadcast package. |
| `contrast_text` | ≥4.5:1 | ≥4.5:1 | At the worst frame in the window. |
| `contrast_accent` | ≥3:1 | ≥3:1 | WCAG 1.4.11 — the rule is a graphical object. |
| `safe_area` | 5 % inset, whole travel | — | EBU R 95; title safe 90 % / safe action 93 %. |
| `sfx` | one soft transient | — | −12 to −15 dB, on the entrance only. |

## Reproduction prompt

```
Build the lower third for {{NAME}} / {{ROLE OR PLACE}} at {{ASPECT}}, arriving
while the picture keeps running.

1. TWO LINES, derived from the type scale, not chosen:
     primary   = step s1  (5.63% of frame height) - the NAME
     secondary = step s-1 (3.60% of frame height) - the ROLE / PLACE
   The ratio is 0.64, which is two steps on a 1.25 scale = 1.5625x apart. That is
   above the 1.4x discrimination floor, which is why the two lines read as two
   levels. Do NOT use adjacent steps.
   Max 3 words per line. No finite verb. This is a NAME, not a sentence - if it
   reads like something the speaker said, it belongs in the caption layer.

2. POSITION BY BAND, not by the phrase "lower third". At 9:16 the caption track
   owns 18-26% of frame height and the platform UI owns the bottom 18%, so the
   lowest glyph sits at 26-32% of frame height - it is not in the lower third of
   the frame at all. At 16:9 the lowest glyph sits at 14-20%. Keep 4% of frame
   height of clear air between this block and the caption band. Left edge at the
   project's margin (6% of frame WIDTH), the same edge as every other left-aligned
   object in the video.

3. ONE ACCENT ELEMENT. Choose exactly one: a vertical rule at the left edge
   (width = --stroke-body, height = the full TEXT block, not the plate), an
   underline under the primary, or the primary set in --accent. Two accent
   elements is decoration.

4. ONE BACKING RUNG. A lower third is wide and sits at a frame edge, so a scrim
   is usually right: --ground at zero alpha ramping to 0.72 over 25-35% of frame
   height. Measure the luminance of the block's box over its window and verify
   4.5:1 for the text and 3:1 for the accent AT THE WORST FRAME.

5. ANIMATE: primary translates 3u from the left plus autoAlpha over 0.50s
   power3.out at {{spoken name + 0.30s}}; secondary the same, 0.10s later. Hold
   3.5s. Prefer NO exit - let the cut clear it; if it must clear inside the shot,
   0.25s out.

6. ONE sound on the entrance, -12 to -15 dB. Not one per line.

7. ONCE PER PERSON. The first appearance only, and never two lower thirds within
   30s of each other.

ACCEPTANCE TEST:
(a) the lowest glyph sits in the specified band and clears the caption band by
    >= 4% of frame height, verified on a snapshot with the caption live;
(b) secondary / primary type size is between 0.60 and 0.75;
(c) exactly one accent element;
(d) the accent rule's width is within 15% of the primary's measured stem width;
(e) the whole travel stays inside the 5% graphics safe inset;
(f) at the brightest and darkest frame of the window, text >= 4.5:1 and accent
    >= 3:1;
(g) downscale a frame to 480px wide - the primary line is still readable;
(h) the block does not appear twice for the same subject.
```

## Execution spec

**HyperFrames — one parameterised sub-composition, instanced per subject.** Same shape as the item marker, for the same reason: identity across instances is a property of the build, not of the operator.

```html
<html data-composition-variables='[
  {"id":"name","type":"string","label":"Name","default":"Name"},
  {"id":"role","type":"string","label":"Role or place","default":"Role"}]'>
<template id="lower-third-template">
  <div data-composition-id="lower-third" data-width="1080" data-height="1920"
       data-duration="4.6" style="position:relative;width:1080px;height:1920px;overflow:hidden;">
    <style>
      [data-composition-id="lower-third"] .scrim{
        position:absolute; left:0; right:0; z-index:10;
        bottom: calc(24 * var(--u)); height: calc(20 * var(--u));
        background:linear-gradient(to top, rgba(16,34,43,.72), rgba(16,34,43,0));
      }
      [data-composition-id="lower-third"] .l3{
        position:absolute; z-index:40;
        left: calc(6 * var(--w)); bottom: calc(28 * var(--u));
        padding-left: calc(1.6 * var(--u));
        border-left: var(--sw-body) solid var(--accent);   /* the ONE accent element */
      }
      [data-composition-id="lower-third"] .l3-name{
        font-size:var(--s1); font-weight:var(--w-body);
        letter-spacing:var(--track-body); line-height:1.1; color:var(--ink);}
      [data-composition-id="lower-third"] .l3-role{
        font-size:var(--s-1); font-weight:var(--w-body);
        text-transform:uppercase;
        letter-spacing:calc(var(--track-body) + var(--track-caps-adj));
        line-height:1.2; color:var(--ink-dim); margin-top:calc(0.6 * var(--u));}
    </style>
    <div class="scrim" id="l3-scrim"></div>
    <div class="l3">
      <div class="l3-name" id="l3-name" data-var-text="name">Name</div>
      <div class="l3-role" id="l3-role" data-var-text="role">Role</div>
    </div>
  </div>
</template>
<script src="./vendor/gsap.min.js"></script>
<script>
  const tl = gsap.timeline({ paused:true, defaults:{ ease:"power3.out" } });
  tl.fromTo("#l3-scrim", { autoAlpha:0 }, { autoAlpha:1, duration:0.40 }, 0.00);
  tl.fromTo("#l3-name",  { x:-30, autoAlpha:0 }, { x:0, autoAlpha:1, duration:0.50 }, 0.07);
  tl.fromTo("#l3-role",  { x:-30, autoAlpha:0 }, { x:0, autoAlpha:1, duration:0.50 }, 0.17);
  tl.to(["#l3-name","#l3-role","#l3-scrim"],
        { autoAlpha:0, duration:0.25, ease:"power2.in" }, 4.20);
  window.__timelines["lower-third"] = tl;
</script>
</html>
```

Host slot in `index.html`:

```html
<div id="el-l3-01" data-composition-id="lower-third"
     data-composition-src="compositions/lower-third.html"
     data-start="34.80" data-duration="4.6" data-track-index="3"
     data-variable-values='{"name":"YAAS Office","role":"Bangalore"}'></div>
```

Contract points:

- **`data-var-text` binds an element's own text to a scalar variable id** (children preserved); **`data-variable-values`** overrides it per host. `data-composition-variables` is a JSON **array of declarations** on `<html>`; render-time `--variables` is a JSON **object keyed by id**.
- **Exactly one `gsap.timeline({paused:true})` per composition**, keyed by the root's `data-composition-id`. Do not manually nest it into the host — *"the runtime auto-nests registered child timelines."*
- **Sub-comp time is scene-local**: the tween at `0.00` fires at the host's `data-start`. Do not add the host offset inside the sub-comp.
- **A sub-comp timeline cannot animate host-root elements**, so the scrim must live inside the lower third, not at the host root. This is why the scrim is a sibling here rather than a shared overlay.
- **The exits land at 4.20 + 0.25 = 4.45 < 4.60** — the visibility window is half-open and the final frame is never rendered.
- **The root needs an explicit sized px box** and every ancestor a resolved height, or a `100%` child collapses to zero and the content piles into the top-left. `snapshot --at <midpoints>` is **required** for projects with sub-compositions and is the only real defence.
- **`border-left` is static layout, not a tween target.** Do not animate `borderWidth` — it forces layout; if the rule must draw on, use a separate absolutely-positioned div and tween `scaleY` from a `transform-origin: bottom`.
- **`data-layout-allow-caption-zone`** is the narrow opt-out if the block genuinely has to sit in the caption band. Prefer the band table. Do not use `data-layout-allow-overflow`.
- **No CDN scripts.** GSAP is vendored locally (`./vendor/gsap.min.js`); `cdn.jsdelivr.net` is blocked by the egress allowlist and a composition that loads from it renders blank. Fonts bundled or local `@font-face`; not `Inter`.
- **Sound:** one transient, `data-audio-group="sfx"`, −12 to −15 dB, loudest frame on the block's first visible frame ([[sfx-appearance-transient]], [[sfx-whoosh-transition-movement-reveal]]).

**ffmpeg — the baked form and the band check:**

```bash
# is the block clear of the platform UI band? draw both and look.
ffmpeg -ss 35.5 -i out.mp4 -frames:v 1 -vf "\
drawbox=x=0:y=ih*0.82:w=iw:h=ih*0.18:color=red@0.3:t=fill,\
drawbox=x=0:y=ih*0.74:w=iw:h=ih*0.08:color=yellow@0.2:t=fill" /tmp/l3/bands.png
```

**Remotion.** `<LowerThird name role />` in a `<Sequence>`; identical geometry.

## Pairs with
[[gfx-modular-type-scale]] · [[gfx-vertical-grid-and-margins]] · [[gfx-plate-and-scrim-ladder]] · [[gfx-stroke-weight-and-corner-radius]] · [[gfx-label-callout-over-footage]] · [[gfx-attention-budget-simultaneity]] · [[sub-safe-area-and-caption-zone]] · [[sub-caption-graphic-collision]] · [[sub-list-marker-caption-lockup]] · [[motion-list-item-marker-card]] · [[motion-attribution-label-inset-clip]] · [[motion-overlay-stack-choreography]] · [[struct-credibility-anchor]] · [[sfx-appearance-transient]]

## Failure modes
- **A lower third in the lower third of a vertical frame.** Under the platform UI. It renders, it passes every check, and nobody reads it.
- **Adjacent type steps.** Primary at `s1` and secondary at `s0` is 1.25× apart, below the discrimination floor: the two lines read as one size, badly set.
- **Two accent elements.** A left rule *and* an underline *and* a coloured name. Decoration.
- **The accent rule on the wrong stroke rung.** A hairline rule beside 700-weight type reads as a stray line; a `mark`-rung rule reads as a badge.
- **The rule bracketing the plate instead of the text.** The proportion goes wrong as soon as the padding changes.
- **A role line that is a sentence.** "Has been editing for twelve years" is a claim, and claims belong to the voice or to a statement card.
- **Two lower thirds in 30 s.** Reads as a broadcast package.
- **A persistent lower third.** Furniture. If something must be permanent it is a corner mark, and it is much smaller.
- **No clearance to the caption band.** Legal, non-overlapping, and crowded.
- **A silent entrance.** The brain expects a sound with motion; without one the block feels hollow.
- **Merging it with the attribution convention.** Different claim, different register, different corner, different face.
- **Hand-built instances.** Placement drifts per subject. Correction: one parameterised sub-comp, instanced with `data-variable-values`.
- **Known gap:** the published entrance figures (15–25 frames at 25 fps, ≈0.5 s after the speaker begins) come from lower-third tutorial practice rather than from measurement of the reference videos, whose lower-third timings were not recoverable from a contact sheet. They agree with this library's house entrance band, which is why they are used; measure a real reference before matching a specific creator.
