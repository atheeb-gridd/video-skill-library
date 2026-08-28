---
id: sub-cut-boundary-policy
title: Break at the cut or ride through it — decide once, per role, and write it into the profile
skill: subtitles
type: caption-timing
family: shot-change
tags: [skill/subtitles, type/caption-timing, family/shot-change, engine/hyperframes, engine/ffmpeg, source/research, source/editing-kt, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:09"
    quote: "So I only use captions when I want the viewer to catch specific words and pay extra attention to them."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "A dissolve or crossfade produces no spike. The change is spread over N frames... a crossfade appears in the per-frame dump as a plateau of mid-range scores, not a peak."
research_refs:
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: high
detectable_from: video
---

# Break at the cut or ride through it — decide once, per role, and write it into the profile

## What it is

[[sub-shot-change-snapping]] answers "where does a boundary go when it is near a cut". This note answers the prior question: **should there be a boundary at the cut at all?**

Two policies, and they produce visibly different videos.

**Break at cuts.** Every hard cut ends the current cue. The caption clears with the outgoing shot and a new cue begins with the incoming one. This is the broadcast instinct, and the argument for it is a real perceptual one: a shot change resets the viewer's visual scan. A caption that survives the cut is, from the eye's point of view, a *new* stimulus in a *new* scene, and viewers demonstrably re-read subtitles that persist across a shot change — the re-reading behaviour the eye-tracking literature measures around subtitle display generally is at its worst here. Breaking at the cut means the text the viewer re-reads is text they were going to read anyway.

**Ride through.** The cue is timed purely to speech and ignores the picture entirely. The argument for it is equally real: in modern short-form the cut rate is often faster than the speech rate — a cut every 1.5 seconds against a clause every 3 — so breaking at every cut would shred the captions into sub-second fragments that violate the duration floor and destroy read-ahead. Riding through also keeps the caption as a **continuity element**: a caption that persists across a cut tells the viewer the thought did not change even though the picture did, which is exactly what a B-roll insert needs.

The decision is therefore not a matter of taste, it is a function of three measurable things: the **cut rate**, the **caption role**, and whether the cut is a *content* cut or a *coverage* cut.

- **Content cut** (new subject, new location, new idea): break. The thought changed.
- **Coverage cut** (B-roll insert, punch-in, cutaway to a screen recording, reverse angle on the same speaker): ride through. The thought did not change.

That distinction is the actual rule, and it is more useful than either blanket policy — but it costs a classification pass. The blanket policies are the fallbacks when you cannot classify: **break at cuts when the median shot length is above ~2.5 s, ride through when it is below**.

## When to use it

- Decide **once per video**, at profile time, and record it. A track that breaks in some scenes and rides in others without a stated rule reads as inconsistent.
- **Break** for talking-head interview material, documentary-style content, anything with long shots and a formal register, and any accessibility deliverable.
- **Ride through** for fast-cut short-form, montage sequences, and any track whose role is an emphasis layer rather than a full transcript.
- **Classify per cut** when the video mixes both — a long-form explainer with B-roll inserts is the standard case, and it is worth the pass.
- Re-check the policy whenever the edit changes: adding a B-roll pass changes the cut rate and can invalidate the choice.

## How to recognise it in a reference video

- **The core measurement.** Build the cut list (`select='gt(scene,0.3)'` for hard cuts, plus a confirmed `gt(scene,0.10)` pass for punch-ins), build the cue boundary list, and compute how many cuts fall **inside** a cue rather than at its edge. A break-at-cuts track shows **<10 %** of cuts landing inside a cue; a ride-through track shows **>60 %**.
- **Median shot length vs. median cue length.** Break-at-cuts tracks have cue lengths at or below shot lengths. Ride-through tracks have cues spanning 2–5 shots.
- **The B-roll test.** Find a B-roll insert over continuous narration. If the caption clears at the insert and returns after, the policy is break — and it will read as a mistake, because the narration never stopped.
- **Cut classification.** Sample 10 cuts and mark each as content or coverage from the frames on either side. Then check what the caption did at each. A consistent split (break at content, ride at coverage) is the sophisticated policy and is worth logging as such.
- **Dissolves.** Check separately: they produce no detection spike, so a break-at-cuts pass built from a threshold list will silently ride through every dissolve. If the reference breaks at dissolves too, the creator is working from an edit list, not from detection.
- **Fragment count.** Count cues under the duration floor. A break-at-cuts policy applied over fast cutting produces a cluster of them, and that cluster is the evidence the policy was wrong for the material.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `cut_policy` | classify | break / ride / classify | One value per video, recorded in `PROFILE.md`. |
| `fallback_threshold` | 2.5 s median shot | 2.0–3.5 s | Above it break, below it ride, when classification is not available. |
| `content_cut_action` | break | break | The thought changed; so should the cue. |
| `coverage_cut_action` | ride | ride | B-roll, punch-in, cutaway, reverse angle. |
| `break_gap` | 0.20 s (6 f @30) | 0.13–0.40 s | The clear at a content cut. |
| `min_cue_after_break` | 0.833 s | 0.70–1.20 s | If a break would produce a shorter cue, do not break. |
| `max_shots_per_cue` | 4 | 2–6 | A ride-through cue spanning more than this is probably stale. |
| `dissolve_policy` | treat as content cut | content / ignore | Detect via per-frame plateau, not a threshold list. |
| `punch_in_policy` | ride | ride / break | A punch-in is the same shot; breaking there is almost always wrong. |
| `role_override` | emphasis layer → ride | — | An emphasis caption is bound to a word, not to a shot. |
| `policy_exceptions` | logged | — | Every deviation from the recorded policy carries a one-line reason. |

## Reproduction prompt

```
Decide and apply the cut-boundary policy for the caption track of {{VIDEO}}.

1. MEASURE. Build the hard-cut list with
   ffmpeg -v error -i {{VIDEO}} -vf "select='gt(scene,0.3)',showinfo"
   -fps_mode vfr -an /tmp/cuts/%04d.png
   and compute median shot length. Run a second pass at gt(scene,0.10),
   confirm each extra boundary visually, and mark those as punch-ins.
2. CHOOSE. If {{POLICY}} is given, use it. Otherwise: if the caption role is
   an emphasis layer, RIDE. Else if median shot length < 2.5s, RIDE. Else
   CLASSIFY every cut as CONTENT (subject, location or idea changes) or
   COVERAGE (B-roll, punch-in, cutaway, reverse angle), breaking at content
   cuts and riding through coverage.
3. APPLY. At each breaking cut: end the current cue at the cut frame, open a
   {{BREAK_GAP}} = 0.20s clear, start the next cue at its own word onset.
   VETO the break if either resulting cue would fall below {{MIN}} = 0.833s
   or above {{CPS}} = 17 CPS, and log it.
4. AUDIT cues spanning more than {{MAX_SHOTS}} = 4 shots; a cue riding
   through five shots is usually stale.
5. RECORD the policy, the median shot length behind it, and every exception.

ACCEPTANCE TEST: the policy is stated once and every cue obeys it or carries
a logged exception; no break produced a cue under the floor; and the count of
cuts falling inside a cue matches the policy (<10% for break, >60% for
ride).
```

## Execution spec

The policy is applied to the inlined cue array at build time — nothing in HyperFrames knows what a cut is. But if the composition itself assembles the picture, **you already have the cut list**: every clip's `data-start` is a cut, and reading them from the DOM is exact where detection is statistical. Prefer that. Detection is for reference analysis and for footage that arrives pre-cut as one file.

Beware the framework's transition semantics when reading cut times off a composition. The transition injector **extends** the outgoing clip's `data-duration` by the transition duration and pulls the incoming clip's `data-start` **earlier** by the same amount to create the overlap, then ping-pongs `data-track-index` between 0 and 1 for readability. So the authored `data-start` of the incoming clip is the *start of the transition*, not the frame the viewer perceives as the cut. For a 0.5 s `crossfade` the perceptual boundary is roughly the midpoint; for a 0.4 s `zoom-through` it is nearer the end. Snap to the perceptual boundary, not to the attribute.

Relative timing makes this worse if you trust it blindly: `data-start="intro + 2"` resolves silently to `0` when the reference is unresolvable, when the target has no resolvable duration it lands on the target's **start** rather than its end, and spaces around the operator are required. Any cut list derived from relative-timed clips needs a snapshot check before captions are timed against it.

Cross-skill: the classification this note asks for is the same one [[cut-hard-cut-for-new-information]] and [[cut-b-roll-coverage-from-transcript]] already make on the editing side. If the project has a cut ledger, read it instead of re-deriving it, and treat any disagreement as a finding.

## Pairs with
[[sub-shot-change-snapping]] · [[sub-fast-cut-sequence-captions]] · [[sub-caption-role-decision]] · [[sub-cue-duration-floor-and-ceiling]] · [[sub-caption-graphic-collision]] · [[cut-hard-cut-for-new-information]] · [[cut-b-roll-coverage-from-transcript]] · [[cut-punch-in-emphasis]] · [[pace-shot-length-follows-interest]] · [[motion-continuity-across-the-seam]]

## Failure modes
- **Breaking at every cut over fast-cut material.** Produces a shower of sub-floor fragments and destroys read-ahead. Correction: ride, or classify.
- **Riding through a content cut.** The caption from the previous idea sits over the new subject and reads as a sync error. Correction: break at content cuts.
- **Breaking at a punch-in.** A punch-in is the same shot; clearing the caption there implies a change that did not happen. Correction: ride.
- **Policy decided per scene by whoever authored that scene.** The most common cause of an inconsistent-feeling track. Correction: one recorded policy plus logged exceptions.
- **Cut list taken from authored `data-start` values with transitions applied.** The injector has already moved them; captions snap to the wrong frame. Correction: use the perceptual boundary.
- **Ignoring dissolves.** They never appear in a threshold-derived cut list, so the policy silently does not apply to them. Correction: per-frame dump.
- **Not re-deciding after a re-edit.** Adding a B-roll pass can halve the median shot length and invalidate a break policy. Correction: re-measure after every structural edit.
