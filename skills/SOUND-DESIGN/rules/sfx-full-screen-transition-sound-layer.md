---
id: sfx-full-screen-transition-sound-layer
title: Sounding a full-screen transition — one recipe per transition type
skill: sound-design
type: sfx
family: transition-sfx
tags: [skill/sound-design, type/sfx, family/transition-sfx, engine/epidemic, engine/hyperframes, engine/ffmpeg, engine/remotion, sfx/motion, layer/sfx, layer/design, source/editing-kt, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:09:58"
    quote: "Another way to make transitions seamless is to use a full-screen transition. There are tons of free packs out there, but if you like my subtle style, I've got something for you in the description."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:01:08"
    quote: "This sound effect is perfect for fast transitions, movements and dynamic reveals."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:58"
    quote: "So first of all, if you're putting a sound effect on a cut, place the highest peak of the sound effect on the cut."
research_refs:
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Low-pass_filter
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Smash_cut
difficulty: medium
detectable_from: transcript+video
---

# Sounding a full-screen transition — one recipe per transition type

## What it is
A full-screen transition is the fallback when two shots cannot be reconciled by matching action, shape or eyeline: an effect that covers the entire frame for a handful of frames hides the seam underneath it. The source treats the visual asset as a commodity — *"there are tons of free packs out there"* — and states the only real preference as **subtlety**. That leaves the sound as the part that actually decides whether the transition reads as invisible craft or as a stock plugin.

This note is the mapping table: for each transition family this stack can actually render, which sound family goes on it, how long, anchored where, at what gain. The general placement law comes from the source — *place the highest peak of the sound effect on the cut* — and this note supplies the per-type variation on it, because the "cut" frame is not the same thing in every transition. A whip pan's event is its velocity peak; a light leak's event is its brightness peak; an iris wipe's event is the frame the mask closes. Those are different frames and the sound goes on the one the eye is actually watching.

A **silent** full-screen transition is worse than no transition. The brain expects sound when there is motion, and a frame-filling effect is the largest motion event in the video; unsounded, *"the video feels really hollow, really fake."*

**Style.** Filed `sfx/motion` — the cue exists because the frame is being crossed; no movement, no sound. Where a transition also carries a riser or a tonal swell, that layer is aesthetic and is budgeted separately ([[sfx-riser-anticipation-build]]).

## When to use it
- **When matching has failed.** Run [[cut-continuity-pass]] first. A full-screen transition is the answer for a hard join between two shots with nothing in common — different location, different lighting, different framing — not a default applied to every cut.
- **At a topic or section boundary**, where the seam is *supposed* to be felt as a chapter break.
- **On a background clash.** The contract's own guidance for `blur-crossfade`: it is the default *"when the two scenes' `#root` backgrounds differ a lot — the blur masks the background-color clash a plain crossfade would expose."* Same logic for a light leak or an overexposure burn.
- **Not on a J-cut or L-cut.** A split edit is already hiding its seam with audio ([[sfx-split-edit-lead-lag]]); putting a whoosh on it announces the very cut the split edit was concealing.
- **Not more than 2–3 transition types per video.** The contract's own planner budget: *"Pick 2-3 types for the whole video and repeat them — repetition is what reads as professional."* Sound follows: 2–3 transition types means 2–3 transition sounds, in rotation, not twenty different ones.
- **Not on every cut.** A transition sound every few seconds is the named overload failure — see [[struct-stimulation-budget]] and [[sfx-placement-discipline]].

## How to recognise it in a reference video
- **Find the frame-filling frames.** Sample luminance and frame-difference per frame; a full-screen transition shows as either a luminance spike (light leak, burn, white bloom), a global frame-difference spike with no scene content (whip pan, glitch), or a monotonic blur/scale ramp (blur dissolve, zoom-through).
  ```bash
  ffmpeg -i ref.mp4 -vf "select='gt(scene,0.3)',metadata=print:file=-" -f null - 2>&1 | grep lavfi
  ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=-" -f null - 2>&1 | head -400
  ```
- **Measure the transition length in frames.** The subtle band is **4–12 frames (0.13–0.40 s)** at 30fps. This converges from two directions: the transition registry's own high-energy default is 0.4 s and its selection table gives 0.15–0.3 s for high energy and 0.3–0.5 s for medium. Anything **over 18 frames (0.6 s)** is either a deliberately calm register or a showy plugin — log which.
- **Then look at the audio in the same window and classify what is there:**
  - a **single broadband sweep** with a rise-then-fall envelope → whoosh/swish, the default;
  - a **sweep that rises into a hard stop** → reverse whoosh, used because the transition *arrives* somewhere;
  - a **sweep plus a low thud** on the same frame → whoosh + impact, the two-layer form;
  - a **short high burst with no low end** → swish or a glitch/stutter texture;
  - a **rising tone over 0.5–2 s ending on the transition** → a riser, which means this is a structural beat, not just a join ([[sfx-riser-anticipation-build]]);
  - **nothing** → either a genuine silence choice at a smash cut ([[sfx-smash-cut-audio-contrast]]) or an unfinished sound pass.
- **Measure the anchor.** `sound_peak_frame − transition_event_frame`. Expect **0 to +2 frames**. Beyond +4 frames late the sound has detached; more than 1 frame early it reads as a mistake, because the ear tolerates audio lagging picture roughly three times better than leading it.
- **Check the direction.** On a directional transition (whip pan left, push-slide UP), a competent mix has the sweep's spectral centroid or stereo image travelling the same way as the picture. A static centred whoosh on a left-to-right whip is a tell.
- **Check the tail.** The sweep should be finished, or under −24 dB, by the time the incoming shot's first spoken word starts. A whoosh tail over dialogue is the most common amateur artefact here.
- **Count the distinct files.** Two or three recurring transition sounds is a style. Twelve different ones is a pack being sprayed.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `transition_len` | 12f (0.40 s) | 4–18f (0.13–0.60 s) | Subtle band. Registry hard ceiling is `max_duration_s: 2.0`; anything past 18f needs a calm-register justification. |
| `sfx_len` | 1.0 × `transition_len` | 0.8–1.5 × | The sound may outlive the picture effect slightly; it must not be shorter. |
| `anchor` | peak on the transition event frame (+0f) | −1f to +2f | The "event frame" is type-specific — see the recipe table. |
| `pre_roll` | 8f (0.27 s) | 5–14f | Sweep audible before the event. This is envelope, not offset. |
| `tail` | 6f (0.20 s) | 3–12f | Must end before the incoming shot's first word. |
| `gain_primary` | 0.211 (≈−13.5 dB) | 0.178–0.251 (−15 to −12 dB) | Relative to dialogue at 0/−3 dB. The source's SFX band. |
| `gain_aesthetic_accent` | 0.100 (−20 dB) | 0.079–0.126 (−22 to −18 dB) | For the subtle style: felt, not noticed. |
| `impact_layer_gain` | 0.158 (−16 dB) | 0.126–0.200 (−18 to −14 dB) | The second layer, when used. Always quieter than the sweep it sits under. |
| `layers` | 1 | 1–2 | Sweep, optionally + impact. Three layers on a 12-frame transition is mud. |
| `highpass_for_subtle` | 400 Hz | 250–800 Hz, 2 poles (12 dB/oct) | Removing the low end is what turns a motion effect into an aesthetic accent. |
| `types_in_video` | 2 | 2–3 | Matches the registry's planner budget. Sound count follows type count. |
| `rotation_variants` | 3 | 2–5 | Per type, so the same file never repeats inside three uses. |
| `duck_music` | −3 dB for 0.5 s | 0 to −6 dB | Only if the bed and the sweep occupy the same band. Usually unnecessary. |

## Reproduction prompt

```
Sound the full-screen transition at {{T}} seconds (composition time).

1. IDENTIFY THE TYPE AND ITS EVENT FRAME. Read the transition from the
   motion spec, then locate the single frame the eye is tracking:
     whip pan / push-slide / squeeze -> the velocity peak (mid-transition)
     zoom-through                    -> the frame of maximum blur/scale
     light leak / burn / white bloom -> the peak-brightness frame
     glitch / chromatic / VHS        -> the first corrupted frame
     circle iris / clock wipe        -> the frame the mask fully closes
     blur crossfade / focus pull     -> the 50% mix frame
   Call that frame {{EVENT}} in seconds.
2. MEASURE {{LEN}}, the transition duration in frames. If {{LEN}} > 18,
   confirm the register is deliberately calm before proceeding.
3. FETCH BY DURATION. Query Epidemic for the family named in the recipe
   table for this type, with duration filter
   0.8*{{LEN}}/30*1000 to 1.5*{{LEN}}/30*1000 milliseconds. Pull 3
   candidates. Never fetch one.
4. FIND EACH CANDIDATE'S PEAK offset from the head of the file:
   {{PEAK_SRC}} seconds. Do not assume it is at the head.
5. PLACE IT: data-start = {{EVENT}} - {{PEAK_SRC}}. Author in seconds;
   there is no frame attribute. Peak may land up to 2 frames late, at most
   1 frame early.
6. SET GAIN. Primary motion effect: 0.211. Subtle aesthetic accent: 0.100
   plus a 400 Hz highpass at 2 poles. Ramp the last 6 frames to zero with a
   volume automation lane that includes an explicit t:0 point.
7. DIRECTION. If the transition is directional, prefer a candidate whose
   sweep travels the same way; otherwise leave it centred - do not fake it
   with a pan, which reads as a gimmick at this length.
8. OPTIONAL SECOND LAYER. Add one low impact at 0.158 on {{EVENT}} only if
   the transition lands on a structural beat. Two layers maximum.
9. CHECK THE TAIL against the incoming shot's transcript: the sweep must be
   below -24 dB before the first word.
10. LOG the file into the rotation for this transition type.

ACCEPTANCE TEST: play from 1s before to 1s after, twice. First pass - the
transition must feel like one event, picture and sound together, not a
picture effect with a sound near it. Second pass - if you can say "early"
or "late", move by one frame and repeat. Then count transition sounds in
the surrounding minute: more than 4 and the seam-hiding has become the
style.
```

## Execution spec

**Hyperframes — the transition and its sound are two separate authored numbers.** There is no audio-follows-transition binding. The transition is GSAP on the two scene wrappers; the sound is an `<audio>` clip whose `data-start` the author computes.

A whip pan at 0.4 s starting at t = 41.00 s (so its velocity peak is at 41.20 s), with a swish whose peak sits 0.18 s into the file:

```html
<!-- 12f @30fps = 0.40s. Event frame = mid-transition = 41.20s. -->
<audio id="sfx-tr-whip-03"
       src="assets/sfx/swish-blind-slide.wav"
       data-audio-group="sfx"
       data-start="41.02"            <!-- 41.20 - 0.18 : peak lands on the event -->
       data-duration="0.46"
       data-track-index="22"
       data-volume="0.211"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.26,&quot;v&quot;:1},{&quot;t&quot;:0.46,&quot;v&quot;:0}]}]}"></audio>
```

and the picture side, verbatim in the registry's shape (`__T__` = overlap start = 41.00):

```js
const T = 41.00, DUR = 0.40;
tl.to("#el-scene-a", { scale: 2.5, opacity: 0, filter: "blur(8px)", duration: DUR, ease: "power3.in" }, T);
tl.fromTo("#el-scene-b", { scale: 0.5, opacity: 0, filter: "blur(8px)" },
                         { scale: 1, opacity: 1, filter: "blur(0px)", duration: DUR, ease: "power3.out" }, T);
```

Contract points that bite here:
- **All authored time is seconds.** Frame counts are comments only.
- **Every `<audio>` needs an `id`** — an id-less audio element is never mixed and the render is silently missing the sound.
- **The automation lane's `t` is clip-local and holds its first value backwards to the clip start**, so the `t: 0` point is mandatory or the sound starts already faded.
- **SFX go in `data-audio-group="sfx"`, never `voiceover`** — a non-voice clip inside the carve group silently poisons the next carve re-analysis.
- **Which transitions actually exist here.** Only five are machine-ready in the registry: `crossfade` (0.5 s), `blur-crossfade` (0.6 s), `push-slide` (0.5 s, LEFT/RIGHT/UP/DOWN), `zoom-through` (0.4 s), `squeeze` (0.4 s). The ~40-name broad catalog (whip pan, light leak, glitch, circle iris, clock wipe, staggered blocks, film burn, VHS, chromatic aberration) is **named but its implementations are not staged** — the visual half may need building or a shader-package transition, while the *sound* half in this note is fully executable either way.
- **Shader transitions capture the DOM to a WebGL texture**, so a transition driven by `HyperShader.init({ scenes, transitions })` gets its timing from the `transitions[].time` array; the audio `data-start` must be computed against that same number.
- **If the transition sits at a sub-composition boundary**, the audio lives at the host root and needs `data-start = scene-local t + the slot's data-start`. Sub-comp timelines cannot reach host-root elements, so the sound cannot be attached "by" the transition.

**Epidemic Sound — the per-type recipe, with live-verified queries.**

| Transition | Sound family | Verified query | Duration filter (ms) |
|---|---|---|---|
| whip pan, push-slide, squeeze | short swish, directional | `filter.tagSlugs ANY ["swooshes--swish"]` — **22 files** at 100–400 ms | 100–500 |
| zoom-through, cinematic zoom | whoosh + optional low impact | `SearchSoundEffects {query:{term:"whoosh transition fast"}}` | 300–700 |
| blur crossfade, focus pull | long soft whoosh, high-passed | `filter.tagSlugs ANY ["designed--whoosh"]` — **2458 files** | 600–1600 |
| light leak, overexposure, white bloom | soft **reverse** whoosh + tonal swell | `{term:"reverse whoosh airy"}` then `{term:"cinematic swell soft"}` | 500–1500 |
| glitch, chromatic, VHS | glitch/interference texture | `filter.tagSlugs ANY ["user-interface--glitch"]` — **31 files** at 130–700 ms | 130–700 |
| circle iris, clock wipe, shutter | swish + a click/latch on close | `{term:"swish short"}` + `{term:"mechanical click latch"}` | 100–400 |
| staggered blocks, blinds | stutter/multi-hit | `{term:"stutter glitch multi hit"}` | 200–800 |
| impact layer (any type) | low boom | `filter.tagSlugs ANY ["designed--boom"]` — **2841 files** at 1000–4000 ms | 1000–3000 |

```
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ANY, values: ["swooshes--swish"] },
            duration: { min: 100, max: 500 } },
  sort:   { by: POPULARITY, order: DESCENDING }, first: 20
}
SearchSimilarToSoundEffect { id: <chosen uuid>, first: 12 }   # build the rotation
DownloadSoundEffect { id: <chosen uuid>, options: { fileType: WAV } }
```

**Negative finding worth keeping — do not query "light leak" or "film burn".** `SearchSoundEffects {query:{term:"light leak film burn transition"}}` returns **5920** results whose top hits are all `chemicals--acid` "Burn, Short Sizzle, Fizz" files at 1.9–3.9 s. The catalogue has no light-leak sound category, because a light leak has no sound in the world; it is an aesthetic transition and wants a reverse whoosh plus a tonal swell. Query for what the sound *is*, not for what the picture is called — the same discipline as [[sfx-name-before-search]].

Always download **WAV**. MP3 pre-echo smears the exact transient you are landing on a frame.

**Turning a motion effect into the "subtle style".** The difference is spectrum and level, not file choice. Add a highpass and drop the gain:

```html
data-volume="0.100"
data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
  {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Airy Only&quot;,&quot;params&quot;:{&quot;frequency&quot;:400,&quot;poles&quot;:&quot;2&quot;}},
  {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;size&quot;:0.4,&quot;wet&quot;:0.15,&quot;dry&quot;:0.9}},
  {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"
```
`poles: "2"` is a 12 dB/octave slope (order-*n* all-pole roll-off is 6*n* dB/octave); `poles: "1"` at 6 dB/octave leaves more body if the effect thins out too much. Order is signal order and the limiter goes last. `reverb` adds `chainTailSeconds`, so the rendered clip runs past `data-duration` — expected, but it means the authored tail ramp is not the last thing heard; keep `wet` at or below 0.2 on a 12-frame transition.

**ffmpeg — measurement and length fitting.**
```bash
# locate the file's peak, to get PEAK_SRC
ffmpeg -i swish.wav -af "astats=metadata=1:reset=0.02,ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null -
# fit length, pitch preserved (what data-playback-rate does)
ffmpeg -i swish.wav -af "atempo=1.25" swish.short.wav
# fit length with pitch (heavier / lighter, the source's own knob)
ffmpeg -i swish.wav -af "asetrate=48000*0.84,aresample=48000" swish.heavy.wav
```
`data-playback-rate` is a **constant in 0.1–5 and is pitch-preserved** — it changes length only, and there is no rate envelope, so an accelerating sweep must be baked.

**Remotion:** an `<Audio>` in a `<Sequence>` whose `from` is set so the file's peak frame equals the transition's event frame. Concept only; Remotion is not part of this stack.

## Pairs with
[[cut-full-screen-transition]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-whoosh-short-vs-long]] · [[sfx-peak-on-the-cut]] · [[motion-whip-pan-transition]] · [[motion-light-leak-overlay-transition]] · [[motion-white-bloom-through]] · [[motion-colour-dip-transition]] · [[motion-velocity-matched-transition]] · [[motion-bookend-transition-map]] · [[sfx-smash-cut-audio-contrast]] · [[sfx-riser-anticipation-build]] · [[sfx-cinematic-hit-emphasis]] · [[struct-stimulation-budget]] · [[sfx-placement-discipline]] · [[cut-continuity-pass]] · [[sfx-filter-character-and-distance]]

