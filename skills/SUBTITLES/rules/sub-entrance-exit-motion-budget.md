---
id: sub-entrance-exit-motion-budget
title: Captions enter in three to six frames on a gentle ease, and leave faster than they arrive
skill: subtitles
type: caption-motion
family: kinetic-type
tags: [skill/subtitles, type/caption-motion, family/kinetic-type, engine/hyperframes, source/hyperframes, source/research, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "the typography guardrail that caption fades belong to the gentle eases (`power1.out` / `power2.out`, \"NOT the entrance default\")."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "tl.to(box, { opacity: 1, duration: 0.1, ease: \"power2.out\", onStart: ... }, line.start); tl.to(box, { opacity: 0, duration: 0.1, ease: \"power2.in\" }, line.end);"
research_refs:
  - https://www.nngroup.com/articles/animation-duration/
  - https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html
  - https://aegisub.org/docs/latest/ass_tags/
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
difficulty: medium
detectable_from: video
---

# Captions enter in three to six frames on a gentle ease, and leave faster than they arrive

## What it is

Caption motion is not scene motion, and the framework's own typography guardrail says so directly: **caption fades belong to the gentle eases — `power1.out` / `power2.out` — explicitly "NOT the entrance default."** The house entrance ease `power3.out` is for hero reveals and title cards; on a caption it reads as a swoop, and a swooping caption competes with the text it is delivering.

The numbers are short. The reference implementation uses **0.1 s in and 0.1 s out** — three frames at 30 fps — and that is a good default rather than a minimum. The band that works is **3–6 frames in, 2–4 frames out**, with two asymmetries that matter:

- **Exits are shorter than entrances.** The general craft rule is entrances 0.4 s, exits 0.25 s; for captions the same ratio holds at a tenth of the scale. An exit that lingers keeps stale text on screen during the next cue's reading time.
- **Opacity is the property.** Not position, not scale. A caption that slides in has a *travelling* baseline, and the eye cannot begin reading until it stops, which spends the reading time the cue was allocated. If motion beyond opacity is wanted, cap the travel at a few pixels and make sure the type is legible from the first frame.

**Where the motion goes is as important as its length.** In a chained track, only the **first cue after a gap** fades in and only the **last cue before a gap** fades out; every internal handover is a hard `set`. Fading each cue individually is the blink defect in [[sub-inter-cue-gap-and-chaining]], and crossfading them is three frames of double exposure.

There is a lower bound worth naming: below about **2 frames** a fade is not perceived as a fade, it is a cut. That is fine — a hard cut on a caption is a legitimate, punchy choice — but author it as a `set`, not as a 0.05 s tween, so it renders identically at every fps.

**Reduced motion is a real constraint, not a checkbox.** Vestibular guidance is about non-essential movement, and a caption's movement is by definition non-essential — the text is the content, the motion is decoration. The conservative default (opacity only, 3–6 frames) is also the accessible one, which is a rare alignment worth taking.

## When to use it

- On every caption track, as the default motion spec, before any per-word treatment is considered.
- Especially in **fast-cut sequences**, where per-cue motion is stripped entirely ([[sub-fast-cut-sequence-captions]]).
- On the **first and last** cue of the whole track, which usually deserve a slightly longer fade (6–8 frames) because they are entering and leaving nothing rather than another cue.
- **Do not** use scene-level entrance eases (`power3.out`, `back.out`, `elastic.out`) on a caption. That is what [[sub-spring-and-bounce-budget]] is about.
- **Do not** animate position on a full caption track. Reserve travel for single-word topic cards and emphasis moments.

## How to recognise it in a reference video

Everything here is measurable from dense frame extraction — `select='between(n,N1,N2)'` with `-fps_mode passthrough`, never `fps=`.

- **Fade length in frames.** Count the frames between the first frame where any caption pixel is visible and the first frame at full opacity. **3–6 frames** is the normal band; 1–2 frames reads as a cut; above 10 frames the caption is drifting in and eating reading time.
- **Fade curve.** Sample opacity at the midpoint. A `power2.out` fade is already past ~75 % opacity at the halfway frame; a linear fade sits at 50 %. That single measurement separates eased from linear.
- **Exit vs. entrance ratio.** Measure both. A deliberate spec shows exit ≈ 0.6–0.8 × entrance. Equal values usually mean the defaults were never revisited.
- **Travel.** Track the baseline y across the entrance frames. A pure opacity fade shows zero movement; any slide shows up as several pixels of drift and should be measured as a percentage of frame height (anything over ~1.5 % is a real move, not a settle).
- **Where fades occur.** Frame-step three internal cue boundaries. Fades at every boundary mean the track is not chained; fades only at breath-group edges mean it is.
- **First and last cue.** Frequently longer than the internal ones; measure them separately or they skew the distribution.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `fade_in` | 0.10 s (3 f @30) | 0.07–0.20 s | The reference implementation's value. |
| `fade_out` | 0.08 s (2–3 f) | 0.05–0.14 s | Shorter than the entrance, always. |
| `ease_in` | `power2.out` | `power1.out` / `power2.out` | The gentle band. Never `power3.out` on a caption. |
| `ease_out` | `power2.in` | `power1.in` / `power2.in` | Correct direction: accelerate away. |
| `track_open_fade` | 0.20 s | 0.14–0.30 s | First cue of the whole track. |
| `track_close_fade` | 0.25 s | 0.16–0.40 s | Last cue; the one place a caption may linger. |
| `internal_handover` | hard `set` | set only | No fade between chained cues. |
| `cut_threshold` | 2 frames | — | Below this, author a `set`, not a short tween. |
| `travel_max` | 0 px | 0–1.5 % frame height | Opacity-only by default. |
| `property` | `autoAlpha` | — | GSAP's opacity+visibility alias; never raw `display`/`visibility` on a clip. |
| `blur_on_entry` | off | off | A blurred caption is an unreadable caption for its first frames. |
| `reduced_motion_fallback` | same spec | — | The default is already conservative; nothing to strip. |

## Reproduction prompt

```
Specify and author caption entrance and exit motion for {{PROJECT}} at
{{FPS}} fps.

- Animate opacity only. No slide, scale, blur or rotation on the caption
  track. If the design calls for travel, cap it at 1.5% of frame height and
  keep the type legible from the first visible frame.
- Entrance {{FADE_IN}} = 0.10s, ease power2.out. Exit {{FADE_OUT}} = 0.08s,
  ease power2.in. Never power3.out, back, elastic or bounce - those are scene
  entrance eases and read as a swoop on a caption.
- Apply the entrance ONLY to the first cue after a gap and the exit ONLY to
  the last cue before a gap. Every chained handover is a zero-duration set on
  a non-clip element, with no crossfade.
- The first cue of the track fades in over {{OPEN}} = 0.20s; the last fades
  out over {{CLOSE}} = 0.25s.
- If the intended fade is under 2 frames, author a set, not a short tween, so
  it renders identically at any fps.
- Use fromTo, never from. No CSS transitions. Land every tween strictly
  before the clip's data-duration - the visibility window is half-open.

ACCEPTANCE TEST: every sampled entrance shows 3-6 frames of fade with the
midpoint frame already above 70% opacity; the exit is measurably shorter than
the entrance; no frame shows two cue texts at once; the baseline does not
move more than 1px during any entrance; and no caption tween uses an ease
outside the power1/power2 families.
```

## Execution spec

The reference cycle, which is the exact shape to copy for a phrase track:

```js
tl.set(box, { visibility: "visible" }, line.start);
tl.to(box, { opacity: 1, duration: 0.1, ease: "power2.out",
             onStart: () => { textEl.textContent = line.text; } }, line.start);
tl.to(box, { opacity: 0, duration: 0.1, ease: "power2.in" }, line.end);
tl.set(box, { opacity: 0, visibility: "hidden" }, line.end + 0.1);
```

Binding contract points:

- The trailing hard kill is the documented explicit-boundary `visibility` exception, and it is legal **only because `#caption-box` is not the clip element** — the clip is the sub-comp host. Never write `display` or raw `visibility` on a `.clip`; the framework owns clip visibility and lint rejects it. Use `autoAlpha` on inner wrappers.
- **No CSS `transition` on the caption element.** CSS transitions interpolate independently of seek and flicker under the render engine's non-linear seeking.
- **Use `fromTo`, never `from`.** `gsap.from()` sets `immediateRender: true`, which writes the "from" state at construction time — before the clip's `data-start` is active — and under seek the element flashes or skips its entrance.
- **No CSS initial `transform` on an element you tween with GSAP** — that is `gsap_css_transform_conflict`, a lint error. If a caption does travel, express the offset in the `fromTo`, not in the stylesheet.
- **Ambient motion must attach to the seekable `tl`.** A bare `gsap.to()` runs on wallclock and is simply absent from the render.
- The third argument to `tl.to()` is an **absolute position in composition seconds**, not a delay — and inside a sub-comp it is scene-local time.

**Carrier note.** If the track is exported as ASS for burn-in, the equivalent is `\fad(100,80)` — milliseconds, in and out. There is no ease control there; libass fades linearly, which is a visible difference from `power2.out` at these durations and is one more reason to prefer rendering the composition.

## Pairs with
[[sub-inter-cue-gap-and-chaining]] · [[sub-per-word-pop-scale-colour]] · [[sub-spring-and-bounce-budget]] · [[sub-fast-cut-sequence-captions]] · [[sub-cue-duration-floor-and-ceiling]] · [[sub-sidecar-timing-fidelity]] · [[motion-entrance-vocabulary]] · [[motion-dissolve-opacity-curve]] · [[motion-silent-motion-tier]]

## Failure modes
- **`power3.out` on a caption.** The house entrance ease, explicitly wrong here; it reads as a swoop and draws attention to the animation rather than the words.
- **Sliding captions in.** The baseline travels, so reading cannot start until it stops, and the cue's effective display time shrinks by the entrance duration. Correction: opacity only.
- **Fading every cue.** Produces the blink at every internal boundary. Correction: fade at gaps only.
- **A 0.05 s tween instead of a set.** Renders as 1 frame at 30 fps and 3 at 60, so the look changes with the render flag. Correction: `set`.
- **`gsap.from()` for the entrance.** Writes the from-state at construction and flashes under seek. Correction: `fromTo`.
- **CSS `transition` on the caption box.** Interpolates outside the timeline and flickers. Correction: all motion on the timeline.
- **A fade that lands exactly on `data-duration`.** Half-open window; the final frame never renders. Correction: land it before.
- **Blur or scale on entry.** The first frames are unreadable, which is precisely the reading time the cue is short of. Correction: legible from frame one.
