---
id: cut-hard-cut-for-new-information
title: The straight cut is the reset — use it whenever the viewer must take on new information
skill: editing
type: cut
family: scene-boundary
tags: [skill/editing, type/cut, family/scene-boundary, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:38"
    quote: "Here you see we cut cleanly from this bar scene to this office scene, and we're ready to take on new information."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:29"
    quote: "The cut is an instant switch between one shot to another, including audio."
research_refs:
  - https://onlinelibrary.wiley.com/doi/10.1111/j.1551-6709.2011.01202.x
  - https://bpb-us-e2.wpmucdn.com/sites.wustl.edu/dist/e/952/files/2017/09/maglianoandzacks2011-22vhbrv.pdf
  - https://ualresearchonline.arts.ac.uk/id/eprint/21187/2/6679.pdf
  - https://pmc.ncbi.nlm.nih.gov/articles/PMC8710938/
  - https://www.backstage.com/magazine/article/types-of-cuts-in-film-75730/
difficulty: low
detectable_from: video
---

# The straight cut is the reset — use it whenever the viewer must take on new information

## What it is
This is the **boundary-classification rule**, not the mechanics of the join — the mechanics (picture and audio switching on the same frame, zero overlap, the anti-click frame) live in [[cut-straight-hard-cut]] and are assumed here. What this note decides is *which* transition a given boundary gets, and the answer is a straight cut whenever the incoming material is **new**. Its editorial function at a scene boundary is a *reset*: the previous location, topic and information load are dropped and the viewer arrives ready to take on the next one. Everything softer — a dissolve, a fade, a shader wipe — signals the opposite thing. Fades and dissolves entered the language as **conventions for time passage and continuity**, not for topic change, so putting one at an information boundary tells the viewer "this continues" while the content says "this is new". The cut costs nothing, occupies no frames, and is the only transition that is genuinely free of a claim about the relationship between the two shots.

## When to use it
Default at every boundary where the incoming material is **new**: a new location, a new topic, a new list item, a new speaker introducing a new point, a return from a demonstration to the presenter, the entry and exit of a mid-roll segment. Use it especially where the next shot carries **information the viewer must read** — a graphic, a number, an on-screen line — because a dissolve spends the first 12–24 frames of that shot at partial opacity, which is exactly the window in which the viewer would otherwise have started reading. Do **not** use it where the relationship between the shots *is* the point: passage of time within a scene ([[cut-dissolve-time-passage]]), a structural act boundary ([[cut-fade-bookend]]), a dream or death ([[cut-fade-to-white]]), or a shared element carried across ([[cut-graphic-match]], [[cut-movement-match]]). And do not smooth an information boundary with a split edit — a J or L cut deliberately blurs the boundary, which is the wrong tool here ([[cut-j-audio-leads-picture]]).

## How to recognise it in a reference video
The detection work here is **classification**, not identification: [[cut-straight-hard-cut]] tells you *whether* a boundary is a hard cut; this note tells you whether it should have been.

- **Build the boundary table first.** For every transition in the reference, log four columns: transition type, transition length in frames, whether the incoming segment introduces new information, and what relationship (if any) a soft transition is asserting. Every row where the type and the content disagree is a finding.
- **Zero-overlap test, per boundary.** Step frames across the cut. A straight cut has **no frame containing both images** — frame N is entirely shot A, frame N+1 entirely shot B. One or more blended frames means a dissolve, not a cut.
- **Detect boundaries and read the transition length from the score curve.** A hard cut is a single-frame spike; a dissolve is a plateau of elevated difference lasting the transition's length:
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=8,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ffmpeg -i ref.mp4 -vf "tblend=all_mode=difference,signalstats,\
  metadata=print:key=lavfi.signalstats.YAVG:file=diff.txt" -f null -
  ```
  In the per-frame trace: **1–2 elevated frames = hard cut**; **12–30 consecutively elevated frames = dissolve (0.4–1.0 s)**; **30–60 = fade**.
- **Audio switches on the same frame.** The defining feature is "including audio". Take a per-frame RMS trace and check the audio step is within **±1 frame** of the picture step:
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  (`n=1600` at 48 kHz is exactly one frame at 30 fps.) A step of ≥6 dB offset from the picture cut means it is a split edit, not a straight cut.
- **Information-load corroboration from the transcript.** At each hard cut, check whether the next sentence introduces a new referent, a new location noun, a new list ordinal, or a new claim. A reference that consistently puts hard cuts at these points and softer transitions elsewhere is applying this rule — log the mapping, it is the design document's transition table.
- **New-shot readability.** If the incoming shot carries text or a graphic, measure how many frames pass before it is fully opaque and static. In a correctly cut reference that is **0**.
- **Ratio to log.** `hard_cuts ÷ total transitions`. Creator explainer content typically runs **0.85–0.97** hard cuts; narrative work runs lower. A reference below ~0.7 is using transitions as a style, and that is a separate signature worth recording.
- **What the *absence* of a reset looks like.** A dissolve at a topic change reads as sleepy; a hard cut in the middle of continuous action reads as a mistake. When auditing, list boundaries where the transition type and the content type disagree — those are the findings.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `overlap_frames` | 0 | 0 | Definitional. Any blended frame makes it a dissolve. |
| `av_sync_at_cut` | 0 f | ±1 f | Picture and audio switch on the same frame; that is what "including audio" means. |
| `hard_cut_ratio` | 0.92 | 0.85–0.97 (explainer) · 0.60–0.85 (narrative) | Hard cuts ÷ all transitions. |
| `pre_cut_hold` | 6 f (0.20 s) | 4–12 f | Frames of the outgoing shot after its last meaningful action, before the cut. Cutting too early clips the beat. |
| `post_cut_hold` | 9 f (0.30 s) | 6–18 f | Frames before new movement, text or narration begins in the incoming shot. Gives the eye one beat to reorient. |
| `text_ready_at` | cut frame | — | If the incoming shot carries text, it is fully opaque on the cut frame, never fading up. |
| `new_info_boundary_types` | location, topic, list item, mode | — | The trigger list. Anything on it takes a hard cut unless a listed exception applies. |
| `exception_transitions` | dissolve 0.5 s · fade 1.0 s | see notes | Dissolve for time passage within a scene; fade for act boundaries; match cut when a shared element carries across. |
| `ambience_switch` | hard | hard \| 1 f crossfade | Even a "hard" audio cut usually gets a 1-frame overlap to avoid a click — see [[sfx-ambience-bridge-across-cut]]. |

## Reproduction prompt

```
Decide and build the transition at every scene boundary in this edit.

1. LIST THE BOUNDARIES. From the design document, list every boundary
   between adjacent segments with: the outgoing segment's subject, the
   incoming segment's subject, and whether the incoming segment introduces
   NEW information (new location, new topic, new list item, new mode such as
   entering or leaving a demo or a CTA).
2. CLASSIFY each boundary into exactly one:
   RESET     -> incoming material is new. USE A STRAIGHT CUT.
   CONTINUES -> same scene, time has passed. Use a dissolve, 12-24f
                (0.40-0.80s).
   STRUCTURE -> act boundary, top or tail of the video. Use a fade,
                30-60f (1.0-2.0s).
   CARRIED   -> a shape, movement or sound is shared across the boundary.
                Use the matching match-cut note, not this one.
   When in doubt, classify as RESET. The straight cut is the only
   transition that makes no claim about the relationship between shots.
3. BUILD EVERY RESET BOUNDARY AS: outgoing clip ends at {{CUT}}, incoming
   clip starts at {{CUT}}, zero overlapping frames, and the audio switches
   on the same frame {{CUT}} - within 1 frame, not "about there".
4. SET THE HANDLES. Leave 6 frames (0.20s) of the outgoing shot after its
   last meaningful action, and 9 frames (0.30s) in the incoming shot before
   new movement, text or the next word of narration. If the incoming shot
   carries text or a graphic, it must be FULLY OPAQUE on frame {{CUT}} -
   never fading up, never scaling in from zero.
5. TREAT THE AUDIO SEAM. If both sides have ambience or room tone, give the
   audio a 1-frame overlapping crossfade to kill the click, and nothing
   more. If the two ambiences are very different, this boundary needs an
   ambience plan, not a longer fade.
6. AUDIT. Count hard cuts as a fraction of all transitions. For an
   explainer, expect 0.85-0.97. If you are below 0.7, you have been using
   transitions as decoration: reclassify every non-RESET boundary and
   justify each one in a single sentence naming what relationship the soft
   transition asserts.
7. ACCEPTANCE TEST: (a) step frames at every RESET boundary - no frame
   contains both images; (b) the audio step is within 1 frame of the
   picture step; (c) any text in an incoming shot is readable on the cut
   frame; (d) read the boundary list aloud as "this continues / this is
   new" - every soft transition must fall on a "this continues".
```

## Execution spec

**HyperFrames (primary).** A straight cut is the cheapest thing in the engine, because the clip visibility window is half-open — `[start, start + duration)` — so `b.start === a.start + a.duration` produces **no overlapping frame at all**. Author seconds; frames are a comment.

```html
<!-- straight cut at 12.40s. Bar scene out, office scene in, audio with it. -->
<video id="bar"    src="bar.mp4"    muted playsinline class="clip"
       data-start="6.00"  data-duration="6.40" data-media-start="14.00" data-track-index="0"></video>
<audio id="bar-a"  src="bar.mp4"
       data-start="6.00"  data-duration="6.40" data-media-start="14.00" data-track-index="10"></audio>

<video id="office" src="office.mp4" muted playsinline class="clip"
       data-start="12.40" data-duration="8.00" data-media-start="2.50" data-track-index="0"></video>
<audio id="office-a" src="office.mp4"
       data-start="12.40" data-duration="8.00" data-media-start="2.50" data-track-index="11"></audio>
```

Five contract facts that decide whether this actually renders as a cut:
- **Every `<audio>` needs an `id`.** An id-less audio element is never mixed → **silent render**, with no warning.
- Overlapping audio clips must not share a `data-track-index` (`duplicate_audio_track` warning) — hence 10 and 11 even though they only touch.
- Picture/sound alignment is **authored, not solved**: there is no automatic waveform sync, so the same `data-start` / `data-duration` / `data-media-start` numbers are written on both elements. That identity *is* "including audio".
- **Land any animation slightly before `data-duration`**, not on it: the clip is hidden at exactly `start + duration`, so an entrance that resolves on the last frame never renders.
- `data-track-index` is display-only. If two clips must overlay, order them with CSS `z-index`.

**The one real conflict with the transition rules.** The animation contract states *"Every composition uses transitions. No exceptions."* That rule governs **motion-graphics scene changes** (`#el-<sid>` wrappers), not footage-to-footage boundaries — and a hard cut between two `<video>` clips is authored purely by adjacency, with no transition template stamped. When the boundary is between two **sub-composition scenes** and you want a reset rather than a blend, satisfy both by using the registry's `instant` preset (**0.15 s**, `expo.inOut`) or `zoom-through` at 0.15–0.20 s: short enough to read as a cut, present enough to satisfy the rule. Do not use `crossfade` here — 0.5 s of blend at an information boundary is the exact error this note exists to prevent.

**ffmpeg.** Only when assembling outside the composition. A straight cut is concat of two trimmed segments — note that stream-copy snaps to keyframes and can move your cut by up to a GOP:
```bash
ffmpeg -i bar.mp4    -ss 14.0 -to 20.4 -c copy seg1.mp4
ffmpeg -i office.mp4 -ss 2.5  -to 10.5 -c copy seg2.mp4
printf "file '%s'\n" seg1.mp4 seg2.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy out.mp4     # drop -c copy for frame accuracy
```
`transcript-cut.mjs` measures exactly this hazard and reports `copy_drift` when the produced duration deviates by more than 1 s.

**Epidemic Sound.** Nothing is required at a straight cut — that is part of the point. If the boundary needs marking, it is a *design* choice and belongs to [[sfx-whoosh-transition-movement-reveal]] or a single hit; a whoosh on every hard cut is the overload failure. Where both sides carry location sound, the seam is an ambience problem, not a transition problem: [[sfx-ambience-bridge-across-cut]].

**Remotion:** two adjacent `<Sequence>`s with no overlap; no Remotion runtime in this project.

## Pairs with
[[cut-straight-hard-cut]] · [[cut-dissolve]] · [[cut-dissolve-time-passage]] · [[cut-fade-bookend]] · [[cut-outpoint-inpoint-alignment]] · [[cut-on-action]] · [[cut-j-audio-leads-picture]] · [[cut-invisible-storytelling-doctrine]] · [[sfx-ambience-bridge-across-cut]] · [[cut-b-roll-coverage-from-transcript]] · [[pace-deliberate-continuity-break]]

## Failure modes
- **Dissolving a topic change.** The transition asserts continuity while the content asserts novelty; the result reads as slow rather than smooth. Fix: hard cut, and spend the dissolve where time actually passes.
- **Fading up text on the incoming shot.** The first 12–24 frames of reading time are wasted at partial opacity. Fix: the graphic is fully opaque on the cut frame; animate *within* it afterwards if you must.
- **Audio not switching with the picture.** A hard picture cut over continuing audio is an L cut, and if it was not intended it reads as a sync error. Fix: same numbers on both elements, or commit to the split edit deliberately.
- **Cutting on the last frame of action.** No breath either side and the boundary feels clipped. Fix: 6 f outgoing handle, 9 f incoming handle.
- **A click at the audio seam.** Two hard-truncated ambiences meeting mid-waveform. Fix: a 1-frame overlapping crossfade — one frame, not fifteen.
- **Transition-pack disease.** Using a different wipe at every boundary. The transition budget is *"2-3 types for the whole video"*, and hard cuts are not one of the three. Fix: raise `hard_cut_ratio` and reserve the named transitions for the classified exceptions.
- **Hard-cutting inside continuous action.** The one place a straight cut is wrong: mid-gesture with no matching movement. Fix: cut on the action ([[cut-on-action]]) or align out-point to in-point ([[cut-outpoint-inpoint-alignment]]).
- **Overlap note:** if you want the frame-level mechanics of building the join — audio boundary alignment, the one-frame anti-click crossfade, the split-edit distinction — use [[cut-straight-hard-cut]]. This note is only the decision about *which* boundaries get one.
- **Known gap:** no study directly measures comprehension of cut versus dissolve at a scene boundary. The reasoning here rests on two solid findings — continuity edits raise fine but not coarse event segmentation while action discontinuity raises both, and fades/dissolves are documented as *conventions* for time passage rather than perceptual necessities — plus edit-blindness evidence that well-motivated cuts largely go unnoticed (about a third of match-action cuts are missed outright). Treat the specific frame handles as house calibration, not as measured optima.
