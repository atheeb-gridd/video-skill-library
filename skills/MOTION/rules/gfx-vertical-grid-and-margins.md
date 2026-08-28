---
id: gfx-vertical-grid-and-margins
title: The 9:16 grid — six columns, margins as percentages, and the four bands the frame is already spent on
skill: motion
type: graphic
family: visual-system
tags: [skill/motion, type/graphic, family/visual-system, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "visual — contact sheet, screen recordings"
    quote: "[NOT SPOKEN — observed on screen] Screen recordings carry a circular webcam PiP bottom-left; inline video-reference cards sit at frame right; a location lower-third reads 'YAAS Office, Bangalore'."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, timeline overlay"
    quote: "[NOT SPOKEN — observed on screen] A stylised NLE timeline overlaid across the bottom of the frame on every film-clip example, with the clip letterboxed and inset on a dark ground rather than filling frame."
research_refs:
  - https://tech.ebu.ch/docs/r/r095.pdf
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/4406208331923-Title-Safe-and-Safe-Action-Best-Practices
  - https://sproutsocial.com/insights/social-media-video-specs-guide/
  - https://legibility.info/rules-for-text-in-videos
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
difficulty: medium
detectable_from: video
---

# The 9:16 grid — six columns, margins as percentages, and the four bands the frame is already spent on

## What it is

A layout system for the vertical frame, in two halves that use **two different denominators**, which is the part that gets got wrong.

**Horizontally: columns and margins as percentages of frame width.** Six columns, a side margin of 6 %, a gutter of 2 %. That resolves to `(100 − 12 − 10) ÷ 6 = 13 %` per column — `140 px` on a 1080-wide frame. Two columns plus a gutter is 28 %; three is 43 %; the full content width is 88 %. Six is the right number for 9:16 because the useful subdivisions of a vertical frame are halves and thirds, and six is the smallest number divisible by both.

**Vertically: bands as percentages of frame height, and most of them are already spent.** This is the real content of the note. A 9:16 frame is not 100 % available:

| Band | % of frame height (from bottom) | Owner | Free? |
|---|---|---|---|
| Platform UI | 0 – 18 % | The host app's caption/handle/CTA stack | **No** |
| Caption track | 18 – 26 % | The caption band, baseline at ~20 % | **No** |
| Clearance | 26 – 30 % | Dead air between caption and anything else | **No** |
| **Graphic band** | **30 – 62 %** | **This is the whole budget: 32 % of frame height** | Yes |
| Subject band | 62 – 87 % | The presenter's head and shoulders in a talking-head cut | Usually no |
| Platform header | 87 – 100 % | Profile row, back button, "Following/For You" | **No** |

Plus a **right rail** of 16 % of frame *width* on the vertical platforms, where the like/comment/share column lives.

**So the honest statement of the 9:16 layout problem is: a graphic gets about a third of the frame's height and about five-sixths of its width, and the subject is in the way of the rest.** Everything in the component library — the card sizes, the row counts, the two-column-versus-stacked decision — falls out of that budget rather than out of taste. A designer who starts from "the frame is 1080 × 1920" designs a graphic that is either under the platform UI or over the presenter's face.

**Safe area is a different constraint from platform UI, and both apply.** EBU R 95 puts the graphics safe area at a **5 % inset** and the action safe area at **3.5 %** — a manufacturing and cropping tolerance, symmetric on all four edges. Netflix/SMPTE title safe is **90 %** of the frame and safe action **93 %**. Platform UI is not a tolerance; it is an occlusion, it is asymmetric, and it is much larger. The 6 % side margin clears the 5 % graphics safe inset with a point to spare; the vertical bands clear platform UI with much more.

**16:9 uses the same method and different numbers**: twelve columns, 5 % side margin, 1.5 % gutter ⇒ `(100 − 10 − 16.5) ÷ 12 = 6.125 %` per column. The vertical bands collapse to caption at 8–14 %, a lower-third band at 14–24 %, and a very large free middle, because a landscape frame has no platform UI to speak of and the subject occupies a third rather than a quarter.

**The vertical rhythm unit is the same `--unit` as the type scale**: 1 % of frame height. Every vertical offset in the project is an integer multiple of it. This is what makes a lower third and a caption and a stat card look like they were placed by one person.

## When to use it

- **Once per aspect ratio**, before any component is designed, and re-resolved (not scaled) for every additional aspect.
- **As the first geometry decision**, before type size and before motion — a component that does not fit the graphic band is not a component that needs smaller type, it is the wrong component.
- **Whenever `hyperframes check` reports `caption_zone_collision`.** That finding is the framework saying the band table was not consulted.
- **Whenever the subject band is unknown.** Measure it: it is a per-project fact, not a constant. A seated mid-shot puts the head at 62–87 %; a close-up can reach 45 %, and then the graphic band is gone and the beat needs a cutaway rather than an overlay.
- **Whenever a graphic must move.** The dodge target has to be a band, not an offset — see [[sub-caption-graphic-collision]], which owns the collision resolution and whose rule is that **the caption moves and the graphic does not**.
- **Not** for a full-frame card, which owns the frame and is bounded only by safe area and the platform header/footer.

## How to recognise it in a reference video

- **Measure every graphic's bounding box as percentages, of the right denominator each way** — width for x, height for y. Pull one frame per component: `ffmpeg -ss <t> -i ref.mp4 -frames:v 1 f.png`.
- **Recover the side margin.** Take the left edge of three different left-aligned objects. Identical within 0.5 % of frame width ⇒ a margin exists. Three different values ⇒ objects placed by eye. This is the single fastest test for whether a grid exists at all.
- **Recover the column count.** Collect every object's left edge and right edge as percentages of frame width, sort, and look for a repeating interval. A 6-column grid with a 2 % gutter puts edges at 6, 19, 21, 34, 36, 49, 51, 64, 66, 79, 81, 94. Landing within ±0.5 % of that set is a grid.
- **Recover the vertical rhythm.** Same on the y axis with frame height as the denominator. Offsets landing on integer percentages is the tell.
- **Measure the caption baseline as % from the bottom.** 16–26 % for vertical in-feed, 8–14 % for 16:9. Then measure the *nearest* graphic edge and compute the clearance: **4 % of frame height** is the comfortable minimum, **3 %** the floor.
- **Overlay the platform chrome.** Composite the target app's UI over the frame. Any glyph under the handle stack or the action rail is a glyph nobody read, and it will pass every automated check.
- **Look for the subject band.** Sample five frames of A-roll and take the union of the head-and-shoulders bounding box. That union is not available to graphics, and its top edge is the real ceiling of the graphic band.
- **Check the other aspect if it exists.** Identical *pixel* offsets across a 16:9 and a 9:16 cut of the same content means the design was scaled rather than re-resolved; identical *percentages* means it was authored properly.
- **Count how much of the frame the graphics actually use.** In competent vertical work the union of all graphic boxes over the whole video is a band, not a scatter. A scatter means each graphic was placed against the shot it happened to land on.

## Parameters

| Parameter | Default (9:16) | Default (16:9) | Notes |
|---|---|---|---|
| `columns` | 6 | 12 | Smallest number divisible by 2 and 3. |
| `side_margin` | 6 % of frame **width** | 5 % of width | 65 px at 1080 wide; 96 px at 1920 wide. Clears the EBU 5 % graphics safe inset. |
| `gutter` | 2 % of width | 1.5 % of width | 22 px / 29 px. |
| `column_width` | 13 % of width | 6.125 % of width | Derived, not chosen. |
| `content_width` | 88 % of width | 90 % of width | The full six/twelve columns plus gutters. |
| `rhythm_unit` | 1 % of frame **height** | 1 % of height | The same `--unit` as the type scale. All vertical offsets are integer multiples. |
| `platform_bottom_band` | 18 % of height | n/a | ~340 px of 1920. Treat TikTok/Reels/Shorts alike unless measured. |
| `platform_top_band` | 13 % of height | n/a | ~250 px of 1920, profile/header row. |
| `platform_right_rail` | 16 % of **width** | n/a | The action column. Centred objects must be narrower than what remains. |
| `caption_band` | 18–26 % of height | 8–14 % | Baseline at ~20 % / ~11 %. Owned by [[sub-safe-area-and-caption-zone]]. |
| `graphic_band` | **30–62 % of height** | 24–78 % | The actual budget. 32 % of frame height at 9:16. |
| `subject_band` | 62–87 % of height | 30–95 % | **Measure it per project.** A close-up eats the graphic band. |
| `clearance` | 4 % of height | 3–6 % | Between any two simultaneously visible objects. Below 3 % reads crowded even with no overlap. |
| `graphics_safe_inset` | 5 % | 5 % | EBU R 95. At 1080×1920: x 54…1026, y 96…1824. |
| `action_safe_inset` | 3.5 % | 3.5 % | EBU R 95. Netflix/SMPTE equivalents: title safe 90 %, safe action 93 %. |
| `max_box_width` | 88 % of width | 90 % of width | Wider reads as edge-to-edge and collides with the rail. |
| `alignment` | left, one axis | left | One vertical alignment axis for the whole video. Centred *and* left-aligned objects in one frame is the commonest grid failure. |
| `optical_centre_offset` | −3 % of height | −2 to −4 % | A visually centred object sits **above** geometric centre. Applies to full-frame cards only. |
| `travel_stays_inside` | required | required | The safe inset applies to the element's whole travel, not its rest pose. The first 3 frames of an entrance are the ones that get cropped. |

## Reproduction prompt

```
Define the layout grid for {{PROJECT}} at {{ASPECT}} {{WIDTH}}x{{HEIGHT}},
delivered {{in-feed vertical | full-screen landscape}}.

1. TWO DENOMINATORS, and do not mix them. Horizontal quantities (margins,
   gutters, column widths, box widths) are percentages of frame WIDTH. Vertical
   quantities (bands, offsets, clearances, type sizes) are percentages of frame
   HEIGHT. A single "5%" with no denominator stated is a bug waiting to happen.

2. HORIZONTAL. 9:16 -> 6 columns, 6% side margin, 2% gutter, 13% column width,
   88% content width. 16:9 -> 12 columns, 5% margin, 1.5% gutter. Emit the full
   edge table (left and right edge of every column, as % of width) so component
   specs can name columns instead of pixels.

3. VERTICAL - and start by subtracting what is already spent:
     bottom 18% of height  : platform UI (vertical only). FORBIDDEN.
     18-26%                : caption band. Owned by the subtitles design.
     26-30%                : clearance. FORBIDDEN.
     top 13% of height     : platform header (vertical only). FORBIDDEN.
     right 16% of WIDTH    : action rail (vertical only). Keep centred objects
                             narrower than the remainder.
   MEASURE the subject band from five A-roll frames: the union of the head-and-
   shoulders box. That union is not available either.
   What is left is the GRAPHIC BAND. At 9:16 with a seated mid-shot it is
   typically 30-62% of frame height - about a third of the frame. Write the
   actual number into the profile; every component budget derives from it.

4. SET THE RHYTHM UNIT to 1% of frame height - the SAME --unit the type scale
   uses. Every vertical offset in the project is an integer multiple of it.

5. CHECK SAFE AREA SEPARATELY from platform UI. They are different constraints:
   EBU R 95 graphics safe = 5% inset on all four edges, action safe = 3.5%; these
   are cropping tolerances. Platform UI is an occlusion, it is asymmetric, and it
   is much larger. Both apply. The safe inset applies to an element's whole
   TRAVEL, not its rest pose - the first frames of an entrance are the ones that
   get cropped.

6. PICK ONE ALIGNMENT AXIS for the whole video and name it. Left-aligned at the
   6% margin is the default. Centred objects and left-aligned objects in the same
   frame is the commonest grid failure and it looks like carelessness rather than
   like a decision.

ACCEPTANCE TEST:
(a) every component's box, expressed in the grid's own units, uses no value that
    is not a column edge or an integer rhythm unit;
(b) no glyph of any element falls inside a forbidden band, checked on snapshots
    at 8 timestamps spread across the video, INCLUDING entrance frames;
(c) every element's whole travel stays inside the 5% graphics safe inset;
(d) no two simultaneously visible objects are closer than 4% of frame height;
(e) re-resolve the grid at the other shipping aspect and confirm every component
    still fits its band without any pixel value being edited.
```

## Execution spec

**HyperFrames.** The grid is CSS custom properties plus one `grid-template-columns`; the bands are named offsets, not magic numbers in component rules.

```css
[data-composition-id="gfx"]{
  --fw: 1080;  --fh: 1920;                      /* MUST equal root data-width/height */
  --u:  calc(var(--fh) / 100 * 1px);            /* 1u = 1% of frame HEIGHT   */
  --w:  calc(var(--fw) / 100 * 1px);            /* 1w = 1% of frame WIDTH    */

  --margin-x: calc(6 * var(--w));
  --gutter:   calc(2 * var(--w));

  --band-platform-bottom: calc(18 * var(--u));
  --band-caption-top:     calc(26 * var(--u));
  --band-graphic-bottom:  calc(30 * var(--u));
  --band-graphic-top:     calc(62 * var(--u));
  --clearance:            calc(4  * var(--u));
}
[data-composition-id="gfx"] .grid{
  position:absolute; inset:0;
  padding: 0 var(--margin-x);
  display:grid;
  grid-template-columns: repeat(6, 1fr);
  column-gap: var(--gutter);
  align-content: end;
}
[data-composition-id="gfx"] .in-graphic-band{
  position:absolute; left:var(--margin-x); right:var(--margin-x);
  bottom: var(--band-graphic-bottom);
  max-height: calc(var(--band-graphic-top) - var(--band-graphic-bottom));
}
```

Contract points, several of which are silent failures:

- **The root needs an explicit sized box in px, and every ancestor down to a `height:100%` element needs a resolved height**, or a flex/`100%` child collapses to ~0 and the content piles into the top-left corner. This is the single most common layout bug in the stack and it is invisible to the gates: *"Do not rely on automated gates alone to catch this; inspect a snapshot."*
- **Root-level clips get automatic layout**: direct children of the root carrying `data-start` are forced to `position:absolute`, anchored `top:0; left:0`, and sized to 100 % when they have no computed size. **Elements without `data-start` are skipped entirely** — an untimed full-bleed grid wrapper needs its own `position:absolute; inset:0` or it has no height at all.
- **Scope every rule to `[data-composition-id="…"]` inside the `<template>`.** The assembler drops a sub-composition's own `<head>` styles.
- **Positioning by flex/grid anchoring beats absolute coordinates** — it is what lets the reference caption implementation annotate its target y in a comment and still survive a size change. Use `align-content: end` plus a bottom offset rather than a computed `top`.
- **Never tween `top`/`left`/`width`/`height`.** Forbidden by the contract; use `x`/`y`/`scale` transform aliases, or the `anchored-layout-expand` rule for a box that must genuinely change size.
- **Do not derive positions from `getBoundingClientRect()` at tween time** — *"compute coordinates once at composition setup and reuse."* In a multi-scene montage do not measure at all: later clips may not be laid out yet, so use authored CSS-matched constants.
- **Per-aspect delivery is two roots, not one scaled root.** Give each aspect its own `index.html` with its own `data-width`/`data-height`, hosting the same sub-compositions and passing band offsets via `data-variable-values`. `--resolution` is a supersample, not a reframe: the aspect must match the composition and the scale must be an integer.
- **`caption_zone_collision`** is the layout audit telling you an object is in the caption band. The narrow opt-out is `data-layout-allow-caption-zone` (element plus descendants, via `closest`) and it is for an intentional lower third only. `data-layout-allow-overflow` is the wrong tool — it inherits down the subtree and also silences `text-clipping` and `content-cramped-container`.
- **`snapshot --at <midpoints>` is required for projects with sub-compositions** and is the only real defence against the root-sizing collapse and against silent relative-timing zeros. It runs on the render host, not the authoring VM.

**ffmpeg — the grid overlay, which is how you actually check a reference:**

```bash
# draw the 6-column grid and the forbidden bands over a reference frame
ffmpeg -ss 96.5 -i ref.mp4 -frames:v 1 -vf "\
drawbox=x=0:y=ih*0.82:w=iw:h=ih*0.18:color=red@0.25:t=fill,\
drawbox=x=0:y=0:w=iw:h=ih*0.13:color=red@0.25:t=fill,\
drawbox=x=iw*0.84:y=0:w=iw*0.16:h=ih:color=orange@0.18:t=fill,\
drawgrid=w=iw*0.15:h=ih*0.01:t=1:color=cyan@0.25" /tmp/g/grid.png
# letterbox a 16:9 source into 9:16 without cropping (the inset-clip convention)
ffmpeg -i in.mp4 -vf "scale=1080:-2,pad=1080:1920:0:(1920-ih)/2:0x10222b" out.mp4
```

**Remotion.** `useVideoConfig()` supplies width and height; every horizontal value is a fraction of `width`, every vertical value a fraction of `height`. The two-denominator rule is the transferable part.

## Pairs with
[[gfx-modular-type-scale]] · [[gfx-attention-budget-simultaneity]] · [[sub-safe-area-and-caption-zone]] · [[sub-platform-ui-overlap-map]] · [[sub-caption-graphic-collision]] · [[motion-overlay-stack-choreography]] · [[gfx-comparison-two-column-card]] · [[gfx-lower-third-anatomy]] · [[gfx-full-frame-statement-card]] · [[gfx-list-card-enumeration]] · [[motion-image-focal-point-direction]]

## Failure modes
- **One denominator for both axes.** "5 % margin" applied to height and width gives a frame that is visibly tighter on one axis, and at 9:16 the error is 78 %.
- **Designing against 100 % of the frame.** The bottom 18 %, the top 13 % and the right 16 % of a vertical deliverable belong to the host app. A graphic there renders, passes every check, and is never seen.
- **Assuming the subject band.** It is a per-project measurement. A close-up A-roll leaves no graphic band at all, and the correct response is a cutaway, not a smaller graphic.
- **Scaling a landscape layout to vertical.** A 230 px bottom pad is 21 % of a 1080-tall frame and 12 % of a 1920-tall one. Re-resolve, never scale.
- **Mixed alignment.** Centred and left-aligned objects in one frame. Reads as carelessness, and no single fix looks like a decision afterwards.
- **Safe area applied to the rest pose only.** The first three frames of an entrance start outside the inset and get cropped on some players.
- **Suppressing `caption_zone_collision` with `data-layout-allow-overflow`.** Its blast radius also hides real clipping. Move the object, or use the narrow caption-zone opt-out on the lower third only.
- **A `100%`-height child under an unsized ancestor.** Collapses to zero and everything piles into the top-left. Invisible to the gates; only a snapshot catches it.
- **Measuring positions at tween time.** `getBoundingClientRect()` in a multi-scene composition reads a layout that does not exist yet.
- **Known gap:** the platform band figures are guidance from platform documentation and change without notice; they are also device-dependent (a notched phone eats more of the top band). Treat 13 %/18 %/16 % as this library's defaults and re-measure by compositing the current app UI over a frame before a launch.
