---
id: sfx-filter-character-and-distance
title: High pass for sharp, low pass for muffled — filters as character and as distance
skill: sound-design
type: mix
family: sfx-treatment
tags: [skill/sound-design, type/mix, family/sfx-treatment, engine/hyperframes, engine/ffmpeg, engine/epidemic, layer/sfx, layer/ambience, layer/design, layer/dialogue, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:08:41"
    quote: "If you want your sound effect to feel sharp, then use a high pass filter on it. It cuts off the lower frequencies and only the high frequencies stay. Whereas a low pass removes the high frequencies and keeps only the low ones, which makes your sound feel a bit muffled, a bit dampened."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:08:23"
    quote: "If your sound effects still feel separate from the video, if they're sticking out, if they feel really odd, then there's a really easy way to mix them in: add reverb."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:08:46"
    quote: "Now let's put a low-pass filter on it, let's add that."
research_refs:
  - https://en.wikipedia.org/wiki/Low-pass_filter
  - https://docs.unity3d.com/Manual/class-AudioLowPassFilter.html
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Auditory_masking
difficulty: medium
detectable_from: audio
---

# High pass for sharp, low pass for muffled — filters as character and as distance

## What it is
Two filters, three jobs. A **high pass** keeps the highs and removes the lows: the sound becomes sharp, crisp, light, cutting. A **low pass** keeps the lows and removes the highs: the sound becomes muffled, dampened, dull, distant. The source frames both as character tools, and that is the first job.

The second job is **distance and occlusion**, and it is the more useful one because it is physics rather than taste. Air and barriers absorb high frequencies faster than low ones — as the filter reference puts it about acoustic barriers, *"the low notes are easily heard, while the high notes are attenuated."* That is why a low pass, not a volume reduction, is what makes a sound read as *behind a wall*, *in the next room*, *outside*, *underwater* or *off screen*. Turning a sound down makes it quiet; low-passing it makes it far away. Game engines encode exactly this: Unity's occlusion guidance is to *"change the Cutoff Frequency when opening the door"* because *"high frequencies of a sound being emitted from behind a door will be filtered out by the door."*

The third job is **mix hygiene**, and it is invisible: high-passing an effect out of the speech bands so it stops masking dialogue. Same filter, no character intent, purely to get out of the way.

The mechanic that makes all three precise: an order-*n* all-pole filter rolls off at **6*n* dB per octave** — 1 pole = 6 dB/oct, 2 poles = 12 dB/oct — and the stated cutoff is the **−3 dB point**, not the point where the sound stops. So a 2 kHz low pass still passes plenty at 3 kHz. Choose the cutoff an octave *below* where you want the character to begin.

**Style.** No `sfx/` style tag: filtering is a treatment applied to any of the three. Its distance and occlusion job is mostly diegetic work ([[sfx-ambience-layer-stack]]), its character job mostly aesthetic ([[sfx-pitch-shift-weight-energy]]), and its mix-hygiene job belongs to no style at all.

## When to use it
- **Sharp (high pass):** clicks, ticks, UI blips, snaps, whip cracks, glass, key presses, text-appearance transients. Also every **aesthetic air accent** — high-passing is what turns a motion whoosh into a felt-not-noticed accent ([[sfx-air-on-micro-movement]]).
- **Muffled (low pass):** anything meant to be somewhere else — a conversation through a wall, traffic outside a closed window, music in another room, a voice in a memory or a dream, a phone in a bag, a sound underwater or behind glass. Also to **dull the tail** of an effect so it does not compete with the next shot's dialogue.
- **Distance, dynamically:** the same low pass automated open as a door opens, a character walks in, or a punch-in arrives. This is the single most convincing use of a filter in this stack and it is available because the cutoff frequency is an automatable parameter.
- **Mix hygiene:** high-pass any effect that sits over speech at 250–400 Hz so its weight stops competing with the voice's Weight band.
- **A reveal:** a heavily low-passed bed that opens up at a structural beat is a riser substitute that costs nothing and never sounds like a stock riser.
- **Not instead of picking the right file.** A low-passed bright whoosh is a dull bright whoosh, not a heavy one. Weight comes from content the file has to contain ([[sfx-pitch-shift-weight-energy]]).
- **Not on dialogue for taste.** Layer 1's filtering is corrective and belongs to [[sfx-dialogue-gate]]. A character filter on dialogue is a *costume* and should be a named preset, not hand-built filters.
- **Not stacked with a character preset.** The stack's own rule about `telephone`, `radio-am`, `megaphone`, `pa-system`, `intercom`, `lofi-tape`: *"These are costumes... Do not stack two."*

## How to recognise it in a reference video
- **Trace the spectral centroid of an isolated effect.** Then compare against the same family untreated elsewhere in the same video — never against a remembered ideal, because *"the absolute spectrum of a single unknown voice cannot be diagnosed"* and the same holds for an effect.
- **Band survey the effect, using the stack's own band names:**
  ```bash
  for b in "20 80 Rumble" "80 250 Weight" "250 600 Mud" "600 2000 Middle" "2000 5000 Presence" "5000 10000 Edge" "10000 20000 Air"; do
    set -- $b; echo -n "$3 "
    ffmpeg -v error -ss <t> -t 0.5 -i ref.wav -af "highpass=f=$1,lowpass=f=$2,volumedetect" -f null - 2>&1 | grep mean_volume
  done
  ```
  - **Rumble and Weight 15+ dB below Presence** → high-passed. Somewhere between 250 and 800 Hz.
  - **Edge and Air 15+ dB below Middle** → low-passed. Somewhere between 2 and 6 kHz.
  - **Both ends down, Middle intact** → this is a bandpass, i.e. a *telephone/radio* costume, not a character filter.
- **Estimate the cutoff, then estimate the slope.** Find the frequency 3 dB down from the passband, then measure how much is lost one octave further out: ~6 dB means a 1-pole filter, ~12 dB means 2 poles. Aggressive occlusion effects use steeper slopes than in-stack filters can deliver in one node.
- **Distinguish "far" from "quiet".** Take two instances of the same sound at different apparent distances and compare *band ratios*, not levels. A pure level change keeps the ratios; genuine distance treatment shows the top end falling faster than the bottom.
- **Look for a sweep.** Plot the Edge-band level over the duration of an effect or bed. A monotonic rise over 0.5–3 s is an automated cutoff opening — a filter reveal. Log the start and end frequencies and the duration.
- **Check whether the effects were high-passed for hygiene.** If every SFX in the video is missing its bottom octave and none of them are meant to sound sharp, the mix has a blanket high pass on the SFX bus. That is a legitimate, mature choice and worth copying.
- **Reverb almost always accompanies a low pass.** The source pairs them: without reverb, effects *"feel like they were recorded in a studio"*. A low pass with no reverb reads as broken gear; a low pass with a little reverb reads as another room.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `hp_sharp` | 400 Hz | 250–1500 Hz | The "sharp" knob. 250–400 is hygiene; 800–1500 is aggressively thin and deliberate. |
| `hp_hygiene` | 300 Hz | 200–400 Hz | Blanket high pass on the SFX bus to keep weight off the voice. The stack's own `highpass` default is 300 Hz. |
| `hp_aesthetic_air` | 600 Hz | 400–1000 Hz | Turns a motion whoosh into an aesthetic accent. Pairs with a gain drop to −18/−22 dB. |
| `lp_slight_damp` | 8000 Hz | 6000–10000 Hz | Barely a character; takes the studio edge off. The stack's `lowpass` default is 8000 Hz. |
| `lp_closed_door` | 5000 Hz | 3000–6000 Hz | Unity's occlusion default is **5000 Hz**, for exactly this case. |
| `lp_solid_wall` | 1200 Hz | 800–2000 Hz | Next room through masonry. |
| `lp_in_a_bag` | 1500 Hz | 1000–2500 Hz | Phone in a pocket, sound inside a container. |
| `lp_underwater` | 600 Hz | 400–900 Hz | Plus reverb and a slow amplitude wobble; a filter alone is not enough. |
| `lp_memory_dream` | 2500 Hz | 1500–3500 Hz | Plus a large reverb and usually a pitch drop. |
| `lp_tail_control` | 4000 Hz | 3000–6000 Hz | Dulls an effect's tail so it does not fight the next line. |
| `poles` | 2 (12 dB/oct) | 1 (6) or 2 (12) | Only two options per node. 1 pole is gentler and keeps more body. |
| `q` | 0.707 | 0.5–1.4 | 0.707 is maximally flat. Above ~1.4 a resonant bump appears at the cutoff, which sounds like an effect. |
| `serial_nodes_for_steeper` | 1 | 1–3 | Two 2-pole nodes at the same frequency ≈ 24 dB/oct. Costs a resonance bump at the corner. |
| `sweep_duration` | 1.2 s | 0.4–3.0 s | For a filter reveal. |
| `sweep_points` | 5 | 4–8 | Spaced by octave (e.g. 500 · 1000 · 2000 · 4000 · 8000), not linearly — see Execution spec. |
| `reverb_with_lp` | wet 0.20 | 0.12–0.35 | A low pass without reverb reads as broken, not distant. |

## Reproduction prompt

```
Filter the sound at {{TARGET_ID}} for intent {{INTENT}}, where {{INTENT}} is
one of SHARP, HYGIENE, AESTHETIC_AIR, DISTANCE, or REVEAL.

1. MEASURE FIRST. Band-survey the file across the seven bands (Rumble,
   Weight, Mud, Middle, Presence, Edge, Air) with ffmpeg highpass+lowpass+
   volumedetect. You need to know what is there before removing anything.
2. PICK THE CUTOFF ONE OCTAVE BELOW where you want the character to start.
   The stated cutoff is the -3 dB point, and a 2-pole filter is only
   12 dB/octave, so a "2 kHz low pass" still passes a lot at 3 kHz.
   SHARP          -> highpass 400 Hz, 2 poles
   HYGIENE        -> highpass 300 Hz, 2 poles, on the SFX BUS not the clip
   AESTHETIC_AIR  -> highpass 600 Hz, 2 poles, AND drop gain to 0.100
   DISTANCE       -> lowpass: closed door 5000 / solid wall 1200 /
                     in a bag 1500 / underwater 600 / memory 2500
   REVEAL         -> lowpass automated from 600 Hz to 8000 Hz
3. ADD REVERB IF LOW-PASSING. Any lowpass at or below 5000 Hz gets a reverb
   node after it, wet 0.20, dry 0.90. A low pass with no reverb sounds like
   broken equipment, not like another room. Expect chainTailSeconds to push
   the clip past its data-duration.
4. WRITE THE CHAIN IN SIGNAL ORDER, corrective first, character middle,
   limiter last:
   highpass/lowpass -> reverb -> limiter{limit:-1}
5. FOR A REVEAL, automate the cutoff, not the volume:
   lane target "fx.n1.frequency", v in Hz, t in CLIP-LOCAL seconds, with an
   explicit t:0 point. Space the points BY OCTAVE (600, 1200, 2400, 4800,
   8000) rather than evenly, so the sweep sounds even.
6. DO NOT STACK A CHARACTER PRESET on top. If the intent is telephone,
   radio, megaphone, PA or intercom, use that named preset INSTEAD of
   hand-built filters, and never two presets together.
7. RE-MEASURE and confirm the bands you meant to remove are at least 15 dB
   below the bands you kept.

ACCEPTANCE TEST: A/B the treated and untreated versions in place, with
picture and dialogue at level, twice. For SHARP/HYGIENE/AESTHETIC_AIR the
treated version must sound like the SAME sound, only better placed - if it
sounds like a different, thinner sound, back the cutoff off by half an
octave. For DISTANCE, a listener with eyes closed must be able to say WHERE
the sound is, not just that it is quiet. For REVEAL, the sweep must arrive
exactly on the structural beat and must not be audible as a filter until
about halfway through.
```

## Execution spec

**Hyperframes — both filters are first-class nodes and both have automatable frequency and Q.**

Registry, verbatim: `highpass` — `frequency` 20–20000 Hz (default **300**, log) **AUTO** · `q` 0.1–20 (0.707, log) **AUTO** · `poles` `1`|`2` (2). `lowpass` — `frequency` 100–20000 Hz (default **8000**, log) **AUTO** · `q` 0.1–20 (0.707, log) **AUTO** · `poles` `1`|`2` (2). *"`q` is bandwidth (higher = narrower). `poles`: `2` = usual biquad (12 dB/oct), `1` = gentler (6 dB/oct)."* Out-of-range values are **clamped on read**, so anything that parses is safe.

Sharp, on one clip:
```html
<audio id="sfx-ui-tick" src="assets/sfx/ui-tick.wav"
       data-audio-group="sfx" data-start="18.40" data-duration="0.22"
       data-track-index="22" data-volume="0.211"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Make Sharp&quot;,&quot;params&quot;:{&quot;frequency&quot;:400,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>
```

Distance — conversation through a wall, with the reverb that makes it believable:
```html
<audio id="amb-next-room" src="assets/sfx/crowd-chatter.wav"
       data-audio-group="ambience" data-start="30.00" data-duration="24.00"
       data-track-index="13" data-volume="0.079"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Through the Wall&quot;,&quot;params&quot;:{&quot;frequency&quot;:1200,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Trim Sub&quot;,&quot;params&quot;:{&quot;frequency&quot;:120,&quot;poles&quot;:&quot;1&quot;}},
         {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;params&quot;:{&quot;size&quot;:0.6,&quot;damping&quot;:0.7,&quot;wet&quot;:0.22,&quot;dry&quot;:0.9}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n4&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>
```

Reveal — the door opens at clip-local 6.0 s, so the cutoff sweeps 600 → 8000 Hz over 1.2 s, octave-spaced:
```html
data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;fx.n1.frequency&quot;,&quot;points&quot;:[
  {&quot;t&quot;:0,&quot;v&quot;:600},{&quot;t&quot;:6.0,&quot;v&quot;:600},{&quot;t&quot;:6.3,&quot;v&quot;:1200},
  {&quot;t&quot;:6.6,&quot;v&quot;:2400},{&quot;t&quot;:6.9,&quot;v&quot;:4800},{&quot;t&quot;:7.2,&quot;v&quot;:8000}]}]}"
```

Contract points that decide whether this works:
- **Automation addresses nodes by `id`, never by position**, as `fx.<nodeId>.<param>`. A node with no `id` loads but cannot be automated, and **a lane whose node is gone is pruned silently on read** — *"a typo'd `nodeId` costs you the envelope silently."*
- **`v` is in the parameter's own unit** — Hz for a frequency, dB for a gain, 0..1 for volume. A frequency lane's values are Hz, not normalised.
- **Lane `t` is clip-local seconds on a clip and composition time on an `<hf-audio-group>` bus.** A blanket SFX high pass belongs on the bus; a per-effect character filter belongs on the clip.
- **A lane holds its first value backwards to the clip start and its last value forward to the end**, so the sweep needs its `t: 0` point or the effect starts already open.
- **The octave spacing is deliberate.** The registry marks `frequency` as a **log**-scaled parameter, but the staged files do not state whether the automation runtime interpolates in log or linear space. Octave-spaced breakpoints sound even either way, so they remove the question. A two-point sweep from 600 to 8000 Hz is a gamble on an undocumented behaviour.
- **Escaping is load-bearing.** Write these attributes double-quoted with the JSON's own quotes as `&quot;` — `carve.mjs` finds them with a `name="..."` regex, and *"a single-quoted attribute is invisible to it and the carve silently overwrites work it could not see."*
- **Chain order is signal order, limiter last.** Doctrine: *"Subtract before you add, level after you filter, relationships after level, character and ceiling last."*
- **Serial nodes for a steeper slope.** Two 2-pole `lowpass` nodes at the same frequency approximate 24 dB/octave, at the cost of a resonance bump at the corner; raise the first node's frequency by a third of an octave to flatten it.
- **`reverb` adds `chainTailSeconds`**, so *"a bed with reverb no longer ends exactly at its `data-duration`; that is expected, not a bug."*
- **`reverb`'s `size`/`damping` are NOT automatable** (they regenerate the impulse); `wet`/`dry` are. `saturate` only exposes `output`. `compressor`, `limiter`, `gate` and `bitcrush` have **zero** automatable parameters. The workaround is *"automate a `gain` stage around it instead."*
- **Nothing validates the chain or the lanes.** Render refuses an unparseable chain outright; preview plays it **dry**, so a filter that "does nothing in preview" may be a JSON error rather than a bad cutoff.
- **Use the character presets for costumes, not hand-built bandpasses.** `telephone`, `radio-am`, `megaphone`, `lofi-tape`, `pa-system`, `intercom`, `doofus-worble`. Presets are wrapped in a wet/dry blend with `presetAmount` (0..1), and **`fx.preset.<id>`** is an automation target — *"the only way to automate a preset as a unit."* That is how a phone voice fades from filtered to full.

**ffmpeg — measurement, and baking when the file must leave the pipeline.**
```bash
# character bake: sharp
ffmpeg -i tick.wav -af "highpass=f=400:poles=2" tick.sharp.wav
# distance bake: behind a solid wall
ffmpeg -i chatter.wav -af "lowpass=f=1200:poles=2,highpass=f=120:poles=1,aecho=0.8:0.6:60:0.3" chatter.wall.wav
# steeper slope by chaining
ffmpeg -i chatter.wav -af "lowpass=f=1400:poles=2,lowpass=f=1200:poles=2" chatter.steep.wav
# verify what was removed
ffmpeg -v error -i chatter.wall.wav -af "highpass=f=5000,volumedetect" -f null - 2>&1 | grep mean_volume
```
`highpass` and `lowpass` both take `frequency`, `poles`, `width_type` (`q|o|h|d`), `width` and `mix`. Bake only for assets leaving the HyperFrames pipeline — in-composition, the `data-fx-chain` node is the answer and leaves the source file untouched.

**Epidemic Sound — filter treatment is a substitute for a fetch about half the time, and knowing which half saves work.**

Filters cannot add content. So:
- **Sharp is usually cheaper to filter than to fetch** — most effects contain more low end than a sharp read needs.
- **Muffled is always cheaper to filter than to fetch.** The catalogue has no "heard through a wall" category, and querying for one wastes calls. Fetch the clean sound and low-pass it.
- **Weight and heaviness must be fetched or pitched, never filtered** — a low pass on a bright file leaves a dull bright file. Query for it:
```
SearchSoundEffects { query: { term: "whoosh heavy low sub" }, filter: { duration: { min: 700, max: 1800 } } }
SearchSoundEffects { filter: { tagSlugs: { matchType: ANY, values: ["designed--boom"] }, duration: { min: 1000, max: 3500 } } }   # 2841 files
SearchSoundEffects { query: { term: "room tone muffled distant" } }        # the honest fetch for a distant bed
SearchSimilarToSoundEffect { id: <chosen uuid>, first: 12 }
DownloadSoundEffect { id: <uuid>, options: { fileType: WAV } }
```
Always **WAV**: mp3 puts pre-echo energy either side of a transient, and after a steep high pass that artefact is one of the few things left in the band you kept.

**Remotion:** a Web Audio `BiquadFilterNode` (`type: "highpass" | "lowpass"`, `frequency`, `Q`) on the audio graph, with the frequency driven from the current frame for a sweep. Concept only; Remotion is not part of this stack.

## Pairs with
[[sfx-pitch-shift-weight-energy]] · [[sfx-air-on-micro-movement]] · [[sfx-camera-move-air-accent]] · [[sfx-full-screen-transition-sound-layer]] · [[sfx-dialogue-gate]] · [[sfx-layer-volume-targets]] · [[sfx-ambience-search-formula]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-phone-call-cross-cut-treatment]] · [[sfx-cross-cut-audio-strategy]] · [[sfx-riser-anticipation-build]] · [[sfx-instrument-filter-search]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-placement-discipline]] · [[sfx-five-layers-build-order]] · [[sfx-transient-masked-outpoint]]

