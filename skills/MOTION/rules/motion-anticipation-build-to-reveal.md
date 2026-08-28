---
id: motion-anticipation-build-to-reveal
title: Build the picture under the riser, and resolve everything on the reveal frame
skill: motion
type: motion
family: riser
tags: [skill/motion, type/motion, family/riser, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/sfx-kt-1, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:02:06"
    quote: "Riser sounds are essential to build anticipation and tension. Before a jumpscare, before a big reveal, or before a drop in the music, a riser teases that something big is about to happen."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:11:17"
    quote: "Risers - build tension and anticipation; signal that something important is about to happen; only use when something important actually is, or they lose credibility."
research_refs:
  - https://www.epidemicsound.com/sound-effects/categories/designed/riser/
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://ffmpeg.org/ffmpeg-filters.html#ebur128
  - https://www.w3.org/WAI/WCAG22/Understanding/three-flashes-or-below-threshold.html
difficulty: high
detectable_from: transcript+video
---

# Build the picture under the riser, and resolve everything on the reveal frame

## What it is
A riser is a promise with a deadline, and the picture has to keep the same promise. This note is the **visual half** of the riser: a 2–5 second window in which one or more properties move monotonically in one direction with an *accelerating* curve — a slow push-in that speeds up, a blur that thickens, a vignette that closes, layers that accumulate, cuts that shorten — and then **resolve simultaneously on a single nominated frame**, where the reveal lands and the impact hits. The sound side (which riser, at what level, how it relates to the bed) lives in [[sfx-riser-anticipation-build]] and [[sfx-riser-to-music-drop-backtiming]]; what this note adds is the property track, the acceleration curve, the back-timing arithmetic, and the resolution frame.

The three canonical slots are the ones the source names: **before a jumpscare, before a big reveal, before a drop in the music.** All three share one structure — build, deadline, payoff. If nothing arrives at the deadline, the riser is a broken promise and every subsequent riser in the video is discounted.

## When to use it
- **A big reveal**: the final result, the number, the transformation, the thing the video promised in its hook.
- **A music drop**, where a section changes and the bed's energy steps up — the build hands off to the beat.
- **A jumpscare or shock cut** in a horror/story register.
- **A section boundary that carries real weight** — the top of the payoff half of a video.

At most **2–3 per video**. The source's rule is the operative one: use a riser only when something big actually follows, *"or they lose credibility."* And never in an intimacy register ([[motion-format-promise-motion-budget]]) — a build is by definition a manipulation the viewer can feel.

## How to recognise it in a reference video
- **Find the loudness ramp first; it is the easiest signal to detect.** Momentary loudness rising monotonically for 2–5 s and then stepping is a riser:
  ```bash
  ffmpeg -i ref.mp4 -af "ebur128=metadata=1,ametadata=print:key=lavfi.r128.M" -f null - 2>&1 \
    | grep -o "lavfi.r128.M=.*" | tail -400
  ```
  Then note the frame of the largest step — that is the deadline.
- **Check that at least one visual property moves monotonically across the same window.** Measure per-second: frame scale (track two fixed features), mean blur (variance of Laplacian), mean luma, vignette strength, element count. A riser under a *static* picture is a defect worth logging: the audio promises, the picture does not.
- **Check the curve shape, not just the direction.** Sample the property at 25/50/75% of the build. **Back-loaded** (little movement early, most in the last third) is the correct accelerating build. Front-loaded is an ease-out and reads as a settle, which contradicts the sound.
- **Measure the build duration.** Real riser assets run **2.8–5.4 s** in the designed-riser library; builds shorter than ~1.5 s do not read as builds, and longer than ~6 s exhaust the viewer.
- **Frame-step the deadline.** The tell of competent work: **several properties resolve on the same frame** — blur to 0, scale snaps, a cut lands, the impact transient peaks. Properties resolving on different frames within 3–6 frames of each other is the amateur signature.
- **Check the tail.** Does the riser stop at the reveal, or ring past it? Convention is that the riser's own peak lands on the reveal frame and its tail is trimmed or masked by the impact; a riser audibly continuing 0.5 s past the reveal reads as a missed edit.
- **Confirm something actually arrives.** If the loudness step lands on an ordinary cut with no new information, log it as a broken promise, not as a technique.
- **Check for a flash.** Many builds resolve with a 1–2 frame white frame. Count luminance flips per second across the section — no more than three.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `build_duration` | 3.0 s | 1.5–6.0 s | Set from the chosen riser asset's length; real designed risers run 2.8–5.4 s. |
| `reveal_frame` | — | — | The deadline, in composition seconds. Everything back-times from it. |
| `build_curve` | `power2.in` | `power1.in` · `power2.in` · `expo.in` · `none` | Must accelerate. `expo.in` for the most aggressive; `none` for a mechanical, machine-like build. **Never** a `.out` curve. |
| `push_scale` | 1.0 → 1.08 | 1.03–1.15 | On the whole frame or on the hero element. Needs overscan if the frame moves. |
| `blur_build` | 0 → 6 px | 0–12 px | Calm/medium/high bands from the transition catalog: calm 20–30 px over 0.8–1.2 s, medium 8–15 px over 0.4–0.6 s, high 3–6 px over 0.2–0.3 s — a build sits at the low end for longer. |
| `vignette_build` | 0 → 0.35 alpha | 0–0.5 | Closes inward; strongest single contributor to "something is coming". |
| `desaturate_build` | 1.0 → 0.85 | 0.75–1.0 | Draining colour before it returns at the reveal is a cheap, effective build. |
| `layer_accumulation` | 0 → 3 elements | 0–5 | Arriving every `build_duration / n`, each 0.2 s `power3.out`. |
| `resolve_window` | 0 f | 0–1 f | All properties resolve on the same frame. Two frames of slop is the maximum. |
| `riser_align` | peak on `reveal_frame` | −1 to 0 f | Align the riser's **peak**, then trim its tail with `data-duration`. |
| `impact_align` | 0 f | −1 to +1 f | Impact transient peak on `reveal_frame`. Audio leading is detectable from ~45 ms; lagging tolerated to ~125 ms. |
| `payoff_hold` | 1.5 s | 1.0–4.0 s | The reveal must be allowed to land before the next cut. |
| `count_per_video` | 2 | 1–3 | Above 3 the device is spent. |
| `flash_ceiling` | 3/s | — | WCAG 2.3.1, if the resolve includes a flash frame. |

## Reproduction prompt

```
Build to the reveal at {{REVEAL}} over {{BUILD}} seconds (default 3.0).

BACK-TIME EVERYTHING. Set T0 = {{REVEAL}} - {{BUILD}}.

1. Choose the riser first and let its length set {{BUILD}}. Find the offset
   from the riser file's start to its loudest point; place the audio clip so
   that point lands exactly on {{REVEAL}}, using data-media-start to trim any
   pre-roll, and set data-duration so the tail stops at or just past
   {{REVEAL}} rather than ringing past it.
2. From T0 to {{REVEAL}}, move at least TWO properties monotonically with an
   ACCELERATING ease (power2.in, or expo.in for the hardest build):
     - frame or hero scale 1.0 -> 1.08
     - blur 0 -> 6px on a non-clip wrapper
     - vignette overlay alpha 0 -> 0.35
     - optional saturation 1.0 -> 0.85
   Never use a .out curve here; it reads as a settle and fights the sound.
3. Optionally accumulate up to 3 elements arriving at even intervals across
   the build, each entering over 0.2s power3.out.
4. RESOLVE ON ONE FRAME. At {{REVEAL}}: blur to 0, vignette to 0, saturation
   to 1, scale snapped to its new resting value - all with duration 0 (a
   tl.set) or a tween of at most 2 frames. Place the impact transient's peak
   on {{REVEAL}}. Optionally add one frame-shake kick.
5. HOLD the payoff at least 1.5s before the next cut.

ACCEPTANCE TEST: sample the build property at T0, T0+25%, T0+50%, T0+75% - the
values must be back-loaded, not linear or front-loaded. Then step
{{REVEAL}}-2f..{{REVEAL}}+2f: every built property must be resolved on the
same frame, and the audio transient must sit within one frame of it. Finally
confirm something new is actually on screen at {{REVEAL}}; if not, delete the
whole build.
```

## Execution spec

**HyperFrames.** The build is ordinary GSAP on the paused timeline; the discipline is entirely in the back-timing and the single resolve frame.

```js
const REVEAL = 214.0, BUILD = 3.0, T0 = REVEAL - BUILD;

// two accelerating property tracks on non-clip wrappers
tl.fromTo("#stage-cam", { scale: 1 },
  { scale: 1.08, duration: BUILD, ease: "power2.in" }, T0);
tl.fromTo("#stage-fx", { filter: "blur(0px) saturate(1)" },
  { filter: "blur(6px) saturate(0.85)", duration: BUILD, ease: "power2.in" }, T0);
tl.fromTo("#vignette", { autoAlpha: 0 },
  { autoAlpha: 0.35, duration: BUILD, ease: "power2.in" }, T0);

// three accumulating layers, evenly spaced across the build
[0, 1, 2].forEach(i => {
  tl.fromTo(`#build-layer-${i}`, { autoAlpha: 0, y: 16 },
    { autoAlpha: 1, y: 0, duration: 0.2, ease: "power3.out" }, T0 + (i + 1) * BUILD / 4);
});

