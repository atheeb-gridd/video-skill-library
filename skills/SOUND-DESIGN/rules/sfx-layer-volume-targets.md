---
id: sfx-layer-volume-targets
title: The three-tier level hierarchy — dialogue 0/-3, SFX -12/-15, music -20/-25
skill: sound-design
type: mix
family: mix-levels
tags: [skill/sound-design, type/mix, family/mix-levels, engine/hyperframes, engine/ffmpeg, layer/dialogue, layer/music, layer/sfx, source/sfx-kt-2, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:08:08"
    quote: "Dialogue should be at 0 to -3 decibels, music should be at -20 to -25 decibels, and sound effects should be at -12 to -15 decibels."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:05:30"
    quote: "For this I'll give you very simple numbers: keep your vocals between minus 3 and 0 decibels, and the music between minus 22 and minus 25 decibels."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "visual — contact sheet, full-frame title card"
    quote: "[NOT SPOKEN — read off screen] DIALOGUES / 0 to -3dB, cut against a Premiere audio meter showing green levels."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "visual — contact sheet, full-frame title card"
    quote: "[NOT SPOKEN — read off screen] Vocals Vol / -3 to 0dB, with a waveform glyph, beside a meter."
research_refs:
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://en.wikipedia.org/wiki/LUFS
  - https://en.wikipedia.org/wiki/Crest_factor
  - https://en.wikipedia.org/wiki/Auditory_masking
difficulty: medium
detectable_from: audio
---

# The three-tier level hierarchy — dialogue 0/-3, SFX -12/-15, music -20/-25

## What it is
The numeric backbone of every mix in this library: dialogue on top at 0 to −3, sound effects roughly 12 dB under it, music roughly 22 dB under it. Two separate source videos give the same music figure, which is the strongest signal in the whole corpus that these are the creator's real working numbers and not an off-the-cuff answer. The critical correction research adds: **these are fader positions relative to a normalised dialogue anchor, not absolute dBFS targets**. A raw Epidemic download and a raw voice recording do not arrive at the same reference level, so the ratios only hold once the dialogue stem has been normalised first.

**The dialogue figure is confirmed, not provisional.** An earlier pass flagged `−3 to 0 dB` as single-source and approximately placed, because the improved transcripts dropped the number. Reading the videos settles it: the figure is **put on screen twice, in two different videos** — `sfx kt 2` carries a full-frame title card `DIALOGUES / 0 to -3dB` cut against a Premiere audio meter showing green levels, and `editing kt 3` carries a card `Vocals Vol / −3 to 0dB` with a waveform glyph beside a meter. Two independent on-screen statements plus the spoken line make this the creator's stated standard. Treat it as **established**, and stop hedging it downstream.

Two caveats survive that confirmation, and both are research rather than source. First, these are **clip-gain peak** figures, not programme loudness: a −3 dBFS peak on voice is hot by broadcast norms, and a delivery bound by a loudness target still has to be checked on a meter ([[sfx-translation-check-devices]]). Second, the reason the creator gives for using numbers at all is that *"every device's drivers are different, so it sounds different on everything"* — the numbers are a defence against monitoring, which is exactly why they must not be treated as a substitute for one measurement pass at the end.

**The static floor is not the whole method.** The narration teaches a fixed music level plus full drop-outs; the screen shows a keyframed volume ramp and a highlighted dip on the music track. Ducking is demonstrated and never named — see [[sfx-ducking-keyframed-dip]] for the technique, and read these numbers as the level the bed sits at *between* ducks.

## When to use it
Always, as the starting position for every audio clip you place. Set these before you tune anything by ear, and treat any departure as a decision you have to justify (the two justified departures in this library are [[sfx-loud-guitar-minus-30]] for dense guitar beds and the momentary drop to silence in [[sfx-music-hard-stop]]). If a mix "sounds fine" but the numbers are wildly off these, the reference monitoring is wrong, not the numbers.

## How to recognise it in a reference video
- Extract the audio and measure in 30 s windows: `ffmpeg -i ref.mp4 -vn -af astats=metadata=1:reset=30 -f null -`. A three-tier mix shows dialogue RMS clustering ~18–22 dB above the music-only passages.
- Find a passage with music but no speech, and one with both. The delta between the music's RMS in the two passages tells you whether ducking or carving is in use; **0–2 dB delta = static bed, 4–8 dB = ducked, spectral-only change = carved**.
- Programme loudness of the finished file: `ffmpeg -i ref.mp4 -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -`. Creator-style YouTube uploads land between −16 and −13 LUFS integrated; anything at −20 or below has been mixed for broadcast, not socials.
- SFX peaks are visible on a waveform as isolated transients rising ~8–12 dB above the music floor but staying **below** the speech peaks. If a whoosh out-peaks the voice, this rule is not being followed.
- Dialogue true peak should sit at or under −1.5 dBTP with no flat-topped clipping.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Dialogue anchor (integrated) | −16 LUFS | −18 to −14 LUFS | Normalise the voice stem here first; every other number is relative to it. |
| Dialogue fader | 0 dB → `data-volume="1"` | −3 to 0 dB (0.708–1.0) | Loudest layer, always. |
| SFX fader | −12 dB → `data-volume="0.25"` | −15 to −9 dB (0.178–0.355) | −9 dB only for a deliberate accent; see [[sfx-cinematic-hit-emphasis]]. |
| Music bed fader | −22 dB → `data-volume="0.079"` | −25 to −20 dB (0.056–0.1) | Both source videos agree on ≈−22. |
| Ambience bed fader | −28 dB → `data-volume="0.04"` | −32 to −24 dB | Not in the transcript; derived — ambience must sit under music or it reads as noise. See [[sfx-ambience-search-formula]]. |
| Programme target | −14 LUFS I | −16 to −13 LUFS I | YouTube/Tidal normalise to −14 LUFS. Podcast leg: −16. |
| True peak ceiling | −1.5 dBTP | −2 to −1 dBTP | EBU R128 caps at −1 dBTP; −1.5 leaves codec headroom. |
| Carve strength | 0.25 | 0.15–0.35 | HyperFrames default; 0.5 is audible as an effect. |

## Reproduction prompt

```
Set the mix hierarchy for this composition. Do it in this order and do not skip step 1.

1. NORMALISE THE ANCHOR. For every dialogue/voiceover source file, run a two-pass
   ffmpeg loudnorm to I=-16, TP=-1.5, LRA=11. Write the normalised files to
   assets/audio/voice/. These become the 0 dB reference.
2. PLACE AND SET GAIN. Every <audio> gets an id, data-audio-group, a track index
   of 10+, and a data-volume from this table:
     dialogue / voiceover  -> data-audio-group="voiceover"  data-volume="1"
     sound effects         -> data-audio-group="sfx"        data-volume="0.25"
     music bed             -> data-audio-group="music"      data-volume="0.079"
     ambience bed          -> data-audio-group="ambience"   data-volume="0.04"
   data-volume is a LINEAR multiplier, not dB. Convert with 10^(dB/20). Never
   author a dB number into data-volume.
3. CARVE, DO NOT DUCK. On the music bed only, add
   data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
   then run: node <SKILL_DIR>/scripts/carve.mjs --comp index.html
   Never put data-fx-carve on a voice clip or on an <hf-audio-group>.
4. VERIFY. Render, then measure the render:
   ffmpeg -i out.mp4 -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -

ACCEPTANCE TEST: integrated loudness of the render is between -16 and -13 LUFS;
input_tp is at or below -1.5; and in a passage carrying dialogue + music + one
SFX, every word is intelligible at a listening level where the music is only
just audible. If a word is masked, lower the music bed 2 dB and re-measure -
do not raise the dialogue.
```

## Execution spec

**HyperFrames.** `data-volume` defaults to `1` (0 dB) and is capped at `3.98` (+12 dB). It is a **linear amplitude multiplier**, so the transcript's dB values must be converted before they are authored — this is the single most common way this rule gets executed wrongly. Conversion table (`10^(dB/20)`):

| dB | 0 | −3 | −6 | −9 | −12 | −15 | −20 | −22 | −25 | −28 | −30 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `data-volume` | 1.0 | 0.708 | 0.501 | 0.355 | 0.251 | 0.178 | 0.1 | 0.079 | 0.056 | 0.04 | 0.032 |

```html
<audio id="vo-01" src="assets/audio/voice/line-01.wav"
       data-audio-group="voiceover" data-start="0.5" data-track-index="10"></audio>

<audio id="music-bed" src="assets/audio/bgm/bed.mp3"
       data-audio-group="music" data-start="0" data-duration="{{DURATION}}"
       data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>

<audio id="sfx-whoosh-01" src="assets/audio/sfx/whoosh-01.wav"
       data-audio-group="sfx" data-start="{{T}}" data-track-index="12"
       data-volume="0.25"></audio>
```

Every `<audio>` **must** have an `id` — an id-less audio element is never mixed and renders silent (`media_missing_id`, error). Do not combine `data-volume` with a GSAP `volume` tween on the same element: the tween is absolute and replaces the gain (`audio_volume_tween_overrides_gain`). A `volume` automation lane also beats a tween (`audio_volume_double_automation`).

**ffmpeg.** Anchor normalisation, two-pass:
```bash
ffmpeg -i voice.wav -af loudnorm=I=-16:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -i voice.wav -af loudnorm=I=-16:TP=-1.5:LRA=11:measured_I=<i>:measured_TP=<tp>:measured_LRA=<lra>:measured_thresh=<t>:offset=<o>:linear=true voice.norm.wav
```
Final programme check uses the same filter with `I=-14`. Nothing in `hyperframes check` validates levels — *"almost no static gate covers the mix"* — so this measurement step is the only gate that exists.

**Epidemic Sound.** Downloads arrive at the publisher's own level, not yours. Always pull `fileType: "WAV"` for anything you will gain-stage (`DownloadSoundEffect` / `DownloadRecording`), and treat the level of every returned file as unknown until measured.

**Remotion.** Same idea: `<Audio volume={0.25} />` takes a linear multiplier, so the same conversion table applies; the loudness normalisation still happens in ffmpeg outside the renderer.

## Pairs with
[[sfx-loud-guitar-minus-30]] · [[sfx-five-layers-build-order]] · [[sfx-music-hard-stop]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-motion-sound-selection]] · [[sfx-ambience-search-formula]] · [[sfx-sound-pass-order]] · [[sfx-ducking-keyframed-dip]] · [[sfx-music-ten-point-framework]]

## Failure modes
- **Authoring the dB number straight into `data-volume`.** `data-volume="-12"` is not −12 dB; it is a negative multiplier and will phase-invert or clamp. Always convert.
- **Applying the ratios to un-normalised sources.** A quiet voice recording at `data-volume="1"` under a hot Epidemic bed at `0.079` still loses. Normalise the anchor first — the ratios are relative, not absolute.
- **Ducking the whole bed instead of carving.** Costs the bed all of its presence. Use `data-fx-carve` against the `voiceover` group; reach for a plain `volume` lane only when there is no speech to analyse.
- **Chasing the platform target instead of the hierarchy.** Hitting −14 LUFS with a mix where music masks the words is still a failed mix. Intelligibility first, loudness second.
- **Known gap:** the stack has no loudness meter inside the composition and no lint rule for levels. The only verification is a render plus an ffmpeg measurement, and the render cannot run on the authoring VM (linux ARM64, no browser). Budget for that round trip.
