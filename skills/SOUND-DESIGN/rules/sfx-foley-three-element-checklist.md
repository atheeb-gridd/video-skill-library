---
id: sfx-foley-three-element-checklist
title: The foley checklist — feet, objects, cloth, and nothing else
skill: sound-design
type: sfx
family: foley
tags: [skill/sound-design, type/sfx, family/foley, sfx/diegetic, layer/sfx, layer/ambience, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:02:03"
    quote: "Now foley sounds include footsteps, object interaction, cloth sounds and so on."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:01:41"
    quote: "you can't record every single sound properly. Like, this is the real sound from my video, and this is the foley sound that I added later."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:01:57"
    quote: "So to keep every sound's quality really good — which sound should be louder, which one softer — for that control, we add the sound later."
research_refs:
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://en.wikipedia.org/wiki/Just-noticeable_difference
  - "mcp://Epidemic_sounds/SearchSoundEffects — probed live 2026-08-28: `footsteps--human` (7467 hits for the sneakers/concrete probe; sequences 16.8–55.2 s; only 57 assets between 300–1500 ms), `cloth--movement` (9745 hits; 3.7–55.8 s), prop handling filed under `objects--packaging` / `food-drink--cooking`"
difficulty: medium
detectable_from: video
---

# The foley checklist — feet, objects, cloth, and nothing else

## What it is
Layer 3 of the five-layer stack, and the layer with the shortest possible checklist. Foley is **real-world sound re-performed after the fact so it can be controlled**: the source is explicit that the reason to replace a recorded sound with a foley sound is not authenticity but *control* — which sound is louder, which is softer. Its scope is three elements, and the industry's own division is identical to the one in the transcript: **Feet** (footsteps), **Specifics / props** (object interaction), and **Moves** (cloth — *"the swishing of clothing when two actors walk past each other"*).

Three elements is the whole list, and that is the point. A foley pass that starts sounding wind, doors down the hall and traffic has stopped being foley and become ambience ([[sfx-ambience-establishes-location]]); a pass that starts adding whooshes to graphics has become the motion pass ([[sfx-motion-pass-two-rules]]). Keeping the checklist to three keeps the pass finishable.

The practical shape of the work in this stack is dictated by how the catalogue stores foley, which was probed live. **Footsteps are sold as long steady sequences** — 16 to 55 seconds of walking, described as `Footsteps, Human, Concrete, Sneakers, Walk, Medium Tempo, Steady 01` — with perspective variants (`Close`, `Distant`) and tempo variants (`Slow`, `Moderate`, `Medium`). Single steps are scarce: filtering `footsteps--human` to 300–1500 ms returned only **57 assets** in the whole catalogue, and most of them are scuffs, stamps and slides rather than clean steps. So the working method is: fetch a sequence whose surface and footwear match, then **place individual steps out of it** with `data-media-start`, one clip per footfall.

## When to use it
- **On any shot where a body, a hand or an object is visible and audible-by-implication**: someone walking into frame, picking up a phone, putting down a mug, turning a page, sitting down, adjusting a jacket.
- **When the production audio has the action but not usably** — a lav mic that heard the voice and not the keyboard, a phone camera that heard the room and not the object.
- **When the video feels real but empty** — dialogue and ambience present, nothing in between. That gap is exactly the foley layer.
- **Feet**: only when feet are visible, or when someone arrives or leaves frame. Do not sound feet you cannot see and whose owner is not moving through the scene; it reads as an intruder.
- **Objects**: on **every visible contact** — this is the element most often under-covered, and the cheapest to fix.
- **Cloth**: on body moves lasting **more than about 12 frames** — standing up, reaching across, turning, taking off a jacket. Not on small gestures; the layer works by being nearly inaudible.
- **Do not** foley a talking-head static shot with no hands and no props. There is nothing to cover, and adding cloth rustle to a motionless presenter is the classic over-foley tell.

## How to recognise it in a reference video
- **Watch the picture with the sound off and list contacts.** Every frame where a foot lands, a hand meets an object, or a torso changes shape is a candidate. Then watch with sound and mark which were covered. **Coverage ratio** is the number to log: well-finished creator work covers **0.6–0.9** of visible contacts; unfinished work covers under 0.2.
- **Check sync tightness.** Foley is the layer where sync errors are most visible because the eye has a contact frame to compare against. Broadcast detectability thresholds put audio-early at around **45 ms** and audio-late at around **125 ms** — so a footfall more than ~1 frame early or ~4 frames late is perceptible. Competent foley sits at **0 to +1 frame**.
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null | paste - -
  ```
- **Measure the level.** Foley sits **18–24 dB below dialogue** — below the designed-SFX band (−12 to −15 dB), because it is realism, not punctuation. Foley that measures at SFX level is the second most common error in this layer after bad sync.
- **Listen for repetition across a walk.** Six identical footsteps is the tell that one file was copied. Real walking varies: alternate feet differ, and each step differs by a couple of dB and a few tens of milliseconds ([[sfx-repetition-variant-rotation]]).
- **Check surface agreement.** Does the footstep timbre match the floor you can see? A concrete step on a carpet shot is a continuity error the viewer registers as "off" without diagnosing.
- **Check perspective agreement.** A wide shot with close-perspective foley sounds like the sound is in your lap. The catalogue's `Close` / `Distant` variants exist precisely for this; in a reference, a distant shot with dry close foley is a defect to log.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `feet_sync` | contact frame + 0 | −1 to +1 frame | The tightest sync requirement in the library. |
| `object_sync` | contact frame + 0 | 0 to +1 frame | Hand-object contacts read late faster than feet do. |
| `cloth_sync` | move onset + 2 frames | 0 to +4 frames | Cloth is a smear, not a transient; a couple of frames late is natural. |
| `cloth_min_move` | 12 frames (0.4 s) | 8–20 frames | Below this, do not sound the move. |
| `foley_gain` | 0.100 (≈ −20 dB) | −24 to −18 dB rel. dialogue | Deliberately under the designed-SFX band. |
| `feet_gain_walk` | 0.089 (≈ −21 dB) | −24 to −19 dB | Louder only if the walk is a story beat (an arrival, a threat). |
| `cloth_gain` | 0.063 (≈ −24 dB) | −28 to −22 dB | The quietest thing in the mix that is still doing a job. |
| `step_variants` | 4 | 3–8 | Distinct steps cut from the sequence, rotated; never the same one twice in a row. |
| `step_level_jitter` | ±1.5 dB | ±1–3 dB | 1 dB is the loudness JND, so ±1.5 dB is audible as variation without reading as a mistake. |
| `step_pitch_jitter` | ±80 cents | ±50–200 cents | Above ~300 cents the shoe changes size. |
| `step_timing_jitter` | ±1 frame | ±0–2 frames | Only where the picture allows; sync wins over variation. |
| `coverage_target` | 0.75 | 0.6–0.9 | Fraction of visible contacts covered. 1.0 is usually over-foley. |
| `perspective` | match shot size | Close / Distant | Wide shot → `Distant` take, or `lowpass` 5–7 kHz plus a touch of the room reverb. |

## Reproduction prompt

```
Run the foley pass on {{COMP}}. Three elements, three passes, in this order.

PASS 1 - FEET. Scan the cut for every footfall that is visible or that carries a
character into or out of frame.
  a) Identify surface and footwear from the picture (concrete/wood/carpet/gravel,
     sneakers/boots/heels/bare).
  b) Fetch a matching STEADY SEQUENCE, not a single step:
     SearchSoundEffects { query:{ term:"footsteps human <surface> <footwear> walk" },
                          filter:{ tagSlugs:{matchType:ALL,values:["footsteps--human"]} },
                          first:24 }
     Prefer titles containing the tempo you need (Slow / Moderate / Medium Tempo,
     Steady) and the perspective (Close / Distant) matching shot size.
  c) In the sequence, measure the offsets of 4 clean consecutive steps
     (10 ms astats scan). These are your 4 variants.
  d) Place ONE <audio> clip per visible footfall: same src, different
     data-media-start (variant offset - 0.02 s pre-roll), data-duration 0.35 s,
     data-start = contact_frame_time - peak_offset_of_that_variant.
     Rotate variants; never the same variant twice in a row.
  e) Gain 0.089. Jitter +/-1.5 dB by varying data-volume between 0.075 and 0.105.

