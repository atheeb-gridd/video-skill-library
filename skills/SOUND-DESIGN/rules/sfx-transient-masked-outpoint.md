---
id: sfx-transient-masked-outpoint
title: Hide an audio out-point behind a transient — the 100 ms forward-masking window
skill: sound-design
type: mix
family: music-arc
tags: [skill/sound-design, type/mix, family/music-arc, engine/hyperframes, engine/ffmpeg, engine/epidemic, layer/music, layer/ambience, layer/sfx, source/editing-kt-3, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:00"
    quote: "whenever you have to turn the music off, turn it off at some peak point of the audio. You can see this from the waveform — where you see a peak, turn the music off there. It feels very smooth, it doesn't feel sudden."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:02"
    quote: "And you can find the peak just by looking at the waveform."
research_refs:
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://librosa.org/doc/latest/generated/librosa.onset.onset_detect.html
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/EBU_R_128
difficulty: medium
detectable_from: audio
---

# Hide an audio out-point behind a transient — the 100 ms forward-masking window

## What it is
The source gives an instruction and a reason: *stop the music at a peak in the waveform, and it feels smooth rather than sudden.* This note supplies the mechanism, the exact window in frames, and the way to find the peak programmatically instead of by eye.

The mechanism is **temporal masking**. A loud transient suppresses the ear's sensitivity to what follows it for roughly **100 ms** (forward, or post-, masking) and to what precedes it for roughly **20 ms** (backward, or pre-, masking). An audio out-point is a discontinuity, and a discontinuity is only noticed if it is heard. Land it inside the 100 ms shadow behind a transient — **1 to 3 frames after the peak at 30 fps** — and the ear is momentarily too busy recovering from the transient to register that something stopped. The backward window works too but is five times tighter, which is why "stop *at* the peak" in practice means "stop just *after* it."

Two distinct problems get solved here and they are constantly confused:

- **The musical discontinuity** — a phrase interrupted mid-flight, a rhythm stopping off the grid. Fixed by *where* the out-point sits: inside a transient's masking shadow, and on the beat grid.
- **The sample discontinuity** — a cut through a non-zero sample, which is a step, and a step is broadband. Fixed by a **2 ms ramp** or a zero crossing, which is 0.06 of a frame and inaudible as a fade.

Both are needed. A perfectly beat-placed stop still clicks if the waveform was mid-cycle; a click-free stop still sounds sudden if it lands in the middle of a sustained chord.

This is the shared mechanism under several notes that each own a different editorial decision: [[sfx-music-hard-stop]] (stop the bed dead for one line), [[sfx-music-fade-out-section-signal]] (ramp it out at a section boundary), [[sfx-track-change-at-section-boundary]] and [[sfx-beat-aligned-handover]] (swap tracks). Those decide *whether and why*; this decides *on which frame*.

## When to use it
- **Every music out-point, without exception.** A hard stop, a fade-out's start, a track change's cut, an ambience bed ending at a location change, an SFX tail truncated to get it off a word.
- **Especially on a hard stop**, where there is no ramp to hide behind and the frame is the whole craft.
- **On an ambience change across a cut.** A room-tone swap has no rhythm to land on, so the transient you use is the picture's own — a door, a footstep, a hand on a table — which makes this the same move as [[sfx-ambience-bridge-across-cut]].
- **Not on a smash cut.** There the discontinuity is the *point* — [[sfx-smash-cut-audio-contrast]] wants it heard, and hiding it defeats the move. Still apply the 2 ms de-click ramp there; that is a different problem.
- **Not as a substitute for choosing the right moment.** Masking makes a stop smooth; it does not make a badly-placed stop meaningful.
- **Not where the track has no transients.** A pure pad or drone has nothing to hide behind. There the honest answer is a fade of 0.5–1.5 s, not a masked cut.

## How to recognise it in a reference video
- **Find every music/ambience out-point** by tracing band-limited RMS at fine resolution and looking for a floor drop:
  ```bash
  ffmpeg -i ref.mp4 -vn -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
    ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -   # 1600 samples = 33.3 ms = 1 frame
  ```
- **For each out-point, find the nearest preceding transient peak and measure the gap in milliseconds.**
  | Gap (peak → out-point) | Verdict |
  |---|---|
  | **0 to +100 ms (0–3f)** | inside the forward-masking shadow — the intended technique |
  | +100 to +250 ms (3–7f) | out of the shadow; audible as a stop, may still be musical if it is on a beat |
  | > +250 ms | unmasked and unplaced; this is the "sudden" the source is warning about |
  | −20 to 0 ms | inside the backward-masking window — also works, and five times harder to hit |
  | < −20 ms (out-point before the peak) | the transient arrives *after* the cut, so nothing masked anything |
- **Cross-check the beat grid.** Extract BPM, build the grid, and check the out-point is within ±2 frames of a grid position. At 100 BPM a beat is 0.6 s = 18 frames. Masking and the grid usually agree, because a beat *is* a transient; when they disagree, professional edits follow the grid.
- **Zoom to the sample level at the out-point.** Look for either a landing on a zero crossing or a ramp of 1–5 ms. A vertical edge mid-cycle plus an audible tick means nobody checked.
- **Check what is left holding the floor.** A stop into total digital silence reads as a fault; a stop into ambience or room tone reads as a choice. Measure the floor after the stop: it should sit around −24 dB relative to dialogue, not at −∞.
- **Count the out-points.** Music that stops and restarts more than about four times in a five-minute video is restless, however well each stop is placed.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `offset_from_peak` | +2f (67 ms) | 0 to +3f (0–100 ms) | The forward-masking shadow is ~100 ms. +2f is the middle of it and the safest default. |
| `backward_alt` | −0.5f (−17 ms) | −20 to 0 ms | Backward masking is ~20 ms. Usable, but under one frame of tolerance. |
| `declick_ramp` | 2 ms | 1–5 ms | 0.03–0.15 frames. Removes the step-discontinuity click. Never lengthen this to fix a "sudden" feeling. |
| `beat_tolerance` | ±2f | ±0 to ±3f | Against the extracted beat grid. Where grid and masking conflict, follow the grid. |
| `transient_prominence` | ≥ 6 dB | 4–15 dB | How far the peak rises above the 200 ms preceding it. Under 4 dB it is not a transient and will not mask. |
| `fallback_fade` | 0.8 s | 0.5–1.5 s | For pad/drone material with no usable transient. `sine.inOut`-shaped, i.e. a `curve` of about 0.3 on the lane. |
| `post_stop_floor` | 0.063 (−24 dB rel. dialogue) | 0.05–0.10 (−26 to −20 dB) | Ambience or room tone left running. Not silence. |
| `detect_hop` | 256 samples @48 kHz (5.33 ms) | 128–512 | librosa's default `hop_length=512` at `sr=22050` is **23.2 ms** — coarser than a video frame. Set both explicitly. |
| `out_points_per_5min` | 3 | 1–4 | Above this the bed is nervous regardless of placement. |

## Reproduction prompt

```
Place the music out-point for the cue ending near {{TARGET}} seconds.

1. DEFINE THE EDITORIAL CONSTRAINT FIRST. The out-point must land within
   {{WINDOW}} of {{TARGET}} - typically 0.5 s - because a line, a cut or a
   section boundary is what requires it. Masking chooses the frame INSIDE
   that window; it does not choose the window.
2. DETECT TRANSIENTS in the music file over the window. Preferred:
     import librosa
     y, sr = librosa.load("bed.wav", sr=48000, mono=True)
     on = librosa.onset.onset_detect(y=y, sr=sr, hop_length=256,
                                     units="time", backtrack=False)
   Set sr and hop_length EXPLICITLY. The defaults (sr=22050,
   hop_length=512) give 23.2 ms resolution, coarser than one video frame.
   Leave backtrack=False: backtrack moves each onset to "the nearest
   preceding minimum of energy", which is the opposite of the peak you want.
   ffmpeg fallback, no Python needed:
     ffmpeg -i bed.wav -af "asetnsamples=n=256,astats=metadata=1:reset=1,\
       ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null -
   then take local maxima that rise at least 6 dB above the preceding 200 ms.
3. EXTRACT THE BEAT GRID from the track's BPM and mark grid positions inside
   the window.
4. CHOOSE THE PEAK that is (a) inside the window, (b) within 2 frames of a
   grid position, (c) at least 6 dB prominent. Call its time {{PEAK}}.
   If no peak qualifies, this is pad or drone material - skip to step 7.
5. SET THE OUT-POINT at {{PEAK}} + 0.067 (2 frames). Express it as the
   clip's data-duration: data-duration = {{PEAK}} + 0.067 - data-start.
6. DE-CLICK with a 2 ms ramp: the volume lane's last two points are
   (data-duration - 0.002, v:1) and (data-duration, v:0). This is not a
   fade; do not lengthen it.
7. NO-TRANSIENT FALLBACK: a 0.8 s ramp to zero ending at {{TARGET}}, with a
   curve of about 0.3 on the departing point so it leaves gently.
8. HOLD THE FLOOR. Confirm an ambience or room-tone clip continues past the
   out-point at 0.063. If there is none, place one - a stop into digital
   silence reads as a technical fault.
9. VERIFY the gap: measure the finished mix and confirm
   out_point - nearest_preceding_peak is between 0 and 100 ms.

ACCEPTANCE TEST: play from 4 s before to 2 s after, twice, at normal volume.
First pass, watching picture: you must notice the music is GONE without
having noticed it STOP. Second pass, audio only, listening for a tick: if
there is one, the ramp is missing, not too short. If the stop is clean but
still feels abrupt, move to the next qualifying peak - do not lengthen the
ramp, because that turns a hard stop into a fade and changes the edit.
```

## Execution spec

**Hyperframes — the out-point is a `data-duration`, and the de-click is the last two points of a volume lane.**

A bed starting at 12.00 s whose chosen masking peak sits at composition time 58.32 s:

```html
<!-- out-point = 58.32 + 0.067 = 58.387 ; duration = 58.387 - 12.00 = 46.387 -->
<audio id="bgm-sec-2" src="assets/bgm/bed.wav"
       data-audio-group="music"
       data-start="12.00" data-duration="46.387"
       data-track-index="14" data-volume="0.075"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:46.385,&quot;v&quot;:1},{&quot;t&quot;:46.387,&quot;v&quot;:0}]}]}"></audio>

<!-- the floor that survives the stop -->
<audio id="amb-room" src="assets/sfx/room-tone-office.wav"
       data-audio-group="ambience" data-start="12.00" data-duration="72.00"
       data-track-index="13" data-volume="0.063"></audio>
```

And the no-transient fallback, a 0.8 s ramp with a curve bending the departure:

```html
data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
  {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:45.587,&quot;v&quot;:1,&quot;curve&quot;:0.3},{&quot;t&quot;:46.387,&quot;v&quot;:0}]}]}"
```

Contract points that decide whether this executes:
- **All authored time is seconds; there is no frame attribute.** 2 frames at 30 fps is `0.067`. Keep the frame count as a comment.
- **Lane `t` is clip-local seconds** — subtract the clip's `data-start`. On an `<hf-audio-group>` bus, `t` is composition time instead, because a bus has no `data-start`. Mixing these up is the most common bug here.
- **A lane holds its first value backwards to the clip start and its last value forward to the clip end.** The `t: 0, v: 1` point is mandatory or the bed starts already faded.
- **`curve` (−1..1) bends the segment *leaving* a point**, so the curve goes on the *earlier* of the two fade points. `viaX`/`viaY` supersede it if you need a specific inflection.
- **512 points per lane maximum.**
- **Never GSAP-tween `volume` alongside a lane** — `audio_volume_double_automation`, the lane wins silently and the tween vanishes.
- **The half-open visibility window is `[start, start + duration)`**, so the clip is already silent at exactly `t = duration`. The 2 ms ramp lands at `duration`, which is the last authored value the lane holds forward — safe, and the reason to ramp rather than rely on the boundary.
- **A reverb or delay in the bed's chain adds `chainTailSeconds`**, so *"a bed with reverb no longer ends exactly at its `data-duration`; that is expected, not a bug."* On a masked hard stop that tail is precisely what you are trying to avoid: either remove the time-based effect from the bed's chain or accept that the stop is a fast decay, not a stop.
- **Nothing in lint validates any of this.** The verification is the ffmpeg measurement plus a listen.

**ffmpeg — detection and verification.**
```bash
# per-frame peak trace (1600 samples @48k = 33.3 ms = one frame at 30fps)
ffmpeg -i bed.wav -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.Peak_level:file=peaks.txt" -f null -

# finer, for placing the out-point (256 samples = 5.33 ms)
ffmpeg -i bed.wav -af "asetnsamples=n=256,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.Peak_level:file=fine.txt" -f null -

# emphasise percussive transients before detecting, so a sustained chord does not win
ffmpeg -i bed.wav -af "highpass=f=1500,asetnsamples=n=256,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.Peak_level:file=hf.txt" -f null -

# confirm the floor after the stop is not silence
ffmpeg -i mix.wav -af "silencedetect=noise=-50dB:d=0.3" -f null -

# baking an out-point into a file (export only). acrossfade ALWAYS ramps, so for a
# masked hard stop trim instead, and let the composition own the 2 ms ramp:
ffmpeg -i bed.wav -t 46.387 -c:a pcm_s16le bed.out.wav
```
`highpass`/`lowpass` take `frequency`, `poles`, `width_type` (`q|o|h|d`) and `mix`; two poles is 12 dB/octave, since an order-*n* all-pole filter rolls off at 6*n* dB/octave. The high-pass before detection matters: onset detection on full-band material can lock onto the loudest *sustained* moment rather than the sharpest one, and it is sharpness that masks.

**librosa — the precise route, with the two settings everyone leaves at default.**
```python
import librosa
y, sr = librosa.load("bed.wav", sr=48000, mono=True)
onsets = librosa.onset.onset_detect(y=y, sr=sr, hop_length=256,
                                    units="time", backtrack=False)
# hop_length=256 @ 48 kHz = 5.33 ms resolution.
# librosa's defaults are sr=22050 and hop_length=512 -> 23.2 ms, coarser
# than one 30 fps frame, which is not good enough to place a frame.
# backtrack=True snaps each onset to "the nearest preceding minimum of
# energy" - useful for slicing loops, wrong here: we want the PEAK.
tempo, beats = librosa.beat.beat_track(y=y, sr=sr, hop_length=256, units="time")
```
`onset_detect` returns *"estimated positions of detected onsets, in whichever units are specified"*; with `sparse=False` it returns a dense boolean array instead, which is easier to intersect with a beat grid.

**Epidemic Sound — the relevant fetch is the floor, not the bed.** The stop needs something to stop *into*:
```
SearchSoundEffects { query: { term: "room tone office quiet ambience" }, filter: { duration: { min: 20000, max: 120000 } } }
SearchSoundEffects { query: { term: "<location> ambience loop" }, sort: { by: DURATION, order: DESCENDING } }
DownloadSoundEffect { id: <uuid>, options: { fileType: WAV } }
```
Also relevant: `SearchRecordings` returns `audioFile.waveformUrl` — a JSON waveform per track — which lets you locate candidate peaks *before* downloading anything, and `bpm` as an integer for building the grid. Prefer **WAV** for the bed: mp3 pre-echo puts energy *before* each transient, which smears the very boundary this note places to the millisecond.

**Remotion:** an `<Audio>` whose `volume` callback returns 1 until the out-point frame and 0 after, with the transition spread over ~2 ms of samples. Concept only; Remotion is not part of this stack.

## Pairs with
[[sfx-music-hard-stop]] · [[sfx-music-fade-out-section-signal]] · [[sfx-music-rest-windows]] · [[sfx-track-change-at-section-boundary]] · [[sfx-beat-aligned-handover]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-ambience-search-formula]] · [[sfx-smash-cut-audio-contrast]] · [[sfx-music-stem-layering]] · [[sfx-peak-on-the-cut]] · [[pace-beat-grid-extraction]] · [[pace-cut-on-the-beat]] · [[sfx-silence-as-pattern-interrupt]] · [[cut-audio-match]] · [[sfx-layer-volume-targets]]

