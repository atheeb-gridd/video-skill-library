---
id: gfx-label-callout-over-footage
title: The label callout — three words that name a thing on live footage, and why it is not a caption
skill: motion
type: graphic
family: graphic-components
tags: [skill/motion, type/graphic, family/graphic-components, engine/hyperframes, engine/ffmpeg, engine/remotion, source/sfx-kt-2, source/editing-kt, source/research, difficulty/low]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "visual — contact sheet, labels over live action"
    quote: "[NOT SPOKEN — observed on screen] Left-aligned labels over live action — 'Low Quality SFX'; elsewhere 'Metal Hit' / 'Wood Hit' stacked as two rows in the same slot."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "visual — contact sheet, annotation"
    quote: "[NOT SPOKEN — observed on screen] A hand-drawn white arrow over B-roll paired with a short all-caps label — 'RECORDING B-ROLL'."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:48"
    quote: "Next, layer a bunch of visual elements over your footage."
research_refs:
  - https://link.springer.com/content/pdf/10.1007/s10648-018-9435-9.pdf
  - https://edtechuvic.ca/wp-content/uploads/sites/11/2022/09/principles-for-reducing-extraneous-processing-in-multimedia-learning-coherence-signaling-redundancy-spatial-contiguity-and-temporal-contiguity-principles.pdf
  - https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
  - https://legibility.info/rules-for-text-in-videos
  - https://tech.ebu.ch/docs/r/r095.pdf
difficulty: low
detectable_from: video
---

# The label callout — three words that name a thing on live footage, and why it is not a caption

## What it is

The smallest component in the library and the one most often built wrong, because it looks like a caption and obeys none of a caption's rules.

A **label callout** is one to three words, set as a noun phrase, that **names the thing currently on screen**. `Low Quality SFX` over a demonstration. `Metal Hit` / `Wood Hit` stacked over two sounds being compared. `RECORDING B-ROLL` beside a hand-drawn arrow. It carries the NAMING payload, and its whole job is to attach a name to a referent the viewer is looking at.

**The three differences from a caption**, and each of them changes a spec:

| | Caption | Label callout |
|---|---|---|
| Source | The spoken words, verbatim | The name of the thing, whether or not it is spoken |
| Timing | The word's timestamp, mandatory | The referent's on-screen window |
| Position | The caption band, fixed for the whole video | Adjacent to its referent, or in a fixed callout slot |
| Grammar | Whatever the speaker said, including verbs | A noun phrase. **No finite verb, ever.** |
| Redundancy | With the audio, by design | With nothing — if the label is a substring of the caption it is a third copy |
| Case | Sentence case, usually | Upper, usually — it is a tag, not a sentence |

The label's licence to duplicate a spoken word is exactly the structural-marker licence: ≤3 words, no verb, co-timed. A label reading `THIS IS A LOW QUALITY SOUND EFFECT` is a caption in a graphic's clothes and fails [[gfx-structure-duplicates-prose-does-not]] on all three tests.

**Adjacency is where the value is.** Spatial contiguity — the label sitting *on* or *beside* the thing it labels rather than in a legend — is meta-analysed at **g = 0.63 across 58 comparisons (n = 2426)** and at a median **d = 1.10** in the reducing-extraneous-processing review. A label in a corner that names something in the centre has thrown most of its benefit away while keeping all of its cost. So the default is adjacency, and a fixed slot is the fallback when the referent moves.

**Two labels stacked is a comparison, and it is the strongest use.** `Metal Hit` above `Wood Hit`, same slot, same treatment, one above the other — that is a two-item comparison built out of the cheapest component in the library, and it works because the parallel form makes the difference between the two the only thing on screen that varies.

## When to use it

- **A demonstration is running and the thing being demonstrated has a name.** The archetypal case: a sound plays, a technique is shown, a setting is changed.
- **The speaker says "this" or "here" and the referent needs a name**, not just a pointer. If it needs a *pointer*, that is an annotation mark ([[gfx-annotation-mark-set]]); if it needs both, the mark points and the label names, and they arrive together.
- **Two things are being compared and both are on screen or in sequence.** Two stacked labels, identical treatment.
- **A term is being introduced over footage** and a full concept card would stop the picture unnecessarily.
- **Not** as a caption. If the content is what the speaker said, it belongs in the caption layer.
- **Not** for an abstract concept with no on-screen referent — that is a concept card ([[motion-abstract-concept-card]]).
- **Not** more than **two concurrent**, and never a third while two are live.
- **Not** longer than a shot. A label that outlives its referent is naming something that has left.

