---
name: motion-index
description: Browsable map of the MOTION rule library — all 57 notes, grouped by family, with a start-here path. The tag-free route into the library.
type: index
count: 57
---

# MOTION — index

The **57 notes** in `skills/MOTION/rules/` describe everything that *moves inside the frame* once the cut exists: how an element arrives and leaves, how a still is given a camera, how a graphic teaches, how the frame itself reacts to an impact, and how every one of those events binds to a sound.

Motion is designed **after** the edit and **before** the sound pass. That order is not stylistic: motion events are placed against cuts, and the sound pass is derived from the motion manifest, so a motion timeline that changes after the sound is fetched invalidates the fetch.

**How it is organised.** Every note carries a `type/` and a `family/`. `skills/MOTION/SKILL.md` routes by tag query; this page routes by browsing, so a note with a wrong or missing tag is still reachable.

**By `type/`** — `graphic` 19 · `motion` 17 · `transition` 9 · `camera` 6 · `type-motion` 3 · `retention` 2 · `sfx` 1  
**By `difficulty/`** — low 5 · medium 34 · high 18  
**Families** — 31

`graphic` notes are things drawn on screen, `motion` notes are the animation of them, `camera` notes move the whole frame, `type-motion` is animated text that is *not* a caption (captions live in `skills/SUBTITLES/`), and `transition` notes are the animated joins that `skills/EDITING/` hands over.

---

## Start here

Eight notes, in this order.

1. **[[motion-entrance-vocabulary]]** — Nothing appears out of nowhere. Five named entrances with real frame counts — the vocabulary the rest of the library assumes.
2. **[[motion-attention-transient]]** — The floor: the minimum on-screen change that actually registers. Below it you have spent effort and bought nothing.
3. **[[motion-silent-motion-tier]]** — Decide which moves get sound *before* you animate anything. This is the note that stops the sound pass from being guesswork.
4. **[[motion-sound-bound-motion-event]]** — The binding rule between this library and SOUND-DESIGN: every authored motion event carries a sound event at the same timeline position.
5. **[[motion-format-promise-motion-budget]]** — How much motion this format can carry — the subtractive counterweight to everything else in here.
6. **[[motion-image-focal-point-direction]]** — Most beats are stills. This is the most-linked note in the library and the one that stops an image landing unguided.
7. **[[motion-continuity-across-the-seam]]** — The failure that spoils otherwise good motion: animation restarting, stopping or reversing at a boundary.
8. **[[motion-storyboard-motion-spec]]** — Where the motion spec lives before anything is animated — `STORYBOARD.md` as the plan layer.

---

## Notes by family

Families are ordered largest first. `motion-sfx-binding` is the load-bearing one — it is the interface to the sound library, and four notes is the minimum it takes to state it.

### `family/teaching-visual` — 7 notes

Graphics whose only job is to explain — concept cards, timelines, filmstrips, waveforms.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-abstract-concept-card]] | The abstract concept card — dark ground, script title, one accent, one abstract visual | `graphic` | medium |
| [[motion-attribution-label-inset-clip]] | The attribution label — small italic serif, top-left, over a letterboxed inset clip | `graphic` | low |
| [[motion-filmstrip-comparison-strip]] | The filmstrip strip — put the whole cut in one static frame so the match is visible at once | `graphic` | medium |
| [[motion-timeline-overlay-explainer]] | The timeline overlay — run a stylised NLE timeline under the clip you are explaining | `graphic` | high |
| [[motion-two-track-offset-diagram]] | The two-track offset diagram — teach a J or L cut as a stagger between two bars | `graphic` | medium |
| [[motion-type-treatment-matches-content]] | Let the typeface do the semantic work — clean type for a clean cut, eroded chalk for SMASH CUT | `type-motion` | medium |
| [[motion-waveform-teaching-overlay]] | Show the waveform — teach an audio edit by putting the shape on screen | `motion` | medium |

### `family/image-treatment` — 5 notes

Making a still direct the eye — focal point, spotlight, glow, colour verdict.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-colour-shift-connotation]] | Push the image's colour to load it with a verdict — red negative, yellow-green positive | `graphic` | medium |
| [[motion-image-focal-point-direction]] | Never drop a whole image on screen unguided — name its focal point | `graphic` | medium |
| [[motion-key-region-animate-in]] | Animate in the key region — lift the one line or area that matters out of the image | `graphic` | medium |
| [[motion-spotlight-mask-reveal]] | Darken and blur the surround — the animated spotlight on an image's focal point | `graphic` | medium |
| [[motion-subject-glow-separation]] | Make the subject glow — separate the focal point with light, not with contrast | `graphic` | high |

