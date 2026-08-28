---
id: cut-jump-time-compression
title: The jump cut — remove a segment from one shot and splice the ends to jump time
skill: editing
type: cut
family: jump-cut
tags: [skill/editing, type/cut, family/jump-cut, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:47"
    quote: "This cut is when a segment of a shot has been removed and the separate ends have been spliced back together, making the shot feel like it has jumped in time."
research_refs:
  - https://en.wikipedia.org/wiki/Jump_cut
  - https://en.wikipedia.org/wiki/30-degree_rule
  - https://storyenvelope.com/three-basic-rules-of-filmmaking-explained/
  - https://www.videomaker.com/how-to/shooting/visual-storytelling/everything-you-need-to-know-about-the-jump-cut/
  - https://help.editmentor.com/en/articles/4811207-30-degree-rule
difficulty: low
detectable_from: transcript+video
---

# The jump cut — remove a segment from one shot and splice the ends to jump time

## What it is
One continuous shot, a chunk taken out of the middle, the two remaining halves butted together. Because the camera has not moved and the framing has not changed, the discontinuity cannot be read as "a different shot" — so the brain reads it as **time skipping forward** inside the same shot. It is the deliberate violation of the continuity rule that exists to prevent it: the **30-degree rule** says consecutive shots of the same subject must differ by at least 30° of camera position (or, in its "20 mm / 30-degree" form, a comparable focal-length change), precisely because anything less "might be perceived as unnecessary or discontinuous — in short, visible." The jump cut takes that visibility and uses it. Godard's *Breathless* (1960) made it a style; the modern talking-head vlog made it a default.

## When to use it
Three distinct jobs, and it is worth naming which one you are doing. **(1) Compression** — the dominant use in creator video: remove the pause, the restart, the "um", the reach for a word, and let the sentence continue. The jump is the price of a tighter cut and the audience has fully normalised it ([[pace-partial-pause-removal]], [[pace-subtractive-first-pass]]). **(2) Time passage inside a held frame** — the same locked-off shot at 10:00, 10:20, 10:45; the jumps *are* the clock. A dissolve is the soft version of this ([[cut-dissolve-time-passage]]). **(3) Energy and unease** — rapid jumps inside one shot read as nervous, urgent or comic, and draw attention to the fact that this is an edit. Do not use it inside a scene you want to feel observed and continuous, where it reads as a mistake; do not use it to hide a performance problem that a retake would fix; and do not use it where the removal changes what the person is understood to have said.

## How to recognise it in a reference video
- **Scene detection under-reports it.** Because framing barely changes, `scdet` scores at a jump cut are low. Run it with a low threshold and expect false negatives:
  ```bash
  ffmpeg -i ref.mp4 -vf "select='gt(scene,0.04)',metadata=print" -f null - 2>&1 | grep pts_time
  ```
- **The reliable detector is the transcript, not the picture.** Force-align the transcript, then look for places where the **speech is continuous and grammatical but the elapsed audio is shorter than the delivery would allow** — a missing breath, a sentence starting with no inhale, a hard consonant with no room tone before it. A jump cut in a talking head almost always shows up as a room-tone discontinuity of ≥3 dB with no picture change.
- **Background teleport.** Freeze one frame either side. In a true jump cut the subject shifts slightly (head angle, hand position, blink state) while the **background is identical**. That combination — moving foreground, static background, same framing — is the signature.
- **Framing delta is the diagnostic number.** Measure the subject's height in each frame. **Under ~5% change with under ~5° of angle change** = a clean jump cut, reads as intentional. **20% or more size change, or 30°+ angle change** = it reads as a new shot and is no longer a jump cut. **Between 5% and 20% is the dead zone** — it reads as a bump, an accident, a camera nudge. Log which band the reference is in.
- **The axial punch.** Many creator "jump cuts" are actually **axial cuts**: same axis, ~15–25% scale step, so the jump is legitimised as a punch-in ([[cut-punch-in-emphasis]]). Detect by measuring the size step; if it is a clean 1.15–1.25× on the same axis with no lateral shift, log it as axial, not raw.
- **Rate.** Count jumps per minute of A-roll. Tight creator explainers run **6–20 per minute**; a vlog-style rapid delivery can exceed 30; a documentary interview runs 0 because the jumps are covered.
- **Cover check.** Note what fraction of jumps are *covered* by B-roll, a graphic or a scale change versus left raw. That ratio is a style fingerprint — log it as `cover_ratio`.
- **Removed duration.** If you have the source, subtract: removed segments in a compression pass sit at **0.3–3.0 s** each. In a time-passage montage they are minutes.
- **Audio seam.** Listen at the splice for a click or a level step. Professionally handled jumps carry a **2–4 frame** crossfade on the dialogue and continuous room tone underneath.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `framing_delta` | ≤ 5% | ≤5% (jump) or ≥20% (new shot) | 5–20% is the dead zone that reads as an error. The 20% rule spans size, angle, focal length, f-stop and lighting. |
| `angle_delta` | 0° | 0–5° (jump) or ≥30° (new shot) | The 30-degree rule is what a jump cut is defined against. |
| `min_removal` | 8 f (0.27 s) | 6–15 f | Below this the splice reads as dropped frames rather than as an edit. |
| `typical_removal` | 30 f (1.0 s) | 9–90 f | Compression pass. Time-passage montages remove far more. |
| `jumps_per_min` | 10 | 6–20 (explainer) · up to 30 (vlog) · 0 (covered interview) | Measured over A-roll runtime only. |
| `cover_ratio` | 0.4 | 0.0–1.0 | Fraction of jumps hidden by B-roll, a graphic or a scale step. 1.0 = an "invisible" edit; 0.0 = the jump is the style. |
| `axial_step` | 1.18× | 1.15–1.25× | Scale step that converts a raw jump into a legible axial punch. Below 1.10× it is a bump. |
| `axial_direction` | in | in \| out | Punch in for emphasis; punch out to release. Do not alternate randomly. |
| `dialogue_crossfade` | 3 f (0.10 s) | 2–4 f | On the audio splice only. Picture stays a hard cut. |
| `room_tone_bed` | continuous | — | A separate room-tone track under the whole A-roll makes every splice inaudible. |
| `breath_policy` | keep one in three | — | Removing every breath makes the delivery inhuman; that is the commonest over-cut signature. |

## Reproduction prompt

```
Create a jump cut in the single continuous shot {{SRC}} by removing
{{CUT_IN}}-{{CUT_OUT}} (seconds in the SOURCE) and splicing the ends.

1. VERIFY IT IS A JUMP CUT, not a bump. Compare the frame at {{CUT_IN}}
   with the frame at {{CUT_OUT}}: subject size must differ by 5% or less
   and camera angle by 5 degrees or less. If the difference lands between
   5% and 20%, do NOT splice here - move one of the two points until the
   framing matches, or convert it to an axial punch (step 5).
2. VERIFY THE REMOVAL IS LEGIBLE: {{CUT_OUT}} - {{CUT_IN}} must be at
   least 8 frames (0.27s). A shorter removal reads as dropped frames.
3. VERIFY THE SENTENCE. Read the transcript across the removal. The
   spliced text must be grammatical and must not change the meaning of
   what the speaker said. If it does, keep the segment.
4. AUTHOR IT as two clips of the SAME source, back to back on the
   timeline: clip A plays [{{A_IN}} .. {{CUT_IN}}], clip B plays
   [{{CUT_OUT}} .. {{B_OUT}}], and B starts on the timeline exactly where A
   ends - no gap, no overlap.
5. DECIDE COVER. Choose one: (a) leave it raw - the jump is the style;
   (b) scale clip B to 1.18x on the same axis, so the jump reads as an
   axial punch-in; (c) cover the splice with 30-60 frames of B-roll or a
   graphic starting 2 frames BEFORE the splice. Apply the same choice
   consistently across the video.
6. AUDIO: hard-cut picture, but crossfade the dialogue across the splice
   over 3 frames, and run a continuous room-tone bed under the whole
   A-roll so the splice has no level step.
7. ACCEPTANCE TEST: (a) step through the splice frame by frame - the
   background must be identical either side; (b) listen with your eyes
   closed - no click, no room-tone step; (c) read the spliced transcript
   aloud - it must scan as one sentence; (d) count jumps per minute across
   the finished A-roll and keep it inside 6-20 unless the format is a
   deliberately rapid vlog.
```

## Execution spec

**`transcript-cut.mjs` is the jump-cut tool.** It is the one script staged in this project and it exists for exactly this operation — compile a kept-segment list from a word-level transcript, cut each with ffmpeg, concat, atomic-rename:

```bash
node <SKILL_DIR>/scripts/transcript-cut.mjs \
  --input talk.mp4 --transcript talk.transcribe.json \
  --remove "12.41-15.02,88.30-91.70" \
  --remove-fillers "um,uh" \
  --cut-silence 0.8 \
  --plan                              # inspect the kept segments first
node <SKILL_DIR>/scripts/transcript-cut.mjs ... --out talk.cut.mp4
```
`--cut-silence 0.8` removes every inter-word gap longer than 0.8 s and is the fastest route to a compression pass. Two traps from the script itself: **`--copy` cuts only on keyframes** and on sparse-keyframe footage "can silently swallow the whole cut" — it self-reports `copy_drift` above 1 s of error, and the guidance is to drop `--copy` for frame-accurate cuts. And the vault mount **cannot delete files**, so keep the script's scratch directories outside it.

**HyperFrames — the declarative form, no new file.** A jump cut is two clips of the same `src` with two `data-media-start` values, authored back to back. The half-open window `[start, start+duration)` means `b.data-start === a.data-start + a.data-duration` produces **no overlapping frame** — that is exactly the splice.

```html
<!-- source shot; remove source 12.41-15.02 (2.61s = 78f) -->
<video id="ar-1" src="talk.mp4" muted playsinline class="clip"
       data-start="0.00" data-duration="7.41" data-media-start="5.00" data-track-index="0"></video>
<audio id="ar-1-aud" src="talk.mp4" data-audio-group="voiceover"
       data-start="0.00" data-duration="7.41" data-media-start="5.00" data-track-index="10"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:7.31,&quot;v&quot;:1},{&quot;t&quot;:7.41,&quot;v&quot;:0}]}]}"></audio>

<video id="ar-2" src="talk.mp4" muted playsinline class="clip"
       data-start="7.41" data-duration="9.00" data-media-start="15.02" data-track-index="0"></video>
<audio id="ar-2-aud" src="talk.mp4" data-audio-group="voiceover"
       data-start="7.41" data-duration="9.00" data-media-start="15.02" data-track-index="11"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.10,&quot;v&quot;:1}]}]}"></audio>
<!-- 0.10s = 3f @30fps: the dialogue crossfade. Picture is a hard cut. -->
```
Notes that make this actually run: every `<audio>` needs an **`id`** (an id-less audio track is never mixed and renders silent); the two overlapping-in-fade audio clips need **different `data-track-index`** values or lint raises `duplicate_audio_track`; an automation lane's `t` is **clip-local seconds** and **holds its first value backwards** to the clip start, which is why the `{t:0,v:0}` point is what produces the fade-in; and do not also GSAP-tween `volume` on the same element (`audio_volume_double_automation` — the lane wins silently).

**The axial punch variant** — cover the jump with a scale step on the incoming clip's wrapper, on the main timeline, in **seconds**:
```js
// 1.18x punch on ar-2, snapping over 4 frames (0.133s) at the splice
tl.fromTo("#ar-2", { scale: 1.0 }, { scale: 1.18, duration: 0.133, ease: "power4.out" }, 7.41);
```
Wrap `#ar-2` if it is a bare `<video>` carrying `data-start` — a `<video data-start>` inside another timed element is the error `video_nested_in_timed_element`, so time **either** the wrapper **or** the video, never both.

**ffmpeg — the physical splice**, when the cut leaves the pipeline:
```bash
ffmpeg -i talk.mp4 -ss 5.00 -to 12.41 -c:v libx264 -crf 18 -c:a aac p1.mp4
ffmpeg -i talk.mp4 -ss 15.02 -to 24.02 -c:v libx264 -crf 18 -c:a aac p2.mp4
printf "file '%s'\n" p1.mp4 p2.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy talk.cut.mp4
```

**Epidemic Sound.** The room-tone bed that makes every splice inaudible: `SearchSoundEffects { query.term: "room tone quiet interior loop", filter.duration { min: 30000 } }`, placed as one long clip in an `ambience` group at roughly −36 dBFS under the whole A-roll — never in the `voiceover` carve group.

**Remotion:** two `<Sequence>`s over one `<OffthreadVideo>` with different `startFrom`; no Remotion runtime exists here.

## Pairs with
[[pace-partial-pause-removal]] · [[pace-subtractive-first-pass]] · [[cut-punch-in-emphasis]] · [[cut-dissolve-time-passage]] · [[cut-straight-hard-cut]] · [[pace-deliberate-continuity-break]] · [[cut-b-roll-coverage-from-transcript]] · [[cut-continuity-pass]] · [[sfx-ambience-bridge-across-cut]]

## Failure modes
- **The dead-zone splice.** 5–20% framing change reads as a camera nudge or a technical fault rather than an edit. Fix: match the framing to within 5%, or commit to a ≥20% axial step.
- **Removals under 8 frames.** Read as dropped frames or a corrupt file. Fix: either remove enough to be legible, or leave the pause.
- **Cutting the breaths out.** Removing every inhale makes delivery robotic and is the loudest over-editing tell. Fix: keep roughly one breath in three; `--cut-silence 0.8` rather than 0.3.
- **Room-tone steps.** Each splice lands a different noise floor and the video ticks. Fix: continuous room-tone bed plus a 3-frame dialogue crossfade.
- **Meaning drift.** A grammatical splice that changes what the speaker said is an ethical failure, not a style one. Fix: read the spliced transcript before rendering.
- **Inconsistent cover policy.** Some jumps punched, some covered, some raw, at random. Fix: pick one `cover_ratio` and apply it.
- **`--copy` on sparse-keyframe footage.** The cut snaps to a keyframe and can swallow the whole removal. Fix: drop `--copy`, or check the script's `copy_drift` report.
- **Known gap:** nothing in this stack measures framing delta across a splice. The 5%/20% test has to be done on exported stills; `scdet` will not flag a well-matched jump cut at all.
