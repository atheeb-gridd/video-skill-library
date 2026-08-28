---
id: sfx-edge-fades-click-free
title: Fade both ends of every effect — the click-free edge, and the fade that is short enough to keep the attack
skill: sound-design
type: mix
family: clip-hygiene
tags: [skill/sound-design, type/mix, family/clip-hygiene, layer/sfx, layer/ambience, layer/design, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-1, source/research, difficulty/low]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:08:31
    quote: "We'll add [a fade] so that our sound effect both comes in and ends properly."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:10:04
    quote: "reverb, changing the pitch, or changing the duration — change all of these and you can make a unique number of variations out of one single sound effect"
research_refs:
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Precedence_effect
  - https://en.wikipedia.org/wiki/Auditory_masking
difficulty: low
detectable_from: audio
---

# Fade both ends of every effect — the click-free edge, and the fade that is short enough to keep the attack

## What it is
Every audio clip you place has two edges, and both are hazards. A clip that starts or stops at a non-zero sample amplitude produces an instantaneous step in the waveform, and a step is broadband energy — a click. It is quiet, it is 1 ms long, and on a phone speaker it is the most audible defect in an otherwise good mix, because nothing else in the material has that spectrum.

The fix is a fade at each end, and the whole craft is in the **length**. Too short and the click survives. Too long and you have destroyed the thing you placed: a 30 ms head fade on a cinematic hit removes its attack, which is the only part of a hit that matters. So the rule is not "add fades", it is **head fade sized to the material, tail fade sized to the decay** — a few milliseconds at the head of a transient effect, tens of milliseconds at the head of a pad, and hundreds at any tail you are cutting short.

The source video treats this as a step in building a DIY effect, alongside pitch and duration. It is more general than that: it applies to every clip on the timeline, including ones you did not edit, because a library file trimmed with `data-media-start` has a new, arbitrary start sample.

## When to use it
- **On every SFX clip, always.** There is no case where an unfaded edge is correct. Treat it as clip hygiene rather than as a creative choice, and make it part of the placement recipe rather than a pass afterwards.
- **Especially after any trim.** `data-media-start` moves the in-point to an arbitrary sample; `data-duration` cuts the out-point at an arbitrary sample. Both create edges that did not exist in the file.
- **Especially on looped or repeated material** — ambience beds, heartbeats, clock ticks. A loop seam is two edges at once and clicks on every repetition.
- **On the tail of anything you are cutting short**: a hit whose decay you do not have room for, a riser you are ending early, an ambience going out under a cut.
- **Not as a substitute for a well-chosen in-point.** A fade hides a click; it does not hide a sound starting mid-syllable or mid-decay. Fix the in-point first ([[sfx-peak-offset-measurement]]).
- **Not on the head of a transient effect beyond ~5 ms.** Past that you are shaping the attack, and a hit or whip with a softened attack is a different, weaker sound.
- **Not as a crossfade between two takes of the same sound.** Correlated material phase-cancels in the middle of a crossfade; butt-join them at a transient instead ([[sfx-transient-masked-outpoint]]).

## How to recognise it in a reference video
- **Clicks show as isolated single-frame broadband spikes** with no musical context. Trace per-sample peak in a tight window around each suspected edit:
  ```bash
  # ~1 ms resolution at 48 kHz
  ffmpeg -i ref.wav -ar 48000 -af "asetnsamples=n=48,astats=metadata=1:reset=1,\
   ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
  ```
  A click is a **≥12 dB rise and fall inside 3 consecutive 1 ms windows** with no rise before it. A real transient has a decay; a click has neither attack nor decay.
