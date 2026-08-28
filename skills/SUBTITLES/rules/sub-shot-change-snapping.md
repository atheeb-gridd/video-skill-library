---
id: sub-shot-change-snapping
title: Snap the cue to the cut when it lands within twelve frames of one
skill: subtitles
type: caption-timing
family: shot-change
tags: [skill/subtitles, type/caption-timing, family/shot-change, engine/ffmpeg, engine/hyperframes, source/research, source/hyperframes, difficulty/high]
source:
  - video: "research"
    timestamp: n/a
    quote: "DCMP Captioning Key, Presentation Rate: a 'borrowing' technique using 15 frames before or after audio occurs, described as 'hardly noticeable to the viewer'."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Hard cut (entirely different content): select scene 0.683, scdet scd.score 26.66. Punch-in (1.2x scale on identical content): 0.160 / 6.26."
research_refs:
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: high
detectable_from: video
---

# Snap the cue to the cut when it lands within twelve frames of one

## What it is

A caption boundary that falls *near* a picture cut but not *on* it produces two visual events a few frames apart. The eye treats them as separate changes, saccades twice, and loses the frames in between. A caption boundary that falls exactly **on** the cut produces one event: the viewer's attention resets once and lands on new picture and new text together.

So the rule broadcast subtitling settled on is a **snap window**. If a cue's start or end falls within *N* frames of a detected shot change, move it to the shot change. Outside the window, leave it where the speech puts it.

Two things set the window's size. The upper bound is how far a caption can be shifted before it desynchronises from the voice: DCMP describes "borrowing" **15 frames before or after** the audio as "hardly noticeable to the viewer," which is the published statement of that tolerance. The lower bound is the two-event threshold — below about 4 frames the viewer cannot separate the two changes anyway, so snapping buys nothing. **12 frames (0.4 s at 30 fps) is the working default**: comfortably inside the noticeability tolerance, comfortably above the fusion threshold.

The snap has direction rules:

- **A cue starting just after a cut** snaps **back** to the cut frame. The caption appears with the new shot.
- **A cue ending just before a cut** snaps **forward** to the cut frame. The caption clears as the shot changes.
- **A cue ending just after a cut** snaps **back** to the cut frame — never let a caption trail two frames into a new shot; that is the ugliest of the four cases.
- **A cue starting just before a cut** is the one case to leave alone if snapping would put the text on screen before its word is spoken. Sync to the voice wins over sync to the picture.

And one hard constraint: **snapping must never violate the duration floor or the reading-rate cap**. If pulling a cue's start back to the cut makes it exceed 20 CPS, or pushing its end forward makes it shorter than 5/6 s, do not snap.

## When to use it

- Any phrase-level or hybrid track over cut-heavy material — an explainer with B-roll, a montage, anything with a cut every 2–4 seconds.
- Any track whose profile records `break at cuts` in [[sub-cut-boundary-policy]].
- Especially at **hard cuts to unrelated content**, where the viewer's attention resets whether you plan for it or not.
- **Do not** snap in a fast-cut burst where cuts arrive faster than the snap window — see [[sub-fast-cut-sequence-captions]].
- **Do not** snap a chained word-level track's internal handovers. Chained cues are locked to word onsets; snapping one shifts every subsequent cue or breaks the chain.

## How to recognise it in a reference video

- **Detect the cuts first, with the right detector.** `scdet` and `select='gt(scene,N)'` answer the same question on **different scales** and their thresholds are not convertible: on one measured file a hard cut scored `scene` **0.683** / `scd.score` **26.66**, while a punch-in on identical content scored **0.160** / **6.26**. Use `gt(scene,0.3)` for hard cuts only; `gt(scene,0.08)`–`gt(scene,0.12)` to also catch punch-ins and soft boundaries, visually confirming every hit at that threshold. A dissolve produces **no spike at all** — it shows as a plateau of mid-range scores in a per-frame dump.
- **Then measure the offset.** For each cue boundary, compute `boundary_frame − nearest_cut_frame`. A track that snaps shows a spike at **0** and nothing in ±1–3 frames. A track that does not snap shows a flat scatter.
- **The tell-tale defect.** Look for a caption still on screen for 2–4 frames after a cut. It is visible as a "leftover" and it is the single most common near-miss.
- **Snap rate.** Count how many of the boundaries within ±12 frames of a cut are exactly on it. Above ~80 % means a snap pass ran; below ~20 % means it did not.
- **fps discipline.** Read fps per file with `ffprobe`; the reference set spans 60, 25 and 29.97 fps, and 12 frames is 0.2 s in one file and 0.48 s in another.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `snap_window` | 12 frames | 6–15 f | 0.4 s at 30 fps. Ceiling from DCMP's 15-frame borrowing tolerance. |
| `snap_window_seconds` | 0.40 s | 0.20–0.50 s | Author in seconds; the frame count is the annotation. |
| `fusion_floor` | 4 frames | 3–6 f | Below this, two events read as one anyway; snapping is a no-op. |
| `snap_start_after_cut` | back to cut | back | Caption appears with the new shot. |
| `snap_end_before_cut` | forward to cut | forward | Caption clears as the shot changes. |
| `snap_end_after_cut` | back to cut | back | Never trail into a new shot. |
| `snap_start_before_cut` | only if word onset allows | back / leave | Voice sync outranks picture sync. |
| `max_lead_over_voice` | 2 frames | 0–3 f | A snap may not put text up more than this before its first word. |
| `cut_detector_hard` | `gt(scene,0.3)` | 0.25–0.40 | Hard cuts, high precision. |
| `cut_detector_soft` | `gt(scene,0.10)` | 0.08–0.12 | Cuts plus punch-ins; every hit needs visual confirmation. |
| `dissolve_policy` | snap to midpoint | midpoint / ignore | Dissolves produce no spike; take the midpoint of the plateau. |
| `snap_veto` | duration floor + CPS cap | — | Never snap into a violation of either. |

