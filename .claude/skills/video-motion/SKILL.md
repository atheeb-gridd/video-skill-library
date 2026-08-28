---
name: video-motion
description: Reproduce MOTION exactly — frame-precise animation specs for motion graphics, kinetic typography, camera moves, graphic reveals and animated transitions, executed through HyperFrames. Use when analysing a reference video's animation vocabulary, when specifying or building any animated element, or when the user names the motion skill.
---

# Motion (loader)

The real library lives in the visible vault so it is browsable, taggable and linkable in Obsidian. This file only routes you there.

**Read these now, in order:**

> **Paths below resolve from your cwd, not from this file's directory. Do not `cd`** — a
> vault-root path that looks missing usually means you changed directory, not that the file
> is absent.


1. `skills/MOTION/SKILL.md` — the routing logic and the two modes (ANALYSE / DESIGN)
2. `_meta/execution-contract.md` — the real HyperFrames primitives. **Required.** Every motion spec must be true against this file; do not write against an API you have not confirmed here.
3. `_meta/pipeline.md` — the five-stage contract
4. `_meta/tags.md` — the closed tag vocabulary

**The rule library:** `skills/MOTION/rules/` — one note per motion, with a full property track and a copy-pasteable reproduction prompt.

**Templates:** `_templates/design-motion.md`, `_templates/style-profile.md`

Runs **after** cuts. Precision is the deliverable: if a spec could be executed two visibly different ways, it is not finished. No composition may load a library from a CDN — the egress allowlist blocks it and the render comes out blank.
