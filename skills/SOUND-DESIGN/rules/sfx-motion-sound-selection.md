---
id: sfx-motion-sound-selection
title: Which motions get a sound - and which stay silent
skill: sound-design
type: sfx
family: motion-sfx
tags: [skill/sound-design, type/sfx, family/motion-sfx, engine/hyperframes, engine/epidemic, sfx/motion, layer/sfx, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:04:17"
    quote: "\"So should I slap a whoosh on every single motion?\" You don't put a whoosh on everything."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:04"
    quote: "And if you're putting a sound effect on a motion, then match the peak of the sound effect to the middle of the motion. And match the length of the sound effect with the motion."
research_refs:
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://en.wikipedia.org/wiki/Habituation
  - https://en.wikipedia.org/wiki/Orienting_response
  - https://en.wikipedia.org/wiki/Sound_effect
  - mcp://Epidemic_sounds/SearchSoundEffects (whoosh/swish duration ranges probed live, 2026-08-27)
difficulty: medium
detectable_from: transcript+video
---

# Which motions get a sound - and which stay silent

## What it is
Motion sound effects are the second of the three styles: a sound bound to something travelling across, into or out of frame. The brain expects a sound when it sees movement, and its absence makes an edit feel hollow — but the inverse is not true. Every motion *invites* a sound; none *obliges* one. This note is the selection rule that sits between the two errors: silent animations that feel fake, and the tick-tick-tick overload that tires a viewer *"within 2 or 3 minutes"*. The mechanism behind that fatigue is habituation, which accelerates as the inter-stimulus interval shortens — so density, not loudness, is what kills a motion-sound pass.

## When to use it
Sonify a motion when it passes **at least two** of these tests:
1. **Narrative weight** — the moving element carries the point of the shot (the headline, the number, the reveal), not decoration.
2. **Frame traversal** — it crosses a meaningful part of the frame, or enters/exits it, rather than nudging in place.
3. **Speed** — it completes in **6–20 frames (0.2–0.67 s)**. Slower moves want a swell or nothing; faster ones are over before a sound resolves.
4. **Isolation** — nothing else is being sonified within ±0.5 s.
5. **It is the top of the hierarchy** — when six elements animate at once, one sound covers the group; you sonify the *group gesture*, not each member.

Leave it silent when: the motion is ambient (a slow push-in, a parallax drift, a subtle scale); it is one of a stagger (sonify the stagger's start, not each item); dialogue is landing an important word on that frame; or the previous effect was under 0.5 s ago.

## How to recognise it in a reference video
- **Count density.** Log every effect with a timecode and compute effects per 10 s. Restrained creator editing runs **1–3 per 10 s**; high-energy editing runs 4–6; above ~8 per 10 s you are looking at the overload mistake, and the audio track shows near-continuous transient activity.
- **Check the alignment convention.** For a motion, the effect's **peak sits at the midpoint of the movement** and the effect's length matches the movement's length. For a cut, the peak sits **on the cut frame**. These are two different rules and reference videos follow one or the other per event.
- **Look for what is NOT sonified.** The diagnostic signal for a good pass is a whole animated sequence with a single sound on the most important element. If every element has its own, note it as overload.
- **Lead measurement:** motion effects usually start **2–6 frames (67–200 ms) before** the visual motion begins, because the noise ramp needs time to arrive at its own peak. Effects starting *after* the motion begins read as late.
- **Repeat check:** if the same whoosh file recurs, its waveform is byte-identical between events. Named as mistake number three in the source video.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| SFX density | 2 per 10 s | 1–4 per 10 s | Above 6 per 10 s, habituation dominates. |
| Minimum gap between effects | 0.5 s | 0.35–1.5 s | Two effects inside 0.35 s read as one messy event. |
| Motion duration that earns a sound | 0.2–0.67 s | 0.15–1.0 s | 6–20 frames at 30 fps. |
| Effect start vs motion start | −4 frames (−0.133 s) | −2 to −6 frames | Effect leads; its peak then lands mid-motion. |
| Peak alignment (motion) | midpoint of the move | ±2 frames | Per the source video. |
| Peak alignment (cut) | on the cut frame | ±1 frame | Different rule; do not mix them up. |
| Level | −12 dB → `data-volume="0.25"` | −15 to −9 dB | Standard SFX tier. |
| Simultaneous animations sonified | 1 | 1 | One sound for the group gesture. |
| Distinct variations per family | 3 | 2–5 | Never the same file twice in a row. |

## Reproduction prompt

```
Run the motion sound pass over design-motion.md. Work event by event; most
events will get NO sound.

FOR EACH motion event with start {{M_IN}} and end {{M_OUT}}:
1. SCORE IT against the five tests: narrative weight, frame traversal, duration
   between 0.2 and 0.67 s, isolation (no other effect within 0.5 s), top of the
   on-screen hierarchy. Fewer than 2 passes -> SKIP IT and write "silent -
   <reason>" in the design row. Skipping is the expected outcome for most rows.
2. CHOOSE THE FAMILY by the movement's character:
     long lateral travel / heavy      -> whoosh   (300-2000 ms)
     fast, light, high, small element -> swish    (150-800 ms)
     very fast snap / punchline       -> whip     (300-1500 ms)
     arrival that lands and stops     -> whoosh + a small impact on the stop
3. FETCH 3 VARIATIONS, not one:
     SearchSoundEffects { query: { term: "whoosh transition fast short light" },
                          filter: { duration: { min: 300, max: 2000 } }, first: 5 }
   then SearchSimilarToSoundEffect on the winner for siblings. Download WAV.
4. PLACE. Set data-start = {{M_IN}} - 0.133 so the effect leads by 4 frames, and
   trim with data-media-start so the file's PEAK falls at ({{M_IN}}+{{M_OUT}})/2.
   Set data-duration to ({{M_OUT}} - {{M_IN}}) + 0.2 so the tail clears the move.
   data-audio-group="sfx", data-volume="0.25", track index 12.
5. AFTER THE PASS, compute density over every rolling 10 s window. Any window
   above 4 effects: delete the least important effect in it and re-check.

ACCEPTANCE TEST: play the sequence with your eyes shut - you should be able to
describe the shape of the main movements and nothing else. Play it again
watching: no animation feels silent that should have sounded, and you never hear
two effects fighting inside half a second. No two consecutive effects are the
same file.
```

## Execution spec

**HyperFrames.** Motion and sound are coupled **by the author writing the same number twice** — there is no audio-follows-animation attribute. The tween's timeline position and the `<audio data-start>` must be authored together, and if the animation lives in a sub-composition at scene-local `t`, the root-level audio needs `data-start = t + the slot's data-start` (a sub-comp timeline cannot reach host-root elements, and audio belongs at the host root so it survives scene cuts).

```html
<!-- motion: text slides in over 12 frames (0.4 s) starting at 6.0 s -->
<audio id="sfx-swish-headline" src="assets/audio/sfx/swish-02.wav"
       data-audio-group="sfx"
       data-start="5.867"            
       data-media-start="0.05"
       data-duration="0.6"
       data-track-index="12" data-volume="0.25"></audio>
```
```js
// same 6.0 on the timeline, authored by hand
tl.fromTo("#headline", { x: -40, autoAlpha: 0 }, { x: 0, autoAlpha: 1, duration: 0.4, ease: "power2.out" }, 6.0);
```
All time is **seconds**; convert frames at authoring time (4 frames = 0.133). Every `<audio>` needs an `id` or it is never mixed. Put effects on a track index of 12+, and give simultaneous effects different indices to avoid `duplicate_audio_track`.

For per-effect character (the source video's mixing toolkit), a `data-fx-chain` on the clip: `highpass` at 400–800 Hz to make an effect feel sharp and sit above the voice; `lowpass` at 1500–3000 Hz to make it muffled and distant; a `reverb` node (`size` 0.3–0.6, `wet` 0.15–0.3) so it stops sounding studio-recorded. Order is signal order and the limiter, if any, goes last.

**Epidemic Sound.** Verified duration ranges to filter on (milliseconds): whoosh 300–2000 (`designed--whoosh`; live results at 2.0 s, 3.0 s, 3.6 s — set `max` or you get long transition risers), swish 150–800 (`swooshes--swish`; live results at 0.57 s and 1.6 s), whip 300–1500 (`weapons--whip`; live result 1.38 s). Query grammar: `whoosh transition fast short light`, `swoosh swish rope thick`, `whip crack short`. `SearchSimilarToSoundEffect` is the correct way to build the 3-variation set that prevents repeats.

**ffmpeg.** Match a sound's length to a movement when no asset fits: `ffmpeg -i whoosh.wav -af "atempo=1.35" whoosh.short.wav` (tempo, pitch preserved) or `asetrate` for the pitch-and-length change together. `data-playback-rate` (0.1–5, pitch-preserved) does the same in-composition without a new file, and is the better first choice.

**Remotion.** `<Sequence from={motionStartFrame - 4}><Audio src={...} volume={0.25} /></Sequence>` — the 4-frame lead is expressed directly in frames.

## Pairs with
[[sfx-name-before-search]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-layer-volume-targets]] · [[struct-stimulation-budget]] · [[sfx-whoosh-transition-movement-reveal]] · [[motion-entrance-vocabulary]] · [[sfx-split-edit-lead-lag]]

## Failure modes
- **A whoosh on everything.** The named mistake. Symptom: a viewer notices the sound design as a layer. Fix by deletion, not by lowering levels — density is the problem.
- **Sonifying every item of a stagger.** Six items entering 3 frames apart with six sounds is one smeared noise. One sound on the group's entrance.
- **Effect starting on the motion's first frame.** The noise ramp then peaks after the movement is over. Lead by 2–6 frames so the peak lands mid-motion.
- **Using the cut alignment rule on a motion.** Peak-on-the-cut is for cuts; peak-at-the-midpoint is for motions. Mixing them makes half your effects feel early.
- **Length mismatch.** A 2 s whoosh on a 0.25 s move keeps sounding after the picture has settled. Match length via `data-playback-rate` or `atempo`.
- **Same file repeated.** Audible within two or three uses. Pull siblings, or vary pitch/duration/reverb.
- **Sonifying a motion that lands on an important word.** The effect masks the word; the word loses. Move the effect or drop it.
- **Known gap:** nothing in the stack computes SFX density or checks audio-to-motion alignment. The density count and the frame-by-frame alignment check are manual steps and must be written into the build manifest as explicit tasks.
