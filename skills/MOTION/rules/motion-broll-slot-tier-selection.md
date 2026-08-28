---
id: motion-broll-slot-tier-selection
title: Pick the B-roll tier before you build — shot, stock, or motion graphic
skill: motion
type: graphic
family: b-roll
tags: [skill/motion, type/graphic, family/b-roll, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:53"
    quote: "A few variations of B-roll are stock footage, which is basically the easy version, and motion graphics."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:19"
    quote: "B-roll is extra footage shot separately from the audio — a visual representation of your words."
research_refs:
  - https://www.pexels.com/license/
  - https://support.google.com/youtube/answer/138161
  - https://www.remotion.dev/docs/the-fundamentals
  - https://docs.manim.community/en/stable/tutorials/output_and_config.html
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: transcript+video
---

# Pick the B-roll tier before you build — shot, stock, or motion graphic

## What it is
The creator's footage taxonomy puts four things in one slot: A-roll, shot B-roll, stock footage ("basically the easy version") and motion graphics. Three of the four are interchangeable *cutaways* — they occupy the same slot, same duration, same layer, and answer the same editorial need: give the eye something new that means what the voice is saying. This note is the **routing decision** that comes before any of the build notes: for a given transcript beat, which tier fills the slot, at what cost, and what conform work each tier drags in. It is a decision, not a preference — the wrong tier is the single most common reason a cutaway reads as filler.

The three tiers differ on exactly two axes: **can it be photographed** (stock and shot B-roll require a thing that exists in front of a lens) and **is the beat a mechanism** (motion graphics are the only tier that can show causation, quantity, or relationship).

## When to use it
Run this decision once per cutaway slot identified by the coverage pass ([[cut-b-roll-coverage-from-transcript]]), before any asset is fetched or built. The routing test, in order:

1. **Does the sentence name a concrete, photographable noun you can shoot yourself?** → shot B-roll. Always first choice; it is the only tier that is *yours*.
2. **Concrete noun you cannot shoot** (a city you are not in, a scale, an era, a machine you do not own)? → stock ([[cut-stock-footage-substitute]]).
3. **Is the beat a mechanism, a quantity, a comparison, a list, or a definition?** Look for "because", "which means", "so then", a number, a versus, an enumeration → motion graphic ([[motion-graphics-broll-slot]]). Footage of a server rack cannot show what the request does inside it.
4. **None of the above** — the line is abstract *and* not a mechanism → the beat wants A-roll held, an emphasis caption ([[sub-emphasis-caption-three-words]]), or a cut. Do not spend a slot on a decorative clip.

Budget rule that makes the routing real: a motion graphic costs roughly an order of magnitude more per second than a stock clip, so a video gets **two or three** of them — spent on the beats the argument turns on — and lets the other tiers carry the rest.

## How to recognise it in a reference video
- **Count the tiers per minute and log the ratio.** A typical explainer profile runs 6–14 cutaways/min with a tier split near 60 % shot / 25 % stock / 15 % graphic. A reference that is >50 % stock is a different (and weaker) format; log it as such.
- **Stock tells on four signals:** (a) a grade that does not match the A-roll — compare `signalstats` `YAVG`/`SATAVG` across the boundary; (b) an aspect or resolution mismatch showing as softness on a punch-in; (c) unmotivated slow motion (a 60fps clip conformed to 30 by half-speed); (d) generic-actor eye lines and stock composition (dead centre, wide, nobody looking at anything).
- **Motion graphics tell on:** flat vector or type on a solid/gradient plate, elements that *enter* rather than *appear*, stagger across siblings, and a colour palette identical to the channel's lower thirds. A graphic whose entrance is 0.3–0.5 s with a long-tail ease was authored; a graphic that pops on in one frame was probably a still.
- **Frame-rate forensics:** step frames and look for a 2-3 cadence or repeated frames inside one cutaway but not its neighbours — that is a 24/25fps stock clip inside a 30fps timeline.
- **Transcript correlation is the decisive test.** Pull the sentence under the cutaway. If it contains a causal or quantitative structure and the picture is a photograph, the reference made a tier error — log the *beat*, not the clip, in the design document.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `slot_duration` | 2.0 s (60 f) | 1.2–4.0 s (36–120 f) | Under 1.2 s a cutaway is not read, it is only registered; over 4 s it becomes a scene and needs its own internal motion. |
| `tier` | shot | `shot` · `stock` · `graphic` | Chosen by the four-step routing test, recorded per slot in the design document. |
| `graphic_budget_per_video` | 3 | 2–5 | Hard cap. More than 5 and the video becomes an animation project. |
| `stock_share_ceiling` | 30 % | 0–40 % | Of total runtime. Above this the video reads as assembled rather than made. |
| `stock_source_resolution` | 3840×2160 | ≥2× delivery | 4K into a 1080p timeline gives exactly **2× linear** headroom — punch-ins to 200 % stay pixel-native. |
| `stock_fps_conform` | match timeline | 24/25/30/60 | Conform by resample, not by playback rate, unless the slow motion is wanted. |
| `graphic_entrance` | 0.40 s (12 f) | 0.27–0.50 s (8–15 f) | `power3.out`. The house entrance band. |
| `graphic_stagger` | 0.06 s (2 f) each | 0.05–0.10 s | Total stagger across all siblings must stay **≤0.5 s** so the arrival reads as one beat. |
| `graphic_read_hold` | 1.2 s | 0.8–2.5 s | Time the finished graphic holds fully assembled before the cut away. Set from text length at ~20 characters/second. |
| `conform_grade` | on | on/off | Match stock to A-roll: exposure, white balance, contrast, then grain. |

## Reproduction prompt

```
For the cutaway slot at {{IN}}-{{OUT}} covering the transcript line {{LINE}},
select and build ONE tier. Do not build two and choose later.

STEP 1 - ROUTE. Apply in order and record the answer in the design document:
  a) Is {{LINE}} about a concrete photographable thing we can shoot? -> SHOT.
  b) Concrete but unshootable by us? -> STOCK.
  c) Does {{LINE}} contain a mechanism ("because","which means","so then"),
     a quantity, a comparison, or an enumeration? -> GRAPHIC.
  d) None of the above -> NO CUTAWAY. Hold A-roll, or use a 3-word emphasis
     caption. Log the slot as intentionally empty.

STEP 2 - BUILD.
  STOCK: fetch at >=2x delivery resolution (3840x2160 for a 1080p timeline).
  Conform in this order: (1) resample fps to the timeline fps - never fake it
  with a playback-rate change unless slow motion is the intent; (2) match
  exposure and white balance to the nearest A-roll shot; (3) match contrast;
  (4) add grain last. Reframe by crop, keeping scale <= 200%.
  GRAPHIC: build as its own sub-composition sized to the delivery frame. One
  idea per graphic. Entrance: each element fromTo({y:24,autoAlpha:0}) ->
  {y:0,autoAlpha:1}, duration 0.40s, ease power3.out, stagger 0.06s in order
  of IMPORTANCE not DOM order, total stagger <= 0.5s. Then hold assembled for
  at least 1.2s before {{OUT}}. No exit animation - the cut is the exit.

STEP 3 - SOUND. Every tier gets audio. Stock and shot B-roll: keep or replace
ambience so the cutaway is not a hole. Graphic: one motion sound effect per
entrance group, transient on the first element's start.

ACCEPTANCE TEST: freeze the frame 6 frames after {{IN}} and the frame 6 frames
before {{OUT}}. At {{IN}}+6 the viewer must be able to name what they are
looking at. At {{OUT}}-6 the graphic must be fully assembled and static, or
the footage must still be on its subject. Then mute the video and read the
transcript line aloud over the slot: if the picture does not mean the line,
the tier was wrong, not the asset.
```

## Execution spec

**HyperFrames.** All three tiers are the same clip shape; only the element differs.

```html
<!-- stock or shot B-roll: a muted video clip, audio on its own track -->
<video id="broll-07" class="clip" src="assets/broll/city-aerial-4k.mp4"
       data-start="41.2" data-duration="2.0" data-media-start="3.40"
       data-track-index="0" muted playsinline></video>

<!-- motion graphic: a sub-composition host, one idea inside it -->
<div id="el-gfx-latency" class="clip"
     data-composition-id="gfx-latency"
     data-composition-src="compositions/gfx-latency.html"
     data-start="47.8" data-duration="3.6" data-track-index="1"></div>
```

Contract points that bind this:
- **Seconds only.** There is no frame-based attribute; a 12-frame entrance at 30 fps is `duration: 0.4`. `data-fps` is a hint the CLI can override.
- **Trim in the composition, not on disk** — `data-media-start` + `data-duration` play a sub-window. Cut a physical file only when the asset leaves the pipeline.
- **Reframe with `clip-path`**, which is render-time and leaves the source untouched. There is **no automatic content-aware reframe or face tracking** in this stack; a punch-in is authored geometry.
- **`data-playback-rate` is a constant, `0.1..5`, pitch-preserved. There is no rate envelope**, so a speed ramp on a stock clip must be preprocessed with ffmpeg.
- **`video_nested_in_timed_element` is a lint error** — time the wrapper *or* the video, never both. A stock clip that needs a wrapper for `clip-path` must not itself carry `data-start`.
- **`data-track-index` is display only.** Layering is CSS `z-index`. Base footage conventionally track 0, graphics 1+, audio 10+.
- The graphic sub-comp's timeline is **scene-local** and **cannot animate host-root elements**. If the graphic must interact with the underlying footage, put the footage inside the sub-comp or drive it from the main timeline at `global t = scene-local t + slot data-start`.
- Land every entrance **before** the clip's `data-duration` — the window is half-open `[start, start+duration)` and the frame at exactly `start+duration` is never rendered.
- Cite, do not quote: the animation rule library has `stat-bars-and-fills`, `counting-dynamic-scale`, `chart-scrub-readout`, `svg-path-draw`, `depth-scatter-assemble` for graphic interiors; their code is not staged here.

**ffmpeg — the stock conform pass, in order.**

```bash
# 1. fps conform (resample, not retime) + scale into the delivery frame
ffmpeg -i stock-4k-25fps.mp4 -vf "fps=30,scale=3840:2160:flags=lanczos" -c:v libx264 -crf 18 conform.mp4

# 2. exposure / balance match to the nearest A-roll frame
ffmpeg -i conform.mp4 -vf "eq=brightness=-0.04:contrast=1.06:saturation=0.94" graded.mp4

# 3. centred reframe to 9:16 if the deliverable is vertical
ffmpeg -i graded.mp4 -vf "crop=ih*9/16:ih,scale=1080:1920" vertical.mp4

# 4. measure both sides of the seam and compare before you accept the match
ffmpeg -ss <t_aroll> -i main.mp4 -frames:v 1 -vf "signalstats,metadata=print" -f null - 2>&1 | grep -E "YAVG|SATAVG"
```

**Licensing, recorded per asset.** Pexels-licensed clips need **no attribution** and permit commercial use, but explicitly prohibit selling unaltered copies, redistributing on other stock platforms, using the footage in a trademark, implying endorsement by people or brands shown, and showing identifiable people "in a bad light". Store the licence URL and the clip id in the design document per slot — this is the record you need if the upload is challenged. Also note the platform-side risk: YouTube's monetisation guidance for third-party footage turns on transformation, and its guidance for gameplay/software capture requires "step-by-step commentary … strictly tied to the live action being shown". The transformation that earns a stock-heavy video is your script and your cutting, not the download.

**Epidemic Sound.** A graphic cutaway needs one motion effect at its entrance: `SearchSoundEffects { query: { term: "ui whoosh short" }, filter: { duration: { max: 900 } } }`, placed per [[sfx-envelope-matched-to-easing-curve]]. A stock cutaway with no usable production audio needs ambience, not silence: `SearchSoundEffects { query: { term: "city ambience distant traffic" }, filter: { duration: { min: 10000 } } }`.

**Remotion.** The equivalent of the graphic tier is a `<Composition>` with `durationInFrames` and `fps`, driving element positions from `useCurrentFrame()` — a genuinely frame-native model, which is why frame counts port cleanly and second-based values do not. Remotion is **not a runtime in this project**; it appears only as a source format to port from. Manim is the other code-driven option and is best only for the narrow case of mathematical or diagrammatic figures.

## Pairs with
[[motion-graphics-broll-slot]] · [[cut-stock-footage-substitute]] · [[cut-b-roll-coverage-from-transcript]] · [[pace-visual-variety-density-audit]] · [[pace-a-roll-burst-rationing]] · [[motion-explainer-beat-animation]] · [[sub-emphasis-caption-three-words]] · [[sfx-envelope-matched-to-easing-curve]] · [[motion-image-focal-point-direction]]

## Failure modes
- **Keyword-matched stock.** A clip chosen because it shares a noun with the sentence, not because it means the sentence. Correction: run the mute-and-read acceptance test; if the picture does not carry the line, the slot wants a different tier or no cutaway.
- **A graphic where a shot would do.** An animated laptop opening is worse and 20× more expensive than a shot of a laptop opening. Correction: the mechanism test — if there is no "because" in the line, do not animate it.
- **Unconformed stock.** Different grade, different grain, different fps. This is the seam that makes an edit read as assembled. Correction: run the four-step conform pass and measure `YAVG` on both sides of the cut.
- **Punch-in past 200 % on 1080p-sourced stock.** Visible softening against pin-sharp A-roll. Correction: source at ≥2× delivery, or don't punch in.
- **Graphic that arrives already finished.** No entrance means no event, and the viewer's eye never gets recruited to it. Correction: 0.40 s `power3.out` entrance, staggered in order of importance.
- **Graphic that keeps moving while it should be read.** Ambient motion under text competes with reading. Correction: build → breathe → resolve, exactly one ambient motion in the breathe phase, and a ≥1.2 s static hold.
- **Exit animations on cutaways.** Banned except on the final scene — the cut *is* the exit, and an outgoing animation reads as a dip. Correction: delete it.
- **Known gap.** Nothing in this stack fetches, licenses or catalogues visual stock; `media-use resolve --type image` and the HeyGen catalogue are network paths and this project's sanctioned sourcing route (Epidemic Sound MCP) covers **audio only**. Visual asset acquisition and its licence bookkeeping are manual steps outside the pipeline — say so in the design document rather than specifying an API that does not exist here.
