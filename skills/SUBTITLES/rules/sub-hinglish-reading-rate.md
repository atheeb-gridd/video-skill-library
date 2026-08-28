---
id: sub-hinglish-reading-rate
title: Romanised Hinglish reads slower per character — derive the rate cap from syllables, not from CPS
skill: subtitles
type: caption-timing
family: mixed-script
tags: [skill/subtitles, type/caption-timing, family/mixed-script, engine/hyperframes, source/sfx-kt-1, source/research, difficulty/high]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: n/a
    quote: "sfx kt 1 burns in captions like `parr naam kya search karu??` — Latin script, not Devanagari ... word-boundary logic must tolerate non-dictionary tokens."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "The word timestamps in the inlined script array — nothing else. There is no external transcript read at runtime, no audio analysis, no audio.currentTime."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://en.wikipedia.org/wiki/Hinglish
difficulty: high
detectable_from: transcript+video
---

# Romanised Hinglish reads slower per character — derive the rate cap from syllables, not from CPS

## What it is

Reading-speed caps for captions are given in **characters per second**: Netflix allows up to 20 CPS for adult programmes and 17 for children's; DCMP works in words per minute, 130 for lower-level through 160 for upper-level audiences. Both figures were derived from English, and both are unsafe when transplanted onto romanised Hindi. They fail in opposite directions at once, which is why this needs its own note rather than a footnote.

**Characters over-count.** Romanisation spells Hindi phonetically, and the phonetics of Hindi need more Latin letters per syllable than English does. Aspirated consonants take two letters (`bh`, `dh`, `kh`, `th`), long vowels take two (`aa`, `ee`, `oo`), retroflexes are often doubled, and there is no orthographic compression of the kind English gets from silent letters and digraphs standing for single sounds. `karoon` is six characters for two syllables; `search`, in the same sentence, is six characters for one. So a Hinglish line at 20 CPS is carrying materially **less** content than an English line at 20 CPS — the cap is looser than it looks, and applying it verbatim over-holds cues and makes the track feel sluggish.

**Words under-count.** DCMP's words-per-minute figures assume English word lengths. Hindi function words are short (`ke`, `ko`, `se`, `hai`) and content words are long, so word count is a noisier proxy in Hinglish than in English.

**Syllables are the stable unit.** Reading rate in any phonetically-written script tracks syllables far better than characters, and romanised Hindi is close to phonetic, which makes syllables cheap to count: roughly one per vowel group. The practical formulation is:

> Convert the English CPS cap into a **syllables-per-second** cap once, then apply that cap to the Hinglish text.

At English's roughly 3.0 characters per syllable, a 17 CPS cap is about **5.7 syllables/second**. Romanised Hindi runs about 3.6 characters per syllable, so the equivalent character cap is about **20.5 CPS** — meaningfully higher than the English figure, and the reason a naively-transplanted 17 CPS holds Hinglish cues too long.

There is a second effect pulling the other way, and it must not be forgotten. **Code-mixing costs a switch.** A sentence that alternates between Hindi and English imposes a small comprehension cost at each language switch. `parr naam kya search karu??` switches twice. At one or two switches per clause this is negligible; above about three it is not, and the cue should be held longer or split.

## When to use it

- On every romanised Indic caption track, at cue-timing time.
- The derivation is done **once per channel** — measure the transcript's characters-per-syllable ratio and convert the cap — then applied mechanically per cue.
- Recompute if the register changes materially: a heavily English-loaded Hinglish (60 %+ English tokens) behaves close to English and the English cap is fine.
- Not applicable to Devanagari, which has the opposite problem: it packs far more per character and needs a *lower* CPS cap. See [[sub-mixed-script-hinglish-stack]].

## How to recognise it in a reference video

