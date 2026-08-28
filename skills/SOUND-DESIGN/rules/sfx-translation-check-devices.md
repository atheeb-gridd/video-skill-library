---
id: sfx-translation-check-devices
title: Mix to the meter, verify on the worst device — the translation check
skill: sound-design
type: mix
family: mix-levels
tags: [skill/sound-design, type/mix, family/mix-levels, layer/dialogue, layer/music, layer/sfx, engine/ffmpeg, engine/hyperframes, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:05:25"
    quote: "Every device's drivers are different, so it sounds different on everything."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:05:30"
    quote: "For this I'll give you very simple numbers: keep your vocals between minus 3 and 0 decibels, and the music between minus 22 and minus 25 decibels."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:05:13"
    quote: "The next problem that comes up is audio levels. In some places the music is so loud that your voice gets lost in the middle of it."
research_refs:
  - https://en.wikipedia.org/wiki/Loudness_normalization
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://en.wikipedia.org/wiki/Inverse-square_law
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: audio
---

# Mix to the meter, verify on the worst device — the translation check

## What it is
The source gives fixed decibel numbers and gives a reason for them: playback hardware differs, so your ears on your setup are not a target. That reason is correct and incomplete. Numbers protect you from **your monitoring**; they do not protect you from **the viewer's monitoring**, because the two failures have different causes. This note is the second half — the verification protocol that proves a mix survives the devices people actually watch on.

Three separate things vary between playback systems, and each breaks a different part of the mix:

1. **Loudness.** Every major platform re-levels your upload: Spotify, YouTube, YouTube Shorts and TikTok normalise to **−14 LUFS**; Netflix and Prime Video sit at **−27 to −24 LUFS**; broadcast is **−23 LUFS** (EBU R 128) or **−24 LUFS** (ATSC A/85). The gain change is applied to your **whole programme** — *"the gain is changed to bring the average loudness to a target level"* — so mixing hot wins nothing and costs headroom. What survives normalisation is the *ratio* between your layers, which is exactly what the source's numbers describe.
2. **Bandwidth.** A phone speaker reproduces very little below roughly 200 Hz. Any weight that lives only in the 40–80 Hz band is simply absent for a large share of viewers, and a mix balanced on headphones can arrive on a phone with no low end and a thin, harsh voice.
3. **Channel count.** Most phone speakers are mono. A stereo bed that sounds wide on headphones can partially cancel when summed, and a wide bed is not a fix for masking anyway.

The discipline that follows is simple: **set levels by meter, then verify by simulation.** Both, in that order. The meter fixes the balance; the simulation catches what the meter cannot see.

## When to use it
- **Before every render that leaves the project** — this is the last gate in the sound pass, after [[sfx-layer-volume-targets]] has set the hierarchy and after any carve or ducking is in place.
- **Immediately, whenever a mix decision was made "by ear at a comfortable volume"** — particularly bass-heavy design work ([[sfx-bass-drop-under-impact]]) and anything with a wide stereo bed.
- **Whenever a video is being cut for more than one destination** — a 9:16 phone-first cut and a 16:9 desktop cut need the same check but tolerate different answers.
- Skip it only for internal previews that nobody watches on a phone.

## How to recognise it in a reference video
This is a process rule, so the evidence is in what the finished audio survives rather than in a visible technique:
- **Integrated loudness sits in the normalisation band.** Measure it. Creator uploads that were mixed for platform land **−16 to −13 LUFS integrated**; a file at −20 or below was mixed for broadcast, a file above −11 was mixed loud and will simply be turned down.
- **True peak is under the ceiling.** −1 to −1.5 dBTP, with no flat-topped clipping in the waveform. Repeated flat tops mean a limiter was used as a fader.
- **The voice survives a 200 Hz high-pass.** Band-limit the reference to a phone's response and listen: in a well-translated mix the words are still fully intelligible and the impacts still register (because they carry a 120–220 Hz punch band, not only sub).
- **Mono sum is stable.** Fold to mono and compare level: a drop of more than ~3 dB in the music bed, or a bed that visibly thins, indicates phase problems that will hit half the audience.
- **Loudness range is modest.** LRA above about 12 LU in a talking-head video means quiet passages will disappear on a phone in a noisy room.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Programme integrated | −14 LUFS | −16 to −13 LUFS | The target every major social platform normalises to. |
| True peak ceiling | −1.5 dBTP | −2 to −1 dBTP | EBU R 128 caps at −1 dBTP; −1.5 leaves lossy-codec headroom. |
| Loudness range (LRA) | ≤ 9 LU | 5–12 LU | Talking-head content. Cinematic pieces may run higher and accept the cost. |
| Phone-simulation high-pass | 200 Hz | 150–400 Hz | 2-pole. Simulates a small speaker's low-end roll-off. |
| Phone-simulation low-pass | 12 kHz | 10–16 kHz | Optional; small drivers also lose the top. |
| Mono-sum level drop tolerance | ≤ 3 dB | ≤ 4 dB | Larger drops mean phase cancellation in the bed. |
| Quiet-listening check level | ≈ 55 dB SPL | 50–60 | Verify dialogue intelligibility at low volume, not at mix volume. |
| Dialogue anchor | −16 LUFS | −18 to −14 | Normalise the voice stem first; every other number is relative to it. |

## Reproduction prompt
```
Run the translation check on the finished mix before rendering the deliverable.

STEP 1 - METER. Measure the full mix:
  ffmpeg -i {{MIX}} -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
Record input_i, input_tp, input_lra. Required: input_i between -16 and -13 LUFS,
input_tp <= -1.0 dBTP, input_lra <= 12 LU. If input_i is outside the band, correct
with ONE global gain move on the master, never by re-balancing layers.

STEP 2 - PHONE SIMULATION. Render a check file, do not ship it:
  ffmpeg -i {{MIX}} -af "pan=mono|c0=0.5*c0+0.5*c1,highpass=f=200:poles=2,lowpass=f=12000" \
    -ar 48000 check_phone.wav
Listen at LOW volume. Required: (a) every word intelligible, (b) every impact still
audible as an impact, (c) no sound effect newly sticking out. If an impact vanishes,
it lives only below 200 Hz - add a 120-220 Hz punch layer rather than raising it.

STEP 3 - MONO. Compare the stereo and mono-summed levels of a music-only passage:
  ffmpeg -i {{MIX}} -ss {{MUSIC_ONLY_TC}} -t 5 -af astats=metadata=1 -f null -
  ffmpeg -i {{MIX}} -ss {{MUSIC_ONLY_TC}} -t 5 -af "pan=mono|c0=0.5*c0+0.5*c1,astats=metadata=1" -f null -
A mono RMS more than 3 dB below the stereo RMS is phase cancellation: narrow the bed.

STEP 4 - NORMALISATION PREVIEW. Apply the platform's own move and re-listen:
  ffmpeg -i {{MIX}} -af "volume={{-14 - input_i}}dB" preview_normalised.wav

ACCEPTANCE: all four steps pass, with the phone check judged on intelligibility at
low volume and NOT on how impressive it sounds. Log input_i, input_tp, input_lra
and the mono delta in the design document. If a step fails, fix the mix and re-run
STEP 1 - never ship a mix whose only passing test was the one you listened to.
```

## Execution spec

**ffmpeg (primary).** Everything here is a raw-media measurement on a rendered file, which is exactly what `media-use`/ffmpeg owns. Two-pass `loudnorm` is the sanctioned form; measure first, then apply the measured values:

```bash
# pass 1 - measure
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -

# pass 2 - apply, using the printed values
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=<input_i>:measured_TP=<input_tp>:\
measured_LRA=<input_lra>:measured_thresh=<input_thresh>:offset=<target_offset>:linear=true \
  mix.social.wav
```

Use `I=-16` for a podcast leg. `astats` gives the RMS/peak numbers for the mono comparison. Note the environment caveat from the contract: **ffmpeg is assumed present but is not verified in this project**, so a translation check that cannot run must be reported rather than skipped.

**HyperFrames.** The mix itself is declared, not baked. Put the master ceiling on the composition's audio as a `limiter` node **last** in the chain (chain order doctrine: *"character and ceiling last"*), with `limit: -1`:

```html
<hf-audio-group id="master" data-label="Master"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;m1&quot;,&quot;label&quot;:&quot;Peak Ceiling&quot;,&quot;params&quot;:{&quot;limit&quot;:-1,&quot;attack&quot;:5,&quot;release&quot;:50}}]}"></hf-audio-group>
```

Two contract facts constrain the workflow. **`limiter` has no automatable parameters** (nor do `compressor`, `gate`, `bitcrush`) — automate a `gain` stage around it if you need movement. And **there is no loudness meter inside HyperFrames**: the audio render happens in an `OfflineAudioContext` in a headless browser, so integrated loudness can only be measured on the rendered file, with ffmpeg, after the fact. Since *"browser-dependent rendering must happen elsewhere"* on this device VM, the measurement leg runs wherever the render ran — plan for it rather than discovering it at the end.

**Epidemic Sound.** Not a fetch note, but relevant on the way in: downloaded music and SFX arrive at wildly different levels, so normalise the **dialogue** stem first and place everything else relative to it ([[sfx-layer-volume-targets]]). Never loudnorm individual SFX files — it destroys their dynamics; set their level with `data-volume` instead.

**Remotion.** Concept only: same rendered-file measurement, same ffmpeg passes. Nothing in the runtime measures loudness either.

## Pairs with
[[sfx-layer-volume-targets]] · [[sfx-noise-floor-target]] · [[sfx-bass-drop-under-impact]] · [[sfx-dialogue-gate]] · [[sfx-loud-guitar-minus-30]] · [[sfx-music-cue-sheet-per-segment]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-demo-clip-loudness-handover]]

## Failure modes
- **Trusting one pair of headphones.** The source's own diagnosis. Closed-back headphones flatter bass and hide masking; the meter plus the phone simulation is the answer, not a better pair.
- **Mixing loud to "compete".** Platform normalisation turns the whole programme down again, so all a hot master buys is reduced dynamic range and pumping. Hit −14 LUFS and stop.
- **Fixing a failed phone check by raising the sub.** The sub is not reproduced. Add the 120–220 Hz punch band instead — that is what a small speaker plays.
- **Widening the bed to make room for the voice.** Spatial separation barely helps informational masking and collapses to mono on the device most viewers use. Carve instead.
- **Judging the phone check at mix volume.** The failure mode being tested is quiet listening in a noisy room. Turn it down.
- **Treating −3 dBFS peak on vocals as a loudness target.** It is a peak position, not a loudness. A voice peaking at −3 can be anywhere from −20 to −12 LUFS. Anchor the voice by loudness and let the peaks land where they land.
- **Known gap:** there is no loudness meter, no phase meter and no mono-check inside the composition tooling, and lint validates none of the audio chain. Every number in this note comes from an external measurement on a rendered file; if the render cannot be produced on this machine, the check is deferred, not passed.
