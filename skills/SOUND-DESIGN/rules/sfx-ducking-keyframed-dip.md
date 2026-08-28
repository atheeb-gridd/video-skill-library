---
id: sfx-ducking-keyframed-dip
title: "Ducking — demonstrated on screen, never named: the keyframed dip under the voice"
skill: sound-design
type: mix
family: mix-levels
tags: [skill/sound-design, type/mix, family/mix-levels, layer/music, layer/dialogue, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "visual — contact sheet, screen recording of the Premiere timeline"
    quote: "[NOT SPOKEN — observed on screen] An audio clip carrying a keyframed volume ramp: the rubber-band line with a keyframe diamond at the playhead. A second frame shows a red-highlighted region on the music track where the level is pulled down."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:05:13"
    quote: "The next problem that comes up is audio levels. In some places the music is so loud that your voice gets lost in the middle of it."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:05:30"
    quote: "Keep your vocals between minus 3 and 0 decibels, and the music between minus 22 and minus 25 decibels."
research_refs:
  - https://en.wikipedia.org/wiki/Ducking
  - https://en.wikipedia.org/wiki/Dynamic_range_compression
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/EBU_R_128
  - _meta/visual-kt-delta.md
difficulty: medium
detectable_from: video
---

# Ducking — demonstrated on screen, never named: the keyframed dip under the voice

## What it is
**This note is credited to visual observation, not to a quote.** The transcript pass over `editing kt 3` concluded that ducking is never taught: the spoken answer to voice-versus-music is a static music floor at −22 to −25 dB plus full drop-outs at emphasis points, and no pass contains the words *duck*, *keyframe*, *automation* or *sidechain*. Reading the contact sheet contradicts that. The screen recording shows a **Premiere audio clip with a keyframed volume ramp** — the rubber-band line with a keyframe diamond sitting at the playhead — and a second frame shows a **red-highlighted dip on the music track**. So **the creator ducks, and does not name it.** The narration describes a static floor while the hands do something more capable.

That gap is worth stating precisely, because it changes what the KT is evidence *for*. It is evidence that the technique is in the working method, and it is **not** evidence for any particular depth, curve or trigger — none of those are visible or spoken. Every number below therefore comes from research and from this stack's own contract, and is labelled as such.

The technique itself: a bed sits at its standing level and is **pulled down for the duration of a line, then restored**, instead of living at one level for the whole video. It buys two things a static floor cannot. It lets the bed sit **louder between phrases**, where it is doing its actual job of carrying energy, while still clearing the voice when the voice arrives. And it makes intelligibility a function of what is actually happening rather than of a worst-case guess. The physical reason it works is masking: a masker buries a signal most when they share a frequency band and the masker is louder, so the fix is either to move the bed down in **level** (a duck) or out of the **band** (a carve).

**Where it sits against the two techniques the source does name.** A static floor ([[sfx-layer-volume-targets]]) is the baseline this modulates. A full stop ([[sfx-music-hard-stop]], [[sfx-music-rest-windows]]) is the extreme version, used as a rhetorical device rather than as level management. Ducking is the middle term the narration skips.

## When to use it
- **Any bed under narration where the bed is also doing energy work.** If dropping it 8 dB for the whole section would make the section feel dead, duck it instead ([[sfx-beat-forward-bed-under-voice]]).
- **Where the VO is intermittent.** A section with long gaps between lines is the strongest case: the bed comes up in the gaps and the video breathes.
- **Under a demonstration.** When a sound or a clip is being shown, everything that is not the demonstration ducks ([[sfx-audio-demo-insert]], [[sfx-demo-clip-loudness-handover]]).
- **Under a dense or distorted bed**, in addition to the level correction, not instead of it ([[sfx-loud-guitar-minus-30]]).
- **Prefer the carve over the duck when the problem is intelligibility.** This stack's intended answer for music-under-voice is spectral: *"The reflex is to duck the whole bed, which works and costs the bed all of its presence… Carve takes only those bands the voice occupies, and the bed keeps its low end and its top."* Duck when the gesture is meant to be *felt* (a swell pulling back for a line); carve when the goal is simply that every word is heard.
- **Not on SFX.** A whoosh or an impact is short enough that a duck on it reads as a mistake; if an effect is masking a word, move it or lower it.
- **Not as a substitute for a rest.** A bed ducked for four minutes straight is still a bed that never stops ([[sfx-music-rest-windows]]).

## How to recognise it in a reference video
- **Watch the bed between phrases.** Play a narrated stretch and listen only to the music. If it rises perceptibly in the gaps between sentences and drops again as the next line starts, it is ducked. A static floor does neither.
- **Measure it, do not guess.** Extract the music-only passages and the under-voice passages and compare short-window RMS: `ffmpeg -i ref.wav -af astats=metadata=1:reset=0.4 -f null -`. A **4–10 dB** difference between "voice present" and "voice absent" windows is a duck; **0–2 dB** is a static floor; **more than 14 dB** is effectively a drop-out.
- **Look at the shape of the transition.** A ducked bed moves over **150–400 ms**; a hard-stopped bed moves in under 40 ms. If the fall is instantaneous, this is [[sfx-music-hard-stop]], not ducking.
- **Check whether the low end also drops.** A level duck attenuates the whole spectrum; a carve leaves the sub and the air intact and cuts only 600 Hz–5 kHz. Compare spectrograms of the two states — if the bed's bass is unchanged under the voice, the reference is carving, not ducking.
- **On screen:** a rubber-band line with diamonds on an audio clip, or a highlighted region on the music track, is the technique being demonstrated whether or not it is named. Worth logging as a **tool tell** in a style profile ([[sfx-translation-check-devices]] for the monitoring argument that motivates it).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `bed_level_nominal` | −22 dB (`data-volume="0.079"`) | −25 to −20 dB | The source's stated floor. Ducking modulates around this, it does not replace it. |
| `duck_depth` | −6 dB (lane `v` 0.5 of nominal) | −4 to −10 dB | Research value, not sourced. Under 4 dB is inaudible; past 10 dB the bed disappears and the gesture reads as a drop-out. |
| `duck_attack` | 200 ms | 120–350 ms | Down-ramp before the first word. Faster than ~100 ms is audible as a pump. |
| `duck_release` | 400 ms | 300–800 ms | Up-ramp after the last word. Deliberately slower than the attack — the ear forgives a slow return and notices a fast one. |
| `pre_roll` | 150 ms | 100–250 ms | The duck starts *before* the word, so the first consonant is already clear. |
| `hold_between_lines` | 600 ms | 400–1200 ms | Gaps shorter than this stay ducked; releasing and re-ducking inside a sentence pumps. |
| `carve_strength` | 0.25 | 0.15–0.45 | The spectral alternative. Default = *"a 6 dB dip in three bands"*; 0.5 is where it is heard as an effect. |
| `voice_level` | −3 to 0 dB | — | Confirmed twice on screen; the voice does not move to solve a masking problem ([[sfx-layer-volume-targets]]). |
| `lane_points_max` | 512 | — | Hard limit per automation lane in this stack. A duck per line in a 10-minute video fits; a duck per word does not. |

## Reproduction prompt

```
The music bed under narration is masking the voice, or is flat and lifeless
between lines. Duck it rather than lowering it globally.

1. DECIDE THE ROUTE FIRST.
   - Goal is intelligibility only -> use the voiceover CARVE, not a duck:
     set data-fx-carve on the BED (never on a voice) with
     sources:["voiceover"], strength 0.25, then run
     node <SKILL_DIR>/scripts/carve.mjs --comp index.html
   - Goal is a felt gesture (bed swells between lines) -> continue below.
2. GET THE SPEECH WINDOWS. Detect them instead of eyeballing:
   ffmpeg -i vo.wav -af silencedetect=noise=-35dB:d=0.4 -f null -
   Convert the silence list into [start,end] speech intervals.
3. BUILD ONE VOLUME LANE on the bed clip, in CLIP-LOCAL seconds:
   - an explicit {"t":0,"v":1} first point, or the lane holds its first value
     backwards and the bed starts already ducked;
   - for each speech interval: v=1 at (start - 0.35), v=0.5 at (start - 0.15),
     v=0.5 at (end + 0.05), v=1 at (end + 0.45);
   - merge any two intervals separated by less than 0.6 s into one duck.
4. DO NOT also GSAP-tween volume on the same track: the lane wins and the
   tween is silently ignored.
5. VERIFY BY MEASUREMENT, not by memory:
   ffmpeg -i mix.wav -af astats=metadata=1:reset=0.4 -f null -
   RMS in voice windows minus RMS in gap windows should be 4-10 dB.

ACCEPTANCE TEST: play the section at a comfortable level. Every word is
intelligible without leaning in; the bed is audibly present between phrases;
and you cannot hear the moment the bed moves. If you can hear it move, the
attack is too fast or the depth is past 10 dB.
```

## Execution spec

**HyperFrames — the duck is a `volume` automation lane.** Three mechanisms exist and their precedence is fixed: `data-volume` (static) < `data-automation` lane < GSAP `volume` tween — except that a lane and a tween on the same track raise `audio_volume_double_automation` and *the lane wins*. Use the lane.

```html
<audio id="music-bed" src="assets/audio/bgm/bed.wav" data-audio-group="music"
       data-start="30.00" data-duration="48.00" data-media-start="6.80"
       data-track-index="11" data-volume="0.079"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:1.65,&quot;v&quot;:1},{&quot;t&quot;:1.85,&quot;v&quot;:0.5},{&quot;t&quot;:7.30,&quot;v&quot;:0.5},{&quot;t&quot;:7.70,&quot;v&quot;:1},{&quot;t&quot;:11.20,&quot;v&quot;:1},{&quot;t&quot;:11.40,&quot;v&quot;:0.5},{&quot;t&quot;:18.05,&quot;v&quot;:0.5},{&quot;t&quot;:18.45,&quot;v&quot;:1}]}]}"></audio>
```
The load-bearing details: `t` is **clip-local seconds** (a bed at `data-start="30"` has `t:0` at composition time 30) — **except on an `<hf-audio-group>` bus, where `t` is composition time**, which is the reason a single-member bus is sometimes worth creating. `v` is 0..1 for volume, so the lane values above are *fractions of `data-volume`*, and 0.5 of −22 dB is about −28 dB. A lane holds its first value backwards and its last value forwards, hence the explicit `{"t":0,"v":1}`. `curve` (−1..1) bends the segment **leaving** a point — a small negative curve on the release makes the return less linear and less noticeable. Maximum **512 points per lane**. Write the JSON **double-quoted with `&quot;`** or `carve.mjs` cannot see it and will overwrite work it could not read.

**The preferred alternative — the carve.** `data-fx-carve` goes on the **bed only**, `sources` is a list naming an **audio group** (never clip ids — `audio_carve_ungrouped_sources`), and the group must contain voices only. It is clip-only; on a bus it raises `audio_group_carve_attr`. Carve and duck compose: carve for intelligibility, a shallow 3–4 dB lane on top for the gesture.

**Generated keyframes, if the lane is built by tooling.** `node <SKILL_DIR>/scripts/audio-duck.mjs --meta audio_meta.json --target "#bgm" --composition index.html` writes GSAP tweens — remember a `volume` tween is **absolute** and replaces `data-volume` rather than scaling it, and loses to any lane on the same track.

**ffmpeg — measure, and bake for export only.**
```bash
# speech windows -> the duck's trigger list
ffmpeg -i vo.wav -af silencedetect=noise=-35dB:d=0.4 -f null -
# verify the depth actually achieved
ffmpeg -i mix.wav -af astats=metadata=1:reset=0.4 -f null - 2>&1 | grep RMS
# true sidechain, for assets LEAVING the pipeline only
ffmpeg -i bed.wav -i vo.wav -filter_complex \
  "[0:a][1:a]sidechaincompress=threshold=0.03:ratio=8:attack=200:release=400[a]" -map "[a]" ducked.wav
```

**Premiere, for reference.** What the reference video shows is clip-level volume keyframes on the rubber band — the same envelope, drawn by hand. Its Essential Sound panel also carries an auto-ducking generator that writes the same keyframes; the contact sheet does not show which was used, and this note does not claim one.

**Remotion.** `<Audio volume={f => …} />` accepts a frame-indexed function, which is the lane by another name; the carve has no equivalent.

## Pairs with
[[sfx-layer-volume-targets]] · [[sfx-loud-guitar-minus-30]] · [[sfx-beat-forward-bed-under-voice]] · [[sfx-music-rest-windows]] · [[sfx-music-hard-stop]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-dialogue-gate]] · [[sfx-translation-check-devices]] · [[sfx-music-ten-point-framework]] · [[sfx-audio-demo-insert]]

