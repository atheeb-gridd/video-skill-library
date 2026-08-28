---
id: sfx-vocal-track-for-narration-free-montage
aliases: [sfx-vocal-track-for-montage]
title: Vocal music belongs where your voice is not — montages, journeys, transformations
skill: sound-design
type: music
family: music-selection
tags: [skill/sound-design, type/music, family/music-selection, layer/music, layer/dialogue, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:03:22
    quote: "vocals versus instrumental."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:03:24"
    quote: "If you're showing an epic montage or an inspiring journey, tracks with vocals will suit it much better and make a much bigger impact."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:03:36"
    quote: "So the rule for this is really simple: wherever your own voice isn't there, using music with vocals works better. But where your own voice is there, putting a vocal track behind it can create a bit of a conflict."
research_refs:
  - https://en.wikipedia.org/wiki/Montage_(filmmaking)
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://blog.audionetwork.com/the-edit/music/how-to-choose-music-for-a-voiceover-heavy-video
  - https://www.musicbed.com/articles/resources/instrumental-vs-vocal-music/
  - https://mubert.com/blog/how-to-make-music-fit-your-video-length-exactly
  - https://adobevideoworld.com/montage-editing-guide/
  - https://air.io/en/youtube-hacks/advanced-retention-editing-cutting-patterns-that-keep-viewers-past-minute-8
  - https://www.retentionrabbit.com/blog/2025-youtube-audience-retention-benchmark-report
  - mcp://Epidemic_sounds/SearchRecordings (vocals + mood + bpm funnel and stem inventory probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Vocal music belongs where your voice is not — montages, journeys, transformations

## What it is
A binary selection rule with a physical reason behind it. **Where your own voice is present, use instrumental music; where it is absent, a vocal track is not merely allowed — it is the stronger choice.** The source states both halves: a lyric under narration *"can create a bit of a conflict"*, while over a montage *"tracks with vocals will suit it much better and make a much bigger impact."*

**The conflict is masking, and it is not a matter of level.** A sung lyric and a spoken narration occupy the same critical bands — the **300 Hz – 3.4 kHz** speech range, "where many lead instruments, guitars, pianos and synth melodies also live" — and *"the listener cannot distinguish between them and they are perceived as one sound with the quieter sound masked by the louder one."* Turning the music down does not separate them; it just makes the lyric a quieter competing sentence. The listener's language processing tries to parse both, and the cost lands on comprehension of *your* words, not on enjoyment of the song.

**The positive half is the interesting one.** A narration-free sequence — montage, transformation, journey, results reel — has a **hole where the emotional statement should be**. The lyric fills it: it becomes the narrator, saying the thing the absent voiceover would have said, and saying it in the first person, which narration usually cannot. That is why the training-montage convention exists at all, where *"an inspirational song (often fast-paced rock music) typically provides the only sound"* — and why a montage cut to an instrumental bed so often feels like it is missing something.

The craft, as opposed to the rule, is **structural alignment** — the montage's turning point lands on the vocal hook, and the montage's length is cut to the song's section boundaries rather than to the footage's — plus the **stem handover** that makes the transition into and out of the montage inaudible. The best version of this rule uses **one track in two states**: full vocal mix in the montage, `INSTRUMENTS` stem under the narration either side, so the score has a single identity and the montage reads as the song *arriving* rather than as a new track starting.

## When to use it
The decision is per **section**, not per video.

- **A montage with no narration over it.** The defining case: transformation, before/after, a build sequence, a highlight reel, a travel or process montage.
- **A cold open before the first line of voiceover.** 8–20 seconds of vocal track sets the register before you speak, and dropping to instrumental at the first word is a clean handover.
- **An outro, credits or CTA tail after the last line.** The lyric carries the ending the narration deliberately stopped short of.
- **A results or testimonial sequence** carried by on-screen text rather than speech.

**Two different length floors apply, and they are for different jobs** — see `min_window` in Parameters. A vocal stretch that is only *setting a register* (cold open, outro tail) works from about **8 seconds**. A **fully scored montage** with a hook aligned to a turning point needs **15–20 seconds** minimum, because a vocal track cannot establish a verse-into-chorus arc in less.

Do not use a vocal track:
- **Under narration, at any level.** This is the hard half of the rule and it has no exceptions worth the risk. Do not reach for ducking on the theory that it will fix it — see Failure modes.
- **Under on-screen interview audio** either. The rule is about *any* speech, not about your speech specifically. One returning line is enough to break it.
- **When captions are doing heavy work.** A lyric and a caption compete for the same language channel even though one is heard and one is read.
- **For a sequence under about 6 seconds.** There is no room for a vocal phrase to complete, so it reads as a fragment of a song rather than as scoring.
- **When the lyric's content contradicts the picture.** A library vocal is a *statement*; check that it is one you want to make.

## How to recognise it in a reference video
- **First, is there narration under the music?** Isolate a 10-second window and listen; then confirm with the transcript — a stretch with no words is the candidate. This is the whole decision, so establish it before anything else.
- **Find every narration-free stretch and check what the music does there.** The signature of this technique is a **track change or a stem change at the narration boundary**, not a level change alone. If the same instrumental bed simply gets louder over the montage, the technique is absent.
- **Detect the vocal objectively.** Band-limit the mix to 300–3400 Hz and compare the music-only stretches with the narration stretches:
  ```bash
  ffmpeg -i ref.mp4 -af "highpass=f=300,lowpass=f=3400,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  A bed whose mid-band energy is close to the narration's own is a vocal bed and will be fighting the voice. On a spectrogram, sung vowels are unmistakable — broad horizontal formant bands that shift together; an instrumental lead shows harmonic stacks that do **not** carry formants.
- **Measure the boundary.** Log `vocal_in − last_word_end` and `first_word_start − vocal_out`. A deliberate handover shows the vocal arriving **0–1.5 s after** the last narrated word and leaving **0.5–2 s before** the next one. Overlap of more than about 0.5 s in either direction means the editor did not do this on purpose.
- **Where the lyric enters relative to picture.** Competent montage scoring starts the section on an instrumental intro and lets the vocal arrive **on a picture beat**, not mid-shot.
- **Where the chorus lands — the strongest single signal.** Mark the montage's turning point (the before→after flip, the result reveal, the summit shot) and the track's chorus entry (the loudest sustained vocal onset after a build). In a scored montage these fall within **±12 frames**, and certainly within half a bar. Farther apart and the music is running *under* the montage rather than *with* it.
- **Bar alignment of cuts.** Compute bar length from BPM: **seconds per bar = 240 ÷ BPM** in 4/4; at 30 fps, **frames per bar = 7200 ÷ BPM** and **frames per beat = 1800 ÷ BPM**. Cut positions clustering on multiples of a bar (or half-bar) mean the montage was cut to the music ([[pace-cut-on-the-beat]]).
- **Section length in bars.** Montages built on music tend to run **8, 16 or 32 bars** rather than an arbitrary number of seconds — at 120 BPM that is 16 s, 32 s, 64 s.
- **Check the montage's out-point against the song's structure.** A montage that ends mid-phrase was cut to footage; one that ends on a downbeat or a chorus resolution was cut to music ([[sfx-music-fade-out-section-signal]]).
- **Measure the level jump.** Music with no voice under it typically sits **6–10 dB louder** than the same music under narration. A montage where the level does *not* rise is under-committed.
- **Track identity across the video.** Check whether the instrumental under the narration and the vocal in the montage are the *same* composition. Shared instrumentation and key across both is a deliberate stem-based build and worth logging as a signature.
- **Lyric relevance.** Read the words. Scored montages use tracks whose lyric is generic-affirmative ("we made it", "keep going") or thematically aligned; a lyric telling an unrelated specific story competes with the picture even without narration.
- **Log for the design document:** montage in/out, whether vocals are present, hook time relative to montage in, and the bed level relative to dialogue in both regimes.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `vocals_allowed` | only where no speech | — | Hard rule. Applies to a section, not a video. Not a taste dial. |
| `min_window` — register-setting (cold open, outro tail) | 12 s | 8–20 s | Hard floor 6 s. The vocal is setting a register, not carrying an arc. |
| `min_window` — fully scored montage | 18 s (540 f) | 15–90 s | A vocal track cannot establish a verse-into-chorus arc in less, and there is nothing to align a hook to. |
| `montage_len` | 16 bars | 8–32 bars | 32 s at 120 BPM. Prefer bar counts to second counts; past ~45 s a montage without narration loses the thread. |
| `bar_seconds` | 240 ÷ BPM | — | 2.0 s at 120 BPM. Frames per bar at 30 fps = 7200 ÷ BPM; frames per beat = 1800 ÷ BPM. |
| `hook_alignment` | 0 f — chorus onset on the montage's turning point | ±12 f (outer ±½ bar) | The one number that separates *scored* from *soundtracked*. |
| `vocal_entry_offset` | 0 f from a picture beat | 0–8 f | The first lyric lands on a cut or a visual beat, not mid-shot. |
| `vocal_in_offset` | +0.6 s after the last narrated word | 0 to +1.5 s | A beat of instrumental before the lyric enters reads as a handover rather than a jump-cut in the music. |
| `vocal_out_offset` | −1.2 s before the next word | −0.5 to −2.5 s | The lyric must be **gone** before you speak, not fading while you speak. |
| `level_montage` — energetic/epic, music in the foreground | −10 dB rel. dialogue | −8 to −12 dB | The lyric *is* the narrator here; commit to it. |
| `level_montage` — montage still sharing attention (on-screen text, captions, interview audio, a quieter transitional montage) | −14 dB rel. dialogue | −12 to −18 dB | The bed is scoring something the viewer is also reading. |
| `level_under_voice` | −22 dB rel. dialogue | −20 to −25 dB | The source's own window; −30 dB for loud guitar-led beds ([[sfx-loud-guitar-minus-30]]). |
| `bed_lift_ramp` | 24 f (0.8 s) | 12–45 f | Level ramp from narration level to montage level, landing on the montage's first frame. |
| `handover_crossfade` | 0.4 s | 0.2–1.0 s | Between the FULL mix and the INSTRUMENTS stem at each boundary. Equal-power. |
| `loop_crossfade` | 0.35 s | 0.2–0.5 s | At a bar-line loop point when extending a track. |
| `tail_fade` | 0.75 s | 0.5–1.0 s | When the montage ends off a musical boundary. |
| `time_stretch_max` | ±5 % | ±0–10 % | Rate change allowed to make a track land; beyond ~10 % quality degrades audibly. Last resort. |
| `lyric_type` | `clean` | `clean` \| `explicit` | A catalogue tag, and the `vocals` filter does **not** screen it. Check before download. |
| `duration_min` | montage × 1.4 | — | You need the run-up to the chorus, which is usually 20–45 s of song you will not use. |

## Reproduction prompt

```
Score the narration-free montage running {{IN}} to {{OUT}} (seconds, 30fps)
with a vocal track, and hand back to instrumental at the narration boundaries.

1. CONFIRM THE HOLE IS REAL. Read the transcript. There must be NO spoken word
   between {{IN}} and {{OUT}}. If there is even one, STOP: this section takes an
   instrumental bed, and the rule has no exceptions. Then check the length
   against the right floor: >= 8 s if the vocal is only setting a register,
   >= 18 s if you intend a scored montage with hook alignment.

2. MARK THE TURNING POINT. Watch the montage and note the single frame with the
   strongest image or the clearest change of state. Call it {{HOOK}}. This is
   what the chorus will land on.

3. FETCH with the three-parameter funnel, vocals ON:
     SearchRecordings with filter.vocals = true,
     filter.bpm { min, max } from the montage's CUT rhythm (there is no speech
       to match - frames per beat = 1800 / BPM at 30fps; pick a BPM whose beat
       is close to your intended average shot length),
     moodSlugs = the emotional statement the montage is making
       ("epic", "hopeful", "euphoric"),
     duration >= ({{OUT}} - {{IN}}) * 1.4.
   Prefer a result whose tags include a "lead vocals" vocal type and a "clean"
   lyric type. Read the returned bpm field; do not guess it. READ THE LYRIC.

