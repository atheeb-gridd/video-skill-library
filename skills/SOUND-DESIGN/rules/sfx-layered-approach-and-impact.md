---
id: sfx-layered-approach-and-impact
title: An impact is a compound — approach, contact, and the sub, tail and settle under them
skill: sound-design
type: sfx
family: impact
tags: [skill/sound-design, type/sfx, family/impact, sfx/motion, layer/sfx, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:10"
    quote: "Either by changing the speed, or by layering multiple sound effects."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:14"
    quote: "Now the peak of my hit sound effect should land exactly on the impact frame of my hand."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:26"
    quote: "So to show the movement while the hand is coming down, we can add a whoosh."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:31"
    quote: "You can also add reverb in between to give it more impact."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:06:27
    quote: "you can also layer a bass drop with this impact sound."
research_refs:
  - https://en.wikipedia.org/wiki/Sound_effect
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Precedence_effect
  - https://en.wikipedia.org/wiki/Doppler_effect
  - https://en.wikipedia.org/wiki/Transient_(acoustics)
  - https://pixflow.net/blog/cinematic-whoosh-sound-effects/
  - https://blog.prosoundeffects.com/sound-editing-in-sync-tutorial
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (swooshes--whoosh / designed--impact / designed--boom probed live, 2026-08-28)
difficulty: high
detectable_from: audio
---

# An impact is a compound — approach, contact, and the sub, tail and settle under them

## What it is
A single hit file on a single frame is a sound. An **impact** is a small piece of construction: the sound of something travelling, resolving into the sound of it arriving, with weight underneath and a room around it. The source builds it in two moves — the hit's peak lands *"exactly on the impact frame"*, and then *"to show the movement while the hand is coming down, we can add a whoosh"* — and then names the further pieces: reverb *"in between"*, and *"you can also layer a bass drop with this impact sound."* Approach, then contact. This is why a single "punch" asset dropped on the contact frame always sounds thinner than it should: the contact is there, but nothing got there.

The layers, in signal and time order. **The first two are mandatory; the rest are earned:**

1. **Approach** — a whoosh or swish covering the travel. Mid-weighted (roughly 1–8 kHz), length matched to the *visible* travel. It is the only layer with real duration; it makes the impact feel *caused*.
2. **Contact (the transient)** — the hit itself. Loudest, shortest, and the only layer whose peak is frame-critical.
3. **Sub** *(optional)* — a low-passed boom or bass drop on the same frame, supplying weight the contact file lacks. Felt rather than heard; it supplies weight without supplying loudness.
4. **Tail** *(optional)* — the room, the debris, the ring-out. It is what stops the impact sounding like a click in a vacuum.
5. **Settle / debris** *(optional, diegetic only)* — the object's aftermath 4–12 frames later: a rattle, a body shift, a cloth rustle. Its presence is the difference between a hit and an event.

**On layers 4 and 5 — the source's *"reverb in between"* supports two readings and this note keeps both**, because they are different objects rather than rival interpretations. Read as *room*, it is the **tail**: a decaying ring-out that places the impact somewhere. Read as *join*, it is a short reverb on the **approach only**, so the sweep blooms rather than stops and the transient lands inside that bloom. Do both on a hero hit. Reverb on the *contact* layer does neither — it smears the attack, which is the one thing an impact cannot afford.

**The one non-obvious number is where the approach peaks**, and getting it wrong is what makes most home-made compounds feel soft. It is tempting to align the whoosh's loudest frame with the hit — that is the correct move for a *riser* into a hit ([[sfx-riser-hit-pair]]), because a riser is a build whose climax *is* the payoff. An approach whoosh is different: it represents **velocity**, and velocity is maximal just *before* contact and zero at it. Align the whoosh's peak with the transient and you get simultaneous masking — a loud broadband sweep raises the threshold at which the hit's attack becomes audible, and the punch you paid for is partly hidden by the sound you added to set it up. **Put the approach's peak 2–4 frames early and let it decay into the transient.**

The gap must also not be too wide. Two sounds of the same family separated by more than ~50 ms begin to separate into distinct events, so the approach's peak should sit inside roughly **65–150 ms** (2–4½ frames) of the contact: far enough that the transient is the loudest single moment, close enough that the ear binds them into one gesture. Past **5 frames** it reads as a flam.

Scale the build to the visual weight, not to enthusiasm. Small impacts use two layers. Big ones use four. A diegetic contact can carry a fifth — the settle — because it is a different *kind* of sound rather than another layer of the same hit; a non-diegetic graphic slam has nothing to settle and stops at four.

## When to use it
Whenever something on screen **travels and then stops**: a hand coming down, a card slamming into place, a title arriving from off-frame, a punch-in landing, a door slamming, a book dropping, a phone hitting a table, a scene wiping to a hard stop, a logo locking up. If the eye sees something arrive, the ear wants both halves.

- **Any full-frame motion-graphic slam** — a title snapping to position, a card landing, a bar hitting its final value. Here every layer is non-diegetic and the compound is pure design ([[sfx-three-types-classification]]).
- **Whenever an existing impact "feels thin".** The diagnosis is almost always a missing approach layer, or a missing sub, not a quiet hit.
- **When the travel is visible for ≥6 frames (0.2 s).** Under that there is not enough travel to sound: use the contact layer alone. The tell that you need the approach layer is that the travel is *visible* — if the element simply appears, an approach whoosh has nothing to describe and is the classic "whoosh on everything" error ([[motion-instant-appearance-sfx-justified]]).
- **Not on a cut.** A cut has no approach. A cut takes a single sound with its peak *on* the cut frame ([[sfx-peak-on-the-cut]]).
- **Not when the object is small and light.** A pen landing has no approach worth hearing; adding one reads as parody.

Scale the build:

- **Micro** (a 12-frame card settling, a caption arriving): approach + contact only, quiet. Often just a soft swish.
- **Medium** (a title slam, a scene transition, a punch-in): approach + contact + tail.
- **Large** (the video's one big reveal, a smash cut, a full-frame slam): all four, plus the settle if the event is diegetic.

Use the large build **two to four times in ten minutes**, maximum, and not on every impact in a fight or montage sequence — the rest take contact-only, or the sequence turns to mush. A film that hits full weight every thirty seconds has no weight at all.

## How to recognise it in a reference video
- **Look at the waveform shape, not the peak.** Trace per-frame RMS (`n=1600` at 48 kHz is exactly one frame at 30 fps):
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
   ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  A compound reads as **6–24 frames of rising broadband energy (0.3–0.6 s), a local maximum, a 2–4 frame decline, then a ≥8 dB single-frame jump**, followed by a decay of 0.8–2.5 s. A single-file impact has no rise at all — it starts at its transient, a bare vertical spike with silence either side.
- **Measure the peak-to-transient gap in frames.** 2–4 frames (66–133 ms) is a designed compound. **0 frames** means the approach is masking the contact — audible as a soft punch. **>5 frames** reads as two events (a flam).
- **Check the spectrogram at the contact frame.** Layers separate by band: the approach is a bright wedge concentrated 1–8 kHz, living above ~300 Hz and often sweeping upward; the contact occupies 200 Hz–4 kHz and adds **30–120 Hz** in a single frame; the sub is a discrete blob at **40–80 Hz** appearing *at* contact and absent before it; the tail is broadband and decaying. Three or four distinguishable bands means construction. A compound with no low-frequency arrival at the transient has no sub layer and will feel small on a phone speaker.
- **Listen for Doppler shape.** An approach that rises in pitch into contact and (if the object passes) falls after it is the physically-correct form — approaching sources read higher, receding lower.
- **Contact vs picture.** Step to the frame where the two objects first touch. In a competent mix the transient's first frame is **that frame or one after it** — never before. Log the offset; a diegetic impact that leads the picture reads as broken, whereas a motion sweep leading by 4 frames reads as anticipation.
- **Approach length vs visible travel.** Measure the frames from the object entering frame (or starting to move) to contact, and compare with the audible sweep's length. They should match within **±20 %**. A 0.4 s whoosh under a 1.2 s arm swing leaves two thirds of the move silent.
- **Sub check.** High-pass the reference at 100 Hz and A/B it. If the impact loses most of its weight but very little of its brightness, there is a real sub layer.
- **Reverb asymmetry.** Listen for a tail on the sweep and none on the transient. If the transient has a long tail, it is one file doing both jobs. Look also for reverb that is present on the impact but **not** on the dialogue around it — a tail that exists only for this event is a design decision, not the room.
- **Settle layer.** Something small **4–12 frames after** the transient — a rattle, a cloth movement, a secondary object.
- **Density.** Count full compounds per minute: **1–3/min** is design; above 6/min the sequence is a mush of sweeps. Count *four-layer* builds separately: more than about four full-weight impacts in ten minutes and the technique has been spent.
- **Level.** The composite should still measure in the **−12 to −15 dB** effects band against dialogue at 0 to −3 dB. Layered impacts that hit −6 dB are a mix error, not a big moment.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `T_CONTACT` | the frame the objects first touch | — | Step it; do not infer it from the motion's midpoint. |
| `layers` | 2 | 2–4, or 5 diegetic | Micro = 2, medium = 3, large = 4. A fifth is the diegetic *settle* only — never a fifth layer of the hit itself. |
| `approach_length` | 0.50 s | 0.20–1.20 s | Match the **visible travel** within ±20 %. Typical designed range 0.30–0.60 s. |
| `approach_start` | `T_CONTACT − approach_length + 0.05` | — | Its tail should still be decaying at contact, not finished. |
| `approach_end` | contact frame | −2 to +1 f | The sweep terminates *at* the hit, not through it. |
| `approach_peak_offset` | **−3 f (−0.100 s)** | −2 to −4½ f (−67 to −150 ms) | Before the transient, never on it. 0 f masks the attack; >5 f is a flam. |
| `approach_gain` | −15 to −17 dB (`data-volume` 0.141–0.178) | −19 to −12 dB | Always 3–6 dB below the contact. It is the setup, not the event. |
| `approach_highpass` | 250–300 Hz | 180–500 Hz | Keeps the sweep out of the sub's band so both survive. A general whoosh clean-up high-pass sits at 80–100 Hz; push it higher when a sub layer is present. |
| `approach_reverb` | `wet` 0.20, `size` 0.5, `damping` 0.5 | wet 0.10–0.30 | The *join* reading of *"reverb in between"*. **Approach only.** |
| `approach_pitch_shape` | rising | rising / rise-fall | Rise into contact; add the fall only if the object passes rather than stops. |
| `contact_offset` | **0 f** on `T_CONTACT` | 0 to +1 f (±½ f tolerance) | The one frame-critical number. Diegetic rule: on the frame or one late, **never early**. Keep transients within a half to a quarter frame of each other to avoid flam. |
| `contact_attack` | <10 ms | 2–20 ms | This is what "hit" means. |
| `contact_gain` (metering the layer) | −10 dB (`data-volume` 0.316) | −13 to −7 dB | Use when you are budgeting the loudest layer. The loudest single element of the compound. |
| `contact_gain` (metering the sum) | −12 dB (`data-volume` 0.251) | −11 to −14 dB | Use when you are budgeting `composite_level` below — the layers must sit lower so their sum lands in the effects band. **Pick one convention per project and state it; the two are not interchangeable.** |
| `contact_length` | 1.2 s | 0.4–3.0 s | Chosen on the **tail**, not the attack. Fade the last 0.3 s. Body excluding tail is 0.10–0.40 s. |
| `contact_reverb` | **none** | — | Smears the attack. Room glue, if any, goes on the bus at `wet` ≤ 0.10. |
| `sub_offset` | **0 f**, same frame as contact | 0 to +1 f | Never before contact — an early sub is heard as a mistake, and two sub transients 100 ms apart is mud. |
| `sub_frequency` | 55 Hz | 40–80 Hz | A short pitch-dropping sine is the classic. |
| `sub_gain` | −13 to −16 dB (0.158–0.224) | −18 to −10 dB | Felt, not heard. Check on a phone speaker: it should be inaudible there and still work. |
| `sub_lowpass` | 140 Hz, `poles: 2` | 90–200 Hz | Pure weight; nothing above should survive. |
| `sub_decay` | 0.5 s | 0.30–0.80 s | Longer reads as a rumble, not an impact. |
| `tail_length` | 1.4 s | 0.8–2.5 s | The *room* reading of *"reverb in between"*. Must not outlast the shot. |
| `tail_gain` | −20 dB (0.1) | −24 to −18 dB | |
| `settle_offset` | +8 f (+0.267 s) | +4 to +12 f | The aftermath. Small, late, quiet. Diegetic events only. |
| `settle_gain` | −20 dB (0.1) | −24 to −18 dB | Below the aesthetic tier; it is texture. |
| `composite_level` | −13 dB | −12 to −15 dB | Measure the **sum**, not the layers. Limiter last on the bus, `limit` −1 dB. |
| `compounds_per_min` | 2 | 1–3 (ceiling 6) | Any 2+-layer compound. Above 6/min the sequence loses all articulation. |
| `large_builds_per_10_min` | 3 | 2–4 | Four-layer full-weight builds only. |
| `bed_duck` | none | 0 to −4 dB | An impact is short enough not to need room. Duck only for a hero hit. |
| `sync_error_direction` | late | 0 to +1 f | Never early: sound leading picture is detected from about 45 ms; lagging only from about 125 ms. |

## Reproduction prompt
```
Build a layered impact resolving at {{T_CONTACT}} (composition seconds).
30 fps: 1 frame = 0.0333 s. TWO layers minimum, four at most - five only if the
event is diegetic and the fifth is the settle.

1. FIX TWO NUMBERS BY STEPPING FRAMES.
   T_CONTACT   = the frame the two objects first touch.
   TRAVEL_LEN  = seconds from the object starting to move (or entering frame) to
                 T_CONTACT. If TRAVEL_LEN < 0.2 s, SKIP the approach layer and
                 place the contact alone - there is not enough travel to sound.
   Also decide the METERING CONVENTION now: are you budgeting the SUM to
   -12/-15 dB, or the loudest LAYER to -10 dB? Write it down. Every gain below
   depends on it and the two conventions are not interchangeable.

2. FETCH THE APPROACH. SearchSoundEffects, filter.tagSlugs ALL
   ["swooshes--whoosh"], duration 300-3000 ms, term "fast air short" (or
   "wind heavy" for a weighted object). Pick on LENGTH first: within +-20% of
   TRAVEL_LEN. Prefer titles containing "Dry". Download WAV.

3. FETCH THE CONTACT. tagSlugs ALL ["designed--impact"], duration 500-4000 ms,
   term "hit dry short" for a real-object contact, or "cinematic impact heavy"
   for a graphic slam. Choose on the TAIL, not the attack - every file in this
   shelf has an attack. Download WAV.

4. MEASURE BOTH PEAK OFFSETS with a per-frame peak trace. Never assume the
   whoosh peaks at its end or the impact at its start. Record WHOOSH_PEAK,
   HIT_PEAK.

5. PLACE. Different data-track-index values - they overlap.
     approach: data-start = T_CONTACT - 0.100 - WHOOSH_PEAK
               data-media-start = 0
               data-duration = min(TRAVEL_LEN, 1.2) , data-volume = 0.178
               -> this puts the approach's PEAK 3 frames BEFORE T_CONTACT.
     contact:  data-start = T_CONTACT
               data-media-start = HIT_PEAK
               data-duration = 1.2 , data-volume = 0.316 (layer convention)
                                              or 0.251 (sum convention)
   Equivalently for the contact: start the clip at T_CONTACT - HIT_PEAK with
   data-media-start = 0. Do one or the other, never both.
   The 3-frame gap is deliberate. Aligning the approach peak WITH the transient
   masks the attack and the punch goes soft. Aligning it more than 5 frames
   early splits the compound into two audible events.

6. SHAPE THE JOIN. On the approach only: reverb node, size 0.5, damping 0.5,
   wet 0.20, dry 1.0, plus highpass 250 Hz. NO reverb on the contact - it
   smears the attack. Volume lane on the approach: t=0 v=0.35,
   t=(len-0.10) v=1.0, t=len v=0.25 so it decays INTO the transient rather
   than stopping at it. If the object PASSES rather than stops, use a
   rise-then-fall pitch shape; if it stops, rising only.

7. OPTIONAL SUB (large impacts). If the contact sounds thin below 120 Hz, add
   one designed--boom at the SAME data-start as the contact (0 offset, not
   offset), data-volume 0.224, lowpass 140 Hz poles 2, decaying over ~0.5 s.
   Never start it before contact.

8. OPTIONAL TAIL (medium and large). Either a reverb send on the contact bus
   (1.4 s decay) or a separate ring-out / debris texture starting at
   T_CONTACT, data-volume 0.1. Cap it at the remaining shot length.

9. OPTIONAL SETTLE (diegetic events only). One small diegetic sound 8 frames
   after T_CONTACT at data-volume 0.1 - a rattle, cloth, a secondary object.

10. MIX. Put every layer on one bus with a limiter last (limit -1 dB). Under
    the SUM convention the layers must total -12/-15 dB against dialogue at
    0/-3 dB - the same target a single effect would have had. Do not raise the
    whole build to make the moment bigger; make the approach longer and the sub
    deeper instead.

CONSTRAINTS: at most 3 full four-layer builds per 10 minutes, and at most
1-3 compounds per minute overall. If the element does not visibly travel for
6+ frames, delete the approach - a whoosh on an instant appearance is the
commonest amateur tell.

ACCEPTANCE TEST.
(a) Per-frame trace: rise, local max, 2-4 frames of decline, then the
    single-frame jump. If the max and the jump are the same frame, move the
    APPROACH earlier - never move the contact.
(b) Solo approach + contact: the sweep must already be falling when the hit
    lands.
(c) The contact's first frame is T_CONTACT or one after. Never before, and no
    second attack 10-60 ms away from it.
(d) The audible sweep length is within 20% of TRAVEL_LEN.
(e) High-pass the bus at 100 Hz: it must lose weight but stay legible, proving
    the sub adds weight rather than carrying the sound.
(f) Play on a laptop or phone speaker: it must still read as an impact with no
    sub audible at all.
(g) Mute the approach: the impact should get noticeably smaller, not cleaner.
    If it gets cleaner, the approach is too loud or overlapping the transient.
(h) Measure the composite against your declared convention.
(i) The contact's last 0.3 s fades rather than stopping, and the tail does not
    outlast the shot.
```

## Execution spec

**Placement spec (the three numbers, per layer).**

| | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Approach (whoosh) | **peak −3 f**; body starts `TRAVEL_LEN` early | −15 to −17 dB (`data-volume` 0.141–0.178) | none |
| Contact (hit) | **0 f** on `T_CONTACT`, 0 to +1 f | −10 dB (0.316) layer / −12 dB (0.251) sum | none (bed −4 dB for a hero hit only) |
| Sub (boom) | **0 f**, same frame as contact | −13 to −16 dB (0.158–0.224) | none |
| Tail (ring-out) | **0 f**, decaying 0.8–2.5 s | −20 dB (0.1) | none |
| Settle | **+8 f** | −20 dB (0.1) | none |

**HyperFrames — clips on their own track indices, one bus, reverb on the approach only.** The group is what lets a limiter act on the sum rather than on each layer.

```html
<hf-audio-group id="impact-01" data-label="Impact 01" data-volume="1"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n9&quot;,&quot;label&quot;:&quot;Ceiling&quot;,&quot;params&quot;:{&quot;limit&quot;:-1,&quot;attack&quot;:5,&quot;release&quot;:50}}]}"></hf-audio-group>

<!-- hand lands at 27.400 s; visible travel 0.53 s; whoosh peak measured at 0.31 s -->
<audio id="imp-approach" src="assets/sfx/whoosh-air.wav"
       data-audio-group="impact-01" data-track-index="13"
       data-start="26.990" data-duration="0.530" data-media-start="0"
       data-volume="0.178"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;a1&quot;,&quot;label&quot;:&quot;Clear the Sub&quot;,&quot;params&quot;:{&quot;frequency&quot;:250,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;a2&quot;,&quot;label&quot;:&quot;Bloom Into The Hit&quot;,&quot;params&quot;:{&quot;size&quot;:0.5,&quot;damping&quot;:0.5,&quot;wet&quot;:0.2,&quot;dry&quot;:1}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.35},{&quot;t&quot;:0.43,&quot;v&quot;:1},{&quot;t&quot;:0.53,&quot;v&quot;:0.25}]}]}"></audio>

<audio id="imp-contact" src="assets/sfx/impact-dry.wav"
       data-audio-group="impact-01" data-track-index="14"
       data-start="27.400" data-duration="1.200" data-media-start="0.048"
       data-volume="0.316"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.9,&quot;v&quot;:1},{&quot;t&quot;:1.2,&quot;v&quot;:0}]}]}"></audio>

<audio id="imp-sub" src="assets/sfx/boom-low.wav"
       data-audio-group="impact-01" data-track-index="15"
       data-start="27.400" data-duration="1.600" data-media-start="0.020"
       data-volume="0.224"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;s1&quot;,&quot;label&quot;:&quot;Weight Only&quot;,&quot;params&quot;:{&quot;frequency&quot;:140,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"></audio>

<audio id="imp-tail" src="assets/sfx/tail-ring.wav"
       data-audio-group="impact-01" data-track-index="16"
       data-start="27.400" data-duration="1.400" data-volume="0.10"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:1.4,&quot;v&quot;:0}]}]}"></audio>

<audio id="imp-settle" src="assets/sfx/cloth-shift.wav"
       data-audio-group="impact-01" data-track-index="17"
       data-start="27.667" data-duration="0.700" data-media-start="0.110"
       data-volume="0.1"></audio>
```

The arithmetic and the traps:
- **`26.990 + 0.310 = 27.300 = 27.400 − 0.100`** — the approach's *measured* peak lands exactly 3 frames before the contact. That identity is the compound. If your whoosh file's peak is elsewhere, recompute `data-start = T_CONTACT − 0.100 − WHOOSH_PEAK`.
- **The contact's `data-start` is `T_CONTACT − transient_offset_in_file`**, or `T_CONTACT` with the pre-roll trimmed by `data-media-start`. Do one or the other, never both.
- **Every overlapping clip needs its own `data-track-index`**, or `duplicate_audio_track` fires.
- **Every `<audio>` needs an `id`** — an id-less one is *never mixed → silent render* (lint error `media_missing_id`).
- **All authored time is seconds.** There is no frame attribute; −3 frames is `−0.100` and the frame count belongs in a comment.
- **`data-volume` is linear**, default `1` = 0 dB, max `3.98` = +12 dB: −10 dB ≈ 0.316, −12 dB ≈ 0.251, −16 dB ≈ 0.158, −20 dB ≈ 0.10.
- **Use a bus, not one limiter per clip.** *"One chain, one fader, one automation clock for every member"* — and a compressor or limiter cannot ride a sequence it only hears a quarter of. Note a bus's automation `t` is **composition time**, while a clip's is clip-local.
- **`highpass` defaults to 300 Hz and `lowpass` to 8000 Hz** — both are written explicitly here because the defaults would undo the band split that lets the sweep and the sub coexist.
- **`reverb`'s `size` and `damping` regenerate the impulse and are not automatable**; only `wet`/`dry` automate. `reverb` and `delay` extend the rendered track past `data-duration` via `chainTailSeconds` — expected behaviour, not a bug, and on the approach it is the point.
- **`compressor`, `limiter`, `gate` and `bitcrush` have zero automatable parameters** (AudioWorklets configured wholesale), so a dynamic join cannot be shaped with a compressor envelope in-composition. Shape it with the `volume` lane, or bake it. Automate a `gain` stage around them.
- **Do not pair a `volume` lane with a GSAP `volume` tween** on the same clip (`audio_volume_double_automation` — the lane wins silently).
- **`data-fx-carve` is clip-only and belongs on a music bed, never on an SFX clip or a bus** (`audio_carve_ungrouped_sources`, `audio_group_carve_attr`). Keep the impact group out of the voice carve group entirely — a non-voice member silently poisons the next carve re-analysis.
- **JSON attributes must be double-quoted with `&quot;`** — `carve.mjs` finds them with a `name="..."` regex and cannot see single-quoted attributes, so it will overwrite work it did not read.
- **Chain order is signal order:** subtract before you add, level after you filter, character and ceiling last.
- **There is no audio-follows-animation attribute.** For a motion-graphic slam, `T_CONTACT` gets written twice: once as the GSAP tween's resolved-position time, once as `data-start`. If the graphic lives in a sub-composition, the root audio needs `data-start = scene-local t + the slot's data-start`.
- **Sound the picture event, not the file.** The motion's peak position comes from its easing curve — see [[sfx-envelope-matched-to-easing-curve]] — and for a travel-then-stop move the ease is normally an in-family curve, which puts the visual velocity maximum at the very end, exactly where the transient goes.

**Epidemic Sound — the shelves, all verified live 2026-08-28.** Tag-first; an unknown slug fails closed at `meta.total: 0`.

```
# APPROACH
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["swooshes--whoosh"] },
                               duration: { min: 300, max: 3000 } },
                     query: { term: "fast air short" },
                     sort: { by: POPULARITY, order: DESCENDING }, first: 12 }
