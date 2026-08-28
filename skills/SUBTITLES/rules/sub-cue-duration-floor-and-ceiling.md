---
id: sub-cue-duration-floor-and-ceiling
title: Five-sixths of a second minimum, seven seconds maximum — and both ends are perceptual, not arbitrary
skill: subtitles
type: caption-timing
family: cue-limits
tags: [skill/subtitles, type/caption-timing, family/cue-limits, engine/hyperframes, source/research, source/hyperframes, difficulty/medium]
source:
  - video: "research"
    timestamp: n/a
    quote: "Netflix Timed Text Style Guide, General Requirements: 'Minimum duration: 5/6 (five-sixths) of a second per subtitle event (e.g. 20 frames for 24fps)' and 'Maximum duration: 7 seconds per subtitle event'."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "The visibility window is half-open: [start, start + duration) — a clip shows while start <= t < start + duration and is hidden at exactly t = start + duration."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
difficulty: medium
detectable_from: video
---

# Five-sixths of a second minimum, seven seconds maximum — and both ends are perceptual, not arbitrary

## What it is

Two hard limits on how long a single cue may exist, and a third derived limit that the published standards do not state but every short-form track depends on.

**The floor: 5/6 of a second.** Netflix specifies a minimum of five-sixths of a second per subtitle event — **20 frames at 24 fps, 25 at 30, 50 at 60**. The reason is perceptual and specific: it takes a viewer roughly 150–250 ms to saccade to the caption, and one to two fixations to read a short cue. A caption that appears and disappears faster than that is registered as a *flash* rather than as text, and the eye is drawn to the flash — so a too-short cue costs attention while delivering no words.

**The ceiling: 7 seconds.** Netflix's maximum event duration. Past about 5 s of an unchanged cue the viewer has finished reading, looked away, and looked back — and a caption still sitting there reads as a freeze, or worse, as a sync error. In practice a phrase-level track rarely wants more than 5 s; the 7 s ceiling exists for cues that must span a long musical or non-speech stretch.

**The derived third limit: the chained floor.** The 5/6-second rule is about a caption object *appearing and disappearing*. In a chained track the object never disappears — the plate persists and only the glyphs swap. What binds there is a much lower limit, the point at which a text swap stops being a swap and becomes a flicker: about **6 frames (0.20 s) at 30 fps**, with 9 frames (0.30 s) comfortable. This is why a word-level track can run cues at a third of the broadcast minimum without looking broken, and why the two floors must be tracked separately.

The three limits interact with reading speed in a specific way: the floor is a **duration** constraint and the cap in [[sub-reading-speed-hard-cap]] is a **rate** constraint, and a cue must satisfy both. A four-character cue at the 0.83 s floor is 5 CPS — legal and slow. A 40-character cue at 0.83 s is 48 CPS — legal by duration, illegal by rate. Always check both.

## When to use it

- On every cue sheet, as a repair pass run immediately after timing and before gap normalisation.
- Whenever the timing model changes, because the floor that binds changes with it — 5/6 s for an isolated cue, 0.20 s for a chained one.
- Whenever the render fps changes, since the frame equivalents move even though the authored seconds do not.
- On imported cue sheets, which routinely carry sub-floor fragments from an unrepaired generator.
- **Do not** apply the isolated floor to a chained track or the chained floor to an isolated one; they measure different perceptual events.
- **Do not** treat the ceiling as a licence to hold: a 5 s cue over continuing speech is stale, not held.

## How to recognise it in a reference video

- **Duration histogram.** Time 20 cues frame-accurately (dense frame extraction, `select='between(n,…)'`, `-fps_mode passthrough`, never `fps=`). A broadcast-register track shows a distribution with a hard left edge at **20–25 frames** and a right tail rarely past 5 s. A chained short-form track shows a left edge at **6–9 frames**.
- **Where the left edge is** tells you which floor the creator used, and therefore whether the track is chained. This is a faster way to identify the timing model than counting words.
- **Flash defects.** Any cue under 5 frames is visible as a stutter. Look specifically at runs of short function words — that is where an unrepaired generator produces them.
- **Stalls.** Any cue over ~5 s on a talking-head video is either a deliberate hold over a non-speech stretch or a generator that failed to close the cue. Check the audio underneath: if the speaker is still talking, the cue is stale.
- **The isolated-vs-chained test.** Freeze at a cue boundary. If the plate blanks, the 0.83 s floor applies to both neighbours. If it persists, the 0.20 s floor applies.
- **Sentence-final holds.** Measure how long the last cue of a sentence stays after the audio ends — **12–24 frames** is a deliberate tail; 0 frames means the generator used `word.end` raw.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `min_duration_isolated` | 0.833 s | 0.70–1.20 s | Netflix's 5/6 s: 20 f @24, 25 f @30, 50 f @60. Binding whenever the plate fades in and out. |
| `min_duration_chained` | 0.20 s (6 f @30) | 0.17–0.30 s | Swap-only floor. Below it the swap is a flicker, not text. |
| `comfortable_chained` | 0.30 s (9 f @30) | 0.25–0.55 s | The mode a good chained track sits at. |
| `max_duration` | 5.0 s | 1.2–7.0 s | Netflix's hard ceiling is 7 s; 5 s is the practical stall threshold for speech. |
| `max_duration_nonspeech` | 7.0 s | 5.0–7.0 s | For a cue spanning a song title, a long annotation or a silent stretch. |
| `tail_hold_sentence_end` | 0.55 s | 0.35–0.90 s | Held past the last word's acoustic end. |
| `short_cue_repair` | merge | merge / extend | Merge into the neighbour with fewer words first; extend only if merging breaks a cap. |
| `long_cue_repair` | trim tail | trim / split | Never leave a stale cue up; trim the hold or split the phrase. |
| `fps` | read per file | — | 24/25/30/60 all appear in the reference set; convert the floor per file. |
| `both_checks` | duration AND rate | — | A cue must satisfy the floor and the CPS cap simultaneously. |

