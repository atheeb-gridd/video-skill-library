---
id: pace-rough-cut-diagnostic
title: Diagnose the cut before you open the library — measure emotion and pace first
skill: editing
type: pacing
family: music-selection
tags: [skill/editing, type/pacing, family/music-selection, engine/ffmpeg, engine/epidemic, engine/hyperframes, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:54"
    quote: "For that, the first thing you need to understand is what your video's emotion and pace are like."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:00"
    quote: "Now if you just hunt for music randomly, you'll waste a ton of time."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:18"
    quote: "The higher the BPM, the faster and more energetic your music feels. So if you're talking fast in the video, a high BPM will feel good; and if you're talking slowly, low BPM music will suit it better."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:28"
    quote: "Don't flip the two around — the video will feel really odd."
research_refs:
  - https://en.wikipedia.org/wiki/Words_per_minute
  - https://www.filmmakersacademy.com/glossary/average-shot-length-asl/
  - https://www.epidemicsound.com/music/moods/
  - https://support.epidemicsound.com/s/article/how-can-i-find-the-right-music-on-epidemic-sound
  - https://ffmpeg.org/ffmpeg-filters.html#silencedetect
difficulty: medium
detectable_from: transcript+video
---

# Diagnose the cut before you open the library — measure emotion and pace first

## What it is
A measurement pass that runs on the rough cut and outputs a small, structured **profile** — a handful of numbers and two words — which every downstream music and sound decision then consumes. The source states the ordering as the first rule of music selection: understand the video's **emotion** and its **pace** before you go looking, because searching before that diagnosis is exactly what produces endless scrolling.

The reason it matters operationally is that the two headline facets of a music library are numeric and categorical: **BPM** and **mood**. Neither can be filled in by taste. Both can be *computed* — BPM from the delivery rate of the voice and the cutting rate of the picture, mood from the script's own stance. Once the profile exists, the search is a filter query rather than a browse, and the same profile can be re-used to check whether the chosen track actually fits.

The profile has five fields, and each has a named consumer:

| Field | Measured from | Consumed by |
|---|---|---|
| `wpm` | word-level transcript | BPM band |
| `cpm` / `asl` | scene detection on the picture track | BPM band, cut-density review |
| `vci` (visual change interval) | every visual change, not just cuts | stimulation budget |
| `emotion` | script stance, resolved to library vocabulary | mood facet |
| `energy_curve` | per-minute `wpm` and `cpm` | where the bed changes and where it rests |

## When to use it
Once, on the rough cut, immediately before the music pass — after picture is broadly locked and pause removal has run (pace is not measurable on unstripped A-roll), and before any track is auditioned. Re-run it per section if the video's delivery changes materially between sections; the per-minute curve will tell you whether it does.

Also run it as the **first step of analysing a reference video**, because the same five fields are exactly what a design document needs in order to reproduce someone else's feel. And re-run the `cpm` and `vci` fields after the B-roll pass, since both change substantially once overlays land.

Skip it only for a video with no music and no B-roll — and note that even then `wpm` and `vci` are the inputs to the retention review.

## How to recognise it in a reference video
This note *is* the recognition procedure. The measurements, in order:

- **Speaking rate.** Transcribe to word level, then `wpm = words ÷ (speech seconds ÷ 60)`. Use **speech** seconds, not runtime — silent B-roll windows would otherwise drag the number down. Reference anchors: slide presentations are comfortable at **100–125 wpm**, audiobooks are read at **150–160 wpm**, auctioneers hit about **250 wpm**. Creator explainers sit at 150–200 wpm; above ~200 the delivery is stripped and fast.
  ```bash
  node <SKILL_DIR>/scripts/transcribe.mjs --input ref.mp4 --out ref.transcribe.json
  # wpm = words.length / ((words[last].end - words[0].start - total_gaps) / 60)
  ```
- **Cut rate and average shot length.** `asl = runtime_seconds ÷ shots`, `cpm = 60 ÷ asl`. Anchors from film: *2001: A Space Odyssey* at **13 s** ASL, *The Bourne Supremacy* at **2.4 s**. Creator talking-head with pause removal typically lands at **1.5–4 s** ASL (15–40 cuts/min); a montage section runs under 1 s.
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=10,metadata=print" -f null - 2>&1 | grep lavfi.scd | wc -l
  ```
  Use a low `scdet` threshold on locked-off talking-head footage — a jump cut is a small frame change and a default threshold misses most of them.
- **Visual change interval.** Cuts are only part of the picture's rhythm. Count *every* visual change: cuts, B-roll in and out, graphic arrivals, punch-ins, caption changes, full-screen transitions. `vci = runtime ÷ visual_changes`. This is the number that actually predicts whether the video feels alive; the cut count alone under-reports videos that use overlays instead of cuts ([[pace-overlay-instead-of-cut]], [[pace-visual-change-clock]]).
- **Per-minute curve.** Bucket `wpm` and `cpm` by minute and plot. A flat curve means the video has one gear; a good long-form video shows a fast opening minute, a settled body, and a lift at each payoff. **The curve is where the music map's boundaries and rests should go** ([[sfx-mood-map-per-topic]], [[sfx-music-rest-windows]]).
- **Emotion, resolved to library vocabulary.** Do not write an adjective of your own. Read the script and answer three questions, then join to the library's controlled moods:
  - **Valence** — is the viewer being told something good, bad, or neutral?
  - **Arousal** — should they be leaning in (urgent, tense, excited) or settled (calm, considered)?
  - **Stance** — is the presenter warning, teaching, celebrating, confiding, or provoking?
  Two words out: e.g. *negative + high arousal + warning* → `Suspense` / `Dark`; *positive + high arousal + celebrating* → `Epic` / `Euphoric`; *neutral + low arousal + teaching* → `Laid Back` / `Smooth`.
- **Cross-check the two halves.** Fast delivery with a long ASL, or slow delivery with a 0.8 s ASL, is a genuine finding: the video's picture and voice disagree about its pace, and any single music tempo will fight one of them. Log the mismatch rather than averaging it away.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `wpm` | measured | 100–220 | Words ÷ speech-minutes. 100–125 presentational · 150–160 audiobook · 150–200 typical creator · >200 stripped-fast. |
| `asl` | measured | 0.8–8 s | Runtime ÷ shots. Creator talking-head 1.5–4 s. |
| `cpm` | 60 ÷ asl | 8–40 | Cuts per minute. |
| `vci` | measured | 1.5–6 s | Seconds between *any* visual change. The retention-relevant number. |
| `bpm_target` | `0.55 × wpm + 18` | 70–140 | House mapping from delivery to bed tempo, clamped. 150 wpm → 100 · 170 → 112 · 190 → 122. Matches the creator's stated 100–120 BPM default for a "slightly fast" delivery. |
| `bpm_band` | ±10 BPM | ±8 to ±15 | Search width around `bpm_target`. Narrower than ±8 returns almost nothing. |
| `bpm_asl_check` | `asl × BPM ÷ 60` | 2–8 beats | Beats per average shot. If you intend to cut on the beat, this should land near a whole number of beats, ideally 4 (one bar) — see [[pace-cut-on-the-beat]]. |
| `emotion` | measured | — | Two words, both from the library's controlled mood vocabulary. |
| `energy_bucket` | 1 min | 30–120 s | Bucket width for the per-minute curve. |
| `curve_range` | ≥1.4× | 1.0–2.5× | Max ÷ min bucketed `cpm`. Below 1.2 the video has one gear and needs a deliberate contrast section. |
| `speech_ratio` | 0.75 | 0.5–0.95 | Speech seconds ÷ runtime. Below 0.5 the video is a montage and `wpm` stops being the pace driver — use `vci` instead. |
| `scdet_threshold` | 10 | 6–14 | ffmpeg `scdet=t=`. Lower for locked-off talking head, higher for handheld/high-motion. |
| `mismatch_flag` | — | — | Raised when `bpm_target` from `wpm` and `bpm_target` from `asl` differ by more than 20 BPM. |

## Reproduction prompt

```
Produce the pace-and-emotion profile for {{SRC}} before any music is chosen.
Output a single JSON object; do not open a music library during this pass.

1. Transcribe to word level. Compute:
   words          = total word count
   speech_s       = sum of word durations plus inter-word gaps under 0.8s
   wpm            = words / (speech_s / 60)
   speech_ratio   = speech_s / runtime_s
2. Detect shots on the picture track with a LOW threshold suited to the
   footage (start at scdet=t=10; lower it until the count stops rising
   sharply). Compute shots, asl = runtime_s / shots, cpm = 60 / asl.
3. Count EVERY visual change, not just cuts: cuts, B-roll in/out, graphic
   arrivals, punch-ins, caption line changes, transitions. Compute
   vci = runtime_s / visual_changes.
4. Bucket wpm and cpm per minute. Output the two arrays and
   curve_range = max(cpm_bucket) / min(cpm_bucket).
5. Classify EMOTION from the script only, in three answers - valence
   (positive/negative/neutral), arousal (high/low), stance (warning,
   teaching, celebrating, confiding, provoking) - then resolve them to TWO
   mood terms taken from the target library's controlled vocabulary. Never
   invent an adjective; if your word is not in the library's list, pick the
   nearest one that is.
6. Compute bpm_target = clamp(0.55 * wpm + 18, 70, 140) and bpm_band = +-10.
   Cross-check against the picture: bpm_from_picture = 240 / asl (i.e. one
   bar per average shot). If the two differ by more than 20 BPM, set
   mismatch_flag true and report both - do not average them.
7. Emit:
   { wpm, speech_ratio, shots, asl, cpm, vci, cpm_by_minute, wpm_by_minute,
     curve_range, emotion: [m1, m2], bpm_target, bpm_band, mismatch_flag }
8. ACCEPTANCE TEST: (a) every number is derived from a command or a count,
   none from impression; (b) both emotion words exist verbatim in the target
   library's mood list; (c) curve_range >= 1.2, or flag that the video has
   one gear; (d) if speech_ratio < 0.5, note that vci, not wpm, drives the
   tempo choice for this video.
```

## Execution spec

**ffmpeg / transcription (this pass is entirely measurement).**

```bash
# word-level transcript (Parakeet default, whisper.cpp fallback)
node <SKILL_DIR>/scripts/transcribe.mjs --input ref.mp4 --out ref.transcribe.json
npx hyperframes transcribe ref.mp4 --engine auto

# shot boundaries
ffmpeg -i ref.mp4 -vf "scdet=t=10,metadata=print" -f null - 2>&1 | grep lavfi.scd

# frame-aligned loudness trace (n=1600 @48kHz = exactly one frame at 30fps)
ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null

# alternative shot lister
scenedetect -i ref.mp4 detect-adaptive list-scenes
```

**Constraint that shapes this pass in this project:** the documented transcription default, `parakeet-mlx`, is an **Apple-silicon MLX** stack and is unavailable on this linux ARM64 VM; the whisper.cpp fallback is what actually runs here. `scenedetect` and `auto-editor` are pip installs and there is no `sudo` on this device, so verify they exist before relying on them — `ffmpeg` itself is assumed present.

**HyperFrames.** The profile is not a composition, but it belongs *with* the project. Two sane homes: as frontmatter/metadata in `STORYBOARD.md` (unknown frontmatter keys are preserved and the parser never throws), or as a small JSON alongside `meta.json`. Once the bed is chosen, the profile's `bpm_target` becomes the ruler for placement: at 30 fps, **frames per beat = 1800 ÷ BPM**, and a bar is four of those — used by [[pace-cut-on-the-beat]]. Remember the mount cannot delete files, so revise the profile by overwriting or superseding, never by removing it.

**Epidemic Sound.** The profile is a search query with no fields left to guess:

```
SearchRecordings {
  query.term: "<emotion[0]> <emotion[1]> instrumental",
  filter.moods: ["<emotion[0]>", "<emotion[1]>"],
  filter.bpm: { min: bpm_target - 10, max: bpm_target + 10 },
  filter.hasVocals: false,
  filter.duration: { min: <section length in ms> }
}
```
Run `SearchSimilarToRecording` on whatever survives auditioning to build adjacent cues. Audition against picture, never in isolation ([[sfx-music-audition-against-picture]]).

**Remotion:** not applicable — this pass produces data, not a composition.

## Pairs with
[[pace-bpm-matched-music-selection]] · [[sfx-mood-map-per-topic]] · [[sfx-vibe-brief]] · [[pace-cut-on-the-beat]] · [[pace-visual-change-clock]] · [[pace-visual-variety-density-audit]] · [[pace-cut-density-from-viewer-intent]] · [[pace-partial-pause-removal]] · [[struct-stimulation-budget]] · [[sfx-music-audition-against-picture]] · [[sfx-vocal-vs-instrumental-bed]]

## Failure modes
- **Measuring before the pause pass.** Unstripped A-roll reports a slow `wpm` that will not survive the edit, and you will pick a bed 20 BPM too slow. Fix: run [[pace-partial-pause-removal]] first, then measure.
- **Using runtime instead of speech time for `wpm`.** A video with 40% silent B-roll reports as slow-talking when the delivery is fast. Fix: `speech_ratio` is part of the profile for exactly this reason.
- **Default `scdet` threshold on locked-off footage.** Jump cuts in a static frame are small changes; a default threshold under-counts them badly and the `asl` comes out 3× too long. Fix: lower the threshold until the count stabilises, and sanity-check by hand on one minute.
- **Counting only cuts.** A video that uses overlays instead of cuts scores as slow and gets a slow bed. Fix: `vci`, not `cpm`, is the perceptual number.
- **Inventing the mood adjective.** "Anticipation" and "innovative" are not facets in any library and return nothing. Fix: resolve to the controlled vocabulary in step 5.
- **Averaging a mismatch.** When picture and voice disagree about pace, the mean fits neither and the bed fights the edit everywhere. Fix: report both, and decide which one the music is serving — usually the voice in explainer work, the picture in montage.
- **One profile for a ten-minute video.** A single BPM across sections with different energy is the reason beds stop working halfway through. Fix: profile per section once `curve_range` exceeds ~1.6.
- **Inverting the mapping.** The source is explicit: fast delivery with a slow bed, or the reverse, makes the video feel "really odd". Fix: the mapping is monotonic; never invert it for variety.
- **Known gap:** the `bpm_target = 0.55 × wpm + 18` mapping is house calibration, fitted to the one datum the source provides (a "slightly fast" delivery pairing with 100–120 BPM) and to the published speech-rate anchors. No library or standards body publishes a wpm→BPM function. Treat it as a starting filter, always audition, and prefer a measured BPM from a reference video when one exists.
