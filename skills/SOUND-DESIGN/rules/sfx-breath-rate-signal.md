---
id: sfx-breath-rate-signal
title: Breath rate as the signal — slow reads as personal, fast reads as terrified
skill: sound-design
type: sfx
family: intimate-sounds
tags: [skill/sound-design, type/sfx, family/intimate-sounds, sfx/aesthetic, layer/sfx, layer/dialogue, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:54
    quote: "A fast heartbeat creates tension; slow breathing sounds can make a moment feel personal, and fast breathing tells you the guy is completely freaking out."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:41
    quote: "to elevate this type of emotion we generally use very intimate sounds — meaning the sounds that are only audible when you come very near or close."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:49
    quote: "Like heartbeat sounds, a clock ticking sound, or heavy breathing sounds."
research_refs:
  - https://en.wikipedia.org/wiki/Respiratory_rate
  - https://en.wikipedia.org/wiki/Tachypnea
  - https://en.wikipedia.org/wiki/Sound_effect
  - mcp://Epidemic_sounds/SearchSoundEffects (human--breath shelf and title grammar probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Breath rate as the signal — slow reads as personal, fast reads as terrified

## What it is
One asset family, two opposite meanings, selected entirely by **rate**. The source is precise about it: *"slow breathing sounds can make a moment feel personal, and fast breathing tells you the guy is completely freaking out."* Nothing about the recording changes — same voice, same mic distance, same file family — only breaths per minute, and the meaning inverts. That makes breath rate a genuinely continuous editorial control, the twin of the heartbeat dial in [[sfx-heartbeat-tension-dial]], and the proximity engineering it depends on lives in [[sfx-intimate-proximity-sounds]].

The reason the dial reads so reliably is that the audience carries the reference in their own chest. The clinical bands are published and the emotional bands sit exactly on top of them: *"the typical respiratory rate for a healthy adult at rest is 12–15 breaths per minute"* (an age table gives adults **15–18**), and **tachypnea** is *"a respiratory rate greater than normal, resulting in abnormally rapid and shallow breathing"* — above **20 breaths per minute** at rest, against a clinically normal range of **12–20**. So a designed breath layer at 10 is a person deliberately calm; at 16 it is neutral presence; at 24 it is a person who has crossed a clinical threshold the viewer's body recognises without being told; at 36 it is panic.

Two properties make breath harder to use than heartbeat, and they are the whole craft of this note.

**Breath occupies the voice's frequency range.** A heartbeat lives under 150 Hz and can sit beneath dialogue forever. Breath is broadband, weighted 200 Hz–6 kHz — the same region as speech. Under words it is not heard as breath, it is heard as **noise**, and the reflex fix (turn it up) makes the dialogue worse. Breath therefore has to be placed in **gaps**, not laid under a track.

**The subject is usually already breathing.** Production audio contains the speaker's real breaths, and a designed layer at a different rate on top of them produces two people breathing out of phase. This is the failure the research question points at, and the answer is a decision made before any asset is fetched: **replace, or place in silence — never overlay.**

**Style.** Filed `sfx/aesthetic` alongside [[sfx-heartbeat-tension-dial]]: the breath is in the mix for what its rate makes the viewer feel, not because a microphone in the room would have caught it. Where the subject is visibly breathing on camera the same asset is doing a diegetic job and is levelled as Foley ([[sfx-foley-replacement-pass]]).

## When to use it
- **A moment that should feel close and personal** — a confession, a slow push-in on a face, a quiet admission after a loud section. Slow breath (8–12 /min) collapses the distance between viewer and subject.
- **A moment of dread or panic**, with no dialogue and preferably no music — fast breath (26–40 /min) carries the whole emotional load. This is the "freaking out" case and it wants space, not layers.
- **As the ramp under a build**: start at 16 and accelerate to 30 across a 10–20 s build. A rate *change* is far more legible than any rate, because the viewer feels the acceleration the way they feel their own.
- **In a reenactment or dramatised sequence** where the subject's own audio is not present — that is the free case, because there is nothing to clash with.
- **After silence removal has stripped the speaker's real breaths.** If the edit removed them ([[sfx-pause-removal-breath-and-room-tone]]), a designed breath layer is not an effect, it is a repair.
- **Not under narration.** A breath layer under a talking-head voice is the single worst use: it masks consonants, cannot be heard as breath, and reads as a noisy recording.
- **Not on a wide shot.** Breath is a proximity cue; on a wide shot it contradicts the picture and reads as ADR.
- **Not in the same beat as a heartbeat layer** unless you have separated them by band and rate deliberately — two intimate rhythms at once is a horror-trailer cliché and they mask each other in the low-mids.

## How to recognise it in a reference video
- **Count breaths over 30 seconds and multiply by two.** That number is the finding. Log it alongside what the scene is doing. Anything below 12 or above 20 is a deliberate design choice.
- **Check whether the rate is constant or ramping.** Measure it in the first and last 15 s of the sequence separately. A ramp of **+8 to +15 breaths/min across 10–20 s** is a build; a constant rate is a state.
- **Look at where the breaths sit relative to speech.** In a designed layer they land **entirely in gaps** — inhale onsets never overlap a word. If breaths overlap words, you are hearing the subject's own production audio, not a designed layer, and that distinction changes the whole analysis.
- **Gap length test.** Measure the speech gaps that contain breaths. A designed breath needs **≥0.6 s** of clear space; if breaths appear in 0.25 s gaps, they are production audio.
- **Level.** Short-window RMS on a breath vs the dialogue. Personal/intimate use sits **−22 to −18 dB** under dialogue; a panic sequence carrying the scene alone sits **−14 to −10 dB**. A breath louder than −10 dB relative to the dialogue in the same scene is doing something stylised.
- **Proximity cues.** A designed intimate breath is **dry** (no audible tail), **bright** (no high-frequency roll-off), **bass-lifted** (proximity effect), and **centred and narrow**. If a breath has room on it, it is production audio from the location, not a placed layer.
- **Spectral check.** On a spectrogram a designed close breath shows a broad noise band 200 Hz–6 kHz with a visible envelope per cycle and near-zero reverberant smear. Production breath in a room shows the same band with a 100–300 ms tail.
- **Music behaviour.** In a competent panic beat the music **stops or thins** for the breath. Breath under a full bed is inaudible and therefore pointless; if the bed is running, the breath is decoration.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| **Rate — personal / intimate** | 10 /min | 6–12 /min | Cycle = **6.0 s** at 10 (`60 / rate`). Below 6 reads as sleep or unconsciousness. |
| **Rate — neutral presence** | 16 /min | 12–20 /min | Clinically normal (12–20). Reads as "a person is here", not as an emotion. |
| **Rate — agitated** | 24 /min | 20–28 /min | Above the tachypnea threshold of 20. Cycle = 2.5 s. |
| **Rate — panic / terror** | 34 /min | 28–45 /min | Cycle = 1.76 s at 34. Above 45 reads as comedic hyperventilation. |
| Cycle length | `60 / rate` seconds | — | 10→6.0 s · 16→3.75 s · 24→2.50 s · 34→1.76 s. |
| Audible inhale length | 0.7 s (slow) / 0.3 s (fast) | 0.2–1.1 s | Slow breath is mostly inhale; fast breath is mostly onset. |
| Ramp rate (build) | +12 /min across 15 s | +6 … +20 /min over 8–25 s | The acceleration is more legible than either endpoint. |
| Level — personal | −20 dB → `data-volume="0.1"` | −24 … −18 dB | Felt, not noticed. Same tier as the aesthetic layer. |
| Level — panic carrying the scene | −12 dB → `data-volume="0.251"` | −15 … −10 dB | Only when there is no dialogue and the music has thinned. |
| Minimum speech gap to place into | 0.6 s | 0.5–1.2 s | Below 0.5 s the breath is heard as noise on the words. |
| Overlap with a spoken word | **0 %** | — | Non-negotiable when the layer is designed. |
| Low-pass (distance / "through a wall") | none | 3–6 kHz when the shot is not close | Only if the picture is not intimate — otherwise brightness is the point. |
| High-pass | 80 Hz, `poles: 2` | 60–120 Hz | Removes handling rumble without touching the proximity weight. |
| Reverb `wet` | 0.02 | 0.00–0.06 | Dry is the dominant proximity cue. Anything above 0.08 puts the breath across the room. |
| Stereo image | mono / centre | — | A wide breath reads as a space around you, not as inside your head. Fold to mono before import — **there is no panner in the FX registry**. |
| Cycles per placement | 3–5 | 2–8 | Fewer than 2 is unreadable; more than 8 without a rate change habituates. |
| Music under a breath beat | thinned or stopped | −6 dB … off | A breath under a full bed is inaudible. |
| Coexistence with a heartbeat layer | avoid | — | If both, put the heartbeat under 150 Hz and low-pass it, and keep the rates non-harmonic. |

**Reading the Epidemic title grammar** — the shelf is unusually well-labelled, so the rate is usually decidable before you audition. Verified titles, 2026-08-28:

| Title contains | Reads as | Approx. rate |
|---|---|---|
| `Sleeping, Through Nose, Close, Calm` (149 s, 150 s) | deep calm, long-form bed | 6–10 /min |
| `Inhale & Exhale, Close, Calm, Deep Breaths` (18.7 s) | personal, intimate | 8–12 /min |
| `Male, Deep Breathing` (10.8 s) · `Female, Calm 02` (19.7 s) | neutral-to-calm | 10–14 /min |
| `Female, Sighs` (13.6 s) | emotional release, not a rate | one-shot |
| `Slow, Heavy, Long Breaths, Out Of Breath` (17.4 s) | recovering after exertion | 20–26 /min |
| `Panting, Less Out Of Breath` (26.3 s) | agitated | 24–30 /min |
| `Panting, Out Of Breath` (53.2 s) | exertion, long enough to ramp within | 30–40 /min |
| `Female, Panicked Breathing` (8.1 s) | terror | 32–45 /min |

## Reproduction prompt
```
Place a breath layer to carry {{EMOTION}} across {{T_IN}}-{{T_OUT}} (composition
seconds). 30 fps: 1 frame = 0.0333 s.

1. RESOLVE THE CLASH FIRST - before fetching anything. Does the subject's own
   production audio contain audible breaths in this window?
     YES and the subject is on camera close  -> DO NOT add a layer. Two breathing
        rates at once is unfixable. Ride the real breaths instead, or reshoot.
     YES but the subject is off-camera / wide / turned away -> mute or gate the
        production breaths first, then place the designed layer.
     NO (silence removal stripped them, or it is a reenactment) -> free. Proceed.

2. PICK THE RATE from the emotion, not from the file:
     personal / intimate  -> 10 /min   (cycle 6.00 s)
     neutral presence     -> 16 /min   (cycle 3.75 s)
     agitated             -> 24 /min   (cycle 2.50 s)   [above the clinical
                                                          tachypnea threshold of 20]
     panic / terror       -> 34 /min   (cycle 1.76 s)
   If this is a BUILD, pick a start and an end rate at least 8 apart and ramp.

3. FETCH BY TITLE. SearchSoundEffects tagSlugs ALL ["human--breath"], duration.min
   8000. Titles map to rate: "Close, Calm, Deep Breaths" ~10 · "Male, Deep Breathing"
   ~12 · "Slow, Heavy, Long Breaths, Out Of Breath" ~22 · "Panting, Less Out Of
   Breath" ~26 · "Panting, Out Of Breath" ~34 · "Panicked Breathing" ~38. Download
   WAV, then verify: cycles counted / file length * 60.

4. FIND THE GAPS. From the transcript word timings, list every speech gap >= 0.6 s in
   the window. Cycles go ONLY in these. Fewer gaps than cycles means the window is
   too talky for a breath layer - stop.

5. PLACE. Prefer ONE clip whose file already has the right rate (its irregularity is
   real); otherwise trim single cycles into the gaps with data-media-start. Level 0.1
   (-20 dB) personal, 0.251 (-12 dB) panic with no dialogue. Chain: highpass 80 Hz
   poles 2, reverb wet <= 0.02. No lowpass unless the shot is not close.

6. RAMP, if building. No pitch node exists and data-playback-rate is a pitch-preserved
   CONSTANT, so use three clips at 16 / 24 / 34 crossfaded 0.4 s, or bake one file
   with ffmpeg atempo.

7. MAKE ROOM. Thin or stop the music: an explicit v=1 point before the dip (a lane
   holds its first value backwards), then v=0.5 or 0.

ACCEPTANCE TEST.
(a) Count breaths over 30 s x2 in the finished mix: within +-2 of your chosen rate.
(b) No inhale onset overlaps a spoken word. Zero, not "few".
(c) Solo it: dry, bright, centred, close. A tail means the wrong room.
(d) Mute it: the moment loses emotion, not clarity. If the dialogue gets clearer, the
    layer was too loud or in the wrong place.
(e) No heartbeat layer at a harmonically related rate.
```

## Execution spec

**Placement spec (the three numbers).**

| | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Personal / intimate breath | no event to align to; cycles land **in speech gaps ≥0.6 s** | −20 dB (`data-volume` 0.1) | music −6 dB across the beat |
| Panic breath (carrying the scene) | first inhale onset 4–8 f before the cut into the beat | −12 dB (0.251) | music off, or thinned to a single stem |
| Ramp segments | crossfade 0.4 s between rate stages | steps of +2 dB per stage, ending at the target | music thins progressively |
| Sigh / release one-shot | on the frame the subject's shoulders drop, 0 to +2 f | −18 dB (0.126) | none |

**HyperFrames — either one clip with the right internal rate, or gap-placed cycles.** Prefer the first: a real recording's irregularity is what stops the layer sounding mechanical, and **render-time randomness is banned**, so you cannot generate irregularity at play time.

```html
<hf-audio-group id="sfx-intimate" data-label="Intimate" data-volume="1"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;i1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:80,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;i2&quot;,&quot;label&quot;:&quot;Barely a Room&quot;,&quot;params&quot;:{&quot;size&quot;:0.15,&quot;damping&quot;:0.7,&quot;wet&quot;:0.02,&quot;dry&quot;:1}}]}"></hf-audio-group>

<!-- personal: one 18.7 s "Close, Calm, Deep Breaths" file, ~10/min, under a slow push-in -->
<audio id="breath-calm" src=".media/audio/sfx/breath-close-calm.wav"
       data-audio-group="sfx-intimate" data-track-index="15"
       data-start="184.000" data-duration="17.000" data-media-start="0.900"
       data-volume="0.1"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.2,&quot;v&quot;:1},{&quot;t&quot;:15.2,&quot;v&quot;:1},{&quot;t&quot;:17.0,&quot;v&quot;:0}]}]}"></audio>

<!-- a three-stage rate ramp: 16 -> 24 -> 34 /min, 0.4 s overlaps, rising level -->
<audio id="breath-r1" src=".media/audio/sfx/breath-deep.wav"     data-audio-group="sfx-intimate"
       data-track-index="15" data-start="212.000" data-duration="5.400" data-volume="0.126"></audio>
<audio id="breath-r2" src=".media/audio/sfx/breath-panting-less.wav" data-audio-group="sfx-intimate"
       data-track-index="16" data-start="217.000" data-duration="5.400" data-volume="0.178"></audio>
<audio id="breath-r3" src=".media/audio/sfx/breath-panicked.wav" data-audio-group="sfx-intimate"
       data-track-index="15" data-start="222.000" data-duration="4.000" data-volume="0.251"></audio>
```

Contract points:
- **Consecutive ramp stages overlap by 0.4 s and therefore need different `data-track-index` values** — sharing an index while overlapping raises `duplicate_audio_track`. Alternating 15/16 handles it.
- **Every `<audio>` needs an `id`.** No id → never mixed → **silent render** (lint error).
- **The chain lives on the bus, not on each clip** — *"one chain, one fader, one automation clock for every member"* — which is what keeps three ramp stages sounding like one person.
- **`reverb` adds `chainTailSeconds`**, so a breath clip will ring very slightly past its `data-duration`. At `wet: 0.02` this is inaudible and expected.
- **A lane holds its first value backwards to the clip start**, hence the explicit `t:0, v:0`.
- **There is no pitch node and no rate envelope.** `data-playback-rate` is a constant `0.1..5` and **pitch-preserved**, so speeding a breath file up gives you a faster rate with an unnaturally unchanged timbre. For a genuine rate change, use separate files (above) or bake with ffmpeg.
- **No panner exists in the FX registry**, so "centred and narrow" must be baked: fold to mono before import.
- **Never put a breath clip in the `voiceover` group.** It would be analysed as speech by the carve and poison the next re-analysis silently.

**Epidemic Sound — one shelf, read by title.**

```
# the shelf: verified 1133 effects tagged human--breath, 2026-08-28
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ALL, values: ["human--breath"] },
            duration: { min: 8000 } },
  query: { term: "calm slow deep close" },
  sort: { by: POPULARITY, order: DESCENDING }, first: 12 }
# that exact filter returns 103 effects - a shelf small enough to audition properly.

# the panic end
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ALL, values: ["human--breath"] },
            duration: { min: 5000, max: 60000 } },
  query: { term: "panting panicked out of breath" }, first: 12 }

# the paired heartbeat, if the beat needs one - keep the rates non-harmonic
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["human--heartbeat"] } },
                     first: 8 }
```
`human--breath` and `human--heartbeat` both verified. **Read the title before auditioning** — the grammar is `Human, Breath, <gender>, <state>, <descriptors>` and the state word (`Calm`, `Deep`, `Slow`, `Panting`, `Panicked`, `Sighs`) is the rate. Prefer longer files (the two `Sleeping … Calm` entries run ~150 s) when you need a bed rather than a gesture — a long file removes the looping problem entirely. Always `DownloadSoundEffect` with `{"fileType":"WAV"}`; breath is high-frequency-heavy and lossy artefacts on a quiet layer are audible.

**ffmpeg — counting the rate, and the two edits the composition cannot do.**
```bash
# count cycles: the envelope peaks ARE the inhales
ffmpeg -i breath.wav -ar 48000 -af "asetnsamples=n=4800,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
# -> count peaks over the file length; rate = peaks / seconds * 60

# change the rate WITHOUT changing pitch (the honest ramp): 16/min -> 24/min = 1.5x
ffmpeg -i breath-deep.wav -af "atempo=1.5" breath-24.wav
# a continuous ramp needs a preprocessed asset - chain atempo segments and concat
ffmpeg -i breath.wav -af "atempo=1.0" p1.wav && ffmpeg -i breath.wav -af "atempo=1.3" p2.wav
printf "file '%s'\n" p1.wav p2.wav > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy breath.ramp.wav

# fold to mono and centre it, since there is no panner in-composition
ffmpeg -i breath.wav -ac 1 breath.mono.wav

# gate the subject's own breaths out of production audio before layering
ffmpeg -i vo.wav -af "agate=threshold=0.02:ratio=8:attack=5:release=120" vo.gated.wav
```
`atempo` is limited to 0.5–2.0 per instance; chain two for larger changes. Register derived files with `resolve --from <file> --type sfx --project .`

**Remotion.** One `<Audio>` per rate stage inside sequences, with `volume` as a function of frame for the ramp. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-intimate-proximity-sounds]] · [[sfx-heartbeat-tension-dial]] · [[sfx-felt-not-noticed]] · [[sfx-pause-removal-breath-and-room-tone]] · [[sfx-tone-bed-mystery]] · [[sfx-filter-character-and-distance]] · [[sfx-dialogue-gate]] · [[sfx-music-rest-windows]] · [[sfx-music-hard-stop]] · [[sfx-three-types-classification]] · [[sfx-mood-map-per-topic]] · [[sfx-noise-floor-target]] · [[cut-punch-in-emphasis]]

