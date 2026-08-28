---
name: "{{PROJECT}} — subtitles"
description: Caption specification for {{PROJECT}}
type: design-doc
skill: subtitles
profile: "[[{{PROFILE_NAME}}]]"
depends_on: ["[[{{PROJECT}} — cuts]]", "[[{{PROJECT}} — motion]]"]
engine: hyperframes
status: draft
---

# Subtitles — {{PROJECT}}

> Designed last, because emphasis and position key off the cuts and the motion. Executed through the HyperFrames caption model — see `execution-contract.md` for what is actually stylable.

## Caption identity

| | |
|---|---|
| Mode | {{word-level / phrase-level / hybrid}} |
| Rule | `[[sub-…]]` |
| Typeface / weight | |
| Size (% of frame height) | |
| Colour / stroke / shadow | |
| Active-word treatment | |
| Background / plate | |
| Position + safe area | |
| Max chars per line | |
| Max lines | |
| Reading speed cap | {{cps}} |
| Language(s) | {{note script mixing if Hinglish}} |

## Timing model

| | |
|---|---|
| Source | {{transcript / forced alignment}} |
| Min cue duration | {{}} |
| Max cue duration | {{}} |
| Gap between cues | {{}} |
| Cut-boundary rule | {{does a cue break at a cut, or ride through it}} |
| Entrance / exit | `[[sub-…]]` |

## Cue sheet

| # | In | Out | Text | Lines | cps | Treatment |
|---|---|---|---|---|---|---|

## Emphasis map

Which words get lifted, and why. Over-emphasis reads as noise, so the rule matters more than the list.

| Timecode | Word / phrase | Treatment | Rule | Reason |
|---|---|---|---|---|

## Collision check

Captions must not fight motion. Cross-check against `design-motion.md`.

| Timecode | Caption position | Competing element | Resolution |
|---|---|---|---|

## Checks

- [ ] No cue exceeds the reading-speed cap
- [ ] No cue collides with a motion element or platform UI safe area
- [ ] Every cue's text matches the transcript verbatim (no silent rewrites)
- [ ] Mixed-script text renders with the right font fallback

## Open questions
