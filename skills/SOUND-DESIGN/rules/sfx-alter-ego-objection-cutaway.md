---
id: sfx-alter-ego-objection-cutaway
title: The heckling alter-ego — voice the viewer's objection, and give it its own room
skill: sound-design
type: mix
family: voice-character
tags: [skill/sound-design, type/mix, family/voice-character, engine/hyperframes, engine/epidemic, engine/ffmpeg, sfx/aesthetic, layer/dialogue, layer/sfx, source/editing-kt-3, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:00:18
    quote: "(interjection) Come on, music isn't even that important — somebody tell him."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:00:38
    quote: "(interjection) I'm an editor, not a musician. — You're not even a decent editor."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:05:45
    quote: "(interjection) Yeah, so what? Nothing's going to happen, let the music run. — Okay, that one was actually good."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:01:36
    quote: "\"Just use the real ones. Why add them later?\" \"You don't know anything, do you.\""
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:03:36
    quote: "\"Motion graphics? Are you crazy?\""
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:04:17
    quote: "\"So should I slap a whoosh on every single motion?\" You don't put a whoosh on everything."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:04:23
    quote: "\"You listed off so many sound effects — but where do I get them from?\""
research_refs:
  - https://en.wikipedia.org/wiki/Auditory_masking
  - mcp://Epidemic_sounds/SearchSoundEffects (communications--phonograph probed live, 2026-08-28)
difficulty: high
detectable_from: transcript+video
---

# The heckling alter-ego — voice the viewer's objection, and give it its own room

## What it is
A second character — a sarcastic version of the presenter — interrupts the lecture at short intervals to say what the viewer is already thinking, and the host answers it. Across the two source videos the interruptions do four distinct jobs, and it is worth separating them because they take different treatments:

1. **The objection.** *"Just use the real ones. Why add them later?"* · *"So should I slap a whoosh on every single motion?"* · *"You listed off so many sound effects — but where do I get them from?"* The anticipated disagreement, spoken aloud so the host can dispose of it. This is the load-bearing one; it converts an assertion into an argument.
2. **The status attack.** *"I'm an editor, not a musician." — "You're not even a decent editor."* Undercuts the presenter, which buys back the authority a lecture spends.
3. **The pacing reset.** *"I don't want to watch your video, this is getting to be too much."* No content at all — a pure attention interrupt at a point where a dense stretch would otherwise flatten out.
4. **The comic beat.** *"Who did you hit?"* · *"BPM? — Yeah, that."* Rhythm only.

The sound-design problem this creates is the one the note is really about. **Two performances by the same person, shot in the same room, on the same microphone, are indistinguishable by ear.** Without a treatment the viewer has to rely on framing alone to know who is speaking, and any moment where the cut is fast or the frame is similar reads as the host contradicting himself. The fix is *not* to pitch-shift — a pitched voice reads as a cartoon and undermines the joke's deadpan. The fix is to **put the alter-ego in a different acoustic space**: a tighter room, a slightly narrower band, and a different level. The viewer never identifies the treatment; they identify a second person.

Measured cadence from the source, which is the other reusable number here: `editing kt 3` carries **12 interruptions in about 7.5 minutes** (≈1.6/min), at gaps of 5, 11, 20, 36, 57, 68, 79 and 99 seconds — clustered around **20–40 s**, with the tight pairs used as call-and-response inside a single beat rather than as separate interruptions.

## When to use it
- **Immediately after a claim the audience will resist.** The objection must arrive within about 3 seconds of the claim, while the resistance is still forming. Later and you are answering a question nobody asked any more.
- **Immediately before a section the audience will find tedious** — a list, a settings walkthrough, a definition. The interruption buys the attention the section will spend.
- **At the 20–40 second mark of any dense explanatory stretch.** This is the pacing use and it needs no content.
- **In the first 25 seconds of the video.** The source opens with one at 0:18; establishing the second character early means later interruptions cost no setup.
- **Not more than about 2 per minute.** Above that the lecture stops being a lecture and the device becomes the content.
- **Not on the video's single most important instruction.** An interruption over the one thing the viewer came for is a retention device eating the payload.
- **Not without an answer.** An objection the host does not dispose of leaves the viewer holding it. Every objection needs a reply within roughly 6 seconds.
- **Not with a distinct caption style *and* a distinct room *and* a sting *and* a costume.** Two differentiators are legible; four are a sketch show.

## How to recognise it in a reference video
- **Read the transcript for second-person or dismissive register in the middle of first-person instruction.** The alter-ego's lines are near-universally one of: a question beginning "so should I / why / but wait", a flat contradiction, or an insult. They are also **short** — measured across both sources, 1.5–4 seconds, almost never longer.
- **Look for a hard cut with no B-roll on the objection frame.** The picture returns to a presenter shot, but a *different* presenter shot: different framing, different position in frame, sometimes a costume or prop change. There is no transition — the cut is deliberately abrupt, because the abruptness is the interruption.
- **Measure the voice, not the words.** Extract 2 s of host and 2 s of alter-ego and compare three things: (a) long-term average spectrum in the 250–600 Hz and 4–8 kHz bands, (b) reverberation decay after a plosive, (c) RMS. A treated alter-ego typically shows **less air above 6 kHz**, **more early reflection energy**, and sits **1–3 dB lower** than the host. If all three are identical, the creator differentiated by picture only — log that, because it means the audio budget is spent elsewhere.
- **Check for a sting on the cut.** Many implementations put a short one-shot on the interruption frame — a record scratch, a needle-off, a reverse whoosh. Look for a 0.5–1.8 s broadband transient exactly on the cut ([[sfx-record-scratch-punctuation]]).
- **Check what the music does.** The strongest tell of a considered implementation: the music **does not stop** for the interruption. Continuity in the bed is what makes the cutaway read as an aside rather than as a new scene.
- **Count and space them.** Log every interruption's timestamp and compute the gaps. A profile that reproduces this creator needs the *cadence* (≈1.6/min, modal gap 20–40 s) far more than it needs any individual joke.
- **Log the reply latency** — seconds from the end of the objection to the start of the host's answer. In the source it is consistently under 1.5 s.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `interjection_length` | 2.5 s | 1.2–4.5 s | Measured across both sources. Past 5 s it is a scene, not an interruption. |
| `cadence` | 30 s | 20–45 s | Modal gap in the source. Tight pairs (5–11 s) are call-and-response inside one beat, not two interruptions. |
| `density_cap` | 1.6 / min | 1.0–2.2 / min | The source's own measured rate. |
| `reply_latency` | 0.6 s | 0.2–1.5 s | End of objection to start of answer. Longer reads as the host being stumped. |
| `objection_after_claim` | 1.5 s | 0–3 s | The objection lands while the resistance is fresh. |
| `alterego_level` | −2 dB vs host | −3 to 0 dB | Slightly under. A louder alter-ego reads as the real voice. |
| `alterego_room` | `room-tight` | `room-tight` \| `room-natural` | A *smaller* room than the host's. Bigger reads as a different location, which is wrong — he is in the same room, being annoying. |
| `alterego_air_cut` | −3 dB @ 8 kHz | −2 to −5 dB | A high-shelf cut. Removes the polish the host's chain adds, which is what makes it sound like a different person rather than a different take. |
| `alterego_presence` | +1.5 dB @ 3 kHz | 0 to +2.5 dB | Slight forwardness so a quieter voice still cuts through. |
| `sting` | optional, 1 in 3 | 0–1 per interruption | Use on the funniest third only. On every one it becomes a laugh track. |
| `sting_level` | −13 dB rel. dialogue | −12 to −15 dB | The library's standard SFX window. |
| `sting_offset` | −2f before the cut | −4f to 0f | Leads the picture slightly, like any motion effect ([[sfx-split-edit-lead-lag]]). |
| `music_continuity` | continuous | continuous | Do **not** cut the bed. Continuity is what makes it an aside. |
| `differentiators` | 2 | 2–3 | Room + framing is the baseline pair. Add a caption style or a costume, never both. |

## Reproduction prompt

```
Build the alter-ego interruption at {{IN}} (seconds), lasting {{LEN}}
seconds, answering the claim that ends at {{CLAIM_END}}.

1. PLACE IT. {{IN}} = {{CLAIM_END}} + 1.5. If more than 3 s have passed
   since the claim, move it earlier or drop it - a late objection answers a
   question the viewer has stopped asking.
2. CHECK THE CADENCE FIRST. List every existing interruption timestamp. If
   the nearest is under 20 s away and is not part of a call-and-response
   pair, do not add this one. Hard cap: 2 per minute of finished runtime.
3. CUT HARD. No transition, no B-roll, no dissolve. Straight cut in on
   {{IN}}, straight cut out on {{IN}} + {{LEN}}. The abruptness IS the
   interruption.
4. TREAT THE VOICE - room and band, never pitch. On the alter-ego's clips:
   - a TIGHT room preset (smaller than the host's), presetAmount ~0.35
   - high-shelf -3 dB at 8000 Hz  (removes the host chain's polish)
   - peaking +1.5 dB at 3000 Hz, Q 1 (keeps it intelligible while quieter)
   - level -2 dB relative to the host
   Do NOT pitch-shift and do NOT stack a second character preset. One
   costume only.
5. GROUP IT. Put every alter-ego clip in its own audio bus so the treatment
   is authored once and every interruption in the video matches. Keep that
   bus INSIDE the voiceover carve group as well, so the music bed keeps
   carving under it - the alter-ego is still speech.
6. STING, CONDITIONALLY. If this is one of the funniest third of the
   interruptions, place a one-shot 2 frames BEFORE {{IN}} at -13 dB
   relative to dialogue. Otherwise place nothing. A sting on every
   interruption is a laugh track.
7. LEAVE THE MUSIC ALONE. The bed runs continuously across {{IN}} and
   {{IN}} + {{LEN}}. Cutting it turns an aside into a scene change.
8. ANSWER IT. The host's reply starts within 0.6 s of {{IN}} + {{LEN}} and
   must actually dispose of the objection. An unanswered objection is worse
   than no objection.

ACCEPTANCE TEST: play from {{CLAIM_END}} - 4 s to the end of the reply with
your eyes closed. You must be able to tell, from sound alone, that two
different people spoke - without being able to say what was done to either
voice. If you hear an effect, the room is too wet or the shelf is too deep.
Then watch it: the music must run underneath without a seam.
```

## Execution spec

**HyperFrames — this is the canonical `<hf-audio-group>` case.** The contract is explicit that a bus is for *"when the same treatment belongs on several tracks"* and that *"a compressor cannot ride a sequence it only hears a third of."* Twelve short interruptions scattered through a video are exactly that: one chain, one fader, applied once.

```html
<!-- the host: the default answer to "fix this voiceover" -->
<hf-audio-group id="voiceover" data-label="Host" data-volume="1"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;h1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:100,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
    {&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;h2&quot;,&quot;label&quot;:&quot;Add Clarity&quot;,&quot;params&quot;:{&quot;frequency&quot;:3000,&quot;gain&quot;:2.5,&quot;q&quot;:1}},
    {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;h3&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></hf-audio-group>

<!-- the alter-ego: same room, smaller space, less air, slightly under -->
<hf-audio-group id="alterego" data-label="Alter-ego" data-volume="0.79"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;a1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:110,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
    {&quot;type&quot;:&quot;highshelf&quot;,&quot;id&quot;:&quot;a2&quot;,&quot;label&quot;:&quot;Take the air off&quot;,&quot;params&quot;:{&quot;frequency&quot;:8000,&quot;gain&quot;:-3}},
    {&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;a3&quot;,&quot;label&quot;:&quot;Add Clarity&quot;,&quot;params&quot;:{&quot;frequency&quot;:3000,&quot;gain&quot;:1.5,&quot;q&quot;:1}},
    {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;a4&quot;,&quot;label&quot;:&quot;Tight room&quot;,&quot;params&quot;:{&quot;size&quot;:0.18,&quot;damping&quot;:0.6,&quot;wet&quot;:0.14,&quot;dry&quot;:0.95}},
    {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;a5&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></hf-audio-group>

<audio id="ae-01" src="assets/vo/heckle-01.wav"
       data-audio-group="alterego" data-start="18.2" data-duration="2.4"
       data-track-index="10"></audio>

<audio id="sfx-scratch-01" src="assets/sfx/design/record_scratch_stop.wav"
       data-audio-group="sfx" data-start="18.13" data-duration="1.0"
       data-track-index="20" data-volume="0.224"></audio>
```
Contract points that decide whether this runs.

- **`data-volume="0.79"` is −2 dB**, and it is on the *bus*, so it applies to every member. A bus fader is *"one fader for every member."*
- **Chain order is signal order** and the doctrine is *"Subtract before you add, level after you filter, relationships after level, character and ceiling last."* Hence high-pass → shelf → peaking → reverb → **limiter last**.
- **Do not use a character preset here.** `telephone`, `radio-am`, `megaphone` and friends are documented as *"costumes... Do not stack two"*, and a costume on an alter-ego who is standing in the same room is the wrong idea entirely — it says *different device*, not *different person*.
- **Reverb's `size` and `damping` are not automatable** (they regenerate the impulse); only `wet`/`dry` are. That is fine — a character room should not move. If you ever need it to, *"automate a `gain` stage around it instead."*
- **Beware the double-application trap.** If you apply the `voice-clean` preset to the host bus *and* hand-add a Reduce Mud job, you get *"−6 dB at 250 Hz where −3 was meant."* Read what a preset already contains.
- **Group membership and carve.** The alter-ego is speech, so the music bed must keep carving under it. `data-fx-carve` names a **group**, so either put the alter-ego clips in `data-audio-group="voiceover"` and accept that they lose the separate bus, or carve against both groups: `"sources":["voiceover","alterego"]` — `sources` *"is a **list**"*. The second is correct and is the reason to build the bus at all. Keep the carve group **voices only**; a stray sting inside it *"poisons the next re-analysis silently."*
- **The sting is not in either voice group.** `data-audio-group="sfx"`, always.
- **The sting leads the picture by 2 frames**: `18.2 − 0.067 = 18.133`, authored as `18.13`. There is no frame unit; frames survive only as comments.

**Epidemic Sound.** The interruption sting. Probed live 2026-08-28, the slug is `communications--phonograph` (1785 results on the term query) and the titles are literal:
```
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["communications--phonograph"]},
                              duration:{min:300,max:4000} },
                     query:{term:"record scratch stop"},
                     sort:{by:RELEVANCE, order:DESCENDING}, first:16 }
#   verified: "Communications, Phonograph, Vinyl, Record, Spin, Stop, Scratch" (1252 ms)
#             "Communications, Phonograph, Vinyl, Record Scratch, Stop"        (3600 ms)
#             "Communications, Phonograph, Vinyl, Record Scratch 01/06/11/17/18/19"
#               (1005 / 662 / 575 / 1697 / 1134 / 1822 ms - a whole variant set)
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
SearchSimilarToSoundEffect { id:<uuid>, first:12 }
```
The numbered variants matter more than the choice: use a **different one each time** ([[sfx-repetition-variant-rotation]]). Alternatives worth auditioning for the same slot: `designed--stinger`, `cartoon--pop`, and a short reverse whoosh from `designed--riser` trimmed to its last 0.4 s.

**ffmpeg.** Only if you are building the character voice as a rendered asset rather than as a live chain — for example to check the treatment before committing:
```bash
# the whole alter-ego treatment, baked, for A/B against the untreated take
ffmpeg -i heckle-01.wav -af "highpass=f=110:poles=2,\
 treble=g=-3:f=8000:width_type=q:width=0.707,\
 equalizer=f=3000:width_type=q:width=1:g=1.5,\
 aecho=0.9:0.25:18:0.12,volume=-2dB,alimiter=limit=0.891" heckle-01.treated.wav
# then compare the two spectra - the difference should be air and room, not pitch
ffmpeg -i heckle-01.wav -af "astats=measure_overall=RMS_level" -f null -
```
`aecho=0.9:0.25:18:0.12` is an 18 ms single reflection — a small-room early reflection, not a reverb tail. Keep intermediates **outside the mounted vault**, which cannot delete files.

**Remotion.** Two `<Audio>` sequences with a shared Web Audio graph is not the Remotion idiom; the practical port is to pre-render the treated alter-ego takes and place them as plain audio. Concept only.

## Pairs with
[[struct-objection-character-cutaway]] · [[sfx-record-scratch-punctuation]] · [[sfx-repetition-variant-rotation]] · [[sfx-dialogue-gate]] · [[sfx-filter-character-and-distance]] · [[sfx-reverb-glue]] · [[sfx-hard-cut-audio-seam]] · [[sfx-split-edit-lead-lag]] · [[sfx-music-rest-windows]] · [[sfx-layer-volume-targets]] · [[sfx-beat-forward-bed-under-voice]] · [[sfx-echo-on-cartoon-oneshot]] · [[cut-jump-cut-take-repair]] · [[struct-presenter-aside-pattern-interrupt]] · [[motion-pattern-interrupt-jolt]]

## Failure modes
- **Pitch-shifting the alter-ego.** Reads as a cartoon and kills the deadpan the joke depends on. Fix: differentiate by room and band, never by pitch.
- **No audio differentiation at all.** The viewer relies entirely on framing, so any fast or similar cut reads as the host contradicting himself. Fix: the tight-room + air-cut + −2 dB triple is the minimum.
- **Too much room.** A wet alter-ego sounds like it is in a different building, which is a location change, not a character. Fix: `size` 0.15–0.22, `wet` ≤0.18.
- **A character preset.** `telephone` / `megaphone` say *different device*. Fix: none of them; a plain small room.
- **Cutting the music for the interruption.** Turns an aside into a scene change and doubles its apparent length. Fix: the bed runs through, uncut.
- **A sting on every one.** Becomes a laugh track and the interruptions stop being surprising. Fix: one in three, and a different variant every time.
- **The alter-ego outside the carve sources.** The music bed un-carves for exactly the length of every interruption, which is audible as the bed swelling on the joke. Fix: `"sources":["voiceover","alterego"]`.
- **An unanswered objection.** The viewer is left holding the disagreement you just handed them, which is worse than never raising it. Fix: reply within 0.6 s and actually dispose of it.
- **Over-frequency.** Above ~2 per minute the device becomes the subject. Fix: compute the gap list before adding one, and cut the weakest rather than spacing the new one.
- **Four differentiators at once** — costume, room, caption style and sting. Fix: two.
- **Known gap:** this technique needs a **second performance**, which no part of this stack can generate. Epidemic's `GenerateVoiceover` produces a synthetic voice, not a second take of the presenter's own, and using it here would break the joke's premise that both characters are him. If the second performance was not shot, the technique is unavailable — say so in the design document rather than substituting TTS.
