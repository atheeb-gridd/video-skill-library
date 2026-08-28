---
id: sfx-performed-foley-substitution
title: Perform the substitution — the props catalogue, the recording spec, and when it beats searching
skill: sound-design
type: sfx
family: foley
tags: [skill/sound-design, type/sfx, family/foley, engine/ffmpeg, engine/hyperframes, engine/epidemic, sfx/diegetic, layer/sfx, source/sfx-kt-1, source/research, difficulty/high]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:07:13
    quote: "But Foley sounds are the sound effects that, instead of being shot at a real location, are recorded inside a studio."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:07:27
    quote: "and this is also where you can make your own sound effects. Say I record a whoosh."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:09:11
    quote: "Or you can take the sound of a cucumber snapping —"
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:09:17
    quote: "[older pass only] The sounds that can't really be recorded in real life, you can fake them this way. Or if you can't find a sound effect anywhere, you can recreate it like this."
research_refs:
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (catalogue coverage cross-checked, 2026-08-28)
difficulty: high
detectable_from: audio
---

# Perform the substitution — the props catalogue, the recording spec, and when it beats searching

## What it is
Foley's oldest working method: **perform the sound with a stand-in object whose acoustic behaviour matches the thing you cannot record.** The source's example is a cucumber snapping for a breaking bone, offered as the answer to two different problems — *"The sounds that can't really be recorded in real life, you can fake them this way. Or if you can't find a sound effect anywhere, you can recreate it like this."*

There are two distinct techniques hiding under that sentence and this library splits them, because they take completely different work:

- **[[sfx-substitute-material-foley]]** assembles the sound from **two library files** — a transient plus a body — aligned to the frame. No microphone involved. That is the cheaper path and it is usually the right one.
- **This note is the performed path**: you actually record something. It costs a microphone, a quiet room and half an hour, and it is worth it in a specific and enumerable set of cases.

The reason to keep the performed path in the library at all is that it solves the one thing a catalogue cannot: **rhythm**. A library file has its own timing baked in. If the picture shows three impacts at irregular intervals, or a continuous action whose speed varies, no amount of trimming makes a stock file fit — but a performer watching the picture produces the rhythm for free, in one take. That, and not "impossible sounds", is the durable justification.

The published substitution catalogue is small and specific enough to reproduce in full, and it is the fastest way to answer "what do I hit?":

