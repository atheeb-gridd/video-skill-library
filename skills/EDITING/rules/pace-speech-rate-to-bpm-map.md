---
id: pace-speech-rate-to-bpm-map
title: Measure your speaking rate, then derive the BPM — never invert the two
skill: editing
type: pacing
family: music-sync
tags: [skill/editing, type/pacing, family/music-sync, layer/music, layer/dialogue, engine/epidemic, engine/ffmpeg, engine/hyperframes, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:18"
    quote: "The higher the BPM, the faster and more energetic your music feels. So if you're talking fast in the video, a high BPM will feel good; and if you're talking slowly, low BPM music will suit it better."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:28"
    quote: "Don't flip the two around — the video will feel really odd."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:35"
    quote: "I mostly use 100-120 BPM music, because I talk a little fast."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:47"
    quote: "Well, you'll find that out by playing the music along with the video."
research_refs:
  - https://en.wikipedia.org/wiki/Words_per_minute
  - https://www.epidemicsound.com/sound-effects/
  - https://librosa.org/doc/latest/generated/librosa.beat.beat_track.html
  - https://aubio.org/manual/latest/cli.html
difficulty: low
detectable_from: transcript+audio
---

# Measure your speaking rate, then derive the BPM — never invert the two

## What it is
The bed's tempo has to track the delivery of the voice. The source states the rule and then states the failure: fast talking wants high BPM, slow talking wants low BPM, and *"don't flip the two around — the video will feel really odd."* It also gives its own working answer — **100–120 BPM, because the creator talks a little fast** — and then admits the method is trial and error: *"you'll find that out by playing the music along with the video."*

**This note replaces the trial and error with a measurement.** The word-level transcript already contains the answer: words divided by elapsed time is a number, and that number maps onto a BPM band. Getting it from the transcript rather than by audition matters for an unattended pipeline, because the audition step is the one an agent cannot perform.

The relationship to its two neighbours is a strict pipeline:

```
transcript ──► THIS NOTE ──► BPM target band ──► pace-bpm-matched-music-selection (the library filter)
                                                        └──► pace-cut-on-the-beat (the grid the cuts snap to)
```

One measurement subtlety decides whether the number is right. **Speech rate** (words ÷ total elapsed time, pauses included) and **articulation rate** (words ÷ voiced time only) are different numbers, and dead-space removal moves the first toward the second. Because the bed plays under the *edited* video, the number you want is the **post-cut speech rate measured on the assembled edit**, not on the raw take. A take at 150 wpm that loses 18% of its runtime to pause removal ([[pace-partial-pause-removal]], [[pace-subtractive-first-pass]]) arrives at roughly 183 wpm — a full band higher, and a bed chosen from the raw take will drag under it.

## When to use it
Before any music is auditioned, on every project with narration and a bed. Specifically:

- At the start of the sound pass, once picture is locked and dead space is removed. Running it earlier gives the wrong number.
- Per **section**, not per video, whenever delivery changes materially between sections — a fast hook and a slow explanation want different beds, and this is the measurement that proves the difference is real rather than felt.
- When a bed "feels off" and nobody can say why. Compute the tempo ratio in the recognition section; a ratio outside 0.45–0.95 identifies the problem in one number.
- When adapting a style profile from a reference creator whose delivery is faster or slower than yours — copying their BPM without adjusting for the delivery difference is exactly the inversion the source warns about.

Skip it where there is no voice: an epic montage or an inspiring-journey sequence has no speech rate, and tempo is chosen from the picture's cut rhythm instead ([[sfx-vocal-track-for-narration-free-montage]]).

## How to recognise it in a reference video
You are measuring two numbers and dividing them.

- **Measure words per minute from the timecoded transcript.** Use the **edited** video's transcript, over a section-length window (60–180 s), not the whole runtime:
  ```bash
  npx hyperframes transcribe ref.mp4 --engine auto        # -> word-level {text,start,end}
  python3 - <<'PY'
  import json,sys
  w=json.load(open('ref.transcribe.json'))['words']
  a,b=60.0,180.0                       # the section window, in seconds
  seg=[x for x in w if a<=x['start']<b]
  voiced=sum(x['end']-x['start'] for x in seg)
  print("speech wpm      ", round(len(seg)/((b-a)/60),1))
  print("articulation wpm", round(len(seg)/(voiced/60),1))
  print("pause fraction  ", round(1-voiced/(b-a),3))
  PY
  ```
  Report both. A **pause fraction above ~0.30** means the edit still has dead space in it and the speech-rate number will move once it is removed.
- **Measure the bed's BPM.** The library reports it (`Recording.bpm` from `SearchRecordings`). Where it is not reported, extract the bed if it is isolable and run a beat tracker:
  ```bash
  aubio tempo -i bed.wav                 # single BPM estimate
  aubiotrack -i bed.wav                  # beat timestamps, in seconds
  ```
  Failing that, count kicks over 20 s three times and average — the manual method the creator's own workflow implies.
- **Compute the tempo ratio: `BPM ÷ WPM`.** This is the single diagnostic.

  | Ratio | Reads as | Action |
  |---|---|---|
  | < 0.45 | Music drags behind the voice; the video feels heavy and slow | Raise BPM one band, or use a double-time feel |
  | 0.55–0.80 | **Well matched.** The modal band for explainer content | None |
  | 0.80–0.95 | Energetic, slightly ahead of the voice — correct for hooks and montage | Fine in short passages |
  | > 0.95 | Music outruns the voice; frantic, the inversion the source warns about | Lower BPM one band, or use a half-time feel |

  Worked example: the creator's own stated 100–120 BPM over a delivery he calls "a little fast" implies a WPM in the high 160s to 180s — ratio ≈ 0.6–0.7, squarely in the matched band.
- **Check per section.** A reference video whose ratio is stable across sections is using one bed for everything; one whose ratio holds while WPM changes is choosing a new bed per section, which is the higher-craft signature ([[sfx-track-change-at-section-boundary]]).
- **Watch for half/double-time.** A track's reported BPM can be half or double its felt pulse. If the ratio computes as 0.35 or 1.4, tap along and check whether the felt pulse is 2× or ½× the metadata before changing the track.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `measurement_window` | 120 s | 60–180 s | Shorter than 60 s and one long pause distorts it. Measure per section. |
| `measure_on` | edited cut | edited cut · raw take | **Always the edited cut.** A raw take under-reports by 10–25% once dead space is removed. |
| `wpm_to_bpm` | `BPM ≈ 0.62 × WPM + 12`, rounded to nearest 5 | — | Fitted to the source's own anchor. Use the band table below in preference; the formula is for interpolation. |
| `target_ratio` | 0.65 | 0.55–0.80 | `BPM ÷ WPM`. Push toward 0.85 for hooks and montage, toward 0.55 for serious or emotional passages. |
| `half_double_tolerance` | 2× or ½× allowed | — | Acceptable **only** if the felt pulse matches the target. 1.5× is never acceptable — it fights the delivery. |
| `fps_friendly_bpm` | 90 · 100 · 120 · 150 | also 75 (24 f/beat), 72 (25 f/beat) | At 30 fps, frames per beat = 1800 ÷ BPM. These give whole-frame beats and make [[pace-cut-on-the-beat]] exact. |
| `per_section_delta` | ≥ 15 BPM | 10–40 BPM | Below this, two sections do not need different beds; the difference will not be felt. |
| `pause_fraction_gate` | 0.30 | 0.20–0.40 | Above this, re-run dead-space removal before trusting the WPM. |

**The band table — the primary lookup:**

| Delivery | WPM (edited) | BPM band | Default | Reference points |
|---|---|---|---|---|
| Deliberate, weighty, emotional | ≤ 120 | 60–85 | 75 | Slide-presentation pace is cited at 100–125 wpm as *comfortable* |
| Measured explainer | 120–145 | 80–100 | 90 | |
| Conversational — the modal band | 145–170 | 95–115 | 105 | Audiobooks are narrated at 150–160 wpm, *"the range that people comfortably hear and vocalize words"* |
| Brisk YouTube explainer | 170–195 | 110–130 | 120 | The source's own band, for delivery he calls "a little fast" |
| Fast, high-energy | 195–220 | 125–150 | 135 | |
| Very fast / hype | > 220 | 140–170, **or** half-time 70–85 with busy subdivision | 150 | Auctioneers run ≈ 250 wpm — past this, tempo stops helping and a half-time feel reads better |

## Reproduction prompt

```
Derive the BPM target for {{SECTION}} of {{PROJECT}} from the speaking rate.
Do this BEFORE auditioning any music.

1. Confirm picture is locked and dead space has been removed. If not, stop -
   the measurement will be wrong by 10-25%.
2. Produce a word-level transcript of the EDITED cut:
     npx hyperframes transcribe {{EDIT}} --engine auto
3. Over a 120-second window inside {{SECTION}}, compute:
     speech_wpm       = words / (window_seconds / 60)
     articulation_wpm = words / (voiced_seconds / 60)
     pause_fraction   = 1 - voiced_seconds / window_seconds
   If pause_fraction > 0.30, go back to dead-space removal and re-measure.
4. Look speech_wpm up in the band table and record the BPM band and default.
   Cross-check with BPM = 0.62 * speech_wpm + 12, rounded to the nearest 5;
   if the two disagree by more than 15 BPM, trust the table and note why.
5. Prefer a BPM that gives whole frames per beat at 30fps - 90 (20f),
   100 (18f), 120 (15f), 150 (12f), 75 (24f) - so the beat grid used by
   pace-cut-on-the-beat is exact. Narrow the search range to
   [default - 10, default + 10] around the nearest friendly value.
6. Search the library with that range as a hard filter, not a preference.
7. If the best candidate's reported BPM is exactly 2x or 0.5x the target,
   accept it ONLY if its felt pulse matches - tap along for 8 bars and
   confirm. Never accept a 1.5x mismatch.
8. Repeat per section. Only give a section its own bed if its speech_wpm
   moves the target by 15 BPM or more.
9. ACCEPTANCE TEST: compute ratio = chosen_BPM / speech_wpm. It must land in
   0.55-0.80 (up to 0.95 for a hook or montage). Then play the section
   start-to-finish once at full speed with the bed under the voice: no
   passage may feel like the music is waiting for the speaker, or like the
   speaker is chasing the music. Record speech_wpm, chosen BPM and the ratio
   in the design document so a re-cut does not have to rediscover them.
```

## Execution spec

**Measurement (ffmpeg / media-use).** The transcript is the instrument. `npx hyperframes transcribe <file>` emits `{ text, words:[{text,start,end}] }`; the default engine is Parakeet-TDT with a whisper.cpp fallback. **On this project's linux ARM64 VM, `parakeet-mlx` is an Apple-silicon MLX stack and is unavailable**, so expect the whisper fallback — accuracy is adequate for a word count, which is all this note needs. If dead space still has to come out first:
```bash
node <SKILL_DIR>/scripts/transcript-cut.mjs --input talk.mp4 --transcript talk.transcribe.json \
  --cut-silence 0.8 --remove-fillers "um,uh" --plan          # inspect first
```
Then re-transcribe the output and measure on that.

**Epidemic Sound.** The derived band goes straight into the search as a hard filter — `SearchRecordings` takes `filter.bpm {min, max}` as integers and can sort by BPM:
```jsonc
// target 120 BPM, brisk explainer at ~178 wpm
{
  "query":  { "term": "driving upbeat corporate" },
  "filter": { "bpm": { "min": 112, "max": 128 }, "vocals": false },
  "sort":   { "by": "BPM", "order": "ASCENDING" },
  "first":  20
}
```
`filter.vocals: false` belongs here whenever the creator's own voice is present ([[sfx-vocal-vs-instrumental-bed]]). `Recording.bpm` comes back on every result, so the ratio check is computable without listening. `SearchSimilarToRecording` finds neighbours of an approved track — useful for the per-section handover — and `EditRecording` with `loopable: true` extends a bed that is shorter than its section. Downloading stops at a local file; placement is HyperFrames.

**HyperFrames.** Nothing about this note is authored in the composition except its consequence: the bed's `data-start`, `data-media-start` (to skip the track's warm-up and land on the first main beat) and `data-volume`. The derived BPM's real payload is the frame grid, and **all authored time is seconds — there is no frame attribute**, so convert once:

