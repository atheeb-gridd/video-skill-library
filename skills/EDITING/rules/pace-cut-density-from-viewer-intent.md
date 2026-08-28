---
id: pace-cut-density-from-viewer-intent
title: Derive cut density from the experience the audience came for
skill: editing
type: pacing
family: cut-density
tags: [skill/editing, type/pacing, family/cut-density, engine/ffmpeg, engine/hyperframes, source/editing-kt, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:01:36
    quote: "So what are you supposed to do when both editing styles work? Start by thinking about the experience your viewers want."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:01:30
    quote: "While Sam averages 90 seconds between cuts, Mr. Beast does the exact opposite."
research_refs:
  - https://increditors.com/video-pacing-youtube-retention-science/
  - https://vidpros.com/video-clip-length/
  - https://www.filmmakersacademy.com/glossary/average-shot-length-of-films/
  - https://prepublish.ai/guides/first-30-seconds
  - https://ctat.roanestate.edu/wp-content/uploads/video_Length_-for_Engagement.pdf
difficulty: medium
detectable_from: transcript+video
---

# Derive cut density from the experience the audience came for

## What it is
Cut density — average shot length (ASL) and cuts per minute (CPM) — is not a quality setting. It is a genre parameter, and picking it wrong destroys the video even when every individual cut is competent. The source video makes the point with two opposite proofs: a hangout vlog averaging **90 seconds between cuts** (≈0.7 CPM) that performs, and Mr. Beast's rapid-fire style that also performs. This note is the lookup step that turns a stated audience intent into a target ASL, a target CPM, and a hard longest-hold ceiling before a single cut is placed.

## When to use it
Run this first, at the top of every design pass, before the subtractive dead-space pass. Run it again whenever a reference video's measured pacing and the new video's intended genre disagree — that disagreement is a decision a human should sign off on, not something to average out. Also run it when a channel has a retention cliff that is *not* at the hook: a mid-video cliff with a flat cut rhythm behind it usually means the density is wrong for the intent, not that individual cuts are bad.

## How to recognise it in a reference video
- **Measure, do not characterise.** Detect cut candidates mechanically, then classify by eye:
  `ffmpeg -i ref.mp4 -vf "select='gt(scene,0.3)',showinfo" -vsync vfr -f null - 2>&1 | grep showinfo`
- Compute and log four numbers: **median shot length**, **p90 shot length**, **max shot length**, **cuts per minute** over the body (exclude the hook and the outro, which have their own densities).
- **Companionship edit** signature: CPM ≤ 2, median shot length > 15s, long unbroken A-roll, cuts occur only where content was removed, no motion events inside a hold, no B-roll rhythm. Sam's 26-minute / 17-cut video is the extreme: 0.65 CPM.
- **Explainer signature:** 3–5 CPM, median 8–15s, cuts land on sentence and clause boundaries, B-roll enters to illustrate a named noun.
- **Entertainment signature:** 10–20 CPM, median 3–5s, sub-1.2s shots present in the p10, every pause removed so the speech is wall-to-wall.
- **Cross-check against speech rate.** Transcribe and compute words per minute. 130–150 WPM is conversational; 160–190 WPM is high-retention delivery; sustained >200 WPM harms comprehension. A high CPM sitting on a 140 WPM delivery is a stylistic choice; a low CPM on a 190 WPM delivery reads as an unfinished edit.
- **Diagnostic ratio:** cuts per 100 words. A companionship edit sits under 1; an explainer 2–4; an entertainment edit 6–12. This is fps- and length-independent, so it is the most portable single number to log in a profile.
- Check whether the longest hold contains a **motion event** (punch-in, push, overlay). A 20s static hold in a fast edit is a defect; a 20s hold with a slow scale drift is a deliberate breathe beat.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `audience_intent` | `explainer` | `companionship` \| `explainer` \| `entertainment` \| `craft-demo` | The single input. Everything below is derived from it. |
| `target_median_asl` | 10s (300f) | companionship 15–90s · explainer 8–15s (240–450f) · entertainment 3–5s (90–150f) · craft-demo 6–15s | Median, not mean — one long demo window skews the mean. |
| `target_cpm` | 4 | companionship 0.5–2 · explainer 3–5 · entertainment 10–20 · gaming 8–15 · comedy 10–20 | Measured over the body only. |
| `cuts_per_100_words` | 3 | 0.5–12 | The fps-independent cross-check. |
| `max_static_hold` | 4s (120f) | 2–8s explainer/entertainment · unbounded for companionship | Above this, a motion event is required, not another cut. |
| `p90_asl_ceiling` | 2.5× median | 2–3× median | A p90 above 3× median means the rhythm has a hole in it. |
| `hook_cpm_multiplier` | 1.5× body | 1.0–2.5× | The first 15s runs denser than the body in every genre except companionship. |
| `delivery_wpm` | 165 | 130–190 | Measured from the transcript; caps the achievable CPM. |
| `min_shot_length` | 0.4s (12f) | 0.25–1.0s (8–30f) | Below ~8 frames a shot reads as a flash, not a shot. |

## Reproduction prompt

```
Set the pacing budget for this edit BEFORE placing any cut.

1. Read the stated audience intent. If it is absent, derive it from the
   transcript: first-person daily narration -> companionship; numbered
   teaching points -> explainer; challenge/stakes/reveal language ->
   entertainment; on-screen demonstration -> craft-demo. If two fit, STOP
   and ask; do not average them.
2. Write the budget into the design document header as five numbers:
   target_median_asl = {{ASL}} frames @30fps, target_cpm = {{CPM}},
   cuts_per_100_words = {{C100}}, max_static_hold = {{HOLD}} frames,
   min_shot_length = 12 frames. Defaults: explainer -> 300f, 4, 3, 120f.
3. Transcribe the narration and compute delivery WPM. If WPM > 190, reduce
   target_cpm by 25% - the speech is already carrying the energy. If
   WPM < 140, raise target_cpm by 25% or the video will feel slack.
4. Place cuts. Then measure the result, do not eyeball it: compute median,
   p90 and max shot length and CPM over the body (exclude first 15s and
   last 20s).
5. ACCEPTANCE TEST, all four must pass:
   - median shot length within +/-20% of target_median_asl
   - p90 <= 2.5x median
   - no static hold longer than max_static_hold without a motion event
     inside it
   - no shot shorter than 12 frames unless it is a deliberate flash
   Every failing row gets a fix or an explicit waiver line naming the
   reason. Do not silently pass.
```

## Execution spec

**Measure the reference (ffmpeg).** Cut candidates then shot-length stats:
```bash
ffmpeg -i ref.mp4 -vf "select='gt(scene,0.3)',showinfo" -vsync vfr -f null - 2>&1 \
  | sed -n 's/.*pts_time:\([0-9.]*\).*/\1/p' > cuts.txt
awk 'NR>1{print $1-p} {p=$1}' cuts.txt | sort -n | awk '{a[NR]=$1} END {
  printf "n=%d median=%.2f p90=%.2f max=%.2f\n", NR, a[int(NR*0.5)], a[int(NR*0.9)], a[NR]}'
```
Scene detection finds candidates only — extract frames either side and classify by eye (`ffmpeg -ss <t> -i ref.mp4 -frames:v 1 f.png`). A soft dissolve or an on-axis punch-in will be missed at threshold 0.3; drop to 0.15 for a second pass on suspected soft cuts.

**Subtractive pass (ffmpeg / media-use).** Dead-space removal is what buys most of the CPM in an explainer edit, and it is mechanical:
```bash
node <SKILL_DIR>/scripts/transcript-cut.mjs --input aroll.mp4 --transcript aroll.transcribe.json \
  --remove-fillers "um,uh,like" --cut-silence 0.6 --plan
```
Inspect the `--plan` JSON before encoding. Drop `--copy` for frame-accurate cuts; with `--copy` the script reports `copy_drift` when keyframe snapping swallowed a cut.

**Assembly (HyperFrames).** There is no frame attribute — author seconds and keep the frame count as a comment. A 300-frame (10s) shot starting 4s in:
```html
<video id="shot-07" src="aroll.mp4" muted playsinline class="clip"
       data-start="4" data-duration="10" data-media-start="61.4" data-track-index="0"></video>
<!-- 10.0s = 300f @30fps -->
```
Back-to-back clips are authored `b.start === a.start + a.duration` — the visibility window is half-open `[start, start+duration)`, so there is no overlapping frame and no gap. Author the audio as a separate `<audio>` on track 10+ carrying the same `data-start` / `data-duration` / `data-media-start`; there is no auto-sync, alignment is the same numbers written twice.

**Render fps.** `npx hyperframes render --fps 30` is the default. Every frame count in this note assumes 30; at 24 multiply seconds-derived frame counts by 0.8, do not reuse the frame numbers.

**Remotion:** the concept ports directly (frames are native there), but this project has no Remotion runtime — treat any `useCurrentFrame()` spec as out of contract.

## Pairs with
[[pace-cut-on-the-beat]] · [[pace-silent-demonstration-window]] · [[cut-punch-in-emphasis]] · [[struct-demand-hook-competence-gap]] · [[struct-numbered-list-mid-roll-sponsor]] · [[pace-bpm-matched-music-selection]] · [[struct-stimulation-budget]] · [[pace-overlay-instead-of-cut]]

## Failure modes
- **Importing a reference's CPM without importing its intent.** Copying Mr. Beast's 15 CPM onto a hangout vlog interrupts exactly the thing the audience came for. Fix: the intent decides the budget; the reference only decides *how* the cuts are made.
- **Cutting to hit a CPM number.** A cut placed because "it had been a while" is the row a reviewer deletes. Fix: every cut needs a motivation; if CPM is short, the shortfall is a content problem (add a B-roll beat) not a cut problem.
- **Reporting the mean.** One 40s demo window drags the mean and hides a choppy body. Fix: always report median + p90 + max.
- **Treating a static hold as a pacing failure.** In companionship edits it is the format. Fix: apply `max_static_hold` only when intent is not `companionship`.
- **Known gap:** no published dataset ties ASL to a retention curve per genre. The CPM bands here come from a practitioner benchmark table and a clip-length guide, and the retention numbers (52% vs 44% for a value claim inside 15s; 65–80% typical 30s retention) come from a separate source. Treat the bands as priors to be replaced by the channel's own measured analytics as soon as those exist, and label them as priors in any profile.
