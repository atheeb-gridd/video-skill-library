---
name: vault-index
description: The map of the whole vault — four skill libraries and their indexes, the _meta documents, the templates, and the five pipeline stages. Start here.
type: index
count: 349
---

# The vault — map

A skill library that turns **reference videos** into **reproducible edits**. You drop in videos you like; it learns the style; it edits new videos the same way. The thing in the middle — the **design document** — is the whole idea: an auditable, editable plan sitting between "here is a video I like" and "here is a new video that feels like it", so when an output is wrong you can point at the decision that was wrong.

```
reference video + transcript  ──▶  style profile  ──▶  design documents  ──▶  rendered video
```

**349 rule notes** across four libraries. Every note is one technique, and every note carries the same nine sections — including *How to recognise it in a reference video* (which makes analysis possible) and a standalone *Reproduction prompt* (which makes execution possible).

**If you are new:** read `_meta/pipeline.md` first — it is the runtime contract every skill implements. Then open the index of whichever library your problem lives in, and use its **Start here** list.

---

## 1. The four skill libraries

They run in this order, and the order is a dependency, not a preference. Cuts define the timeline; motion attaches to cuts; sound is timed off motion events; captions key off both.

| # | Library | Owns | Notes | Router | Browse |
|---|---|---|---|---|---|
| 1 | **EDITING** | Reproduce the **cut** — cut types, pacing, structure, retention | 81 | `skills/EDITING/SKILL.md` | [[skills/EDITING/INDEX\|skills/EDITING/INDEX.md]] |
| 2 | **MOTION** | Reproduce the **motion** — frame-precise animation, graphics, camera | 57 | `skills/MOTION/SKILL.md` | [[skills/MOTION/INDEX\|skills/MOTION/INDEX.md]] |
| 3 | **SOUND-DESIGN** | Which **sound**, and how to fetch it from Epidemic | 137 | `skills/SOUND-DESIGN/SKILL.md` | [[skills/SOUND-DESIGN/INDEX\|skills/SOUND-DESIGN/INDEX.md]] |
| 4 | **SUBTITLES** | **Caption** identity, timing, emphasis and motion | 52 | `skills/SUBTITLES/SKILL.md` | [[skills/SUBTITLES/INDEX\|skills/SUBTITLES/INDEX.md]] |
| | | **total** | **327** | | |

Each library is `<SKILL>/SKILL.md` (the router — modes, non-negotiables, tag queries), `<SKILL>/INDEX.md` (the browsable catalogue — every note by family, plus a start-here path), and `<SKILL>/rules/` (the notes themselves, one file per technique).

**Two ways in, on purpose.** The router routes by *tag query*, which is fast if you already know the vocabulary but silently hides a note whose tag is wrong. The index routes by *browsing*, and reaches every note regardless of its tags. Prefer the index when you do not already know what the thing is called.

`skills/SOUND-DESIGN/_kt/` holds the two delta passes over the reference videos — extraction working notes, kept for provenance, not part of the rule library.

---

## 2. The pipeline — five stages

`_meta/pipeline.md` is the contract. Stages 1–3 run **once per reference set** and produce a reusable style profile; stages 4–5 run **once per new video**. That split is the point: profile a creator once, then edit ten videos in their style.

| Stage | Does | Input | Output |
|---|---|---|---|
| **1 · INGEST** | Probe every media file with `ffprobe`, align the transcript. Every frame count downstream depends on this. | video files, transcripts | `_profiles/<name>/00-ingest.md` |
| **2 · ANALYSE** | Detect techniques and check them against the rules libraries. Measure; do not characterise. | ingested media + the four libraries | `_profiles/<name>/01-observed-{cuts,motion,sound,subtitles}.md` |
| **3 · PROFILE** | Condense the observation logs into one reusable style profile. | the observation logs | `_profiles/<name>/PROFILE.md` |
| **4 · DESIGN** | Write the four design documents for a new video, every row citing a rule note. | the profile + new footage and transcript | `_projects/<name>/design/*.md` |
| **5 · HANDOFF** | Compile the design documents into a build manifest for the engines. | the four design documents | `_projects/<name>/BUILD.md` |

Read the stage definitions, the per-stage commands and the invariants in **`_meta/pipeline.md`**.

---

## 3. `_meta/` — the reference documents

Six documents. Between them they define what may be written, what may be executed, and what was actually measured.

