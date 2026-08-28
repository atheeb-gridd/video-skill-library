---
id: sfx-riser-anticipation-build
aliases: [sfx-riser-anticipation]
title: The riser — a sound anchored by its end, so land the peak on the reveal frame
skill: sound-design
type: sfx
family: riser
tags: [skill/sound-design, type/sfx, family/riser, sfx/aesthetic, layer/sfx, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/editing-kt, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:02:01
    quote: "Third is riser — you get it from the name, right? The sound effect that's rising."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:02:06"
    quote: "A riser sound is essential for building anticipation and tension. Before a jumpscare, before a big reveal, or before a drop in music, the riser teases that something big is about to happen."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:11:17"
    quote: "Risers - build tension and anticipation; signal that something important is about to happen; only use when something important actually is, or they lose credibility."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:11:23
    quote: "First, risers. They build tension and anticipation, because they tell the audience that something really important is about to happen."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:24
    quote: "then stop the first track, put in a riser sound, and start the second track at the end of the riser."
research_refs:
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://unison.audio/how-to-create-risers/
  - https://add.app/sound-effects/sound-design-for-trailers-hits-rises-drones-pulses/
  - https://www.epidemicsound.com/sound-effects/categories/designed/riser/
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://librosa.org/doc/latest/generated/librosa.beat.beat_track.html
  - https://universalcategorysystem.com/
difficulty: medium
detectable_from: audio
---

# The riser — a sound anchored by its end, so land the peak on the reveal frame

## What it is
A riser is a designed sound whose level, pitch and spectral centroid climb monotonically toward a single end point. Its entire function is to make the viewer *expect*: it is the only element in the sound-design vocabulary that points forward rather than marking the present.

**Every other effect in the library is anchored by its front** — you place the transient on the event. A riser is the exception: its meaning lives at its **last frame**, so it is placed by working *backwards* from the moment it is promising. The creator's own three destinations are a jumpscare, a big reveal, and a drop in the music; a fourth, from the music video, is the seam between two tracks that will not blend.

Mechanically it is a **duration** sound, not an event sound. It occupies time, it competes with the voice for the presence band while it runs, and it is the only aesthetic effect that is *allowed* to get louder as it goes — which is exactly why it needs an explicit envelope rather than a static gain.

And because the device is a **promise**, it is spent by misuse: put one in front of something unimportant and the audience stops believing the next one. *"Only use when something important actually is, or they lose credibility."*

## When to use it
Three legitimate placements, plus one structural one:

- **Before a reveal** — a number, a result, a before/after flip, a title card — where a payoff exists within the next few seconds and it is a genuine turn.
- **Before a drop** — the music's own energy change, or the start of a high-energy section.
- **Before a scare or a hard tonal turn.**
- **Across a section boundary two tracks will not blend across.** Stop track A, run the riser over the gap, start track B on the riser's end frame ([[sfx-track-change-at-section-boundary]]).

Also legitimate as the front half of a riser+hit pair on a genuine act break ([[sfx-riser-hit-pair]]). Whether the payoff is worth a riser at all is decided by [[sfx-riser-credibility-budget]]; this note assumes that decision is already yes.

- **The picture should already be building** — a push-in, a stack of elements assembling, a counter rolling up. A riser under a static shot with no visual build reads as a false alarm.
- **Not on an ordinary transition.** A cut from one shot to another is a whoosh's job ([[sfx-whoosh-transition-movement-reveal]], [[sfx-whoosh-transition-movement-reveal]]). Risers used as transitions are the single commonest way the device is burned out.
- **Not on a match cut**, whose whole point is to *not* announce the cut ([[cut-movement-match]]).
- **Not on a mid-list item.** If you cannot name what the riser is pointing at in five words, delete it.
- **Not without a resolution.** A riser that ends into nothing — no hit, no cut, no drop — is heard as an unfinished sentence. If the payoff has no natural transient of its own, put a hit on it ([[sfx-cinematic-hit-emphasis]]).
- **Not stacked with another duration sound.** A riser plus a tension texture plus a bed with its own build is three things saying "wait for it", and reads as mud.

## How to recognise it in a reference video
- **Rising RMS with a rising centroid over ≥0.8 s.** The measurable signature is a monotonic climb, not a swell-and-fall. Trace it per frame:
  ```bash
  # per-frame RMS; n=1600 @48 kHz is exactly one frame @30fps
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
   ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  A riser shows as ≥25 consecutive frames whose RMS increases by **≥6 dB total** with no interior drop greater than 2 dB.
- **Rising spectral centroid.** On a spectrogram the energy sweeps upward — typically from a **60–150 Hz** floor to a **3–10 kHz** ceiling — over a continuous ramp. That upward sweep is the definition; without it you are looking at a swell or a drone.
- **The maximum sits at or within 2 frames of the element's last audible frame** — this is what separates a riser from a whoosh, whose maximum sits in the middle.
- **Peak-to-event offset — the diagnostic that matters.** Measure the frame of maximum level and the frame of the visual event. In competent work these are within **±1 frame**; ±2–3 frames is audible as sloppy; more than 4 frames off reads as a mistake even to untrained viewers. **Which direction is worse depends on the payoff — see the alignment rows in Parameters.**
- **A level notch just before the peak.** Look for a deliberate **3–6 dB** dip in the final **2–4 frames**. It is a trailer-mix convention: the momentary drop makes the payoff read louder without raising it.
- **A hard event lands within 4 frames after the maximum**: a cut, a full-screen flash, a scale step, a hit, or a music downbeat. If nothing lands, log it as an unresolved riser — a defect, not a style.
- **Duration bands** observed in reference edits and confirmed against the library: short-form beats **1.0–2.0 s**, standard explainer **2–3 s**, section change **4–5 s**, long-form/documentary and act builds **6–8 s**. Anything under ~20 f is a swish; anything above ~12 s is a tension bed, not a riser, and is placed differently.
- **Density.** Count risers per minute. Professional long-form runs **0–0.5/min**; two risers inside 20 s means the device has been devalued.
- **Level in the mix.** Peaks in the **−12 to −15 dB** band with dialogue at 0 to −3 dB; a riser that peaks above the dialogue is over.
- **Music behaviour underneath.** In a well-built reference the bed drops **4–8 dB** across the riser and returns at the payoff, or stops entirely. A bed that stays flat under a riser is the amateur tell — two things building at once cancel.
- **On the transcript:** the riser almost always runs under a setup line ("and this is the part nobody tells you…") and its maximum lands in the silence *after* that line, not under a word. The line immediately after the peak should be the payoff — a number, a name, a turn. If the sentence just continues, the riser was pointing at nothing.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `riser_body` (audible length) | 2.0–3.0 s | 1.0–8.0 s | Match to the build on screen: **1.0–2.0 s** short-form/micro-reveal · **2–3 s** standard explainer · **4–5 s** section change · **6–8 s** act break, trailer build, or long-form doc — and only with a visual build of the same length. |
| `bar_locked_length` | 2 bars | 1–4 bars | At the creator's default 100–120 BPM a bar is 2.4–2.0 s, so 1 bar = 2.4–2.0 s and 2 bars = 4.8–4.0 s. Use when a bed is running ([[sfx-cut-on-the-beat]]). |
| `peak_time` in file | **measured** | — | Never assume the file's end. Library risers frequently carry 0.3–1.5 s of tail or an included hit after the peak. |
| `peak_alignment` | 0 frames — peak **on** the payoff frame | ±1 f | The target, always. ±2–3 f is audible as sloppy. |
| `err_direction` — payoff **has its own transient** (a hit, a music drop, a sounded cut) | err **early**, 0 to −2 f | −2 to 0 f | A late riser peak collides with the payoff's own transient and muddies both; the riser must be *resolving into* the payoff, not landing on top of it. This is why "peak late" is the commonest error on a hit-answered riser. |
| `err_direction` — payoff is **purely visual** (a title resolving, a number appearing) | err **late**, 0 to +2 f | 0 to +2 f | With no competing transient the perceptual asymmetry dominates: audio *leading* picture is detectable from **45 ms**, lagging only from **125 ms** (ITU-R BT.1359-1), so an early peak reads as a mistimed edit at roughly half the offset a late one does. |
| `start_gain` (rel. the riser's own peak) | 0.05–0.25 | 0.05–0.40 | The lane's first point. A riser that starts at full level does not build. |
| `start_level` (rel. dialogue) | −30 dB | −34 to −26 dB | The same knob expressed against the mix rather than against the riser. **Do not mix the two reference frames** — pick one and state it. |
| `peak_level` | −13 dB rel. dialogue | −12 to −15 dB | Ceiling stays inside the SFX band ([[sfx-layer-volume-targets]]). |
| `pre_peak_notch` | −4 dB | −3 to −6 dB | Applied over the last 2–4 frames. Makes the payoff read louder without raising it. |
| `notch_window` | 3 f (100 ms) | 2–4 f | |
| `pre_hit_gap` | 0 f | 0–4 f | Optional near-silence immediately before the payoff — mute every other layer for 2–4 f. |
| `tail_after_peak` | 0.15–0.25 s | 0–0.5 s | Let the decay run a few frames past the payoff so the cut is not audibly chopped — but a long tail smears it. |
| `sweep_low` | 100 Hz | 60–150 Hz | Where the ramp's energy starts. |
| `sweep_high` | 8 kHz | 3–10 kHz | Where it ends. |
| `low_end_trim` | `highpass` 60 Hz | 40–90 Hz | Keeps the riser out of the way of the hit's sub, so both survive. |
| `bed_duck_depth` | 0.5 (−6 dB) | 0.4–0.7 (−4 to −8 dB) | Applied across the riser, restored at the payoff frame. Or stop the bed entirely. |
| `presence_carve` (if under speech) | 3 kHz, −4 dB, Q 1.4 | −3 to −6 dB | A `peaking` node **on the riser**, not on the voice. Only when speech overlaps the last third. |
| `risers_per_minute` | 0.3 | 0–0.5 | Hard rule: never two inside 20 s; one per two minutes maximum. |
| `answer` | `hit` | `hit` \| `music drop` \| `hard cut` | A riser **must** be answered. |
| `pitch_variation` | 0 st | −3 to +3 st | Reuse the same file at a different pitch rather than repeating it identically. |

## Reproduction prompt
```
Place a riser so that it resolves exactly on the payoff.

INPUT: payoff time {{PAYOFF}} in composition seconds (the frame of the reveal,
cut, or music drop). Frame rate 30 unless told otherwise, so 1 frame = 0.0333 s.

1. NAME THE PAYOFF IN FIVE WORDS. If you cannot, delete the riser and stop. Then
   classify it: does the payoff carry ITS OWN TRANSIENT (a hit, a music drop, a
   sounded cut), or is it PURELY VISUAL (a title resolving, a number appearing)?
   That decides step 6.
2. PICK {{BODY}} from the payoff's weight and the format: 1.0-2.0 s short-form
   micro-reveal, 2.0-3.0 s standard, 4.0-5.0 s section change, 6.0-8.0 s act
   break. If a bed is running, round to 1 or 2 bars instead.
3. FETCH a riser: Epidemic SearchSoundEffects, filter tagSlugs ALL
   ["designed--riser"], duration min 1500 max 12000, sort POPULARITY DESCENDING.
   Add query term "clean" for a neutral build, "suspense" for dread, "whoosh"
   for one that resolves into air, "sub" for a low chest-level build. Download
   WAV.
4. MEASURE the file's peak offset PEAK_OFF (seconds from file start to its
   loudest frame) with a per-frame RMS/peak trace:
     ffmpeg -i riser.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
      ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
   Do not eyeball it, and do not assume the peak is the file's end - many risers
   carry a tail or a built-in hit.
