---
id: sub-per-word-pop-scale-colour
title: Per-word pop — one property, four frames, and a scale step that does not reflow the line
skill: subtitles
type: caption-motion
family: kinetic-type
tags: [skill/subtitles, type/caption-motion, family/kinetic-type, engine/hyperframes, source/hyperframes, source/editing-kt, source/research, difficulty/high]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "For per-word rather than per-line captions, the mechanism is the `per-word kinetic typography` technique with `timings` taken from the same transcript array, plus the `asr-keyword-glow` rule for keyword emphasis synced to ASR timestamps."
  - video: "assets/videos/editing kt.mp4"
    timestamp: n/a
    quote: "Red strikethrough as the signature rhetorical device: struck-through or red-overlaid text = a claim being negated. Consistent enough to be a caption rule, not a one-off."
research_refs:
  - https://www.nngroup.com/articles/animation-duration/
  - https://aegisub.org/docs/latest/ass_tags/
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
  - https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html
difficulty: high
detectable_from: video
---

# Per-word pop — one property, four frames, and a scale step that does not reflow the line

## What it is

The per-word treatment is the transition a single word makes when it becomes active: it changes colour, or steps up in scale, or gains a plate, or all three. [[sub-active-word-treatment-palette]] decides *which* property carries "active". This note specifies **the transition itself** — how long it takes, what curve it uses, and the geometric constraint that makes the difference between a pop and a jitter.

**The governing constraint is reflow.** A word that scales up inside a line of text pushes its neighbours sideways unless the layout is explicitly prevented from responding. Every word in the line then moves a few pixels on every word transition, and at 3–5 transitions a second the whole line shimmers. The fix is geometric, not aesthetic:

- Scale via **`transform: scale`**, never via `font-size`. Transforms do not participate in layout; font-size does.
- Give each word span a **fixed layout box** — inline-block with the scale applied to an inner element, or absolute positioning inside a pre-measured line — so the transform paints outside the flow.
- Set `transform-origin` to the word's **centre** so the growth is symmetric and the perceived baseline does not shift.
- Cap the scale step at **1.06–1.08**. Even with transforms, a larger step visibly overlaps the neighbouring word at normal letter spacing.

**The transition itself is short.** 3–5 frames (0.10–0.16 s). This is the "immediate" band — around 100 ms an animation reads as direct manipulation rather than as an effect — and it has to be, because the treatment's job is to mark a word that is being spoken *now*, and the word will be gone in a third of a second.

**Only one property may carry the transition.** Colour *and* scale *and* a plate *and* a lift is four simultaneous changes on a 4-frame budget, which reads as a flinch. Pick the carrier; let anything else be a static state difference rather than an animated one.

**Hard swap versus tween, by property.** Colour on the *active* word should be a hard change at the word's onset — a crossfading colour has an ambiguous middle where two words look equally active, which destroys the one signal the treatment exists to give. Scale can tween, because a scaled word is unambiguous throughout its travel.

**Red strikethrough is a per-word treatment with its own timing.** In one reference creator, struck-through or red-overlaid text marks a claim being negated. As motion it is a **draw-on**: the rule sweeps left to right across the word over **4–8 frames** with `power2.out`, landing *after* the word is fully readable — never before, or the viewer reads a struck word without ever having read the word. The rule is a `scaleX` from 0 with `transform-origin: left`, not a width tween. The semantic contract lives in [[sub-red-strikethrough-negation]]; the timing lives here.

## When to use it

- On the active word of any hybrid/karaoke track ([[sub-karaoke-active-word-highlight]]).
- On keyword emphasis inside an otherwise plain track, where the rule that picks the word comes from [[sub-emphasis-selection-rule]] and the density is capped by [[sub-over-emphasis-audit]].
- On a negation, as the strikethrough draw-on.
- **Do not** apply per-word motion inside a fast-cut burst — the picture is already changing at 1–3 Hz.
- **Do not** apply it to a chained word-level track where each cue is one word already; the cue swap *is* the treatment, and adding a pop to every cue is a pop 3–5 times a second.

## How to recognise it in a reference video

