---
id: sfx-bpm-perceptual-bands
title: BPM as the energy dial — the bands, the frame arithmetic, and matching tempo to delivery
skill: sound-design
type: music
family: music-search
tags: [skill/sound-design, type/music, family/music-search, layer/music, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:13
    quote: "if your music is 60 BPM, that means 60 beats per minute. That is, one beat every second... The higher the BPM, the faster and more energetic your music will feel."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:18
    quote: "So if you're talking fast in the video, a high BPM will feel good; and if you're talking slowly, low BPM music will suit it better."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:28
    quote: "Don't flip the two around — the video will feel really odd."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:35
    quote: "I mostly use 100-120 BPM music, because I talk a little fast."
research_refs:
  - https://en.wikipedia.org/wiki/Tempo
  - https://en.wikipedia.org/wiki/Arousal
  - mcp://Epidemic_sounds/SearchRecordings (bpm filter behaviour probed live, 2026-08-28)
difficulty: low
detectable_from: audio
---

# BPM as the energy dial — the bands, the frame arithmetic, and matching tempo to delivery

## What it is
BPM is defined from first principles in the source — *"60 BPM… is one beat every second"* — and then given a job: it is the **perceived-energy control** of a video's music. *"The higher the BPM, the faster and more energetic your music will feel."* Higher reads faster and more activated; lower reads calmer. It is the arousal axis of [[sfx-mood-map-per-topic]] expressed as a single number you can filter a library by.

Two things turn that from a slogan into a usable control.

**One: BPM is exact arithmetic, not a vibe.** One beat lasts `60 / BPM` seconds, one four-beat bar lasts `240 / BPM` seconds, and at 30 fps one beat is `1800 / BPM` frames. That makes BPM the only music parameter that converts directly into edit timing: at 120 BPM a beat is exactly 15 frames, so a cut every 15, 30 or 60 frames is on-grid by construction. Every beat-locked technique in this library ([[sfx-cut-on-the-beat]], [[sfx-beat-aligned-handover]], [[sfx-riser-to-music-drop-backtiming]]) is downstream of this one conversion.

**Two: the perceptual bands are already named.** Classical tempo markings are a published mapping from BPM to felt speed, and they line up usefully with editorial energy language: **Largo 40–66**, **Adagio 44–66**, **Andante 56–108**, **Andante moderato 80–108**, **Moderato 108–120**, **Allegretto 112–120**, **Allegro 120–156**, **Vivace 156–176**, **Presto 168–200**. Note where the creator's own default sits: **100–120 BPM** straddles *Andante moderato* into *Moderato* — the "walking, purposeful, not urgent" region, which is exactly right for a presenter who talks *"a little fast"* over pictures that must remain readable.

The coupling rule is the source's, and it is one-directional: **match the tempo to the delivery, and never invert it.** Fast talking over slow music sounds like the video is dragging its speaker; slow talking over fast music sounds anxious and cheap. *"Don't flip the two around — the video will feel really odd."*

## When to use it
- **As the first filter of every music search**, before instrument and before mood. It is the disqualifier that makes the rest of the search cheap ([[sfx-bpm-filter-first]], [[sfx-three-parameter-music-search]]).
- **When translating a mood map row into a query.** The arousal number picks the band; this note is the lookup.
- **When a section needs to feel faster or slower without changing the cut.** Changing the band is the cheapest energy edit available — no re-cut, no re-shoot.
- **Before planning any beat-locked motion.** If titles are going to land on beats, the BPM must be chosen before the animation timings are authored, because `1800 / BPM` sets the frame grid.
- **When a video feels "off" and both the picture and the music are individually fine.** That is the inversion case nine times out of ten: measure the presenter's rate and the track's BPM and check they are on the same side of the middle.
- **Not** as a mood control. BPM sets arousal only. A 140 BPM track can be joyful or frantic; that is valence, and it comes from mood and instrument ([[sfx-mood-vibe-filter]], [[sfx-instrument-filter-search]]).

## How to recognise it in a reference video
- **Measure the track's BPM, don't guess it.** Tap along for 16 beats and divide, or use the arithmetic in reverse: find two clear kick transients, measure the gap in seconds, `BPM = 60 / gap`. Epidemic returns `bpm` as an integer field on every recording, so if the reference used a library track the number is retrievable.
- **Measure the delivery rate in the same passage.** Count words in a clean 30 s of speech and multiply by two → words/min. Log both numbers together; the *pair* is the finding, not either alone.
- **Check the cut grid.** Convert: `frames per beat = 1800 / BPM` at 30 fps. Then measure shot lengths in frames across a 60 s stretch. If a large share cluster on integer multiples of that number (±2 frames), the editor cut to the grid — a strong, checkable signal.
- **Band changes at section boundaries.** Log each track's BPM against the segment map. A mapped video steps between bands at boundaries; an unmapped one uses one band throughout.
- **The inversion tell.** Slow music (<90 BPM) under speech faster than ~170 wpm, or fast music (>140 BPM) under speech slower than ~120 wpm. Both are audible as "off" before anyone can name why.
- **Spectral cross-check for the band.** Fast bands almost always bring more high-frequency percussive density; if the music's 5–10 kHz energy is dense and continuous, expect ≥120 BPM even before tapping.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Band 1 — calm | 60–85 BPM | 40–85 | *Largo / Adagio / Andante.* Beat = 0.71–1.00 s = **21–30 f**. Reflective, emotional, "the setup". |
| Band 2 — measured | 85–100 BPM | 85–100 | *Andante.* Beat = 0.60–0.71 s = **18–21 f**. Explanatory, considered, slow delivery. |
| Band 3 — default | **100–120 BPM** | 100–120 | *Andante moderato / Moderato.* Beat = 0.50–0.60 s = **15–18 f**. The creator's own default. Talking-head explainer home ground. |
| Band 4 — driving | 120–140 BPM | 120–140 | *Allegro.* Beat = 0.43–0.50 s = **13–15 f**. Montage, build, fast delivery, list sections. |
| Band 5 — peak | 140–170 BPM | 140–176 | *Allegro / Vivace.* Beat = 0.35–0.43 s = **11–13 f**. Short bursts only; over-arousal flattens attention. |
| Frames per beat (30 fps) | `1800 / BPM` | — | 90→20 f · 100→18 f · 110→16.4 f · 120→15 f · 128→14.1 f · 140→12.9 f · 150→12 f · 160→11.3 f. |
| Seconds per beat | `60 / BPM` | — | Author seconds; there is no frame attribute in this stack. |
| Seconds per bar (4/4) | `240 / BPM` | — | 120 BPM → 2.000 s · 100 BPM → 2.400 s · 90 BPM → 2.667 s. The real unit for section-length planning. |
| Delivery → band (derived) | 150–180 wpm → band 3 | — | <120 wpm → band 1–2 · 120–150 → band 2–3 · 150–180 → band 3 · 180–210 → band 4 · >210 → band 4–5. |
| Search window width | ±10 BPM around the band centre | ±5 … ±20 | Narrower than ±5 returns almost nothing; wider than ±20 stops being a filter. |
| Half/double-time allowance | permitted | — | An 80 BPM track with a double-time hat pattern reads as 160. Trust the ear over the tag when they disagree. |
| Band change per boundary | 1 band | 1–2 bands | 3 bands in one boundary is a smash-cut gesture, not an arc. |
| Music gain | −22 dB → `data-volume="0.079"` | −25 … −20 dB | Independent of band. Never raise the fader to buy energy. |

## Reproduction prompt
```
Choose the BPM band for {{SEGMENT}} and convert it into the edit grid, before any
track is auditioned.

1. MEASURE THE DELIVERY. Take a clean 30 s of narration from {{SEGMENT}}, count the
   words, multiply by 2 -> WPM. Do not estimate; count.

2. PICK THE BAND.
     <120 wpm  -> band 1-2 (60-100 BPM)
     120-150   -> band 2-3 (85-120)
     150-180   -> band 3   (100-120)   <- the default; start here if unsure
     180-210   -> band 4   (120-140)
     >210      -> band 4-5 (140-170)
   Then adjust by the segment's arousal target from the mood map: +1 band for a
   build, -1 for a rest. NEVER invert - slow music under fast speech and fast music
   under slow speech both read as broken.

3. CONVERT TO THE GRID. Pick a target BPM at the band centre. Compute and write down:
     seconds per beat = 60 / BPM
     frames per beat  = 1800 / BPM      (30 fps)
     seconds per bar  = 240 / BPM       (4/4)
   Everything beat-locked in this segment - cuts, title entrances, the drop - is
   authored in SECONDS as multiples of 60/BPM. There is no frame attribute in this
   stack; keep the frame count in a comment.

4. FETCH. SearchRecordings with filter.bpm { min: BPM-10, max: BPM+10 }, plus the
   segment's moodSlugs, plus vocals:false wherever narration runs. BPM narrows almost
   nothing on its own - the mood filter is what actually selects. Pull 12 candidates.

5. VERIFY THE TAG AGAINST YOUR EAR. A track tagged 80 with a double-time pattern
   plays as 160. If the tag and the feel disagree, the feel wins; requery.

6. AUDITION AGAINST PICTURE, never in isolation. Lay each candidate under 30 s of the
   real cut at -22 dB rel dialogue and speak along.

ACCEPTANCE TEST.
(a) Speak the narration over the track. If you have to slow down or hurry to fit,
    the band is wrong - change the band, not the delivery.
(b) 60/BPM divides evenly into the beat-locked events you authored, to within 1 frame.
(c) Adjacent segments differ by at least one band, or share a band deliberately.
(d) The bed sits at -22 dB and the dialogue is fully intelligible.
```

## Execution spec

**Placement spec (the three numbers).**

| | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Music bed | starts on the segment boundary; beat 1 aligned to the first cut of the segment | −22 dB (`data-volume` 0.079); −30 dB (0.032) loud guitars | `data-fx-carve` against the `voiceover` group, `strength` 0.25 |
| Beat-locked cut / title | on the beat, 0 to −1 f | n/a | n/a |
| Drop / boundary accent | on beat 1 of a bar | −9 dB (0.355) | bed −6 dB into it |

**HyperFrames — the grid is authored in seconds, derived from BPM.** All authored time is seconds and *"there is no frame-based data attribute"*, so compute the grid once and write the seconds.

```html
<!-- 120 BPM: beat = 0.5 s (15 f), bar = 2.0 s. Segment starts 96.00 s. -->
<audio id="bed-seg03" src=".media/audio/bgm/seg03-120bpm.mp3"
       data-audio-group="music" data-start="96.000" data-duration="104.000"
       data-media-start="0.184"
       data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>

<!-- beat-locked title entrances: 96.000, 98.000, 100.000 = bars 1,2,3 -->
<div id="stat-1" class="clip" data-start="98.000"  data-duration="2.000" data-track-index="2">…</div>
<div id="stat-2" class="clip" data-start="100.000" data-duration="2.000" data-track-index="2">…</div>
```

- **`data-media-start="0.184"`** is the trim that puts the track's beat 1 on `96.000`. Measure the first downbeat's offset inside the file; do not assume the file starts on a beat. This is the single most common reason a "beat-locked" edit drifts.
- **`data-start` accepts a clip-id reference** (`"bed-seg03 + 2"`), which is convenient for bar arithmetic — but **spaces around the operator are required**, an unresolved reference silently resolves to `0`, and if the target has no resolvable duration the reference lands on the target's **start**, not its end. Nothing in lint checks any of it. For a grid this dense, prefer literal seconds.
- **Beat drift over long segments is real.** A 104 s bed at a tagged 120 BPM that is actually 119.94 BPM drifts ~0.05 s by the end. Re-measure the downbeat near the end of any segment over ~60 s rather than extrapolating from the start.
- **`data-playback-rate` cannot be used to change a track's BPM in-composition and keep it usable** — it is normalized `0.1..5` and **pitch-preserved**, so at 1.1× the track survives but every beat-locked number you computed is now wrong, and there is **no rate envelope** for a tempo ramp. Re-fetch at the right BPM instead of retiming.
- **Music gain is `data-volume`; energy is the track.** Do not pair `data-volume` with a GSAP `volume` tween — the tween is absolute and replaces the gain (`audio_volume_tween_overrides_gain`).

**Epidemic Sound — BPM is a first-class filter and a weak one.**

```
SearchRecordings {
  filter: { bpm: { min: 110, max: 130 },
            moodSlugs: { matchType: ANY, values: ["driving","determined","epic"] },
            vocals: false },
  sort: { by: POPULARITY, order: DESCENDING }, first: 12 }
```
Verified live 2026-08-28: `bpm { min: 100, max: 120 }` **plus** `vocals: false` still returns the API's 10 000-result ceiling — so BPM alone does not narrow a search in this catalogue at all. Its job is to **disqualify**, and `moodSlugs` is what selects. Every `Recording` node carries `bpm` as an integer, `stems` (DRUMS / BASS / MELODY / INSTRUMENTS / VOCALS / CLEAN_VOCALS), and `tags` whose `dimension.name` is `mood`, `genre`, `production genre` or `vocal type`. Record the returned `bpm` into the shortlist ([[sfx-track-shortlist-library]]) — it is free, exact, and the thing you will filter on next time. `sort: { by: BPM }` exists if you want to walk a band.

**ffmpeg — measuring BPM and the first downbeat, which the library will not tell you.**
```bash
# transient trace: read the beat spacing straight off the peaks (n=1600 = 1 frame @30fps)
ffmpeg -i track.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
# isolate the kick to make the grid obvious
ffmpeg -i track.wav -af "lowpass=f=120" track.kick.wav
# trim the head so the file starts exactly on beat 1 (only if you need a physical file)
ffmpeg -i track.wav -ss 0.184 -c:a pcm_s16le track.onbeat.wav
```
Prefer `data-media-start` over cutting the file — *"Only cut a physical file when exporting/assembling outside the composition."*

**Remotion.** `framesPerBeat = fps * 60 / bpm`, and sequences placed at integer multiples of it. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-bpm-filter-first]] · [[sfx-three-parameter-music-search]] · [[sfx-mood-vibe-filter]] · [[sfx-instrument-filter-search]] · [[sfx-emotion-and-pace-diagnosis]] · [[sfx-mood-map-per-topic]] · [[sfx-cut-on-the-beat]] · [[sfx-beat-aligned-handover]] · [[sfx-beat-forward-bed-under-voice]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-track-shortlist-library]] · [[sfx-layer-volume-targets]] · [[pace-cut-density-from-viewer-intent]] · [[motion-beat-quantised-animation]]

