---
id: sfx-av-sync-binding-window
title: Motion without sound reads as fake — and the sync window that makes sound believable
skill: sound-design
type: sfx
family: motion-sfx
tags: [skill/sound-design, type/sfx, family/motion-sfx, sfx/motion, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:04:10"
    quote: "Now when there's motion happening, our brain expects that a sound is going to come. But when that sound doesn't come, the video feels really hollow, really fake."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:04:04"
    quote: "Then the second most important sound effect is for motion. Like a transition, an animation in motion graphics, or some text effect."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:04:17"
    quote: "So should I slap a whoosh on every single motion? You don't put a whoosh on everything."
research_refs:
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://tech.ebu.ch/docs/techreview/trev_2009-Q1_HD-Audio-Delays.pdf
  - https://journals.plos.org/ploscompbiol/article?id=10.1371%2Fjournal.pcbi.1003743
  - https://link.springer.com/article/10.1007/s00221-013-3507-3
  - https://sonilo.com/blog/guides/transition-effect-sound-video-edits
  - https://en.wikipedia.org/wiki/Audio_sync
difficulty: medium
detectable_from: transcript+video
---

# Motion without sound reads as fake — and the sync window that makes sound believable

## What it is
The perceptual justification for motion SFX, and the tolerance that governs them. **The principle:** seeing something move creates an *expectation* of sound; when no sound arrives, the absence is not neutral — it is registered as wrongness the viewer cannot localise, which is why an unsounded motion-graphics edit is described as *"really hollow, really fake."* **The tolerance:** the expectation is satisfied inside a window, not at a point, and the window is **strongly asymmetric**. Sound arriving slightly *after* the visual is what physics does — light beats sound to the eye — so the brain absorbs a lag readily; sound arriving *before* the visual is physically impossible and is caught almost immediately. The broadcast measurement of that asymmetry is published: detectability thresholds are about **+45 ms sound advanced to −125 ms sound delayed**, and acceptability about **+90 ms to −185 ms**. The multisensory-integration literature reports the same shape for speech — an integration window from roughly **30–50 ms auditory lead to 170–200 ms visual lead** — and finds the window **larger and more symmetrical for speech than for simple non-speech events**, meaning a discrete graphic hit is judged *more* harshly than a talking face. Convert to frames at 30 fps (1 f = 33.3 ms) and the whole thing becomes a placement rule: **sound may sit up to about 3 frames late and must never sit more than 1 frame early.**

**Style.** Filed `sfx/motion` — the window exists because something moved on screen and the eye is waiting for the sound. The same tolerance governs diegetic Foley, where the visible contact frame plays the part of the motion event ([[sfx-foley-three-element-checklist]]).

## When to use it
This note governs **every** placement of a motion sound: transitions, text entrances, graphic builds, scale changes, punch-ins, swipes, counters, bar fills, cursor moves, and any diegetic action whose sound is being re-created rather than recorded. Apply the window whenever you write an SFX `data-start`, and apply it as an audit whenever a rendered edit "feels off" without an identifiable cause. It also governs the deliberate exceptions: an **anticipation** sound (a whoosh or riser that *leads* the visual) is a different device with a different rule — it must lead by **more than 6 frames** so it reads as a build rather than as bad sync, never by 2–5 frames, which is the uncanny middle. And it governs its own limit: the source immediately qualifies the principle — *"You don't put a whoosh on everything"* — so this note is the *placement* rule, while whether a given motion deserves a sound at all belongs to [[sfx-unsounded-motion-audit]] and the budget belongs to [[sfx-sound-pass-order]].

## How to recognise it in a reference video
- **Build the two traces and subtract them.** Motion onsets from an inter-frame difference; sound onsets from per-frame RMS. `n=1600` samples at 48 kHz is exactly one frame at 30 fps.
  ```bash
  ffmpeg -i ref.mp4 -vf "tblend=all_mode=difference,signalstats,\
  metadata=print:key=lavfi.signalstats.YAVG:file=motion.txt" -f null -
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
- **Log the offset distribution, in frames.** For every motion event, `offset = sound_onset − motion_onset`. This distribution *is* the reference's sync discipline. A finished edit clusters at **0 to +2 f**, standard deviation under ~1.5 f. Everything else is diagnosable:
  | Offset | Reads as | Verdict |
  |---|---|---|
  | −6 f or earlier (< −200 ms) | anticipation / build | deliberate, a different device |
  | −5 to −2 f (−167 to −67 ms) | wrong, unlocatable | **the uncanny band — never author here** |
  | −1 f (−33 ms) | tight | acceptable, at the edge of detectability (+45 ms threshold) |
  | 0 to +2 f (0 to +67 ms) | locked | **the target** |
  | +3 f (+100 ms) | slightly loose | still inside the −125 ms detectability threshold |
  | +4 to +5 f (+133 to +167 ms) | audibly late | detectable, still "acceptable" by the broadcast threshold |
  | +6 f or later (> +200 ms) | a separate event | broken |
- **Compute the coverage ratio too**, because an offset distribution is meaningless if half the motions have no sound: sounded motion events ÷ total motion events. Motion-graphic-heavy references run **0.75–0.95**; unsounded edits run 0.1–0.3.
- **Separate cuts from motion** before classifying, or transitions will pollute the distribution: `ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null -` and subtract those timecodes.
- **Check whether the offset is systematic.** A whole video sitting at +4 f is an **encode or delivery** problem (an A/V offset baked into the file), not an editorial one. Test by measuring a known-sync event — a clap, a lip-sync plosive — and comparing. A systematic offset must be corrected globally with `itsoffset`, not per event.
- **Check the attack, not just the onset.** A sound whose file has 30–120 ms of lead-in before its transient will *measure* on time and *sound* late. Compare the RMS onset frame against the peak frame: a gap greater than **2 f** between them means the file needs trimming, not moving.
- **Judge speech more leniently and graphics more strictly.** The research finding is directly usable: the binding window for speech is wider and more symmetrical than for simple non-speech events, so a lip-sync offset of +3 f may pass while a text-slam at +3 f reads as loose. Score them against different tolerances.
- **Level tells you what kind of sound it is.** Motion SFX sit **−12 to −15 dB** against dialogue at 0 to −3 dB. Anything louder is a hit or an impact, and hits are judged more strictly still because their transient is sharp.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `sync_offset` | +1 f (+33 ms) | 0 to +2 f | Sound onset relative to visual onset. The house target. |
| `max_lag` | +3 f (+100 ms) | +2 to +4 f | Inside the published −125 ms detectability threshold. |
| `max_lead` | −1 f (−33 ms) | −1 to 0 f | The +45 ms advanced-sound detectability threshold is ~1.35 f. Never author a 2–5 f lead. |
| `forbidden_band` | −5 to −2 f | — | The uncanny middle: too early to be physical, too late to be anticipation. |
| `anticipation_lead` | −12 f (−400 ms) | −24 to −6 f | For a deliberate whoosh/riser build. Must clear the forbidden band by a margin. |
| `speech_tolerance` | ±3 f | −1 to +5 f | Speech binds over a wider, more symmetrical window than discrete events. |
| `graphic_tolerance` | ±2 f | −1 to +3 f | Discrete non-speech events are judged more strictly. |
| `transient_lead_in` | ≤ 2 f | 0–2 f | Gap between a file's start and its peak. Trim with `data-media-start` if larger. |
| `coverage_ratio` | 0.85 | 0.75–0.95 | Sounded motion events ÷ total. 1.0 across hundreds of events is overload, not diligence. |
| `sfx_level` | −13 dB | −12 to −15 dB | Motion band. Impacts/hits may sit 2–4 dB above. |
| `music_duck_on_hit` | −4 dB | −3 to −6 dB | Under a transition or impact sound, quick recovery. |
| `systematic_offset_limit` | 1 f | — | Above this across the whole file, fix globally with `itsoffset`, not per event. |

## Reproduction prompt

```
Place motion sound effects to the audiovisual binding window.

RULE: sound may arrive slightly AFTER its visual, never meaningfully before.
Target offset +1 frame (+33ms). Hard bounds: -1 frame to +3 frames. The band
from -5 to -2 frames is FORBIDDEN - it is too early to be physical and too
late to read as anticipation, and it is the single most common cause of a
video that "feels off" for no nameable reason.

For each motion event:
1. FIND THE VISUAL ONSET FRAME. For an authored animation this is the tween's
   start position on the timeline; for footage, the first frame of the inter-
   frame difference run. Record it in seconds.
2. TRIM THE SOUND FILE so its transient is at frame 0 of the clip. Measure
   the gap between the file's start and its peak; if it exceeds 2 frames,
   offset into the media rather than moving the clip. A file with a long
   lead-in placed raw will measure on time and sound late.
3. SET THE CLIP START to visual_onset + 0.033 (one frame). If the visual and
   the sound are both authored, write the same number in both places - there
   is no automatic binding between an animation and its audio.
4. IF THE VISUAL IS INSIDE A SUB-COMPOSITION, the root-level audio start is
   scene-local time PLUS the sub-composition slot's own start. Getting this
   wrong is the second most common sync bug.
5. SET LEVEL to -13 dB (about 0.22 static gain) for a motion sound; duck the
   music bed 4 dB across it with a quick recovery.
6. FOR A DELIBERATE ANTICIPATION SOUND (a riser or whoosh that builds INTO
   the visual), lead by at least 12 frames (0.40s) and land its peak on the
   visual onset. Never lead by 2-5 frames.
7. JUDGE BY TYPE. A graphic slam, a counter tick or an impact must land within
   -1 to +3 frames. Speech and lip-sync tolerate -1 to +5 frames.
8. CHECK FOR A SYSTEMATIC OFFSET FIRST. If every event in the render is late
   by the same amount, the file has an A/V offset - fix it globally, do not
   move fifty clips.

ACCEPTANCE TEST: (a) measure offset for every sounded motion - all within -1
to +3 frames, none in the -5 to -2 band; (b) coverage ratio between 0.75 and
0.95; (c) frame-step three events and confirm the sound's first audible
sample is on or just after the first moving frame; (d) watch once at full
speed with eyes closed then once muted - neither pass should surface an event
the other did not.
```

## Execution spec

**HyperFrames (primary), and the critical fact is stated plainly in the contract: there is no audio-follows-animation attribute.** *"The two are coupled by the author writing the same number twice: the tween's timeline position and the `<audio data-start>`."* All times are **seconds**; 1 f @30fps = `0.033`.

```html
<!-- text slam at composition time 31.20s; sound one frame later at 31.233 -->
<audio id="sfx-slam-1" src="assets/sfx/impact-soft-01.wav"
       data-audio-group="sfx"
       data-start="31.233" data-duration="0.60" data-media-start="0.04"
       data-track-index="15" data-volume="0.22"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.45,&quot;v&quot;:1},{&quot;t&quot;:0.60,&quot;v&quot;:0}]}]}"></audio>