## Failure modes
- **Stopping before the peak.** The transient then arrives after the cut and masks nothing; the stop is fully exposed. Fix: the out-point goes 0–100 ms *after* the peak, never before it by more than 20 ms.
- **Stopping more than 100 ms after the peak.** Out of the shadow. This is the exact failure the source calls "sudden". Fix: move to +2 frames of the nearest qualifying peak.
- **Using a sustained swell as the "peak".** A loud moment is not a transient; masking needs a fast rise. Fix: require ≥6 dB of prominence over the preceding 200 ms, and high-pass before detecting.
- **librosa at defaults.** `sr=22050, hop_length=512` is 23.2 ms per frame — coarser than a video frame, so the detected onset can be a frame off before you start. Fix: `sr=48000, hop_length=256`.
- **`backtrack=True`.** Snaps to the preceding energy *minimum*, which is the quietest nearby point — the worst possible place to hide a cut. Fix: `backtrack=False`.
- **Lengthening the de-click ramp to fix an abrupt feel.** Turns a hard stop into a short fade and changes the editorial move without solving the placement. Fix: 2 ms stays 2 ms; move the frame instead.
- **No ramp and no zero crossing.** A step discontinuity is broadband and ticks on every playback system. Fix: 2 ms ramp.
- **Stopping into digital silence.** Reads as a fault. Fix: ambience or room tone at −24 dB relative to dialogue continues across the stop.
- **Reverb still in the bed's chain.** `chainTailSeconds` means the bed rings past the out-point and the stop is a decay. Fix: remove the time-based node, or choose a fade instead.
- **Reading lane `t` as composition time on a clip.** Puts the ramp somewhere else entirely, usually silently. Fix: clip lanes are clip-local; bus lanes are composition-time.
- **Known gap:** the ~100 ms forward and ~20 ms backward figures are general psychoacoustic values for masking a *probe tone* after a *masker*, not measurements of how well an edit discontinuity is concealed in music. They predict the direction and the rough size of the window reliably, and they explain why the source's instruction works, but the exact tolerance varies with the transient's spectrum and the material's density. Default to +2 frames and let a listen arbitrate.
- **Known gap:** `librosa` is not verified present in this environment, and the ARM64/no-sudo constraint means a `pip install` may not be available. The ffmpeg `asetnsamples` + `astats` route above is the fallback and needs nothing beyond ffmpeg, which the stack already assumes.
