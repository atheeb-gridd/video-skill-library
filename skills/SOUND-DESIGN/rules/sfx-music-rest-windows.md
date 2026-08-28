---
id: sfx-music-rest-windows
aliases: [sfx-music-rest-and-stop-points]
title: Give the music rest — plan the windows where there is no bed
skill: sound-design
type: music
family: music-arc
tags: [skill/sound-design, type/music, family/music-arc, engine/hyperframes, engine/epidemic, engine/ffmpeg, layer/music, layer/dialogue, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:05:41
    quote: "The next mistake people make is that their music just keeps running through the entire video."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:05:49
    quote: "But it's important to give the music some rest, meaning: you should know when to stop the music."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:05:54
    quote: "If you want to put emphasis on something, or you're saying something serious, cutting the music there sends all the focus onto your voice."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:00
    quote: "And whenever you do stop the music, stop it on a peak point in the audio. You can see this in the waveform: wherever you see a peak, cut the music there. It feels really smooth, it doesn't feel sudden."
research_refs:
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
  - https://en.wikipedia.org/wiki/Stem_(audio)
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://www.premiumbeat.com/blog/top-5-ways-music-misused-films/
  - https://www.michaelmusco.com/2026/02/structural-language-music-supervisors-expect.html
  - https://www.storyblocks.com/resources/tutorials/3-techniques-cutting-music-without-sudden-stop
  - https://www.soundbridge.io/spotting-session-film
  - https://www.robin-hoffmann.com/dfsb/wall-to-wall-music-in-short-movies/
  - https://air.io/en/youtube-hacks/advanced-retention-editing-cutting-patterns-that-keep-viewers-past-minute-8
difficulty: medium
detectable_from: audio
---

# Give the music rest — plan the windows where there is no bed

## What it is
Wall-to-wall music is named as a common mistake: **a bed that runs from frame one to the end stops being heard.** The published version of the same point is that continuous scoring *"becomes background noise and loses emotional impact"*, and that contrast is what an editor should be manufacturing — remove music so the viewer can feel a different mood and *appreciate the score's return*.

The move is to design the **rests** — deliberate windows with no music at all — as part of the music plan, not as accidents. Rests do three jobs at once: they restore the bed's power on re-entry, they hand the viewer's whole attention to the voice for a serious or emphatic line, and they mark structure.

**A rest is not a duck.** A duck lowers the bed and returns to it; a rest removes it and starts something new. And it is not an intelligibility fix — that is what a carve is for ([[sfx-vocal-vs-instrumental-bed]]).

The output is a **music map**: a video is a sequence of cues and gaps, each with a deliberate in-point and out-point, not one long track with the volume pulled down when someone talks. **Map, do not drape.**

The craft detail that makes a rest work is *where* you stop: on a peak in the waveform — a downbeat, a hit, the end of a musical phrase — so the stop lands as a musical event rather than as an amputation, and *"feels really smooth, it doesn't feel sudden."* The gesture of stopping dead on one chosen frame for one important line is its own note ([[sfx-music-hard-stop]]); this note plans **where the windows are** and how each one is entered and left.

## When to use it
Drop the music out at these specific places:

- **Around the video's most serious or most important lines.** The highest-value use and the source's own trigger: the thesis sentence, the warning, the number that matters. Killing the bed sends all the focus onto the voice, and it is the cheapest emphasis device in the edit.
- **When the bed has been running for more than about 90 seconds** without an event. Not because 90 seconds is magic, but because past that the ear has fully adapted and the music is contributing nothing while still costing intelligibility.
- **At structural boundaries**, in combination with a fade — fade out, rest, new track for the new section ([[sfx-music-fade-out-section-signal]]).
- **Before a re-entry you want to feel big.** A drop, a montage, a reveal. A drop lands harder out of silence than out of a bed; the rest before it is what makes the entry land.
- **On a silent demonstration**, where the thing itself should be heard ([[pace-silent-demonstration-window]]).
- **When the section is pure information delivery with no visual energy** and the talking is dense — the bed is competing with comprehension rather than supporting it.

Do **not**:
- **Rest where the picture is also resting and the voice has stopped.** Total silence in all three layers reads as a technical fault, not as a choice. Leave ambience running.
- **Rest inside a montage or a beat-cut run**, where the bed *is* the structure.
- **Rest on a window that is already silent for another reason** — you cannot rest from nothing.
- **Rest on a regular interval.** A rest every 30 seconds is a pattern, and patterns become invisible. Vary the spacing and anchor rests to content, not to the clock.
- **Rest to solve an intelligibility problem.** Carve instead.

## How to recognise it in a reference video
- **Build the music-presence timeline first.** Isolate low-frequency bed energy and threshold it — speech has little sustained energy under 200 Hz between phrases, but a bed does:
  ```bash
  ffmpeg -i ref.wav -af "lowpass=f=200,astats=metadata=1:reset=0.5,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
  # finer, frame-resolution version (n=1600 @48k = 1 frame @30fps):
  ffmpeg -i ref.mp4 -af "highpass=f=40,lowpass=f=160,asetnsamples=n=1600,\
  astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  Produce a boolean music/no-music track at 0.5 s resolution. A music **out** shows as a **≥8 dB fall in low-band RMS sustained for ≥15 f** that does not coincide with a pause in speech; a music **in** is the mirror image.
- **Compute the scored fraction** = seconds with a bed ÷ total runtime. **This one number tells you whether the reference has a music map at all.** Beds-everywhere creator edits run **0.90–1.00**; a reference practising this note runs **0.55–0.85** (edutainment typically 0.55–0.75); documentary and interview work commonly sits **0.35–0.60**. Under 0.40 the video is using music as punctuation only.
- **Count the rests and measure them.** Expect **2–4 deliberate drop-outs per 10 minutes** in creator work, more in serious or narrative material. Log every window over 3 s. Rest length clusters at **90–450 f (3–15 s)**. A "rest" under 45 f (1.5 s) is a **dip, not a rest**, and should be logged separately.
- **Measure the longest continuous bed.** A well-rested video's longest bed is usually **under 150 s**.
- **Classify what each rest lands on, from the transcript.** In a well-mapped reference, **≥80 %** of rests land on a thesis line, a serious statement, a direct address, a demonstration, or the beat immediately before a re-entry. Rests falling on ordinary explanation or random B-roll are usually a track that simply ran out — check whether the **same** bed resumes afterwards (ran out) or a **different** one starts (deliberate).
- **Examine the out-point itself, at sample zoom.** Three shapes, and you should log which:
  - **(a) transient stop** — the bed's last sample is a hit, cymbal or downbeat and the level goes to zero within 1–3 f. This is the source's "stop on a peak", and the published editorial guidance agrees: clean cutting moments are **at bar lines, after a transient hit, at the end of a phrase, during brief dropouts, and on sustained chords without rhythmic motion**.
  - **(b) fade** — a ramp of 12–45 f.
  - **(c) truncation** — the bed stops mid-sustain with no transient and no ramp, leaving an audible chop. The amateur signature. A 200–400 ms fade used to cover it sounds like a mistake being covered.
- **Check the out-point against the beat grid.** Estimate the bed's BPM, derive the bar length, and measure the out-point's distance from the nearest bar line. Deliberate stops sit within **±3 f** of a bar line or beat; anything past ~8 f was placed by eye on the picture, not on the music.
- **Look at the re-entry.** A rest is only worth its cost if the return is placed: expect the next in-point within **±4 f** of a section start, a structural turn, a picture cut, or the first word of the next section ([[struct-music-arc-to-narrative-arc]]). Also check whether the return **starts on the main beat** rather than on the track's intro warm-up. An undesigned re-entry starts mid-sentence at an arbitrary point.
- **Distinguish rest from duck by measurement, not by ear.** During a duck the bed is still measurable (typically 8–15 dB down but present); during a rest the low-frequency energy is at the noise floor.
- **Track changes vs rests.** Count how many distinct beds the reference uses and whether changes coincide with section boundaries. Multiple beds changing on section boundaries is a mapped edit; one bed for 12 minutes is not.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `scored_fraction` | 0.65–0.70 | 0.45–0.85 | Seconds with a bed ÷ runtime. Above ~0.85–0.90 there is no rest design. |
| `rests_per_10min` | 2–4 | 1–8 | Deliberate drop-outs. Serious/narrative material runs higher. Vary the spacing — an even interval becomes invisible. |
| `rest_len` | 180 f (6.0 s) | 90–600 f (3–20 s) | Below 45 f (1.5 s) it is a dip, not a rest. Past ~20 s the video has simply stopped having music — fine, but a different decision. |
| `min_rest_spacing` | 45 s | 30–90 s | Between two rests. |
| `max_continuous_bed` — soft | 90 s | 45–150 s | Past this the ear has fully adapted; the bed must do *something* — rest, track change, or a real dynamic event. |
| `max_continuous_bed` — hard | 180 s (5400 f) | 150–240 s | Absolute ceiling. Published sync cue lengths cluster at 0:30 / 1:00 / 1:30 / 2:00 / 2:30–3:00. |
| `out_point_type` | transient | transient · phrase-end · fade | **Truncation mid-sustain is never acceptable.** |
| `stop_snap_window` (`bar_alignment`) | ±1 f of the transient | ±0–3 f | Land the stop on the beat or bar line. Off-beat stops sound like an error; past ~8 f it was placed by eye. |
| `stop_micro_fade` (`out_fade`) | 40 ms (≈1–2 f) | 20–80 ms | Even a "hard" stop needs a couple of frames of ramp or it clicks — short enough that it still reads as a stop, not a fade. |
| `soft_out_fade` | 6 f (0.20 s) | 12–45 f for a deliberate soft exit | `0` extra when stopping on a transient. **Never use a 1-second default fade as a stop** — it reads as running out of track. |
| `emphasis_rest_lead` | 0.5 s (15 f) | 0.3–1.2 s | How far **before** the important word the bed is gone. The silence must be established before the line, not during it. |
| `emphasis_rest_tail` | 1.5 s (45 f) | 0.8–3.0 s | Silence held after the line lands, so the sentence is allowed to sit. |
| `pre_reentry_silence` | 45 f (1.5 s) | 30–90 f | Deliberate gap before a return you want felt. |
| `in_point_alignment` (`reentry_anchor`) | ±4 f of a section start, structural turn or picture cut | ±0–8 f | And on the **first main beat** of the track. |
| `skip_intro_warmup` | yes | — | Trim the track's ramp-in with `data-media-start`. |
| `riser_bridge_len` | 45 f (1.5 s) | 30–75 f | Riser bridging two mismatched tracks; the new track starts at the riser's end. |
| `bed_level` | −22 dB (`data-volume` 0.079) | −25 to −20 dB | The level being rested from. Loud rock/guitars down to **−30 dB** (0.0316). |
| `voice_level` | 0 to −3 dB | — | Unchanged by any of this. |
| `ambience_under_rest` | **required** | — | Ambience keeps running through every rest. Three-layer silence reads as a fault. |

## Reproduction prompt

```
Design the music map for {{PROJECT}} before placing a single bed. Inputs: the
assembled picture, the narration with word-level timings, the section
boundaries, and the bed tracks.

1. MAP, DO NOT DRAPE. From the structure document, list every section boundary
   and every line marked serious, emphatic, or thesis-carrying. These are your
   candidate rest anchors. Then produce a list of CUES and RESTS covering the
   whole runtime as alternating spans.
   Constraints: scored fraction 0.65-0.70 (range 0.55-0.85); no BED span longer
   than 90s without a rest, a track change or a real dynamic event, and never
   longer than 180s; 2-4 RESTs per 10 minutes; no two RESTs closer than 45s;
   REST length 180 frames (6.0s) default, 90-450 frames, except where a whole
   passage is deliberately unscored.
2. PLACE THE RESTS ON CONTENT, not on convenience. Eligible: the thesis line,
   any deliberately serious or emphatic line, a silent demonstration, the beat
   immediately before a re-entry you want felt, a section boundary where the
   next track's vibe differs.
3. FOR EACH EMPHASIS REST, set
     rest_in  = {{LINE_START}} - 0.5s
     rest_out = {{LINE_END}}   + 1.5s
   The silence must exist BEFORE the line.
4. STOP THE BED ON A TRANSIENT. For each rest_in, find the nearest hit, cymbal,
   downbeat or phrase end within 8 frames of your intended picture time and move
   the out-point onto it - within 1 frame where possible. Estimate BPM, derive
   the bar length, and land within 3 frames of a bar line. Then either end hard
   on that transient with a 40 ms (1-2 frame) declick ramp, or fade over 12-45
   frames if the moment wants softness. NEVER truncate mid-sustain, and never
   use a 1-second default fade as a stop.
5. KEEP AMBIENCE RUNNING through every rest. Voice, ambience and picture must
   not all fall silent together.
6. PLACE THE RE-ENTRY. Land the next in-point within 4 frames of a section
   start, a structural turn, a picture cut, or the first word of the next
   section. Trim the track's intro warm-up with data-media-start so the cue
   starts on its first MAIN beat, not on its ramp-in. Leave 45 frames of silence
   immediately before a re-entry you want the viewer to feel.
7. CHANGE TRACK AT SECTION CHANGES. If the two tracks share a vibe, butt them on
   a beat. If they do not, stop track one on a transient, place a riser of about
   45 frames, and start track two on the riser's end.
8. LEVELS. Bed -22 dB (loud rock/guitars -30 dB), voice 0 to -3 dB. Carve the
   bed against the voice group at strength 0.25 - do not solve intelligibility
   with a rest.
9. WRITE THE MAP into the design document as explicit in/out seconds before
   building. The map is the deliverable; the placement is mechanical.

ACCEPTANCE TEST: (a) print the scored fraction, rest count and each rest's
length - all in range; (b) every out-point lands on a transient or phrase end
within 3 frames of a bar line; (c) play each rest with 10s of lead-in and tail -
the stop must not be identifiable as a "cut": you should register that the music
HAS GONE, not hear it going, and it must sound intentional rather than cut off;
(d) at every rest, ambience is still audible; (e) every emphasis line is fully
unaccompanied and the thesis line has no music under it; (f) each re-entry lands
within 4 frames of a structural beat and starts on a main beat, not a warm-up;
(g) play the whole video and confirm you still notice the music when it
re-enters - if a re-entry passes unnoticed, the rest before it was too short.
```

## Execution spec

**HyperFrames — a rest is the absence of a clip, not a silent clip.** Two ways to express one, and the choice matters.

*Route A — separate cues (preferred).* One `<audio>` per cue; the gap between them **is** the rest. This is the honest representation: the design document's map and the DOM agree, the render costs nothing during a rest, and each cue carries its own carve and level.

```html
<!-- CUE 1: 0 -> 84.04s. Starts on the track's first main beat (2.4s in), stops on a transient. -->
<audio id="music-a" src=".media/audio/bgm/bed-a.wav" data-audio-group="music"
       data-start="0" data-duration="84.04" data-media-start="2.40"
       data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.2,&quot;v&quot;:1},{&quot;t&quot;:84,&quot;v&quot;:1},{&quot;t&quot;:84.04,&quot;v&quot;:0}]}]}"></audio>

