---
id: pace-bpm-matched-music-selection
title: Filter the library by BPM before you audition anything
skill: editing
type: pacing
family: music-sync
tags: [skill/editing, type/pacing, family/music-sync, engine/epidemic, engine/hyperframes, source/editing-kt-3, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:33
    quote: "and there I can search for music by BPM."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:39
    quote: "You apply the filter here and boom — music that will fit my video has arrived."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:18
    quote: "The higher the BPM, the faster and more energetic your music feels. So if you're talking fast in the video, a high BPM will feel good; and if you're talking slowly, low BPM music will suit it better."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:05:10
    quote: "Here you can search music by speed, emotion, instrument. And if you like a track, there's a \"find similar\" option to get more music like it."
research_refs:
  - https://www.toolsforfilm.com/blog/bpm-and-picture-editors-guide
  - https://www.epidemicsound.com/tools/customize/
  - https://increditors.com/video-pacing-youtube-retention-science/
difficulty: low
detectable_from: audio
---

# Filter the library by BPM before you audition anything

## What it is
A selection workflow that inverts the usual order: instead of scrolling a library and listening for something that feels right, you compute the required BPM from the edit's own numbers, set the BPM filter, and only then listen. The filter does the elimination; your ears only pick a winner from a pre-qualified set. Two other filters compose with it — **instrument** and **vibe/mood** (the creator's three parameters are BPM, instruments, vibe) — plus the vocals/instrumental switch. The alias in the second source is "search music by speed, emotion, instrument", with **find similar** to expand from one good hit.

This note also owns the arithmetic that makes BPM an *editing* parameter rather than a taste parameter: at 30fps, **frames per beat = 1800 ÷ BPM**.

## When to use it
Every time a bed is needed, before any auditioning. It is also the fix when an edit "feels off" for no locatable reason: an inverted BPM-to-delivery relationship (slow talking over a fast bed, or the reverse) produces exactly that diffuse wrongness, and the source is emphatic that inverting it makes the video feel very odd. Run it per **section**, not per video — a video whose sections differ in energy needs a BPM per section, and find-similar is the tool for keeping the change smooth.

## How to recognise it in a reference video
- **Measure the bed's BPM**, do not guess it. Isolate the music-only stretch (an intro, an outro, a demonstration window with no narration) and analyse the low band:
  `ffmpeg -ss <t> -t 20 -i ref.mp4 -af "lowpass=f=200" -f wav - | <beat estimator>`
  Failing a tool, count kicks over 20 seconds and multiply by 3.