4. FIT THE TRACK TO THE WINDOW, in this order:
   a. EditRecording with targetDurationMs = ({{OUT}} - {{IN}}) * 1000 (max
      300000). Use requiredRegionsAtOffsets to FORCE the chorus region to sit at
      the offset of {{HOOK}}, and preferenceRegions AVOID for any section you do
      not want. Then PollEditRecordingJob, DownloadRecordingEdit.
   b. If EditRecording is unavailable, find the chorus onset by measurement -
      run a 1 s RMS trace and take the first sustained jump of >= 3 dB followed
      by continuous vocal energy; call it CHORUS_T. Then align WITHOUT cutting,
      by setting data-media-start = CHORUS_T - ({{HOOK}} - {{IN}}). If that goes
      negative, the chorus arrives too early in the song for this montage -
      lengthen the montage's head or pick another track.
   c. If the track must be shortened by hand, cut on BAR LINES: seconds per bar
      = 240 / BPM. Remove whole 8-bar phrases, never partial bars, and crossfade
      the seam by 0.2-0.5 s on the downbeat.
   d. Only as a last resort, rate-change by up to 5%.

5. ALIGN THREE THINGS TO PICTURE:
     first frame of the montage -> the start of a musical phrase
     first lyric onset          -> a cut or a visual beat (within 8 frames)
     chorus / hook arrival      -> {{HOOK}} (within 12 frames, half a bar outer)
   Move the PICTURE to the music where the music cannot move; a montage is the
   one place picture yields.

