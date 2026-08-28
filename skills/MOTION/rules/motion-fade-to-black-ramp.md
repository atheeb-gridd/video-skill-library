---
id: motion-fade-to-black-ramp
title: The fade-to-black ramp — curve, hold, and the mid-fade gamma trap
skill: motion
type: transition
family: fade
tags: [skill/motion, type/transition, family/fade, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:23"
    quote: "And that colour is most commonly black, whereas a fade to white might be used to show the character dying or in a dream."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://www.adobe.com/creativecloud/video/discover/whip-pan.html
  - https://gsap.com/docs/v3/Eases
  - https://www.nngroup.com/articles/animation-duration/
difficulty: low
detectable_from: video
---

# The fade-to-black ramp — curve, hold, and the mid-fade gamma trap

## What it is
Black is the default fade colour because it carries no connotation beyond "this section has ended"; every other colour has to earn its meaning ([[cut-fade-to-black]] owns that editorial decision). This note is the ramp itself: how long the luminance takes to fall, on what curve, how long the frame sits at true black before the next image, and the two technical traps that make an otherwise correct fade look wrong — compositing a fade in gamma-encoded space, and letting the engine's half-open clip window eat the darkest frame.

Three distinct devices share the same ramp and must not be confused: the **fade out** (picture to black, end of a section or video), the **dip to black** (out, hold, in — a compressed time-passage marker), and the **fade up** (black to picture, opening).

## When to use it
- **End of video**, over the last held frame or the outro card: the long ramp (1.2–2.0 s).
- **Section boundary** in a chaptered explainer, usually with the music already stopped or landing at a waveform peak ([[sfx-music-fade-out-section-signal]], [[motion-waveform-playhead-scrub]]).
- **Dip to black between two acts** where a dissolve would read as dreamy and a cut as abrupt — the hold at black is the time-passage signal.
- **Fade up from black at the top** of a cold open, 0.5–1.0 s, so the first frame is not a hard slam.
- **Not** between two shots inside a continuous scene (that is a dissolve or a cover), and not as a fix for a bad cut — a fade to black at a mid-section cut reads as an accident or a missing clip.

## How to recognise it in a reference video
- **Sample mean luminance per frame** across the seam: `ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:file=/tmp/luma.txt" -f null -`. The signature is a monotonic fall to (near) zero, an optional flat floor, then a rise.
- **Measure the ramp in frames.** Quick dip 6–10 f (0.2–0.33 s); standard section fade 15–30 f (0.5–1.0 s); end-of-video 36–60 f (1.2–2.0 s). A 3–5 frame fade is a soft cut, not a fade.
- **Measure the hold at black.** 0 frames = soft cut feel; **2–8 f (0.07–0.27 s)** = deliberate dip; **>15 f** = a beat of silence, usually paired with no audio. The hold is the single most informative parameter, so always log it.
- **Check the floor.** True black (Y ≈ 16 in limited range / 0 in full range) versus a floor at 5–10% grey. A grey floor is either an unfinished fade or a stylistic choice — log which.
- **Check what the audio does.** Three patterns: audio fades with picture (matched), audio continues under black (bridge into the next section — a J-cut relationship, see [[cut-j-audio-leads-picture]]), or audio has already stopped before the fade begins (the most common in retention edits). Note which.
- **Look for a mid-fade dip in a dissolve.** In a cross-dissolve between two similarly bright shots, a visible darkening at the midpoint means it was blended in gamma-encoded space: encoded 0.5 corresponds to only about **0.5^2.2 ≈ 22%** of linear light. A dissolve without that dip was done in linear light or S-curve compensated.
- **Colour tell:** a fade whose midpoint is warm or blue-tinted was faded to a colour, not to black ([[cut-fade-to-solid-colour]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `fade_out_section` | 0.7 s (21 f) | 0.5–1.0 s | Standard section boundary. |
| `fade_out_end` | 1.5 s (45 f) | 1.2–2.0 s | End of video. Slowest thing in the edit. |
| `dip_out` | 0.27 s (8 f) | 0.20–0.40 s | Dip-to-black leg 1. |
| `hold_at_black` | 0.13 s (4 f) | 0.07–0.27 s (2–8 f) | The time-passage signal. 0 = soft cut. |
| `dip_in` | 0.30 s (9 f) | 0.20–0.45 s | Leg 3; equal to or slightly longer than leg 1. |
| `fade_up_open` | 0.8 s (24 f) | 0.5–1.2 s | Black to picture at the top. |
| `curve_out` | `power1.in` | `none`–`power2.in` | Slightly accelerating fall reads natural in gamma-encoded compositing. `none` is acceptable and standard. |
| `curve_in` | `power1.out` | `none`–`power2.out` | |
| `floor` | true black | 0–8% grey | Author `#000`; a grey floor must be deliberate. |
| `colour` | `#000000` | — | Default. Any other colour must justify itself ([[cut-fade-to-solid-colour]]). |
| `audio_relationship` | already stopped | stopped \| matched \| bridged | Decide explicitly; never leave it to whatever the clip does. |
| `audio_fade_extra` | +0.10 s | 0 to +0.30 s | If matched, let audio finish slightly after picture — never before. |
| `end_hold_frames` | 3 f | 2–6 f | Frames of black held **after** the ramp so the darkest frame is actually rendered. |

## Reproduction prompt

```
Author a fade to black at {{OUT}}.

CHOOSE THE DEVICE. Section boundary: fade out 0.7s and hold black 4 frames
before the next scene starts. End of video: fade out 1.5s and hold 6 frames.
Dip to black between acts: 0.27s out, 4-frame hold, 0.30s in.

MECHANISM. Do not fade the composition root and do not rely on a root
background colour - on the layered-composite path a root fill is dropped. Add
a full-bleed black plate as the topmost clip (z-index above every scene, its
own data-start/data-duration, NOT an ancestor of the scenes) and ramp its
autoAlpha 0 -> 1 with ease power1.in. Its data-duration must extend at least 3
frames past the moment alpha reaches 1, because a clip is hidden at exactly
start+duration and the last frame of a tween that lands on the boundary is
never rendered.

TIMING. Author every value in seconds on the frame grid: at 30fps use
multiples of 0.0333 (0.7s = 21f, 4f hold = 0.1333s). If the render fps may
change, recompute - 0.7s is 21f at 30 but 16.8f at 24.

AUDIO. State the relationship explicitly. Default: the music has already
stopped at a waveform peak before the fade begins, and only ambience or
silence remains. If audio is matched to picture, let its volume automation
lane reach 0 about 0.10s AFTER the picture reaches black, never before.

ACCEPTANCE TEST: sample mean frame luminance across the event and confirm a
monotonic fall to <= 2% with the intended number of black frames actually
present in the render, then a rise. Confirm no frame of the next scene appears
before the hold ends, and that no audio artefact (a click or a truncated tail)
occurs at the black.
```

## Execution spec

**HyperFrames.** A black plate clip plus one alpha tween; timing in seconds, frames as comments.

```html
<!-- topmost plate; a sibling of the scenes, never their parent -->
<div id="fadeplate" class="clip" data-start="27.0" data-duration="1.1" data-track-index="9"
     style="position:absolute; inset:0; z-index:95; background:#000; opacity:0;"></div>

<div id="el-scene-c" class="clip" data-composition-src="compositions/c.html"
     data-start="20" data-duration="7.8" data-track-index="0"></div>
<div id="el-scene-d" class="clip" data-composition-src="compositions/d.html"
     data-start="27.83" data-duration="8" data-track-index="1"></div>
```

```js
// 0.7s = 21f @30fps fall, then a 4f hold (0.1333s) before scene D starts at 27.83
tl.fromTo("#fadeplate", { autoAlpha: 0 },
  { autoAlpha: 1, duration: 0.7, ease: "power1.in" }, 27.0);
tl.to("#fadeplate", { autoAlpha: 1, duration: 0.1333 }, 27.7);   // explicit hold
tl.to("#fadeplate", { autoAlpha: 0, duration: 0.30, ease: "power1.out" }, 27.83); // dip-in leg
```

Contract points that bind this:
- **The half-open window is the trap.** A clip shows while `start ≤ t < start+duration`, so *"land an animation's resolved end state slightly before `data-duration`, not on it, or its last frame is never rendered."* Give the plate 3+ frames of headroom past full black.
- **The plate is a sibling.** A timed ancestor clamps its descendants, so wrapping the scenes in the plate would hide them.
- Root `data-duration` is read **once at compile time** — a fade at the very end cannot extend render length from a script or `--variables`. Budget the outro black into the root duration up front.
- A **root** full-screen fill is dropped on the layered-composite path (HDR, or any project using shader transitions) — hence a plate child, not a root background.
- `autoAlpha`, not `display`/`visibility`; the framework owns clip visibility and lint rejects tweening it.
- Never a CSS `transition` on the plate — *"they interpolate independently of seek and flicker."*
- The registry's `crossfade` (0.5 s, `power2.inOut`) is the machine-ready **dissolve**; a fade to black is not a crossfade and should not be authored as one.
- Audio: fade with a `volume` **automation lane** (clip-local `t`, first value held backwards to the clip start) or a GSAP `volume` tween — never both on one track (`audio_volume_double_automation`: the lane wins, silently).

**ffmpeg — baked version.** Options are exactly `type`, `start_time`/`start_frame`, `duration`/`nb_frames`, `color`:

```bash
# picture fade out 0.7s at t=27.0 plus a matched audio fade
ffmpeg -i in.mp4 -vf "fade=t=out:st=27.0:d=0.7:color=black" \
                 -af "afade=t=out:st=27.0:d=0.8" out.mp4
# dip to black across a join, expressed as out+in on the concatenated file
ffmpeg -i joined.mp4 -vf "fade=t=out:st=27.0:d=0.27,fade=t=in:st=27.4:d=0.30" dip.mp4
# audit any reference
ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:file=/tmp/luma.txt" -f null -
```
Frame-exact variants use `start_frame`/`nb_frames` instead of times — preferable when the fade must be an exact frame count.

**Remotion:** an `<AbsoluteFill backgroundColor="black">` whose opacity is `interpolate(frame, [a, b], [0, 1])` — concept only.

## Pairs with
[[cut-fade-to-black]] · [[cut-fade-to-solid-colour]] · [[cut-fade-to-white]] · [[cut-fade-bookend]] · [[cut-dissolve-time-passage]] · [[motion-colour-dip-transition]] · [[sfx-music-fade-out-section-signal]] · [[motion-light-leak-overlay-transition]] · [[motion-impact-frame-quantisation]]

## Failure modes
- **The darkest frame never renders.** The tween lands exactly on `data-duration` and the clip is already hidden there; the fade appears to stop at 90%. Correction: 3+ frames of plate headroom past full black.
- **No hold at black.** Out-and-straight-back-in reads as a flicker or a dropped frame rather than a passage of time. Correction: 2–8 frames of hold, and log it as a deliberate value.
- **Grey floor.** A fade that bottoms out at 6% grey looks like an unfinished render. Correction: `#000` and verify ≤2% mean luminance.
- **Audio ending before picture.** Silence over a still-visible image reads as a technical fault. Correction: audio reaches 0 about 0.1 s after the picture does, or has already stopped well before.
- **Fading the root or relying on the root background.** On the layered-composite path the fill is dropped and the fade reveals nothing. Correction: a full-bleed plate child.
- **Using a fade to hide a bad cut mid-section.** Reads as a missing clip. Correction: fix the cut, or use a cover transition ([[motion-light-leak-overlay-transition]], [[motion-whip-pan-transition]]).
- **Mid-dissolve dip.** If you build a cross-dissolve rather than a fade and it darkens at the midpoint, that is gamma-space blending (encoded 0.5 ≈ 22% linear light). Correction: shorten the overlap, S-curve the two opacity ramps, or blend in linear light outside the browser.
- **Known gap:** browser compositing of `opacity` happens in gamma-encoded sRGB and there is no per-composition switch to linear-light blending in this stack — for a fade to black that is harmless (it reads perceptually even), for a long dissolve between two bright shots it is a real limitation. Do the dissolve in ffmpeg if the dip matters.
