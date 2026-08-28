---
id: sfx-foley-replacement-pass
title: The foley replacement pass — you cannot record every sound, so re-add them
skill: sound-design
type: mix
family: foley
tags: [skill/sound-design, type/mix, family/foley, engine/epidemic, engine/hyperframes, engine/ffmpeg, sfx/diegetic, layer/dialogue, layer/ambience, layer/sfx, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/high]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:01:39
    quote: "Look, it's because when you record in the real world, you can't record every single sound properly."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:01:43
    quote: "Like, this is the real sound from my video, and this is the foley sound that I added later."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:01:57
    quote: "So to keep every sound's quality really good - which sound should be louder, which one softer - for that control, we add the sound later."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:02:03
    quote: "Now foley sounds include footsteps, object interaction, cloth sounds and so on."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:07:13
    quote: "But Foley sounds are the sound effects that, instead of being shot at a real location, are recorded inside a studio."
research_refs:
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://en.wikipedia.org/wiki/Room_tone
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/EBU_R_128
  - mcp://Epidemic_sounds/SearchSoundEffects (footsteps--human and cloth--movement probed live, 2026-08-28)
difficulty: high
detectable_from: audio
---

# The foley replacement pass — you cannot record every sound, so re-add them

## What it is
The rationale for foley, stated in one line: on location you have no control over which sound is loud and which is soft, so you re-add the sounds in post where you *do*. That is the whole argument, and it is the same argument the film industry makes — props *"do not react the same way acoustically as their real-life counterparts"*, and location recording captures every sound at whatever level the room and the mic position happened to give it.

The professional practice divides into three categories that match the source's own list exactly: **feet** (footsteps, on the right surface, in the right shoes), **moves** (cloth — created by rubbing two pieces of the same material near the mic at the rate the actor's legs cross), and **specifics** (props and object interaction). The workflow has a name for its first step: **spotting** — watching the picture and writing down every sound that needs to exist, before recording or fetching anything.

The decision this note actually makes, and the one most edits get wrong, is not "add foley" but **what happens to the production sound underneath it**. Three options: keep it as a low bed, gate it out and replace it entirely, or keep it and add only what is missing. Each is right in a different situation, and the choice is measurable.

## When to use it
- **Whenever a physical action on screen has no usable sound**, which in single-camera self-shot content is nearly all of them: the mic was on the presenter's chest, so the coffee cup two feet away is inaudible while the shirt rustling on the lav is deafening.
- **When production sound is present but wrong in level** — the classic being cloth noise louder than the object interaction it accompanies. That inversion is not fixable with a fader; it needs replacement.
- **When the action is off-mic or off-camera.** Footsteps arriving before the person enters frame are pure foley and pure benefit.
- **When the dialogue track has been pause-stripped**, because stripping removes the incidental sounds along with the gaps ([[sfx-pause-removal-breath-and-room-tone]]).
- **When the picture will be re-versioned or dubbed.** Everything incidental recorded with the dialogue is lost with it, which is the industry's own reason foley exists as a discipline.
- **Not on a hero diegetic sound the mic caught well.** If the keyboard sounds right, use it — replacement for its own sake costs realism.
- **Not before the dialogue layer is fixed.** Layer 1 is a gate; foley on a bad voice track is decoration on a broken thing ([[sfx-dialogue-gate]]).
- **Not on every step.** A talking-head video does not need 400 footsteps. Spot the actions the *viewer's attention is on*, which is usually 5–20 per minute of B-roll and near zero over A-roll.

## How to recognise it in a reference video
- **Level inversion is the primary tell of an unfoleyed edit.** Measure the cloth/handling band against the object band on the same shot:
  ```bash
  ffmpeg -ss <t> -t 3 -i ref.wav -af "bandpass=f=400:width_type=o:w=2,astats=metadata=1:reset=0" -f null - 2>&1 | grep RMS_level
  ```
  In a foleyed edit, **object interaction sits above cloth by 6–12 dB**. In raw production sound the relationship is random and often inverted.