- **Transition length.** Extract every frame across five word transitions. The property change completes in **3–5 frames**; anything above 8 frames is a different, softer design and anything at 1 frame is a hard swap.
- **Reflow test — the diagnostic that matters.** Pick a word two positions to the right of the active one and track its left edge, in pixels, across a transition. **Zero movement** means the treatment is transform-based and correctly boxed. Movement of even 2–3 px means the line reflows on every word, and it will read as shimmer at speed.
- **Scale step.** Measure the active word's cap height against its own inactive height in an adjacent frame. **1.00–1.12**; the common value is 1.05–1.08.
- **Baseline shift.** Measure the active word's baseline against the line's baseline. A correct centre-origin scale shifts it by less than half a pixel; a top-origin scale visibly drops it.
- **Colour transition.** Sample the active word's fill on the frame before, the frame of, and the frame after the onset. A hard swap shows two values, no intermediate. A tween shows an intermediate frame where the word is neither colour — and if two adjacent words are both mid-transition on the same frame, the swap is crossfading and is wrong.
- **Strikethrough.** Measure the rule's length as a fraction of the word width per frame. A left-to-right draw over 4–8 frames is a deliberate `scaleX` sweep; an instantly-full rule is a state change.
- **Count the changing properties.** On one transition, check colour, scale, weight, position and background. More than one changing is over-specified.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `transition_duration` | 0.13 s (4 f @30) | 0.10–0.16 s | The "immediate" band; ~100 ms reads as direct. |
| `ease` | `power2.out` | `power1.out`–`power2.out` | Gentle band, as for all caption motion. |
| `carrier_property` | one only | colour / scale / plate | Decided in [[sub-active-word-treatment-palette]]. |
| `scale_step` | 1.06 | 1.00–1.12 | Transform only. Above 1.12 the line visibly collides. |
| `scale_mechanism` | `transform: scale` | — | Never `font-size`; font-size reflows. |
| `transform_origin` | 50 % 50 % | — | Centre, so the baseline does not shift. |
| `layout_box` | fixed per word | — | Inline-block wrapper or pre-measured absolute spans. |
| `reflow_tolerance` | 0 px | 0–1 px | Measured on a word two positions right of the active one. |
| `colour_swap` | hard `set` | set only | A crossfading colour has an ambiguous middle. |
| `y_lift` | 0 px | 0 to −6 px | Optional, transform only, never `top`. |
| `strike_draw` | 0.20 s (6 f) | 0.13–0.27 s | `scaleX` 0→1 from the left, after the word is readable. |
| `strike_delay` | 0.10 s | 0.06–0.20 s | Time between the word being legible and the rule starting. |
| `strike_colour` | accent red | — | Must still clear the contrast floor against the plate. |
| `properties_changing` | 1 | 1 | Two is a design; three is a flinch. |

## Reproduction prompt

```
Author the per-word treatment transition for {{TRACK}} at {{FPS}} fps.

STRUCTURE. Each card is one absolutely-positioned wrapper holding one
<span class="w"> per word. Each span is inline-block with a fixed layout box;
the animated transform goes on an INNER element so the outer box never
changes size. transform-origin is 50% 50%.

ACTIVE TRANSITION at each word's aligned onset:
- colour: a zero-duration set to the accent, and a zero-duration set back to
  the trailing colour at the next word's onset. Never tween colour.
- scale (if scale is the carrier): tween 1.00 -> {{SCALE}} = 1.06 over
  {{DUR}} = 0.13s ease power2.out, and back to 1.00 over 0.10s at the next
  onset.
Change exactly ONE property; anything else is a static state difference
between active, spoken and unspoken words.

STRIKETHROUGH (negation only). Render the rule as a child with
transform-origin left and scaleX 0. {{STRIKE_DELAY}} = 0.10s after the word
is fully legible, tween scaleX 0 -> 1 over {{STRIKE_DUR}} = 0.20s
power2.out. Never draw the rule before the word can be read.

Use fromTo, never from. No CSS transitions, no CSS initial transform on any
tweened element.

ACCEPTANCE TEST: across five transitions, a word two positions right of the
active one does not move a single pixel; the scale step is between 1.00 and
1.12; the colour change occupies exactly one frame with no intermediate
value; exactly one property animates; and no strikethrough is visible before
its word is legible.
```

