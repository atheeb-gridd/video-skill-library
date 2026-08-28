---
name: sound-design-index
description: Browsable map of the SOUND-DESIGN rule library — all 137 notes, grouped by the three styles then by family, with music, mix and craft in their own sections. The tag-free route into the library.
type: index
count: 137
---

# SOUND-DESIGN — index

The **137 notes** in `skills/SOUND-DESIGN/rules/` are the largest library in the vault, and the one with the most structure. They answer two separate questions that are easy to confuse: *which sound belongs at this moment*, and *how do I actually fetch it*. Sound runs **after** cuts and motion, because motion sound effects are timed off motion events.

**How it is organised — two frameworks, both real, both used here.**

The **three styles** (`sfx/diegetic`, `sfx/motion`, `sfx/aesthetic`) classify *why* a sound is there, and that decides how it is chosen and how it is mixed. They are the top-level grouping on this page. The **five layers** (`layer/dialogue` → `ambience` → `music` → `sfx` → `design`) classify *where* a sound sits, and give the build order. Within each style, notes are grouped by `family/`.

Music and mixing are not sound *effects* and so carry no style tag; they have their own sections below, as does the body of craft-and-workflow notes — naming, searching, library building, licensing — that apply across all three styles.

**By style tag** — `sfx/diegetic` 32 · `sfx/motion` 21 · `sfx/aesthetic` 33. That is 86 tags on 82 notes: 80 notes carry exactly one style, and two — [[sfx-ten-family-catalogue]] and [[sfx-two-taxonomies-of-sound]] — deliberately carry all three because they *are* the classification. Both sit in **Craft and workflow** below rather than under any one style. The remaining 55 notes are music, mix and workflow, which are not sound effects and carry no style.  
**By `type/`** — `sfx` 65 · `music` 32 · `mix` 29 · `cut` 7 · `retention` 2 · `structure` 2  
**By `difficulty/`** — low 31 · medium 85 · high 21

---

## The ten families — the whole catalogue

This is the map from *"I don't know what this sound is called"* to a query. It is reproduced here in full because it is the single most-used table in the library; [[sfx-ten-family-catalogue]] owns it and carries the provenance notes.

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

**Style totals across the ten:** diegetic 3 (ambient, intimate, Foley) · motion 4 (whoosh, swoosh, motion SFX, whip) · aesthetic 3 (riser, cartoon, hit & impact). Every family is a layer-2, layer-3 or layer-4 asset — the catalogue never touches dialogue or music.

---

## Start here

Eight notes, in this order. The first three are all map-and-vocabulary notes: this library is unusable until you can name what you are looking for.

1. **[[sfx-two-taxonomies-of-sound]]** — Two reference videos say "three types of sound" and mean different things. This note reconciles them; without it the rest of the library reads as contradictory.
2. **[[sfx-ten-family-catalogue]]** — The answer to "I don't know what this sound is called" — ten named families, each mapped to a style and to the note that owns it.
3. **[[sfx-three-types-classification]]** — Classify the moment by *need* before you search. This is the discipline that stops a library of whooshes being sprayed over a video.
4. **[[sfx-five-layers-build-order]]** — Dialogue → ambience → music → SFX → design. Build in that order, mix in that order.
5. **[[sfx-layer-volume-targets]]** — The numbers everything else is mixed against: dialogue 0/−3, SFX −12/−15, music −20/−25 dB.
6. **[[sfx-sound-pass-order]]** — Sound is half the video. Budget it as ordered passes rather than as whatever time is left.
7. **[[sfx-epidemic-facet-query]]** — How to actually query the library — the six real facets, read off the Epidemic UI, not invented.
8. **[[sfx-music-ten-point-framework]]** — The whole music method in the order it is taught. Music is the single biggest lever in this library.

---

# Style — `sfx/diegetic`

*Sells that the world is **real**.* A sound the scene would actually make: doors, keyboards, footsteps, traffic, cloth. Sits **under** the picture at a believable level, and is wrong the moment it draws attention. Chosen by physical plausibility — what would this object actually sound like? A video that feels *cheap* usually has aesthetic effects and no diegetic layer.

