---
id: cut-jump-cut-run-elided-conversation
title: The jump-cut run — a series of jumps that says the conversation ran longer than the screen time
skill: editing
type: cut
family: jump-cut
tags: [skill/editing, type/cut, family/jump-cut, layer/ambience, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:02"
    quote: "The effect these jump cuts are having is showing the passing of time, and that the characters have actually been speaking longer than the screen time being shown."
research_refs:
  - https://en.wikipedia.org/wiki/Continuity_editing
  - https://en.wikipedia.org/wiki/Jump_cut
  - https://en.wikipedia.org/wiki/Audio_to_video_synchronization
  - https://en.wikipedia.org/wiki/EBU_R_128
difficulty: medium
detectable_from: transcript+video
---

# The jump-cut run — a series of jumps that says the conversation ran longer than the screen time

## What it is
Three or more jump cuts inside a single unchanged setup, played as one gesture. Individually each join is the move described in [[cut-jump-time-compression]] — a chunk removed from one shot, the ends spliced. Collectively they say something a single jump cannot: **you are watching excerpts of a longer exchange.** The technique is a **temporal ellipsis** made visible. Standard continuity editing hides its ellipses; this one advertises them, and the advertisement is the information. The audience is not asked to believe the scene took ninety seconds — they are told it took twenty minutes and that they are being shown ninety seconds of it.

The mechanism is the deliberate violation of the **30-degree rule**, which exists precisely to make cuts of this kind invisible: joining two shots less than 30° apart produces a jump the eye cannot read as a new angle, so it reads as time instead. Keeping the camera locked is therefore not laziness here — it is the whole apparatus. The run is distinguished from [[cut-jump-cut-take-repair]], where jumps are an artefact you are trying to *hide*; here they are the point, and hiding them destroys the effect.

## When to use it
Use it when a conversation, interview, argument, negotiation or lesson has to be represented as long but shown as short. Typical triggers: a dialogue scene whose content is three beats but whose plausibility requires twenty minutes; an interview reduced to its four best answers; a "we talked about this for hours" beat; a character wearing down another character; a montage of one person failing at the same task repeatedly. It is also the honest way to present a heavily condensed talking-head answer where pretending to continuity would be a lie.

Do not use it when the compression is trivial (one filler word removed — that is a take repair). Do not use it when the scene's dramatic point depends on unbroken real time. Do not use it when the camera moves between fragments — that is coverage, and it reads as a different scene, not a later moment of the same one.

## How to recognise it in a reference video
- **Three or more successive cuts with identical framing.** Lens, height, angle and background are unchanged across every join; only the subject's posture, hand position, or the objects around them differ.
- **Visible discontinuity at each join.** The head is in a different position, the hands have moved, a glass is emptier, a page has turned. If the subject snaps back to the *same* pose, it is a take repair, not an ellipsis.
- **Fragment lengths of roughly 1.5–4 s**, and typically **3–6 fragments** in the run. Fewer than 3 does not read as a series; more than 8 starts reading as a nervous vlog edit.
- **The background is static and the light does not change.** A changing background means a different setup; changing light means real time passed on camera and the run is being used to cover a shooting problem.
- **On the audio track — the tell.** Room tone / ambience runs **continuously and unbroken** underneath every fragment, while the dialogue cuts hard with the picture. Look for a constant noise floor across the joins with no step at the cut points. If the ambience steps at every cut, the run was assembled carelessly.
- **Dialogue is non-continuous in meaning.** Fragment 2 answers something fragment 1 did not ask. On the transcript, successive fragments show topic jumps with no connective tissue.
- **The run terminates on a longer fragment.** The last piece typically runs 2× or more the average and then the scene cuts out conventionally.
- **No transitions.** No dissolves, no fades between fragments — a dissolve inside the run converts it into an entirely different statement ("much more time passed") and is a different technique.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Fragments in the run | 4 | 3–6 | Under 3 reads as a mistake; over 8 reads as filler-removal. |
| Fragment length | 60–90 f (2.0–3.0 s) | 45–120 f | Long enough to deliver one complete idea. Below 45 f the fragment carries no content — see [[pace-visual-mush-ceiling]]. |
| Length variation across fragments | ±30% | ±20–50% | Equal fragments read mechanical. |
| Acceleration | 0% | 0 to −15% per fragment | Shortening each successive fragment reads as the conversation winding down. |
| Elided real time per jump | 8 s | 3–120 s | Unbounded in principle; the viewer only reads "a while". |
| Camera angle change | 0° | 0° | Must stay under the 30° threshold. Any real angle change breaks the effect. |
| Ambience bed | continuous, one clip | — | One unbroken room-tone/ambience clip spanning the entire run at −45 to −50 dBFS. |
| Dialogue dip at each join | −3 dB for 3 f | 0 to −4 dB, 2–5 f | Hides the level step between takes. Optional but usually needed. |
| Audio pre-lap at each join | 0 f | 0–8 f | An L-cut of 4–8 f softens a join without hiding it; use on at most half the joins. |
| Terminal fragment | 2× mean | 1.8–3× mean | The landing. Without it the run has no ending. |
| Music under the run | continuous or absent | — | If a bed plays, it must run unbroken across every join, like the ambience. |

## Reproduction prompt

```
Build a jump-cut run that compresses a long conversation into a short
sequence. Source is a single locked-off take. 30fps; HyperFrames authors
seconds, so every frame figure converts as seconds = frames / 30.

1. TRANSCRIBE the take to word level and get {text, start, end} per word.
   `npx hyperframes transcribe take.mp4` or
   `node <SKILL_DIR>/scripts/transcribe.mjs --input take.mp4 --out take.json`.
2. SELECT 4 fragments (range 3-6) that each deliver one complete idea and
   that do NOT connect logically to each other - the gaps between them are
   the technique. Each fragment must start on a word start and end on a word
   end, with 4 frames of handle either side so no consonant is clipped.
3. SIZE them: target 60-90 frames each, varied by at least +/-30% around
   their mean, with the LAST fragment at 2x the mean of the others. If a
   fragment falls under 45 frames, either extend it to a full sentence or
   drop it.
4. VERIFY THE JUMP IS VISIBLE. Compare the first frame of fragment N+1 with
   the last frame of fragment N: the subject's head or hands must be in a
   materially different position. If they match, shift the in-point until
   they do not - an invisible jump reads as a compression glitch.
5. ASSEMBLE picture as N clips of the same source file with N different
   media offsets, butted with no transition and no handles. Do not add
   dissolves anywhere inside the run.
6. AUDIO, and this is what makes it read as one scene: cut the DIALOGUE with
   the picture, but lay ONE continuous ambience/room-tone clip across the
   whole run at -48 dBFS. It must not be cut at the joins. If a music bed
   plays, it likewise runs unbroken.
7. HIDE THE LEVEL STEPS: at each join, dip the dialogue -3 dB for 3 frames
   centred on the cut. Optionally pre-lap the incoming dialogue by 4-8
   frames on no more than half the joins.
8. EXIT on a conventional cut after the terminal fragment. Never fade out of
   a jump-cut run.
9. ACCEPTANCE TEST: (a) play at full speed - the run must read as one place
   and one conversation, with time passing; (b) mute the picture - the audio
   must sound like one continuous room; (c) no click or noise-floor step is
   audible at any join; (d) each fragment is comprehensible on its own; (e)
   the framing is identical in every fragment - overlay first frames and
   confirm the background does not shift.
```

## Execution spec

**HyperFrames — N clips, one source, N media offsets.** The contract's in-composition trimming rule applies directly: *"a clip plays a sub-window via `data-media-start` + `data-duration` … Only cut a physical file when exporting/assembling outside the composition."* Nothing needs cutting on disk.

```html
<!-- picture: four windows into ONE take, butted back to back.
     The visibility window is half-open [start, start+duration), so
     b.data-start = a.data-start + a.data-duration shares no frame. -->
<video id="jc-1" src="footage/interview_a.mp4" muted playsinline class="clip"
       data-start="12.000" data-duration="2.400" data-media-start="41.20"  data-track-index="0"></video>
<video id="jc-2" src="footage/interview_a.mp4" muted playsinline class="clip"
       data-start="14.400" data-duration="3.100" data-media-start="118.90" data-track-index="0"></video>
<video id="jc-3" src="footage/interview_a.mp4" muted playsinline class="clip"
       data-start="17.500" data-duration="2.000" data-media-start="263.05" data-track-index="0"></video>
<video id="jc-4" src="footage/interview_a.mp4" muted playsinline class="clip"
       data-start="19.500" data-duration="5.200" data-media-start="401.60" data-track-index="0"></video>

<!-- dialogue: cut with the picture, same numbers on both elements.
     The stack's convention is muted <video> + a separate <audio>. -->
<audio id="jc-1-a" src="footage/interview_a.mp4"
       data-audio-group="voiceover" data-start="12.000" data-duration="2.400"
       data-media-start="41.20" data-track-index="10"></audio>
<!-- …jc-2-a, jc-3-a, jc-4-a identical in shape… -->

<!-- ambience: ONE clip spanning the whole run. This is the technique. -->
<audio id="jc-room" src="assets/sfx/room_tone_office.wav"
       data-audio-group="ambience"
       data-start="12.000" data-duration="12.700" data-track-index="13" data-volume="0.04"></audio>
```

Contract facts that bind this:
- **There is no automatic waveform sync.** Picture and sound are aligned by writing the same `data-start`, `data-duration`, `data-media-start` (and `data-playback-rate`, if used) on both elements. Write them from one computed table, never by hand twice.
- **`video_nested_in_timed_element` is an error** — time the `<video>` *or* a wrapper, never both. These clips are timed directly.
- **Every `<audio>` needs an `id`.** No id → never mixed → silent render.
- `data-track-index` is display-only and constrains nothing; layering is CSS `z-index`. Overlapping `<audio>` sharing a track index warns `duplicate_audio_track`, so keep dialogue on 10 and ambience on 13.
- **`duplicate_media_discovery_risk`** fires benignly when two media elements share `src` + `data-start`; here they share `src` but not `data-start`, so it does not.
- The dialogue dip at each join is a **`volume` automation lane on each dialogue clip**, `t` clip-local: `[{t:0,v:1},{t:0.05,v:0.7},{t:0.15,v:1}]` at the head, mirrored at the tail. Do not also GSAP-tween `volume` (`audio_volume_double_automation`).

**ffmpeg — only when the run must leave the composition** (a flattened deliverable, or a cut-down handed to another tool). The transcript-cut compiler does exactly this job from word timings:
```bash
node <SKILL_DIR>/scripts/transcript-cut.mjs \
  --input footage/interview_a.mp4 --transcript take.json \
  --keep "41.20-43.60,118.90-122.00,263.05-265.05,401.60-406.80" \
  --out interview_run.mp4 --plan
```
Run `--plan` first and read the kept-segment JSON. **Do not pass `--copy`**: stream copy snaps to keyframes and on sparse-keyframe footage *"can silently swallow the whole cut"*; the script reports `copy_drift` when produced vs expected duration differs by more than 1 s. Frame-accurate cuts need the re-encode path (`libx264 -preset veryfast -crf 18` + `aac` + `+faststart`, which is what the script writes by default). Keep scratch output **outside** the mounted vault — the mount cannot delete files, so temp cleanup fails there.

A flattened run has one further problem the composition does not: cutting the video also cuts the ambience. Rebuild it afterwards:
```bash
ffmpeg -i interview_run.mp4 -stream_loop -1 -i assets/sfx/room_tone_office.wav \
  -filter_complex "[1:a]volume=-48dB,atrim=0:12.7[amb];[0:a][amb]amix=inputs=2:duration=first[a]" \
  -map 0:v -map "[a]" -c:v copy interview_run_roomed.mp4
```

**Epidemic Sound.** The ambience is usually the only asset you need to fetch:
```
SearchSoundEffects { query.term: "room tone office quiet interior", filter.duration { min: 30000 } }
SearchSoundEffects { query.term: "cafe ambience light chatter background" }
```
Download to `assets/sfx/`, optionally ledger with `node <SKILL_DIR>/scripts/resolve.mjs --from <file> --type sfx --project .`. Keep it **out of** the `voiceover` carve group — a non-voice member in that group silently poisons the next carve re-analysis.

**Remotion:** N `<Sequence>`s over one `<OffthreadVideo>` with different `startFrom`, plus one `<Audio>` spanning all of them. Not part of this project.

## Pairs with
- [[cut-jump-time-compression]] — the single jump this note repeats into a gesture
- [[cut-jump-cut-take-repair]] — the opposite intent: hide the jump instead of showing it
- [[sfx-ambience-bridge-across-cut]] — the continuous room tone that holds the run together
- [[cut-dissolve-time-passage]] — the alternative statement, "much more time passed"
- [[pace-partial-pause-removal]] — the finer-grained compression inside each fragment
- [[cut-b-roll-coverage-from-transcript]] — the other way to hide the same ellipsis, with cutaways
- [[cut-l-audio-trails-picture]] — the pre-lap used on some joins
- [[pace-visual-mush-ceiling]] — the floor that stops fragments getting too short
- [[struct-intercut-beat-ledger]] — planning which beats survive the compression

## Failure modes
- **Cutting the ambience with the picture.** The single most common failure: every join pops, and the run reads as four separate clips rather than one scene. One unbroken ambience clip, always.
- **The subject snapping back to the same pose.** If the jump is not visible, the viewer reads a glitch, not an ellipsis. Shift the in-point until the posture genuinely differs.
- **Equal fragment lengths.** Four 2.5 s fragments read as a machine chopped the take. Vary by ±30%.
- **No landing.** A run that ends on another short fragment leaves the scene unresolved. The terminal fragment carries the weight.
- **Adding dissolves between fragments.** That converts an ellipsis-inside-a-scene into a montage across scenes — a different and much weaker statement.
- **Moving the camera between fragments.** A 40° change makes each fragment a separate shot; you now have coverage of a scene you did not shoot, and it looks it.
- **Using it to hide a bad take.** The run advertises its own cuts, so it also advertises that you removed something. If the reason is a fluff, use [[cut-jump-cut-take-repair]] or a cutaway instead.
- **Letting the level step through.** Different takes sit at different levels; without the −3 dB dip at each join, the voice audibly steps. Level-match first, then dip.
- **Known gap:** this stack has **no automatic waveform sync or drift correction** and no beat/level matching between takes. The alignment is authored by writing identical numbers on the picture and audio clips, and the level match is your own measurement — verify by rendering and listening, per [[sfx-playback-verification-loop]].