### `family/fade` — 4 notes

Transitions through a solid colour field, and the gamma trap in the middle of every one.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-bookend-transition-map]] | The transition map — distinctive at the head, slowest at the tail, empty frames only at boundaries | `transition` | medium |
| [[motion-colour-dip-transition]] | The colour dip — fade through a solid field, and the gamma trap in the middle of it | `transition` | medium |
| [[motion-fade-to-black-ramp]] | The fade-to-black ramp — curve, hold, and the mid-fade gamma trap | `transition` | low |
| [[motion-white-bloom-through]] | Bloom through white, don't dissolve to it — the dream and death transition | `transition` | medium |

### `family/motion-sfx-binding` — 4 notes

The contract between a motion event and its sound — manifest, tiering, abstract-object sound.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-abstract-object-sound-contract]] | An abstract graphic has no natural sound — so its motion must specify one | `motion` | medium |
| [[motion-sfx-pass-manifest]] | Derive the sound pass from the motion timeline — the motion-event manifest | `sfx` | high |
| [[motion-silent-motion-tier]] | Tier every motion event — sounded, covered, or deliberately silent | `motion` | medium |
| [[motion-sound-bound-motion-event]] | Every authored motion event carries a sound event at the same timeline position | `motion` | medium |

### `family/entrance` — 3 notes

How an element arrives — the five entrances, the instant appearance, the travelling reveal.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-entrance-vocabulary]] | Nothing appears out of nowhere — the five entrances and the numbers that motivate them | `motion` | medium |
| [[motion-instant-appearance-sfx-justified]] | Let it appear on one frame and let the sound explain how it got there | `motion` | low |
| [[motion-travel-reveal-streak]] | The travelling reveal — an element crosses frame with a directional streak, cut to the whoosh | `motion` | medium |

### `family/b-roll` — 2 notes

Filling the B-roll slot with motion graphics, and choosing the tier before building.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-broll-slot-tier-selection]] | Pick the B-roll tier before you build — shot, stock, or motion graphic | `graphic` | medium |
| [[motion-graphics-broll-slot]] | Motion graphics fill the B-roll slot when the beat is important but boring | `graphic` | high |

### `family/covered-cut` — 2 notes

Hiding the seam behind blur or light rather than behind geometry.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-light-leak-overlay-transition]] | Light leak and film burn — cover the seam with an additive overlay, not geometry | `transition` | medium |
| [[motion-whip-pan-transition]] | Whip pan — a directional blur-covered seam matched to the shot's own motion | `transition` | high |

### `family/data-in-motion` — 2 notes

Animating numbers and waveforms so the value lands on the spoken word.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-number-rollup-stat-reveal]] | The number roll-up — count to the value, land it on the word | `graphic` | medium |
| [[motion-waveform-playhead-scrub]] | The waveform readout — pre-baked peaks, a playhead driven by timeline time, a marker on the transient | `graphic` | high |

### `family/explainer-graphics` — 2 notes

Building information one stage at a time, on the beats that are necessary but dull.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-explainer-beat-animation]] | Animate the beat that is necessary but boring — the information build | `motion` | high |
| [[motion-progressive-information-build]] | The information build — one idea per stage, held long enough to read | `graphic` | high |

### `family/list-spine` — 2 notes

On-screen list markers and the counter that advances them.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-list-item-marker-card]] | Mark every list item twice — spoken ordinal plus an identical on-screen card | `graphic` | low |
| [[motion-persistent-item-counter]] | The persistent item counter, and the digit swap that advances it | `graphic` | medium |

### `family/match-cut` — 2 notes

Landing a graphic or velocity match — the alignment transform and its tolerances.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-graphic-match-alignment-transform]] | Landing a graphic match — the alignment transform, its tolerances and its budget | `transition` | high |
| [[motion-velocity-matched-transition]] | Velocity-matched handoff — measure the outgoing vector, then leave at the same speed | `transition` | high |

### `family/shake` — 2 notes

Decaying frame kicks on impact, and shake keyframes on individual elements.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-camera-shake-impact]] | Impact shake — one decaying kick of the whole frame, on the hit frame | `camera` | high |
| [[motion-shake-keyframes]] | Shake keyframes on an image, a text block or the whole frame | `motion` | high |

### `family/still-image-motion` — 2 notes

Giving a still its own camera — drift, and cut-into-depth parallax.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-parallax-depth-move]] | The perspective move — cut a still into depth planes and fly a camera through it | `camera` | high |
| [[motion-still-image-drift]] | Drift a still — the minimum scale/position ramp that stops an image reading as a freeze | `camera` | low |

