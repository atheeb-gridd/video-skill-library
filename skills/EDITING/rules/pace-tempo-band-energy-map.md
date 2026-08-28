---
id: pace-tempo-band-energy-map
title: BPM as the energy dial — the tempo band table and how to derive it from delivery
skill: editing
type: pacing
family: music-tempo
tags: [skill/editing, type/pacing, family/music-tempo, layer/music, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:13"
    quote: "if your music is 60 BPM, that means 60 beats per minute. That is, one beat every second... The higher the BPM, the faster and more energetic your music will feel."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:18"
    quote: "Fast talking, high BPM. Slow talking, low BPM. Do not invert it — the video will feel very off."
research_refs:
  - https://en.wikipedia.org/wiki/Tempo
  - https://en.wikipedia.org/wiki/Phrase_(music)
  - https://en.wikipedia.org/wiki/Beatmatching
difficulty: low
detectable_from: audio
---

# BPM as the energy dial — the tempo band table and how to derive it from delivery

## What it is
BPM is beats per minute: at 60 BPM there is exactly one beat per second, at 120 there are two. That arithmetic is the whole definition, and everything useful about it follows from turning it into two other numbers. The first is **frames per beat**, which at 30 fps is `1800 / BPM` — this is what makes tempo an *editing* parameter rather than a taste parameter, because it is the grid every cut can land on. The second is **perceived energy**: higher BPM reads faster and more energetic, lower reads calmer, and the classical Italian tempo vocabulary already carries a published mapping from BPM range to felt character (Largo 40–66 "slow and broad", Andante 56–108 "at a walking pace", Moderato 108–120, Allegro 120–156 "fast and bright", Vivace 156–176, Presto 168–200).

This note owns **the band table and the derivation** — how to compute the right BPM from the video's own delivery before you touch a library. Its neighbours own the rest: [[pace-bpm-matched-music-selection]] owns the search workflow (BPM + instruments + vibe as filters, "find similar" to expand), and [[pace-cut-on-the-beat]] owns placing cuts on the resulting grid. The one hard rule the source states is directional and worth repeating: **do not invert it.** Fast delivery over a slow bed, or slow delivery over a fast bed, reads as wrong to viewers who cannot say why.

## When to use it
Before any music search, on every project. Run it again whenever a section's delivery changes materially — a calm explainer that turns into a build, an interview that turns into a montage — because each section gets its own band and its own track.

Use it also as a diagnostic in the opposite direction: when a cut "feels off" and the shot choices are all defensible, measure the narration's words per minute and the bed's BPM and check they are in the same band. The mismatch is usually the answer, and it is cheaper to fix than the picture.

## How to recognise it in a reference video
- **Tap or measure the bed's BPM.** From Epidemic metadata directly, or by counting beats over 30 s and doubling. Watch for **half-time / double-time ambiguity**: a track labelled 75 BPM whose pulse you nod at twice per beat is functionally 150. Judge by where you would nod, not by the metadata.
- **Measure the delivery.** Count words in a clean 60 s stretch of narration. Calm explainer runs **130–150 wpm**, standard YouTube presenter **150–170 wpm**, fast/hype delivery **170–200+ wpm**.
- **Check the pairing.** Derived target `BPM ≈ 0.7 × WPM`, clamped to 60–180. At 160 wpm that gives 112 BPM — which lands inside the creator's stated personal default of **100–120 BPM**, so the heuristic reproduces his own practice.
- **Check the cut grid.** Compute `1800 / BPM` and compare against the sequence's average shot length in frames. In an edit built on the grid, most shot lengths will be near-integer multiples of that number (1, 2, 4 or 8 beats). If shot lengths show no relationship to the beat, the video was not cut to the bed.
- **Listen for band changes at section boundaries.** A well-built video steps bands rather than sliding: intro at 90–110, body at 100–120, montage at 130–150, outro back to 90–110.
- **Signature of an inverted pairing:** narration that keeps arriving "ahead of" or "behind" the music, cuts that feel arbitrary, and a general sense that the video is either dragging or panicking despite competent shots.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Target BPM from delivery | `0.7 × WPM` | clamp 60–180 | Derived heuristic. 160 wpm → 112 BPM. Verify by ear before committing. |
| Creator's default band | 100–120 BPM | — | The stated personal default; a safe starting point for talking-head content. |
| Search tolerance around target | ±6 BPM | ±4 to ±10 | Wider than ±10 and the band's character changes. |
| Frames per beat @30fps | `1800 / BPM` | — | 100 BPM = 18 f; 120 BPM = 15 f; 140 BPM = 12.86 f. |
| Frames per bar (4/4) @30fps | `7200 / BPM` | — | 120 BPM = 60 f = exactly 2 s. |
| Phrase length | 4 bars | 4 or 8 bars | Common-practice phrases are *"often four bars… culminating in a more or less definite cadence"* — the natural place for a section change. |
| Half/double-time check | always | — | 75 and 150 BPM share a pulse family; soul at 75–90 pairs with DnB at 150–185. |
| Max BPM change between adjacent sections | ±25 BPM | ±15–40 | Larger jumps need a hard handover — see [[sfx-beat-aligned-handover]]. |
| Bed level | −22 dB rel. dialogue | −20 to −25 dB | The source's own numbers; loud rock/guitars down to −30 dB. |

### The band table

| BPM | Italian marking | Reads as | Frames/beat @30 | Typical cut cadence | Fits |
|---|---|---|---|---|---|
| 40–66 | Largo / Adagio | grave, spacious, mournful | 27–45 f | every 4 beats (3.6–6.0 s) | emotional narrative, memorial, luxury slow-mo |
| 66–90 | Adagio / lower Andante | calm, reflective, warm | 20–27 f | every 2–4 beats (1.3–3.6 s) | interviews, personal stories, cinematic B-roll |
| 90–108 | Andante | conversational, walking pace | 16.7–20 f | every 2 beats (1.1–1.3 s) | explainers, tutorials, calm talking head |
| 108–120 | Moderato | steady, professional, confident | 15–16.7 f | every 1–2 beats (0.5–1.1 s) | **the default band** for YouTube long-form |
| 120–156 | Allegro | bright, energetic, upbeat | 11.5–15 f | every 1–2 beats (0.4–1.0 s) | product videos, list content, upbeat tutorials |
| 156–176 | Vivace | driving, hype, urgent | 10.2–11.5 f | every 1 beat (0.34–0.38 s) | montages, transformation reveals, sports |
| 168–200 | Presto | frantic, overwhelming | 9–10.7 f | every 1 beat, bursts only | short bursts only — see [[pace-visual-mush-ceiling]] |

Note where the band table collides with the comprehension floor: at 168 BPM one beat is **10.7 frames**, which is below the 12-frame floor for a new simple image and well below the 20-frame floor for an information beat. Above roughly 150 BPM you must cut on **two** beats, not one, for anything the viewer has to read or understand.

## Reproduction prompt

```
Derive the music tempo for a video (or a section of one) and hand the
resulting grid to the search and the cut passes. 30fps throughout.

1. MEASURE DELIVERY. Take a clean 60-second stretch of the narration from
   the word-level transcript and count the words. That is WPM. If the video
   has sections with materially different delivery, do this per section.
2. DERIVE THE TARGET: BPM_target = round(0.7 * WPM), clamped to [60, 180].
   Sanity-check it against the band table: 130-150 wpm -> 90-108 BPM
   (conversational); 150-170 wpm -> 105-120 BPM (steady); 170-200 wpm ->
   120-140 BPM (bright/energetic). If the derived number and the band the
   content obviously belongs to disagree, trust the content and say why.
3. SET THE SEARCH WINDOW: BPM_target +/- 6.
4. COMPUTE THE GRID and record it in the design document, because every
   later pass consumes it:
     frames_per_beat = 1800 / BPM
     frames_per_bar  = 7200 / BPM        (4/4)
     frames_per_phrase = 4 * frames_per_bar
5. CHECK THE FLOOR. If frames_per_beat < 12, cutting on every beat will
   break comprehension. Set the cut cadence to every 2 beats and record that
   as the cadence for this section.
6. CHECK HALF/DOUBLE TIME on any candidate track before accepting its
   metadata: play it and count where you would nod. A 75 BPM track you nod
   to at 150 belongs in the 150 band, not the 75 band.
7. PER-SECTION PASS. Assign each section its own band. Keep adjacent
   sections within 25 BPM of each other; if a larger jump is required, the
   handover needs to be built deliberately, on a beat, with cover.
8. ACCEPTANCE TEST: (a) play the narration over the chosen bed with picture
   muted - the words must land near beats without you trying; (b) confirm no
   section pairs fast delivery with a sub-90 BPM bed or slow delivery with a
   140+ BPM bed; (c) confirm the recorded frames_per_beat matches
   1800 / (the BPM actually delivered by the downloaded file), not the BPM
   you searched for; (d) confirm the cut cadence for every section is at or
   above the 12-frame comprehension floor.
```

## Execution spec

**Epidemic Sound — the BPM filter is the point of this note.** The derived window goes straight into the search:
```
SearchRecordings {
  query.term: "<vibe words from the mood map>",
  filter.bpm     { min: <BPM_target - 6>, max: <BPM_target + 6> },
  filter.vocals  : "instrumental",          // when your own voice is present
  filter.duration{ min: <section length ms> }
}
SearchSimilarToRecording { id: "<the one that worked>" }   // to expand the shortlist
```
Vocals versus instrumental is a separate rule and it is not negotiable when narration is present — see [[sfx-vocal-vs-instrumental-bed]]. `DownloadRecording` writes a local file into `.media/audio/bgm/`; optionally ledger it with `node <SKILL_DIR>/scripts/resolve.mjs --from <file> --type bgm --project .`.

**Verify the delivered BPM, do not trust the search.** Measure the actual file:
```bash
# duration and stream facts
ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 bed.mp3
# find the first strong onset (the downbeat T0) by eye/ear on the waveform:
ffmpeg -i bed.mp3 -filter_complex "showwavespic=s=1920x240" -frames:v 1 bed_wave.png
```
Then beat times are `T0 + n × (60 / BPM)`, and frames-per-beat is `1800 / BPM`. **There is no beat-detection tool in this stack** — `aubio`, `librosa` and equivalents are not part of the contract and are not verified present. `T0` is measured by inspection; record it in the design document once and reuse it everywhere.

**HyperFrames — the grid is authored, not computed at render time.** All authored time is in **seconds**, there is no frame attribute, and there is no beat primitive. Bake the grid into the numbers you write:

```html
<!-- 112 BPM: 60/112 = 0.5357s per beat = 16.07 frames. One bar = 2.143s. -->
<audio id="bed-body" src=".media/audio/bgm/steady_112.mp3"
       data-audio-group="music"
       data-start="8.000"          <!-- T0 of the bed aligned to the section start -->
       data-duration="184.000" data-media-start="0.000"
       data-track-index="11" data-volume="0.6"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```
Then cut on `8.000 + n × 0.5357`. Determinism rules forbid computing this from a clock at render time; if you generate the numbers with a script, the script must run at **authoring** time and write literal values into the markup. A `Date.now()`-driven or `Math.random()`-driven grid is a banned pattern.

**Carve, not duck.** The contract's guidance is unambiguous: *"Carve by default. A bed playing under narration wants a carve."* Put narration clips in `data-audio-group="voiceover"`, carve the bed against the **group** (never a list of clip ids — `audio_carve_ungrouped_sources`), and run `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`. Default `strength` 0.25 = a 6 dB dip in three bands. `data-fx-carve` is **clip-only**; putting it on an `<hf-audio-group>` is `audio_group_carve_attr`.

**Retiming a bed to hit a target BPM.** `data-playback-rate` is a constant in `0.1..5`, render-safe and **pitch-preserved**, so a ±6% nudge is legal: a 118 BPM track at `data-playback-rate="1.0169"` delivers 120. Beyond about ±6% the character of the track changes audibly. **There is no rate envelope** — a tempo *ramp* must be preprocessed into a derived file. And when you retime, the global math applies: *consumed source = timeline duration × rate*.

**Remotion:** the same grid expressed as `fps`-native frame numbers, `framesPerBeat = fps * 60 / bpm`. Not part of this project.

## Pairs with
- [[pace-bpm-matched-music-selection]] — the search workflow this note feeds
- [[pace-cut-on-the-beat]] — placing cuts on the grid this note computes
- [[sfx-vibe-brief]] — the vibe half of the search query
- [[sfx-vocal-vs-instrumental-bed]] — the vocals switch that composes with the BPM filter
- [[sfx-mood-map-per-topic]] — assigning a band per section
- [[sfx-beat-aligned-handover]] — handing over when the band changes
- [[pace-visual-mush-ceiling]] — the floor that caps the top of the band table
- [[pace-cut-density-from-viewer-intent]] — the other input to cut cadence
- [[struct-music-arc-to-narrative-arc]] — the shape the bands are arranged into

## Failure modes
- **Inverting it.** Fast talking over a 70 BPM bed, or a calm explainer over 150 BPM. The source names this specifically and it is the most damaging version of the error, because everything else can be correct and the video still feels wrong.
- **Trusting metadata BPM over the felt pulse.** Half-time and double-time labelling is common. Nod along before you accept a number.
- **Cutting on every beat above 150 BPM.** One beat is under 12 frames there, which is below the comprehension floor for anything new. Cut on two.
- **One BPM for the entire video.** A single tempo across ten minutes flattens the arc; the bands are supposed to step at section boundaries.
- **Chasing a target BPM with a big retime.** Past ±6% the instruments start sounding wrong even though pitch is preserved. Find a different track instead.
- **Deriving the BPM but never measuring T0.** Without the first downbeat, the grid is offset and every "on-beat" cut is early or late by an arbitrary amount. Measure T0 once.
- **Letting the bed run at full level under narration.** The band is chosen for feel, not volume: −20 to −25 dB under dialogue, with a carve.
- **Known gap:** this stack has **no beat detection and no tempo analysis**. BPM comes from library metadata or your own count, and `T0` from inspecting a waveform image. Nothing validates that a cut actually landed on a beat — that check is a listen, per [[sfx-playback-verification-loop]].