5. COMPUTE:
     data-media-start = max(0, PEAK_OFF - {{BODY}})   (if negative, use a longer file)
     data-start       = {{PAYOFF}} - {{BODY}}
     data-duration    = {{BODY}} + 0.20               (tail past the payoff)
   This puts the file's own peak exactly on {{PAYOFF}}.
6. APPLY THE ERR DIRECTION from step 1 if you cannot hit the frame exactly:
     payoff has its own transient -> err EARLY, 0 to -2 frames
     payoff is purely visual      -> err LATE,  0 to +2 frames
   Never more than 2 frames either way.
7. PLACE as <audio id="sfx-riser-{{N}}" data-audio-group="sfx"> on its own track
   index, data-volume set so the peak lands at -13 dB rel. dialogue.
8. AUTHOR THE BUILD as a volume automation lane in CLIP-LOCAL seconds, with an
   EXPLICIT point at t=0 (a lane holds its first value backwards to the clip
   start, so without it the riser opens at full level):
     t=0                v=0.05-0.25   (the ramp's floor)
     t={{BODY}}*0.6     v=0.6-0.85
     t={{BODY}}-0.10    v=1.0
     t={{BODY}}-0.03    v=0.63        (the -4 dB pre-peak notch, 2-4 frames)
     t={{BODY}}         v=1.0         (the peak, on the payoff frame)
     t={{BODY}}+0.20    v=0
   Do NOT also GSAP-tween volume on this element.
9. DUCK THE BED across the build: on the music clip's volume lane add an
   explicit "no cut" point at v=1.0 before the dip, then v=0.5 at the riser's
   start + 0.2, hold, and v=1.0 at the payoff + 0.1. If the section is changing,
   stop the bed instead and start the next track at {{PAYOFF}}.
10. IF SPEECH runs under the last third of the build, add a peaking node to the
    riser's data-fx-chain at 3000 Hz, gain -4, q 1.4, labelled "Presence Room".
11. ANSWER IT. On frame {{PAYOFF}} place the hit, the music drop, or the hard
    cut it pointed at. Never leave a riser unanswered.
12. BUDGET: one riser per two minutes maximum, never two within 20 s. For a
    lesser accent use a swish or a soft hit instead.

ACCEPTANCE TEST: render the 6 s around {{PAYOFF}} and check four things.
(a) The riser's loudest frame and the payoff's first frame are the same frame,
    +/-1, and any error is in the direction step 6 prescribes.
(b) Something visible happens at {{PAYOFF}}; if not, DELETE the riser - do not
    move it to somewhere it "fits better".
(c) With the riser soloed and dialogue muted, the level climbs monotonically -
    no interior dip greater than 2 dB except the authored pre-peak notch.
(d) Mute the riser: the payoff must still work. If the riser is the only thing
    making the moment feel important, remove it.
```

## Execution spec

**Epidemic Sound.** The reliable fetch is by tag, not by free text.
```json
// SearchSoundEffects
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["designed--riser"] },
              "duration": { "min": 1500, "max": 12000 } },
  "query": { "term": "clean transition" },
  "sort": { "by": "POPULARITY", "order": "DESCENDING" }, "first": 12 }
