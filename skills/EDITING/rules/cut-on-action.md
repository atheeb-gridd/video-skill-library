---
id: cut-on-action
title: Cutting on action — put the cut inside the movement
skill: editing
type: cut
family: invisible-cut
tags: [skill/editing, type/cut, family/invisible-cut, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:01"
    quote: "Cutting on action means just that. You cut during the character or object's movement."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:08"
    quote: "The movement carries the viewer's eye across the cut, so they don't notice it."
research_refs:
  - https://bop.unibe.ch/JEMR/article/download/2264/3460
  - https://www.filmsupply.com/articles/cutting-on-action-editing/
  - https://movieschoolfree.com/video-editing-course/cutting-on-the-action/
  - https://link.springer.com/article/10.3758/s13414-018-1548-1
  - https://www.premiumbeat.com/blog/continuity-editing-in-film/
difficulty: medium
detectable_from: video
---

# Cutting on action — put the cut inside the movement

## What it is
The cut lands **during** a movement rather than before it starts or after it finishes: mid-gesture, mid-turn, mid-door-opening, mid-reach, mid-punch. The mechanism is the same one that makes cutting work at all — a moving target has already recruited the eye, so the eye is doing pursuit work and the frame change is absorbed into the motion it is already tracking. It is the single most effective invisibility device in the continuity toolkit, and it is the one with hard empirical backing: in eye-tracking work, cuts matching both scene and action went **undetected 32.4%** of the time, against 25.1% for scene continuity alone and 9.4% for a plain between-scene cut. When viewers did notice a match-action cut it took them longest to do so — **564 ms**, versus 507 ms for a between-scene cut. It also covers sins: a scale mismatch or a mild exposure step that would be obvious on a static cut is frequently invisible inside a movement.

## When to use it
Whenever two angles cover the same physical action and the join must not be noticed. In practice, for creator work: coverage of a hands-on demonstration (the reach, the click, the pour, the tool pickup); a subject standing, sitting, turning or walking through a door; a product being picked up, opened or set down; and — the highest-frequency creator use — cutting from a talking head to a B-roll insert **on the presenter's own gesture**, so the gesture's motion carries into the insert. Also use it as a repair: a boundary that reads rough because motion stalls at the join ([[cut-continuity-pass]], `mafd_ratio_max`) is usually fixed by sliding the cut 6–15 frames into the movement rather than by changing shots. Do **not** use it where the abruptness is the content — a smash cut, a comedic beat landing on a freeze, or a deliberate pattern interrupt — and do not use it on a boundary that is supposed to read as a section break.

## How to recognise it in a reference video
- **Boundary list first, then motion energy.** `scdet` gives both in one pass: `lavfi.scd.score` marks the cut, `lavfi.scd.mafd` is a per-frame mean-absolute-frame-difference value — a usable continuous motion-energy signal.
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=10,metadata=print:file=-" -f null - 2>/dev/null \
    | grep -E "pts_time|lavfi.scd"
  ```
- **The diagnostic shape.** At a cut on action, `mafd` is **elevated on both sides** of the boundary and does not collapse. Concretely: take the mean `mafd` over the 10 frames before the cut and the 10 frames after (excluding the cut frame itself, whose `mafd` is dominated by the cut). Both should be **≥ 2× the clip's own median `mafd`**, and their ratio to each other should be **within 2×**. A static-to-static cut has both sides near the median; a motion-to-static cut has a ratio far above 2×.
- **Confirm by eye on the frame pair.** Extract the last pre-cut frame and the first post-cut frame. A cut on action shows the *same* action, further along, from a new angle — the hand is further into the reach, the head further into the turn. If the action restarts, it is a botched match; if it has finished, the cut is late.
- **Where in the movement.** Log the cut's position as a fraction of the movement's duration. Craft guidance and the reference corpus agree on **0.3–0.6** (early-to-middle), with "slightly before the action completes" as the strongest single position. Cuts after **0.75** read as slow and obvious.
- **Overlap or skip.** Compare the action's progress across the boundary. Professional practice is a small **skip**, not an overlap: the incoming angle picks the action up 2–6 frames *further along* than the outgoing angle left it, because a repeated frame of action reads as a stutter and a small elision reads as nothing. An overlap of more than ~2 frames of the same action is visible.
- **Angle change is a prerequisite.** Cut on action with **less than 30°** of camera-position change is a jump cut wearing a disguise. Check the two frames for a genuine perspective change, not just a size change.
- **Motion direction carries.** The subject's movement vector should point the same way on both sides. A left-to-right reach cut to a right-to-left reach is a direction break no amount of motion energy rescues.
- **Sound.** Almost always there is a diegetic sound of the action itself continuing across the boundary (footstep, latch, impact), and often a J-cut lead. A cut on action with a silent join is doing half the work.
- **Density.** Count cuts-on-action as a fraction of within-scene cuts. Demonstration-heavy creator content runs **0.3–0.6**; talking-head-with-inserts runs **0.1–0.25**; a reference at 0 is deliberately jump-cut styled.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `cut_position` | 0.45 of the movement | 0.30–0.60 | Fraction of the action's duration at which the cut lands. Strongest single value is just before completion, ~0.6. |
| `late_cut_limit` | 0.75 | — | Past this the cut reads as slow and obvious. |
| `action_skip` | 3 f (100 ms) | 2–6 f | Frames of action **elided** across the boundary. Positive = incoming angle is further along. |
| `action_overlap_max` | 2 f | 0–2 f | Repeated frames of the same action. Over 2 f reads as a stutter. |
| `min_angle_change` | 30° | 30–60° | Below this the cut is a jump cut. A ≥20% shot-size change is a partial substitute, not a full one. |
| `mafd_floor` | 2× clip median | 1.5–4× | Both sides of the boundary must clear this. |
| `mafd_ratio_max` | 2× | 1.5–4× | Ratio of mean `mafd` after vs before. |
| `motion_window` | 10 f each side | 6–15 f | Window over which `mafd` is averaged for the test. |
| `direction_match` | required | — | Movement vector points the same way on both sides. |
| `diegetic_sound` | required | — | The action's own sound continues across the boundary. |
| `audio_lead` | 0 f | 0–8 f | Optional J-cut lead on the incoming angle's sound. Keep short here; the motion is already doing the work. |
| `on_action_share` | 0.25 | demo 0.30–0.60 · talking-head 0.10–0.25 | Cuts-on-action ÷ within-scene cuts. |

## Reproduction prompt

```
Build a cut on action between angle A and angle B, both covering the same movement, at 30fps.

1. FIND THE MOVEMENT WINDOW in each angle separately:
     ffmpeg -i A.mp4 -vf "scdet=t=100,metadata=print:file=-" -f null -
   Threshold 100 flags nothing as a cut, giving a clean per-frame lavfi.scd.mafd trace. Record the
   movement's onset (first frame above 2x the clip median) and its peak (local maximum).

2. PICK THE CUT FRAME in A at 0.45 of the way from onset to the movement's end - i.e. early-to-
   middle, on the rising side of the mafd curve, NOT at the peak and NOT after it. Call it
   {{CUT_A}} (a frame index in A's source).

3. PICK THE MATCHING FRAME IN B. Identify the same instant of the action in B by eye on extracted
   stills, then move 3 frames LATER: {{CUT_B}} = that frame + 3. This 3-frame elision is
   deliberate - repeating action reads as a stutter, eliding a little reads as nothing. Never
   overlap more than 2 frames.

4. VERIFY THE PREREQUISITES before building. All four must hold:
   - camera position differs by >= 30 degrees between A and B (perspective change, not just a
     size change);
   - the movement's direction vector points the same way in both;
   - mean mafd over the 10 frames before {{CUT_A}} and the 10 frames after {{CUT_B}} are each
     >= 2x that clip's median mafd, and within 2x of each other;
   - the subject occupies a different shot size (>=20% height change) OR a clearly different
     angle.
   If any fails, this is not a cut on action. Fix the footage choice, do not build it anyway.

5. AUTHOR IT. A ends at composition time {{CUT}}; B starts at {{CUT}}. Convert frames to seconds
   as frames/30 and write the seconds. B's data-media-start = {{CUT_B}}/30.

6. SOUND. The action's own diegetic sound MUST continue across the boundary: either keep one
   continuous audio clip from whichever angle recorded it best spanning both picture clips, or
   lay a foley hit for the action at the moment it completes. Optionally lead B's sound by up to
   8 frames. Do NOT put a whoosh on this cut - a whoosh announces a transition, and this cut's
   whole purpose is to not be announced.

7. ACCEPTANCE TEST: (a) frame-step the boundary - the action is further along on the incoming
   frame, never restarted and never finished; (b) play at speed five times and try to name the cut
   frame; if you can, move the cut 6 f earlier; (c) re-run the mafd test on the assembled cut and
   confirm both sides clear 2x median.
```

## Execution spec

**HyperFrames (primary).** A cut on action is just two clips authored back to back with a carefully chosen `data-media-start` on the incoming one. Nothing exotic — the whole craft is in the two numbers.

```html
<!-- A runs to 12.00s. Cut on action. 3-frame elision = 0.10s already folded into B's media-start. -->
<video id="ang-a" src="assets/angle-a.mp4" class="clip" muted playsinline
       data-start="8.00" data-duration="4.00" data-media-start="31.40" data-track-index="0"></video>
<video id="ang-b" src="assets/angle-b.mp4" class="clip" muted playsinline
       data-start="12.00" data-duration="5.00" data-media-start="47.60" data-track-index="1"></video>

<!-- one continuous sound for the action, from whichever angle recorded it best -->
<audio id="act-sound" src="assets/angle-a.wav" data-audio-group="ambience"
       data-start="8.00" data-duration="9.00" data-media-start="31.40"
       data-track-index="13" data-volume="0.8"></audio>
```

Contract details that decide whether this works:
- The visibility window is **half-open**, `[start, start + duration)`, so `b.start === a.start + a.duration` gives exactly one frame of B where A ended — no overlap, no gap, no doubled frame. That is precisely what a cut on action needs; do not add a 1-frame overlap "for safety".
- **All authored time is seconds.** Convert frames at the render fps (default **30**) and keep the frame count in a comment. Do the conversion at authoring time; there is no frame attribute.
- **Track indices are display-only** and constrain nothing, but keep A and B on different indices while you are experimenting with overlap so the Studio timeline stays readable. Layering is CSS `z-index`, never track index.
- `video_nested_in_timed_element` is an **error**: time the wrapper or the video, never both.
- **Relative timing** expresses the boundary directly — `data-start="ang-a"` means "start when A ends" — but spaces around any offset operator are mandatory (`ang-a-0.1` parses as an id named `ang-a-0.1` and silently resolves to 0), an unresolved id resolves to 0 without erroring, and a target with no resolvable duration lands on its *start*. For a cut this precise, author the literal seconds.
- **No transition here.** The four-non-negotiables rule says every composition uses transitions — that governs scene-to-scene boundaries. A within-scene cut on action is a hard cut by definition; putting a crossfade on it destroys the device. Log it as a hard cut in the storyboard so the transition injector does not claim the boundary.
- **Do not use `data-playback-rate` to make the motion match.** It is a constant in `0.1..5` with no envelope, so retiming one angle to match another's speed changes the whole clip and desyncs its own audio unless you write the same rate on the audio element. If the two angles genuinely move at different speeds, that is a footage problem, not an edit problem.

**ffmpeg — finding the peak.** The verified command shape for a per-frame motion trace is `scdet` with the threshold set high enough that nothing is flagged, so you get `mafd` for every frame:
```bash
ffmpeg -i angle-a.mp4 -vf "scdet=t=100,metadata=print:file=-" -f null - 2>/dev/null \
  | awk '/pts_time/{t=$3} /scd.mafd/{split($0,a,"="); print t, a[2]}' > a.mafd.txt
```
Then take the median, find the first frame above 2× median (onset), the local maximum (peak), and pick 0.45 between onset and end. For a physical trim outside the composition, `ffmpeg -i in.mp4 -ss <t> -to <t2> out.mp4` — and **drop `-c copy`**, because stream copy snaps to keyframes and on sparse-keyframe footage *"can silently swallow the whole cut"*; `transcript-cut.mjs` measures this drift and reports `copy_drift` for exactly this reason.

**Epidemic Sound.** Only for the foley when the action's own sound was not usable: `SearchSoundEffects({ query: { term: "<action> foley <material>" }, filter: { duration: { max: 1500 } }, first: 10 })` — e.g. "door latch close wood", "cloth movement arm", "cup set down table". Place it at the frame the action *completes*, not at the cut. Put it in an `sfx` or `ambience` group, never `voiceover`.

**Remotion:** two adjacent `<Sequence>`s with the incoming one's media offset advanced by the elision; concept only.

## Pairs with
[[cut-movement-match]] · [[cut-continuity-pass]] · [[cut-j-audio-leads-picture]] · [[pace-visual-change-clock]] · [[cut-graphic-match]] · [[pace-cut-on-the-beat]] · [[sfx-unsounded-motion-audit]] · [[pace-silent-demonstration-window]]

## Failure modes
- **Cutting at the peak or after it.** The eye has already resolved the movement and the cut lands in the still aftermath, which is the most visible place to put it. Correction: cut on the *rising* side, 0.30–0.60 of the way through.
- **Overlapping the action.** A repeated 4 frames of the same reach reads as a hiccup. Correction: elide 2–6 frames instead; a small skip is invisible, a small repeat is not.
- **No real angle change.** Same camera, tighter lens, cut mid-gesture — that is a jump cut with motion on it, and viewers read it as a mistake. Correction: 30° minimum, or accept it as a jump cut and style it as one.
- **Direction flip.** The reach goes right in A and left in B. Motion energy is high on both sides, the `mafd` test passes, and the cut still reads as broken. Correction: the direction check is a prerequisite, not a nicety.
- **Silent join.** The action's sound stops at the cut and restarts. The picture is invisible and the audio announces the edit. Correction: one continuous audio clip across the boundary, or a foley hit at the action's completion.
- **A whoosh on it.** Transition SFX are the opposite of this technique's intent. Correction: nothing on the cut; the diegetic sound only ([[sfx-placement-discipline]]).
- **Using it to hide bad coverage everywhere.** Motion covers a multitude of mismatches, which tempts an editor to cut on action at every boundary; the result is a video with no clean, deliberate cuts left for emphasis. Correction: hold `on_action_share` at the profile target.
- **Known gap:** `mafd` is a whole-frame change measure, so a camera pan raises it as much as a subject's gesture does. It cannot tell you *what* moved or in which direction, and this stack has no optical-flow or object-tracking tool. Movement direction and the identification of the same instant in the second angle are hand-verified from extracted stills; mark them as such in the design document.
