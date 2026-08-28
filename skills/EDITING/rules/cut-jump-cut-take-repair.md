---
id: cut-jump-cut-take-repair
title: The jump cut — splice out the mistake, the restart and the dead pause
skill: editing
type: cut
family: jump-cut
tags: [skill/editing, type/cut, family/jump-cut, layer/dialogue, engine/ffmpeg, engine/hyperframes, source/editing-kt-2, source/editing-kt, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:47"
    quote: "This cut is when a segment of a shot has been removed and the separate ends have been spliced back together, making the shot feel like it has jumped in time."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:56"
    quote: "You may also see a lot of jump cuts in talking head videos on YouTube, to help remove pauses and mistakes."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:02"
    quote: "In this Tarantino movie, the effect these jump cuts are having is showing the passing of time, and that the characters have actually been speaking longer than the screen time being shown."
research_refs:
  - https://github.com/WyattBlue/auto-editor/blob/master/README.md
  - https://ffmpeg.org/ffmpeg-filters.html#silencedetect
  - https://www.mdpi.com/2226-471X/8/1/23
  - https://en.wikipedia.org/wiki/Words_per_minute
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/360051554394-Timed-Text-Style-Guide-Subtitle-Timing-Guidelines
difficulty: low
detectable_from: transcript+video
---

# The jump cut — splice out the mistake, the restart and the dead pause

## What it is
The jump cut is number two in the source's ten-cut taxonomy, and its definition is purely mechanical: **a segment is removed from the middle of a single continuous shot and the two ends are spliced back together**, so the subject appears to jump. Everything else about it follows from the fact that the camera did not move — background, framing and lighting are identical across the cut, and only the subject has changed position, which is exactly why the eye catches it.

It has two completely different jobs, and confusing them is the commonest reason a jump cut looks like a mistake:

1. **Repair / density (the creator use).** In self-shot talking-head footage the removed segment is *dead material* — a pause, a stumble, a false start, a filler run, a fluffed line and its retake. The jump is a side effect the audience has learned to ignore, and the payoff is a delivery that is continuously informative. This is the dominant pacing device in YouTube-style explainers.
2. **Time compression (the narrative use).** The removed segment is *real story time*, and the jump is the point: the source's own example is a Tarantino scene where the jumps signal the characters have been talking longer than the screen time shows.

This note owns **job 1, and specifically the mistake half of it** — take selection, false starts, stumbles, retakes. The silence half (thresholds, keep-floors, breath policy, the entertainment/authenticity dial) is fully specified in [[pace-partial-pause-removal]] and is not repeated here; run both passes together, in that order.

## When to use it
Every self-shot A-roll pass, on footage recorded in one continuous unedited take against a static camera. Specifically: whenever the transcript contains a sentence started and abandoned, a word audibly mispronounced and repeated, a run of fillers, a direct address to yourself ("sorry", "again", "one more"), or the same sentence delivered twice because the first delivery was bad.

Do **not** use a jump cut when a cutaway is available and the join is ugly — an insert, a B-roll overlay or a second angle removes the jump entirely and costs nothing ([[pace-overlay-instead-of-cut]]). Do not use it to remove a *pause that is doing work* — before a reveal, after a punchline, around a number. Do not use it on a moving camera or a moving subject: the mismatch that a static-frame jump cut absorbs becomes a continuity error the moment anything is travelling ([[cut-continuity-pass]]). And do not use it on an interview or a testimonial where a visible splice reads as manipulation — use a cutaway or a genuine second angle.

## How to recognise it in a reference video
- **The frame is the test.** At a candidate boundary, step one frame either side and compare the **static** parts of the picture: background objects, light, framing, lens. If those are identical and only the subject's head/hands/posture have moved, it is a jump cut. If the whole frame changed, it is a normal cut.
- **Measure the subject displacement.** A repair jump cut shows a **discontinuous head-position shift** with everything else locked. Quantify it: the head bounding box typically shifts **1–6% of frame width**; below ~1% the cut is invisible and probably had matched framing; above ~10% the presenter has moved between takes and the cut will read as sloppy.
- **Count them per minute.** Frame-step or scene-detect the A-roll track only. **15–40 jump cuts per minute** is a normal aggressive talking-head edit; over ~60/min the picture is being held together by masking rather than by the cut.
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=6,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ```
  Use a **low** `scdet` threshold here: a jump cut in a locked-off frame is a small change and a default threshold misses most of them.
- **Distinguish repair from time-compression.** Repair jumps land **inside or between sentences** and preserve the sense; the transcript reads continuously across them. Time-compression jumps land where the *content* also skips — a new subject, a changed position in the room, a different stage of a task. Log which kind each is.
- **Transcript forensics is the strongest signal for the mistake half.** In a *finished* video look for the absences: no fillers at all while sentence rhythm survives; no abandoned clauses; no repeated openings. In *raw* footage look for the presences — that is what you are going to cut.
  - **False start:** two consecutive utterances beginning with the same 2–4 words, the first one shorter and abandoned.
  - **Retake:** an n-gram of ≥5 words repeated within 30 s with near-identical wording.
  - **Self-address:** "sorry", "again", "let me", "one more", "cut", "take two", "hold on".
  - **Filler run:** ≥2 filler tokens ("um", "uh", "like", "you know") inside a 3-second window.
- **What masks the join tells you the house style.** Log which of these appears at each join: nothing (bare jump — entertainment-first signature); an alternating punch-in ([[cut-punch-in-emphasis]]); a B-roll overlay landing exactly on the join; a whip/whoosh SFX; a full-screen graphic. A single video usually uses one or two consistently.
- **Audio join audit.** Solo the audio and listen at ten joins. A clean repair pass has **no clipped consonants, no half-breaths and no level step**. A click, a truncated plosive or a breath cut in half is the tell of an automated pass run without padding.
- **Effective speaking rate.** Words in the finished cut ÷ speech runtime. Under ~150 wpm is conversational; 175–200 wpm indicates an aggressive repair-plus-silence pass. For reference, audiobooks are read at **150–160 wpm** and slide presentations at **100–125 wpm**.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `pad_lead_in` | 2 f (0.067 s) | 1–3 f | Handle kept **before** the first word of the incoming segment. Protects plosive and fricative onsets — cutting on the exact word-start timestamp clips them. |
| `pad_tail` | 3 f (0.10 s) | 2–6 f | Handle kept **after** the last word, so the word's decay survives. `auto-editor`'s `--margin` defaults to **0.2 s** both sides, which is safe but leaves audible air. |
| `false_start_ngram` | 3 words | 2–4 | Length of the shared opening that identifies an abandoned start. |
| `retake_ngram` | 5 words | 4–8 | Repeated-phrase length that identifies a duplicate take. |
| `retake_window` | 30 s | 10–90 s | How far apart two deliveries can be and still be the same take. |
| `take_choice` | last | last \| best | Default to the **last** delivery — a presenter who restarts has usually improved. Override to `best` only with an explicit quality judgement per pair. |
| `filler_run_threshold` | 2 in 3.0 s | 2–3 | Filler density that triggers removal of the whole run rather than individual tokens. |
| `head_shift_max` | 6% frame width | 1–10% | Above this, mask the join instead of leaving it bare. |
| `cuts_per_min_cap` | 40 | 20–60 | Review flag on A-roll jump-cut density. |
| `mask_ratio` | 0.25 | 0.0–0.6 | Fraction of joins carrying a punch-in, overlay or SFX rather than being bare. 0.0 is entertainment-first; above ~0.6 you are hiding a bad take, not editing. |
| `punch_in_scale` | 1.12 | 1.08–1.20 | Scale step when alternating framing across a join. Below 1.08 it reads as a wobble, not a size change. |
| `join_crossfade_audio` | 1 f (33 ms) | 0–2 f | Tiny audio crossfade at every splice to kill clicks. Never longer — 3 f starts smearing consonants. |
| `protected_ranges` | — | list of `a-b` | Beats where the pause or the stumble is the content (a genuine laugh, a considered silence). Excluded from the pass. |
| `min_kept_segment` | 12 f (0.4 s) | 8–20 f | Never leave a surviving fragment shorter than this between two cuts; it reads as a glitch. |

## Reproduction prompt

```
Run a jump-cut repair pass on the talking-head A-roll {{SRC}}. This pass
removes MISTAKES. Run the silence/pause pass separately and afterwards.

1. Transcribe to word level. Work only from the transcript plus its word
   timestamps; do not scrub video looking for mistakes.
2. Find every REMOVE candidate and log it as a second-range a-b:
   a) FALSE START - two consecutive utterances sharing their first 3 words,
      where the first is shorter and abandoned. Remove the first.
   b) RETAKE - any 5-word sequence repeated within 30s with near-identical
      wording. Keep the LAST delivery, remove all earlier ones and everything
      between the end of the kept-out delivery and the start of the keeper.
   c) SELF-ADDRESS - "sorry", "again", "let me", "one more", "take two",
      "cut", "hold on" and the broken clause attached to it.
   d) FILLER RUN - 2+ fillers inside 3.0s: remove the whole run, not the
      individual tokens.
   e) MISPRONUNCIATION - a word said, corrected and repeated: remove the
      first attempt and the correction phrase.