```
Verified against the live catalogue: `designed--riser` holds **478** effects spanning **0.97 s to 113 s**; the popularity-ranked short/fast risers cluster at **2.9–5.8 s**. Useful term refinements that appear in real titles: `clean`, `suspense`, `distorted`, `reverse`, `eerie`, `sub`, `scifi`, `cymbal`, `whoosh`, `riser build tension`. Two verified behaviours to rely on: an unrecognised tag slug returns `meta.total: 0` (it fails closed, so a zero result means your slug is wrong, not that the library is empty), and **`duration` filters the delivered file length, not the audible event** — leave the window wide and trim with `data-media-start` instead. For a longer build raise the filter to `{min: 6000, max: 10000}`. Then `DownloadSoundEffect` with `{"fileType":"WAV"}` into `assets/sfx/`. `SearchSimilarToSoundEffect` is the right call for a second riser later in the video — a *similar but not identical* file avoids the "same sound effect repeated again and again" mistake.

**HyperFrames.** Placement is three seconds values and one lane. All authored time is in seconds; there is no frame attribute.
```html
<!-- payoff at 84.0s; PEAK_OFF measured at 2.40s; BODY 2.0s -->
<audio id="sfx-riser-reveal" src="assets/sfx/riser-clean.wav"
       data-audio-group="sfx"
       data-start="82.0" data-duration="2.20" data-media-start="0.40"
       data-track-index="12" data-volume="0.22"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.05},{&quot;t&quot;:1.20,&quot;v&quot;:0.6},{&quot;t&quot;:1.90,&quot;v&quot;:1.0},{&quot;t&quot;:1.97,&quot;v&quot;:0.63},{&quot;t&quot;:2.00,&quot;v&quot;:1.0},{&quot;t&quot;:2.20,&quot;v&quot;:0}]}]}"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Clear the Sub&quot;,&quot;params&quot;:{&quot;frequency&quot;:60}}]}"></audio>

