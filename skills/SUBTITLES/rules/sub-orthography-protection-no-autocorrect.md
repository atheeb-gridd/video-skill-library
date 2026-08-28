---
id: sub-orthography-protection-no-autocorrect
title: Nothing in the pipeline may correct the spelling — romanised tokens are not misspellings
skill: subtitles
type: caption-style
family: mixed-script
tags: [skill/subtitles, type/caption-style, family/mixed-script, engine/hyperframes, source/sfx-kt-1, source/research, difficulty/high]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: n/a
    quote: "nothing may \"autocorrect\" the romanisation, and word-boundary logic must tolerate non-dictionary tokens."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: n/a
    quote: "sfx kt 1 burns in captions like `parr naam kya search karu??`"
research_refs:
  - https://en.wikipedia.org/wiki/Hinglish
  - https://www.w3.org/WAI/media/av/captions/
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
difficulty: high
detectable_from: transcript+video
---

# Nothing in the pipeline may correct the spelling — romanised tokens are not misspellings

## What it is

Romanised Hindi has **no standard orthography**. `parr`, `par` and `pr` are all legitimate spellings of the same word; so are `karu`, `karoon` and `karun`. The absence of a standard is structural rather than accidental — it exists because Roman-script keyboards are what people have and Indic-script keyboards are not, so the writing convention grew from typing practice rather than from a spelling authority. Sixty years of standardisation never happened, and it is not going to.

Every one of those tokens is, to any English-language tool, a misspelling. So every layer of a modern content pipeline that touches text will try to fix it:

- **ASR post-processing** — the language-model pass that "cleans up" a raw transcript
- **Spell-check** in an editor, a CMS, or a browser field
- **Autocorrect** on any mobile or OS-level input path
- **An LLM pass** asked to "tidy the transcript" or "fix obvious errors"
- **A translation or localisation step** that detects the language as English and normalises
- **Smart quotes and smart dashes** that rewrite `??` or an inline hyphen
- **Title-casing** applied to a proper-noun heuristic that has never seen `naam`

Each of these is individually reasonable and collectively catastrophic, because the failure is **silent and plausible**. `parr` becoming `part` produces a real English word in a grammatical position; nobody reviewing the video will notice, and the caption now says something the speaker did not say. Compare that with a missing glyph, which is obvious.

This is a hard correctness requirement, not a style preference. The skill's own non-negotiable is *"Verbatim text. Match the transcript. Correct only clear ASR errors, and log the correction."* A romanised spelling is never a clear ASR error. It is the transcript.

The corollary is that **word-boundary and length logic must tolerate non-dictionary tokens**. Anything that segments, hyphenates, capitalises or breaks lines by consulting a dictionary will behave badly on tokens that are not in it — and it will do so in a way that looks like a layout bug rather than a language bug, which sends the fix in the wrong direction.

## When to use it

Every romanised-Indic deliverable, applied as a **pipeline audit** rather than as a styling decision. The check is: enumerate every stage between the microphone and the rendered frame, and for each one, name what it does to text.

Also apply it to:

- **Any transcript with proper nouns, product names or technical tokens.** `HyperFrames`, `Epidemic`, `B-roll`, `−3 dB` are all non-dictionary and all corruptible by the same mechanisms.
- **Deliberate misspeaks.** [[sub-verbatim-misspeak-correction]] depends on the wrong word surviving verbatim to the screen. An autocorrect destroys the gag before anyone sees it.
- **Any transcript that has passed through an LLM.** Assume normalisation happened and diff it.

## How to recognise it in a reference video

The signal is uniformity where variation should exist.