**30 notes · 16 families**

### `family/ambience` — 5 notes

The bed that says where you are — building it, auditing for its absence, and the one sanctioned drop.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-ambience-establishes-location]] | Ambience tells the viewer where they are — building the bed, not just finding it | `sfx` | low |
| [[sfx-ambience-layer-stack]] | Building the ambience as a stack — bed, character layer, spot events, per location | `sfx` | medium |
| [[sfx-ambience-search-formula]] | Ambience beds - the "<place> + ambience" search formula and its exceptions | `sfx` | low |
| [[sfx-continuous-bed-and-silence-drop]] | The bed never stops — and the one sanctioned exception, the measured drop before a hit | `mix` | high |
| [[sfx-missing-ambience-audit]] | Missing ambience — the audit, the bed, and the width it needs | `mix` | medium |

### `family/foley` — 5 notes

Sounds performed or substituted rather than fetched — feet, objects, cloth.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-foley-family]] | Foley — the tenth family, and the two recipes that build a sound you cannot fetch | `sfx` | medium |
| [[sfx-foley-replacement-pass]] | The foley replacement pass — you cannot record every sound, so re-add them | `mix` | high |
| [[sfx-foley-three-element-checklist]] | The foley checklist — feet, objects, cloth, and nothing else | `sfx` | medium |
| [[sfx-performed-foley-substitution]] | Perform the substitution — the props catalogue, the recording spec, and when it beats searching | `sfx` | high |
| [[sfx-substitute-material-foley]] | Substitute-material foley — build the sound you cannot record from two you can | `sfx` | high |

### `family/split-edit` — 5 notes

J and L cuts from the sound side — which sense is allowed to cross the seam first.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-j-cut-audio-lead]] | The J cut — the next scene's sound arrives before its picture | `cut` | medium |
| [[sfx-j-cut-hook-sound]] | Hear it before you see it — choosing the J cut's lead sound for curiosity, not continuity | `cut` | medium |
| [[sfx-l-cut-audio-trail]] | The L cut — hold the outgoing sound over the incoming picture | `cut` | low |
| [[sfx-narration-over-reenactment]] | Holding a voice over an illustrative cutaway — the reenactment L cut and its three sound jobs | `cut` | medium |
| [[sfx-split-edit-lead-lag]] | Split edits — let sound cross the cut to steer attention | `cut` | medium |

### `family/dialogue-edit` — 2 notes

The voice track itself — pause removal, breath, room tone, and the loudness handover.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-demo-clip-loudness-handover]] | Hand the dialogue slot to the demonstration clip — and match its loudness | `mix` | high |
| [[sfx-pause-removal-breath-and-room-tone]] | Partial pause removal — keep the breath, keep the room | `mix` | high |

### `family/diegetic-sfx` — 2 notes

Spotting the world's own sounds — the action inventory and the pass that runs first.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-diegetic-action-inventory]] | Every physical action on screen has a file — the diegetic action inventory | `sfx` | medium |
| [[sfx-diegetic-spotting-list]] | The diegetic pass runs first — spot the cue list, including the sounds you cannot see | `sfx` | medium |

### `family/ambience-bed` — 1 note

Ambience as the cheapest bridge across a cut.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-ambience-bridge-across-cut]] | Ambience is the cheapest bridge across a cut — build the bed, then run it through the seam | `sfx` | medium |

### `family/cross-cut` — 1 note

Sounding a cross-cut phone call — whose ear are we in, and where the futz swaps.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-phone-call-cross-cut-treatment]] | Sounding a cross-cut phone call — whose ear are we in, and where the futz swaps | `mix` | high |

### `family/dialogue-cleanup` — 1 note

Record clean, add the world back in post.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-record-clean-add-world]] | Record clean, add the world back — ambience is a post decision, not a microphone fault | `mix` | medium |