<!-- the answer, on the peak frame -->
<audio id="sfx-hit-reveal" src="assets/sfx/hit.wav" data-audio-group="sfx"
       data-start="84.0" data-duration="1.4" data-track-index="13" data-volume="0.4"></audio>
```
The `{t:1.97, v:0.63}` / `{t:2.00, v:1.0}` pair is the pre-peak notch: −4 dB across three frames, then back to full on the payoff frame.

Contract points that bind this:
- **Lane `t` is clip-local seconds**, and a lane **holds its first value backwards to the clip start** — hence the explicit `{"t":0,…}` point, or the riser opens already at full level. Same for the bed's duck lane: author an explicit `v: 1` point before the dip or the bed starts out already ducked.
- **Do not also GSAP-tween `volume`** on this clip: the lane wins and the tween is silently ignored (`audio_volume_double_automation`). Equally, a `volume` tween is **absolute** and replaces `data-volume` (`audio_volume_tween_overrides_gain`).
- **Every `<audio>` must have an `id`** — an id-less audio element is never mixed and renders silent.
- **Put SFX in their own group** (`data-audio-group="sfx"`), never in the `voiceover` carve group: a non-voice clip inside the carve group poisons the next re-analysis silently.
- **Write the JSON attributes double-quoted with `&quot;`**, or `carve.mjs` cannot see them.
- **There is no audio-follows-animation attribute.** The riser's `data-start` and the payoff tween's timeline position are the **same number written twice**. If the payoff lives inside a sub-composition at scene-local `t`, the root-level riser needs `data-start = t + slot data-start`.
- **Max 512 points per lane**; out-of-range values are clamped on read.
- **Avoid `reverb` or `delay` on a riser.** They make the rendered track **longer** than its `data-duration` (`chainTailSeconds`) — expected behaviour, but it smears the payoff. Prefer a dry riser.

**Optional tone shaping** instead of picking a different file — sweep a `highpass` upward, since `frequency` is automatable:
```
data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Riser Sweep&quot;,&quot;params&quot;:{&quot;frequency&quot;:100,&quot;q&quot;:0.9}}]}"
```
with a second lane `{"target":"fx.n1.frequency","points":[{"t":0,"v":100},{"t":2.0,"v":8000}]}`. Note a lane whose `nodeId` is typo'd is **pruned on read** — no error, just a missing envelope.

**ffmpeg.** Peak measurement, length fitting, and pre-baking:
```bash
# 1. where is the peak?
ffmpeg -i riser.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null

