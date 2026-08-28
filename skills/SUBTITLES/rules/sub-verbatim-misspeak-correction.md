---
id: sub-verbatim-misspeak-correction
title: Caption the wrong word verbatim, then let the correction land
skill: subtitles
type: caption-timing
family: verbatim-fidelity
tags: [skill/subtitles, type/caption-timing, family/verbatim-fidelity, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:46"
    quote: "But how do we know which BDSM is running on our video? — (interjection) BPM? — Yeah, that."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:35"
    quote: "I mostly use 100-120 BPM music, because I talk a little fast."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://dcmp.org/learn/captioningkey/600
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://www.w3.org/WAI/WCAG22/Understanding/captions-prerecorded.html
difficulty: medium
detectable_from: transcript+video
---

# Caption the wrong word verbatim, then let the correction land

## What it is
A deliberate misspeak — the acronym fumbled, then corrected by an alter-ego in the next beat — is a two-second comedy interruption planted in the driest stretch of a technical explanation. It only works if the caption layer is honest about it. Captioning the *intended* word destroys the joke outright, because the viewer reads "BPM" while hearing "BDSM" and the gag evaporates; and it is also wrong as captioning, because the caption stops matching the audio.

The rule has two halves and a boundary. **Half one: transcribe the misspeak exactly as spoken.** DCMP's Captioning Key is explicit about the general case — when a speaker hesitates or stutters, caption what is said ("c-c-c-old"). **Half two: give the correction its own cue with a visible gap**, because the comedy is in the beat between the error and the fix; chaining them into one cue collapses the timing. **The boundary** is that this applies to *deliberate* or *characterising* errors only. Netflix's style guide says mispronunciations should not be reproduced unless they are plot-pertinent or part of characterisation — a planted gag is exactly that, an accidental slip in a take you kept is not, and a genuine ASR mishearing is neither and must be corrected and logged.

This is the concrete case of the library's verbatim non-negotiable: captions match spoken words, and silent rewrites are a correctness bug rather than a style choice.

## When to use it
- **A planted misspeak gag** — the wrong word, then a correction, usually from a second character, an on-screen alter-ego, or the presenter themselves.
- **Any characterising speech error the edit deliberately kept**: a stutter left in for rhythm, a self-correction that shows the presenter thinking, a mispronunciation that is the point of the beat.
- **The placement question**, when you are designing rather than analysing: put the gag in the **driest 20–40 s** of the explanation, where the retention curve is softest — a filter list, a numbers section, a specification read-out. That is where the source puts it, mid-way through a BPM explanation.
- **Do not** caption verbatim when the error is a genuine ASR artifact (the machine misheard a correct word). Correct it and log the correction.
- **Do not** caption verbatim when the error is an unintended flub you kept for pacing but do not want highlighted; either cut it or accept that captioning it draws attention to it.
- **Do not** use it on a beat carrying critical information the viewer must retain — the gag steals the two seconds either side.

## How to recognise it in a reference video
- **Transcript signature:** a low-frequency or out-of-domain token immediately followed, within **0.5–2.5 s**, by a similar-sounding in-domain token, often with a question mark or a one-word interjection between them. `BDSM → BPM` is the canonical shape.
- **Speaker change on the correction.** Listen for a pitch, level or room change on the correcting line — an alter-ego voice, a different mic position, or a hard-panned overdub. If the correction is a different character, the caption layer usually marks it (a colour, a dash, a speaker tag).
- **Gap between the two cues.** Freeze at the boundary: a working gag leaves **6–20 frames** with the caption zone empty or holding only the wrong word. If the two land in one cue, the reference chose comedy-flattening over rhythm.
- **The wrong word gets no extra emphasis.** Good executions caption the misspeak in the *normal* track style. If it is set in a different colour or size, the edit is telling the joke twice.
- **Cut and sound.** Look for a hard cut to a reaction shot or an insert on the correction, plus a small transient — a record scratch, a cartoon pop, a comedic hit. See [[sfx-record-scratch-punctuation]].
- **Dryness of the surrounding beat.** Note what is being explained on either side. If the 20 s before is numbers or a filter list, log the placement rule, not just the gag.
- **Duration budget.** The whole interruption should be **1.5–3.0 s** from the wrong word to the resumption of the explanation. Longer and it is a sketch, not a beat.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `misspeak_transcription` | verbatim | verbatim only | The spoken token exactly, including a stutter's repeated letters. |
| `misspeak_styling` | track default | default only | No accent colour, no size change on the wrong word. |
| `correction_cue` | separate | separate | Never merged with the misspeak cue. |
| `inter_cue_gap` | 0.30 s (9 f) | 0.20–0.67 s | The comedy beat. Below 6 frames the two words read as one phrase. |
| `correction_hold` | 0.80 s | 0.60–1.20 s | Long enough to be read as an interruption. |
| `resume_gap` | 0.20 s (6 f) | 0.13–0.40 s | Before the explanation's next cue. |
| `total_interruption` | 2.0 s | 1.5–3.0 s | Wrong word to resumption. |
| `speaker_marking` | dash prefix | dash / colour / tag | If the corrector is a different character, mark it once and consistently. Do not invent a name. |
| `placement_target` | driest 20–40 s | — | Numbers, filter lists, specification read-outs. |
| `gags_per_video` | 2 | 1–3 | Beyond three the interruptions become the format. |
| `asr_correction_log` | required | — | Every deviation from the ASR output, with a reason, in `design-subtitles.md`. |
| `sfx_level` | −12 dB | −12 to −15 dB | One transient on the correction, not on the misspeak. |

## Reproduction prompt

```
Caption the misspeak-and-correction beat at {{IN}}.

1. TRANSCRIBE VERBATIM. Take the spoken tokens exactly as uttered from the
   word-level transcript. If the speaker said "BDSM", the caption says "BDSM".
   If the speaker stuttered, write the stutter ("c-c-cold"). Do not substitute
   the intended word, do not add [sic], do not add a parenthetical.
2. VERIFY IT IS DELIBERATE. Confirm from the audio that a correction follows
   within 2.5s. If nothing corrects it, this is either an ASR mishearing (fix
   the text and log the fix) or an unintended flub (leave the text verbatim but
   do not build the beat).
3. SPLIT THE CUES. Cue A = the misspoken clause, ending on the wrong word. Cue
   B = the correction, on its own, held 0.80s. Leave a 0.30s gap with the
   caption zone EMPTY between A and B. Leave 0.20s after B before the
   explanation resumes.
4. STYLE. Cue A and B use the track's default style - no accent colour, no
   size change, no emphasis on the wrong word. If the corrector is a different
   voice, prefix cue B with an em dash and keep that convention everywhere in
   the video.
5. SOUND. One short comedic transient on cue B's in-frame at -12 to -15 dB.
   Nothing on cue A.
6. LOG. Write every deviation from the raw ASR output into
   design-subtitles.md with a one-line reason.

ACCEPTANCE TEST: play the beat muted. The wrong word is legible, then the
screen is empty for ~9 frames, then the correction appears alone. Play it with
sound: every on-screen string matches the audio token for token. Total elapsed
from the wrong word to the resumed explanation is between 1.5s and 3.0s.
```

## Execution spec

**HyperFrames.** This is ordinary cue authoring with one extra requirement: an **enforced empty window** between two cues, which conflicts with the chaining rule in [[sub-cue-segmentation-three-word]]. Chaining is the default within a sentence; here the gap is the content, so it is authored explicitly.

```html
<div class="clip" data-start="0" data-duration="{{DURATION}}" data-track-index="6">
  <div class="cap-stack">
    <span class="cap-card" id="cap-0412">which BDSM</span>
    <span class="cap-card" id="cap-0413">— BPM?</span>
    <span class="cap-card" id="cap-0414">Yeah, that.</span>
  </div>
</div>
```

```js
// A: misspeak. Fades out — this cue does NOT chain into the next.
tl.set("#cap-0412", { autoAlpha: 1 }, 106.10);
tl.to ("#cap-0412", { autoAlpha: 0, duration: 0.10, ease: "power2.in" }, 106.74);
// 0.30s of empty caption zone — the beat.
tl.fromTo("#cap-0413", { autoAlpha: 0 },
  { autoAlpha: 1, duration: 0.10, ease: "power2.out" }, 107.14);
tl.to ("#cap-0413", { autoAlpha: 0, duration: 0.10, ease: "power2.in" }, 107.94);
tl.fromTo("#cap-0414", { autoAlpha: 0 },
  { autoAlpha: 1, duration: 0.10, ease: "power2.out" }, 108.14);
```

Contract points:
- **Each cue is its own element with its own opacity envelope.** The reference `captions.html` reuses one box and writes text in `onStart`, which fires on forward entry only — under a backward seek in Studio the wrong word can persist into the correction, which is exactly the failure this note is about.
- **`fromTo`, never `from`**; `from()` writes its start state at construction, before the clip's `data-start` is active.
- **`autoAlpha` on the cue spans, not on the `.clip`** — the framework owns clip visibility and lint rejects `visibility`/`display` writes on a clip element.
- **All time in seconds**; 9 frames @30fps = 0.30 s, and the frame count survives only as a comment. There is no frame attribute in the stack.
- **The gap is real screen time**, so both neighbouring cues must fade rather than hard-swap; those fades use the gentle `power2` family, not the `power3.out` entrance default.
- **Re-derive after any recut.** `transcript-cut.mjs` is the staged transcript-driven cutting script; if the beat is trimmed, regenerate the cue sheet from the recut transcript rather than slipping times by hand — there is no drift correction anywhere in the stack.
- **Transcription source.** `npx hyperframes transcribe` gives word-level timings (Parakeet default is an Apple-silicon MLX path, so expect the whisper.cpp fallback on this linux ARM64 host). ASR will frequently "helpfully" normalise a misspoken token to the nearest real word — check this beat by ear before trusting the transcript, and log the restoration.
- **Speaker marking** is CSS on the cue element (an em dash in the text, or a class carrying a colour). Do not invent a speaker name the video never gives.

**ffmpeg.** For a baked deliverable, the gap is simply two SRT/ASS events with non-adjacent timecodes; `-vf "subtitles=track.ass"` renders them. Nothing special is needed — the discipline is in the cue sheet, not the encoder.

**Epidemic Sound.** One comedic transient on the correction: `SearchSoundEffects { query: { term: "record scratch stop comedic" }, filter: { duration: { max: 1200 } } }`, or `"cartoon pop boing"` for a lighter register. Place at −12 to −15 dB on cue B's in-frame; nothing on cue A. See [[sfx-record-scratch-punctuation]] and [[sfx-cartoon-comedy-family]].

**Remotion.** Two `<Sequence>`s with a deliberate frame gap between them. Concept only.

## Pairs with
[[struct-misspeak-correction-gag]] · [[sub-cue-segmentation-three-word]] · [[sub-caption-role-decision]] · [[sub-mixed-script-hinglish-stack]] · [[sfx-record-scratch-punctuation]] · [[sfx-alter-ego-objection-cutaway]] · [[struct-objection-character-cutaway]] · [[struct-presenter-aside-pattern-interrupt]]

## Failure modes
- **Captioning the intended word.** Kills the gag and breaks caption/audio correspondence at the same time. Correction: verbatim, always, for a deliberate error.
- **Merging the misspeak and the correction into one cue.** The beat disappears and the joke reads as a typo. Correction: two cues, 0.30 s of empty zone between them.
- **Emphasising the wrong word.** Colour or size on the misspeak tells the joke before the correction does. Correction: track default style.
- **Adding `[sic]` or a parenthetical.** Broadcast-caption habits that read as an apology on a comedy beat. Correction: nothing but the words.
- **Trusting ASR through the beat.** Transcribers normalise unusual tokens, so the misspeak often survives as the correct word in the transcript. Correction: listen to the beat, restore the spoken token, log the restoration.
- **Verbatim applied to a genuine ASR error.** Shipping a mishearing because "the transcript said so". Correction: the rule covers *speech* errors, not *machine* errors — fix machine errors and log them.
- **Gag placed on an information-carrying beat.** The two seconds either side are lost. Correction: place it in the driest stretch, where nothing must be retained.
- **Known gap.** Nothing in the stack flags a caption that diverges from its audio; there is no forced-alignment check and no confidence score surfaced. Verbatim fidelity is enforced by the design pass's own correction log, which must live in `design-subtitles.md` — and because the vault cannot delete files, that log is append-only and supersedes rather than replaces.
