---
id: motion-colour-dip-transition
title: The colour dip — fade through a solid field, and the gamma trap in the middle of it
skill: motion
type: transition
family: fade
tags: [skill/motion, type/transition, family/fade, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:16"
    quote: "The fade is a classic, and it's when a shot dissolves or fades to or from a solid colour."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:23"
    quote: "And that colour is most commonly black, whereas a fade to white might be used to show the character dying or in a dream."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:31"
    quote: "Fades are commonly at the start or the end of the film, and they symbolize the beginning or the end of a story."
research_refs:
  - https://en.wikipedia.org/wiki/Fade_(filmmaking)
  - https://ffmpeg.org/ffmpeg-filters.html#fade
  - https://en.wikipedia.org/wiki/Gamma_correction
  - https://en.wikipedia.org/wiki/Blend_modes
  - https://www.w3.org/WAI/WCAG22/Understanding/three-flashes-or-below-threshold.html
difficulty: medium
detectable_from: video
---

# The colour dip — fade through a solid field, and the gamma trap in the middle of it

## What it is
The picture goes to a **flat field of one colour**, optionally holds there, and comes back from that field into the next shot. Emptying the screen is what makes it the strongest punctuation available: a dissolve overlaps two images and never shows a solid frame; a fade shows one. This note owns the **motion execution** — the curve, the hold, the frame counts, and the layer order that makes the dip a transition rather than a gap. The editorial questions — where a fade is allowed to appear at all, and what a non-black colour means — belong to [[cut-fade-to-solid-colour]], [[cut-fade-bookend]] and [[cut-fade-to-white]].

The craft problem this note exists for: an opacity fade authored naively interpolates **gamma-encoded** pixel values, so at the halfway point the screen carries far less light than half the original scene. The image sags, goes muddy, and then races to black. Fades that look expensive either run in linear light or use a curve that compensates for that sag.

## When to use it
- **Head and tail of the piece.** Fade in from black to open, fade out to black to close. In short-form, only the tail — an opening fade costs the hook.
- **Act breaks and chapter boundaries**, including either side of a sponsor read.
- **Before/after dividers**, where the empty frame separates two states of the same thing.
- **A time jump inside a sequence**, where a dissolve would read as "meanwhile" and a hard cut would read as "immediately".
- **Not between related points.** A dip inside an argument reads as the end of the argument. Use the registry's `crossfade` or `push-slide` there instead.
- **Not more than once per structural section.** The mark loses force fast.

## How to recognise it in a reference video
- **Look for at least one frame that is a solid colour.** That single observation separates a fade from a dissolve. Sample mean and standard deviation of luma per frame:
  ```bash
  ffmpeg -i ref.mp4 -vf "select='between(t,120,124)',signalstats,metadata=print" -f null - 2>&1 | grep -E "YAVG|YDIF"
  ```
  A solid frame shows near-zero spatial variance. Zero solid frames plus a luma dip means it was a *dissolve through a dark shot*, not a fade.
- **Measure the three phases separately:** fade-out frames, hold frames, fade-in frames. Typical: **12–30 f out, 0–15 f hold, 12–30 f in** at 30 fps. Openings and closings run longer (30–60 f); mid-piece act breaks run shorter (12–18 f each side).
- **Plot the luma curve across the fade.** A **linear** ramp of mean luma in encoded values is the naive implementation. A curve that stays bright for the first third and then falls away steeply is the gamma-corrected one — that shape is the tell of a professional fade.
- **Check the terminal colour.** Sample the solid frame's RGB. Pure `#000` vs a lifted black (`#0a0a0a`) vs white vs a brand colour. A lifted black usually means the fade was done over a graded image with a floor; a brand colour is a deliberate design choice worth logging.
- **Check whether the audio fades with the picture.** In a bookend fade it almost always does, over the same or a slightly longer window. In a mid-piece dip it often does not — the bed runs through, which is what makes the dip read as a comma rather than a full stop.
- **Look for a hold.** A hold of 6+ frames on the colour is a strong authorial beat, common before a chapter title. Zero hold reads as a soft cut.
- **Watch for a flash-frame variant.** A dip to *white* lasting 1–3 frames is a flash, not a fade, and is governed by the flash safety ceiling (no more than three luminance flips per second).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `dip_colour` | `#000000` | any | Black = full stop. White = dream, death, blowout, revelation. Brand colour = branded chapter break. |
| `fade_out_dur` | 0.50 s (15 f) | 0.27–1.00 s (8–30 f) | Act break 8–18 f; piece tail 30–60 f. Registry `max_duration_s` for any single transition is **2.0 s**. |
| `hold_dur` | 0.20 s (6 f) | 0–0.50 s (0–15 f) | 0 f reads as a soft cut; 6 f as a beat; 15 f as a chapter. |
| `fade_in_dur` | 0.50 s (15 f) | 0.27–1.00 s | Entrances read slower than exits — bias the in slightly longer than the out. |
| `fade_out_ease` | `power2.in` | `power1.in`–`power3.in` | Approximates a gamma-correct (linear-light) fall at γ≈2.2. **Not** linear. |
| `fade_in_ease` | `power2.out` | `power1.out`–`power3.out` | The mirror. |
| `gamma_mode` | `curve` | `curve` · `linear-light` | `curve` = compensating ease on an sRGB composite. `linear-light` = do the blend in linear light (ffmpeg `zscale`), the exact answer. |
| `audio_fade` | follow picture | follow · run through | Bookend: follow, and run 0.1–0.3 s longer than the picture. Mid-piece: usually run through. |
| `cut_under_colour` | required | — | The underlying shot change happens on the frame where the overlay is fully opaque, never before or after. |
| `flash_ceiling` | 3/s | — | WCAG 2.3.1, binding for white dips and flash frames: no more than three general or red flashes in any one second over 25% of any 10° field. |
| `per_section_budget` | 1 | 0–2 | Dips per structural section. |

## Reproduction prompt

```
Author a colour dip between {{SCENE_A}} and {{SCENE_B}}, centred at {{T}}.

Structure: one full-bleed overlay div #dip, positioned absolute inset:0,
background {{COLOUR}} (default #000000), z-index above every visual layer,
opacity 0. It must NOT be a clip - give it no data-start - and it must be a
child of the composition root, not the root itself.

Timeline:
  t = {{T}} - 0.50s : tween #dip opacity 0 -> 1 over 0.50s, ease power2.in
  t = {{T}}         : the picture change happens HERE, underneath a fully
                      opaque overlay - {{SCENE_A}}'s data-duration ends and
                      {{SCENE_B}}'s data-start begins on this same second, a
                      hard cut nobody can see
  t = {{T}} + 0.20s : hold ends
  t = {{T}} + 0.20s : tween #dip opacity 1 -> 0 over 0.50s, ease power2.out

Do NOT fade the two scenes themselves to opacity 0 with a gap between them -
that is a dip with a hole in it and this stack's transition doctrine bans it.
The scenes stay fully opaque; only the overlay moves.

Ease matters: power2.in / power2.out approximate a linear-light fade on an
sRGB composite. A linear ease loses about half the scene's light by the
quarter point and looks muddy.

Audio: if this is a bookend, fade the bed over the same window plus 0.2s using
a volume automation lane. If mid-piece, let it run through.

ACCEPTANCE TEST: sample mean luma every 2 frames across {{T}}-0.5s..{{T}}+0.7s.
The curve must stay above 50% of starting luma until roughly 40% into the
fade, then fall steeply. At least one frame must be a solid colour field with
near-zero spatial variance. No visible cross-dissolve of the two shots.
```

## Execution spec

**HyperFrames.** There is **no `color dip` in the Tier-B transition registry** — the five machine-ready transitions are `crossfade`, `blur-crossfade`, `push-slide`, `zoom-through` and `squeeze`. "Color dip" appears only in the broad ≈40-name catalog whose implementations are *not staged*, so it must be hand-authored. It is a short, safe thing to hand-author:

```html
<!-- full-bleed dip overlay: a child of the root, NOT the root, and NOT a clip -->
<div id="dip" style="position:absolute; inset:0; background:#000; opacity:0;
                     z-index:9999; pointer-events:none;"></div>
```

```js
const T = 42.0;                       // the invisible cut, in composition seconds
// 15 frames @30fps = 0.5s. power2.in ≈ the gamma-correct fall on an sRGB composite.
tl.to("#dip", { opacity: 1, duration: 0.50, ease: "power2.in" }, T - 0.50);
tl.to("#dip", { opacity: 0, duration: 0.50, ease: "power2.out" }, T + 0.20);
```

```html
<!-- the shot change happens under the opaque overlay: back-to-back clips, no overlap -->
<div id="el-scene-a" data-composition-src="compositions/scene-a.html"
     data-composition-id="scene-a" data-start="30" data-duration="12" data-track-index="1"></div>
<div id="el-scene-b" data-composition-src="compositions/scene-b.html"
     data-composition-id="scene-b" data-start="42" data-duration="10" data-track-index="0"></div>
```

Contract points that bind this:
- **The half-open window makes the invisible cut exact:** *"Two clips can therefore be authored back to back (`b.start === a.start + a.duration`) with no overlapping frame."* Scene A ends and Scene B starts on the same second, under full opacity.
- **The banned pattern.** The transition doctrine explicitly rejects `tl.to("#s1",{opacity:0})` followed later by an entrance on `#s2` as *"a jump cut with a dip, not a transition"*, and bans exit animations except on the final scene. The overlay construction above sidesteps it correctly: neither scene animates its own opacity, so nothing is "exiting" — the dip is a layer above both. Do not implement a dip by fading the scenes.
- **`#dip` must not be a clip.** Give it no `data-start`; a timed ancestor clamps descendants and the framework would own its visibility. It is a plain positioned child.
- **Do not put the fill on the composition root.** A full-screen fill on the root is dropped on the layered-composite path (HDR, or any composition using shader transitions) — *"put the fill on a full-bleed child (`position:absolute; inset:0`)"*.
- **Layering is CSS `z-index`, not `data-track-index`** — the latter is display-only and constrains nothing.
- No CSS `transition` on `#dip`; it interpolates independently of seek.
- Where the same beat should read calm rather than final, prefer the registry's `blur-crossfade` (0.6 s, and *"the blur masks the background-color clash a plain crossfade would expose"*) over a dip.

**Audio.** For a bookend dip, fade the bed with a `volume` automation lane rather than a GSAP tween — the lane wins over a tween anyway (`audio_volume_double_automation`), and its `t` is **clip-local**, with the first point held backwards to the clip start:

```html
<audio id="bed" src="assets/bgm/bed.mp3" data-audio-group="music"
       data-start="0" data-duration="46" data-track-index="11" data-volume="0.6"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:41.5,&quot;v&quot;:1},{&quot;t&quot;:42.2,&quot;v&quot;:0},{&quot;t&quot;:42.9,&quot;v&quot;:1}]}]}"></audio>
```

**ffmpeg — the exact answer for a baked fade.** The `fade` filter operates on encoded values, so run it in linear light to avoid the sag:

```bash
# gamma-correct fade to black: convert to linear, fade, convert back
ffmpeg -i in.mp4 -vf "zscale=transfer=linear,fade=t=out:st=41.5:d=0.5:c=black,\
zscale=transfer=bt709,format=yuv420p" out.mp4

# naive (encoded-space) fade for comparison - visibly muddier at the midpoint
ffmpeg -i in.mp4 -vf "fade=t=out:st=41.5:d=0.5:c=black" out.naive.mp4

# fade to an arbitrary colour, and a matching audio fade
ffmpeg -i in.mp4 -vf "fade=t=out:st=41.5:d=0.5:c=0xF5F0E0" -af "afade=t=out:st=41.5:d=0.7" out.mp4
```
`fade` takes either `start_frame`/`nb_frames` or `start_time`/`duration`; prefer the time form so the command survives an fps change.

**Why `power2` and not linear.** To hold displayed light proportional to the fade progress on a γ≈2.2 display, the encoded overlay alpha must follow `α(t) = 1 − (1−t)^(1/2.2)`, which at the midpoint is **0.27**, not 0.5. GSAP's `power2.in` gives `t²` = 0.25 at the midpoint — close enough to be indistinguishable in an 8-bit render, and far closer than linear's 0.5. Use `linear-light` mode (the `zscale` route) when the fade is long, on a graded image, or on a white dip where the error is most visible.

**Epidemic Sound.** A dip usually wants silence rather than an effect, but a chapter dip often carries a low tonal swell into the hold: `SearchSoundEffects { query: { term: "cinematic low drone swell" }, filter: { duration: { min: 1500, max: 5000 } } }`. Do not put a whoosh on a fade — a whoosh implies lateral movement that is not happening.

**Remotion:** an `<AbsoluteFill>` with an `interpolate()`d background opacity over the same window — conceptually identical; Remotion is not a runtime here.

## Pairs with
[[cut-fade-to-solid-colour]] · [[cut-fade-bookend]] · [[cut-fade-to-white]] · [[cut-dissolve]] · [[sfx-music-fade-out-section-signal]] · [[sfx-silence-as-pattern-interrupt]] · [[motion-format-promise-motion-budget]] · [[struct-numbered-list-mid-roll-sponsor]]

## Failure modes
- **Linear opacity.** The midpoint carries roughly a quarter of the light it should, so the image sags and the fade reads as cheap. Correction: `power2.in`/`power2.out`, or do the blend in linear light.
- **Fading the scenes instead of an overlay.** Produces a gap where both scenes are partly transparent and the page background shows through — and it is the pattern the stack's transition doctrine explicitly bans. Correction: an overlay above both, scenes cut hard underneath.
- **Cut not aligned to full opacity.** If the shot changes one frame before the overlay reaches 1.0, the viewer sees the cut through the veil. Correction: the cut second equals the second the overlay hits opacity 1.
- **Dip used inside an argument.** Empties the screen mid-thought and reads as "that's the end", losing the viewer. Correction: `crossfade` or `push-slide` for within-topic moves; keep dips for boundaries.
- **Too long in short-form.** A 1 s dip in a 30 s video is 3% of the runtime doing nothing. Correction: 8–15 frames each side, no hold.
- **White dip used as a flash.** A 1–3 frame white dip is a flash and stacks with cuts and strobes toward the WCAG limit. Correction: count luminance flips per second across the whole timeline, keep under three.
- **Root-level fill.** Putting the dip colour on the composition root means it silently disappears on the layered-composite path. Correction: full-bleed child.
- **Known gap:** the broad transition catalog names a `color dip` but its implementation file is not staged in this project, so no library code can be cited for it. The hand-authored overlay above is built from primitives the contract does confirm; treat the catalog name as a label, not as an available implementation.