- **On a spectrogram** a click is a vertical line spanning the full band, identical from 50 Hz to 18 kHz. Nothing natural looks like that.
- **Loop seams repeat.** If the same spike recurs at a fixed interval matching the file length, you have found an unfaded loop, and the interval tells you the file's duration.
- **A truncated tail is the inverse defect** — level cut from full to floor in under ~10 ms with no click, because the source was already faded but far too fast. It reads as a dropout rather than as a pop.
- **What a well-treated reference looks like:** every effect's onset shows 2–5 ms of ramp before its transient, and every effect's out-point shows ≥40 ms of decay to the floor. Log both numbers per effect; they are cheap to measure and they separate careful mixes from careless ones instantly.
- **Where to look first:** the frames immediately after a cut, where a trimmed ambience or a re-timed effect most often starts.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Head fade — **transient** effect (hit, whip, click, impact) | 3 ms | 1–5 ms | Long enough to kill the step, short enough to leave the attack intact. **Never exceed 5 ms** on a transient. |
| Head fade — **non-transient** effect (whoosh, riser, pad, texture) | 20 ms | 10–50 ms | The material has no attack to protect. |
| Head fade — **ambience / bed** | 300 ms | 150–800 ms | Here the fade is also the editorial entrance ([[sfx-ambience-establishes-location]]). |
| Head fade — **voice / plosive softening** | 10 ms | 5–15 ms | A 10 ms head fade is the standard trick for taming a plosive at a clip start. |
| Absolute minimum to remove a click | 1 ms (48 samples @48 kHz) | — | Below this the ramp is itself a step. |
| Tail fade — effect with its own decay, running to its natural end | 5 ms | 2–10 ms | The decay has already done the work; you are only guarding the last sample. |
| Tail fade — effect **cut short** (hit, riser, texture) | 400 ms | 150–800 ms | Must be long enough that the truncation is not heard as a dropout. |
| Tail fade — ambience out under a cut | 600 ms | 300–1200 ms | |
| Tail fade — loop seam | 15 ms each side | 10–30 ms | Both ends, and equal, or the loop pumps. |
| Fade curve — **uncorrelated** material (the normal case) | equal-power (`qsin` / `hsin`) | — | Midpoint multiplier 0.707 = −3 dB; preserves perceived loudness through the fade. |
| Fade curve — **correlated** material (two takes of one sound) | linear (`tri`) | — | Sums to 1, avoids the level bump; but prefer a butt-join, because correlated crossfades phase-cancel. |
| Fade curve in HyperFrames lanes | linear (no `curve` field) | `curve` −1…1 | The lane's default straight segment is correct for both head and tail at these lengths; reach for `curve` only on fades over ~300 ms. |
| Crossfade between two **different** SFX layers | 30 ms | 10–50 ms | Under ~40 ms two complex sounds fuse into one event (precedence window). Over ~50 ms they separate audibly. |

## Reproduction prompt
```
Give every audio clip on the timeline a click-free head and tail.

1. CLASSIFY EACH CLIP by what its first 50 ms contain.
     TRANSIENT   (hit, impact, whip, click, snap)     -> head fade 3 ms
     NON-TRANSIENT (whoosh, riser, texture, pad)      -> head fade 20 ms
     AMBIENCE / BED                                    -> head fade 300 ms
   Then classify its out-point:
     runs to its own natural end                       -> tail fade 5 ms
     CUT SHORT before its decay finishes               -> tail fade 400 ms
     ambience going out under a cut                    -> tail fade 600 ms

2. AUTHOR AS A VOLUME AUTOMATION LANE, in clip-local seconds. Four points is the
   whole shape. For a 2.5 s hit cut short:
     {"version":1,"lanes":[{"target":"volume","points":[
       {"t":0,"v":0},{"t":0.003,"v":1},{"t":2.1,"v":1},{"t":2.5,"v":0}]}]}
   Write the attribute DOUBLE-QUOTED with &quot; entities, not single-quoted, or
   carve.mjs cannot see it and will silently overwrite it.

3. RESPECT THE HALF-OPEN WINDOW. The clip is visible for [start, start+duration)
   and is gone at exactly start+duration. Put the lane's final v=0 point AT
   data-duration, not past it - a point beyond the duration is never reached and
   the clip stops at whatever level it had.

4. AUTHOR t=0 EXPLICITLY, ALWAYS. A lane holds its first value BACKWARDS to the
   clip start and its last value FORWARDS to the end. A lane whose first point is
   {"t":0.003,"v":1} therefore has no fade-in at all - it is full level from the
   first sample.

5. DO NOT ALSO GSAP-TWEEN volume on the same element. The lane wins and the tween
   is silently ignored (audio_volume_double_automation). And note that a volume
   tween is ABSOLUTE - it replaces data-volume rather than scaling it.

6. IF THE CLIP HAS A REVERB OR DELAY NODE, its rendered tail runs PAST
   data-duration (the mix is told via chainTailSeconds). Your lane cannot fade
   what happens after the window. Either shorten the reverb, or bake the tail
   into the asset with ffmpeg before placing it.

7. VERIFY. Render the clip in isolation and run the 1 ms peak trace across both
   edges. Acceptance: no single 1 ms window rises >12 dB above its two neighbours
   at either edge, AND the effect's attack is still present - compare the first
   30 ms against the untreated source and confirm the peak level is within 1 dB.
   If the attack lost more than 1 dB, your head fade is too long.
```

