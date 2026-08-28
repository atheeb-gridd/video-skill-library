---
id: sfx-ui-demo-payoff-sound
title: The screen-recording payoff — click, compress the wait, land the reveal
skill: sound-design
type: sfx
family: screen-demo
tags: [skill/sound-design, type/sfx, family/screen-demo, sfx/diegetic, layer/sfx, layer/dialogue, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:39
    quote: "You apply the filter here and boom... Music that will fit my video has arrived."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:33
    quote: "and there I can search for music by BPM."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:06:58
    quote: "if you're putting a sound effect on a cut, place the highest peak of the sound effect on the cut."
research_refs:
  - https://en.wikipedia.org/wiki/Sound_effect
  - https://en.wikipedia.org/wiki/Cutaway_(filmmaking)
  - https://en.wikipedia.org/wiki/Diegesis
  - mcp://Epidemic_sounds/SearchSoundEffects (user-interface--* and computers--* slugs probed live, 2026-08-28)
difficulty: medium
detectable_from: transcript+video
---

# The screen-recording payoff — click, compress the wait, land the reveal

## What it is
Abstract advice becomes credible when you show the software doing it, and the source does exactly that: the BPM-filter claim is proved with a screen recording of the library UI, and the results arriving is **punctuated as a moment** — *"you apply the filter here and boom"* — rather than shown as a passive scroll. That punctuation is a sound-design job, and the beat has a fixed three-part shape:

1. **The action** — the cursor reaches a control and the control changes state. This is **diegetic**: the viewer expects a click, and its absence makes the demo feel like a slideshow of screenshots.
2. **The wait** — the software takes 200 ms or 4 s to respond, and none of it is interesting. It must be compressed, and compressing it leaves an edit that has to be covered.
3. **The payoff** — the result appears. This is where "boom" lives: a **motion** sound on the arrival plus, if the moment earns it, an **aesthetic** transient that makes it feel like a result rather than a repaint.

The commonest failure is doing only part 3. A demo with a reveal sound and no click sound reads as a video *about* software; the click is what makes it read as software being *used*. The second commonest is doing all three at equal weight, which makes a routine filter change sound like a plot point.

There is a hard readability constraint riding underneath all of it. Whatever value the demo is proving — `100–120 BPM` in the source's case — the viewer must actually read it, and a UI value at native scale inside a 1080p frame is usually far too small. That means a **punch-in** on the control, and a **minimum dwell** on screen, and both compete with the compression in part 2. Resolving that competition is most of the craft here.

**Style.** Filed `sfx/diegetic`: the beat is built on the click the viewer expects the interface to make, and without it the demo reads as a slideshow of screenshots. The reveal at the end usually takes an aesthetic hit or sub-drop as well ([[sfx-cinematic-hit-emphasis]], [[sfx-bass-drop-under-impact]]), and any cursor travel between them is a motion cue.

## When to use it
- **Any claim about a tool that has a visible control.** "Filter by BPM", "turn on this setting", "paste it here". The screen recording is the evidence and the sound is what makes it an event.
- **Whenever the transcript contains a punctuation word** — "boom", "and there it is", "done", "just like that". That word is the payoff marker; find its frame and build the beat around it.
- **Whenever a UI action's result is the point** and the process is not. If the process *is* the point (a tutorial the viewer will follow along), do not compress it — slow it down and drop the payoff accent entirely.
- **Not on every click in a long demo.** A five-step workflow gets **one** payoff, at the end. Sonifying five reveals turns the sequence into a slot machine and is the density mistake in miniature ([[sfx-density-fatigue-audit]]).
- **Not when the UI is incidental** — a browser flashing past in B-roll needs no click and no reveal; it is background, and gets nothing or a soft keyboard bed.

## How to recognise it in a reference video
- **Find the state-change frame.** Step frame by frame through the click: the frame where the button's fill, border or checkbox visibly changes is `T_CLICK`. In a well-built beat there is a transient within **±1 frame** of it — measure the offset, that number is the finding.
- **Find the appearance frame.** The first frame on which the result is *present* (not the first frame of its fade) is `T_REVEAL`. Expect a broadband sweep whose **onset is 3–6 frames earlier** and whose peak lands on or 1 frame before `T_REVEAL`.
- **Count the frames between them.** `T_REVEAL − T_CLICK` under **6 frames (0.2 s)** means the wait was removed. Then look for the seam: a hard cut, a speed change, or a whip-pan/blur covering it. An uncovered removal shows as a jump in the cursor position — the cursor teleports.
- **Measure the punch-in.** Compare the UI element's on-screen height before and at the click. Typical **1.4×–2.2×** scale, arriving over 8–16 frames, usually `power2.out`. A demo shot at native scale with no punch-in is the amateur tell.
- **Measure the dwell.** Count frames from the value becoming legible to it leaving the frame or being covered. Under **24 frames (0.8 s)** for a short value, or under **36 frames (1.2 s)** if the viewer must also *find* it, and the evidence does not land — the claim is made but not proved.
- **Cursor treatment.** Look for a highlight ring, a size increase, or a contrasting cursor. Its presence indicates a deliberately-authored demo rather than a raw capture.
- **Audio-track signals.** Three distinct classes in ~1.5 s: a short high transient (click, 0.05–0.2 s, energy above 2 kHz), an optional broadband sweep (0.2–0.6 s), and a lower-centred transient with a tail (0.3–2 s). If all three are the same texture, one asset is doing all three jobs and the beat will read as flat.
- **Transcript alignment.** The punctuation word should end **2–5 frames before** the reveal transient. If they collide, the word masks the accent and the accent muddies the word.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `T_CLICK` | the control's state-change frame | — | Not the frame the cursor arrives; the frame the control changes. |
| `T_REVEAL` | first fully-present frame of the result | — | Not the first frame of its fade-in. |
| Click sound offset | **0 f** | 0 … +1 f | Diegetic: on the frame, never early. |
| Click sound length | 0.12 s | 0.05–0.30 s | Trim with `data-media-start`; library click files often contain several takes. |
| Click gain | −16 dB → `data-volume="0.158"` | −20 … −12 dB | Diegetic hero level. Above −12 dB it stops sounding like a click and starts sounding like an effect. |
| Reveal whoosh onset | **−4 f** (−0.133 s) | −3 … −6 f | Motion tier. Its peak lands on `T_REVEAL`. |
| Reveal whoosh length | 0.5 s | 0.3–0.9 s | Match the length of the appearance animation, not longer. |
| Reveal whoosh gain | −12 dB → `data-volume="0.25"` | −15 … −9 dB | Standard SFX tier. |
| Reveal transient offset | **0 f** on `T_REVEAL` | 0 … −1 f | The "boom". Never late. |
| Reveal transient gain | −11 dB → `data-volume="0.282"` | −14 … −9 dB | Hotter than the tier because it is the accent; still under a full cinematic hit. |
| Payoff accents per demo sequence | 1 | 1 | One per workflow, at the end. Not one per click. |
| Wait compression | remove entirely (hard cut) | 0–100 % | See Execution spec: **there is no rate envelope in this stack**, so a ramp must be preprocessed. |
| Seam cover on the removal | the reveal whoosh itself | — | If the whoosh cannot reach the seam, add a 0.25 s swish on the cut frame. |
| Punch-in scale | 1.6× | 1.4–2.2× | Enough that the value is readable; beyond 2.2× the UI context is lost. |
| Punch-in duration | 12 f (0.4 s) | 8–16 f | `power2.out`. Arrives before the click, not on it. |
| Value dwell (short numeric) | 24 f (0.8 s) | 18–40 f | Minimum time the value must be legible and uncovered. |
| Value dwell (viewer must locate it) | 36 f (1.2 s) | 30–60 f | Add 12 f whenever there is no punch-in or highlight pointing at it. |
| Narration gap before the accent | 3 f (0.1 s) | 2–5 f | The punctuation word ends, *then* the accent lands. |
| Bed duck across the payoff | −4 dB (lane `v` 0.63) | −6 … 0 dB | Brief. Restored 0.3 s after. A full duck oversells a UI change. |

## Reproduction prompt
```
Build the screen-recording payoff beat around {{T_REVEAL}} (composition seconds).
30 fps: 1 frame = 0.0333 s. You will produce THREE sounds, not one.

1. FIND TWO FRAMES BY STEPPING, NOT BY GUESSING.
   T_CLICK  = the frame the control visibly changes state (fill/border/checkbox).
   T_REVEAL = the first frame the result is fully present (not its first fade frame).
   Write both down in seconds.

2. COMPRESS THE WAIT. If T_REVEAL - T_CLICK > 0.2 s, remove the dead time. In this
   stack a speed ramp is NOT available - data-playback-rate is a constant 0.1..5 with
   no envelope - so do it as a hard cut: two clips of the same capture with different
   data-media-start values, back to back (b.start == a.start + a.duration). Keep at
   most 0.2 s of visible wait so the causality still reads.

3. THE CLICK - diegetic, on the frame. Fetch tagSlugs ALL
   ["computers--keyboard-mouse"] (real mouse) or ["user-interface--click"] (designed),
   duration 100-3000 ms. Files often hold several takes: trim to the one you want with
   data-media-start. data-start = T_CLICK, data-duration 0.12, data-volume 0.158.
   Offset 0 frames - NEVER early; an early click reads as a fault.

4. THE REVEAL SWEEP - motion, leading. Fetch tagSlugs ALL ["swooshes--whoosh"],
   duration 300-1500 ms, term "fast short air". Measure its peak, then place so the
   PEAK lands on T_REVEAL:
     data-start = T_REVEAL - 0.133 (4 frames of lead)
     data-media-start = max(0, PEAK - 0.133), data-duration 0.5, data-volume 0.25
   Check it reaches the seam you cut in step 2 - it is also the seam cover.

5. THE PAYOFF TRANSIENT - aesthetic, on the frame, ONE per demo sequence. Fetch
   tagSlugs ALL ["designed--impact"], duration 500-4000 ms, term "hit dry short".
   data-start = T_REVEAL, data-media-start = its measured peak, data-duration 1.2,
   data-volume 0.282, volume lane fading the last 0.3 s. If an earlier step already
   spent the payoff, SKIP this sound.

6. MAKE ROOM. The punctuation word ("boom", "done") must END 3 frames before
   T_REVEAL - move the narration, not the accent. On the bed's volume lane: explicit
   v=1 before T_REVEAL (a lane holds its first value backwards), v=0.63 at T_REVEAL,
   v=1 at T_REVEAL + 0.3.

7. READABILITY GATE. The value being proved must be legible >= 24 frames (0.8 s), or
   36 if nothing points at it. If step 2 took the dwell below that, put frames back.

ACCEPTANCE TEST.
(a) Three distinct textures: short high click, sweep, low transient. If they sound
    alike, one asset is doing all three jobs - refetch.
(b) Click within +-1 frame of T_CLICK; transient on T_REVEAL or 1 early.
(c) The cursor does not teleport across the compression cut.
(d) The proved value is readable at 100% zoom for >= 24 frames.
(e) Exactly one payoff transient in the whole demo sequence.
```

## Execution spec

**Placement spec (the three numbers, per sound).**

| | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Click (diegetic) | **0 f** on `T_CLICK` | −16 dB (`data-volume` 0.158) | none |
| Reveal sweep (motion) | onset **−4 f**, peak on `T_REVEAL` | −12 dB (0.25) | none |
| Payoff transient (aesthetic) | **0 f** on `T_REVEAL`, or −1 f | −11 dB (0.282) | bed −4 dB, restored +0.3 s |
| Narration | punctuation word ends **−3 f** before `T_REVEAL` | 0 dB (1.0) | nothing ducks the voice |

**HyperFrames — the wait is removed by cutting the capture in-composition, not by retiming it.** This is the stack-specific decision that shapes the whole beat: `data-playback-rate` is *"a constant, normalized 0.1..5"* and **there is no rate envelope** — *"source speed ramps are not supported… preprocess a derived synchronized asset."* So the cheap, correct move is two clips of the same file with different `data-media-start`, authored back to back. The visibility window is half-open, so `b.start === a.start + a.duration` produces **no overlapping frame**.

```html
<!-- capture, punched in; the 3.1 s of waiting between 8.40 and 11.50 in the source is cut out -->
<video id="ui-a" src="assets/screen-capture.mp4" muted playsinline
       data-start="30.000" data-duration="2.400" data-media-start="6.000"
       data-track-index="0"></video>
<video id="ui-b" src="assets/screen-capture.mp4" muted playsinline
       data-start="32.400" data-duration="4.000" data-media-start="11.500"
       data-track-index="0"></video>

<!-- T_CLICK = 32.200 (inside ui-a) · T_REVEAL = 32.400 (the seam) -->
<audio id="sfx-ui-click" src="assets/sfx/mouse-click.wav"
       data-audio-group="sfx-diegetic" data-track-index="12"
       data-start="32.200" data-duration="0.120" data-media-start="0.640"
       data-volume="0.158"></audio>

<audio id="sfx-ui-sweep" src="assets/sfx/whoosh-short.wav"
       data-audio-group="sfx-motion" data-track-index="13"
       data-start="32.267" data-duration="0.500" data-media-start="0.030"
       data-volume="0.25"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.38,&quot;v&quot;:1},{&quot;t&quot;:0.5,&quot;v&quot;:0}]}]}"></audio>

<audio id="sfx-ui-payoff" src="assets/sfx/impact-dry.wav"
       data-audio-group="sfx-aesthetic" data-track-index="14"
       data-start="32.400" data-duration="1.200" data-media-start="0.052"
       data-volume="0.282"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.9,&quot;v&quot;:1},{&quot;t&quot;:1.2,&quot;v&quot;:0}]}]}"></audio>
```

- **`32.267 = 32.400 − 0.133`** is the 4-frame lead, written as seconds because *"all authored time is in SECONDS. There is no frame-based data attribute."* Keep the frame count in a comment.
- **The three effects are on three different `data-track-index` values** because they overlap; sharing one raises `duplicate_audio_track`.
- **Every `<audio>` has an `id`** — an id-less one is *never mixed → silent render*, and it is a lint error.
- **Videos are `muted` with audio on separate tracks** (project key rule 4). If the capture has usable system audio, place it as its own `<audio>` at −24 dB with 8-frame fades, exactly as in [[sfx-narration-over-reenactment]].
- **The punch-in is a GSAP tween on a wrapper, not on the `<video>`.** A `<video data-start>` whose ancestor also carries `data-start` is a lint **error** (`video_nested_in_timed_element`) — time the wrapper *or* the video, not both. And never set an initial CSS `transform` on an element you will GSAP-tween (`gsap_css_transform_conflict`); use `gsap.fromTo(el, {scale:1}, {scale:1.6})`.
- **Do not tween `display`/`visibility` on a clip** — the framework owns clip visibility; use `autoAlpha`.
- **There is no audio-follows-animation attribute**, so `T_REVEAL` gets written twice: once as the GSAP position of the scale pop, once as `data-start`. If the capture lives in a sub-composition, the root-level audio needs `data-start = scene-local t + the slot's data-start`.
- **Bed duck** is a `volume` lane on the **bed**, with an explicit `v:1` point before the dip — a lane holds its first value backwards to the clip start.

**Epidemic Sound — verified slugs for all three sounds.** Tag-first; an unknown slug fails closed with `meta.total: 0`.

```
# 1. the click - real hardware
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["computers--keyboard-mouse"] },
                               duration: { min: 100, max: 3000 } },
                     query: { term: "mouse click single" },
                     sort: { by: POPULARITY, order: DESCENDING }, first: 10 }
#    the click - designed / brighter, for a stylised UI
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["user-interface--click"] },
                               duration: { min: 100, max: 3000 } },
                     query: { term: "button press tap" }, first: 10 }

# 2. the reveal sweep
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["swooshes--whoosh"] },
                               duration: { min: 300, max: 1500 } },
                     query: { term: "fast short air" }, first: 10 }
#    UI-flavoured alternative, same job
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["user-interface--motion"] },
                               duration: { min: 500, max: 6000 } },
                     query: { term: "short swish swipe open" }, first: 10 }

# 3. the payoff transient
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["designed--impact"] },
                               duration: { min: 500, max: 4000 } },
                     query: { term: "hit dry short" }, first: 8 }
```
All five slugs probed live 2026-08-28. `user-interface--motion` titles are explicitly multi-take — *"Short Swish, Swipe, Open, Close, Variations 04"* — which is a bonus: one download supplies the rotation set for a multi-step demo ([[sfx-repetition-variant-rotation]]). Note that `user-interface--notification`, `user-interface--confirm` and `user-interface--success` are **not valid slugs** (0 results); for a success chime use `designed--impact` or `cartoon--pop` and treat it as an accent, not a UI sound. Download WAV.

**ffmpeg — measuring the two frames and the peak offsets.**
```bash
# extract the exact frames around the click so you can step them
ffmpeg -i screen-capture.mp4 -ss 8.10 -t 0.60 -vf "fps=30" frames/click_%03d.png
# peak offset inside a multi-take click file (n=1600 = 1 frame @ 30 fps)
ffmpeg -i mouse-click.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
# if you genuinely need a speed ramp, it must be a preprocessed asset
ffmpeg -i screen-capture.mp4 -vf "setpts=0.25*PTS" -an capture.fast.mp4
```

**Remotion.** Two `<Sequence>` blocks over one `<OffthreadVideo>` with different `startFrom`, plus three `<Audio>` elements whose `from` frames are `T_CLICK`, `T_REVEAL − 4`, `T_REVEAL`. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-appearance-transient]] · [[sfx-highlight-sound-on-emphasis]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-peak-at-motion-midpoint]] · [[sfx-peak-offset-measurement]] · [[sfx-three-types-classification]] · [[sfx-layered-approach-and-impact]] · [[sfx-narration-over-reenactment]] · [[sfx-hard-cut-audio-seam]] · [[sfx-density-fatigue-audit]] · [[sfx-repetition-variant-rotation]] · [[sfx-demo-clip-loudness-handover]] · [[motion-screen-recording-cursor-punch-in]] · [[cut-screen-recording-proof-insert]]

