---
id: sfx-swoosh-vs-whoosh
title: Swoosh vs whoosh — one air family, split by brightness and by mass
skill: sound-design
type: sfx
family: whoosh
tags: [skill/sound-design, type/sfx, family/whoosh, engine/epidemic, engine/hyperframes, engine/ffmpeg, sfx/motion, layer/sfx, source/sfx-kt-1, source/research, difficulty/low]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:01:23
    quote: "Look, whoosh and swoosh are very similar sound effects, but between the two there's also a very small difference."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:01:32
    quote: "Both sound effects are really the movement of air [cue truncated in both new passes - the rest of the whoosh-vs-swoosh distinction is lost]"
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:01:53
    quote: "[older pass only] So if you want a higher-pitched / top-end sound, use swoosh."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:01:16
    quote: "You can tweak this by changing the pitch. If you push the pitch high, the sound effect will feel a bit lighter, but if you take the pitch low, it'll sound like a really heavy, weighty whoosh."
research_refs:
  - https://en.wikipedia.org/wiki/Sibilant
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (catalogue taxonomy for this family probed live, 2026-08-28 - see Execution spec)
difficulty: low
detectable_from: audio
---

# Swoosh vs whoosh — one air family, split by brightness and by mass

## What it is
Both are the same physical event: broadband noise shaped by an air-movement envelope, rising then falling. The source states the difference is "very small" and, in the older transcript pass, resolves it in one direction — **swoosh is the higher-pitched, top-end version**. Acoustically that is a statement about spectral centroid and about the presence of a **friction / sibilant component**: a swoosh carries audible high-frequency hiss (the `s` in its own name, which is why saying the word out loud approximates the sound), a whoosh's energy sits lower and reads as mass.

The functional consequence, which is what the note is for: **brightness reads as low mass**. A swoosh sounds like something light and small crossing frame — a caption, an icon, a UI panel, a line drawing itself. A whoosh sounds like something with weight — a full-frame transition, a camera move, a title card the size of the screen, a body. Pick by the *apparent mass of the thing moving*, not by which word you happen to know.

There is a third member the catalogue treats as distinct and the transcript does not name: **swish**, which is the short, dry, high, single-stroke version (a stick through air, a swipe). In Epidemic's taxonomy `swish` is where most of what an editor would call "swoosh" actually lives.

**Style.** Filed `sfx/motion`: both are air sounds, and both exist because something crossed the frame. A whoosh laid in as a texture with nothing moving under it has become an aesthetic sweetener and should be budgeted as one ([[sfx-air-on-micro-movement]]).

## When to use it
- **Swoosh / swish** — text and caption entrances, icon and UI motion, a line or underline drawing on, a small graphic crossing frame, a swipe transition, a fast light wipe. Anything under roughly a third of the frame, and anything that reads as weightless.
- **Whoosh** — full-frame transitions, camera pushes and whip pans, a title card landing, a body or object with mass moving, a scene change. Anything that reads as heavy or as the whole frame.
- **Both, layered** — one whoosh for the mass plus one swish for the leading edge, when a big element needs to feel both heavy *and* fast. Split by band, never two mids ([[sfx-layered-approach-and-impact]]).
- **Neither** — if the picture is not moving. A whoosh on a static cut announces the edit ([[sfx-motion-sound-selection]]).
- **Reach for swish specifically** when the motion is under 10 frames. Whooshes long enough to have a body do not fit inside a 6-frame text slide.

## How to recognise it in a reference video
- **Measure the spectral split, do not guess it.** Isolate each air effect and compare band energy:
  ```bash
  # high band vs low band energy for the same 400 ms window
  ffmpeg -ss <t> -t 0.4 -i ref.wav -af "highpass=f=3000,astats=metadata=1:reset=0" -f null - 2>&1 | grep RMS_level
  ffmpeg -ss <t> -t 0.4 -i ref.wav -af "lowpass=f=800,astats=metadata=1:reset=0"  -f null - 2>&1 | grep RMS_level
  ```
  **Swoosh/swish: high band within 6 dB of, or above, the low band.** **Whoosh: low band 10 dB or more above the high band.** That single ratio classifies the effect reliably and is the measurement to log.