| Signal | Method | Reading |
|---|---|---|
| Same word, two spellings across cues | Search the caption text for a frequent Hindi token | Variation is *normal* and probably authentic. Perfect uniformity across 40 instances is suspicious. |
| Real English words in Hindi positions | Read the captions for words that are English but grammatically wrong | `part` where `parr` belongs. The signature of autocorrect. |
| Doubled consonants preserved | `parr`, `bhutt`, `acchha` | Preserved = untouched. Singularised = normalised. |
| Doubled terminal punctuation | `??`, `!!` | Preserved = untouched. Reduced to one = a punctuation normaliser ran. |
| Smart quotes | `'` vs `'` | Curly quotes in a burned-in caption mean a text pipeline rewrote the string. |
| Title case on Hindi words | `Naam Kya Search Karu` | A capitalisation heuristic fired. |
| Caption vs audio | Listen and read simultaneously on 10 cues | Any divergence is the whole finding |
| Hyphenation at a line break | A hyphen at a right edge | `hyphens: auto` fired on a token it cannot analyse |

The **caption-versus-audio** check is the only one that is definitive, and it is cheap: play ten cues and read along. Everything else is circumstantial.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `spellcheck_attribute` | `false` | false | On the caption element, explicitly. |
| `translate_attribute` | `no` | no | Blocks browser and extension translation from rewriting the node. |
| `autocorrect` | off at every stage | off | Editor, OS, CMS, browser. Enumerate the stages. |
| `asr_post_processing` | raw output only | raw | Use the raw word-level transcript. A "cleaned" transcript is already corrupted. |
| `llm_transcript_pass` | forbidden | forbidden | If one is unavoidable, diff every token and log every change. |
| `smart_punctuation` | off | off | `??` must survive; `--` must not become an em dash. |
| `title_casing` | off | off | No capitalisation heuristic touches the string. |
| `hyphens` | `none` | none | The dictionary cannot analyse these tokens. |
| `text_transform` | CSS only | CSS only | `text-transform: uppercase` changes the render, not `textContent`. Uppercasing in JS destroys the record. |
| `unicode_normalisation` | NFC, once, at ingest | NFC | Normalise once at ingest and never again; a second normalisation at a different form silently changes bytes. |
| `protected_token_list` | maintained | — | Proper nouns, product names, technical tokens, deliberate misspeaks. |
| `correction_log` | required | — | Every deviation from ASR output, with a reason, in `design-subtitles.md`. |
| `verification` | byte diff | byte diff | Rendered `textContent` vs transcript source. Not a visual check. |
| `allowed_corrections` | clear ASR errors only | — | A genuinely mis-heard word. Never a spelling variant. |
| `variation_is_signal` | yes | — | Two spellings of one word across cues is probably authentic, not an error to reconcile. |

## Reproduction prompt

```
Audit and lock the text path for the caption track in {{PROJECT}}, whose
transcript is romanised Hinglish — Hindi in Latin script, with no standard
orthography.

Step 1 — enumerate every stage between the audio and the rendered frame and state
what each does to text: ASR and post-processing, transcript storage and editing
surfaces, any LLM pass, the build, the browser at preview, the render.

Step 2 — for every stage that can modify text, disable the modification and say
how: spell-check off, autocorrect off, smart punctuation off, title-casing off,
hyphenation none, translation blocked. On the caption element set
spellcheck="false" and translate="no".

Step 3 — use the RAW word-level ASR output. A "cleaned up" transcript is already
corrupted, and invisibly so, because it produces real English words in
grammatical positions: "parr" becomes "part" and no reviewer catches it. If an
LLM pass is unavoidable, diff every token and log every change with a reason.

Step 4 — build the protected-token list: every romanised Hindi word, proper noun,
product and tool name, technical token (B-roll, -3 dB, BPM), and every deliberate
misspeak the edit depends on.

Step 5 — do case changes in CSS with text-transform, never on the stored string,
which must stay byte-identical to the transcript.

Acceptance test: extract rendered textContent for every cue and diff byte for
byte against the transcript source — zero differences, or one logged correction
per difference. Play ten cues reading along with the audio. Then grep for curly
quotes, em dashes and single terminal question marks where the source had
doubles: any hit means a normaliser is still live.
```

