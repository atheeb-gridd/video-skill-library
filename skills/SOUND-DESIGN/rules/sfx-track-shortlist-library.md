---
id: sfx-track-shortlist-library
title: Favourite as you go — the personal track shortlist as queryable data
skill: sound-design
type: music
family: library
tags: [skill/sound-design, type/music, family/library, layer/music, engine/epidemic, engine/ffmpeg, source/editing-kt-3, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:04:36
    quote: "Whatever tracks you're liking, you can hit like and save them, so they come in handy later."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:05:10
    quote: "Here you can search music by speed, emotion, instrument. And if you like a track, there's a \"find similar\" option to get more music like it."
research_refs:
  - mcp://Epidemic_sounds/SearchRecordings (filter.recordingIDs re-hydration verified live, 2026-08-28)
  - mcp://Epidemic_sounds/SearchSimilarToRecording
  - https://en.wikipedia.org/wiki/Tempo
difficulty: low
detectable_from: transcript
---

# Favourite as you go — the personal track shortlist as queryable data

## What it is
Selection cost is the largest single time sink in music work, and it compounds *down* if you capture every promising track at the moment you hear it. The source's version is one line — *"whatever tracks you're liking, you can hit like and save them, so they come in handy later"* — and the point is that the next project then starts from a curated, pre-auditioned shortlist instead of a cold search.

The version that matters for an **agent** is different in one important way, and it is worth stating plainly because it changes the whole design: **the "like" button is not reachable from this stack.** The Epidemic Sound MCP surface here is `SearchRecordings`, `SearchSimilarToRecording`, `DownloadRecording`, `EditRecording`, `SearchExternalReferences` and the SFX/voice equivalents. There is no favourites API, no collections API, and no way to read a list saved in the web UI. A human's likes and an agent's shortlist are two different stores.

So the shortlist has to be **a local file the agent writes and reads**, and the design hinges on one verified capability: `SearchRecordings` accepts `filter.recordingIDs` as a list of UUIDs and re-hydrates them in a single call — probed live on 2026-08-28 with two ids, returning exactly those two with full metadata (`bpm`, `tags` with dimensions, `stems`, `credits`, `durationInMilliseconds`, preview URLs). That makes a plain CSV of UUIDs a fully-functional music library: **the file stores the judgement, the API stores the metadata**, and one call joins them.

The shortlist's real value is not "tracks I liked". It is **tracks I liked, with the reason, at a known BPM, mood and vocals flag** — because that is exactly the query shape the search funnel wants ([[sfx-three-parameter-music-search]]). A row without those fields is a bookmark; a row with them is an index.

## When to use it
- **Every time you audition music for a project.** Capture the near-misses, not only the winner. The near-miss is the highest-value row in the file: it was good enough to consider and it costs nothing to keep, and its BPM/mood combination is proof that combination exists in the catalogue.
- **Before every new music search.** Query the shortlist first. If a row already matches the mood-map segment's `bpm_band` + `mood` + `vocals`, use it — a re-used track is a *free* selection, and repeated use of the same small set of tracks is how a channel acquires a sonic identity rather than a defect.
- **Immediately after a track works on picture.** Promote its row: record the project, the segment type, and the measured downbeat offset. That last field turns a re-use from a 10-minute job into a 30-second one ([[sfx-bpm-perceptual-bands]]).
- **When `SearchSimilarToRecording` returns a good sibling set.** Capture the whole set, not just the one you used — that is a texture family, and texture families are what make the third and fourth video sound like the first.
- **Not** as a substitute for the mood map. The shortlist answers "do I already own something for this?"; it does not answer "what should this section feel like?"

## How to recognise it in a reference video
This is a workflow, so the evidence is a **pattern across a creator's catalogue**, not a moment inside one video.

- **Track repetition across videos.** Identify the music in three or more videos from the same creator. A shortlist-driven creator re-uses tracks — typically **2–6 recurring beds** across a year — while a cold-search creator uses a different track every time and their videos do not sound related.
- **Artist and label clustering.** Log the composer/artist credits (Epidemic returns `credits` with `MAIN_ARTIST`, `COMPOSER`, `PRODUCER`). Repeated artists across unrelated videos is a strong shortlist signal, because "find similar" and favouriting both converge on artists.
- **Narrow BPM spread.** Measure BPM across a creator's last ten videos. A shortlist user clusters inside one or two bands (the source's own **100–120**); a cold searcher scatters across 70–160.
- **Consistent mood vocabulary.** The same three or four moods recur — "determined", "hopeful", "driving" — rather than a new emotional colour every video.
- **Fast section handovers.** Because the alternatives were already auditioned, shortlist users change track *at* section boundaries confidently and often; cold searchers tend to run one track for the whole video because finding a second was expensive.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Store | `_profiles/<creator>/music-shortlist.csv` | — | One per creator/channel identity, not one per project. Plain CSV so it is greppable and diffable. |
| Join key | Epidemic `recording_id` (UUID) | — | The only stable identifier. Titles collide and change; ids do not. |
| Rows captured per audition session | 5 | 3–15 | Capture near-misses. Below 3 the file never becomes useful. |
| Re-hydration batch size | 50 ids per `SearchRecordings` call | 1–100 | `filter.recordingIDs` verified working; `meta.total` equals the id count, so a mismatch means a dead id. |
| Required columns | 9 (see schema) | — | `recording_id, title, bpm, vocals, moods, genres, duration_s, verdict, note`. |
| Recommended columns | +5 | — | `downbeat_offset_s, used_in, segment_type, similar_seed_id, added` — these are what make it faster than a fresh search. |
| `verdict` vocabulary | `won` \| `runner-up` \| `texture` \| `rejected-fit` \| `rejected-quality` | — | Keep rejections. Knowing a track was rejected for *fit* not *quality* saves re-auditioning it. |
| Deletion policy | **never delete a row** | — | The mounted vault *"cannot delete files"*; supersede with a `status` column instead. Applies to rows as well as files. |
| Shortlist size before it pays for itself | 30 rows | 20–60 | Below 20, a fresh search is usually faster. |
| Refresh cadence | re-hydrate before each project | — | Catalogue metadata changes; ids do not. One call, 50 ids. |
| Local audio cached? | no — store ids, not files | — | Cache only tracks actually used, under `.media/audio/bgm/`, named `<recording_id>.mp3`. |