- **Listen for the friction.** A swoosh has an audible `sss` texture — narrowband hiss around **4–9 kHz**, the same region as speech sibilance, which is also why a swoosh over a spoken `s` masks it. A whoosh's noise is smooth and centred **150–800 Hz**.
- **Correlate with the moving element's screen area.** Tabulate: element area as a fraction of frame vs the band ratio. In competent work small elements get bright sounds and full-frame moves get dark ones. An inversion — bright sound on a full-frame push — is audible as "thin" and is worth logging as a defect, not a style.
- **Length separates swish from whoosh.** Swish/swoosh files cluster **150–500 ms**; whooshes **400–1200 ms** for short and **1200–2500 ms** for the long family. Measured live in the catalogue: swish assets at 191, 238, 268, 344, 367, 396 ms; whoosh assets at 546 and 878 ms.
- **Count the families separately in the density audit.** Swishes on captions are cheap and can run at high density; whooshes are expensive and tire fast. A reference at 12 air-sounds per minute is usually 10 swishes and 2 whooshes, which is fine — collapsing them into one count makes the video look overloaded on paper when it is not.
- **Check for the pitch-shifted single file.** If every air effect has the same envelope shape and only differs in pitch, the creator owns one file and is varying it — the transcript's own poverty workaround. Detectable as identical spectral *shape* translated in frequency.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `band_ratio` (high 3 kHz+ ÷ low <800 Hz) | ≥ 0 dB for swoosh · ≤ −10 dB for whoosh | — | The classifier. Frames at 30 fps elsewhere in this note; this one is dB. |
| `swoosh_length` | 280 ms | 150–500 ms | Match to the motion; fetch by duration filter, do not stretch. |
| `whoosh_length` | 550 ms | 400–1200 ms short · 1200–2500 ms long | Two families, as the source names them. |
| `mass_threshold` | 0.33 frame area | 0.2–0.5 | Element area above this → whoosh; below → swoosh/swish. A rule of thumb, applied consistently. |
| `sibilance_band` | 4–9 kHz | — | Where the swoosh's friction lives, and the same band as a spoken `s`. Also the band to notch if the swoosh fights dialogue. |
| `whoosh_body_band` | 150–800 Hz | — | Where the whoosh's mass lives. Below 80 Hz belongs to a separate sub layer ([[sfx-bass-drop-under-impact]]), not to the whoosh. |
| `pitch_to_convert` | +4 st (≈1.26×) | +3 to +6 st | Turning a whoosh into a swoosh by pitch alone. Beyond +6 st the envelope starts sounding sped up rather than lighter. |
| `level_swoosh` | 0.178 (≈−15 dB) | −16 to −13 dB | Bright sounds read louder than they measure; sit swooshes at the quiet end of the SFX slot. |
| `level_whoosh` | 0.211 (≈−13.5 dB) | −15 to −12 dB | The standard SFX slot. |
| `swish_per_minute` | 8 | 0–14 | Cheap; captions and UI can carry this. |
| `whoosh_per_minute` | 3 | 0–6 | Expensive; above 6 the video reads as a transition showreel. |
| `layer_split_crossover` | 1.2 kHz | 800 Hz–2 kHz | When layering whoosh + swish, low-pass the whoosh and high-pass the swish about here so they do not both occupy the mids. |

## Reproduction prompt

