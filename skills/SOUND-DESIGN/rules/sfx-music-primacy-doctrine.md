---
id: sfx-music-primacy-doctrine
aliases: [sfx-music-first-layer-priority]
title: Music is the biggest lever — it decides engagement, it sets the mood, and it is funded first
skill: sound-design
type: music
family: music-selection
tags: [skill/sound-design, type/music, family/music-selection, layer/music, layer/dialogue, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:20"
    quote: "It is important. That's how important music is: put good music on even a plain, ordinary edit and the video still becomes engaging."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:26"
    quote: "But even after insanely good editing, if the music isn't good, it just doesn't land."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:03:11"
    quote: "Whether you want to give a serious, mysterious feel, or some funky, fun vibe, it's all controlled by the music."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:03:05"
    quote: "You don't figure out the vibe — you create the vibe. As an editor, you're the one with that power."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:02:38"
    quote: "Layer 5 — Music: it drives the emotion, makes the video feel complete, and is the one single layer that can carry an entire video on its own."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:02:49"
    quote: "Now music is the layer that drives the emotion. It's the layer that makes the video feel complete."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:02:53"
    quote: "And it's the one single layer that can carry an entire video on its own."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:26"
    quote: "First of all, if this itself is bad, then no amount of sound design is going to make a difference."
research_refs:
  - https://en.wikipedia.org/wiki/Film_score
  - https://en.wikipedia.org/wiki/Mickey_Mousing
  - https://en.wikipedia.org/wiki/Habituation
  - https://mubert.com/blog/how-to-make-music-fit-your-video-length-exactly
  - https://air.io/en/youtube-hacks/advanced-retention-editing-cutting-patterns-that-keep-viewers-past-minute-8
  - https://blog.audionetwork.com/the-edit/music/how-to-choose-music-for-a-voiceover-heavy-video
  - https://adobevideoworld.com/montage-editing-guide/
  - https://www.forte-ai.com/blog/audio-post-production-workflow-from-picture-handoff-to-final-mix
  - mcp://Epidemic_sounds/SearchRecordings — filter surface probed live 2026-08-28 (bpm, moodSlugs, taxonomySlugs, featuredInstrumentSlugs, musicalKeys, vocals; every result carries bpm, stems and mood-dimension tags)
difficulty: medium
detectable_from: audio
---

# Music is the biggest lever — it decides engagement, it sets the mood, and it is funded first

## What it is
One doctrine with three claims, all stated flatly by the source and all about the same thing: of all the variables an editor controls, the music track moves the outcome most.

**Claim one, engagement.** An ordinary cut with the right track reads as engaging, while a virtuoso cut with the wrong track does not land.

**Claim two, tone.** Serious/mysterious versus funky/fun is not decided by the grade or the pacing — it is decided by the bed, and the editor decides it rather than discovering it (*"you don't figure out the vibe, you create the vibe"*).

**Claim three, structural.** Music is *"the one single layer that can carry an entire video on its own"*, which no other layer can. Ambience alone is a location with nothing happening; foley alone is noise; effects alone are a machine. Music alone is a film.

The operational consequences are two, and they are different from each other.

**Scheduling.** If music is the dominant variable, it must be chosen against the rough cut *before* time is spent on cut-level polish, because the polish is worth less than the track and because the track changes what the polish should be. A serious bed wants longer holds; a funky bed wants faster cutting. Choosing music last means half the cutting decisions were made against the wrong tone.

**Funding.** Claim three gives a triage rule for the case that actually occurs on every deadline: **if only one layer will be added, add music**; if two, music and ambience. This is a **priority**, not a pass **order**, and the difference matters. [[sfx-sound-pass-order]] runs dialogue → ambience → foley → effects → music → mix, because everything is levelled against dialogue; that is the order passes must be *executed* in. This note is about which passes get *funded*. Order says music comes late; priority says music comes first out of the budget. Both are true at once, and the note's alias — "music first layer priority" — is a name for the funding claim, not a claim that music is authored first.

The literal reading of "carry alone" is also a real editing move: a montage, a cold open or a B-roll sequence with music and no words is a section deliberately handed to the music layer ([[sfx-vocal-track-for-narration-free-montage]]).

The one hard precondition is the source's own: **if the dialogue recording is bad, none of this applies.** *"No amount of sound design is going to make a difference"*, and this stack has **no noise removal** to fall back on.

This note is the doctrine, the schedule and the funding order. The mechanics of *how* to search live in the sibling notes: parameters ([[sfx-bpm-filter-first]], [[sfx-instrument-filter-search]]), vibe brief ([[sfx-vibe-brief]]), emotion mapping ([[sfx-emotion-music-lookup-table]], [[sfx-mood-map-per-topic]]), rests and stops ([[sfx-music-rest-windows]], [[sfx-music-hard-stop]]), and level ([[sfx-layer-volume-targets]]).

*(This note absorbs three techniques that arrived separately — "music carries engagement more than editing polish", "mood is controlled almost entirely by the music", and "music is the layer that can carry a video alone, so fund it first". They are one claim with three consequences and are documented here together; the alias is kept so all are findable.)*

## When to use it
- **As a rule about the order of work, on every project with music.** Lock the rough cut, then audition beds, then polish. Not the other way round.
- **As triage, when the sound budget will not cover all five passes.** This note tells you what to cut and in which order.
- **As diagnosis, when a finished-looking edit still feels flat** or "unfinished" while measuring correctly on cuts, levels and captions. Before recutting anything, replace the bed and watch it again. A missing or characterless bed is the most common single cause, and it is also the cheapest thing to change.
- **As design, when planning a section that has no narration** and must still carry meaning, where the music becomes the section's only through-line.
- **When the brief names a feeling** ("make it feel serious", "make it fun"). Reach for the mood filter before reaching for the grade or the cut rhythm.
- **When a section changes job** — hook to body, body to demonstration, demonstration to close. Tone is a per-section property; one bed for eleven minutes is a tonal flatline ([[sfx-track-change-at-section-boundary]]).
- **Do not** apply it as "always add music". The doctrine's own corollary is that music is powerful enough to be *wrong*, and that killing it is a tonal move in itself: a serious line lands hardest with the bed gone ([[sfx-music-rest-windows]], [[sfx-music-drop-on-structure-turn]]).
- **Do not** let it override intelligibility. Dialogue at 0 to −3 dB wins; the bed lives at −20 to −25 dB and is carved, not just ducked ([[sfx-dialogue-gate]]).

## How to recognise it in a reference video
You are measuring how much of the reference's effect is carried by its bed.

- **Layer census on a 60-second sample.** Listen four times, once per layer, and mark presence: dialogue, ambience, foley, effects, music. Then read the shape: `dialogue + music` only is a triaged video and usually still works; `dialogue + effects` with no music is the characteristic under-funded edit; all five is a real sound pass.
- **Music presence ratio** — fraction of runtime with an audible bed. Detect by high-passing away the voice band and looking for sustained energy:
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=48000,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null | paste - -
  ```
  Creator talking-head references typically run **0.55–0.85**. A ratio near 1.0 means the bed never rests, which correlates with the video feeling relentless and which the source treats as a mistake in its own right; below 0.4 the bed is decorative.
- **The mute-the-voice test.** Play a section with the dialogue muted. If the remaining audio still communicates a register — hopeful, tense, playful — the music layer is doing its job. If it becomes wallpaper, the bed was chosen by scrolling, not by decision ([[sfx-vibe-brief]]).
- **Bed level under speech.** Measure a speech window and a nearby speech-free window and difference them. Expect the bed **17–25 dB** below dialogue. Anything under 12 dB is fighting the voice; anything over 30 dB is decorative to the point of pointlessness. A bed sitting at one level throughout means no music pass happened.
- **Carve versus duck.** Under narration, listen for whether the bed loses its *whole* level or only the bands the voice occupies. A bed that keeps its low end and its top while the voice is speaking has been carved; a bed that shrinks entirely has been ducked ([[sfx-sound-pass-order]]).
- **Count tracks and locate the changes.** A reference that changes bed at each structural turn is using music as a section marker. **2–4 tracks per 10 minutes**, changing *at* section boundaries, is a designed score; one unchanging track for 12 minutes is a drop-in. Log each change timecode and check it against the narrative beat sheet.
- **Does the bed have an arc?** Trace a windowed RMS curve over a section and look for build and release rather than a flat line — `asetnsamples=n=24000` at 48 kHz is a 0.5 s window. A designed score's curve tracks the structure; a loop's curve is flat within ±2 dB for minutes.
- **Read the tone against the words.** Take three 20-second windows in different sections, describe the bed in the creator's own vocabulary (serious/mysterious vs funky/fun), and compare with what the narration is doing. A reference whose music tone *tracks* its narration tone is executing this doctrine; one whose bed is tonally constant is not.
- **Music rests.** Look for deliberate stops — at a serious line, before a reveal, at the end of a section. Their presence is a strong signal of an intentional music pass; their absence is the "bed left running for 12 minutes" signature.
- **Programme loudness.** `ffmpeg -i ref.mp4 -af ebur128=peak=true -f null -` — delivered work sits near **−14 LUFS** (socials) or **−16 LUFS** (podcast) with true peak ≤ **−1.5 dBTP**.
- **The swap test, on the reference.** Mute the reference's bed and replace it with a tonally opposite one at the same level. If the section's meaning visibly changes, the bed was carrying the meaning — which is the claim, demonstrated on someone else's footage, and the fastest way to convince a sceptical client.
- **Retention correlation, when you have the data.** Line the bed's changes and rests up against the retention curve in analytics. Interpret cautiously: co-occurrence, not proof.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `layer_priority` | dialogue-fix → music → ambience → motion SFX → foley → aesthetic | fixed | **Funding** order under scarcity. Not the execution order — see [[sfx-sound-pass-order]]. |
| `dialogue_quality_gate` | pass/fail | — | If the voice recording is bad, stop and re-record; there is no noise removal in this stack. Checked before anything else. |
| `music_time_share` | 25 % of the audio budget | 15–35 % | The scheduling consequence of the doctrine. If SFX placement is eating the music budget, the priority is inverted. |
| `audition_candidates` | 3 | 3–6 | Against picture, not in the browser preview ([[sfx-music-audition-against-picture]]). Below 3 you have not chosen; above 6 is procrastination. |
| `audition_window` | 45 s of the rough cut | 30–90 s | Audition against the *hook plus one body beat*, the two sections most sensitive to tone. |
| `music_coverage` | 0.75 | 0.55–0.85 typical · 0.4–0.9 outer | Fraction of runtime with a bed. **1.0 is a failure mode, not a maximum.** Below 0.4 the bed is decorative. |
| `rest_share` | 0.15 | 0.1–0.3 | Fraction of runtime with no music at all, placed deliberately. The complement of coverage, and a design decision rather than a leftover. |
| `tracks_per_10_min` | 3 | 2–5 | One per structural section. 2–4 is the tighter band for creator explainers; 5 only where the video genuinely has five tonal sections. Fewer reads flat; more reads restless. |
| `tone_check_points` | 3 | 2–5 | Sections whose bed tone you explicitly justify in the design doc. |
| `bpm_default` | 110 | 100–120 | The creator's own default band; match to speech rate ([[pace-speech-rate-to-bpm-map]]). |
| `vocals` | false under narration | — | Vocal beds only where your own voice is absent ([[sfx-vocal-vs-instrumental-bed]]). |
| `narration_bed_level` | −22 dB rel. voice (`0.079`) | −20 to −25 dB | The creator's own stated figure is **−24 dB (`0.063`)**, at the quiet end of the same band; either is defensible and the choice is the track's density, not a rule. Loud rock or heavy guitars go to −30 dB (`0.032`, [[sfx-loud-guitar-minus-30]]). |
| `foreground_bed_level` | −10 dB rel. voice | −8 to −12 dB | Narration-free / energetic sections. |
| `carve_strength` | 0.25 | 0.15–0.35 | Spectral room for the voice. At 0.5 the dip reaches 10 dB and is heard as an effect. |
| `music_only_section_len` | 20 s (600 f) | 12–90 s | A section handed entirely to music. |
| `track_edit_unit` | 8 bars | 4–32 bars | Whole phrases only when cutting a track to length; bar = 240 ÷ BPM seconds. |
| `loop_crossfade` | 0.35 s | 0.2–0.5 s | At a bar-line seam, on the downbeat. |
| `programme_loudness` | −14 LUFS | −16 to −14 LUFS | Socials −14, podcast −16; true peak ≤ −1.5 dBTP. |

## Reproduction prompt

```
Fund and choose the music for {{PROJECT}} before polishing any cuts (30fps).

STEP 0 - GATE. Listen to the dialogue alone. Audible hiss, room boom or
clipping under the words means STOP: no music decision improves it and this
stack has no noise removal. Report that the source needs re-recording.

STEP 1 - GATE THE CUT. The rough cut must be locked for structure (sections
and their order), with no motion polish, no SFX, no colour work done yet. If
polish has already started, stop it - the track will change what the polish
should be.

STEP 2 - TRIAGE. If the sound budget cannot cover all five layers, fund in
this order and say in the design document which layers were dropped:
  1. dialogue clean-up (voice-clean preset)   - always
  2. MUSIC                                    - always
  3. ambience (room tone in every gap)
  4. motion SFX on transitions and animations
  5. foley
  6. aesthetic hits/textures
Never fund 4-6 while 2 is unfunded: a video with whooshes and no bed sounds
cheaper than a video with a bed and no whooshes.

STEP 3 - WRITE THE TONE BRIEF, one line per section, in two axes only:
  emotion (serious / mysterious / hopeful / funky / fun / tense / calm)
  energy  (speech rate in words per minute -> target BPM band)
Sections that share both may share a track; sections that differ on either get
their own. Target coverage 0.75 of runtime under music, with 0.15 deliberately
silent - at the most serious line, immediately before the biggest reveal, and
at the hard stop before the CTA.

STEP 4 - FETCH 3 CANDIDATES PER SECTION with the real filter surface, not a
text search:
   SearchRecordings { filter:{ moodSlugs:{matchType:ANY,values:[<mood>]},
                               bpm:{min:<t-10>,max:<t+10>}, vocals:false },
                      sort:{by:POPULARITY,order:DESCENDING}, first:12 }
Record each candidate's id, title, bpm and mood tags.

STEP 5 - AUDITION AGAINST PICTURE. Lay each candidate under the same 45 s
window at -22 dB and watch the whole window without stopping. Judge only two
things: does the section feel like the tone brief, and does the cut rhythm now
feel right or wrong. Do not judge the track on its own merits.

STEP 6 - DECIDE, then write the choice and the REJECTED candidates into the
design doc with one line each on why. The rejections are what make the next
project fast.

STEP 7 - FIT EACH TRACK TO ITS SECTION. Prefer a library re-version
(EditRecording with targetDurationMs) to a hand edit. If cutting by hand, cut
on bar lines only (bar seconds = 240 / BPM; frames per bar at 30fps =
7200 / BPM), remove whole 8-bar phrases, and crossfade seams 0.2-0.5 s on the
downbeat. Rate-change by at most 5% as a last resort.

STEP 8 - LEVEL AND SPACE. Narrated sections: bed at -22 dB relative to voice,
carved against the voiceover GROUP at strength 0.25 - not ducked, so the bed
keeps its low end and its top. Narration-free sections: lift to -10 dB over 24
frames, landing on the section's first frame. Stop the bed at a peak in its own
waveform, not mid-phrase, so the stop reads as intentional. Then run carve.mjs.

STEP 9 - ONLY NOW polish cuts, motion and SFX - against the chosen bed,
playing.

STEP 10 - VERIFY BY SUBTRACTION. Mute the dialogue and play the whole video.
Each section's register must still be legible from music alone, and the section
boundaries must still be audible. Any section that fails is a section whose bed
was chosen by scrolling.

STEP 11 - RE-TEST THE DOCTRINE ONCE. Swap in the strongest rejected candidate
and watch the hook. If you cannot tell the difference, the tone brief was too
vague - rewrite it and repeat step 4.

ACCEPTANCE TEST: (a) music coverage 0.55-0.85, with at least one deliberate
rest; (b) 2-5 distinct tracks per 10 minutes, each changing at a section
boundary; (c) every track edit lands on a bar line; (d) carve applied to every
bed under narration and to none of the narration-free beds; (e) programme
loudness -14 LUFS +/-1 with true peak <= -1.5 dBTP; (f) the mute-the-voice pass
tells the arc; (g) play the hook to someone who has not seen it, with no
picture description, and ask what kind of video this is - their answer should
match the tone brief. If they say "corporate" and you wrote "mysterious", the
bed is wrong and no amount of cutting will fix it.
```

## Execution spec

**Epidemic Sound — the mood dial is a real filter, not a text search.** Probed live 2026-08-28: `SearchRecordings` accepts `filter.moodSlugs`, `filter.taxonomySlugs` (genres, decades, world-country), `filter.featuredInstrumentSlugs`, `filter.bpm {min,max}`, `filter.musicalKeys`, `filter.vocals`, `filter.duration`, and `filter.artistSlugs`, with `matchType` `ALL | ANY | NOT_ANY` on each slug list. Every result carries `bpm`, `credits`, `audioFile.durationInMilliseconds`, `stems` and tags labelled by taxonomy dimension (`mood`, `genre`, `production genre`, `vocal type`) — so mood is a first-class axis of the catalogue, exactly as the source says.

```
# funky / fun, instrumental, matched to a fast talker
SearchRecordings { filter:{ moodSlugs:{matchType:ANY,values:["happy","hopeful"]},
                            bpm:{min:110,max:130}, vocals:false },
                   sort:{by:POPULARITY,order:DESCENDING}, first:12 }

# serious / mysterious, slow, instrumental
SearchRecordings { filter:{ moodSlugs:{matchType:ANY,values:["dark","mysterious","epic"]},
                            bpm:{min:70,max:95}, vocals:false }, first:12 }

# vocal bed for a narration-free montage
SearchRecordings { filter:{ moodSlugs:{matchType:ANY,values:["hopeful"]},
                            bpm:{min:100,max:120}, vocals:true }, first:12 }

# keep the identity across a section change
SearchSimilarToRecording { id:<chosen uuid>, first:12 }
DownloadRecording { id:<uuid> }
```
Verified example results for `term:"uplifting corporate" + bpm 100-120 + vocals:false`: *Moving Up* (110 BPM, moods happy/hopeful), *Let's Go!* (118), *Brighter* (120, dreamy/hopeful), *Light Years* (113), *Fast One (Instrumental Version)* (110). Mood slug values are catalogue-controlled — read them off the `tags[].displayName` where `dimension.name == "mood"` of results you like, and reuse those exact strings. `vocals: false` is the filter that enforces the instrumental-under-narration rule, and it is known to leak, so gate on the `vocal type` tag as well.

**Fitting to length without a hand edit.** `EditRecording { id, input: { targetDurationMs, downloadAudioFormat: "WAV", loopable, forceDuration, preferenceRegions } }` → `PollEditRecordingJob` → `DownloadRecordingEdit`. `targetDurationMs` caps at **300000 ms**. `loopable: true` is the right choice for a bed that must underlie an unknown-length section; `preferenceRegions` biases which parts of the track survive the re-version.

**Stems are the fine mood control.** Every recording returns `stems[]` typed `DRUMS | BASS | MELODY | INSTRUMENTS | VOCALS | CLEAN_VOCALS`, each with its own audio file. Tone can therefore be adjusted without changing track: drop `MELODY` for a more serious, less "scored" feel under a heavy line; keep `DRUMS`+`BASS` only for a pulse under narration; bring the full mix back at the payoff ([[sfx-music-stem-layering]]). Stems are also the answer when a vocal track is otherwise right for a narrated section.

**HyperFrames — the bed, carved, at the source's level.** Music lives at the **host root** in a modular project so playback survives scene cuts. `data-volume` is linear gain: 0.063 ≈ −24 dB, 0.079 ≈ −22 dB, 0.032 ≈ −30 dB for loud guitars.
```html
<audio id="vo-1" src=".media/audio/voice/line-01.wav" data-audio-group="voiceover"
       data-start="0.5" data-track-index="10"></audio>
<audio id="vo-2" src=".media/audio/voice/line-02.wav" data-audio-group="voiceover"
       data-start="6.2" data-track-index="10"></audio>

<audio id="music-bed-a" src=".media/audio/bgm/moving_up.wav"
       data-audio-group="music" data-start="0" data-duration="96" data-media-start="2.4"
       data-track-index="11" data-volume="0.063"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.2,&quot;v&quot;:1},{&quot;t&quot;:95.0,&quot;v&quot;:1},{&quot;t&quot;:96.0,&quot;v&quot;:0}]}]}"></audio>
