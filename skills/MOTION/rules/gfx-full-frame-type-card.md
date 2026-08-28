---
id: gfx-full-frame-type-card
title: The full-frame type card — optical centring, measure, and when a card earns the whole frame
aliases: [gfx-full-frame-statement-card]
skill: motion
type: graphic
family: type-card
tags: [skill/motion, type/graphic, family/type-card, engine/hyperframes, engine/remotion, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "n/a"
    quote: "Technique names appear full-frame on near-black between sections — Movement Match Cut, J Cut, L Cut, SMASH CUT — with the type treatment matching the cut's character. Recorded in _meta/visual-kt-delta.md."
research_refs:
  - https://practicaltypography.com/line-length.html
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
difficulty: medium
detectable_from: video
---

# The full-frame type card — optical centring, measure, and when a card earns the whole frame

## What it is

Type alone on a ground, occupying the whole frame: a chapter marker, a thesis line, a section title. It is the most expensive graphic in the vocabulary because it **costs the footage** — for its duration there is nothing else to look at.

Two things separate a deliberate card from an empty one: **optical centring** (mathematically centred type looks low, because the eye weights the visual mass, not the bounding box) and **measure** (line length, which decides whether one line or three).

`[[motion-closing-thesis-title-card]]` covers its arrival and hold. This is its composition.

## When to use it

Three cases earn a full frame:

1. **A structural boundary** — the viewer needs to feel a section end. The absence of footage *is* the signal.
2. **A thesis line** the whole video turns on, where competing imagery would dilute it.
3. **A name being introduced**, where the word itself is the content — which is exactly the reference use: a cut's name shown before it is demonstrated.

It does **not** earn a frame for a line the speaker is already saying and the caption is already showing. That is three copies (`[[gfx-three-channel-division-of-labour]]`). A card earns the frame when the *pause* is the point, not when the words are.

## How to recognise it in a reference video

- **Vertical position of the type's optical centre**, as % from the top. A deliberate card sits at 44–48 %; exactly 50 % usually means mathematical centring and reads slightly low.
- **Measure** — characters per line, counted.
- **Line count**, and whether breaks fall on syntax or on width.
- **Type step** relative to the caption size in the same video — the ratio tells you the scale's reach.
- **Ground:** solid, near-black, or a darkened still. Note whether footage is visible behind.
- **Air ratio:** type block height ÷ frame height. Below ~0.25 reads timid; above ~0.6 reads cramped.
- **Duration** in frames, and whether the card is silent or carries a sound.
- **Type treatment matching content** — the reference sets `SMASH CUT` in an eroded face and `J Cut` in clean type. The face is carrying meaning, which is a deliberate choice worth logging.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `optical_centre` | 46 %H | 44–48 %H | Of the type block's visual mass. Not its bounding box. |
| `measure` | 22 char | 16–30 char | Short measures at display size; 30+ forces the eye to travel. |
| `max_lines` | 2 | 1–3 | Three only if each line is a complete phrase. |
| `type_step` | 2 steps above caption | 1–3 steps | From `[[gfx-modular-type-scale]]`. |
| `air_ratio` | 0.38 | 0.25–0.6 | Type block height ÷ frame height. |
| `side_margin` | ≥12 %W | 12–20 %W | Wider than body margins — a card wants air. |
| `ground` | `--ground` solid | — | If over footage, darken until ≥7 : 1 contrast. |
| `hold_frames` | 45 | 30–90 | Long enough to read at reading speed, plus ~0.4 s. |
| `line_break` | on syntax | — | Never on width. A break mid-phrase reads as a mistake. |

## Reproduction prompt

```
Compose a full-frame type card reading {{TEXT}} at {{OUT_TC}}.

1. First test whether it earns the frame. If the speaker is saying these
   words and the caption is showing them, it does not — it is a third
   copy. A card is justified by the PAUSE, not the words. If it fails,
   say so and propose an overlay instead.
2. Set at 2 steps above caption size on the profile's scale. Side
   margins >= 12% of frame width.
3. Break lines on SYNTAX, never on width. Max 2 lines, 22 characters
   each. If the text will not fit, cut the text.
4. Centre OPTICALLY, not mathematically: place the type block so its
   visual mass sits at 46% of frame height. In practice, translate the
   mathematically-centred block UP by 2-4% of frame height, then check
   by eye. Ignore ascender/descender space with no glyphs in it.
5. Ground: solid --ground. If over footage, darken until contrast is
   >= 7:1 and confirm no footage detail competes with the type.
6. Hold {{HOLD}} frames, minimum 45. Compute from reading speed plus
   0.4s of air.
7. ACCEPTANCE TEST: extract the frame, flip it vertically, and look at
   it. Optically centred type looks balanced flipped; mathematically
   centred type looks visibly high when inverted. Also confirm every
   line break lands where you would pause reading aloud.
```

## Execution spec

**HyperFrames.** Flex-centre, then apply the optical correction as an explicit transform so it is visible and tunable rather than buried in padding:

```html
<div class="type-card" data-start="41.2" data-duration="1.5"
     style="position:absolute; inset:0; background:var(--ground);
            display:flex; align-items:center; justify-content:center">
  <h2 style="max-width:76%; text-align:center; text-wrap:balance;
             transform:translateY(-3%); margin:0;
             font-size:7.2vh; line-height:1.14; color:var(--ink)">
    Correction never<br>catches the lie
  </h2>
</div>
```

`translateY(-3%)` **is** the optical correction — keep it as its own declaration and comment it, or someone will "clean it up". `text-wrap:balance` evens ragged lines but does not respect syntax, so author explicit `<br>` where the break matters. `font-size` in `vh` so the card survives an aspect change.

Verify by extracting the single frame (`references/build-and-render.md`), never by rendering the section.

**Remotion:** same composition; the optical offset is a `translateY` on the text container.

## Pairs with
[[motion-closing-thesis-title-card]] · [[gfx-modular-type-scale]] · [[gfx-weight-and-optical-size]] · [[gfx-three-channel-division-of-labour]] · [[gfx-palette-ground-ink-accent]] · [[gfx-attention-budget-simultaneity]]

## Failure modes

- **Mathematical centring.** The single most common tell. Type looks low and the card looks unconsidered. Fix: translate up 2–4 %H and check the flip test.
- **Breaking on width.** `Correction never catches / the lie` versus `Correction never / catches the lie` — the second is a phrase, the first is an accident. Fix: author the breaks.
- **A card for words already spoken and captioned.** Three copies of one sentence, at the cost of the footage. Fix: overlay, or cut it.
- **Too short a hold.** Reading a display line takes longer than reading a caption; under 30 frames the viewer registers that something appeared without reading it.
- **Type filling the frame.** Air is what makes a card read as deliberate. Above 0.6 air ratio it reads as a slide.
- **Face chosen for flavour rather than meaning.** The reference changes face to match the cut's character — that is semantic. Decorative face-swapping just looks inconsistent.
