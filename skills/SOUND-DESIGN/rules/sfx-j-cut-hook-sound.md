---
id: sfx-j-cut-hook-sound
title: Hear it before you see it — choosing the J cut's lead sound for curiosity, not continuity
skill: sound-design
type: cut
family: split-edit
tags: [skill/sound-design, type/cut, family/split-edit, sfx/diegetic, layer/ambience, layer/dialogue, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:02:03
    quote: "Here is a popular J cut from the Wolf of Wall Street where we begin to hear Matthew McConaughey beating on his chest, leading us into the lunch scene before we visually see it."
research_refs:
  - https://en.wikipedia.org/wiki/Split_edit
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Precedence_effect
  - https://en.wikipedia.org/wiki/Orienting_response
  - mcp://Epidemic_sounds/SearchSoundEffects (tag slugs probed live, 2026-08-28)
difficulty: medium
detectable_from: transcript+video
---

# Hear it before you see it — choosing the J cut's lead sound for curiosity, not continuity

## What it is
Most J cuts are invisible: the destination's room tone slides under the outgoing shot and the location change lands without being announced. That craft is [[sfx-j-cut-audio-lead]]. This note is the **opposite intent**, and it is a different move with different selection rules: the lead sound is chosen precisely *because* it cannot be explained by what is on screen, so the viewer wants the cut to happen.

The reference case names it exactly — a rhythmic chest-thumping heard before the lunch scene appears. The viewer's model of the current shot cannot account for the sound, and the mismatch produces an orienting response toward the coming picture. The lead sound is doing narrative work, not continuity work: it is a question the cut answers.

The consequence for selection is that **distinctiveness beats plausibility**. An invisible J wants the most neutral bed the destination could produce; a hook J wants the single most unaccountable sound in the destination and nothing else under it.

## When to use it
- **Entering a scene whose interest is its content, not its location** — a demo about to start, a machine about to run, a crowd, a confrontation. The lead sound is the thing the viewer came to see, heard first.
- **At a structural turn** where you want the viewer forward-leaning rather than settled: into the payoff of a promise, into the first item of a numbered list, into a before/after flip.
- **When the outgoing shot is visually static and the incoming one is not.** A hook J converts a dead frame into anticipation for free ([[pace-overlay-instead-of-cut]] is the alternative if you cannot cut).
- **When the incoming sound has a strong rhythmic or vocal identity** — a chant, a chest thump, a hammer, a countdown, a machine spinning up. Continuous ambience makes a bad hook because it carries no information.
- **Not more than two or three times in a video.** Every hook J spends attention; used repeatedly the device becomes the pattern and stops producing surprise ([[struct-stimulation-budget]]).
- **Not into a smash cut.** A smash cut buys its jolt from simultaneity; leading its audio softens exactly what you were paying for ([[sfx-smash-cut-audio-contrast]]).
- **Not with two speech streams overlapping.** Two voices for a second is a mistake, not a hook. If the destination's identity is a voice, lead with its *non-verbal* component — a laugh, a shout, a breath — and bring words in on the picture cut.
- **Not when the incoming sound is disturbing without context.** A scream, a crash or a gunshot with no picture reads as an error the first time and as a cheap jump scare the second.

## How to recognise it in a reference video
- **An audio onset with no visible source, 15–60 frames before a picture cut.** Detect the cuts, then find the nearest audio onset before each:
  ```bash
  scenedetect -i ref.mp4 detect-adaptive list-scenes          # picture cuts, seconds
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
   ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  A **hook** J shows as a discrete, repeating or transient event (≥6 dB above the outgoing shot's floor) starting 0.5–2.0 s before the cut. An **invisible** J shows instead as a quiet step in the noise floor with no transient. The distinction is the finding — log which one it is.
- **The lead sound is still audible after the cut** and is now visibly sourced. If the sound stops at the cut it was a sting, not a J cut.
- **The outgoing picture does not change** during the lead. If it also punches in, cuts or flashes, the anticipation is being carried visually and the J is redundant.
- **The lead level is 6–12 dB below its post-cut level.** A hook J that arrives at full volume reads as a mix error rather than as something approaching.
- **On the transcript:** the narration line running under the lead is a setup or a question, and it **finishes before the cut**. A hook J landed on top of a word masks the setup it exists to answer.
- **Music behaviour:** the bed continues across the seam unchanged. A track change on the same frame turns an invisible seam into a section break and kills the hook.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Lead for a **rhythmic/repeating** sound (thump, hammer, chant, clap, countdown) | 1.2 s (36 f) | 0.8–2.0 s | Needs **at least two repetitions** before the cut or it does not read as a pattern. This is the strongest hook class. |
| Lead for a **distinctive human vocalisation** (laugh, shout, gasp, chest thump) | 0.8 s (24 f) | 0.5–1.2 s | Non-verbal only. Never overlap with the outgoing speech. |
| Lead for a **single mechanical transient** (door, latch, engine catch, shutter) | 0.4 s (12 f) | 0.25–0.6 s | One event; longer leads make it read as a mistake rather than a cue. |
| Lead for **music/downbeat** from the destination | 1 bar | 1–2 bars | At 100–120 BPM one bar is 2.4–2.0 s. Land the picture cut on the downbeat ([[sfx-cut-on-the-beat]]). |
| Lead for **room ambience** (the invisible J, for contrast) | 2.0 s (60 f) | 1.0–3.0 s | Not a hook. Use [[sfx-j-cut-audio-lead]]. |
| Minimum useful lead | 0.13 s (4 f) | — | Below the ~125 ms audio-lag detectability floor the ear folds it into the cut. |
| Maximum before it stops reading as a cut relationship | 3.0 s (90 f) | — | Past this it is an audio bridge or a bed ([[sfx-ambience-bridge-across-cut]]). |
| Lead level | 0.35 (−9 dB rel. its post-cut level) | 0.25–0.5 | Ramp to 1.0 across the lead so the cut still "arrives". |
| Ramp shape | linear over the full lead | 0.2 s–full lead | Rhythmic leads: step each repetition up, don't ramp continuously. |
| Outgoing speech during the lead | must have ended | — | Hard rule. Schedule the lead into the gap after the setup line. |
| Hook Js per 10 minutes | 2 | 1–3 | Shared budget with other pattern interrupts. |

## Reproduction prompt
```
Build a curiosity J cut into the shot at {{CUT}} (composition seconds).

1. PICK THE SOUND, NOT THE BED. List every sound the incoming shot makes. Choose the
   one a viewer looking at the OUTGOING shot could not explain, and that carries
   information: a repeating action sound, a non-verbal human vocalisation, a machine
   spinning up, a countdown. Reject continuous ambience - it is a continuity lead,
   not a hook, and belongs in the invisible-J recipe instead.

2. CHOOSE {{LEAD}} BY CLASS.
     rhythmic / repeating     -> 1.2 s, and confirm at least TWO repetitions fit
     non-verbal vocalisation  -> 0.8 s
     single mechanical event  -> 0.4 s
     destination downbeat     -> one bar (2.4 s at 100 BPM, 2.0 s at 120 BPM)
   Then check the transcript: {{CUT}} - {{LEAD}} must fall AFTER the last word of
   the outgoing line. If it does not, shorten {{LEAD}} to the next word boundary.
   Never start a lead mid-word.

3. SOURCE IT. If the incoming clip has handle before its in-point, use its own audio:
   split picture from sound (video plays muted, a separate <audio> with the same src)
   and move BOTH data-start and data-media-start earlier by {{LEAD}}. If there is no
   handle - the usual case - fetch the sound from Epidemic instead and place it as
   its own clip; the incoming shot's own audio then starts normally at {{CUT}}.

4. PLACE AND RAMP.
     lead clip: data-start = {{CUT}} - {{LEAD}}, data-track-index 11+,
                data-audio-group="location", data-volume = 1.0
     volume lane, clip-local seconds:
       continuous lead -> t=0 v=0.35, t={{LEAD}} v=1.0
       rhythmic lead   -> t=0 v=0.35, t={{LEAD}}*0.5 v=0.6, t={{LEAD}} v=1.0
   Let it CONTINUE past {{CUT}} for at least 0.5 s so the source is seen making it.

5. HOLD EVERYTHING ELSE. Do not fade the outgoing shot's audio under the lead. Do not
   restart, stop or change the music bed at {{CUT}}. Do not add a whoosh on this cut -
   the lead sound IS the transition device and a whoosh competes with it.

6. ACCEPTANCE TEST. (a) At {{CUT}} - {{LEAD}}/2 you hear the next scene and see the
   previous one, and you cannot account for the sound. (b) The lead does not overlap
   any outgoing word. (c) After {{CUT}} the sound's source is visible within 0.5 s -
   if it never appears, this is a sting, not a J cut, and it will read as a loose end.
   (d) The lead is at least 4 frames (0.13 s) or it is doing nothing.
```

## Execution spec

**Placement spec.**

| | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Lead sound, before the cut | starts **12–60 frames early** by class | −9 dB at onset (`data-volume` 0.35), rising to its natural level | none on the bed — the bed must run through unchanged |
| Same sound, after the cut | continues ≥15 frames past the cut | its diegetic level (typically −12 dB rel. dialogue) | dialogue carve unchanged |

**Epidemic Sound.** The reliable path when the footage has no handle is to buy the hook sound as its own asset. Anchor on a verified tag slug and rank with `query.term`; free-text-only SFX search in this catalogue is noisy (a probe for `"clock ticking"` returned camera shutters and a mouse click before it returned a clock).

```json
// rhythmic human hook (the chest-thump class)
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["human--breath"] },
              "duration": { "min": 3000 } },
  "query":  { "term": "chant rhythmic close isolated" }, "first": 8 }