```
then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`, which prints the bed, voice, strength, bands and level envelope it chose and writes `fromCarve`-tagged `peaking` nodes plus a `gain` stage and lanes onto the bed. Contract invariants:
- **Carve settings live on the bed, never on a voice** — *"a voice carved against itself is a bug"* — and `sources` names a **group**, not clip ids (`audio_carve_ungrouped_sources`). Keep the `voiceover` group voices-only: a bed or an SFX clip inside it silently poisons the next re-analysis.
- *"Carve by default. A bed playing under narration wants a carve… Skip it only when there is no narration for the music to sit under."* At `strength` 0.25 that is about a 6 dB dip in three bands, *"audible without sounding like a hole"*; at 0.5 it is heard as an effect. If the bed sounds *notched* rather than quieter, the strength is too high.
- `data-fx-carve` is **clip-only** — never on an `<hf-audio-group>` (`audio_group_carve_attr`).
- Lane `t` is **clip-local**; a lane holds its first value backwards to the clip start, so a bed that begins before the voice *needs* an explicit `{t:0}` point or it starts already ducked.
- Never both a `volume` lane and a GSAP `volume` tween on one track (`audio_volume_double_automation` — the lane wins); and a `volume` tween **replaces** `data-volume` rather than scaling it.
- `carve.mjs` needs **`ffmpeg` on PATH** and `@hyperframes/core` installed, and *"refuses when it cannot tell which track is the bed"*.
- Also worth knowing: `data-volume` maxes at **3.98 (+12 dB)**; `data-media-start="2.4"` is the practical expression of the source's *"every track has a little warm-up at the start — ignore that"*; `data-playback-rate` is a pitch-preserved constant in `0.1..5` with no envelope; reverb/delay tails make a rendered track longer than its `data-duration`, which is expected.

