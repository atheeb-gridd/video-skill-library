---
id: cut-stock-footage-substitute
title: Stock footage is the easy version of B-roll — source it so it does not read as stock
skill: editing
type: cut
family: b-roll
tags: [skill/editing, type/cut, family/b-roll, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:53"
    quote: "A few variations of B-roll are stock footage, which is basically the easy version, and motion graphics."
research_refs:
  - https://www.pexels.com/license/
  - https://pixabay.com/service/license-summary/
  - https://elements.envato.com/learn/best-stock-footage-sites-commercial-use
  - https://www.storyblocks.com/resources/blog/what-are-the-best-stock-video-sites
  - https://swarmify.com/blog/best-free-b-roll-websites/
difficulty: low
detectable_from: video
---

# Stock footage is the easy version of B-roll — source it so it does not read as stock

## What it is
Stock footage occupies the **same slot in the edit as shot B-roll**: a cutaway that shows what the voice is saying, so the viewer has something new to look at. The only difference is provenance — it was shot by someone else, for nobody in particular. That is what makes it cheap and what makes it dangerous: a clip chosen for its keyword rather than for the sentence it sits under reads as filler, and a clip whose frame rate, grade and grain differ from your own footage reads as a seam. The craft in stock is entirely in **selection, conform and treatment**, not in acquisition. Treat a stock clip as raw material you still have to match to your video, exactly as you would a second camera.

## When to use it
Use stock when the transcript names something you cannot film: a city you are not in, a machine you do not own, a scale you cannot shoot (space, crowds, aerials, macro), an archival era, or a moment already gone. Use it as the **fallback tier** in a coverage pass ([[cut-b-roll-coverage-from-transcript]]): shot B-roll first, stock second where shooting is impossible, motion graphics where the beat is a *mechanism* rather than a thing ([[motion-graphics-broll-slot]]). Do **not** use it to solve a boring line — a boring line needs a rewrite or a cut, not a drone shot of a sunrise. Do not use it where the point of the shot is *you* (credibility, demonstration, before/after), because the viewer can tell the difference and borrowed footage silently withdraws the claim. And keep an eye on total share: a video that is mostly other people's clips under a voiceover is the exact shape platforms flag as unoriginal, and the transformation that earns it is your script plus your cutting, not the download.

## How to recognise it in a reference video
- **Grade mismatch at the cut.** Sample one frame either side and compare average colour temperature and black level. Stock cut in raw is typically **warmer and flatter** than a graded A-roll. Measurable step: mean luma differing by more than ~8/255, or a visible hue shift in skin/sky, across a cut that is supposed to be invisible.
  ```bash
  ffmpeg -i ref.mp4 -ss 41.2 -frames:v 1 -y a.png
  ffmpeg -i ref.mp4 -ss 41.6 -frames:v 1 -y b.png
  ffmpeg -i a.png -vf "signalstats,metadata=print" -f null - 2>&1 | grep -E "YAVG|UAVG|VAVG"
  ```
- **Frame-rate judder.** A 24 or 25 fps stock clip dropped into a 30 fps timeline stutters on horizontal pans in a way native 30 fps footage does not. Look for a repeating 2-frame hold on continuous motion; confirm with `ffprobe -show_streams` on the source if you have it.
- **Sharpness and grain step.** Stock is usually delivered sharpened and denoised. Look for a change in visible grain, or an edge halo, appearing only on the cutaways.
- **The register.** Generic-professional signatures: smiling office people, slow-motion coffee pour, unattributed drone city, hand-on-keyboard close-up, gimbal walk toward camera. If the clip could sit in any video on any topic, it is decorative.
- **Motion-direction discontinuity.** Shot B-roll usually inherits the scene's direction of travel; stock does not. A cutaway whose subject moves opposite to the surrounding shots is a strong stock tell.
- **Length signature.** Stock cutaways in creator edits sit on screen **45–150 f (1.5–5.0 s)** — long enough to read, short enough that the loop or the camera move does not finish. A cutaway that plays out a whole 10-second gimbal move is almost never stock used well.
- **Aspect / crop artefacts.** Slight softness from an upscale, or a crop that clips heads, means a 16:9 asset was forced into a 9:16 frame ([[cut-full-screen-transition]] for the legitimate version).
- **Share of runtime.** Count stock seconds ÷ total. Explainer channels run **0.10–0.35**; above ~0.5 the video is a narrated slideshow of other people's work.
- **Duplication across channels.** If you recognise the clip from another video, so will part of the audience. Log it — a recognisable clip is only an asset when recognition is the point ([[struct-recognisable-clip-evidence]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `onscreen_len` | 75 f (2.5 s) | 45–150 f (1.5–5.0 s) | Long enough to read one idea. Cut before the camera move resolves. |
| `stock_share` | 0.20 | 0.10–0.35 of runtime | Above 0.5 the edit is a narrated stock reel; platform "unoriginal content" risk rises with it. |
| `source_resolution` | ≥ 2× delivery height | 1080p min, 2160p preferred | Download the largest available; headroom is what lets you reframe and stabilise without softening. |
| `conform_fps` | 30 | 24 \| 25 \| 30 \| 60 | Physically conform 24/25 fps stock to the project fps before placement — the render's default is 30 fps and there is no retime envelope in the composition. |
| `grade_match_tolerance` | ΔYAVG ≤ 4/255 | ≤ 8/255 | Match stock to your A-roll, never the reverse. |
| `speed` | 1.0 | 0.5–1.0 | `data-playback-rate` is a constant, normalised 0.1–5. Slowing 60 fps stock to 0.5 is free; slowing 30 fps stock is not. |
| `licence_class` | free-commercial | free-commercial \| subscription \| rights-managed | Pexels and Pixabay: no attribution, commercial use allowed; both forbid redistributing the asset standalone and neither guarantees model or property releases. Subscription libraries (Storyblocks, Envato Elements, Artgrid) carry broader indemnified licences. |
| `release_required` | true for recognisable faces/brands/logos | — | The gap that actually bites in monetised work: a free licence covers the *file*, not the person or trademark inside it. |
| `reuse_gap` | never reuse a clip within one video | — | Reusing one stock shot twice reads as a shortage. |
| `grain_match` | +0 to +2% noise | 0–4% | A touch of noise on a denoised stock clip closes the sharpness step against camera footage. |

## Reproduction prompt

```
Fill the B-roll slot at {{IN}}-{{OUT}} (seconds, 30fps project) with stock
footage, matched to the surrounding footage.

1. READ THE LINE. Take the transcript text covering {{IN}}-{{OUT}} and
   extract the single concrete noun or action the viewer should see. Search
   for THAT, not for the topic. If the line contains no concrete noun, do
   not source stock - either cut the line or hand the beat to a motion
   graphic instead.
2. SEARCH with two or three literal terms plus one framing term (e.g.
   "server rack close up", "harbour crane wide"). Reject any candidate you
   could imagine under a different script.
3. LICENCE GATE, before download: confirm the asset's licence permits
   commercial use with no attribution, and inspect the frame for a
   recognisable face, logo or trademark. If one is present and you have no
   release, reject the clip. Record source URL and licence name alongside
   the file.
4. CONFORM the file physically before placing it: force project fps 30,
   scale/crop to the project frame, and re-encode. Do NOT rely on the
   composition to retime it - there is no rate envelope.
5. PLACE it as a clip spanning exactly {{IN}}-{{OUT}}, choosing
   data-media-start so the visible window is the most legible 2.5 seconds
   of the shot - the middle of a camera move, never its start or its
   settle.
6. MATCH: grade the stock toward the surrounding A-roll (temperature,
   black level, saturation), not the reverse. Add 1-2% noise if the clip is
   noticeably cleaner than your footage.
7. SOUND: the clip is mute. If it shows an event that would make a noise,
   add one diegetic sound for it; if it shows a location, add its ambience.
   A silent cutaway inside a sounded edit reads as a dropout.
8. ACCEPTANCE TEST: (a) play {{IN}}-2s to {{OUT}}+2s - no visible step in
   colour, sharpness or motion cadence at either boundary; (b) mute the
   video: the shot still says the line's noun; (c) the shot is on screen
   45-150 frames; (d) the clip's camera move does not complete before the
   cut; (e) the licence and URL are recorded.
```

## Execution spec

**ffmpeg — conform first, always.** Frame-rate and frame-size mismatch is the single biggest source of stock looking like stock, and both are file operations, outside the composition:

```bash
# conform 25fps 4K stock to a 30fps 1080p project, centre-crop to 16:9
ffmpeg -i stock_raw.mp4 -vf "fps=30,scale=-2:1080,crop=1920:1080" \
  -c:v libx264 -preset veryfast -crf 18 -an assets/broll/crane_30p.mp4

# 16:9 -> 9:16 for a vertical project
ffmpeg -i stock_raw.mp4 -vf "fps=30,crop=ih*9/16:ih,scale=1080:1920" -an out.mp4

# grade nudge toward a cooler, contrastier A-roll
ffmpeg -i crane_30p.mp4 -vf "eq=contrast=1.06:saturation=0.94,colorbalance=rm=-0.03:bm=0.04" -an crane_graded.mp4

# +1.5% grain to match camera noise
ffmpeg -i crane_graded.mp4 -vf "noise=alls=4:allf=t+u" -an crane_final.mp4
```
Only cut a physical trim when the asset is leaving the pipeline; sub-windowing inside the composition is free via `data-media-start` + `data-duration`.

**HyperFrames — placement.** A stock cutaway is an ordinary muted `<video>` clip. All times in **seconds**; frames are a comment.

```html
<!-- cutaway from 41.20 to 43.70 (75f), showing 2.5s starting 4.0s into the source -->
<video id="broll-crane" src="assets/broll/crane_final.mp4" muted playsinline class="clip"
       data-start="41.20" data-duration="2.50" data-media-start="4.00"
       data-track-index="1"></video>
```
Contract details that matter here: `data-playback-rate` is a **constant** in `0.1..5`, pitch-preserved, and there is **no rate envelope** — any ramp must be preprocessed. Reframing inside the composition is `clip-path` on the element, not a `width`/`height` tween (those are forbidden). A punch-in on a still-ish stock shot is a GSAP `scale` tween on the clip wrapper, `power1.inOut`, and it must land its end state slightly **before** `data-duration` or the last frame never renders.

**Epidemic Sound.** Stock video arrives silent, and silence under a cutaway is audible. Fetch the two sounds the shot implies: `SearchSoundEffects { query.term: "<location> ambience room tone", filter.duration { min: 6000 } }` placed in an `ambience` group at the cutaway's `data-start`, and one diegetic event for any visible action ([[sfx-unsounded-motion-audit]]). Never put either in the `voiceover` carve group.

**Remotion:** conceptually an `<OffthreadVideo>` inside a `<Sequence>`; no Remotion runtime exists in this project.

## Pairs with
[[cut-b-roll-coverage-from-transcript]] · [[motion-graphics-broll-slot]] · [[pace-visual-variety-density-audit]] · [[cut-hard-cut-for-new-information]] · [[cut-continuity-pass]] · [[sfx-ambience-bridge-across-cut]] · [[cut-j-audio-leads-picture]] · [[struct-recognisable-clip-evidence]] · [[pace-a-roll-burst-rationing]]

## Failure modes
- **Keyword sourcing.** Searching the topic ("innovation") instead of the noun ("robot arm welding") produces the generic-professional register the audience reads as filler. Fix: source from the transcript's concrete nouns, one clip per noun.
- **Un-conformed frame rate.** 24/25 fps stock in a 30 fps render judders on pans. Fix: `fps=30` in a physical conform pass before placement; do not try to solve it with `data-playback-rate`.
- **Grading the A-roll to the stock.** Makes the whole video look borrowed. Fix: A-roll is the reference; stock moves.
- **Leaving it silent.** A mute cutaway inside a sounded edit reads as a dropped audio track. Fix: one ambience plus one diegetic event per cutaway.
- **Playing the whole camera move.** The move resolves, the shot dies on screen, and the viewer notices they are watching stock. Fix: cut inside the move, 45–150 f.
- **Licence-by-vibe.** "Free" covers the file, not the recognisable face, logo or building inside it, and neither Pexels nor Pixabay promises model or property releases. Fix: reject unreleasable frames; record source and licence with the file.
- **Reusing one clip twice.** Reads as a shortage and cheapens both placements. Fix: one placement per asset per video.
- **Known gap:** nothing in this stack verifies licences, detects duplicate stock, or measures grade match automatically — the `signalstats` comparison above is the closest available check and it needs a human to read it.