### `family/annotation` — 1 note

Draw-on circles, arrows and underlines.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-annotation-draw-on]] | Circles, arrows and underlines — the draw-on annotation spec | `graphic` | medium |

### `family/attention-mechanics` — 1 note

The minimum on-screen change that actually registers as change.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-attention-transient]] | The attention transient — the minimum on-screen change that actually registers | `motion` | medium |

### `family/continuity` — 1 note

Never letting animation restart, stop or reverse at a boundary.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-continuity-across-the-seam]] | Motion continuity — never let animation restart, stop or reverse at a boundary | `motion` | high |

### `family/dissolve` — 1 note

The dissolve expressed as an opacity curve, with its mid-point dip.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-dissolve-opacity-curve]] | The dissolve as a motion spec — the opacity curve, the mid-dissolve dip, and the montage cadence | `transition` | medium |

### `family/look-pipeline` — 1 note

The ambient particle layer, its blend mode and its determinism trap.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-particle-ambient-layer]] | The ambient particle layer — density, drift, blend mode, and the determinism trap | `motion` | medium |

### `family/motion-sfx` — 1 note

Whoosh-bound entrances and traverses — where the air actually goes.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-whoosh-bound-entrance-and-traverse]] | Whoosh-bound motion — title entrances and objects crossing frame, and where the air actually goes | `motion` | medium |

### `family/music-sync` — 1 note

Quantising motion to the beat grid so the resolve lands on the beat.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-beat-quantised-animation]] | Quantise motion to the beat grid — land the resolve on the beat, not the start | `motion` | high |

### `family/outro` — 1 note

The closing thesis staged as a full-screen type card.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-closing-thesis-title-card]] | Stage the closing thesis as a full-screen type card — one line, one swell, then air | `type-motion` | medium |

### `family/overlay-stack` — 1 note

Z-order bands, safe area and staggered arrival over live footage.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-overlay-stack-choreography]] | The overlay stack — z-order bands, safe area, and staggered arrival over live footage | `graphic` | medium |

### `family/pattern-interrupt` — 1 note

Breaking your own motion grammar on purpose — exactly one parameter, hard.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-pattern-interrupt-jolt]] | Break your own motion grammar on purpose — violate exactly one parameter, hard | `retention` | high |

### `family/pre-production` — 1 note

Specifying motion in `STORYBOARD.md` before anything is animated.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-storyboard-motion-spec]] | Spec the motion before you animate — STORYBOARD.md as the motion plan layer | `motion` | medium |

### `family/punch-in` — 1 note

The emphasis scale step, and the ladder of push sizes it sits on.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-emphasis-scale-step]] | The emphasis scale step — a ramped push that points, and the ladder it lives on | `camera` | medium |

### `family/retention-contract` — 1 note

Subtracting the motion that interrupts what the viewer came for.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-format-promise-motion-budget]] | Subtract the motion that interrupts what the viewer came for | `retention` | medium |

### `family/riser` — 1 note

Building the picture under a riser and resolving everything on the reveal frame.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-anticipation-build-to-reveal]] | Build the picture under the riser, and resolve everything on the reveal frame | `motion` | high |

### `family/screen-recording` — 1 note

Driving a screen recording — anchored punch-in on the control, pop on the result.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-screen-recording-cursor-punch-in]] | Drive the screen recording — anchored punch-in on the control, pop on the result | `camera` | medium |

### `family/snap` — 1 note

The 3–6 frame snap zoom, and the whip that lands on it.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-snap-zoom-punch]] | The snap zoom — a 3–6 frame scale jump, and the whip that lands on it | `camera` | medium |

### `family/sync-placement` — 1 note

Finding the impact frame, then quantising the motion to the frame grid.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-impact-frame-quantisation]] | Find the impact frame, then quantise the motion to the frame grid | `motion` | high |

### `family/title-card` — 1 note

The one-word topic card, landed on its own beat.

| id | title | type | difficulty |
|---|---|---|---|
| [[motion-single-word-topic-card]] | The one-word topic card — land the subject as a single word on its own beat | `type-motion` | medium |

---

## Also see

- `skills/MOTION/SKILL.md` — the router: the two modes, the non-negotiables, and the tag queries.
- `INDEX.md` — the whole-vault map.
- `_meta/execution-contract.md` §3.7–3.10 — motion is JavaScript, not data attributes; §4 is the transition registry.
- Cross-skill: `skills/EDITING/INDEX.md` for the timeline the motion attaches to, `skills/SOUND-DESIGN/INDEX.md` (style `sfx/motion`) for what every motion event sounds like.
