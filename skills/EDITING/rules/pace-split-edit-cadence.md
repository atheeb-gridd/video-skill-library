---
id: pace-split-edit-cadence
title: Split-edit cadence — stagger audio and picture across a whole conversation, not one cut
skill: editing
type: pacing
family: audio-led
tags: [skill/editing, type/pacing, family/audio-led, layer/dialogue, layer/ambience, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:53"
    quote: "These cuts are incredibly useful because they create a smoother, more natural flow between shots, especially in conversations."
research_refs:
  - https://en.wikipedia.org/wiki/Split_edit
  - https://edicionvideopro.com/en/editing-techniques/j-cuts-and-l-cuts-the-secret-of-professional-audio-easy/
  - https://www.production-expert.com/production-expert-1/5-techniques-for-dialogue-editing-in-film-and-tv
  - https://www.cined.com/editing-dialogue-sequences-a-short-video-tutorial/
  - https://spotlightfx.com/blog/what-are-j-cuts-and-l-cuts-professional-dialogue-editing-explained
difficulty: medium
detectable_from: transcript+video
---

# Split-edit cadence — stagger audio and picture across a whole conversation, not one cut

## What it is
[[cut-j-audio-leads-picture]] and [[cut-l-audio-trails-picture]] describe one boundary each. This note is the **policy across a sequence**: which boundaries get split, in which direction, by how much, and — the part that actually produces "natural" — how those choices vary from cut to cut. A conversation edited with a straight cut on every line reads mechanical because every boundary is identical: picture and sound change on the same frame, every time, and the regularity is what the ear hears as "assembled". A conversation edited with the *same* J cut at the *same* offset on every line is equally mechanical, just softer. The professional shape is a **cadence** — a mixture of straight cuts, J cuts and L cuts with varying offsets, in which the audio edit point and the picture edit point almost never coincide, and no two consecutive boundaries use the same device.

## When to use it
Any sequence with more than about four consecutive dialogue boundaries: a two-hander interview, a multi-camera podcast, a reaction/response cut, a talking head intercut with an off-camera question. Also use it on a **retro-fit pass**: when a dialogue sequence is cut and "feels choppy" but no single cut is wrong, the fault is nearly always that every boundary is the same boundary. The counter-case: a rapid Q&A gag, a montage of one-line answers, or any run where the *snap* between speakers is the joke — there the coincident cuts are the rhythm and splitting them kills it. Also skip it wherever the sequence is a series of separate takes with different room tone, until a continuous ambience bed is in place, because overlapping two different noise floors is worse than a hard cut.

## How to recognise it in a reference video
- **Build the boundary table.** This is the whole detection method. For every cut in the sequence, log four columns: `picture_cut_frame`, `audio_edit_frame`, `delta = audio − picture` (negative = J, positive = L, 0 = straight), and `lead_content` (dialogue / ambience / diegetic / music).
  ```bash
  # picture cuts
  ffmpeg -i ref.mp4 -vf "scdet=t=10,metadata=print" -f null - 2>&1 | grep lavfi.scd
  # per-frame RMS (n=1600 @48kHz = exactly one frame @30fps)
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  A speaker change shows as a step of **≥6 dB** or a clear timbre change in the trace; align it against the transcript's word boundaries for the exact frame.
- **Coincidence count** is the headline number. `coincident = boundaries where |delta| ≤ 2 f`. A choppy edit is near 1.0. A dialogue-heavy professional edit runs **0.4–0.7**, i.e. 30–60% of boundaries are split.
- **Run length.** Look for consecutive boundaries with the same sign of `delta`. Three or more J cuts in a row is a pattern the ear starts predicting. Professional sequences rarely run more than **2** of the same type consecutively.
- **Offset spread.** Compute the standard deviation of `|delta|` across the split boundaries. Everything at exactly 12 f is a template; a spread of **±4–8 f** around the mean is human.
- **Published overlap band.** Dialogue-editing guidance puts split overlaps at roughly **0.5–2.0 s (15–60 f)**, with "start at one second and move from there" as the working default; conversational J leads in fast creator dialogue sit shorter, **6–12 f**. Log which band the reference lives in — it is a strong style fingerprint.
- **Fade signature.** At each split, measure the incoming audio's ramp. **3–5 f** is the published default and is what prevents the double-voice smear when two dialogue tracks overlap. A hard-in on a transient is deliberate.
- **Never both directions at one boundary.** If you find outgoing audio continuing past the cut *and* incoming audio starting before it, that is two overlapping ambiences, not a cadence — log it as a defect.
- **Where the hard cuts survive.** Note which boundaries are left straight. In a good sequence they cluster on the beats that want a snap: an interruption, a punchline, a topic change, a smash cut ([[cut-hard-cut-for-new-information]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `split_ratio` | 0.45 | 0.30–0.60 (dialogue) · 0.10–0.25 (explainer) | Split boundaries ÷ total boundaries in the sequence. |
| `coincidence_gap` | ≥ 6 f | 6–60 f | Minimum distance between the picture edit and the audio edit at a split boundary. Under 3 f it is a straight cut with jitter. |
| `j_lead` | 9 f (0.30 s) | 6–18 f conversational · 15–60 f with ambience | Incoming audio before the picture. |
| `l_trail` | 15 f (0.50 s) | 6–72 f | Outgoing audio after the picture. Longer than a J lead is normal — trailing dialogue is more tolerable than early dialogue. |
| `offset_jitter` | ±5 f | ±3–8 f | Vary the offset boundary to boundary. A constant offset is a template. |
| `max_same_run` | 2 | 1–3 | Consecutive boundaries of the same type before you must change device. |
| `hard_cut_reserve` | 0.30 | 0.25–0.50 | Fraction of boundaries deliberately left straight, held for snaps and topic changes. |
| `incoming_fade` | 4 f (0.13 s) | 3–5 f | Published anti-double-voice default. 0 f only on a transient. |
| `outgoing_dip` | −3 dB | 0 to −6 dB | Across the overlap window only, back to unity at the picture cut. |
| `one_direction_per_boundary` | true | — | Never stack a J and an L at the same cut. |
| `ambience_bed` | continuous | — | One room-tone bed under the whole sequence. Overlaps are only safe on a shared floor. |
| `max_lead` | 75 f (2.5 s) | — | Beyond this it stops being a split edit and becomes an audio-led montage. |

## Reproduction prompt

```
Apply a split-edit cadence to the dialogue sequence between {{SEQ_IN}} and
{{SEQ_OUT}} (seconds, 30fps). Do not treat cuts one at a time - plan the
whole sequence first.

1. TABULATE every picture cut in the range. For each, note the speaker
   before and after, and label the beat: NORMAL (a handover), SNAP (an
   interruption, a punchline, a topic change), or LOCATION (the scene or
   place changes).
2. ASSIGN a device per boundary, top to bottom:
   - every SNAP boundary stays a STRAIGHT cut. Do not split these.
   - every LOCATION boundary becomes a J cut led by AMBIENCE, lead 30
     frames.
   - the remaining NORMAL boundaries alternate J and L so that no more
     than 2 consecutive boundaries use the same device, and so that
     straight cuts make up about 30% of the sequence overall.
3. ASSIGN an offset per split boundary: J cuts 9 frames +/- 5, L cuts 15
   frames +/- 5. Vary them - do not write the same number twice in a row.
   Never exceed 75 frames. Never place a J and an L at the same boundary.
4. IMPLEMENT each split by moving the AUDIO edit only. The picture cut
   frame does not move, and neither clip's picture is shortened "to make
   room". For a J cut, the incoming audio starts {{LEAD}} frames early AND
   its media offset is pulled back by exactly {{LEAD}} frames so the sound
   heard under the outgoing shot is genuinely the sound that precedes the
   incoming shot's first frame. For an L cut, the outgoing audio's
   duration extends {{TRAIL}} frames past the picture cut, media offset
   unchanged.
5. FADE the newly-overlapping audio: 4 frames up on an incoming J, 4
   frames down on the tail of an L. Optionally dip the other side 3 dB
   across the overlap and return to unity at the picture cut.
6. LAY a single continuous room-tone bed under the whole sequence so no
   overlap exposes a noise-floor step.
7. ACCEPTANCE TEST: (a) recompute the boundary table from the finished
   edit - at every split boundary the audio and picture edits must be at
   least 6 frames apart, and no more than 2 consecutive boundaries share a
   device; (b) play the sequence with your eyes closed - it must sound
   like one continuous overheard conversation, with no doubled voices;
   (c) play it watching - the SNAP boundaries must still snap; (d) if any
   two adjacent offsets are identical, change one.
```

## Execution spec

**HyperFrames (primary).** The project convention — **muted `<video>` plus a separate `<audio>` for its sound** — is precisely the split-edit convention, so a cadence is a table of numbers, authored twice per clip. All times in **seconds**; frames are comments.

```html
<!-- boundary 1 at 12.00: L cut, A's audio trails 15f (0.50s) -->
<video id="s1" src="camA.mp4" muted playsinline class="clip"
       data-start="8.00" data-duration="4.00" data-media-start="61.00" data-track-index="0"></video>
<audio id="s1-aud" src="camA.mp4" data-audio-group="voiceover"
       data-start="8.00" data-duration="4.50" data-media-start="61.00" data-track-index="10"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:4.37,&quot;v&quot;:1},{&quot;t&quot;:4.50,&quot;v&quot;:0}]}]}"></audio>