- **Perspective mismatch says "library file, placed well".** Foley is typically recorded close and dry, so a foleyed footstep on a wide shot sounds closer than the picture. In competent work that mismatch is corrected with level and a little reverb; in sloppy work a wide shot has intimate footsteps. Check whether the sound's apparent distance tracks the shot size across a sequence — if it does, someone did this deliberately.
- **Impossible cleanliness.** A single footstep with a clean onset, no room tone change and no neighbouring incidental noise is foley. Production footsteps arrive with the room attached.
- **Count the events against the picture.** Watch on mute and list every physical action; then listen and count how many are audible. The **coverage ratio** is the number to log: raw production sound typically covers 30–60% of visible actions; a foleyed edit covers 80–100% of the *attended* ones and deliberately ignores the rest.
- **Check for a production bed underneath.** In a speech gap, compare the noise floor during a foleyed action to the floor either side. **No change** means the production track was gated or muted and the foley is standing alone — which is the amateur signature, because the action then floats in a vacuum. **A continuous floor** means the production sound (or an ambience bed) is still there underneath.
- **Cloth continuity.** Cloth "moves" should be *continuous* under a moving body, not one event per gesture. A single cloth rustle per gesture with silence between reads as sound effects; a continuous low layer reads as a person.
- **Transcript corroboration:** in the source's own demonstration the foley layer is played in isolation, which is exactly how to build the analysis — split the reference into the layers you can and describe each ([[sfx-layer-stem-demo]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `spotting_granularity` | attended actions only | — | Spot what the viewer is looking at. Every action is a film-mix standard, not a YouTube one. |
| `events_per_minute` | 8 | 0–25 | Over B-roll. Over A-roll where the presenter is seated and talking, near zero — cloth and hands only. |
| `production_bed` | keep at −30 dB | −40 to −24 dB, or off | The default is **keep**. A gated production track under standalone foley is why home foley sounds fake. |
| `object_level` | 0.211 (≈−13.5 dB) | −16 to −11 dB | Object interaction: the hero of the foley layer, because it is what the viewer is looking at. |
| `footstep_level` | 0.126 (≈−18 dB) | −22 to −15 dB | Below objects. Footsteps read as present at surprisingly low levels; loud footsteps are the most common over-mix in the layer. |
| `cloth_level` | 0.079 (≈−22 dB) | −26 to −19 dB | The quietest element, and continuous rather than event-based. Above −19 dB it becomes the thing you hear. |
| `sync_tolerance` | ±1f | −1f to +2f | Frames at 30 fps. A foley event landing **early** reads as wrong far sooner than one landing late; bias late. |
| `footstep_anchor` | heel contact frame | — | Sync to the frame the foot *stops*, not the frame it starts moving. |
| `perspective_reverb_wet` | 0.10 close · 0.22 wide | 0.05–0.35 | Scale reverb with shot size so a wide shot's foley is not intimate. |
| `perspective_level_step` | −4 dB per shot-size step | −2 to −6 dB | Close → medium → wide. Or fetch the catalogue's `Distant` variant instead, which is better. |
| `room_tone_bed` | required | — | A continuous bed spanning the whole sequence so gated moments never expose a floor step. |
| `variants_per_repeating_action` | 4 | 3–8 | Footsteps especially: the same file twice in a row is instantly detected as a loop. |
| `keep_production` | true when the mic caught it well | — | Test: does the production sound have the right level relationship and the right perspective? If yes, keep it and spend the time elsewhere. |

## Reproduction prompt

