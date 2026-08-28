---
id: sfx-variation-set-generator
title: One file into a variation set — the pitch/duration/reverb grid and how to bake it
skill: sound-design
type: sfx
family: variation
tags: [skill/sound-design, type/sfx, family/variation, layer/sfx, engine/ffmpeg, engine/hyperframes, engine/epidemic, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:09:47
    quote: "if you have to use a sound effect repeatedly — say you need a whoosh three or four times in a row — don't use the same whoosh sound there. It sounds really odd, people pick up on it."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:10:04
    quote: "reverb, changing the pitch, or changing the duration — change all of these and you can make a unique number of variations out of one single sound effect, and use them."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:08:01
    quote: "Pitch — lower for a heavy, cinematic, subtle feel; higher for a light, fast or energetic feel."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Sound_effect
  - https://en.wikipedia.org/wiki/Semitone
  - https://en.wikipedia.org/wiki/Just-noticeable_difference
  - mcp://Epidemic_sounds/SearchSoundEffects (multi-take "Variations" titles observed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# One file into a variation set — the pitch/duration/reverb grid and how to bake it

## What it is
The no-budget answer to the repetition problem, and — more usefully — the *professional* answer to it as well. Given one whoosh and three knobs, **reverb, pitch and duration**, you can generate a set of files that a listener hears as different events. [[sfx-repetition-variant-rotation]] owns the *why* (habituation is stimulus-specific, so a varied stimulus keeps working while an identical one stops being heard by about the fifth repeat) and the *policy* (never the same file twice in a row). **This note is the generator**: the exact parameter grid, the commands that produce it, the naming, and the one measurement that must be redone per variant.

Three facts about this stack determine the whole design, and none of them are optional:

1. **Render-time randomness is banned.** No unseeded `Math.random()`, no clocks. Variation cannot be generated at play time; it must exist as **files** chosen by an index-derived, authored decision.
2. **There is no pitch node in the FX registry.** Filters, dynamics, nonlinear, delay/reverb/chorus/phaser — no pitch shifter. So the pitch knob is **only** available as a baked file.
3. **`data-playback-rate` is pitch-preserved** and a constant in `0.1..5` with **no rate envelope**. It changes duration without changing pitch, which is the *opposite* of what tape-style variation wants, and it cannot ramp.

Consequences: **pitch variants are baked with ffmpeg; duration variants can be baked or trimmed in-composition; reverb variants are free in-composition** (the FX registry has a `reverb` node whose `size`/`damping` regenerate a deterministic impulse — *"preview and render generate the same one, so a room is reproducible without shipping an impulse file"*). A well-built set therefore ships **6 baked pitch/duration files** and gets its third dimension for nothing from the composition's own reverb.

The perceptual windows come from discrimination limits and they bound the grid at both ends. Pitch differences below roughly **50 cents** are heard as the same sound slightly off; differences beyond about **3 semitones** are heard as a genuinely different object rather than another instance of the same one. Duration changes below **~15 %** pass unnoticed; beyond **~40 %** the envelope no longer matches the motion it was chosen for. Level differences below **1 dB** (the loudness JND) do nothing; above **3 dB** they read as inconsistent mixing rather than as variation. Every number in the grid below sits inside those brackets.

**Style.** No `sfx/` style tag: the pitch/duration/reverb grid is run over whatever file needs variants — a footstep, an entrance whoosh or a riser — and the policy it serves lives in [[sfx-repetition-variant-rotation]].

## When to use it
- **Any effect family used three or more times in one video** — text entrances, list items, transitions, footsteps, UI clicks. Three uses is the threshold at which identical repeats start being noticed.
- **When the library shelf is thin.** Some shelves are small: `swooshes--whoosh` filtered to 300–1500 ms returns **14** effects. Generating from two of them beats scraping a fifth mediocre asset.
- **When a family must stay coherent.** Six variants of one file are *provably* the same texture; six different downloads are not. For a recurring channel signature this is the stronger choice, not the cheaper one.
- **When one asset is nearly right but the wrong weight.** A single pitch step down is a size change, not just a variation ([[sfx-pitch-shift-weight-energy]]).
- **Build the set once, at library time, not per project** — it belongs in the shared library with its own naming ([[sfx-library-build-and-taxonomy]]).
- **Not for a hero moment.** The one cinematic hit that carries the video's climax should be its own chosen asset, not variant 4 of something.
- **Not as a substitute for a real second asset** when the two uses are different *kinds* of event. A whoosh pitched down is still a whoosh; it will not become an impact.

## How to recognise it in a reference video
- **Same family, different instances.** Isolate every occurrence of one effect family and compare spectrograms. Variants of one file share an **identical envelope shape** and an identical harmonic/noise structure, **frequency-scaled**. Different assets do not.
- **Frequency scaling is the fingerprint.** If instance B's whole spectrum is the same picture shifted up or down by a constant ratio *and* its duration scales by the inverse of that ratio, it is a resampled variant (`asetrate`). Measure a spectral landmark in each: `semitones = 12 * log2(f_B / f_A)`.
- **Duration-only change with no pitch change** means a time-stretch (`atempo`) or a trim — check whether the envelope is compressed or truncated. Truncated variants have a cut-off tail; stretched ones do not.
- **Reverb-only change** shows as an identical dry signal with a different tail length. Measure the decay from the last transient to the noise floor; 0.2 s vs 0.9 s across two instances of the same file is a wet/dry variation.
- **Count the rotation.** Log every instance in order and look for an immediate repeat. A generated set used properly shows **no two consecutive identical instances**; a lazy edit shows the same file three times in a row.
- **Set size.** Count distinct variants across the video. **3** is the working minimum, **6** is a professional set, more than 8 in one family usually means several assets are in play rather than one generated set.
- **Level spread.** Variants in a good rotation differ by **1–3 dB**. A 6 dB spread reads as a mixing error, not as variation.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Set size | 6 | 3–8 | 3 is the minimum that prevents immediate repeats over a long list; 6 makes runs of 12+ safe. |
| Pitch step grid | −2, −1, +1, +2 semitones | −3 … +3 st | `asetrate` ratio = `2^(n/12)`: −3 → 0.8409 · −2 → 0.8909 · −1 → 0.9439 · +1 → 1.0595 · +2 → 1.1225 · +3 → 1.1892. |
| Minimum audible pitch difference | 50 cents | 30–100 cents | Above the ~10-cent discrimination limit, so it is heard as variation rather than as error. |
| Maximum pitch difference | 3 semitones | 2–4 st | Beyond this the ear hears a different object, not another instance. |
| Duration step grid | ×0.85, ×1.00, ×1.18 | ×0.70 … ×1.40 | `atempo` values are the inverse: 1.176, 1.0, 0.847. |
| Minimum audible duration change | 15 % | 12–20 % | Below this the change does no work. |
| Maximum duration change | 40 % | 30–50 % | Beyond this the envelope stops matching the motion it was chosen for. |
| Reverb variants | `wet` 0.02 / 0.10 / 0.18 | 0.00–0.30 | Done **in-composition**, free, no extra files. `size` 0.15 / 0.35 / 0.60. |
| Level jitter per instance | ±1.5 dB | ±1 … ±3 dB | Above the 1 dB JND, below the 3 dB "inconsistent mix" threshold. |
| Micro-timing jitter | ±1 frame (±0.033 s) | 0 … ±2 f | Only on non-frame-locked uses. Never jitter an impact off its contact frame. |
| Combined-knob rule | change **two** knobs per variant | 1–3 | One knob is a version; two is a different event; three starts to break the family. |
| Peak offset | **re-measure per variant** | — | Resampling moves the peak. Do not reuse the base file's `data-media-start`. |
| Rotation policy | round-robin, no immediate repeat | — | Authored at pass time — randomness at render is banned. |
| Source format | WAV throughout | — | Never pitch-shift a lossy file; the artefacts shift with it and become audible. |
| Naming | `<family>-<base>-p<±nn>-t<nnn>.wav` | — | e.g. `whoosh-air-01-p-02-t118.wav` = base 01, −2 semitones, tempo ×1.18. |

**The 6-variant default grid** (two knobs each, all inside the brackets above):

| Variant | Pitch (st) | `asetrate` ratio | Tempo | Resulting duration | Suggested in-comp `reverb.wet` |
|---|---|---|---|---|---|
| `v0` (base) | 0 | 1.0000 | ×1.00 | ×1.000 | 0.02 |
| `v1` | −2 | 0.8909 | ×1.00 (coupled) | ×1.123 | 0.10 |
| `v2` | +2 | 1.1225 | ×1.00 (coupled) | ×0.891 | 0.02 |
| `v3` | −1 | 0.9439 | ×1.18 (decoupled) | ×0.898 | 0.18 |
| `v4` | +1 | 1.0595 | ×0.85 (decoupled) | ×1.110 | 0.10 |
| `v5` | −3 | 0.8409 | restored to ×1.00 | ×1.000 | 0.18 |

"Coupled" means `asetrate` alone — tape behaviour, pitch and duration move together, and it is the **right default for sound effects** because a bigger thing genuinely is both lower and slower. "Decoupled" adds an `atempo` stage to pull duration back independently.

## Reproduction prompt
```
Generate a named variation set from one source effect and register it in the library.

0. START FROM WAV. Download the base with fileType WAV. Never generate variants from
   an mp3 - resampling shifts the codec artefacts along with the signal and they
   become audible as a warble.

1. TRIM THE BASE FIRST. Many library files hold several takes ("...Variations 04").
   Cut the single take you want into base.wav before generating, or you will produce
   six copies of a file with three unwanted takes in it.

2. BAKE SIX VARIANTS with the default grid. r = 2^(n/12).
     v1  -2 st coupled   : asetrate=48000*0.8909,aresample=48000
     v2  +2 st coupled   : asetrate=48000*1.1225,aresample=48000
     v3  -1 st, +18% fast: asetrate=48000*0.9439,aresample=48000,atempo=1.176
     v4  +1 st, -15% slow: asetrate=48000*1.0595,aresample=48000,atempo=0.847
     v5  -3 st, duration restored:
                           asetrate=48000*0.8409,aresample=48000,atempo=0.8409
   Name them <family>-<base>-p<±nn>-t<nnn>.wav. Keep v0 (the untouched base).
   atempo is limited to 0.5-2.0 per instance; chain two for anything larger.

3. RE-MEASURE THE PEAK OFFSET OF EVERY VARIANT. Resampling moves it. Record
   PEAK_v0..PEAK_v5 - these become each clip's data-media-start when it is placed.
   Do NOT copy the base's offset across the set. This is the step people skip and it
   is why a "variation set" ends up sounding sloppy rather than varied.

4. GET THE THIRD KNOB FREE. Do not bake reverb. Assign each variant an in-composition
   reverb node instead - wet 0.02 / 0.10 / 0.18, size 0.15 / 0.35 / 0.60 - so the same
   six files can also sound like three different rooms. The impulse is generated
   deterministically, so preview and render agree.

5. ADD LEVEL JITTER AT PLACEMENT, not in the file: +-1.5 dB via data-volume
   (multiply the tier's linear value by 0.84 to 1.19). Above 1 dB so it is heard;
   below 3 dB so it does not read as a mixing error.

6. ROTATE ROUND-ROBIN, AUTHORED. Assign variants by instance index i:
   variant = set[i mod 6]. Write the assignment out; do NOT call Math.random() -
   unseeded randomness is banned in this stack and would not be deterministic anyway.

7. REGISTER. resolve --from <each file> --type sfx --project . , and add a row per
   variant to the library index with its family, base id, pitch, tempo and peak offset.

ACCEPTANCE TEST.
(a) Play v0 then v1 back to back: they are audibly different events, not the same
    sound at two levels.
(b) Play v0 then v5: still recognisably the SAME family. If v5 sounds like a
    different object, the pitch step is too big - pull it to -2.
(c) Every variant has its own measured peak offset recorded.
(d) In the finished timeline, no two consecutive uses of this family share a variant.
(e) The loudest and quietest instance differ by <= 3 dB.
```

## Execution spec

**Placement spec (the three numbers).** A variant inherits the placement of whatever role it fills — that is the point of a set. What the set adds is the per-instance jitter:

| | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Motion-role variant | onset −4 f, peak inside the move | −12 dB ±1.5 dB (`data-volume` 0.21–0.30) | none |
| Diegetic-role variant | peak **on** the contact frame, 0 to +1 f | −16 dB ±1.5 dB (0.133–0.188) | none |
| Aesthetic-role variant | arrives early, resolves on the beat | −20 dB ±1.5 dB (0.084–0.119) | bed −4 to −8 dB |
| Micro-timing jitter | ±1 f, **only** on non-frame-locked uses | — | — |

**ffmpeg — the generator.** This is the payload of the note. `asetrate` resamples (tape behaviour: pitch and duration move together); `aresample` puts the sample rate back so the file is normal; `atempo` changes duration only, and is limited to **0.5–2.0 per instance**.

```bash
#!/usr/bin/env bash
# generate a 6-variant set from one WAV. Run OUTSIDE the vault mount:
# the mounted vault cannot delete files, so keep intermediates elsewhere.
BASE="$1"; FAM="$2"; SR=48000
OUT="$HOME/sfxgen/$FAM"; mkdir -p "$OUT"
cp "$BASE" "$OUT/${FAM}-v0-p+00-t100.wav"

# coupled (tape) - pitch and duration move together. Right default for SFX.
ffmpeg -y -i "$BASE" -af "asetrate=${SR}*0.8909,aresample=${SR}" "$OUT/${FAM}-v1-p-02-t100.wav"
ffmpeg -y -i "$BASE" -af "asetrate=${SR}*1.1225,aresample=${SR}" "$OUT/${FAM}-v2-p+02-t100.wav"

# decoupled - pitch one way, duration the other
ffmpeg -y -i "$BASE" -af "asetrate=${SR}*0.9439,aresample=${SR},atempo=1.176" "$OUT/${FAM}-v3-p-01-t118.wav"
ffmpeg -y -i "$BASE" -af "asetrate=${SR}*1.0595,aresample=${SR},atempo=0.847" "$OUT/${FAM}-v4-p+01-t085.wav"

# pitch shift with duration RESTORED: atempo = the same ratio
ffmpeg -y -i "$BASE" -af "asetrate=${SR}*0.8409,aresample=${SR},atempo=0.8409" "$OUT/${FAM}-v5-p-03-t100.wav"

# re-measure every peak - resampling MOVED it
for f in "$OUT"/*.wav; do
  echo "== $f"
  ffmpeg -i "$f" -ar ${SR} -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null | head -40
done
```

Supporting operations:
```bash
# trim one take out of a multi-take library file BEFORE generating
ffmpeg -i "Swooshes, Whoosh, Variations.wav" -ss 1.24 -to 1.79 -c:a pcm_s16le base.wav
# normalise the set so data-volume means the same thing on every variant
ffmpeg -i v1.wav -af loudnorm=I=-23:TP=-1.5:LRA=7:print_format=json -f null -
# larger tempo changes need chaining (atempo caps at 2.0 per instance)
ffmpeg -i base.wav -af "atempo=2.0,atempo=1.5" base.x3.wav
# an alternative pitch path IF your build has it - do not assume it is compiled in
ffmpeg -i base.wav -af "rubberband=pitch=0.89" v1.rb.wav
```
`rubberband` preserves formants and duration independently, but it is an optional external library and **is not guaranteed present** — the contract lists ffmpeg itself as *"assumed present"* and nothing more. For sound effects the `asetrate` path is preferable anyway: it preserves transient shape, and a bigger thing genuinely is both lower and slower. Register every output: `node <SKILL_DIR>/scripts/resolve.mjs --from <file> --type sfx --project .`

**HyperFrames — the set placed, with the free reverb knob.**

```html
<!-- three text entrances at 12.20, 14.80, 17.10: variants v0, v3, v1, three rooms -->
<audio id="sfx-in-01" src="assets/sfx/whoosh-air-v0-p+00-t100.wav"
       data-audio-group="sfx-motion" data-track-index="13"
       data-start="12.067" data-duration="0.50" data-media-start="0.030" data-volume="0.250"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;r1&quot;,&quot;label&quot;:&quot;Tight&quot;,&quot;params&quot;:{&quot;size&quot;:0.15,&quot;damping&quot;:0.6,&quot;wet&quot;:0.02,&quot;dry&quot;:1}}]}"></audio>

<audio id="sfx-in-02" src="assets/sfx/whoosh-air-v3-p-01-t118.wav"
       data-audio-group="sfx-motion" data-track-index="14"
       data-start="14.667" data-duration="0.45" data-media-start="0.026" data-volume="0.210"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;r1&quot;,&quot;label&quot;:&quot;Room&quot;,&quot;params&quot;:{&quot;size&quot;:0.6,&quot;damping&quot;:0.4,&quot;wet&quot;:0.18,&quot;dry&quot;:0.95}}]}"></audio>

<audio id="sfx-in-03" src="assets/sfx/whoosh-air-v1-p-02-t100.wav"
       data-audio-group="sfx-motion" data-track-index="13"
       data-start="16.967" data-duration="0.56" data-media-start="0.034" data-volume="0.297"></audio>
```

Contract points:
- **Each variant has its own `data-media-start`** — 0.030, 0.026, 0.034. Those are the *measured* peak offsets, and they differ precisely because resampling moved them. Reusing one number across the set is the commonest way a variation set still sounds sloppy.
- **`data-volume` carries the ±1.5 dB jitter**: 0.250 (−12 dB), 0.210 (−13.5 dB), 0.297 (−10.5 dB). Do not also GSAP-tween `volume` — a tween is absolute and replaces the gain (`audio_volume_tween_overrides_gain`).
- **Reverb is the free third knob**, and its impulse is generated deterministically so preview and render match. But note that `reverb`'s `size` and `damping` **regenerate the impulse and are therefore not automatable**; only `wet`/`dry` automate. And a reverb tail makes the rendered track **longer than its `data-duration`** via `chainTailSeconds` — expected, not a bug.
- **Alternating `data-track-index`** matters only where clips overlap; these do not, but keep the habit for dense rotations (`duplicate_audio_track`).
- **Every `<audio>` needs an `id`** or it is never mixed and the render is silent.
- **There is no pitch node and no `data-playback-rate` envelope**, which is exactly why the pitch column is a set of files rather than an attribute.

**Epidemic Sound — start from an asset that is already a set where you can.**
```
# titles containing "Variations" are multi-take: one download, several takes to trim
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["swooshes--whoosh"] },
                               duration: { min: 1500, max: 8000 } },
                     query: { term: "variations" },
                     sort: { by: POPULARITY, order: DESCENDING }, first: 12 }
# siblings of a base you already like - the cheapest way to widen a family
SearchSimilarToSoundEffect { id: "<base uuid>", first: 12 }
```
Observed live 2026-08-28: `user-interface--motion` titles such as *"Short Swish, Swipe, Open, Close, Variations 04"* and `mechanical--click`'s *"Metal Click, Close, Variations 01"* are multi-take files — trimming them gives real, recorded variation, which always beats a generated one. Generate only for what the shelf does not supply. Always `DownloadSoundEffect` with `{"fileType":"WAV"}`.

**Remotion.** An array of variant sources indexed by `index % set.length`, with `startFrom` set per variant. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-repetition-variant-rotation]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-reverb-glue]] · [[sfx-library-build-and-taxonomy]] · [[sfx-library-quality-gate]] · [[sfx-peak-offset-measurement]] · [[sfx-length-matched-to-motion]] · [[sfx-edge-fades-click-free]] · [[sfx-three-types-classification]] · [[sfx-motion-sound-selection]] · [[sfx-density-fatigue-audit]] · [[sfx-source-licensing-and-clearance]] · [[sfx-ui-demo-payoff-sound]]

