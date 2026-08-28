---
id: struct-numbered-list-mid-roll-sponsor
title: Numbered-list spine with the sponsor read dropped mid-list
skill: editing
type: structure
family: list-spine
tags: [skill/editing, type/structure, family/list-spine, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/research, difficulty/low]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:04:06
    quote: "Have you heard about YAS? — No, that I haven't heard of. — Then how would you know?"
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:00
    quote: "So now let's continue our video. Let's move to the 6th point: cartoon sound effects."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:00:14
    quote: "Apart from that, in this video I'm going to give you 10 points that nobody will tell you even in a paid course."
research_refs:
  - https://channel.farm/blog/listicle-ai-video-scripts-youtube
  - https://sponsorradar.com/insights/youtube-sponsored-video-performance-guide-for-brands
  - https://prepublish.ai/guides/first-30-seconds
  - https://increditors.com/video-pacing-youtube-retention-science/
difficulty: low
detectable_from: transcript
---

# Numbered-list spine with the sponsor read dropped mid-list

## What it is
The video's spine is an explicit numbered countdown — every item announced by its ordinal ("Fifth is motion sound effects", "let's move to the 6th point") — and the sponsor segment is placed **inside** the list rather than at the top or the end. In the source, the sponsor runs 00:04:06 → 00:05:00 (54 seconds) in a 10:36 video: 39% of the way through, between item 5 and item 6, and the return is signposted with an explicit re-entry line naming the next number. The list is doing two jobs: each ordinal is a micro-promise that the next one exists, so the viewer carrying an open loop for items 6–10 has a structural reason to sit through the read.

## When to use it
On any teaching video whose content is naturally enumerable — cut types, sound families, mistakes, tools, steps. It is the single cheapest retention structure available, because the numbers create the open loops for free. Place the sponsor mid-list whenever there is one; place it at a **natural item boundary**, never inside an item's explanation. Do not impose a numbered spine on content that is genuinely sequential-dependent (a build where step 4 makes no sense without step 3) — there, chapters and a progress device work better than a countdown, because a countdown invites skipping.

## How to recognise it in a reference video
- **Detect it from the transcript alone**, which makes it the cheapest technique in this library to log:
  `grep -nEi "^\[([0-9:]+)\] *(number|point|no\.?) *(one|two|three|[0-9]+)|(first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth|[0-9]+(st|nd|rd|th)) (is|point|one)" transcript.md`
- **Build the item table:** ordinal, start timestamp, duration. Then check three things:
  - **Item count** — 5–7 is the researched sweet spot for 5–15 minute videos; 10 is the classic listicle count and it forces short items.
  - **Duration variance** — deliberate structures vary item length (strong items 90–120s, simple items 40–60s). Uniform item lengths at uniform energy is the tell for a video that will lose viewers mid-list.
  - **Coverage gap** — an unannounced gap between two ordinals is the sponsor, a skit, or a mid-roll digression. Measure its position as a percentage of runtime.
