---
id: sfx-dialogue-gate
title: Layer 1 is a gate — measurable thresholds for "good enough to build sound design on"
skill: sound-design
type: mix
family: layers
tags: [skill/sound-design, type/mix, family/layers, engine/hyperframes, engine/ffmpeg, engine/epidemic, layer/dialogue, source/sfx-kt-2, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:26"
    quote: "First of all, if this itself is bad, then no amount of sound design is going to make a difference."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:29"
    quote: "Now for this, you can get a decent mic and learn basic audio editing from this video."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:08:08"
    quote: "Dialogue should be at 0 to -3 decibels, music should be at -20 to -25 decibels, and sound effects should be at -12 to -15 decibels."
research_refs:
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://en.wikipedia.org/wiki/Signal-to-noise_ratio
  - https://en.wikipedia.org/wiki/Proximity_effect_(audio)
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: audio
---

# Layer 1 is a gate — measurable thresholds for "good enough to build sound design on"

## What it is
The five layers are usually read as a build order. Layer 1 is not a step in that order; it is a **gate**. The source states it in the first thirty seconds: *"if this itself is bad, then no amount of sound design is going to make a difference."* Every layer above dialogue is additive — ambience, foley, effects, music all sit *under* the voice and are mixed relative to it — so a voice that is not intelligible, not even, or sitting on an audible noise floor gets worse with each layer added, not better. Building the sound design first and hoping the mix rescues the voice is the single most expensive mistake in this library, because it wastes the whole pass.

The gate has to be measurable or it is just an opinion, so this note gives four numbers to measure and a hard branch: **pass → proceed to layer 2; fail → fix the source or replace it.** It also names honestly which failures this stack **cannot** fix, because "get a better source" is sometimes the entire correct answer.

The stack's own doctrine for the fixing order is one line worth memorising: *"Subtract before you add, level after you filter, relationships after level, character and ceiling last."*

## When to use it
- **Before the sound pass starts.** Run it once per voice source in the project — a change of room, mic or session is a new source and a new gate.
- **On any imported voiceover**, including a synthesized one. Generated voice is clean but can be uneven and over-loud.
- **When the mix "won't come together".** If music at −22 dB still buries the voice, or the voice sounds thin at every level, the diagnosis is almost always upstream of the mix.
- **Before recommending a re-record.** The gate is what makes that recommendation defensible: a number, not a taste.
- **Not as a mastering pass.** The gate is about whether the material is usable. Programme loudness is set at the end, after all five layers ([[sfx-layer-volume-targets]]).
- **Not on a diegetic sync-sound clip that is *meant* to sound rough** — a phone recording played inside the video, a piece of archive footage. Those are content, not layer 1.

## How to recognise it in a reference video
This section doubles as the measurement procedure, because for a reference video "recognising it" *is* running the gate.

- **Split the voice out and look at it.**
  ```bash
  ffmpeg -i ref.mp4 -vn -ac 1 -ar 48000 /tmp/vo.wav
  ```
- **1. Noise floor.** Find speech gaps of at least 400 ms and measure RMS inside them. The trick is to isolate the gaps rather than eyeball them:
  ```bash
  ffmpeg -i /tmp/vo.wav -af "silencedetect=noise=-40dB:d=0.4" -f null - 2>&1 | grep silence_
  # then measure one of those gaps
  ffmpeg -ss <gap_start> -t 0.4 -i /tmp/vo.wav -af volumedetect -f null - 2>&1 | grep -E 'mean_volume|max_volume'
  ```
  | Gap RMS | Verdict |
  |---|---|
  | ≤ −60 dBFS | clean. Nothing will surface when you normalise. |
  | −60 to −50 dBFS | workable. Audible only if you compress hard. |
  | −50 to −45 dBFS | marginal. It will be heard after normalising to −14 LUFS. |
  | **> −45 dBFS** | **fail.** Compression plus normalisation makes this hiss a character in the video. |
- **2. Signal-to-noise ratio.** `SNR(dB) = 20·log₁₀(A_signal / A_noise)` from RMS amplitudes; in practice, speech RMS minus gap RMS in dB.
  | SNR | Verdict |
  |---|---|
  | ≥ 45 dB | pass |
  | 35–45 dB | pass with care; keep the bed a little lower |
  | 30–35 dB | marginal |
  | **< 30 dB** | **fail** |
- **3. Peak headroom and clipping.** `ffmpeg -i /tmp/vo.wav -af volumedetect -f null -`. Peaks should sit at **−12 to −6 dBFS** before any treatment. `max_volume: 0.0 dB` plus a run of identical full-scale samples is clipping, and **clipping is unfixable** — the waveform is gone. Any clipped syllable in a load-bearing line is a fail.
- **4. Loudness and consistency.**
  ```bash
  ffmpeg -i /tmp/vo.wav -af ebur128=framelog=verbose -f null - 2>&1 | tail -12
  ```
  Read integrated LUFS and LRA. For a single narrating voice after levelling, expect **LRA of 5–9 LU**. Above ~12 LU the delivery or the mic distance is wandering and every layer above will need to fight it. EBU R 128's measurement machinery is the reference here — momentary window **400 ms**, short-term **3 s**, absolute gate **−70 LUFS**, relative gate **−10 LU** — while the *target* for this library is **−14 LUFS** (social) or **−16 LUFS** (podcast), not R 128's broadcast **−23 LUFS at −1 dBTP**.
- **Then the qualitative reads, all of which have a named fix in this stack:**
  - **Boomy / too much chest** → energy piled in the 80–250 Hz Weight band, usually the proximity effect from working too close to a cardioid mic, which *"increase[s] bass or low frequency response when a sound source is close to a cardioid or similar directional microphone."*
  - **Muffled, like behind cardboard** → 250–600 Hz Mud.
  - **Sounds like a small room** → 400 Hz Boxiness, plus early reflections. Reflections are not an EQ problem.
  - **Hard to make out** → 2–5 kHz Presence is missing.
  - **Harsh and tiring** → 3.2 kHz.
  - **Sibilance** → 5–9 kHz Edge. **No de-esser exists in this stack** — see the failure modes.
- **The diagnosis rule that governs all of the above:** *"The absolute spectrum of a single unknown voice cannot be diagnosed."* Compare against something **inside the same file** — a clean passage, or the gaps — never against a remembered ideal.

## Parameters

| Parameter | Default (pass threshold) | Range | Notes |
|---|---|---|---|
| `noise_floor` | ≤ −60 dBFS | fail above −45 dBFS | RMS in ≥400 ms speech gaps. |
| `snr` | ≥ 45 dB | fail below 30 dB | Speech RMS − gap RMS. |
| `peak_headroom` | −9 dBFS | −12 to −6 dBFS | Before treatment. |
| `clipping` | 0 samples | 0 only | Any clipped load-bearing syllable is a re-record. |
| `lra_after_levelling` | 7 LU | 5–9 LU | Above ~12 LU, delivery or distance is wandering. |
| `integrated_target` | −14 LUFS | −16 to −14 LUFS | Set at the *end* of the whole mix, not here. |
| `true_peak` | −1.5 dBTP | −2 to −1 dBTP | R 128's ceiling is −1 dBTP. |
| `dialogue_fader` | 1.0 (0 dB) | 0.708–1.0 (−3 to 0 dB) | The source's own band. Everything else is relative to this. |
| `mic_distance` | 20 cm | 15–25 cm | Cardioid, 10–20° off-axis. Closer trades intelligibility for proximity-effect bass and plosives. |
| `highpass_rumble` | 80 Hz, 2 poles | 60–120 Hz | 12 dB/octave. First node in the chain — subtract before you add. |
| `preset` | `voice-clean` | `voice-clean` · `voice-broadcast` · `voice-warm` | *"the default answer to 'fix this voiceover'"*. |
| `carve_strength` | 0.25 | 0.20–0.35 | On the bed, against the `voiceover` group. A failing voice tempts you to raise this; do not. |

## Reproduction prompt

```
Run the layer-1 gate on the voice source(s) for this project. Do not place
any ambience, foley, SFX or music until it passes.

1. EXTRACT one mono 48 kHz WAV per voice source:
   ffmpeg -i <src> -vn -ac 1 -ar 48000 /tmp/vo-<n>.wav
2. MEASURE FOUR NUMBERS per source and record them:
   a) noise floor: silencedetect at -40dB / 0.4s to find gaps, then
      volumedetect on one gap -> mean_volume in dBFS
   b) SNR: volumedetect over the whole file (speech-dominated mean_volume)
      minus the gap mean_volume
   c) peaks / clipping: volumedetect -> max_volume, and check for a run of
      full-scale samples
   d) loudness: ffmpeg -af ebur128=framelog=verbose -> integrated LUFS, LRA
3. APPLY THE GATE.
   PASS  = floor <= -50 dBFS AND SNR >= 35 dB AND no clipping in a
           load-bearing line.
   FAIL  = anything else. STOP. Report the failing number and the branch:
           floor/SNR fail  -> better mic, closer, quieter room, or
                              regenerate the line (see Execution spec)
           clipping        -> re-record or regenerate; it cannot be repaired
           LRA > 12 LU     -> re-record with consistent distance, or accept
                              that levelling will be doing heavy lifting
   Do not proceed past a FAIL by compensating in the mix. Every layer above
   makes a failing voice worse.
4. ON PASS, CLEAN IT, subtract-before-add order:
   a) Put every voice clip in data-audio-group="voiceover".
   b) Apply the voice-clean preset on the voiceover BUS, not per clip -
      one chain, one clock, for every line.
   c) Add ONLY the corrective jobs the measurement asked for, and check
      what the preset already contains first: voice-clean plus a Reduce Mud
      job is -6 dB at 250 Hz where -3 was meant.
   d) Even Out Levels if LRA is above 9 LU. It targets the 80th percentile
      of this track's own speaking windows, so an already-even track is
      left alone.
   e) Limiter LAST, limit -1.
5. SET THE DIALOGUE FADER to 1.0 (0 dB) and leave it. Every other layer is
   expressed as a negative offset from here.
6. RE-MEASURE and confirm: no new clipping, LRA now 5-9 LU, floor unchanged
   or better.
7. ONLY NOW open layer 2.

ACCEPTANCE TEST: solo the voice and play 30 s at a comfortable level with
headphones. You must be able to (a) understand every word without leaning
in, (b) hear no hiss, hum or room in the gaps, (c) not notice the loudest
and quietest lines as different recordings. If any of the three fails, the
gate has not passed regardless of what the numbers said.
```

## Execution spec

**Hyperframes — layer 1 lives on a bus, and that is not optional.**

```html
<hf-audio-group id="voiceover" data-label="Dialogue" data-volume="1"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:80,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
    {&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Reduce Mud&quot;,&quot;params&quot;:{&quot;frequency&quot;:250,&quot;gain&quot;:-3,&quot;q&quot;:1.2}},
    {&quot;type&quot;:&quot;compressor&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;label&quot;:&quot;Even Out Loudness&quot;,&quot;params&quot;:{&quot;threshold&quot;:-18,&quot;ratio&quot;:3,&quot;attack&quot;:20,&quot;release&quot;:250}},
    {&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;n4&quot;,&quot;label&quot;:&quot;Add Clarity&quot;,&quot;params&quot;:{&quot;frequency&quot;:3000,&quot;gain&quot;:2.5,&quot;q&quot;:1}},
    {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n5&quot;,&quot;label&quot;:&quot;Peak Ceiling&quot;,&quot;params&quot;:{&quot;limit&quot;:-1,&quot;attack&quot;:5,&quot;release&quot;:50}}]}"></hf-audio-group>

<audio id="vo-01" src=".media/audio/voice/line-01.wav" data-audio-group="voiceover"
       data-start="0.5" data-track-index="10"></audio>
<audio id="vo-02" src=".media/audio/voice/line-02.wav" data-audio-group="voiceover"
       data-start="6.2" data-track-index="10"></audio>
```

That chain is `voice-clean` written out by hand: **Remove Rumble → Reduce Mud → Even Out Loudness → Add Clarity → Peak Ceiling**, described in the stack as *"the default answer to 'fix this voiceover'"*. Applying the preset itself writes the same nodes tagged `fromPreset`; re-applying replaces its own nodes in place. `voice-broadcast` adds Reduce Boxiness, Add Air and Warmth; `voice-warm` adds weight instead of cutting.

Contract points that decide the outcome:
- **The bus is the right home, per its own doctrine:** *"a compressor cannot ride a sequence it only hears a third of."* Per-clip chains are for genuinely per-clip problems — one line recorded in a different room.
- **Every `<audio>` needs an `id`.** An id-less `<audio>` *"is never mixed → silent render"*, with no error. On the dialogue layer that is a silent, shipped video.
- **Bus automation `t` is composition time**, because a bus has no `data-start`; clip lane `t` is clip-local. A single-member bus is the sanctioned trick for giving one clip composition-time automation.
- **`compressor`, `limiter` and `gate` have zero automatable parameters** — they are AudioWorklets configured wholesale. To ride compression, automate a `gain` stage around it.
- **Order is signal order and the limiter is last**, where it acts as a ceiling.
- **The double-application trap is real and easy:** *"`voice-clean` plus a Reduce Mud job is −6 dB at 250 Hz where −3 was meant."* Read the chain before adding a job.
- **Corrective job values are pre-chosen** — Tame Boominess 200 Hz/−4 dB/Q 1.4 · Reduce Mud 250 Hz/−3 dB/Q 1.2 · Reduce Boxiness 400 Hz/−3 dB/Q 1.4 · Add Clarity 3 kHz/+2.5 dB/Q 1 · Soften Harshness 3.2 kHz/−3 dB/Q 1.6. Carry the name in `label`.
- **Even Out Levels is measured, not fixed:** it *"measures the track's own speaking windows and writes a gain envelope targeting the 80th percentile of that track, not an absolute level, so an already-even track is left alone."* That is the right tool for a high LRA.
- **`room-gate` closes the gaps, it does not remove noise:** *"Does not remove noise — room tone under speech stays."* Gating a hissy source makes the gaps clean and the words still hissy, which sounds worse than leaving it alone.
- **Nothing validates the chain.** *"Nothing validates the chain or the effect lanes at all."* Render refuses an unparseable chain; preview plays it dry. So a chain that "works in preview" may be doing nothing.
- **Keep the `voiceover` group voices only.** A bed or an SFX clip inside it poisons the next carve re-analysis silently.
- **`data-volume` on the bus is one fader for every member**, default 1. Leave it at 1: dialogue is the reference the other four layers are measured against.

**ffmpeg — the gate itself, and the one repair worth baking.**
```bash
# the four measurements
ffmpeg -i vo.wav -af "silencedetect=noise=-40dB:d=0.4" -f null - 2>&1 | grep silence_
ffmpeg -ss <gap> -t 0.4 -i vo.wav -af volumedetect -f null - 2>&1 | grep _volume
ffmpeg -i vo.wav -af volumedetect -f null - 2>&1 | grep _volume
ffmpeg -i vo.wav -af ebur128=framelog=verbose -f null - 2>&1 | tail -12

# band survey against the stack's own band names, to turn a qualitative read into a number
for b in "20 80 Rumble" "80 250 Weight" "250 600 Mud" "600 2000 Middle" "2000 5000 Presence" "5000 10000 Edge" "10000 20000 Air"; do
  set -- $b; echo -n "$3 "
  ffmpeg -v error -i vo.wav -af "highpass=f=$1,lowpass=f=$2,volumedetect" -f null - 2>&1 | grep mean_volume
done

# two-pass loudness, at the END of the whole mix - not on the raw voice
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=<input_i>:measured_TP=<input_tp>:\
measured_LRA=<input_lra>:measured_thresh=<input_thresh>:offset=<target_offset>:linear=true mix.social.wav

# tighten dead air and remove fillers from the transcript, which is a layer-1 job
node <SKILL_DIR>/scripts/transcript-cut.mjs --input talk.mp4 --transcript talk.transcribe.json \
  --remove-fillers "um,uh" --cut-silence 0.8 --out talk.cut.mp4
```
`highpass`/`lowpass` take `frequency`, `poles`, `width_type` (`q|o|h|d`) and `mix`; 2 poles is 12 dB/octave, since an order-*n* all-pole filter rolls off at 6*n* dB/octave. Note `transcript-cut.mjs`'s own warning about `--copy`: stream copy cuts only on keyframes and *"can silently swallow the whole cut"* — it measures the drift and reports `copy_drift`, but *"drop --copy for frame-accurate cuts."*

**Epidemic Sound — the escape hatch when the gate fails, and the two things not to do.**

When the source is unsalvageable and a re-record is not available, this stack's sanctioned route is to **generate the line** rather than to repair it:
```
ListVoices { }                                    # or ListUserGeneratedVoices
GenerateVoiceover { ... }                         # returns a job
PollVoiceoverGenerationStatus { ... }
GetVoiceover { ... }
DownloadVoiceover { id: <uuid>, options: { fileType: WAV } }
```
Treat generated voice as a **new layer-1 source and run the gate on it too** — it will pass the floor and SNR tests trivially and can still fail the LRA test, and it must be normalised into the same band as the rest of the narration or the cut will be audible.

What Epidemic is **not** for at this stage: do not fetch a music bed or ambience to cover a bad voice. Ambience under a hissy voice adds a second noise source; music under an unintelligible voice makes it less intelligible. The gate exists precisely to stop that reflex.

**Remotion:** irrelevant to the gate — this is source qualification and file-level repair, identical in any engine.

## Pairs with
[[sfx-five-layers-build-order]] · [[sfx-layer-volume-targets]] · [[sfx-sound-pass-order]] · [[sfx-pause-removal-breath-and-room-tone]] · [[sfx-ambience-search-formula]] · [[sfx-instrument-filter-search]] · [[sfx-loud-guitar-minus-30]] · [[sfx-filter-character-and-distance]] · [[sfx-music-rest-windows]] · [[struct-stimulation-budget]] · [[sfx-split-edit-lead-lag]] · [[pace-partial-pause-removal]] · [[sub-emphasis-caption-three-words]] · [[sfx-music-audition-against-picture]]

## Failure modes
- **Building the sound design first.** The named mistake. Every added layer makes a failing voice worse, so the whole pass is wasted work. Fix: the gate runs before layer 2, always.
- **Raising the carve strength to rescue intelligibility.** Past 0.35 the bed *"starts being heard as an effect rather than as room for the voice"*, and the voice is still the problem. Fix: fix layer 1 or lower the bed.
- **Gating a hissy source.** `room-gate` cleans the gaps and leaves the hiss under the words, which draws attention to it by making it intermittent. Fix: nothing — see the next item.
- **Trying to remove noise.** There is **no noise removal in this stack**, and the doctrine is blunt: *"There is no fallback for hiss beneath the words — a source with audible hiss needs a better source, and saying so is the whole answer."*
- **Trying to de-ess.** There is **no de-esser**. `harsh-tame` is *"a broad always-on cut centred a band too low, not a de-esser."* Honest fallback: a narrow `peaking` cut, swept in the 5–9 kHz Edge band, Q 3–4, −3 to −5 dB, always on — which costs a little air on every word. State that cost rather than hiding it.
- **Trying to match one voice's tone to another's.** **No tone matching exists.** Fallback is the Tone EQ by hand, comparing both files against each other, never against a memory.
- **Treating clipping as an EQ problem.** The waveform is gone; nothing recovers it. Fix: re-record or regenerate.
- **Normalising the raw voice to −14 LUFS.** That is a *programme* target measured after all five layers. Normalising layer 1 to it leaves no headroom for anything above. Fix: fader at 0 dB here, `loudnorm` at the end.
- **Double-applying a corrective job.** `voice-clean` plus Reduce Mud is −6 dB at 250 Hz. Fix: read the chain first.
- **Per-clip chains for a whole-narration problem.** Different compression on every line means the levelling wanders audibly. Fix: put it on the `voiceover` bus.
- **Judging the voice soloed at high volume.** Everything sounds fine loud and alone. Fix: judge at the level the video will be watched at, with picture.
- **Known gap:** the pass/fail thresholds here (−60/−50/−45 dBFS floor; 45/35/30 dB SNR) are **derived, not quoted from a standard**. The reasoning is explicit: a floor that sits below the level at which the compression and −14 LUFS normalisation in the standard chain will surface it. EBU R 128 supplies the measurement machinery and the gates (400 ms momentary, 3 s short-term, −70 LUFS absolute, −10 LU relative, −1 dBTP ceiling) but no source-quality thresholds, and the SNR reference gives only the formula. Treat these as calibrated defaults and re-derive them if the delivery target changes.
- **Known gap:** the contract's `references/diagnosis.md`, which holds the diagnostic commands, is **not staged in this project**, so the ffmpeg recipes above are assembled from the filter documentation rather than quoted from the stack's own diagnosis guide.
