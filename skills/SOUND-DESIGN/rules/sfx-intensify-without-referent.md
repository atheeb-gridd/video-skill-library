---
id: sfx-intensify-without-referent
title: The aesthetic layer's licence — invented sound may amplify, never inform
skill: sound-design
type: sfx
family: aesthetic-sfx
tags: [skill/sound-design, type/sfx, family/aesthetic-sfx, sfx/aesthetic, layer/sfx, layer/design, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:02:17
    quote: "So we basically use sound effects to enhance the visuals. Sounds that don't even exist in the real world, but they help a lot in intensifying a scene."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:02:25
    quote: "Risers, impacts, hits, whooshes."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:06:32
    quote: "Aesthetic sound effects — cinematic hits, rises, textures, plus a whoosh or air sound on body movement, a camera zoom, even an eye roll."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:09:11
    quote: "Sound effect overload — a tick-tick-tick every other second in every other frame tires the viewer's brain"
research_refs:
  - https://www.epidemicsound.com/sound-effects/
  - https://en.wikipedia.org/wiki/Diegesis
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: audio
---

# The aesthetic layer's licence — invented sound may amplify, never inform

## What it is
Layer 4 is defined by a negative: these are sounds with **no real-world referent**. Nothing in the world makes the noise a riser makes. The source's phrasing — *"sounds that don't even exist in the real world, but they help a lot in intensifying a scene"* — states both the licence and its limit. The licence is that you may invent a sound where reality provides none. The limit is that the invented sound's only job is **amplification**: making what the picture is already doing land harder.

That limit is the decision rule this note exists to make operational, because the aesthetic group is the one of the three styles with no external check. A diegetic sound is checked against the object on screen; a motion sound is checked against the movement. An aesthetic sound is checked against nothing but taste, which is why it is the group that gets overused, and why the source's first named mistake — sound-effect overload — is almost always an aesthetic-layer failure.

The rule that supplies the missing check: **an aesthetic sound may not carry information.** If muting it changes what the viewer *knows* rather than what they *feel*, it was doing a diegetic or a motion job, and it belongs in that group at that group's level and timing.

**Style.** Filed `sfx/aesthetic`, and the two styles this note used to also carry are the test itself: if muting the cue changes what the viewer *knows* about an object it was diegetic ([[sfx-diegetic-action-inventory]]), and if it was describing a movement it was motion ([[sfx-motion-sound-selection]]).

## When to use it
Route a candidate sound with three questions, in order. The first "yes" wins, and only the third yes reaches this note.

1. **Does the thing on screen exist in the world?** A phone, a door, a keyboard, a footstep, a gunshot. → Diegetic group. Fetch the real sound, place it on the action frame ([[sfx-diegetic-action-inventory]], [[sfx-real-vs-invented-sound-rule]]).
2. **Did something move or change on screen?** A cut, a transition, a title entering, a graphic traversing, a scale punch. → Motion group. Sound the movement, anchored to its velocity peak ([[sfx-motion-pass-two-rules]], [[sfx-peak-at-motion-midpoint]]).
3. **Neither — but this moment should feel bigger than it looks.** → Aesthetic group, and only now is invention licensed.

Concrete aesthetic occasions, from the source and from practice:
- A statement or conclusion that must land as important, with no motion to hang a sound on → a cinematic hit ([[sfx-cinematic-hit-emphasis]]).
- A build toward a payoff → a riser ([[sfx-riser-anticipation-build]], gated by [[sfx-riser-credibility-budget]]).
- A section that needs unease with nothing happening on screen → a texture or drone bed.
- Sub-perceptual accents the source names explicitly: air on body movement, a whoosh on a camera zoom, even an eye roll — *"the viewer won't notice them but will feel them"* ([[sfx-felt-not-noticed]], [[sfx-air-on-micro-movement]]).

**Not** where a real sound exists and was merely inconvenient to fetch. **Not** to cover an edit you are unsure about — an aesthetic sound over a bad cut makes the cut louder, not better. **Not** twice in one beat.

## How to recognise it in a reference video
- **The mute test, per event.** Mute one effect and ask what changed. If the answer is "I no longer know that the phone rang", it was diegetic. If it is "the reveal feels smaller", it was aesthetic and correctly placed. If it is "nothing", it was noise.
- **No visual referent on screen at the event frame.** The defining signature: a transient or a swell with nothing in frame that could have made it.
- **Level band.** Aesthetic events sit at the bottom of the SFX band — roughly **−15 to −18 dB relative to dialogue** where diegetic and motion effects sit at −12 to −15 ([[sfx-layer-volume-targets]]). An aesthetic sound you can name while watching at normal attention has been placed too loud.
- **Event vs duration split.** The families divide cleanly: *event* sounds (hit, boom, impact, sub drop) are under 150 ms of attack with a decaying tail; *duration* sounds (riser, texture, drone, long whoosh) occupy 1 s or more with a moving envelope. A beat can carry **one of each** and no more; two duration sounds at once is the mud signature.
- **Density.** Count aesthetic events per minute and check the gaps. Healthy: one aesthetic event per 12–20 s in mid-form, per 6–10 s in short-form. A gap under 4 s between two aesthetic events, repeated, is the overload the source names.
- **Repetition.** The same boom three times in ninety seconds stops being emphasis and becomes a tic.
- **For the per-family acoustic signatures** — what a boom, a braam, a swish or a sub drop actually looks like in a spectrum, and how long each really is — use [[sfx-synthetic-family-catalogue]]; this note does not repeat it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Aesthetic events per minute — long-form | 3–5 | 2–6 | One per 12–20 s. |
| Aesthetic events per minute — short-form | 6–10 | 4–12 | One per 6–10 s; the format's promise is higher stimulation ([[struct-stimulation-budget]]). |
| Minimum gap between aesthetic events | 4 s | ≥ 3 s | Below this they read as texture, and individually stop landing. |
| Simultaneous duration sounds | 1 | 1 | A riser and a texture together cancel. Never two. |
| Events per beat | 1 event + 1 duration | — | The maximum a single moment can carry legibly. |
| Level, aesthetic | −15 to −18 dB rel. dialogue | −12 … −20 | Deliberately below the diegetic/motion band. |
| Information test | must fail | — | If muting it removes knowledge, it is not an aesthetic sound. Re-route it. |
| Distinct files per family per video | ≥ 3 | 2–6 | Or one file varied by pitch ratio and length ([[sfx-pitch-ratio-point-six]]). |
| Low-transient budget | 1 per bar | ≤ 2 | Two sub-heavy events in a bar is mud regardless of level. |

## Reproduction prompt
```
Decide whether a moment is licensed to carry an invented sound, then place it.

INPUT: a moment {{T}} in composition seconds and one clause saying what it should
do to the viewer.

1. ROUTE IT. Answer in order and stop at the first yes:
   a. Does something on screen exist in the real world and make a sound?
      -> DIEGETIC. Fetch the real sound; place its transient on the action frame.
         Stop; this note does not apply.
   b. Did something move, cut, enter or change scale?
      -> MOTION. Sound the movement; anchor to its velocity peak; match the
         sound's length to the movement's length. Stop.
   c. Neither, and the moment should simply feel bigger than it looks?
      -> AESTHETIC. Continue.
2. APPLY THE INFORMATION TEST BEFORE FETCHING. State what the viewer would lose
   if the sound were muted. If the answer contains any fact - that something
   arrived, opened, failed, connected - the sound is doing a diegetic or motion
   job. Re-route it to (a) or (b). An aesthetic sound may only change how the
   moment FEELS.
3. CHOOSE ONE EVENT SOUND AND AT MOST ONE DURATION SOUND for this beat.
   Event: hit / boom / impact / sub drop, for a landing.
   Duration: riser / texture / long whoosh, for a build or a mood.
   Never two duration sounds. Never two low-transient events inside one bar.
4. CHECK THE BUDGET before placing. No other aesthetic event within 4 s. No more
   than 3-5 per minute in long-form, 6-10 in short-form. If over budget, remove
   the weaker moment rather than lowering both.
5. PLACE AND LEVEL. Event sound: transient on {{T}}. Duration sound: resolve on
   {{T}} (see the riser note). Set data-volume so the effect sits 15-18 dB below
   dialogue - the bottom of the SFX band, not the middle.
6. ACCEPTANCE TEST: (a) mute it and the moment feels smaller but nothing is
   unknown; (b) at normal attention on one pass you cannot name the sound;
   (c) it does not mask the syllable it lands on; (d) no other aesthetic event
   within 4 s.
```

## Execution spec

**Epidemic Sound.** The aesthetic families and their verified live tag slugs:

| Job | Tag slug | Catalogue size | Notes |
|---|---|---|---|
| Build | `designed--riser` | 478 | 0.97 s – 113 s; term refinements `clean`, `suspense`, `sub`, `reverse`. |
| Landing / emphasis | `designed--boom` | — | Titles carry `Low Hit`, `Impact`, `Dark`, `Cinematic`. |
| Physical impact | `fight--impact` | — | Use when the moment is a blow rather than an abstraction. |
| Air / traverse | `swooshes--whoosh` | 975 | Titles carry `Deep Reversed`, `Wide`, `Dry`, `Air`, `Warp`. |

```json
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["designed--boom"] },
              "duration": { "min": 1000, "max": 8000 } },
  "query": { "term": "cinematic low hit" },
  "sort": { "by": "POPULARITY", "order": "DESCENDING" }, "first": 12 }
```
Two verified cautions. There is **no `braam` tag** — an LLM will offer the word confidently and the catalogue does not index it; `designed--boom` plus a `brass` term is the real route ([[sfx-vocabulary-llm-expansion]]). And the `duration` filter measures the **delivered file**, not the audible event: only 14 of the 975 whooshes fall inside a 200–1200 ms window because most ship with silence and tail. Keep the window wide, trim with `data-media-start`.

**Hyperframes.** Aesthetic effects get their own group so they can be levelled and audited as a set, and so they never contaminate the `voiceover` carve group:
```html
<audio id="sfx-aes-hit-02" src="assets/sfx/boom-low.wav"
       data-audio-group="sfx-aesthetic"
       data-start="42.18" data-duration="1.6" data-media-start="0.03"
       data-track-index="13" data-volume="0.32"></audio>
```
`data-volume="0.32"` is roughly −10 dB on the clip's own fader; the audible band is then set by the group. Reach for `<hf-audio-group id="sfx-aesthetic">` with one `data-volume` and, if needed, a shared `limiter` node last in the chain, so the whole aesthetic layer moves together — *"one chain, one fader, one automation clock for every member"*. Do **not** put SFX in the carve group: the carve group must be voices only, or the next re-analysis is poisoned silently.

**ffmpeg.** Density auditing is a measurement, not a feeling:
```bash
# per-frame peak trace; count transients >= 8 dB above their 10-frame neighbourhood
ffmpeg -i mix.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
```

**Remotion.** Same routing logic; nothing engine-specific. Portability note only.

## Pairs with
[[sfx-felt-not-noticed]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-riser-anticipation-build]] · [[sfx-riser-credibility-budget]] · [[sfx-bass-drop-under-impact]] · [[sfx-real-vs-invented-sound-rule]] · [[sfx-diegetic-action-inventory]] · [[sfx-motion-pass-two-rules]] · [[sfx-density-fatigue-audit]] · [[struct-stimulation-budget]] · [[sfx-layer-volume-targets]] · [[sfx-synthetic-family-catalogue]] · [[sfx-three-types-classification]] · [[sfx-air-on-micro-movement]]

## Failure modes
- **Using an invented sound where a real one exists.** The source's own counter-example register — a water sound under a page turn — reads as wrong even to viewers who cannot say why. Route the question before fetching.
- **An aesthetic sound carrying information.** A "connection made" swell that is the only signal the connection was made is a diegetic sound wearing an aesthetic costume, and it will be too quiet to do its job at aesthetic level.
- **Two duration sounds at once.** Riser plus texture plus a bed that is already building: three things asking for patience, none of them audible.
- **Aesthetic effects at motion-layer level.** Loud enough to be named is loud enough to be noticed, and the whole register depends on not being noticed.
- **Overload.** The source's first named mistake. It is a density failure, invisible per-event and obvious across a minute — count, do not listen.
- **Repetition of one file.** Three identical booms is a tic. Rotate files or vary by pitch and length.
- **Covering a weak cut.** An aesthetic sound over an edit that does not work amplifies the problem, exactly as advertised.
- **Known gap:** nothing in the stack measures density, level bands or family repetition. This audit is an explicit pass, and the render that verifies it must run on a browser-capable host.
