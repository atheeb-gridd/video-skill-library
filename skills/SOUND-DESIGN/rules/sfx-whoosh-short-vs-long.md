---
id: sfx-whoosh-short-vs-long
title: Short whoosh or long whoosh — pick the family from the length of the move, then trim to fit
skill: sound-design
type: sfx
family: whoosh
tags: [skill/sound-design, type/sfx, family/whoosh, sfx/motion, layer/sfx, engine/hyperframes, engine/epidemic, engine/ffmpeg, engine/remotion, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:00:30"
    quote: "But there are a lot of different types of whoosh — a fast short whoosh, or a long one."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:01:16"
    quote: "You can tweak this by changing the pitch. If you push the pitch high, the sound effect will feel a bit lighter, but if you take the pitch low, it'll sound like a really heavy, weighty whoosh."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:08"
    quote: "And match the length of the sound effect with the motion. Either by changing the speed, or by layering multiple sound effects."
research_refs:
  - https://en.wikipedia.org/wiki/Audio_time_stretching_and_pitch_scaling
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Sound_effect
  - https://en.wikipedia.org/wiki/Transient_(acoustics)
difficulty: medium
detectable_from: audio
---

# Short whoosh or long whoosh — pick the family from the length of the move, then trim to fit

## What it is
"Whoosh" is a family, not a file. The source splits it at the first fork — *a fast short whoosh, or a long one* — and the rule that decides between them is the one it gives two videos later: **match the length of the sound effect to the length of the motion**, by changing the speed or by layering. [[sfx-whoosh-transition-movement-reveal]] owns the anchor frame (where the peak sits relative to a cut) and [[sfx-envelope-matched-to-easing-curve]] owns the envelope (where the peak sits inside the move). This note owns **duration**: which sub-family a given move needs, what the library actually contains, and the two legitimate ways to change a file's length without wrecking it.

The practical finding that changes how you search: in the Epidemic library the short whooshes are **not** filed under "whoosh". Filtering `swooshes--whoosh` returns **1** file under 500 ms and **13** between 500 ms and 1.2 s, but **235** between 1.2 and 3 s and **729** over 3 s — most of the long ones being multi-take compilation files up to 78 s. The sub-second air moves live under `swooshes--swish` (**61** files at or under 1.2 s, the shortest at **118 ms**), and the 3–5 s sustained sweeps live under `designed--whoosh` and `designed--riser`. So "find a short whoosh" is usually the wrong instruction; "search swish, or window a long whoosh with `data-media-start`" is the right one.

**Style.** Filed `sfx/motion`: both the sub-family and the duration are read off the move. The long sustained sweeps under `designed--whoosh` and `designed--riser` shade into the aesthetic layer, where they are chosen for build rather than for travel ([[sfx-riser-anticipation-build]]).

## When to use it
- **Any authored move that travels**: a title crossing frame, a card sliding in, a push-slide or whip-pan transition, a camera move, a graphic reveal, a body movement or an eye roll ([[sfx-air-on-micro-movement]]).
- **Choose by the move's duration, not by the move's importance.** A 4-frame snap and a 2-second camera push both want air; they want air of completely different lengths.
- **Reach for the long family** when the picture keeps moving for a second or more — a slow push, a long parallax move, a sustained mask wipe. A 400 ms whoosh under a 2 s move leaves the second half of the motion silent, which reads as the animation continuing after its sound has finished.
- **Reach for the short family** for snaps, cuts, ticks and micro-moves — and layer it over a longer bed rather than stretching it.
- **Do not** use a whoosh at all on a discontinuity the eye cannot track; that is a whip crack ([[sfx-whip-crack-on-snap-cut]]). And do not use one on a real physical action that has its own sound ([[sfx-diegetic-action-inventory]]).

**The family table**

| Move duration | Family | What to search | File length band | Notes |
|---|---|---|---|---|
| ≤0.20 s (≤6 f) | **swish / air swipe** | `tagSlugs ANY ["swooshes--swish"]`, `duration.max 400` | 0.10–0.40 s | Verified: 61 files ≤1.2 s under this tag, shortest 118 ms. |
| 0.25–0.50 s | **short whoosh** | `swooshes--whoosh`, `duration.max 900` — or window a longer file | 0.40–0.90 s | Only ~14 files exist this short under the whoosh tag; trimming is normal, not a compromise. |
| 0.5–1.2 s | **standard transition whoosh** | `swooshes--whoosh`, `duration 1200–3000` | 1.2–3.0 s | The library's centre of mass: 235 files. |
| 1.2–2.5 s | **long / designed whoosh** | `designed--whoosh`, `duration 2000–5000` | 2.0–5.0 s | e.g. *"Designed, Whoosh, Cymbal Rise, Bassy, Boom, Processed"* (3858 ms). |
| >2.5 s, resolving on a reveal | **riser-whoosh** | `designed--riser` | 3.0–6.0 s | This is a different technique: [[sfx-riser-anticipation-build]] owns it. |

## How to recognise it in a reference video
- **Measure both lengths.** Time the visual move frame by frame; measure the effect's audible body (from first energy above ≈−45 dBFS to where it falls back). The ratio in competent work is **1.0–1.3×**, tail excluded.
- **Ratio under 0.8** = the move outlives its sound: the tell of a short file dropped on a long move.
- **Ratio over 1.6** = the sound outlives the move, which reads as a whoosh belonging to something else on screen — and in a fast cut it will smear into the next shot.
- **Listen for stretch artifacts.** A whoosh stretched beyond about ±35 % with a pitch-preserving algorithm loses its transient definition (phase-vocoder smearing on transients is documented at all non-integer ratios); the peak sounds "wide" and the effect stops locating in time.
- **Listen for varispeed.** If the same whoosh recurs at obviously different pitches *and* lengths, the editor is rate-stretching (pitch and duration coupled) rather than time-stretching — a legitimate, and often better, choice for air.
- **Count repeats.** The same whoosh sample four times in ten seconds is the source's named mistake (*"the same sound effect repeated again and again"*). Look for pitch/length variation between instances ([[sfx-density-fatigue-audit]]).
- **Check for layering.** A long move sounded by *one* long file is the simple case; a long move sounded by a bed plus a short accent on the arrival is the crafted case, and the arrival accent will sit at the move's settle, not its start.
- **Spectral weight vs element size.** Big element → darker whoosh; small element → brighter. A thin bright swish under a full-screen transition reads cheap.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `duration_ratio` | 1.15× the move | 1.0–1.3× (body); tail free | The single number this note exists to enforce. |
| `family` | from the table | — | Decided by move duration alone. |
| `trim_method` | `data-media-start` + `data-duration` | — | Window the file in the composition; do not cut a physical file unless it is leaving the pipeline. |
| `rate_stretch_inpipe` | 1.0 | 0.75–1.35 | `data-playback-rate` is a **constant** 0.1–5 and is **pitch-preserved**, so it changes length only. Beyond ±35 % the transient smears — audition it. |
| `varispeed_bake` | off | ±2 to ±5 semitones | Pitch-with-speed needs ffmpeg (`asetrate`); the source's own "high = lighter, low = heavier" knob. |
| `layer_instead` | preferred over >±35 % stretch | — | Long bed + short arrival accent, per *"either by changing the speed, or by layering multiple sound effects."* |
| `peak_position` | from the ease | out-ease 10–20 % · inOut 50 % · in-ease 85–100 % | See [[sfx-envelope-matched-to-easing-curve]]. |
| `anchor_tolerance` | ±0.5 f (±17 ms) | ±0.25–1 f | Never early by more than 1 frame. |
| `level` | −13 dB | −12 to −15 dB | The source's SFX band; dialogue 0 to −3, music −20 to −25. |
| `tail_fade` | 0.15 s | 0.10–0.30 s | A `volume` lane ending at 0 stops a trimmed tail clicking. |
| `variants` | 3 | 2–4 | Rotate files, or vary rate/pitch, before a fourth repeat. |
| `reverb` | 8–15 % wet | 0–25 % | *"Without reverb, sound effects feel like they were recorded in a studio."* |

## Reproduction prompt

```
Sound the move {{EVENT}} (starts {{T}}, visual duration {{D}} seconds,
ease {{EASE}}) with a correctly sized whoosh.

1. PICK THE FAMILY BY {{D}}:
     D <= 0.20s -> swish        : tagSlugs ANY ["swooshes--swish"], max 400ms
     D 0.25-0.5 -> short whoosh : tagSlugs ANY ["swooshes--whoosh"], max 900ms
     D 0.5-1.2  -> whoosh       : ["swooshes--whoosh"], 1200-3000ms
     D 1.2-2.5  -> long whoosh  : ["designed--whoosh"], 2000-5000ms
     D > 2.5s resolving on a reveal -> use a riser instead.

2. TARGET LENGTH = 1.15 * {{D}} for the audible body (accept 1.0-1.3x).

3. FIT THE FILE, in this order of preference:
   a) WINDOW IT. Find the transient offset, then set data-media-start to
      (peak_offset - lead) and data-duration to the target length. Add a
      volume automation lane fading the last 0.15s to 0 so the trim does not
      click.
   b) RATE-STRETCH IN COMPOSITION. data-playback-rate = file_body /
      target_length, kept within 0.75-1.35. It is pitch-preserved, so this
      changes length only. Audition: if the peak sounds smeared, go back to (a).
   c) LAYER. For a long move, use a long bed at -15 dB plus a short accent at
      -13 dB on the move's settle frame. Prefer this over any stretch beyond
      +/-35%.

4. ANCHOR THE PEAK. out-ease -> peak at 0.15*{{D}} after {{T}};
   inOut -> 0.50*{{D}}; in-ease -> 0.92*{{D}}. Set data-start so the file's
   loudest sample lands there; err late by at most 1 frame, never early.

5. CHARACTER. Large element or heavy move -> pitch DOWN 2-3 semitones (bake
   with ffmpeg asetrate; data-playback-rate cannot pitch). Small or fast ->
   pitch UP. Add 8-15% reverb so it sits in the room.

ACCEPTANCE TEST: measured audible body is 1.0-1.3x {{D}}; the loudest sample
falls within half a frame of the derived peak time; no click at the trim; the
same file is not used more than three times in the video without variation.
```

## Execution spec

**HyperFrames.** Windowing and rate are clip attributes; the tail fade is an automation lane.

```html
<!-- a 2.0s camera push at t=41.0: long whoosh, windowed to 2.3s of body -->
<audio id="sfx-push-air" src="assets/sfx/designed-whoosh-cymbal-rise.wav"
       data-audio-group="sfx"
       data-start="40.85" data-media-start="0.42" data-duration="2.45"
       data-track-index="12" data-volume="0.45"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:2.30,&quot;v&quot;:1},{&quot;t&quot;:2.45,&quot;v&quot;:0}]}]}"></audio>

<!-- a 0.30s title slide at t=12.30: swish, rate-stretched 1.2x shorter -->
<audio id="sfx-title-air" src="assets/sfx/swish-air-swipe.wav"
       data-audio-group="sfx"
       data-start="12.27" data-media-start="0.02" data-duration="0.32"
       data-playback-rate="1.2" data-track-index="13" data-volume="0.5"></audio>
```

Contract points:
- **`data-playback-rate` is a constant in 0.1–5 and is pitch-preserved.** It is a time-stretch, not a varispeed: it cannot deliver the source's pitch knob. There is **no rate envelope** — a whoosh that accelerates must be baked.
- `data-media-start` and `data-duration` window the file with no new file on disk; *"only cut a physical file when exporting/assembling outside the composition."*
- Every `<audio>` needs an `id` — an id-less audio element is never mixed and the render is silently missing it.
- A `volume` automation lane's `t` is **clip-local**, and **a lane holds its first value backwards to the clip start**; put an explicit `{"t":0,"v":1}` point in or the fade starts wrong.
- Do not also GSAP-tween `volume` on a clip that has a `volume` lane (`audio_volume_double_automation` — the lane wins) and remember a `volume` tween **replaces** `data-volume` rather than scaling it.
- Two `<audio>` on the same `data-track-index` overlapping in time raise `duplicate_audio_track`; alternate 12/13 in a run of fast moves.
- Group SFX as `data-audio-group="sfx"` — never inside the voice group, which would poison the carve.

**Epidemic Sound.** The verified queries behind the family table:

```
SearchSoundEffects { filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--swish"] },
                               duration: { max: 400 } }, sort: { by: "DURATION", order: "ASCENDING" } }
SearchSoundEffects { query: { term: "whoosh" },
                     filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--whoosh"] },
                               duration: { min: 1200, max: 3000 } } }
SearchSoundEffects { query: { term: "long whoosh transition rising" },
                     filter: { duration: { min: 2000, max: 5000 } } }
```

Named results confirmed in the library: *"Swooshes, Whoosh, Designed, Generic, Wide"* (420 ms), *"…Generic, Air"* (546 ms), *"Swooshes, Swish, Stick, Whip, Swoosh, Air Swipe"* (118 ms), *"Designed, Riser, Transition, Whoosh, Fast, Short 02"* (3594 ms). Use `SearchSimilarToSoundEffect` to build the 2–4 variants rather than re-using one file.

**ffmpeg — the two stretch modes and the measurement.**

```bash
# where is the peak inside the file? (this is what you align, never the file head)
ffmpeg -i whoosh.wav -af "silencedetect=noise=-45dB:d=0.02" -f null - 2>&1 | grep silence_
# TIME-STRETCH, pitch preserved (what data-playback-rate does): 1.25x shorter
ffmpeg -i whoosh.wav -af "atempo=1.25" whoosh.short.wav          # atempo accepts 0.5..100
# VARISPEED, pitch follows speed (the source's heavy/light knob): -3 semitones
ffmpeg -i whoosh.wav -af "asetrate=48000*0.8409,aresample=48000" whoosh.heavy.wav
# varispeed pitch WITHOUT changing length: correct the tempo back
ffmpeg -i whoosh.wav -af "asetrate=48000*0.8409,aresample=48000,atempo=1.1892" whoosh.heavy.samelen.wav
```

`atempo` preserves pitch (time-domain, WSOLA-family) and smears transients at extreme ratios; `asetrate` is pure resampling, so pitch and duration move together — the chipmunk relationship, and exactly the knob the source describes.

**Remotion.** `<Audio startFrom={…} endAt={…} playbackRate={…}>` is the conceptual equivalent of `data-media-start`/`data-duration`/`data-playback-rate`; note Remotion's `playbackRate` is varispeed-ish rather than pitch-preserved. Concept only — not a runtime here.

## Pairs with
[[sfx-whoosh-transition-movement-reveal]] · [[sfx-envelope-matched-to-easing-curve]] · [[sfx-air-on-micro-movement]] · [[sfx-whip-crack-on-snap-cut]] · [[motion-whip-pan-transition]] · [[motion-travel-reveal-streak]] · [[motion-entrance-vocabulary]] · [[motion-emphasis-scale-step]] · [[sfx-riser-anticipation-build]] · [[sfx-search-vocabulary]] · [[sfx-density-fatigue-audit]] · [[motion-sound-bound-motion-event]] · [[sfx-three-types-classification]]

## Failure modes
- **One whoosh for every move.** A single 900 ms file on a 4-frame snap and on a 2 s push. Correction: pick the family from the move's duration.
- **Searching "short whoosh" and taking whatever comes back.** The library has almost nothing that short under that tag; you end up with a 1.4 s file dropped on a 0.3 s move. Correction: search `swooshes--swish`, or window a long file.
- **Stretching instead of layering.** A 400 ms swish pulled to 2 s smears into a wash. Correction: bed plus accent.
- **Pitching with `data-playback-rate`.** It is pitch-preserved; the sound gets shorter, not heavier. Correction: bake with `asetrate`.
- **Aligning the file head.** Whooshes carry 20–150 ms of pre-roll, so the peak lands late. Correction: measure the peak and back-time `data-start`.
- **Trim click.** A hard `data-duration` in the middle of the tail. Correction: a 0.15 s fade in the `volume` lane.
- **Tail smearing into the next shot.** A 3 s designed whoosh over a 0.4 s cut run. Correction: window it, or use the shorter family.
- **The same file four times.** The source's named mistake. Correction: 2–4 variants, or vary rate and pitch.