## How to recognise it in a reference video

- **Word count and grammar.** 1–3 words, a noun phrase, no finite verb. Four-plus words or a verb means it is a caption, a statement card, or a mistake.
- **Check the substring test against the caption track.** If the label's words are inside the concurrent caption, it is a third copy of a sentence.
- **Measure the distance from label to referent** as a percentage of frame height. **Under 8 %** ⇒ adjacent, doing its job. **Over 25 %**, or across the frame ⇒ a fixed slot, which is legitimate but weaker; log which.
- **Measure the left edge across several labels.** Identical within 0.5 % of frame width ⇒ a fixed callout slot exists. Three different values ⇒ each was placed by eye.
- **Type step.** A label sits at `s-1` or `s0` — cap height **2.6–3.2 %** of frame height. Larger than `s1` and it is an emphasis mark or a topic card, not a label.
- **Backing.** Over footage there is nearly always a chip plate or a scrim. Sample five points inside the chip on a busy frame: identical RGB ⇒ opaque plate. Absence of any backing over busy footage is a fault signal ([[gfx-plate-and-scrim-ladder]]).
- **Lifetime.** **1.2–2.5 s** is the working band. Under 1.2 s nothing is read; over about 4 s the label has stopped being punctuation and become furniture.
- **Entrance.** 0.30–0.45 s, translate from the nearest frame edge by 1.5–3.7 % of frame height plus `autoAlpha`, `power3.out`. Exit shorter than entrance, or no exit at all — a stack cleared by the next cut is the correct default in a multi-scene composition.
- **Stacked pairs.** If two labels appear together, check that their treatment is identical and their vertical gap is constant. A pair whose two members differ in size or weight is asserting a hierarchy that the comparison does not have.
- **Sound.** A label entrance usually carries one short transient at **−12 to −15 dB**; a *pair* gets **one** sound, not two.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `words` | 2 | 1–3 | Noun phrase. A fourth word is a caption. |
| `finite_verb` | forbidden | — | The grammatical test that separates a label from a clause. |
| `case` | UPPER | upper / title | One value per video. Caps take `+0.02 em` tracking relative to lowercase ([[gfx-weight-and-optical-size]]). |
| `type_step` | `s-1` | `s-1`–`s0` | Cap height 2.6–3.2 % of frame height. |
| `weight` | body cut (700) | 600–800 | Same two cuts as the rest of the project. |
| `placement` | adjacent to referent | adjacent / fixed slot | Adjacency is worth `g = 0.63`; a fixed slot is the fallback when the referent moves. |
| `distance_to_referent` | ≤8 % of frame height | ≤12 % | Beyond this the spatial-contiguity benefit is mostly gone. |
| `fixed_slot` | left margin, graphic band | — | 6 % of frame width from the left; vertical position from the grid's graphic band. |
| `alignment` | left | left | One axis for the whole video. |
| `backing` | chip plate | plate / scrim / none | Chosen by measurement, one rung, from [[gfx-plate-and-scrim-ladder]]. |
| `chip_pad` | 0.25 em / 0.67 em | — | The house plate padding, in `em` so it scales with the type. |
| `chip_radius` | 0.5 em | 0–0.75 em | House value. In `em`, never px. |
| `concurrent_max` | 2 | 1–2 | A third label is a list, and lists have their own component. |
| `stack_gap` | 1.5 u | 1.2–2.2 u | Between two stacked labels. Constant, always. |
| `lifetime` | 1.8 s | 1.2–2.5 s | Under 1.2 s it is not read. Over 4 s it is furniture. |
| `entrance` | 0.40 s, `power3.out` | 0.30–0.50 s | Translate 2.2 u from the nearest frame edge + `autoAlpha`. |
| `exit` | none (cut clears it) | 0–0.30 s | Exits are banned in multi-scene compositions except on the final scene — *"the transition IS the exit."* |
| `pair_stagger` | 0.12 s | 0.08–0.17 s | Two labels arrive as one beat, not two. |
| `offset_from_word` | +0.20 s | −0.30 to +0.50 s | Relative to the spoken name, if it is spoken. |
| `contrast_text` | ≥4.5:1 | ≥4.5:1 | At the worst frame in the label's window, not the mean. |
| `contrast_chip` | ≥3:1 vs footage | ≥3:1 | WCAG 1.4.11 — or the chip's own edge disappears. |
| `sfx` | one transient per group | — | −12 to −15 dB, on the first arrival only. |
| `safe_area` | inside 5 % inset | — | Applies to the whole travel, not the rest pose. |

## Reproduction prompt

