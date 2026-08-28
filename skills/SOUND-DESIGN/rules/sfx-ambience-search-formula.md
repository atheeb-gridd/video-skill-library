---
id: sfx-ambience-search-formula
title: Ambience beds - the "<place> + ambience" search formula and its exceptions
skill: sound-design
type: sfx
family: ambience
tags: [skill/sound-design, type/sfx, family/ambience, engine/epidemic, engine/hyperframes, sfx/diegetic, layer/ambience, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:02:55"
    quote: "Including these gives the scene a real atmosphere. Whatever you need - traffic ambience, people chattering ambience, birds ambience - basically just tack \"ambience\" on."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:09:41"
    quote: "Even in movies they use the sounds of that real location, so that you feel like you're actually there. On a platform like Epidemic you get ambience sounds for every kind of location. Rain, marketplace, forest, office, everything."
research_refs:
  - https://en.wikipedia.org/wiki/Sound_effect
  - https://en.wikipedia.org/wiki/Room_tone
  - https://en.wikipedia.org/wiki/Walla
  - mcp://Epidemic_sounds/SearchSoundEffects (ambience tag slugs and title grammar probed live, 2026-08-27)
difficulty: low
detectable_from: audio
---

# Ambience beds - the "<place> + ambience" search formula and its exceptions

## What it is
The most reusable search recipe in the library: take the location, append the word *ambience*, and you have a query. `traffic ambience`, `office ambience`, `forest ambience`. Ambience is the diegetic bed that tells the viewer where they are — in the industry taxonomy, the **backgrounds** class, *"sounds that do not explicitly synchronize with the picture, but indicate setting to the audience"*. Research adds the three exceptions where the formula fails and the library uses a different word: crowd murmur is **walla**, the featureless silence of a space is **room tone** (*"'silence' recorded at a location… lacks explicit background noise"*), and outdoor-nature beds are indexed by the place, not the animal.

## When to use it
- **Any shot that claims a location.** A market scene with no market underneath it reads as a green screen. This is mistake number two in the source video's own list.
- **Under any music drop-out.** [[sfx-music-hard-stop]] needs a floor so the silence is not digital.
- **Across every split edit** ([[sfx-split-edit-lead-lag]]) so the space crossfades instead of switching.
- **Under a talking-head A-roll** shot in a real room, at very low level, to glue the cuts together.
- Skip it only for pure graphics sequences with no implied space, and for formats that are deliberately dry.

## How to recognise it in a reference video
- **Look at the noise floor between words.** An ambience bed shows as a continuous low-level signal that does not stop at cuts. Measure it: `ffmpeg -i ref.wav -af astats=metadata=1:reset=5 -f null -` and read RMS in the speech gaps. A bed is present if the gap floor sits **20–30 dB under the dialogue RMS** rather than dropping to the noise floor of the recording.
- **A bed survives picture cuts.** If the floor changes character exactly on each cut, there is no bed — you are hearing raw camera audio.
- **Spectrogram signature:** traffic = broad low-frequency rumble under 500 Hz with occasional pass-by sweeps; walla = energy concentrated in the 300–3400 Hz speech band with no intelligible words; birds/park = sparse transients above 2 kHz over a quiet floor; room tone = near-flat, eventless.
- **Loop tell:** the same distinctive event (a horn, a laugh) recurring at an exact interval means a short file has been looped and the loop point is audible.
- Count the beds: sophisticated sound design runs **two** ambience layers (a wide bed plus a closer detail layer), not one.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Bed level | −28 dB → `data-volume="0.04"` | −32 to −24 dB (0.025–0.063) | Must sit under music; if you can name it while the voice runs, it is too loud. |
| Minimum asset length | 90 s | 60–300 s | `filter.duration.min` is in **milliseconds** (90000). |
| Crossfade at location change | 0.5 s | 0.3–1.5 s | Volume lanes on both beds. |
| Head/tail fade | 0.3 s | 0.2–1.0 s | Prevents a hard start on the bed. |
| Layers per location | 1 | 1–2 | Wide bed + optional detail layer. |
| Low-pass for "indoors/next room" | 2000 Hz | 800–4000 Hz | `lowpass` node makes an exterior bed read as heard-through-a-wall. |
| High-pass on every bed | 60 Hz | 40–90 Hz | Removes rumble that eats headroom for nothing. |

## Reproduction prompt

```
Add the ambience bed for {{LOCATION}} across {{IN}} to {{OUT}}.

1. BUILD THE QUERY. Default form: "<location> ambience".
   USE THE EXCEPTION WORD instead when it applies:
     crowd / people chattering / restaurant / cafe -> "walla" or
        "ambience restaurant bar cafe crowded voices"
     the quiet of an interior with no events       -> "room tone <space>"
     outdoors with birds                           -> "ambience park birds chirping"
        (search the PLACE, not the animal)
2. FETCH. SearchSoundEffects with
     query: { term: "<query>" }
     filter: { duration: { min: 90000 } }        // milliseconds
     first: 5
   Audition all 5 via lqmp3Url. Reject any with a recognisable one-off event
   (a shout, a siren) that will draw attention when looped.
   Download the winner: DownloadSoundEffect { id, options: { fileType: "WAV" } }
3. PLACE as a single clip spanning {{IN}} to {{OUT}} on its own track index,
   data-audio-group="ambience", data-volume="0.04". If the asset is shorter than
   the section, place consecutive clips and offset data-media-start on each so
   no two clips play the same 10 seconds - never loop from 0 twice in a row.
4. SHAPE. Add a volume lane with a 0.3 s fade in and out. Add a highpass node at
   60 Hz. If the location is heard from indoors, add a lowpass at 2000 Hz.
5. If a music drop-out or a split edit falls inside {{IN}}-{{OUT}}, confirm the
   bed spans it - the bed is what stops silence reading as a fault.

ACCEPTANCE TEST: mute the bed and play the section; it should feel noticeably
flatter and more "studio". Unmute it; you should not be able to point at the
sound while the presenter is talking. If you can name it during speech, cut 3 dB.
```

## Execution spec

**Epidemic Sound.** Verified live, with the exceptions that make this note worth more than the transcript line:

| Need | Query that works | Real tag slug returned |
|---|---|---|
| Street / road | `traffic ambience` | `ambience--traffic` |
| Cafe, restaurant, crowd murmur | `cafe crowd chatter ambience` → returns **Crowds, Walla, Busy Cafe Ambience** | `crowds--walla`, `ambience--restaurant-bar` |
| Outdoors, birds | `ambience birds chirping park` | `ambience--park` |
| Interior "silence" | `room tone office quiet` | `ambience--room-tone` |

Titles read `Ambience, Traffic, Highway, Traffic, Close` — comma-delimited descriptors — so stacking three or four descriptor words in `query.term` is the reliable retrieval route. Always set `filter.duration.min` (milliseconds) to force multi-minute beds; without it you get one-shots. Note that some genuinely good assets return an **empty `tags` array**, so filtering on `tagSlugs` alone will miss them, and an invented slug like `ambience--nature` returns `total: 0` rather than an error.

**HyperFrames.**
```html
<audio id="amb-street" src="assets/audio/amb/traffic.wav"
       data-audio-group="ambience" data-start="{{IN}}" data-duration="{{OUT-IN}}"
       data-media-start="4" data-track-index="13" data-volume="0.04"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:60,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.3,&quot;v&quot;:1},{&quot;t&quot;:{{LEN_MINUS_0_3}},&quot;v&quot;:1},{&quot;t&quot;:{{LEN}},&quot;v&quot;:0}]}]}"></audio>
```
The lane's `v` is the track's own 0..1 volume, and it **holds its first value backwards and its last forward** — so the `t:0` point is required or the bed starts already faded. Where `data-volume` and a `volume` lane coexist, keep them consistent; do not add a GSAP `volume` tween as well (`audio_volume_double_automation`). In a modular project, **keep ambience at the host root** so it survives scene cuts. Give the bed its own `data-track-index` — two `<audio>` sharing an index and overlapping raises `duplicate_audio_track`.

Keep the ambience group **out of** the `voiceover` carve group: *"a bed or an SFX clip inside the named group poisons the next re-analysis silently."*

**ffmpeg.** To build a longer bed from a short asset without an audible loop, cut two offset segments and crossfade rather than concatenating:
```bash
ffmpeg -i amb.wav -filter_complex "[0]atrim=0:60,afade=t=out:st=57:d=3[a];[0]atrim=30:90,afade=t=in:d=3[b];[a][b]concat=n=2:v=0:a=1" amb.long.wav
```

**Remotion.** `<Audio src={staticFile('amb.wav')} volume={0.04} loop />` — same bed, same level; the fades become an interpolated volume.

### Facet note — the six music facets do not exist on this surface
The Epidemic UI's filter bar (**`Moods | Genres | Duration | BPM | Vocals | Key`**) belongs to the **music** catalogue. Ambience is fetched from `SearchSoundEffects`, where five of those six are simply not available: there is no mood, no BPM, no vocals and no key dimension, and the only filters are `tagSlugs`, `duration` (milliseconds) and `soundEffectIDs`. A query written as though the facets applied does not error — the unknown fields are ignored and the fetch quietly degrades to free text, which is the worst of both worlds because it looks constrained and is not.

So on this surface **`duration` carries the entire filtering load**, which is exactly why `filter.duration.min` at 90000 ms is the load-bearing line in the recipe above, and why descriptor stacking in `query.term` (`Ambience, Traffic, Highway, Close`) does the work a mood facet would do on the music side. Where an ambience must behave like a musical cue instead — a tonal drone under a passage — fetch it from `SearchRecordings` and the six facets apply again ([[sfx-tone-bed-mystery]], [[sfx-epidemic-facet-query]]).

## Pairs with
[[sfx-name-before-search]] · [[sfx-layer-volume-targets]] · [[sfx-music-hard-stop]] · [[sfx-split-edit-lead-lag]] · [[sfx-sound-pass-order]] · [[struct-stimulation-budget]] · [[sfx-epidemic-facet-query]] · [[sfx-ten-family-catalogue]]

## Failure modes
- **No bed at all.** The named mistake: *"missing ambience"*. The video reads as recorded in a vacuum, and every cut becomes audible.
- **A bed you can hear.** If a viewer can name the ambience while the presenter is speaking, it is 5–8 dB too loud. It is furniture, not content.
- **Looping a short file from zero.** The distinctive event recurs on a fixed interval and the whole bed collapses into an obvious loop. Offset `data-media-start` per clip, or crossfade two offset segments.
- **Searching "ambience" for crowd chatter.** The library word is **walla**. This is the formula's main blind spot.
- **Confusing room tone with ambience.** Room tone is eventless presence for bridging dialogue edits; ambience carries identifiable events. Using ambience where room tone belongs makes a quiet interior sound like a location shoot.
- **Putting the bed in the voiceover carve group.** Poisons the next carve analysis silently. Ambience gets its own group.
