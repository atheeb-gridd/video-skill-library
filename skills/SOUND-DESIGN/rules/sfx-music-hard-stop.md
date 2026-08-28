---
id: sfx-music-hard-stop
aliases: [sfx-music-drop-for-emphasis]
title: Cut the music dead to make one moment land — and land the stop on an accent
skill: sound-design
type: music
family: music-arc
tags: [skill/sound-design, type/music, family/music-arc, engine/hyperframes, engine/epidemic, engine/ffmpeg, layer/music, layer/ambience, layer/dialogue, source/editing-kt, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:13:15"
    quote: "What do you think happens when you cut the music abruptly? That sudden change jolts the viewer and grabs their attention. On top of that, the absence of music pulls attention to other parts of the video. So try pausing the music for special moments to make that moment stand out."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:05:49"
    quote: "But it's important to give the music some rest, meaning: you should know when to stop the music."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:05:54"
    quote: "If you want to put emphasis on something, or you're saying something serious, cutting the music there sends all the focus onto your voice."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:00"
    quote: "And whenever you do stop the music, stop it on a peak point in the audio. You can see this in the waveform: wherever you see a peak, cut the music there. It feels really smooth, it doesn't feel sudden."
research_refs:
  - https://en.wikipedia.org/wiki/Orienting_response
  - https://en.wikipedia.org/wiki/Habituation
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
  - https://en.wikipedia.org/wiki/Room_tone
  - https://vocal.com/audio/psychoacoustic-effects-masking/
  - https://ccrma.stanford.edu/~malcolm/correlograms/text/23%20Backward%20And%20Forward%20Masking.html
  - https://www.storyblocks.com/resources/tutorials/3-techniques-cutting-music-without-sudden-stop
  - https://blog.frame.io/2017/05/08/edit-with-silence/
  - https://motionedits.com/how-silence-and-pauses-strengthen-video-storytelling/
  - https://pixflow.net/blog/audio-mixing-premiere-pro/
  - https://www.michaelmusco.com/2026/02/structural-language-music-supervisors-expect.html
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: audio
---

# Cut the music dead to make one moment land — and land the stop on an accent

## What it is
Stop the music bed at a chosen frame so the line that follows plays over silence. Two effects arrive at once. The change itself triggers an **orienting response** — the automatic attentional reaction to *"a change in [the] environment"* that fires within seconds of onset. And the removal of the bed takes a competing stimulus off the table, so whatever remains carries the moment. It is an emphasis tool built entirely out of subtraction: everything the bed was doing for energy is withdrawn, and the voice becomes the only thing in the mix.

The two source videos disagree in a productive way: one prescribes the abrupt stop for its jolt, the other insists the stop lands **on a peak in the waveform** so it reads as musical rather than as a dropout. Both are right, and the reconciliation is the whole craft of this move: **cut hard, but cut on a beat.**

The mechanism behind "cut on a peak" is temporal masking. A transient masks what follows it for **150–200 ms** — comfortably 4–6 frames at 30 fps, which is exactly long enough to cover a short gain ramp. Land the stop on an accent and the join is inaudible; truncate a bed mid-sustain and it clicks or leaves a chord hanging, and reads as an error.

Note what does *not* stop: the **ambience stays**. Total silence reads as the file breaking, not as emphasis — *"the soundtrack going completely silent would sound like an equipment failure."*

## When to use it
Reserve it for one to three moments in a video. The legitimate triggers:

1. **The thesis line** — the single sentence the whole video exists to deliver.
2. **A serious or sincere beat** in an otherwise energetic video: bad news, a warning, a personal admission, a line the bed is undercutting.
3. **A number or name the viewer must retain.**
4. **The pivot from problem to solution**, or a reveal whose picture should carry alone.
5. **The frame before a reveal**, as the release half of a riser build ([[sfx-riser-anticipation-build]]) — although there the silence is anticipation rather than emphasis, and it is shorter.

Budget it. The device works by contrast with a bed that is otherwise present; a video that drops the music six times has taught the viewer that the bed is optional, and the orienting response habituates fastest under short inter-stimulus intervals. **One to three per 10 minutes.**

It is the exact counterpart of [[sfx-cinematic-hit-emphasis]] — hits add energy to mark importance, this subtracts energy to mark it — and the two should not fire on the same frame.

**Do not** use it as a section transition: a section change wants a track change ([[sfx-beat-aligned-handover]]) or a fade ([[sfx-music-fade-out-section-signal]]), not a hole. **Do not** use it on a video with no bed at all, where there is nothing to withdraw.

## How to recognise it in a reference video
- **Short-term loudness trace is the fastest detector.** A drop shows as a step down of **6 dB or more** in short-term loudness that is *not* explained by the voice stopping:
  ```bash
  ffmpeg -i ref.mp4 -af "ebur128=peak=true:framelog=verbose" -f null - 2>&1 | grep "S:"
  ```
- **Confirm it is the music and not the mix by looking below the voice.** Music beds usually own the 60–200 Hz region that speech barely touches. Band-limit and trace per frame:
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "lowpass=f=200,asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  (`n=1600` at 48 kHz = one frame at 30 fps.) A music drop is a **≥10 dB** fall in the sub-200 Hz trace while speech continues unbroken above it.
- **Measure the ramp.** Count the frames from the start of the fall to the floor. **1–3 f** = a hard stop on a transient; **2–6 f** = the general professional band; **12–45 f** = a fade-out, which is a section device rather than an emphasis drop ([[sfx-music-fade-out-section-signal]]).
- **Classify the out-point shape at sample zoom.** There are three, and only the first two are deliberate: **(a) transient stop** — the bed's last sample is a hit, cymbal or downbeat and the level reaches zero within 1–3 f; **(b) phrase-end or bar-line stop** — no big transient, but the musical unit has completed; **(c) truncation** — the bed stops mid-sustain with no transient and no ramp, which is the amateur signature and is never acceptable. Published editorial guidance names the clean cutting moments precisely: **at bar lines, after a transient hit, at the end of a phrase, during brief dropouts, and on sustained chords without rhythmic motion.**
- **Check the stop against the grid.** Measure the track's BPM, compute the beat grid, and check that the cut frame is within **±2 frames** of a grid position (at 100 BPM a beat is 0.6 s = 18 frames). On-grid stops are designed; off-grid stops are accidents.
- **Check the ambience floor survives.** After the drop, the inter-word floor should still sit around **−30 to −36 dBFS**, not at digital silence. If it falls below about **−60 dBFS**, the reference dropped everything — log whether that was a deliberate hard gesture (the picture usually changes too) or a mistake.
- **Locate the stop relative to the words.** Align the transcript. In a well-built drop the music is already gone **6–15 f (0.2–0.5 s) before** the first stressed syllable of the emphasised sentence. A drop that lands *after* the sentence has begun feels like a technical fault.
- **Duration of the silence.** Measure floor-to-return. Most emphasis drops run **0.8–3.0 s** — about one sentence — and a few run to **6 s** where the picture is actively carrying. Under ~0.5 s it reads as a glitch; past ~4 s on a static frame viewers begin to suspect a technical fault unless ambience is clearly holding the floor; over 10 s the video has changed mode and the bed's return will feel like a new video starting.
- **How it comes back.** Three signatures: a hard restart on a downbeat, a **0.3–1.0 s (9–30 f)** fade-in, or a riser bridging back in. Log which, plus whether the returning bed is the *same* track resumed or a different one.
- **Cut density under the silence.** Almost always lower — often a single held shot or a slow punch-in ([[cut-punch-in-emphasis]]). A busy cut pattern under a music drop wastes it.
- **Transcript check.** The line immediately after the stop is usually the video's thesis, a number, or a direct address ("here's the part nobody tells you"). If the sentence under the silence is ordinary, the drop was placed by feel and probably in the wrong place.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `drops_per_video` | 2 | 1–3 per 10 min | The device is spent by repetition; the orienting response habituates fastest at short intervals. |
| `stop_shape` | 3 f ramp (0.10 s) | 1–6 f | **Never 0** — cutting mid-waveform at a non-zero sample clicks. **Never over 12 f** — that is a fade, and it says "the section is ending" rather than "this sentence matters". Within the band, condition on the out-point: **1–3 f on a strong transient**, whose own 150–200 ms of post-masking hides the join and preserves the jolt; **4–6 f on a phrase end or bar line** with no big transient, where the extra frames are what prevent the click. |
| `out_point_type` | transient | transient \| phrase-end \| bar line | **Truncation mid-sustain is never acceptable.** If no transient sits within 8 frames of the intended picture time, move the stop, not the rule. |
| `alignment` | on the beat | ±2 f of the beat grid | Cut on a waveform peak / downbeat. Where two nearby accents both work, the **line wins over the grid** — pick the accent that gives clean pre-roll. That licence does *not* extend to cutting mid-sustain: if no accent falls inside the pre-roll window, move the stop back to the previous accent and hold a slightly longer silence. |
| `pre_roll` | 9 f (0.30 s) | 6–15 f | Silence established before the first stressed syllable of the emphasised line. Never drop the bed after the line has started. |
| `silence_len` | 2.0 s (60 f) | 0.8–3.0 s typical · to 6 s conditioned | Roughly one sentence. The longer band is only available when the **picture is carrying** — a held shot or a slow punch-in — and the ambience floor is unmistakably present; on a static frame anything past ~4 s starts reading as a fault. Under 0.5 s = glitch; over 10 s = mode change. |
| `ambience_retained` | true | — | Bed goes; room tone stays. **−28 dB (`0.04`) relative to dialogue**, band −32 to −24 dB, which lands around **−30 to −36 dBFS** absolute. Digital silence reads as failure. |
| `sfx_retained` | diegetic only | — | Keep the diegetic layer, drop aesthetic accents; a whoosh inside the silence undoes it. |
| `voice_level_change` | 0 dB | 0 to +1.5 dB | Do **not** boost the voice to "fill" the gap — the point is that nothing else is there, and removing the masker already raises perceived clarity. |
| `return_mode` | downbeat restart | downbeat \| fade-in \| riser-bridge | The return is normally a different shape from the exit. A riser bridge lands its peak on the return frame. |
| `return_fade` | 0.5 s (15 f) | 0.3–1.0 s (9–30 f) | Fade-in mode only. |
| `bed_level_normal` | −22 dB | −20 to −25 dB | The level the bed returns to. Loud guitar-driven tracks sit nearer −30 dB. |
| `cut_density_under` | 0.3× body | 0–0.5× | Usually one shot, or a slow punch-in. |
| `resume_position` | same track, later | same-later \| same-restart \| new track | "Same-later" (the bed keeps running silently and resumes where it would have been) is smoothest, because the arrangement still makes sense; "new track" makes it a section change instead. |

## Reproduction prompt

```
Place the emphasis music drop: stop the bed so the line beginning at {{T_LINE}}
plays over silence, and bring the bed back at {{T_RESUME}}. 30fps.

1. CHOOSE THE LINE. From the transcript, pick the 1-3 sentences that are
   (a) the video's thesis, (b) genuinely serious or sincere, or (c) a number
   or name the viewer must retain. Rank them and keep at most 3 per 10 minutes
   of runtime. If you cannot argue in one sentence why a line deserves
   silence, it does not.
2. FIND THE ACCENT. Read the bed's BPM (Epidemic returns it on every
   recording); beat interval = 60 / BPM. Within the 1.0 s window BEFORE the
   chosen line's first stressed syllable, find the nearest musical accent - a
   downbeat, crash, hit or phrase end. That frame is {{T_STOP}}. If no accent
   falls inside the window, move to the PREVIOUS accent and hold a slightly
   longer silence; never cut mid-sustain to hit a preferred frame.
3. VERIFY THE PRE-ROLL. {{T_STOP}} must be 6-15 frames (0.20-0.50 s) before
   the first stressed syllable, and never past the line's first word.
4. SHAPE THE STOP as a ramp to zero starting at {{T_STOP}}: 1-3 frames if you
   are landing on a strong transient, 4-6 frames on a phrase end or bar line.
   Not an instant mute (it clicks), not a fade over 12 frames (that is a
   section device).
5. KEEP THE ROOM. Ambience continues unchanged at data-volume "0.04"
   (-30 to -36 dBFS) across the whole silence; if no ambience bed exists,
   fetch one now. Keep diegetic sound effects. Remove aesthetic accents
   (whooshes, air, hits) for the whole window. Do NOT raise the voice level.
6. HOLD THE SILENCE for {{LEN}} - default 2.0 s (60 f), 0.8-3.0 s in general,
   up to 6 s only if a held shot or slow push-in is carrying the picture -
   ending at the emphasised sentence's last word plus 6-12 frames. Cut picture
   at most once inside the silence.
7. RETURN THE BED. Prefer: the same track, resumed where it would have been
   (so the arrangement still makes sense), coming back on the next downbeat at
   full level with no fade. Alternative: a 0.5 s (15 f) fade-in. If the
   section has changed, treat the return as a track change and land the new
   track's first beat on the section's first word.
8. DO NOT also GSAP-tween volume on this element - the lane wins and the tween
   is silently ignored.

ACCEPTANCE TEST: (a) at {{T_STOP}} the sub-200 Hz level falls >=10 dB within 6
frames while speech continues; (b) scrubbing the two seconds around the stop
there is no click and no audible fade - the music is simply gone; (c) the
inter-word floor during the silence is between -30 and -40 dBFS, never below
-60; (d) the emphasised line's first stressed syllable begins in existing
silence and the first word is fully intelligible; (e) no aesthetic SFX plays
during the silence; (f) the return lands on a beat; (g) playing the section
without picture, the stop still sounds like it belongs to the music.
```

## Execution spec

**HyperFrames (primary).** Two routes, and the choice determines where the music resumes.

**Route A — a `volume` lane to zero (bed keeps playing silently).** Best for drops under ~6 s, because the track's arrangement continues underneath and the return still makes musical sense.

```html
<!-- bed starts at 12.00s. Drop at composition time 184.30 -> clip-local t = 172.30 -->
<audio id="bed" src="assets/bgm/bed.mp3" data-audio-group="music"
       data-start="12.00" data-duration="330.00" data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.5,&quot;v&quot;:1},
         {&quot;t&quot;:172.30,&quot;v&quot;:1},{&quot;t&quot;:172.40,&quot;v&quot;:0},
         {&quot;t&quot;:174.40,&quot;v&quot;:0},{&quot;t&quot;:174.40,&quot;v&quot;:1},
         {&quot;t&quot;:329,&quot;v&quot;:1},{&quot;t&quot;:330,&quot;v&quot;:0}]}]}"></audio>
```
Read the numbers: `172.30 → 172.40` is the **3-frame (0.10 s)** stop ramp; the silence holds to `174.40` (**2.0 s**); the two points at the same `t` give a hard return on the downbeat. Contract facts that make or break it:
- Automation `t` is **clip-local seconds** — subtract the clip's `data-start` from every composition timestamp. Getting this wrong is the most common way this fails, and nothing lints it.
- A lane **holds its first value backwards to the clip start and its last value forward to the end**, which is why the `{t:0}` point is mandatory.
- The lane and `data-volume` coexist, and the lane's `v` multiplies it — keep the two consistent, or drop `data-volume` and author absolute levels in the lane. A **GSAP `volume` tween does not** coexist: the lane wins silently (`audio_volume_double_automation`), and a tween on a track with authored `data-volume` **replaces** that gain rather than scaling it.
- Write the attribute **double-quoted with `&quot;`** — single-quoted JSON is invisible to `carve.mjs`, which will then overwrite the bed's carve nodes without seeing your envelope.
- **512 points per lane** maximum, and `curve` (−1..1) bends the segment *leaving* a point if you want the ramp shaped rather than linear.
- If the bed has `reverb` or `delay` in its chain, the rendered track is **longer** than `data-duration` (`chainTailSeconds`) — the tail will ring into your silence. That is usually desirable; if it is not, remove the time FX or use Route B.

**Route B — two bed clips with a gap.** Best for drops over ~6 s, or when the bed should resume from a chosen musical position rather than wherever the track happens to be — and the cleaner shape when the resume is a *different* track.

```html
<audio id="bed-1" src="assets/bgm/bed.mp3" data-audio-group="music"
       data-start="12.00" data-duration="172.40" data-track-index="11" data-volume="0.079"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.5,&quot;v&quot;:1},{&quot;t&quot;:172.30,&quot;v&quot;:1},{&quot;t&quot;:172.40,&quot;v&quot;:0}]}]}"></audio>
<audio id="bed-2" src="assets/bgm/bed.mp3" data-audio-group="music"
       data-start="186.40" data-duration="140.00" data-media-start="96.00"
       data-track-index="12" data-volume="0.079"></audio>
```
Two clips, two **unique ids** (an id-less `<audio>` is never mixed → silent render) and **different track indices** if they ever overlap (`duplicate_audio_track`). Clips authored exactly back to back share no frame, because the visibility window is half-open. `data-media-start="96.00"` is how you choose *which part of the track* resumes — pick a bar line.

Either way, the ambience bed is a **separate** clip in the `ambience` group and is untouched by all of this ([[sfx-ambience-bridge-across-cut]]). Aesthetic SFX inside the silence window must be removed, not just lowered.

**ffmpeg.** For finding the accent and verifying the result:
```bash
# transient map of the bed, to locate downbeats/crashes
ffmpeg -i bed.mp3 -af "highpass=f=2000,asetnsamples=n=1600,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
# verify the drop in the final mix
ffmpeg -i final.mp4 -af "ebur128=framelog=verbose" -f null - 2>&1 | grep "S:"
```
Baking is only for a deliverable leaving the pipeline: `ffmpeg -i bed.wav -af "volume=enable='between(t,{{T_STOP}},{{T_RESUME}})':volume=0" bed.gap.wav`. In-composition automation is preferred — do not cut a new file for this.

**Epidemic Sound.** Three uses.
- **Find the accent without a DAW.** `SearchRecordings` returns `bpm` on every recording, which is what makes beat-accurate stopping cheap: read `recording.bpm`, compute `60/bpm`, snap. It also returns `waveformUrl` — a JSON peak array — so you can locate the peak the source tells you to cut on directly.
- **Create an anchor when the bed has none.** If no usable accent sits near the line, fetch a one-shot: `SearchSoundEffects { query.term: "cinematic impact hit deep short" }`, placed on `{{T_STOP}}` with its **peak** on the frame, so the hit both marks the stop and masks it.
- **Build a bed that genuinely ends.** Where the bed has no clean place to stop at all, compose one rather than cutting into a sustain: `EditRecording` (Create Version) with `targetDurationMs` and `forceDuration` will build a version that really ends, then `PollEditRecordingJob` and `DownloadRecordingEdit`. The published editorial preference is a **button ending** over a fade, because a fade *"remove[s] agency from the editor."*

If the resume is a *new* track, `SearchSimilarToRecording` against the outgoing one keeps the change feeling like a modulation rather than a new video. Levels: bed −20 to −25 dB, down to about −30 dB for loud guitar-driven tracks; SFX −12 to −15 dB.

**Remotion.** Conceptually an interpolated `volume` prop on `<Audio>` driven by `useCurrentFrame()`, with the ramp expressed in frames rather than seconds. No Remotion runtime in this project.

## Pairs with
[[sfx-music-fade-out-section-signal]] · [[sfx-music-rest-windows]] · [[sfx-silence-as-pattern-interrupt]] · [[sfx-music-primacy-doctrine]] · [[sfx-music-sets-the-mood]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-riser-anticipation-build]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-beat-aligned-handover]] · [[sfx-layer-volume-targets]] · [[sfx-bpm-filter-first]] · [[sfx-ambience-search-formula]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-split-edit-lead-lag]] · [[sfx-track-reversion-to-edit-length]] · [[sfx-vocal-vs-instrumental-bed]] · [[struct-stimulation-budget]] · [[struct-music-arc-to-narrative-arc]] · [[cut-punch-in-emphasis]] · [[cut-smash-cut-loud-to-quiet]] · [[pace-cut-on-the-beat]] · [[pace-deliberate-continuity-break]]

