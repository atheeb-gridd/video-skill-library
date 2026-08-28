---
id: motion-waveform-playhead-scrub
title: The waveform readout — pre-baked peaks, a playhead driven by timeline time, a marker on the transient
skill: motion
type: graphic
family: data-in-motion
tags: [skill/motion, type/graphic, family/data-in-motion, layer/music, layer/design, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt-3, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:03"
    quote: "You can see this in the waveform: wherever you see a peak, cut the music there."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://raw.githubusercontent.com/katspaugh/wavesurfer.js/main/src/wavesurfer.ts
  - https://wavesurfer.xyz/
  - https://gsap.com/docs/v3/Eases
  - https://tech.ebu.ch/docs/r/r095.pdf
difficulty: high
detectable_from: video
---

# The waveform readout — pre-baked peaks, a playhead driven by timeline time, a marker on the transient

## What it is
An animated audio waveform on screen, used as a teaching visual: bars or an envelope drawn from the actual audio, a playhead sweeping across them in real time, and a marker that pops on the peak at the exact frame the peak is audible. The point is that the viewer *hears the shape they are being shown* — the rule ("cut the music on a peak") is learned as a recognisable picture rather than an abstraction. [[motion-waveform-teaching-overlay]] frames it as a teaching device; this note is the motion and data spec.

The critical engineering constraint: in a seekable render, the waveform's animation cannot be driven by the audio element's playback position. Amplitude data must be **pre-baked into the composition** and every moving part must be a pure function of timeline time, or the render is non-deterministic and the playhead drifts out of sync with the sound.

## When to use it
- **Teaching an audio edit** — where to stop the music, where a beat sits, why a fade lands where it does ([[sfx-music-rest-windows]], [[pace-cut-on-the-beat]]).
- **Proving a claim about sound** — "this riser peaks here", "the dialogue sits at −3 dB while the bed sits at −22" — where a level or a shape is the evidence ([[sfx-riser-to-music-drop-backtiming]]).
- **Showing the timeline itself** as a screen-recording substitute, when a real NLE capture would be visually noisy ([[cut-screen-recording-proof-insert]]).
- **As a data-in-motion beat** in a sound-design explainer, to break up talking head with something that is literally the subject.
- **Not** for decoration: an audio-reactive waveform bouncing behind unrelated content is a screensaver, and in this engine it costs a pre-bake pass for nothing.

## How to recognise it in a reference video
- **Is the playhead locked to the audio?** Extract the audio and the frames together; find the transient in the audio and check where the playhead is on that frame. Locked (±1 frame) means it is a real readout; drifting means it is decoration.
- **Bars versus envelope.** Bar-style readouts (a rendered bar per bucket) are the modern convention: bar width **3–6 px** at 1080p with **1–3 px** gaps, giving **160–320 bars** across a full-width strip. A smooth filled envelope reads more like an NLE screenshot.
- **Strip geometry:** height **18–28% of frame height** for a hero readout, **8–12%** for a strip under other content; horizontal inset within the 5% graphics safe area (EBU R95).
- **Two colours.** A "played" colour behind the playhead and an "unplayed" colour ahead of it (wavesurfer's `waveColor` / `progressColor` defaults `#999`/`#555` are the archetype). One flat colour means no progress rendering — check whether the playhead exists at all.
- **Playhead width 1–3 px**, moving at **constant velocity** (linear). Any ease on the playhead is a fault — audio time is linear.
- **Marker behaviour.** A peak marker typically pops **0.15–0.25 s** with a scale-up from 0.6–0.8, and lands on the audible transient, not near it. A label ("peak") often follows 2–4 frames later.
- **Is the audio actually audible?** A waveform shown in silence is a diagram; a waveform shown while the corresponding audio plays is the technique. Check the audio track for the same material.
- **Normalisation tell:** if quiet passages still reach 80% of strip height, the peaks were normalised per-window; if the whole strip is tiny except one spike, they were not. Both are legitimate — log which.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `bucket_count` | 240 | 120–400 | One bar per bucket. Compute as `floor(strip_width / (bar_w + gap))`. |
| `bar_width` | 4 px @1080p | 3–6 px | Author in the composition's px space. |
| `bar_gap` | 2 px | 1–3 px | |
| `bar_radius` | 2 px | 0–3 px | Rounded caps read modern; 0 reads technical. |
| `strip_height` | 22% of frame h | 8–28% | Hero vs under-content strip. |
| `strip_inset` | 6% each side | 5–10% | Stay inside the EBU R95 5% graphics safe area. |
| `normalize` | true | true/false | Per-window peak normalisation. |
| `wave_colour` | mid grey | — | Unplayed. |
| `progress_colour` | accent | — | Played; same accent as annotations. |
| `playhead_width` | 2 px | 1–3 px | |
| `playhead_ease` | `none` | `none` only | Audio time is linear. Anything else is a bug. |
| `sweep_duration` | = clip duration | — | Playhead crosses the strip in exactly the audio window shown. |
| `window_shown` | 4 s | 2–10 s | Audio seconds represented by the strip. Under 2 s the shape is unreadable. |
| `marker_pop` | 0.75 → 1.0 | 0.6–0.85 start | `power3.out`, 0.18 s. `back.out(1.7)` allowed once. |
| `marker_frame_tolerance` | ±1 f | ±1 f | On the audible transient. |
| `label_delay` | 0.10 s (3 f) | 0.07–0.17 s | Label after marker. |
| `sfx_relationship` | the audio itself | — | The demonstrated audio plays; no extra SFX needed. |

## Reproduction prompt

```
Build a waveform readout of {{AUDIO_FILE}} from {{AUD_IN}} to {{AUD_OUT}},
with a playhead and a marker on its loudest peak.

STEP 1 - BAKE THE DATA. Do not read amplitude at render time. Decode the
window to mono PCM and reduce it to 240 bucket maxima in 0..1, then paste the
array into the composition as a const. Command:
  ffmpeg -ss {{AUD_IN}} -to {{AUD_OUT}} -i {{AUDIO_FILE}} -f f32le -ac 1 -ar 8000 - \
    | node -e "…read stdin, chunk into 240 buckets, print JSON of per-bucket max…"
Record the bucket index of the maximum; that index is the peak.

STEP 2 - DRAW. Emit 240 bars into a strip 22% of frame height, inset 6% each
side, bar width 4px, gap 2px, radius 2px, height = value * strip_height,
centred vertically. Unplayed bars in mid grey; a duplicate set of bars in the
accent colour clipped by a progress mask.

STEP 3 - ANIMATE. Sweep the progress mask's width (or a clip-path inset) from
0% to 100% over exactly ({{AUD_OUT}} - {{AUD_IN}}) seconds with ease none, and
move the 2px playhead on the same tween. Both must be positioned on the
composition timeline - never driven from the audio element's currentTime.

STEP 4 - MARK THE PEAK. At the timeline position corresponding to the peak
bucket, pop a marker from scale 0.75 to 1.0 with autoAlpha 0->1 over 0.18s
ease power3.out, and bring its label in 0.10s later. Quantise that position to
the frame grid (a whole multiple of 1/fps).

STEP 5 - PLAY THE AUDIO. Place the same file as an audio clip with an id, its
data-media-start = {{AUD_IN}} and duration = the window, so the viewer hears
exactly the shape on screen. Dialogue-level 0 to -3 dB if it is the subject of
the lesson.

ACCEPTANCE TEST: on the frame where the marker pops, the audible waveform
transient must be at its peak (verify by extracting the render's audio and
comparing sample position to frame number, tolerance 1 frame); the playhead
must reach the strip's right edge exactly as the window ends; and the bar
heights must match a showwavespic render of the same window.
```

## Execution spec

**HyperFrames.** Bake, then animate as pure timeline motion.

```html
<div id="wf" class="clip" data-start="30" data-duration="4.5" data-track-index="3"
     style="position:absolute; inset:0;">
  <div id="wf-strip" style="position:absolute; left:6%; right:6%; top:39%; height:22%;">
    <div id="wf-base"  style="position:absolute; inset:0;"></div>   <!-- grey bars -->
    <div id="wf-prog"  style="position:absolute; inset:0; width:0;
         overflow:hidden;"></div>                                   <!-- accent bars, masked -->
    <div id="wf-head"  style="position:absolute; top:-6%; bottom:-6%; width:2px; left:0;
         background:#fff;"></div>
    <div id="wf-mark"  style="position:absolute; opacity:0;">peak</div>
  </div>
</div>
<audio id="wf-audio" src="assets/music/bed-a.wav"
       data-start="30" data-duration="4" data-media-start="62.5"
       data-track-index="10" data-volume="0.9"></audio>
```

```js
// PRE-BAKED — 240 bucket maxima, 0..1, generated by ffmpeg + a reduce script
const PEAKS = [0.04,0.07,0.31, /* … 240 values … */ 0.12];
const PEAK_I = 137;                                  // index of max
// build bars once, at setup (never at tween time)
buildBars("#wf-base", PEAKS, "#8a8a8a");
buildBars("#wf-prog", PEAKS, "#FFD400");

const T = 30.0, WIN = 4.0;                           // window shown, seconds
tl.fromTo("#wf-prog", { width: "0%" }, { width: "100%", duration: WIN, ease: "none" }, T);
tl.fromTo("#wf-head", { xPercent: 0 },  { xPercent: 0, x: () => stripWidthPx, duration: WIN, ease: "none" }, T);
// peak marker, quantised to the frame grid: t = T + round((PEAK_I/240)*WIN*30)/30
tl.fromTo("#wf-mark", { scale: 0.75, autoAlpha: 0 },
  { scale: 1, autoAlpha: 1, duration: 0.18, ease: "power3.out" }, 32.2833);
```

Contract points that bind this:
- **The determinism rule that governs this note, verbatim:** an audio-reactive visual *"reads a pre-baked frequency curve and must remain a function of `tl.time()`, never `audio.currentTime`."* Reading the audio element at render time produces a drifting, non-reproducible render.
- Also banned: render-time clocks, unseeded `Math.random()`, network fetches, `repeat: -1`, timeline construction inside `async`/`setTimeout`/`Promise`. Bake the bars synchronously at setup (inside `document.fonts.ready` is supported).
- **Do not measure at tween time.** *"compute coordinates once at composition setup and reuse"* — and in a multi-scene montage do not measure at all: use authored constants matching the CSS, because later clips may not be laid out yet.
- `width` is **not** a legal tween target for spatial motion; use it only for a mask/progress element as above, and prefer `clip-path`/`scaleX` with `transformOrigin: "left center"` for the reveal if you want a pure transform. If you use `scaleX`, do not also set a CSS `transform` (`gsap_css_transform_conflict`).
- The `<audio>` element **must have an `id`** — an id-less audio track is never mixed and renders silent. Keep audio on track index 10+, and in a modular project at the **host root** so it survives scene cuts.
- `data-media-start` is the offset into the source in seconds — this is what makes the picture and the sound show the same window.
- The playhead's final state must land before the clip's `data-duration` (half-open window); give the strip 2–3 frames of headroom.
- Named rules citable here: `chart-scrub-readout`, `stat-bars-and-fills`, `counting-dynamic-scale`.

**ffmpeg — the bake and the cross-check.**

```bash
# A. reference image of the exact window (use to verify your bar heights)
ffmpeg -ss 62.5 -to 66.5 -i bed-a.wav -filter_complex \
  "showwavespic=s=1600x240:colors=0x8a8a8a:split_channels=0:scale=lin:draw=full" -frames:v 1 wf.png
# B. numeric bake: mono, low sample rate, raw floats -> bucket maxima
ffmpeg -ss 62.5 -to 66.5 -i bed-a.wav -f f32le -ac 1 -ar 8000 - > /tmp/win.f32
# C. animated reference (NOT for the render — only to sanity-check the sweep speed)
ffmpeg -ss 62.5 -to 66.5 -i bed-a.wav -filter_complex "showwaves=mode=cline:s=1600x240:rate=30" wf.mp4
# D. find the true peak time to place the marker
ffmpeg -ss 62.5 -to 66.5 -i bed-a.wav -af "astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.Peak_level" -f null -
```
`showwavespic` options are exactly `size`/`s`, `colors`, `split_channels`, `scale`, `draw`; `showwaves` adds `mode` and `rate`/`r`.

**wavesurfer.js as the geometry reference.** Its option set is the de-facto convention: `peaks` (`Array<Float32Array | number[]>`, pre-decoded — *"We recommend using pre-decoded peaks for large files"*), `barWidth`, `barGap`, `barRadius`, `barAlign`, `height`, `normalize`, `cursorWidth` (default 1), `waveColor` (default `#999`), `progressColor` (default `#555`). Do **not** embed wavesurfer in a composition — it would drive itself from audio playback; copy the geometry, not the runtime.

**Remotion:** `useCurrentFrame()` → progress fraction over a pre-baked peaks array, same bake step — concept only.

## Pairs with
[[motion-waveform-teaching-overlay]] · [[sfx-music-rest-windows]] · [[sfx-music-fade-out-section-signal]] · [[sfx-peak-on-the-cut]] · [[motion-impact-frame-quantisation]] · [[cut-screen-recording-proof-insert]] · [[motion-overlay-stack-choreography]] · [[pace-beat-grid-extraction]]

## Failure modes
- **Driving the visual from `audio.currentTime`.** Works in preview, drifts or freezes in the render, and is explicitly banned. Correction: pre-bake and drive from the timeline.
- **Waveform shown in silence.** The whole point is that the viewer hears the shape. Correction: place the same file with a matching `data-media-start`.
- **Eased playhead.** Audio time is linear; an eased playhead makes the picture lie about the sound. Correction: `ease: "none"`.
- **Marker near the peak, not on it.** Off by 3+ frames and the lesson inverts — the viewer learns the wrong shape. Correction: compute the peak's time from the bake and quantise to the frame grid.
- **Too few buckets.** 60 bars over 4 s smooths away the transient that the lesson is about. Correction: 160–320 bars across a full-width strip.
- **Measuring strip width at tween time.** Returns 0 in a later scene and the playhead never moves. Correction: authored constant, or measured once at setup.
- **Audio without an id.** Silent render, no error. Correction: every `<audio>` gets an `id`.
- **Known gap:** there is no waveform primitive in this stack — the bars are hand-emitted DOM and the peaks are an external bake. Budget the bake as a build step, and re-bake whenever the audio window changes.