## Failure modes
- **Claiming the source teaches this.** It does not. The narration teaches a static floor; the screen shows a keyframed ramp. Any note, profile or spec that quotes the creator on ducking is fabricating a quote.
- **Ducking when the problem is spectral.** A 10 dB duck to rescue consonants costs the bed all its presence. Carve first, duck second.
- **Attack too fast.** Under about 100 ms the bed audibly lurches on every sentence. 120–350 ms.
- **Release too fast.** A quick return is more noticeable than a quick fall; keep release longer than attack.
- **Re-ducking inside a sentence.** Short inter-word gaps trigger a release-then-duck cycle that pumps. Merge intervals closer than 600 ms.
- **A lane and a GSAP tween on the same track.** The lane wins and the tween is silently ignored — the classic "my keyframes do nothing" bug.
- **Missing `{"t":0,"v":1}`.** The lane holds its first value backwards to the clip start, so a bed whose first point is a duck starts already ducked, often before the voice even exists.
- **Raising the voice instead.** Pushes dialogue toward the ceiling and makes the whole mix harsh. The bed moves; the voice does not.
- **Known gap:** the depth, curve and trigger the creator actually used are unknown — the contact sheet shows that a ramp exists, not what it is worth in dB. Treat the numbers here as this library's defaults, and say so when they are quoted downstream.
