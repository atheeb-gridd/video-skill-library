---
id: sfx-j-cut-audio-lead
title: The J cut — the next scene's sound arrives before its picture
skill: sound-design
type: cut
family: split-edit
tags: [skill/sound-design, type/cut, family/split-edit, sfx/diegetic, layer/ambience, layer/dialogue, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:01:54
    quote: "A J cut is when the audio from the next scene starts before the video cuts. So the viewer hears what's coming before they see it."
research_refs:
  - https://en.wikipedia.org/wiki/Split_edit
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://www.epidemicsound.com/sound-effects/
difficulty: medium
detectable_from: transcript+video
---

# The J cut — the next scene's sound arrives before its picture

## What it is
A J cut splits the audio and video cut points so the **incoming** clip's sound starts earlier than its picture. For a stretch of time the viewer is still looking at the outgoing shot while already listening to the next one. The letter names the shape on a timeline: the audio track extends left, past the video edit, forming a J.

It is not a transition effect. Nothing crossfades and nothing moves; the only thing that changes is which of the two clips owns the audio during the overlap. Its whole function is anticipatory — the ear is told where you are going a beat before the eye is, and the cut, when it comes, feels answered rather than announced. The mirror move, audio trailing into the next shot, is the L cut; both are covered as a pair in [[sfx-split-edit-lead-lag]], and this note is the J case in full.

## When to use it
- **Entering a new location or scene.** Its strongest and most invisible use: the destination's ambience or room tone comes up under the tail of the previous shot, so the location change lands as a place you were already in.
- **Entering a new speaker.** The next person's first words start over the last shot of the previous one — standard interview and documentary grammar, and the reason talking-head edits stop feeling like a slideshow.
- **Answering a question.** Narration asks; the answer's audio arrives before its picture. This is the highest-value J in explainer content.
- **Crossing a rough visual seam.** When two shots have nothing in common and a straight cut jars, the shared audio across the seam is what makes it hold ([[sfx-hard-cut-audio-seam]], [[cut-continuity-pass]]).
- **Into a demonstration.** The click, the keyboard, the machine, starting under the setup line, so the demo clip does not begin from silence ([[sfx-demo-clip-loudness-handover]]).
- **Not on a smash cut.** A smash cut wants the discontinuity; leading its audio softens exactly the jolt you were buying ([[sfx-smash-cut-audio-contrast]]).
- **Not into a beat-locked montage.** If the cut is snapped to the grid ([[sfx-cut-on-the-beat]]), a lead of more than about a beat blurs the sync the montage is built on.
- **Not when the two audio streams are both speech.** Two voices overlapping for a second is a mess, not a J cut. Lead with the incoming clip's *ambience or foley*, and bring the voice in on the picture cut.

## How to recognise it in a reference video
- **The audio boundary precedes the picture boundary.** Detect the picture cut with scene detection, then find the nearest audio discontinuity before it:
  ```bash
  scenedetect -i ref.mp4 detect-adaptive list-scenes         # picture cuts, seconds
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
   ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  A J cut shows as a step in the noise floor, the room tone, or the speech onset **4 to 90 frames before** the picture cut, with no matching step at the cut itself.
- **Measure and report the lead in frames**, not as a yes/no. `lead_frames = cut_frame − audio_onset_frame`. This is the number a design document needs.
- **Bands seen in practice, and what each buys:**
  | Lead | Frames @30 | Reads as |
  |---|---|---|
  | < 0.13 s | < 4 | Nothing. Below the audio-lag detectability threshold (ITU-R BT.1359-1: 125 ms lag), so the ear treats it as the same cut. A wasted J. |
  | 0.2–0.5 s | 6–15 | A softened cut. Common on quick B-roll and on foley leads. |
  | 0.5–1.5 s | 15–45 | **The standard dialogue J cut.** Enough for a full incoming clause. |
  | 1.5–3.0 s | 45–90 | Location/scene J cut on ambience. Feels cinematic; too long for dialogue. |
  | > 4 s | > 120 | No longer read as a cut relationship — it is an audio bridge or a bed ([[sfx-ambience-bridge-across-cut]]). |
- **What is leading matters.** Speech leading is a dialogue J; a step in the noise floor with no speech is an ambience J; a single transient (a door, a click) is a foley J and usually leads by only 4–12 frames.
- **On the transcript:** the incoming section's first words carry a timestamp earlier than the shot change. Word-level transcripts make this trivially measurable — `word.start < cut_time` while the speaker on screen is still the previous one.
- **Counter-check for the L cut:** if the *outgoing* audio continues past the picture cut instead, it is an L, and the finding should be logged as such.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `lead` — dialogue | 0.8 s (24 f) | 0.5–1.5 s | Long enough for one incoming clause. Land the lead so it starts on a word boundary, never mid-word. |
| `lead` — ambience / location | 2.0 s (60 f) | 1.0–3.0 s | Start it at a low level and ramp; a location that arrives at full level reads as a mistake. |
| `lead` — foley / single transient | 0.25 s (8 f) | 0.13–0.5 s | Below 4 frames it is inaudible as a lead. |
| Minimum useful lead | 0.13 s (4 f) | — | The audio-lag detectability floor. Shorter is not a J cut. |
| Incoming level during the lead | 0.5 (−6 dB) | 0.35–0.7 | Ramp up to full at the picture cut, so the cut still "arrives". |
| Ramp shape | linear over the lead | 0.2 s–full lead | For ambience use the whole lead; for dialogue ramp over the first 0.2 s only. |
| Outgoing level during the lead | 1.0 → 0.7 | 0.6–1.0 | Only duck the outgoing when both streams carry speech; otherwise leave it. |
| Overlap of two speech streams | 0 s | 0 s | Hard rule: never overlap two voices. Lead with ambience instead. |
| Music behaviour | unchanged | — | The bed spans the cut; it is what makes the seam invisible. Do not restart the bed at a J. |

## Reproduction prompt
```
Build a J cut into the clip at {{CUT}} (composition seconds), leading its audio by
{{LEAD}} seconds (default 0.8 for dialogue, 2.0 for ambience, 0.25 for foley).

1. SPLIT PICTURE FROM SOUND. The incoming video plays muted; its audio becomes a
   separate <audio> element with the same src. Give both an id.
2. VIDEO stays where it is: data-start={{CUT}}, data-media-start=S (its source
   in-point), data-duration as planned.
3. AUDIO moves earlier and its source in-point moves with it by the same amount,
   or picture and sound will be out of sync after the cut:
      audio data-start        = {{CUT}} - {{LEAD}}
      audio data-media-start  = S - {{LEAD}}          (must be >= 0)
      audio data-duration     = video duration + {{LEAD}}
   If S < {{LEAD}} there is not enough handle in the source: shorten the lead, or
   use a separate ambience file for the lead instead of the clip's own audio.
4. RAMP THE LEAD. Volume automation lane on the audio clip, clip-local seconds:
   dialogue -> t=0 v=0.5, t=0.2 v=1.0, and nothing after.
   ambience -> t=0 v=0.35, t={{LEAD}} v=1.0.
   Author the t=0 point explicitly; a lane holds its first value backwards.
5. HOLD THE OUTGOING. Do not fade the outgoing shot's audio out under the lead
   unless both streams are speech; if they are, duck the outgoing to 0.7 across
   the lead, and lead with ambience only, never with the incoming voice.
6. KEEP THE MUSIC CONTINUOUS across the seam. Do not restart or stop the bed here.
7. ACCEPTANCE TEST: (a) at {{CUT}}-{{LEAD}}/2 you hear the next scene and see the
   previous one; (b) after {{CUT}} the incoming speech is still lip-synced —
   scrub two words in and check; (c) the lead does not begin mid-word; (d) the
   lead is at least 4 frames (0.13 s) or it is doing nothing.
```

## Execution spec

**Hyperframes.** The stack has no split-edit primitive and no automatic sync, so a J cut is authored by writing the offset twice — once on the video, once on the audio — exactly as the contract's alignment section prescribes. The house pattern is already `muted` video plus a separate `<audio>`.
```html
<!-- picture cuts at 12.0 s; its sound arrives 0.8 s early -->
<video id="shot-2" src="footage/kitchen.mp4" muted playsinline
       data-start="12" data-duration="4" data-media-start="8"
       data-track-index="0"></video>

<audio id="shot-2-audio" src="footage/kitchen.mp4"
       data-audio-group="location"
       data-start="11.2" data-duration="4.8" data-media-start="7.2"
       data-track-index="10"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.35},{&quot;t&quot;:0.8,&quot;v&quot;:1}]}]}"></audio>
