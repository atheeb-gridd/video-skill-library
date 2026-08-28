---
id: sfx-record-clean-add-world
title: Record clean, add the world back — ambience is a post decision, not a microphone fault
skill: sound-design
type: mix
family: dialogue-cleanup
tags: [skill/sound-design, type/mix, family/dialogue-cleanup, sfx/diegetic, layer/dialogue, layer/ambience, engine/ffmpeg, engine/hyperframes, engine/epidemic, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:02:40"
    quote: "So they should use a better mic, no? — The point isn't that the noise is there because the mic is bad."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:02:44"
    quote: "Even these sound effects are added later, to give a more immersive feel."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:02:36"
    quote: "Even in Hollywood movies, the sounds of nearby things keep playing."
research_refs:
  - https://en.wikipedia.org/wiki/Production_sound_mixer
  - https://en.wikipedia.org/wiki/Room_tone
  - https://en.wikipedia.org/wiki/Noise_reduction
  - https://en.wikipedia.org/wiki/Sound_effect
difficulty: medium
detectable_from: audio
---

# Record clean, add the world back — ambience is a post decision, not a microphone fault

## What it is
A correction to the most common beginner inference about professional audio. When a scene sounds like a market, the market is not leaking into the microphone — it was **placed there afterwards**. The production chain is explicitly two-sided: the production sound mixer captures dialogue on set, and that recording is *"later combined with other elements, i.e. effects, music, narration, Foley or re-recorded dialog."* Ambience belongs to the second half. The dialogue recording's job is to be **clean and only clean**; the world is built on a separate layer where it can be chosen, levelled, moved and removed.

This inverts the instinct. "My audio sounds empty, so I need a better mic" is almost always wrong: a better mic makes the recording *cleaner*, which makes it emptier still. The recording is not supposed to contain the room. What the video is missing is a layer, not a preamp.

The corollary is the part that actually changes a workflow: **noise that did get in is a liability, not a head start.** It cannot be levelled independently, it changes with every shot and mic position, and removing it costs signal — *"noise reduction algorithms tend to alter signals to a greater or lesser degree"*, and choosing one means deciding *"whether sacrificing some real detail is acceptable if it allows more noise to be removed."* So the order is: capture clean, repair conservatively, then lay a designed bed on top. The designed bed is what makes the result sound like a place; it is also what hides the small artefacts the repair left, because a consistent bed gives the ear something continuous to hold onto.

One piece of on-set discipline makes all of this cheaper and is worth naming even though the source video does not: **room tone**, *"the 'silence' recorded at a location or space when no dialogue is spoken"*, which *"may be intercut with dialogue to smooth out any sound edit points."* Thirty seconds of it at every location costs nothing and solves the seams that pause-removal creates.

## When to use it
- **Diagnosing "my audio sounds cheap / empty / amateur"** when the dialogue itself is clean. The answer is a missing layer, not a gear purchase.
- **Any location footage where the location is part of the point** — a street, a café, a workshop, a market — and the recording is a clean lav or shotgun that captured almost none of it.
- **After a pause-removal or jump-cut pass**, which chops the noise floor along with the words and leaves audible steps at every splice ([[sfx-pause-removal-breath-and-room-tone]], [[sfx-noise-floor-target]]).
- **Before deciding to denoise at all.** Often the correct move is to leave a modest floor alone and cover it with an intentional bed, rather than to strip it and then have to replace it.
- **Not** when the problem is hiss, hum or room reflection *underneath the speech*. That is a source problem this stack cannot fix — see Failure modes.

## How to recognise it in a reference video
- **The bed is independent of the shot.** Log the ambience level and character across every angle change in one scene. Post-added ambience is **identical across all of them** — same spectrum, same level, within ~1–2 dB. Captured ambience changes with mic distance and angle at every cut.
- **The bed continues through cutaways and graphics.** If the traffic keeps running under a full-frame motion-graphics insert, it is a laid bed, not a recording.
- **Voice is dry, world is wide.** Check stereo width by comparing L/R difference: the dialogue is mono and centred, the ambience is wide. A single recording cannot produce that combination — it is proof of two layers.
- **The bed has no dialogue-shaped ducking of its own**, but is often carved or ducked around the voice in a way that tracks the words too precisely to be acoustic.
- **The floor is continuous across every splice.** Measure inter-word RMS on either side of a jump cut: a designed bed holds within **≤2 dB**; a raw recording that was cut steps by **4 dB or more** ([[sfx-ambience-bridge-across-cut]]).
- **Named locations always have their sound.** Where the narration says "in the café", the café is audible from the first frame — including in the shots where the camera cannot see the room.
- **Transcript tell:** a location named in the script with no corresponding bed in the audio is the "missing ambience" defect ([[sfx-missing-ambience-audit]]), and it is the single most common finding when auditing amateur edits.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Dialogue floor after repair | −60 dBFS RMS | −65 to −50 dBFS | Measured in pauses. Below −70 is digital black and reads as a fault. |
| Repair aggressiveness | conservative | — | Take 6–10 dB of broadband reduction, not 20. Beyond that, artefacts cost more than the noise. |
| Designed bed level | −22 dB rel. dialogue | −18 to −28 dB | Louder when the location is the point; quieter under dense narration. |
| Room-tone capture | 30 s per location | 20–60 s | Same mic, same position, same gain, everyone silent. |
| Bed layers | 2 | 1–3 | One wide base plus one sparse detail layer. Three is the ceiling before mush. |
| High-pass on dialogue | 100 Hz | 80–120 Hz | Removes rumble the bed will supply intentionally. |
| Bed loop length | ≥ 90 s | 90–180 s | Shorter loops are audible as recurring events. |
| Crossfade at bed edges | 0.5 s | 0.3–1.0 s | Equal-power; prevents an audible in/out ([[sfx-edge-fades-click-free]]). |

## Reproduction prompt
```
Rebuild this scene's sound as two independent layers: a clean dialogue stem and a
designed ambience stem. Do not attempt to fix the dialogue by making it sound more
like a location.

1. MEASURE the dialogue stem's floor in three pauses:
   ffmpeg -i {{DIALOGUE}} -ss {{PAUSE_TC}} -t 0.5 -af astats=metadata=1 -f null -
   Record RMS_level. If it is between -65 and -50 dBFS, DO NOT DENOISE - go to 3.
2. REPAIR CONSERVATIVELY, only if the floor is above -50 dBFS or a hum is present:
   ffmpeg -i {{DIALOGUE}} -af "highpass=f=100:poles=2,afftdn=nr=10:nf=-45" clean.wav
   Take 6-10 dB, no more. A/B the result against the original on the SIBILANTS:
   if "s" sounds watery or the tail of a word warbles, back the reduction off.
   Never denoise into silence - the target floor is quiet, not absent.
3. FETCH THE BED for the location named in the script or visible in the shot, using
   "<place> ambience" (see the ambience search note). Pull a base bed >= 90 s and,
   optionally, one sparse detail layer.
4. PLACE the bed as ONE clip spanning the whole scene - never one bed per shot - at
   {{AMB_DB}} dB (default -22) relative to dialogue, with 0.5 s equal-power fades at
   both edges, high-passed at 60 Hz and low-passed at 12 kHz if it is fighting the voice.
5. CARVE, do not duck: put the dialogue clips in the "voiceover" group and carve the
   bed against that group at strength 0.25.
6. VERIFY: play the scene with the bed muted and unmuted. Muted must sound EMPTY,
   not broken. Unmuted must not make a single word less intelligible.

ACCEPTANCE: inter-word floor varies by <= 2 dB across every cut in the scene; the
bed is one clip, not N; dialogue intelligibility is unchanged with the bed at level;
no denoising artefact is audible on any sibilant at 2x listening attention.
```

## Execution spec

**ffmpeg (this is the only place repair can happen).** The contract is explicit that **the HyperFrames audio engine has no noise removal**: `room-gate` *"does not remove noise — room tone under speech stays"*, and *"there is no fallback for hiss beneath the words."* So any denoise is a **raw-file operation producing a new `src`**, done before the file enters the composition:

```bash
# conservative broadband reduction + rumble cut, producing a new source file
ffmpeg -i vo-raw.wav -af "highpass=f=100:poles=2,afftdn=nr=10:nf=-45" vo-clean.wav

# measure the floor in a pause, before and after
ffmpeg -i vo-clean.wav -ss 12.4 -t 0.5 -af astats=metadata=1 -f null -
```

Then ledger the output (`resolve.mjs --from vo-clean.wav --type voice`). Keep the original: the vault mount cannot delete files, so treat every repair as a new file alongside the old one, never an overwrite.

**Epidemic Sound.** The bed is a normal fetch. `SearchSoundEffects` with `<place> ambience` — `traffic ambience`, `cafe ambience`, `office ambience`, `forest ambience`, `market ambience crowd` — and use `filter.duration.min` in **milliseconds** (`{"min": 90000}`) so the bed is long enough not to loop audibly. For a featureless interior the search word is **room tone**, not ambience; for crowd murmur it is **walla** ([[sfx-ambience-search-formula]]). `SearchSimilarToSoundEffect` keeps a multi-scene video's beds coherent.

**HyperFrames.** Two stems, two roles:

```html
<audio id="vo-1" src=".media/audio/voice/vo-clean.wav" data-audio-group="voiceover"
       data-start="0.5" data-track-index="10"></audio>

<audio id="amb-cafe" src="assets/sfx/cafe-ambience.wav"
       data-audio-group="ambience" data-start="0" data-duration="120"
       data-track-index="11" data-volume="0.08"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;a1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:60}}]}"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.2}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.5,&quot;v&quot;:1},{&quot;t&quot;:119.5,&quot;v&quot;:1},{&quot;t&quot;:120,&quot;v&quot;:0}]}]}"></audio>
```

Contract details that matter here: every `<audio>` needs an `id` or it is **never mixed → silent render**; the carve group must contain **voices only** (a bed inside the voice group poisons the next re-analysis silently); `data-fx-carve` is clip-only and belongs on the **bed**, never on a voice; and an automation lane **holds its first value backwards to the clip start**, which is why the `{"t":0,"v":0}` point is written explicitly. For the repair side, the useful in-composition presets are `voice-clean` (*"the default answer to 'fix this voiceover'"*), `rumble-cut` and `room-gate` — but check what a preset already contains before adding a job on top: *"`voice-clean` plus a Reduce Mud job is −6 dB at 250 Hz where −3 was meant."*

**Remotion.** Concept only: same two stems as two `<Audio>` elements; repair still happens offline in ffmpeg because the runtime has no restoration tooling either.

## Pairs with
[[sfx-missing-ambience-audit]] · [[sfx-ambience-search-formula]] · [[sfx-ambience-establishes-location]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-noise-floor-target]] · [[sfx-pause-removal-breath-and-room-tone]] · [[sfx-five-layers-build-order]] · [[sfx-dialogue-gate]] · [[sfx-foley-replacement-pass]]

