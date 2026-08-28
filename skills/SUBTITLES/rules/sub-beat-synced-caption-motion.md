---
id: sub-beat-synced-caption-motion
title: Sync caption motion to onsets and to emphasis, not to the beat grid
skill: subtitles
type: caption-motion
family: kinetic-type
tags: [skill/subtitles, type/caption-motion, family/kinetic-type, engine/hyperframes, engine/ffmpeg, source/hyperframes, source/research, difficulty/high]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "onset_detect returns transients — where something actually happens — which is usually the better anchor for a cut, since a beat grid is regular by construction and an onset is not."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Tempo estimates halve and double. A 91 BPM bed is regularly reported as 182 or 45.5. But this project has a free ground truth: the Epidemic catalogue hands you Recording.bpm on every search result."
research_refs:
  - https://librosa.org/doc/main/generated/librosa.beat.beat_track.html
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://www.nngroup.com/articles/animation-duration/
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
difficulty: high
detectable_from: video
---

# Sync caption motion to onsets and to emphasis, not to the beat grid

## What it is

There are three clocks a caption can move to, and choosing between them is the whole technique.

**The speech clock.** Word onsets from forced alignment. This is the default and it is almost always right: the caption's job is to track the voice, and a treatment that lands on the word's onset is *correct* rather than *decorative*.

**The emphasis clock.** The subset of word onsets where the speaker actually stresses a word — higher amplitude, longer duration, a pitch move. This is a strictly better anchor than the beat grid for a talking-head video, because it is derived from the performance rather than imposed on it. It is also cheap to approximate: within an aligned transcript, a content word whose duration exceeds its neighbours by ~40 % and whose local amplitude peak is 3+ dB above the phrase mean is a stressed word.

**The music clock.** Beats or onsets from the bed. This is the one people reach for first and it is the one with the most failure modes. Two hard facts:

- **A beat grid is regular by construction; an onset is not.** `librosa.beat.beat_track` returns an estimated tempo and a regular beat grid — which means it will happily place beats where nothing happens. `librosa.onset.onset_detect` returns transients: where something *actually* happens. For binding motion, onsets are the better anchor.
- **Tempo estimates halve and double.** A 91 BPM bed is regularly reported as 182 or 45.5. The project has a free ground truth — the Epidemic catalogue returns `Recording.bpm` on every search result — which downgrades librosa from a tempo detector to a **phase** detector: where beat one actually falls. That is the harder problem and the one you actually need.

**The rule that resolves the conflict.** When the speech clock and the music clock disagree — and they will, constantly — **the speech clock wins for the caption's cue timing and the music clock may only be used for the caption's *motion accent***. A cue that appears on the beat instead of on its word is out of sync with the voice, which every viewer notices. A cue that appears on its word and *pulses* on the nearby beat is in sync with both.

And there is a distance limit: a motion accent may be pulled to a beat only if the beat is within **±3 frames** of where the accent would otherwise sit. Beyond that, drop the accent rather than move it.

**The density cap.** Beat-synced caption motion is fatiguing far faster than beat-synced cutting, because the caption is also the thing being read. At 120 BPM there are two beats a second; putting a caption accent on every beat is 120 accents a minute. Cap it at **one accent per bar or slower** — roughly 0.5 accents per second at 120 BPM — and only during sections where the music is foreground.

## When to use it

- In a **music-forward section** — an intro, a montage, a list burst over a bed — where the bed is loud enough to be the driver rather than the floor.
- On a **structural caption** (a topic card, a numbered item marker) landing on a downbeat.
- On **emphasis words**, synced to the speaker's own stress, which is the version that works in a talking-head video with a quiet bed.
- **Do not** re-time cues to the grid. Ever. Cue timing belongs to the voice.
- **Do not** use beat sync at all when the bed is below the voice by more than ~12 dB — the viewer cannot hear the beat you are syncing to, so the motion has no motivation and reads as random.

## How to recognise it in a reference video

- **Extract the bed's onsets and the caption's motion frames, and compare.** Motion frames come from dense extraction (`select='between(n,…)'`, `-fps_mode passthrough`). Compute the distance from each accent to the nearest onset. A beat-synced track clusters within **±2 frames**; an unsynced one scatters uniformly.
- **Check against the speech clock too.** The diagnostic question is which clock the *cues* follow and which the *accents* follow. Cues within ±2 frames of word onsets and accents within ±2 frames of music onsets is the correct hybrid; cues locked to the grid is the failure.
- **Accent density.** Count accents per second and compare to the BPM. At 120 BPM, an accent every beat is 2/s and will be visibly relentless; one per bar is 0.5/s.
- **Downbeat correlation.** Structural captions in a well-synced video land on downbeats, not on arbitrary beats. Check whether topic cards land on 1.
- **The tempo cross-check.** Read the bed's actual BPM if you can identify the track; a detector that reported double or half will produce accents on every other event and it is visible as a limp, one-in-two pattern.
- **Music level.** Measure the bed against the voice. If the bed is inaudible, any beat sync in the captions is invisible work.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `cue_clock` | speech | speech | Non-negotiable. Cue timing follows word onsets. |
| `accent_clock` | onsets | onsets / beats / stress | Onsets for music; stress for a quiet bed. |
| `accent_density` | 1 per bar | 0.25–1 per bar | At 120 BPM, 0.5/s maximum. |
| `snap_window` | ±3 frames | ±2–4 f | Beyond this, drop the accent rather than move it. |
| `accent_duration` | 0.13 s (4 f) | 0.10–0.20 s | Same band as any per-word pop. |
| `accent_magnitude` | scale 1.04 | 1.00–1.08 | Smaller than a structural pop; it is a pulse, not an event. |
| `bpm_source` | catalogue metadata | catalogue / detector | `Recording.bpm` from Epidemic is ground truth; the detector supplies phase. |
| `phase_source` | onset detection | — | Where beat one actually falls. |
| `min_bed_level` | −12 dB vs voice | −15 to −9 dB | Quieter than this and the sync is inaudible. |
| `downbeat_priority` | structural captions | — | Topic cards land on 1, not on any beat. |
| `disagreement_rule` | speech wins | — | Cue on the word, accent on the beat. |
| `sections` | music-forward only | — | Do not beat-sync the whole video. |

