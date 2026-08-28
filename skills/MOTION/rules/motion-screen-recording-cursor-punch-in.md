---
id: motion-screen-recording-cursor-punch-in
title: Drive the screen recording — anchored punch-in on the control, pop on the result
skill: motion
type: camera
family: screen-recording
tags: [skill/motion, type/camera, family/screen-recording, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:33"
    quote: "So I personally use Epidemic Sound, and there I can search for music by BPM."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:39"
    quote: "You apply the filter here and boom — music that will fit my video has arrived."
research_refs:
  - https://www.clueso.io/blog/how-to-make-tasteful-screen-capture-videos
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/4406208331923-Title-Safe-and-Safe-Action-Best-Practices
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://ffmpeg.org/ffmpeg-filters.html#fade
difficulty: medium
detectable_from: transcript+video
---

# Drive the screen recording — anchored punch-in on the control, pop on the result

## What it is
A raw screen recording is a wide, static, low-contrast rectangle in which nothing tells the viewer where to look. This note is the treatment that turns one into a directed shot: **an anchored punch-in onto the control being operated**, a deliberate cursor, a speed ramp over the dead time, and a **scale-and-sound pop on the moment the result appears**. The source demonstrates exactly this shape — the filter is applied on screen, and the arrival of the results is punctuated verbally as *"boom"* rather than shown as a passive scroll. The editorial decision to prove advice with a recording at all belongs to [[cut-screen-recording-proof-insert]]; this note owns the camera and the reveal.

## When to use it
- **Any time a claim is proved by an interface.** "You filter by BPM" is an assertion until the filter is seen being applied.
- **Whenever a UI control is smaller than about 4% of frame width** at the recording's native framing — which is nearly always, since apps are designed for a 27-inch monitor and the video will be watched on a phone.
- **On the results moment specifically.** The list populating, the render finishing, the number changing. That frame is the payoff and must be marked with scale, sound, or both.
- **Not on every action.** A punch-in per click across a 40-second walkthrough is nauseating. One punch per *decision*, held through the consequence.
- **Not as a substitute for cropping.** If the whole recording only ever matters in one region, crop the source once and skip the move.

## How to recognise it in a reference video
- **Look for scale changes with an off-centre anchor.** Track a fixed UI feature (a window corner) across the move: if the frame scales *and* translates so a specific control ends near centre, the zoom is anchored to the element, not to the frame centre. Centre-anchored zooms are the amateur default.
- **Measure the zoom factor and the ramp.** Practice bands: **1.05–1.10× for emphasis on an already-readable element**, up to **1.15×** before it reads as a hard punch, and **1.5–3×** only when the source is 4K or the target is genuinely tiny UI. Ramp length in polished work is short — **0.12–0.20 s of ease** on the ends — with the move itself lasting **0.3–0.6 s**.
- **Check for a hold at the zoomed size.** A punch that immediately releases reads as a twitch. Expect **≥0.8 s** held.
- **Check cursor behaviour.** Deliberate recordings show a cursor that moves *slower than natural*, pauses before and after clicks, and is often enlarged. A cursor that darts and overshoots is an untreated recording.
- **Look for a click marker.** A ripple, a highlight ring, or a brief scale on the control at the click frame — plus a click sound within ±1 frame.
- **Look for a speed ramp over dead time.** Compare UI motion rate before and after: typing, loading and scrolling are often run at **2–8×**, cut back to 1× at the moment of consequence. A constant-rate walkthrough with 6 seconds of loading in it is untreated.
- **Frame-step the results reveal.** Expect a **0.25–0.40 s** scale-and-opacity pop (from ~0.94–0.97 to 1.0) or a staggered arrival of rows, with a transient — impact, whoosh or confirm — inside **±1 frame** of the first result frame.
- **Measure dwell on any value the viewer must read.** A filter value, a number, a setting: it should be legible and stationary for **≥1.2 s**, or frozen for **0.5–1.0 s**, or it cannot be read at 1× without pausing.
- **Check readability of type.** Recorded UI text below ~24 px at 1080p output is unreadable in-feed; if the reference solves this with a zoom, log the zoom as required, not decorative.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `anchor` | control centre | — | `transformOrigin` expressed as `x% y%` of the recording, measured once at authoring time from a still. |
| `zoom_scale` | 1.10 | 1.05–1.15 typical · 1.5–3.0 for tiny UI on 4K source | Above 1.15 on a 1080p source, UI text softens visibly. |
| `source_res_floor` | `frame_width × zoom_scale` | — | A 2× punch on a 1080p recording needs a 3840-wide source. Re-record at 2–3× the output width rather than upscaling. |
| `zoom_in_dur` | 0.50 s (15 f) | 0.30–0.60 s | `power3.out`. Feels like a camera operator, not a jump. |
| `zoom_hold` | 1.20 s | 0.80–4.00 s | Long enough to read the thing you zoomed to. |
| `zoom_out_dur` | 0.60 s (18 f) | 0.40–0.80 s | `sine.inOut`. Exits may be slower here than the usual 0.25 s rule, because the eye is re-acquiring context. |
| `ease_shoulder` | 0.15 s | 0.12–0.20 s | The soft ends of the move; below this it reads abrupt. |
| `click_marker` | ripple, 0.35 s | 0.25–0.45 s | Scale 0 → 1 with opacity 0.6 → 0 on a ring, `power2.out`. |
| `cursor_scale` | 1.4× | 1.0–2.0× | Only if the cursor is re-drawn; a recorded cursor cannot be resized after the fact. |
| `dead_time_rate` | 4× | 2–8× | Constant rate per clip. Loading, typing, scrolling. |
| `result_pop_from` | `scale 0.96, autoAlpha 0` | 0.92–0.98 | Result panel or first row. |
| `result_pop_dur` | 0.30 s (9 f) | 0.25–0.40 s | `power3.out`. |
| `result_stagger` | 0.05 s | 0.03–0.07 s | Per row. Total stagger across all rows must stay **≤ ~0.5 s** so the arrival reads as one beat. |
| `min_dwell_readable` | 1.2 s | 0.8–2.0 s | For any value the viewer must actually read. |
| `freeze_dense_screen` | 0.75 s | 0.5–1.0 s | On settings panels and dense lists. Requires a preprocessed still — see Execution spec. |
| `sfx_offset` | 0 f | −1 to 0 f | Transient peak on the first result frame. |

## Reproduction prompt

```
Direct the screen recording {{SRC}} covering {{IN}}..{{OUT}}.

1. MEASURE FIRST. Export one still and record, in percentages of the
   recording's own frame: the control being clicked (CONTROL_X%, CONTROL_Y%)
   and the region where results appear. Confirm the source is at least
   frame_width x zoom_scale pixels wide; if not, re-record larger.
2. PUNCH IN. From {{CLICK}}-0.8s, tween the recording wrapper from scale 1 to
   1.10 over 0.50s, ease power3.out, with transformOrigin set once to
   "CONTROL_X% CONTROL_Y%" so the zoom lands on the control rather than the
   centre. Hold at least 1.2s.
3. MARK THE CLICK. At {{CLICK}}, expand a ring from scale 0 to 1 with opacity
   0.6 -> 0 over 0.35s, power2.out, centred on the control. Add a UI click
   sound with its peak on {{CLICK}}.
4. RAMP THE DEAD TIME. Any loading, typing or scrolling between {{CLICK}} and
   the result gets a constant playback rate of 4x. This stack has no rate
   envelope, so use a constant rate per clip - split the recording into
   separate clips at the boundaries rather than trying to ramp.
5. POP THE RESULT. On the first frame results are visible, animate the result
   panel from scale 0.96 / alpha 0 to scale 1 / alpha 1 over 0.30s power3.out,
   staggering rows by 0.05s with the total stagger under 0.5s. Place one
   impact or confirm transient with its peak on that frame.
6. RELEASE. Return to scale 1 over 0.60s, sine.inOut, only after the result
   has been readable for 1.2s.

ACCEPTANCE TEST: watch {{IN}}..{{OUT}} at 1x without pausing. Every value the
narration names must be readable without a pause. Then step the result frame:
the pop must start on the same frame the results appear, and the transient
must sit within one frame of it.
```

## Execution spec

**HyperFrames.** The recording is a `<video>` clip; the camera move is a GSAP tween on a **wrapper**, because the contract forbids nesting a timed `<video>` inside another timed element (`video_nested_in_timed_element`, an error) and forbids a CSS transform on the same element GSAP is tweening.

```html
<!-- the wrapper is timed; the video is not. Time the wrapper OR the video, never both. -->
<div id="rec-shot" class="clip" data-start="96.0" data-duration="12.0" data-track-index="1"
     style="overflow:hidden;">
  <div id="rec-cam" style="position:absolute; inset:0;">
    <video id="rec-video" src="assets/screen/epidemic-filter.mp4"
           style="position:absolute; inset:0; width:100%; height:100%; object-fit:cover;"
           muted playsinline></video>
  </div>
  <div id="rec-ring" style="position:absolute; left:63%; top:41%; width:64px; height:64px;
       margin:-32px 0 0 -32px; border:3px solid #fff; border-radius:50%; opacity:0;"></div>
</div>
```

```js
const IN = 96.0, CLICK = 97.6, RESULT = 99.1;
// transformOrigin set on the timeline, not in CSS, so GSAP owns the transform
tl.set("#rec-cam", { transformOrigin: "63% 41%", scale: 1 }, IN);
tl.to("#rec-cam", { scale: 1.10, duration: 0.50, ease: "power3.out" }, CLICK - 0.8);  // 15f
tl.fromTo("#rec-ring", { scale: 0, autoAlpha: 0.6 },
                        { scale: 1, autoAlpha: 0, duration: 0.35, ease: "power2.out" }, CLICK);
tl.fromTo("#rec-results", { scale: 0.96, autoAlpha: 0 },
          { scale: 1, autoAlpha: 1, duration: 0.30, ease: "power3.out",
            stagger: { each: 0.05, from: "start" } }, RESULT);
tl.to("#rec-cam", { scale: 1, duration: 0.60, ease: "sine.inOut" }, RESULT + 1.2);
```

Contract points that bind this:
- **`fromTo`, never `from`** — `from()` renders its start state at construction, before the clip's window opens, and flashes or skips under the render's non-linear seek.
- **`scale` and `transformOrigin` only**; `width`/`height`/`top`/`left` are forbidden. `transformOrigin` is lint-clean on the master timeline.
- **`autoAlpha` is legal here because `#rec-ring` and `#rec-results` are not the clip element.** Never tween `display` or raw `visibility` on a clip.
- **Stagger budget:** *"items × stagger ≤ ~0.5s"* so the arrival reads as one beat. Twelve rows at 0.05 s is 0.6 s — over budget; either stagger 0.04 s or animate a container plus the first three rows only.
- **Speed: constant only.** `data-playback-rate` is normalised `0.1..5`, render-safe and **pitch-preserved**, but *"no rate envelope exists — speed ramps must be preprocessed"*. Split the recording into adjacent clips of the same source with different rates, using `data-media-start` to enter the source at the right point. The retime math the contract gives: **consumed source = timeline duration × rate**.
- **A mid-source freeze needs a file.** *"No arbitrary mid-source freeze"* — a freeze on a dense panel requires a preprocessed still placed as an `<img>` clip, or holding the final frame of a trimmed segment.
- **Sound of a recording:** the convention is `muted` video plus a separate `<audio>` element carrying its sound, so picture and sound can be cut independently. If you keep the video's own audio, declare `data-has-audio="true"`.
- **No `crossorigin` on media, ever** — `media_crossorigin_breaks_preview` is an error with no suppression.
- Named rules that may be cited but not quoted: `coordinate-target-zoom`, `camera-cursor-tracking`, `cursor-click-ripple`, `context-sensitive-cursor`, `multi-phase-camera`, `viewport-change`, `ai-tracking-box`.

**ffmpeg — the preprocessing this note actually needs.**

```bash
# 1. speed up the dead stretch (97.9s-99.0s of source) by 4x, video only
ffmpeg -ss 97.9 -to 99.0 -i screen.mp4 -filter:v "setpts=PTS/4" -an dead-4x.mp4

# 2. a freeze frame for a dense panel: pull the still, place it as an <img> clip
ffmpeg -ss 99.1 -i screen.mp4 -frames:v 1 -update 1 result-panel.png

# 3. crop once if only one region ever matters (cheaper than a permanent zoom)
ffmpeg -i screen.mp4 -vf "crop=1440:810:240:135,scale=1920:1080" screen.crop.mp4

# 4. measure the source's real resolution before designing any punch
ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 screen.mp4
```

**Epidemic Sound.** Two sounds, both verified against the live catalogue:
- Click on the control: `SearchSoundEffects { query: { term: "ui button select click" }, filter: { tagSlugs: { matchType: "ANY", values: ["user-interface--click"] }, duration: { max: 500 } } }` — real durations **197–663 ms**.
- The "boom" on the result: `SearchSoundEffects { query: { term: "cinematic impact hit low boom" }, filter: { tagSlugs: { matchType: "ANY", values: ["designed--boom"] }, duration: { max: 4000 } } }` — real durations **2.8–3.5 s** with a long tail; place at the result frame and let it ring under the narration, `data-volume` ≈ 0.35–0.45, carved against the voice group if a bed is playing ([[sfx-cinematic-hit-emphasis]]).

**Remotion:** an `<OffthreadVideo>` inside a scaled wrapper with `interpolate()`d scale and a `transformOrigin` string — conceptually identical. Remotion is not a runtime here.

## Pairs with
[[cut-screen-recording-proof-insert]] · [[motion-image-focal-point-direction]] · [[cut-punch-in-emphasis]] · [[motion-instant-appearance-sfx-justified]] · [[motion-sound-bound-motion-event]] · [[sfx-cinematic-hit-emphasis]] · [[pace-silent-demonstration-window]] · [[motion-camera-shake-impact]]

## Failure modes
- **Centre-anchored zoom.** The control drifts out of frame as you push in, and the viewer watches the wrong region. Correction: measure the control's position once and set `transformOrigin` to it.
- **Zooming past the source resolution.** A 2× punch on a 1080p capture produces mush that reads as low production value regardless of the motion. Correction: re-record at 2–3× the output width; check with `ffprobe` before designing.
- **Punch per click.** Continuous zooming is exhausting and destroys the meaning of a zoom. Correction: one punch per decision, held through its consequence.
- **No hold.** A punch that releases immediately reads as a twitch. Correction: ≥0.8 s at size, ≥1.2 s if something must be read.
- **Result appears with no pop and no sound.** The payoff frame passes unmarked and the proof lands as a shrug. Correction: 0.30 s scale-and-alpha pop plus a transient on the same frame.
- **Trying to ramp speed inside the composition.** There is no rate envelope; a spec that animates `data-playback-rate` silently does nothing. Correction: constant rate per clip, or preprocess with `setpts`.
- **Unreadable dwell.** A value on screen for 0.5 s cannot be read at 1×. Correction: 1.2 s, or a freeze still.
- **Cursor untreated.** A darting, overshooting cursor makes a deliberate demo look like a fumble; and it cannot be fixed in post, because the cursor is baked into the recording. Correction: fix it at capture time — move slowly, pause before and after clicks, enlarge the system cursor.
- **Known gap:** this stack has no cursor-tracking or content-aware reframe (*"No automatic face tracking or content-aware reframe"* — pan and zoom are authored geometry). Every anchor coordinate is measured by hand at authoring time and baked as a constant; record those coordinates in the design document so a later pass can re-derive them.