<!-- REST: 84.04 -> 90.0. The emphasis line lives here. NO music element exists. -->
<!-- Ambience continues across the whole runtime, including every rest. -->
<audio id="amb-room" src="assets/ambience/studio-tone.wav" data-audio-group="ambience"
       data-start="0" data-duration="240.00" data-track-index="14" data-volume="0.04"></audio>

<!-- CUE 2: re-entry on the section start at 90.0s, trimmed 6.4s past the warm-up. -->
<audio id="music-b" src=".media/audio/bgm/bed-b.wav" data-audio-group="music"
       data-start="90" data-duration="112" data-media-start="6.4"
       data-track-index="12" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1}]}]}"></audio>

<!-- riser bridging mismatched vibes: 45f = 1.5s, ending exactly on cue 2's start -->
<audio id="riser-s2" src="assets/sfx/riser-01.wav" data-audio-group="sfx"
       data-start="88.50" data-duration="1.50" data-track-index="15" data-volume="0.30"></audio>
```

*Route B — one long bed with a volume lane to zero.* Only when the bed must be musically continuous across the gap (a bar-locked montage). The lane's `t` is **clip-local seconds**:
```
data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
  {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:84,&quot;v&quot;:1},{&quot;t&quot;:84.04,&quot;v&quot;:0},
  {&quot;t&quot;:90,&quot;v&quot;:0},{&quot;t&quot;:90.5,&quot;v&quot;:1}]}]}"
