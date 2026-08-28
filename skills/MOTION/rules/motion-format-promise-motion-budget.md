---
id: motion-format-promise-motion-budget
title: Subtract the motion that interrupts what the viewer came for
skill: motion
type: retention
family: retention-contract
tags: [skill/motion, type/retention, family/retention-contract, engine/hyperframes, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:01:22"
    quote: "A bunch of fast cuts and flashy animations would kill the authentic experience the viewer came for. And guess what, interrupting what the viewer actually came for is the fastest way to get them to click off."
research_refs:
  - https://www.opus.pro/research/broll-visual-effects-short-form
  - https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html
  - https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion
  - https://www.clueso.io/blog/how-to-make-tasteful-screen-capture-videos
  - https://source.opennews.org/articles/motion-sick/
difficulty: medium
detectable_from: transcript+video
---

# Subtract the motion that interrupts what the viewer came for

## What it is
A gate that runs **before** any motion is authored, not after. Every animation costs the viewer a saccade and a re-read; that cost is only worth paying when the format's promise is *clarity* or *energy*. When the promise is **intimacy, authenticity or presence** — a vlog, a founder talking to camera, a confession, a slow interview — added motion subtracts from the exact thing the viewer clicked for, so the correct motion count is near zero. This note is the motion library's half of the budget; the editorial half (cut density, stimulation per format) lives in [[struct-stimulation-budget]]. What this note adds is a per-event test and a per-minute ceiling that an unattended agent can apply mechanically.

## When to use it
Run it once at the top of every motion design document, and again as a subtraction pass on the finished event list. It fires hardest when any of these are true: the video's value proposition is the person rather than the information; the A-roll is long-take and unbroken; the audio is the payload (interview, podcast cut, story); the reference profile logs **fewer than 4 motion events per minute**. It does *not* fire on explainers, listicles, product demos or motion-graphics-led formats, where the animation *is* the clarity and the ceiling is set by [[pace-visual-mush-ceiling]] instead.

## How to recognise it in a reference video
- **Count motion events per minute** — any element entering, leaving, scaling, or any camera push. Bands observed in practice: intimacy formats **0–3/min**, standard talking-head explainer **6–14/min**, high-stimulation short-form **25+/min**. A reference sitting at 0–3 is telling you the budget is near zero, and copying a 14/min vocabulary into it is the failure this note prevents.
- **Measure the longest stretch with no motion event at all.** Intimacy formats routinely hold **20–90 s** with nothing moving but the subject. If the reference has such a stretch, that stretch is a *feature* — log it as a required negative.
- **Check whether stills move.** In an intimacy format, an inserted photo often sits genuinely static; in an explainer it always drifts. This single observation separates the two registers faster than anything else.
- **Look for the absence list.** No shake, no overshoot, no whip pan, no counter, no glow. Write the negatives into the profile explicitly — `skills/MOTION/SKILL.md` requires it, and they are what stop the design pass from inventing.
- **Transcript correlation.** If the narration is a story or a confession (first person, past tense, no enumeration), and a graphic lands mid-sentence anyway, that graphic is a candidate defect, not a technique to copy.
- **Watch for stimulation clustering.** In competent work, motion clusters at structural boundaries and disappears inside a beat. Motion spread evenly across a paragraph is the amateur signature.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `format_register` | `explainer` | `intimacy` · `explainer` · `high-stim` | Chosen once, from the promise, not from taste. Everything below derives from it. |
| `events_per_min_ceiling` | 12 | intimacy 0–3 · explainer 6–14 · high-stim 25–40 | Hard ceiling for the design document. Exceeding it requires a written reason per event. |
| `min_quiet_window` | 8 s | intimacy 20–90 s · explainer 6–12 s · high-stim 2–4 s | The longest stretch that must contain no motion event. Author it as a deliberate hole. |
| `event_justification` | required | — | One clause per event naming the spoken words it serves. An event with no clause is cut. |
| `entrance_duration` | 0.4 s (12 f) | 0.25–0.6 s | Intimacy register uses the slow end and `sine.inOut`; high-stim uses 0.15–0.3 s and `expo`/`power4`. |
| `max_simultaneous_events` | 2 | 1–3 | Intimacy: 1. Three things moving at once always reads as busy. |
| `ambient_motion_per_scene` | 1 | 0–1 | Exactly one ambient/idle motion in the breathe phase (30–70% of a scene), per the motion-principles contract. |
| `flash_rate_ceiling` | 3/s | — | WCAG 2.3.1: no more than three general or red flashes in any one second, measured over 25% of any 10-degree visual field. A hard safety limit, not a style choice. |
| `reduced_motion_variant` | off | on/off | Only meaningful for web-delivered artefacts; a rendered MP4 cannot honour `prefers-reduced-motion`. Note it as a known gap when the deliverable is a video. |

## Reproduction prompt

```
Before authoring any motion for this project, run the budget gate.

1. Write ONE line naming the format's promise: what the viewer clicked for.
   Classify it as intimacy, explainer, or high-stim.
2. Set EVENTS_PER_MIN from the register: intimacy 0-3, explainer 6-14,
   high-stim 25-40. Set MIN_QUIET_WINDOW: 20-90s, 6-12s, 2-4s respectively.
3. List every motion event you intend, each with: the timecode, the spoken
   words it serves, and one clause saying what the viewer cannot understand
   without it. Delete every event whose clause is aesthetic ("adds energy",
   "looks modern"). Delete until the per-minute count is at or under
   EVENTS_PER_MIN.
4. Author one deliberate hole of at least MIN_QUIET_WINDOW with zero motion
   events, placed on the video's most personal or most serious passage. Mark
   it in the design document as a required negative so no later pass fills it.
5. Cap simultaneous events at 2 (1 for intimacy) and ambient/idle motion at
   exactly one per scene, in its 30-70% window.
6. Check no cut, flash, strobe or shake produces more than three luminance
   flips per second anywhere in the timeline.

ACCEPTANCE TEST: play {{IN}}..{{OUT}} muted at 1x. If any single motion event
can be removed without the viewer losing information, remove it and re-run.
The final count must be at or under EVENTS_PER_MIN, and the quiet window must
survive intact.
```

## Execution spec

**HyperFrames.** The budget is enforced at authoring time; the engine will happily render an over-animated composition. Two concrete levers exist:

- **Count the tweens you actually wrote.** After authoring, `node skills/hyperframes-animation/scripts/animation-map.mjs <composition-dir> --out <dir>/.hyperframes/anim-map` enumerates every tween on every registered timeline and reports dead zones and stagger consistency. Divide the tween count by the root `data-duration` (seconds) × 60 to get events per minute, and compare it to `events_per_min_ceiling`. Note the contract constraint: `animation-map.mjs` reads live timelines, so it is **browser-dependent and must run off the authoring VM** (linux ARM64, no sudo).
- **The quiet window is a hole in the timeline, and it must be authored as one.** Do not "animate subtly" through it. The contract's own doctrine agrees: exactly one ambient motion in a scene's breathe phase, and *"the slowest scene should be 3× slower than the fastest"* — the quiet window is where that 3× lives.

Transitions are exempt from the count only in the sense that the contract makes them mandatory (*"Every composition uses transitions. No exceptions."*). In an intimacy register, spend that mandate on the calmest entry in the registry — `blur-crossfade`, `default_duration_s` 0.6, or `crossfade` at 0.5 — and never on `zoom-through`.

```js
// Intimacy register: the whole motion vocabulary of a 90s segment.
const tl = gsap.timeline({ paused: true, defaults: { duration: 0.6, ease: "sine.inOut" } });
tl.fromTo("#name-card", { autoAlpha: 0, y: 12 }, { autoAlpha: 1, y: 0 }, 2.4);   // 18f in
tl.to("#name-card", { autoAlpha: 0, duration: 0.4 }, 6.0);
// 6.0 -> 74.0 : intentional hole. No tweens. Do not fill.
```

**ffmpeg.** To measure a reference's stimulation objectively before deciding the register, count scene changes and use that as the cut-density proxy that the motion budget rides on:

```bash
ffmpeg -i ref.mp4 -vf "select='gt(scene,0.3)',metadata=print:file=-" -an -f null - 2>/dev/null | grep -c pts_time
```

**Epidemic Sound.** The budget applies to sound too: an intimacy register wants no motion SFX at all, because every whoosh is a motion event with a volume. If the register is intimacy, the only sound layers are dialogue, ambience and a carved bed — see [[sfx-placement-discipline]].

**Remotion:** the same discipline expressed as fewer `<Sequence>`s and fewer `interpolate()` calls; conceptual only — Remotion is not a runtime in this stack.

## Pairs with
[[struct-stimulation-budget]] · [[pace-visual-mush-ceiling]] · [[pace-cut-density-from-viewer-intent]] · [[pace-subtractive-first-pass]] · [[motion-shake-keyframes]] · [[sfx-placement-discipline]] · [[pace-shot-length-follows-interest]]

## Failure modes
- **Copying a vocabulary across registers.** Lifting a 25-events/minute short-form kit onto a 90-second-per-cut interview destroys the format. Correction: classify the register first; the reference's own event rate is the ceiling, not a starting point.
- **Filling the quiet window later.** A second pass, or a second agent, sees "dead air" and animates it. Correction: write the hole into the design document as a required negative with its own acceptance test.
- **Justifying events after authoring.** Any event can be rationalised once it exists. Correction: the clause is written *before* the tween, and the clause must name spoken words.
- **Confusing subtraction with flatness.** Zero motion is not the goal — one well-placed event in ninety seconds is. Correction: keep the count above zero at structural boundaries; the contract still requires a transition at every scene break.
- **Ignoring the safety floor.** Stimulation budgets are aesthetic; the WCAG flash threshold is not. Three flashes per second is a hard ceiling regardless of register.
- **Known gap:** the per-minute bands here are calibrated from reference profiling and from the usage distributions in the OpusClip corpus (B-roll on 6.0% of clips, transitions on 2.4%), which is descriptive, not causal. No controlled study establishes a retention penalty for over-animation in intimacy formats; treat the bands as house policy that a profile can override, and record the observed reference rate alongside the chosen ceiling.
