---
id: sub-mixed-script-hinglish-stack
title: Devanagari captioning is the exception branch — build the two-script stack only when the script is the requirement
skill: subtitles
type: caption-style
family: mixed-script
tags: [skill/subtitles, type/caption-style, family/mixed-script, engine/hyperframes, source/sfx-kt-1, source/research, difficulty/high]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: n/a
    quote: "sfx kt 1 burns in captions like `parr naam kya search karu??` — Latin script, not Devanagari. The subtitles library was briefed to solve script fallback and Devanagari line-height. The real requirement is romanised Hindi set in a Latin face."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:46"
    quote: "But how do we know which BDSM is running on our video? — (interjection) BPM? — Yeah, that."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:05:30"
    quote: "Vocals: -3 to 0 dB. Music: -22 to -25 dB."
research_refs:
  - https://en.wikipedia.org/wiki/Hinglish
  - https://learn.microsoft.com/en-us/typography/script-development/devanagari
  - https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/unicode-range
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
difficulty: high
detectable_from: transcript+video
---

# Devanagari captioning is the exception branch — build the two-script stack only when the script is the requirement

> **Corrected 2026-08-28.** This note previously opened *"Build a two-script font stack before captioning Hinglish"* and treated Devanagari as the default problem for this user. The visual pass over the reference footage shows that is wrong: `sfx kt 1` burns in `parr naam kya search karu??` — **romanised Hindi in Latin script**, no Devanagari anywhere. The default branch is now [[sub-romanised-hinglish-latin-face]]. What follows is the **exception branch**: correct when Devanagari is genuinely required, and not to be applied by default. The earlier framing also mis-cited its source; the transcript header's `Devanagari script` annotation described the transcription, not the burned-in captions.

## What it is

Hinglish speech mixes Hindi and English inside a single sentence, and the technical vocabulary — BPM, reverb, dB, timeline, B-roll — stays English while the grammar around it is Hindi. That much was right, and it remains true.

What was wrong was the assumed **script**. Written Hinglish overwhelmingly uses Latin letters: analysis of YouTube comment data found **52 % romanised Hindi, 46 % English, and 1 % Devanagari**. Devanagari is a rounding error in this register, for a mechanical reason — Roman-script keyboards are ubiquitous on mobile and Indic-script keyboards are not.

So this note now answers a narrower question: **when Devanagari is genuinely the requirement, what does it cost?** Three things, all of which are real and none of which apply to a romanised deliverable:

**A two-family stack bound by `unicode-range`.** One family almost never covers both scripts well. Devanagari at `U+0900–U+097F`, Latin at `U+0000–U+007F`, with `size-adjust` on one of them because the two faces will not agree on apparent size at the same nominal `font-size`.

**Materially more line box.** The shirorekha (head line) sits above the consonant body; above-base matras and reph stack above that; below-base forms and vocalic marks descend beneath the baseline. Latin-only captions run **1.15–1.30**; Devanagari or mixed needs **1.45–1.70**. A Devanagari line at 1.2 is clipping even when the sampled frame looks fine, and `overflow: hidden` hides the evidence.

**Lighter tracking.** The display-size negative tracking that Latin captions need (−0.03 to −0.05 em) collides Devanagari conjuncts and breaks the head line. Devanagari runs −0.01 to −0.02 em, or none.

And one hard project constraint: **no Devanagari face is bundled here**, and Google Fonts is unreachable under the egress allowlist. A licensed local font file must be added before any Devanagari caption can be built at all.

## When to use it

Take this branch only when one of these is true:

- **The audience expects the script.** Formal, institutional, educational or regional-language contexts where Devanagari itself carries register, and romanisation would read as casual or careless.
- **There is an accessibility or localisation obligation** in Hindi specifically. A closed caption track in Hindi should be Devanagari, because it is the written standard and it is what a Hindi-first reader reads fastest.
- **The channel's existing convention is Devanagari** and changing it would be a bigger break than keeping it.

Otherwise take [[sub-romanised-hinglish-latin-face]]. For this user's reference material, the default is romanised.

If you do take this branch: decide once per channel, never mix conventions inside one video, and run this note **before** the cue sheet exists, because segmentation depends on rendered width and rendered width depends on the stack.

## How to recognise it in a reference video

First, establish which branch you are even looking at:

| Signal | Reading |
|---|---|
| Any `क`, `ा`, `्`, `ी` in a caption | Devanagari branch |
| Latin glyphs only, but the words are not English | Romanised branch — go to [[sub-romanised-hinglish-latin-face]] |
| Both scripts in one video | A defect, not a design |

Then, if it is Devanagari:

