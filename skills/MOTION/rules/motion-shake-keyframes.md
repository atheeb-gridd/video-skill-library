---
id: motion-shake-keyframes
title: Shake keyframes on an image, a text block or the whole frame
skill: motion
type: motion
family: shake
tags: [skill/motion, type/motion, family/shake, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:35"
    quote: "You can also add shake keyframes."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:37"
    quote: "Then you'll see images or text or maybe the whole video shaking."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:41"
    quote: "You'll never catch me doing this, because I don't like it. But if you want to do it, go for it."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/three-flashes-or-below-threshold.html
  - https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html
  - https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion
  - https://source.opennews.org/articles/motion-sick/
  - https://helpx.adobe.com/after-effects/using/expression-language-reference.html
difficulty: high
detectable_from: video
---

# Shake keyframes on an image, a text block or the whole frame

## What it is
A high-frequency, low-amplitude oscillation of an element's **position and rotation** around its resting pose, sustained for a fraction of a second and then decayed to zero. It is the classic `wiggle`-expression move from After Effects — vary a transform property randomly at a stated frequency and amplitude — applied to one graphic, to a caption word, or to a wrapper containing the whole picture. The source names it as an available attention device and then explicitly rejects it for his own style: *"You'll never catch me doing this, because I don't like it."* This note is therefore catalogued with its taste caveat attached: it is in the library so an analysis pass can *detect* it and a design pass can *decide against it*, not because it is house style. The whole-frame variant on an impact is a different move with different parameters and lives in [[motion-camera-shake-impact]].

## When to use it
Three legitimate slots, and one illegitimate one worth naming.
- **A word that is itself unstable** — "panic", "crashed", "collapse", "glitch". Shake the word, not the sentence, for 0.2–0.35 s on the syllable.
- **A diegetic vibration** — a phone buzzing on a table, an engine, a notification. Here the shake is *motivated* by the picture and needs a diegetic sound, not a design sound.
- **A comedic or meme register**, where the shake is admitted to be a joke and lands with a cartoon SFX.
- **Not** as a generic "make this feel energetic" treatment on arbitrary graphics. That is the use the source rejects, and it is also the use that reads as amateur fastest, because it is uncorrelated with meaning.

Do not use it at all in an intimacy register — see [[motion-format-promise-motion-budget]].

## How to recognise it in a reference video
- **Extract frames at native rate around the suspected event** and read them in sequence:
  `ffmpeg -i ref.mp4 -ss <t> -t 1.0 -vf fps=30 /tmp/sh/%03d.png`
  A shake shows as a **direction reversal every 2–4 frames** in the element's bounding box. Reversal every 1 frame is not a shake, it is strobe, and it reads as compression noise.
- **Measure the amplitude in pixels, then normalise to frame height.** Typical bands at 1080p: caption/word shake **±2–6 px** (0.2–0.6% of frame height); graphic shake **±6–14 px**; whole-frame shake **±10–30 px**. Above ~3% of frame height on a full-frame element, edges pull inside the frame and you will see the background.
- **Check for a rotation component.** A shake built from translation only reads mechanical; competent shakes add **±0.3–1.2°** of rotation. Measure by tracking two corners of a rectangular element.
- **Check for decay.** Professional shakes are enveloped: peak amplitude in the first 2–3 frames, then a fall to zero over 6–12 frames. A constant-amplitude shake that stops abruptly is the amateur tell.
- **Check the scope.** Is the *element* shaking against a stable frame, or is everything shaking together? If captions, background and subject all move identically, it is a frame/camera shake and belongs to [[motion-camera-shake-impact]].
- **Audio track:** a shake with no transient underneath it is almost always a mistake. Expect an impact, a rumble, or a diegetic buzz inside **±2 frames** of the shake's first frame.
- **Log it as a negative when absent.** If a reference never shakes anything across a whole video, write "no shake" into the profile; that is a style decision worth preserving.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `amplitude_x` | 6 px @1080p | 2–30 px | Scale with frame height, not width. ≤6 px for text, 6–14 px for graphics, 10–30 px for the whole frame. |
| `amplitude_y` | 0.7 × `amplitude_x` | 0.5–1.0 × | Equal x/y reads circular and unnatural; a slight vertical bias reads as a knock. |
| `amplitude_rot` | 0.6° | 0–1.2° | Above ~1.5° on text, glyph edges alias badly after encoding. |
| `frequency` | 8 Hz | 5–10 Hz | At 30 fps a full cycle at 8 Hz is 3.75 frames. **Hard ceiling 10 Hz** — above that the reversal falls inside 1.5 frames and temporally aliases into flicker. Nyquist is 15 Hz; do not go near it. |
| `duration` | 0.30 s (9 f) | 0.13–0.60 s | Under 0.13 s (4 f) nothing is perceived as a shake; over 0.6 s it stops being punctuation and becomes an effect. |
| `decay` | `power2.out` on the amplitude envelope | `power1.out`–`power3.out` | Amplitude must reach exactly 0 before the clip's `data-duration`. |
| `sustain_fraction` | 0.25 | 0–0.4 | Fraction of `duration` at full amplitude before decay begins. |
| `steps` | 8 | 4–16 | Number of discrete legs authored. `duration × frequency × 2` ≈ steps. |
| `seed` | element index | integer | Must be deterministic. Two siblings shaking on the same seed look like one rigid object. |
| `sfx_offset` | 0 f | −2 to 0 f | The transient lands on or up to 2 frames before the first shake frame. |
| `flash_ceiling` | 3/s | — | WCAG 2.3.1. A shake that also changes luminance (a flashing badge) must stay under three flips per second across 25% of any 10° field. |

## Reproduction prompt

```
Author a decaying shake on {{TARGET}} starting at {{IN}}.

Do NOT use a runtime random function - this stack bans unseeded randomness and
wall-clock in compositions. Precompute the shake legs once at composition setup
from a seeded pseudo-random sequence (or write the array literal by hand), then
play them back as a chain of short tweens on the paused timeline.

Values: AMP_X 6px, AMP_Y 4px, AMP_ROT 0.6deg at 1080p; FREQ 8Hz, so one leg
every 0.0625s (about 2 frames at 30fps); DURATION 0.30s, i.e. 8 legs. Hold full
amplitude for the first 25% of DURATION, then scale each subsequent leg's
amplitude by a power2.out falloff so the last leg is 0. Ease each leg "none"
(linear) - easing individual legs muddies the reversal. Final leg must land
exactly on x:0, y:0, rotation:0, and must resolve at least 2 frames before the
clip's data-duration ends.

Shake a WRAPPER, never the .clip element itself, and never tween width, height,
top or left - x, y and rotation only. If two siblings shake, give each a
different seed.

Pair it with one transient: an impact for a knock, a buzz for a diegetic
vibration, placed at {{IN}} or up to 2 frames earlier, -12 to -15 dB.

ACCEPTANCE TEST: step frames {{IN}}..{{IN}}+0.35s. Direction must reverse no
faster than every 2 frames; amplitude must visibly fall; the element must be
exactly at rest on the last frame; no element edge may pull inside the frame.
```

## Execution spec

**HyperFrames — determinism is the binding constraint.** The contract bans *"unseeded `Math.random()`"* and render-time clocks, and bans standalone `gsap.to()` calls (*"Ambient pulses must attach to the seekable `tl`"*). So an After-Effects-style `wiggle(8, 6)` has no direct equivalent: you bake the schedule.

```js
// Deterministic shake: legs computed once at setup, then played on the paused timeline.
function shakeLegs({ seed = 1, amp = 6, ampY = 4, rot = 0.6, steps = 8, sustain = 0.25 }) {
  let s = seed * 9301 + 49297;                       // seeded LCG - no Math.random()
  const rnd = () => ((s = (s * 9301 + 49297) % 233280) / 233280) * 2 - 1;
  return Array.from({ length: steps }, (_, i) => {
    const p = i / (steps - 1);
    const env = p < sustain ? 1 : Math.pow(1 - (p - sustain) / (1 - sustain), 2); // power2.out
    return { x: rnd() * amp * env, y: rnd() * ampY * env, rotation: rnd() * rot * env };
  });
}

const T = 12.4;                 // composition seconds
const LEG = 0.0625;             // 8 Hz -> 2 legs per cycle -> ~2 frames per leg @30fps
shakeLegs({ seed: 3 }).forEach((v, i) => {
  tl.to("#panic-word-inner", { ...v, duration: LEG, ease: "none" }, T + i * LEG);
});
tl.to("#panic-word-inner", { x: 0, y: 0, rotation: 0, duration: LEG, ease: "power2.out" },
     T + 8 * LEG);              // guaranteed rest, 0.5625s after T
```

Contract points that bind this:
- **Shake an inner wrapper, not the clip.** The framework owns clip visibility and layout; root-level clips are forced to `position: absolute; inset: 0`. Put a `<div>` inside the clip and shake that.
- **`x` / `y` / `rotation` only.** `width`/`height`/`top`/`left` tweens are forbidden.
- **No CSS `transform` on the shaken element** — a CSS initial transform plus a GSAP tween on the same property is lint error `gsap_css_transform_conflict`. Set the resting pose with a zero-duration `tl.set()` if you need one.
- **No CSS `transition`** on the element; it interpolates independently of seek and flickers.
- **Land at rest before `data-duration`.** The visibility window is half-open `[start, start+duration)`, so the final frame is never rendered — if the rest state lands *on* `data-duration`, the last thing the viewer sees is an off-centre element.
- **No `repeat: -1`.** A sustained "vibrating" element must be a finite count.
- For a whole-frame shake, the shaken wrapper must be a **host-root sibling** of the scenes or contain them: a sub-composition timeline *cannot* animate host-root elements. Overflow will show the page background, so give the shaken wrapper a slight base `scale: 1.03` headroom (set once via `tl.set`, in the same tween namespace as the shake to avoid the CSS-transform conflict).
- Related named animation rules exist and may be cited but not quoted: `nudge-curve`, `kinetic-beat-slam`, `chromatic-glitch`, `physics-press-reaction`.

**ffmpeg — only if the shake must be baked into a file** (e.g. the shaken source is B-roll leaving the pipeline). A deterministic sinusoidal shake with decay, no random:

```bash
# 8 Hz shake, ±6 px, decaying over 0.3s starting at t=12.4s, on a 1080p source
ffmpeg -i in.mp4 -vf "scale=1976:1112,crop=1920:1080:\
x='28+if(between(t,12.4,12.7), 6*sin(2*PI*8*(t-12.4))*pow(1-(t-12.4)/0.3,2), 0)':\
y='16+if(between(t,12.4,12.7), 4*sin(2*PI*8*(t-12.4)+1.7)*pow(1-(t-12.4)/0.3,2), 0)'" out.mp4
```
The `scale` up front is the overscan headroom; without it the crop walks off the edge.

**Epidemic Sound.** A shake with no transient is the single most common way this looks wrong.
- Impact/knock: `SearchSoundEffects { query: { term: "impact hit short" }, filter: { tagSlugs: { matchType: "ANY", values: ["designed--boom"] }, duration: { max: 2000 } } }` — the `designed--boom` library runs 2.8–3.5 s, so trim with `data-media-start` and a hard `data-duration`.
- Diegetic phone buzz: search term `"phone vibrate table buzz"`, no design tag.
- Cartoon register: see [[sfx-cartoon-comedy-family]].
Place at the shake's first frame, `data-volume` ≈ 0.25–0.4 (−12 to −15 dB region), on `data-audio-group="sfx"`.

**Remotion:** a `useCurrentFrame()`-driven sine with a decay envelope is the natural equivalent, and it is deterministic by construction — concept only; Remotion is not a runtime here.

## Pairs with
[[motion-camera-shake-impact]] · [[motion-format-promise-motion-budget]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-cartoon-comedy-family]] · [[motion-sound-bound-motion-event]] · [[motion-anticipation-build-to-reveal]] · [[pace-deliberate-continuity-break]]

