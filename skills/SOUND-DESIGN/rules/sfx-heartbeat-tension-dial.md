---
id: sfx-heartbeat-tension-dial
title: Heartbeat as a tension dial — the rate is the parameter, not the presence
skill: sound-design
type: sfx
family: intimate-sounds
tags: [skill/sound-design, type/sfx, family/intimate-sounds, engine/epidemic, engine/hyperframes, engine/ffmpeg, sfx/aesthetic, layer/design, layer/sfx, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:41
    quote: "[older pass only] to elevate this type of emotion we generally use very intimate sounds — meaning the sounds that are only audible when you come very near or close."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:49
    quote: "Like heartbeat sounds, a clock ticking sound, or heavy breathing sounds."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:54
    quote: "A fast heartbeat creates tension; slow breathing sounds can make a moment feel personal, and fast breathing tells you the guy is completely freaking out."
research_refs:
  - https://en.wikipedia.org/wiki/Heart_rate
  - https://en.wikipedia.org/wiki/Auditory_masking
  - mcp://Epidemic_sounds/SearchSoundEffects (human--heartbeat enumerated live, 39 assets, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Heartbeat as a tension dial — the rate is the parameter, not the presence

## What it is
The seventh family in the source's catalogue is **intimate sounds** — *"the sounds that are only audible when you come very near or close"* — and the insight buried in its worked example is that these sounds carry meaning through **rate**, not through presence. *"A fast heartbeat creates tension; slow breathing sounds can make a moment feel personal, and fast breathing tells you the guy is completely freaking out."* The same file at two tempos says two different things. That makes BPM a continuous editorial control, which is rare in sound design and worth exploiting deliberately.

The dial is calibrated by physiology, and the numbers are not arbitrary. The normal adult resting rate is **60–100 bpm** (American Heart Association; more recent evidence puts the normal range at **50–90**). **Bradycardia is *"a low heart rate, defined as below 60 bpm at rest"***; **tachycardia is *"a high heart rate, defined as above 100 bpm at rest."*** During sleep *"a heartbeat with rates around 40–50 bpm is common and considered normal."* Those clinical boundaries map directly onto emotional register, because the audience carries the same reference in their own chest:

| Rate | Clinical reading | What it says on screen |
|---|---|---|
| 39–45 | sleep / deep bradycardia | dissociation, slow motion, dying, dream |
| 54–65 | resting, low-normal | calm, intimacy, a private moment |
| 75–83 | resting, high-normal | alert, mild unease, something noticed |
| 100–115 | tachycardia | tension, fear, exertion |
| 125+ | marked tachycardia | panic |

The second half of the technique is the **transition** between rungs, and this is where most implementations fail. A heart rate that jumps from 65 to 115 at a cut is a different body; a heart rate that ramps continuously is a body under stress. The stack cannot ramp — `data-playback-rate` is *"a **constant** in `0.1..5`"* and *"no rate envelope exists"* — so a continuous accelerando must either be **preprocessed** or **stepped and masked**, and stepping turns out to be the better answer anyway, because the catalogue ships pre-recorded rungs at exactly the right intervals.

## When to use it
- **A stretch that must feel dangerous but has no event to sound.** The same brief as a tone bed, and the two stack well ([[sfx-tone-bed-mystery]]) — the drone supplies the dread, the heartbeat supplies the body.
- **The final third of a cross cut**, as the intimate layer that turns "two things are happening" into "something is about to happen to someone" ([[sfx-cross-cut-audio-strategy]]).
- **The run-up to a reveal**, underneath a riser rather than instead of one. A riser says *something is coming*; a heartbeat says *it is coming for you*.
- **A close-up held longer than comfortable.** The rate justifies the hold.
- **An intimate, quiet moment** — at 54–65, not fast. The source is explicit that the slow end reads as *personal*, not as tense.
- **Not with a visible on-screen pulse it contradicts.** If a chest, a monitor or an animation is visibly beating, the sound must match its rate or the mismatch is the only thing anyone notices.
- **Not for more than about 25 seconds at one rate.** A static heartbeat stops being felt faster than almost any other bed, because it is metrically predictable.
- **Not under a music bed with a strong kick.** Two low-frequency pulses at different tempos is polyrhythm, and it reads as a mistake. Drop to the `INSTRUMENTS` stem or drop the heartbeat.
- **Not at a level where it can be named.** A heartbeat you hear is a horror-film cliché; a heartbeat you feel is tension.

## How to recognise it in a reference video
- **Look in the 20–80 Hz band, not in the mix.** A heartbeat is almost entirely Rumble and Weight band energy. Low-pass the reference at 120 Hz and the pulse becomes obvious even when it is inaudible in the full mix:
  ```bash
  ffmpeg -i ref.wav -af "lowpass=f=120:poles=2,volume=12dB" ref.sub.wav
  ```
- **Measure its rate.** Print a 50 ms RMS trace of the low-passed track and count peak-to-peak intervals: `BPM = 60 / mean_interval_seconds`. Report the number, not "there's a heartbeat" — the number is the whole technique.
- **Check for the double-thump.** A real heartbeat is lub-dub: two transients about **0.25–0.35 s apart** repeating at the stated rate. A single-transient pulse at the same tempo is a kick drum or a designed sub hit, not a heartbeat, and it is doing a different job ([[sfx-bass-drop-under-impact]]).
- **Track the rate across the sequence.** Log BPM in each 10 s window. A dial that is being *used* shows a monotonic rise in 10–25% steps; a heartbeat that was simply dropped in shows one constant value for its whole duration.
- **Find the step points.** If the rate changes, note where. A competent implementation changes rate **on a picture cut or under a transient**, never in the middle of a held shot ([[sfx-transient-masked-outpoint]]).
- **Check the level against dialogue.** Measure the low-passed heartbeat's RMS against the dialogue's. Expect **−24 to −16 dB**; anything above −14 dB is being used as an effect rather than as a bed, which is a legitimate but different choice — log which.
- **Check whether a beat lands on the cut.** In tightly designed sequences the beat and the picture cut coincide within 2 frames. That coincidence is deliberate and is worth reproducing.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `bpm` | 100 | 39–125 | The dial. Pick from the catalogue's own rungs (see Execution spec) rather than retiming a file. |
| `rung_ladder` | 65 → 83 → 100 → 115 → 125 | — | Ratios 1.28 / 1.20 / 1.15 / 1.09. Each step is large enough to be felt and small enough to read as the same body. |
| `step_size` | 15–25% | 10–30% | Under 10% the change is not perceived; over 30% it reads as a different person. |
| `step_masking` | on a picture cut | ±2f of a cut or transient | A rate change in a held shot is heard as an edit. |
| `hold_per_rung` | 8 s | 5–20 s | Long enough to register, short enough not to habituate. |
| `total_duration` | 20 s | 6–45 s | Past ~25 s at one rate the bed stops being felt; ladder or stop. |
| `level_rel_dialogue` | −20 dB (`data-volume` 0.100) | −24 to −16 dB | Below the standard SFX window (−12/−15) because it is a bed, and because low-frequency maskers *"are effective over a wide frequency range."* |
| `highpass` | 30 Hz | 25–40 Hz | Removes sub-audible content that costs master headroom and is never heard. |
| `lowpass` | 200 Hz | 140–400 Hz | Keeps the pulse entirely out of the speech band. A heartbeat with audible click competes with consonants. |
| `beat_on_cut` | yes | yes/no | Align one beat to the sequence's key cut, ±2f. Costs nothing, reads as intent. |
| `lub_dub_gap` | 0.30 s | 0.25–0.35 s | Only relevant if building a beat from one-shots. Outside this window it stops sounding like a heart. |
| `fade_in` | 3 s | 2–6 s | Same rule as any bed — the viewer must not hear it start ([[sfx-tone-bed-mystery]]). |
| `fade_out` | 0.2 s under a transient, else 2 s | — | Ending a heartbeat on a hit is the strongest exit available. |

## Reproduction prompt

```
Install a heartbeat tension dial under the sequence {{IN}} to {{OUT}}
(seconds), rising from {{START_BPM}} to {{END_BPM}}.

1. PICK THE RUNGS FROM PHYSIOLOGY, NOT FROM TASTE:
   39-45  dissociation / slow motion / dying   54-65  calm, intimate
   75-83  alert, mild unease                   100-115 tension, fear
   125+   panic
   If {{START_BPM}} and {{END_BPM}} are both inside one band, you do not
   need a ladder - use one clip.
2. BUILD THE LADDER from the catalogue's own pre-recorded rates. Do NOT
   retime one file: a rate change alters the thump's decay and the result
   stops sounding like a chest. Steps of 15-25%; the natural ladder is
   65 -> 83 -> 100 -> 115 -> 125.
3. FIND THE MASK POINTS. List every picture cut and every loud transient
   between {{IN}} and {{OUT}}. Each rung change must land within 2 frames
   of one. If there are fewer cuts than rungs, use fewer rungs - never
   change rate in a held shot.
4. PLACE EACH RUNG as its own clip, butted end to end at the mask points,
   in the "design" audio group, on a track index of 14+. Give every clip
   an id. Overlap consecutive rungs by 0.1 s and crossfade so the join is
   a beat, not a gap.
5. FILTER EVERY RUNG IDENTICALLY: high-pass 30 Hz, low-pass 200 Hz,
   limiter last. Identical filtering is what makes five clips read as one
   body.
6. LEVEL at -20 dB relative to dialogue (linear 0.100) and keep it the
   same on every rung. Do NOT make the fast rungs louder - the rate is the
   dial; loudness is not. Raising level with rate is how this reads as a
   horror cliche.
7. FADE IN over 3 s with an explicit t=0 point at v=0. END ON A TRANSIENT
   if there is one within 12 frames of {{OUT}} - cut to zero over 0.2 s
   under it. Otherwise fade out over 2 s.
8. ALIGN ONE BEAT TO THE KEY CUT. Measure the first beat's offset from the
   file head and set data-media-start so a thump lands within 2 frames of
   the sequence's most important cut.
9. CHECK AGAINST THE MUSIC. If the bed has a kick, the two pulses will
   fight. Switch the music to its INSTRUMENTS stem for the duration, or
   drop the heartbeat. Two low-frequency pulses at different tempos is
   always wrong.

ACCEPTANCE TEST: play {{IN}} to {{OUT}} once at normal volume. You should
feel the sequence tighten and NOT be able to say when the rate changed. Then
low-pass the mix at 120 Hz and play it again: the ladder must be obvious,
monotonic, and every step must sit on a cut. If a step is audible in the
full mix, it was not masked; move it onto the nearest cut.
```

## Execution spec

**Epidemic Sound — the catalogue does the retiming for you.** This is the finding that changes the technique. Probed live 2026-08-28, `human--heartbeat` holds exactly **39 assets**, and they include **three complete BPM ladders** of 60-second files, each rung recorded rather than stretched:

```
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["human--heartbeat"]} },
                     sort:{by:TITLE, order:ASCENDING}, first:40 }
# live 2026-08-28 -> meta.total 39, one page, the whole family.
```
The rungs, verified by title:

| Family | Rates available | Duration | Character |
|---|---|---|---|
| `Human, Heartbeat, <N> Beats Per Minute` | 39, 54, 58, 65, 75, 101, 115 | 60 s | plain, recorded |
| `Human, Heartbeat, Cinematic, <N> BPM` | 39, 45, 54, 58, 65, 75, 83, 100, 115, 125 | 60–65 s | processed, more sub |
| `Human, Heartbeat, Clicky, <N> BPM` | 45, 54, 58, 65, 75, 83, 100, 115, 125 | 60 s | transient-forward, cuts through a busy mix |

**Use the `Cinematic` family as the default** — it has all ten rungs, which means an entire ladder can be built from one consistent set. Do not mix families mid-ladder; the thump's character changes and it reads as a different body.

Also in the family and worth knowing:
- `Human, Heartbeat, Through Chest, Irregular, Getting Faster` (15 293 ms) — **a pre-made accelerando**. When the ladder is short and the sequence is under 15 s, this single file beats building one.
- `Human, Heartbeat, Eerie Heartbeat, Muffled` (180 033 ms) — a three-minute bed for a long low-tension passage.
- `Human, Heartbeat, Designed, Evil Heartbeat, Fat Bass` (28 134 ms) — heavily processed; treat as a design element, not as a body.
- `Human, Heartbeat, Hearthbeat, Contact Mic` (60 218 ms) — a contact-mic perspective, dry and close; the right choice when the shot is a close-up.
- `Human, Heartbeat, Designed, Heartbeats, Loopable 01/02/03` (2 925 / 2 827 / 2 540 ms) — short loopable cells, for when you need a rate the ladder does not have. They need a crossfaded loop, not a butt join.
- `Human, Heartbeat, Slow Motion, Breathing` (59 350 ms) — the breathing half of the same family, for the source's *"slow breathing... personal"* case.
- `Human, Heartbeat, Through Chest, Steady Rhythm` (10 117 ms) and `Human, Heartbeat` (9 828 ms) — short, for a single moment.

```
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
# ladder ids verified live 2026-08-28 (Cinematic family):
#   65 BPM  c8e198d7-e5d4-4fe9-b333-65c9479ac11c
#   83 BPM  55992b90-5d63-410a-89a8-5a90add60539
#   100 BPM 3b450a60-4050-425a-b757-edb650ce881e
#   115 BPM 38e59250-c6a2-4fda-8ee1-7c416d6e6d2c
#   125 BPM bd398989-bf31-42ce-8695-7bcd5b2edbeb
```
**WAV, not mp3** — you are aligning a low-frequency transient to a picture cut, and mp3 pre-echo smears exactly that.

**HyperFrames.** One clip per rung, butted at mask points, identically filtered. Sequence 120.0 → 148.0 s with cuts at 128.0, 136.0 and 142.0:

```html
<audio id="hb-65"  src="assets/sfx/design/heartbeat_cine_65.wav"  data-audio-group="design"
       data-start="120.0" data-duration="8.1" data-media-start="4.0"
       data-track-index="15" data-volume="0.100"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;params&quot;:{&quot;frequency&quot;:30,&quot;poles&quot;:&quot;2&quot;}},
         {&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;frequency&quot;:200,&quot;poles&quot;:&quot;2&quot;}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:3,&quot;v&quot;:1},{&quot;t&quot;:8.1,&quot;v&quot;:1}]}]}"></audio>

<audio id="hb-100" src="assets/sfx/design/heartbeat_cine_100.wav" data-audio-group="design"
       data-start="128.0" data-duration="8.1" data-media-start="2.4"
       data-track-index="16" data-volume="0.100"
       data-fx-chain="… the same three nodes as #hb-65: highpass 30 / lowpass 200 / limiter …"></audio>

<audio id="hb-125" src="assets/sfx/design/heartbeat_cine_125.wav" data-audio-group="design"
       data-start="136.0" data-duration="12.0" data-media-start="0.6"
       data-track-index="15" data-volume="0.100"
       data-fx-chain="… the same three nodes as #hb-65: highpass 30 / lowpass 200 / limiter …"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:11.8,&quot;v&quot;:1},{&quot;t&quot;:12.0,&quot;v&quot;:0}]}]}"></audio>
```
Contract points that decide whether this runs. Each rung's `data-media-start` is what puts a **beat on the cut**: measure the first thump's offset in the file, then solve `data-media-start = first_beat_offset − (desired_beat_time − data-start)` modulo the beat period. Every `<audio>` **needs an `id`** or it is never mixed. `data-track-index` is *"display only"* and clips may overlap, so the 0.1 s crossfade between rungs is legal on any index — alternating 15/16 just keeps the Studio timeline readable. Every lane needs its explicit `t:0` point because *"a lane holds its first value backwards to the start of its clip"* — without it the 65 BPM rung starts at full level and the 3 s fade does nothing. `limiter` last, per the chain-order doctrine. Keep the heartbeat in `design`, **never** in the `voiceover` carve group — a non-voice clip in that group *"poisons the next re-analysis silently."*

**What this stack cannot do, and the workaround.** There is **no rate envelope**: `data-playback-rate` is a constant in `0.1..5`, and *"source speed ramps are not supported because there is no rate envelope; preprocess a derived synchronized asset."* So a smooth accelerando is a preprocessing job:
```bash
# constant retime, pitch-changing (asetrate) - AVOID for heartbeats, it thins the thump
# constant retime, pitch-preserving - acceptable for small adjustments only (<=10%)
ffmpeg -i heartbeat_cine_100.wav -af "atempo=1.15" heartbeat_115ish.wav

# a real accelerando: cut rungs and crossfade them into one asset, then place one clip
ffmpeg -i hb65.wav -i hb83.wav -filter_complex "acrossfade=d=0.6:c1=tri:c2=tri" a.wav
ffmpeg -i a.wav   -i hb100.wav -filter_complex "acrossfade=d=0.6:c1=tri:c2=tri" b.wav
ffmpeg -i b.wav   -i hb125.wav -filter_complex "acrossfade=d=0.6:c1=tri:c2=tri" hb_ramp.wav

# measure a file's actual rate before trusting its title
ffmpeg -i hb.wav -af "lowpass=f=120,asetnsamples=n=2400,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
```
`atempo` is valid only in 0.5–2.0; chain two instances for anything outside that. Use `c1=tri` for a heartbeat crossfade rather than `qsin` — a triangular fade keeps the intermediate beats from doubling in level. Keep intermediates **outside the mounted vault**, which cannot delete files.

**Remotion.** A sequence of `<Audio>` components with `startFrom` per rung; a continuous ramp requires the same pre-rendered asset. Concept only.

## Pairs with
[[sfx-cross-cut-audio-strategy]] · [[sfx-tone-bed-mystery]] · [[sfx-riser-anticipation-build]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-bass-drop-under-impact]] · [[sfx-intensify-without-referent]] · [[sfx-felt-not-noticed]] · [[sfx-transient-masked-outpoint]] · [[sfx-filter-character-and-distance]] · [[sfx-music-stem-layering]] · [[sfx-layer-volume-targets]] · [[sfx-repetition-variant-rotation]] · [[struct-cross-cutting-parallel-action]] · [[pace-cross-cut-acceleration]]

