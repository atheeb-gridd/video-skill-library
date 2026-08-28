---
id: motion-light-leak-overlay-transition
title: Light leak and film burn — cover the seam with an additive overlay, not geometry
skill: motion
type: transition
family: covered-cut
tags: [skill/motion, type/transition, family/covered-cut, sfx/aesthetic, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, engine/remotion, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:58"
    quote: "Another way to make transitions seamless is to use a full-screen transition. There are tons of free packs out there, but if you like my subtle style, I've got something for you in the description."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://www.adobe.com/creativecloud/video/discover/whip-pan.html
  - https://gsap.com/docs/v3/Eases
difficulty: medium
detectable_from: video
---

# Light leak and film burn — cover the seam with an additive overlay, not geometry

## What it is
The subtle half of the full-screen transition family, and the one the creator's "subtle style" pack lives in: instead of moving the two shots, you brighten across the seam with an additive element — a soft warm bloom sweeping the frame, a film-burn flare, an overexposure lift — peaking on the frame where the picture swaps. Neither shot translates, scales or blurs. The cover is purely photometric: at peak, enough of the frame is lifted toward white that the change of image is not resolvable, and the eye reads the whole event as light rather than as an edit.

It is the least intrusive cover available and the one that survives repetition best, which is why it is the natural "primary" transition when [[motion-whip-pan-transition]] is the accent.

## When to use it
- **Between two shots with nothing in common** — different location, framing, lens, colour — where a straight cut reads as a jolt and a whip pan would be too loud.
- **On a section boundary** in a talking-head or vlog structure, often paired with a music change ([[sfx-track-change-at-section-boundary]]).
- **In a montage** where every cut needs the same light treatment for cohesion.
- **Over a match that almost works** — the leak buys you the 3–4 frames of mismatch you could not fix.
- **When the audio is continuous across the cut** — the leak covers picture only, so an unbroken bed or ambience makes it seamless ([[sfx-ambience-bridge-across-cut]]).
- **Not** over text or a graphic the viewer is still reading (the lift destroys contrast), and not more than once every ~15 s at full strength.

## How to recognise it in a reference video
- **Nothing moves.** Track any edge across the seam: geometry is static in both shots. If the frame also translates or scales, it is a different transition with a leak painted on top.
- **A luminance hump.** Sample mean frame luminance per frame across the seam (`ffmpeg -vf "signalstats,metadata=print"` or a per-frame thumbnail strip). The signature is a rise of **+15% to +45% mean luminance** over 6–10 frames, a 1–3 frame plateau, and a fall over 8–14 frames. Total event **14–26 frames** (0.45–0.85 s) — longer than a whip, and the swap sits on the plateau.
- **The lift is coloured and off-centre.** Real leaks are warm (orange/amber, roughly R>G>B) and enter from one edge or corner, not uniformly. A uniform white flash is a **dip-to-white**, a different device ([[cut-fade-to-white]]).
- **Highlights bloom, blacks stay put.** Additive blending lifts bright areas much more than dark ones. If the shadows go grey too, it was an opacity crossfade to a white plate, not a screen/lighten composite.
- **Grain or texture rides along.** Film-burn assets carry visible grain and edge irregularity; a clean gradient reads as a CSS effect.
- **Audio:** usually soft — an airy whoosh, a tape/analogue texture, or nothing at all if the music carries the change. When present, its peak sits on the plateau, **−15 to −20 dB**, quieter than a whip's whoosh.
- **Count flashes.** More than 3 lifts per second anywhere in the video is a photosensitivity hazard (WCAG 2.3.1 three-flash threshold) — always log this, it is a hard fail.
- **Frequency:** as a primary transition, once every **8–20 s** is normal; at every cut it flattens into a look rather than a transition.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `total_duration` | 0.60 s (18 f) | 0.45–0.85 s (14–26 f) | Calm/medium band. Registry `max_duration_s` 2.0 is the hard ceiling. |
| `rise` | 0.25 s (7–8 f) | 0.20–0.33 s | `power2.in` — light arrives accelerating. |
| `plateau` | 0.06 s (2 f) | 0.03–0.10 s | The picture swap happens here. |
| `fall` | 0.30 s (9 f) | 0.26–0.46 s | `power2.out`, longer than the rise. |
| `peak_opacity` | 0.75 | 0.55–0.95 | Of the leak element, in `screen` blend. |
| `peak_luma_lift` | +30% mean | +15% to +45% | Measured, not authored — verify on the render. |
| `blend_mode` | `screen` | `screen` \| `lighten` \| `plus-lighter` | `screen` is the safe default; `plus-lighter` clips faster. |
| `leak_colour` | #FF8A2B | warm 2000–3500 K | Amber/orange. Cool leaks read as digital glitch, not film. |
| `entry_edge` | right | any edge/corner | Enter from the side the previous shot's brightest area is on. |
| `swap_offset` | plateau start | ±1 f | Where `data-start`/`data-duration` hand over. |
| `sfx_level` | −18 dB | −15 to −20 dB | Quieter than a whip whoosh; often omitted. |
| `min_gap` | 8 s | 6–20 s | Between full-strength leaks. |
| `flash_ceiling` | 3/s | — | WCAG 2.3.1. Never exceed; log any reference video that does. |
| `text_safe` | no text under peak | — | Do not lift over on-screen copy the viewer is reading. |

## Reproduction prompt

```
Cover the cut at {{CUT}} between {{FROM}} and {{TO}} with a light-leak
transition. Neither shot moves.

TIMING. Total 0.60s (18 frames at 30fps). Let T = {{CUT}} - 0.27s so the
plateau lands on the cut. Rise 0.25s, plateau 0.06s, fall 0.30s. Extend
{{FROM}}'s data-duration to reach the plateau and start {{TO}} at the plateau,
so the picture swap is hidden under peak brightness. Author the swap on a whole
frame boundary (a multiple of 1/fps).

OVERLAY. Add one full-bleed element above both scenes at z-index 90, with
mix-blend-mode: screen. Source it either from a leak/film-burn video asset
(muted, data-has-audio absent) or from a radial gradient entering from the
right edge in warm amber (#FF8A2B), using the target colour at zero alpha -
never the transparent keyword. It must NOT be a clip that clamps the scenes:
give it its own data-start/data-duration on its own track index, not as an
ancestor of the scenes.

ANIMATION. autoAlpha 0 -> 0.75 over 0.25s ease power2.in; hold 0.06s;
0.75 -> 0 over 0.30s ease power2.out. Optionally scale the gradient 1.0 -> 1.15
across the whole event with ease none for a moving bloom. Land the final state
at least 2 frames before the overlay clip's data-duration.

SOUND. Optional: airy whoosh or analogue texture, peak on the plateau, -18 dB.
If the music changes here, let the music carry it and use no SFX.

ACCEPTANCE TEST: step T-2f .. T+20f. No geometry may move in either shot;
mean frame luminance must rise 15-45% and return; the swap frame must be
unidentifiable; no on-screen text may be under the peak; and across the whole
video no more than 3 such lifts occur in any one second.
```

## Execution spec

**HyperFrames.** Two scene clips handing over under one additive overlay clip.

```html
<!-- scenes: no motion, hand over at the plateau (12.00s) -->
<div id="el-scene-a" class="clip" data-composition-src="compositions/a.html"
     data-start="6"  data-duration="6"    data-track-index="0"></div>
<div id="el-scene-b" class="clip" data-composition-src="compositions/b.html"
     data-start="12" data-duration="6"    data-track-index="1"></div>

<!-- the leak: a sibling clip, never an ancestor of the scenes -->
<div id="leak" class="clip" data-start="11.73" data-duration="0.7" data-track-index="4"
     style="position:absolute; inset:0; z-index:90; mix-blend-mode:screen; opacity:0;
            background:radial-gradient(120% 90% at 100% 40%,
              rgba(255,138,43,1) 0%, rgba(255,138,43,0.35) 45%, rgba(255,138,43,0) 78%);"></div>
```

```js
const T = 11.73;                                   // 0.60s event; plateau at 11.98-12.04
tl.fromTo("#leak", { autoAlpha: 0, scale: 1.0 },
                   { autoAlpha: 0.75, duration: 0.25, ease: "power2.in" }, T);
tl.to("#leak", { autoAlpha: 0.75, duration: 0.06 }, T + 0.25);      // plateau
tl.to("#leak", { autoAlpha: 0, duration: 0.30, ease: "power2.out" }, T + 0.31);
tl.to("#leak", { scale: 1.15, duration: 0.61, ease: "none" }, T);   // optional drifting bloom
```

Contract points that bind this:
- **The overlay must be a sibling, not a parent.** A timed ancestor **clamps** its descendants' visibility — wrapping the scenes in the leak would hide them outside the leak's 0.7 s window.
- The leak element is a **clip**, so do not tween `display`/`visibility` on it; `autoAlpha` is fine, and the framework still owns its window.
- Root-level timed children are auto-`position:absolute; inset:0`; an untimed decorative div is **not** and would collapse — keep `data-start` on it (as above) or give it explicit `position:absolute; inset:0`.
- Gradients: use the target colour at **zero alpha**, never the `transparent` keyword; no gradient opacity below 0.15; no gradients on elements thinner than 4 px. These are shader-capture rules and are also just safer across renderers.
- **Shader-transition projects:** DOM is captured to WebGL textures via html2canvas, which does not reliably reproduce `mix-blend-mode`. In those projects use the package's own `light leak (shader)` transition by name instead — its implementation files are not staged, so do not invent code for it.
- Also from core: a full-screen fill on the composition **root** is dropped on the layered-composite path — put any background fill on a full-bleed child.
- Video-sourced leaks: `<video muted>` with an `id` (an id-less media element is a lint error), and no `crossorigin` attribute (`media_crossorigin_breaks_preview` is an error with **no suppression**).
- Determinism: no `Math.random()` flicker, no `repeat: -1` grain loop — finite counts only.

**ffmpeg — baked version.** Additive composite of a leak clip over the cut:

```bash
# 1. cut A and B so they meet at the plateau, then screen-blend the leak over the seam
ffmpeg -i seam.mp4 -i leak.mov -filter_complex \
 "[1:v]format=yuva420p,scale=1920:1080,setpts=PTS-STARTPTS+11.73/TB[lk];\
  [0:v][lk]blend=all_mode=screen:all_opacity=0.75:shortest=0" -c:a copy out.mp4
# 2. audit the luminance hump on any reference
ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:file=/tmp/luma.txt" -f null -
```
A pure fade-through-white fallback (no asset): `fade=t=out:st=11.73:d=0.27:color=white` on A and `fade=t=in:st=12.0:d=0.30:color=white` on B — cruder, but honest.

**Epidemic Sound.** `SearchSoundEffects { query: { term: "airy whoosh light transition texture" }, filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--whoosh"] }, duration: { max: 3000 } } }`. Place at −18 dB (`data-volume` ≈ 0.13 relative to a 1.0 dialogue bus) with the transient on the plateau.

**Remotion:** an `<AbsoluteFill>` with `mixBlendMode: "screen"` whose opacity is interpolated over the seam frames — concept only.

## Pairs with
[[cut-full-screen-transition]] · [[motion-whip-pan-transition]] · [[motion-fade-to-black-ramp]] · [[cut-fade-to-white]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-track-change-at-section-boundary]] · [[motion-look-finishing-pass]] · [[motion-attention-transient]]

