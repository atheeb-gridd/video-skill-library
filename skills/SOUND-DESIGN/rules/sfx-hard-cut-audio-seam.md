---
id: sfx-hard-cut-audio-seam
title: The straight cut's audio seam — switch on the same frame, without a click
skill: sound-design
type: cut
family: hard-cut
tags: [skill/sound-design, type/cut, family/hard-cut, engine/hyperframes, engine/ffmpeg, engine/epidemic, sfx/diegetic, layer/dialogue, layer/ambience, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:00:29
    quote: "The cut is an instant switch between one shot to another, including audio."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:00:38
    quote: "Here you see we cut cleanly from this bar scene to this office scene, and we're ready to take on new information."
research_refs:
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Audio_to_video_synchronization
difficulty: low
detectable_from: audio
---

# The straight cut's audio seam — switch on the same frame, without a click

## What it is
The default cut, defined by the source as *"an instant switch between one shot to another, including audio"* — the three words that matter are **including audio**. Picture and sound change on the identical frame, with no overlap, no ramp and no added effect. It is the cut against which every other cut in the library is a deliberate deviation: a J cut moves the audio earlier, an L cut lets it trail, a smash cut maximises the level delta, a transition adds a sweep. The straight cut does none of that, and its craft is entirely **subtractive** — three ways it can go wrong and how to stop each.

The three failure sources are: a **click** (cutting mid-waveform creates a step discontinuity, which is broadband energy and is heard as a tick), a **noise-floor step** (two shots with different room tone, so the space audibly switches even when the words are continuous), and **drift** (picture and sound not actually landing on the same frame). Research gives the fix for the first: a very short fade, of the order of **10 ms**, is the standard declick — *"To clear up plosive sounds created through vocals, a quick fade-in with a very short time of around 10 ms can be used."* At 30 fps that is a third of a frame; backward masking (**"approximately 20 ms"**) means it is not merely inaudible as a fade, it is masked by whatever follows it. That is why a 1–3 frame crossfade is the conventional maximum for something that must still read as a hard cut: **anything at or under about 3 frames (100 ms) is heard as a switch; from roughly 4 frames up it starts to be heard as a blend.**

Crossfade *shape* matters when the fade gets long enough to matter. For uncorrelated material use an equal-power shape, whose *"midpoint of the fade provides an amplitude multiplier of 0.707"*, or a level dip appears in the middle. For two pieces of the *same* recording (a jump cut in one take) use a linear/equal-gain shape instead, because correlated signals sum in amplitude and equal-power will bump the level up in the middle.

## When to use it
- **As the default for every cut that is not doing something else.** In a talking-head edit, the large majority of cuts are straight cuts, and the large majority carry **no** added sound effect — 5–20 % coverage is the working band from [[sfx-second-sense-doctrine]].
- **When the two sides carry different information and the join should be clean, not commented on.** *"We're ready to take on new information."*
- **Wherever a split edit is not wanted.** If the incoming line should be heard before it is seen, that is [[cut-j-audio-leads-picture]]; if the outgoing line should finish over the new picture, [[cut-l-audio-trails-picture]]. Use this note's seam treatment on both — the declick and floor-continuity rules apply to every audio edit, split or not.
- **Always, as a repair pass**, on any cut that ticks. A ticking timeline is the single most amateur-sounding defect available, and it is free to fix.
- **Not on a boundary you want felt.** For that, either add level contrast ([[sfx-smash-cut-audio-contrast]]) or a transition sound ([[sfx-full-screen-transition-sound-layer]]).

## How to recognise it in a reference video
- **Zoom the waveform to sample level at the cut.** A straight cut shows a **vertical edge** — no visible ramp on either side. A visible 2–20 frame taper means someone crossfaded and it is not a straight cut.
- **Audio and picture change on the same frame.** Compare the scene-change frame with the transient/floor-change sample:
  ```bash
  ffmpeg -i ref.mp4 -vf "select='gt(scene,0.3)',showinfo" -an -f null - 2>&1 | grep pts_time
  ffmpeg -i ref.mp4 -vn -af "asetnsamples=n=1600,astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
  ```
  Same-frame within ±1 frame = straight cut. Audio consistently 4–12 frames earlier = J cut. Later = L cut.
- **Listen for the click, then look for it.** `ffmpeg -i ref.wav -af "highpass=f=6000,astats=metadata=1:reset=1"` — an isolated one-frame spike of high-frequency energy sitting exactly on a cut is a click, not an effect.
- **Watch the noise floor across the seam.** Measure RMS in the speech gaps either side. A well-made straight cut has a floor step of **under 3 dB** and no change in spectral character; a step of 6 dB or more, or a change in tone (one side hissy, one side dead), means there is no ambience bed gluing the cuts and you are hearing raw camera audio ([[sfx-ambience-establishes-location]]).
- **No added effect.** Count how many cuts carry a transient that is not explained by the picture. In a straight-cut-dominated edit, most cuts have nothing on them at all — and that is the finding to log, not an absence of data.
- **Transcript tell:** a straight cut usually falls **between sentences or between clauses**, not mid-word. A cut mid-word with no audio ramp is either a jump-cut repair or a mistake.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `av_alignment` | 0f (identical frame) | 0f only | Both tracks change on the same frame. Any intentional offset makes it a split edit, not a straight cut. |
| `declick_fade` | 5 ms (0.15f) | 2–10 ms | Standard declick; 10 ms is the documented figure for taming plosives. Under 2 ms may not clear a large step. |
| `declick_shape` | linear | linear · log | Too short for shape to be audible; keep it simple. |
| `max_hard_crossfade` | 2f (67 ms) | 1–3f (33–100 ms) | Still perceived as a switch. From 4f it reads as a blend. |
| `crossfade_curve (uncorrelated)` | equal-power (`qsin`) | `qsin` · `hsin` · `esin` | Midpoint amplitude 0.707 so there is no level dip. |
| `crossfade_curve (same take)` | linear (`tri`) | `tri` | Correlated material sums in amplitude; equal-power would bump the middle. |
| `floor_step_tolerance` | ≤3 dB | 0–3 dB | Room-tone difference across the seam. Above this, add or extend an ambience bed. |
| `ambience_continuity` | bed runs across the cut | — | The bed's own clip must span the join, never be cut at it. |
| `sfx_on_cut` | none | 0–1 accents | Straight cuts are usually silent. If you are adding an accent, you have chosen a different note. |
| `zero_crossing_snap` | on | on/off | Landing the out-point on a zero crossing removes the click without any fade at all. |

## Reproduction prompt

```
Author a straight cut at {{CUT}} seconds (composition time) between outgoing
clip {{A}} and incoming clip {{B}}, and make its audio seam clean.

1. ABUT THE PICTURE EXACTLY. Set B.data-start = A.data-start + A.data-duration
   = {{CUT}}. The visibility window is half-open, [start, start+duration), so
   back-to-back clips share no frame - do not overlap them and do not leave a
   gap. Verify by arithmetic, not by eye.
2. ABUT THE SOUND ON THE SAME NUMBER. If picture and sound are separate
   elements, write {{CUT}} on both. Do not offset either one. If you want an
   offset, stop - you are building a J or L cut, not a straight cut.
3. DECLICK BOTH SIDES. On the outgoing audio clip add a volume lane whose last
   two points are 5 ms apart, v:1 then v:0. On the incoming clip add the mirror:
   t:0 v:0, t:0.005 v:1. Include an explicit t:0 point on every lane - a lane
   holds its first value backwards to the clip start, so a missing t:0 makes
   the clip start already faded.
4. IF A CLICK SURVIVES, do not lengthen the fade past 10 ms. Instead move the
   cut point by up to 1 frame to land on a zero crossing, or check that the
   click is not actually a transient in the source.
5. HOLD THE FLOOR ACROSS THE SEAM. Measure RMS in the 300 ms of near-silence
   either side of {{CUT}}. If the two differ by more than 3 dB, place or extend
   an ambience/room-tone bed whose own clip spans {{CUT}} continuously at
   about -28 dB relative to dialogue. Never cut the bed at the picture cut.
6. ADD NO SOUND EFFECT. A straight cut is clean by definition. If the moment
   needs punctuation, use the transition-sound note or the smash-cut note
   instead, deliberately.
7. IF THE TWO SIDES ARE THE SAME TAKE (a pause removal), use a 1-2 frame
   LINEAR crossfade instead of the 5 ms declick - overlap B by 0.033-0.067s
   and mirror the two lanes across the overlap. Linear, not equal-power:
   the material is correlated.

ACCEPTANCE TEST: solo the audio and play from 2s before to 2s after {{CUT}}
three times with your eyes closed. You must not be able to say where the cut
was from any tick, thump or change in room sound - only from the words. Then
play with picture: sound and image must change on the same frame; if the
sound feels a beat behind, re-check that both elements carry the same
data-start.
```

## Execution spec

**HyperFrames — a straight cut is the framework's default, and that is the whole point.** The visibility window is half-open, `[start, start + duration)`: *"Two clips can therefore be authored back to back (`b.start === a.start + a.duration`) with no overlapping frame."* There is **no crossfade attribute and no audio transition primitive** — an audio crossfade must be authored as overlap plus two `volume` lanes.

```html
<!-- picture: abutting, no overlap. Cut at 18.40s -->
<video id="shot-a" src="assets/a.mp4" data-start="12.00" data-duration="6.40"
       data-track-index="0" muted playsinline></video>
<video id="shot-b" src="assets/b.mp4" data-start="18.40" data-duration="5.00"
       data-track-index="0" muted playsinline></video>

<!-- sound: same numbers, 5 ms declick ramps at the seam -->
<audio id="shot-a-aud" src="assets/a.mp4" data-audio-group="voiceover"
       data-start="12.00" data-duration="6.40" data-track-index="10"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.005,&quot;v&quot;:1},{&quot;t&quot;:6.395,&quot;v&quot;:1},{&quot;t&quot;:6.4,&quot;v&quot;:0}]}]}"></audio>
<audio id="shot-b-aud" src="assets/b.mp4" data-audio-group="voiceover"
       data-start="18.40" data-duration="5.00" data-track-index="10"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.005,&quot;v&quot;:1},{&quot;t&quot;:4.995,&quot;v&quot;:1},{&quot;t&quot;:5.0,&quot;v&quot;:0}]}]}"></audio>

<!-- the bed that hides the seam: one clip, spanning both shots -->
<audio id="amb-room" src="assets/sfx/room-tone-loop.wav" data-audio-group="ambience"
       data-start="12.00" data-duration="11.40" data-track-index="11" data-volume="0.04"></audio>
```

Contract points that decide the result:
- **Lane `t` is clip-local seconds**, so the outgoing ramp is at `t: 6.395 → 6.4`, not at composition time.
- **A lane holds its first value backwards and its last forward**, which is exactly why the `t:0, v:0 → t:0.005, v:1` pair works as a fade-in and why omitting `t:0` would leave the clip permanently at its first authored value.
- **Never GSAP-tween `volume` on a track that has a `volume` lane** — `audio_volume_double_automation`: the lane wins and the tween is silently ignored.
- **Every `<audio>` needs an `id`** — an id-less audio element is *never mixed*, giving a silent render, which is the most expensive way to discover this.
- **Two `<audio>` elements sharing a `data-track-index` and overlapping in time raise `duplicate_audio_track`** (warning). For a 1–2 frame audio crossfade on a "same take" join, put the overlapping clip on a different track index.
- **Alignment is authored, not detected:** *"HyperFrames does not provide automatic waveform sync or drift correction."* Picture and sound share `data-start`, `data-duration`, `data-media-start` **and** `data-playback-rate` — if you retime one, retime both, and remember `consumed source = timeline duration × rate`.
- **There is no frame attribute.** 1f = `0.033`, 2f = `0.067`, 3f = `0.1` at 30 fps; render fps comes from `--fps` and defaults to 30.

**ffmpeg — for baked joins and for measurement.** A physical hard join is `concat`, not `acrossfade`:
```bash
printf "file '%s'\n" a.wav b.wav > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy joined.wav          # true hard cut

# 2-frame equal-power crossfade (uncorrelated material), 67 ms
ffmpeg -i a.wav -i b.wav -filter_complex "acrossfade=d=0.067:c1=qsin:c2=qsin" out.wav
# same-take join: linear
ffmpeg -i a.wav -i b.wav -filter_complex "acrossfade=d=0.067:c1=tri:c2=tri" out.wav

# declick a single boundary without a crossfade
ffmpeg -i a.wav -af "afade=t=out:st=6.395:d=0.005:curve=tri" a.declick.wav
```
`acrossfade` options are `duration/d`, `nb_samples/ns` (default 44100), `overlap/o` (default enabled) and `curve1/curve2` from the set `tri, qsin, hsin, esin, log, ipar, qua, cub, squ, cbr, par, exp, iqsin, ihsin, dese, desi, losi, sinc, isinc, quat, quatr, qsin2, hsin2, nofade`. `tri` is linear; `qsin` is the quarter-sine equal-power shape. For frame-accurate work note the `--copy` trap in `transcript-cut.mjs`: stream copy cuts only on keyframes and *"can silently swallow the whole cut"* — *"drop --copy for frame-accurate cuts."*

**Epidemic Sound — usually nothing to fetch, with one exception.** A straight cut needs no effect. What it often needs is the bed that hides the seam:
```
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ANY, values: ["ambience--room-tone"] },
            duration: { min: 30000 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 10 }
```
Live-verified 2026-08-28: the `ambience--room-tone` shelf exists and its titles are explicitly loop-ready — e.g. *"Ambience, Room Tone, Hotel Corridor, Loop"* (44.0 s). `ambience--room-tone` + `ambience--indoor` + `ambience--designed` together return **582** files.

**Remotion:** two `<Sequence>`s with adjacent frame ranges and a 1–2 frame volume ramp at each boundary. Concept only; no Remotion runtime in this project.

## Pairs with
[[cut-straight-hard-cut]] · [[cut-hard-cut-for-new-information]] · [[sfx-split-edit-lead-lag]] · [[cut-j-audio-leads-picture]] · [[cut-l-audio-trails-picture]] · [[sfx-ambience-establishes-location]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-smash-cut-audio-contrast]] · [[sfx-pause-removal-breath-and-room-tone]] · [[sfx-second-sense-doctrine]] · [[sfx-transient-masked-outpoint]] · [[cut-continuity-pass]]