## Failure modes
- **Buying a microphone to solve a layering problem.** The named error. A cleaner recording makes the emptiness worse.
- **Denoising until the dialogue is "clean".** Aggressive reduction produces watery sibilants and warbling word tails that are far more distracting than the noise was. Take 6–10 dB and cover the rest with the bed.
- **Denoising into digital black.** A −∞ floor is heard as the sound having failed, not as quiet ([[sfx-noise-floor-target]]). Leave a floor, or supply one.
- **One ambience clip per shot.** Produces a pumping bed that announces every cut. One clip spans the scene.
- **A bed loud enough to be noticed.** If a viewer could name the ambience without being asked, it is 4–6 dB too loud.
- **Putting the bed in the `voiceover` carve group** so it gets carved against itself, or carving a voice against itself — both are bugs the carve tooling will not warn you about.
- **Known gap - hiss under speech.** HyperFrames has no noise removal. ffmpeg **is** available (6.1.1, verified - see `_meta/execution-contract.md` §7A/§7B) and `afftdn` runs, but it trades detail for noise: pushed hard enough to kill hiss it also dulls consonants. `arnndn` would be the stronger tool and is compiled in, but **ships with no model** in this container, so `-af arnndn` fails to initialise unless you supply an `.rnnn` model yourself. If the source has audible hiss beneath the words, the honest answer is a better source, and saying so is the whole answer.
