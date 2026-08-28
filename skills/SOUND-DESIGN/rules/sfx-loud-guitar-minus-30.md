---
id: sfx-loud-guitar-minus-30
title: Dense-guitar rock beds go to -30 dB, not -22
skill: sound-design
type: mix
family: mix-levels
tags: [skill/sound-design, type/mix, family/mix-levels, engine/hyperframes, engine/epidemic, layer/music, layer/dialogue, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:05:37"
    quote: "If it's rock music with loud guitars, I prefer to keep it down to around minus 30 decibels."
research_refs:
  - https://en.wikipedia.org/wiki/Crest_factor
  - https://en.wikipedia.org/wiki/Distortion_(music)
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Voice_frequency
difficulty: medium
detectable_from: audio
---

# Dense-guitar rock beds go to -30 dB, not -22

## What it is
A named exception to [[sfx-layer-volume-targets]]: a bed built on distorted electric guitars gets 5–8 dB more attenuation than the standing music level, landing around −30 dB relative to dialogue. The transcript states the number without a reason; research supplies one. Distortion is non-linear clipping that *"produces frequencies not originally present"* and yields *"a compressed sound"* — so a distorted guitar has both a **low crest factor** (more average power at the same peak, therefore louder for the same meter reading) and a **dense harmonic series sitting directly on top of the speech band**. Masking is strongest when masker and signal share frequency, and it spreads upward, so a wall of guitar mids buries consonants while the fader still reads "correct".

## When to use it
Apply whenever the chosen bed carries any of: distorted or overdriven electric guitar, a full band playing continuously, a heavily limited "loud" master, or a wall-of-sound texture with no gaps. Also apply the same −5 to −8 dB correction to any bed that is *spectrally* similar even if it is not rock: dense synth-wave pads, brass-heavy trailer music, busy lo-fi with saturated drums. Do **not** apply it to sparse beds — a piano or a filtered ambient loop at −30 dB simply disappears.

## How to recognise it in a reference video
- **Measure crest factor on the music-only passage.** `ffmpeg -i ref.wav -af astats=metadata=1:reset=10 -f null - 2>&1 | grep -E 'Peak level|RMS level'`. Peak minus RMS below ~10 dB means a compressed, dense bed that needs this correction; above ~14 dB means a dynamic bed that does not.
- On a spectrogram, a dense-guitar bed shows continuous energy through **600 Hz–5 kHz** with no holes — exactly the band the voice needs. A bed that leaves this band open is not a candidate.
- Listen for the symptom rather than the genre: if consonants (t, k, s, f) blur under the music but vowels stay clear, upper-mid masking is happening.
- In a reference that has done this right, the music-under-voice level sits visibly lower than that same creator's other sections — a bed level that changes by section is the tell.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Bed level, dense guitar | −30 dB → `data-volume="0.032"` | −32 to −27 dB (0.025–0.045) | vs. the standard −22 dB / 0.079. |
| Correction vs. standard bed | −8 dB | −5 to −10 dB | Derived from the transcript's −22 → −30 step. |
| Carve strength for this bed | 0.35 | 0.25–0.45 | Above the 0.25 default because the masker is denser. |
| Presence-band carve centre | 3 kHz | 2–5 kHz | Where consonant intelligibility lives; carve writes these automatically. |
| Low-shelf trim (optional) | 0 dB | −3 to 0 dB @ 200 Hz | Only if the bed also booms under the voice. |
| Crest-factor threshold | 10 dB | 8–14 dB | Below this, treat the bed as dense regardless of genre. |

## Reproduction prompt

```
The chosen music bed is a dense or distorted-guitar track. Apply the loud-bed
correction instead of the standard music level.

1. MEASURE FIRST. On the bed file, run:
   ffmpeg -i {{BED}} -af astats=metadata=1:reset=10 -f null -
   Record Peak level and RMS level. If (Peak - RMS) < 10 dB, this rule applies.
   If it is above 14 dB, STOP and use the standard -22 dB bed level instead.
2. SET THE LEVEL. On the bed's <audio> element set data-volume="0.032"
   (= -30 dB). Do not write "-30" into the attribute; data-volume is linear.
3. CARVE HARDER. Set
   data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.35}"
   on the bed only, then run:
   node <SKILL_DIR>/scripts/carve.mjs --comp index.html
4. IF STILL MASKED, do not lower the voice. Add one peaking node to the bed's
   data-fx-chain before the carve nodes: frequency 3000, gain -3, q 1.4,
   label "Make Room For Voice".
5. RE-CHECK the section against the acceptance test below after every change.

ACCEPTANCE TEST: play the busiest 15 seconds of the section at a comfortable
level with the picture. Every consonant is intelligible without leaning in, and
the bed is still clearly present between phrases. If the bed sounds notched or
hollow rather than simply quieter, the carve strength is too high - step it back
to 0.25 and take the extra 2 dB off the fader instead.
```

## Execution spec

**HyperFrames.** Level and carve on the bed clip:
```html
<audio id="music-bed-rock" src="assets/audio/bgm/rock-bed.wav"
       data-audio-group="music" data-start="{{IN}}" data-duration="{{OUT-IN}}"
       data-track-index="11" data-volume="0.032"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.35}"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Make Room For Voice&quot;,&quot;params&quot;:{&quot;frequency&quot;:3000,&quot;gain&quot;:-3,&quot;q&quot;:1.4}}]}"></audio>
```
Write these JSON attributes **double-quoted with `&quot;`** — `carve.mjs` finds them with a `name="..."` regex and a single-quoted attribute is invisible to it, so the carve silently overwrites work it could not see. `data-fx-carve` is clip-only; putting it on an `<hf-audio-group>` raises `audio_group_carve_attr`. Carve-written nodes are tagged `fromCarve`; never set that flag by hand.

**Epidemic Sound.** Screen for this at search time rather than fixing it at mix time. Use `SearchRecordings` with `filter.featuredInstrumentSlugs: {matchType: "NOT_ANY", values: ["electric-guitar", "distorted-guitar"]}` when the section has narration over it, or `matchType: "ANY"` with the same slugs when you deliberately want the rock bed and will pay the 8 dB. `filter.taxonomySlugs` carries the genre dimension (`rock`, `alternative-rock`) — verified live: a `featuredInstrumentSlugs: ["electric-guitar"]` + `bpm 100–140` query returns alternative-rock results with `genre: alternative rock` tags. Prefer results that expose an `INSTRUMENTS` or `MELODY` stem: pulling the stem set lets you drop the guitar layer entirely under narration rather than attenuating the whole bed.

**ffmpeg.** Crest-factor probe as in the prompt. If you need to bake the correction for an asset leaving the pipeline: `ffmpeg -i bed.wav -af "volume=-8dB" bed.quiet.wav`.

**Remotion.** `<Audio volume={0.032} />`; the spectral carve has no Remotion equivalent and would have to be baked into the file with ffmpeg first.

## Pairs with
[[sfx-layer-volume-targets]] · [[sfx-bpm-filter-first]] · [[sfx-music-hard-stop]] · [[sfx-sound-pass-order]]

## Failure modes
- **Applying it by genre label instead of by measurement.** An acoustic "rock" track with a 16 dB crest factor vanishes at −30 dB. Measure, then decide.
- **Compensating by raising the voice.** This pushes dialogue toward the true-peak ceiling and makes the whole mix harsh. The bed moves, the voice does not.
- **Cranking carve strength instead of lowering the fader.** Past ~0.5 the carve becomes audible as a hole punched in the music. Fader first, carve second.
- **Forgetting that the correction is section-local.** If only one section uses the rock bed, only that bed gets −30; re-using the value on the next, sparser track buries it.
- **Known gap:** there is no de-esser and no automatic tone matching in this stack, so if the guitar bed is also harsh you are limited to a narrow `peaking` cut swept between 5–9 kHz at Q 3–4, −3 to −5 dB, always on.
