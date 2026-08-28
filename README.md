---
name: Video Editing vault
description: Skill library that turns reference videos into reproducible edits — cuts, motion, sound design and subtitles.
type: index
---

# Video Editing

A skill library, not a notes folder. You drop in reference videos; it learns the style; it edits new videos the same way.

**The map is [[INDEX|INDEX.md]]** — every library, every `_meta` document, every template and every pipeline stage, with links. Start there if you are looking for something specific.

```
reference video + transcript  ──▶  style profile  ──▶  design documents  ──▶  rendered video
```

The **design document** in the middle is the whole idea. It is the auditable, editable plan that sits between "here is a video I like" and "here is a new video that feels like it" — so when an output is wrong, you can see exactly which decision was wrong.

## The four skills

| Skill | Owns | Library |
|---|---|---|
| [[skills/EDITING/SKILL\|Editing]] | Reproduce the **cut** — cut types, pacing, structure, retention | `skills/EDITING/rules/` |
| [[skills/MOTION/SKILL\|Motion]] | Reproduce the **motion** — frame-precise animation specs | `skills/MOTION/rules/` |
| [[skills/SOUND-DESIGN/SKILL\|Sound design]] | Which **sound**, and how to fetch it from Epidemic | `skills/SOUND-DESIGN/rules/` |
| [[skills/SUBTITLES/SKILL\|Subtitles]] | **Caption** identity, timing and emphasis | `skills/SUBTITLES/rules/` |

They run in that order. Cuts define the timeline; motion attaches to cuts; sound is timed off motion; captions key off both.

## How to use it

**Profile a style** — "Profile these three videos." Runs stages 1–3 of `_meta/pipeline.md` and writes a reusable profile to `_profiles/`.

**Edit a new video** — "Edit this using all four skills, in the <name> style." Runs stages 4–5 and writes design documents to `_projects/<name>/design/`, then a build manifest.

**Use one skill only** — name it: "just redo the sound design."

## Layout

| Path | What's in it |
|---|---|
| `skills/EDITING/` `skills/MOTION/` `skills/SOUND-DESIGN/` `skills/SUBTITLES/` | A `SKILL.md` router, a `rules/` library of one-note-per-technique, and `_kt/` extraction notes |
| `skills/` | The four libraries. Nothing but skill content lives here. |
| `assets/videos/` | The 5 source KT videos. **Do not delete** — `_meta/visual-kt-delta.md` records why. |
| `assets/audio/` | Extracted audio per video, for sound analysis without the mp4s |
| `assets/transcripts/` | Raw ASR output, all languages and all passes |
| `assets/transcripts-en/` | Cleaned, timestamped English transcripts |
| `assets/frames/` | Contact sheets — 30 frames per video. Look here before claiming anything visual. |
| `_meta/pipeline.md` | **The runtime contract.** Read this first. |
| `_meta/tags.md` | The closed tag vocabulary |
| `_meta/execution-contract.md` | What this stack can actually execute — the source of truth for every spec |
| `_meta/build-report.md` | Integrity report from the last library build |
| `_templates/` | The design-document, profile and rule-note templates |
| `_profiles/` | Style profiles, one per reference set |
| `_projects/` | Per-video work: design documents and build manifests |
| `hyperframes/` | The working HyperFrames install that renders everything |
| `.claude/skills/` | Thin loaders so Claude Code auto-discovers the four skills |

Every rule note carries two sections that do the real work: **How to recognise it in a reference video** (which makes analysis possible) and **Reproduction prompt** (a standalone, copy-pasteable instruction for an executing agent).

## The stack

| Tool | Job |
|---|---|
| **HyperFrames** | Compositions, motion, captions, rendering |
| **Epidemic Sound** (MCP) | Real SFX, music and ambience |
| **ffmpeg** / media-use | Raw media — trims, concat, speed, audio slip, loudness |
| **Claude** | Drives all of the above from these skills |

## House rules

- **Frames at a stated fps.** Never "quick", "snappy", "a beat".
- **Every design row cites a rule note**, or is marked `ad-hoc` so review catches it.
- **Observation before assertion.** A technique not visually confirmed in a reference is a hypothesis and is labelled one.
- **Specs must be true against `execution-contract.md`.** No plausible-looking APIs.
- **No CDN loads in compositions** — the egress allowlist blocks them and the render comes out blank.
- **Render is human-gated.** Checks and preview first, always.