// the resolve: one frame, everything at once
tl.set("#stage-fx", { filter: "blur(0px) saturate(1)" }, REVEAL);
tl.set("#vignette", { autoAlpha: 0 }, REVEAL);
tl.set("#stage-cam", { scale: 1.0 }, REVEAL);
tl.set(["#build-layer-0", "#build-layer-1", "#build-layer-2"], { autoAlpha: 0 }, REVEAL);
```

```html
<!-- riser: peak back-timed onto REVEAL, tail trimmed so it does not ring past it -->
<audio id="sfx-riser" src="assets/sfx/riser-build-suspense.wav" data-audio-group="sfx"
       data-start="211.0" data-duration="3.1" data-media-start="0.35"
       data-track-index="12" data-volume="0.4"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.5},{&quot;t&quot;:2.9,&quot;v&quot;:1},{&quot;t&quot;:3.1,&quot;v&quot;:0}]}]}"></audio>
<audio id="sfx-impact" src="assets/sfx/impact-low-boom.wav" data-audio-group="sfx"
       data-start="214.0" data-duration="2.4" data-media-start="0.02"
       data-track-index="13" data-volume="0.45"></audio>
```

Contract points that bind this:
- **`fromTo`, never `from`.** `from()` writes its start state at construction, before the clip's window opens; under the render's non-linear seek the build starts wrong or flashes.
- **Accelerating easing is legal and named:** `power1/2/3/4.in`, `expo.in`, and `none` for mechanical. The house doctrine's *"smooth beats bouncy"* applies to entrances; a build is not an entrance and wants an `.in` curve.
- **`filter` is lint-clean on the master timeline**, as are `scaleX` and `transformOrigin`. Animate `filter` on a **non-clip** wrapper.
- **`autoAlpha` only on non-clip elements.** Never tween `display` or raw `visibility` on a clip; the framework owns clip visibility.
- **Overscan if the whole frame pushes in.** A `scale` above 1 needs no overscan; a push that also translates does. See [[motion-camera-shake-impact]] for the wrapper pattern.
- **Two audio tracks, two track indices.** The riser and the impact overlap in time; sharing a `data-track-index` raises `duplicate_audio_track`.
- **Every `<audio>` needs an `id`** — without one it is never mixed and the render is silent.
- **Automation lane `t` is clip-local**, and *"a lane holds its first value backwards to the start of its clip"* — so the riser's own swell is authored from `t: 0`, not from composition time.
- **Bed relationship:** if music is playing under the build, do not duck it — carve it against the voice group (`data-fx-carve`, `strength` default 0.25) and let the riser sit above. A riser fighting an unducked bed is the most common reason a build does not read.
- **Sub-comp boundary:** if the reveal lives inside a sub-composition, the riser at the host root needs `data-start = scene-local reveal time + slot data-start`. There is no audio-follows-animation attribute — the coupling is the author writing the same number twice.
- Named rules that may be cited, not quoted: `multi-phase-camera`, `depth-of-field-blur`, `ambient-glow-bloom`, `coordinate-target-zoom`, `kinetic-beat-slam`, `particle-burst`.

**ffmpeg — finding the drop, since nothing in this stack detects it.** The contract is explicit: *"HyperFrames does not provide automatic waveform sync or drift correction."* So locate the drop offline and bake the number:

```bash
# momentary loudness every 100ms; the largest positive step is the drop
ffmpeg -i bed.mp3 -af "ebur128=metadata=1,ametadata=print:key=lavfi.r128.M" -f null - 2>&1 \
  | awk -F= '/r128.M/ {print prev_t, $2} /pts_time/ {prev_t=$2}' > loudness.txt

