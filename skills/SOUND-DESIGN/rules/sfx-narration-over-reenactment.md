---
id: sfx-narration-over-reenactment
title: Holding a voice over an illustrative cutaway — the reenactment L cut and its three sound jobs
skill: sound-design
type: cut
family: split-edit
tags: [skill/sound-design, type/cut, family/split-edit, sfx/diegetic, layer/dialogue, layer/ambience, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:02:34
    quote: "This L cut from Ant-Man continues the character's dialogue while we're visually seeing a reenactment scene, bridging the two together."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:02:24
    quote: "The audio from the current scene continues even after the visual cuts to the next. You're still hearing a line of dialogue or ambient sound as you're already seeing the new shot."
research_refs:
  - https://en.wikipedia.org/wiki/Voice-over
  - https://en.wikipedia.org/wiki/Cutaway_(filmmaking)
  - https://en.wikipedia.org/wiki/Diegesis
  - https://en.wikipedia.org/wiki/Sound_effect
difficulty: medium
detectable_from: transcript+video
---

# Holding a voice over an illustrative cutaway — the reenactment L cut and its three sound jobs

## What it is
A specific and very high-value case of the L cut: the picture leaves the speaker and goes to a **dramatisation of what they are describing** — a reenactment, an illustrative insert, a screen recording, a piece of stock — while their voice keeps running underneath. The voice stops being in-scene dialogue and starts functioning as narration over new material, which is exactly what a voice-over is: *"the filmmaker distributes the sound of a human voice (or voices) over images shown on the screen that may or may not be related to the words that are being spoken."* The generic split-edit mechanics live in [[sfx-l-cut-audio-trail]]; **this note is the three sound jobs the illustrative case adds**, none of which the plain L cut has to solve.

**Job 1 — the cutaway brings its own production sound, and you must decide what it is worth.** A cutaway is *"the interruption of a continuously filmed action by inserting a view of something else"*, and that something else was recorded somewhere else, with its own room, its own floor and often its own voices. Three outcomes: keep it low and diegetic (a demo whose sound is part of the point), replace it with room tone (a shot whose sound is just camera noise), or mute it and let a designed bed carry the space. Muting with nothing underneath is the one wrong answer — it produces a hole in the noise floor at both edges that reads as a mistake ([[sfx-noise-floor-target]]).

**Job 2 — decide whether the held voice is still in the room or has become narration, and treat it accordingly.** These are different acoustic positions and the audience hears the difference. *In-scene*: the voice keeps the original recording's space, so the cutaway feels like it is happening *while* the speaker talks. *Narration*: the voice moves closer and drier than any of the pictures, so it reads as commentary from outside the scene. Pick one deliberately; the failure is the accidental middle, where the voice sounds like it is in a room that is on screen but sounds nothing like it.

**Job 3 — the cutaway has a clock.** Once the mouth is off screen there is no lip-sync constraint at all, so the overlap can technically run forever. What limits it is attribution: past roughly 12–15 seconds the viewer stops hearing a person and starts hearing a disembodied track, and the return to face lands as a surprise rather than a resolution.

## When to use it
- **The speaker describes an event, a process or a place** and you have footage of it. This is the canonical trigger and covers most B-roll: the voice becomes narration for the illustration.
- **A claim needs evidence in-frame** — a screen recording of the thing working, a demo, a chart. The voice must not stop to let the evidence play, or the evidence reads as a digression.
- **Two spaces need bridging into one idea.** The source's own framing: the continuing dialogue is what "bridges the two together." The voice is the continuity, not the picture.
- **A talking-head passage is running long** and needs visual variety without a break in the argument.
- **Not when the cutaway contains someone speaking.** Two voices at once is a dialogue overlap, not an illustrative cutaway, and needs one of them to win outright.
- **Not when the cutaway's own sound is the point** — a musician playing, a car starting, a machine. Then the cutaway audio should come *up*, and the held voice should end before it, which is a J cut into diegetic sound instead ([[sfx-j-cut-audio-lead]]).
- **Not across a section boundary.** An L cut bridges; a boundary is supposed to break. Ending the voice on the cut is the correct move there.

## How to recognise it in a reference video
- **The picture cuts and the waveform does not.** Look for a picture change with **no discontinuity at all** in the speech envelope — no gap, no level step, no timbre change on the syllable that straddles the cut. That single observation identifies the technique.
- **Second, quieter layer appears within 2–6 frames of the picture cut**, fading in over 4–12 frames rather than switching on: that is the cutaway's production sound being brought up under the voice. Measure it — in a well-mixed example it sits **14–24 dB under the held voice**.
- **The floor changes but does not step.** Compare the noise floor 0.5 s before and 0.5 s after the picture cut. A clean example moves by **≤3 dB**; a broken one shows a 6–15 dB step, which is the sound of production audio being hard-muted.
- **Voice acoustic across the cut.** If the held voice suddenly gets drier or louder *at* the cut, the editor has moved it to narration position mid-sentence — audible and wrong. The treatment change, if any, belongs at a sentence boundary, not a picture boundary.
- **Cutaway duration.** Time from the picture cut to the return to the speaker's face. Typical **3–12 s**; a competent long-form creator returns within 15 s or motivates the stay with a second visual event. Log any cutaway over 20 s as a finding.
- **Return cadence.** Over a whole video, count seconds-on-face vs seconds-on-cutaway per minute. A talking-head explainer usually runs **35–60 % on face**; below 25 % the video reads as a narrated slideshow.
- **Transcript signal.** The cutaway starts inside a clause, not at a full stop. If picture cuts consistently land on sentence ends, the editor is cutting to the transcript rather than L-cutting.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Picture cut vs speech | mid-clause, **never on a stressed syllable** | — | Cut on an unstressed syllable or a consonant; the ear will not mark it. |
| Voice lead before picture cut (`L` overlap) | continuous — the voice never stops | — | This is the definition. Any gap turns it into two shots. |
| Cutaway duration | 6 s | 2–15 s | Under 2 s reads as a flash-frame; over 15 s the speaker is lost. |
| Hard ceiling before returning to face | 15 s | 12–20 s | Beyond 20 s, motivate it with a second visual event or return. |
| Face share of runtime | 45 % | 25–70 % | Below 25 % the video reads as narration over slides. |
| Cutaway production sound (informative) | −16 dB rel. dialogue → `data-volume="0.158"` | −20 … −12 dB | A demo, a machine, a UI — sound that carries information. |
| Cutaway production sound (incidental) | −24 dB → `data-volume="0.063"` | −30 … −20 dB | Room and handling noise only. Consider replacing with room tone instead. |
| Cutaway audio fade in / out | 8 f (0.267 s) | 4–12 f | Never a hard in. A step in the floor is the giveaway. |
| Held voice level | unchanged, 0 dB | 0 … +1.5 dB | If you must lift it for the busier picture, +1.5 dB is the ceiling. |
| Narration treatment — reverb `wet` | 0.03 | 0.00–0.06 | Drier than any pictured room. Use only if committing to narration position. |
| In-scene treatment — reverb `wet` | 0.12 | 0.08–0.18 | Matches the reenactment space; use the room the *cutaway* shows. |
| Presence lift (narration only) | `peaking` 3000 Hz +2.5 dB Q 1 | +1.5 … +3 dB | The rack's "Add Clarity" job. **Check the preset first** — `voice-clean` already contains it. |
| Low trim on cutaway audio | `highpass` 120 Hz | 90–160 Hz | Keeps the cutaway's rumble out of the voice's weight band. |
| Music bed under the cutaway | unchanged | — | Do **not** raise the bed to "fill" the cutaway. The cutaway's own sound fills it. |
| Treatment-change position | sentence boundary | — | Never at the picture cut. |

## Reproduction prompt
```
Hold the speaker's voice across a picture cut to an illustrative/reenactment shot,
from {{T_CUT}} to {{T_RETURN}} (composition seconds). 30 fps: 1 frame = 0.0333 s.

1. PICK THE CUT FRAME. Find an unstressed syllable or a consonant inside a clause
   between {{T_CUT}}-0.5 and {{T_CUT}}+0.5 and cut the PICTURE there. Do NOT cut on
   a sentence end and do NOT cut on a stressed vowel. The audio clip is untouched -
   the voice track spans the whole passage as ONE clip. If you find yourself trimming
   the voice, stop: that is not this technique.

2. DECIDE THE CUTAWAY'S OWN SOUND. Answer one question: does the cutaway's audio
   carry information the viewer needs?
     YES (a demo, a device, a UI, an action) -> place it at -16 dB rel dialogue.
     NO  (handling noise, room, wind)        -> place it at -24 dB, OR replace it
         with a matching room-tone/ambience bed and mute the production track.
     NEVER mute it and leave nothing. A silent cutaway makes a 6-15 dB hole in the
     noise floor at both edges and reads as a fault.
   Fade it in over 8 frames from {{T_CUT}} and out over 8 frames at {{T_RETURN}}.

3. DECIDE THE VOICE'S POSITION and do not change it mid-sentence.
     IN-SCENE  -> leave the voice's own acoustic alone, and if anything add reverb
                  wet 0.12 matching the room the cutaway shows.
     NARRATION -> reverb wet <= 0.03 and, only if the voice chain does not already
                  contain it, one peaking node at 3000 Hz +2.5 dB Q 1.
   Check the existing chain first: voice-clean already includes an Add Clarity node,
   and adding a second is +5 dB at 3 kHz where +2.5 was meant.

4. SET THE RETURN. {{T_RETURN}} default = {{T_CUT}} + 6 s, hard ceiling +15 s. Return
   on a clause boundary so the face reappears with a new thought, not mid-word.

5. LEAVE THE MUSIC ALONE. Do not raise the bed under the cutaway.

ACCEPTANCE TEST.
(a) Close your eyes through {{T_CUT}}: nothing happens. If you can hear the picture
    cut, the mix is wrong.
(b) Noise floor 0.5 s either side of {{T_CUT}} differs by <= 3 dB.
(c) The speech straddling the cut is one continuous waveform - no gap, no level step.
(d) {{T_RETURN}} - {{T_CUT}} <= 15 s.
(e) The held voice is fully intelligible with the cutaway audio at level. If not,
    lower the cutaway, never the music, and never lift the voice above +1.5 dB.
```

## Execution spec

**Placement spec (the three numbers).**

| | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Held voice | spans the cut; **no offset, no edit** | 0 dB (`data-volume` 1.0) | none — it is the thing everything else ducks for |
| Cutaway production sound | in at the cut frame, 8 f fade | −16 dB informative (0.158) / −24 dB incidental (0.063) | manual `volume` lane, not a carve |
| Room-tone substitute | spans the cutaway ±0.3 s | −28 dB (0.04) | none |
| Music bed | unchanged across the cut | −22 dB (0.079) | existing `voiceover` carve continues |

**HyperFrames — one continuous voice clip, one short cutaway-audio clip, both at the root.** The key structural fact is that the voice is **one clip that does not know the picture cut happened**. Picture is cut; sound is not.

```html
<!-- A-roll picture, cut at 42.30s; muted, audio lives on its own track (CLAUDE.md key rule 4) -->
<video id="aroll-a" src="assets/aroll.mp4" muted playsinline
       data-start="36.00" data-duration="6.30" data-media-start="112.4"
       data-track-index="0"></video>
<video id="broll-reenact" src="assets/reenactment.mp4" muted playsinline
       data-start="42.30" data-duration="6.00" data-media-start="3.2"
       data-track-index="0"></video>
<video id="aroll-b" src="assets/aroll.mp4" muted playsinline
       data-start="48.30" data-duration="9.00" data-media-start="118.7"
       data-track-index="0"></video>

<!-- ONE voice clip spanning all three picture clips -->
<audio id="vo-passage" src="assets/aroll.mp4"
       data-audio-group="voiceover"
       data-start="36.00" data-duration="21.30" data-media-start="112.4"
       data-track-index="10" data-volume="1"></audio>

<!-- the cutaway's own production sound, ducked, faded both ends -->
<audio id="cut-prodsound" src="assets/reenactment.mp4"
       data-audio-group="sfx-diegetic"
       data-start="42.30" data-duration="6.00" data-media-start="3.2"
       data-track-index="12" data-volume="0.158"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Clear the Voice Band&quot;,&quot;params&quot;:{&quot;frequency&quot;:120,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.267,&quot;v&quot;:1},{&quot;t&quot;:5.733,&quot;v&quot;:1},{&quot;t&quot;:6.0,&quot;v&quot;:0}]}]}"></audio>
```

Contract points:
- **`36.00 + 21.30 = 57.30`** — the voice clip's window covers `aroll-a`, `broll-reenact` and `aroll-b` end to end. That identity *is* the L cut. If the voice clip ends at 42.30 you have made a hard cut with a cutaway after it.
- **The picture clips share `data-media-start` arithmetic with the voice.** There is *"no automatic waveform sync or drift correction"* — picture and sound are aligned by writing the same numbers on both. `aroll-b` returns at source `118.7` because `112.4 + (48.30 − 36.00) = 124.7` minus the 6 s the reenactment covered… **check this by hand every time**: if you removed nothing from the voice, `aroll-b`'s `data-media-start` must equal `112.4 + (48.30 − 36.00) = 124.70`, not 118.7. Getting this wrong is the classic silent lip-sync break on the return.
- **Videos are `muted` with a separate `<audio>`** — the project's key rule, and the only way picture and sound can be cut independently.
- **The cutaway audio uses a `volume` lane, not `data-fx-carve`.** Carve is for *music under narration*; its settings *"live on the bed, never on a voice"*, `sources` must name a group, and putting a non-music clip in the carve group *"poisons the next re-analysis silently."*
- **Keep the held voice in the `voiceover` group** so the music carve continues to follow it across the cutaway. The cutaway's production sound must **not** join that group.
- **A lane holds its first value backwards**, hence the explicit `t:0, v:0`.
- **Narration treatment goes on the voice clip's own `data-fx-chain`** — but only if you are committing to narration position, and only after checking the preset. *"`voice-clean` plus a Reduce Mud job is −6 dB at 250 Hz where −3 was meant"* — the same double-application trap applies to Add Clarity at 3 kHz.
- **Reverb has a tail**: adding a `reverb` node makes the rendered track longer than its `data-duration` via `chainTailSeconds`. Expected, not a bug — but it means a narration-treated voice clip will ring slightly past its window.

**ffmpeg — room tone, when the cutaway's own audio is unusable.**
```bash
# lift a clean 4 s of floor from the cutaway itself and loop it seamlessly
ffmpeg -i reenactment.mp4 -vn -ss 0.4 -t 4 -c:a pcm_s16le tone.wav
ffmpeg -i tone.wav -i tone.wav -filter_complex "acrossfade=d=1.2:c1=qsin:c2=qsin" tone.x2.wav
# measure the floor either side of the cut for the acceptance test
ffmpeg -i mix.wav -af "silencedetect=n=-45dB:d=0.3" -f null -
# extract the cutaway's production sound as its own asset
ffmpeg -i reenactment.mp4 -vn -ac 2 -ar 48000 reenact.prod.wav
```

**Epidemic Sound.** Usually nothing needs fetching — the cutaway supplies its own sound. Fetch only when replacing an unusable production track:
```
# room tone to fill under a silent cutaway
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["ambience--room-tone"] },
                               duration: { min: 30000 } },
                     sort: { by: DURATION, order: DESCENDING }, first: 10 }
# a reenactment shot outdoors/on a street
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["ambience--traffic"] },
                               duration: { min: 60000 } }, first: 10 }
```
Both slugs verified live 2026-08-28. Download WAV.

**Remotion.** One `<Audio>` spanning several `<Sequence>` picture blocks, plus a second `<Audio>` with an interpolated volume ramp for the cutaway. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-l-cut-audio-trail]] · [[sfx-j-cut-audio-lead]] · [[sfx-split-edit-lead-lag]] · [[sfx-hard-cut-audio-seam]] · [[sfx-noise-floor-target]] · [[sfx-dialogue-gate]] · [[sfx-ambience-establishes-location]] · [[sfx-ambience-layer-stack]] · [[sfx-filter-character-and-distance]] · [[sfx-three-types-classification]] · [[sfx-alter-ego-objection-cutaway]] · [[sfx-ui-demo-payoff-sound]] · [[cut-l-voice-over-reenactment]] · [[cut-l-audio-trails-picture]] · [[cut-b-roll-coverage-from-transcript]] · [[cut-on-action]]