# 2. stretch/compress the build to exactly 3.0 s without changing pitch
ffmpeg -i riser.wav -af "rubberband=tempo=1.28" riser_3s.wav

# 3. pre-baked, if the riser must leave the pipeline
ffmpeg -i riser.wav -ss 0.40 -t 2.20 -af "volume=-13dB,afade=t=out:st=2.0:d=0.20" riser.cut.wav
```
`data-playback-rate` (0.1–5) would also retime it in-composition, but it is pitch-preserved and constant, so use it only for whole-file retimes; there is no rate envelope. The FX registry has **no pitch node**, so any pitch variation must be baked before placement.

**Remotion.** An `<Audio>` with `startFrom` set to `peakOffsetFrames - bodyFrames`, inside a `<Sequence>` starting `bodyFrames` before the payoff frame. Remotion is not part of this stack — portability notes only.

## Pairs with
[[sfx-riser-credibility-budget]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-riser-hit-pair]] · [[sfx-bass-drop-under-impact]] · [[sfx-track-change-at-section-boundary]] · [[sfx-music-drop-on-structure-turn]] · [[sfx-peak-offset-measurement]] · [[sfx-layer-volume-targets]] · [[sfx-intensify-without-referent]] · [[sfx-whoosh-transition-movement-reveal]] · [[motion-anticipation-build-to-reveal]] · [[sfx-synthetic-family-catalogue]] · [[struct-music-arc-to-narrative-arc]] · [[struct-outcome-first-cold-open]] · [[struct-enumerated-promise-and-counter]] · [[cut-fade-bookend]] · [[sfx-music-audition-against-picture]] · [[struct-stimulation-budget]] · [[pace-overlay-instead-of-cut]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-cut-on-the-beat]]

## Failure modes
- **Peak on the file's end instead of its measured maximum.** Library risers often include 0.3–1.5 s of tail or a built-in hit after the peak, so aligning the file end to the payoff puts the build's climax a beat early. Measure `PEAK_OFF` every time; solve for `data-start` from it, never place by ear.
- **Peak in the wrong direction for the payoff.** Late onto a hit muddies both; early onto a purely visual reveal reads as a mistimed edit. Check which case you are in before you nudge.
- **Unanswered riser.** Anticipation with no payoff is heard as an unfinished sentence and teaches the viewer to discount the device. Fix: a hit, a drop, or a hard cut on the peak frame — or remove the riser. Never slide it to somewhere it "fits better".
- **Riser on an unimportant beat.** Costs the credibility of every later riser in the video. Fix: name the payoff in five words or delete.
- **Riser used as a transition.** The commonest way the device is burned out. Fix: a whoosh carries a cut; a riser promises a payoff.
- **Riser masking the line it is supposed to set up.** Risers climb through 2–8 kHz, straight into the presence band. Fix: schedule the last third into a speech gap, or carve 3 kHz on the riser.
- **Flat bed underneath.** Two things building at once cancel — the riser's climb is only perceptible relative to something that is not climbing. Fix: duck the bed 4–8 dB, or stop it.
- **Two risers close together.** Reads as a nervous tic. Fix: one per two minutes; use a swish for lesser accents.
- **Too loud.** A riser peaking above the dialogue makes the payoff quieter by comparison. Fix: −13 dB peak, and use the pre-peak notch rather than more level.
- **Long tail past the peak.** Smears the payoff and muddies the first second of the new section. Fix: 0.15–0.25 s of tail, hard out; avoid reverb on risers.
- **Identical riser reused all video.** One of the three named sound-design mistakes; three uses of one file makes the device audible as a template. Fix: `SearchSimilarToSoundEffect`, or reuse at ±2 semitones and a different length ([[sfx-pitch-shift-weight-energy]]).
- **Known gap:** nothing in this stack validates the effect chain or the lanes, and nothing detects the peak for you — the `astats` measurement is a manual step and must be recorded in the design document so a later pass can re-derive the alignment. The FX registry also has no pitch node, so pitch variation must be baked with ffmpeg before placement.