**The schema, written out once:**

```csv
recording_id,title,bpm,vocals,moods,genres,duration_s,verdict,note,downbeat_offset_s,used_in,segment_type,similar_seed_id,added,status
c1635400-4b95-4fa1-bdcf-1f4e185ed638,Be My Lover (Instrumental Version),110,false,happy|laid back,k-pop|pop,174.6,runner-up,too bright for a serious open,,,intro,,2026-08-28,active
ca1a8bcd-76b8-4926-af4e-2eca0cdec2c3,Monsieur Cat Walk,116,false,funny|quirky,comedy|children's music,144.1,texture,use for the objection bit only,0.184,ep-14,objection,,2026-08-28,active
```

`moods` and `genres` are pipe-separated because Epidemic returns them as a `tags` array whose entries carry `dimension.name` ∈ `mood` · `genre` · `production genre` · `vocal type`. Split on that dimension when you write the row; do not flatten them into one column.

## Reproduction prompt
```
Maintain the music shortlist at {{STORE}} (default
_profiles/<creator>/music-shortlist.csv) and query it before any new music search.

READ PATH - do this FIRST, every time a mood-map row needs a track.
1. Load {{STORE}}. Filter rows where status=active AND vocals matches the segment's
   vocals flag AND bpm falls inside the segment's band (band 3 = 100-120) AND moods
   intersects the segment's mood slugs.
2. If 1 or more rows match, re-hydrate them in ONE call:
     SearchRecordings { filter: { recordingIDs: [<up to 50 uuids>] }, first: 50 }
   Verified: meta.total equals the number of live ids, so total < len(ids) means one
   or more ids are dead - mark those rows status=dead (do NOT delete the row).
3. Audition the matches against picture at -22 dB rel dialogue. If one works, stop.
   You have just skipped an entire search.
4. Only if nothing matches, run the full three-parameter funnel.

WRITE PATH - after every audition session, win or lose.
5. For every track you played for more than ~15 seconds, append a row. Fill from the
   API response, not from memory:
     recording_id  <- node.recording.id
     bpm           <- node.recording.bpm            (integer, exact - never re-tap it)
     duration_s    <- node.recording.audioFile.durationInMilliseconds / 1000
     moods         <- tags where dimension.name == "mood",  joined with |
     genres        <- tags where dimension.name in ("genre","production genre")
     vocals        <- true unless a "no vocals" tag is present under "vocal type"
     verdict       <- won | runner-up | texture | rejected-fit | rejected-quality
     note          <- ONE clause on why. "too bright for a serious open" is useful;
                      "nice" is not. A row with no note is a bookmark, not an index.
     added         <- today's date
     status        <- active
6. For the WINNER only, additionally record downbeat_offset_s (measure it - the file
   almost never starts on beat 1), used_in, and segment_type.
7. If you used SearchSimilarToRecording to find it, record similar_seed_id. Capture
   the whole sibling set as rows, not just the winner - that set is a texture family.

NEVER DELETE A ROW. The mounted vault cannot delete files, and a rejection is data.
Supersede by setting status=superseded|dead and appending a new row.

ACCEPTANCE TEST.
(a) Every row has a non-empty note and a verdict.
(b) Re-hydrating every active id in one call returns meta.total == the id count.
(c) At least one row in the last three projects was re-used rather than freshly found.
(d) BPM values came from the API's integer field, not from tapping.
```

## Execution spec

**Placement spec.** This note produces no placed sound of its own; it feeds every note that does. The placement numbers a shortlist row carries forward are: **music bed at −22 dB rel. dialogue** (`data-volume="0.079"`; −30 dB / `0.032` for loud guitars), **bed starts on the segment boundary**, **`data-media-start` = the row's `downbeat_offset_s`**, and **duck by carve against the `voiceover` group at `strength` 0.25**, never by a plain fader dip.

