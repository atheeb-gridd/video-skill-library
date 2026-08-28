---
id: sfx-three-parameter-music-search
title: The three-parameter funnel — BPM, then instrument, then vibe, in one query
skill: sound-design
type: music
family: music-search
tags: [skill/sound-design, type/music, family/music-search, engine/epidemic, layer/music, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:00
    quote: "Now if you just hunt for music randomly, you'll waste a ton of time."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:05
    quote: "Instead, you should focus on these three parameters:"
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:07
    quote: "BPM, instruments and vibe."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:35
    quote: "I mostly use 100-120 BPM music, because I talk a little fast."
research_refs:
  - mcp://Epidemic_sounds/SearchRecordings (funnel counts probed live, 2026-08-28)
  - https://en.wikipedia.org/wiki/Tempo
difficulty: low
detectable_from: transcript
---

# The three-parameter funnel — BPM, then instrument, then vibe, in one query

## What it is
The creator's answer to the biggest single time sink in editing: *"if you just hunt for music randomly, you'll waste a ton of time."* Every music search collapses to three filterable axes — **BPM**, **instruments**, **vibe** — and the discipline is to set all three *before* auditioning anything, so the ears only pick a winner from a pre-qualified set instead of doing the elimination.

The three axes each have their own note in this library: [[sfx-bpm-filter-first]] (why BPM comes first and how it maps to delivery), [[sfx-instrument-filter-search]] (why instrument is the scalpel), [[sfx-mood-vibe-filter]] (why vibe is a decision, not an observation). **This note is the funnel** — the part none of the three can say alone: what order the filters go on, what result count means you are done, and what to loosen first when the query returns nothing.

The funnel exists because the three axes have wildly different selectivity, and stacking them in the wrong order produces either 10,000 results or zero. Measured live on 2026-08-28:

| Query | Results |
|---|---|
| `bpm 100–120` + `vocals: false` | **10,000** (the cap — effectively unbounded) |
| `mood: hopeful` + `vocals: false` | **10,000** (top popularity hit was **147 BPM**) |
| `mood: hopeful` + `vocals: false` + `bpm 100–120` + `instrument: piano` | **953** |
| `mood: epic` + `vocals: true` + `bpm 100–120` | **81** |
| `mood: suspense` + `instrument: violin` + `vocals: false` + `bpm 60–100` | **14** |

Two facts fall out of that table and they are the whole method. First, **mood alone constrains nothing** — the most popular "hopeful, no vocals" track in the catalogue runs at 147 BPM, which is unusable under a slow delivery. Second, **instrument is the last filter you add**, because it is the only one that can take you from 953 to 14 in a single field.

The target is not "the fewest results". It is a **landing zone of roughly 20–200 candidates**: enough that a good track exists in the set, few enough that auditioning ten of them settles it.

## When to use it
- **Every time you need a music bed.** This is the entry point for [[sfx-music-audition-against-picture]], not an optimisation for hard cases.
- **Before opening the library at all.** The three values come from the video — pace, presence of your own voice, emotional intent — not from browsing.
- **When a search returns nothing.** The funnel is also the back-off ladder: it tells you which filter to loosen and in what order.
- **When a search returns thousands.** Adding the *next* axis is always cheaper than scrolling.
- **When re-scoring a section.** A section change wants a new query, not a new scroll ([[sfx-track-change-at-section-boundary]]).
- **Not for sound effects.** The SFX catalogue has no BPM and no mood dimension; it is searched by tag slug and duration ([[sfx-name-before-search]]).
- **Not when a profile already names a track family.** If the style profile has a working track, `SearchSimilarToRecording` beats a fresh funnel ([[sfx-find-similar-track-handover]]).

## How to recognise it in a reference video
This is a *process*, so what you detect in a reference is the **fingerprint of a disciplined search** rather than the search itself. All of it is measurable from the audio:

- **Measure the track's BPM and the presenter's speech rate in the same window.** Extract the music-only stretches (before the first line, after the last), estimate tempo, and count words per minute over 60 s of narration. A funnel-sourced bed shows a stable relationship — roughly **fast delivery (≥160 wpm) with 100–140 BPM**, **slow delivery (≤130 wpm) with 60–95 BPM**. A random pick shows no relationship at all, and its most common failure signature is a slow, deliberate delivery over a 140+ BPM bed.
- **Check vocal presence against narration presence.** A track with lead vocals under continuous narration is the single clearest sign no funnel was applied ([[sfx-vocal-track-for-narration-free-montage]]). Detect it by band-limiting the mix to 300–3400 Hz during a narration pause and listening for a second voice.
- **Count the distinct tracks and their boundaries.** Funnelled searches produce **one track per structural section** with changes on section boundaries, because a fresh query is run per section. Random browsing produces either one track for the whole video or changes at arbitrary points.
- **Listen for instrument consistency across track changes.** If two consecutive tracks share a lead instrument and a tempo band but differ in energy, the editor filtered by instrument. If they share nothing, they were picked by feel.
- **Log it for the design document as three values per section**, not as a track name: `bpm_range`, `instruments[]`, `mood[]`, plus `vocals: true|false`. Those four fields regenerate the search; a track title does not.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `bpm_window` | 100–120 | 60–160 | The creator's stated personal default, chosen because *"I talk a little fast."* Derive it per project from delivery speed ([[sfx-bpm-filter-first]]). |
| `bpm_widen_step` | ±10 | ±5 to ±20 | The first thing you loosen. Widening BPM costs less than dropping an instrument. |
| `vocals` | `false` | `true` \| `false` | A boolean, decided by whether your own voice is present, not by taste ([[sfx-vocal-track-for-narration-free-montage]]). |
| `mood_count` | 1 | 1–3 | With `matchType: ANY`, extra moods **widen**; with `ALL` they narrow hard. Start with one and `ANY`. |
| `instrument_count` | 1 | 0–2 | Added **last**. Two instruments with `ALL` will usually return single digits. |
| `target_results` | 20–200 | 10–400 | The landing zone. Above 400, add the next axis; below 10, back off one step. |
| `audition_depth` | 8 | 5–15 | Candidates actually played against picture. More than 15 means the filter was too loose. |
| `sort` | `POPULARITY DESC` | `POPULARITY` \| `RELEVANCE` | Popularity front-loads well-produced tracks; relevance is only useful when a free-text `term` is doing real work. |
| `duration_min` | section length × 1.1 | — | A bed shorter than its section forces a loop or a second track. Filter on it rather than discovering it later. |

## Reproduction prompt

```
Find the music bed for the section running {{IN}} to {{OUT}} (seconds).
Do NOT browse. Run the funnel.

STEP 0 - READ THE VIDEO, NOT THE LIBRARY. Write down three values before
any query:
  BPM     : count words per minute over 60 s of this section's narration.
            >=160 wpm -> 110-135. 130-160 wpm -> 95-120. <=130 wpm -> 65-95.
  VOCALS  : is your own voice present anywhere in {{IN}}..{{OUT}}?
            yes -> vocals:false (a lyric fights narration).
            no  -> vocals:true is allowed and usually better.
  VIBE    : the emotion you are CHOOSING to install, one word.
  (optional) INSTRUMENT: the mechanism that produces that emotion.

STEP 1 - QUERY WITH BPM + VOCALS + MOOD. Sort by popularity. Read the
result total.
STEP 2 - READ THE TOTAL AND ACT ON IT:
    > 400  -> add the instrument filter. Still > 400 -> narrow the BPM
              window to +/-8 of your centre, or add a second mood with ALL.
    20-200 -> STOP. This is the landing zone. Go to step 4.
    < 20   -> back off in this exact order: (a) drop the instrument,
              (b) widen BPM by +/-10, (c) switch moodSlugs matchType to ANY
              and add an adjacent mood, (d) drop the mood and keep BPM +
              instrument. Never drop the vocals boolean - it is not a taste
              filter.
    = 0    -> a slug is wrong, not the search. Zero means an invalid slug
              value. Verify the slug spelling before widening anything.
STEP 3 - repeat step 2 until you are in the landing zone. Record every
    (filter set -> total) pair; that ladder is the reusable artefact.
STEP 4 - AUDITION 8 CANDIDATES AGAINST PICTURE with the narration playing,
    never in isolation. Filter for fit, not for whether you like the song.
STEP 5 - WRITE BACK the winning filter set into the design document as
    bpm_range / instruments / mood / vocals - not as a track title. The next
    person re-runs the query; they cannot re-run a name.

ACCEPTANCE TEST: play 30 s of the section with the chosen bed under the
narration at -22 dB relative to dialogue. Every word must be intelligible,
and tapping along to the music must feel like the same tempo as the speech,
not half or double it. If the bed feels rushed or dragging, the BPM window
was wrong - go back to step 0, do not audition further.
```

## Execution spec

**Epidemic Sound — one call, all three axes.** `SearchRecordings` takes BPM, instrument and mood as **simultaneously combinable filters**, which is the fact that makes the creator's three-parameter model directly executable rather than aspirational:

```
# the full funnel in one query
SearchRecordings {
  filter: {
    bpm: { min: 100, max: 120 },                                   # axis 1
    featuredInstrumentSlugs: { matchType: ANY, values: ["piano"] }, # axis 2 - add LAST
    moodSlugs: { matchType: ANY, values: ["hopeful"] },             # axis 3
    vocals: false,
    duration: { min: 120000 }                                      # bed >= section
  },
  sort: { by: POPULARITY, order: DESCENDING },
  first: 20 }
# live 2026-08-28 -> meta.total 953. Dropping the instrument -> 10000 (capped).
```

Read `meta.total` on **every** call; it is the funnel's only instrument. `pageInfo.hasNextPage` and `endCursor` page through, but paging is a symptom — if you are paging, the filter is too loose.

Field semantics that decide whether the query does what you meant:

- **`moodSlugs` reaches only the `mood` dimension.** A `Recording`'s `tags` each carry a `dimension.name`, and the live probe shows at least six in use: `mood` (happy, laid back, dark, suspense, epic, sad, dreamy, elegant, funny, quirky, sentimental, angry, eccentric, hopeful), `genre` (k-pop, pop, electronic, trap, indie rock, synth-pop, bhajan, alternative rock, contemporary classical), `production genre` (corporate, comedy, children's music, sneaky, pulses, adventure, build, cinematic, religious music), `vocal type` (no vocals, lead vocals), `lyric type` (**clean**, **explicit**), `decade` (1970s, 1980s), `world countries` (india). A word in the wrong dimension returns **zero**, which is why zero means *fix the slug*, never *widen the search*.
- **`taxonomySlugs`** is the field for genre / decade / world-country, not `moodSlugs`.
- **`featuredInstrumentSlugs`** is its own field (`acoustic-guitar`, `piano`, `violin`, `strings`, `electronic-drums`, …) and is the most selective filter available — `ALL` with two instruments routinely returns single digits.
- **`matchType`** is the hidden lever: `ANY` widens, `ALL` narrows, `NOT_ANY` excludes. Excluding is under-used — `moodSlugs: { matchType: NOT_ANY, values: ["sad"] }` is often a better fix for a too-large set than adding another positive filter.
- **`vocals`** is a plain boolean and belongs in every query. `lyric type: explicit` also exists as a tag — check it before shipping a vocal track, because the filter does not remove explicit lyrics for you.
- **`musicalKeys`** (`c-minor`, `d-major`, …) is a **fourth axis the creator does not mention** and it is worth knowing: it is how you make a music bed and a pitched tone bed agree instead of clashing ([[sfx-tone-bed-mystery]]).
- **`stems`** come back on every result (`DRUMS`, `BASS`, `MELODY`, `INSTRUMENTS`, `CLEAN_VOCALS`, `VOCALS`). A track that is nearly right but too busy is often fixed by taking a stem rather than by re-running the funnel ([[sfx-music-stem-layering]]).