**ffmpeg — measurement, delivery and any hand edit.**
```bash
# bar-line phrase removal + downbeat crossfade (120 BPM -> bar = 2.0s)
ffmpeg -i bed.wav -af "atrim=0:32,asetpts=PTS-STARTPTS" p1.wav
ffmpeg -i bed.wav -af "atrim=48:80,asetpts=PTS-STARTPTS" p2.wav
ffmpeg -i p1.wav -i p2.wav -filter_complex "[0][1]acrossfade=d=0.35:c1=tri:c2=tri" bed.cut.wav

# two-pass loudness for delivery
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=…:measured_TP=…:measured_LRA=…:\
measured_thresh=…:offset=…:linear=true mix.social.wav

# baked sidechain ONLY for assets leaving the pipeline
ffmpeg -i bgm.mp3 -i voice.wav -filter_complex \
 "[0][1]sidechaincompress=threshold=0.03:ratio=8:attack=200:release=400[d]" -map "[d]" bgm.ducked.wav
```
Do not bake the duck otherwise: *"Declare inside compositions. Bake only for assets leaving the hyperframes pipeline."*

**Remotion:** conceptually one `<Audio>` per section with an interpolated volume callback, plus a separate narration track. No Remotion runtime exists in this project.

## Pairs with
[[sfx-sound-pass-order]] · [[sfx-music-sets-the-mood]] · [[sfx-vibe-brief]] · [[sfx-bpm-filter-first]] · [[sfx-instrument-filter-search]] · [[sfx-emotion-music-lookup-table]] · [[sfx-mood-map-per-topic]] · [[sfx-music-audition-against-picture]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-vocal-track-for-narration-free-montage]] · [[sfx-music-stem-layering]] · [[sfx-music-rest-windows]] · [[sfx-music-hard-stop]] · [[sfx-music-drop-on-structure-turn]] · [[sfx-track-change-at-section-boundary]] · [[sfx-beat-aligned-handover]] · [[sfx-layer-volume-targets]] · [[sfx-dialogue-gate]] · [[sfx-loud-guitar-minus-30]] · [[pace-bpm-matched-music-selection]] · [[pace-speech-rate-to-bpm-map]] · [[struct-music-arc-to-narrative-arc]] · [[struct-stimulation-budget]]

