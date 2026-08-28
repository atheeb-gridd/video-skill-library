---
id: motion-camera-shake-impact
title: Impact shake — one decaying kick of the whole frame, on the hit frame
skill: motion
type: camera
family: shake
tags: [skill/motion, type/camera, family/shake, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:37"
    quote: "Then you'll see images or text or maybe the whole video shaking."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:14"
    quote: "Now the peak of my hit sound effect should land exactly on the impact frame of my hand."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/three-flashes-or-below-threshold.html
  - https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://docs.unity3d.com/Packages/com.unity.cinemachine@2.8/manual/CinemachineImpulse.html
  - https://source.opennews.org/articles/motion-sick/
difficulty: high
detectable_from: transcript+video
---

# Impact shake — one decaying kick of the whole frame, on the hit frame

## What it is
A single impulse, not an oscillation: on one nominated frame the **entire picture** jumps a few pixels off centre with a small rotation, then settles back to rest over 8–15 frames on a damped curve. Everything moves together — subject, background, captions, graphics — which is what distinguishes it from the per-element wiggle in [[motion-shake-keyframes]]. It exists to make a *hit* physical. Its parameters are borrowed from game-engine impulse systems, which model exactly this shape: an event fires a signal with an amplitude, a frequency and a decay envelope, and the camera listens. The rule that makes it work is not visual at all: the sound's transient and the shake's first frame are the same frame.

## When to use it
- **On a smash cut or a hard reveal**, at the exact frame the new image lands — see [[cut-smash-cut]].
- **On a number, word or logo that slams in**, as the physical consequence of the slam.
- **On a diegetic impact** — a hand hitting a table, a door, a foot landing — where the shake is the camera's reaction to something visible.
- **At the top of a drop**, where the riser resolves into the beat — see [[motion-anticipation-build-to-reveal]].

One per structural beat, at most. Two impact shakes inside 5 seconds cancel each other: the second has nothing to be an escalation of. Never in an intimacy register ([[motion-format-promise-motion-budget]]), and never on a plain cut with no sound behind it.

## How to recognise it in a reference video
- **Everything moves in lockstep.** Extract frames at native rate and track two features from different depth planes (a caption and the background). If both displace by the same vector, it is a frame shake; if only one moves, it is element shake.
  `ffmpeg -i ref.mp4 -ss <t> -t 0.8 -vf fps=30 /tmp/imp/%03d.png`
- **The displacement profile is asymmetric.** The first frame carries **60–100% of peak amplitude**; the settle takes 8–15 frames. A symmetric in-and-out over the same number of frames is a bounce, not an impact.
- **Amplitude bands at 1080p:** subtle **8–14 px** (0.7–1.3% of frame height), standard **15–25 px**, heavy **26–45 px**. Above ~4% of frame height you will see edge overscan unless the shot was pre-scaled.
- **Rotation is present in good ones:** **0.4–1.5°**, and usually a single direction rather than an oscillation.
- **Look for a scale spike.** Many impact shakes also punch scale by **1.5–4%** on the same frame and release it with the position. Measure the frame's field of view against the frame before.
- **The audio is the ground truth.** Locate the loudest transient in a ±0.5 s window and compare its sample position to the shake's first frame. In competent work they are the **same frame, ±1**. The contract for detectability is asymmetric: audio lagging picture is tolerated to about 125 ms, audio *leading* only to about 45 ms (ITU-R BT.1359-1); broadcast practice (ATSC IS-191) tightens that to +15 ms lead / −45 ms lag. At 30 fps that means **never more than 1 frame early, at most 1–3 frames late**.
- **Check for a companion whoosh.** If the impact has a visible approach (a hand coming down, an object flying in), a whoosh usually covers the approach and the hit lands on the frame of contact.
- **Log the negative.** Many polished channels never shake the frame. Record "no frame shake" as a profile fact.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `peak_amp_x` | 18 px @1080p | 8–45 px | Express as % of frame height for portrait: 1.7% default. |
| `peak_amp_y` | 12 px @1080p | 6–30 px | Keep below `peak_amp_x` for a lateral kick, above it for a vertical slam. |
| `peak_rot` | 0.8° | 0.3–1.5° | One direction. Oscillating rotation reads cartoonish. |
| `scale_spike` | 1.025 | 1.00–1.04 | Optional; released on the same curve as position. |
| `settle_duration` | 0.40 s (12 f) | 0.27–0.50 s (8–15 f) | Under 8 frames reads as a glitch; over 15 reads as a drift. |
| `settle_curve` | `springEase({ response: 0.30, dampingFraction: 0.65 })` | response 0.25–0.35 · ζ 0.60–0.75 | Take **both** the ease and the duration from the helper. ζ<1 overshoot is legal here because this is a transform-only tween. |
| `fallback_curve` | `power3.out` | `power2.out`–`power4.out` | If no spring helper is available. No overshoot, slightly less physical. |
| `overscan` | 1.05 | 1.03–1.10 | Base scale on the shaken wrapper so edges never pull inside the frame. Must be ≥ 1 + 2·peak_amp/frame_height. |
| `sfx_align` | 0 f | −1 to +1 f | The SFX **peak** — not its file start — sits on the shake's first frame. |
| `min_gap_between_shakes` | 5 s | 3–20 s | Below 3 s they stop being punctuation. |
| `count_per_minute` | 1 | 0–3 | Above 3/min the device is spent. |
| `flash_ceiling` | 3/s | — | WCAG 2.3.1, if the shake is paired with a white flash frame. |

## Reproduction prompt

```
Add one impact shake to the whole frame at {{HIT}}.

Structure: a full-bleed wrapper #camera containing every visual layer of the
scene, given a base scale of 1.05 as overscan so the kick cannot expose the
edges. Set the base scale with a zero-duration tl.set at the scene start - do
NOT put it in CSS, because a CSS transform plus a GSAP tween on the same
property is a lint error in this stack.

At {{HIT}}, jump to x:18, y:-12, rotation:0.8, scale:1.05*1.025 with a
duration of 0 (a tl.set), then in the same frame start the settle:
tween back to x:0, y:0, rotation:0, scale:1.05 over 0.40s using a spring ease
of response 0.30 and dampingFraction 0.65, taking the duration from the helper
if you have it, otherwise power3.out. Overshoot is permitted here because only
transforms are animated - never put an overshooting curve on opacity.

Place the hit SFX so its loudest transient - not its file start - lands on
{{HIT}}. Trim into the file with data-media-start to achieve that. If the
impact has a visible approach, add a whoosh covering the approach that ends at
{{HIT}}. Sound at -12 to -15 dB relative to a 0 dB dialogue bus.

ACCEPTANCE TEST: step {{HIT}}-2f .. {{HIT}}+15f. Frame {{HIT}} must show the
full displacement, every layer must move by the same vector, no frame edge may
show background, motion must be at rest by {{HIT}}+15f, and the audio transient
must sit within one frame of {{HIT}}.
```

## Execution spec

**HyperFrames.** The whole frame is one wrapper. The contract's hard nesting limit matters here: *"a sub-comp timeline cannot animate host-root elements"* — so if the scenes are sub-compositions, the shaken wrapper must live at the host root and contain the scene slots, and the shake tween must be written on the **main** timeline at global time.

```html
<!-- index.html : one shaken camera wrapper containing the scene slots -->
<div id="camera" style="position:absolute; inset:0; overflow:hidden;">
  <div id="el-scene-a" data-composition-id="scene-a" data-composition-src="compositions/scene-a.html"
       data-start="0" data-duration="6" data-track-index="1"></div>
  <div id="el-scene-b" data-composition-id="scene-b" data-composition-src="compositions/scene-b.html"
       data-start="6" data-duration="6" data-track-index="0"></div>
</div>
```

```js
const HIT = 6.0;                                  // composition seconds
// overscan + resting pose, set on the timeline (not CSS) to avoid gsap_css_transform_conflict
tl.set("#camera", { scale: 1.05, x: 0, y: 0, rotation: 0 }, 0);
// the kick: instantaneous displacement on the hit frame
tl.set("#camera", { x: 18, y: -12, rotation: 0.8, scale: 1.05 * 1.025 }, HIT);
// the settle: 12 frames @30fps = 0.4s, transform-only so overshoot is legal
tl.to("#camera", { x: 0, y: 0, rotation: 0, scale: 1.05,
                   duration: 0.4, ease: "power3.out" }, HIT);
```

Contract points that bind this:
- **`#camera` must not be a clip.** Give it no `data-start`; it is a plain positioned container. A timed ancestor clamps its descendants' visibility, which would break the scene windows.
- Because `#camera` is not a root-level timed clip, it does **not** get the framework's automatic `position: absolute; inset: 0` — it needs its own, exactly as written above, or it collapses to zero height.
- `scale`, `x`, `y`, `rotation` only. `filter` and `transformOrigin` are also lint-clean on the master timeline.
- **Spring:** `springEase({ response, dampingFraction })` is a pure function of progress and is seek-safe; take the `duration` it returns rather than inventing one. `dampingFraction` 0.60–0.70 is the *"explicitly playful"* band — appropriate for an impact, not for entrances. Below 0.55, don't.
- **Shader-transition projects:** a full-screen fill on the composition **root** is dropped on the layered-composite path — keep the background fill on a full-bleed child inside `#camera`, not on the root.
- The kick's rest state must land **before** the enclosing content's `data-duration` (half-open window `[start, start+duration)`).
- Named rules that may be cited, not quoted: `kinetic-beat-slam`, `physics-press-reaction`, `press-release-spring`, `motion-blur-streak`, `multi-phase-camera`.

**ffmpeg — baked version, when the shake must be in a delivered file.** Deterministic, single-impulse, with overscan:

```bash
# 18px x / 12px y kick at t=6.0s settling over 0.4s, cubic-out decay, 1080p
ffmpeg -i in.mp4 -vf "scale=2016:1134,crop=1920:1080:\
x='48+18*if(between(t,6.0,6.4), pow(1-(t-6.0)/0.4,3), 0)':\
y='27-12*if(between(t,6.0,6.4), pow(1-(t-6.0)/0.4,3), 0)'" out.mp4
```

**Epidemic Sound.** Two assets, one placement rule.
- The hit: `SearchSoundEffects { query: { term: "cinematic impact hit low boom" }, filter: { tagSlugs: { matchType: "ANY", values: ["designed--boom"] }, duration: { max: 4000 } } }`. Real library durations in this tag run **2.8–3.5 s** because the tail is long — the transient is near the file start, so place with `data-start = HIT` and let the tail ring, or trim the pre-roll with `data-media-start` if the file has any.
- The approach: `filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--whoosh"] }, duration: { max: 2000 } }` — real durations 1.0–1.6 s.

```html
<audio id="sfx-hit" src="assets/sfx/impact-low-boom.wav" data-audio-group="sfx"
       data-start="6" data-duration="2.2" data-media-start="0.02"
       data-track-index="12" data-volume="0.45"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:1.6,&quot;v&quot;:1},{&quot;t&quot;:2.2,&quot;v&quot;:0}]}]}"></audio>
```
Remember the automation lane's `t` is **clip-local** and its first value is held backwards to the clip start; and never GSAP-tween `volume` on a track that already has a `volume` lane (`audio_volume_double_automation` — the lane wins).

**Remotion:** `useCurrentFrame()` minus the hit frame, fed through a decaying spring, applied to a wrapping `<AbsoluteFill>` — concept only.

## Pairs with
[[motion-shake-keyframes]] · [[cut-smash-cut]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-peak-on-impact-frame]] · [[motion-anticipation-build-to-reveal]] · [[motion-sound-bound-motion-event]] · [[sfx-whoosh-transition-movement-reveal]] · [[motion-format-promise-motion-budget]]

