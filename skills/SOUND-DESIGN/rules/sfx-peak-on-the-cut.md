---
id: sfx-peak-on-the-cut
title: Put the sound's loudest peak on the cut frame, not the file's first frame
skill: sound-design
type: sfx
family: sfx-placement
tags: [skill/sound-design, type/sfx, family/sfx-placement, sfx/motion, layer/sfx, layer/music, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-2, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:58"
    quote: "So first of all, if you're putting a sound effect on a cut, place the highest peak of the sound effect on the cut."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:00"
    quote: "whenever you have to turn the music off, turn it off at some peak point of the audio. You can see this from the waveform — where you see a peak, turn the music off there. It feels very smooth, it doesn't feel sudden."
research_refs:
  - https://hearinghealthmatters.org/pathways-society/2015/unmasking-auditory-temporal-masking/
  - https://librosa.org/doc/main/generated/librosa.onset.onset_detect.html
  - https://musicinformationretrieval.com/content/4_rhythm_tempo_beat/onset_detection.html
  - https://ffmpeg.org/ffmpeg-filters.html#astats
  - https://www.ableton.com/en/blog/learn-how-to-make-high-impact-sounds-for-movies-and-trailers/
difficulty: medium
detectable_from: audio
---

# Put the sound's loudest peak on the cut frame, not the file's first frame

## What it is
A sound effect is not a rectangle. Almost every library file has **pre-roll** — a swell, an air movement, a reverse tail, a fraction of a second of near-silence — before its loudest moment. Drag the file so its *start* lands on the cut and the accent arrives late by exactly that pre-roll, typically 2–15 frames, which is precisely the band where the ear stops binding sound to picture and starts hearing them as two events. The rule is therefore stated on the **peak**: find the loudest sample in the file, and put *that* on the cut frame. Everything before the peak plays over the outgoing shot, where it functions as anticipation; everything after plays over the incoming shot, where it functions as a tail. The same measurement, used in the other direction, is what makes a **music stop** sound smooth rather than sudden: land the out-point on a transient and the transient masks the truncation — forward (post-) masking is strongest for about **50 ms** and still measurable to **200 ms** after a loud event, which comfortably covers a 2–6 frame gain ramp.

**Style.** Filed `sfx/motion` — the accent exists because the frame changed. An aesthetic hit or riser landing on the same frame uses the identical peak arithmetic, timed from its own peak rather than its file start ([[sfx-riser-hit-pair]]).

## When to use it
Every time a sound is placed *because of* a cut: a whoosh on a transition, a hit on a title card or a reveal, an impact on a smash cut, a riser resolving on a drop, a click on a graphic snapping into place. Also whenever a sound is placed because of a **visual event** inside a shot — a punch-in, a text slam, a logo landing — where the "cut frame" is simply the frame the visual event happens on. And in reverse, whenever a **bed stops**: measure the bed's transients and stop on one. The one case where the rule does not apply is a sound with no meaningful peak — a drone, a tone, an ambience bed — which is placed by its onset and level, not by an anchor frame.

## How to recognise it in a reference video
- **Get the cut frames, then get the peak frames, then subtract.**
  ```bash
  # picture cuts
  ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd
  # per-frame PEAK level (n=1600 @48kHz = exactly one frame @30fps)
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
  ```
  A placed SFX shows as a local maximum in the peak trace rising **≥8 dB** above the surrounding 10 frames.
- **The offset is the finding.** `offset = sfx_peak_frame − cut_frame`. Well-placed accents sit at **0 f**, with a working tolerance of **−1 to +1 f**. A reference sitting consistently at **+3 to +8 f** has been placed by file start and is a defect worth logging, not a style.
- **Look for pre-roll on the outgoing shot.** Play the 10 frames before the cut. A correctly-anchored whoosh or riser is already audible there and rising. If the sound begins exactly at the cut, its peak is late by definition.
- **Distinguish the two families.** A *transient* effect (hit, click, impact) has almost no pre-roll and a long tail: the peak is within 1–2 frames of the file start. A *swept* effect (whoosh, riser, swell) has 6–30 frames of pre-roll before the peak. Log which family the reference uses at each boundary — it changes the authoring route entirely.
- **Tail behaviour.** Measure frames from the peak to −20 dB. Hits and impacts run **15–75 f (0.5–2.5 s)** of tail over the incoming shot; whooshes run **3–12 f**. A hit whose tail is cut off at the shot boundary is a truncation, audible as a click.
- **Music out-points.** For a bed that stops, check whether the last audible music sample coincides with a transient in the bed itself (a kick, a crash, a phrase end). Trace the bed's low band — `lowpass=f=160` plus the same per-frame peak print — and check the stop frame against the detected onsets. On-grid stops are designed; off-grid stops are truncations.
- **Sanity check against the sync window.** Sound placed **late** by 3–8 f is heard as sloppy well before it is heard as wrong; sound placed **early** is detectable much sooner. The house numbers in this vault are `sync_offset` +1 f, `max_lag` +3 f, `max_lead` −1 f, with a **forbidden band at −5 to −2 f** ([[sfx-av-sync-binding-window]]). The peak anchor is what keeps you out of that band automatically.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `anchor` | peak on the cut frame (0 f) | −1 to +1 f | The rule. Frames at 30 fps. |
| `pre_roll` | measured per file | 0–30 f | Peak time minus file start. This is the number the whole note is about — measure it, never assume it. |
| `max_untrimmed_pre_roll` | 2 f | 0–2 f | If the pre-roll exceeds this and you are *not* using it as anticipation, trim it with `data-media-start` rather than sliding the clip. |
| `tail_over_incoming` | 30 f (1.0 s) | 15–75 f (hits) · 3–12 f (whooshes) | Frames from the peak to −20 dB. |
| `music_stop_ramp` | 4 f (0.13 s) | 2–6 f | Covered by the 150–200 ms post-masking of the transient you stop on. |
| `masking_window_post` | 50 ms | up to 200 ms | Forward masking is strongest to ~50 ms and measurable to ~200 ms; a 10 dB louder masker buys about 3 dB more masking. |
| `masking_window_pre` | 20 ms | up to ~25 ms, gone by 100 ms | Backward masking is much shorter — you cannot hide a ramp *before* a transient the way you can after it. |
| `peak_search_window` | whole file | — | Use the true amplitude maximum, not the first onset, unless the file has several equal peaks — then use the first. |
| `level` | −13 dB | −12 to −15 dB | SFX layer. Hits and impacts may sit 2–4 dB above. |
| `music_duck_on_accent` | −4 dB | −3 to −6 dB | Quick dip under the accent, fast recovery. |
| `variants` | 4 in rotation | 3–8 | No file repeats within 3 uses; vary by reverb, pitch or duration. |

## Reproduction prompt

```
Place sound effect {{SFX_FILE}} so its loudest peak lands exactly on the
cut at {{CUT}} (seconds in the composition, 30fps project).

1. MEASURE THE FILE. Find the time of the maximum absolute sample in
   {{SFX_FILE}}, in seconds from the file start. Call it PEAK_T. Do not
   estimate it from the filename or from listening - measure it. Also
   measure TAIL_T, the time from PEAK_T until the level has fallen 20 dB.
2. CLASSIFY. If PEAK_T <= 0.07s (2 frames) the file is a TRANSIENT type.
   If PEAK_T > 0.07s it is a SWEPT type with pre-roll.
3. PLACE:
   - TRANSIENT: data-start = {{CUT}} - PEAK_T. Keep data-media-start at 0.
   - SWEPT, using the pre-roll as anticipation (whoosh, riser - the normal
     case): data-start = {{CUT}} - PEAK_T, data-media-start = 0. The
     pre-roll now plays over the outgoing shot, which is what you want.
   - SWEPT, where the pre-roll must not be heard: set data-media-start =
     PEAK_T - 0.033 and data-start = {{CUT}} - 0.033, so exactly one frame
     of attack precedes the peak.
4. SET data-duration so the tail is allowed to run TAIL_T past {{CUT}},
   then ramp the last 4 frames to zero with a volume automation lane so
   the clip cannot end on a non-zero sample.
5. LEVEL at -13 dB relative to dialogue (hits may sit 2-4 dB louder), and
   dip any music bed by 4 dB across the accent, recovering within 12
   frames.
6. VERIFY THE OFFSET by measuring the finished mix, not by trusting the
   arithmetic: the frame of the local peak in the rendered audio must
   equal the frame of the picture cut, within 1 frame.
7. ACCEPTANCE TEST: (a) step to {{CUT}} - the picture change and the
   loudest moment of the sound happen on the same frame; (b) play the 10
   frames before {{CUT}} - for a swept effect you should already hear it
   building; (c) play the 30 frames after - the tail decays, it is not
   truncated; (d) the accent never arrives more than 1 frame LATE, which
   is the failure this rule exists to prevent.
```

## Execution spec

**Measuring the peak — three routes, pick by what is installed.**

```bash
# 1. ffmpeg only: per-frame peak print, then read off the maximum
ffmpeg -i sfx.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null

# 2. ffmpeg, whole-file summary (gives Peak level and its sample position context)
ffmpeg -i sfx.wav -af "astats=measure_overall=Peak_level+Max_difference" -f null -

# 3. python/librosa: exact peak time, plus onsets if you need the grid
python3 - <<'PY'
import librosa, numpy as np
y, sr = librosa.load("sfx.wav", sr=None, mono=True)
peak_t = float(np.argmax(np.abs(y))) / sr
onsets = librosa.onset.onset_detect(y=y, sr=sr, units="time")
print(f"PEAK_T={peak_t:.3f}s  frame@30={round(peak_t*30)}  onsets={onsets[:8]}")
PY
```
`librosa.onset.onset_detect(y=..., sr=..., units='time')` returns onset times in seconds and is the right tool for finding a **music bed's** transients (the out-point case); `np.argmax(np.abs(y))` is the right tool for a **single SFX file's** anchor. Neither `librosa` nor `numpy` is verified installed here — the ffmpeg route always works, and `parakeet-mlx`-style Apple-silicon paths are unavailable on this ARM64 host.

**HyperFrames — the placement.** All times in **seconds**; frames are a comment. A hit with `PEAK_T = 0.18` landing on a cut at `21.40`:

```html
<audio id="sfx-hit-01" src="assets/sfx/cinematic_hit.wav"
       data-audio-group="sfx"
       data-start="21.22"          <!-- 21.40 - 0.18 : the peak lands on the cut -->
       data-duration="2.40"
       data-media-start="0"
       data-track-index="12"
       data-volume="0.22"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:2.27,&quot;v&quot;:1},{&quot;t&quot;:2.40,&quot;v&quot;:0}]}]}"></audio>
```
The trim variant, when the pre-roll must not be heard: `data-media-start="0.147"` and `data-start="21.367"` (one frame of attack, 0.033 s, before the cut).

Contract facts that decide whether this runs:
- **Every `<audio>` needs an `id`.** An id-less audio element is never mixed → **silent render**, with no warning.
- The lane's `t` is **clip-local seconds** and **holds its first value backwards to the clip start and its last value forward to the end**, so the `{t:0,v:1}` point is required or the whole clip inherits the ramp.
- **Do not also GSAP-tween `volume`** on this element: `audio_volume_double_automation` — the lane wins, the tween is silently ignored. And an authored `data-volume` on a track whose `volume` is tweened is *replaced*, not scaled (`audio_volume_tween_overrides_gain`).
- Write the JSON attributes **double-quoted with `&quot;`**; `carve.mjs` finds them with a `name="..."` regex and cannot see a single-quoted attribute, so a carve run would silently overwrite them.
- Give SFX their **own group** (`sfx`), never the `voiceover` carve group — a non-voice clip inside the carve group poisons the next re-analysis silently.
- Overlapping audio sharing a `data-track-index` raises `duplicate_audio_track`; use 12, 13, 14 for stacked accents.
- **There is no audio-follows-animation attribute.** Coupling a sound to a *visual* event is the author writing the same number twice: the tween's timeline position and the audio's `data-start`. If the visual lives in a sub-composition at scene-local `t`, the root-level audio needs `data-start = t + slot data-start`.

**The inverse case — stopping a bed on a transient.** Same measurement, opposite use: detect the bed's onsets, pick the one nearest your intended stop, and ramp the `volume` lane to 0 over 2–6 frames **starting on that onset**, so the transient masks the ramp. The editorial questions — when to stop, how long the silence runs, how the bed returns — belong to [[sfx-music-hard-stop]] and [[sfx-music-rest-windows]]; this note only owns finding the frame.

**Epidemic Sound.** Fetch, then measure — never assume a library file's peak position. `SearchSoundEffects { query.term: "cinematic hit impact", filter.duration { max: 4000 } }` for transients, `{ query.term: "whoosh transition fast" }` for swept effects. `SearchSimilarToSoundEffect` builds the variant rotation that keeps one file from repeating within three uses. Download to `assets/sfx/` inside the project so the compiler and render can reach it.

**Remotion:** an `<Audio>` with a negative `startFrom` offset computed from the measured peak; not present in this project.

## Pairs with
[[sfx-av-sync-binding-window]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-music-hard-stop]] · [[sfx-music-rest-windows]] · [[sfx-unsounded-motion-audit]] · [[sfx-placement-discipline]] · [[motion-waveform-teaching-overlay]] · [[pace-cut-on-the-beat]]