**Epidemic Sound — the three calls this workflow uses, in order.**

```
# 1. READ: re-hydrate the shortlist. Verified live 2026-08-28 with 2 ids -> meta.total: 2.
SearchRecordings { filter: { recordingIDs: ["c1635400-…","ca1a8bcd-…"] }, first: 50 }

# 2. MISS: the full funnel, when nothing in the shortlist fits.
SearchRecordings {
  filter: { bpm: { min: 100, max: 120 },
            moodSlugs: { matchType: ANY, values: ["hopeful","determined"] },
            featuredInstrumentSlugs: { matchType: ANY, values: ["acoustic-guitar","piano"] },
            vocals: false },
  sort: { by: POPULARITY, order: DESCENDING }, first: 15 }

# 3. EXPAND: turn one winner into a texture family worth several rows.
SearchSimilarToRecording { id: "<winner uuid>", first: 12 }
```

Fields worth persisting that are easy to miss: `stems` tells you whether DRUMS / BASS / MELODY / INSTRUMENTS / VOCALS / CLEAN_VOCALS exist for that track — that is the difference between a track you can thin under narration and one you cannot ([[sfx-music-stem-layering]]). `credits` gives artist ids and slugs, and `filter.artistSlugs` accepts them, so a shortlist that records artists can later ask the catalogue for "more from the people I keep choosing". `audioFile.lqmp3Url` is a low-quality preview — fine for auditioning, **never** for the final bed; use `DownloadRecording` for the real file.

**Local storage and the vault's one hard constraint.** *"The mounted vault folder cannot delete files."* Therefore:
- The shortlist is **append-only**. Corrections are new rows plus a `status` change on the old one; there is no delete and no in-place row removal workflow that can be relied on.
- Keep scratch work — download temp dirs, dedupe intermediates — **outside** the mount.
- Superseding a shortlist means writing `music-shortlist.csv` afresh and leaving the old copy in place, not removing it.

```bash
# query the shortlist without any tooling
awk -F, '$3>=100 && $3<=120 && $4=="false" && $15=="active"' _profiles/kt/music-shortlist.csv

# collect the ids for a re-hydration call
awk -F, '$15=="active"{print $1}' _profiles/kt/music-shortlist.csv | paste -sd, -

# cache a winner under its id so the row and the file agree
node <SKILL_DIR>/scripts/resolve.mjs --from .media/audio/bgm/c1635400-….mp3 --type bgm --project .
```

**ffmpeg — the one measurement a row should carry.** `downbeat_offset_s` is not in the API and is the field that saves the most time on re-use:
```bash
# isolate the kick, then read the first strong peak's timestamp off the trace
ffmpeg -i track.mp3 -af "lowpass=f=120" -ar 48000 -f wav - | \
ffmpeg -i - -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
```

**Remotion.** No equivalent — this is a data-store pattern, not a rendering one. Portability note only.

## Pairs with
[[sfx-three-parameter-music-search]] · [[sfx-bpm-perceptual-bands]] · [[sfx-bpm-filter-first]] · [[sfx-mood-vibe-filter]] · [[sfx-instrument-filter-search]] · [[sfx-find-similar-track-handover]] · [[sfx-mood-map-per-topic]] · [[sfx-emotion-music-lookup-table]] · [[sfx-library-build-and-taxonomy]] · [[sfx-library-quality-gate]] · [[sfx-music-stem-layering]] · [[sfx-source-licensing-and-clearance]] · [[sfx-music-audition-against-picture]]

## Failure modes
- **Saving titles instead of ids.** Titles are not unique, are edited, and cannot be re-hydrated. The UUID is the only thing that survives; a shortlist keyed on titles is a list of things you will search for again.
- **Rows with no note.** "Good track" tells the next reader nothing. One clause on *why* — the mood it served, or the reason it failed — is what makes the file an index rather than a bookmark bar.
- **Dropping the rejections.** A track rejected for *fit* is a track you will otherwise re-audition every six months. Keeping `rejected-fit` rows is most of the compounding.
- **Assuming the web-UI "likes" are available.** They are not exposed by any MCP tool here. If the human has favourited things in the browser, those must be transcribed into the CSV by hand once; there is no import.
- **Caching every audition as a file.** Downloads are large and the vault cannot delete. Store ids; download only what you place.
- **Re-tapping BPM by ear when the API returns it.** `recording.bpm` is an exact integer. Use it, and note in the row when your ear disagrees (half/double time) rather than overwriting it.
- **Letting the shortlist become the whole palette.** Re-use builds identity; total re-use builds monotony. One new track per project keeps the file growing.
- **Known gap — no favourites/collections API.** The MCP surface has search, similarity, download, edit and external references only. Any workflow that assumes reading a saved playlist from Epidemic will fail. The local CSV is the substitute, and it is the agent's only durable memory of a music decision.
- **Known gap — dead ids fail quietly.** A catalogue removal shows up only as `meta.total` being lower than the number of ids you sent. Compare the two on every re-hydration; nothing errors.