```
**Route B is not the same thing musically:** the track keeps playing behind the fader, so the re-entry lands wherever the track happens to be, not on a chosen bar. Prefer A whenever the re-entry should start on a specific beat.

Contract facts this depends on:
- **All times are seconds; there is no frame attribute.** 2 f = `0.067`; 6 f = `0.20`; 45 f = `1.50`; 180 f = `6.00`.
- **Trim in the composition, not on the file.** `data-media-start` + `data-duration` is how you skip a warm-up and end on a transient; only cut a physical file when the asset is leaving the pipeline.
- **A `volume` lane holds its first value backwards to the clip start and its last value forward to the clip end.** *"So a bed that begins before the voice needs an explicit 'no cut' point at `t: 0`, or it starts out already ducked."*
- **Land the last lane point slightly before `data-duration`**, not on it, per the half-open window `[start, start+duration)` — which is also what lets two cues abut with no overlapping frame. For a rest you want a real gap, so leave it explicit.
- **Never both a `volume` lane and a GSAP `volume` tween** on one track: `audio_volume_double_automation` — the lane wins, the tween is silently ignored. An authored `data-volume` on a tweened track is **replaced**, not scaled (`audio_volume_tween_overrides_gain`).
- **Different `data-track-index` for consecutive cues** even though they never overlap — it costs nothing and keeps `duplicate_audio_track` quiet if a boundary later moves.
- **Every `<audio>` needs an `id`** or it is never mixed → silent render.
- **Carve, don't duck, under narration.** *"A bed playing under narration wants a carve… Skip it only when there is no narration for the music to sit under."* Settings live on the **bed**; `sources` names a **group**, not clip ids; the group holds voices only. `data-fx-carve` is clip-only — **never on an `<hf-audio-group>`** — so every bed element repeats it. Run `node <SKILL_DIR>/scripts/carve.mjs --comp index.html` once and it writes `fromCarve` nodes onto each bed; never hand-write `fromCarve`.
- **`curve` (−1..1) bends the segment leaving a point**, `viaX`/`viaY` supersede it, and a lane holds at most **512 points**. For an exit closer to equal-power, add `"curve": 0.4` to the penultimate point rather than stacking extra points.
- **Relative timing** (`data-start="music-a + 6"`) can express the rest, but spaces around the operator are required and every failure mode resolves silently to 0. Prefer absolute seconds for something this structural.

**Finding the transient to stop on.** There is no beat-detection primitive in the stack. Do it with ffmpeg on the bed file before placing it:
```bash
# per-frame RMS on the bed alone: local maxima are candidate out-points
ffmpeg -i bed-a.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
# low-band peaks mark kicks/downbeats
ffmpeg -i bed-a.wav -af "lowpass=f=160,asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
# physically cut a cue that leaves the pipeline, with a 0.20s tail
ffmpeg -i bed.mp3 -ss 2.40 -t 84.04 -af "afade=t=out:st=83.84:d=0.20" -c:a pcm_s16le cue1.wav
# loudness-match cues to each other before mixing (two-pass: measure, then apply)
ffmpeg -i cue1.wav -af loudnorm=I=-16:TP=-1.5:LRA=11:print_format=json -f null -
```
If the track's BPM is known (Epidemic exposes `bpm` on every `Recording`), **the beat grid is arithmetic and more reliable than peak-picking on a dense mix**: `beat = 60 / bpm`, `bar = 4 × beat`. Snap the stop to `data-media-start + n × bar`.

**Epidemic Sound — build beds that are already the right length.** The strongest version of this note is not trimming a five-minute track to 84 seconds; it is asking the catalogue for an 84-second version with a real beginning and end:
```
SearchRecordings { query:{ term:"<vibe> instrumental" },
                   filter:{ bpm:{min:100,max:120}, vocals:false },
                   sort:{ by: POPULARITY, order: DESCENDING }, first: 20 }