PASS 2 - OBJECTS. Scan for every hand-object contact: pick up, put down, tap,
open, close, page turn, cup on desk, phone on table.
  Fetch by MATERIAL, not by fiction:
     SearchSoundEffects { query:{ term:"<material> <action> pick up put down" },
                          filter:{ duration:{min:400,max:12000} }, first:24 }
  Long "Handle Pick Up Put Down" files contain several usable contacts - trim to
  each with data-media-start, exactly as in pass 1. Gain 0.100, sync 0 to +1 frame.

PASS 3 - CLOTH. Scan for body moves longer than 12 frames: standing, reaching,
turning, removing a layer.
     SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL,values:["cloth--movement"]},
                                   duration:{min:3000,max:20000} }, first:24 }
  Match the garment in the title to the garment on screen (Hoodie / Jacket /
  Wool / Light Material) and the speed (Fast / Medium / Short / Long Movements).
  Trim one movement per event. Gain 0.063, start 2 frames after the move onset.

THEN, ONCE, FOR ALL THREE:
  - Put every foley clip in data-audio-group="foley".
  - Give that group ONE reverb (size 0.35, wet 0.14, dry 0.9) so the three
    elements share a room. Individual reverbs on individual clips is the wrong
    shape here.
  - Count coverage: covered contacts / visible contacts. Target 0.75.

