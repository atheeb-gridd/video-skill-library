---
id: sfx-vocal-vs-instrumental-bed
aliases: [sfx-vocals-only-without-narration]
title: Vocal tracks only where your own voice isn't — and the stem that gets you out of it
skill: sound-design
type: music
family: bed-selection
tags: [skill/sound-design, type/music, family/bed-selection, engine/hyperframes, engine/epidemic, engine/ffmpeg, layer/music, layer/dialogue, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:03:24
    quote: "If you're showing an epic montage or an inspiring journey, tracks with vocals will suit it much better and make a much bigger impact."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:03:36
    quote: "So the rule for this is really simple: wherever your own voice isn't there, using music with vocals works better. But where your own voice is there, putting a vocal track behind it can create a bit of a conflict"
research_refs:
  - https://en.wikipedia.org/wiki/Irrelevant_speech_effect
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Music_and_emotion
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://www.isca-archive.org/interspeech_2018/scharenborg18_interspeech.pdf
  - https://pure.mpg.de/rest/items/item_3490253/component/file_3490254/content
  - https://www.isca-archive.org/interspeech_2023/huo23_interspeech.pdf
  - https://pureaudioinsight.com/blogs/content-production/background-music-volume-how-loud-should-it-be
  - https://bunnystudio.com/blog/voice-over-background-music-best-practices/
  - mcp://Epidemic_sounds/SearchRecordings (vocals filter and stem types probed live, 2026-08-28)
difficulty: low
detectable_from: audio
---

# Vocal tracks only where your own voice isn't — and the stem that gets you out of it

## What it is
A hard selection rule with a measurable reason. Lyrics and narration are **two competing linguistic streams**, and the brain cannot fully suppress the one it is not attending to. The interference is **informational**, not merely energetic: the listener's language system tries to parse both. Background speech degrades verbal working memory even when it is quiet, even when it is unintelligible, and even when the target material was presented visually — it interferes with the rehearsal process itself, not with audibility.

**That is why the usual mix tools do not rescue it.** Ducking and spectral carving solve *energetic* masking — one signal burying another in the same band at the same time. They cannot solve informational masking, because **you cannot attenuate meaning**. A vocal bed carved 6 dB under narration is quieter and just as distracting.

So the rule stands as stated: sections with narration get **instrumental** beds; sections with no narration — a montage, a demonstration window, an emotional beat, a title sequence, a cold open, the credits — are where a **vocal** track earns its keep, and where it will outperform an instrumental for impact. It is a routing decision made at the section level, before any track is auditioned.

And there is exactly one legitimate escape hatch, which this note also owns: **Epidemic ships every track as stems**, so the `INSTRUMENTS` stem of the vocal track you loved *is* the instrumental version, with the same arrangement and the same energy curve. Use it instead of hunting for a different track.

This note is the **selection rule**. Scoring a montage *with* a vocal track — hook alignment, the stem handover, fitting the track to the window — is [[sfx-vocal-track-for-narration-free-montage]].

## When to use it
Apply it during music selection, section by section, as the **very first filter** — before BPM ([[pace-bpm-matched-music-selection]]), before vibe ([[sfx-vibe-brief]]). Every section is one of two kinds, **narrated** or **unnarrated**, and the kind decides whether a vocal track is even a candidate.

- **Vocal — yes** in any window with no voiceover and no on-camera speech: a montage, a before/after reveal, an establishing sequence, a b-roll run, a wordless demo, a cold open, an outro over an end card.
- **Vocal — yes** when the lyric *is* the content: a section whose whole point is the song, or a beat where you deliberately let a hook land in a silence you made ([[sfx-music-rest-windows]]).
- **Instrumental — always** under narration, dialogue, an interview answer, or a voiced screen recording.
- **Instrumental — always** under a **captioned line the viewer is reading**. Reading is a linguistic task too; lyrics interfere with captions as well as with speech.
- **Instrumental — always** under a section carrying numbers, names or instructions. Informational masking hits verbal *serial* recall hardest, which is exactly what a list of steps is.
- **The stem route** when the right track happens to have vocals: take its `INSTRUMENTS` stem rather than rejecting the track. This is the answer whenever the arrangement and energy arc already fit the edit.

It matters most in videos that alternate — an explainer with a cold-open montage, a tutorial with a silent demonstration window ([[pace-silent-demonstration-window]]), a vlog with a b-roll sequence.

**The one place the rule bends** is a vocal whose content is **non-lexical**: wordless "ooh"/"ah" pads, a vocal used as texture, a chopped-vowel hook, or lyrics in a language the audience does not speak. Those carry much less informational masking and can sit under narration if kept low. In the catalogue this is the difference between a `vocal presence` tag and a `lead vocals` tag.

**Not workarounds:**
- **Carving harder.** Past `strength` ~0.35 the bed sounds notched and there is still a second voice in the room.
- **Panning the bed wide.** Spatial separation reduces energetic masking but barely touches informational masking, and it collapses on the mono phone speaker most viewers use.

## How to recognise it in a reference video
- **Segment the timeline into narrated and unnarrated spans** from the transcript. Every span longer than ~4 s with no words is an unnarrated section; log its start and end.
- **Classify the bed in each span.** Listen for lyrics; where the mix makes it hard, high-pass at 300 Hz and listen in the 300 Hz–4 kHz band — that is where both a voice and a lead vocal live, and is exactly why they conflict. On a spectrogram, sung vowels show as stacked harmonic bands with vibrato; the presenter's speech shows the same bands with faster formant transitions.
- **Build a two-column log:** `narration present (y/n)` × `vocals present (y/n)`. **The only defective cell is y/y.** Report it with timecodes — that is the finding a design document needs.
- **Word-level transcript overlap test.** Where a transcript exists, any music-vocal onset falling inside `[word.start, word.end]` for a narration word is a hit. Fully automatable, and the recommended detector.
- **Distinguish `lead vocals` from `vocal presence`.** A `vocal presence` track may carry only wordless "oohs", pads or chops — texture, not a competing stream, and legal under narration. `lead vocals`, and any `lyric type` tag (`clean` / `explicit`), mean real words, which are not.
- **The expected pattern of a correct reference:** instrumental under every narrated span; vocal tracks appearing *only* in unnarrated spans; the switch happening **at the section boundary**, not fading in mid-sentence. Typical distribution: **0 % vocal under narration; 60–100 % vocal in narration-free windows longer than ~8 s.**
- **Measure the level relationship**, because it is the second half of the diagnosis:
  ```bash
  ffmpeg -i ref.wav -af "loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json" -f null -
  ```
  Run it on the full mix, then on a narrated span and an unnarrated span separately. Consistent practitioner targets: **dialogue −3 to 0 dB peak / music −20 to −25 dB** under narration, with loud guitar-led material pulled to about **−30 dB**. An unnarrated span typically sits **6–15 dB louder** on the music.
- **The give-away failure.** A reference with a vocal track under narration shows the editor fighting it: unusually deep ducking (more than ~12 dB), aggressive EQ holes in the mid band, or the music dropping out entirely every time the presenter speaks. **Deep ducking under a vocal bed is the symptom; the wrong track is the disease.**
- **Check the montage sections for the inverse defect.** A wordless montage running an instrumental bed is a missed opportunity, not an error — but log it, because the source's own rule says vocals "suit it much better and make a much bigger impact" there.
- **Research anchor for why level alone does not fix it.** In a controlled study, sung lyrics significantly reduced spoken-word recognition versus the same music instrumental (**β = −1.245, p < .001**) **at all three signal-to-noise ratios tested (+15 dB, +5 dB, 0 dB)**, with the conditions energy-matched. +15 dB SNR is the "restaurant" condition — quieter, relatively, than a typical −20 dB bed — and the lyric penalty was still there. Musical complexity hurt too, but only at the low SNRs; the *lyric* penalty was SNR-independent. That is the empirical form of the creator's "conflict".

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `narrated_bed` | instrumental | instrumental only | Hard rule. `vocals: false` at the search layer. |
| `unnarrated_bed` | vocal permitted | vocal \| instrumental | Vocal preferred for montage/emotional/title spans. |
| `nonlexical_exception` | allowed | — | Wordless or non-target-language vocals may sit under narration, at the low end of the music range. |
| `acceptance_tag_under_narration` | `vocal type == "no vocals"` | — | Reject `lead vocals`. Judge `vocal presence` by ear: wordless texture is fine, words are not. |
| `min_span_to_change_track` | 4 s (120 f) | 3–5 s | Below this, do not change tracks at all — keep the instrumental running. A chorus that starts and is cut off by the next line is worse than no change. |
| `min_span_for_a_vocal_track` | 8 s | 6–12 s | Between 4 s and 8 s, change to an *instrumental* if you change at all: shorter than this and the lyric has no room to register before the voice returns. |
| `music_under_voice` | −22 dB (`data-volume` 0.079) | −20 to −25 dB | Relative to a dialogue peak of −3 to 0 dB. |
| `music_loud_source` | −30 dB (0.032) | −28 to −32 dB | Loud rock / loud guitars need more room than the number suggests ([[sfx-loud-guitar-minus-30]]). |
| `music_unnarrated` — music is the foreground | −10 dB (0.316) | −8 to −12 dB | An epic montage where the bed *is* the content. |
| `music_unnarrated` — montage sharing attention | −14 to −16 dB (0.158–0.2) | −14 to −18 dB | Where captions or on-screen text are also being read. |
| `duck_depth_ceiling` | −6 dB | −3 to −12 dB | Needing more than 12 dB of duck means the **track** is wrong, not the duck. |
| `carve_strength` | 0.25 | 0.20–0.35 (hard ceiling 0.40) | Voiceover carve default. Above 0.35 the bed audibly notches; at 0.5 the dip reaches ~10 dB and is heard as an effect. Never a substitute for removing lyrics. |
| `switch_point` | section boundary | — | Change tracks at a structural boundary, on a beat or at a waveform peak — never mid-sentence. |
| `handover_ramp` (vocal montage → narration) | 0.6 s | 0.4–1.0 s | Swap to the `INSTRUMENTS` stem, or drop 6 dB, across this ramp — ending **before** the first narration word. |
| `lead_in_before_first_word` | 0.5 s | 0.3–0.8 s | The vocal must be **gone, not fading**, when speech starts. |

## Reproduction prompt

```
Select and place the music beds for a narrated video at 30fps under the
vocal/instrumental rule.

1. SEGMENT. From the word-level transcript, build the list of NARRATED spans and
   UNNARRATED spans (any gap >= 120 f / 4.0 s with no words). Merge unnarrated
   spans shorter than 120 f into the narrated span around them - they are
   pauses, not sections. Reading counts: a window carrying dense on-screen
   captions the viewer must read is treated as speech.

2. ROUTE by window length as well as by speech:
     any speech present        -> INSTRUMENTAL ONLY. No exceptions, no ducking
                                  workaround, no carve strength that fixes it.
     no speech, span < 4 s     -> do not change tracks; keep the instrumental.
     no speech, 4-8 s          -> change if the section warrants it, but to an
                                  INSTRUMENTAL - a lyric cannot register yet.
     no speech, >= 8 s         -> VOCAL TRACK PERMITTED, and preferred if it is
                                  a montage, an emotional beat, a cold open, a
                                  title sequence, or a cinematic demonstration.
   The only vocals permitted under narration are non-lexical: wordless pads,
   chopped vowels, or lyrics in a language the target audience does not speak -
   and those go at the bottom of the music level range.

3. SEARCH with vocals as a hard filter, not a preference:
     narrated   -> filter.vocals = false
     unnarrated -> filter.vocals = true
   Then apply BPM and mood filters on top, from the standing emotion table.
   Never audition a vocal track for a narrated span; it will sound good in
   isolation and fail in the mix, which wastes the audition.

4. GATE ON THE TAG, NOT THE FILTER. For every returned node, read tags[] and
   find the entry whose dimension.name == "vocal type". Under narration keep
   only "no vocals"; discard "lead vocals"; audition "vocal presence" - wordless
   pads and chopped syllables are acceptable texture, intelligible words are
   not. The vocals boolean is VERIFIED TO LEAK, so this step is mandatory.

5. IF THE RIGHT TRACK HAS VOCALS AND THE WINDOW HAS NARRATION, DO NOT REJECT IT.
   Read recording.stems[] and take the stem whose type is INSTRUMENTS. That is
   the same arrangement with the voice removed - a better instrumental than any
   different track you would find. For the full-quality file rather than the
   lqmp3 preview, run EditRecording with skipStems=false and download the edit.
   Then AUDITION it: a stripped vocal track often has an obvious melodic hole
   where the singer was.

6. LEVEL. Dialogue peaks -3 to 0 dB. Instrumental under narration -22 dB
   (-30 dB if guitar-led or dense). Vocal in an unnarrated montage -10 dB where
   the music is the foreground, -14/-16 dB where captions are also being read.

7. PLACE. Instrumental under narration: data-audio-group="music",
   data-volume="0.079", carved against the voiceover group at strength 0.25.
   Vocal in a montage: NO carve - there is nothing to carve against, and
   carving against a group with no members is a silent no-op.

8. TRANSITION at the SECTION BOUNDARY. Stop the outgoing track on a peak in its
   waveform, start the incoming one on a downbeat. Never crossfade a vocal track
   into a narrated span. If a vocal montage runs into narration, the vocal must
   be FINISHED 0.5 s before the first word - either end the track there, or
   cross into the INSTRUMENTS stem of the same track over 0.6 s so the bed
   continues and only the voice leaves.

9. CARVE, DO NOT DUCK, under narration. If the duck you need is deeper than
   12 dB for intelligibility, STOP: the track is wrong. Replace it with a
   sparser instrumental rather than ducking harder.

ACCEPTANCE TEST: (a) build a list of every narration word start time and every
music-vocal onset - zero overlaps; (b) play each narrated span at final level
with your eyes shut and write down the narration from memory - if you cannot, or
if you can make out any word that is not the presenter's, the bed is wrong
regardless of what the tag said; (c) confirm no duck exceeds 12 dB and no carve
exceeds 0.35; (d) confirm every track change lands on a section boundary, not
inside a sentence.
```

## Execution spec

**Placement spec.** A bed has no frame offset — it starts on the section's first frame and its first downbeat lands there. Gains: **instrumental under narration −22 dB** (`data-volume` 0.079); **vocal in a narration-free montage −10 to −16 dB** (0.158–0.316) depending on whether the music is the sole foreground. Ducking: instrumental beds get a **voiceover carve at strength 0.25**, not a level duck; vocal montage beds get **no carve and no duck**.

**Epidemic Sound — this is where the rule is actually enforced.** `SearchRecordings` exposes `filter.vocals` as a boolean — a hard catalogue filter, applied upstream of any listening.

```json
// under narration
{ "filter": { "vocals": false,
              "moodSlugs": { "matchType": "ALL", "values": ["laid-back"] },
              "bpm": { "min": 85, "max": 105 },
              "duration": { "min": 120000 } },
  "sort": { "by": "POPULARITY", "order": "DESCENDING" }, "first": 12 }

// narration-free montage
{ "filter": { "vocals": true,
              "moodSlugs": { "matchType": "ALL", "values": ["epic"] },
              "bpm": { "min": 120, "max": 140 } },
  "sort": { "by": "POPULARITY", "order": "DESCENDING" }, "first": 12 }
```

**Verified live on 2026-08-28: `vocals: false` does not guarantee an instrumental result.** Two independent probes with `vocals: false` returned tracks carrying a `vocal presence` tag — one under `moodSlugs ALL ["hopeful"] + bpm 100–120`, one under a plain term search. The reliable gate is the returned tag: each node's `tags[]` entries carry `{displayName, dimension:{name}}`, and the **`vocal type`** dimension takes the values `no vocals`, `vocal presence`, `lead vocals`. A separate **`lyric type`** dimension (`clean`, `explicit`) appears only on tracks with real words and is a useful secondary signal.

**The stem escape hatch is the important capability here.** Every `Recording` returns `stems[]` with types drawn from `DRUMS`, `BASS`, `MELODY`, `INSTRUMENTS`, `CLEAN_VOCALS`, `VOCALS`, and `DownloadRecording` accepts `options.stemType` with `FULL | BASS | DRUMS | INSTRUMENTS`:

```
DownloadRecording({ id: "<uuid>", options: { fileType: "WAV", stemType: "INSTRUMENTS" } })
```

Taking the `INSTRUMENTS` stem of a vocal track is the sanctioned vocal-removal route — not a hack, a shipped asset — and it preserves the arrangement and energy arc that made you pick the track. Verified on typical results: *Mindscape* returns `INSTRUMENTS / MELODY / BASS`; *Higher* returns `INSTRUMENTS / VOCALS / BASS / DRUMS`. Two caveats: **not every track ships every stem**, so check the array before planning a section around one; and a stem is a different arrangement from the full mix — often a hole where the melody was — so its level and density change. Audition it against picture ([[sfx-music-audition-against-picture]]) and re-measure rather than reusing the full track's gain.

`EditRecording` produces a length-exact version (`targetDurationMs`, max 300000 ms, `forceDuration`, `loopable`) and can be pointed at the sections you want kept with `preferenceRegions` / `requiredRegionsAtOffsets` — useful for making a vocal montage bed land its chorus on the montage's peak. `skipStems: true` makes that faster when you do not need the stems; `skipStems: false` is how you pull a full-quality stem set ([[sfx-track-reversion-to-edit-length]]).

**HyperFrames.** The two cases are structurally different and the difference is the carve.

```html
<audio id="vo-3" src=".media/audio/voice/line-03.wav" data-audio-group="voiceover"
       data-start="18.4" data-track-index="10"></audio>

<!-- narration section: instrumental, carved, quiet -->
<audio id="bed-narrated" src="assets/audio/bgm/laidback-92-instruments.wav"
       data-audio-group="music" data-track-index="11"
       data-start="18.0" data-duration="64" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>

<!-- montage: vocal, hot, UNCARVED, out 0.5 s before the next word at 88.0 -->
<audio id="bed-montage" src="assets/audio/bgm/epic-vocal-128.wav"
       data-audio-group="music" data-track-index="12"
       data-start="82.0" data-duration="5.5" data-volume="0.316"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:4.9,&quot;v&quot;:1},{&quot;t&quot;:5.5,&quot;v&quot;:0}]}]}"></audio>
```

Contract points:
- **`data-volume` is a linear gain**, default `1` = 0 dB, max `3.98` = +12 dB. −10 dB ≈ `0.316`; −16 dB ≈ `0.158`; −22 dB ≈ `0.079`; −25 dB ≈ `0.056`; −30 dB ≈ `0.032`.
- **Carve, do not duck, under narration:** *"The reflex is to duck the whole bed, which works and costs the bed all of its presence… Carve takes only those [bands the voice occupies], and the bed keeps its low end and its top."* Settings live on the **bed**, never on a voice; `sources` must name a **group**, not clip ids (`audio_carve_ungrouped_sources`); the group must contain **voices only** — a bed or SFX clip inside it poisons the next re-analysis; `data-fx-carve` is clip-only, never on an `<hf-audio-group>` (`audio_group_carve_attr`). Then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html` — it needs `ffmpeg` on PATH and `@hyperframes/core` installed, and refuses when it cannot tell which track is the bed.
- **`strength` 0.25** is a ~6 dB dip in three bands. If the bed sounds notched rather than quieter, the strength is too high. **Carve strength is not a fix for a lyric bed** — carve follows *speech*, and a sung lyric is speech-like enough to make the carve chase the wrong signal.
- **Two overlapping beds must not share a `data-track-index`** (`duplicate_audio_track`), and every `<audio>` needs an **`id`** or it is never mixed → silent render.
- **Write JSON attributes double-quoted with `&quot;`** so `carve.mjs`'s regex can see them; a single-quoted attribute is invisible and the next carve silently overwrites work it could not see.
- **Do not stack a `volume` lane and a GSAP `volume` tween** on one track: the lane wins (`audio_volume_double_automation`), and a tween replaces `data-volume` outright rather than scaling it (`audio_volume_tween_overrides_gain`).
- There is **no de-esser, no noise removal and no pitch shifter** in the FX registry, and **no source separation anywhere in this stack**. Nothing here can "carve out the lyrics" — the informational masking is linguistic, not spectral, and no EQ move removes it. That is why the rule is a *selection* rule and the Epidemic stem is the whole answer.

**ffmpeg — verification only.**
```bash
# is there sung content under the narration? compare the bed alone against the mix
ffmpeg -i bed.wav -af "highpass=f=200,lowpass=f=4000,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
# final loudness for delivery
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
```
Baked sidechain ducking (`sidechaincompress=threshold=0.03:ratio=8:attack=200:release=400`) exists, but the contract is explicit: *"Bake only for assets leaving the hyperframes pipeline."*

**Remotion:** two `<Audio>` tracks with different `volume` props switched at a section boundary. A selection constraint, not a rendering one — portability note only.

### Facet upgrade — the Vocals facet, with the counts read off the screen
The visual pass settles what kind of decision this is. The Epidemic UI's **Vocals facet is one of six** in the filter bar, and the contact sheet catches it expanded with real counts: **`Vocals 291` / `Instrumentals 2529`**. Two things follow.

**It is a filter, not a judgement call.** The decision is made before any listening, in `filter.vocals`, exactly as the rule in this note requires — and a fetch recipe that omits it is relying on luck rather than on the rule.

**The two sides are not the same size.** In that filtered view the instrumental side is roughly **9× larger**. Filtering to instrumentals therefore costs essentially nothing in choice, which removes the last excuse for auditioning vocal tracks for narrated sections; while the vocals side is a **narrow slice** that should be spent deliberately, on the narration-free montage where it earns its place ([[sfx-vocal-track-for-narration-free-montage]]). Ratios will differ per query — treat 9:1 as the observed order of magnitude, not a constant.

The filter is still known to leak, so the gate stays two-stage: `filter.vocals: false` upstream, then confirm the returned `vocal type` tag before committing. [[sfx-epidemic-facet-query]] owns the six-facet query shape.

## Pairs with
[[sfx-vocal-track-for-narration-free-montage]] · [[sfx-emotion-music-lookup-table]] · [[sfx-beat-forward-bed-under-voice]] · [[sfx-music-rest-windows]] · [[sfx-music-stem-layering]] · [[sfx-track-reversion-to-edit-length]] · [[sfx-layer-volume-targets]] · [[sfx-dialogue-gate]] · [[sfx-music-primacy-doctrine]] · [[sfx-track-change-at-section-boundary]] · [[struct-music-arc-to-narrative-arc]] · [[pace-bpm-matched-music-selection]] · [[sfx-vibe-brief]] · [[sfx-music-sets-the-mood]] · [[sfx-music-audition-against-picture]] · [[pace-silent-demonstration-window]] · [[sfx-sound-pass-order]] · [[struct-outcome-first-cold-open]] · [[sfx-loud-guitar-minus-30]] · [[sfx-epidemic-facet-query]] · [[sfx-music-ten-point-framework]]

## Failure modes
- **A vocal track under narration, ducked to compensate.** The interference is informational, not energetic — it persists at every level tested, including quiet ones. A quiet second voice is still a second voice, and the viewer's comprehension of your narration drops without them being able to say why. Fix: change the track, do not change the level.
- **Trusting `vocals: false`.** Verified to leak `vocal presence` results. Gate on the `vocal type` tag every time.
- **Auditioning vocal tracks for narrated sections.** They sound great alone and lose the moment the voice arrives, and the audition time is wasted. Fix: `filter.vocals: false` at the search layer, so they never enter the shortlist.
- **Rejecting the right track for having vocals.** Take its `INSTRUMENTS` stem. Hunting for a different instrumental usually costs an hour and lands somewhere worse.
- **Using the INSTRUMENTS stem without auditioning it.** A stripped vocal track often has an obvious melodic hole where the singer was. Fix: audition the stem against picture like any other candidate.
- **Assuming every track has an `INSTRUMENTS` stem.** The `stems[]` array varies per recording. Check it before you plan the section around it.
- **Carving harder instead of switching.** Past `strength` 0.35–0.4 the bed sounds notched and the voice still competes with the lyric. The carve is for instrumental beds; a lyric bed is out of its scope.
- **Landing the vocal's tail on the first narration word.** The vocal must be *finished*, not fading, 0.5 s before speech starts. A lyric decaying under "So the first thing…" is the same defect at half the level.
- **Switching tracks mid-sentence.** The change reads as a technical fault. Fix: change on a section boundary, stopping the outgoing track at a waveform peak and starting the incoming one on a downbeat.
- **Vocal music under dense captions.** Reading is a verbal task. If the viewer is parsing on-screen words, lyrics interfere with that too.
- **Wide-panning the bed as a workaround.** It barely helps informationally and it collapses on the mono phone speaker most viewers use.
- **Treating wordless vocals as forbidden.** Non-lexical vocal pads are a legitimate and common cinematic bed under narration. The rule is about *lyrics*, not about the timbre of a human voice.
- **Vocal bed in a 3-second gap.** A chorus that starts and is immediately cut off by the next line is worse than no change at all. Fix: 120-frame minimum before considering a track change, 8 s before considering a *vocal* one.
- **Missing the inverse.** A wordless montage on an instrumental bed is not wrong, but it leaves the impact on the table. Log those windows and consider a vocal track.
- **Known gap:** nothing in this stack detects lyrics automatically, and there is **no source separation and no de-esser**; `carve` has no static mode. The vocal/instrumental classification of a *reference* video's bed is a listening judgement and should be logged as human-verified. If a delivered mix already contains an unwanted vocal bed, there is no in-composition repair — the fix is upstream, at selection. On the sourcing side the `vocals` filter plus the `vocal type` tag gate and the `INSTRUMENTS` stem make the rule mechanical, which is the only place it is mechanised.
