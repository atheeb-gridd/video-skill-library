---
id: sub-over-emphasis-audit
title: Count the emphasis before you ship — over 15 % and the mark has stopped marking
skill: subtitles
type: caption-style
family: emphasis-caption
tags: [skill/subtitles, type/caption-style, family/emphasis-caption, engine/hyperframes, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:54"
    quote: "A lot of people make the mistake of adding captions just to bump up the visual variety."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:02"
    quote: "Using captions to fill more space can get ugly fast and waste a great opportunity to put something more engaging on screen."
research_refs:
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://en.wikipedia.org/wiki/Color_blindness
  - https://www.w3.org/WAI/media/av/captions/
difficulty: medium
detectable_from: transcript+video
---

# Count the emphasis before you ship — over 15 % and the mark has stopped marking

## What it is

Emphasis is a **contrast effect**, and every contrast effect has a saturation point past which adding more of it removes the effect entirely. A caption track where 8 % of words are accented has a working code. The same track at 35 % has no code at all — it has two text colours, and the viewer has stopped attributing meaning to either.

This is not a taste judgement, it is arithmetic on attention. The mark works because it is rare enough that noticing it is free. Once marks are frequent enough that the eye lands on one every second, reading them costs the same as reading the rest, and the viewer stops.

The failure mode is systematic rather than random, because of how emphasis gets added: it accumulates. Each pass adds a few more, nobody removes any, and every individual addition is defensible. The only defence is **counting**, at a fixed point in the process, against a stated budget, with a defined action when the count is over.

Four things get counted, and the third and fourth are the ones people forget:

1. **Share** — emphasised words as a percentage of total words.
2. **Rate** — emphasis events per minute.
3. **Clustering** — the longest run of consecutive cues carrying a mark. Share and rate can both pass while every mark sits in one 20-second stretch.
4. **Treatment count** — how many *distinct* visual treatments are being used to mean "emphasis". Three treatments for one meaning is over-emphasis of a different kind, and it is invisible to a word count.

The action when a count fails is fixed and non-negotiable: **tighten the rule and re-run**, never hand-prune ([[sub-emphasis-selection-rule]]). Hand-pruning gets the count down and destroys reproducibility, so the next video starts from nothing.

## When to use it

- **After the rule is applied and before any styling.** The count is on the rule's output, not on the finished video, so a failure is cheap to fix.
- **Again after the final pass**, because emphasis accretes during review. This second count is the one that catches "can we just highlight that one too" three times.
- **On a reference video during Mode A**, to establish what the target creator's actual budget is rather than guessing it.
- Not needed when the caption role is a plain accessibility track with no emphasis layer.

The audit is also the natural place to check the **redundancy** requirement: every hue-carried distinction needs a non-colour cue, because about 8 % of male viewers will not see the hue.

## How to recognise it in a reference video

The audit is a measurement, so this section is the measurement procedure.

```bash
# 1. word-level transcript
npx hyperframes transcribe <video> --out transcript.json

# 2. sample frames at cue midpoints and read which words are marked
ffmpeg -ss <t> -i <video> -frames:v 1 -q:v 2 cue_<n>.png
```

Then compute:

| Metric | Formula | Pass | Warn | Fail |
|---|---|---|---|---|
| Share | emphasised words / total words | ≤10 % | 10–15 % | >15 % |
| Rate | events / minutes of speech | ≤5/min | 5–8/min | >8/min |
| Max run | longest consecutive cues each carrying a mark | ≤2 | 3–4 | ≥5 |
| Longest gap | max seconds with no mark | ≤45 s | 45–90 s | >90 s |
| Min gap | min seconds between two events | ≥2.0 s | 1.2–2.0 s | <1.2 s |
| Treatments | distinct visual treatments meaning "emphasis" | 1 | 2 | ≥3 |
| Simultaneous | max marks visible in one frame | 1 | — | ≥2 |
| Redundancy | % of hue-carried distinctions with a non-colour cue | 100 % | — | <100 % |
| Repeat lifts | % of lifted terms lifted on more than first mention | 0 % | ≤20 % | >20 % |

The **longest gap** row is the one that surprises people: it is possible to fail the audit by having too *little* emphasis in a stretch, because if a device disappears for two minutes the viewer stops expecting it and its next appearance reads as an anomaly rather than as a mark. A working code needs to be re-confirmed periodically.

A fast eyeball proxy, useful in review: build a 6×5 contact sheet of cue midpoints and look at it from across the room. If more than about three of the thirty tiles have a visible accent, the track is over budget.

```bash
ffmpeg -i in.mp4 -vf "fps=1/<dur/30>,scale=300:-1,tile=6x5" -frames:v 1 sheet.png
```

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `share_target` | 8 % | 5–15 % | Emphasised words over total words. |
| `share_ceiling` | 15 % | — | Hard fail. Above this the mark carries no information. |
| `rate_target` | 5 / min | 3–8 | Events per minute of speech. |
| `rate_ceiling` | 8 / min | — | Hard fail. |
| `max_run` | 2 cues | 1–4 | Consecutive marked cues. Catches clustering that share and rate both miss. |
| `min_gap` | 2.0 s | 1.2–4.0 s | Below 1.2 s two marks read as a caption track starting. |
| `max_gap` | 45 s | 30–90 s | Too little is also a failure — the code decays. |
| `treatments` | 1 | 1–2 | Distinct visual encodings of "emphasis". Three is a separate over-emphasis. |
| `simultaneous` | 1 | 1 | Never two marks in one frame. |
| `redundancy` | 100 % | 100 % | Every hue distinction has a non-colour cue. ~8 % of males see no hue difference. |
| `repeat_lift_share` | 0 % | 0–20 % | Terms lifted after first mention. |
| `audit_points` | 2 | 2 | After rule application; after final review. |
| `failure_action` | tighten the rule, re-run | — | **Never hand-prune.** |
| `hand_override_budget` | 0 | 0–2 | Each override is evidence the rule is wrong. |
| `counted_by` | script | script / manual | Manual counting reliably under-counts by about a third. |

## Reproduction prompt

```
Audit the emphasis density of the caption track for {{PROJECT}}, given
{{TRANSCRIPT}} and {{EMPHASIS_MAP}}.

Compute and report all nine metrics as PASS/WARN/FAIL with the actual number, not
a judgement:
  share        emphasised words / total words          target <=10%, fail >15%
  rate         events / minutes of speech              target <=5, fail >8
  max_run      longest consecutive marked cues         target <=2, fail >=5
  max_gap      longest stretch with no mark, seconds   target <=45, fail >90
  min_gap      shortest gap between events, seconds    target >=2.0, fail <1.2
  treatments   distinct encodings meaning "emphasis"   target 1, fail >=3
  simultaneous max marks visible in one frame          target 1, fail >=2
  redundancy   % hue distinctions with non-colour cue  must be 100%
  repeat_lifts % terms lifted after first mention      target 0%

If ANY metric fails, do not fix the output. Diagnose which clause of the emphasis
rule is over-firing, rewrite that clause to be more exclusive — usually by
tightening the part-of-speech whitelist or hardening the per-sentence gate — and
re-run the rule over the whole transcript from scratch. Report before and after
counts plus the rule diff. Hand-pruning individual marks is forbidden: it passes
the audit and destroys the rule, so the next video starts from zero.

If max_gap fails, the rule is too tight there — loosen it or accept the device is
absent in that stretch and say so. Do not add marks by hand.

Acceptance test: after the fix, all nine metrics pass, and the emphasis map's
Rule column explains every remaining mark with no entry reading "manual" or
"editorial".
```

## Execution spec

The audit runs over the same word-level transcript array that drives caption timing, so it is a pure data operation with no browser dependency — which matters here, because the browser-backed audits inside `check` cannot run on the device VM.

```js
const total   = script.length;
const marked  = emphasis.reduce((n, e) => n + (e.to - e.from + 1), 0);
const minutes = (script.at(-1).end - script[0].start) / 60;

const report = {
  share:  marked / total,
  rate:   emphasis.length / minutes,
  maxRun: longestConsecutiveMarkedCues(cues, emphasis),
  minGap: Math.min(...gapsBetween(emphasis)),
  maxGap: Math.max(...gapsBetween(emphasis)),
  treatments: new Set(emphasis.map(e => e.treatment)).size,
};
```

Notes:

- **`npx hyperframes check` does not do this.** Its contrast and layout audits are about legibility and collision, not about density. There is no framework hook for emphasis density; this audit is a project-level script.
- **`animation-map.mjs`** (`node skills/hyperframes-animation/scripts/animation-map.mjs <dir> --out <dir>/.hyperframes/anim-map`) reads every registered timeline, enumerates tweens and samples bounding boxes. It is the right tool for the **simultaneous** metric — two marks visible at once shows up as two overlapping active tweens — and for finding dead zones, which is the `max_gap` metric. It needs a browser, so it runs off the device VM.
- **The mounted vault cannot delete files.** Do not design this audit to overwrite a previous report and delete the old one. Write `emphasis-audit-<n>.md` as a superseding file and update the index, per the project constraint.
- Store the result in the design doc rather than only in a console. The **Checks** section of `_templates/design-subtitles.md` is where the pass/fail belongs.

## Pairs with

- [[sub-emphasis-selection-rule]] — the thing being audited
- [[sub-emphasis-caption-three-words]] — the per-event ceiling and the source's own budget
- [[sub-red-strikethrough-negation]] — shares the same scarcity budget
- [[sub-semantic-colour-assignment]] — the redundancy metric comes from here
- [[sub-caption-role-decision]] — the 30–70 % captioned band is the filler signature
- [[pace-visual-variety-density-audit]] — the same counting discipline applied to picture
- [[sfx-density-fatigue-audit]] — the same discipline applied to sound
- [[motion-silent-motion-tier]] — restraint as a designed tier

## Failure modes

- **Never counting.** The default state. Emphasis inflates monotonically because every individual addition is defensible.
- **Hand-pruning to pass.** Passes the audit, destroys the rule, guarantees the next video starts from taste again.
- **Counting share only.** Share and rate can both pass while every mark is clustered in one stretch and two minutes have none.
- **Counting words, not treatments.** Three visual encodings of one meaning is over-emphasis that no word count detects.
- **Auditing only at the end.** By then the styling is done and the fix is expensive, so the budget gets renegotiated instead.
- **Estimating instead of counting.** Manual estimates under-count by roughly a third, consistently and in the flattering direction.
- **Ignoring `max_gap`.** A device that vanishes for two minutes has to be re-learned; its next appearance reads as an anomaly.
- **Treating a `check` pass as an emphasis pass.** `check` has no opinion about density. And a lint error silently disables its layout and contrast audits, so `0 sample(s)` reads clean and means nothing ran.