```
Choose and place an air-movement sound for the motion event at {{EVENT}}
(seconds, composition time).

1. CLASSIFY THE MOVER. Measure the moving element's on-screen area as a
   fraction of the frame, and its travel length in frames ({{MOVE_LEN}}).
   - area < 0.33 frame, or the element is text/icon/UI/a drawn line
     -> SWOOSH family. Search term "swish" first, then "swoosh".
   - area >= 0.33 frame, or it is a camera move, a full-frame transition,
     a title card, or a body -> WHOOSH family.
   - If the picture is not moving at all, place NOTHING and stop.
2. FETCH BY LENGTH BAND, in milliseconds:
   swoosh/swish -> duration 0.8*{{MOVE_MS}} to 1.25*{{MOVE_MS}}, clamped to
   150-500 ms. whoosh -> same ratio, clamped to 400-1200 ms (or 1200-2500 ms
   if the move is over 40 frames). Pull 3 candidates, never 1.
3. VERIFY THE CLASSIFICATION ON THE FILE, not the title. Measure the
   high-band (>3 kHz) minus low-band (<800 Hz) RMS. Swoosh candidates must
   come out at 0 dB or above; whoosh candidates at -10 dB or below. Catalogue
   titles mix the words freely - the measurement is the authority.
4. PLACE by peak, not by file start: data-start = {{EVENT_OR_MIDPOINT}} minus
   the file's peak offset. For a transition the anchor is the cut frame; for
   a travelling element it is the midpoint of the travel.
5. SET GAIN: swoosh 0.178, whoosh 0.211. If the sound lands on or within 3
   frames of a spoken "s", "sh" or "t", either move it into the gap or notch
   4-9 kHz by -3 dB - a swoosh and a sibilant occupy the same band and the
   word loses.
6. IF LAYERING both for a big fast element: low-pass the whoosh at 1.2 kHz,
   high-pass the swish at 1.2 kHz, align both peaks to the same frame, and
   drop the combined pair 2 dB so the stack does not exceed a single hit.
7. ROTATE. If this exact file appears in the last 3 uses of its family, pick
   another or shift pitch by 3 semitones.

ACCEPTANCE TEST: play the shot with eyes closed. You should be able to say
whether the thing that moved was big or small, and be right. If a small
caption sounded heavy, or a full-frame push sounded thin, the family is
wrong - swap family rather than adjusting volume.
```

## Execution spec

**Epidemic Sound — the catalogue's taxonomy is the real answer to this question, and it is not the one the transcript implies.** Probed live 2026-08-28: searching `"swoosh"` returns assets whose titles are `Swooshes, Whoosh, …` and `Swooshes, Swish, …`, carrying tag slugs `swooshes--whoosh` and `swooshes--swish`. In other words **"Swoosh" is the category name for the whole air family, and the bright/light member is tagged `swish`, not `swoosh`.** Searching for the word "swoosh" expecting the bright variant returns a mixture; filtering on `swooshes--swish` returns it directly.

```
# the bright, light, short member - what an editor means by "swoosh"
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["swooshes--swish"]},
                              duration:{min:150,max:500} },
                     sort:{by:POPULARITY,order:DESCENDING}, first:24 }
# the heavy member
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["swooshes--whoosh"]},
                              duration:{min:400,max:1200} }, first:24 }
# cartoon-register light pass (comedy edits)
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["cartoon--swish"]} }, first:24 }
# UI / graphic motion, the other place small-element air lives
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["user-interface--motion"]},
                              duration:{min:150,max:800} }, first:24 }
# term-based fallbacks, in descending reliability
#   "swish stick fast swipe through air"   "swooshes swish short classic noise filter dry"
#   "whoosh designed generic air"          "whoosh short deep reversed dry"
SearchSimilarToSoundEffect { id:<chosen uuid>, first:12 }   # build the rotation set
DownloadSoundEffect { id:<chosen uuid>, options:{ fileType: WAV } }
```
Read `audioFile.durationInMilliseconds` before downloading — it is the length match — and `audioFile.waveformUrl` to see roughly where the peak sits. Descriptors seen in real titles that are worth putting in a term: `Designed`, `Generic`, `Air`, `Dry`, `Reversed`, `Short`, `Deep`, `Bendy`, `Stick`, `Fast`, `Classic`, `Noise`, `Filter`. `Reversed` is how you find the arrival/reveal variant. Always WAV: mp3 pre-echo on a 200 ms transient is exactly the artefact you cannot afford.