## Failure modes
- **Layering a designed breath over the subject's own breathing.** Two rates at once, out of phase, and no level setting fixes it. Decide before fetching: replace, or place in silence.
- **Breath under words.** It is not heard as breath, it is heard as a noisy recording, and raising it to fix that damages consonants. Every cycle goes in a gap of ≥0.6 s or it does not go in.
- **A rate that says nothing.** 14–18 /min is clinically normal and emotionally neutral: it adds presence, not meaning. If the intent is an emotion, get below 12 or above 20 — the thresholds are where the reading is.
- **A wet breath.** Reverb on an intimate sound moves it across the room and destroys the entire effect. `wet` ≤ 0.02, or none.
- **A wide breath.** Stereo width reads as a space around the listener; intimacy is mono and centred. Fold before import — there is no panner in-composition.
- **Looping one short cycle.** Human breathing is irregular; a 2 s loop is mechanical within three repeats, and you cannot randomise at render time. Use a long file, or hand-place cycles at irregular offsets.
- **Speeding a file up with `data-playback-rate` to raise the rate.** It is pitch-preserved, so a 1.5× breath has the timbre of a calm one at panic speed — uncanny rather than urgent. Use a different recording or bake with `atempo`.
- **Breath and heartbeat together at related rates.** They mask each other in the low-mids and read as a horror stock cue. Separate the bands (heartbeat low-passed under 150 Hz) and keep the rates non-harmonic, or use one.
- **Breath under a full music bed.** Inaudible, therefore pointless. If the music cannot thin, the beat does not want a breath layer.
- **Known gap — no pitch node, no rate envelope, no panner.** Rate ramps, formant changes and stereo placement must all be baked with ffmpeg before import. The vault cannot delete files, so keep the intermediates outside the mount.
