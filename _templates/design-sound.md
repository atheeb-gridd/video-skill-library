---
name: "{{PROJECT}} — sound"
description: Sound design specification and asset fetch list for {{PROJECT}}
type: design-doc
skill: sound-design
profile: "[[{{PROFILE_NAME}}]]"
depends_on: ["[[{{PROJECT}} — cuts]]", "[[{{PROJECT}} — motion]]"]
fps: {{30}}
loudness_target: "{{-14 LUFS}}"
status: draft
---

# Sound — {{PROJECT}}

> Organised by the layers-of-sound framework, and every effect is classified by one of the three styles: `sfx/diegetic`, `sfx/motion`, `sfx/aesthetic`. The style determines *why* the sound is there, which determines how it is mixed.

## Layer plan

| Layer | Present | Bed / treatment | Target dB rel. dialogue |
|---|---|---|---|
| `layer/dialogue` | | | `0` |
| `layer/ambience` | | | {{-24}} |
| `layer/music` | | | {{-18, ducking to -24}} |
| `layer/sfx` | | | {{-12}} |
| `layer/design` | | | {{-14}} |

## Sound events

`Offset` is frames relative to the visual event — negative means the sound leads the picture, which is usually what you want for an impact.

| # | Timecode | Sound | Style | Layer | Rule | Offset | Gain | Duck |
|---|---|---|---|---|---|---|---|---|
| S1 | 00:00:02:12 | {{whoosh}} | `sfx/motion` | `layer/sfx` | `[[sfx-…]]` | {{-3f}} | {{-12dB}} | {{no}} |

## Fetch list

Resolve every asset **before** building. A missing file found mid-render is a wasted render.

| # | Asset role | Epidemic query | Filters | Chosen file | Status |
|---|---|---|---|---|---|
| S1 | {{transition whoosh}} | `{{exact query terms}}` | {{duration, mood, tempo}} | | ☐ |

Query construction lives in each rule note's **Execution spec**. Prefer the note's tested query over improvising — that is the entire reason the note records it.

## Style balance

| Style | Count | Share | Profile target |
|---|---|---|---|
| `sfx/diegetic` | | | |
| `sfx/motion` | | | |
| `sfx/aesthetic` | | | |

Drifting from the profile's balance is the fastest way to lose a creator's sonic identity, even with individually good sounds.

## Music

| | |
|---|---|
| Track | |
| Epidemic query | |
| Energy arc | {{where it lifts and drops, against the structure beats}} |
| Edit points | {{where the track is cut to hit structure}} |
| Ducking rule | |

## Mix checks

- [ ] Dialogue intelligible with every layer at full level
- [ ] No two `sfx/motion` events within {{6f}} of each other fighting
- [ ] Programme loudness at target, true peak below {{-1 dBTP}}
- [ ] Every motion event in `design-motion.md` that calls for a paired sound has one here

## Open questions
