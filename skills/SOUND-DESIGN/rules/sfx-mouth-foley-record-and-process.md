---
id: sfx-mouth-foley-record-and-process
title: Mouth foley — perform the effect into the mic, then process it into one
skill: sound-design
type: sfx
family: foley
tags: [skill/sound-design, type/sfx, family/foley, engine/ffmpeg, engine/hyperframes, engine/epidemic, sfx/motion, layer/sfx, source/sfx-kt-1, source/research, difficulty/high]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:07:27
    quote: "and this is also where you can make your own sound effects. Say I record a whoosh."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:07:33
    quote: "So I made that with my own mouth, and it sounds like this."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:07:36
    quote: "There's a bit of noise in it, so let's [handle that] - we get a little section of noise out of it"
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:08:06
    quote: "First we'll put a change on it - our pitch shifter. Let's drop that on and raise the pitch a little, because our whoosh is a bit heavy, it sounds too heavy"
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:08:36
    quote: "See, it sounds like a proper whoosh now, but the pitch still feels a little off. Let's bring the pitch down a bit more - let's make it 6, zero point six. Listen to the pitch now."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:08:46
    quote: "Now let's put a low-pass filter on it, let's add that."
research_refs:
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://en.wikipedia.org/wiki/Proximity_effect_(audio)
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/EBU_R_128
  - mcp://Epidemic_sounds/SearchSoundEffects (mouth/voice source assets probed live, 2026-08-28)
difficulty: high
detectable_from: audio
---

# Mouth foley — perform the effect into the mic, then process it into one

## What it is
You do not have to source every effect. A whoosh can be performed vocally into a microphone and turned into a usable file — and the source demonstrates the whole chain end to end, on camera: record it, deal with the noise, **pitch-shift it** (up first because the raw take was too heavy, then settling at a value read out as "zero point six"), add **fades so it comes in and ends properly**, then a **low-pass filter**. The presenter's closing line about it is the honest summary: *"Nobody will ever find out. I've done this plenty of times."*

The insight worth extracting is that the raw take is never the effect. A mouth-performed whoosh has three problems by construction: it carries room noise and breath noise, it has **formants** — the resonances that make it identifiably a human mouth — and it has no clean onset or release. Processing does not "improve" it; processing is what removes the three tells. The pitch shift moves the formants out of the vocal range, the low-pass removes the sibilant give-away, and the fades remove the click and the lip smack.

**Style.** Filed `sfx/motion`: the worked example is a whoosh, and the whole processing chain exists to make a performed air move usable over screen movement. The same record-and-process chain is how diegetic substitutes are built, and that use is [[sfx-substitute-material-foley]].

**Where this chain sits in the source.** The improved transcript pass places the whole record-and-process demo *inside* the video's Foley section rather than as a loose appendix — mouth foley is presented as the entry point to making your own effects, alongside the two-ingredient substitution recipe. [[sfx-foley-family]] carries the family framing and the sibling recipe; this note owns the performance and the chain.

## When to use it
- **When the library has nothing at the right length.** Mouth foley's real advantage is that you can perform *exactly* the duration of the motion, which is the parameter hardest to satisfy by search.
- **For air-movement effects specifically** — whoosh, swoosh, swish, wind, a passing-by. The mouth is genuinely good at broadband noise with a shaped envelope and genuinely bad at impacts, mechanisms and anything with a metallic or wooden character.
- **When licensing is a blocker.** A sound you performed is a sound you own outright — the cleanest entry in the clearance table ([[sfx-source-licensing-and-clearance]]).
- **When you need a variant set from nothing.** One performance plus pitch, duration and reverb variation is the source's own escape from the repetition mistake for someone who owns exactly one whoosh.
- **Not for diegetic sounds of real objects.** A mouth-made door is a mouth-made door. Real objects dictate their own sound; if the object exists, record the object or fetch it ([[sfx-substitute-material-foley]] is the technique for objects you cannot record).
- **Not when a search would take two minutes.** This is a 15-minute task with a real failure rate. It earns its place on length-critical or unavailable sounds, not as a default.

