---
name: pipeline
description: The runtime contract. Reference video + timestamped transcript in, design documents out, build manifest handed to the engines.
type: reference
---

# The pipeline

This is the contract every skill in this vault implements. It exists because a reference video and a finished new video are too far apart to cross in one jump — the **design document** is the intermediate artifact that makes the jump auditable, editable, and repeatable.

```
  reference video(s)                          the new video
  + timestamped transcript                    + its transcript
          │                                          │
          ▼                                          ▼
    ┌───────────┐   ┌───────────┐   ┌───────────┐   ┌───────────┐   ┌───────────┐
    │ 1 INGEST  │──▶│ 2 ANALYSE │──▶│ 3 PROFILE │──▶│ 4 DESIGN  │──▶│ 5 HANDOFF │
    └───────────┘   └───────────┘   └───────────┘   └───────────┘   └───────────┘
      probe media     detect            condense       write the       build
      align text      techniques        into a         four design     manifest
                      against the       style          documents       → engines
                      rules library     profile
```

Stages 1–3 run **once per reference set** and produce a reusable style profile. Stages 4–5 run **once per new video**. That split is the point: profile a creator once, then edit ten videos in their style.

---

## Stage 1 — INGEST

**Input:** video file(s), transcript(s).

Probe every media file and write the facts down; every frame count downstream depends on them.

```bash
ffprobe -v error -select_streams v:0 \
  -show_entries stream=r_frame_rate,width,height,nb_frames,duration \
  -of default=noprint_wrappers=1 "<video>"
```

Record: **fps**, resolution, aspect, duration, and audio channel layout.

> **Read fps per file. Never assume it.** The KT references in this vault run at 60, 25 and 29.97fps — see `source-media.md`. Measuring a 60fps file as 30fps halves every duration you observe. Convert measurements to **seconds** first, then re-express in frames at the target project fps, and record the source fps next to every observed parameter. Normalise the transcript to `[HH:MM:SS.mmm] text` lines. If a transcript is missing, generate one — `media-use/scripts/transcribe.mjs` is in the HyperFrames install. If it is in Hinglish or another mixed language, keep the original **and** an English translation side by side; the original carries the delivery rhythm, the translation carries the meaning.

**Output:** `_profiles/<name>/00-ingest.md`

## Stage 2 — ANALYSE

**Input:** the ingested media, plus the rules libraries.

This is where the library earns its keep. For each skill, walk the reference video and match what you see against the **How to recognise it in a reference video** section of every rule note. That section is written to be machine-checkable, so this stage is detection, not interpretation.

Log every hit as a row: `timecode | rule id | confidence | observed parameters | evidence`. Observed parameters matter more than the hit itself — knowing the video uses `[[cut-j-audio-leads-picture]]` is mildly useful; knowing it slips audio ahead by a consistent 6–8 frames is what lets you reproduce the feel.

Sample the video, don't guess. Pull frames at cut points and around motion events:

```bash
ffmpeg -i "<video>" -vf "select='gt(scene,0.3)',showinfo" -vsync vfr /tmp/cuts/%04d.png
```

Read the frames. A technique you did not visually confirm goes in the log at low confidence and gets flagged, never asserted.

**Output:** `_profiles/<name>/01-observed-{cuts,motion,sound,subtitles}.md`

## Stage 3 — PROFILE

**Input:** the observation logs.

Condense observations into rules with numbers attached. A profile is not a list of techniques — it is a set of **defaults and tolerances** that a new video must satisfy. "Uses fast cuts" is worthless. "Median shot length 1.8s, p90 4.2s, never exceeds 7s without a motion event" is a profile.

Every profile section states the numbers, the range, and how confident the observation is. Sparse evidence gets marked sparse rather than smoothed over.

**Output:** `_profiles/<name>/PROFILE.md` — from `_templates/style-profile.md`

## Stage 4 — DESIGN

**Input:** the profile, plus the new video's raw footage and transcript.

Emit four design documents. Each is a **decision record with timecodes** — every row names the rule note it applies and the concrete parameters, so the row is executable and traceable back to why.

| Document | Template | Owns |
|---|---|---|
| `design-cuts.md` | `_templates/design-cuts.md` | the edit decision list: every cut, its type, its frames |
| `design-motion.md` | `_templates/design-motion.md` | every animated element, with full motion spec |
| `design-sound.md` | `_templates/design-sound.md` | every sound, its style and layer, its Epidemic query |
| `design-subtitles.md` | `_templates/design-subtitles.md` | caption identity, timing model, emphasis map |

Order matters. Cuts first — they define the timeline everything else attaches to. Then motion, which needs cut boundaries. Then sound, which needs both, since motion sound effects are timed off motion events. Subtitles last, because emphasis treatments key off the cuts and the motion.

**Output:** `_projects/<name>/design/*.md`

## Stage 5 — HANDOFF

**Input:** the four design documents.

Compile them into one `BUILD.md` manifest that the engines consume, then execute in this order:

1. **Fetch** — every Epidemic asset named in `design-sound.md`, resolved to a local file. Fetch before building; a missing asset discovered mid-render is a wasted render.
2. **Cut** — apply the EDL with ffmpeg, producing the assembled base.
3. **Compose** — build HyperFrames compositions for motion and captions.
4. **Mix** — place sound on its tracks with the specified gain and ducking.
5. **Check** — `npm run check`, then preview, then render.

Nothing renders until the checks pass and a human says go.

**Output:** `_projects/<name>/BUILD.md` — from `_templates/build-manifest.md`

---

## Invariants

- **Frames, not vibes.** Every timing value is a frame count or a millisecond value at a stated fps. "Quick" and "snappy" are not values.
- **Every design row cites a rule.** If a decision has no rule note behind it, either write the note or mark the row `ad-hoc` so it shows up in review.
- **Observation before assertion.** A technique not visually confirmed in the reference is a hypothesis and is labelled one.
- **The profile is the contract, the design doc is the plan, the manifest is the build.** Do not skip a layer to save time — the layers are what make a bad output diagnosable.
- **Known project constraints** (see `execution-contract.md`): no CDN loads in compositions, the vault mount cannot delete files, browser rendering does not run on the device VM.
