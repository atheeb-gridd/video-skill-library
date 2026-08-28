---
id: cut-j-curiosity-lead
title: Choose the J-cut lead sound for intrigue, not just for smoothness
skill: editing
type: retention
family: audio-led
tags: [skill/editing, type/retention, family/audio-led, engine/hyperframes, engine/ffmpeg, engine/epidemic, layer/sfx, layer/ambience, sfx/diegetic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:03"
    quote: "Here is a popular J cut from the Wolf of Wall Street where we begin to hear Matthew McConaughey beating on his chest, leading us into the lunch scene before we visually see it."
research_refs:
  - https://nofilmschool.com/pre-lap-screenwriting-and-editing
  - https://filmlifestyle.com/what-are-pre-lap-sounds-with-examples-tutorials/
  - https://www.studiobinder.com/blog/what-is-pre-lap-in-screenplay/
  - https://bop.unibe.ch/JEMR/article/download/2264/3460
  - https://link.springer.com/article/10.1007/s11747-025-01137-x
difficulty: medium
detectable_from: transcript+video
---

# Choose the J-cut lead sound for intrigue, not just for smoothness

## What it is
A selection rule layered on top of the J cut. [[cut-j-audio-leads-picture]] owns the mechanics — how many frames the audio leads, how the media start is pulled back, how the fade is shaped. This note owns the *choice of sound*, and it argues the opposite default: where the mechanics note treats ambience as the safe, invisible lead, the curiosity lead deliberately picks a sound the viewer **cannot identify from hearing alone**, so the picture cut arrives as the answer to a question the ear has just asked. The canonical example is the chest-beating rhythm from *The Wolf of Wall Street*: not room tone, not dialogue, but a strange percussive human noise that makes no sense until you see it. In screenwriting this device is a **pre-lap**; in editing it is the cheapest anticipation hook available, because it costs zero screen time and works entirely inside frames you were going to have anyway.

## When to use it
Use it at boundaries where you need the viewer to *want* the next thing, not merely to accept it. In practice: into a demonstration or reveal (the sound of the thing before the shot of the thing); into a section whose subject is visual and strange; at the transition out of a slow explanatory passage into an energetic one; and immediately before a mid-roll structural beat where drop-off is likely. It is a **rationed** device — one every 60–120 s at most — because a curiosity lead that pays off into something ordinary teaches the viewer to ignore the next one. Use the invisible ambience lead ([[cut-j-audio-leads-picture]]) for every other split edit. Do **not** use it into a boundary where the picture answers nothing (a cut back to the same talking head), do not use it where the sound is so ambiguous the viewer misreads the location, and never use music as the lead — a music change at a boundary is a section device, not a hook.

## How to recognise it in a reference video
- **Two timecodes as always** — picture cut and incoming-audio onset — but the diagnostic here is *what* arrives early, not how early.
- **The unidentifiability test.** Play the lead window with the picture hidden and try to name the sound. If a first-time listener can name it in under a second (traffic, a café, a keyboard, a voice saying words), it is a continuity lead. If they cannot — a rhythm, a mechanical noise, a non-verbal human sound, an unplaceable texture — it is a curiosity lead.
- **The payoff test.** The first frame after the cut must *explain* the sound. Extract the frame at the cut and ask: does this image answer the question the sound posed? If the explanation arrives 2 s later, the lead is misplaced.
- **RMS onset, frame-aligned:**
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  `n=1600` at 48 kHz is one frame at 30 fps, so the printed `pts_time` values are frame-aligned. The lead shows as a **≥ 8 dB** RMS step that does not coincide with a picture cut — a bigger step than the ~6 dB an ambience lead produces, because a curiosity lead is meant to be noticed.
- **Longer leads than the invisible kind.** Ambience leads sit at 6–30 f. Curiosity leads run **20–60 f (0.7–2.0 s)** — long enough for the ear to fail to identify it and start looking for the answer. Past **75 f (2.5 s)** it becomes an audio-led montage with its own rhythm.
- **Rhythmic or repeating.** Most working curiosity leads repeat inside the lead window — a beat, a knock, a chant, a mechanical cycle. A single unidentifiable transient is startling rather than intriguing; two or three repetitions read as a question.
- **Transcript signal.** The narration usually goes **quiet or ends a sentence** across the lead window. A curiosity lead under continuing narration competes with it and loses.
- **Density.** Count them per minute. One per **60–120 s** is the working rate; a reference at more than 1/min has turned the device into a tic.
- **Distinguish from a riser.** A riser is designed non-diegetic tension that resolves at a drop ([[sfx-riser-anticipation-build]]). A curiosity lead is a **diegetic** sound from the next scene. If the sound does not exist in the incoming shot, it is a riser, not a J cut.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `lead` | 36 f (1.20 s) | 20–60 f (0.7–2.0 s) | Longer than an ambience lead on purpose. |
| `max_lead` | 75 f (2.5 s) | — | Past this it is an audio-led montage. |
| `repetitions_in_window` | 3 | 2–5 | Repeats of the sound's cycle inside the lead. One repetition reads as a startle. |
| `rms_step` | +8 dB | +6 to +14 dB | Step in the frame-aligned RMS trace at the lead onset. |
| `fade_in` | 6 f (0.20 s) | 0–10 f | Slightly softer than an ambience lead so the sound *emerges*. 0 f only on a deliberate hard transient. |
| `narration_gap` | ≥ 18 f (0.6 s) | 12–45 f | Silence in the voice track across the lead window. Non-negotiable. |
| `bed_dip` | −6 dB | −3 to −9 dB | Music dips across the lead so the lead is the thing you hear. Back to unity at the cut. |
| `payoff_within` | 0 f | 0–6 f | Frames after the picture cut before the image explains the sound. Effectively immediate. |
| `interval` | 90 s (2700 f) | 60–120 s | Minimum spacing between curiosity leads. |
| `lead_content` | diegetic, non-verbal | rhythmic action \| non-verbal human \| mechanical \| unplaceable texture | **Never** music. Dialogue only if the *words* are the intrigue. |

## Reproduction prompt

```
Build a curiosity J-cut lead into the boundary at {{CUT}} (composition seconds, 30fps) between
outgoing clip {{A}} and incoming clip {{B}}.

1. QUALIFY THE BOUNDARY. All three must hold or do not build this:
   - B's first frame visually EXPLAINS a sound that exists in B;
   - the narration has a gap of at least 18 f (0.6 s) ending at or before {{CUT}};
   - no other curiosity lead within 2700 f (90 s) in either direction.

2. CHOOSE THE LEAD SOUND from B, in this priority order:
   a) a rhythmic action sound in B that repeats (knocking, beating, a machine cycle, footsteps
      on a specific surface);
   b) a non-verbal human sound (a chant, a laugh, breathing, a crowd);
   c) a distinctive mechanical or object sound;
   d) an unplaceable texture.
   REJECT: music of any kind; generic room tone; dialogue, unless the words themselves are the
   intrigue. Apply the test: play it to someone with no picture. If they name it in under a
   second, pick a different sound - that one is a continuity lead, not a curiosity lead.

3. SET {{LEAD}} = 36 frames (1.20 s) by default, then adjust so that the sound's own cycle
   repeats 3 times inside the lead window. Range 20-60 f. Never exceed 75 f.

4. AUTHOR IT. B's AUDIO starts at {{CUT}} - {{LEAD}}/30 seconds. B's PICTURE starts at {{CUT}}.
   B's audio data-media-start must be pulled back by exactly {{LEAD}}/30 relative to B's picture
   data-media-start, so what plays under A is genuinely the sound that PRECEDES B's first frame.
   Fade the lead in over 6 f from silence.

5. CLEAR THE FIELD across the lead window: the voice track is silent, and the music bed dips
   6 dB from {{CUT}} - {{LEAD}}/30 to {{CUT}}, returning to unity by {{CUT}}. If a whoosh or
   riser was scheduled at this boundary, DELETE IT - it competes with the lead for the same job.

6. Leave A's picture untouched; do not shorten it to make room.

7. ACCEPTANCE TEST: (a) play from 3 s before the boundary with your eyes closed - you should be
   unable to name the sound, and should want to look; (b) play it watching - the first frame
   after the cut must answer the question, with no delay; (c) frame-step: B's audio onset is
   exactly {{LEAD}} frames before B's first picture frame, and B's picture and B's own sound are
   within 1 frame of sync from {{CUT}} onward; (d) if the payoff frame does not explain the
   sound, either change the incoming shot or downgrade this to a plain ambience J cut.
```

## Execution spec

**HyperFrames (primary).** Identical mechanism to [[cut-j-audio-leads-picture]] — muted `<video>` plus a separate `<audio>`, two `data-start` values, a pulled-back `data-media-start` — so consult that note for the full markup. What this note adds is the **third element**: the bed dip that clears the field.

```html
<!-- picture cut at 96.00s; curiosity lead of 36 f = 1.20s -->
<video id="shot-b" src="assets/b.mp4" class="clip" muted playsinline
       data-start="96.00" data-duration="7.00" data-media-start="12.00" data-track-index="0"></video>
<audio id="shot-b-aud" src="assets/b.wav" data-audio-group="ambience"
       data-start="94.80" data-duration="8.20" data-media-start="10.80" data-track-index="11"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.2,&quot;v&quot;:1}]}]}"></audio>
```

The bed dip is a `volume` lane on the **music bed**, and its `t` is **clip-local seconds** — measured from the bed's own `data-start`, not from the composition. For a bed starting at 0, the dip across 94.80–96.00 is:
```
{"target":"volume","points":[{"t":0,"v":1},{"t":94.6,"v":1},{"t":94.8,"v":0.5},{"t":96.0,"v":1}]}
```
Contract details that bite here:
- A lane **holds its first value backwards** to the clip's start and its last value forward to its end, so the explicit `{"t":0,"v":1}` point is what stops the bed from starting out already dipped.
- Do **not** also GSAP-tween `volume` on the bed — the lane wins and the tween is silently ignored (`audio_volume_double_automation`). And an authored `data-volume` on a tweened track is replaced outright, not scaled (`audio_volume_tween_overrides_gain`).
- −6 dB is `v ≈ 0.5` on the 0..1 volume lane (−6 dB = ×0.501). −3 dB ≈ 0.71, −9 dB ≈ 0.355.
- The lead clip goes in an **`ambience`** or `sfx` group. Never `voiceover` — a non-voice clip in the carve group poisons the next carve re-analysis silently.
- Every `<audio>` needs an **`id`**; an id-less audio element is never mixed and renders silent with no warning.
- Overlapping audio sharing one `data-track-index` raises `duplicate_audio_track`. Give the lead its own index.
- If the bed already carries a `data-fx-carve` against the `voiceover` group, the dip lane and the carve coexist — the carve writes `fromCarve`-tagged nodes and its own gain envelope, and a hand-drawn `volume` lane is left alone by a carve re-run. Do not hand-write `fromCarve`.

**ffmpeg.** Only to *find* the lead sound in the incoming source. The frame-aligned RMS trace above locates candidate transients; then extract and audition a candidate window:
```bash
ffmpeg -i b.mp4 -ss 10.80 -t 1.20 -vn -ar 48000 -ac 1 lead_candidate.wav
```
For a baked version leaving the pipeline, `atrim` + `afade=t=in:st=0:d=0.2` + `adelay` — see [[cut-j-audio-leads-picture]] for the filter graph.

**Epidemic Sound.** When the incoming scene has no usable sound of its own, source the lead rather than defaulting to ambience. Search on the *action*, not the location:
`SearchSoundEffects({ query: { term: "rhythmic knocking wood repeating" }, filter: { duration: { min: 1200, max: 6000 } }, first: 12 })`; other productive terms: `"chest beating chant crowd"`, `"machine cycle mechanical rhythmic loop"`, `"footsteps gravel approaching"`. Use `SearchSimilarToSoundEffect` to find a variant rather than reusing a file already in the video — a repeated identical SFX is one of the three named sound-design mistakes. Do **not** reach for `SearchRecordings` here; music is disqualified as a lead by the rule itself.

**Remotion:** an `<Audio>` sequence starting `LEAD` frames before the picture `<Sequence>`, with a matching `startFrom` offset; concept only.

## Pairs with
[[cut-j-audio-leads-picture]] · [[sfx-riser-anticipation-build]] · [[struct-comment-prompt-curiosity-gap]] · [[struct-demo-before-label]] · [[cut-audio-match]] · [[pace-silent-demonstration-window]] · [[sfx-placement-discipline]] · [[pace-visual-change-clock]]

## Failure modes
- **The payoff frame does not explain the sound.** The viewer is left with a question and moves on. Correction: the incoming shot must *show the source*; if it does not, change the shot or downgrade to an ambience lead.
- **Leading with music.** A music change at a boundary reads as "a new section started", which is a completely different signal and cancels the hook. Correction: diegetic sound only.
- **Lead under continuing narration.** The voice wins, the lead is heard as noise, and the mix sounds cluttered. Correction: an 18-frame minimum silence in the voice track, and dip the bed.
- **Stacking a riser on it.** Two anticipation devices at one boundary is one too many, and the riser's synthetic build makes the diegetic lead sound like a mistake. Correction: pick one; the riser belongs at a scripted reveal, the curiosity lead at a scene change.
- **Overuse.** Every boundary teased is no boundary teased. Correction: 60–120 s minimum spacing; everywhere else, use the invisible lead.
- **Too short.** A 6-frame unidentifiable noise is a glitch, not a question. Correction: 20 f minimum, and let the sound's cycle repeat 2–3 times.
- **Sliding the audio without sliding the media start.** The sound plays early but is the wrong sound, and B is out of sync afterwards. Correction: pull `data-media-start` back by exactly the lead.
- **Known gap:** the "can a listener name it in under a second" test is the load-bearing check and there is no automated substitute for it in this stack. Log the human verification in the design document. Nothing here measures whether a sound is *intriguing*; `RMS_level` only tells you a sound arrived.