## Failure modes
- **Reading the cutoff as a wall.** It is the **−3 dB point**, and a 2-pole filter loses only 12 dB per octave beyond it. A "2 kHz low pass" that does not sound muffled enough is usually set an octave too high. Fix: cutoff one octave below where the character should begin, or chain a second node.
- **Low-passing to make something heavy.** Removes the top without adding a bottom; the result is dull, not weighty. Fix: fetch a low-content file or bake a pitch drop with `asetrate`.
- **A low pass with no reverb.** Reads as broken equipment rather than another room. Fix: `reverb` after the filter, wet 0.20.
- **Turning a sound down to make it distant.** Level says "quiet"; spectrum says "far". Fix: low-pass and keep the level, then trim.
- **Q above ~1.4 on a "clean" filter.** Adds a resonant bump at the corner that sounds like a synth sweep. Fix: 0.707.
- **A two-point frequency sweep.** Whether the runtime interpolates a log-scaled parameter linearly is not documented, so a 600→8000 Hz sweep in two points may spend almost all its perceptual travel in the last moment. Fix: octave-spaced breakpoints.
- **A typo in the automation target.** `fx.n1.frequncy` or a renamed node id is **pruned silently on read** — no error, no envelope, and the filter simply sits at its authored value. Fix: check node ids against the chain before shipping, and confirm by ear that the sweep happens.
- **Single-quoted JSON attributes.** Parses in the browser, invisible to `carve.mjs`, which then silently overwrites work it could not see. Fix: double quotes with `&quot;`.
- **Stacking two character presets.** *"These are costumes... Do not stack two."* Fix: one, with `presetAmount` to control how far it goes.
- **Hand-building a telephone effect.** A bandpass plus distortion by hand is worse and less portable than the `telephone` preset, and it cannot be automated as a unit. Fix: use the preset, automate `fx.preset.<id>`.
- **Blanket high pass so aggressive that impacts lose their point.** A 400 Hz bus high pass removes exactly what a cinematic boom is for. Fix: hygiene high pass on the bus at 200–300 Hz, and exempt the impact clips by giving them their own group.
- **Known gap:** the research question asks for the equivalent parameter names in **Premiere Pro and DaVinci Resolve**. Those could not be verified from vendor documentation in this session — the Adobe audio-effects reference did not return the parameter list — so no names are asserted here. Both applications ship high-pass and low-pass filters whose primary control is a cutoff frequency, but if a spec has to name a control in either host, verify it in the host first. The authoritative names for **this** stack are the registry's: `highpass`/`lowpass` with `frequency`, `q`, `poles`.
- **Known gap:** the occlusion cutoff figures (closed door 5000 Hz, solid wall 1200 Hz, underwater 600 Hz) are calibrated from game-engine practice — Unity's occlusion default is 5000 Hz — and from the physical fact that barriers attenuate highs faster than lows, not from measured transmission-loss curves for specific materials. They are good starting points, not acoustic predictions.