6. HANDOVER AT BOTH ENDS WITH STEMS, NOT WITH A DIFFERENT TRACK. From {{IN}} -
   0.6 back to the previous narration, and from {{OUT}} + 1.2 forward, play the
   INSTRUMENTS stem of the SAME track instead of the full mix, crossfaded 0.4 s
   equal-power at each boundary. Same track, same tempo, same key, no lyric
   under speech - nothing about the score appears to change except the arrival
   of a voice.

7. SET LEVELS. Inside the montage: -10 dB if the music is the foreground,
   -14 dB if the montage still carries captions or on-screen text. Outside:
   -22 dB. Ramp between them over the 0.4 s crossfade / 24 frames, not
   instantly. Do NOT carve the montage bed - there is no voice there for a
   carve to follow.

8. CUT THE PICTURE TO THE MUSIC. Place montage cuts on beats or bars, and let
   shot length shorten into the chorus rather than staying uniform. Move {{OUT}}
   to the next downbeat or phrase end after the last needed image, up to 1 bar
   later; a montage that ends mid-phrase reads as running out of footage.

ACCEPTANCE TEST: (a) no spoken word overlaps any lyric anywhere in the video;
(b) the chorus's first sung syllable and the montage's strongest image are
within 12 frames; (c) every montage cut sits within 2 frames of a beat; (d) the
bed is at least 8-10 dB louder relative to the programme inside the montage than
outside it; (e) the montage begins and ends on musical boundaries, or ends with
a 0.75 s fade; (f) played from 5 s before {{IN}} to 5 s after {{OUT}}, the
arrival of the lyric feels like the montage started, not like the music changed
- and with your eyes closed at the handover back to narration, you should hear a
voice leaving, not a track changing; (g) played with the picture hidden, the
music alone still tells the arc.
```

## Execution spec

**Epidemic Sound — the primary tool, and the stem trick that makes the handover invisible.** The catalogue exposes `vocals` as a plain boolean filter, and every `Recording` carries a `stems` list. Probed live 2026-08-28, the stem types are `DRUMS`, `BASS`, `MELODY`, `INSTRUMENTS`, `CLEAN_VOCALS`, `VOCALS`, and `DownloadRecording` accepts `stemType: FULL | BASS | DRUMS | INSTRUMENTS`. That means **one track can serve both regimes**: `FULL` inside the montage, `INSTRUMENTS` under the narration on either side. Same tempo, same key, same production — the only thing that changes is that a voice arrives.

```
# the montage track: vocals ON, epic, in the montage's own tempo band
SearchRecordings {
  query:  { term: "epic inspiring cinematic journey" },
  filter: { vocals: true,
            moodSlugs: { matchType: ANY, values: ["epic"] },
            bpm: { min: 100, max: 130 },
            duration: { min: 150000 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }
# live 2026-08-28 -> meta.total 81. A workable landing zone from one query.

DownloadRecording { id:<uuid>, options:{ fileType: WAV, stemType: FULL } }
DownloadRecording { id:<uuid>, options:{ fileType: WAV, stemType: INSTRUMENTS } }
SearchSimilarToRecording { id:<uuid>, first:12 }
```

Results carry `bpm` (an integer — use it rather than estimating), `audioFile.durationInMilliseconds`, and a `tags` list with dimensions including **mood**, **genre**, **vocal type** and **lyric type**. Two catalogue facts to design around. **`vocal type`** has values `lead vocals` / `no vocals`, so a track's tags confirm what the boolean filter did. **`lyric type` is a separate dimension** with values `clean` and `explicit`, and **the `vocals` filter does not screen it** — the live probe returned `PRESSURE!` tagged `explicit` alongside `PRESSURE! (Clean Version)` tagged `clean`, as two distinct recordings with different ids. Read the tag before you download. Where both exist, the clean version also ships a `CLEAN_VOCALS` stem rather than `VOCALS`.

**Fitting to length** — the mechanism for "the chorus must land on the turning point":
```
EditRecording { id, input: { targetDurationMs, downloadAudioFormat: "WAV",
                             loopable, forceDuration,
                             requiredRegionsAtOffsets: [{ startMs, endMs, offsetMsInEdit }],
                             preferenceRegions: [{ startMs, endMs, preferenceType: "PREFER" | "AVOID" }] } }
PollEditRecordingJob { ... }
DownloadRecordingEdit { ... }
```
`targetDurationMs` is capped at **300000 ms (5 minutes)**. `requiredRegionsAtOffsets` takes the chorus's source range plus the offset inside the edit where the turning point sits. `SearchSimilarToRecording` expands a shortlist from the one track that nearly works. Downloads land under the project (`.media/audio/bgm/…`); everything after that is HyperFrames.

**HyperFrames.** Three clips of the same track, two stems, crossfaded at the boundaries. Montage 62.0 → 84.0 s, hook at 71.0 s, chorus 38.4 s into the file:

```html
<!-- before: instrumental stem under narration, carved -->
<audio id="bed-pre" src=".media/audio/bgm/journey_INSTRUMENTS.wav"
       data-audio-group="music"
       data-start="40" data-duration="22.4" data-media-start="16.0"
       data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:22.0,&quot;v&quot;:1},{&quot;t&quot;:22.4,&quot;v&quot;:0}]}]}"></audio>

