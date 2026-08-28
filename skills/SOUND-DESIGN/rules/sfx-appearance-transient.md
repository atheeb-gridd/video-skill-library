---
id: sfx-appearance-transient
title: The arrival transient — a sound can stand in for an entrance animation
skill: sound-design
type: sfx
family: appearance
tags: [skill/sound-design, type/sfx, family/appearance, engine/hyperframes, engine/epidemic, engine/ffmpeg, sfx/motion, layer/sfx, source/editing-kt, source/sfx-kt-1, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:03"
    quote: "Any time a graphic shows up on screen, it can't just appear out of nowhere. That doesn't make sense. It has to get into the frame somehow."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:13"
    quote: "You don't necessarily have to animate the elements. You can also have something magically appear on screen, but then explain how it got there with a sound effect. I like using this shutter sound effect, but a pop or something similar works too."
research_refs:
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Diegetic_music
  - https://en.wikipedia.org/wiki/Camera_shutter
  - mcp://Epidemic_sounds/SearchSoundEffects (shutter / pop / UI-click families probed live, 2026-08-27)
difficulty: low
detectable_from: transcript+video
---

# The arrival transient — a sound can stand in for an entrance animation

## What it is
The continuity rule says nothing may appear from nowhere; it does not say the explanation has to be visual. An element can cut on in a single frame provided a short, hard-attack sound lands on that frame and supplies the cause. The presenter's default is a camera shutter — the sound of a photograph being taken, which reads as "this image was placed here" — and a pop, click or soft transient does the same job in a lighter register. The sound is doing the work the entrance animation would otherwise do: it gives the change an agent.

This is the cheapest continuity move in the library. It costs one audio clip and no keyframes, and it is the correct choice when an entrance animation would either slow the beat down or pull focus from the line being spoken over it.

## When to use it
- **Fast overlay stacks.** Four or five supporting graphics land inside three seconds. Animating each one costs more screen time than the beat has; cut each on and give each an arrival transient.
- **Anything appearing under a live line.** An entrance animation competes with the words; a 200 ms transient does not.
- **Screenshots, receipts, proof cards, list items, annotations, circles and arrows.** All of these read as "placed", which is exactly what a shutter says.
- **When the element must land on an exact beat.** A transient is frame-exact; an eased entrance has a perceptual centre somewhere inside its ramp.

Do **not** use it when the element's arrival direction carries meaning (something coming *from* the timeline, *from* off-screen left) — that wants travel and a whoosh, see [[sfx-whoosh-transition-movement-reveal]]. Do not use it more than once every ~2 s: a shutter every second is the "tick-tick-tick" overload the second source video names.

## How to recognise it in a reference video
- **On the video track:** an element's opacity/geometry goes from absent to fully resolved between two adjacent frames — no ramp, no scale settle. Step through frame by frame; if there is not a single intermediate frame, it is an instant appearance.
- **On the audio track:** a transient with a rise time under ~10 ms and a total audible body under ~400 ms, sitting on the same frame. Shutters show a characteristic double transient (open + close, ~40–120 ms apart); pops show a single burst with almost no tail.
- **Measure the offset in frames.** `peak_frame − appear_frame` should be **0 to +2 frames**. The ITU threshold for detecting sound *leading* picture is about **45 ms (1.4 frames at 30 fps)**, while sound *lagging* is only detected from about **125 ms (3.7 frames)** — so competent work sits on the frame or a touch late, never early.
- **Level:** the transient peaks well under dialogue — typically **12–18 dB down**. If it reads at dialogue level it is being used as punctuation, not as continuity, and belongs to [[sfx-cinematic-hit-emphasis]] instead.
- **Repetition check:** the same creator usually uses one signature transient (the shutter) throughout, with 2–4 variants. Identical waveforms on every appearance is the named repeat mistake.
- **Transcript check:** the element usually appears on a noun the presenter has just said, within 0–6 frames of that word's onset.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Transient family | camera shutter | shutter · pop · UI click · tape stop · soft thud | Shutter = "placed/captured". Pop = light, playful. Click = interface/tech. Tape stop = retro/comedic. |
| Peak vs appearance frame | 0 f | 0 to +2 f (0 to +67 ms) | Never earlier than −1 f; audio-lead detection starts at ~45 ms. |
| Audible body length | 250 ms | 120–400 ms | Longer than 400 ms stops reading as an instant and starts reading as an animation that is missing. |
| Attack (rise time) | < 10 ms | 1–20 ms | A soft attack cannot explain an instantaneous change. |
| Level vs dialogue | −14 dB (`data-volume="0.2"`) | −12 to −18 dB (`0.251`–`0.126`) | −12 dB when the graphic is the point; −18 dB when it is background furniture. |
| Ducking | none | none | Too short to duck for. If it lands on a stressed syllable, move it to the nearest gap instead. |
| Minimum spacing | 2.0 s | 1.2–4 s | Below 1.2 s consecutive appearances smear into one noise. |
| Variants held | 3 | 2–5 | Rotate; never the same file twice in a row. |
| Pitch variation | ±0 | −3 to +3 semitones | Cheapest way to make one file into three. |
| Reverb (glue) | `wet` 0.08 | 0.05–0.15 | Only if the rest of the SFX bus is treated — see [[sfx-reverb-glue]]. |

## Reproduction prompt

```
Give the element that appears instantly at {{T_APPEAR}} seconds an arrival
transient so its appearance has a cause.

1. CONFIRM IT IS AN INSTANT APPEARANCE. The element's clip starts at
   {{T_APPEAR}} with no entrance tween. If an entrance animation already
   exists, STOP - use the whoosh rule instead, not this one.
2. CHOOSE THE FAMILY. Screenshot / photo / proof card / annotation -> camera
   shutter. Playful or small element -> pop. Tech, UI, cursor, code -> click.
   Keep the SAME family for every instant appearance in this video.
3. FETCH THREE CANDIDATES (never one):
     SearchSoundEffects {
       query:  { term: "camera shutter click" },
       filter: { tagSlugs: { matchType: ALL, values: ["communications--camera"] },
                 duration: { min: 250, max: 1100 } },
       first: 8 }
   Prefer a title containing "Shutter Click Only" - the full-camera takes carry
   mirror and motor tails you do not want. Download WAV via DownloadSoundEffect.
4. MEASURE THE FILE'S PEAK, do not assume it is at the head:
     ffmpeg -i sfx.wav -af "astats=metadata=1:reset=0.01,ametadata=print:\
     key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
   Read the window index with the highest peak; peak_offset = index * 0.01 s.
5. PLACE IT. On the audio clip set:
     data-start      = {{T_APPEAR}} - peak_offset
     data-media-start= 0
     data-duration   = peak_offset + 0.35
     data-volume     = "0.2"        (-14 dB under dialogue)
     data-audio-group= "sfx", data-track-index = 12
   Every <audio> needs a unique id or it is silently dropped from the mix.
6. CHECK THE WORD IT LANDS ON. If {{T_APPEAR}} falls on a stressed syllable in
   the transcript, move the appearance (and the sound) to the next word gap,
   1-4 frames away. Dialogue wins.
7. VARY. If this is the second or later use, pitch the file by -2 or +2
   semitones, or use candidate 2 or 3 from step 3.

ACCEPTANCE TEST: scrub the half second around {{T_APPEAR}} at quarter speed.
The picture change and the transient are indistinguishable in time - you cannot
say which came first. Muted, the appearance looks like a glitch; unmuted, it
looks intended. No word is masked. The transient is audible at conversational
listening level but you would not be able to name it without being asked.
```

## Execution spec

**Hyperframes.** An instant appearance is simply a clip with a `data-start` and no entrance tween — there is nothing to animate, which is the point. Never tween `display`/`visibility` on the clip element itself (lint rejects it; the framework owns clip visibility). The sound is coupled to it **by writing the same number twice** — there is no audio-follows-element attribute.

```html
<!-- the graphic: appears on one frame at t = 8.40 s -->
<img id="proof-card" class="clip" src="assets/img/proof.png"
     data-start="8.4" data-duration="2.6" data-track-index="2">

<!-- the arrival transient: file peak measured at 0.021 s into the file -->
<audio id="sfx-shutter-01" src="assets/audio/sfx/shutter-click-only.wav"
       data-audio-group="sfx"
       data-start="8.379" data-media-start="0" data-duration="0.371"
       data-track-index="12" data-volume="0.2"></audio>
```

Time is authored in **seconds** — 2 frames at 30 fps is `0.067`. If the graphic lives inside a sub-composition at scene-local `t`, the audio stays at the host root and needs `data-start = t + the slot's data-start`; a sub-comp timeline cannot reach host-root elements, and audio at the root survives scene cuts. Give simultaneous effects different `data-track-index` values to avoid the `duplicate_audio_track` warning.

**Epidemic Sound.** Verified live (2026-08-27), with the tag slugs the catalogue actually uses:

| Family | Query | Filter | Real results |
|---|---|---|---|
| Shutter | `camera shutter click` | `tagSlugs ALL ["communications--camera"]`, `duration 250–1100 ms` | *Communications, Camera, Digital SLR, Sony Alpha, Take Photo, Shutter Click Only* — **379 ms** (best: no motor tail) · *Canon EOS 5D, Shutter* — 832 ms · *Nikon D3100, Shutter* — 1062 ms |
| Pop | `pop ui appear short` | `tagSlugs ANY ["user-interface--alert","user-interface--click"]`, `duration 50–800 ms` | *User Interface, Click, UI Buttons, Bubbly, Select* — **197 ms** · *User Interface, Alert, Pops, Low, Zap* — 212 ms |
| Click | `ui click select button` | `tagSlugs ALL ["user-interface--click"]`, `duration 50–400 ms` | same family, sub-250 ms takes |

Epidemic titles are built `Category, Subcategory, Object, Descriptors, Variant NN` — search in that word order and you hit the right shelf far more reliably than searching an adjective. Use `SearchSimilarToSoundEffect` on the winner to build the 3-variant rotation.

**ffmpeg.** Locating the peak (step 4 above) is the only raw-media operation this note needs; trimming is done in-composition with `data-media-start`, never by cutting a file. To pitch a variant without a second download: `ffmpeg -i shutter.wav -af "asetrate=48000*1.12,aresample=48000" shutter.up2.wav` (changes length as well as pitch — acceptable for a 380 ms file).

**Remotion.** `<Sequence from={appearFrame} durationInFrames={12}><Audio src={shutter} volume={0.2} /></Sequence>` — the frame lead is expressed directly in frames, and the element is rendered with no interpolation.

## Pairs with
[[motion-instant-appearance-sfx-justified]] · [[sfx-peak-on-the-cut]] · [[sfx-motion-sound-selection]] · [[sfx-layer-volume-targets]] · [[sfx-name-before-search]] · [[sfx-real-vs-invented-sound-rule]] · [[sfx-reverb-glue]] · [[cut-full-screen-transition]] · [[motion-overlay-stack-choreography]] · [[struct-stimulation-budget]]

## Failure modes
- **A soft-attack sound on an instant appearance.** A pad, swell or long whoosh cannot explain a one-frame change; the ear hears the element arrive before the sound does. Rise time under 10 ms or pick a different file.
- **Placing the file's head on the appearance frame.** Most shutter files have 20–60 ms of pre-transient. The result lands late by exactly that much. Measure the peak.
- **Leading the picture.** Sound-early is detected at ~45 ms, roughly three times more sensitively than sound-late. When in doubt, be a frame late, never a frame early.
- **Using it as the house transition.** A shutter on every graphic in a 90-second video is the density mistake; the effect stops meaning "placed" and starts meaning "the editor has one sound".
- **The same file every time.** Audible by the third use. Rotate three variants or pitch-shift.
- **Masking a word.** A 200 ms transient over a consonant costs a word. Slide it into the nearest speech gap.
- **Known gap:** nothing in the stack verifies audio-to-picture alignment. The frame-offset check and the peak measurement are manual steps and must appear as explicit tasks in the build manifest.
