---
id: sfx-envelope-matched-to-easing-curve
title: For invented motion any sound works — derive its envelope from the easing curve
skill: sound-design
type: sfx
family: motion-sfx
tags: [skill/sound-design, type/sfx, family/motion-sfx, sfx/motion, layer/sfx, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:05:40"
    quote: "And the fun part is, there's no rule at all. You can use any random sound effect, as long as it matches the motion of the video."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:05:46"
    quote: "If it's in sync, it will just make sense."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:23"
    quote: "But for things that don't even exist in real life, you can creatively use any sound effect you want. The speed and timing just have to match."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:04"
    quote: "And if you're putting a sound effect on a motion, then match the peak of the sound effect to the middle of the motion. And match the length of the sound effect with the motion."
research_refs:
  - https://en.wikipedia.org/wiki/Envelope_(music)
  - https://en.wikipedia.org/wiki/Doppler_effect
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://en.wikipedia.org/wiki/Transient_(acoustics)
  - https://blog.prosoundeffects.com/sound-editing-in-sync-tutorial
difficulty: high
detectable_from: audio
---

# For invented motion any sound works — derive its envelope from the easing curve

## What it is
The answer to "which sound effect do I even search for" when the thing moving does not exist: a title sliding in, a card flipping, a bar filling, a UI panel expanding. There is no real-world referent to be faithful to, so **any** sound can carry it — provided its envelope matches the motion's. Sync is what creates the meaning, not literal correspondence. This note turns "match the motion" into arithmetic by taking the four matching parameters straight off the motion spec you already wrote: **duration**, **peak position**, **attack shape** and **pitch direction**.

The one refinement research adds to the source's rule of thumb. "Peak on the middle of the motion" is right for a symmetric ease and wrong for the ease this stack uses by default. The peak belongs where the motion is **fastest** — the maximum of the easing curve's derivative — and for `power3.out`, the house entrance ease, that is at the *very start*, not the middle. Read the peak position off the ease family and the mismatch that makes an otherwise good effect feel "slightly off" disappears.

## When to use it
On every non-diegetic motion event: entrances, exits, transitions, text reveals, graphic builds, chart fills, camera moves, UI interactions. It is the sound-side of the motion library and the reason most motion notes carry a sound line.

Do **not** use this licence on a real object. A real action wants its real sound — a water sound under a page turn "just feels weird", and no amount of envelope matching fixes it ([[sfx-diegetic-action-inventory]]). The freedom is specifically for things that do not exist in life.

Also apply it as a **repair** rule: when an effect has been chosen and still feels wrong, the fault is almost always one of the four parameters, not the file. Check duration ratio, then peak position, then attack, then pitch direction, in that order, before searching for a different sound.

## How to recognise it in a reference video
- **Overlay the waveform on the motion.** Extract frames at 30 fps across the event and measure per-frame position deltas; extract the audio and look at the envelope. In matched work the **audio peak sits at the frame of maximum visual velocity**, within ±1 frame.
- **Read the ease off the deltas, then predict the peak.** Front-loaded deltas (big first, decaying) = an out-ease → peak at 10–20 % of the duration. Back-loaded = an in-ease → peak at 85–100 %. Symmetric = inOut → peak at 50 %. If the audio peak sits somewhere else, the reference did not match, and you should log the mismatch rather than copying it.
- **Compare lengths.** The audible body of the effect should run **1.0–1.3×** the motion duration, with any reverb tail beyond that. An effect much shorter than the move leaves the second half of the motion silent, which reads as the animation continuing after the sound has finished — the commonest tell of a template.
- **Listen for pitch direction against travel.** Upward, outward or growing motion carries rising pitch; downward, inward or settling motion carries falling pitch. A sound that falls while the element rises is detectable even by people who cannot say why.
- **Check spectral brightness against element size.** Large elements are sounded darker (lower spectral centroid); small elements brighter. A full-screen panel with a thin, bright tick reads as cheap.
- **Count sounds against staggered siblings.** Five cards arriving on a 0.06 s stagger should carry **one** sound, not five. Five distinct transients across 0.3 s is the machine-gun failure.
- **Overshoot needs two events.** If the element passes its resting position and settles back (a spring), competent work has a secondary, quieter transient at the settle. A single hit under a visibly bouncing element sounds unfinished.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `duration_ratio` | 1.15× the motion duration | 1.0–1.3× (body); tail unbounded | Below 1.0 the motion outlives its sound. Trim with `data-media-start` + `data-duration` rather than cutting a file. |
| `peak_position` | derived from the ease | see table below | The single most valuable number in this note. |
| `peak_tolerance` | ±0.5 f (±17 ms) | ±0.25–1 f | Post convention: keep transients within a half to a quarter of a frame. |
| `sync_offset` | 0 f | 0 to +1 f late | Never early: sound leading picture is detected from about **45 ms**, lagging only from about **125 ms**. |
| `attack_time` | match the motion's onset | 2–200 ms | Snappy out-ease (0.15–0.3 s) → attack <20 ms. Calm `sine.inOut` (0.8–2 s) → attack 80–200 ms. |
| `pitch_direction` | follows travel | ±2 to ±7 semitones | Up/out/grow → rising. Down/in/settle → falling. The physical intuition is the Doppler convention: approaching sources read higher, receding lower. |
| `spectral_weight` | follows element size | — | Large element → pitch the effect **down** (heavier, more cinematic). Small element → **up** (lighter, faster, more energetic). |
| `level` | −13 dB | −12 to −15 dB | Against dialogue at 0 to −3 dB. |
| `one_sound_per_arrival` | true | — | A staggered group is **one** event unless the stagger exceeds 0.12 s per item. |
| `stagger_step_down` | −2 dB per item | −1.5 to −3 dB | When the stagger is wide enough to warrant separate sounds, step level down and pitch up slightly per item. |
| `settle_transient` | on for overshoot | on/off | For springs with `dampingFraction` < 1.0, add a second transient at the settle, −8 to −12 dB below the first. |
| `reverb` | 8–15 % small room | 0–25 % | Without it, effects feel studio-recorded rather than inside the frame. |

**Peak position by ease family** — the derivative of the curve, expressed as a fraction of the motion's duration:

| Ease | Velocity profile | Place the peak at | Effect character to search for |
|---|---|---|---|
| `power2.out` / `power3.out` / `power4.out` | fastest at the start, long tail | **10–20 %** | Sharp attack, decaying tail: a swish-into-settle, a soft impact. |
| `expo.out` | extremely front-loaded | **5–12 %** | Hard transient, fast decay. |
| `power2.in` / `power3.in` | accelerating into the end | **85–100 %** | Rising sweep resolving on a hit at the end. |
| `power2.inOut` / `expo.inOut` | fastest at the midpoint | **45–55 %** | Symmetric whoosh; the source's "middle of the motion" case. |
| `sine.inOut` | gentle, midpoint-peaked | **50 %** | Long soft air, no transient at all. |
| `none` (linear) | constant velocity | no peak — **sustain**, resolve at 100 % | Steady tone or texture, terminated by a small arrival tick. |
| `steps(N)` | N discrete jumps | one transient per step | Ticks, typing, counter clicks. |
| spring (`dampingFraction` < 1) | front-loaded plus overshoot | **10–20 %**, plus a settle transient at the first zero-crossing back | Impact plus a quieter secondary. |
| `back.out(1.7)` | front-loaded with overshoot | **10–20 %** + settle | Rare, explicitly-playful register only. |

## Reproduction prompt

```
Sound the motion event {{EVENT}} (starts {{T}}, duration {{D}} seconds, ease
{{EASE}}, property {{PROP}}, travel {{FROM}} -> {{TO}}).

1. DERIVE THE PEAK POSITION from {{EASE}}:
     *.out family     -> peak at 0.15 * {{D}}
     expo.out         -> peak at 0.08 * {{D}}
     *.in family      -> peak at 0.92 * {{D}}
     *.inOut / sine   -> peak at 0.50 * {{D}}
     linear (none)    -> no peak; sustained sound, small tick at {{D}}
     steps(N)         -> one short tick per step
     spring/back      -> peak at 0.15 * {{D}} PLUS a settle transient at the
                         overshoot's return, 8-12dB quieter
   Peak time = {{T}} + (fraction * {{D}}).

2. DERIVE THE LENGTH: audible body = 1.15 * {{D}} (accept 1.0-1.3). Reverb
   tail may run past. Trim to length inside the composition with
   data-media-start and data-duration - do not cut a new file.

3. DERIVE THE CHARACTER:
     attack: <20ms if {{D}} <= 0.3s; 40-80ms if 0.3-0.6s; 80-200ms if > 0.6s
     pitch:  rising if {{TO}} is up/outward/larger than {{FROM}};
             falling if down/inward/smaller. +/-2 to +/-7 semitones.
     weight: pitch the whole effect DOWN 1-3 semitones if the element covers
             more than a third of the frame; UP 1-3 if it is small.

4. FETCH ANY SOUND THAT FITS THAT ENVELOPE. The source of the sound does not
   matter for invented motion - a paper rustle, a synth sweep, a struck metal
   object are all valid if the envelope matches. Do NOT apply this licence to
   a real physical action; those need their real sound.

5. PLACE BY PEAK. start = peak_time - (transient offset inside the file).
   Target 0 offset against picture; if you must err, err LATE by up to 1
   frame, never early.

6. GROUPS: if {{EVENT}} is a staggered set of siblings, use ONE sound for the
   whole arrival unless the per-item stagger exceeds 0.12s. If it does, one
   sound per item, each 2dB quieter and 1 semitone higher than the last.

ACCEPTANCE TEST: render the event and watch it 3 times. (1) The loudest moment
of the sound must coincide with the fastest moment of the picture - if the
element is already still when the peak arrives, the peak position is wrong.
(2) The sound must not finish before the motion does. (3) Mute the picture:
the sound alone should describe a movement of the same speed and direction.
(4) Swap in a completely different sound file with the same envelope - it
should work equally well. If it does not, you are relying on the file rather
than on the match, and the envelope is not actually right yet.
```

## Execution spec

**HyperFrames.** The motion and the sound are two independent declarations that must carry the same arithmetic. There is no audio-follows-animation attribute — you write the number twice.

```js
// The motion: 0.45s slide-in on the house ease, at composition second 61.2
const T = 61.2, D = 0.45;                 // 0.45s = 13.5 frames @30fps
tl.fromTo("#card-a", { y: 40, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: D, ease: "power3.out" }, T);
// power3.out -> peak at 0.15 * D = 0.0675 -> peak time 61.2675
```

```html
<!-- the file's own transient sits 0.062s into it, so start = 61.2675 - 0.062 -->
<audio id="sfx-card-a" src="assets/sfx/soft-swish.wav"
       data-audio-group="sfx" data-start="61.206" data-duration="0.52"
       data-track-index="12" data-volume="0.22"></audio>
```

Contract points that bind this:
- **Author seconds; frames are a derived comment.** 0.45 s is 13.5 frames at 30 fps and 10.8 at 24 — if `--fps` changes, the seconds stay and the frame counts move, which is exactly why the peak fraction (a ratio) is the durable spec and the frame count is not.
- **A sub-comp's timeline is scene-local.** If the motion lives in a sub-composition at scene-local `t`, the audio at the root needs `data-start = t + the slot's data-start`. Relative timing (`data-start="el-intro + 0.2"`) can express that, with four silent-zero failure modes: spaces around the operator are **required**, an unresolved id resolves to 0, a target with no resolvable duration lands you on its **start** rather than its end, and a cycle resolves to 0. None of these are linted.
- **Audio lives at the host root** in modular projects so playback survives scene cuts, while the motion stays inside the scene — this is the normal case for this note, not the exception.
- **`data-media-start` + `data-duration` trim in place.** Only cut a physical file when the asset is leaving the pipeline.
- **`data-playback-rate` is a constant in `0.1..5` and is pitch-preserved** — so it changes an effect's *length* without changing its pitch, which is the opposite of what a classic tape-style speed change does. To change pitch you need the `pitch` treatment in the FX chain or a preprocessed file. **There is no rate envelope**, so an accelerating sound must be preprocessed.
- **Every `<audio>` needs an `id`** or it is never mixed — silent render.
- **Give SFX their own group**, never the voice group used for carve.
- **Do not both tween and automate `volume`** on one track (`audio_volume_double_automation`); a `volume` tween is absolute and replaces `data-volume` entirely (`audio_volume_tween_overrides_gain`).
- **The stagger cap is a sound cap too.** The rules contract caps an arrival at `items × stagger ≤ ~0.5s` so it reads as one beat — which is precisely why one arrival takes one sound.
- **Springs are seek-safe only as baked eases.** `springEase({response, dampingFraction})` is a pure function of progress; take **both** the ease and the duration from the helper, and note that at `dampingFraction` < 1 overshoot goes on transforms only, never on opacity or colour. The settle transient's time comes from the helper's duration, not from a guess.

**Epidemic Sound.** Search by envelope, not by object:

```
# out-ease entrance, 0.45s: short sharp attack with a decaying tail
SearchSoundEffects { query: { term: "short swish transition light" },
                     filter: { duration: { max: 900 } } }
# in-ease exit resolving on a hit
SearchSoundEffects { query: { term: "riser short impact resolve" },
                     filter: { duration: { min: 400, max: 1200 } } }
# linear camera move: sustained texture, no transient
SearchSoundEffects { query: { term: "air movement texture sustained" },
                     filter: { duration: { min: 2000 } } }
```
`SearchSimilarToSoundEffect` on a hit that has the right envelope but the wrong colour is faster than re-querying.

**ffmpeg — the three variation knobs and the transient measurement.**

```bash
# find the transient offset (what you align, never the file head)
ffmpeg -i swish.wav -af "silencedetect=noise=-45dB:d=0.02" -f null - 2>&1 | grep silence_end

# pitch WITHOUT changing length (+2 semitones = ratio 1.122)
ffmpeg -i swish.wav -af "asetrate=48000*1.122,aresample=48000,atempo=0.891" swish.up2.wav
# length WITHOUT changing pitch (stretch to 1.15x)
ffmpeg -i swish.wav -af "atempo=0.87" swish.long.wav
# reverse a sweep so it rises instead of falls
ffmpeg -i sweep.wav -af "areverse" sweep.rise.wav
```

**Remotion.** Frame-native, so the peak fraction becomes a literal frame: `peakFrame = startFrame + Math.round(0.15 * durationInFrames)`. Not a runtime in this project.

## Pairs with
[[sfx-unsounded-motion-audit]] · [[sfx-peak-on-impact-frame]] · [[sfx-layered-approach-and-impact]] · [[sfx-diegetic-action-inventory]] · [[sfx-av-sync-binding-window]] · [[motion-sound-bound-motion-event]] · [[motion-instant-appearance-sfx-justified]] · [[sfx-air-on-micro-movement]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-search-vocabulary]] · [[motion-overlay-stack-choreography]]

## Failure modes
- **Peak on the middle of an out-ease.** The most common near-miss: the element has already arrived and is settling when the loudest moment lands. It feels late even though nothing is late. Correction: read the peak fraction off the ease family.
- **Sound shorter than the motion.** The animation continues in silence and the whole event feels unfinished. Correction: body length 1.0–1.3× the motion.
- **Sound much longer than the motion.** The tail runs into the next beat and the edit starts to smear. Correction: trim with `data-duration`, and keep only reverb past the motion's end.
- **Pitch contradicting travel.** Falling pitch on a rising element. Correction: match direction, ±2–7 semitones.
- **One sound per staggered sibling.** Machine-gun. Correction: one sound per arrival unless the stagger exceeds 0.12 s.
- **No settle sound under an overshoot.** The picture bounces, the sound does not, and the spring reads as a rendering glitch. Correction: a second transient 8–12 dB down at the settle.
- **Treating the licence as universal.** Applying "any sound works" to a real object produces the water-on-a-page-turn effect the source names as obviously wrong. Correction: the licence covers invented motion only.
- **Everything sounded.** Envelope-matching makes it easy to sound every tween, which is how a video arrives at a tick every other second and tires the viewer within two or three minutes. Correction: the sound-pass budget decides *which* events get sound; this note only decides how.
- **Known gap.** Nothing in this stack derives a sound from a motion automatically. `animation-map.mjs` can enumerate a composition's tweens (start, duration, targets) and would be the natural input for generating placements — but it reads live timelines in a browser, and this project's authoring VM is linux ARM64 without sudo, so it cannot run here. Until then the peak arithmetic is done at authoring time and written into the design document alongside the motion row.
