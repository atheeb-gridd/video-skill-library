---
id: sfx-placement-discipline
title: Right place, not every place — the SFX placement gate
skill: sound-design
type: sfx
family: sfx-placement
tags: [skill/sound-design, type/sfx, family/sfx-placement, engine/hyperframes, engine/epidemic, engine/ffmpeg, layer/sfx, layer/design, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:03:36"
    quote: "What's the use of all this effort? — It pays off if you apply it in the right place. Don't just apply it everywhere"
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:09:11"
    quote: "a tick-tick-tick every other second in every other frame tires the viewer's brain within 2 or 3 minutes"
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:10:04"
    quote: "reverb, pitch change, duration change"
research_refs:
  - https://hearinghealthmatters.org/pathways-society/2015/unmasking-auditory-temporal-masking/
  - https://www.production-expert.com/production-expert-1/8-ways-to-prevent-frequency-masking-in-your-mixes
  - https://sfxengine.com/blog/common-sound-design-mistakes-in-video-editing
  - https://sonilo.com/blog/guides/transition-effect-sound-video-edits
  - https://blog.prosoundeffects.com/sound-layering
difficulty: medium
detectable_from: audio
---

# Right place, not every place — the SFX placement gate

## What it is
A per-event admission test that runs over a candidate SFX list and rejects most of it. The source states the economics plainly: all the sourcing, pitching and layering work only pays off *if it lands in the right place*, and blanket application destroys the benefit rather than diluting it. This note is the gate, and it is distinct from the two adjacent notes: [[struct-stimulation-budget]] sets the SFX-per-minute *census* for the format, [[sfx-unsounded-motion-audit]] generates the *candidate list* from motion events. This one decides, for each candidate, whether it earns its slot — using three tests that have nothing to do with density: does it have a job, is it far enough from its neighbours in **time**, and is it far enough from its neighbours in **frequency**.

**Style.** No `sfx/` style tag: the gate runs over the whole candidate list at once, and its time and frequency tests do not care which style a candidate came from — a diegetic click two frames from a motion whoosh fails on spacing exactly as two whooshes would.

## When to use it
Run it once, immediately after the motion audit produces its candidate list and before any file is fetched — rejecting a candidate is free, un-fetching one is not. Run it again after any recut. It is the pass that catches the two failures the census misses: a mix that is *within* budget but stacks three effects into one 300 ms window so none of them is heard, and a video where every effect is technically motivated but they all occupy 2–5 kHz and turn the mid band to mud. Use it especially on motion-graphics-heavy explainer work, where the candidate list from the motion audit is long and mostly automatic. Do **not** use it to prune diegetic sound: a sound that exists in the world of the shot is not a candidate, it is a requirement, and cutting it is what makes a video *"just can't feel real"*.

## How to recognise it in a reference video
- **Census first, then structure.** Count non-diegetic SFX and divide by runtime. Then — the part this note adds — plot them on a timeline and look at **spacing and clustering**, not just the count.
- **The onset trace, frame-aligned:**
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  `n=1600` at 48 kHz is one frame at 30 fps. An SFX onset shows as a step of **≥ 6 dB** within one or two frames. Log every onset and compute the inter-onset intervals.
- **Temporal spacing.** Auditory forward masking is strongest for gaps under **~50 ms** and still measurable out to **~200 ms**; backward masking falls off sharply past **~25 ms** and is essentially gone by **~100 ms**. Translated to frames at 30 fps: two effects inside **2 frames (67 ms)** of each other largely mask one another and read as one event; **6 frames (200 ms)** is the point at which two effects are cleanly separable. So the practical minimum spacing between two *distinct intended* effects is **6 f**, and anything inside 2 f should be treated as a single layered event, deliberately designed as one sound.
- **Frequency slotting.** For each pair of overlapping effects, note their dominant band using the rack's own vocabulary: 20–80 Rumble, 80–250 Weight, 250–600 Mud, 600–2000 Middle, 2000–5000 Presence, 5000–10000 Edge, 10000–20000 Air. Two overlapping effects in the same band mask each other; in a well-made reference the overlapping pairs sit in **different** bands — typically an impact in Weight plus a whoosh in Edge/Air.
- **The voice's band is reserved.** Presence (2–5 kHz) is where speech intelligibility lives. Count how many effects occupy it *while the presenter is speaking*. In a competent mix that number is close to zero; effects under narration sit in Weight or Air.
- **Repetition census.** Count how many times the *same file* appears. The named third sound-design mistake is the same effect repeated again and again; a reference that varies its whooshes (by pitch, duration or reverb) rather than repeating one is doing this pass.
- **Justification audit from the transcript.** For each effect, can you name what it is sounding? A transition, a specific animation, a specific object, a specific emotional beat? Effects you cannot justify are the ones that would fail this gate — and their share is the number worth logging.
- **Cluster test.** Slide a 1.0 s window across the onset list. In a mix that reads as clean, no window contains more than **3** distinct effects; 4+ in a second is where a mix starts reading as cluttered regardless of level.
- **Levels.** SFX at **−12 to −15 dB**, dialogue **0 to −3 dB**, music **−20 to −25 dB** are the practitioner numbers this creator teaches, and they match the ambience-at-−25-to-−40 figure from post references. An SFX census that is fine but whose effects sit at −6 dB will read as overload from level alone.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `min_spacing` | 6 f (200 ms) | 6–15 f | Minimum gap between two distinct intended effects. Below 2 f (67 ms) they mask and must be designed as one layered event. |
| `layer_window` | 2 f (67 ms) | 0–2 f | Onsets inside this window are one event, not two. |
| `cluster_ceiling` | 3 per 1.0 s | 2–4 | Distinct effects in any 1-second window. |
| `density_ceiling` | 6 per 10 s | 3–8 | Inherited from [[sfx-unsounded-motion-audit]]; this gate must not exceed it. |
| `max_layers_simultaneous` | 4 | 3–5 | Total simultaneous audio layers including dialogue, ambience and music. |
| `band_collision` | forbidden | — | Two overlapping effects must not share a dominant band. |
| `presence_under_voice` | 0 effects | 0–1 | Effects occupying 2–5 kHz while the presenter speaks. |
| `sfx_level` | −13 dB | −12 to −15 dB | Relative to dialogue at 0 to −3 dB. |
| `ambience_level` | −30 dB | −25 to −40 dB | Ambience is a layer, not an effect; it does not count against the census. |
| `repeat_limit` | 2 per file | 1–3 | Then vary it: pitch, duration or reverb. |
| `pitch_variation` | ±2 st | ±1 to ±4 st | For making one file into several. Baked, not in-composition. |
| `justified_share` | 1.0 | — | Every surviving effect names what it sounds. No exceptions; that is the gate. |

## Reproduction prompt

```
Run the SFX placement gate over the candidate list at 30fps. Reject, do not fetch.

1. INPUT: the candidate list from the motion audit, each row {time_f, event, proposed_sound}.
   Add every diegetic requirement (a sound that exists in the world of the shot) as a row marked
   REQUIRED - these bypass the gate entirely and are placed first.

2. TEST 1 - JOB. For each non-required candidate, write one clause naming what the sound is
   sounding: which transition, which animation, which object, which emotional beat. If the clause
   is "there was a cut here" or "it had been a while", DELETE the row. Nothing survives this gate
   without a job.

3. TEST 2 - TIME. Sort survivors by time, then:
   - onsets within 2 f (67 ms) mask each other: merge into ONE designed layered event (one dominant
     sound, the other as its low or high layer) or delete the weaker;
   - onsets 3-5 f apart: move one to >= 6 f (200 ms), or merge;
   - slide a 30 f window: where more than 3 distinct effects fall inside, keep the most specifically
     justified and delete the rest. Verify no 10 s window exceeds 6.

4. TEST 3 - FREQUENCY. Tag each survivor with its dominant band: RUMBLE 20-80 / WEIGHT 80-250 /
   MUD 250-600 / MIDDLE 600-2000 / PRESENCE 2000-5000 / EDGE 5000-10000 / AIR 10000-20000.
   - two effects that overlap in time must not share a band. Re-tag one by choosing a different
     sound, or shape it with a highpass/lowpass so its dominant band moves;
   - NO effect may occupy PRESENCE while the presenter is speaking. Move it to WEIGHT or AIR, or
     move it into a gap in the narration.

5. TEST 4 - REPETITION. Count uses per file. Past 2 uses, vary the third: pitch it +/- 2
   semitones, change its duration, or add reverb. Never place the same untouched file a third
   time.

6. PLACE the survivors at -13 dB (range -12 to -15) against dialogue at 0 to -3 dB and music at
   -20 to -25. Ambience sits at -25 to -40 and is not counted.

7. ACCEPTANCE TEST: (a) every surviving row has a one-clause job; (b) no two onsets within 6 f
   unless merged as one event; (c) no 1 s window over 3 effects, no 10 s window over 6; (d) no
   overlapping pair shares a band; (e) zero effects in PRESENCE under narration; (f) no file used
   more than twice unmodified; (g) play three minutes and count the effects you NOTICE - more than
   a third means the level or the count is too high. Report the rejection count; under a third of
   non-required rows rejected means you did not run the gate.
```

## Execution spec

**HyperFrames (primary).** Each effect is one `<audio>` clip. The gate's outputs are the clip's `data-start`, its `data-volume`, and — for the band re-tagging — its `data-fx-chain`.

```html
<audio id="sfx-swipe-04" src="assets/sfx/whoosh-short.wav" data-audio-group="sfx"
       data-start="41.20" data-duration="0.55" data-media-start="0.06"
       data-track-index="12" data-volume="0.22"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Move To Air&quot;,&quot;params&quot;:{&quot;frequency&quot;:2800,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"></audio>
```

- **Band re-tagging is a filter, and it is the cheapest fix in the pass.** `highpass` (frequency 20–20000, default 300, `poles` 1 = 6 dB/oct or 2 = 12 dB/oct) pushes an effect's dominant band up out of a collision; `lowpass` (default 8000) pushes it down and makes the sound *"muffled and dampened"*; a `peaking` cut carves a specific overlap. Chain order is signal order, and the doctrine is *"subtract before you add, level after you filter, relationships after level, character and ceiling last"* — limiter last.
- **`data-volume` is linear.** −13 dB ≈ `0.224`; −12 dB ≈ `0.251`; −15 dB ≈ `0.178`. Default `1` = 0 dB, max `3.98` = +12 dB.
- **Group every effect as `sfx`,** never `voiceover`. A non-voice clip inside the carve group silently poisons the next carve re-analysis. Ambience gets its own group.
- **A shared bus is the right home for a whole family of effects:** `<hf-audio-group id="sfx" data-volume="0.9" data-fx-chain="…">` gives one chain, one fader and one automation clock for every member — and a bus's automation `t` is **composition time**, unlike a clip's clip-local `t`. That is also the only clean way to put a single limiter across all effects. Note `data-fx-carve` may **never** go on a bus (`audio_group_carve_attr`).
- **Every `<audio>` needs an `id`** — id-less audio is never mixed and renders **silent**, with no warning. In a pass that places dozens of clips this is the single most likely silent failure.
- **Overlapping effects must not share a `data-track-index`** (`duplicate_audio_track`). With a cluster ceiling of 3, reserve indices 12/13/14 for effects and rotate.
- **Pitch variation must be baked.** There is **no pitch shifter** in the FX registry and `data-playback-rate` is explicitly *pitch-preserved*, so the ±2-semitone variation is an ffmpeg step, below.
- **Reverb has a tail** — the mix is told how much via `chainTailSeconds` — so a reverbed effect ends **later** than its `data-duration`. Factor that into the spacing test: a 0.4 s effect with a 0.6 s reverb tail is a 1.0 s occupancy.
- **Nothing validates the chain.** Lint reads `data-automation` for exactly two conflicts and *"nothing validates the chain or the effect lanes at all."* Render refuses an unparseable chain; preview plays it dry. Write the JSON **double-quoted with `&quot;`** — `carve.mjs` finds these attributes with a `name="..."` regex and a single-quoted attribute is invisible to it.

**ffmpeg — the variation trick.** The source's three parameters (reverb, pitch, duration) map to: reverb in-composition, duration in-composition via `data-duration`/`data-media-start`, pitch baked here:
```bash
# -2 semitones: ratio 2^(-2/12)=0.8909, tempo compensated by 1/0.8909=1.1225
ffmpeg -i whoosh.wav -af "asetrate=48000*0.8909,aresample=48000,atempo=1.1225" whoosh.-2.wav
# +2 semitones: asetrate=48000*1.1225 , atempo=0.8909
```
Keep these derived files outside the vault mount, which cannot delete files.

**Epidemic Sound.** The gate runs **before** fetching, so the fetch list is already pruned. When variation is needed, prefer a genuinely different file over a pitched copy: `SearchSimilarToSoundEffect({ id: "<uuid>", first: 10 })`. Constrain duration hard so a candidate cannot violate the spacing test by being long: `SearchSoundEffects({ query: { term: "short whoosh transition" }, filter: { duration: { max: 700 } }, first: 12 })`. For a band-specific pick, put the band in the query term — "low impact thud", "high air swish", "mid click" — rather than fetching a full-range sound and filtering it down.

**Remotion:** one `<Audio>` per surviving row with `volume` and `startFrom`; concept only.

## Pairs with
[[sfx-unsounded-motion-audit]] · [[struct-stimulation-budget]] · [[sfx-sound-pass-order]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-riser-anticipation-build]] · [[sfx-riser-to-music-drop-backtiming]] · [[cut-on-action]] · [[pace-visual-change-clock]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-density-fatigue-audit]] · [[sfx-search-vocabulary]]

