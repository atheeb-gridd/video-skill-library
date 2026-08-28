---
id: motion-number-rollup-stat-reveal
title: The number roll-up — count to the value, land it on the word
skill: motion
type: graphic
family: data-in-motion
tags: [skill/motion, type/graphic, family/data-in-motion, engine/hyperframes, engine/ffmpeg, engine/epidemic, engine/remotion, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:04:16"
    quote: "Any attempt to use A-roll or regular B-roll in that moment would have been either too slow or horribly confusing, and either one would have cost viewers. But an animation explained it crystal clear and fast."
research_refs:
  - https://www.nngroup.com/articles/animation-duration/
  - https://en.wikipedia.org/wiki/Words_per_minute
  - https://gsap.com/resources/getting-started/Staggers/
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/360051554394-Timed-Text-Style-Guide-Subtitle-Timing-Guidelines
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: video
---

# The number roll-up — count to the value, land it on the word

## What it is
A quantity arrives by **counting to itself** instead of appearing: the digits interpolate from a start value to the target over 0.5–1.5 s while the type takes a small scale pop, and the count **stops on the frame the narration says the number**. It is the fastest way to make a statistic feel like an event rather than a caption, and it is the `VALUE` stage of an information build ([[motion-progressive-information-build]]) — but it is worth its own spec because everything that makes it look cheap is a detail: the settle frame, the digit-box jitter, the unit suffix, and the accompanying bar.

Two mechanisms, and they are not interchangeable. **Interpolated count**: tween a plain number and write the formatted string every frame — right for large, unrounded quantities (revenue, views, milliseconds). **Odometer roll**: each digit column is a vertical strip of 0–9 that translates through its window in `steps()`, staggered right-to-left — right for small tallies and for a mechanical, deliberately-discrete register. The contract names both shapes as existing animation rules: `counting-dynamic-scale` and `vertical-spring-ticker`.

## When to use it
- The beat's payload **is** a number, and the narration says it out loud. If the voice does not say the number, animate nothing — put it up statically.
- The number is the *verdict* of a comparison or the punchline of a claim ("it went from 400 to 41,000").
- One number at a time. Two counters running together are unreadable — the eye cannot track two changing digit fields, and neither lands.
- Also use it for the **paired bar/fill**: whenever a bar grows, its label must count in lockstep and both must land on the same frame.
- Do **not** use it for identifiers (a year, a version, a phone number, a price the viewer must copy). Counting to `2024` reads as a bug.

## How to recognise it in a reference video
- **Extract at full frame rate across the reveal** (`ffmpeg -vf fps=30`) and read the digits frame by frame. A genuine count shows **monotonic intermediate values**; a fake shows the final value on frame 1 with only a scale/opacity animation.
- **Count the frames from first digit to final value.** 15–45 frames @30fps is the working band; over 45 the count is being watched instead of read.
- **Check the last five frames for a settle.** A decelerating count has shrinking per-frame deltas (ease-out); a linear count has constant deltas and reads mechanical. Overshoot past the target and back is a spring — log it, it is a strong style fingerprint.
- **Look for horizontal jitter in the digit box.** If the number's left edge or the following unit label shifts as digits change, the type is not tabular. This is the single most reliable amateur tell.
- **Check the landing frame against the transcript.** The final value should be reached within **±3 frames of the spoken number's onset**, and never after the word has finished.
- **Check the pop.** A scale bump of ~4–8 % over 5–6 frames on the landing frame is the standard punctuation; look for it in the type's cap height across three frames.
- **Audio.** A rising tick/riser under the count and a short hit or pop on the landing frame is the conventional pairing; silence under a 1 s count is a detectable omission.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `count_duration` | 0.80 s (24 f) | 0.50–1.50 s (15–45 f) | NN/g: 400 ms is the upper limit for *transitional* UI motion; a count is content, so it may exceed that — but 1.5 s is the hard ceiling before it becomes a performance. |
| `count_ease` | `power2.out` | `power1.out`–`power3.out` | Ease-out only. `none` for the mechanical/odometer register. Never `back`/`elastic` on digits. |
| `start_value` | 0 | 0, or `floor(target × 0.6)` | Starting near the target ("38 → 41") reads as a correction, not a count. Start at 0 unless the beat is explicitly a delta. |
| `scale_pop` | 1.06 | 1.03–1.10 | On the landing frame, `1.00 → pop → 1.00`. |
| `pop_duration` | 0.18 s (5 f) | 0.12–0.24 s | Out-and-back; `power2.out` up, `power2.inOut` back. |
| `numerals` | `tabular-nums` | required | `font-variant-numeric: tabular-nums`, or a monospaced face, or a fixed-width box per digit. Non-negotiable. |
| `decimals` | fixed | 0–2 | The decimal count must not change during the count. Format every frame with the same rule. |
| `suffix` | static | — | `%`, `x`, `k`, `$`, unit words appear at t=0 at full opacity and never animate. Only the digits count. |
| `digit_roll_stagger` | `each: 0.05`, `from: "end"` | 0.03–0.08 | Odometer variant: rightmost (fastest) column first. `steps(10)` per revolution. |
| `land_offset` | −0.07 s (−2 f) | −0.15 to 0.00 s | Land just before the spoken number's onset, never after. |
| `bar_sync` | same frame | ±1 f | A paired bar/fill must reach its end on the count's landing frame. |
| `max_simultaneous` | 1 | 1 | One counting number on screen at a time. |
| `post_land_hold` | 1.0 s | 0.6–2.5 s | The settled value must be legible and still. |

## Reproduction prompt

```
Animate the statistic at {{IN}} as a number roll-up landing on the spoken
value at {{WORD_T}}. All authored time is SECONDS; frame counts are @30fps
derived comments.

SETUP. Mark up the value as three separate elements: a static prefix (e.g. $),
a digit span (id #stat-value), and a static suffix (e.g. % / x / "views").
Give the digit span font-variant-numeric: tabular-nums and a fixed min-width
computed for the widest digit string it will hold. Do NOT put a CSS transform
on any element you will tween.

COUNT. Create a proxy object { v: {{FROM}} } and tween it:
tl.to(proxy, { v: {{TO}}, duration: 0.80, ease: "power2.out",
onUpdate: () => { el.textContent = fmt(proxy.v); } }, {{WORD_T}} - 0.87);
where fmt() rounds to a FIXED number of decimals and applies thousands
separators identically on every frame. The count therefore lands at
{{WORD_T}} - 0.07 (2 frames before the word).

POP. On the landing position, scale the whole value wrapper:
tl.to("#stat-wrap", { scale: 1.06, duration: 0.09, ease: "power2.out" }, {{WORD_T}} - 0.07);
tl.to("#stat-wrap", { scale: 1.00, duration: 0.09, ease: "power2.inOut" }, {{WORD_T}} + 0.02);

BAR (if present). tl.fromTo("#stat-bar", { scaleX: 0 }, { scaleX: {{FRACTION}},
duration: 0.80, ease: "power2.out", transformOrigin: "left center" },
{{WORD_T}} - 0.87) so the fill completes on the same frame the digits land.

SOUND. A rising tick or short riser under the count, its tail ending on the
landing frame, and one short hit or pop ON the landing frame at -14 dB
relative to dialogue.

HOLD. Keep the settled value still and fully opaque for at least 1.0s.

ACCEPTANCE TEST: extract frames at 30fps from {{WORD_T}} - 1.0 to
{{WORD_T}} + 1.2. The digit string must change monotonically, must reach
{{TO}} within 3 frames of {{WORD_T}}, must never overshoot past {{TO}}, and
the left edge of the digit span must not move by more than 1px at any point.
```

## Execution spec

**HyperFrames.** The count is a GSAP tween on a plain JS object with an `onUpdate` that writes `textContent`.

```js
const el = document.querySelector("#stat-value");
const proxy = { v: 0 };
const fmt = (n) => Math.round(n).toLocaleString("en-US");   // fixed rule, every frame

tl.to(proxy, {
  v: 41000, duration: 0.8, ease: "power2.out",
  onUpdate: () => { el.textContent = fmt(proxy.v); }
}, 12.03);
```

Why this is seek-safe, and why it matters here: `onUpdate` is a **pure function of the tween's progress**, so a backwards seek or a render-engine jump re-derives the correct string. That is the opposite of the caption pattern in `compositions/captions.html`, where text is written in `onStart` and therefore only correct on forward entry. Anything that writes text on a **timeline callback that fires once** is a render bug waiting to happen; anything that writes it from progress is fine.

Other contract points:
- `toLocaleString` is deterministic given a fixed locale argument — pass the locale explicitly, never rely on the environment's default.
- No `Date.now()`, no unseeded `Math.random()`, no network. The value is a literal in the composition.
- Scale/`scaleX` and `transformOrigin` are legal on the master timeline; `width` tweens are not — a bar grows with `scaleX` and `transformOrigin: "left center"`, never `width`.
- Never tween `display`/`visibility` on a clip element; if the counter needs a hard kill, do it on an inner wrapper.
- Odometer variant: `ease: "steps(10)"` per digit column with `stagger: { each: 0.05, from: "end" }`, each column a `y` tween of `-(digit * cellHeight)`. Keep `items × stagger ≤ ~0.5 s`.
- Video type sizes: a hero number on a full-screen video wants **60 px+**, in-feed **90 px+**, with tracking −0.03 to −0.05 em at display size.

**ffmpeg — verification.**

```bash
# read the digits frame by frame across the landing
ffmpeg -i out.mp4 -ss 11.0 -t 2.2 -vf fps=30 /tmp/n/%03d.png
# optional: crop just the digit box so a diff shows box jitter
ffmpeg -i out.mp4 -ss 11.0 -t 2.2 -vf "crop=520:140:700:470,fps=30" /tmp/nbox/%03d.png
```

**Epidemic Sound.** Landing hit: `SearchSoundEffects` with `filter.tagSlugs { matchType: "ANY", values: ["designed--impact", "cartoon--pop"] }`, `filter.duration { min: 200, max: 1500 }`. Count bed: `["designed--riser"]` with `filter.duration { min: 800, max: 2500 }`, trimmed with `data-media-start` so the riser's end sits on the landing frame ([[sfx-riser-to-music-drop-backtiming]]).

**Remotion.** `interpolate(frame, [start, start+24], [from, to], { easing: Easing.out(Easing.quad) })` and render the formatted string — same purity property. Concept only.

## Pairs with
[[motion-progressive-information-build]] · [[motion-persistent-item-counter]] · [[motion-waveform-playhead-scrub]] · [[motion-attention-transient]] · [[motion-sfx-pass-manifest]] · [[motion-beat-quantised-animation]] · [[sfx-cinematic-hit-emphasis]] · [[struct-demo-before-label]]

## Failure modes
- **Non-tabular digits.** The number visibly wobbles as digit widths change and the suffix dances. Correction: `tabular-nums` plus a fixed min-width on the digit span.
- **Landing after the word.** The voice says "forty-one thousand" and the screen is still at 37,412. Correction: land 2 frames early; the count may finish before the word, never after.
- **Counting too long.** A 3 s count means the viewer watches the animation rather than reading the number. Correction: cap at 1.5 s; if the number is huge, start at a non-zero floor rather than extending time.
- **Two counters at once.** Neither is read. Correction: sequence them at least 1.2 s apart, or animate one and set the other statically.
- **Changing decimal precision mid-count** (`0.7 → 12.44 → 41,000`). Correction: one `fmt()` rule for every frame.
- **Counting an identifier.** A year or version number rolling up reads as a glitch. Correction: static.
- **Writing the digits in `onStart` or a `call()`.** Correct on playback, wrong on seek, and the render engine seeks. Correction: write from `onUpdate` only.
- **Bar and number out of sync.** The fill completes 4 frames before the digits stop and the pair reads as two events. Correction: identical `duration`, identical position, identical ease.
