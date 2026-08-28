---
id: cut-straight-hard-cut
title: The straight cut — picture and sound switch on the same frame
skill: editing
type: cut
family: hard-cut
tags: [skill/editing, type/cut, family/hard-cut, layer/dialogue, layer/ambience, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:29"
    quote: "The cut is an instant switch between one shot to another, including audio."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:18"
    quote: "Number one is the cut. The most basic type of edit."
research_refs:
  - https://www.avid.com/pro-tools/user-guide/how-to-fade
  - https://filmdaft.com/crossfades-in-premiere-pro-explained/
  - https://www.descript.com/blog/article/crossfade-audio-what-crossfade-is-and-how-to-edit-it
  - https://opentimelineio.readthedocs.io/en/v0.15/api/python/opentimelineio.adapters.cmx_3600.html
  - https://en.wikipedia.org/wiki/Split_edit
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: low
detectable_from: video
---

# The straight cut — picture and sound switch on the same frame

## What it is
The default join, and the one every other cut is defined against: at frame *N* you are in shot A, at frame *N+1* you are in shot B, and **the audio changes on the same boundary**. No overlap, no dissolve, no split. The source's definition is exactly this and includes the audio clause deliberately — *"an instant switch between one shot to another, **including audio**"* — because the moment sound crosses the boundary you no longer have a straight cut, you have a J cut ([[cut-j-audio-leads-picture]]) or an L cut ([[cut-l-audio-trails-picture]]). Editorially it reads as a **clean, complete handoff**: this thought is finished, here is the next one. That is a real meaning, not an absence of one, which is why an edit made entirely of split edits feels boneless — it has no full stops.

## When to use it
Use it as the baseline and deviate on purpose. Specifically reach for a straight cut when: a **sentence or clause has genuinely ended** and the next one starts a new idea; you are stepping through a **numbered list** and item *n* is done; at a **section boundary** where the audio also changes deliberately (music out, new bed, new location tone); on a **jump cut** inside one continuous take, where the whole point is a visible discontinuity; and immediately before or after any transition-heavy stretch, as relief. Do **not** use it mid-sentence, mid-word, or across a continuing action — those want a split edit or a cut on action. Do not use it when the two shots' room tone differs sharply and nothing covers the change: the picture will be fine and the audio will step audibly ([[cut-continuity-pass]]).

## How to recognise it in a reference video
The whole detection is a subtraction: find the picture boundary, find the audio boundary, and check they coincide.

- **Picture boundary, mechanically.**
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ```
- **Audio boundary, mechanically.** A per-frame RMS trace — `n=1600` samples at 48 kHz is exactly one frame at 30 fps:
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
- **The classifier.** `|audio_change − picture_cut| ≤ 2 f` → **straight cut**. `audio_onset < picture_cut − 2 f` → J cut. `audio_end > picture_cut + 2 f` → L cut. The ±2 f tolerance exists because a real straight cut still shows a 1–3 frame audio ramp (see below) and because scene detection lands within a frame or two of the true boundary.
- **Look for the tiny ramp, not for a step.** A professionally finished straight cut has a **5–10 ms** (sub-frame) or **1–3 frame** audio fade *centred on the cut*. On a waveform this is invisible at timeline zoom and obvious at sample zoom. A literal sample-accurate butt join usually shows a click: a single-frame RMS spike **8–20 dB** above both neighbours with energy across the whole spectrum.
- **Straight-cut share.** Count all boundaries and classify. Explainer/creator references run **75–90% straight cuts**; dialogue-driven drama runs **40–70%**. A reference under ~50% straight cuts in an explainer is doing something deliberate with split edits and should be logged as such.
- **Transcript alignment is the fastest single test.** Overlay word boundaries on picture cuts. A cut that lands in the **gap between two sentences** with no word spanning it is a straight cut, detectable from the transcript with no audio analysis at all. A cut with a word spanning it is a split edit by definition.
- **Room-tone step.** Where the two shots have different beds, measure the RMS of the 15 frames either side in a speech-free window. A step **> 4 dB** with no fade is an unfinished straight cut — the amateur signature — not a stylistic choice.
- **Do not confuse it with a jump cut.** Same detection result, different meaning: a jump cut is a straight cut between two shots from the *same* framing of the *same* subject. Check whether the framing is unchanged and the subject has moved/teleported.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `picture_audio_offset` | 0 f | 0 f | Definitionally zero. Any non-zero value makes it a split edit. |
| `declick_fade` | 8 ms (≈0.25 f) | 5–10 ms | Pro-audio answer: short fades of 5–10 ms remove pops and clicks after a trim. Sub-frame, inaudible. |
| `nle_min_fade` | 2 f (67 ms) | 1–3 f | What frame-based tools can actually express (Premiere's minimum audio transition is 2 frames). Centre it on the cut. |
| `max_declick_fade` | 3 f (100 ms) | — | Above this it starts to read as a soft join. Premiere's *default* audio transition is **1 s** — 30× too long for this job and the commonest cause of accidental soft cuts. |
| `fade_shape` | equal-power | equal-power / linear | Constant-power (logarithmic) keeps combined loudness flat; constant-gain (linear) dips ~3 dB at the midpoint. Use equal-power. |
| `detection_tolerance` | ±2 f | ±1–3 f | Window inside which picture and audio boundaries count as coincident. |
| `roomtone_step_limit` | 4 dB | 2–6 dB | Max acceptable bed level change across the boundary with no cover. |
| `straight_cut_share` | 0.82 | explainer 0.75–0.90 · dialogue 0.40–0.70 | Straight cuts ÷ all boundaries. |
| `min_shot_len` | 12 f (0.4 s) | 6–45 f | Below 6 f the cut reads as a flash frame rather than a shot. |

## Reproduction prompt

```
Build a straight cut from clip {{A}} to clip {{B}} at composition time
{{CUT}} (seconds, 30fps).

1. PICTURE. End A's picture at {{CUT}} and start B's picture at {{CUT}}.
   Author them back to back so no frame is shared and none is skipped: B's
   start equals A's start plus A's duration, exactly.
2. AUDIO ON THE SAME FRAME. A's audio ends at {{CUT}} and B's audio starts at
   {{CUT}}. Do not extend either past the boundary - if you want sound to
   cross it, you are building a J or L cut and must say so.
3. DECLICK. Put a 2-frame (0.067s) equal-power fade CENTRED on the cut: A's
   audio ramps 1.0 -> 0 over the last 1 frame, B's audio ramps 0 -> 1.0 over
   its first 1 frame. Never use the editor's default 1-second audio
   crossfade: that is a dissolve, not a declick.
4. PLACE IT AT A LANGUAGE BOUNDARY. Take {{CUT}} from the word-level
   transcript: it must sit in the gap BETWEEN two sentences or clauses, at
   least 3 frames after the last word-end and at least 3 frames before the
   next word-start. If no such gap exists within 8 frames, this beat wants a
   split edit instead - stop and report that.
5. MATCH THE BEDS. Measure the room-tone RMS of the 15 frames either side in
   a speech-free window. If they differ by more than 4 dB, add a continuous
   ambience layer that spans the cut at -22 to -25 dB, or fetch matching room
   tone. Do not solve it by lengthening the fade.
6. VERIFY THE SHOT IS A SHOT. A must be at least 12 frames long and B at
   least 12 frames, or the cut reads as a flash frame.

ACCEPTANCE TEST: (a) frame-step the boundary - the last frame of A and the
first frame of B are adjacent, with no black frame, no repeated frame and no
one-frame flash; (b) listen at 2x gain on headphones - no click, no pop, no
audible level step; (c) run the RMS trace and confirm the audio change lands
within 1 frame of the picture change; (d) with the picture off, the audio
should sound like a deliberate full stop, not like a dropout.
```

## Execution spec

**HyperFrames (primary), and this is the cheapest thing in the stack.** A straight cut is two clips authored back to back; the framework's **half-open visibility window** `[start, start + duration)` does the work: *"Two clips can therefore be authored back to back (`b.start === a.start + a.duration`) with no overlapping frame."* Author **seconds**; frames are a derived comment.

```html
<!-- straight cut at 21.40s. Picture and sound switch on the same boundary. -->
<video id="shot-a" src="a.mp4" muted playsinline class="clip"
       data-start="16.00" data-duration="5.40" data-media-start="3.00" data-track-index="0"></video>
<audio id="shot-a-aud" src="a.mp4" data-audio-group="dialogue"
       data-start="16.00" data-duration="5.40" data-media-start="3.00" data-track-index="10"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:5.367,&quot;v&quot;:1},{&quot;t&quot;:5.40,&quot;v&quot;:0}]}]}"></audio>

