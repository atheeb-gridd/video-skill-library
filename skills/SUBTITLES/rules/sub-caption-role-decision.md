---
id: sub-caption-role-decision
title: Decide the caption role before styling — emphasis layer, full track, or both
skill: subtitles
type: caption-style
family: caption-role
tags: [skill/subtitles, type/caption-style, family/caption-role, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:54"
    quote: "A lot of people make the mistake of adding captions just to bump up the visual variety."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:02"
    quote: "Using captions to fill more space can get ugly fast and waste a great opportunity to put something more engaging on screen. So I only use captions when I want the viewer to catch specific words and pay extra attention to them."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:15"
    quote: "But if there's genuinely nothing else you could put on screen, captions are often still better than nothing."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/captions-prerecorded.html
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://sproutsocial.com/insights/social-media-video-specs-guide/
difficulty: medium
detectable_from: transcript+video
---

# Decide the caption role before styling — emphasis layer, full track, or both

## What it is
Three different objects get called "captions" and they have incompatible specs, so the first decision in any subtitle design is which of them you are building. A **full track** carries all of the speech, obeys a reading-speed ceiling, sits in a fixed zone and is what discharges an accessibility obligation. An **emphasis layer** is a graphic: one to three words, roughly one second, fired on a handful of load-bearing words to make them land. A **hybrid** runs a full track in the caption zone plus a sparse emphasis layer above it, with a hard zone split between them. This note is the routing decision and the coexistence contract; the emphasis layer's own type and timing numbers live in [[sub-emphasis-caption-three-words]], and the full track's cue maths lives in [[sub-cue-segmentation-three-word]].

The source's argument against captions-as-filler is an opportunity-cost argument, not a taste argument: the lower third is prime screen area, and a redundant transcription of a sentence the viewer just heard is the lowest-value thing that can sit there. The stated fallback survives the rule and must not be dropped — with genuinely nothing else to show, captions still beat nothing.

## When to use it
Run this decision once per deliverable, before any styling, and record the answer in `design-subtitles.md`.

- **Full track** when the deliverable is watched muted by default (in-feed vertical, LinkedIn, X), when there is an accessibility requirement (WCAG 2.2 SC 1.2.2 Captions (Prerecorded) is Level A and covers the whole audio programme, not the interesting words), when the audio is accented, mixed-language or noisy, or when the client asked for one.
- **Emphasis layer only** when the video is watched with sound on a large screen, the frame is already carrying B-roll, graphics and demos, and the caption's job is to spike specific words. This is the source's own register: a talking-head YouTube edit with heavy visual variety.
- **Hybrid** when both are true — an in-feed cut of a sound-on edit. Budget the zones first, or they collide.
- **Neither / defer** when the beat has an unfilled B-roll slot. A caption is competing with a cutaway for that area; route the slot with [[motion-broll-slot-tier-selection]] first and only caption if the slot stays empty.

The decision changes with the delivery, not with the edit: the same timeline can ship sound-on at 16:9 with an emphasis layer only, and in-feed at 9:16 with a full track, from one composition and two sub-comp hosts.

## How to recognise it in a reference video
- **Captioned share of speech** — pull the word-level transcript, count spoken words that appear as on-screen type, divide by total spoken words. **Under 15 %** = emphasis layer. **Over 80 %** = full track. **30–70 %** is almost always the failure this note names: captions that started because the editor ran out of pictures and stopped when the B-roll returned.
- **Continuity of the box.** A full track's caption object is on screen with no blank longer than ~0.5 s across a whole paragraph. An emphasis layer leaves the zone empty for **2 s or more** between events.
- **Two distinct type registers in one frame** is the hybrid tell: a small track (3–4.5 % of frame height) parked low, plus an occasional large mark (5–9 % of frame height) higher up and often in an accent colour.
- **Zone check.** Measure the vertical band each object occupies as a percentage of frame height. If the two overlap at any timestamp, the reference is not a designed hybrid, it is a collision.
- **Silent-viewing test.** Play muted for 30 s. If you can follow the argument, a full track exists. If you catch isolated nouns and numbers only, it is an emphasis layer.
- **Track ride-through.** Full-track cues usually ride straight through picture cuts; emphasis captions almost always start and end inside a single shot.
- **On the transcript**, mark which of the four emphasis classes each captioned word belongs to (named term, number/unit, proper noun/jargon, load-bearing claim word). If most captioned words fit none of them, the layer is filler.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `role` | emphasis | emphasis / full-track / hybrid | One value per deliverable, recorded before styling. |
| `captioned_share_of_speech` | 10 % (emphasis) | 5–15 % emphasis; 95–100 % full track | The 30–70 % band is the filler signature. Nothing should be authored into it. |
| `emphasis_events_per_minute` | 5 | 3–8 | Hard ceiling 8. One visible at a time. |
| `min_gap_between_emphasis_events` | 2.0 s | 1.2–4.0 s | Below 1.2 s the layer reads as a track starting. |
| `track_zone_bottom` | 12 % of frame height | 8–20 % | Baseline of the track above the platform UI band. See [[sub-safe-area-and-caption-zone]]. |
| `emphasis_zone_bottom` | 28 % of frame height | 22–40 % | Sits **above** the track band in a hybrid; never share a band. |
| `zone_separation` | 6 % of frame height | ≥4 % | Clear air between the two objects' boxes at every timestamp. |
| `track_reading_rate` | 17 CPS | 15–20 CPS | Netflix caps adult programmes at 20 CPS, children's at 17; DCMP targets 130–160 wpm. Use 17 CPS as the house cap. |
| `emphasis_hold` | 1.0 s | 0.6–1.6 s | Full spec in [[sub-emphasis-caption-three-words]]. |
| `accessibility_obligation` | none | none / WCAG-A | If WCAG-A, the full track is mandatory and carries speaker IDs and non-speech audio, not just dialogue. |

## Reproduction prompt

```
Before styling any caption in this project, resolve the caption role and write
it into design-subtitles.md.

1. ANSWER FOUR QUESTIONS. (a) Will this deliverable be watched muted by
   default? (b) Is there an accessibility requirement? (c) Is the audio
   accented, mixed-language or noisy? (d) Is the frame already carrying B-roll
   and graphics on most beats? Any yes to (a)(b)(c) => FULL TRACK. Only (d)
   yes => EMPHASIS LAYER. (a or b) plus (d) => HYBRID.
2. BUDGET THE ZONES. Full track: baseline at 12% of frame height from the
   bottom. Emphasis layer: baseline at 28%. In a hybrid keep >=4% of frame
   height of clear air between the two boxes at every timestamp, and never let
   both be visible with less than that gap.
3. SET THE QUOTAS. Emphasis layer: <=15% of spoken words, <=8 events per
   minute, >=2.0s between events, never two on screen at once. Full track:
   95-100% of spoken words, <=17 characters per second, minimum 0.833s per
   isolated cue.
4. ROUTE THE LEFTOVERS. For every beat where you wanted a caption purely
   because the frame was empty, log a B-roll slot request instead. Only
   caption it if that slot is still unfilled at picture lock.

ACCEPTANCE TEST: compute captioned_words / spoken_words for the finished cut.
It must be <=0.15 or >=0.95 - never between. Then play muted for 30s: under
FULL TRACK the argument must be followable; under EMPHASIS the caption zone
must be empty for at least 2s between every pair of events.
```

## Execution spec

**HyperFrames.** There is no caption primitive — no `data-caption`, no SRT/VTT ingest, no built-in subtitle renderer. A caption is an ordinary composition whose GSAP timeline writes `textContent` and animates a box (`compositions/captions.html` is the reference implementation, hand-authored throughout). The role decision maps directly onto composition architecture:

```html
<!-- index.html: two independent caption sub-comps, never one -->
<div id="el-track" data-composition-id="captions-track"
     data-composition-src="compositions/captions-track.html"
     data-start="0" data-duration="{{DURATION}}" data-track-index="6"
     style="z-index: 40" data-layout-allow-caption-zone></div>

<div id="el-emph" data-composition-id="captions-emphasis"
     data-composition-src="compositions/captions-emphasis.html"
     data-start="0" data-duration="{{DURATION}}" data-track-index="7"
     style="z-index: 50"></div>
```

- `data-duration` is **required** on a sub-composition host; without a resolvable duration the element stays visible for the rest of the composition.
- `data-track-index` is **display only** — the render never reads it. Layering is CSS `z-index`. Put the emphasis layer above the track.
- Ship one deliverable per aspect by giving each its own `index.html` root (`data-width`/`data-height`), reusing the same caption sub-comps with different `data-variable-values` for the zone offsets. The root `data-duration` is compile-time-locked, so it cannot be varied per render.
- **Do not merge the two roles into one sub-comp.** A sub-comp timeline cannot animate host-root elements, and mixing a per-line box with per-event elements in one file is how the zone budget quietly drifts.
- The layout audit's `--caption-zone` check raises `caption_zone_collision`; put `data-layout-allow-caption-zone` on the **track** host only (it applies to descendants via `closest`) so a real collision on the emphasis layer still reports.
- Scope every CSS rule to `[data-composition-id="captions-track"]` inside the `<template>` — the assembler drops a sub-comp file's own `<head>` styles.
- GSAP must be loaded from a **local** path; `cdn.jsdelivr.net` is blocked by the egress allowlist, so the reference file's CDN `<script>` line must be substituted.

**ffmpeg.** Only for a baked track leaving the pipeline: `ffmpeg -i in.mp4 -vf "subtitles=track.srt:force_style='FontName=Montserrat,FontSize=28,Outline=2,MarginV=130'" -c:a copy out.mp4`. `force_style` values map onto ASS style fields (`FontName`, `FontSize`, `PrimaryColour`, `OutlineColour`, `Bold`, `MarginV`). Never bake the emphasis layer this way — it should stay restylable without a re-encode.

**Epidemic Sound.** Only the emphasis layer needs sound. One short transient per event: `SearchSoundEffects { query: { term: "ui text pop tick" }, filter: { duration: { max: 400 } } }`, placed at −12 to −15 dB. A full track is silent.

**Remotion.** Equivalent shape is two sibling components mounted for the whole composition, each mapping its own cue array to frame ranges. Portable concept, not a stack in this project.

## Pairs with
[[sub-emphasis-caption-three-words]] · [[sub-cue-segmentation-three-word]] · [[sub-safe-area-and-caption-zone]] · [[sub-karaoke-active-word-highlight]] · [[motion-broll-slot-tier-selection]] · [[pace-visual-variety-density-audit]] · [[motion-overlay-stack-choreography]] · [[struct-stimulation-budget]]

## Failure modes
- **Authoring into the 30–70 % band.** Half a transcript on screen: too much to be a mark, too little to be a track, and it is the exact "captions as filler" move the source rejects. Correction: pick a role and hit its quota.
- **Treating an emphasis layer as accessibility.** It carries no speaker identification, no non-speech audio and not most of the dialogue, so it does not meet SC 1.2.2. Correction: if the obligation exists, author a real track and keep emphasis sparse on top of it.
- **One object trying to do both jobs.** Styling a full track heavy enough to also read as emphasis makes every word look emphasised, so none is. Correction: two objects, two zones, two type registers.
- **Zone collision in the hybrid.** The most common avoidable defect in the whole library — a mark landing on top of a track line. Correction: enforce the 4 % clear-air rule and let `caption_zone_collision` run on the emphasis layer rather than suppressing it globally.
- **Deciding the role after styling.** Restyling a finished track into an emphasis layer means re-selecting words, which means redoing the timing. Correction: this note runs first, before [[sub-cue-segmentation-three-word]].
- **Suppressing the caption-zone audit with `data-layout-allow-overflow`.** Its blast radius is the whole subtree and it also switches off `text-clipping` and `content-cramped-container`. Correction: use the narrow `data-layout-allow-caption-zone`.
- **Known gap.** Nothing in the stack measures captioned share of speech. It has to be computed from the transcript by the design pass and written into `design-subtitles.md`; there is no lint rule to catch a drift.