EditRecording { id:<uuid>, input:{ targetDurationMs: 84000, forceDuration: true,
                                   downloadAudioFormat: WAV,
                                   preferenceRegions:[{startMs:0,endMs:8000,preferenceType:AVOID}] } }
PollEditRecordingJob { ... } ; DownloadRecordingEdit { input:{ jobId, editId } }
```
`targetDurationMs` maxes out at 300000 ms (5 minutes), which is also a useful sanity bound on how long any single bed span should be. The published editorial preference is a **button ending** over a fade, because a fade *"remove[s] agency from the editor"* — so where a track has no clean ending, compose one rather than fading over an arbitrary passage.

Three further catalogue levers:
- **BPM matched to delivery speed** ([[pace-bpm-matched-music-selection]]), instrumental wherever your own voice is present ([[sfx-vocal-vs-instrumental-bed]]).
- **`SearchSimilarToRecording { id }`** on the outgoing track finds the successor for the span after the rest — the "find similar" move, and why a cue change at a section boundary can be inaudible.
- **`DownloadRecording` accepts `stemType: FULL | BASS | DRUMS | INSTRUMENTS`.** A **partial rest** — dropping to the `DRUMS` stem alone for 20 seconds under a dense passage — is a real option when a full rest would leave the video feeling dropped.

For the riser bridge when vibes do not match: `SearchSoundEffects { query.term: "riser build tension short", filter.duration { max: 3000 } }`, placed in the `sfx` group, ending exactly on the new cue's `data-start` ([[sfx-riser-anticipation-build]]).

**Remotion:** one `<Audio>` per bed span inside its own `<Sequence>`; the rest is the frame range no sequence covers. Concept only; no Remotion runtime exists in this project.

## Pairs with
[[sfx-music-fade-out-section-signal]] · [[sfx-music-hard-stop]] · [[sfx-silence-as-pattern-interrupt]] · [[sfx-track-change-at-section-boundary]] · [[sfx-five-layers-build-order]] · [[struct-music-arc-to-narrative-arc]] · [[struct-thesis-line-payoff]] · [[pace-bpm-matched-music-selection]] · [[sfx-loud-guitar-minus-30]] · [[sfx-music-sets-the-mood]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-music-audition-against-picture]] · [[sfx-riser-anticipation-build]] · [[pace-silent-demonstration-window]] · [[pace-cut-on-the-beat]] · [[sfx-music-primacy-doctrine]] · [[struct-cross-cutting-parallel-action]] · [[sfx-placement-discipline]] · [[sfx-track-reversion-to-edit-length]] · [[sfx-music-stem-layering]]

## Failure modes
- **Wall-to-wall bed.** The named mistake. The bed stops being heard, every return is wasted, and the mix has no dynamic range left. Fix: a music map with a scored fraction of 0.55–0.85 and at least 2 rests per 10 minutes, written before placement.
- **Truncating mid-sustain.** The bed stops in the middle of a chord and the edit sounds broken. Fix: move the out-point to the nearest transient, bar line or phrase end within 8 frames, then a short tail.
- **A "hard" stop with no micro-fade.** Cutting at a non-zero sample clicks. Fix: 40 ms, two breakpoints — short enough that it still reads as a stop.
- **Using the editor's 1-second default fade as a stop.** Reads as running out of track, not as a decision. Fix: hard stop on a transient, or a chosen 12–45 frame fade.
- **Resting the music and everything else at once.** Voice out, picture static, bed gone: the viewer checks their connection. Fix: ambience always continues through a rest.
- **Resting instead of carving.** Killing the bed every time the voice is hard to hear is a mix problem being solved with structure. Fix: carve at 0.25 against the voiceover group; reserve rests for emphasis.
- **Resting after the important line has started.** The silence arrives too late to frame it. Fix: the bed is gone 0.5 s *before* the line.
- **Rests on nothing.** A gap where the track simply ran out, with the same bed resuming afterwards — functionally invisible because nothing happens in it. Fix: put content in the rest — the thesis, the serious line, the demonstration, the silence before a drop.
- **Rests on a regular interval.** Becomes a pattern and disappears. Fix: vary spacing; anchor rests to content, not to the clock.
- **Re-entry on a warm-up.** The new cue fades in on the track's ramp-in, the section starts on mush, and the rest is undone. Fix: `data-media-start` past the intro, or `AVOID` the intro region in `EditRecording`.
- **A rest too long.** Past ~15–20 s of unscored talking the video feels like it lost its soundtrack. Fix: 90–450 frames, and check the picture is carrying the energy during it.
- **Mismatched consecutive cues.** Two individually good tracks that do not belong to the same album. Fix: `SearchSimilarToRecording` for the handoff, or bridge with a riser and accept the change as deliberate.
- **Reverb tails outliving the cue.** `reverb`/`delay` lengthen the rendered track (`chainTailSeconds`), so *"a bed with reverb no longer ends exactly at its `data-duration`; that is expected, not a bug"* — but it will bleed into a rest. Fix: shorten the cue, or drop the reverb on a cue whose stop must be clean.
- **Known gap:** the coverage percentages, the continuous-bed ceilings and the rests-per-10-minutes figures are conventions derived from the source's stated mistake plus the measurement procedure above; they are calibration targets, not published standards. Measure the reference and use *its* numbers when you have one.
- **Known gap:** the stack has no beat detection, no BPM detection and no automatic music/no-music segmentation. The out-point transient must be found by the RMS/peak traces above or derived from the track's published BPM; `data-playback-rate` is a constant (no rate envelope), so a bed cannot be time-stretched to fit a picture in-composition. The ffmpeg leg must run somewhere with ffmpeg on PATH — not assumed on this VM.
