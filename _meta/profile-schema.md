---
name: profile-schema
description: Field-level contract for PROFILE.md — which fields must parse as numbers, which may stay prose, the cross-field invariants, and the exact violation messages. The profile stage's exit condition.
type: reference
---

# PROFILE.md — the checkable contract

The profile stage's exit condition was prose: *"every section has numbers, not adjectives."*
A human reads that correctly. A validator cannot, and an orchestrator asked to judge it will
pass `"fast cutting, punchy sound"` on a generous read — which is the exact failure the
condition exists to prevent.

This file makes it mechanical. `_templates/style-profile.md` defines the *shape*; this
defines what counts as **filled**.

## The one rule underneath all of it

**A field typed `numeric`, `range`, `percent` or `ratio` that contains no digit is a
violation.** Not a warning. That single check catches nearly every adjective-instead-of-
measurement failure, and it cannot be argued with.

## Field classes

| Class | Must satisfy | Example |
|---|---|---|
| `numeric` | at least one digit; parses to a number after unit stripping | `1.8s / 54f` → 1.8 |
| `range` | two numbers, `min ≤ max`, any of `–` `-` `to` as separator | `0.6–4.2s` |
| `percent` | a number 0–100 | `34%` |
| `ratio` | `n:1` or a decimal ≥ 1 | `4.5:1` |
| `rational` | `num`/`den` integer pair; a bare decimal is a violation | `fps_num: 30000, fps_den: 1001` |
| `hex` | `#RGB` or `#RRGGBB` | `#0E0E0C` |
| `enum` | member of a closed set | `high \| medium \| sparse` |
| `linklist` | ≥1 `[[id]]`, each resolving to a real note id or declared alias | `[[cut-j-audio-leads-picture]]` |
| `bool` | `yes` \| `no` | |
| `prose!` | **required** free text, ≥8 words, no template residue | the Rhythm rule |
| `prose?` | optional | Characteristic use |

`prose!` exists because some load-bearing knowledge genuinely is not a number — *"no shot
survives past 4s without a cut, a push-in, or a graphic entering"* is the most useful line
in a cut profile and it has one digit in it by accident. Do not force these numeric; do
enforce that they are answered.

## Required fields

Frontmatter:

| Field | Class | Notes |
|---|---|---|
| `name` | `prose!` | |
| `type` | `enum` | must be `profile` |
| `built` | date | ISO |
| `references[].file` | path | ≥1 entry, each must exist on disk |
| `references[].fps_num` / `fps_den` | `rational` | per file, never assumed — see `app-integration.md` |
| `confidence` | `enum` | `high` \| `medium` \| `sparse` |

Body — the load-bearing set. Anything not listed is `prose?` and does not block.