## Failure modes
- **Hard-muting the cutaway.** Produces a 6–15 dB hole in the noise floor at the in and out points. The viewer cannot name it but hears the edit. Always leave something under it, even at −30 dB.
- **Cutting the voice at the picture cut.** Turns an L cut into two shots and destroys the bridge the technique exists to build. The voice clip must span the picture cuts as one clip.
- **Changing the voice's acoustic at the picture cut.** A sudden move to narration position mid-sentence is audible as a jump. Change treatment at sentence boundaries or not at all.
- **Miscalculating the return's `data-media-start`.** The single most common silent bug here: the face comes back out of sync because the voice never skipped the cutaway's duration but the picture did. Recompute `media-start` as `original_start + (timeline_start − clip_timeline_start)` every time.
- **Cutting on a stressed syllable.** The picture cut becomes audible by association even though nothing changed in the audio. Move it two or three frames onto a consonant.
- **Staying on the cutaway too long.** Past ~15 s the voice stops belonging to a person. Return, or add a second visual event to re-motivate the stay.
- **Raising the music bed to fill the cutaway.** It fights the voice at exactly the moment the voice is carrying everything. The cutaway's own sound is the filler.
- **A cutaway that contains speech.** Two voices at once is unfixable by level. Either use a silent portion of that shot or subtitle the cutaway and duck the narration instead — which is a different technique.
- **Known gap — no auto-sync.** *"HyperFrames does not provide automatic waveform sync or drift correction."* Every alignment here is authored arithmetic, and nothing in `check` will catch a wrong `data-media-start`. Verify by rendering the return and watching the lips.
