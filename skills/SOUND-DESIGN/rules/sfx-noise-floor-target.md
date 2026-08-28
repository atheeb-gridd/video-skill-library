---
id: sfx-noise-floor-target
title: Too perfect is broken — hold a measurable noise floor instead of digital silence
skill: sound-design
type: mix
family: noise-floor
tags: [skill/sound-design, type/mix, family/noise-floor, engine/ffmpeg, engine/hyperframes, engine/epidemic, sfx/diegetic, layer/ambience, layer/dialogue, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:02:16
    quote: "In life, if anything is too perfect, it feels off — it doesn't feel natural. Same with your video: if there's no noise in it at all, then it feels too perfect."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:02:40
    quote: "[older pass only] — So they should use a better mic, no? — The point isn't that the noise is there because the mic is bad."
research_refs:
  - https://en.wikipedia.org/wiki/Room_tone
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (ambience--room-tone probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Too perfect is broken — hold a measurable noise floor instead of digital silence

## What it is
The principle behind layer 2, stated as a diagnosis rather than as a recipe: *"if anything is too perfect, it feels off — it doesn't feel natural... if there's no noise in it at all, then it feels too perfect."* The source then rejects the obvious counter-argument outright — *"the point isn't that the noise is there because the mic is bad."* Noise is not tolerated. Noise is **placed**.

The mechanism is well documented in film sound. Presence, or room tone, is *"the 'silence' recorded at a location or space when no dialogue is spoken"*, and it exists because of what happens without it: *"The sound track 'going dead' would be perceived by the audience not as silence, but as a failure of the sound system."* That is the whole finding. A viewer does not experience a −∞ dBFS gap as quiet. They experience it as the audio having stopped working, and the reaction is a check of the volume slider or the device — attention leaves the video entirely.

This note is deliberately narrower than its neighbours. [[sfx-missing-ambience-audit]] is about a bed that was never laid; [[sfx-ambience-establishes-location]] is about placing it. **This one is about a floor that was destroyed** — by a noise gate set too hard, by denoising, by pause removal that cut into digital black, or by a mix where nothing at all is playing between phrases. That is a mixing fault, it is invisible on a waveform at normal zoom, and it is measurable in one command.

The target is a floor that is **present and unnameable**: loud enough to prove the system is running, quiet enough that nobody can say what it is.

## When to use it
- **After any pause-removal or silence-cut pass.** `transcript-cut.mjs --cut-silence`, `auto-editor`, or any jump-cut workflow leaves seams where the floor steps or vanishes. Run the check after, always ([[sfx-pause-removal-breath-and-room-tone]]).
- **After applying a gate.** A gate's job is to close gaps; its default `range` of −24 dB is survivable, and anything approaching −80 dB is a manufactured hole.
- **On any voiceover recorded in a treated room or booth.** These are the sources that actually arrive too clean.
- **On any AI or TTS voice track.** Synthesised speech has a literal zero floor between phrases, and it is the single most common reason a generated voiceover reads as generated.
- **Before shipping any video with a music rest window.** Killing the music to emphasise a line ([[sfx-music-rest-windows]]) is exactly when the floor becomes audible, because nothing is masking it any more.
- **On the incoming side of every L cut and hard cut** — a shot with no bed under it goes dead the moment the outgoing audio ends ([[sfx-l-cut-audio-trail]], [[sfx-hard-cut-audio-seam]]).
- **Not as an excuse for a bad source.** The contract is blunt: there is no noise removal in this stack and *"a source with audible hiss needs a better source, and saying so is the whole answer."* This note is about floors that are too *low*, not about floors that are too high.
- **Not by raising the noise you have.** You add a chosen bed; you do not turn up the recording's own hiss.

## How to recognise it in a reference video
- **Run silence detection at two thresholds and compare.** This is the whole test:
  ```bash
  ffmpeg -i ref.wav -af "silencedetect=n=-50dB:d=0.30" -f null -   # expect: nothing
  ffmpeg -i ref.wav -af "silencedetect=n=-60dB:d=0.30" -f null -   # expect: nothing
  ```
  A healthy mix reports **no silences at −50 dB** during natural pauses. Hits at −50 dB mean a floor that is too low; hits at −60 dB mean genuine digital black and a mix that will read as broken on a quiet device.
- **Measure the floor in the pauses, not overall.** Take three 0.4 s windows from inter-phrase gaps and print RMS:
  ```bash
  ffmpeg -ss <t> -t 0.4 -i ref.wav -af "astats=measure_overall=RMS_level" -f null -
  ```
  A placed floor lands **−55 to −45 dBFS** and is **consistent across all three windows within about 3 dB**. Wild variance between gaps is the tell that the floor is leftover recording noise rather than a bed — real beds do not change level between sentences.
- **Look for the step, not the level.** The clearest signature of a gate or a denoiser is a **discontinuity at the word boundary**: the floor is present under speech and gone 40 ms after it. Print RMS at 0.05 s resolution across a phrase end; a step of more than 10 dB within two frames is a gate.
- **Check what the floor *is*.** Band-limit a pause window: broadband hiss with no structure is a noise floor; something with 50/60 Hz harmonics is mains hum; something with events is ambience. Log which, because they take different fixes.
- **Listen at low volume on a phone speaker.** Digital black is almost inaudible on monitors and unmistakable on a phone, because the device's own noise floor disappears with the signal.
- **Log for the design document:** floor level in dBFS, floor consistency across pauses, and whether any `silencedetect -50dB` hits exist. Three numbers, and they fully specify the fault.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `floor_target` | −50 dBFS | −55 to −45 dBFS | Measured RMS in an inter-phrase gap. This is the number the note exists to deliver. |
| `floor_rel_dialogue` | −36 dB | −40 to −32 dB | The same target expressed against dialogue at 0/−3 dB. Sits below the ambience bed (−28 dB), which sits below the music (−22 dB). |
| `floor_consistency` | ±3 dB | ±1 to ±5 dB | Across every pause in the video. Variance is the fault, not the level. |
| `silencedetect_gate` | −50 dB, d=0.30 | −55 to −45 dB | The pass/fail check. Zero hits is a pass. |
| `digital_black_threshold` | −70 dBFS | — | Below this the viewer reads a system failure, not quiet. Never allowed anywhere in the programme. |
| `gate_range` | −14 dB | −18 to −10 dB | The single most important knob. `gate`'s default `range` is −24 dB; **never approach −80**, which is what manufactures a hole. |
| `gate_threshold` | −38 dB | −45 to −30 dB | Below the quietest useful breath, above the floor. |
| `bed_level` | −28 dB rel. dialogue | −32 to −24 dB | If the floor is missing, a room-tone bed is what supplies it. |
| `bed_hpf` | 60 Hz | 45–90 Hz | Room-tone files often carry inaudible sub energy that eats master headroom. |
| `programme_loudness` | −14 LUFS | −14 (social) / −16 (podcast) | Sets what "dialogue at 0 dB" means in absolute terms; the floor target is relative to it. |
| `bed_continuity` | whole programme | — | The floor never stops, including under music, including in rests, including across every cut. |

## Reproduction prompt

```
Audit and repair the noise floor of the mix at {{MIX}}.

1. MEASURE, DO NOT LISTEN FIRST.
   ffmpeg -i {{MIX}} -af "silencedetect=n=-50dB:d=0.30" -f null -
   Record every silence_start / silence_end pair. Zero pairs = pass, stop.
2. CLASSIFY EACH HIT.
   a) HIT IN A NATURAL PAUSE between phrases -> the floor was destroyed.
      Cause is almost always a gate, a denoise pass, or silence removal.
   b) HIT AT A CUT BOUNDARY -> the incoming clip has no bed under it.
   c) HIT IN A MUSIC REST WINDOW -> nothing is carrying the programme while
      the music is out.
   Fix (a) at the source: raise the gate's RANGE to -14 dB so it attenuates
   instead of killing. Do not fix (a) by adding a bed on top of a gate that
   is still slamming - you will hear the bed duck with every word.
3. MEASURE THE SURVIVING FLOOR. Take three 0.4 s windows from three
   different inter-phrase pauses:
   ffmpeg -ss <t> -t 0.4 -i {{MIX}} -af "astats=measure_overall=RMS_level" -f null -
   Target -50 dBFS, consistent within 3 dB across all three.
4. IF THE FLOOR IS BELOW -60 dBFS OR INCONSISTENT, LAY A BED. Fetch room
   tone matching the shooting space (not an ambience with events - a bed
   with a recognisable car or laugh becomes a loop the moment it repeats).
   Place ONE clip spanning the entire programme, uncut, at -28 dB relative
   to dialogue, high-passed at 60 Hz.
5. DO NOT CUT THE BED AT PICTURE CUTS. A bed belongs to the programme, not
   to the shot. Cutting it reintroduces exactly the step you are removing.
6. RE-MEASURE. The -50 dB silencedetect must now return nothing, and the
   three pause windows must agree within 3 dB.
7. FINAL LOUDNESS LAST, not first. Two-pass loudnorm to -14 LUFS for social
   or -16 LUFS for podcast, AFTER the floor is right - normalising first
   moves the floor and invalidates every measurement above.

ACCEPTANCE TEST: play the three quietest passages on a phone speaker at low
volume. You must hear that the video is still running at every instant. You
must NOT be able to say what you are hearing. If you can name it - hiss,
hum, traffic, a room - it is 4-6 dB too loud. If you reach for the volume
control, it is too quiet and the audit failed.
```

## Execution spec

**ffmpeg — the whole audit is three commands.**
```bash
# 1. the pass/fail gate. zero output = pass.
ffmpeg -i mix.wav -af "silencedetect=n=-50dB:d=0.30" -f null -

# 2. the floor level in a specific pause (repeat at three different pause times)
ffmpeg -ss 41.8 -t 0.4 -i mix.wav -af "astats=measure_overall=RMS_level" -f null -

# 3. the step test: 50 ms RMS trace across a phrase end, to catch a gate
ffmpeg -ss 41.2 -t 1.2 -i mix.wav -ar 48000 -af "asetnsamples=n=2400,\
 astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null

# harvesting a floor from the footage itself, when a quiet stretch exists
ffmpeg -i take.mp4 -ss 3.0 -to 8.0 -vn -c:a pcm_s16le room_tone_harvested.wav

# building a long bed from a short harvest, seam-free
ffmpeg -i room_tone_harvested.wav -i room_tone_harvested.wav \
  -filter_complex "acrossfade=d=1.5:c1=qsin:c2=qsin" rt.x2.wav
ffmpeg -i rt.x2.wav -af "aloop=loop=20:size=480000" -t 600 rt.600s.wav

# loudness LAST, two-pass, per the contract
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=<input_i>:\
measured_TP=<input_tp>:measured_LRA=<input_lra>:measured_thresh=<input_thresh>:\
offset=<target_offset>:linear=true mix.social.wav
```
`aloop`'s `size` is in **samples** (48000 × seconds), which is the detail that silently produces a 10-second bed when you wanted ten minutes. Keep every intermediate **outside the mounted vault**, which cannot delete files.

**HyperFrames.** One bed clip spanning the programme, and — more importantly — the **gate settings that stop you needing it**. From the FX registry, `gate` takes `threshold` −80–0 dB (default −35), `range` −80–0 dB (**default −24**), `ratio`, `attack`, `release`, `knee`. `range` is the amount of attenuation applied when the gate is closed, and it is the parameter that decides whether you get a quieter room or a hole:

```html
<hf-audio-group id="voiceover" data-label="Voiceover"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;g1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:100,&quot;poles&quot;:&quot;2&quot;}},
    {&quot;type&quot;:&quot;gate&quot;,&quot;id&quot;:&quot;g2&quot;,&quot;label&quot;:&quot;Tighten, do not kill&quot;,
      &quot;params&quot;:{&quot;threshold&quot;:-38,&quot;range&quot;:-14,&quot;attack&quot;:2,&quot;release&quot;:180}},
    {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;g3&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></hf-audio-group>

<!-- the floor: ONE clip, whole programme, never cut at a picture cut -->
<audio id="floor-bed" src="assets/sfx/ambience/office_room_tone_120s.wav"
       data-audio-group="ambience"
       data-start="0" data-duration="600" data-track-index="13" data-volume="0.040"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;f1&quot;,&quot;label&quot;:&quot;Kill sub&quot;,&quot;params&quot;:{&quot;frequency&quot;:60,&quot;poles&quot;:&quot;2&quot;}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;f2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>
```
Contract points, and one of them is a trap. **`gate` has zero automatable parameters** — it is an AudioWorklet *"configured wholesale"* — so a gate that is too hard cannot be softened over time; you change the number and re-render. `data-volume="0.040"` is **−28 dB**. The bed must **not** be in the `voiceover` group: keep the carve group voices only, or the carve's next analysis is poisoned silently. Do **not** carve the floor bed against the voice at all — a floor that ducks under every word is exactly the artefact you are trying to remove; it is quiet enough not to need it.

Two contract facts to plan around. **There is no noise removal in this stack.** `room-gate` is documented as *"Does not remove noise — room tone under speech stays"*, and the honest statement is that *"a source with audible hiss needs a better source."* So this note's fixes are all additive or gate-loosening; none of them clean a source. And **nothing validates the chain or the effect lanes at all** — a mistyped `gate` node loads and does nothing, so verify by measurement, never by reading the markup.

**Epidemic Sound.** When no usable floor can be harvested from the footage:
```
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["ambience--room-tone"]},
                              duration:{min:60000,max:300000} },
                     query:{term:"office room tone"},
                     sort:{by:DURATION, order:DESCENDING}, first:24 }
#   verified live: "Ambience, Room Tone, Office Kitchen Room Tone 01" (120000 ms)
#   the slug is the filter that matters - a term-only search returns hits and risers
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Choose by **eventlessness**, not by realism. A file with a distinctive car, cough or bird becomes a loop the moment it repeats, and a floor is the one layer that repeats for the entire programme. `(Multimono)` in a title marks a mono recording spread across channels — good for a floor, because a floor should not have a stereo image. A wrong slug returns `meta.total: 0`; zero means fix the slug, not widen the search.

**Remotion.** One `<Audio>` spanning the whole composition at low gain. Concept only.

## Pairs with
[[sfx-missing-ambience-audit]] · [[sfx-ambience-establishes-location]] · [[sfx-ambience-search-formula]] · [[sfx-pause-removal-breath-and-room-tone]] · [[sfx-hard-cut-audio-seam]] · [[sfx-l-cut-audio-trail]] · [[sfx-j-cut-audio-lead]] · [[sfx-music-rest-windows]] · [[sfx-music-hard-stop]] · [[sfx-dialogue-gate]] · [[sfx-layer-volume-targets]] · [[sfx-demo-clip-loudness-handover]] · [[sfx-ambience-bridge-across-cut]] · [[cut-jump-cut-take-repair]]

## Failure modes
- **A gate with `range` near −80 dB.** Manufactures digital black between every phrase and is the commonest cause of this fault in an otherwise good mix. Fix: `range` −14 dB. A gate should make the room quieter, never absent.
- **Adding a bed on top of a slamming gate.** The gate is on the voice bus, the bed is on its own — but if the bed is *inside* the voice group it gets gated too, and now the floor pumps with every word. Fix: the bed lives in `ambience`, never in `voiceover`.
- **Cutting the bed at picture cuts.** Reintroduces the exact step you are removing, once per cut. Fix: one clip, whole programme.
- **Normalising before measuring.** `loudnorm` moves the floor, so every number taken before it is wrong. Fix: floor first, loudness last.
- **Judging on monitors.** Digital black is nearly inaudible on good speakers and obvious on a phone. Fix: the acceptance test is a phone at low volume.
- **A bed with events.** A recognisable car or laugh at a fixed interval is the clearest possible loop tell, and a floor loops for the whole video. Fix: choose eventless room tone; if only an eventful file exists, get one longer than the programme.
- **Raising the recording's own hiss instead of adding a bed.** Makes the source's problems louder. Fix: leave the source alone and add a chosen bed under it.
- **Treating a too-*high* floor with this note.** Audible hiss is a different fault with no fix in this stack. Fix: re-record; say so plainly rather than implying a repair exists.
- **Known gap:** there is no automated check for this in the pipeline. *"Almost no static gate covers the mix"* — the linter reads `data-automation` for exactly two conflicts and validates nothing about chains or beds. The `silencedetect` command in this note **is** the gate, and it has to be run by hand as an explicit step in the design document.
