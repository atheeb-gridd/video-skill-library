---
id: sfx-foley-family
title: Foley — the tenth family, and the two recipes that build a sound you cannot fetch
skill: sound-design
type: sfx
family: foley
tags: [skill/sound-design, type/sfx, family/foley, sfx/diegetic, layer/sfx, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:07:07"
    quote: "Foley sounds are the sound effects that, instead of being shot at a real location, are recorded inside a studio - fake sound effects that sound completely real."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:07:13"
    quote: "Footsteps, clothes, a door creak. This creates realism in the scene."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:07:27"
    quote: "So I made that with my own mouth, and it sounds like this."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:08:06"
    quote: "First we'll put a change on it - our pitch shifter."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:08:36"
    quote: "The pitch still feels a little off. Let's bring the pitch down a bit more - let's make it 6, zero point six."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:09:06"
    quote: "If you need the sound of a bone breaking, you can take the sound of wood breaking and mix it with a water splash. Nobody will ever find out. I've done this plenty of times."
research_refs:
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://en.wikipedia.org/wiki/Pitch_shift
  - https://en.wikipedia.org/wiki/Low-pass_filter
  - https://en.wikipedia.org/wiki/Reverberation
  - skills/SOUND-DESIGN/_kt/sfx-kt-1-delta.md
difficulty: medium
detectable_from: audio
---

# Foley — the tenth family, and the two recipes that build a sound you cannot fetch

## What it is
Foley is the **tenth** of the ten named sound-effect families in `sfx kt 1`, and the first pass over that video lost it entirely — which also mis-numbered whip as tenth when it is ninth ([[sfx-ten-family-catalogue]] carries the corrected list). It is defined by *where the sound was made*, not by what it sounds like: **"fake sound effects that sound completely real, but they're actually recorded sitting inside a studio."** Named members: **footsteps, clothes, a door creak** — and the stated purpose is realism, not emphasis. That is why the family is `sfx/diegetic` and lives on `layer/sfx` even though its material is performed rather than captured on location.

The family matters twice over. Once as a **fetch target** — most Foley is available in a licensed library and does not need performing ([[sfx-foley-replacement-pass]], [[sfx-foley-three-element-checklist]]). And once as the video's **entry point into making your own sounds**: the whole 00:07:27–00:09:36 block is *inside* the Foley section, not a loose appendix. That block gives exactly two recipes, and they are the two halves of DIY sound:

1. **Perform it, then process it.** Record a whoosh with your own mouth, then run the Premiere **Pitch Shifter** chain over it. The order is the part everyone gets wrong: the pitch goes **up first** — the mouth recording is *"a bit heavy… it's going 'hoo hoo hoo'"* and raising the pitch kills that body — then **down to 0.6**, then a **low-pass filter** to take the mouth's top end off. Up, down to 0.6, low-pass. Not one downward move.
2. **Mix two real sounds into an impossible one.** **Bone break = wood breaking + water splash.** The wood supplies the snap, the water supplies the wet. *"Nobody will ever find out. I've done this plenty of times."* A cucumber snapping is offered as the same trick performed rather than fetched.

The claim that Foley "creates realism in the scene" belongs here and **only** here — it is frequently mis-attributed to the whip, which creates a genre reference rather than realism ([[sfx-whip-crack-on-snap-cut]]).

## When to use it
- **Whenever a physical action is visible and the production audio does not carry it** — the standard case, and the reason the family exists ([[sfx-diegetic-action-inventory]]).
- **Reach for the fetch first.** Footsteps, cloth and door shelves are deep and the file is free; performing is for when the search fails.
- **Perform it when the sound has no catalogue name** — a specific texture, a prop unique to your shot, an invented object, or a comedy beat whose timing you want to control at the source ([[sfx-performed-foley-substitution]]).
- **Mix two sounds when the referent is impossible or unshootable** — breaks, tears, impacts on bodies, creatures, fire on skin. Anything you cannot ethically or practically record ([[sfx-substitute-material-foley]]).
- **Not for emphasis.** A Foley sound that is *noticed* has failed; the aesthetic layer is where attention is bought ([[sfx-felt-not-noticed]], [[sfx-intensify-without-referent]]).
- **Not as a substitute for ambience.** Foley is discrete events tied to actions; the bed underneath is a different layer ([[sfx-ambience-layer-stack]]).

## How to recognise it in a reference video
- **Count the actions, then count the sounds.** Play a 20-second stretch and list every physical event — a hand landing on a desk, a jacket moving, a mug set down. In a Foley-passed video the count matches. A gap of more than two or three unsounded actions per 20 s means the pass was never run ([[sfx-unsounded-motion-audit]]).
- **Listen for level consistency across cuts.** Location audio changes character at every angle; a Foley pass is uniform because all of it was recorded or fetched in one place. Uniform footsteps across three angles is the tell.
- **Look for a noise floor under the effect.** Library and studio Foley arrives with near-silent surroundings, which is why the bed has to be added back ([[sfx-record-clean-add-world]], [[sfx-noise-floor-target]]).
- **Mouth-made effects are identifiable by spectrum.** A performed whoosh keeps formant structure — energy clustered in 300–3000 Hz with vocal-tract resonances — where a library whoosh is broadband filtered noise. On a spectrogram the performed one has horizontal bands; the fetched one does not. That is what the low-pass step in the chain is disguising.
- **Compound effects have two attacks.** A wood-plus-water break shows a sharp transient followed 20–120 ms later by a broadband wet splash. One attack = one file; two = a build.
- **Sync tolerance.** Foley that was placed rather than performed to picture drifts. Anything past about 2 frames late reads as dubbed ([[sfx-av-sync-binding-window]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `pitch_up_first` | +3 to +5 semitones | +2 to +7 | The de-heavying move on a mouth recording. The source does it before anything else. |
| `pitch_final_ratio` | **0.6** | 0.55–0.75 | The stated landing value. As a ratio, not semitones — see [[sfx-pitch-ratio-point-six]]. |
| `lowpass_frequency` | 6000 Hz | 3500–9000 Hz | Final step of the DIY whoosh chain; takes mouth sibilance and room top off. |
| `lowpass_poles` | 2 | 1 or 2 | 2 = 12 dB/oct, the usual biquad; 1 for a gentler tilt. |
| `edge_fade` | 10 ms | 5–25 ms | Head/tail handles so the effect *"comes in and ends properly"* ([[sfx-edge-fades-click-free]]). |
| `compound_offset` | 45 ms | 20–120 ms | Wet layer behind the snap in a two-ingredient build. Under 20 ms it fuses into one timbre. |
| `compound_ratio` | snap 0 dB / wet −6 dB | −3 to −10 dB | The wet layer supports; it never leads. |
| `foley_level` | −18 dB (`data-volume="0.126"`) | −22 to −14 dB | Under dialogue, above the ambience bed ([[sfx-layer-volume-targets]]). |
| `variants_per_action` | 3 | 2–5 | Repeated actions need rotation ([[sfx-repetition-variant-rotation]]). |

## Reproduction prompt

```
Build the Foley pass for {{SHOT}}. Fetch first, perform second, mix third.

1. SPOT THE ACTIONS. Watch the shot with the audio off and list every physical
   event with its frame. Classify each as feet / cloth / object.
2. FETCH what the catalogue has. For each row run SearchSoundEffects with the
   family term plus a material word, filter duration to the length of the
   action, and download WAV. Stop here for anything ordinary.
3. PERFORM only what step 2 could not supply:
   a. record the effect with your own mouth or with a prop, close-mic, in the
      quietest room available;
   b. run a noise pass BEFORE anything else - the source flags noise on the
      raw take;
   c. Pitch Shifter, and RAISE the pitch first (+3 to +5 st) to remove the
      "hoo hoo hoo" body of a mouth recording;
   d. bring the pitch back DOWN to a ratio of 0.6;
   e. low-pass at 6 kHz to remove the mouth's top end;
   f. fade 10 ms at head and tail.
   Audition against picture after (d) and again after (e) - if the effect is
   now recognisably a person making a noise, the low-pass is too high.
4. MIX A COMPOUND for anything impossible: pick a SNAP ingredient and a WET or
   BODY ingredient, place the wet 45 ms behind the snap, wet 6 dB down, and
   bounce the pair as one file before placing.
   bone break  = wood breaking + water splash
   ice crack   = wood/plastic snap + glass shard scatter
   body impact = leather/cloth thump + low sub
5. PLACE, then run the rotation check: no identical file twice inside 8 s.

ACCEPTANCE TEST: play the shot for someone who has not seen it and ask what
they heard. If they name the sounds, the pass is too loud. If they say the
shot "sounds real", it is correct. If they say a particular sound was funny or
strange, it is a performed take whose formants are still audible - lower the
low-pass by 1 kHz and re-audition.
```

## Execution spec

**Epidemic Sound — fetch before you perform.** Sound effects are a separate surface from recordings and the six music facets do **not** apply to it ([[sfx-epidemic-facet-query]]); `duration` in milliseconds is the filter that does the work.

```
SearchSoundEffects { query:{term:"footsteps sneakers concrete"}, filter:{duration:{min:300,max:1500}} }
SearchSoundEffects { query:{term:"cloth movement"},             filter:{duration:{max:3000}} }
SearchSoundEffects { query:{term:"door creak wood"},            filter:{duration:{min:500,max:4000}} }
SearchSoundEffects { query:{term:"wood break snap"},            filter:{duration:{max:2000}} }
SearchSoundEffects { query:{term:"water splash"},               filter:{duration:{max:2000}} }
DownloadSoundEffect { id:<id>, options:{ fileType: WAV } }
```
WAV always: this material gets pitch-shifted and filtered, and mp3 pre-echo smears exactly the transients the compound recipe depends on. Once one footstep is right, `SearchSimilarToSoundEffect` on its id returns the family for the rotation set rather than a fresh neighbourhood of the catalogue.

**HyperFrames — the processed DIY chain.** The Premiere Pitch Shifter has no in-stack equivalent (pitch is a **file** operation here), so the pitch work is baked with ffmpeg and only the low-pass and the fades live in the composition:

```html
<audio id="foley-whoosh-01" src="assets/sfx/whoosh-mouth-06.wav"
       data-audio-group="sfx" data-start="12.40" data-duration="0.62"
       data-track-index="12" data-volume="0.126"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Take The Mouth Off&quot;,&quot;params&quot;:{&quot;frequency&quot;:6000,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.01,&quot;v&quot;:1},{&quot;t&quot;:0.61,&quot;v&quot;:1},{&quot;t&quot;:0.62,&quot;v&quot;:0}]}]}"></audio>
```
Write JSON attributes **double-quoted with `&quot;`** or `carve.mjs`'s `name="..."` regex cannot see them. Every `<audio>` needs an `id` or it is never mixed (silent render). A `volume` lane holds its first value backwards to the clip start, so the explicit `{"t":0,"v":0}` is what makes the head fade exist. Keep Foley in the `sfx` group and **out** of any carve `sources` list — a non-voice member inside the carve group poisons the next re-analysis.

**ffmpeg — the pitch chain, in the source's order.** `asetrate` moves pitch and speed together; `rubberband` (where built) moves pitch alone.

```bash
# 1. de-heavy the mouth take: pitch UP first (+4 st), length preserved
ffmpeg -i raw-mouth.wav -af "rubberband=pitch=1.26" up.wav
# fallback if rubberband is absent - resample trick, then restore length
ffmpeg -i raw-mouth.wav -af "asetrate=48000*1.26,aresample=48000,atempo=0.794" up.wav

# 2. then DOWN to the stated 0.6 ratio
ffmpeg -i up.wav -af "rubberband=pitch=0.6" down.wav

# 3. low-pass, then 10 ms handles
ffmpeg -i down.wav -af "lowpass=f=6000:p=2,afade=t=in:d=0.01,afade=t=out:st=0.61:d=0.01" whoosh-mouth-06.wav

# compound build: wet 45 ms behind the snap, 6 dB down, bounced as one file
ffmpeg -i wood-snap.wav -i water-splash.wav -filter_complex \
 "[1:a]adelay=45|45,volume=-6dB[w];[0:a][w]amix=inputs=2:normalize=0[a]" -map "[a]" bone-break.wav
```
`normalize=0` matters: `amix` normalises by default and would pull the snap down by 6 dB, undoing the balance you just set.

**Premiere, for reference.** The named effect is **Pitch Shifter**; the space presets that finish a DIY effect are in [[sfx-essential-sound-space-presets]]. Nothing about the recipe is Premiere-specific — the order is.

**Remotion.** `<Audio volume={0.126} />` plays the baked file; there is no filter graph, so the low-pass has to be baked too.

## Pairs with
[[sfx-ten-family-catalogue]] · [[sfx-foley-replacement-pass]] · [[sfx-foley-three-element-checklist]] · [[sfx-mouth-foley-record-and-process]] · [[sfx-substitute-material-foley]] · [[sfx-performed-foley-substitution]] · [[sfx-pitch-ratio-point-six]] · [[sfx-filter-character-and-distance]] · [[sfx-essential-sound-space-presets]] · [[sfx-repetition-variant-rotation]] · [[sfx-diegetic-action-inventory]]

## Failure modes
- **Pitching straight down.** The single most common mis-execution of this recipe, and it comes from the earlier transcript: the mouth take is already heavy, so a downward-only move makes it a muddy blob. Up first, then to 0.6.
- **Skipping the noise pass.** A self-recorded take carries room noise that the pitch shift then turns into an audible warble. Denoise before processing, never after.
- **Low-passing too hard.** Below about 3.5 kHz a whoosh stops moving air and becomes a rumble. If the effect sounds like it is behind a door, that is the [[sfx-filter-character-and-distance]] use, not this one.
- **Compound layers stacked at zero offset.** Wood and water on the same frame fuse into one unidentifiable timbre. 20–120 ms of offset is what makes the ear read two materials.
- **Treating Foley as an emphasis layer.** Loud Foley pulls attention to a footstep and away from the line. It belongs 12–18 dB under dialogue.
- **One file for a repeated action.** Four identical footsteps is the source's own named mistake, transplanted from whooshes. Rotate three variants or vary pitch by ±2%.
- **Performing what the catalogue already has.** A studio-quality door creak is one query away; performing it spends an hour to lose 6 dB of signal-to-noise.
- **Known gap:** nothing in this stack pitch-shifts inside the composition — `data-playback-rate` is pitch-*preserved* and constant, so it changes speed without changing pitch and cannot substitute for the Pitch Shifter step. Every pitch decision is baked into the file, so record the chain (`+4 st → 0.6 → LP 6 k`) in the asset's filename or ledger or it cannot be reproduced.