<video id="s2" src="camB.mp4" muted playsinline class="clip"
       data-start="12.00" data-duration="5.00" data-media-start="102.00" data-track-index="0"></video>
<audio id="s2-aud" src="camB.mp4" data-audio-group="voiceover"
       data-start="12.00" data-duration="5.00" data-media-start="102.00" data-track-index="11"></audio>

<!-- boundary 2 at 17.00: J cut, C's audio leads 9f (0.30s) -->
<video id="s3" src="camA.mp4" muted playsinline class="clip"
       data-start="17.00" data-duration="6.00" data-media-start="140.00" data-track-index="0"></video>
<audio id="s3-aud" src="camA.mp4" data-audio-group="voiceover"
       data-start="16.70" data-duration="6.30" data-media-start="139.70" data-track-index="12"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.13,&quot;v&quot;:1}]}]}"></audio>

<!-- one bed under the whole sequence -->
<audio id="seq-tone" src="assets/sfx/roomtone.wav" data-audio-group="ambience"
       data-start="8.00" data-duration="20.00" data-track-index="15" data-volume="0.06"></audio>
```

Five contract facts that this arrangement depends on:
- **`data-media-start` must move with `data-start` on a J cut**, by exactly the lead. Move only `data-start` and you play the incoming shot's *first-frame* sound early and then run out of sync for the rest of the shot. There is **no automatic waveform sync** in this stack — alignment is the same numbers written twice.
- **Overlapping audio clips must not share `data-track-index`** or lint warns `duplicate_audio_track`. Cycle 10, 11, 12 across the sequence.
- **Every `<audio>` needs an `id`.** An id-less audio element is never mixed and renders silent, with no warning.
- Automation `t` is **clip-local seconds**, and a lane **holds its first value backwards** to the clip start — so a fade-in needs an explicit `{"t":0,"v":0}` point, and a fade-out needs an explicit unity point before it.
- Do not GSAP-tween `volume` on a track that also has a `volume` lane (`audio_volume_double_automation` — the lane wins and the tween is silently ignored).

**Relative timing is expressive but has four silent-zero failure modes.** `data-start="s3 - 0.3"` says the lead directly, but **spaces around the operator are mandatory** (`s3-0.3` parses as an id), an unresolved id resolves to 0 rather than erroring, a target with no resolvable duration lands on its *start*, and a cycle resolves to 0. Author literal seconds for a cadence table; if you use references, `snapshot` and verify.

**ffmpeg — only if the sequence leaves the pipeline.** Slip one incoming audio against picture with `atrim` + `adelay` (milliseconds), as in [[cut-j-audio-leads-picture]]. For a systematic offset across a whole file, use `-itsoffset` once rather than per-event.

**Epidemic Sound.** The continuous bed the overlaps sit on: `SearchSoundEffects { query.term: "room tone interior quiet loop", filter.duration { min: 30000 } }`, in an `ambience` group, never in the `voiceover` carve group — a bed or SFX clip inside the carve group poisons the next re-analysis silently.

**Remotion:** a `<Sequence>` per shot with independently-offset `<Audio>` children; not present in this project.

## Pairs with
[[cut-j-audio-leads-picture]] · [[cut-l-audio-trails-picture]] · [[cut-outpoint-inpoint-alignment]] · [[cut-hard-cut-for-new-information]] · [[sfx-ambience-bridge-across-cut]] · [[pace-cut-density-from-viewer-intent]] · [[cut-continuity-pass]] · [[struct-inverse-pair-teaching]] · [[pace-cross-cut-acceleration]]

## Failure modes
- **Splitting every boundary.** The sequence becomes uniformly soft and there are no hard cuts left to punctuate with. Fix: hold `hard_cut_reserve` at ~30% and put those straight cuts on the snaps.
- **One offset everywhere.** Twelve frames on every J reads as a template applied by a script. Fix: jitter ±5 f and vary the device.
- **Stacking a J and an L at one boundary.** Two ambiences and two voices overlap; the result is mush. Fix: one direction per boundary.
- **Overlapping different room tones.** Without a shared bed the overlap exposes two noise floors and pumps. Fix: lay the ambience bed first, split second.
- **Moving `data-start` but not `data-media-start`.** Early sound that is the wrong sound, then a shot that is out of sync. Fix: shift both by the same amount.
- **Double-voice smear.** Two dialogue tracks at full level through the overlap. Fix: 3–5 frame fades, and a 3 dB dip on the non-featured side.
- **Splitting across an act break or a fade.** A structural boundary means "this ended"; carrying sound over it contradicts the structure. Fix: leave those hard.
- **Known gap:** nothing here validates a cadence. Lint checks two audio conflicts and nothing else; the boundary table and its statistics must be produced by the analysis pass and written into the design document.
