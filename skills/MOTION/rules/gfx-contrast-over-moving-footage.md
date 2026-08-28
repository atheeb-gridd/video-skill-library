---
id: gfx-contrast-over-moving-footage
title: Contrast over footage you do not control — measure the worst frame, and measure it over the element's whole life
skill: motion
type: graphic
family: visual-system
tags: [skill/motion, type/graphic, family/visual-system, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/hyperframes, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:48"
    quote: "Next, layer a bunch of visual elements over your footage."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "check — the composite gate: lint + runtime + layout + motion + contrast. Target is \"0 findings\"."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "A lint error also switches off the layout and contrast audits: check then reports 0 sample(s) and 0/0 text checks, which reads like a clean file but means nothing ran."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://en.wikipedia.org/wiki/Contrast_(vision)
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://tech.ebu.ch/docs/r/r095.pdf
difficulty: high
detectable_from: video
---

# Contrast over footage you do not control — measure the worst frame, and measure it over the element's whole life

## What it is

Contrast over a flat ground is arithmetic: two hex values, one ratio, done once. Contrast over footage is a **different problem in three ways**, and every one of them is a way a design that measured fine fails on screen.

**1. The background is a distribution, not a value.** Somewhere in the element's window there is a frame where the picture behind it is exactly the luminance of the ink. Designing against a representative frame is designing against the mean of a distribution whose tail is the thing that breaks you. The correct measurement is the **worst frame inside the element's own bounding box, over the element's own time window** — not the video's average, not the shot's average, and not a frame somebody picked because it looked typical.

**2. The failure is temporal, and temporal failure is worse than uniform failure.** A label that reads at 5:1 for two seconds and 1.4:1 for eight frames does not read as "mostly legible". It reads as *flickering*, because the eye is drawn to the change. A uniformly mediocre 3:1 label is less damaging than one that oscillates between 8:1 and 1.5:1, even though the second has a better mean. This is the argument for owning the pixels — a plate guarantees a floor at every frame by construction — and the reason a "usually fine" treatment is not a treatment.

**3. Graphics are not all text, and the floors differ.** WCAG 1.4.3 sets **4.5:1** for normal text. WCAG 1.4.11 sets **3:1** for graphical objects — the parts of a non-text object required to understand it: a bar's edge against its track, a connector against the ground, an icon's stroke, a node's border. A diagram over footage has both kinds of object in it and they have different budgets, so a single "check the contrast" pass is two passes.

**The tool cannot do this for you, and it is important to know precisely why.** The contrast audit inside `hyperframes check` compares text against its **declared CSS background**, following WCAG's own guidance to use the markup's colours rather than the rendered pixels. Over `--ground` that is exactly right. Over footage the declared background is `transparent`, so the audit has nothing meaningful to compare and **passes** an illegible frame. Worse, a lint *error* switches the layout and contrast audits off entirely, after which `check` reports `0 sample(s)` and `0/0 text checks` — which reads like a clean file and means nothing ran. Read the sample count, never just the finding count.

**The engineering answer is to make the background not be footage.** There are only three honest strategies, and the ladder is decided in [[gfx-plate-and-scrim-ladder]]:

- **Own the pixels.** An opaque plate or a full-frame card. The floor is guaranteed because the video is never visible behind the object.
- **Own the luminance.** A scrim — a gradient or flat darkening of the region — pulls the whole background into a known band, so the worst frame becomes computable. Cheaper visually than a plate, still measurable.
- **Own the placement.** Put the object where the footage is reliably quiet, and *prove* it with the band-luminance dump rather than asserting it. This is the only strategy with no pixels spent, and the only one that can fail because the shot changed.

Adding weight is not on the list. Nor is a drop shadow: an offset shadow defends one side of each glyph and backgrounds do not agree to appear only on that side.

## When to use it

- **Every element that is not on `--ground`.** Labels over B-roll, lower thirds, annotation marks on an image, a stat over a screen recording, a watermark. If footage is visible anywhere inside the element's bounding box, this note applies.
- **Before choosing a backing, not after.** The measurement tells you which rung of the ladder you need. Choosing a scrim and then measuring is how a design ends up with a plate *and* a stroke *and* a shadow.
- **Again whenever the footage under the element changes** — a new B-roll pass, a section that cuts to white screen recordings, a re-grade. A treatment tuned to interview footage fails over a bright UI capture, and the failure is section-shaped so it looks like a rendering bug.
- **On the element's entrance and exit frames, not only its held state.** A 12-frame entrance that travels across a bright region is 12 frames of illegibility that no held-state sample catches.
- **Not** for objects on a card. Those are five computed pairs, once, in [[gfx-palette-ground-ink-accent]].
- **Not** as a substitute for the caption backing decision, which has its own note and its own guarantees ([[sub-legibility-backing-ladder]]).

## How to recognise it in a reference video

The method is the same whether you are auditing your own build or profiling somebody else's: **sample deliberately at the extremes, never uniformly.** A uniform sample will miss the one bright frame that decides the design.

```bash
# 1. crop to the ELEMENT's box for the ELEMENT's window, not the whole frame
#    box: x=6% y=30% w=88% h=42% of a 1080x1920 frame, live 12.0s -> 16.5s
ffmpeg -ss 12.0 -t 4.5 -i ref.mp4 \
  -vf "crop=iw*0.88:ih*0.42:iw*0.06:ih*0.30" -an /tmp/c/band.mp4

# 2. per-frame luminance statistics on that crop
ffmpeg -i /tmp/c/band.mp4 \
  -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG" -f null - 2> /tmp/c/yavg.txt
ffmpeg -i /tmp/c/band.mp4 \
  -vf "signalstats,metadata=print:key=lavfi.signalstats.YMAX" -f null - 2> /tmp/c/ymax.txt

# 3. pull the brightest and darkest frames and compute the real ratio at both
sort -t= -k2 -g /tmp/c/yavg.txt | tail -1     # brightest frame's timestamp
sort -t= -k2 -g /tmp/c/yavg.txt | head -1     # darkest
ffmpeg -ss <that t> -i ref.mp4 -frames:v 1 -q:v 2 /tmp/c/worst.png
```

| Signal | How to read it |
|---|---|
| `YAVG` range across the window **< 25** (8-bit) | Quiet footage. Placement alone may be a legitimate strategy. |
| `YAVG` range **25–70** | A scrim is the minimum. |
| `YAVG` range **> 70**, or `YMAX` > 235 anywhere | Only an opaque plate or a full-frame card guarantees the floor. |
| `YMIN` < 16 **and** `YMAX` > 235 in the same window | The element crosses both clipping ends; no single ink colour works. Plate it. |
| Ratio at the brightest frame **and** the darkest frame both ≥ 4.5:1 | The treatment survives the video. |
| Ratio ≥ 4.5:1 at the mean, < 2:1 at an extreme | Designed on a representative frame. The commonest failure in the medium. |
| Element's ratio changes visibly across its life | Flicker. Log it as a defect, not a look. |
| Marks (arrows, bars, node borders) below 3:1 at any frame | 1.4.11 failure. Edges disappear and the diagram loses its structure while keeping its text. |
| A scrim present but the element's box extends past the scrim's box | The classic half-fix: the object is bigger than its own backing. |
| Counters of `e`, `a`, `o` filled at 200 % on the worst frame | A stroke has been used as the backing and is too heavy for the size. |

Two more, both from the reference material: **look for a scrim at all.** Text laid over moving footage in competent work almost always has one — a flat plate at 40–65 % opacity, a bottom-up gradient over 25–35 % of frame height, or a blurred plate. Absence of any backing over busy footage is a fault signal, not a bold choice. And **check the transition frames**, because a collision or a contrast failure that exists only during a 12-frame entrance is easy to miss in review and very visible in motion.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `measure_scope` | element box × element window | — | Not the frame, not the shot, not a representative sample. |
| `sample_method` | extremes | extremes | Brightest and darkest frames inside the crop. Uniform sampling misses the tail. |
| `floor_text` | 4.5:1 | ≥4.5:1 | WCAG 1.4.3. Do **not** take the 3:1 large-text allowance: it assumes a static page and self-paced reading. |
| `floor_mark` | 3:1 | ≥3:1 | WCAG 1.4.11 non-text contrast, for the parts needed to understand the object. |
| `floor_hairline_over_footage` | 3:1 | ≥3:1 | A hairline has a *ceiling* on `--ground` and a *floor* over footage — so it becomes a different colour when it crosses. |
| `design_margin` | ×1.5 | ×1.3–1.8 | **Craft judgement, not research.** Target 6.75:1 for text if 4.5:1 must survive H.264 at social bitrates: deblocking softens edges and chroma subsampling shifts saturated accents. Verify on an encoded file, not on a PNG. |
| `frames_checked` | entrance + 3 held + exit | ≥5 | Plus the two extremes found by the luminance dump. |
| `flicker_tolerance` | ±1.5:1 across the window | ≤±2:1 | A ratio that swings more than this reads as flicker even when the minimum passes. |
| `strategy` | own the pixels | pixels / luminance / placement | Ladder in [[gfx-plate-and-scrim-ladder]]. Placement requires proof. |
| `weight_as_fix` | forbidden | — | Fills counters, does nothing at the failing frames. |
| `offset_shadow_as_fix` | forbidden | — | Defends one side of each glyph. |
| `stacked_backings` | 1 | 1 | One backing. A box-shadow on the *box* for separation from the picture is not a second backing. |
| `audit_trust` | none over footage | — | `check`'s contrast audit reads the declared CSS background. Over `transparent` it is meaningless. |
| `sample_count_read` | required | — | `0 sample(s)` / `0/0 text checks` means a lint error disabled the audit. |
| `scrim_covers_element` | element box + 1.5 % frame height | ≥ element box | The backing must be larger than what it backs, including during travel. |
| `recheck_trigger` | new footage / new grade / moved element | — | The result is only valid for the pair it was measured on. |

## Reproduction prompt

```
Verify and fix contrast for every graphic element in {{PROJECT}} that sits over
footage rather than over the flat ground.

1. BUILD THE OCCUPANCY LIST from design-motion.md: for every non-caption graphic
   element, record its id, its bounding box as percentages of frame width and
   height INCLUDING its entrance and exit travel, and its [start, end) in
   seconds. An element that moves has a box equal to the union of its poses.

2. FOR EACH ELEMENT, dump the luminance of ITS box over ITS window:
     ffmpeg -ss <start> -t <dur> -i <video> \
       -vf "crop=iw*<w>:ih*<h>:iw*<x>:ih*<y>" -an band.mp4
     ffmpeg -i band.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG" \
       -f null - 2> yavg.txt
   Find the brightest and the darkest frame. Those two frames decide the design.
   Do NOT sample uniformly and do NOT use a frame somebody chose as typical.

3. COMPUTE THE REAL RATIO AT BOTH EXTREMES, separately for text and for marks:
     text   >= 4.5:1   (do not claim the 3:1 large-text allowance - it assumes a
                        static page, not motion)
     marks  >= 3:1     (WCAG 1.4.11: bar edges, connectors, icon strokes, node
                        borders - the parts needed to understand the object)
   Add a 1.5x design margin if the deliverable is encoded for a feed: deblocking
   softens edges and chroma subsampling shifts saturated accents. Verify on the
   ENCODED file, not on a PNG.

4. PICK A STRATEGY per element, in this order, and pick exactly one:
     (a) OWN THE PIXELS  - opaque plate or full-frame card. Guarantees a floor at
         every frame because video is never visible behind the object.
     (b) OWN THE LUMINANCE - a scrim over the element's box + 1.5% of frame
         height of overhang, pulling the background into a known band.
     (c) OWN THE PLACEMENT - move the element to a region where the YAVG range
         across the window is under 25. This one is free and it is the only one
         that can fail because a shot changed, so it must be re-proved after any
         footage change.
   NOT on the list: more weight, an offset drop shadow, or two backings stacked.

5. CHECK FLICKER, not just the minimum. If the measured ratio swings by more
   than +/-1.5:1 across the element's life, the element reads as flickering even
   where it never drops below the floor. Fix it by raising the strategy one rung.

6. STATE HONESTLY, per element, whether the floor is GUARANTEED or LIKELY. Only
   (a) is a guarantee. If it is a probability, name the fallback for the frames
   where it fails - a conditional plate on named cues, a reposition, a scrim
   extension. "It'll probably be fine" is not a fallback.

ACCEPTANCE TEST:
(a) for every element, both extreme frames clear their floor (4.5:1 text, 3:1
    marks), measured on the encoded deliverable;
(b) the entrance frame and the exit frame are among the frames checked;
(c) inspect the counters of e, a, o at 200% on the worst frame - open passes;
(d) `hyperframes check` reports a NON-ZERO sample count and a non-zero text-check
    count; 0 samples or 0/0 text checks means a lint error disabled the audit and
    the result is meaningless;
(e) each element has exactly one backing, and the backing's box is larger than
    the element's box including travel.
```

## Execution spec

**HyperFrames.** The scrim is a sibling element painted directly beneath its own object, in the scrim z-band, and it is sized from the object's box rather than from the frame:

```html
<div id="stack" class="clip" data-start="12" data-duration="4.5" data-track-index="2"
     style="position:absolute; inset:0;">
  <!-- the backing. Same box as the label, plus overhang. z-band 10. -->
  <div class="scrim" style="position:absolute; z-index:10;
       left:4.5%; top:28.5%; width:91%; height:45%;
       background:linear-gradient(to top, rgba(16,34,43,.78), rgba(16,34,43,0));"></div>
  <!-- the object. z-band 40. -->
  <div id="lbl" class="t-label" style="position:absolute; z-index:40;
       left:6%; top:30%; width:88%;">METAL HIT</div>
</div>
```

```js
// entrance and exit both land INSIDE the clip window; the scrim leads the label
// by 2 frames so the label is never visible against raw footage.
tl.fromTo(["#stack .scrim", "#lbl"],
  { autoAlpha: 0 },
  { autoAlpha: 1, duration: 0.40, ease: "power3.out",
    stagger: { each: 0.07, from: "start" } }, 12.15);
```

Contract points:

- **Layering is CSS `z-index`, not `data-track-index`** — *"It is not read by the render, and it constrains nothing."* Use the z-bands from [[motion-overlay-stack-choreography]]: scrim 10, cards 20, labels 40, annotation 60, captions 80.
- **The scrim leads its object.** If the object fades in first, there are frames of raw-footage background. Stagger the pair with the scrim first, 2–3 frames ahead.
- **Gradients:** never the `transparent` keyword — use the target colour at zero alpha, exactly as above. No stop below `0.15` opacity, no gradient on an element thinner than 4 px. Mandatory if the project uses shader transitions.
- **`backdrop-filter` blur is fragile here and the reason is specific.** An element with `opacity < 1` **is a backdrop root**, so any element whose opacity is being animated has nothing to blur until opacity reaches exactly 1 — the blur pops in. To use blur-behind, split the elements: animate `autoAlpha` on an outer wrapper and put `backdrop-filter` on an inner box that never leaves opacity 1. Blur also removes *detail*, not *luminance*: a blurred white sky is still white, so a blur is never the contrast mechanism on its own.
- **`autoAlpha`, never `display`/`visibility`, and never on the clip element** — the framework owns clip visibility and lint rejects tweening it.
- **`fromTo`, never `from`** — `from()` sets `immediateRender: true` and writes its start state at construction, before the clip's `data-start`, which flashes under non-linear seek.
- **Land the last tween before `data-duration`**; the visibility window is half-open and the frame at exactly `start + duration` is never rendered.
- **`data-layout-allow-overflow` is the wrong escape hatch here.** Its blast radius inherits down the whole subtree and also suppresses `text-clipping`, `content-cramped-container` and `foreground-over-panel`. For an intentional lower-third in the caption band use the narrow `data-layout-allow-caption-zone`.
- **The browser-backed audits, `snapshot`, `preview` and `render` do not run on the authoring VM** (linux ARM64, no sudo, no Chrome). Author here; measure on the render host. Every acceptance test in this note is a render-host test.

**ffmpeg — the whole measurement leg**, and it is the part that actually decides the design. The commands are in the recognition section; two more that matter:

```bash
# does the treatment survive the ENCODE? Measure on the deliverable, not the PNG.
ffmpeg -i out.mp4 -ss 14.2 -frames:v 1 -q:v 2 /tmp/c/encoded_worst.png
# darkening a region without a gradient (baked deliverables only)
ffmpeg -i base.mp4 -filter_complex \
 "drawbox=x=iw*0.045:y=ih*0.285:w=iw*0.91:h=ih*0.45:color=0x10222b@0.62:t=fill" out.mp4
```

**Remotion.** The same scrim-under-object structure in `<AbsoluteFill>`s with explicit `zIndex`; the measurement leg is identical because it is an ffmpeg problem, not a framework problem.

## Pairs with
[[gfx-plate-and-scrim-ladder]] · [[gfx-palette-ground-ink-accent]] · [[gfx-label-callout-over-footage]] · [[gfx-annotation-mark-set]] · [[motion-overlay-stack-choreography]] · [[sub-legibility-backing-ladder]] · [[sub-caption-contrast-accessibility]] · [[motion-spotlight-mask-reveal]] · [[motion-subject-glow-separation]] · [[motion-image-focal-point-direction]] · [[gfx-weight-and-optical-size]]

## Failure modes
- **Designing on a representative frame.** Every video has a worst frame and it is never the one you looked at.
- **Measuring the frame instead of the element's box.** A bright sky in the top third is irrelevant to a label in the bottom third, and a bright UI panel exactly under the label is invisible in a whole-frame average.
- **Measuring the held state only.** The entrance travels; the travel crosses regions the held pose never touches.
- **Reading `0/0 text checks` as a pass.** It means a lint error disabled the audit.
- **Trusting the contrast audit over footage.** It compares text to its declared CSS background. Over `transparent` it has nothing to compare and it passes.
- **Treating a scrim as a guarantee.** It is — but only inside the scrim's box. An object one pixel wider than its backing has an unbacked edge, which is where the eye goes.
- **Treating blur as contrast.** Blur removes spatial detail; luminance is untouched.
- **`backdrop-filter` on the element whose opacity is animated.** The element is its own backdrop root; the blur silently does nothing until the fade finishes, then pops.
- **Fixing it with weight.** Fills the counters, buys almost nothing at the failing frames.
- **Fixing it with an offset drop shadow.** Defends one side of each glyph.
- **Stacking a plate, a stroke and a shadow.** The stroke sits between the ink and the plate and *lowers* the measured ratio.
- **Forgetting that marks have a different floor.** A diagram whose text passes at 5:1 and whose connectors sit at 2:1 keeps its labels and loses its structure — which is the half of the diagram that was doing the work.
- **Verifying on a PNG.** The encode is where the margin is spent. Measure the deliverable.
- **Known gap:** there is no automatic content-aware placement in this stack — no face tracking, no saliency map, and pan/Ken Burns is *"authored geometry, not automatic face tracking."* An element cannot be auto-placed into the quiet part of a shot; the quiet regions have to be found by the analysis pass and written down.
