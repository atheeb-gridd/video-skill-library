---
id: sfx-sound-pass-order
aliases: [sfx-sound-pass-budget]
title: Sound is half the video — budget it as ordered passes, not leftover time
skill: sound-design
type: structure
family: sound-workflow
tags: [skill/sound-design, type/structure, family/sound-workflow, engine/hyperframes, engine/epidemic, engine/ffmpeg, layer/dialogue, layer/ambience, layer/music, layer/sfx, layer/design, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:00"
    quote: "Most editors make really good visuals, but they leave the sound design for later. \"If there's time left we'll do it, otherwise not.\" Motion graphics is a must, sound isn't."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:06"
    quote: "I've already said this 50 times, that sound is 50% of the video."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:23"
    quote: "And layer number one of those is dialogue, or voiceover. First of all, if this itself is bad, then no amount of sound design is going to make a difference."
research_refs:
  - https://en.wikipedia.org/wiki/Post-production
  - https://en.wikipedia.org/wiki/Audio_post_production
  - https://en.wikipedia.org/wiki/Sound_editor_(filmmaking)
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://en.wikipedia.org/wiki/Sound_design
  - https://en.wikipedia.org/wiki/Room_tone
  - https://www.forte-ai.com/blog/audio-post-production-workflow-from-picture-handoff-to-final-mix
  - https://www.boomboxpost.com/blog/2022/4/26/step-by-step-audio-post-production-workflow
  - https://massive.io/workflow/audio-post-production-workflow/
  - https://www.documentary.org/feature/mix-practical-guide-navigating-post-production-audio-process
difficulty: medium
detectable_from: audio
---

# Sound is half the video — budget it as ordered passes, not leftover time

## What it is
The thesis note for this library, turned into a schedule. The failure it names is an **ordering** failure: motion graphics gets treated as mandatory and sound as leftover time — *"if there's time left we'll do it, otherwise not"* — so sound is always the thing that runs out of budget, and that inversion is why otherwise competent videos feel cheap. The fix has two halves: allocate sound roughly **half the post-production effort**, and spend it as **discrete ordered passes** rather than as continuous fiddling.

This mirrors how professional audio post is actually organised (handoff → session prep → spotting → dialogue edit → design/foley → music integration → premix → final mix → QC): after picture lock, *"the sound is spotted and turned over to the composer and sound designers"*, and the work is divided by role rather than done in one sweep.

**The schedule is five content passes, bracketed by two more.** The five layers this library is built on ([[sfx-five-layers-build-order]]) map one-to-one onto five passes run bottom up — **dialogue → ambience → foley/diegetic → effects → music** — with a **spotting pass** before them and a **mix pass** after. That is seven named rows in the build manifest. (Both counts are in circulation: "five passes" counts only the layer passes, "six" or "seven" counts spotting and mix as passes of their own. They describe the same sequence — what matters is that spotting and mix each get their own row and their own status field, because both get skipped when they are treated as steps inside another pass.)

**The ordering is load-bearing.** Every later pass is levelled against the dialogue, so dialogue goes first. Everything is levelled against a locked picture, so nothing starts before picture lock. And the mix needs all layers present, so it goes last. This note is the *schedule*; [[sfx-five-layers-build-order]] is the *model*.

## When to use it
At the start of every project, when the build manifest is written — and instantiate it the moment picture is locked. The sound section is not one row in the schedule; it is seven, and it begins when the cut is locked, **not** when the motion pass is finished.

Refuse to start before picture lock: a re-cut invalidates the spotting list, which is the pass's only durable artefact, and every placed sound is anchored to a timecode that is about to move.

Use it as a **triage tool** when time genuinely runs out. The passes are ordered by return, so cutting from the bottom (drop the design layer, then the foley pass) degrades gracefully, whereas cutting the dialogue pass wrecks everything above it.

Two conditions override it:
- **If the dialogue or voiceover recording is bad, stop.** *"If this itself is bad, then no amount of sound design is going to make a difference."* The stack has no noise removal to fall back on — `room-gate` closes the gaps between words but leaves noise under speech untouched — and the honest answer for audible hiss is a better source.
- **In a companionship or vlog format where the aesthetic *is* raw**, the ambience and foley passes shrink to almost nothing and the budget shifts to dialogue and mix. Say so in the design document rather than skipping passes silently.

## How to recognise it in a reference video
You are detecting whether the sound pass happened at all, and which layers got attention.

- **Layer census — the fastest single diagnostic in the vault.** For a 60-second sample, listen four times, once per layer, and mark presence: dialogue, ambience, foley, effects, music. **Read the result against the format**: a produced explainer with all five present has had a real sound pass, and under 4 of 5 means a layer was skipped; a talking-head or companionship video legitimately runs **2–3** layers — the source's own admission is *"in my own YouTube videos I only use 2 or 3 of these layers."* Five layers is the model, not the quota. Below 3 in a produced video, it will read as cheap regardless of the visuals.
- **Count layers in a quiet moment.** Solo a 5-second gap between sentences: dialogue-only means one pass was run; a floor plus a distant bed means two or three; a floor, a bed, plus a cloth or footstep detail means four or five.
- **Ambience continuity is the sharpest tell.** Between phrases, is there room tone, or digital silence?
  ```bash
  ffmpeg -i ref.mp4 -af "silencedetect=n=-45dB:d=0.30" -f null - 2>&1 | grep silence_
  ```
  Absolute silence in the gaps of an otherwise-produced video means **no ambience pass** — the second named sound-design mistake. A sounded video's gaps sit around **−45 to −60 dBFS**, not at the noise floor.
- **Spectrogram test:** a single-pass video shows a hard vertical edge at every cut where all sound stops and restarts together. A multi-pass video shows one or more continuous horizontal bands crossing the cuts.
- **Layer balance, measured.** Dialogue **0 to −3 dB**, effects **−12 to −15 dB**, music **−20 to −25 dB** relative to dialogue (loud rock/guitar beds to −30 dB), ambience **−28 to −38 dB**. Measure with a windowed RMS trace, comparing passages where each layer is isolated:
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=24000,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
- **Programme loudness.** `ffmpeg -i ref.mp4 -af ebur128=peak=true -f null -` — a delivered video sits near **−14 LUFS** for socials or **−16 LUFS** for podcast, true peak at or under **−1.5 dBTP**. A reading of −24 LUFS or +0 dBTP means no mix pass.
- **Dialogue quality is the tell for pass 1.** Consistent level between sentences, no room-tone jumps at edits, no plosives, and a consistent EQ/compression character across all A-roll including takes from different days. If dialogue level swings 6+ dB sentence to sentence, or the character varies per clip, no dialogue pass was run and everything above it is decoration.
- **Foley presence.** Footsteps, object handling, cloth. In creator content these are usually *absent from the recording and never re-added*; their presence is a strong signal of a deliberate pass.
- **Music discipline.** Does the bed ever stop? Does it change at section boundaries? Continuous unchanging music across a whole video is the signature of music dropped in at the end rather than integrated ([[sfx-music-sets-the-mood]]).
- **Ratio between styles.** Log every effect and classify it ([[sfx-three-types-classification]]). Motion effects with no diegetic layer sounds cheap; diegetic with no aesthetic layer sounds flat; effects on things that are not moving sounds cluttered. That ratio is the creator's sonic fingerprint and is worth recording in the profile.
- **Effect repetition.** The same effect recurring identically is the third named mistake, and it is audible within about a minute.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `sound_share_of_post` | 0.45 | 0.30–0.55 | Share of post-production effort allocated to sound. The source's claim is 50 %; treat 30 % as the floor below which the layer census will fail. |
| `gate` | picture lock | — | Hard precondition. Nothing in this pass survives a re-cut. |
| `pass_order` | spotting → dialogue → ambience → foley → effects → music → mix | fixed | Dialogue first because every other level is set against it; mix last because it needs all layers present. |
| `spotting_output` | a written list | — | `timecode \| layer \| style \| intent \| asset \| target level \| rule note id`. The pass's durable artefact and the only thing that survives into the next revision. |
| `prep_share` | 0.15 of the sound budget | 0.10–0.25 | Non-creative session prep — naming, grouping, track layout. Professional sessions spend 2–3 hours here on a typical project, up to half a day on complex material. |
| Pass 1 — dialogue | 25 % of the sound budget | 20–35 % | Level consistency, `voice-clean` preset, edit repair. Gate: if the source is bad, fix the source. |
| Pass 2 — ambience | 15 % | 10–20 % | One bed per location ([[sfx-ambience-search-formula]]). |
| Pass 3 — foley / diegetic | 20 % | 10–30 % | Footsteps, cloth, object interaction ([[sfx-diegetic-action-inventory]]). Skip for pure talking-head or screen-recording content. |
| Pass 4 — effects (motion + aesthetic) | 25 % | 20–35 % | [[sfx-motion-sound-selection]], [[sfx-cinematic-hit-emphasis]]. |
| Pass 5 — music | 15 % | 10–25 % | [[sfx-bpm-filter-first]]; the one layer that can carry a video alone. |
| Mix pass | separate, after all five | — | [[sfx-layer-volume-targets]] + carve + loudness. |
| `minimum_viable_set` | passes 1, 2, 5 | — | Dialogue + ambience + music is the honest floor. |
| `layers_present` — produced explainer | 5 | 4–5 | Per 60-second sample. |
| `layers_present` — talking head / companionship | 3 | 2–3 | The source's own working number. Not a defect in that format. |
| `dialogue_level` | 0 to −3 dB | — | The reference all other layers are set against. |
| `sfx_level` | −12 to −15 dB | — | Relative to dialogue. |
| `music_level` | −20 to −25 dB | −30 dB for loud rock/guitars | Relative to dialogue. |
| `ambience_level` | −30 dB | −28 to −38 dB | Present but never identifiable as a layer while dialogue plays. Bus fader `data-volume="0.04"` ≈ −28 dB, with clips below it. |
| `gap_floor` | −45 to −60 dBFS | — | Level in inter-phrase gaps. Digital silence is a defect. |
| `programme_loudness` | −14 LUFS | −14 socials · −16 podcast | True peak ≤ −1.5 dBTP. |
| `effect_density` | 1–4 effects / 10 s | — | Across the whole video, not per section ([[sfx-density-fatigue-audit]]). |
| `carve_strength` | 0.25 | 0.15–0.40 | Music-under-voice is a carve, not a duck. |
| `mix_check_devices` | 3 | 2–4 | Phone speaker, laptop speakers, headphones. Most viewing is on the worst of these. |

## Reproduction prompt

```
Plan and execute the sound work for this project as ordered passes on a locked
picture. Do not begin any pass before the one below it is complete, and do not
start until picture lock is signed off.

PASS 0a - GATE. Verify the dialogue/voiceover source is usable: listen to 30
   seconds of the quietest passage on headphones. If there is audible hiss or
   room noise UNDER the words, STOP and re-record - there is no noise removal in
   this stack and no pass below will fix it.

PASS 0b - SPOTTING. Watch the locked cut once, in real time, end to end, writing
   a single table: timecode | what is happening | layer (dialogue / ambience /
   foley / effects / music) | which of the three styles (diegetic / motion /
   aesthetic) | intent in one clause | asset to fetch | target level | rule note
   id. Every motion event in design-motion.md must appear as a row, even if the
   decision is "silent". PLACE NOTHING during this pass and fetch nothing. Output
   the list to the design document; it is the artefact everything else executes
   against.

PASS 1 - DIALOGUE. One consistent treatment across every A-roll take: remove
   rumble, reduce mud, even out loudness, add clarity, ceiling last. Normalise
   every voice file to I=-16 LUFS TP=-1.5 with a two-pass ffmpeg loudnorm. Set
   dialogue to 0 to -3 dB. Put every voice clip in data-audio-group="voiceover"
   and apply the treatment to the GROUP BUS, not to each clip. Do not apply a
   preset AND its component jobs - check what the preset already contains before
   adding an EQ move.

PASS 2 - AMBIENCE. One bed per location, continuous under everything, spanning
   the whole section and crossing every cut and every music drop-out, at -28 to
   -38 dB. Every inter-phrase gap must sit at -45 to -60 dBFS, never at digital
   silence. Ambience is what tells the viewer where they are.

PASS 3 - FOLEY / DIEGETIC. Sounds the scene would really make: footsteps, cloth,
   object handling, a phone, a door - only where something is visibly handled or
   a body visibly moves. These carry the realism. Skip entirely for
   screen-recording content.

PASS 4 - EFFECTS. Execute the spotting list's effects rows in style order:
   diegetic first (the ones that must exist for the shot to feel real), then
   motion, then aesthetic (hits, risers, textures) last and sparingly.
   -12 to -15 dB. Density budget: 1-4 effects per 10 s across the whole video.

PASS 5 - MUSIC. One bed per structural section, chosen for the section's
   intended mood, filtered by BPM before auditioning, instrumental wherever the
   host speaks, -20 to -25 dB (-30 for loud guitars). Carve the bed against the
   voice group at 0.25 rather than ducking it. Plan at least one deliberate
   silence.

PASS 6 - MIX. Set relative levels in the order dialogue -> effects -> music ->
   ambience. Run carve.mjs. Then measure programme loudness and normalise to
   -14 LUFS (socials) or -16 LUFS (podcast), true peak <= -1.5 dBTP. Check on a
   phone speaker, laptop speakers and headphones.

ACCEPTANCE TEST: (a) every row of the PASS 0b table is either executed or
explicitly marked "silent - <reason>", and no sound exists that is not on the
list; (b) layer census - pick any 60 seconds and confirm the layer count matches
the format (4-5 for a produced explainer, 2-3 for a talking head); (c) no gap
sits at digital silence; (d) measured levels match the table within 3 dB;
(e) programme loudness within 1 LU of target and true peak under -1.5 dBTP;
(f) on the phone-speaker check, every word is intelligible with the music in -
if not, raise the carve strength before lowering the bed; (g) the passes appear
as separate rows in the build manifest with their own status fields.
```

## Execution spec

**HyperFrames (the whole mix lives here).** Track layout is the session prep, and it is worth doing before any sound is placed. Convention: visuals on `0–9`, audio on `10+`; put each layer on its own band so the linter's overlap rules stay clear and so a whole layer can be muted with `data-hidden` on its group. Note `data-track-index` is **display-only** and *"constrains nothing"* — this is a convention for legibility, not a correctness rule, so a simple project can collapse the bands:

| Band | Layer | Group |
|---|---|---|
| 10 | dialogue / VO | `voiceover` |
| 11–12 | music beds | `music` |
| 13 | ambience | `ambience` |
| 14–16 | effects | `sfx` |
| 17 | foley | `foley` |

Make the buses real where a treatment belongs to several tracks — *"a compressor cannot ride a sequence it only hears a third of"*:

```html
<hf-audio-group id="voiceover" data-label="Voiceover" data-volume="0.95"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:100}},
    {&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Reduce Mud&quot;,&quot;params&quot;:{&quot;frequency&quot;:250,&quot;gain&quot;:-3,&quot;q&quot;:1.2}},
    {&quot;type&quot;:&quot;compressor&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;params&quot;:{&quot;threshold&quot;:-18,&quot;ratio&quot;:3}},
    {&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;n4&quot;,&quot;label&quot;:&quot;Add Clarity&quot;,&quot;params&quot;:{&quot;frequency&quot;:3000,&quot;gain&quot;:2.5,&quot;q&quot;:1}},
    {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n5&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></hf-audio-group>
<hf-audio-group id="ambience" data-label="Ambience" data-volume="0.04"></hf-audio-group>
<hf-audio-group id="sfx"      data-label="Effects"   data-volume="0.3"></hf-audio-group>
<hf-audio-group id="music"    data-label="Music"     data-volume="0.079"></hf-audio-group>
```
That voiceover chain is essentially the `voice-clean` preset written out; applying the preset instead is fine, but **do not apply the preset and then add its component jobs** — `voice-clean` plus a Reduce Mud job is −6 dB at 250 Hz where −3 was meant. Chain order doctrine: subtract before you add, level after you filter, character middle, **limiter last**.

Contract facts that shape the pass:
- **Membership is by `data-audio-group` on each clip.** Keep the `voiceover` group **voices only** — a bed or an effect inside it poisons the next carve re-analysis silently.
- **Every `<audio>` needs an `id`.** No id → never mixed → silent render, with no warning.
- A **bus's** automation clock is composition time; a **clip's** is clip-local, and a lane holds its first value backwards to the clip start.
- **`data-fx-carve` is clip-only** and lives on the bed, with `sources` naming a group (`audio_carve_ungrouped_sources`, `audio_group_carve_attr`). Run `node <SKILL_DIR>/scripts/carve.mjs --comp index.html` after the music pass; it needs `ffmpeg` on PATH and `@hyperframes/core` in the project, and it refuses when it cannot tell which track is the bed.
- **Write JSON attributes double-quoted with `&quot;`** — `carve.mjs` finds them with a `name="..."` regex and a single-quoted attribute is invisible to it, so the carve silently overwrites work it could not see.
- **In a modular project, keep all audio at the host root** so playback survives scene cuts, with visual segments as sub-compositions.
- **Almost no static gate covers the mix.** Lint reads `data-automation` for exactly two conflicts and validates nothing else; render refuses an unparseable chain outright while preview plays it **dry**. The mix pass therefore ends with a render-and-listen, not with `check`.
- Effects with a tail (reverb, delay) make a track **longer** than its `data-duration` — expected, not a bug.

**ffmpeg (measurement and delivery).** Pass 1 normalisation and the final measurement are the two ffmpeg legs. Two-pass loudness on the exported mix:
```bash
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=<i>:measured_TP=<tp>:\
measured_LRA=<lra>:measured_thresh=<th>:offset=<off>:linear=true mix.social.wav
ffmpeg -i mix.wav -af ebur128=peak=true -f null -           # verify
```
Bake a sidechain duck **only** for assets leaving the pipeline: `sidechaincompress=threshold=0.03:ratio=8:attack=200:release=400`. For the spotting table, `npx hyperframes transcribe talk.mp4` emits word-level timings you can spot against directly.

**Epidemic Sound (sourcing, per pass — not per moment).** The spotting list is the shopping list. Passes 2–5 each produce **one** fetch list; resolve every asset to a local file under `assets/audio/{voice,amb,sfx,bgm}/` before building. *"A missing sound discovered mid-render is a wasted render."*
- ambience: `SearchSoundEffects { query.term: "<location> ambience room tone loop", filter.duration { min: 20000 } }`
- foley: `SearchSoundEffects { query.term: "footsteps <surface>" / "cloth movement" / "object handling" }`
- effects: `SearchSoundEffects` per row, plus `SearchSimilarToSoundEffect` for variants
- music: `SearchRecordings { filter: { bpm: …, vocals: false } }` and `SearchSimilarToRecording` for the neighbouring section

Epidemic produces a file and stops; everything after is HyperFrames. Register downloads with `resolve.mjs --from <file> --type sfx` if you want them in the ledger.

**Known stack gaps to state in the design document rather than discover late:** no de-essing (`harsh-tame` is a broad cut centred a band too low — the honest fallback is a narrow `peaking` cut swept 5–9 kHz, Q 3–4, −3 to −5 dB), no tone-matching one track to another, **no noise removal**, no pitch-shift effect, and no automation at all on `compressor`/`limiter`/`gate`/`bitcrush` (automate a `gain` stage around them instead).

**Remotion:** the pass order is engine-independent — the same passes become layers of `<Audio>` components, and the ordering discipline has nothing to do with the renderer. No Remotion runtime in this project.

## Pairs with
[[sfx-five-layers-build-order]] · [[sfx-layer-volume-targets]] · [[sfx-ambience-search-formula]] · [[sfx-motion-sound-selection]] · [[sfx-bpm-filter-first]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-name-before-search]] · [[sfx-pause-removal-breath-and-room-tone]] · [[struct-stimulation-budget]] · [[sfx-music-sets-the-mood]] · [[sfx-music-audition-against-picture]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-riser-anticipation-build]] · [[pace-subtractive-first-pass]] · [[motion-look-finishing-pass]] · [[sfx-diegetic-action-inventory]] · [[sfx-three-types-classification]] · [[sfx-density-fatigue-audit]] · [[sfx-playback-verification-loop]]

