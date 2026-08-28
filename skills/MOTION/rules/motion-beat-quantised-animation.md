---
id: motion-beat-quantised-animation
title: Quantise motion to the beat grid — land the resolve on the beat, not the start
skill: motion
type: motion
family: music-sync
tags: [skill/motion, type/motion, family/music-sync, layer/music, engine/hyperframes, engine/ffmpeg, engine/epidemic, engine/remotion, source/editing-kt-3, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:45"
    quote: "I even try to make sure every single cut in my video is synced to some beat of the music."
research_refs:
  - https://librosa.org/doc/main/generated/librosa.beat.beat_track.html
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://gsap.com/resources/getting-started/Staggers/
  - https://www.nngroup.com/articles/animation-duration/
  - https://aubio.org/manual/latest/cli.html
difficulty: high
detectable_from: transcript+video
---

# Quantise motion to the beat grid — land the resolve on the beat, not the start

## What it is
The motion-side companion to on-beat cutting. Once a beat grid exists — a tempo and an anchor frame ([[pace-beat-grid-extraction]]) — it becomes the ruler for **animation**, not just for cuts: entrances, reveals, counters, transitions and stagger intervals are all snapped to it. The claim in the source is about cuts, but a cut and a graphic entrance are the same event to the viewer's eye, and an on-beat cut sitting next to an off-beat card entrance is worse than neither being locked, because the mismatch is audible.

The rule that makes this work, and the one almost everyone gets wrong: **quantise the frame the motion RESOLVES, not the frame it starts.** A cut is instantaneous, so start and resolve are the same frame; an animation is not. An entrance authored to *begin* on the beat arrives one full entrance-duration late — 0.30–0.40 s, i.e. **9–12 frames at 30 fps**, which is two to three times the ITU-R BT.1359 detectability threshold for audio lag (125 ms) and roughly eight times ATSC's acceptability limit (45 ms). It reads as sloppy without the viewer being able to say why. The correct placement is `t_start = t_beat − duration`.

## When to use it
- Any section that has a music bed with an audible pulse and contains authored motion.
- **Montage and B-roll sequences** first — that is where it is most visible and where the source explicitly applies it.
- **Multi-item builds**: the stagger interval should be a musical subdivision, not an arbitrary 0.06 s.
- Do **not** let the grid override a **word**. When a graphic exists to make a spoken keyword land, the keyword wins: if the keyword onset and the nearest beat are more than 0.20 s apart, quantise to the word and leave the beat alone ([[motion-progressive-information-build]]).
- Do not apply it under narration with no bed, or in a section where the music has been deliberately killed.

### The arithmetic

`frames_per_beat = (60 / BPM) × fps`. At 30 fps that is `1800 / BPM`.

| BPM | f/beat @24 | f/beat @30 | f/beat @60 | 1/2 beat @30 | 1/4 beat @30 |
|---|---|---|---|---|---|
| 80 | 18.00 | 22.50 | 45.00 | 11.25 | 5.63 |
| 90 | 16.00 | **20.00** | 40.00 | **10.00** | **5.00** |
| 100 | 14.40 | **18.00** | 36.00 | **9.00** | 4.50 |
| 110 | 13.09 | 16.36 | 32.73 | 8.18 | 4.09 |
| 120 | **12.00** | **15.00** | **30.00** | 7.50 | 3.75 |
| 128 | 11.25 | 14.06 | 28.13 | 7.03 | 3.52 |
| 140 | 10.29 | 12.86 | 25.71 | 6.43 | 3.21 |
| 150 | 9.60 | **12.00** | 24.00 | 6.00 | **3.00** |
| 160 | 9.00 | 11.25 | 22.50 | 5.63 | 2.81 |

Two consequences worth designing around. First, at 30 fps only **90, 100, 120 and 150 BPM** give whole-frame beats — and the creator's stated personal default of **100–120 BPM** sits exactly inside that clean band. Second, 90 BPM is the only common tempo that stays whole-frame all the way down to the **quarter beat** (5 f), which makes it the friendliest tempo for staggered builds. At 120 BPM the quarter beat is 3.75 f and any 1/4-beat stagger will drift; use half beats (7.5 f → alternate 7 and 8) or `amount` rather than `each`.

## How to recognise it in a reference video
- **Extract the grid from the reference's own bed**, then extract the motion landings and compare. `librosa.beat.beat_track(y, sr, units='time')` returns tempo plus beat times in seconds; convert to frames with `round(t × fps)`.
- **Landings, not starts.** For each motion event, find the frame where the element reaches its rest pose (the first frame where the per-frame displacement drops below ~0.3 px) and compute `landing − nearest_beat` in frames.
- **Read the histogram.** Mean ≈ 0 with σ ≤ 2 frames means the reference quantises **landings** — the mark of a careful motion pass. Mean ≈ **+9 to +12 frames** at 30 fps means the reference quantises **starts** — extremely common, and a strong, reusable style fingerprint. A flat histogram means no beat locking at all.
- **Check the stagger interval against subdivisions.** Measure the gap between successive items in a staggered group; if it equals a half or quarter beat within a frame, the build is musically quantised.
- **Check drift lengths.** Ambient pushes that start and end on bar lines (4 beats) rather than arbitrary durations are a tell.
- **Check transitions.** A registry-style transition is quantised at its **midpoint** (the frame of the swap), not its start — so `t_start = t_beat − duration/2`. Measure the visual swap frame, not the first frame of the move.
- **Check where it stops.** Most references beat-lock montage and stop beat-locking under narration. Log which sections are locked; that boundary is part of the style.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `quantise_target` | resolve frame | resolve · swap · start | Entrances → resolve. Transitions → swap (mid). Cuts → the cut frame. |
| `entrance_offset` | `−duration` | — | `t_start = t_beat − duration`, then round to `1/fps`. |
| `transition_offset` | `−duration/2` | — | The swap lands on the beat. |
| `tolerance` | ±1 f (±33 ms) | ±0–2 f | ±2 f (66 ms) is the outer bound; ATSC's acceptability window is 15 ms lead / 45 ms lag. |
| `direction_bias` | early | early only | If rounding must break a tie, round **earlier**. Late always reads worse than early. |
| `subdivision` | 1/2 beat | 1 · 1/2 · 1/4 | Events denser than 1/4 beat stop being heard as musical. |
| `stagger_each` | one subdivision | — | e.g. 100 BPM 1/4 beat = 0.15 s. Engine cap: `items × each ≤ ~0.5 s` — beyond 3–4 items switch to `amount: one beat`. |
| `drift_length` | 1 bar (4 beats) | 1–4 bars | 100 BPM: 1 bar = 2.4 s; 4 bars = 9.6 s. |
| `downbeat_priority` | section starts | — | Section openings land on a **downbeat** (beat 1 of a bar), not merely a beat. |
| `keyword_override` | 0.20 s | 0.15–0.30 s | If the nearest beat is further than this from the keyword, follow the keyword. |
| `locked_sections` | montage + B-roll | — | Declare explicitly which sections are grid-locked. |

## Reproduction prompt

```
Quantise every authored motion event in the section {{IN}}–{{OUT}} to the
music grid, targeting the frame each motion RESOLVES.

STEP 1 - GET THE GRID. Run beat tracking on the bed used in this section:
  import librosa
  y, sr = librosa.load("bed.wav")
  tempo, beats = librosa.beat.beat_track(y=y, sr=sr, units="time")
Discard beats before the track's first strong onset (every track has a
warm-up; start from the main beat). Add the bed's own composition offset so
beat times are in COMPOSITION seconds. Write the result as a literal array
BEATS = [...] inside the composition - never analyse audio at render time.

STEP 2 - CLASSIFY EACH EVENT. For every tween in the section record its
duration and its type: ENTRANCE (resolves to a rest pose), TRANSITION (swaps
two scenes), CUT, DRIFT (ambient, no landing).

STEP 3 - PLACE.
  ENTRANCE:   t_start = nearestBeat(t_wanted) - duration
  TRANSITION: t_start = nearestBeat(t_wanted) - duration/2
  CUT:        t_cut   = nearestBeat(t_wanted)
  DRIFT:      duration = a whole number of bars (4 beats each); start on a
              downbeat.
Round every result to the frame grid: t = Math.round(t * FPS) / FPS. When
rounding is ambiguous, round DOWN (earlier).

STEP 4 - STAGGER MUSICALLY. Set stagger.each to one subdivision
(60/BPM/2 for half beats, /4 for quarters). If items * each > 0.5s, switch to
stagger { amount: 60/BPM } so the whole group arrives inside one beat, and
keep from:"start" ordered by importance.

STEP 5 - RESPECT THE WORD. For any event that exists to land a spoken
keyword, compare the keyword onset with the chosen beat. If they differ by
more than 0.20s, discard the beat and use the keyword.

ACCEPTANCE TEST: render, extract frames at FPS across {{IN}}-{{OUT}}, and for
each event find the first frame at which the element stops moving. Every such
frame must be within 1 frame of a BEATS entry, and none may be LATE by more
than 1 frame. Print the (landing - beat) histogram; mean must be <= 0 and
sigma <= 1.5 frames.
```

## Execution spec

**HyperFrames.** The grid is a baked constant. The contract's determinism bans make any render-time analysis illegal: no network, no clocks, and audio-reactive work must be a **pre-baked** curve that is a function of `tl.time()`, never `audio.currentTime`.

```js
const FPS = 30;
const BPM = 100;                     // 18.00 frames per beat at 30fps - whole-frame
const B0  = 4.20;                    // composition seconds of the first main beat
const beat = 60 / BPM;               // 0.6s
const q   = (t) => Math.round(t / (1 / FPS)) / FPS;             // frame quantiser
const nearestBeat = (t) => q(B0 + Math.round((t - B0) / beat) * beat);

// ENTRANCE resolving ON the beat: start one duration early
const DUR = 0.35;
const tBeat = nearestBeat(12.5);
tl.fromTo("#card", { y: 32, autoAlpha: 0 },
                   { y: 0, autoAlpha: 1, duration: DUR, ease: "power3.out" },
          q(tBeat - DUR));

// TRANSITION whose SWAP lands on the beat
const TD = 0.40, tSwap = nearestBeat(20.0);
tl.to("#el-s2",   { scale: 2.5, opacity: 0, filter: "blur(8px)", duration: TD, ease: "power3.in" },  q(tSwap - TD / 2));
tl.fromTo("#el-s3", { scale: 0.5, opacity: 0, filter: "blur(8px)" },
                    { scale: 1, opacity: 1, filter: "blur(0px)", duration: TD, ease: "power3.out" }, q(tSwap - TD / 2));

// STAGGERED GROUP on quarter beats (100 BPM -> 0.15s each, 4 items = 0.45s <= 0.5s cap)
tl.fromTo(".chip", { y: 24, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.30, ease: "power3.out",
    stagger: { each: beat / 4, from: "start" } },
  q(nearestBeat(28.0) - 0.30));

// DRIFT over exactly 4 bars = 16 beats = 9.6s at 100 BPM
tl.fromTo("#still", { scale: 1.0 }, { scale: 1.03, duration: 16 * beat, ease: "none" },
          nearestBeat(34.0));
```

Contract points:
- **All authored time is seconds; there is no frame attribute.** Quantising to frames is therefore something you do in arithmetic (`Math.round(t*FPS)/FPS`), not something the engine does for you. Render fps comes from `npx hyperframes render --fps 24|30|60`, default 30 — **quantise against the fps you will actually render at**, and re-quantise if it changes.
- Timeline positions are absolute composition seconds (the third argument), not delays.
- In a sub-composition, positions are scene-local: global beat time − the host slot's `data-start`.
- `stagger` object keys are `each`, `amount`, `from`, `grid`, `axis`; `amount` divides a total across all items and is the right choice when the group must land inside one beat regardless of item count.
- Audio placement uses the same numbers written twice ([[motion-sfx-pass-manifest]]); a bed's own `data-media-start` shifts the whole grid, so if you trim the track's warm-up, recompute `B0`.

**ffmpeg / librosa — grid extraction.**

```bash
# isolate the bed's low end so the tracker locks to kick/snare rather than voice
ffmpeg -i bed.wav -af "lowpass=f=200" /tmp/bed.low.wav
python - <<'PY'
import librosa, json
y, sr = librosa.load("/tmp/bed.low.wav")
tempo, beats = librosa.beat.beat_track(y=y, sr=sr, units="time", trim=True)
print(float(tempo), json.dumps([round(float(b), 3) for b in beats]))
PY
# alternative CLI: aubiotrack bed.wav
```

**Epidemic Sound.** Pick the bed by tempo first ([[pace-bpm-matched-music-selection]]); when tempo is a free choice, prefer **90, 100, 120 or 150 BPM** for a 30 fps deliverable and 120 BPM for 24 fps, because those are the whole-frame tempi in the table above.

**Remotion.** Precompute the beat array at build time and place `<Sequence from={Math.round(beatSec*fps) - durFrames}>`. Concept only.

## Pairs with
[[pace-cut-on-the-beat]] · [[pace-beat-grid-extraction]] · [[pace-bpm-matched-music-selection]] · [[motion-impact-frame-quantisation]] · [[motion-progressive-information-build]] · [[motion-number-rollup-stat-reveal]] · [[motion-sfx-pass-manifest]] · [[sfx-beat-aligned-handover]] · [[pace-speech-rate-to-bpm-map]] · [[motion-bookend-transition-map]]

## Failure modes
- **Quantising the start.** Every arrival is one entrance-duration late — 9–12 frames at 30 fps, past every published sync threshold. Correction: `t_start = t_beat − duration`.
- **Quantising to seconds but not to frames.** `t = 12.4333…` lands on whichever frame the sampler hits, so the same edit is one frame off in a 24 fps render and correct at 30. Correction: `Math.round(t*FPS)/FPS`, against the fps you will render.
- **Fractional-frame subdivisions.** A 1/4-beat stagger at 120 BPM is 3.75 frames and accumulates a two-frame error over four items. Correction: half beats, or `amount`, or pick a whole-frame tempo.
- **Locking dialogue-driven graphics to the grid.** The card lands on the beat and 0.4 s after the word it illustrates. Correction: the word wins beyond a 0.20 s divergence.
- **Forgetting the bed's own offset.** The grid is computed on the file and applied to the composition without adding the bed's `data-start` (or subtracting its `data-media-start`). Everything is uniformly wrong by that offset. Correction: convert to composition time before writing `BEATS`.
- **Beat-locking everything.** Wall-to-wall quantisation over 10 minutes is metronomic and stops meaning anything. Correction: declare locked sections; leave narration sections free.
- **Analysing audio at render time.** Banned by the determinism rules and non-reproducible. Correction: bake the array into the composition.
