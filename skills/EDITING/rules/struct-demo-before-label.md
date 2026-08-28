---
id: struct-demo-before-label
title: Play it first, name it second — the demo-before-label module
skill: editing
type: structure
family: demonstration
tags: [skill/editing, type/structure, family/demonstration, layer/sfx, layer/dialogue, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:01:08
    quote: "This sound effect is perfect for fast transitions, movements and dynamic reveals."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:00:30
    quote: "But there are a lot of different types of whoosh — a fast short whoosh, or a long one."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:01:16
    quote: "You can tweak this by changing the pitch. If you push the pitch high, the sound effect will feel a bit lighter, but if you take the pitch low, it'll sound like a really heavy, weighty whoosh."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:08:08
    quote: "Dialogue should be at 0 to -3 decibels, music should be at -20 to -25 decibels, and sound effects should be at -12 to -15 decibels."
research_refs:
  - https://laurenmarg.com/2023/05/03/article-summary-schwartz-bransford-1998-a-time-for-telling-constructivism/
  - https://elifesciences.org/articles/88406
  - https://mytasker.com/blog/the-complete-guide-to-sound-design-for-video-creators
  - https://sites.google.com/site/cognitivetheorymmlearning/segmenting-principle
difficulty: low
detectable_from: transcript+audio
---

# Play it first, name it second — the demo-before-label module

## What it is
An inversion of the standard teaching module. Instead of **name → define → demonstrate**, an audio-first segment runs **demonstrate → name → use case**: the sound is played, in isolation, *before* the viewer is told what it is called. The audio demo does the teaching; the narration only labels the thing that has already been experienced. It works because the label attaches to a percept the viewer already has rather than to an abstraction they have to hold and later fill — the same reason exploration-before-explanation and passive pre-exposure improve category learning. It is also why a video built this way functions as an audio reference: someone scrubbing hears the sound and can decide whether they need the name.

## When to use it
Whenever the thing being taught is **directly perceptible in under about a second and is impossible to describe in words**: a sound-effect family, a transition, an ease curve, a grade, a mix move, a font's feel. The test is blunt — if a competent one-sentence description would tell the viewer nothing they could not get from two seconds of exposure, invert the module. Use the standard **name → define → demonstrate** order ([[struct-name-define-demonstrate]]) instead when the item's *name* is the load-bearing information (a list of ten named cut types where the viewer's goal is vocabulary), when the demonstration needs interpretation the viewer cannot supply unaided, or when items must be findable by name in a chaptered reference. The two modules can co-exist in one video if the choice is made per item type and applied consistently — but do not alternate at random, because the whole benefit of a repeated module is that the viewer stops spending attention on the structure.

## How to recognise it in a reference video
- **Cross the transcript against the audio, because the transcript alone will lie.** Find each item's naming line, then look **backwards** for a non-speech audio event. If a distinct, isolated sound occurs **0.3–2.0 s before** the name is spoken, the module is inverted.
- **Detect the demo windows mechanically.** They are narration gaps that are not silent:
  `node <SKILL_DIR>/scripts/transcript-cut.mjs --input ref.mp4 --transcript ref.transcribe.json --cut-silence 0.5 --plan`
  and read the *removed* ranges — those are the candidate demos. Then check each one is loud:
  `ffmpeg -ss <t> -t <len> -i ref.mp4 -af "astats=metadata=1:reset=4" -f null - 2>&1 | grep RMS_level`
  A real demo sits **within 10 dB of the narration's level**; a dead pause reads −45 dB or lower.
- **Count the hits inside each demo window.** One hit = a single-purpose effect. **Two or three** = the family has axes being taught (short vs long, high vs low pitch), and the axis is usually named right after.
- **Measure demo length.** Individual hits **0.3–1.2 s**; gap between variations **0.25–0.40 s**; whole window **≤4 s**. Windows longer than ~5 s without narration are demonstration *sections*, a different technique ([[pace-silent-demonstration-window]]).
- **Measure demo level against narration.** This is the diagnostic that separates a designed demo from a dragged-in file. Integrated loudness of the demo window should be **within ±1.5 LU of the narration**, which is roughly **9–12 dB louder** than where the same effect sits when mixed under a video (SFX in-mix at −12 to −15 dB against dialogue at 0 to −3 dB). A demo left at in-mix level makes the viewer reach for the volume, and the audience for an audio video will not forgive it twice.
- **Check the bed.** Under a demo the music is normally **stopped or dropped ≥12 dB**. A demo played over a running bed is not a demo, because the viewer cannot isolate what they are supposed to hear.
- **Check the picture.** During an audio demo the picture usually goes *quiet*: a held frame, a waveform, or the on-screen thing the sound belongs to. Busy motion under an audio demo splits attention and is a defect.
- **Check the order of the naming line's parts.** In the inverted module the sentence after the demo is *name → use case* ("this sound effect is perfect for fast transitions, movements and dynamic reveals"), not *name → definition*. If a definition follows, the module has drifted back to the standard order.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `demo_first` | true | — | The whole technique. |
| `demo_count` | 1 | 1–3 | 1 for a single-purpose item; 2–3 only when an axis is being taught, and the axis must be named immediately after. |
| `hit_len` | 0.6 s | 0.3–1.2 s | Per demo hit. |
| `inter_hit_gap` | 0.30 s (9 f) | 0.25–0.40 s | Enough to separate, short enough to compare. |
| `window_total` | 1.8 s | 0.6–4.0 s | Whole demo window. Over 5 s it is a demonstration section, not a demo. |
| `label_delay` | 0.35 s (10 f) | 0.20–0.80 s | Gap between the last demo hit and the first word of the name. |
| `demo_level` | narration ±1.5 LU | ±0–2 LU | ≈ 9–12 dB above in-mix SFX level. Measure, don't guess. |
| `inmix_level` | −13 dB | −12 to −15 dB | Where the same effect sits when actually used. |
| `bed_under_demo` | −∞ (stopped) | stopped, or −12 to −20 dB | Stopped is better for a single hit. |
| `picture_under_demo` | held frame | held frame \| waveform \| the object | No new motion during the window. |
| `label_form` | name + use case | — | Not name + definition. |
| `repeat_at_inmix` | true | — | After the label, play the effect **once more in context** at in-mix level, so the viewer hears both the sound and the job. |
| `module_consistency` | 1.0 | — | Fraction of items using the same module. Mixing modules item-to-item destroys the benefit. |

## Reproduction prompt

```
Build a demo-before-label module for item {{N}} of an audio-first teaching
video.

Timeline, relative to the module's start T:

1. T + 0.00  PICTURE SETTLES. Hold a frame, or show the object the sound
   belongs to, or a waveform. No new motion starts anywhere in the frame for
   the whole demo window.
2. T + 0.00  BED OUT. Stop the music bed, or drop it by at least 12 dB with a
   0.2s ramp. A demo over a running bed is not a demo.
3. T + 0.10  DEMO. Play the effect ONCE, in isolation, 0.3-1.2s long, LEVELLED
   TO THE NARRATION: match the demo window's integrated loudness to the
   narration's within 1.5 LU. That is roughly 9-12 dB hotter than where this
   effect will sit when mixed under a video. Do not use the in-mix level for
   the demo, and do not exceed the narration by more than 2 LU.
   - If and only if the item has an AXIS to teach (short vs long, high vs low
     pitch), play 2-3 variations instead, 0.30s apart, in the order the axis
     will be named. Never more than 3.
4. +0.35s after the last hit  LABEL. Speak the name, then the USE CASE - not a
   definition. Pattern: "<name>. Perfect for <situation A>, <situation B> and
   <situation C>."
5. Then RESTORE the bed and play the effect ONE more time IN CONTEXT at in-mix
   level (-12 to -15 dB against dialogue at 0 to -3 dB), landing its loudest
   frame on the actual visual event it belongs to. The viewer must hear both
   the sound and the job.
6. Use this exact module for every item of this type in the video. Do not
   alternate with name-first.

ACCEPTANCE TEST: (a) measure the demo window and the narration with ebur128 -
within 1.5 LU, or the viewer reaches for the volume; (b) the first word of the
name comes AFTER the last demo hit, frame-checked; (c) nothing else animates
during the demo window; (d) with the narration muted, the demo window is still
clearly audible and isolated; (e) run the same measurement on every item -
consistency across items is what makes the module free to watch.
```

## Execution spec

**HyperFrames.** The module is: one held picture clip, one demo `<audio>` at demo level, one in-context `<audio>` at in-mix level, and a lane on the bed. The two SFX clips are the *same file at two different gains*, which is the cleanest way to guarantee the viewer hears the same thing twice.

```html
<!-- held frame / object under the demo -->
<div id="demo-08-still" class="clip" data-start="196.0" data-duration="6.4" data-track-index="1"></div>

<!-- the DEMO: isolated, at narration level. 0.22 linear = -13 dB is IN-MIX; demo needs ~0.62 = -4 dB -->
<audio id="sfx-08-demo" src="assets/sfx/whoosh-long.wav" data-audio-group="sfx"
       data-start="196.10" data-duration="0.90" data-track-index="12" data-volume="0.62"></audio>

<!-- the LABEL is narration; the IN-CONTEXT repeat sits on the real visual event at 201.40 -->
<audio id="sfx-08-inmix" src="assets/sfx/whoosh-long.wav" data-audio-group="sfx"
       data-start="201.25" data-duration="0.90" data-track-index="13" data-volume="0.22"></audio>

<!-- bed: stopped across the demo window, back for the in-context repeat -->
<audio id="bed-main" src=".media/audio/bgm/bed.mp3" data-audio-group="music"
       data-start="0" data-duration="600" data-track-index="11" data-volume="0.07"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:195.8,&quot;v&quot;:1},{&quot;t&quot;:196.0,&quot;v&quot;:0},{&quot;t&quot;:200.8,&quot;v&quot;:0},{&quot;t&quot;:201.1,&quot;v&quot;:1}]}]}"></audio>
```

Contract points that bind this:
- **Convert dB to linear for `data-volume`:** `v = 10^(dB/20)`. −13 dB = 0.224, −4 dB = 0.631, −6 dB = 0.501. `data-volume` defaults to `1` (0 dB) and boosts to a maximum of **3.98 (+12 dB)** — so if a demo file is quiet, you have 12 dB of headroom before you must re-render the asset.
- The two SFX clips are on **different track indices**; they do not overlap here, but keeping them separate avoids `duplicate_audio_track` if timings move.
- Every `<audio>` needs an `id`, or it is never mixed → **silent render**.
- SFX go in the **`sfx`** group, never `voiceover` — a non-voice clip inside the carve group silently poisons the next carve re-analysis. The carve settings live on the **bed**, and `sources` names a **group**, not clip ids.
- Bed lane `t` is **clip-local seconds** (here the bed starts at 0 so clip-local ≈ composition time — do not assume that in general), and a lane **holds its first value backwards to the clip start**, hence the explicit `t:0`.
- Do not also GSAP-tween `volume` on the bed (`audio_volume_double_automation` — the lane wins).
- The demo's timing and the picture's held frame are coupled only by the author writing the same numbers twice; there is no audio-follows-animation attribute. If the picture lives in a sub-composition at scene-local `t`, the root-level audio needs `data-start = t + slot data-start`.
- **Avoid `reverb`/`delay` on the demo clip.** A tail makes the rendered track longer than `data-duration` (`chainTailSeconds`) and blurs the isolation that is the whole point. The in-context copy is where reverb belongs, if anywhere.
- For the pitch axis, the contract offers **no pitch parameter** — `data-playback-rate` (0.1–5) is **pitch-preserved**, so it changes length, not pitch. A pitched variation must be a **preprocessed file**.
- If several items share a treatment, `<hf-audio-group>` gives one fader and one chain for all of them — but note a **bus's automation `t` is composition time**, not clip time.

**ffmpeg — levelling the demo is the one step you must measure, not eyeball:**

```bash
# narration reference: integrated loudness of a clean narration stretch
ffmpeg -ss 150 -t 20 -i mix.wav -af ebur128=peak=true -f null - 2>&1 | tail -20
# the demo window
ffmpeg -ss 196.1 -t 0.9 -i mix.wav -af ebur128=peak=true -f null - 2>&1 | tail -20
# make a pitched variation for an axis demo (down 3 semitones: 2^(-3/12)=0.8409)
ffmpeg -i whoosh.wav -af "asetrate=48000*0.8409,aresample=48000,atempo=1/0.8409" whoosh.low.wav
# whole-mix delivery target
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
```

**Epidemic Sound.** Fetch the demo file by duration so it needs no trimming, and fetch the *axis* variations as genuinely different files rather than one file processed twice where possible:

```
SearchSoundEffects({ query: { term: "whoosh long air transition" },
                     filter: { duration: { min: 600, max: 1400 } }, first: 10 })
SearchSoundEffects({ query: { term: "whoosh short fast" },
                     filter: { duration: { max: 500 } }, first: 10 })
```
`SearchSimilarToSoundEffect` on the chosen file is the right call for the second variation — it keeps the family recognisable while avoiding the "same sound effect repeated again and again" mistake.

**Remotion:** two `<Audio>` elements with different `volume` props inside `<Sequence>`s; concept only.

## Pairs with
[[struct-name-define-demonstrate]] · [[struct-inverse-pair-teaching]] · [[pace-silent-demonstration-window]] · [[motion-list-item-marker-card]] · [[sfx-whoosh-transition-movement-reveal]] · [[struct-numbered-list-mid-roll-sponsor]] · [[struct-comment-prompt-curiosity-gap]] · [[sfx-riser-anticipation-build]] · [[cut-audio-match]]

## Failure modes
- **Demo at in-mix level.** The most common and most damaging error in an audio teaching video: the effect is played at −13 dB where it belongs *under* a video, the viewer cannot hear it, and they turn the volume up — after which the narration is too loud. Correction: match the demo window to the narration within 1.5 LU, then bring the level back down for the in-context repeat.
- **Demo over a running bed.** The viewer cannot isolate the thing being taught. Correction: stop the bed, or drop it ≥12 dB.
- **Name spoken over the demo.** Both are then unintelligible and neither job gets done. Correction: 0.35 s of clearance after the last hit.
- **Four or more variations.** Comparison collapses past three; the viewer remembers none of them. Correction: 1, or 2–3 only when an axis is named.
- **No in-context repeat.** The viewer learns what the sound is and not what it does, which is the half that changes their edit. Correction: always play it once more on the real visual event at in-mix level.
- **Busy picture under the demo.** Attention splits and the audio is not heard. Correction: hold the frame; no new motion in the window.
- **Module alternated with name-first.** The viewer keeps re-learning the structure and the segmenting benefit is lost. Correction: one module per item type, applied to all items of that type.
- **Definition instead of a use case.** After a demo the viewer already has the percept; a definition is redundant, while the use case is the only new information. Correction: name + where to use it.
- **Known gap:** the demo-level rule (match narration ±1.5 LU) is derived here from the two documented level bands — dialogue at 0 to −3 dB and SFX at −12 to −15 dB — plus general delivery-loudness practice; no published source specifies a *demo* level for an SFX teaching segment. The demo count and hit lengths are likewise house numbers taken from the source video's own cadence. Measure and record them per project rather than trusting them blind.