### `family/diegetic-convention` — 1 note

Convention beats accuracy — why frankly fake sounds read as real.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-convention-over-accuracy]] | Convention beats accuracy — the whip, the punch, and why fake sounds read as real | `sfx` | medium |

### `family/hard-cut` — 1 note

The straight cut's audio seam, switched on the same frame without a click.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-hard-cut-audio-seam]] | The straight cut's audio seam — switch on the same frame, without a click | `cut` | low |

### `family/layers` — 1 note

The five layers of sound, used as a build order.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-five-layers-build-order]] | The five layers of sound as a build order | `mix` | medium |

### `family/match-cut` — 1 note

Cutting on the sound that two scenes share.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-audio-match-bridge]] | Audio match — cut on the sound the two scenes share | `cut` | high |

### `family/noise-floor` — 1 note

Holding a measurable noise floor instead of digital silence.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-noise-floor-target]] | Too perfect is broken — hold a measurable noise floor instead of digital silence | `mix` | medium |

### `family/screen-demo` — 1 note

The screen-recording payoff — click, compress the wait, land the reveal.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-ui-demo-payoff-sound]] | The screen-recording payoff — click, compress the wait, land the reveal | `sfx` | medium |

### `family/sfx-treatment` — 1 note

Reverb as the glue that puts a library effect inside the room.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-reverb-glue]] | Reverb is what puts a library effect inside the room | `mix` | medium |

### `family/space-and-distance` — 1 note

The eight named space presets, and their in-stack equivalents.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-essential-sound-space-presets]] | Put the sound in a place — the eight named space presets, and their in-stack equivalents | `mix` | medium |

---

# Style — `sfx/motion`

*Sells the **movement**.* Bound to something travelling across or into frame: whooshes on transitions, swishes on text entrances, impacts on slams. Sits **with** the picture and usually **leads it by a few frames**. Chosen by the movement's speed, weight and direction. A video that feels *cluttered* usually has motion effects on things that are not moving.

**19 notes · 14 families**

### `family/motion-sfx` — 3 notes

Which motions get a sound at all, and the sync window that makes one believable.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-av-sync-binding-window]] | Motion without sound reads as fake — and the sync window that makes sound believable | `sfx` | medium |
| [[sfx-envelope-matched-to-easing-curve]] | For invented motion any sound works — derive its envelope from the easing curve | `sfx` | high |
| [[sfx-motion-sound-selection]] | Which motions get a sound - and which stay silent | `sfx` | medium |

### `family/whoosh` — 3 notes

The air family — whoosh and swoosh, short and long, and how to fetch the right one.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-swoosh-vs-whoosh]] | Swoosh vs whoosh — one air family, split by brightness and by mass | `sfx` | low |
| [[sfx-whoosh-short-vs-long]] | Short whoosh or long whoosh — pick the family from the length of the move, then trim to fit | `sfx` | medium |
| [[sfx-whoosh-transition-movement-reveal]] | Whoosh — the default sound for transitions, movement and reveals, and how to fetch the right one | `sfx` | low |

### `family/motion-coverage` — 2 notes

Auditing the timeline for movement that carries no sound.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-arbitrary-sound-motion-sync]] | For abstract motion there is no correct sound — only sync | `sfx` | medium |
| [[sfx-unsounded-motion-audit]] | Unsounded motion audit — find every move with no sound on it | `sfx` | medium |

### `family/appearance` — 1 note

The arrival transient that stands in for an entrance animation.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-appearance-transient]] | The arrival transient — a sound can stand in for an entrance animation | `sfx` | low |

### `family/foley` — 1 note

Mouth foley — performing the effect into the mic, then processing it into one.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-mouth-foley-record-and-process]] | Mouth foley — perform the effect into the mic, then process it into one | `sfx` | high |

### `family/impact` — 1 note

The impact as a compound — approach, contact, and the sub, tail and settle under them.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-layered-approach-and-impact]] | An impact is a compound — approach, contact, and the sub, tail and settle under them | `sfx` | high |

