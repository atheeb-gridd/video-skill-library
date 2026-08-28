---
id: sub-romanised-hinglish-latin-face
title: Romanised Hinglish is a Latin-script problem — set it in one Latin face, not a fallback stack
skill: subtitles
type: caption-style
family: mixed-script
tags: [skill/subtitles, type/caption-style, family/mixed-script, engine/hyperframes, source/sfx-kt-1, source/research, difficulty/high]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: n/a
    quote: "sfx kt 1 burns in captions like `parr naam kya search karu??` — Latin script, not Devanagari. The subtitles library was briefed to solve script fallback and Devanagari line-height. The real requirement is romanised Hindi set in a Latin face: no script fallback needed, but nothing may \"autocorrect\" the romanisation, and word-boundary logic must tolerate non-dictionary tokens."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Safe-and-distinctive bundled picks: Montserrat, Oswald, League Gothic, Archivo Black, Space Mono, IBM Plex Mono, JetBrains Mono, Source Code Pro, Noto Sans JP."
research_refs:
  - https://en.wikipedia.org/wiki/Hinglish
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://en.wikipedia.org/wiki/X-height
  - https://www.w3.org/WAI/media/av/captions/
difficulty: high
detectable_from: video
---

# Romanised Hinglish is a Latin-script problem — set it in one Latin face, not a fallback stack

## What it is

**This note corrects a wrong assumption that shaped this library's early design.** The Hinglish requirement was originally scoped as a mixed-script problem: Devanagari plus Latin, needing a two-script font stack, script-specific fallback, and extra line height for matras and reph. The visual pass over the reference footage shows that is not what the creator does. `sfx kt 1` burns in captions like `parr naam kya search karu??` — **romanised Hindi in Latin script**. There is no Devanagari in the captions at all.

That is not an idiosyncrasy, it is the norm. Analysis of YouTube comment data found **52 % romanised Hindi, 46 % English, and 1 % Devanagari** — Devanagari is a rounding error in this register. The cause is mechanical: Roman-script keyboards are ubiquitous on mobile and Indic-script keyboards are not, so a generation of Hindi speakers writes Hindi in Latin letters and has never developed a standard orthography for doing so.

The consequences for caption design are almost the inverse of the Devanagari brief:

**No script fallback is needed, and a fallback stack is now a liability.** Every glyph is Basic Latin. A multi-family stack cannot help and can only hurt — it introduces the possibility of a silent mid-line face swap that changes x-height and colour.

**Line height goes back to normal.** No above-base matras, no below-base conjuncts, no reph. The Latin band of 1.15–1.35 applies, not the 1.45–1.70 that Devanagari needs. A design carrying the Devanagari leading is wasting 20 % of the caption block's height for nothing.

**The hard problems move to text handling.** Romanised Hindi has **no standard spelling**. `parr` / `par` / `pr`; `karu` / `karoon` / `karun`; `kya` / `kyaa`. The creator's spelling is the creator's voice, and it is also what the transcript says. Every layer that might normalise it — an ASR post-processor, a spell-checker, an autocorrect, a "clean up the transcript" LLM pass — is a correctness bug. This is serious enough to have its own note: [[sub-orthography-protection-no-autocorrect]].

**Word-boundary and length logic must tolerate non-dictionary tokens.** Anything that segments, hyphenates, capitalises or line-breaks by consulting an English dictionary will do the wrong thing on `karu`, `naam`, `parr`. Hyphenation is the worst offender and must be off.

**Code-mixing happens mid-sentence, at the word level.** `parr naam kya search karu??` contains one English word — `search` — inside a Hindi clause, in the same face, with no marking. Do not style it differently. Do not treat the sentence as bilingual for the purposes of line breaking; treat it as one clause in one language that happens to borrow.

## When to use it

- Any deliverable whose speech is Hinglish, Tanglish, Benglish or any other romanised Indic register — which for this user is the default case, not the exception.
- The Devanagari branch survives only when the *audience* expects Devanagari: formal, institutional or regional-language contexts where the script itself carries register. It is a deliberate choice, not the default. See the corrected [[sub-mixed-script-hinglish-stack]].
- Pick one policy per channel and hold it. Mixing romanised and Devanagari captions inside one video reads as an error, because the two scripts have different colour on screen.

## How to recognise it in a reference video

