---
id: sfx-ab-audition-candidates
title: Hold the picture, swap the sound — A/B every cue before you commit to one
skill: sound-design
type: sfx
family: sfx-selection
tags: [skill/sound-design, type/sfx, family/sfx-selection, sfx/aesthetic, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:05:54"
    quote: "In a single shot, let me put different sound effects on and show you the difference."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:05:54"
    quote: "A fast heartbeat creates tension; slow breathing sounds can make a moment feel personal, and fast breathing tells you the guy is completely freaking out."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:10:04"
    quote: "Three parameters to turn one sound file into many variations: reverb, pitch change, duration change."
research_refs:
  - https://www.itu.int/dms_pubrec/itu-r/rec/bs/R-REC-BS.1534-3-201510-I!!PDF-E.pdf
  - https://en.wikipedia.org/wiki/MUSHRA
  - https://blog.prosoundeffects.com/sound-layering
  - https://helpx.adobe.com/audition/using/basic-multitrack-controls.html
  - https://www.soundonsound.com/techniques/sound-design-visual-media
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: low
detectable_from: audio
---

# Hold the picture, swap the sound — A/B every cue before you commit to one

## What it is
A working method that is also a teaching device: **keep the picture identical and change only the sound layer**, so you can hear how radically the meaning of one shot moves. The source demonstrates it with intimate sounds on a single shot — a fast heartbeat makes it tense, slow breathing makes it personal, fast breathing makes the character terrified — same frames, three different scenes. As a workflow it is the antidote to the most common sound-design habit: taking the first search hit because it is *a* sound rather than *the* sound. The formal version is stacked candidate tracks, all muted except one, switched while the same few seconds loop — and it borrows two rules from proper listening-test methodology: **level-match the candidates first**, and **randomise the order you hear them in**, because the loud one and the first one both win unfairly.

**Style.** The audition is scoped to meaning-bearing cues, which is why this note is filed `sfx/aesthetic`; routine motion sounds are chosen by rule rather than by taste and are covered by [[sfx-unsounded-motion-audit]] and [[sfx-motion-sound-selection]].

## When to use it
On every cue that carries meaning rather than mechanics. In practice that means: the emotional cue in a scene (which is what the source is demonstrating), the hero transition, the payoff hit, the riser before a reveal, and the signature sound of a recurring element. Skip it for routine motion sounds — a text entrance does not deserve a five-candidate audition, and [[sfx-unsounded-motion-audit]] already covers those by rule rather than by taste. Run the audition **once per cue class**, not once per instance: choose the whoosh for your section transitions once, then reuse it, because the same-sound-every-time failure is about repetition, not about selection ([[sfx-placement-discipline]]). And use the same method as a **teaching device** when the video's own subject is sound — the progressive-layer demo is its close relative ([[struct-progressive-layer-demo]]).

## How to recognise it in a reference video
This one is mostly detectable as a *teaching sequence* in a reference, and as a *quality signature* in the mix.

- **Repeated identical picture, different audio.** The giveaway: the same shot plays two or more times with near-zero inter-frame difference between the repeats, while the audio differs. Detect the repeats first, then compare the audio:
  ```bash
  ffmpeg -i ref.mp4 -vf "select='gt(scene,0.3)',showinfo" -vsync vfr -f null - 2>&1 | grep pts_time
  ffmpeg -ss <rep1> -t 3 -i ref.mp4 -lavfi showspectrumpic=s=1200x600 a.png
  ffmpeg -ss <rep2> -t 3 -i ref.mp4 -lavfi showspectrumpic=s=1200x600 b.png
  ```
- **Transcript framing.** Look for the demonstration verbs: "let me put different sound effects on", "listen to this one", "now the same shot with…", "hear the difference". Present = the reference is teaching the method.
- **Candidate count in the demo.** Log how many alternatives are played. Teaching sequences run **2–4**; more than four and the audience loses the baseline.
- **The baseline is replayed.** A well-built demo returns to the *silent* or original version at least once so the comparison has an anchor — the hidden-reference logic of a formal listening test, applied informally.
- **Level parity between the versions.** Measure short-term loudness across the repeats. If one candidate is 3+ dB louder, the demo is rigged (usually unintentionally) — and so is the choice it justifies:
  ```bash
  ffmpeg -ss <rep> -t 3 -i ref.mp4 -af "ebur128=peak=true" -f null - 2>&1 | tail -20
  ```
- **Signature of a mix where auditions happened.** Across the whole video, cues of the same class sound *consistent* (one whoosh family, one hit family) while cues of different classes sound *distinct*. A mix where every accent is a different library file is a mix where nothing was auditioned — the file that came up first was used every time.
- **Variation rather than repetition.** Where the same cue recurs, listen for the three-parameter treatment — reverb, pitch, duration — rather than a literal repeat. A recurring cue that is pitched a couple of semitones apart on each use is the audible fingerprint of a designer who auditioned once and varied afterwards.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `candidates_per_cue` | 4 | 3–6 | Below 3 is not an audition; above ~6 the ear stops discriminating in one sitting. Formal listening tests cap a single trial at 12 signals including anchors. |
| `families_represented` | 3 | 2–4 | Candidates must come from **different families** (whoosh, hit, riser, tone, intimate, cartoon, foley), not four versions of one. Meaning changes between families; texture changes within them. |
| `loop_window` | 4 s (120 f) | 2–6 s | The picture window you loop. Long enough to contain the cue plus context, short enough to hold in memory. |
| `level_match_tol` | ±0.5 LU | ±0–1 LU | Match candidates before comparing. Level difference is the single largest bias in any A/B. |
| `order` | randomised | — | Randomise presentation order; do not always start with your favourite. |
| `include_null` | true | — | Always include a "no sound" candidate. It wins more often than editors expect. |
| `rounds` | 2 | 1–3 | Round 1 narrows 4–6 to 2; round 2 chooses. Deciding in one pass is deciding by first impression. |
| `decision_criterion` | meaning | meaning \| texture | State before listening what the cue must *do* ("tense", "final", "playful"). Choose on that, then check texture. |
| `variation_params` | reverb, pitch, duration | — | Once chosen, generate reuses by varying these three rather than re-auditioning. |
| `pitch_variation` | ±2 semitones | ±1–4 | Enough that a repeat is not literal, not so much that it becomes a different object. |
| `layer_ceiling` | 3 | 2–5 files | If a chosen "sound" is really a stack, keep it under 5 and mute-test each layer. |
| `audition_at_final_level` | true | — | Judge with the bed, the voice and the ambience playing, at mix levels — never soloed. |

## Reproduction prompt

```
Choose the sound for cue {{CUE}} at {{T}} by A/B audition.

1. STATE THE JOB IN ONE WORD before you listen: what must this cue DO?
   (tense / final / playful / soft / heavy / urgent). Write it down. You are
   choosing against this word, not against "which sounds nicer".
2. GATHER 4 CANDIDATES FROM DIFFERENT FAMILIES. Not four whooshes - one
   whoosh, one hit, one riser, one texture/tone, or whichever four families
   could plausibly do the job. Add a 5th candidate that is SILENCE. Meaning
   lives between families; texture lives within them.
3. LEVEL-MATCH THEM to within 0.5 LU of each other, measured over the cue
   itself, before any comparison. An unmatched candidate that is 3 dB louder
   will win for the wrong reason.
4. BUILD THE LOOP. Take a {{WINDOW}} of picture - default 4 seconds (120
   frames) - containing the cue and enough context to read it. The picture
   never changes. Only the candidate layer changes.
5. AUDITION AT FINAL MIX LEVELS with the voice, bed and ambience playing.
   Never solo. A cue judged in isolation will be 6 dB too loud in the mix.
6. RANDOMISE THE ORDER and play each candidate twice. Do not stop on the
   first one that works. Round 1: eliminate to two. Round 2: choose,
   including silence as a live option.
7. RECORD THE DECISION: the chosen file, the one-word job, and the two
   runners-up. The runners-up are your variation stock for the next
   occurrence of this cue class.
8. VARY, DON'T RE-AUDITION. For subsequent instances of the same cue class,
   reuse the chosen sound and vary it with the three parameters: reverb
   (space), pitch (+/- 2 semitones), duration (match to the motion). Do not
   run a new audition per instance - that is what makes a mix incoherent.
9. ACCEPTANCE TEST: (a) all candidates were within 0.5 LU before choosing;
   (b) at least three families were represented; (c) silence was genuinely
   considered; (d) the chosen cue still reads as the one-word job when
   played inside the full mix at final levels; (e) the decision is written
   down with its runners-up.
```

## Execution spec

**HyperFrames (primary).** There is no solo/mute API in the contract — but there is exactly the right attribute: **`data-hidden`** *"hides the element in both preview and render, overriding its time window. Non-destructive, reversible, toggled by Studio's timeline eye icon."* Stack the candidates at the same `data-start`, on **different track indices**, with all but one hidden.

```html
<!-- CANDIDATE RACK for the reveal at 41.20s. Exactly one is un-hidden at a time. -->
<audio id="cand-a-hit"    src="assets/sfx/cand/hit-deep.wav"      data-audio-group="sfx"
       data-start="41.20" data-duration="1.20" data-track-index="20" data-volume="0.22"></audio>
<audio id="cand-b-riser"  src="assets/sfx/cand/riser-short.wav"   data-audio-group="sfx" data-hidden
       data-start="40.40" data-duration="2.00" data-track-index="21" data-volume="0.22"></audio>
<audio id="cand-c-whoosh" src="assets/sfx/cand/whoosh-tonal.wav"  data-audio-group="sfx" data-hidden
       data-start="41.05" data-duration="0.90" data-track-index="22" data-volume="0.24"></audio>
<audio id="cand-d-tone"   src="assets/sfx/cand/tone-dark.wav"     data-audio-group="sfx" data-hidden
       data-start="40.60" data-duration="2.40" data-track-index="23" data-volume="0.18"></audio>
<!-- candidate E is silence: hide all four. -->
```

Why it is built this way, against the contract:
- **Every `<audio>` needs a unique `id`** — an id-less audio track is never mixed and renders silent with no warning, which in an audition rack reads as "that candidate is bad".
- **Different `data-track-index` per candidate.** Two overlapping `<audio>` on one track index raise `duplicate_audio_track`. Two candidates sharing the same `src` *and* `data-start` would also trip `duplicate_media_discovery_risk`, which is benign but noisy.
- Track indices **20+** keep the rack clearly above the real mix lanes (0 base video, 1+ visuals, 10+ audio).
- Note each candidate has its **own `data-start`**: a riser must start early to peak on the frame, a hit starts on it. Aligning candidates by their *peak*, not their onset, is part of a fair comparison ([[sfx-placement-discipline]]).
- To audition a whole **group** at once — say four layers that together form one candidate — put them in an `<hf-audio-group>` and use `data-hidden` on the group: it *"drops every member from the mix"*.
- **Level-match with `data-volume`**, not by ear-adjusting during the test. `data-volume` is a static gain, default `1` (0 dB), max `3.98` (+12 dB). Do **not** mix a `volume` automation lane with a GSAP `volume` tween on the same clip — the lane wins silently.
- When the choice is made, delete the losing clips' `data-hidden` siblings from the file. **The mounted vault cannot delete files**, but removing elements from a composition is an ordinary edit — just do not design a workflow that depends on deleting the candidate *media* from disk.

**The device constraint that shapes this workflow.** `preview`, `play`, `render` and `snapshot` are all browser-dependent, and the device VM here is **linux ARM64 without sudo**, so browser-hosted playback must happen elsewhere. On this machine, do the audition as **offline mixdowns with ffmpeg** and listen to those files; use the Studio eye-icon rack when a browser host is available.

**ffmpeg — the portable audition rig.** Build one file per candidate over an identical picture window, level-matched, then listen back to back:
```bash
WIN_START=39.5; WIN_LEN=4; CUE_MS=1700      # cue offset inside the window, in ms
ffmpeg -ss $WIN_START -t $WIN_LEN -i final_nosfx.mp4 -c copy window.mp4
for c in hit-deep riser-short whoosh-tonal tone-dark; do
  # measure the candidate, then normalise it to a common target before comparing
  ffmpeg -i assets/sfx/cand/$c.wav -af "loudnorm=I=-23:TP=-2:LRA=7" -ar 48000 norm-$c.wav
  ffmpeg -i window.mp4 -i norm-$c.wav -filter_complex \
    "[1:a]adelay=${CUE_MS}|${CUE_MS},volume=-13dB[s];[0:a][s]amix=inputs=2:normalize=0[a]" \
    -map 0:v -map "[a]" -c:v copy ab-$c.mp4
done
ffmpeg -ss $WIN_START -t $WIN_LEN -i final_nosfx.mp4 -c copy ab-silence.mp4
# verify parity across the rack
for f in ab-*.mp4; do echo "$f"; ffmpeg -i $f -af ebur128 -f null - 2>&1 | tail -6; done
```
Two-pass `loudnorm` (measure, then apply the measured values) is the accurate form; the single pass above is adequate for candidate parity. Once chosen, generate variations rather than re-auditioning:
```bash
ffmpeg -i chosen.wav -af "asetrate=48000*1.122,aresample=48000,atempo=0.891" chosen.up2st.wav   # +2 semitones, same length
ffmpeg -i chosen.wav -af "aecho=0.8:0.7:60:0.3" chosen.room.wav                                  # cheap space
```
In-composition, the same three variations are available declaratively: `reverb` (size/damping/wet/dry — `wet`/`dry` are automatable, `size`/`damping` are not because they regenerate the impulse), `data-playback-rate` for duration (constant, `0.1..5`, **pitch-preserved**, so it is *not* a pitch shifter), and `data-media-start` + `data-duration` for trimming.

**Epidemic Sound.** The audition rack is exactly what `Search*` + `SearchSimilarTo*` are for:
- Cast wide first, across families: `SearchSoundEffects { query.term: "deep impact hit" }`, `{ "short riser tension" }`, `{ "dark tone drone" }`, `{ "heartbeat fast" }` — four searches, one candidate each.
- Then narrow: `SearchSimilarToSoundEffect` against the round-1 winner to find its better sibling.
- Download all candidates before auditioning; comparing a downloaded file against a streamed preview is not a fair test.

**Remotion:** conceptually N `<Audio>` components behind a candidate switch; no Remotion runtime in this project.

## Pairs with
[[sfx-placement-discipline]] · [[sfx-unsounded-motion-audit]] · [[sfx-music-audition-against-picture]] · [[sfx-sound-pass-order]] · [[sfx-cartoon-comedy-family]] · [[sfx-riser-anticipation-build]] · [[struct-progressive-layer-demo]] · [[sfx-vibe-brief]] · [[sfx-music-hard-stop]] · [[sfx-search-vocabulary]]

## Failure modes
- **Taking the first hit.** The most common failure and the reason this note exists. Fix: four candidates and a silence, always, for meaning-bearing cues.
- **Auditioning four versions of the same thing.** Four whooshes tell you about texture and nothing about meaning. Fix: enforce `families_represented ≥ 3`.
- **Comparing at different levels.** The louder candidate wins; listening-test methodology exists precisely because of this. Fix: level-match to ±0.5 LU first.
- **Auditioning soloed.** A cue chosen in isolation is invariably too loud and too busy once the bed and voice return. Fix: judge inside the full mix at final levels.
- **Aligning candidates by file start.** A riser and a hit placed at the same `data-start` peak at different times, so you are comparing timing, not sound. Fix: align every candidate by its **peak** on the target frame.
- **Never considering silence.** Some cues are better empty; the overload failure (a tick every other second) is built out of cues that were never questioned. Fix: silence is always candidate five.
- **Re-auditioning every instance.** Produces a mix where nothing is recognisable as a system. Fix: choose per cue *class*, then vary with reverb, pitch and duration.
- **Leaving hidden candidates in the shipped file.** `data-hidden` clips are inert in preview and render, so they will not be heard — but they linger as confusing dead weight and the next carve/analysis pass sees them. Fix: remove the rack from the composition once the decision is recorded.
- **Known gap:** no source publishes how many candidates professional sound editors audition per cue; the 3–6 figure here is house calibration bounded by two real anchors — the layering guidance that 3–5 files per sound is where you should stop and mute-test, and the formal listening-test cap of 12 signals per trial. The level-matching and order-randomisation requirements, by contrast, are lifted directly from listening-test methodology and are the most defensible part of this note.
