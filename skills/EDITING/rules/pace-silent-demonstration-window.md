---
id: pace-silent-demonstration-window
title: Stop narrating and let the example clip play
skill: editing
type: pacing
family: demonstration
tags: [skill/editing, type/pacing, family/demonstration, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:04:17
    quote: "Cutting on action is another very common technique used by editors, and it helps make the cuts feel smoother and more natural to the viewer."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:01:43
    quote: "Mama said they'd take me anywhere. She said they was my magic shoes."
research_refs:
  - https://educationaltechnology.net/mayers-principles-of-multimedia-learning/
  - https://ctat.roanestate.edu/wp-content/uploads/video_Length_-for_Engagement.pdf
  - https://jite.org/documents/Vol20/JITE-Rv20p173-200Thompson6921.pdf
  - https://www.cambridge.org/core/books/abs/cambridge-handbook-of-multimedia-learning/principles-for-reducing-extraneous-processing-in-multimedia-learning-coherence-signaling-redundancy-spatial-contiguity-and-temporal-contiguity-principles/CD5B7AE1279A9AB81F8EEBB53DBEC86E
difficulty: low
detectable_from: transcript+video
---

# Stop narrating and let the example clip play

## What it is
After a technique is defined in one or two sentences, narration stops completely and the demonstration clip plays with its **own** audio for a measurable window. The source video does this repeatedly — the narration line at 00:04:17 is followed by roughly 18 seconds with no narration at all (00:04:17→00:04:35), and the same shape appears at 00:01:27, 00:01:43, 00:03:53 and 00:05:19, where movie clips play their own dialogue. The example *is* the argument; talking over it makes the viewer choose between listening and looking, and they will do neither well. In multimedia-learning terms this is the coherence/redundancy side of the ledger: narration laid over a visual the learner must scrutinise adds extraneous processing rather than reinforcement.

## When to use it
Immediately after defining any technique whose evidence is visible or audible: a cut type, a transition, a sound effect, a before/after, a piece of footage that proves a claim. Also use it where the demonstration's own sound *is* the point — a J cut example must be heard, and narration would mask the exact thing being taught. Do **not** use it where the visual needs interpretation the viewer cannot supply (a complex diagram, an unlabeled timeline) — that case wants narration plus signalling, not silence.

## How to recognise it in a reference video
- **Transcript gap is the primary tell.** Two narration cues separated by ≥3 seconds with picture running and no narration between them. Detect it from the word-level transcript directly:
  `node <SKILL_DIR>/scripts/transcript-cut.mjs --input ref.mp4 --transcript ref.transcribe.json --cut-silence 3.0 --plan`
  and read the *removed* ranges — those are the candidate windows.
- **Distinguish silence from a demonstration.** In a demonstration window the audio floor does **not** drop to the room floor: the clip's own audio (dialogue, SFX, ambience) is running at speech-level. Measure it:
  `ffmpeg -ss <t> -t <len> -i ref.mp4 -af "astats=metadata=1:reset=8" -f null - 2>&1 | grep RMS_level`
  A dead pause reads −45 dB or lower; a demonstration window reads within 10 dB of the narration's level.
- **Entry signals, look for at least one:** narration ends on a complete sentence (not mid-clause); the music bed ducks hard or stops entirely at the window's first frame; an on-screen label or the item's number card appears; a 6–12 frame beat of held frame before the clip starts.
- **Exit signals:** narration resumes on the frame the demo clip ends or 6–18 frames after; the bed returns at the same level it left; often a new number card.
- **Window lengths cluster.** Log every window's length. In the source they cluster around 8–20 seconds for full demonstrations and 3–8 seconds for a single illustrative beat. A single 40s+ window in short-form educational content is unusual and worth flagging.
- **Cut density inside the window is the *clip's*, not the editor's.** If the window is internally cut at the host video's CPM, it is a montage, not a demonstration.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `window_length` | 240f (8s) | 90–600f (3–20s) | Under 90f the viewer has not finished orienting; over 600f in short-form educational content, split it or add a caption beat. |
| `min_setup_words` | 12 | 8–30 | The definition before the window must be complete on its own; the window proves, it does not explain. |
| `pre_roll_hold` | 9f (0.3s) | 6–15f | Frames between narration ending and the demo's first frame. |
| `post_roll_hold` | 12f (0.4s) | 6–24f | Frames after the demo before narration resumes. Zero reads as an overlap. |
| `demo_audio_level` | 1.0 (0 dB, full) | 0.71–1.0 (−3 to 0 dB) | The demo's own audio takes the dialogue slot for the duration. |
| `bed_during_window` | 0 (stopped) | 0–0.056 (−25 dB) | Stop the bed if the demo has its own music; duck to −25 dB if it does not. |
| `bed_stop_point` | on a waveform peak | — | Cut the bed at a peak, not in a trough, so the stop is smooth rather than sudden. |
| `label_on_screen` | yes | yes/no | An on-screen label or number card is the cheapest "watch this now" signal. |
| `windows_per_item` | 1 | 1–2 | One demonstration per taught item; two only when contrasting before/after. |
| `max_share_of_runtime` | 25% | 10–35% | Sum of all windows ÷ runtime. Above ~35% the video is a compilation with commentary, which is a different format. |

## Reproduction prompt

```
Insert a silent demonstration window after the definition at {{IN}}.

1. Verify the setup is complete. The narration immediately before {{IN}}
   must define the technique in a full sentence of at least 12 words. If it
   trails off or promises "watch this", rewrite it to close cleanly.
2. Set {{IN}} = the frame 9 frames (0.3s) after the last narration word's
   end. Set {{OUT}} = {{IN}} + window_length, default 240 frames (8s), never
   below 90 and never above 600.
3. Place the demonstration clip on the picture track from {{IN}} to {{OUT}}.
   Place its own audio as a separate track at 0 dB (full), occupying the
   dialogue slot. Do not narrate over it. Do not add captions over it unless
   the demo's dialogue is hard to hear.
4. Stop the music bed at {{IN}}. Cut it on a peak in its waveform, not in a
   trough, and ramp the last 4 frames to zero so the stop is smooth.
   Restart the bed at {{OUT}} + 12 frames, at the level it left.
5. Put an on-screen label at {{IN}} naming what to watch for (3-5 words,
   fades in over 6 frames, holds, out over 6 frames before {{OUT}}).
6. Resume narration at {{OUT}} + 12 frames.
7. ACCEPTANCE TEST: play from 3 seconds before {{IN}} to 3 seconds after
   {{OUT}}. There must be no narration word inside [{{IN}}, {{OUT}}]; the
   demo's audio RMS inside the window must be within 10 dB of the
   narration's RMS outside it; and the transition into the window must not
   feel like the audio dropped out - if it does, the bed was cut in a trough
   or the pre-roll hold is missing. Finally, sum all windows in the video:
   if they exceed 35% of runtime, cut the weakest one.
```

## Execution spec

**Finding and cutting the windows (ffmpeg / media-use).** The subtractive pass must be told *not* to eat these gaps. `transcript-cut.mjs --cut-silence 0.6` will happily delete a demonstration window, because from the transcript's point of view it is silence:
```bash
# List candidate windows WITHOUT cutting, then protect them
node <SKILL_DIR>/scripts/transcript-cut.mjs --input aroll.mp4 --transcript aroll.transcribe.json \
  --cut-silence 0.6 --plan > plan.json
```
Inspect `plan.json`, and drive the real cut with explicit `--keep` ranges (inverse mode) or narrow `--remove` ranges that exclude every demonstration window. This is a real trap: the demonstration windows are exactly the gaps the automatic silence cut targets.

**HyperFrames (assembly).** Picture and the demo's own sound are separate elements carrying the same numbers — there is no auto-sync:
```html
<video id="demo-cut-on-action" src="assets/demos/cut-on-action.mp4" muted playsinline class="clip"
       data-start="257.0" data-duration="8.0" data-media-start="0" data-track-index="0"></video>
<audio id="demo-cut-on-action-a" src="assets/demos/cut-on-action.mp4"
       data-audio-group="dialogue"
       data-start="257.0" data-duration="8.0" data-media-start="0"
       data-track-index="10" data-volume="1"></audio>
<!-- window 257.0-265.0s = frames 7710-7950 @30fps -->
```
Every `<audio>` needs an `id` — an id-less audio element is never mixed and renders silent.

Stopping the bed cleanly, using a clip-local `volume` lane with the mandatory `t:0` anchor (the lane holds its first value backwards to the clip start):
```html
<audio id="bed-section-8" src=".media/audio/bgm/bed-8.wav" data-audio-group="music"
       data-start="240.0" data-duration="17.0" data-track-index="11" data-volume="0.079"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:16.87,&quot;v&quot;:1},{&quot;t&quot;:17.0,&quot;v&quot;:0}]}]}"></audio>
```
The bed's `data-duration` ends at 257.0 — the window's first frame — and the last 4 frames (0.13s) ramp to zero. A second bed clip restarts at `265.4`.

The on-screen label is an ordinary timed div with a GSAP opacity pair; use `fromTo`, and keep the resolved end state slightly before `data-duration`:
```js
tl.fromTo("#demo-label", { autoAlpha: 0, y: 8 }, { autoAlpha: 1, y: 0, duration: 0.2, ease: "power2.out" }, 257.0);
tl.to("#demo-label", { autoAlpha: 0, duration: 0.2, ease: "power2.in" }, 264.6);
```
`autoAlpha` is legal here because `#demo-label` is an inner element, not the clip container.

**Epidemic Sound:** nothing to fetch for the window itself. If the demo has no audio of its own, source ambience rather than music: `SearchSoundEffects { query.term: "<location> ambience", filter.duration {min: 10000} }`, placed at −25 dB (`data-volume="0.056"`).

**Remotion:** a Sequence with the demo clip and no narration audio; concept only.

## Pairs with
[[pace-cut-density-from-viewer-intent]] · [[struct-numbered-list-mid-roll-sponsor]] · [[cut-graphic-match]] · [[struct-music-arc-to-narrative-arc]] · [[pace-cut-on-the-beat]] · [[struct-name-define-demonstrate]]

## Failure modes
- **The automatic silence cut deletes the window.** The single most common way this breaks: `--cut-silence` sees a demonstration as dead air. Fix: protect every window with explicit `--keep` ranges and inspect `--plan` before encoding.
- **Narrating over the demo "just to bridge it".** Splits attention and hides the taught detail — precisely the extraneous-processing failure the multimedia-learning literature describes. Fix: move the words before `{{IN}}` or after `{{OUT}}`.
- **Leaving the bed running at full level.** The demo's own audio and the bed fight, and the demo loses. Fix: stop the bed, or duck to −25 dB.
- **Cutting the bed in a trough.** The stop registers as a fault. Fix: cut on a waveform peak, with a 4-frame ramp to zero.
- **Windows too long for the format.** A 45-second unnarrated window in a 6-minute explainer reads as filler. Fix: cap at 600 frames and cap total window share at ~35% of runtime.
- **Known gap:** there is no published measurement of how long an unnarrated demonstration window can run before disengagement. The bands here are craft defaults anchored to the source video's own observed windows (roughly 3–20s) plus the general finding that engagement with instructional video maxes out around 6 minutes regardless of length. Treat `window_length` as the parameter most worth tuning against a channel's real retention graph.
