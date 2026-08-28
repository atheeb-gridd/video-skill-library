---
id: motion-whip-pan-transition
title: Whip pan — a directional blur-covered seam matched to the shot's own motion
skill: motion
type: transition
family: covered-cut
tags: [skill/motion, type/transition, family/covered-cut, sfx/motion, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, engine/remotion, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:58"
    quote: "Another way to make transitions seamless is to use a full-screen transition."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://gsap.com/docs/v3/Eases
  - https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-dasharray
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
difficulty: high
detectable_from: video
---

# Whip pan — a directional blur-covered seam matched to the shot's own motion

## What it is
A full-frame transition that fakes a camera whipping from one subject to another: the outgoing frame accelerates off one edge while smearing along the axis of travel, the incoming frame arrives from the opposite edge decelerating out of the same smear, and the actual picture swap happens at the moment of maximum blur where no detail is resolvable. It is the highest-energy member of the covered-cut family and the one most sensitive to direction: the whip must travel the same way the shot was already moving, or it reads as two unrelated slides glued together. The editorial decision to cover a seam at all lives in [[cut-full-screen-transition]]; this is the motion spec.

Mechanically it is the registry's `push-slide` compressed into the high-energy duration band with a **directional** blur ramped over it — isotropic Gaussian blur will not do, because a whip pan's signature is smear along one axis only.

## When to use it
- **The outgoing shot already has lateral motion** — a pan, a handheld swing, a subject exiting frame — and the incoming shot has motion in the same direction. Velocity-matched, this is invisible; unmatched, it is a gimmick.
- **A hard location or topic jump** where a straight cut would read as an error and a dissolve would read as slow.
- **Between two A-roll setups** shot on different days that cannot be reconciled by matching.
- **On a beat**, in a music-led montage — the whip is a percussive gesture ([[pace-cut-on-the-beat]]).
- **Not** in an intimacy or authority register, not more than a handful of times per video (pick 2–3 transition types for the whole video and repeat them), and not when the two shots could simply be match-cut ([[cut-match-cut]]).

## How to recognise it in a reference video
- **Smear is axis-aligned.** Extract the seam frames (`ffmpeg -ss <t> -t 0.5 -vf fps=30`) and look at the blur: a whip pan blurs horizontally (or vertically) only; vertical edges stay sharp. Isotropic blur on both axes is a **blur dissolve**, not a whip.
- **Total covered duration 5–10 frames** (0.17–0.33 s at 30fps). Over ~12 frames it stops reading as a whip and becomes a slide.
- **Displacement per frame is large:** the outgoing image travels **100–140% of frame width** during its half. Peak per-frame displacement is typically 25–45% of frame width — a translation you can measure by tracking any high-contrast edge across two frames.
- **The two halves are asymmetric in ease, symmetric in length.** Outgoing accelerates (`power3.in`/`expo.in`), incoming decelerates (`power3.out`/`expo.out`), each roughly half the total.
- **Direction continuity:** check the outgoing shot's last 10 frames and the incoming shot's first 10 for camera or subject motion. In competent work all three vectors agree.
- **Audio:** a whoosh whose loudest sample sits within ±1 frame of the swap frame, typically **0.4–0.9 s** long with pre-roll before the seam, at **−12 to −15 dB** under a 0 dB dialogue bus. A whip with no whoosh is a strong amateur tell — the brain expects a sound on motion of this magnitude ([[motion-sound-bound-motion-event]]).
- **No detail at the seam:** the middle 1–2 frames should be unreadable. If you can still identify the subject at mid-whip, the blur is under-cooked and the swap will be visible.
- **Frequency:** log how many appear per minute. More than ~2/min in a talking-head video is a template signature.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `total_duration` | 0.25 s (7–8 f) | 0.17–0.33 s (5–10 f) | High-energy band from the transition catalog (0.15–0.3 s). Registry `max_duration_s` is 2.0 — irrelevant here. |
| `out_half` | 0.12 s | 0.08–0.16 s | Outgoing travel. |
| `in_half` | 0.13 s | 0.09–0.17 s | Incoming travel; may be 1 frame longer than `out_half`. |
| `travel` | 110% of frame width | 100–140% | `xPercent: -110` / `+110`. Vertical whip uses `yPercent`. |
| `axis` | `x` | `x` \| `y` | Match the shot's motion axis. |
| `direction` | image travels left | left \| right \| up \| down | The direction the **image** moves, matched across both shots. |
| `blur_peak` | 48 px @1080p | 30–90 px | Along the axis only. Scale with travel: bigger travel needs more smear. |
| `blur_cross_axis` | 0 px | 0–6 px | Keep near zero; >6 px turns it into a blur dissolve. |
| `out_ease` | `power3.in` | `power3.in`–`expo.in` | |
| `in_ease` | `power3.out` | `power3.out`–`expo.out` | |
| `swap_frame` | midpoint | ±1 f | Where blur peaks and the picture changes. |
| `sfx_peak_offset` | 0 f | −1 to +1 f | Whoosh transient on the swap frame. ITU-R BT.1359-1 detectability is +45 ms lead / −125 ms lag; keep inside 1 frame. |
| `count_per_minute` | ≤1 | 0–2 | Repetition of 2–3 transition types is what reads professional; whip is an accent, not the primary. |
| `scale_padding` | 1.06 | 1.03–1.10 | Base scale on both wrappers so no edge exposes background mid-travel. |

## Reproduction prompt

```
Replace the cut at {{CUT}} with a whip pan between scene {{FROM}} and scene
{{TO}}, travelling along {{AXIS}} in the direction the outgoing shot is
already moving.

TIMING. Total 0.25s (7-8 frames at 30fps), split into two halves. Overlap the
two clips: extend {{FROM}}'s data-duration by 0.25s so it holds its last frame,
and pull {{TO}}'s data-start 0.25s earlier. Let T = the overlap start.

MOTION. Give both scene wrappers a base scale of 1.06 (set on the timeline,
never in CSS) so travel cannot expose an edge. At T, tween the outgoing
wrapper xPercent 0 -> -110 over 0.12s with ease power3.in. At T+0.12, tween
the incoming wrapper xPercent +110 -> 0 over 0.13s with ease power3.out. For a
vertical whip use yPercent and swap left/right for up/down.

BLUR. The smear must be directional. Attach an SVG filter with
feGaussianBlur stdDeviation="0 0" to both wrappers and animate the attribute:
0 -> 48 0 across the outgoing half, then 48 0 -> 0 0 across the incoming half.
Do NOT use CSS filter: blur(), which is isotropic and produces a blur dissolve
instead of a whip.

SOUND. One whoosh, 0.4-0.9s, its loudest sample on the swap frame T+0.12 (trim
into the file with data-media-start to achieve that, do not align the file
start). -12 to -15 dB relative to a 0 dB dialogue bus.

ACCEPTANCE TEST: step T-2f .. T+10f. The middle 1-2 frames must be
unreadable; vertical edges must stay sharp while horizontal detail smears (for
a horizontal whip); no frame may show background at an edge; the whoosh
transient must sit within 1 frame of the swap; and the outgoing shot's own
motion direction must match the whip direction.
```

## Execution spec

**HyperFrames.** This is a scene-to-scene transition, so it operates on the two scene **clip wrappers** (`#el-<sid>`), exactly like the registry's Tier-B transitions, and is stamped onto the master timeline at the overlap start.

```html
<!-- directional blur: SVG filter, because CSS blur() is isotropic -->
<svg width="0" height="0" style="position:absolute">
  <filter id="whip-out"><feGaussianBlur id="whip-out-b" in="SourceGraphic" stdDeviation="0 0"/></filter>
  <filter id="whip-in"><feGaussianBlur id="whip-in-b"  in="SourceGraphic" stdDeviation="0 0"/></filter>
</svg>
```

```js
const T = 12.0, OUT = 0.12, IN = 0.13;             // 0.25s total ~ 7.5f @30fps
tl.set("#el-scene-a", { scale: 1.06, filter: "url(#whip-out)" }, 0);
tl.set("#el-scene-b", { scale: 1.06, filter: "url(#whip-in)"  }, 0);

// outgoing: accelerate off-frame while smearing along x
tl.to("#el-scene-a", { xPercent: -110, duration: OUT, ease: "power3.in" }, T);
tl.to("#whip-out-b", { attr: { stdDeviation: "48 0" }, duration: OUT, ease: "power3.in" }, T);

// incoming: arrive decelerating out of the smear
tl.fromTo("#el-scene-b", { xPercent: 110 }, { xPercent: 0, duration: IN, ease: "power3.out" }, T + OUT);
tl.fromTo("#whip-in-b", { attr: { stdDeviation: "48 0" } },
                        { attr: { stdDeviation: "0 0" }, duration: IN, ease: "power3.out" }, T + OUT);
```

Contract points that bind this:
- **Overlap is authored in the timing attributes**, the way the transition injector does it: extend `#el-<from>`'s `data-duration` by the transition duration so it holds its final frame, and pull `#el-<to>`'s `data-start` earlier by the same amount. Relative timing works too (`data-start="scene-a - 0.25"`) — **the spaces around the operator are mandatory**; `"scene-a-0.25"` parses as an id and silently resolves to 0.
- Give the two overlapping wrappers different `data-track-index` values (0/1 ping-pong) — a readability convention, not a render constraint; real layering is `z-index`.
- `filter`, `scaleX` and `transformOrigin` are lint-clean **on the master timeline**; the `x/y/scale/rotation/opacity` whitelist is a scene-worker rule only.
- Outgoing content must be **fully visible when the transition starts** — no separate exit animation. *"The transition IS the exit."* Exit animations are banned except on the final scene.
- The registry's nearest machine-ready relative is `push-slide` (`default_duration_s` 0.5, directions LEFT/RIGHT/UP/DOWN) and its high-energy sibling `zoom-through` (0.4). The broad catalog names a **shader** `whip pan`, but those implementation files are not staged — name it, do not emit code for it.
- If the project uses `@hyperframes/shader-transitions`, every `.scene` div needs an explicit `background-color` matching `bgColor`, and DOM is captured through html2canvas — SVG filters may not survive capture. Use the CSS/GSAP route above in shader projects, or accept a plain `push-slide`.
- **`transformOrigin` matters for a vertical whip**; set it once with `tl.set`, never in CSS alongside a GSAP transform (`gsap_css_transform_conflict`).

**ffmpeg — baked version.** `xfade` has no whip; build it from `avgblur` (which takes independent `sizeX`/`sizeY`, unlike `boxblur`) plus overlay/crop expressions, or pre-render the two smeared halves and concat:

```bash
# horizontal-only smear on the outgoing tail, 0.12s from t=12.0
ffmpeg -i a.mp4 -vf "avgblur=sizeX='if(between(t,12.0,12.12), 40*(t-12.0)/0.12, 0)':sizeY=0" a_smear.mp4
# nearest built-in fallback if a real whip is not required:
ffmpeg -i a.mp4 -i b.mp4 -filter_complex "xfade=transition=slideleft:duration=0.25:offset=12.0" out.mp4
```

**Epidemic Sound.** `SearchSoundEffects { query: { term: "fast whoosh transition swish" }, filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--whoosh"] }, duration: { max: 2000 } } }` — typical returns 0.4–1.6 s. Place so the transient lands on the swap frame:

```html
<audio id="sfx-whip" src="assets/sfx/whoosh-fast.wav" data-audio-group="sfx"
       data-start="11.95" data-duration="0.8" data-media-start="0.06"
       data-track-index="12" data-volume="0.5"></audio>
```

**Remotion:** `interpolate(frame, [T, T+4, T+8], [0, -110, 0])` on `translateX` with a paired SVG filter `stdDeviation` interpolation — concept only.

## Pairs with
[[cut-full-screen-transition]] · [[motion-light-leak-overlay-transition]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-whip-crack-on-snap-cut]] · [[cut-movement-match]] · [[motion-sound-bound-motion-event]] · [[motion-impact-frame-quantisation]] · [[pace-cut-on-the-beat]]

