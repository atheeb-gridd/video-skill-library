---
id: sfx-music-cue-sheet-per-segment
title: The per-segment music cue sheet — boundary, mood brief, query, level-matched track
skill: sound-design
type: music
family: music-scoring
tags: [skill/sound-design, type/music, family/music-scoring, sfx/aesthetic, layer/music, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:12:35"
    quote: "Split your video up by topic changes, then decide what mood you want the viewer to be in for each topic."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:12:28"
    quote: "Then, in a section where I'm giving game-changing advice, I'll use a song with an innovative feel that builds a ton of excitement around what I'm saying."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:09"
    quote: "I usually change the music whenever the section changes, and moving from one track to another is a bit tricky."
research_refs:
  - https://en.wikipedia.org/wiki/Film_score
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
  - https://en.wikipedia.org/wiki/Loudness_normalization
  - https://en.wikipedia.org/wiki/EBU_R_128
  - "mcp://Epidemic_sounds/SearchRecordings (filter schema: bpm / moodSlugs / vocals / duration-ms / musicalKeys)"
difficulty: medium
detectable_from: transcript+video
---

# The per-segment music cue sheet — boundary, mood brief, query, level-matched track

## What it is
The artifact that sits between the mood decision and the search box. [[sfx-mood-map-per-topic]] decides *what the viewer should feel* in each topic; this note is the **document that turns each of those rows into a fetchable track and a placed clip**: one row per segment, carrying the boundary timecodes, the mood brief, the four filter values, the resolved Epidemic id, the measured loudness of the region actually used, and the join type into the segment.

Film scoring has done this for a century and the vocabulary is worth borrowing exactly. In a **spotting session** the director and composer *"watch the entire film, noting which scenes require original music"*, and the score is then built as numbered **cues** — *"timed to begin and end at certain moments during the film"* — with notes on *"how long each cue must be, where it begins, where it ends, and of particular moments during a scene that music may need to coincide with."* A YouTube edit is the same job at smaller scale. Numbering the cues (`M1`, `M2`, `M3`…) is not bureaucracy: it is what lets a fetch list, a placement pass and a mix pass all refer to the same thing.

Two things research adds that the transcript does not.

**A cue sheet has holes in it, on purpose.** Not every segment gets a track. The map must mark rest windows explicitly ([[sfx-music-rest-windows]]), because "no music here" is a cue decision, and if it is not written down it never happens.

**Consecutive tracks must be level-matched to each other, not just to the dialogue.** Two Epidemic tracks that both "sit right" in isolation can be 3–4 LU apart, and a section change then reads as a volume jump rather than a mood change. Loudness normalisation exists platform-side precisely because *"the gain is changed to bring the average loudness to a target level"* — but that is applied to your whole programme, not per cue, so intra-video consistency is entirely yours. Measure each cue over **the region you actually use**, not the whole file, and land every bed within **±1 LU** of the others.

## When to use it
- Any video over ~90 seconds with more than one topic. Below that, one track is correct and this note is overhead.
- Whenever the design document already has a structure pass (`design-cuts.md` section boundaries) — the cue sheet is built directly off those boundary timecodes, never off a fresh listen.
- Whenever a video has been scored track-by-track and *feels* lumpy: the usual cause is missing rows (unplanned rests) or unmatched loudness between cues, both of which this document exposes.
- Skip it for a single-mood piece, a montage scored to one track, or anything under a minute.

## How to recognise it in a reference video
- **Track changes land on structural boundaries, not arbitrary times.** Log every music change; compare to the transcript's topic changes. A per-segment score has ≥80 % of its music changes within 1 s of a topic boundary.
- **Count the cues.** 3–6 distinct tracks in a 10-minute video is a scored edit. One track looped is not. Twelve is churn.
- **Measure the joins.** At each change, check whether the two beds overlap. Overlap ≥0.8 s with both audible = crossfade. Zero overlap with a clean level step on a beat = hard change. A gap of ≥0.5 s of no music = rest window.
- **Measure levels across cues.** Short-term loudness (3 s window) of each bed during a no-speech moment. Spread greater than ~2 LU across cues means the cues were never matched; under 1 LU means they were.
- **Mood contrast is audible at the boundary.** Instrumentation or mode changes at the change, not just the melody. A change from one 110 BPM corporate piano bed to another 110 BPM corporate piano bed is a track change with no cue decision behind it.
- **Transcript tell:** the line immediately after a music change is usually a topic sentence ("So the second thing is…"). If music changes mid-argument, the score is not following structure.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Cues per 10 min | 4 | 3–6 | Under 3 reads monotonous; over 6 reads restless. |
| Minimum cue length | 45 s | 25–120 s | Below ~25 s the viewer registers a track change as an error. |
| Cue-to-cue loudness match | ±1 LU | ±0.5 to ±2 LU | 1 dB is the loudness JND — beyond 2 LU the change is heard as a fader move. |
| Bed level under dialogue | −20 dB | −18 to −25 dB | Per the source's own numbers; loud-guitar material to −30 ([[sfx-loud-guitar-minus-30]]). |
| Crossfade at a boundary | 1.2 s | 0.8–2.0 s | Equal-power. Only when tempos are within ±5 BPM and keys are compatible. |
| Hard change | on the boundary frame | ±2 frames | Outgoing fades 0.3–0.5 s under a covering transition sound. |
| Rest window at a boundary | 0.8 s | 0.4–2.0 s | The default join when tempo or key do not match. |
| Warm-up skip (`data-media-start`) | 4 s | 0–12 s | Start on the track's first main beat, not the file head. |
| BPM window per cue | ±10 BPM | ±5 to ±20 | Derived from that segment's speech rate ([[sfx-bpm-filter-first]]). |
| Vocals | `false` | — | Under narration always false ([[sfx-vocal-vs-instrumental-bed]]). |

## Reproduction prompt
```
Build the music cue sheet for this video, then place it.

1. SEGMENT. Read the transcript with timecodes. Mark every topic change. Emit rows
   M1..Mn with {cue_id, in_tc, out_tc, topic, target_mood, target_arousal(1-5)}.
   Adjacent cues must differ in arousal by at least 1; if two neighbours want the
   same mood, merge them into one cue.
2. BRIEF EACH CUE. For each row add: bpm_window (from that segment's words-per-minute:
   <130wpm -> 70-95; 130-170 -> 95-115; 170-200 -> 110-130; >200 -> 125-150, width +/-10),
   mood_slugs (2 max), instrument_slugs (1-2), vocals=false, min_duration_ms = cue length.
3. FETCH. Per row call Epidemic SearchRecordings with filter {bpm:{min,max},
   moodSlugs:{matchType:"ANY",values:[...]}, vocals:false, duration:{min:<ms>}}.
   Audition 5 via audioFile.lqmp3Url. Record recording.id and bpm in the row.
4. LEVEL-MATCH. For each chosen file measure short-term loudness over the used
   region only. Compute per-cue gain so every bed lands within +/-1 LU of cue M1,
   then apply the global bed offset that puts music {{MUSIC_DB}} dB (default -20)
   under the normalised dialogue.
5. JOIN. For each boundary choose: CROSSFADE (1.2 s equal-power) only if
   |bpm_a - bpm_b| <= 5 and keys are compatible; HARD CHANGE on the boundary frame
   with the new track's first main beat on that frame; or REST (0.8 s of no music).
   Default to REST when unsure. Mark at least one boundary in the video as a rest.
6. PLACE. One <audio> per cue, data-audio-group="music", data-media-start = warm-up
   skip so the first main beat lands on {{IN}}, per-cue data-volume from step 4,
   a volume automation lane for the join fades. Crossfading pairs go on DIFFERENT
   data-track-index values (11 and 12).

ACCEPTANCE: every topic boundary has an explicit join decision; no cue shorter than
25 s; measured short-term loudness spread across cues <= 1 LU; at least one rest
window exists; no two adjacent cues share the same mood slug set.
```

## Execution spec

**Epidemic Sound.** One `SearchRecordings` call per cue — the filters are the cue brief, literally:

```jsonc
{ "filter": {
    "bpm":       { "min": 100, "max": 120 },
    "moodSlugs": { "matchType": "ANY", "values": ["hopeful", "epic"] },
    "featuredInstrumentSlugs": { "matchType": "ANY", "values": ["synth", "piano"] },
    "vocals": false,
    "duration": { "min": 95000 }          // MILLISECONDS — cue length + 20 %
} }
```

Per-cue slug picks come from [[sfx-emotion-music-lookup-table]]; `mood` is a distinct taxonomy dimension from genre ([[sfx-mood-vibe-filter]]). Audition on `audioFile.lqmp3Url` before downloading. For a boundary you want to *crossfade*, generate the second candidate with `SearchSimilarToRecording` seeded on the first — but re-apply the BPM filter over the result set, because similarity matches vibe and not tempo ([[sfx-find-similar-track-handover]]). `audioFile.waveformUrl` gives a peak array, which is how you find the first main beat for `data-media-start` without opening an editor. Keep `recording.id` in the cue row; it is the only reliable way to re-fetch.

**ffmpeg.** Measure each cue's used region, not the file:

```bash
ffmpeg -ss 4 -t 95 -i cue-M2.mp3 -af loudnorm=I=-23:TP=-1.5:LRA=11:print_format=json -f null -
```

Read `input_i` per cue; the per-cue trim gain is `target_i - input_i`, converted to a HyperFrames linear value with `10^(dB/20)`. Do **not** loudnorm the music files themselves — normalising each bed to the same integrated target flattens intentional dynamics; take the measurement and apply it as gain.

**HyperFrames.** One `<audio>` per cue at the root (audio lives at the root so it survives scene cuts), each with an `id`, `data-audio-group="music"`, a high `data-track-index`, and `data-media-start` to skip the warm-up:

```html
<audio id="cue-m1" src="assets/bgm/m1.mp3" data-audio-group="music"
       data-start="0" data-duration="94" data-media-start="4.2"
       data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
<audio id="cue-m2" src="assets/bgm/m2.mp3" data-audio-group="music"
       data-start="cue-m1 - 1.2" data-duration="120" data-media-start="6.0"
       data-track-index="12" data-volume="0.071"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.2,&quot;v&quot;:1}]}]}"></audio>
```

Contract facts this arrangement depends on: relative timing needs **spaces around the operator** (`cue-m1 - 1.2`, never `cue-m1-1.2`) and an unresolved reference silently becomes `0`; two overlapping `<audio>` sharing a `data-track-index` raise `duplicate_audio_track`, so crossfading cues go on 11 and 12; an automation lane **holds its first value backwards to the clip start**, so the incoming cue needs the explicit `{"t":0,"v":0}` point shown; `data-volume` is linear (0.079 ≈ −22 dB), max `3.98`; and a `volume` lane plus a GSAP `volume` tween on one clip is `audio_volume_double_automation` — the lane wins. Carve each bed against the `voiceover` group rather than ducking it, then run `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`.

**Remotion.** Conceptually the same sheet: one `<Audio>` per cue with `startFrom`, volumes computed per cue, joins expressed as `interpolate` ramps. Frame positions come from `boundary_seconds × fps`.

## Pairs with
[[sfx-mood-map-per-topic]] · [[sfx-track-change-at-section-boundary]] · [[sfx-bpm-filter-first]] · [[sfx-mood-vibe-filter]] · [[sfx-emotion-music-lookup-table]] · [[sfx-music-rest-windows]] · [[sfx-find-similar-track-handover]] · [[sfx-music-hard-stop]] · [[sfx-layer-volume-targets]] · [[sfx-translation-check-devices]] · [[struct-music-arc-to-narrative-arc]]

## Failure modes
- **A cue sheet with no rests.** Music under every second of a ten-minute video defeats the purpose of changing it; the changes stop being felt. Mark rests as rows.
- **Changing track without changing mood.** Two different tracks in the same mood, tempo and instrumentation is churn the viewer notices and cannot interpret. If the mood is the same, keep the track.
- **Matching cues by fader, not by meter.** "Sounds about right" gets you 3 LU apart. Measure short-term loudness in a no-speech moment of each cue.
- **Crossfading tracks with different tempos.** Two conflicting grids for 1.2 s reads as a mistake, not a transition. Different tempo means hard change or rest.
- **Starting each cue at the file head.** Nearly every library track opens with 1–12 s of atmosphere; starting at 0 gives a new section an ambiguous swell instead of a downbeat. Use `data-media-start`.
- **Cue rows without `recording.id`.** A filename is not a handle. Without the id you cannot re-fetch, cannot run Find Similar, and cannot reproduce the video.
- **Known gap:** nothing in the stack validates that a cue's audio actually starts on a beat — no beat detection is available in HyperFrames, and lint reads `data-automation` for only two conflicts. Verify by rendering a snapshot of the section and listening.
