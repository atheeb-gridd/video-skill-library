---
id: sfx-synthetic-family-catalogue
title: Layer 4 — the catalogue of sounds that do not exist, and what each one is for
skill: sound-design
type: sfx
family: synthetic-sfx
tags: [skill/sound-design, type/sfx, family/synthetic-sfx, sfx/aesthetic, layer/sfx, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:02:17"
    quote: "So we basically use sound effects to enhance the visuals. Sounds that don't even exist in the real world, but they help a lot in intensifying a scene."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:02:25"
    quote: "Risers, impacts, hits, whooshes."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:02:06"
    quote: "Use a riser before a jumpscare, before a big reveal, or before a drop in the music."
research_refs:
  - https://www.epidemicsound.com/sound-effects/
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://en.wikipedia.org/wiki/Transient_(acoustics)
  - https://en.wikipedia.org/wiki/Envelope_(music)
difficulty: medium
detectable_from: audio
---

# Layer 4 — the catalogue of sounds that do not exist, and what each one is for

## What it is
The source defines Layer 4 by a negative: these are sounds with **no real-world referent**. Nothing in the world makes the noise a riser makes. Their job is not realism, it is **amplification** — taking what the picture is already doing and making it land harder. [[sfx-layered-approach-and-impact]] covers how the five layers stack; this note is the **palette**: nine synthetic families, what each actually sounds like in measurable terms, how long they really are, what motion each belongs on, and the exact search that fetches one.

The reason to write the families down rather than searching by vibe is that the two named sound-design mistakes are both catalogue failures: *sound-effect overload* (reaching for a family that does not fit and adding a third one to compensate) and *the same sound effect repeated again and again* (not knowing the neighbouring family exists). A named palette fixes both.

**Style.** Filed `sfx/aesthetic` — Layer 4 is defined by having no real-world referent. Several of the nine families are routinely *placed* on a movement (a whoosh under a transition, an impact on a slam); that placement is a motion job and is governed by [[sfx-motion-sound-selection]] and [[sfx-peak-on-the-cut]].

## When to use it
- **At the sound pass**, once the motion spec exists, as the lookup that turns "this needs a sound" into "this needs a 0.6 s swish pitched down two semitones".
- **When a chosen effect is nearly right.** Nine times out of ten the fix is a neighbouring family, not a different file inside the same one — a boom where a braam was used, a swish where a whoosh was used.
- **When the same effect has been used three times** and the video is starting to sound like a template.
- **When budgeting.** The families divide cleanly into *event* sounds (impact, braam, click) and *duration* sounds (riser, texture, whoosh), and a beat can carry at most one of each without turning to mud.
- **Not** for anything that exists in the world. A door, a phone, a keyboard, a footstep wants its real sound; the synthetic licence does not apply and a synthetic substitute is the "water sound under a page turn" failure ([[sfx-diegetic-action-inventory]]).

## How to recognise it in a reference video
- **Length of the audible body decides half of it.** Under ~150 ms with no tail → click family. 300 ms–1.5 s with a moving centroid → whoosh/swish. Over 1.5 s with a rising envelope → riser. Over 1.5 s with a *falling* envelope after a hard front → impact family.
- **Where the loudest moment sits.** At the very start → impact/boom/braam. In the middle → whoosh/swish. **At the very end** → riser or reverse.
- **Is it pitched?** Hum along with it. If you can, it is a braam or a tonal swish, and it can clash with the music's key; if you cannot, it is a boom or a whoosh and it cannot.
- **Where is the energy?** A spectrum with everything under 120 Hz is a sub drop and will vanish on a laptop. Everything over 2 kHz is a click. A broad even spread is a whoosh.
- **What follows it.** A riser is identified as much by its payoff as by its shape: find the frame it resolves on. If nothing happens there, the reference is misusing the family and you should log that as a negative, not copy it.
- **Repetition audit.** Count distinct files across the video. The named mistake is *"the same sound effect repeated again and again"*; a reference using one whoosh sixty times is a template, and the fix is three variations of one file, not sixty files.
- **Density.** A tick every other second in every other frame tires the viewer's brain within 2–3 minutes. Count events per minute and log it ([[sfx-density-fatigue-audit]]).

## Parameters

**The nine families** — durations are the actual distribution in the Epidemic Sound catalogue, sampled through the search API, not estimates. Note how much longer most of these are than the moment they are used for: almost every one is trimmed heavily in place with `data-media-start` + `data-duration`.

| Family | Acoustic signature | Catalogue duration | Trimmed use | Belongs on | Epidemic tag |
|---|---|---|---|---|---|
| **Riser** | Monotonically ascending loudness and/or pitch; broadband filtered noise, often a reversed impact underneath; resolves into silence or a hit. Momentary loudness rises without a plateau. | **5.4–15.5 s** | 0.8–3.0 s | Anticipation before a reveal, a card, a drop, a jumpscare. **Only when something important actually follows** — a riser to nothing spends its credibility for the rest of the video. | `designed--riser` |
| **Impact / boom** | Transient attack under ~10 ms, LF-dominant (40–120 Hz), then 0.5–3 s of reverb tail. Perceived "size" is the tail length and how low the fundamental sits, not the peak level. | **2.8–11.2 s** | 0.6–2.5 s | The frame a thing lands, a card slams, a cut punctuates. One per beat, never two. | `designed--boom` |
| **Braam** | A *pitched* brass-like cluster with a bend, 1–3 s of sustained body before the tail. Melodic where a boom is percussive; it has a note, and that note can clash with the music. | **4.4–8.5 s** | 1.0–3.0 s | Title cards, the video's single biggest reveal, trailer-register beats. Cinematic and expensive-sounding; unmistakable and therefore easy to over-use. | `designed--braam` |
| **Bass dive / sub drop** | A downward pitch glide through roughly 100 → 30 Hz over 0.5–3 s with almost no mid content. Catalogue entries are often labelled by their landing frequency (45, 50, 55, 70 Hz). | **3.6–21.3 s** | 1.0–3.0 s | Under a cut into a new section, under a fall or a collapse, under a hard scale change. **Inaudible on phone speakers** — always pair with a mid-range partner. | `designed--bass-dive` |
| **Whoosh** | Broadband filtered noise whose spectral centroid sweeps; loudest moment usually **not** at the file head. The generic air-movement effect. | **0.39–1.2 s** | 0.3–1.0 s | Titles animating on, objects crossing frame, fast transitions, dynamic reveals. The workhorse. | `swooshes--whoosh` |
| **Swish** | A brighter, faster, more tonal whoosh with a clear fly-by contour (rise then fall). | **0.39–1.2 s** | 0.3–0.8 s | Traverses, whip pans, fast small movements. Where a whoosh is air, a swish is an object passing. | `swooshes--swish` |
| **Reverse / pre-transient** | Any impact played backwards: a crescendo that terminates abruptly at its loudest sample. Silence-then-nothing after. | derived | 0.3–1.0 s | A miniature riser for a small beat. Its abrupt end **is** the cut point — align the file's last sample to the frame, not its first. | build with `areverse` |
| **Texture / drone** | Sustained, no transient, slowly evolving spectrum; sits under everything without an event of its own. | 5–60 s | 3–30 s | Underlying tension across a whole section; the "tones" that create mystery and intrigue for darker moods. | `designed--riser` (long, non-resolving) or a music bed |
| **UI click / pop / tick** | 20–120 ms, HF-dominant (2–8 kHz), essentially no tail. | **0.18–0.66 s** | 0.05–0.3 s | Counters, steps, list items, checkmarks, cursor actions, typing. The only family safe to repeat many times in a row — and even then, vary the pitch. | `user-interface--click` |

**Placement and mix knobs.**

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `level` | −13 dB | −12 … −15 dB | Against dialogue at 0 to −3 dB and music at −20 to −25 dB. |
| `families_per_event` | 1 | 1–2 | At most one *duration* sound plus one *event* sound (a whoosh into an impact). Three is mud. |
| `riser_resolution` | on the payoff frame | ±1 f | The riser's last sample lands on the impact frame. AV-sync detectability is about +45 ms early / −125 ms late. |
| `riser_budget` | ≤2 per video | 0–3 | A riser before something ordinary devalues every later riser. |
| `impact_alignment` | file **peak** on the frame | ±1 f | Not the file head — impacts carry 20–120 ms of pre-transient. |
| `sub_partner` | required | — | Any bass-dive must be layered with a mid-range effect or it is silent on phones. |
| `braam_key_check` | required | — | A braam is pitched; audition it against the music bed before committing. |
| `reverb` | 8–15% small room | 0–25% | So effects stop sounding studio-recorded and start existing in the frame. |
| `variation_knobs` | pitch, duration, reverb | — | The source's own three: one file becomes many. Vary before you fetch another file. |
| `pitch_by_size` | ±1–3 semitones | ±1–7 | Down for large elements (heavier, more cinematic), up for small (lighter, faster). |
| `repeat_pitch_step` | +1 semitone, −2 dB | — | When a family genuinely repeats (list ticks, counters), step pitch up and level down per item. |

## Reproduction prompt

```
Choose and place the Layer-4 effect for the event {{EVENT}} at {{T}}.

1. GATE. Does this thing exist in the real world? If yes, stop - it needs a
   diegetic sound, not a synthetic one. Layer 4 covers invented motion and
   emphasis only.

2. CLASSIFY THE EVENT and pick the family:
     something ANTICIPATES        -> riser        (0.8-3.0s, resolves ON {{T}})
     something LANDS or PUNCTUATES-> impact/boom  (peak ON {{T}})
     the BIGGEST reveal in the video, cinematic register -> braam
     a FALL, collapse or hard section change -> bass dive + a mid partner
     something TRAVELS a short way and stops -> whoosh
     something CROSSES the frame  -> swish
     a SMALL discrete step, tick, item, counter -> ui click
     a whole SECTION needs underlying tension -> texture/drone
   Pick exactly ONE. Optionally add ONE of a different kind (a whoosh into an
   impact is the only pairing that is always safe).

3. FETCH with the tag namespace, not free text alone:
     SearchSoundEffects { query: { term: "<descriptive terms>" },
       filter: { tagSlugs: { matchType: "ANY", values: ["<slug>"] },
                 duration: { min: <ms>, max: <ms> } } }
   Slugs: designed--riser, designed--boom, designed--braam,
          designed--bass-dive, swooshes--whoosh, swooshes--swish,
          user-interface--click.

4. TRIM IN PLACE, never cut a file. Catalogue entries are much longer than the
   moment you need: risers run 5-15s, braams 4-9s, booms 3-11s. Use
   data-media-start and data-duration.

5. ALIGN BY THE RIGHT EDGE OF THE ENVELOPE:
     riser / reverse -> its LAST sample on {{T}}
     impact / braam  -> its LOUDEST sample on {{T}}
     whoosh / swish  -> its loudest sample on the motion's velocity peak
     click           -> its onset on {{T}}
   Measure, do not assume:
     ffmpeg -i f.wav -af ebur128=metadata=1,ametadata=print:key=lavfi.r128.M \
       -f null - 2>&1 | grep -B1 pts_time

6. LEVEL -13 dB. Own audio group "sfx", never the voiceover group.

7. BEFORE FETCHING A SECOND FILE, try the three variation knobs on the one you
   have: pitch (asetrate + atempo, or the FX chain), duration (data-duration /
   data-playback-rate, which is pitch-preserved), reverb (fx chain, 8-15%).
   A video should contain a handful of files in many variations, not many
   files.

ACCEPTANCE TEST:
(1) Name the family out loud and say what it is amplifying. If you cannot name
what it amplifies, delete it.
(2) A riser must have a payoff frame you can point at.
(3) Play the section on a phone speaker: if the effect disappears entirely, it
is sub-only and needs a mid-range partner.
(4) A braam must not clash with the music bed's key.
(5) Count synthetic events in the section. More than one every ~4 seconds over
a sustained stretch is overload - cut the weakest.
```

## Execution spec

**HyperFrames.** Every one of these is an `<audio>` clip; the family only changes the alignment arithmetic and the trim.

```html
<!-- riser resolving on the card at 6.38, and the impact on the same frame -->
<audio id="sfx-riser" src="assets/sfx/riser.wav" data-audio-group="sfx"
       data-start="5.18" data-duration="1.20" data-media-start="6.40"
       data-track-index="13" data-volume="0.30"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.5},{&quot;t&quot;:1.2,&quot;v&quot;:1}]}]}"></audio>
<audio id="sfx-impact" src="assets/sfx/boom.wav" data-audio-group="sfx"
       data-start="6.30" data-duration="2.40" data-media-start="0.08"
       data-track-index="12" data-volume="0.45"></audio>
```

Contract points that bind this:
- **`data-media-start` on a riser is deep into the file** precisely so that `data-start + data-duration` coincides with the riser's own climax. This is the one family where you author from the *end*.
- **Escaping is load-bearing.** Write `data-automation` / `data-fx-chain` / `data-fx-carve` double-quoted with the JSON's own quotes as `&quot;`. `scripts/carve.mjs` finds them with a `name="..."` regex, so a single-quoted attribute is invisible to it and the carve silently overwrites work it could not see.
- **An automation lane's `t` is clip-local seconds**, and **a lane holds its first value backwards to the clip start and its last value forward to the end** — so a riser envelope needs an explicit point at `t: 0`.
- **512 points per lane maximum**, a lane on a missing node is pruned silently on read, and a lane on a non-automatable parameter is silently inert.
- **Every `<audio>` needs an `id`** or it is never mixed — silent render, no error.
- **SFX get their own group.** A bed or an SFX clip inside the `voiceover` carve group poisons the next re-analysis silently, and `data-fx-carve` is clip-only (never on an `<hf-audio-group>`).
- **`duplicate_audio_track`** warns when two `<audio>` share a track index *and* overlap in time — put the riser and the impact on different indices, as above.
- **Do not both tween and automate `volume`** (`audio_volume_double_automation` — the lane wins), and remember a `volume` tween is absolute and replaces `data-volume` (`audio_volume_tween_overrides_gain`).
- **The variation knobs, in the FX chain.** The source's three are pitch, duration and reverb. In this stack: **duration** is `data-playback-rate` (a constant in `0.1..5`, **pitch-preserved** — so it is the opposite of a tape speed change, and there is **no rate envelope**); **reverb** is an FX node (`size` 0.05–1 default 0.7, `damping` 0–1, `wet` 0–1 default 0.35 **AUTO**, `dry` **AUTO**) convolving a *generated* impulse, so preview and render produce the same room without shipping a file; **pitch is not an FX node at all** and must be preprocessed with ffmpeg.
- **High-pass / low-pass are the fourth and fifth knobs** the source's mixing toolkit names: `highpass` (`frequency` 20–20000 Hz, default 300, **AUTO**) makes an effect sharp and airy; `lowpass` (default 8000, **AUTO**) makes it muffled and heavy. Both are automatable, unlike `compressor`/`limiter`/`gate`/`bitcrush`, whose parameters cannot be automated at all — automate a `gain` stage around those instead.
- **Chain order doctrine:** *"Subtract before you add, level after you filter, relationships after level, character and ceiling last."* Limiter last.
- **`chainTailSeconds`:** an effect with a tail (reverb, delay) makes the rendered track **longer** than its source, so a treated impact no longer ends exactly at its `data-duration`. That is expected.
- **Nothing validates an FX chain.** Lint reads `data-automation` for exactly two conflicts and checks two carve-arrangement rules. Render refuses an unparseable chain outright; preview plays it **dry**. So a chain that "works in preview" may be silently doing nothing.

**Epidemic Sound.** The seven verified searches:

```
riser      SearchSoundEffects { query:{term:"riser build tension cinematic"},      filter:{ tagSlugs:{matchType:"ANY",values:["designed--riser"]},     duration:{min:3000,max:12000} } }
impact     SearchSoundEffects { query:{term:"cinematic impact hit boom deep"},     filter:{ tagSlugs:{matchType:"ANY",values:["designed--boom"]},      duration:{max:8000} } }
braam      SearchSoundEffects { query:{term:"braam brass orchestral impact epic"}, filter:{ tagSlugs:{matchType:"ANY",values:["designed--braam"]},     duration:{max:9000} } }
sub drop   SearchSoundEffects { query:{term:"bass drop deep sub low end"},         filter:{ tagSlugs:{matchType:"ANY",values:["designed--bass-dive"]}, duration:{max:6000} } }
whoosh     SearchSoundEffects { query:{term:"whoosh air designed generic"},        filter:{ tagSlugs:{matchType:"ANY",values:["swooshes--whoosh"]},    duration:{max:1200} } }
swish      SearchSoundEffects { query:{term:"swish flyby short bright"},           filter:{ tagSlugs:{matchType:"ANY",values:["swooshes--swish"]},     duration:{max:1500} } }
click      SearchSoundEffects { query:{term:"ui click button select"},             filter:{ tagSlugs:{matchType:"ANY",values:["user-interface--click"]},duration:{max:600} } }
```
`SearchSimilarToSoundEffect` on a hit with the right envelope but the wrong colour beats re-querying. `DownloadSoundEffect` writes a local file into `.media/audio/sfx/` or `assets/sfx/` and **stops there** — placement, gain and timing are pure HyperFrames after that.

**ffmpeg — building families you cannot find.**

```bash
# a reverse/pre-transient from any impact
ffmpeg -i boom.wav -af "areverse" pre-transient.wav
# pitch WITHOUT changing length (-3 semitones = ratio 0.841)
ffmpeg -i braam.wav -af "asetrate=48000*0.841,aresample=48000,atempo=1.189" braam.dn3.wav
# a mid-range partner for a sub drop: band-limit a whoosh into 400-4000 Hz
ffmpeg -i whoosh.wav -af "highpass=f=400,lowpass=f=4000" whoosh.mid.wav
# find the loudest moment, for alignment
ffmpeg -i f.wav -af ebur128=metadata=1,ametadata=print:key=lavfi.r128.M -f null - 2>&1 | grep -B1 pts_time
```

## Pairs with
[[sfx-layered-approach-and-impact]] · [[sfx-riser-anticipation-build]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-whoosh-transition-movement-reveal]] · [[motion-whoosh-bound-entrance-and-traverse]] · [[sfx-envelope-matched-to-easing-curve]] · [[sfx-search-vocabulary]] · [[sfx-density-fatigue-audit]] · [[sfx-sound-pass-order]] · [[sfx-diegetic-action-inventory]] · [[motion-single-word-topic-card]] · [[sfx-camera-move-air-accent]] · [[sfx-cartoon-comedy-family]] · [[motion-attention-transient]]

