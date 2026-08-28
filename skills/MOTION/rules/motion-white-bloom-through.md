---
id: motion-white-bloom-through
title: Bloom through white, don't dissolve to it — the dream and death transition
skill: motion
type: transition
family: fade
tags: [skill/motion, type/transition, family/fade, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:23"
    quote: "And that colour is most commonly black, whereas a fade to white might be used to show the character dying or in a dream."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:16"
    quote: "The fade is a classic, and it's when a shot dissolves or fades to or from a solid colour."
research_refs:
  - https://en.wikipedia.org/wiki/Bloom_(shader_effect)
  - https://en.wikipedia.org/wiki/Fade_(filmmaking)
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://developer.mozilla.org/en-US/docs/Web/CSS/filter
  - https://helpx.adobe.com/after-effects/using/stylize-effects.html
difficulty: medium
detectable_from: video
---

# Bloom through white, don't dissolve to it — the dream and death transition

## What it is
The motion execution of the fade-to-white convention ([[cut-fade-to-white]]). The convention is cheap — swap the terminal colour and the boundary changes meaning from *closure* (black) to *dying, dreaming, remembering, transcending* (white). The execution is where it fails: a linear opacity crossfade to a white matte is indistinguishable from a blown-out exposure error, because nothing about it looks like light. A **bloom-through** looks like light because it does what light does — the highlights clip first and bleed outward, the image loses saturation before it loses detail, and the frame is overwhelmed from the bright areas outward rather than veiled uniformly.

That is the mechanism bloom imitates in the first place: an Airy disk spreading a point source beyond its natural borders, and charge overflowing from saturated photodiodes into adjacent pixels. Built as threshold → blur → additive composite, it reads as a camera being overwhelmed. Built as a dissolve, it reads as a mistake.

## When to use it
At a boundary where the story leaves the concrete world: into or out of a memory, a dream, an imagined scenario, a hypothetical the narrator sets up ("imagine your edit was so good that…"), a reconstruction, a death, or a final beat meant to feel open rather than finished. In non-fiction the reliable triggers are the **hypothetical** and the **reconstruction**; the reliable *anti*-trigger is a plain section change, which wants black, a dissolve, or a cut.

Use black when the boundary means *this is over*. Use a dissolve when it only means *time passed*. Use this when the boundary means *we are leaving reality*, and use it **once or twice in a video** — it is the loudest fade there is, and the second one costs the first one its meaning.

## How to recognise it in a reference video
- **Sample the luma histogram every 2 frames across the transition.** A bloom-through shows the **highlight tail clipping 6–14 frames before the mean peaks** — bright areas hit 100 % first and grow. A plain dissolve-to-white shows the whole histogram translating uniformly rightward with no early clipping.
- **Saturation leads luminance.** Measure `SATAVG`: in a bloom-through it falls **before** `YAVG` peaks, typically starting 4–10 frames earlier. In a dissolve both move together.
- **Look for blur growth.** A bloom-through adds 6–20 px of blur at 1080p as it goes white; a dissolve stays sharp until it disappears. Frame-step and check whether edges soften on the way out.
- **Measure the asymmetry.** The classic shape is **fast in, slow out**: roughly 0.6–1.0 s into white, a 0.2–0.6 s white hold, then 1.0–1.8 s emerging. A symmetric ramp reads as a technical fade; the asymmetry is what reads as regaining consciousness.
- **Check for a white plateau.** Frames at or near 100 % across the whole frame, held **6–18 frames**. Zero plateau frames means it is a dissolve; more than about 30 frames and the viewer thinks the file broke.
- **Look for a slow scale push** of 2–8 % across the ramp. Nearly universal in the dream register and nearly absent in the technical fade.
- **Audio is the confirmation.** Under a real bloom-through the outgoing audio gets a **reverb tail and a low-pass sweep** (highs disappearing as if underwater), often into near-silence at the plateau, and the incoming scene arrives dry. Measure spectral centroid across the transition — a downward slide of an octave or more is the tell.
- **Transcript correlation.** The ramp starts on or just after the word that opens the hypothetical ("imagine", "picture this", "back when", "what if"), not at the sentence end.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `ramp_in_duration` | 0.80 s (24 f) | 0.50–1.20 s (15–36 f) | Fades run **1–2 s (24–48 f)** by convention; the bloom half sits at the fast end because the white hold carries the rest. Ease `power2.in` — slow start, accelerating into white. |
| `white_hold` | 0.30 s (9 f) | 0.20–0.60 s (6–18 f) | The beat where the viewer has nothing. Zero = dissolve; >1 s = broken file. |
| `ramp_out_duration` | 1.40 s (42 f) | 1.00–1.80 s (30–54 f) | Ease `power2.out`. **Always longer than the ramp in** — this asymmetry is the whole register. |
| `total_transition` | 2.5 s | 1.7–3.6 s | Note the registry's Tier-B `max_duration_s` is **2.0 s**, so anything longer must be hand-authored, not injected as a registry transition. |
| `brightness_peak` | 2.6× | 2.0–3.5× | Where the image is driven before the white plate takes over. Below 2.0 the highlights never clip and it reads as a dissolve. |
| `bloom_blur_peak` | 14 px @1080p | 6–24 px | Grows with brightness. Above ~24 px the outgoing image is unrecognisable too early. |
| `saturation_at_peak` | 0.35 | 0.20–0.60 | Desaturation leads. Colour surviving into a white-out reads as a colour cast, not as light. |
| `saturation_lead` | 0.20 s (6 f) | 0.13–0.33 s (4–10 f) | How far ahead of the luminance peak the desaturation starts. |
| `scale_push` | 1.05 | 1.02–1.08 | Over the ramp in, `power1.inOut`. Continue it through the plateau so the emerging shot is already moving. |
| `white_colour` | `#FFFFFF` | `#FFF` to `#FFF8EE` | A hair of warmth (2–8 % toward amber) reads as sunlight; pure white reads as a UI element. |
| `audio_lowpass_sweep` | 18 kHz → 800 Hz | down to 400–1500 Hz | Across the ramp in, on the outgoing bed. The single strongest confirmation cue. |
| `audio_reverb_tail` | 1.2 s | 0.8–2.5 s | Applied to the outgoing, spilling across the plateau. |
| `plateau_level` | −30 dB | −40 to −24 dB | Not silence, not full. Something must be under the white or it feels like a dropout. |
| `uses_per_video` | 1 | 1–2 | Third use and the device is a habit, not a meaning. |

## Reproduction prompt

```
Build a bloom-through-white transition from scene A to scene B at {{T}}
(the frame where the hypothetical or memory begins).

RAMP IN (0.80s, {{T}} to {{T}}+0.80, ease power2.in on every property):
  - scene A brightness 1.0 -> 2.6
  - scene A saturation 1.0 -> 0.35, STARTING 0.20s EARLIER than the
    brightness ramp so colour leaves before light arrives
  - scene A blur 0 -> 14px
  - scene A scale 1.00 -> 1.05, ease power1.inOut
  - a full-frame white plate above scene A: opacity 0 -> 1 over the LAST
    0.35s of the ramp only, ease power2.in. The plate finishes the move; it
    must not carry it.
WHITE HOLD: 0.30s of full white. Keep the scale push running underneath.
RAMP OUT (1.40s, ease power2.out, mirrored):
  - white plate opacity 1 -> 0 over the first 0.5s
  - scene B brightness 2.2 -> 1.0, saturation 0.5 -> 1.0, blur 10px -> 0
  - scene B scale 1.05 -> 1.00
Scene B must be LIVE and already playing under the plate before the plate
clears - never start scene B at the moment the white ends.

AUDIO, authored on the same numbers:
  - outgoing bed: low-pass sweep 18kHz -> 800Hz across the ramp in, plus a
    1.2s reverb tail that spills over the plateau
  - plateau: everything at about -30dB. Not silence, not full.
  - incoming: dry, at full level, from the start of the ramp out.

CONSTRAINTS: use this at most twice in the video. Do not use it for a plain
section change - that is a cut, a dissolve, or a fade to black. The white must
never exceed 1.0s total on screen.

ACCEPTANCE TEST: extract every frame of the transition. (1) Highlights must
reach 100% at least 6 frames before the frame mean peaks. (2) Mean saturation
must start falling before mean luma starts rising. (3) There must be 6-18
frames of near-total white and no more. (4) The out ramp must be at least
1.5x longer than the in ramp. Then watch it once at 1x with sound: if your
first read is "blown-out export", the plate is doing too much of the work -
raise the brightness peak and shorten the plate's opacity ramp.
```

## Execution spec

**HyperFrames.** Hand-authored, not a registry transition — the registry's five Tier-B entries (`crossfade`, `blur-crossfade`, `push-slide`, `zoom-through`, `squeeze`) have no white-bloom member and its `max_duration_s` is 2.0. Build it on the two scene wrappers plus one plate.

```html
<div id="white-plate" style="position:absolute; inset:0; background:#FFFCF6; opacity:0; pointer-events:none;"></div>
```

```js
const T = 128.0, IN = 0.80, HOLD = 0.30, OUT = 1.40;

// saturation leads by 6 frames
tl.to("#el-scene-a", { filter: "brightness(1) saturate(0.35) blur(0px)",
                       duration: IN - 0.20, ease: "power2.in" }, T);
tl.to("#el-scene-a", { filter: "brightness(2.6) saturate(0.35) blur(14px)",
                       duration: 0.20, ease: "power2.in" }, T + IN - 0.20);
tl.to("#el-scene-a", { scale: 1.05, duration: IN + HOLD, ease: "power1.inOut" }, T);
tl.to("#white-plate", { opacity: 1, duration: 0.35, ease: "power2.in" }, T + IN - 0.35);

// scene B is live under the plate before it clears
tl.fromTo("#el-scene-b",
  { filter: "brightness(2.2) saturate(0.5) blur(10px)", scale: 1.05 },
  { filter: "brightness(1) saturate(1) blur(0px)", scale: 1.0,
    duration: OUT, ease: "power2.out" }, T + IN + HOLD);
tl.to("#white-plate", { opacity: 0, duration: 0.50, ease: "power2.out" }, T + IN + HOLD);
```

Contract points that bind this:
- **Overlap the two scenes.** Extend `#el-scene-a`'s `data-duration` so it holds its last frame through the ramp, and pull `#el-scene-b`'s `data-start` **earlier** by the transition length — this is exactly how the registry's injector creates an overlap. Put the two wrappers on different `data-track-index` values as a readability convention (it constrains nothing at render; layering is CSS `z-index`).
- **Outgoing and incoming animate at the same time `T`.** The four non-negotiable multi-scene rules: every composition uses transitions; every scene uses `fromTo` entrances; **exit animations are banned except on the final scene** because *the transition is the exit*; only the last scene may fade out.
- **The white plate must not be the composition root's background.** A full-screen fill on the **root** is dropped on the layered-composite path (HDR, or any composition using shader transitions) — put the fill on a full-bleed child with `position:absolute; inset:0`.
- **Untimed elements get no automatic layout.** An overlay without `data-start` is skipped by the root-clip layout pass, so it needs its own `position:absolute; inset:0` or it collapses to zero height.
- **Filter tweens are lint-clean on the master timeline**, and `filter` interpolates as a function list — keep the same functions in the same order in both the from and the to state or the interpolation falls back to a discrete swap.
- **No CSS `transition` on animated elements** — they interpolate independently of seek and flicker in the render.
- **`fromTo`, never `from`.**
- If the project uses shader transitions, `@hyperframes/shader-transitions` offers `light leak`, `overexposure burn` and `film burn` in the light category of the broad catalog — **names only; the implementations are not staged here**, so cite them as an alternative and do not emit code for them.

**ffmpeg — when the transition is baked between two files.**

```bash
# push A into white with a real exposure ramp + bloom, then hard fade the last stretch
ffmpeg -i A.mp4 -filter_complex "\
  [0:v]exposure=exposure='if(gt(t,10),(t-10)*1.6,0)':black=0,\
       gblur=sigma='if(gt(t,10),(t-10)*17,0)',\
       eq=saturation='if(gt(t,9.8),max(0.35,1-(t-9.8)*1.6),1)',\
       fade=t=out:st=10.45:d=0.35:c=white[v]" -map "[v]" A.white.mp4

# emerge into B (mirror), then concat A.white and B.white
ffmpeg -i B.mp4 -vf "fade=t=in:st=0:d=0.5:c=white,eq=saturation='min(1,0.5+t*0.36)'" B.white.mp4
printf "file '%s'\n" A.white.mp4 B.white.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy out.mp4
```
`fade`'s `c`/`color` option is what makes it a white fade rather than the default black; `exposure` supplies the brightness drive; `gblur`'s sigma is the bloom radius; `eq=saturation` supplies the lead. Note the general rule: **only cut a physical file when exporting or assembling outside the composition** — in-composition this whole transition is filter tweens on two wrappers.

**Epidemic Sound.** Two fetches. The tail: `SearchSoundEffects { query: { term: "cinematic whoosh reverse riser dreamy" }, filter: { duration: { min: 1500, max: 4000 } } }`. The plateau texture: `SearchSoundEffects { query: { term: "ambient tone drone soft" }, filter: { duration: { min: 4000 } } }` at −30 dB. The low-pass sweep is **not** a fetch — it is an automation lane on the outgoing bed's `lowpass` node: `{"target":"fx.n1.frequency","points":[{"t":0,"v":18000},{"t":0.8,"v":800}]}`, remembering that a lane's first value holds backwards to the clip start and that `t` is **clip-local** on a clip and **composition time** on an `<hf-audio-group>` bus. The `lowpass` filter's `frequency` is automatable (100–20000 Hz, log). Reverb's `size` and `damping` are **not** automatable, so build the tail with a fixed reverb plus an automated `gain` stage around it, and remember that reverb adds `chainTailSeconds` — the rendered track will be longer than its `data-duration`, which is expected.

**Remotion.** `interpolate()` over a frame range driving the same three filters plus a plate opacity; frame-native, so the 24/9/42-frame shape ports literally. Not a runtime in this project.

## Pairs with
[[cut-fade-to-white]] · [[cut-fade-to-black]] · [[cut-fade-to-solid-colour]] · [[cut-dissolve-time-passage]] · [[cut-fade-bookend]] · [[motion-subject-glow-separation]] · [[motion-colour-dip-transition]] · [[sfx-music-fade-out-section-signal]] · [[motion-pattern-interrupt-jolt]] · [[struct-emotional-arc-drives-retention]]

## Failure modes
- **Linear dissolve to a white matte.** The default, and the reason most fades to white look like an error. Correction: drive brightness and blur on the *image*; let the plate finish only the last third of the ramp.
- **Symmetric timing.** Equal in and out makes it a technical fade with no emotional shape. Correction: out ≥1.5× in.
- **No white hold.** Without a plateau there is no threshold crossed, so the viewer reads a soft cut. Correction: 6–18 frames of white.
- **Too long a hold.** Past about a second of white the viewer checks their connection. Correction: cap total white at 1.0 s.
- **Colour surviving into the white.** A pink or teal white-out reads as a grading error. Correction: desaturate ahead of the brightness ramp.
- **Scene B starting at the end of the white.** Produces a hidden cut inside the transition and kills the continuity the device is for. Correction: B plays live under the plate before the plate clears.
- **Audio untouched.** A full-bandwidth mix under a white-out is the fastest way to make it read as a video glitch. Correction: low-pass sweep plus reverb tail, plateau at about −30 dB.
- **Used for a section change.** White means *leaving reality*; using it for "next chapter" spends the meaning and confuses the viewer for the rest of the video. Correction: black, dissolve, or cut.
- **Overuse.** Once or twice per video. Correction: audit every white boundary and demote the weakest to a dissolve.
- **Known gap.** There is no HDR-aware highlight roll-off in this path and no exposure primitive in the composition layer — `filter: brightness()` clips hard at the display ceiling, which is why the desaturation lead and the blur growth are doing so much of the work. If the deliverable is HDR (`--hdr`, MP4 only), test the transition at the delivery ceiling before trusting these numbers, and remember `--resolution` cannot be combined with `--hdr`.
