---
id: sfx-silence-as-pattern-interrupt
title: The hard music drop — cut the bed abruptly so the silence itself is the interrupt
skill: sound-design
type: music
family: music-stops
tags: [skill/sound-design, type/music, family/music-stops, layer/music, layer/dialogue, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:13:15"
    quote: "What do you think happens when you cut the music abruptly? That sudden change jolts the viewer and grabs their attention. On top of that, the absence of music pulls attention to other parts of the video. So try pausing the music for special moments to make that moment stand out."
research_refs:
  - https://en.wikipedia.org/wiki/Orienting_response
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://ffmpeg.org/ffmpeg-filters.html#fade
  - https://en.wikipedia.org/wiki/Audio_to_video_synchronization
difficulty: medium
detectable_from: audio
---

# The hard music drop — cut the bed abruptly so the silence itself is the interrupt

## What it is
The bed stops without a fade, on one chosen frame, and stays gone for a measured window. Two separate things then happen, and the source names both. First, the **stop is a change**, and a sudden environmental change is the textbook trigger for an **orienting response** — the involuntary "what was that" reflex that reorients attention. An offset works for this exactly as an onset does; the reflex is to *change*, not to loudness. Second, the resulting **silence removes a competing stimulus**, so whatever is left — the line being spoken, the number on screen, the reveal — becomes the only thing in the mix and inherits the whole of the listener's attention.

This is the pattern-interrupt use of the move, and it is deliberately distinguished from its two neighbours. [[sfx-music-hard-stop]] owns the *emphasis* case — the serious line, the stop landed on an accent so it is not heard as an error. [[sfx-music-rest-windows]] owns the *map* — where a video's cues and rests sit overall. This note owns the case where you **want** the stop to be noticed, and it owns the numbers for the silent window: how long, what stays underneath, and what happens to the dialogue level while the bed is gone.

## When to use it
Use it for a designated "special moment" — a payoff, a reveal, a punchline, a hard turn in the argument, or the single most important sentence in the video. Use it when retention data or a read-through says the viewer is drifting at a known timestamp and the content there is worth saving. Use it at a chapter boundary where the next section has a different mood and you want the seam felt rather than smoothed.

Do **not** use it as general punctuation. The orienting response **habituates**: repeat the same stimulus and it decays to nothing, and a video that drops its bed every ninety seconds has trained the viewer to ignore the drop. Do not use it under a line that is itself quiet or hesitant — the silence will expose it. Do not use it if there is no ambience or room tone to carry the gap; total digital silence reads as a broken file, not as design.

## How to recognise it in a reference video
- **On the music track:** short-term loudness of the bed falls by **more than 20 LU inside 2 frames** and stays down. A fade reads as a slope over 10+ frames; a drop is a cliff.
- **The floor does not go to zero.** Look at the noise floor during the gap. A designed drop leaves ambience/room tone at roughly **−45 to −50 dBFS**; a mistake or a missing clip leaves **true digital silence** (−∞, a flat line).
- **Where the cliff lands.** Either exactly on a musical accent/downbeat of the outgoing bed, or **2–6 frames before the stressed syllable** of the line being protected. Both are deliberate; a cliff in the middle of a sustained chord with a click on it is not.
- **Dialogue level steps up.** Compare the VO's short-term loudness in the 3 s before and the 3 s after the drop. A well-executed drop raises the voice **+1 to +1.5 dB** to compensate for the missing bed; a lazy one leaves it flat and the whole mix audibly deflates.
- **Duration of the gap:** typically **0.8–2.5 s**. A gap over ~4 s with nothing else happening reads as a fault.
- **The return.** The bed comes back on a downbeat or a section change, either hard-in or fading in over 12–24 frames — never sneaking back mid-phrase.
- **On the picture track:** the drop almost always coincides with a visual event — a cut, a title card, a punch-in, a full-screen graphic. A drop with nothing on screen is rare and usually accidental.
- **On the transcript:** the sentence sitting in the gap is short, declarative, and is the thesis of the section.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Stop ramp | 0.3 f (10 ms) | 5–30 ms | Not a fade — a de-click ramp. Below 5 ms you risk a click; above 30 ms (~1 frame) it starts reading as a fade. |
| Stop frame, emphasis mode | 4 f before the stressed syllable | 2–6 f | Silence must arrive *before* the word, so the word lands in it. |
| Stop frame, accent mode | on the bed's next downbeat | ±1 f | Frames per beat at 30 fps = `1800 / BPM`. |
| Silence window | 45 f (1.5 s) | 24–75 f (0.8–2.5 s) | Beyond 75 f, only if speech or a strong ambience continues. |
| Absolute-silence ceiling | 15 f (0.5 s) | 0–20 f | Maximum time with *nothing at all* audible before it reads as a fault. |
| Ambience floor during the gap | −48 dBFS | −45 to −52 dBFS | Room tone or location ambience, never removed. |
| Dialogue compensation | +1.2 dB | +0.8 to +1.5 dB | Ramp in over 6 f before the drop, out over 6 f after the return. |
| Bed level before the drop | −22 dB rel. dialogue | −20 to −25 dB | The source's own mix numbers; the drop is relative to this. |
| Return ramp | 0 f (hard, on a downbeat) | 0–24 f | Hard-in on a downbeat is cleanest; a 12–24 f `power2.out` fade is the safe alternative. |
| Budget | 1 per 2 min | 1 per 90 s – 1 per 5 min | Habituation: the third identical drop in a video is worth roughly nothing. |
| Programme loudness after the move | −14 LUFS integrated | −16 to −13 | YouTube/Tidal normalise to −14 LUFS; true peak ≤ −1 dBTP. |

## Reproduction prompt

```
Execute a hard music drop as a pattern interrupt at moment {{HIT}} (seconds,
30fps; frames convert as seconds = frames / 30).

1. GATE. Confirm all four or stop: (a) {{HIT}} is a designated payoff,
   reveal or thesis line - not routine punctuation; (b) this is the first or
   second such drop in the video, and at least 120s from the previous one;
   (c) a continuous ambience or room-tone track exists under the whole
   window, or you will create one; (d) the line landing in the gap is
   delivered with confidence.
2. CHOOSE THE STOP FRAME. Emphasis mode: find the stressed syllable of the
   protected line in the word-level transcript and set STOP = that word's
   start - 0.13 (4 frames). Accent mode: set STOP to the bed's next downbeat
   at or before {{HIT}}, computed as T0 + n * (60 / BPM) where T0 is the
   bed's first downbeat. Never place STOP mid-syllable.
3. STOP THE BED. Do not truncate the clip on a hard boundary. Author the
   bed's volume automation with two points 10ms apart: v=1 at
   (STOP - bed.data-start) and v=0 at (STOP - bed.data-start + 0.01). Set
   the clip's data-duration to end at least 0.5s later so any reverb tail
   in the chain is not chopped.
4. HOLD. Keep the ambience running at -48 dBFS across the whole gap. Do not
   mute it, do not let true digital silence exceed 0.5s.
5. COMPENSATE. Raise the dialogue/VO by +1.2 dB across the gap: automation
   points at STOP-0.2 (v = base), STOP (v = base * 1.15), RETURN (v = base *
   1.15), RETURN+0.2 (v = base). Never GSAP-tween volume on a track that
   already has a volume lane - the lane wins and the tween is ignored.
6. RETURN. Set RETURN = STOP + 1.5s, then move it to the nearest downbeat of
   the incoming bed. Bring the bed back hard on that frame, or fade it in
   over 0.4s with power2.out. If the section has changed, return with a
   different track and land the change on the beat.
7. ACCEPTANCE TEST: (a) no click at STOP - inspect the rendered waveform,
   the last non-zero sample must be on the ramp, not a step; (b) the gap
   contains audible ambience throughout - it must not be a flat line;
   (c) short-term loudness of the voice inside the gap is 1.0-1.5 LU above
   its value 3s earlier; (d) integrated programme loudness is still -14
   LUFS +/-1 with true peak <= -1 dBTP; (e) play the 10s window at full
   speed with your eyes on the picture - the drop must feel like the video
   leaned in, not like the audio broke.
```

## Execution spec

**HyperFrames — the drop is an automation lane, not an edit.** The contract is explicit that `data-automation` lane `t` is **clip-local seconds** on a clip and **composition seconds** on an `<hf-audio-group>` bus, and that **a lane holds its first value backwards to the clip start and its last value forward to the clip end**. Both facts drive the shape below. Bed starting at composition time `30.00`, drop at `92.00`, return at `93.50`:

```html
<audio id="bed-ch2" src=".media/audio/bgm/bed.mp3"
       data-audio-group="music"
       data-start="30.00" data-duration="90.00" data-track-index="11" data-volume="0.6"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},
         {&quot;t&quot;:62.00,&quot;v&quot;:1},
         {&quot;t&quot;:62.01,&quot;v&quot;:0},
         {&quot;t&quot;:63.50,&quot;v&quot;:0},
         {&quot;t&quot;:63.50,&quot;v&quot;:1}]}]}"></audio>

<!-- ambience never stops; it is what makes the gap read as a room, not a fault -->
<audio id="amb-room" src="assets/sfx/room_tone.wav"
       data-audio-group="ambience"
       data-start="0" data-duration="180" data-track-index="13" data-volume="0.04"></audio>
```
`62.00` and `63.50` are `92.00 − 30.00` and `93.50 − 30.00` — clip-local, because the lane is on the clip. The `{t:0, v:1}` point is **mandatory**: without it the lane's first authored value is held backwards and the bed starts already at whatever that value is.

Contract facts that bind this note:
- **JSON attributes must be double-quoted with `&quot;`.** `carve.mjs` finds them with a `name="..."` regex; a single-quoted attribute is invisible to it and the next carve silently overwrites work it could not see.
- **Do not add a GSAP `volume` tween to a track that has a `volume` lane** — `audio_volume_double_automation`, the lane wins. And an authored `data-volume` on a tweened track is replaced outright, not scaled (`audio_volume_tween_overrides_gain`).
- **Every `<audio>` needs an `id`** or it is never mixed — a silent render with no error.
- The carve stays on the bed across the drop. It is harmless while the bed is at zero and it is what keeps the bed out of the voice's way either side.
- Keep the ambience clip **out of** the `voiceover` carve group; a non-voice member poisons the next re-analysis silently.
- If the bed's chain contains `reverb` or `delay`, the rendered track runs longer than `data-duration` (`chainTailSeconds`) — expected, not a bug. Give the clip 0.5 s of room past the drop so the tail is not chopped; a chopped tail is the click you were avoiding.

**Dialogue compensation on a bus.** If the VO is many clips, put the +1.2 dB on the `<hf-audio-group>` instead — a bus lane's `t` is **composition time**, which is what you want for a single global gesture:
```html
<hf-audio-group id="voiceover" data-label="Voiceover" data-volume="0.9"
  data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
    {&quot;t&quot;:0,&quot;v&quot;:0.9},{&quot;t&quot;:91.8,&quot;v&quot;:0.9},{&quot;t&quot;:92.0,&quot;v&quot;:1.0},
    {&quot;t&quot;:93.5,&quot;v&quot;:1.0},{&quot;t&quot;:93.7,&quot;v&quot;:0.9}]}]}"></hf-audio-group>
```

**ffmpeg — only if the bed is leaving the pipeline.** In-composition this is a lane; bake only for export.
```bash
# hard stop with a 10 ms de-click ramp at 92.000s, silence to 93.500s
ffmpeg -i bed.wav -af "afade=t=out:st=91.99:d=0.01:curve=tri,volume=enable='between(t,92,93.5)':volume=0" bed.dropped.wav
# verify programme loudness afterwards (two-pass loudnorm, measure then apply)
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
```
`afade`'s `curve=tri` is linear amplitude — correct for a 10 ms de-click. For an audible *fade* out of a bed use `curve=log` or `qsin` instead; a linear amplitude fade over a second sounds like it hangs.

**Epidemic Sound.** Nothing new is fetched for the drop itself, but the *return* often wants a different cue:
```
SearchRecordings { query.term: "<mood of the next section>", filter.bpm { min: <BPM-6>, max: <BPM+6> }, filter.vocals: "instrumental" }
SearchSimilarToRecording { id: "<outgoing track id>" }
```
`SearchSimilarToRecording` is the smooth-handover route; if the returning track is a genuinely different vibe, this drop becomes the seam and [[sfx-beat-aligned-handover]] takes over.

**Remotion:** an `<Audio>` with a `volume={(f) => …}` callback expressing the same envelope in frames. Not part of this project.

## Pairs with
- [[sfx-music-hard-stop]] — the emphasis variant; land the stop on an accent so it is not heard · [[sfx-music-fade-out-section-signal]]
- [[sfx-music-rest-windows]] — where the rests go across the whole video
- [[sfx-ambience-bridge-across-cut]] — the ambience bed that makes the gap survivable
- [[struct-presenter-aside-pattern-interrupt]] — the picture-side equivalent of this move
- [[sfx-riser-anticipation-build]] — the opposite approach to the same "special moment"
- [[cut-smash-cut]] — when the drop coincides with a hard picture contrast
- [[sfx-beat-aligned-handover]] — if the bed returns as a different track
- [[sfx-playback-verification-loop]] — the listening protocol that signs this off
- [[struct-stimulation-budget]] — the census that stops you spending drops too often

## Failure modes
- **Truncating the clip instead of ramping.** Ending a bed on a non-zero sample produces a click, and a click reads as a technical fault — the exact opposite of the intended effect. Two automation points 10 ms apart, always.
- **True digital silence.** Cutting the bed *and* having no ambience leaves a dead hole; viewers reach for their volume control. Ambience at −48 dBFS is not optional.
- **Leaving the voice level alone.** Removing a −22 dB bed drops the mix's perceived level, so the emphasised line arrives *smaller* than the words before it. Compensate by +1.2 dB.
- **Dropping into a weak line.** The silence is a magnifying glass. If the take is hesitant, the drop broadcasts that. Fix the take first.
- **Doing it repeatedly.** Habituation kills it. Three drops in a ten-minute video means the third one does nothing; budget one per two minutes at most.
- **Landing mid-word.** A stop inside a syllable sounds like a dropout. Use the word-level transcript, not the waveform's look.
- **Fading instead of cutting.** A 1 s fade-out is a different move with a different meaning (winding down, not interrupting). If the intent is a jolt, the ramp must be sub-frame.
- **Known gap:** nothing in the stack validates automation lanes — the contract states plainly that *nothing validates the chain or the effect lanes at all*, and lint checks `data-automation` for exactly two conflicts. A typo'd lane is silently inert. The only verification is rendering and listening, and in this project the render is browser-dependent and must run off the authoring VM.
