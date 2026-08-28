---
id: sfx-vibe-brief
title: The vibe is a decision, not a discovery — write it as a brief before you search
skill: sound-design
type: music
family: music-selection
tags: [skill/sound-design, type/music, family/music-selection, layer/music, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:03:05
    quote: "You don't figure out the vibe — you create the vibe."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:03:07
    quote: "As an editor, you're the one with that power, you get to decide the video's vibe or mood."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:03:36
    quote: "So the rule for this is really simple: wherever your own voice isn't there, using music with vocals works better. But where your own voice is there, putting a vocal track behind it can create a bit of a conflict."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:00
    quote: "Now if you just hunt for music randomly, you'll waste a ton of time."
research_refs:
  - https://www.holabrief.com/creative-brief/music-template
  - https://en.wikipedia.org/wiki/Temp_track
  - https://www.toolsforfilm.com/blog/how-to-work-with-a-composer
  - https://www.documentary.org/feature/minding-your-beats-and-cues-tips-working-composer
difficulty: low
detectable_from: transcript+video
---

# The vibe is a decision, not a discovery — write it as a brief before you search

## What it is
A reversal of the usual workflow. The mood of a video is not a property of the footage waiting to be identified by scrolling a music library; the editor **assigns** it, and the music is how the assignment is executed. That principle, and the psychology behind it, is [[sfx-music-sets-the-mood]]; **this note is the artefact that makes the principle executable** — the written brief. Practically, the search happens **after** a written decision, not instead of one: serious/mysterious or funky/fun, one line, committed to before a single track is auditioned. The reason this matters operationally is that every music library — Epidemic included — is searched by *facets*, and facets can only be filled in by someone who has already decided. Random scrolling is the failure mode the source names explicitly, and a written brief is what makes the search deterministic and repeatable across sections and across videos.

## When to use it
Once per video before any music is fetched, and again at every section boundary where the mood changes. It is also the correct artefact when two people (or two passes) must agree on music without listening together — a brief is comparable, a hunch is not. Write it before the edit is locked but after the script's arc is known, because the fields that matter most (arc position, whether your voice is present, pace) come from the script, not the footage. Skip it only for a video with no music at all — which is a decision too, and belongs in the same document.

## How to recognise it in a reference video
You are reverse-engineering the brief from the finished video. Every field below is observable:
- **Section the video by music.** Mark every point where the bed changes, stops, or starts. Those boundaries are the brief's rows. In competent work they coincide with narrative section boundaries; if the music changes mid-argument, there was no brief.
- **Vocals vs instrumental, per section.** The single most diagnostic field. Listen for a sung or rapped vocal line. The rule the source states — vocals where the presenter's voice is absent (montage, journey, outro), instrumental where it is present — is directly checkable, and a violation is audible as the two voices fighting.
- **BPM per section.** Tap it out or measure it: `aubiotempo -i bed.wav`. Then compare against the narration's delivery speed. High BPM under slow delivery (or the reverse) is the "inverted" error the source warns about.
- **Instrument identity.** Name the two or three dominant instruments per section: piano/strings, synth/arp, guitar/drums, plucks, brass. This is a real search facet on Epidemic (`featuredInstrumentSlugs`) and it is what makes two tracks of the same BPM and mood feel different.
- **Mood label.** Force yourself to pick one word per section from a closed set (epic, hopeful, tense, mysterious, funky, laid-back, dark, quirky, sentimental). If you cannot pick one, the section has no vibe and that is the finding.
- **Level.** Measure the bed under narration: the creator's own numbers are music at **−22 to −25 dB** against dialogue at **−3 to 0 dB**, dropping to **−30 dB** for loud rock/guitars. A bed measurably above −18 dB under speech is either a deliberate music-first section or a mix error.
- **Continuity.** Does one track run the whole video? That is the "no rest" failure the source names, and it is visible as a single unbroken bed on the audio track.
- **Cross-check the brief you inferred against the picture.** If the mood label you wrote from the music does not match the mood label you would write from the picture alone, you have found either a deliberate contrast (rare, powerful) or a mismatch (common, sloppy). Log which.

## Parameters

The brief itself is the parameter set. One row per section; every field maps to a real Epidemic search facet or to a mix number.

| Field | Default | Range / vocabulary | Notes |
|---|---|---|---|
| `section_id` | — | — | Must match the section ids in the storyboard. |
| `in` / `out` | — | seconds | Composition time. |
| `mood` | — | epic \| hopeful \| tense \| mysterious \| funky \| laid-back \| dark \| quirky \| sentimental | One word. Maps to `filter.moodSlugs`. |
| `intent` | — | free text, one clause | *Why* this mood here. The field that stops a later pass "improving" it. |
| `bpm_min` / `bpm_max` | 100 / 120 | 60–170 | The creator's personal default is **100–120 BPM** for fast delivery. Maps to `filter.bpm`. |
| `vocals` | `false` | true \| false | **`true` only where the presenter's voice is absent.** Maps to `filter.vocals`. |
| `instruments` | — | 1–3 slugs | e.g. `acoustic-guitar`, `electronic-drums`, `piano`. Maps to `filter.featuredInstrumentSlugs` (`matchType: ANY`). |
| `genre` | — | 0–2 slugs | Maps to `filter.taxonomySlugs` (genre / decade / world-country all live here). |
| `key` | — | e.g. `c-minor` | Only when matching an adjacent section's track. Maps to `filter.musicalKeys`. |
| `energy_arc` | flat | rise \| flat \| fall | Drives whether the section wants a track with a build. |
| `bed_level_db` | −23 | −20 to −25 (−30 for loud guitars) | Under narration. |
| `duck_method` | carve | carve \| volume-lane \| none | Carve against the `voiceover` group is the default answer for music-under-voice. |
| `stop_rule` | on-peak | on-peak \| on-beat \| fade | Where the section's music ends. Stopping on a waveform peak is smooth; stopping in a trough is heard as sudden. |
| `transition_to_next` | similar | similar \| riser-bridge \| hard-beat \| silence | `similar` = `SearchSimilarToRecording`; `riser-bridge` = stop, riser, next track from its first main beat. |
| `music_rest_pct` | ≥15% | 10–30% | Fraction of runtime with **no** bed. "Give the music rest." |
| `reference_track` | — | a URL/id | The temp-track slot. Name it, and name what about it you want — temp-track love is a real failure mode. |

## Reproduction prompt

```
Write the vibe brief BEFORE fetching any music. Do not open a music library
until this table exists.

1. Read the script/storyboard and split the video into MUSIC SECTIONS at
   narrative boundaries (not at footage boundaries). Typical long-form: 4-8
   sections plus at least one section with no music at all.

2. For each section, DECIDE and write, in this order - do not audition first:
     mood        one word from: epic, hopeful, tense, mysterious, funky,
                 laid-back, dark, quirky, sentimental
     intent      one clause: why this mood, here
     bpm range   match the narration's delivery speed in this section. Fast
                 talking -> high BPM, slow talking -> low BPM. Never invert
                 it. Default 100-120.
     vocals      TRUE only if the presenter's voice is absent for the whole
                 section (montage, journey, outro). Otherwise FALSE.
     instruments 1-3, named
     energy_arc  rise / flat / fall
     bed level   -23 dB default; -30 dB if the track is loud rock or guitars
     stop rule   where and how this section's music ends
     transition  how it hands over to the next section

3. Sanity-check the whole table before searching:
     - at least 15% of runtime has NO bed;
     - no two adjacent sections share the same mood AND the same bpm band
       (or the section boundary will be inaudible);
     - vocals is FALSE in every section where narration runs;
     - the mood sequence tells the same story as the script's arc - read the
       mood column alone and check it rises and falls where the script does.

4. ONLY NOW search, one query per section, built directly from the row. Fetch
   3 candidates per section, never 1.

5. Record the chosen track id, bpm and key back into the row. The brief is the
   artefact that survives the session; the audition is not.

ACCEPTANCE TEST: hand the mood column alone to someone who has not seen the
video and ask them to describe the video's emotional shape. It must match the
script's arc. Then check every FALSE/TRUE in the vocals column against the
narration track, frame-accurate at the section boundaries. Any section where
you cannot state the intent in one clause has no vibe decision in it and must
be re-decided, not re-auditioned.
```

## Execution spec

**Epidemic Sound MCP — the brief row *is* the query.** Every field above maps to a real filter on `SearchRecordings`, which is what makes the brief deterministic rather than decorative:

```
SearchRecordings({
  query:  { term: "tense mysterious underscore" },
  filter: {
    bpm:                     { min: 100, max: 120 },
    vocals:                  false,
    moodSlugs:               { matchType: "ANY", values: ["mysterious", "dark"] },
    featuredInstrumentSlugs: { matchType: "ANY", values: ["piano", "strings"] },
    taxonomySlugs:           { matchType: "ANY", values: ["cinematic"] },
    duration:                { min: 90000, max: 240000 }     // ms
  },
  first: 8,
  sort: { by: "RELEVANCE", order: "DESCENDING" }
})
```
Notes that matter: `duration` is in **milliseconds**; `bpm` comes back on every `Recording` so you can write the real value into the brief; `stems` (DRUMS / BASS / MELODY / INSTRUMENTS / CLEAN_VOCALS / VOCALS) are exposed, which is the escape hatch when a track is right but its vocal conflicts — take the instrumental stem instead of rejecting the track. For the `similar` transition rule use `SearchSimilarToRecording` on the outgoing track; for an externally-referenced temp track, resolve it first with `SearchExternalReferences` (SPOTIFY_TRACK) and then `SearchSimilarToRecording`. Then `DownloadRecording` into `.media/audio/bgm/`.

**HyperFrames — one `<audio>` clip per brief row**, at the root (so playback survives scene cuts in a modular project), on a high track index, in the `music` group, carved against the voice:

```html
<audio id="vo-s2" src=".media/audio/voice/s2.wav" data-audio-group="voiceover"
       data-start="128.0" data-track-index="10"></audio>

<audio id="bed-s2" src=".media/audio/bgm/tense-underscore.mp3"
       data-audio-group="music"
       data-start="126.4" data-duration="94.0" data-media-start="8.0"
       data-track-index="11" data-volume="0.07"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.2,&quot;v&quot;:1},{&quot;t&quot;:92.0,&quot;v&quot;:1},{&quot;t&quot;:94.0,&quot;v&quot;:0}]}]}"></audio>
```

Contract points that bind this:
- `data-volume="0.07"` is roughly **−23 dB** (20·log₁₀(0.07) ≈ −23.1). Convert the brief's dB to linear: `v = 10^(dB/20)`. −20 dB = 0.10, −25 dB = 0.056, −30 dB = 0.032.
- `data-media-start="8.0"` is how you *"ignore the track's warm-up and start straight from the main beat"* without cutting a file.
- The lane's `t` is **clip-local seconds**, and a lane **holds its first value backwards to the clip start** — hence the explicit `{"t":0,"v":0}`.
- **Carve, don't duck, for music under narration.** Settings live on the **bed**, never on a voice; `sources` must name a **group**, not a list of clip ids (`audio_carve_ungrouped_sources`); `data-fx-carve` is clip-only, never on an `<hf-audio-group>`. Default `strength` **0.25** ≈ a 6 dB dip in three bands. At 0.5 it starts being heard as an effect. Run `node <SKILL_DIR>/scripts/carve.mjs --comp index.html` — it needs `ffmpeg` on PATH and `@hyperframes/core` installed, and it refuses when it cannot tell which track is the bed. Never hand-write `fromCarve`.
- Keep the carve group **voices only** — a bed or an SFX clip inside `voiceover` poisons the next re-analysis silently.
- Do not also GSAP-tween `volume` on a track with a lane (`audio_volume_double_automation` — the lane wins); do not author `data-volume` on a track whose volume you tween (`audio_volume_tween_overrides_gain` — the tween is absolute).
- Every `<audio>` needs an `id` or it is never mixed → silent render. Two `<audio>` sharing a track index and overlapping raise `duplicate_audio_track` — give each section's bed its own index while they overlap.
- If the section wants a whole-bus treatment (several beds sharing one fader/chain), make `music` a real `<hf-audio-group>`; note a **bus's automation `t` is composition time**, not clip time.
- **Nothing validates the FX chain or the lanes.** Render refuses an unparseable chain outright; preview plays it dry. Verify by rendering and listening.

**ffmpeg — measurement, not creation.** Confirm the delivered bed level and the BPM you wrote in the brief:

```bash
aubiotempo -i bed.wav                                  # BPM; hopsize 512, bufsize 1024 by default
ffmpeg -i mix.wav -af ebur128=peak=true -f null -      # integrated loudness of the finished mix
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -   # pass 1, socials
```

**Remotion:** an `<Audio volume={f => …} />` per section driven by the same table; concept only.

## Pairs with
[[sfx-music-sets-the-mood]] · [[pace-bpm-matched-music-selection]] · [[sfx-music-audition-against-picture]] · [[struct-music-arc-to-narrative-arc]] · [[sfx-riser-to-music-drop-backtiming]] · [[pace-cut-on-the-beat]] · [[struct-stimulation-budget]] · [[pace-partial-pause-removal]]

## Failure modes
- **Searching before deciding.** Produces a track that is "nice" and a video with no emotional shape, and costs hours. Correction: the table exists before the library opens.
- **Vocal track under narration.** Two voices competing; the audience hears neither. Correction: `vocals: false` wherever the presenter speaks — or take the track's instrumental **stem**.
- **BPM inverted against delivery.** Slow talking over a 140 BPM track feels wrong in a way viewers cannot name and editors often miss. Correction: measure the section's words-per-minute and the track's BPM and check they move together.
- **One bed for the whole video.** No rest, no section boundaries, no contrast, and the music stops being information. Correction: ≥15% of runtime with no bed, and a change at every section.
- **Mood chosen from the footage.** The footage will always suggest the safest, most literal choice. Correction: choose from the script's *intent*, then let the music impose it.
- **Temp-track love.** The reference track becomes the requirement and nothing else is ever acceptable. Correction: record in the brief *what about it* you want — the BPM, the instrument, the arc — and search those facets, not the track.
- **Carve strength pushed up to fix a level problem.** If the bed sounds notched rather than simply quieter under the voice, strength is too high. Correction: lower to 0.25 and fix the level with `data-volume`.
- **Known gap:** the mood vocabulary above is a closed set chosen for this library, not Epidemic's own taxonomy; `moodSlugs` values must be real slugs from the catalog, so a first query should be run loosely and the returned `tags` (with their `dimension`) read back to learn the exact slugs before the brief is finalised. Record the slugs you used in the brief so the search is repeatable.
