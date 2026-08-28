---
id: gfx-plate-and-scrim-ladder
title: Five ways to back a graphic — own the frame, the pixels, the luminance, the placement, or nothing
skill: motion
type: graphic
family: visual-system
tags: [skill/motion, type/graphic, family/visual-system, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/sfx-kt-2, source/hyperframes, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "visual — contact sheet, concept cards"
    quote: "[NOT SPOKEN — observed on screen] Full-frame word cards on black — 'Whistle' — as a marker before demonstrating a sound; elsewhere left-aligned labels sitting directly over live action."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:48"
    quote: "Next, layer a bunch of visual elements over your footage."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: ".caption-box — background-color: #7a6248; padding: 12px 32px; border-radius: 24px; box-shadow: 0 4px 15px rgba(0,0,0,.2)."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
  - https://developer.mozilla.org/en-US/docs/Web/CSS/backdrop-filter
  - https://tech.ebu.ch/docs/r/r095.pdf
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: video
---

# Five ways to back a graphic — own the frame, the pixels, the luminance, the placement, or nothing

## What it is

The decision that comes immediately after "this beat needs a graphic": **how much of the frame does the graphic have to take away from the footage in order to be readable?** There are exactly five answers, they form a ladder ordered by cost, and the rule is to take the lowest rung the measurement allows and no lower.

| Rung | What it owns | Contrast floor over worst-case footage | Guaranteed? | Cost |
|---|---|---|---|---|
| **5. Full-frame card** | The whole frame | The card's own computed pairs (7:1 ink, 3:1 marks) | **Yes** | The picture stops. Everything the footage was doing is gone. |
| **4. Opaque plate** | The element's box | Exactly the ink-to-plate ratio (the reference pair `#f5f0e0` on `#7a6248` is ≈ 6.4:1) | **Yes** | A rectangle of picture is gone; the object reads as *stamped on*. |
| **3. Scrim** | The luminance of a region | Computable once, from the darkened band's YMAX | Yes, **inside its own box** | The picture stays but loses local contrast; a gradient reads as *lit*, a flat plate as *dimmed*. |
| **2. Placement** | Nothing | Whatever the footage does there | **No** — it is a proof, and the proof expires when the footage changes | Free, and the only rung that can silently break later. |
| **1. Nothing** | Nothing | Undefined | No | Free, and only legal when the "footage" is a surface you control. |
| — | *Blur-behind* | Detail, not luminance | **No** | Sits between 2 and 3 in feel and below 2 in reliability. See below. |

**Blur is not a rung, and this is the most common misunderstanding in the whole area.** `backdrop-filter: blur()` removes spatial *detail*; it does not touch *luminance*. A blurred white sky is still white. Blur makes a busy background *calm*, which reads as legible in a screenshot and is not a contrast mechanism. If a blur is used, the contrast is coming from the tint over it, and the tint is a rung-3 scrim with an expensive aesthetic attached.

**The two rules that make the ladder work.**

**Exactly one rung per element.** A plate plus a stroke plus a shadow is the signature of a design assembled by adding fixes until one frame looked acceptable. It thickens the letterforms, fills the counters, and actively *lowers* the measured ratio, because the dark stroke now sits between the ink and the plate. A `box-shadow` on the plate — the reference implementation's `0 4px 15px rgba(0,0,0,.2)` — is separation from the picture, not contrast, and is therefore permitted alongside any rung.

**The backing must be bigger than the thing it backs, including during travel.** An object one pixel wider than its plate has an unbacked edge, and the eye goes to edges. Overhang is 1.5 % of frame height on every side, computed against the *union* of the element's poses, not its rest pose.

The caption case is decided separately and by a note with different constraints — a caption's plate changes size on every cue, which is why word-level captions usually take a stroke where a graphic would take a plate ([[sub-legibility-backing-ladder]], [[sub-caption-plate-geometry]]). This note is for everything that is not a caption. The measurement that chooses the rung is in [[gfx-contrast-over-moving-footage]].

## When to use it

- **Once per component type**, recorded in the profile as a rung plus its numbers, not per instance.
- **Immediately after the luminance measurement**, which is what selects the rung. Choosing first and measuring afterwards is how designs acquire three backings.
- **Rung 5 (full-frame card)** when the beat has no picture worth keeping, when the graphic *is* the beat (a concept card, a statement card, a comparison), or when the graphic needs more than about 45 % of frame height. Below that threshold a card is wasting the footage; above it, a plate is a card with worse edges.
- **Rung 4 (plate)** when the footage matters, the object is small and textual, and the footage is unpredictable. Chips, lower thirds, attribution labels, stat chips. This is the default over live footage and it is the boring correct answer.
- **Rung 3 (scrim)** when the object is wide, sits against a frame edge, and the picture behind it should stay visible — the bottom-band case. Also the right rung for a *group* of objects: one scrim under a stack is far better than four plates.
- **Rung 2 (placement)** when the shot is locked and the region is measurably quiet (`YAVG` range under 25 across the window). Re-prove it after any footage change.
- **Rung 1 (nothing)** only when the background is a surface you authored — a card, a screenshot with a known flat area, a graded solid.
- **Not** as a per-frame decision. A component whose rung changes mid-video is two components.

## How to recognise it in a reference video

Every rung has a single-frame tell, and they are unambiguous.

| Signal | Measure | Reading |
|---|---|---|
| Full-frame card | Is any footage visible? | No footage anywhere ⇒ rung 5. |
| Plate present | Sample 5 points inside the box on a *busy* frame | Identical RGB ⇒ opaque plate. Varying ⇒ translucent, scrim, or blur. |
| Plate alpha | Compare plate RGB over a bright moment and a dark one | Same ⇒ opaque. Different ⇒ translucent; compute alpha from the delta. |
| Scrim | Look at the *edge* of the darkened region | A hard edge ⇒ flat plate at alpha. A ramp over 25–35 % of frame height ⇒ gradient scrim. |
| Scrim extent | Measure the darkened band's height as % of frame height | 25–35 % is the designed band for a bottom scrim. |
| Blur-behind | Look at a high-detail frame at the box edge | Detail smeared *inside* the box while luminance is preserved ⇒ `backdrop-filter`. |
| Placement only | `signalstats` YAVG range on the element's crop | Under ~25 ⇒ the designer proved the region was quiet. Over 70 with no backing ⇒ they did not. |
| Stacking | Count distinct dark treatments on one glyph | More than one ⇒ stacked backing; a defect. |
| Overhang | Compare the object's box with the backing's box | Backing smaller than object ⇒ an unbacked edge. |
| Separation shadow | Is the shadow on the *box* or on the *glyphs*? | On the box ⇒ legitimate separation. On the glyphs as the only treatment ⇒ rung 0 pretending to be rung 4. |

One more, worth its own line: **look for absence.** Text laid directly over moving footage with no backing at all, in a video that is otherwise competent, is almost always a section where the footage changed after the graphic was designed. Note the section, not just the frame.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `rung` | 4 (plate) | 1–5 | One per component type. Selected by the luminance measurement, not by taste. |
| `rungs_stacked` | 1 | 1 | Hard. A `box-shadow` on the box is not a second rung. |
| `card_threshold` | 45 % of frame height | 40–55 % | Above this the graphic should own the frame; below it, a plate. |
| `plate_alpha` | 1.0 | 0.85–1.0 | Below 0.85 the floor is no longer guaranteed; below 0.7 the plate is decorative. |
| `plate_pad_x` | 0.67 em | 0.5–1.0 em | The reference `12px 32px` at 48 px is `0.25 em / 0.67 em`. Express in `em` so the plate scales with type. |
| `plate_pad_y` | 0.25 em | 0.2–0.4 em | Same. |
| `plate_radius` | 0.5 em | 0–0.75 em | Reference `24px` at 48 px. Pixels here is the untokenised-design smell. See [[gfx-stroke-weight-and-corner-radius]]. |
| `plate_vs_footage` | ≥3:1 | ≥3:1 | The plate is itself a graphical object under WCAG 1.4.11; below 3:1 its edge vanishes and the object floats. |
| `ink_on_plate` | ≥4.5:1 | ≥4.5:1 | The reference pair computes to ≈6.4:1. Design to 4.5:1 even for large text — the large-text allowance assumes a static page. |
| `scrim_height` | 30 % of frame height | 25–35 % | Bottom-up gradient. |
| `scrim_peak_alpha` | 0.72 | 0.55–0.82 | At the frame edge. |
| `scrim_flat_alpha` | 0.55 | 0.40–0.65 | If a flat plate rather than a gradient. |
| `scrim_colour` | `--ground` | — | At zero alpha at the far stop. **Never the `transparent` keyword.** |
| `gradient_min_stop` | 0.15 | ≥0.15 | Below this a ramp bands visibly at social bitrates. |
| `overhang` | 1.5 % of frame height | 1–3 % | On every side, against the union of the element's poses. |
| `blur_radius` | 12 px | 8–24 px | Only as an aesthetic on top of a rung-3 tint. Never the mechanism. |
| `blur_tint_alpha` | 0.55 | 0.40–0.70 | This is what is actually doing the contrast work. |
| `box_shadow` | `0 4px 15px rgba(0,0,0,.2)` | — | Separation from the picture. Permitted with any rung. Not contrast. |
| `placement_yavg_range` | <25 (8-bit) | <25 | The proof threshold for rung 2. Re-prove after any footage change. |
| `scrim_leads_object` | 2 frames | 2–3 f | The backing fades in first, or the object shows against raw footage. |
| `one_scrim_per_group` | preferred | — | One scrim under a stack beats four plates. |

## Reproduction prompt

```
Choose and specify the backing for every non-caption graphic element in
{{PROJECT}}. One rung per element. Do not stack.

1. MEASURE FIRST. For each element, dump per-frame luminance of ITS bounding box
   over ITS time window (see the contrast note's ffmpeg recipe) and record the
   YAVG range and the YMAX.

2. SELECT THE RUNG - the LOWEST one the measurement allows:
     graphic needs > 45% of frame height, or the beat has no picture worth
       keeping                                     -> 5. FULL-FRAME CARD
     small textual object, footage matters,
       footage unpredictable                       -> 4. OPAQUE PLATE
     wide object at a frame edge, or a GROUP of
       objects, picture should stay visible         -> 3. SCRIM
     shot locked AND measured YAVG range < 25       -> 2. PLACEMENT (with proof)
     background is a surface you authored           -> 1. NOTHING
   Blur-behind is NOT a rung. Blur removes detail, not luminance; a blurred white
   sky is still white. If you use it, the contrast comes from the tint, and the
   tint is rung 3 with an expensive aesthetic on top.

3. SPECIFY THE NUMBERS for the chosen rung:
     PLATE: colour, alpha (>= 0.85 or the floor is not guaranteed), padding in em
       (0.25em / 0.67em), radius in em (0.5em), ink-to-plate ratio (>= 4.5:1),
       plate-to-footage ratio (>= 3:1 - WCAG 1.4.11, or the plate's edge vanishes).
     SCRIM: band height as % of frame height (25-35%), peak alpha (0.55-0.82),
       colour = --ground at zero alpha at the far stop. NEVER the `transparent`
       keyword; no stop below 0.15 opacity.
     CARD: the palette's own five computed pairs; nothing new.
     PLACEMENT: paste the measured YAVG range as the proof, and name the shots it
       was proved against.

4. SIZE THE BACKING LARGER THAN THE OBJECT: 1.5% of frame height of overhang on
   every side, computed against the UNION of the element's poses including its
   entrance and exit travel - not its rest pose.

5. ORDER THE FADES: the backing fades in 2-3 frames BEFORE its object, and out
   2-3 frames after. Otherwise there are frames where the object sits on raw
   footage.

6. A box-shadow on the plate for separation from the picture is permitted with
   any rung and is not a second backing. A stroke on the glyphs, a second plate,
   or an offset text-shadow IS a second backing and is forbidden.

7. STATE PER ELEMENT whether the floor is GUARANTEED (rungs 4 and 5 only) or
   LIKELY (rungs 1-3), and for every LIKELY, name the fallback for the frames
   where it fails.

ACCEPTANCE TEST:
(a) count distinct dark treatments on one glyph of each element - exactly one
    passes;
(b) each backing's box is larger than its object's box including travel;
(c) the ink-to-plate ratio and the plate-to-footage ratio are both computed and
    recorded, not asserted;
(d) step the entrance frame by frame and confirm the object is never visible
    before its backing;
(e) for any rung-2 element, the YAVG proof is in the profile with the shot ids
    it was measured on.
```

## Execution spec

**HyperFrames.** All five rungs are ordinary CSS. What differs is which of them interacts badly with the stack.

```css
[data-composition-id="gfx"] .plate{                    /* rung 4 */
  background: var(--ground);                            /* alpha 1 */
  padding: 0.25em 0.67em;
  border-radius: 0.5em;
  box-shadow: 0 4px 15px rgba(0,0,0,.2);                /* separation, NOT contrast */
}
[data-composition-id="gfx"] .scrim{                    /* rung 3 */
  position:absolute; left:0; right:0; bottom:0; height:30%; z-index:10;
  background: linear-gradient(to top,
    rgba(16,34,43,.72),                                 /* --ground at peak alpha */
    rgba(16,34,43,0));                                  /* --ground at ZERO alpha  */
}
[data-composition-id="gfx"] .card{                     /* rung 5 */
  position:absolute; inset:0; background: var(--ground);
}
```

Constraints, in order of how likely each is to bite:

- **`backdrop-filter` and animated opacity are mutually exclusive.** An element with `opacity < 1` **is a backdrop root**, so a box whose opacity is being tweened has nothing to blur until opacity reaches exactly 1 — the blur pops in at the end of the fade. Split it: animate `autoAlpha` on an outer wrapper and put `backdrop-filter` on an inner box that never leaves opacity 1. `backdrop-filter` is also GPU-expensive per rendered frame, and the render happens off the authoring VM regardless.
- **Never the `transparent` keyword in a gradient.** Use the target colour at zero alpha. No stop below `0.15` opacity, and no gradient on an element thinner than 4 px — mandatory if the project uses shader transitions, harmless otherwise.
- **Layering is CSS `z-index`.** `data-track-index` is *"display only … not read by the render, and it constrains nothing."* Scrim 10, cards 20, labels 40, annotation 60, captions 80.
- **The backing is a sibling under the object, not a parent.** A parent with a background clamps nothing useful and makes the object's own layout depend on the plate's box. Two absolutely-positioned siblings in one `data-start` wrapper is the shape; the wrapper's window then clears both with one attribute.
- **A timed wrapper clamps its descendants** — a child cannot be visible while its timed ancestor is hidden. That is the feature: one `data-start`/`data-duration` on the stack retires the scrim and the object together.
- **An untimed full-bleed backing needs its own `position:absolute; inset:0`.** Root-level automatic layout only applies to elements carrying `data-start`; elements without it are skipped entirely and collapse to zero height.
- **`autoAlpha` on inner elements, never `display`/`visibility` on the clip.** `fromTo`, never `from`. Land the last tween before `data-duration`.
- **`data-layout-allow-caption-zone`** is the narrow opt-out for a backing that legitimately occupies the caption band. Do **not** reach for `data-layout-allow-overflow`: it inherits down the whole subtree and also silences `text-clipping`, `content-cramped-container` and `foreground-over-panel`.
- **`check`'s contrast audit reads the declared CSS background.** Over a plate it is trustworthy and useful — this is the one place the audit earns its keep. Over footage it is meaningless. And a lint error switches it off entirely, reporting `0/0 text checks`.

**ffmpeg — baking a backing into a file that leaves the pipeline**, and the flat-scrim equivalent:

```bash
# flat scrim over the bottom 30% of frame, gated to the element's window
ffmpeg -i base.mp4 -filter_complex \
 "drawbox=x=0:y=ih*0.70:w=iw:h=ih*0.30:color=0x10222b@0.55:t=fill:\
enable='between(t,12,16.5)'" out.mp4
# a plate under a burned label
ffmpeg -i base.mp4 -filter_complex \
 "drawbox=x=iw*0.06:y=ih*0.30:w=iw*0.34:h=ih*0.06:color=0x10222b@1.0:t=fill,\
  drawtext=fontfile=./vendor/Montserrat-Bold.ttf:text='METAL HIT':fontsize=69:\
fontcolor=0xf5f0e0:x=iw*0.075:y=ih*0.312" out.mp4
```

**Remotion.** `<AbsoluteFill>` per band with explicit `zIndex`; the rung ladder and the numbers are framework-independent.

## Pairs with
[[gfx-contrast-over-moving-footage]] · [[gfx-palette-ground-ink-accent]] · [[gfx-stroke-weight-and-corner-radius]] · [[gfx-label-callout-over-footage]] · [[gfx-lower-third-anatomy]] · [[motion-overlay-stack-choreography]] · [[sub-legibility-backing-ladder]] · [[sub-caption-plate-geometry]] · [[motion-spotlight-mask-reveal]] · [[gfx-full-frame-statement-card]] · [[motion-abstract-concept-card]]

## Failure modes
- **Stacking rungs.** Plate plus stroke plus shadow. Counters fill, letterforms thicken, and the stroke between ink and plate *lowers* the measured ratio.
- **Choosing the rung before measuring.** Produces exactly the stack above, one fix at a time.
- **Backing smaller than the object.** An unbacked edge is where the eye goes.
- **Object fading in before its backing.** Two to three frames of the object on raw footage, every single time it appears.
- **Blur as the mechanism.** Removes detail, not luminance.
- **`backdrop-filter` on an opacity-animated element.** Silently inert until the fade completes, then pops.
- **A plate below 0.85 alpha called a plate.** It is a scrim with a hard edge, and it no longer guarantees a floor.
- **A plate at 3:1 or less against the footage.** Its own edge disappears and the object reads as floating text with a smudge behind it.
- **`transparent` in a gradient.** Grey ramp over a coloured ground in some engines.
- **A plate per object in a group of four.** Four rectangles of lost picture where one scrim would do, and four edges to align.
- **Rung 2 without proof, or with expired proof.** Placement is the only rung that can break because somebody swapped a B-roll clip.
- **A full-frame card where a plate would do.** The picture stops for a two-word label. Correction: the 45 %-of-frame-height threshold.
- **Known gap:** there is no automatic saliency or face detection in this stack, so "the quiet part of the shot" cannot be found by the tool. Rung 2's proof is an ffmpeg measurement the analysis pass has to run and write down, and it is only valid for the exact clips it was run on.
