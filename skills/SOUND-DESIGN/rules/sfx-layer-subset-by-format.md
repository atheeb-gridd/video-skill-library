---
id: sfx-layer-subset-by-format
title: Two or three layers, not five — the drop test and what each format actually needs
skill: sound-design
type: structure
family: layers
tags: [skill/sound-design, type/structure, family/layers, engine/hyperframes, engine/epidemic, engine/ffmpeg, layer/dialogue, layer/ambience, layer/music, layer/sfx, layer/design, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:03:24
    quote: "Now this doesn't mean that you have to do all 5 layers every single time."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:03:24
    quote: "In my own YouTube videos I only use 2 or 3 of these layers."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:03:28
    quote: "This was just to make you understand how all the layers come together to create an experience."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:09:41
    quote: "Even in movies they use the sounds of that real location, so that you feel like you're actually there."
research_refs:
  - https://en.wikipedia.org/wiki/Room_tone
  - https://en.wikipedia.org/wiki/Montage_(filmmaking)
difficulty: low
detectable_from: audio
---

# Two or three layers, not five — the drop test and what each format actually needs

## What it is
An explicit anti-maximalism note attached to the five-layer framework by its own author: *"this doesn't mean that you have to do all 5 layers every single time. In my own YouTube videos I only use 2 or 3 of these layers."* The full stack was demonstrated to show *"how all the layers come together to create an experience"*, not as a checklist to complete.

[[sfx-five-layers-build-order]] establishes the model and the order — **dialogue → ambience → foley → SFX → music**. This note is the **selection** step that comes before it: deciding which layers this particular video, in this particular section, actually needs. Without it, the framework becomes a to-do list, and a to-do list produces the two worst outcomes available: a video with foley on a screen recording, or a video where four thin layers eat the time one good layer needed.

The selection is not a matter of ambition. Each layer has a **condition on the picture** that makes it mandatory, and if that condition is absent the layer has nothing to do:

| Layer | Mandatory when | Droppable when |
|---|---|---|
| 1 dialogue | anyone speaks | nothing is spoken (a silent social cut, a pure montage) |
| 2 ambience | the picture shows a **real place** | the picture shows no place — motion graphics, screen recordings, text, product on white |
| 3 foley | a **body or an object visibly acts** — hands, feet, cloth, contact | nothing on screen touches anything |
| 4 SFX | something **moves that reality did not make** — a transition, a text animation, a graphic | no synthetic motion at all (essentially never, in edited content) |
| 5 music | almost always — it is the one layer that can carry a video alone | a deliberate rest window, or a sequence whose whole point is bare sound |

Read that table against a typical talking-head video and the creator's own "2 or 3" falls straight out: **dialogue + music + SFX**. There is a real place on screen, but a static interior with no events in it is served by a noise floor rather than by an ambience *design* — and that is the distinction that trips people up. **You may drop ambience as content. You may never drop the floor.** A programme with no layer 2 still needs a measurable noise floor, or it goes dead ([[sfx-noise-floor-target]]).

## When to use it
- **At the top of every design document, before any fetching.** The layer set is the first decision, and it determines the whole asset list.
- **Per section, not per video.** A talking-head video with one location montage is 3 layers for 90% of its runtime and 4 for the montage. Deciding once for the whole video is how you end up with foley nobody needed.
- **When the sound budget is short.** Two layers executed properly beats five executed at 60%. The choice of *which* two is the entire craft.
- **When a video sounds cluttered.** The fault is usually a layer that had no condition to satisfy — most often SFX on things that are not moving.
- **When a video sounds hollow.** The fault is usually a mandatory layer that was dropped — most often ambience on real-location footage, which is a named mistake in the source corpus.
- **Not as licence to skip layer 1.** Dialogue is the floor of the model: if the voice is bad, no layer above it rescues the video.
- **Not as licence to skip the noise floor.** Dropping ambience is a content decision; the floor is a technical requirement and is not part of this trade.

## How to recognise it in a reference video
- **Count the layers present, per section, and log the count.** This is the single most useful number an analysis pass can produce about a video's sound, because it sets the effort budget for reproducing it. Section-by-section, not overall.
- **Detect each layer with a specific test:**
  - **Dialogue** — trivial from the transcript.
  - **Ambience** — band-limit to 200 Hz–6 kHz during a speech pause and listen for *events*: a car, a bird, distant voices. Events mean layer 2 is present. A featureless hiss with no events is a floor, not ambience, and should be logged as such.
  - **Foley** — look for sounds that correspond to a visible body or object action with no synthetic character: footsteps, cloth, a cup on a table. Presence of even three of these across a video means the creator did a foley pass.
  - **SFX** — whooshes, risers, hits, impacts on transitions and animations. Almost always present.
  - **Music** — obvious, but log the **rest windows** too; their existence is a sign of a considered mix ([[sfx-music-rest-windows]]).
- **Measure the noise floor even when ambience is absent.** Three 0.4 s windows in speech pauses; expect −55 to −45 dBFS. A reference video with no ambience *and* no floor is a badly-mixed reference, not a stylistic choice — do not reproduce it.
- **Compute the layer count against the format.** If it does not match the table in the Parameters section, that mismatch is the most interesting finding in the whole audio analysis: either the creator has a deliberate style, or they made the standard mistake.
- **Watch for foley on non-places.** Footsteps under a screen recording, cloth under a motion graphic. Its presence tells you the creator was working from a checklist, and it is not worth reproducing.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `layer_count` | 3 | 2–5 | The source's own working range for YouTube is 2–3. Five is a narrative-film budget. |
| `talking_head_youtube` | 1, 4, 5 (+floor) | — | Dialogue, SFX, music. Ambience as a floor only; foley absent. This is the corpus's own configuration. |
| `location_vlog` | 1, 2, 5 (+4 sparingly) | — | The place is the content, so layer 2 is mandatory and layer 4 is decoration. |
| `documentary` | 1, 2, 4, 5 | — | Foley only for archive or reconstruction where the original audio is missing. |
| `narrative_short` | 1, 2, 3, 4, 5 | — | The only format where all five are genuinely required. |
| `ad_15_30s` | 1, 4, 5 | — | No time to establish a place. Ambience only if the location *is* the pitch. |
| `faceless_explainer` | 1, 4, 5 | — | No real place and no bodies, so layers 2 and 3 have nothing to do. Motion SFX carries everything. |
| `silent_social` | 4, 5 (+2 if a place) | — | No dialogue layer at all; captions carry the language (the caption track carries the language instead). |
| `noise_floor` | always | — | Not a layer and not negotiable. −50 dBFS in the gaps, even at `layer_count: 2`. |
| `per_section_override` | yes | — | Re-run the drop test at every structural boundary. |
| `effort_split` | 60 / 25 / 15 | — | Rough time split across the layers you kept, highest-condition layer first. A fourth layer is usually taking time from the first. |

## Reproduction prompt

```
Decide the sound layer set for the video, section by section, BEFORE
fetching any asset.

1. SPLIT THE VIDEO INTO SECTIONS from the structure document. Do this per
   section; a single answer for the whole video is always wrong somewhere.

2. FOR EACH SECTION, RUN THE DROP TEST. Ask each question against the
   PICTURE, not against ambition:
   L1 DIALOGUE  - does anyone speak? yes -> mandatory.
   L2 AMBIENCE  - does the picture show a REAL PLACE? yes -> mandatory.
                  Screen recordings, motion graphics, text cards and product
                  on white are NOT places. A static interior with no events
                  is a floor, not an ambience design.
   L3 FOLEY     - does a body or object VISIBLY ACT on screen - hands, feet,
                  cloth, contact? yes -> mandatory. Nothing touching
                  anything -> drop.
   L4 SFX       - does anything move that reality did not make - a
                  transition, a text animation, a graphic? yes -> mandatory.
   L5 MUSIC     - default yes, except in deliberate rest windows.

3. COUNT. If you have 4 or 5 in a talking-head or explainer section,
   re-check L2 and L3 - they are the layers people add without a condition.
   If you have 1 or 2 in a location section, re-check L2 - a real place with
   no ambience is a named mistake.

4. HOLD THE FLOOR REGARDLESS. Dropping L2 as content does NOT drop the noise
   floor. Every section, at every layer count, must measure -55 to -45 dBFS
   in its speech gaps. Verify with:
     ffmpeg -i mix.wav -af "silencedetect=n=-50dB:d=0.30" -f null -
   Zero hits is the pass condition.

5. WRITE THE SET INTO THE DESIGN DOCUMENT as an explicit per-section list,
   e.g. "s2 (desk, talking head): L1, L4, L5 + floor". The asset list is
   generated from this, so an unstated layer becomes an unfetched asset.

6. SPEND THE TIME YOU SAVED ON THE LAYERS YOU KEPT. Three layers at full
   quality beats five at 60%. If you have four layers and a deadline, cut
   the layer with the weakest condition and put its time into layer 1.

ACCEPTANCE TEST: for each section, mute each layer in turn and play 15 s.
Muting a layer you kept must make the section measurably worse in a way you
can name in one sentence. If you cannot name what a layer is doing, it did
not have a condition and should not be there.
```

## Execution spec

**HyperFrames — the layer set is an audio-group topology.** Each kept layer becomes one `data-audio-group`, and dropping a layer means one fewer group, not a muted one. A three-layer talking-head section:

```html
<!-- L1 dialogue: the carve source, and the only mandatory bus -->
<hf-audio-group id="voiceover" data-label="Dialogue" data-volume="1"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;v1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:100,&quot;poles&quot;:&quot;2&quot;}},
    {&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;v2&quot;,&quot;label&quot;:&quot;Add Clarity&quot;,&quot;params&quot;:{&quot;frequency&quot;:3000,&quot;gain&quot;:2.5,&quot;q&quot;:1}},
    {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;v3&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></hf-audio-group>

<audio id="vo-1" src=".media/audio/voice/line-01.wav" data-audio-group="voiceover"
       data-start="0.5" data-track-index="10"></audio>

<!-- the FLOOR. not layer 2, and not optional at any layer count. -->
<audio id="floor-bed" src="assets/sfx/ambience/room_tone_120s.wav"
       data-audio-group="ambience" data-start="0" data-duration="600"
       data-track-index="13" data-volume="0.040"></audio>

<!-- L4 SFX -->
<audio id="sfx-whoosh-1" src="assets/sfx/motion/whoosh_short_01.wav"
       data-audio-group="sfx" data-start="12.87" data-duration="0.6"
       data-track-index="20" data-volume="0.211"></audio>

<!-- L5 music, carved against the dialogue group -->
<audio id="music-bed" src=".media/audio/bgm/bed.wav" data-audio-group="music"
       data-start="0" data-duration="600" data-track-index="11" data-volume="0.071"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```
Contract points. The gains encode the source's own targets: dialogue `1` (0 dB), music `0.071` (−23 dB, inside the −20/−25 window), SFX `0.211` (−13.5 dB, inside −12/−15), floor `0.040` (−28 dB). Every `<audio>` **needs an `id`** or it is never mixed and the layer silently disappears from the render. Keep the carve group **voices only** — a floor bed or an SFX clip inside `voiceover` *"poisons the next re-analysis silently"* — and note that the floor bed lives in `ambience` precisely so it stays out of it. `data-fx-carve` is **clip-only**, never on a bus (`audio_group_carve_attr`), and its `sources` must name a **group**, not clip ids (`audio_carve_ungrouped_sources`). Then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`; the contract's own doctrine is *"Carve by default… Skip it only when there is no narration for the music to sit under"*, which for a 2-layer music-and-SFX section means skipping it.

A useful consequence of the topology: **a dropped layer is a group that does not exist**, which makes the layer count readable straight off the composition. If a design document says three layers and the composition has five groups, one of them is unjustified.

**Epidemic Sound — the fetch list is generated from the layer set, and the queries differ per layer.** This is the practical payoff of deciding first:
```
# L2 ambience (only if the section has a real place) - SFX catalogue, not Recordings
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["ambience--room-tone"]},
                              duration:{min:60000} },
                     sort:{by:DURATION, order:DESCENDING}, first:24 }
# L3 foley (only if a body or object acts on screen)
SearchSoundEffects { query:{term:"footsteps wood interior"}, filter:{duration:{min:300,max:4000}} }
SearchSoundEffects { query:{term:"cloth movement foley"},    filter:{duration:{min:200,max:2000}} }
# L4 sfx
SearchSoundEffects { query:{term:"whoosh transition short"}, filter:{duration:{min:200,max:1500}} }
# L5 music
SearchRecordings { filter:{ bpm:{min:100,max:120}, vocals:false },
                   sort:{by:POPULARITY, order:DESCENDING}, first:20 }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
DownloadRecording   { id:<uuid>, options:{ fileType: WAV, stemType: FULL } }
```
Note that **ambiences live in the sound-effects catalogue, not in `SearchRecordings`** — a common and expensive wrong turn. And note the floor is fetched even when layer 2 is dropped: it comes from the same `ambience--room-tone` slug, chosen for eventlessness rather than for location.

**ffmpeg — the two checks that police the decision.**
```bash
# 1. the floor is present at every layer count. zero output = pass.
ffmpeg -i mix.wav -af "silencedetect=n=-50dB:d=0.30" -f null -
# 2. per-layer stem bounce, to run the mute test objectively rather than by ear
ffmpeg -i mix.wav -af "astats=metadata=1:reset=30" -f null - 2>&1 | grep -E 'RMS|Peak'
```

**Remotion.** Layers are separate `<Audio>` components; there is no bus concept, so a shared treatment must be applied per file. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-five-layers-build-order]] · [[sfx-noise-floor-target]] · [[sfx-missing-ambience-audit]] · [[sfx-ambience-establishes-location]] · [[sfx-foley-replacement-pass]] · [[sfx-foley-three-element-checklist]] · [[sfx-motion-pass-two-rules]] · [[sfx-unsounded-motion-audit]] · [[sfx-density-fatigue-audit]] · [[struct-stimulation-budget]] · [[sfx-layer-volume-targets]] · [[sfx-music-primacy-doctrine]] · [[sfx-sound-pass-order]] · [[sfx-layer-stem-demo]] · [[motion-format-promise-motion-budget]] · [[struct-progressive-layer-demo]]

