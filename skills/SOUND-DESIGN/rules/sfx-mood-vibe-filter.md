---
id: sfx-mood-vibe-filter
title: Mood is the third axis — and the editor sets it, not the footage
skill: sound-design
type: music
family: music-search
tags: [skill/sound-design, type/music, family/music-search, layer/music, engine/epidemic, engine/hyperframes, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:03:15
    quote: "In software like Epidemic Sound you even get this feature, where you can search for music by vibe or by mood."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:03:05
    quote: "You don't figure out the vibe — you create the vibe."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:05
    quote: "Instead, you should focus on these three parameters: BPM, instruments and vibe."
research_refs:
  - https://www.epidemicsound.com/music/search/
  - https://www.epidemicsound.com/music/moods/
  - https://universalcategorysystem.com/
difficulty: low
detectable_from: transcript
---

# Mood is the third axis — and the editor sets it, not the footage

## What it is
Mood is the last of the three search parameters, applied after BPM and instrument, and it is the one that turns a technically correct shortlist into the right one. The source frames it as a decision rather than an observation: *"You don't figure out the vibe — you create the vibe."* The same footage under a `mysterious` bed and a `hopeful` bed is two different videos, and the editor chooses which.

Practically, mood is a **filter dimension in the library's taxonomy**, not a free-text word. Epidemic's music catalogue tags every recording across several dimensions — `mood`, `genre`, `production genre`, `vocal type`, `world countries` — and only `mood` is reachable through the mood filter. Knowing which dimension a word lives in is the difference between a query that returns the right 80 tracks and one that returns nothing.

## When to use it
- **On every music search, as the third filter**, after the BPM window from [[sfx-bpm-filter-first]] and any instrument constraint from [[sfx-instrument-filter-search]]. The order matters: BPM and instrument are hard constraints, mood is the taste layer that narrows what survives them.
- **When a shortlist is technically right and emotionally wrong.** Same BPM, same instruments, still not it — the missing axis is mood.
- **When a section changes emotional register without changing pace.** The same BPM band with a different mood slug is the cleanest way to get a new track that still cuts together with the old one ([[sfx-track-change-at-section-boundary]]).
- **As an exclusion.** `NOT_ANY` on a mood is underused and powerful: an upbeat sponsor read inside a serious video is `NOT_ANY: ["dark"]` rather than a new search.
- **Not as the first filter.** Mood alone across the whole catalogue returns thousands of tracks at every tempo; it is a narrowing tool, not a starting point.
- **Not for sound effects.** The SFX catalogue has no mood dimension at all — its filters are `tagSlugs` and `duration` only. Emotional intent in SFX is expressed through the family and through treatment ([[sfx-vocabulary-llm-expansion]], [[sfx-filter-character-and-distance]]).

## How to recognise it in a reference video
- **Name the reference's mood in library vocabulary, not in prose.** The finding to log is a slug list, because that is what a design document can execute. Verified live slugs from the catalogue include: `epic`, `hopeful`, `mysterious`, `suspense`, `dark`, `happy`, `smooth`, `dreamy`, `laid-back`, `floating`, `sunny-holiday`.
- **Slug form is the display name lowercased and hyphenated** — the tag that displays as "laid back" filters as `laid-back`. Confirmed live.
- **Do not confuse mood with production genre.** `build`, `drama`, `mystery`, `pulses`, `action`, `adventure`, `crime-scene`, `acoustic`, `beautiful` are all real tags, but they sit in the **production genre** dimension and are *not* reachable via `moodSlugs`. A query using them as moods returns zero. This is the single commonest silent failure in library search.
- **Read moods off a match instead of guessing.** Find one track that sounds like the reference, then read its `tags[]` back — each carries its `dimension.name`. Two or three tracks are enough to identify the mood cluster the reference lives in.
- **Check the vocal type tag.** `no vocals` appearing on every track in a narrated reference is the confirmation of the vocals rule, not a coincidence.
- **Multiple moods per track is normal.** Real catalogue entries carry pairs like `mysterious` + `suspense`, or `hopeful` + `floating`. Match on the pair when a single word does not capture it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `moodSlugs.matchType` | `ANY` | ANY / ALL / NOT_ANY | `ANY` = union, the normal case. `ALL` only for a deliberate pair (`mysterious`+`suspense`). `NOT_ANY` to carve an exclusion out of an otherwise good query. |
| Mood count per query | 2 | 1–3 | Four or more with `ANY` widens back toward the unfiltered catalogue. |
| Filter order | BPM → instrument → mood | — | Mood last; it is the narrowing pass. |
| Healthy result count | 30–300 | 10–500 | Over 2000: under-filtered, add a mood or an instrument. Under 10: over-filtered, relax mood first — never BPM. |
| `vocals` | `false` under narration | true/false | Applied alongside mood, not instead of it. |
| Zero-result meaning | bad slug | — | Verified: an unrecognised mood slug returns `meta.total: 0`. The filter fails closed, so zero means fix the word. |
| Slug source of truth | a returned tag | — | Never invent a slug. Read it off a result's `tags[].displayName` and hyphenate. |
| Exclusion moods | none | 0–2 | Typically `dark` or `sad` excluded from upbeat sections. |

## Reproduction prompt
```
Apply the mood axis to a music search that already has a BPM window.

INPUT: a music brief with {bpm:{min,max}, moods:[...], vocals:bool} for this
section (see the emotion-and-pace diagnosis note if one does not exist).

1. VALIDATE EVERY MOOD SLUG BEFORE USING IT. Run the query with that slug alone
   and first:1. If meta.total is 0, the slug is wrong - the filter fails closed,
   it does not silently ignore unknown values. Fix it by searching a term that
   describes the feeling, reading tags[] off a result, and taking the displayName
   of a tag whose dimension.name is exactly "mood", lowercased and hyphenated.
   Words like build, drama, mystery, pulses, action, acoustic are production-genre
   tags, NOT moods - they will return zero through moodSlugs.
2. COMPOSE THE THREE-AXIS QUERY in one call:
   filter = { bpm:{min,max}, moodSlugs:{matchType:"ANY", values:[<1-3 slugs>]},
              vocals:<bool>, featuredInstrumentSlugs:{...} (optional) }
   sort = { by:"POPULARITY", order:"DESCENDING" }, first: 20
3. READ meta.total AS A HEALTH CHECK. Over 2000 -> add a second mood or an
   instrument. Under 10 -> remove a mood, or switch matchType from ALL to ANY.
   Do NOT widen the BPM window to fix a mood problem.
4. ADD EXCLUSIONS RATHER THAN RE-SEARCHING. If the shortlist keeps returning the
   wrong emotional colour, add moodSlugs matchType NOT_ANY with the offending
   slug in a second pass rather than starting over.
5. RECORD WHAT YOU USED. Write the exact filter object into the project's music
   brief alongside the chosen recording id, so the search is reproducible and the
   next section can reuse the axes it should keep.
6. ACCEPTANCE TEST: the shortlist is 10-500 long; every returned track's tags
   include at least one of your mood slugs; every track's bpm is inside the
   window; and if the section has narration, every track's vocal type is
   "no vocals". Then audition against picture, never in isolation.
```

## Execution spec

**Epidemic Sound.** The full verified filter surface for `SearchRecordings`, which is what makes a three-axis query possible in a single call:

| Filter | Shape | Notes |
|---|---|---|
| `bpm` | `{min, max}` | `recording.bpm` returns as an exact integer. |
| `moodSlugs` | `{matchType, values[]}` | ALL / ANY / NOT_ANY. The mood dimension only. |
| `featuredInstrumentSlugs` | `{matchType, values[]}` | e.g. `acoustic-guitar`, `accordion`, `electronic-drums`. |
| `taxonomySlugs` | `{matchType, values[]}` | Genre, decade, world country — **not** mood. |
| `vocals` | boolean | The vocals-vs-instrumental rule, as a filter. |
| `musicalKeys` | `[slug]` | e.g. `c-minor`, `d-major`. |
| `duration` | `{min, max}` ms | |
| `artistSlugs`, `recordingIDs`, `tagSlugs` | `{matchType, values[]}` | `tagSlugs` is free-form and unreliable across dimensions — prefer `moodSlugs` and `taxonomySlugs`, and always verify by reading `tags[]` off the results. |

```json
// the canonical three-axis call
{ "filter": { "bpm": { "min": 100, "max": 120 },
              "moodSlugs": { "matchType": "ANY", "values": ["mysterious", "suspense"] },
              "vocals": false },
  "sort": { "by": "POPULARITY", "order": "DESCENDING" }, "first": 20 }
```
Every result carries `tags[]` with `displayName` and `dimension.name`, plus `stems[]` (DRUMS, BASS, MELODY, INSTRUMENTS, VOCALS) — which is where [[sfx-music-stem-layering]] picks up. `DownloadRecording` produces the local file; placement is then ordinary HyperFrames.

**Hyperframes.** Mood does not survive into the composition as anything but a level and a carve. Place the bed at the root with `data-audio-group="music"`, a `data-volume` around 0.6, and `data-fx-carve` against the `voiceover` group at strength 0.25, then run `carve.mjs`. Record the mood slugs in `STORYBOARD.md` so the choice is auditable later.

**ffmpeg.** Nothing mood-specific. Loudness matching between two tracks of different moods, when they must sit at the same perceived level, is the two-pass `loudnorm` measure-then-apply.

**Remotion.** Not applicable — this is a sourcing decision, upstream of any renderer.

### Facet upgrade — Moods is facet 1 of 6, and it is never the whole query
The UI filter bar read off `editing kt 3` is **`Moods | Genres | Duration | BPM | Vocals | Key`**. Two consequences for this note's recipes. First, **Moods is a first-class facet**, not a search word — a mood typed into the query box is matched as text against titles and descriptions, while `filter.moodSlugs` matches the catalogue's own dimension; those are different queries with different result sets. Second, the observed workflow is *term in the box, then narrow by BPM and Vocals*, so a mood filter should always arrive with at least those two beside it:

```
filter: { moodSlugs: { matchType: ANY, values: ["<discovered>", "<discovered>"] },
          bpm:      { min: 105, max: 115 },
          vocals:   false,
          duration: { min: 75000 } }        # ms
```
`matchType: ALL` on two moods is usually over-constrained; `ANY` on two or three related moods is the reliable shape, and `NOT_ANY` is the honest way to exclude a mood the profile rejects rather than filtering results afterwards. Slugs are still **discovered, never invented** — run the term alone, read back `tags[].displayName` where `dimension.name == "mood"`, and record what you used. [[sfx-epidemic-facet-query]] carries the full facet-to-parameter map.

## Pairs with
[[sfx-bpm-filter-first]] · [[sfx-instrument-filter-search]] · [[sfx-emotion-and-pace-diagnosis]] · [[sfx-music-audition-against-picture]] · [[sfx-find-similar-track-handover]] · [[sfx-track-change-at-section-boundary]] · [[sfx-beat-forward-bed-under-voice]] · [[sfx-music-stem-layering]] · [[sfx-mood-map-per-topic]] · [[sfx-emotion-music-lookup-table]] · [[sfx-vocabulary-llm-expansion]] · [[sfx-epidemic-facet-query]]

## Failure modes
- **Using a production-genre word as a mood.** `build`, `drama`, `pulses`, `action` are real tags in a different dimension; through `moodSlugs` they return nothing, and the natural reading of an empty result is "the library has nothing like this". Validate slugs one at a time.
- **Treating zero results as an empty catalogue.** The filter fails closed on unknown slugs. Zero almost always means a typo, not a gap.
- **Mood first.** Filtering the whole catalogue by feeling returns tracks at every tempo, most of which cannot sit under this narration at all. BPM is the hard constraint; mood is the taste pass.
- **Four or more moods with `ANY`.** Each added mood widens the union; past three the filter has stopped filtering.
- **Widening BPM to rescue a mood.** Guarantees the pace mismatch the whole three-parameter method exists to prevent. Relax mood instead.
- **Letting the footage choose the mood.** The source's point is that the editor decides. Deciding by default — taking whatever the first plausible track suggests — is how a video ends up with no point of view.
- **Applying mood filters to sound effects.** The SFX catalogue has no mood dimension; `SearchSoundEffects` accepts only `tagSlugs`, `duration` and `soundEffectIDs`. Emotional intent there is a family choice plus treatment.