// mechanical single-transient hook
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["mechanical--click"] } },
  "query":  { "term": "latch metal close" }, "first": 8 }

// repeating pulse hook — clocks read as pressure, not as location
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["clocks--tick"] },
              "duration": { "min": 10000 } },
  "query":  { "term": "tick tock loop" },
  "sort":   { "by": "POPULARITY", "order": "DESCENDING" }, "first": 6 }
```

Verified slugs: `human--breath`, `human--heartbeat`, `clocks--tick`, `mechanical--click`, `footsteps--human`, `communications--camera`, `computers--keyboard-mouse`. An unrecognised slug returns `meta.total: 0` — it fails closed, so zero results means the slug is wrong. Prefer titles containing **"Close"** or **"Isolated"** for a hook: they are dry and read as *approaching*, where a roomy take reads as *already here*. `DownloadSoundEffect` with `{"fileType":"WAV"}`.

**HyperFrames.** There is no split-edit primitive and no automatic sync, so a J cut is authored by writing the offset twice. When the lead is the clip's own audio, **both** `data-start` and `data-media-start` move by the lead — moving only one desyncs the entire shot and nothing in the stack detects it.

```html
<!-- picture cuts at 12.0 s; a rhythmic hook leads by 1.2 s -->
<video id="shot-2" src="footage/floor.mp4" muted playsinline
       data-start="12" data-duration="6" data-media-start="8"
       data-track-index="0"></video>

