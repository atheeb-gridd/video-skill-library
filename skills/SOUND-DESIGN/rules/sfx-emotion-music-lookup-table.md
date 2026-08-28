---
id: sfx-emotion-music-lookup-table
aliases: [sfx-emotion-to-music-table]
title: The standing emotion-to-music table — the filter values, and the motion energy each row dictates
skill: sound-design
type: music
family: music-selection
tags: [skill/sound-design, type/music, family/music-selection, layer/music, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:54"
    quote: "For that, the first thing you need to understand is what your video's emotion and pace are like."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:00:57
    quote: "Which music goes with which emotion — here's a list for that. (on-screen list)"
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:05
    quote: "Instead, you should focus on these three parameters: BPM, instruments and vibe."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:18"
    quote: "The higher the BPM, the faster and more energetic your music feels. So if you're talking fast in the video, a high BPM will feel good; and if you're talking slowly, low BPM music will suit it better."
research_refs:
  - https://en.wikipedia.org/wiki/Music_and_emotion
  - https://en.wikipedia.org/wiki/Tempo
  - https://en.wikipedia.org/wiki/Drop_(music)
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://www.epidemicsound.com/music/moods/
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchRecordings (every mood slug below probed live with matchType ALL, 2026-08-28)
difficulty: medium
detectable_from: transcript+video
---

# The standing emotion-to-music table — the filter values, and the motion energy each row dictates

## What it is
The creator does not decide the music emotion fresh each time; he works from a **standing list** of which music goes on which emotion, and puts that list on screen as a graphic. This note is that list, made executable: a fixed lookup keyed on the section's target emotion, returning everything downstream needs — a **verified mood slug**, a **BPM band**, an **instrument or genre hint**, a **vocals decision**, and the **motion energy band and transition tier that must match the row you picked**.

The value is not that the mappings are subtle — it is that they are *fixed*. Deciding "what music goes on determination" from scratch every project produces a different answer every project, and the videos stop sounding like one creator. A standing table is what makes a sonic identity reproducible, and it is the single input the search workflow ([[sfx-bpm-filter-first]], [[sfx-mood-vibe-filter]], [[sfx-instrument-filter-search]]) consumes.

**The motion columns are why this is more than a search helper.** Tempo is the shared clock. A 145 BPM chase bed under 0.8 s luxury eases is the same mistake as a slow-talking presenter over high-BPM music, and it is exactly as noticeable. Picking the music row picks the motion register; if the design document says "urgent" in the music column and "calm" in the motion column, one of them is wrong.

Underneath, the table is a two-axis map — **valence** (negative↔positive) crossed with **arousal** (calm↔energised) — because that is how musical features actually behave, and the structural cues are documented rather than invented: fast tempo raises both arousal and valence; louder raises arousal; major mode reads positive and minor negative (a finding stable since 1935, and identifiable by children as young as three); legato reads cohesive, calm, sad or scary while staccato reads tense, energetic, amusing and surprising; and greater pitch variation raises arousal. Every row below is one of those four quadrants with a library slug attached.

## When to use it
- **Before opening the library at all.** Read the section's emotion and pace from the cut ([[sfx-emotion-and-pace-diagnosis]]), look the row up, and enter the search with filters already decided. Scrolling a music catalogue without filters is the single biggest time sink in the whole sound pass.
- **Once per section**, at the point where the video has been split by topic and each segment has been given a target mood ([[sfx-mood-map-per-topic]]) — this note is the resolver that turns that mood word into a search and a set of numbers.
- **At every section boundary** where the track changes ([[sfx-track-change-at-section-boundary]]). Each section gets a row.
- **As a consistency gate before rendering**: read the design document's music column and motion column side by side and check they name the same energy.
- **When building a profile from a reference video** — log which row each of the reference's tracks belongs to; the resulting distribution *is* the creator's musical identity.
- **When two people are choosing music for the same channel.** The table is the shared vocabulary.
- **Not as a substitute for auditioning against picture.** The table narrows 50,000 tracks to ~2,000; the ear picks one ([[sfx-music-audition-against-picture]]). A track that scores perfectly on all four filters and lands its chorus in the middle of your best line is still the wrong track.
- **Not to pick a track by vibe alone.** The three search parameters are BPM, instruments and vibe, in that order, and BPM must also match the presenter's delivery rate ([[pace-speech-rate-to-bpm-map]], [[pace-bpm-matched-music-selection]]).
- **Not for the narration-free montage without checking the vocals column** — that decision has its own rule ([[sfx-vocal-vs-instrumental-bed]]).

## How to recognise it in a reference video
- **Segment the video by track**, then classify each segment's music independently of its picture.
- **Estimate the bed's BPM** by tapping to the render or by autocorrelating the music-only stretches (the intro and any narration gap):
  ```bash
  # per-track tempo estimate; librosa is optional in this environment - see Execution spec
  python3 -c "import librosa,sys; y,sr=librosa.load(sys.argv[1]); \
    t,_=librosa.beat.beat_track(y=y,sr=sr); print(round(float(t)))" seg.wav
  ```
- **Measure BPM against speech rate.** Count the words in the narration over the same segment and divide by its length. The creator's rule is directional and hard: fast talking → high BPM, slow talking → low BPM, **never inverted**. Matched pairs sit in a band — roughly 130–150 wpm against 100–120 BPM in the creator's own default. A segment where speech runs ~180 wpm over a 75 BPM bed is a diagnosable defect, not a style ([[pace-speech-rate-to-bpm-map]]).
- **Mode by ear on the sustained chords:** minor third above the root = negative-valence rows; major third = positive. This is the most reliable single cue and it separates the top half of the table from the bottom.
- **Instrument census per segment** — name the two most prominent instruments. Those two are what the `featuredInstrumentSlugs` filter needs to reproduce the sound, and they are usually more identity-carrying than the genre. Together with BPM and mode, these three fields *are* the row.
- **Measure the motion energy in the same section**: median entrance duration in frames and median shot length. A coherent section shows fast BPM with short entrances and short shots; the mismatch case shows a fast bed over 0.6 s eases and 5 s shots, and it feels like the video is dragging even though the music is busy.
- **Vocals present or absent, and whether narration overlaps them.** Log both. Lyrics under narration is a defect; lyrics under a wordless montage is a choice ([[sfx-vocal-vs-instrumental-bed]]).
- **Watch for the row changing at the section boundary** rather than inside a section. Track changes on topic changes are the signature of a mood map; track changes mid-paragraph are the signature of a stock playlist.
- **Count the distinct rows used across the whole video.** Two to four is a coherent identity; seven is a playlist.
- **Level.** Under narration a bed sits around −20 to −25 dB relative to dialogue at 0 to −3 dB. A bed you can transcribe is too loud.

## Parameters

**The table.** Every row is a lookup: pick the emotion, take the whole row. Every `moodSlugs` value was probed live against `SearchRecordings` with `matchType: ALL`; the count is the catalogue size behind that slug on 2026-08-28. Motion columns marked **—** are rows that carry no measured motion band yet: take the nearest row by arousal and record what you chose.

| Editorial emotion | `moodSlugs` (verified, count) | BPM band | Mode / instrument / genre hint | `vocals` | Motion duration band | Transition tier | Median shot |
|---|---|---|---|---|---|---|---|
| Uplifting / hopeful, "it works out" | `hopeful` (3.1k+), `happy` | 85–125 | Major; piano, plucked arp, swelling strings, claps late; `pop` | false under narration | 0.3–0.5 s (9–15 f) | medium: `push-slide` | 3–5 s |
| Excitement / game-changing | `euphoric` (1,689), `happy` | 118–132 | Major; bright synth, four-on-the-floor, claps; `nu disco`, `house` | true only if no narration | 0.15–0.3 s (5–9 f) | high: `zoom-through` | 1.2–2.5 s |
| Epic / triumph, big finish | `epic` (3,082) | **120–140 tagged; 90–120 felt** | Minor→major lift; strings, brass, taiko, choir; `orchestral hybrid`, `cinematic` | true only if no narration | 0.5–0.8 s (15–24 f) | high but slow: `zoom-through` at 0.5 s | 2–4 s |
| Driving / focused work | `restless` (8,477) | 110–130 | Neutral valence; electronic drums, arpeggios; `beats` | false | — | — | — |
| Cool / confident flex | `laid-back` (10k+), `smooth` | 85–110 | Minor; lo-fi drums, sub bass, vinyl texture, electric piano, upright bass; `neo soul`, `lo-fi` | false | 0.3–0.5 s (9–15 f) | medium: `push-slide` | 2.5–4 s |
| Calm / explanation, contemplative | `peaceful` (4,292), `floating` | 60–95 | Major or modal; Rhodes, pads, felt piano, brushed drums; `ambient` | false | 0.5–0.8 s (15–24 f) | calm: `blur-crossfade` | 4–7 s |
| Reflective / sentimental, tender | `sentimental` (5,348), `dreamy` | 55–90 | Major 7ths; solo piano, felt keys, cello, reverbed guitar, no drums; `contemporary classical` | false | 0.8–2.0 s (24–60 f) | calm: `blur-crossfade` 0.6–0.8 s | 5–9 s |
| Dreamy / drifting | `dreamy` (display name verified) | 70–100 | Reverbed keys, pads | false | — | — | — |
| Romantic / intimate, longing | `romantic` (3,726), `sexy`, `smooth` | 65–110 | Major 7ths; nylon guitar, Rhodes, warm synth, brushed kit; `r&b` | true only if no narration | 0.5–0.8 s (15–24 f) | calm: `blur-crossfade` | 4–7 s |
| Sad / loss | `sad` (2,325), `heavy-ponderous` | 50–80 | Minor, legato; solo piano or cello, long sustains | false | 0.8–2.0 s (24–60 f) | calm, long: `crossfade` 0.8 s | 6–10 s |
| Anticipation / tense, "something is coming" | `suspense` (2,304), `restless` | 90–130 | Minor; pulsing synth, muted plucks, ostinato strings, low drone, sparse percussion | false | 0.3–0.5 s (9–15 f) | medium: `push-slide`, `squeeze` | 2.5–4 s |
| Dark / ominous, serious warning | `dark` (5,689), `fear` | 60–110 | Minor; low drone, detuned pad, sub bass, sub hits, distorted textures; `trap`, `cinematic` | false | 0.5–0.8 s (15–24 f) | medium, hard: `squeeze` | 3–6 s |
| Mysterious / uncanny, curiosity gap | `mysterious` (3,021), `sneaking`, `weird` | 70–100 | Minor/whole-tone; pizzicato, marimba, detuned keys, bowed metal, filtered pad | false | 0.3–0.5 s (9–15 f) | medium: `push-slide` | 3–5 s |
| Fear / threat | `fear`, `scary` (display names observed; verify before use) | 60–120 | Strings sul ponticello, sub pulses; `horror` | false | — | — | — |
| Angry / confrontation | `angry` (1,795) | 120–160 | Distorted guitar, aggressive drums; `metal`, `rock` | false | — | — | — |
| Chaotic / urgent, chase | `chasing`, `busy-frantic` (1,787), `running` | 130–172 | Minor, driving; arps, breakbeat, staccato strings, fast percussion, stabs | false | 0.15–0.3 s (5–9 f) | high: `zoom-through` 0.2–0.3 s | 0.8–1.8 s |
| Playful / quirky | `quirky` (1,838), `eccentric` | 110–150 | Major, staccato; pizzicato, ukulele, marimba, woodblock; `easy listening`, `swing` | false | 0.15–0.3 s (5–9 f) | high, playful: `zoom-through` 0.3 s | 1–2.5 s |
| Comic / joke landing | `funny` (995) | 100–160 | Tuba, muted trumpet, slide whistle; `comedy` | false | 0.15–0.3 s (5–9 f) | high, playful: `zoom-through` 0.3 s | 1–2.5 s |

**On the Epic row's two BPM figures.** The library *tags* epic material at 120–140, but the row is almost always **felt in half-time** — the perceived pulse is 60–70, which is why its motion band is slow (0.5–0.8 s) despite the high tagged tempo. **Filter on the tagged band; set the motion from the felt pulse.** Reading the tagged number as the motion clock is how you get 5-frame snaps under a choir.

Non-emotion knobs that go on the same query:

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `default_bpm` / house BPM | 110 (band 100–120) | 60–172 | The creator's stated personal default when the section has no strong emotion. Start every row's band centred here unless the row says otherwise. |
| `bpm_vs_speech` | matched | — | Fast delivery → top of the row's band; slow delivery → bottom. **Do not invert.** If the row's band and the pace disagree by more than ~30 BPM, the *row* is wrong for this section, not the band. |
| `bpm` filter and rubato tracks | leave **unset** for `peaceful` / `mysterious` / `fear` | — | Verified: tracks with no measured tempo carry **`bpm: 0`** (e.g. *Don't Turn Around*, Belladonna Strings). Any `bpm: {min: …}` filter silently excludes the entire ambient/rubato catalogue. |
| `moodSlugs.matchType` | `ALL` for two slugs, `ANY` for a row's alternates | — | `ALL` with two moods is the sharpest filter in the API — e.g. `["dark","suspense"]` returns exactly the thriller bed. |
| `vocals` | instrumental | vocal / instrumental | Vocal only where your own voice is absent. |
| `rows_per_video` | 3 | 2–5 | Fewer rows than sections is normal — reuse the row when the emotion returns. More than four or five and the video stops sounding like one thing. |
| `mode_lift` | optional | — | A minor→relative-major move between two adjacent sections is the cheapest available "it gets better" cue. |
| `articulation` | match motion | legato / staccato | Legato under long eases; staccato under snappy ones. The finest-grained match available, and almost nobody does it. |
| `music_level` | −22 dB (`data-volume` 0.079) | −25 to −20 dB | Against dialogue at 0 to −3 dB. The `angry` row and loud guitar-led material go to **−30 dB** (`0.032`) ([[sfx-loud-guitar-minus-30]], [[sfx-layer-volume-targets]]). |
| `programme_loudness` | −14 LUFS | −16 to −14 LUFS | −14 for YouTube/Tidal; −16 for podcast. True peak ≤ −1 dBTP. |

## Reproduction prompt

```
Resolve the music for every section of the video from the standing table.

1. DIAGNOSE, DO NOT BROWSE. For each section, write down two things before
   opening the library: its TARGET EMOTION in one word (already assigned by the
   mood map), and its PACE as words-per-minute of narration (count the words in
   the transcript for this section, divide by its length in minutes). Do not
   skip this - it is the whole method.

2. LOOK UP THE ROW and take the WHOLE ROW: moodSlugs, BPM band, mode and
   instrumentation, vocals decision, motion duration band, transition tier,
   median shot length. If the emotion is not on the table, pick the nearest row
   by valence (positive or negative?) and arousal (calm or energised?) - do not
   invent a new slug, unrecognised slugs return zero results.

3. RECONCILE BPM WITH PACE. The row gives a band; narration pace decides where
   in it you sit. Above ~165 wpm -> top of the band. Below ~120 wpm -> bottom.
   NEVER invert this - fast talking over slow music, or slow talking over fast
   music, is the one error the source names explicitly. If the row's band and
   the pace disagree by more than ~30 BPM, the row is wrong, not the band.

4. QUERY with all three parameters, not the vibe alone: BPM band first, then
   instrumentation, then mood slug.
     SearchRecordings {
       filter: { moodSlugs: { matchType: "ALL", values: [<row slug>] },
                 bpm: { min: <band low>, max: <band high> },
                 vocals: <row value>,
                 duration: { min: <section length ms + 20000> } },
       sort: { by: "POPULARITY", order: "DESCENDING" }, first: 12 }
   If the row is peaceful / mysterious / fear, OMIT the bpm filter entirely -
   rubato tracks carry bpm 0 and a bpm filter deletes them.
   If you get fewer than ~10 results, drop the instrument or genre filter first,
   then widen BPM. Never drop the mood slug - it is the row.
   If the section carries narration, filter to instrumental. Use vocal tracks
   ONLY where your own voice is absent for the whole section.

5. VERIFY THE VOCALS FIELD ON EACH RESULT. The vocals boolean filter leaks. Read
   each node's tags and keep only those whose "vocal type" tag is "no vocals"
   when you asked for instrumental. Discard "vocal presence" and "lead vocals".

6. WRITE THE MOTION COLUMN FROM THE SAME ROW. Every entrance animation in the
   section takes its duration from the row's motion band; every scene transition
   takes its type and duration from the row's transition tier; the cut plan
   targets the row's median shot length. On the Epic row, drive the motion from
   the FELT pulse (90-120), not the tagged BPM. If the design document already
   specifies motion that contradicts the row, STOP and resolve the conflict
   before building - one of the two is wrong.

7. AUDITION THREE AGAINST PICTURE, not against silence. Play each lqmp3Url over
   the actual cut. Reject any track whose energy peaks land somewhere other than
   your section's turns.

8. SET LEVEL: bed at -22 dB (-20 to -25) against dialogue at 0 to -3 dB; -30 dB
   for the angry row and loud electric guitar. Carve the bed against the
   narration rather than ducking it flat.

9. CHANGE THE ROW only at a section boundary, never mid-paragraph.

10. RECORD THE ROW in the design document next to the section, so the next video
    can reuse it. The table only pays off if the same emotion gets the same row
    twice.

ACCEPTANCE TEST: name the row you used, the BPM you landed on, and the narration
wpm. If BPM and wpm move in opposite directions across two adjacent sections,
one of the two rows is wrong. Then play each section boundary with picture: the
music change must land ON the boundary, not near it. Then play the section muted
and count entrance durations - their median must sit inside the row's motion
band. Then play it with music at -22 dB and try to follow the melody: if you can
follow the music instead of the voice, the bed is too loud or the row is too
busy for a narrated section.
```

## Execution spec

**Placement spec.** Music is a bed, not an event, so its "offset" is structural rather than framed: the track's **first downbeat lands on the section's first frame** (0 frames, never late), it sits at **−20 to −25 dB relative to dialogue** (`data-volume` 0.056–0.1, default 0.079 = −22 dB), and it is **carved, not ducked**, against the voiceover group.

**Epidemic Sound.** `SearchRecordings` is the entry point and the filters map one-to-one onto the table's columns.

```json
{ "filter": {
    "moodSlugs":  { "matchType": "ALL", "values": ["dark", "suspense"] },
    "bpm":        { "min": 90, "max": 130 },
    "vocals":     false,
    "duration":   { "min": 120000 },
    "featuredInstrumentSlugs": { "matchType": "ANY", "values": ["electronic-drums"] },
    "taxonomySlugs": { "matchType": "ANY", "values": ["electronic"] } },
  "query": { "term": "tense build" },
  "sort":  { "by": "POPULARITY", "order": "DESCENDING" }, "first": 12 }
```

Verified behaviours worth relying on:

- **Slugs fail closed.** `moodSlugs: ["eerie"]` returns `meta.total: 0`. Zero results means your slug is wrong, not that the catalogue is empty. Every slug in the table above was probed individually.
- **Slug form** is the display name lowercased with spaces hyphenated and `&` dropped: `busy & frantic` → `busy-frantic` (verified, 1,787 results).
- **`vocals: false` leaks.** Two separate probes with `vocals: false` returned tracks whose `vocal type` tag was `vocal presence`. Treat the boolean as a coarse pre-filter and **gate on the returned tag**, not on the filter.
- **Tags come back dimensioned.** Each node's `tags[]` carries `{displayName, dimension:{name}}` with dimensions `mood`, `genre`, `production genre`, `decade`, `world countries`, `vocal type`, `lyric type`. Read `production genre` — values like `corporate`, `cinematic`, `horror`, `comedy`, `pulses`, `build` are often a better match to an edit's *function* than the musical genre is.
- **`bpm: 0` is real.** Ambient and rubato tracks report zero, so a BPM filter deletes them silently.
- **Stems ship with the track**: `DRUMS`, `BASS`, `MELODY`, `INSTRUMENTS`, `CLEAN_VOCALS`, `VOCALS`. A row that wants a thinner version of the right track should reach for a stem before it reaches for a different track ([[sfx-music-stem-layering]]).
- `SearchSimilarToRecording` expands a row once one track in it is right, and is also the smooth way to change tracks between adjacent sections without a hard tonal jump ([[sfx-find-similar-track-handover]], [[sfx-track-change-at-section-boundary]]).

`DownloadRecording` produces a local file and **stops there**; everything after is HyperFrames. Keep the file inside the project (`.media/audio/bgm/`) so the compiler and render can reach it.

**HyperFrames.** One bed per section, at the root, carved against the voice group.

```html
<audio id="vo-s3-1" src=".media/audio/voice/s3-01.wav" data-audio-group="voiceover"
       data-start="128.4" data-track-index="10"></audio>

<audio id="bed-s3" src=".media/audio/bgm/anticipation-108bpm.mp3"
       data-audio-group="music"
       data-start="126.0" data-duration="74" data-media-start="8.0"
       data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```

Contract points that bind this:
- **Every `<audio>` needs an `id`.** An id-less audio element is never mixed — a **silent render**, with no error.
- **Carve, don't duck.** `data-fx-carve` lives on the **bed**, never on a voice, and its `sources` must name an **audio group**, not a list of clip ids (`audio_carve_ungrouped_sources`); it is clip-only, never on an `<hf-audio-group>` (`audio_group_carve_attr`). Default `strength` 0.25 is about a 6 dB dip in three bands — audible as room for the voice, not as a hole; at 0.5 the dip reaches 10 dB and starts being heard as an effect. If the bed sounds *notched* rather than quieter, the strength is too high. Then run `node <SKILL_DIR>/scripts/carve.mjs --comp index.html` (needs `ffmpeg` on PATH and `@hyperframes/core` installed).
- **`data-volume` is linear gain, not dB.** Default `1` = 0 dB; the maximum is `3.98` (+12 dB). A −22 dB bed is `data-volume="0.079"`; the `angry` row gets `0.032` (−30 dB).
- **Do not both automate and tween `volume`.** A `volume` lane wins and the GSAP tween is ignored (`audio_volume_double_automation`); an authored `data-volume` on a tweened track is replaced entirely, not scaled (`audio_volume_tween_overrides_gain`).
- **Automation `t` is clip-local on a clip** and **composition time on an `<hf-audio-group>` bus**, and a lane **holds its first value backwards to the clip start** — so a bed that begins before the voice needs an explicit point at `t: 0`.
- **A track change at a boundary** is two audio clips, the outgoing with a volume lane falling to 0 and the incoming starting at the same composition second. Relative timing (`data-start="bed-s2 + 0"`) works but has four silent zero-failures — spaces around the operator are required, an unresolved reference silently resolves to 0, a target with no resolvable duration lands you on its **start**, and a cycle resolves to 0. Author the number when in doubt.
- Audio lives at the **host root** in modular projects so playback survives scene cuts.

**ffmpeg.** BPM is not measurable by ffmpeg alone; take it from the library metadata, which is why searching by BPM beats detecting it. For level checks and the final master:

```bash
ffmpeg -i bed.mp3 -af "volumedetect" -f null - 2>&1 | grep -E "mean_volume|max_volume"
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -    # measure
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=…:linear=true mix.social.wav
```
`librosa`, `auto-editor` and `scenedetect` are **not verified present** in this environment and the VM is linux ARM64 without sudo, so treat the tempo script in the recognition section as optional; the Epidemic `bpm` field is authoritative for library tracks anyway and needs no analysis.

**Remotion.** Conceptually identical — the table is a data file, not an API. Portability note only.

## Pairs with
[[sfx-emotion-and-pace-diagnosis]] · [[sfx-bpm-filter-first]] · [[sfx-mood-vibe-filter]] · [[sfx-instrument-filter-search]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-music-audition-against-picture]] · [[sfx-track-change-at-section-boundary]] · [[sfx-find-similar-track-handover]] · [[sfx-layer-volume-targets]] · [[sfx-loud-guitar-minus-30]] · [[sfx-music-primacy-doctrine]] · [[sfx-track-reversion-to-edit-length]] · [[pace-speech-rate-to-bpm-map]] · [[pace-tempo-band-energy-map]] · [[struct-music-arc-to-narrative-arc]] · [[sfx-mood-map-per-topic]] · [[pace-bpm-matched-music-selection]] · [[sfx-vibe-brief]] · [[sfx-music-rest-windows]] · [[motion-pattern-interrupt-jolt]] · [[sfx-music-sets-the-mood]] · [[sfx-music-stem-layering]] · [[sfx-riser-anticipation-build]] · [[sfx-cartoon-comedy-family]]

## Failure modes
- **Vibe-only search.** Searching "epic" and auditioning 40 tracks is the exact waste the three-parameter method replaces. Correction: BPM band first, instrumentation second, mood slug third.
- **Inventing a slug.** Anything not in the verified list fails closed at zero results, and the usual reaction — widening the query term — hides the cause. If a search returns nothing, check the slug first.
- **Inverting BPM against speech rate.** Slow delivery over a fast bed (or the reverse) is the error the source calls out by name; it makes the video feel "really odd" without the viewer knowing why. Correction: measure wpm, pick within the band accordingly.
- **Driving the motion from the Epic row's tagged BPM.** 140 BPM tagged, felt at 70 — take the motion band from the felt pulse or you get 5-frame snaps under a choir.
- **Music row and motion row disagreeing.** A 150 BPM bed under 0.8 s eases, or a piano ballad under 3-frame snaps. Correction: take the whole row, including the motion band; resolve conflicts before building.
- **Trusting `vocals: false`.** Verified to leak. Gate on the returned `vocal type` tag or you will ship lyrics under narration.
- **Filtering by BPM on an ambient row.** `bpm: 0` tracks vanish, and those are exactly the tracks the `peaceful` and `mysterious` rows want.
- **Using seven rows in one video.** Each row is a colour; a video with seven has none. Cap at three or four and let dynamics, not genre, carry the variation. One bed for the whole video is the opposite failure — no arc, and the music stops being information.
- **Picking the row from the footage instead of from the intent.** Drone shots do not mean the section is "epic". The row comes from what the section is *for*, and the editor sets the mood ([[sfx-mood-vibe-filter]]).
- **Bed too loud.** Anything above about −20 dB against dialogue at 0 to −3 dB starts stealing intelligibility. Correction: −22 dB default, −30 dB for loud guitar-led material, and carve rather than duck.
- **Row changed mid-paragraph.** Reads as a playlist shuffling, not as an edit. Correction: boundaries only.
- **Treating the table as the decision.** It narrows the field; the audition against picture decides.
- **Known gap:** the API exposes no valence/arousal numerics and no energy-curve metadata, so matching a track's *internal* arc to the edit's structure cannot be filtered for — it has to be auditioned, or engineered afterwards with `EditRecording` ([[sfx-track-reversion-to-edit-length]]).
- **Known gap — the mapping is conventional, not universal.** The structural cues (mode, tempo, articulation, loudness) are well documented in the music-emotion literature, but the *emotion → genre* rows are production-library conventions and carry cultural loading. They are a defensible default for a broad Western-facing audience and should be re-derived if the target audience is elsewhere. Record the target audience in the design document. Four rows also carry no measured motion band yet — take the nearest row by arousal and write down what you chose.