## How to recognise it in a reference video
Detecting mouth foley in someone else's video is detecting the tells they failed to remove:
- **Formant peaks.** A human vocal tract leaves resonant bumps in the spectrum, typically a first formant around **300–900 Hz** and a second around **900–2500 Hz**. A library whoosh's noise is smooth; a mouth whoosh that has not been pitched or filtered shows two or three broad humps. Look at a spectrogram rather than a waveform.
- **Sibilant signature.** An unprocessed mouth whoosh carries `sh`/`f` energy at **4–9 kHz** with the same character as the presenter's own consonants. If the effect and the voice share that texture, one made the other.
- **Same-voice correlation.** Compare the effect's noise band to the presenter's breath during pauses. A match is close to proof.
- **Breath tail.** Mouth performances often end with an audible inhale or a lip release 100–300 ms after the effect. A library file does not.
- **Consistent oddness at one length.** Mouth foley is used where lengths are awkward, so the tell is often a whoosh at some unlikely duration (e.g. 380 ms) that fits its motion perfectly.
- **Log it as reproducible, not as a defect.** If a reference uses mouth foley well you will not detect it — which is the point. When you *do* detect it, the finding for the design document is "this creator performs their own air sounds", and the reproduction route is this note rather than a query.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `mic_distance` | 20 cm | 15–30 cm | Closer invites the proximity effect (bass build-up on directional mics) and plosive blasts; further picks up the room. |
| `off_axis_angle` | 35° | 30–45° | Speak *past* the capsule, not into it. The single highest-value technique here: it removes the plosive blast without removing the air. |
| `record_peak` | −12 dBFS | −18 to −9 dBFS | Leave headroom: the pitch shift and the fades change the peak, and you cannot un-clip. |
| `takes` | 6 | 4–12 | Perform a set, not a take. Two long, two medium, two short — then you have a length range and a rotation set from one session. |
| `room_noise_floor` | ≤ −55 dBFS | — | Measure the room before performing. Above −50 dBFS the noise reduction will audibly artefact on a broadband effect. |
| `noise_profile_length` | 0.5 s | 0.3–1.0 s | The clean-room section the source explicitly grabs ("we get a little section of noise out of it"). Record it deliberately at the head of the session. |
| `highpass` | 100 Hz | 80–150 Hz | Removes rumble, handling and the proximity-effect bass. Do this *before* pitching. |
| `pitch_shift` | see note | ×0.6 to ×1.35 | The source's own move: raise first if the take is heavy, then settle. Their stated landing value is **0.6** — a large downward shift (≈ −8.9 semitones) that puts the formants well below the vocal range. Treat ×0.6 as the "heavy whoosh" preset and ×1.25 as the "light swoosh" preset. |
| `lowpass` | 6 kHz | 3–9 kHz | The source's final step. Kills the sibilant tell. Lower for heavy, higher for light — this and pitch are the two knobs that decide the family. |
| `fade_in` | 20 ms | 10–40 ms | Removes the onset click and the lip smack. |
| `fade_out` | 60 ms | 30–150 ms | Removes the breath tail. Longer than the fade-in, always — an air sound decays, it does not stop. |
| `final_peak` | −6 dBTP | −9 to −3 dBTP | The library ingest target, so the new file behaves like every other one-shot ([[sfx-library-build-and-taxonomy]]). |
| `variants_from_one_take` | 4 | 3–8 | Pitch (±3 st), duration (±20%) and reverb (wet 0.1–0.25) applied in combination. |

## Reproduction prompt

```
Create a usable whoosh (or other air-movement effect) from a mouth
performance, for a motion of {{MOVE_LEN}} frames at 30 fps.

RECORD
1. Set the mic 20 cm away and speak PAST it at about 35 degrees off-axis.
   Set gain so peaks land near -12 dBFS. Do not compress while recording.
2. Record 0.5 s of silence first, deliberately, with no movement. This is
   the noise profile and the source video's own first step.
3. Perform 6 takes: two long (about 1.2 s), two medium (about 0.6 s), two
   short (about 0.3 s). Say "whoooosh" with the emphasis on the SH, not on
   the W - the noise is the effect, the vowel is the problem.

PROCESS, in this order - order is the whole technique
4. HIGH-PASS at 100 Hz. Removes handling rumble and proximity-effect bass
   before anything else acts on it.
5. NOISE-REDUCE using the recorded profile. Be conservative: a broadband
   effect and broadband noise reduction are fighting over the same
   frequencies, and over-reduction leaves a watery, gated-sounding whoosh
   that is worse than the noise. If the room floor was above -50 dBFS,
   re-record instead.
6. PITCH-SHIFT. Judge the raw take: if it sounds too heavy, raise it; if it
   sounds like a person, lower it hard. The source's landing value is 0.6
   (about -8.9 semitones) for a heavy whoosh. Use 1.25 for a light swoosh.
   Preserve length while shifting - this is a pitch change, not a speed
   change.
7. LOW-PASS at 6 kHz. This is what removes the "that's a person's mouth"
   tell. Sweep it down until the sibilance stops sounding like a consonant,
   then stop - going further makes it dull rather than heavy.
8. FADE 20 ms in, 60 ms out. Non-negotiable: the source calls this out as
   its own step, and it is what makes the file "come in and end properly".
9. PEAK-NORMALISE to -6 dBTP and save as 48 kHz 24-bit WAV, named
   motion_whoosh_mouth-<descriptor>_NN.wav.

VERIFY
10. A/B against a library whoosh of the same length at the same level. Then
    generate 4 variants from this one file by pitch, duration and reverb.

ACCEPTANCE TEST: play the new file three times in a row with your eyes shut.
If on any pass you hear a person, the low-pass is too high or the pitch shift
is too small - fix those two, in that order. Then place it on the actual
motion: if the effect fits the movement's length without stretching, the
performance was the right length and you have gained the thing a search
cannot give you.
```

