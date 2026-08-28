---
id: cut-l-audio-trails-picture
title: The L cut — hold the outgoing audio over the incoming picture
skill: editing
type: cut
family: audio-led
tags: [skill/editing, type/cut, family/audio-led, layer/dialogue, layer/ambience, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:23"
    quote: "An L cut is the opposite. The audio from the current scene continues even after the visual cuts to the next."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:29"
    quote: "You're still hearing a line of dialogue or ambient sound as you're already seeing the new shot."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:34"
    quote: "This L cut from Ant-Man continues the character's dialogue while we're visually seeing a reenactment scene, bridging the two together."
research_refs:
  - https://www.backstage.com/magazine/article/l-cut-film-editing-how-to-75537/
  - https://spotlightfx.com/blog/what-are-j-cuts-and-l-cuts-professional-dialogue-editing-explained
  - https://en.wikipedia.org/wiki/Split_edit
  - https://www.soundstripe.com/blogs/a-video-editors-guide-to-j-cuts-and-l-cuts
  - https://firecut.ai/blog/mastering-the-split-edit-how-j-cuts-and-l-cuts-work/
  - https://bop.unibe.ch/JEMR/article/download/2264/3460
difficulty: medium
detectable_from: transcript+video
---

# The L cut — hold the outgoing audio over the incoming picture

## What it is
The second half of the split-edit pair: **picture cuts first, sound carries on**. The shape in a timeline is an L — audio extends to the right of the picture cut — and it is the exact inverse of [[cut-j-audio-leads-picture]], where the sound arrives early. Functionally it does something a J cut cannot: it keeps a **thread of thought** running while the eye is given something new. That is why it is the workhorse of two very different jobs. In dialogue it lets you cut to a listener while the speaker finishes, so the shot is about the reaction rather than the line. In creator and explainer work it is the mechanism that makes B-roll feel motivated rather than decorative: the narration never stops, the picture simply illustrates it — the source's own example is dialogue continuing over a re-enactment scene, "bridging the two together". Where a J cut buys anticipation, an L cut buys **continuity of meaning**.

## When to use it
Four triggers, in descending frequency for creator work. (1) **Any B-roll or graphic insert under continuous narration** — this is the default, and an insert that cuts the voice as well as the picture is almost always a mistake. (2) **Reaction shots**: cut to the listener while the speaker is still talking, so the audience watches the effect of the line instead of its delivery. (3) **Out of a scene that has just landed something**: hold its ambience or its last line over the first seconds of the next scene so the previous beat is allowed to finish. (4) **Into a demonstration**: the explanation trails over the first frames of the doing. Do **not** use it where the point is that something ended — a fade, an act break, a music stop, or a smash cut, where carrying sound across contradicts the boundary ([[cut-fade-bookend]]). Do not stack it against a J cut at the same boundary: two ambiences overlapping in both directions is mush.

## How to recognise it in a reference video
- **Two timecodes, subtracted.** Log the picture cut and the moment the outgoing audio actually ends. `audio_end > picture_cut` is an L cut; `audio_onset < picture_cut` is a J; both within ±2 frames is a straight cut.
- **Measure it, do not eyeball it.** Picture boundary mechanically, audio boundary from a frame-aligned RMS trace (`n=1600` samples at 48 kHz is exactly one frame at 30 fps):
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  The outgoing bed ending shows as a drop of **≥6 dB** in the RMS trace that does **not** coincide with the picture cut.
- **Trail bands worth logging.** Conversational dialogue **9–24 f (0.3–0.8 s)**; reaction-shot holds **24–60 f (0.8–2.0 s)**; ambience carried out of a location **30–90 f (1.0–3.0 s)**. The profession's own published guidance is only "a few frames to a second or two", so treat anything longer as needing a reason. **Trails tolerate more length than J-cut leads** — a voice you have already seen speaking can continue for two seconds without confusion, while a voice arriving two seconds early is noticeable.
- **The degenerate case is the important one.** If the outgoing audio runs for the *entire* incoming shot and beyond, this is not a boundary device — it is **narration-over-B-roll**, the structural pattern. Log it as such: `trail == incoming shot length` means the picture is being cut *underneath* a continuous voice track, and the parameter that matters is then the insert length, not the trail.
- **Transcript test, and it is decisive.** Align the transcript against picture cuts. A sentence that begins before a cut and finishes after it, with no new speaker, is an L cut, and it is detectable from the transcript alone with no video at all.
- **What is trailing.** Classify: dialogue/VO, ambience/room tone, a diegetic effect, or music. Music continuing across a cut is not an L cut — a bed is expected to be continuous ([[sfx-music-sets-the-mood]]).
- **The tail shape.** Look at the last 6–15 frames of the outgoing audio. A clean fade of **6–15 f** is the professional default; a hard stop mid-word is a mistake; a slow 30 f+ ramp reads as a scene ending rather than a bridge.
- **Density.** Split edits as a share of all cuts: dialogue-heavy edits **30–60%**, explainers **10–25%**. In explainers the L direction usually dominates the J direction roughly 3:1, because B-roll inserts are all L cuts.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `audio_trail` | 15 f (0.50 s) | 9–90 f (0.3–3.0 s) | Dialogue 9–24 f · reaction hold 24–60 f · ambience out of a location 30–90 f. |
| `max_trail` | 90 f (3.0 s) | — | Beyond this the picture reads as illustration under continuous narration, not as a cut — switch to the B-roll-insert pattern and document it as such. |
| `outgoing_fade_out` | 9 f (0.30 s) | 0–20 f | Ramp on the trailing audio. 0 f only if it ends on its own natural stop. |
| `word_boundary_guard` | 4 f (0.13 s) | 2–8 f | Minimum gap between the end of the trailing speech and the fade start, so no word is clipped. |
| `incoming_ambience_in` | 12 f (0.40 s) | 6–24 f | Fade-up of the new scene's own bed under the trailing audio. |
| `incoming_duck` | −4 dB | 0 to −8 dB | Level of the incoming bed during the trail window, back to unity after. |
| `reaction_hold` | 36 f (1.2 s) | 24–60 f | How long to stay on the listener before returning or moving on. |
| `split_ratio` | 0.20 | explainer 0.10–0.25 · dialogue 0.30–0.60 | Split edits ÷ total cuts. |
| `l_to_j_ratio` | 3:1 | 1:1–5:1 | In explainer work; dialogue work runs nearer 1:1. |
| `sync_tolerance` | ±1 f | ±0–2 f | Picture and its own sound stay locked; only the boundary is split. |

## Reproduction prompt

```
Build an L cut at the picture cut {{CUT}} (seconds, 30fps) from outgoing
clip {{A}} to incoming clip {{B}}.

1. Decide what trails. In order of preference: A's narration/dialogue (if a
   sentence is mid-flight); A's ambience/room tone; A's last diegetic sound.
   Music never counts - a bed is expected to run across cuts anyway.
2. Set {{TRAIL}} from the boundary type: conversational dialogue 15 frames
   (0.50s); a reaction hold 36 frames (1.20s); ambience out of a location
   45 frames (1.50s). Never exceed 90 frames without reclassifying this as a
   narration-over-B-roll insert.
3. Cut A's PICTURE at {{CUT}} and start B's PICTURE at {{CUT}}. Do NOT cut
   A's audio there: let it run to {{CUT}} + {{TRAIL}}. A's audio keeps its own
   internal sync throughout - its data-media-start is untouched, only its
   duration is longer than its picture's.
4. Never clip a word. Find the last word-end in the transcript before
   {{CUT}} + {{TRAIL}}; start the fade at least 4 frames after it. Fade A's
   audio out over 9 frames. If A's audio reaches a natural stop, use no fade.
5. Bring B's own ambience up under the trail: fade in over 12 frames starting
   at {{CUT}}, held about 4 dB under its later level until the trail ends,
   then back to unity. If B has no ambience of its own, fetch one - a hard
   silence under trailing speech is the tell.
6. Do NOT also pull B's audio earlier at this boundary. One direction per
   boundary: an L and a J stacked at the same cut is two ambiences fighting.
7. If {{TRAIL}} would cover the whole of B, stop treating this as a boundary
   device: keep the narration as ONE continuous audio clip and cut the picture
   under it. That is the B-roll insert pattern and it needs no split at all.

ACCEPTANCE TEST: (a) with eyes closed the audio has no seam; (b) watching,
the picture change must feel like the sentence kept going, not like the sound
lagged; (c) frame-step: A's audio ends exactly {{TRAIL}} frames after B's
first picture frame, no word is truncated, and B's picture and B's own sound
stay within 1 frame of sync from {{CUT}} onward; (d) if a viewer would say
"the old sound hung around", cut {{TRAIL}} by a third.
```

## Execution spec

**HyperFrames (primary), and it is nearly free.** The project convention is a **muted `<video>` with a separate `<audio>`** for its sound — *"the pattern to reach for when picture and sound are cut independently"* — so an L cut is one number: the audio clip's `data-duration` runs past the picture clip's. Times are **seconds**; frames are a comment.

```html
<!-- picture cut at 21.40s; L cut with a 15-frame (0.50s) audio trail -->
<video id="shot-a" src="a.mp4" muted playsinline class="clip"
       data-start="16.00" data-duration="5.40" data-media-start="3.00" data-track-index="0"></video>
<audio id="shot-a-aud" src="a.mp4"
       data-start="16.00" data-duration="5.90" data-media-start="3.00" data-track-index="10"
       data-audio-group="voiceover"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:5.6,&quot;v&quot;:1},{&quot;t&quot;:5.9,&quot;v&quot;:0}]}]}"></audio>

<video id="shot-b" src="b.mp4" muted playsinline class="clip"
       data-start="21.40" data-duration="6.00" data-media-start="8.00" data-track-index="0"></video>
<audio id="shot-b-aud" src="b.mp4"
       data-start="21.40" data-duration="6.00" data-media-start="8.00" data-track-index="11"
       data-audio-group="voiceover"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.63},{&quot;t&quot;:0.5,&quot;v&quot;:0.63},{&quot;t&quot;:0.9,&quot;v&quot;:1}]}]}"></audio>
<!-- 0.50s = 15f @30fps. A's audio outlives A's picture by 0.50s; A's media-start is
     UNCHANGED (unlike a J cut) because we are extending the tail, not pulling sound early. -->
```
Five contract facts this depends on:
- **`data-media-start` is not touched.** The J cut's characteristic mistake — sliding the media offset — has no equivalent here: an L cut only extends `data-duration`.
- **Every `<audio>` needs an `id`.** An id-less `<audio>` is never mixed and renders silent, with no warning.
- The two audio clips **overlap in time and must not share a `data-track-index`**, or lint raises `duplicate_audio_track`. Hence 10 and 11.
- The `data-automation` lane's `t` is **clip-local seconds** and **holds its first value backwards to the clip start and its last value forward to the clip end** — so the `{t:0}` point on `#shot-b-aud` is what actually produces the ducked entry; without it the incoming bed would start at unity.
- Do not also GSAP-tween `volume` on these elements: the lane wins and the tween is silently ignored (`audio_volume_double_automation`).

**The B-roll insert case — the one you will build most often — is simpler still: do not split anything.** Keep the narration as one long `<audio>` at the root (in a modular project, audio *always* lives at the host root so playback survives scene cuts) and cut the picture underneath it:

```html
<audio id="vo-section-3" src=".media/audio/voice/sec3.wav" data-audio-group="voiceover"
       data-start="30.00" data-duration="42.00" data-track-index="10"></audio>

<video id="aroll-3a" src="aroll.mp4" muted playsinline class="clip"
       data-start="30.00" data-duration="6.20" data-media-start="112.00" data-track-index="0"></video>
<video id="broll-3a" src="broll-hands.mp4" muted playsinline class="clip"
       data-start="36.20" data-duration="4.10" data-media-start="2.40" data-track-index="0"></video>
```
Clips authored back to back (`b.start === a.start + a.duration`) share no frame, because the visibility window is half-open `[start, start + duration)`.

**ffmpeg — only when the split leaves the pipeline.** Extend the outgoing audio under the new picture with `atrim` + `afade` + `adelay` (milliseconds):
```bash
# A's audio continued 0.50s past the picture cut at 21.40s, faded out over 0.30s
ffmpeg -i cut.mp4 -i a.mp4 -filter_complex "\
 [1:a]atrim=start=3.0:end=8.9,asetpts=PTS-STARTPTS,afade=t=out:st=5.6:d=0.3,adelay=16000|16000[tail];\
 [0:a][tail]amix=inputs=2:normalize=0[aout]" -map 0:v -map "[aout]" -c:v copy out.mp4
```
Prefer the declarative route — the contract states a physical cut is only for assets leaving the composition, and that there is **no automatic waveform sync**; alignment is the same numbers written twice either way.

**Epidemic Sound.** Two fetches this note commonly needs: the incoming scene's ambience, so the trail is not sitting over silence — `SearchSoundEffects { query.term: "<location> room tone ambience loop", filter.duration { min: 10000 } }` — placed as its own clip in an `ambience` group, **never** in the `voiceover` carve group (a carve group must contain voices only, or it silently poisons the next re-analysis).

**Remotion:** conceptually one `<Audio>` spanning several picture `<Sequence>`s; no Remotion runtime exists in this project.

## Pairs with
[[cut-j-audio-leads-picture]] · [[struct-inverse-pair-teaching]] · [[pace-overlay-instead-of-cut]] · [[pace-visual-variety-density-audit]] · [[cut-invisible-storytelling-doctrine]] · [[cut-on-action]] · [[sfx-sound-pass-order]] · [[cut-audio-match]] · [[pace-partial-pause-removal]] · [[motion-two-track-offset-diagram]] · [[motion-timeline-overlay-explainer]]

## Failure modes
- **Cutting the narration wherever the picture cuts.** The single commonest amateur pattern: every B-roll insert chops the voice track too, producing a room-tone step at every boundary. Fix: one continuous VO clip, picture cut underneath it.
- **Clipping a word.** A trail that ends 3 frames into "…because" is worse than no trail. Fix: take the fade start from the word-level transcript, with a 4-frame guard.
- **Trailing over silence.** The old voice continues but the new scene has no bed under it, so the moment the trail ends there is a hole. Fix: fade the incoming ambience up under the trail.
- **Trailing too long.** Past ~3 s the audience starts wondering why the old speaker is still talking over this new thing. Fix: cut the trail by a third, or convert to an explicit narration-over-B-roll section with its own design row.
- **Stacking an L and a J at one boundary.** Both directions overlapping means two ambiences and two intentions. Fix: one direction per boundary.
- **Using it at a structural boundary.** An act break or a music stop says "this ended"; a trail contradicts it. Fix: hard boundary, no split.
- **Splitting everything.** An edit with no hard cuts has nothing left to punctuate with. Fix: hold `split_ratio` near the profile's target and keep smash cuts hard.
- **`duplicate_audio_track` and silent renders.** Overlapping audio sharing a track index warns; a missing `id` renders silent with no warning at all. Fix: unique ids, distinct track indices across the overlap window.
- **Known gap:** no authoritative source publishes numeric trail standards — the profession's own guidance is "a few frames to a second or two". The bands here are house calibration anchored to that range. Always prefer the measured trail from the reference video when one exists.
