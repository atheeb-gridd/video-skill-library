---
name: motion
description: Reproduce the MOTION, exactly. Analyse a reference video's animation vocabulary, then write a frame-precise motion specification for a new video. Use for animation, motion graphics, kinetic typography, camera moves, graphic reveals and animated transitions, or when the user names the motion skill.
type: skill-router
library: skills/MOTION/rules/
templates: ["_templates/design-motion.md", "_templates/style-profile.md"]
pipeline: "_meta/pipeline.md"
engine: hyperframes
---

# Motion

**Browse instead of query:** [[skills/MOTION/INDEX|skills/MOTION/INDEX.md]] lists all 57 notes grouped by family, with a start-here path. Use it when you do not already know the tag — routing below is tag-driven, and a mistagged note is invisible to it.

**Precision is the entire deliverable.** "Slides in from the left" is a failed spec. `translateX -120px → 0 over 14f on cubic-bezier(0.16,1,0.3,1), 3f stagger across siblings` is a spec. If a row in your design document could be executed two visibly different ways, it is not finished.

Runs **after** cuts — motion timing keys off cut boundaries.

---

## Mode A — ANALYSE a reference video

**Produces:** `_profiles/<name>/01-observed-motion.md` → the motion sections of `PROFILE.md`.

1. **Find motion events.** Extract frames densely around every graphic or text appearance:
   ```bash
   ffmpeg -i "<video>" -ss <t> -t 1.5 -vf fps=30 /tmp/m/%03d.png
   ```
   Then **read the frames in sequence.** This is how you recover real timing: count the frames from first appearance to settled state — that is your duration. Compare the per-frame position deltas — front-loaded means ease-out, back-loaded means ease-in, symmetric means ease-in-out.
2. **Classify** against `skills/MOTION/rules/` using each note's recognition section.
3. **Recover parameters, not just names.** Per event: duration in frames, property track, easing shape, stagger, overshoot, layer order. Overshoot is the tell for a spring — if the element passes its resting position and settles back, log the overshoot percentage.
4. **Build the vocabulary.** Which handful of moves recur? A creator's style is usually 4–8 moves reused, not endless invention.
5. **Log the negatives.** What the reference *never* does is as diagnostic as what it does. No 3D flips, no rotation, no bounce — write it down.
6. **Measure density.** Motion events per minute, and the longest gap without one.

## Mode B — DESIGN a new video

**Produces:** `_projects/<name>/design/design-motion.md` from `_templates/design-motion.md`.

1. **Read `design-cuts.md` first.** Motion attaches to cuts and to spoken words; you need both timelines.
2. **Place events** where the profile's density and triggers say they belong.
3. **Write the full property track for every event** — the table of property, from, to, start, duration, easing. Copy the Reproduction prompt from the rule note and resolve every placeholder.
4. **Set layer order explicitly.** Z-order bugs are the most common silent failure.
5. **Pair the sound.** Almost every motion event wants an `sfx/motion` effect. Name it here and make sure it appears in `design-sound.md` at the matching offset. Sound usually leads picture by a few frames.
6. **Write an acceptance test per event** — the frame range to inspect and what must be true in it.

---

## Routing

| The ask | Go to |
|---|---|
| I don't know the tag — just show me everything | **[[skills/MOTION/INDEX|skills/MOTION/INDEX.md]]** — all 57 notes by family, plus a start-here path |
| How does this element come in / leave? | `skills/MOTION/rules/` filtered `type/motion` |
| Animate this text | `type/type-motion` |
| Push in, zoom, pan | `type/camera` |
| Reveal a stat, chart, logo | `type/graphic` |
| Get from scene A to scene B with movement | `type/transition` + the transition registry in `_meta/execution-contract.md` |
| What does this movement sound like? | `skills/SOUND-DESIGN/rules/` filtered `sfx/motion` |
| Teach an edit — show the cut, not just the result | [[motion-timeline-overlay-explainer]], and [[motion-two-track-offset-diagram]] for J/L |
| Name an abstract concept that has no footage | [[motion-abstract-concept-card]] |
| Compare two shots across a cut in one frame | [[motion-filmstrip-comparison-strip]] |
| Quote someone else's clip | [[motion-attribution-label-inset-clip]] |
| Which typeface for this title card? | [[motion-type-treatment-matches-content]] |

```dataview
TABLE title, family, difficulty FROM #skill/motion SORT type, family
```

## Non-negotiables

- **Frames, never seconds-as-vibes.** At the fps stated in the design doc's frontmatter.
- **Easing named exactly** — a cubic-bezier with four numbers, or a named curve that exists in `_meta/execution-contract.md`.
- **Ground every spec in the execution contract.** If an attribute is not in that file, it does not exist. Do not write against a plausible-looking API you have not confirmed.
- **No CDN loads.** `cdn.jsdelivr.net` is blocked in this environment — a composition that pulls GSAP from a CDN renders blank. Inline everything.
- **Motion serves the cut.** A motion event that exists because it looked fun, rather than because the edit needed it, is the one to cut.