### `family/motion-sync` — 1 note

Matching the effect's length to the length of the move.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-length-matched-to-motion]] | Match the effect's length to the motion — stretch it, or stack it | `sfx` | medium |

### `family/sfx-pass` — 1 note

The two-rule sound-effect pass — air on what moves, a highlight on what is marked.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-motion-pass-two-rules]] | The sound-effect pass — a whoosh on everything that moves, a highlight sound on everything highlighted | `sfx` | medium |

### `family/sfx-placement` — 1 note

Peak on the cut frame, not on the file's first frame.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-peak-on-the-cut]] | Put the sound's loudest peak on the cut frame, not the file's first frame | `sfx` | medium |

### `family/sfx-treatment` — 1 note

The 0.6 pitch ratio that turns a thin whoosh into a heavy one.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-pitch-ratio-point-six]] | Pitch 0.6 — the ratio that turns a thin mouth-whoosh into a heavy one | `mix` | medium |

### `family/sync` — 1 note

Peak at the velocity peak — not the file start, not automatically the middle.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-peak-at-motion-midpoint]] | On a motion, the peak goes at the velocity peak — not the file start, not always the middle | `sfx` | high |

### `family/sync-placement` — 1 note

Aligning the peak to the measured impact frame.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-peak-on-impact-frame]] | Align the peak, not the file — find the impact frame and land the hit on it | `sfx` | medium |

### `family/transition-sfx` — 1 note

One sound recipe per full-screen transition type.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-full-screen-transition-sound-layer]] | Sounding a full-screen transition — one recipe per transition type | `sfx` | medium |

### `family/whip` — 1 note

The whip crack — the sound for a cut, not for a glide.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-whip-crack-on-snap-cut]] | The whip crack — the sound for a cut, not for a glide | `sfx` | medium |

---

# Style — `sfx/aesthetic`

*Sells the **feeling**.* No physical or visual referent at all: risers, drones, tonal stings, textures, braams. Sits **around** the picture, often long and low. Chosen by emotional intent and by where you are in the structure. A video that feels *flat* usually has motion effects and no aesthetic layer.

**31 notes · 22 families**

### `family/aesthetic-sfx` — 3 notes

Invented air and accents — the layer's licence to amplify, and its ban on informing.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-air-on-micro-movement]] | Air on the small moves — whoosh a gesture, a zoom, even an eye roll | `sfx` | medium |
| [[sfx-camera-move-air-accent]] | Air on the camera — sounding zooms, push-ins and body movement so it is felt, not noticed | `sfx` | medium |
| [[sfx-intensify-without-referent]] | The aesthetic layer's licence — invented sound may amplify, never inform | `sfx` | medium |

### `family/riser` — 3 notes

Anticipation built by a sound anchored at its end, and the credibility it spends.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-riser-anticipation-build]] | The riser — a sound anchored by its end, so land the peak on the reveal frame | `sfx` | medium |
| [[sfx-riser-credibility-budget]] | A riser is a promise — the credibility budget that keeps it working | `retention` | medium |
| [[sfx-riser-to-music-drop-backtiming]] | Back-time the riser from the music's drop — and use it to bridge two tracks | `sfx` | high |

### `family/cartoon` — 2 notes

The comedic register — boing, pop, slide whistle, and the echo dial on top.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-cartoon-comedy-family]] | The cartoon SFX family — a comedic register, and the beat each sound punctuates | `sfx` | medium |
| [[sfx-echo-on-cartoon-oneshot]] | Echo on a cartoon one-shot — the goofiness dial, and its dialogue budget | `sfx` | medium |

### `family/comedy-sfx` — 2 notes

Punctuation gags — the record scratch and the punchline whip.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-record-scratch-punctuation]] | The record scratch — a full stop that kills the mix | `sfx` | medium |
| [[sfx-whip-on-punchline]] | The whip on a punchline — a supersonic crack on a small human movement | `sfx` | low |

### `family/impact` — 2 notes

