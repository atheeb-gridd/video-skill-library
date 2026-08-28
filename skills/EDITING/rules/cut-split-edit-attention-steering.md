---
id: cut-split-edit-attention-steering
title: Split edits as attention control — decide which sense leads, and where the eye goes
skill: editing
type: cut
family: audio-led
tags: [skill/editing, type/cut, family/audio-led, layer/dialogue, layer/ambience, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:00"
    quote: "They let editors guide the audience's attention, build emotional impact, and instead of just feeling like a hard stop, the J and L cut make the film feel more immersive."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:53"
    quote: "These cuts are incredibly useful because they create a smoother, more natural flow between shots, especially in conversations."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:34"
    quote: "This L cut from Ant-Man continues the character's dialogue while we're visually seeing a reenactment scene, bridging the two together."
research_refs:
  - https://www.studiobinder.com/blog/walter-murch-rule-of-six/
  - https://filmdaft.com/walter-murchs-rule-of-six-the-editors-formula-for-choosing-the-right-cut/
  - https://www.studiobinder.com/blog/how-to-edit-a-dialogue-scene/
  - https://www.studiobinder.com/blog/what-is-a-reaction-shot-definition/
  - https://www.filmmakersacademy.com/glossary/average-shot-length-asl/
  - https://artlist.io/blog/eye-trace-and-rule-of-six-editing/
difficulty: medium
detectable_from: transcript+video
---

# Split edits as attention control — decide which sense leads, and where the eye goes

## What it is
The principle underneath the J cut and the L cut, stated as a choice rather than as two shapes. Because a cut has **two tracks and they need not move together**, the editor picks which sense arrives first — and that choice decides what the audience is paying attention to and how they read the moment emotionally. Sound leading (a **J cut**) points attention *forward*: the ear commits to the next thing while the eye is still on the old one, so the picture cut lands as confirmation. Picture leading (an **L cut**) frees the eye to go somewhere else while the ear stays on the line still being spoken — which is how you cut to a listener, a hand, a screen, a reaction, or a piece of evidence without dropping a word of the argument.

Framed in Murch's terms, this is a lever on the two criteria that matter most. His Rule of Six ranks a cut's obligations **emotion 51%, story 23%, rhythm 10%, eye-trace 7%, two-dimensional plane of the screen 5%, three-dimensional space of action 4%** — and a split edit is one of the very few purely mechanical moves that operates directly on the top two. It changes nothing about the shots; it changes what the audience is *doing* at the moment of the cut.

The mechanics of each shape — lead times, media-start slipping, fade-ins, ducking — live in [[cut-j-audio-leads-picture]] and [[cut-l-audio-trails-picture]]. **This note is the chooser**: given a moment and an intent, which sense should lead, for how long, and what the eye must find when the picture finally changes.

## When to use it
Reach for the chooser at any boundary where the *hard cut is technically fine but emotionally flat*, and at any boundary where you want the audience looking somewhere the speaker is not. Specific triggers:

- **You want a reaction, not a statement.** The line matters less than its effect. Cut picture to the listener, keep the speaker's audio running (L). This is the single most common professional split edit and the reason reaction shots read as reactions rather than as cutaways.
- **You want evidence to land under a claim.** In explainer work: presenter keeps talking, picture goes to the screen recording, the graph, the product. L cut. The claim and the proof occupy the same seconds instead of consecutive ones ([[cut-screen-recording-proof-insert]]).
- **You want anticipation.** Something is about to change and you want it felt before it is seen. Bring the next scene's ambience or first sound in early (J).
- **You want a question to pull the viewer forward.** Sound leads with the setup while the picture is still elsewhere ([[cut-j-curiosity-lead]]).
- **You want to soften a boundary that has no narrative reason to be abrupt.** Any split, 8–12 frames, fixes most of them.

Do **not** split when the abruptness *is* the meaning — a smash cut, a hard information break ([[cut-hard-cut-for-new-information]]), a punchline, an act boundary or a fade. Do not split at a structural boundary where the whole point is that something ended ([[cut-fade-bookend]]). And do not split *every* cut: an edit with no hard cuts left has nothing to make a point with.

## How to recognise it in a reference video
- **Log two timecodes per boundary, never one.** Picture-change time and audio-change time, then subtract. `audio_onset < picture_cut` = J; outgoing audio continuing past `picture_cut` = L; both within ±2 f = straight cut.
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  `n=1600` at 48 kHz is exactly one frame at 30 fps, so the printed `pts_time` values are frame-aligned.
- **Then classify the intent, which is the part that matters here.** For every split, answer: *what is the viewer looking at during the overlap, and why?* Write it down. The four answers you will see are: a listener/reaction; an object or evidence; a new place; the same speaker in a new size. A reference video where every split resolves to "a new place" is doing smoothing; one where splits resolve to "a listener" is doing emotion.
- **Reaction-shot holds are measurable.** For each L cut onto a listener, log how long the listener is held under continuing audio. Typical bands: **0.8–1.5 s (24–45 f)** for a beat of acknowledgement; **1.5–3.0 s (45–90 f)** when the reaction *is* the point; over ~4 s the shot has become the new scene and the audio should have followed it. Compare against the video's own average shot length — a reaction held at 2–3× the local ASL is being emphasised deliberately.
- **Eye-trace check across the cut.** Note where the point of interest sits in the outgoing frame's last frame (left/centre/right, high/low) and where it sits in the incoming frame's first frame. A well-steered split puts them in **the same screen region**; the viewer's eye is already there and the cut disappears. A jump from far-left to far-right at a split edit is the reason some splits still feel rough.
- **Cut point relative to the sentence.** Log whether the picture cut lands mid-clause, on a comma, or at a full stop. **Mid-clause picture cuts are the professional signature** of attention steering — the sentence's continuity is what welds the two images together. Cuts that always land at full stops mean nobody is steering; the edit is just following punctuation.
- **Split ratio.** Split edits ÷ total cuts. Dialogue-heavy edits run **30–60%**; explainer edits **10–25%**. Both 0% and 100% are signatures worth logging.
- **Which track carries the overlap.** Dialogue, ambience, diegetic effect or music. Ambience-led splits are invisible; dialogue-led splits are noticed and felt; a music change at a boundary is a *section device*, not a split edit, and should be logged separately ([[sfx-track-change-at-section-boundary]]).
- **Transcript-only detection.** Align the transcript to the picture cuts. A word that begins before the frame where the picture changes, or a sentence that continues past it, is a split edit — detectable without ever looking at the audio waveform.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `lead_sense` | picture | picture (L) \| sound (J) | The decision this note exists for. See the chooser in the prompt. |
| `l_trail` | 15 f (0.50 s) | 6–72 f | Outgoing audio held past the picture cut. Longer than a J lead is normal: trailing dialogue is more tolerable than early dialogue. |
| `j_lead` | 12 f (0.40 s) | 6–60 f | Incoming audio ahead of its picture. Dialogue 6–12 f · B-roll 12–30 f · location/ambience 24–60 f. |
| `max_lead` | 75 f (2.5 s) | — | Beyond this a J stops reading as a split edit and becomes an audio-led montage. |
| `reaction_hold` | 45 f (1.5 s) | 24–90 f | Listener/reaction shot under continuing audio. Over 120 f the audio must follow the picture. |
| `reaction_ratio` | 2.0× local ASL | 1.5–3.0× | How much longer than the surrounding average shot a deliberate reaction is held. |
| `cut_position` | mid-clause | mid-clause \| comma \| full stop | Mid-clause is the attention-steering position. Full-stop-only cutting is unsteered. |
| `eye_trace_zone_match` | required | — | Point of interest in the same third of frame across the cut, horizontally and vertically. |
| `split_ratio` | 0.20 | dialogue 0.30–0.60 · explainer 0.10–0.25 | Split edits ÷ total cuts. |
| `overlap_track` | ambience | ambience \| dialogue \| diegetic sfx | Choose ambience to be invisible, dialogue to be felt. Never music. |
| `outgoing_duck_db` | −3 dB | 0 to −6 dB | Applied only across a J's lead window, back to unity at the cut. |
| `incoming_fade_in` | 4 f (0.13 s) | 0–8 f | 0 f only when the incoming audio starts on a transient. |
| `sync_tolerance` | ±1 f | ±0–2 f | Picture and its **own** sound stay locked; only the boundary is split. |
| `one_direction_per_boundary` | true | — | Never stack a J and an L at the same cut. |

## Reproduction prompt

```
At the boundary {{CUT}} (seconds, 30fps) between clip {{A}} and clip {{B}},
decide and build the split edit.

1. STATE THE INTENT in one sentence: "at this moment I want the viewer to be
   ___". If you cannot, make a straight hard cut and stop here.
2. CHOOSE THE LEADING SENSE from the intent:
   - looking at someone's or something's REACTION while a line continues
     -> PICTURE LEADS (L cut). Cut picture to the reaction, keep A's audio.
   - looking at EVIDENCE (screen, graph, object) under a continuing claim
     -> PICTURE LEADS (L cut).
   - ANTICIPATING a change of place, speaker or subject
     -> SOUND LEADS (J cut). Bring B's ambience or first sound in early.
   - receiving NEW INFORMATION that must feel like a clean break
     -> NEITHER. Straight cut. Do not split.
3. SET THE OVERLAP. L: hold the new picture {{HOLD}} = 45 frames by default;
   24-45f for acknowledgement, 45-90f when the reaction is the point, never
   past 120f without letting the audio follow. J: {{LEAD}} = 8f for
   conversational dialogue, 12f into B-roll, 30f for a location change
   carried by ambience; never above 75f.
4. PLACE THE PICTURE CUT MID-CLAUSE, not on a full stop, unless the intent is
   a clean break. The unbroken sentence is what welds the two images.
5. STEER THE EYE. Identify the point of interest in A's last frame and put
   B's point of interest in the same third of the frame, horizontally and
   vertically. If B cannot be framed that way, scale or reposition B, or pick
   a different incoming frame.
6. KEEP INTERNAL SYNC. Whichever clip's audio moves, its media offset moves
   by exactly the same amount, so that clip's own picture and sound stay
   locked to within 1 frame. Fade the incoming audio up over 4 frames unless
   it starts on a transient.
7. ONE DIRECTION ONLY. Never overlap A's audio forward and B's audio backward
   at the same boundary.
8. ACCEPTANCE TEST: (a) play it once and say out loud what you were looking
   at during the overlap - if the answer is "nothing in particular", the
   split has no job and should be a hard cut; (b) close your eyes and play
   it - you should hear one continuous thought, no seam; (c) frame-step: the
   moved audio is exactly {{LEAD}}/{{HOLD}} frames from the picture cut and
   each clip's own picture and sound are within 1 frame; (d) count splits
   across the whole video and keep the ratio inside the profile band.
```

## Execution spec

**HyperFrames (primary).** The project convention — **muted `<video>` plus a separate `<audio>` for its sound** — exists precisely so picture and sound can be cut independently. A split edit is two different `data-start` values plus a matching shift in `data-media-start`. All authored time is in **seconds**; frames are a comment.

```html
<!-- L cut: picture goes to the reaction at 21.40s, A's audio runs on to 21.90s -->
<video id="shot-a" src="a.mp4" muted playsinline class="clip"
       data-start="16.00" data-duration="5.40" data-media-start="3.00" data-track-index="0"></video>
<audio id="shot-a-aud" src="a.mp4" data-audio-group="voiceover"
       data-start="16.00" data-duration="5.90" data-media-start="3.00" data-track-index="10"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:5.6,&quot;v&quot;:1},{&quot;t&quot;:5.9,&quot;v&quot;:0}]}]}"></audio>

<video id="shot-b" src="b.mp4" muted playsinline class="clip"
       data-start="21.40" data-duration="4.00" data-media-start="8.00" data-track-index="0"></video>
<audio id="shot-b-aud" src="b.mp4" data-audio-group="voiceover"
       data-start="21.90" data-duration="3.50" data-media-start="8.50" data-track-index="11"></audio>
<!-- 0.50s = 15f @30fps. shot-b-aud starts 0.50 late AND its media-start is 0.50 later,
     so B's picture and B's own sound stay locked from 21.90 onward. -->
```

Five contract facts that break this if ignored: every `<audio>` needs an **`id`** (id-less audio is never mixed → silent render); two overlapping audio clips must not share a `data-track-index` (`duplicate_audio_track`); a `data-automation` lane's `t` is **clip-local seconds** and **holds its first value backwards** to the clip start, so an unwanted fade at the top is prevented by an explicit `{"t":0,"v":1}` point; do **not** also GSAP-tween `volume` on a track that has a `volume` lane (`audio_volume_double_automation` — the lane wins); and picture/sound alignment is authored by **writing the same numbers twice** — there is no automatic waveform sync in this stack.

**Eye-trace steering, in-composition.** Repositioning B so its point of interest matches A's is a transform on the clip, not a media operation: GSAP `x`/`y`/`scale` on the clip wrapper, or a `clip-path` crop. Never tween `width`/`height`/`top`/`left`; never put a CSS `transform` on an element you also GSAP-tween (`gsap_css_transform_conflict`, error). A static reframe can also be a plain CSS `object-position` / `clip-path` with no tween at all — the contract prefers `clip-path` for render-time cropping with the source untouched.

**ffmpeg (only when the split leaves the pipeline).** Slip one side's audio with `atrim` + `adelay` (milliseconds) in a single filter graph and mix:
```bash
ffmpeg -i a_cut.mp4 -i b.mp4 -filter_complex "\
 [1:a]atrim=start=8.5,asetpts=PTS-STARTPTS,adelay=21900|21900[bl];\
 [0:a][bl]amix=inputs=2:normalize=0[aout]" -map 0:v -map "[aout]" -c:v copy out.mp4
```

**Epidemic Sound.** When the overlap should be ambience-led and the incoming location has no usable sound of its own: `SearchSoundEffects { query.term: "<location> ambience room tone loop", filter.duration { min: 8000 } }`. Place it as its own clip in an `ambience` group — **never** in the `voiceover` carve group, which must contain voices only or the next carve re-analysis is silently poisoned.

**Remotion:** conceptually a `<Sequence>` for picture and a separately-offset `<Audio>`; no Remotion runtime exists in this project.

## Pairs with
[[cut-j-audio-leads-picture]] · [[cut-l-audio-trails-picture]] · [[cut-l-voice-over-reenactment]] · [[cut-j-curiosity-lead]] · [[cut-eye-trace-continuity]] · [[cut-hard-cut-for-new-information]] · [[cut-screen-recording-proof-insert]] · [[struct-objection-character-cutaway]] · [[cut-invisible-storytelling-doctrine]] · [[sfx-ambience-bridge-across-cut]] · [[cut-on-action]] · [[pace-overlay-instead-of-cut]]

## Failure modes
- **Splitting with no stated intent.** A split that steers attention nowhere just makes the boundary mushy. Fix: if you cannot finish "I want the viewer to be ___", hard cut.
- **Cutting on the full stop every time.** Punctuation-following is not steering; the sentence break and the picture break reinforce each other and the edit reads as a slideshow. Fix: put the picture cut mid-clause.
- **Ignoring eye trace.** The overlap is correct to the frame and the cut still feels rough because the eye has to travel across the screen. Fix: match the point-of-interest zone, or reframe the incoming shot.
- **Holding the reaction too long.** Past about 4 s the listener has become the scene while the audio is still elsewhere, and the viewer starts wondering when the picture will catch up. Fix: shorten, or let the audio follow the picture and make it a real scene change.
- **Sliding audio without sliding the media offset.** The sound plays early or late but is the *wrong* sound, and that clip is then out of sync for its whole duration. Fix: shift `data-media-start` by exactly the same amount.
- **Leading with dialogue when invisibility was the goal.** Early speech is always noticed. Fix: lead with room tone for smoothing; save dialogue leads for deliberate anticipation.
- **Stacking a J and an L at one boundary.** Two overlapping beds turn the cut into mush. Fix: one direction per boundary.
- **Splitting everything.** No hard cuts remain, so nothing can be emphasised. Fix: keep the split ratio inside the format's band and keep smash cuts hard.
- **Known gap:** nothing authoritative publishes numeric hold times for reaction shots or split-edit lead times — the profession's guidance is "a few frames to a second or two" and "as long as it plays". The frame bands here are house calibration anchored to that range and to measured average-shot-length data. When a reference video exists, measure its holds and prefer those.
