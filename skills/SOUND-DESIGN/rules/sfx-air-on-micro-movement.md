---
id: sfx-air-on-micro-movement
title: Air on the small moves — whoosh a gesture, a zoom, even an eye roll
skill: sound-design
type: sfx
family: aesthetic-sfx
tags: [skill/sound-design, type/sfx, family/aesthetic-sfx, sfx/aesthetic, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:41"
    quote: "But if I'm moving, if the camera is zooming, if I'm rolling my eyes — adding a whoosh or an air sound effect to all of that adds an aesthetic to the video."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:48"
    quote: "Your viewer won't notice that you placed a sound effect there, but they will feel it."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:04"
    quote: "And if you're putting a sound effect on a motion, then match the peak of the sound effect to the middle of the motion. And match the length of the sound effect with the motion."
research_refs:
  - https://sound.krotosaudio.com/whoosh-sound-effects/
  - https://blog.prosoundeffects.com/sound-layering
  - https://pixflow.net/blog/audio-mixing-premiere-pro/
  - https://www.soundonsound.com/techniques/sound-design-visual-media
  - https://vocal.com/audio/psychoacoustic-effects-masking/
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: audio
---

# Air on the small moves — whoosh a gesture, a zoom, even an eye roll

## What it is
The third and quietest class of sound effect: **aesthetic**. Where diegetic effects make the world real and motion effects satisfy the brain's expectation that visible movement makes noise, aesthetic effects are pure polish — a breath of air on a hand crossing frame, on a camera push, on a shoulder turn, on an eye roll. Nobody would say the shot needed a sound there, which is exactly the point: *"your viewer won't notice that you placed a sound effect there, but they will feel it."* The distinguishing feature is **level and spectrum, not choice of file**. An aesthetic accent sits far below the noticed layer and is high-passed so it carries no weight; the same whoosh 10 dB louder with its low end intact becomes a motion effect and is heard as one.

## When to use it
As a **separate late pass**, after the motion-sound pass is complete and the mix is otherwise balanced ([[sfx-sound-pass-order]]). Its candidates are the moves that the motion pass correctly ignored because nothing about them demands sound: a presenter's gesture, a lean into camera, a head turn, a shrug, a slow push-in, a Ken Burns drift, a subtle parallax, an eye roll played for comedy. It is highest value on talking-head and creator content, where the picture is mostly one person in one room and the polish has nowhere else to come from. It is lowest value on footage already dense with real sound. Do **not** run it on a video that already feels busy — a video that tires the viewer's brain within two or three minutes is nearly always a video with an unbudgeted aesthetic pass on top of a complete motion pass.

## How to recognise it in a reference video
- **Look in the high band only.** Aesthetic air is high-passed, so it shows up as transient energy above ~1 kHz with nothing beneath it:
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "highpass=f=1200,asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
  ```
  (`n=1600` at 48 kHz = one frame at 30 fps.) Then run the same trace band-limited **below** 250 Hz. An aesthetic accent is a high-band event with **no** corresponding low-band event; a motion or impact effect has both.
- **Measure the level gap to dialogue.** Aesthetic accents run **18–24 dB below** the dialogue RMS — roughly **−22 to −27 dBFS** with dialogue at −10 to −12 dBFS, which places them above the ambience floor (−30) and clearly below the audible SFX layer (−12 to −15). If you can name the sound on first listen, it is too loud to be this technique.
- **Correlate with a motion trace, not with cuts.** Aesthetic accents land *inside* shots, on movement, not on boundaries:
  ```bash
  ffmpeg -i ref.mp4 -vf "tblend=all_mode=difference,signalstats,\
  metadata=print:key=lavfi.signalstats.YAVG:file=motion.txt" -f null -
  ```
  Sustained YAVG runs of **2.0–12** lasting ≥4 frames are real moves. An accent whose peak sits inside such a run, with no cut nearby, is aesthetic.
- **Peak placement inside the move.** Measure the frame of the sound's peak against the move's start and end. The taught rule is the **middle of the motion**, and the sound's **length matched to the move's length**. Log the offset — mid-move for eased-both-ends motion, earlier for a fast-out ease.
- **Density.** Count accents per minute. A tasteful pass runs **8–20 per minute** of talking head. Above ~30 per minute you are hearing the overload failure, and the reference will feel tiring even though no single sound is objectionable.
- **Spectral family consistency.** Aesthetic passes reuse one or two air textures pitched and stretched, not fifteen library files. Compare spectra of several accents — near-identical envelopes at different pitches is the fingerprint of a designed pass ([[sfx-ab-audition-candidates]]).
- **Reverb tail.** Listen for a short tail. Dry, studio-clipped air reads as pasted on; a small amount of space is what makes it belong.
- **The negative test.** Mute everything except the high band and play a minute. You should hear a soft rhythm of breaths that tracks the presenter's body. If you hear nothing, there is no aesthetic pass; if you hear an obvious percussion track, the pass is too loud.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `level_rel_dialogue` | −21 dB | −18 to −24 dB | Relative to dialogue RMS. This single number is what makes it "felt, not noticed". |
| `level_abs` | −24 dBFS | −22 to −27 dBFS | With dialogue at −10 to −12 dBFS. Compare: SFX layer −12 to −15, ambience −30. |
| `hp_cut` | 1200 Hz | 800–2000 Hz | Removing the bass is what creates "air". Also keeps the accent out of the voice's Weight band (80–250 Hz). |
| `lp_cut` | 14 kHz | 10–16 kHz | Optional; tames library brightness so the accent does not sparkle. |
| `duration` | match the move | 6–25 f | Gestures 8–20 f (0.27–0.67 s); camera push 10–25 f; eye roll 6–12 f. |
| `peak_offset_eased` | mid-move | 45–55% of the move | For `sine.inOut` / `power2.inOut` motion, where velocity peaks in the middle. |
| `peak_offset_fast_out` | 20% of the move | 12–28% | For `power3.out` / `power4.out` motion, where velocity peaks near the start. Put the peak where the *acceleration* is, not at the geometric midpoint. |
| `peak_tolerance` | ±1 f | ±0–2 f | Align by the waveform's peak, never by the file's start. |
| `pitch` | 0 st | −4 to +4 st | Lower = heavier, more cinematic; higher = lighter, faster, more energetic. |
| `reverb_wet` | 0.12 | 0.06–0.20 | Enough that it exists in the room, not enough to hear as an effect. |
| `density` | 12 /min | 8–20 /min | Above 30 /min is the overload failure. |
| `unique_files` | 2 | 1–3 | One or two air textures, varied by pitch and duration. |
| `min_gap` | 45 f (1.5 s) | 30–90 f | Minimum spacing between two aesthetic accents. |
| `suppressed_windows` | emphasis drops, riser builds | — | No aesthetic air during a music drop or under a riser — it undoes both. |

## Reproduction prompt

```
Run the aesthetic air pass. Do this AFTER the motion-sound pass is complete
and the mix is otherwise balanced.

1. LIST THE CANDIDATES. Walk the timeline and log every small movement that
   the motion pass did NOT sound because nothing demanded it: a hand or arm
   crossing frame, a lean toward or away from camera, a head or shoulder
   turn, a shrug, an eye roll, a camera push-in or pull-out, a Ken Burns
   drift, a parallax slide. For each, record start frame, end frame, and
   direction.
2. BUDGET. Keep at most 12 accents per minute (hard ceiling 20), with a
   minimum gap of 45 frames (1.5s) between accents. If the candidate list
   exceeds the budget, keep the moves that are (a) toward camera, (b) fastest,
   (c) on a line that matters. Drop the rest - do not shorten the gap.
3. SUPPRESS WINDOWS. Remove every candidate that falls inside an emphasis
   music drop, inside a riser build, or during a deliberate silence. Air
   inside those windows destroys the effect they exist for.
4. CHOOSE ONE OR TWO AIR TEXTURES for the whole video - soft, tonal-free
   air whooshes - and vary them per accent with pitch (-4 to +4 semitones)
   and duration. Do not use a different library file per accent.
5. SHAPE EACH ACCENT: high-pass at 1200Hz (range 800-2000), optional
   low-pass at 14kHz, reverb wet ~0.12, and set the level 21 dB below the
   dialogue RMS - about -24 dBFS with dialogue at -10.
6. MATCH LENGTH TO THE MOVE. The accent's duration equals the movement's
   duration, achieved by trimming or by a constant rate change - not by
   fading a long file.
7. PLACE THE PEAK, NOT THE START. Align the accent so its waveform PEAK
   sits where the movement's acceleration peaks:
     - motion eased at both ends (sine.inOut, power2.inOut): peak at the
       MIDDLE of the move;
     - motion with a fast start and long tail (power3.out, power4.out):
       peak at ~20% of the move's duration;
     - a hard-cut push with no ease: peak on the first frame.
   Tolerance is 1 frame.
8. ACCEPTANCE TEST: (a) play the video once at normal level - you must NOT
   be able to name where the air sounds are; (b) mute the pass and play the
   same minute - it must feel flatter; (c) high-band trace shows accents
   with no low-band counterpart; (d) accents per minute <= 20 and every gap
   >= 30 frames; (e) no accent falls inside a music drop or riser;
   (f) measured level is 18-24 dB below dialogue.
```

## Execution spec

**HyperFrames (primary).** Each accent is a tiny `<audio>` clip with a filter chain, in its own group, on a high track index. The critical mechanic is stated plainly in the contract: **there is no audio-follows-animation attribute** — *"The two are coupled by the author writing the same number twice: the tween's timeline position and the `<audio data-start>`."*

```html
<!-- camera push on #hero from 62.40s over 0.50s with power3.out.
     Velocity peaks at ~20% => 62.50. Air file peaks 0.06s in => data-start 62.44. -->
<audio id="air-push-01" src="assets/sfx/air-soft-a.wav"
       data-audio-group="air"
       data-start="62.44" data-duration="0.50" data-media-start="0.00"
       data-track-index="16" data-volume="0.055"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
        {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Make It Air&quot;,&quot;params&quot;:{&quot;frequency&quot;:1200,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
        {&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;frequency&quot;:14000,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
        {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;label&quot;:&quot;Small Room&quot;,&quot;params&quot;:{&quot;size&quot;:0.35,&quot;damping&quot;:0.6,&quot;wet&quot;:0.12,&quot;dry&quot;:0.95}}]}"></audio>
```
```js
// the move this accent belongs to - same number, written twice
tl.to("#hero", { scale: 1.06, duration: 0.50, ease: "power3.out" }, 62.40);
```

Contract facts that decide whether this works:
- **`data-volume="0.055"`** is roughly −25 dB of static gain (`0.055 ≈ 10^(-25/20)`). Default is `1` (0 dB); the ceiling is `3.98` (+12 dB). Author the level as a gain number, and do not also GSAP-tween `volume` — the lane/tween precedence rules will surprise you (`audio_volume_double_automation`, `audio_volume_tween_overrides_gain`).
- **Every `<audio>` needs an `id`.** Forty accents means forty unique ids; a missing one is silently never mixed.
- Accents rarely overlap, but if two do they need **different `data-track-index`** values (`duplicate_audio_track`).
- **Group them all** as `data-audio-group="air"` and give the group a real `<hf-audio-group>` bus once there are more than a handful — *"one chain, one fader, one automation clock for every member"*. That is how you audition or trim the entire pass by one number:
  ```html
  <hf-audio-group id="air" data-label="Aesthetic air" data-volume="1.0"
    data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;g1&quot;,&quot;params&quot;:{&quot;frequency&quot;:1200}}]}"></hf-audio-group>
  ```
  Put the high-pass on the **bus** rather than on forty clips; keep per-clip chains for genuinely per-clip problems. On a bus, automation `t` is **composition time**, not clip-local. `data-hidden` on the group drops the whole pass from the mix — the fastest possible A/B of "with air" versus "without".
- **Never put the air group inside `voiceover`.** The carve group must contain voices only; an SFX clip in it poisons the *next* carve analysis silently.
- **`reverb`'s `size`/`damping` are not automatable** (they regenerate the impulse); `wet`/`dry` are. Also note a reverb tail makes the rendered track **longer** than `data-duration` (`chainTailSeconds`) — expected, not a bug, and it is part of why the accent sits in the room.
- **Sub-composition offset math.** If the move is animated inside a sub-comp at scene-local `t`, the accent at the root needs `data-start = t + the slot's data-start`. Audio always lives at the host root so it survives scene cuts.
- **Nothing validates an FX chain.** Render refuses an unparseable chain; preview plays it **dry**. A pass that sounds correct in preview and shrill in render is exactly this failure — verify by rendering, and remember the render must run on a browser-capable host, not the ARM64 device VM.