## Failure modes
- **Rate constant for the whole sequence.** The dial exists and was not turned; the bed habituates within about 25 s and stops doing anything. Fix: build a ladder, even a two-rung one.
- **Rate change in a held shot.** Heard as an edit rather than as a body. Fix: every rung change within 2 frames of a picture cut or a loud transient.
- **Retiming one file instead of using recorded rungs.** A large `atempo` shift alters the thump's decay and the pulse stops reading as a chest. Fix: the catalogue has ten rungs; use them. Retime only for adjustments under 10%.
- **Mixing the Cinematic, Clicky and plain families inside one ladder.** Different character per rung reads as different people. Fix: pick one family and stay in it.
- **Raising the level with the rate.** Loudness is not the dial. Fix: identical `data-volume` on every rung.
- **Too loud.** A heartbeat you can name is a cliché. Fix: −20 dB relative to dialogue, and low-pass at 200 Hz so its click cannot compete with consonants.
- **No high-pass.** Heartbeat files carry 20–30 Hz energy that no viewer's device reproduces but every limiter reacts to, shrinking the whole mix. Fix: high-pass at 30 Hz.
- **Running it against a music bed with a kick.** Two sub-band pulses at different tempos is polyrhythm and reads as a fault. Fix: `INSTRUMENTS` stem for the duration, or no heartbeat.
- **Contradicting a visible pulse.** If a chest or a monitor is beating on screen, the audio must match. Fix: measure the picture's rate first and pick the nearest rung.
- **Butt-joining rungs with no crossfade.** Produces a gap or a doubled beat exactly at the moment of highest attention. Fix: 0.1 s overlap, triangular crossfade.
- **Known gap:** the stack has **no rate envelope**, so a genuinely continuous accelerando cannot be authored in a composition — it must be baked with ffmpeg and placed as one clip, or approximated with the masked ladder. Say which one the design document is using; they are not interchangeable and the ladder is cheaper.
