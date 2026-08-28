---
id: pace-visual-change-clock
title: On-screen change is the attention mechanism — run a visual-change clock
skill: editing
type: pacing
family: attention-mechanics
tags: [skill/editing, type/pacing, family/attention-mechanics, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:02:56"
    quote: "When you see a change in your field of view, like something moving suddenly, it grabs your attention. The same thing happens when you're watching a video."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:02:30"
    quote: "using the visuals to maximize attention, cutting between A-roll, B-roll and other footage so there is always something new to look at"
research_refs:
  - https://link.springer.com/article/10.1007/s11747-025-01137-x
  - https://link.springer.com/article/10.3758/s13414-018-1548-1
  - https://jov.arvojournals.org/article.aspx?articleid=2193180
  - https://bop.unibe.ch/JEMR/article/download/2264/3460
  - https://air.io/en/youtube-hacks/advanced-retention-editing-cutting-patterns-that-keep-viewers-past-minute-8
difficulty: medium
detectable_from: transcript+video
---

# On-screen change is the attention mechanism — run a visual-change clock

## What it is
The mechanism under every cut, punch-in, overlay and Ken Burns move is the same: a transient in the field of view recruits attention involuntarily, before the viewer decides anything. A cut is one way to produce that transient; it is not the only way. So the editing unit that actually matters is not "cut" but **visual-change event** — any moment where the image measurably becomes a different image. The clock this note installs counts *those*, resets on each one, and flags every stretch where the clock ran past the format's ceiling with nothing happening. The corollary the creator states directly — "there is always something new to look at" — is a scheduling instruction, not a taste preference.

## When to use it
Run this as **pass 3 of the Mode B design** (rhythm), immediately after motivated cuts are placed, and as a diagnostic in Mode A whenever a reference video feels faster or slower than its cut count implies. It is the pass that catches the two failures cut-counting misses: a 40-second A-roll monologue with no visual event at all (clock overrun), and a section where six changes land inside four seconds and none of them are legible (clock thrash). Use it specifically when the retention curve shows a slow slide rather than a cliff — a slide is usually clock overrun, a cliff is usually a structural problem ([[struct-stimulation-budget]]). Do **not** use it to justify adding events: the clock is a *ceiling* check, and in a companionship/authenticity format the correct ceiling is enormous and the correct action is still subtractive.

## How to recognise it in a reference video
- **Count visual-change events, not cuts.** An event is any of: a hard cut; a punch-in or reframe on the same source; a B-roll or graphic entering or leaving; a caption line change that carries new words; a transition; a substantial camera or subject move beginning. Log each with a timecode and a type.
- **Detect the picture-cut subset mechanically, then classify by eye:**
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=10,metadata=print:file=-" -f null - 2>/dev/null \
    | grep -B1 "lavfi.scd.score=[1-9]"
  ```
  `scdet` prints two keys per frame — `lavfi.scd.mafd` (mean absolute frame difference, a per-frame change-energy value) and `lavfi.scd.score`. A score above the threshold marks a cut; `mafd` alone is the continuous change signal and is what finds punch-ins and moves that `scdet` scores too low to flag.
- **Compute the inter-event interval distribution**, not the mean: median, p90, and the single longest gap. The longest gap is the number that predicts the drop-off.
- **Bands measured in retention-edited long-form:** visual change every **10–20 s** through minutes 0–3, relaxing to **25–40 s** for minutes 3–7, and a deliberate pattern interrupt roughly every **2 min** thereafter. A first pattern interrupt at **25–35 s** is near-universal in this style.
- **Cut-corpus reference point:** in a measured advertising corpus the median scene ran **2.12 s** (IQR 1.5–3.0 s), and the same study puts the viewer's post-cut ocular response inside a **0–0.66 s** window. Both numbers are useful anchors: 0.66 s is the floor below which a new image has not been *read*, 2.12 s is what a maximally-stimulating format looks like.
- **Look for the change with no cut.** Count events on a single continuous A-roll take — scale drift, overlays, focal-point treatments. A reference with 8 cuts/min but a change every 12 s is a *motion*-driven edit, not a cut-driven one, and copying its cut count will miss the style entirely ([[pace-overlay-instead-of-cut]]).
- **Static-frame test.** Extract stills every 2 s and diff adjacent pairs. Runs of near-identical stills are the clock overruns:
  ```bash
  ffmpeg -i ref.mp4 -vf "fps=0.5,signalstats,metadata=print:file=-" -f null - 2>/dev/null | grep -E "pts_time|YAVG"
  ```
- **Transcript cross-check.** Mark where the transcript changes topic. An event ceiling that is respected but never lands on a topic boundary is a mechanical clock, and mechanical clocks read as restless. Events should cluster on meaning.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `event_ceiling_early` | 15 s (450 f) | 10–20 s | Longest permitted gap between visual-change events, minutes 0–3. |
| `event_ceiling_mid` | 30 s (900 f) | 25–40 s | Minutes 3–7 and onward for explainer long-form. |
| `event_ceiling_companionship` | 90 s (2700 f) | 60 s–no ceiling | Authenticity formats. Do not import the explainer ceiling. |
| `event_floor` | 20 f (0.67 s) | 15–30 f | Minimum legible life of a new image; below this the viewer's post-cut orienting response has not resolved. Hard floor for any image carrying information. |
| `info_hold` | 30 f (1.0 s) | 30–60 f | Minimum uninterrupted time for an element the viewer must actually read or remember. |
| `interrupt_interval` | 120 s (3600 f) | 90–150 s | Spacing of deliberate pattern interrupts once the mid ceiling is in force. |
| `first_interrupt` | 30 s (900 f) | 25–35 s | The first one is early and load-bearing. |
| `thrash_limit` | 4 events / 4 s | 3–6 events / 4 s | More than this and no individual event is read. |
| `change_no_cut_share` | 0.35 | 0.1–0.7 | Fraction of events produced without a picture cut. Higher = motion-driven style. |
| `event_on_meaning` | 0.7 | 0.5–0.9 | Fraction of events landing within 1 s of a transcript topic/sentence boundary. |

## Reproduction prompt

```
Run a visual-change clock over the assembled timeline at 30fps and fix every overrun.

1. BUILD THE EVENT LIST. Enumerate every visual-change event with timecode and type:
   hard cut | reframe/punch-in | b-roll in | b-roll out | graphic in | graphic out |
   transition | caption-line change | camera-or-subject move onset. Detect the cut subset with
   `ffmpeg -i cut.mp4 -vf "scdet=t=10,metadata=print:file=-" -f null -` and add the non-cut
   events by reading the composition's clip and tween list. Do not guess.

2. COMPUTE the sorted list of inter-event gaps. Report median, p90 and the max gap.

3. APPLY THE CEILING. For composition time 0-180s the ceiling is {{CEIL_EARLY}} (default 450 f
   = 15.0 s). After 180s it is {{CEIL_MID}} (default 900 f = 30.0 s). For every gap over the
   ceiling, insert exactly ONE event at the gap's midpoint, chosen in this priority order and
   justified in one clause:
     a) a cut to B-roll that shows what the narration is describing;
     b) a punch-in reframe on the A-roll at a sentence boundary (scale 1.00 -> 1.12, 0.5 s,
        power3.out);
     c) a graphic/overlay carrying a number or name the narration just said;
     d) a slow scale/position drift on a still (1.00 -> 1.06 over the whole gap, ease none).
   Never insert an event that shows nothing the narration is not already saying.

