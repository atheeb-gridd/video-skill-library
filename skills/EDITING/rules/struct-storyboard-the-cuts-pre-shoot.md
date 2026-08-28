---
id: struct-storyboard-the-cuts-pre-shoot
title: Storyboard the cuts before you shoot — the edit's ceiling is set on shoot day
skill: editing
type: structure
family: pre-production
tags: [skill/editing, type/structure, family/pre-production, layer/dialogue, layer/ambience, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:05:30"
    quote: "To really maximize the impact of your edits and cuts, take the time to plan and storyboard them before you go out shooting."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:06"
    quote: "Basically, when the out point of shot A matches the in point of shot B, it creates a seamless transition."
research_refs:
  - https://story2board.com/blog/editing-techniques-storyboard-guide
  - https://www.videomaker.com/article/c18/14584-the-perfect-plan-storyboard-and-shot-list-creation/
  - https://www.studiobinder.com/blog/match-cuts-creative-transitions-examples/
  - https://www.studiobinder.com/blog/what-is-room-tone/
  - https://en.wikipedia.org/wiki/Cutting_on_action
  - https://en.wikipedia.org/wiki/30-degree_rule
  - https://en.wikipedia.org/wiki/Split_edit
difficulty: medium
detectable_from: transcript
---

# Storyboard the cuts before you shoot — the edit's ceiling is set on shoot day

## What it is
Almost every cut worth naming needs **coverage that only exists if someone shot it on purpose**. A cut on action needs the same action performed and recorded from two angles more than 30° apart, with overlap at both ends. A graphic match needs two framings deliberately composed to rhyme. A movement match needs two shots whose dominant motion vectors point the same way. A J cut needs the incoming scene's sound recorded as **wild sound**, separately from its picture. An L cut needs room tone so the trail is not sitting over a hole. A whip-pan transition needs the pan actually performed, in the direction the next shot moves. None of these can be added in the edit. So the storyboard's job is not to draw pretty frames: it is to make the intended **cut** an explicit, checkable requirement of the shoot, and to convert each intended cut into the shots and the sound that make it possible. This is the principle that sits behind every other note in this library — you can only reproduce a reference's cut if you have the reference's coverage.

## When to use it
Always, before any shoot you control — but the *depth* scales. Do the full pass when the piece contains any planned transition beyond a straight cut, when there is a demonstration or process to cover, when two locations must be intercut ([[struct-cross-cutting-parallel-action]]), when the edit is meant to look "invisible" ([[cut-invisible-storytelling-doctrine]]), or when a second shoot day is impossible. Do the light version — a shot list with cut intentions in the notes column, no drawings — for a single-location talking head with B-roll, which is most creator work. Skip it only for genuinely unrepeatable footage, and in that case invert the process: *analyse* what coverage you happen to have and choose cuts the footage can support, rather than planning cuts it cannot. If you are working from a reference video, this note is where a reference analysis becomes a **shoot brief**: every cut logged in the design document turns into one or more coverage requirements here.

## How to recognise it in a reference video
You are not detecting a visual device — you are detecting whether the reference was *planned*, which is legible in the coverage.

- **Handles.** Where the same take appears more than once (a repeated demonstration, a callback), check whether the usages overlap or abut. **Overlapping usage** proves the editor had extra frames either side and chose; abutting usage suggests pre-trimmed or improvised coverage.
- **Coverage inventory per beat.** For each demonstration or action beat, count distinct camera positions. Planned coverage runs **2–4 angles** per action beat; unplanned runs 1. A single-angle action beat cannot contain a cut on action, and a reference full of single-angle beats was not storyboarded for cuts.
- **The 30° / shot-size test at every action match.** Planned coverage satisfies it consistently. A reference where matched cuts sometimes violate it was cut from whatever existed.
- **Motion-direction consistency across transitions.** Planned whip pans and pushes have the outgoing motion, the transition and the incoming motion all agreeing. Measure the dominant vector either side of each transition:
  ```bash
  ffmpeg -i ref.mp4 -vf "mestimate=method=epzs,metadata=print" -f null - 2>&1 | head -60
  ```
  Consistent agreement across several transitions is near-proof of planning; a random mix is a post-hoc pack.
- **Graphic-match precision.** In a planned graphic match the matched element's **centroid moves less than ~4% of frame width** and its **scale changes less than ~10%** across the cut. Loose matches (10%+ drift) were found in the edit, not composed on the shoot.
- **Wild sound and room tone evidence.** J cuts whose incoming sound arrives **clean and full** before its picture indicate wild sound was recorded; a J cut whose lead-in is obviously the picture's own audio pulled forward will carry that shot's specific noises early and often sounds slightly wrong. Room tone is detectable as a **continuous, unbroken floor** under a stretch of cuts: measure the RMS of speech-free windows across several boundaries; steps under 2 dB across a whole scene mean a tone bed exists.
- **Repeated framings across locations.** The same shot size and eyeline reused across different scenes is a storyboard signature; ad-hoc shooting produces framings that drift.
- **Transcript signal.** In creator content the presenter often says the plan out loud — "I shot this three times so I could…", "watch this next bit, I set that up". Log it as direct evidence.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `angles_per_action_beat` | 2 | 2–4 | Minimum to allow a cut on action. |
| `handle_len` | 60 f (2.0 s) | 30–120 f | Extra frames recorded either side of every intended cut point. |
| `action_overlap` | 45 f (1.5 s) | 30–90 f | The same action re-performed and overlapping between angles, so the match point exists in both. |
| `camera_angle_delta` | 40° | > 30° | The 30° rule with margin, or a full step in shot size. |
| `screen_direction` | preserved | — | Recorded per shot in the shot list; violated only deliberately, and noted. |
| `motion_vector_note` | required | — | For every intended movement match or whip transition: direction and approximate speed, per shot. |
| `graphic_match_tolerance` | 4% of frame width | 2–8% | Allowed centroid drift for a planned graphic match; scale within 10%. |
| `wild_sound_len` | 30 s | 20–60 s | Per sound source that will lead a J cut. |
| `room_tone_len` | 45 s | 30–60 s | Per location, recorded immediately after the takes with everything still in place. |
| `takes_per_line` | 3 | 2–5 | So the delivery gate in [[pace-a-roll-burst-rationing]] has something to choose from. |
| `broll_overshoot` | 5× | 4–6× | Published guidance: shoot 4–6× the B-roll you expect to use; roughly 20% gets used. |
| `storyboard_depth` | shot list + notes | drawings for transitions only | Full frames only where a match or transition must be composed. |

## Reproduction prompt

```
Turn an edit plan into a shoot brief. Input: the design document's cut list
(one row per intended cut, with its type) plus the script or outline. Output:
STORYBOARD.md plus a shot list where every intended cut has the coverage that
makes it possible.

For EACH intended cut, emit its coverage requirement:

- STRAIGHT CUT: nothing special. Note the line boundary it lands on.
- CUT ON ACTION: name the action in one clause ("hand leaves the handle").
  Require 2+ angles, >30 degrees apart or a full shot-size step, each
  performing the WHOLE action, with 45 frames (1.5s) of overlap either side
  of the intended match point plus 60-frame handles. Record screen direction
  for both.
- GRAPHIC MATCH: specify the shared shape, its position in frame as a
  fraction of width/height, and its approximate size. Both shots must be
  composed to put it in the same place - centroid within 4% of frame width,
  scale within 10%. This is a framing instruction, not an edit instruction.
- MOVEMENT MATCH / WHIP PAN: record the direction (LEFT/RIGHT/UP/DOWN) and
  rough speed of the dominant motion in BOTH shots. They must agree. For a
  practical whip, require 24 frames of fast pan at the tail of the outgoing
  shot and at the head of the incoming shot, same direction.
- J CUT: require WILD SOUND of the incoming scene's key sound, 30 seconds,
  recorded separately from picture.
- L CUT / CUTAWAY: require ROOM TONE, 45 seconds per location, recorded
  immediately after the takes with everyone and everything still in place.
- CROSS CUT: require both strands established in a wide shot, and a
  deliberate visual separator between them (shot size, grade, or location).
- DISSOLVE / FADE: require a held frame at both ends - 60 extra frames of
  the outgoing shot's settled state and the incoming shot's settled state.

Then: 3 takes of every scripted line; 5x the B-roll you expect to use; 60
frames of handles on everything.

Write it as STORYBOARD.md - frontmatter (format, duration, message, arc,
audience, mode), then one "## Frame N - Title" per beat with `- key: value`
bullets for status, src, duration, transition_in, scene, voiceover, and the
coverage requirement in the narrative text below the bullets.

ACCEPTANCE TEST: every cut in the cut list maps to at least one line in the
shot list; no intended cut depends on coverage nobody was asked to shoot;
every location has a room-tone line; every J cut has a wild-sound line; every
match cut has a framing instruction, not just a description.
```

## Execution spec

**HyperFrames — the plan layer is real and parsed.** `STORYBOARD.md` is not a convention, it is read by `@hyperframes/core/storyboard` into a `StoryboardManifest`, exposed at `GET /api/projects/<id>/storyboard`, and rendered by Studio as a contact sheet (`?view=storyboard` **ahead of the hash**):
```
http://localhost:3002/?view=storyboard#project/<project-name>
```

```markdown
---
format: 16:9
duration: 480
message: You can plan the cut before you own the footage
arc: promise -> demonstration -> payoff
audience: creators shooting solo
mode: explainer
---

## Frame 7 — The tool lands on the bench
- status: outline
- duration: 3.2
- transition_in: blur-crossfade
- scene: hand lowers the tool; it touches down centre-frame
- voiceover: "and this is where it actually clicks into place"

COVERAGE REQUIRED — cut on action at the touchdown.
Angle 1: medium, camera left, 45° off axis. Angle 2: macro on the bench.
Both perform the full lower-and-place. 45 f overlap either side of touchdown,
60 f handles. Screen direction: tool moves frame-right to frame-left in both.
Room tone: 45 s, workshop, after the last take.
```
Frame keys, verbatim from the parser: `status` (`outline` → `built` → `animated`), `src`, `duration`, `transition_in` (alias `transition`), `scene` (aliases `description`/`summary`/`caption`), `voiceover` (aliases `vo`/`voice_over`/`narration`), `poster`. Headings may be `Frame` / `Beat` / `Scene` at H2 or H3. **Unknown keys are preserved under `extra`**, which is where a `coverage:` key can live safely. The parser *"never throws"* and records surprises as `warnings` — so a malformed frame is silent, and the storyboard must be read back through Studio or the API rather than assumed.

Transition planning syntax the planner understands, and it belongs in the storyboard rather than in the edit:
```
**Transition:** blur-crossfade
**Transition:** push-slide LEFT
**Transition:** zoom-through 0.3s
```
Budget: *"Pick 2-3 types for the whole video and repeat them."* Decide that here, once, not per boundary.

**The review loop, and a hard local constraint.** Structured feedback arrives as `.hyperframes/frame-comments.json` (`version`, `pass` = `storyboard`/`sketch`/`final`, `submitted_at`, `comments[].{frame,src,title,text}`) and the documented contract is *"revise exactly the frames named, **delete the file**, re-present."* **In this project the mounted vault folder cannot delete files.** So the delete step is not performable: instead advance each named frame's `status`, write a superseding `frame-comments.<pass>.done.json` marker (or bump `pass`), and record in the storyboard which comment file has been consumed. Any workflow whose correctness depends on removing that file will silently loop.

Because the storyboard is where scene structure is decided, it is also where the **modular vs monolithic** call is made: modularise when there are clear scene cuts, scenes over ~100 lines, reusable scenes, or continuous audio over several visual segments — *"If a monolithic project is approaching three or more scene cuts, prefer modularizing before adding the next scene."* And plan the audio home now: **audio lives at the host root** so playback survives scene cuts.

**ffmpeg — the coverage audit, run on rushes before the shoot wraps.** This is the highest-value use of ffmpeg in this note: verify on the day that the intended cuts are possible.
```bash
# 1. Are the handles actually there? Compare take duration against the scripted action window.
ffprobe -v error -show_entries format=duration -of csv=p=0 take_a1.mp4

# 2. Do the two angles both contain the action? Motion trace per take; the action shows as a run above baseline.
ffmpeg -i take_a1.mp4 -vf "tblend=all_mode=difference,signalstats,\
 metadata=print:key=lavfi.signalstats.YAVG:file=m_a1.txt" -f null -

# 3. Is there room tone, and is it clean? RMS of the tone recording.
ffmpeg -i roomtone.wav -af "astats=metadata=1:reset=0" -f null - 2>&1 | grep RMS_level

# 4. Frame-rate parity across cameras, before anything is intercut.
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of csv=p=0 take_b1.mp4
```
Transcribe the takes the same day so the delivery gate and the cut points can be chosen from language rather than by scrubbing:
```bash
npx hyperframes transcribe take_a1.mp4 --engine auto
```
Note the transcription default (Parakeet via `parakeet-mlx`) is an **Apple-silicon MLX path** and is unavailable on this linux ARM64 VM; the whisper.cpp fallback is what remains.

**Epidemic Sound.** Planning also decides what will be *sourced* rather than shot. Anything on that list becomes an asset requirement instead of a coverage requirement: transition whooshes (`SearchSoundEffects { query.term: "fast whoosh transition swoosh short" }`), location ambiences to stand in for un-recorded room tone (`{ query.term: "<location> ambience loop", filter.duration { min: 20000 } }`), and the section beds, searched by **BPM / instrument / vibe** with BPM matched to the intended delivery speed. Deciding this at storyboard time is what prevents a shoot that forgot to record tone from becoming an unfixable edit.

**Remotion:** the equivalent plan layer is a plain scene manifest consumed by the composition; no Remotion runtime exists in this project.

## Pairs with
[[cut-on-action]] · [[cut-outpoint-inpoint-alignment]] · [[cut-graphic-match]] · [[cut-movement-match]] · [[cut-audio-match]] · [[cut-j-audio-leads-picture]] · [[cut-l-audio-trails-picture]] · [[cut-full-screen-transition]] · [[struct-cross-cutting-parallel-action]] · [[cut-invisible-storytelling-doctrine]] · [[cut-continuity-pass]] · [[pace-a-roll-burst-rationing]]

## Failure modes
- **Storyboarding pictures instead of cuts.** Beautiful frames, no boundary information, and the edit is back to whatever the footage allows. Fix: every frame's notes name the cut *into* and *out of* it and what that cut requires.
- **One angle per action.** The single most common reason a planned cut on action cannot be built. Fix: two angles, >30° apart, each performing the whole action.
- **No overlap between angles.** Both angles exist but neither contains the match frame, so the cut can only elide or repeat. Fix: 45 f of overlapping action either side of the intended point.
- **No handles.** Frame-accurate work needs spare frames; without them a boundary that is 4 frames off cannot be fixed. Fix: 60 f handles as a shoot habit, not a decision.
- **Forgetting room tone.** The cheapest thing on the list and the one most often skipped; without it every L cut and every cutaway sits over a hole. Fix: 45 s per location, immediately after the takes, everything still in place.
- **Forgetting wild sound.** Every J cut then has to borrow the incoming picture's own audio early, which carries that shot's specific noises into the previous scene. Fix: 30 s of the key incoming sound, recorded separately.
- **Match cut described but not framed.** "Match the circle here" with no position or size, and the two shots do not rhyme. Fix: specify the element's position as a fraction of frame width/height and its size, for both shots.
- **Motion direction unrecorded.** Whip pans and movement matches then get assembled against the footage's actual motion. Fix: a direction column in the shot list, filled for every shot.
- **Planning transitions the stack cannot build.** The broad ≈40-name transition catalog is **not staged** and no CDN is reachable, so a storyboard promising "film burn" commits the edit to supplying its own plate. Fix: plan from the 5 registry transitions plus any overlay plates you will actually own.
- **Relying on the documented review-loop delete.** The vault cannot delete files, so the `frame-comments.json` lifecycle cannot complete as written. Fix: status advance plus a superseding marker file, recorded in the storyboard.
- **Known gap:** nothing in this stack validates a storyboard against a shot list, and the storyboard parser *"never throws"* — a mis-keyed frame is silent. Read the manifest back through Studio or the API before treating the plan as agreed.
