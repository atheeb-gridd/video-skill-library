---
id: motion-pattern-interrupt-jolt
title: Break your own motion grammar on purpose — violate exactly one parameter, hard
skill: motion
type: retention
family: pattern-interrupt
tags: [skill/motion, type/retention, family/pattern-interrupt, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:10:08"
    quote: "And don't be afraid to break visual continuity once in a while, because remember, that jolts the viewer. It'll grab their attention."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:58"
    quote: "Another way to make transitions seamless is to use a full-screen transition."
research_refs:
  - https://en.wikipedia.org/wiki/Orienting_response
  - https://bpb-us-e2.wpmucdn.com/sites.wustl.edu/dist/e/952/files/2017/09/maglianoandzacks2011-22vhbrv.pdf
  - https://onlinelibrary.wiley.com/doi/10.1111/j.1551-6709.2011.01202.x
  - https://en.wikipedia.org/wiki/Jump_cut
difficulty: high
detectable_from: video
---

# Break your own motion grammar on purpose — violate exactly one parameter, hard

## What it is
The motion-side execution of the deliberate continuity break ([[pace-deliberate-continuity-break]]). A channel's motion vocabulary is a small, stable set of parameters — an entrance duration band, one or two ease families, a habitual travel direction and distance, a scale range, a palette. Consistency is what makes the edit feel invisible; it is also what makes the viewer stop noticing it. The orienting response fires on **change from the currently active model** and **habituates with repetition** — so the thing that recruits involuntary attention is not motion, it is motion that breaks the pattern the viewer has already learned.

The rule that makes this executable rather than vague: **establish the grammar, then violate exactly one parameter of it by a factor of ≥3× or by an inversion of direction, holding every other parameter identical.** One violated parameter reads as intent. Three violated parameters read as a different editor took over.

## When to use it
Three triggers, and no others:

1. **A known attention dip** — the 25–35 s opening reset, the channel's own retention-graph valleys, and the roughly 90–120 s rehook cadence in long form.
2. **A motion pattern that has run too long.** If the same entrance (same distance, same duration, same ease) has fired **more than about 6 times in 90 seconds**, it has habituated and the next one is invisible. That is the moment a break is cheapest.
3. **A structural turn the viewer must not miss** — the pivot, the "but here's what nobody tells you", the section change, the reveal the whole video was built toward.

Do **not** use it as a style. The jolt is paid for out of the smoothness of everything around it; a video that breaks its grammar every 20 seconds has no grammar to break. And never use one to disguise a genuine mistake — an accidental jump cut and a designed one look identical on the frame and different in the retention graph.

## How to recognise it in a reference video
- **Build the grammar histogram first.** Extract frames at 30 fps around every motion event in a 3-minute stretch and measure, per event: entrance duration in frames, travel distance in px, travel axis and sign, scale delta, and ease shape (front-loaded = out, back-loaded = in, symmetric = inOut). A house grammar shows as a tight cluster — typically **9–15 frames**, one or two ease shapes, and one dominant direction.
- **A break is a measurable outlier on exactly one axis.** Look for a single event where one parameter sits **≥3× outside the cluster** (a 3-frame snap where everything else is 12; a 300 px slam where everything else travels 60) or is **direction-inverted** (everything enters from screen-left, this one drops from the top), while the other parameters stay inside the cluster.
- **Format-level breaks are the loudest and easiest to log:** an aspect-ratio change (full-bleed → letterboxed or pillarboxed), a palette inversion held 2–8 frames, a hard freeze, a grade drop to monochrome, or a switch to a visibly different footage register (phone video, screen recording, archive).
- **Check the audio track at the same frame.** A designed break is nearly always sounded — a hit, a record scratch, a riser resolving, or a **hard cut to silence**. Silence is the most reliable single tell: measure RMS in a 0.5 s window before and after; a drop of **>20 dB** with picture continuing is a deliberate interrupt, not a mix error.
- **Measure spacing.** Log the timestamps of every break. Designed breaks cluster around drop-off zones and section boundaries, at **≥60 s apart**; accidental discontinuity is uniformly distributed and often clustered where the footage was hard.
- **Check the recovery.** After a designed break the grammar returns immediately and exactly. If the motion vocabulary is different *after* the break too, you are looking at two sections cut by different people, not a technique.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `breaks_per_10_min` | 4 | 2–6 | Above 6 the baseline stops existing and every break costs more than it returns. |
| `min_spacing` | 90 s | 60–150 s | Two breaks inside 60 s read as one messy section. |
| `violated_parameters` | 1 | 1–1 | Exactly one. This is the whole rule. |
| `violation_magnitude` | 4× | 3–8× | Of the house value for that parameter. Below 3× it reads as sloppiness; above 8× as a different video. |
| `snap_duration` | 0.10 s (3 f) | 0.03–0.17 s (1–5 f) | For a duration violation against a 9–15 f house band. A 1-frame snap is the maximum-energy version. |
| `snap_ease` | `expo.inOut` or `none` | `power4` · `expo` · `none` · `steps(N)` | The break may use an ease family the video otherwise never uses — that *is* the violation when duration is held constant. |
| `hold_after_break` | 1.5 s | 0.8–3.0 s | The break needs stillness after it or the jolt has nothing to land in. |
| `format_break_duration` | 4.0 s | 1.5–8.0 s | Aspect/register breaks are sections, not events. Under 1.5 s they read as a glitch. |
| `flash_frames` | 2 f | 1–4 f (33–133 ms) | Palette inversion or white flash. **Never** build a repeating flash — see failure modes. |
| `freeze_duration` | 0.8 s (24 f) | 0.5–2.0 s | Freeze + desaturate + type is the "record scratch" register. |
| `silence_window` | 0.6 s | 0.4–1.2 s | Music and bed out, hard, at the break frame. |
| `audio_lead` | 1 f (33 ms) | 0–2 f | The break's sound may lead picture by up to one frame; two is the practical ceiling. |
| `recovery` | exact | — | Every parameter returns to the house value on the very next event. |

## Reproduction prompt

```
Place a deliberate motion-grammar break at {{T}}.

STEP 1 - MEASURE THE GRAMMAR. From the 90 seconds before {{T}}, log every
motion event's entrance duration (frames), travel distance (px), travel axis
and sign, scale delta, and ease family. Compute the median of each. This is
the house grammar. Write it into the design document; if you cannot state it
in one line, you do not yet know what you are breaking.

STEP 2 - CHOOSE ONE PARAMETER and violate it by 3-8x, or invert its
direction. Everything else stays exactly at the house value. Pick by register:
  DURATION violation  - the same element, same distance, same ease, but 3
                        frames instead of 12. Reads as urgency.
  DIRECTION violation - same duration and distance, entering from the opposite
                        axis. Reads as surprise.
  SCALE violation     - a hard punch to 1.6x in 3 frames where the house move
                        is 1.08x over 14. Reads as emphasis.
  FORMAT violation    - the frame itself changes: aspect, palette inversion
                        (2 frames), monochrome, or a switch to a visibly
                        different footage register. Reads as a chapter break.
  STILLNESS violation - a hard freeze of 24 frames in a video that never
                        freezes. Reads as a full stop.

STEP 3 - SOUND IT. The break must be audible. Either (a) a transient whose
peak lands on the break frame, -12 to -15 dB, or (b) the inverse: cut music
and bed to silence at the break frame with a 1-frame fade, and hold the
silence 0.4-1.2s. Do not do both.

STEP 4 - LAND IT. Hold 1.5s of relative stillness after the break so the jolt
has somewhere to resolve. Then return EVERY parameter to the house value on
the next motion event - no drift, no second break.

CONSTRAINTS: no more than 4 breaks per 10 minutes and never two within 60
seconds. Never place a break to cover a real continuity error. Never build a
flashing or strobing break - no repeating flash element, ever.

ACCEPTANCE TEST: play from {{T}}-15s to {{T}}+10s at 1x. The break must be
noticeable on the first viewing and must not be re-noticeable as an error on
the third. Then verify the grammar histogram: exactly one parameter is an
outlier at the break frame, and the event immediately after {{T}}+1.5s sits
back inside the cluster.
```

## Execution spec

**HyperFrames.** A break is authored the same way as any other motion; what makes it a break is the *numbers*, and those numbers come from measuring the surrounding grammar.

```js
// House grammar for this video, measured: 0.45s, y +40 -> 0, power3.out, stagger 0.06
tl.fromTo("#card-a", { y: 40, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.45, ease: "power3.out" }, 61.2);

// THE BREAK at t=104.0 - duration violated 4.5x, direction inverted; everything else identical
tl.fromTo("#card-break", { y: -40, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.10, ease: "expo.out" }, 104.0);

// Format break: a 2-frame palette inversion on a non-clip overlay
tl.set("#flash", { autoAlpha: 1 }, 104.0);
tl.set("#flash", { autoAlpha: 0 }, 104.067);   // 2 frames @30fps

// Recovery - back to house on the very next event
tl.fromTo("#card-b", { y: 40, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.45, ease: "power3.out" }, 105.6);
```

Contract points that bind this:
- **Seconds, always.** 3 frames at 30 fps is `0.10`; 2 frames is `0.067`. There is no frame attribute, and `--fps` can override `data-fps`, so the *derived* frame count must be recomputed if the delivery fps changes.
- **A zero-duration boundary `tl.set()` is the legal way to snap visibility**, and only on a **non-clip** element or an inner wrapper — the framework owns clip visibility and lint rejects `display`/`visibility` tweens on a clip.
- **`fromTo`, never `from`** — the render seeks non-linearly and `from()` writes its start state at construction.
- **A format break is usually a scene boundary, so use the transition registry**, not a hand-rolled move. `zoom-through` (0.4 s, high energy) and `squeeze` (0.4 s, medium) are the Tier-B entries with the right register; `default_high_energy` is `zoom-through` and `max_duration_s` is 2.0. The registry's own planner budget — *pick 2–3 transition types for the whole video and repeat them* — is what creates the baseline a break needs, so the break should use the **one type held in reserve**, used once.
- **Multi-scene rules still apply at a break.** Outgoing and incoming animate at the same time `T`; exit animations are banned except on the final scene, because *the transition is the exit*. A break is not a licence to fade out.
- **Aspect changes are authored, not rendered.** `--resolution` must match the composition's aspect and the scale must be an integer, so a mid-video letterbox is a full-bleed child element with bars — not a render-level change.
- **Ambient/idle motion must be finite and attached to `tl`.** No `repeat: -1`, no bare `gsap.to()`.
- Named rules that may be cited, not quoted: `kinetic-beat-slam`, `chromatic-glitch`, `motion-blur-streak`, `scale-swap-transition`, `viewport-change`.

**ffmpeg.** A freeze break and a register break are file operations:

```bash
# freeze frame at t, held 0.8s, as a still to place as an <img> clip
ffmpeg -ss 104.0 -i main.mp4 -frames:v 1 -update 1 freeze.png

# monochrome + contrast register break, baked
ffmpeg -i shot.mp4 -vf "hue=s=0,eq=contrast=1.25" shot.mono.mp4

# measure the silence break: RMS either side of the break frame
ffmpeg -ss 103.4 -t 0.5 -i mix.wav -af "volumedetect" -f null - 2>&1 | grep mean_volume
ffmpeg -ss 104.0 -t 0.5 -i mix.wav -af "volumedetect" -f null - 2>&1 | grep mean_volume
```
There is **no arbitrary mid-source freeze** inside the composition — a freeze needs a preprocessed still or segment. And there is **no rate envelope**: a break built as a speed ramp must be preprocessed, because `data-playback-rate` is a constant in `0.1..5`.

**Epidemic Sound.** Two mutually exclusive routes. Sounded break: `SearchSoundEffects { query: { term: "cinematic impact hit braam" }, filter: { duration: { max: 2500 } } }`, peak on the break frame, −12 to −15 dB. Silent break: no fetch at all — a `volume` automation lane on the bed with points at `{t: T-0.03, v: <bed>}` and `{t: T, v: 0}`, held for the silence window, then back up over 0.3–0.5 s ([[sfx-silence-as-pattern-interrupt]], [[sfx-music-hard-stop]]).

**Remotion.** Frame-native, so a break is expressed literally: `interpolate(frame, [T, T+3], [40, 0])` against a house `[T, T+14]`. Not a runtime in this project.

## Pairs with
[[pace-deliberate-continuity-break]] · [[sfx-silence-as-pattern-interrupt]] · [[motion-camera-shake-impact]] · [[cut-smash-cut]] · [[motion-attention-transient]] · [[struct-presenter-aside-pattern-interrupt]] · [[cut-full-screen-transition]] · [[motion-format-promise-motion-budget]] · [[sfx-cinematic-hit-emphasis]] · [[pace-visual-change-clock]]

## Failure modes
- **No grammar to break.** If the video's motion is already inconsistent, a break is invisible — it is just one more different thing. Correction: measure the histogram first; if the cluster is wide, the fix is consistency, not a jolt.
- **Two or more parameters violated at once.** Reads as a mistake or as a different editor. Correction: one parameter, 3–8×, everything else held.
- **Violation too small.** A 2× duration change is below the noticing threshold and just looks uneven. Correction: ≥3×, or invert a direction.
- **Break used to cover an error.** The audience cannot tell, but the retention graph can: a covered error still sits where the content was weak. Correction: fix the underlying cut.
- **Too frequent.** Every break habituates the next one, exactly as the orienting response habituates to a repeated stimulus. Correction: ≤4 per 10 minutes, ≥60 s apart.
- **Silent break.** A hard visual discontinuity with no audio event reads as a dropped frame or an export bug. Correction: sound it, or make the silence itself the event.
- **No recovery.** The grammar never comes back and the "break" turns out to have been a new normal. Correction: return every parameter on the next event.
- **Flashing.** A repeated high-contrast flash is a photosensitivity hazard, not a technique. Correction: single flashes of 1–4 frames only, never a repeating or strobing element, and never full-frame red.
- **Known gap.** Nothing in this stack measures a video's own motion grammar for you. `animation-map.mjs` enumerates tweens and samples bounding boxes from the **registered timelines of a composition you already authored** — useful for auditing your own choreography, useless for profiling a reference MP4. Reference-side grammar histograms come from frame extraction and manual measurement, and it is a browser-dependent script besides, so it cannot run on this project's authoring VM.