```
Run a foley replacement pass over {{IN}}..{{OUT}}.

1. SPOT FIRST, WITH THE SOUND OFF. Watch the range muted and write a cue
   sheet: one row per physical action, with its frame, its category (FEET /
   MOVES / SPECIFICS), the surface or material, and whether the viewer's
   attention is on it. Do not open a sound library yet. This list is the
   deliverable of step 1 and everything else follows it.
2. TRIAGE AGAINST PRODUCTION SOUND. For each row, listen to what the
   production track already has:
   - Right level and right perspective -> KEEP. Mark the row "keep" and move
     on. Replacement for its own sake costs realism.
   - Present but wrong (cloth louder than the object, handling noise
     dominating) -> REPLACE.
   - Absent -> ADD.
   Only "replace" and "add" rows cost work.
3. DECIDE THE PRODUCTION BED, once, for the whole range. Default: keep the
   production track at -30 dB under the foley. Only gate it out if it carries
   a defect (a voice, traffic that contradicts the scene, a hum). If you do
   gate it, you MUST lay a room-tone bed in its place - foley over silence is
   the single loudest tell of home sound design.
4. FETCH BY CATEGORY, not by row. All footsteps for the sequence in one
   search, all cloth in another. Prefer files with Close / Distant variants
   so perspective is a fetch decision rather than a plugin decision.
5. PLACE, per row, peak on the action frame:
   - FEET: anchor to the frame the foot STOPS (heel contact), never the frame
     it starts moving. data-start = frame/30 - peak_t.
   - MOVES: a continuous low layer under the movement, not one event per
     gesture. Trim into a long cloth file with data-media-start.
   - SPECIFICS: peak on the contact frame.
   Bias late, never early: +1 to +2 frames is invisible, -2 frames is heard.
6. SET THE HIERARCHY, and do not deviate from it: objects -13.5 dB,
   footsteps -18 dB, cloth -22 dB, production bed -30 dB, all relative to
   dialogue at 0/-3 dB. If a footstep needs to be louder than an object, the
   picture is telling you the footstep IS the object - change the row, not the
   hierarchy.
7. SCALE PERSPECTIVE with shot size: -4 dB and +0.1 reverb wet per step from
   close to wide.
8. ROTATE repeating actions across at least 4 variants.

ACCEPTANCE TEST: play {{IN}}..{{OUT}} once at full speed. Every action the
viewer's eye lands on must have made a sound, and you must not be able to
name any single one of them as "a sound effect". Then play a 10-second
stretch and listen only to the noise floor: it must not step, gate or pump
at any foley event. If it does, the production bed or the room tone is
missing.
```

## Execution spec

**Epidemic Sound — fetch by category, and use the perspective descriptors.** Verified live 2026-08-28, the two workhorse slugs are `footsteps--human` and `cloth--movement`, and their titles are unusually specific — which is what makes a category fetch work:
```
# FEET - surface and footwear are in the title, so put them in the term
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["footsteps--human"]} },
                     query:{term:"sneakers concrete walk"}, first:24 }
#   real titles: "Footsteps, Human, Shoes, Concrete Walk" ·
#     "Footsteps, Human, Sneakers, Concrete, Walk, Close" ·
#     "Footsteps, Human, Sneakers, Concrete, Walk, Distant" ·
#     "Footsteps, Human, Boots, Concrete, Walk Fast" · "... Slipper, Concrete Walk"
#   >>> Close / Distant are real descriptors. Fetching the Distant variant for a
#       wide shot is better than adding reverb to the Close one.
# MOVES - long files, trim into them rather than fetching one per gesture
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["cloth--movement"]},
                              duration:{min:6000} }, first:24 }
#   real titles: "Cloth, Movement, Denim, Jeans, Pants, Walking" (29.9 s) ·
#     "Cloth, Movement, Coat, Jacket, Arm Movement, Walking" · "... Raincoat, Walking Fast, Marching"
# SPECIFICS - query the object and the interaction, not the emotion
#   "door handle open close" · "keyboard typing mechanical" · "cup ceramic table set down"
#   "paper page turn" · "zipper jacket" · "chair creak"
# THE BED
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["ambience--room-tone"]},
                              duration:{min:60000} }, first:24 }
SearchSimilarToSoundEffect { id:<uuid>, first:12 }        # the rotation set
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Footstep files are **walk cycles of 8–25 seconds**, not single steps: fetch one cycle and use `data-media-start` to pick individual steps out of it, which also gives natural variation for free. Same for cloth — a 30-second denim walk is a bed you trim into, not an event.

**HyperFrames — the arrangement, including the production bed.** The pattern that matters is that the production sound stays, quietly, underneath:
```html
<!-- picture, muted; production sound as its own low bed -->
<video id="shot-12" src="assets/broll/shot-12.mp4" class="clip" muted playsinline
       data-start="120.0" data-duration="6.0" data-media-start="0" data-track-index="0"></video>