- **Measure delivery WPM** from the word-level transcript over the same section.
- **The signature is the ratio.** Plot BPM against WPM per section. A deliberate edit shows a positive relationship; roughly, BPM ≈ 0.65 × WPM ± 15 in this creator's register (165 WPM → ~107 BPM, inside his stated 100–120 default). A flat BPM across wildly varying WPM means one track was dropped over everything.
- **Check the frames-per-beat arithmetic.** If the bed's BPM is 100 or 120 and the output is 30fps, frames per beat is exactly 18 or 15 — integers. Beat-locked cuts in that video will land on exact frames with no drift. A BPM like 110 (16.36 f/beat) plus perfectly locked cuts means the editor was snapping to markers, not counting.
- **Vocals test.** Is there singing under the narrator's voice? Sustained vocal music under narration is either a deliberate montage (narration absent) or an error.
- **Section changes.** Log where the track changes and whether the new track's BPM is within ±8 of the old one (find-similar behaviour) or clearly different (deliberate reset, usually with a riser bridge).
- **Level.** Music sitting around −22 to −25 dB relative to a 0 to −3 dB dialogue is the creator's stated mix; a bed at −12 dB is a different (louder, more montage-like) style.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `target_bpm` | 110 | 60–160 | Creator's personal default band is 100–120 because he speaks slightly fast. |
| `bpm_filter_window` | ±10 | ±5 to ±20 | What you set as `filter.bpm {min,max}`. Narrower than ±5 usually returns too few hits. |
| `bpm_from_wpm` | `0.65 × WPM` | 0.55–0.75 × WPM | Derivation rule. 140 WPM → ~91 BPM; 165 → ~107; 190 → ~124. |
| `preferred_bpm_30fps` | 100 or 120 | 90, 100, 120, 150 | These give integer frames per beat at 30fps (20, 18, 15, 12) — zero drift when cutting to beat. |
| `frames_per_beat` | 1800 ÷ BPM | — | At 30fps. At 24fps it is 1440 ÷ BPM; at 60fps, 3600 ÷ BPM. |
| `bar_frames` | 4 × frames_per_beat | — | 100 BPM → 72f (2.4s); 120 BPM → 60f (2.0s). |
| `vocals` | `false` | false when narration present · true only where the narrator is absent | Vocal music under your own voice conflicts; over a montage it lands harder. |
| `mood_slugs` | derived from the section's emotion | — | Epidemic `filter.moodSlugs`, e.g. `hopeful`, `tense`, `mysterious`, `epic`. |
| `instrument_slugs` | beat-forward | — | `filter.featuredInstrumentSlugs`. Percussive, beat-led tracks sit best under a voice; strings/violin for suspense and tension. |
| `music_level` | 0.079 (≈−22 dB) | 0.056–0.100 (−25 to −20 dB); 0.032 (−30 dB) for loud rock/guitars | Linear `data-volume`. Dialogue sits 0 to −3 dB (1.0–0.71). |
| `similarity_bpm_window` | ±8 | ±0 to ±15 | For a find-similar track change at a section boundary. |

## Reproduction prompt

```
Select the music bed for section {{SECTION}} by filtering first.

1. Compute the inputs. From the word-level transcript for this section,
   compute delivery WPM = words / (section seconds / 60). From the cut plan,
   note the target median shot length in frames.
2. Derive target_bpm = round(0.65 * WPM). Then snap it to the nearest value
   that gives an integer frames-per-beat at the output fps: at 30fps prefer
   90, 100, 120 or 150 BPM (20, 18, 15, 12 frames per beat). Record both the
   raw and snapped values.
3. Search the library with the filter applied BEFORE listening:
   bpm min = target_bpm - 10, max = target_bpm + 10;
   vocals = false if this section has narration, true only if it does not;
   mood = the section's emotion in one word; instruments = beat-forward
   unless the emotion calls for strings.
4. Audition ONLY the returned set, and audition against the picture, not in
   isolation. Reject anything whose intro warm-up exceeds 4 seconds unless
   you intend to trim past it.
5. Pick one. Record its id, its reported BPM and its duration in the design
   doc. Then run a similarity lookup on it and record the top 3 ids as
   fallbacks and as candidates for the NEXT section's track.
6. Place it at -22 dB (linear 0.079) and carve it against the voiceover
   group rather than ducking it flat.
7. ACCEPTANCE TEST: play the section at full speed once. The bed's pulse and
   the speech must feel like the same tempo - if you notice the music as
   faster or slower than the talking, the BPM is inverted and the fix is a
   different track, not a level change. Confirm frames_per_beat =
   1800/reported BPM is within 0.5 frames of an integer, or accept that
   beat-locked cutting will drift and switch to bar-level cutting instead.
```

## Execution spec