| Signal | Method | Reading |
|---|---|---|
| Script | Read any caption frame | Latin glyphs only = romanised. Any `क`, `ा`, `्` = Devanagari. |
| Language of the Latin text | Read it aloud | If it is not English but is in Latin letters, it is romanised Indic. |
| Code-mixing rate | Count English words per Hindi clause | 1–3 per clause is typical Hinglish. |
| English words styled differently | Compare the treatment of `search` to `naam` | Identical = correct. Differently styled = somebody treated it as a foreign word. |
| Line height | Baseline to baseline / font-size on a two-line cue | 1.15–1.35 = correctly Latin. 1.45+ = a Devanagari design applied to Latin text. |
| Orthographic variation | Find the same word in two cues | `parr` in one and `par` in another may be genuine transcript variation. Uniformity may mean something normalised it. |
| Doubled consonants | `parr`, `bhutt` | A romanisation convention marking a short vowel or emphasis. Preserve exactly. |
| Punctuation | `??`, `!!` | Doubled terminal punctuation is a register marker in this style. Preserve. |
| Font fallback artefacts | Look for a mid-line change in x-height or stroke weight | Present = a fallback stack fired, which should be impossible in pure Latin |

The reference caption `parr naam kya search karu??` contains four of these signals at once: pure Latin, a doubled consonant in `parr`, an English word inline with no marking, and doubled terminal punctuation. That single string is the specification.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `script_policy` | **romanised Latin** | romanised / devanagari | Romanised is the default. Devanagari only when the audience expects it. |
| `font_stack_length` | 1 family + generic | 1 | A fallback stack is a liability: it can only introduce a silent mid-line face swap. |
| `unicode_range_needed` | `U+0000-007F` | + `U+0080-00FF` | Basic Latin covers it. Latin-1 only if the copy uses accented characters. |
| `devanagari_range_needed` | none | — | Do not load a Devanagari face for a romanised deliverable. |
| `line_height` | 1.22 | 1.15–1.35 | The Latin band. **Not** the 1.45–1.70 Devanagari band. |
| `padding_top` | 0.25 em | 0.2–0.4 em | Normal Latin padding. No matra clearance needed. |
| `overflow` | `visible` | `visible` | For fit visibility, not for glyph clearance. |
| `spell_check` | off | off | Every romanised token is a non-word. See [[sub-orthography-protection-no-autocorrect]]. |
| `autocorrect` | off | off | Hard requirement. |
| `hyphens` | `none` | `none` | The hyphenation dictionary has no model of these tokens. |
| `text_transform` | CSS only | CSS only | Never uppercase the stored string; it must stay verbatim. |
| `lang_attribute` | `hi-Latn` | `hi-Latn` / `en` | BCP 47 for romanised Hindi. Suppresses locale-driven behaviour and documents intent. |
| `english_token_styling` | identical to surrounding text | identical | `search` inside a Hindi clause is not a foreign word; do not italicise or accent it. |
| `code_mix_rate` | 1–3 English words per clause | — | Typical. Not a problem to be solved. |
| `never_split` | English technical token + its Hindi governing word | — | `search karu` breaks the sense if split across lines. |
| `reading_rate_cap` | see [[sub-hinglish-reading-rate]] | — | Romanised Hindi runs longer per unit meaning than English. |
| `chars_per_line` | English budget × 0.85 | — | Romanisation inflates character counts; budget fewer words per line, not more characters. |

## Reproduction prompt

```
Specify typographic handling for the romanised Hinglish caption track in
{{PROJECT}}, whose transcript is Hindi in Latin script with inline English
borrowing — for example "parr naam kya search karu??".

This is a LATIN-SCRIPT deliverable. Do not build a two-script font stack, do not
load a Devanagari family, do not apply Devanagari line-height. Every glyph is
Basic Latin.

Specify exactly ONE font family plus a generic fallback. A multi-family stack
cannot help — there are no missing glyphs to fall back for — and can hurt, by
allowing a silent mid-line face swap. Choose from the pre-bundled families; a
Google Fonts fetch is a blocked network path.

Set line-height in the Latin band, 1.15-1.35. Set unicode-range to U+0000-007F,
extended to U+00FF only for accented Latin. Set lang="hi-Latn" — the correct BCP
47 tag for romanised Hindi — to document intent and suppress locale behaviour
that assumes English.

Turn OFF spell-check, autocorrect and hyphenation. Romanised Hindi has no
standard orthography — "parr", "par" and "pr" are all valid — so every token is a
non-dictionary word and every correction engine will corrupt it.

Style inline English borrowings IDENTICALLY to the surrounding Hindi. "search"
inside a Hindi clause is not a foreign word.

Budget about 15% fewer characters per line than an English track at the same
size.

Acceptance test: render "parr naam kya search karu?? — B-roll, -3 dB" at caption
size over three sampled frames. Every glyph renders in the one specified family
with no mid-line x-height change; the doubled "rr" and "??" survive. Then diff
rendered textContent against the transcript byte for byte: zero differences.
```

