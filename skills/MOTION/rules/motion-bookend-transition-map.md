---
id: motion-bookend-transition-map
title: The transition map — distinctive at the head, slowest at the tail, empty frames only at boundaries
skill: motion
type: transition
family: fade
tags: [skill/motion, type/transition, family/fade, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:31"
    quote: "Fades are commonly at the start or the end of the film, and they symbolize the beginning or the end of a story."
research_refs:
  - https://www.filmeditingpro.com/fades-to-black-and-dissolves-what-you-need-to-know/
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://www.nngroup.com/articles/animation-duration/
  - https://en.wikipedia.org/wiki/Dissolve_(filmmaking)
difficulty: medium
detectable_from: video
---

# The transition map — distinctive at the head, slowest at the tail, empty frames only at boundaries

## What it is
A **runtime-level plan** for which transition appears at which boundary, built on the rule that a fade — the only transition that empties the frame — is structural punctuation. [[cut-fade-bookend]] owns the editorial rule ("fades mark beginnings and endings"); [[motion-fade-to-black-ramp]] and [[motion-colour-dip-transition]] own a single ramp. This note owns the **distribution**: how many empty-frame events a runtime is allowed, where they sit as a fraction of total length, what fills every other boundary, and the requirement that the head and the tail be recognisable as a **matched pair**.

The bookend requirement is the motion-specific half and it is usually missed. A fade up over 15 frames and a fade down over 75 frames is a correct asymmetry — endings carry more weight than beginnings, and film practice puts the closing fade among the slowest events in a piece. A 60-frame open and a 12-frame close is the inverse and reads as the video being cut off mid-thought. The rule: **the tail ramp is 1.3–2.0× the head ramp, on the same colour, with the same curve family reversed.**

## When to use it
- **Once per project, in the design pass, before any transition is authored.** It is a planning artefact, like the beat grid.
- Whenever a piece has more than two sections, so that "which boundaries are structural?" is a real question.
- Whenever a reference video is being profiled: the distribution of empty-frame events across the runtime is one of the strongest and easiest style fingerprints to extract.
- The registry's own budget applies on top: **pick 2–3 transition types for the whole video and repeat them** — repetition is what reads as professional.

## How to recognise it in a reference video
- **Find every empty frame.** `ffmpeg -i ref.mp4 -vf blackdetect=d=0.05:pic_th=0.98:pix_th=0.10 -f null -` lists every run of near-black frames with in/out times. Repeat with `whitedetect`-equivalent (a `signalstats` YAVG threshold) for white and for a brand-colour dip.
- **Normalise their positions.** Express each as a fraction of runtime. A conventional map has events at ~0.00 and ~1.00 and, if act breaks exist, near 0.33 / 0.66. Events scattered at 0.12, 0.19, 0.41, 0.58 mean the reference uses fades as connective tissue — a genuine style, and worth logging as such, but not the convention.
- **Count them.** Long-form 10–20 min: **2–4** solid-frame events total. Short-form under 60 s: **0–1**. More than one solid-frame event per 5 minutes of body is the threshold where the piece starts to feel like it keeps ending.
- **Measure the two ramps.** Extract mean luma per frame at the head and tail (`signalstats` → `YAVG`) and count the frames from 100 % to <2 %. Record head length, tail length and the ratio.
- **Check the tail is the slowest event in the piece.** Compare the closing ramp's duration against every mid-body transition. If a mid-body transition is longer, the map is inverted.
- **Check what covers the non-structural boundaries.** Log the two or three recurring types (push-slide, blur-crossfade, zoom-through, whip pan, light leak) and their durations; a professional edit shows a small vocabulary repeated, not variety.
- **Check the music.** A structural fade almost always coincides with a music stop, a track change, or a bar boundary ([[sfx-music-rest-windows]], [[sfx-track-change-at-section-boundary]]). A fade with the bed running straight through it is a weaker boundary and usually a mistake.
- **Loop check (short-form).** If the piece is designed to loop, the tail must **not** go to black; look for the last frame matching the first.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `solid_events_total` | 2 | 0–4 | Head + tail. Add one per genuine act break only. |
| `solid_events_density` | ≤1 per 5 min of body | — | Excluding head and tail. |
| `head_ramp` | 18 f (0.60 s) | 12–24 f (0.40–0.80 s) | Up from black. |
| `tail_ramp` | 36 f (1.20 s) | 24–60 f (0.80–2.00 s) | Down to black. Registry hard cap `max_duration_s: 2.0`. |
| `bookend_ratio` | 2.0 | 1.3–2.0 | `tail_ramp ÷ head_ramp`. Below 1.0 is a defect. |
| `head_ease` | `power2.out` | `sine.inOut`–`power2.out` | Light arriving. |
| `tail_ease` | `power2.in` | `power2.in`–`sine.in` | Mirror of the head. Same family, reversed direction. |
| `act_break_dip` | 10 f down / 6 f hold / 10 f up | 8–14 / 4–8 / 8–14 | The mid-body version. Total ≤0.9 s. |
| `black_hold_tail` | 12 f | 6–24 f | Frames at true black before the end card or the cut to end screen. |
| `primary_transition` | `blur-crossfade` or `push-slide` | registry names | 0.3 s between related points. |
| `accent_transition` | `zoom-through` | registry names | 0.15–0.3 s, climax only, ≤3 uses per video. |
| `opening_transition` | 0.4–0.6 s | — | Most distinctive of the video's 2–3 types. |
| `outro_transition` | 0.6–1.0 s | — | Slowest and simplest. |
| `loop_safe` | false | true for short-form loops | If true, `solid_events_total = 0` and the last frame must match the first. |

## Reproduction prompt

```
Produce and then execute a transition map for this video before authoring any
individual transition.

STEP 1 - MAP. List every boundary in the edit with its timecode and classify
it: HEAD, TAIL, ACT-BREAK (the argument changes register, not merely topic),
SECTION (new topic, same register), BEAT (related points), CLIMAX,
WIND-DOWN. Write the fraction of runtime for each.

STEP 2 - ALLOCATE. Assign:
  HEAD       -> fade up from black, 18 frames, power2.out, the video's most
                distinctive move underneath it (0.4-0.6s).
  TAIL       -> fade down to black, 36 frames, power2.in, then 12 frames of
                held black. Must be the slowest transition in the piece.
  ACT-BREAK  -> colour dip: 10f down / 6f hold / 10f up. Maximum 2 in a video.
  SECTION    -> the video's SECONDARY registry type (something other than the
                primary), 0.4-0.5s.
  BEAT       -> the PRIMARY registry type, 0.3s.
  CLIMAX     -> the accent type (zoom-through), 0.15-0.3s, max 3 per video.
  WIND-DOWN  -> gentle, 0.5-0.7s, sine.inOut.
Use only 2-3 transition types across the whole video, plus the fades. If the
piece is a short-form loop, allocate ZERO solid-frame events and end on a
frame that matches frame 1.

STEP 3 - VERIFY THE BOOKEND. tail_ramp / head_ramp must be between 1.3 and
2.0, both on the same colour, with mirrored ease families.

STEP 4 - BIND THE MUSIC. Every solid-frame event must coincide with a music
stop, a track change or a bar boundary. If none is available, move the event
or change the music plan.

STEP 5 - AUTHOR. Mid-body transitions animate the outgoing and incoming
scenes AT THE SAME TIMELINE POSITION. Never author an exit tween followed by
an entrance tween - that is a jump cut with a dip. Only the final scene is
permitted an exit.

ACCEPTANCE TEST: run ffmpeg blackdetect over the render. The number of
detected black runs must equal solid_events_total exactly; their positions
must match the map within 6 frames; the tail run must be the longest ramp in
the file; and no black run may appear inside a section.
```

## Execution spec

**HyperFrames.** Two mechanisms, and choosing the wrong one is the most common structural error in this stack.

*Head and tail* are genuine fades to a solid field, authored as a full-bleed solid child at the top of the z-order:

```html
<div id="blackout" class="clip" data-start="0" data-duration="182.0" data-track-index="9"></div>
<style>#blackout { position: absolute; inset: 0; background: #000; z-index: 900; opacity: 1; }</style>
```

```js
const D = 182.0;
tl.to("#blackout", { opacity: 0, duration: 0.60, ease: "power2.out" }, 0.0);   // head, 18f
tl.to("#blackout", { opacity: 1, duration: 1.20, ease: "power2.in"  }, D - 1.60); // tail, 36f
// 12 frames of held black remain before D; land the end state before data-duration.
```

*Mid-body boundaries* use the transition registry and must obey its non-negotiables. Quoted from the contract: **exit animations are BANNED except on the final scene — "the transition IS the exit"**, and outgoing content must be fully visible when the transition starts. So an act-break dip is authored as a transition (both wrappers animating at the same `T`), not as an exit plus an entrance:

```js
const T = 96.4;
tl.to("#el-s3",   { opacity: 0, duration: 0.33, ease: "power2.inOut" }, T);
tl.fromTo("#el-s4", { opacity: 0 }, { opacity: 1, duration: 0.33, ease: "power2.inOut" }, T + 0.20);
```

Other contract points:
- Registry names and defaults: `crossfade` 0.5 s, `blur-crossfade` 0.6 s (calm default; also the right pick when the two scenes' backgrounds differ a lot), `push-slide` 0.5 s (LEFT default), `zoom-through` 0.4 s (high-energy default), `squeeze` 0.4 s. **`max_duration_s: 2.0`.**
- The injector's own mechanics if you use the registry: it extends the outgoing wrapper's `data-duration` by the transition duration, pulls the incoming wrapper's `data-start` earlier by the same amount, and ping-pongs `data-track-index` 0/1 so overlapping wrappers do not share a track.
- **Every composition uses transitions** and **every scene uses entrance animations via `gsap.fromTo()`** — `from()` paired with CSS `opacity: 0` is a 0→0 no-op.
- The half-open window `[start, start+duration)` eats the last frame: land the tail's `opacity: 1` at least 2 frames before the root `data-duration`, or the darkest frame is never rendered ([[motion-fade-to-black-ramp]]).
- Root `data-duration` is read **once at compile time** — the runtime length cannot be changed by a script or `--variables`, so the tail arithmetic must be authored against a literal.

**ffmpeg — extracting the map from a reference, and verifying your own.**

```bash
# every near-black run, with in/out times
ffmpeg -i ref.mp4 -vf blackdetect=d=0.05:pic_th=0.98:pix_th=0.10 -f null - 2>&1 | grep black_start

# per-frame mean luma, for measuring ramp lengths
ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=/tmp/luma.txt" -f null -

# loop check for short-form: compare first and last frame
ffmpeg -i ref.mp4 -vf "select=eq(n\,0)" -vframes 1 /tmp/f0.png
ffmpeg -sseof -0.1 -i ref.mp4 -vframes 1 /tmp/fN.png
```

**Remotion.** An `<AbsoluteFill>` black overlay whose opacity is `interpolate(frame, [0, 18], [1, 0])` at the head and the mirrored ramp at the tail; scene transitions via `@remotion/transitions`. Concept only.

## Pairs with
[[cut-fade-bookend]] · [[cut-fade-to-black]] · [[cut-fade-to-solid-colour]] · [[motion-fade-to-black-ramp]] · [[motion-colour-dip-transition]] · [[motion-whip-pan-transition]] · [[motion-light-leak-overlay-transition]] · [[sfx-music-rest-windows]] · [[sfx-track-change-at-section-boundary]] · [[struct-end-screen-handoff]] · [[motion-storyboard-motion-spec]]

## Failure modes
- **Fades mid-section.** Every empty frame says "this ended", so a fade between two related points makes the video feel like it stops four times. Correction: cuts or registry transitions everywhere except the mapped boundaries.
- **An inverted bookend.** A slow open and a snapped close. Correction: `tail_ramp ÷ head_ramp` between 1.3 and 2.0.
- **A fade to black at the end of a looping short.** It kills the loop and the replay. Correction: `loop_safe = true`, zero solid events, last frame matches first.
- **Authoring an act break as exit + entrance.** The picture dips, holds nothing, and the incoming scene starts from zero — a jump cut with a dip, and it is explicitly the banned pattern in the contract. Correction: both wrappers animate at the same `T`.
- **Music running through the fade.** The picture says "section over", the bed says "still going". Correction: bind every solid-frame event to a music stop, a change, or at minimum a bar line.
- **Five transition types.** Variety reads as indecision. Correction: 2–3 types plus the fades, repeated.
- **The outro faster than a mid-body transition.** Correction: the closing move must be the slowest thing in the piece.
- **The last black frame missing in the render.** Correction: land the ramp 2 frames early against the half-open window.
