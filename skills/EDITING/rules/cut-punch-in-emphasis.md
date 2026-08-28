---
id: cut-punch-in-emphasis
title: Punch in hard on the face to mark the line that matters
skill: editing
type: cut
family: punch-in
tags: [skill/editing, type/cut, family/punch-in, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:06:27
    quote: "For example, when I'm saying something important in an A-roll segment, I zoom in close on my face to subtly tell the viewer to listen up."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:06:22
    quote: "You can also make more abrupt scale changes to pull attention to specific things."
research_refs:
  - https://cotovan.com/post/dynamic-zoom-edits-riverside-polished-podcasts/
  - https://creativecow.net/forums/thread/how-much-can-you-zoom-in-on-4k-footage-in-a-1080p/
  - https://en.wikipedia.org/wiki/Jump_cut
  - https://www.adobe.com/creativecloud/video/post-production/cuts-in-film/jump-cut
difficulty: medium
detectable_from: video
---

# Punch in hard on the face to mark the line that matters

## What it is
A punch-in is an on-axis scale change on a single A-roll angle, used as a pointer rather than as motion. It is deliberately distinct from the slow drift applied to stills for immersion: the drift is continuous and unnoticed, the punch-in is **abrupt and noticed**, and what the viewer notices is "listen to this line". Mechanically it is a jump cut in scale on the same camera, so the framing changes while the subject and background do not.

## When to use it
On the one clause per segment that carries the claim — a number, a name, a promise, a contradiction of what the viewer expects. Also on the first line after returning from B-roll or a sponsor block, where it re-establishes the speaker and re-marks attention. Do **not** use it as a general anti-boredom device: a punch-in that lands on an ordinary line teaches the viewer that the signal is meaningless, and the next real one is ignored. One to three punch-in events per minute of A-roll is the working ceiling in an explainer; a podcast-style recut can carry more because the framing changes double as angle changes.

## How to recognise it in a reference video
- **On-axis scale jump with no parallax.** Background and subject scale together, perspective does not change, and the background does not shift laterally. If the background moves relative to the subject it is a second camera or a real lens move, not a punch-in.
- **Scene detection often misses it.** A punch-in at threshold 0.3 frequently does not register — re-run detection at `gt(scene,0.12)` and compare frames either side.
- Measure the scale ratio by picking a fixed feature (interpupillary distance, shoulder width, a logo) in the frame before and the frame after: `scale_ratio = width_after / width_before`. Typical marks: **1.10–1.20** for a "same shot, tighter" mark, **1.25–1.40** for an emphasis punch, **>1.5** only on 4K-sourced footage.
- **Duration of the change.** A hard punch is 0 frames (a cut). A ramped push is 3–8 frames and shows intermediate scales when stepped frame-by-frame. Log which one it is — it is a signature.
- **Framing centre moves up.** In a correct punch-in the eyes stay on the upper-third line, which means the transform origin is above frame centre. If the eyes drift toward the top edge as it punches in, the origin was frame centre — a tell for an inexperienced edit.
- **Transcript correlation is the confirmation.** Align the punch frames to the word-level transcript. A real emphasis punch lands within ±6 frames of the onset of a stressed word or the start of the clause; if punches land at even intervals unrelated to content, it is a rhythm device, not emphasis.
- **Audio tell.** Roughly half of emphasis punches carry a low-level sub or a short whoosh; check for a transient in the 8–14 frame window around the punch.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `punch_scale` | 1.25 | 1.10–1.40 (native 1080) · up to 2.0 (4K source in 1080) | Linear scale factor, not area. |
| `levels` | 2 (100% / 125%) | 2–3 | Three levels (100/115/135) is the practical maximum before the viewer loses the reference framing. |
| `ramp_frames` | 0 (hard cut) | 0, or 3–8f (0.1–0.27s) | Hard for emphasis; ramp when the line runs >4s and you want a push, not a stab. |
| `ramp_ease` | `power2.out` | `power2.out` \| `power3.out` | Long-tail settle. Never `back`/`elastic` — overshoot reads as playful, which fights the "pay attention" signal. |
| `transform_origin` | `50% 38%` | 50% 30–45% | Puts the growth centre on the eyeline so the eyes stay put. |
| `hold_frames` | 45f (1.5s) | 30–150f (1–5s) | Minimum time at the tighter framing; anything under 30f reads as a glitch. |
| `return_style` | hard cut back | hard cut \| 8–12f ease-out pull | Return on a clause boundary, never mid-word. |
| `events_per_minute` | 2 | 1–4 (explainer) · 4–8 (podcast recut) | Above this the signal degrades. |
| `max_scale_native` | 1.20 | 1.10–1.20 | Hard ceiling when timeline resolution == source resolution. |
| `max_scale_4k_in_1080` | 2.00 | 1.5–2.0 | 4K in a 1080 timeline sits at 50% to fit, so 200% is still 1:1 pixels. |
| `sfx_offset` | −3f | −6f to 0f | If a sub/whoosh is used, its transient leads the punch by 0–6 frames. |

## Reproduction prompt

```
Add an emphasis punch-in to the A-roll clip at {{CLIP_ID}}.

1. From the word-level transcript, find the stressed word that carries the
   claim in this segment. Set {{IN}} = the frame of that word's onset,
   rounded DOWN to the nearest clause boundary within 8 frames. Set {{OUT}}
   = the end of that clause. Minimum {{OUT}}-{{IN}} = 45 frames (1.5s).
2. Check headroom: if source resolution == output resolution, cap scale at
   1.20. If source is 4K into a 1080 output, cap at 2.00. Choose
   punch_scale = 1.25 unless capped lower.
3. Apply the scale as an on-axis transform with transformOrigin
   "50% 38%" so the subject's eyes do not travel. Do NOT tween width or
   height. Do NOT reposition horizontally - a punch-in is on-axis.
4. Timing: hard change at {{IN}} (0 frames) is the default. If
   {{OUT}}-{{IN}} > 120 frames, use a 6-frame (0.2s) power2.out ramp
   instead so it reads as a push.
5. Return to 1.0 at {{OUT}} with a hard change, on the clause boundary.
6. Optional: place one low sub or short whoosh whose transient sits 3
   frames BEFORE {{IN}}, at -15 dB relative to dialogue.
7. ACCEPTANCE TEST: step the frames at {{IN}}-1 and {{IN}}. The subject's
   eyes must sit within 2% of frame height of where they were; the crop
   must not clip the top of the head or the chin; no visible softening at
   100% pixel view; and no second punch-in within 30 frames either side.
```

## Execution spec

**HyperFrames (primary).** A punch-in is a GSAP transform on the video element's wrapper, positioned in composition seconds on the single paused timeline. `scale` and `transformOrigin` are lint-clean; `width`/`height`/`top`/`left` are forbidden.

```html
<!-- shot-12 opens at 8.0s and runs 6.0s (240f). Punch at 10.4s, return at 13.4s. -->
<div id="shot-12-wrap" class="clip" data-start="8" data-duration="6" data-track-index="0"
     style="position:absolute; inset:0; overflow:hidden;">
  <video id="shot-12" src="aroll.mp4" muted playsinline
         style="width:100%; height:100%; object-fit:cover; transform-origin:50% 38%;"></video>
</div>
```
Time the **wrapper**, not the video: a `<video data-start>` inside a timed ancestor is the lint error `video_nested_in_timed_element`.

```js
// Hard punch to 1.25 at t=10.4s (312f), hard return at t=13.4s (402f).
// A 0.001s duration is a boundary set, not a tween — it renders as a cut.
tl.set("#shot-12", { scale: 1.25 }, 10.4);
tl.set("#shot-12", { scale: 1.0  }, 13.4);

// Ramped variant: 6 frames = 0.2s.
tl.fromTo("#shot-12", { scale: 1.0 }, { scale: 1.25, duration: 0.2, ease: "power2.out" }, 10.4);
```
Use `fromTo`, never `from` — `from()` writes its start state at construction time and flashes under the render engine's non-linear seek. Do not put a CSS `transform: scale()` on `#shot-12` as well; that is the `gsap_css_transform_conflict` error. Land the last tween before the clip's `data-duration`, since the visibility window is half-open.

If the punch belongs to a sub-composition, its scene-local `t` is `global_t − host data-start`; an accompanying SFX at the root needs `data-start = scene_local_t + host data-start`.

**ffmpeg (only if a baked file is required).** In-composition scaling needs no new file. Bake only when the punched shot leaves the pipeline:
```bash
# 1.25x on-axis punch with the origin on the eyeline (38% of height), 1080 out
ffmpeg -i shot.mp4 -vf "scale=2400:1350,crop=1920:1080:240:290" -c:a copy shot.punch.mp4
```
There is no rate/scale envelope in ffmpeg's crop filter chain worth authoring here — a ramped punch belongs in HyperFrames, not in a bake.

**Epidemic Sound (optional sub/whoosh).** `SearchSoundEffects` with `query.term: "cinematic sub drop short"` or `"soft whoosh short"`, `filter.duration.max: 900` (ms), `sort.by: POPULARITY`. Place per [[sfx-whoosh-transition-movement-reveal]] with `data-volume="0.18"` (≈−15 dB).

**Remotion:** conceptually an interpolated `scale` on the frame index; not available in this project.

## Pairs with
[[pace-cut-density-from-viewer-intent]] · [[sfx-whoosh-transition-movement-reveal]] · [[pace-silent-demonstration-window]] · [[cut-graphic-match]] · [[struct-numbered-list-mid-roll-sponsor]] · [[pace-overlay-instead-of-cut]]

## Failure modes
- **Punching in on an ordinary line.** Burns the signal; the next real emphasis reads as noise. Fix: one punch per claim, max 2–4 per minute, always transcript-anchored.
- **Frame-centre origin.** The eyes ride up toward the top edge and the shot looks like a mistake. Fix: `transform-origin: 50% 38%`.
- **Exceeding resolution headroom.** 1.4× on native 1080 softens skin and eyes visibly at 100% view. Fix: cap at 1.20 on native, shoot 4K when the style needs deep punches, and inspect at 100% not at fit-to-window.
- **Ramping when you meant to mark.** A 20-frame ease-in reads as a slow camera push and carries no "listen up" signal. Fix: hard cut, or ≤8 frames.
- **Punching mid-word on the return.** Reads as a dropped frame. Fix: snap both `{{IN}}` and `{{OUT}}` to clause boundaries from the word-level transcript.
- **Known gap:** there is no automatic face tracking or content-aware reframe in this stack — the origin and crop are authored geometry. If the subject moves during the punched window the framing will not follow, so pick a window where the head is stable.
