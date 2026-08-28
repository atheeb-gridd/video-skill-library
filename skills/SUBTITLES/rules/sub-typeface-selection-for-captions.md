---
id: sub-typeface-selection-for-captions
title: Choose the caption face on x-height, aperture and counter survival, not on personality
skill: subtitles
type: caption-style
family: caption-type
tags: [skill/subtitles, type/caption-style, family/caption-type, engine/hyperframes, source/hyperframes, source/research, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Inter is a bundled font (weights 400 · 700 · 900, so 700 here is a real cut) — but it is also on the Banned monoculture list. Safe-and-distinctive bundled picks: Montserrat, Oswald, League Gothic, Archivo Black, Space Mono, IBM Plex Mono, JetBrains Mono, Source Code Pro, Noto Sans JP."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Load the captured local variable font — do NOT use Google Fonts @import."
research_refs:
  - https://en.wikipedia.org/wiki/X-height
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://www.w3.org/TR/WCAG22/
difficulty: medium
detectable_from: video
---

# Choose the caption face on x-height, aperture and counter survival, not on personality

## What it is

A caption face is not a display face that happens to be small. It has a job no other type in the video has: it must be read **involuntarily, in peripheral vision, over moving content, after lossy video compression, on a phone held at arm's length**, and it must survive all of that without the viewer consciously deciding to read it.

Four letterform properties determine whether it does. In descending order of impact at caption size:

1. **x-height ratio** — x-height divided by em. Lowercase does the reading; caps are wayfinding. A face at 0.52 sets visibly smaller than a face at 0.73 at the same nominal `font-size`, so the ratio is the real size control. But the relationship is not monotonic: very high x-heights flatten word shapes and hurt recognition, because ascenders and descenders are what make `bank` and `hank` different silhouettes. The band that works for captions is **0.50–0.56** relative to cap height... measured properly, **x-height / cap-height between 0.70 and 0.78**.
2. **Aperture** — how open the terminals of `c`, `e`, `s`, `a` are. Closed apertures collapse into `o` after chroma subsampling. Video is delivered 4:2:0; the colour planes are quarter-resolution, and thin closed counters are exactly the detail that dies there.
3. **Counter size** — the enclosed white in `e`, `a`, `o`, `g`. Small counters fill in under a stroke or a shadow, and at caption size the stroke is a meaningful fraction of the counter.
4. **Letterfit at negative tracking.** Caption type runs at −0.03 to −0.05 em because video encoding compresses letter detail. A face with tight default sidebearings will collide at that tracking; a face drawn loose absorbs it.

Personality is a fifth-order concern. It is also where nearly every wrong decision is made.

## When to use it

Once per channel, not once per video. The face is the most identity-bearing token in the set ([[sub-caption-identity-token-set]]) and changing it between videos in a series is a bigger visual change than changing the colour.

Re-open the decision only when:

- **The delivery format changes.** A face chosen for full-screen 16:9 viewing may not hold at in-feed vertical, where the type floors are roughly 60 % higher.
- **The language changes.** A face that handles English fine may have no support for the accented Latin or the currency and punctuation a new market needs. For romanised Hinglish specifically, see [[sub-romanised-hinglish-latin-face]] — the requirement is a Latin face with a wide Latin repertoire, not a script-fallback stack.
- **The backing changes.** A face with small counters is survivable on a plate and unusable with a 3 px stroke.

In this project the choice is also **constrained by what is actually available**: the Google Fonts fetch is a blocked network path under the egress allowlist and fails closed in distributed renders. Pick from the 18 pre-bundled families, or embed a local `@font-face`. There is no third option.

## How to recognise it in a reference video

Faces are identifiable from a single mid-cue frame if you know what to measure. Extract at 2× or higher (`--resolution` supersampling, or a 4K source) so letterform detail survives.

| Measurement | How | What it tells you |
|---|---|---|
| x-height / cap-height | Measure `x` and `H` in the same word in pixels | 0.70–0.78 = a modern screen grotesque. Below 0.68 = an older or more literary face; expect it to read small. |
| Terminal angle on `c` / `e` | Look at whether the terminal cuts horizontally or on an angle | Horizontal, wide-open = humanist (Source Sans, IBM Plex). Angled, closed = geometric (Montserrat, Futura-likes). |
| `a` construction | Double-storey vs single-storey | Single-storey `a` at caption size is a geometric/display signal and costs a little legibility. |
| `1` / `I` / `l` | Do they differ? | If they are three identical bars, the face is a geometric sans and numbers in captions will be ambiguous. |
| Stroke contrast | Compare the stem of `o` at 3 o'clock vs 12 o'clock | Near-zero contrast is right for captions. Visible modulation is a text-face signal and it thins under compression. |
| Width | Characters per 10 % of frame width | Condensed faces (Oswald, League Gothic) fit ~40 % more characters per line at the same cap height. |

The single fastest tell for "this is a considered caption face" versus "this is the default": look at `g`. A double-storey `g` at 4.5 % of frame height is a deliberate choice; almost every default and almost every AI-generated caption uses a single-storey `g`.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `family` | Montserrat | 18 pre-bundled families, or local `@font-face` | Google Fonts `@import` is blocked; treat it as unavailable, not as a fallback. |
| `x_height_to_cap` | 0.74 | 0.70–0.78 | Below 0.70 the face reads a size smaller than specified. Above 0.78 word shapes flatten. |
| `available_weights` | 400 · 700 · 900 | ≥2 cuts | Verify the cut exists. Bundled Inter ships exactly 400/700/900 — asking for `600` synthesises, and synthetic bold is mush at caption size. |
| `width_class` | normal | condensed / normal | Condensed only for vertical formats where line length is the binding constraint; it costs aperture. |
| `numeral_style` | lining, tabular | lining only | Oldstyle figures in captions read as typos. Tabular matters for counters and timecodes. |
| `latin_repertoire` | Basic Latin + Latin-1 | `U+0000-00FF` minimum | Enough for English and romanised Hinglish. Add `U+0100-017F` for Central European. |
| `banned` | Inter | — | Bundled and technically excellent, but on the project's banned monoculture list. Everything looks like everything else. |
| `safe_picks` | Montserrat, Oswald, League Gothic, Archivo Black, Space Mono, IBM Plex Mono, JetBrains Mono, Source Code Pro, Noto Sans JP | — | The project's own list of safe-and-distinctive bundled families. |
| `mono_for_captions` | no | no / yes | Space Mono / JetBrains Mono / Source Code Pro are excellent for *technical* captions (a filter name, a dB value) and poor for speech — monospace destroys word shape. |
| `fallback_stack` | one family + generic | 1–2 families | A long fallback stack is a Devanagari-era habit. For a Latin-only caption you want exactly one family; a silent fallback is worse than a missing glyph. |
| `synthetic_bold` | forbidden | — | `font-weight: 600` against a 400/700/900 family is a browser-synthesised smear. |
| `font_load_gate` | `document.fonts.ready` | — | Register the timeline only after the build completes; building inside `document.fonts.ready` is supported. |

## Reproduction prompt

```
Select and specify the caption typeface for {{PROJECT}}, delivered {{ASPECT}} and
viewed {{in-feed|full-screen}}, in {{LANGUAGE}}.

Constraints, absolute: choose from the pre-bundled families only, or specify a
local @font-face with a file path. A Google Fonts @import or link is a blocked
network path in this project and fails closed at render. Do not choose Inter —
it is bundled and it is on the banned monoculture list.

Evaluate at least three candidates against, in this order: x-height to cap-height
ratio (target 0.70-0.78), aperture on c/e/s, counter size in e/a/o under the
chosen backing, and letterfit at -0.03em tracking. Reject any candidate whose
required weight cut does not physically exist in the bundled file — name the
shipped cuts for each candidate. Reject monospace unless the captions are
technical tokens rather than speech.

Emit: the chosen family; the shipped weight cuts; the x-height ratio you
measured or the source you took it from; a one-line reason keyed to a
letterform property, not to a mood; and the @font-face or bundled reference
as it will appear in the composition.

Acceptance test: render the string "Hll1lIi0Oo aeso 3.5dB" at {{SIZE}} over
{{three sampled frames of the actual footage}}, at the chosen backing, then
re-encode at the delivery bitrate and view at 100%. Every glyph must remain
distinguishable from its lookalike after re-encode. If 1/I/l collapse, or the
counters in e/a/o fill in, the face fails.
```

## Execution spec

The font is referenced from inside the scoped `<style>` in `<template id="captions-template">`, like every other caption style. Two paths:

```css
/* Path A — a pre-bundled family. Named, not fetched. */
[data-composition-id="captions"] .caption-text {
  font-family: "Montserrat", sans-serif;
}

/* Path B — a local file. The only legal way to bring your own. */
@font-face {
  font-family: "HouseCaption";
  src: url("./assets/fonts/HouseCaption-Bold.woff2") format("woff2");
  font-weight: 700;
  font-display: block;   /* block, not swap — a swap is a visible flash mid-render */
}
```

`font-display: block` rather than `swap` is deliberate for video. A swap produces a frame or two of fallback metrics, which in a deterministic render is a reproducible glitch rather than a transient one.

Gate the timeline registration on font load, because caption box width is measured from text metrics and the layout audit samples `getBoundingClientRect`:

```js
document.fonts.ready.then(() => {
  buildCaptionTimeline();
  window.__timelines["captions"] = tl;   // register only after the build completes
});
```

Registering before fonts resolve gives the layout audit fallback-font boxes, which either passes a design that will actually overflow or fails one that will not.

Verification is `npx hyperframes check` — the composite gate runs lint, runtime, layout, motion and contrast — plus `snapshot --at <cue midpoints>` and an actual look at the frames. **A lint error switches off the layout and contrast audits**, so a clean-looking `0 sample(s)` / `0/0 text checks` means nothing ran, not that nothing is wrong.

## Pairs with

- [[sub-caption-identity-token-set]] — where `--cap-font-family` is recorded
- [[sub-weight-case-and-optical-size]] — the cut, the case, and why optical size is not a knob here
- [[sub-tracking-and-caption-line-height]] — the tracking this face has to survive
- [[sub-romanised-hinglish-latin-face]] — the Latin-repertoire requirement for Hinglish
- [[sub-legibility-backing-ladder]] — counters interact with the backing choice
- [[motion-entrance-vocabulary]] — the same face governs animated text objects
- [[sub-term-definition-lockup]] — a second type object that must derive from the same family

## Failure modes

- **Choosing on a specimen sheet.** Faces are evaluated at 200 px on white in a browser and deployed at 48 px over moving footage at 6 Mbps. Always evaluate on a real frame at real size after a real encode.
- **Specifying a weight that does not exist.** `font-weight: 600` against a 400/700/900 family produces synthetic bold: the browser smears the 400. It looks fine at 200 px and turns to porridge at caption size.
- **A Google Fonts `@import`.** It works in local preview if the machine happens to have network, and fails closed in the render. This is the single most common way a caption composition renders in Times New Roman.
- **A long fallback stack.** `font-family: "Montserrat", "Helvetica", "Arial", sans-serif` guarantees that a missing glyph silently renders in a different face at a different x-height mid-line, which is harder to spot than a tofu box. One family plus one generic.
- **Condensed as a fix for long lines.** It buys characters and spends aperture. The right fix for a long line is a line break ([[sub-syntactic-line-breaking]]) or fewer words per cue.
- **Monospace for speech.** Monospace destroys the varying word silhouettes that make peripheral reading possible. It is right for a dB value and wrong for a sentence.
- **Registering the timeline before `document.fonts.ready`.** Layout measurements come back against the fallback face, so the audit certifies a box size that will not exist at render.