## Reproduction prompt

```
Add beat-synchronised motion accents to the caption track of {{PROJECT}}
without disturbing cue timing.

1. GROUND TRUTH FIRST. Take the bed's BPM from catalogue metadata ({{BPM}}),
   not from a detector - detectors halve and double. Then get the PHASE from
   onset detection:
     y, sr = librosa.load("{{BED}}", sr=None, mono=True)
     onsets = librosa.onset.onset_detect(y=y, sr=sr, units="time")
   Prefer onsets to beat_track's grid: a grid is regular by construction and
   will place beats where nothing happens.
2. GATE THE SECTION. Apply accents only where the bed sits within
   {{BED_LEVEL}} = 12 dB of the voice. Elsewhere use the speaker's own
   stressed words as the accent clock.
3. SELECT at most one accent per bar (bar = 240 / {{BPM}} seconds),
   preferring words the emphasis rule already selected.
4. BIND. Place the accent on the ONSET only if that onset is within
   {{WINDOW}} = 3 frames of the word's own onset; otherwise place nothing.
   Never move the cue itself.
5. AUTHOR each accent as a {{DUR}} = 0.13s scale pulse to {{MAG}} = 1.04,
   power2.out, on a transform inside a fixed layout box.

ACCEPTANCE TEST: no cue start moved in this pass; accent density is at or
under one per bar; every accent is within 2 frames of a detected onset and 3
frames of its word's onset; no accents exist where the bed is more than 12 dB
under the voice; and the BPM used is the catalogue value, recorded in the
design doc.
```

## Execution spec

**HyperFrames has no beat-detection surface**, and the creative helper script that would provide one is not staged. So the beat grid comes from outside the stack, at build time, and enters the composition as literal seconds in the tween positions — exactly like cue times. Run librosa in the container, not on the device VM: an install is a network path and the device is linux ARM64 without sudo.

The audio-reactive pattern the framework does support is instructive here: a reactive visual reads a **pre-baked** frequency curve and must remain a function of `tl.time()`, **never `audio.currentTime`**. Same discipline applies — bake the onset list, place tweens at absolute seconds, and never read the audio element at render time. Determinism bans make the alternative unrenderable anyway: no render-time clocks, no unseeded randomness, no fetches.

Placement is ordinary timeline work:

```js
// accent on a detected onset at 31.402s, bound to the word "twice"
tl.fromTo("#w-0871 .inner", { scale: 1 },
  { scale: 1.04, duration: 0.13, ease: "power2.out" }, 31.402);
tl.to("#w-0871 .inner", { scale: 1, duration: 0.10, ease: "power2.in" }, 31.532);
```

`ffprobe` the file for fps before converting any frame window; the reference set spans 60, 25 and 29.97 fps and a ±3-frame window is 50 ms in one and 120 ms in another. The AV-sync tolerances are the sanity check on that window: detectability runs from 45 ms audio lead to 125 ms lag, so a ±3-frame window at 30 fps (±100 ms) is at the edge of what a viewer will notice and ±2 frames is safer.

Cross-skill: the same onset list should drive [[pace-cut-on-the-beat]] and [[sfx-beat-aligned-handover]]. If the caption accents and the cuts were derived from different detections, they will disagree by a frame or two and the video will feel loose without anyone being able to say why — derive once, share the list.

## Pairs with
[[sub-per-word-pop-scale-colour]] · [[sub-spring-and-bounce-budget]] · [[sub-emphasis-selection-rule]] · [[sub-fast-cut-sequence-captions]] · [[pace-cut-on-the-beat]] · [[pace-beat-grid-extraction]] · [[pace-bpm-matched-music-selection]] · [[sfx-beat-aligned-handover]] · [[motion-beat-quantised-animation]] · [[motion-impact-frame-quantisation]]

## Failure modes
- **Re-timing cues to the grid.** The captions leave the voice, which every viewer notices immediately. Correction: cues on words, accents on beats.
- **Using `beat_track`'s grid as the anchor.** Accents land where nothing happens. Correction: onsets.
- **Trusting a detected tempo.** Halved or doubled tempo produces a one-in-two limp. Correction: catalogue BPM for tempo, detector for phase.
- **An accent on every beat.** 120 accents a minute; fatiguing and meaningless. Correction: one per bar.
- **Beat sync under an inaudible bed.** Invisible work that reads as random motion. Correction: gate on the bed level.
- **Deriving the beat list twice.** Caption accents and cuts land a frame or two apart and the section feels loose. Correction: one shared onset list.
- **Reading `audio.currentTime` to drive the accent.** Not seekable, not deterministic, absent from the render. Correction: bake and place at absolute seconds.
- **Snapping an accent more than 3 frames.** It leaves its word and starts reading as a music-video effect rather than as emphasis. Correction: drop it instead.