## Execution spec

**ffmpeg is the whole processing chain** — this is a raw-media operation that produces a frozen file, and the composition layer has no part in it until placement. The chain in the source's own order:

```bash
# 0. record; then measure the room floor from the deliberate silence
ffmpeg -ss 0 -t 0.5 -i raw.wav -af "astats=metadata=1:reset=0" -f null - 2>&1 | grep RMS_level

# 1. high-pass 100 Hz  ->  2. noise reduce  ->  (one pass, order preserved)
ffmpeg -i raw.wav -af "highpass=f=100:poles=2,afftdn=nr=12:nf=-50:tn=1" step2.wav
#   afftdn: nr = reduction in dB (be conservative, 8-15), nf = noise floor estimate,
#   tn=1 enables noise tracking. arnndn is theoretically stronger BUT ships with no
#   model in this container - `-af arnndn` fails with "Error initializing filters"
#   unless you supply m=<model.rnnn> yourself. Use afftdn here. See contract 7B.7.
#   but needs a model file that may not be present here.

# 3. pitch shift DOWN to 0.6 with length preserved (the source's own value)
ffmpeg -i step2.wav -af "asetrate=48000*0.6,aresample=48000,atempo=1.6667" step3.wav
#   atempo is valid only in 0.5-2.0. 1.6667 is inside it. For a shift needing
#   a tempo factor outside that range, chain two atempo instances.
#   If rubberband is compiled in, it is the better-sounding route and one filter:
ffmpeg -i step2.wav -af "rubberband=pitch=0.6" step3.wav

# 4. low-pass 6 kHz  ->  5. fades  ->  6. peak-normalise, in one pass
ffmpeg -i step3.wav -af "lowpass=f=6000:poles=2,afade=t=in:st=0:d=0.02,afade=t=out:st=0.50:d=0.06,volume=-3dB" \
  -ar 48000 -c:a pcm_s24le motion_whoosh_mouth-heavy_01.wav
#   afade st is the START time of the fade in seconds: set the out-fade's st to
#   (file_duration - 0.06). Measure duration with ffprobe first, do not guess.

# 7. verify the final peak, then ledger it
ffmpeg -i motion_whoosh_mouth-heavy_01.wav -af "astats=measure_overall=Peak_level" -f null -
node <SKILL_DIR>/scripts/resolve.mjs --from motion_whoosh_mouth-heavy_01.wav --type sfx --project .
```
Two warnings from the execution contract that bite here. First, **`asetrate` changes pitch and length together** — the `atempo` (or `rubberband`) is what restores length, and forgetting it produces the classic mistake of a "heavier" whoosh that is also 40% longer and no longer fits the motion. Second, keep scratch files **outside the mounted vault**, which cannot delete files: an eight-step chain generates seven intermediates you do not want to keep forever.

**Why this cannot be done in the composition.** The contract is explicit that the audio layer has **no noise removal** (*"There is no fallback for hiss beneath the words — a source with audible hiss needs a better source, and saying so is the whole answer"*), and **no pitch shift at all**: `data-playback-rate` is 0.1–5 but **pitch-preserved**, which is precisely the opposite of what step 3 needs. `room-gate` closes gaps and leaves noise under the sound untouched. So mouth foley is a `media-use`/ffmpeg job that re-enters the composition as a `src`, and any spec that tries to do it with `data-*` attributes cannot run.

