---
name: editing
description: Reproduce the CUT. Analyse how a reference video is cut, then design the edit decision list for a new video in that style. Use when asked to match a reference video's pacing, cut types, structure or retention shape, or when the user names the editing skill.
type: skill-router
library: skills/EDITING/rules/
templates: ["_templates/design-cuts.md", "_templates/style-profile.md"]
pipeline: "_meta/pipeline.md"
---

# Editing

**Browse instead of query:** [[skills/EDITING/INDEX|skills/EDITING/INDEX.md]] lists all 81 notes grouped by family, with a start-here path. Use it when you do not already know the tag — routing below is tag-driven, and a mistagged note is invisible to it.

**This skill owns the timeline.** Cuts are designed before motion, sound or captions, because everything else attaches to the timeline cuts define.

Two modes. Read `_meta/pipeline.md` for the full contract; this file is the routing logic.

---

## Mode A — ANALYSE a reference video

**You have:** a reference video and its timestamped transcript.
**You produce:** `_profiles/<name>/01-observed-cuts.md`, then the cut sections of `PROFILE.md`.

1. **Probe first.** Get real fps and duration with `ffprobe`. Every frame count below depends on it.
2. **Find the cuts mechanically.** Do not eyeball this:
   ```bash
   ffmpeg -i "<video>" -vf "select='gt(scene,0.3)',showinfo" -vsync vfr -f null - 2>&1 | grep showinfo
   ```
   Extract frames either side of each detected cut and **look at them**. Scene detection finds candidates; your eyes classify them.
3. **Classify every cut** against `skills/EDITING/rules/`. Each note's *How to recognise it in a reference video* section is written to be checkable — use it as the test, not your intuition. Log `timecode | rule id | confidence | observed parameters | evidence`.
4. **Measure, don't characterise.** Compute the shot-length distribution: median, p90, max, cuts per minute. "Fast cutting" is not an observation; `median 1.8s, p90 4.2s, 22 cuts/min` is.
5. **Log the audio relationship.** For each cut, does audio lead or trail picture, and by how many frames? A consistent slip is a signature.
6. **Map the macro structure** — hook, setup, payoff, and where retention devices land.

A technique you did not visually confirm is a hypothesis. Mark it low-confidence; never assert it.

## Mode B — DESIGN a new video

**You have:** a style profile, new footage, and a transcript.
**You produce:** `_projects/<name>/design/design-cuts.md` from `_templates/design-cuts.md`.

1. **Structure before cuts.** Lay out the macro beats and their durations. A well-cut video with a broken structure still fails.
2. **Pass 1 — subtractive.** Remove dead space per the profile's policy. This is mechanical; `media-use/scripts/transcript-cut.mjs` drives it from the transcript.
3. **Pass 2 — motivated cuts.** Every cut gets a *reason* in the Motivation column. A cut with no reason beyond "it had been a while" is the row a reviewer should delete.
4. **Pass 3 — rhythm.** Check the shot-length distribution against the profile targets and fix outliers. Watch for the profile's hard rules, e.g. "no static hold past 4s without a motion event".
5. **Pass 4 — retention.** Place pattern interrupts and open loops where the profile puts them.
6. **Fill every parameter.** Copy the Reproduction prompt from each cited rule note and resolve all placeholders. No `{{}}` survives into the build.

Hand off to motion, then sound, then subtitles — in that order.

---

## Routing

| The ask | Go to |
|---|---|
| I don't know the tag — just show me everything | **[[skills/EDITING/INDEX|skills/EDITING/INDEX.md]]** — all 81 notes by family, plus a start-here path |
| Which cut goes here? | `skills/EDITING/rules/`, filtered by `type/cut` |
| How fast should this move? | `type/pacing` |
| How do I shape the whole video? | `type/structure` |
| They're dropping off at 0:30 | `type/retention` |
| How do I get from this shot to that one? | `type/transition`, then `skills/MOTION/rules/` for anything animated |
| What sound goes on this cut? | `skills/SOUND-DESIGN/rules/`, filtered `sfx/motion` |

Rule notes are tagged per `_meta/tags.md`. Query the library rather than guessing:

```dataview
TABLE title, family, difficulty FROM #skill/editing AND #type/cut SORT family
```

## Non-negotiables

- **Frames at a stated fps.** Never "a beat", "a moment", "quickly".
- **Every design row cites a rule note.** No note behind a decision means either write the note or mark the row `ad-hoc` so review catches it.
- **ffmpeg owns raw media** — trims, concat, speed. HyperFrames owns assembly and anything animated. See `_meta/execution-contract.md`.
- **Cuts are subtractive first.** Remove what should not be there before adding what should.