## Failure modes
- **Budgeting sound as leftover time.** The failure the source names. What actually gets skipped is ambience and foley — the two layers that produce the feeling of a real place — so the video reads as cheap even with good graphics. Fix: allocate the hours up front and treat the layer census as a delivery requirement.
- **Starting before picture lock.** Every placed sound is anchored to a timecode that is about to move, and the spotting list has to be rewritten. Fix: gate the pass on lock, in writing.
- **Running the passes out of order.** Effects placed before the dialogue is normalised have to be re-levelled afterwards; ambience added after music is always fighting for the same space.
- **No spotting pass, or fetching per moment.** Placing sounds while watching produces a video that is loud in the first two minutes and bare afterwards, dozens of one-off searches, an incoherent palette, and no record of what was decided. Fix: write the list first, place nothing during the watch, fetch per pass.
- **Mixing before all layers exist.** Levels set against a missing ambience bed all move again once it arrives. Fix: mix last.
- **Digital silence in the gaps.** The most common single defect, and instantly recognisable. Fix: continuous ambience at −28 to −38 dB.
- **Treating five layers as a quota.** Two or three well-chosen layers beat five badly balanced ones, and the source's own videos run 2–3. The model tells you what is missing, not what is mandatory — but read it against the format before calling a 3-layer explainer finished.
- **Trying to rescue bad dialogue with design.** There is no noise removal in this stack: `room-gate` closes gaps but *"noise under speech is untouched"*. Say so and get a better source.
- **Ducking the music instead of carving it.** The bed loses all its presence and the mix goes hollow whenever anyone talks. Fix: carve at 0.25 against the voice group; if it sounds notched rather than quieter, the strength is too high.
- **Preset stacking.** `voice-clean` plus its component jobs doubles cuts that were meant once; two character presets stacked make a costume of a costume. Fix: inspect the chain before adding.
- **Trusting `check`.** Nothing validates chains or lanes, and a lint *error* elsewhere silently disables the layout and contrast audits so `check` reports a clean-looking `0 samples`. Fix: end the pass with a render and a listen on three devices.
- **Known gap:** the 45 % budget figure is a craft claim (the source says 50 %) with no published time-allocation study behind it; the professional stage list and the 2–3-hour session-prep figure come from audio-post workflow documentation for scripted/commercial projects, which is a heavier pipeline than creator long-form. Treat the pass *order* as reliable and the *share* as a planning prior.
- **Known gap:** the render leg cannot run on the authoring VM (linux ARM64, no sudo, browser-dependent render — the audio path runs in an `OfflineAudioContext` in a headless browser), so the mix pass has a mandatory hand-off to another host. Plan the schedule around one round trip per mix revision, and treat the composition plus assets, not the MP4, as the deliverable.
