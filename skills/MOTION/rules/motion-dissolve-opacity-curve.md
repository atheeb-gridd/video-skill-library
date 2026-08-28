---
id: motion-dissolve-opacity-curve
title: The dissolve as a motion spec — the opacity curve, the mid-dissolve dip, and the montage cadence
skill: motion
type: transition
family: dissolve
tags: [skill/motion, type/transition, family/dissolve, engine/hyperframes, engine/ffmpeg, engine/epidemic, engine/remotion, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:47"
    quote: "The dissolve is commonly used to show a passing of time, either within a scene or from one scene to the next."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:43"
    quote: "This — instead of fading from a colour, we just fade to a new shot."
research_refs:
  - https://en.wikipedia.org/wiki/Dissolve_(filmmaking)
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
  - https://en.wikipedia.org/wiki/Gamma_correction
  - https://en.wikipedia.org/wiki/Ken_Burns_effect
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: video
---

# The dissolve as a motion spec — the opacity curve, the mid-dissolve dip, and the montage cadence

## What it is
[[cut-dissolve]] defines the transition and [[cut-dissolve-time-passage]] owns the editorial job the source names for it — elapsed time, within a scene or between scenes. This note is the **motion spec**: which layer's opacity actually moves, on what curve, over how many frames, what happens to the picture's brightness in the middle of the overlap, and how a run of dissolves is spaced so a montage reads as rhythm rather than as a pile of soft cuts.

The one thing that separates a professional dissolve from a default one is what happens at 50 %. A dissolve is an **over-composite**, not a mix: the incoming sits on top of the outgoing, which sits on the composition's background. Fade *both* layers — which is what the transition registry's `crossfade` template does — and at the midpoint the picture is `0.5·N + 0.25·O + 0.25·background`. Against a black root with two shots of similar luminance that is **25 % dark for one frame region in the middle of every dissolve**. Fade only the top layer and the sum is exactly right at every instant. That single change is the difference between a dissolve that feels like film and one that feels like a dip.

## When to use it
- **A time-passage montage**: 3–6 shots of the same task, place or subject, each dissolving into the next, saying "this went on for a while" without narration.
- **Within one scene**, across the same framing, to compress a wait or a build.
- **Between two calm scenes** where a hard cut would be too abrupt and a fade to black would end something that has not ended ([[cut-fade-bookend]]).
- **When the two scenes' backgrounds clash**, reach for the registry's `blur-crossfade` instead — its own note: *"Default when the two scenes' `#root` backgrounds differ a lot — the blur masks the background-color clash a plain crossfade would expose."*
- **Not** on high-energy material, not on new information (a hard cut is the reset), and not as a default join. A dissolve on every cut is the oldest amateur tell there is.

## How to recognise it in a reference video
- **Measure the overlap length.** Step at 30 fps and count frames where both images are visible: **6–12 f (0.2–0.4 s)** is a soft join, **24–48 f (0.8–1.6 s)** is the classical time-passage dissolve, **60 f+ (2 s)** reads as memory or dream. Wikipedia's figure for the conventional dissolve is 1–2 s.
- **Plot mean luma across the overlap.** A correct dissolve between two similarly exposed shots holds mean luma within **±4 %** across the whole overlap. A **dip of 10–25 % at the midpoint** is the double-fade fault, and it is measurable even when it is not consciously visible. A dip toward a *colour* means it is not a dissolve at all but a colour dip ([[motion-colour-dip-transition]]).
- **Check the curve.** Sample the outgoing layer's contribution every 2 frames. Linear opacity produces a straight ramp; the registry's `power2.inOut` produces an S; an equal-power pair holds the sum flat. Straight-ramp dissolves between shots of very different luminance are where the gamma error shows most.
- **Check whether motion continues through the overlap.** In good montage work each shot is already drifting ([[motion-still-image-drift]]) and the drift **direction is consistent across the dissolve**; consecutive drifts that reverse rock the frame at every join ([[motion-velocity-matched-transition]]).
- **Cadence.** Measure hold length per shot and dissolve length per join in a montage: holds cluster within ±20 % of each other and the dissolve runs **25–40 % of the hold**. Irregular ratios read as arbitrary.
- **Beat alignment.** In music-led montages the **midpoint** of each dissolve — not its start — tends to land on a beat or a bar line ([[pace-cut-on-the-beat]]).
- **Audio behaviour.** The bed runs continuously; ambience crossfades roughly **6–10 frames longer** than the picture; there is usually no SFX on the join at all.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `dissolve_duration` | 0.80 s (24 f) | 0.20–2.00 s | Registry `crossfade` default is 0.5 s; **`max_duration_s: 2.0`** is a hard registry limit. 6–12 f softens a cut; 24–48 f says time passed. |
| `curve` | fade the **top layer only**, `power2.inOut` | `power1.inOut`–`power2.inOut`; `sine` pair if both must fade | Fading one layer keeps the composite exactly right at every instant. |
| `equal_power_pair` | `sine.in` out / `sine.out` in | — | When both layers must fade (over a visible background), this pair puts each at **0.707** at the midpoint — the audio equal-power law, which is what holds level through the middle. |
| `shot_hold` | 2.4 s | 1.5–3.5 s | Montage. Holds within ±20 % of one another. |
| `dissolve_to_hold_ratio` | 0.33 | 0.25–0.40 | 0.8 s dissolve on a 2.4 s hold. |
| `shots_per_montage` | 4 | 3–6 | Under 3 it is not a montage; over 6 the device wears out. |
| `drift_per_shot` | 3–5 % scale over the hold | 2–8 % | Every shot in the montage moves; direction consistent across joins. |
| `beat_anchor` | dissolve **midpoint** on the beat | midpoint or start | At 100 BPM a bar is 2.4 s — one shot per bar is the cleanest montage grid. |
| `luma_tolerance` | ±4 % mean luma across the overlap | ±8 % | The measurable definition of a clean dissolve. |
| `ambience_overlap` | picture + 8 f | +6 to +10 f | Sound crossfades slightly longer than picture. |
| `bed` | continuous | — | The music does not react to the dissolves; the montage sits inside one musical phrase. |
| `sfx` | none | — | A whoosh on a dissolve contradicts the softness. |

## Reproduction prompt

```
Build a time-passage dissolve montage of {{N}} shots starting at {{T0}}.

1. GRID. hold = 2.4s, dissolve = 0.8s. Author literal seconds: shot k has
   data-start = {{T0}} + k*hold and data-duration = hold + dissolve, so each
   clip outlives its successor's entry by exactly the dissolve length. If a
   bed is playing, set hold to one bar (60/BPM*4) and put each dissolve's
   MIDPOINT on the downbeat.

2. LAYERING. Give shot k z-index k so each incoming sits above the outgoing.
   Author the dissolve as ONE tween on the incoming only:
     tl.fromTo("#shot-k", { opacity: 0 },
       { opacity: 1, duration: 0.8, ease: "power2.inOut" }, T_k);
   Do NOT also fade the outgoing to 0 — a double fade drops the composite to
   ~75% at the midpoint against a black root. Let the outgoing simply end
   (its clip window closes) once the incoming is fully opaque.
   If the root background must show through, use the equal-power pair instead:
   outgoing ease "sine.in" to 0, incoming ease "sine.out" from 0, same T,
   same duration.

3. MOTION THROUGH THE JOIN. Every shot drifts: scale 1.00 -> 1.04 (or a
   matching pan) across its whole clip on ease "none", and every shot drifts
   in the SAME direction so the montage does not rock at the joins.

4. SOUND. One continuous bed under the whole montage; crossfade ambience 8
   frames longer than the picture; no SFX on the joins.

5. RESOLVE. The last dissolve lands on a downbeat and the final shot holds at
   least 1.5s before the montage cuts away.

ACCEPTANCE TEST: sample mean luma every 2 frames across each overlap - it must
stay within +/-4% of the two shots' average, with no midpoint dip. Overlap
lengths must be equal to within 2 frames. No drift reverses across a join.
Every animation resolves at least 2 frames before its clip's data-duration.
```

## Execution spec

**HyperFrames.** The overlap is authored in the clip windows; the fade is one tween.

```html
<!-- hold 2.4s, dissolve 0.8s: each clip is 3.2s long and starts 2.4s after the last -->
<div id="mt-1" class="clip" data-start="30.0" data-duration="3.2" data-track-index="1" style="z-index:1">
  <img id="mt-1-img" src="assets/still-01.jpg" style="width:100%;height:100%;object-fit:cover">
</div>
<div id="mt-2" class="clip" data-start="32.4" data-duration="3.2" data-track-index="2" style="z-index:2">
  <img id="mt-2-img" src="assets/still-02.jpg" style="width:100%;height:100%;object-fit:cover">
</div>
```

```js
// dissolve INTO shot 2 — only the incoming is tweened
tl.fromTo("#mt-2", { opacity: 0 }, { opacity: 1, duration: 0.8, ease: "power2.inOut" }, 32.4);
// drift, same direction on every shot, linear so the join has no velocity step
tl.fromTo("#mt-1-img", { scale: 1.00 }, { scale: 1.04, duration: 3.1, ease: "none" }, 30.0);
tl.fromTo("#mt-2-img", { scale: 1.00 }, { scale: 1.04, duration: 3.1, ease: "none" }, 32.4);
```

Contract points:
- **Layering is CSS `z-index`, not `data-track-index`** — the track index is display-only and constrains nothing.
- Two clips may overlap in time on the same track; the render paints in CSS order.
- The registry's `crossfade` template tweens **both** wrappers (`to(__OLD__, {opacity:0})` + `fromTo(__NEW__, {opacity:0},{opacity:1})`, `power2.inOut`). It is legal and fine when the two scenes are similarly lit; the single-layer form above is the fix when a midpoint dip is measurable. *(This dip is derived arithmetic — `0.5N + 0.25O + 0.25bg` at the midpoint — not a claim made by the staged files.)*
- `blur-crossfade` (0.6 s, calm) is the registry's answer when the two roots' backgrounds differ a lot.
- Relative timing can express the overlap (`data-start="mt-1 - 0.8"`), but **spaces around the operator are required** and an unresolved reference silently becomes 0. Prefer literal seconds in a montage and verify with `snapshot`.
- The visibility window is half-open: land the fade at least 2 frames before `data-duration`.
- `img` clips **require** `data-duration`; without a resolvable duration an element stays visible for the rest of the composition.
- Do not tween `display`/`visibility` on a clip element; the framework owns clip visibility.
- **Known gap — linear-light blending.** Browser compositing of `opacity` happens in gamma-encoded sRGB, and blending gamma-encoded values of *different* luminance gives a result darker than physically correct (the classic gamma error; sRGB's exponent is ≈2.2). There is no attribute to force a linear-light composite. Mitigations: keep the two shots within ~1 stop of each other, shorten the time spent near 50 % with a steeper `power2.inOut`, or move the blend into a shader transition (`@hyperframes/shader-transitions`) where the mix is authored explicitly.

**ffmpeg — measuring and, when a flat file is the deliverable, baking.**

```bash
# mean luma per frame across a dissolve, the clean-dissolve test
ffmpeg -ss 32.2 -i render.mp4 -t 1.2 -vf "fps=30,signalstats,metadata=print:key=lavfi.signalstats.YAVG" -f null -
# bake a dissolve between two files (offset = start of the overlap, in seconds)
ffmpeg -i a.mp4 -i b.mp4 -filter_complex "xfade=transition=fade:duration=0.8:offset=2.4" out.mp4
# xfade also carries a literal 'dissolve' (noise-threshold) transition, which is NOT a cross-dissolve
```

**Epidemic Sound.** Nothing on the joins. For the bed under the montage: `SearchRecordings` filtered to the target BPM band so one bar equals the shot hold ([[pace-bpm-matched-music-selection]]); crossfade ambience with a `volume` automation lane on each ambience clip rather than an SFX.

**Remotion.** `interpolate(frame, [start, start+24], [0, 1])` on the incoming sequence's opacity, with the outgoing left opaque underneath — same single-layer rule. Concept only.

## Pairs with
[[cut-dissolve]] · [[cut-dissolve-time-passage]] · [[motion-still-image-drift]] · [[motion-velocity-matched-transition]] · [[motion-colour-dip-transition]] · [[motion-fade-to-black-ramp]] · [[motion-white-bloom-through]] · [[pace-cut-on-the-beat]] · [[motion-beat-quantised-animation]] · [[sfx-ambience-bridge-across-cut]] · [[motion-continuity-across-the-seam]] · [[motion-bookend-transition-map]]

## Failure modes
- **The double fade.** Both layers ramped to 0.5 at the midpoint; the picture drops about a quarter of its brightness for a few frames on every join. Correction: fade the top layer only, or use the `sine.in`/`sine.out` equal-power pair.
- **Dissolving between very different exposures.** The gamma error makes the middle muddy and the transition reads as a fault in the grade. Correction: match exposure first, or shorten the dissolve.
- **Dissolve as the default join.** Softness everywhere means nothing is soft. Correction: hard cuts carry new information; dissolves carry elapsed time.
- **Static shots inside the montage.** Four still frames dissolving into each other reads as a slideshow. Correction: every shot drifts, same direction.
- **Reversing drift across a join.** The frame rocks left-right-left. Correction: one drift direction for the whole montage ([[motion-velocity-matched-transition]]).
- **Ragged cadence.** Holds of 1.2 s, 3.4 s and 2.0 s with dissolves of 0.4 s, 1.1 s and 0.6 s. Correction: one hold and one dissolve length for the whole montage, both derived from the bar length.
- **A whoosh on the join.** Contradicts what a dissolve means. Correction: silence, and let ambience carry it.
- **Landing the fade exactly on `data-duration`.** The last frame never renders and the join flicks. Correction: resolve 2 frames early.