```
Build a label callout naming {{THING}} over the shot running {{IN}}..{{OUT}}.

1. WRITE THE LABEL: one to three words, a NOUN PHRASE, no finite verb, upper
   case. It names the thing on screen. It is NOT what the speaker said - if it is
   a substring of the concurrent caption it is a third copy of one sentence and
   must be cut or shortened to a bare name.

2. PLACE IT ADJACENT TO ITS REFERENT, within 8% of frame height of the thing it
   names. Adjacency is the whole value: a label in a corner naming something in
   the centre has thrown away most of its benefit (spatial contiguity, g = 0.63
   over 58 comparisons) and kept all of its cost. Only if the referent MOVES, use
   the project's fixed callout slot: left margin at 6% of frame width, inside the
   grid's graphic band.

3. SIZE IT at type step s-1 (cap height ~2.6% of frame height) in the project's
   body weight, with +0.02em tracking because it is caps. Never larger than s0 -
   above that it stops being a label and starts competing as an emphasis mark.

4. BACK IT. Measure the luminance of the label's box over its window and pick ONE
   rung: chip plate (default over unpredictable footage) or scrim. Chip padding
   0.25em/0.67em, radius 0.5em, both in em so they scale with the type. Verify
   4.5:1 for the text and 3:1 for the chip against the footage AT THE WORST FRAME,
   not the mean. Do not stack a plate and a stroke.

5. ANIMATE ONCE: translate 2.2u from the nearest frame edge plus autoAlpha 0->1,
   0.40s, power3.out, starting at the referent's in-point + 0.15s (or the spoken
   name + 0.20s, whichever exists). Then completely still.

6. IF THERE ARE TWO LABELS (a comparison), stack them in the same slot with a
   constant 1.5u gap, IDENTICAL treatment - same step, same weight, same chip -
   and arrive them as ONE beat with a 0.12s stagger. A pair whose members differ
   in size is asserting a hierarchy the comparison does not have.

7. LIFETIME 1.8s, and never longer than its referent is on screen. Prefer NO exit
   animation - let the next cut clear it.

8. ONE sound on the first arrival, -12 to -15 dB. Not one per label.

ACCEPTANCE TEST:
(a) the label is <= 3 words and contains no finite verb;
(b) it is not a substring of the concurrent caption;
(c) its distance to its referent is <= 8% of frame height, or it sits in the
    declared fixed slot at the same left edge as every other label in the video;
(d) at the brightest and darkest frame of its window, text >= 4.5:1 and chip
    >= 3:1;
(e) at most two labels are live at once;
(f) the whole travel stays inside the 5% graphics safe inset;
(g) downscale the frame to 480px wide - the label is still readable.
```

## Execution spec

**HyperFrames.** A wrapper carrying `data-start` (which clamps both the chip and its text), two absolutely-positioned children, one staggered tween.

```html
<div id="lbl-metal" class="clip" data-start="128.62" data-duration="2.10"
     data-track-index="3" style="position:absolute; inset:0;">
  <div class="chip" id="lbl-metal-chip">
    <span class="t-label">METAL HIT</span>
  </div>
</div>
```

```css
[data-composition-id="gfx"] .chip{
  position:absolute; z-index:40;
  left: calc(6 * var(--w));
  top:  calc(38 * var(--u));
  padding: 0.25em 0.67em;
  border-radius: 0.5em;
  background: var(--ground);
  color: var(--ink);
  box-shadow: 0 4px 15px rgba(0,0,0,.2);      /* separation, NOT contrast */
}
[data-composition-id="gfx"] .t-label{
  font-family: var(--face), sans-serif;
  font-size: var(--s-1);
  font-weight: var(--w-body);
  text-transform: uppercase;
  letter-spacing: calc(var(--track-body) + var(--track-caps-adj));
  white-space: nowrap;
}
```

```js
// 12 frames @30fps = 0.40s. Entrance only; the cut clears it.
tl.fromTo("#lbl-metal-chip",
  { x: -22, autoAlpha: 0 },
  { x: 0, autoAlpha: 1, duration: 0.40, ease: "power3.out" },
  128.77);
```

Contract points:

