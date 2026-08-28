---
id: sfx-epidemic-facet-query
title: Build the query from the six facets, not from a sentence
skill: sound-design
type: music
family: music-search
tags: [skill/sound-design, type/music, family/music-search, layer/music, engine/epidemic, source/editing-kt-3, source/editing-kt, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "visual — contact sheet, Epidemic Sound web UI"
    quote: "[NOT SPOKEN — read off screen] Filter bar: Moods | Genres | Duration | BPM | Vocals | Key. The Vocals facet expanded: Vocals 291 / Instrumentals 2529."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "visual — contact sheet, music search"
    quote: "[NOT SPOKEN — read off screen] Query box carrying the single word 'anticipation'; results list with a BPM column (91, 114, 90, 120, 80) and genre tags (Chill, Dance, Electronic, Ambient)."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:07"
    quote: "So I personally use Epidemic Sound, and there I can search for music by BPM."
research_refs:
  - https://www.epidemicsound.com/music/
  - https://support.epidemicsound.com/s/article/how-can-i-find-the-right-music-on-epidemic-sound
  - _meta/visual-kt-delta.md
  - _meta/execution-contract.md
  - mcp://Epidemic_sounds/SearchRecordings (filter shapes per execution-contract §5A.3)
difficulty: low
detectable_from: video
---

# Build the query from the six facets, not from a sentence

## What it is
The Epidemic Sound web UI, read directly off the reference video, carries exactly six filter facets:

```
Moods | Genres | Duration | BPM | Vocals | Key
```

with the Vocals facet expanded to show real counts — **`Vocals 291` / `Instrumentals 2529`**. A second video shows the search box holding a single word (`anticipation`) and a results list with a **BPM column**. Together those two frames describe the whole method the creator actually uses: **one term in the box, then narrow with facets.** Not a sentence, not a vibe, not a playlist.

This matters because a free-text query is a *relevance* request and a facet is a *constraint*. "Upbeat corporate music that isn't too distracting with no vocals around 110 bpm" is one long relevance string that the ranker will partially honour and partially ignore; the same intent expressed as `term:"upbeat corporate"` + `bpm 105–115` + `vocals:false` is a hard filter that **cannot** return a 78 BPM vocal track. The single most consequential of the six is **Vocals**: the visual pass is explicit that the vocals/instrumental decision is *a filter, not a judgement call*, and a bed under narration is `vocals: false` — always ([[sfx-vocal-vs-instrumental-bed]]).

The facet counts also tell you something about the catalogue's shape. `291` vocal tracks against `2529` instrumentals in that filtered view means the instrumental side is roughly **9×** larger: filtering to instrumentals costs almost nothing in choice, while filtering to vocals is a narrow slice and should be spent deliberately, on a montage where your own voice is absent ([[sfx-vocal-track-for-narration-free-montage]]).

**Two boundaries worth knowing before writing a query.**
- **The six facets belong to the music surface only.** Sound effects are a different surface with a different filter set — `duration` in milliseconds does nearly all the work there, and there is no mood, BPM, vocals or key ([[sfx-ten-family-catalogue]] carries the per-family SFX queries).
- **Instruments is not one of the six.** The reference set teaches instrument choice as a first-class parameter (violin for suspense), and the API supports `featuredInstrumentSlugs` — but it was **not** among the facets visible in the UI filter bar. Treat instrument as a real, available filter that the on-screen workflow did not use ([[sfx-instrument-filter-search]]).

## When to use it
- **Every music fetch.** This is the query-construction step for [[sfx-three-parameter-music-search]], [[sfx-bpm-filter-first]], [[sfx-mood-vibe-filter]] and [[sfx-emotion-music-lookup-table]] — those notes decide *what values*; this one decides *what shape*.
- **When a search returns thousands of results.** Add a facet, do not refine the sentence. Duration and BPM cut hardest.
- **When a search returns nothing.** Loosen facets in a fixed order — Key first, then Genres, then Mood, then BPM window, and never Vocals under narration.
- **When a fetch recipe in a note is free text only.** That is a defect: it will return a different neighbourhood every time it is run, and the video assembled from it will sound assembled.
- **Not for coherence across a whole video.** Facets find *a* track; similarity search finds a *family*. Once one bed is right, `SearchSimilarToRecording` on its id supplies the rest ([[sfx-find-similar-track-handover]], [[sfx-track-shortlist-library]]).

## How to recognise it in a reference video
- **The screen shows a filter bar, not a scrolling playlist.** A creator working facet-first has narrow result lists and short auditions; a creator browsing has long lists and the download-place-reject loop ([[sfx-music-audition-against-picture]]).
- **A BPM column is visible in the results.** That is the tell that BPM is being used as a selection criterion at all.
- **Beds under narration are instrumental with no exceptions.** One vocal track behind the presenter's own voice, anywhere in a video, means the Vocals facet is not part of that workflow.
- **Track lengths are close to section lengths.** Consistent use of the Duration facet shows up as beds that end musically rather than fading arbitrarily ([[sfx-track-reversion-to-edit-length]]).
- **Key is almost never used** in practice, and its absence is not a defect — it matters only when two cues overlap or a tonal SFX sits over a bed.

## Parameters

| Facet (UI) | Parameter | Shape | Default to use | Notes |
|---|---|---|---|---|
| **Moods** | `filter.moodSlugs` | `{matchType: ALL\|ANY\|NOT_ANY, values:[slug]}` | `ANY` with 2–3 slugs | Slug vocabulary is **not enumerable** on this surface — discover it by running a term-only search and reading back `tags[].displayName` where `dimension.name == "mood"`. |
| **Genres** | `filter.taxonomySlugs` | same shape | omit unless the profile names a genre | This dimension also carries **decade** (`1980s`, `2010s`) and **world/country** (`cuba`, `france`) alongside genre. |
| **Duration** | `filter.duration` | `{min, max}` in **milliseconds** | `min: section_length_ms` | Millisecond units are the classic mistake — `60000`, not `60`. |
| **BPM** | `filter.bpm` | `{min, max}` integers | target ±5 | Derive the target from speech rate; creator default band **100–120** ([[sfx-bpm-perceptual-bands]]). |
| **Vocals** | `filter.vocals` | **boolean** | `false` under narration | `true` = the Vocals side (291), `false` = Instrumentals (2529). Known to leak — also gate on the returned vocal-type tag. |
| **Key** | `filter.musicalKeys` | plain array `["c-minor"]` — **not** a matchType object | omit | Use only when cues overlap or a tonal sting must agree with the bed. |
| *(not a UI facet)* | `filter.featuredInstrumentSlugs` | `{matchType, values}` | use for suspense/emotion briefs | The API expression of the instrument-to-emotion mapping. |
| — | `first` / `after` | cursor pagination | `first: 20` | Read `pageInfo.endCursor`; `meta.total` is the count that tells you whether the funnel is working. |

**Funnel targets.** A query is finished when `meta.total` lands between about **20 and 300**. Above that you are still browsing; below about 10 you have over-constrained and should loosen Key or Genres first.

## Reproduction prompt

```
Construct an Epidemic Sound music query for {{SECTION}} using the six facets.

1. WRITE THE TERM. One to three words of intent, from the mood map or the
   emotion table - "anticipation", "upbeat corporate", "chill lo-fi". Not a
   sentence. The term is a relevance hint; the facets do the constraining.
2. SET VOCALS FIRST. vocals:false wherever the presenter's own voice is
   present. vocals:true only for a narration-free montage.
3. SET BPM. Measure narration words-per-minute for the section, map it to a
   target BPM, and use target +-5. Default band 100-120 if unmeasurable.
4. SET DURATION. min = the section length in MILLISECONDS. Do not filter max
   unless you intend to avoid trimming.
5. ADD MOODS only after a term-only probe: run the term alone, read back
   tags[].displayName where dimension.name == "mood", and use those exact
   strings as slugs. Never invent a slug.
6. ADD GENRES / KEY / INSTRUMENTS only if the brief names them.
7. READ meta.total. Over 300 -> add or tighten one facet. Under 10 -> loosen
   in this order: Key, Genres, Moods, BPM window. NEVER loosen Vocals.
8. RECORD THE QUERY in the cue sheet as the facet tree, plus the chosen
   recording's UUID. The UUID is the durable handle; the words are not.

ACCEPTANCE TEST: re-run the recorded query a day later and the winning track
is still in the result set. If it is not, the query was free text wearing a
filter's clothes.
```

## Execution spec

**Epidemic Sound — the canonical facet tree.**

```
SearchRecordings
  query:  { term: "anticipation" }                    # one term, from the UI's own box
  filter: { bpm:      { min: 105, max: 115 },
            vocals:   false,                          # the Instrumentals side of the facet
            duration: { min: 75000 },                 # ms - covers a 75 s section
            moodSlugs: { matchType: ANY, values: ["hopeful", "epic"] } }
  sort:   { by: RELEVANCE, order: DESCENDING }
  first:  20
  -> read `bpm` and `tags[]` off each node; audition the top 5 against picture
DownloadRecording { id:<recordingId>, options:{ fileType: WAV, stemType: FULL } }   # stemType REQUIRED
```
`matchType` semantics: `ALL` = every value, `ANY` = at least one, `NOT_ANY` = exclusion — and `NOT_ANY` is the honest way to write "not that", rather than filtering results afterwards. **Slug values are not verifiable from the schema**: it offers examples only (`c-minor`, `acoustic-guitar`, `rock`, `2010s`, `cuba`). Discover, then record. Recording tags expose `displayName` and `dimension.name` but **no slug**, so the lower-case-and-hyphenate convention is a guess that must be tested per query.

**Sound effects take a different tree.** No facets; `duration` in ms and the term:
```
SearchSoundEffects { query:{term:"whoosh transition"}, filter:{duration:{max:1500}} }
DownloadSoundEffect { id:<id>, options:{ fileType: WAV } }
```

**Coherence beats relevance for the second and third cue.** `SearchSimilarToRecording(id)` / `SearchSimilarToSoundEffect(id)` return the chosen asset's neighbourhood. Store the anchor UUID in the style profile; a row that says *"bed, similar-to `<uuid>`"* is executable, where *"something upbeat"* re-litigates the palette on every fetch.

**HyperFrames.** Fetching stops at a local file. `data-media-start` trims the warm-up, `data-duration` sets the length, `data-volume="0.079"` is the −22 dB bed — none of which the facets touch. If the track is long and the section short, decide between the free in-composition trim and `EditRecording` (a three-call async job: `EditRecording` → `PollEditRecordingJob` → `DownloadRecordingEdit` with **both** `jobId` and `editId`; `targetDurationMs` caps at 300000).

**Known environment constraint.** `audiocdn.epidemicsound.com` is blocked by this project's egress allowlist (verified 403 on CONNECT), so a signed `assetUrl` must be fetched from a host that allows it. Store UUIDs, not URLs — the schema does not say whether `assetUrl` expires, and its sibling field is literally named `signedUrl`.

## Pairs with
[[sfx-three-parameter-music-search]] · [[sfx-bpm-filter-first]] · [[sfx-mood-vibe-filter]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-instrument-filter-search]] · [[sfx-emotion-music-lookup-table]] · [[sfx-music-cue-sheet-per-segment]] · [[sfx-find-similar-track-handover]] · [[sfx-track-shortlist-library]] · [[sfx-music-ten-point-framework]] · [[sfx-ten-family-catalogue]]

## Failure modes
- **Sentences in the term field.** The ranker honours some of it and ignores the rest, and the result set is different every time. One to three words.
- **Seconds where milliseconds are required.** `duration:{min:60}` filters to tracks longer than 60 ms — that is, everything. Silent, and it looks like the filter simply did nothing.
- **Inventing slugs.** `moodSlugs:["uplifting-corporate-vibes"]` returns `meta.total: 0` and reads as an empty catalogue. Probe with the term alone first.
- **Omitting `vocals:false` under narration.** The most expensive omission on the list: a vocal bed behind a voice is the source's own named mistake, and the filter is free.
- **Treating `vocals:false` as a guarantee.** It leaks. Check the returned vocal-type tag before committing.
- **Using Key as a default.** It cuts the result set hard for a benefit almost no single-bed section can hear.
- **Storing the query but not the UUID.** Facets narrow to a neighbourhood, not to a file; without the id the exact track is not recoverable.
- **Applying music facets to sound effects.** They are silently ignored on that surface, and the fetch quietly becomes free text.
- **Known gap:** the visual pass shows the facet bar and the vocals counts; it does **not** show which mood or genre slugs the creator selected. Every slug in this library is discovered, not observed.
