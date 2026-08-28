---
id: struct-misspeak-correction-gag
title: The scripted misspeak — a two-beat correction gag inside a dry explanation
skill: editing
type: retention
family: pattern-interrupt
tags: [skill/editing, type/retention, family/pattern-interrupt, layer/dialogue, layer/sfx, engine/hyperframes, engine/epidemic, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:46"
    quote: "But how do we know which BDSM is running on our video? — (interjection) BPM? — Yeah, that."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:10"
    quote: "So first up is BPM, that is, beats per minute."
research_refs:
  - https://www.clevercast.com/bbc-subtitling-guidelines/
  - https://www.clevercast.com/standards-guidelines-closed-captions/
  - https://air.io/en/youtube-hacks/advanced-retention-editing-cutting-patterns-that-keep-viewers-past-minute-8
  - https://pixflow.net/blog/youtube-video-retention-editing/
  - https://tvtropes.org/pmwiki/pmwiki.php/Main/RecordNeedleScratch
  - https://www.masterclass.com/articles/guide-to-comedic-timing
difficulty: low
detectable_from: transcript
---

# The scripted misspeak — a two-beat correction gag inside a dry explanation

## What it is
A deliberately wrong word, immediately corrected by a second voice, dropped into the driest stretch of a technical explanation. In the source the presenter is four beats into explaining beats-per-minute when he asks how you know *"which **BDSM** is running on our video"*, the alter-ego says *"BPM?"*, and he answers *"Yeah, that."* Three things make it work and all three are structural rather than comedic. **(1) It is only funny if the correct term has already been taught** — the joke is a deliberate corruption of something the viewer learned ninety seconds ago, so it doubles as a recall check. **(2) The correction is a second voice**, so the presenter never breaks his own authority; the alter-ego takes the hit. **(3) It costs about two seconds** and returns the explanation exactly where it was — nothing has to be re-established afterwards. It is a *micro*-interrupt: smaller and cheaper than a full presenter aside ([[struct-presenter-aside-pattern-interrupt]]) or an objection cutaway ([[struct-objection-character-cutaway]]), and therefore usable in places where those would be too expensive.

## When to use it
Place it **inside the driest passage of the video**, not at its edges. Concretely: in the second half of a definitional stretch (a term being defined, a unit being explained, a spec being read), immediately before or after a number-heavy line, or at the point in a numbered list where the format has been learned and the novelty has gone. Retention practice puts the first deliberate interrupt at **25–35 s** and re-engagement devices every **2–3 minutes**; a misspeak gag is the cheapest thing that fits either slot. It also needs three preconditions: **a term the audience already knows** (taught earlier in this same video), **a second voice or persona** to deliver the correction, and **a corruption that is obviously wrong** — a near-miss reads as an error rather than as a joke. Do **not** use it on the video's thesis or on any number the viewer must retain: corrupting the one figure they need is a real cost, not a gag. Do not use it in the hook, where credibility is being established. Do not use two in the same section. And never use it where the misspoken word could plausibly be believed — if a viewer might repeat the wrong term, the gag has failed upward into misinformation.

## How to recognise it in a reference video
- **Transcript alone is sufficient**, which makes this one of the cheapest techniques to detect at scale. The signature is a **three-move sequence in under 4 seconds**: a wrong or absurd token → an interrogative correction, usually one word with a question mark → a minimal acknowledgement ("yeah, that", "right", "that").
- **The corrupted token is a near-neighbour of a term used earlier.** Test it mechanically: for each unusual token, compute edit distance and initialism overlap against the video's own vocabulary. `BDSM` vs `BPM` shares two of three letters and the initialism shape. A hit with **≥ 50% character overlap or an identical initial letter and length ±1** against a term already used, appearing exactly once, is almost certainly this device.
- **Speaker change across the correction.** Two different voices in under 2 seconds, and the second one speaks **1–4 words**. If the same speaker corrects themselves, it is a self-correction gag (a valid variant — log it as such).
- **Length.** The whole unit is **45–120 f (1.5–4 s)**. The gap between the wrong word and the correction is **9–24 f (0.3–0.8 s)** — long enough for the viewer to register the error themselves, short enough that they do not start doubting the video. That beat is the entire craft of the move.
- **Production drops around it, then returns.** Typically no B-roll under the correction, often a cut to the second persona's framing, frequently an SFX punctuation on the correction word ([[sfx-record-scratch-punctuation]]) and a bed dip. The explanation's visual treatment resumes unchanged immediately after.
- **Check the captions.** This is the diagnostic that separates a finished edit from a rough one: does the burned-in caption show the **wrong word verbatim**? If it shows the correct term, the caption pass silently deleted the joke, and a viewer watching muted sees no gag at all.
- **Position in runtime.** Log it as a fraction. These cluster at **0.15–0.40** — early enough that the term is fresh, late enough that the definitional stretch has gone dry.
- **Density.** At most **1 per 3–4 minutes**, and typically 1–3 in a whole video. More than that and the presenter reads as unable to say anything correctly.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `unit_len` | 75 f (2.5 s) | 45–120 f (1.5–4 s) | Wrong word → correction → acknowledgement, end to end. |
| `beat_gap` | 15 f (0.50 s) | 9–24 f (0.3–0.8 s) | Silence between the wrong word and the correction. The load-bearing number. |
| `correction_len` | 24 f (0.8 s) | 12–45 f | The corrector's line: 1–4 words. |
| `ack_len` | 24 f (0.8 s) | 12–36 f | "Yeah, that." Keep it shorter than the correction. |
| `distance_from_teach` | 60 s | 30–180 s | Time since the correct term was taught. Under 30 s the corruption reads as a mistake; over ~3 min the viewer has lost the reference. |
| `corruption_similarity` | ≥ 0.5 | 0.4–0.8 | Character overlap with the real term. Too low and it is a non-sequitur; too high and it reads as a genuine slip. |
| `position` | 0.25 | 0.15–0.40 | Fraction of runtime. |
| `density` | 1 per 4 min | 1 per 3–6 min | 1–3 per video total. |
| `caption_wrong_word` | verbatim | — | The wrong word appears in the captions exactly as spoken. Non-negotiable for muted viewers. |
| `caption_min_display` | 0.3 s/word | — | BBC guidance: ~0.3 s per word minimum (1.2 s for a 4-word subtitle). |
| `caption_reading_speed` | 170 wpm | 160–180 wpm | BBC recommended band. |
| `sfx_on_correction` | optional | — | If used: one, at −12 to −15 dB, on the correction's first frame. |
| `music_dip` | −4 dB | 0 to −6 dB | Across the unit, recovering immediately. |

## Reproduction prompt

```
Insert a scripted misspeak gag into a dry explanatory passage.

1. FIND THE SLOT. Take the video's driest 30-second window - the one with the
   highest density of definitions, units, numbers or spec, and the lowest
   density of picture changes. The gag goes inside it, at roughly 0.15-0.40 of
   total runtime. Do NOT place it on the thesis, in the hook, or on a number
   the viewer must retain.
2. PICK THE TARGET TERM. It must be a term ALREADY TAUGHT in this video, 30
   to 180 seconds earlier. Corrupt it into something obviously and
   unmistakably wrong that still shares its shape - same initial letter,
   similar length, roughly half its characters. If a viewer could plausibly
   believe the wrong version, choose a different corruption.
3. WRITE THREE BEATS.
   Beat 1 - the presenter uses the wrong term inside an otherwise normal
   sentence, with no signal that anything is wrong. 
   Beat 2 - after a gap of 15 frames (0.50s), a SECOND voice says the correct
   term as a one-word question. 1-4 words, no more.
   Beat 3 - the presenter acknowledges in under 24 frames: "Yeah, that." Then
   the explanation continues from exactly where it was.
   Total 75 frames (2.5s).
4. CUT IT. No B-roll under beats 2 and 3 - the production drops out and the
   two voices carry it. If a second framing exists for the corrector, cut to
   it on beat 2 and back on beat 3. Resume the passage's normal visual
   treatment on the first frame after beat 3.
5. CAPTION THE WRONG WORD VERBATIM. The burned-in caption on beat 1 shows the
   misspoken word exactly as spoken - never the corrected term. Beat 2's
   caption shows the correction as its own line, entering on the correction's
   first frame. A muted viewer must be able to see the whole gag. Hold every
   caption line at least 0.3s per word.
6. SOUND IT, LIGHTLY. At most ONE sound effect, on the first frame of beat 2,
   at -12 to -15 dB. Dip the music bed 4 dB across the unit and restore it
   immediately after beat 3. Do not stop the music for a two-second joke.

ACCEPTANCE TEST: (a) the whole unit runs 45-120 frames and the explanation
resumes with nothing to re-establish; (b) watched MUTED with captions on, the
gag still reads - the wrong word is visible; (c) the corrupted term is a
corruption of something taught earlier in this same video; (d) no viewer
could come away believing the wrong term; (e) there is no second misspeak
gag within 3 minutes either side.
```

## Execution spec

**HyperFrames (primary).** Three beats = three narration clips (or one clip with the beats already inside it) plus a caption sub-composition. Times are **seconds**.

```html
<!-- beat 1: the wrong word, inside the normal line. -->
<audio id="vo-b1" src=".media/audio/voice/bpm-line-wrong.wav" data-audio-group="voiceover"
       data-start="106.00" data-duration="2.10" data-track-index="10"></audio>
<!-- 0.50s gap = 15f. beat 2: the corrector. -->
<audio id="vo-b2" src=".media/audio/voice/alt-correction.wav" data-audio-group="voiceover"
       data-start="108.60" data-duration="0.80" data-track-index="10"></audio>
<!-- beat 3: acknowledgement. -->
<audio id="vo-b3" src=".media/audio/voice/yeah-that.wav" data-audio-group="voiceover"
       data-start="109.40" data-duration="0.80" data-track-index="10"></audio>

<!-- one SFX on the correction's first frame -->
<audio id="sfx-correct" src="assets/sfx/pop-01.wav" data-audio-group="sfx"
       data-start="108.60" data-duration="0.50" data-track-index="15" data-volume="0.22"></audio>

<!-- picture: cut to the corrector's framing for beats 2-3 -->
<video id="pic-b1" src="aroll.mp4" muted playsinline class="clip"
       data-start="106.00" data-duration="2.60" data-media-start="880.00" data-track-index="0"></video>
<video id="pic-b2" src="alt-persona.mp4" muted playsinline class="clip"
       data-start="108.60" data-duration="1.60" data-media-start="14.00" data-track-index="0"></video>
```
The three voice clips can share `data-track-index="10"` because they **do not overlap**; had they overlapped, `duplicate_audio_track` would warn. Every `<audio>` still needs its `id` — an id-less one is never mixed and renders silent.

Bed dip across the unit, as a `volume` lane on the music clip (clip-local `t`, and remember the lane **holds its first value backwards** so the `{t:0}` "no cut" point is mandatory):
```html
data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
  {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:26,&quot;v&quot;:1},{&quot;t&quot;:26.2,&quot;v&quot;:0.63},
  {&quot;t&quot;:30.2,&quot;v&quot;:0.63},{&quot;t&quot;:30.6,&quot;v&quot;:1}]}]}"
```
(`v: 0.63` ≈ −4 dB. Do **not** also GSAP-tween `volume` on this track: `audio_volume_double_automation` — the lane wins and the tween is ignored.)

**Captions — and this is where the note usually fails.** The contract is explicit: **HyperFrames has no caption primitive** — no `data-caption`, no SRT/VTT ingest, no built-in subtitle renderer. A caption is a hand-authored sub-composition whose timeline writes `textContent`. So the wrong word survives or dies depending on what you put in the `script` array. The working reference implementation (`compositions/captions.html`) groups a word-level transcript into 5-word lines and, per line, does exactly four things:
```js
tl.set(box, { visibility: "visible" }, line.start);
tl.to(box, { opacity: 1, duration: 0.1, ease: "power2.out",
             onStart: () => { textEl.textContent = line.text; } }, line.start);
tl.to(box, { opacity: 0, duration: 0.1, ease: "power2.in" }, line.end);
tl.set(box, { opacity: 0, visibility: "hidden" }, line.end + 0.1);
```
Three consequences for this gag:
- The caption text comes from the **inlined `script` array**, so an ASR pass that "corrects" `BDSM` to `BPM`, or a human tidying the transcript, silently deletes the joke. Freeze the wrong token in the array and mark it so no later pass normalises it.
- **Give the correction its own line** rather than letting the 5-word grouping swallow it: split the array at the beat boundary so beat 2 gets a caption entering on its first frame.
- The trailing `tl.set(..., visibility: "hidden")` is legal only because `#caption-box` is **not** the clip element (the clip is the sub-comp host) — never apply it to a `.clip` container, and never tween `display` or raw `visibility` on a clip (lint rejects it; use `autoAlpha`).
Known fragility, worth stating: because the box is reused and the text is set in `onStart`, a **backwards seek** may not restore the correct text. For a three-beat gag whose whole value is one word, prefer a **per-line element with its own opacity envelope** over the shared-box pattern.

Also from the contract: caption fades belong to the **gentle** eases (`power1.out`/`power2.out`, *"NOT the entrance default"*); `white-space: nowrap` + `overflow: hidden` + 5-word grouping is a **text-fit hazard** — a long line clips silently, and the escape hatch for an intentional lower third is `data-layout-allow-caption-zone` (narrower than `data-layout-allow-overflow`, which also suppresses `text-clipping` and `content-cramped-container` for every descendant). Caption type at 48 px sits in the full-screen band; **in-feed viewing wants body ≥32 px and headlines ≥90 px**.

**ffmpeg.** Only to cut the three beats out of a single take and to set the gap precisely:
```bash
node <SKILL_DIR>/scripts/transcript-cut.mjs --input take.mp4 --transcript take.transcribe.json \
  --plan --remove "108.10-108.60" --out beats.mp4
```
`--plan` prints the kept-segment JSON before encoding. Drop `--copy` for frame accuracy.

**Epidemic Sound.** One optional fetch: `SearchSoundEffects { query.term: "cartoon pop boing short", filter.duration { max: 1200 } }` — or the record scratch, if the gag is the absurd kind ([[sfx-record-scratch-punctuation]]). Place in the `sfx` group at `data-volume` ≈ `0.22` (−13 dB). Vary a reused effect by **pitch, reverb and duration** rather than fetching more files.

**Remotion:** conceptually three short `<Sequence>`s with a caption component driven by the same word array; no Remotion runtime exists in this project.

## Pairs with
[[struct-presenter-aside-pattern-interrupt]] · [[struct-objection-character-cutaway]] · [[sfx-record-scratch-punctuation]] · [[struct-stimulation-budget]] · [[pace-visual-change-clock]] · [[struct-name-define-demonstrate]] · [[pace-a-roll-burst-rationing]] · [[struct-enumerated-promise-and-counter]]

## Failure modes
- **The captions show the corrected word.** The commonest failure and completely invisible in a sound-on review. A large share of viewers watch muted; for them the gag simply does not exist. Fix: freeze the wrong token in the caption source and check the burned-in output, not the transcript.
- **A corruption that is believable.** If the wrong term could be mistaken for real, some viewers will carry it away. Fix: make it unmistakably absurd, and keep the correction inside 0.8 s.
- **No beat.** Wrong word and correction back to back with no gap gives the viewer no chance to notice the error themselves, so the joke lands on nobody. Fix: 9–24 f of silence between beats 1 and 2.
- **Too long a beat.** Past ~1 s the viewer starts believing the presenter meant it, and the correction reads as a fix rather than a gag. Fix: cap at 24 f.
- **Corrupting a term the viewer has not learned.** Then it is not a joke, it is a definition they now have wrong. Fix: 30–180 s after the term was taught, never before.
- **Corrupting the thesis or a load-bearing number.** Costs comprehension to buy two seconds of attention. Fix: pick a secondary term.
- **Too many.** Three in five minutes and the presenter reads as sloppy rather than playful. Fix: 1 per 3–6 minutes, 1–3 per video.
- **Over-production.** A whoosh, a zoom, a graphic and a music stop for a two-second gag makes it heavier than the point it interrupts. Fix: at most one SFX and a 4 dB bed dip; production drops out rather than ramping up.
- **Placed at a boundary you are already marking.** Landing it on a section change wastes both interrupts. Fix: keep it inside the dry passage, away from transitions and music changes.
- **Known gap:** there is **no caption primitive, no SRT/VTT ingest and no subtitle renderer** in this stack, and the reference caption implementation is fragile under backwards seek. Any spec that depends on a specific word being on screen must own its caption composition and verify it with a rendered snapshot, not with the transcript.