ACCEPTANCE TEST: watch one shot with the foley bus muted, then unmuted. Muted it
should feel like a video; unmuted it should feel like a place. If you can point
at any single footstep and say "that one", it is 3 dB too loud or its variant
repeated.
```

## Execution spec

**Epidemic Sound — what the catalogue actually holds, probed live 2026-08-28.**

*Feet* — slug `footsteps--human`. Titles follow `Footsteps, Human, <Surface>, <Footwear>, <Gait>, <Tempo>, Steady NN`; real examples: `Footsteps, Human, Sneakers, Concrete, Walk, Close`, `…, Walk, Distant` (both 16.8 s), `Footsteps, Human, Concrete, Sneakers, Walk, Medium Tempo, Steady 01` (31.7 s), `Footsteps, Human, Sneakers on Concrete 01` (52.6 s). **Filtering the same slug to 300–1500 ms returns only 57 assets catalogue-wide**, and they are mostly `Scrape, Scuff, Feet, Gravel Ground` (376 ms), `Footsteps, Human, Stamp, Wood Panel` (300 ms), `Footsteps, Human, Slide On Carpeted Floor` (1071 ms). So: **sequences for walking, singles only for stamps, scuffs and slides.**
```
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL,values:["footsteps--human"]} },
                     query:{ term:"concrete sneakers walk medium tempo steady" }, first:24 }
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL,values:["footsteps--human"]},
                              duration:{min:300,max:1500} }, first:24 }   # the singles
```
*Cloth* — slug `cloth--movement`. Titles: `Cloth, Movement, Clothing, Hoodie 02` (14.8 s), `Cloth, Movement, Clothing, Hoodie, Fast` (3.7 s), `Cloth, Movement, Clothing, Jacket, Medium` (9.0 s), `Cloth, Movement, Soft Cloth, Wool, Fur, Fluffy, Short Movements 02` (55.8 s), `Cloth, Movement, Clothes, Rummage, Light Material` (7.7 s). Garment and speed are both in the title — use them as search terms.

*Objects* — no single slug; props are filed by **object and material** (`objects--packaging`, `food-drink--cooking`, and similar), with the action spelled out in the chain: `Objects, Packaging, Canned Item, Pick Up, Put Down` (11.5 s), `Food & Drink, Cooking, Vegetable, Fruit, Apple, Handle Pick Up Put Down` (6.3 s). Search the **material and the action**, never the narrative object ([[sfx-substitute-material-foley]]).

Always `DownloadSoundEffect { id, options:{ fileType: WAV } }` — foley is quiet and gets gain applied, which also amplifies mp3 artefacts.

**HyperFrames — one file, many clips, one bus.** The pattern that makes long sequences usable: the same `src` placed several times with different `data-media-start`, each trimmed to one contact.
```html
<!-- four footfalls out of one 31.7 s sequence; variants at 1.42 / 1.94 / 2.47 / 2.98 s -->
<audio id="fol-step-01" src="assets/foley/feet/footsteps_human_concrete_sneakers_medium_01.wav"
       data-audio-group="foley" data-start="6.214" data-duration="0.35"
       data-media-start="1.400" data-track-index="15" data-volume="0.089"></audio>
<audio id="fol-step-02" src="assets/foley/feet/footsteps_human_concrete_sneakers_medium_01.wav"
       data-audio-group="foley" data-start="6.681" data-duration="0.35"
       data-media-start="1.920" data-track-index="16" data-volume="0.100"></audio>
<audio id="fol-step-03" src="assets/foley/feet/footsteps_human_concrete_sneakers_medium_01.wav"
       data-audio-group="foley" data-start="7.148" data-duration="0.35"
       data-media-start="2.450" data-track-index="15" data-volume="0.079"></audio>

