---
id: motion-attention-transient
title: The attention transient — the minimum on-screen change that actually registers
skill: motion
type: motion
family: attention-mechanics
tags: [skill/motion, type/motion, family/attention-mechanics, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:02:57"
    quote: "When you see a change in your field of view, like something moving suddenly, it grabs your attention."
research_refs:
  - https://www.mdpi.com/1995-8692/2/2/11
  - https://www.nngroup.com/articles/animation-duration/
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://tech.ebu.ch/docs/r/r095.pdf
difficulty: medium
detectable_from: transcript+video
---

# The attention transient — the minimum on-screen change that actually registers

## What it is
The motion-library reading of the creator's principle: a change in the field of view recruits attention **only if the change is large enough and fast enough to be a transient**. Below a threshold, a change is experienced as texture — pleasant, immersive, invisible — and above it, it is an involuntary orienting event. Every authored move in a composition is therefore one of two things on purpose: a *transient* (meant to be noticed) or a *drift* (meant not to be). Getting a move stuck between the two bands is the most common motion fault in retention editing: it costs attention without buying a beat.

The empirical backstop is edit blindness. In Smith & Henderson's eye-tracking study, viewers pressing a button whenever they saw a cut **missed 32.4% of match-action cuts and 25.1% of within-scene cuts**, versus **9.4% of between-scene cuts**, with mean detection latencies of **564 ms, ~489 ms and 507 ms** respectively (gaze-match cuts were detected fastest, 410 ms, missed 10.9%). A cut is not automatically an attention event. Change has to be *legible* to be a transient.

## When to use it
- **As a gate on every authored move.** Before writing a tween, decide: transient or drift. Then give it the parameters of that band, not the ones in between.
- **When a beat needs to land without a cut** — the transient is the cheap substitute for a cut ([[pace-overlay-instead-of-cut]], [[motion-overlay-stack-choreography]]).
- **When a still needs to stop being a still** but must not steal focus — the drift band in the table below, one slow tween across the whole clip.
- **When two changes collide.** If two regions change inside the same 6 frames, attention splits and neither reads. Sequence them.
- **When a cut is doing no work.** If the incoming shot's framing, subject scale and luminance are near-identical to the outgoing, the cut will be missed by a quarter to a third of viewers — either add a real transient at the cut or don't spend the cut.

## How to recognise it in a reference video
- **Extract per-frame difference and look at the shape of it.** `ffmpeg -i ref.mp4 -vf "select='gt(scene,0.15)',metadata=print" -f null -` prints a timestamped list of frames where the frame changed materially. Frames that print are transients; long gaps between prints are drift or stasis.
- **Measure displacement in frame-height percent, not pixels.** Track one feature across 4 frames. **≥1.5% of frame height inside ≤4 frames (0.13 s)** is a transient. **≤0.6% of frame height per second** is drift. The 0.6–1.5%/0.13 s gap is the dead zone.
- **Scale changes:** a punch-in of **≥3%** of linear scale inside 6 frames reads as an event; **≤1.5% per second** reads as breathing.
- **Luminance/area events:** a change covering **≥10% of frame area** with a **≥15% luminance delta** in that region (a scrim, a flash, a full-width lower third) reads as a transient regardless of displacement.
- **Count the transients per 10 s.** Retention-style explainer: **4–8 per 10 s** across all sources (cut, overlay entrance, punch-in, caption emphasis). Under 2 reads as flat; over 12 reads as noise and the individual transients stop meaning anything ([[pace-visual-mush-ceiling]]).
- **Check for collisions.** Step through any 6-frame window containing an entrance: if a second element also starts moving in the same window and is not part of the same staggered group, log it as a collision.
- **Check drift discipline on stills.** Stills that are genuinely static (no drift at all) are also a profile fact worth logging — some channels never move a still.
- **Transcript signal:** words like "look", "here", "this bit", a number, or a named term inside ±0.5 s of a transient means the transient is doing editorial work, not decoration.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `transient_displacement` | 2.5% of frame height | 1.5–8% | 1080p: 27 px default, 16–86 px. Below 1.5% it is not seen as an event. |
| `transient_rise` | 0.13 s (4 f) | 0.07–0.30 s (2–9 f) | Time to reach ~80% of the move. NN/g's 100–500 ms UI band is the outer envelope; a video transient lives at its fast end. |
| `transient_ease` | `power3.out` | `power2.out`–`expo.out` | Front-loaded velocity is what makes it a transient. `sine.inOut` destroys it. |
| `transient_scale_delta` | 1.04 | 1.03–1.15 | Punch-in as a transient. Under 1.03 nobody sees it. |
| `drift_rate` | 0.4%/s of frame height | 0.15–0.6%/s | Ken-Burns-band motion. 1080p: ~4 px/s. |
| `drift_scale_rate` | 1.0%/s | 0.5–1.5%/s | Slow push. Author as a single linear (`none`) or `sine.inOut` tween over the whole clip. |
| `dead_zone` | — | 0.6–1.5% h in 0.13 s | Avoid. Either commit to a transient or fall back into drift. |
| `transients_per_10s` | 6 | 2–12 | All sources counted together, including cuts. |
| `min_gap_between_transients` | 0.5 s | 0.35–2.0 s | Below 0.35 s two transients merge into one perceived event. |
| `collision_window` | 6 f (0.2 s) | 4–9 f | Two unrelated elements must not both start inside this window. |
| `group_stagger_total` | 0.3 s | 0.15–0.5 s | A staggered group is ONE transient. Hard engine cap: items × stagger ≤ ~0.5 s. |
| `safe_inset` | 5% | 3.5–5% | EBU R95: 5% graphics safe, 3.5% action safe. A transient that starts outside the safe area is half-missed. |

## Reproduction prompt

```
Audit and re-author the change events in this composition so every authored
move is either a TRANSIENT or a DRIFT, never in between.

STEP 1 - inventory. List every moment where the picture changes: cuts, clip
entrances, punch-ins, overlay reveals, caption emphasis frames. For each,
record time, the region of frame it occupies, and displacement measured as a
percentage of frame height over its first 4 frames.

STEP 2 - classify. Displacement >= 1.5% of frame height within 4 frames (or a
scale delta >= 3% within 6 frames, or a >= 10%-of-frame-area luminance change)
is a TRANSIENT. <= 0.6% of frame height per second is a DRIFT. Anything in
between is a defect: push it up or down.

STEP 3 - re-author. Transients: translate 2.5% of frame height (27px at 1080p)
or scale 1.00 -> 1.04, duration 0.13-0.20s, ease power3.out, and land the end
state at least 2 frames before the clip's data-duration. Drifts: one tween
across the whole clip at 0.4% of frame height per second, ease none or
sine.inOut, no second move inside it.

STEP 4 - spacing. Enforce >= 0.5s between transients, no two unrelated
elements starting inside the same 6-frame window, and 4-8 transients per 10s
of finished video. A staggered group counts as one transient; keep its total
stagger under 0.3s.

ACCEPTANCE TEST: run ffmpeg select='gt(scene,0.15)',metadata=print over the
render and confirm the printed timestamps match your intended transient list
within 2 frames, with no unintended prints and no gap longer than 4s in a
retention-paced section.
```

## Execution spec

**HyperFrames.** Transients and drifts are both GSAP tweens on the single paused timeline; the difference is entirely duration, ease and magnitude.

```js
const tl = gsap.timeline({ paused: true, defaults: { duration: 0.4, ease: "power3.out" } });

// TRANSIENT: overlay card arrives as an attention event at t = 12.4s
// 2.5% of 1080 = 27px, 4 frames @30fps = 0.133s
tl.fromTo("#stat-card",
  { y: 27, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.20, ease: "power3.out" }, 12.4);

// DRIFT: the still underneath breathes for its whole 6s window, unnoticed
// 0.4%/s over 6s = 2.4% total; scale 1.00 -> 1.024
tl.fromTo("#still-a", { scale: 1.0 }, { scale: 1.024, duration: 6, ease: "none" }, 8.0);
```

Contract points that bind this:
- **Transform aliases only** (`x`, `y`, `scale`, `rotation`). `top`/`left`/`width`/`height` tweens are forbidden, and a CSS `transform` on the same element as a GSAP tween is the `gsap_css_transform_conflict` lint error.
- Use `fromTo`, never `from` — `from()` writes its start state at construction time and misbehaves under the render engine's non-linear seek.
- Author time in **seconds**; frames are a derived comment. 4 f @30fps = `0.133`.
- The resolved end state must land **before** `data-start + data-duration` (half-open window) or its final frame never renders.
- A drift on a **root-level clip** is safe; the framework forces root-level timed children to `position:absolute; inset:0`, so a scale drift has a stable box. A non-timed wrapper needs its own `position:absolute; inset:0`.
- Prefer `stagger` over N delayed tweens for a group, `amount` ≤ 0.5 s total, ordered by **importance** not DOM order.
- Never `gsap.to()` a drift outside `tl` — a bare tween runs on wallclock and is **absent from the render**.

**ffmpeg — the audit side.**

```bash
# 1. list change events with a low threshold (transients + hard cuts)
ffmpeg -i ref.mp4 -vf "select='gt(scene,0.15)',metadata=print:file=/tmp/changes.txt" -f null -
# 2. frame-accurate strip around one candidate for displacement measurement
ffmpeg -i ref.mp4 -ss 12.2 -t 0.6 -vf fps=30 /tmp/t/%03d.png
# 3. drift check: sample 1 frame per second and confirm slow, monotonic change
ffmpeg -i ref.mp4 -vf fps=1 /tmp/drift/%03d.png
```

**Remotion:** `useCurrentFrame()` with an `interpolate` over a 4–6 frame window for a transient, and over the whole clip's frame range for a drift — concept only.

## Pairs with
[[pace-visual-change-clock]] · [[pace-visual-mush-ceiling]] · [[motion-overlay-stack-choreography]] · [[motion-sound-bound-motion-event]] · [[motion-silent-motion-tier]] · [[cut-punch-in-emphasis]] · [[motion-image-focal-point-direction]] · [[motion-format-promise-motion-budget]]

## Failure modes
- **Dead-zone motion.** A 10 px slide over 20 frames: too small to notice, too big to be free. Correction: 27 px over 4–6 frames, or 4 px/s across the whole clip.
- **Slow ease on a transient.** `sine.inOut` or `power1.inOut` on a 0.2 s entrance flattens the velocity spike that does the recruiting. Correction: `power3.out` or `expo.out`.
- **Two transients in the same 6 frames.** Attention splits; both are half-seen. Correction: 0.5 s apart, or fold them into one staggered group with ≤0.3 s total stagger.
- **Transient outside the safe area.** A move that starts beyond the 5% graphics inset (EBU R95) is partly cropped on some players. Correction: keep the whole travel inside the inset.
- **Treating every cut as a transient.** Match-action and within-scene cuts are missed by 25–32% of viewers (Smith & Henderson). Correction: if a cut must land as a beat, give it a scale or luminance change too, or a sound event.
- **Transient with no editorial reason.** A move that recruits attention and then pays nothing costs trust. Correction: bind every transient to a word in the transcript within ±0.5 s.
- **Known gap:** the displacement and rate thresholds here are craft calibrations derived from frame measurement of retention-style edits, not published psychophysics; the edit-blindness percentages and the 100–500 ms animation band are the sourced numbers and should be treated as harder.
