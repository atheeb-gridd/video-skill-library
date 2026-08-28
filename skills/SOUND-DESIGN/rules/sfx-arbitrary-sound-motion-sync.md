---
id: sfx-arbitrary-sound-motion-sync
title: For abstract motion there is no correct sound — only sync
skill: sound-design
type: sfx
family: motion-coverage
tags: [skill/sound-design, type/sfx, family/motion-coverage, engine/hyperframes, engine/epidemic, engine/ffmpeg, sfx/motion, layer/sfx, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:05:40
    quote: "And the fun part is, there's no rule at all. You can use any random sound effect, as long as it matches the motion of the video."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:05:46
    quote: "If it's in sync, it will just make sense."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:06:23
    quote: "But for things that don't even exist in real life, you can creatively use any sound effect you want. The speed and timing just have to match."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:07:04
    quote: "And if you're putting a sound effect on a motion, then match the peak of the sound effect to the middle of the motion. And match the length of the sound effect with the motion."
research_refs:
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Pitch_shift
difficulty: medium
detectable_from: audio
---

# For abstract motion there is no correct sound — only sync

## What it is
The answer to "which sound effect do I even search for?" for animation, motion graphics and text effects: **there isn't one**. For an element with no real-world referent — a line drawing itself, a card flipping, a number counting, a shape morphing — any sound works provided it matches the motion. Sync is what creates meaning, not literal correspondence. What "matches" means is not vague, though, and this note makes it four measurable things: **attack alignment**, **duration ratio**, **envelope shape versus the motion's easing curve**, and **spectral direction versus travel direction**.

The rule has a hard boundary the same source demonstrates: for anything with a real referent, an arbitrary sound is wrong — a water sound on the wrong object "will just feel weird". Freedom applies to the abstract; the representational belongs to the diegetic style and is constrained by physics.

## When to use it
- **On motion-graphics animation**: an element sliding, scaling, morphing, drawing, assembling, counting.
- **On text effects**: a word slamming in, characters typing, a line wiping, a caption popping.
- **On UI and screen-recording motion**: a panel opening, a cursor click ripple, a chart filling.
- **On transitions built from shapes** rather than from camera moves.
- **When you have been searching for twenty minutes** for "the right sound" for an abstract animation. That search has no answer; pick a candidate with the right envelope and align it.
- **Not on anything the viewer can name.** A door, a phone, a glass, a car, water, a body — those get the sound of the thing. The `sfx/diegetic` style governs, and substitution is heard immediately.
- **Not as licence to skip judgement.** "Any sound" means the *identity* is free; the four matching parameters are not.

## How to recognise it in a reference video
- **Look for effects with no referent.** An effect that does not correspond to any object on screen but lands exactly on an animation is this technique. Cataloguing the *identity* of these sounds is usually a waste of time; catalogue their **shapes**.
- **Measure attack alignment.** Find the effect's sharpest transient and the animation's peak-velocity frame. In a well-synced pair these are within **±1 frame** (33 ms). Anything beyond about 2 frames early starts crossing the lead-detectability threshold (~45 ms); lateness is roughly three times more forgiving (~125 ms).
- **Measure the duration ratio.** `sfx_duration / motion_duration` should sit at **0.8–1.25**. A ratio near 2 means the sound was dropped on without trimming; near 0.4 means it fires and the motion continues in silence.
- **Read the envelope against the easing.** This is the diagnostic that separates real craft from luck. Sample the effect's amplitude envelope and the animation's velocity curve and compare their peak positions:
  - envelope peaks at the **start**, decays → matches an `.out` ease (fast start, long settle)
  - envelope **builds** to a peak at the **end** → matches an `.in` ease (accelerating into a stop)
  - envelope peaks in the **middle** → matches an `.inOut` ease
  - envelope is **flat and sustained** → matches linear/`none` motion
  - **two** transients, the second smaller → matches `back.out` / `elastic.out` overshoot
  - **N discrete ticks** → matches `steps(N)`
  A mismatch here is what people mean when they say a sound "doesn't fit" an animation they cannot fault otherwise.
- **Check spectral direction.** Rising pitch or brightening spectrum on upward, outward or expanding motion; falling on downward, inward or contracting motion. Reversed direction is audible as wrongness even when the timing is perfect.
- **Transcript signal:** none. This is a picture-and-audio technique.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `attack_alignment` | 0f from peak velocity | −1f to +3f | 30fps. Bias late rather than early — the lead detectability threshold (~45 ms) is about 3× tighter than the lag threshold (~125 ms). |
| `duration_ratio` | 1.0 | 0.8–1.25 | `sfx_duration / motion_duration`. Enforce with the Epidemic duration filter; stretch only as a last resort. |
| `envelope_match` | derived from the ease | see table below | The main parameter. Choose the sound by its shape, not its name. |
| `peak_position` | mid-motion for `.inOut` | 0–100% of the motion | The source's "peak in the middle" rule is correct for `.inOut` easing and wrong for `.in` or `.out`. Derive it. |
| `pitch_direction` | rising for up/out/expand | rising · falling · flat | Falling for down/in/contract. Flat for lateral or mechanical motion. |
| `level` | 0.211 (≈−13.5 dB) | 0.178–0.251 (−15 to −12 dB) | Relative to dialogue at 0/−3 dB. |
| `candidates_auditioned` | 3 | 2–5 | Because identity is free, the cheap move is to try three shapes rather than search for one name. |
| `tail_ramp` | 6f (0.2 s) | 3–12f | Ramp to zero so the effect does not outlive the animation. |
| `reverb_wet` | 0.15 | 0.10–0.25 | Stops the effect sounding studio-recorded and pastes it into the scene. |

**Envelope-to-easing map** — this is the table the whole note exists to produce. Eases are the GSAP families actually available in this stack.

| Ease on the motion | Velocity peaks | Sound shape to fetch | Anchor the transient at |
|---|---|---|---|
| `power2.out`, `power3.out`, `power4.out` (house entrance default) | at the start | sharp attack, long decaying tail — a hit, a stab, a reverse-decay swell | the motion's **first** frame |
| `expo.in`, `power2.in` | at the end | a build — riser, accelerating whoosh, rising sweep | the motion's **last** frame |
| `sine.inOut`, `expo.inOut`, `power2.inOut` | at the middle | a symmetrical sweep — a classic whoosh | the motion's **midpoint** |
| `none` (linear) | constant | sustained and flat — a drone, hum, tone, motor | held across the whole motion, no transient |
| `back.out(1.7)`, `elastic.out` | at the start, then rebounds | boing, spring, rubber — two transients | first frame, second accent on the overshoot's return |
| `bounce.out` | repeated impacts | a short impact repeated with decreasing level | each bounce contact |
| `steps(N)` | N discrete jumps | N ticks, clicks or blips | one per step |
| stagger of N items | N staggered starts | one short sound per item, or one sound whose length equals the total stagger | first item's start; keep total under ~0.5 s so it reads as one beat |

## Reproduction prompt

```
Sound the abstract animation that runs {{MOTION_IN}}..{{MOTION_OUT}}.

1. CHECK THE BOUNDARY FIRST. Does the animated element depict a real object
   or material - water, glass, metal, a door, a body? If yes, STOP: this is
   a diegetic effect and the sound is determined by the object. This note
   applies only to abstract elements: shapes, text, lines, charts, UI,
   morphs, counters.
2. READ THE EASE from the composition's tween. Note the ease name and the
   duration in seconds. Convert duration to milliseconds: {{MOTION_MS}}.
3. DERIVE THE ENVELOPE using the ease->shape table:
   .out ease   -> sharp attack + decay, transient on the FIRST frame
   .in ease    -> build to a peak, transient on the LAST frame
   .inOut ease -> symmetrical sweep, transient at the MIDPOINT
   linear      -> sustained flat tone, no transient
   back/elastic-> two transients: arrival, then the overshoot return
   steps(N)    -> N ticks
4. DERIVE THE PITCH DIRECTION from travel: up/outward/expanding -> rising;
   down/inward/contracting -> falling; lateral or mechanical -> flat.
5. FETCH BY SHAPE, NOT BY NAME. Search Epidemic with a duration filter of
   0.8*{{MOTION_MS}} to 1.25*{{MOTION_MS}} and a term describing the SHAPE
   ("riser short", "impact tight", "sweep symmetrical", "tick click",
   "spring boing"). Pull 3 candidates. Do not keep searching for the "right"
   sound - there isn't one.
6. PLACE each candidate so its loudest frame lands on the anchor frame from
   step 3. Remember to subtract the file's internal peak offset from the
   start time; do not assume the peak is at the file's head.
7. AUDITION all 3 back to back at -13.5 dB and take the best. Total time
   budget: 6 minutes.

ACCEPTANCE TEST: play the motion at full speed three times. If you cannot
say whether the sound is early or late, the alignment is right. Then play it
at 0.25x: the loudest moment of the sound must coincide with the fastest
moment of the movement. If the animation finishes before the sound does, or
vice versa, fix the duration ratio before touching anything else.
```

## Execution spec

**HyperFrames — the ease *is* the spec, and it is readable.** Motion is GSAP on one paused timeline per composition, positioned in **absolute composition seconds** as the tween's third argument. So the four matching parameters are all derivable from markup you already have:

```js
// 12 frames @30fps = 0.4s, house settle, at t=1.2s
tl.fromTo("#card",
  { x: -40, autoAlpha: 0 },
  { x: 0, autoAlpha: 1, duration: 0.4, ease: "power3.out" },
  1.2
);
```
From that one tween: duration 0.4 s → `MOTION_MS = 400`, filter 320–500 ms. Ease `power3.out` → velocity peaks at the start → sharp attack with decay, transient anchored on **1.20 s**. Travel is `x: -40 → 0`, lateral → flat pitch direction. That is the entire brief, with nothing measured from pixels.

The audio then has to carry the same number:
```html
<audio id="sfx-card-in" src="assets/sfx/impact-tight-03.wav"
       data-audio-group="sfx"
       data-start="1.17"          <!-- 1.20 minus the file's 0.03s peak offset -->
       data-duration="0.46"
       data-track-index="23"
       data-volume="0.211"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.26,&quot;v&quot;:1},{&quot;t&quot;:0.46,&quot;v&quot;:0}]}]}"></audio>
```

Contract points that bite:
- **There is no audio-follows-animation attribute.** The tween's timeline position and the `<audio data-start>` are the same number written twice, by hand. That duplication is the whole coupling mechanism, and it is why a motion revision silently desyncs the sound.
- **If the tween lives in a sub-composition,** its position is *scene-local*. The root-level audio needs `data-start = scene-local t + the slot's data-start`. A sub-comp timeline cannot reach host-root elements, so the audio cannot be placed from inside the animation.
- **All authored time is seconds; there is no frame attribute.** 1 frame at 30fps = 0.0333 s.
- **Use `fromTo`, never `from`** — `from()` sets `immediateRender: true` and under the render engine's non-linear seek the element flashes or starts wrong, which desyncs the sound you carefully aligned.
- **`data-playback-rate` is a constant in 0.1–5 with pitch preserved.** There is no rate envelope, so you cannot ramp a sound's speed to follow an ease — the envelope must come from the file you chose or from a `volume` lane you draw.
- The stagger cap is a sound constraint too: `items × stagger ≤ ~0.5 s` so an arrival reads as **one** beat — which means one sound, not N.

**Drawing an envelope you could not fetch.** When no candidate has the right shape, build it from a flat sustained sound plus a `volume` lane. For an `.in` ease (build to the end) over 0.6 s:
```html
data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
  {&quot;t&quot;:0,&quot;v&quot;:0.06},{&quot;t&quot;:0.3,&quot;v&quot;:0.18},{&quot;t&quot;:0.5,&quot;v&quot;:0.5},{&quot;t&quot;:0.6,&quot;v&quot;:1},{&quot;t&quot;:0.72,&quot;v&quot;:0}]}]}"
```
The lane's `curve` field (−1..1) bends the segment *leaving* a point, which is how you approximate an exponential build without twenty breakpoints. Lanes cap at 512 points. Remember the lane **holds its first value backwards**, hence the explicit `t:0`.

**Epidemic Sound — search the shape.** Terms that describe envelopes rather than objects are what make this fast:
```
# .out ease - attack then decay
SearchSoundEffects { query:{term:"impact tight short"},   filter:{duration:{min:320,max:500}} }
# .in ease - build to a stop
SearchSoundEffects { query:{term:"riser short build"},    filter:{duration:{min:480,max:750}} }
# .inOut ease - symmetrical sweep
SearchSoundEffects { query:{term:"whoosh sweep"},         filter:{duration:{min:400,max:625}} }
# linear - sustained
SearchSoundEffects { query:{term:"drone tone sustained"},  filter:{duration:{min:2000,max:8000}} }
# steps / ticks
SearchSoundEffects { query:{term:"click tick ui"},         filter:{duration:{min:40,max:250}} }
# back/elastic - overshoot
SearchSoundEffects { query:{term:"boing spring cartoon"},  filter:{duration:{min:300,max:900}} }
SearchSimilarToSoundEffect { id:<the shape that worked>, first: 12 }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
`audioFile.waveformUrl` on every hit is the fastest way to check an envelope's shape before downloading anything — for this note it is more useful than the title.

**ffmpeg — reshaping a candidate** when its identity is right and its shape is not:
```bash
ffmpeg -i sweep.wav -af "areverse" build.wav                      # turn a decay into a build
ffmpeg -i sfx.wav -af "asetrate=48000*1.12,aresample=48000,atempo=0.893" up.wav   # +2 semitones, length kept
ffmpeg -i sfx.wav -af "atrim=0:0.4,afade=t=out:st=0.3:d=0.1" short.wav
```
`atempo` is valid only in 0.5–2.0; chain instances for larger changes. Reversing is the highest-value single operation here: it converts every `.out`-shaped effect in the catalogue into an `.in`-shaped one, doubling your usable library.

**Remotion:** the same derivation from an `interpolate()` easing function; `<Audio>` offset so its peak lands on the anchor frame. Concept only.

## Pairs with
[[sfx-envelope-matched-to-easing-curve]] · [[sfx-unsounded-motion-audit]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-pitch-shift-weight-energy]] · [[motion-abstract-object-sound-contract]] · [[motion-sound-bound-motion-event]] · [[motion-entrance-vocabulary]] · [[motion-impact-frame-quantisation]] · [[sfx-diegetic-action-inventory]] · [[sfx-three-types-classification]] · [[sfx-name-before-search]] · [[sfx-motion-sound-selection]]

## Failure modes
- **Applying it to a real object.** Any sound on a shape is fine; any sound on a glass of water is not. The source demonstrates the failure directly. Fix: check the boundary first, every time.
- **Peak in the middle by reflex.** The stated "peak at the middle of the motion" rule is correct for `.inOut` easing, which is not this stack's entrance default — `power3.out` is. On an `.out` ease the peak belongs on the **first** frame. Fix: derive the anchor from the ease.
- **Ignoring the duration ratio.** The commonest visible-audible mismatch: a 1.2 s effect on a 0.4 s animation. Fix: fetch inside a duration filter derived from the tween.
- **Searching for the "right" sound.** There isn't one, and the search is unbounded. Fix: 3 candidates, 6 minutes, choose by envelope.
- **Reversed spectral direction.** A falling pitch on an expanding element reads as wrong even when the timing is perfect. Fix: rising for out/up, falling for in/down.
- **One sound per staggered item when the stagger is under 0.5 s.** Produces a rattle where the motion reads as one beat. Fix: one sound for the whole arrival.
- **Forgetting to re-sync after a motion revision.** Nothing in the stack couples them; a changed tween position silently orphans the audio. Fix: treat the tween position and `data-start` as one edit.
- **Known gap:** the envelope-to-easing table is a derivation from the velocity profiles of the named GSAP eases plus the source's stated "peak in the middle" rule. No cited study measures listener preference for envelope-to-easing matching; the table is defensible mechanics, and it should be checked against a reference profile when one exists.
