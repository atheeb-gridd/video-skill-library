---
id: motion-abstract-object-sound-contract
title: An abstract graphic has no natural sound — so its motion must specify one
skill: motion
type: motion
family: motion-sfx-binding
tags: [skill/motion, type/motion, family/motion-sfx-binding, sfx/diegetic, sfx/motion, layer/sfx, engine/hyperframes, engine/epidemic, engine/ffmpeg, engine/remotion, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:20"
    quote: "But for things that don't even exist in real life, you can creatively use any sound effect you want. The speed and timing just have to match."
research_refs:
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://en.wikipedia.org/wiki/Michel_Chion
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Shutter_angle
  - https://www.nngroup.com/articles/animation-duration/
difficulty: medium
detectable_from: video
---

# An abstract graphic has no natural sound — so its motion must specify one

## What it is
The dividing line for sound choice, restated as an obligation on the **motion designer**. If the thing on screen exists in the world — a phone, a door, a hand on a table, a car — its sound is *determined*, and any other sound is a continuity error the viewer feels immediately. If the thing does **not** exist — a card, a bar, an arrow, a UI panel, a logo lockup, a chapter number, a mask edge — then no sound is right or wrong, and the only constraint the source states is that **speed and timing must match**.

That freedom moves the work upstream. Because nothing about a rectangle implies a sound, everything the viewer will believe about it has to come from the **motion's own envelope**: how long it takes, how it accelerates, how long it takes to stop, which direction it goes, and how far it travels. The pairing of an arbitrary sound with a synchronous image is the standard mechanism of film sound — Chion's *Audio-Vision* names it *synchresis* — and it works reliably only when the two envelopes agree. [[motion-sfx-pass-manifest]] owns *where* the sound goes; this note owns *which* sound is legal given the motion, and — the part that changes how you animate — *how to design the motion so that a legal sound exists.*

### The four envelope matches
These are the contract. A sound that satisfies all four will be believed regardless of what it actually is; a sound that fails any one will read as a library file dropped on top.

1. **Duration.** The sound's audible span (first to last sample above −40 dBFS) must be **1.0–3.0×** the motion's duration. A 0.2 s move with a 1.8 s sound leaves 1.6 s of audio with nothing on screen producing it.
2. **Attack shape matched to the ease.** A front-loaded ease (`power4.out`, `expo.out`) needs an attack under **20 ms**; a symmetric glide (`sine.inOut`, `power2.inOut`) needs a **60–150 ms** swell; an accelerating exit (`power3.in`) needs a sound that *builds*. Attack and ease disagreeing is the most common mismatch and it reads as lateness even when the transient is on the right frame.
3. **Pitch contour matched to direction.** Rising pitch for motion that goes **up, toward camera, or larger**; falling for **down, away, or smaller**. A card that scales up under a downward-sweeping sound feels wrong to viewers who cannot say why.
4. **Mass implied by deceleration, not by size.** A long settle (≥0.4 s of visible deceleration) reads as heavy → low, weighty sound, pitched **−3 to −7 semitones**. A dead stop inside 4 frames reads as light and rigid → high, short, clicky, **+2 to +5 semitones**. This is the one that lets a 40 px chip and a full-screen panel legitimately share a sound file.

The corollary the source states directly: because abstract objects are free, **generate variations from one file** using the three parameters it names — reverb, pitch, duration — instead of pulling twenty files. One good whoosh plus a pitch ladder covers an entire project's graphic vocabulary.

## When to use it
- **Every time a non-existent object moves** — which in a graphics-heavy edit is most sound events.
- **As a gate before searching for a sound at all**: classify the element as REAL or ABSTRACT first, because the two searches are completely different (a literal noun for the real one; an envelope description for the abstract one).
- **When a real object is on screen, invert the workflow**: cut the motion to the sound rather than the sound to the motion. A door's slam is a fixed event; the picture must land on it.
- **When a sound feels wrong but the sync is verifiably correct** — then the problem is one of the four matches, not the placement, and this is the checklist that finds which.

## How to recognise it in a reference video
- **Classify every sounded element** as REAL (exists in the world) or ABSTRACT (graphic). Log the ratio; a channel's ratio is a style fact.
- **For each REAL element, check literalness.** A water sound on a non-water object, a mechanical click on a soft object — the source's own example of the failure. Any substitution here should be *invisible*, not creative.
- **For each ABSTRACT element, measure the four matches:**
  - *Duration ratio*: sound audible length ÷ move length. Log it. Outside 1.0–3.0 is a finding.
  - *Attack*: RMS in 10 ms windows from onset; time to reach 90 % of peak. Compare against the visual ease read off the per-frame displacement curve.
  - *Pitch contour*: a spectrogram of the effect — spectral centroid rising or falling — compared with the motion's direction.
  - *Deceleration*: frames from peak velocity to rest, against the sound's decay length and pitch register.
- **Look for a pitch ladder.** If several graphic events in one video share an obviously identical file at different pitches, the reference is doing exactly what the source recommends; that is a positive finding, not a repetition fault.
- **Check reverb consistency.** Abstract elements in the same "space" should share a reverb amount; a dry pop next to a hall-sized whoosh reads as two different videos.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `duration_ratio` | 2.0× | 1.0–3.0× | Sound audible length ÷ motion duration. |
| `attack_out_ease` | ≤20 ms | 5–30 ms | For `*.out` eases. |
| `attack_inout_ease` | 100 ms | 60–150 ms | For `sine.inOut` / `power2.inOut` glides. |
| `pitch_up_motion` | +2 st | +1 to +5 | Motion up / toward camera / growing. |
| `pitch_down_motion` | −3 st | −1 to −7 | Motion down / away / shrinking. |
| `mass_light` | +3 st, ≤300 ms | — | Stop within 4 frames. |
| `mass_heavy` | −5 st, 600–1200 ms | — | Visible deceleration ≥0.4 s. |
| `reverb_wet` | 0.12 | 0.05–0.25 | One value for all abstract elements in a scene. The FX registry's `reverb` node: `size` 0.05–1 (0.7), `wet` 0–1 (0.35), `dry` 0–1 (0.7). |
| `variants_from_one_file` | 4 | 3–8 | Pitch ladder ±2/±4 st plus one reverb-wet and one time-stretched variant. |
| `real_object_tolerance` | 0 | — | No creative substitution for diegetic objects: literal sound, literal timing. |
| `sync_window` | −45 to 0 ms | −45 to +45 ms | ITU-R BT.1359-1 detectability is 45 ms lead / 125 ms lag; ATSC IS-191 acceptability is 15 ms lead / 45 ms lag. Aim early. |

## Reproduction prompt

```
For every sound event in this composition, apply the real/abstract gate and
then the four envelope matches.

STEP 1 - CLASSIFY. For each element that moves or is highlighted, mark it
REAL (it exists in the physical world and the viewer knows what it sounds
like) or ABSTRACT (a graphic, a card, a bar, an arrow, a panel, a number).

STEP 2 - REAL ELEMENTS. Use the literal sound, at the literal moment, with no
creative substitution. If the picture and the sound disagree, MOVE THE
PICTURE: adjust the clip's data-media-start or the cut so the visual contact
frame lands on the sound's transient. Do not stretch or pitch a diegetic
sound to fit.

STEP 3 - ABSTRACT ELEMENTS. Read the motion's parameters off the tween:
duration D, ease E, direction (up/down/toward/away/grow/shrink), and
deceleration time (frames from peak velocity to rest). Then:
  a) choose a file whose audible length is between 1.0*D and 3.0*D;
  b) require attack <= 20ms if E is an *.out ease, 60-150ms if E is *.inOut,
     and a building envelope if E is *.in;
  c) pitch it +1..+5 semitones if the motion goes up/toward/larger, -1..-7 if
     down/away/smaller;
  d) pitch and lengthen for mass: deceleration >= 0.4s -> -3..-7 st and a
     600-1200ms sound; a dead stop within 4 frames -> +2..+5 st and <= 300ms.
All pitch changes must be BAKED with ffmpeg before import - data-playback-rate
is pitch-preserved and cannot do this.

STEP 4 - BUILD ONE FAMILY, NOT TWENTY FILES. Pick one whoosh, one pop and one
impact for the whole project. Generate 4 variants of each with the three
parameters: pitch (+/-2 and +/-4 semitones), reverb (one wet variant), and
duration (one time-stretched variant). Assign variants so no identical file
plays twice within 60s.

STEP 5 - ONE SPACE. Give every abstract element the same reverb wet value
(0.12 default) via a shared hf-audio-group, so the graphics all sound like
they are in one room.

ACCEPTANCE TEST: for every abstract event print duration_ratio, measured
attack in ms, the motion's ease family and its direction. Every row must
satisfy: 1.0 <= ratio <= 3.0; attack within the band for its ease; pitch
direction matching motion direction. Every real-object event must use a
literal sound whose transient sits within 45ms of the visual contact frame.
```

## Execution spec

**HyperFrames.** The critical constraint, and it is easy to miss: **`data-playback-rate` is normalized 0.1–5 and is pitch-preserved for sound.** You cannot pitch a whoosh in the composition by slowing it down — you get a longer file that sounds identical. Every pitch variant must be baked before import.

```bash
# pitch WITHOUT changing duration (the usual want)
ffmpeg -i whoosh.wav -af "rubberband=pitch=1.1225"  whoosh.+2st.wav   # 2^( 2/12)
ffmpeg -i whoosh.wav -af "rubberband=pitch=0.8909"  whoosh.-2st.wav   # 2^(-2/12)
ffmpeg -i whoosh.wav -af "rubberband=pitch=0.7937"  whoosh.-4st.wav   # 2^(-4/12)

# pitch AND duration together (tape-style; also makes the file shorter/longer)
ffmpeg -i whoosh.wav -af "asetrate=48000*0.8909,aresample=48000" whoosh.tape-2st.wav

# time-stretch without pitching (make one file fit a longer move)
ffmpeg -i whoosh.wav -af "rubberband=tempo=0.75" whoosh.long.wav

# measure attack: RMS in 10ms windows from the file start
ffmpeg -i whoosh.wav -af "astats=metadata=1:reset=1,ametadata=print" -f null -
```

Reverb and the shared space are declared, not baked, and belong on a bus:

```html
<hf-audio-group id="sfx" data-label="Graphics SFX" data-volume="0.9"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;r1&quot;,&quot;label&quot;:&quot;Graphics Room&quot;,
     &quot;params&quot;:{&quot;size&quot;:0.45,&quot;damping&quot;:0.6,&quot;wet&quot;:0.12,&quot;dry&quot;:0.95}},
    {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;r2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></hf-audio-group>
```

Contract points:
- Audio JSON attributes must be **double-quoted with `&quot;`** or `carve.mjs` cannot see them.
- `reverb` convolves a **generated** impulse and preview and render generate the same one — the room is reproducible without shipping an IR file. But a reverb **tail makes the rendered track longer than its source** (`chainTailSeconds`); a bed with reverb no longer ends exactly on its `data-duration`, and that is expected.
- `reverb`'s `wet`/`dry` are automatable; `size`/`damping` are not (they regenerate the impulse). `compressor`, `limiter`, `gate` and `bitcrush` have **no** automatable parameters — automate a `gain` stage around them instead.
- Keep the `sfx` group separate from the `voiceover` carve group: a non-voice clip inside the carve group silently poisons the next re-analysis.
- Chain order doctrine: *subtract before you add, level after you filter, character and ceiling last* — limiter last.
- For a REAL object, the picture is what moves: adjust the clip's `data-media-start` (a sub-window, no new file) rather than sliding the sound.

**Epidemic Sound.** For a REAL object, search the literal noun and prefer the recorded-source families (`mechanical--click`, `communications--camera`, `fight--impact`, `computers--keyboard-mouse`). For an ABSTRACT object, search by **envelope** instead: `swooshes--whoosh` / `swooshes--swish` for glides, `cartoon--pop` for light dead-stops, `designed--impact` / `designed--boom` for heavy landings, `designed--riser` for builds — then use `SearchSimilarToSoundEffect` on the chosen file to build the family rather than searching again.

**Remotion.** Same rules; `<Audio>` has no pitch control either, so bake variants the same way. Concept only.

## Pairs with
[[motion-sfx-pass-manifest]] · [[motion-sound-bound-motion-event]] · [[motion-silent-motion-tier]] · [[motion-travel-reveal-streak]] · [[motion-snap-zoom-punch]] · [[motion-instant-appearance-sfx-justified]] · [[sfx-search-vocabulary]] · [[sfx-ab-audition-candidates]] · [[sfx-placement-discipline]] · [[sfx-cartoon-comedy-family]]

## Failure modes
- **Creative sound on a real object.** The source's own example: a water sound where something else belongs "feels weird". Correction: literal sound, literal timing, and move the picture if they disagree.
- **A long sound on a short move.** The audio outlives the picture event and the scene sounds haunted. Correction: 1.0–3.0× duration ratio, trimmed with `data-media-start`.
- **Attack disagreeing with the ease.** A 200 ms swell under a 4-frame `expo.out` snap is heard as late even when the file starts on the right frame. Correction: match attack to ease family.
- **Pitch contour inverted.** Rising graphic, falling sound. Correction: check direction before choosing.
- **Mass read from size instead of deceleration.** A big card that stops instantly given a heavy 1 s boom feels wrong; a small chip with a long settle given a click feels weightless. Correction: read the deceleration, not the bounding box.
- **Trying to pitch with `data-playback-rate`.** It is pitch-preserved: the file just gets longer. Correction: bake with `rubberband` or `asetrate`.
- **Twenty files, no family.** Every graphic sounds like a different video. Correction: one file per class, four baked variants, one shared reverb bus.
- **Mixed reverb across the same scene.** A dry pop next to a hall whoosh breaks the illusion of one space. Correction: put the reverb on the bus, not on clips.