## Failure modes
- **Inverting the coupling.** Slow music under fast delivery or the reverse. The source names it explicitly and it is the single most damaging music error available, because nothing about either element is individually wrong.
- **Treating BPM as a mood control.** Raising the band to make a section "more exciting" gets you faster, not happier, and if the mood slug is unchanged you now have frantic sad music.
- **Trusting the tag over the ear on half/double time.** An 80 BPM track with 16th-note hats plays as 160 and will fight a slow delivery even though the filter said 80.
- **Filtering on BPM alone.** Verified to return the result ceiling — you will scroll forever. BPM disqualifies; mood selects.
- **Assuming the file starts on beat 1.** Almost none do. Measure the first downbeat and set `data-media-start`, or every beat-locked event in the segment is off by a constant.
- **Extrapolating the grid across a long bed.** Tagged BPM is rounded; over 60+ seconds the error accumulates into visible drift. Re-measure near the end.
- **Retiming a track with `data-playback-rate` to hit a target BPM.** It is pitch-preserved and constant-only, there is **no rate envelope**, and it invalidates every derived timing. Re-fetch instead.
- **Known gap — no beat detection in the stack.** Nothing here analyses a track for beats or downbeats; the peak trace above is a manual read. Budget the measurement, and record the result in the shortlist so it is done once per track, not once per project.
