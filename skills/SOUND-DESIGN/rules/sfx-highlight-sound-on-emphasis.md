---
id: sfx-highlight-sound-on-emphasis
title: The highlight sound — what goes on a thing that gets marked rather than moved
skill: sound-design
type: sfx
family: highlight
tags: [skill/sound-design, type/sfx, family/highlight, sfx/aesthetic, layer/sfx, layer/design, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:11:13"
    quote: "And if something gets highlighted, a highlight sound."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:38"
    quote: "Animate in the most important line of text, or the most important part of the image you are highlighting; darken the area surrounding the focal point; blur the area surrounding the focal point; circles, arrows and underlines."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:32"
    quote: "Aesthetic sound effects — cinematic hits, rises, textures, plus a whoosh or air sound on body movement, a camera zoom, even an eye roll. The viewer won't notice them but will feel them."
research_refs:
  - https://en.wikipedia.org/wiki/Spectral_centroid
  - https://en.wikipedia.org/wiki/Just-noticeable_difference
  - https://en.wikipedia.org/wiki/Habituation
  - "mcp://Epidemic_sounds/SearchSoundEffects — probed live 2026-08-28: magic--shimmer (1030 hits, 3.8–5.2 s), user-interface--click (2801 hits, 0.30–0.81 s)"
difficulty: low
detectable_from: transcript+video
---

# The highlight sound — what goes on a thing that gets marked rather than moved

## What it is
The second of the two rules in the sound-effect pass, and the one with no obvious answer. A **highlight event** is a moment when something on screen is *marked as important without travelling*: the surround darkens or blurs, a circle or underline draws on, a glow rises, the colour shifts warm or cold, a key line of text animates in, a caption keyword pops. There is no movement for an air sound to describe and no impact for a hit, so the sound has to signal *attention* instead of physics.

Three sound families do that job, and they are not interchangeable. **Shimmer / twinkle** — a bright, narrowband, slightly random sparkle, energy mostly above 4 kHz: reads as "look, this is special", and is the family the word "highlight sound" usually means. **UI click / select** — a short, dry, synthetic transient: reads as "this has been *selected*", correct for cursor-driven, screen-recording and interface content. **Soft swell / bell** — a short bloom with a tonal centre: reads as "this is significant", the quietest and most cinematic of the three. Brightness is the axis they share: the spectral centroid predicts perceived brightness, and brightness is exactly what makes a sound feel like a pointer rather than an object.

The catalogue fact that decides the craft: probed live, `magic--shimmer` assets run **3.8–5.2 seconds**, while a highlight event lasts **6–15 frames**. A highlight sound is therefore almost always a *trimmed excerpt with an authored tail*, not a file dropped whole.

**Style.** Filed `sfx/aesthetic`: a highlight event has nothing moving for the sound to describe, so the cue is chosen for the attention it creates rather than for a movement it tracks. If the highlighted element also travels, it earns a separate motion cue under [[sfx-motion-sound-selection]].

## When to use it
Trigger on any of the six focal-point methods from the creator's own taxonomy plus caption emphasis:
- **Surround darkens or blurs** to isolate a focal point → soft swell, or shimmer at the low end of the gain band.
- **Circle, arrow or underline draws on** → shimmer if the annotation is decorative; UI click if it reads as an interface action; a short swish if the stroke actually travels ([[sfx-swoosh-vs-whoosh]] — a drawing stroke is a travel event and may want both).
- **Glow rises on the subject** → soft swell, ramped with the glow rather than struck.
- **Colour shifts toward red (negative) or yellow/green (positive)** → this one usually wants **no** sound; the grade carries it. Sound it only if the shift is abrupt and narratively loaded, and then with a low tonal swell, never a sparkle.
- **A key line of text animates in / a keyword caption pops** → UI click or a very short shimmer, at the bottom of the gain band, and **not on every keyword**.
- **A number or stat resolves** → shimmer or bell on the resolve frame, paired with the counter's own tick family ([[motion-number-rollup-stat-reveal]]).

Do **not** use a highlight sound when the highlighted thing also travels or scales significantly — that is rule 1, and doubling both reads as clutter. Do not use one on every item of a list; mark the item that matters. And do not use shimmer in a serious register: sparkle is tonally cheerful and will fight a grave line whatever the level.

## How to recognise it in a reference video
- **Find the highlight events on the video track first.** Highlight events are luminance/saturation changes localised to a region while global motion stays low. Practical detector: motion trace low (`YAVG < 2.0`) while the frame's mean luminance or its variance jumps.
  ```bash
  ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=luma.txt" -f null -
  ```
  A **≥ 4 %** step in YAVG with no shot change and no motion run is a vignette/darken-surround highlight. Draw-ons and glows show as small localised changes — those need a visual pass, not a metric.
- **Then classify the sound by its band, not by ear.** Highlight sounds are the brightest things in the mix:
  ```bash
  ffmpeg -v error -ss <t> -t 0.5 -i ref.wav -af "aspectralstats=measure=centroid,\
  ametadata=print:key=lavfi.aspectralstats.1.centroid:file=-" -f null - 2>/dev/null | head -20
  ```
  **Shimmer: centroid 4–9 kHz**, often above. **UI click: 1.5–4 kHz**, short and dry. **Soft swell/bell: 400 Hz–2 kHz** with a slow attack. Anything with a centroid under 400 Hz on a highlight event is a cinematic hit, which is a different note ([[sfx-cinematic-hit-emphasis]]).
- **Measure attack time.** Highlight sounds split cleanly: click/shimmer attacks are **under 20 ms**; swells are **80–400 ms**. Attack time tells you whether the reference *struck* the highlight or *ramped* it, which is the single most copyable decision in this family.
- **Count them, separately from air sounds.** Healthy density is **3–8 highlight sounds per minute**; above ~10 the video starts to sound like a slot machine. Habituation is the reason: the shorter the interval between repeats, the faster the response decays, so a sparkle on every keyword stops working within a minute and the video has spent its attention currency.
- **Check level relative to dialogue.** Highlight sounds sit **−18 to −15 dB** under dialogue at 0 to −3 dB — audibly below the motion-SFX band. A highlight sound level-matched to a whoosh is the commonest mixing error in this family, because bright sounds read louder than they measure.
- **Check for masking against sibilants.** A shimmer sitting on a spoken `s`/`sh` costs the consonant, since both live at 4–9 kHz. In good work the highlight lands in a speech gap or on a stressed vowel.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `shimmer_used_length` | 0.60 s | 0.35–1.0 s | The *authored* length, trimmed out of a 3.8–5.2 s catalogue file with `data-media-start`. |
| `click_length` | 0.35 s | 0.20–0.80 s | Catalogue UI clicks measured 0.30–0.81 s; use whole. |
| `swell_length` | 0.90 s | 0.6–1.6 s | Ramped, not struck; ends into the line it introduces. |
| `media_start_into_shimmer` | 0.35 s | 0.15–0.8 s | Sparkle files usually have a soft head; start after it so the transient is immediate. |
| `tail_fade` | 0.15 s | 0.08–0.30 s | Volume-lane fade at the end of the used window, so the trim is not a click. |
| `anchor_draw_on` | resolve frame | resolve − 1 to resolve + 1 | An annotation's sound lands where the stroke *completes*, not where it starts. |
| `anchor_glow` | glow onset | onset to onset + 3 frames | A ramped swell starts with the glow and peaks with it. |
| `anchor_keyword_pop` | pop frame | pop − 1 to pop | Caption pops are struck on the frame. |
| `gain_highlight` | 0.150 (≈ −16.5 dB) | −18 to −15 dB rel. dialogue | Below the −12/−15 dB SFX band because these are decorative and frequent. |
| `gain_swell` | 0.126 (≈ −18 dB) | −20 to −16 dB | Tonal sounds need less level to be felt. |
| `highlight_per_minute` | 5 | 3–8 | Hard ceiling 10. Count separately from air sounds. |
| `sibilance_guard` | 3 frames | 2–5 frames | Minimum distance from a spoken `s`/`sh`/`t`, or notch 4–9 kHz by −3 dB. |
| `variants_per_family` | 3 | 3–6 | Rotate; a repeated sparkle is the most noticeable repetition in the mix. |

## Reproduction prompt

```
Place a highlight sound on the highlight event at {{EVENT}} seconds in {{COMP}}.

1. CONFIRM IT IS A HIGHLIGHT, not a move. The marked element must not travel or
   scale by more than 10% of frame during the event. If it travels, stop: this is
   an air-sound event (rule 1), not a highlight.
2. PICK THE FAMILY from what the picture does:
   surround darken/blur        -> SWELL
   circle/arrow/underline draws-> SHIMMER (add a swish if the stroke travels)
   glow rises                  -> SWELL, ramped
   colour shift only           -> usually NOTHING; if abrupt and loaded, SWELL
   keyword caption pop         -> CLICK, or a 0.35 s SHIMMER
   stat/number resolves        -> SHIMMER or bell on the resolve frame
   screen-recording / cursor   -> CLICK, always
3. FETCH 3 candidates (queries in the Execution spec). Shimmer files run 3.8-5.2 s
   in the catalogue: you will trim, so judge candidates on their first second.
4. TRIM to {{USED_LEN}} (default 0.60 s shimmer / 0.35 s click / 0.90 s swell):
   set data-media-start so the file's transient is at the very start of the used
   window, and end the window with a volume lane fading to 0 over 0.15 s.
5. ANCHOR: draw-on -> the frame the stroke COMPLETES. glow -> the glow's onset.
   keyword pop -> the pop frame. Then data-start = anchor - peak_offset, where
   peak_offset is measured, not guessed (see sfx-peak-offset-measurement).
6. GAIN 0.150 for shimmer/click, 0.126 for swell. Never match a whoosh's level.
7. CHECK THE WORD UNDER IT. If the anchor is within 3 frames of a spoken s/sh/t,
   move the anchor into the nearest speech gap, or add a peaking node at 6 kHz
   with gain -3 dB, q 1.4 on the highlight clip. Do not raise its level to win.
8. BUDGET: count highlight sounds in the whole video. Above 8 per minute, delete
   the least narratively important ones until you are under. Above 10, the pass
   has failed regardless of how good each sound is.

ACCEPTANCE TEST: mute the highlight bus and watch the section. The highlighted
things should still be visible but should stop feeling pointed-at. Unmute: no
individual sparkle should be nameable, and no spoken consonant should have gone
soft. If you can hear "the sparkle sound", drop 2 dB and shorten the tail.
```

## Execution spec

**Epidemic Sound — probed live 2026-08-28.** The catalogue has no tag called "highlight". The three families map onto real slugs, and the title grammar is a comma-separated descriptor chain that is itself a good search term.

```
# SHIMMER family - 1030 hits, durations measured 3846-5171 ms (trim these)
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["magic--shimmer"]} },
                     sort:{by:POPULARITY,order:DESCENDING}, first:24 }
#   real titles: "Magic, Shimmer, Spell, Cast, Transform, Shimmer, Sparkle, Twinkle 01"
#                "Magic, Shimmer, Spell, Cast, Dispel Magic, Cleanse, Twinkle, Glimmer, Short 02"
#   term fallback: "magic shimmer twinkle glimmer short positive"
#   pick titles containing Short / Twinkle / Glimmer; avoid Spell / Attack / Heal
#   (they carry a game-y tail you will have to trim off anyway)

# CLICK family - 2801 hits, durations measured 299-814 ms (use whole)
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["user-interface--click"]},
                              duration:{min:200,max:900} }, first:24 }
#   real titles: "User Interface, Click, Accept, Select, Digital, Short, Synthetic"
#                "User Interface, Click, Pops, Glass, UI, Pops"
#   descriptors that matter: Select, Positive, Negative, Accept, Short, Synthetic, Glass

# SWELL family - no dedicated slug; search terms, then similarity
SearchSoundEffects { query:{ term:"designed swell soft bloom short reverse cinematic subtle" },
                     filter:{ duration:{min:500,max:1800} }, first:24 }

SearchSimilarToSoundEffect { id:<the one that worked>, first:12 }   # rotation set of 3+
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Judge candidates on `audioFile.durationInMilliseconds` and on the first second of `audioFile.lqmp3Url`. Download WAV: a 300 ms bright transient is exactly where mp3 pre-echo is audible.

**HyperFrames — the trim, the tail and the sibilance notch.** All times in seconds.
```html
<!-- underline completes at 14.900 s; shimmer peak_offset (after trim) 0.020 s -->
<audio id="sfx-hl-shimmer-03"
       src="assets/sfx/highlight/magic_shimmer_twinkle_short_02.wav"
       data-audio-group="sfx" data-start="14.880" data-duration="0.60"
       data-media-start="0.35" data-track-index="13" data-volume="0.150"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.45,&quot;v&quot;:1},{&quot;t&quot;:0.60,&quot;v&quot;:0}]}]}"></audio>