<!-- the montage: full mix, lyric present, media-start aligns chorus to the hook -->
<!-- media_start = 38.4 - (71.0 - 62.0) = 29.4 -->
<audio id="bed-montage" src=".media/audio/bgm/journey_FULL.wav"
       data-audio-group="music"
       data-start="62.0" data-duration="22.8" data-media-start="29.4"
       data-track-index="12" data-volume="0.316"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.4,&quot;v&quot;:1},
         {&quot;t&quot;:22.4,&quot;v&quot;:1},{&quot;t&quot;:22.8,&quot;v&quot;:0}]}]}"></audio>

<!-- after: back to the instrumental stem, carved again -->
<audio id="bed-post" src=".media/audio/bgm/journey_INSTRUMENTS.wav"
       data-audio-group="music"
       data-start="84.4" data-duration="30" data-media-start="51.8"
       data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```

Contract points:
- **`data-volume` 0.316 ≈ −10 dB, 0.200 ≈ −14 dB, 0.079 ≈ −22 dB.** The level change between regimes is authored as two clips, not as one long automation, because the two clips are different files.
- **No carve on the montage bed.** `data-fx-carve` exists to make room for a voice; there is no voice here, and *"skip it only when there is no narration for the music to sit under"* is exactly this case. Carve the instrumental beds either side.
- **Every lane needs its explicit `t:0` point**, because *"a lane holds its first value backwards to the start of its clip"* — without it the montage clip starts already at full level and the crossfade does nothing.
- **Overlapping clips need different `data-track-index` values** or lint raises `duplicate_audio_track`. The two instrumental clips can share index 11 since they do not overlap; the montage sits on 12.
- **Every `<audio>` needs an `id`** or it is silently unmixed.
- **`data-media-start` is doing the real work.** It *"offset[s] into the media source, in seconds"* without touching the file, so aligning a chorus to a picture event is a single arithmetic line rather than a render.
- **A ±5 % rate fit is available in-composition** without touching the file: `data-playback-rate="0.97"`, normalised to `0.1..5` and **pitch-preserved**. There is **no rate envelope**, so it is a constant for the whole clip.
- Effects with a tail (reverb, delay) make the rendered track **longer** than its `data-duration` — expected, not a bug.

**ffmpeg — measurement, hand edits, and delivery.**
```bash
# 1 s RMS trace: find the first sustained >=3 dB jump - that is the chorus entry
ffmpeg -i journey_FULL.wav -af "asetnsamples=n=48000,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null