## Execution spec

```html
<span id="caption-text" class="caption-text" lang="hi-Latn"
      spellcheck="false" translate="no"></span>
```

```css
[data-composition-id="captions"] .caption-text {
  font-family: "Montserrat", sans-serif;   /* ONE family. Not a stack. */
  line-height: 1.22;                        /* Latin band, not Devanagari */
  hyphens: none;
  -webkit-hyphens: none;
  white-space: pre-line;                    /* honours explicit \n breaks */
  overflow: visible;
}
@font-face {
  font-family: "Montserrat";
  src: url("./assets/fonts/Montserrat-Bold.woff2") format("woff2");
  font-weight: 700;
  unicode-range: U+0000-00FF;               /* Basic Latin + Latin-1. No Devanagari. */
  font-display: block;
}
```

Notes specific to this stack:

- **`lang="hi-Latn"`** is the BCP 47 tag for Hindi in Latin script. It has no rendering effect on a Latin-only face, and it is worth setting anyway: it documents intent for anyone reading the composition, and it is the correct hook if a future pass adds locale-sensitive behaviour.
- **`translate="no"` and `spellcheck="false"`** are cheap insurance against browser-level or extension-level interference during `preview`, which is an editable Studio surface where a stray correction is possible.
- **The transcript path matters.** `npx hyperframes transcribe` defaults to Parakeet, which is an Apple-silicon MLX stack and therefore unavailable on this project's linux ARM64 device VM; the whisper fallback is what runs. Whisper's Hindi handling will sometimes emit Devanagari and sometimes romanised Latin for the same audio, so the transcription language and script must be pinned explicitly and the output inspected, not assumed. Any Devanagari that comes back in a romanised deliverable is a transcription artefact to be transliterated deliberately and logged, not silently accepted.
- **Every deviation from the ASR output gets logged** in the design doc's correction log, per the skill's verbatim non-negotiable. That log is the only defence against a normalisation creeping in during review.
- **`unicode-range` on the `@font-face` is a guard, not an optimisation.** If any Devanagari does slip into the string, restricting the range makes it render as tofu — visible and fixable — rather than silently falling back to a system face at a different weight.

## Pairs with

- [[sub-orthography-protection-no-autocorrect]] — the text-handling half of this requirement
- [[sub-hinglish-reading-rate]] — how long a romanised cue needs to be held
- [[sub-mixed-script-hinglish-stack]] — the Devanagari branch, now the exception
- [[sub-typeface-selection-for-captions]] — the single-family requirement in context
- [[sub-tracking-and-caption-line-height]] — the Latin leading band
- [[sub-syntactic-line-breaking]] — breaking rules that must not consult a dictionary
- [[sub-line-length-and-line-count]] — the ~15 % character inflation
- [[sub-verbatim-misspeak-correction]] — the same verbatim discipline
- [[sfx-translation-check-devices]] — the creator's own bilingual devices

## Failure modes

- **Building a Devanagari fallback stack for a romanised deliverable.** Solves a problem that does not exist and introduces a silent mid-line face swap that does.
- **Carrying Devanagari line-height into Latin text.** 1.5+ leading on a two-line cue wastes about 20 % of the caption block and pushes it toward the UI band.
- **Any spell-check or autocorrect in the pipeline.** Every romanised token is a non-word. `parr` becomes `part`; `karu` becomes `karma`. See [[sub-orthography-protection-no-autocorrect]].
- **`hyphens: auto`.** The dictionary has no model of these words, so it hyphenates at random.
- **Italicising inline English words.** `search` is not a foreign word in this register; marking it is a category error that also burns the emphasis code.
- **Assuming the ASR emits one script consistently.** Whisper will mix Devanagari and Latin for the same speaker. Pin it and inspect the output.
- **Applying English character budgets.** Romanisation is phonetic and runs longer; the same meaning takes ~15 % more characters.
- **Normalising spelling for consistency.** `parr` and `par` in two cues may both be what was said. The creator's romanisation is the creator's voice.
- **Treating a code-mixed sentence as two languages for line breaking.** It is one clause. Break it on its own syntax, and never between an English token and its Hindi governing verb.
