---
id: sfx-echo-on-cartoon-oneshot
title: Echo on a cartoon one-shot — the goofiness dial, and its dialogue budget
skill: sound-design
type: sfx
family: cartoon
tags: [skill/sound-design, type/sfx, family/cartoon, engine/hyperframes, engine/epidemic, engine/ffmpeg, sfx/aesthetic, layer/sfx, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:15
    quote: "You can also put echo on these sound effects to give them a slightly goofier feel."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:10
    quote: "These include sound effects like boing, slide, whistle or pop. Adding them, you can elevate your humour even further."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:10:04
    quote: "reverb, changing the pitch, or changing the duration - change all of these and you can make a unique number of variations out of one single sound effect"
research_refs:
  - https://en.wikipedia.org/wiki/Delay_(audio_effect)
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (cartoon family tag slugs probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Echo on a cartoon one-shot — the goofiness dial, and its dialogue budget

## What it is
For the cartoon family, echo is the tweak dial that pitch is for the whoosh family: it exaggerates the effect and pushes the register from "a sound happened" toward "this is a joke". Mechanically it is a **delay** — discrete repeats of the whole one-shot — not a reverb, which is a diffuse tail. The distinction matters because it is the *countability* of the repeats that reads as comic. One clean repeat is a punchline; a smooth wash is just space.

The version that works sits in **slapback** territory: 60–250 ms delay with little or no feedback, historically the vocal sound of 1950s rock-and-roll and, in comedy editing, the exact interval at which a boing or a pop turns cartoonish. Shorter than about 30–50 ms it stops being an echo and becomes *doubling* — thickening, not comedy. Longer than about 400 ms and the repeat reads as a second, separate event, which is usually wrong unless you want the gag to land twice.

The constraint the technique lives or dies on is the **dialogue budget**: an echoed one-shot is no longer 300 ms long, it is 300 ms plus its whole decay, and that decay lands on top of whatever the presenter says next.

**Style.** Filed `sfx/aesthetic` with the rest of the cartoon family ([[sfx-cartoon-comedy-family]]): the echo is there to make the moment funnier, not to describe a movement. The one-shot underneath it is often pinned to a motion event, and that placement follows [[sfx-peak-at-motion-midpoint]].

## When to use it
- **On a cartoon/comedy one-shot** — boing, pop, slide, whistle, disc scratch, plop — where the register is already light-hearted and you want more of it.
- **On the punchline of a joke or a self-deprecating aside**, where the sound is doing comedic punctuation rather than describing motion.
- **On a repeated gag's second or third appearance**, as the variation that stops the identical file being detected as a repeat — the source lists echo alongside pitch and duration as exactly this kind of variation generator.
- **Only where there is a speech gap to spend.** The full decay must fit inside it. If the next word arrives in 200 ms, there is no echo to add.
- **Never on a diegetic sound.** A door with a slapback on it is not a comic door, it is a mistake; the world does not echo on cue. Real objects dictate their sound ([[sfx-real-vs-invented-sound-rule]]).
- **Never on a motion sound whose job is sync.** The repeat de-syncs the accent from the movement — the brain binds the first transient to the picture and then hears two more events with nothing on screen.
- **Sparingly.** Echo is a strong register marker; two echoed one-shots in a minute is a style, five is a bit.

## How to recognise it in a reference video
- **Count the repeats in the waveform.** An echoed one-shot appears as **2–5 amplitude peaks of the same shape**, evenly spaced, each quieter than the last. Even spacing plus identical shape is the signature — a genuine second event is neither.
- **Measure the interval.** `peak₂_time − peak₁_time` in milliseconds:
  - **30–50 ms** → doubling, not echo. Reads as thickness; you will not consciously hear a repeat.
  - **60–250 ms** → slapback. This is the comic band.
  - **250–400 ms** → long slapback; the repeat is clearly a repeat.
  - **>400 ms** → reads as two events. Log it as deliberate only if the picture supports it.
- **Measure the decay ratio.** `peak₂ ÷ peak₁` in dB gives the feedback: about **−9 dB** per repeat is feedback ≈ 0.35; **−6 dB** is ≈ 0.5; **−3 dB** is ≈ 0.7 and will produce a long, obvious trail. More than about 4 audible repeats means feedback above 0.5 and is worth logging as a distinctive choice.
- **Check the tail against the transcript.** Take the last audible repeat's time and compare it to the next word's start in the word-level transcript. In competent work the tail ends **at least 3 frames (0.1 s) before** the next word. Overlap is the defect to look for, and it is audible as a slightly slurred first syllable.
- **Reverb vs delay.** Run the effect through a high-pass and look at the envelope: discrete peaks = delay; a smooth exponential ramp with no countable peaks = reverb ([[sfx-reverb-glue]]). Comedy uses the first; realism uses the second. Creators frequently use reverb and call it echo — log what is actually there.
- **Register cross-check.** Echoed one-shots should co-occur with other comedy markers — a jump-cut aside, a zoom punch-in, a caption gag, a record scratch. An echoed pop in an otherwise serious cinematic sequence is a tonal mismatch.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `delay_time` | 120 ms | 60–250 ms | The comic slapback band. Below 50 ms is doubling; above 400 ms reads as a second event. |
| `feedback` | 0.35 | 0.15–0.55 | HyperFrames' `delay` default. ≈ −9 dB per repeat at 0.35, giving 3–4 audible repeats. Above 0.6 the trail dominates the one-shot. |
| `mix` (wet/dry) | 0.35 | 0.20–0.50 | HyperFrames' default is 0.4. Below 0.2 the gag is inaudible; above 0.5 the repeats are louder than the joke. |
| `audible_repeats` | 3 | 2–5 | What you are actually designing. Derived: repeats to −40 dB ≈ `40 / (−20·log₁₀ feedback)`. |
| `total_tail` | 500 ms | 240–1000 ms | Derived: `delay_time × repeats_to_−60dB`, where `repeats_to_−60dB = 60 / (−20·log₁₀ feedback)` ≈ 6.6 at 0.35. At 120 ms that is ≈ 790 ms — measure it, do not assume the one-shot's own length. |
| `gap_required` | `total_tail + 0.10 s` | — | The speech gap the echo must fit inside. **This is the gate.** No gap, no echo. |
| `pre_gap_guard` | 3f (0.10 s) | 2–6f | Silence between the last audible repeat and the next word. |
| `level_after_echo` | 0.178 (≈−15 dB) | −17 to −13 dB | Drop the dry level 1–2 dB when adding echo: the repeats add perceived loudness even though the peak does not move. |
| `pitch_pair` | +2 st | 0 to +4 st | Echo plus a small pitch-up is the classic cartoon combination — lighter *and* bouncier. Beyond +4 st it sounds sped up. |
| `per_minute` | 1.5 | 0–3 | Echoed one-shots per minute. Above 3 the register stops being a punctuation and becomes the video's voice. |
| `filter_the_repeats` | high-pass 400 Hz | 200–800 Hz | Optional but good: filtering the wet path keeps the repeats from muddying the low mids where the voice lives. |

## Reproduction prompt

```
Add echo to the cartoon one-shot at {{EVENT}} (seconds, composition time) to
push it goofier - without smearing the next line.

1. CHECK THE GAP FIRST. Read the word-level transcript. Measure the silence
   from {{EVENT}} to the start of the next spoken word: {{GAP}} seconds.
   Compute the tail you are about to create:
     repeats_to_-60dB = 60 / (-20 * log10({{FEEDBACK}}))     # 6.6 at 0.35
     total_tail = {{DELAY_MS}} / 1000 * repeats_to_-60dB      # 0.79 s at 120 ms
   If total_tail + 0.10 > {{GAP}}, DO NOT add the echo at these settings.
   Either shorten delay_time, lower feedback to 0.2, or place the one-shot
   dry. A smeared next word costs more than the gag earns.
2. CONFIRM THE REGISTER. This must be a cartoon/comedy one-shot (boing, pop,
   slide, whistle, scratch, plop) or a punchline accent. If it is a diegetic
   object sound or a motion-sync sound, stop - echo is wrong for both.
3. SET THE DELAY on the one-shot's own clip, as an fx chain in signal order:
   delay { time: 120 ms, feedback: 0.35, mix: 0.35 } then a limiter at -1 dB.
   Optionally high-pass the whole clip at 400 Hz so the repeats stay out of
   the voice's low mids.
4. DROP THE DRY LEVEL by 1-2 dB (data-volume 0.178 instead of 0.211): the
   repeats add loudness the peak meter will not show you.
5. OPTIONAL PITCH PAIRING: +2 semitones, baked with ffmpeg, for the full
   cartoon register. data-playback-rate will NOT do this - it preserves pitch.
6. EXTEND THE CLIP WINDOW. A delay adds tail beyond data-duration
   (chainTailSeconds), so the rendered track runs longer than the authored
   clip. Author data-duration to the DRY length and expect the tail; do not
   put a volume ramp at the end and expect it to be the last thing heard.
7. ROTATE. If an echoed one-shot has already been used within the last 30
   seconds, use a dry one here instead. Echo is a punctuation mark, not a
   texture.

ACCEPTANCE TEST: play from 1 s before {{EVENT}} to 2 s after, twice. First
pass: you must be able to COUNT the repeats - 2 to 4 of them. If you cannot
count them, it is reverb, not echo, and the comic effect is absent. Second
pass: listen only to the next spoken word. Its first syllable must be as
clean as it was before you added the effect. If it is not, cut feedback to
0.2 and re-test.
```

## Execution spec

**HyperFrames — `delay` is a real node with real ranges.** From the FX registry: `delay` takes `time` 1–5000 ms (default 250, log, **automatable**), `feedback` 0.01–0.95 (default 0.35, automatable), `mix` 0–1 (default 0.4, automatable). Out-of-range values are clamped on read, so anything that parses is safe to realise.

```html
<audio id="sfx-boing-03" src="assets/sfx/motion/cartoon/motion_cartoon_boing_02.wav"
       data-audio-group="sfx"
       data-start="184.62"          <!-- peak lands on the gag frame -->
       data-duration="0.34"          <!-- DRY length; the delay tail runs past this -->
       data-track-index="24"
       data-volume="0.178"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Keep out of the voice&quot;,&quot;params&quot;:{&quot;frequency&quot;:400,&quot;poles&quot;:&quot;1&quot;}},
         {&quot;type&quot;:&quot;delay&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Goofy slapback&quot;,&quot;params&quot;:{&quot;time&quot;:120,&quot;feedback&quot;:0.35,&quot;mix&quot;:0.35}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>
```
Five contract facts that decide whether this works:
1. **Order is signal order.** High-pass before the delay filters the source that feeds the repeats; after the delay it filters the repeats too. Both are defensible — put it first for a cleaner comic tone, last to tame the trail. **Limiter last**, always.
2. **`chainTailSeconds`:** *"a bed with reverb no longer ends exactly at its `data-duration`; that is expected, not a bug."* The same is true of `delay`. So a `volume` automation ramp at the end of the clip **will not** be the last thing you hear — the tail continues past it. Do not try to fade a delay tail with a clip-local lane; shorten `feedback` instead.
3. **`delay.time`, `feedback` and `mix` are all automatable** (`target: "fx.n2.time"`, `"fx.n2.feedback"`, `"fx.n2.mix"`), with `t` in **clip-local seconds** and a lane that **holds its first value backwards to the clip start** — so an automated echo needs an explicit `t: 0` point or it starts already at its first authored value. A lane whose `nodeId` is typo'd is **pruned on read, silently**.
4. **Do not reach for the `slap-echo` or `dub-throw` presets here** unless you want their whole character: presets append their own nodes tagged `fromPreset` and are wrapped in a `presetAmount` blend. They are *"costumes"*, and the doctrine is *"do not stack two."* A three-node hand-built chain is more predictable for a 300 ms one-shot.
5. **Nothing validates the chain.** Lint reads `data-automation` for exactly two conflicts and *"nothing validates the chain or the effect lanes at all."* Render refuses an unparseable chain outright; **preview plays it dry**, which means a broken chain in preview sounds like "the echo didn't work" rather than an error. Check the escaping: double-quoted attribute with the JSON's quotes as `&quot;`, because `carve.mjs` finds these attributes with a `name="..."` regex and a single-quoted attribute is invisible to it.

**Epidemic Sound — sourcing the cartoon one-shot.** Verified live: the family lives under the `cartoon--*` slugs, and titles follow `Cartoon, <Subcategory>, <Descriptors>`.
```
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["cartoon--pop"]},
                              duration:{min:200,max:1200} },
                     sort:{by:POPULARITY,order:DESCENDING}, first:24 }
# other verified slugs in the family
#   cartoon--swish   (light fast passes)   cartoon--misc   (kaching, novelty)
#   cartoon--musical (stings, heavenly choir)
# the presenter's favourite, which lives OUTSIDE the cartoon category:
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["communications--phonograph"]},
                              duration:{min:400,max:2000} }, first:24 }   # "Vinyl, Record Scratch NN"
# term fallbacks: "cartoon pop small lid" · "cartoon pop mouth finger" ·
#   "cartoon boing" · "cartoon slide whistle" · "cartoon pop vanish"
SearchSimilarToSoundEffect { id:<uuid>, first:12 }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Fetch **dry** assets and add the echo in the chain rather than fetching a pre-echoed file — a baked echo cannot be shortened when the speech gap turns out to be 200 ms. If a title contains `Various` or `x6` it is a multi-hit compilation: use `data-media-start` to pick one hit out of it rather than downloading six files.

**ffmpeg — when the echo must be baked** (an asset leaving the pipeline, or a library variant you want to keep):
```bash
# slapback: 120 ms, ~35% feedback, 35% wet. aecho=in_gain:out_gain:delays_ms:decays
ffmpeg -i boing.wav -af "aecho=0.9:0.35:120:0.35" boing.slap.wav
# three explicit taps instead of feedback, for exact control of each repeat
ffmpeg -i boing.wav -af "aecho=0.9:0.4:120|240|360:0.5|0.25|0.12" boing.taps.wav
# echo + the classic cartoon pitch-up (+2 st = x1.1225), length preserved
ffmpeg -i boing.wav -af "asetrate=48000*1.1225,aresample=48000,atempo=0.8909,aecho=0.9:0.35:120:0.35" boing.goofy.wav
```
`aecho`'s `delays` are milliseconds and `decays` are linear gains; the multi-tap form is the more controllable of the two because you can see each repeat's level instead of deriving it. Then re-ingest with `resolve.mjs --from <file> --type sfx` so the variant is in the ledger and in `library.json`.

**Remotion:** conceptually an `<Audio>` plus a Web Audio delay node, or a pre-baked echoed variant. Concept only; no Remotion runtime here.

## Pairs with
[[sfx-cartoon-comedy-family]] · [[sfx-record-scratch-punctuation]] · [[sfx-reverb-glue]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-filter-character-and-distance]] · [[sfx-library-build-and-taxonomy]] · [[struct-stimulation-budget]] · [[sfx-name-before-search]] · [[sfx-whip-on-punchline]] · [[struct-presenter-aside-pattern-interrupt]] · [[struct-misspeak-correction-gag]] · [[sfx-real-vs-invented-sound-rule]] · [[sfx-layer-volume-targets]]

## Failure modes
- **The tail lands on the next word.** The one failure that actually costs the viewer something. Fix: compute `total_tail` from `delay_time` and `feedback` *before* placing, and check it against the transcript gap.
- **Using reverb and calling it echo.** A diffuse wash adds space, not comedy — the repeats have to be countable. Fix: `delay` node, 60–250 ms, not `reverb`.
- **Delay time under 50 ms.** That is doubling: the sound gets thicker and no funnier. Fix: 120 ms default.
- **Feedback above 0.6.** Six or seven audible repeats turn a punctuation mark into a novelty siren, and each one is a chance to collide with speech. Fix: 0.35, three or four repeats.
- **Fading the tail with a clip-local `volume` lane.** The delay's `chainTailSeconds` runs past `data-duration`, so the ramp is not the last thing heard. Fix: control the tail with `feedback`, not with a fade.
- **Echo on a diegetic sound.** A slapback door tells the viewer the room is a canyon. Fix: reverb for space, delay for jokes.
- **Echo on a motion-sync sound.** The extra transients have no picture attached and read as sloppy sync. Fix: dry, peak-aligned.
- **Stacking `slap-echo` on top of a hand-built delay.** Two echo characters at two intervals, which reads as a broken plugin. Fix: one echo mechanism per clip.
- **Every gag echoed.** The register stops being a marker. Fix: 1–2 per minute, and rotate with dry variants and pitch variants.
- **Known gap:** the 60–250 ms slapback band and the 30–50 ms doubling band are documented delay-engineering figures, not comedy-editing measurements — no source measures the delay time at which a cartoon one-shot becomes "funnier". Treat 120 ms as a tested starting point and the countable-repeats acceptance test as the real authority.
