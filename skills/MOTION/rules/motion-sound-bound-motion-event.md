---
id: motion-sound-bound-motion-event
title: Every authored motion event carries a sound event at the same timeline position
skill: motion
type: motion
family: motion-sfx-binding
tags: [skill/motion, type/motion, family/motion-sfx-binding, sfx/motion, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, engine/remotion, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:03:16"
    quote: "So if there's motion happening anywhere in your video but no sound effect on it, then the video feels very empty."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:03:47"
    quote: "Now the peak of my hit sound effect should land exactly on the impact frame of my hand."
research_refs:
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://www.nngroup.com/articles/animation-duration/
  - https://www.mdpi.com/1995-8692/2/2/11
difficulty: medium
detectable_from: transcript+video
---

# Every authored motion event carries a sound event at the same timeline position

## What it is
The motion-library obligation implied by the sound rule: a composition's motion events and its sound events are one list, not two. When you author a tween that qualifies as a transient ([[motion-attention-transient]]), you also author its sound at the same timeline position, with the sound's **loudest sample** — not its file start — on the motion's first frame. [[sfx-unsounded-motion-audit]] states the audit from the sound side; this note is the motion side: the motion-event register, what qualifies, and how the two are bound in the same composition so they cannot drift apart.

The rationale is perceptual: motion of a magnitude the eye reads as an event creates an expectation of a sound. When the sound is missing the viewer does not think "no sound effect" — they think the video is unfinished.

## When to use it
- **On every build**, as the last pass before render: walk the timeline, list the motion events, confirm each has a bound sound or an explicit silent-tier decision ([[motion-silent-motion-tier]]).
- **On every transition** — a covered seam always carries a sound ([[motion-whip-pan-transition]], [[sfx-whoosh-transition-movement-reveal]]).
- **On every primary element entrance** — the first card, title, stat or annotation of a beat.
- **On every impact, slam or shake** ([[motion-camera-shake-impact]], [[motion-impact-frame-quantisation]]).
- **On a scale/punch-in of ≥3%** and on any element that leaves frame at speed.
- **Not** on drift, idle pulses, ambient loops, or the 2nd and 3rd members of a staggered group — those are tiered out deliberately, which is a decision you record rather than an omission.

## How to recognise it in a reference video
- **Build both lists and diff them.** Video events: `ffmpeg -i ref.mp4 -vf "select='gt(scene,0.15)',metadata=print:file=/tmp/v.txt" -f null -`. Audio events: `ffmpeg -i ref.mp4 -af "silencedetect=n=-38dB:d=0.08,ametadata=print:file=/tmp/a.txt" -f null -` plus a transient scan (`astats=metadata=1:reset=1` per 0.1 s window). A motion timestamp with no audio transient within ±0.1 s is an unsounded event.
- **Judge magnitude before calling it a fault.** Only events over the transient threshold (≥1.5% of frame height in ≤4 frames, or ≥3% scale, or ≥10% of frame area luminance change) are obliged to carry sound.
- **Check alignment, not just presence.** The sound's peak should sit within **1 frame** of the motion's first frame. ITU-R BT.1359-1 puts detectability at about **+45 ms audio lead / −125 ms lag** and acceptability at **+90 / −185 ms** — at 30 fps that is at most **1 frame early, 1–3 frames late**, never more.
- **Count grouped events.** Three elements staggered over 0.3 s with **one** sound is correct practice, not a miss.
- **Look for the aesthetic layer.** Well-sounded motion often has a quiet air/whoosh under a body movement, a camera zoom, or a graphic drift at **−18 to −22 dB** — audible only in the mix ([[sfx-air-on-micro-movement]]).
- **Levels:** motion SFX sit at **−12 to −15 dB** against dialogue at **0 to −3 dB** and music at **−20 to −25 dB**. A motion SFX louder than the dialogue is a fault.
- **The negative case matters:** an intentionally silent motion (a slow reveal in a quiet beat, with music carrying it) is a legitimate style choice. Log it as `deliberate-silence` rather than as a miss when the music is doing the work.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `bind_threshold_displacement` | 1.5% frame h in ≤4 f | — | Below this, no obligation. |
| `bind_threshold_scale` | 1.03 | — | 3% linear scale in ≤6 f. |
| `bind_threshold_area` | 10% frame area | — | Luminance/coverage events (scrims, flashes, full-frame overlays). |
| `align_tolerance` | ±1 f | −3 f to +1 f | Late is more forgiving than early (ITU-R BT.1359-1). |
| `sfx_level` | −13 dB | −12 to −15 dB | Relative to 0 dB dialogue. As `data-volume` against a 1.0 dialogue bus: ≈0.22. |
| `air_level` | −20 dB | −18 to −22 dB | Aesthetic layer under drifts and camera moves. |
| `one_sound_per_group` | true | — | A staggered group is one event. |
| `group_window` | 0.36 s | ≤0.5 s | Motion inside this window shares one sound. |
| `max_sfx_per_10s` | 5 | 3–8 | Above this, tier events out instead of adding sounds. |
| `min_repeat_gap` | 10 s | 8–20 s | Same SFX file must not recur inside this gap (use pitch/duration/reverb variants). |
| `transient_offset_in_file` | measured | 0–0.30 s | Most whoosh/hit files have 20–150 ms of pre-roll; back-time with `data-media-start`. |

## Reproduction prompt

```
Bind a sound event to every qualifying motion event in this composition.

STEP 1 - REGISTER. Enumerate every tween position on the timeline. For each,
record: time in seconds, target, property, magnitude (as % of frame height, or
scale delta, or % of frame area), and whether it is the first member of a
staggered group. This register is the deliverable; keep it as a comment block
at the top of the animation script.

STEP 2 - QUALIFY. Mark an event BOUND if displacement >= 1.5% of frame height
within 4 frames, or scale delta >= 3% within 6 frames, or it changes >= 10% of
frame area in luminance. Everything else is SILENT by decision, not omission.
A staggered group is one BOUND event (its first member).

STEP 3 - SOURCE. For each BOUND event choose the family: whoosh for travel and
transitions, hit/impact for slams and shakes, tick/click for small discrete
appearances, air for slow camera or drift. Never reuse the same file within
10s; vary by pitch, duration or reverb instead.

STEP 4 - PLACE. Find the loudest sample of the chosen file. Set the audio
clip's data-start so that transient lands on the motion's first frame, using
data-media-start to trim the file's pre-roll. Do not align file starts. Every
audio element needs an id. Put SFX on track index 12+, in the "sfx" audio
group, at -12 to -15 dB relative to a 0 dB dialogue bus.

STEP 5 - VERIFY. Render, then extract audio and diff the two event lists. Every
BOUND motion time must have an audio transient within 1 frame. Report any
event where the audio leads the picture by more than 1 frame - early is worse
than late.

ACCEPTANCE TEST: zero BOUND events without a transient; zero transients more
than 1 frame early; total SFX count <= 5 per 10s; no file repeated inside 10s.
```

## Execution spec

**HyperFrames.** Motion and sound are authored in the same file, so keep them adjacent — the register as a comment, the tween and the audio clip written together.

```html
<!-- SFX bus: one chain and one fader for every motion sound -->
<hf-audio-group id="sfx" data-label="Motion SFX" data-volume="0.9"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Clear the voice band floor&quot;,&quot;params&quot;:{&quot;frequency&quot;:120}},
    {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;limit&quot;:-3}}]}"></hf-audio-group>

<!-- event: card entrance at 12.40s. Whoosh transient at 0.08s into the file. -->
<audio id="sfx-card-in" src="assets/sfx/whoosh-soft.wav" data-audio-group="sfx"
       data-start="12.32" data-duration="0.7" data-media-start="0.0"
       data-track-index="12" data-volume="0.22"></audio>
```

```js
/* MOTION EVENT REGISTER
   t=12.40  #stat-card   y 27->0        2.5% h / 6f   BOUND  sfx-card-in
   t=12.52  #stat-label  y 27->0        2.5% h / 6f   grouped (no sound)
   t=18.00  #camera      impact kick    1.7% h / 1f   BOUND  sfx-hit-01
   t=20.00  #still-a     scale 1->1.024 drift          SILENT (tier 3)          */
tl.fromTo(["#stat-card", "#stat-label"],
  { y: 27, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.4, ease: "power3.out", stagger: { each: 0.12 } }, 12.40);
```

Contract points that bind this:
- **Alignment is done with `data-start` + `data-media-start`, both in seconds.** `data-start = motion_time − transient_offset_in_file`, and `data-media-start` trims dead pre-roll. There is no frame unit; author seconds and keep the maths in a comment.
- **Every `<audio>` needs an `id`** — an id-less audio element *"is never mixed → silent render"*, with no error.
- Two `<audio>` sharing a `data-track-index` **and** overlapping in time raise `duplicate_audio_track` (warning) — give simultaneous SFX different indices (12, 13, 14…).
- `data-volume` is static gain (1 = 0 dB, max 3.98 = +12 dB). A GSAP `volume` tween is **absolute** and replaces it; a `volume` **automation lane** beats the tween (`audio_volume_double_automation`). Pick one mechanism per track.
- Use an `<hf-audio-group>` when the same treatment belongs on many SFX — *"a compressor cannot ride a sequence it only hears a third of."* Bus automation `t` is **composition time**; clip automation `t` is **clip-local**, and a lane's first value is held backwards to the clip start.
- JSON attributes must be double-quoted with `&quot;` escaping, or `scripts/carve.mjs` cannot see them and will silently overwrite work it could not read.
- If the composition is modular, keep audio at the **host root** so playback survives scene cuts; sub-comp timelines cannot animate host-root elements, but audio placement is markup, not animation, so it is unaffected.

**ffmpeg — the audit pass.**

```bash
# motion events
ffmpeg -i render.mp4 -vf "select='gt(scene,0.15)',metadata=print:file=/tmp/v.txt" -f null -
# audio transients: per-100ms peak level, then diff against /tmp/v.txt
ffmpeg -i render.mp4 -af "astats=metadata=1:reset=3,ametadata=print:key=lavfi.astats.Overall.Peak_level:file=/tmp/a.txt" -f null -
# where silence sits, to catch whole unsounded regions
ffmpeg -i render.mp4 -af "silencedetect=n=-38dB:d=0.08" -f null - 2>&1 | grep silence_
```

**Epidemic Sound.** One search per family, then bind:
- travel: `SearchSoundEffects { query: { term: "soft whoosh ui transition" }, filter: { tagSlugs: { matchType: "ANY", values: ["swooshes--whoosh"] }, duration: { max: 2000 } } }`
- impact: `... values: ["designed--boom"] , duration: { max: 4000 }`
- discrete appearance: `query: { term: "ui tick click pop short" }, duration: { max: 800 }`
Then `DownloadSoundEffect` and place per the markup above. Vary a reused file with `pitch`/duration/reverb rather than downloading a near-duplicate.

**Remotion:** `<Audio startFrom={…}>` placed at the same frame as the animation's start, with the file's pre-roll trimmed — concept only.

## Pairs with
[[sfx-unsounded-motion-audit]] · [[motion-silent-motion-tier]] · [[motion-impact-frame-quantisation]] · [[motion-attention-transient]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-air-on-micro-movement]] · [[motion-camera-shake-impact]] · [[motion-instant-appearance-sfx-justified]] · [[sfx-density-fatigue-audit]]

