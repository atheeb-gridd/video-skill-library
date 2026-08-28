---
id: sfx-riser-hit-pair
title: Build and release — the riser-into-hit compound, and the one-word reveal it stages
skill: sound-design
type: sfx
family: impact
tags: [skill/sound-design, type/sfx, family/impact, sfx/aesthetic, layer/sfx, layer/design, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/editing-kt-3, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:11:36
    quote: "Next up are hits. These release tension and punctuate moments so they feel important. You can use them on their own or put a riser in front of them. It depends on the situation. And again, don't overdo it."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:00:06
    quote: "Music"
research_refs:
  - https://en.wikipedia.org/wiki/Precedence_effect
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Sting_(musical_phrase)
  - https://en.wikipedia.org/wiki/Drop_(music)
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (tag slugs and title grammar probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Build and release — the riser-into-hit compound, and the one-word reveal it stages

## What it is
A riser and a hit are two halves of one gesture: the riser is the promise, the hit is the payment. Used as a compound they are not two effects placed near each other — they are a single sound whose crescendo terminates *on* a transient, so the ear hears one continuous event that resolves rather than two events that happen to be adjacent. The creator's own framing is exactly this: hits "release tension", and "you can use them on their own or put a riser in front of them."

The join is where compounds are won or lost. The riser's loudest frame and the hit's attack must be **coincident**, not merely close. Two identical-family sounds separated by 2–50 ms fall inside the precedence window and fuse into one smeared attack; separated by more than 50 ms they are heard as two distinct events and the release reads as a stutter. There is no useful middle.

This note also owns the sound half of the **single-word topic reveal** — the beat where a hook resolves into one isolated word on screen ("Music"). That is the compound's canonical staging: the riser runs under the setup line, the hit lands on the word's first fully-resolved frame, and the bed is out of the way so the word sits in a hole. The typographic half lives in [[motion-single-word-topic-card]].

## When to use it
- **A build already exists on the picture** — a push-in, a stack assembling, a counter rolling, a caption stack tightening. A compound under a static shot has nothing to release.
- **The payoff is a hard visual event with a definable single frame**: a cut, a title's resolved frame, a full-screen flash, a chart snapping to final value, a number landing. If you cannot name the frame, you cannot build the compound.
- **The moment is one of two-to-five in the whole video.** Both halves are credibility-priced: [[sfx-riser-credibility-budget]] governs the riser, and a hit habituates on the same schedule.
- **Use the hit alone** when the moment is important but not *anticipated* — a smash cut into a demo, a statistic dropped mid-sentence, a punchline. A riser in front of a moment the viewer had no reason to expect reads as manipulation.
- **Use the riser alone** only when the payoff supplies its own transient — a music drop ([[sfx-riser-to-music-drop-backtiming]]), a hard cut with a loud incoming ambience. Otherwise you owe it a hit.
- **Not on a music drop that already has an impact in the arrangement.** You get two sub transients 100 ms apart, which is mud.
- **Not stacked with a record scratch or a hard music stop** on the same frame — those mark importance by subtraction ([[sfx-music-hard-stop]], [[sfx-record-scratch-punctuation]]) and cancel an additive accent.

## How to recognise it in a reference video
- **One monotonic climb terminating in a near-vertical transient**, with **no gap and no dip** between them. Trace per-frame RMS (n=1600 at 48 kHz is exactly one frame at 30 fps):
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
   ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  A compound reads as **≥25 frames of rising RMS (≥6 dB total, no interior drop >2 dB) followed within 0–1 frames by a ≥8 dB single-frame jump.**
- **The riser's maximum and the hit's maximum are the same frame.** If they are 2–3 frames apart (66–100 ms) you are looking at a badly assembled compound, and it is audible as a flam. Log the offset in frames — that number is the finding.
- **Spectral signature at the join:** the riser's energy is concentrated 2–8 kHz and rising; the hit adds 30–120 Hz sub simultaneously. On a spectrogram the compound is a rising bright wedge that suddenly grows a fat low tail.
- **The tail continues under the next shot for 1.5–4 s.** A hit whose decay is cut at the shot boundary is a truncation, not a design choice.
- **The bed drops 4–8 dB across the build and returns at the payoff, or stops entirely.** A flat bed under a compound is the reliable amateur tell — the climb is only perceptible against something not climbing.
- **On the transcript:** the build runs under a setup clause and the transient lands in the **silence after it**, not under a word. If the hit lands on a syllable, the mix is fighting itself.
- **Density check:** 2–5 compounds per 10 minutes is design. More than one per minute and the release stops meaning anything.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `T_PAYOFF` | the event frame | — | The cut frame, or the title's first fully-resolved frame — never the frame its animation starts. |
| Riser body | 3.0 s | 1.0–8.0 s | 1.5 s short-form, 3.0 s standard, 5–8 s only with a visual build of matching length. |
| Join error (riser peak → hit attack) | 0 frames | −1 … 0 frames | Coincident, or riser peak **1 frame early**. Never late. 2–50 ms apart = smeared flam (precedence window); >50 ms = two audible events. |
| Hit transient alignment to picture | 0 frames | −1 … 0 frames | Audio leading picture is detectable from ~45 ms; lagging only from ~125 ms — so err **early**, never late. |
| Hit asset length | 8 s | 3–25 s | Live catalogue: `designed--impact` in the 2–20 s window holds **480** effects; popular cinematic hits measure 7.7 s, 9.3 s, 10.0 s, 11.3 s, 12.6 s. |
| Tail allowed over next shot | 2.0 s | 1.0–4.0 s | Trim with `data-duration` **plus** a fade; a hard boundary truncates the decay audibly. |
| Riser gain | −13 dB rel. dialogue → `data-volume` 0.224 | −15 … −12 dB (0.178–0.251) | Standard SFX tier. |
| Hit gain | −9 dB rel. dialogue → `data-volume` 0.355 | −12 … −6 dB (0.251–0.501) | Hotter than the tier on purpose; it is the accent. |
| Bed duck across the build | −6 dB (lane `v` 0.5) | −8 … −4 dB | Restored at `T_PAYOFF` + 0.1 s, or stop the bed and change track. |
| Sub reinforcement (optional) | one `designed--boom` at −12 dB | −15 … −9 dB | Only if the chosen hit is thin below 120 Hz. Layer at the **same** `data-start`, not offset. |
| Riser low trim | `highpass` 60 Hz | 40–90 Hz | Keeps the riser out of the hit's sub so both survive. |
| Compounds per 10 minutes | 3 | 2–5 | Shared budget with standalone hits and standalone risers. |

## Reproduction prompt
```
Build a riser-into-hit compound resolving at {{T_PAYOFF}} (composition seconds).
30 fps: 1 frame = 0.0333 s. Riser body {{BODY}} (default 3.0; 1.5 short-form).

1. FIX THE FRAME. {{T_PAYOFF}} is the picture cut, or the first frame on which the
   title/word/graphic is fully resolved - NOT the frame its animation starts. If you
   cannot name one frame, stop: this moment does not take a compound.

2. FETCH THE RISER. SearchSoundEffects, filter.tagSlugs ALL ["designed--riser"],
   duration 1500-12000 ms, term "clean" | "reverse cymbal" | "sub", sort POPULARITY
   DESC. READ THE TITLES: one containing "No Impact" or "No Hit" ends dry - take it,
   because you supply the hit. Any other riser may carry its own built-in impact; if
   it does, use it ALONE and skip step 3 or you land two transients on one frame.

3. FETCH THE HIT. tagSlugs ALL ["designed--impact"], duration 5000-25000 ms, term
   "hit big powerful cinematic". Choose on the TAIL, not the attack. Download WAV.

4. MEASURE BOTH PEAK OFFSETS with a per-frame peak trace. Never assume the riser
   peaks at its file end or the hit at its file start. Record RISER_PEAK, HIT_PEAK.

5. PLACE. Two <audio> clips, data-audio-group="sfx", track indices 12 and 13
   (different - overlapping clips on one index raise duplicate_audio_track).
     riser: data-start = {{T_PAYOFF}} - {{BODY}}
            data-media-start = max(0, RISER_PEAK - {{BODY}})
            data-duration = {{BODY}} + 0.15, data-volume = 0.224
     hit:   data-start = {{T_PAYOFF}}, data-media-start = HIT_PEAK
            data-duration = 2.5, data-volume = 0.355
   Verify the identity: riser data-start + {{BODY}} == hit data-start, exactly.

6. SHAPE. Riser volume lane (clip-local): t=0 v=0.25, t={{BODY}}*0.6 v=0.6,
   t={{BODY}} v=1.0, t={{BODY}}+0.15 v=0. Hit lane: t=0 v=1, t=2.1 v=1, t=2.5 v=0.
   Do NOT also GSAP-tween volume on either element.

7. MAKE ROOM. On the bed's volume lane author an explicit v=1 point BEFORE the dip
   (a lane holds its first value backwards), then v=0.5 at riser start + 0.2, hold,
   v=1.0 at {{T_PAYOFF}} + 0.1. If the section turns, stop the bed instead.

8. ACCEPTANCE TEST. (a) Riser peak and hit attack are the SAME frame - a 2-3 frame
   gap is an audible flam; fix by moving the riser, never the hit. (b) Something
   visible happens at {{T_PAYOFF}}; if not, delete both rather than sliding them.
   (c) SFX soloed, the climb is monotonic (no interior dip > 2 dB). (d) The hit's
   last 0.4 s fades rather than stopping.
```

## Execution spec

**Placement spec (the three numbers every SFX note owes).**

| | Offset vs the visual event | Gain rel. dialogue | Ducking |
|---|---|---|---|
| Riser | starts `BODY` before it; **peak on the event frame, 0 to −1 frames** | −13 dB (`data-volume` 0.224) | bed −6 dB across the build |
| Hit | **attack on the event frame, 0 to −1 frames** | −9 dB (`data-volume` 0.355) | bed returns to 0 dB at event +0.1 s |
| Sub layer (optional) | same frame as the hit, 0 offset | −12 dB (0.251) | none |

**Epidemic Sound.** Tag-first, term-second. Free-text SFX search is unreliable in this catalogue — a probe for `"clock ticking"` returned camera shutters and mouse clicks — so anchor every fetch on a verified slug and use `query.term` only to rank inside it.

```json
// riser leg — verified slug designed--riser
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["designed--riser"] },
              "duration": { "min": 1500, "max": 12000 } },
  "query":  { "term": "reverse cymbal crescendo suspense climax" },
  "sort":   { "by": "POPULARITY", "order": "DESCENDING" }, "first": 12 }

// hit leg — verified slug designed--impact (480 effects at 2–20 s)
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["designed--impact"] },
              "duration": { "min": 5000, "max": 25000 } },
  "query":  { "term": "hit big powerful cinematic epic" },
  "sort":   { "by": "POPULARITY", "order": "DESCENDING" }, "first": 8 }

// optional sub layer — verified slug designed--boom
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["designed--boom"] },
              "duration": { "min": 2000, "max": 10000 } },
  "query":  { "term": "deep low drum hit simple" }, "first": 6 }
```

The catalogue's title grammar is load-bearing here and was verified live: `Designed, Riser, Stinger, Reversed, Cymbal, **No Impact**` (4.98 s) and `Designed, Riser, Reversed, Riser, **No Hit**` (13.0 s) are explicitly dry-ending risers; `Designed, Riser, Cymbal, Reverse, Crescendo, Suspense, Climax 03` (3.23 s) is not labelled and may carry its own terminal impact. **Read the title before you pair.** An unrecognised tag slug returns `meta.total: 0` — it fails closed, so zero results means the slug is wrong, not that the library is empty. `duration` filters the delivered file length, not the audible event, so keep the window wide and trim with `data-media-start`. Pull siblings with `SearchSimilarToSoundEffect(id)` so the third compound in a video is not the first one again ([[sfx-repetition-variant-rotation]]). Always `DownloadSoundEffect` with `{"fileType":"WAV"}` — a hit is the worst thing to pitch-shift from a lossy source.

**HyperFrames.** All authored time is seconds; there is no frame attribute, so convert at authoring time. There is also no audio-follows-animation attribute — coupling the compound to a visual event means writing the same number twice, once as the GSAP tween position and once as `data-start`. If the title lives in a sub-composition at scene-local `t`, the root-level audio needs `data-start = t + the slot's data-start`.

```html
<!-- payoff at 11.40 s; 3.0 s build -->
<audio id="sfx-riser-01" src="assets/audio/sfx/riser-no-hit.wav"
       data-audio-group="sfx" data-track-index="12"
       data-start="8.4" data-duration="3.15" data-media-start="0.42"
       data-volume="0.224"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.25},{&quot;t&quot;:1.8,&quot;v&quot;:0.6},{&quot;t&quot;:3,&quot;v&quot;:1},{&quot;t&quot;:3.15,&quot;v&quot;:0}]}]}"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Clear the Sub&quot;,&quot;params&quot;:{&quot;frequency&quot;:60}}]}"></audio>

<audio id="sfx-hit-01" src="assets/audio/sfx/cinematic-hit.wav"
       data-audio-group="sfx" data-track-index="13"
       data-start="11.4" data-duration="2.5" data-media-start="0.08"
       data-volume="0.355"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:2.1,&quot;v&quot;:1},{&quot;t&quot;:2.5,&quot;v&quot;:0}]}]}"></audio>
```

`8.4 + 3.0 = 11.4` — that identity is the compound. Write the JSON attributes **double-quoted with `&quot;`** or `carve.mjs` cannot see them. Give the two clips different `data-track-index` values: they overlap in time and sharing an index raises `duplicate_audio_track`. Every `<audio>` needs an `id` — an id-less one is never mixed and renders silent. Do not pair a `volume` lane with a GSAP `volume` tween on the same element (`audio_volume_double_automation`: the lane wins silently). If you add a `reverb` node to lengthen the tail, the rendered track becomes longer than its `data-duration` via `chainTailSeconds` — expected, not a bug.

**ffmpeg.** Peak measurement on both legs, and a reverse-hit variant when you want the pre-swell without a separate riser:

```bash
# peak offset inside each asset (per-frame at 30fps)
ffmpeg -i hit.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null

# reverse a hit into its own pre-swell: place so the ORIGINAL attack (now the tail
# end) lands on T_PAYOFF, i.e. data-start = T_PAYOFF - (filelen - HIT_PEAK)
ffmpeg -i hit.wav -af areverse hit.rev.wav

# deepen a thin hit (lower pitch = heavier, per the source video's mixing toolkit)
ffmpeg -i hit.wav -af "asetrate=48000*0.9,aresample=48000" hit.deep.wav
```

**Remotion.** Two `<Audio>` elements inside sequences whose `from` frames differ by exactly `bodyFrames`, each with `startFrom` set to its measured peak offset. Portability note only — Remotion is not part of this stack.

## Pairs with
[[sfx-riser-anticipation-build]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-riser-credibility-budget]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-bass-drop-under-impact]] · [[sfx-peak-offset-measurement]] · [[sfx-edge-fades-click-free]] · [[sfx-layer-volume-targets]] · [[sfx-music-hard-stop]] · [[sfx-repetition-variant-rotation]] · [[motion-single-word-topic-card]] · [[motion-anticipation-build-to-reveal]] · [[struct-thesis-line-payoff]] · [[sfx-two-taxonomies-of-sound]]

