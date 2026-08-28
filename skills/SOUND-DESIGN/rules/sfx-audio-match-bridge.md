---
id: sfx-audio-match-bridge
title: Audio match — cut on the sound the two scenes share
skill: sound-design
type: cut
family: match-cut
tags: [skill/sound-design, type/cut, family/match-cut, sfx/diegetic, layer/sfx, layer/ambience, layer/dialogue, engine/ffmpeg, engine/hyperframes, engine/epidemic, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:40"
    quote: "and audio, with the sound matches between the two scenes."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:17"
    quote: "The match cut is a cut that matches action, shape, colour, framing or even audio of two shots, seamlessly bringing the viewer into the next scene."
research_refs:
  - https://en.wikipedia.org/wiki/Match_cut
  - https://en.wikipedia.org/wiki/Sound_bridge
  - https://en.wikipedia.org/wiki/Spectral_centroid
  - https://en.wikipedia.org/wiki/Just-noticeable_difference
  - https://ffmpeg.org/ffmpeg-filters.html#astats-1
  - local verification 2026-08-28 — ffmpeg 6.1.1 `aspectralstats=measure=centroid+flatness+rolloff` confirmed present, metadata keys print as `lavfi.aspectralstats.1.centroid`
difficulty: high
detectable_from: audio
---

# Audio match — cut on the sound the two scenes share

## What it is
A match cut whose matched dimension is **sound**. Scene A contains a sound; scene B contains a sound that the ear accepts as the *same* sound, or as its continuation; the picture changes on it and the change costs the viewer nothing. A scream becomes a train whistle; a phone ringing becomes an alarm clock; a kettle becomes a siren; a drum hit in the room becomes the downbeat of the score. The mechanism is not "similar vibes" — it is that the ear tracks a small number of measurable properties across the join, and if those hold, it hears **one continuous auditory object** while the eye is handed a completely new image. Continuity in the ear buys discontinuity in the eye.

Distinguish it from its neighbours. A **sound bridge / J or L cut** overlaps *one* sound across a cut (the sound is literally the same file, [[sfx-split-edit-lead-lag]]). An audio match uses **two different sounds** that are made to read as one. A **graphic match** matches shape, a **movement match** matches motion — those are the other two of the creator's three match types ([[cut-graphic-match]], [[cut-movement-match]]).

Four properties do the work, in order of how unforgiving they are: **pitch proximity** (the fundamentals must be close — pitch differences above about 3 semitones are heard as a different note, and around 10 cents is already discriminable at 1 kHz, so "close" means within a few semitones, not within an octave), **envelope class** (both percussive or both sustained; a struck sound cannot become a swelling one across a hard cut), **spectral centroid** (perceived brightness — the join is audible if the timbre jumps a third of an octave or more), and **level** (within about 2 dB; 1 dB is the loudness JND, so a 4 dB step is a clearly heard seam).

**Style.** Filed `sfx/diegetic`: the join works because both sounds are real objects the ear accepts as one — a scream becoming a train whistle. A match built from two *designed* sounds, a riser handing over to a braam, is doing an aesthetic job instead and follows [[sfx-riser-hit-pair]].

## When to use it
- **A hard scene or location change** that would otherwise read as a jolt, where you can find or place a sound both places plausibly own.
- **A time jump** — the same class of sound in two eras is the classic audio match, and it does the "meanwhile / years later" work without a title card.
- **A tonal pivot** — the sound is the pun: the domestic thing becomes the dangerous thing. This is the one that gets noticed and remembered, so it belongs at a structural turn, not mid-explanation.
- **Handing the viewer into a montage or into music**, where a diegetic sound becomes the first beat of the bed ([[sfx-beat-aligned-handover]]).
- **Do not** use it where the cut should be felt — a smash cut wants contrast, not continuity ([[sfx-smash-cut-audio-contrast]]).
- **Do not** use it more than once or twice per video: it is a conspicuous device by construction (the match cut is, in the literature, *"a more conspicuous transition"*), and a third one turns the video into a showreel of itself.
- **Do not** attempt it if you cannot get the two sounds within the tolerances below. A near-match is worse than a plain cut, because the ear notices the attempt and the failure.

## How to recognise it in a reference video
- **Find candidate joins:** a shot change (`scdet`) where the audio does **not** step. Compute a per-frame RMS trace and look for cuts with **|ΔRMS| < 2 dB** across the boundary while the picture changes completely.
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null | paste - -
  ```
- **Then check timbre continuity across the same boundary** — this is the measurement that separates an audio match from a coincidence:
  ```bash
  for t in <cut-0.30> <cut+0.02>; do
    ffmpeg -v error -ss $t -t 0.28 -i ref.wav -af "aspectralstats=measure=centroid+rolloff,\
    ametadata=print:key=lavfi.aspectralstats.1.centroid:file=-" -f null - 2>/dev/null \
    | awk -F= '{s+=$2;n++} END{print "centroid",s/n}'
  done
  ```
  An audio match holds the centroid within about **±25 %** (a third of an octave) across the cut. A plain cut between unrelated sounds typically jumps by a factor of 2 or more.
- **Classify the envelope on both sides.** Attack under 20 ms both sides = percussive match (expect a butt cut, 0–1 frame). Attack over 80 ms both sides = sustained match (expect a 2–6 frame crossfade). A percussive-to-sustained pair across a hard cut is not a match, whatever the titles say.
- **Look for the deliberate pitch match.** Extract 200 ms either side and compare fundamentals; a designed match sits within **±3 semitones** and often dead on. If you have no pitch tracker, the centroid plus a spectrogram eyeball is enough to call it.
- **Watch what the picture does at the same instant.** In real audio matches the picture change is *total* — different location, different subject, different framing. If the picture is only mildly different, the editor was hiding a jump cut, not building a match.
- **Transcript signal:** the line before the cut usually names the object whose sound carries over ("…and the phone rang"). Audio matches are set up in words more often than editors admit.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `pitch_tolerance` | 0 st | ±3 st | Above 3 semitones the ear hears a different note. Pitch-shift one side ([[sfx-pitch-shift-weight-energy]]) rather than accepting a wide interval. |
| `centroid_tolerance` | ±25 % | ±15–40 % | A third of an octave. Verified measurable with `aspectralstats`. |
| `level_tolerance` | 2 dB | 1–3 dB | 1 dB is the loudness JND; 4 dB is a heard step. Match with `astats` RMS over 200 ms either side. |
| `attack_class_match` | required | — | Percussive↔percussive or sustained↔sustained. No mixed pairs. |
| `crossfade_percussive` | 0 frames (butt) | 0–1 frame | A hit matches on its transient; a fade smears it. |
| `crossfade_sustained` | 4 frames (0.133 s) | 2–6 frames | Equal-power overlap. Above 8 frames the audience hears two sounds, not one. |
| `crossfade_ambience` | 12 frames (0.4 s) | 8–20 frames | Bed-to-bed matches (rain → static) want a longer, gentler handover. |
| `eq_morph_duration` | 8 frames (0.267 s) | 6–12 frames | If the timbres are close but not equal, sweep a `lowpass`/`highpass` cutoff across the join instead of crossfading longer. |
| `reverb_continuity` | same node both sides | — | A dry sound becoming a reverberant one breaks the match faster than pitch does. Put the same `reverb` on both clips, or on their shared group. |
| `uses_per_video` | 1 | 0–2 | Conspicuous device; ration it. |
| `setup_lead` | 1 line of narration | 0–2 lines | The object whose sound carries should be visible or named before the cut. |

## Reproduction prompt

```
Build an audio match cut at {{CUT}} seconds between scene A (out) and scene B (in)
in {{COMP}}.

1. CHOOSE THE PAIR. Name the sound A owns and the sound B owns, and check they
   share an envelope class: both percussive (attack < 20 ms) or both sustained
   (attack > 80 ms). If they do not, pick a different pair - do not proceed.
2. MEASURE BOTH, 250 ms windows, before placing anything:
   ffmpeg -v error -i A.wav -af "aspectralstats=measure=centroid,\
   ametadata=print:key=lavfi.aspectralstats.1.centroid:file=-" -f null -
   (same for B) and RMS with astats. Requirements:
     centroid_B within 0.75-1.33 x centroid_A
     RMS within 2 dB
     fundamentals within 3 semitones
3. FIX THE MISMATCH ON B, not on A (A is already established):
   pitch:    ffmpeg -i B.wav -af "rubberband=pitch=<ratio>" B.tuned.wav
             (ratio = 2^(semitones/12))
   level:    data-volume on B's clip, or a gain node
   timbre:   lowpass/highpass node on B, cutoff chosen an octave below where
             the character should start
4. PLACE THE JOIN:
   percussive pair -> both clips butt-cut at {{CUT}}; A's data-duration ends
     exactly at {{CUT}}, B's data-start = {{CUT}}, and B's peak_offset is
     subtracted so B's transient lands ON {{CUT}}.
   sustained pair -> overlap by 4 frames (0.133 s): A gets a volume lane
     falling 1 -> 0 across its last 0.133 s, B starts 0.133 s early with a lane
     rising 0 -> 1. Equal-power: both reach 0.707 at the midpoint, so use a
     mid point {"t":<half>,"v":0.707} in each lane rather than a straight line.
5. GLUE THE SPACE. Put the same reverb node on both clips (or put both in one
   audio group and treat the group), size 0.3-0.5, wet 0.12-0.2. A room change
   at the join undoes everything above.
6. OPTIONAL EQ MORPH instead of a longer fade: on B, automate a lowpass cutoff
   from A's centroid to B's own brightness over 0.267 s.
7. VERIFY BY EAR WITH EYES CLOSED. Listen across the join without picture. You
   must hear ONE sound continuing. Then watch it: the picture change should feel
   free. If you hear two sounds, shorten the overlap and re-match level and pitch
   - do not lengthen the fade.

ACCEPTANCE TEST: measure the render. RMS step across {{CUT}} under 2 dB,
centroid ratio between 0.75 and 1.33, and no audible click at the boundary
(scan 1 ms windows for a peak more than 6 dB above the local average).
```

## Execution spec

**HyperFrames — the join is two clips and two lanes, in seconds.** A clip's window is half-open `[start, start + duration)`, so *"two clips can be authored back to back (`b.start === a.start + a.duration`) with no overlapping frame"* — that is the butt cut for a percussive match. Negative relative offsets produce the overlap for a sustained match; mind the four silent failure modes of relative timing (spaces around the operator are required; an unresolved id resolves to 0).

```html
<!-- percussive match: A's clank ends exactly where B's hit begins, on the cut at 18.000 -->
<audio id="sfx-a-clank" src="assets/sfx/diegetic/clank_metal_02.wav"
       data-audio-group="sfx" data-start="17.640" data-duration="0.360"
       data-track-index="12" data-volume="0.240"></audio>
<audio id="sfx-b-hit"   src="assets/sfx/diegetic/door_slam_01.wav"
       data-audio-group="sfx" data-start="17.938" data-duration="1.200"
       data-track-index="13" data-volume="0.240"></audio>
<!-- 17.938 = 18.000 - peak_offset(0.062). B's transient lands ON the cut. -->

<!-- sustained match: rain (A) becomes TV static (B), 4-frame equal-power overlap -->
<audio id="amb-rain" src="assets/ambience/rain_steady.wav"
       data-audio-group="ambience" data-start="30.000" data-duration="12.133"
       data-track-index="11" data-volume="0.126"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:12.0,&quot;v&quot;:1},{&quot;t&quot;:12.066,&quot;v&quot;:0.707},{&quot;t&quot;:12.133,&quot;v&quot;:0}]}]}"></audio>