<audio id="shot-2-hook" src="assets/audio/sfx/chest-thump-loop.wav"
       data-audio-group="location" data-track-index="11"
       data-start="10.8" data-duration="2.4" data-volume="1"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.35},{&quot;t&quot;:0.6,&quot;v&quot;:0.6},{&quot;t&quot;:1.2,&quot;v&quot;:1}]}]}"></audio>

<audio id="shot-2-audio" src="footage/floor.mp4"
       data-audio-group="location" data-track-index="12"
       data-start="12" data-duration="6" data-media-start="8"></audio>
```

Relative timing can express the offset — `data-start="shot-1 - 1.2"` — but **the spaces around the minus are mandatory**: `"shot-1-1.2"` parses as an id and silently resolves to `0`. Keep overlapping audio on different `data-track-index` values (`duplicate_audio_track`). Write JSON attributes double-quoted with `&quot;` so `carve.mjs` can see them. Every `<audio>` needs an `id`, or it is never mixed and the render is silent.

**ffmpeg.** Check whether the source has handle before the in-point, and lift a lead from it if so:
```bash
ffprobe -v error -show_entries format=duration footage/floor.mp4
ffmpeg -i footage/floor.mp4 -ss 6.8 -to 8.0 -vn -c:a pcm_s16le lead.wav
```
Trim the lead so it starts on a transient, not mid-decay, and give it a 5 ms head fade ([[sfx-edge-fades-click-free]]).

**Remotion.** The lead `<Sequence>` starts `leadFrames` before the picture sequence. Portability note only — Remotion is not part of this stack.

## Pairs with
[[sfx-j-cut-audio-lead]] · [[sfx-split-edit-lead-lag]] · [[cut-j-curiosity-lead]] · [[cut-j-audio-leads-picture]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-hard-cut-audio-seam]] · [[sfx-smash-cut-audio-contrast]] · [[sfx-cut-on-the-beat]] · [[struct-stimulation-budget]] · [[motion-pattern-interrupt-jolt]] · [[struct-outcome-first-cold-open]]

## Failure modes
- **Leading with ambience and calling it a hook.** Continuous room tone carries no information, so there is nothing to be curious about. That is the invisible J and belongs in [[sfx-j-cut-audio-lead]].
- **The sound's source never appears.** A hook J is a question; if the picture never answers it the viewer is left with a loose end and reads the sound as a mistake. Show the source within 0.5 s of the cut.
- **Overlapping the outgoing speech.** The lead masks the setup line it exists to answer — and forward masking persists ~100 ms past a loud event, so even a lead that *ends* just before a word can smear its first phoneme. Land the whole lead in a gap.
- **Full-level arrival.** The location or action appearing at final volume before the picture reads as a mix error. Ramp from ~0.35.
- **One repetition of a rhythmic sound.** A single thump is a transient, not a pattern; the hook comes from the ear predicting the next one. Fit at least two.
- **Adding a whoosh on the same cut.** Two devices claiming the same seam. The lead sound is the transition.
- **Restarting the music at the seam.** The bed spanning the cut is half of why the seam holds. A track change here converts a hook into a section break ([[sfx-track-change-at-section-boundary]]).
- **Using it for every scene change.** Barry Salt's 2011 survey of 33 American films found J-edit usage rising to near parity with L-edits — which is exactly why an *unmotivated* one no longer surprises. Budget two or three per video and make each one answer something.
- **Known gap:** nothing in `lint` checks split-edit sync, and `duplicate_audio_track` is only a warning. Verification requires rendering the seam and listening, and the browser-dependent render must run off the authoring VM.