| Document | What it is for |
|---|---|
| **`_meta/pipeline.md`** | **The runtime contract.** The five stages, their inputs and outputs, the commands each runs, and the invariants that hold across all of them. Read first. |
| **`_meta/execution-contract.md`** | **The boundary of the executable.** The real HyperFrames attributes, transition names and audio model; the sixteen Epidemic Sound MCP tools and the six music facets; the ffmpeg analysis toolchain, marked verified or unverified. A spec that cites anything outside this document is not known to run. |
| **`_meta/tags.md`** | **The closed tag vocabulary.** `skill/`, `type/`, `family/`, `engine/`, `sfx/`, `layer/`, `source/`, `difficulty/`. A tag outside this list is a bug, not a new idea. |
| **`_meta/source-media.md`** | **Measured format facts** for the five reference videos — resolution, fps, duration — and the fps normalisation rule. Three different frame rates across five references; assuming 30fps silently halves or doubles every measurement. |
| **`_meta/visual-kt-delta.md`** | **What the transcripts could not see.** Findings from reading contact sheets of all five references: the set is three creators not five, ducking *is* demonstrated but never named, and the captions are romanised Hinglish rather than Devanagari. Corrective, not merely additive. |
| **`_meta/build-report.md`** | **The integrity report** from the last library build — counts, duplicate ids, link resolution, section completeness, tag conformance, and a prioritised review list. |

---

## 4. `_templates/` — the document shapes

Seven templates. Copy them; do not invent a new shape.

| Template | Produces |
|---|---|
| `_templates/rule-note.md` | A rule note — the nine-section shape every one of the 327 notes follows |
| `_templates/style-profile.md` | `_profiles/<name>/PROFILE.md`, the stage-3 output |
| `_templates/design-cuts.md` | `design-cuts.md` — the edit decision list (stage 4, editing) |
| `_templates/design-motion.md` | `design-motion.md` — the motion specification (stage 4, motion) |
| `_templates/design-sound.md` | `design-sound.md` — the sound spec and asset fetch list (stage 4, sound) |
| `_templates/design-subtitles.md` | `design-subtitles.md` — the caption specification (stage 4, subtitles) |
| `_templates/build-manifest.md` | `_projects/<name>/BUILD.md`, the stage-5 handoff |

---

## 5. Everything else

| Path | What is in it |
|---|---|
| `README.md` | The prose introduction — what the vault is, how to ask it for work, the house rules |
| `_profiles/` | Style profiles, one directory per reference set. Currently empty — no profile has been built yet |
| `_projects/` | Per-video work: design documents and build manifests. Currently empty |
| `assets/transcripts-en/` | The five cleaned, timestamped English transcripts the libraries were mined from |
| `assets/videos/` | The source KT videos. Teaching references, not source footage — see `_meta/source-media.md` |
| `.claude/skills/` | Four thin loaders so Claude Code auto-discovers the skills. The real libraries live in the visible vault |
| `hyperframes/` | The working HyperFrames install that renders everything |

---

## 6. The stack

| Tool | Job |
|---|---|
| **HyperFrames** | Compositions, motion, captions, rendering |
| **Epidemic Sound** (MCP) | Real SFX, music, ambience and voiceover |
| **ffmpeg** / media-use | Raw media — trims, concat, speed, audio slip, loudness — and all measurement |
| **Claude** | Drives all of the above from these skills |

## House rules

- **Frames at a stated fps.** Never "quick", "snappy", "a beat".
- **Every design row cites a rule note**, or is marked `ad-hoc` so review catches it.
- **Observation before assertion.** A technique not visually confirmed in a reference is a hypothesis, and is labelled one.
- **Specs must be true against `_meta/execution-contract.md`.** No plausible-looking APIs.
- **No CDN loads in compositions** — the egress allowlist blocks them and the render comes out blank.
- **Render is human-gated.** Checks and preview first, always.

---

## Where to go next

| You want to | Go to |
|---|---|
| Understand how the whole thing runs | `_meta/pipeline.md` |
| Find a technique but not know its name | the library's `INDEX.md`, section **Start here** |
| Find a technique and know the tag | the library's `SKILL.md`, section **Routing** |
| Know whether a spec can actually run | `_meta/execution-contract.md` |
| Add a note | `_templates/rule-note.md`, then check the tags against `_meta/tags.md` |
| Know what is currently broken | `_meta/build-report.md` |