<video id="shot-b" src="b.mp4" muted playsinline class="clip"
       data-start="21.40" data-duration="6.00" data-media-start="8.00" data-track-index="0"></video>
<audio id="shot-b-aud" src="b.mp4" data-audio-group="dialogue"
       data-start="21.40" data-duration="6.00" data-media-start="8.00" data-track-index="11"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.033,&quot;v&quot;:1}]}]}"></audio>
<!-- 0.033s = 1f @30fps on each side = a 2-frame equal-power declick centred on 21.40. -->
```
Five contract facts this depends on:
- **All authored time is seconds. There is no frame attribute.** 1 f @30fps = `0.033`; 2 f = `0.067`.
- **Land the ramp before the boundary, not on it.** *"Land an animation's resolved end state slightly before `data-duration`, not on it, or its last frame is never rendered."* Hence `t: 5.367` → `t: 5.40`, not a point exactly at the edge.
- **The lane holds its first value backwards to the clip start and its last value forward to the clip end** — so `#shot-b-aud` needs the explicit `{t:0,v:0}` point or it starts at unity and the declick does nothing.
- **Every `<audio>` needs an `id`** or it is never mixed → silent render, no warning.
- The two audio clips do not overlap here, so they *could* share a track index; distinct indices (10, 11) are still safer because any later split edit at this boundary would trip `duplicate_audio_track`.

