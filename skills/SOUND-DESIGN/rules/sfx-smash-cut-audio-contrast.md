---
id: sfx-smash-cut-audio-contrast
title: The smash cut, from the audio side — measuring and building the jolt
skill: sound-design
type: mix
family: contrast
tags: [skill/sound-design, type/mix, family/contrast, engine/hyperframes, engine/ffmpeg, engine/epidemic, engine/remotion, sfx/aesthetic, layer/sfx, layer/music, layer/ambience, layer/dialogue, source/editing-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:05:03"
    quote: "It's a harsh, abrupt cut from one scene to the next, with contrasting visuals and audio."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:05:11"
    quote: "An example of a smash cut could be a loud, chaotic scene that suddenly cuts to a quiet, simple one."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:06:04"
    quote: "If you want to give some dramatic emphasis to a scene, you can use this sound effect there — it makes moments quite powerful, those moments."
research_refs:
  - https://en.wikipedia.org/wiki/Smash_cut
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: transcript+video
---

# The smash cut, from the audio side — measuring and building the jolt

## What it is
The deliberate opposite of a seamless cut: *"a harsh, abrupt cut from one scene to the next, with contrasting visuals and audio."* Everything the continuity pass works to reduce — brightness difference, shot-scale difference, motion difference, loudness difference — is maximised instead, so the join itself becomes punctuation. Film reference describes the same asymmetry: *"a disparity in the type of scene on either side of the cut is often present, going from a fast-paced frenzied scene to a tranquil one."*

The mistake this note exists to prevent is treating the smash cut as a *picture* move with the audio left to follow. **Audio carries most of the jolt.** A cut from a bright, busy shot to a dark, still one whose soundtrack level barely changes reads as an ordinary cut in an inconsistent grade. A cut whose loudness falls 15 LU in one frame reads as a smash cut even if the two shots look similar. So the audio contrast is the parameter, and it is measurable.

There are two audio treatments, and they are not interchangeable. **Loud → quiet** (the source's own example) is a *subtraction*: everything drops on the frame, and the quiet side is what lands. **Quiet → loud** is an *addition*, usually an impact or a hit on the incoming frame. Both are smash cuts; they punctuate opposite kinds of sentence.

**Style.** Filed `sfx/aesthetic`: the jolt is engineered for feel, and the measured loudness step is the instrument. The material on either side of the join is usually each scene's own bed, which is diegetic and is handled in [[sfx-ambience-bridge-across-cut]].

## When to use it
- **At a hard structural boundary** where the join should be felt: cold open into title, problem into solution, setup into payoff, a "but here's what actually happened" reversal.
- **Loud → quiet, for gravity.** After a dense montage or a fast run of cuts, smash to a still shot and near-silence for the one sentence that matters. This is the strongest version of [[sfx-music-hard-stop]] and it pairs with it.
- **Quiet → loud, for a reveal or a comic reversal.** The Gilligan variant — a character declares an intention, then a cut *"depicting the character doing the exact opposite"* — is a quiet→loud smash cut and it wants a hit, not a whoosh.
- **Once or twice per video.** The jolt is an orienting response and the orienting response habituates. Three smash cuts is a style; six is noise, and by then nothing lands.
- **Not as a transition between related points.** Related material wants a straight cut or the primary transition ([[cut-straight-hard-cut]]).
- **Not where a whoosh belongs.** A whoosh smooths a join; the smash cut *is* the absence of smoothing. Putting a transition sweep over a smash cut cancels it, and this is the most common way the move gets ruined ([[sfx-full-screen-transition-sound-layer]]).
- **Not when the two sides are similar.** A smash cut between two medium shots of the same person in the same room at the same volume is just a jump cut.

## How to recognise it in a reference video
Measure four deltas across the join. **Three of the four should be large; if only one is, it is not a smash cut.**

- **Loudness delta — the primary signal.** Measure momentary loudness in the EBU R 128 momentary window, which is exactly **400 ms**, on each side of the cut:
  ```bash
  ffmpeg -i ref.mp4 -vn -ar 48000 -af "ebur128=metadata=1:framelog=verbose" -f null - 2>&1 \
    | grep -E 'M:' | head -2000
  # or a per-400ms RMS trace, aligned to the cut list
  ffmpeg -i ref.mp4 -vn -ar 48000 -af "asetnsamples=n=19200,astats=metadata=1:reset=1,\
    ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
  ```
  | Momentary delta | Reads as |
  |---|---|
  | < 4 LU | an ordinary cut |
  | 4–8 LU | a level change; noticeable but not a jolt |
  | **8–20 LU** | **a smash cut — the working band** |
  | 20–28 LU | a hard smash; verify the quiet side is not below the ambience floor |
  | > 28 LU, or into true digital silence | reads as a dropout or a technical fault, not a choice |
- **Luminance delta.** `ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=-" -f null -`. A YAVG change of **more than 25 %** of range across one frame boundary, with no transition frames between, is the picture half.
- **Shot-scale and framing delta.** Wide→close or close→wide, plus a subject-position change of more than a third of frame width. Two shots at the same scale rarely smash.
- **Motion-energy delta.** `ffmpeg -i ref.mp4 -vf "select='gt(scene,0.4)',showinfo" -f null -` plus a frame-difference trace. Frenzied→still is the canonical shape.
- **Then look at the frame boundary itself, sample-accurately.** Zoom to the waveform at the cut:
  - **No crossfade.** A smash cut has a vertical edge in the waveform. Any visible 2–20 frame ramp means someone applied a crossfade and the move is gone.
  - **A 1–6 frame gap of digital silence** immediately after the cut, before the incoming bed starts, is a deliberate device and worth logging separately. A gap under about **20 ms** would be swallowed by backward masking and is therefore *not* the device — if you can hear it, it is longer than 20 ms.
  - **A single low impact or hit** straddling the boundary, its peak on the incoming first frame, is the quiet→loud form.
- **Check what survives on the quiet side.** A competent loud→quiet smash keeps a low ambience or room-tone bed running; the level drops 8–20 LU but does not reach silence. A cut to true silence is a different, riskier move.
- **Transcript check.** The line immediately after a loud→quiet smash is almost always the thesis, a number, or a direct address. The line immediately *before* a quiet→loud smash is almost always a claim the cut is about to contradict.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `momentary_delta` | 14 LU | 8–20 LU | Measured in the R 128 momentary (400 ms) window either side. The single most important number in this note. |
| `crossfade` | **0 frames** | 0 frames only | Any ramp cancels the move. The de-click fade below is not a crossfade. |
| `declick_fade` | 2 ms | 1–5 ms | ~0.06 frames. Removes the broadband click a mid-waveform cut produces, and is far too short to be heard as a fade. |
| `silence_gap` | 0f | 0–6f (0–200 ms) | Optional device on the loud→quiet form. Under 20 ms is masked and pointless; 2–6f reads as a held breath. |
| `quiet_side_floor` | −24 dB rel. dialogue | −30 to −20 dB | Keep ambience or room tone alive. True digital silence reads as a fault. |
| `impact_gain` | 0.251 (−12 dB) | 0.200–0.316 (−14 to −10 dB) | Quiet→loud form only. Louder than a normal SFX because it *is* the event. |
| `impact_anchor` | peak on the incoming first frame (+0f) | −1f to +1f | Tighter than a transition sweep; this is a punctuation mark. |
| `impact_len` | 2.0 s | 1.0–3.5 s | Cinematic booms are long. Let the tail run into the new scene. |
| `luminance_delta` | 30 % of range | 25–60 % | The picture half of the contrast. |
| `per_video` | 1 | 1–3 | The orienting response habituates. |
| `true_peak_ceiling` | −1 dBTP | −2 to −1 dBTP | The loud side is where a mix clips. R 128's own ceiling. |
| `recovery` | 1.5 s | 0.8–4 s | How long the quiet side is held before anything is added back. Under 0.8 s the jolt has no room to land. |

## Reproduction prompt

```
Build a smash cut at {{CUT}} seconds (composition time), direction
{{DIR}} = LOUD_TO_QUIET or QUIET_TO_LOUD.

1. VERIFY THE PICTURE CONTRAST FIRST. Measure YAVG either side; require a
   change of at least 25% of range, plus a shot-scale change (wide<->close).
   If the two shots look alike, this is a jump cut and the audio work will
   not rescue it - fix the picture or pick a different boundary.
2. MEASURE THE CURRENT LOUDNESS in the 400 ms window either side of {{CUT}}
   with ffmpeg ebur128. Record momentary_out and momentary_in.
3. HIT THE TARGET DELTA of 14 LU (accept 8-20).
   IF LOUD_TO_QUIET:
     a) End every music and SFX clip exactly at {{CUT}} with a hard out -
        a volume lane whose last two points are 2 ms apart, v:1 then v:0.
        No crossfade, no ramp.
     b) Leave the ambience bed running across the cut at -24 dB relative to
        dialogue. Do NOT cut to digital silence.
     c) Hold the quiet side for at least 1.5 s before adding anything back.
   IF QUIET_TO_LOUD:
     a) Fetch one low cinematic boom, 1-3.5 s. Place it so its PEAK lands on
        the incoming first frame: data-start = {{CUT}} - PEAK_SRC.
     b) Gain 0.251. Let the tail run past the cut into the new scene.
     c) Bring music in on the same frame, at full section level, with no
        fade-in.
4. DE-CLICK. A hard cut mid-waveform produces a broadband click. Either land
   the out-point on a zero crossing or use the 2 ms ramp from 3a. Never
   solve a click by lengthening the fade.
5. DO NOT ADD A WHOOSH. A transition sweep across the boundary reads as
   smoothing and destroys the contrast. If a sweep feels necessary, this
   moment wanted a normal transition, not a smash cut.
6. CHECK THE CEILING on the loud side: true peak must stay at or under
   -1 dBTP.
7. RE-MEASURE the momentary delta and confirm it is in 8-20 LU.
8. COUNT smash cuts in the whole video. More than 3 and the earlier ones
   have stopped working - delete the weakest.

ACCEPTANCE TEST: play from 3 s before to 3 s after with picture, once, at
normal volume. The join must register in the body before you have time to
analyse it. Then play audio only: the jolt must still be there. If it is
only there with picture, the audio contrast is too small - increase the
delta by 4 LU and repeat.
```

## Execution spec

**Hyperframes — a smash cut is authored as two clips meeting exactly, with no overlap.** The visibility window is **half-open**, `[start, start + duration)`, which is precisely what this move needs: *"Two clips can therefore be authored back to back (`b.start === a.start + a.duration`) with no overlapping frame."*

```html
<!-- LOUD -> QUIET at 62.40s -->
<video id="shot-busy" src="assets/montage.mp4" data-start="58.00" data-duration="4.40"
       data-track-index="0" muted playsinline></video>
<video id="shot-still" src="assets/still-wide.mp4" data-start="62.40" data-duration="6.00"
       data-track-index="0" muted playsinline></video>

<!-- music dies on the frame: last two lane points 2 ms apart -->
<audio id="bgm-montage" src="assets/bgm/build.wav"
       data-audio-group="music" data-start="48.00" data-duration="14.40"
       data-track-index="14" data-volume="0.100"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:14.398,&quot;v&quot;:1},{&quot;t&quot;:14.4,&quot;v&quot;:0}]}]}"></audio>

<!-- ambience survives the cut and holds the floor -->
<audio id="amb-room" src="assets/sfx/room-tone.wav"
       data-audio-group="ambience" data-start="48.00" data-duration="24.00"
       data-track-index="13" data-volume="0.063"></audio>
```

```html
<!-- QUIET -> LOUD at 62.40s: boom peak on the incoming first frame -->
<audio id="sfx-smash-boom" src="assets/sfx/cinematic-low-boom.wav"
       data-audio-group="sfx" data-start="62.15"   <!-- 62.40 - 0.25 PEAK_SRC -->
       data-duration="2.60" data-track-index="22" data-volume="0.251"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:2.0,&quot;v&quot;:1},{&quot;t&quot;:2.6,&quot;v&quot;:0}]}]}"></audio>
```

Contract points that decide the result:
- **There is no crossfade attribute and no audio transition primitive**, which is convenient here — the default behaviour of two abutting clips *is* a hard cut. To get a crossfade you would have to author overlap plus lanes; a smash cut is simply not doing that.
- **The 2 ms de-click ramp goes in the volume lane, not in a separate fade.** Lane `t` is clip-local seconds, so on a clip starting at 48.00 with duration 14.40, the last points are `t: 14.398` and `t: 14.4`. Author in seconds; there is no frame attribute.
- **A lane holds its first value backwards to the clip start**, so include `t: 0`.
- **Never GSAP-tween `volume` on a track that has a `volume` lane** — `audio_volume_double_automation`, the lane wins silently and your hard out disappears.
- **`data-hidden` is not the tool for a mute.** It drops the element from the mix entirely in preview and render; for a level move use the lane.
- **Do not put the boom in the `voiceover` group.** SFX in the carve group silently poisons the next carve re-analysis. `data-audio-group="sfx"`.
- **`reverb` on the boom adds `chainTailSeconds`**, so the clip outlives its `data-duration` — usually desirable on the quiet→loud form, but it means the authored tail ramp is not the last thing heard.
- **Nothing in lint checks any of this.** *"Almost no static gate covers the mix."* The verification is the ffmpeg measurement plus a listen.

**ffmpeg — measure, and bake only for export.**
```bash
# momentary loudness trace, R128 momentary window = 400 ms
ffmpeg -i ref.mp4 -vn -ar 48000 -af "ebur128=metadata=1:framelog=verbose" -f null - 2>&1 | grep ' M:'

# true peak and integrated, for the ceiling check
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -

# luminance either side of the cut
ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=-" -f null -

# if a real file cut is needed (export only), do NOT use acrossfade here -
# acrossfade always ramps. concat the two pieces instead:
printf "file '%s'\n" a.wav b.wav > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy joined.wav
```
`acrossfade` is the wrong filter for this move by definition — *"Apply cross fade from one input audio stream to another"* — and its `curve1`/`curve2` parameters exist to shape a ramp you do not want. Reach for it on a J-cut, never on a smash cut.

**Epidemic Sound — only the quiet→loud form needs a fetch.** Live-verified: `designed--boom` holds **2841 files** between 1000 and 4000 ms, with top hits titled "Designed, Boom, Cinematic Hit, Low Boom" and "Designed, Boom, Impact, Dark, Cinematic, Downer".

```
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ANY, values: ["designed--boom"] },
            duration: { min: 1000, max: 3500 } },
  sort:   { by: POPULARITY, order: DESCENDING }, first: 20
}
# alternates by intent
SearchSoundEffects { query: { term: "cinematic impact hit sub drop" }, filter: { duration: { min: 1000, max: 4000 } } }   # 2841 results
SearchSoundEffects { query: { term: "braam trailer hit dark" } }
SearchSoundEffects { query: { term: "reverse cymbal reverse impact" } }   # for the loud->quiet form's optional lead-in
DownloadSoundEffect { id: <uuid>, options: { fileType: WAV } }
```
For the **loud→quiet** form there is nothing to fetch — the move is subtraction — except the ambience bed that holds the floor on the quiet side (`SearchSoundEffects { query: { term: "<location> ambience room tone" } }`, see [[sfx-ambience-search-formula]]). Download **WAV**: mp3 pre-echo smears the transient this whole note is built around.

**Remotion:** two `<Sequence>` blocks abutting with no overlap, and an `<Audio>` `volume` callback returning 0 from the cut frame onward. Concept only; Remotion is not part of this stack.

## Pairs with
[[cut-smash-cut]] · [[cut-smash-cut-loud-to-quiet]] · [[sfx-music-hard-stop]] · [[sfx-silence-as-pattern-interrupt]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-bass-drop-under-impact]] · [[sfx-ambience-search-formula]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-layer-volume-targets]] · [[sfx-transient-masked-outpoint]] · [[motion-pattern-interrupt-jolt]] · [[motion-camera-shake-impact]] · [[pace-deliberate-continuity-break]] · [[cut-straight-hard-cut]] · [[sfx-full-screen-transition-sound-layer]] · [[struct-stimulation-budget]]

