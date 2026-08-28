---
name: "{{PROFILE_NAME}}"
description: Style profile derived from {{N}} reference video(s)
type: profile
built: "{{YYYY-MM-DD}}"
references:
  - file: "{{path}}"
    duration: "{{MM:SS}}"
    fps: {{30}}
confidence: {{high|medium|sparse}}
---

# Style profile — {{PROFILE_NAME}}

> One paragraph: what this style *feels* like to watch, and the single mechanism that produces that feeling. Written for a human, so a reviewer can sanity-check the numbers below against their own impression.

## Format facts

| | |
|---|---|
| Aspect / resolution | {{1920x1080}} |
| fps | {{30}} |
| Median duration | {{MM:SS}} |
| Loudness target | {{-14 LUFS}} |

## Cut profile

| Metric | Value | Range observed | Confidence |
|---|---|---|---|
| Median shot length | {{1.8s / 54f}} | {{0.6–4.2s}} | {{high}} |
| p90 shot length | {{4.2s}} | | |
| Longest tolerated static hold | {{7s}} | | |
| Cuts per minute | {{22}} | | |
| Dominant cut types | `[[cut-…]]`, `[[cut-…]]` | | |
| Dead-space policy | {{e.g. all pauses >250ms removed}} | | |

**Rhythm rule:** {{the one sentence that governs pacing — e.g. "no shot survives past 4s without either a cut, a push-in, or a graphic entering"}}

## Motion profile

| | |
|---|---|
| Motion vocabulary | `[[motion-…]]`, `[[motion-…]]`, `[[motion-…]]` |
| Default entrance | {{spec}} |
| Default exit | {{spec}} |
| Signature easing | {{cubic-bezier(…)}} |
| Typical duration | {{12–18f}} |
| Stagger | {{3f}} |
| Density | {{n motion events per minute}} |
| Never does | {{the negative constraints — as diagnostic as the positive ones}} |

## Sound profile

| Layer | Present | Treatment |
|---|---|---|
| `layer/dialogue` | {{yes}} | {{eq/comp notes, target dB}} |
| `layer/ambience` | | |
| `layer/music` | | {{genre, energy, dB under dialogue}} |
| `layer/sfx` | | {{density per minute}} |
| `layer/design` | | |

**Style mix** — how the three sound-effect styles are balanced:

| Style | Share | Characteristic use |
|---|---|---|
| `sfx/diegetic` | {{%}} | |
| `sfx/motion` | {{%}} | |
| `sfx/aesthetic` | {{%}} | |

**Palette:** the recurring sounds, with their Epidemic queries, so the same sonic identity is reachable next time.

## Caption identity

| | |
|---|---|
| Mode | {{word-level / phrase-level / hybrid}} |
| Position / safe area | {{}} |
| Typeface, weight, size | {{}} |
| Colour + active-word treatment | {{}} |
| Max chars per line / lines | {{}} |
| Reading speed | {{cps}} |
| Emphasis rule | {{what gets highlighted, and why}} |
| Motion | `[[sub-…]]` |

## Evidence gaps

Anything asserted on thin evidence, so review starts here rather than discovering it in a render.