If picture and sound are one unmuted `<video data-has-audio="true">`, the straight cut is a single pair of clips and the declick is not expressible per-side — that is an accepted simplification for footage with a continuous bed, and a reason to prefer the separate-`<audio>` convention when boundaries are tight.

**ffmpeg — only when the join leaves the pipeline.** Physical concat with a real declick means re-encoding at the boundary; a pure `-c copy` concat is keyframe-snapped and will not land where you asked:
```bash
ffmpeg -i a.mp4 -ss 3.0   -t 5.4 -c:v libx264 -preset veryfast -crf 18 -c:a aac seg_a.mp4
ffmpeg -i b.mp4 -ss 8.0   -t 6.0 -c:v libx264 -preset veryfast -crf 18 -c:a aac seg_b.mp4
printf "file '%s'\n" seg_a.mp4 seg_b.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy out.mp4
```
Audio-only, with an explicit equal-power 67 ms crossfade at the boundary:
```bash
ffmpeg -i a.wav -i b.wav -filter_complex "[0][1]acrossfade=d=0.067:c1=tri:c2=tri[out]" -map "[out]" joined.wav
```
The transcript-driven route is better when the cut points come from language: `transcript-cut.mjs --remove "a-b,c-d"` compiles the kept segments and concats them; **drop `--copy` for frame accuracy** — it snaps to keyframes and reports `copy_drift` when the snap swallows a cut.

**Epidemic Sound.** Only for the room-tone problem: `SearchSoundEffects { query.term: "<location> room tone ambience loop", filter.duration { min: 10000 } }`, placed as its own continuous clip spanning the boundary in an `ambience` group — **never** inside the `voiceover` carve group.

**Remotion:** two adjacent `<Sequence>`s with no overlap; no Remotion runtime exists in this project.

## Pairs with
[[cut-outpoint-inpoint-alignment]] · [[cut-j-audio-leads-picture]] · [[cut-l-audio-trails-picture]] · [[cut-continuity-pass]] · [[cut-on-action]] · [[pace-cut-on-the-beat]] · [[cut-invisible-storytelling-doctrine]] · [[pace-cut-density-from-viewer-intent]] · [[cut-full-screen-transition]] · [[sfx-whoosh-transition-movement-reveal]] · [[cut-smash-cut-loud-to-quiet]] · [[cut-match-cut]]

## Failure modes
- **The click.** A sample-accurate butt join on a non-zero waveform pops. Fix: 5–10 ms, or 1–3 frames, of equal-power fade centred on the cut — not a longer one.
- **Reaching for the editor's default crossfade.** One second of audio dissolve turns every hard cut soft and the edit loses all its full stops. Fix: set the declick length explicitly; treat 1 s as a dissolve you chose, never as a click fix.
- **The room-tone step.** Picture is clean, the bed jumps 6 dB, and the cut sounds like a mistake even though it looks fine. Fix: a continuous ambience layer across the boundary, or matched room tone; not a longer fade.
- **Cutting mid-word.** The most audible amateur error and trivially avoidable from a word-level transcript. Fix: place the cut in a word gap with a 3-frame guard each side.
- **Flash frames.** A 2–4 frame remnant of a shot left at a boundary reads as a glitch. Fix: 12-frame minimum shot length, and frame-step every boundary.
- **All straight cuts, everywhere.** Technically correct and rhythmically flat: nothing is ever bridged, so every idea has a wall around it. Fix: hold `straight_cut_share` near 0.82 in explainers and give the rest to split edits and matched cuts.
- **Calling a jump cut a straight cut in the design document.** Same measurement, different intent, different reproduction. Fix: record whether framing and subject are unchanged across the boundary.
- **Stream-copy drift.** `-c copy` cuts only on keyframes; on sparse-keyframe footage the snap can *"silently swallow the whole cut."* Fix: re-encode the boundary segments, or accept the drift knowingly after reading `copy_drift`.
- **Known gap:** no frame-based timing attribute exists in HyperFrames, so every frame count in this note must be divided by the render fps at authoring time — and `--fps` can be overridden at render, which silently changes what "2 frames" meant. Record the intended fps in the design document.