## Failure modes
- **Reusing the base's peak offset across the set.** Resampling moves the peak by the same ratio it moves everything else. Every variant needs its own measured `data-media-start` or the rotation lands progressively off.
- **Pitch steps too large.** Beyond ~3 semitones the variant is heard as a different object, so the family stops reading as a family and the coherence you generated the set for is gone.
- **Pitch steps too small.** Under ~50 cents nothing is perceived except a vague wrongness. Above the 10-cent discrimination limit is not enough; it has to be clearly a variation.
- **Generating from an mp3.** Codec artefacts resample along with the signal and turn into audible warble on the quiet tail. WAV in, WAV out.
- **Generating from a multi-take file without trimming first.** You get six copies of a file containing three takes, and every placement then needs a different `data-media-start` for a reason that has nothing to do with variation.
- **Changing all three knobs on every variant.** Pitch + duration + reverb + level at once produces six sounds that are no longer relatives. Two knobs per variant.
- **Level spread over 3 dB.** Reads as inconsistent mixing rather than as variation, and undermines the whole rotation.
- **Jittering timing on a frame-locked use.** A ±1 frame nudge is fine on a decorative entrance and wrong on an impact — a diegetic contact sound must stay on the contact frame.
- **Trying to do it at render time.** `Math.random()` is banned, there is no pitch node, and `data-playback-rate` is pitch-preserving. Nothing about this can be deferred to playback; it is a build step.
- **Known gap — `rubberband` is not guaranteed.** Formant-preserving pitch shift may simply not be compiled into the available ffmpeg. Check before writing a spec that depends on it; the `asetrate` path always works and is usually better for effects anyway.
- **Known gap — the vault cannot delete files.** Generate into a scratch directory outside the mount and copy only the winners in; there is no cleanup step available inside the vault.
