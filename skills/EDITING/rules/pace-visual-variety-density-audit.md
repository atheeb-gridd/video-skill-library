---
id: pace-visual-variety-density-audit
title: Count distinct things to look at per minute, not cuts per minute
skill: editing
type: pacing
family: visual-variety
tags: [skill/editing, type/pacing, family/visual-variety, engine/ffmpeg, engine/hyperframes, source/editing-kt, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:04"
    quote: "And here, there are only three different things to look at in an entire minute. Kind of boring. But if the video cut between A-roll, B-roll and other footage every few seconds, it would hold attention way better."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:16"
    quote: "That said, there's also a downside to switching what's on screen too often."
research_refs:
  - https://www.scenedetect.com/docs/latest/api/detectors.html
  - https://air.io/en/youtube-hacks/advanced-retention-editing-cutting-patterns-that-keep-viewers-past-minute-8
  - https://pixflow.net/blog/youtube-video-retention-editing/
  - https://monitoryt.com/blog/editing-for-retention
  - https://www.retentionrabbit.com/blog/2025-youtube-audience-retention-benchmark-report
  - https://nofilmschool.com/2018/08/editing-eye-trace-mind-rule-six-incorrect
difficulty: low
detectable_from: transcript+video
---

# Count distinct things to look at per minute, not cuts per minute

## What it is
A one-number diagnostic for "why is this boring" that is deliberately *not* cut density. You count how many **visually distinct things** the viewer is given to look at in a minute — distinct meaning a new image, not a return to one already used. The source's failing example is a minute containing only **three** distinct visuals; its prescription is a new visual "every few seconds", drawn from the four footage types it names (A-roll, B-roll, stock, motion graphics). The metric matters because cuts and variety come apart: an edit ping-ponging between two camera angles twenty times a minute has a cut density of 20 CPM and a variety density of **2**, and it is the 2 the viewer feels. Call the metric **DVPM** — distinct visuals per minute — and its companion **LSH**, the longest single-visual hold. It is the sibling of [[pace-visual-change-clock]] and must not be confused with it: the clock counts *change events* and enforces a ceiling on the gap between them, so a punch-in and a caption line both reset it; DVPM counts *how many different images exist*, deduplicated, so neither of those scores at all. A video can pass the clock and fail this audit — that is exactly the failing minute the source describes.

## When to use it
Run it as the second gate in a design pass, immediately after [[pace-cut-density-from-viewer-intent]] has set a target ASL and [[struct-stimulation-budget]] has set the format's ceiling. It is the correct diagnostic when: a section measures fine on cut rate but plays flat; a retention graph sags in the middle of an otherwise well-cut explainer; a talking-head edit has plenty of jump cuts and still feels static; or a reviewer says "nothing happens here" and cannot say why. It is also the right audit *before* sourcing B-roll, because DVPM tells you how many distinct visual assets a section actually requires — it converts "we need some B-roll" into a count. Do not run it as a target on companionship, ASMR, sit-down-podcast or performance formats, where low DVPM is the product; there the ceiling from the stimulation budget wins.

## How to recognise it in a reference video
- **Measure DVPM, do not estimate it.** Three steps: detect shot boundaries; take one representative frame per shot; cluster those frames perceptually so recurring visuals collapse to one entry. DVPM is the number of clusters whose first appearance falls inside the minute.
- **Detect boundaries mechanically.** `scdet` or the scene-score selector gives candidates; classify by eye afterwards.
  ```bash
  ffprobe -select_streams v:0 -show_entries stream=r_frame_rate,nb_frames -of csv ref.mp4
  ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ```
  If `scenedetect` is installed, `ContentDetector` (default threshold **27.0**, `min_scene_len` **15 frames**) is the better-behaved equivalent, and `AdaptiveDetector` (threshold **3.0**) suppresses the false positives that camera movement creates.
- **Collapse recurring visuals with a perceptual hash.** PySceneDetect's own `HashDetector` uses a **16×16 DCT hash with lowpass 2** and calls frames different above a normalised Hamming distance of **0.395**; for *sameness* clustering use a much tighter gate — **distance < 0.15** means "the viewer has seen this already", so a second A-roll shot on the same angle does not earn a point.
- **Count overlay events too.** A graphic, callout, inset or stat card appearing *without* a cut is a distinct thing to look at ([[pace-overlay-instead-of-cut]]). Shot detection will miss it, so scan for intra-shot change: on a locked-off shot, a step in mean absolute frame difference with no `scdet` hit is an overlay event.
- **Score the four footage types.** For each distinct visual, tag it `a-roll | b-roll | stock | graphic | screen-capture | still`. A minute of six distinct visuals that are all A-roll angles is a different (worse) result than six spread across three types. Log the type histogram, not just the count.
- **Log LSH.** The longest continuous stretch with no new distinct visual. In the source's failing example, LSH is roughly **20 s**. An explainer with LSH over **12 s** outside a deliberate demonstration window has a hole in it.
- **Bands observed in published practice** (all soft — see Failure modes): creator/short-form guidance clusters at a visual change every **5–7 s** (≈9–12 DVPM); age-segmented long-form guidance at **15–25 s** for 13–24 and **20–40 s** for 25+ audiences (≈2.5–4 DVPM); intro sections tighten to **10–20 s** between changes. The source's own "boring" reading — **3 DVPM** — sits exactly in the slow band, which is the tell that this is a genre argument, not a universal law.
- **Transcript cross-check.** Mark every noun the narration names that has no matching visual within ±2 s. A high count with a low DVPM is the diagnosis "the words are doing all the work" and simultaneously the B-roll shopping list.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `dvpm_target` | 12 | 3–24 | Distinct visuals per minute. Retention-forward explainer 10–16 · standard talking head 6–10 · companionship/vlog 2–5 · montage 20–40. |
| `dvpm_floor` | 4 | 3–6 | At or below this the source's verdict applies: "kind of boring". Below 3 the video is a slideshow with a voice. |
| `dvpm_ceiling` | 24 | 18–40 | Above this, novelty stops registering as information and reads as churn. Also raises the [[struct-stimulation-budget]] question. |
| `visual_change_interval` | 5 s (150 f) | 3–25 s | Derived: 60 ÷ `dvpm_target`. This is the number a design document actually consumes. |
| `lsh_max` | 12 s (360 f) | 6–90 s | Longest hold with no new distinct visual. Demonstration windows are exempt and must be marked as such ([[pace-silent-demonstration-window]]). |
| `dedupe_distance` | 0.15 | 0.08–0.25 | Normalised Hamming distance on a 16×16 DCT hash below which two frames count as the *same* visual. |
| `boundary_threshold` | 27.0 (ContentDetector) / `scdet=t=12` | 20–35 / 8–18 | Detection sensitivity for shot boundaries. |
| `min_shot_len` | 15 f (0.5 s) | 8–30 f | Below this a "shot" is usually a flash frame or a graphic pop, not a shot. |
| `type_spread_min` | 3 | 2–5 | Distinct footage *types* per minute. 6 visuals from one type fails this even at target DVPM. |
| `overlay_share` | 0.35 | 0.1–0.6 | Fraction of distinct visuals delivered as overlays rather than cuts. High values preserve A-roll delivery. |

## Reproduction prompt

```
Audit and then fix visual variety density for {{SECTION}} of the timeline
(30fps; all frame counts below assume 30fps - re-scale if ffprobe says
otherwise).

STEP 1 - MEASURE. For each 60s window of {{SECTION}}:
  a. Detect shot boundaries:
     ffmpeg -ss {{IN}} -to {{OUT}} -i {{REF}} -vf "scdet=t=12,metadata=print" -f null -
  b. Export one frame from the middle of every detected shot.
  c. Reduce each frame to a 16x16 DCT perceptual hash. Cluster frames whose
     normalised Hamming distance is < 0.15 - these are the SAME visual.
  d. Add one entry for every overlay/graphic that appears without a cut.
  e. DVPM = number of clusters first appearing in that window.
     LSH  = longest run of seconds with no new cluster.
  f. Tag every cluster: a-roll | b-roll | stock | graphic | screen-capture | still.
Report a table: window | DVPM | LSH | type histogram.

STEP 2 - DIAGNOSE. Flag any window with DVPM <= 4, or LSH > 360 frames (12s),
or fewer than 3 footage types. Do not flag windows the design document marks
as demonstration or companionship.

STEP 3 - FIX, cheapest first. For each flagged window, target
DVPM = {{DVPM_TARGET}} (default 12), i.e. one new visual every
{{INTERVAL}} = 150 frames (5.0s):
  1. Overlay before cut: add a callout, inset, stat card or treated still over
     the running A-roll (no cut, delivery preserved).
  2. B-roll insert on an existing sentence boundary, entered as an L cut so the
     narration runs under it - never a hard picture-and-sound cut.
  3. Motion graphic for any beat the narration explains but the picture does not.
  4. Punch-in on A-roll counts as HALF a distinct visual: it refreshes the
     frame but not the content. Never use it to hit the number twice in a row.
Do NOT reach the number by adding cuts between two existing angles - that
raises cuts/min and leaves DVPM unchanged, which is the exact failure this
audit exists to catch.

ACCEPTANCE TEST: re-run STEP 1. Every window is within
[{{DVPM_TARGET}} - 3, {{DVPM_TARGET}} + 6], LSH <= 360 frames, >= 3 footage
types per minute, and no cluster is reused more than 3 times in the section.
Every added visual must have a row in the design document with a reason; a
visual added only to hit the count is a row a reviewer should delete.
```

## Execution spec

**ffmpeg — the whole measurement, with no pip installs.** The device VM is ARM64 without sudo, so `scenedetect` / `auto-editor` may not be installable; this path uses only ffmpeg plus arithmetic.

```bash
# 1. real fps and frame count first — every threshold depends on it
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate,nb_frames,duration -of json ref.mp4

# 2. shot boundary candidates with timestamps
ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep -E "lavfi.scd.(score|time)"

# 3. one representative frame per second (cheap proxy when shot list is long)
ffmpeg -i ref.mp4 -vf "fps=1,scale=320:-1" -q:v 3 frames/f_%04d.jpg

# 4. dHash-able reduction of a frame: 9x8 grayscale raw bytes, compare adjacent
#    columns to build a 64-bit hash in whatever scripting you have to hand
ffmpeg -i frames/f_0042.jpg -vf "scale=9:8,format=gray" -f rawvideo -pix_fmt gray - | xxd -p

# 5. intra-shot overlay events: mean absolute frame difference trace
ffmpeg -i ref.mp4 -vf "select='gt(scene,0.02)',metadata=print" -f null - 2>&1 | grep pts_time
```
If `scenedetect` *is* available, prefer it: `scenedetect -i ref.mp4 detect-adaptive list-scenes` for boundaries and `detect-hash` for the dedupe, since its `HashDetector` already implements the 16×16/lowpass-2 hash this note's `dedupe_distance` is calibrated against.

**HyperFrames — the audit is also a static read of the composition, which is faster and exact.** Every visual is a clip with a `data-start` in seconds; distinct visuals are distinct `src` values plus distinct overlay clips.

```bash
# distinct media sources and their start times, straight out of the composition
grep -oE '<(video|img)[^>]*(src|data-start)="[^"]*"' index.html
grep -oE 'data-start="[0-9.]+"' index.html | sort -t'"' -k2 -n
```
Turn that into DVPM by bucketing `data-start` into 60 s windows and counting **first appearances of each `src`**. Two contract facts make this reliable: `data-start` is what marks an element as timed (so every visual event is enumerable), and `data-track-index` is display-only, so you must not infer layering or grouping from it. Sub-compositions hide their internals from a root-level grep — for a modular project, run the same count inside each `compositions/<scene>.html` and add the host's `data-start` to every scene-local value.

Fixing a flagged window in HyperFrames is one of three edits, in cost order: (1) an overlay clip added on a track above the running A-roll (`class="clip"`, its own `id`, `data-start`/`data-duration` in seconds, entrance authored as `gsap.fromTo` — never `from`, which writes its start state at construction time and flashes under non-linear seek); (2) a B-roll `<video muted playsinline>` clip butted into the picture track with the narration `<audio>` untouched (that is an L cut — [[cut-l-audio-trails-picture]]); (3) a new sub-composition for a motion-graphic beat. Remember the half-open window `[start, start+duration)`: two clips authored back to back with `b.start === a.start + a.duration` share no frame.

**Epidemic Sound.** Not the primary tool here, but a raised DVPM changes the sound pass: every added overlay or insert needs a motion sound ([[sfx-unsounded-motion-audit]]), so budget one `SearchSoundEffects` fetch per added visual and check the total against [[sfx-sound-pass-order]] before adding twenty.

**Remotion:** conceptually the same count over `<Sequence>` starts and distinct `src` props; no Remotion runtime exists in this project.

## Pairs with
[[pace-visual-change-clock]] · [[pace-cut-density-from-viewer-intent]] · [[struct-stimulation-budget]] · [[pace-overlay-instead-of-cut]] · [[cut-l-audio-trails-picture]] · [[cut-punch-in-emphasis]] · [[motion-image-focal-point-direction]] · [[pace-silent-demonstration-window]] · [[sfx-unsounded-motion-audit]] · [[cut-eye-trace-continuity]]

## Failure modes
- **Measuring cuts and calling it variety.** The commonest version: an A/B angle ping-pong reported as "22 cuts/min, well paced". Fix: dedupe by perceptual hash before counting; two angles are two visuals no matter how often you alternate them.
- **Recycled B-roll inflating the count.** The same stock clip used six times reads as one visual and, worse, as padding. Fix: `dedupe_distance` 0.15 catches near-identical reuse; cap reuse at 3 per section.
- **Hitting the number with punch-ins.** Scale changes on the same frame refresh attention but add no information; counted as 1.0 each they will fake a passing score. Fix: count them as 0.5 and never twice consecutively.
- **Density without motivation.** Every added visual still needs a reason in the design document. A variety score that passes while the Motivation column is empty means the audit was gamed.
- **Applying the target to the wrong format.** A companionship edit forced to 12 DVPM is destroyed by this note. Fix: the stimulation budget's ceiling always overrides `dvpm_target`.
- **Treating the published intervals as data.** The "change something every 5–7 s" family of numbers is creator guidance, not platform-published measurement — one retention practitioner states plainly that any "cut every 10–15 seconds" rule is a marketing claim, not YouTube data. The defensible move is to measure the *reference video* and match it, and to treat the bands here as fallbacks when no reference exists.
- **Counting captions as variety.** Rolling captions change the pixels continuously and would trivially satisfy any per-second metric. Fix: exclude the caption layer from the census entirely; a caption counts only when a distinct keyword card is a deliberate visual beat.
- **Known gap:** nothing in HyperFrames measures a rendered file, and the browser-dependent tooling (`snapshot`, `check`'s layout audits) cannot run on the authoring VM. DVPM on a *rendered* deliverable therefore has to be measured off-host or from the composition source, and the composition-source count is the one to trust here.
