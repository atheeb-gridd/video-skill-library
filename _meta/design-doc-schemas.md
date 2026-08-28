---
name: design-doc-schemas
description: Checkable exit conditions for design-motion, design-sound and design-subtitles — the same treatment profile-schema.md gives PROFILE.md. Plus the REQUIRED_READS map for every stage.
type: reference
---

# Design documents — the checkable contracts

`assertDesignComplete` already gates `design-cuts.md`: no placeholders, non-empty keep list,
duration agreeing with its keeps. The other three documents have no such gate, which means
slices 3–5 would each land with a prose exit condition and the same failure mode
`profile-schema.md` was written to close.

Field classes and violation-message style are as defined in `profile-schema.md`. This file
only adds the per-document field sets and invariants.

---

## `design-motion.md`

### Per motion event — all blocking

| Field | Class | Notes |
|---|---|---|
| `outTc` | `numeric` | **output** frames. Source timecode here is the bug `timebase.md` exists to prevent |
| `component` | `linklist` | must resolve into `skills/MOTION/rules/`, normally a `gfx-` note |
| `rule` | `linklist` | the motion note governing how it moves |
| `enter` / `hold` / `exit` | `numeric` | frames |
| `layer` | `numeric` | integer; z-order is explicit or it is a bug |
| `easing` | `prose!` | a 4-number `cubic-bezier(...)` or a curve named in `execution-contract.md` |
| `trigger` | `prose!` | the cut, word or beat it keys off |
| `channel_justification` | `prose!` | what this carries that the caption does not |
| `acceptance_test` | `prose!` | the frame range to inspect and what must be true in it |
| `box` | `numeric4?` | **optional.** `x,y,w,h` as percentages of frame, the screen area the event occupies. Optional because most motion notes describe *how* a thing moves, not *where* it sits — but C6 cannot be enforced without it (see below) |

Property track rows each need `property`, `from`, `to`, `start`, `duration`, `easing` — all
present, `duration ≥ 1`.

### Invariants

| # | Rule | Why |
|---|---|---|
| M1 | `outTc + enter + hold + exit ≤ outputDuration` | an event running past the end |
| M2 | every `easing` resolves in `execution-contract.md` §3 | invented curves fail at render, not at review |
| M3 | no composition references a CDN | blocked in some environments; inlining is the convention |
| M4 | events-per-minute within profile density ±25% | drift from the learned style |
| M5 | `channel_justification` must not match `/shows? the (words|text|caption)/i` | that is prose duplication wearing a justification — `[[gfx-three-channel-division-of-labour]]` |
| M6 | every event whose rule calls for a paired sound appears in `design-sound.md` at the matching offset | the commonest cross-document break |
| M7 | overlapping events on the same `layer` must not overlap in time | silent z-fighting |

---

## `design-sound.md`

### Per cue — all blocking

| Field | Class | Notes |
|---|---|---|
| `outTc` | `numeric` | output frames |
| `style` | `enum` | **exactly one** of `sfx/diegetic` · `sfx/motion` · `sfx/aesthetic` |
| `layer` | `enum` | one of the five `layer/*` |
| `rule` | `linklist` | into `skills/SOUND-DESIGN/rules/` |
| `offset` | `numeric` | signed frames relative to the visual event; negative = leads |
| `gainDb` | `numeric` | relative to dialogue; normally negative |
| `query` | `prose!` | the Epidemic query. Empty means unfetchable |
| `facets` | `prose?` | Moods / Genres / Duration / BPM / Vocals / Key |
| `asset` | path \| `null` | `null` before fetch; non-null before build |

### Invariants

| # | Rule | Why |
|---|---|---|
| S1 | style shares within the profile's balance ±10 pts | the balance *is* the sonic identity |
| S2 | `type/sfx` cues carry exactly one `sfx/*`; process/music/mix cues carry none | `_meta/tags.md`, as amended |
| S3 | no two `sfx/motion` cues within 6 frames | they fight and read as a smear |
| S4 | dialogue layer present with a stated target | `−3 to 0 dB`, confirmed twice on screen |
| S5 | every cue has a non-empty `query` **or** a resolved `asset` | otherwise the fetch list is a wish |
| S6 | before `build`, zero `asset: null` | a missing sound found mid-render is a wasted render |
| S7 | programme loudness target present | |
| S8 | every `design-motion.md` M6 pairing has its cue here | the other half of M6 |

