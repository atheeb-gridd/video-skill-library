---
id: struct-progressive-layer-demo
title: Replay one clip, adding one layer per pass — the progressive stem demo
skill: editing
type: structure
family: demonstration
tags: [skill/editing, type/structure, family/demonstration, engine/hyperframes, engine/ffmpeg, engine/epidemic, layer/dialogue, layer/ambience, layer/music, layer/sfx, layer/design, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:32"
    quote: "To make you feel the importance of each sound layer, I'll play each layer along with the video. So here it is with just voiceover."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:20"
    quote: "Layer 1 — Dialogue / voiceover. Layer 2 — Ambient sounds. Layer 3 — Foley. Layer 4 — Sound effects. Layer 5 — Music."
research_refs:
  - https://www.masteringthemix.com/blogs/learn/114050949-this-transformed-my-mixes
  - https://educationaltechnology.net/mayers-principles-of-multimedia-learning/
  - https://sites.google.com/site/cognitivetheorymmlearning/segmenting-principle
  - https://blog.prosoundeffects.com/sound-layering
  - https://sfxengine.com/blog/common-sound-design-mistakes-in-video-editing
difficulty: medium
detectable_from: transcript+video
---

# Replay one clip, adding one layer per pass — the progressive stem demo

## What it is
A structural teaching device: hold **one fixed visual clip** and replay it N times, enabling one additional audio layer per replay, ending with all N stacked. Pass 1 is dialogue alone, pass 2 dialogue + ambience, pass 3 adds foley, pass 4 adds effects, pass 5 adds music. The device proves each layer's contribution *experientially* rather than by assertion — the viewer hears the gap and then hears it filled — and it hands the section a built-in rhythm with a guaranteed payoff on the final pass. It generalises beyond sound: the same shape works for a colour grade built in stages, a motion graphic assembled element by element, or a mix demonstrated with and without one treatment. The two things that make or break it are both measurable: the **picture must be byte-identical across passes** so the only variable is the layer, and the **shared layers must be level-locked** so the viewer hears richness rather than loudness.

## When to use it
Use it when you are teaching a *composite* — something whose value is invisible in the finished form because all its parts are present at once. Sound design is the canonical case; grading, lighting, and multi-element motion graphics are the others. It belongs early, as a cold-open proof that the topic matters, because it converts an abstract claim ("sound is half the video") into a felt one in under a minute. Use it also as a mid-video reset when the section that follows is dense — the repetition gives the viewer a break while still teaching. Do **not** use it where the layers are not separable (a single take with no stems), where N > 6 (the repetition becomes tedious before the payoff), or where the clip is over ~12 s (N replays of a 20-second clip is three minutes of the same picture).

## How to recognise it in a reference video
- **The unmistakable visual signature: the identical picture repeating.** Detect it mechanically — the passes will produce near-zero frame difference against each other. Extract a fingerprint frame from each suspected pass and compare, or simply look for a cut pattern where scene detection fires at a regular interval with the same shot returning:
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=10,metadata=print:file=-" -f null - 2>/dev/null | grep -E "pts_time|score"
  ```
  Then extract one frame per suspected pass at the same relative offset and diff them; a progressive demo gives essentially identical frames.
- **Equal pass durations.** Every pass is the same length within a frame or two, because it is the same clip. Unequal passes mean it is a montage, not this device.
- **Transcript, between passes.** Look for a labelling line before each pass, in a fixed frame: "here it is with just voiceover", "now with ambience", "and now everything together". A fixed construction repeated N times is the marker.
- **Count the passes and identify the layer added at each.** The creator's own taxonomy is five: dialogue → ambience → foley → effects → music. A reference using 3 or 4 has collapsed some.
- **Cumulative, not isolated.** Check whether each pass *adds* to the previous or *replaces* it. Cumulative (1, 1+2, 1+2+3) is this device. Isolated (just 1, just 2, just 3) is a different and much weaker device — the viewer never hears the thing being built.
- **Level discipline.** Measure the loudness of each pass:
  ```bash
  ffmpeg -i ref.wav -af "loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json" -f null -
  ```
  Integrated loudness *should* rise pass to pass — that is honest, the mix genuinely has more in it. What should **not** change is the level of the layers common to both passes. If the dialogue is louder in pass 5 than in pass 1, the demo is rigged and the viewer is hearing volume, not design. Even **1 dB** is enough to bias an A/B judgement toward "better".
- **Gap between passes.** Look for a short beat of silence or a marker sound between passes — typically **6–20 f** — that stops the passes running together into one continuous replay.
- **The final pass is longer or held.** Many references let the all-layers pass run a beat longer or repeat, because that is the payoff and the viewer wants to sit in it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `clip_length` | 8 s (240 f) | 5–12 s | Longer than 12 s and N replays become tedious. |
| `pass_count` | 5 | 3–6 | Matches the five-layer taxonomy. Above 6 the payoff arrives too late. |
| `inter_pass_gap` | 12 f (0.40 s) | 6–20 f | Silence or a marker between passes so they do not blur. |
| `label_length` | 3–6 words | — | "Now with ambience." Fixed construction, repeated verbatim in shape. |
| `label_position` | in the gap | in-gap \| over first 15 f | Never over the demo content itself. |
| `layer_order` | dialogue, ambience, foley, sfx, music | — | Fixed; it is the taxonomy the video is teaching. |
| `cumulative` | true | true | Isolated stems are a different, weaker device. |
| `shared_layer_tolerance` | ±0.5 dB | ±0 to ±1 dB | Common layers must not change level between passes. 1 dB biases the judgement. |
| `final_pass_hold` | +30 f | 0–60 f | Extra time on the all-layers pass. |
| `total_section` | 55 s | 35–90 s | `pass_count × (clip_length + gap)` plus labels. Budget it before building. |
| `picture_identity` | byte-identical | — | Same source, same `data-media-start`, same treatment on every pass. |

## Reproduction prompt

```
Build a progressive layer demo at 30fps from one clip {{CLIP}} and {{N}} audio layers.

1. BUDGET FIRST. Section length = {{N}} x (clip_length + 12 f gap) + labels. With the defaults
   (5 passes, 240 f clip, 12 f gap) that is 1260 f = 42.0 s before labels. If the result exceeds
   90 s, shorten the clip - never drop the final all-layers pass.

2. PREPARE ONE PICTURE and reuse it. Every pass plays the SAME source, from the SAME media offset,
   for the SAME duration, with the SAME visual treatment. Do not re-grade, re-frame or re-time any
   pass. If the picture differs at all between passes, the demo proves nothing.

3. PREPARE THE LAYER STEMS as separate files, one per layer, all the same length as the clip and
   all starting at the clip's first frame:
     L1 dialogue/voiceover, L2 ambience, L3 foley, L4 sound effects, L5 music.

4. LEVEL-LOCK. Measure each stem's loudness ONCE and use that same gain in every pass it appears
   in. The dialogue stem's level in pass 5 must be identical to its level in pass 1, within
   0.5 dB. Do not "balance" a pass by nudging an already-established layer - a 1 dB change is
   enough to make a listener call the louder version better, which would make the demo a lie.
   The TOTAL loudness is expected to rise pass to pass; that is the honest part.

5. LAY OUT THE PASSES cumulatively. Pass k plays layers 1..k. Pass k starts at
   (k-1) x (clip_length + gap). Nothing is muted or soloed - each pass is its own set of clips.

6. LABEL each pass in the 12 f gap BEFORE it, in a fixed construction: "Just voiceover." /
   "Now with ambience." / "Adding foley." / "Now the sound effects." / "And with music."
   Keep the labels off the demo content itself, and keep them the same length and position every
   time - the repetition is the structure.

7. HOLD THE FINAL PASS 30 f longer than the others, or repeat it once. That is the payoff.

8. ACCEPTANCE TEST: (a) extract the frame at offset 60 f within each pass and confirm they are
   identical; (b) measure integrated loudness per pass - it must rise monotonically; (c) solo the
   dialogue stem in pass 1 and in pass {{N}} and confirm the levels match within 0.5 dB; (d) play
   the section with your eyes closed - you must be able to name the layer that was added at each
   step without being told; (e) if you cannot hear what pass 3 added, the foley stem is too quiet
   or the wrong sounds, not the demo's fault - fix the stem.
```

## Execution spec

**HyperFrames (primary).** There is **no mute/solo automation and no track-enable primitive** in this stack, so a progressive demo is not built by toggling tracks — it is built by **placing a different set of clips per pass**. This is the natural shape here and is cheaper than it sounds, because the picture clips all point at the same file.

```html
<!-- pass 1: dialogue only. clip = 8.0s (240f), gap = 0.4s (12f), pitch of 8.4s per pass -->
<video id="demo-p1" class="clip" src="assets/demo.mp4" muted playsinline
       data-start="0.00" data-duration="8.00" data-media-start="4.00" data-track-index="0"></video>
<audio id="p1-vo" src="assets/stems/dialogue.wav" data-audio-group="voiceover"
       data-start="0.00" data-duration="8.00" data-track-index="10" data-volume="1.0"></audio>

<!-- pass 2: dialogue + ambience -->
<video id="demo-p2" class="clip" src="assets/demo.mp4" muted playsinline
       data-start="8.40" data-duration="8.00" data-media-start="4.00" data-track-index="0"></video>
<audio id="p2-vo"  src="assets/stems/dialogue.wav" data-audio-group="voiceover"
       data-start="8.40" data-duration="8.00" data-track-index="10" data-volume="1.0"></audio>
<audio id="p2-amb" src="assets/stems/ambience.wav" data-audio-group="ambience"
       data-start="8.40" data-duration="8.00" data-track-index="11" data-volume="0.10"></audio>

<!-- pass 5: all five layers, held 1.0s longer -->
<video id="demo-p5" class="clip" src="assets/demo.mp4" muted playsinline
       data-start="33.60" data-duration="9.00" data-media-start="4.00" data-track-index="0"></video>
<!-- p5-vo, p5-amb, p5-foley, p5-sfx, p5-music on track indices 10..14, same volumes as above -->
```

Contract details that decide whether this builds:
- **`data-volume` is the level lock.** Write the *same* number for a given stem in every pass it appears in. Linear gain: `1.0` = 0 dB, `0.25` = −12 dB, `0.10` = −20 dB, `0.056` = −25 dB. Do not use automation lanes for the stems — a lane holds its first value backwards and forwards and invites per-pass drift.
- **Every `<audio>` needs a unique `id`.** An id-less audio element is never mixed and renders **silent** — in a build with 15 audio clips this is the likeliest failure and it produces exactly the symptom "pass 3 sounds the same as pass 2".
- **Overlapping audio must not share a `data-track-index`** (`duplicate_audio_track`). Within a pass, give each layer its own index (10–14). Across passes indices may repeat, because passes do not overlap in time.
- `duplicate_media_discovery_risk` fires only on two media elements sharing **`src` AND `data-start`** — the passes share `src` but differ in `data-start`, so it does not fire. It is a benign finding regardless.
- **The half-open window** `[start, start + duration)` means `pass2.start = pass1.start + pass1.duration + gap` produces exactly the gap you asked for, with no shared frame.
- **Do not carve here.** The point of the demo is to hear each layer unaltered; a `data-fx-carve` on the music in pass 5 would make the final pass sound different from a real mix. If the finished video's mix does carve, say so verbally rather than carving the demo.
- **Relative timing is tempting and risky.** `data-start="demo-p1 + 0.4"` expresses the gap directly, but the operator **needs spaces** (`demo-p1+0.4` parses as an id and silently resolves to 0), an unresolved id resolves to 0 without erroring, and a target with no resolvable duration lands on its *start*. For a chain of five passes, one silent zero collapses the section. Author literal seconds.
- **Labels** are a small sub-composition or a text clip in the gap, entering with a gentle ease — caption fades belong to `power1.out`/`power2.out`, *not* the entrance default. Use `gsap.fromTo()`, never `from()` (which sets `immediateRender: true` and writes its from-state before the clip is active).
- This is a **multi-scene composition** with five near-identical scenes; `snapshot --at <midpoints>` is the documented defence against the silent relative-timing zeros and the silent root-sizing bug — but it is browser-backed and must run off this VM.

**ffmpeg — the alternative build, and the way to make the stems.** If the demo has to be a flat asset rather than a composition, render per-stem and concatenate:
```bash
# build each pass by mixing the cumulative stem set against the same picture
ffmpeg -i demo.mp4 -i dialogue.wav -i ambience.wav \
  -filter_complex "[1:a]volume=1.0[a1];[2:a]volume=0.10[a2];[a1][a2]amix=inputs=2:normalize=0[aout]" \
  -map 0:v -map "[aout]" -c:v libx264 -crf 18 -c:a aac pass2.mp4
# then concatenate the passes
printf "file '%s'\n" pass1.mp4 pass2.mp4 pass3.mp4 pass4.mp4 pass5.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy demo_section.mp4
```
`normalize=0` on `amix` is **load-bearing**: without it `amix` divides by the input count, so adding a layer would *reduce* the level of every existing one — the exact bias this note exists to prevent. Verify with two-pass `loudnorm` measurement per pass. Keep intermediates outside the vault mount, which cannot delete files.

**Epidemic Sound.** Sourcing the stems: `SearchSoundEffects` for the foley and effects layers (`filter.duration` bounded so nothing overruns the clip), `SearchRecordings` with `filter.vocals: false` for the music layer under narration ([[sfx-vocal-vs-instrumental-bed]]), and `SearchSoundEffects({ query: { term: "<location> room tone ambience" }, filter: { duration: { min: 10000 } } })` for the ambience layer. `EditRecording({ input: { targetDurationMs: 8000, forceDuration: true } })` gives a music stem exactly the clip's length so the final pass does not fade out mid-phrase.

**Remotion:** N `<Sequence>`s each containing the same `<OffthreadVideo>` plus a growing set of `<Audio>` children; concept only.

## Pairs with
[[struct-demo-before-label]] · [[struct-inverse-pair-teaching]] · [[struct-name-define-demonstrate]] · [[sfx-sound-pass-order]] · [[sfx-unsounded-motion-audit]] · [[sfx-vocal-vs-instrumental-bed]] · [[pace-silent-demonstration-window]] · [[struct-outcome-first-cold-open]] · [[struct-enumerated-promise-and-counter]]

## Failure modes
- **The picture changes between passes.** A different angle, a re-grade, even a different in-point, and the viewer attributes the difference to the picture. Correction: one source, one `data-media-start`, one duration, no treatment differences.
- **Nudging an established layer's level in a later pass.** A 1 dB lift on the dialogue in pass 5 makes the demo a demonstration of volume. Correction: lock each stem's gain once and reuse the number literally.
- **Using `amix` without `normalize=0`.** The added layer quietly attenuates everything already present, so pass 5 sounds *thinner* than pass 4. Correction: `normalize=0`, then verify per-pass loudness rises.
- **Isolated stems instead of cumulative.** Playing each layer alone is a catalogue, not a build; the viewer never experiences the stack forming. Correction: pass k plays layers 1..k.
- **Too many passes or too long a clip.** Seven passes of a 15-second clip is nearly two minutes of the same shot and viewers leave before the payoff. Correction: 5 passes max at 8 s, and budget the section before building.
- **No gap between passes.** They run together and the viewer loses count of which layer is which. Correction: 12 frames of silence and a fixed three-to-six-word label.
- **A silent pass from a missing audio id.** The section builds, one clip never enters the mix, and the demo appears to prove that layer does nothing. Correction: id every `<audio>` and count placed clips against the plan.
- **Known gap:** HyperFrames has no mute/solo, no track-enable attribute and no automation over track state — `data-hidden` drops an element from **both** preview and render entirely, which is a build-time switch, not a per-pass one. The device is therefore built by duplicating clips, and there is no primitive that expresses "the same timeline with fewer tracks". Any design document specifying this technique should say so, and budget the clip count.
