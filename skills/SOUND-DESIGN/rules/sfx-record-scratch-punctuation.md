---
id: sfx-record-scratch-punctuation
aliases: [sfx-record-scratch-freeze-punctuation]
title: The record scratch — a full stop that kills the mix
skill: sound-design
type: sfx
family: comedy-sfx
tags: [skill/sound-design, type/sfx, family/comedy-sfx, sfx/aesthetic, layer/sfx, layer/music, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:05:10"
    quote: "These include sound effects like boing, slide, whistle or pop. Adding them, you can elevate your humour even further."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:05:15"
    quote: "You can also put echo on these sound effects to give them a slightly goofier feel."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:05:19"
    quote: "My favourite sound effect out of these is the disc scratch — I use it a lot."
research_refs:
  - https://en.wikipedia.org/wiki/Scratching
  - https://en.wikipedia.org/wiki/Habituation
  - https://tvtropes.org/pmwiki/pmwiki.php/Main/RecordNeedleScratch
  - https://tvtropes.org/pmwiki/query.php?parent_id=84620&type=lnf
  - https://sonilo.com/blog/guides/transition-effect-sound-video-edits
  - https://www.explainxkcd.com/wiki/index.php/1745:_Record_Scratch
  - https://www.flexclip.com/learn/transition-sound-effects.html
  - https://ffmpeg.org/ffmpeg-filters.html#astats-1
  - "mcp://Epidemic_sounds/SearchSoundEffects — `communications--phonograph` probed live 2026-08-28: 4544 hits; measured durations 501, 575, 594, 662, 925, 1005, 1134, 1233, 1252, 1697, 1822 ms, plus a 3600 ms \"Record Scratch, Stop\" variant"
difficulty: medium
detectable_from: audio
---

# The record scratch — a full stop that kills the mix

## What it is
A single sound effect used as **punctuation**, not as texture, and the one comedy effect that is **subtractive**. Every other effect in the cartoon family adds something to the mix; the record-needle scratch is the culturally fixed signal for *stop everything*, so in its canonical form the background music and everything else *"comes to a screeching halt"*, and what follows is a beat of near-silence in which the viewer processes an absurdity, a reversal, or a correction. An edit that plays a scratch *over* a continuing bed has used the sound and skipped the device. What makes it land is not the sound but the **hole behind it**.

It is also a **full stop, not a comma** — after it, something must change: a cut, a freeze, a new line, a correction, a title. A scratch that resolves back into the same bed and the same sentence is a sound effect that meant nothing.

**This note is the mix pattern, not the joke.** Three things happen within a few frames of each other: the **bed stops** (hard, on the scratch's peak, with a short tail so it does not click), the **dialogue drops out or the picture freezes**, and a **silence window** follows in which the viewer processes the absurdity. Then something changes.

The source names it as the single most-used effect in his comedy toolkit, which is the useful signal: this is a **default**, applied often, and therefore governed mainly by rules about not overusing it. His sibling advice applies here too — *"you can also put echo on these sound effects to give them a slightly goofier feel"* — a short slap delay pushes the scratch further into cartoon register ([[sfx-echo-on-cartoon-oneshot]]).

## When to use it
Five triggers, all of them moments where the video needs to say *"stop"*:

1. **A correction** — the presenter or a second persona catches an error mid-sentence ([[struct-misspeak-correction-gag]]).
2. **An absurdity** — a line, claim, statistic or image the video wants marked as ridiculous.
3. **A reversal** — the sentence turns on itself ("…which is exactly what you should never do").
4. **The freeze-frame intro** — the canonical pairing, where the action stops mid-moment and the presenter starts explaining how we got here.
5. **A hard tonal pivot** out of a montage or a high-energy run into something serious. Here the scratch is the brake, and what follows must actually be different.

Do **not** use it where a whoosh belongs: a scratch on an ordinary transition is a category error — a whoosh carries motion *through* a cut, a scratch stops the video dead ([[sfx-whoosh-transition-movement-reveal]], [[sfx-whoosh-transition-movement-reveal]]). Do not use it for mild humour; it is the loudest punctuation available and spending it on a small joke leaves nothing for a big one. Do not use it under a line the viewer must actually hear — it takes the mix with it. And do not use it more than a couple of times in a video: habituation is fastest for high-salience repeated stimuli, so the third one is not funny.

## How to recognise it in a reference video
- **The sound itself is spectrally distinctive**: a short, downward-swept broadband noise burst with most energy between roughly 300 Hz and 6 kHz and a characteristic pitch fall. It shows as a single sharp RMS spike, 15–55 frames long:
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null | paste - -
  ffmpeg -v error -ss <t> -t 1.0 -i ref.wav -af "aspectralstats=measure=centroid,\
  ametadata=print:key=lavfi.aspectralstats.1.centroid:file=-" -f null - 2>/dev/null
  ```
  A scratch's centroid **falls monotonically** across its length — that descent is what separates it from a generic noise burst.
- **The diagnostic is what happens after it, not the effect.** Take low-band RMS (the bed) either side, in the 0.5 s before and the 0.5 s after. A properly deployed scratch shows the bed falling **≥15–20 dB within 2–6 frames** of the scratch's peak and **staying down for the silence window**. If the bed level is unchanged across the scratch, log it as *decorative* — the effect was used without the device, and that is a miss, not a style.
  ```bash
  ffmpeg -i ref.mp4 -af "highpass=f=40,lowpass=f=160,asetnsamples=n=1600,\
  astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
- **Measure the silence that follows** — the gap between the scratch's tail and the next spoken word or sound event. This is the joke's whole timing, and the working band **depends on what is on the far side** (see Parameters): **8–20 f (0.27–0.67 s)** when the next thing is a spoken line, **15–45 f (0.5–1.5 s)** when the next thing is a freeze frame or a held visual gag. Under ~8 f there is no beat and the gag is skipped; past ~60 f the video feels like it stopped.
- **Look for the change on the far side, within ±3 f.** A hard cut, a freeze frame, a scale snap, a caption slam, a new speaker, or the bed restarting with a different track. A scratch with no visual change is a sound looking for a moment, and a scratch with nothing on its far side is a defect.
- **Check the transcript at the scratch's timecode.** Expect one of: a correction ("wait", "no", "actually", "sorry", "okay so"), an absurdity, a reversal conjunction ("…which is exactly wrong"), or the start of a framing device ("yep, that's me"). Scanning the transcript for those words is a faster way to find candidate scratches than scanning the audio.
- **How the music comes back.** Three shapes: **restart on the next musical downbeat** (the comedy convention), **ramp back over 0.15–0.5 s**, or **a different track entirely**. Log which — it tells you whether the scratch was a punctuation mark or a section boundary.
- **Density.** Count per video. **1–2 in an 8–10 minute video** is the professional band, 3 is the absolute ceiling. Five or more and the effect has become a verbal tic; the published transition-sound guidance applies directly — *"most cuts should be silent handoffs"* and a second pass should **delete about half** the effects.
- **Variation.** If the same scratch file is used more than once, check whether pitch, duration or reverb differ between uses. Identical repeats are the "same sound effect again and again" mistake.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `source_file_len` | 0.9 s | 0.50–1.85 s | The measured catalogue range for `communications--phonograph` (501–1822 ms across the first page). |
| `authored_clip_len` | 0.40–0.9 s | 0.2–1.85 s | What you actually author with `data-duration`. Short end (0.40–0.7 s) for a quick correction, long end for a full stop. Trim the file's head with `data-media-start` so the transient lands on frame 0 of the clip, and the tail with `data-duration`. |
| `spin_down_length` | 3.6 s | 2.5–4.0 s | The "Vinyl, Record Scratch, Stop" variant — a whole turntable slowing. A **scene-level** gesture: use only for a full-stop pivot, never for a correction. |
| `scratch_gain` | −12.5 dB (`data-volume` 0.240) | −15 to −10 dB rel. dialogue | Top of the SFX band, because this is punctuation. Never above the voice. |
| `bed_stop_at` | scratch peak | peak −1 to +1 f | The music must stop *on* the scratch, not before or after it. |
| `bed_stop_fade` | 2–3 f (0.066–0.10 s) | 1–3 f (0.033–0.10 s) | **Not zero** — a hard cut mid-sustain clicks. Not more — it stops sounding like a stop. |
| `bed_kill_depth` | to silence | ≥15 dB drop, target 0 | A partial dip reads as a duck, not a scratch. |
| `silence_len` — far side is **dialogue** | 12 f (0.40 s) | 8–20 f (0.27–0.67 s) | The viewer is waiting for words; a longer hole reads as dead air. Use this row for corrections and reversals. |
| `silence_len` — far side is **a freeze or held visual** | 24 f (0.80 s) | 15–45 f (0.5–1.5 s) | There is something to look at, so the beat can breathe. Use this row for freeze-frame intros and visual gags. |
| `dialogue_handling` | duck to 0 across the window | mute \| duck | Mute if the freeze is total; duck to ~0.15 if room tone should continue. Never clip a syllable. |
| `ambience_continues` | **yes** | — | Ambience survives the kill. Only the music stops — all three layers stopping together reads as a technical fault, not as a joke. |
| `bed_return` | ramp back 0.25 s | ramp 0.15–0.5 s \| hard restart \| new track | Ramp by default. A **hard restart is legitimate only when it lands on the next musical downbeat** — that is the comedy convention; a hard restart mid-phrase is just a splice. |
| `visual_event_offset` | 0 f | −3 to +3 f | Cut, freeze, scale snap or caption relative to the scratch transient. |
| `freeze_alignment` | scratch peak = frozen frame | ±1 f | If the picture freezes, the peak and the frozen frame are the **same frame**. Author both from the same number. |
| `freeze_len` | 45 f (1.5 s) | 30–90 f | If pairing with a freeze frame. |
| `density` | 1–2 per video | 0–3 per 8–10 min | Above 2 it is becoming a tic; 3 is the hard ceiling. None within 90 s of another. |
| `pitch_variation` | ±2 semitones | ±0–4 | Between reuses, so the same file does not read as the same file. |
| `echo_delay` | 90 ms | 60–140 ms | The source's "goofier feel" trick, as a `delay` node: `feedback` 0.2–0.3, `mix` 0.2–0.3. Above ~0.25 mix it stops sounding like a record. Never on the bed. |

## Reproduction prompt

```
Place a record-scratch punctuation at composition time {{HIT}} (seconds, 30fps),
where {{HIT}} is the frame the absurdity / correction / reversal lands.

1. CONFIRM THE MOMENT AND THE FAR SIDE. {{HIT}} must be a correction, an
   absurdity, a reversal, a freeze-frame intro, or a hard tonal pivot - AND
   within 0.5 s after it there must be a cut, a freeze, a new line, a new
   caption or a track change. If it is an ordinary transition, STOP: use a
   whoosh instead. A scratch stops the video; a whoosh carries it through. If
   there is nothing on the far side, place nothing, or use a lighter comedy
   effect.

2. CHECK THE WORD BOUNDARY. If the presenter is mid-word at {{HIT}}, move
   {{HIT}} to the nearest word boundary. A scratch that clips a syllable is a
   mistake, not a joke.

3. FETCH:
     SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL,
        values:["communications--phonograph"]}, duration:{min:500,max:1900} },
        sort:{by:POPULARITY,order:DESCENDING}, first:24 }
   Pull 3 candidates; prefer titles reading "Vinyl, Record Scratch NN". For a
   full-stop pivot instead use duration {min:2500,max:4000} and the "Record
   Scratch, Stop" spin-down variant. Download WAV - the scratch is a fast
   broadband sweep and mp3 pre-echo is audible on exactly the leading edge you
   are aligning.

4. MEASURE peak_offset and PLACE THE EFFECT so its transient lands exactly on
   {{HIT}}: data-start = {{HIT}} - peak_offset, or trim the head with
   data-media-start until the attack is at frame 0 of the clip and start the
   clip at {{HIT}}. Do one or the other, never both. Duration 0.40-0.9 s,
   data-volume 0.240, group "sfx", its own track index.

5. KILL THE MUSIC ON THE PEAK. On the music clip add a volume lane:
   {"t":<hit-0.066>,"v":1}, {"t":<hit>,"v":0} - a 2-frame fall to silence, not
   zero frames (it clicks) and not more (it stops sounding like a stop). Hold 0
   across the silence window. If the bed only dips, the device has not been
   performed.

6. SIZE THE SILENCE WINDOW BY WHAT FOLLOWS:
     next thing is a spoken line     -> 8-20 frames (0.27-0.67 s)
     next thing is a freeze or a held visual gag -> 15-45 frames (0.5-1.5 s)
   That silence is the joke. Do not fill it.

7. KEEP AMBIENCE RUNNING. Room tone and location sound continue through the
   kill. Only the music stops.

8. CHANGE SOMETHING VISUALLY within 3 frames of {{HIT}}: a hard cut, a freeze
   frame held 45 frames, a scale snap, or a caption slam. If a freeze is used,
   the frozen frame and the scratch's peak are the SAME frame - author both from
   the same number.

9. BRING THE MUSIC BACK deliberately: ramp up over 0.15-0.5 s, or hard-restart
   ONLY if that lands on the next musical downbeat, or start a different track
   if this is a section boundary.

10. OPTIONAL GOOFIER REGISTER: a delay node on the scratch clip - time 90 ms,
    feedback 0.25, mix 0.25. Never on the bed.

11. BUDGET. No more than 2 in the whole video (3 absolute ceiling), none within
    90 seconds of another. If reusing the same file, shift pitch by up to 2
    semitones and vary the duration so it does not read as a repeat.

ACCEPTANCE TEST: play from 2 s before to 2 s after with your eyes closed. You
should hear: normal mix -> scratch -> a hole -> something different. Then check
numerically: (a) low-band RMS falls at least 15 dB within 6 frames of {{HIT}}
and stays down across the window; (b) ambience is still audible during the kill;
(c) there is a visible change within 3 frames of the transient; (d) the first
sound after the beat is the intended line, not a leftover; (e) across the video,
at most 2-3 scratches, none within 90 seconds of another. If the bed is still
playing under the hole, step 5 was not done and the device did not fire.
```

## Execution spec

**Epidemic Sound — verified live 2026-08-28.** The family is filed under `communications--phonograph` (4544 hits for the phrase probe), with title chains reading `Communications, Phonograph, Vinyl, Record Scratch NN`. Measured durations across the first page: **501, 575, 594, 662, 925, 1005, 1134, 1233, 1252, 1697, 1822 ms**, plus `Communications, Phonograph, Vinyl, Record Scratch, Stop` at **3600 ms** and `…Vinyl, Record, Spin, Stop, Scratch` at **1252 ms**.
```
# the punctuation scratch
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["communications--phonograph"]},
                              duration:{min:500,max:1900} },
                     sort:{by:POPULARITY,order:DESCENDING}, first:24 }
# the full spin-down stop
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["communications--phonograph"]},
                              duration:{min:2500,max:4000} }, first:12 }
# term fallbacks, descending reliability
#   "communications phonograph vinyl record scratch"
#   "vinyl record scratch stop turntable"
#   "record scratch vinyl stop"
SearchSimilarToSoundEffect { id:<chosen uuid>, first:12 }   # two more, for the second use
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Take WAV. Adjacent cartoon-family fetches for the same toolkit: `"boing cartoon"`, `"cartoon slide whistle"`, `"pop cartoon short"` ([[sfx-cartoon-comedy-family]]). Place in the `sfx` group — **never** in the `voiceover` carve group, which must contain voices only or it poisons the next carve re-analysis silently.

**HyperFrames — the pattern is one clip plus one lane on the bed.** All times in seconds.

```html
<!-- absurdity lands at 42.000 s; scratch peak_offset 0.085 s -->
<audio id="sfx-scratch-01" src="assets/sfx/comedy/vinyl_record_scratch_08.wav"
       data-audio-group="sfx" data-start="41.915" data-duration="0.925"
       data-track-index="14" data-volume="0.240"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;delay&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Goofy slap&quot;,&quot;params&quot;:{&quot;time&quot;:90,&quot;feedback&quot;:0.25,&quot;mix&quot;:0.25}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>

<!-- the device: the bed stops ON the peak, hole for 0.4 s, ramp back at 42.4 -->
<audio id="music-bed" src=".media/audio/bgm/bed.wav" data-audio-group="music"
       data-start="0" data-duration="180" data-track-index="11" data-volume="0.063"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:41.934,&quot;v&quot;:1},{&quot;t&quot;:42.0,&quot;v&quot;:0},
         {&quot;t&quot;:42.4,&quot;v&quot;:0},{&quot;t&quot;:42.65,&quot;v&quot;:1}]}]}"></audio>