---

## `design-subtitles.md`

### Identity block — all blocking

`mode` (`enum`: word-level / phrase-level / hybrid) · `typeface` · `weight` ·
`size_pct_height` (`percent`) · `colour` (`hex`) · `stroke_or_backing` ·
`position_pct_from_bottom` (`percent`) · `max_chars_per_line` (`numeric`) ·
`max_lines` (`numeric`) · `reading_speed_cps` (`numeric`) · `emphasis_rule` (`prose!`)

### Per cue

`outIn` / `outOut` (`numeric`, frames) · `text` (`prose!`) · `cps` (`numeric`, computed) ·
`emphasis` (index list, may be empty)

### Invariants

| # | Rule | Why |
|---|---|---|
| C1 | every cue's `cps ≤ reading_speed_cps` | a hard cap, not a target |
| C2 | `size_pct_height` and `position_pct_from_bottom` are percentages, never points | a point size does not survive an aspect change |
| C3 | no cue overlaps a platform UI safe band | a caption behind the UI does not exist |
| C4 | concatenated `text` matches the re-timed transcript verbatim, modulo logged ASR corrections | silent rewrites are a correctness bug |
| C5 | emphasised words ≤ 15% of total | above that, emphasis means nothing |
| C6 | no cue collides in time **and** space with a `design-motion.md` event | the commonest avoidable defect |
| C6a | an event sharing a caption's time window with **no `box`** is *reported*, not failed | space is unknown, so a fail would be a guess. The report is the prompt to add a `box` |
| C7 | `outIn < outOut`, cues non-overlapping and ascending | |
| C8 | cues derive from the **re-timed** transcript, not the source one | the two-clock rule, at the caption layer |

C4 is the one to implement first — it is cheap (a diff) and it catches the failure where the
model paraphrases the speaker into something tidier.

---

## `REQUIRED_READS` — the full map

Each stage must demonstrably have read its contract. A stage that skipped it produces
plausible output by pattern-matching rather than by measurement, and the two are
indistinguishable downstream.

```ts
export const REQUIRED_READS: Partial<Record<Stage, string[]>> = {
  profile: [
    'references/reference-breakdown.md',   // the measurement procedure
    '_meta/tags.md',                       // vocabulary every linklist must belong to
  ],
  ingest: [
    '_meta/source-media.md',               // fps is per-file and never assumed
  ],
  design: [
    'references/timebase.md',              // the two clocks
    '_meta/execution-contract.md',         // what can actually run
  ],
  build: [
    'references/build-and-render.md',      // order of operations; render is not the inner loop
    '_meta/execution-contract.md',         // §7A/§7B verified filters
  ],
}
```

The `design` stage runs four passes. If the orchestrator splits them into separate queries —
which it should, for connector control — then each pass gets its own list: cuts and motion
take `timebase.md`; sound adds `references/sound-design-pass.md`; subtitles adds
`references/subtitle-spec.md`.

---

## Ordering note

These schemas are written so a slice can land without its predecessor being *validated in
production* — but not without being *built*. M6/S8 and C6 are cross-document invariants, so
the sound gate cannot be honestly implemented before motion emits its pairings, and the
subtitle collision check needs real motion events. Build in the pipeline's own order:
motion, then sound, then subtitles, then build.

## C6 needs a field motion did not have

C6 says *time **and** space*, and the motion schema originally carried no position of any kind — so an implementation
had two bad options: fail every time-overlap (false positives on events nowhere near the caption band), or drop the
space half (and stop catching the defect). `box` above is the resolution, and it is **optional on purpose**: most motion
notes govern movement, not placement, and forcing a position into every event would invite invented numbers, which is
worse than a missing one.

So C6 has two behaviours, and both must be implemented:

- **`box` present on the event** → real time-and-space check. Overlap in both dimensions is a **failure**.
- **`box` absent** → time overlap alone is a **report**, naming the event and the cue, and the design document is not
  blocked. Silence here would be wrong too: the reader needs to know a collision *may* exist.

An event that keeps getting reported is the signal to give it a `box`, not to weaken C6.
