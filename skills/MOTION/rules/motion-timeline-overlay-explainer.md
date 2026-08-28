---
id: motion-timeline-overlay-explainer
title: The timeline overlay — run a stylised NLE timeline under the clip you are explaining
skill: motion
type: graphic
family: teaching-visual
tags: [skill/motion, type/graphic, family/teaching-visual, layer/design, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, every film-clip example"
    quote: "[NOT SPOKEN — observed on screen] A stylised NLE timeline overlaid across the bottom of frame: coloured clip bars (green picture, blue/purple/cyan audio), real waveforms drawn inside them, and a playhead tracking the clip as it plays."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, J Cut / L Cut segments"
    quote: "[NOT SPOKEN — observed on screen] A green picture bar and a blue audio bar visibly staggered, waveform showing — the offset presented as a track-level relationship, not as a transition effect."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html#showwavespic
  - https://legibility.info/rules-for-text-in-videos
  - https://en.wikipedia.org/wiki/Non-linear_editing
  - https://en.wikipedia.org/wiki/Dual-coding_theory
  - _meta/visual-kt-delta.md
difficulty: high
detectable_from: video
---

# The timeline overlay — run a stylised NLE timeline under the clip you are explaining

## What it is
The strongest reusable teaching pattern in the whole reference set. Every film-clip example in `editing kt 2` carries a **stylised editing timeline overlaid across the bottom of the frame**: coloured clip bars — green for picture, blue/purple/cyan for audio — with real waveforms drawn inside them and a **playhead that tracks the clip as it plays**. The viewer watches the edit and its timeline *at the same time*.

Why it works is not decoration. A cut is an event in time that leaves no trace on screen: by the time the viewer notices it, it is over. The overlay gives the event a **spatial existence** — the seam between two bars is visible before, during and after it is heard, and the playhead crossing it converts an instant into a place. It is the same argument as putting a waveform on screen to teach an audio edit ([[motion-waveform-teaching-overlay]]), extended from one track to the whole edit, and it is what makes structural claims — *this audio starts before this picture* — verifiable rather than asserted.

Three things make the difference between a real explainer and a decorative timeline graphic:

1. **Synchronisation.** The playhead's position must be a true linear function of the clip's own time. Any easing on a playhead is a lie about time, and the moment it drifts from the picture the graphic stops being evidence.
2. **Reduction.** A real NLE timeline has rulers, track heads, keyframe lanes, labels and a dozen colours. The teaching version keeps **two or three tracks and nothing else**. Everything the claim does not need is removed.
3. **Simultaneity.** The clip and its timeline share the frame. Cutting away to a timeline screenshot loses the whole benefit, because the viewer can no longer bind the seam to what they are hearing.

The letterboxed clip sits **above** the band, inset on a dark ground, with its attribution label top-left ([[motion-attribution-label-inset-clip]]) — the overlay and the inset are one composed layout, not two ideas.

## When to use it
- **Whenever the claim is about a relationship between tracks or between clips** — J and L cuts ([[motion-two-track-offset-diagram]]), split edits, audio leading picture, a match cut's alignment, cut density in a sequence.
- **When teaching from a clip the audience did not make.** The overlay is what turns a borrowed film clip into a demonstration instead of an illustration ([[struct-recognisable-clip-evidence]]).
- **In an edit-craft explainer**, as the format's signature device: used on every example, it becomes the video's visual grammar and costs nothing after the first build.
- **When a rule has a measurable size** — "the audio leads by about a second" is a length the viewer can see on the bar.
- **Not for a claim about a single frame.** A snap zoom or an impact frame is better served by a freeze and an annotation ([[motion-annotation-draw-on]]).
- **Not over a clip the viewer needs to read closely.** The band takes real estate; if the point is in the bottom third of the picture, move the band or lose it.
- **Not as a scrolling decoration** under unrelated footage — an animated timeline that does not correspond to what is playing is the audio-visualiser cliché with extra steps.

## How to recognise it in a reference video
- **A persistent band in the lower ~20% of frame**, present for the whole of an example rather than flashed.
- **Two or three tracks, not eight.** Count them. A faithful screen-recorded timeline is a different (weaker) technique.
- **Colour-coded by role** — one hue for picture, a second for audio, consistent across every example in the video.
- **Waveforms are real.** Look for correspondence between a loud moment and a tall waveform. Synthetic squiggles that do not move with the audio are decorative.
- **The playhead moves at constant speed** and reaches a bar boundary on the exact frame the cut happens. Step through it: a 1-frame lead or lag is acceptable, more is a build error.
- **The bars extend past frame edges** rather than fitting neatly — that reads as a window onto a longer timeline rather than as a diagram of a whole video.
- **On a J or L cut the offset is visible as a stagger** between the green and blue bars, and its length matches what you hear.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `band_height` | 20% of frame height (216 px @1080p) | 15–25% | Below 15% the waveforms are unreadable; above 25% it competes with the clip. |
| `band_position` | bottom, flush | — | Bottom edge; the clip is inset above it. |
| `track_count` | 2 | 2–3 | Picture + audio; a third only when the claim needs it (music vs dialogue). |
| `track_height` | 64 px @1080p | 48–88 px | Equal heights; the picture track may be 1.2× the audio track. |
| `clip_bar_radius` | 6 px | 4–10 px | Rounded ends read as "clip"; square ends read as "chart". |
| `picture_hue` | green | — | One hue for picture across the whole video. |
| `audio_hue` | blue/cyan/purple | — | A second hue for audio; use a third only for a third track. |
| `waveform_render` | `showwavespic`, `scale=sqrt` | linear\|sqrt\|log | `sqrt` is the readable default; `linear` buries quiet detail. |
| `waveform_size` | 1600×120 per track | 1200–1920 × 90–160 | Rendered per clip, cropped into its bar. |
| `playhead_ease` | `none` | — | **Always linear.** A playhead is a clock. |
| `playhead_width` | 3 px | 2–4 px | Plus an optional 1 px bright core. |
| `sync_tolerance` | ±1 frame | ≤2 f | Playhead at a bar seam on the frame the cut is heard/seen. |
| `visible_window` | 12 s of timeline | 6–30 s | How much timeline the band represents. Longer and a 1 s offset is invisible. |
| `px_per_second` | 160 px/s @1080p | 64–320 | Derived: `frame_width / visible_window`. The number that makes offsets measurable. |
| `label_px` | 40 px @1080p | 36–56 px | Track labels (`V1`, `A1`) if present at all; keep to ≤3 characters. |
| `entry_anim` | 0.4 s, `power3.out` | 0.3–0.5 s | Band slides up from the bottom edge once, at the start of the example. |

## Reproduction prompt

```
Build a timeline-overlay explainer for clip {{CLIP}} demonstrating {{CLAIM}},
on screen from {{IN}} to {{OUT}} (seconds, 30 fps).

1. DECIDE THE WINDOW. visible_window = the clip's length + 2 s of handles.
   px_per_second = 1920 / visible_window. Write both numbers down - every
   position below is computed from them, never eyeballed.
2. RENDER THE WAVEFORMS with ffmpeg showwavespic, one image per audio clip,
   1600x120, scale=sqrt, single colour. Render only the region the bar shows.
3. LAY OUT the band: bottom 20% of frame, dark translucent ground, two rows.
   Row 1 (picture, green bars), row 2 (audio, blue bars with the waveform
   image inside). Bar x = (clip_start - window_start) * px_per_second;
   bar width = clip_duration * px_per_second. Bars may run off both edges.
4. INSET THE CLIP above the band: letterboxed, on the same dark ground, with
   its attribution label top-left.
5. ANIMATE, in this order:
   a. band slides up 0.4 s power3.out at {{IN}};
   b. playhead travels left to right, ease "none", duration exactly
      visible_window, starting at {{IN}};
   c. nothing else moves. No pulsing bars, no easing, no parallax.
6. PLAY THE CLIP'S REAL AUDIO underneath at the same offset the bars claim.
7. VERIFY FRAME BY FRAME: extract the frames around the cut
   (ffmpeg -ss <t> -i out.mp4 -frames:v 6 f-%02d.png) and confirm the
   playhead is at the bar seam on the same frame the picture changes.

ACCEPTANCE TEST: pause anywhere in the example. The playhead's position on
the band tells you exactly where you are in the clip, and the bar under it
tells you which clip is playing. If a viewer could not point at the cut a
second before it happens, the band is too long a window.
```

## Execution spec

**ffmpeg — the waveform images, and the frame-accurate check.**
```bash
# one waveform per audio clip, windowed to exactly what the bar shows
ffmpeg -ss 12.0 -t 8.0 -i clip.wav \
  -filter_complex "showwavespic=s=1600x120:colors=0x6ec1ff:scale=sqrt:draw=full" \
  -frames:v 1 -y assets/img/tl_a1.png
# verify sync: every frame in a 0.3 s window around the cut
ffmpeg -ss 41.8 -t 0.3 -i out.mp4 -vsync 0 /tmp/f-%03d.png
```
Prefer a **still image plus an authored playhead** over `showwaves` video: the video variant hands you a media clip whose motion the timeline no longer owns and which cannot be seeked independently.

**HyperFrames — the band.** Everything is divs inside one clip wrapper; the picture is a muted `<video>` with a separate `<audio>` element, per the project's key rule.

```html
<div class="clip" id="tl-example" data-start="60.00" data-duration="14.00" data-track-index="2">
  <video id="tl-clip" src="assets/clips/departed.mp4" muted></video>
  <div class="tl-band">
    <div class="tl-row tl-v"><div class="tl-bar tl-pic" id="bar-v1"></div><div class="tl-bar tl-pic" id="bar-v2"></div></div>
    <div class="tl-row tl-a"><img class="tl-wave" src="assets/img/tl_a1.png" alt=""></div>
    <div id="tl-playhead"></div>
  </div>
</div>
<audio id="tl-clip-audio" src="assets/clips/departed.wav" data-audio-group="sfx"
       data-start="60.00" data-duration="14.00" data-track-index="12" data-volume="0.9"></audio>
```
```js
const IN = 60.0, WINDOW = 14.0, W = 1920;
tl.fromTo(".tl-band", { autoAlpha: 0, y: 40 },
  { autoAlpha: 1, y: 0, duration: 0.4, ease: "power3.out" }, IN);
tl.fromTo("#tl-playhead", { x: 0 },
  { x: W, duration: WINDOW, ease: "none" }, IN);   // linear, always
```
Contract facts this depends on: **`fromTo`, never `from`** — `from()` renders its start state at construction, before the clip's `data-start`, and flashes under non-linear seek. **Transform aliases only** (`x`, `y`, `scale`, `rotation`); `width`/`left` tweens are forbidden and a CSS `transform` on a GSAP-tweened element raises `gsap_css_transform_conflict`. Use `autoAlpha`, never `visibility`/`display`, and never on the clip element itself — the framework owns clip visibility. Bar positions must come from **authored constants**, not `getBoundingClientRect()` at tween time, because later clips may not be laid out yet. Land the last tween **before** `data-duration` (the visibility window is half-open). Every `<audio>` needs an `id` or the render is silent, and `crossorigin` on media is a lint error with no suppression. GSAP must be a **local vendored file** — the CDN is blocked by this project's egress allowlist. A `<video>` inside a *timed* element raises `video_nested_in_timed_element`; keep the picture in the clip wrapper as above.

**Making it modular.** Build the band once as a sub-composition and pass the per-example numbers in; the four relative-timing failures apply, so keep `data-start` values explicit rather than inferred.

**Remotion.** `useCurrentFrame()` drives the playhead by interpolation; the waveform is still an ffmpeg artefact re-entering as a `src`.

## Pairs with
[[motion-waveform-teaching-overlay]] · [[motion-two-track-offset-diagram]] · [[motion-attribution-label-inset-clip]] · [[motion-waveform-playhead-scrub]] · [[motion-annotation-draw-on]] · [[struct-recognisable-clip-evidence]] · [[struct-name-define-demonstrate]] · [[cut-j-audio-leads-picture]] · [[cut-l-audio-trails-picture]] · [[sfx-split-edit-lead-lag]]

## Failure modes
- **An eased playhead.** Misrepresents time and quietly teaches the wrong relationship. `ease: "none"`, duration exactly the window length.
- **A window so long the offset vanishes.** At 30 s across the frame, a 1-second J-cut lead is 64 px and reads as a rendering artefact. Shorten the window until the offset being taught is at least ~10% of frame width.
- **Fake waveforms.** Decorative squiggles destroy the credibility of every other claim in the video. Render from the real audio.
- **A faithful NLE screenshot.** Track heads, rulers and eight tracks bury the two bars that matter. Reduce.
- **Cutting away to the timeline.** Simultaneity is the whole mechanism; a cutaway makes it two separate assertions.
- **Playhead drift across a long example.** Usually a mismatch between `visible_window` and the tween duration. Verify with extracted frames, not by watching.
- **Bars that fit the frame exactly.** Reads as a chart of the whole film rather than a window onto a timeline. Let them run off both edges.
- **Colour drift between examples.** Green picture in one example and blue picture in the next destroys the grammar the viewer has just learned.
- **Known gap:** nothing in this stack draws a waveform inside a composition, so each bar's waveform is a pre-rendered image — changing the window means re-running ffmpeg *and* recomputing every bar position. Record `window_start`, `visible_window` and `px_per_second` next to the assets or the layout is not reproducible.
