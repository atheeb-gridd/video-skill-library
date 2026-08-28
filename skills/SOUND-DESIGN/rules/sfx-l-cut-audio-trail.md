---
id: sfx-l-cut-audio-trail
title: The L cut — hold the outgoing sound over the incoming picture
skill: sound-design
type: cut
family: split-edit
tags: [skill/sound-design, type/cut, family/split-edit, engine/hyperframes, engine/ffmpeg, engine/epidemic, sfx/diegetic, layer/dialogue, layer/ambience, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:02:23
    quote: "An L cut is the opposite."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:02:24
    quote: "The audio from the current scene continues even after the visual cuts to the next."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:02:29
    quote: "You're still hearing a line of dialogue or ambient sound as you're already seeing the new shot."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:02:34
    quote: "This L cut from Ant-Man continues the character's dialogue while we're visually seeing a reenactment scene, bridging the two together."
research_refs:
  - https://en.wikipedia.org/wiki/Split_edit
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://en.wikipedia.org/wiki/Room_tone
difficulty: low
detectable_from: transcript+video
---

# The L cut — hold the outgoing sound over the incoming picture

## What it is
The picture cuts first and the previous shot's audio keeps running underneath the new one. On a timeline the outgoing clip's audio extends **right**, past the video edit, drawing an L. Formally: *"A variant of split edit when the audio from preceding scene overlaps the video from the following scene."*

It is the mirror of the J cut — [[sfx-j-cut-audio-lead]] covers the lead case in full, and [[sfx-split-edit-lead-lag]] covers the pair — but the two are not interchangeable, because they aim at different halves of the viewer's attention. A **J cut makes the viewer anticipate**: the ear is told where you are going before the eye. An **L cut makes the viewer finish a thought**: the eye has already moved on while the ear is still completing the sentence it started. The source's own example is exactly this — a character's dialogue continues *"while we're visually seeing a reenactment scene, bridging the two together."*

For talking-head content this is the single highest-frequency split edit that exists, because it is what a B-roll insert *is*: A-roll audio runs continuously while the picture leaves the face and comes back. Every one of those inserts is an L cut followed by a J cut, and treating them as split edits rather than as "cutaways" is what makes them land on the right frame instead of on the shot boundary.

The reason an L cut is nearly free of sync risk is worth stating: once the speaker's mouth has left the screen, lip-sync ceases to be a constraint at all. The tolerance windows that govern sync — detectability at **45 ms audio-lead to 125 ms audio-lag** (ITU-R BT.1359-1), acceptability **+40 / −60 ms** (EBU R37) — apply only while a mouth is visible. An L cut removes the mouth first, then holds the audio, which is why the overlap can run for seconds without ever feeling out of sync.

## When to use it
- **A sentence is still finishing when the shot has done its work.** Cut the picture on the last useful frame and let the clause land over the next image. This is the default, not the exception.
- **Entering B-roll.** The cut to B-roll happens on the syllable that names the thing, and the A-roll voice continues. Cutting the picture on the *sentence* boundary is the amateur version and reads as slideshow.
- **Bridging two scenes that share a meaning.** The outgoing line comments on the incoming image, which is what turns two shots into one idea.
- **Hiding a bad edit in the picture.** Continuous audio across the seam is the cheapest continuity there is; the eye forgives a jump the ear did not register.
- **Ending a scene without ending its atmosphere.** Trailing *ambience* rather than dialogue moves the viewer's body to the new place a beat after their eyes get there — slower, softer, more cinematic than a hard swap.
- **Not when the outgoing line is the point.** If the audience must watch a reaction while a line lands, keep the picture on the face. An L cut throws away the performance.
- **Not across a hard tonal break.** A smash cut works by giving the ear and the eye the same shock at the same frame ([[sfx-smash-cut-audio-contrast]]); an L cut over one blunts it.
- **Not when the outgoing audio contains a transient** — a door, a slam, a laugh. A transient arriving over an unrelated picture reads as a mistake, not as a bridge.

## How to recognise it in a reference video
- **Compare the picture-cut frame list to the transcript's word boundaries.** An L cut is a picture cut that falls **inside** a spoken word or clause, with the same voice continuing after it. Mechanically: `picture_cut_time` lies strictly between `word.start` and the end of the sentence that word belongs to. Word timings come from `hyperframes transcribe` (`{ text, words:[{text,start,end}] }`), which makes this detection scriptable rather than a listening exercise.
- **Watch for a picture cut with no audio seam.** Print RMS at 0.1 s resolution across the cut. A straight cut shows a step in the noise floor at the cut frame; an L cut shows **no discontinuity at all** at the picture cut, and any discontinuity appears 12–120 frames later.
- **The trailing audio ends on a word or breath boundary, not on a shot boundary.** That mismatch is the tell.
- **Measure the overlap in frames.** Log `overlap = audio_out_time − picture_cut_time` at 30 fps. In this corpus the distribution is bimodal: **12–36 frames** for conversational bridges, **1–4 seconds** for A-roll-over-B-roll inserts. A value under 6 frames is not an L cut, it is a sloppy straight cut.
- **Ambience L cuts show as a band, not a step.** On a spectrogram the outgoing location's broadband bed tapers over 0.5–2 s after the picture has already changed, while the incoming location's bed rises underneath it. Two beds briefly coexist; that crossfade region is the L cut.
- **Count the pattern, not the instance.** A creator who uses L cuts uses them constantly. If more than about 30% of picture cuts fall mid-clause with continuous audio, log it as a style property in the profile, not as a one-off technique.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `overlap_dialogue` | 18f (0.6 s) | 12–36f | Enough to complete a clause. Under 12f the viewer registers a stutter rather than a bridge. |
| `overlap_broll` | 60f (2.0 s) | 30f–8 s | The whole B-roll insert. Bounded by how long the picture can leave the speaker before the video feels like a slideshow. |
| `overlap_ambience` | 24f (0.8 s) | 12–60f | Longer than a dialogue trail, because a location bed is diffuse and its exit is inaudible. |
| `audio_out_fade` | 6f (0.2 s) | 3–15f | Dialogue: cut clean on the word end, no fade. Ambience: fade, always. A hard-cut ambience tail clicks. |
| `incoming_bed_lead` | 0f | 0–12f | The incoming location's bed may start a few frames *before* the picture — a J cut on ambience under an L cut on dialogue. This is the seamless case. |
| `trailing_level` | −3 dB from its own level | −6 to 0 dB | Optional taper so the outgoing voice yields to the new image without disappearing. |
| `min_incoming_handle` | 12f | ≥ 6f | Frames of usable media past the incoming clip's in-point. Below this the L cut has nothing to sit over. |
| `max_dead_air_after` | 8f | 0–12f | Silence between the trailing audio's end and the incoming audio's start. More than 12f and the bridge breaks in two. |
| `density` | ≤30% of cuts | 10–50% | Above 50% every cut is soft and the edit loses its punctuation entirely. |

## Reproduction prompt

```
Convert the straight cut at {{CUT}} (seconds) into an L cut: the outgoing
shot's audio continues over the incoming picture.

1. FIND THE REAL OUT-POINT IN THE AUDIO, not in the picture. Read the
   transcript's word timings around {{CUT}}. Let W be the last word of the
   clause in progress at {{CUT}}. Set AUDIO_OUT = W.end + 0.08 (a breath's
   worth of tail). If {{CUT}} is already past W.end, this is not an L cut -
   stop.
2. MOVE THE PICTURE CUT EARLIER, not the audio later. Set the outgoing
   video's out-point to {{CUT}}, and confirm {{CUT}} lands mid-clause. Target
   OVERLAP = AUDIO_OUT - {{CUT}} of 12-36 frames (0.4-1.2 s) for a
   conversational bridge, or the full insert length for B-roll.
3. SPLIT PICTURE FROM SOUND. The outgoing video clip ends at {{CUT}}. The
   outgoing AUDIO clip keeps the same data-start and its duration is extended
   to AUDIO_OUT. Same data-media-start on both, so nothing slips.
4. FADE. Dialogue: no fade, cut on the word tail. Ambience or music:
   6-frame (0.2 s) fade to zero at AUDIO_OUT.
5. GIVE THE INCOMING SHOT ITS OWN FLOOR. The incoming picture with no audio
   under it produces digital silence, which reads as a fault. Either start the
   incoming clip's ambience at {{CUT}} (or 6 frames before it, making a J cut
   on the bed under the L cut on the voice), or extend the outgoing room tone
   through the overlap.
6. CHECK DEAD AIR. Measure the gap between AUDIO_OUT and the next audio
   event. If it exceeds 8 frames, either shorten the trail or start the next
   line earlier - a hole in the middle of a bridge undoes the bridge.

ACCEPTANCE TEST: play {{CUT}} - 3 s to {{CUT}} + 3 s once. You must not be
able to name the frame the picture changed on without stepping back through
it. Then mute the picture and listen alone: the audio must sound like one
uninterrupted take with no step in its noise floor. If you hear a step, the
outgoing clip's tail was trimmed into silence instead of into room tone.
```

## Execution spec

**HyperFrames — the L cut is one number.** The project convention already splits picture from sound: *"Videos use `muted` with a separate `<audio>` element for the audio track"* (`CLAUDE.md` key rule 4), which is described as *"the pattern to reach for when picture and sound are cut independently."* An L cut is therefore not a special construct — it is the audio clip's `data-duration` being **longer** than its video clip's, with both sharing `data-start` and `data-media-start` so nothing slips.

Cut at 12.40 s; the clause finishes at 13.00 s; overlap 18 frames (0.6 s):

```html
<!-- OUTGOING picture: ends on the cut frame -->
<video id="shot-a" src="assets/aroll/take-04.mp4" muted playsinline
       data-start="8.00" data-duration="4.40" data-media-start="31.2"
       data-track-index="0"></video>

<!-- OUTGOING sound: same start, same media-start, 0.6 s LONGER. This is the L. -->
<audio id="shot-a-audio" src="assets/aroll/take-04.mp4"
       data-audio-group="voiceover"
       data-start="8.00" data-duration="5.00" data-media-start="31.2"
       data-track-index="10"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:4.80,&quot;v&quot;:1},{&quot;t&quot;:5.00,&quot;v&quot;:0}]}]}"></audio>

<!-- INCOMING picture: starts on the cut frame, under the trailing voice -->
<video id="shot-b" src="assets/broll/desk-02.mp4" muted playsinline
       data-start="12.40" data-duration="3.60" data-media-start="2.0"
       data-track-index="0"></video>

<!-- INCOMING bed: starts 6 frames EARLY so there is never digital silence -->
<audio id="shot-b-amb" src="assets/sfx/ambience/office_room_tone.wav"
       data-audio-group="ambience"
       data-start="12.20" data-duration="3.80" data-track-index="11"
       data-volume="0.040"></audio>
```
Contract points that decide whether this runs. Time is **seconds, always** — there is no frame attribute, so 18 frames at 30 fps is authored as `0.6` and the frame count survives only as a comment. Every `<audio>` **needs an `id`** or it is never mixed and the trail vanishes from the render with no error. `data-track-index` is *"display only"* — clips on one track may overlap, so the fact that `shot-a-audio` and `shot-b-amb` coexist in time is fine and does not need separate lanes, though separate lanes keep the Studio timeline readable. `data-media-start` must be **identical** on the picture and sound of the same take, because *"HyperFrames does not provide automatic waveform sync or drift correction"* — alignment is authored by writing the same numbers twice, and an L cut is precisely the edit where forgetting that produces a slip you will not hear until the next re-edit.

Relative timing can express the overlap directly — `data-duration` cannot reference another clip, but the incoming bed can: `data-start="shot-b - 0.2"`. Use it knowing the four silent-zero failure modes from the contract's §2; a typo'd id resolves to 0 rather than erroring.

Keep the outgoing voice in `data-audio-group="voiceover"` so it stays part of the carve source set for any music bed ([[sfx-beat-forward-bed-under-voice]]). A trailing line that falls out of the voice group is the reason a bed suddenly stops carving over a cut.

**ffmpeg.** Only when you need a file, which for an L cut is rare — the overlap is a composition-level operation. Two cases where it is not:
```bash
# harvest the incoming location's room tone so the new shot is never dead
ffmpeg -i desk-02.mp4 -ss 0.0 -to 4.0 -vn -c:a pcm_s16le desk_room_tone.wav
# confirm the outgoing take actually HAS the handle you are about to use
ffprobe -v error -show_entries format=duration -of csv=p=0 take-04.mp4
# find the word tail objectively: silence boundaries at -40 dB, 120 ms minimum
ffmpeg -i take-04.wav -af "silencedetect=n=-40dB:d=0.12" -f null -
```
`silencedetect` is the honest way to place `AUDIO_OUT`: take the first `silence_start` after `{{CUT}}`, and trim there rather than guessing from the waveform.

**Epidemic Sound.** The L cut's own asset need is the **incoming shot's floor**, because the moment the picture changes with no bed under it the mix goes to digital silence and *"the sound track 'going dead' would be perceived by the audience not as silence, but as a failure of the sound system."* Fetch the destination's room tone:
```
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["ambience--room-tone"]},
                              duration:{min:60000} },
                     query:{term:"office room tone"},
                     sort:{by:DURATION, order:DESCENDING}, first:12 }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
`ambience--room-tone` is a verified live slug returning 120 s+ beds; a wrong slug returns `meta.total: 0`, so zero results means fix the slug rather than widen the search ([[sfx-ambience-search-formula]]).

**Remotion.** The audio `<Sequence>` for the outgoing shot has a larger `durationInFrames` than its video `<Sequence>`, both sharing the same `startFrom`. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-j-cut-audio-lead]] · [[sfx-split-edit-lead-lag]] · [[sfx-hard-cut-audio-seam]] · [[sfx-ambience-establishes-location]] · [[sfx-ambience-search-formula]] · [[sfx-noise-floor-target]] · [[sfx-pause-removal-breath-and-room-tone]] · [[sfx-audio-match-bridge]] · [[sfx-smash-cut-audio-contrast]] · [[sfx-beat-forward-bed-under-voice]] · [[cut-l-audio-trails-picture]] · [[cut-l-voice-over-reenactment]] · [[cut-split-edit-attention-steering]] · [[cut-b-roll-coverage-from-transcript]] · [[cut-on-action]]

## Failure modes
- **Cutting the picture on the sentence boundary instead of inside it.** Produces a straight cut with extra steps and reads as a slideshow. Fix: put the picture cut on the syllable that names the incoming image, mid-clause.
- **Trimming the trail into digital silence.** The outgoing audio ends and the noise floor drops to nothing under the new picture. This is the fault the ear catches every time. Fix: extend room tone through the overlap, or start the incoming bed 6 frames early.
- **A transient in the trail.** A door close or a laugh arriving over an unrelated image reads as a continuity error. Fix: move `AUDIO_OUT` before the transient, or pick a different cut point.
- **Different `data-media-start` on the picture and the sound of the same take.** Silent, invisible, and it drifts. Fix: write the same number on both elements, every time.
- **Overlap under 6 frames.** Not perceived as a bridge; perceived as a mistimed cut. Fix: 12 frames minimum, or make it a straight cut on purpose.
- **L-cutting everything.** Above roughly half of all cuts, the edit has no punctuation left and every scene change feels the same weight. Fix: reserve straight cuts for the beats that should land hard.
- **Using it under a smash cut.** Blunts the shock the smash cut exists to deliver. Fix: hard-cut both tracks on the same frame there ([[sfx-smash-cut-audio-contrast]]).
- **Forgetting the trailing voice's group membership.** A voice clip outside `data-audio-group="voiceover"` is invisible to the carve, so the music bed un-carves for exactly the length of the trail. Fix: group every voice clip, including trails.
- **Known gap:** nothing in this stack detects picture/sound drift — *"No automatic waveform sync or drift correction"* — so an L cut whose numbers were mistyped will render wrong with no warning. The only defence is the acceptance test: listen to the audio alone across the seam and confirm there is no step.