```
DownloadRecording { id:<uuid>, options:{ fileType: WAV, stemType: FULL } }
SearchSimilarToRecording { id:<uuid>, first:12 }   # once one track lands, keep the palette
```

**HyperFrames.** The funnel produces a file; placement is unchanged. A bed goes on a high track index with the narration grouped for the carve:
```html
<audio id="vo-1" src=".media/audio/voice/line-01.wav" data-audio-group="voiceover"
       data-start="0.5" data-track-index="10"></audio>
<audio id="music-bed" src=".media/audio/bgm/bed.wav" data-audio-group="music"
       data-start="0" data-duration="42" data-track-index="11" data-volume="0.071"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```
then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`. `data-volume="0.071"` is −23 dB, the middle of the source's −20/−25 window. Carve `sources` names a **group**, never a list of clip ids (`audio_carve_ungrouped_sources`), and `data-fx-carve` is **clip-only** — never on a bus.

**ffmpeg.** Only to verify the delivery-speed half of step 0 and to measure a candidate:
```bash
# words per minute from the transcript json, to set the BPM window objectively
node <SKILL_DIR>/scripts/transcribe.mjs --input talk.mp4 --out talk.transcribe.json
python3 -c "import json,sys; w=json.load(open('talk.transcribe.json'))['words']; \
print(round(len(w)/((w[-1]['end']-w[0]['start'])/60)))"
# confirm a downloaded bed is long enough for the section before you place it
ffprobe -v error -show_entries format=duration -of csv=p=0 bed.wav
```

**Remotion.** No equivalent — the funnel is a sourcing step, and Remotion has no music catalogue. Portability note only.

### Facet upgrade — the funnel's three parameters against the UI's six facets
The funnel in this note (BPM → instrument → vibe) predates the visual pass, which read the real filter bar off screen: **`Moods | Genres | Duration | BPM | Vocals | Key`**. Mapping one onto the other closes two gaps.

- **Vocals is missing from the funnel and should be its first move**, not an afterthought: it is a boolean, it is free, and the observed counts (`Vocals 291` / `Instrumentals 2529`) mean it costs almost nothing in choice under narration ([[sfx-vocal-vs-instrumental-bed]]).
- **Duration is missing and is the cheapest way to cut a result set** — `{min: section_ms}` in **milliseconds** removes every track too short to cover the section before you audition anything.
- **Instrument is not a UI facet at all** but is an API filter, so the funnel's second stage is stronger than the on-screen workflow rather than a copy of it ([[sfx-instrument-filter-search]]).
- **Key is the sixth facet and stays omitted by default** — it cuts hard for a benefit a single-bed section cannot hear.

Revised order for the funnel: **Vocals → BPM → Duration → Moods/vibe → Instruments → (Key, rarely)**, with `meta.total` read after each addition and a target landing zone of **20–300**. [[sfx-epidemic-facet-query]] carries the full parameter map, the `matchType` semantics and the loosening order when a query returns nothing.

## Pairs with
[[sfx-bpm-filter-first]] · [[sfx-instrument-filter-search]] · [[sfx-mood-vibe-filter]] · [[sfx-emotion-and-pace-diagnosis]] · [[sfx-vocal-track-for-narration-free-montage]] · [[sfx-music-audition-against-picture]] · [[sfx-find-similar-track-handover]] · [[sfx-track-change-at-section-boundary]] · [[sfx-music-stem-layering]] · [[sfx-layer-volume-targets]] · [[sfx-loud-guitar-minus-30]] · [[sfx-tone-bed-mystery]] · [[pace-bpm-matched-music-selection]] · [[pace-speech-rate-to-bpm-map]] · [[sfx-vibe-brief]] · [[sfx-epidemic-facet-query]] · [[sfx-music-ten-point-framework]]

## Failure modes
- **Auditioning before filtering.** The failure the source names outright — liking a track, downloading it, dropping it in, finding it does not fit, starting again. Fix: no playback until `meta.total` is inside the landing zone.
- **Filtering by mood alone.** Mood constrains nothing; the top "hopeful, no vocals" result was 147 BPM. Fix: BPM is axis one, always.
- **Adding the instrument first.** Takes you straight to single digits and hides the good tracks. Fix: instrument is the last filter on and the first filter off.
- **Reading zero results as "nothing fits".** Zero almost always means an invalid slug value, not an empty catalogue. Fix: verify the slug against the dimension it belongs to before touching the other filters.
- **Dropping the `vocals` boolean to widen a search.** It is a structural constraint, not a preference; a lyric under narration is a defect regardless of how good the track is. Fix: widen BPM instead.
- **Recording a track title in the design document instead of the filter set.** The next person cannot re-run a name, and the exact track may be gone. Fix: write `bpm_range / instruments / mood / vocals`.
- **Ignoring `duration` and discovering the bed is shorter than the section.** Forces an audible loop or an unplanned track change. Fix: `duration: { min: section_ms * 1.1 }` in the first query.
- **Shipping an `explicit` lyric type.** The `vocals` boolean does not filter it. Fix: read the `lyric type` tag on the chosen recording before download.
- **Known gap:** `meta.total` saturates at **10000**, so the funnel cannot distinguish "ten thousand" from "eighty thousand". Treat any 10000 as *unbounded* and keep adding axes; do not read it as a real count.