| Section | Field | Class | Blocking |
|---|---|---|---|
| Format facts | Aspect / resolution | `prose!` | ✅ |
| | Loudness target | `numeric` | ✅ |
| Cut profile | Median shot length | `numeric` | ✅ |
| | p90 shot length | `numeric` | ✅ |
| | Longest tolerated static hold | `numeric` | ✅ |
| | Cuts per minute | `numeric` | ✅ |
| | Dominant cut types | `linklist` | ✅ |
| | Dead-space policy | `prose!` | ✅ |
| | Rhythm rule | `prose!` | ✅ |
| | *(each row's)* Range observed | `range` | ⚠️ warn |
| | *(each row's)* Confidence | `enum` | ⚠️ warn |
| Motion profile | Motion vocabulary | `linklist` | ✅ |
| | Typical duration | `range` | ✅ |
| | Signature easing | `prose!` | ✅ |
| | Stagger | `numeric` | ✅ |
| | Density | `numeric` | ✅ |
| | Never does | `prose!` | ✅ |
| Sound profile | each layer → Present | `bool` | ✅ |
| | `sfx/diegetic` share | `percent` | ✅ |
| | `sfx/motion` share | `percent` | ✅ |
| | `sfx/aesthetic` share | `percent` | ✅ |
| Visual system | Type scale ratio + steps | `numeric` | ✅ |
| | Ground / Ink / Accent | `hex` | ✅ |
| | Contrast floor over footage | `ratio` | ✅ |
| | Margin | `percent` | ✅ |
| | Stroke weight @1080w | `numeric` | ✅ |
| Channel balance | Graphic events per minute | `numeric` | ✅ |
| | Beats carried by caption alone | `percent` | ✅ |
| | Observed prose duplication | `percent` | ✅ |
| Caption identity | Mode | `enum` | ✅ · `word-level` \| `phrase-level` \| `hybrid` |
| | Reading speed | `numeric` | ✅ · cps |
| | Max chars per line / lines | `numeric` | ✅ |
| | Emphasis rule | `prose!` | ✅ |
| | Motion | `linklist` | ✅ |

## Cross-field invariants

These catch the errors a per-field check cannot. Each has bitten a real document.

| # | Invariant | Why |
|---|---|---|
| X1 | zero `{{…}}` anywhere in the file | an unfilled template that parses is the worst outcome |
| X2 | `median ≤ p90 ≤ longest tolerated hold` | catches transposed columns |
| X3 | every value falls inside its own `Range observed` | catches copy-paste between rows |
| X4 | the three `sfx/*` shares sum to 100 ±2 | a balance that does not sum is not a balance |
| X5 | channel-balance percentages each ≤ 100 and caption-alone + graphic-bearing ≤ 100 | |
| X6 | exactly one `Accent` hex | `[[gfx-palette-ground-ink-accent]]` — the discipline is one accent |
| X7 | every `linklist` id resolves in `skills/*/rules/` or a declared `aliases:` | a profile citing a note that does not exist is unexecutable |
| X8 | no `fps` scalar anywhere; only `fps_num`/`fps_den` | `round(s × 29.97)` misplaces 622 of 18000 frames |
| X9 | `confidence: sparse` ⇒ **Evidence gaps** section is non-empty | sparse without saying where is not honest |
| X10 | `references[]` length ≥ 2 **or** `confidence: sparse` | one video is not a style, and must not claim to be |

X10 is the one to keep. A single-reference profile is legitimate — but it must declare
itself sparse, so downstream stages treat its numbers as priors rather than constraints.

## Violation messages

Emit the field path, the class, what was found, and what would satisfy it. The last part is
what makes the message actionable rather than an accusation.

```
PROFILE:cut.median_shot_length — expected numeric, found "fast". A number with a unit,
  e.g. "1.8s / 54f". Measure the shot-length distribution; do not characterise it.

PROFILE:motion.vocabulary — expected linklist, found "punchy entrances". At least one
  [[rule-id]] from skills/MOTION/rules/. Name the moves, do not describe them.

PROFILE:sound.style_mix — shares sum to 78, expected 100 ±2 (diegetic 30, motion 48,
  aesthetic 0). An unmeasured style is 0, not blank — say so explicitly.

PROFILE:X3 cut.p90_shot_length — value 4.2s sits outside its stated range 0.6–3.1s.
  One of the two is wrong.

PROFILE:X10 — 1 reference with confidence "high". One video is not a style. Either add
  references or set confidence: sparse.

PROFILE:X1 — 6 unfilled placeholders remain: visual_system.ground, caption.position, …
```

## Machine form

For a validator to consume directly rather than parsing the tables above.

```json
{
  "version": 1,
  "blocking": {
    "cut.median_shot_length":      "numeric",
    "cut.p90_shot_length":         "numeric",
    "cut.longest_static_hold":     "numeric",
    "cut.cuts_per_minute":         "numeric",
    "cut.dominant_types":          "linklist",
    "cut.dead_space_policy":       "prose!",
    "cut.rhythm_rule":             "prose!",
    "motion.vocabulary":           "linklist",
    "motion.typical_duration":     "range",
    "motion.signature_easing":     "prose!",
    "motion.stagger":              "numeric",
    "motion.density":              "numeric",
    "motion.never_does":           "prose!",
    "sound.style_mix.diegetic":    "percent",
    "sound.style_mix.motion":      "percent",
    "sound.style_mix.aesthetic":   "percent",
    "visual.type_scale":           "numeric",
    "visual.ground":               "hex",
    "visual.ink":                  "hex",
    "visual.accent":               "hex",
    "visual.contrast_floor":       "ratio",
    "visual.margin":               "percent",
    "visual.stroke_weight":        "numeric",
    "channel.graphic_per_minute":  "numeric",
    "channel.caption_alone_pct":   "percent",
    "channel.prose_duplication":   "percent",
    "caption.mode":                "enum:word-level|phrase-level|hybrid",
    "caption.reading_speed_cps":   "numeric",
    "caption.max_chars_per_line":  "numeric",
    "caption.emphasis_rule":       "prose!",
    "caption.motion":              "linklist",
    "format.aspect":               "prose!",
    "format.loudness_target":      "numeric"
  },
  "warn": {
    "cut.*.range_observed": "range",
    "cut.*.confidence":     "enum:high|medium|sparse"
  },
  "invariants": ["X1","X2","X3","X4","X5","X6","X7","X8","X9","X10"],
  "prose_min_words": 8,
  "percent_sum_tolerance": 2
}
```

## Required reads for the profile stage

Analogous to `timebase.md` for design. A profile stage that never opened these produced
plausible output by pattern-matching, not by measurement:

- `references/reference-breakdown.md` — the measurement procedure, and the rule that an
  unconfirmed technique is a hypothesis
- `_meta/tags.md` — the closed vocabulary every `linklist` id must belong to

## What this deliberately does not do

It does not check whether the numbers are **true**. A profile can satisfy every rule here
and still be wrong, because it measured three videos badly. Truth is caught by the
source⇄output toggle, the landmark check, and a human watching the first edit. This schema
only guarantees the profile is a **measurement** rather than an impression — which is the
precondition for being wrong in a diagnosable way.
