---
id: sfx-music-sets-the-mood
title: The bed decides the mood — choose it, don't discover it
skill: sound-design
type: music
family: mood-control
tags: [skill/sound-design, type/music, family/mood-control, engine/epidemic, engine/hyperframes, engine/ffmpeg, layer/music, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:03:14"
    quote: "Whether you want to give a serious, mysterious feel, or some funky, fun vibe, it's all controlled by the music."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:03:05"
    quote: "You don't figure out the vibe — you create the vibe. As an editor, you're the one with that power."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:03:24"
    quote: "If you're showing an epic montage or an inspiring journey, tracks with vocals will suit it much better and make a much bigger impact."
research_refs:
  - https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2020.02242/full
  - https://link.springer.com/article/10.3758/BF03196892
  - https://researchonline.ljmu.ac.uk/id/eprint/15429/9/The%20role%20of%20music-induced%20emotions%20on%20recognition%20memory%20of%20filmed%20events.pdf
  - https://help.epidemicsound.com/hc/en-us/articles/25436460909202-Find-the-right-music
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: audio
---

# The bed decides the mood — choose it, don't discover it

## What it is
The tonal register of a section — serious, mysterious, funky, triumphant, tense — is set almost entirely by the music under it, ahead of the grade and ahead of the cutting. The source states it as a decision rather than a discovery: *"you don't figure out the vibe — you create the vibe."* This is one of the few claims in the vault with direct experimental support. Presented with an **identical 1'55" scene**, viewers given a soft melancholic jazz bed described the character as agreeable and introverted and the space as "cozier"; viewers given an agitated orchestral bed described the same footage as someone planning to do harm in an unpleasant environment. Pupil dilation rose (0.25 vs 0.20) and gaze behaviour changed measurably — the agitated-music group spent **15% of the scene** fixated on a barely visible figure versus **11%**, revisiting it 11.07 vs 8.07 times. The bed does not colour the interpretation; it *is* the interpretation.

## When to use it
At the top of the sound pass, once per section, immediately after picture lock and before any SFX work — every other sound decision inherits from it. Use it deliberately whenever a section's intended reading is not self-evident from the picture: a neutral shot of a person at a desk can be "focused", "lonely" or "sinister" and only the bed decides. Use it as the *first* fix when a section "feels wrong" but the cut measures fine. And use the *absence* of music the same way: killing the bed under a serious line is a mood choice with the same force as changing the track. Skip a bed only where the format's register is silence — a demonstration window, or a deliberately dry companionship edit.

## How to recognise it in a reference video
The goal is to log, per section, the mood the bed asserts and the descriptors that produce it — so a new video can be given the same register with a different track.

- **Segment first.** Find the bed boundaries (entries, exits, track changes) and treat each as a section. A change of bed is a change of intended mood, by definition.
- **Measure four descriptors per bed**, which is what the research says actually drives the shift — arousal and valence, not genre labels:
  - **Tempo (BPM)** — estimate from the beat grid. Sub-80 reads reflective; 90–120 neutral-confident; 130+ energetic.
  - **Level variability** — the standard deviation of short-window RMS. Steady beds read calm and supportive; large, rapid level swings read agitated or dramatic. This was the descriptor separating the two conditions in the cited study.
  - **Timbre brightness** — spectral centroid. Under ~1200 Hz reads dark/warm/heavy; 1500–2800 Hz reads open and modern; above ~3500 Hz reads bright, thin, urgent.
  - **Mode/harmony** — minor or ambiguous harmony reads serious/mysterious; major reads confident/fun. Judge by ear; there is no reliable filter for it.
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=24000,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null   # 0.5s RMS trace
  ffmpeg -i ref.mp4 -af "aspectralstats=win_size=2048,\
  ametadata=print:key=lavfi.aspectralstats.1.centroid:file=-" -f null - 2>/dev/null  # brightness
  ```
- **Instrumentation census, by ear.** Log the two or three dominant instruments. This is the most portable field in the whole profile, because Epidemic's search is instrument-filterable.
- **Vocals or instrumental, and why.** Vocals appear where the host's voice does not — montage, journey, outro. Vocals *under* narration is a defect, not a style ([[pace-bpm-matched-music-selection]]).
- **Congruence check against the picture.** Read the section's visual content and the bed's mood independently, then compare. A congruent pair is the norm; a deliberate mismatch (cheerful music over grim footage) is a strong authorial device and must be logged as intentional, because the research shows incongruent pairs are encoded **separately** — the viewer remembers whichever channel they attended to and loses the other. An unintentional mismatch therefore costs comprehension, not just vibe.
- **Silence as a mood.** Log every bed *exit*. A drop to dry voice before a serious line is a mood move; treat it as an entry in the mood map, not a gap.
- **Mood arc across the video.** Plot the per-section moods in order. A working long-form video shows a shape — establish, build, release — not a random walk ([[struct-music-arc-to-narrative-arc]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `mood_target` | stated per section | serious · mysterious · tense · confident · funky/fun · triumphant · reflective · warm | The design document must name one per section. "Nice" is not a mood. |
| `bpm` | 100–120 | 60–150 | Match the delivery rate, not the mood label ([[pace-bpm-matched-music-selection]]). |
| `mode` | minor for serious/mysterious/tense · major for confident/funky/triumphant | — | The coarsest lever, and the one viewers read fastest. |
| `arousal` | medium | low · medium · high | Level variability + rate of change. The study's decisive descriptor: same valence, opposite arousal produced opposite readings. |
| `brightness_centroid` | 1500–2800 Hz | <1200 dark · 1500–2800 open · >3500 urgent | Measurable with `aspectralstats`; use it to match a reference bed you cannot license. |
| `instruments` | 2–3 named | — | e.g. "muted piano + low strings" (serious), "clean electric bass + rimshot kit" (funky). |
| `vocals` | instrumental | instrumental \| vocal | Vocal only where the host's voice is absent. |
| `bed_level` | −20 to −25 dB rel. dialogue | — | Dialogue 0 to −3 dB; SFX −12 to −15 dB. Loud rock/guitars go to −30 dB. |
| `carve_strength` | 0.25 | 0.15–0.40 | Voiceover carve on the bed rather than a blanket duck. 0.5 is audible as an effect. |
| `beds_per_video` | 3 | 2–6 | One per structural section. More than ~6 reads as restless. |
| `congruence` | congruent | congruent \| deliberate-mismatch | A mismatch must be written down as intentional or it is a bug. |
| `silence_sections` | 1 | 0–3 | At least one deliberate no-music passage in a long-form video. |
| `change_landing` | on a beat or a section boundary | ±4 f | A bed change mid-sentence is the signature of an unauditioned choice. |

## Reproduction prompt

```
Set the mood of every section by choosing its bed.

1. Write the mood map BEFORE searching for anything. One row per section:
   section name | in/out timecode | mood word | intended viewer reading in
   one clause. If two adjacent sections carry the same mood word, consider
   merging them into one bed.
2. For each row, derive the four descriptors: mode (major/minor), bpm band
   (from the section's speaking rate, not from the mood), arousal
   (low/medium/high = how much the level and texture move), and brightness
   (dark <1200Hz / open 1500-2800Hz / urgent >3500Hz spectral centroid).
   Name 2-3 instruments.
3. Search by those descriptors, not by adjectives. Fetch 3 candidates per
   section.
4. Audition each candidate UNDER THE LOCKED PICTURE at final level
   (bed -20 to -25 dB relative to dialogue at 0 to -3 dB), never in a
   library player at full volume.
5. Judge one question only: does this bed produce the intended reading in
   the "viewer reading" column? Not "is this a good track".
6. Check congruence. If the bed's mood and the picture's content disagree,
   either fix it or write "deliberate mismatch" plus the reason in the design
   document - an unintentional mismatch splits the viewer's encoding and
   costs recall of the content, not just feel.
7. Place bed changes on a beat or a section boundary, within 4 frames. Do
   not change a bed mid-sentence.
8. Plan at least one no-music passage, placed under the video's most serious
   or highest-stakes line, and stop the bed at a waveform peak so the stop
   reads as intentional.
9. Carve the bed against the voice group at strength 0.25 rather than
   ducking it whole.
10. ACCEPTANCE TEST: (a) hand someone the muted picture and the mood map -
    they should be able to guess the mood words from the visuals, and where
    they cannot, the bed is doing necessary work rather than decorative work;
    (b) play each section and name the mood in one word without looking at
    the map - it must match; (c) verify no vocal bed sits under narration;
    (d) verify every bed change lands within 4 frames of a beat or boundary.
```

## Execution spec

**Epidemic Sound (the whole selection step).** Search by descriptor, not by adjective. The library exposes mood/vibe, instrument and BPM filters, and a similarity search that is the right tool for the *next* section:

```
SearchRecordings { query.term: "sparse minor piano low strings tension",
                   filter: { bpm: 70-90, vocals: false } }              # serious / mysterious
SearchRecordings { query.term: "funky clean bass rimshot groove",
                   filter: { bpm: 105-120, vocals: false } }            # funky / fun
SearchRecordings { query.term: "rising cinematic strings triumphant",
                   filter: { bpm: 120-135 } }                           # vocal allowed if no narration
SearchSimilarToRecording { id: "<the bed you kept>" }                    # neighbouring section
DownloadRecording → .media/audio/bgm/<section>.mp3
```
Epidemic produces a **file and stops**; everything after is HyperFrames.

**HyperFrames (placement, level, mood-driven exits).** One bed per section, on its own track index, in a `music` group, carved against the voice group:

```html
<audio id="vo-01" src=".media/audio/voice/l01.wav" data-audio-group="voiceover"
       data-start="12.4" data-track-index="10"></audio>

<audio id="bed-serious" src=".media/audio/bgm/serious.mp3" data-audio-group="music"
       data-start="8" data-duration="96" data-track-index="11" data-volume="0.55"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.2,&quot;v&quot;:1},{&quot;t&quot;:94.4,&quot;v&quot;:1},{&quot;t&quot;:96,&quot;v&quot;:0}]}]}"></audio>