**Epidemic Sound (the filter is a real API field).** `SearchRecordings` exposes exactly the creator's three parameters:
```
SearchRecordings {
  query: { topic: "focused build documentary" },
  filter: {
    bpm: { min: 100, max: 120 },
    vocals: false,
    moodSlugs:              { matchType: ANY, values: ["hopeful","determined"] },
    featuredInstrumentSlugs:{ matchType: ANY, values: ["electronic-drums","piano"] },
    duration:               { min: 90000, max: 300000 }
  },
  sort: { by: RELEVANCE, order: DESCENDING },
  first: 25
}
```
Every hit returns `recording.bpm` (an `Int`), `audioFile.durationInMilliseconds`, `audioFile.waveformUrl` and the four stems — record the BPM, the timeline needs it. `sort: { by: BPM, order: ASCENDING }` gives a deterministic, repeatable ordering, which is how you make a "saved search" reproducible in a scripted pipeline. Find-similar is `SearchSimilarToRecording { id, first: 5 }` (also reachable as `recording.similarRecordings`). Fetch with `DownloadRecording`, and use `EditRecording` when the track must be re-cut to fit — see [[struct-music-arc-to-narrative-arc]] for the section-pinning form.

Epidemic's web UI and its Premiere/DaVinci plugins expose the same three axes plus Segments and Stems; the MCP path above is the scriptable equivalent and should be preferred in this project, since `media-use`'s own `resolve --type bgm` is a network path that is not sanctioned here.

**HyperFrames (placement).** The bed is a clip like any other; convention is one bed per section, audio at the host root in a modular project so playback survives scene cuts:
```html
<audio id="bed-s3" src=".media/audio/bgm/bed-s3.wav"
       data-audio-group="music"
       data-start="126.0" data-duration="74.0" data-media-start="2.4"
       data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```
`data-media-start="2.4"` trims the warm-up without touching the file. `data-volume` maxes at `3.98` (+12 dB); dB→linear is `10^(dB/20)`, so −22 dB = 0.079, −25 dB = 0.056, −30 dB = 0.032, −3 dB = 0.71. Then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`, which needs `ffmpeg` on PATH and `@hyperframes/core` in the project. Carve by default under narration — a flat duck costs the bed all of its presence, and the whole point of choosing a beat-forward track is that its beat stays audible.

Do not change tempo with `data-playback-rate` to hit a BPM: rate is a constant in `0.1..5`, pitch-preserved for sound, but a 10% rate change on music is audible as a pitch/feel shift even when the pitch is nominally preserved. Pick a different track.

**ffmpeg (measurement).** BPM estimation is not in this stack; measure by low-band transient counting or read the value the library reports. Loudness for the final mix is two-pass `loudnorm` at `I=-14:TP=-1.5:LRA=11` for socials.

**Remotion:** identical selection logic; no runtime here.

## Pairs with
[[pace-cut-on-the-beat]] · [[struct-music-arc-to-narrative-arc]] · [[pace-cut-density-from-viewer-intent]] · [[pace-silent-demonstration-window]] · [[sfx-music-audition-against-picture]] · [[pace-speech-rate-to-bpm-map]] · [[pace-beat-grid-extraction]]

## Failure modes
- **Auditioning before filtering.** Burns an hour and still lands on a track that fights the delivery, because your ears are judging the track and not the pairing. Fix: set `filter.bpm` first, always.
- **Inverting the relationship.** Slow delivery under a 140 BPM bed (or fast delivery under 70) is the specific failure the source names, and it reads as "something is wrong" rather than "the music is wrong". Fix: derive BPM from measured WPM; do not eyeball energy.
- **Vocal music under narration.** Two voices compete and both lose. Fix: `filter.vocals: false` wherever the narrator speaks; keep vocal tracks for narration-free montages.
- **One bed for the whole video.** Removes the section structure the bed could have been marking. Fix: one bed per section, find-similar for continuity, riser bridge when the vibe genuinely changes.
- **Choosing a BPM with a non-integer frames-per-beat and then cutting to the beat.** At 11.25 or 16.36 frames per beat, rounding accumulates; over 64 beats the drift can exceed half a second. Fix: snap to 90/100/120/150 at 30fps, or cut at bar level and place cuts from a generated timecode list rather than by counting.
- **Fixing a wrong track with the fader.** A bed at the wrong tempo does not become right at −30 dB, it becomes an inaudible wrong bed. Fix: replace the track.
