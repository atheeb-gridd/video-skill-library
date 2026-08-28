---
id: motion-whoosh-bound-entrance-and-traverse
title: Whoosh-bound motion — title entrances and objects crossing frame, and where the air actually goes
skill: motion
type: motion
family: motion-sfx
tags: [skill/motion, type/motion, family/motion-sfx, sfx/motion, layer/sfx, engine/hyperframes, engine/epidemic, engine/ffmpeg, engine/remotion, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:01:11"
    quote: "Whether it's a title animation or an object moving across the screen, the whoosh is what you'll use."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:01:07"
    quote: "This sound effect is perfect for fast transitions, movements and dynamic reveals."
research_refs:
  - https://gsap.com/docs/v3/Eases/
  - https://en.wikipedia.org/wiki/Motion_blur
  - https://en.wikipedia.org/wiki/Shutter_speed
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: transcript+video
---

# Whoosh-bound motion — title entrances and objects crossing frame, and where the air actually goes

## What it is
The source names two specific placements for the whoosh — **a title animating on** and **an object moving across the screen** — and this note is the motion spec for both, plus the arithmetic that decides where in the file the whoosh's loudest moment has to sit. The two archetypes look similar and are timed completely differently:

- **Archetype A — entrance.** A title or graphic travels a short distance and *stops*. It decelerates into rest on an out-ease, so its velocity peak is at the **very beginning**, and the whoosh's loudest moment belongs there — not in the middle.
- **Archetype B — traverse.** An object crosses the whole frame and leaves. Velocity is roughly constant, so the peak belongs at the **frame-centre crossing**, and the motion needs a streak because at these speeds real footage would blur and a graphic will not.

[[sfx-envelope-matched-to-easing-curve]] gives the general envelope-matching rule for any invented motion, and [[sfx-whoosh-transition-movement-reveal]] gives the whoosh anchored to a cut. This note gives the two motion archetypes themselves — their travel, duration, ease and blur — plus the **in-point derivation**: the whoosh's file offset, measured rather than guessed, so that its peak coincides with the motion's peak instead of its start.

## When to use it
- **Every title, lower third, headline, badge, stat card or logo that animates on.** The brain expects a sound when it sees motion; without one, the change is hollow. This is the default treatment, not an accent.
- **Every graphic, icon, arrow, cutout or object that translates across the frame** — including a full-frame element flying through as a transition device.
- **Any element that travels more than about 8% of frame width.** Below that, the move belongs to the silent tier ([[motion-silent-motion-tier]]) and a whoosh on it is noise.
- **Not** on a staggered group of siblings. Five cards arriving on a 0.06 s stagger take **one** whoosh, not five — the arrival is a single beat.
- **Not** on ambient motion. A drifting still ([[motion-still-image-drift]]) or a slow camera move gets air at most, not a whoosh ([[sfx-camera-move-air-accent]]).
- **Not** on a real physical action. A hand picking up a phone wants the phone's real sound; the whoosh licence covers invented motion ([[sfx-diegetic-action-inventory]]).

## How to recognise it in a reference video
**Separate the archetypes first — the per-frame displacement profile does it unambiguously.** Extract the event at 30 fps and measure the element's position each frame.

- **Archetype A (entrance):** displacement is **front-loaded and decaying** — the biggest step is between frames 1 and 2, and the element is at rest by the end. Total travel typically **5–15% of frame width**; total duration **9–14 frames**.
- **Archetype B (traverse):** displacement is **roughly constant** and the element exits the frame. Total travel **≥100% of frame width**; total duration **12–27 frames**. The element is visible touching both frame edges at some point.
- **Then check where the whoosh peaks.** Extract the audio for the event and find the loudest 100 ms window.
  - For A, in matched work the peak sits at **10–20% of the motion's duration** — i.e. within the first 2–3 frames. A whoosh peaking in the middle of an out-ease entrance is the commonest near-miss: the element has already arrived when the sound arrives.
  - For B, the peak sits at **45–55%**, on the frame where the object crosses frame centre.
- **Length ratio.** The audible body should be **1.0–1.3× the motion duration**, with reverb tail beyond. A 9-frame entrance under a 2-second whoosh is a template.
- **Pitch direction.** Rising for motion outward/upward/growing, falling for inward/downward/settling. A traverse commonly carries a Doppler-like rise-then-fall; a falling sweep under a rising element is detectable even by viewers who cannot name it.
- **Motion blur on the traverse.** At **>12 px/frame** of displacement, real footage would smear. Check whether the graphic does. Zero blur at 60 px/frame is the tell that the object is a pasted layer rather than something in the scene.
- **Level.** SFX sit at **−12 to −15 dB** under dialogue at 0 to −3 dB. A whoosh you can name while watching is 6 dB too loud.
- **Count them.** Whooshes per minute is a style-profile number. Above ~8/min the video is in tick-every-other-second territory and the viewer tires within two or three minutes.

## Parameters

### Archetype A — entrance

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `travel` | 90 px @1080p | 60–160 px | ≈5–9% of frame width. Larger travel needs a longer duration or it reads as a throw. |
| `axis` | `y` (rise) or `x` (from the side it will live on) | — | Match the element's resting alignment: a left-aligned lower third enters from the left. |
| `duration` | 0.38 s (11 f) | 0.30–0.45 s | "Professional, most content" band. |
| `ease` | `power3.out` | `power3.out` \| `power4.out` \| `expo.out` | House entrance ease. |
| `opacity_tween` | separate, `power2.out`, 0.25 s | — | Split from the transform; overshooting curves never touch opacity. |
| `peak_fraction` | 0.15 | 0.10–0.20 (`0.05–0.12` for `expo.out`) | Where the whoosh's loudest moment goes. |
| `stagger` | 0.06 s | 0.04–0.10 s | Siblings. Hard cap `items × stagger ≤ 0.5 s`; **one sound for the whole group**. |
| `sfx_length` | 1.15 × duration | 1.0–1.3× | ≈0.44 s for a 0.38 s entrance. |
| `sfx_level` | −13 dB | −12 … −15 dB | |

### Archetype B — traverse

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `travel` | 120% of frame width | 100–140% | `xPercent: -120 → 120`, or the reverse. Must fully clear both edges. |
| `duration` | 0.60 s (18 f) | 0.40–0.90 s | |
| `ease` | `none` | `none` \| `power1.inOut` | A fly-by has constant velocity. An out-ease makes the object appear to brake off-screen. |
| `peak_fraction` | 0.50 | 0.45–0.55 | Frame-centre crossing. |
| `displacement_per_frame` | derived | — | `travel_px / (duration × fps)`. At 120% of 1920 over 18 frames that is **128 px/frame**. |
| `streak_length` | 0.5 × displacement/frame | 0.4–0.6× | A 180° shutter at 30 fps is a **1/60 s exposure** — half a frame — so the physically-matched smear is half the per-frame travel. 64 px at the numbers above. |
| `streak_axis` | travel axis only | — | Directional. An isotropic CSS `blur()` produces a soft ghost, not a streak; use an SVG `feGaussianBlur` with a two-value `stdDeviation`. |
| `rotation` | 0° | 0–12° | A slight tilt into the direction of travel sells momentum on a card or icon. |
| `sfx_length` | 1.15 × duration | 1.0–1.3× | ≈0.7 s for a 0.6 s traverse. |
| `sfx_pitch_contour` | rise then fall | — | The Doppler convention: approaching reads higher, receding lower. |
| `sfx_level` | −13 dB | −12 … −15 dB | |

## Reproduction prompt

```
Sound and finish the motion event {{EVENT}} at composition second {{T}}.

1. CLASSIFY. Measure the element's travel and end state.
     Element travels < 20% of frame width and comes to REST -> ARCHETYPE A.
     Element travels >= 100% of frame width and LEAVES     -> ARCHETYPE B.
     Element travels 20-100% and comes to rest: treat as A with a longer
     duration (0.45-0.55s) and peak_fraction 0.15.
     Element travels < 8% of frame width: no whoosh. Silent tier.

2. BUILD THE MOTION.
   ARCHETYPE A: fromTo the element on x or y across 90px into 0, plus a
     separate opacity tween, duration 0.38, ease power3.out, at {{T}}.
     peak_fraction = 0.15 (use 0.08 if the ease is expo.out).
   ARCHETYPE B: fromTo xPercent -120 -> 120 (or reverse), duration 0.60,
     ease "none", at {{T}}. peak_fraction = 0.50.
     Compute displacement_per_frame = travel_px / (0.60 * fps). If it exceeds
     12 px/frame, add a DIRECTIONAL streak: an SVG feGaussianBlur whose
     stdDeviation animates "0 0" -> "<0.5*displacement_per_frame> 0" -> "0 0"
     across the traverse, on the travel axis only. Do not use CSS filter:
     blur() - it smears both axes and produces a ghost, not a streak.

3. DERIVE THE WHOOSH IN-POINT. This is the step people skip.
     peak_time = {{T}} + peak_fraction * duration
     Measure the whoosh file's own peak offset - do NOT assume it is at the
     start or the middle:
       ffmpeg -i whoosh.wav -af ebur128=metadata=1,ametadata=print:key=lavfi.r128.M \
         -f null - 2>&1 | grep -B1 pts_time
     Take the pts_time of the maximum momentary-loudness value. Call it
     file_peak.
     in_point (data-media-start) = file_peak - (peak_time - clip_start)
     Simplest correct form: set data-start = peak_time - file_peak and
     data-media-start = 0 when file_peak <= peak_time; otherwise trim with
     data-media-start = file_peak - (peak_time - data-start).

4. LENGTH. audible body = 1.15 * duration. Trim with data-media-start and
   data-duration inside the composition; do not cut a new file.

5. PITCH. Rising for outward/upward/growing motion, falling for
   inward/downward/settling. A traverse takes a rise-then-fall contour. Pitch
   the whole effect DOWN 1-3 semitones if the element covers more than a third
   of the frame, UP 1-3 if it is small.

6. LEVEL -13 dB against dialogue at 0 to -3 dB. Give it the sfx audio group,
   never the voiceover group.

7. GROUPS. If {{EVENT}} is a staggered set of siblings, use ONE whoosh for the
   whole arrival unless the per-item stagger exceeds 0.12s.

ACCEPTANCE TEST:
(1) Overlay the audio envelope on the per-frame displacement. The loudest
100ms window must contain the frame of maximum displacement, +/- 1 frame.
(2) The sound must not finish before the motion does.
(3) For a traverse, the object must fully clear both frame edges and no frame
may show it half-clipped at rest.
(4) For a traverse above 12 px/frame, the streak must run along the travel
axis only - edges perpendicular to travel stay sharp.
(5) Mute the picture: the sound alone must describe a movement of the same
speed and direction.
(6) Turn the whoosh down until you cannot name it while watching, then check
you can still feel the move. That level is correct.
```

## Execution spec

**HyperFrames.** Motion is GSAP on the single paused timeline; sound is an `<audio>` clip; the two are coupled only by the author writing the same arithmetic twice — there is **no audio-follows-animation attribute**.

```js
// ARCHETYPE A: lower third enters at 22.4s
const T = 22.4, D = 0.38;
tl.fromTo("#lower-third", { x: -90 }, { x: 0, duration: D, ease: "power3.out" }, T);
tl.fromTo("#lower-third", { autoAlpha: 0 }, { autoAlpha: 1, duration: 0.25, ease: "power2.out" }, T);
// power3.out -> peak at 0.15 * 0.38 = 0.057 -> peak_time = 22.457
```

```html
<!-- whoosh whose own loudest moment is 0.31s into the file -->
<audio id="sfx-lt" src="assets/sfx/whoosh-soft.wav" data-audio-group="sfx"
       data-start="22.147" data-duration="0.44" data-track-index="12" data-volume="0.22"></audio>
```

```js
// ARCHETYPE B: icon flies across at 48.0s, 1920-wide frame, 30fps
const T2 = 48.0, D2 = 0.60;                     // 120% of 1920 = 2304px over 18f = 128 px/f
tl.fromTo("#fly-icon", { xPercent: -120, rotation: -6 },
                       { xPercent: 120, rotation: 6, duration: D2, ease: "none" }, T2);
// directional streak: 0.5 * 128 = 64px along x only
tl.fromTo("#fly-blur", { attr: { stdDeviation: "0 0" } },
                       { attr: { stdDeviation: "64 0" }, duration: D2 / 2, ease: "power1.out" }, T2);
tl.to("#fly-blur",     { attr: { stdDeviation: "0 0" },  duration: D2 / 2, ease: "power1.in"  }, T2 + D2 / 2);
// peak_time = 48.0 + 0.5 * 0.60 = 48.30
```

```html
<svg width="0" height="0" style="position:absolute">
  <filter id="fly-streak"><feGaussianBlur id="fly-blur" in="SourceGraphic" stdDeviation="0 0"/></filter>
</svg>
```

Contract points that bind this:
- **Author seconds; frames are a derived comment.** 0.38 s is 11.4 frames at 30 and 9.1 at 24. The **peak fraction is a ratio and survives an fps change**; the frame count does not. `render --fps` can override `data-fps`.
- **`fromTo`, never `from`** — `from()` writes its start state at construction, before the clip's `data-start` is active, and non-linear seek then flashes or skips it.
- **`x`/`xPercent`/`rotation`, not `left`/`margin`.** `width`/`height`/`top`/`left` tweens are forbidden.
- **No CSS `transform` on an element GSAP transforms** (`gsap_css_transform_conflict`, error — and a lint error also switches off the layout and contrast audits).
- **`filter` and SVG `attr` tweens are lint-clean on the master timeline.** The `x/y/scale/rotation/opacity` whitelist is a scene-worker prompt rule and does not bind `index.html`.
- **A traverse needs overflow to be intentional.** The composition root should hide overflow; mark the deliberate off-frame excursion with `data-layout-bleed="true"` rather than `data-layout-allow-overflow`, whose blast radius covers the whole subtree.
- **Every `<audio>` needs an `id`** or it is never mixed — a silent render with no error.
- **Give SFX their own group** (`data-audio-group="sfx"`), never the `voiceover` group used for carve; a non-voice clip inside the carve group poisons the next re-analysis silently.
- **Do not both tween and automate `volume`** on one track (`audio_volume_double_automation` — the lane wins); a `volume` tween is absolute and replaces `data-volume` entirely (`audio_volume_tween_overrides_gain`).
- **`data-media-start` + `data-duration` trim in place.** Only cut a physical file when the asset leaves the pipeline.
- **`data-playback-rate` is a constant in `0.1..5` and is pitch-preserved**, so it changes an effect's length without changing its pitch. **There is no rate envelope** — an accelerating sweep must be preprocessed.
- **Sub-comp boundary.** If the motion lives in a sub-composition at scene-local `t`, the audio at the host root needs `data-start = t + the slot's data-start`. Audio lives at the root in modular projects so playback survives scene cuts.
- **Stagger cap:** `items × stagger ≤ ~0.5 s` so an arrival reads as one beat — which is exactly why one arrival takes one whoosh.

**Epidemic Sound.** Real tag namespaces, verified against the catalogue:

```
# Archetype A - short, soft, decaying
SearchSoundEffects { query: { term: "short soft whoosh transition light" },
                     filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--whoosh", "swooshes--swish"] },
                               duration: { max: 1000 } } }
# Archetype B - fly-by with a contour
SearchSoundEffects { query: { term: "swish flyby fast bright" },
                     filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--swish"] },
                               duration: { min: 300, max: 1500 } } }
```
Typical returns in this range run **390–1200 ms**, which is the right order for both archetypes without heavy trimming. `SearchSimilarToSoundEffect` on a hit with the right envelope but the wrong colour is faster than re-querying.

**ffmpeg — the three measurements and the three variation knobs.**

```bash
# where is the file's own loudest moment? (momentary loudness, 100ms windows)
ffmpeg -i whoosh.wav -af ebur128=metadata=1,ametadata=print:key=lavfi.r128.M -f null - 2>&1 | grep -B1 pts_time
# where does the sound actually start? (for the in-point when there is a long silent head)
ffmpeg -i whoosh.wav -af "silencedetect=noise=-45dB:d=0.02" -f null - 2>&1 | grep silence_end
# pitch WITHOUT changing length (+2 semitones = ratio 1.122)
ffmpeg -i whoosh.wav -af "asetrate=48000*1.122,aresample=48000,atempo=0.891" whoosh.up2.wav
# reverse a sweep so it rises instead of falls
ffmpeg -i whoosh.wav -af "areverse" whoosh.rise.wav
```

**Remotion.** Frame-native, so the peak fraction becomes a literal frame: `peakFrame = startFrame + Math.round(peakFraction * durationInFrames)`. Concept only.

## Pairs with
[[sfx-envelope-matched-to-easing-curve]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-unsounded-motion-audit]] · [[motion-sound-bound-motion-event]] · [[motion-silent-motion-tier]] · [[sfx-peak-on-impact-frame]] · [[sfx-av-sync-binding-window]] · [[motion-overlay-stack-choreography]] · [[sfx-camera-move-air-accent]] · [[sfx-synthetic-family-catalogue]] · [[motion-whip-pan-transition]] · [[sfx-density-fatigue-audit]] · [[sfx-search-vocabulary]]

