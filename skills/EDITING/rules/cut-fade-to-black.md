---
id: cut-fade-to-black
title: Black is the default fade colour — and what a non-black fade has to prove
skill: editing
type: transition
family: fade
tags: [skill/editing, type/transition, family/fade, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:23"
    quote: "And that colour is most commonly black."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:16"
    quote: "The fade is a classic, and it's when a shot dissolves or fades to or from a solid colour."
research_refs:
  - https://en.wikipedia.org/wiki/Fade_(filmmaking)
  - https://ffmpeg.org/ffmpeg-filters.html#fade
  - https://ffmpeg.org/ffmpeg-filters.html#signalstats
  - https://en.wikipedia.org/wiki/Match_cut
difficulty: low
detectable_from: video
---

# Black is the default fade colour — and what a non-black fade has to prove

## What it is
A fade is a transition to or from a solid colour, and unless there is a stated reason to do otherwise, **that colour is black**. Black is not a stylistic preference; it is the absence of signal. It is the state the display is in before the video starts and after it ends, so a fade to black reads as nothing more and nothing less than *"this section has ended"* — no mood, no metaphor, no colour association to manage. Every other terminal colour adds meaning, and added meaning has to be paid for.

This note owns the **colour decision** and the burden of proof a non-black colour carries. Its two siblings own the other halves of the fade: [[cut-fade-bookend]] owns *where* fades are allowed to go (structural boundaries, not inside scenes), and [[cut-fade-to-white]] owns the one non-black colour with an established convention behind it — white for death, dreams and altered states. Everything else — brand colours, a scene's dominant hue, a flash to a light source in frame — is uncharted, and the risk is specific and severe: **a fade to a colour the viewer cannot motivate is indistinguishable from a rendering error.**

Three conditions, together, are what make a non-black fade read as intentional. Miss any one and it reads as a mistake:

1. **Motivation in the picture.** The colour already exists on screen — it is the dominant hue of the outgoing shot, the colour of a practical light in frame, or the background the incoming scene opens on. A colour that appears from nowhere has no explanation available to the viewer.
2. **Establishment by repetition.** A brand colour has to have been seen at least twice before it is used as a fade colour, ideally in the intro. First use as a full-frame wash is where "is my player broken" lives.
3. **A hold long enough to be a decision.** A full-frame colour that appears and vanishes inside a few frames is a glitch. A colour held flat across the whole frame for a countable number of frames is a card.

## When to use it
**Black, by default,** at any boundary where the meaning is simply *this part is over*: the end of a chapter, the end of an act, the end of the video, a hard topic change, or the gap before a cold open resumes. Also as the neutral answer whenever a boundary needs weight and no other convention applies — black never says the wrong thing.

**Consider a non-black colour** only in these cases, and record the justification in the design document:

- The two shots either side share a strong dominant colour and fading through it makes the join a colour match rather than a break ([[cut-match-cut]], colour channel).
- The video has an established brand colour used consistently as a card background, and the fade is landing on that card ([[motion-list-item-marker-card]], [[struct-numbered-list-mid-roll-sponsor]]).
- The next scene opens on a light source and fading up from that colour reads as the light arriving.
- White, specifically, for the dream/memory/death register — that is [[cut-fade-to-white]]'s business, not this note's.

Do **not** fade to a colour to "add production value", to match a thumbnail, or because black felt boring. Boring is what black is for.

## How to recognise it in a reference video
- **Frame-average luma trajectory.** Trace `YAVG` across the boundary:
  ```bash
  ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=-" -f null -
  ```
  A fade to black shows a **monotonic decline to YAVG ≤ 8** (0–255 scale; ≤ 20 if the source is limited-range and untagged), a **flat hold**, then a rise. A dissolve does not reach the floor. A black-frame dropout has **no ramp at all** — it goes from normal to zero in one or two frames and back.
- **Chroma goes neutral with it.** In a true fade to black, `UAVG` and `VAVG` converge on **128 ± 3** as luma falls. If chroma survives at low luma, the shot merely got dark — a night exterior, a lens cap, a dip — not a fade.
- **Count the hold.** Frames at the floor, measured:
  - **0–2 frames** → a *dip to black*, punctuation inside a scene, not a section boundary. Log it as [[pace-deliberate-continuity-break]].
  - **3–10 frames** → a short act break; the video keeps moving.
  - **10–30 frames** → a full structural boundary. This is the common case.
  - **30+ frames** → an ending, or a deliberate breath before something large.
- **Fade length bands.** The published convention for fades and dissolves is **1 to 2 seconds (24–48 frames)**, varying with the director's preference. At 30 fps read it as: **20–35 f (0.67–1.17 s)** brisk section boundary · **36–60 f (1.2–2.0 s)** standard act boundary · **60–120 f (2–4 s)** opening or closing the whole piece. Under 12 f is a dip, not a fade.
- **Symmetry.** Fade-out and the following fade-in are usually within **30%** of each other in length. Wildly asymmetric lengths mean one side is doing something else — an iris, a light leak, a whip.
- **Non-black colour test.** If the terminal frame is not black, measure `YAVG`/`UAVG`/`VAVG` at the hold and compare against the mean of the 30 frames before the fade started. If the terminal colour is **within ±15 (chroma) of the outgoing shot's dominant colour**, it is motivated. If it is not, look for the same colour elsewhere in the video before concluding it is intentional — and if it appears exactly once, log it as *unmotivated, probable error*.
- **Audio confirms it.** A structural fade almost always has a music gesture with it — a bed ending, a fade-out, or a rest ([[sfx-music-fade-out-section-signal]], [[sfx-music-rest-windows]]). Picture fading to black over an unchanged bed reads as an accident and is worth logging as a defect in the reference, not as a technique.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `colour` | black | black · white · motivated scene colour · established brand colour | Anything but black must satisfy all three conditions in *What it is*. |
| `black_value` | `#000000` (full range) | Y′ 0–16 | If the deliverable is limited-range, the floor is code **16**, not 0. Fading to 0 in a limited-range pipeline can crush and band. |
| `fade_out_length` | 45 f (1.5 s) | 20–120 f | 24–48 f is the published convention; the wider range covers brisk section breaks and full openings/closings. |
| `hold_at_colour` | 15 f (0.5 s) | 0–60 f | 0–2 f = dip, 10–30 f = structural boundary, 30+ f = ending. |
| `fade_in_length` | 45 f (1.5 s) | 20–120 f | Keep within 30% of the fade-out unless asymmetry is the point. |
| `curve` | ease-in-out | linear · ease-in-out | Linear luminance is the classic film look. `sine.inOut` in GSAP for a slightly softer entry and exit. |
| `non_black_min_hold` | 15 f (0.5 s) | 12–30 f | A non-black colour needs a longer hold than black to read as a decision rather than a flash. |
| `non_black_prior_uses` | ≥ 2 | 2–∞ | The colour must have appeared on screen at least twice before it is used as a fade colour. |
| `audio_gesture` | required | — | The bed fades, stops, or rests across the fade. A picture-only fade reads as a fault. |
| `uses_per_video` | 2–4 | 0–6 | Fades are structural punctuation. More than about four in a ten-minute video and the structure stops being legible. |

## Reproduction prompt

```
Place a fade to black at boundary {{BOUNDARY_TC}} in composition {{COMP}}.
Frames at 30fps; HyperFrames time is authored in SECONDS.

1. Confirm this is a STRUCTURAL boundary - end of a section, act, or the
   video. If the boundary is inside a scene, stop and use a hard cut or a
   dissolve instead (see cut-fade-bookend).
2. Use BLACK unless all three of these are true, in which case record the
   justification and the colour's prior on-screen appearances:
     (a) the colour is already visible in the outgoing or incoming shot, or
         is an established brand colour;
     (b) it has appeared on screen at least twice earlier in the video;
     (c) you will hold it flat for at least 15 frames.
3. Timing, in composition seconds:
     fade_out : starts at {{BOUNDARY_TC}} - 1.5, ends at {{BOUNDARY_TC}}
     hold     : {{BOUNDARY_TC}} to {{BOUNDARY_TC}} + 0.5
     fade_in  : {{BOUNDARY_TC}} + 0.5 to {{BOUNDARY_TC}} + 2.0
   Fade lengths must be within 30% of each other.
4. Build it as a full-bleed colour layer ABOVE the picture, not by fading the
   picture itself: a div with position:absolute; inset:0; background:#000,
   given data-start and data-duration, animated with GSAP autoAlpha 0 -> 1 ->
   0 via fromTo (never from). Do not tween display or raw visibility on a
   clip element. Land each tween's end state at least 1 frame before the
   layer's data-duration elapses.
5. Cut the audio gesture on the same boundary: the bed fades out across the
   picture fade, or stops at the start of the hold. A silent picture fade
   over a running bed is a defect.
6. Ambience continues through the hold unless the hold is the end of the
   video. A hold at both digital black and digital silence reads as a
   dropout.
7. ACCEPTANCE TEST: render or snapshot the boundary and run
   ffmpeg -i {{OUT}} -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=-" -f null -
   Confirm YAVG declines monotonically to <= 8, holds for the intended frame
   count +/- 2 frames, then rises. Confirm UAVG and VAVG reach 128 +/- 3 at
   the hold. Then watch at full speed once and confirm the hold does not read
   as a stall or as a dropped frame.
```

## Execution spec

**HyperFrames (primary).** There is **no fade transition primitive** and no `data-transition` attribute — the machine transition registry contains exactly five entries (`crossfade`, `blur-crossfade`, `push-slide`, `zoom-through`, `squeeze`) and none of them is a fade to a colour. Build it as a full-bleed colour clip driven by the composition's single paused GSAP timeline.

```html
<!-- Boundary at 96.0s. Full-bleed black layer, 96.0-1.5 = 94.5 through 98.0. -->
<div id="fade-black" class="clip"
     style="position:absolute; inset:0; background:#000; opacity:0;"
     data-start="94.5" data-duration="3.6" data-track-index="5"></div>
```

```js
// Fade out 94.5 -> 96.0, hold to 96.5, fade in (reveal picture) 96.5 -> 98.0.
// Positions are ABSOLUTE composition seconds, not delays.
tl.fromTo("#fade-black", { autoAlpha: 0 }, { autoAlpha: 1, duration: 1.5, ease: "sine.inOut" }, 94.5);
tl.to("#fade-black", { autoAlpha: 0, duration: 1.5, ease: "sine.inOut" }, 96.5);
```

Six constraints, each of which is a real failure if ignored:

- **`fromTo`, never `from`.** `gsap.from()` sets `immediateRender: true` and writes its start state at construction time, before the clip's window opens; under the render engine's non-linear seek the element flashes or skips its entrance.
- **`autoAlpha`, not `display` or raw `visibility`.** The framework owns clip visibility and lint rejects tweening it on a clip element.
- **The tween must land before `data-duration` elapses.** The window is half-open — `[start, start + duration)` — so an animation resolving exactly on the boundary never renders its last frame. Here the layer runs to 98.1 and the final tween lands at 98.0.
- **Give it an explicit sized box.** Root-level clips carrying `data-start` are forced to `position: absolute` and sized to 100% when they have no computed size, but authoring `position:absolute; inset:0` explicitly is what keeps it correct if it is ever nested. An untimed full-bleed element without it collapses to zero height.
- **Do not put the fill on the composition root.** A full-screen fill on the root is dropped on the layered-composite path (HDR, or any composition using shader transitions). Full-bleed **child**, always.
- **Layering is CSS `z-index`, not `data-track-index`** — the track index is display only and *"is not read by the render, and it constrains nothing."* Give the fade layer a `z-index` above the picture and below anything that must survive the fade (rarely: a persistent logo).

Cheaper alternative when the boundary is between two **sub-compositions** and you want a dip rather than a hold: the registry's `crossfade` at its 0.5 s default, with both scene roots painted the same background colour, produces a very short black passage without an extra layer. It is not the same gesture — there is no hold — so only use it where the design calls for a dip.

**ffmpeg.** For a fade baked into a source file, or into a deliverable leaving the pipeline:
```bash
# fade to black over 1.5s starting at 94.5s, then back up at 96.5s
ffmpeg -i in.mp4 -vf "fade=t=out:st=94.5:d=1.5:color=black,fade=t=in:st=96.5:d=1.5:color=black" \
       -c:v libx264 -preset veryfast -crf 18 -c:a copy out.mp4
```
`color` accepts `black`, `white` or a hex value — that argument is the whole non-black decision in one place, which is exactly why it should carry a comment naming the justification. Fade the audio with `afade` on the same times if the bed is baked in too (see [[sfx-music-fade-out-section-signal]] for curve choice). Note this re-encodes: do not attempt it with `-c copy`.

**Epidemic Sound.** No asset needed for the picture fade. The paired audio gesture usually is: either the current bed's fade-out (authored, no fetch), or a low sustained tone under the hold — `SearchSoundEffects` with `query.term: "cinematic sub drone low tone"` and `filter.duration {min: 2000, max: 8000}` (milliseconds). Keep it in the `sfx` group, never the voice group.

**Remotion:** an `<AbsoluteFill backgroundColor="black">` with opacity driven by `interpolate(frame, ...)`; frames are native there. Not present in this project.

## Pairs with
[[cut-fade-bookend]] · [[cut-fade-to-white]] · [[cut-dissolve]] · [[cut-dissolve-time-passage]] · [[sfx-music-fade-out-section-signal]] · [[sfx-music-rest-windows]] · [[struct-closing-recap-single-cta]] · [[cut-match-cut]] · [[pace-deliberate-continuity-break]] · [[motion-look-finishing-pass]]

## Failure modes
- **A non-black colour with no motivation.** The single most common way a fade looks amateur: a full-frame wash of a colour that appears nowhere else. The viewer's first hypothesis is a rendering fault. Fix: use black, or establish the colour twice beforehand and hold it 15+ frames.
- **A mid-luminance colour.** Fades to mid-grey, mid-blue or a desaturated pastel land exactly in the zone where the frame looks like a decode error. Fix: go dark (near-black) or go bright and fully desaturated (white); avoid the middle unless the colour is a hard brand asset.
- **No hold.** A fade that reaches black and immediately comes back is a dip, and reads as a dropped shot rather than a section boundary. Fix: 10–30 frames at the floor for a structural boundary.
- **Fading the picture but not the sound.** The most reliable amateur tell. Fix: pair every picture fade with a music gesture on the same frames.
- **Fading inside a scene.** Fades announce structure; used mid-argument they announce a structure that is not there. Fix: dissolve or hard cut — see [[cut-fade-bookend]].
- **Fading to code 0 in a limited-range deliverable.** Crushes shadow detail on the way down and can band on gradients. Fix: floor at code 16 for limited range, and dither if the fade shows contouring.
- **Too many fades.** Six fades in ten minutes makes every section feel like the end of the video. Fix: budget 2–4, and use hard cuts for topic changes that are not structural.
- **Known gap:** HyperFrames has no fade-to-colour transition in the registry, so this is always hand-authored DOM plus a hand-written tween — nothing lints it and nothing verifies the hold length. The only verification is a rendered `signalstats` trace, and the render is browser-dependent, so it must run off the authoring VM.
