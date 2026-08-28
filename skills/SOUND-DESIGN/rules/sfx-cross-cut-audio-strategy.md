---
id: sfx-cross-cut-audio-strategy
aliases: [sfx-cross-cut-tension-bed]
title: One bed, two worlds — the audio architecture of a cross-cut sequence
skill: sound-design
type: music
family: parallel-action
tags: [skill/sound-design, type/music, family/parallel-action, layer/music, layer/ambience, layer/sfx, sfx/aesthetic, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/editing-kt-2, source/sfx-kt-1, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:35"
    quote: "Cross cutting is when the editor is cutting back and forth between multiple scenes, usually at the same time."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:44"
    quote: "This is a common technique used in thriller style movies."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:02:53"
    quote: "And it's the one single layer that can carry an entire video on its own."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:05:41"
    quote: "To elevate this type of emotion we generally use very intimate sounds — meaning the sounds that are only audible when you come very near or close."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:05:54"
    quote: "A fast heartbeat creates tension; slow breathing sounds can make a moment feel personal, and fast breathing tells you the guy is completely freaking out."
research_refs:
  - https://www.studiobinder.com/blog/cross-cutting-parallel-editing-definition/
  - https://www.nfi.edu/cross-cutting/
  - https://en.wikipedia.org/wiki/Cross-cutting
  - https://en.wikipedia.org/wiki/Diegetic_music
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://www.boomlibrary.com/blog/sound-design-voice-over-and-music-for-film-trailers/
  - https://hearinghealthmatters.org/pathways-society/2015/unmasking-auditory-temporal-masking/
  - https://en.wikipedia.org/wiki/Auditory_masking
  - mcp://Epidemic_sounds/SearchSoundEffects (heartbeat / clock tick / breath / room-tone families probed live, 2026-08-27)
difficulty: high
detectable_from: audio
---

# One bed, two worlds — the audio architecture of a cross-cut sequence

## What it is
A cross cut asks the audience to hold two places in mind at once. The sound decides whether that feels like **one event with two views** or like **channel-hopping**. Picture alone cannot say it; sound is what does.

The architecture is a contradiction held on purpose, and it is asymmetric:

- **One continuous layer that never cuts** — the music bed, and any design tone under it. It does not know there are two places, so its unbroken presence tells the ear that the two strands share a clock. This is the layer that asserts *one event*.
- **Per-strand layers that change on every seam** — ambience, room tone, foley, phone futz. They carry difference: they tell the ear *which* place. This is the layer that asserts *two locations*.

Get either half wrong and the sequence fails a specific way: continuous everything reads as one flat scene, discontinuous everything reads as random intercutting. A bed that restarts per strand, or an ambience that stays constant across two locations, is the single most common reason a technically correct cross cut feels flat.

The tension is then built with two knobs that picture and sound share: the strand blocks get shorter as the strands converge, and an **intimate layer** — heartbeat, ticking clock, close breath, *"sounds that are only audible when you come very near or close"* — fades up underneath in the final third. The intimate layer is what turns "two things are happening" into "something is about to happen to someone".

## When to use it
Any time [[pace-cross-cut-acceleration]] or [[struct-cross-cutting-parallel-action]] is in play, and specifically once segments drop below about **60 f (2 s)**. Above that length a strand can carry its own sound world unaided; below it, the ambience swaps arrive faster than the ear can re-orient and the architecture has to do the work.

- **Any convergence:** a chase, a deadline, a rescue, a countdown, two people about to meet or collide. Use the full version — continuous bed, dual ambience, intimate layer, convergence marker — on a genuine tension build.
- **Two-location conversations** where the tension is dramatic rather than practical. For the practical case (a phone call, whose ear are we in) use [[sfx-phone-call-cross-cut-treatment]], which owns the futz and perspective rules.
- **Non-fiction analogues:** the demo running against the clock while the presenter explains; the before-shot cutting against the after-shot; two competing approaches shown in parallel.
- **Reduced version** — continuous bed, single shared ambience — where the two strands are in the same acoustic space (two rooms of one house, two people on one street), because there swapping ambience is a lie the ear catches.
- **Not for a simple A/B comparison** with no convergence and no stakes. There is nothing for the intimate layer to be about, and the accelerating block schedule will just feel restless.
- **Do not** carry a music bed across a cross cut whose whole point is a contrast of register (a comic cut between a funeral and a party); there the collision of two sound worlds is the joke and continuity would kill it.

## How to recognise it in a reference video
- **Bed continuity test.** Trace short-term loudness across the sequence and check the music never resets:
  ```bash
  ffmpeg -i ref.mp4 -af "ebur128=peak=true:framelog=verbose" -f null - 2>&1 | grep "S:"
  ```
  A continuous bed shows a smooth or monotonically rising curve through many picture cuts. Steps that coincide with picture cuts mean the bed is being cut with the strands — log that as the failure signature. The finer version of the same test: at each cut compare the spectral content of the 200 ms either side; a harmonic bed continuing unbroken while broadband/noise content changes abruptly *is* this architecture.
- **Beat-grid test.** Estimate the bed's BPM and check whether the picture cuts sit on or off the grid. A cross cut whose cuts land on the grid throughout is scored to the music; one that drifts is scored under it. Both are valid; log which.
- **Measure the block schedule.** Log the duration of each strand block in order. A tension cross cut shows a monotone decreasing series — typically **4–6 s** for the first blocks, roughly halving every two exchanges, with a floor around **0.8–1.2 s** before the convergence.
- **Ambience swap test.** Band-limit and trace per frame; room tone lives mostly below 500 Hz and above 4 kHz, where music and voice do not dominate:
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "highpass=f=4000,asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  (`n=1600` at 48 kHz = one frame at 30 fps.) A per-strand architecture shows a **repeating two-level pattern** in this trace, alternating with the picture; a shared-ambience architecture shows a flat line.
- **Then decide which of the two swap schools the reference belongs to** — this is the reading that matters most, and the two are audibly different:
  - **Dominance swap.** Both ambiences run continuously; the departing one drops to roughly **−12 to −18 dB** below the arriving one and stays audible, over a **4–9 f (0.13–0.30 s)** ramp. The tell is a floor that never reaches the noise floor between swaps.
  - **Hard swap.** One ambience clip per block, changing character on the cut frame with **no crossfade**, the departing strand genuinely absent. The tell is a true two-state trace with silence-adjacent troughs. This is the thriller convention.
  A 2–4 frame crossfade in a hard-swap reference means the two ambiences were tonally close and the editor smoothed the seam. Log which school, and the ramp length; they are different rules, not one rule measured badly.
- **Rate of sonic event.** Count discrete sound events (hits, impacts, footsteps, percussion accents) per 10 s across the sequence. In a working tension build this **rises in step with the picture's cutting rate**. If picture accelerates and event density is flat, the sequence feels mechanical.
- **Find the intimate layer and time its entrance.** Heartbeat (a 40–160 Hz double thump), clock tick (a sharp 2–5 kHz transient at a metronomic interval), or close breath. It typically enters in the **last third**, 8–20 s from the convergence, and rises 6–10 dB across that span. Check its rate against the cutting rate: in matched work the heartbeat accelerates as blocks shorten. A fixed-rate heartbeat under an accelerating cut is a stock loop dropped in.
- **Convergence markers.** Listen at the frame the strands meet for one of three signatures: a hit/impact ([[sfx-cinematic-hit-emphasis]]), a music drop into silence ([[sfx-music-hard-stop]]), or a riser resolving ([[sfx-riser-to-music-drop-backtiming]]). A convergence with no audio marker is a missed payoff, and absence of that landing is the commonest structural failure. Then listen for the **release**: 0.8–1.5 s of bed-only or near-silence after it.
- **Levels.** Reference values for a mixed sequence: dialogue **0 to −3 dB**, music **−20 to −25 dB** under narration and up to **−8 to −12 dB** in narration-free stretches, SFX **−12 to −15 dB**, ambience **−24 to −30 dB** relative to dialogue, which lands roughly **−30 to −36 dBFS** as an absolute floor.
- **Transcript check:** dialogue thins out as blocks shorten. If the presenter is still talking at 1 s blocks, the sequence is being carried by the voice, not by the cut, and the sound design should be re-scoped.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `bed_continuity` | one unbroken bed | — | The bed spans the whole sequence and never cuts with the picture. Non-negotiable for simultaneity. If the bed must change character at the convergence, change it by level or by adding a stem, never by a cut. |
| `bed_level` | −22 dB rel. voice (`0.079`) | −20 to −25 dB · −8 to −12 dB where there is no voice | Loud guitar-led tracks sit nearer −30 dB. |
| `bed_arc` | rising | rising \| flat | Choose a track with a built-in build, or automate a +4 to +6 dB rise across the sequence. |
| `swap_school` | dominance | dominance \| hard | **The one genuine architectural fork, and the two source conventions disagree because they are solving different problems.** Choose *dominance* when simultaneity is the point (parallel action, non-fiction comparison), when the two locations are acoustically near each other, or when blocks are already under ~2 s — a hard swap at that rate strobes. Choose *hard* when the contrast of place is the point (the thriller convention), the two rooms are spectrally far apart, and blocks are still ≥1 s. |
| `ambience_dominant` | 0 dB (reference) | — | The arriving strand's ambience. |
| `ambience_secondary` | −15 dB | −12 to −18 dB | Dominance school only: the departing strand's ambience, held audible under the cut. Never fully off. |
| `ambience_level` | −26 dB (`0.05`) | −30 to −24 dB rel. dialogue | Absolute: roughly −30 to −36 dBFS. Present but never nameable. |
| `swap_ramp` | 6 f (0.20 s) dominance · 0 f hard | 4–9 f dominance · 0–4 f hard | Dominance: crossfade between the two levels at each strand cut. Hard: 0 f by default; add 2–4 f only to kill an audible click where the beds share tonal content. |
| `first_block_len` | 5 s | 4–6 s | |
| `block_decay` | ×0.7 per exchange | ×0.6–0.85 | Halving roughly every two exchanges. |
| `floor_block_len` | 1.0 s | 0.8–1.2 s | Below ~0.7 s the ambience swap stops being legible and just sounds like noise modulation. |
| `sfx_level` | −13 dB | −12 to −15 dB | Motion and diegetic events. Hits may sit 2–4 dB above. |
| `event_density_slope` | rising with cut rate | — | Discrete sound events per 10 s should track the picture's acceleration. Keep 1–2 events per block as blocks shorten; do not fit the same count into a shorter window. |
| `intimate_layer_entry` | last third, ~12 s out | 8–20 s out | Heartbeat, clock tick or close breath. |
| `intimate_layer_level` | −24 dB → −16 dB (`0.063` → `0.158`) | −28 to −14 dB | Rise across the final span; never above the bed. |
| `heartbeat_rate` | 72 → 120 BPM | 60–140 BPM | Accelerate with the cutting rate. `data-playback-rate` is a constant (0.1–5, pitch-preserved) with no envelope, so step it with successive clips. |
| `riser_lead` | 45 f (1.5 s) | 30–90 f | Riser into the convergence; its peak lands on the convergence frame, not after it. |
| `convergence_marker` | hit | hit \| drop-to-silence \| riser resolve | Exactly one. Two markers at one frame cancel each other. |
| `release_after_hit` | 1.0 s | 0.5–3 s | Bed-only or near-silence. Without it the sequence has no punctuation. |
| `dialogue_group` | `voiceover` | — | Voices only. A bed or SFX clip inside the carve group silently poisons the next carve re-analysis. |
| `carve_strength` | 0.25 | 0.15–0.35 | Under narration, carve the bed rather than ducking it; at 0.5 the dip reaches 10 dB and is heard as an effect. |

## Reproduction prompt

```
Build the audio for the cross-cut sequence spanning {{SEQ_IN}}-{{SEQ_OUT}}
(seconds, 30fps) with strands A and B converging at {{CONVERGE}}.

1. LIST THE BLOCKS. From the cut list, write every block as
   (strand, start, end). Verify the durations decrease monotonically; if they
   do not, fix the picture first - the sound cannot create acceleration that
   the cut does not have. Expect 4-6 s at the top, roughly halving every two
   exchanges, with a floor of 0.8-1.2 s.
2. ONE BED. Place a single music clip starting at {{SEQ_IN}} - 1.0 and
   running past {{CONVERGE}} to {{SEQ_OUT}} + 1.0. It must not be cut,
   restarted or crossfaded at any picture cut in the sequence. Choose a track
   that already builds; if it does not, automate its level to rise 4-6 dB
   linearly from {{SEQ_IN}} to {{CONVERGE}}. Bed level -22 dB relative to
   dialogue (data-volume "0.079"), or -10 dB in any stretch with no voice.
3. CHOOSE THE SWAP SCHOOL before placing any ambience:
     blocks under 2 s, or two acoustically similar locations, or parallel
       action where simultaneity is the point  -> DOMINANCE
     strongly contrasted locations, blocks >= 1 s, thriller register
                                               -> HARD
4a. DOMINANCE. Place ONE continuous ambience clip per strand, each spanning
    the whole sequence. Do NOT cut them with the picture. Automate their
    levels: at every picture cut, ramp the ARRIVING strand's ambience to 0 dB
    reference and the DEPARTING strand's to -15 dB, over 6 frames (0.20 s).
    Neither ever reaches silence.
4b. HARD. Create one audio group per strand ("amb-a", "amb-b"). Place one
    ambience clip per BLOCK, data-start and data-duration exactly matching the
    block, data-volume "0.05", no crossfade. Use data-media-start to advance
    into the same source file block by block so each strand sounds continuous
    WITHIN itself across its gaps:
      data-media-start = (accumulated on-screen time of that strand so far)
    Confirm no ambience clip overlaps its neighbour by more than 1 frame.
5. DIEGETIC LAYER. Add per-strand events (footsteps, doors, machinery) only
   inside their own strand's segments, at -13 dB. As the segments shorten,
   keep the event count per segment at 1-2.
6. ACCELERATE THE SOUND with the picture: the count of discrete sound events
   per 10 seconds must rise across the sequence in step with the cutting rate.
   If the picture accelerates and the sound does not, the build will not read.
7. INTIMATE LAYER at INT_IN = {{CONVERGE}} - 12.0:
     SearchSoundEffects { query:{term:"heartbeat"},
       filter:{ tagSlugs:{matchType:ALL,values:["human--heartbeat"]},
                duration:{min:2000,max:6000} }, first:8 }
   Prefer a title containing "Loopable". Place it, then ramp its volume lane
   from v:0.063 at t:0 to v:0.158 at t:({{CONVERGE}} - INT_IN). Rate is NOT
   animatable, so accelerate the pulse with 2-3 successive copies at
   data-playback-rate 1.0, 1.25, 1.5.
8. CONVERGENCE. Choose exactly ONE marker at {{CONVERGE}}: a cinematic hit
   whose loudest peak sits on the convergence frame (back-time data-start by
   the file's measured peak offset); or a music drop to silence beginning 4
   frames before it; or a riser whose peak lands on it. Never two. Then cut
   the intimate layer dead on that frame and give 0.8-1.5 s of bed-only or
   near-silence before anything else happens.
9. IF THERE IS NARRATION over the sequence, put every voice clip in the
   voiceover group and carve the bed against that GROUP at strength 0.25. Do
   not duck the bed wholesale and do not put ambience or SFX in the voiceover
   group.
10. VERIFY EVERY SEAM: music continues, the ambience changes, nothing clicks.

ACCEPTANCE TEST: (a) solo the music and scrub the sequence - it must play
through every picture cut without a seam; (b) solo the ambiences - you must
hear two distinct places alternating with the picture (dominance: both always
audible, one clearly dominant; hard: a clean change of room on the cut frame);
(c) listen with the picture hidden - the sequence must sound like it is
getting faster, and the pulse under it must speed up; (d) at {{CONVERGE}}
exactly one thing happens in the audio, and then the sequence breathes; (e)
watch it: no seam clicks, no ambience arrives late, the hit is exactly on the
frame of contact.
```

## Execution spec

**HyperFrames (primary).** The key structural choice: put the bed and both ambiences at the **host root** so playback survives every scene cut, and use an `<hf-audio-group>` per strand — because **a bus's automation clock is composition time**, while a clip's automation `t` is clip-local. For level swaps that must land on specific composition timecodes, that difference is the whole reason to use a bus: one lane on the strand's bus can use the cut list's own timecodes instead of subtracting each clip's `data-start`.

Dominance school — two continuous ambience clips, level-swapped:

```html
<!-- the bed: one clip, never cut -->
<audio id="xc-bed" src=".media/audio/bgm/tense_build.mp3"
       data-audio-group="music" data-start="30.00" data-duration="32.00"
       data-track-index="11" data-volume="0.6"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.55},{&quot;t&quot;:30,&quot;v&quot;:0.95}]}]}"></audio>

<!-- strand ambiences: continuous clips, level-swapped, never cut -->
<audio id="xc-amb-a" src="assets/sfx/street_amb.wav" data-audio-group="ambience"
       data-start="30.00" data-duration="32.00" data-track-index="13"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:3.8,&quot;v&quot;:1},{&quot;t&quot;:4.0,&quot;v&quot;:0.18},{&quot;t&quot;:7.8,&quot;v&quot;:0.18},{&quot;t&quot;:8.0,&quot;v&quot;:1}]}]}"></audio>
<audio id="xc-amb-b" src="assets/sfx/basement_amb.wav" data-audio-group="ambience"
       data-start="30.00" data-duration="32.00" data-track-index="14"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.18},{&quot;t&quot;:3.8,&quot;v&quot;:0.18},{&quot;t&quot;:4.0,&quot;v&quot;:1},{&quot;t&quot;:7.8,&quot;v&quot;:1},{&quot;t&quot;:8.0,&quot;v&quot;:0.18}]}]}"></audio>

<!-- the convergence hit -->
<audio id="xc-hit" src="assets/sfx/cinematic_hit.wav" data-audio-group="sfx"
       data-start="59.88" data-duration="2.60" data-media-start="0.10"
       data-track-index="16" data-volume="0.9"></audio>
```

Hard school — per-strand buses and one ambience clip per block, with `data-media-start` keeping each strand internally continuous:

```html
<hf-audio-group id="amb-a" data-label="Strand A room" data-volume="1"></hf-audio-group>
<hf-audio-group id="amb-b" data-label="Strand B room" data-volume="1"></hf-audio-group>

<audio id="amb-a-01" src="assets/audio/amb/office-roomtone.wav" data-audio-group="amb-a"
       data-start="62" data-duration="5" data-media-start="0"
       data-track-index="13" data-volume="0.05"></audio>
<audio id="amb-b-01" src="assets/audio/amb/street-traffic.wav" data-audio-group="amb-b"
       data-start="67" data-duration="4.2" data-media-start="0"
       data-track-index="14" data-volume="0.05"></audio>
<audio id="amb-a-02" src="assets/audio/amb/office-roomtone.wav" data-audio-group="amb-a"
       data-start="71.2" data-duration="3.4" data-media-start="5"
       data-track-index="13" data-volume="0.05"></audio>
```

Contract facts this depends on:
- **A lane's `t` is clip-local seconds on a clip, composition time on an `<hf-audio-group>` bus** (a bus has no `data-start`). The dominance lanes above are clip-local because both ambience clips start at 30.00 — subtract the clip start from every composition timecode.
- **A lane holds its first value backwards to the clip start and its last value forward to the end.** An ambience that should begin quiet needs an explicit `{"t":0,...}` point, or it starts at unity.
- **512 points per lane maximum** — with 6 cycles × 2 points per swap you are nowhere near it, but a long sequence with per-cut swaps on several tracks should be checked.
- **`data-fx-carve` is clip-only** (never on a bus, `audio_group_carve_attr`), lives on the **bed**, and its `sources` must name a **group**, not clip ids (`audio_carve_ungrouped_sources`). Run `node <SKILL_DIR>/scripts/carve.mjs --comp index.html` after authoring; it needs `ffmpeg` on PATH and `@hyperframes/core` installed.
- **Every `<audio>` needs an `id`** or it is never mixed — a silent render with no warning. Overlapping audio on one `data-track-index` warns (`duplicate_audio_track`), hence 11/13/14/16 and the two strands never sharing an index.
- **Do not GSAP-tween `volume`** on a track that carries a `volume` lane: `audio_volume_double_automation`, the lane wins silently.
- **`data-playback-rate` is a constant** in `0.1..5` and pitch-preserved — there is no rate envelope, so an accelerating heartbeat is built from successive clips at rising rates.
- Write these JSON attributes **double-quoted with `&quot;`** — `carve.mjs` finds them with a `name="..."` regex and a single-quoted attribute is invisible to it, so a carve run silently overwrites work it could not see.
- Effects with a tail (`reverb`, `delay`) make the rendered track **longer** than its `data-duration`; the mix is told how much via `chainTailSeconds`. A hit's reverb outrunning its clip is expected, not a bug.

**Epidemic Sound.** The bed and the marker:
- Bed with a built-in build: `SearchRecordings { query.term: "tense building percussion cinematic instrumental", filter: { bpm: { min: 110, max: 140 }, vocals: false } }` — instrumental wherever your own voice is present ([[sfx-vocal-vs-instrumental-bed]]). `vocals: false` is known to leak; gate on the `vocal type` tag as well.
- Convergence marker: `SearchSoundEffects { query.term: "cinematic hit impact deep", filter.duration { max: 4000 } }`.
- If the bed needs to be exactly the sequence length, `EditRecording` / `PollEditRecordingJob` can produce a version with sections added or removed — preferable to a fade, which removes agency from the editor.

The ambience and intimate layers, verified live (2026-08-27):

| Layer | Query | Filter | Real results |
|---|---|---|---|
| Room tone | `room tone <place>` | `tagSlugs ALL ["ambience--room-tone"]`, `duration ≥ 60000 ms` | *Ambience, Room Tone, Office 01/03* — **120 000 ms** each; the room-tone shelf is uniformly 2-minute beds, which is exactly the length a strand needs |
| Heartbeat | `heartbeat fast tension` | `tagSlugs ALL ["human--heartbeat"]`, `duration 2000–6000 ms` | *Human, Heartbeat, Designed, Heartbeats, Loopable 01/02/03* — **2827 / 2540 / 2925 ms** (loopable takes are the ones to use) · *Evil Heartbeat, Fat Bass* — 28 134 ms (a whole bed) |
| Clock | `clock ticking` | `tagSlugs ALL ["clocks--tick"]`, `duration 30000–120000 ms` | *Clocks, Tick, Old Wall Clock, Ticking* — 58 294 ms · *Plastic Clock, Ticking* — 74 009 ms · *Wooden Wall Clock* — 42 016 ms |
| Breath | `breathing heavy human` | `tagSlugs ALL ["human--breath"]`, `duration 5000–30000 ms` | *Human, Breath, Male, Sports Breathing, Runner, Heavy, Close Perspective* — 21 569 ms · *Slow, Heavy, Long Breaths* — 17 365 ms |

Pick the two strand ambiences so they differ in **spectral centre**, not just in label — office room tone versus street traffic swaps audibly; two interiors do not. Use `SearchSimilarToSoundEffect` to keep both inside one sonic world. Full query construction lives in [[sfx-ambience-search-formula]].

**ffmpeg — measurement and export only.** `ebur128` for the loudness trace. Checking a seam for a click: `ffmpeg -ss <cut-0.2> -t 0.4 -i mix.wav -af astats=metadata=1:reset=1 -f null -`. Building a longer strand ambience than the library offers: `ffmpeg -stream_loop 3 -i roomtone.wav -t 180 -c copy amb-long.wav`. Two-pass `loudnorm` (`I=-14:TP=-1.5:LRA=11` for socials, `I=-16` for podcast) on the final mix; `sidechaincompress=threshold=0.03:ratio=8:attack=200:release=400` only for a bed leaving the pipeline.

**Remotion:** one `<Audio>` for the bed spanning the whole `<Sequence>`, and per-block `<Sequence from={blockStart} durationInFrames={blockLen}><Audio src={ambA} startFrom={accumulated} /></Sequence>` — the same accumulate-`startFrom` trick keeps each strand internally continuous. Not present in this project.

## Pairs with
[[pace-cross-cut-acceleration]] · [[struct-cross-cutting-parallel-action]] · [[struct-intercut-beat-ledger]] · [[sfx-phone-call-cross-cut-treatment]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-music-hard-stop]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-ambience-search-formula]] · [[sfx-peak-on-the-cut]] · [[sfx-vocal-vs-instrumental-bed]] · [[struct-music-arc-to-narrative-arc]]