## Reproduction prompt

```
Snap caption cue boundaries to picture cuts for {{VIDEO}}.

1. READ fps with ffprobe and convert the snap window {{WINDOW_S}} = 0.40s
   into frames for THIS file.
2. DETECT cuts:
   ffmpeg -v error -i {{VIDEO}} -vf "select='gt(scene,0.3)',showinfo"
   -fps_mode vfr -an /tmp/cuts/%04d.png
   Capture each pts_time. Run a second pass at gt(scene,0.10) and confirm
   every extra hit visually. Record the threshold used; it does not transfer
   between files.
3. For every cue boundary b, find the nearest cut c. If {{FUSION}} = 4 <
   |b - c| <= {{WINDOW}}, snap b to c: a start after a cut moves back; an end
   on either side of a cut moves to the cut; a start before a cut moves back
   only if its first word onset is no more than {{LEAD}} = 2 frames later.
4. VETO any snap that would make the cue shorter than {{MIN_DUR}} = 0.833s
   or push it above {{CPS}} = 17 characters per second. Log every veto.
5. Re-run the gap normaliser: snapping can open a 1-frame gap.

ACCEPTANCE TEST: every boundary within the window of a cut sits exactly on
the cut frame or is listed as vetoed with a reason; no snap exceeded
{{WINDOW}} frames; no cue fell below the duration floor or above the CPS cap;
and across five cuts no caption lingers 1-4 frames past a cut it should have
cleared on.
```

## Execution spec

Cut detection is **ffmpeg, at build time**, and its output is a list of times in seconds that the cue generator consumes. Nothing detects cuts at render time.

```bash
# hard cuts, with the frame at each boundary so you can confirm it
ffmpeg -v error -i in.mp4 -vf "select='gt(scene,0.3)',showinfo" -fps_mode vfr -an /tmp/cuts/%04d.png

# per-frame score dump — the only way to see a dissolve
ffmpeg -v error -i in.mp4 -vf "scdet=threshold=0,metadata=print:key=lavfi.scd.score:file=-" -an -f null -
```

Two cautions that belong in any spec citing this: **the two detectors' thresholds are on different scales and never convert** (the measured ratio between a hard cut and a punch-in agreed at ~4.3x on both metrics, but the absolute scales differ by roughly 39x), and **thresholds do not transfer between files** — low-bitrate material raises the score floor, so sweep per file and record the threshold used.

On the HyperFrames side the snap is just arithmetic on the inlined cue array before it is written into the composition. Time is in seconds; snapping to a cut means assigning the cut's `pts_time`, not a rounded frame number. If the picture is assembled from separate clips whose starts you already know from `data-start`, those clip boundaries **are** the cut list and no detection is needed — read them from the composition rather than detecting them from a render.

Cross-check with the editing library: the cut list this note snaps to is the same list [[pace-visual-change-clock]] and [[pace-shot-length-follows-interest]] work from, and a caption boundary landing on a punch-in rather than a cut is usually the [[cut-punch-in-emphasis]] case, which is a softer event and often should not be snapped to at all.

## Pairs with
[[sub-cut-boundary-policy]] · [[sub-fast-cut-sequence-captions]] · [[sub-inter-cue-gap-and-chaining]] · [[sub-cue-duration-floor-and-ceiling]] · [[sub-latency-and-offset-correction]] · [[cut-straight-hard-cut]] · [[cut-punch-in-emphasis]] · [[pace-visual-change-clock]] · [[motion-impact-frame-quantisation]]

## Failure modes
- **Snapping with a cut list detected at the wrong threshold.** `gt(scene,0.3)` is a hard-cut detector; run it alone over punch-in-heavy material and most boundaries go unsnapped. Correction: two passes, confirm the soft one visually.
- **Carrying a threshold between files.** A threshold tuned on a 1080p master misses boundaries on a 854x480 export. Correction: sweep per file, log the value.
- **Snapping past the voice.** Pulling a cue back to a cut can put words on screen before they are spoken. Correction: the 2-frame lead ceiling.
- **Snapping a chained word track.** Moving one cue either shifts every subsequent cue or breaks the chain. Correction: snap only phrase/card boundaries.
- **Ignoring dissolves.** They produce no spike, so a boundary list built from a threshold pass has no entry there and the caption cuts mid-dissolve. Correction: per-frame dump, snap to the plateau midpoint.
- **Snapping into a duration or rate violation.** A legal-looking snap that leaves a 0.6 s cue is worse than no snap. Correction: veto and log.
- **Snapping without re-normalising gaps.** A snap frequently opens exactly the 1-frame gap that [[sub-inter-cue-gap-and-chaining]] forbids. Correction: re-run the gap pass afterwards.