## Failure modes
- **Treating the five layers as a checklist.** Produces foley on screen recordings and ambience under motion graphics — sounds with no condition to satisfy. Fix: run the drop test against the picture, per section.
- **Dropping the noise floor along with layer 2.** The commonest misreading of "2 or 3 layers", and it makes the video read as broken rather than as minimal. Fix: the floor is not a layer; it is always present at −55 to −45 dBFS.
- **One layer set for the whole video.** A location montage inside a talking-head video needs a layer the rest does not. Fix: decide per section.
- **Dropping ambience on real-location footage.** A named mistake in the source corpus: *"Even in movies they use the sounds of that real location, so that you feel like you're actually there."* Fix: real place → layer 2 is mandatory.
- **Adding a fourth layer instead of finishing the first.** Layer 1 is the floor of the model; time taken from it to add thin foley is a net loss. Fix: 60/25/15 across the layers you kept.
- **Confusing a floor with an ambience.** A featureless hiss identifies no place and does no layer-2 work. Fix: layer 2 has events; a floor does not. Log them separately in the analysis.
- **Groups that outnumber the declared layers.** A composition with five audio groups and a three-layer design document has an unjustified layer in it. Fix: reconcile before rendering; the topology is the audit.
- **Known gap:** nothing in the pipeline checks a layer set against the picture — there is no shot classifier and no *"automatic face tracking or content-aware"* analysis of any kind. The drop test is a human or agent judgement made from the storyboard and the footage, and it must be written into the design document explicitly, because no later stage will catch a missing layer.