Weight under the hit — the bass drop, and the riser-into-hit compound.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-bass-drop-under-impact]] | Layer a bass drop under the impact for weight | `sfx` | medium |
| [[sfx-riser-hit-pair]] | Build and release — the riser-into-hit compound, and the one-word reveal it stages | `sfx` | medium |

### `family/intimate-sounds` — 2 notes

Heartbeat and breath used as tension dials, where the rate is the parameter.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-breath-rate-signal]] | Breath rate as the signal — slow reads as personal, fast reads as terrified | `sfx` | medium |
| [[sfx-heartbeat-tension-dial]] | Heartbeat as a tension dial — the rate is the parameter, not the presence | `sfx` | medium |

### `family/sfx-treatment` — 2 notes

Pitch and reverb as the size and weight controls on a fetched file.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-pitch-shift-weight-energy]] | Pitch down for heavy and cinematic, pitch up for light and energetic | `mix` | medium |
| [[sfx-reverb-size-and-tail]] | Reverb as size — the tail that makes a hit land bigger | `mix` | high |

### `family/aesthetic-bed` — 1 note

Sustained tone beds that colour a passage with mystery or dread.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-tone-bed-mystery]] | Tones — the sustained bed that colours a passage with mystery and dread | `sfx` | medium |

### `family/contrast` — 1 note

The smash cut measured and built from the audio side.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-smash-cut-audio-contrast]] | The smash cut, from the audio side — measuring and building the jolt | `mix` | medium |

### `family/highlight` — 1 note

The sound for something that is marked rather than moved.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-highlight-sound-on-emphasis]] | The highlight sound — what goes on a thing that gets marked rather than moved | `sfx` | low |

### `family/hit-impact` — 1 note

The cinematic hit — punctuating the moment you want felt as important.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-cinematic-hit-emphasis]] | The cinematic hit — punctuate the moment you want felt as important | `sfx` | medium |

### `family/intimacy` — 1 note

Collapsing the distance between viewer and subject.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-intimate-proximity-sounds]] | Intimate sounds — collapsing the distance between viewer and subject | `sfx` | medium |

### `family/intimate-sfx` — 1 note

The ticking clock as a metronome you have to tune to the edit.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-ticking-clock-time-pressure]] | The ticking clock — a metronome you have to tune to the edit | `sfx` | medium |

### `family/music-scoring` — 1 note

The per-segment music cue sheet.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-music-cue-sheet-per-segment]] | The per-segment music cue sheet — boundary, mood brief, query, level-matched track | `music` | medium |

### `family/music-search` — 1 note

Searching music by instrument, where for suspense the instrument *is* the brief.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-instrument-filter-search]] | Search music by instrument — and for suspense, the instrument *is* the brief | `music` | medium |

### `family/music-selection` — 1 note

Budgeting the music search, and picking a library worth the budget.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-music-source-and-search-budget]] | Budget the music search — and pick the library whose search is worth the budget | `music` | low |

### `family/music-transition` — 1 note

Find Similar as a track-handover tool — what it matches and what you must match yourself.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-find-similar-track-handover]] | Find Similar for a track handover — what it actually matches, and what you must match yourself | `music` | medium |

### `family/parallel-action` — 1 note

One bed, two worlds — the audio architecture of a cross-cut sequence.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-cross-cut-audio-strategy]] | One bed, two worlds — the audio architecture of a cross-cut sequence | `music` | high |

### `family/sfx-selection` — 1 note

Holding the picture and swapping the sound — A/B before committing.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-ab-audition-candidates]] | Hold the picture, swap the sound — A/B every cue before you commit to one | `sfx` | low |

### `family/subliminal` — 1 note

Level and masking rules for sound that must be felt and not noticed.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-felt-not-noticed]] | Felt, not noticed — the level and masking rules for the aesthetic layer | `mix` | high |

### `family/synthetic-sfx` — 1 note

The catalogue of sounds that do not exist, and what each one is for.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-synthetic-family-catalogue]] | Layer 4 — the catalogue of sounds that do not exist, and what each one is for | `sfx` | medium |

