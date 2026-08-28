---
id: sub-reading-speed-hard-cap
title: Reading speed is a hard cap — 17–20 CPS, computed per cue, and the research says why
skill: subtitles
type: caption-timing
family: cue-limits
tags: [skill/subtitles, type/caption-timing, family/cue-limits, engine/hyperframes, source/research, source/editing-kt, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:20"
    quote: "Also keep it to three words or fewer, since that makes them easier to read."
  - video: "research"
    timestamp: n/a
    quote: "Netflix English Timed Text Style Guide: 'Adult programs: up to 20 characters per second. Children's programs: up to 17 characters per second.'"
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
difficulty: medium
detectable_from: transcript+video
---

# Reading speed is a hard cap — 17–20 CPS, computed per cue, and the research says why

## What it is

Reading speed is the ratio of on-screen characters to display seconds. It is the only caption constraint that is a *comprehension* limit rather than a layout limit, and it is the one most often shipped as a mean instead of enforced as a cap.

**The published numbers.** Netflix's English style guide sets **20 characters per second for adult programmes and 17 for children's**. DCMP works in words per minute and caps presentation at **130 wpm (lower level), 140 (middle), 160 (upper)** — and counts speaker IDs and sound-effect annotations in the total. The two units convert at roughly 5.5–6 characters per word including the following space, so 160 wpm ≈ 15–16 CPS and 20 CPS ≈ 200–215 wpm. Those are not the same number, and the difference is not an error: DCMP is writing for educational media and a reading-age spread; Netflix is writing for general entertainment where the viewer usually also hears the soundtrack.

**What the research actually found**, and it is more interesting than the guidelines. Szarkowska and Gerber-Morón tested subtitles at **12, 16 and 20 cps** with eye tracking and comprehension measures. Subtitle speed had **no statistically significant effect on comprehension** at any tested speed. What changed was reading behaviour: slower subtitles produced *more* fixations and longer mean fixation durations, and viewers **re-read roughly two of every three subtitles at 12 cps versus about one in five at the faster speeds**. Fast subtitles showed a higher proportion of display time spent actually reading.

Two conclusions follow, and both are load-bearing.

1. **The cap is a ceiling, not a target.** There is no comprehension benefit to sitting far under it, and there is a measurable cost: spare display time is spent re-reading rather than watching the picture.
2. **The cap is defended, not optimised.** The published figures are conservative for good reason — they must hold for the worst viewer, the worst cue and the worst frame, not the average. So enforce it per cue and fail the build, rather than reporting a mean.

**The sound-on exception, stated precisely.** A chained short-form track routinely measures 25–35 CPS. That is above every published cap and it is not automatically wrong, because the viewer is also *hearing* the words: the caption is a redundant channel reinforcing the audio, not the sole carrier of meaning. The moment the deliverable is muted-first — a silent autoplay feed — that redundancy vanishes and the published cap binds again. So the profile carries **two** caps and the deliverable picks one.

## When to use it

- On every phrase-level and hybrid cue, as a hard gate before render.
- On word-level chained tracks, computed and recorded but enforced only against the muted cap when the deliverable is muted-first.
- When choosing between splitting a cue and holding it longer — the cap is what decides.
- When a reference track "feels rushed" and you need a number instead of an opinion.
- **Do not** use the cap to justify rewriting speech. Verbatim is a correctness rule; a cue that fails the cap gets split or held, never edited. Reducing text to hit a rate is a DCMP-sanctioned move for educational captioning of read-aloud material and is out of scope for a creator track.

## How to recognise it in a reference video

Reading rate is fully measurable from the video alone, and it is the single most diagnostic caption number.

- **Per-cue CPS.** For 20 sampled cues: count characters of the visible text **including spaces and punctuation**, divide by the cue's display duration measured frame-accurately. Report the distribution, not the mean — the p90 is the number that characterises the track.
- **Typical bands.** Broadcast/accessibility tracks: **10–17 CPS**. Modern phrase-level creator tracks: **14–20 CPS**. Chained word-level short-form: **25–35 CPS**. Anything sustained above 40 CPS is unreadable regardless of styling and indicates the caption is decorative.
- **WPM cross-check.** Words ÷ minutes on-screen. Multiply CPS by ~10.5 for a rough wpm. If the two disagree badly, the track has unusually long or short words — which is itself the finding, and the reason [[sub-hinglish-reading-rate]] exists for romanised Hindi.
- **Speech rate vs. caption rate.** Compute the speaker's wpm from the transcript. In a chained word track they will match by construction. In a phrase track the caption rate should be **at or below** the speech rate, because the tail hold adds display time.
- **Worst-cue test.** Find the cue with the most characters and time it. One 28 CPS cue in an otherwise 15 CPS track is the defect a viewer notices.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `cps_cap_muted` | 17 CPS | 15–20 | Netflix: 20 adult, 17 children. Binding when the caption is the only channel. |
| `cps_cap_sound_on` | 30 CPS | 25–35 | Chained short-form only, where the audio carries the meaning. |
| `cps_target` | 14 CPS | 12–17 | A target, not a floor — under 12 CPS costs re-reading, not comprehension. |
| `wpm_cap` | 160 wpm | 130–200 | DCMP: 130 lower / 140 middle / 160 upper level. Includes speaker IDs and sound annotations. |
| `chars_counted` | all glyphs + spaces | — | Count what is rendered, including punctuation and the space between lines. |
| `measure_unit` | per cue | per cue | Never a track mean. |
| `p90_cps` | ≤ cap | — | Report it; it characterises the track better than the mean. |
| `over_cap_action` | split, then hold | split / hold | Split first ([[sub-cue-splitting-on-overflow]]); extend only if there is room before the next cue. |
| `annotation_counts` | true | true/false | Speaker IDs and `[sound]` annotations count toward the rate. |
| `deliverable_mode` | sound-on | sound-on / muted-first | Picks which cap binds. Recorded in the profile, once. |
| `speech_rate_source` | transcript | — | `(word count / duration) * 60`, computed over the whole programme and per scene. |

## Reproduction prompt

```
Enforce the reading-speed cap across the cue sheet for {{PROJECT}} and fail
the build if any cue exceeds it.

1. Read {{DELIVERABLE_MODE}}. If muted-first, CAP = {{CPS_MUTED}} = 17. If
   sound-on and the model is chained word-level, CAP = {{CPS_SOUND_ON}} = 30.
   Record which cap is in force and why.
2. For every cue compute chars = length of the rendered text INCLUDING
   spaces, punctuation, speaker prefixes and bracketed sound annotations;
   duration = cue.end - cue.start in seconds; cps = chars / duration.
3. Report: mean cps, median, p90, max, and the five worst cues with their
   text, index and cps.
4. For every cue over CAP, in this order: (a) split it at the best syntactic
   point so both halves fall under CAP; (b) if it cannot be split without
   breaking a never-split pair, extend its end into the following gap, never
   past the next cue's start minus {{MIN_GAP}}; (c) if neither works, flag it
   for a human. NEVER shorten, reword or paraphrase the text, and never
   reduce the type size to buy characters.
5. Cross-check: compute the speaker's wpm from the transcript. If caption wpm
   exceeds speech wpm anywhere in a phrase-level track, the tail holds are
   too short - investigate before shipping.

ACCEPTANCE TEST: zero cues exceed CAP; p90 cps is reported and is at or under
CAP; no cue text differs by a single character from the transcript; and the
cap actually applied is written into design-subtitles.md with the deliverable
mode that selected it.
```

## Execution spec

Nothing in HyperFrames measures reading rate — there is no caption primitive and no reading-rate audit. This is a build-time check over the cue array **before** it is inlined into the composition, and it should be the same script that gates the batch pipeline.

Two contract facts shape how the fix is applied:

- **Extending a cue is a timing change, and it is cheap.** Cue times are plain numbers in the inlined array; extending `cue.end` costs nothing at render. But the extension must be clamped against the next cue's start minus the minimum gap, or the plate double-draws.
- **Shrinking the type is not a legal fix and the layout audit will not save you.** `.caption-text` in the reference uses `white-space: nowrap` with `overflow: hidden`, so an over-long line silently clips; the layout audit still measures `getBoundingClientRect` at sampled timestamps and reports the overflow, and `overflow: hidden` does not suppress the finding. Buying reading time with point size trades a rate failure for a legibility failure, and the size floor is set by [[sub-size-as-frame-height-percentage]], not by the cue sheet.

For a **muted-first** deliverable, run the check twice: once against the cue text, once against the cue text plus any speaker prefixes and bracketed sound annotations, because those count toward the rate and are frequently added after the rate check ran.

Cross-skill: the speech rate that feeds this cap is the same number [[pace-speech-rate-to-bpm-map]] uses, and a scene that is over cap on captions is usually also over cap on cut density — check [[pace-visual-mush-ceiling]] before blaming the captions.

## Pairs with
[[sub-hinglish-reading-rate]] · [[sub-cue-splitting-on-overflow]] · [[sub-phrase-cue-assembly]] · [[sub-cue-duration-floor-and-ceiling]] · [[sub-line-length-and-line-count]] · [[sub-timing-model-selection]] · [[sub-speaker-and-non-speech-annotation]] · [[pace-speech-rate-to-bpm-map]] · [[pace-visual-mush-ceiling]]

## Failure modes
- **Reporting a mean.** A 14 CPS mean routinely hides three cues at 26 CPS, and those three are the ones the viewer trips on. Correction: per-cue hard gate, p90 in the report.
- **Rewriting speech to fit.** A correctness bug dressed as a style choice. Correction: split or hold.
- **Shrinking the type to buy characters.** Trades a rate failure for a legibility failure and usually breaks the size floor. Correction: split.
- **Applying the sound-on cap to a muted-first deliverable.** A 30 CPS chained track is fine in a sound-on feed and illegible in a silent autoplay. Correction: record the deliverable mode and let it pick the cap.
- **Treating the cap as a target.** Holding every cue at 10 CPS produces re-reading, not comprehension — viewers re-read about two of three subtitles at 12 cps. Correction: aim near the target band and defend the ceiling.
- **Forgetting annotations.** Speaker IDs and `[door slams]` count toward the rate and are usually added after the check. Correction: run the check on the final rendered text.
- **Ignoring the transition case.** A cue that is legal at 17 CPS but sits under a busy graphic effectively has less reading time. Correction: the collision check in [[sub-caption-graphic-collision]].
