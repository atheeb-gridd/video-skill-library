---
id: motion-travel-reveal-streak
title: The travelling reveal — an element crosses frame with a directional streak, cut to the whoosh
skill: motion
type: motion
family: entrance
tags: [skill/motion, type/motion, family/entrance, sfx/motion, layer/sfx, engine/hyperframes, engine/epidemic, engine/ffmpeg, engine/remotion, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:01:07"
    quote: "This sound effect is perfect for fast transitions, movements and dynamic reveals."
research_refs:
  - https://en.wikipedia.org/wiki/Shutter_angle
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://www.nngroup.com/articles/animation-duration/
  - https://gsap.com/resources/getting-started/Staggers/
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: video
---

# The travelling reveal — an element crosses frame with a directional streak, cut to the whoosh

## What it is
The move the whoosh exists to describe. The source names three jobs for the whoosh — *fast transitions, movements and dynamic reveals* — and the shot-to-shot half is covered by [[motion-whip-pan-transition]] and [[motion-light-leak-overlay-transition]]. This note owns the other two: an **element** (a title, a card, a logo, a chip, a mask edge) that travels a substantial distance across frame at high speed, smears along its axis of travel, and either stops at a rest pose or exits the far side leaving something revealed behind it. [[sfx-whoosh-transition-movement-reveal]] owns the sound's placement relative to a *cut*; here the sound is bound to the *element's velocity envelope*, which is a different anchor.

Three variants, and they are not interchangeable:

| Variant | Travel | Duration | Ease | Peak velocity at |
|---|---|---|---|---|
| **Title sweep** — element enters and stops at rest | 15–35 % of frame width | 0.25–0.50 s | `power4.out` / `expo.out` | first frame |
| **Object pass** — element crosses fully and leaves | 110–140 % of frame width | 0.18–0.30 s | `power2.inOut` | midpoint |
| **Mask wipe** — the travelling edge reveals content behind it | 100–110 % of frame width | 0.30–0.55 s | `power3.inOut` | midpoint |

The variant determines where the whoosh's transient goes, which is the single thing that makes the pairing feel bound rather than glued on: the transient sits on the **peak-velocity frame** ([[motion-sfx-pass-manifest]]), so a title sweep gets its transient on frame 1 and an object pass gets it in the middle.

## When to use it
- A **title, stat, chip or lower third** needs to arrive with energy in a high-tempo section (an entrance that is a beat, not a fade).
- A **reveal** where the thing behind is the payoff: the travelling element is the curtain.
- A **list of items** arriving as a group — the sweep is the group's shared direction, with a stagger inside it.
- The register is confident and fast. In an intimate or slow register, a travelling reveal is too much motion for what the format promised ([[motion-format-promise-motion-budget]]).
- Do **not** use it to bring in body text or anything the viewer must read immediately: a fast entrance costs the first ~0.2 s of reading time.

## How to recognise it in a reference video
- **Extract at full frame rate around the entrance** (`ffmpeg -ss T -t 1 -vf fps=30`) and track the element's leading edge per frame. A travelling reveal shows **≥5 % of frame width displaced in a single frame** at its peak (96 px at 1920).
- **Read the deceleration.** Per-frame deltas that shrink monotonically (e.g. 96, 62, 38, 22, 12, 6, 2 px) are an ease-out — a title sweep. Deltas that rise then fall symmetrically are an `inOut` — a pass. Deltas that grow are an exit.
- **Look for the streak.** Crop the element on its fastest frame and compare edge sharpness along vs across the travel axis. A real streak is **anisotropic**: elongated along the axis. Isotropic softness is a plain `blur()` and reads as out-of-focus, not as speed.
- **Measure streak length against velocity.** A 180° shutter produces a blur of `velocity ÷ (2 × fps)` px. At 1200 px/s and 30 fps that is 20 px. Streaks much longer than that read as a stylised trail (fine, but log it as a choice); much shorter and the move looks strobed.
- **Count ghosts.** A trail implemented as duplicated copies shows a discrete number of echoes (usually 3) at decreasing opacity; a true motion blur is continuous.
- **Check the audio.** A broadband sweep whose loudest moment aligns with the max-displacement frame within 0–2 frames. Late by 4+ frames is the file-start placement error.
- **Check the direction against the rest of the video.** A channel usually has one dominant entrance axis. An entrance that comes from the opposite side of the last three is either a deliberate pattern break ([[motion-pattern-interrupt-jolt]]) or an error.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `travel_entrance` | 22 % of frame width (420 px @1920) | 15–35 % | Distance from off-rest to rest. |
| `travel_pass` | 120 % of frame width | 110–140 % | Must fully clear both edges. |
| `duration_entrance` | 0.33 s (10 f) | 0.25–0.50 s | Contract band: fast 0.15–0.3 s, medium 0.3–0.5 s. |
| `duration_pass` | 0.22 s (7 f) | 0.18–0.30 s | Faster than an entrance because nothing must be read. |
| `ease_entrance` | `power4.out` | `power3.out`–`expo.out` | Front-loaded; peak velocity on frame 1. |
| `ease_pass` | `power2.inOut` | `sine.inOut`–`power3.inOut` | Symmetric; peak at midpoint. |
| `overshoot` | none | — | House doctrine: smooth beats bouncy. If a spring is wanted, `dampingFraction` 0.85, `response` 0.35, and **transforms only** — never opacity. |
| `opacity_ramp` | 0 → 1 over 40 % of the move | — | Separate `power2.out` tween so the element is not invisible for the whole travel. |
| `streak_ghosts` | 3 | 2–4 | Opacity 0.30 / 0.18 / 0.09, offset backwards along the axis by 0.4 / 0.8 / 1.2 × the per-frame travel at peak. |
| `streak_length` | `v_peak ÷ (2 × fps)` | 0.5–2 × that | 180° shutter equivalence. At 1080p a 420 px / 0.33 s `power4.out` move peaks near 3400 px/s → ~57 px. |
| `axis` | frame-horizontal | ±0° or ±90° | Diagonal only if the whole vocabulary is diagonal. |
| `stagger` | `each: 0.05` | 0.04–0.08 | For a group sweeping together; total ≤0.5 s, ordered by importance. |
| `sfx_length` | 2.0 × move duration | 1.5–3.0 × | 0.33 s move → a 500–1000 ms whoosh. |
| `sfx_pitch` | 0 st | −4 to +4 st | Lower = heavier/bigger; higher = lighter/smaller. Must be **baked** (see execution spec). |
| `rest_hold` | 0.8 s | 0.5–3.0 s | Time settled before the next event. |

## Reproduction prompt

```
Bring the element {{TARGET}} on screen at {{IN}} as a travelling reveal.
Author seconds; frame counts @30fps are derived comments.

STEP 1 - PICK THE VARIANT. TITLE SWEEP if the element stops and stays.
OBJECT PASS if it crosses and leaves, revealing something. MASK WIPE if the
element is the edge of a reveal. Record the choice; it sets the ease and the
sound anchor.

STEP 2 - GEOMETRY. Travel along ONE axis, the same axis the rest of this
composition uses. TITLE SWEEP: from x = -0.22 * frame_width (or +, matching
the house direction) to x = 0. OBJECT PASS: from -0.60 to +0.60 of frame
width. Never diagonal unless the whole vocabulary is diagonal.

STEP 3 - MOTION.
  TITLE SWEEP: tl.fromTo(el, { x: -420, autoAlpha: 0 },
    { x: 0, autoAlpha: 1, duration: 0.33, ease: "power4.out" }, {{IN}});
    plus a separate opacity tween finishing at 40% of the move if the fade
    needs its own gentler curve (power2.out).
  OBJECT PASS: fromTo x -1150 -> +1150, duration 0.22, ease "power2.inOut".
  Group: add stagger { each: 0.05, from: "start" }, ordered by importance,
  total under 0.5s. The GROUP is one motion event and gets ONE sound.

STEP 4 - STREAK. Add 3 ghost copies of the element as siblings inside the
same wrapper at opacity 0.30 / 0.18 / 0.09, each running the identical tween
delayed by 1, 2 and 3 frames (0.033 / 0.067 / 0.100). Ghosts must be below
the real element in z-order and must be removed (opacity 0) by 0.12s after
the move ends. Do not use an isotropic CSS blur as a substitute for a streak.

STEP 5 - SOUND. Fetch a whoosh whose audible length is 1.5-3x the move
duration. Measure the offset from file start to its loudest sample (PREROLL).
Place the audio at:
  TITLE SWEEP: data-start = {{IN}} - PREROLL - 0.033
  OBJECT PASS: data-start = {{IN}} + duration/2 - PREROLL - 0.033
Level -14 dB relative to dialogue. Lower the pitch 2-4 semitones for a heavy
element, raise it 2-3 for a light one - baked, not via playback rate.

ACCEPTANCE TEST: extract frames at 30fps from {{IN}} - 0.2 to {{IN}} + 1.0.
The per-frame displacement must peak at >= 5% of frame width, must decelerate
monotonically for a TITLE SWEEP, and the element must be fully at rest and
fully opaque within duration + 2 frames. The whoosh's onset must fall within
2 frames before the peak-displacement frame and never after it.
```

## Execution spec

**HyperFrames.**

```html
<div id="title-wrap" class="clip" data-start="18.0" data-duration="4.0" data-track-index="2">
  <div class="ghost g3">DYNAMIC RANGE</div>
  <div class="ghost g2">DYNAMIC RANGE</div>
  <div class="ghost g1">DYNAMIC RANGE</div>
  <div id="title-main">DYNAMIC RANGE</div>
</div>
```

```js
const T = 18.0, D = 0.33, FROM = -420;
const move = { x: 0, duration: D, ease: "power4.out" };
tl.fromTo("#title-main", { x: FROM, autoAlpha: 0 }, { ...move, autoAlpha: 1 }, T);
[
  [".g1", 0.033, 0.30], [".g2", 0.067, 0.18], [".g3", 0.100, 0.09],
].forEach(([sel, dt, op]) => {
  tl.fromTo(sel, { x: FROM, autoAlpha: 0 }, { ...move, autoAlpha: op }, T + dt);
  tl.to(sel, { autoAlpha: 0, duration: 0.10, ease: "power1.out" }, T + D);
});
```

```html
<audio id="sfx-title-sweep" src="assets/sfx/whoosh-light-02.wav"
       data-audio-group="sfx" data-start="17.787" data-duration="0.80"
       data-track-index="12" data-volume="0.5"></audio>
<!-- 18.0 - PREROLL(0.18) - 0.033 = 17.787 : the transient lands on frame 1 of the move -->
```

Contract points:
- **Transform aliases only** — `x`, not `left`. No CSS `transform` on any tweened element (`gsap_css_transform_conflict`, error).
- `fromTo`, never `from`.
- The ghosts are **not** clips (no `data-start`), so they are laid out by the wrapper's CSS; the wrapper is the clip and gets `position:absolute; inset:0` automatically as a root-level timed child.
- Transformed elements must be **block-level and sized**; no `<br>` in body text.
- Land the resolved state ≥2 frames before `data-start + data-duration`.
- **Motion blur is not a primitive.** There is no directional-blur filter in the contract's toolset; CSS `filter: blur()` is isotropic. The ghost-trail construction above is the supported approximation, and the contract names a `motion-blur-streak` recipe in the animation rule index (implementation not staged — cite it, do not quote code you do not have). **Known gap:** a true per-frame directional smear requires either a shader or an ffmpeg pre-render.
- **`data-playback-rate` is pitch-preserved**, so it cannot pitch a whoosh. Bake pitch variants with ffmpeg before import.

**ffmpeg.**

```bash
# measure the move: per-frame stills to track the leading edge
ffmpeg -i out.mp4 -ss 17.8 -t 1.0 -vf fps=30 /tmp/sweep/%03d.png
# bake a heavier whoosh: -3 semitones, duration preserved
ffmpeg -i whoosh.wav -af "rubberband=pitch=0.8409" whoosh.-3st.wav
# find the file's loudest-sample offset (PREROLL)
ffmpeg -i whoosh.wav -af "astats=metadata=1:reset=1,ametadata=print" -f null -
```

**Epidemic Sound.** `SearchSoundEffects` with `filter.tagSlugs { matchType: "ANY", values: ["swooshes--whoosh", "swooshes--swish"] }` and `filter.duration { min: 500, max: 1000 }` for a 0.33 s move. Verified title shapes in the library: *"Swooshes, Whoosh, Designed, Generic, Air"* (546 ms) for a light title sweep; *"Swooshes, Whoosh, Deep, Low, Cinematic"* (2437 ms) only for a move of 0.8 s or longer. Build a 3-file pool with `SearchSimilarToSoundEffect` and rotate.

**Remotion.** `interpolate(frame, [0, 10], [-420, 0], { easing: Easing.out(Easing.exp) })` with the ghosts as offset copies. Concept only.

## Pairs with
[[sfx-whoosh-transition-movement-reveal]] · [[motion-sfx-pass-manifest]] · [[motion-abstract-object-sound-contract]] · [[motion-snap-zoom-punch]] · [[motion-whip-pan-transition]] · [[motion-overlay-stack-choreography]] · [[motion-attention-transient]] · [[motion-beat-quantised-animation]] · [[motion-instant-appearance-sfx-justified]] · [[sfx-air-on-micro-movement]]

## Failure modes
- **Isotropic blur used as a streak.** The element looks out of focus rather than fast. Correction: ghost trail along the axis, or bake a directional blur.
- **The whoosh on the file's first sample.** Late by the file's pre-roll, typically 4–8 frames. Correction: subtract PREROLL.
- **A 2.5 s cinematic whoosh on a 0.3 s sweep.** Correction: 1.5–3× the move duration; trim with `data-media-start`.
- **Overshoot on a title.** `back.out` on an entrance is the cheap register the house doctrine explicitly excludes. Correction: `power4.out`, or a spring at ζ ≥ 0.85 on transforms only.
- **Travel too long.** A 900 px slide over 0.5 s at 1080p reads as a slideshow. Correction: 15–35 % of frame width.
- **Body text swept in.** The first 0.2 s of reading time is spent tracking the element. Correction: fade body text, sweep only display type.
- **Every element from a different direction.** Correction: one dominant axis per composition; a reversal is a deliberate interrupt or a mistake.
- **A whoosh on each of five staggered chips.** Correction: the group is one motion event and gets one sound, anchored on the first item's peak.