### `family/voice-character` — 1 note

The heckling alter-ego — voicing the objection, and giving it its own room.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-alter-ego-objection-cutaway]] | The heckling alter-ego — voice the viewer's objection, and give it its own room | `mix` | high |

---

# Music

**27 notes · 10 families.** Music carries no `sfx/` style tag — it is `layer/music`, not a sound effect. It is also the biggest single lever in the library: the bed decides the mood, the energy and a large share of the perceived production value, and it is chosen *before* effects rather than after. These notes cover the brief, the six-facet query, the arc across the video, and how a track is ended.

### `family/music-selection` — 7 notes

Choosing the bed — the brief, the emotion table, the audition, and the re-cut to length.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-emotion-music-lookup-table]] | The standing emotion-to-music table — the filter values, and the motion energy each row dictates | `music` | medium |
| [[sfx-mood-map-per-topic]] | The mood map — one target emotion per topic, and the audio that installs it | `music` | medium |
| [[sfx-music-audition-against-picture]] | Judge a track only against the locked cut, at final level | `music` | low |
| [[sfx-music-primacy-doctrine]] | Music is the biggest lever — it decides engagement, it sets the mood, and it is funded first | `music` | medium |
| [[sfx-track-reversion-to-edit-length]] | Re-cut the track to the edit — Create Version, not a fade-out | `music` | medium |
| [[sfx-vibe-brief]] | The vibe is a decision, not a discovery — write it as a brief before you search | `music` | low |
| [[sfx-vocal-track-for-narration-free-montage]] | Vocal music belongs where your voice is not — montages, journeys, transformations | `music` | medium |

### `family/music-search` — 6 notes

Querying the library — the six facets, BPM first, then instrument and vibe.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-bpm-filter-first]] | Filter by BPM before you listen to anything | `music` | low |
| [[sfx-bpm-perceptual-bands]] | BPM as the energy dial — the bands, the frame arithmetic, and matching tempo to delivery | `music` | low |
| [[sfx-emotion-and-pace-diagnosis]] | Diagnose the cut's emotion and pace before the library is opened | `music` | medium |
| [[sfx-epidemic-facet-query]] | Build the query from the six facets, not from a sentence | `music` | low |
| [[sfx-mood-vibe-filter]] | Mood is the third axis — and the editor sets it, not the footage | `music` | low |
| [[sfx-three-parameter-music-search]] | The three-parameter funnel — BPM, then instrument, then vibe, in one query | `music` | low |

### `family/music-arc` — 5 notes

The bed's shape across the whole video — drops, stops, rests and track changes.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-music-drop-on-structure-turn]] | Land the music's drop on the structural turn, not just its mood on the segment | `music` | high |
| [[sfx-music-hard-stop]] | Cut the music dead to make one moment land — and land the stop on an accent | `music` | medium |
| [[sfx-music-rest-windows]] | Give the music rest — plan the windows where there is no bed | `music` | medium |
| [[sfx-music-ten-point-framework]] | The ten-point music method — the whole framework, in the order it is taught | `music` | medium |
| [[sfx-track-change-at-section-boundary]] | Change the track when the section changes — choose the handover, land the first beat on the boundary | `music` | medium |

### `family/bed-selection` — 2 notes

What kind of bed actually survives underneath a voice.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-beat-forward-bed-under-voice]] | Beat-forward beds sit under a voice — pads, leads and vocals fight it | `music` | medium |
| [[sfx-vocal-vs-instrumental-bed]] | Vocal tracks only where your own voice isn't — and the stem that gets you out of it | `music` | low |

### `family/music-stops` — 2 notes

Ending the bed on purpose — the slow fade-out and the hard drop.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-music-fade-out-section-signal]] | Fade the bed out slowly to announce that a section is ending | `music` | low |
| [[sfx-silence-as-pattern-interrupt]] | The hard music drop — cut the bed abruptly so the silence itself is the interrupt | `music` | medium |

