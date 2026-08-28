---
id: sfx-search-vocabulary
title: The bottleneck is the name, not the file — the intent-to-query lookup
skill: sound-design
type: sfx
family: sfx-sourcing
tags: [skill/sound-design, type/sfx, family/sfx-sourcing, layer/sfx, layer/ambience, engine/epidemic, engine/ffmpeg, engine/hyperframes, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:00:00"
    quote: "Man, I need a sound effect, something that gives suspense. I don't get how to apply it. — Should I just search the name on YouTube? You'll find it."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:00:09"
    quote: "But what name do I search? I don't know the name of a single sound effect."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:09:42"
    quote: "besides YouTube there are other platforms too, like freesound.org or Pixabay, where you'll get free sound effects."
research_refs:
  - https://universalcategorysystem.com/
  - https://www.epidemicsound.com/sound-effects/
  - https://ffmpeg.org/ffmpeg-filters.html#astats
  - https://ffmpeg.org/ffmpeg-filters.html#silencedetect
difficulty: low
detectable_from: audio
---

# The bottleneck is the name, not the file — the intent-to-query lookup

## What it is
Almost every sound effect anyone needs already exists and is findable by search. The thing that stops an editor is not the library and not the budget — it is that the editor knows what the moment should *feel* like and does not know what that sound is *called*. The source opens on exactly that gap: someone needs "something that gives suspense", is told to just search the name, and answers *"but what name do I search? I don't know the name of a single sound effect."* The named families in the rest of that video — whoosh, swoosh, riser, ambience, motion, cartoon, intimate, hit and impact, whip, Foley — are the vocabulary, and learning the vocabulary is the first skill, ahead of any mixing craft.

For an unattended pipeline this stops being a learning problem and becomes a **resolution table**. A design document says "build tension before the reveal"; something has to turn that into a library query. This note is that lookup, in both directions:

- **Forward** (design → asset): described intent → family name → query terms → category filter → duration filter.
- **Backward** (reference → design): a sound heard in a reference video → its family, by measurable acoustic signature → the name that will find it again.

Two naming systems are worth knowing. **UCS — the Universal Category System** — is *"a public domain initiative"* whose stated purpose is to *"provide and encourage the use of a set category list for the classification of sound effects"*: a fixed Category / SubCategory list with short `CatID` abbreviations (e.g. `WOODHndl`) baked into filenames. It is the cross-library standard, and where a supplier ships UCS-named files the CatID is a more reliable search key than any free-text term. But **Epidemic Sound**, the sanctioned source in this project, does not use UCS — it has its own category tree, and that tree is the vocabulary this note actually resolves to.

The related but distinct problems are owned elsewhere: whether a candidate earns a slot at all is [[sfx-placement-discipline]]; auditioning two candidates against picture is [[sfx-ab-audition-candidates]]; turning one file into several variations by reverb, pitch and duration is also [[sfx-placement-discipline]]; per-family craft lives in the family notes ([[sfx-whoosh-transition-movement-reveal]], [[sfx-riser-anticipation-build]], [[sfx-cinematic-hit-emphasis]], [[sfx-cartoon-comedy-family]], [[sfx-record-scratch-punctuation]], [[sfx-whip-crack-on-snap-cut]], [[sfx-ambience-bridge-across-cut]]).

**Style.** No `sfx/` style tag: the lookup spans the whole vocabulary — Foley and ambience terms on the diegetic side, whoosh and swish on the motion side, riser and braam on the aesthetic side — and choosing between those groups happens earlier, in [[sfx-three-types-classification]].

## When to use it
- Every time a design row names a sound by its *effect* rather than by its name — "something ominous", "make this land", "a little sparkle here". Resolve it before the sourcing pass starts.
- At the start of any sound pass, to turn the spotting list into a batch of concrete queries that can be fetched in one go.
- In Mode A, when logging a reference video's sound design: the design document has to name each sound in a way a later fetch can act on, and "a whooshy thing at 0:42" is not that.
- When a search returns nothing useful. Nine times out of ten the term was wrong, not the library — try the family's synonyms and the category filter before concluding the sound does not exist.

**The lookup table.**

Epidemic Sound category slugs are verified from its own sound-effects index. `filter.duration` is in **milliseconds** in the MCP schema.

| Described intent | Family | Query terms (try in this order) | Epidemic category slug | Duration (ms) |
|---|---|---|---|---|
| "build tension", "something is coming", "before the reveal" | **Riser** | `riser`, `rise`, `build up`, `uplifter`, `swell`, `tension riser` | `designed/riser` | 1500–6000 |
| "fast transition", "sweep between shots", "text flies in" | **Whoosh** | `whoosh`, `swoosh`, `swish`, `transition whoosh`, `air whoosh` | `swooshes/whoosh`, `swooshes` | 200–1500 |
| "punctuate this", "make the moment land", "big" | **Hit / impact** | `impact`, `hit`, `cinematic hit`, `boom`, `braam`, `slam`, `stinger` | `designed` | 500–4000 |
| "mystery", "dread", "something underneath" | **Tone / drone** | `drone`, `sub drone`, `dark tone`, `atmosphere`, `texture`, `pad` | `designed` | 5000–60000 |
| "make this funny", "comic beat" | **Cartoon** | `boing`, `pop`, `slide whistle`, `spring`, `plop`, `record scratch`, `sad trombone` | `cartoon` | 200–3000 |
| "the scene feels empty / has no place" | **Ambience** | `room tone`, `ambience`, `city traffic ambience`, `cafe crowd`, `birds forest`, `wind` | `ambience`, `weather`, `crowds`, `birds` | 8000–120000 |
| "he picks it up / walks / shifts in the chair" | **Foley** | `footsteps`, `cloth movement`, `cloth rustle`, `object handling`, `pick up put down` | `footsteps`, `cloth`, `objects` | 200–3000 |
| "button press", "notification", "toggle", "app UI" | **User interface** | `click`, `tap`, `notification`, `toggle`, `swipe`, `error`, `success` | `user-interface` | 50–1200 |
| "anxious", "tense body", "time running out" | **Intimate** | `heartbeat`, `heartbeat fast`, `clock ticking`, `heavy breathing`, `breath` | `human`, `clocks` | 1000–20000 |
| "old-school action snap", "fast cut with a bite" | **Whip** | `whip crack`, `whip`, `whipcrack` | (term only; no dedicated category) | 200–1200 |
| "typing", "coding", "at the computer" | **Computers** | `keyboard typing`, `mechanical keyboard`, `mouse click`, `hard drive` | `computers` | 500–15000 |
| "magic", "power-up", "sparkle" | **Magic** | `magic sparkle`, `shimmer`, `power up`, `magic whoosh` | `magic` | 300–3000 |
| "glitch", "error", "digital break" | **Distortion / designed** | `glitch`, `digital glitch`, `static`, `interference`, `data corrupt` | `designed`, `computers` | 200–3000 |
| "gun / explosion / fight" | **Weapons / destruction** | `gunshot`, `explosion`, `punch impact`, `debris` | `guns`, `explosions`, `fight`, `destruction` | 300–6000 |
| "vehicle passing / engine" | **Vehicles / motors** | `car pass by`, `engine start`, `engine idle` | `vehicles`, `motors` | 1000–30000 |

Epidemic's full category list, verified, for when the intent does not map to a row above: Air, Aircraft, Alarms, Ambience, Animals, Beeps, Bells, Birds, Boats, Bullets, Cartoon, Ceramics, Chains, Chemicals, Clocks, Cloth, Communications, Computers, Creatures, Crowds, Designed, Destruction, Dirt & Sand, Doors, Drawers, Electricity, Equipment, Explosions, Farts, Fight, Fire, Fireworks, Food & Drink, Footsteps, Games, Geothermal, Glass, Gore, Guns, Horns, Human, Ice, Lasers, Leather, Liquid & Mud, Machines, Magic, Mechanical, Metal, Motors, Movement, Musical, Natural Disaster, Objects, Paper, Plastic, Rain, Robots, Rocks, Rope, Rubber, Scifi, Snow, Sports, Swooshes, Tools, Toys, Trains, User Interface, Vegetation, Vehicles, Voices, Water, Weapons, Weather, Whistles, Wind, Windows, Wings, Wood.

The source's own two learning routes still apply where the table does not reach: **practice** — the more you browse, the more names you own — and **ask a language model**, prompted at the register you need ("funny name sound effects"). Free fallbacks it names: **freesound.org** and **Pixabay**, plus plain YouTube search.

## How to recognise it in a reference video
The backward direction. Given a sound in a reference, classify it into a family so the design document can name a query. Each family has a measurable signature; measure with a windowed peak/RMS trace and a spectral read:
```bash
ffmpeg -ss <t> -t 2 -i ref.mp4 -af "astats=metadata=1:reset=1:length=0.02,\
ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null -
ffmpeg -i ref.mp4 -af "silencedetect=n=-45dB:d=0.30" -f null - 2>&1 | grep silence_
```

- **Whoosh / swoosh** — *sustain-dominated*. Broadband, 200–1500 ms, energy peak in the **middle** of its own body, spectral centroid rising then falling. Anchored to the middle of a movement, not to a frame.
- **Whip** — *transient-dominated*. Attack under ~10 ms (it is literally a small sonic boom — the tip breaks the speed of sound), tail under 300 ms, energy concentrated 2–8 kHz. Anchored to an instant.
- **Hit / impact** — attack under 15 ms, **long** decay (0.5–4 s), dominant energy below 200 Hz, often with a reverb tail.
- **Riser** — monotonic **rise** in level and/or pitch over 1.5–6 s, terminating in a drop or a hit. If the level does not rise monotonically it is a drone, not a riser.
- **Tone / drone** — sustained 5 s or longer, near-constant level (crest factor low and steady), minimal spectral movement, sits under everything.
- **Cartoon** — clearly pitched and harmonic, obviously non-natural: a glissando (boing, slide whistle) or a single pitched blip (pop, plop). 200 ms–3 s.
- **Ambience** — continuous, **no discrete events aligned to picture**, and its level in the dialogue gaps sits at **−45 to −60 dBFS**. Digital silence in the gaps means there is no ambience pass at all.
- **Foley** — discrete events tightly aligned to visible body or object motion, mid-band, short, and *not* on the beat grid. The alignment to picture is the tell.
- **UI** — under 300 ms, pitched, quiet, aligned to a graphic appearing rather than to a physical motion.

Log each identified sound as `timecode | family | query term to re-source | duration (ms) | layer`. That row is directly executable by the sourcing pass.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `terms_per_intent` | 3 | 2–5 | Try the family's synonyms before widening the category. |
| `candidates_per_slot` | 5 | 3–10 | Fetch a handful, then audition against picture per [[sfx-ab-audition-candidates]]. |
| `duration_filter` | per the table (ms) | — | The single highest-yield filter. A 30-second "whoosh" is a drone that was mis-tagged. |
| `sort` | `RELEVANCE` first pass, `POPULARITY` second | RELEVANCE · POPULARITY · DATE · DURATION · TITLE | Popularity surfaces the library's workhorses; relevance surfaces the odd ones. |
| `tag_match_type` | `ANY` for discovery, `ALL` to narrow | ALL · ANY · NOT_ANY | `NOT_ANY` is the underused one — use it to exclude `music` or `loop` tags from an SFX search. |
| `distinct_files_per_family` | 3 | 2–6 | So a repeated whoosh is never the same file twice — the source's explicit warning. |
| `naming_convention_on_disk` | `<family>-<descriptor>-<nn>.wav` | — | Store under `assets/sfx/` (or `.media/audio/sfx/`) with the family in the filename, so the next project inherits the vocabulary. |
| `record_query_in_design_doc` | required | — | The query string, not just the file path. A file path cannot be re-sourced; a query can. |

## Reproduction prompt

```
Resolve every sound-effect intent in {{DESIGN_DOC}} into concrete library
queries and fetch candidates. Do not place anything yet.

1. Build the spotting list: one row per intended sound, each with a timecode,
   a one-line description of the INTENT ("build tension before the reveal"),
   and the layer it belongs to (dialogue / ambience / foley / sfx / music).
2. For each row, resolve INTENT -> FAMILY using the lookup table in this
   note. If no row matches, pick the closest Epidemic category from the full
   category list and record that you improvised.
3. For each row emit a query: the family's first query term, the category
   slug as a tag filter, and the duration window in MILLISECONDS. Example
   for "build tension before the reveal":
     query.term          = "riser"
     filter.tagSlugs     = { matchType: "ANY", values: ["designed", "riser"] }
     filter.duration     = { min: 1500, max: 6000 }
     sort                = { by: "RELEVANCE", order: "DESCENDING" }
     first               = 5
4. Run the search. If it returns nothing usable, retry with term 2 then
   term 3 from the family's synonym list BEFORE widening the duration window
   or dropping the category filter. Only conclude the sound does not exist
   after all three terms have failed.
5. Where the same family is needed three or more times in the video, fetch at
   least 3 DISTINCT files for it. Reusing one file repeatedly is audible and
   is called out explicitly in the source as a mistake.
6. Download to assets/sfx/ naming each file <family>-<descriptor>-<nn>.wav.
7. Write back into the design doc, per row: family, the exact query string
   used, the chosen file path, and its duration in ms. The QUERY is the
   durable artefact - a path cannot be re-sourced, a query can.
8. ACCEPTANCE TEST: every row in the spotting list has a family, a query
   string and a file. No family used 3+ times maps to fewer than 3 distinct
   files. Every fetched file's duration falls inside its family's window from
   the table - a file outside it was mis-tagged and must be re-searched.
```

## Execution spec

**Epidemic Sound (the sourcing engine).** `SearchSoundEffects` is the tool, and its real shape is: `query.term` (free text), `filter.tagSlugs {matchType: ALL|ANY|NOT_ANY, values: [...]}`, `filter.duration {min, max}` in **milliseconds**, `filter.soundEffectIDs`, `sort {by: RELEVANCE|POPULARITY|DATE|DURATION|TITLE, order}`, `first`, `after`. Results carry `SoundEffect { id, title, audioFile { durationInMilliseconds, lqmp3Url, waveformUrl }, tags { displayName, slug } }`.

```jsonc
// "build tension before the reveal" -> Riser
{
  "query":  { "term": "riser" },
  "filter": { "tagSlugs": { "matchType": "ANY", "values": ["designed", "riser"] },
              "duration": { "min": 1500, "max": 6000 } },
  "sort":   { "by": "RELEVANCE", "order": "DESCENDING" },
  "first":  5
}
```

Two things worth exploiting. The returned `tags` on each result are the library's own vocabulary for that file — **harvest them**, because they are better search terms than anything guessed, and feeding one back as a `tagSlugs` value is how a single good hit becomes a shortlist. And `SearchSimilarToSoundEffect` takes an approved effect and returns neighbours, which is the cheapest way to satisfy the three-distinct-files rule.

`DownloadSoundEffect` produces a local file and **stops there**. Optionally ledger it like any other asset:
```bash
node <SKILL_DIR>/scripts/resolve.mjs --from assets/sfx/riser-tension-01.wav --type sfx --project .
```

**HyperFrames (placement, for completeness).** Sourcing ends at a file; placement is a clip. Give it an `id` — an id-less `<audio>` is **never mixed**, producing a silent render with no error — put it on `data-track-index` 10+, and give it its own audio group (`sfx`), never the voice group:

```html
<audio id="sfx-riser-1" src="assets/sfx/riser-tension-01.wav"
       data-audio-group="sfx" data-start="61.2" data-duration="3.0"
       data-media-start="0.4" data-track-index="12" data-volume="0.45"></audio>
```
Keep two overlapping `<audio>` elements off the same track index (`duplicate_audio_track`). `data-media-start` trims into the file without cutting it — the right way to drop a riser's slow head.

**ffmpeg.** Classification and QC only, plus the variation trick when the library gives you one file and you need three (pitch, duration and reverb — the mechanics live in [[sfx-placement-discipline]], and in HyperFrames the reverb is a `data-fx-chain` node, not an ffmpeg pass).
```bash
ffprobe -v error -show_entries format=duration -of csv=p=0 assets/sfx/riser-tension-01.wav
ffmpeg -i cand.wav -af "astats=metadata=1:reset=1:length=0.02,ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null -
```

**Remotion:** irrelevant — sourcing is engine-agnostic. Not present in this project.

## Pairs with
[[sfx-placement-discipline]] · [[sfx-ab-audition-candidates]] · [[sfx-sound-pass-order]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-riser-anticipation-build]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-cartoon-comedy-family]] · [[sfx-whip-crack-on-snap-cut]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-air-on-micro-movement]] · [[sfx-record-scratch-punctuation]] · [[sfx-mood-map-per-topic]] · [[sfx-ten-family-catalogue]] · [[sfx-foley-family]]

