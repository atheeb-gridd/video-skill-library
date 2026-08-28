---
id: sfx-demo-clip-loudness-handover
title: Hand the dialogue slot to the demonstration clip — and match its loudness
skill: sound-design
type: mix
family: dialogue-edit
tags: [skill/sound-design, type/mix, family/dialogue-edit, engine/ffmpeg, engine/hyperframes, engine/epidemic, sfx/diegetic, layer/dialogue, layer/music, layer/ambience, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:04:17
    quote: "Cutting on action is another very common technique used by editors, and it helps make the cuts feel smoother and more natural to the viewer."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:02:41
    quote: "You know, I don't mind rose, man. You know, but there was a rose that saved the day. It was delightful."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:01:43
    quote: "Mama said they'd take me anywhere. She said they was my magic shoes."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:05:17
    quote: "Little man, I give the watch to you."
research_refs:
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Room_tone
difficulty: high
detectable_from: audio
---

# Hand the dialogue slot to the demonstration clip — and match its loudness

## What it is
After defining a technique, the source video stops narrating and lets the example clip play with its own sound — at 00:04:17→00:04:35 for cutting on action, and again at 00:01:27, 00:01:43, 00:03:53 and 00:05:19, where film clips play their own dialogue. The editorial reasoning is [[pace-silent-demonstration-window]]. **This note is the sound problem the window creates**, which is a different and harder problem than deciding to have the window at all.

For the duration of a demonstration, the **dialogue slot changes owner**. Your narration vacates it and the clip's audio takes it — and that clip was mastered by someone else, for a different medium, to a different standard. Film dialogue is mixed quiet under loud music and effects; a trailer is mastered hot; a screen recording has no dialogue at all and a UI click at −40 dB. Dropping any of them into a slot calibrated for your voice at 0/−3 dB produces one of two failures within a frame of the window opening: the viewer reaches for the volume, or the demonstration is inaudible.

The fix is a measurement, not a fader: measure the **speech portion** of the incoming clip, not its integrated loudness, and match *that* to your narration's speech loudness. An action-film clip's integrated loudness is dominated by explosions; normalising to it makes the dialogue whisper.

## When to use it
- **Every inserted third-party clip that carries speech** — a film clip, another creator's video, an interview grab, an archive clip.
- **Every demonstration window** where the clip's own audio is the content: a sound effect being demonstrated, a J cut being heard, a before/after comparison.
- **Every screen recording**, which is the inverse problem: almost no level, and a floor that steps hard against your narration's room.
- **Before the window, not after the mix.** The handover is authored, not fixed later: your bed has to stop, the clip's level has to be set, and your narration has to resume — three decisions at two frames.
- **Not on B-roll you shot**, which has no separate loudness identity and is handled by [[sfx-foley-replacement-pass]].
- **Not on a clip you are using muted** as pure visual. That is a picture decision.
- **Not by normalising the whole clip to a single target.** A clip with dialogue *and* music needs its dialogue matched and its music constrained separately, which is two numbers.

## How to recognise it in a reference video
- **Find the windows from the transcript, then measure the audio inside them.** Two narration cues separated by ≥3 s with picture running is the window; the audio inside it tells you whether it was handled:
  ```bash
  # narration's own speech loudness, from a narration-only stretch
  ffmpeg -ss <n_in> -t 20 -i ref.mp4 -af loudnorm=I=-16:print_format=json -f null - 2>&1 | tail -20
  # the window's loudness
  ffmpeg -ss <w_in> -t <w_len> -i ref.mp4 -af loudnorm=I=-16:print_format=json -f null - 2>&1 | tail -20
  # and the window's SPEECH loudness only, gated harder to exclude music/effects
  ffmpeg -ss <w_in> -t <w_len> -i ref.mp4 -af "highpass=f=120,lowpass=f=6000,astats=metadata=1:reset=1" -f null - 2>&1 | grep RMS_level
  ```
- **The number to log is the delta.** `window_speech_LUFS − narration_LUFS`:
  - **within ±2 LU** → matched. Competent, and the target.
  - **−3 to −8 LU** → the demonstration is quieter than the host. Very common; reads as "I had to lean in".
  - **+3 LU or more** → the clip is louder than the host. The worst case, because the viewer's reflex is the volume control and they may not put it back.
- **Check the bed at the window's first frame.** Does the host's music stop, duck, or run through? A bed running under a film clip that has its own score is the giveaway of an unhandled window — two pieces of music at once.
- **Check the floor at both seams.** The window's in-point and out-point are two edits between two different recordings. A step in the noise floor at either is audible; a continuous floor means the host laid ambience across the window ([[sfx-missing-ambience-audit]]).
- **Check the true peak.** A clip mastered for cinema can peak far above the host's ceiling and clip on the delivery encode. Measure: `ffmpeg -i ref.mp4 -af astats -f null -` and look for peaks at or above −0.1 dBTP inside the window only.
- **Listen for the resume.** Does narration return at the same loudness it left? A host whose own voice is 2 LU louder after the window has re-mixed around the clip rather than matching it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `match_target` | narration speech loudness | — | The reference is **your own voice**, measured on a narration-only stretch of this video — not an absolute standard. *"The absolute spectrum of a single unknown voice cannot be diagnosed"*; compare against something inside the same file. |
| `match_tolerance` | ±1.5 LU | ±1.0 to ±2.5 LU | Below 1 LU is inaudible precision; above 2.5 LU is a perceptible step. |
| `measure_window` | speech only | — | Gate out music and effects (high-pass 120 Hz, low-pass 6 kHz, and measure only the speech-bearing seconds). Integrated loudness over a whole action clip measures explosions. |
| `programme_target` | −14 LUFS | −16 to −14 LUFS | The finished mix. YouTube normalises **downward only**, so a quieter master is not raised — a mix at −20 LUFS just plays quiet. |
| `true_peak_ceiling` | −1 dBTP | −2 to −1 dBTP | R 128's ceiling, applied to the whole programme including the window. |
| `clip_music_ceiling` | −20 dB relative to your narration | −24 to −18 dB | If the clip carries its own score, constrain it to roughly your own bed's slot so it does not become the loudest thing in your video. |
| `host_bed_during_window` | 0 (stopped) | 0, or −28 dB | Stop the bed if the clip has its own music. Duck to −28 dB only if the clip is dry. |
| `bed_stop_point` | on a waveform peak | — | Stop the host bed on a transient, not in a trough, so the stop reads as smooth. |
| `pre_roll_hold` | 9f (0.3 s) | 6–15f | Frames between narration ending and the clip's first frame. |
| `post_roll_hold` | 12f (0.4 s) | 6–24f | Frames after the clip before narration resumes. Zero reads as an overlap. |
| `seam_fade` | 8 ms | 5–15 ms | Micro-fade at the window's in and out points, on the audio, to kill splice clicks. |
| `ambience_across_window` | continuous | — | The host's room-tone bed spans the window, at −30 dB, so neither seam exposes a floor step. |
| `clip_highpass` | 80 Hz | 60–120 Hz | Removes rumble a cinema mix assumes a subwoofer for and your viewer's phone cannot reproduce anyway. |
| `max_share_of_runtime` | 25% | 10–35% | Total window time ÷ runtime. Above ~35% the video is a compilation with commentary. |

## Reproduction prompt

```
Hand the dialogue slot to the demonstration clip for the window
{{WIN_IN}}..{{WIN_OUT}} (seconds, composition time), and match its loudness
to the host narration.

1. MEASURE THE HOST. Pick a 20 s narration-only stretch with no music and run
   two-pass loudnorm measurement on it. Record narration_I (LUFS) and
   narration_TP. This is your reference - not a standard, your own voice in
   this video.
2. MEASURE THE CLIP'S SPEECH, not the clip. If the clip carries music or
   effects, isolate the speech-bearing seconds and measure only those, gated
   with highpass=120, lowpass=6000. An action clip's integrated loudness is
   its explosions; normalising to it makes the dialogue whisper.
   Record clip_speech_I.
3. COMPUTE THE GAIN: gain_dB = narration_I - clip_speech_I. Apply it as a
   static level on the clip's audio, NOT by loudness-normalising the whole
   clip. If |gain_dB| > 12, the clip needs a two-pass loudnorm bake instead -
   a fader that large means the clip's dynamics are wrong for the slot too.
4. CONSTRAIN THE CLIP'S OWN MUSIC. If the clip has a score, check that it does
   not exceed your narration by more than -20 dB once the gain is applied. If
   it does, either accept it as a deliberate cinematic moment for 2-3 seconds
   or bake a reduction.
5. STOP THE HOST BED at {{WIN_IN}}, on a waveform peak in the bed, ramping to
   zero over the last 4 frames. If the clip is dry, duck to -28 dB instead of
   stopping. Restart the bed at {{WIN_OUT}} + 0.4 s.
6. SPAN THE WINDOW WITH THE HOST AMBIENCE. The room-tone bed at -30 dB runs
   continuously through {{WIN_IN}} and {{WIN_OUT}} so neither seam exposes a
   floor step. This is what makes the two recordings sound like one video.
7. FADE THE SEAMS: 8 ms on the clip's audio in and out. Hold 0.3 s before the
   clip and 0.4 s after it before narration resumes.
8. CHECK THE CEILING. After the gain, the window's true peak must not exceed
   -1 dBTP. A cinema-mastered clip can peak far above your programme ceiling
   and clip on the delivery encode.
9. RE-MEASURE THE WHOLE PROGRAMME to -14 LUFS / -1 dBTP, and confirm the
   window did not drag the integrated value.

ACCEPTANCE TEST: play from 5 s before {{WIN_IN}} to 5 s after {{WIN_OUT}} at a
comfortable volume, once, without touching the volume control. You must not
want to. Speech either side of both seams must sit at the same apparent
loudness, and you must not hear the noise floor change at either seam. Then
check the delta numerically: window speech loudness must be within 1.5 LU of
narration loudness. If the numbers pass and it still sounds wrong, the clip's
dialogue is spectrally different, not louder - that is an EQ problem, not a
level problem.
```

## Execution spec

**ffmpeg is the whole measurement and bake.** The contract's own two-pass `loudnorm` recipe, used here to *compare* rather than to hit a standard:
```bash
# 1. measure the host narration (20 s, narration only, no music)
ffmpeg -ss 610 -t 20 -i host.mp4 -af loudnorm=I=-16:TP=-1.5:LRA=11:print_format=json -f null - 2>&1 | tail -20
#    read input_i  -> narration_I

# 2. measure the clip's SPEECH only. Two routes:
#    a) if the speech is contiguous, measure just those seconds
ffmpeg -ss 3.2 -t 6.5 -i demo.mp4 -af "highpass=f=120,lowpass=f=6000,loudnorm=I=-16:print_format=json" -f null - 2>&1 | tail -20
#    b) if speech is interleaved with effects, print short-window loudness and
#       take the median of the speech windows
ffmpeg -i demo.mp4 -af "highpass=f=120,lowpass=f=6000,ebur128=framelog=verbose" -f null - 2>&1 | grep "M:"

# 3. apply the computed static gain, high-pass, and fade the seams
ffmpeg -i demo.mp4 -vn -ac 2 -ar 48000 \
  -af "highpass=f=80,volume=<gain_dB>dB,afade=t=in:st=0:d=0.008,afade=t=out:st=<len-0.008>:d=0.008,alimiter=limit=0.891" \
  -c:a pcm_s24le demo-audio.matched.wav

# 4. only if |gain| > 12 dB: a real two-pass normalise instead of a fader
ffmpeg -i demo.mp4 -vn -af loudnorm=I=-16:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -i demo.mp4 -vn -af loudnorm=I=-16:TP=-1.5:LRA=11:measured_I=<i>:measured_TP=<tp>:measured_LRA=<lra>:measured_thresh=<th>:offset=<off>:linear=true \
  -ar 48000 -c:a pcm_s24le demo-audio.norm.wav

# 5. the programme, at the end
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
```
Two notes that matter. `loudnorm`'s gating discards material below −70 LUFS absolute and 10 LU below the running integrated value — which is *why* measuring a whole action clip gives you the explosions and not the dialogue, and why step 2's band-limited measurement is not fussiness. And `ebur128=framelog=verbose` gives momentary (`M:`) values you can median over speech windows, which is the practical route when speech and effects interleave.

**HyperFrames — the arrangement, which is where the handover actually lives.** The project's convention is a muted `<video>` plus a separate `<audio>`, which is exactly right here because the clip's audio needs its own gain and chain while its picture needs nothing:
```html
<!-- the demonstration clip: picture muted, sound as its own track at the matched level -->
<video id="demo-cut-on-action" src="assets/demos/cut-on-action.mp4" class="clip" muted playsinline
       data-start="257.0" data-duration="18.0" data-media-start="0" data-track-index="0"></video>
<audio id="demo-cut-on-action-a" src="assets/demos/cut-on-action.mp4"
       data-audio-group="dialogue"
       data-start="257.0" data-duration="18.0" data-media-start="0"
       data-track-index="10" data-volume="0.63"      <!-- computed gain, about -4 dB -->
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:80}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Peak Ceiling&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.008,&quot;v&quot;:1},{&quot;t&quot;:17.99,&quot;v&quot;:1},{&quot;t&quot;:18.0,&quot;v&quot;:0}]}]}"></audio>

<!-- the host bed stops at the window's first frame, on a peak, over 4 frames -->
<audio id="bed-sec-7" src=".media/audio/bgm/bed-7.wav" data-audio-group="music"
       data-start="240.0" data-duration="17.0" data-track-index="11" data-volume="0.056"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:16.87,&quot;v&quot;:1},{&quot;t&quot;:17.0,&quot;v&quot;:0}]}]}"></audio>

<!-- the host room tone runs straight through the window, both seams covered -->
<audio id="amb-room" src="assets/sfx/diegetic/room-tone/room_tone_office_ac_01.wav"
       data-audio-group="ambience" data-start="0" data-duration="600"
       data-track-index="14" data-volume="0.0316"></audio>
```
Contract points that decide whether this runs:
- **The demo audio goes in a `dialogue` group, NOT `voiceover`.** This is the subtle one. The `voiceover` group is the carve source, and *"Keep the carve group voices only: a bed or an SFX clip inside the named group poisons the **next** re-analysis silently."* A film clip's full mix inside the carve group makes the bed carve against explosions. Your narration is `voiceover`; the clip is `dialogue`.
- **`data-volume` max is 3.98 (+12 dB).** If the computed gain exceeds +12 dB, the composition cannot express it and you must bake the level with ffmpeg. A screen recording at −40 dB is exactly this case.
- **The `t: 0` point is mandatory** on every lane, because a lane holds its first value backwards to the clip start. Here it is doing double duty as the 8 ms seam fade.
- **`limiter` last in the chain**, always — *"character and ceiling last"* — and it is what stops a cinema-mastered peak breaking the programme ceiling.
- **Automation on `limiter` is impossible**: `compressor`, `limiter`, `gate` and `bitcrush` are AudioWorklets configured wholesale with **zero automatable parameters**. If a window needs a moving ceiling, automate a `gain` stage around the limiter instead.
- **There is no auto-sync.** Picture and sound are aligned only because `data-start`, `data-duration`, `data-media-start` and `data-playback-rate` are written identically on both elements.
- **Every `<audio>` needs an `id`.** An id-less demo audio track renders silent with no error — and a silent demonstration window is indistinguishable from a deliberate one, which makes this the most dangerous instance of that bug in the whole library.
- **A window is also a trap for the pause-removal pass**: the automatic silence cut targets exactly these gaps. Protect them with explicit `--keep` ranges or narrow `--remove` ranges ([[sfx-pause-removal-breath-and-room-tone]]).

**Epidemic Sound.** Nothing to fetch for the window itself. Two adjacent needs:
```
# if the clip is dry and needs a bed of place rather than the host's music
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["ambience--room-tone"]},
                              duration:{min:60000} }, first:24 }
# a soft marker on the window's in-point, so "watch this now" is audible as well as visible
SearchSoundEffects { query:{term:"user interface soft transition"},
                     filter:{duration:{min:200,max:800}}, first:20 }
```

**Remotion:** the clip's `<Audio>` inside its `<Sequence>` with a `volume` prop set from the measured gain. Concept only; no Remotion runtime here.

## Pairs with
[[pace-silent-demonstration-window]] · [[sfx-layer-volume-targets]] · [[sfx-dialogue-gate]] · [[sfx-missing-ambience-audit]] · [[sfx-music-hard-stop]] · [[sfx-music-rest-windows]] · [[sfx-transient-masked-outpoint]] · [[sfx-pause-removal-breath-and-room-tone]] · [[sfx-layer-stem-demo]] · [[sfx-filter-character-and-distance]] · [[sfx-second-sense-doctrine]] · [[struct-demo-before-label]] · [[struct-recognisable-clip-evidence]] · [[cut-screen-recording-proof-insert]] · [[sfx-source-licensing-and-clearance]]

## Failure modes
- **Normalising the whole clip instead of its speech.** An action clip's integrated loudness is its explosions, so the dialogue ends up whispering while the bangs are fine. Fix: band-limited, speech-only measurement.
- **The clip louder than the host.** The viewer reaches for the volume and may not put it back. The single worst outcome in the note. Fix: measure, compute, apply; ±1.5 LU.
- **The host bed running under a clip that has its own score.** Two pieces of music at once, in different keys and tempos. Fix: stop the host bed at the window's first frame, on a peak.
- **No ambience across the window.** The floor steps at both seams, so the insert sounds pasted in even at a perfect level. Fix: the host room tone spans the window.
- **Putting the clip's audio in the `voiceover` group.** The music carve then analyses a film mix as if it were your voice and silently poisons the next re-analysis. Fix: `data-audio-group="dialogue"`.
- **No seam fades.** Two 1-frame clicks per window. Fix: 8 ms in and out.
- **A gain above +12 dB attempted with `data-volume`.** Silently clamped at 3.98, so the quiet screen recording stays quiet and nothing tells you why. Fix: bake it with ffmpeg.
- **Cinema true peaks left alone.** The window clips on the delivery encode even though the mix meter looked fine. Fix: `limiter` last, `limit: -1`.
- **Narration resuming at a different loudness.** Means the host was re-mixed around the clip instead of the clip being matched to the host. Fix: the host is the reference and never moves.
- **The pause-removal pass eating the window.** It is, by construction, the longest gap in the narration. Fix: exempt every window range explicitly.
- **Known gap:** the ±1.5 LU match tolerance is derived from R 128's own ±0.5–±1 LU programme-compliance tolerances extended for the harder case of two different recordings, not from a listening study on inserted clips. The −20 dB constraint on the clip's own music is an extrapolation of the source's own music slot (−20 to −25 dB) rather than a cited figure. Both are defensible starting points; the volume-control acceptance test is the authority.
