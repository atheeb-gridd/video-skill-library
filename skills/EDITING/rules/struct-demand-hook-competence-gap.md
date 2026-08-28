---
id: struct-demand-hook-competence-gap
title: Open with a demand hook stacked on a competence gap
skill: editing
type: retention
family: hook
tags: [skill/editing, type/retention, family/hook, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:00:00
    quote: "This is the most requested video on my channel."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:00:02
    quote: "And why wouldn't it be — in this video we're talking about the one thing that 90% of people can't get right."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:00:06
    quote: "Music."
research_refs:
  - https://prepublish.ai/guides/first-30-seconds
  - https://increditors.com/video-pacing-youtube-retention-science/
  - https://prepublish.ai/guides/youtube-hook-examples
  - https://www.opus.pro/blog/youtube-retention-graphs-explained
difficulty: low
detectable_from: transcript+video
---

# Open with a demand hook stacked on a competence gap

## What it is
Two hooks fired in sequence inside the first seven seconds, before the topic word is spoken. First a **demand hook** — social proof that the audience asked for this ("the most requested video on my channel"). Then a **competence gap** — an implicit accusation the viewer wants resolved ("the one thing that 90% of people can't get right"). Only then, at 00:00:06, the topic: "Music." The ordering is the technique: the viewer is committed to finding out whether they are in the 90% before they know what the subject is, so the subject cannot be the thing they bounce off.

## When to use it
On any video whose topic is a skill the audience believes they already have, or a topic whose bare name is not itself a hook ("music", "captions", "lighting"). Also use it on a topic the channel has previously covered — the demand hook launders the repetition into a service. It is a poor fit where the topic name *is* the hook (a named product, a shocking event, a number), where inverting the order and leading with the subject is stronger. Never claim demand you do not have: the demand hook is checkable and a false one costs trust permanently.

## How to recognise it in a reference video
- **Read the first 15 seconds of transcript with a stopwatch** and mark three timestamps: `t_hook1` (first claim), `t_hook2` (second claim), `t_topic` (the first frame the subject is named).
- **Signature:** `t_hook1 ≤ 2s`, `t_hook2 ≤ 4s`, `t_topic` between 4s and 10s, with **no** other content in between. The source's numbers are 0s / 2s / 6s.
- **Two claim types before the topic** is what distinguishes this from a plain curiosity hook. Classify each: demand/social proof ("most requested", "you all asked"), competence gap ("90% get this wrong", "nobody tells you"), stakes, contrarian, or curiosity.
- **Topic word delivered as a one-word cue.** Look for a single-word or two-word transcript cue at `t_topic` sitting alone — often with a title card, a hard music entry, or a hit on the same frame.
- **Cut density in the hook runs above the body.** Measure CPM over 0–15s and over the body; a deliberate hook is typically 1.5× the body CPM.
- **Look for the second promise between 10s and 20s** — the source adds "10 points that nobody will tell you even in a paid course" at 00:00:14 plus an authority anchor ("six years of video editing experience") at 00:00:42. That is the commitment hook phase, and it is part of the same structure.
- **Audio tells:** a riser or hit on `t_topic`; a bed that enters (not fades) on the topic word; often silence or near-silence under hook 1 so the first line lands dry.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `t_hook1` | 0s (frame 0) | 0–1s | First word on the first frame. No logo sting before it. |
| `t_hook2` | 2.0s (60f) | 1.5–4s | The second claim must land before the viewer's first exit decision. |
| `t_topic` | 6.0s (180f) | 3–10s; hard ceiling 15s | Scripts that deliver a value claim inside 15s retain 52% on average vs 44% for those that do not. |
| `hook_word_budget` | 30 words | 20–45 words | Everything before `t_topic`. At 165 WPM, 30 words ≈ 11s, so keep it under 20 for a 6s reveal. |
| `hook_cpm` | 1.5× body CPM | 1.0–2.5× | Visual change rate across 0–15s. |
| `max_shot_in_hook` | 60f (2s) | 30–90f | No single hook shot should outstay 2 seconds. |
| `commitment_hook_at` | 14s (420f) | 10–20s | The third beat: the specific promise (item count, what they will be able to do). |
| `authority_anchor_at` | 42s | 20–60s | After the promise, not before. Credentials do not hook; they justify. |
| `topic_reveal_treatment` | one-word cue + title card + hit | — | The reveal should be marked, not merely spoken. |
| `bed_entry` | on `t_topic` | — | Enter the bed on the reveal frame rather than fading it up under the hook. |

## Reproduction prompt

```
Build the cold open for this video.

1. Write the two hooks. Hook 1 = demand or social proof, one sentence, must
   be literally true and checkable. Hook 2 = competence gap: a proportion of
   people who get this wrong, or a thing nobody tells you. Total budget
   before the topic reveal: 30 words maximum.
2. Place hook 1's first word on frame 0. No logo, no sting, no b-roll
   pre-roll. Place hook 2 starting at 60 frames (2.0s).
3. Reveal the topic at 180 frames (6.0s), as a one- or two-word line
   delivered alone. Hard ceiling 450 frames (15s); if the script cannot get
   there, cut words from hook 2, not from the reveal.
4. Mark the reveal on three tracks at the same frame 180: a hard picture cut
   (or a title card animating in over 6 frames, power3.out), the music bed
   ENTERING at -22 dB (linear 0.079), and one impact hit at -15 dB relative
   to dialogue whose transient sits on frame 180, not after it.
5. Keep the hook's visual change rate at ~1.5x the body's cuts-per-minute
   and no single shot longer than 60 frames.
6. Add the commitment hook at ~420 frames (14s): the specific promise
   (how many items, what they will be able to do). Put any authority anchor
   AFTER it, around 42s.
7. ACCEPTANCE TEST: read the transcript of the first 15 seconds aloud with a
   stopwatch. Hook 1 must start at 0.0s, hook 2 by 4.0s, topic named by
   10.0s, promise by 20.0s. Then watch muted: the reveal frame must be
   visually distinct (cut, card or scale change) without any audio. Then
   watch with sound: the bed must enter on the reveal, not before. If any
   claim in the hook is not literally true, delete it.
```

## Execution spec

**HyperFrames (assembly).** Seconds, with frames as comments. The reveal is three elements landing on the same number:
```html
<!-- hook shots -->
<video id="hook-1" src="aroll.mp4" muted playsinline class="clip"
       data-start="0"   data-duration="2.0" data-media-start="12.4" data-track-index="0"></video>
<video id="hook-2" src="aroll.mp4" muted playsinline class="clip"
       data-start="2.0" data-duration="4.0" data-media-start="31.8" data-track-index="0"></video>
<!-- reveal at 6.0s = frame 180 -->
<div id="topic-card" class="clip" data-start="6.0" data-duration="2.2" data-track-index="2"
     style="z-index:50;"><span id="topic-word">Music</span></div>
<audio id="bed-open" src=".media/audio/bgm/open.wav" data-audio-group="music"
       data-start="6.0" data-duration="48" data-media-start="1.8"
       data-track-index="11" data-volume="0.079"></audio>
<audio id="hit-reveal" src="assets/sfx/impact.wav" data-audio-group="sfx"
       data-start="6.0" data-duration="1.4" data-track-index="12" data-volume="0.178"></audio>
```
```js
// title card in over 6 frames = 0.2s, house settle
tl.fromTo("#topic-word", { autoAlpha: 0, y: 14, scale: 0.96 },
  { autoAlpha: 1, y: 0, scale: 1, duration: 0.2, ease: "power3.out" }, 6.0);
tl.to("#topic-word", { autoAlpha: 0, duration: 0.18, ease: "power2.in" }, 8.0);
```
`autoAlpha` on `#topic-word` (an inner span) is legal; on the `.clip` container it is not. `fromTo`, never `from`. Land the exit before the clip's `data-duration` — the window is half-open. The SFX transient must be at the *head* of the file, or offset it with `data-media-start` so the peak, not the file start, sits on 6.0 — see [[sfx-whoosh-transition-movement-reveal]].

**Levels.** `data-volume` is linear; dB→linear is `10^(dB/20)`. Dialogue 0 to −3 dB = 1.0–0.71, SFX −12 to −15 dB = 0.251–0.178, music −22 to −25 dB = 0.079–0.056. Carve the bed against the `voiceover` group rather than ducking it.

**ffmpeg.** The hook is where the subtractive pass matters most; every filler syllable before `t_topic` costs reveal time:
```bash
node <SKILL_DIR>/scripts/transcript-cut.mjs --input aroll.mp4 --transcript aroll.transcribe.json \
  --keep "0-2.0,31.8-36.0" --out hook.mp4
```
`--keep` is inverse mode and is mutually exclusive with the removal flags. Use `--plan` first.

**Epidemic Sound.** `SearchSoundEffects { query.term: "cinematic impact hit trailer", filter.duration {max: 2500}, sort {by: POPULARITY, order: DESCENDING} }` for the reveal hit; bed per [[pace-bpm-matched-music-selection]].

**Remotion:** trivially portable; no runtime here.

## Pairs with
[[struct-numbered-list-mid-roll-sponsor]] · [[pace-cut-density-from-viewer-intent]] · [[cut-punch-in-emphasis]] · [[sfx-whoosh-transition-movement-reveal]] · [[struct-music-arc-to-narrative-arc]] · [[struct-outcome-first-cold-open]]

## Failure modes
- **A logo sting or brand animation before frame 0's first word.** Spends the most valuable two seconds in the video on nothing. Fix: first word on frame 0; the logo can live at 00:20 or nowhere.
- **Topic reveal past 15 seconds.** The steepest retention decline sits between seconds 10 and 20; a reveal after it arrives to a smaller audience. Fix: cut hook 2, not the reveal.
- **Three or four stacked hooks.** Each additional claim before the topic reads as stalling, and the viewer starts to suspect there is no substance. Fix: exactly two, then the topic.
- **A demand hook that is not true.** Checkable, and fatal to trust when it is checked. Fix: use a competence gap or a curiosity gap instead; they cost nothing to substantiate.
- **Fading the bed up under the hook.** Wastes the reveal's biggest free marker. Fix: enter the bed on the reveal frame.
- **A hook cut at body pacing.** A 4s static opening shot behind a competence-gap claim undercuts the claim's urgency. Fix: hook CPM ≈ 1.5× body, max 60-frame shots.
- **Known gap:** the 52%-vs-44% figure is a single practitioner dataset for "value claim inside 15 seconds", not a controlled study of hook *types*. The stacking order here is the source video's own construction; validate it against the channel's own first-30-second retention curve before treating the ordering as settled.