- **Sponsor block signature:** starts with a question or a name the audience does not know ("Have you heard about…"), contains the words "sponsored by", runs 45–90 seconds, sits between two ordinals, and ends with an explicit re-entry line ("So now let's continue our video. Let's move to the 6th point").
- **Sponsor position** in the source is 39% of runtime, immediately after the midpoint of the list (item 5 of 10). Log the percentage and the item index; a read placed at 5–10% (top) or 90%+ (end) is a different structure.
- **Visual signposting:** look for an on-screen number card at each ordinal, and for a distinct visual treatment (different background, lower-third, logo) across the sponsor block — the visual change is what lets a skipping viewer find the end of the read.
- **Numbers may be lost to ASR.** In the source, item 7's and item 9's headings fall in transcript gaps. If an ordinal is missing, look for the item's *content* start and infer the boundary rather than concluding the item does not exist.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `item_count` | 7 | 5–10 | 5–7 for 5–15 min videos; 10 works when items are 40–60s. Odd counts perform slightly better in titles. |
| `item_length` | 60s | strong items 90–120s · simple items 40–60s | Vary deliberately; uniform lengths read as a template. |
| `ordinal_announced` | yes, every item | — | Say the number out loud AND show it. Skipping the spoken ordinal removes the open loop. |
| `number_card` | 18f in / hold / 12f out | in 12–24f, out 9–18f | On-screen card at each item start. |
| `sponsor_position` | 40% of runtime | 35–55% | Immediately after the list's midpoint item. Never before item 3 and never after the second-to-last item. |
| `sponsor_length` | 54s | 45–90s | The source's is 54s; sponsor guidance sits at 60–90s for mid-roll integrations. |
| `sponsor_entry_boundary` | item boundary | — | Between two items, never mid-item. |
| `reentry_line` | required | — | Explicit: "let's continue" + the next ordinal named. |
| `remaining_count_tease` | optional | — | Naming how many items remain before the read strengthens the open loop. |
| `best_item_position` | 60–70% of the list | 50–85% | Position 5 or 6 of 7. Front-load a quick win at item 1; do not spend the strongest item first. |
| `pattern_interrupt_between_items` | 10s (300f) | 150–450f | A 10-second beat between items — a skit, a demo, a graphic — is what keeps the list from feeling like a spreadsheet. |

## Reproduction prompt

```
Lay out the numbered-list structure for this video before any cut is placed.

1. Build the item table in the design doc: ordinal, title, planned duration,
   and a one-line note on why the viewer wants it. Target 7 items; accept
   5-10. Assign 90-120s to the two or three strongest items and 40-60s to the
   rest - do NOT give every item the same duration.
2. Order them so item 1 is a fast, obvious win and the single strongest item
   lands at 60-70% of the list. Close on a synthesis item, not on a repeat of
   the strongest point.
3. Announce every item twice: spoken ordinal in the narration, and an
   on-screen number card animating in over 18 frames (power3.out), holding,
   out over 12 frames.
4. Place the sponsor block at the item boundary nearest 40% of runtime -
   after the list's midpoint item, never inside an item. Length 45-90s.
   Give it a visibly different treatment (background, lower-third, logo) so
   its start and end are findable by a skipping viewer.
5. Immediately before the read, tease what remains ("five more, and number
   eight is the one nobody uses"). Immediately after, write the re-entry line
   explicitly: "let's continue - number six: <title>", and land the next
   number card on the frame the line starts.
6. Put a 300-frame (10s) pattern interrupt between items: a demonstration
   window, a skit beat, or a graphic - not another talking-head paragraph.
7. ACCEPTANCE TEST: read only the ordinals in sequence. No number may be
   skipped, repeated or arrive out of order. Then check the gap table: the
   only unannounced gap longer than 20 seconds must be the sponsor block, and
   it must sit between 35% and 55% of runtime. Finally confirm every item
   boundary carries both a spoken ordinal and a number card on the same
   frame.
```

## Execution spec

**Detection and structure logging (ffmpeg / transcript).** Transcribe, then derive the item table:
```bash
npx hyperframes transcribe ref.mp4 --engine auto      # word-level json
# ordinals -> item boundaries; unannounced gaps -> sponsor / skit / digression
```
Note the environment constraint: the Parakeet default is an Apple-silicon MLX path, so on this linux ARM64 box expect the whisper.cpp fallback.

