---
id: motion-abstract-concept-card
title: The abstract concept card — dark ground, script title, one accent, one abstract visual
skill: motion
type: graphic
family: teaching-visual
tags: [skill/motion, type/graphic, family/teaching-visual, layer/design, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/sfx-kt-2, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "visual — contact sheet, concept cards"
    quote: "[NOT SPOKEN — observed on screen] 'The Composition of a Video' — a 50/50 pie chart labelled Sound / Visuals with thin leader lines, on a dark teal/navy ground with a muted cyan accent."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "visual — contact sheet, concept cards"
    quote: "[NOT SPOKEN — observed on screen] 'Music' — a circular arc with diamond nodes at the cardinal points and a waveform drawn inside it. Elsewhere: an isolated waveform in a rounded rectangle; a handwritten/script title 'Instruments' with a small orange sub-label 'Suspense/Tension' beneath."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:24"
    quote: "Sound is half of your video."
research_refs:
  - https://legibility.info/rules-for-text-in-videos
  - https://en.wikipedia.org/wiki/Dual-coding_theory
  - https://en.wikipedia.org/wiki/Contrast_(vision)
  - https://www.w3.org/TR/WCAG21/#contrast-minimum
  - _meta/visual-kt-delta.md
difficulty: medium
detectable_from: video
---

# The abstract concept card — dark ground, script title, one accent, one abstract visual

## What it is
The Hinglish trio (`sfx kt 1`, `sfx kt 2`, `editing kt 3` — one creator, one house style) gives every abstract concept its own **full-frame card**, and the cards are built from one repeated recipe:

- a **dark teal/navy ground**, the same across the whole video;
- a **title in a handwritten or script face** — `Instruments`, `Music`, `The Composition of a Video`;
- optionally a **small sub-label in a second accent colour** tying the concept to a use — orange `Suspense/Tension` under `Instruments`;
- **one abstract visual** in a single muted cyan accent: a 50/50 pie chart with thin leader lines, a circular arc with diamond nodes and a waveform inside it, an isolated waveform in a rounded rectangle;
- **nothing else.** No photograph, no screenshot, no second colour, no decoration.

The value is not the individual card, it is that they form a **system**. Once three cards share a ground, a type treatment and one accent, the fourth is recognised as "a concept is being named" before it is read — the format teaches the viewer its own grammar, and each new card costs almost nothing to build. It is the visual counterpart of the name-define-demonstrate spine ([[struct-name-define-demonstrate]]): the card *names*, the presenter *defines*, the clip *demonstrates*.

The abstract visual carries real weight and should be chosen for what it asserts, not for how it looks:
- a **pie chart** asserts a *proportion* — "sound is half the video" is a claim about share, so the visual is a share;
- a **waveform** asserts *this is audio* without asserting anything about a particular file;
- an **arc with nodes** asserts *a cycle or a progression* — a shape with a beginning and an end.

Choosing the wrong one is not a style error, it is a factual one: a bar chart under "sound is half the video" would say something the sentence does not.

Where the five sound layers, the ten SFX families or the eleven music points are taught, each item plausibly gets its own card in this system — one card per item, same ground, same accent, different visual ([[sfx-ten-family-catalogue]], [[sfx-five-layers-build-order]], [[sfx-music-ten-point-framework]]).

## When to use it
- **When naming an abstract concept that has no footage** — a layer of sound, a category, a proportion, a workflow stage. This is the B-roll slot for ideas ([[motion-graphics-broll-slot]]).
- **At the top of each item in an enumerated list**, as the marker that a new item has begun ([[motion-list-item-marker-card]], [[struct-enumerated-promise-and-counter]]).
- **For a claim that is a proportion or a relationship** — the case where a chart is genuinely more honest than a sentence.
- **When the alternative is a stock photo.** A stock image of a mixing desk under the word "Foley" adds nothing and dates the video.
- **Not for a concept that has a demonstration.** If you can play the sound or show the edit, do that instead; a card in front of a demo is a delay, not an aid ([[struct-demo-before-label]]).
- **Not more than about one card per 45 s.** Past that the cards stop being punctuation and become the video.
- **Not with a photographic background.** The system's legibility comes from a flat ground.

## How to recognise it in a reference video
- **The same ground colour returns.** Sample the background of three cards: within a few percent, it is a system; different each time, it is decoration.
- **Exactly one accent hue** carries every graphic element. A second hue appears only as a small sub-label and always means the same thing.
- **A script or handwritten title face** paired with a clean face for everything else — the contrast is the signature ([[motion-type-treatment-matches-content]]).
- **The card is full-frame and static**, held 2–5 s, with a single build rather than continuous motion.
- **The visual is abstract, never photographic**, and reduces to one idea: one chart, one waveform, one arc.
- **Cards recur with the same layout** — title in the same place, visual in the same place. Measure the title baseline on two cards; a system holds it within a few pixels.
- **The presenter's voice continues over the card.** These are illustrations of speech, not silent title cards.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `ground` | dark teal/navy `#10222b`–`#0d1b2a` | — | One value for the whole video. Never a gradient with a visible band. |
| `accent` | muted cyan | — | One hue for every graphic element. |
| `accent_secondary` | orange sub-label | — | Reserved for a single job (e.g. the emotion a concept maps to). Never for decoration. |
| `contrast_ratio` | ≥4.5:1 | ≥4.5:1 | Title against ground; WCAG AA for normal text ([[sub-emphasis-caption-three-words]] for the caption side). |
| `title_face` | script/handwritten | — | Titles only. Body and labels stay in the clean face. |
| `title_px` | 96 px @1080p | 72–140 px | Titles ≥1.5× body; tracking −0.03 to −0.05 em on the clean face. |
| `sublabel_px` | 44 px @1080p | 36–56 px | ≤30 characters. |
| `dwell` | max(2.5 s, chars ÷ 13) | 2.5–6 s | Reading budget, not taste. |
| `visual_stroke` | 3 px @1080p | 2–5 px | Thin leader lines read as diagrammatic; thick strokes read as branding. |
| `elements_per_card` | 1 visual + 1 title | — | Plus at most one sub-label. Two visuals means two cards. |
| `entry` | 0.4 s, `power3.out` | 0.3–0.5 s | Title and visual, staggered 0.12 s. No overshoot. |
| `exit` | hard cut | — | Cards leave on the cut, not on a fade — the cut is the punctuation. |
| `cards_per_minute` | ≤1.3 | — | Above this the format flips from punctuated to card-driven. |
| `chart_reveal` | 0.6 s sweep | 0.4–0.9 s | A pie or arc draws round; a waveform fades or wipes. Draw in the direction the concept runs. |

## Reproduction prompt

```
Build a concept card for {{CONCEPT}} in the house card system.

1. PICK THE ASSERTION, then the visual:
   proportion or share      -> pie / split ring, labelled both sides
   "this is audio"          -> isolated waveform in a rounded rectangle
   cycle, order, progression-> arc with diamond nodes at the cardinal points
   quantity over time       -> do NOT use a card; use a real chart or a clip
   If none of these fits the sentence being spoken, the card is decoration -
   cut it.
2. LAY OUT on the standing ground colour: title in the script face, upper
   third; visual centred; sub-label directly under the title if the concept
   maps to a use or an emotion.
3. ONE ACCENT for every stroke and fill in the visual. The sub-label may use
   the single secondary accent. No third colour.
4. ANIMATE ONCE: title fades/rises 0.4 s power3.out; visual 0.12 s later;
   any chart draws in over 0.6 s in the direction the concept runs. Then
   hold, completely static.
5. HOLD for max(2.5 s, characters / 13) and leave on a hard cut.
6. CHECK THE SYSTEM: put this card beside the last two from the same video.
   Same ground, same accent, same title baseline, same title size. If any of
   the three differ, fix this card, not the others.

ACCEPTANCE TEST: mute the video and show three cards in sequence to someone
who has not seen it. They should be able to say what each concept is, and
that the three belong to the same video.
```

## Execution spec

**HyperFrames — one clip, divs, transform tweens.** SVG is the right primitive for the abstract visual: it scales, it is one file, and its stroke can carry the accent as a CSS variable.

```html
<div class="clip" id="card-instruments" data-start="204.00" data-duration="4.20" data-track-index="2">
  <div class="cc-ground">
    <h2 class="cc-title" id="cc-t">Instruments</h2>
    <p class="cc-sub" id="cc-s">Suspense / Tension</p>
    <svg class="cc-vis" id="cc-v" viewBox="0 0 400 400" aria-hidden="true"><!-- arc + nodes + waveform --></svg>
  </div>
</div>
```
```js
const IN = 204.0;
tl.fromTo("#cc-t", { autoAlpha: 0, y: 18 }, { autoAlpha: 1, y: 0, duration: 0.40, ease: "power3.out" }, IN);
tl.fromTo("#cc-s", { autoAlpha: 0, y: 12 }, { autoAlpha: 1, y: 0, duration: 0.35, ease: "power3.out" }, IN + 0.12);
tl.fromTo("#cc-v", { autoAlpha: 0, scale: 0.94 }, { autoAlpha: 1, scale: 1, duration: 0.45, ease: "power3.out" }, IN + 0.12);
// a drawn arc: animate strokeDashoffset, not geometry
tl.fromTo("#cc-arc", { strokeDashoffset: 640 }, { strokeDashoffset: 0, duration: 0.6, ease: "power2.out" }, IN + 0.20);
```
Contract facts: **`fromTo`, never `from`** (a `from()` writes its start state at construction, before `data-start`). **Transform aliases only** — `scale`, `x`, `y`, `rotation`; `width`/`height`/`top`/`left` tweens are forbidden, and `strokeDashoffset` is a legitimate non-transform property because it is not layout. **`autoAlpha`, never `visibility`/`display`, and never on the clip element itself.** A CSS `transform` on a GSAP-tweened element raises `gsap_css_transform_conflict`. Land the last tween before `data-duration` — the visibility window is half-open. GSAP must be vendored locally; the CDN is blocked by the egress allowlist. Fonts must be local too: a script face pulled from a web font host will not resolve at render.

**Make it a sub-composition.** Once the system exists, each card is the same sub-comp with a different title, sub-label and SVG — that is what makes card *n* nearly free. Keep `data-start` explicit on the host; relative timing has four silent failure modes.

**Colour and type as tokens.** Put ground, accent and secondary accent in CSS custom properties at the root so a profile change is one edit, not twelve. Verify the title/ground pair at ≥4.5:1 before building the rest.

**ffmpeg — only if a real waveform is wanted** in the isolated-waveform card:
```bash
ffmpeg -ss 6 -t 4 -i bed.wav -filter_complex \
  "showwavespic=s=1200x300:colors=0x62c6d8:scale=sqrt" -frames:v 1 assets/img/card_wave.png
```
A synthesised squiggle is acceptable on a *concept* card — it asserts "audio", not "this audio" — but never on a teaching overlay, where a fake waveform destroys the credibility of the real ones ([[motion-waveform-teaching-overlay]]).

**Remotion.** Ordinary divs and SVG driven by `useCurrentFrame()`; nothing here is stack-specific except the lint rules.

## Pairs with
[[motion-single-word-topic-card]] · [[motion-list-item-marker-card]] · [[motion-type-treatment-matches-content]] · [[motion-graphics-broll-slot]] · [[motion-closing-thesis-title-card]] · [[motion-explainer-beat-animation]] · [[motion-waveform-teaching-overlay]] · [[struct-name-define-demonstrate]] · [[sfx-five-layers-build-order]] · [[sfx-ten-family-catalogue]] · [[sfx-music-ten-point-framework]]

## Failure modes
- **A second accent colour.** The system's recognisability is one hue; a third colour makes every card look like a different video.
- **A visual that asserts the wrong thing.** A bar chart for a proportion, a rising line for a category. Pick the visual from the sentence.
- **Photographic backgrounds.** Kills contrast and breaks the set.
- **Continuous motion.** A looping pulse or drifting particles turns a card into a screensaver. One build, then static.
- **Too short to read.** Under 2.5 s a title in a script face is a flash; script faces are slower to read than clean ones, so the reading budget is a floor, not a target.
- **Title face used for body text.** Script faces fail at small sizes and low contrast. Titles only.
- **Card creep.** More than about one card per 45 s and the video is cards with clips between them.
- **Drifting layout.** Title baseline moving between cards is the fastest way to lose the system; template it as a sub-composition.
- **Known gap:** the exact hex values, typeface and card durations are not measurable from a contact sheet — the ground, accent and type *relationships* are observed, the numbers here are this library's defaults. Sample real frames before matching a specific creator.
