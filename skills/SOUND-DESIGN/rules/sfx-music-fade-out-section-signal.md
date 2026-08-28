---
id: sfx-music-fade-out-section-signal
aliases: [sfx-music-fade-out-section-end]
title: Fade the bed out slowly to announce that a section is ending
skill: sound-design
type: music
family: music-stops
tags: [skill/sound-design, type/music, family/music-stops, layer/music, layer/dialogue, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:13:15"
    quote: "What do you think happens when you cut the music abruptly? That sudden change jolts the viewer and grabs their attention."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:13:30"
    quote: "And what if you slowly faded the music out instead? As soon as the viewer notices the music fading, they'll understand that the section they're watching is coming to an end. And that realization gives them anticipation for something new."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:09
    quote: "I usually change the music whenever the section changes, and moving from one track to another is a bit tricky."
research_refs:
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
  - https://en.wikipedia.org/wiki/Fade_(filmmaking)
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://ffmpeg.org/ffmpeg-filters.html#afade-1
  - https://manual.audacityteam.org/man/fades.html
  - https://support.google.com/youtube/answer/9314415
difficulty: low
detectable_from: audio
---

# Fade the bed out slowly to announce that a section is ending

## What it is
A gradual reduction of the music bed to silence, used as **structural punctuation** rather than as a mix correction. The source is precise about the mechanism and it is a two-step one: the viewer *notices* the fade, then *infers* from it that the section is closing, and the inference itself produces anticipation for whatever comes next. That anticipation is the retention payload — the fade buys attention across a chapter boundary, which is exactly where a retention curve dips, because it is where a viewer who has got what they came for decides whether to stay.

The fade is the **soft** member of a family of three stops, and the choice between them is a design decision, not a taste one:

| Stop | Reads as | Owned by |
|---|---|---|
| Hard cut to silence, mid-phrase | A jolt. "Look at this." | [[sfx-silence-as-pattern-interrupt]], [[sfx-music-hard-stop]] |
| Stop landed on a musical accent | Emphasis. "This line matters." | [[sfx-music-hard-stop]] |
| Slow fade to silence | Closure. "This part is over; something new is coming." | **this note** |

The fade is the only one of the three that is *predictive*. A hard stop points at the present moment and spends attention **now**; a fade points forward and spends attention **onward**. That is why it belongs at a boundary and nowhere else.

Two things make a fade legible as a deliberate gesture rather than an accident.

**Length.** It has to run long enough that the decline is perceived as a process. Because the ear needs roughly 6–10 dB of change before it reliably registers a level move, the first third of any fade is effectively invisible — so a 500 ms fade is heard as a stop, and a 1-second fade as a slightly soft cut. The move only works from roughly two seconds up.

**Shape.** A **linear-amplitude** ramp (ffmpeg's default `tri` curve, and what a straight fader move or a two-point lane gives) spends most of its time in the last few dB where nothing is audible any more — it sounds like the music dropped out and then dribbled. Never author one. The two curves that work do different jobs:

- **Logarithmic — constant dB per second.** Perceived loudness is logarithmic, so equal-dB steps sound *even* across the whole fade. Use it when the fade should read as a steady departure, and when you want the bottom to arrive exactly on schedule. This is the safe default.
- **Sigmoid — hold, then decline decisively, then settle.** Use it when the *onset* of the fade needs to be perceptible at a specific beat, because the source's mechanism runs through the viewer **noticing** the fade start. The decisive middle is what gets noticed.

Either way, author it as breakpoints, never as a straight line from 1 to 0.

## When to use it
At a **section boundary** — the end of a chapter, a numbered point, an act, a demonstration, or the whole video. Anywhere your structure document already has a beat marker. Specifically:

- **The next section changes mood and will get a different bed.** The fade closes the old one; [[sfx-track-change-at-section-boundary]] owns the handover that follows. It is the clean way to leave a track when Find Similar has not produced a matching successor.
- **Into a deliberate silence** — the fade lands, a beat of nothing plays, the new section starts. That silence is doing as much work as the fade.
- **The next beat is the CTA, the recap, or the outro** and you want the viewer to feel the video turning ([[struct-closing-recap-single-cta]], [[struct-cta-after-payoff]]).
- **Retention data shows a dip at a chapter boundary.** The fade plus the anticipation it creates is the cheapest available patch, because it converts a "this is over" moment into a "what's next" moment.
- **The section ends on a summarising line** and you want that line to land in progressively clearer air.

Do **not** use it:
- **Mid-section.** It announces an ending that is not coming, which is worse than no signal at all — it breaks the convention for the rest of the video.
- **When you want a jolt.** If the point is to snap attention to a serious line, cut the music dead on a waveform peak instead. Mixing the two up inverts the intent.
- **To solve a bed that is too loud under narration.** That is a carve ([[sfx-music-primacy-doctrine]]).
- **On a bed about to be replaced by a *similar* track**, where a crossfade handover is smoother and the boundary should not be felt.
- **At the very end of the video** unless the video is genuinely over — a full fade to silence reads as the end screen and viewers leave.
- **On every cut, or more than about once every couple of minutes.** Past that it stops meaning "ending" and starts meaning "the editor fades things".

## How to recognise it in a reference video
The whole detection is on the music band, and the discriminations that matter are fade-vs-duck, fade-vs-cut, and fade-vs-the-track's-own-outro.

- **Short-term loudness decline, measured.** Run an EBU R128 trace and read the **S** (3-second sliding window) series across the suspect boundary:
  ```bash
  ffmpeg -i ref.mp4 -af "ebur128=framelog=verbose" -f null - 2>&1 | grep -E "M:|S:"
  ```
  A section-end fade shows a **monotonic S decline of 12–25 LU over 2–5 seconds**, ending at or below the programme's noise floor and **staying there for at least 0.5 s**. A duck shows a decline of only **4–10 LU** that **returns**; a fade does not return. If the same track comes back at level within 10 s, it was a duck or a music rest, not a section signal.
- **Isolate the bed first if the trace is muddy.** `ffmpeg -i ref.wav -af "lowpass=f=250,astats=metadata=1:reset=5" -f null -` separates the bass energy of a bed from speech. A section-end fade shows as a **monotonic decay of 2–6 s ending at or near the floor**.
- **Measure the decay in dB, not in amplitude.** A well-made fade runs roughly **15–25 dB per second** for a 3-second fade to silence. A fade that plummets in the first half second and then crawls is a linear-amplitude fade and reads as a stop with a tail.
- **The dialogue level does not move.** This is the single cleanest discriminator. Compare a windowed RMS of the passage against a speech-only passage: in a fade, the voice holds its level while the bed leaves. If both fall together, you are looking at a master fade or a scene fade, not a music cue fade.
- **Curve shape.** Convert the S series to dB-vs-time and check the middle. A **sigmoid** (slow, then steep, then gentle) and a **constant-dB straight line** are both deliberate studio-style fades. A **straight line in amplitude** — which plots as a decline that accelerates hard only at the very end — is a linear fader move; still deliberate, but a weaker signal. A **step** is a cut, not a fade.
- **Spectral behaviour.** A studio-style fade often loses the top end slightly ahead of the bottom (Audacity's Studio Fade Out is explicitly *"fading out the higher frequencies a little quicker than the lower frequencies"*, for a going-into-the-distance quality). If the spectral centroid falls faster than the level does, the fade was shaped, not just faded.
- **A track's own composed outro is not a fade.** Listen for instruments dropping out **asymmetrically** — drums stop, pad continues — or a final chord/hit. That is an arrangement ending; the level does not decline monotonically and there is usually a terminal transient. A fader fade declines broadband and ends in nothing.
- **Correlate with the transcript.** A genuine section-end fade begins under the **last one or two clauses** of the closing sentence and reaches silence at or just after the final word. If the last word and the start of the fade are more than ~1 s apart, the fade is late and the boundary is mushy; if the fade starts mid-argument, or ends 4 seconds before anyone stops talking, it is a mix decision, not a structural one — log it differently.
- **Check what happens at the bottom.** Three distinct patterns; log which:
  - **fade → silence (0.8–2.5 s) → new track** — the full section signal. The most common and the strongest.
  - **fade → new track enters immediately** — a crossfade, which reads as continuity, not as a boundary. A different move.
  - **fade → silence → no music for the next section** — the fade is doubling as a rest.
- **Look at the picture at the fade's end.** A title card, a hard cut to a new location, a B-roll change or a chapter graphic landing within ±1 s of the fade bottom confirms this is structural rather than a duck.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `fade_length` | 3.0 s (90 f) | 2.0–6.0 s | The one number that decides whether the gesture is legible. Under 2.0 s it reads as a stop, not a departure; above ~6 s the viewer registers the emptiness before they register the direction. |
| `fade_curve` | logarithmic (constant dB/s) | log · sigmoid | **Log** for a steady, even departure — the safe default. **Sigmoid** when the fade's *onset* must be noticed at a specific beat. **Never linear-amplitude**, and never `exp` (it hangs at the top then disappears). |
| `total_attenuation` | 60 dB to silence (v = 0) | 40–70 dB | 60 dB over 3 s = 20 dB/s. Fading to a floor rather than to zero leaves a bed murmuring under the next section; only do that deliberately. |
| `fade_start_vs_last_word` | −2.0 to −2.5 s (60–75 f before the final word) | −4.0 to −1.0 s | Start under the closing clause so the last sentence lands in thinning music. If the closing sentence is shorter than the fade, start the fade under the sentence before it rather than shortening it. |
| `fade_end_vs_last_word` | +0.5 s (15 f after the final word) | −0.5 to +1.5 s | Reaching silence slightly after the last word is what makes the closure feel like the *section's*, not the sentence's, and hands the silence to the boundary. |
| `silence_window` | 1.2 s (36 f) | 0.8–2.5 s (outer 0.5–3.0 s) | The anticipation window, between fade bottom and the next track's first beat. Under 0.8 s the boundary is not felt and the next bed steps on the ending; over 2.5 s the video feels dropped. |
| `next_bed_entry` | on its first main beat | — | Skip the track's warm-up with `data-media-start`; see [[sfx-track-change-at-section-boundary]]. |
| `bed_level_before_fade` | −22 dB (`data-volume` 0.079) | −25 to −20 dB | The level the fade departs from. |
| `high_freq_tilt` | optional | 0 to −6 dB over the fade | Rolling the top off slightly as it goes gives the "moving away" impression — the Studio-Fade-Out trick. |
| `dialogue_level_change` | 0 dB | 0 to +1 dB | The voice must not move. If the voice was carved against the bed, the carve releases naturally as the bed leaves — do not also raise the voice. |
| `fades_per_10min` | 3 | 1–6 | One per genuine structural section, minimum ~60–120 s apart. More than ~6 and the signal stops meaning anything. |

## Reproduction prompt

```
Place a section-end music fade at boundary {{BOUNDARY_TC}} in composition
{{COMP}}, on bed {{BED_ID}}. Cuts are frames at 30fps; HyperFrames time is
seconds.

1. Find {{LAST_WORD}}: the end time, in seconds, of the final spoken word of the
   closing section. Take it from the word-level transcript, not by ear. Find the
   first beat of the next section's first shot; call it {{NEXT_IN}}.
2. Compute, in composition seconds:
     fade_start   = {{LAST_WORD}} - 2.5      (75 frames before the last word)
     fade_end     = {{LAST_WORD}} + 0.5      (15 frames after it)
     next_bed_in  = fade_end + 1.2           (36-frame anticipation window)
   Total fade length must land at 3.0 s +/- 0.5 s. If the closing sentence is
   shorter than 2.5 s, start the fade under the sentence BEFORE it rather than
   shortening the fade. If {{NEXT_IN}} - fade_end < 0.8 s, move the next track
   later - never move the fade earlier.
3. CHOOSE THE CURVE. Logarithmic (constant dB/s) unless the fade's start must be
   noticed on a particular beat, in which case sigmoid. Never a straight line
   from 1 to 0.
4. Author the fade as a volume automation lane on {{BED_ID}}, with t in
   CLIP-LOCAL seconds (t = 0 is the bed's own data-start, not the composition's).
   Use five breakpoints, not two:
     LOGARITHMIC - equal 15 dB steps:
       hold at level until fade_start, then v = 0.178, 0.0316, 0.0056, 0
       at 25%, 50%, 75%, 100% of the fade.
     SIGMOID - hold, decline, settle:
       hold at level until fade_start, then v = 0.85, 0.45, 0.12, 0
       at 15%, 50%, 80%, 100% of the fade.
   A lane holds its FIRST value backwards to the clip start, so the first point
   must be an explicit "no change" point at the bed's normal level.
5. Set the bed clip's data-duration so it ends at fade_end. Do not leave the file
   running silently past the fade.
6. Do NOT also GSAP-tween volume on this element - a volume lane plus a volume
   tween is lint audio_volume_double_automation and the lane wins silently. Do
   NOT change the dialogue level anywhere in the fade.
7. Leave the anticipation window empty of MUSIC. Ambience and dialogue continue;
   if the room goes to digital silence, place a low room-tone bed.
8. Start the next track ON its main beat, not on its file head - trim the
   warm-up with data-media-start. Do NOT crossfade: a crossfade reads as
   continuity and destroys the boundary this move exists to create.

ACCEPTANCE TEST: render the section and run
  ffmpeg -i {{OUT}} -af "ebur128=framelog=verbose" -f null -
Confirm short-term (S) loudness declines monotonically by at least 12 LU across
the fade, reaches the floor within 0.5 s of {{LAST_WORD}} + 0.5, and stays there
for the full anticipation window. Then listen once at full speed, from 8 s
before {{LAST_WORD}} to 4 s after {{NEXT_IN}}, without looking at the timeline:
you should be able to say "that part ended" at the right moment. If instead you
notice the music STOPPING, the fade is too short. If you notice nothing, it is
too long or too quiet. The final word must be fully intelligible over the
thinning bed, and the silence window must be audible as silence - if the next
track's first beat lands inside the fade tail, the boundary is lost.
```

## Execution spec

**HyperFrames (primary).** The fade is a `data-automation` `volume` lane on the bed clip. Two facts govern the authoring and both are silent-failure sources:

1. **`t` is clip-local seconds**, not composition seconds. A bed at `data-start="84"` has `t: 0` at composition time 84.
2. **A lane holds its first value backwards to the clip's start and its last value forward to the end.** Without an explicit "still at full level" point, the bed starts out already fading.

JSON attributes must be **double-quoted with the JSON's own quotes as `&quot;`** — a single-quoted attribute is invisible to `carve.mjs`'s `name="..."` regex, and a later carve will silently overwrite work it could not see.

```html
<!-- LOGARITHMIC fade: five points at equal 15 dB steps.
     Bed enters at 84.0s; section's last word ends at 131.4s composition time
     (clip-local t = 47.4). Fade 44.9 -> 47.9 (3.0s = 90f); bed ends at 47.9. -->
<audio id="bed-sec2" src="assets/bgm/sec2.mp3"
       data-audio-group="music"
       data-start="84" data-duration="47.9" data-media-start="6.4"
       data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},
         {&quot;t&quot;:44.9,&quot;v&quot;:1},
         {&quot;t&quot;:45.65,&quot;v&quot;:0.178},
         {&quot;t&quot;:46.4,&quot;v&quot;:0.0316},
         {&quot;t&quot;:47.15,&quot;v&quot;:0.0056},
         {&quot;t&quot;:47.9,&quot;v&quot;:0}]}]}"></audio>

<!-- SIGMOID alternative for the same fade window, when the fade's ONSET must be
     noticed on the beat at 44.9:
       {t:44.9,v:1}, {t:45.35,v:0.85}, {t:46.4,v:0.45}, {t:47.3,v:0.12}, {t:47.9,v:0} -->

<!-- Next bed enters 1.2s later, on its first main beat (warm-up skipped). -->
<audio id="bed-sec3" src="assets/bgm/sec3.mp3"
       data-audio-group="music"
       data-start="133.1" data-duration="52" data-media-start="4.8"
       data-track-index="12" data-volume="0.079"></audio>
```

Notes on the shapes above: `v` is 0..1 **volume** (amplitude), and the lane interpolates in the parameter's own unit, which is linear — so a constant-dB fade can only be produced by authoring equal-dB *breakpoints*. `0.178` is −15 dB, `0.0316` is −30 dB, `0.0056` is −45 dB. The sigmoid's `0.45` is roughly −7 dB and `0.12` roughly −18 dB: already audible at 15 % of the fade, settling into the last few dB without a cliff. The `curve` field (−1..1) bends the segment *leaving* a point and can smooth the corners further (`viaX`/`viaY` supersede it), but explicit points are self-documenting and survive review; the cap is 512 points per lane, so cost is not a consideration.

Constraints to respect:
- `data-volume` is the **baseline** the lane's 0..1 rides on, and the lane is **absolute** on the same parameter — do not add a GSAP `volume` tween (`audio_volume_double_automation`, the lane wins and the tween is silently ignored; and `audio_volume_tween_overrides_gain`, a tween is absolute and replaces the authored gain rather than scaling it).
- Every `<audio>` needs an `id` or it is **never mixed** — a silent render with no error.
- Keep beds and voices on a high `data-track-index` (10+), and keep two overlapping `<audio>` off the same index (`duplicate_audio_track`).
- If the bed carries a `reverb` or `delay` node, its rendered tail runs past `data-duration` by `chainTailSeconds` — expected, not a bug, but it eats the silence window. Budget it, or shorten the fade and lengthen the gap.

**Epidemic Sound — the better answer than fading, when you have time.** A fade is a graceful way to leave a track that does not end where you need it to. `EditRecording` (the catalogue's Create Version) will build a version that genuinely *ends* at your section length, with a composed outro instead of an amputation:

```
EditRecording {
  id: <recording uuid>,
  input: {
    targetDurationMs: 87000,          # max 300000
    forceDuration: true,
    downloadAudioFormat: WAV,
    preferenceRegions: [ { startMs: 0, endMs: 12000, preferenceType: AVOID } ]   # skip the warm-up
  }
}
PollEditRecordingJob { ... }          # status PENDING -> IN_PROGRESS -> COMPLETED
DownloadRecordingEdit { input: { jobId: <job>, editId: <edit> } }
```
Use `requiredRegionsAtOffsets` when a specific musical moment must land on a specific beat of your section. **A composed ending plus a 1.0 s fade over the last bar beats a 3 s fade over an arbitrary middle-of-track passage every time.** If the section's bed is shorter than the section, `EditRecording` with `loopable: true` extends it without a seam — extend before you fade, never fade early to hide a short file.

For the successor track: `SearchSimilarToRecording { id }` for a smooth vibe-preserving change, or a fresh `SearchRecordings` with a different `moodSlugs` filter when the section's emotion genuinely changes. `SearchRecordings` takes `filter.bpm {min,max}`, `filter.moodSlugs`, `filter.featuredInstrumentSlugs`, `filter.taxonomySlugs` and `filter.vocals`.

**ffmpeg.** Only when the bed is being baked outside the composition; in-composition is the right place. The curve names are real filter arguments:
```bash
# 3.0s logarithmic fade to silence starting at 84s into the bed file
ffmpeg -i bed.wav -af "afade=t=out:st=84:d=3:curve=log" bed.faded.wav
# 3.0s sigmoid alternative
ffmpeg -i bed.mp3 -af "afade=t=out:st=84:d=3.0:curve=losi" bed.faded.wav
```
`afade` exposes a large curve set — `tri` (linear), `log`, `exp`, `qsin`, `hsin`, `esin`, `cub`, `par`, `losi` and more. `log` matches the perceptual behaviour described above; `losi` (logistic sigmoid) and `hsin` (half sine) are the S-curves. Never `exp` for a section-end fade. `acrossfade=d=<sec>:curve1=<c>:curve2=<c>` bakes a two-bed handover, but prefer authoring the gap in the composition so it stays editable — and remember a crossfade is the wrong move here anyway.

**Remotion:** the same envelope is an `interpolate()` over frames driving an `<Audio volume>` prop; concept identical, no runtime in this project.

## Pairs with
[[sfx-music-rest-windows]] · [[sfx-music-hard-stop]] · [[sfx-silence-as-pattern-interrupt]] · [[sfx-track-change-at-section-boundary]] · [[struct-music-arc-to-narrative-arc]] · [[cut-fade-to-black]] · [[cut-fade-bookend]] · [[motion-fade-to-black-ramp]] · [[struct-closing-recap-single-cta]] · [[sfx-music-primacy-doctrine]] · [[sfx-riser-anticipation-build]] · [[sfx-bpm-filter-first]] · [[sfx-track-reversion-to-edit-length]]

## Failure modes
- **The fade is too short.** Anything under ~2 s is heard as a soft cut and signals nothing; the viewer gets the jolt without the anticipation. Fix: 3.0 s default, and start it earlier rather than making it faster. If the section will not accommodate it, use the abrupt stop deliberately instead.
- **The fade is too long.** Past ~6 s the boundary stops feeling like a boundary and the section just runs out of energy. Fix: cap at 6 s; if the closing beat genuinely needs longer, you want a musical outro, not a fader move.
- **A linear-amplitude fade.** Sounds like the music vanished and then trailed, because perceived loudness is logarithmic. Fix: equal-dB breakpoints, or a sigmoid.
- **Fading under live narration that continues.** The viewer reads "section ending" and the speaker keeps going for another minute. This is worse than no signal — it breaks the convention for the rest of the video. Fix: the fade must terminate at or just after the section's last word.
- **Fading after the section's last word.** Puts the signal *after* the thing it was supposed to introduce, so the anticipation arrives too late to be spent. Fix: the fade starts under the closing sentence.
- **Crossfading into the next track.** Reads as continuity; destroys the boundary the fade exists to mark. Fix: leave 0.8–2.5 s of real silence.
- **Fading at every boundary.** Used more than about once every two minutes, the fade becomes the editor's tic and stops carrying meaning. Fix: budget them; alternate with the hard stop and the similar-track handover.
- **Leaving the anticipation window at digital silence.** Music gone *and* room tone absent reads as a dropout or a corrupt file. Fix: ambience continues through the gap; check with `silencedetect=n=-45dB:d=0.3` that the gap sits at −45 to −60 dBFS and not at the noise floor.
- **A first breakpoint that is not at `t: 0`.** The lane holds its first value backwards, so a lane whose first point is the fade's start silently plays the bed at that level from its very beginning. Fix: always write an explicit `{t:0, v:1}` point.
- **Starting the next track on its file head.** Every track has a warm-up; the new section then begins with an ambiguous swell instead of a beat. Fix: trim into the source with `data-media-start`, or `AVOID` the intro region in `EditRecording`.
- **Forgetting the reverb tail.** A bed with `reverb` in its chain rings past its `data-duration`, eating the silence window. Fix: shorten the fade or lengthen the gap.
- **Known gap:** the 2–6 s band and the 0.8–2.5 s silence window are practitioner conventions calibrated against the "must be perceived as a fade" mechanism the source describes; no cited study fixes them. The defensible parts are the logarithmic curve (perceived loudness is logarithmic) and the equal-dB breakpoint construction.
- **Known gap:** nothing in this stack validates automation lanes. Lint reads `data-automation` for exactly two conflicts and *"nothing validates the chain or the effect lanes at all"*. The only real verification is a render plus an `ebur128` trace plus listening — and the render is browser-dependent, so it must happen off the authoring VM.