# observed titles: "Swooshes, Whoosh, Harsh, Sharps" (1.36 s) · "Short, Car, Fast,
# Dry" (1.07 s) · "Designed, Generic, Air" (0.55 s) · "Classic, Airy" (3.52 s).
# The word "Dry" in a title matters here - a wet whoosh fights the reverb you add.

# CONTACT
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["designed--impact"] },
                               duration: { min: 500, max: 4000 } },
                     query: { term: "punch hit body dry" }, first: 10 }
# verified: that exact filter returns 91 effects. Observed: "Cinematic Impact, Heavy,
# Dry x2" (2.42 s) · "Cinematic Impact, Hard, Metallic, Dry x2" (3.93 s) ·
# "Distorted Hit" (3.38 s). "x2" means the file contains TWO takes - trim one.

# SUB
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["designed--boom"] },
                               duration: { min: 1000, max: 8000 } },
                     query: { term: "deep low sub" }, first: 8 }

# TAIL
SearchSoundEffects { query: { term: "impact tail debris ring out" },
                     filter: { duration: { min: 1000 } } }

# SETTLE - diegetic, from the object's own family
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["footsteps--human"] },
                               duration: { min: 500, max: 8000 } }, first: 8 }
```
Prefer titles containing **"Dry"** for both approach and contact — you are supplying the space yourself, and a file that already carries a room will fight the reverb on the approach and smear the transient on the contact. Matched approach/contact sets are usually found by running `SearchSimilarToSoundEffect` on the chosen transient — a whoosh from the same library pack shares the tonal colour, which is what makes two files sound like one event; it is also how you build the variant set for repeated impacts ([[sfx-variation-set-generator]]). Always `DownloadSoundEffect` with `{"fileType":"WAV"}` — impacts are the worst thing to pitch-shift or filter from a lossy source.

**ffmpeg — measurement, the sub layer, and the shaping moves the composition cannot make.**
```bash
# peak offset inside each layer (n=1600 = exactly one frame at 30 fps)
for f in whoosh-air.wav impact-dry.wav boom-low.wav; do echo "== $f"; \
ffmpeg -i "$f" -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null | head -30; done

