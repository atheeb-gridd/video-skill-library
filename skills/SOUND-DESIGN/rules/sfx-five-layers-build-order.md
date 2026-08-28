---
id: sfx-five-layers-build-order
title: The five layers of sound as a build order
skill: sound-design
type: mix
family: layers
tags: [skill/sound-design, type/mix, family/layers, engine/hyperframes, engine/epidemic, engine/ffmpeg, sfx/diegetic, layer/dialogue, layer/ambience, layer/music, layer/sfx, layer/design, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:00:20
    quote: "But before that, to do sound design you really need to understand the five layers of sound."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:00:26
    quote: "First of all, if this itself is bad, then no amount of sound design is going to make a difference."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:03:24
    quote: "Now this doesn't mean that you have to do all 5 layers every single time. In my own YouTube videos I only use 2 or 3 of these layers."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:08:08
    quote: "Dialogue should be at 0 to -3 decibels, music should be at -20 to -25 decibels, and sound effects should be at -12 to -15 decibels."
research_refs:
  - https://en.wikipedia.org/wiki/Stem_(audio)
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
difficulty: medium
detectable_from: audio
---

# The five layers of sound as a build order

## What it is
Every video's audio decomposes into five stacked layers, and the order they are taught in is the order they are built in: **1 dialogue/voiceover → 2 ambience → 3 foley → 4 sound effects → 5 music**. Layer 1 is the floor — if the voice is bad, nothing above it rescues the video, so it is fixed before anything is added. The layers are not a checklist to complete; the source is explicit that his own videos use only two or three of them. What the framework buys is *diagnosis*: when a video sounds wrong, you name the missing or over-loud layer instead of guessing.

The industry equivalent is the DME stem convention — dialogue, music and effects delivered as separate submixes so any one can be replaced or re-levelled downstream. This library uses the five-layer split as the authoring model and DME as the delivery model: layers 2, 3 and 4 collapse into the E stem.

## When to use it
At the start of every sound pass, and again whenever a mix is "off" but you cannot say why. Concretely:

- **Before fetching a single asset.** Assign every planned sound to exactly one layer. An asset that belongs to two layers (a music track with a whoosh baked in) is a sourcing mistake, not a mixing one.
- **When a video feels flat but the effects are all there** — almost always a missing layer 2. Ambience is the layer that says *where* the scene is, and no quantity of layer-4 effects substitutes for it.
- **When a video feels cluttered** — usually layer 4 doing layer 3's job: design effects placed on real-world actions that wanted foley.
- **When the voice is fighting the bed** — a layer-1 versus layer-5 relationship problem, solved by carve, not by turning the music down until it disappears.
- Skip layers deliberately, not by omission. A screen-recording tutorial with no location legitimately has no layer 2; write that decision down.

## How to recognise it in a reference video
Analyse by **subtraction and by band**, not by listening for "good sound":

- **Split and look at the spectrum.** `ffmpeg -i ref.mp4 -vn -ac 2 -ar 48000 /tmp/ref.wav`, then a spectrogram. The five layers are visually separable: dialogue as a dense 100 Hz–8 kHz band that starts and stops with the transcript; ambience as an unbroken low-level floor that never stops; foley as short mid/high transients aligned to on-screen actions; effects as broadband bursts or long sweeps unaligned to anything physical; music as a steady, harmonically regular bed.
- **The ambience test.** Find a gap between two spoken words at least 400 ms long and look at the floor. A true layer 2 shows a continuous non-zero noise floor **across picture cuts**; a video with no ambience drops toward digital silence in the same gaps. Measure it: `ffmpeg -i /tmp/ref.wav -af "astats=metadata=1:reset=10" -f null -` and compare RMS in speech gaps to RMS during speech. A gap floor more than ~45 dB below speech means layer 2 is absent.
- **Count the layers actually present.** Log which of the five you can positively identify. Two or three is normal and matches the source's own practice; five with all of them audible is a film mix, not a YouTube edit.
- **Measure the layer offsets in dB relative to dialogue,** not in absolutes. Dialogue is the reference at 0. Log music, effects, ambience as negative offsets. This ratio is portable across videos; absolute levels are not.
- **Look for the foley/effects confusion.** A door closing on screen accompanied by a designed impact rather than a door sound is a style choice; note it, because it is a reliable creator fingerprint.
- **Transcript signal:** any line where the presenter names a place ("on the road", "in a cafe") is a location cue that a well-built reference will have sounded in layer 2.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `layer_1_dialogue` | 0 dB (linear 1.0) | 0 to −3 dB (1.0–0.708) | The reference. Everything else is expressed relative to this. Source-stated. |
| `layer_2_ambience` | −30 dB (0.0316) | −35 to −25 dB (0.0178–0.056) | Not stated in the source; derived so ambience stays under both speech and music. Present but never identifiable as a "sound". |
| `layer_3_foley` | −18 dB (0.126) | −24 to −12 dB (0.063–0.251) | Not stated in the source. Sits below effects because it is meant to read as real, not as design. |
| `layer_4_effects` | −13.5 dB (0.211) | −15 to −12 dB (0.178–0.251) | Source-stated band. Peak level of the effect, not its average. |
| `layer_5_music` | −22 dB (0.079) | −25 to −20 dB (0.056–0.1) | Source-stated. `editing kt 3` narrows to −22/−25 and takes loud guitar rock to −30 (0.0316). |
| `track_index_band` | 10/14/18/22/30 | 10–33 | One index band per layer, four indices wide, so overlapping clips inside a layer never share an index (`duplicate_audio_track`). |
| `audio_group` | `voiceover`/`ambience`/`foley`/`sfx`/`music` | — | Group names are the carve contract. Only real voice clips may be in `voiceover`. |
| `carve_strength` | 0.25 | 0–0.5 | Applied to the music bed against the `voiceover` group. 0.5 starts being heard as an effect. |
| `layers_used` | 3 | 2–5 | Source's own practice is 2–3. Five is a film mix. |
| `programme_loudness` | −14 LUFS | −16 to −14 LUFS | The absolute check after the relative balance is right. −16 for podcast-style. |

## Reproduction prompt

```
Build the audio for {{PROJECT}} in five passes, in this order. Do not start a
pass until the one before it is signed off.

PASS 1 - DIALOGUE. Place every voice clip in data-audio-group="voiceover",
track indices 10-13, gain 1.0 (0 dB). Apply the voice-clean preset to the
voiceover bus, not to individual clips. Acceptance: every word intelligible
with all other layers muted. If it is not, stop - no later pass fixes this.

PASS 2 - AMBIENCE. For each distinct location in the video, place one looping
ambience bed in data-audio-group="ambience", indices 14-17, gain 0.0316
(-30 dB). The bed spans the whole location, crossing every picture cut inside
it. Acceptance: solo dialogue+ambience; you should be able to name the
location with your eyes shut and never be able to point at the bed.

PASS 3 - FOLEY. For every real-world physical action visible on screen -
footsteps, object handling, cloth - place a foley clip in group "foley",
indices 18-21, gain 0.126 (-18 dB), peak on the contact frame.

PASS 4 - EFFECTS. Only now place risers, impacts, hits and whooshes. Group
"sfx", indices 22-29, gain 0.178-0.251 (-15 to -12 dB).

PASS 5 - MUSIC. One bed per section, group "music", indices 30-33, gain 0.079
(-22 dB), data-fx-carve against ["voiceover"] at strength 0.25.

ACCEPTANCE TEST: solo each layer alone and confirm it is coherent by itself;
then mute each layer in turn from the full mix and confirm the video gets
worse. A layer whose removal changes nothing is a layer to delete. Finally
measure programme loudness and land it at -14 LUFS.
```

## Execution spec

**HyperFrames — the five-layer track map.** There is no track abstraction in the engine: `data-track-index` is *display only* and constrains nothing, and layering is CSS `z-index`, not track index. The one place index carries meaning is the `duplicate_audio_track` warning (two `<audio>` sharing an index **and** overlapping in time). So the layer map below is a convention that exists to (a) keep that warning quiet and (b) make the composition readable:

| Layer | `data-audio-group` | `data-track-index` | Default `data-volume` |
|---|---|---|---|
| 1 dialogue/VO | `voiceover` | 10–13 | `1` |
| 2 ambience | `ambience` | 14–17 | `0.0316` |
| 3 foley | `foley` | 18–21 | `0.126` |
| 4 effects | `sfx` | 22–29 | `0.211` |
| 5 music | `music` | 30–33 | `0.079` |

Group membership alone is enough to carve against. Adding an `<hf-audio-group>` element makes it a real bus — one chain, one fader, one automation clock — which is what you want for layers 1 and 4, where the same treatment belongs on every member:

```html
<hf-audio-group id="voiceover" data-label="Dialogue" data-volume="1"></hf-audio-group>
<hf-audio-group id="ambience" data-label="Ambience" data-volume="0.0316"></hf-audio-group>
<hf-audio-group id="foley"    data-label="Foley"    data-volume="0.126"></hf-audio-group>
<hf-audio-group id="sfx"      data-label="Effects"  data-volume="0.211"></hf-audio-group>
<hf-audio-group id="music"    data-label="Music"    data-volume="0.079"></hf-audio-group>

<audio id="vo-01" src=".media/audio/voice/line-01.wav"
       data-audio-group="voiceover" data-start="0.5" data-track-index="10"></audio>
<audio id="amb-office" src="assets/sfx/office-ambience.wav"
       data-audio-group="ambience" data-start="0" data-duration="42" data-track-index="14"
       data-volume="0.0316"></audio>
<audio id="music-a" src=".media/audio/bgm/bed-a.mp3"
       data-audio-group="music" data-start="0" data-duration="42" data-track-index="30"
       data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```

Contract points that bite, all from `_meta/execution-contract.md`:
- **Every `<audio>` needs an `id`.** An id-less audio element is never mixed → silent render, no error.
- **A bus's automation clock is composition time**; a clip's lane `t` is clip-local. That asymmetry is the reason to reach for a single-member bus when you want composition-time timing on one clip.
- **Keep the carve group voices only.** An ambience or SFX clip inside `voiceover` silently poisons the next carve re-analysis. This is the single strongest argument for five distinct group names.
- **`data-fx-carve` is clip-only** — never on an `<hf-audio-group>` (`audio_group_carve_attr`).
- In modular projects put all audio at the **host root** so playback survives scene cuts; visual segments become sub-comps.
- Nothing validates the FX chain or the automation lanes. Render refuses an unparseable chain; preview plays it dry. So a chain typo is invisible in preview and fatal at render.

**Epidemic Sound — one query shape per layer.**
```
# layer 2 - ambience (SearchRecordings is wrong here; ambiences live in the SFX catalog)
SearchSoundEffects { query:{term:"office ambience room tone"},
                     filter:{ duration:{ min: 30000, max: 300000 } },
                     sort:{ by: DURATION, order: DESCENDING }, first: 20 }
# layer 3 - foley
SearchSoundEffects { query:{term:"footsteps wood interior"},   filter:{duration:{min:300,max:4000}} }
SearchSoundEffects { query:{term:"cloth movement foley"},      filter:{duration:{min:200,max:2000}} }
# layer 4 - effects
SearchSoundEffects { query:{term:"cinematic impact"},          filter:{duration:{min:800,max:4000}} }
# layer 5 - music
SearchRecordings   { query:{term:"<vibe>"},
                     filter:{ bpm:{min:100,max:120}, vocals:false },
                     sort:{ by: POPULARITY, order: DESCENDING }, first: 20 }
DownloadSoundEffect { id: <uuid>, options:{ fileType: WAV } }
DownloadRecording   { id: <uuid>, options:{ fileType: WAV, stemType: FULL } }
```
Two catalogue facts worth designing around: a `Recording` exposes `bpm` and a `stems` list (`DRUMS`, `BASS`, `MELODY`, `INSTRUMENTS`, `CLEAN_VOCALS`, `VOCALS`), and `DownloadRecording` will hand you `FULL | BASS | DRUMS | INSTRUMENTS`. A stem download is the cleanest way to thin layer 5 under a dense layer 4 without touching its level — drop to `INSTRUMENTS` or `DRUMS` for the busy stretch.

**ffmpeg — the absolute check the relative balance cannot give you.** Layer offsets are relative; programme loudness is not. Two-pass `loudnorm` after the mix is rendered:
```bash
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=<i>:measured_TP=<tp>:measured_LRA=<lra>:measured_thresh=<th>:offset=<off>:linear=true mix.social.wav
```

**Remotion:** conceptually one `<Audio>` per clip with a `volume` prop; there is no bus or group primitive, so the five-layer grouping would be a naming convention plus a shared volume constant. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-three-types-classification]] · [[sfx-pause-removal-breath-and-room-tone]] · [[sfx-unsounded-motion-audit]] · [[sfx-music-rest-windows]] · [[sfx-diegetic-action-inventory]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-music-primacy-doctrine]] · [[sfx-sound-pass-order]] · [[struct-music-arc-to-narrative-arc]] · [[sfx-layer-volume-targets]] · [[sfx-ambience-search-formula]]