<!-- cloth: one movement out of a 9 s jacket file, 2 frames after the reach starts -->
<audio id="fol-cloth-01" src="assets/foley/cloth/cloth_movement_jacket_medium.wav"
       data-audio-group="foley" data-start="12.466" data-duration="0.70"
       data-media-start="3.150" data-track-index="17" data-volume="0.063"></audio>

<!-- the shared room, once, on the bus -->
<hf-audio-group id="foley" data-label="Foley" data-volume="1"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;g1&quot;,&quot;label&quot;:&quot;Trim rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:80,&quot;poles&quot;:&quot;1&quot;}},
    {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;g2&quot;,&quot;label&quot;:&quot;Shared room&quot;,&quot;params&quot;:{&quot;size&quot;:0.35,&quot;damping&quot;:0.5,&quot;wet&quot;:0.14,&quot;dry&quot;:0.9}},
    {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;g3&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></hf-audio-group>
```
Contract points: alternate `data-track-index` between adjacent steps or overlapping tails raise `duplicate_audio_track`; every `<audio>` needs an `id` or it is **never mixed** and the render is silently missing the layer; `data-media-start` trims without touching the file, which is what makes the many-clips-one-file pattern free; `<hf-audio-group>` is the right shape here because *"a compressor cannot ride a sequence it only hears a third of"* and the same holds for a room. Keep the foley group **out** of the `voiceover` carve group — putting a non-voice track in the carve group *"poisons the next re-analysis silently"*.

**Distance without a distant take:** `lowpass` at 5000–7000 Hz plus more `wet` on the bus reads as further away ([[sfx-filter-character-and-distance]]). This is cheaper than fetching both perspectives, and reversible.

**ffmpeg — cutting singles out of a sequence when you want real files.**
```bash
# find the step offsets inside the sequence (10 ms scan, take the local maxima)
ffmpeg -v error -i steps_seq.wav -af "asetnsamples=n=480,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null | paste - -

# cut four variants with 20 ms pre-roll and a 60 ms tail fade
for t in 1.40 1.92 2.45 2.96; do
  ffmpeg -y -i steps_seq.wav -ss $t -t 0.35 \
    -af "afade=t=in:st=0:d=0.005,afade=t=out:st=0.29:d=0.06" step_${t}.wav
done
# pitch a variant by -80 cents without changing length (rubberband present in this build)
ffmpeg -i step_1.40.wav -af "rubberband=pitch=0.9548" step_1.40_dn80c.wav
```

**Remotion:** one `<Audio startFrom>` per contact, same file, different offsets. Concept only.

## Pairs with
[[sfx-five-layers-build-order]] · [[sfx-diegetic-action-inventory]] · [[sfx-substitute-material-foley]] · [[sfx-mouth-foley-record-and-process]] · [[sfx-real-vs-invented-sound-rule]] · [[sfx-repetition-variant-rotation]] · [[sfx-peak-offset-measurement]] · [[sfx-filter-character-and-distance]] · [[sfx-reverb-glue]] · [[sfx-layer-volume-targets]] · [[sfx-ambience-establishes-location]] · [[sfx-convention-over-accuracy]] · [[sfx-air-on-micro-movement]] · [[sfx-foley-family]]

## Failure modes
- **Over-foley.** Every micro-gesture covered; the video sounds like a rustling paper bag. Fix: the 12-frame cloth floor and a coverage target of 0.75, not 1.0.
- **Foley at SFX level.** Realism mixed like punctuation. Fix: −24 to −18 dB relative to dialogue; if you can name the sound, it is too loud.
- **One footstep file copied.** Six identical steps is not a walk. Fix: four variants from the sequence, rotated, with ±1.5 dB and ±80 cents of jitter.
- **Surface mismatch.** Concrete steps on carpet. Fix: read the floor off the picture before searching; the surface is in the catalogue title.
- **Perspective mismatch.** Close foley on a wide shot. Fix: `Distant` take, or lowpass at 5–7 kHz plus more wet on the bus.
- **Sounding feet you cannot see.** Reads as someone else in the room. Fix: feet only when visible or when a character enters/leaves.
- **Individual reverbs per clip.** Every element in its own slightly different room; the layer never glues. Fix: one reverb on the `foley` bus.
- **Foley clips left without ids.** Silently dropped from the mix — the whole layer disappears and `check` will not tell you. Fix: id every `<audio>`.
- **Known gap:** the catalogue has no "single footstep" category worth the name (57 assets under 1.5 s catalogue-wide), so per-step placement always means slicing a sequence. Budget for that: a 12-step walk is 12 clips and one measurement pass, not one drag-and-drop.