# trim one take out of an "x2" impact file
ffmpeg -i impact-x2.wav -ss 0.00 -to 1.15 -c:a pcm_s16le impact-dry.wav

# make a heavier contact: lower pitch = heavier object (no pitch node exists in-comp)
ffmpeg -i impact-dry.wav -af "asetrate=48000*0.8909,aresample=48000" impact-heavy.wav

# synthesise a sub layer when the shelf has nothing: a 55Hz sine dropping away
ffmpeg -f lavfi -i "sine=frequency=55:duration=0.9" \
  -af "afade=t=out:st=0.05:d=0.85,lowpass=f=140,volume=-6dB" sub-55.wav

# offline pre-mix of four layers with a ceiling, for auditioning
ffmpeg -i whoosh.wav -i hit.wav -i sub.wav -i tail.wav \
  -filter_complex "[0]adelay=0|0,volume=-17dB[a];[1]adelay=422|422,volume=-12dB[b];\
                   [2]adelay=450|450,volume=-16dB[c];[3]adelay=450|450,volume=-20dB[d];\
                   [a][b][c][d]amix=inputs=4:normalize=0,alimiter=limit=0.891[out]" \
  -map "[out]" impact-01.wav

# verify the composite level, and the two-part envelope after render
ffmpeg -i impact-01.wav -af "volumedetect" -f null - 2>&1 | grep -E "mean_volume|max_volume"
ffmpeg -i mix.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
```
Bake only for assets leaving the pipeline — inside the composition, keep the layers separate so the balance stays editable.

**Remotion.** One `<Audio>` per layer, whose `from` frames differ by the measured offsets, each with `startFrom` at its own peak. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-riser-hit-pair]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-bass-drop-under-impact]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-swoosh-vs-whoosh]] · [[sfx-peak-at-motion-midpoint]] · [[sfx-peak-offset-measurement]] · [[sfx-length-matched-to-motion]] · [[sfx-diegetic-action-inventory]] · [[sfx-reverb-glue]] · [[sfx-edge-fades-click-free]] · [[sfx-three-types-classification]] · [[sfx-variation-set-generator]] · [[sfx-ui-demo-payoff-sound]] · [[cut-on-action]] · [[motion-explainer-beat-animation]] · [[sfx-peak-on-impact-frame]] · [[sfx-envelope-matched-to-easing-curve]] · [[sfx-riser-to-music-drop-backtiming]] · [[motion-camera-shake-impact]] · [[motion-instant-appearance-sfx-justified]] · [[cut-smash-cut]] · [[sfx-air-on-micro-movement]] · [[sfx-density-fatigue-audit]] · [[sfx-peak-on-the-cut]]

## Failure modes
- **Aligning the approach's peak with the transient.** The commonest error and the reason a layered impact can sound *worse* than a bare one: a loud broadband sweep raises the audibility threshold of the attack underneath it, so the punch is masked by its own setup and the result is louder and smaller. Move the approach 2–4 frames earlier — never move the contact.
- **A gap wider than 5 frames.** Past ~50 ms the two sounds begin to separate into distinct events and the compound reads as a flam.
- **Approach continuing through the impact.** Reads as the object passing when it actually stopped. Terminate the approach at the contact frame.
- **An approach that ends before contact.** The sweep must still be decaying when the transient arrives. One that finishes 3 frames early leaves a hole and the impact sounds detached.
- **Approach on an element that does not travel.** The single most common amateur tell — a whoosh under something that simply appears. Delete the approach; a two-frame appearance wants a tick, not a whoosh.
- **Approach longer than the visible travel.** The ear hears movement the eye cannot see. Match within ±20 %.
- **Reverb on the contact.** Smears the attack, which is the only thing an impact has. Reverb belongs on the approach, where it becomes the bloom the transient lands inside, or on a separate tail clip.
- **Contact leading the picture.** Diegetic sounds land on the frame or one after; only motion sweeps get the −4 frame lead. An early contact reads as broken, not as anticipation.
- **Sub starting before contact, or offset from it.** Heard as a timing error even by listeners who cannot name the layer, and a boom 2–4 frames off the contact produces low-frequency mud rather than weight. Same frame, or no sub.
- **Sub carrying the sound.** Big on studio monitors, absent on a phone. The build must read with the sub muted; the sub only adds weight.
- **No spectral separation.** Approach, contact and sub all occupying 100–500 Hz. High-pass the approach at 250–300 Hz, low-pass the sub at 140 Hz.
- **Mixing the two gain conventions.** Layer gains from the −10 dB convention plus a −13 dB composite target double-counts the headroom and the build comes out thin. Declare one convention per project.
- **Layering to get loud.** Four layers each at −12 dB sums to roughly −6 dB and blows the effects band. Mix the sum to −12/−15 dB and put the limiter on the bus, not on each clip.
- **Every impact fully built.** Weight is relative; if everything is heavy, nothing is. 2–4 large builds per 10 minutes, and above ~6 compounds per minute the sweeps overlap into a wash. Two-layer micro builds everywhere else.
- **Tail longer than the shot.** A 2.5 s ring-out under a 1.2 s shot spills into the next scene and smears the cut. Cap the tail at the remaining shot length, or duck it at the cut.
- **Using a wet library file for either layer.** It arrives with a room that is not the room on screen, and no amount of added reverb removes it.
- **Known gap — no send/return architecture.** Effects are per-clip or per-bus chains in signal order, so a shared reverb "send" is expressed either as a reverb node on the impact bus (which then also processes the dry transient) or as a separate pre-rendered tail file. The tail-as-its-own-clip route in the markup above is the cleaner of the two, and it is a deliberate workaround, not the ideal.
- **Known gap — no pitch node in the FX registry.** Making a contact heavier or lighter must be baked with ffmpeg before placement; it cannot be done or automated in-composition.
- **Known gap — no panner.** An impact travelling in from frame-left cannot be positioned in the stereo field in-composition. Bake the position or accept centre.
