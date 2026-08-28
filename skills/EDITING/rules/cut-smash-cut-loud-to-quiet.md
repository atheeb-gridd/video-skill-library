---
id: cut-smash-cut-loud-to-quiet
title: The smash cut — drop from loud and chaotic to quiet and simple
skill: editing
type: cut
family: smash-cut
tags: [skill/editing, type/cut, family/smash-cut, layer/music, layer/sfx, layer/ambience, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:05:11"
    quote: "An example of a smash cut could be a loud, chaotic scene that suddenly cuts to a quiet, simple one."
research_refs:
  - https://en.wikipedia.org/wiki/Smash_cut
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://en.wikipedia.org/wiki/Audio_normalization
  - https://ffmpeg.org/ffmpeg-filters.html#ebur128
  - https://ffmpeg.org/ffmpeg-filters.html#afade-1
difficulty: medium
detectable_from: transcript+video
---

# The smash cut — drop from loud and chaotic to quiet and simple

## What it is
A hard cut whose whole effect is **dynamic contrast**: a loud, busy, fast passage ends on one frame and the next frame is quiet, still and simple. The reference definition of a smash cut is a cut that is deliberately abrupt *"for aesthetic, comedic, narrative, or emotional purpose"*, typically running from *"a fast-paced frenzied scene to a tranquil one"* — and the canonical comic example, Indiana Jones confidently describing Marcus Brody's resourcefulness before cutting to Brody lost in a bazaar, works entirely because the second shot arrives with none of the first's energy.

The counter-intuitive part, and the reason this note exists separately from the general hard cut, is that **the drop is the event**. Editors reach for a loud accent to mark an important moment; a smash cut does the opposite, and the sudden *absence* of sound produces a larger orienting response than an added sound would, because the ear is tracking change, not level. It also clears the field: with the noise gone, whatever is left — a line, a face, a number on screen — is the only thing in the mix.

Two things distinguish it from its neighbours in this library. It is **not** the music drop of [[sfx-music-hard-stop]] or [[sfx-silence-as-pattern-interrupt]] — those keep the picture continuous and remove one layer; the smash cut changes the picture and the whole soundscape on the same frame. And it is **not** a pattern interrupt for its own sake: the incoming shot has to be worth the silence it arrives in. The inverse move — quiet to loud — exists and is the jump-scare register; this note owns the loud-to-quiet direction, which is the one that works in non-fiction.

## When to use it
The trigger is always a **turn in the content**, and the smash cut makes the turn physical:

- **Comic deflation.** The narration builds, boasts, or over-promises, and the cut lands on the unglamorous reality. The transcript signal is a confident claim followed by a contradicting image.
- **Hype into substance.** A montage, a highlight reel, or a fast-cut cold open ends and the actual video begins on a single quiet shot ([[struct-outcome-first-cold-open]]).
- **Chaos into consequence.** A dense demonstration, a fast build, or a problem sequence resolves into one still frame of the result.
- **The turn from problem to solution**, where the source's own music-drop technique already sits. If the bed is changing there anyway, upgrading the moment to a full smash cut costs nothing.
- **A hard chapter boundary** where a fade would be too soft and a straight cut too neutral.

Do not use it: more than two or three times in a ten-minute video (it is loud punctuation and the third one is a tic); anywhere the quiet side is not visually simple — a busy incoming frame wastes the silence; or where the audience needs to keep hearing something across the join, which is a J or L cut instead ([[cut-j-audio-leads-picture]], [[cut-l-audio-trails-picture]]).

## How to recognise it in a reference video
This is an audio-first detection. Everything hinges on the **momentary loudness step** at the cut frame.

- **Momentary loudness (400 ms window) across the join.** Trace it:
  ```bash
  ffmpeg -i ref.mp4 -af "ebur128=framelog=verbose:peak=true" -f null - 2>&1 | grep -E "M:|S:"
  ```
  A smash cut shows a **step of ≥ 10 LU** in momentary loudness, completed **within 3 frames (100 ms)**. If the decline takes longer than about 10 frames, it is a fade ([[sfx-music-fade-out-section-signal]]); if it recovers within a second, it is a duck.
- **Short-term loudness (3 s window) either side.** Sample the 3 seconds before and the 3 seconds after. Typical measured pairs:
  - Loud side short-term **−12 to −8 LUFS**, quiet side **−30 to −24 LUFS** → delta **14–20 LU**: a full smash cut with a near-silent landing.
  - Loud side **−14 to −11 LUFS**, quiet side **−26 to −22 LUFS** → delta **10–14 LU**: a smash cut whose quiet side still carries dialogue.
  - Delta under **8 LU** → not a smash cut; log it as a straight cut with a mix change.
- **Picture cuts on the same frame.** Measure the offset between the audio step and the visual cut. **Within ±2 frames** is a smash cut. Beyond that you are looking at a split edit and should log it as [[cut-split-edit-attention-steering]].
- **The quiet side sustains.** The low level must hold for **at least 30 frames (1 s)**, and usually 2–4 s. A 6-frame dip that comes back is a stutter or a dropout, not a technique.
- **Layer census either side.** Count active layers in each 3-second window: dialogue, ambience, foley, effects, music. A smash cut typically goes from **4–5 layers to 1–2**. That count is often a cleaner signal than the loudness number, because it survives a badly mastered source.
- **Loudness range of the whole programme.** `ebur128` reports **LRA in LU**. A video that uses dynamic contrast deliberately runs **LRA 8–14 LU**; a flat, over-compressed edit sits **under 5 LU** and cannot contain a smash cut regardless of what the picture does. If the reference's LRA is low, any apparent smash cut in it was flattened in the mix.
- **Visual simplicity on the incoming side.** Measure the incoming shot's motion energy — `tblend=all_mode=difference,signalstats` — and its shot length. A genuine smash cut lands on a shot that is **long relative to the outgoing passage** (often 3–10× the preceding average shot length) and **low in motion energy**. Loud-to-quiet in the sound with a still-frenetic picture is a mix accident.
- **Transcript.** Look for the deflation: an over-claim, a build, a list ending, or a "but here's the thing" immediately before the join.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `loudness_delta` | 15 LU (short-term) | 10–22 LU | Under 10 LU the drop is not felt. Over 22 LU the quiet side risks inaudibility on phone speakers after platform normalisation. |
| `loud_side_short_term` | −11 LUFS | −14 to −8 LUFS | Measured over the 3 s before the cut. |
| `quiet_side_short_term` | −26 LUFS | −30 to −22 LUFS | Use the upper half of the range whenever the quiet side carries dialogue that must stay intelligible. |
| `drop_duration` | 0 frames (hard) | 0–2 frames | The step is instantaneous. The only reason for 1–2 frames is de-clicking, below. |
| `declick_fade` | 2 frames (66 ms) | 1–3 frames | A hard truncation of a loud sustained bed clicks. A 33–66 ms fade removes the click and is far inside the 400 ms momentary-loudness window, so the step still reads as instantaneous. |
| `true_silence_gap` | 0 frames | 0–6 frames | Optional. A 2–6 frame gap of genuine digital silence before the new scene's ambience enters deepens the drop. Past ~10 frames it reads as a dropout. |
| `quiet_side_hold` | 90 frames (3.0 s) | 30–150 frames | How long the quiet stays before the video re-energises. Under 30 frames the contrast does not land. |
| `av_offset` | 0 frames | ±2 frames | Audio step and picture cut on the same frame. Anything larger is a different technique. |
| `incoming_shot_length` | ≥ 3× the outgoing passage's mean shot length | 2–10× | The quiet side must be visibly slower, not just quieter. |
| `programme_LRA` | 9 LU | 7–14 LU | The finished video's loudness range must be wide enough to contain the contrast. |
| `uses_per_video` | 2 | 1–3 | Budget. |
| `sfx_on_the_cut` | none | none · one soft tail | Adding a hit on a smash cut fights the silence. If anything, let the outgoing bed's reverb tail run 2–4 frames past the cut. |

## Reproduction prompt

```
Build a loud-to-quiet smash cut at {{CUT_TC}} in composition {{COMP}}.
Frames at 30fps; HyperFrames time is authored in SECONDS.

1. Verify the content justifies it: the outgoing passage must be busy (4+
   active audio layers, dense cutting) and the incoming shot must be simple,
   still, and worth looking at in silence. If the incoming shot is busy,
   change the shot, not the mix.
2. Measure the outgoing side. Run
   ffmpeg -i {{ROUGH}} -af "ebur128=framelog=verbose" -f null -
   and record short-term (S) LUFS over the 3 s before {{CUT_TC}}.
3. Set the quiet side target = loud side - 15 LU. If the quiet side carries
   dialogue, clamp the target so dialogue sits no lower than -26 LUFS
   short-term, and accept a smaller delta (minimum 10 LU) rather than losing
   intelligibility.
4. Cut picture and sound on the SAME frame. Do not crossfade the audio, do
   not use a registry transition on this boundary, and do not let any layer
   ramp across the join.
5. End every loud-side layer at {{CUT_TC}} with a 2-frame (0.066 s) fade to
   zero, authored as the last two points of that clip's volume automation
   lane. This is a de-click only - it must not be longer than 3 frames.
6. On the incoming side, start ONLY the layers the quiet scene needs -
   typically dialogue plus one ambience. Optionally leave 3 frames (0.1 s) of
   true silence before ambience enters; never more than 6.
7. Hold the quiet for at least 90 frames (3.0 s) before re-introducing music
   or cutting again.
8. Do NOT run a dynamic loudness normaliser over the finished mix. If you
   normalise for delivery, use two-pass loudnorm with linear=true and the
   measured values, which applies a constant gain and leaves relative
   dynamics unchanged. A dynamic pass, or an LRA target below about 9,
   will flatten the very contrast you built.
9. ACCEPTANCE TEST: on the rendered file, confirm with ebur128 that
   momentary (M) loudness falls by at least 10 LU within 3 frames of
   {{CUT_TC}}, that short-term loudness either side differs by 10-20 LU, and
   that programme LRA is at least 7 LU. Then listen once on a phone speaker
   at a normal volume: the quiet side must still be clearly audible. If it
   is not, reduce the delta - do not raise the quiet side after the fact.
```

## Execution spec

**HyperFrames (primary).** A smash cut is authored, not applied — there is no transition to invoke. It is two picture clips butted together and a discontinuous set of audio clips on the same frame.

```html
<!-- Picture: hard cut at 78.40s. Half-open window means no shared frame. -->
<video id="sc-loud"  src="assets/montage.mp4" muted playsinline class="clip"
       data-start="72.40" data-duration="6.00" data-media-start="11.2" data-track-index="0"></video>
<video id="sc-quiet" src="assets/still-room.mp4" muted playsinline class="clip"
       data-start="78.40" data-duration="6.50" data-media-start="0.0"  data-track-index="0"></video>

<!-- Loud side: bed + SFX, both ending at 78.40 with a 2-frame de-click.
     t is CLIP-LOCAL seconds; the lane's first point must state the starting level. -->
<audio id="sc-bed" src="assets/bgm/drive.mp3" data-audio-group="music"
       data-start="60.00" data-duration="18.40" data-media-start="8.0"
       data-track-index="11" data-volume="0.75"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:18.334,&quot;v&quot;:1},{&quot;t&quot;:18.40,&quot;v&quot;:0}]}]}"></audio>

<!-- Quiet side: one ambience, entering 3 frames (0.1s) after the cut. -->
<audio id="sc-room" src="assets/sfx/room-tone.wav" data-audio-group="ambience"
       data-start="78.50" data-duration="6.40" data-track-index="12" data-volume="0.18"></audio>
```

The details that matter:

- **`t` in a clip lane is clip-local seconds.** The bed starts at composition 60.0, so the cut at 78.40 is `t = 18.40`. Two frames earlier is `t = 18.334`.
- **A lane holds its first value backwards to the clip start**, so the explicit `{t:0, v:1}` point is mandatory — without it the bed plays the whole passage at whatever the next point says.
- **Write the JSON double-quoted with `&quot;`.** `carve.mjs` finds these attributes with a `name="..."` regex; a single-quoted attribute is invisible to it and a later carve silently overwrites work it could not see.
- **Do not also GSAP-tween `volume`** on a track that has a volume lane — `audio_volume_double_automation`, the lane wins and the tween is ignored, silently.
- **Every `<audio>` needs an `id`.** An id-less `<audio>` is never mixed → a silent render with no error.
- **Keep overlapping audio off the same `data-track-index`** (`duplicate_audio_track`). Audio conventionally lives at 10+.
- **No registry transition on this boundary.** The injector extends the outgoing clip and pulls the incoming clip's `data-start` earlier to create an overlap — an overlap is precisely what a smash cut must not have.
- **Reverb/delay tails outrun `data-duration`** by `chainTailSeconds`. If the loud bed has a reverb node, its tail will spill past the cut; that can be a pleasant 2–4 frame ring, or it can undermine the drop. Check it in the render, and remove the reverb from the final bed if it softens the step.
- **Ducking interaction.** If the bed is carved against the voice group, the carve releases slowly by design. It does not fight a hard stop — the clip simply ends — but do not expect the carve to *create* the drop; the drop is the clip boundary plus the lane.

**ffmpeg.** For measurement, and for baking if the mix leaves the pipeline.
```bash
# measure momentary/short-term/integrated/LRA/true-peak
ffmpeg -i mix.wav -af "ebur128=framelog=verbose:peak=true" -f null -

# 2-frame de-click on the loud bed, then a hard join (no crossfade)
ffmpeg -i bed.wav -af "afade=t=out:st=18.334:d=0.066:curve=tri" bed.declick.wav

# delivery normalisation that PRESERVES the contrast: two-pass, linear
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=<i>:measured_TP=<tp>:measured_LRA=<lra>:measured_thresh=<th>:offset=<off>:linear=true:print_format=summary mix.social.wav
```
`linear=true` is load-bearing here: it applies a **constant gain** across the programme, which leaves the loud/quiet relationship intact. Without measured values, `loudnorm` runs dynamically and will pull the quiet side up and the loud side down — flattening the smash cut into nothing. Platform normalisation itself does not flatten it: the platforms apply a single programme-level gain (YouTube, Spotify and TikTok target **−14 LUFS**; EBU R128 broadcast **−23**, ATSC A/85 **−24**), and *"because the same amount of gain is applied across the entire recording, the signal-to-noise ratio and relative dynamics are unchanged."* The real risk is that a loud programme is turned **down** as a whole, taking an already-quiet side toward inaudibility — which is why the delta is capped rather than maximised.

**Epidemic Sound.** Only the loud side usually needs sourcing. `SearchRecordings` with `filter.bpm {min:120,max:150}`, `filter.moodSlugs` for the busy register and `filter.vocals: false` under narration; take the `stems` (DRUMS / BASS / MELODY / INSTRUMENTS) if you want the loud side to be denser than one track allows. Nothing is fetched for the quiet side except room tone: `SearchSoundEffects` with `query.term: "room tone quiet interior"`, `filter.duration {min: 8000, max: 60000}` (milliseconds). Place ambience in an `ambience` group, never in the voice group.

**Remotion:** two `<Sequence>` blocks and two `<Audio>` elements with different `volume` props and no overlap. Concept identical; not present in this project.

## Pairs with
[[cut-straight-hard-cut]] · [[cut-hard-cut-for-new-information]] · [[sfx-silence-as-pattern-interrupt]] · [[sfx-music-hard-stop]] · [[sfx-music-rest-windows]] · [[struct-outcome-first-cold-open]] · [[pace-deliberate-continuity-break]] · [[struct-presenter-aside-pattern-interrupt]] · [[sfx-ambience-bridge-across-cut]] · [[pace-shot-length-follows-interest]]

## Failure modes
- **The quiet side is not quiet enough.** A delta under 8 LU is a mix change, not a smash cut, and the viewer registers nothing. Fix: measure short-term LUFS either side and hit at least 10 LU.
- **The quiet side is too quiet.** Pushed past ~22 LU of contrast, the quiet passage disappears on laptop and phone speakers once the whole programme has been normalised down. Fix: cap the delta, and test on a phone speaker before shipping.
- **Crossfading the audio.** Any crossfade longer than about 3 frames turns the step into a ramp and destroys the effect. Fix: hard join, 2-frame de-click at most.
- **Landing on a busy shot.** Silence over a fast-moving frame is just a missing music track. Fix: the incoming shot must be still and simple, and 3× longer than the outgoing average shot.
- **Coming back too quickly.** Re-entering with music 15 frames after the cut cancels the whole gesture. Fix: hold the quiet at least 90 frames.
- **Normalising dynamically at delivery.** A one-pass `loudnorm`, an aggressive limiter, or an LRA target below ~9 LU will flatten the contrast after all the work is done. Fix: two-pass `linear=true` with measured values; check programme LRA ≥ 7 LU on the delivered file.
- **Adding a hit on the cut.** An impact on the frame of the drop competes with the silence it is supposed to reveal. Fix: nothing on the cut; if the moment needs marking, mark it *before* the cut on the loud side.
- **Known gap:** nothing in this stack measures loudness at author time. `ebur128` runs on rendered audio only, the render is browser-hosted and browser-dependent, and lint validates none of the mix. Every number in this note has to be verified after a render, on another host, and written back into the design document.