3. SNAP every boundary off the raw word timestamps: start each kept segment
   {{PAD_IN}}=2 frames BEFORE its first word, and end it {{PAD_TAIL}}=3
   frames AFTER its last word. Cutting exactly on a word timestamp clips the
   consonant onset.
4. Do not create a surviving fragment shorter than 12 frames. If two removals
   would leave one, extend the removal to swallow it.
5. Exclude {{PROTECTED}} ranges entirely.
6. Emit the removal list, apply it, and add a 1-frame audio crossfade at
   every splice.
7. MASK PASS: for each resulting join, measure the subject's head-position
   shift. Bare join if under 6% of frame width. Above that, choose ONE of:
   alternate the framing by scaling the incoming side to 1.12; land a B-roll
   or graphic overlay exactly on the join; or place a short whoosh on the
   cut. Keep masked joins under 25% of all joins.
8. ACCEPTANCE TEST: (a) read the output transcript aloud - it must be
   grammatical and contain no repeated openings; (b) listen to ten joins with
   your eyes closed - no clicks, no clipped consonants, no half-breaths, no
   level steps; (c) count jump cuts per minute of A-roll - flag over 40;
   (d) confirm no surviving fragment is under 12 frames.
```

## Execution spec

**ffmpeg / `transcript-cut.mjs` (primary — this is a raw media operation).** The removal list is exactly what the project's transcript-cut compiler takes. It compiles a kept-segment list, cuts each segment with `ffmpeg -ss … -to …`, concatenates, and atomic-renames the output:

```bash
node <SKILL_DIR>/scripts/transcribe.mjs --input araw.mp4 --out araw.transcribe.json