## Failure modes
- **Choosing music last.** The most expensive ordering mistake available, because every cut-rhythm decision was made against a tone that changed. Fix: bed before polish, always.
- **Reading "music first" as "music early".** The mirror-image error. Executing the music pass before the dialogue pass means levelling everything against a moving target. Fix: fund music first, execute it in its proper place — after dialogue and ambience.
- **Funding the fun layers first.** Whooshes and hits on a video with no bed is the signature of a sound pass that started at the end of the list. Fix: the funding order in `layer_priority`.
- **Auditioning in the catalogue player.** A track that sounds great alone can be wrong under picture, and vice versa. Fix: audition under the actual 45 s window at the actual level.
- **A bed that never stops.** Coverage 1.0 removes the contrast that makes the bed mean anything, and removes the ability to make a line land by killing the music. Fix: `rest_share` 0.10–0.30, with rests placed on purpose.
- **One bed for the whole video.** Tonal flatline; no section boundary is audible and the viewer stops hearing it within a couple of minutes (habituation is faster the shorter the gap between repeats). Fix: 2–5 tracks per 10 minutes, changing at structural turns, ideally via a similar-track search so the identity holds.
- **Letting the doctrine mean "louder".** Music's power is not level. A bed at −12 dB does not double the effect; it costs intelligibility, which is the one thing that must not be spent. Fix: −20 to −25 dB and a carve.
- **Ducking where a carve belongs.** Ducking the whole bed under narration costs the bed all of its presence for no intelligibility gain the carve would not have given more cheaply. Fix: carve at 0.25 against the voice group.
- **Carving too hard.** At strength 0.5 the dip reaches 10 dB and the bed sounds notched — audible as an effect. Fix: back to 0.25 and re-listen.
- **A vocal track under your own narration.** Two voices competing; the words lose. Fix: `vocals: false` under narration, and check the vocal-type tag because the filter leaks.
- **Mood-matching the topic instead of the intent.** A video *about* something sad does not necessarily want a sad bed — the bed should carry what you want the viewer to feel next. Fix: write the tone brief in terms of the intended feeling, then filter.
- **Trying to fix a bad voice recording with music.** Louder music under a hissy voice makes both worse. Fix: the gate in step 0; re-record. *"There is no fallback for hiss beneath the words."*
- **Cutting the track mid-bar.** Audible to everyone, even people who cannot name why. Fix: whole phrases, downbeat crossfades, or a library re-version.
- **Known gap — the evidence.** The engagement claim is the creator's experience, and this note found **no publicly verifiable controlled study** tying music choice to average view duration on talking-head content; the film-music literature reachable here describes score as the affect channel but cites no such measurement. Treat the engagement claim as a strong working prior and, where a channel has the data, test it: two similar videos, deliberately different bed strategies, compare retention shapes. The mood claim is much safer — it is what film scoring is *for*, and the swap test demonstrates it on your own footage in two minutes.
- **Known gap — validation.** Nothing validates the mix. Lint reads `data-automation` for exactly two conflicts and the carve arrangement rules; *"nothing validates the chain or the effect lanes at all"*, and there is no beat/bar/section detector anywhere in the stack. Verification is listening to a render — which, on this ARM64 authoring VM, has to happen off-host.
