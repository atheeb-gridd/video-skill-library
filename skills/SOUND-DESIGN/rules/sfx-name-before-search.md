---
id: sfx-name-before-search
title: Name the sound before you search for it
skill: sound-design
type: sfx
family: sfx-taxonomy
tags: [skill/sound-design, type/sfx, family/sfx-taxonomy, engine/epidemic, layer/sfx, layer/design, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:00:00"
    quote: "Should I just search the name on YouTube? You'll find it. - But what name do I search? I don't know the name of a single sound effect."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:05:19"
    quote: "How am I supposed to learn all these names? Tell me that. - Look, there are two ways. The first one is practice. The more you explore, the more things you keep learning."
research_refs:
  - https://en.wikipedia.org/wiki/Sound_effect
  - https://en.wikipedia.org/wiki/Walla
  - https://en.wikipedia.org/wiki/Room_tone
  - https://en.wikipedia.org/wiki/Diegesis
  - mcp://Epidemic_sounds/SearchSoundEffects (tag slugs and title grammar probed live, 2026-08-27)
difficulty: low
detectable_from: transcript
---

# Name the sound before you search for it

## What it is
Almost every sound an editor can imagine already exists in a licensed library and is one query away. What actually blocks the work is vocabulary: you cannot retrieve "the thing that makes it feel like something big is coming" until you know it is called a **riser**. This note is the resolver — it maps described intent to the library's own words, so the agent never types a description into a search box that only indexes names. Research adds the industry taxonomy underneath the creator's list: post-production sorts effects into **hard effects** (*"common sounds that appear on screen"*), **backgrounds/atmos** (*"do not explicitly synchronize with the picture, but indicate setting"*), **foley** (*"sounds that synchronize on screen"*), and **design effects** (*"sounds that do not normally occur in nature… used in a musical fashion to create an emotional mood"*). That four-way split maps cleanly onto the three styles this library is organised by.

**Style.** No `sfx/` style tag: the resolver's job is to route an intent into one of the three groups *before* a query is written, so it stands above them rather than inside one ([[sfx-three-types-classification]]).

## When to use it
Every time a design row says "needs a sound here" and does not yet name one. Run the resolver before touching `SearchSoundEffects`. Also run it in reverse during analysis: when you hear an effect in a reference video and need to log it, this table converts what you heard into the term you will search with later.

## How to recognise it in a reference video
This note is a lookup, so recognition means **identifying which family you are hearing**:

| What you hear | Family name | Style | Duration | Spectral signature |
|---|---|---|---|---|
| Broadband air rushing past, no pitch | **whoosh** | motion | 0.3–2.0 s | Filtered noise sweep, energy 500 Hz–8 kHz |
| Thinner, faster, higher air | **swoosh / swish** | motion | 0.15–0.8 s | Same shape, weighted above 2 kHz |
| Very fast crack with a tail | **whip** | motion | 0.3–1.5 s | Sharp transient + short air tail |
| Pitch or noise climbing for seconds | **riser / build up** | aesthetic | 2–15 s | Rising sweep on a spectrogram |
| One loud transient with a long decay | **impact / hit / cinematic hit** | aesthetic | 3–25 s | Broadband spike, sub energy, 2–8 s reverb tail |
| Sustained unpitched bed, no rhythm | **drone / texture / tone** | aesthetic | 30 s+ | Flat low-frequency band, no transients |
| Short musical punctuation | **stinger** | aesthetic | 1–4 s | Tonal, resolves |
| Continuous location sound | **ambience / atmos** | diegetic | 60 s+ | Steady noise floor with irregular events |
| Featureless "silence" of a room | **room tone** | diegetic | 60 s+ | Near-flat, no events |
| Indistinct crowd murmur | **walla** | diegetic | 60 s+ | Speech-band energy, no intelligible words |
| Footsteps, cloth, object handling | **foley** | diegetic | 0.2–20 s | Tight transients, dry |
| Boing, pop, slide, disc scratch | **cartoon** | motion/aesthetic | 0.2–2 s | Comic pitch bends |
| Heartbeat, breathing, clock tick | **intimate / human** | aesthetic | loopable | Low, rhythmic, close-mic'd |

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Candidates per query | 5 | 3–10 | *"Effects are cheap to audition and expensive to guess at."* |
| Terms per query | 3–4 | 2–6 | Epidemic titles are comma-delimited descriptor chains; extra words help. |
| Query grammar | `<family> <function> <character>` | — | e.g. `whoosh transition fast short light`. |
| Duration filter | family-dependent | see table above | In **milliseconds**. |
| Variations to pull per family | 3 | 2–5 | Feeds the no-repeat rule; see Failure modes. |

## Reproduction prompt

```
Resolve the described sound "{{INTENT}}" to a library query and fetch candidates.

1. CLASSIFY THE STYLE FIRST. Ask why the sound is there:
   - the scene would really make it            -> diegetic
   - something on screen is moving             -> motion
   - no physical or visual referent, pure feel -> aesthetic
   An unclassified effect is an unjustified effect; do not proceed without this.
2. RESOLVE THE FAMILY NAME using the recognition table in this note. Never send
   a description ("suspenseful build-up thing") as the search term. Send the
   family name.
3. BUILD THE QUERY as: <family> <function> <character>
     "whoosh transition fast short light"
     "riser transition build up suspenseful"
     "impact hit big cinematic"
     "ambience traffic highway"
   Epidemic titles read like "Designed, Whoosh, Transition, Riser, Fast, Short,
   Light, Pass By" - descriptor words in the query match those tokens directly.
4. CONSTRAIN DURATION in milliseconds from the recognition table, e.g.
   filter: { duration: { min: 300, max: 2000 } } for a whoosh.
5. PULL 5 CANDIDATES, audition each lqmp3Url against the picture, download the
   winner as WAV, and WRITE THE WORKING QUERY BACK into the design document.

ACCEPTANCE TEST: the chosen file's title contains the family name you searched
for, its duration falls inside the table's range for that family, and a second
agent given only your recorded query string can retrieve the same asset.
```

## Execution spec

**Epidemic Sound.** Two retrieval routes, and the difference between them matters:

1. **Term search (reliable).** `SearchSoundEffects({ query: { term: "whoosh transition fast" }, first: 5, sort: { by: "RELEVANCE", order: "DESCENDING" } })`. Titles are comma-delimited descriptor chains, so descriptor words in the term hit directly. Verified live.
2. **Tag filter (precise but brittle).** `filter.tagSlugs: { matchType: "ANY", values: ["designed--whoosh"] }`. Slugs follow a `<category>--<subcategory>` grammar. **Verified slugs:** `designed--whoosh`, `designed--riser`, `designed--impact`, `designed--stinger`, `designed--drone`, `swooshes--swish`, `weapons--whip`, `cartoon--boing`, `human--heartbeat`, `cloth--movement`, `crowds--walla`, `ambience--traffic`, `ambience--park`, `ambience--room-tone`, `ambience--restaurant-bar`.

**The trap, confirmed by probe:** an invented slug does not error — `ambience--nature` returned `total: 0` with an empty node list, which is indistinguishable from "the library has nothing". Some assets also carry an **empty `tags` array** while still being perfect matches. So: term search first, tag filter only as a narrowing pass, and never conclude the library lacks a sound from an empty tag-filtered result.

Other tools: `SearchSimilarToSoundEffect(id)` is the identity tool — once one asset matches the profile's palette, similarity search keeps the rest of the video coherent, and it is also how you get the 3–5 *variations* needed to avoid repeating one file. `DownloadSoundEffect({ id, options: { fileType: "WAV" } })` — take WAV for anything you will pitch, stretch or gain-stage.

**HyperFrames.** Nothing here places sound; this note ends at the file. Placement is [[sfx-motion-sound-selection]] and [[sfx-cinematic-hit-emphasis]]; gain is [[sfx-layer-volume-targets]].

**ffmpeg.** The three variation knobs the source video names, applied to one file:
```bash
ffmpeg -i whoosh.wav -af "asetrate=48000*1.15,aresample=48000" whoosh.hi.wav   # pitch up (shortens)
ffmpeg -i whoosh.wav -af "asetrate=48000*0.85,aresample=48000" whoosh.lo.wav   # pitch down (heavier)
ffmpeg -i whoosh.wav -af "atempo=1.25" whoosh.fast.wav                          # duration, pitch kept
```
Reverb is better applied in-composition via a `reverb` FX node than baked.

**Remotion.** Concept only: the resolved file is mounted with `<Audio>`; nothing about naming changes.

## Pairs with
[[sfx-ambience-search-formula]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-motion-sound-selection]] · [[sfx-bpm-filter-first]] · [[sfx-sound-pass-order]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-ten-family-catalogue]] · [[sfx-epidemic-facet-query]]

## Failure modes
- **Searching the description instead of the name.** "Sound that builds tension" returns noise; `riser build up suspenseful` returns the asset. This is the entire bottleneck the source video names.
- **Trusting an empty tag-filtered result.** An invented slug silently returns zero. Re-run as a term search before concluding anything.
- **Skipping classification.** Choosing a sound before deciding *why* it is there is how libraries of whooshes end up sprayed across a video. Style first, family second, file third.
- **Pulling one candidate.** Auditioning is nearly free; guessing is not. Pull 5.
- **Re-using one file for repeated beats.** *"Don't use the same whoosh sound there. It sounds really odd, people pick up on it."* Pull 3–5 variations per family, or derive them with the pitch/duration/reverb knobs above.
- **Not writing the winning query back into the note or design doc.** The library is supposed to get more reliable with every project; an unrecorded query is a search you will pay for twice.