## Failure modes
- **A flam at the join.** Riser peak and hit attack 2–3 frames apart sit inside the precedence window (2–50 ms) and fuse into one smeared, weak attack; past 50 ms they separate into two events. Both destroy the release. Fix by moving the riser, never the hit — the hit is locked to picture.
- **Doubling a riser that already ends in an impact.** The commonest compound bug. Read the Epidemic title: "No Impact" / "No Hit" means it is safe to pair; anything else needs auditioning first.
- **Aligning file starts instead of measured peaks.** Risers carry 0.3–1.5 s of tail past their peak; hits carry 0.05–0.3 s of pre-roll before theirs. Aligning file edges puts the climax a beat off in both directions at once.
- **Landing the hit late.** Audio lagging picture is detectable past ~125 ms and reads as broken; leading is only detectable from ~45 ms. On the frame or one early.
- **A flat bed underneath.** The climb is perceptible only relative to something that is not climbing. Duck 4–8 dB or stop the bed.
- **Chopping the tail.** A hard `data-duration` with no fade truncates the decay audibly. Always fade the last 0.3–0.4 s ([[sfx-edge-fades-click-free]]).
- **Compounding an unimportant moment.** Both halves are credibility instruments. One unearned compound devalues every later one in the same video.
- **Known gap:** the FX registry has **no pitch node**, so any pitch variation of a riser or hit must be baked with ffmpeg before placement — it cannot be automated in-composition. `compressor` and `limiter` have zero automatable parameters, so a dynamic join cannot be shaped in-comp either; shape it with the `volume` lane or bake it.
