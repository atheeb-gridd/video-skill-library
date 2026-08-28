---
id: pace-shot-length-follows-interest
title: Shot length is set by interest, never by a target duration
skill: editing
type: pacing
family: shot-duration
tags: [skill/editing, type/pacing, family/shot-duration, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:05:52"
    quote: "To avoid that, don't shorten your shots just for the sake of being short. Period. It's totally fine to leave the same clip on screen for 10 seconds if it's interesting for 10 seconds."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:04"
    quote: "A lot of the time you don't even need to cut to a different clip to make your video more interesting. Instead, use a few of these tricks to make the content way more immersive."
research_refs:
  - https://en.wikipedia.org/wiki/Walter_Murch
  - https://en.wikipedia.org/wiki/Average_shot_length
  - https://support.google.com/youtube/answer/9314415
  - https://ffmpeg.org/ffmpeg-filters.html#tblend
  - https://ffmpeg.org/ffmpeg-filters.html#signalstats
difficulty: medium
detectable_from: transcript+video
---

# Shot length is set by interest, never by a target duration

## What it is
A shot ends when it stops paying the viewer, and not one frame before. The source states it as a prohibition — *"don't shorten your shots just for the sake of being short"* — and then removes the usual excuse by naming a concrete counter-example: ten seconds on one clip is correct if the clip is interesting for ten seconds. The consequence is that **average shot length is an output of the edit, not an input to it.** ASL is a measurement — a film's runtime divided by its shot count — and treating a measured ASL from a reference video as a quota to hit is how an edit acquires cuts that carry no reason.

Walter Murch's Rule of Six is the classic statement of the same priority order: he weights the six criteria a cut must satisfy as **emotion 51%, story 23%, rhythm 10%, eye-trace 7%, two-dimensional plane of the screen 5%, three-dimensional space of action 4%**. Rhythm — "it has been a while since the last cut" — is worth a tenth. It is not zero, which is why [[pace-visual-change-clock]] exists, but it never outranks whether the shot still has something to say.

This note owns the **upper** bound and the test that sets it. Its siblings own the other bounds: [[pace-visual-mush-ceiling]] owns the *floor* (no shorter than comprehension allows), [[pace-visual-change-clock]] owns the *maximum gap between visual changes*, and [[pace-cut-density-from-viewer-intent]] picks the target band the whole video sits in. The resolution between this note and the change clock is the source's own next sentence: when a shot is still interesting but the frame has gone stale, **you add a change without cutting** — see [[pace-overlay-instead-of-cut]] and [[motion-image-focal-point-direction]].

## When to use it
Run it as Pass 3 of Mode B, after motivated cuts and before rhythm normalisation, and run it in Mode A whenever the temptation is to copy a reference's shot-length histogram directly. Specifically:

- A design row proposes a cut whose Motivation column says only "pacing", "keep it moving", or "it had been a while". That row is this note's business.
- The rough cut has a passage where the picture is cutting faster than the narration introduces ideas.
- A brief says "make it snappier" and the instinct is to cut the existing shots shorter rather than remove whole shots. Shortening is the wrong operation; removal is usually the right one ([[pace-subtractive-first-pass]]).
- A single shot runs past 10 seconds and someone wants to break it up. Do not break it up until the interest test below has actually failed.

Do **not** use it to defend long holds in a format whose stimulation budget is closed against them ([[struct-stimulation-budget]]), and do not use it to override the comprehension floor: a shot that is still interesting at frame 6 is still illegal at frame 6.

## How to recognise it in a reference video
You are looking for evidence that the editor's shot lengths track content rather than a metronome. Four observable signatures, all measurable.

- **Shot-length distribution shape.** Cut-detect the reference, then histogram the durations.
  - **Interest-led editing produces a wide, right-skewed distribution**: a coefficient of variation (σ/mean) **above ~0.8**, a p90/median ratio **above ~2.5**, and a visible long tail of 8–30 s shots living inside an otherwise dense edit.
  - **Metronomic editing produces a narrow distribution**: CV **below ~0.45**, p90/median **under 1.8**, and a mode spike. A mode spike at a round number (exactly 2.0 s, exactly 60 frames) is the strongest single tell that shots were cut to a target.
- **The long shots are the interesting ones, not the boring ones.** Pull every shot above the p90 length and check what is in it. In an interest-led edit the long shots contain a demonstration, a screen recording, a punchline building, a reveal, or dense on-screen motion. In a metronomic edit the long shots are simply the ones the editor ran out of B-roll for — static A-roll with no motion event.
- **Intra-shot motion energy stays above the floor for the shot's whole length.** This is the mechanical version of "still interesting". Compute per-frame inter-frame difference energy and check it does not flatline inside a long shot:
  ```bash
  ffmpeg -i ref.mp4 -vf "tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=-" -f null - 2>/dev/null
  ```
  Read the `YAVG` series (0–255 scale). A shot whose YAVG sits **below ~2.0 for more than 4 continuous seconds** is a dead hold — no camera move, no subject motion, no animation. If dead holds like that are absent from long shots, the editor is honouring this rule. If a long shot *is* dead, look for an overlay or scale change carrying it before you call it a mistake.
- **New-information rate from the transcript.** Align the timecoded transcript to the shot boundaries and count **new content words** (nouns/verbs not used in the preceding 20 s) per shot second. An interest-led edit sustains roughly **0.4–1.0 new content words per second** across long shots; a shot whose rate falls below **0.15/s** for over 3 s and carries no visual event is exhausted.
- **Retention data, where available.** YouTube's absolute audience-retention graph reads dips as *"viewers are abandoning or skipping at that specific part"* and flat runs as sections watched completely. A **flat run across a long shot is direct proof** the shot was interesting for its whole length; a dip that starts inside a shot and not at its boundary localises the exhaustion point to the frame. Note the report needs 60+ seconds of runtime and 100+ views before key moments appear, so treat it as confirmation, never as the primary signal.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `max_shot_length_without_reason` | 10.0 s (300 f) | 4–90 s | The source's explicit permission. Past this, the design row must name what is interesting; it does not need to shorten. |
| `dead_hold_ceiling` | 4.0 s (120 f) | 2.0–8.0 s | Longest run of sub-floor motion energy allowed before a change is required. Add motion, do not cut. |
| `motion_floor_YAVG` | 2.0 | 1.0–4.0 | Mean luma of the tblend-difference frame, 0–255. Below this the frame is effectively still. Raise for grainy footage. |
| `new_info_rate_floor` | 0.15 words/s | 0.10–0.35 | New content words per second over a 3 s window. Below the floor with no visual event = exhausted shot. |
| `interest_recheck_interval` | 2.0 s (60 f) | 1.0–4.0 s | Cadence at which the audit re-evaluates a running shot. |
| `retention_dip_threshold` | 2.0 pp below local 5 s trend | 1–4 pp | Only meaningful with ≥100 views and ≥60 s runtime. |
| `cv_target` | ≥ 0.8 | 0.5–1.6 | Coefficient of variation of shot lengths for the finished edit. Below 0.45 means you cut to a metronome. |
| `p90_over_median_target` | ≥ 2.5 | 1.8–4.0 | Long-tail health check on the finished edit. |
| `min_removal_unit` | whole shot | — | When pace must increase, remove entire shots. Never trim every shot by a uniform percentage. |

## Reproduction prompt

```
Audit and set shot lengths for {{SECTION}} by interest, not by a target ASL.
Inputs: the cut list with in/out frames at 30fps, the timecoded transcript,
and the assembled picture.

1. For every shot, compute three numbers and write them into the design doc:
   (a) length in frames;
   (b) motion energy - run
       ffmpeg -i {{PICTURE}} -vf "tblend=all_mode=difference,signalstats,
       metadata=print:key=lavfi.signalstats.YAVG:file=-" -f null -
       and record the longest continuous run, in frames, where YAVG < 2.0;
   (c) new-information rate - new content words per second from the
       transcript over the shot's span, where "new" means not used in the
       preceding 20 seconds.
2. Mark a shot EXHAUSTED only if BOTH (b) exceeds 120 frames AND (c) falls
   below 0.15 words/s for 90 or more continuous frames. One alone is not
   enough: a still frame under dense narration is fine, and a silent
   demonstration with strong motion is fine.
3. For every EXHAUSTED shot, choose in this order and record the choice:
   (i) DELETE the exhausted tail - trim the out point to the last frame
       that still passed, snapped to the nearest clause boundary in the
       transcript;
   (ii) ADD A CHANGE without cutting - a scale or position move on the clip
        wrapper, an overlay, or a punch-in - if the audio must keep running;
   (iii) CUT AWAY to a different visual only if neither of the above serves
         the content.
4. Do NOT shorten any shot that is not marked EXHAUSTED, for any reason,
   including hitting a target average shot length. If a reviewer asks for
   more pace, remove whole shots instead and re-run step 1.
5. Enforce the floor: after any trim, no shot carrying new information may
   be shorter than 20 frames.
6. ACCEPTANCE TEST: recompute the shot-length distribution for {{SECTION}}.
   Coefficient of variation must be >= 0.8 and p90/median >= 2.5; a mode
   spike at a single exact duration is a failure. Then confirm zero shots
   remain marked EXHAUSTED, and confirm every shot longer than 300 frames
   has a one-line reason recorded in the Motivation column.
```

## Execution spec

**HyperFrames.** A shot's length is `data-duration` in **seconds** — there is no frame attribute, so convert at authoring time (300 f @30fps = `10.0`). Lengthening or shortening a shot is an attribute edit, not a media operation, because the clip plays a sub-window of its source via `data-media-start` + `data-duration`:

```html
<!-- 10.0s = 300f @30fps. Interesting for its whole length: screen recording with continuous motion. -->
<video id="shot-demo" src="assets/demo.mp4" muted playsinline class="clip"
       data-start="42.0" data-duration="10.0" data-media-start="3.5" data-track-index="0"></video>
```

Two consequences worth writing into any spec:

- The visibility window is **half-open** — `[start, start + duration)` — so two shots authored back to back (`b.start === a.start + a.duration`) share no frame. A trim of the exhausted tail is just a smaller `data-duration` on the outgoing clip and a smaller `data-start` on the incoming one.
- Option (ii) — add a change instead of cutting — is a GSAP tween on the **clip wrapper**, positioned in absolute composition seconds on the single paused timeline. Use `fromTo`, never `from` (`from()` sets `immediateRender: true` and writes its start state before the clip's window opens, which flashes under the render engine's non-linear seek). Spatial motion uses transform aliases only:

```js
// Slow push-in across a 10s hold: 1.00 -> 1.08 scale, starting 1.2s into the shot.
tl.fromTo("#shot-demo",
  { scale: 1.0 },
  { scale: 1.08, duration: 7.0, ease: "sine.inOut" },
  43.2                       // absolute composition seconds, not a delay
);
```
`sine.inOut` is the house ease for long, calm, ambient drift. Land the tween **before** `data-duration` elapses, or its last frame is never rendered. Do not put a CSS `transform` on the same element — that is `gsap_css_transform_conflict`, a lint **error**, and a lint error silently switches off the layout and contrast audits.

**ffmpeg.** Measurement only; this rule never requires a re-encode.
```bash
# 1. cut candidates
ffmpeg -i ref.mp4 -vf "select='gt(scene,0.3)',showinfo" -vsync vfr -f null - 2>&1 | grep showinfo
# 2. intra-shot motion energy (the dead-hold detector)
ffmpeg -i ref.mp4 -vf "tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=-" -f null -
```
Only cut a physical file when the deliverable leaves the composition. If you do, drop `-c copy`: stream copy snaps to keyframes and on sparse-keyframe footage *"can silently swallow the whole cut"*.

**Epidemic Sound.** Not a sourcing rule. The one interaction: if a long hold is being carried by a bed, do not let the bed's phrase structure dictate the shot's out point — resolve that in [[pace-cut-on-the-beat]], where B-roll snaps to the grid and content-led shots are explicitly marked and left alone.

**Remotion:** frames are the native unit there, so a shot length is a frame count on a `<Sequence durationInFrames>`; the rule is identical, only the unit changes. Not present in this project.

## Pairs with
[[pace-visual-mush-ceiling]] · [[pace-visual-change-clock]] · [[pace-cut-density-from-viewer-intent]] · [[pace-overlay-instead-of-cut]] · [[pace-subtractive-first-pass]] · [[motion-image-focal-point-direction]] · [[cut-punch-in-emphasis]] · [[struct-stimulation-budget]] · [[cut-hard-cut-for-new-information]] · [[pace-silent-demonstration-window]]

## Failure modes
- **Copying a reference's ASL as a target.** The reference's ASL is the *result* of its content. Reproducing the number without the content produces cuts with no motivation and a mode-spiked histogram. Fix: reproduce the *distribution shape* (CV, p90/median) and let content set individual lengths.
- **Uniform percentage trimming.** Taking 15% off every shot to "tighten" a section shortens the interesting shots and leaves the boring ones proportionally as long. Fix: remove whole shots, or trim only the shots the audit marked exhausted.
- **Using the rule to defend a dead hold.** "It is interesting" is not an assertion an agent may make on its own authority. Fix: the audit's three numbers are the evidence; a long shot with sub-floor motion energy *and* sub-floor information rate is exhausted regardless of anyone's opinion.
- **Trimming to the frame instead of to the clause.** Cutting the exhausted tail mid-word leaves an audible stub. Fix: snap the new out point to the nearest transcript clause boundary, then apply the split-edit policy from [[cut-l-audio-trails-picture]] if picture must leave earlier than sound.
- **Confusing "interesting" with "moving".** A shaky handheld shot has high motion energy and no information. Fix: both tests must fail before a shot is exhausted, and both must pass before a shot is defended.
- **Known gap:** this stack has no shot-boundary metadata and no retention data. Cut boundaries come from `select='gt(scene,0.3)'`, which misses cuts between visually similar shots and invents cuts on fast pans, and retention curves are external to the pipeline entirely. Record the detected boundary list in the design document and eyeball the extracted frames before trusting any per-shot number derived from it.