**HyperFrames (assembly).** Modular is the right architecture here — a numbered list is scene cuts by definition, and the guidance is to modularise once a project passes three scene cuts. One sub-composition per item, audio at the host root so the bed survives the cuts:
```html
<!-- index.html : thin root, audio at root, one host slot per item -->
<div id="el-item-05" data-composition-id="item-05" data-composition-src="compositions/item-05.html"
     data-start="186.0" data-duration="60.0" data-track-index="1"></div>
<div id="el-sponsor" data-composition-id="sponsor" data-composition-src="compositions/sponsor.html"
     data-start="246.0" data-duration="54.0" data-track-index="1"></div>
<div id="el-item-06" data-composition-id="item-06" data-composition-src="compositions/item-06.html"
     data-start="300.0" data-duration="64.0" data-track-index="1"></div>
<!-- sponsor 246.0-300.0s = frames 7380-9000 @30fps; 39% of a 636s runtime -->
```
Relative timing can chain these (`data-start="el-item-05"` = start when item 5 ends), which keeps the table self-consistent when an item's length changes — but the four silent-zero failures apply: spaces around `+`/`-` are mandatory, an unresolved id resolves to 0, a target with no resolvable duration lands on its *start*, and a cycle resolves to 0. Nothing in lint checks it, so `npx hyperframes snapshot --at <midpoints>` and verify each item actually starts where the table says. Snapshotting is **required** for projects with sub-compositions.

Inside each item sub-comp, times are scene-local. The number card:
```js
// item sub-comp: card in at scene-local 0.1s (0.6s = 18f in, power3.out)
tl.fromTo("#num-card", { autoAlpha: 0, y: 18 },
  { autoAlpha: 1, y: 0, duration: 0.6, ease: "power3.out" }, 0.1);
tl.to("#num-card", { autoAlpha: 0, duration: 0.4, ease: "power2.in" }, 2.6);
```
Do not start at t=0 — offset the first animation 0.1–0.3s. `autoAlpha` is on the inner card element, not the clip container. A sub-comp timeline **cannot** animate host-root elements, so anything that must span the item boundary (a persistent progress bar, the bed) belongs at the host root.

Give the sponsor block a distinct scene background and a different transition from the list's primary one — the transition budget is 2–3 types for the whole video, and the topic-change slot is exactly where the third one earns its place.

**ffmpeg (chapter markers for the deliverable).** YouTube chapters come from the description, but a marker file is worth emitting alongside the render so the item table survives:
```bash
awk -F'|' '{printf "%s %s\n", $1, $2}' items.psv > chapters.txt
```

**Epidemic Sound.** One bed per list phase, not one per item; change the bed at the sponsor boundary and use find-similar so the return feels continuous. See [[pace-bpm-matched-music-selection]].

**Remotion:** a Series of Sequences, one per item; concept only.

## Pairs with
[[struct-demand-hook-competence-gap]] · [[pace-silent-demonstration-window]] · [[pace-cut-density-from-viewer-intent]] · [[struct-music-arc-to-narrative-arc]] · [[cut-punch-in-emphasis]] · [[struct-enumerated-promise-and-counter]] · [[struct-name-define-demonstrate]]

## Failure modes
- **Sponsor at the top.** A meaningful share of viewers leave in the first minute, so a pre-roll read reaches the smallest possible audience and spends the hook's momentum on a third party. Fix: move it to the 40% boundary.
- **Sponsor inside an item.** Breaks an open loop mid-explanation; the viewer loses the thread and does not come back for the second half of the item. Fix: item boundaries only.
- **No re-entry line.** The viewer who skipped the read cannot tell where the content resumes and scrubs past the next item too. Fix: "let's continue" plus the next ordinal, spoken and carded on the same frame.
- **Silent ordinals.** Cards without spoken numbers means an audio-only or a distracted viewer loses the spine, and the open loops disappear. Fix: say every number.
- **Uniform item lengths at uniform energy.** The most reliable way to lose the middle of a list. Fix: 90–120s for the strong items, 40–60s for the rest, and a 10-second interrupt between them.
- **Strongest item first.** Everything after it is a decline. Fix: strongest at 60–70% of the list, a fast win at item 1.
- **Known gap:** there is no published retention-by-position dataset for *sponsor* placement inside a numbered list. The 35–55% window here is triangulated from the source video's own 39% placement, from sponsor-marketplace guidance that mid-roll reads after a natural content break outperform interruptions, and from the general shape of retention curves. Replace it with the channel's own retention graph as soon as one exists — the sponsor block's dip is the most legible feature on that graph.