## Failure modes
- **Isotropic blur.** CSS `filter: blur()` smears both axes and the result reads as a soft dissolve, not a whip. Correction: SVG `feGaussianBlur` with a two-value `stdDeviation` on the travel axis only.
- **Direction fighting the footage.** Outgoing shot pans left, whip goes right: the eye sees the reversal and the cover fails. Correction: match the whip vector to the outgoing shot's motion, and prefer an incoming shot that continues it.
- **Too slow.** 15+ frames and it becomes a push-slide with mush on top. Correction: 5–10 frames total.
- **Under-blurred seam.** If the swap frame is readable, the cut is visible and the whole device is wasted. Correction: raise `blur_peak` until the middle frames are unidentifiable.
- **No overscan.** Travel exposes page background at an edge for a frame or two. Correction: base scale 1.06 on both wrappers, set on the timeline.
- **Missing whoosh.** Large motion with no sound is the exact "video feels empty" failure. Correction: whoosh with its peak on the swap frame.
- **Whip as the primary transition.** Used every cut it becomes the video's whole personality. Correction: 2–3 transition types per video, whip as accent, ≤1 per minute.
- **Known gap:** the frame counts, travel percentages and blur magnitudes here are calibrated from frame measurement of retention-style edits and from the catalog's high-energy band (0.15–0.3 s, `power4`/`expo`); no standards body publishes whip-pan parameters. The AV-sync tolerance is the one hard number (ITU-R BT.1359-1).
