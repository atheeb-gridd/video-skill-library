---
id: sub-batch-generation-and-qc
title: Generate a long video's cues in one deterministic pass, then gate the build on a machine QC
skill: subtitles
type: caption-timing
family: caption-pipeline
tags: [skill/subtitles, type/caption-timing, family/caption-pipeline, engine/hyperframes, engine/ffmpeg, source/hyperframes, source/research, difficulty/high]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "A lint error also switches off the layout and contrast audits: `check` then reports `0 sample(s)` and `0/0 text checks`, which reads like a clean file but means nothing ran."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Above ~600 cards, split the track into per-scene sub-comps rather than one file."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://github.com/m-bain/whisperX
difficulty: high
detectable_from: transcript+video
---

# Generate a long video's cues in one deterministic pass, then gate the build on a machine QC

## What it is

A 60-second short has about 25 phrase cues or 200 word cues. A 12-minute explainer has **300 phrase cues or 2,400 word cues**. At that scale every rule in this library stops being something you check and becomes something you *enforce in code*, because the failure rate of hand inspection at 2,400 items is effectively 100 %.

The pipeline is a fixed sequence of pure transforms over the transcript, each one idempotent, each one logging what it changed:

```
transcribe → correct text → force-align → ALIGN QC (gate)
  → segment (model-specific) → time → duration repair → gap normalise
  → cut snap → rate check → split/redistribute → CUE QC (gate)
  → author composition → hyperframes check (gate) → render → spot-check
```

Two properties make this work at length.

**Determinism.** The same transcript must produce the same cue sheet every run. No wall-clock, no unseeded randomness, no "pick the nicer break". This is the same constraint the render engine imposes on compositions — no `Date.now()`, no unseeded `Math.random()`, no fetches — and it applies to the generator for the same reason: a non-deterministic generator makes every QC result unreproducible.

**Gates, not reports.** A QC that prints warnings gets skimmed. A QC that exits non-zero stops the build. There are three natural gates: after alignment, after cue generation, and after `hyperframes check`. Each has a **countable** pass criterion and a written exceptions list; nothing proceeds on "looks fine".

**The QC must report how much it inspected.** This is the lesson from the framework's own audit behaviour: a lint *error* switches off the layout and contrast audits, after which `check` reports `0 sample(s)` and `0/0 text checks` — output that reads like a clean file and means nothing ran. Every gate in this pipeline prints its denominators: cues checked, frames sampled, words covered.

**Sampling for the human pass.** A human still looks, but at a designed sample, not at the whole thing: the first and last cue, every cue flagged by any gate, one cue at each of five evenly spaced points, the three longest and three shortest cues, and every cue that crosses a scene transition. That is 20–30 cues on a 12-minute video, and it is a real inspection rather than a scroll.

## When to use it

- Any programme over about 3 minutes, and any project where the caption track will be regenerated more than once.
- Any project where the picture is likely to be recut after captions exist — the pipeline makes regeneration cheap and slipping cues impossible.
- Any multi-deliverable project (horizontal master plus vertical cutdowns), where the same transcript feeds several cue sheets with different caps.
- **Do not** build the pipeline for a single 30-second video; the cost dominates. But do run the same *gates* by hand.

## How to recognise it in a reference video

You are looking for evidence of consistency at scale, which is exactly what hand-authoring cannot produce.

- **Parameter stability across the runtime.** Sample cues at 10 %, 50 % and 90 % of the video and measure cap height as a percentage of frame height, baseline position as a percentage from the bottom, characters per line, and CPS. A generated track holds all four within a few percent. A hand-authored track drifts — usually the type gets smaller as the editor gets tired of it colliding with graphics.
- **Defect clustering.** Hand-authored tracks have defects clustered in the last third. Generated tracks have defects distributed uniformly, or none.
- **Cue count vs. word count.** Compute words per cue across the whole video. A generated track's distribution is tight; a hand-authored one is bimodal.
- **The pathological cases.** Find the three longest cues and the three shortest in the whole video. In a gated track they are inside the floor and ceiling; in an ungated one, the shortest is 3 frames and the longest is 9 seconds.
- **Regeneration evidence.** If a video exists in horizontal and vertical cuts with identical wording but different line breaks and cue boundaries, the track was generated from one transcript against two caps — a strong signal.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `pipeline_stages` | 12 | — | Each stage pure, idempotent and logged. |
| `determinism` | required | — | Same input, same cue sheet, byte for byte. |
| `gate_1` | alignment QC | — | Monotonic, coverage, confidence, OOV, offset. |
| `gate_2` | cue QC | — | Duration, gap, rate, line, snap, verbatim. |
| `gate_3` | `hyperframes check` | — | Lint clean, then layout and contrast with non-zero samples. |
| `exceptions_budget` | 2 % of cues | 0–5 % | Above this, fix the rule, not the cues. |
| `human_sample_size` | 20–30 cues | — | Designed sample, not a scroll. |
| `cues_per_subcomp` | 600 | 300–900 | Above this, split into per-scene sub-comps. |
| `regen_on_recut` | always | — | Never slip cues by hand after a picture change. |
| `report_denominators` | required | — | Cues checked, frames sampled, words covered. |
| `spot_check_render` | 5 points + all flags | — | Frame-accurate, at native fps. |
| `artefact_retention` | transcript, align, cues, QC | — | Every intermediate kept so a defect can be bisected. |

