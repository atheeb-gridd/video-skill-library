---
id: motion-annotation-draw-on
title: Circles, arrows and underlines — the draw-on annotation spec
skill: motion
type: graphic
family: annotation
tags: [skill/motion, type/graphic, family/annotation, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:11"
    quote: "Circles, arrows and underlines work too."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "visual — contact sheet, B-roll segments"
    quote: "[NOT SPOKEN — observed on screen] Hand-drawn white curved arrows annotating B-roll, with a caps label — RECORDING B-ROLL."
research_refs:
  - https://gsap.com/docs/v3/Plugins/DrawSVGPlugin/
  - https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-dasharray
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://tech.ebu.ch/docs/r/r095.pdf
  - https://gsap.com/docs/v3/Eases
difficulty: medium
detectable_from: video
---

# Circles, arrows and underlines — the draw-on annotation spec

## What it is
The most literal focal-point method in the creator's list of six: a stroked mark drawn on top of the image that names what to look at. Three shapes, one mechanism — an SVG path whose stroke is revealed progressively from 0% to 100% of its length, timed so the reveal completes as the word it illustrates finishes. The circle encloses, the arrow points, the underline scores a line of text. All three are stroke-only (never filled), all three animate `stroke-dashoffset` (or GSAP's `drawSVG` wrapper over the same two properties), and all three live in the annotation z-band above cards and labels but below captions.

Their whole value is that they are unambiguous. Their whole risk is that they are cheap: an annotation that appears without being drawn, or that sits on screen for eight seconds, reads as a stock-template overlay rather than an editorial pointer.

### The hand-drawn arrow over B-roll, with a caps label
`editing kt` (Creator B) runs a variant worth naming separately, because its register is different: a **white, hand-drawn curved arrow** swept over live B-roll, paired with a short **all-caps label** — `RECORDING B-ROLL`. Three things distinguish it from the clean geometric annotation above.

- **The stroke is imperfect on purpose.** A slightly wobbly, variable-width curve reads as *someone marking up the footage*, where a perfect Bézier reads as a template. Build it from a hand-drawn path (traced, or a path with deliberate control-point irregularity), not from a circle primitive.
- **It carries a label, not a caption.** Two or three words, all caps, set beside the arrow's tail — it names the thing the arrow points at rather than transcribing speech, so it sits in the annotation band and obeys the annotation dwell, not the caption rules ([[sub-emphasis-caption-three-words]]).
- **It lands on live footage rather than a still.** The arrow must be re-checked against motion: a target that moves out from under a static arrow is worse than no annotation. Either the shot is locked for the arrow's life, or the arrow's tip is keyframed to follow — and if it has to follow, the annotation is probably the wrong tool ([[motion-key-region-animate-in]]).

Numbers that differ from the geometric case: **draw time 0.35–0.5 s** (a hand-drawn stroke that snaps on in 0.2 s looks mechanical), **label arrives on the arrow's completion frame**, not with it, **total dwell 1.5–2.5 s**, and stroke width **6–10 px @1080p** — thicker than a clean pointer, because an irregular stroke loses apparent weight. Keep the white-on-footage contrast honest: an arrow over a bright sky needs a soft drop shadow rather than a heavier stroke.

This is also the positive half of Creator B's annotation grammar. The negative half — **red strike-through and red overlay as negation** — is a caption rule and belongs to the subtitles library; the two share a colour logic, so if red means "rejected" anywhere in a video, a red annotation arrow will read as a rejection too. Use white for pointing, red only for negation.

## When to use it
- **A screenshot, chart, UI or document is on screen and one region matters.** The strongest use — pair with a punch-in ([[cut-punch-in-emphasis]]) or with darkening/blurring the surround ([[motion-image-focal-point-direction]]).
- **The speaker says "this", "here", "that number", "the third one"** and the referent is ambiguous without a mark.
- **One line of on-screen text out of several is the operative one** — underline.
- **A relationship must be shown**: this element causes that one — arrow.
- **Not** as decoration on A-roll, not on an image with a single obvious subject (the punch-in already did the job), and not when the surround treatment alone (darken/blur) already isolates the focal point — doubling reads as insecurity.

