---
id: sfx-whoosh-transition-movement-reveal
aliases: [sfx-whoosh-on-cut]
title: Whoosh — the default sound for transitions, movement and reveals, and how to fetch the right one
skill: sound-design
type: sfx
family: whoosh
tags: [skill/sound-design, type/sfx, family/whoosh, engine/epidemic, engine/hyperframes, engine/ffmpeg, sfx/motion, layer/sfx, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:01:07
    quote: "This sound effect is perfect for fast transitions, movements and dynamic reveals."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:01:11"
    quote: "Whether it's a title animation or an object moving across the screen, the whoosh is what you'll use."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:01:15
    quote: "You can tweak this by changing the pitch. If you raise the pitch, the sound effect feels a bit lighter. But if you lower the pitch, it becomes a really heavy, weighty whoosh."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:06:58
    quote: "So first of all, if you're putting a sound effect on a cut, place the highest peak of the sound effect on the cut."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:07:08
    quote: "And match the length of the sound effect with the motion. Either by changing the speed, or by layering multiple sound effects."
research_refs:
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://en.wikipedia.org/wiki/Audio_sync
  - https://en.wikipedia.org/wiki/Sub-bass
  - https://pixflow.net/blog/cinematic-whoosh-sound-effects/
  - https://sonilo.com/blog/guides/transition-effect-sound-video-edits
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: low
detectable_from: audio
---

# Whoosh — the default sound for transitions, movement and reveals, and how to fetch the right one

## What it is
The whoosh is a broadband air-movement sweep and the workhorse of the `sfx/motion` style. Three named jobs, from the source: **fast transitions** (shot to shot), **movements** (an object, a title or the camera travelling across frame), and **dynamic reveals** (something arriving). It is the first thing to reach for whenever a fast visual change plays silent — the brain expects a sound when it sees motion, and without one the change reads as hollow.

The swoosh is its near-alias — same air-movement origin, brighter and higher — and the source treats the difference as small; use swoosh when the motion is light and whoosh when it has weight ([[sfx-swoosh-vs-whoosh]]).

**Two hard specifications carry this note, and everything else is variation on them:**
1. the file's **peak** lands on the event frame, not the file's head;
2. the file's **length** matches the motion's length.

Pitch, texture, direction and rotation are all refinements of those two.

## When to use it
- **On a transition whose picture already carries motion**: a whip pan, a push, a zoom-through, a slide, a wipe, a blur-through, a punch-in with some aggression. The whoosh sounds the motion that is there.
- **On a travelling element**: a title flying in, a graphic crossing frame, an overlay exiting, a card sliding up.
- **On a reveal** where something lands: use a **reverse whoosh** (a sweep that builds *to* the arrival) rather than a forward one.
- **On a body or camera move** as an aesthetic accent — the source's own example is a whoosh on the presenter moving, a camera zoom, even an eye roll. Quieter, longer, unnoticeable, and it belongs to the `sfx/aesthetic` style rather than to motion ([[sfx-air-on-micro-movement]]).
- **Not on a static hard cut.** A whoosh on a cut with no visual movement announces the edit instead of supporting it, which is the opposite of the intent. A static cut wants silence or a soft riser.
- **Not on every cut.** Effect overload tires the viewer's brain within two or three minutes, and repeating the identical file is separately named as a mistake.
- **Not where it masks a word.** If the peak lands on a consonant, move it into the nearest speech gap or lower it; the dialogue layer wins.

## How to recognise it in a reference video
- **Find the transients and compare them to the cut list.** Broadband bursts with a rising-then-falling envelope and no harmonic structure are whooshes.
  ```bash
  ffmpeg -i ref.wav -af "highpass=f=1200,astats=metadata=1:reset=0.05,\
  ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null -
  # or, against the cut list:
  ffmpeg -i ref.mp4 -af "highpass=f=1500,astats=metadata=1:reset=2" -f null - 2>&1 | grep Peak_level
  ```
- **Measure the anchor, in frames — and measure the *peak*, not the onset.** For each whoosh compute `peak_frame − event_frame`:
  - **0 frames** → peak on the event. The stated convention and the default.
  - **+1 to +3 f (33–100 ms late)** → inside the documented forgiveness window; the detectability threshold for audio *lagging* picture is around 125 ms.
  - **−2 f or earlier (>66 ms early)** → past the audio-*lead* detectability threshold of about 45 ms, which is roughly three times tighter than the lag threshold. **Leads read as errors sooner than lags do.** If a reference consistently leads, that is a deliberate style — log it rather than correcting it.
  - **The distinction that matters:** the **body** of the sweep occupies the **8–15 frames before** the event, which is what makes the event feel *arrived at*. That is envelope shape, not a lead on the transient. Do not confuse a sweep whose body starts 12 frames early with a peak placed 12 frames early.
- **Measure the length ratio.** `whoosh_duration / motion_duration`. An auditioned whoosh sits at **0.8–1.25**. A 1.5 s whoosh over a 6-frame cut is a stock drop-in.
- **Read the pitch.** Energy centred below ~800 Hz = a heavy whoosh doing gravity; above ~2 kHz = light and fast, or a swoosh. Check it against what the picture is doing — a heavy whoosh on a light text slide is a mismatch and is audible as one.
- **Direction.** A forward whoosh rises then falls (departure); a reverse whoosh rises into a hard stop (arrival). Reveals should use the second. Read the envelope.
- **Repetition check.** Extract every whoosh and compare spectra or file hashes. The identical file more than 3–4 times is the named "same sound effect again and again" failure; a professional set shows pitch, length or texture variation.
- **Density.** Whooshes per minute. Above ~8/min they stop registering and start tiring.
- **Level.** Peak sits around **−12 to −15 dB** relative to dialogue at 0 to −3 dB. A whoosh at dialogue level is a short-form style choice; log it rather than calling it wrong.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `anchor` (the **peak**) | on the event frame (+0 f) | −1 f to +3 f | Frames at 30 fps. **Bias late rather than early:** the lag detectability threshold (~125 ms) is about 3× looser than the lead threshold (~45 ms). Never later than +3 f. |
| `lead_ms` | 15 ms (≈0.5 f) | 10–20 ms | A documented **sub-frame** micro-lead for perceived responsiveness on motion. This is a refinement inside the `anchor` window, not a licence to place whole frames early. |
| `body_before_event` | 10 f (0.33 s) | 6–15 f | How much sweep is audible before the event. This is the anticipation, and it is **envelope, not offset**. |
| `total_length` | 450 ms | 250–900 ms (short) · 1200–2500 ms (long) | Two families. The source names "fast short whoosh" and "long whoosh" as distinct types ([[sfx-whoosh-short-vs-long]]). |
| `length_ratio` | 1.0 | 0.8–1.25 | `whoosh_duration / motion_duration`. Enforce with the Epidemic duration filter, not by stretching. |
| `tail_after_event` | 6 f (0.2 s) | 3–12 f | Ramp to zero; a whoosh outstaying the motion muddies the next shot's opening. |
| `level` | 0.178–0.211 (−15 to −13.5 dB) | 0.126–0.251 (−18 to −12 dB) | Relative to dialogue at 0/−3 dB. |
| `direction` | forward | forward · reverse | Reverse for reveals and arrivals. |
| `pitch` | 1.0 | 0.6–1.4 | Below 1 = heavier/weightier; above = lighter. **Not a HyperFrames attribute** — see Execution spec. |
| `variants_in_rotation` | 4 | 3–8 | Distinct files or distinct treatments, cycled so no identical file repeats inside 3 uses. |
| `per_minute` | 4 | 0–8 | Above 8 the effect stops registering and starts tiring. |
| `layer_split` | 1 file | 1–3 files | If layering, split by band: one sharp/high, one mid sweep, one low rumble. **Never three mids.** |
| `reverb_wet` | 0.15 | 0.10–0.25 | A little reverb stops the effect sounding studio-recorded. Adds a tail past `data-duration`. |

## Reproduction prompt

```
Place a whoosh on the motion event at {{EVENT}} (seconds, composition time).

1. QUALIFY THE EVENT. Confirm visible motion: a pan, push, zoom, slide, wipe,
   or an element crossing frame. If the picture is static, do NOT place a
   whoosh - the moment wants silence, a riser, or nothing.
2. MEASURE THE MOTION in frames: {{MOVE_LEN}}. Convert to milliseconds:
   {{MOVE_MS}} = {{MOVE_LEN}} / 30 * 1000.
3. FETCH BY DURATION, not by browsing. Search Epidemic sound effects for
   "whoosh transition fast" with a duration filter of 0.8*{{MOVE_MS}} to
   1.25*{{MOVE_MS}} milliseconds. Pull at least 3 candidates. For a reveal,
   search "reverse whoosh" instead. For light motion, search "swoosh". For
   weight, "whoosh heavy low sub".
4. FIND THE FILE'S PEAK. Locate its loudest frame measured from the head of the
   file: {{PEAK_SRC}} seconds. DO NOT assume the peak is at the head - most
   whooshes peak 40-70% of the way in.
5. PLACE IT so the PEAK lands on the event:
     data-start = {{EVENT}} - {{PEAK_SRC}}
   If that start falls before the previous shot begins, trim into the file with
   data-media-start rather than moving the peak. The peak may sit up to 3 frames
   LATE; it may sit at most 1 frame EARLY. A 10-20 ms sub-frame lead is fine and
   is not the same thing as a frame of lead.
6. CHECK THE BODY. The sweep should be audible for 8-15 frames BEFORE the event
   - that is what makes the cut feel arrived at. If the file is too short to do
   that, it is the wrong length, not the wrong position.
7. SET GAIN to 0.178-0.211 (about -15 to -13.5 dB relative to dialogue). Ramp
   the final 6 frames of the tail to zero with a volume automation lane,
   remembering the lane holds its first value backwards - so include an explicit
   t:0 point.
8. CHECK THE ROTATION LOG. If this exact file appears in the last 3 whooshes,
   pick another, or shift its pitch by 0.2 and its length by 15% so it reads as
   a different sound.
9. CHECK THE WORDS. If the peak lands inside a spoken word, move it to the
   nearest speech gap within 3 frames, or drop the gain to 0.178.

ACCEPTANCE TEST: play 1 s either side, twice. On the first pass the sound must
feel like it BELONGS to the picture change, not like it happened near it. On the
second, if you can say "early" or "late", re-anchor by 1 frame and repeat. Then
count whooshes in the surrounding minute: over 8, delete the weakest.
```

## Execution spec

**Epidemic Sound — the duration filter is the whole trick.** Length matching is the parameter most often got wrong, and the search API enforces it for you. `filter.duration` is in **milliseconds**:

```
# short whoosh for a 15-frame (500 ms) move -> 400-625 ms
SearchSoundEffects {
  query:  { term: "whoosh transition fast" },
  filter: { duration: { min: 400, max: 625 } },
  sort:   { by: POPULARITY, order: DESCENDING },
  first:  20
}
# long whoosh for a slow 2s push
SearchSoundEffects { query:{term:"long whoosh cinematic"}, filter:{duration:{min:1600,max:2500}} }
# reveal / arrival
SearchSoundEffects { query:{term:"reverse whoosh"},        filter:{duration:{min:600,max:1500}} }
# light motion, text entrance
SearchSoundEffects { query:{term:"swoosh light"},          filter:{duration:{min:200,max:500}} }
# heavy, weighty
SearchSoundEffects { query:{term:"whoosh heavy low sub"},  filter:{duration:{min:700,max:1800}} }
# building the rotation set once one asset is right
SearchSimilarToSoundEffect { id: <chosen uuid>, first: 12 }
DownloadSoundEffect { id: <chosen uuid>, options: { fileType: WAV } }
```
Other useful terms: `"air movement"`, `"whoosh short punchy"`, `"whip whoosh"`, `"transition whoosh dark"`, `"camera whoosh"`, `"whoosh transition cinematic"`. Two returned fields do real work before you download anything: **`audioFile.durationInMilliseconds`** is the number you match against the motion, and **`audioFile.waveformUrl`** lets you see roughly where the peak sits. `filter.tagSlugs` with `matchType: ALL` narrows further once you know the catalogue's slugs for this family (`swooshes--whoosh`, `swooshes--swish`). Always download **WAV** — mp3 pre-echo smears exactly the transient you are trying to land on a frame.

**HyperFrames — placement.** Whoosh on an event at 41.20 s whose chosen file peaks 0.18 s in:
```html
<audio id="sfx-whoosh-12" src="assets/sfx/whoosh-04.wav"
       data-audio-group="sfx"
       data-start="41.02"            <!-- 41.20 - 0.18 : peak lands on the event -->
       data-duration="0.62"
       data-media-start="0"
       data-track-index="22"
       data-volume="0.211"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.42,&quot;v&quot;:1},{&quot;t&quot;:0.62,&quot;v&quot;:0}]}]}"></audio>
```
Contract points that bite:
- **All authored time is in seconds. There is no frame-based attribute.** Convert frames at authoring time and leave the frame count as a comment.
- **Every `<audio>` needs an `id`.** No id → never mixed → silent render, no error.
- **The automation lane's `t` is clip-local and it holds its first value backwards to the clip start**, so the `t:0` point is mandatory.
- **Never GSAP-tween `volume` alongside a lane** (`audio_volume_double_automation` — the lane wins silently), and never tween `volume` on a clip whose `data-volume` you meant to keep (`audio_volume_tween_overrides_gain` — the tween is absolute, not a scale).
- **SFX go in their own group** (`sfx`), never in `voiceover`: a non-voice clip inside the carve group silently poisons the next carve re-analysis.
- **Two overlapping `<audio>` must not share a `data-track-index`** (`duplicate_audio_track`).
- **There is no audio-follows-animation attribute.** Picture and sound are coupled by the author writing the same number twice. If the animation lives in a sub-composition at scene-local `t`, the root-level audio needs `data-start = t + host data-start`. Relative timing (`data-start="el-intro + 0.2"`) can express that, but **spaces around the operator are required** and every parse failure resolves silently to 0.
- **Sub-comp timelines cannot animate host-root elements**, so the whoosh cannot be placed "by" the animation that triggers it; the author places both.

**Pitch and treatment.** There is no pitch attribute. `data-playback-rate` (0.1–5) changes rate with **pitch preserved**, which is the opposite of what a heavier whoosh needs. Two real routes:
1. **Bake the shift with ffmpeg** — the honest answer for "make it heavier":
   ```bash
   # about -4 semitones, length preserved
   ffmpeg -i whoosh.wav -af "asetrate=48000*0.7937,aresample=48000,atempo=1.26" whoosh.low.wav
   # -20% pitch
   ffmpeg -i whoosh.wav -af "asetrate=44100*0.8,aresample=44100,atempo=1.25" whoosh.low.wav
   # or, formant-aware if the rubberband filter is built in
   ffmpeg -i whoosh.wav -af "rubberband=pitch=0.7937" whoosh.low.wav
   ```
   `atempo` is valid only in 0.5–2.0, so chain two instances for larger shifts. Register derived files: `node <SKILL_DIR>/scripts/resolve.mjs --from whoosh.low.wav --type sfx --project .`
2. **Shape it in the chain** for weight or brightness without moving pitch:
   ```html
   data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
     {&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Weight&quot;,&quot;params&quot;:{&quot;frequency&quot;:2200}},
     {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;size&quot;:0.45,&quot;wet&quot;:0.15,&quot;dry&quot;:0.9}},
     {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"
   ```
   Order is signal order; limiter last. A `highpass` (sharper, lighter) is the mirror move. `reverb` adds `chainTailSeconds`, so the rendered track runs past `data-duration` — expected, not a bug, but it means the tail ramp will not be the last thing you hear.

**Remotion:** an `<Audio>` inside a `<Sequence>` offset so the file's peak lands on the event frame. Concept only; no Remotion runtime here.

## Pairs with
[[sfx-whoosh-short-vs-long]] · [[sfx-swoosh-vs-whoosh]] · [[sfx-unsounded-motion-audit]] · [[sfx-arbitrary-sound-motion-sync]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-bass-drop-under-impact]] · [[motion-whoosh-bound-entrance-and-traverse]] · [[motion-whip-pan-transition]] · [[motion-velocity-matched-transition]] · [[sfx-camera-move-air-accent]] · [[cut-movement-match]] · [[pace-cut-on-the-beat]] · [[sfx-motion-sound-selection]] · [[sfx-name-before-search]] · [[struct-stimulation-budget]] · [[sfx-peak-on-the-cut]] · [[sfx-peak-on-impact-frame]] · [[sfx-air-on-micro-movement]] · [[sfx-density-fatigue-audit]] · [[cut-graphic-match]] · [[cut-punch-in-emphasis]] · [[cut-fade-to-white]] · [[struct-music-arc-to-narrative-arc]] · [[sfx-riser-anticipation-build]] · [[sfx-whip-crack-on-snap-cut]]

