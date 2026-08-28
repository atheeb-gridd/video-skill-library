---
id: sub-inter-cue-gap-and-chaining
title: Either chain the cues or leave two clear frames — one frame of gap is a defect
skill: subtitles
type: caption-timing
family: cue-limits
tags: [skill/subtitles, type/caption-timing, family/cue-limits, engine/hyperframes, source/hyperframes, source/research, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Two clips can therefore be authored back to back (b.start === a.start + a.duration) with no overlapping frame."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "tl.set(box, { opacity: 0, visibility: \"hidden\" }, line.end + 0.1);  // hard kill to ensure caption is hidden"
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://www.w3.org/TR/webvtt1/
  - https://aegisub.org/docs/latest/ass_tags/
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
difficulty: medium
detectable_from: video
---

# Either chain the cues or leave two clear frames — one frame of gap is a defect

## What it is

Between any two consecutive cues there are exactly three legal states, and the illegal fourth is the most common thing a generator produces.

- **Chained (gap = 0).** `cue[n].end === cue[n+1].start`. The plate stays up, the glyphs swap. Because the visibility window is half-open — `[start, start + duration)` — two cues authored back to back share no frame, so this produces a clean single-frame handover with no double-draw. This is the default inside a breath group in a word-level track.
- **Clear gap (≥ 2 frames).** The plate blanks visibly, signalling a syntactic or structural break. Two frames is the perceptual minimum for "the caption went away and came back"; 4–8 frames reads clearly as a beat.
- **Long break (≥ 0.5 s).** The plate clears for a pause, a scene change or a silent stretch. Used at paragraph boundaries and before a topic change.

**The illegal state is a gap of one frame**, or any gap under about two frames. It is too short to read as a clear and too long to read as a swap, so it registers as a **blink** — a flicker artefact that the eye catches even when the viewer cannot say what happened. It comes from three places: rounding cue times to milliseconds and back to frames, using `word.end` as `cue.end` on a chained track, and adding a fade-out and fade-in at a boundary that should have been a hard swap.

The blink has a second, less obvious source: **overlapping fades**. Two 0.1 s fades at the same boundary do not produce a blink, they produce a double exposure — roughly three frames where both cues are partly visible and both are legible. On a chained track that is worse than a blink, because it looks like a rendering fault.

**Overlap is a fourth state and it is legal in some carriers.** WebVTT explicitly allows cues to overlap, and players stack them. Never use that: a stacked pair moves the caption baseline and breaks position stability. If two speakers must be captioned at once, that is one cue with two dash-prefixed lines, per [[sub-speaker-and-non-speech-annotation]].

## When to use it

- **Chain** inside a breath group in word-level and hybrid tracks, and between two cues of a single continuing sentence in a phrase track when the speaker does not pause.
- **Clear gap** at every terminal punctuation mark, at a speaker change, and at a hard picture cut when the profile's cut policy says break ([[sub-cut-boundary-policy]]).
- **Long break** at paragraph boundaries, over a silent demonstration window, and wherever the picture needs to be uncovered.
- **Never** ship a gap between 1 frame and the minimum, and never ship overlapping cues.

## How to recognise it in a reference video

- **Frame-step every boundary in a 10-second sample.** Extract every frame (`select='between(n,N1,N2)'`, `-fps_mode passthrough`). Classify each boundary: plate present in all frames (chained), plate absent for *k* frames (gap of *k*), or both texts partly visible (overlapping fades).
- **The gap histogram is the finding.** A healthy track shows a bimodal distribution: a spike at 0 frames and a cluster at 3–8 frames. A spike at 1–2 frames means the generator is rounding.
- **Where the gaps fall.** Line them up against the transcript. Gaps at terminal punctuation and speaker changes indicate deliberate structure; gaps scattered mid-clause indicate a `word.end` bug.
- **Double exposure.** Look for a frame where two different cue texts are both readable at, say, 50 % opacity each. This is always a defect, and it is invisible in a contact sheet — only dense extraction finds it.
- **Baseline stability across a gap.** Measure the text baseline as a percentage of frame height before and after a gap. A shift means the box is being re-laid-out per cue instead of anchored.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `chain_gap` | 0 s exactly | 0 | `cue[n].end === cue[n+1].start`, to full float precision. |
| `min_visible_gap` | 2 frames | 2–4 f | The floor for a gap that should read as a clear. |
| `forbidden_gap_band` | >0 and <2 frames | — | Hard fail. Snap to 0 or to the minimum. |
| `sentence_gap` | 0.20 s (6 f @30) | 0.13–0.40 s | At `.` `?` `!`. |
| `paragraph_gap` | 0.60 s | 0.40–1.20 s | At a topic change or before a full-frame card. |
| `speaker_change_gap` | 0.20 s | 0.13–0.40 s | Even when the speech is continuous. |
| `overlap_allowed` | false | false | Legal in WebVTT, never used here. |
| `swap_type_chained` | hard `set` | set only | Never crossfade a chained handover. |
| `fade_in` | 0.10 s | 0.06–0.16 s | Only at the first cue after a gap. |
| `fade_out` | 0.10 s | 0.06–0.14 s | Only at the last cue before a gap. |
| `rounding` | snap to frame grid | — | Round cue times to the frame grid once, at the end, then re-test the gaps. |
| `hard_kill_offset` | +0.10 s after fade-out | 0.05–0.15 s | The reference file's explicit hide, on a non-clip element only. |

## Reproduction prompt

```
Normalise the gaps in the cue sheet for {{PROJECT}} at {{FPS}} fps.

1. CLASSIFY every consecutive pair from the transcript: CHAIN inside a breath
   group; SENTENCE at terminal punctuation; PARAGRAPH at a topic change or
   before a full-frame card; SPEAKER at a speaker change.
2. APPLY: chain -> cue[n].end = cue[n+1].start exactly (assign, never
   round-trip). sentence and speaker -> {{SENT_GAP}} = 0.20s. paragraph ->
   {{PARA_GAP}} = 0.60s. Take gap time from the trailing cue's tail, never by
   delaying the next cue past its word onset.
3. SNAP everything to the frame grid ONCE, using round(t * {{FPS}}) / {{FPS}},
   then RE-TEST: any pair whose gap is now greater than 0 and less than 2
   frames is snapped to 0 if it was a chain, or opened to exactly 2 frames if
   it was a break.
4. FADES: apply a {{FADE}} = 0.10s fade-in only to the first cue after any
   gap and a 0.10s fade-out only to the last cue before any gap. Chained
   handovers use a hard set with no fade on either side.

ACCEPTANCE TEST: no pair has a gap in the open interval (0, 2 frames); every
chained pair satisfies end == start to full precision; no frame shows two cue
texts simultaneously; and frame-stepping across three chained boundaries and
three sentence boundaries shows, respectively, an unbroken plate and a clean
6-frame clear.
```

## Execution spec

The half-open window is what makes chaining exact: a clip shows while `start ≤ t < start + duration`, so `b.start === a.start + a.duration` yields no shared frame. Author the chain as an assignment (`b.start = a.end`), never as two independently rounded numbers.

The reference `captions.html` cycle produces a gap at **every** boundary, because it fades out at `line.end`, then hard-kills at `line.end + 0.1`, then fades the next line in at its own start:

```js
tl.to(box, { opacity: 0, duration: 0.1, ease: "power2.in" }, line.end);
tl.set(box, { opacity: 0, visibility: "hidden" }, line.end + 0.1);
```

That is correct for a phrase-level track with real gaps and wrong for a chained one. For chaining, use zero-duration sets on **non-clip** elements:

```js
// chained handover — no fade, no overlap, one clean frame boundary
tl.set("#cap-0212", { autoAlpha: 0 }, 41.780);
tl.set("#cap-0213", { autoAlpha: 1 }, 41.780);
```

Binding points:

- `visibility`/`display` writes are illegal on a `.clip` element — lint rejects them and the framework owns clip visibility. The reference's hard kill is legal only because `#caption-box` is not the clip; the clip is the sub-comp host.
- Caption fades belong to the **gentle** eases, `power2.out` in and `power2.in` out — explicitly *not* the `power3.out` entrance default.
- Do not tween `opacity` on a chained handover at all. Two 0.1 s crossfading cues give roughly three frames of legible double exposure.
- If a cue must clear because of a picture cut, the gap belongs to the outgoing cue's tail — never delay the incoming cue past its word onset to manufacture one.

**Carrier note.** ASS expresses fades per event with `\fad(<in>,<out>)` in milliseconds, which is the right way to carry a per-cue fade into a burn-in. WebVTT has no fade and allows overlap; SRT has neither. See [[sub-sidecar-timing-fidelity]].

## Pairs with
[[sub-cue-duration-floor-and-ceiling]] · [[sub-word-level-cue-generation]] · [[sub-phrase-cue-assembly]] · [[sub-cue-segmentation-three-word]] · [[sub-entrance-exit-motion-budget]] · [[sub-cut-boundary-policy]] · [[sub-speaker-and-non-speech-annotation]] · [[sub-sidecar-timing-fidelity]] · [[cut-straight-hard-cut]]

## Failure modes
- **The one-frame blink.** The signature defect of a rounded cue sheet. Correction: snap once, then re-test and force every gap to 0 or ≥2 frames.
- **Crossfading a chained handover.** Three frames of double exposure that read as a rendering fault. Correction: hard `set`.
- **Gaps taken from the incoming cue.** Delaying the next cue to make room puts it behind its word onset and the whole track feels late. Correction: take gap time from the outgoing tail.
- **Uniform gaps everywhere.** A constant 0.2 s gap between every cue erases the difference between a clause break and a sentence end. Correction: classify by intent.
- **Overlapping cues because a tail hold was not clamped.** Two boxes draw at once. Correction: clamp the hold against the next start minus the gap.
- **Chaining across a speaker change.** The viewer cannot tell the line changed hands. Correction: always break at a speaker change, even mid-sentence.
- **Assuming the sidecar preserves the chain.** SRT/VTT rendering inserts its own timing behaviour and a 0-gap chain may render as a flicker in some players. Correction: for sidecar deliverables use phrase cues with real gaps.
