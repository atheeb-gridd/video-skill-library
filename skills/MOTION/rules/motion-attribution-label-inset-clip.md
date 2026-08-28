---
id: motion-attribution-label-inset-clip
title: The attribution label — small italic serif, top-left, over a letterboxed inset clip
skill: motion
type: graphic
family: teaching-visual
tags: [skill/motion, type/graphic, family/teaching-visual, layer/design, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, every film clip"
    quote: "[NOT SPOKEN — observed on screen] Every film clip labelled top-left in small italic serif: The Departed, Forrest Gump, The Wolf of Wall Street, The Shawshank Redemption, Reacher. Clips are letterboxed and inset on a dark ground rather than filling frame."
research_refs:
  - https://legibility.info/rules-for-text-in-videos
  - https://en.wikipedia.org/wiki/Fair_use
  - https://www.w3.org/TR/WCAG21/#contrast-minimum
  - https://en.wikipedia.org/wiki/Letterboxing_(filming)
  - _meta/visual-kt-delta.md
difficulty: low
detectable_from: video
---

# The attribution label — small italic serif, top-left, over a letterboxed inset clip

## What it is
Every borrowed film clip in `editing kt 2` carries the same three things: it is **letterboxed and inset on a dark ground** rather than filling the frame, it is **labelled top-left in a small italic serif** with the title (*The Departed*, *Forrest Gump*, *The Wolf of Wall Street*, *The Shawshank Redemption*, *Reacher*), and the label is present for the **whole** of the clip rather than flashed at its start.

Three separate jobs are being done by one convention, which is why it is worth codifying rather than improvising per clip:

1. **Attribution.** The source of borrowed material is named on screen. That is a courtesy, a credibility signal, and — depending on jurisdiction and use — part of a fair-dealing or fair-use posture. It does not by itself make an unlicensed use lawful, and this note makes no legal claim; it describes a convention that any serious commentary channel follows ([[sfx-source-licensing-and-clearance]] is the audio-side gate).
2. **Framing as evidence.** An inset, letterboxed clip on a dark ground reads as *quoted*: it is visibly not the presenter's own footage. A full-frame clip reads as the video's own material, which is both a credibility problem and a comprehension one.
3. **Orientation.** The viewer knows immediately which film they are looking at, which is the entire mechanism behind anchoring an abstract term to something the audience already remembers ([[struct-recognisable-clip-evidence]]).

The **italic serif** does real work too: it is the typographic convention for a *title of a work*, and it is deliberately different from every other type in the video, so the eye files it as metadata rather than as content. It should never be the same face as the video's own title cards ([[motion-type-treatment-matches-content]]).

## When to use it
- **On every borrowed clip, without exception** — film, TV, another creator's video, a game, a commercial.
- **On stock footage** where the piece's credibility depends on the viewer knowing it is stock rather than shot ([[cut-stock-footage-substitute]]).
- **On screen recordings of third-party products**, where the label names the product rather than a film.
- **Under a timeline overlay**, as one composed layout: label top-left, clip inset, band across the bottom ([[motion-timeline-overlay-explainer]]).
- **Not on the creator's own footage.** Labelling everything makes the convention meaningless.
- **Not as a lower third.** This is metadata, not a name key; it belongs at the top-left of the inset, small, and it does not animate.

## How to recognise it in a reference video
- **The label is present for the clip's full duration**, not just the first second — a flashed label is a caption, a persistent one is a convention.
- **It sits top-left of the inset**, not of the frame, and it moves with the inset if the inset moves.
- **It is small** — roughly a third to a half of caption size — and low-contrast enough not to compete with the picture, but still legible at 4.5:1.
- **Italic serif, and nothing else in the video uses that face.** That exclusivity is the tell.
- **The clip is letterboxed and inset** on the video's standing ground colour, with a consistent margin across every example.
- **Every borrowed clip has one.** One unlabelled clip in a labelled video is the exception that proves the creator improvises.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `inset_width` | 84% of frame width | 75–92% | Enough margin that the ground reads as a mount, not as a rendering error. |
| `inset_ground` | the video's standing dark ground | — | Same value as the concept cards ([[motion-abstract-concept-card]]). |
| `inset_radius` | 8 px @1080p | 0–16 px | Optional; keep consistent. |
| `letterbox` | preserve source aspect | — | Never crop a quoted clip to fill; the framing is part of what is quoted. |
| `label_position` | top-left of the inset | — | 24–32 px in from the inset's own edges. |
| `label_px` | 34 px @1080p | 28–44 px | About 0.4× title size. Small on purpose. |
| `label_face` | italic serif | — | Reserved: used for attribution and nothing else. |
| `label_opacity` | 0.8 | 0.7–1.0 | Still ≥4.5:1 against whatever is behind it. |
| `label_scrim` | 40% black, 2 px blur | 0–60% | Only if the clip's top-left is bright; a scrim beats raising opacity. |
| `label_persistence` | full clip duration | — | Never flash-and-fade. |
| `label_entry` | fade 0.25 s | 0.2–0.35 s | With the inset, not after it. No slide, no scale. |
| `title_format` | *Title* only | — | Year and director optional; keep to one line ≤30 characters. |

## Reproduction prompt

```
Place borrowed clip {{CLIP}} from {{WORK}} with the attribution convention.

1. INSET AND LETTERBOX: scale the clip to 84% of frame width, preserve its
   own aspect, centre it on the standing dark ground. Do not crop to fill.
2. LABEL top-left of the INSET (not of the frame), 24 px in from its edges,
   italic serif, 34 px, opacity 0.8. Text is the work's title, one line.
3. IF THE CLIP'S TOP-LEFT IS BRIGHT, add a soft 40% black scrim behind the
   label rather than increasing its opacity or size.
4. FADE the label in with the inset over 0.25 s and hold it for the ENTIRE
   clip. It does not animate again.
5. REPEAT IDENTICALLY for every borrowed clip in the video - same position,
   size, face and opacity. Any variation reads as an accident.
6. CHECK CLEARANCE separately. The label is attribution, not a licence.

ACCEPTANCE TEST: freeze on any borrowed clip. A viewer can name the source
without the voiceover, and can tell at a glance that this footage is quoted
rather than shot by the presenter.
```

## Execution spec

**HyperFrames — inset, ground, label.** The picture is a muted `<video>` with a separate `<audio>`, per the project's key rule; the label is a sibling div inside the same clip wrapper so it inherits the clip's visibility window.

```html
<div class="clip" id="ex-departed" data-start="72.00" data-duration="9.00" data-track-index="2">
  <div class="inset">
    <video id="ex-departed-pic" src="assets/clips/departed.mp4" muted></video>
    <span class="attrib" id="ex-departed-lbl">The Departed</span>
  </div>
</div>
<audio id="ex-departed-aud" src="assets/clips/departed.wav" data-audio-group="sfx"
       data-start="72.00" data-duration="9.00" data-track-index="12" data-volume="0.9"></audio>
```
```js
tl.fromTo(["#ex-departed-lbl"], { autoAlpha: 0 },
  { autoAlpha: 0.8, duration: 0.25, ease: "power2.out" }, 72.0);
```
The rules that apply: `autoAlpha` (never `visibility`/`display`), and never on the clip element itself — the framework owns clip visibility, so a label that must persist for the clip's life simply lives inside the wrapper and needs no exit tween. **`fromTo`, never `from`.** A `<video>` must not be nested in a *timed* element (`video_nested_in_timed_element`); the plain inset wrapper above is fine. Every `<audio>` needs an `id` or the render is silent. Fonts must be vendored locally — an italic serif pulled from a font CDN will not resolve, and the fallback face silently destroys the convention.

**Scaling the inset.** Size the inset in CSS (a static `width`/`aspect-ratio`), not with a GSAP `width` tween — layout properties are not tweenable in this stack. If the inset must move or scale during the clip, use `scale`/`x`/`y` on the wrapper, and remember the **label scales with it**: for a label that must stay at a fixed size, put it outside the scaled element and position it over the inset's known coordinates.

**ffmpeg — preparing the clip.** Letterbox rather than crop, and keep the source aspect:
```bash
# fit a 2.39:1 clip into a 16:9 inset without cropping
ffmpeg -i departed.mp4 -vf "scale=1612:-2,pad=1612:906:(ow-iw)/2:(oh-ih)/2:black" -c:a copy inset.mp4
# split the audio out, per the muted-video convention
ffmpeg -i inset.mp4 -vn -acodec pcm_s16le departed.wav
```

**Remotion.** An `<AbsoluteFill>` with the video inset and an absolutely-positioned label; identical structure.

## Pairs with
[[motion-timeline-overlay-explainer]] · [[motion-filmstrip-comparison-strip]] · [[motion-type-treatment-matches-content]] · [[motion-abstract-concept-card]] · [[motion-overlay-stack-choreography]] · [[struct-recognisable-clip-evidence]] · [[struct-credibility-anchor]] · [[cut-stock-footage-substitute]] · [[sfx-source-licensing-and-clearance]] · [[sfx-demo-clip-loudness-handover]]

## Failure modes
- **Flashing the label and removing it.** A viewer joining mid-clip has no idea what they are watching. Persist it.
- **Labelling only some clips.** The convention only means anything if it is exhaustive.
- **A label as big as a caption.** It competes with the picture and reads as content rather than metadata.
- **The video's own title face.** Destroys the "this is metadata" signal; keep the italic serif exclusive.
- **Cropping the clip to fill frame.** Changes the composition being quoted — which, in a video about framing and cutting, contradicts the lesson.
- **Label positioned to the frame rather than the inset.** Looks unmoored, and breaks the moment the inset moves.
- **Assuming attribution equals clearance.** It does not. Run the licence question separately.
- **Illegible over a bright shot.** Use a scrim, not more opacity.
- **Known gap:** the reference's exact type size, opacity and margins are not measurable from a contact sheet — the *convention* (small, italic serif, top-left, persistent, inset clip) is observed; the numbers here are this library's defaults.