## Execution spec

```html
<span id="caption-text" class="caption-text"
      lang="hi-Latn" spellcheck="false" translate="no"></span>
```

```js
// textContent, not innerHTML. The verbatim string goes in unmodified.
textEl.textContent = line.text;          // exactly as transcribed
```

```css
[data-composition-id="captions"] .caption-text {
  hyphens: none;
  -webkit-hyphens: none;
  text-transform: none;      /* set to uppercase here if needed — never in JS */
  white-space: pre-line;     /* explicit \n breaks, string still verbatim */
}
```

Why `pre-line` matters here specifically: it is the only way to control line breaking while keeping the string in `textContent`. Switching to `innerHTML` with `<br>` means the string in the DOM is no longer the transcript, so the byte-diff verification loses its reference point. If markup is genuinely required — for a semantic emphasis span or a strikethrough — keep the raw transcript string alongside the marked-up version and diff against the raw one.

Further stack notes:

- **The transcript is inlined into the composition** as a `script` array of `{text, start, end}`. That inlined array is the verbatim record and the thing to diff against. It is also the thing an LLM asked to "tidy this file" will happily rewrite.
- **`npx hyperframes transcribe` runs whisper here**, because the Parakeet default is an Apple-silicon MLX stack and this project's device VM is linux ARM64. Whisper applies its own light normalisation and will sometimes emit Devanagari for Hindi audio. Pin the language and script, and inspect rather than assume.
- **`preview` is an editable Studio surface.** A user can hand-edit text there before rendering. That is a feature, and it is also a place a browser-level autocorrect can fire — hence `spellcheck="false"` and `translate="no"` on the element rather than relying on process discipline.
- **The vault cannot delete files.** Correction logs and transcript versions accumulate as superseding files with an updated index, not as overwrites. That is fortunate here: the history is the audit trail.
- **Normalise Unicode once, at ingest, to NFC.** A second normalisation at a different form later changes bytes without changing appearance, which will make the byte-diff verification fail confusingly.

## Pairs with

- [[sub-romanised-hinglish-latin-face]] — the typographic half of this requirement
- [[sub-hinglish-reading-rate]] — timing for tokens no dictionary knows
- [[sub-verbatim-misspeak-correction]] — a gag that this note protects
- [[sub-syntactic-line-breaking]] — breaking rules that must not consult a dictionary
- [[sub-caption-role-decision]] — the verbatim non-negotiable
- [[sub-mixed-script-hinglish-stack]] — the Devanagari branch, same discipline
- [[sub-weight-case-and-optical-size]] — why case changes happen in CSS
- [[sub-speaker-and-non-speech-annotation]] — annotations are the one text that is *not* transcript

## Failure modes

- **An LLM "cleanup" pass on the transcript.** The single highest-risk stage. It produces fluent, plausible, wrong text and nobody catches it because it reads perfectly.
- **`parr` → `part`.** A real word, grammatically placed, completely wrong. This is the canonical failure and it is invisible in review.
- **Normalising spelling variation for consistency.** The variation is probably what was said. Uniformity is the anomaly, not the goal.
- **Smart punctuation.** `??` reduced to `?` removes a register marker; straight quotes curled changes the burned-in glyphs.
- **Uppercasing the string in JS.** Destroys the verbatim record and the correction log's reference point. Use `text-transform`.
- **`hyphens: auto`.** Hyphenates at positions with no linguistic meaning, and it looks like a layout bug.
- **Verifying visually instead of by diff.** A human reading a caption in a language they read fluently will not notice `part` for `parr`. The byte diff will.
- **Assuming the ASR output is raw.** Many pipelines apply a language-model pass by default. Check.
- **Normalising Unicode twice at different forms.** Bytes change, appearance does not, and the diff fails for a reason nobody can see.
- **No protected-token list.** Product names and technical tokens are corrupted by exactly the same mechanisms and nobody thinks to check them.