## Failure modes
- **File start aligned instead of transient.** Most whoosh and hit files carry 20–150 ms of pre-roll, so the sound lands 1–5 frames late and the motion feels rubbery. Correction: measure the peak, back-time `data-start`.
- **Audio leading the picture.** Early is perceptually worse than late (+45 ms detectability vs −125 ms). Correction: never more than 1 frame early.
- **One sound per element in a staggered group.** Three whooshes in 0.36 s is the SFX-overload mistake. Correction: one sound on the first member.
- **Sounding drift.** A 4 px/s Ken-Burns push does not need a whoosh; putting one there is what "whoosh on everything" means. Correction: tier it silent ([[motion-silent-motion-tier]]).
- **SFX louder than dialogue.** Correction: −12 to −15 dB, checked on the bus, not by ear on one clip.
- **The same file five times.** Named as mistake number three in the source: repetition is heard even when individual placements are correct. Correction: 10 s minimum gap and pitch/duration variants.
- **Register kept outside the composition.** A spreadsheet of intended sounds drifts from the file within one revision. Correction: keep the register as a comment block beside the tweens.
- **Known gap:** there is no automatic motion-event extractor in this stack — the register is hand-built from the tween list, and the ffmpeg scene-detect audit only catches events large enough to move the frame-difference metric. Small but qualifying element moves must be enumerated from the source, not from the render.
