---
id: sfx-instrument-filter-search
title: Search music by instrument — and for suspense, the instrument *is* the brief
skill: sound-design
type: music
family: music-search
tags: [skill/sound-design, type/music, family/music-search, engine/epidemic, engine/hyperframes, engine/ffmpeg, layer/music, layer/design, sfx/aesthetic, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:02:31
    quote: "So think of it like this: if you want to give a suspense or tension vibe, then a violin [cue truncated here in both new passes — the sentence probably continued naming instruments]"
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:07
    quote: "BPM, instruments and vibe."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:02:54
    quote: "So you can search for music by instrument too. I just go into Epidemic Sound, apply the instrument filter, and pick the music right from there."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:02:51
    quote: "Music that has beats in it sits really well underneath the voice."
research_refs:
  - https://en.wikipedia.org/wiki/Consonance_and_dissonance
  - https://en.wikipedia.org/wiki/Shepard_tone
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchRecordings (featuredInstrumentSlugs, moodSlugs, tagSlugs and bpm filters probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Search music by instrument — and for suspense, the instrument *is* the brief

## What it is
The second of the creator's three music-search parameters (BPM, **instruments**, vibe), and the one that does the most work on the hardest brief. When the ask is "suspense" or "tension", searching the mood keyword returns a mixed bag, because *mood* is a label applied to a finished track while the **instrument and the playing technique are the mechanism that actually produces the tension**. The source's worked example is exactly this reasoning — asked how to deliver a suspense vibe, the answer is an instrument (a violin), not a mood word.

Research explains why the instrument is the right handle. Tension in music is mostly a small set of acoustic devices, and each maps to specific instrumentation:

- **Dissonance / roughness.** Two tones inside the same critical band beat against each other: *"people tend to perceive maximum dissonance when the frequencies are within the critical band for those frequencies, which is as wide as a minor third for low frequencies and as narrow as a minor second for high frequencies."* Close-voiced high strings, clustered synth pads, and minor-second doublings are the practical delivery. Functionally, *"an unstable tone combination is a dissonance; its tension demands an onward motion to a stable chord"* — tension is a *promise of resolution*, so it only works if something resolves it.
- **Sustain without rhythm.** Long bowed strings, drones and pads remove the metrical grid, and with it the listener's ability to predict what happens next.
- **A pulse instead of a beat.** A repeating sub or ticking figure marks time without giving a groove — the catalogue's own "pulses" production-genre exists for this.
- **Endless rise.** The Shepard tone: *"a sound consisting of a superposition of sine waves separated by octaves"* whose scales *"fade in and fade out so that hearing the beginning or end of any given scale is impossible."* Nolan used it as *"a fundamental basis for compositions"* in *Dunkirk*, *"to create the illusion of an ever increasing moment of intensity."* This is the designed cousin of a riser and belongs in the design layer.
- **Weight and threat.** Low double bass, cello, taiko and sub-hits carry menace by frequency alone, and they occupy the band voice does not, which is why they survive under narration.

The other half of the note is the practical one: **instrument filters stack badly.** Verified live — `featuredInstrumentSlugs: ["violin"]` + `moodSlugs: ["suspense"]` + `vocals: false` + `bpm 60–100` returns **14 tracks** out of a catalogue where mood-plus-strings alone returns **957**. Instrument is a scalpel; use it as the *last* filter you add, and drop the BPM window before you drop the instrument.

## When to use it
- **Whenever the brief is an emotion that instrumentation delivers**: suspense, tension, dread, menace, unease, mystery. Reason from the mechanism to the instrument, then filter by the instrument.
- **When mood searching has already failed** — you have auditioned five "suspense" tracks and they are all wrong in different ways. That is the signal that the mood tag is too coarse and the instrument is the discriminator.
- **When the bed must sit under narration.** *"Music that has beats in it sits really well underneath the voice"*: percussive and pulse-driven material has energy in the transient domain and the low end, leaving the 600–4000 Hz speech bands relatively free. A sustained-strings bed fights the voice in exactly the mid-band the voice needs; if you must use one, carve it ([[sfx-reverb-glue]] for the SFX equivalent, [[sfx-layer-volume-targets]] for the levels).
- **When a section needs to sound different but not louder.** Changing instrumentation at a section boundary reads as a change of subject; changing volume just reads as a mistake ([[sfx-track-change-at-section-boundary]]).
- **Not for high-energy or feel-good briefs**, where BPM and mood are the efficient handles and instrument over-constrains the pool.

## How to recognise it in a reference video
- **Name the instruments in the bed before naming its mood.** Solo the music by finding a speech gap and listing what you can actually hear: bowed strings, plucked strings, piano, synth pad, sub pulse, ticking percussion, taiko, brass.
- **Look at the spectrum, not just the vibe.** `ffmpeg -i ref.wav -lavfi showspectrumpic=s=1024x512:legend=1 spec.png`. A suspense bed built the "right" way for talking-head shows **energy below 200 Hz and sparse transients**, with a relatively empty 600–4000 Hz corridor. A suspense bed built the wrong way shows a solid mid-band block — that is a bed that will fight the voice.
- **Rhythm test.** Tap along. If you cannot find a downbeat, the bed is drone/pulse based (tension via unpredictability). If you can, it is groove based (tension via drive). These are different tools and should be logged separately.
- **Dissonance test.** Sustained close intervals produce audible beating or "roughness" — a wobble at under ~20 Hz that you hear as loudness fluctuation rather than as two notes. Its presence is the strongest tell of a deliberately dissonant bed.
- **Rise test.** A pitch that appears to climb for 15+ seconds without ever arriving is a Shepard-type construction, not a riser; log it as design layer, not music.
- **Cross-reference the transcript.** Instrumentation changes should coincide with topic changes. If the bed's instrumentation is identical across a problem section and a solution section, the creator is mood-matching, not instrument-designing.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `filter_order` | mood → BPM → instrument | — | Add the instrument filter last; it is the one that collapses the pool. |
| `min_pool` | 30 tracks | 20–200 | Below ~20 results you are auditioning the catalogue's leftovers. Loosen BPM first, instrument second. |
| `bpm_window` | ±15 BPM around the speech-rate match | ±10 to ±25 | Creator default 100–120 BPM overall; for tension beds 60–90 is more common. |
| `tension_primary` | violin / high sustained strings | violin · viola · strings | The source's own answer. Close-voiced and sustained is the tension-carrying register. |
| `tension_weight` | double bass / cello | double-bass · cello · taiko | Threat by frequency. Survives under voice. |
| `tension_pulse` | pulses (production genre) | pulses · drone · ambient | Time without groove. Verified: `tagSlugs ANY ["pulses","drone"]` = 385 tracks. |
| `dissonance_interval` | minor 2nd (high) / minor 3rd (low) | — | The critical-band roughness window; narrower at high frequencies, wider at low. |
| `speech_corridor` | 600–4000 Hz kept clear | — | The band the voice needs. Judge a bed by what it does *here*. |
| `bed_level` | −22 dB (`data-volume="0.079"`) | −25 to −20 dB | Per [[sfx-layer-volume-targets]]; dense low strings often want −25. |
| `carve_strength` | 0.25 | 0.15–0.35 | HyperFrames default: a 6 dB dip in three bands. 0.5 is audible as an effect. |
| `resolution_required` | yes | — | Dissonance without a later resolution reads as a mistake, not as tension. Plan where it lands. |

## Reproduction prompt

```
Find and place a music bed for the {{SECTION}} section whose brief is
"{{EMOTION}}" (e.g. suspense, tension, dread).

1. DO NOT SEARCH THE EMOTION FIRST. Write down the MECHANISM you want, from
   this map:
     unpredictability  -> sustained strings / drone, no drums
     dread / threat    -> double bass, cello, taiko, sub pulse
     nervous energy    -> ticking or pulsing percussion, staccato strings
     unease            -> close dissonant intervals, detuned or clustered pads
     escalation        -> a build/riser track, or a Shepard-type rising design tone
2. TURN THE MECHANISM INTO FILTERS, adding them in this order and checking the
   result count after each:
     a) moodSlugs: ["suspense"] (and/or "dark", "mysterious", "fear")
     b) vocals: false  - a vocal track will fight the narration
     c) bpm: a +/-15 window around the video's speech rate
     d) featuredInstrumentSlugs: the instrument from step 1
   STOP ADDING FILTERS WHEN THE POOL DROPS BELOW 30 RESULTS. If the instrument
   filter takes you under 30, remove the BPM window first, not the instrument.
3. AUDITION THREE CANDIDATES AGAINST PICTURE, not in isolation. Judge each on
   one question only: does the 600-4000 Hz region stay clear enough that the
   voice needs no more than a 0.25 carve?
4. PLACE THE BED at data-volume 0.079 (-22 dB), on the music group, with
   data-fx-carve against the voiceover group at strength 0.25. Trim past the
   track's warm-up with data-media-start so the section starts on the main beat.
5. IF THE BED IS DISSONANT OR RISING, DECIDE NOW WHERE IT RESOLVES: the frame
   where the tension pays off. Tension with no resolution reads as an error.
   Author the resolution as either a hit, a drop, or the bed's own arrival.
6. IF NOTHING IN THE CATALOGUE FITS, build the tension in the DESIGN layer
   instead: a low drone at -24 dB plus a pulse, both under the existing bed.
   That is often better than a wrong bed.

ACCEPTANCE TEST: play the section with dialogue at level and the bed at
-22 dB. Every word must be intelligible with no carve above 0.35, and you
must be able to name the feeling in one word without looking at the picture.
Then mute the bed: the section should feel neutral. If it still feels tense
with the bed muted, the tension is coming from the picture and the bed is
redundant - remove it.
```

## Execution spec

**Epidemic Sound — the filter names are verified, and so is the pool-collapse trap.**

```
# 1. mood only - the wide pool
SearchRecordings {
  filter: { moodSlugs: { matchType: ANY, values: ["suspense"] },
            featuredInstrumentSlugs: { matchType: ANY, values: ["strings"] },
            vocals: false },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }
# live 2026-08-28 -> 957 results

# 2. add instrument + BPM - the scalpel
SearchRecordings {
  filter: { moodSlugs: { matchType: ANY, values: ["suspense"] },
            featuredInstrumentSlugs: { matchType: ANY, values: ["violin"] },
            vocals: false,
            bpm: { min: 60, max: 100 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }
# live 2026-08-28 -> 14 results. This is the collapse; loosen bpm first.

# 3. weight-and-threat instrumentation
SearchRecordings {
  filter: { featuredInstrumentSlugs: { matchType: ANY, values: ["double-bass","cello","taiko"] } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }
# live 2026-08-28 -> 612 results

# 4. pulse / drone material, via the production-genre and genre tags
SearchRecordings {
  filter: { tagSlugs: { matchType: ANY, values: ["pulses","drone"] } }, first: 20 }
# live 2026-08-28 -> 385 results
```

Verified filter surface on `SearchRecordings`: `moodSlugs`, `featuredInstrumentSlugs`, `tagSlugs`, `taxonomySlugs` (genre / decade / world country), `bpm {min,max}`, `duration {min,max}`, `musicalKeys`, `vocals`, `artistSlugs`, `recordingIDs`. Returned tags carry a `dimension.name` — observed values include **mood** (`suspense`, `dark`, `mysterious`, `fear`, `heavy & ponderous`, `restless`), **production genre** (`pulses`, `build`, `cinematic`, `mystery`, `action`, `main title`, `suspense`), **genre** (`orchestral hybrid`, `contemporary classical`, `ambient`, `drone`, `electronic`), **vocal type**, **decade**. Read those back off candidate tracks to learn the vocabulary rather than guessing slugs.

Two more tools matter here: `SearchSimilarToRecording { id }` once one candidate is right (the coherence tool), and every `Recording` exposes `stems: [DRUMS, BASS, MELODY, INSTRUMENTS, CLEAN_VOCALS, VOCALS]` — so a bed that is *almost* right can be reduced to its `BASS` + `DRUMS` stems for a pulse-only tension bed that leaves the speech corridor empty. That is the cheapest fix in this note and it is often better than another search. Fetch with `DownloadRecording` into `.media/audio/bgm/`.

**HyperFrames — placing the bed, carved against the voice.**

```html
<audio id="vo-s3-1" src=".media/audio/voice/s3-01.wav" data-audio-group="voiceover"
       data-start="182.40" data-track-index="10"></audio>

<audio id="bgm-tension" src=".media/audio/bgm/exile.wav"
       data-audio-group="music"
       data-start="181.20" data-duration="54.00" data-media-start="8.00"
       data-track-index="12" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```

- `data-media-start="8.00"` skips the track's warm-up — *"Every track has a little warm-up at the start — ignore that and start straight from the main beat."*
- **Carve settings live on the bed, never on a voice** (*"A voice carved against itself is a bug"*), `sources` is a list, and it must name a **group**, not clip ids (`audio_carve_ungrouped_sources`). Then run `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`, which needs `ffmpeg` on PATH and `@hyperframes/core` installed.
- **Building tension in the design layer instead**, when the catalogue will not deliver it: a drone clip plus a pulse clip, with a `lowpass` to keep them out of the voice, and a `gain` stage to automate (the workaround for the fact that `compressor`/`limiter`/`gate` have **no** automatable parameters):

```html
<audio id="des-drone" src=".media/audio/sfx/low-drone.wav" data-audio-group="design"
       data-start="181.20" data-duration="24.00" data-track-index="16" data-volume="0.063"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Keep Out Of Voice&quot;,&quot;params&quot;:{&quot;frequency&quot;:500,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},{&quot;type&quot;:&quot;gain&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;gain&quot;:0}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;fx.n2.gain&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:-12},{&quot;t&quot;:20,&quot;v&quot;:0},{&quot;t&quot;:24,&quot;v&quot;:-24}]}]}"></audio>
```

Chain order doctrine: *"Subtract before you add, level after you filter, relationships after level, character and ceiling last."* `gain` is automatable in dB (−60..12); a lane on a **non-automatable** parameter is *silently inert*, and a lane whose `nodeId` is typo'd is **pruned on read** with no error.

**ffmpeg — audition and analysis, plus one honest gap.**
```bash
ffmpeg -i bed.mp3 -lavfi showspectrumpic=s=1024x512:legend=1 bed-spectrum.png
ffmpeg -i bed.mp3 -af "bandpass=f=1500:width_type=o:w=2,astats=metadata=1:reset=5" -f null -   # speech-corridor energy
```
There is **no Shepard-tone generator and no pitch-envelope facility** in this stack (`data-playback-rate` is a constant in 0.1..5 with *"no rate envelope"*, and speed ramps *"must be preprocessed"*). A rising design tone must be fetched as a finished riser asset or preprocessed offline with `rubberband`/`asetrate`.

**Remotion:** identical thinking; the bed is an `<Audio>` with a volume callback. Concept only — no Remotion runtime here.

### Facet upgrade — instruments are an API filter, not one of the six UI facets
Worth stating plainly, because it changes how much this note's queries can be trusted. The Epidemic filter bar visible in `editing kt 3` is **`Moods | Genres | Duration | BPM | Vocals | Key`** — **instruments are not among them**. So the creator's instrument advice (*"if you want a suspense or tension vibe, then a violin"*) is being executed as a **search term**, not as a facet, and a term match against titles and descriptions is exactly the kind of soft match that returns a different neighbourhood every time it is run.

`filter.featuredInstrumentSlugs` — available on `SearchRecordings`, `{matchType, values}` — is the hard version of the same intent, and using it is a **strict reliability upgrade over the on-screen workflow**, not a copy of it. Pair it with the facets the UI does expose:

```
filter: { featuredInstrumentSlugs: { matchType: ANY, values: ["violin", "strings"] },
          moodSlugs: { matchType: ANY, values: ["suspense", "dark"] },
          vocals:   false,
          bpm:      { min: 70, max: 95 },
          duration: { min: 60000 } }
```
Two cautions carry over from the facet note: instrument slugs are **not enumerable** on this surface (the schema gives examples only — `acoustic-guitar`, `accordion`, `electronic-drums`), so discover them from returned tags and record what worked; and `matchType: ALL` across two instruments is usually over-constrained — a track "featuring" both is rarer than it sounds. [[sfx-epidemic-facet-query]] owns the six-facet map and the loosening order.

## Pairs with
[[sfx-bpm-filter-first]] · [[sfx-vibe-brief]] · [[sfx-mood-map-per-topic]] · [[sfx-music-stem-layering]] · [[sfx-track-change-at-section-boundary]] · [[sfx-music-audition-against-picture]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-layer-volume-targets]] · [[sfx-riser-anticipation-build]] · [[sfx-cross-cut-audio-strategy]] · [[sfx-second-sense-doctrine]] · [[struct-music-arc-to-narrative-arc]] · [[sfx-epidemic-facet-query]] · [[sfx-music-ten-point-framework]]

## Failure modes
- **Searching the mood word and auditioning forever.** "Suspense" is a label on 500+ finished tracks with nothing in common. Fix: name the mechanism, filter the instrument.
- **Stacking mood + instrument + BPM + key at once.** Verified: three filters took a 957-track pool to 14. You then pick the best of a bad fourteen and blame the catalogue. Fix: add filters one at a time, stop at 30 results, loosen BPM before instrument.
- **A sustained mid-band strings bed under narration.** It sits exactly where the voice lives, so you carve it hard, and a carve at 0.5 *"starts being heard as an effect rather than as room for the voice."* Fix: pulse/low-end instrumentation, or use only the BASS and DRUMS stems.
- **Dissonance with no resolution.** The listener is promised an arrival that never comes and reads the bed as wrong rather than tense. Fix: author the resolution frame — a hit, a drop, or the track's own arrival — before committing the bed.
- **Confusing a rising design tone with a riser.** A Shepard-type rise can run 20+ seconds and never arrive; a riser must arrive. Fix: log them as different layers and give the riser its landing.
- **Starting the track at its file head.** The section opens on an ambiguous swell. Fix: `data-media-start` past the warm-up.
- **Known gap:** the instrument→mechanism map is assembled from the acoustic research above plus the source's single named instrument (violin); the transcript's list was truncated by ASR. Treat the map as a starting hypothesis to be corrected against each profile's measured palette, and record what actually worked back into this note.