## Failure modes
- **A tick on every cut.** The step discontinuity of a mid-waveform join. Fix: 2–10 ms ramps at both sides, or snap the out-point to a zero crossing. Do **not** fix it by lengthening the fade — at 4+ frames the cut stops being a cut.
- **Solving a click with a 10-frame crossfade.** Now the join reads as a soft blend and the "ready for new information" snap is gone. Fix: keep it ≤3 frames.
- **Equal-power crossfade on two pieces of the same take.** Correlated signals sum, so the middle of the fade gets *louder*. Fix: linear (`tri`) for same-source joins, equal-power (`qsin`) for different sources.
- **Room tone switching at the cut.** Words continue, the space does not, and the edit sounds like an edit. Fix: one continuous ambience clip spanning the join, ≤3 dB floor step.
- **Cutting the ambience bed at the picture cut** because it "belongs" to the shot. This *creates* the floor step. Fix: beds are authored across cuts by design.
- **Picture and sound landing a frame or two apart** because the numbers were typed twice and one was wrong. Film practice tolerates *"no more than 22 milliseconds in either direction"* — under a frame. Fix: derive both `data-start` values from one variable and check the arithmetic.
- **Known gap:** there is no crossfade or declick primitive in this stack, so every seam ramp is a hand-authored `volume` lane and nothing validates it — *"Nothing validates the chain or the effect lanes at all."* On a long timeline this is real bookkeeping; script the lane generation rather than hand-writing 200 of them.