| Measurement | Method | Reading |
|---|---|---|
| Characters per second | Cue character count / cue duration | Compare against the derived cap, not against 17 or 20. |
| Syllables per second | Count vowel groups per cue / duration | The stable metric. 5–7 is a comfortable band. |
| Characters per syllable | Total characters / total vowel groups over the whole transcript | ~3.0 English, ~3.6 romanised Hindi. This ratio is what you convert with. |
| Code-switch count | Language switches per cue | 0–2 is free. 3+ needs extra hold. |
| English token share | English words / total words | Above ~60 % and English caps apply directly. |
| Cue duration floor | Shortest cue | Netflix's minimum event is 5/6 s ≈ 0.83 s. A romanised cue is often *longer* in characters, so this floor binds less often. |
| Cue duration ceiling | Longest cue | Netflix caps an event at 7 s. |
| Feel | Watch it | Cues that clear the derived cap and still feel sluggish usually have a code-switch problem, not a rate problem. |

Counting vowel groups is crude and good enough: a run of one or more of `a e i o u` counts as one, with a small correction for word-final `a` in transliterations that use it as an inherent-vowel marker. Do not reach for a syllabifier — English syllabifiers will fail on exactly these tokens, which is the whole theme of [[sub-orthography-protection-no-autocorrect]].

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `rate_unit` | syllables/second | syllables/s | The stable unit across scripts. |
| `syllable_cap_muted` | 5.7 syll/s | 5.0–6.5 | Derived from a 17 CPS English cap at ~3.0 chars/syllable. |
| `syllable_cap_sound_on` | 9.0 syll/s | 8–11 | Sound-on tolerates far more because the audio carries meaning. |
| `chars_per_syllable_english` | 3.0 | 2.8–3.2 | The conversion constant. |
| `chars_per_syllable_hinglish` | 3.6 | 3.3–4.0 | Measure it on the actual transcript; register varies. |
| `derived_cps_cap_muted` | 20.5 CPS | 18–23 | `syllable_cap × chars_per_syllable`. Higher than the English 17. |
| `derived_cps_cap_sound_on` | 32 CPS | 28–38 | Only valid when the audio carries the meaning. |
| `netflix_cps_reference` | 20 adult / 17 children | — | The English-derived figures. Convert, do not transplant. |
| `dcmp_wpm_reference` | 130 / 140 / 160 | — | Lower / middle / upper level. Word counts are noisier in Hinglish. |
| `code_switch_free_allowance` | 2 per cue | 0–2 | Beyond this, add hold time. |
| `code_switch_penalty` | +0.08 s per extra switch | 0.05–0.15 s | Added to the cue's minimum duration. |
| `min_cue_duration` | 0.83 s | 0.70–1.20 s | Netflix's 5/6 s minimum event. |
| `max_cue_duration` | 7.0 s | — | Netflix's maximum event. |
| `english_share_switch_point` | 60 % | 50–70 % | Above this, use English caps directly. |
| `over_cap_action` | split the cue | split | Never speed-read; never shrink the type. |
| `syllable_counter` | vowel-group heuristic | — | Do **not** use an English syllabifier — it fails on non-dictionary tokens. |

## Reproduction prompt

```
Derive and apply the reading-rate cap for the romanised Hinglish caption track in
{{PROJECT}}, delivered {{muted-first|sound-on}}, given {{TRANSCRIPT}}.

Do not transplant the English caps. Netflix's 20 CPS (adult) and 17 CPS
(children's) came from English orthography. Romanisation spells Hindi
phonetically — aspirates take two letters (bh, dh, kh), long vowels two (aa, ee,
oo) — so romanised Hindi runs ~3.6 characters per syllable against English's 3.0.
A Hinglish line at 17 CPS carries ~20% less content, so the cap is looser than it
looks and applying it verbatim over-holds every cue.

Step 1 — measure the transcript's actual characters-per-syllable ratio, counting
syllables as vowel groups. Do NOT use an English syllabifier: it fails on exactly
these non-dictionary tokens.

Step 2 — convert. Divide the English CPS cap by 3.0 for a syllables-per-second
cap, then multiply by the measured Hinglish ratio for the CPS cap to enforce.
Report all three numbers.

Step 3 — count code switches per cue. Zero to two is free; add 0.08s to the
minimum duration for each switch beyond the second.

Step 4 — apply per cue. Any cue over the derived cap gets SPLIT, not sped up and
not shrunk. Re-check each half against the 0.83s minimum and 7s maximum event
durations.

If English tokens exceed 60% of the transcript, note it and use English caps.

Acceptance test: report per cue the characters, syllables, duration, derived CPS
and syllables-per-second. Zero cues over the cap, under 0.83s or over 7s. Then
watch muted at 1x.
```