## Failure modes
- **A picture-only smash cut.** The two shots contrast and the soundtrack does not. Reads as a grading inconsistency. Fix: measure the momentary delta and get it above 8 LU.
- **A crossfade at the join.** Even 4 frames of ramp turns the smash cut into a dissolve with a hard edge. Fix: zero crossfade; use the 2 ms de-click ramp only.
- **A whoosh over the boundary.** Cancels the contrast by smoothing exactly what should be rough. Fix: delete it. If the moment wants a sweep, it wanted an ordinary transition.
- **Cutting to true digital silence.** Reads as an equipment failure, not as gravity. Fix: keep ambience or room tone at −24 dB relative to dialogue across the join.
- **A click at the cut.** A hard cut through a non-zero sample is a step discontinuity and steps are broadband. Fix: zero crossing or 2 ms ramp — not a longer fade.
- **A 10 ms gap of "silence".** Backward masking is about 20 ms, so a gap that short is inaudible and you have added nothing. Fix: 2–6 frames if you want the gap heard, or none at all.
- **Clipping the loud side.** The frame where everything arrives at once is where true peak goes over. Fix: check `loudnorm`'s `input_tp`, keep it at or under −1 dBTP, limiter last in the chain.
- **Too many.** By the fourth smash cut the orienting response has habituated and the first three have retroactively stopped working. Fix: one or two, three at the absolute most.
- **The recovery is too fast.** Music back in 0.3 s after the smash means the quiet side never landed. Fix: hold at least 1.5 s.
- **Known gap:** EBU R 128 defines the measurement windows and the gate but **publishes no figure for an acceptable loudness jump between adjacent programme items**, so the 8–20 LU band here is derived from the meter's own momentary window plus the perceptual constraint at each end (below ~4 LU nothing is noticed; at digital silence it reads as a fault) rather than quoted from a standard. Treat it as a calibrated default and let a listen decide.