```
```js
// the visual event: same number, written again. 0.13s = 4f, punch entrance.
tl.fromTo("#headline", { scale: 1.4, autoAlpha: 0 },
                       { scale: 1, autoAlpha: 1, duration: 0.13, ease: "power4.out" }, 31.20);
```
`data-media-start="0.04"` is the transient trim — 40 ms of lead-in removed from the file so its attack sits at clip frame 0.

**The sub-composition offset, which is where this most often breaks.** A sub-comp's internal timeline runs from the host slot's `data-start`, and its own clip times are **scene-local**. Audio lives at the **host root** (so playback survives scene cuts), so:
```
audio data-start = scene-local tween position + host slot data-start
```
A slam at scene-local `2.40` inside a slot starting at `28.80` needs `data-start="31.233"` (`28.80 + 2.40 + 0.033`). Relative timing can express part of this — `data-start="el-scene-3 + 2.433"` — but **spaces around the operator are required**, an unresolved reference **resolves to 0 with no error**, a target with no resolvable duration lands the reference on the target's **start**, and a cycle resolves to 0. Nothing in lint checks any of it. For sync-critical audio, prefer absolute seconds and verify with `snapshot`.

Other contract facts in play:
- **Every `<audio>` needs an `id`** or it is never mixed → **silent render**, with no warning. An entire unsounded pass can be one missing id.
- **Overlapping `<audio>` sharing a `data-track-index`** raises `duplicate_audio_track`; SFX belong on 12–15, above visuals.
- **A `volume` lane's `t` is clip-local and holds its first value backwards** — hence the explicit `{t:0}` point.
- **Never both a lane and a GSAP `volume` tween** on one track (`audio_volume_double_automation`).
- **JSON audio attributes must be double-quoted with `&quot;`** to survive `carve.mjs`'s regex.
- **`reverb`/`delay` add `chainTailSeconds`**, so a treated SFX renders longer than its `data-duration` — expected, but it means a tail can bleed into the next event.
- **Determinism:** the tween must be on the seekable `tl`, never a bare `gsap.to()` — *"standalone tweens run on wallclock and are absent from the render."* An SFX perfectly synced to a wallclock tween is synced to nothing.
- **Land the animation's end state slightly before the clip's `data-duration`**, per the half-open window, or its final frame never renders and the sound outlives the picture.

**ffmpeg.** Three jobs, in order of value.
```bash
# 1. Measure the transient lead-in of an SFX file (peak frame vs first audible frame)
ffmpeg -i impact.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null