## Reproduction prompt

```
Build and run the caption pipeline for the long-form video {{VIDEO}}.
Produce a cue sheet, a QC report and a gated build.

STAGE 1-3: transcribe; apply and log text corrections; force-align. GATE A -
the alignment QC (monotonicity, duration outliers, silence agreement,
confidence floor, coverage with exact spelling, global offset). Exit non-zero
on any hard failure. Print words checked, OOV count and mean confidence.

STAGE 4-9: segment per the recorded timing model; time the cues; repair
durations; normalise gaps; snap to cuts per the recorded cut policy; run the
rate check and split/redistribute. GATE B - the cue QC: every cue inside the
duration floor and ceiling, no gap in the forbidden band, every cue at or
under {{CPS}} characters per second and {{LINE}} characters per line, cue
text identical to the corrected transcript token for token, starts strictly
increasing. Print cues checked and the exceptions list.

STAGE 10-12: author the composition with the cue array inlined; run
hyperframes check and ASSERT its sample count is greater than zero before
believing a pass; render; inspect frames at 5 evenly spaced points plus every
flagged cue.

Every stage is deterministic: no clocks, no unseeded randomness, no network.
Keep every intermediate artefact.

ACCEPTANCE TEST: re-running the pipeline on the same inputs produces a
byte-identical cue sheet; both gates report non-zero denominators and zero
hard failures; the exceptions list is under {{BUDGET}} = 2% of cues with a
reason per entry; and the human sample shows no defect the gates missed.
```

## Execution spec

**Composition scale is the first real constraint.** One element per cue is the seek-robust authoring pattern, and at 2,400 cues that is 2,400 absolutely-positioned spans in one file. Split into **per-scene sub-compositions** above roughly 600 cues. Each sub-comp gets its own `data-composition-id`, its own paused timeline registered on `window.__timelines`, and **scene-local** cue times — the sub-comp's internal timeline runs from the host's `data-start` to `data-start + data-duration`, so cue times inside it are relative to the scene, not the programme. Getting that conversion wrong is the classic long-video caption bug; keep the global cue sheet as the source of truth and derive scene-local arrays from it mechanically.

Other binding facts at scale:

- **Ids must be unique across the assembled page.** Prefix per-scene cue ids with the composition id (`#cap-s03-0117`). The compiler stamps `data-hf-render-id` on media elements only.
- **Root `data-duration` is read once at compile time** and cannot be changed by a script or `--variables`. Compute it from the last cue's end plus its fade, per sub-comp and at the root.
- **Never construct timelines inside `async`/`setTimeout`/`Promise`** and register the timeline only after the build completes; building inside `document.fonts.ready` is supported and is the right hook when the caption face is webfont-loaded.
- **`hyperframes check` gates the build** and `render` is the only thing that produces an MP4. Treat a lint error as a stop, not a warning, precisely because it silently disables the audits you were relying on.

The generator itself lives outside the framework — there is no caption primitive, no SRT/VTT ingest and no subtitle renderer — so all of this is your code producing an array of `{text, start, end}` in seconds to three decimals, exactly the shape `compositions/captions.html` inlines.

Where a recut happens, `transcript-cut.mjs` is the compiler that removes ranges from picture and transcript together; the pipeline then re-runs from stage 3. That is the whole argument for building it.

## Pairs with
[[sub-alignment-qc-pass]] · [[sub-cue-splitting-on-overflow]] · [[sub-latency-and-offset-correction]] · [[sub-cue-duration-floor-and-ceiling]] · [[sub-inter-cue-gap-and-chaining]] · [[sub-cut-boundary-policy]] · [[sub-sidecar-timing-fidelity]] · [[sub-over-emphasis-audit]] · [[pace-rough-cut-diagnostic]]

## Failure modes
- **A QC that warns instead of failing.** At 2,400 cues, warnings are noise. Correction: exit non-zero.
- **Trusting a green `check` after a lint error.** `0 sample(s)` reads like a pass. Correction: assert the denominator.
- **Non-deterministic generation.** Two runs produce different sheets, so no QC result is reproducible and no bug can be bisected. Correction: pure transforms only.
- **One 2,400-element composition.** Slow to author, slow to check, and a single mistake affects the whole file. Correction: per-scene sub-comps above ~600 cues.
- **Scene-local vs. global time confusion.** Cues in scene 7 land 40 seconds early because global times were pasted into a sub-comp. Correction: derive scene-local arrays mechanically from the global sheet.
- **Hand-patching a cue after the pipeline ran.** The next regeneration silently reverts it. Correction: fix the rule or add a recorded exception.
- **Slipping cues after a recut.** Every cue after the cut is wrong, and wrong differently on either side of a mid-phrase removal. Correction: re-run from alignment.
- **An exceptions list nobody reads.** Correction: cap it at 2 % and require a reason per entry.