<audio id="bed-funky" src=".media/audio/bgm/funky.mp3" data-audio-group="music"
       data-start="104" data-duration="120" data-track-index="12" data-volume="0.55"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```
Then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`.

Contract rules that decide whether this works:
- **Carve settings live on the bed, never on a voice** — "a voice carved against itself is a bug" — and `sources` must name a **group**, not a list of clip ids (`audio_carve_ungrouped_sources`). Keep the voice group voices only; a bed or SFX clip inside it silently poisons the next re-analysis.
- Two beds must not share a `data-track-index` if they overlap at all (`duplicate_audio_track`); with a crossfade they do overlap, so use distinct indices.
- Automation `t` is **clip-local seconds**, and a lane **holds its first value backwards** to the clip start — so a bed that begins before the voice needs an explicit `{t:0}` point or it starts already ducked.
- Never GSAP-tween `volume` on a track that has a `volume` lane: the lane wins and the tween is silently ignored (`audio_volume_double_automation`); and an authored `data-volume` on a tweened track is *replaced*, not scaled (`audio_volume_tween_overrides_gain`).
- `data-volume` max is `3.98` (+12 dB); `0.55` ≈ −5 dB against the file's own level, which is why the mix numbers must be checked by ear or by `ebur128`, not assumed from the attribute.
- **Nothing validates the FX chain or the lanes.** Render refuses an unparseable chain outright; preview plays it dry. Verify by rendering and listening — see the mix targets below.

