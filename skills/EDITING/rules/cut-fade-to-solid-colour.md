---
id: cut-fade-to-solid-colour
title: The fade — dissolving to or from a solid colour, and how to make it not look muddy
skill: editing
type: transition
family: fade
tags: [skill/editing, type/transition, family/fade, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:16"
    quote: "The fade is a classic, and it's when a shot dissolves or fades to or from a solid colour."
research_refs:
  - https://en.wikipedia.org/wiki/Fade_(filmmaking)
  - https://en.wikipedia.org/wiki/Gamma_correction
  - https://ffmpeg.org/ffmpeg-filters.html#fade
  - https://en.wikipedia.org/wiki/Continuity_editing
difficulty: low
detectable_from: video
---

# The fade — dissolving to or from a solid colour, and how to make it not look muddy

## What it is
The picture resolves into, or emerges from, a **flat field of one colour**. That is the whole definition, and the single detail that separates it from a dissolve: a dissolve overlaps two images and never shows a solid frame; a fade empties the screen. Emptying the screen is why it reads as the strongest punctuation available — a full stop, not a comma. Everything downstream follows from that: it belongs at boundaries, and it is the wrong mark inside a scene.

This note is the **execution** note for the primitive. Its two siblings own meaning: [[cut-fade-bookend]] owns *where* a fade is allowed to appear, and [[cut-fade-to-white]] owns what happens when the terminal colour is not black. What this note adds is the craft that decides whether a fade looks professional or homemade — **the duration, the curve, and the colour space**. A fade authored as a linear interpolation of gamma-encoded pixel values passes through a midpoint that is *darker than half* the original scene's light, because gamma encoding is not proportional to light. The image appears to sag and go muddy at the middle of the move before racing to black. Fades that look expensive are either done in linear light or shaped with a curve that compensates for that sag.

## When to use it
Head of the piece (fade in from black), tail of the piece (fade out to black), and hard structural breaks — a chapter boundary, an act break, a before/after divider, the boundary either side of a sponsor read. In short-form and social edits, fade the *last* two seconds only; the opening fade costs you the hook and is almost always wrong there.

Use a fade rather than a cut when you want the viewer to feel that a unit has completed, and rather than a dissolve when you do not want the two sides to touch. Do **not** fade between shots inside a scene, do **not** fade to break up a list, and do **not** fade into a mid-roll CTA — that reads as the video ending. The colour is a second decision: black asserts closure, white asserts ambiguity ([[cut-fade-to-white]]), a brand colour asserts a stinger.

## How to recognise it in a reference video
- **At least one frame of a genuinely flat field.** Sample the mid-transition frame and check pixel variance: a true fade reaches a frame whose standard deviation across the whole picture is near zero. A dissolve never does.
- **Mean-luminance ramp shape.** Plot mean Y over the transition. A fade goes monotonically to (or from) the colour's luminance and *stays* there for at least a frame; a dissolve's mean luminance wanders between two images.
- **Duration bands.** Opening fade-in **30–60 f (1.0–2.0 s)**; closing fade-out **45–90 f (1.5–3.0 s)**; act-break pairs **15–30 f (0.5–1.0 s)** each way. Reference for the neighbouring device: a standard dissolve is *"1 to 2 seconds (24–48 frames)"*.
- **Held colour between an out and an in.** Count the flat frames. **12–30 f** is a designed beat; 2–5 f is a mistake; over 60 f reads as the video ending or buffering.
- **The audio tells you whether it was authored or defaulted.** A considered fade has its audio ramp **2–6 f longer** than the picture, so the last black frame is silent. A dragged-on NLE default cuts audio and picture on the same frame, leaving a tick of sound over black.
- **Midpoint darkness.** Compare the frame at 50% of a fade-to-black against the source frame at 50% brightness. If the transition frame is noticeably darker, the fade was done in gamma space with a linear ramp — the common, cheap look.
- **Colour cast.** A fade to a colour that is not pure black or white, or a black that is #0A0A0A rather than #000, is deliberate branding and worth logging as such.
- **On the transcript:** the fade always falls in a gap between sentences, usually where a section's last word has finished and 0.5 s of silence follows.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Opening fade-in | 45 f (1.5 s) | 30–60 f | Skip entirely for short-form; the hook cannot afford it. |
| Closing fade-out | 60 f (2.0 s) | 45–90 f | The longest fade in the piece. |
| Act-break fade out / in | 24 f (0.8 s) each | 15–30 f | Symmetrical unless the new section is meant to arrive faster. |
| Held solid colour between out and in | 18 f (0.6 s) | 12–30 f | Under 12 f reads as a dip, not a break. |
| Terminal colour | `#000000` | `#000` / `#FFF` / brand | Black = closure, white = ambiguity, brand = stinger. |
| Picture curve (fade out) | `power2.in` | `power1.in`–`power3.in` | Slow start, fast finish; cancels the gamma sag. Linear only if fading in linear light. |
| Picture curve (fade in) | `power2.out` | `power1.out`–`power3.out` | Mirror image. |
| Colour space for the blend | linear light | linear / gamma+curve | Correct is decode → blend → re-encode. If you cannot, use the eased curve as the compensation. |
| Audio tail beyond picture | 4 f (0.13 s) | 2–6 f | So the final flat frame is silent. |
| Audio curve | `log` (out) / `qsin` (in) | `log`, `exp`, `qsin`, `hsin` | `tri` is linear amplitude and sounds like it hangs. |
| Fades per video | 2 | 2–5 | Head, tail, and act breaks only. More than five means fades are being used as commas. |

## Reproduction prompt

```
Author a fade to (or from) a solid colour at boundary {{T}} seconds. 30fps;
HyperFrames authors SECONDS, so every frame value converts as
seconds = frames / 30. There is no frame attribute in this stack.

1. CLASSIFY THE BOUNDARY: HEAD (fade in from colour), TAIL (fade out to
   colour), or BREAK (fade out, hold, fade in). If the boundary is inside a
   scene, or between two points of the same list, STOP - use a cut or a
   dissolve, not a fade.
2. SET DURATIONS by class: HEAD = 45f (1.5s) fade in. TAIL = 60f (2.0s) fade
   out. BREAK = 24f out, 18f held colour, 24f in. Short-form (<90s total):
   skip the HEAD fade entirely and cut the TAIL to 30f.
3. PICK THE COLOUR: #000000 for closure, #FFFFFF only if the meaning is
   ambiguity or transcendence, a brand colour only for a stinger. Author it
   as an explicit hex, never as `transparent`.
4. BUILD IT AS A LAYER, NOT A FILTER. Place a full-bleed solid-colour
   element ABOVE the picture, covering {{T}} - (fade duration) to {{T}} +
   (held duration). Animate the OVERLAY's opacity 0 -> 1 for a fade out and
   1 -> 0 for a fade in. Do not animate the picture's own opacity - the
   frame behind it is undefined.
5. CURVE: fade out with power2.in, fade in with power2.out. Never linear in
   gamma space: a linear ramp on gamma-encoded values passes through a
   midpoint darker than half the scene's light and visibly sags. If your
   tool can blend in linear light, do that and use a linear ramp instead.
6. LAND THE END STATE EARLY. The clip window is half-open, [start, start +
   duration), so an animation whose resolved end state lands exactly on
   data-duration never renders its last frame. Finish the tween at least
   0.05s before the clip's end.
7. AUDIO: ramp the mix with the same shape but end it 4 frames AFTER the
   picture reaches the colour, so the final flat frame is silent. Use a
   logarithmic curve for a fade out, quarter-sine for a fade in - a linear
   amplitude ramp sounds like it hangs.
8. ACCEPTANCE TEST: (a) snapshot the frame at {{T}} - the picture must be a
   perfectly flat field, standard deviation ~0 across all channels; (b)
   snapshot the 50% frame - it must not look markedly darker than the source
   frame at half brightness; (c) confirm at least one full frame of held
   colour exists (12f for a BREAK); (d) confirm no audio is audible over the
   last flat frame; (e) count fades in the finished video - more than five
   means they are being used as punctuation and should be demoted to cuts.
```

## Execution spec

**HyperFrames — a fade is an overlay clip plus one GSAP tween.** There is no `data-transition` and no `data-ease`; motion is authored as tweens on the composition's single paused timeline, positioned in **absolute composition seconds**.

```html
<!-- fade to black at 92.0s over 2.0s, held to 92.6s -->
<div id="fade-black" class="clip"
     data-start="90.00" data-duration="2.60" data-track-index="9"
     style="position:absolute; inset:0; pointer-events:none;">
  <div class="fill" style="position:absolute; inset:0; background:#000000; opacity:0;"></div>
</div>
```
```js
// 60 frames @30fps = 2.0s. Tween the INNER fill, not the clip element.
tl.fromTo("#fade-black .fill",
  { opacity: 0 },
  { opacity: 1, duration: 2.0, ease: "power2.in" },
  90.00
);
```
Why each piece is what it is, straight from the contract:
- **`fromTo`, never `from`.** `gsap.from()` sets `immediateRender: true`, writing the "from" state at construction — before the clip's `data-start` is active — and under the render engine's non-linear seek that flashes or skips.
- **Tween the inner `.fill`, not the clip.** The framework owns clip visibility; never tween `display` or raw `visibility` on a clip element (lint rejects it). `autoAlpha` is the sanctioned alternative, but keeping the animated node one level in is simpler and avoids the question.
- **No CSS `opacity` in the stylesheet *and* a GSAP tween on the same property pattern** — a CSS initial `transform` plus a GSAP transform tween is `gsap_css_transform_conflict` (error); the same discipline applies here, so let the `fromTo` own the value.
- **No CSS `transition`** on the element — *"they interpolate independently of seek and flicker."*
- **Land the end state before `data-duration`.** The window is `[start, start + duration)`; an animation resolving exactly on the boundary never renders its final frame.
- **A full-screen fill on the composition root is dropped on the layered-composite path** (HDR, or any composition using shader transitions). Put the fill on a full-bleed child with `position:absolute; inset:0` — which is exactly the markup above.
- Root-level clips get automatic layout (forced `position:absolute`, `top/left:0`, sized to 100%) **only if they carry `data-start`**; an untimed background collapses to zero height. This clip carries `data-start`, so it is fine.
- Layering is **CSS `z-index`, not `data-track-index`** — the fade layer must actually paint above the picture, so give it a higher `z-index` (or later document order); `data-track-index="9"` is documentation only.

**Registry note.** The machine transition registry contains `crossfade` and `blur-crossfade`, which are shot-to-shot **dissolves** — not fades to colour. There is no registry entry for a fade to a solid colour, so this is authored by hand as above rather than injected. The registry's `max_duration_s: 2.0` is worth respecting as a house ceiling for anything scene-to-scene, but a closing fade to black may legitimately exceed it.

**ffmpeg — for flat media leaving the pipeline.** Exact filter shape, using time-based options (`start_time`/`duration` override the frame-based ones):
```bash
ffmpeg -i in.mp4 \
  -vf "fade=t=in:st=0:d=1.5:color=black,fade=t=out:st=118.0:d=2.0:color=black" \
  -af "afade=t=in:st=0:d=1.5:curve=qsin,afade=t=out:st=118.13:d=2.0:curve=log" \
  -c:v libx264 -preset veryfast -crf 18 -c:a aac -movflags +faststart out.mp4
```
- `fade` options: `type` (`in`/`out`), `start_frame`/`nb_frames`, `start_time`/`duration`, `color` (default black), `alpha`.
- `afade` `curve` accepts `tri` (linear), `qsin`, `hsin`, `esin`, `log`, `exp`, `ipar`, `qua`, `cub`, `squ`, `par`, `nofade` and more. Use `log` out / `qsin` in; `tri` is linear amplitude and audibly hangs.
- Note the audio fade starts **4 frames (0.133 s) later** than the picture's, so the last flat frame is silent.

**Gamma.** `fade` operates on the encoded values, so a plain `fade` is a gamma-space blend with the sag described above. To fade in linear light:
```bash
ffmpeg -i in.mp4 -vf "zscale=t=linear:npl=100,fade=t=out:st=118:d=2:color=black,zscale=t=bt709:m=bt709:r=tv,format=yuv420p" out.mp4
```
`zscale` requires an ffmpeg built with **libzimg**, which is **not verified present in this environment** — treat it as optional. When it is unavailable, the eased `power2.in` curve (HyperFrames) or `curve`-shaped equivalent is the sanctioned compensation, and it gets you most of the way.

**Epidemic Sound:** not involved, except that a closing fade usually wants the bed to end with it — see [[sfx-music-rest-windows]] for the out-point, and do not let a reverb tail outrun the last black frame (effects with a tail make the rendered track longer than its `data-duration`; the mix is told how much via `chainTailSeconds`).

**Remotion:** an `<AbsoluteFill>` with `backgroundColor` and `opacity` driven by `interpolate(frame, [a, b], [0, 1])` plus an easing. Conceptually identical; not part of this project.

## Pairs with
- [[cut-fade-bookend]] — where a fade is permitted to appear at all
- [[cut-fade-to-white]] — the colour swap and what it changes
- [[cut-dissolve]] — the neighbouring device that never shows a solid frame
- [[cut-dissolve-time-passage]] — the "time passed" statement a fade over-states
- [[sfx-music-rest-windows]] — landing the bed's out-point with the fade
- [[cut-full-screen-transition]] — the high-energy alternative at a section break
- [[struct-closing-recap-single-cta]] — the content the closing fade punctuates
- [[motion-look-finishing-pass]] — the grade the fade must not fight

## Failure modes
- **Linear ramp in gamma space.** The midpoint sags dark and the transition looks cheap. Ease it (`power2.in` out / `power2.out` in) or blend in linear light.
- **Fading the picture instead of an overlay.** Reducing a shot's own opacity reveals whatever is behind it — often nothing, sometimes the previous clip — and the result is a dissolve you did not ask for. Always fade a colour layer on top.
- **No held frames.** A fade out that flips straight into a fade in reads as a flicker. Give the colour 12–30 frames to exist.
- **Audio and picture ending on the same frame.** A tick of sound over black is the single most recognisable amateur tell. Give the audio 2–6 frames more.
- **Fades used as commas.** Five fades inside one section trains the viewer that the video keeps ending. Demote to cuts; the fade must stay expensive.
- **Fading into a mid-roll CTA.** The audience reads the fade as the end and leaves. Cut into the CTA, and put the fade after it if anywhere.
- **A fade at the head of a short-form video.** 1.5 seconds of black is 1.5 seconds of the only window you get. Start on the picture.
- **Animation resolving exactly on `data-duration`.** The half-open window means that final frame never renders, so the "fully black" frame you designed does not exist. Land the tween early and give the clip a tail.
- **Known gap:** linear-light fading depends on `zscale`/libzimg, which is **not verified present**; and nothing in `check` measures a transition frame's flatness or its midpoint luminance. The acceptance test is `snapshot` plus your eyes, and `snapshot` is browser-dependent so it must run off the device VM.