### `family/beat-grid` — 1 note

Beat-locked cuts seen from the audio side — the grid, the tolerance, the kick collision.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-cut-on-the-beat]] | Beat-locked cuts, from the audio side — the grid, the tolerance, and the collision with the kick | `music` | high |

### `family/library` — 1 note

The personal track shortlist, kept as queryable data.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-track-shortlist-library]] | Favourite as you go — the personal track shortlist as queryable data | `music` | low |

### `family/mood-control` — 1 note

The bed decides the mood — choose it, don't discover it.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-music-sets-the-mood]] | The bed decides the mood — choose it, don't discover it | `music` | medium |

### `family/music-transitions` — 1 note

Landing track B's downbeat exactly on the section change.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-beat-aligned-handover]] | Beat-aligned track handover — land track B's downbeat exactly on the change | `music` | high |

### `family/stems` — 1 note

Running the music as stems rather than as one bounce.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-music-stem-layering]] | Run the music as stems, not as one bounce | `music` | high |

---

# Mix

**12 notes · 8 families.** Levels, gates, filters and verification — `type/mix`, `layer/dialogue` and `layer/music`. Dialogue wins: if the voice is not fully intelligible with every layer at level, the mix is wrong regardless of how good the design is.

### `family/mix-levels` — 4 notes

The level hierarchy and the moves that hold it — targets, ducking, genre exceptions, device checks.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-ducking-keyframed-dip]] | Ducking — demonstrated on screen, never named: the keyframed dip under the voice | `mix` | medium |
| [[sfx-layer-volume-targets]] | The three-tier level hierarchy — dialogue 0/-3, SFX -12/-15, music -20/-25 | `mix` | medium |
| [[sfx-loud-guitar-minus-30]] | Dense-guitar rock beds go to -30 dB, not -22 | `mix` | medium |
| [[sfx-translation-check-devices]] | Mix to the meter, verify on the worst device — the translation check | `mix` | medium |

### `family/layers` — 2 notes

The dialogue gate, and the cumulative stem demo that proves the layer model.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-dialogue-gate]] | Layer 1 is a gate — measurable thresholds for "good enough to build sound design on" | `mix` | medium |
| [[sfx-layer-stem-demo]] | Prove the layers — build a cumulative stem demo of one clip | `mix` | medium |

### `family/audio-demo` — 1 note

Playing the sound before naming it, at the level it needs.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-audio-demo-insert]] | Play the sound before you name it — the demo insert and the level it needs | `mix` | medium |

### `family/clip-hygiene` — 1 note

Edge fades that kill the click without eating the attack.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-edge-fades-click-free]] | Fade both ends of every effect — the click-free edge, and the fade that is short enough to keep the attack | `mix` | low |

### `family/music-arc` — 1 note

Hiding an audio out-point behind a transient.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-transient-masked-outpoint]] | Hide an audio out-point behind a transient — the 100 ms forward-masking window | `mix` | medium |

### `family/second-sense` — 1 note

The doctrine — every cut, transition, animation and clip gets an audible counterpart.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-second-sense-doctrine]] | Audio is the second sense — every cut, transition, animation and clip gets an audible counterpart | `mix` | medium |

### `family/sfx-treatment` — 1 note

Filters as character and as distance — high pass for sharp, low pass for muffled.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-filter-character-and-distance]] | High pass for sharp, low pass for muffled — filters as character and as distance | `mix` | medium |

### `family/verification` — 1 note

The structured listen-adjust-listen protocol.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-playback-verification-loop]] | Play it and trust the feel — the structured listen-adjust-listen protocol | `mix` | medium |

---

# Craft and workflow — style-independent

**18 notes · 12 families.** Notes that apply whatever the style: naming a sound before searching for it, building and gating a library, clearing licences, rotating variants, auditing density, and ordering the passes. These are the notes that make the rest of the library reliable rather than lucky.

### `family/sfx-taxonomy` — 4 notes