## Failure modes
- **Sounding every candidate.** The motion audit's output is a candidate list, and treating it as a work order produces the tick-every-other-second mix that exhausts a viewer inside two or three minutes. Correction: reject at least a third; the rejection count is the pass's evidence.
- **Two effects inside two frames.** They mask each other, so you paid for two and got one muddier one. Correction: either 6 frames apart or deliberately designed as one layered sound.
- **Everything in the same band.** Six well-motivated effects all living in 2–5 kHz make a mix that is quiet, correct and unlistenable. Correction: tag bands, and move one side of every overlap with a highpass or lowpass.
- **An effect in the voice's band under narration.** Intelligibility drops and the viewer works harder without knowing why. Correction: move it to Weight or Air, or move it into a gap.
- **The same file five times.** Named as the third sound-design mistake. Correction: vary by pitch, duration or reverb — or fetch a similar file, which is better.
- **Cutting diegetic sound to hit a budget.** Removing the phone ringing because the census was full makes the video feel fake, which is the exact failure the whole layer exists to prevent. Correction: diegetic sounds are REQUIRED rows and bypass the gate; prune aesthetic effects instead.
- **Forgetting the reverb tail in the spacing maths.** A reverbed hit occupies far longer than its clip duration and collides with the next effect. Correction: count occupancy, not duration.
- **Silent render from a missing id.** Dozens of clips placed and one has no `id`; it never enters the mix and nothing warns you. Correction: id every audio element, and diff the placed count against the surviving-row count.
- **Known gap:** this stack has no spectrum analyser and no automatic band tagging. The dominant-band tag for each effect is a listening judgement (or read off the file's own name and Epidemic tags) and must be logged as human-assigned. `astats` gives level and onsets but not spectral content, so TEST 3 is the least automatable step in the pass.
