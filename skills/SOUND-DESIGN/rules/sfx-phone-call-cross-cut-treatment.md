---
id: sfx-phone-call-cross-cut-treatment
aliases: [cut-cross-cut-phone-call]
title: Sounding a cross-cut phone call — whose ear are we in, and where the futz swaps
skill: sound-design
type: mix
family: cross-cut
tags: [skill/sound-design, type/mix, family/cross-cut, engine/hyperframes, engine/epidemic, engine/ffmpeg, sfx/diegetic, layer/dialogue, layer/ambience, source/editing-kt-2, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:04:37
    quote: "Cross cutting is when the editor is cutting back and forth between multiple scenes, usually at the same time."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:04:48
    quote: "It can be used when maybe two characters are on the phone to each other, and you're cutting to and from each character."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:54"
    quote: "What cross cutting allows you to do is to easily tell your two stories that are happening at the same time."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:00:54
    quote: "If I play you traffic noise, you'll tell me without even looking that this video was shot on a road."
research_refs:
  - https://en.wikipedia.org/wiki/Voice_frequency
  - https://en.wikipedia.org/wiki/Wideband_audio
  - https://en.wikipedia.org/wiki/Cross-cutting
  - https://en.wikipedia.org/wiki/Sound_bridge
  - https://www.production-expert.com/production-expert-1/the-secret-to-great-phone-futzing
  - https://www.boomboxpost.com/blog/2018/1/25/sound-editing-for-perspective-shifts
  - https://www.studiobinder.com/blog/cross-cutting-parallel-editing-definition/
  - https://www.adobe.com/lu_en/creativecloud/video/discover/cross-cutting-film.html
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: high
detectable_from: transcript+video
---

# Sounding a cross-cut phone call — whose ear are we in, and where the futz swaps

## What it is
The canonical, simplest cross cut: two characters in two places, joined by a call, cut back and forth so one conversation plays as a single scene across two spaces. Picture alternates; the **dialogue does not** — it runs continuously, which is what welds the two locations together.

**Picture handles the spaces; sound decides whose ear the audience is in.** The craft that separates a professional version from a student one is entirely on the audio, and it is a single decision applied consistently: the character whose room we are looking at is heard **clean and close**, with their room's ambience up, while the other end arrives **through the earpiece** — band-limited to the telephone band, compressed, quieter, and carrying none of the far room's ambience except what leaks through the handset. When the picture cuts to the other location, all of that **swaps**.

**The swap is the whole technique.** Applied consistently it is invisible; applied inconsistently it sounds like a fault.

Two things must *not* swap: **the music bed** and **the sense of one continuous conversation**. One bed spanning both locations is what tells the viewer these two spaces are one scene.

The general structural rules of cross cutting — establishing both strands, how many strands a format can carry, average-shot-length behaviour — live in [[struct-cross-cutting-parallel-action]] and [[pace-cross-cut-acceleration]]. This note is the **phone-call application**, and the reason it needs its own note is the audio spec nothing else in the family has: the perspective swap and the earpiece futz.

## When to use it
- **Any cross-cut phone, video-call, radio or intercom conversation** where the picture visits both ends. This is the default treatment. Also any interview cross-connection, two-location conversation, or creator-content version — a two-hander sketch, an "objection character" replying from elsewhere ([[struct-objection-character-cutaway]]), a caller/expert insert.
- **When the distance between the characters is part of the point.** They are apart; that is the drama. The band-limited voice *is* the distance.
- **Reach for it when the reaction on the other end is part of the content.** If only one side matters, stay on that side and let the other voice be off-screen.
- **Also for the single-ended case:** we only ever see one character and the other exists only as a voice. Same treatment, no swap, and the futzed voice does more work because it is the only evidence the other person exists.
- **Skip the futz entirely** when the scene is comedic, stylised, or when intelligibility of both halves matters more than realism — a talking-head creator cutting to a "call" bit usually wants both voices clean. A legitimate style position; take it deliberately and log it.
- **Skip the swap** (keep one voice permanently futzed) when one character is narratively "the caller" and the other is the protagonist whose POV the whole scene holds. This is the second valid convention, and **choosing between the two is the actual decision this note asks you to make.**
- **Not for two people in the same room.** A futz with no transmission channel is just a broken EQ.
- **Not when the two strands are not concurrent** — that is parallel editing of different times, and cross cutting will assert a simultaneity that is not true.

## How to recognise it in a reference video
- **Alternation pattern from the cut list.** Detect boundaries, label each shot `A` or `B` by location, and write out the string. A cross cut looks like `A B A B A B`; a scene with a cutaway looks like `A A A B A A`. A genuine cross cut has **at least two** complete `A→B→A` cycles.
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=10,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ```
- **Shot-length series.** Write the durations in order. Classic cross cutting *accelerates*: openings hold **60–150 f (2–5 s)** per side, tightening toward the climax to **30–60 f (1–2 s)**. A flat series is a conversation cut in a phone shape; a decelerating series is usually a mistake.
- **The futz test — the definitive one.** Band-limited earpiece audio has essentially no energy above ~3.4 kHz. Measure the high band per speaker:
  ```bash
  ffmpeg -ss <t> -t 1 -i ref.mp4 -af "highpass=f=4000,astats=metadata=1" -f null - 2>&1 | grep RMS_level
  ffmpeg -i ref.mp4 -lavfi showspectrumpic=s=1600x900:legend=1 spectrum.png
  ```
  A futzed line reads **15–25 dB lower** above 4 kHz than the same speaker heard clean, and the spectrogram shows a hard floor near **300 Hz** and a flat ceiling at **~3.4 kHz** on alternate voices. A "HD voice"/wideband futz sits nearer 50 Hz–7 kHz and reads as a modern smartphone rather than a landline.
- **Does the futz swap, and where?** For each picture cut, find the first sample where a speaker changes band-limitation state. Three patterns, all common:
  - **Swaps at every cut** → strict perspective. The most cinematic.
  - **Never swaps, one voice always futzed** → fixed POV. Also correct, and cheaper.
  - **Swaps sometimes** → an error, unless the picture is doing something else at those cuts.
  A correct swap lands within **±1 frame of the picture cut** when there is a speech gap there, or at the nearest **line boundary** with a 2–4 frame crossfade when a line spans the cut. A swap that lags by 3+ frames with no line spanning the cut is audible as an error; a swap that lands **mid-word** is audible as a dropout.
- **Is either side clean throughout?** Some references keep both voices clean and let picture alone carry the geography — common in comedy and creator content. Log which convention the reference uses; it is a parameter, not a fault.
- **Ambience swap.** Measure the inter-word noise floor per side. Two distinct floors alternating = two spaces sounded properly; one floor across both = the locations are not being sold. This is usually a **stronger cue than the voice treatment**. Note whether the beds switch hard or crossfade.
- **The bed.** Does one music track run unbroken across the cuts? If yes, the editor is using music as the unifier — the standard approach. If music also cuts at each location change, the scene reads as two scenes.
- **Level offset.** A futzed voice normally sits **3–6 dB below** the near voice, because it is arriving from a small speaker. Measure both voices' RMS during speech and log the difference.
- **Dialogue continuity.** Align the transcript to the cut list. In a cross cut, **speech runs across the boundaries** — the line beginning before a cut finishes after it, or the reply begins under the outgoing shot. Count how many boundaries are split edits; in a well-cut phone scene it is most of them ([[cut-j-audio-leads-picture]], [[cut-l-audio-trails-picture]]). Overlapping dialogue, interruptions and lines that answer across a picture cut mark this as one conversation rather than two monologues.
- **Eye-line and screen direction.** The two characters should look toward *opposite* sides of frame. If both look camera-left, the sequence reads as them being in the same place facing away from each other. This is the one visual continuity rule cross cutting cannot ignore.
- **Interstitial handles.** Note whether the reference includes the phone's own diegetic sounds (ring, pick-up, hang-up, keypad) and where. Their presence is what makes the convention legible without dialogue explaining it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `swap_convention` | strict perspective (swap at every cut) | strict · fixed-POV | Decide once for the whole sequence and never mix them. |
| `futz_convention` | near-clean / far-futzed | near-clean \| both-clean | Whether the remote voice is filtered at all. Pick once and hold it. |
| `swap_anchor` — **cut lands in a speech gap** (the common case) | the picture cut frame | ±1 f | The two coincide; swap on the frame. A late swap here is the single most common way this reads as an error. |
| `swap_anchor` — **a line spans the cut** | the nearest speech gap | within ±0.4 s of the cut | Never mid-word: a filter change inside a syllable is heard as a dropout or a codec glitch. |
| `swap_crossfade` | 1 f (declick) | 2–4 f when the swap must land mid-line | A one-frame overlap kills clicks; 2–4 frames turns a mid-line swap into a slide rather than a step. Anything longer smears the swap. |
| `futz_highpass` | 300 Hz | 200–400 Hz | Bottom of the narrowband telephone band (~300–3400 Hz). `poles: 2` for a definite 12 dB/oct wall. |
| `futz_lowpass` | 3400 Hz | 3000–4000 Hz | Top of the same band. Together these two filters *are* the phone. Use 3400 for a landline/classic read. |
| `futz_band_wideband` | 50–80 Hz – 7 kHz | — | The "HD voice"/VoIP-era alternative. A modern mobile rather than a landline; noticeably less "toy". Practitioner setting — verify by ear. |
| `futz_presence` | +4 dB @ 1.8–1.9 kHz, Q 1.2 | +2 to +6 dB | Restores intelligibility lost with the top and bottom. Without it the futz is muddy rather than thin. |
| `futz_level_offset` | −4 dB vs the near voice (`data-volume` ×0.63) | −3 to −6 dB | The earpiece is quieter than the person in the room. Any deeper and the far half stops being intelligible. |
| `futz_compression` | threshold −22 to −24 dB, ratio 6 | ratio 4–8 | Phone lines are heavily compressed; this is what makes it read as a *channel*, not an EQ. Not automatable in this stack. |
| `handset_leak` | −34 dB (0.02) | −40 to −28 dB | The far room's ambience, futzed with the same filters, faintly under the far voice. The detail that sells it. |
| `ambience_per_location` | 1 bed each | — | See the two rows below. |
| `ambience_switch` — **default** | hard switch on the picture cut | 0 f | The location bed is the viewer's strongest cue for which room they are in; a hard switch is what makes it a cue. |
| `ambience_switch` — **tonally similar beds, or fast cutting** | crossfade 15 f (0.5 s) | 9–24 f | Use when the two beds are close in character, or when the cut rate is under ~45 f per side and hard switches would chatter. |
| `music_bed` | one, continuous across all cuts | — | **The unifier.** Never cut the bed at a location change inside the sequence. −22 dB, carved against the voiceover group. |
| `cycles` | 3 | 2–8 | Complete `A→B→A` alternations. Under 2 it is a cutaway, not a cross cut. |
| `shot_len_open` | 105 f (3.5 s) | 60–150 f | Opening hold per side, while geography is being established. |
| `shot_len_climax` | 45 f (1.5 s) | 30–60 f | Toward the peak. The series should shorten monotonically or nearly so. |
| `accel_ratio` | 0.6 | 0.5–0.8 | Each side's hold as a fraction of the previous cycle's. |
| `split_edit_ratio` | 0.7 | 0.5–1.0 | Fraction of boundaries carrying dialogue across, as J or L cuts. |
| `screen_direction` | opposed | — | A looks frame-right, B looks frame-left, held for the whole sequence. |
| `diegetic_markers` | ring + pickup + hangup | — | At least the pick-up and the hang-up, or the convention is not established. |

## Reproduction prompt

```
Build and sound the cross-cut phone sequence between location A and location B,
running {{SEQ_IN}}..{{SEQ_OUT}}.

1. DECIDE THE CONVENTION FIRST and write it down: STRICT PERSPECTIVE (the voice
   belonging to the location on screen is clean, the other is futzed, swapping at
   every picture cut) or FIXED POV (A always clean, B always futzed, no swaps).
   Do not mix them. Also decide futz_convention: near-clean/far-futzed, or both
   voices clean.
2. LOCK THE DIALOGUE FIRST. Lay both characters' lines on a single continuous
   conversation timeline with the real overlaps and pauses. The dialogue is the
   spine; picture is cut TO it. Do not trim a line to fit a shot.
3. CHOOSE PERSPECTIVE PER LINE. For every moment, decide which room the viewer is
   in. Default: we are with whoever is about to react. Write it as a list of
   ranges, e.g. A[0-3.5] B[3.5-6.8] A[6.8-9.4].
4. CUT PICTURE TO THAT LIST, then apply the acceleration: opening holds 90-150f
   (3.0-5.0s) per side, each subsequent cycle at ~0.6x the previous hold, floor
   30f (1.0s). Minimum 2 complete A->B->A cycles. Record each cut's time and
   which location it moves to.
5. SPLIT THE DIALOGUE INTO CLIPS. Each character's lines become their own clips
   in data-audio-group="voiceover" - never one interleaved track, because you
   cannot apply two different treatments to one element. When splitting one
   performance, the second clip's data-media-start must resume exactly where the
   first ended, or the line stutters.
6. TREAT THE VOICES. In each perspective range: the character IN that room is
   clean and full-band; the other is the earpiece - highpass 300Hz (poles 2),
   lowpass 3400Hz (poles 2) (use ~7000Hz for a modern mobile read), peaking
   +4dB at 1800-1900Hz Q1.2, compressor threshold -22/-24 ratio 6, and 4 dB
   below the near voice (data-volume x0.63). Apply ONE phone treatment; never
   stack two character presets.
7. PLACE THE SWAPS.
     If there is a speech gap at the picture cut -> swap ON the cut frame,
       within 1 frame, with a 1-frame overlapping crossfade to kill clicks.
     If a line genuinely spans the cut -> move the swap to the nearest speech
       gap within 0.4s, OR crossfade the two treatments over 2-4 frames.
     Never switch a filter mid-word.
8. TWO AMBIENCES, ONE BED. Give each location its own ambience clip at about
   -30 dB. Switch them HARD on the picture cut by default - that switch is the
   viewer's main location cue. Crossfade 9-15f only if the two beds are tonally
   close or the cut rate is under 45f per side. Then run ONE music bed across the
   entire sequence at -22 dB, carved against the voiceover group.
9. ADD HANDSET LEAK: a copy of the FAR location's ambience, futzed with the same
   filters, at -34 dB, under the far voice only. Put it in the ambience group,
   not the voiceover group.
10. SPLIT THE BOUNDARIES. Carry dialogue across at least half the cuts: the reply
    starts 8-12f before the picture changes (J cut), or the outgoing line
    finishes 10-15f after it (L cut). One direction per boundary, never both.
11. MARK THE CONVENTION. Include the diegetic phone sounds - the ring, the
    pick-up, and the hang-up at minimum. Place each with its PEAK on the visible
    action frame, not its start.
12. HOLD SCREEN DIRECTION. A looks frame-right for the whole sequence, B
    frame-left. Never flip.

ACCEPTANCE TEST: (a) with the picture off, the conversation plays as one
uninterrupted scene, and you can always say which room you are in; (b) with the
sound off, the alternation is legible and shot lengths shorten toward the climax;
(c) measure >4 kHz energy per voice - the futzed side is 15-25 dB down;
(d) step frames at every cut: the futz state changes on the cut frame, or at a
deliberate line boundary within 0.4s - never mid-word, and never with a click,
dropout or level jump; (e) every picture cut is accompanied by an ambience
change, and NO picture cut is accompanied by a music change; (f) no boundary
carries both a J and an L cut; (g) check intelligibility of the futzed half at
speaker volume - if you lose words, raise futz_level_offset toward -3 dB before
widening the band.
```

## Execution spec

**HyperFrames — the `telephone` character preset is the intended route.** The audio skill ships named character presets: `telephone`, `radio-am`, `megaphone`, `pa-system`, `intercom`, `lofi-tape`. They write ordinary nodes tagged `fromPreset`, and the doctrine is blunt: *"These are costumes… Do not stack two."* One phone treatment per clip — never `telephone` plus `radio-am`, never `telephone` plus a hand-built band-pass.

The preset's real advantage here is that **`fx.preset.<id>` is an automation target, and it is the only way to automate a preset as a unit** (`presetAmount`, 0..1). That is exactly the perspective swap: one clip per character, the futz preset applied, and the preset amount driven to 0 in the shots where that character's room is on screen and to 1 where it is not.

```html
<!-- character B's dialogue: futzed except while we are in B's room -->
<audio id="dlg-b" src="assets/audio/b-lines.wav"
       data-audio-group="voiceover" data-start="0" data-duration="46"
       data-track-index="11" data-volume="0.63"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[
         {&quot;target&quot;:&quot;fx.preset.telephone&quot;,&quot;points&quot;:[
           {&quot;t&quot;:0,&quot;v&quot;:1},
           {&quot;t&quot;:12.2,&quot;v&quot;:1},{&quot;t&quot;:12.3,&quot;v&quot;:0},
           {&quot;t&quot;:19.6,&quot;v&quot;:0},{&quot;t&quot;:19.7,&quot;v&quot;:1}]}]}"></audio>
