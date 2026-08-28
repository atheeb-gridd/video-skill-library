---
id: sub-fast-cut-sequence-captions
title: In a fast-cut burst, stop snapping and let one held cue ride the whole sequence
skill: subtitles
type: caption-timing
family: shot-change
tags: [skill/subtitles, type/caption-timing, family/shot-change, engine/hyperframes, engine/ffmpeg, source/research, source/editing-kt, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:09"
    quote: "So I only use captions when I want the viewer to catch specific words and pay extra attention to them."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Every composition uses transitions. No exceptions. ... Exit animations are BANNED except on the final scene. The transition IS the exit."
research_refs:
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html
difficulty: high
detectable_from: video
---

# In a fast-cut burst, stop snapping and let one held cue ride the whole sequence

## What it is

There is a cut rate above which every caption rule that references the picture stops working. When shots are 0.3–1.0 s long — a montage, an A-roll burst, a rapid list of examples, a "here are seven things" sequence — snapping to cuts would produce cues below the duration floor, breaking at cuts would produce fragments, and any per-cue entrance animation would put a moving caption on top of already-moving picture.

The rule for that regime is the opposite of the normal one: **detach the caption from the picture entirely and hold it still.**

Concretely, a fast-cut sequence gets:

1. **One cue, or very few**, spanning the whole burst — timed to the speech that motivates the sequence, not to any shot inside it.
2. **No snapping.** The cut list inside the burst is ignored.
3. **No per-cue motion.** The caption enters once before the burst and leaves once after it. Inside the burst it does not move, scale, pop or change colour, because everything else on screen is already changing at 1–3 Hz.
4. **A stronger backing.** The background is changing every few frames, so a stroke or shadow tuned to one shot will fail on another. The plate is the safe answer inside a burst; see [[sub-legibility-backing-ladder]].
5. **A fixed baseline.** The cue must not re-layout mid-burst. Any change in the caption's size or line count during a burst reads as a flicker on top of a flicker.

The threshold where this regime starts is measurable: when **median shot length inside the sequence falls below about 1.2 s**, or equivalently when there is more than one cut per cue at the track's normal cue length. Below **0.5 s** median, treat the whole burst as a single visual event and consider whether the caption should be there at all — [[motion-silent-motion-tier]] and the emphasis-layer role are often the better answer.

There is a second, related case: the **scene change**. A single boundary between two structurally different segments (topic change, chapter break, a full-frame card) is not a fast-cut burst but it obeys a related rule — the caption clears *before* the boundary rather than being cut off by it, because a caption chopped by a scene transition looks like a rendering fault. Clear it 2–4 frames before the transition begins, and bring the next cue in after the transition resolves.

## When to use it

- Any sequence whose median shot length is under ~1.2 s and which lasts long enough to contain a cue.
- Montage, list bursts, before/after flurries, "look at all these" sequences, and beat-cut sections built on [[pace-cut-on-the-beat]].
- Across a **scene transition** of any kind — crossfade, push-slide, zoom-through — where a cue would otherwise be cut in half.
- **Do not** apply it to a merely brisk section. Between 1.2 s and 2.5 s median shot length, the normal policy in [[sub-cut-boundary-policy]] still works.
- **Do not** use it to justify holding a stale cue: the cue still obeys the 5 s practical ceiling and the reading-rate cap.

## How to recognise it in a reference video

- **Find the bursts first.** Build the cut list, compute shot lengths, and mark every run of 3+ consecutive shots under 1.2 s. That run is a burst; treat its boundaries as the unit of analysis.
- **Cue count per burst.** A handled burst shows **1–2 cues** across the whole run. An unhandled one shows a cue per shot, and its cue durations cluster at the shot length rather than at the speech rhythm.
- **Motion inside the burst.** Extract every frame of the burst. A handled caption is pixel-identical frame to frame except for the glyphs at a single swap. Any per-cue scale or slide inside a burst is visible as jitter against the cutting.
- **Backing change.** Check the caption's contrast against three different shots inside the burst. A stroke-only caption will pass on two and fail on one; a plate passes on all three.
- **Baseline drift.** Measure the caption baseline as a percentage of frame height on the first and last frame of the burst. Anything over ~0.5 % of frame height is a re-layout.
- **At scene transitions.** Step through the transition frame by frame. A well-handled track has cleared the caption before the first frame of the transition; a badly handled one shows caption text crossfading or scaling with the outgoing scene.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `burst_threshold` | 1.2 s median shot | 0.8–1.6 s | Below this, the burst regime applies. |
| `burst_min_shots` | 3 | 3–5 | Fewer consecutive short shots is not a burst. |
| `extreme_burst` | 0.5 s median | — | Below this, question whether a caption belongs at all. |
| `cues_per_burst` | 1 | 1–2 | Timed to the speech that motivates the burst. |
| `snap_inside_burst` | off | off | The cut list inside the burst is ignored entirely. |
| `motion_inside_burst` | none | none | No entrance, no pop, no colour change per cue. |
| `backing_inside_burst` | plate | plate | The only backing that survives an unknown background. |
| `baseline_drift_max` | 0.5 % frame height | 0–1 % | Measured first frame to last frame of the burst. |
| `pre_transition_clear` | 3 frames | 2–4 f | Caption clears before a scene transition starts. |
| `post_transition_hold` | transition duration + 2 f | — | Next cue starts after the transition resolves. |
| `max_burst_cue_duration` | 5.0 s | up to 7.0 s | The ceiling still applies. |
| `burst_cps_cap` | 15 CPS | 12–17 | Lower than normal: the picture is competing for attention. |

## Reproduction prompt

```
Handle caption timing across fast-cut sequences in {{VIDEO}}.

1. DETECT bursts. Build the hard-cut list, compute every shot length, and
   mark each run of >= {{MIN_SHOTS}} = 3 consecutive shots whose median
   length is under {{BURST}} = 1.2s. Record each burst's start and end.
2. RE-TIME. Inside each burst discard the existing cue boundaries and emit
   ONE cue spanning it, timed to the speech: start at the first word onset at
   or after the burst start minus {{PAD}} = 0.06s, end at the last word end
   before the burst end plus {{TAIL}} = 0.4s. If the text would exceed
   {{BURST_CPS}} = 15 characters per second or 5.0s, emit two cues split at
   the strongest syntactic boundary - never more.
3. STRIP MOTION. Inside a burst the caption has no entrance, exit, scale,
   colour change or highlight advance. One {{FADE}} = 0.10s power2 fade
   before the burst and one after it.
4. FORCE the plate backing and a fixed baseline for the whole burst.
5. SCENE TRANSITIONS. Clear any cue {{PRE}} = 3 frames before a transition's
   first frame and start the next cue after the transition plus 2 frames.

ACCEPTANCE TEST: every burst holds at most 2 cues; no cue boundary inside a
burst coincides with a cut; every frame of one burst shows the caption box
pixel-identical apart from glyph swaps; the caption is absent in every
transition frame; and no burst cue exceeds 15 CPS or 5.0s.
```

## Execution spec

**Transitions are the hard constraint here, and the framework's rules make the caption's behaviour non-negotiable.** Every composition uses transitions; every scene uses entrance animations; **exit animations are banned except on the final scene** because "the transition IS the exit" and outgoing content must be fully visible when the transition starts. A caption still on screen when a `zoom-through` fires will be scaled to 2.5x and blurred along with the rest of the outgoing wrapper — which is why the caption must be *gone*, cleanly, before the transition's start time rather than fading out during it.

Transition durations from the registry, which set the clear-before window: `crossfade` 0.5 s, `blur-crossfade` 0.6 s, `push-slide` 0.5 s, `zoom-through` 0.4 s, `squeeze` 0.4 s, with a global `max_duration_s` of 2.0. The injector pulls the incoming clip's `data-start` earlier by the transition duration, so the next cue's earliest legal start is the incoming clip's *authored* start plus the transition duration.

If the caption lives in its own sub-composition hosted above the scene stack, it is not part of either scene wrapper and will **not** be swept up by a transition — which is the architecture to prefer. Note the hard nesting limit: a sub-comp timeline cannot animate host-root elements, so the caption comp drives only its own DOM, and its cue times are **scene-local** if it is nested inside a scene and **global** if it sits at the host root. For a track that must survive scene cuts, put it at the host root — the same reasoning that puts audio at the root so playback survives scene cuts.

Inside a burst, "no motion" also means no ambient motion: an ambient pulse must attach to the seekable `tl` and, in a burst, should simply not exist. Bare `gsap.to()` tweens run on wallclock and are absent from the render anyway.

## Pairs with
[[sub-cut-boundary-policy]] · [[sub-shot-change-snapping]] · [[sub-legibility-backing-ladder]] · [[sub-caption-graphic-collision]] · [[sub-entrance-exit-motion-budget]] · [[sub-spring-and-bounce-budget]] · [[pace-cut-on-the-beat]] · [[pace-a-roll-burst-rationing]] · [[motion-silent-motion-tier]] · [[motion-continuity-across-the-seam]]

## Failure modes
- **One cue per shot inside a burst.** Sub-floor fragments, unreadable, and they make the cutting look faster than it is. Correction: one cue for the burst.
- **Per-cue entrance animation inside a burst.** Motion on top of cutting reads as jitter and is the most fatiguing thing a caption can do; it is also the case the reduced-motion guidance is about. Correction: strip all motion inside the burst.
- **Stroke-only backing inside a burst.** Passes on the shots you checked and fails on the one you did not. Correction: plate.
- **Caption caught by a transition.** Scaled and blurred with the outgoing scene, which reads as a bug. Correction: clear 3 frames before the transition starts.
- **Caption nested inside a scene sub-comp.** It inherits the scene's clip window and disappears mid-word at the scene boundary. Correction: host-root caption track.
- **Holding one cue across a burst that runs 9 seconds.** Legal by policy, illegal by ceiling. Correction: split at the strongest syntactic boundary, maximum two cues.
- **Applying the burst rule to merely brisk cutting.** Between 1.2 s and 2.5 s the normal policy is better and preserves the caption/picture relationship. Correction: measure before switching regimes.
