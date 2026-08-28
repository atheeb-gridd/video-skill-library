---
name: subtitles
description: Caption and on-screen-text design, executed through HyperFrames. Covers caption identity and styling, timing models, word-level highlighting, emphasis, caption motion, safe areas and mixed-script text. Use for captions, subtitles, burned-in text or when the user names the subtitles skill.
type: skill-router
library: skills/SUBTITLES/rules/
templates: ["_templates/design-subtitles.md", "_templates/style-profile.md"]
pipeline: "_meta/pipeline.md"
engine: hyperframes
source: hyperframes/
---

# Subtitles

**Browse instead of query:** [[skills/SUBTITLES/INDEX|skills/SUBTITLES/INDEX.md]] lists all 52 notes grouped by family, with a start-here path. Use it when you do not already know the tag — routing below is tag-driven, and a mistagged note is invisible to it.

Captions are the most-watched element in a modern short-form video and the easiest to get subtly wrong. This library is mined chiefly from the **HyperFrames** install in this vault rather than from the KT videos, so its specs are executable rather than theoretical — see `_meta/execution-contract.md` for the real caption model and what is actually stylable.

Runs **last**. Emphasis treatments and positioning key off the cuts and the motion, so captions cannot be designed before those exist.

---

## Mode A — ANALYSE a reference video

**Produces:** `_profiles/<name>/01-observed-subtitles.md` → the caption identity section of `PROFILE.md`.

1. **Sample frames mid-cue** across the whole video and read them. Captions are the one element you can measure precisely from a single frame.
2. **Measure the type.** Cap height as a percentage of frame height (not points — points are meaningless across resolutions), weight, case, tracking, stroke width, shadow, and the plate behind it if any.
3. **Determine the mode.** Word-level (one or two words at a time), phrase-level (a full clause held), or hybrid. Check whether a single word is highlighted inside a held phrase — that active-word treatment is the most common signature.
4. **Measure position** as a percentage from the bottom, and check it against the platform's UI safe area.
5. **Recover the timing model.** Min and max cue duration, gaps, and crucially whether cues break at cuts or ride through them.
6. **Find the emphasis rule.** Which words get lifted — nouns, numbers, profanity, the promise words? There is almost always a rule, and the rule reproduces better than a word list.
7. **Log the motion.** How cues enter and leave, in frames.

## Mode B — DESIGN a new video

**Produces:** `_projects/<name>/design/design-subtitles.md` from `_templates/design-subtitles.md`.

1. **Start from the transcript, verbatim.** Captions match spoken words. Silent rewrites are a correctness bug, not a style choice.
2. **Set the identity** from the profile — one block, fully specified, applied consistently.
3. **Generate the cue sheet** against the timing model. Enforce the reading-speed cap and the line-length limits as hard constraints; a cue that violates them gets split, not shipped.
4. **Respect cut boundaries** per the profile's rule.
5. **Apply the emphasis rule**, then count the results. If more than a small fraction of words are emphasised, the emphasis has stopped meaning anything — tighten the rule.
6. **Run the collision check** against `design-motion.md`. A caption sitting under a lower third is the most common avoidable defect.
7. **Handle mixed scripts explicitly.** Hinglish and other mixed-script text needs a font stack with real fallback, and Devanagari needs more line height than Latin at the same size.

---

## Routing

| The ask | Go to |
|---|---|
| I don't know the tag — just show me everything | **[[skills/SUBTITLES/INDEX|skills/SUBTITLES/INDEX.md]]** — all 52 notes by family, plus a start-here path |
| What should captions look like? | `type/caption-style` |
| When does each cue appear? | `type/caption-timing` |
| Animate the captions | `type/caption-motion` |
| Highlight the active word | `type/caption-motion`, family `karaoke` |
| Which words to emphasise | `type/caption-style`, family `emphasis` |
| Captions clash with a graphic | this skill's collision check, plus `skills/MOTION/SKILL.md` |

```dataview
TABLE title, type, difficulty FROM #skill/subtitles SORT type
```

## Non-negotiables

- **Verbatim text.** Match the transcript. Correct only clear ASR errors, and log the correction.
- **Reading speed is a hard cap**, not a target. Over it, comprehension drops regardless of how good the styling is.
- **Sizes as a percentage of frame height.** The same design must survive 1080x1920 and 1920x1080.
- **Safe areas are real.** Platform UI covers the bottom of the frame; a caption behind it does not exist.
- **Ground specs in the HyperFrames caption model** in `_meta/execution-contract.md`. Do not invent styling hooks.