```
Two cautions. A **lane whose node is gone is pruned on read, not an error** — a mistyped preset id costs you the whole envelope silently, so snapshot and listen rather than trusting the markup. And a **lane on a non-automatable parameter is silently inert**, which is why the manual chain below does its swapping with a `gain` stage rather than by automating filter frequencies.

**The manual chain**, when you want explicit control of the band (and the honest fallback if the preset id does not resolve). Split that character's audio at the perspective boundaries, because a chain is a per-clip attribute and there is no automatable "phone on/off" parameter:

```html
<!-- picture alternates -->
<video id="p-a1" src="a.mp4" muted playsinline class="clip" data-start="0"    data-duration="3.50" data-track-index="0"></video>
<video id="p-b1" src="b.mp4" muted playsinline class="clip" data-start="3.50" data-duration="3.30" data-track-index="0"></video>

<!-- CHARACTER A's voice, split at 3.50: clean, then futzed -->
<audio id="va-1" src="a-vox.wav" data-audio-group="voiceover"
       data-start="0" data-duration="3.50" data-track-index="10"></audio>
<audio id="va-2" src="a-vox.wav" data-audio-group="voiceover"
       data-start="3.50" data-duration="3.30" data-media-start="3.50" data-track-index="10"
       data-volume="0.63"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
        {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Phone Bottom&quot;,&quot;params&quot;:{&quot;frequency&quot;:300,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
        {&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Phone Top&quot;,&quot;params&quot;:{&quot;frequency&quot;:3400,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
        {&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;label&quot;:&quot;Earpiece Presence&quot;,&quot;params&quot;:{&quot;frequency&quot;:1850,&quot;gain&quot;:4,&quot;q&quot;:1.2}},
        {&quot;type&quot;:&quot;compressor&quot;,&quot;id&quot;:&quot;n4&quot;,&quot;label&quot;:&quot;Line Squash&quot;,&quot;params&quot;:{&quot;threshold&quot;:-23,&quot;ratio&quot;:6,&quot;attack&quot;:5,&quot;release&quot;:120}},
        {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n5&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>
```

**The robust alternative — two clips, one swap.** Because a silently-pruned lane is a real risk on something this audible, the safest construction is duplication: place each line twice, once clean and once futzed, on different track indices, and drive their `volume` lanes in opposition. Zero clever automation, no preset id to get wrong, and any mistake is audible immediately in preview. Costs twice the elements. **On anything client-facing, prefer this.**

**Ambience and bed:**
```html
<audio id="amb-loc-a" src="assets/sfx/apartment-ambience.wav" data-audio-group="ambience"
       data-start="0" data-duration="3.50" data-track-index="14" data-volume="0.0316"></audio>
<audio id="amb-loc-b" src="assets/sfx/street-ambience.wav" data-audio-group="ambience"
       data-start="3.50" data-duration="3.30" data-track-index="15" data-volume="0.0316"></audio>
<audio id="music-call" src=".media/audio/bgm/tension-bed.wav" data-audio-group="music"
       data-start="0" data-duration="46" data-track-index="30" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```

The contract points that decide the result:
- **`data-media-start` keeps a split performance seamless.** Splitting one take into clean and futzed clips means the second clip must start into the source exactly where the first ended (`3.50` here). Get this wrong and the line stutters or skips.
- **Chain order is signal order** — *"subtract before you add, level after you filter, relationships after level, character and ceiling last."* Band-pass → presence → dynamics → ceiling. `highpass`/`lowpass`/`peaking` frequencies **are** automatable; **`compressor` and `limiter` have zero automatable parameters** (AudioWorklets configured wholesale), so any moving treatment must be a `gain` stage around them or a `volume` lane.
- **Do not GSAP-tween `volume`** on a clip that also has a `volume` lane — the lane wins silently (`audio_volume_double_automation`), and an authored `data-volume` on a tweened track is *replaced*, not scaled (`audio_volume_tween_overrides_gain`).
- **Nothing validates an FX chain.** Lint reads `data-automation` for exactly two conflicts and checks nothing else; render *refuses* an unparseable chain while preview plays it **dry**. A chain that sounds fine in preview and wrong in render is a real failure mode here — verify by rendering.
- **Ambience beds use different track indices** because they are adjacent (and would trip `duplicate_audio_track` if they overlapped for a crossfade), while the music bed spans every cut on its own index.
- **Keep only genuine voice clips in `data-audio-group="voiceover"`** so the bed can carve against them. The futzed voice belongs there — it is speech and the carve should follow it. The handset-leak ambience does **not**; a non-voice clip in the carve group poisons the next re-analysis silently.
- **Every `<audio>` needs a unique `id`.** Splitting a voice into three clips means three ids; forget one and that section is silent with no warning.

**ffmpeg — baking a futz.** Only for an asset leaving the pipeline, or to prepare a pre-futzed duplicate for the two-clip construction. The "downsample it for real" trick is the most convincing version, because it brings quantisation with it:
```bash
# straightforward bake
ffmpeg -i b-lines.wav -af "highpass=f=300:poles=2,lowpass=f=3400:poles=2,\
equalizer=f=1850:t=q:w=1.2:g=4,acompressor=threshold=-23dB:ratio=6,volume=0.63" b-lines.futz.wav

# authentic narrowband: resample to 8k, then back, with a soft clip
ffmpeg -i vox.wav -af "highpass=f=300,lowpass=f=3400,acompressor=threshold=-22dB:ratio=6,\
aresample=8000,aresample=48000,alimiter=limit=0.9" vox.phone.wav

# verify the band ceiling
ffmpeg -i vox.phone.wav -lavfi showspectrumpic=s=1200x600 vox.phone.png
```

**Epidemic Sound — the diegetic furniture the scene needs.** The markers are non-negotiable, and they are layer 3/4, not layer 1:
```
SearchSoundEffects { query:{ term:"mobile phone ringtone incoming call" }, filter:{duration:{min:1000,max:8000}} }
SearchSoundEffects { query:{ term:"phone pick up handset click" } }
SearchSoundEffects { query:{ term:"phone hang up end call beep" },        filter:{duration:{min:200,max:2000}} }
SearchSoundEffects { query:{ term:"phone vibrate table" },                filter:{duration:{min:500,max:5000}} }
SearchSoundEffects { query:{ term:"dial tone" } }
SearchSoundEffects { query:{ term:"keypad tone dtmf" } }
# one ambience bed per location - these matter MORE than the phone queries
SearchSoundEffects { query:{ term:"apartment room tone quiet" },
                     filter:{duration:{min:30000,max:300000}}, sort:{ by: DURATION, order: DESCENDING } }
SearchSoundEffects { query:{ term:"street ambience traffic distant" }, filter:{duration:{min:30000,max:300000}} }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Place each marker on its exact action frame in an `sfx` group at track index 12+, with the **peak** of the sound on the visible action, not its start. The ambience queries matter more than the phone queries: the source's own test for ambience is that the viewer can name the location without looking, and in a cross cut that is the mechanism by which the audience tracks which end of the call they are on.

**Remotion:** alternating `<Sequence>`s over a continuous `<Audio>` per character, with two elements carrying opposing `volume` callbacks per line. Concept only; no Remotion runtime in this project.

## Pairs with
[[sfx-cross-cut-audio-strategy]] · [[struct-cross-cutting-parallel-action]] · [[sfx-five-layers-build-order]] · [[sfx-ambience-bridge-across-cut]] · [[cut-j-audio-leads-picture]] · [[cut-l-audio-trails-picture]] · [[sfx-diegetic-action-inventory]] · [[pace-cross-cut-acceleration]] · [[sfx-ambience-search-formula]] · [[sfx-split-edit-lead-lag]] · [[sfx-layer-volume-targets]] · [[cut-audio-match]] · [[cut-eye-trace-continuity]] · [[cut-hard-cut-for-new-information]] · [[struct-objection-character-cutaway]] · [[pace-cut-density-from-viewer-intent]] · [[sfx-placement-discipline]]

## Failure modes
- **The futz swaps late.** Three or four frames after the picture with no line spanning the cut, and the sequence audibly stumbles at every cut. Fix: split the voice clip on the exact cut second and verify frame by frame.
- **Swapping mid-word.** Sounds like a dropout or a codec glitch. Fix: swap at the nearest speech gap within 0.4 s, or crossfade over 2–4 frames.
- **Inconsistent swapping.** Some cuts swap, some do not. Reads as a mixing fault, not as a style. Fix: pick strict-perspective or fixed-POV and apply it to every cut.
- **Both voices futzed, or neither, inconsistently.** The viewer cannot tell where they are. Fix: choose `futz_convention` once and hold it.
- **Futz with no presence boost.** Cutting 300 Hz and 3.4 kHz without adding back around 1.8 kHz gives a thin, unintelligible voice — and the fix people reach for, raising the level, makes it loud *and* unintelligible. Fix: `Add Clarity` at 1.8–1.9 kHz, +4 dB.
- **Stacking phone effects.** `telephone` plus a hand-built band-pass, or `telephone` plus `radio-am`, gives a thin cartoonish honk; the doctrine explicitly forbids two costumes. Fix: one preset, then shape with plain filters.
- **Filtering the near voice too.** If we are in the room with them, they are not on a phone to us. Fix: perspective list first, treatment second.
- **Cutting the music with the picture.** Turns one scene into two. Fix: one bed across the whole sequence; the bed is the unifier.
- **One ambience for both locations.** Undoes the entire point of cross-cutting two places. Fix: a bed each, switching on the cut.
- **Putting the handset-leak ambience in the `voiceover` group** so it "follows the voice". Poisons the next carve analysis silently. Fix: it belongs in `ambience`.
- **Trusting a preset-amount lane you have not heard.** A mistyped `fx.preset.<id>` prunes the lane on read with no error. Fix: snapshot and listen, or use the two-clip construction.
- **Flat shot lengths.** Alternating every 3 s for two minutes is a metronome. Fix: accelerate toward the climax at ~0.6× per cycle.
- **Losing the geography.** Both characters looking the same way, no establishing wide, no diegetic ring. Fix: opposed screen direction, and the pick-up/hang-up sounds at minimum.
- **Cutting the dialogue to fit the picture.** Kills the one thing binding the two rooms. Fix: dialogue is locked first; picture is cut to it.
- **Silent render from a missing `id`.** Splitting a voice into three clips means three ids; forget one and that section is silent with no warning.
- **Overlap note:** strand establishment, strand count and cutting-rate structure are not repeated here — take them from [[struct-cross-cutting-parallel-action]] and treat this note as the audio and perspective layer on top.
- **Known gap:** 300–3400 Hz is the documented narrowband telephone range and the wideband 50–7000 Hz figure is documented, but the −4 dB level offset, the compressor settings and — crucially — *when* the remote voice should be futzed versus left clean are practitioner conventions, not cited standards. The documented change at a perspective cut is **level**, with one-frame crossfades. Treat `futz_convention` and `swap_convention` as decisions to log from the reference rather than rules to apply, and judge the rest by ear.
- **Known gap:** this stack has no de-esser and no noise removal, so a source voice with hiss will have that hiss band-limited along with everything else and it will be *more* audible inside the narrow band, not less. There is no fallback — a hissy source needs a better source.