## Failure modes
- **Cutting to true digital silence.** Dropping everything, ambience included, reads as a dropout or a codec fault under a talking head. Fix: bed out, room tone in, floor at −30 to −36 dBFS.
- **Truncating mid-sustain.** Chops a held note, clicks or leaves a chord hanging, and sounds like a fault rather than a decision — the opposite of the *"feels really smooth, it doesn't feel sudden"* the source is after. Fix: snap the stop onto a transient, bar line or phrase end derived from the track's BPM.
- **A zero-length ramp.** Cutting mid-waveform at a non-zero sample produces an audible click on almost any material. Fix: 1–6 frames, never 0. A few frames of ramp is inaudible as a fade and removes the click.
- **A fade instead of a stop.** Anything over ~12 frames stops reading as emphasis and starts reading as "the section is ending". A slow fade tells the viewer *a section is ending*; a hard stop tells them *this sentence matters*. Using the wrong one inverts the meaning of the moment. Fix: keep it under 6 frames, or accept that you are building a section boundary ([[sfx-music-fade-out-section-signal]]). **Never use a 1-second default fade as a stop** — it reads as running out of track.
- **Cutting off the beat.** The stop draws attention to itself as an edit rather than to the line. Fix: snap to the grid unless a nearby accent gives better pre-roll.
- **Dropping after the line starts, or stopping on the word instead of before it.** If the ramp overlaps the first syllable the viewer hears the music *duck* rather than *stop*, and attributes the change to a glitch rather than to the sentence. Fix: 6–15 frames of pre-roll, ramp landing fully in the gap before the line.
- **Boosting the voice into the gap.** Defeats the point — the effect *is* the absence of everything else, and removing the masker has already raised perceived clarity. Fix: leave the voice level alone.
- **An aesthetic SFX inside the silence.** One whoosh and the silence becomes just a quiet bit. Fix: strip aesthetic accents across the whole window; keep diegetic sound.
- **Overuse.** Four drops in eight minutes and the bed reads as unreliable rather than the silences reading as important; the orienting response habituates fastest under short inter-stimulus intervals. Fix: 1–3 per 10 minutes.
- **Ragged return.** The bed restarting off-grid, mid-bar, or at a different level. Fix: return on a downbeat, at the same level, from a chosen `data-media-start` if using two clips.
- **Known gap:** no published research measures optimal silence duration or ramp length for a music drop; the editing literature on silence is explicitly intuition-based ("until it feels wrong"). The 1–6 frame ramp is derived from temporal-masking figures (post-masking 150–200 ms, pre-masking ~20 ms) plus click-avoidance practice, and the silence window is house calibration at one-sentence scale. Log the measured values from any matched reference and prefer them.