## Failure modes
- **Assuming the file's peak is at its head.** Places the effect late by the length of its attack — often 5–10 frames. Fix: measure `{{PEAK_SRC}}` and subtract it.
- **Confusing the sweep's body with a lead on the peak.** A whoosh whose body starts 12 frames before the cut is correct; a whoosh whose *peak* is 12 frames early is broken. Fix: measure the peak, and let the envelope do the anticipation.
- **Audio lagging past +3 f.** Past ~3 frames on a fast transition it reads as a sync fault. Fix: bias to 0 or a sub-frame lead; never past +3 f.
- **Length mismatch.** A whoosh longer than the motion keeps sweeping after the picture has settled; shorter and the motion outlives its sound. Fix: fetch by duration filter, do not stretch.
- **A whoosh on a static cut.** Announces the edit, which is the opposite of the intent. Fix: whooshes ride visible motion; a static cut wants silence or a riser.
- **Forward whoosh on a reveal.** A departing sweep on an arriving object reads as backwards. Fix: reverse whoosh.
- **One file, twenty times.** The named repetition mistake — the viewer stops hearing it and starts noticing it. Fix: a rotation of four, or pitch/length variation on one file.
- **Too many.** A tick every other second tires the brain in two or three minutes. Fix: cap around 8/min, target 4.
- **Three mid-range whooshes stacked** to make it bigger. Mud, not weight. Fix: layer by band — sharp/high, mid sweep, low rumble.
- **Masking a word.** The dialogue layer always wins. Fix: shift into a speech gap or drop 2–3 dB.
- **Whoosh in the `voiceover` group.** Silently poisons the next carve re-analysis. Fix: `data-audio-group="sfx"`.
- **Known gap:** no research measures the ideal whoosh anchor directly. The ±window here is derived from broadcast A/V sync thresholds (ITU-R BT.1359-1: detectability from 45 ms lead to 125 ms lag; ATSC IS-191 acceptability +15/−45 ms; film ±22 ms), which are lip-sync figures applied by analogy, plus the practitioner 10–20 ms micro-lead. Treat `anchor = 0 f` as the default and a human ear as the authority.
