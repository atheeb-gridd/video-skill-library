---
id: sfx-riser-credibility-budget
title: A riser is a promise — the credibility budget that keeps it working
skill: sound-design
type: retention
family: riser
tags: [skill/sound-design, type/retention, family/riser, sfx/aesthetic, layer/sfx, engine/hyperframes, engine/epidemic, source/editing-kt, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:11:23
    quote: "First, risers. They build tension and anticipation, because they tell the audience that something really important is about to happen. But only use them when something important actually is about to happen. Otherwise they lose their credibility and stop working."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:02:06
    quote: "Riser sounds are essential to build anticipation and tension. Before a jumpscare, before a big reveal, or before a drop in the music, a riser teases"
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:09:11
    quote: "Mistake number three — the same sound effect repeated again and again"
research_refs:
  - https://en.wikipedia.org/wiki/Habituation
  - https://www.epidemicsound.com/sound-effects/
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
difficulty: medium
detectable_from: transcript+video
---

# A riser is a promise — the credibility budget that keeps it working

## What it is
The riser is the only effect in the library whose power is **spent**. It works because the viewer has learned that this sound is followed by something worth waiting for; every riser placed in front of a non-event repays that learning with nothing, and after two or three unpaid promises the sound stops producing anticipation at all. The creator states the constraint directly: *"only use them when something important actually is about to happen. Otherwise they lose their credibility and stop working."*

This note is the gate that runs **before** [[sfx-riser-anticipation-build]]. That note tells you how to place a riser; this one tells you whether you are allowed to. It converts "something important" into a testable definition and gives a per-video budget, because the failure is not audible in any single riser — it is only visible in the count.

## When to use it
Run this gate at the sound-effect pass, once per candidate riser, and once more over the whole timeline as a count.

A moment qualifies as a payoff if it meets **at least one** of these, verifiably:
- **New information arrives**: a number, a name, a result, a price, the answer to a question the narration explicitly asked.
- **A structural turn**: the video changes section, the argument flips, a before becomes an after.
- **A visual reveal**: something previously hidden or unresolved becomes visible in one frame — a full-screen graphic lands, a product appears, a mask completes.
- **A music event**: the bed drops, changes track, or restarts after a rest window ([[sfx-music-rest-windows]]).
- **A hard tonal jolt**: a smash cut from loud to quiet or the reverse ([[sfx-smash-cut-audio-contrast]]).

It does **not** qualify when: the narration is merely continuing; the next shot is another B-roll of the same thing; the payoff is a sentence rather than an event; the "reveal" is a caption of a word already spoken; or the riser is really covering a transition, which is a whoosh's job.

## How to recognise it in a reference video
- **Count the risers and the payoffs, then divide.** For each detected riser (see the RMS-climb signature in [[sfx-riser-anticipation-build]]), look at the 0–0.5 s window after its peak and mark whether a qualifying payoff lands there. The finding to log is `riser_payoff_ratio = paid / total`. A professional reference scores **1.0**; anything below 0.8 is a video actively burning the device.
- **Riser density.** Count risers per minute of finished runtime. Observed healthy bands: long-form explainer **0.3–0.8 per minute**, short-form **1 per 20–30 s of runtime but rarely more than 2 in a 60 s video**, trailer/hype **up to 3 per minute** because the whole format is promise-and-payoff.
- **Spacing.** Two risers inside 20 s of each other in non-trailer content is the single strongest predictor that the second one will not land. Log the minimum inter-riser gap.
- **Repetition of one file.** If the same riser file is used three or more times, the viewer's ear starts recognising the sound instead of the promise. Detect by cross-correlating the isolated riser segments, or simply by comparing their durations and peak offsets — identical to the millisecond means the same file.
- **Escalation.** In good references the risers get longer and louder as the video progresses; the biggest one precedes the biggest payoff. A video whose first riser is its largest has nowhere to go.
- **On the transcript:** a paid riser almost always sits under a setup clause — "and here's the part that changed everything", "so what actually happened was" — and resolves in the pause before the payoff word. A riser under continuous mid-sentence narration is nearly always unpaid.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `riser_payoff_ratio` (gate) | 1.0 | ≥ 0.8 to ship | Below 0.8, delete unpaid risers rather than adding payoffs. |
| Risers per minute — long-form | 0.5 | 0.3–0.8 | A 10-minute explainer wants 3–6, not 15. |
| Risers per minute — short-form | 1.0 | 0–2 per 60 s | Many strong short-form edits use exactly one, at the turn. |
| Risers per minute — trailer/hype | 2.0 | 1–3 | The only format where back-to-back risers are idiomatic. |
| Minimum inter-riser gap | 25 s | ≥ 20 s | Below this the second riser is heard as texture, not as a promise. |
| Distinct files required | 1 per use | ≥ 3 files per video | Or one file varied by pitch ratio 0.85/1.0/1.15 and by length. |
| Payoff detection window | 0–0.5 s after peak | 0–0.7 s | Beyond ~0.7 s the connection is not made and the riser reads as unresolved. |
| Escalation | monotonic | — | Each successive riser ≥ the previous in length or in peak level; the largest precedes the final payoff. |

## Reproduction prompt
```
Audit and enforce the riser budget on this timeline before any riser is placed.

1. BUILD THE CANDIDATE LIST. From the design document, list every moment currently
   marked for a riser, with its timecode and its stated reason.
2. GATE EACH ONE. A candidate survives only if a qualifying payoff lands within
   0.5 s after where the riser would peak. Qualifying = new information (a number,
   name, result, or the answer to a question the narration asked) OR a structural
   turn OR a one-frame visual reveal OR a music drop/track change OR a smash-cut
   tonal jolt. "The next line is important" does NOT qualify. Write the payoff
   next to each survivor in one clause; if you cannot write it, the candidate fails.
3. APPLY THE DENSITY BUDGET. Long-form: 0.3-0.8 risers per minute. Short-form:
   at most 2 per 60 s. Trailer: up to 3 per minute. If over budget, cut the
   weakest payoffs first, not the ones that are hardest to place.
4. APPLY THE SPACING RULE. No two risers within 25 s (20 s absolute floor) outside
   trailer content. If two survive inside that window, keep the one whose payoff is
   more structural and give the other a hit alone, with no build in front of it.
5. ENFORCE VARIETY. Assign a different riser file per use, up to three; beyond
   three uses, reuse a file only after varying it — pitch ratio 0.85 or 1.15 via
   ffmpeg rubberband, or a different body length. Never place the same file twice
   inside 90 s.
6. ORDER BY ESCALATION. Sort the surviving risers by payoff importance and assign
   body lengths in ascending order (e.g. 1.5 s, 2.5 s, 4 s), so the largest build
   precedes the largest payoff.
7. EMIT the surviving list as riser events with {time, body_length, payoff_reason,
   file_id} and hand it to the placement note.
8. ACCEPTANCE TEST: riser_payoff_ratio == 1.0; no gap under 20 s; no file used more
   than twice; body lengths non-decreasing across the video. Then, and only then,
   place them per sfx-riser-anticipation.
```

## Execution spec

**Hyperframes.** The budget is a planning artefact, not an attribute, so record it where the plan lives: as frame metadata bullets in `STORYBOARD.md` (`- sfx: riser 2.5s → payoff: revenue number lands`). The parser preserves unknown keys under `extra` and never throws, so a `sfx` key is safe. Do not encode the decision only in the composition — a placed `<audio id="sfx-riser-…">` carries no reason, and the next pass cannot re-audit it. **Known constraint:** the vault cannot delete files, so a rejected riser is recorded as a status change in the storyboard, never by removing an entry.

Counting risers already in a composition is a grep, not a render:
```bash
grep -o 'id="sfx-riser-[^"]*"' index.html | wc -l
grep -o 'data-start="[0-9.]*"' index.html   # then diff consecutive riser starts
```

**Epidemic Sound.** Variety is a fetch problem as much as a placement one. Pull the whole shortlist in one call and keep the ids, so the third riser is not a panic search:
```json
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["designed--riser"] },
              "duration": { "min": 1500, "max": 12000 } },
  "sort": { "by": "POPULARITY", "order": "DESCENDING" }, "first": 12 }
```
Then `SearchSimilarToSoundEffect` on the one you liked to get near-neighbours that differ audibly but sit in the same texture family — this is the cheap route to three distinct risers that still sound like one video. The `designed--riser` tag holds 478 effects, so scarcity is never the reason to reuse a file.

**ffmpeg.** Making variants of one riser when the library is not reachable:
```bash
ffmpeg -i riser.wav -af "rubberband=pitch=0.85" riser_low.wav   # -2.8 semitones
ffmpeg -i riser.wav -af "rubberband=pitch=1.15,rubberband=tempo=1.2" riser_hi.wav
```

**Remotion.** No equivalent concept; the budget is editorial and lives in the plan either way.

## Pairs with
[[sfx-riser-anticipation-build]] · [[sfx-density-fatigue-audit]] · [[struct-stimulation-budget]] · [[sfx-music-drop-on-structure-turn]] · [[sfx-smash-cut-audio-contrast]] · [[sfx-intensify-without-referent]] · [[sfx-cinematic-hit-emphasis]] · [[motion-pattern-interrupt-jolt]] · [[motion-anticipation-build-to-reveal]] · [[pace-cut-density-from-viewer-intent]]

## Failure modes
- **Risers as punctuation.** Using one before every section heading turns the sound into a bullet point. The gate is "would the viewer feel cheated if nothing happened?" — if not, it is punctuation, and a hit or a whoosh does the job without the promise.
- **Retro-fitting a payoff.** Adding a flash or a scale punch purely so a riser has something to land on. If the payoff exists only to justify the sound, the sound was the mistake.
- **Front-loading.** Spending the biggest riser in the first 20 seconds, then having nothing left for the actual turn. Assign lengths after ordering by payoff importance, not in edit order.
- **Riser stacking under a build that already builds.** A bed with its own build plus a riser is two promises for one payoff and the second one is inaudible. Choose one.
- **Auditing by ear only.** The failure is statistical — each individual riser sounds fine. Count them.
- **Known gap:** nothing in the stack validates this. Lint reads only two audio conflicts and never looks at effect semantics, so this audit is a human/agent pass that must be run explicitly before render.
