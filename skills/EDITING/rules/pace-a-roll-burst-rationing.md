---
id: pace-a-roll-burst-rationing
title: A-roll in short bursts — ration the face to the lines that matter
skill: editing
type: pacing
family: footage-mix
tags: [skill/editing, type/pacing, family/footage-mix, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:24"
    quote: "A-roll. This is footage where you can see and hear the subject at the same time. It feels personal and holds attention really well when you're speaking confidently. Use it in short bursts when you're saying something important."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:09"
    quote: "But if the video cut between A-roll, B-roll and other footage every few seconds, it would hold attention way better."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:50"
    quote: "It's more interesting than A-roll, so use it as often as you possibly can."
research_refs:
  - https://captions.ai/blog/practical-guide-b-roll-video
  - https://air.io/en/youtube-hacks/advanced-retention-editing-cutting-patterns-that-keep-viewers-past-minute-8
  - https://pixflow.net/blog/youtube-video-retention-editing/
  - https://monitoryt.com/blog/editing-for-retention
  - https://tryarticulate.app/blog/what-ai-speech-analysis-reveals-about-habits-worlds-top-speakers
  - https://thespeakerlab.com/blog/average-words-per-minute-speaking/
difficulty: low
detectable_from: transcript+video
---

# A-roll in short bursts — ration the face to the lines that matter

## What it is
A-roll is defined in the source as footage where you **see and hear the subject at the same time**. Its one advantage over every other footage type is that it is *personal* — a face delivering a line is the only shot that carries a person. Its disadvantages are that it is slower than B-roll at conveying information, that it is the least visually new thing in the video (the frame does not change while it runs), and that its whole value is contingent on delivery: it *"holds attention really well **when you're speaking confidently**"*. The rule that follows is a rationing rule, not a ban. A-roll is spent in short bursts on the lines that need a human being attached to them — the claim, the promise, the opinion, the turn — and everything explanatory is handed to B-roll, stock or motion graphics. This is the "visual variety" pillar applied to a specific footage type: A-roll is the pillar's most expensive currency.

## When to use it
Choose A-roll for a specific beat when at least one of these is true: the line is a **claim or an opinion** the presenter must own; it is the **promise or the payoff** of a section; it is a **direct address** to the viewer (a question, a CTA, a challenge); it is a **transitional/structural line** ("but here's the part nobody tells you") whose job is to reset attention with the presenter's face; or the take is simply **so well delivered** that cutting away costs more than it gains. Hand the beat to B-roll or a graphic when the line names a thing that can be shown, lists steps, or is *"an important but boring moment"* — the source's own example is a plot beat that A-roll would have made *"too slow or horribly confusing"* and an animation made *"crystal clear and fast."* Do not use A-roll as the default that plays whenever no B-roll was found — that is the failure this rule exists to prevent. And do not swing to the opposite extreme: the source explicitly warns *"there's also a downside to switching what's on screen too often."*

## How to recognise it in a reference video
You are measuring three things: the A-roll **share**, the A-roll **burst length distribution**, and whether the bursts land on **important lines**.

- **Segment the timeline into A-roll vs not-A-roll.** A-roll = the speaking subject visible and their sync sound present. In practice: a face-forward framing that persists while the voice continues and whose lip movement correlates with the audio. Detect candidates with shot changes plus a face-presence pass, then confirm against the transcript.
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ```
- **A-roll share of runtime.** Talking-head/tutorial creator work clusters around the published **60/40 rule** (≈60% A-roll, 40% B-roll); documentary-leaning work runs 50/50 or B-roll heavy. A reference practising *this* note's discipline runs **A-roll 30–55%**. Above ~70% the video is a webcam recording with decoration; below ~20% the presenter has effectively disappeared and the personal advantage is gone.
- **Burst length distribution — the load-bearing measurement.** Log every uninterrupted A-roll run in frames. A rationed edit has a **median burst of 90–240 f (3–8 s)** and a long tail that rarely exceeds **360 f (12 s)**. Compare against the published talking-head baselines: a calm talking-head edit sits at **15–25 s per cut** and a fast explanation at **10–15 s** — anything in *those* bands is an unrationed edit, not a burst.
- **Visual-change clock.** Independently of A-roll, log time between *any* on-screen change (cut, insert, punch-in, graphic build). Published bands: **5–7 s** in aggressive creator work, **10–20 s** in the first three minutes, **25–40 s** mid-video for 25+ audiences. A long A-roll burst that is subdivided by punch-ins is not the same failure as a static one — log the punch-ins ([[cut-punch-in-emphasis]]).
- **Do the bursts carry important lines?** Align burst boundaries to the transcript and classify each burst's content: claim / promise / opinion / direct address / structural turn / explanation / list / definition. In a well-rationed reference, **≥70%** of A-roll bursts fall in the first five categories and explanation/list beats are almost entirely under B-roll.
- **Delivery-confidence gate, and it is measurable.** For each candidate burst compute, from the word-level transcript and the audio: **speaking rate** (target **150–165 wpm**; 163 wpm is the published TED average), **filler-word share** (elite ≈ **1 filler/min** and **below 1.3% of words**; average speakers run ~5/min), **longest silent gap** inside the burst (top speakers keep pauses **under 2 s**), and **pitch variance** (top performers run **~30% above** their own conversational baseline). A burst that fails two or more of these is a take the frame should not be held on — cut away or replace the take.
  ```bash
  ffmpeg -i ref.mp4 -vn -ar 16000 -ac 1 ref.wav   # then word-level transcribe
  ```
- **Punch-in correlation.** The source's own habit is a close punch-in on the face for important A-roll lines. A high correlation between punch-ins and the important-line classification is strong evidence the reference is rationing deliberately.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `aroll_share` | 0.45 | 0.30–0.55 | Fraction of runtime on A-roll. Published 60/40 rule is the *loose* end; 0.70+ reads as an unedited recording. |
| `burst_len` | 150 f (5.0 s) | 60–360 f (2–12 s) | Median A-roll run. Claim/opinion 90–180 f · direct address 60–120 f · structural turn 90–150 f. |
| `burst_max` | 360 f (12 s) | 240–540 f | Hard ceiling without an internal change. Past it, insert a punch-in or cut away. |
| `broll_insert_len` | 90 f (3.0 s) | 45–150 f (1.5–5 s) | Published bands: detail 1.5–3 s · establishing 2–4 s · cutaway 2–5 s · reaction 1–2 s. |
| `visual_change_clock` | 180 f (6 s) | 150–600 f (5–20 s) | Max gap between *any* on-screen change. Tighten to 150–210 f for the first 3 minutes. |
| `important_line_hit_rate` | 0.70 | 0.60–0.90 | Share of A-roll bursts whose content is a claim/promise/opinion/address/turn. |
| `wpm` | 155 | 150–165 | Delivery gate. Slow to ~120 wpm for one emphasised line only. |
| `filler_share` | 0.013 | 0.000–0.020 | Fillers ÷ words inside the burst. Above 0.02, recut or replace the take. |
| `max_internal_pause` | 45 f (1.5 s) | 15–60 f | Silence inside a held burst. Longer gaps belong to [[pace-partial-pause-removal]]. |
| `punch_in_scale` | 1.15 | 1.08–1.30 | Subdivides a long burst without a cut. |

## Reproduction prompt

```
Ration A-roll across the assembled timeline. You have the footage, a
word-level transcript, and a cut list.

1. CLASSIFY EVERY LINE in the transcript into one of: CLAIM, PROMISE,
   OPINION, DIRECT-ADDRESS, STRUCTURAL-TURN, EXPLANATION, LIST, DEFINITION,
   DEMO. Only the first five are eligible to be A-roll.
2. GATE EACH ELIGIBLE TAKE on delivery, computed from the transcript and
   audio: speaking rate 150-165 wpm; filler words under 1.3% of words in the
   span; no internal silence longer than 45 frames (1.5s). A take failing two
   of the three loses the frame - route that line to B-roll or a graphic and
   note it for a re-record.
3. BUILD BURSTS. Target a median A-roll run of 150 frames (5.0s), floor 60
   frames (2.0s), ceiling 360 frames (12s). Never hold a static A-roll frame
   past 360 frames: either cut away or insert a punch-in to scale 1.15 over
   12 frames with ease power3.out.
4. FILL EVERYTHING ELSE. Every EXPLANATION / LIST / DEFINITION / DEMO line
   gets B-roll, stock or motion graphics at 45-150 frames per insert. The
   narration audio is ONE continuous clip; only the picture cuts under it.
5. ENFORCE THE CLOCKS. No gap longer than 180 frames (6s) between on-screen
   changes anywhere; tighten to 150 frames for the first 3 minutes. Total
   A-roll share of runtime must land between 0.30 and 0.55.
6. DO NOT over-cut. Minimum shot length 45 frames (1.5s) for any insert; no
   more than 3 consecutive inserts under 60 frames outside a deliberate
   montage.

ACCEPTANCE TEST: (a) print the A-roll share, the burst-length median and
max, and the longest visual-change gap - all three inside range; (b) every
A-roll burst maps to a CLAIM/PROMISE/OPINION/ADDRESS/TURN line; (c) no line
classified EXPLANATION or LIST plays over a static face; (d) scrub with sound
off - the picture alone should still be changing at least every 6 seconds.
```

## Execution spec

**HyperFrames (primary).** A-roll bursts and B-roll inserts are picture clips on the same track index, authored back to back; the voice is a single long `<audio>` at the root so a cut in the picture never cuts the narration. All times are **seconds** — frames are a comment.

```html
<!-- one continuous narration clip; picture is rationed underneath it -->
<audio id="vo-sec2" src=".media/audio/voice/sec2.wav" data-audio-group="voiceover"
       data-start="42.00" data-duration="38.00" data-track-index="10"></audio>

<!-- A-roll burst: the claim. 5.0s = 150f @30fps -->
<video id="aroll-claim" src="aroll.mp4" muted playsinline class="clip"
       data-start="42.00" data-duration="5.00" data-media-start="214.30" data-track-index="0"></video>
<!-- B-roll under the explanation. 3.0s = 90f -->
<video id="broll-2a" src="broll-desk.mp4" muted playsinline class="clip"
       data-start="47.00" data-duration="3.00" data-media-start="1.20" data-track-index="0"></video>
<video id="broll-2b" src="broll-hands.mp4" muted playsinline class="clip"
       data-start="50.00" data-duration="2.40" data-media-start="6.00" data-track-index="0"></video>
<!-- A-roll burst: the turn -->
<video id="aroll-turn" src="aroll.mp4" muted playsinline class="clip"
       data-start="52.40" data-duration="4.20" data-media-start="301.00" data-track-index="0"></video>
```
Contract facts this leans on: the visibility window is **half-open** `[start, start+duration)`, so `b.start === a.start + a.duration` shares no frame; `data-media-start` + `data-duration` is an in-composition trim needing no new file; `<video>` is `muted` with a separate `<audio>` per project convention; every `<audio>` needs an `id` or it is never mixed and the render is silent; `data-track-index` is display-only, so ordering/layering is CSS, not track number.

Subdividing an over-long burst without a cut is a GSAP tween on the clip, not a new clip:
```js
// punch-in at 12s into a long A-roll burst that starts at 42.0s: 0.4s = 12f
tl.fromTo("#aroll-claim", { scale: 1 }, { scale: 1.15, duration: 0.4, ease: "power3.out" }, 54.0);
```
Never tween `width`/`height`/`top`/`left` (forbidden) and never put a CSS `transform` on the same element (`gsap_css_transform_conflict`, an error).

**ffmpeg.** The A-roll/B-roll classification pass is a measurement job, not a cutting job: `scdet` for shot boundaries, a transcript for line classification. If dead space must physically leave the A-roll before assembly, `transcript-cut.mjs` is the tool:
```bash
node <SKILL_DIR>/scripts/transcript-cut.mjs --input aroll.mp4 --transcript aroll.transcribe.json \
  --remove-fillers "um,uh,like" --cut-silence 0.8 --out aroll.tight.mp4
```
Drop `--copy` for frame-accurate cuts — stream copy snaps to keyframes and the script reports `copy_drift` when it swallows a cut.

**Epidemic Sound.** Not needed for the ration itself. If a burst is being replaced by a graphic beat, that beat needs a motion sound: `SearchSoundEffects { query.term: "subtle ui transition whoosh short" }` at −12 to −15 dB ([[sfx-unsounded-motion-audit]]).

**Remotion:** conceptually one `<Audio>` spanning a series of picture `<Sequence>`s; no Remotion runtime exists in this project.

## Pairs with
[[pace-visual-variety-density-audit]] · [[pace-visual-change-clock]] · [[cut-punch-in-emphasis]] · [[cut-l-audio-trails-picture]] · [[cut-l-voice-over-reenactment]] · [[pace-cut-density-from-viewer-intent]] · [[pace-partial-pause-removal]] · [[struct-demo-before-label]] · [[pace-overlay-instead-of-cut]] · [[sfx-unsounded-motion-audit]]

## Failure modes
- **A-roll as the default filler.** Face plays wherever no B-roll exists, and the ration inverts: the important lines end up under stock footage while the boring ones hold the face. Fix: classify lines first, then assign footage; A-roll is assigned, never defaulted to.
- **Holding a weak take because it was the only one.** The source's condition is *"when you're speaking confidently"* — a hesitant take on the frame costs more than a cutaway. Fix: run the delivery gate (wpm, filler share, internal pause) and route failures away from picture.
- **Bursts too long.** Anything past 12 s static is the unedited-recording signature. Fix: cut away, or punch in at 1.15× to buy another 8–10 s.
- **Bursts too short.** Sub-2-second A-roll flashes read as nervous cutting; the source itself warns against switching what's on screen too often. Fix: 60 f floor, and never three sub-2 s inserts in a row outside a montage.
- **Cutting the narration wherever the picture cuts.** Produces a room-tone step at every insert boundary. Fix: one continuous VO clip, picture cut underneath ([[cut-l-audio-trails-picture]]).
- **Punch-in used as variety rather than emphasis.** A scale change on a throwaway line spends the device and leaves nothing for the claim. Fix: reserve punch-ins for the important-line classification.
- **Known gap — the numbers are not platform data.** One of the sources used here says so directly: *"any 'cut every 10 to 15 seconds for higher retention' rule you see is a marketing claim, not platform data."* The bands in this note are calibrated from published creator practice and the reference video in front of you, and a channel's own retention graph outranks all of them. Always prefer the measured distribution from the reference over these defaults.
- **No automatic face/subject detection in this stack.** Classifying A-roll requires either a vision pass outside HyperFrames or a hand-authored log; the contract lists no face tracking or content-aware analysis. State which was used in the design document.
