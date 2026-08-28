---
id: sfx-bpm-filter-first
title: Filter by BPM before you listen to anything
skill: sound-design
type: music
family: music-search
tags: [skill/sound-design, type/music, family/music-search, engine/epidemic, engine/ffmpeg, layer/music, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:33"
    quote: "So I personally use Epidemic Sound, and there I can search for music by BPM. I mostly use 100-120 BPM music, because I talk a little fast. You apply the filter here and boom - music that will fit my video has arrived."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:18"
    quote: "The higher the BPM, the faster and more energetic your music feels. So if you're talking fast in the video, a high BPM will feel good; and if you're talking slowly, low BPM music will suit it better. Don't flip the two around - the video will feel really odd."
research_refs:
  - mcp://Epidemic_sounds/SearchRecordings (schema and filters probed live, 2026-08-27)
  - https://en.wikipedia.org/wiki/LUFS
difficulty: low
detectable_from: transcript+video
---

# Filter by BPM before you listen to anything

## What it is
A search discipline, not a taste question. Before auditioning a single track, constrain the library by beats per minute so that everything you hear is already compatible with how fast the presenter talks. The filter does the elimination; the ears only pick a winner from a pre-qualified set. The transcript's failure case is the whole reason it exists: liking a track, downloading it, dropping it under the video, finding it does not fit, and starting the hunt again — a loop that costs hours and produces a track chosen for how it sounds alone rather than for how it sits under a voice.

## When to use it
At the start of every music search, before any listening. Measure the delivery speed first (words per minute from the transcript and its timestamps), map it to a BPM window, then filter. Also re-apply per section: a video whose hook is fast and whose teaching sections are slow needs two different windows, not one track stretched across both. The one case to skip it is a montage with no voice at all — there the cut rhythm sets the tempo and you should filter on mood and vocals instead (a voice-free montage is where vocal tracks are allowed; under narration they conflict).

## How to recognise it in a reference video
- **Measure speech rate from the transcript.** Words ÷ speaking minutes. Creator-paced delivery runs 150–190 wpm; deliberate/teaching delivery 110–150 wpm; hype/hook delivery 190–230 wpm.
- **Measure music tempo from the audio.** Onset-count over a 30 s music-only window, or read the beat spacing off the waveform: beat interval seconds = 60 ÷ BPM.
- **The tell that this rule was followed:** BPM and wpm move together across the video's sections, and cuts land on beats. The tell that it was not: a 75 BPM ambient bed under 200 wpm delivery (feels sluggish and mismatched) or a 140 BPM track under a slow, sincere section (feels frantic).
- Track changes at section boundaries, each with a different tempo, means per-section filtering rather than one-track-fits-all.
- If B-roll cuts land on the beat grid, the track was chosen before the cuts were finalised or the cuts were re-timed to it — either way, tempo was treated as a constraint, not decoration.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Creator default window | 100–120 BPM | as stated in source | The creator's own default, "because I talk a little fast". |
| Slow / sincere delivery (<130 wpm) | 70–95 BPM | 60–100 | |
| Normal delivery (130–170 wpm) | 95–115 BPM | 90–120 | |
| Fast delivery (170–200 wpm) | 110–130 BPM | 100–140 | |
| Hook / montage (>200 wpm) | 125–150 BPM | 120–160 | Half-time feel at 2× BPM is also valid. |
| Window width | ±10 BPM | ±5 to ±20 | Narrower than ±5 starves the result set. |
| Candidates to audition | 5 | 3–8 | Audition the survivors only. |
| Vocals under narration | `false` | — | Vocal tracks conflict with the presenter's voice. |

## Reproduction prompt

```
Choose the music bed for section {{SECTION}} ({{IN}} to {{OUT}}) by filtering
before listening. Do not audition anything until step 3.

1. MEASURE DELIVERY. From the transcript, count words spoken between {{IN}} and
   {{OUT}} and divide by the speaking minutes to get wpm. Map:
     <130 wpm -> 70-95 BPM    130-170 -> 95-115
     170-200  -> 110-130      >200    -> 125-150
   If unmeasurable, use 100-120 BPM.
2. FILTER. Call Epidemic SearchRecordings with:
     query: { term: "<the section's emotional intent, 2-4 words>" }
     filter: { bpm: { min: <low>, max: <high> },
               vocals: false,
               duration: { min: <section length in ms> } }
     sort:   { by: "RELEVANCE", order: "DESCENDING" }
   If the section has NO presenter voice over it, set vocals: true instead.
   If a dense-guitar bed is unwanted, add
     featuredInstrumentSlugs: { matchType: "NOT_ANY", values: ["electric-guitar"] }
3. AUDITION EXACTLY 5 SURVIVORS via their lqmp3Url, against the picture, at the
   bed level (data-volume 0.079), never solo.
4. DOWNLOAD the winner with DownloadRecording, fileType WAV, into
   assets/audio/bgm/. Record the recording id and its bpm in the design doc -
   the bpm is needed later for beat-aligned stops and cuts.

ACCEPTANCE TEST: with the bed at -22 dB under the narration, the presenter's
phrasing and the track's pulse do not fight - phrase endings tend to land near
beats without being forced. If you find yourself wanting to speed the track up or
slow the presenter down, the BPM window was wrong; redo step 1, do not re-audition.
```

## Execution spec

**Epidemic Sound (primary).** `SearchRecordings` exposes exactly the filters this rule needs — verified live against the MCP:

| Need | Field | Shape |
|---|---|---|
| Tempo | `filter.bpm` | `{ min: 100, max: 120 }` |
| Voice conflict | `filter.vocals` | boolean; `false` returns tracks tagged `no vocals` |
| Instrument | `filter.featuredInstrumentSlugs` | `{ matchType: "ALL"\|"ANY"\|"NOT_ANY", values: ["acoustic-guitar", "electric-guitar", …] }` |
| Mood / vibe | `filter.moodSlugs` | same shape; returned tags carry `dimension.name = "mood"` (e.g. `happy`, `hopeful`, `dreamy`, `sentimental`) |
| Genre / decade / region | `filter.taxonomySlugs` | genres, decades, world-country in one dimension |
| Length | `filter.duration` | **milliseconds** |
| Key | `filter.musicalKeys` | `["c-minor", …]` — use when two beds must sit together |

Every returned `recording` carries `bpm`, `audioFile.lqmp3Url` (audition without downloading), `audioFile.waveformUrl` (a peak JSON, useful for beat-aligned stops), and a `stems` array (`DRUMS`, `BASS`, `MELODY`, `INSTRUMENTS`, `VOCALS`, `CLEAN_VOCALS`). Stems are the cheap way to get a "quieter version" of a track that is otherwise right — drop the drums under narration rather than dropping the level. Confirmed live: a `bpm 100–120 + vocals:false` query returns tracks whose `bpm` field lands inside the window (120, 113, 118).

Follow-ups: `SearchSimilarToRecording` for a smooth track-to-track change at a section boundary; `SearchExternalReferences` to start from a Spotify track the client named.

**ffmpeg.** To verify a delivered track's tempo or to re-check the section's speech rate, extract audio and inspect: `ffmpeg -i ref.mp4 -vn -ac 1 -ar 48000 /tmp/ref.wav`. Word counts come from `npx hyperframes transcribe` or `transcribe.mjs`, which emit `{ text, words:[{text,start,end}] }` — wpm is computable directly from that.

**HyperFrames.** The chosen file is placed like any other bed: `<audio id="music-bed" data-audio-group="music" data-volume="0.079" …>` with `data-media-start` used to skip the track's warm-up and start on the first real beat, per the source video's "ignore the warm-up" advice. No file cut is needed for that.

**Remotion.** Concept only: the same filtered file, mounted as `<Audio src={staticFile(...)} />`; tempo alignment is done by computing frame positions from BPM.

### Facet upgrade — BPM is one of six, and it is weakest alone
The Epidemic UI's filter bar, read directly off `editing kt 3`, carries exactly **`Moods | Genres | Duration | BPM | Vocals | Key`**, and `editing kt` independently shows a results list with a **BPM column** (91, 114, 90, 120, 80). So BPM-first is confirmed as the creator's real workflow — but a BPM window alone is a weak filter: `bpm 100–120` + `vocals:false` still returns the API's 10,000-result cap. Make the query a **facet tree**, not a single filter:

```
SearchRecordings
  query:  { term: "<one to three words of intent>" }
  filter: { bpm:      { min: <target-5>, max: <target+5> },
            vocals:   false,                       # never omitted under narration
            duration: { min: <section_ms> },       # MILLISECONDS
            moodSlugs:{ matchType: ANY, values: [<discovered slugs>] } }
  first: 20
```
Read `meta.total` as the instrument: **20–300 is a finished query**; above that, tighten Duration or Moods before touching the BPM window, since BPM is the one value derived from measurement rather than taste. [[sfx-epidemic-facet-query]] owns the general construction and the loosening order.

## Pairs with
[[sfx-music-audition-against-picture]] · [[sfx-loud-guitar-minus-30]] · [[sfx-layer-volume-targets]] · [[sfx-music-hard-stop]] · [[sfx-music-rest-windows]] · [[sfx-name-before-search]] · [[sfx-sound-pass-order]] · [[sfx-epidemic-facet-query]] · [[sfx-music-ten-point-framework]]

## Failure modes
- **Auditioning first, filtering never.** The loop the source video names: you fall for a track, then try to make the video fit it. Filter, then listen.
- **Inverting the mapping.** Fast talking over a slow bed, or slow talking over a fast one — *"the video will feel really odd"*. This is the one hard error in the rule.
- **Filtering the window so tightly the result set is empty.** `SearchRecordings` returns `meta.total`; if it is under ~20, widen the BPM window before changing the search term.
- **Leaving `vocals` unset under narration.** Lyrics compete with the presenter for the same channel of attention. Set `vocals: false` explicitly; do not rely on the term.
- **Ignoring `duration`.** A 90 s track under a 4-minute section forces a loop or a second search. Set `filter.duration.min` to the section length in **milliseconds** — the field is not seconds.
- **Recording only the filename.** Keep the `recording.id` and `bpm` in the design document; both are needed for [[sfx-music-hard-stop]] and for re-fetching the same asset later.