## Execution spec

The mechanism is the framework's **per-word kinetic typography** technique, with `timings` taken from the same inlined transcript array, and **`asr-keyword-glow`** for keyword emphasis synced to ASR timestamps. The technique file's own example uses a decaying slide distance (80→12 px) to mimic a camera settling — that is a *title* treatment, not a caption treatment; do not import the travel.

```js
// active-word colour: hard swap, both directions
tl.set("#w-0413", { color: "var(--cap-accent)" }, 22.140);
tl.set("#w-0413", { color: "var(--cap-spoken)" }, 22.480);

// active-word scale: transform only, centre origin, inner element
tl.fromTo("#w-0413 .inner", { scale: 1 },
  { scale: 1.06, duration: 0.13, ease: "power2.out" }, 22.140);
tl.to("#w-0413 .inner", { scale: 1, duration: 0.10, ease: "power2.in" }, 22.480);

// negation strike: scaleX draw-on, after the word is readable
tl.fromTo("#w-0416 .strike", { scaleX: 0 },
  { scaleX: 1, duration: 0.20, ease: "power2.out" }, 24.020);
```

Binding contract points:

- **`fromTo`, never `from`** — `from()` sets `immediateRender: true` and writes its start state at construction, before the clip's `data-start` is active, which flashes under seek.
- **No CSS initial `transform`** on any element GSAP tweens: `gsap_css_transform_conflict` is a lint **error**, and a lint error also switches off the layout and contrast audits, so the build then reports `0 sample(s)` and looks clean.
- Spatial motion uses **transform aliases only** (`x`, `y`, `scale`, `rotation`). `width`, `height`, `top` and `left` tweens are forbidden — which is also why the strike is `scaleX`, not a width animation.
- **Never derive positions from `getBoundingClientRect()` at tween time**; compute coordinates once at setup. In a multi-scene montage, do not measure at all — later clips may not be laid out yet — use authored CSS-matched constants.
- Transformed elements must be **block-level and sized**, and `<br>` is banned in body text; build lines as elements, not as line breaks.
- Total stagger for any grouped arrival stays under ~0.5 s so it reads as one beat; per-word treatments are not staggered arrivals and should not borrow that pattern.

**Carrier note.** In ASS, the equivalent of a hard per-word colour swap is `\k` with a primary/secondary colour pair; `\kf` sweeps the fill and is the karaoke-wipe look, not the hard swap specified here. Centisecond rounding on `\k` is over half a frame at 60 fps.

## Pairs with
[[sub-active-word-treatment-palette]] · [[sub-karaoke-active-word-highlight]] · [[sub-red-strikethrough-negation]] · [[sub-emphasis-selection-rule]] · [[sub-over-emphasis-audit]] · [[sub-spring-and-bounce-budget]] · [[sub-entrance-exit-motion-budget]] · [[motion-emphasis-scale-step]] · [[motion-annotation-draw-on]] · [[sfx-envelope-matched-to-easing-curve]]

## Failure modes
- **Scaling with `font-size`.** The line reflows on every word and the whole caption shimmers. The single most common per-word bug. Correction: `transform: scale` on an inner element in a fixed box.
- **Top or left transform origin.** The word appears to drop or drift as it grows. Correction: centre origin.
- **Crossfading the active colour.** Two words look half-active for two frames and the "where is the voice" signal is destroyed. Correction: hard `set`.
- **Animating three properties at once.** Reads as a flinch, not an emphasis. Correction: one carrier.
- **A scale step above ~1.12.** The active word collides with its neighbours even without reflow. Correction: 1.06.
- **Strikethrough drawn on arrival.** The viewer reads a struck word and never reads the claim being negated. Correction: delay the rule until the word is legible.
- **Per-word pop on a chained one-word track.** A pop 3–5 times a second is a strobe. Correction: the cue swap is the treatment.
- **Importing the kinetic-typography slide distance.** 80 px of travel is a title move; on a caption it costs the reading time the cue does not have.