# 2. Trim the lead-in physically, when the file is reused everywhere
ffmpeg -i impact.wav -ss 0.04 -c:a pcm_s16le impact_tight.wav

# 3. Correct a SYSTEMATIC A/V offset in a source file (audio 100 ms late -> pull it early)
ffmpeg -itsoffset -0.100 -i src.mp4 -i src.mp4 -map 0:v -map 1:a -c copy fixed.mp4
```
There is **no automatic waveform sync or drift correction** in this stack, and **no rate envelope** (`data-playback-rate` is a constant in 0.1..5) — a retimed shot's sound must carry the *same* `data-start`, `data-duration`, `data-media-start` **and** `data-playback-rate`, using the contract's arithmetic: *consumed source = timeline duration × rate*.

**Epidemic Sound.** Fetch by function, then vary rather than re-fetch — the three parameters that turn one file into many are **reverb, pitch and duration**:
- text/graphic entrance: `SearchSoundEffects { query.term: "subtle ui pop transition short", filter.duration { max: 1200 } }`
- transition: `{ query.term: "fast whoosh swoosh short" }`
- impact/slam: `{ query.term: "soft cinematic impact hit sub" }`
- anticipation: `{ query.term: "riser build tension short" }`
`SearchSimilarToSoundEffect` gives the variants that keep a coverage ratio near 0.85 without the same file appearing forty times. Everything goes in an `sfx` group — never the `voiceover` carve group.

**Remotion:** conceptually `<Audio>` with a `from` frame derived from the same constant the animation uses; no Remotion runtime exists in this project.

## Pairs with
[[sfx-unsounded-motion-audit]] · [[sfx-sound-pass-order]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-riser-anticipation-build]] · [[sfx-riser-to-music-drop-backtiming]] · [[cut-full-screen-transition]] · [[sfx-placement-discipline]] · [[cut-audio-match]] · [[pace-cut-on-the-beat]] · [[motion-look-finishing-pass]]

## Failure modes
- **Sound placed 2–5 frames early.** The forbidden band. Nobody can name what is wrong; the video simply feels cheap. Fix: 0 to +2 frames, or commit to a real anticipation lead of 12+ frames.
- **Ignoring the file's lead-in.** The clip starts on the right frame and the transient arrives 3 frames later. Fix: measure peak vs onset and trim with `data-media-start`.
- **Fixing a systematic offset one clip at a time.** Fifty edits that should have been one `itsoffset`. Fix: measure a known-sync event first and decide global vs per-event before touching anything.
- **Forgetting the sub-composition offset.** Scene-local time written into a root-level audio clip puts every SFX in the scene at the wrong absolute time. Fix: `scene-local + slot data-start`, and snapshot to verify.
- **Syncing to a wallclock tween.** A bare `gsap.to()` is absent from the render, so the sound lands against nothing. Fix: everything on the seekable `tl`.
- **Treating the principle as "sound everything."** The source's own next line is *"You don't put a whoosh on everything"*; a tick every second tires the viewer within two or three minutes. Fix: coverage 0.75–0.95, and delete about half the transition sounds on a second pass.
- **One file everywhere.** Perfect sync, identical sound, audible within a minute. Fix: vary reverb, pitch and duration.
- **Judging graphics by speech tolerance.** A text slam at +4 frames reads loose even though a lip-sync at +4 frames would pass. Fix: separate tolerances per event type.
- **A missing `id` on an SFX `<audio>`.** The sound is never mixed and the render is silent, with no warning at all — indistinguishable from having forgotten the sound. Fix: id on every audio element, and verify by listening to the render.
- **Known gap:** the render's browser-hosted audio path (`OfflineAudioContext` in headless Chrome) cannot run on this linux ARM64 VM without sudo, so **sync can be authored here but must be verified on another host**. Never sign off a sync pass on measurements alone — the acceptance test requires listening to a real render.