## Execution spec

**Placement spec.** Fades do not change *where* a clip sits — the transient still lands on its event frame (0 to −1 frames) and the gain stays at the clip's tier (SFX −12 to −15 dB relative to dialogue, `data-volume` 0.178–0.251). What they change is the clip's first and last few milliseconds. Because the head fade on a transient is ≤5 ms and one frame at 30 fps is 33 ms, **a correct head fade never moves the perceived hit point** — that is the test that tells you it is short enough.

**HyperFrames.** A fade is a `volume` automation lane, in **clip-local seconds**, and nothing else. There is no fade attribute and no fade primitive.

```html
<!-- transient effect: 3 ms in, 400 ms out because the tail is being cut -->
<audio id="sfx-hit-02" src="assets/audio/sfx/hit.wav"
       data-audio-group="sfx" data-track-index="13"
       data-start="42.0" data-duration="2.5" data-media-start="0.08"
       data-volume="0.355"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.003,&quot;v&quot;:1},{&quot;t&quot;:2.1,&quot;v&quot;:1},{&quot;t&quot;:2.5,&quot;v&quot;:0}]}]}"></audio>

<!-- ambience bed: 300 ms in, 600 ms out -->
<audio id="amb-office" src="assets/audio/sfx/room-tone-office.wav"
       data-audio-group="ambience" data-track-index="15"
       data-start="12.0" data-duration="34.0" data-volume="0.126"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.3,&quot;v&quot;:1},{&quot;t&quot;:33.4,&quot;v&quot;:1},{&quot;t&quot;:34,&quot;v&quot;:0}]}]}"></audio>
```

The four load-bearing rules, all from the audio attribute contract:

1. **`t` is clip-local**, measured from the clip's own `data-start` — except on an `<hf-audio-group>` bus, where `t` is **composition time**, because a bus has no `data-start`.
2. **A lane holds its first value backwards and its last value forwards.** Omitting the `t: 0` point does not give you a fade from zero; it gives you full level from the first sample.
3. **512 points per lane, maximum**, which is far more than a fade needs but matters if you are also automating.
4. **`curve` (−1…1) bends the segment *leaving* a point**; `viaX`/`viaY` name an interior point and supersede it. At 3–20 ms the curve is inaudible, so leave it off; for a 600 ms ambience fade it is worth a listen.

Interactions to keep straight: `data-volume` is the **baseline** and the lane's `v` is 0..1 of the track's own level, so they compose; a **GSAP `volume` tween** is absolute and replaces `data-volume` entirely, and pairing one with a lane silently loses the tween (`audio_volume_double_automation`). Nothing in `lint` validates lanes — a typo'd target is pruned on read and a lane on a non-automatable parameter is silently inert — so verification is by listening, not by gate.

**ffmpeg.** For baking fades into an asset before it enters the composition, which is the right move whenever the same treated file will be reused, or when a reverb tail needs to be inside the file rather than after the clip window:

