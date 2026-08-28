---
id: motion-look-finishing-pass
title: The look pass — grade, vignette, subtle particles, in that order
skill: editing
type: motion
family: look-pipeline
tags: [skill/editing, type/motion, family/look-pipeline, engine/ffmpeg, engine/hyperframes, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:17"
    quote: "Another immersion hack is to simply make the video look good. That can be color grading, adding a vignette, or some subtle particle animations."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:26"
    quote: "And while we're on the subject of making things look good, let's focus on making them feel good."
research_refs:
  - https://cromostudio.it/cromo-tips/understanding-nodes-and-node-order-in-davinci-resolve
  - https://animationpatterns.art/animations/film-overlay-compositing/
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://aaapresets.com/blogs/camera-specific-color-grading-series/mastering-the-node-tree-your-ultimate-guide-to-blackmagic-pocket-4k-6k-color-grading-in-2026
  - https://www.capcut.com/resource/film-grain-in-after-effects
difficulty: medium
detectable_from: video
---

# The look pass — grade, vignette, subtle particles, in that order

## What it is
The last visual pass over a locked timeline, treated as an **immersion mechanism rather than decoration**: a consistent grade so every source looks like it belongs to one video, a vignette so the eye stays inside the frame, and — optionally — a low-density particle or grain layer so the image has texture instead of reading as flat digital. The source names exactly these three. Their order is not arbitrary and is the part most often got wrong: **normalise → match → primary → creative look → vignette → grain/particles**, because a vignette applied before the look gets crushed or lifted by it, and grain applied before anything else gets graded into stripes.

## When to use it
Run it once, after picture lock and after motion, on a timeline nobody intends to re-cut — every parameter here is global and re-running it per revision is wasted work. It earns its place in three situations specifically: the video mixes **sources that do not match** (camera A-roll, phone B-roll, stock, screen recordings); the video has long static A-roll holds where a flat image reads as cheap; or the format is aspirational/cinematic rather than utilitarian. Skip the particles entirely on tutorial and screen-recording content, where texture over UI reads as a compression artefact. Skip the vignette on anything that will be re-cropped for vertical — the vignette centre moves and the crop reveals the falloff.

## How to recognise it in a reference video
- **Corner falloff (the vignette test).** Extract a frame with an evenly-lit background and compare mean luma in a 10%-wide corner box against the centre box. A subtle vignette shows corners **6–15% darker**; a heavy one **20–35%**; nothing means no vignette. Verify it is a *post* vignette rather than a lens artefact by checking that the falloff is **identical across shots from different cameras** — that identity is the tell.
  ```bash
  ffmpeg -ss 92 -i ref.mp4 -frames:v 1 f.png
  ffmpeg -i f.png -vf "crop=iw*0.1:ih*0.1:0:0,signalstats,metadata=print" -f null - 2>&1 | grep YAVG
  ffmpeg -i f.png -vf "crop=iw*0.1:ih*0.1:iw*0.45:ih*0.45,signalstats,metadata=print" -f null - 2>&1 | grep YAVG
  ```
- **Grade consistency across sources.** Sample 8–12 frames spanning every source type and compare black point, white point and mid-tone hue. A graded video holds **black point within ±3 IRE** and skin-tone hue **within ±6°** across sources. A wide spread means each clip was left as shot.
- **Look direction.** Read the shadow tint and the highlight tint separately. Teal-shadow/warm-highlight, warm-across, and lifted-matte-blacks (black point raised to 4–8 IRE) are the three most common creator looks. Log which, and log the **black lift value** — it is the single most portable number in a look.
- **Saturation shape.** A creative look almost always desaturates or compresses one hue band. Compare a colour chart shot or a known object across sources if one exists.
- **Grain / texture.** Zoom to 200% on a flat area (a wall, sky, a solid graphic). Real added grain is **uniform across the frame and static in size** while the image moves; sensor noise varies with brightness and camera. Grain that also sits **on top of the graphics and titles** is a full-frame overlay applied last — the correct build.
- **Particles.** Look for slow, low-contrast motes drifting **independently of camera motion** (they do not parallax), typically **8–25 elements** on screen, opacity so low they vanish against bright areas. If they move with the picture, they are in the footage, not the overlay.
- **Where the look is not applied.** Check the titles and motion graphics. If the grade/vignette stops at the edge of the A-roll and the graphics are untouched, the look was applied per-clip rather than as a finishing layer — worth logging, because it changes how you reproduce it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `pass_order` | normalise → match → primary → look → vignette → grain/particles | fixed | Vignette after the look, before any glow; grain always last. |
| `match_target` | the hero A-roll shot | — | Match every other source to one chosen shot, never to a scope ideal. |
| `match_sequence` | exposure → white balance → contrast → saturation → hue | fixed | Fixing hue before exposure is wasted work. |
| `black_point` | 2 IRE | 0–8 IRE | 4–8 IRE is the "lifted matte" look; 0 is clean digital. |
| `white_point` | 95 IRE | 90–100 IRE | Leave headroom unless the look is deliberately clipped. |
| `saturation` | 1.00 | 0.85–1.10 | Creator looks usually sit slightly **under** 1.0; over 1.05 reads as a phone filter. |
| `look_strength` | 0.6 | 0.3–0.8 | Fraction of the creative LUT mixed in. A LUT at 100% is the amateur signature. |
| `vignette_angle` | PI/5 (36°) | PI/6 subtle – PI/4 strong | ffmpeg's `vignette` filter parameter; larger angle = stronger. |
| `vignette_corner_drop` | 10% | 6–18% | Measured luma drop, corner vs centre. Above 20% it is a look, not a frame. |
| `vignette_inner_stop` | 50% of radius | 42–60% | Where falloff begins. Below 42% it eats the subject. |
| `vignette_blend` | multiply | multiply | Screen/overlay vignettes go grey rather than dark. |
| `grain_opacity` | 0.10 | 0.06–0.20 | Overlay blend. Above 0.25 it is a stylistic statement and needs a reason. |
| `grain_tile` | 32 px | 24–64 px | A tile smaller than ~24 px moires on high-DPI displays. |
| `particle_count` | 14 | 8–25 | On screen at once, at 1080p. |
| `particle_opacity` | 0.12 | 0.05–0.20 | Screen blend on dark elements. |
| `particle_speed` | 12 px/s | 6–25 px/s | Slow enough that no viewer tracks an individual mote. |
| `particle_blur` | 2 px | 0–6 px | Slight blur is what separates "atmosphere" from "dirt on the lens". |
| `applies_to` | whole frame, including graphics | — | The pass is a finishing layer above everything, not a per-clip effect. |

## Reproduction prompt

```
Apply the look pass to the locked timeline. Do the six stages in order and
do not start until picture and motion are locked.

1. NORMALISE. Bring every source to the same working range: correct
   exposure and white balance per source until black points and skin hue
   agree. Choose ONE hero A-roll shot as the match target and match every
   other clip to it, in this order: exposure, white balance, contrast,
   saturation, hue. Acceptance: black point within +/-3 IRE and skin hue
   within +/-6 degrees across all sources.
2. PRIMARY. Set the video's black point to {{BLACK}} (default 2 IRE, use
   4-8 for a lifted matte look), white point to about 95 IRE, saturation
   {{SAT}} (default 1.00, never above 1.05).
3. LOOK. Apply the creative LUT or curve at {{LOOK_STRENGTH}} (default 0.6,
   never 1.0). One look for the whole video. If a section needs a different
   look, that is a narrative decision and must be stated in the design
   document, not improvised here.
4. VIGNETTE, after the look. Centred, elliptical, falloff starting at 50%
   of the radius, corners 10% darker than centre, multiply blend. Verify by
   measurement, not by eye.
5. GRAIN (optional). Full-frame, above everything including titles and
   graphics. Overlay blend, opacity 0.10, tile 32px. Advance it in discrete
   steps, not smooth motion.
6. PARTICLES (optional, and skip entirely for screen-recording or tutorial
   content). 14 elements at 1080p, opacity 0.12, screen blend, 2px blur,
   drifting at about 12 px/s. Every position, size and phase must be
   derived from the element's INDEX - no random numbers, no wall-clock
   animation, finite repeat counts only.
7. ACCEPTANCE TEST: (a) measure corner-vs-centre luma - 6-18% drop;
   (b) sample 8 frames across different sources - black point spread under
   3 IRE; (c) scrub the whole video at 4x - the look must not change at any
   cut except a deliberate one; (d) view at 100% and at phone size - if the
   particles are visible as objects at phone size, halve their opacity;
   (e) render two frames 1 second apart twice and diff them - the pass must
   be bit-identical across renders.
```

## Execution spec

**Two routes, and the choice matters.** Grading footage is a *raw media* operation (ffmpeg); the vignette, grain and particles are a *composition* layer (HyperFrames). Do not try to grade inside the composition — there is no colour-management surface there — and do not bake the vignette into the footage, because it must also cover the graphics.

**ffmpeg — the grade, per source or per clip, producing files that re-enter as `src`:**

```bash
# normalise + match + creative LUT at partial strength
ffmpeg -i broll_phone.mp4 -vf "\
 eq=contrast=1.04:brightness=0.01:saturation=0.97,\
 curves=master='0/0.016 0.5/0.5 1/0.95',\
 lut3d=file=looks/house.cube" \
 -c:v libx264 -crf 18 -preset slow -c:a copy graded/broll_phone.mp4
```
`lut3d` applies the LUT at full strength; for `look_strength = 0.6`, blend the graded and ungraded streams:
```bash
ffmpeg -i in.mp4 -filter_complex "[0:v]split[a][b];[b]lut3d=file=looks/house.cube[g];\
 [a][g]blend=all_mode=normal:all_opacity=0.6[v]" -map "[v]" -map 0:a -c:v libx264 -crf 18 out.mp4
```
A baked vignette, only for a deliverable leaving the pipeline: `-vf "vignette=PI/5"` (default angle is `PI/5`; `PI/6` is subtle, `PI/4` strong). Register any produced file afterwards (`resolve --from <file> --type grade`). Keep scratch output outside the vault mount, which cannot delete files.

**HyperFrames — the vignette, grain and particles as a finishing layer above everything.** Two contract traps here, both silent:
- An **untimed** full-bleed element is skipped by the root's automatic layout, so it needs its own `position: absolute; inset: 0` or it collapses to zero height.
- A full-screen fill on the composition **root** is dropped on the layered-composite path (HDR, or any composition using shader transitions) — put the fill on a full-bleed **child**, which is what this is anyway.

```html
<!-- finishing layer: last in DOM order, high z-index, no data-start (covers the whole render) -->
<div id="look-vignette" style="position:absolute; inset:0; z-index:900; pointer-events:none;
     mix-blend-mode:multiply;
     background:radial-gradient(ellipse at center, rgba(255,255,255,1) 50%, rgba(0,0,0,0.90) 100%);"></div>
<div id="look-grain" style="position:absolute; inset:0; z-index:901; pointer-events:none;
     mix-blend-mode:overlay; opacity:0.10;
     background-image:url('assets/grain-32.png'); background-size:32px 32px;"></div>
<div id="look-particles" style="position:absolute; inset:0; z-index:902; pointer-events:none;
     mix-blend-mode:screen; opacity:0.12; filter:blur(2px);"></div>
```
The grain must **advance in discrete steps**, never drift smoothly, and every motion here must be attached to the composition's single paused timeline:

```js
// grain: 4-phase shuffle, finite repeats — no wall-clock, no repeat:-1
tl.to("#look-grain", { backgroundPosition: "32px 16px", duration: 0.1, ease: "steps(1)", repeat: 59, yoyo: true }, 0);

// particles: positions and phases derived from index, never Math.random()
const N = 14;
for (let i = 0; i < N; i++) {
  const p = document.createElement("div");
  const x = ((i * 37) % 100), y = ((i * 61) % 100), s = 2 + (i % 3);
  p.style.cssText = `position:absolute;left:${x}%;top:${y}%;width:${s}px;height:${s}px;
                     border-radius:50%;background:#fff;`;
  document.getElementById("look-particles").appendChild(p);
  tl.to(p, { y: -120, x: (i % 2 ? 30 : -30), duration: 10 + (i % 5), ease: "none", repeat: 5 }, -(i * 0.7));
}
```
Determinism is not optional: **no `Date.now()`/`performance.now()`, no unseeded `Math.random()`, no `repeat: -1`**, and an ambient pulse must attach to the seekable `tl` rather than a bare `gsap.to()` — a standalone tween runs on wall-clock and is simply absent from the render. Do not tween `display`/`visibility` on a clip element; use `autoAlpha` on a non-clip wrapper. Do not put a CSS `transform` on an element you also GSAP-tween (`gsap_css_transform_conflict`, a hard error that additionally switches off the layout and contrast audits so `check` reports a meaningless clean result).

Exclude the finishing layer from layout audits if it trips them: `data-layout-ignore` on the three overlay divs is the right escape hatch here, and is narrower than `data-layout-allow-overflow`, which inherits down a whole subtree.

**Epidemic Sound:** nothing. This pass is silent by definition — if a particle needs a sound, it is not subtle enough.

**Remotion:** the same three layers as absolutely-positioned components with `interpolate` driving the drift; concept only, no Remotion runtime here.

**Known stack gap:** this project has **no colour management** — no working-space transform, no scopes, no per-shot matching UI. The match stage is therefore eyeballed against extracted frames plus `signalstats`, which is enough for consistency but not for a genuine multi-camera match. Say so in the design document rather than claiming a graded deliverable. Rendering itself is browser-dependent and must happen off the authoring VM.

## Pairs with
[[cut-dissolve-time-passage]] · [[cut-punch-in-emphasis]] · [[pace-overlay-instead-of-cut]] · [[struct-stimulation-budget]] · [[cut-fade-to-white]] · [[pace-silent-demonstration-window]]

## Failure modes
- **LUT at 100%.** The single most recognisable amateur signature: crushed blacks, clipped highlights, skin gone orange. Fix: 0.6 strength, and correct exposure before the LUT rather than with it.
- **Vignette before the look.** The look then lifts or crushes the falloff and the vignette either disappears or turns into a black frame border. Fix: obey `pass_order`.
- **Vignette too strong.** Over ~20% corner drop the frame reads as a telescope. Fix: measure rather than eyeball; 6–18%.
- **Grain under the graphics.** Grain applied per-clip leaves titles and motion graphics clean and instantly reveals them as pasted on. Fix: one full-frame layer above everything.
- **Particles that read as dirt.** Too many, too fast, too sharp, or too bright. Fix: 8–25 elements, ≤0.2 opacity, ~12 px/s, 2 px blur; check at phone size where most viewing happens.
- **Random particles.** `Math.random()` and wall-clock loops break determinism — the render will not match the preview and two renders will not match each other. Fix: index-derived values, finite repeats, everything attached to the paused timeline.
- **Per-section look drift.** A grade applied clip by clip drifts across the video and every cut becomes visible as a colour jump. Fix: one look for the whole video; match to a hero shot.
- **Grading a timeline that will be re-cut.** All of this is global and gets thrown away by a re-order. Fix: picture lock first.
- **Known gap:** the node-order and vignette-placement guidance comes from grading practice documentation, and the CSS blend/opacity numbers from a compositing reference; neither is a measured standard. The IRE tolerances (±3 black point, ±6° skin hue) are house review thresholds, not published specifications.
