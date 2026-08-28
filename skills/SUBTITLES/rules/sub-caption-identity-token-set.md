---
id: sub-caption-identity-token-set
title: Specify the caption identity as a token set, not as a pile of CSS
skill: subtitles
type: caption-style
family: caption-identity
tags: [skill/subtitles, type/caption-style, family/caption-identity, engine/hyperframes, source/hyperframes, source/research, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "compositions/captions.html — .captions-container → #caption-box.caption-box → #caption-text.caption-text. One box, one span, reused for every line. Scoped CSS inside the template, every rule prefixed [data-composition-id=\"captions\"]."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "There is no data-caption, no SRT/VTT ingest attribute, and no built-in subtitle renderer. A caption is an ordinary composition whose GSAP timeline writes textContent and animates a box."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://www.w3.org/TR/ttml-imsc1.1/
  - https://www.w3.org/TR/WCAG22/
difficulty: medium
detectable_from: video
---

# Specify the caption identity as a token set, not as a pile of CSS

## What it is

A **caption identity** is the complete, closed set of values that determines what every caption in a video looks like. It is written once, named, and referenced — never re-decided per cue and never re-typed per composition.

This matters more in HyperFrames than in a conventional NLE, because HyperFrames has **no caption primitive**. There is no `data-caption` attribute, no SRT/VTT ingest, no subtitle renderer. `compositions/captions.html` is a hand-authored composition: a container, a box, a span, and a GSAP timeline that writes `textContent`. Every visual property is ordinary CSS that somebody typed. Nothing stops a second composition from typing different numbers, and nothing in `hyperframes check` will complain — the layout and contrast audits check *legibility*, not *consistency*. Drift between two caption compositions in the same video is invisible to the toolchain and glaring to a viewer.

The fix is a token set: a block of CSS custom properties defined once on the caption composition root, from which every rule reads. Fifteen tokens, listed below, fully determine the identity. A style profile records those fifteen values. A new project starts by copying the block and changing values, not by re-deriving the design.

The token set is also the interchange format between the two modes of this skill. **Mode A** (analyse a reference video) fills the fifteen slots by measurement. **Mode B** (design a new video) reads them back out. `_templates/style-profile.md` and the "Caption identity" table in `_templates/design-subtitles.md` are both projections of this same set.

## When to use it

Always, before any caption CSS is written. Specifically:

- **At the start of Mode B**, as the first artefact produced. Cue segmentation, emphasis, and collision checks all reference tokens by name; they cannot be specified against un-named values.
- **At the end of Mode A**, as the deliverable of the measurement pass. "The captions are white Montserrat with a black plate" is not a profile. Fifteen numbers is a profile.
- **Whenever a video contains more than one caption-bearing object** — a track plus emphasis captions, or captions plus a term lockup ([[sub-term-definition-lockup]]) plus a list marker ([[sub-list-marker-caption-lockup]]). Each object is a *variant* that derives from the base tokens by a stated transform, not an independent design.
- **Before the second video in a series.** The whole return on a token set is the second use.

Do not build a token set for a one-off single-caption graphic. One caption is not an identity.

## How to recognise it in a reference video

An identity is present, and reusable, when repeated sampling produces the *same* measurements rather than a distribution. Sample mid-cue frames at 8–12 points spread across the video and measure each:

| Signal | A real identity | No identity |
|---|---|---|
| Cap height as % of frame height | Same value ±0.2 pp across all samples | Varies 1 pp or more between sections |
| Baseline position as % from bottom | Same ±1 pp, or exactly two values (track band and emphasis band) | Three or more distinct bands, no pattern |
| Plate colour sampled at 5 points inside the box | Identical RGB, or one flat gradient | Different hex in different sections |
| Corner radius, measured in px then divided by cap height | Constant ratio | Constant *pixels* across different type sizes — an untokenised design |
| Number of distinct accent hues across the whole video | 1, occasionally 2 | 4+ |
| Weight | One cut for body, one for emphasis | Three or more cuts |

The corner-radius test is the sharpest one. A design where radius is a fixed pixel value while type size changes has been re-typed per object. A design where radius scales with cap height came out of a token set.

Practical measurement: extract a frame with `ffmpeg -ss <t> -i <video> -frames:v 1 out.png`, then measure cap height in pixels on a capital letter (not an ascender, not a lowercase x) and divide by frame height. At 1080p a 4.5 % font-size token gives roughly 48 px em box and roughly 34 px cap height, or 3.1 % cap height. **Report both** — cap height is what the eye sees, font-size is what the CSS says, and they differ by the face's cap-height ratio.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `--cap-font-family` | Montserrat | one of the 18 pre-bundled families | Google Fonts fetch is a blocked network path; see [[sub-typeface-selection-for-captions]]. Inter is bundled but on the banned monoculture list. |
| `--cap-size` | 4.5 % of frame height | 3.5–6 % | 48 px at 1080p — matches the reference file's `font-size: 48px`. In-feed deliverables start at 5 %. |
| `--cap-weight` | 700 | 600–900 | The reference uses `700`, a real cut in bundled Inter (400 · 700 · 900). Verify the cut exists before specifying it. |
| `--cap-tracking` | −0.03 em | −0.03 to −0.05 em | Display-size tracking. See [[sub-tracking-and-caption-line-height]]. |
| `--cap-leading` | 1.2 | 1.15–1.35 | The reference uses `line-height: 1.2`. Add 0.05–0.1 on dark grounds. |
| `--cap-case` | sentence | sentence / upper | One value for the whole video. All-caps degrades past ~4 words. |
| `--cap-colour` | `#f5f0e0` | — | Reference value. Never pure `#ffffff` on a plate — see [[sub-caption-colour-token-system]]. |
| `--cap-accent` | one hue | 1 hue, 2 max | The emphasis colour. Two accents is no accent. |
| `--cap-plate` | `#7a6248` | — | Reference value. `transparent` if the backing is stroke or shadow instead. |
| `--cap-plate-alpha` | 1.0 | 0.7–1.0 | Below 0.7 the plate stops guaranteeing contrast over unpredictable video. |
| `--cap-pad-y` / `--cap-pad-x` | 0.25 em / 0.67 em | 0.2–0.4 / 0.5–1.0 em | Reference `12px 32px` at 48 px = 0.25 em / 0.67 em. Express in `em` so the plate scales with type. |
| `--cap-radius` | 0.5 em | 0–0.75 em | Reference `24px` at 48 px = 0.5 em. Pixels here is the untokenised-design smell. |
| `--cap-max-width` | 80 % of frame width | 70–86 % | Reference `max-width: 80%` on the box, `1600px` on the text inside 1920. |
| `--cap-bottom` | 11 % of frame height (16:9) / 20 % (9:16) | 8–26 % | The reference's `padding-bottom: 230px` on 1080 is ~21 % — a vertical-style placement in a landscape frame. See [[sub-platform-ui-overlap-map]]. |
| `--cap-backing` | plate | plate / stroke / shadow / blur | Exactly one. See [[sub-legibility-backing-ladder]]. |

## Reproduction prompt

```
Produce a caption identity token block for {{PROJECT}}, targeting {{ASPECT}} at
{{WIDTH}}x{{HEIGHT}}, viewed {{in-feed|full-screen}}.

Emit a single CSS custom-property block scoped to the caption composition root,
in the HyperFrames scoping style: every selector prefixed
[data-composition-id="captions"]. Define exactly these tokens and no others:
--cap-font-family, --cap-size, --cap-weight, --cap-tracking, --cap-leading,
--cap-case, --cap-colour, --cap-accent, --cap-plate, --cap-plate-alpha,
--cap-pad-y, --cap-pad-x, --cap-radius, --cap-max-width, --cap-bottom,
--cap-backing.

Rules. Express --cap-size and --cap-bottom as calc() against the composition
height, never as bare pixels, so the block survives a re-render at another
resolution. Express padding and radius in em so they scale with type. Pick
--cap-font-family from the 18 pre-bundled families only — a Google Fonts
@import is a blocked network path in this project and will fail closed. Choose
exactly one value for --cap-backing; do not stack a plate, a stroke and a
shadow. Use at most {{1|2}} accent hues.

Then emit the three rules that consume the tokens — .captions-container,
.caption-box, .caption-text — and nothing else. No hard-coded colour, size,
radius or offset may appear outside the token block.

Acceptance test: grep the emitted CSS for a hex colour, a px length, or a
numeric font-size outside the :root token block. Zero matches passes. Then
change --cap-size alone by 25 % and confirm the plate, radius and padding all
scale with it and the box does not exceed --cap-max-width.
```

## Execution spec

The token block lives inside `<template id="captions-template">`, in the scoped `<style>` that HyperFrames preserves. This is load-bearing: the assembler drops `<head>`, so caption styles **must** be inside the template, and every rule **must** be prefixed `[data-composition-id="captions"]` or it leaks into sibling compositions.

```html
<template id="captions-template">
  <div data-composition-id="captions" data-width="1920" data-height="1080" data-duration="10">
    <style>
      [data-composition-id="captions"] {
        --cap-h: 1080;
        --cap-size: calc(4.5 * var(--cap-h) / 100 * 1px);
        --cap-bottom: calc(11 * var(--cap-h) / 100 * 1px);
        --cap-weight: 700;
        --cap-tracking: -0.03em;
        --cap-leading: 1.2;
        --cap-colour: #f5f0e0;
        --cap-plate: #7a6248;
        --cap-pad-y: 0.25em;
        --cap-pad-x: 0.67em;
        --cap-radius: 0.5em;
        --cap-max-width: 80%;
      }
      [data-composition-id="captions"] .captions-container {
        width: 100%; height: 100%; display: flex;
        justify-content: center; align-items: flex-end;
        padding-bottom: var(--cap-bottom); pointer-events: none;
      }
      [data-composition-id="captions"] .caption-box {
        background-color: var(--cap-plate);
        padding: var(--cap-pad-y) var(--cap-pad-x);
        border-radius: var(--cap-radius);
        max-width: var(--cap-max-width);
        opacity: 0;
      }
      [data-composition-id="captions"] .caption-text {
        color: var(--cap-colour);
        font-size: var(--cap-size);
        font-weight: var(--cap-weight);
        letter-spacing: var(--cap-tracking);
        line-height: var(--cap-leading);
      }
    </style>
    ...
  </div>
</template>
```

Four execution constraints ride along:

- **`--cap-h` must match the root `data-height`.** There is no CSS way to read the composition height, so it is duplicated. If `data-height` changes, this changes. A `snapshot --at <midpoint>` is the only cheap check that they agree.
- **Fonts load locally.** `document.fonts.ready` gates the build; register the timeline only after the build completes. A `@import` from Google Fonts fails closed under the egress allowlist.
- **GSAP loads from a relative path.** The staged `captions.html` line `<script src="https://cdn.jsdelivr.net/npm/gsap@3.14.2/dist/gsap.min.js">` is blocked in this project and must be replaced with a vendored local reference.
- **Tokens do not survive `--variables`.** `data-composition-variables` overrides values at render time, but the root `data-duration` is compile-time-locked. If you want a per-render caption size, declare it as a composition variable and have the script write it onto the root as an inline custom property.

## Pairs with

- [[sub-typeface-selection-for-captions]] — how `--cap-font-family` gets chosen
- [[sub-size-as-frame-height-percentage]] — why `--cap-size` is a percentage and not a px value
- [[sub-caption-colour-token-system]] — the colour half of the set, expanded
- [[sub-legibility-backing-ladder]] — how `--cap-backing` gets chosen
- [[sub-caption-plate-geometry]] — how the padding and radius tokens are derived
- [[sub-platform-ui-overlap-map]] — what constrains `--cap-bottom`
- [[sub-caption-role-decision]] — decide the role before you build the identity
- [[motion-overlay-stack-choreography]] — the same discipline applied to overlays
- [[motion-storyboard-motion-spec]] — where the token block is recorded for the build

## Failure modes

- **Tokens defined, then bypassed.** A designer sets `--cap-size` and then writes `font-size: 52px` on the emphasis variant "just this once". The grep in the acceptance test exists precisely for this. One bypass and the set is decorative.
- **Pixels in the token block.** `--cap-size: 48px` works perfectly at 1080p and is 25 % too small when the same composition is rendered at portrait 1920 tall. The `calc()` against `--cap-h` is the whole point.
- **Radius and padding in px.** These scale independently of type, so a size change silently changes the plate's proportions. Anything inside the box goes in `em`.
- **Styles outside the template.** Put the caption CSS in `<head>` and the assembler drops it. The composition renders with browser defaults — 16 px serif, no plate — and `check` reports it as a contrast finding rather than as a missing stylesheet, which sends you looking in the wrong place.
- **Unprefixed selectors.** `.caption-box { }` without the `[data-composition-id="captions"]` prefix styles every sibling composition's boxes too. This produces bugs that appear only when compositions are assembled, never in isolated preview.
- **A profile that records adjectives.** "Bold, punchy, high-contrast" is not recoverable. Fifteen numbers is.
- **Assuming `check` catches drift.** It does not. And note the trap: a lint **error** switches off the layout and contrast audits entirely, so `check` reports `0 sample(s)` and `0/0 text checks` — which reads clean and means nothing ran.