```bash
# 3 ms head, 400 ms tail on a 2.5 s hit; equal-power curve
ffmpeg -i hit.wav -af "afade=t=in:st=0:d=0.003:curve=qsin,\
afade=t=out:st=2.1:d=0.4:curve=qsin" hit.faded.wav

# make a loop seamless: 15 ms crossfade of the file onto itself
ffmpeg -i amb.wav -i amb.wav -filter_complex "[0][1]acrossfade=d=0.015:c1=tri:c2=tri" amb.loop.wav

# 1 ms peak trace to prove there is no click left
ffmpeg -i hit.faded.wav -ar 48000 -af "asetnsamples=n=48,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
```

`afade` options are `type`/`t` (`in`|`out`), `start_time`/`st`, `duration`/`d`, `start_sample`/`ss`, `nb_samples`/`ns`, `silence` (default 0.0), `unity` (default 1.0) and `curve`. Curves available: `tri` (linear), `qsin`, `hsin`, `esin`, `log`, `ipar`, `qua`, `cub`, `squ`, `cbr`, `par`, `exp`, `iqsin`, `ihsin`, `dese`, `desi`, `losi`, `sinc`, `isinc`, `quat`, `quatr`, `qsin2`, `hsin2`, `nofade`. Use `qsin`/`hsin` (equal-power, −3 dB at the midpoint) for uncorrelated material and `tri` (linear, sums to 1) when the two sides are correlated. `acrossfade` takes the same curve set as `c1`/`c2`. **Do not use `--copy`-style stream copying on a file you have just faded** — and remember any file you bake re-enters the composition as a new `src`; register it with `resolve --from <file> --type sfx` if you want it in the ledger.

**Epidemic Sound.** Nothing to fetch — but two facts about fetched assets are relevant. Library effects are delivered with their own natural head and tail, so an **untrimmed** clip placed at `data-media-start="0"` usually needs only the minimum guard fades. The moment you set a non-zero `data-media-start`, you have created a new start sample at an arbitrary amplitude and the full head fade applies. Download WAV (`{"fileType":"WAV"}`) — an MP3's encoder padding adds its own silence and its own edge behaviour at the head.

**Remotion.** A `volume` callback interpolating over the first and last few frames. Portability note only — Remotion is not part of this stack.

## Pairs with
[[sfx-transient-masked-outpoint]] · [[sfx-hard-cut-audio-seam]] · [[sfx-peak-offset-measurement]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-riser-hit-pair]] · [[sfx-length-matched-to-motion]] · [[sfx-ambience-establishes-location]] · [[sfx-missing-ambience-audit]] · [[sfx-intimate-proximity-sounds]] · [[sfx-reverb-glue]] · [[sfx-layer-volume-targets]] · [[sfx-repetition-variant-rotation]]

## Failure modes
- **No fade at all after a trim.** The commonest defect in a library-sourced mix, and the one that most reliably makes a video sound amateur on a phone. Every `data-media-start` creates an edge.
- **A head fade long enough to eat the attack.** 20 ms on a hit removes what you paid for. If the treated clip's first 30 ms peak more than 1 dB below the source's, the fade is too long.
- **Omitting the `t: 0` point.** A lane starting at `{"t":0.003,"v":1}` has no fade — the lane holds its first value backwards. This looks correct in the JSON and does nothing.
- **A final point past `data-duration`.** The clip's window is half-open; a fade authored to finish after the window never finishes, and the clip stops at full level. Land the last point exactly on the duration.
- **A tail fade of 10 ms on a truncated hit.** No click, but an audible dropout. A cut-short decay needs 150–800 ms.
- **Crossfading two takes of the same sound.** Correlated material phase-cancels in the middle of a crossfade — in the extreme case you get silence where the join should be. Butt-join at a transient instead.
- **Single-quoted JSON attributes.** They parse in the browser but are invisible to `carve.mjs`'s `name="..."` regex, so the next carve silently overwrites the lane you wrote.
- **Assuming the fade catches a reverb tail.** Effects with a tail make the rendered track longer than `data-duration` via `chainTailSeconds`. The lane ends with the window; the tail does not. Bake it or shorten it.
- **Known gap:** nothing in `lint` or `check` inspects fades, lane shapes, or clicks — the linter reads `data-automation` for exactly two conflicts and *"nothing validates the chain or the effect lanes at all."* This audit is manual, and the render that would let you hear it must run off the authoring VM.
