---
id: struct-name-define-demonstrate
title: Name it, define it in one sentence, then show it — the same way every time
skill: editing
type: structure
family: list-video
tags: [skill/editing, type/structure, family/list-video, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:29"
    quote: "The cut is an instant switch between one shot to another, including audio. You would have seen thousands of these, as it's the most popular cut style of them all."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:57"
    quote: "Number eight is cutting on action. Cutting on action means just that. You cut during the character or object's movement."
research_refs:
  - https://sites.google.com/site/cognitivetheorymmlearning/segmenting-principle
  - https://learningatscale.acm.org/las2014/talks/paper_philip_guo2.pdf
  - https://eddl.tru.ca/wp-content/uploads/2019/08/EDDL5101_W5_Guo_2013.pdf
  - https://www.sciencedirect.com/science/article/abs/pii/S2211368121000231
difficulty: low
detectable_from: transcript+video
---

# Name it, define it in one sentence, then show it — the same way every time

## What it is
A fixed three-beat module repeated identically for every item in a list video: **(A) announce the ordinal and the name**, **(B) one sentence of definition**, **(C) cut to footage that demonstrates it**. The repetition is the technique. Once a viewer has seen the module twice they know what is coming, stop spending attention on the structure, and spend all of it on the content — which is the segmenting principle from multimedia-learning research, and the reason a bare list of ten things is watchable at all. The demonstration beat is a worked example: the definition is the rule, the clip is the instance, and the pair together is what gets remembered.

## When to use it
Use it for any enumerated payload: N cut types, N mistakes, N tools, N steps. It is the natural body structure that follows a counted promise ([[struct-enumerated-promise-and-counter]]) and it pairs with an on-screen counter. It requires that every item genuinely have a demonstrable instance — if three of your ten items can only be *described*, the cadence breaks at those three and the video sags there. Do not use it for an argument that builds, where each point depends on the last; that wants a different shape, because the module's whole promise is that items are independent and interchangeable.

## How to recognise it in a reference video
- **The transcript is the primary evidence.** Look for an ordinal + copula + name pattern repeated N times: "Number two, the jump cut." · "Number three is the match cut." · "Number eight is cutting on action." Extract every such line and its timestamp — that list *is* the structure.
- **Inter-item interval and its variance.** Compute the gaps between consecutive item-start timestamps. A real cadence has a **low coefficient of variation, σ/μ < 0.30**. The source video runs 10 items across 00:00:21–00:05:26, i.e. **~30 s per item**.
- **Definition length.** The sentence after the name is short and complete: **8–25 words**, one clause of mechanism. If it runs three sentences, the module has decayed.
- **A demonstration cut follows the definition within 1–4 s.** The cut is hard, full-frame, and the demo clip usually carries **its own diegetic audio** (movie dialogue, a real-world sound) rather than the host's voice.
- **An identical graphic template each time.** Same number card, same position, same entrance, same duration. Look for pixel-identical placement across items — that is the tell that it is a template, not hand-built.
- **Voice returns on the same beat.** After the demo, the host's voice comes back in the same register at the same relative point.
- **Aggregate runtime check.** `item_count × per_item_duration`. Engagement measurements on 862 videos / 6.9M sessions put the engagement ceiling near **6 minutes** regardless of length, with viewers of 12-minute-plus videos watching about **3 minutes**. A cadence that pushes total runtime past ~8 minutes without chaptering or rehooks is over-extended.
- **Chapter markers / a counter.** Often present, and they are the structure made visible.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `per_item_duration` | 30 s (900 f) | 20–45 s | Measured at ~30 s in the source. Multiply by item count and sanity-check the total |
| `beat_A_name` | 2.0 s (60 f) | 1.5–3.0 s | Ordinal + name only. No hedging, no preamble |
| `beat_B_define` | 6.0 s (180 f) | 4.0–8.0 s | One sentence, 8–25 words |
| `beat_C_demo` | 14 s (420 f) | 8–20 s | The worked example. Longest beat |
| `beat_D_why` | 5.0 s (150 f) | 0–6 s | Optional one-line consequence. Drop it to hit runtime |
| `demo_lead_in` | 1.5 s (45 f) | 1.0–4.0 s | Gap between end of definition and the demo cut |
| `interval_cv` | 0.20 | 0.0–0.30 | σ/μ of inter-item gaps. Above 0.30 the cadence is not felt |
| `item_count` | 10 | 3–12 | Beyond 12 items either chapter it or split the video |
| `total_body_runtime` | 5.0 min | 3–8 min | `item_count × per_item_duration`. Past 8 min add rehooks every 2 min |
| `card_entrance` | 0.4 s (12 f) | 0.27–0.5 s | `power3.out`, identical for every item |
| `card_hold` | 2.0 s (60 f) | 1.5–3.0 s | Identical for every item |
| `rehook_interval` | 120 s (3600 f) | 90–180 s | Only needed when total runtime exceeds ~6 min |

## Reproduction prompt

```
Build the body of a list video as N identical three-beat modules at 30fps.

1. From the transcript extract the N items and write a module table: ordinal | name | one-sentence
   definition (8-25 words) | demo source | demo in/out. An item with no demonstrable clip either
   gets one or gets cut. Never ship a module with an empty beat C.

2. Fix the beat budget ONCE and apply it unchanged to every item:
   beat A name        60 f - ordinal + name spoken; numbered card enters at A+0
   beat B definition 180 f - exactly one sentence
   beat C demo       420 f - hard cut to full-frame demonstration footage
   beat D why        150 f - optional; drop this first if runtime overruns
   per item          810 f (27.0 s). Allowed drift +/-150 f (5 s).

3. Compute item_count x per_item_duration. Over 8 minutes: reduce per-item toward 20 s, cut items,
   or insert a rehook every 3600 f that restates the promise and the current count.

4. Build the numbered card ONCE as a parameterised sub-composition and instance it N times with
   per-instance {{ORDINAL}} / {{NAME}}. Entrance 0.4 s power3.out, hold 60 f, exit 0.25 s
   power2.in. Never hand-build the second card - a pixel of drift breaks the cadence.

5. Cut into every demo identically: hard cut, no transition, the demo's own audio playing. Duck or
   stop the bed for beat C and restore it on the first frame of the next beat A.

Acceptance test: list every beat-A start timestamp; sigma/mu of consecutive differences must be
<=0.30. All N cards must occupy identical pixel positions for identical durations. Any item
missing beat C, or any card differing from the template, fails.
```

## Execution spec

**HyperFrames — modular, one sub-composition per item, with variables.** This is exactly the case the contract says to modularise for ("clear scene cuts", "reusable scenes", "three or more scene cuts → modularize"):

```html
<!-- compositions/item.html declares the schema on <html> -->
<!-- <html data-composition-variables='[
       {"id":"ordinal","type":"string","label":"Ordinal","default":"1"},
       {"id":"name","type":"string","label":"Item name","default":"The cut"}]'> -->

<!-- index.html: N instances of the SAME file, differing only in values -->
<div id="el-item-01" data-composition-id="item" data-composition-src="compositions/item.html"
     data-start="21.0" data-duration="27.0" data-track-index="1"
     data-variable-values='{"ordinal":"1","name":"The cut"}'></div>
<div id="el-item-02" data-composition-id="item" data-composition-src="compositions/item.html"
     data-start="el-item-01" data-duration="27.0" data-track-index="1"
     data-variable-values='{"ordinal":"2","name":"The jump cut"}'></div>

<!-- beat C demo footage lives at the host root so it can carry its own sound -->
<video id="demo-01" src="assets/demo01.mp4" data-start="29.0" data-duration="14.0"
       data-media-start="4.5" data-track-index="0" muted playsinline></video>
<audio id="demo-01-a" src="assets/demo01.mp4" data-start="29.0" data-duration="14.0"
       data-media-start="4.5" data-track-index="10" data-volume="0.9"></audio>
```

Contract points that make or break this:
- `data-variable-values` is the per-instance override; the schema is a JSON **array** on `<html>` of the sub-comp, and scripts inside read resolved values via `window.__hyperframes.getVariables()`.
- The **host's** `data-duration` is a clip duration, re-read from the live DOM, so per-item length *can* be driven by variables/scripts. The **root** `data-duration` cannot — it is compile-time-locked, so total runtime is fixed at authoring time.
- `data-start="el-item-01"` chains items end-to-end. **Spaces around `+`/`-` are mandatory** and an unresolvable reference silently resolves to `0`. Chain of 10 references → snapshot at every item boundary.
- Ids must be unique across the **assembled** page. Prefix sub-comp internals (`#item-card`) and give each host a distinct id.
- A sub-comp timeline **cannot** animate host-root elements, which is why the demo `<video>` sits at the root and is driven (if at all) on the main timeline at `global = scene-local + slot data-start`.
- Put the sub-comp's `<style>` and `<script>` **inside** the `<template>` — the assembler drops the file's own `<head>`. Load GSAP from a **local** path; `cdn.jsdelivr.net` is blocked.
- Duck the bed for beat C with a `volume` automation lane on the bed (clip-local `t`), remembering the lane holds its first value backwards to the clip start — so give it an explicit `{"t":0,"v":1}` point.

**ffmpeg** — prepare demo clips at exact in/out, or prefer `data-media-start` and cut nothing:

```bash
ffmpeg -i source.mp4 -ss 00:04:31.500 -to 00:04:45.500 -c copy assets/demo01.mp4
# frame-accurate: drop -c copy (keyframe snap moves the in point)
```

**Epidemic Sound** — one bed for the whole body, one card SFX reused N times (reuse is correct here; the repetition is the structure):
`SearchSoundEffects({ query:{ term:"ui pop transition short" }, filter:{ duration:{ min:150, max:600 } } })`.

**Remotion**: an `.map()` over the item array emitting one `<Sequence>` per item at `from = 630 + i*810` frames; concept only.

## Pairs with
[[struct-enumerated-promise-and-counter]] · [[pace-silent-demonstration-window]] (beat C, done properly) · [[struct-numbered-list-mid-roll-sponsor]] · [[struct-outcome-first-cold-open]] · [[struct-stimulation-budget]] · [[cut-fade-bookend]] · [[pace-overlay-instead-of-cut]]

## Failure modes
- **Cadence decay.** Items 1–3 are tight, items 7–10 balloon. The viewer feels the video losing interest in itself. Correction: enforce the beat budget as a table before building, and check σ/μ afterwards.
- **A module with no demonstration.** Definition-only items are where retention dips. Correction: cut the item, or replace beat C with a motion graphic that *does* something rather than a still.
- **Hand-building each card.** Positions and durations drift by a few pixels and frames, and the template stops reading as a template. Correction: one parameterised sub-comp, N `data-variable-values` instances.
- **Novelty inside the module.** Varying the entrance animation per item to "keep it interesting" destroys the exact property that makes the list watchable. Correction: identical every time; put variety in beat C's footage.
- **Ten items × 60 s.** A 10-minute list overruns the engagement ceiling and viewers see roughly a quarter of it. Correction: 20–30 s per item, or chapter it and add a rehook every 2 minutes.
- **Music running unchanged under the demo.** The demo's own audio is the evidence; a bed over it makes the example unreadable. Correction: duck or stop the bed for beat C.
- **The counter and the modules disagreeing.** Promising 10 and shipping 9 modules is the one error a viewer definitely notices. Correction: count the modules against the promise before render.
