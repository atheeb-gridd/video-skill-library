---
id: sfx-repetition-variant-rotation
title: Mistake three — the same sound effect again and again, and the rotation that fixes it
skill: sound-design
type: sfx
family: variation
tags: [skill/sound-design, type/sfx, family/variation, layer/sfx, engine/epidemic, engine/ffmpeg, engine/hyperframes, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:09:51"
    quote: "Then mistake number three is the same sound effect repeated again and again and again."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:10:21"
    quote: "It looks professional and people don't get irritated either."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:10:04"
    quote: "[the three parameters that turn one sound file into many variations] Reverb. Pitch change. Duration change."
research_refs:
  - https://en.wikipedia.org/wiki/Habituation
  - https://en.wikipedia.org/wiki/Just-noticeable_difference
  - https://ffmpeg.org/ffmpeg-filters.html#astats-1
  - local verification 2026-08-28 — normalised cross-correlation between a file and itself = 1.000; the same file at −2 dB = 1.000 (level-invariant); the same file pitched +2 semitones = 0.126; an unrelated file = 0.059
difficulty: medium
detectable_from: audio
---

# Mistake three — the same sound effect again and again, and the rotation that fixes it

## What it is
The third of the source's named sound-design mistakes: one identical file used for every instance of a recurring event — every text entrance, every transition, every footstep, every list item. It is not a taste problem, it is a **perception** problem. Habituation is faster the shorter the interval between repeats, and it is **stimulus-specific**: the response decays to *this* sound and recovers for a different one. So an identical whoosh on twelve consecutive entrances stops being heard by roughly the fifth, and by the eighth the viewer is noticing the *repetition* rather than the video — which is the irritation the source names. Meanwhile a *varied* whoosh keeps doing its job, because each instance is a slightly novel stimulus.

The fix has two levels and the second is what separates professional from adequate. **Level one: multiple files.** Three or more distinct assets in the same texture family, rotated round-robin so the same file never lands twice in a row. This is the reason the source prefers a real library over ripped clips — the library is what makes rotation possible at all. **Level two: parameterised variation.** The source's own three knobs — **reverb, pitch, duration** — plus level and micro-timing, applied per instance so that even two uses of the same file are not the same event. The tolerances are set by human discrimination limits: loudness JND is about **1 dB**, pitch discrimination is about **10 cents (0.6 %)** above 1 kHz, and pitch differences beyond about **3 semitones** are heard as a genuinely different sound. Variation therefore wants to sit **above 1 dB and above ~50 cents** (so it is heard as variation) and **below 3 semitones** (so it is still the same object).

A stack-specific constraint shapes how this is implemented: HyperFrames bans render-time randomness — no unseeded `Math.random()`, no clocks — so **variation must be authored, not generated at render time**. Rotation is an index-derived decision made when the note's pass runs, and pitch variants are baked files, because `data-playback-rate` is pitch-preserved and cannot supply a pitch shift.

**Style.** No `sfx/` style tag: habituation is stimulus-specific and indifferent to style, so the rotation rule applies equally to a repeated footstep, a repeated entrance whoosh and a repeated riser — and [[sfx-variation-set-generator]] bakes variants for all three.

## When to use it
- **Whenever an event recurs three or more times** in a video: entrances, transitions, list-item reveals, footsteps, key clicks, notification pops, page turns.
- **During the sound pass, at fetch time** — building the rotation set costs one extra `SearchSimilarToSoundEffect` call and is nearly free then, and expensive later.
- **On any recurring foley action** ([[sfx-foley-three-element-checklist]]), where identical repeats are the most audible of all because real footsteps and real handling never repeat exactly.
- **Especially on the highlight and cartoon families**, whose bright, salient sounds habituate fastest ([[sfx-highlight-sound-on-emphasis]], [[sfx-cartoon-comedy-family]]).
- **Not** on a *motif*. A sound that recurs deliberately to mean something — a channel's signature transition, a stinger that marks each new chapter — is supposed to be identical, and varying it destroys the meaning. The test is whether the viewer is meant to *recognise* it. If yes, keep it identical, and control fatigue with spacing instead ([[sfx-density-fatigue-audit]]).
- **Not** as a licence to add more sounds. Rotation reduces fatigue per sound; it does not raise the density ceiling.

## How to recognise it in a reference video
- **Extract every instance of a recurring family and cross-correlate them pairwise.** Verified behaviour of the measure (2026-08-28): normalised cross-correlation is **1.000** for the same audio, still **1.000** when one copy is level-scaled by −2 dB, **0.126** for the same source pitched up 2 semitones, and **0.059** for unrelated audio.
  ```bash
  ffmpeg -v error -ss <t1> -t 0.5 -i ref.wav -f f32le -ac 1 -ar 48000 a.f32
  ffmpeg -v error -ss <t2> -t 0.5 -i ref.wav -f f32le -ac 1 -ar 48000 b.f32
  python3 -c "
  import numpy as np
  a=np.fromfile('a.f32',dtype=np.float32); b=np.fromfile('b.f32',dtype=np.float32)
  n=min(len(a),len(b)); a=a[:n]-a[:n].mean(); b=b[:n]-b[:n].mean()
  print(round(float(np.correlate(a,b,'full').max()/(np.linalg.norm(a)*np.linalg.norm(b))),3))"
  ```
  Read it this way: **≥ 0.95 = literally the same audio** (level variation does not lower it), which is the mistake. **< 0.95 tells you they are not identical but does not tell you they are different sounds** — a pitch-shifted copy scores about as low as an unrelated file. So use correlation as an *identical-reuse detector*, and compare **spectral envelopes** (`aspectralstats` centroid/rolloff/flatness across the file) to tell a varied copy from a genuinely different asset: a pitch variant keeps the same envelope *shape* translated in frequency.
- **Compute the variety ratio**: distinct sounds ÷ sounded events, per family. Healthy work sits **above 0.3** for high-count families — meaning roughly one distinct asset per three uses, with the rest of the difference supplied by pitch, level and reverb rather than by forty different files.
- **Check the gap distribution.** Identical repeats matter most when close together. Log the minimum interval between two identical instances; **under 8 seconds** is where the repetition becomes conspicuous.
- **Listen for the "sample pack" tell** — every effect in the video sharing one reverb tail and one brightness. That is a single-source library used unvaried, and it reads as cheap even when each individual sound is good.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `variants_per_family` | 3 | 3–8 | 3 for families used up to ~8 times; 5+ beyond that. Distinct **files**, from similarity search. |
| `no_repeat_window` | 3 uses | 2–5 | The same file may not recur inside this many consecutive uses of its family. |
| `min_identical_gap` | 8 s | 5–15 s | If a file must recur sooner, vary its parameters instead of just rotating. |
| `pitch_jitter` | ±100 cents | ±50–300 cents | Above JND (~10 cents), below the 3-semitone identity limit. Bake it; `data-playback-rate` cannot do it. |
| `level_jitter` | ±1.5 dB | ±1–3 dB | Loudness JND is ~1 dB, so ±1.5 dB is heard as variation, not as a mixing error. |
| `duration_jitter` | ±8 % | ±5–15 % | The source's third knob. Do it with `atempo`, or by trimming the tail with `data-duration`. |
| `reverb_jitter` | wet ±0.04 | 0.08–0.22 wet | The source's first knob. Two rooms is enough; more sounds inconsistent. |
| `timing_jitter` | ±1 frame | 0–2 frames | Only where sync allows. Never on an impact or a cut-aligned transient. |
| `variety_ratio_floor` | 0.3 | 0.25–0.5 | Distinct assets ÷ uses, per family. |
| `motif_exemption` | identical | — | Signature sounds stay identical; control them by spacing, not variation. |

## Reproduction prompt

```
De-duplicate the recurring sound effects in {{COMP}}.

1. BUILD THE USE TABLE. For every SFX clip in the composition, record:
   family, src file, data-start, data-volume. Group by family and sort by time.
2. FLAG THE OFFENDERS. Within each family, flag any file used
   (a) twice inside 3 consecutive uses, or (b) twice within 8 seconds, or
   (c) for more than 40% of that family's uses.
   If a family has exactly one file and 3+ uses, the whole family is flagged.
3. DECIDE MOTIF OR NOT. If the viewer is meant to RECOGNISE this sound (channel
   signature, chapter stinger), it stays identical - skip it and instead check
   its spacing is at least 20 s. Otherwise continue.
4. BUILD THE ROTATION SET, 3 files minimum:
   SearchSimilarToSoundEffect { id:<the file you already have>, first:12 }
   Choose 2-3 whose durations are within 25% of the original and whose titles
   share the family descriptors. Download WAV. Measure each one's peak_offset.
5. BAKE PARAMETER VARIANTS for any file that must still repeat:
   pitch -100 cents: ffmpeg -i s.wav -af "rubberband=pitch=0.9439" s_dn100.wav
   pitch +100 cents: ffmpeg -i s.wav -af "rubberband=pitch=1.0595" s_up100.wav
   duration -8%:     ffmpeg -i s.wav -af "atempo=1.087" s_short.wav
   Re-measure peak_offset on every baked file - processing moves the peak.
6. ASSIGN DETERMINISTICALLY. Walk the family's uses in time order and assign
   variant[i % N]. Do NOT randomise: this stack bans render-time randomness, and
   a deterministic assignment is reproducible across renders and reviewable.
7. JITTER PER INSTANCE, also deterministically by index:
   data-volume: base * [1.0, 0.85, 1.15, 0.92][i % 4]      (about +/-1.5 dB)
   data-duration: trim the tail by 0-8% on alternating uses.
8. VERIFY: re-run the cross-correlation check on any two instances of the same
   family that are within 8 s of each other. A result >= 0.95 means they are
   still the same audio and step 6 did not take effect.

ACCEPTANCE TEST: play the section at 1.5x speed with your eyes closed and count
how many times you notice "that sound again". Zero is the target. One is
acceptable. Two or more means the rotation set is too small - add a file, do not
add more jitter.
```

## Execution spec

**Epidemic Sound — similarity search is the rotation tool.** This is its highest-value use in the whole library: once one asset is right, `SearchSimilarToSoundEffect` returns the neighbours that keep the palette coherent while breaking the repetition.
```
SearchSimilarToSoundEffect { id:<the asset that worked>, first:12 }
# then filter the shortlist yourself on durationInMilliseconds within +/-25%
# of the original, and on shared title descriptors (Short / Dry / Designed / ...)

# family-level alternative when similarity returns too little:
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL,values:["<the family slug>"]},
                              duration:{min:<0.75*d>,max:<1.25*d>} },
                     sort:{by:POPULARITY,order:DESCENDING}, first:24 }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Store the rotation set as a **group** in the asset manifest — family, N files, each with duration, peak offset and the query that found it — so the next project inherits it ([[sfx-library-build-and-taxonomy]]).

**ffmpeg — the three knobs, baked.** `rubberband` is present in this build (verified 2026-08-28) and is the right tool because it preserves length while changing pitch; `asetrate` is the fallback and changes both.
```bash
# pitch: cents -> ratio = 2^(cents/1200);  -100c = 0.9439, +100c = 1.0595
ffmpeg -i whoosh.wav -af "rubberband=pitch=1.0595" whoosh_up100.wav
# fallback without rubberband (changes length too, then correct it)
ffmpeg -i whoosh.wav -af "asetrate=48000*1.0595,aresample=48000,atempo=0.9438" whoosh_up100.wav
# duration: -8%
ffmpeg -i whoosh.wav -af "atempo=1.087" whoosh_short.wav       # atempo valid 0.5-2.0
# room: two subtly different tails for the same family
ffmpeg -i whoosh.wav -af "aecho=0.9:0.35:28:0.16" whoosh_roomA.wav
ffmpeg -i whoosh.wav -af "aecho=0.9:0.35:46:0.12" whoosh_roomB.wav
```
**Re-measure `peak_offset` on every derived file** — a pitch or tempo change rescales the timebase and a stale offset puts the sound out of sync ([[sfx-peak-offset-measurement]]).

**HyperFrames — deterministic rotation, and why it has to be.** The determinism bans are explicit: no unseeded `Math.random()`, no render-time clocks, index-derived pseudo-randomness and baked schedules only. So the rotation is written into the markup, not computed at render:
```html
<!-- list items at 4.0 / 5.2 / 6.4 / 7.6 s: three files rotated, level jittered by index -->
<audio id="sfx-item-1" src="assets/sfx/motion/swish_a.wav" data-audio-group="sfx"
       data-start="3.940" data-duration="0.28" data-track-index="12" data-volume="0.178"></audio>
<audio id="sfx-item-2" src="assets/sfx/motion/swish_b.wav" data-audio-group="sfx"
       data-start="5.146" data-duration="0.26" data-track-index="13" data-volume="0.151"></audio>
<audio id="sfx-item-3" src="assets/sfx/motion/swish_c.wav" data-audio-group="sfx"
       data-start="6.352" data-duration="0.30" data-track-index="12" data-volume="0.205"></audio>
<audio id="sfx-item-4" src="assets/sfx/motion/swish_a_up100.wav" data-audio-group="sfx"
       data-start="7.548" data-duration="0.28" data-track-index="13" data-volume="0.164"></audio>
```
Note what is *not* available: `data-playback-rate` is **pitch-preserved** and clamped 0.1–5, so it varies length without varying pitch — useful as the duration knob, useless as the pitch knob. There is **no rate envelope**. `data-volume` above 1 boosts to a maximum of 3.98 (+12 dB). Two overlapping clips on one track index raise `duplicate_audio_track`, hence the 12/13 alternation. Per-clip reverb is legitimate here — this is a genuinely per-clip difference — but if all four want the *same* room, put it on the `sfx` bus and vary only pitch and level.

**Remotion:** the same index-derived assignment (`variants[i % N]`) inside a mapped `<Sequence>`. Concept only; Remotion is not part of this stack.

## Pairs with
[[sfx-density-fatigue-audit]] · [[sfx-library-build-and-taxonomy]] · [[sfx-motion-pass-two-rules]] · [[sfx-foley-three-element-checklist]] · [[sfx-highlight-sound-on-emphasis]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-reverb-glue]] · [[sfx-peak-offset-measurement]] · [[sfx-cartoon-comedy-family]] · [[sfx-source-licensing-and-clearance]] · [[sfx-ab-audition-candidates]] · [[sfx-swoosh-vs-whoosh]] · [[struct-stimulation-budget]] · [[motion-entrance-vocabulary]]

## Failure modes
- **One file, twelve uses.** The named mistake. Fix: three files minimum, rotated by index.
- **Varying only the level.** Cross-correlation is level-invariant and so, largely, is the ear's sense of sameness — a quieter identical whoosh is still the same whoosh. Fix: pitch and duration carry the variation; level is a garnish.
- **Varying too much.** Beyond ~3 semitones the sound changes identity and the family stops reading as one family. Fix: stay inside ±300 cents, default ±100.
- **Randomising at render time.** Banned by the determinism rules and unreviewable besides — two renders would differ. Fix: index-derived assignment written into the markup.
- **Using `data-playback-rate` as the pitch knob.** It is pitch-preserved; you get a length change and no timbral variation. Fix: bake with `rubberband`.
- **Forgetting to re-measure after baking.** Every derived variant has a new peak offset; reusing the original's puts the variants out of sync by a few milliseconds each, which reads as sloppiness rather than variation. Fix: measure derived files as new assets.
- **Varying a motif.** Destroys a recognisable signature to solve a problem it did not have. Fix: identify motifs first; space them instead.
- **Known gap:** there is **no published threshold** for how much variation makes repetition imperceptible — the JND figures bound the useful range from below and the identity limit bounds it from above, but the defaults here (±100 cents, ±1.5 dB, 3 variants, no-repeat-within-3) are house numbers calibrated on those bounds, not measured findings. The cross-correlation check is also only an identical-reuse detector: it cannot tell a pitch-varied copy from a different asset (0.126 vs 0.059 in the verified test), so a variety audit still needs a listen.
