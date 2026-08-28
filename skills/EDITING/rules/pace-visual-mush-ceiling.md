---
id: pace-visual-mush-ceiling
title: The comprehension floor — where visual variety turns into visual mush
skill: editing
type: pacing
family: cut-density
tags: [skill/editing, type/pacing, family/cut-density, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:05:33"
    quote: "All that visual variety can turn into visual mush fast if you do it wrong. Let's say you want to be engaging, so you try to cut between different clips as much as humanly possible. You run the risk of making things confusing. Which hurts engagement."
research_refs:
  - https://en.wikipedia.org/wiki/Attentional_blink
  - https://en.wikipedia.org/wiki/Saccade
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://en.wikipedia.org/wiki/Fast_cutting
  - https://en.wikipedia.org/wiki/Rapid_serial_visual_presentation
difficulty: medium
detectable_from: video
---

# The comprehension floor — where visual variety turns into visual mush

## What it is
Visual variety is bounded from below by comprehension. Every shot has a **minimum on-screen duration** determined by what the viewer has to do with it — recognise it, read it, or understand it — and a cut placed before that duration elapses delivers an image the viewer never actually received. Stack enough of those and the sequence stops being "fast" and becomes **mush**: motion and colour with no retained content. This note owns the floor. Its siblings own the ceiling and the census: [[pace-cut-density-from-viewer-intent]] picks a target ASL from the audience's intent, [[pace-visual-variety-density-audit]] counts how many *distinct* visuals exist, and [[pace-visual-change-clock]] enforces a maximum gap between changes. This note is the only one that says **no shorter than this**.

The floor is not one number. It is a per-shot function of content class, and the three costs that set it are measurable: the eye needs roughly **200 ms to launch a saccade** to an unexpected stimulus plus **20–200 ms** to move it, and natural scene viewing runs at only **two to three fixations per second**; a second information-bearing event landing **200–500 ms** after the first falls inside the **attentional blink** and is frequently not reported at all; and text is bounded by reading speed, for which the strictest published broadcast numbers are **20 characters per second** (adult) / **17 cps** (children) with a hard floor of **5/6 of a second** per subtitle event regardless of how short the text is.

## When to use it
Run this check whenever the edit is dense — any passage whose average shot length is under about 1.5 s, any montage, any "hook" section built from stacked B-roll, any sequence assembled to a fast bed. Run it specifically when the brief says "make it more engaging" and the instinct is to add cuts: that is the exact failure the source describes. Run it before shipping any sequence containing on-screen text, a chart, a UI screenshot, a face the viewer has not seen before, or a number the viewer is supposed to remember. Do **not** apply it to shots that are re-shows of an already-established image — those are exempt, and the exemption is what makes fast montage legal.

## How to recognise it in a reference video
- **Shot-length histogram.** Detect cuts and list durations. A healthy dense edit clusters at 0.8–2.5 s with a tail. A mush passage has a mode **under 0.4 s (12 frames)** *and* a high proportion of those short shots carrying new subjects.
- **The classification test, per shot under 24 frames.** Is the frame (a) a repeat of an image already on screen in the last 10 s, (b) a new but trivially readable image — one big centred subject, or (c) new information — text, a face, a diagram, a UI, a product detail? Only class (a) and (b) are legal at that length. A run of class (c) shots under 20 frames is mush.
- **Text under its reading floor.** Measure the character count of any burned-in text and its on-screen frames. If `frames < 25 + (chars / 20) × 30` at 30 fps, the viewer cannot have read it. Anything under **25 frames** is below the broadcast minimum event duration outright.
- **Two new subjects inside 15 frames.** Two shots that each introduce something the viewer must understand, separated by less than 0.5 s, means the second one landed inside the attentional-blink window. Log the pair.
- **Focal-point ping-pong.** Consecutive short shots whose subject sits in different quadrants of the frame. Each jump costs a saccade (~250 ms round trip) that the shot length does not pay for. A sustained run of these is the sensation the source calls "confusing".
- **On the audio track:** narration continuing evenly *underneath* a picture that is cutting far faster than the narration's own beats is the classic signature — picture cut to a music grid, not to meaning.
- **On the transcript:** count new nouns per 10 s versus new shots per 10 s. When shots outrun the concepts by more than 3:1, the extra shots are decoration and are candidates for removal.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Floor — re-show of an established image | 6 f (0.20 s) | 4–10 f | Already encoded; the analogue of lag-1 sparing. Legal in bursts. |
| Floor — new simple image, one centred subject | 12 f (0.40 s) | 10–18 f | Covers saccade latency (~200 ms) plus one fixation. |
| Floor — new face that must be recognised | 15 f (0.50 s) | 12–24 f | Longer if the face is small in frame or in profile. |
| Floor — shot carrying an information beat | 20 f (0.67 s) | 18–30 f | The viewer must *understand*, not just see. |
| Floor — on-screen text | `25 f + (chars / 20) × 30 f` | min 25 f | 25 f = the 5/6 s broadcast minimum event at 30 fps; 20 cps is the adult reading ceiling. Use 17 cps (`chars/17`) for a general audience. |
| Floor — diagram, chart, UI screenshot | 60 f (2.0 s) | 45–120 f | Three or more elements to scan at 2–3 fixations/s. |
| Min gap between two *new-information* shots | 15 f (0.50 s) | 12–20 f | The attentional-blink window is 200–500 ms. |
| Max consecutive sub-floor shots in a burst | 4 | 3–8 | Only when all are class (a)/(b) variations of one established subject. |
| Mush threshold (fail the passage) | 15% | 10–25% | Share of shots in a 60 s window that sit below their own class floor. |
| Burst recovery hold | 45 f (1.5 s) | 30–90 f | Length of the shot that must follow a legal burst, so the sequence resolves. |

## Reproduction prompt

```
Audit and repair a sequence for comprehension-floor violations. Frames are
at 30fps; HyperFrames is authored in seconds, so convert (frames / 30).

1. BUILD THE SHOT TABLE. For the window {{IN}}..{{OUT}}, list every shot as
   {index, start_s, duration_s, duration_frames}. Get boundaries from
   `scenedetect -i <file> detect-adaptive list-scenes -o .` for flat media,
   or by reading data-start/data-duration off every [data-start] clip in
   the composition.
2. CLASSIFY each shot into exactly one class: (a) re-show of an image
   already used in the previous 10s; (b) new simple image, one dominant
   centred subject, no text; (c) new information - burned-in text, a face
   not yet seen, a chart, a UI, a product detail, a number.
3. ASSIGN the floor: (a)=6f, (b)=12f, (c)=20f. Override for text with
   floor = 25f + (character_count / 20) * 30f. Override for a diagram or
   UI screenshot with floor = 60f.
4. FLAG three violation types: SHORT (duration < floor); BLINK (two class-c
   shots whose starts are less than 15f apart); BURST-OVERRUN (more than 4
   consecutive sub-floor shots, or any sub-floor run containing a class-c
   shot).
5. REPAIR in this order, never by adding cuts: (i) extend the offending
   clip's duration to its floor and absorb the frames from the nearest
   neighbouring shot that is above its own floor by 10f or more; (ii) if no
   neighbour has slack, DELETE the offending shot entirely and extend the
   shot before it - a shot the viewer cannot read is worth zero, so removing
   it costs nothing; (iii) only if the passage must keep its length, demote
   the shot from class c to class b by removing its text or punching in on
   its single subject.
6. AFTER a legal burst, ensure the next shot holds at least 45f.
7. ACCEPTANCE TEST: re-run steps 1-4. Pass requires: zero class-c shots
   below floor; zero BLINK pairs; sub-floor shots under 15% of shots in
   every 60s window; and a human playback at 1x during which every piece of
   on-screen text can be read aloud in full before it leaves the screen.
   Do not judge any of this by scrubbing - only full-speed playback counts.
```

## Execution spec

**Measuring the reference (ffmpeg).** Shot boundaries and the histogram, before anything is authored:
```bash
# cut list with timestamps + shot durations
scenedetect -i ref.mp4 detect-adaptive list-scenes -o ./analysis
# fallback if scenedetect is not installed (it is optional in this stack):
ffmpeg -i ref.mp4 -vf "select='gt(scene,0.35)',showinfo" -f null - 2> scenes.txt
```
`scenedetect` is listed in the contract as an **optional, unverified** tool; the `select=gt(scene,…)` fallback needs only ffmpeg, which is assumed present. Neither classifies shots — step 2 of the prompt is a human/VLM judgement over extracted stills:
```bash
ffmpeg -i ref.mp4 -vf "select='eq(n\,{{FRAME}})'" -vframes 1 shot_{{INDEX}}.png
```

**HyperFrames — the audit is a read over the DOM, the repair is an attribute edit.** Every clip is `[data-start]` with `data-duration` in **seconds**; there is no frame attribute, so the floors above convert at authoring time (12 f = `0.4`, 20 f = `0.667`, 25 f = `0.833`, 60 f = `2.0`). The visibility window is half-open `[start, start+duration)`, so two clips authored back to back (`b.start === a.start + a.duration`) share no frame — extending clip *a* by `0.2` means clip *b*'s `data-start` moves by `0.2` too, unless *b* uses **relative timing**:

```html
<!-- absorbing 6 frames of slack from the neighbour, expressed in seconds -->
<video id="shot-14" src="broll/ui.mp4" muted playsinline
       data-start="18.40" data-duration="0.867"   <!-- was 0.60 = 18f, floor for text is 26f -->
       data-media-start="3.20" data-track-index="0"></video>
<video id="shot-15" src="broll/desk.mp4" muted playsinline
       data-start="shot-14" data-duration="1.60"   <!-- follows automatically -->
       data-media-start="0" data-track-index="0"></video>
```
Relative timing has four silent failure modes from the contract: **spaces around `+`/`-` are mandatory** (`"shot-14 + 0.2"`, never `"shot-14+0.2"`), an unresolved id resolves to `0`, a target with no resolvable duration lands the reference on the target's **start**, and a cycle resolves to `0` — none of which lint catches. After any repass, `npx hyperframes snapshot --at <midpoints>` and eyeball, because a chain that silently collapsed to 0 looks like a missing shot, not an error.

Deleting a mush shot is the preferred repair and it is non-destructive: set `data-hidden` on the clip rather than removing markup — the mounted vault **cannot delete files**, and a hidden clip is reversible and visible in Studio's timeline.

**Epidemic Sound:** not involved. Do not "fix" a mush passage by changing the bed — if the bed's BPM is what forced the sub-floor cuts, the fix is a slower bed, which is [[pace-tempo-band-energy-map]], not this note.

**Remotion:** the same audit expressed as a `frame`-indexed sequence list; the floors are already in frames there. Remotion is not part of this project.

## Pairs with
- [[pace-cut-density-from-viewer-intent]] — sets the target ASL this floor constrains from below · [[pace-shot-length-follows-interest]]
- [[pace-visual-variety-density-audit]] — counts distinct visuals; a passage can pass DVPM and still be mush
- [[pace-visual-change-clock]] — the opposite bound: maximum time without a change
- [[struct-stimulation-budget]] — the same argument applied to sound and motion density
- [[cut-punch-in-emphasis]] — how to demote a class-c shot to class-b without losing it
- [[motion-image-focal-point-direction]] — reduces the saccade cost by pre-directing the eye
- [[sub-cue-duration-floor-and-ceiling]] — the text floor as it applies to captions proper
- [[pace-tempo-band-energy-map]] — if the bed is forcing the cuts, change the bed

## Failure modes
- **Treating the floor as a target.** Cutting everything to exactly 12 frames produces a metronomic edit that reads as machine-made. The floor is a minimum; vary shot length by at least ±30% around the passage's mean.
- **Applying the floor to a re-show.** A montage returning to the same three images can legally run 6-frame shots. Extending those to 20 frames kills the passage. Classification comes first.
- **Fixing a violation by adding a transition.** A 0.4 s crossfade over a 0.3 s shot leaves the shot never fully resolved at all — strictly worse. Extend or delete.
- **Measuring text length by eye.** Count characters. A 60-character line needs `25 + 90 = 115` frames (3.8 s), which is far longer than most editors' instinct and is the single most common violation.
- **Ignoring where the subject sits.** Two legal-length shots with subjects in opposite corners still fail in practice, because the eye spends the whole of the second shot travelling. Either match focal points across the cut ([[cut-eye-trace-continuity]]) or add frames.
- **Judging by scrubbing.** Scrubbing gives you unlimited time on each frame and therefore always passes. Full-speed playback is the only valid test, and [[sfx-playback-verification-loop]] is the protocol.
- **Known gap:** nothing in this stack detects shots, classifies content, or measures reading load automatically. `scenedetect` is optional and unverified in this environment, and there is no lint rule for short clips. The audit is a script you write over the DOM plus a human pass; do not claim it as a gate.
