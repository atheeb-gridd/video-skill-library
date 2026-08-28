---
id: struct-cta-after-payoff
title: Place the mid-roll CTA immediately after a delivered payoff, and lead with proof
skill: editing
type: retention
family: mid-roll
tags: [skill/editing, type/retention, family/mid-roll, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:04:42"
    quote: "If you follow my channel, you've probably noticed that I've only uploaded three videos. And with those I've gotten over 300,000 views and around 13,000 subscribers."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:04:33"
    quote: "But an animation explained it crystal clear and fast. That's the kind of editing decision you have to make to build a video people can't look away from."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:04:52"
    quote: "What makes it even crazier is that I didn't promote these videos anywhere."
research_refs:
  - https://prepublish.ai/guides/youtube-retention-guide
  - https://sponsorradar.com/insights/youtube-sponsored-video-performance-guide-for-brands
  - https://vidiq.com/blog/post/youtube-8-minute-mid-roll-ads/
  - https://tubemilestone.com/blog/youtube-mid-roll-ads.html
  - https://socialbee.com/blog/cta-youtube/
difficulty: medium
detectable_from: transcript+video
---

# Place the mid-roll CTA immediately after a delivered payoff, and lead with proof

## What it is
A mid-roll pitch — for a product, a cohort, a newsletter, or the channel itself — anchored to the frame where the video has just *proved* something. In the source video the pitch begins one line after an animation payoff has demonstrated the method working, and it opens not with the offer but with numbers: three uploads, 300,000 views, 13,000 subscribers, a prior 60,000-subscriber / 24-million-view channel, and no promotion. Then the offer, then scarcity. The craft move is entirely **position and proof order**; the offer itself is the least interesting part. The mechanism is simple: a viewer who has just received value is the only viewer with an open reason to believe the pitch, and interrupting *before* a payoff spends attention the video has not yet earned.

## When to use it
Whenever the video contains a pitch of any kind that is not the ending. Place it at the first genuine payoff after the video's opening promise has been at least partly delivered — in practice **25–40% of runtime**, and never inside the first 90 seconds. Use it twice at most in a long-form video: one full read after the first payoff, one one-line reminder near the end. Skip it entirely in a video whose promise is not delivered until the end (a single-reveal video); there, the CTA belongs after the reveal, and the video accepts one CTA instead of two. If YouTube mid-roll *ads* are also enabled, note the platform requires an 8-minute minimum runtime for them and will place its own breaks — put your read where it will not collide with a natural ad slot.

## How to recognise it in a reference video
- **Find the payoff, then the pitch, and measure the gap.** In a correctly built video the pitch's first word falls **within 0–8 seconds** of the payoff's last frame. A gap over ~15 s means the pitch is floating and was placed by clock, not by structure.
- **Percentage-through.** Log `pitch_start ÷ runtime`. Correct placement clusters at **0.25–0.40**. Pitches at 0.05–0.15 are the classic retention-cliff position: mid-roll placements between **60 and 180 seconds** coincide with the steepest measured drop-offs.
- **Segment length.** Time from the pitch's first word to the return to content. Standard sponsored integrations run **60–90 s**; a self-promotion read that runs past ~120 s reads as the video's actual purpose.
- **Proof-before-offer order, from the transcript.** Segment the pitch into: proof → offer → scarcity → return. Count numerals in the first three sentences. A proof-led pitch carries **2 or more concrete figures** before the first mention of what is being sold. An offer-led pitch mentions the product in sentence one.
- **Falsifiable specificity.** Proof sentences in the reference name checkable quantities (view counts, subscriber counts, timeframes, "I didn't promote these anywhere") rather than adjectives. Log the count of falsifiable claims; it is the cleanest single quality measure of the segment.
- **Scarcity marker.** Look for a limiting clause near the end ("spots are extremely limited", a deadline, a cohort size). Present or absent is a parameter.
- **Visual and audio signature of the break.** Expect one or more of: a music change or a bed starting under a previously dry section, a framing change (wider, or a different set), a graphic lower-third or a full-frame card, and a *lower* cut density than the body. The last is the giveaway — pitches are cut slower than the content around them.
- **Return marker.** A correctly built segment ends with an explicit re-entry line ("so now let's continue") and usually a hard visual reset back to the body's framing and music. If the video drifts back without a marker, the viewer does not know the pitch is over.
- **Open-loop check.** In the strongest versions, the payoff just before the pitch *closes* one loop while the narration *opens* the next one before the pitch starts, so the viewer has a reason to wait through it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `anchor` | first delivered payoff | — | The pitch is positioned relative to the payoff, not to the clock. Everything else is derived. |
| `gap_after_payoff` | 2 s (60 f) | 0–8 s | Time between the payoff's last frame and the pitch's first word. |
| `pct_through` | 0.30 | 0.25–0.40 | Never below 0.15, and never inside the first 90 s of runtime. |
| `segment_length` | 75 s | 45–90 s | Beyond 120 s expect measurable drop-off. Self-promotion should sit at the shorter end. |
| `proof_claims` | 3 | 2–5 | Falsifiable numeric claims stated **before** the offer. Under 2 and the pitch is assertion. |
| `proof_first` | true | — | Hard rule. No product noun before the second proof claim. |
| `scarcity_clause` | present | present \| absent | One clause, at the end, and true. |
| `offer_sentences` | 3 | 2–5 | What it is, who it is for, what happens next. |
| `cut_density_ratio` | 0.6× body | 0.4–0.8× | The pitch is cut slower than the body. Matching body density makes it feel like content and reads as a bait-and-switch. |
| `music_action` | start or change | start \| change \| continue | A distinct bed marks the break honestly. `continue` only when the body already has an unbroken bed. |
| `visual_marker` | framing change + card | — | Something must signal "this is a different mode". |
| `return_marker` | explicit line + hard reset | — | One line plus a cut back to the body's framing, bed and cut density. |
| `cta_count` | 2 | 1–2 | One full read mid-roll, one ≤10 s reminder at 85–95% through. |
| `open_loop_before` | true | — | Open the next question before the pitch so there is a reason to sit through it. |

## Reproduction prompt

```
Place the mid-roll CTA in this video.

1. Find the anchor. Walk the design document's beat list and mark every
   payoff: a demonstration completed, a before/after shown, a number
   revealed, a promised item delivered. Choose the FIRST payoff whose end
   falls at or after 25% of runtime. If none exists before 40%, the problem
   is the structure - move a payoff earlier rather than moving the CTA
   later.
2. Open a loop in the last content line before the pitch (name the next
   question the video will answer). Then start the pitch {{GAP}} seconds
   after the payoff's last frame - default 2s, never more than 8s.
3. Write the segment in this fixed order and nothing else:
   a. PROOF - 2 to 5 falsifiable numeric claims. Quantities and timeframes
      only, no adjectives. State the least impressive true number rather
      than an unverifiable big one.
   b. OFFER - 2 to 5 sentences: what it is, who it is for, what to do next.
   c. SCARCITY - one true limiting clause (cohort size, deadline, spots).
   d. RETURN - one explicit re-entry line.
   No product noun may appear before proof claim number two.
4. Hold total segment length to 45-90 seconds. Time the read; if it runs
   over 90s, cut the offer section first, never the proof.
5. Cut the segment at 0.6x the body's cut density (if the body is 4 cuts
   per minute, the pitch runs about 2-3). Change ONE visual variable at the
   pitch's first frame: framing, background, or a full-frame card. Start or
   change the music bed at the same frame.
6. At the return marker, reset all three at once: framing, bed and cut
   density go back to the body's values on a single hard cut.
7. Add one reminder CTA of 10 seconds or less at 85-95% of runtime. No
   second full read.
8. ACCEPTANCE TEST: (a) pitch_start / runtime is between 0.25 and 0.40 and
   pitch_start > 90s; (b) the gap from payoff to first word is 0-8s;
   (c) counting from the transcript, at least two numerals appear before the
   first product noun; (d) segment length 45-90s; (e) the segment's cuts per
   minute is 40-80% of the body's; (f) a listener who skipped the pitch can
   still name the open loop it interrupted.
```

## Execution spec

**HyperFrames (assembly).** The pitch is a section boundary, so build it as a **sub-composition** with its own host slot — the contract prefers modular once a project has three or more scene cuts, and a CTA segment is exactly a reusable scene. Keep the audio at the host root so the bed change is authored in one place:

```html
<!-- body … payoff ends at 322.40s -->
<div id="el-cta" data-composition-id="cta"
     data-composition-src="compositions/cta.html"
     data-start="324.40" data-duration="75" data-track-index="1"></div>
<!-- 2.00s gap = 60f @30fps after the payoff. 75s segment. -->

<audio id="bed-body" src="assets/bgm/body.mp3" data-audio-group="music"
       data-start="90" data-duration="234.4" data-track-index="11" data-volume="0.55"></audio>
<audio id="bed-cta"  src="assets/bgm/cta.mp3"  data-audio-group="music"
       data-start="324.4" data-duration="75" data-track-index="12" data-volume="0.55"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```
Two contract notes: the two beds must not share a `data-track-index` if they overlap at all (`duplicate_audio_track`), and the carve settings live on the **bed**, never on a voice, with `sources` naming a **group** rather than a list of clip ids (`audio_carve_ungrouped_sources`). Run `node <SKILL_DIR>/scripts/carve.mjs --comp index.html` after placing.

Inside `compositions/cta.html` (a `<template>`-wrapped root, with its `<style>`/`<script>` **inside** the template — the assembler drops a sub-comp's own `<head>` tags), the proof numbers are counters and the offer is a card. Numbers earn a count-up; use the `counting-dynamic-scale` motion rule by name and keep each arrival under the stagger cap (`items × stagger ≤ ~0.5 s`). Positions inside a sub-comp are **scene-local seconds**, and a sub-comp timeline **cannot** animate host-root elements.

Mark the boundary visually with a registry transition on the way in and out — pick from the five machine transitions and reuse the video's chosen 2–3 types: `push-slide` (0.5 s, medium energy) in, `crossfade` (0.5 s) out is a safe pair. The injector convention is to extend the outgoing slot by the transition duration and pull the incoming slot's `data-start` earlier by the same amount.

**ffmpeg.** Only for measurement and for cutting the read from the raw take:
```bash
# where is the pitch, in percentage terms?
ffprobe -v error -show_entries format=duration -of csv=p=0 final.mp4
# cut density inside the segment vs the body
ffmpeg -ss 324.4 -t 75 -i final.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep -c lavfi.scd
```

**Epidemic Sound.** A distinct bed marks the break: `SearchRecordings { query.term: "clean confident corporate underscore", filter { bpm: 95-115, vocals: false } }`. Instrumental is mandatory — the whole segment is voice. Use `SearchSimilarToRecording` against the body's bed if you want the change to feel like a modulation rather than a different video.

**Remotion:** the segment maps to a `<Sequence>` with its own audio; no Remotion runtime in this project.

## Pairs with
[[struct-numbered-list-mid-roll-sponsor]] · [[struct-stimulation-budget]] · [[struct-outcome-first-cold-open]] · [[struct-credibility-anchor]] · [[struct-enumerated-promise-and-counter]] · [[pace-cut-density-from-viewer-intent]] · [[sfx-music-sets-the-mood]] · [[struct-music-arc-to-narrative-arc]]

## Failure modes
- **Pitching before the first payoff.** The viewer is asked to buy on the strength of a promise. Retention data puts the steepest cliffs at mid-roll breaks between 60 and 180 s, and the documented fix is precisely to move the break to after the first payoff lands. Fix: move the pitch, or move a payoff earlier.
- **Offer-led opening.** "I've built a course that…" in sentence one triggers the skip reflex before any reason to stay exists. Fix: two numbers first, product noun second.
- **Unfalsifiable proof.** "Thousands of students" and "insane results" are noise; "three uploads, 300,000 views, no promotion" is proof. Fix: replace every adjective in the proof block with a quantity, and prefer a smaller true number to a vague large one.
- **Overrunning.** A 3-minute read inside a 12-minute video makes the video the ad. Fix: 90 s ceiling; cut the offer, not the proof.
- **No mode change.** A pitch cut and scored exactly like the body reads as a bait-and-switch when the viewer realises. Fix: change framing and bed at the first frame, and slow the cut density.
- **No return marker.** Without an explicit re-entry the audience assumes the pitch is still going and leaves after it ends. Fix: one line plus a simultaneous reset of framing, bed and density.
- **Two full reads.** The second one costs more than it earns. Fix: one full read plus a ≤10 s reminder late.
- **False scarcity.** A limit that is not real is the one failure here that damages the channel rather than the video. Fix: state the actual constraint, or omit the clause.
- **Known gap:** no public dataset measures retention loss as a function of CTA position and length. The 0.25–0.40 placement window and the 60–90 s length come from a retention-benchmark guide and a sponsorship performance guide respectively; the 4–8 point lift figure cited for re-engagement beats at the 25–30% and 65% marks is from the same benchmark guide and is not CTA-specific. Treat all of these as priors and replace them with the channel's own retention graph for a published video containing a mid-roll.