## Failure modes
- **A silent full-screen transition.** The largest motion event in the video, unsounded. Fix: every full-screen transition gets a sweep, even at −20 dB.
- **Sound anchored to the transition's start instead of its event frame.** On a 12-frame whip pan that is 6 frames early — well past the point where a lead reads as a fault. Fix: compute the event frame per the recipe table, then subtract the file's own peak offset.
- **Assuming the file's peak is at its head.** Places the effect late by the length of its attack, often 5–10 frames. Fix: measure `PEAK_SRC`.
- **A 1.5 s whoosh on a 6-frame transition.** The sweep is still going two shots later. Fix: fetch with the duration filter; do not stretch beyond ±35 %.
- **Querying the picture's name.** "light leak", "film burn", "ink wipe" return irrelevant catalogue families. Fix: query the sound — reverse whoosh, swell, swish, glitch.
- **Three layers on a short transition.** Sweep + impact + riser inside 0.4 s is one indistinct noise. Fix: two layers maximum, and split them by band.
- **The tail over the incoming dialogue.** The most audible amateur artefact in this whole family. Fix: ramp to zero before the first word, or shorten the file.
- **A different transition sound every time.** Reads as a pack, not a style. Fix: 2–3 types, 3 rotation variants each.
- **Transition sound in the `voiceover` group.** Silently corrupts the next carve pass. Fix: `data-audio-group="sfx"`.
- **Known gap:** the broad transition catalog's implementations (`catalog.md`, `css-*.md`) are **not staged in this project**, so the visual half of whip pan, light leak, glitch, iris and the rest can be named but not emitted as code from here. The sound half is fully specified and independent of that gap; treat the visual as either a registry transition, a shader-package transition, or hand-authored GSAP.
- **Known gap:** no published research measures the ideal anchor for a transition sound. The ±window here is derived by analogy from broadcast A/V sync detectability thresholds (roughly 45 ms audio lead, 125 ms lag) and from auditory forward masking lasting about 100 ms, which is why a late sound hides better than an early one. Default to +0f and let a human ear arbitrate.