## Failure modes
- **Aligning the file start to the cut.** The single defect this rule exists to prevent: the accent lands 2–15 frames late, the cut feels unsupported, and the sound reads as an afterthought. Fix: subtract the measured `PEAK_T` from the cut time.
- **Guessing the pre-roll.** Library files vary wildly, including between variants in the same pack. Fix: measure every file, once, and record `PEAK_T` alongside it.
- **Over-correcting into the forbidden band.** Sliding a sound 2–5 frames early to "make sure" puts it in the uncanny window — too early to be physical, too late to be anticipation. Fix: 0 f, tolerance ±1 f. If you want anticipation, go to −12 f or beyond and use a swept effect.
- **Truncating the tail.** Setting `data-duration` to the cut-to-cut length chops a decaying hit and clicks. Fix: let the tail run over the incoming shot and ramp the last 4 frames to zero.
- **Trimming away the anticipation.** Cutting a whoosh's pre-roll off with `data-media-start` and then wondering why the transition feels unmotivated. Fix: for swept effects, keep the pre-roll and let it play over the outgoing shot.
- **Stopping a bed mid-sustain.** No transient to hide behind; the drop-out is heard as a fault. Fix: detect onsets and stop on one.
- **Reverb tails and clip length.** Effects with a tail make the rendered track longer than its `data-duration` (`chainTailSeconds`) — expected, not a bug, but do not then also extend the clip or the tail doubles.
- **Known gap:** nothing in this stack finds a peak for you, and nothing validates that a placed accent actually lands on its cut. The measurement is a manual ffmpeg/librosa step and the verification is a render-and-measure loop. Record `PEAK_T` per asset in the design document so it is measured once, not once per placement.
