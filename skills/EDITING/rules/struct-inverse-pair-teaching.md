---
id: struct-inverse-pair-teaching
title: Teach mirror-image techniques as one pair, with a shared rationale and one diagram
skill: editing
type: structure
family: list-video
tags: [skill/editing, type/structure, family/list-video, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:50"
    quote: "Cuts number four and five is the J cut and the L cut."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:23"
    quote: "An L cut is the opposite. The audio from the current scene continues even after the visual cuts to the next."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:53"
    quote: "These cuts are incredibly useful because they create a smoother, more natural flow between shots, especially in conversations."
research_refs:
  - https://link.springer.com/article/10.1007/s10648-012-9201-3
  - https://link.springer.com/article/10.3758/s13421-012-0272-7
  - https://bera-journals.onlinelibrary.wiley.com/doi/10.1002/rev3.3266
  - https://en.wikipedia.org/wiki/Split_attention_effect
  - https://www.sciencedirect.com/science/article/abs/pii/S0959475209000358
difficulty: medium
detectable_from: transcript+video
---

# Teach mirror-image techniques as one pair, with a shared rationale and one diagram

## What it is
When two items in a list are **inverses of each other**, they are presented as a single numbered beat rather than two: the first is defined in full, the second is defined only as "the opposite", and the rationale that justifies both is delivered **once, after both**. The source does exactly this — "cuts number four and five is the J cut and the L cut" is announced as one heading, the L cut gets one sentence ("the opposite"), and the shared *why* ("smoother, more natural flow… especially in conversations") arrives at the end covering both. The structural payoff is that the explanation cost roughly halves while retention improves, because the learner is forced to **discriminate** between two confusable items rather than encode each in isolation. The cost — and the reason this note has parameters — is that paired inverses are exactly the material learners later mix up, so the pairing must carry disambiguation devices or it backfires.

## When to use it
Only when the two items are genuinely **symmetric**: the same mechanism with one variable flipped, so that "the opposite" is a complete definition. J cut / L cut, fade in / fade out, high-pass / low-pass, riser / downlifter, cut-in / cut-away, ease-in / ease-out. Do **not** pair items that are merely adjacent or contrasting-in-vibe — a match cut and a smash cut are both cuts and both "about" contrast, but neither is the other's inverse, and pairing them produces a muddle rather than a contrast. Also do not pair when one of the two is far more useful than the other; the weaker one steals a numbered slot it does not deserve. Use it at most **twice per list video**: the device is efficient, but a list where half the items are pairs reads as padding the count.

## How to recognise it in a reference video
- **One heading, two names, from the transcript.** The signature line is a numbering announcement that names two items at once ("number four and five is X and Y"). Grep the transcript for a numeral range or a conjunction inside a heading.
- **Definition asymmetry.** Measure the word count of each definition. In a pairing, item A gets a full definition (**25–60 words**) and item B gets **5–20 words**, usually containing the literal word "opposite", "reverse", "flipped" or "other way round". A near-equal split means they were taught as two separate items that happen to be adjacent.
- **Rationale position.** The shared "why this is useful" sits **after both examples**, not after the first. If each item has its own rationale, it is not a pairing.
- **Two examples, adjacent.** Both items get a demonstration, and the demonstrations are back to back with no other content between them. Log the gap; over ~20 s of intervening material and the contrast is lost.
- **A simultaneous comparison graphic.** Look for one frame showing **both** timelines/waveforms/curves at once with both labels attached to the thing they label. This is the disambiguation device, and its presence or absence is the single best predictor of whether the pairing worked. Two consecutive single graphics is a weaker form.
- **A mnemonic tied to form.** The J cut / L cut names *are* the diagram — the letter shape describes the timeline shape. In a strong version the presenter says so out loud or the graphic draws the letter. Log whether the mnemonic is stated, drawn, or absent.
- **Discrimination beat.** The strongest versions end with a mixed test: one example shown, the viewer asked which is which. Rare; log it when present.
- **Runtime economy.** Compare seconds-per-item for the paired beat against the list's median. A working pairing runs at roughly **1.3–1.6×** a single item's time for two items (i.e. it saves 20–35%), not 2×.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `symmetry_test` | must pass | — | Item B is fully defined by flipping exactly one variable of item A. If it takes two clauses to say what flipped, do not pair. |
| `definition_ratio` | 3:1 | 2:1 – 6:1 | Words in A's definition ÷ words in B's. |
| `b_definition_words` | 12 | 5–20 | B's whole definition. Longer and the pairing dissolves into two items. |
| `shared_rationale_position` | after both examples | — | Delivered once, covering both. |
| `example_gap` | 0 s | 0–20 s | Content between the two demonstrations. Zero is best. |
| `comparison_graphic` | required | — | One frame, both timelines, both labels **on** the elements they name — not in a legend. |
| `label_distance` | ≤ 40 px @1080p | 0–80 px | Spatial contiguity: a label further from its element than this re-introduces the split-attention cost the graphic exists to avoid. |
| `mnemonic` | form-based, stated | stated \| drawn \| absent | Tie the name to the shape (the J descends to the left of the cut; the L extends to the right of it). |
| `graphic_hold` | 3.5 s (105 f) | 2.5–6 s | The comparison frame must be readable at a glance and held long enough to compare, not just to see. |
| `pairs_per_video` | 1 | 0–2 | More than two pairings in one list reads as padding. |
| `discrimination_beat` | optional | — | 4–8 s: one mixed example, name it. Costs little, and is the only part that tests the contrast. |
| `time_ratio` | 1.45× | 1.3–1.6× | Paired-beat duration ÷ median single-item duration. |

## Reproduction prompt

```
Structure list items {{N}} and {{N+1}} as an inverse pair.

1. SYMMETRY TEST first. Write one sentence of the form "B is A with
   {{VARIABLE}} reversed". If you cannot, abandon the pairing and teach
   them as two separate numbered items. Do not pair merely-related items.
2. Announce both under ONE heading, naming both ("number four and five are
   X and Y"). The on-screen counter shows both numbers.
3. Define A fully: what it is, mechanically, in 25-60 words. Show A's
   example immediately.
4. Define B in 5-20 words, containing an explicit inversion word
   ("the opposite", "reversed"). Show B's example immediately after A's,
   with NOTHING between them.
5. Cut to ONE comparison graphic showing both cases simultaneously - two
   stacked timelines / curves / waveforms, each labelled in place, with the
   difference highlighted (colour the flipped variable, not the whole
   element). Hold it 3.5 seconds (105 frames @30fps). Do not use two
   consecutive single graphics: the comparison must be visible in one frame.
6. Say the mnemonic out loud while the graphic is up, tying each name to its
   shape.
7. Deliver the shared rationale ONCE, after both examples, covering both
   items ("these are useful because ...").
8. Optional 4-8s discrimination beat: show one unlabelled example and name
   it, so the viewer's first act with the pair is telling them apart.
9. ACCEPTANCE TEST: (a) B's definition is under 20 words and contains an
   inversion word; (b) the two examples are adjacent with no intervening
   content; (c) one frame exists in which both cases are visible and
   labelled, with every label within 40px of the thing it labels at 1080p;
   (d) the rationale appears once, after both; (e) total duration is 1.3-1.6x
   the video's median single-item duration - if it is 2x, the pairing bought
   nothing and should be split back into two items.
```

## Execution spec

**HyperFrames (the comparison graphic is the whole build).** Make it a **sub-composition**: it has clear internal phases and will be reused for the next pair. The root of a sub-comp is `<template>`-wrapped and its `<style>`/`<script>` must live **inside** the template, because the assembler drops a sub-comp's own `<head>` tags.

```html
<!-- host slot in index.html -->
<div id="el-pair-jl" data-composition-id="pair-jl"
     data-composition-src="compositions/pair-jl.html"
     data-start="126.0" data-duration="3.5" data-track-index="1"></div>
<!-- 3.5s = 105f @30fps -->
```

Inside, two stacked timeline rows (video bar + audio bar per case), with the audio bar offset left for the J and right for the L. Build the reveal so the contrast is what animates:

```js
// scene-local seconds inside the sub-comp's own paused timeline
const tl = window.__timelines["pair-jl"] = gsap.timeline({ paused: true,
  defaults: { duration: 0.4, ease: "power3.out" } });
tl.fromTo(".row", { x: -40, autoAlpha: 0 }, { x: 0, autoAlpha: 1, stagger: { each: 0.12 } }, 0.15);
tl.fromTo("#j-audio-bar", { scaleX: 1, transformOrigin: "right center" },
                          { scaleX: 1.25, duration: 0.5, ease: "power2.inOut" }, 0.9);
tl.fromTo("#l-audio-bar", { scaleX: 1, transformOrigin: "left center" },
                          { scaleX: 1.25, duration: 0.5, ease: "power2.inOut" }, 0.9);
tl.fromTo(".label", { autoAlpha: 0 }, { autoAlpha: 1, stagger: { each: 0.08 } }, 1.4);
```
Contract details: use **`fromTo`, never `from`** (a `from()` writes its start state at construction, before the clip window opens, and flashes under seek); `autoAlpha` rather than `visibility`/`display`, and only on non-clip inner elements — the framework owns clip visibility and lint rejects tweening it; keep `items × stagger ≤ ~0.5 s` so each row-set arrives as one beat; land every tween **before** the slot's `data-duration`, since the window is half-open. Total stagger for four rows at 0.12 s is 0.36 s — inside the cap.

Labels go **on** the bars as absolutely-positioned children, not in a legend — the split-attention research is the reason, and the layout audit will separately flag a label that overflows or collides. If a label must sit in the caption zone, opt out explicitly with `data-layout-allow-caption-zone` rather than letting the audit fail silently behind an unrelated lint error.

Transition in and out with one of the five registry transitions, reusing the video's chosen 2–3 types (`push-slide` 0.5 s is a good fit for a comparison card, since the direction can echo the inversion).

**ffmpeg (measurement on a reference).** Timing the beat and confirming the examples are adjacent:
```bash
# item boundaries from the transcript, then durations
python3 - <<'PY'
import json; d=json.load(open('ref.transcribe.json'))
# locate "number four and five", then the next numbered heading; print the span
PY
ffmpeg -ss 120 -t 20 -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd
```

**Epidemic Sound.** One soft motion sound on the comparison graphic's build, and nothing else — the beat is explanatory, not dramatic: `SearchSoundEffects { query.term: "subtle ui swipe transition soft", filter.duration { max: 900 } }`, placed at the graphic's first animated frame, own group `sfx`, around −12 to −15 dB relative to dialogue.

**Remotion:** a comparison component with two offset bars; concept only, no Remotion runtime here.

## Pairs with
[[cut-j-audio-leads-picture]] · [[struct-name-define-demonstrate]] · [[struct-enumerated-promise-and-counter]] · [[struct-numbered-list-mid-roll-sponsor]] · [[struct-credibility-anchor]] · [[pace-overlay-instead-of-cut]] · [[struct-objection-character-cutaway]]

## Failure modes
- **Pairing non-inverses.** "The opposite" then does not define B, the viewer holds two half-definitions, and both are lost. Fix: run the symmetry test in writing before scripting.
- **No simultaneous comparison frame.** Two consecutive graphics require the viewer to hold the first in memory while decoding the second — the interleaving benefit depends on *contrast*, and sequential presentation is the version that produces confusion instead. Fix: one frame, both cases.
- **Labels in a legend.** A legend forces the eye to shuttle between key and diagram; that split-attention cost is exactly what the pairing was supposed to save. Fix: labels within 40 px of what they name.
- **Rationale delivered twice.** Repeating the *why* after each item throws away the pairing's whole economy and makes the beat run 2× a single item. Fix: once, after both.
- **B taught at equal length.** The asymmetry is the device. An equal-length B is just item five. Fix: cut B's definition to under 20 words and let the example carry the rest.
- **Over-using the pattern.** A ten-item list containing four pairings is a six-item list wearing a costume. Fix: two pairings maximum.
- **Skipping the mnemonic.** Without a form-based hook the viewer remembers "there are two, one is the opposite" and neither name. Fix: state the shape-to-name link while the graphic is on screen.
- **Known gap:** the learning-science support here (discriminative contrast from interleaving; spatial-contiguity/split-attention effects) is drawn from classroom and lab studies of category learning and multimedia instruction, not from video-tutorial retention data — and the interleaving literature itself notes that ecologically valid studies are thin. The word counts, ratios and hold times in the parameter table are craft calibrations against the source video, not measured optima. Treat them as review thresholds.
