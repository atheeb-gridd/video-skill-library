---
id: sfx-ten-family-catalogue
title: The ten named sound-effect families — the whole catalogue, with the style each one belongs to
skill: sound-design
type: sfx
family: sfx-taxonomy
tags: [skill/sound-design, type/sfx, family/sfx-taxonomy, sfx/diegetic, sfx/motion, sfx/aesthetic, layer/sfx, layer/ambience, engine/epidemic, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:00:14"
    quote: "But what name do I search? I don't know the name of a single sound effect."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:07:07"
    quote: "Foley sounds are the sound effects that, instead of being shot at a real location, are recorded inside a studio."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:03:47"
    quote: "Diegetic, motion and aesthetic sound effects."
research_refs:
  - https://universalcategorysystem.com/
  - https://www.epidemicsound.com/sound-effects/
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - skills/SOUND-DESIGN/_kt/sfx-kt-1-delta.md
  - _meta/visual-kt-delta.md
difficulty: low
detectable_from: transcript
---

# The ten named sound-effect families — the whole catalogue, with the style each one belongs to

## What it is
`sfx kt 1` is built around one problem — *"I don't know the name of a single sound effect"* — and its answer is a **numbered catalogue of ten families**. This note is that catalogue, complete, cross-referenced to the note that owns each family and classified against the three styles from `sfx kt 2` ([[sfx-three-types-classification]]). It exists because the first pass over that video **dropped the tenth family (Foley) and mis-numbered whip as tenth**, so the library carried a nine-item list with a hole in it.

**The catalogue, in the video's own order:**

| # | Family | Style | Layer | What it is for | The note that owns it |
|---|---|---|---|---|---|
| 1 | **whoosh** | `sfx/motion` (aesthetic when on a camera move) | `layer/sfx` | Transitions, movement, dynamic reveals; a title animation, an object crossing frame | [[sfx-whoosh-transition-movement-reveal]] · [[sfx-whoosh-short-vs-long]] |
| 2 | **swoosh** | `sfx/motion` | `layer/sfx` | *"A very small difference"* from whoosh; both are moving air | [[sfx-swoosh-vs-whoosh]] |
| 3 | **riser** | `sfx/aesthetic` | `layer/sfx` | Build anticipation before a jumpscare, a reveal, or a drop | [[sfx-riser-anticipation-build]] · [[sfx-riser-credibility-budget]] |
| 4 | **ambient sound** | `sfx/diegetic` | `layer/ambience` | Stops the video feeling *"too perfect"*; makes the location believable | [[sfx-ambience-establishes-location]] · [[sfx-ambience-search-formula]] |
| 5 | **motion sound effects** | `sfx/motion` | `layer/sfx` | *"In real life even the tiniest movements create sound"* — walking, dragging, page flips, motion graphics | [[sfx-motion-sound-selection]] · [[sfx-air-on-micro-movement]] |
| 6 | **cartoon sound effects** | `sfx/aesthetic` | `layer/sfx` | Comedy register. Named members: **boing, slide, whistle, pop**; add **echo** for a goofier feel | [[sfx-cartoon-comedy-family]] · [[sfx-echo-on-cartoon-oneshot]] · [[sfx-record-scratch-punctuation]] |
| 7 | **intimate sounds** | `sfx/diegetic` | `layer/sfx` | *"The sounds that are only audible when you come very near"* — heartbeat, clock tick, breathing | [[sfx-intimate-proximity-sounds]] · [[sfx-heartbeat-tension-dial]] · [[sfx-breath-rate-signal]] · [[sfx-ticking-clock-time-pressure]] |
| 8 | **hit and impact** | `sfx/aesthetic` | `layer/sfx` | Dramatic emphasis; *"makes moments quite powerful"*. **Material variants: metal, wood.** Sold as *cinematic hit* in trailers; layer a bass drop under it | [[sfx-cinematic-hit-emphasis]] · [[sfx-layered-approach-and-impact]] · [[sfx-bass-drop-under-impact]] |
| 9 | **whip** | `sfx/motion` (comedic/aesthetic in use) | `layer/sfx` | Fast cuts, punchlines, sudden reactions, old-school action. **Layer it with a whoosh** for unique sounds | [[sfx-whip-crack-on-snap-cut]] · [[sfx-whip-on-punchline]] |
| 10 | **Foley** | `sfx/diegetic` | `layer/sfx` | Studio-made sounds that read as real — footsteps, clothes, door creak. *"This creates realism in the scene."* Also the entry point to making your own | [[sfx-foley-family]] · [[sfx-foley-three-element-checklist]] · [[sfx-foley-replacement-pass]] |

**Style totals across the ten:** diegetic 3 (ambient, intimate, Foley) · motion 4 (whoosh, swoosh, motion SFX, whip) · aesthetic 3 (riser, cartoon, hit & impact). Every family is a layer-2, layer-3 or layer-4 asset — the video never touches dialogue or music.

**Two honesty notes about the list itself.** The ordinals for **7 and 8 are never audible** in any transcript pass; their positions are fixed by 6 before and 9 after, not by the video saying "seventh". And the **whoosh-versus-swoosh differentiator survives only in the older transcript pass** (`00:01:53`) — both improved passes truncate at *"both sound effects are really the movement of air"*. Treat the brightness/mass split in [[sfx-swoosh-vs-whoosh]] as a reasonable reconstruction rather than a quoted rule, and do not build a spec that depends on the distinction being real.

## When to use it
- **As the first stop when a moment needs a sound and you do not know its name.** Read the "what it is for" column, take the family, then go to that family's note for the query ([[sfx-name-before-search]] is the discipline; this is the map).
- **As a coverage audit.** Run the ten rows against a finished cut and ask which families are entirely absent. A video with motion effects and no diegetic or aesthetic families is the classic flat mix ([[sfx-density-fatigue-audit]]).
- **When briefing a style profile.** Which families a creator uses, and which they never touch, is a compact description of their sound.
- **When teaching.** The list is also the video's own structure — name, define, demonstrate, ten times ([[struct-name-define-demonstrate]], [[struct-enumerated-promise-and-counter]]).
- **Not as a mixing guide.** Levels, order and placement live in [[sfx-five-layers-build-order]] and [[sfx-layer-volume-targets]].

## How to recognise it in a reference video
- **Tally families per minute.** Log every effect you hear into one of the ten rows. Three or fewer distinct families across a whole video is a template; six or more is a designed mix.
- **The diegetic/aesthetic ratio is the house style.** Vlog and documentary references skew diegetic (4, 7, 10); tech and hype references skew aesthetic (3, 6, 8).
- **Check for family 4 first.** Missing ambience is the single most common gap and the easiest to hear — cut points where the room noise vanishes entirely ([[sfx-missing-ambience-audit]]).
- **Look for compounding.** A reference that layers whip+whoosh, or hit+bass drop, is working two families at once; that is a competence signal, not decoration.
- **Watch for the repetition tell.** The same whoosh three or four times in a row is audible to viewers and is the video's own named mistake ([[sfx-repetition-variant-rotation]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `families_present` | 5 | 3–8 | Distinct families in one finished video. Under 3 reads as templated. |
| `variants_per_family` | 3 | 2–5 | Distinct files held per family so a 3–4 hit run never repeats a file. |
| `diegetic_share` | 40% | 20–60% | Share of effect instances from families 4, 7, 10. Below 20% the video reads as synthetic. |
| `aesthetic_share` | 25% | 10–40% | Families 3, 6, 8. Above 40% reads as a trailer. |
| `unknown_name_budget` | 0 | — | Every row in a design document names a family. "Something dramatic here" is not a spec. |

## Reproduction prompt

```
Audit or design a video's sound-effect coverage against the ten families.

1. LIST the ten families: whoosh, swoosh, riser, ambient sound, motion SFX,
   cartoon SFX, intimate sounds, hit and impact, whip, Foley.
2. FOR AN AUDIT: play the cut and assign every audible effect to one family.
   Produce a table of family -> count -> example timecode. Flag any family
   with a count of zero that the content plainly calls for (a location shot
   with no ambience; a reveal with no riser; visible physical action with no
   Foley).
3. FOR A DESIGN: walk the timeline section by section and write the family
   name - not a description - for every moment that needs sound. Only then
   open the library.
4. CHECK REPETITION: no family may use the same file twice inside 8 seconds
   or four times in a video without a variant.
5. CLASSIFY each chosen family as diegetic / motion / aesthetic and confirm
   the mix is not entirely one style.

ACCEPTANCE TEST: every row in the design document names a family from the ten
and links to the note that owns it. If a row says what the moment should feel
like rather than what family it needs, it is not finished.
```

## Execution spec

**Epidemic Sound — the starting query per family.** These are the sound-effects surface, so the six music facets do not apply; `duration` (ms) and the term carry the search ([[sfx-epidemic-facet-query]] explains which surface takes which filters).

```
whoosh          SearchSoundEffects { term:"whoosh transition",  duration:{max:1500} }
swoosh          SearchSoundEffects { term:"swoosh",             duration:{max:1200} }
riser           SearchSoundEffects { term:"riser tension",      duration:{min:2000,max:8000} }
ambient sound   SearchSoundEffects { term:"<place> ambience",   duration:{min:30000} }
motion SFX      SearchSoundEffects { term:"page flip | door open | finger snap" }
cartoon SFX     SearchSoundEffects { term:"boing | slide whistle | pop cartoon", duration:{max:2000} }
intimate        SearchSoundEffects { term:"heartbeat | clock ticking | breathing" }
hit and impact  SearchSoundEffects { term:"cinematic impact metal | wood impact", duration:{min:300,max:4000} }
whip            SearchSoundEffects { term:"whip crack",         duration:{max:1200} }
foley           SearchSoundEffects { term:"footsteps | cloth movement | door creak" }
```
Once one file per family is right, `SearchSimilarToSoundEffect` on its id builds the variant set and keeps the whole video inside one sonic neighbourhood — the anchor-and-family workflow. Always `fileType: WAV` for anything that will be pitched, filtered or layered.

**Free sources, when clearance allows.** The video names **freesound.org** and **Pixabay** as free alternatives, motivated by copyright claims landing on effects. Licence terms differ per asset on both; run them through [[sfx-source-licensing-and-clearance]] before a monetised or client delivery, and through [[sfx-library-quality-gate]] before trusting the file.

**HyperFrames.** Nothing family-specific: every effect is an `<audio>` clip in the `sfx` group with `data-start`, `data-duration` and `data-volume`. Family choice changes the *file* and the *anchor frame* — peak on the impact frame for 8 and 9, peak at the velocity midpoint for 1, 2 and 5, peak at the end for 3 ([[sfx-peak-on-impact-frame]], [[sfx-peak-at-motion-midpoint]], [[sfx-riser-anticipation-build]]).

## Pairs with
[[sfx-three-types-classification]] · [[sfx-two-taxonomies-of-sound]] · [[sfx-foley-family]] · [[sfx-search-vocabulary]] · [[sfx-name-before-search]] · [[sfx-vocabulary-llm-expansion]] · [[sfx-five-layers-build-order]] · [[sfx-synthetic-family-catalogue]] · [[sfx-repetition-variant-rotation]] · [[sfx-epidemic-facet-query]]

## Failure modes
- **Working from the nine-family version.** The library carried a list with Foley missing and whip mis-numbered; any design document built on it has no diegetic performance layer at all. Re-check against this table.
- **Treating the numbering as load-bearing.** Two of the ten ordinals are inaudible in every transcript. Use the list as a set, not as a ranking.
- **Asserting the whoosh/swoosh split confidently.** It rests on one line in the weakest transcript pass. Say "brighter/lighter variant, per a single-source line" rather than inventing an acoustic law.
- **Picking a family from what the picture shows rather than what the moment needs.** A visible movement does not automatically want a whoosh; placement discipline governs ([[sfx-placement-discipline]]).
- **Using the catalogue as a checklist to fill.** Ten families present in a two-minute video is clutter, not coverage. Five is a healthy number.
- **Known gap:** the video gives no counts, levels or durations for any family — every number in this note comes from the family notes and from research, not from the source. Where a family note and this one disagree, the family note wins.