```
Both `data-start` and `data-media-start` move by the lead; moving only one desyncs the whole shot. Relative timing can express it — `data-start="shot-1 - 0.8"` — but **the spaces around the minus are mandatory**: `"shot-1-0.8"` parses as an id and silently resolves to 0. Keep the audio on a track index of 10+; two `<audio>` elements sharing a track index and overlapping in time raise `duplicate_audio_track`, and the J's overlap is precisely that, so give the lead its own index. Every `<audio>` needs an `id` or it is never mixed and the render is silent.

**ffmpeg.** Only needed when the source has no handle before its in-point, or when you want a standalone lead file:
```bash
# extract 3 s of the destination's room tone from before the in-point
ffmpeg -i kitchen.mp4 -ss 5.0 -to 8.0 -vn -c:a pcm_s16le kitchen_lead.wav
# check there is handle at all
ffprobe -v error -show_entries format=duration kitchen.mp4
```

**Epidemic Sound.** When the incoming clip has no usable handle — the commonest real case — buy the lead from the library instead of from the footage. Fetch the destination's room tone and run it under the outgoing shot:
```json
{ "query": { "term": "room tone office" },
  "filter": { "tagSlugs": { "matchType": "ALL", "values": ["ambience--room-tone"] },
              "duration": { "min": 30000 } },
  "sort": { "by": "POPULARITY", "order": "DESCENDING" }, "first": 8 }
