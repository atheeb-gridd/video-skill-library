---
id: sfx-length-matched-to-motion
title: Match the effect's length to the motion — stretch it, or stack it
skill: sound-design
type: sfx
family: motion-sync
tags: [skill/sound-design, type/sfx, family/motion-sync, sfx/motion, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:07:08
    quote: "And match the length of the sound effect with the motion. Either by changing the speed, or by layering multiple sound effects."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:07:04
    quote: "And if you're putting a sound effect on a motion, then match the peak of the sound effect to the middle of the motion."
research_refs:
  - https://en.wikipedia.org/wiki/Audio_time_stretching_and_pitch_scaling
  - https://en.wikipedia.org/wiki/Precedence_effect
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Auditory_masking
  - mcp://Epidemic_sounds/SearchSoundEffects (duration filter behaviour probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Match the effect's length to the motion — stretch it, or stack it

## What it is
Aligning a sound's **peak** to a motion is only half the job; the other half is that the sound must last as long as the motion does. A 0.4 s whoosh under a 1.4 s camera push stops a second before the move does, and the last second of the move plays silent — which reads as the animation continuing after the sound already decided it was over. The eye notices, even though the viewer could not tell you why.

Two methods, both named in the source: **change the speed** of one file, or **layer several files** end to end and on top of each other until they cover the whole motion. They are not interchangeable. Speed change is right when the file's shape already matches the motion's shape and only its scale is wrong. Layering is right when the motion has internal structure — an anticipation, a travel, a settle — that no single file has.

The peak rule and the length rule interact, and the interaction is the actual craft: for a motion, the peak goes at the **velocity peak**, which for a standard `power3.out` ease is around 20–30% into the move, not at its midpoint. The naive "peak at the middle" is right only for a symmetric `sine.inOut`. So you size the sound to the motion, then slide it so its peak lands on the fastest frame.

## When to use it
- **Any motion longer than about 0.5 s.** Below that a single short effect covers the whole move and there is nothing to match; above it the mismatch becomes audible.
- **Camera moves, push-ins, parallax drifts, long traverses** — the classic under-covered cases, because the available whooshes are all 0.3–0.8 s and the moves are 1–3 s.
- **Compound motions** — an element that anticipates, travels, and settles. Three phases want at least two sounds ([[sfx-layered-approach-and-impact]]).
- **Staggered arrivals.** A stagger is a sequence of motions, not one motion; the house cap is `items × stagger ≤ ~0.5 s`, so the whole arrival is one sound, not one per item ([[motion-overlay-stack-choreography]]).
- **When you have exactly one whoosh** and need three different ones. Duration change is one of the three variation parameters the source names, alongside reverb and pitch ([[sfx-repetition-variant-rotation]], [[sfx-pitch-shift-weight-energy]]).
- **Not on a hit or impact.** A hit is an event, not a duration; stretching it destroys the attack. If the motion is long and the sound is a hit, you needed a whoosh in front of it, not a longer hit.
- **Not by stretching beyond the artefact threshold.** Past roughly 0.8×–1.25× on transient-rich material the smearing is audible. Beyond that, fetch a different file or layer.
- **Not by layering three copies of the same file.** That is a flam, not a texture. Layers must differ in spectrum or the ear hears one sound with a stutter.

## How to recognise it in a reference video
- **Measure both durations and report the ratio.** The motion's duration comes from the animation (first frame of movement to first frame at rest); the sound's from its own envelope.
  ```bash
  # per-frame RMS of the effect band, 30 fps resolution
  ffmpeg -i ref.mp4 -ar 48000 -af "highpass=f=300,asetnsamples=n=1600,\
   astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" \
   -f null - 2>/dev/null
  ```
  **`coverage = sound_audible_duration / motion_duration`.** A well-matched pair sits at **0.9–1.2**. Below 0.75 the motion outlives its sound; above 1.5 the sound outlives the motion and bleeds into the next beat.
- **Where the peak sits inside the motion**, as a percentage: `(peak_time − motion_start) / motion_duration`. Expect **20–35%** for an ease-out entrance, **45–55%** for a symmetric ease-in-out traverse, **65–80%** for an ease-in exit. A peak at 50% on an ease-out move is the tell that the editor used the naive midpoint rule.
- **Layering is audible as a change of spectral centroid mid-sound** without a break in level — the sound gets brighter or darker while staying continuous. A single stretched file keeps a roughly constant centroid.
- **Stretch artefacts** are audible as a metallic, slightly doubled quality on the transient and a "phasey" smear on the noise tail. On a spectrogram, a phase-vocoder stretch shows horizontal streaking across what should be a vertical transient.
- **A pitch-shifted rather than time-stretched file** gives itself away: the whole spectrum has moved, so a stretched-down whoosh sounds larger and heavier as well as longer. That may be the intent — log which one it is.
- **Count layers**: two is common, three is a designed moment, four or more in a video that is not a trailer is overload ([[sfx-density-fatigue-audit]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Target coverage | 1.0 | 0.9–1.2 | Sound audible duration ÷ motion duration. |
| Peak position — ease-out entrance (`power3.out`) | 25% into the motion | 20–35% | Where the velocity peak is. This is the house entrance ease. |
| Peak position — symmetric traverse (`sine.inOut`) | 50% | 45–55% | The only case where "middle of the motion" is literally right. |
| Peak position — ease-in exit (`power3.in`) | 72% | 65–80% | |
| Peak alignment tolerance | ±1 frame (±0.033 s) | −2 … +1 frames | Audio may lead; lagging is detectable from ~125 ms. |
| Transparent `atempo` range | 0.8–1.25 | — | Below/above this, transient smearing becomes audible on percussive material. Noise-based whooshes tolerate 0.6–1.6. |
| `atempo` hard range | 0.5–2.0 per instance | chainable | `atempo=0.5,atempo=0.5` gives 0.25×. Chaining compounds the artefacts. |
| When to pitch-shift instead | ratio beyond 0.6 or 1.6 | — | `asetrate` changes length **and** pitch. Down = heavier and longer; up = lighter and shorter. Often the better answer ([[sfx-pitch-shift-weight-energy]]). |
| `data-playback-rate` (in-composition) | 1.0 | 0.1–5.0 | Constant only — **there is no rate envelope**. Pitch-preserved. Use for whole-file retimes with no re-encode. |
| Layer crossfade (fuse into one sound) | 30 ms | 10–45 ms | Under ~40 ms two complex sounds fuse into one event. Equal-power curve. |
| Layer separation (read as two events) | 150 ms | ≥100 ms | Between 50 and 100 ms the pair reads as a flam — the one gap to avoid. |
| Level of a secondary layer | −6 dB below the primary | −9 … −3 dB | The primary carries the peak; layers add extension, not level. |
| Layers per motion | 2 | 1–3 | Three only on a designed hero moment. |
| Motion duration bands | fast 0.15–0.3 s · medium 0.3–0.5 s · slow 0.5–0.8 s · very slow 0.8–2.0 s | — | The house speed bands. Match the sound's band to the motion's. |

## Reproduction prompt
```
Fit a sound to the motion running {{M_IN}}..{{M_OUT}} (composition seconds).

1. MEASURE THE MOTION. MOTION_DUR = {{M_OUT}} - {{M_IN}}. Read the tween's ease
   from the composition's timeline code and locate the VELOCITY PEAK:
     power3.out / power4.out (entrance) -> T_PEAK = {{M_IN}} + 0.25*MOTION_DUR
     sine.inOut / expo.inOut (traverse) -> T_PEAK = {{M_IN}} + 0.50*MOTION_DUR
     power3.in (exit)                   -> T_PEAK = {{M_IN}} + 0.72*MOTION_DUR
   Do not default to the midpoint. The midpoint is correct only for inOut eases.

2. FETCH CANDIDATES SIZED TO THE MOTION. SearchSoundEffects with
   filter.duration { min: MOTION_DUR*1000*0.8, max: MOTION_DUR*1000*2 } and an
   appropriate tag slug. Note the duration filter matches the DELIVERED FILE
   length, not the audible event - so keep the window generous and trim in the
   composition with data-media-start rather than searching narrowly.

3. MEASURE THE CANDIDATE. Trace per-frame RMS. Record SFX_PEAK (seconds from file
   start to loudest frame) and SFX_AUDIBLE (from first frame above the floor to
   last). Compute COVERAGE = SFX_AUDIBLE / MOTION_DUR.

4. CHOOSE A METHOD BY COVERAGE.
     0.9 <= COVERAGE <= 1.2  -> place as is. No processing.
     0.75 <= COVERAGE < 0.9 or 1.2 < COVERAGE <= 1.35
                             -> STRETCH. tempo = SFX_AUDIBLE / MOTION_DUR.
                                ffmpeg -i in.wav -af "atempo=<tempo>" out.wav
                                (atempo is 0.5-2.0 per instance and chainable;
                                 stay inside 0.8-1.25 for percussive material)
                                Re-measure SFX_PEAK afterwards - it moved.
     COVERAGE < 0.75         -> LAYER (step 5), or accept a pitch shift with
                                asetrate if a heavier/longer character is wanted.
     COVERAGE > 1.35         -> trim with data-media-start + data-duration and a
                                400 ms tail fade. Do not speed a long file up past
                                1.25x; fetch a shorter one.

5. LAYERING RECIPE. Cover the motion in phases, not in copies.
     phase A - anticipation/approach: a rising air sound, in at {{M_IN}}
     phase B - travel:                the primary whoosh, PEAK at T_PEAK
     phase C - settle:                a short tail, texture or soft tick at {{M_OUT}}
   Every layer must differ in SPECTRUM - a bright swish plus a dark air, not two
   copies of one file. Use SearchSimilarToSoundEffect to find siblings.
   Overlap adjacent layers by 30 ms with an equal-power crossfade so they FUSE
   (under ~40 ms two complex sounds are heard as one event). NEVER leave a gap of
   50-100 ms between layers - that is exactly the range that reads as a flam.
   Secondary layers sit 6 dB below the primary.

6. PLACE. Primary: data-start = T_PEAK - SFX_PEAK, data-media-start = 0,
   data-duration = SFX_AUDIBLE, data-volume = 0.224 (-13 dB rel. dialogue),
   data-audio-group="sfx", each layer on its own data-track-index.
   Give every clip a head and tail fade ([[sfx-edge-fades-click-free]]).

7. ACCEPTANCE TEST. (a) COVERAGE is between 0.9 and 1.2. (b) Scrub to {{M_OUT}}
   minus 3 frames: sound is still present. (c) Scrub to {{M_OUT}} plus 10 frames:
   sound is gone or clearly decaying. (d) The loudest frame is within 1 frame of
   T_PEAK. (e) Solo the layers together and confirm you hear ONE sound with a
   changing character, not two sounds with a seam.
```

## Execution spec

**Placement spec.**

| | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Primary motion effect | **peak on the velocity peak**, 25%/50%/72% into the move by ease; ±1 frame, may lead by 2 | −13 dB (`data-volume` 0.224), range −15…−12 | none for a short move; on a >1.5 s move dip the bed 3 dB across it |
| Approach layer | in on the motion's first frame (0 frames) | −19 dB (`data-volume` 0.112) | none |
| Settle layer | on the motion's last frame (0 frames), tail free to run 10–15 frames past | −19 dB (`data-volume` 0.112) | none |

**HyperFrames.** Two mechanisms and one hard limit.

*In-composition retime* — `data-playback-rate`, normalised to `0.1..5`, constant, render-safe for picture and **pitch-preserved** for sound. This is the cheapest way to fit a file to a motion because it needs no new asset. The limit is stated in the contract and matters here: **there is no rate envelope**, so a sound that should accelerate with the motion cannot be done this way — it must be preprocessed.

*In-composition trim* — `data-media-start` + `data-duration`, both in seconds. Use this rather than cutting a file whenever you only need a window of the asset.

```html
<!-- 1.4 s push-in starting at 30.0 s, power3.out: velocity peak at 30.35 s -->
<!-- primary: a 0.9 s whoosh slowed to 1.4 s with data-playback-rate -->
<audio id="sfx-push-air" src="assets/audio/sfx/whoosh-long.wav"
       data-audio-group="sfx" data-track-index="12"
       data-start="30.0" data-duration="1.45" data-media-start="0.05"
       data-playback-rate="0.64" data-volume="0.224"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.02,&quot;v&quot;:1},{&quot;t&quot;:1.05,&quot;v&quot;:1},{&quot;t&quot;:1.45,&quot;v&quot;:0}]}]}"></audio>

<!-- settle layer: soft texture landing on the last frame, 6 dB down -->
<audio id="sfx-push-settle" src="assets/audio/sfx/air-tail.wav"
       data-audio-group="sfx" data-track-index="13"
       data-start="31.4" data-duration="0.5" data-volume="0.112"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.2,&quot;v&quot;:1},{&quot;t&quot;:0.5,&quot;v&quot;:0}]}]}"></audio>
```

The retime maths, verbatim from the contract: **consumed source = timeline duration × rate**, and **natural timeline duration = remaining source / rate**. So a 0.9 s file at `data-playback-rate="0.64"` occupies 1.41 s of timeline. There is **no audio-follows-animation attribute** — coupling the sound to the tween means writing the same numbers twice, once as the GSAP position and once as `data-start`; if the motion lives in a sub-composition at scene-local `t`, the root-level audio needs `data-start = t + the slot's data-start`, because a sub-comp timeline cannot reach host-root elements and vice versa. Give each layer its own `data-track-index` (overlapping audio on one index raises `duplicate_audio_track`), give every `<audio>` an `id` (an id-less one is never mixed → silent render), and write JSON attributes double-quoted with `&quot;`.

**ffmpeg.** For anything `data-playback-rate` cannot do — a ratio outside 0.1–5, a pitch-shifting retime, or a stretch you want baked so the same treated file is reused.

```bash
# time-stretch, pitch preserved. atempo is 0.5–2.0 per instance and chainable.
ffmpeg -i whoosh.wav -af "atempo=0.643" whoosh_1s4.wav
ffmpeg -i whoosh.wav -af "atempo=0.5,atempo=0.8" whoosh_2s25.wav   # 0.40x overall

# higher-quality stretch with independent transient handling, if the build has it:
#   check availability first — the option set is not in the online docs
ffmpeg -h filter=rubberband
ffmpeg -i whoosh.wav -af "rubberband=tempo=0.643" whoosh_rb.wav

# length AND pitch together (heavier as well as longer) — the source video's own trick
ffmpeg -i whoosh.wav -af "asetrate=48000*0.7,aresample=48000" whoosh_deep_long.wav

# stack two layers into one asset with a 30 ms equal-power crossfade
ffmpeg -i approach.wav -i travel.wav \
  -filter_complex "[0][1]acrossfade=d=0.03:c1=qsin:c2=qsin" motion_layered.wav
```

Method notes that decide which to reach for: `atempo` is a time-domain overlap-add, which is **best on monophonic and noise-based material** (whooshes, air, cloth) and degrades on harmonically complex or percussive content. Phase-vocoder stretching handles harmonic content better but *"introduced considerable smearing on transient waveforms at all non-integer compression/expansion rates"* — which is why a hit should never be stretched at all. `asetrate` is plain resampling: no artefacts whatsoever, but pitch moves with length, and the source video treats that as a feature. After any bake, re-measure the peak offset and register the output (`resolve --from <file> --type sfx`).

**Epidemic Sound.** Size the search to the motion, then trim rather than search narrowly:

```json
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["user-interface--motion"] },
              "duration": { "min": 1100, "max": 2800 } },
  "query":  { "term": "swish swipe long smooth" },
  "sort":   { "by": "DURATION", "order": "ASCENDING" }, "first": 12 }
```

Verified: `duration` filters the **delivered file length**, not the audible event, so a 2 s file may contain a 0.4 s effect with 1.6 s of silence — always measure, never assume. `sort: { by: "DURATION" }` is the fastest way to find a file that is already the right length and skip the stretch entirely. Verified slugs for this family: `user-interface--motion`, `designed--impact`, `designed--boom`, `designed--riser`; unrecognised slugs return `meta.total: 0`. Use `SearchSimilarToSoundEffect(id)` to get spectrally-related siblings for the layer stack — siblings layer well because they share a design language while differing in spectrum.

**Remotion.** `<Audio playbackRate>` on a sequence, or several sequences with staggered `from` frames. Portability note only — Remotion is not part of this stack.

## Pairs with
[[sfx-peak-at-motion-midpoint]] · [[sfx-envelope-matched-to-easing-curve]] · [[sfx-motion-sound-selection]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-swoosh-vs-whoosh]] · [[sfx-layered-approach-and-impact]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-repetition-variant-rotation]] · [[sfx-edge-fades-click-free]] · [[sfx-peak-offset-measurement]] · [[sfx-unsounded-motion-audit]] · [[motion-whoosh-bound-entrance-and-traverse]] · [[motion-sound-bound-motion-event]] · [[motion-parallax-depth-move]] · [[motion-entrance-vocabulary]]

## Failure modes
- **Sound ends before the motion does.** The default failure when a 0.4 s library whoosh is dropped on a 1.5 s move. Measure coverage; below 0.75 it is audible.
- **Peak at the midpoint of an ease-out move.** The velocity peak of `power3.out` is around a quarter in. A midpoint peak lands after the fastest frame and the sound feels dragged.
- **Stretching a hit.** Transient smearing at any non-integer ratio destroys the attack, which is the entire sound. Hits are events; if you need duration, add a whoosh in front.
- **Chaining `atempo` far past the transparent range.** Each instance compounds the artefacts; `atempo=0.5,atempo=0.5` on a percussive file sounds like a broken cassette. Fetch a longer file instead.
- **Layer gap of 50–100 ms.** The one interval to avoid: too long to fuse (the precedence window closes around 40 ms for complex sounds), too short to read as two deliberate events. Either overlap by 30 ms or separate by 150 ms.
- **Layering copies instead of spectra.** Two instances of one file at a small offset is a flam. Layers must differ in brightness or the stack sounds broken rather than rich.
- **Assuming the file's duration is the sound's duration.** Library assets carry silence. The Epidemic `duration` filter measures the file; your ear measures the event.
- **Forgetting to re-measure after a stretch.** `atempo` moves the peak offset by the same ratio. Placing with the pre-stretch offset puts the peak in the wrong place by exactly the amount you stretched.
- **Known gap:** there is **no rate envelope** in the stack (`data-playback-rate` is constant, 0.1–5) and no pitch node in the FX registry, so an accelerating or decelerating sound — the natural partner to an eased motion — cannot be authored in-composition at all. It must be baked with ffmpeg as a derived synchronized asset before placement.
