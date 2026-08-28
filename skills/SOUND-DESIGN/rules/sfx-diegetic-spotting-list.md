---
id: sfx-diegetic-spotting-list
title: The diegetic pass runs first — spot the cue list, including the sounds you cannot see
skill: sound-design
type: sfx
family: diegetic-sfx
tags: [skill/sound-design, type/sfx, family/diegetic-sfx, sfx/diegetic, layer/sfx, layer/ambience, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:03:54"
    quote: "And the most important out of these is diegetic sound effects."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:04:00"
    quote: "Like a phone ringing, a gunshot. Without these your video just can't feel real."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:03:39"
    quote: "Are you applying them in the right place, or just slapping them on everywhere?"
research_refs:
  - https://en.wikipedia.org/wiki/Sound_effect
  - https://en.wikipedia.org/wiki/Film_score
  - https://en.wikipedia.org/wiki/Acousmatic_sound
  - https://en.wikipedia.org/wiki/Inverse-square_law
  - https://en.wikipedia.org/wiki/Precedence_effect
difficulty: medium
detectable_from: video
---

# The diegetic pass runs first — spot the cue list, including the sounds you cannot see

## What it is
Two claims, one method. The claims: **diegetic effects outrank the other two styles**, because their absence is a hole rather than a missed opportunity — *"without these your video just can't feel real"* — and therefore the diegetic pass runs **before** motion and before aesthetic. The method: a **spotting pass** that produces a numbered cue list before a single file is fetched, exactly as scoring does when *"the director and composer watch the entire film, noting which scenes require original music"* and take *"precise timing notes … where it begins, where it ends."*

This note is the pass and the list. It has two siblings and it is worth being precise about the division:
- [[sfx-diegetic-action-inventory]] owns the **on-screen action → file** mapping: what a page flip, a mug, a laptop lid needs.
- [[sfx-foley-replacement-pass]] owns **feet, cloth and props** and what happens to the production sound underneath them.
- **This note owns the pass order, the cue-list format, and the half of the inventory that is not on screen.**

That last part is the reason the note exists. Beginners inventory what they can see; the world does not stop at the frame edge. Film theory names this directly: acousmatic sound is *"sound that one hears without seeing the causes behind it"*, and *"the opposition between visualised and acousmatic provides a basis for the fundamental audiovisual notion of offscreen space."* A room with a door, a street outside a window, a colleague in the next room, a phone on a desk out of shot — every one of these is a cue, and the off-screen cues are what make a location feel bigger than the shot.

The industry taxonomy the cue list should carry is four-way: **hard effects** (*"common sounds that appear on screen, such as door alarms, weapons firing, and cars driving by"*), **backgrounds/ambience** (*"do not explicitly synchronize with the picture, but indicate setting"*), **foley** (*"sounds that synchronize on screen … footsteps, the movement of hand props … the rustling of cloth"*), and **design** (*"sounds that do not normally occur in nature"* — which is the other two styles in this library and explicitly **not** part of this pass).

## When to use it
- **First, on any footage with a physical world in it** — hands, objects, doors, devices, vehicles, weather, other people. Before motion sounds, before risers, before music.
- **Whenever an edit "feels fake" but nothing is obviously wrong.** The near-universal cause is a complete motion/aesthetic layer sitting on top of an empty diegetic layer.
- **On any location scene where the camera sees less than the character hears** — interiors with doors and windows, offices, cafés, streets.
- **Not** on abstract full-frame motion graphics with no implied space; there is no diegesis to serve, and the correct pass there is motion ([[sfx-motion-pass-two-rules]]).
- **Not as a replacement for ambience.** The bed is a different layer ([[sfx-ambience-establishes-location]]); this pass is discrete events.

## How to recognise it in a reference video
- **Count events, not effects.** Step through and list every physical event with a contact frame. Then count how many are sounded. A finished diegetic pass sounds **>90 %** of on-screen contacts; under ~60 % is an unfinished pass and is the finding to log.
- **Look for off-screen cues.** Sounds with no visible source that are clearly not ambience: a door closing somewhere, a phone buzzing off-frame, a car passing behind camera. **Two or more per minute** in a location scene indicates a deliberate off-screen inventory. Zero indicates a purely on-screen pass.
- **Check perspective consistency.** For each diegetic event, estimate its distance from the picture and compare with its treatment. Distant sources should be **quieter, duller and wetter**; a far-off door with a close, bright, dry sound is the tell that a library file was dropped in without perspective.
- **Check sync.** Measure the offset from the visual contact frame to the effect's envelope peak. Diegetic effects sit within **±2 frames** of contact; anything beyond ~4 frames early reads as designed, and late reads as broken ([[sfx-peak-on-impact-frame]]).
- **Check level tier.** Diegetic events sit around **−12 to −15 dB** relative to dialogue — the SFX tier — but the loudest of them (a slammed door, a dropped object) may briefly reach −6.
- **Look for the sounds a shot implies but does not show.** A character reacts to something: is it audible? An unanswered reaction is the single most damaging diegetic hole, because the viewer registers a missing cause.
- **Transcript cross-check.** Objects named in dialogue ("my phone", "the door") should exist in the sound. Named-but-silent objects are a reliable finding.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Pass order | diegetic → motion → aesthetic | fixed | The one hard ordering rule in the SFX passes. |
| On-screen contacts sounded | 100 % | 90–100 % | Deliberate omissions must be logged as decisions. |
| Off-screen cues per minute | 2 | 1–4 | Location scenes. Zero is a red flag; above 4 becomes clutter. |
| Sync window | ±2 f | −4 to +1 f | 30 fps. Early beats late; see the sync-window note. |
| Level, on-screen close | −12 dB rel. dialogue | −10 to −15 | Dry, full band. |
| Level, on-screen mid | −16 dB | −14 to −18 | Reverb wet ≈ 0.10. |
| Level, on-screen far | −22 dB | −18 to −26 | Low-pass 4–6 kHz, wet ≈ 0.20. Consistent with 6 dB per doubling of distance. |
| Level, off-screen adjacent | −20 dB | −16 to −24 | Low-pass 2–4 kHz, wet ≈ 0.25. |
| Through a wall or door | −24 dB | −20 to −28 | Low-pass 800–1500 Hz, high-pass 100 Hz, wet ≈ 0.3. |
| Cue-list row id | `D-001` | — | `D` = diegetic; `M` = motion; `A` = aesthetic. Stable handles for the fetch list. |

## Reproduction prompt
```
Run the DIEGETIC spotting pass on this cut. Do this before any motion or aesthetic
sound work. Produce a cue list first; fetch nothing until the list is complete.

STEP 1 - ON-SCREEN SPOT. Step through the cut. For every physical event that makes
contact - object set down, door, switch, page, keyboard, footstep, vehicle, device
alert - emit a row:
  {id: D-00n, tc_in, contact_frame, object, action, on_screen: true,
   distance: close|mid|far, query, gain_db, offset_frames}

STEP 2 - OFF-SCREEN SPOT. Go through again and answer these four questions per
scene, adding a row for each YES:
  (a) What exists in this location that the frame does not show?
  (b) Is anyone or anything else in the building / street / room?
  (c) Does anyone react to something we do not see? (An unanswered reaction is a
      mandatory cue - never leave one silent.)
  (d) Does anything continue from the previous shot that should still be audible?
Mark these rows on_screen: false and distance: adjacent|through-wall.

STEP 3 - TREAT BY PERSPECTIVE, not by taste. Apply the level/filter/reverb triple
for each row's distance class from this note's Parameters table. Distance is a
FILTER decision before it is a fader decision: turning a sound down makes it quiet,
low-passing it makes it far away.

STEP 4 - PLACE. Align each effect's envelope PEAK to its contact frame, within
+/-2 frames, biased early. Never align file starts.

STEP 5 - AUDIT. Play the scene with dialogue and ambience only, then with the
diegetic layer. The second pass must feel REAL, not louder. Any event that draws
attention to itself is 4-6 dB too loud or too dry.

ACCEPTANCE: every on-screen contact has a row; every unanswered on-screen reaction
has an off-screen row; no row is missing a query string or a gain; the pass is
complete before a single motion or aesthetic effect is added.
```

## Execution spec

**Epidemic Sound.** One `SearchSoundEffects` call per cue row, using the object plus its material plus the action — the vocabulary rule from [[sfx-name-before-search]] applies. Reliable shapes for the two source-named examples and their off-screen siblings:

| Cue | Query | Filters |
|---|---|---|
| Phone ringing (on desk) | `mobile phone ringing vibrate` | `duration.max: 6000` |
| Phone, off-screen in next room | `mobile phone ringing` + low-pass in post | — |
| Gunshot | `gunshot single dry` | `duration.max: 3000` |
| Door, off-screen | `door close interior wooden` | `duration.max: 4000` |
| Distant traffic pass-by | `car pass by distant` | `duration.min: 3000` |
| Keyboard | `keyboard typing mechanical` | `duration.min: 4000` |

`duration` is in **milliseconds**. Pull three candidates per row rather than one — effects are cheap to audition and expensive to guess at — and once a video's palette is set, use `SearchSimilarToSoundEffect` so the same door does not come from three different buildings. Record the resolved asset id back into the cue row; the cue list is also the fetch list.

**HyperFrames.** Each cue is one `<audio>` clip. Perspective is a chain, not a fader:

```html
<!-- D-014: door closing, off-screen, adjacent room, contact at t = 18.40 -->
<audio id="sfx-d014-door" src="assets/sfx/door-close.wav"
       data-audio-group="sfx" data-start="18.33" data-duration="1.2"
       data-media-start="0.08" data-track-index="12" data-volume="0.1"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;d1&quot;,&quot;label&quot;:&quot;Through the wall&quot;,&quot;params&quot;:{&quot;frequency&quot;:1200,&quot;poles&quot;:&quot;2&quot;}},{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;d2&quot;,&quot;params&quot;:{&quot;frequency&quot;:100}},{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;d3&quot;,&quot;params&quot;:{&quot;size&quot;:0.5,&quot;damping&quot;:0.6,&quot;wet&quot;:0.3,&quot;dry&quot;:0.8}}]}"></audio>
```

Timing mechanics from the contract: **all authored time is in seconds**, so a contact at frame 552 @30 fps is `18.40`, and `data-media-start` trims the file's pre-transient so the *peak* lands there rather than the file head ([[sfx-peak-offset-measurement]]). There is **no audio-follows-animation attribute** — picture and sound are coupled only by the author writing the same number twice — and if the visual event lives in a sub-composition, the root-level audio needs `data-start = scene_local_t + slot data-start`. Give every clip an `id` (an id-less `<audio>` is never mixed → silent render) and keep the SFX in their own `sfx` group, **never** in the `voiceover` carve group.

**ffmpeg.** Measure each file's transient offset before placing it, rather than eyeballing the waveform:

```bash
ffmpeg -i door-close.wav -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
```

`n=1600` at 48 kHz is exactly one frame at 30 fps, so the loudest printed block index is the peak's frame offset.

**Remotion.** Concept only: one `<Audio>` per cue with `startFrom` set to the measured pre-transient, mounted at `contact_frame - offset_frames`.

## Pairs with
[[sfx-diegetic-action-inventory]] · [[sfx-three-types-classification]] · [[sfx-sound-pass-order]] · [[sfx-foley-replacement-pass]] · [[sfx-filter-character-and-distance]] · [[sfx-peak-on-impact-frame]] · [[sfx-peak-offset-measurement]] · [[sfx-ambience-establishes-location]] · [[sfx-convention-over-accuracy]] · [[sfx-name-before-search]] · [[sfx-layer-volume-targets]]

## Failure modes
- **Doing the motion pass first.** Whooshes over an unsounded world is the signature of an amateur edit: it sounds *produced* and *fake* at the same time. The order is not negotiable.
- **Inventorying only what is visible.** Produces a world that ends at the frame edge. Run step 2 explicitly; it is the half people skip.
- **Leaving a reaction unanswered.** A character flinches, looks up, or turns — and nothing caused it. This is the most damaging single hole in the layer.
- **Ignoring perspective.** Every effect close, dry and bright makes a room sound like a mixing booth. Distance is low-pass plus reverb plus level, in that order of importance.
- **Aligning file starts instead of peaks.** Effects have variable pre-transient padding; aligning starts puts the audible event anywhere from 0 to 200 ms late.
- **Sounding every single footstep in a wide shot.** Coverage is not the goal; plausibility is. Sound the steps the eye follows and let the ambience carry the rest.
- **Known gap:** nothing in this stack detects contact frames, and there is no automatic sync. The cue list is produced by watching, and every offset is authored by hand on both the picture and the audio element.