## Failure modes
- **Riser with no payoff.** The most damaging misuse, because it is cumulative: once a riser has preceded something ordinary, the viewer stops responding to risers for the rest of the video. Correction: one or two per video, each resolving on a beat you can name.
- **Two impacts on one frame.** Layering a boom and a braam on the same moment produces a smeared low-end blob, not a bigger hit. Correction: one event sound per beat; layer only across kinds (duration + event).
- **Sub-only drop.** It sounds enormous on monitors and is completely absent on a phone, which is where most of the audience is. Correction: always pair with a mid-range partner, and audition on a phone speaker.
- **Braam clashing with the music.** A braam has a note. Against a bed in a different key it sounds broken rather than epic. Correction: audition against the bed; pitch-shift the braam if needed.
- **File head aligned instead of file peak.** Impacts have pre-transient. Aligning `data-start` to the frame puts the hit late. Correction: measure with `ebur128` and offset with `data-media-start`.
- **Sixty copies of one file.** The named mistake. Correction: three to five files, many variations — pitch, duration, reverb, high-pass, low-pass.
- **Overload.** A tick every other second every other frame; the viewer's brain tires within two or three minutes and they either stop attending or start attending to the effects instead of the video. Correction: the sound-pass budget, and a density audit.
- **Missing the other four layers.** A video full of Layer 4 with no ambience underneath still feels fake — *"even in movies they use the sounds of that real location so you feel like you're actually there."* Correction: Layer 4 amplifies; it does not substitute for Layers 2 and 3.
- **Known gap:** there is **no de-esser, no noise removal and no tone matching** in this stack, and `compressor`/`limiter`/`gate`/`bitcrush` have zero automatable parameters. There is also **no pitch node** — every pitch variation is an ffmpeg preprocess producing a new file, which means pitch variations must be planned as assets rather than dialled in at mix time.
