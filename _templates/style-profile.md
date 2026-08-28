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

## Visual system

The style-level design language every graphic in this style is built from. Defined once here, referenced by every `design-motion.md`. Sizes are **% of frame height**, never points — a point size does not survive an aspect change. See `[[gfx-modular-type-scale]]`.

| | |
|---|---|
| Type scale ratio + steps | {{1.25 · 2.2 / 2.8 / 3.5 / 4.4 / 5.5 %H}} |
| Display / body face + weight | {{}} |
| Ground | {{hex}} |
| Ink | {{hex}} |
| Accent (exactly one) | {{hex}} |
| Contrast floor over footage | {{ratio, and the backing used to reach it — [[gfx-plate-and-scrim-ladder]]}} |
| Margin (% of frame width) | {{}} |
| Grid columns / gutter | {{}} |
| Stroke weight @1080w | {{px}} |
| Corner radius | {{px, and whether it scales with the element}} |
| Icon style + weight match | {{}} |

**Component vocabulary** — which of these the style actually uses, and its variant:

| Component | Used | Notes |
|---|---|---|
| Label / callout `[[gfx-label-callout-over-footage]]` | | |
| Lower third `[[gfx-lower-third-anatomy]]` | | |
| Stat card `[[gfx-stat-card-layout]]` | | |
| List card `[[gfx-list-card-enumeration]]` | | |
| Two-column comparison `[[gfx-comparison-two-column-card]]` | | |
| Quote card `[[gfx-quote-card]]` | | |

**Channel balance** — how much work graphics do versus captions in this style. Measure it; do not assume. See `[[gfx-three-channel-division-of-labour]]`.

| | |
|---|---|
| Graphic events per minute | {{}} |
| Beats carried by caption alone | {{%}} |
| Beats carrying a graphic that adds structure/quantity/relation | {{%}} |
| Observed prose duplication (caption and graphic saying the same words) | {{% — if this is high the reference is doing it badly; do not reproduce it}} |

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