**ffmpeg (measurement and delivery loudness).** Two-pass `loudnorm` at the end, on the mixed deliverable:
```bash
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
# then apply with the measured values, linear=true
```
`-14 LUFS` for socials, `-16` for podcast.

**Remotion:** an `<Audio>` per section with a volume function; concept only, no Remotion runtime here.

## Pairs with
[[sfx-music-audition-against-picture]] · [[pace-bpm-matched-music-selection]] · [[struct-music-arc-to-narrative-arc]] · [[sfx-riser-anticipation-build]] · [[cut-dissolve-time-passage]] · [[pace-silent-demonstration-window]] · [[sfx-sound-pass-order]] · [[motion-look-finishing-pass]]

## Failure modes
- **Choosing a track you like.** The question is what reading the bed produces, not whether the track is good. Fix: write the intended viewer reading first, then judge candidates against that sentence only.
- **Accidental incongruence.** A bright, bouncy bed under a cautionary point does not merely feel odd — mismatched pairs are encoded as two separate streams and the viewer loses whichever they did not attend to. Fix: audition against the picture, and mark any surviving mismatch as deliberate with a reason.
- **Vocals under narration.** Two voices competing for the same band; intelligibility drops and the viewer cannot say why. Fix: instrumental wherever the host speaks; save vocal beds for voice-free montage.
- **One bed for the whole video.** The mood then cannot move with the argument, and the bed becomes wallpaper the ear stops hearing. Fix: one bed per structural section, 3 as a default.
- **Never stopping.** Music running unbroken removes the strongest emphasis tool available. Fix: at least one silence passage, stopped on a waveform peak.
- **Ducking instead of carving.** A blanket duck costs the bed all its presence; the carve takes only the bands the voice occupies. Fix: `data-fx-carve` at 0.25 on the bed. If it sounds *notched* rather than quieter, the strength is too high.
- **Changing the bed mid-sentence.** Reads as an editing error even when the two tracks are both right. Fix: land changes on a beat or a section boundary within 4 frames.
- **Fixing mood with the grade.** Colour is a much weaker lever than the bed and takes ten times as long. Fix: try three beds before touching the grade ([[motion-look-finishing-pass]]).
- **Known gap:** the cited experiments establish that the same footage is read differently under different beds, and identify arousal/valence as the drivers — they do not give a mapping from a mood word to a BPM, a centroid or an instrument list. The descriptor bands in the parameter table are craft calibrations, and the spectral-centroid ranges in particular are a convenience for *matching a reference bed*, not a psychoacoustic standard.