```
Verified: `ambience--room-tone` returns 120 s beds (office, office kitchen, office + AC among them); swap the term for the destination — `ambience--urban`, `ambience--forest`, `ambience--office`, `ambience--desert` are all live slugs. A wrong slug returns `meta.total: 0`, so zero results means fix the slug, not widen the search. Place the fetched bed at `{{CUT}} - {{LEAD}}` and let it continue under the incoming shot so the join is seamless ([[sfx-ambience-search-formula]]).

**Remotion.** Same idea: the incoming `<Sequence>` for audio starts `leadFrames` before the video sequence, with `startFrom` reduced by the same number of frames. Portability note only — Remotion is not part of this stack.

## Pairs with
[[sfx-split-edit-lead-lag]] · [[cut-j-audio-leads-picture]] · [[cut-l-audio-trails-picture]] · [[cut-j-curiosity-lead]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-ambience-establishes-location]] · [[sfx-hard-cut-audio-seam]] · [[sfx-demo-clip-loudness-handover]] · [[cut-split-edit-attention-steering]] · [[pace-split-edit-cadence]] · [[sfx-missing-ambience-audit]]

## Failure modes
- **Moving `data-start` without `data-media-start`.** The lead plays, and then the whole shot is 0.8 s out of sync for its entire length. Nothing in the stack detects this — there is no automatic waveform sync or drift correction. Scrub two words past the cut and check lip sync every time.
- **Leading with the voice over another voice.** A second of two people talking is not anticipation, it is an accident. Lead with ambience or foley; bring the voice in on the picture cut.
- **A lead under 4 frames.** Below the 125 ms audio-lag detectability threshold the ear folds it into the cut. You paid for a J and got a straight cut.
- **Full-level ambience arriving early.** The location appearing at full volume before the picture reads as a mix error. Ramp it: 0.35 → 1.0 across the lead.
- **Starting the lead mid-word.** A half-syllable before the cut sounds like a dropout. Snap the lead's start to a word boundary from the word-level transcript.
- **Leading into a smash cut or a beat-locked montage.** Both depend on simultaneity. A J cut there dissolves the effect you were building.
- **Restarting the music at the seam.** The bed spanning the cut is half of why the J is invisible; a music change at the same frame turns an invisible edit into a section break.
- **Known gap:** `duplicate_audio_track` is only a warning, and there is no lint rule at all for split-edit sync. Verify by rendering the seam and listening; the browser-dependent render must run off the authoring VM.