## Failure modes
- **Shake without a transient.** The single most common failure; the frame moves for no audible reason and reads as an encoding fault. Correction: an impact whose loudest sample sits on the shake's first frame.
- **SFX file start aligned instead of SFX peak.** Many hit files have 20–80 ms of pre-roll; aligning the file start puts the transient 1–3 frames late. Correction: find the peak in the waveform and back-time with `data-media-start`.
- **No overscan.** The kick exposes black or page background at an edge for two frames — instantly amateur. Correction: base scale ≥ 1 + 2·peak_amp/frame_height, minimum 1.03.
- **Symmetric in-and-out.** Reads as a bounce or a bump, not an impact. Correction: instantaneous displacement, then decay only.
- **Overshoot on opacity.** If you spring a fade at ζ<1 the alpha goes above 1 or below 0 and clips. Correction: transforms only; split any opacity onto a `power2.out` tween at the same position.
- **Shaking the clip element or a sub-comp's internals.** Captions or overlays that live outside the shaken wrapper stay still and reveal the trick. Correction: everything visual must be inside `#camera`.
- **Too many.** Three in ten seconds and the device is dead. Correction: one per structural beat, ≥3 s apart.
- **Known gap:** the impulse parameter model here is transposed from game-engine camera-impulse systems (amplitude, frequency, decay envelope) and calibrated by frame measurement; no film-post standard publishes amplitude figures. The AV-sync figures, by contrast, are standards-based (ITU-R BT.1359-1, ATSC IS-191, EBU R37) and should be treated as harder numbers than the amplitudes. As with all shake, a rendered MP4 cannot honour a viewer's reduced-motion preference — note it rather than claiming mitigation.
