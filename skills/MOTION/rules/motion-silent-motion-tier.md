---
id: motion-silent-motion-tier
title: Tier every motion event — sounded, covered, or deliberately silent
skill: motion
type: motion
family: motion-sfx-binding
tags: [skill/motion, type/motion, family/motion-sfx-binding, sfx/motion, sfx/aesthetic, layer/sfx, layer/music, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:04:17"
    quote: "\"So should I slap a whoosh on every single motion?\" You don't put a whoosh on everything."
research_refs:
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://www.nngroup.com/articles/animation-duration/
  - https://www.mdpi.com/1995-8692/2/2/11
difficulty: medium
detectable_from: transcript+video
---

# Tier every motion event — sounded, covered, or deliberately silent

## What it is
The counterweight to [[motion-sound-bound-motion-event]], delivered in the source as a skit objection. Motion invites a sound; it does not oblige one. The workable form is a three-tier classification applied to the motion-event register, so that "which motions get sounds" is a decision with a rule behind it instead of a reflex:

- **Tier 1 — sounded.** The event gets its own sound with its transient on the event's first frame. Transitions, primary entrances, impacts, exits at speed, anything the structure depends on.
- **Tier 2 — covered.** The event is real but is absorbed by a sound that already exists: the first member of its staggered group, the transition it sits inside, the music hit it lands on, or the ambience under it. No new file.
- **Tier 3 — silent.** Drift, idle pulses, ambient loops, secondary micro-moves, anything under the transient threshold. Sounding these is exactly what "a whoosh on everything" means, and it produces the fatigue the source names as the first sound-design mistake.

## When to use it
- **Immediately after building the motion-event register** and before sourcing any audio — tiering first is what keeps the SFX count down.
- **When a beat has three or more simultaneous animations** and you must choose which one speaks.
- **When the SFX count in a 10-second window exceeds ~5** — the fix is to demote events, not to lower volumes.
- **When the music is already doing the work** — a drop, a beat, a swell — demote the visual event to Tier 2 and let the music carry it ([[sfx-music-hard-stop]]).
- **In a quiet, intimate or authority register**, where a dense SFX layer contradicts the tone ([[motion-format-promise-motion-budget]]).

## How to recognise it in a reference video
- **Count SFX per 10 s and compare against motion events per 10 s.** Competent retention editing runs roughly **3–6 SFX per 10 s** against **5–10 motion events** — a ratio near **0.5–0.7**, not 1.0. A ratio at or above 1.0 is overload; below ~0.25 the video will feel hollow.
- **Watch a group entrance frame by frame.** One sound at the first arrival and silence for the rest is Tier 2 in action.
- **Listen under transitions.** A whip or leak usually carries one whoosh; any element entering inside that whoosh's decay is intentionally covered.
- **Check the drifts.** Slow pushes on stills should be silent. A whoosh on a 6-second Ken Burns move is a diagnostic of an over-sounded edit.
- **Check idle/ambient motion.** Looping glows, particle drift, breathing scale: silent in every competent example.
- **Repetition test.** Log the SFX by ear or by spectrum: the same file three times within 10 s is the source's mistake number three, and often indicates that Tier 2 was never used.
- **Register the ceiling.** If any 1-second window contains 3+ distinct SFX transients, log it — that is the fatigue threshold, and the video will tire a viewer inside 2–3 minutes.
- **Transcript cross-check:** Tier 1 events almost always coincide with a stressed word, a number, or a section boundary. A sounded event with no verbal correlate is usually a template sound.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `tier1_share` | 40% of events | 25–55% | Of all qualifying motion events. |
| `tier2_share` | 35% | 25–50% | Grouped, covered, or music-carried. |
| `tier3_share` | 25% | 15–40% | Drift and idle motion. |
| `sfx_per_10s` | 4 | 3–6 | Hard ceiling 8; above that, demote. |
| `sfx_to_motion_ratio` | 0.6 | 0.4–0.8 | Sounded events ÷ qualifying motion events. |
| `max_transients_per_1s` | 2 | 1–3 | 3+ in one second is fatigue. |
| `group_cover_window` | 0.36 s | 0.25–0.6 s | Motion inside this window after a Tier 1 sound is covered. |
| `transition_cover_window` | 0.6 s | 0.4–0.9 s | Elements entering inside a transition's whoosh decay are covered. |
| `music_cover_window` | 0.25 s | 0.15–0.4 s | Motion landing on a beat or drop is covered by the music. |
| `min_repeat_gap` | 10 s | 8–20 s | Same file. Vary pitch / duration / reverb otherwise. |
| `tier3_air_option` | off | off/on | A −20 dB air bed under a long camera move is Tier 2.5: allowed once or twice per video. |
| `register_required` | true | — | Tier must be recorded per event, not inferred later. |

## Reproduction prompt

```
Tier every event in the motion-event register before sourcing any audio.

RULES, applied in order:
1. TIER 1 (own sound): scene transitions; the first member of any staggered
   group; impacts, shakes and slams; an element leaving frame at speed; the
   primary entrance of a beat (the element the line is about); any event whose
   magnitude exceeds 6% of frame height in under 4 frames.
2. TIER 2 (covered, no new file): every non-first member of a group; anything
   starting within 0.36s after a Tier 1 sound; anything inside a transition's
   0.6s whoosh decay; anything landing within 0.25s of a music beat or drop;
   anything happening while ambience of the same character is present.
3. TIER 3 (silent): drift under 0.6% of frame height per second; idle or
   looping motion; scale changes under 3%; secondary decorative moves; motion
   under a spoken line where a sound would compete with the voice.

BUDGET. Cap Tier 1 at 4 sounds per 10 seconds (hard ceiling 8) and at 2
transients per any 1 second. If the cap is exceeded, demote the lowest-
importance Tier 1 events to Tier 2 - do NOT solve it by lowering volume.
Never reuse a file inside 10s; vary pitch, duration or reverb instead.

RECORD. Write the tier next to each event in the register comment block, with
one-word justification (group / transition / music / drift / idle). An
unlabelled event is a bug.

ACCEPTANCE TEST: sounded-events / qualifying-events lands in 0.4-0.8; no
1-second window contains 3+ SFX transients; no file repeats inside 10s; and on
a mix playback pass every Tier 1 sound is audible under dialogue at -12 to -15
dB without any of them competing with a spoken word.
```

## Execution spec

**HyperFrames.** Tiering is bookkeeping plus what you *don't* place; the engine-side work is the register and the bus.

```js
/* MOTION EVENT REGISTER — tiered
   t=11.73 leak transition        T1  sfx-leak-air     (transition)
   t=12.40 #stat-card  y 27->0    T1  sfx-card-in      (primary entrance)
   t=12.52 #stat-label y 27->0    T2  covered          (group, 0.12s after T1)
   t=12.64 #stat-chip  y 27->0    T2  covered          (group)
   t=13.10 #annot-circle draw     T2  covered          (inside card whoosh decay)
   t=14.00 #still-a scale drift   T3  silent           (drift 0.4%/s)
   t=18.00 #camera impact kick    T1  sfx-hit-01       (impact)                */
```

Contract points that bind this:
- Tier 2 and Tier 3 are implemented by **placing no `<audio>` clip**. There is no "muted SFX" state worth authoring; `data-hidden` on an audio element drops it from the mix in both preview and render and is the right tool only when you want to keep a candidate around for A/B ([[sfx-ab-audition-candidates]]).
- Keep all Tier 1 sounds in one `<hf-audio-group id="sfx">` so a single fader and limiter govern the layer — *"one chain, one fader, one automation clock for every member."* Demoting an event then never changes the mix balance.
- Two overlapping `<audio>` on the same `data-track-index` raise `duplicate_audio_track`; with a tiered register you rarely overlap, which is itself a signal you tiered correctly.
- The music bed under all this should be carved, not ducked: `data-fx-carve` on the **bed** with `sources` naming the **voiceover group**, `strength` default `0.25` (≈6 dB dip in three bands). Carve settings never go on a voice track, and `data-fx-carve` is clip-only (never on a bus).
- Do not solve density by lowering `data-volume` — a quiet cluttered layer is still cluttered, and the limiter will pump.

**ffmpeg — density audit.**

```bash
# transient census: per-0.5s peak level; count entries above -20 dBFS per 10s window
ffmpeg -i render.mp4 -af "astats=metadata=1:reset=15,ametadata=print:key=lavfi.astats.Overall.Peak_level:file=/tmp/peaks.txt" -f null -
# motion census for the ratio
ffmpeg -i render.mp4 -vf "select='gt(scene,0.15)',metadata=print:file=/tmp/motion.txt" -f null -
```
Ratio = sounded events ÷ qualifying motion events; target 0.4–0.8.

**Epidemic Sound.** Tier 1 only. Before downloading a second similar file, use `SearchSimilarToSoundEffect` on the one you have and prefer a *variant* (different pitch/length) over a near-duplicate — repetition is audible even when placement is right.

**Remotion:** the same register as a typed array with a `tier` field; only `tier === 1` entries emit an `<Audio>` — concept only.

## Pairs with
[[motion-sound-bound-motion-event]] · [[sfx-placement-discipline]] · [[sfx-density-fatigue-audit]] · [[sfx-unsounded-motion-audit]] · [[motion-attention-transient]] · [[sfx-music-hard-stop]] · [[sfx-air-on-micro-movement]] · [[motion-format-promise-motion-budget]] · [[sfx-silence-as-pattern-interrupt]]

## Failure modes
- **No tiering at all.** Either every motion gets a whoosh (fatigue inside 2–3 minutes) or the sound pass is done by mood and half the structural events are silent. Correction: tier the register before sourcing.
- **Sounding every member of a group.** Correction: Tier 1 the first member only; the rest are covered by definition.
- **Solving overload with volume.** Five quiet whooshes still read as five events and still tire the viewer. Correction: demote, don't attenuate.
- **Sounding drift.** Correction: anything under 0.6% of frame height per second is Tier 3, full stop.
- **Sounding motion under a spoken word.** The SFX competes with the voice and both lose. Correction: Tier 2 it, or move the motion 4–6 frames off the stressed syllable.
- **Repeating one file.** Correction: 10 s gap, or pitch/duration/reverb variant.
- **Tier decisions made in the mix rather than in the register.** They get lost on the next revision. Correction: tier labels live in the composition beside the tweens.
- **Known gap:** the tier shares and the 0.4–0.8 ratio are calibrations from measuring retention-style edits, not published standards; the fatigue mechanism is asserted in the source video and is not backed here by a controlled study. The AV-sync tolerance is the only hard number in this family (ITU-R BT.1359-1).
