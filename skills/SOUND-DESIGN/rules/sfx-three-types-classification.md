---
id: sfx-three-types-classification
title: The three styles by need — classify the moment before you search for the sound
skill: sound-design
type: sfx
family: sfx-styles
tags: [skill/sound-design, type/sfx, family/sfx-styles, layer/sfx, layer/ambience, layer/design, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:03:47
    quote: "So mainly, in my opinion, three kinds of sound effects exist, based on their need in the video. Diegetic, motion and aesthetic sound effects."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:03:54
    quote: "And the most important out of these is diegetic sound effects. Which are the sound effects that exist pretty prominently in the real world. Like a phone ringing, a gunshot. Without these your video just can't feel real."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:04:10
    quote: "Now when there's motion happening, our brain expects that a sound is going to come. But when that sound doesn't come, the video feels really hollow, really fake."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:06:48
    quote: "Your viewer won't notice that you placed a sound effect there, but they will feel it."
research_refs:
  - https://en.wikipedia.org/wiki/Diegesis
  - https://en.wikipedia.org/wiki/Sound_effect
  - https://en.wikipedia.org/wiki/Sound_design
  - https://en.wikipedia.org/wiki/Voice-over
  - https://en.wikipedia.org/wiki/Transient_(acoustics)
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - mcp://Epidemic_sounds/SearchSoundEffects (tag slugs probed live, 2026-08-28)
difficulty: medium
detectable_from: transcript+video
---

# The three styles by need — classify the moment before you search for the sound

## What it is
The organising taxonomy of this whole library, the router for every other SFX note in this vault, and the one decision that comes before every search. Every sound effect in a video is exactly one of three styles, sorted by **why it is there**, not by what it sounds like:

1. **Diegetic** — a sound the world on screen would genuinely make, belonging to something visible and prominent: a phone ringing, a gunshot, a door, a keyboard, a page turning, a laptop closing. *"Without these your video just can't feel real."* Most important of the three, because its absence is a hole rather than a missed opportunity. **Required** wherever the event is visible and prominent.
2. **Motion** — a sound bound to something *moving* that has no real-world referent: a transition, a motion-graphics animation, a text effect. The brain issues a prediction when it sees movement, and *"when that sound doesn't come, the video feels really hollow, really fake."* **Expected**: the absence is what is noticed, as hollowness.
3. **Aesthetic** — a sound bound to no object and no visible motion, placed for feeling alone: cinematic hits, rises, textures, plus air on a body move, a camera zoom, even an eye roll. *"Your viewer won't notice that you placed a sound effect there, but they will feel it."* **Optional and felt, not noticed.**

The classification is not decoration: it is a **decision procedure**. Classify the moment first and you know whether a sound is required, expected, optional or unwanted, at what level it sits, which frame it lands on, which note owns it, and — the part people skip — whether it should be there at all. An unclassified effect is an unjustified effect.

**Where this sits relative to the film-sound literature**, because the words collide. The formal axis is *source*: diegetic sound comes from inside the story world and characters could hear it; non-diegetic is *"heard by the audience, but not by the characters"* — score, voice-over narration, and *"sound effects added purely for dramatic effect."* By that measure the creator's **motion** and **aesthetic** styles are both non-diegetic, and the split between them is a second, orthogonal question: **is the sound synchronised to a visible event or not?** Meanwhile post-production's own class system cuts a third way — *hard effects* (*"common sounds that appear on screen"* — doors, weapons, cars), *background/ambience* (*"do not explicitly synchronize with the picture, but indicate setting"*), *Foley* (*"sounds that synchronize on screen"* — footsteps, hand props, cloth), and *design effects* (*"sounds that do not normally occur in nature… used in a musical fashion to create an emotional mood"*).

The three-way map, stated once so it never has to be re-derived:

| Creator's style | Formal position | Post classes it absorbs | Answer to "is it required?" |
|---|---|---|---|
| Diegetic | diegetic | hard effects + Foley | **Required.** Its absence is heard. |
| Motion | non-diegetic, **synchronised** | design effects on a picture event | **Expected, budgeted.** Absence reads hollow; excess reads cheap. |
| Aesthetic | non-diegetic, **unsynchronised** | design effects on no event | **Optional, credibility-priced.** Absence reads flat; excess devalues the next one. |

**Where ambience sits, since the two halves of this note disagreed about it and both were half right.** Ambience — room tone, traffic, a café crowd, wind — is **diegetic in kind**: it comes from the world on screen, its absence is heard, and it is required wherever the location is established. But it is **not an event**, and that is the distinction that matters operationally. It is continuous, it has its own layer in the five-layer model and its own note ([[sfx-ambience-bridge-across-cut]], [[sfx-ambience-layer-stack]]), and it must be **excluded from the per-event classification, from the events-per-minute counts, and from the density budget**. Classify it as diegetic when you are asking "is this required?"; leave it out of the event list when you are counting. Rationing a room tone like a hit starves the scene of its floor.

Two further consequences worth stating plainly. **"Diegetic" here means *prominent and on screen*, not merely in-world** — a chair creaking under an unmoving presenter is technically diegetic and is still not a sound you place. And **one row per sound, not per moment**: a door slam that also punctuates a section is diegetic; the punctuation is a *second*, aesthetic layer with its own row, its own gain and its own budget line.

**Style.** No `sfx/` style tag: this is the router that assigns one to every other note, and tagging it with all three would make it a member of the set it defines. Every `sfx/` tag in the vault resolves back to the three definitions here.

## When to use it
Run this classifier **once per moment**, as the first move of the sound pass, before any Epidemic query is written. It converts the timeline into a classified event list, which is what [[sfx-sound-pass-order]] then schedules and [[motion-sfx-pass-manifest]] then derives from the motion side. Concretely, it fires:

- **On every row of `design-motion.md`** — each motion event either gets a style and a sound, or gets classified as silent and marked so ([[sfx-unsounded-motion-audit]]).
- **On every shot change of location or setting** — that is a diegetic obligation (ambience), not a design choice.
- **On every visible object interaction** in A-roll or B-roll — hands, doors, cups, laptops, paper. Diegetic, required for hero actions.
- **On every structural beat** — hook end, section turn, reveal, punchline. Those are aesthetic candidates and are the only ones allowed to spend from the credibility budget.
- **Any time you are stuck on "what sound goes here"** — the answer is usually that you have not decided which class the moment is in. A motion moment takes any sound with the right envelope; a diegetic moment takes exactly one sound, the real one.
- **Whenever a video "feels wrong" and you cannot say why.** The diagnostic readings are all classification failures: *fake* = missing diegetic and ambience; *hollow* = motion effects missing; *cheap/exhausting* = aesthetic effects placed as if they were required; *cluttered* = motion effects on things that are not moving; *flat* = motion effects with no aesthetic layer.
- **When the density audit fails.** Cut aesthetic first, motion second, and never diegetic ([[sfx-density-fatigue-audit]]).

Do **not** run it as a way to justify a sound you have already chosen. The classifier's output is allowed to be "no sound here," and on a talking-head video roughly a third of candidate moments should come back that way.

## How to recognise it in a reference video
Work the timeline transient by transient and classify each. The finding you are logging is not "there is a whoosh at 04:12" — it is the **style ratio**, which is the creator's sonic fingerprint. Per effect, record timecode, style, and offset vs picture; then compute shares.

For every SFX onset, ask in this order:

- **Is there a visible physical event within ±2 frames?** (contact, impact, an object being operated, a device that would make a noise) → **diegetic**. Check that it is on-screen and prominent; if the event is off-screen it may be doing ambience's job instead. **Test: mute the picture.** If a listener can name the object or the place, it is diegetic. Broadband and short (0.05–0.6 s) for hard effects.
- **Is there an authored motion event within ±2 frames?** (a transition, an element entering/leaving, a text build, a camera move) → **motion**. Detect with a scene-change / frame-delta pass and match against the audio onset list. On a spectrogram these are 0.2–0.8 s bursts, mid-and-up weighted (1–10 kHz), one per animation, with **onset 2–6 frames before** the element starts moving and peak inside the move. **Test:** freeze the picture at the effect's peak — something is mid-travel.
- **Neither?** → **aesthetic**. Long (1.5–12 s), low centre of gravity, no synchronised visual event at onset, quieter and smoother than the other two, clustering at emphasis points rather than at events. Often audible *only* by A/B — solo the SFX stem and it is obviously there; play the full mix and you cannot point at it. Risers, drones, sub booms, air textures.
- **Ratio, measured.** Typical fast-cut YouTube explainer: **motion 50–65 %, aesthetic 20–30 %, diegetic 10–25 %** by count. Cinematic / documentary-styled: diegetic **>50 %**. A video whose diegetic share is under 10 % is the "feels fake" case; one whose motion share is over 75 % is the "tick-tick-tick" case. Zero diegetic with a heavy motion count is the "produced but not real" profile; aesthetic outnumbering motion is the "trailer cosplay" profile.
- **Count per class per minute.** A working explainer typically runs **1–4 diegetic**, **6–15 motion** and **2–6 aesthetic** events per minute — the aesthetic figure counts *textures* (air on a move, a camera zoom), not the big riser/hit/tone gestures, which are far rarer. Totals: 8–20/min for the fast style, 3–8/min for the cinematic style. Above ~30/min habituation dominates ([[sfx-density-fatigue-audit]]). The diagnostic is the *shape*, not the absolute number.
- **Check the silent side.** List visible motion events with **no** sound: if more than about 20 % of authored motion is unsounded and the video is not deliberately quiet, the motion class is under-served ([[sfx-motion-sound-selection]], [[motion-silent-motion-tier]]).
- **Check level separation.** Split the stems if you can; otherwise measure short-window RMS at each effect and subtract the dialogue's RMS. A well-classified mix shows three distinct clusters, with ambience far below at −28 dB. If everything is at the same level, the video was mixed by dragging one fader. **Which cluster is loudest depends on the material — see the level table in Parameters, which is the one place these numbers are genuinely contested.**
- **Check whether diegetic sounds are the *right* sounds.** A water sound under a page turn is the source's own example of the mismatch; motion and aesthetic classes tolerate substitution, diegetic does not.
- **Transcript signal.** Diegetic obligations announce themselves in words — "so I picked up the phone", "here on the road". Aesthetic beats sit at paragraph boundaries and at the ends of thesis lines. Motion beats do not appear in the transcript at all; they come from the motion design.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `style` | — | `diegetic` \| `motion` \| `aesthetic` \| `silent` | Mandatory field on every row of the sound design doc. Store it on the event, not in your head. `silent` is a real, recordable answer. |
| `need` | required / expected / optional | — | Diegetic required, motion expected, aesthetic optional. This is the cut order when the density audit fails, reversed. |
| `dialogue_level` | 0 to −3 dB | — | Source. The reference all SFX levels are relative to. |
| `music_level` | −20 to −25 dB | — | Source. |

**Levels by style — read the condition column, because the two halves of this note disagreed here and the disagreement is real.** One reading says diegetic is the loudest class *because it must be believed*; the other says motion is, *because it is the standard designed-SFX tier*. Both are true of different material, and the variable is **how loud the real-world event actually is**:

| Style | Condition | Gain rel. dialogue | `data-volume` |
|---|---|---|---|
| Diegetic — loud real event | gunshot, slam, crash: the sound the shot is *about* | **−10 to −13 dB** | 0.224–0.316 |
| Diegetic — hero action | a hand, a laptop lid, a page: prominent but ordinary | **−16 dB** | 0.158 |
| Diegetic — background action | incidental, on-screen but not the subject | **−20 dB** | 0.1 |
| Motion | any authored movement | **−12 to −14 dB** | 0.2–0.25 |
| Aesthetic — texture | air on a body move, a camera zoom | **−16 to −18 dB** | 0.126–0.158 |
| Aesthetic — statement | riser, hit, tone | **−20 dB** | 0.1 |
| Ambience bed | continuous, not an event | **−28 dB** | 0.04 |

So: **on a video of loud physical events, diegetic is the loudest class; on a graphics-led explainer, motion is.** Never flatten this into one number per style — a gunshot at −16 dB is not believable, and a laptop lid at −12 dB is comic.

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `diegetic_offset` | **0 f** — peak on the contact frame | 0 to +1 f | Never early. An early impact reads as a mistake; a late one as weight. Audio leading picture is detected from ≈45 ms, lagging only from ≈125 ms. |
| `motion_offset` | **onset −4 f (−0.133 s); peak inside the move** | onset −2 to −6 f | **The lead is on the onset, not the peak.** The peak still never precedes the visual velocity maximum. This is why "never early" and "motion leads by 4 frames" are both true. |
| `aesthetic_offset` | arrives −8 to −90 f early, resolves on the beat | — | Risers start seconds early; textures have no event at all. |
| `diegetic_substitution` | forbidden | — | The real action needs its real sound. |
| `motion_substitution` | free | — | Any file with the right envelope ([[sfx-envelope-matched-to-easing-curve]]). |
| `diegetic_coverage` | 100 % of hero actions, ~60 % of background actions | — | Full coverage of everything is the density mistake. |
| `motion_coverage` | 40–60 % of animation events | 25–70 % | The rest are deliberately silent. |
| `aesthetic_texture_rate` | 2–6 per minute | 0–8 | Air, camera moves, micro-movement accents. |
| `aesthetic_statement_budget` | 3 per 10 min | 2–5 per 10 min | **Risers, hits and tones only**, shared across all three. This is the credibility budget and it is 20× stricter than the texture rate — do not conflate them ([[sfx-riser-credibility-budget]]). |
| `events_per_minute` | 10–20 total | 6–25 | Excludes ambience. 8–20/min fast style, 3–8/min cinematic. Above ~25–30 the density audit takes over. |
| `style_ratio_target` | motion 55 % / aesthetic 25 % / diegetic 20 % | set from the reference profile | Copy the reference's ratio, not its individual sounds. |
| `bus` | one per style | 3 buses | `sfx-diegetic`, `sfx-motion`, `sfx-aesthetic` — one fader and one treatment per class. |
| `reverb_aesthetic` | 12 % wet | 8–25 % | Aesthetic and motion effects need room; diegetic usually inherits the scene's. |
| `ducking_by_style` | diegetic: none · motion: none · aesthetic: bed −4 to −8 dB | — | Only the aesthetic layer is long enough to need room made for it. |

## Reproduction prompt
```
Classify every sound moment in {{COMPOSITION}} into exactly one of four styles
before fetching a single asset. Output a table with columns:
  t_event (s) | style | referent | required? | asset query | offset (frames) | gain (dB rel dialogue)

0. BUILD THE EVENT LIST from three sources:
   a) picture: scene/frame-delta detection for cuts and visible physical events;
   b) the motion timeline: every authored tween that qualifies as a motion event
      (see the motion-event manifest);
   c) the word-level transcript: emphasis words, punchlines, reveals.
   Do NOT put location tone or room tone on this list. Ambience is diegetic in
   kind but is not an event: route it to the ambience layer, give it a bed at
   -28 dB, and exclude it from every count below.

RUN THE CLASSIFIER IN THIS ORDER. First match wins.

Q1 DIEGETIC. At {{T}}, is there an object, action or place on screen that a real
   world would make a sound for - a hand touching a thing, a device, a vehicle?
   If YES -> style=diegetic. Mark required=YES for the action the shot is about,
   required=NO(background) for anything incidental. Offset 0 frames, peak on the
   contact frame, never early. Gain by loudness of the real event:
     genuinely loud (gunshot, slam, crash) -> -10 to -13 dB
     hero action (hand, lid, page)         -> -16 dB
     background action                     -> -20 dB
   One correct sound only; no substitution. Do NOT proceed to Q2 for this moment.

Q2 MOTION. Is there an on-screen element changing position, scale or opacity
   across 3 or more frames, with no physical referent - a transition, a title, a
   graphic, a bar, a wipe? If YES -> style=motion. Then apply the budget: sonify
   40-60% of these, choosing the ones that carry meaning; mark the rest
   style=silent with a reason. Offset: ONSET leads by 4 frames (-0.133 s), PEAK
   lands inside the move - do not lead the peak. Gain -12 to -14 dB. Any file
   whose envelope matches the easing curve.

Q3 AESTHETIC. Neither of the above, but the moment has an emotional or
   structural job - a section turn, a reveal, a thesis line, a camera push, a
   body move, a beat of dread? If YES -> style=aesthetic, and check WHICH budget:
     texture (air, camera move, micro-movement) -> 2-6 per minute, gain -16/-18 dB
     statement (riser, hit, tone)               -> max 3 per 10 MINUTES,
                                                   gain -20 dB
   It arrives before its moment, not on it.

Q4 Otherwise -> style=silent. Write the reason. Silence is an answer.

5. SET NEED AND ORDER. Place diegetic first, motion second, aesthetic last. If
   the total exceeds ~25 events per minute, cut aesthetic entirely before
   touching motion, and never cut diegetic.

6. ROUTE. data-audio-group="sfx-diegetic" | "sfx-motion" | "sfx-aesthetic", one
   <hf-audio-group> bus per style carrying that style's fader and reverb. Never
   put an SFX in the voiceover group - it poisons the bed's carve.

7. THEN, and only then, write queries. Anchor each on the verified Epidemic tag
   family for its style: diegetic -> the object's own family (footsteps--,
   mechanical--, computers--, ambience--); motion -> swooshes--whoosh,
   user-interface--motion; aesthetic -> designed--riser, designed--impact,
   designed--boom, designed--eerie.

8. PLACE by style rule: diegetic on the contact frame, motion by the easing
   curve's velocity peak with the onset leading, aesthetic loosely under the beat
   it colours. Align the file's LOUDEST SAMPLE, not the file's head.

ACCEPTANCE TEST.
(a) Every row has a style. No blanks, no "both".
(b) Every visible prominent physical event has a diegetic sound.
(c) The style ratio is within 10 percentage points of the reference profile's
    ratio; diegetic share is at least 10% - below that the video reads as fake.
(d) Unsounded authored motion is under 20% of motion events, or explicitly
    listed as deliberately silent.
(e) Aesthetic STATEMENT count is <= 3 per 10 minutes; texture count <= 8/min.
(f) The three buses measure as three distinct level bands, and no aesthetic
    effect is audible as a separate event at normal volume.
(g) Mute the SFX buses one at a time: killing diegetic should make the video
    feel unreal, killing motion should make it feel hollow, killing aesthetic
    should make it feel flat. If killing a bus changes nothing, that bus is
    mis-classified.
```

## Execution spec

**Placement spec by style (the three numbers, per style).**

| Style | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Diegetic (loud event) | peak **on** the contact frame, 0 to +1 f | −10 to −13 dB (0.224–0.316) | none — too short to need it |
| Diegetic (hero action) | peak **on** the contact frame, 0 to +1 f | −16 dB (0.158) | none |
| Diegetic (background / bed) | continuous, no event | −20 dB (0.1) / ambience bed −28 dB (0.04) | none; never carve a bed |
| Motion | onset **−4 f**, peak inside the move | −12 to −14 dB (0.2–0.25) | none |
| Aesthetic (texture) | loosely under the beat it colours | −16 to −18 dB (0.126–0.158) | none |
| Aesthetic (statement) | arrives −8 to −90 f early, resolves on the beat | −20 dB (0.1) | music bed −4 to −8 dB across it |

**HyperFrames — one `<hf-audio-group>` bus per style.** This is the structural payoff of classifying: the style becomes a real submix, so a whole style can be levelled, filtered or muted in one place, and acceptance test (g) above is a one-attribute change. A bus is *"one chain, one fader, one automation clock for every member"*, and its automation `t` is **composition time** (a bus has no `data-start`), unlike a clip lane.

```html
<hf-audio-group id="sfx-diegetic"  data-label="SFX — Diegetic"  data-volume="0.158"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;d1&quot;,&quot;label&quot;:&quot;Room Glue&quot;,&quot;params&quot;:{&quot;size&quot;:0.35,&quot;damping&quot;:0.6,&quot;wet&quot;:0.1,&quot;dry&quot;:0.95}}]}"></hf-audio-group>

<hf-audio-group id="sfx-motion"    data-label="SFX — Motion"    data-volume="0.25"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;m1&quot;,&quot;label&quot;:&quot;Clear the Sub&quot;,&quot;params&quot;:{&quot;frequency&quot;:120,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"></hf-audio-group>

<hf-audio-group id="sfx-aesthetic" data-label="SFX — Aesthetic" data-volume="0.1"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;a1&quot;,&quot;label&quot;:&quot;Aesthetic Space&quot;,&quot;params&quot;:{&quot;size&quot;:0.6,&quot;damping&quot;:0.5,&quot;wet&quot;:0.12,&quot;dry&quot;:0.9}}]}"></hf-audio-group>

<audio id="sfx-door-01"  src="assets/sfx/door-close.wav"   data-audio-group="sfx-diegetic"
       data-start="18.400" data-media-start="0.08" data-duration="1.2" data-track-index="12"></audio>
<audio id="sfx-title-in" src="assets/sfx/whoosh-short.wav" data-audio-group="sfx-motion"
       data-start="24.267" data-media-start="0.02" data-duration="0.7"  data-track-index="13"></audio>
<audio id="sfx-riser-01" src="assets/sfx/riser-no-hit.wav" data-audio-group="sfx-aesthetic"
       data-start="51.000" data-media-start="0.11" data-duration="3.2"  data-track-index="14"></audio>
```

Contract points that decide whether this actually runs:
- **Every `<audio>` needs an `id`.** An id-less `<audio>` is *never mixed → silent render*, and it is a lint **error** (`media_missing_id`).
- **Overlapping clips need different `data-track-index` values** or lint warns `duplicate_audio_track`. Style buses do not remove that requirement — `data-track-index` is display-only and *"constrains nothing"* — so spread a style across 12/13/14.
- **Group membership alone is enough to carve against**, but adding the `<hf-audio-group>` element is what gives the style a real fader and chain, and it is the reason a class-wide duck is easier on the bus.
- **Never put an SFX clip in the `voiceover` carve group.** The carve group must be voices only; a bed or an effect inside it *"poisons the next re-analysis silently."* Each style bus here is separate from `voiceover` on purpose.
- **`data-fx-carve` is clip-only** and belongs on the music bed — never on a bus and never on a voice (`audio_group_carve_attr`). Ducking the music under an aesthetic riser is a `volume` lane on the *bed*, not a carve.
- **`compressor`, `limiter`, `gate` and `bitcrush` have zero automatable parameters** — to ride a style dynamically, automate a `gain` node around it.
- **Do not pair a bus/clip `volume` lane with a GSAP `volume` tween** on the same track: the lane wins silently (`audio_volume_double_automation`).
- **All authored time is seconds.** There is no frame attribute; convert at authoring time (−4 frames at 30 fps = −0.133 s) and leave the frame count in a comment.
- **There is no audio-follows-animation attribute.** Coupling a motion effect to its animation means writing the same number twice — once as the GSAP timeline position, once as `data-start`. If the animation lives in a sub-composition at scene-local `t`, the root-level audio needs `data-start = t + the slot's data-start`.
- **`data-volume` is linear gain** (1 = 0 dB, max 3.98 = +12 dB); the dB targets above are relative mix positions to hit at the render, verified by listening, not by attribute arithmetic alone.

**Epidemic Sound — the anchor families per style.** Search is tag-first, term-second: free text alone is unreliable in this catalogue, and an unrecognised slug **fails closed** (`meta.total: 0`), so zero results means the slug is wrong. All slugs below were probed live on 2026-08-28.

```
# DIEGETIC - name the action, anchor on the object's own family
footsteps--human · mechanical--click · computers--keyboard-mouse ·
communications--camera · ambience--traffic · ambience--market · ambience--park ·
ambience--urban · ambience--forest · ambience--room-tone · crowds--walla
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["mechanical--click"] },
                               duration: { min: 200, max: 3000 } },
                     query: { term: "close dry variations" }, first: 8 }

# MOTION - name the envelope, anchor on the movement family
swooshes--whoosh · swooshes--swish · user-interface--motion · user-interface--click · user-interface--glitch
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["swooshes--whoosh"] },
                               duration: { min: 300, max: 1500 } },
                     query: { term: "fast short air" },
                     sort: { by: POPULARITY, order: DESCENDING }, first: 10 }
# verified: that exact filter returns 14 effects - a small, auditionable shelf.

# AESTHETIC - name the register, anchor on the designed family
designed--riser · designed--impact · designed--boom · designed--eerie
SearchSoundEffects { filter: { tagSlugs: { matchType: ALL, values: ["designed--riser"] },
                               duration: { min: 1500, max: 12000 } },
                     query: { term: "clean no impact suspense" }, first: 12 }
```

Invalid slugs found by probing, so you do not waste a call on them: `ambience--cafe`, `ambience--restaurant`, `user-interface--notification`, `user-interface--confirm`, `user-interface--success` all return 0. For a café use `crowds--walla` plus `ambience--room-tone`. Always `DownloadSoundEffect` with `{"fileType":"WAV"}`, and use `SearchSimilarToSoundEffect(id)` to keep a style's palette coherent across a video.

**ffmpeg — building the event list, and the style-ratio audit.** There is no stem separation here, so measure per-effect windows rather than buses:
```bash
# picture events (cuts and large frame deltas)
ffmpeg -i render.mp4 -vf "select='gt(scene,0.15)',metadata=print:file=/tmp/pic.txt" -f null -
# audio onsets already present, to classify what is there
ffmpeg -i render.mp4 -af "astats=metadata=1:reset=3,ametadata=print:key=lavfi.astats.Overall.Peak_level:file=/tmp/aud.txt" -f null -
# regions with no sound at all, to catch an under-served motion class
ffmpeg -i render.mp4 -af "silencedetect=n=-38dB:d=0.08" -f null - 2>&1 | grep silence_
# per-frame RMS trace; effect onsets are the jumps
ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
# band split, to separate aesthetic (sub/air) from motion (mid) energy
ffmpeg -i ref.wav -af "lowpass=f=200"   ref.sub.wav
ffmpeg -i ref.wav -af "highpass=f=6000" ref.air.wav
```

**Remotion.** Three `<Audio>` sets wrapped in three sequences with a shared volume constant per style; the classification itself is a planning artefact and ports as-is. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-real-vs-invented-sound-rule]] · [[sfx-diegetic-action-inventory]] · [[sfx-motion-sound-selection]] · [[sfx-felt-not-noticed]] · [[sfx-five-layers-build-order]] · [[sfx-ambience-layer-stack]] · [[sfx-layer-volume-targets]] · [[sfx-second-sense-doctrine]] · [[sfx-density-fatigue-audit]] · [[sfx-unsounded-motion-audit]] · [[sfx-sound-pass-order]] · [[sfx-name-before-search]] · [[sfx-layered-approach-and-impact]] · [[sfx-mood-map-per-topic]] · [[motion-silent-motion-tier]] · [[struct-emotional-arc-drives-retention]] · [[sfx-air-on-micro-movement]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-envelope-matched-to-easing-curve]] · [[sfx-placement-discipline]] · [[sfx-ambience-bridge-across-cut]] · [[motion-sfx-pass-manifest]] · [[sfx-whoosh-short-vs-long]] · [[sfx-search-vocabulary]] · [[motion-sound-bound-motion-event]] · [[sfx-riser-credibility-budget]] · [[sfx-two-taxonomies-of-sound]] · [[sfx-ten-family-catalogue]]

