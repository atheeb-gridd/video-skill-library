---
name: tag-taxonomy
description: The closed tag vocabulary for the Video Editing vault. Every note tag must come from here.
type: reference
---

# Tag taxonomy

Tags are lowercase, slash-separated, and **closed** — a tag outside this list is a bug, not a new idea. Obsidian's tag pane renders these as a tree, so the namespace prefix is doing real work.

## `skill/` — which library owns the note

| Tag | Library |
|---|---|
| `skill/editing` | `skills/EDITING/rules/` — how to reproduce a cut |
| `skill/motion` | `skills/MOTION/rules/` — how to reproduce a motion |
| `skill/sound-design` | `skills/SOUND-DESIGN/rules/` — which sound, and how to fetch it |
| `skill/subtitles` | `skills/SUBTITLES/rules/` — caption design and timing |

A note carries exactly one `skill/` tag. Cross-skill relationships are expressed with `[\[wikilinks\]]` in **Pairs with**, not with a second skill tag.

## `type/` — what kind of move it is

`cut` · `pacing` · `structure` · `transition` · `retention` · `motion` · `graphic` · `type-motion` · `camera` · `sfx` · `music` · `mix` · `caption-style` · `caption-timing` · `caption-motion`

## `family/` — the grouping slug

Free-form but reused: `family/audio-led`, `family/match-cut`, `family/whip-pan`, `family/riser`, `family/kinetic-type`. Coin a new family only when three or more notes will share it.

## `engine/` — what actually executes it

| Tag | Meaning |
|---|---|
| `engine/hyperframes` | Expressible as a HyperFrames composition, data attributes or transition |
| `engine/ffmpeg` | A raw media operation — trim, concat, speed, audio slip, loudness |
| `engine/epidemic` | Requires an asset fetched from Epidemic Sound |
| `engine/remotion` | Has a documented Remotion equivalent |

Multiple `engine/` tags are normal and useful — they answer "can this stack actually do it today?"

## `sfx/` — the three styles (sound notes only)

The creator's own taxonomy:

| Tag | What it is |
|---|---|
| `sfx/diegetic` | Sound that exists *in the world of the shot* — a door, a keyboard, footsteps, traffic. Sells realism. |
| `sfx/motion` | Sound bound to *movement on screen* — whooshes on transitions, swishes on a text entrance, impacts on a slam. Sells the animation. |
| `sfx/aesthetic` | Sound that exists only for *feel* — risers, drones, tonal stings, textures. Sells the mood. |

### Which notes carry a style

The style describes **a sound**, so only a note that is *about* a sound carries one:

| Note is about | Styles it carries |
|---|---|
| A **specific sound or family of sounds** — a door, a whoosh, a riser, a heartbeat, an impact, an ambient bed | **Exactly one.** Pick the one the sound is *for*. A sound that could be argued into two is a sound whose job has not been decided yet. |
| **Process** — how to name, search, source, license, audition, vary, place or quality-gate a sound | **None.** These are style-independent by nature: the naming discipline is the same whether the sound is a door or a riser. |
| **Classification** — the taxonomy documents themselves, which explain the three styles or reconcile them against another scheme | **None.** A note that defines the vocabulary is not written in it. |

The old rule read *"every sound-effect note is exactly one of these"* and was false against fifteen good notes — two classification notes and thirteen process notes. The notes were right and the rule was wrong; this is the corrected rule. `type/sfx` therefore does **not** imply a style tag. What implies a style tag is describing a sound.

The mechanical check is: **a `type/sfx` note carries either exactly one `sfx/` tag or none, never two or three.** Zero means process or classification — and `skills/SOUND-DESIGN/INDEX.md` already files exactly those notes under *Craft and workflow*, so the index and the taxonomy now agree.

## `layer/` — the layers-of-sound framework (sound notes only)

`layer/dialogue` · `layer/ambience` · `layer/music` · `layer/sfx` · `layer/design`

## `source/` — provenance

| Tag | Source |
|---|---|
| `source/editing-kt` | `assets/videos/editing kt.mp4` |
| `source/editing-kt-2` | `assets/videos/editing kt 2.mp4` |
| `source/editing-kt-3` | `assets/videos/editing kt 3.mp4` |
| `source/sfx-kt-1` | `assets/videos/sfx kt 1.mp4` |
| `source/sfx-kt-2` | `assets/videos/sfx kt 2.mp4` |
| `source/hyperframes` | Mined from the HyperFrames repo |
| `source/research` | Added from web research, not present in the KT videos |

A note usually carries both a video source tag and `source/research`.

## `difficulty/`

`difficulty/low` · `difficulty/medium` · `difficulty/high` — how likely an unattended agent is to get it right first try.

## Useful queries

```dataview
TABLE title, type, difficulty FROM #skill/motion AND #engine/hyperframes SORT type
```

```dataview
TABLE title, family FROM #sfx/motion SORT family
```