**ffmpeg.** Making the textures, and verifying the pass:
```bash
# turn one air recording into the pass's two working textures
ffmpeg -i air-raw.wav -af "highpass=f=1200,lowpass=f=14000,volume=-6dB" assets/sfx/air-soft-a.wav
ffmpeg -i air-raw.wav -af "asetrate=48000*1.19,aresample=48000,highpass=f=1400" assets/sfx/air-soft-b.wav  # +3 st, lighter
# verify the pass is high-band only and at the right level
ffmpeg -i final.mp4 -af "highpass=f=1200,astats=metadata=1" -f null - 2>&1 | grep RMS_level
ffmpeg -i final.mp4 -af "lowpass=f=250,astats=metadata=1"  -f null - 2>&1 | grep RMS_level
```
In-composition, duration matching is `data-playback-rate` (constant, `0.1..5`, **pitch-preserved** — so it changes length without changing pitch) plus `data-media-start`/`data-duration`. Pitch shifting must be preprocessed: there is no pitch parameter in the FX registry.

**Epidemic Sound.** Fetch one or two textures, not forty:
- `SearchSoundEffects { query.term: "soft air whoosh subtle short" }`
- `SearchSoundEffects { query.term: "air movement pass by gentle" }`
- `SearchSimilarToSoundEffect` against the chosen file to get its sibling for variation.
Avoid anything tonal, pitched, or with a designed impact — a whoosh with a musical note in it will be noticed on the third use. Download into `assets/sfx/`, then place as above; optionally ledger with `resolve.mjs --from <file> --type sfx --project .`