## Failure modes
- **Reveal sound, no click sound.** The most common version of this beat and the reason it reads as a screenshot tour. The click is what makes the software feel operated.
- **Sonifying every step.** Five payoffs in one workflow devalues all five and tires the viewer. One click sound per click is fine; one payoff per sequence.
- **The transient landing on the punctuation word.** "Boom" and the hit on the same frame produce mud in the 200–800 Hz region and cost both. Move the narration 3 frames earlier.
- **Compressing the wait below readability.** Removing the dead time is right; removing the dwell is not. If the value the demo proves is on screen for 12 frames, the shot no longer proves anything.
- **No punch-in.** A 14 px UI label at 1080p is unreadable on a phone. Punch in 1.4–2.2× or the evidence is decorative.
- **The cursor teleporting across the compression cut.** Cut where the cursor is stationary, or cover the jump with the sweep plus a 2-frame blur.
- **Using the whoosh as the payoff.** A sweep says "something moved"; it does not say "here is the result". The reveal needs a transient with a low centre of gravity, or the moment has no floor.
- **An early click.** Diegetic sounds land on or 1 frame after the event, never before — an early click reads as a broken edit, whereas an early motion sweep reads as anticipation. Do not apply the motion lead to the click.
- **Known gap — no speed ramp.** `data-playback-rate` is a constant with no envelope, so the familiar "ramp through the boring part" move must be baked with ffmpeg outside the composition and re-imported as a derived asset. Plan for a file, or use the hard cut.
- **Known gap — no cursor highlighting primitive.** Nothing in the stack draws a cursor ring or magnifies the pointer. It is an authored overlay (a `div` with a radial gradient tweened to the cursor's authored positions) or it does not happen; and positions must be **computed once at setup**, never from `getBoundingClientRect()` at tween time.