<!-- ambience keeps running: untouched, its own clip, its own track index -->
<audio id="amb-room" src="assets/ambience/studio-tone.wav" data-audio-group="ambience"
       data-start="0" data-duration="180" data-track-index="13" data-volume="0.10"></audio>

<!-- the freeze: a still exported at the freeze frame, held 45f = 1.5s -->
<img id="freeze-1" src="assets/stills/freeze-42.png" class="clip"
     data-start="42.00" data-duration="1.50" data-track-index="1"
     style="position:absolute; inset:0; width:100%; height:100%; object-fit:cover">
```

Contract facts this depends on:
- **A `data-automation` lane's `t` is clip-local seconds.** This bed starts at 0 so the numbers coincide with composition time; a bed starting at 180.00 would need 180 subtracting from every point above. Getting this wrong silently kills the music somewhere else.
- **A lane holds its first value backwards to the clip start and its last value forward to the clip end**, so the `{t:0,v:1}` "no cut" point is mandatory or the bed starts already silent.
- **Never both a lane and a GSAP `volume` tween** on one track (`audio_volume_double_automation`); the lane wins silently.
- **If the bed is carved** (`data-fx-carve`), the carve writes its own `gain` stage and lanes tagged `fromCarve`. **Write the stop lane on `volume`, not on the carve's gain node**, and re-run `carve.mjs` afterwards — it replaces only its own nodes and leaves hand-drawn lanes alone.
- **JSON attributes double-quoted with `&quot;`** — a single-quoted attribute is invisible to `carve.mjs`'s regex and *"the carve silently overwrites work it could not see."*
- **Every `<audio>` needs an `id`**, or it is never mixed → silent render.
- **Overlapping audio must not share a `data-track-index`** (`duplicate_audio_track`) — hence 11/13/14.
- **`data-media-start` trims into the source in seconds**, which is how the transient is aligned to frame 0 without cutting a file.
- **`delay` params** are `time` 1–5000 ms, `feedback` 0.01–0.95, `mix` 0–1, all automatable; out-of-range values are clamped on read. `limiter` last. The delay adds a tail, so *"a bed with reverb no longer ends exactly at its `data-duration`; that is expected"* — the same applies to this clip.
- **There is no arbitrary mid-source freeze.** *"Freeze: still `<img>` clip, or hold the final frame; arbitrary mid-source freeze requires a preprocessed still/segment."* So the freeze-frame pairing needs a still exported by ffmpeg first.

If the moment also wants a caption slam or a scale snap, put it on the master timeline at the same number:
```js
// caption slam on the scratch transient; 0.13s = 4f
tl.fromTo("#gag-caption", { scale: 1.6, autoAlpha: 0 },
                          { scale: 1, autoAlpha: 1, duration: 0.13, ease: "power4.out" }, 42.0);
