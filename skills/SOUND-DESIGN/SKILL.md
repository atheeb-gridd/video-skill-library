---
name: sound-design
description: Decide which sound belongs at a moment, then actually fetch it. Covers the three styles of sound effect (diegetic, motion, aesthetic), the layers-of-sound framework, music and mixing, executed through Epidemic Sound. Use for SFX, music selection, ambience, mixing, or when the user names the sound design skill.
type: skill-router
library: skills/SOUND-DESIGN/rules/
templates: ["_templates/design-sound.md", "_templates/style-profile.md"]
pipeline: "_meta/pipeline.md"
engines: [epidemic, hyperframes, ffmpeg]
source_videos: ["assets/videos/sfx kt 1.mp4", "assets/videos/sfx kt 2.mp4"]
---

# Sound design

**Browse instead of query:** [[skills/SOUND-DESIGN/INDEX|skills/SOUND-DESIGN/INDEX.md]] lists all 137 notes grouped by style then by family — music, mix and craft in their own sections — and carries the ten-family catalogue in full. Use it when you do not already know the tag; routing below is tag-driven, and a mistagged note is invisible to it.

Sound is roughly half of what a viewer experiences and the first thing skipped when time runs short. This library exists so it is never the thing skipped: it turns "this moment needs a whoosh" into a specific Epidemic query, a frame offset, and a gain value.

Runs **after** cuts and motion — motion sound effects are timed off motion events.

---

## The two frameworks this library is built on

### The three styles — *why* a sound is there

Every sound effect is exactly one of these, and the style decides how it is chosen and mixed.

| Style | Exists to | Sits in the mix | Chosen by |
|---|---|---|---|
| `sfx/diegetic` | Sell that the world is **real** — it is a sound the scene would actually make. Doors, keyboards, footsteps, traffic, cloth. | Sits *under* the picture, at a believable level. Wrong when it draws attention. | Physical plausibility. What would this object actually sound like? |
| `sfx/motion` | Sell the **movement** — bound to something travelling across or into frame. Whooshes on transitions, swishes on text entrances, impacts on slams. | Sits *with* the picture and usually **leads it by a few frames**. | The movement's speed, weight and direction. |
| `sfx/aesthetic` | Sell the **feeling** — no physical or visual referent at all. Risers, drones, tonal stings, textures, braams. | Sits *around* the picture, often long and low. | Emotional intent and where you are in the structure. |

Diagnostic value: a video that feels flat usually has motion effects and no aesthetic layer. A video that feels cheap usually has aesthetic effects and no diegetic layer. A video that feels cluttered usually has motion effects on things that are not moving.

### The five layers — *where* a sound sits

`layer/dialogue` → `layer/ambience` → `layer/music` → `layer/sfx` → `layer/design`

Build in that order and mix in that order. Dialogue is the floor: if it is bad, no amount of sound design rescues the video, so fix it before adding anything.

---

## Mode A — ANALYSE a reference video

**Produces:** `_profiles/<name>/01-observed-sound.md` → the sound sections of `PROFILE.md`.

1. **Split the audio and look at it**, don't just listen:
   ```bash
   ffmpeg -i "<video>" -vn -ac 2 -ar 48000 /tmp/ref.wav
   ffmpeg -i /tmp/ref.wav -af astats=metadata=1:reset=30 -f null - 2>&1 | grep -E 'RMS|Peak'
   ```
   A spectrogram makes the layers visible — risers show as rising sweeps, whooshes as short broadband bursts, music as a steady bed.
2. **Log every audible effect** with timecode, style, layer, and its relationship to the picture (lead/on/trail, in frames).
3. **Measure the balance.** Count effects by style and compute each share. This ratio *is* the creator's sonic identity — reproduce it, not just the individual sounds.
4. **Measure density** — effects per minute — and the levels: music under dialogue in dB, whether ducking is used, programme loudness.
5. **Build the palette.** Recurring sounds get a name and a tested Epidemic query so the identity is reachable next time.

## Mode B — DESIGN a new video

**Produces:** `_projects/<name>/design/design-sound.md` from `_templates/design-sound.md`.

1. **Read `design-cuts.md` and `design-motion.md`.** Every motion event that calls for a paired sound must get a row here — that cross-check is a required gate.
2. **Layer by layer, bottom up.** Dialogue treatment, then ambience beds, then music with its energy arc against the structure beats, then effects, then design.
3. **Classify before choosing.** Decide the style first (why is this sound here?), then pick within it. This is what stops a library of whooshes from being sprayed over a video.
4. **Write the fetch list.** Every row gets the exact Epidemic query from its rule note's Execution spec, plus filters. Use the note's tested query rather than improvising — recording it is the whole point of the note.
5. **Fetch before building.** Resolve every asset to a local file first. A missing sound discovered mid-render is a wasted render.
6. **Check the balance** against the profile's style ratio, then run the mix checks.

---

## Routing

| The ask | Go to |
|---|---|
| I don't know the tag — just show me everything | **[[skills/SOUND-DESIGN/INDEX|skills/SOUND-DESIGN/INDEX.md]]** — all 137 notes by style and family, the ten-family catalogue, plus a start-here path |
| This transition needs a sound | `sfx/motion` |
| This scene feels fake | `sfx/diegetic` |
| Build tension into this moment | `sfx/aesthetic` |
| Pick music | `type/music` |
| Dialogue is muddy / levels are wrong | `type/mix`, `layer/dialogue` |
| What sound goes with this animation? | `skills/MOTION/rules/` for the motion, then `sfx/motion` here |
| I don't know what this sound is called | [[sfx-ten-family-catalogue]] — the ten named families, then the family's own note |
| Two videos say "three types of sound" and disagree | [[sfx-two-taxonomies-of-sound]] |
| Where do I start on the music for a whole video? | [[sfx-music-ten-point-framework]] |
| How do I write the Epidemic query? | [[sfx-epidemic-facet-query]] — the six real facets |
| The bed is fighting the voice | [[sfx-ducking-keyframed-dip]], then [[sfx-layer-volume-targets]] |

```dataview
TABLE title, family, difficulty FROM #skill/sound-design SORT file.frontmatter.tags
```

## Fetching from Epidemic

The MCP tools are `SearchSoundEffects`, `DownloadSoundEffect`, `SearchRecordings`, `DownloadRecording`, `SearchSimilarToSoundEffect`.

- **Search by what the sound *does*, not only what it is.** "whoosh fast transition light" beats "whoosh".
- **`SearchSimilarToSoundEffect` is the identity tool.** Once one asset matches a profile's palette, similarity search keeps the rest of the video coherent.
- **Record what actually worked.** When a query returns the right asset, write it back into the rule note's Execution spec. The library should get more reliable every project.
- Effects are cheap to audition and expensive to guess at — pull three candidates, not one.
- **Music queries are built from the six real facets** — `Moods | Genres | Duration | BPM | Vocals | Key`, read directly off the Epidemic UI in the reference set. Free text alone is a relevance request; a facet is a constraint. `vocals: false` under narration, always. See [[sfx-epidemic-facet-query]].
- **The six facets are music-only.** `SearchSoundEffects` has no mood, BPM, vocals or key — `duration` (milliseconds) carries the filtering there.

## Non-negotiables

- **Every effect is classified** by one of the three styles. An unclassified effect is an unjustified effect.
- **Offsets in frames, gains in dB relative to dialogue.** Not "loud", not "subtle".
- **Motion sound leads picture.** Almost always by a few frames; an impact landing late reads as broken.
- **Dialogue wins.** If dialogue is not fully intelligible with every layer at level, the mix is wrong regardless of how good the design is.