<!-- same sound, landing near a sibilant: notch the shared band on the effect -->
<audio id="sfx-hl-shimmer-04"
       src="assets/sfx/highlight/magic_shimmer_twinkle_short_02.wav"
       data-audio-group="sfx" data-start="21.310" data-duration="0.55"
       data-media-start="0.35" data-track-index="12" data-volume="0.150"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Make room for the S&quot;,&quot;params&quot;:{&quot;frequency&quot;:6000,&quot;gain&quot;:-3,&quot;q&quot;:1.4}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>

<!-- glow: ramped swell, attack authored as a lane rather than struck -->
<audio id="sfx-hl-swell-01" src="assets/sfx/highlight/designed_swell_soft_01.wav"
       data-audio-group="sfx" data-start="30.100" data-duration="0.90"
       data-track-index="13" data-volume="0.126"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.35,&quot;v&quot;:1},{&quot;t&quot;:0.70,&quot;v&quot;:1},{&quot;t&quot;:0.90,&quot;v&quot;:0}]}]}"></audio>
```
Contract points: a `volume` lane's `t` is **clip-local** and its **first value is held backwards** to the clip start — hence the explicit `t: 0` in each lane. Do not additionally GSAP-tween `volume` (`audio_volume_double_automation`: the lane wins, the tween is ignored). `peaking` takes `frequency` 20–20000 Hz, `gain` −40..40 dB, `q` 0.1–20, and out-of-range values are clamped on read. Signal order is chain order; keep `limiter` last. Alternate track indices 12/13 for adjacent highlights so overlaps do not raise `duplicate_audio_track`. Every `<audio>` needs an `id` or it is never mixed.

**ffmpeg — only when the trim needs to be a real file.** In-composition trimming needs no new file (`data-media-start` + `data-duration`); cut one only for an asset leaving the pipeline:
```bash
# take 0.35-0.95 s out of a shimmer, with a 30 ms in-fade and 150 ms out-fade
ffmpeg -i shimmer.wav -ss 0.35 -t 0.60 \
  -af "afade=t=in:st=0:d=0.03,afade=t=out:st=0.45:d=0.15" shimmer_hl_600ms.wav
