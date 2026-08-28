---
id: cut-full-screen-transition
title: Full-screen transitions — cover the whole frame when nothing matches
skill: editing
type: transition
family: covered-cut
tags: [skill/editing, type/transition, family/covered-cut, layer/sfx, sfx/motion, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:58"
    quote: "Another way to make transitions seamless is to use a full-screen transition. There are tons of free packs out there, but if you like my subtle style, I've got something for you in the description."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:31"
    quote: "Visual continuity: a seamless flow of images with no rough edges, invisible editing and a captivating experience."
research_refs:
  - https://www.premiumbeat.com/blog/create-seamless-transitons-whip-pan/
  - https://tutvid.com/premiere-pro/whip-pan-blurring-transition-effect-premiere-pro/
  - https://en.wikipedia.org/wiki/Whip_pan
  - https://sonilo.com/blog/guides/transition-effect-sound-video-edits
  - https://www.epidemicsound.com/blog/5-adobe-premiere-pro-transition-effects/
  - https://www.flexclip.com/learn/transition-sound-effects.html
difficulty: medium
detectable_from: transcript+video
---

# Full-screen transitions — cover the whole frame when nothing matches

## What it is
When two shots cannot be reconciled by matching anything — no shared shape, no shared movement, no shared audio, different location, different grade — you cover the seam instead of hiding it. A full-screen transition is an element or effect that **occupies 100% of the frame for a short window**, during which the outgoing picture is replaced. Because nothing of either shot is visible at the midpoint, no continuity between them is required: the eye is given a single continuous event to follow instead of a discontinuity to notice. The families that do this are whip pans and directional blurs, luma/ink/paint wipes, light leaks and overexposure burns, glitch and chromatic distortions, blur dissolves and focus pulls, and staggered block/blind covers. The source's stated preference is the important half of the note: *"if you like my **subtle** style"* — a full-screen transition is a seam-cover, not a set piece, and free packs are treated as commodity assets rather than as a look.

## When to use it
The trigger is a **failed match**: you wanted a graphic, movement or audio match at this boundary and the footage does not support one ([[cut-graphic-match]], [[cut-movement-match]], [[cut-audio-match]]). Second trigger: a **genuine location or topic change** where a straight cut would read as an error rather than a full stop — different room, different grade, different time. Third: **inside a montage or a B-roll run** where the transition is carrying the energy rather than the information. Fourth: at the **opening** of a video, where the catalog's own narrative guidance puts the most distinctive transition. Do **not** use one at a boundary where a straight cut is *meaning* something (a full stop, an act break, a music stop, a smash cut), do not use one to fix a badly chosen cut point (it will still be badly chosen, just louder), and do not use one on every cut — the whole ladder of devices collapses if the frame is covered twenty times a minute. Budget rule from the transition catalog, quoted: *"Pick **2-3 types for the whole video** and repeat them — repetition is what reads as professional."*

## How to recognise it in a reference video
- **Find the covered window, not the cut.** A full-screen transition shows as a **short run of frames with anomalous global statistics** rather than as a single boundary. Measure per-frame luma mean and standard deviation:
  ```bash
  ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=yavg.txt" -f null -
  ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YDIF:file=ydif.txt" -f null -
  ```
  The signatures: **light leak / burn** = YAVG spikes toward white, typically **+40 to +120** above the local baseline for 6–15 f. **Whip pan / directional blur** = YDIF (inter-frame difference) spikes hard while spatial detail collapses — high motion, low high-frequency energy. **Blur dissolve / focus pull** = detail collapses with YAVG roughly flat. **Glitch** = a 2–5 f burst of extreme YDIF with chroma excursions. **Wipe** = a moving hard edge; YAVG changes monotonically over the window while a row/column profile shows a travelling boundary.
- **Measure three durations separately.** `total` (first anomalous frame → last), `covered` (frames where **neither** shot is identifiably visible), and `overlap` (frames where both contribute). A subtle transition has **total 9–18 f (0.30–0.60 s)** and **covered 4–8 f (0.13–0.27 s)**. A showy pack preset runs total 24–45 f with covered 12–20 f. This is the single most useful number for reproducing a reference's *style*.
- **Direction, and whether it was matched.** For a whip pan or push, extract the dominant motion vector either side of the window. In a well-built one, the outgoing shot's motion, the transition's motion, and the incoming shot's motion **all point the same way**; a pack applied blindly has the transition moving left across two static shots.
  ```bash
  ffmpeg -i ref.mp4 -vf "mestimate=method=epzs,metadata=print" -f null - 2>&1 | head -50
  ```
- **Always check the audio.** A full-screen transition with no sound is a strong tell that it came from a video-only pack. Look for a **whoosh/riser rising into the covered window and a soft impact or held note on it** — the published description of the shape. On the RMS trace (`asetnsamples=n=1600` at 48 kHz = 1 frame at 30 fps) expect a ramp beginning **6–15 f before** the covered window and a peak within **±2 f** of its centre.
- **Music behaviour.** Professionally the bed dips **3–6 dB** under the transition sound with a quick recovery. A bed that does not move at all under a loud whoosh is a mix that was never touched.
- **Count them and compute the density.** Full-screen transitions ÷ total boundaries. Retention-focused creator work runs **0.03–0.12**; a pack-happy edit runs above 0.30. Also count **distinct types**: 2–3 across a whole video is the professional signature; 8 different transitions is an asset-pack tour.
- **Position them in the runtime.** Log each as a fraction of total duration and against the section map. Expect them clustered at section boundaries and the opening, and absent inside continuous explanation.
- **Transcript cross-check.** A full-screen transition almost always lands in a **speech gap** and very often on an explicit structural line ("so", "next", "point number three"). One landing mid-sentence is either a mistake or a deliberate smash.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `total_dur` | 15 f (0.50 s) | 9–18 f (0.30–0.60 s) | Registry `default_duration_s` for the machine transitions: crossfade 0.5 · blur-crossfade 0.6 · push-slide 0.5 · zoom-through 0.4 · squeeze 0.4. Registry hard cap `max_duration_s: 2.0`. |
| `covered_dur` | 6 f (0.20 s) | 4–8 f (0.13–0.27 s) | Frames where neither shot is identifiable. This is what "subtle" actually controls. |
| `energy_band` | medium | calm / medium / high | Calm **0.5–0.8 s**, `sine.inOut`/`power1` · medium **0.3–0.5 s**, `power2`/`power3` · high **0.15–0.3 s**, `power4`/`expo`. |
| `blur_px` | 12 px | calm 20–30 · medium 8–15 · high 3–6 | With hold: calm 0.3–0.5 s, medium 0.1–0.2 s, high none. |
| `whip_blur_len` | 250 px @1080p | 120–400 | Directional blur length in a whip pan; direction 90° for a horizontal whip. |
| `whip_pre_frames` | 5 f | 3–8 f | Frames of build **before** the cut point (the published adjustment-layer recipe). |
| `whip_post_frames` | 10 f | 6–14 f | Frames of settle **after** the cut point. Total 15 f. |
| `direction_match` | required | — | Transition direction = incoming shot's dominant motion direction. `LEFT`/`RIGHT`/`UP`/`DOWN` for `push-slide` (registry default `LEFT`). |
| `types_per_video` | 3 | 2–3 | Catalog budget. The Tier-A `shared-element` morph is exempt from the count. |
| `density` | 0.06 | 0.03–0.12 | Full-screen transitions ÷ all boundaries. |
| `sfx_lead` | 9 f (0.30 s) | 6–15 f | Whoosh onset before the covered window. |
| `sfx_level` | −13 dB | −12 to −15 dB | Motion-SFX band, against dialogue at 0 to −3 dB. |
| `music_duck` | −4 dB | −3 to −6 dB | Bed dip under the transition sound, quick recovery. |
| `opening_dur` | 0.5 s | 0.4–0.6 s | Catalog narrative position: opening = most distinctive. Outro 0.6–1.0 s, slowest and simplest. |

## Reproduction prompt

```
Build a full-screen transition at boundary {{CUT}} (seconds, 30fps) between
outgoing scene {{FROM}} and incoming scene {{TO}}.

1. JUSTIFY IT FIRST. Confirm no match exists at this boundary: no shared
   shape, no shared motion vector, no shared audio event, no matched framing.
   If a match DOES exist, stop - use the matched cut, it is always better.
2. PICK THE TYPE from the project's 2-3 approved types, chosen by energy:
   calm -> blur-crossfade (0.6s, sine.inOut); medium -> push-slide (0.5s,
   power3); high -> zoom-through (0.4s, power4/expo). Do not introduce a
   fourth type for one boundary.
3. SET THE DIRECTION from the INCOMING shot. Measure its dominant motion
   vector in its first 15 frames and point the transition the same way. A
   static incoming shot takes a non-directional type (blur-crossfade,
   zoom-through), never a push.
4. TIME IT. Total 15 frames (0.50s): 5 frames of build before {{CUT}}, a
   fully covered window of 6 frames, then 4 frames of settle. The outgoing
   scene must be FULLY VISIBLE when the transition starts - do not fade it
   out first and then start the transition. Outgoing and incoming animate at
   the SAME timeline position.
5. SOUND IT, ALWAYS. One whoosh whose onset is 9 frames before the covered
   window and whose peak lands within 2 frames of the covered midpoint, at
   -12 to -15 dB. Duck the music bed by 4 dB across the transition window
   with a quick recovery. A full-screen picture move with no sound is the
   single clearest sign of a pack applied blindly.
6. PROVE IT IS SUBTLE. Watch the boundary at full speed three times. If you
   notice the transition before you notice the new shot, halve the covered
   window and reduce the blur by a third.

ACCEPTANCE TEST: (a) frame-step - at the covered midpoint neither shot is
identifiable, and no frame is black unless black was chosen; (b) the
transition's motion direction agrees with the incoming shot's; (c) the
whoosh peak is within 2 frames of the covered midpoint; (d) across the whole
video no more than 3 distinct transition types appear and full-screen
transitions are under 12% of all boundaries.
```

## Execution spec

**HyperFrames (primary).** Two routes, and the contract is explicit about which is real.

*Route 1 — the machine registry (5 transitions, Tier-B ready).* Pure transform/opacity/filter on the two scene **clip wrappers** (`#el-<sid>`), no injected overlay DOM. This is the only route whose GSAP is verified in the contract.

```js
// blur-crossfade at T = 21.40s, 0.6s (18f). __OLD__ = "#el-scene-a", __NEW__ = "#el-scene-b"
const T = 21.40, DUR = 0.6;
tl.to("#el-scene-a", { opacity: 0, filter: "blur(12px)", duration: DUR, ease: "power2.inOut" }, T);
tl.fromTo("#el-scene-b", { opacity: 0, filter: "blur(12px)" },
                         { opacity: 1, filter: "blur(0px)", duration: DUR, ease: "power2.inOut" }, T);

// zoom-through at high energy, 0.4s (12f) — verbatim registry template
tl.to("#el-scene-a", { scale: 2.5, opacity: 0, filter: "blur(8px)", duration: 0.4, ease: "power3.in" }, T);
tl.fromTo("#el-scene-b", { scale: 0.5, opacity: 0, filter: "blur(8px)" },
                         { scale: 1, opacity: 1, filter: "blur(0px)", duration: 0.4, ease: "power3.out" }, T);
```
The boundary arithmetic the injector performs, and which you must replicate by hand: **(1)** extend `#el-<from>`'s `data-duration` by `duration_s` so it holds its final frame; **(2)** pull `#el-<to>`'s `data-start` **earlier** by `duration_s` to create the overlap; **(3)** put the two overlapping wrappers on different `data-track-index` values (a 0/1 ping-pong — a readability convention, not a render constraint, since layering is CSS `z-index`); **(4)** stamp the tweens at `T` = overlap start.

Four non-negotiables from the multi-scene rules, all quoted: *"Every composition uses transitions"*; *"Every scene uses entrance animations"* via `gsap.fromTo()` (never `from()`, which sets `immediateRender: true` and flashes under non-linear seek); **exit animations are BANNED except on the final scene — "The transition IS the exit"**; the last scene may fade out. The banned pattern is fading the outgoing scene at T and starting the incoming at T+DUR — *"a jump cut with a dip, not a transition."*

*Route 2 — a real full-screen overlay element* (a light leak, an ink wipe, a whip-pan sheet). This is a normal timed clip on a high `z-index` with a GSAP tween, and it is how the "free pack" case is actually built:
```html
<video id="tr-leak" src="assets/transitions/light-leak-01.mp4" muted playsinline class="clip"
       data-start="21.15" data-duration="0.50" data-media-start="0.30" data-track-index="5"
       style="position:absolute; inset:0; z-index:50; mix-blend-mode:screen; object-fit:cover"></video>
```
Note `mix-blend-mode: screen` is what makes a light-leak plate composite rather than sit on top. `filter`, `scaleX` and `transformOrigin` are lint-clean **on the master timeline** — the `x/y/scale/rotation/opacity` whitelist is a scene-worker prompt rule only and does not bind `index.html`.

*Shader route.* `@hyperframes/shader-transitions` provides `whip pan`, `SDF iris`, `cross-warp morph`, `domain warp`, `light leak`, `glitch`, `chromatic split`, `ripple waves`, `swirl vortex`:
```js
var tl = HyperShader.init({ bgColor: "#000", accentColor: "#6366f1",
  scenes: ["s1","s2","s3"],
  transitions: [{ time: 21.40, shader: "whip-pan", duration: 0.4 }] });
```
Let `HyperShader` create the timeline; add beat animations to the returned `tl` after the call. Capture constraints: no `transparent` keyword in gradients, no CSS `var()` on elements visible during capture, every `.scene` div needs an explicit `background-color` matching `bgColor`, mark uncapturable decoratives `data-no-capture`, and a full-screen fill on the composition **root** is dropped on the layered-composite path — put it on a full-bleed child (`position:absolute; inset:0`).

**Known gaps to state plainly.** The ≈40-name broad catalog (`catalog.md`, `css-*.md`) was **not staged**: the names — whip pan, light leak, overexposure burn, film burn, circle/diamond iris, diagonal split, clock wipe, shutter, staggered blocks, blinds, glitch, chromatic aberration, ripple, VHS, grid dissolve, morph circle — are citable but **no implementation is available**, so a spec must either use a registry transition, hand-author the tween, or use an overlay plate. Explicitly **do not work in CSS**: star iris, tilt-shift, lens flare, hinge/door. `@hyperframes/shader-transitions` is **not verified as installed** here. And the transition-injector script itself is not staged, so the four boundary steps above must be done by hand.

**ffmpeg.** Only for producing a plate or a preprocessed whip. A practical whip-pan plate from real footage is a speed ramp — and **there is no rate envelope in HyperFrames** (`data-playback-rate` is a constant in 0.1..5), so a ramp *must* be preprocessed:
```bash
# fast whip from the tail of a pan: 8x speed on the last 0.8s, then blur it
ffmpeg -i pan.mp4 -filter_complex "[0:v]trim=start=4.2:end=5.0,setpts=(PTS-STARTPTS)/8,\
 tblend=all_mode=average,boxblur=40:1:0:0[v]" -map "[v]" -an whip_plate.mp4
```
`xfade` is available for a baked transition when the deliverable leaves the pipeline:
```bash
ffmpeg -i a.mp4 -i b.mp4 -filter_complex "[0][1]xfade=transition=fadewhite:duration=0.5:offset=21.4[v]" \
  -map "[v]" out.mp4
```

**Epidemic Sound.** Every full-screen transition gets a sound. Queries that map to the families:
- whip pan / push: `SearchSoundEffects { query.term: "fast whoosh transition swoosh short", filter.duration { max: 1500 } }`
- light leak / burn: `SearchSoundEffects { query.term: "cinematic transition riser airy whoosh" }`
- glitch: `SearchSoundEffects { query.term: "digital glitch stutter transition" }`
- impact on the covered frame: `SearchSoundEffects { query.term: "soft cinematic impact hit sub" }`
Place with `data-audio-group="sfx"` (never the `voiceover` carve group), `data-volume` ≈ `0.22` (≈ −13 dB), and duck the bed 3–6 dB with a `volume` lane on the music clip. Vary a reused whoosh with **pitch, reverb and duration** rather than fetching forty files.

**Remotion:** conceptually `<TransitionSeries>` with a presentation and a timing function; no Remotion runtime exists in this project.

## Pairs with
[[sfx-whoosh-transition-movement-reveal]] · [[sfx-riser-anticipation-build]] · [[cut-graphic-match]] · [[cut-movement-match]] · [[cut-dissolve]] · [[cut-straight-hard-cut]] · [[cut-invisible-storytelling-doctrine]] · [[sfx-unsounded-motion-audit]] · [[sfx-av-sync-binding-window]] · [[motion-look-finishing-pass]] · [[struct-music-arc-to-narrative-arc]]

## Failure modes
- **Silent transitions.** The frame does something violent and nothing is heard. The brain expects a sound on motion and its absence reads as fake. Fix: whoosh on every one, onset 9 f early, peak on the covered midpoint.
- **Direction contradicting the shot.** A left-to-right whip into a shot panning right feels like a mistake nobody can name. Fix: take the direction from the incoming shot's motion; use a non-directional type over static footage.
- **Using one to rescue a bad cut point.** The transition covers the frame, not the error; the boundary still lands mid-thought. Fix: fix the cut point from the transcript first, then decide whether it still needs covering.
- **Pack tourism.** Eight different transitions in eight minutes. Fix: 2–3 types for the whole video, repeated.
- **Too long, too visible.** Total 30 f+ with a 20 f covered window is a set piece; the source's word is *"subtle"*. Fix: total 9–18 f, covered 4–8 f.
- **Fading the outgoing scene out before starting the incoming.** Explicitly banned in the multi-scene rules — it produces *"a jump cut with a dip, not a transition."* Fix: both scenes animate at the same timeline position `T`.
- **`gsap.from()` on the incoming scene.** `immediateRender: true` writes the from-state at construction, before the scene's `data-start` is active; under the render engine's non-linear seek the entrance flashes or is skipped. Fix: always `fromTo()`.
- **CSS `transform` on an element GSAP also tweens.** Lint error `gsap_css_transform_conflict`. Fix: express the initial state in the `fromTo()` from-object.
- **Repeating geometric patterns.** Blanket catalog warning: *"Avoid transitions that create visible repeating geometric patterns... the eye instantly sees the grid."* Fix: prefer organic noise (FBM, domain warp) over grids and blinds.
- **A `crossorigin` attribute on the overlay plate.** Hard lint error with **no suppression**. Fix: host the plate locally inside the project.
- **Known gap:** the CSS/shader transition catalog and the injector script are not staged, and no CDN is reachable, so a spec naming `light leak` or `film burn` must supply its own overlay plate or hand-authored tween. Say which in the design document.