**HyperFrames — placement and the band split.** Seconds only; frames are comments.
```html
<!-- caption entrance at 12.40s, swish peaks 0.06s into the file -->
<audio id="sfx-swish-04" src="assets/sfx/motion/swish/motion_swish_bright-short_02.wav"
       data-audio-group="sfx" data-start="12.34" data-duration="0.28"
       data-track-index="22" data-volume="0.178"></audio>

<!-- full-frame push at 12.40s: whoosh for mass, swish for the leading edge -->
<audio id="sfx-whoosh-11" src="assets/sfx/motion/whoosh/motion_whoosh_heavy_01.wav"
       data-audio-group="sfx" data-start="12.06" data-duration="0.62"
       data-track-index="22" data-volume="0.188"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Mass only&quot;,&quot;params&quot;:{&quot;frequency&quot;:1200}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>
<audio id="sfx-swish-05" src="assets/sfx/motion/swish/motion_swish_bright-short_02.wav"
       data-audio-group="sfx" data-start="12.34" data-duration="0.28"
       data-track-index="23" data-volume="0.150"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Edge only&quot;,&quot;params&quot;:{&quot;frequency&quot;:1200}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>
```
Contract points: `highpass`/`lowpass` take `frequency` 20–20000 Hz with `q` (0.707 default) and `poles` (`2` = 12 dB/oct, `1` = 6 dB/oct) — use `poles: 1` when the crossover sounds too surgical. Order is signal order, **limiter last**. Two `<audio>` on the same `data-track-index` that overlap raise the `duplicate_audio_track` warning, hence 22 and 23. Every `<audio>` needs an `id` or it is never mixed and the render is silent. Keep both in `data-audio-group="sfx"`, never `voiceover`.

**Converting a whoosh into a swoosh with ffmpeg** — the honest route, because `data-playback-rate` is *pitch-preserved* and therefore does the opposite of what is wanted:
```bash
# +4 semitones (x1.2599), length preserved
ffmpeg -i whoosh.wav -af "asetrate=48000*1.2599,aresample=48000,atempo=0.7937" swoosh.wav
# or formant-aware if rubberband is compiled in
ffmpeg -i whoosh.wav -af "rubberband=pitch=1.2599" swoosh.wav
```
`atempo` is only valid in 0.5–2.0; chain instances for larger shifts. A cheaper cheat that often reads better than pitching: leave the pitch alone and high-pass the whoosh at 1.5–2 kHz — brightness, not speed, is what makes it read light.

**Remotion:** an `<Audio>` in a `<Sequence>`, same two-file band split. Concept only; no Remotion runtime here.

## Pairs with
[[sfx-whoosh-transition-movement-reveal]] · [[sfx-whip-crack-on-snap-cut]] · [[sfx-whoosh-short-vs-long]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-filter-character-and-distance]] · [[sfx-motion-sound-selection]] · [[sfx-appearance-transient]] · [[sfx-layered-approach-and-impact]] · [[sfx-bass-drop-under-impact]] · [[sfx-library-build-and-taxonomy]] · [[motion-whoosh-bound-entrance-and-traverse]] · [[motion-entrance-vocabulary]] · [[sub-emphasis-caption-three-words]] · [[sfx-unsounded-motion-audit]]

## Failure modes
- **Searching the word "swoosh" and taking what comes back.** The catalogue uses "Swooshes" as the *category*; the bright member is `swish`. You get a relevance mixture and half your "swooshes" are whooshes. Fix: filter on `swooshes--swish`.
- **A heavy whoosh on a caption.** The most common single mismatch in this family, and it makes small text feel like a door closing. Fix: classify by area first, measure the band ratio second.
- **A bright swish on a full-frame transition.** Reads thin and cheap — the frame moved and the sound did not have the mass to match. Fix: whoosh family, or layer.
- **Two mid-range air sounds stacked** to make a big move bigger. Mud. Fix: the 1.2 kHz crossover — low-pass one, high-pass the other.
- **Swoosh landing on a sibilant.** Both live at 4–9 kHz, so the word loses its consonant and the viewer hears a mumble. Fix: shift into a speech gap or notch the effect, never boost it.
- **Counting swishes and whooshes together in the density audit.** Makes a correctly-built caption pass look like overload. Fix: separate per-minute budgets — swish 8, whoosh 3.
- **Using `data-playback-rate` to pitch a whoosh.** It preserves pitch and changes speed, which breaks the length match and does not change the brightness. Fix: bake the shift with ffmpeg, or filter instead.
- **Known gap:** no cited acoustic study defines "whoosh" versus "swoosh" — the terms are library vernacular, not measured categories. Everything above the transcript's own "swoosh = higher-pitched" is (a) the sibilance band, which is real and documented, and (b) the live catalogue taxonomy, which is verifiable. The `band_ratio` thresholds are calibrated against the assets probed on 2026-08-28 and should be re-checked against your own library after ingest.