## Failure modes
- **Skipping the classifier and searching straight from a vibe.** Produces a video made entirely of whooshes, because "whoosh" is the easiest thing to search, and a timeline of aesthetic sounds with no diegetic floor: the video sounds produced and unreal. The ratio audit catches it — motion share above 75 %. Correction: run the triage, place diegetic first.
- **Classifying a moment as two styles.** A door slam that also punctuates a section is still diegetic; the punctuation is a *second*, aesthetic layer with its own row, gain and budget line. One row per sound, not per moment.
- **Treating diegetic as optional.** It is the one style whose absence is *heard*. A video with zero diegetic layer reads as fake even when every animation has a sound.
- **Substituting inside the diegetic class.** A water sound under a page turn — the source's own example. Only motion and aesthetic tolerate substitution.
- **Flattening the level table to one number per style.** A gunshot at −16 dB is not believable; a laptop lid at −12 dB is comic. Correction: pick the row by how loud the real event is, and keep the three diegetic rows distinct.
- **Mixing the offsets up.** Diegetic peaks **on** the contact frame; motion's *onset* leads by ~4 frames while its peak still lands inside the move. Applying the motion lead to the *peak* of an impact makes the impact land before the fist does, which reads as broken rather than as anticipation.
- **Aesthetic sounds mixed at motion level.** At −12 dB an aesthetic accent stops being felt and starts being noticed, which is the exact quality it is defined against. Correction: 3–6 dB below the motion layer, and −20 dB for statements.
- **Confusing the two aesthetic budgets.** Six air accents in a minute is normal; six risers in a minute has spent the credibility budget twelve times over. Correction: count textures and statements separately.
- **Treating ambience as an event.** Location tone gets rationed like a hit and the scene loses its floor; or it gets counted in the density audit and forces real effects out. Correction: diegetic in kind, excluded from the event list, routed to the ambience layer, which is continuous.
- **Cutting diegetic to fix density.** Correction: cut in reverse-need order — aesthetic, then motion; never diegetic.
- **SFX inside the voiceover group.** Silently corrupts the next carve analysis; nothing errors. Correction: `sfx-*` groups only, and keep the carve group voices-only.
- **One fader for everything.** Three styles with three jobs cannot share one level. Correction: three buses.
- **Classifying by how the file sounds instead of by what the moment is.** A whoosh placed on a real door swing is still a diegetic moment and needs the door. Correction: classify the moment, then choose the file.
- **Known gap — no automatic classification.** Nothing in this stack detects motion events or objects; the classifier is a human/agent pass over `design-motion.md` and the footage. There is no face tracking, no content-aware analysis and no scene-understanding API in the contract. Budget the pass time.
- **Known gap — no panner.** The FX registry has filters, dynamics, nonlinear, delay/reverb/chorus/phaser and no pan or width control, so styles cannot be separated by stereo position in-composition. Bake width with ffmpeg before import, or accept centre.