**Remotion:** conceptually one `<Audio>` per accent with a volume constant, offset to the tween's frame; no Remotion runtime in this project.

## Pairs with
[[sfx-unsounded-motion-audit]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-placement-discipline]] · [[sfx-sound-pass-order]] · [[sfx-ab-audition-candidates]] · [[cut-punch-in-emphasis]] · [[sfx-music-hard-stop]] · [[sfx-ambience-bridge-across-cut]] · [[cut-screen-recording-proof-insert]] · [[motion-look-finishing-pass]]

## Failure modes
- **Too loud.** The single failure that turns polish into an effects reel. If you can name the sound on first listen, it is not aesthetic any more. Fix: −18 to −24 dB relative to dialogue, and re-check inside the full mix.
- **Low end left in.** Air with its bass intact competes with the voice's Weight band and the bed's low end, and the mix loses clarity without anyone knowing why. Fix: high-pass at 1200 Hz; check the sub-250 Hz trace shows nothing at the accent.
- **Peak on the file's start.** The accent feels late by however long the file's attack is. Fix: align by waveform peak, and put that peak where the *acceleration* is — mid-move for eased-both-ends motion, ~20% in for a `power3.out` push.
- **Length not matched.** A 1.2 s whoosh on a 0.4 s gesture leaves a tail hanging over the next line. Fix: trim or rate-change to the move's duration; do not fade a long file.
- **Overload.** A tick every other second tires the viewer's brain within two or three minutes — the source names this as mistake number one. Fix: budget 8–20 per minute, minimum 45-frame gaps, and cut candidates rather than closing gaps.
- **Air inside a silence or a riser.** It undoes the exact effect that window was built for. Fix: suppress the pass across those windows entirely.
- **Fifteen different library files.** The pass stops reading as a system and starts reading as randomness. Fix: one or two textures, varied by pitch and duration.
- **Dry and pasted-on.** Studio-clean air over live-recorded footage sits outside the room. Fix: `reverb` wet ≈ 0.12 on the bus.
- **Running it before the motion pass.** You end up sounding moves that needed a real motion effect, quietly — so they are both under-sounded and cluttered. Fix: motion pass first, aesthetic pass last.
- **Known gap:** no published source specifies a level or filter frequency for sub-noticed aesthetic accents. The −18 to −24 dB window here is derived by placing the layer between two documented anchors — the SFX layer at −12 to −15 dB and a room-tone floor around −30 dBFS — and the 800–2000 Hz high-pass follows the sound-design principle that "air" is made by removing bass, not by adding treble. Log the measured values from any reference you are matching and prefer them over these defaults.