- **Compare the two scripts' apparent sizes on a mixed cue.** Latin cap height and Devanagari body height should look matched. If one looks two sizes smaller, the stack has no `size-adjust`.
- **Look for boxes or a visibly different fallback face** on any character — a missing `unicode-range` entry or a font that never loaded.
- **Inspect the top of the matras and the bottom of the below-base forms** across a whole line. A shaved head line or a clipped vocalic mark is the most common Devanagari caption defect, and it is silent.
- **Measure line-height as a ratio.** 1.45–1.70 for Devanagari. 1.2 means it is clipping.
- **Compare words-per-cue between scripts.** Devanagari packs more meaning per character, so its CPS cap must be *lower* than English's — the opposite of romanised Hindi, which needs a *higher* one ([[sub-hinglish-reading-rate]]).
- **Check where English tokens fall.** A good segmentation keeps `BPM` with the Hindi word governing it.
- **Check numerals.** Western `100-120` versus Devanagari `१००-१२०` is a deliberate choice; mixed usage in one video is a defect.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `script_policy` | **romanised** | romanised / devanagari+latin | **Corrected default.** Devanagari only when the audience expects the script. |
| `branch_check` | run first | — | If the deliverable is romanised, this note does not apply. |
| `latin_range` | `U+0000-007F` | + `U+0080-00FF` | Basic Latin; extend for accented Latin. |
| `devanagari_range` | `U+0900-097F` | + `U+A8E0-A8FF` | Extended block covers Vedic marks; add only if needed. |
| `font_families` | 2 | 2 | One per script, bound by `unicode-range`. |
| `size_adjust` | measured | 0.9–1.1 | On the Devanagari face, tuned against a mixed test string. Do not guess. |
| `line_height_devanagari` | 1.55 | 1.45–1.70 | Versus 1.15–1.30 Latin-only. |
| `devanagari_size_ratio` | 0.92 | 0.86–1.00 | Devanagari usually matches optically a little smaller. Measure. |
| `padding_top` | 0.18 em | 0.12–0.28 em | For reph and above-base matras. |
| `padding_bottom` | 0.14 em | 0.10–0.22 em | For below-base forms. |
| `overflow_policy` | `visible` | visible | Never `hidden` on a Devanagari line box — clipping is silent. |
| `tracking_devanagari` | −0.015 em | −0.02 to 0 em | Latin's −0.03 to −0.05 em collides conjuncts. |
| `weight` | 700 Latin / 600 Devanagari | — | Devanagari reads heavier at the same nominal weight; drop one step. |
| `reading_rate_cap` | 14 CPS | 12–17 CPS | **Lower** than English. Devanagari carries more per character. Contrast [[sub-hinglish-reading-rate]], where romanised needs a *higher* cap. |
| `max_words_per_cue` | 3 | 1–3 | Validate **rendered width**, not word count. |
| `max_cue_width` | 80 % of frame width | 70–86 % | Hinglish cue widths vary more than English ones. |
| `numeral_convention` | Western digits | western / devanagari | Technical numbers stay Western. Pick one and hold it. |
| `technical_token_policy` | keep English | keep / transliterate | `बीपीएम` for `BPM` is unfamiliar and unsearchable to the audience that came for it. |
| `never_split` | English token + governing word | — | Do not orphan `BPM` onto its own card. |
| `font_availability` | **none bundled** | — | No Devanagari face ships here and Google Fonts is unreachable. A licensed local file is a prerequisite. |
| `shaping_validation` | manual snapshot | — | `check` has no shaping audit. A clipped conjunct passes every automated gate. |

## Reproduction prompt

```
Decide the script branch for the Hinglish caption track in {{PROJECT}}, then
specify it.

STEP 0 — BRANCH CHECK, before anything else. Written Hinglish is overwhelmingly
romanised: about 52% of Hindi-language YouTube comments are romanised Hindi
against 1% Devanagari, and the reference creator burns in romanised captions. The
default branch is ROMANISED — go to sub-romanised-hinglish-latin-face and stop.

Take the Devanagari branch ONLY if one of these holds, and state which: the
audience expects the script and romanisation would read as careless; there is a
Hindi accessibility or localisation obligation; the channel's convention is
already Devanagari.

STEP 1, Devanagari only. Confirm a licensed Devanagari font FILE exists locally.
None is bundled and Google Fonts is unreachable. Without one, stop rather than
emitting a spec that fails at render.

STEP 2. Emit two @font-face rules bound by unicode-range: Latin U+0000-007F,
Devanagari U+0900-097F. Tune size-adjust against a mixed test string — measure,
do not guess.

STEP 3. Set line-height 1.45-1.70, padding-top 0.18em, padding-bottom 0.14em,
overflow: visible. A Latin line-height silently shaves the head line and matras.

STEP 4. Set tracking to -0.015em, not the Latin -0.03 to -0.05em, which collides
conjuncts.

STEP 5. Set the rate cap to 14 CPS — LOWER than English, the opposite correction
from romanised Hindi.

STEP 6. Keep English technical tokens in Latin; never split one from its
governing Hindi word.

Acceptance test: snapshot a mixed cue with matras, a below-base conjunct, an
English token and a numeral. At 200%: no clipped mark, no fallback glyph, both
scripts the same apparent size. There is no shaping audit in `check`.
```