# check the centroid actually says "bright"
ffmpeg -v error -i shimmer_hl_600ms.wav -af "aspectralstats=measure=centroid,\
ametadata=print:key=lavfi.aspectralstats.1.centroid:file=-" -f null - 2>/dev/null | head
```

**Remotion:** an `<Audio startFrom={...}>` inside a `<Sequence>` of the trimmed length, with a volume callback for the tail. Concept only.

## Pairs with
[[sfx-motion-pass-two-rules]] · [[sfx-appearance-transient]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-swoosh-vs-whoosh]] · [[sfx-peak-offset-measurement]] · [[sfx-felt-not-noticed]] · [[sfx-density-fatigue-audit]] · [[sfx-repetition-variant-rotation]] · [[sfx-filter-character-and-distance]] · [[motion-image-focal-point-direction]] · [[motion-key-region-animate-in]] · [[motion-subject-glow-separation]] · [[motion-annotation-draw-on]] · [[motion-spotlight-mask-reveal]] · [[sub-emphasis-caption-three-words]]

## Failure modes
- **A 4.5 s shimmer under a 12-frame highlight.** The sparkle rings on over the next sentence and the video sounds like a fairy tale. Fix: trim to 0.6 s with `data-media-start` and end it with a volume lane.
- **Highlight sounds at whoosh level.** Bright sounds read louder than they measure, so a level-matched sparkle dominates. Fix: −18 to −15 dB, verified against dialogue, not by ear.
- **Sparkle on a serious line.** Timbre carries tone; the shimmer family is cheerful and will contradict the words. Fix: swell family, or nothing.
- **A shimmer landing on a sibilant.** Both occupy 4–9 kHz and the consonant loses. Fix: move into a speech gap, or notch 6 kHz by −3 dB on the effect.
- **One sparkle per caption keyword.** The fastest route to habituation in the whole library. Fix: 3–8 per minute, and only on the beat that matters.
- **A highlight sound on a moving element.** Doubles rule 1 and rule 2 and reads as clutter. Fix: classify first; travel wins.
- **Sounding a colour grade shift.** Nothing physical happened; the sound has no referent and the viewer registers it as arbitrary. Fix: leave it silent unless the shift is a narrative jolt.
- **Known gap:** "highlight sound" is the creator's term, not a catalogue category — there is no `highlight` tag to filter on, so this family is reached through three different slugs plus similarity search. Record the exact uuid that worked in the project's palette, because the query is the least reproducible part of this note.
