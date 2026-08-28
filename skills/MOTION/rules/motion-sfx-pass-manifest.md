---
id: motion-sfx-pass-manifest
title: Derive the sound pass from the motion timeline — the motion-event manifest
skill: motion
type: sfx
family: motion-sfx-binding
tags: [skill/motion, type/sfx, family/motion-sfx-binding, sfx/motion, sfx/aesthetic, layer/sfx, engine/hyperframes, engine/epidemic, engine/ffmpeg, engine/remotion, source/editing-kt, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:11:06"
    quote: "Next, go through your video and just add sound effects everywhere it makes sense. If something moves, you should add a whoosh. And if something gets highlighted, a highlight sound."
research_refs:
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://gsap.com/resources/getting-started/Staggers/
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://librosa.org/doc/main/generated/librosa.beat.beat_track.html
  - https://www.nngroup.com/articles/animation-duration/
difficulty: high
detectable_from: transcript+video
---

# Derive the sound pass from the motion timeline — the motion-event manifest

## What it is
The mechanised form of the creator's sound pass. Instead of scrubbing the finished picture hunting for moves, you **emit a manifest from the composition itself** — one row per authored tween that qualifies as a motion event, carrying its timeline position, its duration, the property it moves, its magnitude, and the one number that actually determines placement: the **time of peak velocity**. Each row is then paired with a sound whose audible length matches the move and whose transient is anchored on that peak.

The source gives two event classes and one sound each: *if something moves, add a whoosh; if something gets highlighted, a highlight sound.* [[sfx-unsounded-motion-audit]] is the audit from the sound side and [[motion-sound-bound-motion-event]] states the binding obligation; this note is the machinery — the manifest schema, the peak-velocity arithmetic, the length-matching rule, and the query that fetches the file.

The peak-velocity rule is the part that is almost always got wrong. A sound placed on a move's **first frame** is correct only when the move's velocity peaks on its first frame. For the eases this house actually uses, the peak sits in three different places:

| Ease family | Where velocity peaks | Anchor the transient at |
|---|---|---|
| `power2.out`, `power3.out`, `power4.out`, `expo.out` | at the very start | `t_start` |
| `sine.inOut`, `power2.inOut`, `expo.inOut` | at the midpoint | `t_start + dur/2` |
| `power3.in`, `power4.in` (exits, zoom-through's outgoing half) | at the very end | `t_start + dur` |
| baked spring, `dampingFraction` 0.8–1.0 | early, ≈20 % in | `t_start + 0.2 × dur` |
| `none` (linear) | constant — no peak | `t_start` (treat as an out-ease) |

So a whoosh on a `power3.out` entrance and a whoosh on a `sine.inOut` glide of the same duration are placed **six frames apart** at 30 fps, and only one of them will feel bound to the picture.

## When to use it
- **Once per project, after picture lock and after the motion pass**, as a dedicated pass — not while animating.
- Whenever the composition contains more than about eight authored motion events; below that, place by hand.
- Whenever a project is being reproduced from a reference: the manifest is also the diff format for "the reference sounds 22 moves in 90 s and we have sounded 9".
- It is the correct place to apply the **budget** too: the manifest is the list you subtract from ([[motion-silent-motion-tier]], [[sfx-density-fatigue-audit]]), not just the list you add sound to.

## How to recognise it in a reference video
- **Build the move list first, from picture.** `ffmpeg -vf "select='gt(scene,0.10)',metadata=print"` gives candidate change frames; step 6 frames either side of each to classify it as MOVE (something translates/scales) or HIGHLIGHT (something is marked, glowed, boxed, underlined, colour-shifted).
- **Measure the sound onset against the move's peak frame, not its first frame.** Extract the audio, run an onset detector, and compute `onset − peak` per event. A competent pass clusters at **0 to −2 frames** (sound very slightly early). A pass placed on file-start clusters at **+2 to +15 frames late** and that is the fingerprint of dragging files onto a timeline.
- **Tolerance to judge by:** ITU-R BT.1359-1 puts the *detectability* threshold at **45 ms audio lead / 125 ms audio lag** — at 30 fps that is 1.35 frames early / 3.75 frames late. ATSC IS-191's *acceptability* limits are tighter: **15 ms lead / 45 ms lag** (0.45 / 1.35 frames). Anything later than ~4 frames is heard as a separate event.
- **Length matching.** Measure each sound's audible span (first to last sample above −40 dBFS) against its move's duration. Ratios of **1.5–3×** are the working band. A 2.5 s cinematic whoosh over a 0.25 s card entrance is the most common over-reach.
- **Variety.** Cross-correlate the sound events with each other: if the same file appears more than about four times in 60 s at identical pitch, the reference is repeating an effect and that is the source's own third sound-design mistake.
- **Class separation.** Highlights should be shorter (150–600 ms), brighter (energy above 2 kHz), and quieter than moves. If highlights and moves sound the same, the reference has one effect doing two jobs.
- **Count.** 4–10 sound events per 10 s in a graphic-heavy explainer; above 12 the audit is fatigue, not richness.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `qualifying_magnitude` | 1.5 % of frame height | 1.5–8 % | Below this a move is a drift and gets no sound ([[motion-attention-transient]]). |
| `peak_k` | by ease (table above) | 0.0 / 0.2 / 0.5 / 1.0 | `t_peak = t_start + k × duration`. |
| `sfx_lead` | −0.033 s (−1 f) | −0.067 to 0.000 s | Place the transient 0–2 frames **early**. Never late. |
| `length_ratio` | 2.0× | 1.5–3.0× | Sound's audible length ÷ move duration. |
| `move_sfx_level` | −14 dBFS | −12 to −18 | Source's own layer guidance: SFX −12 to −15 dB with dialogue at 0 to −3. |
| `highlight_sfx_level` | −18 dBFS | −16 to −22 | Highlights sit under moves. |
| `highlight_length` | 300 ms | 150–600 ms | Short and bright. |
| `variant_pool` | 3 | 3–6 | Distinct files per event class per project. |
| `pitch_rotation` | ±2 semitones | ±1 to ±4 | Applied across repeats of the same file so a repeat is not heard as a repeat. Must be **baked** — see the `data-playback-rate` trap below. |
| `events_per_10s` | 6 | 4–10 | Hard ceiling 12. |
| `stagger_group_rule` | one sound | — | A staggered group (items × stagger ≤ 0.5 s) is ONE motion event and gets ONE sound, on the first item's peak. |
| `sfx_track_index` | 12 | 10+ | Audio lives well above visuals; `duplicate_audio_track` warns on overlap within one index. |

## Reproduction prompt

```
Run the sound pass for this composition by deriving it from the motion, not
by scrubbing the picture.

STEP 1 - EMIT THE MANIFEST. Walk every tween authored on the composition's
timeline (and every sub-composition timeline, adding that slot's data-start
to convert scene-local time to global time). Emit one JSON row per tween
whose visible magnitude is at least 1.5% of frame height, or a scale delta of
at least 3%, or a luminance/area change over 10% of frame:
  { "id", "t_start", "dur", "ease", "prop", "magnitude_pct",
    "class": "MOVE" | "HIGHLIGHT", "t_peak" }
Compute t_peak = t_start + k*dur with k = 0.0 for any *.out or linear ease,
0.5 for any *.inOut, 1.0 for any *.in, 0.2 for a baked spring. Collapse a
staggered group into ONE row using the first item's t_start.

STEP 2 - SUBTRACT. Remove rows that are covered by another sound within
0.15s, rows inside a deliberate silence, and rows whose motion is a drift.
Target 4-10 surviving rows per 10s; if you exceed 12, cut the least
editorially important rows first.

STEP 3 - FETCH. For each MOVE row query Epidemic Sound with tagSlugs ANY
["swooshes--whoosh","swooshes--swish"] and duration min = 1500*dur ms,
max = 3000*dur ms. For each HIGHLIGHT row query tagSlugs ANY
["cartoon--pop","mechanical--click","communications--camera"] with duration
150-600ms. Use at least 3 distinct files per class across the project.

STEP 4 - PLACE. For each fetched file, measure the offset from its file start
to its loudest sample (call it PREROLL). Author the audio clip with
data-start = t_peak - PREROLL - 0.033, an id, data-audio-group="sfx",
data-track-index="12", and data-volume set for -14 dB (MOVE) or -18 dB
(HIGHLIGHT) relative to dialogue. Trim with data-media-start rather than
cutting a file.

STEP 5 - VERIFY. Render. For every row, detect the audio onset and confirm it
falls between t_peak - 0.067 and t_peak (0 to 2 frames early, never late).

ACCEPTANCE TEST: no row's sound onset lands more than 45ms before or 45ms
after its t_peak; no file appears more than 4 times in any 60s window at the
same pitch; every <audio> element has an id; the SFX bus never exceeds the
dialogue bus in short-term loudness.
```

## Execution spec

**HyperFrames.** There is **no audio-follows-animation attribute**. The contract is explicit: the two are coupled by the author writing the same number twice — the tween's timeline position and the `<audio data-start>`. The manifest exists precisely to make that duplication mechanical instead of manual.

```html
<!-- MOVE: card slides in at global t = 31.40 on power3.out (peak velocity at t_start) -->
<!-- file's loudest sample is 0.22s into the file -> data-start = 31.40 - 0.22 - 0.033 -->
<audio id="sfx-card-in" src="assets/sfx/whoosh-mid-03.wav"
       data-audio-group="sfx" data-start="31.147" data-duration="0.90"
       data-track-index="12" data-volume="0.5"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.7,&quot;v&quot;:1},{&quot;t&quot;:0.9,&quot;v&quot;:0}]}]}"></audio>

<!-- HIGHLIGHT: underline draws at global t = 34.10, sine.inOut, dur 0.36 -> t_peak 34.28 -->
<audio id="sfx-underline" src="assets/sfx/pop-soft-01.wav"
       data-audio-group="sfx" data-start="34.19" data-duration="0.35"
       data-track-index="12" data-volume="0.28"></audio>
```

```js
// the same numbers, on the picture side
tl.fromTo("#card", { y: 40, autoAlpha: 0 },
                   { y: 0, autoAlpha: 1, duration: 0.35, ease: "power3.out" }, 31.40);
tl.fromTo("#rule-path", { strokeDashoffset: L }, { strokeDashoffset: 0,
                   duration: 0.36, ease: "sine.inOut" }, 34.10);
```

Contract rules that bind this pass:
- **Every `<audio>` needs an `id`.** An id-less audio element is never mixed — a **silent render** with no error.
- Audio JSON attributes must be **double-quoted with `&quot;`** for the JSON's own quotes, or `carve.mjs` cannot see them and will silently overwrite work it could not read.
- A `volume` automation lane **holds its first value backwards** to the clip start — an SFX with a fade-out tail needs an explicit `{"t":0,"v":1}` point.
- Do not both write a `volume` lane and GSAP-tween `volume` on one track (`audio_volume_double_automation` — the lane wins, the tween is ignored).
- `data-volume` max is `3.98` (+12 dB); `1` is 0 dB.
- **`data-playback-rate` is pitch-preserved** (0.1–5). It cannot be used to pitch a whoosh down for weight. Pitch rotation must be **baked** before the file enters the composition — see the ffmpeg line below.
- SFX go in their own group (`sfx`), **never** the `voiceover` carve group — a non-voice clip in the carve group poisons the next re-analysis silently.
- If the motion lives in a sub-composition, the audio at the root needs `data-start = scene-local t + the slot's data-start`. Relative timing (`data-start="el-scene + 0.2"`) can express it, with the four silent-zero failure modes in force (spaces around the operator are mandatory).

**Epidemic Sound.** Verified tag slugs, usable verbatim:

```
MOVE       filter.tagSlugs { matchType: "ANY", values: ["swooshes--whoosh", "swooshes--swish"] }
           filter.duration { min: 400, max: 1400 }        // for a 0.3-0.5s move
HIGHLIGHT  filter.tagSlugs { matchType: "ANY", values: ["cartoon--pop", "mechanical--click",
                                                        "communications--camera"] }
           filter.duration { min: 150, max: 600 }
IMPACT     filter.tagSlugs { matchType: "ANY", values: ["designed--impact", "designed--boom"] }
RISER      filter.tagSlugs { matchType: "ANY", values: ["designed--riser"] }
```

`SearchSoundEffects` with `sort { by: "POPULARITY", order: "DESCENDING" }` for the first pass, then `SearchSimilarToSoundEffect` on the chosen file to build the 3-variant pool. `DownloadSoundEffect` writes a local path; everything after that is HyperFrames.

**ffmpeg — measurement and pitch rotation.**

```bash
# 1. find a file's loudest sample offset (PREROLL) - the number the whole placement depends on
ffmpeg -i whoosh.wav -af "astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.Peak_level" -f null -

# 2. bake a -2 semitone variant, duration preserved
ffmpeg -i whoosh.wav -af "rubberband=pitch=0.8909" whoosh.-2st.wav
# duration-changing alternative (also shortens the file):
ffmpeg -i whoosh.wav -af "asetrate=48000*0.8909,aresample=48000" whoosh.slow.wav

# 3. verify onsets in the render against the manifest
ffmpeg -i out.mp4 -vn -ac 1 -ar 22050 /tmp/mix.wav
python -c "import librosa;y,sr=librosa.load('/tmp/mix.wav');print(librosa.onset.onset_detect(y=y,sr=sr,units='time'))"
```

**Remotion.** `<Audio src startFrom={...}/>` inside the same `<Sequence>` as the visual, with `startFrom` computed from the same peak arithmetic. Concept only.

## Pairs with
[[motion-sound-bound-motion-event]] · [[motion-silent-motion-tier]] · [[sfx-unsounded-motion-audit]] · [[sfx-peak-on-impact-frame]] · [[sfx-peak-on-the-cut]] · [[sfx-density-fatigue-audit]] · [[sfx-placement-discipline]] · [[motion-travel-reveal-streak]] · [[motion-abstract-object-sound-contract]] · [[motion-attention-transient]] · [[sfx-sound-pass-order]]

## Failure modes
- **Anchoring on the file's first sample.** Every effect lands 2–15 frames late, past the ITU 125 ms lag threshold, and the sound reads as a separate event. Correction: measure PREROLL per file and subtract it.
- **Anchoring on the tween's start regardless of ease.** Correct for `*.out`, six frames early for `*.inOut`, twelve frames early for `*.in`. Correction: apply `peak_k`.
- **A 2 s cinematic whoosh on a 0.25 s move.** The sound outlives the picture event and the next 1.75 s has a sound with nothing doing it. Correction: 1.5–3× the move duration, trimmed with `data-media-start`.
- **One whoosh, twenty times.** Correction: a pool of ≥3 files, ±2 semitones baked, rotated.
- **Trying to pitch in-composition with `data-playback-rate`.** It is pitch-preserved — the file gets shorter and sounds identical. Correction: bake with `rubberband` or `asetrate`.
- **Sounding every row.** 20 events in 10 s tires the viewer inside two minutes. Correction: subtract to 4–10 per 10 s and tier the rest as covered or deliberately silent.
- **An `<audio>` with no id.** Silent render, no error, no lint message beyond `media_missing_id`. Correction: id everything.
- **Known gap:** nothing in this stack emits the manifest for you. There is no timeline-introspection API in the contract, so the walk in Step 1 is authored — in practice, keep the manifest as a JSON file next to `STORYBOARD.md` and generate both the tweens and the audio clips from it, so they cannot drift apart.
