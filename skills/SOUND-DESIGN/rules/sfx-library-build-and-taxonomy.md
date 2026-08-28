---
id: sfx-library-build-and-taxonomy
title: Build the sound library before the timeline — taxonomy, naming and ingest
skill: sound-design
type: sfx
family: library
tags: [skill/sound-design, type/sfx, family/library, engine/epidemic, engine/ffmpeg, engine/hyperframes, layer/sfx, source/editing-kt, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:10:51
    quote: "But for now, the first step of sound design is building up a library of sounds to work with."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:11:02
    quote: "If you need more, check out freesound.org or grab Epidemic Sound."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:09:47
    quote: "One more very important thing: if you have to use a sound effect repeatedly - say you need a whoosh three or four times in a row - don't use the same whoosh sound there. It sounds really odd, people pick up on it."
research_refs:
  - https://universalcategorysystem.com/
  - https://freesound.org/help/faq/
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (catalogue title grammar and tag-slug shape probed live, 2026-08-28)
difficulty: medium
detectable_from: transcript
---

# Build the sound library before the timeline — taxonomy, naming and ingest

## What it is
Sound design is named as starting *before* the edit: assemble a reusable, cleared collection of sounds first, then place them. The claim is operational, not motivational — the reason a sound pass takes twenty minutes for one editor and three hours for another is almost entirely retrieval speed. A library is three things: a **category taxonomy** that matches how you decide (the three styles, then the families), a **filename convention** that makes the category machine-readable, and an **ingest step** that normalises loudness so `data-volume` numbers written in one note mean the same thing on every file.

The single most valuable structural decision is that the library stores **variant sets**, not single files. The source's own repetition rule — never the same whoosh three times in a row — is a *library* requirement, not a timeline one: you cannot rotate variants you never collected.

**Style.** No `sfx/` style tag: the taxonomy is what *holds* the three styles, so it cannot sit inside one of them — the top level of the category tree is exactly `diegetic` / `motion` / `aesthetic` as defined in [[sfx-three-types-classification]].

## When to use it
- **Once per project profile**, before the first sound pass. Build the shelf, then shop from it.
- **Whenever a query in a rule note returns the right asset** — write the asset back into the library with its query, so the next project starts from a hit instead of a search.
- **Before any unattended run.** An agent editing without supervision cannot audition fifty candidates; it needs a pre-cleared shelf with known filenames and known levels. This note is what makes that possible.
- **Not** as a substitute for per-project fetching. Ambience and music are picked against the actual footage ([[sfx-ambience-search-formula]], [[sfx-music-audition-against-picture]]); the library holds the *reusable* half — motion effects, aesthetic effects, UI, cartoon, generic foley.

## How to recognise it in a reference video
You are detecting a creator who *has* a library versus one who grabs per-video.
- **Recurrence across videos.** Pull two or three videos from the same channel, extract the SFX transients, and compare spectra. A library creator's whoosh, hit and appearance sounds are **identical files across videos** — the same file hash, the same waveform. That recurrence *is* the sonic identity and is the thing worth reproducing.
- **Variant depth inside one video.** Count distinct whooshes. A library creator shows **3–8 distinct** whoosh files in a ten-minute video with none repeating inside a 3-use window. A per-video grabber shows one file used 15 times.
- **Level consistency.** Measure the peak of every SFX: `ffmpeg -i ref.wav -af "astats=metadata=1:reset=1" -f null -`. A normalised library shows SFX peaks clustered inside a **3 dB** band. Un-normalised grabs scatter over 12 dB or more, which shows up as some effects blasting and others inaudible.
- **Family coverage.** Tabulate effects by the three styles. A creator with a library has a **diegetic** column; a creator with a pack of transitions has only `sfx/motion`.
- **Transcript signal:** creators with a library say the sound's *name* ("put a riser here"); creators without say "some sound". Naming vocabulary is the tell — see [[sfx-name-before-search]].

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `top_level_split` | the three styles | — | `diegetic/`, `motion/`, `aesthetic/`. Style first, because style is what you decide first. Families sit inside. |
| `families_per_style` | 12 | 8–20 | motion: whoosh, swish, whip, impact, appearance, ui, transition-full · aesthetic: riser, hit, tone, texture, braam, sub-drop · diegetic: footstep, cloth, object, door, keyboard, phone, ambience, room-tone. |
| `variants_per_family` | 5 | 3–8 | The rotation depth. Under 3 the repetition mistake is unavoidable. |
| `filename_pattern` | `<style>_<family>_<descriptor>_<nn>.wav` | — | e.g. `motion_whoosh_short-bright_03.wav`. Lowercase, hyphens inside a field, underscores between fields, zero-padded index. Parseable by a glob and sortable. |
| `ingest_peak_target` | −6 dBTP | −9 to −3 dBTP | Normalise every one-shot to the same **peak** on ingest. Peak, not LUFS: a 300 ms transient has no meaningful integrated loudness. |
| `ingest_lufs_target` | −23 LUFS | −27 to −20 LUFS | For **beds only** (ambience, room tone, loops), where integrated loudness is meaningful. EBU R 128's programme target, chosen because it leaves headroom under a −14 LUFS delivery. |
| `ingest_true_peak_ceiling` | −1 dBTP | — | R 128's ceiling. Keep it on every ingested file so a later limiter has something to do. |
| `sample_rate` / `bit_depth` | 48 kHz / 24-bit | — | Match the composition's audio path; 48 kHz is the video standard. |
| `file_format` | WAV | WAV only | mp3 encoder pre-echo smears the exact transient you align to a frame. Never store the working library as mp3. |
| `sidecar_index` | `library.json` | — | One record per file: path, style, family, descriptors, `peak_t` (seconds from file head), duration, source, licence, the query that found it. `peak_t` is the field that saves the most time later ([[sfx-peak-at-motion-midpoint]]). |
| `licence_field` | required | — | Never ingest a file without it. See [[sfx-source-licensing-and-clearance]]. |

## Reproduction prompt

```
Build or extend the project sound library at {{LIB_ROOT}}.

1. CREATE THE TREE. Three top-level directories named for the three styles:
   diegetic/ motion/ aesthetic/ . Inside each, one directory per family
   (motion/whoosh, motion/swish, motion/impact, motion/appearance, motion/ui,
   aesthetic/riser, aesthetic/hit, aesthetic/tone, aesthetic/texture,
   diegetic/footstep, diegetic/cloth, diegetic/object, diegetic/ambience,
   diegetic/room-tone). Do not create a "misc" directory - it becomes the
   whole library within a month.
2. FETCH IN VARIANT SETS, never singles. For each family, run the family
   note's Epidemic query, pick ONE asset that matches the profile, then run
   SearchSimilarToSoundEffect on it and take {{VARIANTS}}=5 more. Download
   WAV. A family with one file is not stocked.
3. RENAME on ingest to <style>_<family>_<descriptor>_<nn>.wav, lowercase,
   hyphens inside fields, underscores between fields, index zero-padded to 2.
4. NORMALISE. One-shots: peak-normalise to -6 dBTP. Beds and loops longer
   than 10 s: two-pass loudnorm to I=-23 LUFS, TP=-1 dBTP. Convert everything
   to 48 kHz 24-bit WAV. Do not compress and do not EQ at ingest - treatment
   is a per-placement decision.
5. MEASURE peak_t FOR EVERY ONE-SHOT: the offset in seconds from the file
   head to its loudest sample. Store it. This is the number every placement
   note subtracts, and measuring it once here removes it from every later
   placement.
6. WRITE library.json: one record per file with path, style, family,
   descriptors, duration_ms, peak_t, source, licence, query_used.
7. RECORD THE LICENCE for every file before it enters the tree. A file with
   no licence field is not in the library, it is a liability.

ACCEPTANCE TEST: pick any three families at random. Each must contain at
least 3 files, whose peaks measure within 3 dB of each other, whose names
parse against the pattern, and each of which has a licence and a peak_t in
library.json. Then grep library.json for duplicate source ids - the same
asset filed twice under two names defeats the rotation.
```

## Execution spec

**Epidemic Sound — stock the shelf, one family at a time.** The catalogue's own title grammar is `Category, Subcategory, Descriptors` (verified live: `"Swooshes, Whoosh, Designed, Generic, Air"`, `"Ambience, Room Tone, Office Room Tone, AC"`, `"Footsteps, Human, Shoes, Concrete Walk"`), and tag slugs are `category--subcategory`. That grammar is the fastest way to stock a family: search the category term, read the `tags[].slug` off a good hit, then re-search filtering on that slug so you get the whole subcategory rather than a relevance mixture.

```
# 1. find one good asset in the family
SearchSoundEffects { query:{term:"whoosh transition"}, filter:{duration:{min:200,max:900}},
                     sort:{by:POPULARITY,order:DESCENDING}, first:20 }
# 2. read its tags[].slug  ->  e.g. "swooshes--whoosh"
# 3. harvest the whole subcategory at the length you want
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["swooshes--whoosh"]},
                              duration:{min:200,max:900} },
                     sort:{by:POPULARITY,order:DESCENDING}, first:30 }
# 4. build the variant set around the one you chose
SearchSimilarToSoundEffect { id:<uuid>, first:12 }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Verified slugs worth seeding the library with: `swooshes--whoosh`, `swooshes--swish`, `cartoon--swish`, `cartoon--pop`, `cartoon--misc`, `cartoon--musical`, `user-interface--motion`, `user-interface--click`, `fight--impact`, `ambience--room-tone`, `cloth--movement`, `footsteps--human`, `wood--break`, `gore--bone`, `communications--phonograph`, `voices--misc`, `human--misc`, `beeps--general`, `games--video`. `filter.duration` is in **milliseconds** and is the single most useful filter in the whole API — a family stocked by length bands (short 150–500 ms, medium 500–1200 ms, long 1200–3000 ms) is a family you can fetch from by motion length later.

**ffmpeg — the ingest normalisation.** Two different jobs, and using the wrong one is the common error:
```bash
# ONE-SHOTS: peak-normalise to -6 dBTP, resample, 24-bit
ffmpeg -i in.wav -af "volume=-6dB:precision=float" -ar 48000 -c:a pcm_s24le out.wav   # only after measuring
# measure first:
ffmpeg -i in.wav -af "astats=measure_overall=Peak_level" -f null - 2>&1 | grep Peak_level
# BEDS/LOOPS: two-pass EBU R128 to -23 LUFS
ffmpeg -i bed.wav -af loudnorm=I=-23:TP=-1:LRA=11:print_format=json -f null -
ffmpeg -i bed.wav -af loudnorm=I=-23:TP=-1:LRA=11:measured_I=<i>:measured_TP=<tp>:measured_LRA=<lra>:measured_thresh=<th>:offset=<off>:linear=true -ar 48000 -c:a pcm_s24le bed.norm.wav
# peak_t for the sidecar index, ffmpeg-only route (n=1600 @48k = one frame @30fps)
ffmpeg -i in.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
```
Note `loudnorm` on a 300 ms one-shot is meaningless — its gating threshold discards almost the whole file. Peak-normalise one-shots; loudness-normalise beds.

**HyperFrames — why the library shape matters to the composition.** Placement reads three things out of `library.json` and nothing else: the `src` path, `peak_t` (to compute `data-start`), and the family's level. All authored time is in **seconds**; there is no frame attribute. Because every one-shot was normalised to the same peak on ingest, a family's level can be written once as a constant:

```html
<audio id="sfx-whoosh-07" src="assets/sfx/motion/whoosh/motion_whoosh_short-bright_03.wav"
       data-audio-group="sfx" data-start="41.02" data-duration="0.62"
       data-track-index="22" data-volume="0.211"></audio>
```
`data-volume` 0.211 ≈ −13.5 dB, the SFX slot ([[sfx-layer-volume-targets]]). Keep every SFX in `data-audio-group="sfx"` — a non-voice clip inside the `voiceover` group silently poisons the next carve re-analysis. Every `<audio>` needs an `id` or it is **never mixed and the render is silent with no error**.

**Storage constraint, stated because it changes the workflow:** the mounted vault folder **cannot delete files**. The library is therefore append-only. Superseding a bad ingest means writing `..._04.wav` and marking `_03` as `retired: true` in `library.json`, never removing it. Do all normalisation scratch work **outside** the mount.

**Remotion:** the same tree and the same `library.json`; a `staticFile()` path per asset. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-source-licensing-and-clearance]] · [[sfx-name-before-search]] · [[sfx-search-vocabulary]] · [[sfx-layer-volume-targets]] · [[sfx-peak-at-motion-midpoint]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-swoosh-vs-whoosh]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-reverb-glue]] · [[sfx-sound-pass-order]] · [[sfx-ambience-search-formula]] · [[sfx-mouth-foley-record-and-process]] · [[struct-stimulation-budget]] · [[motion-sfx-pass-manifest]]

## Failure modes
- **A flat folder of 400 files with vendor names.** `WHOOSH_designed_generic_air_02.wav` next to `sfx_final_v3.wav` next to `boom.wav`. Unsearchable within a month. Fix: style/family tree plus the filename pattern, applied at ingest, with no exceptions.
- **One file per family.** Guarantees the repetition mistake the source names explicitly. Fix: variant sets of five, built with `SearchSimilarToSoundEffect`.
- **No loudness normalisation.** Every placement then needs its own gain guess, and the `data-volume` numbers in every other note in this library become meaningless. Fix: peak-normalise one-shots to −6 dBTP at ingest.
- **Loudness-normalising one-shots with `loudnorm`.** The gate throws away most of a short file and the result is wrong and unpredictable. Fix: peak for one-shots, LUFS for beds.
- **Storing mp3.** Pre-echo on the transient you are trying to land on a frame. Fix: WAV in the library; mp3 only for previews.
- **No `peak_t` in the index.** Every placement then re-measures, and half of them skip it and land the accent late. Fix: measure once at ingest.
- **A `misc/` directory.** Absorbs everything and becomes the library. Fix: if a sound does not fit a family, that is evidence a family is missing — add the family.
- **Ingesting without a licence field.** The one failure that survives publication. Fix: [[sfx-source-licensing-and-clearance]] is a gate, not a footnote.
- **Known gap:** the Universal Category System is the industry's standard SFX taxonomy and the right thing to converge on, but its exact filename template and CatID list live in UCS's own distribution and could not be retrieved here. The naming pattern above is a project convention chosen to be UCS-*compatible* in shape (category-first, delimiter-separated, machine-parseable) rather than a quotation of UCS. If the UCS spec is available, prefer it and record the mapping in `library.json`.
