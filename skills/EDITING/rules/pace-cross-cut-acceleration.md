---
id: pace-cross-cut-acceleration
title: Accelerate the cross cut — shorten each strand segment as the two lines converge
skill: editing
type: pacing
family: parallel-action
tags: [skill/editing, type/pacing, family/parallel-action, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:44"
    quote: "This is a common technique used in thriller style movies."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:37"
    quote: "Cross cutting is when the editor is cutting back and forth between multiple scenes, usually at the same time."
research_refs:
  - https://www.studiobinder.com/blog/cross-cutting-parallel-editing-definition/
  - https://www.nfi.edu/cross-cutting/
  - https://www.academia.edu/610782/How_Act_Structure_Sculpts_Shot_Lengths_and_Shot_Transitions_in_Hollywood_Film
  - https://fiveable.me/film-and-media-theory/key-terms/average-shot-length
  - https://en.wikipedia.org/wiki/Post-classical_editing
difficulty: high
detectable_from: video
---

# Accelerate the cross cut — shorten each strand segment as the two lines converge

## What it is
Cross cutting establishes that two things are happening at once ([[struct-cross-cutting-parallel-action]]). This note is the **rhythm** that turns that structure into suspense. The tension does not come from the interleaving itself — it comes from the interleaving getting **faster** as the strands approach each other. Each time you return to a strand you give it less time than last time, so the audience is handed the two lines in ever-shorter bursts until they collide. That acceleration is not a metaphor: empirical shot-length work on Hollywood film finds shot lengths shortening systematically toward the end of an act, so an accelerating cutting rate is a measurable property of climaxes. It is also why the device belongs to thrillers — the audience knows the two lines are converging and the characters do not, and the shrinking segments are the clock.

## When to use it
Any convergence the audience can anticipate: a chase, a rescue, a countdown, a heist against a guard patrol, a deadline, a race, an argument about to be overheard. In non-fiction the same shape works for a demonstration against a stopwatch, a build against a deadline, or a claim cut against the evidence that will contradict it. Two preconditions. **(1) The audience must know both strands.** Acceleration is only tense if the viewer already understands what is at stake in each line; the first cycle or two exist to establish that, and they should be *long*. **(2) There must be a convergence.** An accelerating cross cut that never resolves is exhausting and reads as a technical tic. Do not use it where the two strands are thematically rather than causally related — that is parallel editing for comparison, and it wants steady, not accelerating, segments.

## How to recognise it in a reference video
- **Build the segment table.** Detect cuts, then label each segment `A` or `B` by strand (location, palette, character, lens). Log segment durations in order.
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ```
- **Compute the acceleration ratio.** Divide each cycle's mean segment length by the previous cycle's. A designed acceleration sits at **0.75–0.85** per cycle — a geometric decay, not a linear one. A ratio of 1.0 is steady parallel editing, not a tension build; below 0.6 the sequence burns out in three cycles.
- **Find the floor.** The shortest segments before convergence. Thriller sequences bottom out around **12–24 f (0.4–0.8 s)** per strand. Below ~10 f the strands stop being readable as separate places and the sequence turns into a blur.
- **Find the opening length.** First cycle segments run **90–180 f (3–6 s)** — long enough to (re)establish each world.
- **Cycle count.** Typically **4–8** alternations before the convergence. Fewer and the acceleration is not felt; more and the audience gets ahead of it.
- **Look for the hold before the payoff.** A very common and very effective signature: the segment immediately before convergence *breaks* the pattern — either a held shot of **45–90 f** (the breath) or a total cut to silence. Log whether it is present; its absence usually means the sequence just stops.
- **Screen-time asymmetry.** Early cycles usually give the strands near-equal time; late cycles skew toward the strand that carries the threat. Compute the A:B time ratio per cycle and look for it drifting from ~1.0 toward 1.3–2.0.
- **Cutting rate as a curve, not a number.** Plot cuts per 10 s across the sequence. A tension build is a monotonically rising curve; an average shot length alone hides it.
- **Does the audio accelerate too?** Check whether the music's rate of event (hits, percussion density, riser) rises in step with the picture. If picture accelerates and sound does not, the sequence feels mechanical ([[sfx-cross-cut-audio-strategy]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `open_segment` | 120 f (4.0 s) | 90–180 f | First cycle, per strand. Long enough to re-establish the world. |
| `accel_ratio` | 0.80 | 0.75–0.85 per cycle | Geometric. Apply per cycle, not per cut. |
| `floor_segment` | 18 f (0.6 s) | 12–24 f | Shortest readable strand segment. Below ~10 f strands blur together. |
| `cycles` | 6 | 4–8 | Alternations before convergence. |
| `pre_convergence_hold` | 60 f (2.0 s) | 45–90 f | The breath that breaks the pattern immediately before the payoff. |
| `strand_ratio_open` | 1.00 | 0.9–1.1 | A:B screen time in the first two cycles. |
| `strand_ratio_close` | 1.50 | 1.2–2.0 | Skewed toward the threatening strand in the last two cycles. |
| `strands` | 2 | 2–3 | Three is the practical ceiling; each additional strand costs the audience a re-orientation on every return. |
| `reorient_frames` | 6 f | 4–9 f | Time at the head of each return segment before anything new happens, so the viewer re-locates. Do not cut a strand's first 6 frames away. |
| `convergence_frame` | — | — | The frame the two strands meet. Everything is measured backwards from here. |
| `cut_type` | straight | straight \| match | Straight cuts throughout; one match cut at the convergence is the classic payoff ([[cut-graphic-match]], [[cut-movement-match]]). |

## Reproduction prompt

```
Build an accelerating cross cut converging at {{CONVERGE}} (seconds,
30fps), interleaving strand A ({{A_SRC}}) and strand B ({{B_SRC}}).

1. WORK BACKWARDS from {{CONVERGE}}. Generate the segment schedule as a
   geometric series: cycle 1 segments are 120 frames each, and each
   subsequent cycle is 0.80x the previous, floored at 18 frames. With 6
   cycles that gives, per strand, approximately:
   120, 96, 77, 61, 49, 39 frames (4.00, 3.20, 2.56, 2.05, 1.63, 1.31 s).
   Round every value to a whole frame, then convert to seconds for
   authoring (frames / 30).
2. INSERT THE BREATH: replace the final segment before {{CONVERGE}} with
   a single held shot of 60 frames (2.00s) on the strand that carries the
   threat. This break in the pattern is what makes the convergence land.
   Do not skip it.
3. LAY OUT the schedule as alternating clips A,B,A,B... ending at
   {{CONVERGE}}, back to back with no gaps and no overlaps.
4. CHOOSE EACH SEGMENT'S CONTENT so that every return shows PROGRESS -
   something has changed in that strand since we left it. A return that
   shows the same state wastes the cycle. Keep the first 6 frames of each
   return re-orienting (a recognisable wide, the same character, the same
   palette) before anything new happens.
5. SKEW THE TIME: in the last two cycles give the threatening strand
   about 1.5x the screen time of the other.
6. AUDIO: one continuous music bed spans the entire sequence and does NOT
   cut with the picture. Ambience swaps per strand. See the paired sound
   note for levels.
7. RESOLVE at {{CONVERGE}} with a straight cut or a single match cut -
   never a dissolve, which un-tightens everything you just built.
8. ACCEPTANCE TEST: (a) list the finished segment durations in order -
   each cycle's mean must be 0.75-0.85x the previous, monotonically; (b)
   no segment is shorter than 12 frames; (c) the breath before
   {{CONVERGE}} is present and is at least 2x the segment before it; (d)
   watch it once: at every return you can say in one word where you are;
   (e) the music does not cut at any picture cut.
```

## Execution spec

**HyperFrames (primary).** The whole device is a schedule of `data-start` / `data-duration` values. Compute the geometric series at authoring time and write literal **seconds**; there is no frame attribute, and `data-fps` is only a hint the CLI can override.

```html
<!-- cycle 1: 120f = 4.00s each; cycle 2: 96f = 3.20s; ... convergence at 60.00 -->
<video id="x-a1" src="chase.mp4" muted playsinline class="clip"
       data-start="30.00" data-duration="4.00" data-media-start="12.00" data-track-index="0"></video>
<video id="x-b1" src="bomb.mp4"  muted playsinline class="clip"
       data-start="34.00" data-duration="4.00" data-media-start="3.00"  data-track-index="1"></video>
<video id="x-a2" src="chase.mp4" muted playsinline class="clip"
       data-start="38.00" data-duration="3.20" data-media-start="20.00" data-track-index="0"></video>
<!-- ... ping-pong the track index 0/1 so adjacent segments never share a lane ... -->
<video id="x-b6" src="bomb.mp4"  muted playsinline class="clip"
       data-start="58.00" data-duration="2.00" data-media-start="41.00" data-track-index="1"></video>
<!-- 2.00s = the 60f breath, immediately before the convergence at 60.00 -->
```
Contract points that matter:
- **The half-open window** `[start, start+duration)` means back-to-back clips (`b.start === a.start + a.duration`) share **no** frame — which is exactly a straight cut, and is what you want throughout.
- **`data-track-index` is display only.** It constrains nothing and is not read by the render; the 0/1 ping-pong is a readability convention borrowed from the transition injector. **Layering is CSS `z-index`.**
- **No render-time randomness.** Do not jitter the schedule with `Math.random()` — determinism bans unseeded randomness, and the schedule must be reproducible. Derive any variation from the cycle index.
- **`data-playback-rate` is a constant** in `0.1..5`; there is **no rate envelope**, so any speed ramp inside a strand must be preprocessed into a derived file.
- If a strand is a scene rather than a single source, prefer the **modular** layout — one sub-composition per strand segment — and keep the music at the host root so playback survives every scene cut.
- **Do not put a dissolve at the convergence.** Registry transitions exist (`crossfade`, `blur-crossfade`, `push-slide`, `zoom-through`, `squeeze`, `max_duration_s: 2.0`) but the whole point of the acceleration is that the cuts are hard; if you must mark the convergence, `zoom-through` at 0.3 s is the highest-energy option in the registry.

**Generating the schedule.** Do the arithmetic before authoring, not in the composition:
```bash
python3 - <<'PY'
open_f, ratio, floor_f, cycles, fps = 120, 0.80, 12, 6, 30
t = 30.0; segs = []
for c in range(cycles):
    d = max(floor_f, round(open_f * (ratio ** c)))
    for strand in ("A", "B"):
        segs.append((strand, round(t, 3), round(d / fps, 3))); t += d / fps
segs[-1] = (segs[-1][0], segs[-1][1], round(60 / fps, 3))   # the 60f breath
for s in segs: print(s)
PY
```

**ffmpeg — physical assembly**, only when the sequence leaves the pipeline:
```bash
# cut each segment, then concat in order
ffmpeg -i chase.mp4 -ss 12.00 -to 16.00 -c:v libx264 -crf 18 -an a1.mp4
ffmpeg -i bomb.mp4  -ss 3.00  -to 7.00  -c:v libx264 -crf 18 -an b1.mp4
printf "file '%s'\n" a1.mp4 b1.mp4 a2.mp4 b2.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy crosscut.mp4
```
Avoid `-c copy` on the individual cuts: stream copy snaps to keyframes and on sparse-keyframe footage can swallow a 12-frame segment entirely.

**Epidemic Sound.** One bed for the whole sequence, chosen for a rising arrangement rather than cut to fit: `SearchRecordings { query.term: "tense building percussion instrumental", filter: { bpm: { min: 110, max: 140 }, vocals: false } }`. The riser into the convergence: `SearchSoundEffects { query.term: "riser build tension", filter.duration { max: 4000 } }`. Levels and routing in [[sfx-cross-cut-audio-strategy]].

**Remotion:** an array of `<Sequence>`s generated from the same geometric series; not present in this project.

## Pairs with
[[struct-cross-cutting-parallel-action]] · [[sfx-cross-cut-audio-strategy]] · [[sfx-phone-call-cross-cut-treatment]] · [[cut-on-action]] · [[cut-movement-match]] · [[cut-graphic-match]] · [[pace-cut-on-the-beat]] · [[sfx-riser-to-music-drop-backtiming]] · [[pace-visual-change-clock]] · [[cut-straight-hard-cut]]

## Failure modes
- **Steady segments.** Interleaving at a constant length is parallel editing, not suspense; it reads as informative and slightly dull. Fix: apply the 0.80 ratio per cycle.
- **Accelerating too fast.** A ratio below 0.6 hits the floor in three cycles and then has nowhere to go, so the last third is flat at maximum speed. Fix: 0.75–0.85 and more cycles.
- **Cutting below the readability floor.** Under ~10 f per strand the audience loses track of which place they are in and the tension collapses into noise. Fix: floor at 12–18 f, and keep each return's first 6 frames re-orienting.
- **Returns with no progress.** Cutting back to the same state wastes a cycle and teaches the audience the strand is idle. Fix: every return must show a change.
- **No breath before the payoff.** The sequence simply stops at maximum speed and the convergence lands as an interruption. Fix: the 45–90 f held shot.
- **Music cut with the picture.** Restarting or hard-cutting the bed at strand changes destroys the illusion of simultaneity. Fix: one continuous bed across the whole sequence.
- **Three or four strands.** Every extra strand costs a re-orientation on every return, and the cycle length needed to stay legible fights the acceleration. Fix: two strands, three at most.
- **Dissolving into the convergence.** Softens the exact frame the whole sequence was built for. Fix: hard cut, or one match cut.
- **Known gap:** no tool in this stack labels which strand a shot belongs to. The segment table is produced by the analysis pass — `scdet` gives you the cut list, a human or a vision pass gives you the A/B labels.
