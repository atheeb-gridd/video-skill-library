---
id: sfx-bass-drop-under-impact
title: Layer a bass drop under the impact for weight
skill: sound-design
type: sfx
family: impact
tags: [skill/sound-design, type/sfx, family/impact, engine/epidemic, engine/hyperframes, engine/ffmpeg, sfx/aesthetic, layer/design, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:06:11
    quote: "And to give a bit heavier impact, you can also layer a bass drop with this impact - that thing, the bass drop."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:06:04
    quote: "Hit and impact sound effects - these make moments quite powerful."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:07:31
    quote: "You can also add reverb in between to give it more impact."
research_refs:
  - https://en.wikipedia.org/wiki/Sub-bass
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
difficulty: medium
detectable_from: audio
---

# Layer a bass drop under the impact for weight

## What it is
Impacts are built by **stacking bands, not by turning one file up**. A cinematic hit carries its identity in the mid and high frequencies — the crack, the metal, the transient — and physically cannot supply the low-end weight that makes a moment feel heavy. A separate sub/bass drop under it supplies that weight. The two layers work because they occupy different parts of the spectrum: sub-bass runs from roughly **20 Hz up to about 70 Hz**, a region where hearing is least sensitive and where notes are *felt more than heard*, while the hit lives from 200 Hz upward. Stacking across bands adds size; stacking two mid-heavy impacts only adds mud.

The move has three parts, and skipping any of them is what makes stacked impacts sound worse than a single one: carve the low end **out** of the hit so the sub owns the bottom, align the sub's onset to the hit's transient, and put a ceiling on the pair.

## When to use it
- **On the single biggest moments in the video** — the reveal, the thesis line landing, the number, the before/after flip, the end of a riser. The bass drop is a scarcity effect: it means "this is the important one", and it means nothing if everything gets it.
- **After a riser.** Riser builds, hit releases, sub carries the weight of the release. This is the canonical sequence.
- **On a hard physical impact on screen** — a hand slam, a book dropping, a door — where the diegetic sound alone reads as thin. Here the sub is doing aesthetic reinforcement of a diegetic event.
- **On a smash cut from loud to quiet**, where the sub's tail becomes the last thing heard before the silence.
- **Not on ordinary transitions.** A whoosh does not need a sub. A sub on every cut is exhausting and destroys the mix's headroom.
- **Not more than about once a minute.** More often and the impacts stop being impacts.
- **Not when the deliverable is phone-first and nothing else carries the weight** — see the failure modes; a phone speaker reproduces almost nothing below 200 Hz, so a moment whose entire weight is sub will land as a moment of near-silence.

## How to recognise it in a reference video
- **Split the bands and compare.** The signature of this technique is energy in two separate places at the same instant:
  ```bash
  ffmpeg -i ref.wav -af "lowpass=f=80,astats=metadata=1:reset=0.05,ametadata=print:key=lavfi.astats.Overall.Peak_level:file=sub.txt"  -f null -
  ffmpeg -i ref.wav -af "highpass=f=800,astats=metadata=1:reset=0.05,ametadata=print:key=lavfi.astats.Overall.Peak_level:file=hi.txt" -f null -
  ```
  A layered impact shows a **high-band transient** and, within 0–4 frames, a **sub-band swell 5–20 dB above the surrounding floor** that then decays over 1–3 seconds. A single unlayered impact shows the high-band transient with little or no sub excursion.
- **Measure the offset.** `sub_onset_frame − hit_transient_frame` is normally **0 to +2 frames**. A sub that starts *before* the hit gives the moment away and reads as a mistake unless it is deliberately a riser.
- **Measure the decay.** Sub tail typically **1.0–3.0 s**, considerably longer than the hit's 0.3–1.0 s. If both end together, it is one file, not two layers.
- **Check whether the hit was high-passed.** In a well-built stack the impact layer itself has little energy below ~100 Hz, so the sub band is clean. If both layers have low-end, expect a level jump and a muddier result — audible as the impact "swallowing" the dialogue around it.
- **Look at the master's peak behaviour.** A stacked impact without a ceiling shows peaks 6–12 dB above the surrounding programme, often clipped flat. A properly limited one shows the same perceived size with peaks controlled.
- **Count them.** Log bass drops per ten minutes. Reference videos that use them well typically show **3–8 per ten minutes**, clustered at structural high points, not spread evenly.
- **Transcript signal:** the line under a bass drop is nearly always the section's most important sentence. Cross-check; if it isn't, the effect is decorative in that reference.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `sub_band` | 30–60 Hz fundamental | 20–70 Hz | The sub-bass region: felt more than heard, hearing least sensitive here. Below ~25 Hz it is inaudible on almost every playback system and only eats headroom. |
| `hit_highpass` | 110 Hz | 80–140 Hz | Cut the low out of the impact layer so the sub owns the bottom. The single most important parameter in this note. |
| `punch_band_retained` | 120–220 Hz in the hit | — | Do **not** high-pass the hit above ~140 Hz: this band is what survives on a phone speaker and carries the weight when the sub is inaudible. |
| `sub_offset` | +1f (33 ms) after the hit transient | 0 to +2f | A 30 Hz cycle is 33 ms long, so a sub physically cannot have a sharp attack; aligning its onset to the transient puts its perceived peak 2–4 frames later, which is correct. |
| `sub_level` | −4 dB relative to the hit's peak | −8 to −2 dB | The sub adds far more peak level than perceived loudness. Set by ear against the hit, then check the meter. |
| `hit_level` | 0.251 (−12 dB rel. dialogue) | 0.211–0.316 (−13.5 to −10 dB) | Impacts sit at the loud end of the effects band. |
| `sub_length` | 1.8 s | 1.0–3.0 s | Longer than the hit. Fade the last 25% to zero. |
| `hit_length` | 0.7 s | 0.3–1.2 s | |
| `layers` | 2 | 2–3 | A third layer is allowed only if it occupies a third band (e.g. a short 3–8 kHz "crack"). Never two subs — they phase-cancel. |
| `bus_limiter` | `limit: −1 dB` | −3 to −0.5 dB | On the `sfx` bus, last in the chain, as a ceiling. |
| `reverb_wet` | 0.20 | 0.10–0.30 | On the hit only, never on the sub — reverb on a sub is mud with a tail. |
| `per_10min` | 5 | 3–8 | Scarcity is the effect. |
| `min_spacing` | 45 s | 25–120 s | Two bass drops close together halve each other. |

## Reproduction prompt

```
Build a layered impact at {{EVENT}} (seconds, composition time).

1. CONFIRM THIS MOMENT DESERVES IT. A bass drop is for the biggest beat in
   the section. If there is another one within 45s, do not place this one -
   pick which of the two matters more.
2. FETCH TWO FILES, not one:
   layer A - the hit: search "cinematic impact" (or "metal impact" / "wood
   impact" if the picture names a material), duration 300-1200 ms.
   layer B - the sub: search "sub drop" / "bass drop" / "sub boom",
   duration 1000-3000 ms.
3. FIND EACH FILE'S PEAK OFFSET from its head. Place layer A so its peak
   lands on {{EVENT}}. Place layer B so its ONSET lands on {{EVENT}} + 0.033
   (one frame later). Do not align the sub's peak - a sub has no sharp peak.
4. HIGH-PASS LAYER A at 110 Hz. This is not optional: without it both layers
   fight in the same band and the stack sounds smaller than the hit alone.
   Do NOT high-pass above 140 Hz - the 120-220 Hz punch is what survives on
   a phone speaker.
5. SET LEVELS: layer A at 0.251 (-12 dB rel. dialogue). Layer B 4 dB below
   layer A's peak. Give layer B a volume lane that fades its final 25% to
   zero.
6. PUT A CEILING ON THE PAIR. Add a limiter with limit -1 dB as the LAST
   node on the sfx bus, not on either clip.
7. Optional: reverb wet 0.20 on layer A only. Never on layer B.

ACCEPTANCE TEST: (a) mute layer B - the hit alone must still make sense, and
the moment must still land, just smaller. If muting B leaves nothing, A is
wrong. (b) Unmute and confirm the pair reads as ONE sound, not two. If you
hear two events, reduce the offset toward 0 frames. (c) Check the master
peak does not exceed -1 dBFS. (d) Play it back on a phone speaker or with a
200 Hz high-pass on the master: the moment must still land. If it vanishes,
you removed the punch band from layer A.
```

## Execution spec

**HyperFrames — two clips, one bus, one ceiling.**
```html
<!-- layer A: the hit. Peak lands on the event; low end carved out. -->
<audio id="sfx-hit-reveal" src="assets/sfx/cinematic-impact-07.wav"
       data-audio-group="sfx"
       data-start="62.84"          <!-- event 63.00 minus the file's 0.16s peak offset -->
       data-duration="0.80"
       data-track-index="24"
       data-volume="0.251"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Make Room For Sub&quot;,&quot;params&quot;:{&quot;frequency&quot;:110,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
         {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;size&quot;:0.55,&quot;wet&quot;:0.2,&quot;dry&quot;:0.9}}]}"></audio>

<!-- layer B: the sub. Onset one frame later; no reverb; long fade out. -->
<audio id="sfx-sub-reveal" src="assets/sfx/sub-drop-02.wav"
       data-audio-group="sfx"
       data-start="63.033"
       data-duration="1.80"
       data-track-index="25"
       data-volume="0.158"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Sub Only&quot;,&quot;params&quot;:{&quot;frequency&quot;:120,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:1.35,&quot;v&quot;:1},{&quot;t&quot;:1.80,&quot;v&quot;:0}]}]}"></audio>

<!-- the ceiling: one limiter for the whole effects layer -->
<hf-audio-group id="sfx" data-label="Effects" data-volume="1"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
    {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;g1&quot;,&quot;label&quot;:&quot;Effects Ceiling&quot;,&quot;params&quot;:{&quot;limit&quot;:-1,&quot;attack&quot;:5,&quot;release&quot;:80}}]}"></hf-audio-group>
```

Contract points that bite:
- **Different `data-track-index` for the two layers.** They overlap in time, and two `<audio>` sharing an index while overlapping raises `duplicate_audio_track`.
- **Chain order is signal order, limiter last.** The doctrine is *"Subtract before you add, level after you filter, relationships after level, character and ceiling last."* The limiter belongs on the **bus**, not on either clip — a limiter on one layer cannot see the sum, and the sum is what clips.
- **`limiter` has zero automatable parameters** (it is an AudioWorklet configured wholesale), as do `compressor`, `gate` and `bitcrush`. If you need a moving ceiling, automate a `gain` stage around it.
- **`reverb` adds `chainTailSeconds`**, so the hit rings past its `data-duration`. Expected. It is also why the reverb goes on the hit and not the sub: a reverberant sub is an unbounded low-frequency smear.
- **Out-of-range FX params are clamped on read**, so nothing you write here can fail to parse — but nothing validates the chain either. **Render refuses an unparseable chain; preview plays it dry.** A chain typo therefore sounds *fine* in preview and different at render.
- **`data-volume` maxes at 3.98 (+12 dB)** — if you find yourself near it, the source file is too quiet; fix it upstream.

**Epidemic Sound — two searches, and the second one is the one people skip.**
```
# layer A - the hit
SearchSoundEffects { query:{term:"cinematic impact"},  filter:{duration:{min:300,max:1200}},
                     sort:{by:POPULARITY, order:DESCENDING}, first: 20 }
SearchSoundEffects { query:{term:"metal impact"},      filter:{duration:{min:300,max:1200}} }
SearchSoundEffects { query:{term:"wood impact"},       filter:{duration:{min:300,max:1200}} }
SearchSoundEffects { query:{term:"trailer hit braam"},  filter:{duration:{min:800,max:3000}} }
# layer B - the sub
SearchSoundEffects { query:{term:"sub drop"},          filter:{duration:{min:1000,max:3000}} }
SearchSoundEffects { query:{term:"bass drop deep"},     filter:{duration:{min:1000,max:3000}} }
SearchSoundEffects { query:{term:"sub boom low"},       filter:{duration:{min:1000,max:3000}} }
SearchSimilarToSoundEffect { id:<chosen hit>, first: 12 }   # variants so repeats are not identical
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
The source names **metal** and **wood** as material variations of the hit family — pick the one that matches what is on screen when the impact has a visible cause. Always WAV: mp3 encoding is at its worst on very low frequencies and on sharp transients, which is precisely both layers.

A catalogue alternative worth knowing: a music `Recording`'s **`BASS` stem** (via `DownloadRecording { options:{ stemType: BASS } }`) can supply a sub layer that is already in the key of the bed, which is the tidy answer when a bass drop is landing over music.

**ffmpeg — deriving a sub when nothing in the catalogue fits.** The cheapest usable sub is the hit itself, pitched an octave down and low-passed:
```bash
# one octave down (pitch and length both change), then keep only the bottom
ffmpeg -i cinematic-impact-07.wav -af "asetrate=48000*0.5,aresample=48000,lowpass=f=120:poles=2,afade=t=out:st=1.4:d=0.4" sub-derived.wav
# check what the pair actually peaks at before trusting your ears
ffmpeg -i hit.wav -i sub.wav -filter_complex "[0][1]amix=inputs=2:duration=longest,astats=metadata=1" -f null -
```
Bake only for assets leaving the pipeline; in-composition the chain does this without a new file.

**Remotion:** two `<Audio>` components at offset frames with a shared limiter you would have to implement yourself. Concept only.

## Pairs with
[[sfx-layered-approach-and-impact]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-riser-anticipation-build]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-peak-on-impact-frame]] · [[sfx-pitch-shift-weight-energy]] · [[motion-impact-frame-quantisation]] · [[motion-camera-shake-impact]] · [[motion-snap-zoom-punch]] · [[cut-smash-cut-loud-to-quiet]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-layer-volume-targets]] · [[sfx-ten-family-catalogue]]

## Failure modes
- **Not high-passing the hit.** Both layers fight below 120 Hz, the sum is muddier and *quieter-sounding* than the hit alone, and people respond by turning it up until it clips. Fix: `highpass` at 110 Hz on the impact layer. This is the most common failure by a wide margin.
- **High-passing the hit too high.** Cutting above ~140 Hz removes the punch band and the impact vanishes on phone speakers, which reproduce almost nothing below ~200 Hz. Fix: 80–140 Hz only, and audition through a 200 Hz high-pass to simulate a phone.
- **Two sub layers.** Low frequencies phase-cancel; two subs can sum to *less* than one. Fix: one sub, ever. A third layer must be in a third band.
- **Sub starting before the hit.** Gives the moment away and reads as a fault. Fix: onset 0 to +2 frames after the transient.
- **Aligning the sub's peak instead of its onset.** A 30 Hz waveform takes 33 ms per cycle and cannot have a sharp peak; peak-aligning it puts the whole layer late. Fix: align onsets.
- **No ceiling.** Stacked impacts are the loudest thing in the mix and will clip the master while the rest of the video sits at −22 dB. Fix: `limiter` at −1 dB as the last node on the `sfx` bus.
- **Reverb on the sub.** Unbounded low-frequency smear that eats the next two seconds. Fix: reverb on the hit only.
- **Bass drops everywhere.** Scarcity is the effect. Fix: 3–8 per ten minutes, minimum 45 s apart.
- **Trusting preview.** An unparseable `data-fx-chain` plays **dry** in preview and **fails the render**; nothing lints the chain. Fix: render a short test before committing a chain you have not heard.
- **Known gap:** the 20–70 Hz sub band and its "felt more than heard" character are cited; the +1 frame offset, the 110 Hz high-pass point and the −4 dB sub level are engineering conventions derived from those physics, not measured standards. The phone-speaker caveat is practitioner knowledge — verify on the actual target device.
