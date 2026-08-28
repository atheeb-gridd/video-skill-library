---
id: sfx-mood-map-per-topic
title: The mood map — one target emotion per topic, and the audio that installs it
skill: sound-design
type: music
family: music-selection
tags: [skill/sound-design, type/music, family/music-selection, layer/music, layer/design, layer/sfx, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:11:56
    quote: "These sound effects work so well because they play on the viewer's emotions. And that's powerful, because the more emotionally invested viewers are, the more engaged they are."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:12:16"
    quote: "For example, I like picking songs that create a sense of anticipation, so viewers constantly feel like I'm about to say something really important."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:12:24"
    quote: "Then, in a section where I'm giving game-changing advice, I'll use a song with an innovative feel that builds a ton of excitement around what I'm saying."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:12:33"
    quote: "It's really easy to pull off. Split your video up by topic changes, then decide what mood you want the viewer to be in for each topic."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:12:41"
    quote: "By the way, you should put a lot of time into finding the right music, because it really matters that it fits."
research_refs:
  - https://en.wikipedia.org/wiki/Transportation_theory_(psychology)
  - https://en.wikipedia.org/wiki/Arousal
  - https://en.wikipedia.org/wiki/Tempo
  - https://www.epidemicsound.com/music/moods/
  - https://www.epidemicsound.com/music/genres/
  - https://support.epidemicsound.com/s/article/how-can-i-find-the-right-music-on-epidemic-sound
  - https://www.heather-fenoughty.com/composing-music/how-i-spot-cues-in-a-film-works-for-any-media-a-quick-and-dirty-guide/
  - https://www.artofcomposing.com/how-to-spot-a-film
  - mcp://Epidemic_sounds/SearchRecordings (mood/BPM/vocals filters probed live, 2026-08-28)
difficulty: medium
detectable_from: transcript+video
---

# The mood map — one target emotion per topic, and the audio that installs it

## What it is
A two-column document produced **before** any music is auditioned, and the claim behind every riser, hit and tone in this library: sound works on **emotion**, and *"the more emotionally invested viewers are, the more engaged they are."* The creator gives the operational form, which is what makes it a technique rather than a slogan — **split the video by topic change, decide the mood you want the viewer in for each topic, and choose the audio for that mood.**

Column one is the video's topic segmentation — every boundary where the subject changes, with in and out timecodes. Column two is, for each segment, **the emotional state the viewer should be in while watching it**, written as one word or short phrase. The track is then chosen to *produce* that state. This is the film-scoring **spotting session** compressed to creator scale: professionals sit with picture and decide, cue by cue, where music enters, what it is doing and where it stops, and the resulting cue list is what the composer or the library search works from.

Two things make it more than a nice idea. First, the mood is chosen for the **viewer**, not to describe the content: the source's own examples are "a sense of anticipation, so viewers constantly feel like I'm about to say something really important" and "an innovative feel that builds a ton of excitement" — both are descriptions of a state to induce, not of the subject matter. Second, the map is what makes the library search **deterministic**: every licensed library, Epidemic included, is searched by controlled facets, and a facet can only be filled in by someone who has already decided.

Research sharpens this in two ways that change what you actually author.

**First, emotion is two numbers, not one.** The circumplex model puts every affect on **valence** (negative↔positive) crossed with **arousal** (the *"'intensity' of an emotion"*). This matters because the two are installed by different controls: **arousal** is carried by tempo, loudness, density and brightness; **valence** is carried by mode (major/minor), harmony and instrument choice. "Make this section feel more intense" is an arousal instruction — raise BPM and SFX density. "Make it feel darker" is a valence instruction — change mode and instrument, and leave the tempo alone.

**Second, arousal is not monotonic in your favour.** *"The Yerkes–Dodson law states that there is an optimal level of arousal for performance, and too little or too much arousal can adversely affect task performance"*, and over-arousal produces *"attention narrowing, during which the range of cues from the stimulus and the environment decreases."* A video pinned at maximum arousal for ten minutes does not retain harder; it flattens, and the viewer stops registering individual cues — which is the same failure the source names as sound-effect overload ([[sfx-density-fatigue-audit]]). So the map's job is a **shape**, not a level: adjacent segments must differ.

The mechanism the arc is aiming at is **narrative transportation** — *"the experience of being carried away by a narrative"*, whose components are **focused attention** (*"individuals concentrate so intently on the story that environmental distractions fade away"*), **emotional engagement**, and **mental imagery**. Transported viewers show *"reduced counterarguing"*. That is exactly the state the creator describes as emotional investment, and it is produced by variation over time, not by intensity at any instant.

The related notes divide the work: [[sfx-music-sets-the-mood]] is *why* the bed owns the mood, [[sfx-vibe-brief]] is the single written commitment for a video or a section, [[pace-bpm-matched-music-selection]] is the tempo half of the search. **This note is the per-segment map** — the artefact that turns one brief into N searches.

**Segments and cues are different counts and this note keeps both.** A *segment* is a topic row in the map; a *cue* is a distinct bed. Adjacent segments that share a target emotion share one cue, so cues are always fewer than segments. Every count below is labelled with which one it governs; do not read a segment threshold as a cue threshold.

## When to use it
- **Once per project, before any music is fetched**, as the first sheet of `design-sound.md`, after the picture is roughly locked. Every later audio decision — track choice, rest windows, aesthetic accent placement — reads from this table. Choosing music per section without a map is how a video ends up with six tracks that all sound the same.
- **On any video longer than about 90 s that has more than one topic**, and mandatory on anything over ~3 minutes. It is mandatory in any list/chaptered format, where the segmentation already exists in the script.
- It is the fix for the two commonest music failures in creator work: one track running the whole video ([[sfx-music-rest-windows]]), and a music library scrolled at random until something "feels right" — the source's named waste.
- **Whenever a video "drags" without an obvious cause.** A flat arousal column across four consecutive segments is the usual finding, and it is fixable without touching a cut.
- **Whenever the analysis pass profiles a reference creator.** The reference's mood map *is* their editorial identity far more than their choice of whoosh.
- Skip it for anything under about 90 s or single-topic — a short has one mood, and the map collapses to a single row; the arc discipline still applies to where the music rests. Skip the *mood column* (not the segmentation) for segments you have already decided will be **silent**: a serious line, a reveal, a demonstration. Silence is a legitimate entry in the map and should be written into it explicitly.
- **Not** as a substitute for structure. The map annotates the segment boundaries that `design-cuts.md` already found; it does not invent them. If the structure has no topic changes, fix the structure first.

## How to recognise it in a reference video
- **Detect the cue boundaries mechanically first.** A per-frame RMS trace on the music-only frequency region shows cue entries and exits as sustained steps; a track change shows as a step *plus* a change in spectral content.
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  `n=1600` at 48 kHz is exactly one frame at 30 fps, so printed `pts_time` values are frame-aligned. Segment the reference **by music, not by content, first** — log every track change, hard stop and rest window with timecode.
- **Count distinct cues.** Listen for changes of instrumentation, key and tempo, not just level. A 10-minute creator explainer with a mood map typically runs **3–6 distinct cues** plus **1–3 deliberate silences**. One bed end to end means no map. More than about 8 cues in 10 minutes means the music is being changed for novelty rather than for structure.
- **Test boundary alignment.** For each cue change, measure its distance to the nearest *topic* boundary in the transcript. A mood map produces changes within **±2–3 s** of a topic boundary. Changes that land mid-topic — mid-argument especially — are either an arc device ([[struct-music-arc-to-narrative-arc]]) or randomness, and are the tell that no map exists.
- **Read arousal per segment from four measurables**: track BPM (tap or use the library's own value), cut rate (cuts/min), SFX density (effects/min), and short-window loudness of the music bed. These move together in a mapped video.
- **Look for the contrast requirement.** Adjacent segments should differ by **≥1 step on a 5-step arousal scale** — typically ≥20 BPM, or ≥30 % in cut rate, or the presence/absence of the bed. Four consecutive segments at the same BPM band is an unmapped video.
- **Name each cue's mood in library vocabulary** (see the mapping table below) and write the sequence out: e.g. `Hopeful → Suspense → Epic → Laid Back`. A good map has **contrast at the joins** — adjacent cues rarely share a mood, and the emotional trajectory has a shape.
- **Valence is read from mode and instrument**, not tempo: minor-key pads, low strings and detuned synths for negative; major-key plucks, piano, brass and claps for positive. A section that is fast *and* dark is high-arousal/low-valence — that combination is the "tension" cell and is used sparingly.
- **Check the mood against the content, and expect a deliberate mismatch sometimes.** The strongest tell of an authored map is a cue whose mood is *not* the obvious one for the subject: tension music under a mundane demonstration to make it feel consequential, or laid-back music under a big claim to make it read as confident.
- **Rest windows.** Count seconds of *no music* per 5 minutes. A mapped video has **4–12 s of full-bed silence at least once per 5 min**, almost always immediately before or after the most important line ([[sfx-music-rest-windows]]).
- **Aesthetic accents cluster on boundaries.** Plot riser/hit timecodes against segment boundaries: in a mapped video **≥70 %** of them land within 2 s of one. Scattered accents mean the accents are decorating, not structuring.
- **BPM per cue.** Extract each cue's tempo and compare it to the local speaking rate. A map that was executed properly shows tempo tracking delivery, not one tempo throughout ([[pace-bpm-matched-music-selection]]).
- **Vocals audit.** Cues under narration should be instrumental; vocal cues should coincide with narration-free montage ([[sfx-vocal-vs-instrumental-bed]]).
- **Transcript signals for the segmentation itself.** Discourse markers ("so", "now", "but here's the thing", "next"), enumerators ("point number three", "the second thing"), explicit chapter language ("now let's talk about", "moving on"), reframes ("but here's the problem"), and any on-screen title card or chapter marker. Use those as the candidate boundary set, then confirm against the audio.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `segments` (topic rows) | 7 per 10 min | 5–12 per 10 min | One per script section; do not manufacture extra. Fewer than 5 and the map does nothing; more than 12 and every track change is a disruption. |
| `segment_len` | 90 s | 45–180 s | One topic per row. Under 45 s the audio cannot establish; over 180 s the arousal reads flat. |
| `cues` (distinct beds) | 4 per 10 min | 2–8 per 10 min | **Always ≤ `segments`** — two adjacent segments with the same target emotion share one cue. |
| `min_cue_len` | 25 s | 15–45 s | Below ~15 s a bed cannot establish and reads as an accident. |
| `max_cue_len` | 150 s | 60–240 s | Past this, either the topic is too long or the bed needs rest. |
| `silences` / `rest_window` | 6 s, twice per 10 min | 4–12 s, 1–4 per 10 min | Explicit no-music entries; music out entirely, dialogue and ambience continue. A map with zero is not a map, it is a playlist. |
| `boundary_tol` | ±2 s | ±0–4 s | Cue change vs topic boundary. Tighten to ±0.5 s when the change is meant to be *felt* as a chapter marker ([[sfx-track-change-at-section-boundary]]). Reading a reference, allow ±3 s. |
| `arousal_scale` | 5 steps (1 calm … 5 peak) | — | Step 1: 60–85 BPM · 2: 85–100 · 3: 100–120 · 4: 120–140 · 5: 140–170. Aligns with [[sfx-bpm-perceptual-bands]]. |
| `adjacent_contrast` | ≥1 arousal step, and no repeated mood facet | 1–2 steps | 3 steps in one boundary is a smash-cut gesture, not an arc; use once at most. If two consecutive cues must share a mood facet, change instrumentation or BPM by ≥15 instead. |
| `peak_arousal_segments` | 2 per 10 min | 1–3 | Step 5 is a spend, not a setting. |
| `step_1_segments` | ≥1 per 10 min | 1–3 | The floor is what makes the peaks legible. |
| `valence_per_segment` | +1 (positive) | −2 … +2 | Sets mode and instrument, not tempo. −2 only for genuinely dark material. |
| `moods_per_video` | 3 | 2–5 | Distinct mood facets across the whole map. More than 5 and the video has no identity. |
| `intent_words_per_cue` | 1 | 1–2 | One primary mood, at most one modifier. "Anticipation + hopeful" is fine; four adjectives is an unsearchable brief. |
| `mood_vocab` | Epidemic mood facet | — | Always resolve the intent word to one of the library's 34 controlled moods before searching. |
| `accents_per_boundary` | 1 | 0–1 | Total still capped at 3 per 10 min ([[sfx-riser-credibility-budget]]). Spend them on the largest arousal steps. |
| `bed_level` | −22 dB → `data-volume="0.079"` | −25 to −20 dB | Constant across the map; arousal is carried by the track, not by the fader. |
| `bed_level_loud_guitar` | −30 dB → `data-volume="0.032"` | −32 to −28 dB | The source's own exception for loud rock ([[sfx-loud-guitar-minus-30]]). |
| `bed_change_crossfade` | 0.6 s (18 f) | 0.3–1.5 s | Or a hard stop on a beat if the boundary is a smash cut. |
| `vocals` | `false` wherever narration runs | `true` only in narration-free montage | The source's rule; see [[sfx-vocal-vs-instrumental-bed]]. |

**The map's own columns**, which is what the note actually produces:

| Column | Values |
|---|---|
| `segment` | index + label (`03 — the objection`) |
| `t_in` / `t_out` | composition seconds |
| `emotion` | one word from the standing table ([[sfx-emotion-music-lookup-table]]) |
| `arousal` | 1–5 |
| `valence` | −2 … +2 |
| `bpm_band` | derived from arousal |
| `mood_slugs` | Epidemic mood filter values |
| `vocals` | true/false |
| `rest` | none · pre · post |
| `accent` | none · riser · hit · tone · riser+hit |

**Intent-word → Epidemic mood facet.** The creator's own vocabulary is not the library's; this join is the step most people skip, and it is why searches come back empty. Epidemic exposes exactly **34** browsable moods: *Angry, Busy & Frantic, Changing Tempo, Chasing, Dark, Dreamy, Eccentric, Elegant, Epic, Euphoric, Fear, Floating, Funny, Glamorous, Happy, Heavy & Ponderous, Hopeful, Laid Back, Marching, Mysterious, Peaceful, Quirky, Relaxing, Restless, Romantic, Running, Sad, Scary, Sentimental, Sexy, Smooth, Sneaking, Suspense, Weird.* Note that **"anticipation" and "innovative" are not among them** — the source's two named examples both require a translation step:

| Intent (what you wrote in the map) | Epidemic mood facet(s) | Arousal / valence | Notes |
|---|---|---|---|
| Anticipation — "something important is coming" | `Suspense`, `Restless`, `Mysterious` | 3 / 0 | Add BPM 90–115 and a pulse/arpeggio instrument filter; the anticipation is carried by the ostinato, not the mood tag. |
| Innovative / game-changing advice | `Epic`, `Hopeful`, `Euphoric` | 4 / +2 | Filter to synth/electronic instrumentation; the "innovative" quality is a timbre, not a mood. |
| Serious, credible, sober | `Heavy & Ponderous`, `Dark` (low intensity) | 2 / −1 | Consider silence instead ([[sfx-music-rest-windows]]). |
| Fun, playful segment | `Funny`, `Quirky`, `Happy` | 3 / +2 | Pairs with [[sfx-cartoon-comedy-family]]. |
| Calm explanation / how-to body | `Laid Back`, `Smooth`, `Peaceful` | 1–2 / +1 | The default bed for instructional stretches. |
| Tension, the problem statement | `Suspense`, `Dark`, `Fear` | 3–4 / −2 | Keep it under −25 dB; tense beds mask consonants. |
| Triumph, the payoff / result reveal | `Epic`, `Euphoric`, `Hopeful` | 5 / +2 | Where a drop belongs ([[struct-music-arc-to-narrative-arc]]). |
| Nostalgic, story/origin section | `Sentimental`, `Dreamy` | 2 / 0 | |
| Urgency, speed, montage | `Running`, `Busy & Frantic`, `Chasing` | 4–5 / +1 | Vocal permitted if the presenter is silent. |

## Reproduction prompt

```
Build the mood map for {{VIDEO}} and emit it as a table BEFORE fetching any
music. Then execute it.

1. SEGMENT. Read the transcript and design-cuts.md. Cut the video at topic
   changes - discourse markers ("so", "now", "but here's the thing"),
   enumerators ("number three"), reframes, and on-screen title cards -
   confirmed against the structure doc. Target 90 s per segment, 45-180 s
   allowed, 5-12 segments per 10 minutes. Output rows:
   segment_id | t_in | t_out | one-line topic.

2. NAME THE TARGET STATE for each segment in one word - the state the VIEWER
   should be in during that topic, not a description of the content. Write the
   sentence "while watching this the viewer should feel ___" and use that word.
   "Pricing" is a topic; "anticipation" is a mood. Mark any segment that should
   have NO music as SILENT and give the reason.

3. SPLIT IT INTO TWO NUMBERS. arousal 1-5 (how activated) and valence -2..+2
   (how positive). Arousal will set tempo, density and brightness. Valence will
   set mode and instrument. Do not let one word set both by accident.

4. SHAPE THE COLUMN, not the level. Enforce: no two adjacent segments share an
   arousal value; at least one segment at 1 and at most three at 5 per 10
   minutes; never more than two consecutive segments above 3. If the column
   violates any of these, change the segments' targets now - it is free here
   and expensive later.

5. MERGE INTO CUES. Adjacent segments with the same target state share one
   cue. Aim for 3-6 cues plus 1-3 silences per 10 minutes. No cue shorter than
   15 s, none longer than 150 s.

6. TRANSLATE each target state into the library's controlled mood vocabulary
   before searching. Do not search on your own adjective - "innovative" and
   "anticipation" are not facets. Add exactly one modifier facet if needed
   (instrument family or genre), never four.

7. DERIVE THE REMAINING DECISIONS per row.
   bpm_band from arousal: 1=60-85, 2=85-100, 3=100-120, 4=120-140, 5=140-170,
     cross-checked against the local speaking rate.
   mood_slugs from the emotion via the standing emotion-to-music table.
   vocals=false wherever your narration runs; true only in narration-free
     montage.
   duration >= cue length.
   rest: mark "post" on the segment that ends with the video's most important
     line.

8. ALLOCATE ACCENTS. At most one aesthetic accent per boundary and at most 3
   per 10 minutes total. Spend them on the largest arousal steps. Boundaries
   with no step get no accent.

9. SEARCH once per cue with the full facet set (SearchRecordings: bpm +
   moodSlugs + vocals + duration). Audition against picture, at final level,
   not in isolation. Two candidates per cue, then choose.

10. CHECK CONTRAST: no two consecutive cues share a mood facet. If they must,
    change instrument family or BPM by at least 15 instead.

11. PLACE each bed as its own timeline clip at its segment in-point, at -22 dB
    under narration (-30 dB for loud guitar-led tracks), instrumental under
    voice, carved against the voiceover group. Arousal is carried by the
    track, never by raising the fader.

ACCEPTANCE TEST.
(a) Read the arousal column alone: it must look like a shape, not a line.
(b) List the mood sequence as words - it should read as a trajectory, not a
    list of synonyms.
(c) Play only the music, muted picture, front to back. The section boundaries
    must be audible without the words, and at each cue change a topic must
    actually change there within 2 seconds.
(d) Every accent lands within 2 s of a boundary.
(e) There is at least one 4-12 s window per 5 minutes with no music at all.
(f) Dialogue is fully intelligible in every segment at the mapped level. If
    not, the map is irrelevant - fix the mix first.
```

## Execution spec

**Placement spec (per map row, not per sound).**

| | Offset vs the segment boundary | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Music bed | starts on the boundary, or −0.6 s for a crossfade | −22 dB (`data-volume` 0.079); −30 dB loud guitars | carve against the `voiceover` group, `strength` 0.25 |
| Boundary accent (riser) | peak **on** the boundary frame; body starts 1.5–3 s early | −13 dB (0.224) | bed −6 dB across the build, restored +0.1 s |
| Boundary accent (hit) | attack on the boundary frame, 0 to −1 f | −9 dB (0.355) | bed returns immediately |
| Rest window | starts on the last word of the important line | bed to 0 (silence) | n/a — this *is* the duck, taken to its limit |

**HyperFrames — the map becomes one bed clip per cue plus one carve.** Beds live at the **host root** in a modular project so playback survives scene cuts, and they belong to a `music` group so the carve can name the `voiceover` group as its source.

```html
<audio id="vo-s2" src=".media/audio/voice/s2.wav" data-audio-group="voiceover"
       data-start="96.0" data-track-index="10"></audio>

<!-- segment 02: "the problem", arousal 2, valence -1, 88 BPM, instrumental. 96.0s -> 182.0s -->
<audio id="bed-seg02" src=".media/audio/bgm/seg02.mp3"
       data-audio-group="music" data-start="96.0" data-duration="86.0"
       data-media-start="7.4" data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.6,&quot;v&quot;:1},{&quot;t&quot;:79.0,&quot;v&quot;:1},{&quot;t&quot;:79.6,&quot;v&quot;:0},{&quot;t&quot;:86.0,&quot;v&quot;:0}]}]}"></audio>

<!-- segment 03: "the objection", arousal 4, 128 BPM, starts 182.0s -->
<audio id="bed-seg03" src=".media/audio/bgm/seg03.mp3"
       data-audio-group="music" data-start="182.0" data-duration="104.0"
       data-track-index="12" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.6,&quot;v&quot;:1}]}]}"></audio>
```

The details that decide whether this is right:
- **`data-media-start="7.4"`** is how you skip a track's warm-up and start on its first main beat without cutting the file.
- **`data-volume="0.079"`** is roughly −22 dB (`10^(-22/20) ≈ 0.079`); the attribute is a linear gain with `1` = 0 dB.
- **The 6.4 s rest window** is authored inside `bed-seg02`'s lane (`79.0 → 79.6` down, held to the clip end), not by shortening the clip — that keeps the fade shape under your control and the clip boundary somewhere harmless.
- **A lane holds its first value backwards to the clip start and its last value forward to the end**, so the explicit `t:0` point and the explicit terminal point are both load-bearing. Without `t:0, v:0` the bed starts already at full. Its `t` is **clip-local seconds**.
- **Every `<audio>` needs an `id`** — an id-less audio element is never mixed and renders silent with no warning.
- **Give each bed its own `data-track-index`** (11, 12, …) so overlapping handovers do not raise `duplicate_audio_track`.
- **Carve, do not duck, under narration.** *"A bed playing under narration wants a carve… Skip it only when there is no narration."* Settings live on the **bed**, never on a voice; `sources` names a **group**, not a list of clip ids (`audio_carve_ungrouped_sources`); and the voice group must contain voices only — a bed or SFX clip inside it silently poisons the next re-analysis. Then run it once for the whole composition:
  ```bash
  node <SKILL_DIR>/scripts/carve.mjs --comp index.html
  ```
  `strength` 0.25 is *"a 6 dB dip in three bands"*; 0.5 is heard as an effect. If the bed sounds notched rather than quieter, the strength is too high.
- **Write JSON attributes double-quoted with `&quot;`.** `carve.mjs` finds them with a `name="..."` regex; a single-quoted attribute is invisible to it and the next carve overwrites work it could not see.
- **Do not also GSAP-tween `volume`** on a track that has a `volume` lane — the lane wins silently (`audio_volume_double_automation`).

**Epidemic Sound (MCP) — one query per map row.** `SearchRecordings` takes exactly the map's columns:

```
SearchRecordings {
  query: { term: "suspense pulse ostinato instrumental" },
  filter: { bpm: { min: 96, max: 112 },
            moodSlugs: { matchType: ANY, values: ["suspense","restless","mysterious"] },
            vocals: false,
            duration: { min: 62000 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 15 }
```
Recording nodes return `bpm` directly, plus `tags` carrying a `dimension.name` of **`mood`**, **`genre`**, **`production genre`** or **`vocal type`** — that is the field to record into the shortlist ([[sfx-track-shortlist-library]]). Verified live: `bpm 100–120` + `vocals:false` alone still returns the 10 000-result ceiling, so **mood is what actually narrows a music search**, not BPM; BPM is the disqualifier, mood is the selector. For an adjacent-segment change that must feel continuous rather than new, take the previous winner's id into `SearchSimilarToRecording` instead of a fresh query ([[sfx-find-similar-track-handover]]). `DownloadRecording` to a project-local path (`.media/audio/bgm/` or `assets/bgm/`). The MCP produces a file and stops; everything after is HyperFrames. Optionally ledger it: `node <SKILL_DIR>/scripts/resolve.mjs --from <file> --type bgm --project .`

**ffmpeg — loudness-matching, and the arc audit on a finished mix.** Loudness-match a set of cues to each other before placement so the map does not need per-cue gain fiddling:
```bash
ffmpeg -i cue.mp3 -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -   # measure
```
then apply with the measured values. Do **not** bake ducking — declare it with the carve.

Nothing in the stack measures an arc, so measure loudness over time and read the shape:
```bash
# 5-second-window loudness trace of the finished mix -> the arousal column, measured
ffmpeg -i mix.wav -af "asetnsamples=n=240000,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=arc.txt" -f null -
# programme check after the map is in
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
```
A mapped video shows **LRA ≥ 6**; a flat one shows LRA under 4. That single number is the fastest objective test of whether an arc exists.

**Remotion.** One `<Audio>` per cue inside a `<Sequence>` whose `from`/`durationInFrames` come from the map, with volume as a function of frame for the rest window. Concept only; no Remotion runtime exists here.

## Pairs with
[[sfx-emotion-music-lookup-table]] · [[sfx-emotion-and-pace-diagnosis]] · [[sfx-bpm-perceptual-bands]] · [[sfx-track-change-at-section-boundary]] · [[sfx-music-rest-windows]] · [[sfx-music-hard-stop]] · [[sfx-riser-credibility-budget]] · [[sfx-riser-hit-pair]] · [[sfx-tone-bed-mystery]] · [[sfx-three-types-classification]] · [[struct-stimulation-budget]] · [[sfx-find-similar-track-handover]] · [[sfx-track-shortlist-library]] · [[sfx-vocal-vs-instrumental-bed]] · [[struct-music-arc-to-narrative-arc]] · [[pace-tempo-band-energy-map]] · [[sfx-vibe-brief]] · [[sfx-music-sets-the-mood]] · [[pace-bpm-matched-music-selection]] · [[pace-rough-cut-diagnostic]] · [[sfx-music-audition-against-picture]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-loud-guitar-minus-30]] · [[sfx-density-fatigue-audit]] · [[sfx-beat-aligned-handover]]

## Failure modes
- **A flat arousal column.** The commonest failure and the reason a well-cut video still drags: every segment sits at 3–4, so nothing is a peak. Fix by *lowering* two segments, not by raising the rest — the floor is what makes a peak legible.
- **Confusing arousal with volume.** Raising the bed fader to make a section feel bigger buys 3 dB of intensity and costs dialogue intelligibility. Intensity comes from the track's tempo, density and brightness. The fader stays at −22 dB.
- **Describing the content instead of the viewer.** "This section is about pricing, so… business music" — "editing tutorial section" is not a mood and cannot be searched. Fix: complete the sentence "the viewer should feel ___", which for a pricing section is usually relief or confidence.
- **Searching on your own adjective.** "Innovative" and "anticipation" return nothing useful because neither is a library facet. Fix: run the translation table, then search.
- **Reading a segment count as a cue count.** Twelve segments does not mean twelve tracks; merging adjacent rows with the same target is the step that keeps the video coherent. Fix: keep the two columns separate in the map.
- **Segment boundaries invented for the music.** Changing the bed where no topic changed reads as restlessness. Fix: the segmentation comes from the script, and music follows it — never the reverse.
- **Track changes that miss the boundary.** A bed change 8 s into a new topic reads as an error even when the track is right. Fix: land it on the boundary or on the first beat after it ([[sfx-beat-aligned-handover]]).
- **Five moods in five minutes.** Constant re-characterisation leaves the video with no identity. Fix: 3 moods, 2–5 max, and get variety from instrumentation and BPM instead.
- **Spending every accent early.** Three risers in the first two minutes leaves the actual climax undressed, and risers *"lose their credibility and stop working"* once they have promised nothing three times.
- **No silences in the map.** Every mood is present so none registers; the serious line has nowhere to land. A bed running the whole video removes the map's strongest single gesture. Fix: at least one explicit SILENT row per 10 minutes — silence is the highest-contrast arousal step available and it costs nothing to fetch.
- **Cues that fade rather than end.** A cue with no decided out-point drifts under the next topic. Fix: give every cue an out-point in the map, and stop it on a waveform peak.
- **Vocal bed under narration.** Two voices compete and intelligibility drops, regardless of how well the mood matches. Fix: the map's `vocals` column exists for exactly this; instrumental wherever the presenter speaks.
- **Level set per cue by ear.** Different masters land at different loudness, so the map sounds uneven. Fix: loudness-match the set before placement, then one carve.
- **Known gap:** no library publishes a mapping from natural-language intent to its own facets, and Epidemic's mood list has no "anticipation" or "innovative" entry. The translation table above is house-built from the published 34-mood vocabulary and should be extended per project rather than treated as complete.
- **Known gap — nothing validates the arc.** The linter reads `data-automation` for exactly two conflicts and *"nothing validates the chain or the effect lanes at all."* The LRA measurement above is a proxy, and it needs a rendered mix, which on this VM must happen on another host. Plan for the map to be checked late.
