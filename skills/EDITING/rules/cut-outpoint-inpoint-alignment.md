---
id: cut-outpoint-inpoint-alignment
title: Align the out point of shot A to the in point of shot B — the frame-accurate procedure
skill: editing
type: cut
family: action-match
tags: [skill/editing, type/cut, family/action-match, engine/ffmpeg, engine/hyperframes, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:06"
    quote: "Basically, when the out point of shot A matches the in point of shot B, it creates a seamless transition."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:14"
    quote: "Cutting on action is another very common technique used by editors, and it helps make the cuts feel smoother and more natural to the viewer."
research_refs:
  - https://en.wikipedia.org/wiki/Cutting_on_action
  - https://en.wikipedia.org/wiki/30-degree_rule
  - https://bop.unibe.ch/JEMR/article/download/2264/3460
  - https://www.filmsupply.com/articles/cutting-on-action-editing/
  - https://www.soundstripe.com/blogs/the-invisible-editor-a-guide-to-continuity-editing-for-film-and-video
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: high
detectable_from: video
---

# Align the out point of shot A to the in point of shot B — the frame-accurate procedure

## What it is
The source states the acceptance test for a seamless join in one line — *"when the out point of shot A matches the in point of shot B, it creates a seamless transition"* — and this note is the **procedure that produces those two frame numbers**. It is deliberately mechanical: establish a common time base for the two shots, map the action's arc in each, compute a candidate pair of points, slide it inside a bounded search window until the continuity measurements pass, verify the two prerequisite geometry rules, then convert the winning frame numbers into the seconds the composition actually consumes. Why it deserves its own note: [[cut-on-action]] owns *why* the device works and how to detect it, [[cut-movement-match]] owns the vector-matching variant across unrelated shots, and both assume you can already find the frames. On real footage — two takes, two cameras, mismatched frame rates, no slate — finding the frames is most of the work, and doing it by scrubbing is exactly how an unattended pipeline produces a stutter.

## When to use it
Whenever a cut's quality depends on a specific *frame* rather than a specific second: cutting on action, a movement match, a graphic match where a shape must land in place, joining two takes of the same demonstration, a beat-locked montage cut, or any repair of a boundary that reads as a stutter or a jump. Run it also as the second attempt after an eyeballed cut fails review — a boundary that "nearly works" is almost always 2–6 frames off, not wrong in kind. Skip it for cuts whose motivation is dialogue or structure: a cut at a sentence boundary or a section break tolerates ±3 frames and does not repay the effort. The procedure assumes **handles** — extra source either side of the intended cut. If the footage was cut to length before it reached you, say so in the design document rather than pretending precision you cannot have.

## How to recognise it in a reference video
You are detecting whether the reference was cut with frame discipline, which shows up as *consistency* rather than as any single boundary.

- **Measure the elision at every action boundary.** Track the moving element's position across the cut and express the discontinuity in frames of action: negative = frames of action repeated (overlap), positive = frames skipped (elision). Log the distribution.
- **A frame-disciplined edit has a tight distribution.** Typically **+2 to +4 f of elision**, standard deviation under about 2 f, and **no boundary with more than 2 f of overlap** — a repeated frame of action reads as a stutter, a small elision reads as nothing. A scattered distribution from −6 to +10 f is a scrubbed edit.
- **Check for a shared time base.** In multi-camera reference material, the same diegetic transient (a clap, a door, a tool click) appears in both angles. Extract it in each and compare its offset from the cut. If the offset is consistent across several boundaries, the editor synced once and cut from a locked timeline; if it wanders, each cut was placed by hand.
- **The two prerequisite geometry checks.** Camera position must differ by **more than 30°** (or shot size by a full step), and screen direction must be preserved across the boundary. A boundary that passes the action match but fails either of these was aligned without verification — a common signature of automated cutting.
- **Frame-rate discipline.** Extract `r_frame_rate` for the whole reference and check for conform artefacts at boundaries: a 60→30 conform shows as doubled or dropped frames near cuts, and a 25→30 conform shows as periodic stutter that has nothing to do with the edit. Rule any frame counts you measure through the real fps before comparing them with this note's numbers.
- **Handle evidence.** Where a reference contains the same take twice (a repeated demonstration, a callback), compare which frames were used. Overlapping usage means the editor had handles and chose; abutting usage means the source was pre-trimmed.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `action_skip` | +3 f (0.10 s) | +2 to +6 f | Frames of action **elided** across the boundary; incoming angle picks up further along. Sign convention shared with [[cut-on-action]]. |
| `action_overlap_max` | 2 f | 0–2 f | Repeated frames of action. Above 2 f reads as a stutter. |
| `search_window` | ±8 f (±0.27 s) | ±4–15 f | How far the boundary may slide while hunting a passing match. |
| `handle_frames` | 8 f (0.27 s) | 4–15 f | Extra source required either side. Below 4 f the procedure cannot run. |
| `arc_position` | 0.45 of the movement | 0.30–0.60 | Candidate cut position within the action, in both shots. |
| `sync_tolerance` | ±1 f | ±0–2 f | Accuracy required of the shared-transient alignment. |
| `min_angle_change` | 30° | 30–120° | The 30-degree rule; a ≥20% shot-size change is a partial substitute. |
| `velocity_tolerance` | ±25% | ±10–40% | On-screen px/frame of the tracked element, measured **after** conform. |
| `centroid_tolerance` | 12% of frame width | 5–15% | 230 px at 1920 wide. |
| `frame_to_seconds` | `(frame + 0.5) / fps` | — | The conversion the composition needs; the half-frame offset stops a rounding error selecting the neighbour. |
| `iterations_max` | 17 | 9–31 | Candidate positions tried (a ±8 f window is 17 positions). Beyond this, the coverage is the problem, not the alignment. |

## Reproduction prompt

```
Produce the frame numbers for a seamless join between shot A and shot B at
30fps, then convert them for the composition.

STEP 0 - PROBE. For BOTH shots:
  ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate,nb_frames,duration -of json <src>
If the two fps differ, conform one first and re-probe; every frame count below
is meaningless across mismatched rates. Confirm you have at least 8 frames of
handle either side of the intended cut in both shots. If not, stop and report
that the footage cannot support a frame-accurate join.

STEP 1 - COMMON TIME BASE.
 (a) Same event, two cameras: find a shared transient (slate clap, latch,
     impact). Get its frame in each shot from a one-frame-resolution RMS trace
     (n=1600 samples at 48kHz == 1 frame at 30fps):
       ffmpeg -i <src> -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
       ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
     OFFSET = transient_frame_A - transient_frame_B. Verify by checking a
     second transient: the two offsets must agree within 1 frame.
 (b) Two separate takes (no shared sound): use the action itself. The common
     zero in each shot is the first frame where the tracked element starts to
     move.

STEP 2 - MAP THE ARC. In each shot log S (first frame of movement) and
E (frame where the movement completes). Candidate points:
  A_out = S_A + round(0.45 * (E_A - S_A))
  B_in  = S_B + round(0.45 * (E_B - S_B)) + {{SKIP}}     ; {{SKIP}} default +3

STEP 3 - VERIFY AT THE BOUNDARY. Export A frame A_out and B frame B_in:
  ffmpeg -i A.mp4 -vf "select='eq(n\,A_out)'" -vsync 0 -frames:v 1 a_out.png
  ffmpeg -i B.mp4 -vf "select='eq(n\,B_in)'"  -vsync 0 -frames:v 1 b_in.png
Measure the tracked element in both and require ALL of:
  - direction of travel differs <= 20 degrees
  - on-screen speed differs <= 25% (px/frame, measured after conform)
  - centroid moves <= 12% of frame width (230px at 1920)
  - motion blur present on both frames or on neither
  - action progresses by +2..+6 frames (never backwards by more than 2)
  - camera position differs by > 30 degrees, or shot size by a full step
  - screen direction unchanged

STEP 4 - SEARCH. If any check fails, slide the pair within +/-8 frames:
first move B_in alone (cheapest), then A_out, then both. Try at most 17
positions. Keep the first pair that passes every check; if none passes,
report that this coverage does not support the join and fall back to a
straight cut on a clause boundary or a covered insert.

STEP 5 - CONVERT AND RECORD. seconds = (frame + 0.5) / fps.
  A's clip:  data-media-start = (A_out - A_duration_frames + 0.5)/30 ... or,
             more simply, keep A's existing media-start and set A's
             data-duration so that its last played frame is A_out.
  B's clip:  data-media-start = (B_in + 0.5)/30
  B's data-start = A's data-start + A's data-duration   (exact abutment;
             the visibility window is half-open so no frame is shared)
Record in the design document: A_out, B_in, skip, fps, and which checks were
marginal.

ACCEPTANCE TEST: (a) frame-step the boundary - the action continues, with no
repeated frame and no jump larger than 12% of frame width; (b) at 1x a
first-time viewer cannot name the cut frame; (c) the two shots are visibly
different vantage points; (d) re-probe the rendered segment and confirm the
cut lands on the intended frame, not its neighbour.
```

## Execution spec

**ffmpeg — this note is mostly ffmpeg.** Four operations, in the order the procedure needs them.

```bash
# 1. probe (never skip; every threshold is fps-relative)
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate,nb_frames,duration -of json A.mp4

# 2. shared-transient sync, one-frame resolution (n=1600 @48kHz == 1 frame @30fps)
ffmpeg -i A.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null | head -40
# builds carrying the axcorrelate filter can cross-correlate the two tracks directly instead

# 3. arc mapping via per-frame change energy (threshold high so nothing is flagged as a cut,
#    leaving a clean lavfi.scd.mafd trace to read the movement's onset and peak from)
ffmpeg -i A.mp4 -vf "scdet=t=100,metadata=print:file=-" -f null - 2>/dev/null | grep -E "pts_time|mafd"

# 4. candidate frame export, and the frame pair for verification
ffmpeg -i A.mp4 -vf "select='between(n\,404\,420)',showinfo" -vsync 0 a_%03d.png
ffmpeg -i B.mp4 -vf "select='eq(n\,88)'" -vsync 0 -frames:v 1 b_in.png
```
Two traps the contract names explicitly. **Stream copy is not frame-accurate**: `-c copy` cuts only on keyframes and on sparse-keyframe footage the snap *"can silently swallow the whole cut"* — `transcript-cut.mjs` measures this and reports `copy_drift`, and the guidance is to *"drop `--copy` for frame-accurate cuts"*. And **conform before you measure**: `data-playback-rate` is a constant in `0.1..5` with **no rate envelope**, so any variable retime has to be preprocessed into a derived asset; the global arithmetic is *consumed source = timeline duration × rate*.

**HyperFrames — the conversion step, which is where frame work usually dies.** There is **no frame-based attribute**: `data-start`, `data-duration` and `data-media-start` are all **seconds**, and `data-fps` is only a hint the CLI can override. Convert with `seconds = (frame + 0.5) / fps`.

```html
<!-- fps 30. A plays out on source frame 412; B enters on source frame 88 (=B_in with +3 skip).
     A: media-start 10.75s, duration 3.00s  -> last played source frame = 412
     B: media-start (88 + 0.5)/30 = 2.95s -->
<video id="shot-a" src="assets/A.mp4" muted playsinline class="clip"
       data-start="5.00" data-duration="3.00" data-media-start="10.75" data-track-index="0"></video>
<video id="shot-b" src="assets/B.mp4" muted playsinline class="clip"
       data-start="8.00" data-duration="4.00" data-media-start="2.95" data-track-index="0"></video>
```
- **Exact abutment is safe:** the window is half-open `[start, start + duration)`, so `b.start === a.start + a.duration` yields no shared and no dropped frame.
- **Do not use relative timing for a frame-critical cut.** `data-start="shot-a"` reads well but has four silent-zero failures (spaces around the operator are mandatory — `shot-a-0.5` parses as an id; an unresolved id resolves to 0; a target with no resolvable duration lands on its *start*; a cycle resolves to 0), and none of them are linted. Author the literal seconds.
- **Audio must be given the same numbers twice.** There is **no automatic waveform sync or drift correction**; when a separate `<audio>` carries the shot's sound it needs the same `data-start` / `data-duration` / `data-media-start` (and `data-playback-rate`) as its picture.
- **Verify off-host.** `snapshot`, `preview` and `render` are browser-dependent and the authoring VM is ARM64 without sudo, so the "did it land on the intended frame" check runs wherever the render runs — plan for it rather than asserting the cut is correct because the numbers are.

**Epidemic Sound.** Not involved in alignment. If the boundary needs a sound at all, it is the action's own diegetic sound, and it belongs to [[cut-on-action]]'s spec, not to this procedure.

**Remotion:** conceptually `startFrom` / `endAt` on two `<Sequence>`s, which is genuinely frame-based; no Remotion runtime exists in this project, and porting a spec written in frames into HyperFrames means running every value through `(frame + 0.5) / fps`.

## Pairs with
[[cut-on-action]] · [[cut-movement-match]] · [[cut-graphic-match]] · [[cut-eye-trace-continuity]] · [[cut-invisible-storytelling-doctrine]] · [[pace-cut-on-the-beat]] · [[pace-partial-pause-removal]]

## Failure modes
- **Measuring frames across mismatched frame rates.** A frame index means nothing until both shots share an fps. Fix: probe first, conform, re-probe, then measure.
- **Overlapping instead of eliding.** Repeating 4 frames of the same movement is a visible stutter; skipping 3 is invisible. Fix: keep `action_skip` positive, cap overlap at 2 f.
- **Aligning without the geometry checks.** A perfect action match at 10° of camera change is a jump cut. Fix: the 30-degree and screen-direction checks are part of the acceptance test, not optional extras.
- **`-c copy` on a frame-accurate cut.** Keyframe snapping moves your carefully chosen frame by up to a second. Fix: re-encode, or use `transcript-cut.mjs` without `--copy` and read `copy_drift`.
- **Forgetting the half-frame offset.** `frame/fps` sits exactly on a boundary and rounding can select the neighbouring frame; every boundary in the video is then one frame out in an unpredictable direction. Fix: `(frame + 0.5) / fps`, always.
- **Searching forever.** More than about 17 candidate positions means the two shots do not cover the same action well enough. Fix: stop, and either re-shoot coverage or choose a different cut type.
- **Aligning picture and leaving sound behind.** The picture is frame-perfect and its audio is 3 frames out, which is worse than both being loose. Fix: write the same numbers on the `<audio>` element.
- **Known gap:** the stack has **no automatic sync, no drift correction, no multicam primitive and no frame-based timing attribute**. Every part of this procedure is manual arithmetic the note makes explicit, and there is no gate that will catch an off-by-one — `hyperframes check` has nothing to say about whether a cut landed on the right frame.
