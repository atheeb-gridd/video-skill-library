---
id: sfx-pause-removal-breath-and-room-tone
title: Partial pause removal — keep the breath, keep the room
skill: sound-design
type: mix
family: dialogue-edit
tags: [skill/sound-design, type/mix, family/dialogue-edit, engine/ffmpeg, engine/hyperframes, engine/epidemic, sfx/diegetic, layer/dialogue, layer/ambience, source/editing-kt, source/research, difficulty/high]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:01:56
    quote: "For example, if you cut out every pause so you're talking non-stop, that's by far the biggest thing you can do for entertainment. But it comes at the cost of authenticity."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:02:45
    quote: "These cuts removed pauses and bad takes."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:09:41
    quote: "Even in movies they use the sounds of that real location, so that you feel like you're actually there."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://auto-editor.com/ref/edit
  - https://auto-editor.com/ref/options
  - https://en.wikipedia.org/wiki/Speech_tempo
difficulty: high
detectable_from: audio
---

# Partial pause removal — keep the breath, keep the room

## What it is
Cutting every pause so the speech runs non-stop is named as the single highest-impact entertainment move available in an edit, and in the same breath as the biggest authenticity cost. This note is the **audio half** of that decision: pause removal is not a video operation with an audio side-effect, it is a dialogue-layer edit whose artefacts are all audible. Two things get destroyed by an all-or-nothing strip — the **breath**, which is what makes a speaker sound like a person, and the **room tone continuity**, which is what makes the recording sound like a place. A partial strip keeps both: it removes only gaps longer than a threshold, leaves a pad of real audio around every remaining word, and lays a continuous room-tone bed underneath so the splices have nothing to expose.

The style position is the deliverable. "Remove every pause" and "remove nothing" are both defensible; what is not defensible is not having decided.

## When to use it
- **Any single-camera talking-head or voiceover cut** where the raw take has dead air. This is the default first pass on A-roll.
- **When the profile calls for high entertainment density** — fast, non-stop delivery, MrBeast-adjacent pacing. Push `cut_silence` down toward 0.30 s and accept the authenticity cost knowingly.
- **When the profile calls for a hangout/companion feel** — the "feels like hanging out with someone" register. Push `cut_silence` up to 0.8–1.0 s so thinking pauses survive, and never strip breaths.
- **Not on emotional or serious lines.** A pause before a heavy sentence is doing work; stripping it flattens the beat. Exempt those ranges by hand.
- **Not on demonstration windows** where the silence is the content (a UI interaction playing out, a sound being demonstrated).
- Always paired with the layer-2 decision: if you are going to strip aggressively, you are committing to laying room tone.

## How to recognise it in a reference video
- **Count the splices per minute of speech.** Detect silences at a speech-appropriate floor and compare against the cut list:
  `ffmpeg -i ref.mp4 -af "silencedetect=noise=-32dB:d=0.25" -f null - 2>&1 | grep silence_`
  Report `silence_start` / `silence_end` / `silence_duration`. In a heavily stripped edit the longest surviving gap is typically **under 0.35 s** and the gap-length histogram has a hard wall — no gaps at all above the threshold. An unstripped take shows a long tail out past 1.5 s.
- **Look for the wall, not the average.** The tell-tale of automated stripping is the *absence* of any gap above a single value. A hand-edited cut has a ragged distribution with occasional long deliberate pauses.
- **Listen for the breath.** In a stripped edit, either (a) breaths are present and the speech has a human rhythm — a partial strip, or (b) every inhale is gone and consecutive sentences butt directly together — a full strip, which reads as relentless and slightly inhuman. Log which.
- **Check the room-tone floor across splices.** In a speech gap, look at the noise floor either side of a splice. A **step** in floor level or timbre at the splice means no ambience bed was laid — the classic amateur signature. A continuous floor across every splice means either a room-tone bed (layer 2) or a crossfade at every join.
- **Look for the audio "click" or "pop"** at splices — 1–2 frame transients at cut points, visible as isolated spikes in a high-passed waveform. Their presence means the strip was done without fades.
- **Video track corroboration:** a stripped talking-head almost always carries jump cuts, punch-ins, or B-roll landing exactly on the splices. Cross-check the splice list against the cut list — if they coincide, the cutting was audio-driven.
- **Transcript signal:** word-level timestamps make this trivial. Compute inter-word gaps from `transcript.json`; the same wall shows up in the numbers.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `noise_floor` | −32 dBFS | −40 to −26 dBFS | The silence threshold. ffmpeg `silencedetect` *defaults to −60 dB*, which is far too low for a room-tone-bearing take and finds almost nothing; auto-editor's audio method defaults to 0.04 of full scale ≈ **−28 dBFS**. −32 dB is the middle and works on a quiet room. Measure the actual floor first. |
| `cut_silence` | 0.60 s | 0.30–1.00 s | Minimum gap that gets removed. Below 0.30 s you start eating breaths and stop-consonant closures. Above 1.0 s you are barely editing. |
| `pad` | 0.20 s (6f) | 0.10–0.30 s (3–9f) | Real audio kept either side of every retained word. This is auto-editor's `--margin`, whose default is **0.2s**. Pad is what keeps consonant onsets and word tails intact. |
| `breath_keep` | true | true/false | Whether an inhale between phrases survives. An inhale runs roughly 250–500 ms; a `cut_silence` at or below 0.30 s deletes them wholesale. |
| `splice_fade` | 8 ms | 5–15 ms | Micro-fade at each join to kill splice clicks. A ~10 ms fade is the standard de-plosive/de-click length. |
| `room_tone_bed` | required when `cut_silence` < 0.7 s | — | Continuous layer-2 bed under the whole dialogue so the floor never steps at a splice. |
| `bed_level` | −30 dB (0.0316) | −35 to −25 dB | Just enough to mask the floor discontinuity, never enough to identify. |
| `exempt_ranges` | [] | — | Hand-listed second-ranges where no pause is removed: emotional beats, demonstrations, deliberate silences. |
| `target_articulation` | 168–210 wpm | 150–230 wpm | Broadcast speech rates. If a strip pushes the effective rate past ~230 wpm the edit reads as rushed rather than tight. |

