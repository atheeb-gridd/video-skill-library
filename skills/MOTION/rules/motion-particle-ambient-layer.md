---
id: motion-particle-ambient-layer
title: The ambient particle layer — density, drift, blend mode, and the determinism trap
skill: motion
type: motion
family: look-pipeline
tags: [skill/motion, type/motion, family/look-pipeline, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:17"
    quote: "Another immersion hack is to simply make the video look good. That can be color grading, adding a vignette, or some subtle particle animations."
research_refs:
  - https://en.wikipedia.org/wiki/Blend_modes
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://www.nngroup.com/articles/animation-duration/
  - https://en.wikipedia.org/wiki/Shutter_angle
difficulty: medium
detectable_from: video
---

# The ambient particle layer — density, drift, blend mode, and the determinism trap

## What it is
The third element of the creator's "just make it look good" set, and the only one that is *motion*: a full-frame overlay of small, low-contrast, slowly drifting elements — dust motes, out-of-focus bokeh, embers, faint streaks — composited **additively** over the picture. The grade and the vignette are static treatments and belong to [[motion-look-finishing-pass]]; the particle layer is authored motion and belongs here, because its whole design problem is a timing problem: it must move enough to give the frame depth and never enough to register as an event.

That is a quantitative constraint, not a taste one. [[motion-attention-transient]] puts the drift ceiling at **0.6 % of frame height per second**; a particle layer lives at roughly **0.4 %/s**, which at 1080p is about **4 px/s** — a mote crosses the frame in four to eight minutes. Anything faster stops being atmosphere and starts being weather.

## When to use it
- **Over a flat digital image that needs texture**: a graded talking head on a plain wall, a solid-colour title card, a dark scene where compression banding is visible.
- **Under a title or a hero card**, where the empty space around the type would otherwise read as dead.
- **In a "cinematic" or "atmospheric" register** — the same register that wants slow pushes, long dissolves and a low-BPM bed.
- **Not** over busy footage. If the frame already has leaves, rain, crowd, or a moving camera, particles add nothing and cost bitrate.
- **Not** in a fast, high-density retention edit, where the frame changes every 1.5 s anyway and the layer will never be seen.
- **Not** over text-heavy graphics or captions — motes passing across type is the fastest way to make a build look cheap.

## How to recognise it in a reference video
- **Isolate the highlights.** Particles live in the top ~15 % of luminance. Threshold a frame at the 85th percentile and look for a scatter of small blobs that are *not* part of the scene. Repeat 2 s later: the same blobs should have moved a few pixels **coherently**, in one direction.
- **Count them.** 15–45 blobs per 1920×1080 frame is the working band. Over ~60 reads as a snow globe; under ~10 is invisible and not worth the render.
- **Measure travel.** Track one mote across 60 frames (2 s): **6–30 px** total is the drift band. If a mote crosses 5 % of frame width in 2 s, it is a designed motion element, not an ambient layer — log it separately.
- **Look for parallax.** Three size classes moving at visibly different rates is a depth-layered implementation; one size class moving uniformly is a stock overlay clip.
- **Check for a loop seam.** Sample the same crop every 4 s: a stock overlay usually repeats on a 5–15 s cycle and the seam shows as a frame where the whole field jumps.
- **Check blend behaviour.** On a near-white area of the frame the particles should **vanish** (screen/add saturate); if they stay visible over white, the layer is being composited with `normal` and will look like dirt on the lens.
- **Check they are below captions and above footage** in z-order: a mote passing over a caption is the tell that the layer was dropped on top of everything.
- **Per-frame difference is flat.** `ffmpeg -vf "select='gt(scene,0.02)'"` should print *nothing* attributable to the particle layer. If particles trip a scene-change threshold, they are too strong.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `count` | 24 per 1920×1080 | 15–45 | Scale linearly with frame area for other sizes. |
| `size` | 4 px | 2–8 px | Three depth classes at a 1 : 0.7 : 0.45 size ratio. |
| `particle_opacity` | 0.10 | 0.06–0.18 | Per particle, before blend. Above 0.2 they read as dirt. |
| `blend` | `screen` | `screen` · `lighter` | Screen is the conservative additive choice; `lighter` (linear dodge) clips to white and is only for embers/flares. Never `normal`, `overlay` or `soft-light` — those darken as well as brighten and stop reading as light. |
| `drift_rate` | 8 px/s @1080p (0.4 %/s of frame h) | 4–14 px/s (0.2–0.6 %/s) | Hard ceiling is the transient threshold, 0.6 %/s. |
| `parallax_ratio` | 1 : 0.6 : 0.35 | — | Velocity ratio across the three depth classes. Back class also gets 2–4 px blur. |
| `drift_direction` | one axis + ≤15° | — | A single coherent direction reads as air. Random per-particle directions read as noise. |
| `rotation` | none | — | Dust does not spin. Rotation is for embers only, ≤6°/s. |
| `twinkle` | 0.7 → 1.0 opacity | period 3–8 s | Optional, `sine.inOut`, staggered so no two particles peak together. |
| `loop_period` | ≥ composition duration | — | Prefer no loop at all: author the drift as one long tween across the whole composition. |
| `z_band` | above footage, below cards | — | Convention: footage track 0, particles z between footage and overlay cards, captions always above. |
| `seed` | literal integer | — | Positions come from a **seeded** PRNG or a literal array. Never `Math.random()`. |
| `grain_alternative` | 0.03–0.08 | — | If the goal is texture rather than depth, film grain at 3–8 % is cheaper and safer than particles. |

## Reproduction prompt

```
Add an ambient particle layer over {{IN}}–{{OUT}} that gives the frame depth
without ever registering as motion.

STEP 1 - GENERATE POSITIONS DETERMINISTICALLY. Implement mulberry32 with the
literal seed {{SEED}} (an integer written into the composition). Generate 24
particles for a 1920x1080 frame, each with: x0, y0 in 0..1; a depth class d
in {0,1,2} assigned round-robin; size = 4 * [1, 0.7, 0.45][d] px; opacity =
0.10 * [1, 0.85, 0.7][d]; a twinkle phase in 0..1. Do NOT call Math.random()
and do NOT read any clock.

STEP 2 - BUILD THE LAYER. One absolutely-positioned full-bleed div
(position:absolute; inset:0; pointer-events:none; mix-blend-mode: screen)
containing 24 round divs with a soft radial-gradient white fill and no CSS
transform of their own. Depth class 2 gets filter: blur(3px). Place the layer
in z-order above the footage and below every card, title and caption.

STEP 3 - ANIMATE. For each particle, ONE tween on the composition timeline
spanning the whole window: from { x: 0, y: 0 } to { x: vx * D, y: vy * D },
duration D = {{OUT}} - {{IN}}, ease "none", where the speed |v| = 8 * [1,
0.6, 0.35][d] px/s and the direction is the same unit vector (+/-15 degrees
jitter from the seed) for every particle. Optional twinkle: a second tween on
opacity, 0.7 -> 1.0 -> 0.7, duration 3-8s, ease sine.inOut, repeat a FINITE
count computed as floor(D / period), staggered by the seeded phase.

STEP 4 - VERIFY IT IS INVISIBLE AS MOTION. No particle may travel more than
0.6% of frame height per second. No particle may pass through the caption
safe zone (bottom 25% of frame) at above 0.10 opacity.

ACCEPTANCE TEST: render twice and hash the two files - they must be
byte-identical (determinism). Then run
ffmpeg -vf "select='gt(scene,0.02)',metadata=print" over a static-shot
section: the particle layer must produce zero prints. Finally, threshold a
frame at the 85th luminance percentile and count blobs: 15-45.
```

## Execution spec

**HyperFrames.** The determinism rules in the contract are the whole difficulty here, and they are unforgiving: *no unseeded `Math.random()`*, *no render-time clocks*, *no `repeat: -1`*, and **ambient pulses must attach to the seekable `tl`, never a bare `gsap.to()`** — a standalone tween runs on wallclock and is simply absent from the render.

```js
// seeded PRNG - deterministic, seek-safe, render-safe
function mulberry32(a) {
  return function () {
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
const rnd = mulberry32(20260827);
const D = 42.0;                       // whole composition, seconds
const layer = document.querySelector("#particles");
const SPEED = [8, 4.8, 2.8];          // px/s by depth class
const DIRX = 0.26, DIRY = -0.97;      // one coherent direction, mostly upward

for (let i = 0; i < 24; i++) {
  const d = i % 3;
  const el = document.createElement("div");
  el.className = "mote m" + d;
  el.style.left = (rnd() * 100) + "%";
  el.style.top  = (rnd() * 100) + "%";
  layer.appendChild(el);
  const dist = SPEED[d] * D;
  tl.fromTo(el, { x: 0, y: 0 },
                { x: DIRX * dist, y: DIRY * dist, duration: D, ease: "none" }, 0);
  const period = 3 + rnd() * 5;
  tl.fromTo(el, { opacity: 0.07 },
                { opacity: 0.10 * [1, 0.85, 0.7][d], duration: period / 2,
                  ease: "sine.inOut", repeat: Math.floor(D / period) * 2 - 1,
                  yoyo: true }, rnd() * period);
}
```

```css
#particles { position: absolute; inset: 0; pointer-events: none; mix-blend-mode: screen; }
.mote { position: absolute; width: 4px; height: 4px; border-radius: 50%;
        background: radial-gradient(circle, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0) 70%); }
.m1 { width: 3px; height: 3px; } .m2 { width: 2px; height: 2px; filter: blur(3px); }
```

Contract points:
- `#particles` has **no `data-start`**, so it is not a clip and the framework will not lay it out — it needs its own `position: absolute; inset: 0`, or it collapses to zero height and nothing renders.
- `repeat` must be a **finite** count. `repeat: -1` is banned.
- Do **not** author the drift as a CSS `@keyframes … infinite` — an unbounded CSS animation forces a root `data-duration` and is a determinism risk; and CSS `transition` on these elements interpolates independently of seek and flickers.
- No CSS `transform` on `.mote` (they are GSAP-tweened on `x`/`y`) — that is `gsap_css_transform_conflict`, an error.
- Shader-transition compositions capture the DOM through html2canvas: `mix-blend-mode` and radial gradients under 0.15 opacity are exactly the things that do not survive capture. In a shader composition, mark the layer `data-no-capture` and accept that it is absent during the transition, or bake the particles into the footage with ffmpeg instead. **Known gap** — the contract gives no supported way to composite a blend-mode layer *into* a shader transition.
- If the composition uses the layered-composite path (HDR or shader transitions), a full-screen fill on the **root** is dropped — put the particle layer on a full-bleed child, which this already is.

**ffmpeg — the bake-it-instead route, and the grain alternative.**

```bash
# composite a prepared particle plate additively over the picture
ffmpeg -i base.mp4 -i particles.mov -filter_complex "[0:v][1:v]blend=all_mode=screen" out.mp4

# film grain instead of particles: cheaper, safer, no determinism problem
ffmpeg -i base.mp4 -vf "noise=alls=8:allf=t+u" -c:a copy grained.mp4

# audit: does the layer trip a scene-change threshold on a locked-off shot?
ffmpeg -i out.mp4 -vf "select='gt(scene,0.02)',metadata=print" -f null -
```

**Remotion.** Same seeded-PRNG pattern with Remotion's own `random(seed)` helper and `interpolate(frame, …)` over the sequence's frame range. Concept only.

## Pairs with
[[motion-look-finishing-pass]] · [[motion-attention-transient]] · [[motion-light-leak-overlay-transition]] · [[motion-format-promise-motion-budget]] · [[motion-overlay-stack-choreography]] · [[motion-fade-to-black-ramp]] · [[sfx-music-sets-the-mood]]

## Failure modes
- **Unseeded randomness.** Every render is a different video, previews do not match renders, and a re-render after a note changes the whole layer. Correction: a literal seed and a small PRNG, written into the composition.
- **A bare `gsap.to()` for the drift.** Looks perfect in preview and is **completely absent from the render**, because it runs on wallclock rather than the seekable timeline. Correction: every particle tween goes on `tl`.
- **Too many, too bright.** 80 motes at 0.25 opacity is a snow globe and it dates the video instantly. Correction: 24 at 0.10, screen blend.
- **`normal` blend.** The particles sit *on* the image like dust on a lens instead of light in the air, and they stay visible over highlights. Correction: `screen`.
- **Particles over type.** Correction: keep the layer below every card and caption in z-order, and keep density lowest in the lower third.
- **Drift in the transient dead zone.** 20 px/s is fast enough to catch the eye and slow enough to mean nothing. Correction: ≤0.6 %/s of frame height, or make it a designed motion element with a purpose.
- **A visible loop seam.** Correction: one tween across the whole composition rather than a looping overlay clip; if using a stock plate, cross-dissolve its loop point over 0.5 s.
- **Adding particles to a busy edit.** Nobody sees them and the encoder spends bits on them. Correction: reserve for slow, atmospheric or graphic-heavy sections.