**HyperFrames — placing the finished file.** Identical to any other one-shot; the only difference is that you know its exact length because you performed it.
```html
<audio id="sfx-whoosh-mouth-01" src="assets/sfx/motion/whoosh/motion_whoosh_mouth-heavy_01.wav"
       data-audio-group="sfx" data-start="63.18" data-duration="0.56"
       data-track-index="22" data-volume="0.211"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Put it in the room&quot;,&quot;params&quot;:{&quot;size&quot;:0.45,&quot;wet&quot;:0.15,&quot;dry&quot;:0.9}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>
```
A small amount of `reverb` is worth adding **in the chain rather than baked**, because a home-made file is the one most likely to sound studio-recorded and detached ([[sfx-reverb-glue]]). `reverb` convolves a *generated* impulse, so preview and render produce the same room without shipping an impulse file — but `size` and `damping` are **not automatable** (they regenerate the impulse); only `wet` and `dry` are.

**Epidemic Sound — the honest comparison, and the fallback.** Before spending fifteen minutes, spend thirty seconds checking whether the length band you need exists:
```
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["swooshes--whoosh"]},
                              duration:{min:<0.8*move_ms>,max:<1.25*move_ms>} }, first:24 }
```
If that returns nothing usable, mouth foley is justified. The catalogue also carries *raw material* for this technique, which is a genuinely useful discovery: verified live, `voices--misc` contains assets titled `"Voices, Misc, Mouth, Suck Air, Roof Of Mouth, Noise"` and `"Voices, Misc, Making Sounds With Mouth"`, and `human--misc` carries mouth squelches and breath. Those are performed mouth sounds recorded properly, in a treated room — so if the room floor is too high to perform your own, fetch the raw performance and apply steps 4–9 to it instead of steps 1–9.

**Remotion:** the finished WAV in an `<Audio>` inside a `<Sequence>`. All processing is still ffmpeg. Concept only.

## Pairs with
[[sfx-substitute-material-foley]] · [[sfx-foley-replacement-pass]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-swoosh-vs-whoosh]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-filter-character-and-distance]] · [[sfx-reverb-glue]] · [[sfx-library-build-and-taxonomy]] · [[sfx-source-licensing-and-clearance]] · [[sfx-dialogue-gate]] · [[sfx-diegetic-action-inventory]] · [[sfx-name-before-search]] · [[sfx-foley-family]] · [[sfx-essential-sound-space-presets]]

## Failure modes
- **Recording on-axis.** Plosive blasts and a bass hump from the proximity effect, neither of which a filter fully repairs. Fix: 35° off-axis at 20 cm.
- **No noise profile.** The source's first move is to grab a section of noise; without it, reduction is guesswork. Fix: record 0.5 s of deliberate silence at the head of the session.
- **Over-reducing the noise.** Broadband noise reduction on a broadband effect eats the effect. The result is watery and gated and worse than hiss. Fix: `nr=8..15`, and re-record if the room floor is above −50 dBFS.
- **Pitching with `asetrate` and forgetting `atempo`.** Produces a heavier whoosh that is also 67% longer and no longer matches the motion. Fix: always restore length, or use `rubberband=pitch=`.
- **Trying to pitch with `data-playback-rate`.** It is pitch-*preserved*. It changes speed and does nothing to the formants. Fix: bake the shift with ffmpeg.
- **Skipping the low-pass.** The single tell that survives everything else: 4–9 kHz sibilance that sounds exactly like the presenter's consonants. Fix: sweep the low-pass down until the `sh` stops being a `sh`.
- **No fades.** A click at the head and a breath at the tail. The source names this step for a reason. Fix: 20 ms in, 60 ms out, always asymmetric.
- **One take.** No length range, no rotation set, and the repetition mistake arrives anyway. Fix: six takes across three lengths, then four processed variants.
- **Using it for impacts or mechanisms.** The mouth cannot do metal, wood or mass. Fix: [[sfx-substitute-material-foley]] for those.
- **Known gap:** the source reads its pitch value aloud as "zero point six" without naming the plugin's units, so whether that is a ratio (×0.6 ≈ −8.9 st) or a plugin-specific scale is not recoverable from the transcript. This note treats it as a **ratio**, which is the reading consistent with "a really heavy, weighty whoosh", and gives ×0.6 / ×1.25 as the two presets. Verify by ear against a library whoosh rather than trusting the number.