# inspect the kept segments before encoding
node <SKILL_DIR>/scripts/transcript-cut.mjs \
  --input araw.mp4 --transcript araw.transcribe.json \
  --remove "12.41-15.02,88.30-91.70,203.15-209.44" \
  --remove-fillers "um,uh,like,you know" \
  --plan

node <SKILL_DIR>/scripts/transcript-cut.mjs \
  --input araw.mp4 --transcript araw.transcribe.json \
  --remove "12.41-15.02,88.30-91.70,203.15-209.44" \
  --remove-fillers "um,uh,like,you know" \
  --out a-repaired.mp4
```

Options that matter here: `--remove` (second ranges), `--remove-words` (word-**index** ranges — better for filler surgery), `--remove-fillers`, `--keep` (inverse mode, mutually exclusive with removal), `--plan`, `--json`. **Do not add `--copy`** for this job: stream copy cuts only on keyframes, and on sparse-keyframe footage the snap "can silently swallow the whole cut"; the script measures produced-vs-expected duration and reports `copy_drift` on >1 s drift, but the correct answer is to drop `--copy` for frame-accurate cuts. Keep scratch and temp output **outside the vault mount**, which cannot delete files.

Silence removal is a **separate invocation** with `--cut-silence <seconds>`, or `auto-editor` (`--edit audio:threshold=0.04` ≈ −28 dBFS, `--margin 0.2s`). Note that raw `ffmpeg silencedetect` defaults — `noise=-60dB`, `duration=2` — are a digital-silence detector and find almost no speech pauses; override both. Full treatment in [[pace-partial-pause-removal]].

**HyperFrames (when the repair stays declarative).** You do **not** need a cut file if the A-roll enters a composition: each surviving segment is one clip pair, picture muted plus its own `<audio>`, all times in **seconds**, back-to-back with no overlap because the visibility window is half-open `[start, start+duration)`:

```html
<video id="a-01" src="araw.mp4" muted playsinline class="clip"
       data-start="0"    data-duration="4.20" data-media-start="3.10"  data-track-index="0"></video>
<audio id="a-01-aud" src="araw.mp4" data-audio-group="voiceover"
       data-start="0"    data-duration="4.20" data-media-start="3.10"  data-track-index="10"></audio>
