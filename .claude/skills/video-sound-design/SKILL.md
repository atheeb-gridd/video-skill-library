---
name: video-sound-design
description: Decide which sound belongs at a moment and fetch it from Epidemic Sound. Covers the three styles of sound effect (diegetic, motion, aesthetic), the five layers of sound, music selection, ambience, frame-accurate placement and mixing. Use for SFX, music, audio layering or mixing, or when the user names the sound design skill.
---

# Sound design (loader)

The real library lives in the visible vault so it is browsable, taggable and linkable in Obsidian. This file only routes you there.

**Read these now, in order:**

1. `skills/SOUND-DESIGN/SKILL.md` — the two frameworks (three styles, five layers), the routing logic and the two modes
2. `_meta/pipeline.md` — the five-stage contract
3. `_meta/tags.md` — the closed tag vocabulary
4. `_meta/execution-contract.md` — the audio model, tracks, ducking and the FX registry

**The rule library:** `skills/SOUND-DESIGN/rules/` — each note carries the tested Epidemic search query, the frame offset relative to the visual event, and the gain in dB relative to dialogue.

**Templates:** `_templates/design-sound.md`, `_templates/style-profile.md`

Runs **after** cuts and motion, since motion sound effects are timed off motion events. Every effect must be classified by one of the three styles — an unclassified effect is an unjustified one. Fetch every asset before building.