## Execution spec

The rate check runs on the word-level transcript array before the timeline is built, which makes it a pure data operation with no browser dependency — important, because the browser-backed audits cannot run on this project's device VM.

```js
const VOWEL_GROUP = /[aeiouAEIOU]+/g;
const syllables = s => (s.match(VOWEL_GROUP) || []).length;

function rateCheck(cue) {
  const dur   = cue.end - cue.start;
  const chars = cue.text.length;
  const syll  = syllables(cue.text);
  return {
    cps:  chars / dur,
    sps:  syll / dur,
    pass: (syll / dur) <= SYLL_CAP && dur >= 0.83 && dur <= 7.0,
  };
}
```

Stack notes:

- **Caption timing comes from the inlined `script` array and nothing else.** There is no runtime audio analysis and no `audio.currentTime` in the staged model. So the rate cap is enforced at build time, on the array, and cannot be adjusted at playback.
- **A cue split changes the timeline**, so re-run line breaking and the fit check afterwards ([[sub-syntactic-line-breaking]], [[sub-line-length-and-line-count]]). Split points must respect the never-split list, which for Hinglish includes an English technical token and its Hindi governing verb — `search karu` must not be split.
- **The word timestamps come from whisper here**, since the Parakeet default is an Apple-silicon MLX stack unavailable on linux ARM64. Whisper's word-level timings on code-mixed speech are noisier than on monolingual English; expect to smooth them. A word whose reported duration is under about 60 ms is almost always a timing artefact rather than a real token boundary.
- **`hyperframes check` has no reading-rate audit.** This is a project-level script, and its result belongs in the **Checks** section of `_templates/design-subtitles.md`.
- Timing is authored in **seconds**, not frames — there is no frame unit in the composition model, and the render default is 30 fps, so 0.83 s is 25 frames.

## Pairs with

- [[sub-romanised-hinglish-latin-face]] — the script finding this timing note depends on
- [[sub-orthography-protection-no-autocorrect]] — why an English syllabifier must not be used
- [[sub-cue-segmentation-three-word]] — the general cue timing model
- [[sub-line-length-and-line-count]] — a split re-opens the fit check
- [[sub-syntactic-line-breaking]] — where a split is allowed to fall
- [[sub-mixed-script-hinglish-stack]] — Devanagari has the opposite ratio problem
- [[sub-caption-role-decision]] — the muted-versus-sound-on decision that sets the cap
- [[pace-speech-rate-to-bpm-map]] — speech rate as a pacing input

## Failure modes

- **Transplanting 17 or 20 CPS.** Over-holds every Hinglish cue by roughly 20 %, and the track feels sluggish for a reason nobody can name.
- **Using an English syllabifier.** It fails on `karu`, `naam`, `parr` — the exact tokens the count is for.
- **Counting words instead of syllables.** Hindi function words are very short and content words are long, so word count is noisy here.
- **Ignoring code switches.** Three or four switches in one cue reads slower than its character count predicts, and the cue looks correctly timed on paper.
- **Applying the sound-on cap to a muted-first deliverable.** The sound-on cap is only legal because the audio carries the meaning. In a feed it usually does not.
- **Splitting at a code-switch boundary.** `search / karu` splits an English token from its Hindi governing verb, which is the worst available split point.
- **Trusting whisper's word timings on code-mixed speech.** Sub-60 ms word durations are artefacts; smooth them before deriving cue boundaries.
- **Deriving the ratio from one paragraph.** Characters-per-syllable varies with register; measure it over the whole transcript.
- **Fixing an over-cap cue by shrinking the type.** Changes the design to solve a timing problem, and the caption visibly changes size mid-video.