<audio id="amb-static" src="assets/ambience/tv_static_hiss.wav"
       data-audio-group="ambience" data-start="42.000" data-duration="9.000"
       data-track-index="10" data-volume="0.126"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.066,&quot;v&quot;:0.707},{&quot;t&quot;:0.133,&quot;v&quot;:1}]}]}"></audio>
```
Why the `0.707` midpoints: two linear fades sum to a **−3 dB dip** at the midpoint; equal-power crossfades hold constant loudness. The lane's `t` is clip-local and **its first value is held backwards to the clip start**, so the rising lane must state `t: 0, v: 0` explicitly or the incoming bed starts at full level.

Space glue, on both sides — one `<hf-audio-group>` is the honest way, because *"a compressor cannot ride a sequence it only hears a third of"* and the same logic applies to a room:
```html
<hf-audio-group id="matchspace" data-label="Match room" data-volume="1"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;g1&quot;,&quot;label&quot;:&quot;Shared room&quot;,&quot;params&quot;:{&quot;size&quot;:0.4,&quot;damping&quot;:0.5,&quot;wet&quot;:0.16,&quot;dry&quot;:0.9}},
    {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;g2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></hf-audio-group>
```
Two contract notes: a bus's automation `t` is **composition time**, not clip time; and effects with a tail (`reverb`, `delay`) make the rendered track longer than its source, which is expected and not a bug. `data-fx-carve` is clip-only and must never go on the bus.

**ffmpeg — measurement and the two fixes.** All three commands below were run against ffmpeg 6.1.1 on 2026-08-28; `aspectralstats` and `rubberband` are both present in this build.
```bash
# brightness of each side (keys print as lavfi.aspectralstats.1.centroid)
ffmpeg -v error -ss 17.70 -t 0.25 -i ref.wav -af "aspectralstats=measure=centroid+rolloff,\
ametadata=print:key=lavfi.aspectralstats.1.centroid:file=-" -f null - 2>/dev/null

# level of each side
ffmpeg -v error -ss 18.02 -t 0.25 -i ref.wav -af "astats=metadata=1:reset=0" -f null - 2>&1 | grep RMS_level

# tune B up 2 semitones (2^(2/12) = 1.1225), length preserved
ffmpeg -i B.wav -af "rubberband=pitch=1.1225" B.tuned.wav
# without rubberband: asetrate + atempo (changes length, so re-measure the peak)
ffmpeg -i B.wav -af "asetrate=48000*1.1225,aresample=48000,atempo=0.8909" B.tuned.wav

# bake the crossfade only for an asset leaving the pipeline
ffmpeg -i A.wav -i B.wav -filter_complex "acrossfade=d=0.133:c1=tri:c2=tri" AB.wav
```
In-composition, prefer the lanes: baking is for assets leaving the HyperFrames pipeline.

**Epidemic Sound — how to fetch a matchable pair.** The trick is to search for the *second* sound by the properties of the first, and to use similarity search as the matcher.
```
# the pair-hunting pattern: find A, then let the catalogue find B's neighbours
SearchSoundEffects { query:{ term:"telephone ring vintage bell single" },
                     filter:{ duration:{min:800,max:3000} }, first:24 }
SearchSimilarToSoundEffect { id:<A uuid>, first:24 }
#   -> shortlist candidates whose titles name a DIFFERENT object but a similar
#      timbre (bell / alarm / kettle / siren). Similarity here is timbral, which
#      is exactly the axis the match needs.
# useful pairs to search by descriptor chain, catalogue-style:
#   "alarm clock bell mechanical ring"      <-> "telephone ring bell rotary"
#   "kettle whistle steam boil"             <-> "siren distant emergency"
#   "scream human female short"             <-> "train whistle distant"
#   "heartbeat slow single thump"           <-> "kick drum deep low"
#   "rain steady window"                    <-> "tv static hiss white noise"
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Read `durationInMilliseconds` on both, and reject any candidate whose length forces you to loop or stretch it past 1.25× to cover the join.

**Remotion:** two `<Audio>` elements in adjacent `<Sequence>`s with a `volume` callback shaped as an equal-power fade over the overlap. Concept only; Remotion is not part of this stack.

## Pairs with
[[cut-audio-match]] · [[cut-match-cut]] · [[cut-graphic-match]] · [[cut-movement-match]] · [[sfx-split-edit-lead-lag]] · [[sfx-hard-cut-audio-seam]] · [[sfx-transient-masked-outpoint]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-reverb-glue]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-peak-offset-measurement]] · [[sfx-beat-aligned-handover]] · [[sfx-smash-cut-audio-contrast]] · [[motion-graphic-match-alignment-transform]] · [[motion-continuity-across-the-seam]]

