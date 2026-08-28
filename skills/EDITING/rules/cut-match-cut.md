---
id: cut-match-cut
title: The match cut — carry one shared property across the join
skill: editing
type: cut
family: match-cut
tags: [skill/editing, type/cut, family/match-cut, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:17"
    quote: "The match cut is a cut that matches action, shape, colour, framing or even audio of two shots, seamlessly bringing the viewer into the next scene."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:31"
    quote: "The three types of match cuts are: graphic, with visual elements matching; movement, with camera, character or object movement matching; and audio, with the sound matching between the two scenes."
research_refs:
  - https://en.wikipedia.org/wiki/Match_cut
  - https://ffmpeg.org/ffmpeg-filters.html#ssim
  - https://ffmpeg.org/ffmpeg-filters.html#signalstats
  - https://ffmpeg.org/ffmpeg-filters.html#signature
  - https://en.wikipedia.org/wiki/Walter_Murch
difficulty: high
detectable_from: transcript+video
---

# The match cut — carry one shared property across the join

## What it is
A hard cut in which the outgoing frame and the incoming frame **share one salient property**, so the viewer's eye or ear stays locked on that property while everything around it changes. The shared element is the handrail: it carries the attention across the join, and the viewer arrives in the new scene already oriented instead of having to re-find the subject. The reference definition names five properties a match cut can be built on — **action, shape, colour, framing, audio** — and the creator's own taxonomy collapses them into three types by *which channel does the carrying*:

| Type | Carries on | Dedicated note |
|---|---|---|
| **Graphic** | shape, colour, framing — a static compositional property | [[cut-graphic-match]] |
| **Movement** | camera, character or object motion continuing across the cut | [[cut-movement-match]] |
| **Audio** | a sound continuing, or two sounds resolving into each other | [[cut-audio-match]] |

**This note is the parent.** It owns the part that is common to all three and that none of the children can own: **how you find the pair in the first place.** A match cut is not something you apply to two shots you already chose — it is a constraint that *selects* the two shots, which is why it is the highest-difficulty cut in the library. This note gives the selection procedure and a mechanical candidate-finder, then hands off to the child note for the execution of whichever channel wins.

The canonical examples are worth carrying because they show the range: *2001: A Space Odyssey* cuts a thrown bone to an orbiting satellite (shape + movement, and the match is the whole argument of the film); *Psycho* goes from the shower drain to Marion's eye (shape + framing); a graphic match is defined precisely as one where *"the shapes, colors and/or overall movement of two shots match in composition."*

The discipline that keeps it from being a gimmick: **exactly one property should match, and it should be the property the idea lives in.** Two shots that match on shape *and* colour *and* framing are not a match cut, they are the same shot twice. And in Murch's weighting — emotion 51%, story 23%, rhythm 10%, eye-trace 7%, 2D plane 5%, 3D space 4% — the match cut trades entirely in the bottom 16%. It has to earn the top 74% some other way, which is why a technically perfect match cut that says nothing reads as showing off.

## When to use it
A match cut is justified by a **relationship between two ideas**, not by two shots that happen to rhyme. Use it when:

- The script makes an explicit comparison, analogy or transformation — "this is really the same as that", "and then it became", "which brings us back to". Search the transcript for that language; it is the strongest single trigger.
- You are crossing a boundary the viewer would otherwise experience as a break: a time jump, a location change, a topic change, or the seam between two footage sources that do not belong together ([[cut-full-screen-transition]] is the alternative when nothing matches).
- A before/after or problem/solution pair exists in the content, and the match makes the pairing visible without a caption ([[struct-inverse-pair-teaching]]).
- Two visuals must be understood as the same object at different scales — the diagram and the real thing, the code and the running app, the plan and the result.

Do not use it: to get out of a shot you have no other exit from; more than a couple of times in a video (the device is loud and repetition burns it); or where the "match" is only visible frame-by-frame — if it does not read at full speed, it is not there. When two shots must simply flow, the correct tools are [[cut-outpoint-inpoint-alignment]] and [[cut-eye-trace-continuity]], which are invisible and cost nothing.

## How to recognise it in a reference video
Detection has two stages: find joins that are suspiciously similar across the cut, then classify which property is doing the carrying. Stage one is fully mechanical.

**Stage 1 — extract the boundary frame pair.** For each detected cut at time `t`, pull the last frame of the outgoing shot and the first frame of the incoming shot:
```bash
ffmpeg -i ref.mp4 -vf "select='gt(scene,0.3)',showinfo" -vsync vfr -f null - 2>&1 | grep showinfo   # candidates
ffmpeg -ss <t_minus_1frame> -i ref.mp4 -frames:v 1 -q:v 2 a_out.png
ffmpeg -ss <t>              -i ref.mp4 -frames:v 1 -q:v 2 b_in.png
```

**Stage 2 — score the pair on five channels.** Each has a runnable measurement and a threshold. A match cut trips **one** of these hard while the others stay ordinary; a dissolve or a repeated shot trips all of them.

- **Framing / mass distribution — the most useful single number.** Blur both frames heavily so texture disappears and only the distribution of light and mass survives, then measure structural similarity. Heavy blur is what makes this a *framing* test rather than an image-identity test:
  ```bash
  ffmpeg -i a_out.png -i b_in.png -lavfi \
    "[0]gblur=sigma=14[a];[1]gblur=sigma=14[b];[a][b]ssim=stats_file=-" -f null -
  ```
  **Blurred SSIM ≥ 0.55** at a hard cut between two genuinely different scenes is a strong framing/shape match. Compare against the reference video's own baseline: compute the same number for 20 random non-adjacent frame pairs and take the 95th percentile as the "no match" ceiling — typically 0.25–0.40. Report the candidate's score *relative* to that ceiling, never as an absolute.
- **Luminance and colour.** Per-frame channel means:
  ```bash
  ffmpeg -i a_out.png -vf "signalstats,metadata=print" -f null - 2>&1 | grep -E "YAVG|UAVG|VAVG"
  ```
  A colour match holds **|ΔYAVG| ≤ 12** and **|ΔUAVG|, |ΔVAVG| ≤ 10** on a 0–255 scale. Colour alone matching while framing does not is the signature of a *colour* match — rarer, and usually paired with a topic change.
- **Subject position.** Locate the dominant subject in each frame (largest connected high-contrast region, or a face if present) and measure the centroid offset. **Within 8% of the frame diagonal** is a deliberate positional match; that is also what makes it an eye-trace match, so log it against [[cut-eye-trace-continuity]] as well.
- **Movement continuity.** Sample motion over the 6 frames before and the 6 frames after the cut. A movement match holds **direction within ±20°** and **speed within ±30%** across the join. This is the only channel that needs a temporal window rather than a frame pair — a single-frame test cannot see it, which is why movement matches are the most commonly missed in analysis.
- **Audio continuity.** Windowed RMS and spectral centroid across the join. An audio match holds **level within ±3 dB** and centroid within ±15% while the picture changes completely. Distinguish from a J/L split edit ([[cut-j-audio-leads-picture]], [[cut-l-audio-trails-picture]]): in a split edit the audio *is* one of the two shots' own audio, running early or late; in an audio match, the two sounds are different sources that resolve into each other.

**Stage 3 — confirm by eye at full speed, and check the transcript.** A pair that scores high mechanically but does not read as a match at 30fps is a coincidence, and a match cut whose transcript shows no comparison, transformation or topic change is decoration. Log every candidate as `timecode | channel | score | baseline | reads-at-speed y/n | transcript trigger`.

MPEG-7 `signature` exists in ffmpeg for near-duplicate detection and is worth knowing about, but it is built to answer "is this the same video" and is too coarse for compositional matching. Blurred SSIM plus channel means is the right resolution here.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `matched_channel` | one only | shape · colour · framing · movement · audio | Two channels matching is acceptable when one is dominant; three is the same shot twice. |
| `blurred_ssim_threshold` | 0.55 | 0.45–0.70 | With `gblur=sigma=14` at 1080p. Scale sigma with frame height (≈ height/77). Always report against the video's own 95th-percentile baseline. |
| `luma_delta_max` | 12 (0–255) | 6–20 | `YAVG` difference across the join for a colour/tone match. |
| `chroma_delta_max` | 10 (0–255) | 5–16 | `UAVG` / `VAVG` difference. |
| `centroid_offset_max` | 8% of frame diagonal | 4–12% | Subject-position match. Beyond 12% the eye has to travel and the match is lost. |
| `motion_direction_tolerance` | ±20° | ±10–30° | Movement match. |
| `motion_speed_tolerance` | ±30% | ±15–50% | Movement match. Slower incoming motion reads better than faster. |
| `audio_level_delta_max` | 3 dB | 1–6 dB | Audio match. |
| `cut_type` | hard cut, 0 frames | 0 frames · 2–4 frame dissolve | A match cut is a **straight cut**. A short dissolve is permissible only to hide a small geometric mismatch, and 4 frames is the ceiling before it reads as a dissolve. |
| `pre_roll_on_shape` | 12 f (0.4 s) | 8–20 f | Frames the matching shape must be established on screen *before* the cut, or the viewer has not registered it in time to notice the carry. |
| `post_roll_on_shape` | 15 f (0.5 s) | 10–24 f | Frames the shape holds after the cut before the new scene starts moving. |
| `uses_per_video` | 1 | 0–3 | Budget. The device is loud. |
| `sfx_on_join` | none, or one soft accent | — | A match cut is usually cleanest dry. If it needs help, see [[sfx-peak-on-the-cut]]. |

## Reproduction prompt

```
Build a match cut at boundary {{BOUNDARY}} in {{PROJECT}}. Frames at 30fps.

1. Read the transcript around {{BOUNDARY}} and state, in one sentence, the
   RELATIONSHIP the cut must express (comparison / transformation / same
   thing at another scale / problem-to-solution). If you cannot state it,
   stop: use a straight cut per cut-straight-hard-cut instead.
2. Pick the CHANNEL that carries that relationship - shape, colour, framing,
   movement, or audio - and pick exactly one. Record it.
3. Build the candidate pool. For every available outgoing tail frame and
   every available incoming head frame, extract stills:
     ffmpeg -ss <t> -i <src> -frames:v 1 -q:v 2 <name>.png
   and score each pair:
     ffmpeg -i a.png -i b.png -lavfi "[0]gblur=sigma=14[a];[1]gblur=sigma=14[b];
       [a][b]ssim=stats_file=-" -f null -
     ffmpeg -i a.png -vf "signalstats,metadata=print" -f null -   (YAVG/UAVG/VAVG)
   Establish the baseline first: the same blurred-SSIM score for 20 random
   non-adjacent pairs from this footage; take the 95th percentile.
4. Rank pairs by (score - baseline) on the chosen channel and take the top 5.
   Reject any pair that also scores high on two other channels - that is the
   same image twice, not a match.
5. Choose the in/out frames so the matching element is on screen for at
   least 12 frames before the cut and 15 frames after it. Adjust the incoming
   clip's media offset, not the cut position, to achieve this.
6. Cut hard - 0 frames of overlap. Only if a residual geometric mismatch is
   visible at full speed, add a dissolve of at most 4 frames, and record why.
7. If the channel is MOVEMENT: match direction within 20 degrees and speed
   within 30%, and place the cut at the moment of peak velocity, not at the
   start or end of the move.
   If the channel is AUDIO: hold level within 3 dB across the join and do not
   let a music transition happen on the same frame.
8. ACCEPTANCE TEST: play 2 seconds either side at full speed, three times.
   The match must be noticeable on the first viewing and must not require
   frame-stepping to see. Then re-read the transcript line at the cut and
   confirm it states the relationship from step 1. Finally confirm the
   video's total match-cut count is <= 3.
```

## Execution spec

**HyperFrames (assembly).** A match cut is two clips authored back to back with no overlapping frame. The visibility window is half-open — `[start, start + duration)` — so `b.start === a.start + a.duration` produces a clean single-frame join with nothing to configure:

```html
<!-- Outgoing: shape established for 12f (0.4s) before the join at 61.20s -->
<video id="mc-a" src="assets/shot-a.mp4" muted playsinline class="clip"
       data-start="58.40" data-duration="2.80" data-media-start="14.10"
       data-track-index="0"></video>
<!-- Incoming: same shape held for 15f (0.5s) after the join. media-start is the
     knob that positions the matching element, NOT data-start. -->
<video id="mc-b" src="assets/shot-b.mp4" muted playsinline class="clip"
       data-start="61.20" data-duration="4.00" data-media-start="7.63"
       data-track-index="0"></video>
```

Three things to get right:

- **Tune `data-media-start`, never the cut frame.** The cut frame is set by the section's structure and possibly by a beat grid; the *phase* of the matching element inside the incoming shot is what you adjust. `data-media-start` trims into the source without touching the file.
- **Do not put a registry transition on this boundary.** The transition injector extends the outgoing clip's `data-duration` and pulls the incoming clip's `data-start` earlier to create an overlap — that overlap destroys the match, because the two frames become visible simultaneously and the viewer sees the mismatch rather than the carry. If you truly need 2–4 frames of softening, author a hand-written `crossfade` at 0.07–0.13 s rather than invoking a registry name whose default is 0.5 s.
- **`data-track-index` is display only.** It layers nothing; two clips on one index may overlap in time. Keep both shots on the same index (`0`) as a readability convention and rely on the half-open window for the exclusivity.

If the matching element needs help to be noticed — a scale or position nudge that brings the two compositions into register — that is a GSAP tween on the clip wrapper, on the single paused timeline, in absolute composition seconds, with `fromTo` (never `from`) and transform aliases only (`x`, `y`, `scale`, `rotation`):

```js
// Bring shot A's shape 2% larger to register exactly with shot B's, landing
// before the cut at 61.20s. Linear, so it reads as a camera move, not a gesture.
tl.fromTo("#mc-a", { scale: 1.00 }, { scale: 1.02, duration: 0.40, ease: "none" }, 60.80);
```
No CSS `transform` on the same element (`gsap_css_transform_conflict`, an error — and a lint error also switches off the layout and contrast audits, so `check` reports `0 sample(s)` and looks clean while nothing ran).

**ffmpeg.** Analysis, as in the recognition section, plus baking only when the deliverable leaves the composition. If you do bake, re-encode: `-c copy` snaps cuts to keyframes and will move the join off the matched frame.
```bash
ffmpeg -i a.mp4 -ss 14.10 -to 16.90 -c:v libx264 -preset veryfast -crf 18 -c:a aac a.cut.mp4
ffmpeg -i b.mp4 -ss 7.63  -to 11.63 -c:v libx264 -preset veryfast -crf 18 -c:a aac b.cut.mp4
printf "file '%s'\n" a.cut.mp4 b.cut.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy match.mp4
```

**Epidemic Sound.** For an **audio** match you may need the two sounds that resolve into each other. `SearchSoundEffects` takes `query.term` plus `filter.tagSlugs {matchType, values}` and `filter.duration {min,max}` in **milliseconds** — pull both candidates in one pass and audition them against picture per [[sfx-ab-audition-candidates]]. Do not let a music track change on the same frame as the match; the ear cannot follow two matches at once ([[sfx-track-change-at-section-boundary]]).

**Remotion:** two `<Sequence>` blocks with adjacent frame ranges; the same `data-media-start` role is played by the source's `startFrom`. Not present in this project.

## Pairs with
[[cut-graphic-match]] · [[cut-movement-match]] · [[cut-audio-match]] · [[cut-eye-trace-continuity]] · [[cut-outpoint-inpoint-alignment]] · [[cut-on-action]] · [[cut-invisible-storytelling-doctrine]] · [[struct-inverse-pair-teaching]] · [[sfx-peak-on-the-cut]] · [[cut-full-screen-transition]] · [[cut-straight-hard-cut]]

## Failure modes
- **A match with no idea behind it.** Two circles cutting to each other because they are both circles reads as an editor's flourish and costs the viewer a beat of confusion. Fix: the transcript must state the relationship. If it does not, the cut is decoration — delete it.
- **Matching too many channels.** Shape + colour + framing + position all matching means the viewer perceives one continuous shot with a glitch in it, not a transition. Fix: one dominant channel; deliberately break at least one other.
- **The shape is not on screen long enough.** Under ~12 frames of pre-roll the viewer never registered the outgoing shape, so there is nothing to carry. Fix: extend the outgoing tail, or adjust the incoming media offset — never shorten the pre-roll to hit a beat.
- **Softening it with a default dissolve.** A 0.5 s crossfade shows both frames at once and exposes the mismatch it was meant to hide. Fix: hard cut, or at most 4 frames.
- **Movement match with the speed reversed.** Fast outgoing motion into slow incoming motion reads as a brake; the reverse reads as an accident. Fix: match speed within 30%, and if you must mismatch, let the incoming shot be the slower one.
- **Landing the match on a music change.** Two simultaneous matches compete and neither lands. Fix: separate them by at least a bar.
- **Trusting the score over the screen.** Blurred SSIM will happily rank a pair that no viewer perceives as matching. Fix: the full-speed read is the gate; the score only produces the shortlist.
- **Known gap:** this stack has no shot-boundary metadata, no subject detection and no motion-vector export. Cut candidates come from `select='gt(scene,0.3)'`, which misses cuts between similar shots and invents them on fast pans; subject centroids and motion vectors have to be estimated from extracted stills by eye or by a script you write yourself. Record every measured number in the design document so a re-cut does not have to rediscover it.
