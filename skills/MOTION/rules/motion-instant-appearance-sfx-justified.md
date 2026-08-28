---
id: motion-instant-appearance-sfx-justified
title: Let it appear on one frame and let the sound explain how it got there
skill: motion
type: motion
family: entrance
tags: [skill/motion, type/motion, family/entrance, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/editing-kt, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:03"
    quote: "Any time a graphic shows up on screen, it can't just appear out of nowhere. That doesn't make sense. It has to get into the frame somehow."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:13"
    quote: "You don't necessarily have to animate the elements. You can also have something magically appear on screen, but then explain how it got there with a sound effect."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:21"
    quote: "I like using this shutter sound effect, but a pop or something similar works too."
research_refs:
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://www.epidemicsound.com/sound-effects/categories/designed/riser/
  - https://ffmpeg.org/ffmpeg-filters.html#fade
  - https://www.clueso.io/blog/how-to-make-tasteful-screen-capture-videos
difficulty: low
detectable_from: transcript+video
---

# Let it appear on one frame and let the sound explain how it got there

## What it is
The **null entrance**: an element goes from absent to fully present between two adjacent frames, with no translate, no scale, no fade — and a transient sound on the appearance frame carries the whole justification. The continuity requirement ("it has to get into the frame somehow") is satisfied in the **audio domain** instead of the visual one. The source's default is a camera-shutter sound; a pop, a click or a soft transient also works. Done right it is the cheapest and fastest entrance available and it reads as *deliberate* rather than lazy, because the sound is doing what the animation would have done. Done without the sound it is the exact defect the source is warning about.

## When to use it
- **When speed is the point.** Rapid-fire lists, a stack of receipts, evidence dropped one item at a time on a fast narration — a 12-frame slide per item would fall behind the words; an instant appearance keeps up.
- **When the element is photographic.** A screenshot, a tweet, a photo. A shutter sound frames the appearance as *a photograph being taken*, which is a coherent story about how it arrived.
- **When there is nowhere to come from.** A label in the middle of a dense frame has no off-screen edge to travel from; sliding it in crosses other content.
- **When motion budget is tight** ([[motion-format-promise-motion-budget]]) — an instant appearance costs almost no motion and no attention drift.
- **Not for hero reveals.** A title card, the video's thesis, a big number: those want a real animated entrance, 0.4 s on `power3.out`. Instant appearance reads as informational, not important.
- **Not for scenes.** Individual elements may appear instantly; a scene change may not. The stack's own transition doctrine is explicit that every composition uses transitions and every scene uses entrance animations.

## How to recognise it in a reference video
- **Frame-step the element's arrival.** The test is binary: is there a frame where the element is at partial opacity, partial scale or off its final position? If not — absent on frame *n*, complete on frame *n+1* — it is a null entrance.
  `ffmpeg -i ref.mp4 -ss <t-0.3> -t 0.8 -vf fps=30 /tmp/app/%03d.png`
- **Then look at the audio in the same window.** Extract and inspect the transient:
  `ffmpeg -ss <t-0.3> -t 0.8 -i ref.mp4 -vn -af "highpass=f=200" /tmp/app.wav`
  Expect a sharp attack whose peak sits **on the appearance frame, or up to 1 frame before it**. Audio *leading* picture is detectable from about 45 ms (≈1.35 frames at 30 fps); audio *lagging* is tolerated to about 125 ms. So a transient 1 frame early is invisible; 3 frames late is noticeable and reads as sloppy.
- **Identify the sound family.** Shutter (a mechanical two-part click, 0.3–1.0 s including tail), pop (0.15–0.4 s), UI click (0.2–0.7 s), tape stop, soft transient. A shutter specifically implies "photograph"; if the element is not photographic, the shutter is a mismatch worth logging.
- **Count how many appear this way in a row.** Competent work varies the sample across a run of items, or pitches it up/down per item. **The same file three times in a row** is the mistake the sound-design source names explicitly.
- **Look for a 1–2 frame flash or micro-pop.** Some instant appearances add a single frame at `scale: 1.02` or a one-frame white flash to give the arrival physicality. Detect it by comparing the element's bounding box on the first two frames.
- **Log the null case.** An element that appears instantly with **no** sound is a defect in the reference, not a technique. Note it as such so the design pass does not reproduce it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `appearance_duration` | 0 f (1-frame swap) | 0–1 f | The whole point. If you find yourself using 2+ frames, author a real entrance instead. |
| `sfx_offset` | 0 f | −1 to 0 f | Transient peak relative to the appearance frame. Never late; 1 frame early is free. |
| `sfx_family` | shutter | shutter · pop · UI click · tape stop · soft transient | Shutter for photographic content; pop/click for UI, labels and list items. |
| `sfx_duration` | 0.4 s | 0.15–1.05 s | Real Epidemic shutter assets measure **379–1062 ms**; UI clicks **197–663 ms**. The tail may run past the appearance; only the attack must be aligned. |
| `sfx_level` | 0.35 (`data-volume`) | 0.25–0.5 | Sound-effects bus sits **−12 to −15 dB** against a dialogue bus at 0 to −3 dB. |
| `variation_window` | 3 items | 2–5 | Rotate between at least 2–3 different files, or pitch-shift, within this many consecutive appearances. |
| `pitch_variation` | ±2 semitones | ±0–4 | Achieved with `data-playback-rate` (pitch-preserved, so it changes length not pitch) or a baked pitch shift — see Failure modes. |
| `micro_pop` | off | off · `scale: 1.02` for 2 f | Optional physicality. Keep it at 2 frames; longer and it becomes a spring entrance. |
| `flash_frame` | off | off · 1 f | A single-frame white overlay at 0.25–0.5 alpha. Hard ceiling: no more than three luminance flips per second anywhere (WCAG 2.3.1). |
| `min_hold` | 1.0 s | 0.8–4 s | Whatever appeared must be readable. Under 0.8 s it cannot be read no matter how it arrived. |

## Reproduction prompt

```
Make {{ELEMENT}} appear instantly at {{IN}}, justified by a sound.

1. VISUAL: give the element data-start={{IN}} and an explicit data-duration
   covering its hold. Write NO entrance tween - no fade, no slide, no scale.
   The framework's clip window makes it absent before {{IN}} and complete on
   {{IN}}. Optionally add exactly 2 frames of micro-pop: tl.set scale 1.02 at
   {{IN}}, tween scale to 1 over 0.067s ease power2.out.
2. AUDIO: place one transient so its PEAK - not its file start - lands on
   {{IN}} or one frame earlier. Inspect the waveform, measure the offset from
   file start to peak, and subtract it using data-media-start. Put the clip on
   data-audio-group="sfx", data-track-index 12 or above, data-volume 0.35.
   Give it an id: an audio element without an id is never mixed and renders
   silent.
3. FAMILY: use a camera shutter if {{ELEMENT}} is a photo, screenshot or
   tweet; a pop or UI click otherwise.
4. VARIATION: if this is one of a run, use a different file (or a different
   data-playback-rate between 0.9 and 1.1) from the previous two appearances.
5. HOLD: the element must stay at least 1.0s so it can be read.

ACCEPTANCE TEST: step {{IN}}-2f .. {{IN}}+2f. The element must be wholly
absent on {{IN}}-1 and wholly present on {{IN}}, with no partial state on any
frame. Then listen at 1x with the picture: the arrival must feel caused. If it
feels like a dropped frame, the transient is late - move it one frame earlier.
```

## Execution spec

**HyperFrames.** This is the one entrance that needs no animation code at all: the clip's own timing window *is* the entrance.

```html
<!-- visual: appears exactly at 21.5s, holds 2.4s. No tween. -->
<div id="proof-tweet" class="clip" data-start="21.5" data-duration="2.4" data-track-index="2"
     style="position:absolute; left:12%; top:18%; width:44%;">
  <img src="assets/img/tweet.png" style="width:100%; display:block;">
</div>

<!-- audio: shutter, peak back-timed onto the appearance frame -->
<audio id="sfx-shutter-1" src="assets/sfx/dslr-shutter.wav"
       data-audio-group="sfx" data-start="21.5" data-duration="0.9"
       data-media-start="0.014" data-track-index="12" data-volume="0.35"></audio>
```

```js
// optional 2-frame micro-pop; the wrapper is the clip, so pop an INNER element
tl.set("#proof-tweet-inner", { scale: 1.02 }, 21.5);
tl.to("#proof-tweet-inner", { scale: 1, duration: 0.067, ease: "power2.out" }, 21.5);
```

Contract points that bind this:
- **`data-start` is what makes an element a clip**, and the visibility window is half-open `[start, start+duration)` — so the element is hidden at exactly `start + duration` and two clips can be authored back to back with no overlapping frame. That is precisely the mechanism delivering a one-frame appearance.
- **`data-duration` is required** for `div` and `img` clips. Without a resolvable duration the element *never ends* and stays visible for the rest of the composition.
- **`data-media-start` is in seconds**, and it is how you align a transient without cutting a file: *"a clip plays a sub-window via `data-media-start` + `data-duration`… Only cut a physical file when exporting/assembling outside the composition."*
- **Every `<audio>` needs an `id`** — `media_missing_id` is a lint **error**, and an id-less `<audio>` is *never mixed*, producing a silent render.
- Audio lives on `data-track-index` **10+** by convention; two `<audio>` sharing a track index **and** overlapping in time raise `duplicate_audio_track`. A run of instant appearances 0.4 s apart with 0.9 s shutters *will* overlap — give consecutive SFX different track indices (12, 13, 12, 13…).
- **There is no audio-follows-animation attribute.** Picture and sound are coupled by the author writing the same number twice. If the visual lives in a **sub-composition** at scene-local time `t`, the audio at the host root needs `data-start = t + slot data-start`.
- **The micro-pop must be on an inner element**, since the framework owns clip layout and a CSS transform on the clip plus a GSAP tween is `gsap_css_transform_conflict`.
- **Scene-level exception:** the transition doctrine (*"Every scene uses entrance animations"*, *"Exit animations are BANNED except on the final scene"*) governs scenes, not elements inside them. Do not use this note to skip a scene transition.

**Epidemic Sound.** Verified against the live catalogue:
```
SearchSoundEffects {
  query:  { term: "digital camera shutter click take photo" },
  filter: { tagSlugs: { matchType: "ANY", values: ["communications--camera"] },
            duration: { max: 1500 } },
  sort:   { by: "POPULARITY", order: "DESCENDING" }, first: 10 }
```
Real results run **379 ms** (SLR "Shutter Click Only") to **1062 ms** (Nikon D3100 shutter) — the short, click-only variants are the ones to prefer, because a long mechanical tail smears the arrival. For the pop/click family:
```
SearchSoundEffects {
  query:  { term: "ui button select confirm pop" },
  filter: { tagSlugs: { matchType: "ANY", values: ["user-interface--click"] },
            duration: { max: 800 } } }
```
Real durations there: **197–663 ms**. Download to `assets/sfx/`, then place as above. Fetch **two or three** variants in one pass so the variation rule can be satisfied without re-querying.

**ffmpeg.** Only needed to *measure* the transient offset, or to trim a file that is leaving the pipeline:
```bash
# find the peak's position in the file, to derive data-media-start
ffmpeg -i dslr-shutter.wav -af "astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.Peak_level" -f null -
# hard-trim a shutter's pre-roll (only when the asset leaves the composition)
ffmpeg -i dslr-shutter.wav -ss 0.014 -t 0.40 -c:a pcm_s16le shutter.trim.wav
```

**Remotion:** a `<Sequence from={frame}>` with no animation inside plus an `<Audio>` starting at the same frame — conceptually identical. Remotion is not a runtime in this stack.

## Pairs with
[[motion-sound-bound-motion-event]] · [[sfx-peak-on-the-cut]] · [[sfx-air-on-micro-movement]] · [[motion-image-focal-point-direction]] · [[motion-colour-shift-connotation]] · [[cut-continuity-pass]] · [[motion-format-promise-motion-budget]] · [[sfx-placement-discipline]]

## Failure modes
- **No sound.** Then it is not this technique, it is the defect the source is describing: a graphic that appeared out of nowhere. Correction: a transient on the appearance frame, or author a real animated entrance.
- **File start aligned instead of the peak.** Shutters and pops commonly carry 10–80 ms of pre-roll, which puts the transient 1–3 frames late — right at the edge of detectability. Correction: measure the peak, back-time with `data-media-start`.
- **Transient late.** Late audio reads as a dropped frame. Correction: 0 or −1 frame; never positive.
- **Same sample repeated.** *"The same sound effect repeated again and again"* is a named sound-design mistake; four identical shutters in four seconds is comedy. Correction: rotate 2–3 variants, or vary `data-playback-rate`.
- **Shutter on non-photographic content.** A shutter on a bullet point implies a camera that isn't there. Correction: pop or click.
- **Used on a hero reveal.** The most important element in the video arriving with no animation reads as informational. Correction: give thesis-level content a real entrance.
- **Hold too short.** An instant appearance held 0.5 s cannot be read. Correction: 1.0 s minimum.
- **Overlapping audio on one track index.** Runs of fast appearances trip `duplicate_audio_track`. Correction: alternate track indices.
- **Known gap — pitch variation.** `data-playback-rate` is documented as **pitch-preserved**, so it changes an SFX's *length*, not its pitch. There is therefore **no in-composition pitch shift**: real pitch variation must be baked before the file enters the composition (e.g. `ffmpeg -af asetrate=44100*1.06,aresample=44100`), or achieved by using genuinely different assets. Do not write a spec that pitches an SFX with an attribute that cannot do it.