```
frames per beat @30fps = 1800 / BPM      120 BPM -> 15 f -> 0.5 s
bar (4 beats)                            120 BPM -> 60 f -> 2.0 s
                                         100 BPM -> 18 f -> 0.6 s / bar 2.4 s
```
Write the BPM, the frames-per-beat and the bar length into the design document; [[pace-cut-on-the-beat]] consumes them.

**Remotion:** irrelevant to the measurement; the BPM would drive `Sequence` frame positions directly. Not present in this project.

## Pairs with
[[pace-bpm-matched-music-selection]] · [[pace-cut-on-the-beat]] · [[pace-beat-grid-extraction]] · [[pace-partial-pause-removal]] · [[pace-subtractive-first-pass]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-mood-map-per-topic]] · [[sfx-track-change-at-section-boundary]] · [[struct-music-arc-to-narrative-arc]] · [[pace-cut-density-from-viewer-intent]]

## Failure modes
- **Measuring the raw take.** The single most common error. Dead-space removal raises speech rate by 10–25%, so a bed chosen from the unedited take will always drag under the finished cut. Fix: measure after the subtractive pass, never before.
- **Inverting the relationship.** Slow delivery over a fast bed, or fast delivery over a slow one — the source's named failure. It does not read as a stylistic choice; it reads as a mistake nobody can name. Fix: compute the ratio; anything outside 0.45–0.95 is wrong.
- **One BPM for a video whose delivery changes.** A calm 130-wpm explanation under the same 135 BPM bed that carried a 210-wpm hook makes the explanation feel rushed. Fix: measure per section; change beds when the target moves 15 BPM or more.
- **Accepting a 1.5× mismatch.** Half and double time work because the pulse aligns; 1.5× puts the beat between the syllables and is audibly wrong. Fix: reject it and widen the search instead.
- **Trusting library BPM metadata blindly.** Reported BPM is sometimes half or double the felt pulse, and occasionally just wrong. Fix: tap along for eight bars before committing, and re-derive frames-per-beat from what you actually hear.
- **Choosing a BPM with a fractional frame count.** 128 BPM at 30 fps is 14.06 frames per beat; a grid built by counting accumulates roughly 16 frames of drift over 64 beats. Fix: prefer 75/90/100/120/150, or generate absolute grid positions rather than chaining them.
- **Known gap:** this stack has no beat detection and no tempo analysis of its own. BPM comes from library metadata, from an external tool (`aubio`, `librosa`) that is *not verified present in this environment*, or from counting by ear. The WPM half is fully computable from the transcript; the BPM half is not, and the design document must record where the number came from.