## Failure modes
- **Opacity crossfade to a white plate instead of an additive blend.** Lifts the blacks, the image goes milky and flat, and it reads as a cheap dip. Correction: `mix-blend-mode: screen` (or `blend=all_mode=screen` when baking).
- **Peak too low.** Under about +15% mean luminance the swap is still visible and the leak just looks like a flicker. Correction: raise `peak_opacity` until the plateau frame is unidentifiable.
- **Peak too high or too long.** A 4+ frame full-white plateau is a flash, not a leak, and starts to be a photosensitivity issue. Correction: 1–3 frame plateau, ≤0.95 opacity, and never more than 3 lifts per second.
- **Cool or neutral colour.** A white or blue lift reads as a digital error rather than light. Correction: warm amber.
- **Lifting over text.** Contrast collapses and the viewer loses the word they were reading. Correction: clear the copy before the rise, or move the leak to the next seam.
- **Leak as an ancestor of the scenes.** The scenes vanish outside the leak's window — a silent, total failure. Correction: sibling clip, `z-index` for layering.
- **Every cut leaked.** The device becomes a grade. Correction: ≥8 s between full-strength leaks; use plain cuts in between.
- **Known gap:** the luminance-lift percentages and frame counts are measured craft calibrations, not published standards; the flash ceiling (WCAG 2.3.1) and contrast rules are the sourced constraints. Rendered MP4 cannot honour a viewer's reduced-motion or photosensitivity preferences — treat the ceiling as absolute.