## Failure modes
- **Building top-down.** Placing effects before the voice is clean is the named mistake: "if this itself is bad, then no amount of sound design is going to make a difference." Fix: pass 1 is a gate, not a step.
- **Treating five layers as a target.** Producing ambience for a screen-recording tutorial is padding. Fix: two or three layers is the source's own norm; record the skipped layers as decisions.
- **Reading the dB numbers as LUFS.** 0/−3 for dialogue and −20/−25 for music are *fader offsets on a timeline*, not loudness measurements. A mix that hits them and still measures −22 LUFS programme loudness is quiet, not correct. Fix: get the relative balance from the layer table, then normalise the whole programme to −14 LUFS.
- **Putting ambience or SFX in the `voiceover` group** so the carve "hears" them. Poisons the next carve re-analysis silently. Fix: five groups, voices only in `voiceover`.
- **Ducking the whole bed instead of carving it.** Costs the bed all its presence. Fix: `data-fx-carve` at 0.25 against the voice group; if the bed sounds notched rather than quieter, strength is too high.
- **Overlapping clips inside one layer on the same track index.** Raises `duplicate_audio_track`. Fix: the four-wide index bands in the table.
- **Known gap:** the source states levels only for layers 1, 4 and 5. The ambience (−30 dB) and foley (−18 dB) defaults here are derived from where those layers have to sit to stay under speech and under the effects layer, not quoted from the video. Treat them as starting points and confirm by ear.
- **Known gap:** the stack has no metering primitive. `check` runs no audio audit at all, and the only loudness measurement available is ffmpeg on a rendered file — which, per the environment constraints, has to happen off this VM. Plan the render leg on another host.