## Reproduction prompt

```
Perform a PARTIAL pause removal on the dialogue of {{SOURCE}} between {{IN}}
and {{OUT}}. Do not strip every pause.

1. MEASURE THE FLOOR FIRST. Run
   ffmpeg -i {{SOURCE}} -af "silencedetect=noise=-32dB:d=0.25" -f null -
   Read back silence_duration values and build a histogram. If it reports
   almost nothing, the floor is higher than -32 dB: raise the threshold in
   2 dB steps until gaps appear. Record the value you settled on.
2. LIST EXEMPT RANGES before cutting: every pause that precedes a serious
   or emotional line, every demonstration window, every deliberate beat.
   Write them as second-ranges. These are never touched.
3. CUT with the transcript, not the waveform:
   node <SKILL_DIR>/scripts/transcript-cut.mjs --input {{SOURCE}}
     --transcript {{TRANSCRIPT}} --cut-silence 0.6 --plan
   Inspect the kept-segment JSON. Confirm no exempt range was clipped and
   that no removal is shorter than 0.30s. Then re-run without --plan and
   without --copy (stream copy snaps to keyframes and will swallow cuts).
4. KEEP THE BREATH. Any gap between 0.25s and 0.60s stays. If the result
   sounds like a machine talking, raise --cut-silence by 0.1 and re-run.
5. LAY THE ROOM. Place one continuous ambience/room-tone bed spanning
   {{IN}}..{{OUT}} at -30 dB (data-volume 0.0316), group "ambience". This is
   not optional below 0.7s: it is what makes the splices inaudible.
6. FADE THE JOINS. 8 ms fade at every splice.

ACCEPTANCE TEST: listen with eyes closed to 60 continuous seconds. You must
(a) hear the speaker breathe at least twice, (b) never hear the noise floor
step, click or pump, (c) never be able to point at a splice. If you can point
at a splice, the bed is too quiet or the fade is too short. Then check the
effective speech rate is under 230 wpm.
```

## Execution spec

**The stack's real tool is `transcript-cut.mjs`,** and it is the reason partial pause removal is scriptable here rather than an all-or-nothing strip. Verified flags:

```bash
node <SKILL_DIR>/scripts/transcribe.mjs --input talk.mp4 --out talk.transcribe.json
node <SKILL_DIR>/scripts/transcript-cut.mjs \
  --input talk.mp4 --transcript talk.transcribe.json \
  --cut-silence 0.6 \
  --remove "142.10-149.55" \
  --remove-fillers "um,uh" \
  --plan
```
`--cut-silence 0.6` *"removes inter-word gaps longer than N seconds"* — exactly the partial-strip semantics. `--plan` prints the kept-segment list before encoding; inspect it. `--remove` takes explicit second-ranges for bad takes. Two traps from the contract: **`--copy` cuts only on keyframes** and on sparse-keyframe footage *"can silently swallow the whole cut"* (the script warns on >1 s drift and reports `copy_drift` in `--json`) — drop it for frame-accurate work; and the script's temp-dir cleanup calls `rmSync`, which **cannot run inside the mounted vault**, so keep scratch work outside the mount.

Transcription default is Parakeet via `parakeet-mlx`, which is an **Apple-silicon MLX path and unavailable on this linux ARM64 VM**; the whisper.cpp fallback is what will actually run, subject to the egress allowlist. Plan for the transcript to be produced elsewhere if it is not already in `transcript.json`.

**Detection with plain ffmpeg**, when there is no transcript:
```bash
# find the gaps
ffmpeg -i talk.wav -af "silencedetect=noise=-32dB:d=0.25" -f null - 2>&1 | grep silence_
# strip with padding preserved (stop_periods=-1 = all gaps; 0.2s of silence kept each side)
ffmpeg -i talk.wav -af "silenceremove=stop_periods=-1:stop_duration=0.6:stop_threshold=-32dB" out.wav
```
`silencedetect`'s documented defaults are `noise=-60dB` and `duration=2.0` — both wrong for this job; always pass both explicitly.

