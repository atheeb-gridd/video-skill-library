---
id: sfx-pitch-ratio-point-six
title: Pitch 0.6 — the ratio that turns a thin mouth-whoosh into a heavy one
skill: sound-design
type: mix
family: sfx-treatment
tags: [skill/sound-design, type/mix, family/sfx-treatment, sfx/motion, layer/sfx, engine/ffmpeg, engine/hyperframes, engine/epidemic, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:08:36
    quote: "See, it sounds like a proper whoosh now, but the pitch still feels a little off. Let's bring the pitch down a bit more — let's make it 6, zero point six. Listen to the pitch now."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:08:06
    quote: "First we'll put a change on it — our pitch shifter. Let's drop that on and raise the pitch a little, because our whoosh is a bit heavy, it sounds too heavy —"
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:08:46
    quote: "Now let's put a low-pass filter on it, let's add that."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:01:16
    quote: "You can tweak this by changing the pitch. If you push the pitch high, the sound effect will feel a bit lighter, but if you take the pitch low, it'll sound like a really heavy, weighty whoosh."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://breakfastquay.com/rubberband/
  - https://en.wikipedia.org/wiki/Formant
  - https://en.wikipedia.org/wiki/Cent_(music)
difficulty: medium
detectable_from: audio
---

# Pitch 0.6 — the ratio that turns a thin mouth-whoosh into a heavy one

## What it is
`0.6` is not six semitones and it is not sixty percent of anything musical — it is a **pitch scale factor**, the ratio between the output frequency and the input frequency. Every ratio-style pitch control in audio uses the same convention: ffmpeg's `rubberband` filter exposes `pitch` as a scale factor from 0.01 to 100 with a default of 1, and 0.6 there produces exactly what the source demonstrates in his NLE. The conversion is `semitones = 12 × log₂(ratio)`, so **0.6 is −8.84 semitones**, a little more than a major sixth down.

The context matters as much as the number. The sound being treated is a whoosh performed with the mouth, and the diagnosis is *"it's sounding a bit weak"*. Pitching down does two jobs at once: it adds weight and mass, and it drags the vocal formants down with it, which is what stops the effect sounding like a person going "whooo". The low-pass that follows removes the sibilant top that would otherwise still give the source away.

**Style.** Filed `sfx/motion`, because the sound being treated is a whoosh and the ratio exists to give a movement mass. The same control used to add weight to a hit or a braam is the aesthetic case, and it is [[sfx-pitch-shift-weight-energy]].

## When to use it
- **On a self-recorded mouth or breath effect that reads as thin or as obviously human.** The canonical case, and the one the source demonstrates ([[sfx-mouth-foley-record-and-process]]).
- **On any library effect that is right in shape but wrong in mass** — a whoosh that should feel like a truck rather than a hand, a hit that should feel like a door rather than a book.
- **To make variants of a single file** so a repeated action does not reuse one asset. The source names pitch alongside reverb and duration as the three variation knobs ([[sfx-riser-credibility-budget]], [[sfx-density-fatigue-audit]]).
- **Downward for weight and gravity; upward for lightness and speed** — the general direction rule lives in [[sfx-pitch-shift-weight-energy]]. This note is the concrete numbers and the mechanism.
- **Not on dialogue.** Any ratio shift on a voice you intend to be heard as a voice needs formant preservation and belongs in a different conversation.
- **Not below about 0.5** without cleanup: artefacts and rumble start dominating, and the effect stops reading as the thing it was.
- **Not as a fix for the wrong effect.** If a swish is wrong because it should have been a whip, pitching it will not make it a whip ([[sfx-whip-crack-on-snap-cut]]).

## How to recognise it in a reference video
- **A whoosh with a spectral centroid well below its family.** Library whooshes centre their energy in the 1.5–6 kHz region; a pitched-down one sits noticeably lower, with audible content under 300 Hz that a mouth recording could not have produced natively.
- **Length is the tell for which mechanism was used.** A pitch-only shift (rubberband) leaves duration unchanged. A varispeed shift — playing the file slower — lowers pitch *and* lengthens it by `1/ratio`, so 0.6 makes the file **1.667× longer**. If the effect is both deeper and longer than its family's norm by roughly that factor, it was varispeed.
- **Formant smear.** A voice pitched down with formants shifted has a hollow, "big" quality with no intelligible vowel; a voice pitched down with formants preserved still sounds like a person. If you can almost hear a word, formants were preserved and the disguise failed.
- **A hard shelf in the top end.** A low-pass applied after the shift shows as a steep roll-off, typically somewhere between 6 and 9 kHz — measurable, and a strong signature of the DIY chain.
- **Reference ratios to compare against**, for reading a shift off a spectrum:

  | Ratio | Semitones | Reads as |
  |---|---|---|
  | 0.5 | −12.00 | An octave down; heavy, often too heavy for a whoosh |
  | 0.6 | −8.84 | The source's value: weighty, clearly non-human |
  | 0.7 | −6.18 | Substantial but still recognisable as the original |
  | 0.8 | −3.86 | A nudge; adds body without changing identity |
  | 0.9 | −1.82 | Variation only |
  | 1.15 | +2.42 | Lighter, quicker |
  | 1.25 | +3.86 | Distinctly light; the "small object" register |
  | 1.5 | +7.02 | Comedic / miniature |

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `pitch` ratio (mouth whoosh) | 0.6 | 0.55–0.75 | The source's value. Below 0.5 the artefacts win. |
| `pitch` ratio (weight nudge on a library effect) | 0.85 | 0.8–0.95 | Adds mass without changing the effect's identity. |
| `pitch` ratio (variation set) | 0.85 / 1.0 / 1.15 | — | Three files from one, ±~2.5 semitones apart, audibly different but same family. |
| `formant` | `shifted` (default) | shifted / preserved | **Shifted is what disguises a human source.** Preserved keeps it sounding like a person — the wrong choice here. |
| `transients` | `crisp` (default) | crisp / mixed / smooth | Keep `crisp` for whooshes and hits; `smooth` for sustained textures. |
| Post low-pass | 7500 Hz | 6000–9000 Hz | Removes the sibilance that gives away a mouth source. |
| Post high-pass | 50 Hz | 40–60 Hz | Only after a shift below ~0.6, to clear the rumble the shift created. |
| Varispeed length factor | `1 / ratio` | — | 0.6 → 1.667× longer. Use `atempo` to correct if length must be preserved. |
| Fade handles | 0.02 s in / 0.05 s out | 10–80 ms | The source adds fades before judging the pitch; a clicky edit reads as "wrong pitch" when it is actually a wrong edit. |

## Reproduction prompt
```
Give a thin or obviously-human effect weight by pitching it down, and prove the
number rather than guessing it.

INPUT: {{SRC}} the effect file; {{RATIO}} default 0.6 (a pitch SCALE FACTOR, not
semitones: semitones = 12 * log2(ratio), so 0.6 = -8.84 st).

1. CLEAN AND TOP-AND-TAIL FIRST. Trim silence, add a 0.02 s fade in and a 0.05 s
   fade out. A clicky head or tail is heard as a pitch problem and will send you
   chasing the wrong knob.
2. DECIDE THE MECHANISM.
   - Pitch only, length unchanged (default, and what the source is doing):
       ffmpeg -i {{SRC}} -af "rubberband=pitch={{RATIO}}:formant=shifted:transients=crisp" out.wav
   - Varispeed, pitch AND length (use when the effect should also get slower):
       ffmpeg -i {{SRC}} -af "asetrate=48000*{{RATIO}},aresample=48000" out.wav
     Length becomes 1/{{RATIO}} times the original - 0.6 makes it 1.667x longer.
     Add ",atempo=1/{{RATIO}}" only if you want the original length back.
   Keep formant=shifted. Preserving formants keeps it sounding like a person,
   which is the opposite of what a DIY whoosh needs.
3. CLEAN UP AFTER THE SHIFT.
       ffmpeg -i out.wav -af "highpass=f=50,lowpass=f=7500" out_clean.wav
   The low pass is the step the source performs last and it is what removes the
   sibilance that identifies a mouth source.
4. AUDITION AT THE RIGHT LEVEL, against the picture, at the SFX band (-12 to -15
   dB relative to dialogue). A pitched effect judged in solo at full level always
   sounds better than it will in the mix.
5. IF IT IS STILL WEAK, do not push the ratio lower. Layer a low element under it
   instead - a sub or boom under the whoosh - which adds weight without artefacts.
6. MAKE THE VARIANT SET while you are here: 0.85, 1.0 and 1.15 of the cleaned file,
   named <base>_lo/_mid/_hi, so a repeated action never reuses one asset.
7. ACCEPTANCE TEST: (a) no word or vowel is identifiable in the result; (b) no
   click at either end; (c) at -15 dB under dialogue it still reads as one event,
   not as rumble; (d) if you used varispeed, the new duration is within 2 frames
   of the visual event you are covering, or you corrected it with atempo.
```

## Execution spec

**ffmpeg — this is where the work happens.** Verified locally against the installed build: `rubberband` exposes `pitch` as a double scale factor from 0.01 to 100 (default 1), `tempo` likewise, plus `transients` (crisp/mixed/smooth), `detector`, `formant` (shifted/preserved), `pitchq` (speed/quality/consistency) and `window`. `asetrate` changes the sample rate without touching the data, which is varispeed — pitch and length together — and needs an `aresample` back to the working rate.
```bash
# pitch only, length preserved — the source's move
ffmpeg -i whoosh_raw.wav -af "rubberband=pitch=0.6:formant=shifted:pitchq=quality" whoosh_06.wav
# varispeed — deeper AND longer by 1/0.6
ffmpeg -i whoosh_raw.wav -af "asetrate=48000*0.6,aresample=48000" whoosh_vari.wav
# finish
ffmpeg -i whoosh_06.wav -af "highpass=f=50,lowpass=f=7500,afade=t=in:d=0.02,areverse,afade=t=in:d=0.05,areverse" whoosh_final.wav
```

**Hyperframes — the important negative.** There is **no pitch effect in the audio FX registry at all**: the available node types are filters (`highpass`, `lowpass`, `peaking`, `lowshelf`, `highshelf`), dynamics (`gain`, `compressor`, `limiter`, `gate`), nonlinear (`saturate`, `bitcrush`) and time (`delay`, `reverb`, `chorus`, `phaser`). And `data-playback-rate`, which is the only rate control on a clip, is normalised to 0.1–5 and is explicitly **pitch-preserved** — it will change the length and leave the pitch alone, the exact opposite of what is wanted here. **Therefore every pitch shift in this stack must be baked into a file with ffmpeg before placement.** What the composition *can* do afterwards is the filtering:
```html
<audio id="sfx-whoosh-heavy" src="assets/sfx/whoosh_final.wav"
       data-audio-group="sfx" data-start="6.4" data-duration="0.72"
       data-track-index="12" data-volume="0.5"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Clear Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:50}},{&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Kill Sibilance&quot;,&quot;params&quot;:{&quot;frequency&quot;:7500}}]}"></audio>
```
Chain order is signal order and out-of-range params are clamped on read, so the chain above is safe to realise as written. Nothing validates the chain, so a typo costs the effect silently.

**Epidemic Sound.** Often the cheaper answer than treating a thin file: fetch a heavier one. `swooshes--whoosh` holds 975 effects, and their titles carry the weight vocabulary directly — `Deep Reversed`, `Wide`, `Dry`, `Classic`, `Air`, `Warp`.
```json
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["swooshes--whoosh"] } },
  "query": { "term": "deep low" },
  "sort": { "by": "POPULARITY", "order": "DESCENDING" }, "first": 12 }
```
Note the measured trap: only **14 of those 975** files fall inside a 200–1200 ms `duration` window, because the filter measures the *delivered file*, which usually carries silence and tail around a much shorter audible event. Leave the duration window wide and trim with `data-media-start` / `data-duration`.

**Remotion.** No pitch control on `<Audio>` either; the same conclusion holds — bake it. Portability note only.

## Pairs with
[[sfx-pitch-shift-weight-energy]] · [[sfx-mouth-foley-record-and-process]] · [[sfx-substitute-material-foley]] · [[sfx-filter-character-and-distance]] · [[sfx-reverb-glue]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-swoosh-vs-whoosh]] · [[sfx-bass-drop-under-impact]] · [[sfx-density-fatigue-audit]] · [[sfx-library-quality-gate]]

## Failure modes
- **Reading 0.6 as semitones.** Six semitones down is a ratio of 0.707 and sounds materially lighter than what the source demonstrates. The number is a ratio: 0.6 = −8.84 st.
- **Using `data-playback-rate` to do it.** It is pitch-preserved, so you get a longer effect at the same pitch — the length changes and the problem does not.
- **Preserving formants on a mouth source.** Keeps the human quality you were trying to hide. Use `formant=shifted`.
- **Pitching down past 0.5 to chase weight.** Artefacts, rumble, and a loss of the transient that made the effect readable. Layer a sub under it instead.
- **Skipping the low-pass.** Sibilance survives a pitch shift and is the single most identifiable trace of a mouth recording.
- **Judging pitch on a clicky file.** An unfaded head reads as a pitch error. Fade first, then decide.
- **Forgetting the length change on varispeed.** At 0.6 the file is two-thirds longer; a whoosh that was cut to a 12-frame transition is now 20 frames and overshoots the cut.
- **Known gap:** no pitch node and no pitch automation exist in this stack, so pitch cannot be varied over time inside a composition. Anything that needs a moving pitch must be rendered as a derived asset first.