The naming problem and the two competing taxonomies — the map you read before searching.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-name-before-search]] | Name the sound before you search for it | `sfx` | low |
| [[sfx-ten-family-catalogue]] | The ten named sound-effect families — the whole catalogue, with the style each one belongs to | `sfx` | low |
| [[sfx-two-taxonomies-of-sound]] | Two competing "three types of sound" — one classifies why, the other classifies what | `sfx` | low |
| [[sfx-vocabulary-llm-expansion]] | From intent to searchable name — expanding SFX vocabulary and validating it against the library | `sfx` | low |

### `family/library` — 3 notes

Building and gating your own sound library, and the clearance rules on its sources.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-library-build-and-taxonomy]] | Build the sound library before the timeline — taxonomy, naming and ingest | `sfx` | medium |
| [[sfx-library-quality-gate]] | Four deficits of a scraped sound — the quality gate a source must pass | `sfx` | medium |
| [[sfx-source-licensing-and-clearance]] | Clearance gate — which source a sound may come from, per delivery | `sfx` | low |

### `family/variation` — 2 notes

Avoiding repetition — rotation, and generating a variation set from one file.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-repetition-variant-rotation]] | Mistake three — the same sound effect again and again, and the rotation that fixes it | `sfx` | medium |
| [[sfx-variation-set-generator]] | One file into a variation set — the pitch/duration/reverb grid and how to bake it | `sfx` | medium |

### `family/density` — 1 note

The overload audit that keeps the viewer's brain out of fatigue.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-density-fatigue-audit]] | SFX overload — the density audit that keeps the viewer's brain out of fatigue | `retention` | medium |

### `family/layers` — 1 note

The drop test — how many layers a given format actually needs.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-layer-subset-by-format]] | Two or three layers, not five — the drop test and what each format actually needs | `structure` | low |

### `family/placement` — 1 note

Measuring an effect's transient offset instead of eyeballing it.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-peak-offset-measurement]] | Find the peak — measure an effect's transient offset instead of eyeballing it | `sfx` | low |

### `family/search-vocabulary` — 1 note

Turning a mouth imitation into a catalogue search term.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-onomatopoeia-to-search-term]] | Say it out loud — turning a mouth-imitation into a catalogue search term | `sfx` | low |

### `family/sfx-placement` — 1 note

The placement gate — right place, not every place.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-placement-discipline]] | Right place, not every place — the SFX placement gate | `sfx` | medium |

### `family/sfx-sourcing` — 1 note

The intent-to-query lookup: the bottleneck is the name, not the file.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-search-vocabulary]] | The bottleneck is the name, not the file — the intent-to-query lookup | `sfx` | low |

### `family/sfx-styles` — 1 note

Classifying the moment by need before searching for the sound.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-three-types-classification]] | The three styles by need — classify the moment before you search for the sound | `sfx` | medium |

### `family/sound-selection` — 1 note

The plausibility rule — real objects dictate their sound, invented ones do not.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-real-vs-invented-sound-rule]] | Real objects dictate their sound, invented ones don't — the plausibility rule | `sfx` | medium |

### `family/sound-workflow` — 1 note

Budgeting sound as ordered passes rather than as leftover time.

| id | title | type | difficulty |
|---|---|---|---|
| [[sfx-sound-pass-order]] | Sound is half the video — budget it as ordered passes, not leftover time | `structure` | medium |

---

## Also see

- `skills/SOUND-DESIGN/SKILL.md` — the router: the two modes, the Epidemic fetching rules, and the non-negotiables.
- `INDEX.md` — the whole-vault map.
- `_meta/execution-contract.md` §5 (audio model), §5A (the sixteen Epidemic MCP tools and the six facets), §7A (the analysis toolchain).
- `skills/SOUND-DESIGN/_kt/` — the two delta passes over the reference videos this library is mined from.
- Cross-skill: `skills/MOTION/INDEX.md` family `motion-sfx-binding` is the interface that hands motion events to the `sfx/motion` style here.