## Failure modes
- **Peak at the middle of an out-ease.** The element has already arrived and is settling when the loudest moment lands. It feels late although nothing is late. Correction: peak at 10–20% for `*.out`, 5–12% for `expo.out`.
- **File head aligned instead of file peak.** Most whooshes have 50–300 ms of build before their loudest moment; aligning the file's first sample to the motion's start puts the whole effect late. Correction: measure with `ebur128` and offset with `data-media-start`.
- **A traverse with no streak.** 128 px/frame of clean-edged movement is something no camera could produce; the object reads as a sprite. Correction: directional SVG blur at ~0.5× the per-frame displacement.
- **Isotropic blur on a traverse.** CSS `filter: blur()` smears both axes and yields a soft ghost. Correction: `feGaussianBlur` with a two-value `stdDeviation` on the travel axis.
- **An out-ease on a fly-by.** The object appears to brake as it leaves frame, which nothing in the world does. Correction: `none`, or `power1.inOut` at most.
- **One whoosh per staggered sibling.** Five transients across 0.3 s is a machine-gun. Correction: one sound per arrival unless the stagger exceeds 0.12 s.
- **Sound shorter than the motion.** The second half of the animation plays in silence and reads as unfinished. Correction: body 1.0–1.3× the motion.
- **Whooshing everything.** Every tween sounded is how a video reaches a tick every other second and tires the viewer within two or three minutes. Correction: the sound-pass budget decides *which* events get sound; this note only decides how ([[sfx-sound-pass-order]], [[sfx-density-fatigue-audit]]).
- **Known gap:** nothing in this stack derives a sound placement from a motion automatically. `animation-map.mjs` enumerates every registered timeline's tweens, targets and durations and would be the natural input for generating whoosh placements — but it reads live timelines in a browser, and this authoring VM is linux ARM64 without sudo. The peak arithmetic is done at authoring time and written into the design document next to the motion row.