**HyperFrames — do the cut in the composition, not on the file, when you can.** Trim/sub-window is `data-media-start` + `data-duration` in seconds; a physical cut is only for material leaving the pipeline. But partial pause removal produces *dozens* of segments, so one clip per kept segment is unwieldy — the honest answer is: cut the file with `transcript-cut.mjs`, then bring the result back in as a single `src`. Picture and sound stay aligned only because you author the same numbers on both elements; **there is no automatic waveform sync or drift correction in this stack.**

The room-tone bed and the splice fades are pure composition:
```html
<audio id="dlg-main" src="assets/audio/talk.cut.wav"
       data-audio-group="voiceover" data-start="0" data-track-index="10"></audio>

<audio id="amb-room" src="assets/sfx/room-tone-office.wav"
       data-audio-group="ambience" data-start="0" data-duration="420"
       data-track-index="14" data-volume="0.0316"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.5,&quot;v&quot;:1},{&quot;t&quot;:418.5,&quot;v&quot;:1},{&quot;t&quot;:420,&quot;v&quot;:0}]}]}"></audio>
```
The `t:0` point is mandatory: a lane **holds its first value backwards to the start of its clip**, so a bed without an explicit opening point starts already at whatever its first authored value is.

For the dialogue itself, apply `voice-clean` to the `voiceover` **bus** rather than per clip — *"a compressor cannot ride a sequence it only hears a third of."* Do not also stack a Reduce Mud job on top: `voice-clean` already contains one, and doubling gives −6 dB at 250 Hz where −3 was meant.

**Epidemic Sound — sourcing the bed.** Room tone is the hardest thing to find because it is defined by absence. Query the *space*, not the event, and filter hard on duration so you get a bed rather than a one-shot:
```
SearchSoundEffects { query:{ term: "room tone quiet interior" },
                     filter:{ duration:{ min: 30000, max: 300000 } },
                     sort:{ by: DURATION, order: DESCENDING }, first: 20 }
```
Term variants that return usable beds: `"room tone office"`, `"room tone bedroom quiet"`, `"air conditioning hum background"`, `"studio ambience quiet"`, `"outdoor ambience distant traffic"`. Once one matches the recording's actual room, `SearchSimilarToSoundEffect { id }` builds a small set so a long video is not one loop repeating. Download WAV (`DownloadSoundEffect { id, options:{ fileType: WAV } }`) — mp3 encoder pre-echo is audible on a near-silent bed.

**Remotion:** conceptually a `<Sequence>` per kept segment with `startFrom`/`endAt` on the source `<Audio>`. Concept only; no Remotion runtime here.

## Pairs with
[[pace-partial-pause-removal]] · [[sfx-five-layers-build-order]] · [[sfx-ambience-bridge-across-cut]] · [[cut-jump-cut-take-repair]] · [[cut-jump-cut-run-elided-conversation]] · [[pace-subtractive-first-pass]] · [[cut-b-roll-coverage-from-transcript]] · [[sfx-silence-as-pattern-interrupt]] · [[pace-speech-rate-to-bpm-map]] · [[sfx-ambience-search-formula]] · [[sfx-layer-volume-targets]]

## Failure modes
- **Stripping to zero.** Every breath gone, every sentence butted. Reads as a machine, and it is the exact authenticity cost the source names. Fix: `cut_silence` floor of 0.30 s, and keep every gap under it.
- **No room-tone bed under an aggressive strip.** The noise floor steps at every splice, which the ear hears as pumping even when it cannot localise it. Fix: layer 2 at −30 dB, continuous, spanning every splice. This is the single highest-value line in the note.
- **Using ffmpeg's default `silencedetect` threshold.** −60 dB finds almost nothing on real footage, so the pass appears to "work" while removing two gaps in ten minutes. Fix: always pass `noise=` explicitly, and measure the floor first.
- **Stripping the pause before a serious line.** Removes the beat the line needed. Fix: the exempt-range list is a required input, not an optional refinement.
- **Splice clicks.** Cutting on a non-zero sample leaves a transient. Fix: 8 ms fades at every join; the same ~10 ms figure used to kill plosives.
- **`--copy` on sparse-keyframe footage.** Cuts snap to keyframes and can silently swallow the whole edit. Fix: drop `--copy`, or check `copy_drift` in `--json`.
- **Cutting sound without cutting picture, or vice versa.** There is no auto-sync in this stack. Fix: author the same `data-start` / `data-duration` / `data-media-start` / `data-playback-rate` on both elements, and snapshot to confirm.
- **Known gap:** the 250–500 ms inhale figure is a practitioner estimate, not a cited measurement. The defensible numbers here are ffmpeg's and auto-editor's documented defaults and the broadcast speech-rate band; the breath length is the one parameter to verify by ear on the actual speaker.
