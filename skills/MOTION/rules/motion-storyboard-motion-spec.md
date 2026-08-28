---
id: motion-storyboard-motion-spec
title: Spec the motion before you animate — STORYBOARD.md as the motion plan layer
skill: motion
type: motion
family: pre-production
tags: [skill/motion, type/motion, family/pre-production, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:05:30"
    quote: "To really maximize the impact of your edits and cuts, take the time to plan and storyboard them before you go out shooting."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://tech.ebu.ch/docs/r/r095.pdf
  - https://www.adobe.com/creativecloud/video/discover/whip-pan.html
  - https://gsap.com/docs/v3/Eases
difficulty: medium
detectable_from: transcript
---

# Spec the motion before you animate — STORYBOARD.md as the motion plan layer

## What it is
The shoot-side version of this principle is [[struct-storyboard-the-cuts-pre-shoot]]: the edit's ceiling is set on shoot day, so transitions have to be planned before coverage exists. The motion-side version is the same argument one stage later: **the animation's ceiling is set before the first tween is written**. In this stack the plan layer is a real, parsed artefact — `STORYBOARD.md`, read by `@hyperframes/core/storyboard` into a `StoryboardManifest`, exposed at `GET /api/projects/<id>/storyboard`, and rendered by Studio as a contact sheet. A motion spec written there survives review, drives the build, and gets marked off frame by frame (`status: outline → built → animated`).

Concretely: before building, every frame gets a named motion event, a transition in, a duration, and a place in a **transition budget** of 2–3 types for the whole video. Choosing transitions after the scenes exist is what produces a composition with six different transition types and no house style.

## When to use it
- **Any composition with three or more scene cuts.** The contract's own threshold for modularising is *"approaching three or more scene cuts"* — the same threshold applies to needing a written plan.
- **Before requesting or shooting coverage**, so that a planned motion (a match cut, a whip pan matched to camera motion, a graphic that continues a subject's movement) has footage that can carry it.
- **When a video is one of a series** and must reuse the same motion vocabulary.
- **When someone else (or another agent) will build the scenes** — the storyboard is the interface, and `.hyperframes/frame-comments.json` is the review channel back.
- **Not** for a single-scene composition of under ~100 lines, where the plan is the file.

## How to recognise it in a reference video
This is a process technique, so recognition is inferential — but the fingerprints are strong and worth logging into a design document:
- **Transition vocabulary is small and repeated.** Count distinct transition types across the whole video. **2–3 types** with one dominant (used for 60%+ of boundaries) is the signature of a planned edit; 5+ types is unplanned.
- **Duration bands cluster.** Measure every transition: planned work clusters into two or three values (e.g. 0.25 s for topic beats, 0.6 s for section breaks). Unplanned work scatters.
- **Motion register is consistent.** Entrance direction, ease character and offset magnitude repeat across scenes. Roughly **3 easing characters** across a whole composition is the house target; one ease everywhere reads flat, a different ease per scene reads unplanned.
- **Every scene has an entrance.** Planned compositions animate content in on every scene; unplanned ones have scenes that simply appear.
- **No exit animations except the last scene.** A composition where outgoing content fades before every transition is a tell that transitions were bolted on afterwards.
- **Graphics land on spoken cues.** Check 6–10 graphic entrances against the transcript: planned work lands within ±0.2 s of its word; unplanned work drifts by 0.5 s+.
- **Coverage supports the motion.** A whip pan whose two shots share a motion direction, or a match cut with genuinely matched framing, can only exist if it was planned ([[cut-match-cut]], [[motion-whip-pan-transition]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `transition_types_per_video` | 3 | 2–3 | Planner budget, verbatim from the transition doctrine. Tier-A `shared-element` morph is exempt. |
| `primary_transition_share` | 60% | 50–80% | One type carries the video; the rest are accents. |
| `easing_characters` | 3 | 2–4 | Per composition. Vary by energy inside the smooth families. |
| `duration_bands` | 2 | 2–3 | E.g. beat 0.25 s, section 0.6 s. |
| `frame_status_gates` | outline → built → animated | — | Real parsed values; do not invent others. |
| `plan_before_build` | required ≥3 scenes | — | Matches the modularisation threshold. |
| `slowest_to_fastest` | 3× | 2–4× | *"The slowest scene should be 3× slower than the fastest."* |
| `first_animation_offset` | 0.2 s | 0.1–0.3 s | Never start motion at t=0. |
| `safe_inset_declared` | 5% | 3.5–5% | EBU R95; declare it in the frontmatter so every frame inherits it. |
| `review_cycle` | 1 pass per stage | — | `pass: storyboard | sketch | final` in `frame-comments.json`. |
| `animatic_fps` | 30 | 24–30 | For the timing animatic assembled from frame stills. |

## Reproduction prompt

```
Before building any scene, write STORYBOARD.md at the project root as the
motion plan, then build only what it names.

FRONTMATTER. Set format, duration, message, arc, audience, mode. Add the
project's motion budget as free-form notes under the frontmatter: the 2-3
transition types for the whole video (name the primary), the 2 duration bands,
the 3 easing characters, the safe inset (5%), and the frame size.

ONE H2 PER FRAME, in order: "## Frame N - Title". Under each, metadata as
"- key: value" bullets using only the keys the parser knows: status, src,
duration, transition_in (alias transition), scene, voiceover, poster. Unknown
keys are preserved under extra, so put motion detail there or in the narrative
body - and write it as a real spec: what moves, from what value to what value,
over how many seconds, on what ease, with what stagger, and what sound event
it is bound to.

TRANSITIONS. Use the planner syntax exactly: "**Transition:** blur-crossfade",
"**Transition:** push-slide LEFT", "**Transition:** zoom-through 0.3s". Only
use names from the registry (crossfade, blur-crossfade, push-slide,
zoom-through, squeeze) unless the note for a custom transition is cited.

STATUS DISCIPLINE. Every frame starts at status: outline. Move it to built
when its DOM exists, and to animated only when its tweens and its bound sound
event exist. Do not build frame N+1 while frame N is still outline.

REVIEW. If .hyperframes/frame-comments.json is present, revise exactly the
frames it names, delete the file, and re-present. Do not silently revise other
frames.

ACCEPTANCE TEST: the manifest parses with no warnings; every frame carries a
duration and a transition_in; the whole file uses at most 3 transition types
and at most 3 easing characters; the sum of frame durations matches the root
composition data-duration (which is read once at compile time and cannot be
changed later by a script or --variables).
```

## Execution spec

**HyperFrames.** The plan layer is a real file with a real parser.

```markdown
---
format: 1920x1080
duration: 48
message: Ten cuts, demonstrated not described
arc: promise -> enumeration -> payoff
audience: intermediate editors
mode: explainer
---
Motion budget: primary transition push-slide LEFT 0.5s (topic beats),
accent zoom-through 0.3s (climax only), calm blur-crossfade 0.6s (section
breaks). Easing characters: power3.out entrances, sine.inOut drifts,
expo.in transitions. Safe inset 5%. Stagger cap 0.36s.

## Frame 3 — The match cut, demonstrated
- status: outline
- src: compositions/frame-03.html
- duration: 5.2
- transition_in: push-slide LEFT
- scene: two shots sharing a circular shape, cut on the shape
- voiceover: "A match cut connects two scenes through a shared element."
- motion: label chip enters y 22->0 autoAlpha 0->1, 0.4s power3.out at +0.35s;
  annotation circle draws 0.40s power2.out at +1.20s; no exit (transition is the exit)
- sfx: one soft whoosh on the chip entrance, -14 dB, transient on its first frame

**Transition:** push-slide LEFT
```

Contract points that bind this:
- Frame headings are `Frame` / `Beat` / `Scene` at **H2 or H3**; metadata are `- key: value` bullets; known keys are `status`, `src`, `duration`, `transition_in` (alias `transition`), `scene` (aliases `description`/`summary`/`caption`), `voiceover` (aliases `vo`/`voice_over`/`narration`), `poster`. Unknown keys land under `extra`. The parser *"never throws"* and records surprises as `warnings` — so **read the warnings**, they are the only feedback.
- Studio renders the contact sheet at `?view=storyboard` **ahead of the hash**.
- `SCRIPT.md` exists for locked narration but is **not** parsed into the manifest — do not put motion spec there.
- Review contract, verbatim: *"revise exactly the frames named, delete the file, re-present."*
- Plan the **architecture** at the same time: modular (one `compositions/<scene>.html` per frame) once there are three or more scene cuts, scenes over ~100 lines, or a continuous audio bed across several visual segments — in which case **audio lives at the host root**.
- Plan around the hard nesting limit: *"a sub-comp timeline cannot animate host-root elements."* Anything that must move across a scene boundary (a camera wrapper, a persistent progress spine) has to be planned as a host-root element driven on the main timeline at **global time = scene-local time + the slot's `data-start`**.
- Plan the root `data-duration` up front: it is read once at compile time and no script or `--variables` can change render length.
- Sub-comp ids must be unique across the **assembled** page — prefix them (`#<scene>-hero`) at plan time.

**ffmpeg — the timing animatic.** Turn frame stills into a real-time animatic to test durations before any motion exists:

```bash
# one still per frame, durations from the storyboard, at 30fps
printf "file 'f01.png'\nduration 3.4\nfile 'f02.png'\nduration 5.2\nfile 'f03.png'\nduration 5.2\nfile 'f03.png'\n" > list.txt
ffmpeg -f concat -safe 0 -i list.txt -vf "fps=30,scale=1920:1080" -pix_fmt yuv420p animatic.mp4
# lay the scratch VO under it to check whether each frame's duration matches its line
ffmpeg -i animatic.mp4 -i vo.wav -c:v copy -c:a aac -shortest animatic_vo.mp4
```

**Remotion:** the same plan file can drive a `<Series>` of `<Series.Sequence durationInFrames>` — concept only.

## Pairs with
[[struct-storyboard-the-cuts-pre-shoot]] · [[motion-format-promise-motion-budget]] · [[motion-whip-pan-transition]] · [[motion-light-leak-overlay-transition]] · [[cut-match-cut]] · [[motion-overlay-stack-choreography]] · [[motion-sound-bound-motion-event]] · [[pace-beat-grid-extraction]]

## Failure modes
- **Transitions chosen per scene.** Six types, no house style; the video reads as a template sampler. Correction: fix 2–3 types in the frontmatter before building, name the primary.
- **Plan with no numbers.** "Card slides in" is not a spec and does not survive handoff. Correction: from-value, to-value, seconds, ease, stagger, bound sound.
- **Frames marked `animated` before their sound exists.** Motion without its sound event is not finished ([[motion-sound-bound-motion-event]]). Correction: gate `animated` on both.
- **Building ahead of the plan.** Frame 6 exists while frame 4 is still `outline`; durations then no longer add up to the root duration. Correction: build in order, update `status` as you go.
- **Ignoring parser warnings.** The parser never throws, so a mistyped key silently becomes `extra` and your spec is invisible to the contact sheet. Correction: read `warnings` after every edit.
- **Planning cross-scene motion inside a sub-comp.** It cannot animate host-root elements; the tween silently does nothing. Correction: plan such elements as host-root siblings with global-time positions.
- **Root duration too short for the outro.** The last fade is clipped and cannot be extended later. Correction: budget the final black in the frontmatter duration.
- **Known gap:** `references/script-format.md` and the `rules/` recipe directory are not staged in this project, so a plan may cite a rule by name (`waterfall-entry`, `multi-phase-camera`, …) but must not quote its code.