| Target sound | Prop | Source phrasing |
|---|---|---|
| snow crunching | corn starch in a leather pouch | *"Corn starch in a leather pouch makes the sound of snow crunching"* |
| bird wings | a pair of gloves | *"A pair of gloves sounds like bird wings flapping"* |
| whoosh | an arrow or thin stick | *"An arrow or thin stick makes a whoosh sound"* |
| controllable creak | an old chair | *"An old chair makes a controllable creaking sound"* |
| creak, varied | a water-soaked rusty hinge on different surfaces | *"A water-soaked rusty hinge when placed against different surfaces makes a creaking sound"* |
| gunfire | heavy staple gun + small metal sounds | *"A heavy staple gun combined with other small metal sounds make convincing gun noises"* |
| chain-link fence | a metal rake | *"A metal rake makes the rattle/squeak sound of chain-link fence"* |
| candle / soft fire | burning plastic garbage bags cut into strips | *"Burning plastic garbage bags cut into strips makes a realistic sounding candle or soft non-crackling fire"* |
| grass / brush underfoot | balled-up ¼-inch audio tape | *"1⁄4-inch audio tape balled up sounds like grass or brush when walked upon"* |
| squishing | gelatin and hand soap | *"Gelatin and hand soap make squishing noises"* |
| bone cracking / head injury | frozen romaine lettuce (the source's cucumber) | *"Frozen romaine lettuce makes bone cracking...or head injury noises"* |
| horse hooves | halved coconut shells stuffed with padding | *"Coconut shells cut in half and stuffed with padding make horse hoof noises"* |
| crackling fire | cellophane | *"Cellophane creates crackling fire effects"* |
| ice cubes in a glass | walnuts | *"Walnuts are used in place of ice cubes in a glass of water"* |

The pattern across all fourteen: the prop matches the **material behaviour** (brittleness, fibre, resonance, wetness), never the object. That is the transferable rule for anything not on the list.

## When to use it
- **The picture's rhythm is specific and irregular.** Three footsteps at uneven intervals, a variable-speed rub, a stutter. A performer watching playback delivers the rhythm in one take; a library file never will.
- **You need many synchronous variants of one action.** Recording ten takes is cheaper than finding ten library files that sound like the same object.
- **The object is distinctive and on screen.** A specific product, a prop, a machine with a recognisable character. A generic library file undermines a shot that is *about* that object.
- **A specific perspective is required.** Close and dry for an intimate shot, distant and roomy for a wide. The catalogue has some perspective variants; it does not have yours.
- **The catalogue genuinely has nothing** — after you have actually searched, which is the step everyone skips.
- **Not before searching.** The honest finding from [[sfx-substitute-material-foley]] is that subscription catalogues carry the "impossible" sounds outright — a live probe returned `Gore, Bone, Break, Snap 03` under the tag `gore--bone`. The transcript's flagship example is solvable with one query. Search first, every time.
- **Not for common actions.** Doors, keyboards, footsteps, cloth exist in every library in twenty variants ([[sfx-diegetic-action-inventory]]).
- **Not for air.** A whoosh performed with the mouth is faster and better than a stick ([[sfx-mouth-foley-record-and-process]]).
- **Not without a quiet room.** A performed foley recorded over a fridge hum is worse than any library file, and this stack has **no noise removal** to rescue it.

## How to recognise it in a reference video
- **Look for sync too good to be library.** A library file matches an action at one point — usually its peak. Performed foley matches it **continuously**: the amplitude envelope of the sound tracks the velocity of the on-screen motion frame by frame. Extract a 50 ms RMS trace of the effect and compare it to a frame-differencing motion trace of the shot; a correlation that holds across the whole action, not just at the impact, is the signature.
- **Look for irregular repeats that still match.** Three impacts at 0.31 s, 0.47 s and 0.28 s spacing, each with a slightly different timbre, is a performance. Three identical impacts at even spacing is a file placed three times.
- **Listen for a consistent room across all of one object's sounds.** Performed foley for a scene is recorded in one session, so every hit shares the same early reflections and the same noise floor. Library assembly shows different rooms per hit — that inconsistency is the counter-signature.
- **Check the noise floor under the effect.** Home-performed foley usually sits on a floor 6–15 dB higher than the surrounding mix, audible as a brief lift under each hit. A well-produced library file does not do that. If you hear the floor lift and drop with each effect, it was recorded, not bought — and it was gated afterwards.
- **Check the material mismatch.** The technique's own tell: a soft object cracking, or a small object booming. That mismatch is deliberate ([[sfx-convention-over-accuracy]]).
- **Log the prop, not the sound.** For the design document the reproducible finding is *"footsteps in snow = corn starch pouch, 12 takes, close perspective"*. "Snow footsteps" is not reproducible.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `search_first` | mandatory | — | Query the literal target before recording anything. This step is not optional and it usually ends the task. |
| `takes` | 10 | 6–20 | You are recording variants as much as a sound. Ten takes is four usable ones. |
| `sample_rate` | 48 kHz | 48–96 kHz | 48 kHz matches the pipeline. 96 kHz only if you intend to pitch down more than an octave. |
| `bit_depth` | 24-bit | 24-bit | Headroom for a quiet peak. 16-bit forces you to record hot, which clips transients. |
| `peak_target` | −12 dBFS | −18 to −8 dBFS | Foley is transient-heavy and meters lie about transients. Leave the headroom. |
| `mic_distance` | 25 cm | 15–45 cm | Closer than 15 cm and proximity effect swamps the material; further than 45 cm and you record the room. |
| `mic_axis` | 20–30° off-axis | 0–45° | Off-axis reduces plosive blast from air-moving props without dulling the transient. |
| `room_floor` | ≤ −55 dBFS | ≤ −50 dBFS | Measure before you record. This stack cannot remove noise afterwards. |
| `input_processing` | none | none | No compression, no EQ, no gate on the way in. All of it is reversible only if you did not do it. |
| `handle` | 1 s before, 2 s after | — | You need the tail, and you need clean floor either side for the trim. |
| `hpf_post` | 80 Hz | 60–120 Hz | Removes handling and floor rumble. The one processing step that is always right. |
| `pitch_variants` | ×0.85, ×1.0, ×1.15 | 0.7–1.3 | Built from the best take, after bouncing ([[sfx-pitch-shift-weight-energy]]). |
| `library_name` | `diegetic_<action>_<prop>_NN.wav` | — | The prop belongs in the filename. It is what makes the sound re-recordable in a year. |

## Reproduction prompt

```
The on-screen action at {{EVENT}} needs a sound that has to be performed:
{{ACTION_DESCRIPTION}}.

1. SEARCH THE CATALOGUE FIRST, honestly and literally. Query the target
   itself, not the substitute. Subscription libraries carry most "impossible"
   sounds. Only continue if nothing usable came back AND one of these is
   true: the picture's rhythm is irregular, you need many synchronous
   variants, the object is distinctive and on screen, or you need a
   perspective the catalogue lacks.
2. PICK THE PROP BY MATERIAL BEHAVIOUR, not by object. Ask: is the target
   brittle, fibrous, resonant, wet, granular, metallic? Then match:
     brittle snap      -> celery / frozen romaine lettuce / cucumber
     granular crunch   -> corn starch in a leather pouch
     fibrous rustle    -> balled 1/4-inch tape, dry leaves
     resonant knock    -> halved padded coconut shells
     crackle           -> cellophane
     wet squish        -> gelatin and hand soap
     metallic rattle   -> a metal rake, small metal parts
     air movement      -> an arrow or thin stick (or your mouth - faster)
     creak             -> an old chair, or a water-soaked rusty hinge on
                          different surfaces (one prop, many creaks)
3. MEASURE THE ROOM BEFORE THE FIRST TAKE. Record 5 s of nothing and check
   the floor is at or below -55 dBFS. If it is not, fix the room or stop -
   this pipeline has NO noise removal, and a hissy performed effect is worse
   than any library file.
4. RECORD: 48 kHz / 24-bit, mic 25 cm away and 20-30 degrees off-axis, peaks
   at -12 dBFS, NO compression / EQ / gate on the way in. Leave 1 s of clean
   floor before each take and 2 s after. Perform WATCHING THE PICTURE, in
   real time - the rhythm is the whole reason you are recording.
5. TAKE TEN. You are recording a variant set, not one sound.
6. AUDITION AGAINST PICTURE and pick one hero take plus three variants.
7. PROCESS MINIMALLY, in this order: high-pass 80 Hz -> trim to 200 ms
   before the transient -> fade in 5 ms and out over the natural tail ->
   peak-normalise to -6 dBTP. Nothing else. Reverb and filtering are mix
   decisions and belong in the composition, not in the file.
8. NAME AND INGEST: diegetic_<action>_<prop>_01.wav, with the prop in the
   name, and register the file so it is reusable.
9. PLACE by peak, not by file start: measure the transient's offset from the
   file head and set start = {{EVENT}} - peak_offset.

ACCEPTANCE TEST: play the shot at full speed once with the effect in. It
must read as the object on screen, not as the prop. Then play it three times
in a row with three different variants: no two may sound like the same file.
Then solo the effect and listen to the 200 ms before the transient - if you
hear a room, a breath or a floor lift, the trim is wrong.
```

## Execution spec

**A hard environment constraint, stated first.** Recording does not happen in this stack. The device VM is *"linux ARM64 without sudo"*, there is no capture path in HyperFrames, and Epidemic's MCP produces files rather than accepting them. So the performed-foley workflow splits cleanly:

- **Off-stack (the user, on their own machine):** the room check, the takes, the props.
- **In-stack:** everything after. Ingest, trim, high-pass, normalise, variant generation, placement, mix.

A design document that specifies performed foley must therefore raise it as a **request to the user**, with the prop list and the recording spec attached, not as a step the agent performs. Writing it as an agent step is a spec that cannot execute.

**ffmpeg — the whole post-recording chain.**
```bash
# 0. room check, BEFORE any takes (run on the user's machine, or on the delivered file)
ffmpeg -ss 0 -t 5 -i room.wav -af "astats=measure_overall=RMS_level" -f null -
#    RMS_level must be <= -55 dB. If not, stop.

# 1. find the transient objectively - per-frame peak trace at 30 fps
ffmpeg -i take-07.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null

# 2. the minimal processing chain, one pass. peak at 1.34 s -> keep from 1.14 s
ffmpeg -ss 1.14 -t 1.60 -i take-07.wav \
  -af "highpass=f=80:poles=2,afade=t=in:st=0:d=0.005,\
 afade=t=out:st=1.50:d=0.10,alimiter=limit=0.501" \
  -ar 48000 -c:a pcm_s24le diegetic_bone-break_lettuce_01.wav

# 3. variants FROM THE BOUNCE, never from the raw take
ffmpeg -i diegetic_bone-break_lettuce_01.wav \
  -af "asetrate=48000*0.85,aresample=48000,atempo=1.1765" diegetic_bone-break_lettuce_02.wav
ffmpeg -i diegetic_bone-break_lettuce_01.wav \
  -af "asetrate=48000*1.15,aresample=48000,atempo=0.8696" diegetic_bone-break_lettuce_03.wav

# 4. ingest so it lands in the ledger like any other asset
node <SKILL_DIR>/scripts/resolve.mjs --from diegetic_bone-break_lettuce_01.wav --type sfx --project .
```
`alimiter=limit=0.501` is −6 dBTP. `atempo` is valid only in 0.5–2.0 — chain two for anything outside. Keep every intermediate **outside the mounted vault**, which cannot delete files.

**HyperFrames — placement by peak, and the room added at mix time.** The file is dry on purpose; the room is a composition decision so it can match the shot rather than the recording session:
```html
<audio id="sfx-break-01" src="assets/sfx/diegetic/object/diegetic_bone-break_lettuce_01.wav"
       data-audio-group="sfx"
       data-start="96.31"          <!-- 96.40 event - 0.09 peak offset -->
       data-duration="1.6" data-track-index="20" data-volume="0.211"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Reduce Boxiness&quot;,&quot;params&quot;:{&quot;frequency&quot;:400,&quot;gain&quot;:-3,&quot;q&quot;:1.4}},
         {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Match the shot&quot;,&quot;params&quot;:{&quot;size&quot;:0.35,&quot;damping&quot;:0.5,&quot;wet&quot;:0.18,&quot;dry&quot;:0.95}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>
```
Contract points. `data-volume="0.211"` is ≈ −13.5 dB, inside the source's −12/−15 SFX window. Every `<audio>` **needs an `id`** or it is never mixed. Chain order is signal order — *"Subtract before you add… character and ceiling last"* — so the corrective peaking precedes the reverb and the **limiter is last**. `reverb` convolves a **generated** impulse, so *"preview and render generate the same one"* and a room is reproducible without shipping an impulse file — which is exactly why the recorded file should be dry ([[sfx-reverb-glue]]). Keep it in `data-audio-group="sfx"`, never in `voiceover`.

**Epidemic Sound — the search you must run before recording.** Query the target and the prop, in that order:
```
# 1. the target, literally. this is the step that usually ends the task.
SearchSoundEffects { query:{term:"bone break snap"}, first:24 }
#    verified live: "Gore, Bone, Break, Snap 03", tag gore--bone

# 2. the prop, if you still need it - to compare your take against a reference
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["wood--break"]},
                              duration:{min:200,max:1500} },
                     sort:{by:POPULARITY, order:DESCENDING}, first:24 }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Catalogue titles carry mic notes — `MKH8060 (Shotgun)` appears in some — which is a free lesson in perspective: a shotgun-mic recording is dry and transient-forward, a room recording is diffuse and heavy. Match your own mic distance to whichever the shot wants.

**Remotion.** No recording path either; the file is placed as a plain `<Audio>` in a `<Sequence>`. Concept only.

## Pairs with
[[sfx-substitute-material-foley]] · [[sfx-mouth-foley-record-and-process]] · [[sfx-foley-replacement-pass]] · [[sfx-foley-three-element-checklist]] · [[sfx-diegetic-action-inventory]] · [[sfx-real-vs-invented-sound-rule]] · [[sfx-convention-over-accuracy]] · [[sfx-repetition-variant-rotation]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-reverb-glue]] · [[sfx-library-build-and-taxonomy]] · [[sfx-library-quality-gate]] · [[sfx-peak-offset-measurement]] · [[sfx-peak-on-impact-frame]] · [[sfx-noise-floor-target]]

## Failure modes
- **Recording something the catalogue already has.** The most expensive mistake available here, and the source's own flagship example falls to it. Fix: search the literal target first; thirty seconds saves an hour.
- **Recording in a noisy room.** There is **no noise removal in this stack** — *"a source with audible hiss needs a better source, and saying so is the whole answer."* Fix: measure the floor before the first take; abort at anything above −50 dBFS.
- **Processing on the way in.** Compression, EQ or a gate applied at record time cannot be undone and will be wrong for the mix. Fix: record flat, process after.
- **Recording hot.** Foley is transient-heavy and meters under-read transients, so "peaking at −3" is usually clipping. Fix: peak at −12 dBFS.
- **Baking reverb into the file.** Locks the effect to one room, so it cannot match a different shot later. Fix: record dry, add the room in the composition where `reverb` regenerates deterministically.
- **One take.** You need variants, and a single take repeated is the third named sound-design mistake in the source corpus. Fix: ten takes, four kept.
- **Matching the object instead of the material.** A "car door" prop for a car door is not the technique; the technique is asking what the material does. Fix: brittle / fibrous / resonant / wet / granular / metallic, then pick.
- **Placing by file start.** Puts the transient wherever the take's pre-roll happens to end. Fix: measure `peak_offset` and set `start = event − peak_offset` ([[sfx-peak-offset-measurement]]).
- **Losing the prop.** A file named `break_03.wav` cannot be re-recorded consistently next year. Fix: the prop goes in the filename.
- **Known gap:** **there is no recording capability anywhere in this stack.** The VM is linux ARM64 without sudo, HyperFrames has no capture surface, and Epidemic's MCP is download-only. Every performed-foley step up to and including the takes must be requested from the user with the spec attached. Any design document that lists performed foley as an agent action is specifying something that cannot run.