## Failure modes
- **Searching the intent instead of the family.** Typing "suspense sound" returns music. Typing "riser" returns risers. Fix: always resolve intent → family → term; never query the intent verbatim.
- **No duration filter.** The single most wasteful omission. Without it, a "whoosh" search returns 40-second whoosh *loops* and designed drones. Fix: apply the family's millisecond window on every search.
- **Giving up after one term.** A family has three or four common names; the library indexes some and not others. Fix: exhaust the synonym list before widening.
- **Recording only the file path.** Six months later the path is stale and nobody knows what to search for. Fix: the design document stores the query string, the family and the duration window.
- **One file used repeatedly.** *"Don't use the same whoosh sound there. It sounds really odd, people pick up on it."* Fix: three distinct files per family, or generate variations by pitch, duration and reverb.
- **Putting SFX in the voice group.** A carve group must contain voices only; a bed or an SFX clip inside it poisons the next re-analysis **silently**. Fix: SFX go in their own group.
- **Assuming UCS names will work as queries.** UCS `CatID`s are a filename standard for suppliers who adopt it, not a search vocabulary for Epidemic. Fix: use UCS when the files on disk are UCS-named; use Epidemic's own category slugs against Epidemic.
- **Known gap:** the full UCS Category/CatID list is not available offline in this project — the initiative's own site distributes it as a separate download, and the execution contract's egress constraints mean it should not be assumed reachable. The Epidemic category list in this note is verified and is the working vocabulary; treat UCS as a naming convention to honour on disk rather than a table to query against.
