---
name: "{{PROJECT}} — motion"
description: Motion design specification for {{PROJECT}}
type: design-doc
skill: motion
profile: "[[{{PROFILE_NAME}}]]"
depends_on: "[[{{PROJECT}} — cuts]]"
fps: {{30}}
engine: hyperframes
status: draft
---

# Motion — {{PROJECT}}

> Every element gets a full spec. "Slides in from the left" is not a spec; `translateX -120px → 0 over 14f on cubic-bezier(0.16,1,0.3,1)` is.

## Motion events

| # | Timecode | Element | Rule | Enter | Hold | Exit | Layer |
|---|---|---|---|---|---|---|---|
| 1 | 00:00:02:12 | {{lower third}} | `[[motion-…]]` | {{14f}} | {{90f}} | {{10f}} | {{2}} |

## Specs

One block per motion event. Copy the **Reproduction prompt** from the cited rule note and fill in every placeholder — no `{{}}` may survive into the build.

### M1 — {{element}} @ {{00:00:02:12}}

- **Rule:** `[[motion-…]]`
- **Trigger:** {{the cut, word or beat this keys off}}
- **Property track:**

  | Property | From | To | Start | Duration | Easing |
  |---|---|---|---|---|---|
  | `translateY` | `24px` | `0` | `0f` | `14f` | `cubic-bezier(0.16,1,0.3,1)` |
  | `opacity` | `0` | `1` | `0f` | `8f` | `linear` |

- **Stagger:** {{3f across children}}
- **Z-order / layer:** {{}}
- **Paired sound:** `[[sfx-…]]` at {{offset}} — must match `design-sound.md` row {{S#}}
- **HyperFrames markup:**

  ```html
  {{the actual data attributes, grounded in _meta/execution-contract.md}}
  ```

- **Acceptance test:** {{what to look at in the rendered frame range to confirm it worked}}

## Transitions

| # | Timecode | From → To | Transition | Rule | Frames | Paired sound |
|---|---|---|---|---|---|---|

## Density check

| Metric | Profile target | This design | Pass |
|---|---|---|---|
| Motion events per minute | | | |
| Longest gap without motion | | | |

## Constraints honoured

- [ ] No composition loads a library from a CDN (`cdn.jsdelivr.net` is blocked — see `execution-contract.md`)
- [ ] Every duration is a frame count at the stated fps
- [ ] Every element sits inside the safe area

## Open questions