- **The wrapper carries `data-start`, so it clamps its descendants** — a child cannot be visible while its timed ancestor is hidden. One attribute retires the chip and the text together.
- **A root-level timed clip is auto-`position:absolute; inset:0`**; an untimed wrapper is not and needs its own `position:absolute; inset:0` or it collapses to zero height. Elements **without** `data-start` are skipped by the automatic layout entirely.
- **Layering is CSS `z-index`, not `data-track-index`** — track index is *"display only … not read by the render, and it constrains nothing."* Labels sit in the 40 band, scrims at 10, annotation at 60, captions at 80.
- **`x`, not `left`** — spatial motion uses GSAP transform aliases only; `width`/`height`/`top`/`left` tweens are forbidden.
- **No CSS `transform` on the tweened element.** The `left`/`top` above are static layout, which is fine; a CSS `translateX(-22px)` would raise `gsap_css_transform_conflict` (error), and a lint error switches off the layout and contrast audits entirely.
- **`fromTo`, never `from`** — `from()` writes its start state at construction, before the clip's `data-start` is active, and flashes under non-linear seek.
- **`autoAlpha` on the chip (a non-clip inner element), never `display`/`visibility` on the clip itself.**
- **Land the tween before `data-duration`** — the window is half-open, so the frame at exactly `start + duration` is never rendered.
- **`white-space: nowrap` on a label is safe at ≤3 words and a hazard beyond it** — combined with `overflow:hidden` it clips silently rather than wrapping, which is the exact trap the reference caption implementation carries. The word ceiling is what makes it safe here.
- **A label that legitimately sits in the caption band needs `data-layout-allow-caption-zone`** (element plus descendants, via `closest`). Prefer moving it. Do **not** use `data-layout-allow-overflow`, whose blast radius also suppresses `text-clipping` and `content-cramped-container` for every descendant.
- **Sound:** one short transient on the first arrival, `data-audio-group="sfx"`, −12 to −15 dB, its loudest frame on the label's first visible frame. Rotate files across instances — the same effect repeated is a named sound-design mistake ([[sfx-repetition-variant-rotation]], [[sfx-appearance-transient]]).

**ffmpeg — the audit, and the baked form for a deliverable leaving the pipeline:**

```bash
# worst-frame legibility under the label's box
ffmpeg -ss 128.6 -t 2.1 -i ref.mp4 -vf "crop=iw*0.5:ih*0.06:iw*0.06:ih*0.38,\
signalstats,metadata=print:key=lavfi.signalstats.YAVG" -f null - 2> /tmp/l/y.txt
# baked chip + label
ffmpeg -i base.mp4 -filter_complex \
 "drawbox=x=iw*0.06:y=ih*0.38:w=iw*0.30:h=ih*0.052:color=0x10222b@1:t=fill:\
enable='between(t,128.6,130.7)',\
  drawtext=fontfile=./vendor/Montserrat-Bold.ttf:text='METAL HIT':fontsize=69:\
fontcolor=0xf5f0e0:x=iw*0.075:y=ih*0.392:enable='between(t,128.6,130.7)'" out.mp4
```

**Remotion.** A `<Label text slot />` component inside a `<Sequence>`; the spec transfers unchanged.

## Pairs with
[[gfx-plate-and-scrim-ladder]] · [[gfx-contrast-over-moving-footage]] · [[gfx-annotation-mark-set]] · [[gfx-modular-type-scale]] · [[gfx-weight-and-optical-size]] · [[gfx-structure-duplicates-prose-does-not]] · [[gfx-three-channel-division-of-labour]] · [[motion-overlay-stack-choreography]] · [[motion-annotation-draw-on]] · [[motion-abstract-concept-card]] · [[sub-emphasis-caption-three-words]] · [[sfx-appearance-transient]] · [[struct-name-define-demonstrate]]

## Failure modes
- **A sentence in a label slot.** Four or more words, or a finite verb. It is a caption in the wrong band, and it now competes with the real caption.
- **The label is the caption's words.** A third copy of one sentence, occupying the graphic band.
- **A label across the frame from its referent.** Most of the benefit thrown away, all of the cost kept.
- **Drifting left edges.** Three labels at three different margins reads as carelessness and no single frame looks wrong.
- **No backing over busy footage.** Flickers between legible and illegible as the shot's luminance changes.
- **A plate and a stroke.** The stroke sits between ink and plate and lowers the measured ratio.
- **Three labels at once.** That is a list. Use the list card, which has row rhythm and a current-row signal.
- **A label outliving its referent.** Naming something that has left the frame.
- **A stacked pair with different treatments.** Asserts a hierarchy the comparison does not have.
- **Two sounds for a pair.** One group, one transient.
- **Under 1.2 s.** Not read. The label was spent for nothing.
- **Known gap:** whether a specific creator's labels are adjacent or slotted is measurable from frames, but *why* a given label sits where it does — dodging a face, dodging a UI element, following an off-screen convention — is not recoverable. Log the position and the referent distance; do not infer the rule from one instance.