## How to recognise it in a reference video
- **The mark is drawn, not cut on.** Step frames: the stroke grows from one end over **6–15 frames**. A mark that appears whole in one frame is a different (weaker) device — log it as `instant-annotation` and check whether a sound covers it ([[motion-instant-appearance-sfx-justified]]).
- **Stroke weight scales with the frame, not with the image.** Measure as a percentage of frame height: **0.35–0.7%** (4–8 px at 1080p, 6–12 px at 4K). A hairline under 3 px at 1080p will not survive compression.
- **The path is imperfect.** Hand-drawn-style annotation shows a non-circular ellipse, an overshooting circle whose ends cross by 5–15% of the path, or a slightly wavering line. Perfect geometric circles read as software UI, not annotation.
- **One accent colour, reused.** Look for the same colour on every annotation in the video — typically a saturated yellow, red or brand accent. Two annotation colours in one video usually means a template.
- **Look for a contrast carrier.** Over arbitrary imagery, competent marks carry a dark outer stroke or a drop shadow (2–4 px) so they survive both bright and dark backgrounds; WCAG's 3:1 for graphical objects is the floor.
- **Hold then leave.** Typical: draw 0.2–0.5 s, hold **0.8–2.5 s**, then either the shot cuts or the mark fades in 0.15–0.25 s. A mark held longer than ~3 s without the shot changing is a fault.
- **Arrows are two-part.** Shaft draws, head arrives **1–3 frames after** the shaft completes, often with a small scale pop (1.0 → 1.15 → 1.0).
- **Audio:** a short pen/marker/whoosh sound at the draw's start, or a soft tick at completion, **−12 to −15 dB**. Absence over an otherwise sounded edit is a hole.
- **Transcript alignment:** the draw usually **starts 2–4 frames before** the operative word and completes on or just after it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `stroke_width` | 6 px @1080p (0.55% h) | 4–8 px (0.35–0.7% h) | Author in viewBox units so it scales with the frame. |
| `draw_duration_circle` | 0.40 s (12 f) | 0.27–0.50 s | Longer path, longer draw. |
| `draw_duration_arrow_shaft` | 0.28 s (8 f) | 0.20–0.40 s | |
| `arrow_head_delay` | 0.06 s (2 f) | 0.03–0.10 s | After shaft completes. |
| `arrow_head_pop` | 1.15 → 1.0 | 1.08–1.25 | 0.15 s, `back.out(1.7)` is licensed here — this is the playful register the house style otherwise reserves. |
| `draw_duration_underline` | 0.22 s (7 f) | 0.15–0.30 s | Always left-to-right for LTR text. |
| `draw_ease` | `power2.out` | `power1.out`–`power3.out` | A pen decelerates. `none` reads mechanical; `expo.out` reads snapped. |
| `overshoot_cross` | 8% of path | 0–15% | Circle ends crossing past the start — the hand-drawn tell. |
| `hold_duration` | 1.4 s | 0.8–2.5 s | From draw completion to exit or cut. |
| `exit_duration` | 0.20 s (6 f) | 0.15–0.30 s | `autoAlpha` only; do not un-draw unless the erase is the point. |
| `colour` | one accent | — | Same accent for every annotation in the video. |
| `contrast_ratio` | 3:1 | ≥3:1 | WCAG 1.4.11, against the darkest and lightest pixels under the mark. |
| `carrier_shadow` | 3 px @ 45% | 2–4 px | Dark drop shadow or 1 px outer stroke, for arbitrary imagery. |
| `lead_before_word` | 0.10 s (3 f) | 0.05–0.15 s | Draw starts before the operative word. |
| `safe_inset` | 5% | 3.5–5% | EBU R95; the mark's bounding box, including overshoot. |
| `max_concurrent` | 1 | 1–2 | Two marks at once only for an explicit A→B relationship. |

## Reproduction prompt

```
Draw an annotation over the image at {{IN}} that names {{TARGET_REGION}}.

SHAPE. Circle for a region, arrow for a relationship, underline for one line of
text. Author it as an inline SVG path in the composition's own viewBox - not a
raster asset - stroke only, no fill, stroke-width 6 at 1080p (0.55% of frame
height), round caps and joins, single accent colour, plus a 3px dark drop
shadow so it survives both bright and dark footage. For a circle, make the
path a deliberately imperfect ellipse whose end crosses the start by about 8%
of its length. Keep the whole bounding box, including overshoot, inside a 5%
inset from every edge.

DRAW. Reveal the stroke from 0% to 100% of its length by animating
stroke-dashoffset from the measured path length to 0 (set stroke-dasharray to
the same length), or drawSVG "0%" -> "100%" if the plugin is available.
Duration: 0.40s circle, 0.28s arrow shaft, 0.22s underline. Ease power2.out.
Start the draw at {{IN}} = the operative word's start minus 0.10s.

ARROW ONLY. Hold the head at scale 0 until the shaft completes, then pop it
1.15 -> 1.0 over 0.15s with back.out(1.7), starting 0.06s after shaft end.

HOLD AND CLEAR. Hold 1.4s after completion. Then either let the cut clear it,
or fade autoAlpha to 0 over 0.20s, landing at least 2 frames before the clip's
data-duration. Do not un-draw.

SOUND. One short marker/whoosh at the draw start, -12 to -15 dB, its transient
on the draw's first frame.

ACCEPTANCE TEST: step {{IN}}-2f .. {{IN}}+15f - the stroke must grow, never
appear whole; the mark must be legible over the brightest and darkest frame in
the hold window; and the draw must complete no later than 4 frames after the
operative word ends.
```

## Execution spec

**HyperFrames.** Inline SVG inside the composition; the draw is a GSAP tween on the timeline like any other motion. Two routes — the plugin, and the plugin-free one that always works:

```html
<div id="annot" class="clip" data-start="14" data-duration="3.2" data-track-index="3"
     style="position:absolute; inset:0; z-index:60;">
  <svg viewBox="0 0 1920 1080" style="position:absolute; inset:0; width:100%; height:100%;">
    <defs><filter id="a-sh"><feDropShadow dx="0" dy="2" stdDeviation="2" flood-opacity="0.45"/></filter></defs>
    <path id="annot-circle" filter="url(#a-sh)" fill="none" stroke="#FFD400"
          stroke-width="6" stroke-linecap="round"
          d="M980,300 C1240,286 1372,392 1354,506 C1336,626 1150,690 1000,668 C860,648 760,560 786,452 C808,360 900,306 1010,298"/>
  </svg>
</div>
```

```js
// plugin-free draw-on: dasharray = path length, dashoffset length -> 0
const p = document.querySelector("#annot-circle");
const L = p.getTotalLength();                       // measured once at setup, not at tween time
gsap.set(p, { strokeDasharray: L, strokeDashoffset: L });
tl.to(p, { strokeDashoffset: 0, duration: 0.40, ease: "power2.out" }, 14.0);
// with the plugin instead:
// tl.fromTo(p, { drawSVG: "0%" }, { drawSVG: "100%", duration: 0.40, ease: "power2.out" }, 14.0);
tl.to("#annot", { autoAlpha: 0, duration: 0.20 }, 16.9);   // ends before data-duration (17.2)
```

Contract points that bind this:
- `getTotalLength()` is measured **once at composition setup**, never inside a tween — the contract bans deriving positions at tween time; in a multi-scene montage prefer an authored constant over any measurement, because later clips may not be laid out yet.
- `stroke-dashoffset` / `stroke-dasharray` are ordinary animatable properties; this is not a transform, so it does not trip `gsap_css_transform_conflict`. The **arrow head's scale pop is** a transform — give the head its own element and never also set a CSS `transform` on it.
- `back.out(1.7)` is the house's rare playful register; one pop on an arrowhead is inside budget, a video full of them is not.
- Do not tween `display`/`visibility`; `autoAlpha` on the inner SVG or a non-clip wrapper.
- The mark's clip must land its final state **before** `data-start + data-duration` (half-open window).
- Deterministic only: no `Math.random()` wobble unless seeded, no `repeat: -1` on a pulsing mark — use a finite count.
- Named rules citable here: `svg-path-draw`, `svg-icon-enrichment`, `ai-tracking-box`.
- Hand-drawn "boil": swap between 2–3 pre-authored path variants on a `steps(3)` ease or a small set of `tl.set()` calls at 8–12 fps — it must be timeline-driven, never a CSS animation with its own clock.

**ffmpeg.** Only when the annotation must be baked into a delivered file (no draw-on; static mark with a hard in/out):

```bash
ffmpeg -i in.mp4 -i annot.png -filter_complex \
 "[0:v][1:v]overlay=0:0:enable='between(t,14,17.2)'" -c:a copy out.mp4
```
For a real draw-on outside HyperFrames, render the SVG animation to a transparent-background sequence and overlay that instead.

**Epidemic Sound.** `SearchSoundEffects { query: { term: "marker pen draw whoosh short" }, filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--whoosh"] }, duration: { max: 1500 } } }` — place with the transient on the draw's first frame ([[motion-impact-frame-quantisation]]).

**Remotion:** the same dashoffset interpolation driven by `useCurrentFrame()` — concept only.

## Pairs with
[[motion-image-focal-point-direction]] · [[motion-overlay-stack-choreography]] · [[cut-punch-in-emphasis]] · [[motion-colour-shift-connotation]] · [[motion-attention-transient]] · [[sfx-air-on-micro-movement]] · [[motion-instant-appearance-sfx-justified]] · [[cut-screen-recording-proof-insert]] · [[struct-analytics-screenshot-proof]] · [[motion-filmstrip-comparison-strip]] · [[motion-timeline-overlay-explainer]]

## Failure modes
- **Perfect geometry.** A mathematically exact circle reads as a UI element and kills the "someone is pointing at this" effect. Correction: an imperfect ellipse with 5–15% end overshoot.
- **Hairline stroke.** Under ~3 px at 1080p the mark half-disappears after platform compression. Correction: 0.35–0.7% of frame height, plus a shadow.
- **No contrast carrier.** A yellow circle over a bright wall vanishes. Correction: dark drop shadow or outer stroke; verify 3:1 against the extremes.
- **Annotation without a punch-in.** Marking a region of a full-frame screenshot that is already too small to read does not make it readable. Correction: scale to the region first, then annotate.
- **Held too long.** A mark still on screen 4 s after its word has passed becomes furniture. Correction: hold ≤2.5 s, or cut.
- **Un-drawing on exit.** Reverse-drawing reads as an undo and costs 8+ frames of attention for nothing. Correction: fade.
- **Multiple accent colours.** Correction: one annotation colour per video, declared in the project profile.
- **Measuring path length at tween time.** In a multi-scene composition the element may not be laid out yet and the draw silently starts from 0 (no reveal). Correction: measure at setup, or hard-code the length.
