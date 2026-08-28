---
id: sfx-second-sense-doctrine
title: Audio is the second sense — every cut, transition, animation and clip gets an audible counterpart
skill: sound-design
type: mix
family: second-sense
tags: [skill/sound-design, type/mix, family/second-sense, engine/hyperframes, engine/epidemic, engine/ffmpeg, layer/dialogue, layer/ambience, layer/music, layer/sfx, layer/design, source/editing-kt, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:10:29
    quote: "In pillar four, immersive audio and sound design makes the viewer experience every cut, every transition, every animation and every piece of footage with a second sense."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:10:39
    quote: "It's literally double the stimulation, and it can be used to steer the viewer's mood."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:10:24
    quote: "There's a completely different sense your viewer can experience the video with."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:00:06
    quote: "I've already said this 50 times, that sound is 50% of the video."
research_refs:
  - https://en.wikipedia.org/wiki/Audio_to_video_synchronization
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Cognitive_load
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: transcript+video
---

# Audio is the second sense — every cut, transition, animation and clip gets an audible counterpart

## What it is
The organising doctrine of this whole library, and the reason a sound pass exists as a pass rather than as decoration. The claim is that the timeline has two parallel channels of stimulation, that most editors build only one, and that the four *visual* event classes the creator names — **cut, transition, animation, piece of footage** — each have an audible counterpart that can be authored. Get all four covered and the viewer experiences the same edit twice, through two senses.

Research narrows the claim in a useful way. "Double the stimulation" is not additive attention; it is **cross-modal binding**. Audio and picture fuse into a single perceived event only inside a narrow temporal window, and the window is measurably asymmetric: ITU controlled testing puts the detectability threshold for audio/video offset at **"45 ms lead to 125 ms lag"**, EBU R37 accepts **"+40 ms and −60 ms (audio before/after video, respectively)"** end-to-end, and ATSC allows **"audio should lead video by no more than 15 ms and audio should lag video by no more than 45 ms."** Film practice is tighter still — **"no more than 22 milliseconds in either direction."** So a sound that arrives inside roughly ±1 frame of its picture event *is* that event; a sound 6 frames late is a second, separate event and reads as a mistake. Every frame offset in this library lives inside that budget, and the deliberate motion-sound lead exists precisely because the early side of the window is the intolerant one.

The second half of the quote — *"it can be used to steer the viewer's mood"* — is the other half of the doctrine: coverage makes the edit felt, and layer choice (ambience, bed, design tone) sets what it is felt *as*. Coverage without mood-steering is a video that sounds busy and means nothing.

**Style.** No `sfx/` style tag: the doctrine's four visual event classes cut across all three styles — a piece of footage is answered diegetically, a cut or transition with motion, an animation often with both plus an aesthetic sweetener. It is the parent claim, not one of the groups ([[sfx-three-types-classification]]).

## When to use it
Always, as the framing step of the sound pass, and specifically as the **audit** you run once cuts and motion are locked:

- **After the motion pass, before the effects pass.** You cannot spot sound against a timeline that is still moving; a re-timed animation invalidates every frame offset you wrote.
- **When a video "looks finished but feels flat."** That is the diagnostic symptom of one-channel construction: the picture is doing all the work. Count the covered event classes before touching anything.
- **When the video feels busy but not immersive.** Usually the opposite failure — motion effects everywhere, no ambience or dialogue floor, so there is stimulation without a world. Coverage is about breadth across layers, not density inside one.
- **Not as a mandate to sound every event.** The doctrine says every event class has a counterpart *available*; the density decision belongs to [[struct-stimulation-budget]] and the fatigue ceiling to [[sfx-density-fatigue-audit]]. A silent event is a legitimate choice; an *unconsidered* silent event is not.

## How to recognise it in a reference video
Build a two-column event log — picture events on the left, audible events on the right — and compute coverage per class. This is the single most useful artefact an analysis pass can produce for the sound sections of a profile.

- **Get the cut list and the audio, separately.**
  ```bash
  ffmpeg -i ref.mp4 -vf "select='gt(scene,0.3)',showinfo" -an -f null - 2>&1 | grep showinfo
  ffmpeg -i ref.mp4 -vn -ac 2 -ar 48000 ref.wav
  ffmpeg -i ref.wav -af "asetnsamples=n=1600,astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
  ```
  A 1600-sample window at 48 kHz is 33 ms — one frame at 30 fps — so the RMS trace is directly comparable to a frame-numbered cut list.
- **Coverage rates, per class.** For a creator working this doctrine, expect roughly: **straight cuts 5–20 % sounded** (most cuts are silent; see [[sfx-hard-cut-audio-seam]]), **full-frame transitions 90–100 %**, **graphic/text animations 60–90 %**, **new footage type or location 100 % carrying ambience or a bed change**. A reference where transitions are under ~50 % sounded is not practising this doctrine.
- **Measure the offset, not just the presence.** For each sounded event, find the effect's peak and the picture event's frame. Values should cluster in **−4f to 0f (audio early to on-frame, i.e. −133 ms to 0)**, and essentially never later than **+1f**. A cluster on the late side means the effects were dragged onto the timeline by eye, not spotted.
- **Check the four layers are all present at all**, using speech gaps: an ambience floor that survives cuts, a music bed, isolated effect transients, and dialogue on top. A reference with only dialogue + effects sounds "edited"; a reference with all four sounds "shot."
- **Mood-steering tell:** find two sections with the same visual grammar but different intent. If the audio layer differs (bed instrumentation, ambience density, presence of design tones) while the cutting is identical, mood is being steered by sound.
- **Transcript tell:** the creator's own script often names the event that got the sound — "and then this happens", "watch this" — because emphasis language and audible accents co-occur.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `av_bind_window` | ±22 ms (±0.66f) | −45 ms to +125 ms detectable | Film practice: "no more than 22 milliseconds in either direction." Outside this the sound becomes a separate event. |
| `preferred_offset` | −2f (−67 ms) | −4f to 0f | Motion sound leads picture. The early side is where perception is *least* tolerant, so keep leads small and deliberate. |
| `late_limit` | +1f (+33 ms) | 0 to +1f | Anything later reads as sloppy sync even though ATSC would still accept it — an accent is judged harder than lip sync. |
| `cut_coverage` | 10 % | 5–20 % | Fraction of straight cuts carrying a dedicated effect. High values are the overload failure. |
| `transition_coverage` | 100 % | 90–100 % | A full-frame transition with no sound is the most conspicuous gap in the whole doctrine. |
| `animation_coverage` | 75 % | 60–90 % | Graphic and text motion. Reserve the silent quarter for the smallest moves. |
| `footage_coverage` | 100 % | — | Every distinct location or footage type carries ambience or a bed change. |
| `layers_present` | 4 | 3–5 | Dialogue + ambience + music + effects. Foley is the fifth and is optional for talking-head. |
| `programme_loudness` | −14 LUFS I | −16 to −13 LUFS I | Delivery target; the mix ratios themselves live in [[sfx-layer-volume-targets]]. |
| `true_peak` | −1.5 dBTP | −2 to −1 dBTP | Headroom for codec artefacts on top of R 128's −1 dBTP ceiling. |

## Reproduction prompt

```
Run the SECOND-SENSE COVERAGE AUDIT on this composition, then close the gaps.
Do this only after cuts and motion are locked; a re-timed animation
invalidates every offset you write here.

1. BUILD THE EVENT LEDGER. Walk the composition and list every event in four
   classes, each with its composition time in seconds to 2 decimals:
     C = straight cuts (clip boundary, picture only)
     T = full-frame transitions (wipe, whip, bloom, dip, shader)
     A = animations (text entrance, graphic move, scale step, overlay)
     F = footage/location changes (new place, new footage type, new section)
2. CLASSIFY EACH ROW by style before choosing any asset: diegetic (the world
   would make this sound), motion (something is travelling), aesthetic (feel
   only). Write the style in the ledger. An unclassified row gets no sound.
3. APPLY THE COVERAGE TARGETS: T = 100%, A = 75%, F = 100% (ambience or bed
   change), C = 10% max. If class C is already above 20%, do not add - delete
   the weakest accents until it is under 20%.
4. FOR EVERY UNSOUNDED T AND F ROW, fetch and place a sound. For A rows, sound
   the largest 75% of moves by travel distance and leave the smallest silent.
5. SET EACH OFFSET so the effect's PEAK - not its file head - sits at
   {{EVENT}} - 0.067s (2 frames early at 30fps). Compute data-start as
   {{EVENT}} - 0.067 - PEAK_OFFSET_IN_SOURCE. Never let a peak land later
   than {{EVENT}} + 0.033s.
6. SET GAIN by style: motion and diegetic accents 0.251 (-12 dB), aesthetic
   textures 0.126 (-18 dB) or lower. Dialogue keeps 0 to -3 dB and always wins.
7. CONFIRM ALL FOUR LAYERS EXIST: a dialogue track, an ambience bed that runs
   across cuts, a music bed with a carve against the voiceover group, and the
   effects you just placed. If a layer is missing, add it before adding more
   effects - breadth beats density.
8. MEASURE the finished mix: two-pass ffmpeg loudnorm to I=-14, TP=-1.5.

ACCEPTANCE TEST: play the whole video once with picture at normal volume and
do not take notes. Then play the audio alone. The audio alone must let you
say where every transition and every section change was. If it does not, the
second channel is not carrying the edit. Then invert: mute the effects bus
only. If nothing feels lost, the effects were decoration, not coverage.
```

## Execution spec

**HyperFrames — the doctrine is enforced by authoring, because nothing checks it.** There is no audio-follows-animation attribute in this stack: *"The two are coupled by the author writing the same number twice: the tween's timeline position and the `<audio data-start>`."* That is the whole reason this note exists as an audit rather than a feature.

- **All authored time is in SECONDS.** There is no frame attribute and no `data-fps` on a clip; a 2-frame lead at 30 fps is `0.067`, written as a derived comment.
- **Each effect is an `<audio>` clip with an `id`** (an id-less `<audio>` is never mixed — a silent render), `data-audio-group="sfx"`, and a `data-track-index` of 10+.
- **Sub-composition offset trap:** if the visual event lives in a sub-comp at scene-local `t`, the root-level audio needs `data-start = t + slot data-start`. Relative timing can express it — `data-start="el-scene-3 + 1.2"` — but **spaces around the operator are required** and an unresolved reference silently resolves to `0`.
- **Layer skeleton for the four channels** (track indices are display-only, but keep them meaningful):

```html
<audio id="vo-01" src=".media/audio/voice/line-01.wav" data-audio-group="voiceover"
       data-start="0.50" data-track-index="10"></audio>

<audio id="amb-room" src=".media/audio/sfx/room-tone-loop.wav" data-audio-group="ambience"
       data-start="0" data-duration="120" data-track-index="11" data-volume="0.04"></audio>

<audio id="bgm-sec-1" src=".media/audio/bgm/bed-a.wav" data-audio-group="music"
       data-start="0" data-duration="64" data-track-index="12" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>

<!-- transition sound: picture event at 12.40s, peak 0.18s into the file, 2f lead -->
<audio id="sfx-t-01" src=".media/audio/sfx/whoosh-mid.wav" data-audio-group="sfx"
       data-start="12.153" data-duration="0.90" data-track-index="14" data-volume="0.251"></audio>
```

`12.153 = 12.40 − 0.067 (2f lead) − 0.18 (peak offset in source)`. Write that arithmetic as a comment on every effect clip; it is the only record of why the number is what it is.

- **Never put an effect in the `voiceover` group.** A non-voice member *"poisons the next re-analysis silently."*
- **`data-hidden` is the A/B tool for step 8's mute test** — it drops an element from preview *and* render, non-destructively, so muting the effects tracks one at a time is cheap. Put the effects on their own `<hf-audio-group id="sfx">` and set `data-hidden` on the bus to mute the whole class at once.
- **Nothing validates any of this.** *"Almost no static gate covers the mix."* Lint reads `data-automation` for exactly two conflicts. The audit is the gate.

**ffmpeg — measurement only at this level.** Frame-aligned RMS trace (33 ms windows), scene list, and the two-pass `loudnorm` delivery check:
```bash
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=…:measured_TP=…:measured_LRA=…:measured_thresh=…:offset=…:linear=true mix.social.wav
```

**Epidemic Sound — one fetch pass, driven by the ledger, not by browsing.** Group the ledger rows by style and fetch per group so the video stays coherent:
- transitions → `SearchSoundEffects { filter: { tagSlugs: { matchType: ANY, values: ["swooshes--whoosh","swooshes--swish"] }, duration: { min: 400, max: 1500 } }, sort: { by: POPULARITY, order: DESCENDING } }`
- location/footage rows → `ambience--<place>` (see [[sfx-ambience-establishes-location]])
- once one asset is right, `SearchSimilarToSoundEffect { id }` for the rest of that class — this is what makes a palette instead of a pile.
Download with `DownloadSoundEffect` into `.media/audio/sfx/` **before** building; a missing asset discovered mid-render is a wasted render.

**Remotion:** the same coupling problem exists there — an `<Audio>` whose `from` frame is written to match the animation's frame. Concept only; there is no Remotion runtime in this project.

## Pairs with
[[sfx-sound-pass-order]] · [[sfx-five-layers-build-order]] · [[sfx-layer-volume-targets]] · [[sfx-unsounded-motion-audit]] · [[sfx-density-fatigue-audit]] · [[struct-stimulation-budget]] · [[sfx-hard-cut-audio-seam]] · [[sfx-ambience-establishes-location]] · [[sfx-felt-not-noticed]] · [[sfx-motion-sound-selection]] · [[motion-sfx-pass-manifest]] · [[motion-sound-bound-motion-event]] · [[sfx-three-types-classification]]

## Failure modes
- **Reading "double the stimulation" as "twice as many events."** Coverage means breadth across the four event classes and five layers, not density. The measurable consequence of the misreading is documented in [[sfx-density-fatigue-audit]]. Fix: fill missing *layers* before adding more effects.
- **Spotting sound before picture is locked.** Every offset is invalidated by a re-timed animation, and there is no automatic re-sync in this stack: *"HyperFrames does not provide automatic waveform sync or drift correction."* Fix: audio pass runs last.
- **Effects placed by file head instead of by peak.** The transient then lands 100–300 ms late, well outside the ±22 ms binding window, and the accent reads as a separate sound. Fix: measure the peak offset in the source and subtract it.
- **Late accents.** Perception tolerates audio *lag* better than lead for lip sync, but an accent is judged against a visible instant; late reads as broken. Fix: 0 to 2 frames early, never late.
- **Covering transitions and animations but not footage changes.** The video gets punchy and stays fake, because nothing tells the ear the location changed. Fix: ambience per location, always.
- **Mood left unsteered.** Full coverage with a single generic bed produces a video that is stimulating and emotionally neutral — coverage without the second half of the quote. Fix: bed and design choices per section, per [[sfx-instrument-filter-search]].
- **Known gap:** the coverage percentages are calibrated from this creator's own practice plus the class-by-class logic above, not from a published study; the sync numbers (ITU/EBU/ATSC/film ±22 ms) are the defensible part. Treat the percentages as a profile to be measured per reference video, not as a law.
