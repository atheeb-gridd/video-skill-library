---
id: sfx-emotion-and-pace-diagnosis
title: Diagnose the cut's emotion and pace before the library is opened
skill: sound-design
type: music
family: music-search
tags: [skill/sound-design, type/music, family/music-search, layer/music, engine/epidemic, engine/ffmpeg, engine/hyperframes, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:00:54
    quote: "For that, the first thing you need to understand is what your video's emotion and pace are like."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:00:57
    quote: "Which music goes with which emotion — here's a list for that."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:00
    quote: "Now if you just hunt for music randomly, you'll waste a ton of time."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:18
    quote: "The higher the BPM, the faster and more energetic your music feels. So if you're talking fast in the video, a high BPM will feel good; and if you're talking slowly, low BPM music will suit it better."
research_refs:
  - https://en.wikipedia.org/wiki/Words_per_minute
  - https://librosa.org/doc/latest/generated/librosa.beat.beat_track.html
  - https://www.epidemicsound.com/music/search/
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: transcript+video
---

# Diagnose the cut's emotion and pace before the library is opened

## What it is
Music selection begins with a measurement of the edit, not with a search box. The creator's sequence is explicit: understand the video's emotion and pace **first**, then apply BPM, instrument and mood filters. Searching before that diagnosis is what produces the failure he demonstrates — downloading a track, dropping it under the video, finding it does not fit, and starting the hunt again.

The diagnosis is machine-checkable. Pace is two numbers you already have: the narration's words per minute, from the word-level transcript, and the picture's cut rate, from scene detection. Emotion is a decision the editor makes and then writes down as library vocabulary, not a feeling to be discovered later. The output of this note is a small artefact — a music brief — that the three filter notes ([[sfx-bpm-filter-first]], [[sfx-instrument-filter-search]], [[sfx-mood-vibe-filter]]) consume directly.

## When to use it
- **Once per section, before any track is auditioned.** Sections with different pace get different briefs; a single brief for a whole video is the reason the music stops fitting halfway through ([[sfx-track-change-at-section-boundary]]).
- **On the rough cut, not the fine cut.** The rough cut's pace is close enough, and choosing music late means re-cutting to the track instead of cutting to the content.
- **Whenever a chosen track "just isn't working" and nobody can say why.** Nine times out of ten the diagnosis was skipped and the mismatch is BPM against speech rate, which is measurable in thirty seconds.
- **Before commissioning a change.** "Find something more energetic" is unactionable; "we need 125–135 BPM instead of 95" is a filter.
- **Not for a section with no bed.** Rest windows are planned, not searched ([[sfx-music-rest-windows]]).

## How to recognise it in a reference video
This section doubles as the measurement procedure — the same numbers describe a reference and specify your own edit.

- **Speech rate (WPM).** From the word-level transcript, count words in speaking windows only and divide by speaking minutes; do not include silence, or a pausy delivery scores as slow when it is merely spaced. Reference anchors: comfortable presentation delivery is **100–125 wpm**, audiobook narration **150–160 wpm**, fast creator delivery **170–200 wpm**, auctioneer **~250 wpm**.
- **Average shot length (ASL) and cut rate.** `ASL = runtime ÷ cuts`; `cut_rate = cuts ÷ minutes`. `scenedetect -i ref.mp4 detect-adaptive list-scenes` gives the cut list.
- **The reference's own BPM.** Extract it rather than guessing:
  ```python
  import librosa
  y, sr = librosa.load("ref_music.wav")
  tempo, beats = librosa.beat.beat_track(y=y, sr=sr)      # tempo in BPM
  times = librosa.frames_to_time(beats, sr=sr)            # beat grid, seconds
  ```
- **Report the triple.** `{wpm, asl, bpm}` is the finding. It is what makes references comparable and what a design document can act on.
- **Emotion, as library vocabulary.** Do not log "hopeful-ish". Log the mood slugs the library actually indexes — verified live ones include `epic`, `hopeful`, `mysterious`, `suspense`, `dark`, `happy`, `smooth`, `dreamy`, `laid-back`, `floating`. If a reference's music carries a mood you cannot name in that vocabulary, search for a track that sounds like it and read its tags back.
- **Vocals present or not.** A reference with vocal music under narration is either a mixing failure or has no narration in that section — check before copying it ([[sfx-beat-forward-bed-under-voice]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `wpm` measurement window | speaking time only | — | Exclude gaps > 0.5 s, or pauses distort the rate. |
| WPM → BPM band | see below | — | The creator's own default is 100–120 BPM because he talks fast. |
| — under 110 wpm | 60–90 BPM | ±10 | Reflective, interview, luxury. |
| — 110–140 wpm | 90–110 BPM | ±10 | Standard explainer. |
| — 140–170 wpm | 100–125 BPM | ±10 | Fast creator delivery; the house default. |
| — over 170 wpm | 120–140 BPM | ±10 | Hype, montage, short-form. |
| ASL → energy band | — | — | > 6 s calm · 3–6 s standard · 1.5–3 s energetic · < 1.5 s hype. |
| BPM tolerance in the query | ±10 | ±5 … ±15 | Narrower than ±5 returns too few tracks to choose from. |
| Mood slugs per brief | 2 | 1–3 | More than three with `ANY` widens to noise; use `ALL` only for a very specific pair. |
| `vocals` | `false` when narration exists | true/false | Vocal tracks only where your own voice is absent. |
| Brief scope | one per section | — | A section is a structural unit, typically 30–120 s. |
| Healthy result count | 30–300 | 10–500 | Over 2000 = under-filtered; under 10 = over-filtered. Relax mood first, never BPM. |

## Reproduction prompt
```
Produce a music brief for each section of this edit BEFORE searching for any track.

1. MEASURE PACE.
   a. From transcript.json, compute words-per-minute over speaking windows only
      (exclude inter-word gaps longer than 0.5 s). Report per section.
   b. Run scene detection on the rough cut; compute average shot length and cuts
      per minute per section.
2. MAP TO A BPM BAND using the speech rate, not the cut rate:
   <110 wpm -> 60-90 | 110-140 -> 90-110 | 140-170 -> 100-125 | >170 -> 120-140.
   Then adjust by at most one band toward the ASL energy band if the two disagree
   (ASL >6 s pulls down, <1.5 s pulls up). Never invert the mapping - fast speech
   over slow music, or the reverse, is the failure the source calls out by name.
3. DECIDE EMOTION AS VOCABULARY. For each section, choose 1-3 mood slugs from the
   library's own list (e.g. epic, hopeful, mysterious, suspense, dark, happy,
   smooth, dreamy, laid-back, floating). This is a decision, not an observation:
   the editor sets the vibe. Write one clause saying what the section must make
   the viewer feel, then the slugs that encode it.
4. DECIDE VOCALS. If the section has narration or dialogue, vocals=false. Only a
   section with no voice of your own may use a vocal track.
5. EMIT the brief as JSON, one object per section:
   { "section": "<name>", "start": <s>, "end": <s>, "wpm": <n>, "asl": <s>,
     "bpm": {"min": <n>, "max": <n>}, "moods": ["<slug>", ...],
     "vocals": false, "instruments": ["<slug>", ...] }
   Save it to the project as music-brief.json (append a new file for a revision;
   do not rely on deleting the old one).
6. ACCEPTANCE TEST: every section has a brief; no brief has an empty moods array;
   the BPM window is at least 20 BPM wide; and running the brief as a query
   returns between 10 and 500 results. If it returns thousands, add a mood or an
   instrument. If it returns none, widen mood before touching BPM.
```

## Execution spec

**Epidemic Sound.** The brief is designed to compile straight into one `SearchRecordings` call — all three axes at once, which is the whole point of diagnosing first.
```json
{ "query": { "term": "" },
  "filter": {
    "bpm": { "min": 100, "max": 120 },
    "moodSlugs": { "matchType": "ANY", "values": ["hopeful", "epic"] },
    "vocals": false,
    "featuredInstrumentSlugs": { "matchType": "ANY", "values": ["acoustic-guitar"] }
  },
  "sort": { "by": "POPULARITY", "order": "DESCENDING" }, "first": 20 }
```
`recording.bpm` comes back as an exact integer on every result, so the brief can be verified against what was actually chosen, and the same number seeds the beat grid in [[sfx-cut-on-the-beat]]. Read `meta.total` as the health check for the brief itself: a verified quirk is that an unrecognised mood slug returns `total: 0` rather than being ignored, so zero results means a bad slug, not an empty catalogue.

**ffmpeg / analysis.** WPM comes from `transcript.json` (`npx hyperframes transcribe`, word-level `{text,start,end}`); cuts come from `scenedetect`; BPM of a reference comes from `librosa.beat.beat_track`. None of these is browser-dependent, so all three run on the authoring VM.

**Hyperframes.** The brief itself is a plan artefact, not composition markup. Record the chosen numbers in `STORYBOARD.md` frontmatter/per-frame bullets (`- music: 112 bpm, hopeful, no vocals`) so the next pass can re-derive the choice; the parser preserves unknown keys and never throws. The bed is then placed at the root with `data-audio-group="music"` and carved against the voiceover group ([[sfx-dialogue-gate]], [[sfx-layer-volume-targets]]).

**Remotion.** No equivalent; the brief is upstream of any renderer.

## Pairs with
[[sfx-bpm-filter-first]] · [[sfx-instrument-filter-search]] · [[sfx-mood-vibe-filter]] · [[sfx-music-audition-against-picture]] · [[sfx-beat-forward-bed-under-voice]] · [[sfx-track-change-at-section-boundary]] · [[sfx-music-rest-windows]] · [[sfx-cut-on-the-beat]] · [[pace-speech-rate-to-bpm-map]] · [[pace-bpm-matched-music-selection]] · [[sfx-emotion-music-lookup-table]] · [[pace-rough-cut-diagnostic]]

## Failure modes
- **Searching first.** The audition-and-reject loop the source demonstrates costs more time than the whole diagnosis. If a track is being auditioned before a brief exists, stop and measure.
- **Deriving BPM from cut rate instead of speech rate.** A fast-cut montage over slow narration wants the narration's tempo; the cuts are an editing choice and can be re-timed, the delivery cannot.
- **Inverting the mapping.** Slow speech over fast music, or fast speech over slow music, is the specific error named in the source: *"the video will feel really odd."*
- **Logging emotion in prose.** "Warm but slightly melancholy" cannot be queried. Convert to slugs at diagnosis time or the brief is unusable.
- **One brief for the whole video.** Section boundaries are exactly where pace changes; a single brief guarantees a mismatch in at least one section.
- **Counting words including long pauses.** Under-reports WPM and lands you a band too slow.
- **Known gap:** nothing in the stack validates a brief against the finished mix. The only real check is auditioning against the actual cut ([[sfx-music-audition-against-picture]]), which needs a preview or render on a browser-capable host.