## Reproduction prompt

```
Enforce cue duration limits across the cue sheet for {{PROJECT}} at
{{FPS}} fps.

1. Mark each cue CHAINED if the plate does not clear between it and its
   neighbour (cue.end == next.start), otherwise ISOLATED.
2. FLOOR. Isolated cues under {{MIN_ISO}} = 0.833s (= round(0.833 * {{FPS}})
   frames): extend the end into the following gap, stopping {{MIN_GAP}}
   before the next cue's start; if there is no room, merge with the
   neighbour holding fewer words. Chained cues under {{MIN_CHAINED}} = 0.20s:
   merge only - never stretch a chained cue, because stretching pushes the
   next cue off its word onset.
3. CEILING. A cue over {{MAX}} = 5.0s with speech under it is stale -
   re-split the phrase. A non-speech stretch may reach 7.0s, never more.
4. TAIL. The last cue of each sentence gets end = last word's end +
   {{TAIL}} = 0.55s, clamped against the next cue.
5. Re-run the reading-rate check: extending lowers CPS, but merging raises
   the character count and can push a merged cue over the cap.

ACCEPTANCE TEST: no isolated cue is under round(0.833*{{FPS}}) frames; no
chained cue is under 6 frames at 30fps equivalent; no cue exceeds 7.0s and
no speech-bearing cue exceeds 5.0s; every repair is logged with the cue
index, old and new times, and the rule applied; and no cue exceeds the CPS
cap afterwards.
```

## Execution spec

Durations are authored in **seconds**; there is no frame-based data attribute anywhere in HyperFrames. Convert the floor for the render fps at authoring time and leave the frame count as a comment: `// 25 frames @30fps = 0.833s`. Render fps comes from `npx hyperframes render --fps 24|30|60` and defaults to 30, and `data-fps` on the root is only a hint that CLI flags override — so the floor you authored in seconds stays correct across fps changes while the frame comment does not. That asymmetry is a feature: author the perceptual number, annotate the frame count.

The **half-open visibility window** is what makes the ceiling side subtle. A clip shows while `start ≤ t < start + duration` and is hidden at exactly `start + duration`, so two cues authored back to back (`b.start === a.start + a.duration`) produce no overlapping frame — which is exactly the chained handover you want. It also means any tween that resolves *on* the boundary never renders its final frame: land the fade-out slightly before the end, not on it.

For the caption sub-composition itself, the root `data-duration` must cover the last cue's end plus its fade. It is read **once at compile time** and cannot be changed by a script or `--variables`, and a timeline running past it is simply cut off — which is exactly what the reference `captions.html` does, with a 10 s root over a transcript running to 16.02 s. Compute the root duration from the cue sheet.

Where cues are one element each, the floor is enforced by the distance between two `tl.set()` positions; where a single reused box is used, it is the distance between the fade-in and fade-out tween positions. Either way the floor lives in the cue array, not in the composition — repair it before authoring.

## Pairs with
[[sub-inter-cue-gap-and-chaining]] · [[sub-reading-speed-hard-cap]] · [[sub-word-level-cue-generation]] · [[sub-phrase-cue-assembly]] · [[sub-cue-segmentation-three-word]] · [[sub-cue-splitting-on-overflow]] · [[sub-entrance-exit-motion-budget]] · [[motion-impact-frame-quantisation]]

## Failure modes
- **Applying the 0.83 s floor to a chained track.** Every cue gets stretched, the chain drifts off the word onsets, and by the end of a sentence the caption is a word behind the voice. Correction: chained cues merge, they never stretch.
- **Applying the 0.20 s floor to an isolated track.** Produces flashes. Correction: 5/6 s whenever the plate fades.
- **Stale long cues.** A cue over 5 s with speech continuing under it means the generator never closed it. Correction: re-split.
- **Extending a cue into the next one.** Overlapping cues double-draw or fight for the same box. Correction: clamp against the next start minus the gap.
- **Converting the floor to frames once and reusing it.** The reference set contains 60, 25 and 29.97 fps files; 20 frames is the floor at 24 fps and a flash at 60. Correction: read fps per file.
- **Landing the fade-out exactly on `data-duration`.** The half-open window means its final frame never renders. Correction: land it before.
- **Repairing durations after the rate check.** Merging raises characters and can push a merged cue over the CPS cap. Correction: re-run the rate check after every duration repair.
