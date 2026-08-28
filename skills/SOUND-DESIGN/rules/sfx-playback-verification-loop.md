---
id: sfx-playback-verification-loop
title: Play it and trust the feel — the structured listen-adjust-listen protocol
skill: sound-design
type: mix
family: verification
tags: [skill/sound-design, type/mix, family/verification, layer/dialogue, layer/music, layer/sfx, layer/ambience, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:31"
    quote: "It depends on the feel. Play it, if it sounds right, it's right. If not, tweak it a bit and check again."
research_refs:
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://en.wikipedia.org/wiki/Audio_to_video_synchronization
  - https://ffmpeg.org/ffmpeg-filters.html#fade
  - https://en.wikipedia.org/wiki/Orienting_response
difficulty: medium
detectable_from: audio
---

# Play it and trust the feel — the structured listen-adjust-listen protocol

## What it is
The closing rule of the source's placement section, taken seriously: the numeric rules get a sound close, and a **listen-adjust-listen loop at playback speed** finishes the job. Placement is judged with the ears against the picture, never by looking at a waveform. The waveform tells you where a transient *is*; it cannot tell you whether the transient feels caused by the movement, whether it fights the voice, or whether the moment now has too much on it.

Left there, though, "if it sounds right, it's right" is unrepeatable — it produces different answers on different days, on different headphones, and it has no stopping condition. This note is the protocol that makes the loop converge: **five listening passes, each with a defined question and a defined system, a hard iteration cap, and four objective measurements that run alongside** so that a subjective judgement is never asked to carry something a meter can settle. Those measurements are exactly the ones where ears are unreliable: absolute loudness, sync offset, mono compatibility, and level relationships between layers.

The one contract fact that shapes everything here: **this stack has almost no automated gate over the mix.** The linter reads `data-automation` for exactly two conflicts and nothing validates the FX chain or the effect lanes at all. There is no substitute for the loop.

## When to use it
After every placement decision, before it is treated as done. Specifically: after placing any SFX, after any level change, after any carve run, after any music cue change, and as a whole-programme pass before the render is presented. It is the sign-off step referenced by every other sound note in the library.

Also use it as an arbitration procedure when two people disagree about a placement, or when a note's parameter table and your ears disagree — the table's numbers are defaults, and pass 2 (the A/B) is what decides. Do **not** use scrubbing, waveform inspection or frame-stepping as a substitute for any pass; scrubbing gives every element unlimited time and therefore always passes.

## How to recognise it in a reference video
You are detecting the *absence or presence of verification*, which shows up as a cluster of symptoms rather than one signal:
- **Level relationships hold across the whole video.** Measure dialogue, music and SFX short-term loudness at five random points. A verified mix keeps dialogue at **0 to −3 dB**, music at **−20 to −25 dB**, SFX at **−12 to −15 dB** relative to dialogue, consistently. Drift between sections means nobody did a whole-programme pass.
- **Integrated loudness sits near the platform target** — **−14 LUFS** for YouTube/Tidal, true peak ≤ **−1 dBTP**. A file at −9 LUFS or −22 LUFS was never metered.
- **Sync is inside the window everywhere.** Spot-check five SFX against their visual events: a verified mix keeps them within **±1 frame**; broadcast recommendations are audio leading by no more than **15 ms** and lagging by no more than **45 ms**, against a detectability threshold of **45 ms lead / 125 ms lag**.
- **Nothing disappears in mono.** Sum to mono and listen: an effect that vanishes was placed with a phase-inverted stereo file and never checked.
- **The small-speaker test passes.** Play through a phone or laptop speaker. A verified mix still reads; an unverified one loses its sub-heavy hits entirely and its dialogue gets buried in the 300 Hz–3 kHz region.
- **Symptoms of an unverified mix:** an SFX that is audibly late by 3–5 frames; a bed that is fine in one section and 4 dB louder in the next; a carve that sounds *notched* rather than simply quieter under the voice (the contract's own diagnostic: the strength is too high); a reverb tail chopped off mid-decay.
- **On the transcript/design doc:** a project that records `PEAK_T`, measured loudness values and a per-element pass/fail was verified. One with only "sfx: whoosh" was not.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Pass 1 — in-context playback window | 10 s (5 s each side of the event) | 6–20 s | Full speed, eyes on picture, no scrubbing. |
| Pass 2 — A/B alternations | 3 | 2–5 | Element on / off. If you cannot tell which pass had it, delete the element. |
| Pass 3 — solo against dialogue | 1 | 1–2 | Mutes music and ambience; checks masking and intelligibility. |
| Pass 4 — second system | phone or laptop speaker | + headphones | Small speaker for masking, headphones for tail and stereo. |
| Pass 5 — whole programme | 1 per render | 1–2 | Census pass: count SFX per minute, check level drift and fatigue. |
| Iteration cap per element | 3 | 2–4 | Not right in 3 tweaks → the **file** is wrong, not the timing. Swap it. |
| Sync acceptance | ±1 f (33 ms) | ±0 to ±2 f | Tighter than the 45 ms/125 ms detectability threshold on purpose. |
| Integrated loudness | −14 LUFS | −16 to −13 | YouTube/Tidal target; podcast deliverable −16 LUFS. |
| True peak ceiling | −1 dBTP | −1.5 to −1 | Some broadcasters demand −3 dBTP for data-reduced formats. |
| Dialogue level | 0 to −3 dB | — | Source's own numbers. |
| Music level | −20 to −25 dB rel. dialogue | −30 for loud guitars | Source's own numbers. |
| SFX level | −12 to −15 dB rel. dialogue | — | Source's own numbers. |
| Carve strength | 0.25 | 0.15–0.40 | 0.25 = a 6 dB dip in three bands. At 0.5 the dip reaches 10 dB and is heard as an effect. |
| Mono check | mandatory | — | Any element that vanishes is phase-broken. |

## Reproduction prompt

```
Verify one sound placement, then the whole programme. Do not skip a pass and
do not substitute scrubbing for playback at any point.

PASS 1 - IN CONTEXT. Play the 10s window centred on the event at 1x speed,
eyes on the picture, once. Ask exactly one question: does the sound feel
CAUSED by what is on screen? Do not look at the waveform. If it feels late
or early, measure before adjusting (see MEASURE below) - do not nudge by
feel when a number is available.

PASS 2 - A/B. Toggle the element off and on three times, playing the same
window each time. Set data-hidden on the clip to mute it non-destructively.
If you cannot reliably tell which pass contained it, DELETE the element -
it is not earning its slot.

PASS 3 - AGAINST DIALOGUE ONLY. Mute music and ambience. Check the element
does not mask a consonant and that the line is still fully intelligible.
If it masks, do not just lower it: high-pass or notch the offending band.

PASS 4 - SECOND SYSTEM. Play the same window on a phone or laptop speaker,
then on headphones. Small speaker reveals masking in 300Hz-3kHz and kills
sub-heavy elements; headphones reveal tails, stereo width and clicks.
An element that only works on one of the two is not finished.

PASS 5 - WHOLE PROGRAMME, once per render. Play the entire video without
stopping. Count SFX per minute. Note any section where levels step. Note the
point at which you stop noticing the sound design - everything after that
point is over-stimulated and should be thinned.

MEASURE, alongside every iteration:
  1. SYNC: render, find the element's local peak, confirm it is within 1
     frame of the intended frame. Never estimate this.
  2. LOUDNESS: integrated -14 LUFS +/- 1, true peak <= -1 dBTP.
  3. RELATIONSHIPS: dialogue 0 to -3 dB, SFX -12 to -15 dB, music -20 to
     -25 dB relative to dialogue.
  4. MONO: sum to mono; confirm nothing vanishes.

ITERATION CAP: three tweaks per element. If it is still wrong, the FILE is
wrong - source a different one rather than continuing to move this one.

ACCEPTANCE TEST: every pass completed; all four measurements inside range;
the iteration cap not exceeded on any element; and a note recorded in the
design document giving the element's measured PEAK_T, its final level and
its pass/fail per pass, so the next session does not re-litigate it.
```

## Execution spec

**The measurements (ffmpeg).** These are the four numbers the ears should never be asked to supply:
```bash
# 1. loudness, two-pass: measure, then apply the measured values
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=<input_i>:measured_TP=<input_tp>:measured_LRA=<input_lra>:measured_thresh=<input_thresh>:offset=<target_offset>:linear=true:print_format=summary mix.social.wav

# short-term loudness trace, for level-drift and per-layer relationships
ffmpeg -i mix.wav -af ebur128=peak=true -f null - 2>&1 | grep -E "S:|M:"

# 2. peak position of a single SFX file (for PEAK_T and for sync verification)
ffmpeg -i whoosh.wav -af "astats=metadata=1:reset=0,ametadata=print:key=lavfi.astats.Overall.Peak_level" -f null -

# 3. mono compatibility: sum and compare
ffmpeg -i mix.wav -ac 1 -af "volume=1" mix.mono.wav
ffmpeg -i mix.mono.wav -af ebur128 -f null - 2>&1 | tail -5

# 4. an offline audition without a browser (the device VM cannot render)
ffplay -autoexit -ss 138 -t 10 mix.wav
```
The podcast deliverable is the same two-pass command with `I=-16`.

**HyperFrames — what the loop actually touches.**
- **Pass 2's mute is `data-hidden`**, not deletion: *"Hides the element in both preview and render, overriding its time window. Non-destructive, reversible, toggled by Studio's timeline eye icon."* This matters twice — it is reversible, and **the mounted vault cannot delete files**, so non-destructive toggling is the only safe idiom here.
- **Nudging timing is editing `data-start` in seconds**, and there is no frame attribute — one frame at 30 fps is `0.0333`. Write three decimals.
- **Studio is the review surface, not just a viewer.** `npx hyperframes preview --background` (never a `run_in_background` wrapper around `npm run dev`, which *"can disappear while the browser stays open"*), then `npx hyperframes preview --status` to confirm it is listening, and hand back `http://localhost:3002/#project/<project-name>` — a URL missing the `#project/<name>` hash is dead.
- **`npx hyperframes check` does not cover the mix.** The contract is explicit: *"Almost no static gate covers the mix"*, the linter reads `data-automation` for exactly two conflicts (`audio_volume_double_automation`, `audio_volume_tween_overrides_gain`) plus two carve-arrangement rules, and *"nothing validates the chain or the effect lanes at all."* A clean `check` says nothing about whether the sound is right.
- **A lint *error* silently disables the layout and contrast audits** — `check` then reports `0 sample(s)` and `0/0 text checks`, which reads clean and means nothing ran. Fix errors before believing any pass.
- **Render refuses an unparseable FX chain; preview plays it dry.** So an element that sounds untreated in preview may simply have a malformed chain — check the JSON escaping (`&quot;`) before re-tweaking the level.
- **Diagnosis rule, verbatim from the contract:** *"The absolute spectrum of a single unknown voice cannot be diagnosed."* Always compare against something **inside the same file** — the clean original, or the pauses. Do not chase an absolute target for a voice.
- **Carve self-check:** *"If the bed sounds notched rather than simply quieter under the voice, the strength is too high."* Default 0.25; 0.5 is where a carve *"starts being heard as an effect."* Re-run `node <SKILL_DIR>/scripts/carve.mjs --comp index.html` after changing it; it replaces only its own `fromCarve` nodes and leaves hand-built effects alone.
- **Effects with a tail** (`reverb`, `delay`) make the rendered track longer than its `data-duration` via `chainTailSeconds` — *"that is expected, not a bug."* Do not treat it as a placement error.
- **Render only after review.** *"Render only after the user has reviewed in `preview` and approved. Don't auto-render when the checks pass."*

**The hard environmental constraint, and it is load-bearing for this note.** `render`, `snapshot`, `preview`, `play` and the audio render path are all **browser-dependent** — the mix is rendered through *"an `OfflineAudioContext` in the headless browser."* This project's device VM is **linux ARM64 without sudo**, so none of that can run there. Practical consequence: passes 1–5 as written require the render to happen on another host. What *can* be done locally is the ffmpeg measurement set above and `ffplay` auditions of the individual source files. **Do not claim a placement is verified if the only thing that ran was `check`.**

**Epidemic Sound.** The iteration cap is what sends you back to the library. When an element fails three tweaks, replace it rather than continuing:
```
SearchSimilarToSoundEffect { id: "<the file that nearly worked>" }
SearchSoundEffects { query.term: "<same intent, different family>", filter.duration { max: 3000 } }
```
Fetch three candidates and run pass 2 against each — that is [[sfx-ab-audition-candidates]]'s job, and it is the correct exit from this loop.

**Remotion:** the same protocol; the measurement half is identical because it is ffmpeg either way. Not part of this project.

## Pairs with
- [[sfx-ab-audition-candidates]] — where a failed iteration cap sends you
- [[sfx-placement-discipline]] — the gate that decides an element deserves a slot at all
- [[sfx-av-sync-binding-window]] — the sync tolerance numbers measured in pass 1
- [[sfx-sound-pass-order]] — the census run in pass 5
- [[struct-stimulation-budget]] — the fatigue judgement pass 5 produces
- [[sfx-cinematic-hit-emphasis]] — the `PEAK_T` measurement pattern this note generalises
- [[sfx-silence-as-pattern-interrupt]] — a move that can only be signed off by listening
- [[pace-rough-cut-diagnostic]] — the picture-side equivalent of a whole-programme pass
- [[sfx-music-audition-against-picture]] — the same loop applied to a bed

## Failure modes
- **Judging placement on the waveform.** The waveform shows where a peak is, not whether it feels caused. Every pass is a playback.
- **Scrubbing instead of playing.** Scrubbing gives each element unlimited exposure and therefore always passes. Full speed, once, eyes on picture.
- **One system only.** A mix verified on good headphones alone routinely collapses on a phone speaker, which is where most of the audience is. The phone pass is not optional.
- **No iteration cap.** Twenty nudges of the same wrong file is the classic time sink. Three tweaks, then swap the file.
- **Treating `check` as verification.** It does not cover the mix, and a lint error makes it report a clean-looking result while running nothing.
- **Chasing an absolute target for a voice.** The absolute spectrum of an unknown voice cannot be diagnosed; compare against the clean original or the pauses in the same file.
- **Skipping the mono check.** A phase-broken stereo effect disappears on any mono playback path and you will not hear it in stereo.
- **Fixing masking with the fader.** If an effect covers a consonant, lowering it also removes the effect. Notch or high-pass the offending band instead.
- **Over-carving to make room.** A notched-sounding bed is a strength problem, not a level problem. Back off to 0.25.
- **Not writing the numbers down.** An unrecorded verification is re-litigated next session. Record `PEAK_T`, final levels and per-pass results in the design document.
- **Known gap:** the browser-dependent legs of this protocol — `render`, `snapshot`, `preview`, `play`, and the `OfflineAudioContext` audio render — **cannot run on this project's device VM** (linux ARM64, no sudo). The loop is only fully executable on a host with a browser. Locally, you get the ffmpeg measurements and `ffplay` on source files, and you must say so rather than implying a full sign-off.
