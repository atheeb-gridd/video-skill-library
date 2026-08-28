---
id: motion-snap-zoom-punch
title: The snap zoom — a 3–6 frame scale jump, and the whip that lands on it
skill: motion
type: camera
family: snap
tags: [skill/motion, type/camera, family/snap, sfx/motion, sfx/aesthetic, layer/sfx, engine/hyperframes, engine/epidemic, engine/ffmpeg, engine/remotion, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:06:41"
    quote: "On fast cuts or fast moments this works really well."
research_refs:
  - https://en.wikipedia.org/wiki/Shutter_angle
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://www.nngroup.com/articles/animation-duration/
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: video
---

# The snap zoom — a 3–6 frame scale jump, and the whip that lands on it

## What it is
The "fast moment" the whip crack belongs on. A snap zoom is a **very fast change of framing within one shot**: the frame scales up (or down) by a large step across 3–6 frames and stops dead, with no settle and no overshoot. It is not a punch-in cut (that is [[cut-punch-in-emphasis]], a cut between two framings) and not a push (a slow drift). It is a single violent reframing that the eye reads as the camera *snapping* to something.

Three members of the family:

| Move | Scale | Frames @30 | Ease | Sound |
|---|---|---|---|---|
| **Snap zoom in** | 1.00 → 1.25 | 4 | `expo.out` | whip crack |
| **Snap zoom out** | 1.25 → 1.00 | 5 | `expo.out` | whip crack, ~2 st lower |
| **Snap-cut burst** | series of 4–8 shots at 4–10 f each | — | n/a (cuts) | one whip per cut, or one riser across the burst |

And the decision this note settles — **whip or whoosh?** — comes down to whether the picture stays resolvable during the move:

| | Whoosh | Whip crack |
|---|---|---|
| Motion character | a **glide**: continuous, trackable path | a **discontinuity**: the eye cannot follow |
| Peak displacement per frame | < ~25 % of frame width | ≥ ~40 % of frame width, or a scale step ≥15 % inside 4 frames |
| Envelope | swell → peak → tail | near-instant attack (<20 ms), short decay |
| Typical hosts | title sweep, push-slide, object pass, mask wipe | snap zoom, whip pan, snap-cut burst, punchline |
| Layering | — | the source explicitly layers whip **over** whoosh for a bigger, unique hit |

Between the two bands (25–40 % per frame) either works; layer both and let the whoosh carry the travel while the whip marks the arrival.

## When to use it
- To **punctuate a punchline, a reversal or a verdict** — the visual equivalent of an exclamation mark, and the source's own second use for the whip ("a punchline or a sudden reaction").
- To **enter a montage burst**: one snap zoom into the first shot sets the register for the rapid cutting that follows.
- To **arrive on a detail** in a screen recording or a still, where a slow push would waste the beat ([[motion-screen-recording-cursor-punch-in]]).
- Sparingly. **Two per 30 seconds** outside a designed burst; beyond that the device stops meaning anything and the video reads as an ad.
- Not in a calm register, not on A-roll where the presenter is being sincere, and never on a shot the viewer is being asked to read.

## How to recognise it in a reference video
- **Measure the scale ratio frame to frame.** Track two fixed features and take the ratio of their separation. A snap shows **≥4 % scale change in a single frame** and a total step of 15–45 % completed in 3–6 frames.
- **Check for a settle.** A snap has none: the last two frames of the move should be within 0.5 % of each other. Overshoot-and-return means a spring, which is a different (softer) device — log it separately.
- **Check the anchor.** Compute the fixed point of the scale transform. If it is frame centre, the snap is naive; if it sits on the subject's eyes or on the control being operated, the reference is anchoring `transformOrigin` deliberately — a strong style fingerprint.
- **Check for resolution collapse.** On a snap beyond ~1.4 the source must be higher-resolution than the timeline; if the incoming frames go soft, the reference is upscaling and it will be visible on a large screen.
- **Audio:** a transient with an attack under **20 ms** and a total length under 400 ms, sitting on frame 1–2 of the move. A slow swell under a snap is a whoosh doing a whip's job.
- **Burst detection:** in a snap-cut sequence measure shot lengths — **4–10 frames** — and check each cut against the beat grid; bursts are almost always quantised ([[motion-beat-quantised-animation]]).
- **Frequency:** count snaps per minute. Above ~6/min the device is the style, not an accent.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `scale_step` | 1.25 | 1.18–1.45 | Below 1.15 it is not read as a snap; above 1.5 the resolution cost is visible. |
| `duration` | 0.133 s (4 f) | 0.10–0.20 s (3–6 f) | Below 3 f it is a cut; above 6 f it is a push. |
| `ease` | `expo.out` | `power4.out`–`expo.out` | Front-loaded, dead stop. |
| `overshoot` | none | — | A snap that bounces is a spring, not a snap. |
| `transform_origin` | the focal point | — | Expressed in % of the element box. Centre only if the subject is centred. |
| `source_headroom` | ≥ `scale_step` × timeline width | ≥1.0× | To snap to 1.4 on a 1920 timeline the source must be ≥2688 px wide. Check before authoring. |
| `pre_hold` | 0.5 s | 0.3–2.0 s | Stillness before the snap is what makes it violent. |
| `post_hold` | 0.7 s | 0.5–3.0 s | Nothing else moves for this long afterwards. |
| `density` | 2 per 30 s | 0–4 | Outside a designed burst. |
| `burst_shot_length` | 6 f | 4–10 f | Snap-cut montage. |
| `burst_length` | 8 shots | 4–12 | Longer stops being a burst and becomes a sequence. |
| `sfx_attack` | <20 ms | — | The whip's defining property. |
| `sfx_anchor` | frame 1 of the move | frame 1–2 | `expo.out` peaks at the start; for a whip **pan** (travel, not scale) anchor at `t_start + duration/2`, the swap/blur peak. |
| `sfx_length` | 250 ms | 150–500 ms | Longer than 500 ms is a whoosh wearing a whip's name. |
| `layer_whoosh` | optional | — | Whoosh under whip for a move that both travels and snaps; whoosh at −18 dB, whip at −14 dB. |

## Reproduction prompt

```
Author a snap zoom on {{TARGET}} landing at {{T}} to punctuate the line
"{{LINE}}". Author seconds; frame counts @30fps are derived comments.

STEP 0 - CHECK HEADROOM. The source asset's pixel width must be at least
scale_step x the composition width (1.25 x 1920 = 2400px). If it is not,
reduce scale_step or replace the asset. Do not upscale.

STEP 1 - ANCHOR. Set transformOrigin on the media element to the focal point
as a percentage of its own box (e.g. "62% 38%" for a face slightly right and
high). Do not use a CSS transform on this element - only transformOrigin.

STEP 2 - HOLD, THEN SNAP.
  Ensure nothing else animates for 0.5s before {{T}}.
  tl.fromTo("{{TARGET}}", { scale: 1.0 },
    { scale: 1.25, duration: 0.133, ease: "expo.out",
      transformOrigin: "62% 38%" }, {{T}});
  No settle tween, no overshoot, no return. If the framing must come back,
  do it on a CUT, not by animating back.

STEP 3 - QUIET AFTER. Nothing else moves for 0.7s. If a caption or graphic
must arrive, put it at least 0.7s later.

STEP 4 - SOUND. Fetch a whip: tagSlugs ANY ["weapons--whip"], duration
150-1600ms, and trim it with data-media-start so its transient sits on
{{T}} (frame 1 of the move), minus 1 frame of lead. Level -14 dB relative to
dialogue. If the move also travels across frame, layer a whoosh underneath at
-18 dB anchored on the same frame.

STEP 5 - BEAT. If a bed is playing, quantise {{T}} to the nearest beat and
re-check the pre-hold.

ACCEPTANCE TEST: extract frames at 30fps from {{T}} - 0.2 to {{T}} + 0.5.
The scale must complete inside 6 frames, must not overshoot 1.25 by more than
0.5%, and must be perfectly static from frame 7 onward. The anchor point must
stay within 2px of its position across the whole move. The whip's onset must
fall within 1 frame before {{T}} and never after.
```

## Execution spec

**HyperFrames.**

```html
<div id="shot-face" class="clip" data-start="61.0" data-duration="5.0" data-track-index="0">
  <video id="v-face" src="assets/aroll/take-14.mp4" muted playsinline
         data-media-start="212.4"></video>
</div>
```

```js
// snap at global t = 63.20, anchored on the eyes
tl.fromTo("#v-face", { scale: 1.0 },
  { scale: 1.25, duration: 0.133, ease: "expo.out", transformOrigin: "62% 38%" }, 63.20);
```

```html
<audio id="sfx-snap" src="assets/sfx/whip-crack-01.wav" data-audio-group="sfx"
       data-start="63.03" data-media-start="0.09" data-duration="0.45"
       data-track-index="12" data-volume="0.5"></audio>
<!-- file transient is 0.24s in; 63.20 - 0.24 + 0.09(trim) - 0.033(lead) = 63.017 -> 63.03 quantised -->
```

Contract points:
- `scale` and `transformOrigin` are legal on the master timeline; **`filter`/`scaleX`/`transformOrigin` are lint-clean there** (the tighter whitelist binds scene-worker prompts only).
- The `<video>` carries `data-media-start` but **must not** carry `data-start` while its wrapper does — `video_nested_in_timed_element` is a hard error. Time the wrapper *or* the video, never both.
- Every `<video>`/`<audio>` needs an `id`; `crossorigin` on media is an unsuppressable error.
- **No speed ramp exists.** `data-playback-rate` is a constant (0.1–5, pitch-preserved). A snap that also ramps the footage's speed must be **preprocessed with ffmpeg** and re-imported.
- Do not put a CSS `transform` on `#v-face` — `gsap_css_transform_conflict`.
- Land the resolved scale ≥2 frames before the clip's `data-duration`.
- For a snap on a **still**, the same tween applies to an `<img>`; check the still's pixel dimensions against the headroom rule first.

**ffmpeg — preprocessing and audit.**

```bash
# preprocess a speed-ramped snap (no rate envelope exists in-composition)
ffmpeg -i take.mp4 -filter_complex \
  "[0:v]setpts='if(between(T,2.0,2.2), 0.25*PTS, PTS)'[v]" -map "[v]" -an ramped.mp4

# audit the scale step: per-frame stills across the move
ffmpeg -i out.mp4 -ss 63.0 -t 0.6 -vf fps=30 /tmp/snap/%03d.png

# measure the whip's attack time and transient offset
ffmpeg -i whip.wav -af "astats=metadata=1:reset=1,ametadata=print" -f null -
```

**Epidemic Sound.** Verified: the library carries a real `weapons--whip` tag — e.g. *"Weapons, Whip, Bull Whip, Short, Classic Whip Crack"* (1384 ms) and *"Weapons, Whip, Bull Whip, Overhead, Single Classic Whip Crack"* (1509 ms). Because these files are longer than a snap needs, **trim to the crack** with `data-media-start` rather than letting the tail run. For the layered variant, add `swooshes--swish` (e.g. *"Swooshes, Swish, Rubber Cord, Whip Through Air, Whoosh 01"*, 854 ms) underneath. Free-text `"whip"` returns ~209 results; the tag filter is the reliable route.

**Remotion.** `interpolate(frame, [0, 4], [1, 1.25], { easing: Easing.out(Easing.exp) })` with `transformOrigin` set on the wrapper. Concept only.

## Pairs with
[[sfx-whip-crack-on-snap-cut]] · [[sfx-whip-on-punchline]] · [[motion-whip-pan-transition]] · [[motion-travel-reveal-streak]] · [[motion-camera-shake-impact]] · [[cut-punch-in-emphasis]] · [[motion-screen-recording-cursor-punch-in]] · [[motion-sfx-pass-manifest]] · [[motion-beat-quantised-animation]] · [[motion-pattern-interrupt-jolt]] · [[motion-attention-transient]]

## Failure modes
- **Snapping past the source's resolution.** 1.4× on a 1080p source in a 1080p timeline is a 40 % upscale and it is visible. Correction: check headroom before authoring; shoot or source at ≥1.5× delivery.
- **A settle.** Any return toward the start value turns a snap into a bounce and drains the punctuation. Correction: no second tween; if the framing must return, cut.
- **Centre anchor by default.** The snap lands on the middle of the frame rather than the thing. Correction: set `transformOrigin` to the focal point.
- **Whoosh instead of whip.** A 900 ms swell under a 4-frame snap arrives after the move is over. Correction: <20 ms attack, ≤500 ms total, transient on frame 1.
- **Sound late.** Past ~125 ms (ITU detectability for lag) the crack is heard as a separate event. Correction: 0–1 frame early, never late.
- **Snapping constantly.** Six per minute and the device is noise. Correction: two per 30 s outside a designed burst.
- **Motion inside the post-hold.** A caption arriving 5 frames after the snap steals the punctuation. Correction: 0.7 s of stillness.
- **Trying to ramp footage speed in-composition.** There is no rate envelope. Correction: preprocess with ffmpeg and re-import.