<audio id="shot-12-prod" src="assets/broll/shot-12.mp4"
       data-audio-group="production" data-start="120.0" data-duration="6.0" data-media-start="0"
       data-track-index="15" data-volume="0.0316"></audio>   <!-- -30 dB bed -->

<!-- FEET: one step trimmed out of a walk cycle, peak on the heel-contact frame -->
<audio id="fol-step-31" src="assets/sfx/diegetic/footstep/footsteps_sneaker_concrete_close_01.wav"
       data-audio-group="foley" data-start="121.28" data-duration="0.30"
       data-media-start="3.42" data-track-index="16" data-volume="0.126"></audio>

<!-- MOVES: a continuous cloth layer, not one event per gesture -->
<audio id="fol-cloth-04" src="assets/sfx/diegetic/cloth/cloth_denim_walking_01.wav"
       data-audio-group="foley" data-start="120.0" data-duration="6.0"
       data-media-start="11.0" data-track-index="17" data-volume="0.079"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.3,&quot;v&quot;:1},{&quot;t&quot;:5.7,&quot;v&quot;:1},{&quot;t&quot;:6.0,&quot;v&quot;:0}]}]}"></audio>

<!-- the whole-sequence room tone, so nothing ever floats -->
<audio id="amb-room" src="assets/sfx/diegetic/room-tone/room_tone_office_ac_01.wav"
       data-audio-group="ambience" data-start="0" data-duration="600"
       data-track-index="14" data-volume="0.0316"></audio>

