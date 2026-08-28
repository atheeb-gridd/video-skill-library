---
id: cut-audio-match
title: Audio match — cut on a sound that both scenes share
skill: editing
type: cut
family: match-cut
tags: [skill/editing, type/cut, family/match-cut, layer/sfx, layer/dialogue, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:01:40
    quote: "and audio, with the sound matches between the two scenes."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:01:17
    quote: "The match cut is a cut that matches action, shape, colour, framing or even audio of two shots, seamlessly bringing the viewer into the next scene."
research_refs:
  - https://arxiv.org/html/2408.10998v1
  - https://denfed.github.io/audiomatchcut/
  - https://www.studiobinder.com/blog/match-cuts-creative-transitions-examples/
  - https://www.toolsforfilm.com/glossary/audio-bridge
  - https://ffmpeg.org/ffmpeg-filters.html#acrossfade
difficulty: high
detectable_from: audio
---

# Audio match — cut on a sound that both scenes share

## What it is
A hard picture cut placed on a sound that is **continued rather than replaced**: a scream becomes a kettle whistle, a phone ring becomes an alarm clock, a helicopter becomes a ceiling fan. The two sounds come from different sources in different scenes, but they are close enough in pitch, timbre and envelope that the ear hears one continuous event and does not register the picture change as a break. It is the third of the three match-cut types the source names, alongside graphic and movement match. The defining test, taken from the research literature, is a **swap test**: if you exchanged the audio between the two scenes, both would still sound plausible.

## When to use it
Where you need the viewer to cross a hard boundary without noticing it, and where the boundary is *aural* — an environment change, a time jump, a change of register (calm to chaotic) that the sound can carry. It is the strongest available join when the two shots have nothing visual in common, which is exactly the case a graphic match cannot serve. In explainer work the highest-value use is the **metaphor join**: a real-world sound in the illustration becomes the UI sound of the product, or a claim's sound becomes the demo's sound. It is also the right device for entering and leaving a demonstration window. Do not attempt it when either sound is under a spoken line — you cannot hear the match through dialogue, and the whole payload of the technique is heard, not seen.

## How to recognise it in a reference video
- **The picture cut and the sound event are not on the same frame.** That is the primary tell. Extract audio and look at the boundary: an audio match has **one continuous sonic event spanning the cut**, typically starting **6–20 frames (0.2–0.7 s) before** the picture change and continuing **6–24 frames after**.
- **Spectrogram continuity across a picture discontinuity.** Generate both and compare:
  `ffmpeg -ss <t-1.5> -t 3 -i ref.mp4 -lavfi showspectrumpic=s=1600x800:legend=1 spec.png`
  A match shows the energy band continuing across the cut frame with, at most, a small step in the harmonic stack. A plain cut shows the band stopping and a different one starting.
- **Measure four things and check tolerances:**
  - **Fundamental / dominant pitch** within **±2 semitones** (≈ ±12%). Beyond ±4 semitones the ear hears two sounds.
  - **Spectral centroid ratio** (brightness) within **±25%**.
  - **Envelope class identical** — both sustained, or both transient-with-decay. A transient answered by a sustain is a *sound bridge*, not a match.
  - **Loudness within ±1.5 LU** across the join: `ffmpeg -i ref.mp4 -af ebur128=peak=true -f null -` on 1-second windows either side.
- **The swap test, applied by ear.** Play scene A's picture with scene B's audio. If it is plausible, it is a match pair; if it is absurd, the editor was using a sound bridge to paper over a cut.
- **Crossfade length at the join.** Audible practice clusters at **0.25–0.5 s (8–15 frames)**; in the research evaluation, fixed crossfades in that band scored **1.71–1.75 out of 3** against **0.82** for a bare concatenation, and an adaptive length scored **2.14**. A join with no crossfade at all usually clicks.
- **Distinguish from the neighbours.** A **J cut** brings the *next* scene's own audio in early; an **L cut** holds the *current* scene's audio over the new picture; an **audio bridge** carries one continuous source across. An audio *match* has **two different sources** that sound alike. Log which one you actually found, because the reproduction differs.
- **Transcript check.** The join should sit in a narration gap. If a word straddles the cut, the match is inaudible and something else is doing the work.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `pitch_tolerance` | ±2 st | 0–4 st | Semitones between the two sounds' dominant pitch. |
| `centroid_tolerance` | ±25% | ±10–40% | Spectral centroid ratio; brightness match. |
| `envelope_class` | identical | — | sustained↔sustained or transient↔transient. Not mixable. |
| `loudness_match` | ±1.0 LU | ±0–1.5 LU | Measured with `ebur128` on 1 s windows either side. |
| `crossfade_dur` | 0.35 s (10.5 f) | 0.20–0.60 s | 0.25–0.50 s is the researched practical band. Below 0.15 s expect a click; above 0.8 s the match turns into a dissolve of sound and loses its edge. |
| `fade_curve` | equal-power (`qsin`) | `qsin` \| `hsin` \| `tri` | Linear (`tri`) crossfades dip ≈3 dB at the midpoint on uncorrelated material. Equal-power holds level. |
| `audio_lead` | 0.30 s (9 f) | 0.20–0.70 s | How long before the picture cut the shared sound is already audible. |
| `audio_tail` | 0.40 s (12 f) | 0.20–0.80 s | How long after. |
| `picture_cut_offset` | 0 f from the sound's peak | −6 to +6 f | Where the picture change sits relative to the shared sound's loudest frame. On the peak is the default; a few frames early feels driven, a few late feels heavy. |
| `dialogue_clearance` | 0.35 s | 0.25–0.60 s | Minimum narration gap either side of the join. |
| `eq_morph` | off | off \| 1 band | A single `peaking` node whose frequency is automated from A's dominant band to B's, across the crossfade. Use only when the pitch tolerance is at its limit. |
| `matches_per_video` | 1 | 0–3 | The device is conspicuous by design; more than three reads as a showreel. |

## Reproduction prompt

```
Build an audio match cut at the section boundary {{CUT}} (composition seconds,
30fps).

1. IDENTIFY THE PAIR. Name the two sounds in one clause each ("the kettle
   whistle in shot A" / "the train brake in shot B"). Then run the SWAP TEST:
   play A's picture against B's audio. If implausible, reject the pair; you
   have a sound bridge, not a match.

2. MEASURE both sounds on a 1.0s window centred on each one's peak:
     - dominant pitch  (must be within 2 semitones)
     - spectral centroid (within 25%)
     - envelope class (both sustained, or both transient)
     - integrated loudness (bring within 1.0 LU using a static gain, not a
       compressor)
   If pitch is outside 2 semitones, pitch-shift the SECOND sound - never the
   first - by at most 3 semitones and re-measure. If it is still outside,
   reject the pair.

3. LAY THE SOUND ACROSS THE CUT. Trim so that:
     shared-sound A runs from {{CUT}} - 0.30s and ends at {{CUT}} + 0.05s
     shared-sound B starts at {{CUT}} - 0.30s and runs to {{CUT}} + 0.40s
   i.e. they overlap by 0.35s straddling the cut. Fade A out and B in across
   that overlap with EQUAL-POWER curves (both at 0.707, not 0.5, at the
   midpoint). Do not use linear fades - they dip about 3 dB at the crossover.

4. PLACE THE PICTURE CUT on the shared sound's loudest frame: a hard cut, zero
   frames of dissolve. Both shots are otherwise untouched.

5. CLEAR THE DIALOGUE. There must be at least 0.35s of narration silence
   either side of {{CUT}}. If a spoken word straddles the cut, move the cut -
   the match is inaudible under speech and the technique is wasted.

6. Duck or stop the music bed across the join by 6 dB with a 0.2s ramp, so the
   match is the loudest thing in the mix for its half second.

ACCEPTANCE TEST: (a) play the join with the picture hidden - it must sound like
ONE event, and you must not be able to say where the join is; (b) play it with
the sound muted - the picture cut must look like an ordinary hard cut, no
softening; (c) step the boundary frame by frame - the picture change is on the
sound's peak frame +/-1; (d) measure loudness on 1s windows either side: within
1.5 LU. If a viewer describes it as "a cool transition", the crossfade is too
long or the two sounds are too different.
```

## Execution spec

**Measurement (ffmpeg).** Loudness either side, and the spectrogram evidence:

```bash
T=71.4
ffmpeg -ss $(echo "$T-1.0" | bc) -t 1.0 -i ref.mp4 -af ebur128=peak=true -f null - 2>&1 | tail -20
ffmpeg -ss $T                    -t 1.0 -i ref.mp4 -af ebur128=peak=true -f null - 2>&1 | tail -20
ffmpeg -ss $(echo "$T-1.5" | bc) -t 3.0 -i ref.mp4 -lavfi showspectrumpic=s=1600x800:legend=1 -update 1 spec.png
```

**Baking the joined sound (ffmpeg), when it must be a single asset.** `acrossfade` is the right filter and its default curve is linear — override it:

```bash
# equal-power 0.35s crossfade between the two shared sounds
ffmpeg -i sound_a.wav -i sound_b.wav \
  -filter_complex "[0][1]acrossfade=d=0.35:c1=qsin:c2=qsin[out]" -map "[out]" match.wav
# optional: shift B up 2 semitones first (2^(2/12) = 1.1225)
ffmpeg -i sound_b.wav -af "asetrate=48000*1.1225,aresample=48000,atempo=1/1.1225" sound_b.up2.wav
```

**HyperFrames — the picture is a hard cut, the sound is two overlapping clips.** Picture: back-to-back clips, no transition, exploiting the half-open window. Sound: two `<audio>` clips with mirrored `volume` lanes.

```html
<!-- PICTURE: hard cut at 71.4s, no dissolve, no registry transition -->
<video id="shot-a" src="assets/a.mp4" muted playsinline class="clip"
       data-start="66.0" data-duration="5.4" data-media-start="12.0" data-track-index="0"></video>
<video id="shot-b" src="assets/b.mp4" muted playsinline class="clip"
       data-start="71.4" data-duration="6.0" data-media-start="3.2" data-track-index="0"></video>

<!-- SOUND: the shared event, overlapping 0.35s across the cut, equal-power -->
<audio id="match-a" src="assets/sfx/kettle.wav" data-audio-group="sfx"
       data-start="71.10" data-duration="0.35" data-track-index="12" data-volume="0.5"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1.0},{&quot;t&quot;:0.175,&quot;v&quot;:0.707},{&quot;t&quot;:0.35,&quot;v&quot;:0}]}]}"></audio>
<audio id="match-b" src="assets/sfx/brake.wav" data-audio-group="sfx"
       data-start="71.10" data-duration="0.75" data-track-index="13" data-volume="0.5"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.175,&quot;v&quot;:0.707},{&quot;t&quot;:0.35,&quot;v&quot;:1.0},{&quot;t&quot;:0.75,&quot;v&quot;:0}]}]}"></audio>
```

Contract points that bind this:
- **`0.707` at the midpoint is the whole trick.** A lane's `v` is linear volume, so two lanes crossing at `0.5` sum to −6 dB of correlated power and −3 dB of uncorrelated power — an audible hole exactly where the match must be seamless. Crossing at `0.707` (−3 dB) holds constant power.
- A lane **holds its first value backwards to the clip start and its last value forward to the end**, so both lanes need explicit `t:0` points.
- The two audio clips are on **different `data-track-index` values**. Two `<audio>` elements sharing a track index *and* overlapping in time raise `duplicate_audio_track`.
- Every `<audio>` needs an `id`; an id-less audio element is never mixed and renders silent.
- Put them in the `sfx` group, **never** in the `voiceover` carve group — a non-voice clip inside the carve group silently poisons the next carve re-analysis.
- **Do not use a registry transition here.** All five (`crossfade`, `blur-crossfade`, `push-slide`, `zoom-through`, `squeeze`) animate the scene wrappers and would soften the picture cut, which is the opposite of the intent. The picture cut must be hard: `shot-b.start === shot-a.start + shot-a.duration`.
- There is no audio-follows-picture attribute. The picture cut time and the audio `data-start` are **the same number written twice**. If the picture cut lives inside a sub-composition at scene-local `t`, the root-level audio needs `data-start = t + slot data-start`.
- The optional EQ morph is a `peaking` node with an automated `frequency` (frequency is AUTO-capable): `data-fx-chain` on `#match-b` with `{"type":"peaking","id":"n1","label":"Match Morph","params":{"frequency":900,"gain":4,"q":1.2}}` plus a lane `{"target":"fx.n1.frequency","points":[{"t":0,"v":900},{"t":0.35,"v":1600}]}`. A typo'd `nodeId` is **pruned on read** with no error.
- Avoid `reverb`/`delay` on either clip: effects with a tail make the rendered track longer than `data-duration` (`chainTailSeconds`) and will smear the join.

**Epidemic Sound.** You are looking for two *different* sounds that are acoustically close, so search each side separately and use duration as the discipline:

```
SearchSoundEffects({ query: { term: "kettle whistle steam sustained" },
                     filter: { duration: { min: 800, max: 2500 } }, first: 10 })
SearchSoundEffects({ query: { term: "train brake squeal metal" },
                     filter: { duration: { min: 800, max: 2500 } }, first: 10 })
```
Then `SearchSimilarToSoundEffect` on whichever side you picked first — that is the fastest route to an acoustically adjacent partner. `DownloadSoundEffect` into `assets/sfx/`.

**Remotion:** two `<Audio>` elements inside overlapping `<Sequence>`s with `volume={f => …}` callbacks shaped as √ curves, and a hard `<Sequence>` boundary for picture; concept only.

## Pairs with
[[cut-graphic-match]] · [[cut-j-audio-leads-picture]] · [[cut-movement-match]] · [[cut-dissolve]] · [[sfx-whoosh-transition-movement-reveal]] · [[pace-silent-demonstration-window]] · [[sfx-riser-to-music-drop-backtiming]] · [[struct-demo-before-label]] · [[pace-cut-on-the-beat]] · [[cut-match-cut]]

## Failure modes
- **Linear crossfade.** The commonest technical error: both sides at 0.5 at the midpoint, producing an audible level dip precisely at the join, which the ear reads as a cut. Correction: equal-power — 0.707 at the crossover, or `acrossfade=c1=qsin:c2=qsin`.
- **Crossfade too long.** Past ~0.8 s the two sounds are audibly both present and the audience hears a mix, not a match. Correction: 0.25–0.50 s.
- **No crossfade at all.** Bare concatenation clicks and scored worst in the research evaluation (0.82/3). Correction: minimum 0.20 s.
- **Sounds too far apart in pitch or brightness.** Beyond ±4 semitones the ear separates them and the cut is exposed. Correction: reject the pair, or pitch-shift by ≤3 semitones — never more, or the second sound stops being itself.
- **Level mismatch.** A 4 LU jump at the join is heard as an edit even when the timbres match. Correction: static gain to ±1 LU before any fades.
- **Placed under dialogue.** The match is inaudible and the effort is invisible. Correction: 0.35 s of narration clearance both sides.
- **Music left running loud.** The bed masks the match. Correction: 6 dB dip across the join.
- **Overuse.** Correction: one per video, three absolute maximum.
- **Known gap:** the pitch/centroid/envelope tolerances here are house thresholds derived from the cited research's similarity framing, not published limits — the research defines the match by learned embedding similarity, not by named acoustic tolerances. Nothing in this stack measures them for you: the measurement is a manual `ebur128`/`showspectrumpic` step and must be recorded in the design document.
