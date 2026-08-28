---
id: struct-enumerated-promise-and-counter
title: Promise a countable payload, then show the viewer their progress through it
skill: editing
type: retention
family: hook
tags: [skill/editing, type/retention, family/hook, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:14"
    quote: "in this video I'm going to tell you 10 points that nobody will tell you even in their paid course."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:42"
    quote: "I'll tell you things you probably won't find anywhere else, because I discovered these things myself over my 6 years of video editing experience."
research_refs:
  - https://business.columbia.edu/insights/chazen-global-insights/goal-gradient-hypothesis-resurrected-purchase-acceleration
  - https://journals.sagepub.com/doi/abs/10.1509/jmkr.43.1.39
  - https://prepublish.ai/guides/first-30-seconds
  - https://www.retentionrabbit.com/blog/2025-youtube-audience-retention-benchmark-report
difficulty: medium
detectable_from: transcript+video
---

# Promise a countable payload, then show the viewer their progress through it

## What it is
A three-part device. **(1)** The opening states a specific integer of deliverables — "10 points". **(2)** It attaches a scarcity claim that says why they are not available elsewhere ("nobody will tell you even in their paid course") plus an authority anchor for why *you* have them ("6 years of my own editing, self-discovered"). **(3)** The count is then made visible and tracked for the entire runtime, so the viewer always knows where they are in it. The integer is what converts a vague promise into a goal, and a goal the viewer can see themselves approaching pulls them forward — the goal-gradient effect, whose canonical experiment showed a 12-stamp loyalty card with two stamps pre-filled completing in a **median 10 days** against **15 days** for an identical-effort 10-stamp card. Visible progress, even partly illusory, accelerates completion.

## When to use it
Use it whenever the payload genuinely decomposes into independent items — tips, mistakes, cuts, tools, steps. It is the hook that pairs with a modular body ([[struct-name-define-demonstrate]]), and it is the wrong hook for an argument that builds toward one conclusion, because a counter on a cumulative argument invites the viewer to skip to the end. The scarcity clause is only usable if at least one item is genuinely non-obvious; without that it is a cheque the body cannot cash and the video reads as clickbait from item three onwards.

## How to recognise it in a reference video
- **A numeral in the first 20 seconds of transcript**, attached to a noun of deliverables: "10 points", "7 mistakes", "three moves". Ideally within **15 s** — that is the practical deadline for a payoff claim, and scripts that hit it retain about **52%** against **44%** for those that miss it.
- **A scarcity clause adjacent to the numeral.** Look for "nobody tells you", "not even in a paid course", "you won't find this anywhere else". It sits in the same sentence or the next one.
- **An authority anchor** near it: a year count, a client count, a revenue figure, "I discovered these myself".
- **N discrete item announcements later in the transcript**, and the count matches the promise. Extract them and check. A mismatch is the single most detectable failure of this device.
- **First item delivered early.** In matched examples the first item lands by **60–90 s**, i.e. before the point at which more than half the audience has already left.
- **An on-screen counter.** Either a per-item card ("3/10", "Number three") that appears for **1.5–3 s** at each item boundary, or a persistent chyron. Persistent is rarer and only appears when N is small.
- **Restatement of the count** at roughly the midpoint and again before the last item — "that's five down, five to go".
- **Strongest item is not last.** Check where the most surprising claim sits: in a well-built version it is at position **2–4**, not 10, because the scarcity claim has to be validated while the audience is still large.
- **Audio corroboration.** The numeral is very often stamped with a short hit or a UI pop at the exact frame the counter card lands.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `promise_stated_by` | 12 s (360 f) | 8–15 s | Hard ceiling 15 s |
| `item_count` | 10 | 3–12 | Must equal the number of modules actually shipped |
| `first_item_by` | 75 s (2250 f) | 45–90 s | Before the first-minute cliff |
| `scarcity_clause` | present | present \| absent | Only if ≥1 item is genuinely non-obvious |
| `authority_anchor` | present | present \| absent | One clause, ≤ 10 words |
| `counter_style` | `per-item card` | `per-item card` \| `persistent chyron` | Persistent only when `item_count ≤ 5` |
| `counter_hold` | 2.0 s (60 f) | 1.5–3.0 s | Identical for every item |
| `counter_entrance` | 0.4 s (12 f) | 0.27–0.5 s | `power3.out`; same every time |
| `counter_position` | title-safe top-left | any title-safe corner | 96 px / 54 px inset at 1920×1080 |
| `progress_restate_at` | 50%, 90% | 40–60%, 85–95% | Spoken, not just graphic |
| `best_item_position` | 3 | 2–4 | Validates the scarcity claim while the audience is large |
| `counter_sfx_level` | −13 dB | −12 to −15 dB | One short pop/hit on the counter frame |

## Reproduction prompt

```
Install a counted promise and a progress counter.

1. Within the first 360 f (12.0 s) the host speaks: an integer + a deliverable noun ("10 points"),
   a scarcity clause naming why these are not available elsewhere, and a one-clause authority
   anchor. Hard ceiling: the integer is spoken by frame 450 (15.0 s). If it lands later, cut
   whatever precedes it.

2. Count the discrete item modules in the body. That number MUST equal the promised integer.
   If it does not, change the promise - never the body silently.

3. Order items so the single most non-obvious one sits at position 2, 3 or 4. Do not save the best
   for last; by the last item most of the audience has gone.

4. Deliver item 1 by frame 2250 (75 s). Everything before it is overhead - cut until it fits.

5. Build the counter ONCE as a parameterised sub-composition, instanced N times with
   {{ORDINAL}} / {{ITEM_COUNT}}. At each boundary {{IN}}:
     tl.fromTo("#counter-{{N}}", { y: 24, autoAlpha: 0 },
       { y: 0, autoAlpha: 1, duration: 0.4, ease: "power3.out" }, {{IN}});
     tl.to("#counter-{{N}}", { autoAlpha: 0, duration: 0.25, ease: "power2.in" }, {{IN}} + 1.8);
   Position inside the title-safe box (96 px / 54 px inset at 1920x1080). One short pop or hit at
   exactly {{IN}} at -13 dB. Use a persistent chyron ONLY when the count is 5 or fewer - above
   that, a permanent counter advertises how much is left.

6. Restate progress out loud at roughly 50% and again before the last item.

Acceptance test: from the first 15 s of transcript a viewer can state the integer and why it is
scarce; the module count equals the integer exactly; every counter card renders at an identical
pixel position for an identical duration; item 1 begins before frame 2250.
```

## Execution spec

**HyperFrames — the counter as one parameterised sub-composition, instanced N times.** This is the case `data-composition-variables` + `data-variable-values` exists for, and it guarantees the cards are pixel-identical:

```html
<!-- compositions/counter.html : <html data-composition-variables='[
     {"id":"ordinal","type":"string","label":"Ordinal","default":"1"},
     {"id":"total","type":"string","label":"Total","default":"10"}]'> -->

<div id="el-counter-03" data-composition-id="counter" data-composition-src="compositions/counter.html"
     data-start="121.4" data-duration="2.2" data-track-index="5"
     data-variable-values='{"ordinal":"3","total":"10"}'
     style="z-index:20"></div>

<audio id="sfx-counter-03" src="assets/sfx/pop.wav" data-audio-group="sfx"
       data-start="121.4" data-duration="0.4" data-track-index="12" data-volume="0.22"></audio>
```

Contract points:
- `data-duration` is **required** on a sub-comp host, or the card never leaves.
- Give every host a unique id and prefix ids inside the sub-comp (`#counter-num`) — ids must be unique across the **assembled** page.
- The sub-comp's timeline cannot touch host-root elements; keep the card's animation entirely inside `compositions/counter.html`, timed scene-locally (0.0 = the host's `data-start`).
- Put the sub-comp's `<style>`/`<script>` **inside** the `<template>`; the assembler drops the file's own `<head>`. GSAP must load from a **local** path — CDN is blocked by the egress allowlist.
- Land the exit before the host's `data-duration`; the window is half-open.

**If you use a persistent chyron instead** (only for N ≤ 5), do **not** copy the single-element `textContent`-in-`onStart` pattern from `compositions/captions.html`: because the box is reused and the text is written in a tween's `onStart`, a **backwards seek or a seek landing between items does not restore the correct text**. For a counter that must be right at every seeked frame, author **one element per ordinal** with its own opacity envelope and let only visibility change.

**ffmpeg** — the subtractive work that makes `first_item_by` achievable:

```bash
node <SKILL_DIR>/scripts/transcript-cut.mjs --input aroll.mp4 --transcript aroll.transcribe.json \
  --remove-fillers "um,uh,basically,you know" --cut-silence 0.3 --plan
# inspect the kept-segment JSON, then re-run with --out. Do not use --copy for sub-second cuts.
```

**Epidemic Sound** — one counter sound, reused for every item (reuse is correct: the repetition is the structure):
`SearchSoundEffects({ query: { term: "ui pop click short" }, filter: { duration: { min: 100, max: 500 } }, first: 8 })` → `DownloadSoundEffect` to `assets/sfx/pop.wav`. Vary nothing between items; if you must, vary only pitch by ±1 semitone, never the sound.

**Remotion**: `items.map((it,i) => <Sequence from={starts[i]} durationInFrames={66}><Counter ordinal={i+1} total={N}/></Sequence>)`; concept only.

## Pairs with
[[struct-name-define-demonstrate]] · [[struct-numbered-list-mid-roll-sponsor]] · [[struct-outcome-first-cold-open]] · [[struct-demand-hook-competence-gap]] · [[struct-stimulation-budget]] · [[struct-objection-character-cutaway]] · [[sfx-riser-anticipation-build]]

## Failure modes
- **Promising 10 and shipping 8.** The one error a viewer reliably notices, and it costs the channel's credibility, not just the video's retention. Correction: count the modules before render; change the promise, not the count in the graphic.
- **Saving the best for last.** By item 10 most of the audience has gone, so the strongest item is delivered to the fewest people and the scarcity claim went unvalidated for everyone who left. Correction: move it to position 2–4.
- **Persistent counter on a long list.** "2 / 12" at minute one tells the viewer there are ten more to sit through. Correction: per-item card only, above N = 5.
- **Scarcity clause over obvious content.** "Nobody tells you… to cut out the dead space." Correction: either find a genuinely non-obvious item or drop the clause; a false scarcity claim is worse than no claim.
- **Authority anchor that is a paragraph.** Correction: one clause, under ten words, adjacent to the numeral.
- **Item 1 arriving at 3 minutes.** All the setup is delivered to an audience that is already halving. Correction: cut setup until item 1 lands before 75 s.
- **A counter card that differs per item.** Different positions or durations break the very tracking the device exists to provide. Correction: one parameterised sub-comp, N instances.
- **Counter via `textContent` in `onStart` on a reused element.** Correct at 1× playback, wrong under seek and in a partially-rendered check. Correction: one element per ordinal.