# find the riser file's own peak, to compute data-media-start
ffmpeg -i riser.wav -af "astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.Peak_level" -f null -

# derive a beat grid instead, when the drop must land on a musical boundary
#   beat interval = 60 / BPM ; at 110 BPM a 4-bar phrase is 8.727s
```

**Epidemic Sound.** Verified against the live catalogue:
```
SearchSoundEffects { query: { term: "riser build up suspense" },
  filter: { tagSlugs: { matchType: "ANY", values: ["designed--riser"] },
            duration: { min: 2000, max: 6000 } } }
```
Real results: "Riser, Short, Fast, Build Up, Suspenseful" **2860 ms**, "Riser, Short, Build Up, Horror, Mysterious, Suspense" **4615 ms**, "Riser, Long Rise, Braam, Epic Build Up" **4367 ms**, up to **5439 ms**. Pick the asset *first* and let its length set `build_duration` — stretching a riser to fit a chosen build is the wrong way round. Pair with `designed--boom` for the impact (real durations 2.8–3.5 s).

**Remotion:** `interpolate()` with a cubic-in easing across the build frames and a hard switch at the reveal frame — conceptually identical. Remotion is not a runtime here.

## Pairs with
[[sfx-riser-anticipation-build]] · [[sfx-riser-to-music-drop-backtiming]] · [[motion-camera-shake-impact]] · [[sfx-cinematic-hit-emphasis]] · [[pace-cross-cut-acceleration]] · [[sfx-music-hard-stop]] · [[motion-colour-dip-transition]] · [[motion-format-promise-motion-budget]]

## Failure modes
- **Riser with a static picture.** The sound promises and the picture does not; the reveal then feels smaller than the build implied. Correction: at least two monotonic property tracks across the same window.
- **Decelerating curve.** A `.out` ease on the build makes the picture settle while the sound rises — the two read as unrelated. Correction: `power2.in` or `expo.in`.
- **Properties resolving on different frames.** Blur clearing three frames after the cut is instantly visible as sloppiness. Correction: one `tl.set` block at the reveal frame.
- **Riser file start aligned instead of its peak.** Puts the climax 1–4 frames off the reveal. Correction: measure the peak, back-time with `data-media-start`.
- **Riser ringing past the reveal.** Correction: trim with `data-duration` and a volume lane that closes at the reveal.
- **Nothing arrives.** The single worst failure, because it costs credibility on every later riser too. Correction: if the payoff is not genuinely new information, delete the build.
- **Payoff cut short.** A 0.5 s hold after a 3 s build wastes the whole device. Correction: ≥1.5 s.
- **Build over an unducked bed.** The riser and the bed occupy the same range and neither reads. Correction: carve the bed against the voiceover group at `strength` 0.25, and let the riser be the loudest thing in the build.
- **Too many.** Three builds in two minutes and none of them mean anything. Correction: 2 per video, at real structural peaks.
- **Known gap:** the stack cannot detect a drop, a beat grid, or a riser's peak — all three are offline measurements baked into the composition as constants. Record the measured numbers (drop timecode, riser peak offset, BPM) in the design document, because nothing downstream can re-derive them, and a later change to the music invalidates the whole back-timing silently.