## Execution spec

```css
@font-face {
  font-family: "CaptionLatin";
  src: url("./assets/fonts/Montserrat-Bold.woff2") format("woff2");
  unicode-range: U+0000-00FF;
  font-weight: 700;
  font-display: block;
}
@font-face {
  font-family: "CaptionDeva";
  src: url("./assets/fonts/NotoSansDevanagari-SemiBold.woff2") format("woff2");
  unicode-range: U+0900-097F;
  font-weight: 600;              /* one step down — Devanagari reads heavier */
  size-adjust: 92%;              /* MEASURED against a mixed string */
  font-display: block;
}
[data-composition-id="captions"] .caption-text {
  font-family: "CaptionLatin", "CaptionDeva", sans-serif;
  line-height: 1.55;
  letter-spacing: -0.015em;
  padding-block: 0.18em 0.14em;
  overflow: visible;
}
```

Stack notes:

- **`unicode-range` order does not matter; declaration completeness does.** A character outside every declared range falls through to the generic, silently, in a different face.
- **`size-adjust` must be measured.** Render a string containing both scripts, measure Latin cap height and Devanagari body height, and tune until they match. Guessing produces the "two different sizes" defect that is the branch's signature failure.
- **`document.fonts.ready` gates the build**, and with two faces there are two loads. Register the timeline only after both resolve, or the layout audit measures fallback metrics.
- **There is no shaping validation anywhere in the toolchain.** `check` runs lint, runtime, layout, motion and contrast; none of them look at glyph composition. A clipped conjunct or a broken head line passes every gate. `snapshot --at <cue midpoints>` plus an actual look at the frames is the only check.
- **Everything in [[sub-orthography-protection-no-autocorrect]] still applies.** Devanagari does not exempt the transcript from being verbatim, and Unicode normalisation is if anything more dangerous here: NFC and NFD produce visually identical Devanagari with different byte sequences. Normalise once, at ingest, to NFC.

## Pairs with

- [[sub-romanised-hinglish-latin-face]] — **the default branch.** Read that first.
- [[sub-orthography-protection-no-autocorrect]] — verbatim text, either script
- [[sub-hinglish-reading-rate]] — romanised needs a higher CPS cap; Devanagari a lower one
- [[sub-cue-segmentation-three-word]] — segmentation depends on rendered width
- [[sub-tracking-and-caption-line-height]] — the Latin values this branch overrides
- [[sub-typeface-selection-for-captions]] — the single-family rule this branch is the exception to
- [[sub-line-length-and-line-count]] — validate rendered width, not word count
- [[sub-caption-role-decision]] — an accessibility obligation may force this branch
- [[sfx-translation-check-devices]] — the creator's own bilingual devices
- [[sub-term-definition-lockup]] — technical tokens stay in Latin

## Failure modes

- **Taking this branch by default.** The correction this note exists for. Romanised is the default for this user's material; Devanagari is the exception.
- **One font for both scripts.** One of them falls back to a system face that does not match, and the mismatch reads as a rendering fault.
- **Clipped matras.** A Latin line-height shaves the head line. Silent, and `overflow: hidden` hides the evidence.
- **Guessing `size-adjust`.** Produces the two-different-sizes look that is this branch's signature failure.
- **Latin tracking on Devanagari.** −0.04 em collides conjuncts and breaks the shirorekha.
- **Applying the romanised CPS cap.** Devanagari packs more per character and needs a *lower* cap, not a higher one.
- **Transliterating technical tokens.** `बीपीएम` is unfamiliar and unsearchable to exactly the audience that came for it.
- **Two conventions in one video.** Romanised hook, Devanagari body. One policy per channel.
- **Assuming a Devanagari font is available.** None is bundled and Google Fonts is unreachable. Confirm a local file exists before specifying anything.
- **Trusting `check`.** There is no shaping audit. A broken conjunct passes every automated gate.
- **Normalising Unicode twice at different forms.** NFC and NFD Devanagari look identical and differ in bytes, which breaks the verbatim diff for reasons nobody can see.
