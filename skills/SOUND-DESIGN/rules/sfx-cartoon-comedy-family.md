---
id: sfx-cartoon-comedy-family
title: The cartoon SFX family — a comedic register, and the beat each sound punctuates
skill: sound-design
type: sfx
family: cartoon
tags: [skill/sound-design, type/sfx, family/cartoon, engine/epidemic, engine/hyperframes, engine/ffmpeg, sfx/aesthetic, layer/sfx, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:04
    quote: "For slightly light-hearted or funny content, or to give that kind of feel, you can use these types of sound effects."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:10
    quote: "These include sound effects like boing, slide, whistle or pop. Adding them, you can elevate your humour even further."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:15
    quote: "disc scratch — my favourite"
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:22
    quote: "Practice — the more you explore, the more you learn. Or ask ChatGPT: \"funny name sound effects\"."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:10:04
    quote: "reverb, changing the pitch, or changing the duration — change all of these and you can make a unique number of variations out of one single sound effect"
research_refs:
  - https://en.wikipedia.org/wiki/Mickey_Mousing
  - https://en.wikipedia.org/wiki/Slide_whistle
  - https://en.wikipedia.org/wiki/Comic_timing
  - https://en.wikipedia.org/wiki/Habituation
  - https://motionarray.com/learn/royalty-free-music/cartoon-sound-effects/
  - https://www.epidemicsound.com/filmmaking/blooper-sound-effects/
  - https://www.audiosparx.com/sa/display/submain.cfm/soundGroup_iid.113
  - https://link.springer.com/article/10.1007/s12144-025-08405-7
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (cartoon-- shelf slugs and counts probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# The cartoon SFX family — a comedic register, and the beat each sound punctuates

## What it is
A whole tonal family — boing, pop, slide whistle, bonk/wobble, squish, muted "wah-wah" trombone, scratch, and the little musical stings — whose job is not to describe an event but to declare a **register**. Using one is a decision about what kind of video this is: light-hearted, self-aware, allowed to be silly. That is why the source frames it as content-level (*"for slightly light-hearted or funny content, or to give that kind of feel"*) rather than as a per-event choice, and why the family is nearly impossible to use once or twice — a single boing in an otherwise serious video reads as a mistake, while five across a comedic video read as a voice. Choosing this family is a **tonal commitment applied across the edit**, in the same way that picking two or three transition types is: once one boing has been heard, the video is in a cartoon register and a later attempt at gravity will fight it. They belong to the *aesthetic* class in the three-way SFX taxonomy ([[sfx-three-types-classification]]) — the viewer will not notice them individually, but will feel the tone they set — and they earn their keep only where the humour is **related to the material**, which is also the only kind of humour the instructional-video research supports.

The family's history is the reason it works at all: these are inherited conventions from cartoon scoring, where music and effects tracked action beat-for-beat — the technique named **Mickey Mousing**, first used in *Steamboat Willie* (1928) and standard through the Tom & Jerry / Looney Tunes era. The audience knows the vocabulary without being taught it. The slide whistle in particular is *"familiar as a sound effect (as in animated cartoon sound tracks, when a glissando can suggest something rapidly ascending or falling)"* — a pitch contour that means "up" or "down" with no picture at all.

The same history is the warning. Mickey Mousing was criticised almost immediately for literalism: Chuck Jones complained in 1946 that cartoon musicians were *"more concerned with exact synchronization or 'Mickey-Mousing' than with the originality of their contribution"*, and Cocteau called it *"the most vulgar technique used in film music."* Applied to editing: sounding every single gesture is the failure mode of this family, not its strength.

**The load-bearing craft distinction in this note:** cartoon accents are timed **opposite** to motion sounds, and *which* opposite depends on what the accent is anchored to. A motion sound *leads* its picture event by 0–4 frames because it is describing the movement. A comedic accent is a **reaction**, and reactions come after. Anchored to a **spoken** beat it lands 2–8 frames after the punch word, in the pause that comic timing already requires — *"a pause taken to allow the audience time to recognize the joke and react."* Put the sting on the punch word and you step on the joke; put it in the pause and you are the audience laughing. Anchored to a **visual** accent (an element popping on, a graphic bouncing) the reaction window is much tighter — 0–2 frames — because there is no word to avoid masking and a larger gap simply reads as late. See the `offset` rows in Parameters.

## When to use it
- **When the video's register is comedic or self-aware, and you are committing to it across the whole edit.** Decide once, at the top of the sound design, alongside the format budget in [[struct-stimulation-budget]].
- **On four specific comedic beats**, one sound each:
  - **The reaction / cutaway** — a scratch, a needle-off, or a musical stop when the video interrupts itself. This is the strongest member of the family and the presenter's own favourite.
  - **The punchline** — a short musical sting or a bonk, landing in the pause *after* the line.
  - **The absurd or bouncy assertion** — a boing on a scale pop, a springy graphic, an exaggerated number.
  - **Appearance and disappearance** — a pop on an element entering or vanishing (`cartoon--pop` includes *"Vanish"*, *"Pull Out, Release, Plop"*).
- **On rise and fall** — the slide whistle when something goes up or, more commonly, down. A pratfall, a plummeting graph, a "and then it all collapsed".
- **For the "punctuate a small visual" job in playful branding** — a pop under an appearing icon, a slide under something exiting. This is the visual-anchored variant, and it is the one that tolerates a higher count per minute.
- **Never mixed with the cinematic register in the same section.** A braam and a boing within ten seconds is tonal confusion; the viewer cannot tell whether to take the video seriously. Hits and risers plus boings reads as an editor with two style references and no decision ([[sfx-riser-anticipation-build]]). If both are genuinely needed, separate them by section, not by seconds.
- **Not on informational or emotional content**, and not in the intimacy formats — a cartoon accent under a sincere line actively damages it. Keep the family away from the credibility beats: a claim, an authority anchor or a price should never be scored by a cartoon effect. In a mostly serious video, the honest options are none at all, or exactly one, placed on a named joke.
- **Do not use it as a comedy generator.** A boing on an unfunny beat draws attention to the fact that nothing happened.

## How to recognise it in a reference video
- **Listen for the register before cataloguing individual sounds.** One boing is an accident; three or more distinct cartoon-family sounds in a video is a deliberate register. Log the *count and spread*, not just the presence.
- **Spot the family, not the file.** Non-realistic, pitched, short transients: a rubbery *boing*; a dry *pop*; a *slide* (whistle glissando) on an exit or a descent; a *wobble*/bonk on an impact; a *squish*; a comedy trombone on a failure; a vinyl *scratch* on an abrupt halt.
- **Spectral and envelope signatures:**
  - **boing** — a fast pitch-descending resonant tail, 190 ms–1.8 s, strong single fundamental sweeping down (often a jaw harp or spring).
  - **pop** — very short, 60–950 ms, broadband transient with almost no tail. The shortest members of the family (Epidemic's shelf includes files as short as **78 ms**).
  - **slide whistle** — a continuous glissando, 250 ms–3.1 s, a single narrow pitch trace visibly sliding on a spectrogram.
  - **scratch** — broadband noise with rapid amplitude and pitch modulation, 300 ms–1.5 s, often with a music stop on the same frame.
  - **musical sting** — pitched, harmonically rich, 1–4 s, recognisably an instrument or choir rather than a noise.
- **Duration is the giveaway.** Real cartoon one-shots are extremely short. A "comedy" sound over about 2 s is a bed, not a punctuation — long "erratic slide" and comedy-trombone beds run **12–25 s** and are a different device.
- **Beat mapping.** For each occurrence, log which comic beat it lands on: `setup` (rare — usually an appearing element), `reaction` (bonk, squish, wobble, scratch), `punchline/fail` (boing, trombone, sting), `exit` (slide). A video using the family well shows a clear bias toward punchline/fail and reaction; one using it badly sprays them on transitions.
- **Measure the offset, and expect it to be positive.** For speech-anchored accents, find the punch word's end in a word-level transcript and the accent's peak: expect **+2f to +8f (67–267 ms) after** the word ends. For visual-anchored accents, measure against the frame of the visual event: expect **0 to +2f**. Either way, if accents cluster *before* their anchor, the editor is using them as motion sounds and the comedy is not landing. Measure with a one-frame-resolution RMS trace (`n=1600` at 48 kHz).
- **Check the music at the same frame.** A scratch or needle-off is very often simultaneous with a music stop; the pair is one gesture. Log them together.
- **Density.** Count them per minute — and count the two anchor types separately, because they have different ceilings (see Parameters). Speech-anchored comedic accents sit at roughly **0.5–1.5 per minute**; above ~3/min you are looking at the Mickey Mousing failure. Counting the whole family including small visual punctuation, **1–4 per minute** is a comedic register and above about 8/min is the source's first named sound-design mistake — "a tick-tick-tick every other second in every other frame tires the viewer's brain within 2 or 3 minutes".
- **Repetition.** Check whether the *same file* recurs. The source's third named mistake is the same effect used again and again; two identical boings in one minute is audible and cheap ([[sfx-density-fatigue-audit]]).
- **Register consistency.** Count distinct cartoon sub-families used. **2–3 for the whole video** is a decision; six is a sound-effect drawer emptied onto the timeline. Also check for register clash: cinematic hits/risers co-existing with boings.
- **Variation technique.** Where the same sound recurs deliberately, listen for whether it was *varied* — pitched, reverbed, or trimmed to a different length. Audible variation on a repeated element is the signature of a deliberate sound pass.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `register_commitment` | whole video | section or whole video | Never per-moment. Mixing registers within ten seconds is the tonal failure. |
| `register_lock` | cartoon XOR cinematic | — | Never both families in one video. |
| `offset_speech_anchored` | +4f (+133 ms) after the punch word ends | +2f to +8f | **Reactions come after.** The inverse of the motion-sound lead. Needs a pause to land in. |
| `offset_visual_anchored` | +1f (33 ms) after the visual accent | 0 to +2f | The tighter window: no word to mask, so a larger gap just reads as late. Never before the accent. |
| `punchline_pause` | 8–15f (267–500 ms) of pause before the accent | 6–20f | Speech-anchored only. The comic beat must exist for the accent to land inside it. |
| `gain_reaction` | −10 dB (`data-volume="0.316"`) | −12 to −9 dB (0.251–0.355) | For accents that *are* the joke — scratch, sting, punchline boing. These are meant to be noticed. Still below dialogue. |
| `gain_punctuation` | −13 dB (`data-volume="0.22"`) | −12 to −15 dB (0.178–0.251) | For small visual punctuation — a pop under an appearing icon. Ordinary SFX-layer level; at reaction level these become the loudest amateur tell in the family. |
| `density_reaction_per_min` | 1.0 / min | 0.5–1.5 / min | Speech-anchored comedic accents. Above 3/min is Mickey Mousing. |
| `density_family_per_min` | 2 / min | 1–4 / min | The whole family including visual punctuation. Above 8/min is sound-effect overload. |
| `subfamilies_per_video` | 2 | 2–3 | Distinct cartoon sub-families (boing / pop / slide / scratch / trombone). |
| `distinct_samples` | ≥4 across the video | 3–8 | Never the same file twice within 90 s. |
| `min_spacing` | 45f (1.5 s) | 30–90f | Minimum gap between two cartoon effects; a punchline effect wants a clear 2 s neighbourhood. |
| `repeat_variation` | required after 1 reuse | — | Vary by pitch, reverb or duration before reusing a file. |
| `pitch_variation` | ±2 semitones between reuses | ±1 to ±5 st | Higher = lighter/faster, lower = heavier. **Must be baked** — see Execution spec ([[sfx-pitch-shift-weight-energy]]). |
| `boing_len` | 0.6 s | 0.19–1.8 s | Trim the tail with `data-duration` if it rings past the joke. |
| `pop_len` | 0.15 s | 0.06–0.95 s | Effectively an impulse. The shelf also holds a 5.1 s *"Pop, Vanish"* — a different device, not a pop. |
| `slide_len` | matched to the visual travel | 0.25–3.1 s | Length *must* match the movement it describes; direction must match too. |
| `scratch_len` | 0.8 s | 0.3–1.5 s | Pair with a music stop on the same frame. |
| `bed_len` | — | 12–25 s | Only for long comedy beds (erratic slide whistle, sad trombone tail). Not a one-shot. |
| `reverb_wet` | 0.10–0.15 | 0.05–0.30 | Small room so the effect is not obviously dry-sampled ([[sfx-reverb-glue]]). |
| `tail_fade` | 6f (0.2 s) | 0–12f | Only if the file's own tail is longer than the beat. |

## Reproduction prompt

```
Place a cartoon-family accent on the comedic beat at {{BEAT}} (composition
seconds, 30fps), where {{BEAT}} is the END of the punch word, or the frame of
the visual gag.

1. CHECK THE REGISTER FIRST. Does this video already carry at least two other
   cartoon-family sounds, or is this the moment the register is being
   established? If the video is otherwise cinematic or sincere - if it uses
   hits or risers anywhere - STOP: a lone cartoon accent reads as a mistake,
   not as a joke. If the beat is a claim, a credibility anchor, a price or a
   CTA, do not add one at all.
2. PICK BY BEAT, not by taste:
     interruption / self-aware cutaway -> scratch (+ music stop, same frame)
     punchline / fail / wrong answer   -> short musical sting, bonk, or
                                          comedy trombone
     absurd claim / bouncy graphic     -> boing or wobble
     element appears or vanishes       -> pop
     something rises or falls          -> slide whistle, direction matched
3. CLASSIFY THE ANCHOR. Is this accent reacting to a SPOKEN beat or
   punctuating a VISUAL one? It decides the offset, the level and the budget
   in steps 5, 7 and 9. When in doubt it is spoken.
4. FETCH IT. Epidemic SearchSoundEffects, filtering by tag slug rather than by
   free text where possible - verified slugs include cartoon--boing,
   cartoon--pop, cartoon--whistle, cartoon--musical, cartoon--impact,
   cartoon--vocal, cartoon--misc - and constrain duration:
   filter.duration { max: 2000 } for a one-shot. Sort by POPULARITY, audition
   the lqmp3 preview, then DownloadSoundEffect. Read the TITLE: the catalogue
   names the direction ("Up and Down", "Dives", "Vanish", "Teasing").
5. IF SPEECH-ANCHORED, VERIFY THE PAUSE EXISTS. There must be 8-15 frames
   (0.27-0.50s) of no speech starting at {{BEAT}}. If the next line starts
   sooner, either extend the pause by 10 frames or do not place the accent -
   an accent over the following line kills both.
6. FIND THE TRANSIENT INSIDE THE FILE. Confirm the peak's offset from an RMS
   trace; do not assume the file starts on its transient.
7. TIME IT AS A REACTION:
     speech-anchored -> peak at {{BEAT}} + 0.133s (4 frames after)
     visual-anchored -> peak at {{BEAT}} + 0.033s (1 frame after)
   data-start = target - PEAK_OFFSET_IN_SOURCE. Trim leading silence with
   data-media-start rather than guessing. Do NOT lead the beat; leading is for
   motion sounds.
   EXCEPTION: a slide whistle describing visible travel IS a motion sound -
   start it 0-2 frames BEFORE the movement and match its length to the travel.
8. SET GAIN: 0.316 (-10 dB) if the accent IS the joke; 0.22 (-13 dB) if it is
   small visual punctuation. Put it in an `sfx` audio group - never the
   voiceover group, which must contain voices only. Then check the next spoken
   word is still fully intelligible.
9. ADD A LITTLE REVERB (wet 0.10-0.15) so it belongs to the room rather than
   to the library.
10. GIVE IT SPACE. No other sound effect within 45 frames (1.5s) either side,
    and no music change on the same frame. A punchline effect must be the only
    effect in its neighbourhood or it is not a punchline effect.
11. IF THE SCRATCH ROUTE: put a hard music stop on the same frame - the music
    clip's volume lane last two points 5 ms apart, v:1 then v:0 - and restart
    the bed after the joke, or leave it out as a rest.
12. IF THIS FILE IS ALREADY USED, vary it before reusing: pitch by +/-2
    semitones (baked - there is no pitch-shift node in the composition audio
    rack), or add reverb, or trim it to a different length. Never place the
    identical file twice within 90s.
13. BUDGET CHECK. Count speech-anchored accents in the whole video: target 1
    per minute, hard ceiling 3 per minute. Count the whole family per minute:
    target 2, ceiling 4, hard overload at 8. If over, remove the weakest
    instead of adding this one. No more than 3 distinct sub-families in the
    video.

ACCEPTANCE TEST: (a) play the beat with picture at normal volume for someone
who has not seen it - they should smile or exhale at the accent, and should
not be able to tell you what the sound "was"; (b) the transient is AFTER its
anchor, within the window for its anchor type, never before; (c) play the
following sentence - if any word is harder to hear, the accent is too loud or
too late; (d) no other effect within 1.5s; (e) the density and sub-family
caps in step 13 hold; (f) no identical file repeats within 90s without
variation; (g) muting the effect makes the beat feel flatter, not cleaner - if
it feels cleaner, the beat was not funny and the effect was covering for it;
(h) scanning the whole video, the accents feel like a running voice rather
than a series of interruptions.
```

## Execution spec

**Epidemic Sound — the shelf slugs are verified, and the family is genuinely shelved as such.** Live probes, 2026-08-28:

| Shelf slug | What it holds | Verified |
|---|---|---|
| `cartoon--boing` | *"Cartoon, Boing, Jump, Spring"*, *"Action Jump, Boing, Jaw Harp"*, *"Spring Bounce, Many"* | **56 files** |
| `cartoon--whistle` | *"Cartoon, Whistle, Slide Whistle, Up and Down, Silly, Long, Dives"* (25.0 s), *"Slip, Trip, Up"* (0.33 s) | **101 files** |
| `cartoon--pop` | *"Pop, Small Lid"* (0.44 s), *"Pop, Vanish"* (5.1 s), *"Pull Out, Release, Plop"* (0.078 s), *"Pops x6"*, *"Ascending x4"* | present |
| `cartoon--musical` | *"Heavenly Choir"*, *"Success, Fanfare"*, *"Funny, Teasing"*, *"Suspense, Worried"* | present |
| `cartoon--impact` | *"Cartoon Comic Expressions, Piano Roll"* | present |
| `cartoon--vocal` | *"Quack, Short, Goofy"*, *"Teeth Chatter, Freezing, Comedy"* | present |
| `cartoon--misc` | *"Cash Register, Kaching, Money"*, *"Running, Start"*, *"Funny Toy Sound"* | present |
| `fight--impact` | *"Slap, Short, Fast, Cartoony"* — the bonk, filed under fight | present |

Adjacent useful shelves for playful UI beats are `user-interface--alert`, `beeps--general` and `games--video`.

```
# the reliable route: filter by shelf, then sort, then audition three
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ALL, values: ["cartoon--boing"] },
            duration: { min: 200, max: 1500 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }

# slide whistle, direction-matched: read the TITLE, it names the direction
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ALL, values: ["cartoon--whistle"] },
            duration: { min: 250, max: 3000 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }

# pops, for appearance and vanish
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ALL, values: ["cartoon--pop"] },
            duration: { max: 500 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }

# comedy trombone / fanfare stings
SearchSoundEffects { query: { term: "trombone failure sad" },
  filter: { tagSlugs: { matchType: ANY, values: ["cartoon--musical"] } } }

# the scratch: no dedicated shelf was confirmed - use the term search and read
# tags back off the results before committing a slug
SearchSoundEffects { query: { term: "record scratch vinyl stop" },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }
```

Then `SearchSimilarToSoundEffect { id }` on the one that worked — that is how you get four *distinct but related* comedic sounds instead of four unrelated ones, which is what makes the register read as a voice, and it is also the fastest way to build the *variation set* a repeated gag needs. Every node returns `audioFile.durationInMilliseconds` (use it to enforce the length rows), a `waveformUrl` and an `lqmp3Url` for auditioning. Download with `DownloadSoundEffect` into `.media/audio/sfx/` (or `assets/sfx/`). The catalogue's titles are the richest metadata in the whole system here: *"Up and Down"*, *"Dives"*, *"Vanish"*, *"Teasing"* tell you the beat the file is for.

Search-vocabulary note from the source: the family's names are the hard part, and the transcript's own advice is to ask a model for *"funny name sound effects"* and search those words. That is legitimate — but write the working query back into this note when it lands, per [[sfx-name-before-search]].

**HyperFrames — a reaction-timed one-shot, plus the paired music stop.**

```html
<!-- punch word ends at 96.20s; sting peaks 4 frames later; peak is 0.09s into the file -->
<audio id="sfx-sting-01" src=".media/audio/sfx/cartoon-sting.wav"
       data-audio-group="sfx"
       data-start="96.243" data-duration="1.20" data-track-index="15" data-volume="0.316"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Sit In Room&quot;,&quot;params&quot;:{&quot;size&quot;:0.4,&quot;damping&quot;:0.5,&quot;wet&quot;:0.10,&quot;dry&quot;:0.9}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:1.0,&quot;v&quot;:1},{&quot;t&quot;:1.2,&quot;v&quot;:0}]}]}"></audio>

<!-- scratch route: the bed dies on the same frame as the scratch -->
<audio id="sfx-scratch-01" src=".media/audio/sfx/vinyl-scratch.wav" data-audio-group="sfx"
       data-start="96.20" data-duration="0.80" data-track-index="15" data-volume="0.316"></audio>

<!-- visual-anchored punctuation: accent at 41.20s, transient 1 frame later,
     file has 40ms of leading silence so media-start trims it off -->
<audio id="sfx-boing-1" src="assets/sfx/cartoon-boing-fall-bounce.wav"
       data-audio-group="sfx"
       data-start="41.233" data-duration="0.93" data-media-start="0.04"
       data-track-index="13" data-volume="0.22"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Small Room&quot;,&quot;params&quot;:{&quot;size&quot;:0.25,&quot;damping&quot;:0.6,&quot;wet&quot;:0.15,&quot;dry&quot;:0.9}},{&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>
```
`96.243 = 96.20 + 0.133 (4f) − 0.09 (peak offset)`. Keep that arithmetic as a comment.

Contract points:
- **Seconds only** — 1f = `0.033`, 2f = `0.067`, 4f = `0.133`, 8f = `0.267` at 30 fps. There is no frame attribute.
- **Attributes are double-quoted with the JSON's own quotes as `&quot;`.** `scripts/carve.mjs` finds these attributes with a `name="..."` regex — a single-quoted attribute is **invisible to it** and a later carve will silently overwrite work it could not see.
- **Every `<audio>` needs an `id`.** An id-less one is never mixed → silent render, no warning.
- **`data-duration` is the tail trim.** A boing that rings 1.5 s when the joke needs 0.6 s gets `data-duration="0.6"` plus a short out-ramp; the source file is untouched.
- **`reverb` adds `chainTailSeconds`**, so the rendered clip outlives its authored duration — *"that is expected, not a bug"* — which for a comedic accent is usually fine but does mean the authored out-ramp is not the last thing heard.
- **Chain order is signal order**, and the limiter goes last as a ceiling.
- **`data-playback-rate`** (constant, `0.1..5`) is **pitch-preserved**, so it changes speed *without* the pitch shift this note wants. For a real pitch change, preprocess and place the derived asset; there is no pitch node in the FX registry.
- **Never put the accent in the `voiceover` group** — an SFX clip inside the carve group poisons the next carve analysis silently. `data-audio-group="sfx"`.
- **The music stop is a volume lane on the bed**, last two points 5 ms apart. Do not also GSAP-tween `volume` (`audio_volume_double_automation`: the lane wins silently).
- Timing to a visual event is the author writing the same number twice: there is no audio-follows-animation attribute. If the visual accent lives in a sub-composition at scene-local `t`, the root-level audio needs `data-start = t + the slot's data-start`.
- Track index 10+ for audio; two overlapping audio clips must not share one index (`duplicate_audio_track`).

**ffmpeg — the pitch-variant factory, which is how one asset becomes four.** Two of the source's three variation parameters (reverb, duration) are native to the composition; **pitch must be baked into a derived file**. Either route works:
```bash
# rubberband: formant-aware, length preserved. Preferred where the build has it.
ffmpeg -i boing.wav -af "rubberband=pitch=1.122"  boing.up2.wav   # +2 semitones
ffmpeg -i boing.wav -af "rubberband=pitch=0.891"  boing.dn2.wav   # -2 semitones

# asetrate+atempo: no rubberband dependency, same length, slightly more artefact
ffmpeg -i boing.wav -af "asetrate=48000*1.1225,aresample=48000,atempo=1/1.1225" boing.up2.wav
ffmpeg -i boing.wav -af "asetrate=48000*0.8409,aresample=48000,atempo=1/0.8409" boing.dn3.wav

# tape-style (pitch and speed together) - often more natural on cartoon material
ffmpeg -i boing.wav -af "asetrate=48000*1.122,aresample=48000" boing.tape.wav

# duration variation without re-pitching is just a trim, and needs no file at all:
#   use data-media-start + data-duration in the composition instead
```
`rubberband` exposes `tempo`, `pitch`, `transients`, `detector`. Register each derived file so it lands in the ledger like any other asset: `node <SKILL_DIR>/scripts/resolve.mjs --from boing.up2.wav --type sfx --project .`

**Remotion:** conceptually an `<Audio>` starting at `beatFrame + 4`, with a `volume` prop. Concept only; no Remotion runtime in this project.

## Pairs with
[[sfx-whip-crack-on-snap-cut]] · [[sfx-whip-on-punchline]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-reverb-glue]] · [[sfx-name-before-search]] · [[sfx-density-fatigue-audit]] · [[struct-stimulation-budget]] · [[sfx-music-hard-stop]] · [[sfx-silence-as-pattern-interrupt]] · [[sfx-synthetic-family-catalogue]] · [[sfx-second-sense-doctrine]] · [[cut-smash-cut]] · [[motion-emphasis-scale-step]] · [[sfx-unsounded-motion-audit]] · [[sfx-sound-pass-order]] · [[struct-presenter-aside-pattern-interrupt]] · [[struct-objection-character-cutaway]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-riser-anticipation-build]] · [[sfx-music-sets-the-mood]] · [[motion-list-item-marker-card]] · [[sfx-three-types-classification]]

## Failure modes
- **One cartoon accent in a serious video.** Reads as a mistake, not a joke, because the register was never established. Fix: three or more across the video, or none.
- **Using it to make something funny.** A boing on a flat beat announces that a joke was intended and missed. Fix: score existing humour; delete the effect if the beat is not funny with it muted.
- **Sounding every gesture.** This is Mickey Mousing, criticised since 1946 for exactly this — *"more concerned with exact synchronization … than with the originality of their contribution."* Fix: 1 reaction per minute, ceiling 3.
- **Landing the sting on the punch word.** It masks the word that is carrying the joke. Fix: 2–8 frames into the pause *after* it, and make sure the pause exists.
- **No pause to land in.** The accent collides with the next line and both are lost. Fix: extend the pause by 10 frames in the edit, or drop the accent.
- **Early transient.** A sound that arrives before its anchor reads as broken sync, not as comedy. Fix: place after, and trim the file's leading silence with `data-media-start` rather than guessing.
- **Overload.** The source's first named mistake: an effect every couple of seconds tires the viewer within 2–3 minutes. Fix: enforce both density caps, hold 45-frame spacing, and give punchline effects a clear 2-second neighbourhood.
- **Slide whistle in the wrong direction.** A rising whistle on a falling graph is instantly wrong to everyone, even people who could not name why. Fix: read the file's title — the catalogue names the direction — and check against the picture.
- **The same boing five times.** Named mistake number three in the source corpus, and the most audible. Fix: pitch-baked variants (±2 st), a reverb variant, a trimmed variant, or a `SearchSimilarToSoundEffect` set.
- **Too loud.** Cartoon effects are bright and transient-heavy; at dialogue level they are painful. Fix: use the gain row that matches the anchor type, limiter last in the chain.
- **Dry cartoon SFX over a real room.** They sound stuck on top of the video because they are the only element with no space. Fix: reverb wet 0.05–0.30.
- **Braam and boing in the same breath.** Tonal confusion; the audience does not know how to take the video. Fix: one register per section.
- **Cartoon SFX on credibility beats.** A pop under a price or a claim undermines it. Fix: keep the family away from anything the viewer is being asked to believe.
- **Assuming a pitch knob exists in the composition.** It does not; `data-playback-rate` preserves pitch and there is no pitch-shift node in the FX registry. Fix: bake the pitch variant and place the derived file.
- **Known gap:** no dedicated `scratch` shelf slug was confirmed in the live probe, so the scratch — the presenter's own favourite — currently needs a term search and a tag read-back before its slug can be recorded here. Fill it in the first time a project resolves it.
- **Known gap:** nothing validates the FX chain — *"nothing validates the chain or the effect lanes at all"* — and on **render** an unparseable chain fails the whole mix while **preview** plays it dry. A cartoon effect that sounds fine in preview and wrong in the render is almost always a chain that preview quietly bypassed.