<video id="a-02" src="araw.mp4" muted playsinline class="clip"
       data-start="4.20" data-duration="6.05" data-media-start="15.02" data-track-index="0"></video>
<audio id="a-02-aud" src="araw.mp4" data-audio-group="voiceover"
       data-start="4.20" data-duration="6.05" data-media-start="15.02" data-track-index="11"></audio>
```

Contract details: every `<audio>` needs an `id` (an id-less audio track is never mixed → silent render); do not nest a `<video data-start>` inside another timed element (`video_nested_in_timed_element`, error); picture and its sound are aligned by **writing the same numbers twice** — there is no automatic waveform sync in this stack; and `data-media-start` is what implements the pad, so subtract `pad_lead_in` from the first word's timestamp when you compute it. At 30 fps, 2 f = 0.067 s and 3 f = 0.10 s. Practical warning: a 400-clip repaired A-roll is unwieldy as markup — past roughly 40 segments, cut the file with `transcript-cut.mjs` and bring in one clean asset.

For the **mask pass**, the punch-in is a GSAP scale on the incoming clip's wrapper, authored on the composition's single paused timeline (`tl.fromTo(el, {scale:1}, {scale:1.12, duration:0.001})` as a hard step, or a real 0.25 s `power3.out` move for a visible push-in — see [[cut-punch-in-emphasis]]). Never tween `width`/`height`; never CSS-`transform` an element you also GSAP-tween (`gsap_css_transform_conflict`, error).

**Epidemic Sound.** For masked joins: `SearchSoundEffects { query.term: "short whoosh transition subtle", filter.duration { max: 700 } }`, placed at the join, `data-audio-group="sfx"`, track index 12+, around −13 dB (`data-volume` ≈ `0.22`). See [[sfx-whoosh-transition-movement-reveal]] and [[sfx-whip-crack-on-snap-cut]].

**Remotion:** conceptually one `<Sequence>` per surviving segment with an `<OffthreadVideo startFrom=…>`; no Remotion runtime exists in this project.

## Pairs with
[[pace-partial-pause-removal]] · [[pace-subtractive-first-pass]] · [[cut-punch-in-emphasis]] · [[pace-overlay-instead-of-cut]] · [[cut-straight-hard-cut]] · [[struct-misspeak-correction-gag]] · [[pace-a-roll-burst-rationing]] · [[cut-continuity-pass]] · [[sfx-whoosh-transition-movement-reveal]] · [[pace-cut-density-from-viewer-intent]] · [[cut-b-roll-coverage-from-transcript]]

## Failure modes
- **Cutting on the word timestamp.** ASR word starts sit at the vowel, not at the consonant onset, so an exact cut lops the front off "product", "start", "think". Fix: 2 frames of lead-in, always.
- **No tail pad.** The last word's decay is severed and the join clicks. Fix: 3 frames, plus a 1-frame audio crossfade.
- **Removing every breath.** The single loudest authenticity tell; the presenter starts sounding synthetic. Fix: keep breaths and attenuate them −6 to −9 dB rather than cutting them.
- **Keeping the wrong take.** Defaulting to the first delivery keeps the version the presenter chose to abandon. Fix: keep the last unless you have explicitly judged otherwise.
- **Orphan fragments.** Two adjacent removals leave a 6-frame sliver of a word between them. Fix: `min_kept_segment` 12 f; extend the removal to swallow it.
- **Masking everything.** A punch-in on every join turns the video into a zoom metronome and telegraphs that the take was bad. Fix: `mask_ratio` ≤ 0.25, bare joins by default.
- **Jump-cutting a moving shot.** The device only absorbs discontinuity because the frame is locked. Fix: static camera only; otherwise cut away.
- **Using `--copy`.** Keyframe snapping silently swallows cuts on sparse-keyframe footage. Fix: drop `--copy` and accept the re-encode.
- **Confusing the two jobs.** A time-compression jump in the middle of an explanation reads as a mistake, not as style. Fix: label each jump repair or compression, and keep compression jumps at genuine content skips.
- **Known gap:** there is no published standard for jump-cut density or head-shift tolerance in creator content; `cuts_per_min_cap`, `head_shift_max` and `mask_ratio` are house calibration. The padding, threshold and margin numbers are anchored to the shipped defaults of `auto-editor` and `transcript-cut.mjs` and are defensible; the density numbers should be re-derived from the reference video whenever one exists.
