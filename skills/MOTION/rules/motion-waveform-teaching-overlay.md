---
id: motion-waveform-teaching-overlay
title: Show the waveform — teach an audio edit by putting the shape on screen
skill: motion
type: motion
family: teaching-visual
tags: [skill/motion, type/motion, family/teaching-visual, layer/music, layer/design, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:03"
    quote: "You can see this from the waveform — where you see a peak, turn the music off there."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:00"
    quote: "whenever you have to turn the music off, turn it off at some peak point of the audio."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html#showwavespic
  - https://www.zixi.org/archives/generating-a-waveform-with-ffmpeg.html
  - https://legibility.info/rules-for-text-in-videos
  - https://librosa.org/doc/main/generated/librosa.onset.onset_detect.html
difficulty: medium
detectable_from: video
---

# Show the waveform — teach an audio edit by putting the shape on screen

## What it is
An audio rule is invisible. "Stop the music on a peak" is an abstraction until the viewer sees a waveform, sees the peak, sees the marker land on it and hears the transient at the same instant. Putting the timeline waveform on screen converts the rule into **pattern recognition**: the viewer learns the shape they should be cutting at, not a sentence they have to remember. The craft is in three things — **windowing** (a whole track at 1600 px makes every peak one pixel wide, so crop to a few seconds), **annotation** (a marker that arrives *before* the moment it names, so the eye is already there), and **synchronisation** (the audio you play must be the audio you are showing, at the same offset, or the demonstration teaches the wrong thing).

## When to use it
Whenever the video's claim is about a **position in time in an audio file**: stopping a bed on a transient, aligning an SFX peak to a cut, showing where a riser's build ends, marking the gap that dialogue leaves for a duck, or contrasting a compressed track with an uncompressed one. It is a teaching visual, so it belongs in explainer and tutorial formats, over B-roll of the timeline or as a full-frame graphic ([[motion-graphics-broll-slot]]). Do **not** use it as decoration — an animated waveform running under an unrelated voiceover is the audio-visualiser cliché and carries no information. And do not use it where the point is *how something sounds* rather than *where it happens*; for that, just play it.

## How to recognise it in a reference video
- **A waveform occupies a stable region of frame** — usually a lower band or a full-width strip — for **60–300 f (2–10 s)**, long enough to be read rather than glimpsed.
- **The window is short.** Count visible transients. A teaching waveform shows **3–12 peaks** across its width; a full-track waveform showing hundreds of undifferentiated spikes is decoration, not instruction.
- **There is exactly one marker.** A vertical line, an arrow, a circle or a dot on one peak, plus at most one short label. Two markers means two lessons in one shot.
- **Marker timing relative to the audible event.** In good teaching visuals the marker **arrives 6–15 f (0.2–0.5 s) before** the transient it names, so the eye is on the target when the ear hears it. A marker that appears simultaneously with the sound is missed; one that appears after is a caption, not a pointer.
- **The audio being demonstrated is actually audible and isolated.** Listen: the bed or SFX being shown should be foregrounded (voice ducked or paused) for the 15–45 frames around the demonstrated moment. If the presenter talks over it, the visual is illustrating a claim the viewer cannot verify.
- **A playhead, if present, is linear.** A playhead crossing the waveform should move at constant speed — any easing on a playhead is a lie about time. Check for acceleration near the marker.
- **Label legibility.** Any text obeys the reading budget: at least **characters ÷ 13** seconds on screen, ≤30 characters per line, body around **40–60 px** at 1080p.
- **The peak is visibly a peak.** Measure the marked transient's width on screen. If it is under about 6 px, the window is too long for the claim being made and the reference is showing a waveform rather than teaching from one.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `window_len` | 6.0 s | 2–12 s | Audio duration rendered into the image. Longer than ~12 s and individual transients stop being resolvable. |
| `visible_peaks` | 6 | 3–12 | Transients across the image width. The legibility criterion. |
| `min_peak_px` | 8 px | ≥6 px | Rendered width of the marked transient at delivery resolution. Shorten the window until this is met. |
| `image_size` | 1600×240 | 1200–1920 × 180–320 | `showwavespic` default is 600×240 — far too small for a 1080p frame. |
| `scale_mode` | `sqrt` | linear \| sqrt \| log \| cbrt | `linear` buries quiet detail; `sqrt` is the readable default for a teaching image; `log` for very dynamic material. |
| `onscreen_len` | 150 f (5.0 s) | 60–300 f | Total time the waveform is up. |
| `marker_lead` | 9 f (0.30 s) | 6–15 f | How early the marker arrives before the transient it names. |
| `marker_anim` | 0.3 s, `power3.out` | 0.25–0.4 s | House settle. Do not overshoot on a pointer. |
| `playhead_ease` | `none` | — | Linear, always. A playhead is a clock. |
| `label_dwell` | chars ÷ 13 s | ≥ 2.3 s per 30-char line | Published minimum reading dwell. |
| `label_px` | 48 px @1080p | 40–60 px | Titles ≥1.5× body; tracking −0.03 to −0.05 em. |
| `audio_foreground` | −3 dB, voice paused | — | The demonstrated audio must be clearly audible for 15–45 f around the marked frame. |

## Reproduction prompt

```
Build a waveform teaching visual demonstrating the moment {{EVENT}}
(seconds into {{AUDIO_FILE}}), on screen from {{IN}} to {{OUT}} in the
composition (seconds, 30fps).

1. CHOOSE THE WINDOW. Set WINDOW_START = {{EVENT}} - 3.0 and WINDOW_LEN =
   6.0 seconds, so the demonstrated moment sits in the middle. Then check
   legibility: render the image and confirm the transient at {{EVENT}} is
   at least 8 pixels wide at delivery resolution and that 3-12 transients
   are visible in total. If not, halve WINDOW_LEN and re-render.
2. RENDER THE WAVEFORM to a PNG at 1600x240 with sqrt amplitude scaling
   and a single colour that contrasts with the composition background.
   Render only the windowed region, never the whole file.
3. COMPUTE THE MARKER X POSITION:
   x = ({{EVENT}} - WINDOW_START) / WINDOW_LEN * image_width
   Write this number down; do not eyeball the marker into place.
4. LAY OUT: the waveform image as a clip spanning {{IN}}-{{OUT}}; a
   1-3px vertical marker line at x; optionally a short label above it
   (<= 30 characters).
5. ANIMATE, in this order:
   a. waveform image fades/slides in at {{IN}}, 0.4s, power3.out;
   b. a playhead line travels left to right across the image with ease
      "none", starting at {{IN}} and taking exactly WINDOW_LEN seconds,
      so screen position is a true function of audio time;
   c. the marker appears at composition time
      {{IN}} + ({{EVENT}} - WINDOW_START) - 0.30, i.e. 9 frames BEFORE
      the transient is heard, scaling from 0.85 to 1.0 over 0.3s with
      power3.out;
   d. the label, if present, arrives with the marker and stays on screen
      at least (characters / 13) seconds.
6. PLAY THE ACTUAL AUDIO underneath, from the same file, offset so that
   WINDOW_START of the file is heard at {{IN}}. Foreground it: pause or
   duck the narration for the 15 frames either side of the marked moment.
   The viewer must HEAR the peak they are being SHOWN, on the same frame.
7. ACCEPTANCE TEST: (a) at the frame the transient is audible, the
   playhead is exactly on the marker; (b) the marker was already on
   screen for ~9 frames before that; (c) freeze the frame - the marked
   peak is unambiguously the tallest thing near the marker; (d) the label
   is readable in the time it is up; (e) nothing about the playhead speeds
   up or slows down.
```

## Execution spec

**ffmpeg — render the waveform image.** `showwavespic` produces a single still from an audio stream; window it with `-ss` / `-t` **before** the filter so only the region of interest is drawn. Its default size is 600×240, which is far too small for a 1080p frame.

```bash
# 6-second window starting at 12.0s, 1600x240, sqrt scaling, single colour
ffmpeg -ss 12.0 -t 6.0 -i bed.mp3 \
  -filter_complex "showwavespic=s=1600x240:colors=0x8ab4f8:scale=sqrt:draw=full" \
  -frames:v 1 -y assets/img/wave_window.png

# split channels, transparent background variant (PNG keeps alpha)
ffmpeg -ss 12.0 -t 6.0 -i bed.mp3 \
  -filter_complex "showwavespic=s=1600x320:split_channels=1:colors=0x8ab4f8|0x5c8ad0:scale=sqrt" \
  -frames:v 1 -y assets/img/wave_split.png
```
Useful neighbours: `showwaves` (`mode=point|line|p2p`, `rate`, `n`) renders a *moving* waveform video rather than a still — but that gives you a media clip whose motion you no longer control, and it cannot be seeked independently of its own timing. **Prefer the still image plus an authored playhead**, which is deterministic and fully under the timeline's control.

Find the exact event time to mark, if it is not already known:
```bash
ffmpeg -i bed.mp3 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
```
or `librosa.onset.onset_detect(y=y, sr=sr, units="time")` where librosa is available ([[sfx-peak-on-the-cut]]).

**HyperFrames — the composition.** An `<img>` clip, a marker div, a playhead div, and the real audio at the same offset. Times in **seconds**; frames are comments.

```html
<div class="clip" id="wave-scene" data-start="40.00" data-duration="7.00" data-track-index="2">
  <img id="wave-img" src="assets/img/wave_window.png" alt="">
  <div id="wave-playhead"></div>
  <div id="wave-marker"></div>
  <div id="wave-label">stop here</div>
</div>

<!-- the audio being demonstrated: file time 12.0 is heard at composition time 40.0 -->
<audio id="wave-audio" src="bed.mp3" data-audio-group="music"
       data-start="40.00" data-duration="6.00" data-media-start="12.00"
       data-track-index="11" data-volume="0.8"></audio>
```
```js
// window: file 12.0 -> 18.0 (6.0s). Event at file 15.0 => 3.0s into the window.
// image is 1600px wide as laid out; marker x = 3.0/6.0 * 1600 = 800px.
const W = 1600, WIN = 6.0, EV = 3.0, IN = 40.0;

tl.fromTo("#wave-img", { autoAlpha: 0, y: 16 },
  { autoAlpha: 1, y: 0, duration: 0.4, ease: "power3.out" }, IN);

// playhead: strictly linear - a playhead is a clock, never eased
tl.fromTo("#wave-playhead", { x: 0 },
  { x: W, duration: WIN, ease: "none" }, IN);

// marker lands 9 frames (0.30s) BEFORE the transient is heard
tl.fromTo("#wave-marker", { scaleY: 0.85, autoAlpha: 0 },
  { scaleY: 1, autoAlpha: 1, duration: 0.3, ease: "power3.out" }, IN + EV - 0.30);
tl.fromTo("#wave-label", { autoAlpha: 0, y: 8 },
  { autoAlpha: 1, y: 0, duration: 0.3, ease: "power3.out" }, IN + EV - 0.30);
```
Contract facts this depends on:
- **`fromTo`, never `from`** — `from()` sets `immediateRender: true` and writes its start state at construction, before the clip's `data-start`; under the render's non-linear seek those elements flash or skip.
- **Transform aliases only** (`x`, `y`, `scale`, `scaleY`, `rotation`) — `width`/`height`/`top`/`left` tweens are forbidden, and a CSS `transform` on the same element that GSAP tweens is the error `gsap_css_transform_conflict`.
- **`autoAlpha`, not `visibility`/`display`, and never on the clip element itself** — the framework owns clip visibility. Put the marker and playhead inside the clip wrapper, as above.
- The marker's x must be computed from **authored constants**, not from `getBoundingClientRect()` at tween time — in a multi-scene composition later clips may not be laid out yet. Compute once at setup and reuse.
- Land the last tween **before** `data-duration`; the visibility window is half-open.
- The audio and the visual are coupled only by **the author writing the same number twice** — there is no audio-follows-animation attribute and no `audio.currentTime` access (it is banned; everything must be a function of `tl.time()`). If the waveform lives in a sub-composition, the root-level audio needs `data-start = scene-local t + the slot's data-start`.
- **Every `<audio>` needs an `id`** or it is never mixed (silent render), and `crossorigin` on media is a lint **error** with no suppression.
- GSAP must be loaded from a **local vendored file** — `cdn.jsdelivr.net` is blocked by this project's egress allowlist.

**Ducking the narration under the demonstration.** Put the voice clips in the `voiceover` group and either leave a genuine gap in the VO across the demonstrated moment (best), or add a `volume` lane on the VO clip. Do not carve the demonstrated audio against the voice here — the point is that the viewer hears it clean.

**Remotion:** an `<Img>` plus an interpolated playhead from `useCurrentFrame()`; not present in this project.

## Pairs with
[[sfx-peak-on-the-cut]] · [[sfx-music-rest-windows]] · [[sfx-music-hard-stop]] · [[motion-graphics-broll-slot]] · [[motion-image-focal-point-direction]] · [[struct-name-define-demonstrate]] · [[pace-silent-demonstration-window]] · [[struct-demo-before-label]] · [[sfx-av-sync-binding-window]] · [[motion-timeline-overlay-explainer]] · [[motion-two-track-offset-diagram]]

## Failure modes
- **Showing the whole track.** Every peak is one pixel wide and the viewer learns nothing. Fix: window to 2–12 s and check the marked transient is ≥8 px.
- **Marker and sound arriving on the same frame.** The eye is still travelling and misses the pointer. Fix: marker 6–15 frames early.
- **An eased playhead.** Any easing on a playhead misrepresents time and quietly teaches the wrong relationship. Fix: `ease: "none"`, duration exactly the window length.
- **Talking over the demonstration.** The viewer cannot verify the claim, so the visual is decorative. Fix: leave a VO gap of 15–45 frames around the marked moment.
- **Playing different audio from the one shown.** A generic music bed under a waveform rendered from another file. Fix: same file, same offset, computed once.
- **Two markers, two lessons.** Splits attention and neither lands. Fix: one marker per shot; make a second shot.
- **`linear` amplitude scaling on quiet material.** The waveform reads as a flat line and the peak is invisible. Fix: `scale=sqrt` (or `log` for very dynamic material).
- **Using `showwaves` video instead of a still plus a playhead.** You inherit a media clip whose motion the timeline does not own, and it cannot be re-timed or seeked independently. Fix: still image, authored playhead.
- **Known gap:** nothing in this stack renders a waveform inside a composition — the image is an ffmpeg artefact that re-enters as a `src`, so a change of window means re-running ffmpeg and re-computing the marker x by hand. Record `WINDOW_START`, `WINDOW_LEN` and the image width alongside the asset so the marker maths is reproducible.