4. APPLY THE FLOOR. Delete or extend any event whose resulting image lives under 20 f (0.67 s),
   and any information-bearing element under 30 f (1.0 s). Nothing that must be READ may be
   shorter than 30 f.

5. DE-THRASH. Where more than 4 events fall inside any 4.0 s window, keep the ones that land on
   a transcript sentence boundary and delete the rest.

6. SNAP TO MEANING. Move every inserted event to the nearest transcript sentence or clause
   boundary within +/- 12 f. At least 70% of all events must land within 30 f of one.

ACCEPTANCE TEST: no gap exceeds its ceiling; max gap is reported and under it; no image under
20 f; no information-bearing element under 30 f; no 4 s window over 4 events; >=70% of events
on a transcript boundary; and every inserted event has a one-clause reason that names something
in the narration. If any inserted event's reason is "it had been a while", delete that event and
raise the ceiling for that section instead.
```

## Execution spec

**HyperFrames (primary).** The clock is an audit over the composition's own timing declarations, so it can be computed from the HTML without rendering — which matters, because this VM cannot run the browser-backed passes.

- **Cut events** are `data-start` values on `<video>`/`<img>`/`<section class="clip">` elements on the picture tracks (`data-track-index` 0–1 by convention). Every clip contributes an event at `data-start` and, if it ends before the next clip begins, another at `data-start + data-duration`.
- **Non-cut events** are GSAP tween positions on the composition's single paused timeline. Extract them by reading the tween list; after authoring, `node skills/hyperframes-animation/scripts/animation-map.mjs <dir> --out <dir>/.hyperframes/anim-map` enumerates tweens and samples bboxes — but it reads live timelines, so **it needs a browser and must run off this VM**.
- **Inserting a punch-in** is a scale tween on a wrapper, not on the clip: transform aliases only (`scale`, `x`, `y`), never `width`/`height`/`top`/`left`, and never a CSS `transform` on the same element (that is `gsap_css_transform_conflict`, an error).
  ```js
  // event insert: punch-in on A-roll at composition t=41.20s. 15f = 0.5s.
  tl.fromTo("#aroll-03-inner", { scale: 1.00 }, { scale: 1.12, duration: 0.5, ease: "power3.out" }, 41.20);
  ```
- **Inserting a drift on a still** is the zero-cut event, and must attach to `tl` — a bare `gsap.to()` runs on wallclock and is absent from the render.
  ```js
  tl.fromTo("#still-07", { scale: 1.00, x: 0 }, { scale: 1.06, x: -18, duration: 9.0, ease: "none" }, 52.00);
  ```
- **Half-open window:** a clip shows on `[start, start + duration)`. Land the inserted tween's end state slightly before the clip's `data-duration` or its final frame never renders. Two clips authored back-to-back (`b.start === a.start + a.duration`) share no frame — which is what makes the event list unambiguous.
- All times are **seconds**. There is no frame attribute; write `0.5` and put `15f @30fps` in a comment.
- The event floor interacts with the layout audit: an element under 20 f may never be sampled by `check`'s layout pass at all, so a too-short graphic can pass every gate and still be unreadable.

**ffmpeg.** `scdet` for cuts and `mafd` for continuous change energy (both verified above). For the still-diff overrun scan, `fps=0.5,signalstats` and watch `YAVG`/`SATAVG` flatline. `auto-editor` and `scenedetect` are alternatives but need pip installs this VM cannot perform without sudo.

**Epidemic Sound.** Not directly involved — but note that an inserted event with no sound is half an event ([[sfx-unsounded-motion-audit]]), and the SFX budget is capped separately ([[sfx-placement-discipline]]). Do not let the clock push the SFX census past its own ceiling.

**Remotion:** conceptually the same audit over `<Sequence>` `from`/`durationInFrames` values; no Remotion runtime exists in this project.

## Pairs with
[[pace-cut-density-from-viewer-intent]] · [[struct-stimulation-budget]] · [[pace-overlay-instead-of-cut]] · [[cut-punch-in-emphasis]] · [[motion-image-focal-point-direction]] · [[cut-on-action]] · [[sfx-unsounded-motion-audit]] · [[pace-subtractive-first-pass]] · [[struct-demand-hook-competence-gap]] · [[pace-shot-length-follows-interest]]

## Failure modes
- **Treating the ceiling as a quota.** Filling every gap with the nearest available B-roll produces a video where the pictures no longer mean anything. Correction: an inserted event must name something in the narration, or the ceiling for that section is wrong.
- **Counting cuts instead of events.** A reference with a change every 12 s and 8 cuts/min gets reproduced at 8 cuts/min with 40 s of dead A-roll between them. Correction: count the non-cut events too; `change_no_cut_share` is a style signature.
- **Breaking the floor.** Two-frame flash inserts read as a glitch and carry no information; a 15-frame graphic with a number on it is unread. Correction: 20 f minimum for any image, 30 f for anything to be read.
- **Thrash at a climax.** Stacking six events into three seconds to signal importance destroys legibility exactly where it matters. Correction: at a climax use one *bigger* event, not more events.
- **Mechanical spacing.** Events on a metronome that ignores the transcript feel restless and reveal the system. Correction: snap to sentence boundaries; 70% minimum.
- **Importing the explainer ceiling into an authenticity format.** A 15 s ceiling on a vlog destroys the format's premise. Correction: take the ceiling from the profile, not from this note's default.
- **Known gap:** the automated half of this audit stops at picture cuts. `mafd` finds change energy but cannot distinguish "the subject moved" from "the editor punched in", and there is no tool in this stack that enumerates non-cut events from a rendered MP4 — only from the composition source. For a third-party reference video, the non-cut event list is hand-logged, and should be marked as such in the profile.