# confirm the difference between the two stems is a voice, not a level
ffmpeg -i journey_FULL.wav -i journey_INSTRUMENTS.wav \
  -filter_complex "[1:a]volume=-1.0,aeval=-val(0)|-val(1)[inv];[0:a][inv]amix=inputs=2" \
  -af "bandpass=f=1500:width_type=o:w=2" -f null -

# bar-line edit: remove bars 17-24 of a 120 BPM track (bar = 2.0s), crossfade 0.35s
ffmpeg -i track.wav -af "atrim=0:32,asetpts=PTS-STARTPTS" a.wav
ffmpeg -i track.wav -af "atrim=48:96,asetpts=PTS-STARTPTS" b.wav
ffmpeg -i a.wav -i b.wav -filter_complex "[0][1]acrossfade=d=0.35:c1=tri:c2=tri" track.cut.wav

# equal-power stem handover, if you would rather bounce it than author it
ffmpeg -i journey_INSTRUMENTS.wav -i journey_FULL.wav \
  -filter_complex "acrossfade=d=0.4:c1=qsin:c2=qsin" handover.wav

# delivery loudness, two-pass
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
```

**Remotion:** two `<Audio>` components in adjacent `<Sequence>`s with `startFrom` set to the aligned offsets and `interpolate`d volume across the boundary. Concept only; no Remotion runtime exists in this project.

## Pairs with
[[sfx-vocal-vs-instrumental-bed]] · [[sfx-three-parameter-music-search]] · [[sfx-mood-vibe-filter]] · [[sfx-bpm-filter-first]] · [[sfx-music-stem-layering]] · [[sfx-layer-volume-targets]] · [[sfx-loud-guitar-minus-30]] · [[sfx-cut-on-the-beat]] · [[sfx-music-drop-on-structure-turn]] · [[sfx-music-fade-out-section-signal]] · [[sfx-track-change-at-section-boundary]] · [[sfx-find-similar-track-handover]] · [[sfx-beat-forward-bed-under-voice]] · [[pace-cut-on-the-beat]] · [[pace-beat-grid-extraction]] · [[struct-music-arc-to-narrative-arc]] · [[pace-bpm-matched-music-selection]] · [[sfx-vibe-brief]] · [[sfx-music-sets-the-mood]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-music-primacy-doctrine]] · [[sfx-music-audition-against-picture]] · [[sfx-track-reversion-to-edit-length]]

## Failure modes
- **A lyric under narration — and "I'll just duck it."** The named conflict. Ducking lowers both voices and fixes nothing; the lyric is still competing for the same critical bands. The stack's carve is *worse* here, not better: it dips the bands the **speech** occupies — at the default strength 0.25, about **6 dB across three bands** — which is precisely where the lyric lives, so you get a gutted song and a still-crowded mid-range. Fix: instrumental, or the `INSTRUMENTS` stem of the same track.
- **Vocal bed under a section that "only has a little" narration.** One returning line is enough to break it. Fix: sections are the unit; if the voice appears at all, the section is instrumental.
- **Changing tracks at the montage boundary instead of changing stems.** The viewer hears the *edit* rather than the montage. Fix: one track, `FULL` inside, `INSTRUMENTS` outside, 0.4 s crossfade.
- **The chorus landing anywhere.** The single largest wasted opportunity in montage scoring: a vocal track dropped in at `data-media-start="0"` puts 30 seconds of intro over your best images, and the song's biggest moment lands three shots after the reveal. Fix: measure `CHORUS_T` and solve for `media_start`, or use `requiredRegionsAtOffsets`, or move the picture.
- **Cutting the track anywhere but a bar line.** Mid-bar edits are audible even to non-musicians. Fix: `240 ÷ BPM` seconds per bar, whole phrases only, 0.2–0.5 s crossfade on the downbeat.
- **Time-stretching to fit.** Beyond about 5–10 % the track degrades and the BPM no longer matches the cut rhythm you chose it for. Fix: re-edit the length instead; stretch is the last resort.
- **Not raising the level in the montage.** Without a voice to protect, −22 dB reads as timid and the montage feels like the same scene with no talking. Technically clean, emotionally inert. Fix: lift to −10 dB (−14 dB if captions are working).
- **Ending the montage mid-phrase.** Reads as running out of footage. Fix: extend to the next downbeat, up to a bar.
- **Shipping an explicit lyric.** The `vocals` boolean does not filter `lyric type`. Fix: read the tag; prefer the `(Clean Version)` recording, which is a separate id.
- **A lyric that argues with the picture, or tells its own story.** A library vocal makes a first-person statement; over the wrong images it is actively confusing, and a specific narrative lyric competes with the picture even with no narration present. Fix: prefer generic-affirmative or thematically aligned words, and read them before you commit.
- **Carving the montage clip.** A carve with no voice under it does nothing useful and, if a stray non-voice clip is in the carve group, *"poisons the next re-analysis silently."* Fix: carve the instrumental beds only.
- **Known gap:** nothing in the stack detects beats, bars, chorus positions or vocal onsets, and nothing detects a sung vocal automatically. BPM comes from Epidemic's metadata; bar positions are arithmetic; the chorus position must be found by listening and read off the waveform; "is there a lyric under this narration?" is a listening check or a hand-run band-limited RMS comparison, with no lint rule behind it. Put the check in the design document as an explicit gate rather than assuming a tool will catch it.