```
`autoAlpha`, not raw `visibility`/`display`, and only on a non-clip element or an inner wrapper. Use `fromTo`, never `from` (`immediateRender: true` writes the from-state at construction and flashes under non-linear seek). No CSS `transform` on the same element (`gsap_css_transform_conflict`, an error). There is **no audio-follows-animation attribute**: the tween position and the `<audio data-start>` are coupled only by you writing `42.0` twice — and if the visual lives inside a sub-comp, the root-level audio needs `data-start = scene-local t + the slot's data-start`.

**ffmpeg.** Three jobs.
```bash
# 1. Export the freeze still (mid-source freezes need a real file)
ffmpeg -ss 42.00 -i program.mp4 -frames:v 1 -q:v 2 assets/stills/freeze-42.png

# 2. Make pitch/length variants of ONE scratch file so repeats do not read as repeats
#    (asetrate shifts pitch and speed together; atempo compensates the length back.
#     +/-2 semitones is x1.12 / x0.89.)
ffmpeg -i record-scratch-01.wav -af "asetrate=48000*1.12,aresample=48000,atempo=0.893" scratch_up2.wav
ffmpeg -i record-scratch-01.wav -af "asetrate=48000*0.89,aresample=48000,atempo=1.123" scratch_dn2.wav

# 3. Verify the descent: the spectral centroid should fall across the file
ffmpeg -v error -i scratch.wav -af "aspectralstats=measure=centroid,\
ametadata=print:key=lavfi.aspectralstats.1.centroid:file=-" -f null - 2>/dev/null | head -20
```
A little echo for the "goofier feel" is better done in-composition as a `delay` node than baked, so it stays adjustable. If it must be baked (an asset leaving the pipeline, or a pre-mixed sting):
```bash
ffmpeg -i scratch.wav -af "aecho=0.8:0.6:90:0.25,afade=t=out:st=0.80:d=0.12" scratch_goofy.wav
```

