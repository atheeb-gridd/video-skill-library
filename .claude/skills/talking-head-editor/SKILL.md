---
name: talking-head-editor
description: Edit a real-footage talking-head video — Instagram Reels, Shorts, vertical social — from reference videos you admire. Breaks 2-3 references into a measured style profile, then specs the whole edit as four design documents (cuts, motion, sound, subtitles) for approval before building anything, then assembles, mixes and renders. Covers extracting audio and transcripts when they are not supplied, sound design across diegetic/motion/aesthetic styles via Epidemic Sound, and HyperFrames captions. Use whenever editing or re-cutting footage of a person speaking to camera, matching a reference video's style, or building a style profile from references. For stills-plus-voiceover doodle explainers use faceless-doodle-editor instead.
---

# Talking-head editor

You are editing real footage of a person speaking. The craft is **subtractive**: the raw file contains too much, and the edit is what you remove, plus what you add back to hold attention across the removals.

This skill sits on top of the rule library in the vault. It does not restate the rules — it sequences them, and it enforces the two disciplines that make the difference between a good edit and an expensive mess.

## The two disciplines

**1. Spec before you build.** Four design documents are written and approved before a single frame renders. Not bureaucracy — the render is the expensive step, and a wrong decision found in a design document costs a paragraph, while the same decision found in a render costs the render. Every design row cites the rule note that justifies it.

**2. Two clocks.** Cuts are designed in **source** timecode. Sound, captions and motion are designed in **output** timecode, and only after the cut list is locked. Remove 3.2s of pauses and every sound effect after that point lands 3.2s late — and it reads as *bad sound design*, not as a bug, which is why it survives review. `references/timebase.md` is not optional reading.

## Route first

| The user gives you | Go |
|---|---|
| Footage of a person speaking + transcript | **This skill.** |
| Stills / illustrations + voiceover + transcript | `faceless-doodle-editor`. Different craft — no cuts to subtract, and its render pipeline is Remotion. Do not force it through here. |
| Reference videos only, no project yet | Stage A of this skill, stop after the profile. |

## Order of work

Stages are **serial**. Each attaches to the timeline the previous one defines, so running them out of order or in parallel produces sound cues timed against motion that does not exist. Parallelism lives *inside* a stage — see below.

### A — Break down the references → a style profile

`references/reference-breakdown.md`

2-3 videos in, one `_profiles/<name>/PROFILE.md` out. A profile is **defaults and tolerances with numbers**, not a list of techniques. "Fast cuts" is worthless; "median shot 1.8s, p90 4.2s, never past 7s without a motion event" is a profile.

Runs once per reference set and is then reused for every video in that style.

> **Parallel here:** one subagent per reference video, each returning structured observations, then a merge. This is the main speedup in the whole skill.

### B — Ingest the project

`scripts/ingest.sh`

Probe the footage. **Read fps per file, never assume it** — measuring a 60fps source as 30fps halves every duration you observe.

Fallbacks, because the user may not supply everything:
- No separate audio → extract it from the video.
- No transcript → generate one, then force-align for word-level timings.
- Transcript without word-level timings → force-align against the audio.

### C — Design, in this order

| # | Document | Reference | Depends on |
|---|---|---|---|
| 1 | `design-cuts.md` | `skills/EDITING/SKILL.md` | the profile |
| 2 | `design-motion.md` | `skills/MOTION/SKILL.md` | locked cuts |
| 3 | `design-sound.md` | `references/sound-design-pass.md` | locked cuts **and** motion |
| 4 | `design-subtitles.md` | `references/subtitle-spec.md` | all three |

Cuts first because they define the timeline. Sound after motion because motion effects are timed off motion events. Subtitles last because emphasis and position key off both, and captions must not collide with graphics.

After cuts are locked, **build the timebase map and re-stamp the transcript into output time.** Everything downstream reads the re-stamped version.

> **Parallel here:** within the sound stage, the three styles — diegetic, motion, aesthetic — are independent layers and can be designed concurrently, then merged with a collision check. Epidemic fetches parallelise freely once the fetch list exists.

### D — ⛔ APPROVAL GATE

**Stop. Present the four design documents. Wait.**

This gate is the entire reason the design stage exists. Skip it and you have spent the same compute with extra steps. Present: the four documents, the profile checks each one passed or failed, and every open question. Then wait for a human.

Proceed only on an explicit go. If working unattended, stop here and say so.

### E — Build

`references/build-and-render.md`

Fetch → assemble → render layers → composite → mix → master → verify.

**The render is not the inner loop.** Verify picture by extracting single frames at chosen output timecodes and looking at them. Render silent and mux audio separately, so an audio fix costs seconds instead of a full re-render.

## Non-negotiables

- **Frames at a stated fps.** Never "quick", "snappy", "a beat".
- **Every design row cites a rule note**, or is marked `ad-hoc` so review catches it.
- **Observation before assertion.** A technique not visually confirmed in a reference is a hypothesis and is labelled one.
- **Specs must be true against `_meta/execution-contract.md`.** If a filter or attribute is not in there, it is not known to run.
- **No CDN loads in any composition.** `cdn.jsdelivr.net` is blocked; a composition that pulls a library from it renders blank. Inline everything.
- **Fetch every asset before building.** A missing sound found mid-render is a wasted render.
- **Render is human-gated**, on top of the design gate.

## Where things live

```
_profiles/<style>/          PROFILE.md + observation logs     ← tracked in git
_projects/<video>/
├── design/*.md             the four design documents         ← tracked in git
├── BUILD.md                the compiled manifest             ← tracked in git
├── footage/ renders/       everything else                   ← local only
```

## Reference files

| File | Read it when |
|---|---|
| `references/timebase.md` | **Always.** Before designing anything past cuts. |
| `references/reference-breakdown.md` | Stage A |
| `references/sound-design-pass.md` | Stage C.3 |
| `references/subtitle-spec.md` | Stage C.4 |
| `references/build-and-render.md` | Stage E |

The rule libraries themselves — 327 notes across `skills/EDITING`, `skills/MOTION`, `skills/SOUND-DESIGN`, `skills/SUBTITLES` — are the source of every technique. Start at a library's `INDEX.md` to browse, or query by tag per `_meta/tags.md`.
