---
name: "{{PROJECT}} — cuts"
description: Edit decision list for {{PROJECT}}
type: design-doc
skill: editing
profile: "[[{{PROFILE_NAME}}]]"
source_media: "{{path}}"
fps: {{30}}
target_duration: "{{MM:SS}}"
status: draft
---

# Cuts — {{PROJECT}}

> Cuts are designed first: they define the timeline that motion, sound and captions attach to. Every row cites the rule note that justifies it.

## Structure

The macro shape before the micro cuts. If the structure is wrong, no amount of good cutting saves it.

| # | Beat | In | Out | Purpose | Rule |
|---|---|---|---|---|---|
| 1 | Hook | 00:00:00 | 00:00:0{{7}} | {{the promise made}} | `[[struct-…]]` |
| 2 | | | | | |

## Edit decision list

`In`/`Out` are source timecodes; `Frames` is the cut's own duration where it has one (a hard cut is 0). `Slip` is audio offset relative to picture, negative meaning audio leads.

| # | Timecode | Cut type | Rule | In | Out | Frames | Slip | Motivation |
|---|---|---|---|---|---|---|---|---|
| 1 | 00:00:00:00 | hard | `[[cut-straight-hard-cut]]` | | | 0 | 0 | {{why here}} |
| 2 | | | | | | | | |

## Pacing check

| Metric | Profile target | This edit | Pass |
|---|---|---|---|
| Median shot length | | | |
| Longest static hold | | | |
| Cuts per minute | | | |

## Dead space removed

| Source in | Source out | Duration | Reason |
|---|---|---|---|

## Retention devices

| Timecode | Device | Rule | Note |
|---|---|---|---|

## Open questions

Decisions that need a human. Do not silently pick and move on.