<!-- perspective for a wide shot, when no Distant variant exists -->
<!-- data-fx-chain: reverb {size:0.55, wet:0.22, dry:0.85} then limiter {limit:-1} -->
```
Contract points that decide whether this runs:
- **`data-media-start` is the tool that makes a walk cycle into individual steps** — trimming inside the composition needs no new file, and *"only cut a physical file when exporting/assembling outside the composition."*
- **Every `<audio>` needs an `id`.** An id-less `<audio>` is *never mixed → silent render*, with no error. With 40 foley clips this is the failure most likely to actually happen.
- **A `volume` lane's `t` is clip-local and holds its first value backwards to the clip start**, so the cloth bed's `t: 0` point is mandatory or it opens at full level.
- **`data-track-index` is display only** — it constrains nothing and does not layer anything (layering is CSS `z-index`, irrelevant for audio). Its one real effect: two `<audio>` sharing a track index *and* overlapping in time raise `duplicate_audio_track`. With many simultaneous foley clips, spread them across indices 16–19.
- **Groups matter for the carve.** Put foley in `foley`, production in `production`, room tone in `ambience` — and **never** any of them in `voiceover`: *"a bed or an SFX clip inside the named group poisons the next re-analysis silently."* The music bed carves against `voiceover` only.
- **A single-member `<hf-audio-group>` is legitimate for exactly one reason**: a bus's automation clock is **composition time** rather than clip-local, which is how you write one level envelope across a whole sequence of foley clips instead of per clip.
- **No automatic sync exists.** *"HyperFrames does not provide automatic waveform sync or drift correction."* Every foley event's frame is a number you write.

**ffmpeg — the two operations worth doing on files.** Gating the production bed is a mix decision, but measuring the level relationship is a file operation, and it is the measurement that makes the triage in step 2 objective:
```bash
# is cloth louder than objects on this shot? (400 Hz octave band vs 1-4 kHz)
ffmpeg -ss 120 -t 6 -i shot-12.mp4 -af "bandpass=f=400:width_type=o:w=2,astats=metadata=1:reset=0" -f null - 2>&1 | grep RMS_level
ffmpeg -ss 120 -t 6 -i shot-12.mp4 -af "bandpass=f=2000:width_type=o:w=2,astats=metadata=1:reset=0" -f null - 2>&1 | grep RMS_level
# extract the production audio once as a wav so the bed is not decoding the video repeatedly
ffmpeg -i shot-12.mp4 -vn -ac 2 -ar 48000 -c:a pcm_s24le shot-12-prod.wav
```
Do **not** bake the production bed's level with ffmpeg — the contract's rule is that ducking and gain are *declared* in the composition and baked only for assets leaving the pipeline.

**Remotion:** one `<Audio>` per foley event inside the shot's `<Sequence>`, with `startFrom` doing the job of `data-media-start`. Concept only; no Remotion runtime here.

## Pairs with
[[sfx-diegetic-action-inventory]] · [[sfx-substitute-material-foley]] · [[sfx-mouth-foley-record-and-process]] · [[sfx-missing-ambience-audit]] · [[sfx-pause-removal-breath-and-room-tone]] · [[sfx-dialogue-gate]] · [[sfx-layer-volume-targets]] · [[sfx-five-layers-build-order]] · [[sfx-filter-character-and-distance]] · [[sfx-reverb-glue]] · [[sfx-real-vs-invented-sound-rule]] · [[sfx-layer-stem-demo]] · [[sfx-air-on-micro-movement]] · [[sfx-sound-pass-order]] · [[cut-b-roll-coverage-from-transcript]] · [[sfx-foley-family]] · [[sfx-essential-sound-space-presets]]

## Failure modes
- **Foley over a gated production track with no room tone.** Every event floats in a vacuum and the floor steps around it. The loudest possible amateur signature. Fix: keep the production bed at −30 dB, or lay room tone if you must gate it.
- **Loud footsteps.** The most common over-mix in the layer, because footsteps are satisfying to place. They belong 4–5 dB *below* object interaction. Fix: the hierarchy is objects → feet → cloth, in that order, always.
- **Cloth as events.** One rustle per gesture with silence between reads as sound effects, not as a person. Fix: a continuous low cloth layer trimmed out of a long file.
- **Syncing footsteps to the frame the foot leaves the ground.** Lands the sound early, which is the direction the ear catches soonest. Fix: anchor on heel contact, bias +1 frame.
- **Perspective mismatch.** Intimate footsteps on a wide shot. Fix: fetch the catalogue's `Distant` variant, or −4 dB and +0.1 reverb wet per shot-size step.
- **Replacing sound that was already good.** Costs realism and time. Fix: the triage in step 2 exists to produce "keep" rows, and a pass with no "keep" rows was not triaged.
- **Foleying every action.** A film-mix standard applied to a nine-minute talking head; the result is busy and tiring, which is the source's own named overload mistake. Fix: spot the attended actions only, 8/min over B-roll.
- **The same footstep file twice in a row.** Instantly heard as a loop, and separately named as a mistake. Fix: trim different steps out of a walk cycle — free variation.
- **Putting foley in the `voiceover` group** so the music carve "hears" it. Silently poisons the next carve re-analysis. Fix: `data-audio-group="foley"`.
- **An id-less `<audio>`.** Never mixed, no error, silently missing from the render. With dozens of foley clips this is the most likely real-world failure. Fix: id on every one, checked by lint (`media_missing_id` is an error).
- **Known gap:** the level hierarchy (objects −13.5, feet −18, cloth −22 dB) is derived from the source's own three-tier framework (dialogue 0/−3, SFX −12/−15, music −20/−25) subdivided by which element the viewer's attention is on. No cited reference specifies per-foley-element levels; treat the *ordering* as the rule and the exact numbers as a defensible starting point to be checked against the reference profile's measured balance.
