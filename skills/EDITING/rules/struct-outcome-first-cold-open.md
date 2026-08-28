---
id: struct-outcome-first-cold-open
title: Open on the outcome, transfer it, then name the deliverable
skill: editing
type: structure
family: hook
tags: [skill/editing, type/structure, family/hook, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:00:00"
    quote: "Imagine your editing being so good that your viewers literally can't help but watch all the way to the end. That's what I want for you, too. So I took my years of experience in video editing and boiled it down into a formula with four pillars."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:00:12"
    quote: "And you'll want to take notes today, because we're going way deeper than basics like cutting out the dead space."
research_refs:
  - https://prepublish.ai/guides/first-30-seconds
  - https://www.retentionrabbit.com/blog/2025-youtube-audience-retention-benchmark-report
  - https://air.io/en/youtube-hacks/advanced-retention-editing-cutting-patterns-that-keep-viewers-past-minute-8
difficulty: medium
detectable_from: transcript+video
---

# Open on the outcome, transfer it, then name the deliverable

## What it is
A four-beat cold open that never states the topic. Beat 1 describes the end state the viewer wants, in the second person and in the present tense ("imagine your editing being so good that..."). Beat 2 hands that state to the viewer explicitly ("that's what I want for you, too"). Beat 3 names a **countable, structured deliverable** that will produce it ("a formula with four pillars"). Beat 4 sets stakes and asks for commitment ("take notes, because we're going way deeper than basics"). The topic is never announced, because a topic is a category and an outcome is a reason to stay.

## When to use it
This is the default opening for any long-form instructional or "how-to" video where the viewer arrived with a problem. Use it when the video has a genuinely structured payload (a formula, a framework, a numbered list, a process) — beat 3 collapses without one. Do not use it for a companionship/vlog format, where the correct opening is *in medias res* with no promise at all; and do not use it where the video's real value is a single fact, because the outcome-first frame writes a cheque a thin payload cannot cash.

## How to recognise it in a reference video
Timestamp the four beats from the transcript, then check the video track.

- **Beat 1 — outcome, 0.0–5.0 s.** Second person, desired end state, no topic noun. Signal words: "imagine", "picture", "by the end of this video you'll", "what if your…". **The word for the video's subject does not appear.**
- **Beat 2 — transfer, 4.0–8.0 s.** One short sentence handing it over: "that's what I want for you", "and that's exactly what you're getting". Often the shortest line in the video.
- **Beat 3 — deliverable named, by 15.0 s (usually 6–10 s).** A noun phrase with a *count* in it: "a formula with four pillars", "10 points", "three moves". Nearly always accompanied by a title card or a graphic enumerating the parts.
- **Beat 4 — stakes / commitment, 10.0–20.0 s.** An instruction to the viewer ("take notes") plus an explicit escalation above the obvious ("way deeper than basics like cutting out the dead space") — i.e. it names and dismisses the cheap version of the topic.
- **Cut density in the cold open.** Denser than the body: expect a visual change every **10–15 s** minimum, often every **3–6 s**, even in a format whose body runs slow.
- **Dead air.** Effectively zero. Inter-word gaps under **0.25 s**; no breath, no ramp-up sentence, no "hey guys".
- **Audio track.** Music bed frequently enters at beat 3 (the deliverable), not at 0 — the entry is the reward for staying. A soft riser or hit under the deliverable card is common.
- **Retention corroboration.** If analytics are available, the steepest single drop sits between **10 s and 20 s** with inflection near 15 s; a video that names its deliverable after 15 s shows a visibly deeper notch there.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `beat1_outcome_out` | 5.0 s (150 f) | 3.0–6.0 s | Longer than 6 s and beat 3 slips past the deadline |
| `beat2_transfer_out` | 6.5 s (195 f) | 5.0–8.0 s | One sentence, ≤ 8 words |
| `beat3_deliverable_at` | 7.0 s (210 f) | 5.0–15.0 s | **Hard ceiling 15.0 s.** Under 10 s earns a measurable bonus |
| `beat4_stakes_out` | 18.0 s (540 f) | 12.0–22.0 s | Includes the "deeper than basics" dismissal |
| `cold_open_total` | 20 s (600 f) | 15–30 s | Body pacing begins after this |
| `cold_open_cut_interval` | 4.0 s (120 f) | 3.0–15.0 s | Denser than the body's `visual_change_interval` |
| `max_inter_word_gap` | 0.25 s (7.5 f) | 0.15–0.35 s | Feed to `transcript-cut.mjs --cut-silence` |
| `deliverable_card_in` | beat3 + 0.2 s | +0.1–+0.4 s | Card lands just after the count is spoken, never before |
| `deliverable_card_hold` | 2.5 s (75 f) | 2.0–4.0 s | Long enough to read the enumeration |
| `music_bed_in` | at beat 3 | beat 1–beat 4 | Entering at the deliverable is the strongest default |

## Reproduction prompt

```
Build a four-beat outcome-first cold open from a word-level transcript.

1. Locate or write the beats and record in/out word indices:
   B1 OUTCOME ({{IN}} -> 5.0 s): second-person description of the end state the viewer wants,
     present tense, opening on "imagine"/"picture". Contains NO noun naming the topic.
   B2 TRANSFER (-> 6.5 s): one sentence, <=8 words, handing that state to the viewer.
   B3 DELIVERABLE (fires at {{B3}}, default 7.0 s, HARD CEILING 15.0 s): names a countable
     structured payload - "a formula with four pillars", "10 points", "three moves".
   B4 STAKES (-> 18.0 s): an instruction to the viewer plus a line that names and dismisses the
     cheap version of the topic.

2. Cut every inter-word gap over 0.25 s (7 f) across the cold open. Delete any greeting, channel
   intro or ramp-up sentence outright.

3. A visual change at least every 120 f (4.0 s) inside the cold open even if the body runs
   slower; never hold one static A-roll frame past 150 f here.

4. At {{B3}} + 0.2 s bring up a card that ENUMERATES the deliverable and hold it 75 f. Entrance
   0.4 s power3.out, items staggered 0.12 s with the group landing inside 0.5 s, exit 0.25 s
   power2.in. Never before the count is spoken.

5. Start the music bed at {{B3}}, not at 0, carved against the voiceover group at strength 0.25.
   Land one hit or riser tail exactly on {{B3}}.

Acceptance test: from the first 15 s of transcript alone a viewer must be able to state what they
will be able to do afterwards and how many parts the answer has. Topic noun before 5.0 s -> rewrite
B1. Count after 15.0 s -> the cold open fails.
```

## Execution spec

**ffmpeg / transcript-cut** — the subtractive pass that makes the timing possible:

```bash
npx hyperframes transcribe aroll.mp4 --engine auto   # word-level {text,start,end}
node <SKILL_DIR>/scripts/transcript-cut.mjs \
  --input aroll.mp4 --transcript aroll.transcribe.json \
  --remove "0-3.2" \
  --remove-fillers "um,uh,so,basically" \
  --cut-silence 0.25 \
  --plan                                 # inspect the kept-segment JSON first
# then re-run without --plan and with --out coldopen.mp4 ; do NOT pass --copy (keyframe snap
# can swallow a sub-second cut; the script reports copy_drift when it does)
```

**HyperFrames** — the cold open as its own sub-composition so the beat boundaries are legible and the deliverable card can be re-timed independently:

```html
<!-- index.html -->
<div id="el-coldopen" data-composition-id="coldopen" data-composition-src="compositions/coldopen.html"
     data-start="0" data-duration="20" data-track-index="1"></div>

<audio id="vo-coldopen" src="assets/coldopen.wav" data-audio-group="voiceover"
       data-start="0" data-duration="20" data-track-index="10"></audio>

<!-- bed enters at beat 3, carved against the voice -->
<audio id="bed" src="assets/bgm/bed.mp3" data-audio-group="music"
       data-start="7" data-duration="180" data-track-index="11" data-volume="0.6"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
<audio id="sfx-hit-b3" src="assets/sfx/hit.wav" data-audio-group="sfx"
       data-start="7" data-duration="1.2" data-track-index="12" data-volume="0.35"></audio>
```

Inside `compositions/coldopen.html` (template-wrapped root, scoped CSS inside the template, **local** GSAP script — `cdn.jsdelivr.net` is blocked by the egress allowlist), the deliverable card as scene-local time:

```js
const tl = gsap.timeline({ paused: true, defaults: { duration: 0.4, ease: "power3.out" } });
// B3 at global 7.0s == scene-local 7.0s (this slot starts at 0)
tl.fromTo("#card .pillar", { y: 32, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, stagger: 0.12 }, 7.2);
tl.to("#card .pillar", { autoAlpha: 0, duration: 0.25, ease: "power2.in" }, 9.5);
window.__timelines["coldopen"] = tl;
```

Remember: root `data-duration` is compile-time-locked and cannot be varied by `--variables`; the cold open's length is fixed at authoring time. Run `npx hyperframes snapshot --at 3,6,7.5,12,18` (off-VM per §9) and check the beats land.

**Epidemic Sound** — the deliverable hit and the bed:
`SearchSoundEffects({ query:{ term:"cinematic impact hit short" }, filter:{ duration:{ min:400, max:1500 } } })`
`SearchRecordings({ query:{ term:"driving confident tutorial bed" }, filter:{ bpm:{ min:100, max:120 }, vocals:false } })` — BPM matched to delivery per [[sfx-music-audition-against-picture]].

**Remotion**: the same four beats as a `<Sequence>` per beat with `from` in frames; concept only.

## Pairs with
[[struct-enumerated-promise-and-counter]] · [[struct-demand-hook-competence-gap]] · [[struct-stimulation-budget]] · [[struct-name-define-demonstrate]] · [[cut-punch-in-emphasis]] · [[sfx-riser-anticipation-build]] · [[pace-overlay-instead-of-cut]]

## Failure modes
- **Naming the topic in beat 1.** "Today we're talking about editing" is a category, not an outcome, and it forfeits the whole structure. Correction: rewrite so the first sentence contains no noun for the subject.
- **Deliverable after 15 s.** The count lands in the middle of the steepest drop and does no work. Correction: move it before 10 s, cutting beat 1 down if necessary.
- **A deliverable with no count.** "A framework for better editing" gives the viewer nothing to track. Correction: commit to a number, and make sure the body actually has that many parts — see [[struct-enumerated-promise-and-counter]].
- **Beat 4 without the dismissal.** "Take notes" alone is a request, not a stake. Correction: name the obvious/cheap version of the topic and explicitly go past it.
- **Music from frame 0.** Spends the bed's entrance before there is anything to reward. Correction: enter at beat 3.
- **Card lands before the count is spoken.** Reads as a mismatch and steals the line. Correction: card in at `beat3 + 0.2 s`, never earlier.
- **A tight cold open followed by a slack body.** The viewer feels the deceleration as a bait-and-switch. Correction: hold the body to the profile's `visual_change_interval`; only the *cut interval* relaxes, never the dead-air policy.
