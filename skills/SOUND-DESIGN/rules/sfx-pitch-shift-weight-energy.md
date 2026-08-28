---
id: sfx-pitch-shift-weight-energy
title: Pitch down for heavy and cinematic, pitch up for light and energetic
skill: sound-design
type: mix
family: sfx-treatment
tags: [skill/sound-design, type/mix, family/sfx-treatment, engine/ffmpeg, engine/hyperframes, engine/epidemic, sfx/aesthetic, layer/sfx, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:08:18
    quote: "To give a heavy, cinematic, subtle feel, you lower the pitch. For a light, fast or energetic feel, use a higher pitch."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:01:15
    quote: "If you raise the pitch, the sound effect feels a bit lighter. But if you lower the pitch, it becomes a really heavy, weighty whoosh."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:10:04
    quote: "Change all of these and you can make a unique number of variations out of one single sound effect."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:08:06
    quote: "First we'll put a change on it - our pitch shifter."
research_refs:
  - https://en.wikipedia.org/wiki/Pitch_shift
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://breakfastquay.com/rubberband/
  - https://en.wikipedia.org/wiki/Sub-bass
difficulty: medium
detectable_from: audio
---

# Pitch down for heavy and cinematic, pitch up for light and energetic

## What it is
Pitch is a mixing tool, not a repair tool. Lowering a sound effect's pitch makes it read as **heavy, cinematic and subtle**; raising it makes the same file read as **light, fast and energetic**. Because the perceived size of a sound is largely a function of where its energy sits, one library file becomes several usable effects — and pitch is one of the three named levers (with reverb and duration) that turn a single asset into a set of variations, which is also the cure for the "same sound effect again and again" mistake.

Two mechanisms exist and they are not interchangeable. **Speed-based shifting** resamples: pitch and duration move together, exactly like slowing a tape. **Time-domain shifting** (a phase vocoder such as Rubber Band) changes pitch independently of tempo and can preserve formants. For sound effects the speed-based method is usually the right one — it preserves transient shape, and a bigger thing genuinely is both lower *and* slower, so the result sounds physical. Formant preservation exists to protect vocal timbre; a whoosh has no formants to protect.

## When to use it
- **When the right family is right but the weight is wrong.** The whoosh is correct, it just feels too light for a heavy push. Pitch it down rather than searching for a different whoosh.
- **To build a rotation.** Three or four uses of the same whoosh in a run is a named failure. ±2 semitones plus ±15% length turns one file into a set that no viewer will identify as one sound.
- **To match a sound to the size of what is on screen.** A full-frame push wants a lower whoosh than a text card sliding in. Pitch is how you scale one asset across both.
- **To place the effect in the mix's spectrum.** If the effect is fighting the voice around 2–3 kHz, pitching down moves its energy out of the way — often a better fix than turning it down.
- **On a DIY or mouth-recorded effect** whose raw pitch is simply wrong. The source's own recipe is exactly this: Pitch Shifter on a mouth-recorded whoosh, raise it, then settle it lower, then low-pass.
- **Not on anything with a recognisable identity** — a phone ringtone, a car, a voice, a piece of music. Shifting those makes them sound broken rather than heavier.
- **Not as a substitute for the sub layer.** Pitching an impact down does not give you sub weight; it gives you a smaller, duller impact. Layer a bass drop instead.

## How to recognise it in a reference video
- **Compare two instances of the same effect.** Extract each occurrence of a recurring effect and cross-correlate their spectra. If the spectral shapes are identical but **frequency-scaled** — every peak multiplied by the same ratio — the file has been pitch-shifted, not replaced.
- **Check whether length scaled with pitch.** If a lower version is also proportionally *longer* by the inverse ratio (a −4 semitone version being 1.26× longer), it was a speed-based shift. If it is lower and the **same length**, a phase vocoder was used, and on a transient-heavy sound you will usually also hear a slightly smeared attack.
- **Estimate the ratio.** Pick a clear spectral feature in both versions and take the frequency ratio. Convert: `semitones = 12 * log2(f2/f1)`. Typical, meaningful values in edited video sit at **−2 to −7** and **+2 to +5** semitones; anything past ±7 is a deliberate character change, not a weight adjustment.
- **Watch the pairing.** In a reference with real craft, lower-pitched effects sit on bigger, slower, heavier picture events and higher-pitched ones on small, fast, light events. If pitch and picture size are uncorrelated, the effects were dropped in unmodified.
- **Listen for the artefact signature.** Aggressive downward shifts (past about −7 semitones) turn crisp transients into a dull thud and can expose the source's noise floor as a low rumble; aggressive upward shifts (past +7) produce the toy/"chipmunk" quality. Both are audible on a whoosh as an obviously processed sound rather than a heavier one.
- **Transcript signal:** none.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `shift_heavy` | −3 semitones (ratio 0.8409) | −2 to −7 st (0.8909 → 0.6674) | "Heavy, cinematic, subtle". Past −7 the sound loses its identity and its transient. |
| `shift_light` | +3 semitones (ratio 1.1892) | +2 to +5 st (1.1225 → 1.3348) | "Light, fast, energetic". Past +7 it reads as a toy. |
| `method` | speed-based (resample) | speed-based · phase-vocoder | Speed-based preserves transients and couples length to pitch, which is usually what you want for SFX. |
| `formant_preserve` | off | on/off | Only relevant to voices. A whoosh, impact or riser has no formants to preserve; turning it on costs quality for nothing. |
| `length_coupling` | accepted | accepted · corrected | With speed-based shifting, length scales by `1/ratio`. A −4 st shift makes the file 1.26× longer. Either accept it (and re-check the duration ratio against the motion) or correct with `atempo`. |
| `atempo_correction` | `1/ratio` | 0.5–2.0 per instance | ffmpeg's `atempo` is valid only in 0.5–2.0; chain instances for larger corrections. |
| `rotation_pitch_step` | ±2 semitones | ±1 to ±3 st | Enough for two uses of one file to read as two sounds. |
| `rotation_length_step` | ±15% | ±10 to ±25% | The second lever. Combined with pitch, four variants from one file. |
| `pitch_vs_filter` | pitch first, filter second | — | Pitching moves harmonics; low-passing removes them. They sound different — do not substitute one for the other. |
| `noise_check` | required below −5 st | — | Downward shifts drag the source's noise floor into the audible low end. Check the file's floor before a big shift. |

**Semitone → ratio table** (ratio = 2^(n/12)); use these as the multiplier in `asetrate`.

| Semitones | −7 | −6 | −5 | −4 | −3 | −2 | −1 | +1 | +2 | +3 | +4 | +5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Ratio | 0.6674 | 0.7071 | 0.7492 | 0.7937 | 0.8409 | 0.8909 | 0.9439 | 1.0595 | 1.1225 | 1.1892 | 1.2599 | 1.3348 |
| Length × | 1.498 | 1.414 | 1.335 | 1.260 | 1.189 | 1.122 | 1.059 | 0.944 | 0.891 | 0.841 | 0.794 | 0.749 |

## Reproduction prompt

```
Pitch-shift {{SFX_FILE}} to change its weight for the event at {{EVENT}}.

1. DECIDE THE DIRECTION FROM THE PICTURE, not from taste. Big, slow, heavy,
   full-frame, or serious -> shift DOWN. Small, fast, light, playful, or a
   single UI element -> shift UP.
2. PICK THE AMOUNT: start at -3 semitones (ratio 0.8409) for heavy or +3
   semitones (ratio 1.1892) for light. Only leave the -7..+5 band if you
   intend a character change rather than a weight change.
3. CHECK THE SOURCE FLOOR FIRST if shifting down more than 5 semitones:
   ffmpeg -i {{SFX_FILE}} -af "highpass=f=20,lowpass=f=120,astats=metadata=1" -f null -
   A noisy file becomes a rumbly file when pitched down.
4. SHIFT WITH RESAMPLING, not a phase vocoder, unless the duration must not
   change. Accept that length scales by 1/ratio.
   ffmpeg -i {{SFX_FILE}} -af "asetrate=48000*0.8409,aresample=48000" out.wav
5. RE-CHECK THE DURATION RATIO against the motion. The shift just made the
   file 1.19x longer. If sfx_duration / motion_duration now exceeds 1.25,
   correct it:
   ffmpeg -i {{SFX_FILE}} -af "asetrate=48000*0.8409,aresample=48000,atempo=1.189" out.wav
   atempo is valid only in 0.5-2.0; chain two instances for larger factors.
6. RE-FIND THE PEAK. The shift moved the file's internal peak offset by the
   same factor. Re-measure it before placing, or the effect lands late.
7. IF THIS IS A ROTATION VARIANT: apply +/-2 semitones AND +/-15% length, not
   pitch alone. Log the variant so the same one is not reused within 3 uses.

ACCEPTANCE TEST: A/B the original and the shifted version against the same
picture at the same level. The shifted one must feel heavier or lighter -
not just duller or thinner. If it only sounds duller, you wanted a low-pass
filter, not a pitch shift, and you should undo this. Then confirm the
transient is still sharp: if the attack has smeared, you used a phase
vocoder where you wanted resampling.
```

## Execution spec

**There is no pitch attribute in HyperFrames, and the attribute that looks like one is the wrong tool.** `data-playback-rate` accepts 0.1–5 and is **pitch-preserved** — it changes speed while holding pitch, which is the exact opposite of this note's intent. There is also no rate envelope, so pitch cannot be ramped. Pitch shifting is therefore a **baked, pre-placement operation**.

```bash
# heavy: -3 semitones, length allowed to grow 1.19x (usually fine, and often desirable)
ffmpeg -i whoosh.wav -af "asetrate=48000*0.8409,aresample=48000" whoosh.-3.wav

# heavy, length preserved
ffmpeg -i whoosh.wav -af "asetrate=48000*0.8409,aresample=48000,atempo=1.189" whoosh.-3.fix.wav

# light: +3 semitones, length preserved
ffmpeg -i whoosh.wav -af "asetrate=48000*1.1892,aresample=48000,atempo=0.841" whoosh.+3.fix.wav

# pitch independent of tempo, when duration is locked and transients are not critical
ffmpeg -i pad.wav -af "rubberband=pitch=0.8409" pad.-3.wav

# a full rotation set from one file, in one pass
for r in 0.8909 0.9439 1.0595 1.1225; do
  ffmpeg -y -i whoosh.wav -af "asetrate=48000*$r,aresample=48000" "whoosh.$r.wav"
done
```
Notes that matter: `asetrate` must be followed by `aresample` back to the project rate or downstream filters see the wrong rate; `atempo` is valid only in **0.5–2.0**, so chain instances for bigger corrections; and the `rubberband` filter is an optional ffmpeg build dependency — treat its availability as unverified in this environment and fall back to resampling. Keep all of this **outside the mounted vault**, which cannot delete files, and register the result afterwards (`resolve.mjs --from <file> --type sfx`) if you want it in the ledger.

**What you can do in the composition instead.** Pitch is not available, but the two *perceptual* neighbours of pitch are:
```html
<!-- heavier and duller: not the same as lower, but often close enough -->
data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
  {&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Weight&quot;,&quot;params&quot;:{&quot;frequency&quot;:2200,&quot;poles&quot;:&quot;2&quot;}},
  {&quot;type&quot;:&quot;lowshelf&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Add Weight&quot;,&quot;params&quot;:{&quot;frequency&quot;:180,&quot;gain&quot;:3}},
  {&quot;type&quot;:&quot;saturate&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;params&quot;:{&quot;type&quot;:&quot;tanh&quot;,&quot;threshold&quot;:-6,&quot;output&quot;:0}}]}"

<!-- lighter and faster: sharpen rather than raise -->
data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
  {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Lighten&quot;,&quot;params&quot;:{&quot;frequency&quot;:400,&quot;poles&quot;:&quot;2&quot;}},
  {&quot;type&quot;:&quot;highshelf&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Add Air&quot;,&quot;params&quot;:{&quot;frequency&quot;:6000,&quot;gain&quot;:3}}]}"
```
Be honest about the difference: **filtering removes harmonics, pitching moves them.** A low-passed whoosh is a duller whoosh of the same size; a pitched-down whoosh is a bigger object. Use the chain when a bake is impractical, and bake when the weight actually matters. Also note `saturate`'s `type`, `threshold` and `oversample` rebuild a waveshaper curve and are **not automatable** — only `output` is.

**In an NLE, for portability.** The source names the tool it uses in Premiere Pro verbatim — the **Pitch Shifter** effect — and its own recipe raises the pitch of a mouth-recorded whoosh first, then settles it lower, then low-passes. DaVinci Resolve's equivalents are the Fairlight clip pitch controls and the Pitch effect. Neither is part of this stack; they are recorded here because the source's numbers came from one of them.

**Epidemic Sound — pitch after fetching, not instead of fetching.** Search first with the duration filter *for the length you will end up with*: a −3 semitone shift makes the file 1.19× longer, so if the motion is 500 ms, fetch in the 340–520 ms band, not the 400–625 ms band. And use similarity search before reaching for pitch — a genuinely different file is always better than a processed one:
```
SearchSoundEffects { query:{term:"whoosh heavy low"}, filter:{duration:{min:340,max:520}} }
SearchSimilarToSoundEffect { id:<chosen>, first: 12 }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
WAV always: pitch-shifting an mp3 drags its encoding artefacts down into the audible band along with everything else.

**Remotion:** no pitch control on `<Audio>`; the same bake-first approach applies. Concept only.

## Pairs with
[[sfx-whoosh-transition-movement-reveal]] · [[sfx-bass-drop-under-impact]] · [[sfx-arbitrary-sound-motion-sync]] · [[sfx-synthetic-family-catalogue]] · [[sfx-whoosh-short-vs-long]] · [[sfx-density-fatigue-audit]] · [[sfx-five-layers-build-order]] · [[sfx-cartoon-comedy-family]] · [[motion-emphasis-scale-step]] · [[sfx-name-before-search]] · [[sfx-layer-volume-targets]]

## Failure modes
- **Reaching for `data-playback-rate`.** It is pitch-*preserved*, so it changes the speed and not the weight — the opposite of the intent, and it will quietly desync the effect from the motion as well. Fix: bake the shift with ffmpeg.
- **Confusing pitch with filtering.** Low-passing gives you a duller sound of the same size. Fix: if the goal is "bigger", shift; if the goal is "less bright", filter.
- **Forgetting the length changed.** A speed-based shift scales duration by `1/ratio`, which silently breaks the duration ratio against the motion and moves the file's internal peak. Fix: re-measure the peak and re-check the ratio after every shift.
- **Shifting past ±7 semitones for a weight adjustment.** You get a different sound, not a heavier one, plus smeared transients going down and a toy quality going up. Fix: stay in −7..+5; if you need more, find another file.
- **Pitching down a noisy source.** The noise floor comes down with everything else and becomes an audible rumble under the effect. Fix: check the floor first; a hissy source is not fixable in this stack — there is no noise removal, and saying so is the whole answer.
- **Using a phase vocoder on a transient.** Smears the attack, which is the one part of an impact that has to be sharp. Fix: resampling for anything percussive; reserve the vocoder for pads and drones with a locked duration.
- **Pitching instead of layering for weight.** A pitched-down impact is a smaller, duller impact; it does not contain sub energy that was never there. Fix: layer a bass drop.
- **Turning on formant preservation for SFX.** Costs quality and processing for a property the sound does not have. Fix: off, unless the material is a voice.
- **Known gap:** the semitone bands (−2..−7, +2..+5) are practitioner conventions with the ratio arithmetic behind them; no cited study fixes where "heavier" becomes "broken". The mechanism claims — speed-based shifting couples pitch to duration, phase vocoders decouple them and can preserve formants — are documented, and the ratio table is exact.
- **Known gap:** `rubberband` availability in the local ffmpeg build is unverified, and ffmpeg itself is only *assumed* present in this project. Any spec depending on a bake should state a fallback to the in-chain filter approach.