## Failure modes
- **Two sounds that are only conceptually similar.** "Both are bells" is not a match if one is 400 Hz and bright and the other is 1.2 kHz and dull. Fix: measure centroid and fundamental first; tune B.
- **A level step at the join.** The single most common tell, and it is measurable. Fix: RMS within 2 dB over 200 ms either side.
- **Lengthening the crossfade to hide a bad match.** Beyond about 8 frames the viewer hears two sounds overlapping, which is worse than a clean cut. Fix: fix pitch/level/timbre, keep the fade short.
- **Two linear fades instead of equal power.** Produces a −3 dB hole exactly at the cut — audible as a dip on a sustained match. Fix: the 0.707 midpoint.
- **A room change across the join.** Dry to reverberant kills the illusion faster than a semitone of pitch error. Fix: shared `reverb` on a group covering both clips.
- **Using it three times.** Conspicuous by design; repetition turns a device into a tic. Fix: one per video, two at most.
- **Smearing a percussive match with a fade.** A transient is the match; fading it removes the thing being matched. Fix: butt cut, and place B by its measured peak offset.
- **Known gap:** nothing in this stack tracks pitch. There is no fundamental-frequency estimator in the verified toolset (`aubio` is unverified here), so the ±3 semitone requirement is checked by ear against a tone, or by eyeballing a spectrogram — the centroid and RMS checks are the parts that are actually automatable.