## Failure modes
- **Frequency too high.** Above 10 Hz at 30 fps the reversal lands inside 1.5 frames, and the render shows flicker rather than movement — and the encoder spends bitrate on it, softening the whole shot. Correction: 8 Hz default, 10 Hz ceiling.
- **No decay.** A constant-amplitude shake that stops dead reads as a broken keyframe. Correction: 25% sustain, then a `power2.out` amplitude envelope to exactly zero.
- **Shaking without sound.** The brain expects a transient for a violent movement; without one the shake reads as a rendering fault. Correction: one impact or diegetic sound at the first frame — see [[motion-sound-bound-motion-event]].
- **Shaking the clip element.** Fights the framework's layout ownership and trips `gsap_css_transform_conflict` if any CSS transform is present. Correction: shake an inner wrapper.
- **Edges pulling in on a full-frame shake.** Correction: base `scale: 1.03`+ overscan, or `scale: 1 + 2 × amplitude / frame_height`.
- **Same seed on siblings.** Two words shaking identically look welded together. Correction: seed from index.
- **Applied as generic energy.** This is the source's own objection. If the shake is not caused by something in the words or the picture, cut it.
- **Known gap — accessibility.** Vestibular guidance (`prefers-reduced-motion`, WCAG 2.3.3) is written for interactive documents, and **a rendered MP4 cannot honour a user motion preference**: there is no per-viewer variant. The only available mitigations are staying under the WCAG 2.3.1 flash thresholds, keeping amplitude small relative to frame height, and keeping duration short. If the deliverable is a web artefact rather than a video, author a reduced-motion variant; if it is an MP4, record the limitation in the design document rather than pretending it is handled.
- **Known gap — no wiggle primitive.** There is no `data-` attribute, GSAP plugin or documented rule recipe in this stack that produces a wiggle; the baked-legs pattern above is authored from primitives the contract does confirm. Do not substitute an AE expression.
