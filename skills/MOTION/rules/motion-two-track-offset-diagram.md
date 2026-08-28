---
id: motion-two-track-offset-diagram
title: The two-track offset diagram — teach a J or L cut as a stagger between two bars
skill: motion
type: graphic
family: teaching-visual
tags: [skill/motion, type/graphic, family/teaching-visual, family/audio-led, layer/design, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, J Cut and L Cut segments"
    quote: "[NOT SPOKEN — observed on screen] J Cut and L Cut are taught with a two-track offset diagram: a green picture bar and a blue audio bar visibly staggered, waveform showing."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, title cards"
    quote: "[NOT SPOKEN — observed on screen] Title cards 'J Cut', 'L Cut', 'IN POINT' in clean type, over letterboxed film clips attributed top-left."
research_refs:
  - https://en.wikipedia.org/wiki/Split_edit
  - https://en.wikipedia.org/wiki/Dual-coding_theory
  - https://ffmpeg.org/ffmpeg-filters.html#showwavespic
  - https://legibility.info/rules-for-text-in-videos
  - _meta/visual-kt-delta.md
difficulty: medium
detectable_from: video
---

# The two-track offset diagram — teach a J or L cut as a stagger between two bars

## What it is
A J cut and an L cut are the same object seen from two sides: **the audio and the picture do not change on the same frame**. Every verbal formulation of that is clumsy — "the sound of the next scene comes in before you see it" takes a sentence and still leaves the viewer assembling a mental model. The reference solves it with one static graphic: **a green picture bar and a blue audio bar, staggered, with the waveform visible in the audio bar.** The shape of the letter is the shape of the diagram, and the name stops being arbitrary.

The diagram also settles a modelling question that matters downstream: the offset is presented as a **track-level relationship**, not as a transition effect. There is no dissolve, no wipe, no named transition anywhere in it — just two clips whose in-points differ. That is exactly how it must be built in this stack, where audio and picture are separate elements with their own `data-start`, and where the transition registry is **picture-only and does not touch audio at all**.

It is the reduced, static sibling of [[motion-timeline-overlay-explainer]]: the overlay runs live under a real clip, the offset diagram is a still schematic that can be held, labelled and pointed at. Use the diagram to **define**, the overlay to **demonstrate** — which is the same name-define-demonstrate order the reference set uses throughout ([[struct-name-define-demonstrate]]), and the pair of cuts is the canonical case for teaching two mirror-image techniques together ([[struct-inverse-pair-teaching]]).

## When to use it
- **Teaching J cuts, L cuts or any split edit** ([[cut-j-audio-leads-picture]], [[cut-l-audio-trails-picture]], [[cut-split-edit-attention-steering]]).
- **Teaching any track-offset relationship**: an SFX leading a graphic, a music downbeat landing before a section's first frame, an ambience bed bridging a cut ([[sfx-split-edit-lead-lag]], [[sfx-ambience-bridge-across-cut]]).
- **As the definition card before a real example.** Diagram first, clip second — the abstraction is cheap to hold once the shape is in the viewer's head.
- **When the size of the offset is the lesson.** A labelled stagger states "about a second" in a way a sentence cannot.
- **Not for anything that happens on a single frame.** A hard cut has no offset to draw ([[cut-straight-hard-cut]]).
- **Not with three or more tracks.** The letter-shape reading collapses; use the full timeline overlay instead.

## How to recognise it in a reference video
- **Two bars, two colours, one stagger.** If the bars are aligned, this is not the technique.
- **The waveform is inside the audio bar**, and it is real — a loud moment in the clip corresponds to a tall region.
- **The overhang direction matches the name being taught.** Audio leading (extending left of the picture's in-point) is a J; audio trailing (extending right past the picture's out-point) is an L. A reference that draws them the same way is teaching one thing twice.
- **A labelled boundary.** `IN POINT`, or a vertical rule at the picture cut, is usually present so the offset has something to be measured against.
- **It is held long enough to be read** — 2.5–6 s, static or with one small build.
- **Then a real clip follows**, usually with the timeline overlay running, so the abstraction is immediately cashed out.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `bar_height` | 88 px @1080p | 64–120 px | Both bars equal; the audio bar may be 1.1× to fit the waveform. |
| `bar_gap` | 24 px | 16–40 px | Vertical gap. Too large and the two bars stop reading as one object. |
| `bar_length` | 60% of frame width | 45–75% | Leaves room for the stagger to be visible at both ends. |
| `offset_draw` | 12% of frame width | 8–18% | The **drawn** stagger. Deliberately larger than a literal 1 s at the diagram's scale — this is a schematic, and it should say so. |
| `offset_taught` | 1.0 s | 0.5–2.0 s | The number in the label. Keep the drawn and taught values consistent across every diagram in one video. |
| `picture_hue` | green | — | Same hue as the timeline overlay in the same video. |
| `audio_hue` | blue/cyan | — | Same as the overlay. Colour grammar is shared or it is not grammar. |
| `boundary_rule` | 2 px, 60% opacity | 1–3 px | Vertical line at the picture cut, full band height. |
| `label_px` | 44 px @1080p | 40–60 px | ≤30 characters per line. |
| `label_dwell` | chars ÷ 13 s | ≥2.3 s | Published minimum reading dwell. |
| `onscreen_len` | 4.0 s (120 f) | 75–180 f | Long enough to read both bars and the label. |
| `build_order` | picture → audio → offset marker | — | Draw the thing that does not move first. |
| `build_stagger` | 0.15 s | 0.1–0.25 s | Between the three build steps. |
| `ease` | `power3.out`, 0.3–0.4 s | — | House settle; no overshoot on a diagram. |

## Reproduction prompt

```
Build a two-track offset diagram defining a {{J|L}} cut, on screen {{IN}} to
{{OUT}} (seconds, 30 fps).

1. SET THE GEOMETRY. Two horizontal bars, centred, 60% of frame width, 88 px
   tall, 24 px apart. Row 1 = picture (green). Row 2 = audio (blue), with a
   real waveform image inside it.
2. SET THE STAGGER. For a J cut, the AUDIO bar starts 12% of frame width to
   the LEFT of the picture bar - the sound arrives first. For an L cut, the
   audio bar EXTENDS 12% to the RIGHT past the picture bar's end - the sound
   stays. Draw only one of the two per card.
3. DRAW THE BOUNDARY: a vertical rule through both rows at the picture cut,
   and a bracket or arrow spanning the stagger, labelled with the taught
   offset ("~1 s").
4. ANIMATE the build: picture bar wipes in (0.35 s, power3.out); audio bar
   0.15 s later; boundary rule and offset label 0.15 s after that. Nothing
   loops, nothing pulses.
5. HOLD static for at least (label characters / 13) seconds.
6. CUT TO A REAL CLIP demonstrating the same cut, with the timeline overlay
   running, so the schematic is cashed out immediately.

ACCEPTANCE TEST: freeze the card and ask someone which arrives first, the
sound or the picture. If they have to read the label to answer, the stagger
is drawn too small.
```

## Execution spec

**HyperFrames — divs and transform tweens only.**
```html
<div class="clip" id="jcut-card" data-start="128.00" data-duration="5.00" data-track-index="2">
  <div class="od-row"><div class="od-bar od-pic" id="od-pic"></div></div>
  <div class="od-row"><div class="od-bar od-aud" id="od-aud"><img src="assets/img/od_wave.png" alt=""></div></div>
  <div id="od-rule"></div>
  <div id="od-label">audio leads by ~1 s</div>
</div>
```
```js
const IN = 128.0;
tl.fromTo("#od-pic", { scaleX: 0, transformOrigin: "left center" },
  { scaleX: 1, duration: 0.35, ease: "power3.out" }, IN);
tl.fromTo("#od-aud", { scaleX: 0, transformOrigin: "left center" },
  { scaleX: 1, duration: 0.35, ease: "power3.out" }, IN + 0.15);
tl.fromTo(["#od-rule", "#od-label"], { autoAlpha: 0, y: 10 },
  { autoAlpha: 1, y: 0, duration: 0.3, ease: "power3.out" }, IN + 0.30);
```
The rules that bite here: **`fromTo`, never `from`**; **transform aliases only** — a bar grows with `scaleX`, never with a `width` tween, and the stagger is authored as CSS `left`/`margin` on the static layout rather than tweened; a CSS `transform` on a GSAP-tweened element raises `gsap_css_transform_conflict`; `autoAlpha` never goes on the clip element itself. Land the last tween before `data-duration`. If the bar is scaled, remember its **text child inherits the scale** — put the label outside the bar, as above.

**The waveform image** comes from ffmpeg and should be rendered from the *actual* clip being taught, not from a stock file:
```bash
ffmpeg -ss 8.0 -t 4.0 -i clip.wav -filter_complex \
  "showwavespic=s=1100x80:colors=0x6ec1ff:scale=sqrt" -frames:v 1 assets/img/od_wave.png
```

**What the diagram means downstream.** Because the offset is a track relationship, the executable form is two `data-start` values, not a transition:
```html
<video id="sc2-pic" src="scene2.mp4" muted data-start="60.00" data-duration="8.00" data-track-index="1"></video>
<audio id="sc2-aud" src="scene2.wav" data-audio-group="dialogue"
       data-start="59.00" data-duration="9.00" data-track-index="10" data-volume="1"></audio>
```
The audio simply starts one second earlier. **The transition registry (`crossfade`, `blur-crossfade`, …) is for picture scenes only and does not touch audio**, so no transition name can express a J cut; and two overlapping `<audio>` on the same track index raise `duplicate_audio_track`, which is why an overlapping handover needs separate indices.

**Remotion.** Two `<Sequence>`s with different `from` values; the diagram itself is ordinary divs.

## Pairs with
[[motion-timeline-overlay-explainer]] · [[motion-waveform-teaching-overlay]] · [[cut-j-audio-leads-picture]] · [[cut-l-audio-trails-picture]] · [[cut-split-edit-attention-steering]] · [[sfx-split-edit-lead-lag]] · [[sfx-j-cut-audio-lead]] · [[sfx-l-cut-audio-trail]] · [[struct-inverse-pair-teaching]] · [[motion-type-treatment-matches-content]]

## Failure modes
- **Drawing J and L identically.** The direction of the overhang *is* the lesson; a mirrored pair drawn the same way teaches nothing twice.
- **A stagger too small to see.** A literal 1 s at the timeline's scale can be 4% of frame width. Draw the schematic larger than life and label the true value.
- **Three tracks.** The letter-shape reading collapses. Two bars, or use the full overlay.
- **Tweening `width` to grow a bar.** Forbidden in this stack; use `scaleX` with `transformOrigin: "left center"`.
- **Labels inside a scaled bar.** The text scales with its parent and lands at the wrong size. Keep labels as siblings.
- **Reaching for a transition to build the real thing.** No transition in the registry touches audio; the cut is two `data-start` values.
- **A card with no clip after it.** The diagram defines; without a demonstration it stays abstract ([[struct-demo-before-label]] is the alternative order, and either is better than definition alone).
- **Colour drift.** If the timeline overlay elsewhere in the video uses blue for picture, this diagram must too.
- **Known gap:** the reference's exact offset value is not readable from a contact sheet — the diagram shows *that* audio leads, not by how much. The 0.5–2.0 s range here comes from the split-edit notes and research, not from the video.