## Failure modes
- **Cutting the bed with the picture.** The single most common error, and it destroys simultaneity instantly — the two strands stop sharing a clock and the sequence becomes a slideshow of two scenes. Fix: one clip, no cuts, level automation only.
- **Mixing the two swap schools inside one sequence.** Hard swaps on some seams and dominance ramps on others reads as inconsistent coverage rather than as design. Fix: choose once, at the top, and hold it.
- **Hard on/off swaps at high cutting rates.** Below about 2 s blocks a hard swap clicks, sucks and strobes on every cut, and it gets worse as segments shorten. Fix: switch to the dominance swap — departing strand to −15 dB over 6 frames, never to silence.
- **Crossfading the ambience in a hard-swap sequence.** Softening the seam destroys the "different place" signal the hard swap carries. Fix: 0 f by default; 2–4 f only to kill a click.
- **Identical ambience for two locations.** The ear stops distinguishing the strands and the sequence reads as one place with confusing coverage. Fix: two beds, genuinely different in spectrum, unless the strands really share a space.
- **Restarting each strand's ambience from 0.** The strand's room audibly resets every time you return to it. Fix: advance `data-media-start` by the strand's accumulated on-screen time.
- **A heartbeat that starts at the top.** Entering the intimate layer at the beginning leaves nowhere to go and the device is spent in ten seconds. Fix: enter in the last third and rise.
- **Fixed-rate pulse under an accelerating cut.** Audibly mechanical. Fix: step the rate with successive clips.
- **Static event density under an accelerating picture.** The mix contradicts the cut and the build does not land. Fix: raise events per 10 s in step with the cut rate.
- **Two convergence markers.** A riser and a hit and a drop at the same frame cancel one another and read as clutter. Fix: exactly one.
- **No landing, or no release.** Convergence with no marker leaves the built tension unspent, which viewers experience as the sequence "not going anywhere"; a marker with nothing after it has no punctuation. Fix: one marker, then 0.8–1.5 s of bed-only or near-silence.
- **Ducking the bed instead of carving it.** Under narration a wholesale duck costs the bed all its presence at exactly the moment you need the build. Fix: carve at 0.25 against the `voiceover` group. If the bed sounds notched rather than quieter, the strength is too high.
- **SFX or ambience inside the `voiceover` group.** The carve analysis follows the wrong signal and the next re-run degrades silently. Fix: voices only in the carve group.
- **Known gap:** nothing validates the FX chain or the effect lanes at all — lint reads `data-automation` for exactly two conflicts, and nothing checks that the bed is genuinely uncut across seams. A typo'd `nodeId` costs the envelope silently. There is also no rate envelope in the stack, so a continuously accelerating pulse must be approximated in steps. Verify this sequence by rendering and listening, not by passing `check`.
