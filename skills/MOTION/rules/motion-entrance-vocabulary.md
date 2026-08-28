---
id: motion-entrance-vocabulary
title: Nothing appears out of nowhere — the five entrances and the numbers that motivate them
skill: motion
type: motion
family: entrance
tags: [skill/motion, type/motion, family/entrance, engine/hyperframes, engine/epidemic, engine/remotion, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:03"
    quote: "Any time a graphic shows up on screen, it can't just appear out of nowhere."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:07"
    quote: "That doesn't make sense. It has to get into the frame somehow."
research_refs:
  - https://carbondesignsystem.com/elements/motion/overview/
  - https://www.nngroup.com/articles/animation-duration/
  - https://en.wikipedia.org/wiki/Twelve_basic_principles_of_animation
  - https://en.wikipedia.org/wiki/Optical_flow
difficulty: medium
detectable_from: video
---

# Nothing appears out of nowhere — the five entrances and the numbers that motivate them

## What it is
A hard rule with a small vocabulary attached. Every element that becomes visible — a title, a lower third, a card, an icon, an arrow, a stat, a bracket — must **travel, grow, be uncovered or resolve into focus**. An element whose first visible frame is already at its final position, final scale and full opacity is a **pop**, and a pop is the rough edge the source's continuity pillar exists to remove. The source demonstrates its entrances visually and points at a preset pack rather than naming them; this note is that pack written out as five families with durations, easings and travel distances.

The stack already encodes half of the rule: *"Every scene uses entrance animations"* via `gsap.fromTo()`, and *"exit animations are BANNED except on the final scene — the transition IS the exit."* So an element enters once, deliberately, and leaves by being transitioned or cut away from. There is exactly one licensed way to appear on a single frame: [[motion-instant-appearance-sfx-justified]], where a transient sound does the justifying instead of the picture.

**The five families**

| Family | The move | Default duration | Ease | Reads as |
|---|---|---|---|---|
| **Travel-in** | `x`/`y` from an offset or off-frame edge → 0, with opacity | 0.40 s (12 f) | `power3.out` | arrived from somewhere |
| **Scale-in** | `scale` 0.92 → 1.00 (or 0.80 → 1.00), with opacity | 0.35 s (10 f) | `power3.out` | grew into place |
| **Mask reveal** | `clip-path` inset/polygon opens along one axis | 0.50 s (15 f) | `power2.inOut` | was uncovered |
| **Blur-in** | `filter: blur(10px) → blur(0)` with opacity | 0.45 s (13 f) | `power2.out` | came into focus |
| **Build (staggered group)** | any of the above across siblings | 0.35 s each, `stagger.each 0.06` | `power3.out` | assembled, in one beat |

## When to use it
- **Every graphic, every time.** This is a gate, not an option: before rendering, every timed element must have an entrance, an instant-appearance sound, or a documented reason it is already on screen when the scene opens.
- **Pick the family from the content, not from taste.** Travel-in for anything with a spatial home (lower thirds, side panels, arrows pointing at a thing). Scale-in for anything that belongs *at* a point (a badge on a face, a marker on a chart). Mask reveal for type and for anything that reads left-to-right — the wipe direction should follow the reading order. Blur-in for photographic content and for anything that would look mechanical sliding. Build for lists, grids and any set of siblings arriving together.
- **Two or three families for the whole video**, repeated — the same budget the transition registry sets for transitions (*"Pick 2-3 types for the whole video and repeat them — repetition is what reads as professional"*). A video with eight entrance styles reads as a template dump.
- **Not** on an element that is already on screen at a scene boundary — re-entering a persistent element is a continuity fault ([[motion-continuity-across-the-seam]]).
- **Not** as a licence to animate everything: the entrance budget is spent on elements the viewer must notice ([[motion-format-promise-motion-budget]]).

## How to recognise it in a reference video
- **Find the first visible frame of each graphic** (step at 30 fps through the shot). Then measure the element's position, scale, opacity and edge sharpness on that frame versus 12 frames later. **All four identical = a pop.** Log pops; they are the defect.
- **Count the frames from first visible to settled.** Working band is **8–18 frames (0.27–0.60 s)**. Under 6 frames the entrance is a flicker; over 24 the graphic is late to its own line.
- **Read the ease off the per-frame deltas.** Front-loaded and decaying = an out-ease (correct). Symmetric = an inOut, normal for mask wipes. Deltas that overshoot the resting value and come back = a spring — note it, and check it is a genuinely playful video.
- **Measure travel distance.** Convert to % of frame width. **3–8 %** for a nudge, **10–20 %** for a substantial arrival, **>50 %** means it came from off-frame. Distance and duration should move together: a 3 % nudge over 0.6 s reads sluggish, an off-frame slide in 0.15 s reads like a glitch.
- **Check direction is motivated.** The element should enter from the edge nearest its resting place, or from the thing it belongs to. An element crossing the whole frame to reach a corner is unmotivated travel.
- **Stagger measurement.** For a group, measure the gap between successive first-visible frames: **0.04–0.10 s (1–3 f)** each, and a **total under 0.5 s** for the group regardless of item count.
- **Opacity vs transform split.** On careful work the opacity ramp finishes *before* the transform settles (opacity ~0.25 s, transform ~0.4 s). A single combined tween is fine but flatter; a spring applied to opacity is a fault.
- **Audio corroboration.** Most entrances carry a short air or tick within ±1 frame of the start ([[motion-sound-bound-motion-event]]). A silent entrance in an otherwise sounded video is a miss.
- **Exit check.** Elements should leave by cut or transition. A fade-out in the middle of a video is the banned exit pattern and is worth logging as a fault in the reference.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `duration_entrance` | 0.40 s (12 f) | 0.27–0.60 s (8–18 f) | Entrances get longer than exits (0.4 in / 0.25 out). NN/g: 100–500 ms, 500 ms is where motion "starts to feel like a drag". |
| `duration_by_distance` | see notes | — | <5 % frame travel → 0.25–0.30 s · 5–15 % → 0.35–0.40 s · >15 % or off-frame → 0.45–0.60 s. Carbon: *"the larger the change in distance or size, the longer the animation takes."* |
| `travel_distance` | 6 % of frame width (115 px @1920) | 3–20 % · off-frame for whips | Small distance + out-ease reads confident; long travel needs the longer duration. |
| `ease` | `power3.out` | `power2.out`–`power4.out`; `power2.inOut` for masks | House default. `back.out(1.7)` / `elastic` are an explicitly-playful register only — *"smooth beats bouncy."* |
| `scale_from` | 0.92 | 0.80–0.96 | Below 0.8 the element reads as flying in from depth; pair with blur if so. |
| `blur_from` | 10 px @1920 (0.5 % frame width) | 6–16 px | Scale it with resolution or it renders wrong at 4K. |
| `opacity_ramp` | 0.25 s `power2.out` | 0.15–0.30 s | Separate tween at the same position; never put an overshooting ease on opacity. |
| `stagger_each` | 0.06 s | 0.04–0.10 s | Hard cap from the rules contract: `items × stagger ≤ ~0.5 s`. |
| `stagger_from` | importance order | `"start"`, `"edges"`, `"center"`, index | *"Stagger in order of importance, not DOM order."* |
| `entrance_families_per_video` | 2 | 2–3 | Same budget as transitions. |
| `first_offset` | 0.1–0.3 s after the clip opens | — | *"Don't start at t=0."* |
| `read_time_before_next` | 0.8 s | 0.6–2.0 s | The element must be still and readable before anything else moves. |
| `sfx` | short air/tick, −13 dB | −12 to −15 dB | One sound per arrival, including for a staggered group. |

## Reproduction prompt

```
Give every graphic in {{COMPOSITION}} a motivated entrance. No element may be
at its final position, final scale and full opacity on its first visible frame.

1. INVENTORY. List every timed element (every [data-start] that is not the
   base video or an audio track) with: its clip's data-start, its resting
   position, its size as a % of frame, and the word in the transcript it
   belongs to.

2. CLASSIFY each into one family, and use at most TWO families in the file:
     spatial home (lower third, side panel, arrow)  -> travel-in
     belongs at a point (badge, marker, pin)        -> scale-in
     type or reading-order content                  -> mask reveal
     photographic content                           -> blur-in
     siblings arriving together                     -> build/stagger

3. AUTHOR with fromTo only (never from(): it renders its start state at
   construction and flashes under seek). At composition position {{T}}:
     travel-in: tl.fromTo(EL,{x:-115,autoAlpha:0},
                  {x:0,autoAlpha:1,duration:0.40,ease:"power3.out"},{{T}});
     scale-in : {scale:0.92,autoAlpha:0} -> {scale:1,autoAlpha:1,0.35}
     mask     : {clipPath:"inset(0 100% 0 0)"} -> {clipPath:"inset(0 0% 0 0)",
                  duration:0.50,ease:"power2.inOut"}
     blur-in  : {filter:"blur(10px)",autoAlpha:0} -> {filter:"blur(0px)",
                  autoAlpha:1,duration:0.45,ease:"power2.out"}
     build    : the same tween with stagger:{each:0.06,from:"start"} and
                items x 0.06 <= 0.5s total.

4. SCALE DURATION TO DISTANCE: <5% of frame width -> 0.28s; 5-15% -> 0.38s;
   off-frame -> 0.50s. Offset the first entrance 0.1-0.3s after its clip opens.

5. NO EXITS. Elements leave by cut or by the scene transition; only the final
   scene may fade out.

6. SOUND each arrival once, transient on the first frame ({{SFX}}).

ACCEPTANCE TEST: for every element, frames F0 (first visible) and F0+12 must
differ in position, scale, opacity or blur; the settle must land at least 2
frames before the clip's data-duration; no element's entrance exceeds 0.60s;
no group's stagger exceeds 0.5s end to end; the file uses at most 2 families.
```

## Execution spec

**HyperFrames.** Entrances are GSAP tweens on the single paused timeline; the clip attributes only decide *when the element exists*.

```html
<div id="lower-third" class="clip" data-start="12.0" data-duration="4.5" data-track-index="2"
     style="position:absolute;left:120px;bottom:180px;width:720px">
  <div id="lt-name">Kritika</div>
  <div id="lt-role">Editor</div>
</div>
```

```js
const T = 12.15;                      // 0.15s after the clip opens
tl.fromTo("#lower-third", { x: -115, autoAlpha: 0 },
  { x: 0, autoAlpha: 1, duration: 0.40, ease: "power3.out" }, T);
tl.fromTo(["#lt-name", "#lt-role"], { y: 14, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.35, ease: "power3.out",
    stagger: { each: 0.06, from: "start" } }, T + 0.08);
```

Contract points:
- **`fromTo`, always.** `from()` writes its start state at construction, before the clip's `data-start` is active — elements flash or skip their entrance under the render engine's non-linear seek.
- **No CSS `transform` on an element GSAP transforms** (`gsap_css_transform_conflict`, error) and **no CSS `transition`** — it interpolates outside the seek.
- `autoAlpha`, not `display`/`visibility`, and only on non-clip elements or an inner wrapper — the framework owns clip visibility.
- Transform aliases only: `x`, `y`, `scale`, `rotation`. `width`/`height`/`top`/`left` tweens are forbidden; `clip-path` and `filter` are lint-clean on the master timeline (the tighter whitelist binds scene-worker prompts only).
- Land the settle **before** `data-duration` — the window is half-open, so a tween ending exactly on it never renders its last frame.
- Sub-comp timelines cannot animate host-root elements; keep the element and its entrance in the same file.
- Transformed elements must be block-level and sized, and a root-level clip with no computed size is forced to 100 %.

**ffmpeg — the pop audit.**

```bash
# step through a graphic's first half-second
ffmpeg -ss 11.9 -i render.mp4 -t 0.8 -vf fps=30 /tmp/entr/%03d.png
# scene-score spikes reveal single-frame appearances (a pop scores like a cut)
ffmpeg -i render.mp4 -vf "select='gt(scene,0.12)',metadata=print" -f null -
```

**Epidemic Sound.** One short air or tick per arrival:
`SearchSoundEffects { query: { term: "ui tick pop short transition" }, filter: { duration: { max: 800 } } }`, or `tagSlugs ANY ["swooshes--swish"]` for travel-in. Place with the transient on the entrance's first frame ([[motion-sound-bound-motion-event]]).

**Remotion.** `spring()` or `interpolate()` inside a `<Sequence from={…}>` is the equivalent; the same rule applies — the element must not be at its resting state on its first frame. Concept only.

## Pairs with
[[motion-instant-appearance-sfx-justified]] · [[motion-overlay-stack-choreography]] · [[motion-continuity-across-the-seam]] · [[motion-progressive-information-build]] · [[motion-attention-transient]] · [[motion-sound-bound-motion-event]] · [[motion-key-region-animate-in]] · [[motion-velocity-matched-transition]] · [[cut-continuity-pass]] · [[motion-format-promise-motion-budget]] · [[motion-annotation-draw-on]] · [[sfx-air-on-micro-movement]]

## Failure modes
- **The pop.** Full opacity, final position, first frame, no sound. The exact defect the source names. Correction: an entrance from the table, or a transient per [[motion-instant-appearance-sfx-justified]].
- **`gsap.from()` instead of `fromTo()`.** Looks right in preview, flashes or skips in the render. Correction: always `fromTo`.
- **Bounce everywhere.** `back.out(1.7)` on every card reads cheap — the contract's words: *"One ease everywhere reads flat; bounce everywhere reads cheap — the second failure is worse."* Correction: `power3.out` as the default, overshoot reserved.
- **Overshoot on opacity or colour.** A spring with ζ<1 applied to `autoAlpha` produces a visible flicker past 1. Correction: overshooting curves on transforms only; opacity gets its own `power2.out`.
- **Unmotivated direction.** A card flying in from the opposite corner past the speaker's face. Correction: enter from the nearest edge or from the element it belongs to.
- **Stagger sprawl.** Twelve items at 0.08 s each is a 0.96 s crawl. Correction: `amount: 0.5` total, or animate the container instead of the children.
- **Entrance longer than the read.** A 0.9 s reveal on a word that is on screen for 1.2 s. Correction: cap at 0.6 s and give the element 0.8 s of stillness.
- **Re-entering a persistent element** at every scene boundary. Correction: hoist it above the boundary and leave it alone.
- **Exit animations mid-video.** Banned by the stack; they create a dip in the middle of a transition. Correction: delete the exit, let the transition or the cut take it.
