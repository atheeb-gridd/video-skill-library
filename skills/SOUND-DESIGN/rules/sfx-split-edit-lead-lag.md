---
id: sfx-split-edit-lead-lag
title: Split edits — let sound cross the cut to steer attention
skill: sound-design
type: cut
family: split-edit
tags: [skill/sound-design, type/cut, family/split-edit, engine/hyperframes, engine/ffmpeg, layer/dialogue, layer/ambience, sfx/diegetic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:00"
    quote: "They let editors guide the audience's attention, build emotional impact, and instead of just feeling like a hard stop, the J and L cut make the film feel more immersive."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:23"
    quote: "An L cut is the opposite. The audio from the current scene continues even after the visual cuts to the next."
research_refs:
  - https://en.wikipedia.org/wiki/Split_edit
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://en.wikipedia.org/wiki/Room_tone
difficulty: medium
detectable_from: transcript+video
---

# Split edits — let sound cross the cut to steer attention

## What it is
A split edit breaks the picture cut and the sound cut onto different frames. **J cut:** the incoming scene's audio starts before its picture — sound leads. **L cut:** the outgoing scene's audio continues after its picture has gone — sound trails. Because one sense arrives first, the editor chooses what the viewer is *thinking about* at the cut: a J cut makes the audience anticipate the new space, an L cut keeps them inside the old one while showing them something new. In dialogue this is what stops a conversation feeling like *"a tennis match"*; in a talking-head edit it is what turns a hard B-roll cut into a continuous thought.

## When to use it
- **J cut** when the new scene's meaning should arrive before its image: a location change you want to feel motivated, a reveal you want anticipated, a new speaker whose voice should pull the cut.
- **L cut** when the reaction matters more than the delivery: cut to the listener, to B-roll, or to the object being described while the line keeps running. This is the workhorse move for A-roll → B-roll in creator editing — the voice never breaks, only the picture does.
- **Always** across an ambience change, in either direction, so the room does not switch instantly with the frame.
- Do not split a cut whose whole point is shock. A smash cut and a beat-synced hard cut both want picture and sound landing together.

## How to recognise it in a reference video
- **The tell is a mismatch between the picture cut frame and the audio transition frame.** Detect picture cuts (`scenedetect -i ref.mp4 detect-adaptive list-scenes`) and compare each cut timecode against the transcript's word boundaries: if a word straddles the cut, it is a split edit.
- **J cut signature:** a new ambience, a new voice, or a new room tone becomes audible **6–36 frames (0.2–1.2 s)** *before* the picture changes.
- **L cut signature:** the outgoing speaker's line continues **6–60 frames (0.2–2.0 s)** past the picture change; on the waveform, the speech envelope is continuous across a hard visual cut.
- **Not a split edit:** an offset under 2 frames (67 ms). That is inside lip-sync tolerance and reads as a plain hard cut — or as a sync error. Film practice treats *"no more than 22 milliseconds in either direction"* as acceptable lip sync, so anything under ~1 frame is noise, not intent.
- Reaction-shot holds under continuing audio typically run **1.0–2.5 s**; past ~3 s without a new line the shot starts to read as a mistake.
- Count them: a dialogue-driven edit with almost every cut split is doing this deliberately; one or two in a whole video is probably accidental.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| J-cut lead (audio before picture) | 12 frames (0.4 s) | 6–36 frames (0.2–1.2 s) | Longer leads feel like a pre-lap and need a strong incoming sound. |
| L-cut trail (audio after picture) | 18 frames (0.6 s) | 6–60 frames (0.2–2.0 s) | To the end of the sentence for A-roll→B-roll. |
| Minimum meaningful offset | 4 frames (0.133 s) | 2–4 frames | Below this it reads as sync error, not craft. |
| Reaction-shot hold | 1.5 s | 1.0–2.5 s | Under continuing audio. |
| Ambience crossfade | 0.5 s | 0.3–1.5 s | Overlap the two beds across the picture cut. |
| Sync tolerance to respect | ±22 ms | ±22 ms | On any shot where lips are visible, sound must stay locked. |

## Reproduction prompt

```
Convert the hard cut at {{T_CUT}} into a split edit.

DECIDE THE DIRECTION FIRST.
- If the incoming shot's meaning should be anticipated -> J cut: audio leads.
- If the outgoing line should carry over the new picture -> L cut: audio trails.
- If the shot shows a speaking face in either scene, the split may only apply to
  the NON-speaking side. Never slip audio against visible lips.

BUILD IT.
1. Split picture and sound onto separate elements. The <video> carries `muted`
   and its own data-start/data-duration/data-media-start; a matching <audio>
   carries the same media-start arithmetic, moved by the offset.
2. J CUT: set the incoming audio's data-start to {{T_CUT}} - {{LEAD}} and
   increase its data-duration by {{LEAD}}; leave data-media-start unchanged so
   the sound is the same take, just earlier. Default {{LEAD}} = 0.4 s.
3. L CUT: extend the outgoing audio's data-duration by {{TRAIL}} past the
   picture cut. Default {{TRAIL}} = 0.6 s. End it on a word boundary, never
   mid-syllable.
4. Crossfade the ambience beds across the picture cut over 0.5 s with a volume
   automation lane on each - out on one, in on the other.
5. Put every voice clip in data-audio-group="voiceover" so the music carve keeps
   following the speech across the split.

ACCEPTANCE TEST: play from 2 s before to 2 s after {{T_CUT}}. The sentence is
unbroken and no word is clipped. No lips are visible out of sync. The picture cut
lands somewhere inside a phrase, not on the gap between sentences - if it lands
on the gap, you have built two hard cuts, not a split edit.
```

## Execution spec

**HyperFrames.** There is no split-edit primitive; the split is expressed by giving picture and sound different `data-start` values. The stack's own convention makes this natural: *"Videos use `muted` with a separate `<audio>` element for the audio track"* — the pattern to reach for *"when picture and sound are cut independently."* An L cut, audio trailing 0.6 s past the picture:

```html
<!-- picture cuts at 12.0 -->
<video id="shot-a" src="a.mp4" muted playsinline
       data-start="8" data-duration="4" data-media-start="31.2" data-track-index="0"></video>
<video id="shot-b" src="b.mp4" muted playsinline
       data-start="12" data-duration="6" data-media-start="4.0" data-track-index="0"></video>

<!-- sound from shot A runs to 12.6 -->
<audio id="shot-a-audio" src="a.mp4" data-audio-group="voiceover"
       data-start="8" data-duration="4.6" data-media-start="31.2" data-track-index="10"></audio>
<audio id="shot-b-audio" src="b.mp4" data-audio-group="voiceover"
       data-start="12.6" data-duration="5.4" data-media-start="4.6" data-track-index="10"></audio>
```

Note the media-start arithmetic on `shot-b-audio`: delaying the audio start by 0.6 s means skipping 0.6 s further into the source, or the two drift. There is **no automatic waveform sync and no drift correction** in this stack — alignment is authored by writing the same numbers on both elements. If either element carries `data-playback-rate`, both must carry it, and the global math is *consumed source = timeline duration × rate*.

All timing is **seconds**; there is no frame attribute. Convert at authoring time: at 30 fps, 12 frames = 0.4, 18 frames = 0.6.

Watch `duplicate_audio_track` (two `<audio>` sharing a track index *and* overlapping in time raises a lint warning) — during the 0.6 s overlap of an ambience crossfade, put the two beds on different track indices.

**ffmpeg.** Only when the split has to survive outside the composition: cut picture and audio as separate files with `-ss/-to` offsets and re-mux. Prefer the in-composition form — `data-media-start` + `data-duration` trims without cutting a file at all.

**Epidemic Sound.** Split edits usually need a second ambience bed so the two spaces can overlap. Fetch both with `SearchSoundEffects` and the ambience recipe in [[sfx-ambience-search-formula]]; a J cut into a new location is much stronger when the new room arrives before the picture.

**Remotion.** Place `<Video muted>` and `<Audio>` in separate `<Sequence from={...}>` blocks with different `from` frames — same idea, expressed in frames rather than seconds.

## Pairs with
[[sfx-ambience-search-formula]] · [[sfx-layer-volume-targets]] · [[sfx-motion-sound-selection]] · [[sfx-music-hard-stop]] · [[cut-j-audio-leads-picture]] · [[cut-l-audio-trails-picture]] · [[cut-straight-hard-cut]]

## Failure modes
- **Slipping audio under a visible speaking face.** Beyond ±22 ms this reads as a broken file, not as style. Split only against the non-speaking side.
- **Cutting the trail mid-syllable.** The L cut's end must land on a word boundary; a clipped consonant sounds like a dropped frame.
- **Offsets under 2 frames.** Invisible as craft, visible as error. Either commit to 6+ frames or make it a hard cut.
- **Forgetting the media-start arithmetic.** Moving `data-start` without moving `data-media-start` by the same amount plays different source content, silently.
- **Splitting every cut.** Constant overlap removes the punctuation from the edit; the video stops having paragraphs. Reserve hard sync for the beats that should feel like stops.
- **Known gap:** relative timing (`data-start="shot-a + 0.6"`) can express the offset, but it fails silently to `0` if the spaces around the operator are missing, if the reference is unresolved, or if the target has no resolvable duration. Prefer absolute seconds for split edits, and snapshot to confirm.