**Remotion:** an `<Audio>` one-shot plus a volume callback on the bed that returns 0 across the hole. Concept only; Remotion is not part of this stack.

## Pairs with
[[sfx-cartoon-comedy-family]] · [[sfx-echo-on-cartoon-oneshot]] · [[sfx-music-hard-stop]] · [[sfx-silence-as-pattern-interrupt]] · [[sfx-smash-cut-audio-contrast]] · [[sfx-peak-offset-measurement]] · [[sfx-density-fatigue-audit]] · [[sfx-repetition-variant-rotation]] · [[struct-misspeak-correction-gag]] · [[struct-presenter-aside-pattern-interrupt]] · [[motion-pattern-interrupt-jolt]] · [[cut-smash-cut]] · [[sfx-music-rest-windows]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-placement-discipline]] · [[sfx-sound-pass-order]] · [[struct-outcome-first-cold-open]] · [[struct-stimulation-budget]] · [[sfx-motion-sound-selection]] · [[sfx-ab-audition-candidates]]

## Failure modes
- **Scratch over a continuing bed.** The commonest and most complete failure: the sound says "the music stopped" while the music has not, and nothing is punctuated. Fix: the volume lane to 0 on the scratch's peak, staying down across the window.
- **A hard bed cut with no fade.** Clicks, especially on a sustained chord. Fix: 2 frames, not zero.
- **Filling the beat.** A line, a whoosh or a music restart immediately after the scratch throws away the silence that carries the joke. Fix: leave the window empty, sized by what is on the far side.
- **Killing ambience too.** All three layers stopping reads as a dropout, not a gag. Fix: only the music stops.
- **Nothing changes afterwards.** Scratch, hole, then the same sentence continues — the device fired at nothing. Fix: put the cut, freeze or reframe on the far side, or remove the scratch.
- **Scratching mid-word.** Cuts a syllable and reads as an error rather than a gag. Fix: move the beat to the word boundary.
- **Used as a transition sound.** A whoosh's job is to carry motion through a cut; a scratch's job is to stop. Swapping them makes both meaningless.
- **Overuse.** Five scratches in ten minutes and the device stops being punctuation; high-salience stimuli habituate fastest, so the third one is wallpaper. The published guidance is to delete about half the effects on a second pass. Fix: 1–2 per video, 3 at the absolute ceiling, 90 seconds apart minimum.
- **Identical repeats.** The same file, same pitch, same length, three times: audible within a minute. Fix: vary pitch ±2 semitones, duration, and reverb — three parameters turn one file into many ([[sfx-repetition-variant-rotation]]).
- **Using the 3.6 s spin-down for a quick correction.** The long variant is a scene-ending gesture; on a small joke it swallows four seconds of pacing. Fix: 0.5–0.9 s for corrections.
- **Transient not on the frame.** Most scratch files have 30–120 ms of lead-in; placed raw, the hit lands late and the sync feels loose. Fix: trim with `data-media-start` until the attack is at frame 0.
- **Too loud.** Above the voice it stops being punctuation and becomes an assault. Fix: −10 to −15 dB against dialogue at 0 to −3 dB.
- **Known gap:** the "record scratch" convention is cultural, not acoustic — there is no measurement that says *this* scratch reads as funny and *that* one does not. The measurable parts are the descent of the centroid, the bed drop and the silence window; the register itself has to be auditioned ([[sfx-ab-audition-candidates]]).
- **Known gap:** there is **no arbitrary mid-source freeze** in this stack — the freeze-frame pairing needs a still or a segment preprocessed with ffmpeg — and **no audio-follows-animation binding**, so the scratch's `data-start` and the visual tween's position must be written as the same number by hand (plus the sub-comp offset if the visual is nested).
