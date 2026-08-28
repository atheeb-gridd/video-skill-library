---
id: sub-term-definition-lockup
title: Put the term on screen, not the definition
skill: subtitles
type: caption-style
family: teaching-type
tags: [skill/subtitles, type/caption-style, family/teaching-type, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:29"
    quote: "The cut is an instant switch between one shot to another, including audio. You would have seen thousands of these, as it's the most popular cut style of them all."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:17"
    quote: "The match cut is a cut that matches action, shape, colour, framing or even audio of two shots, seamlessly bringing the viewer into the next scene."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://developer.mozilla.org/en-US/docs/Web/CSS/text-wrap-style
  - https://tech.ebu.ch/docs/r/r095.pdf
difficulty: medium
detectable_from: transcript+video
---

# Put the term on screen, not the definition

## What it is
Instructional list videos run a three-beat cadence per item: **name** the thing, **define** it in one sentence, **demonstrate** it with a recognisable clip. The text layer's job is to serve that cadence without duplicating it, and the rule that falls out is narrow and useful: **caption the term, not the definition**. The term is a label the viewer will need for the rest of the section and often cannot spell from hearing it once; the definition is a full spoken sentence that the demonstration is about to make redundant. Setting the whole definition as type competes with the demonstration clip for the same second of attention and reproduces, word for word, audio the viewer is already receiving.

The executable object is a two-part lockup: the **term** at heading size, held across the naming beat and into the definition; and optionally a **stripped definition line** underneath at body size — the definition compressed to a single clause of five to nine words, in the presenter's own vocabulary, that persists into the demonstration. The full definition sentence never goes on screen. The editorial structure this serves lives in [[struct-name-define-demonstrate]]; the numbering that usually wraps it lives in [[sub-list-marker-caption-lockup]].

## When to use it
- Any explainer beat where a term is **named and then defined** — detectable in the transcript as `The X is …`, `X is when …`, `This is called X`.
- Any beat introducing **vocabulary the viewer will have to hold** for later items (the framework names, the taxonomy items, the acronyms).
- Where the term is **hard to spell or hear** — jargon, loanwords, proper nouns, acronyms. This is the strongest case: type is doing something audio cannot.
- **Definition line on** when the demonstration clip is long (>6 s) or ambiguous, and a viewer arriving mid-clip needs an anchor. **Definition line off** when the demonstration is self-evident, or the clip is under ~4 s.
- **Do not** run one for a term the video uses once in passing, and do not run one on the same beat as a full-frame topic card ([[sub-single-word-topic-card]]) — two display-size text objects in one beat is one too many.

## How to recognise it in a reference video
- **Transcript pattern.** Find `is a`, `is when`, `is called`, `this means` within 3 s of a spoken item marker. That window is where the lockup should be.
- **Term-on-screen ratio.** Count named terms in the transcript, count how many appear as on-screen type. A teaching profile that reinforces terms hits **80–100 %**; a profile that does not is a different (and weaker) design and should be logged as such.
- **Compare the on-screen text with the spoken definition word for word.** If the screen carries the full sentence, log it as the failure this note names. If the screen carries a compressed clause of **5–9 words** that is not verbatim, that is the stripped-definition form and it is deliberate.
- **Hold across beats.** The term usually enters at the naming beat and persists **2–5 s**, surviving into the first seconds of the demonstration clip. If it exits before the demonstration starts, the lockup is decorative rather than structural.
- **Size relationship.** Term at **5–9 % of frame height**, definition line at **2.5–4 %**, ratio roughly 2:1. A definition line set at the same size as the term reads as two headlines.
- **Line count.** The definition line should be one line, or two balanced lines — never three. Netflix caps a subtitle event at two lines with a bottom-heavy break; the same discipline applies here.
- **Position.** Almost always upper-left or lower-left, out of the caption band. If it is in the caption band, check whether the running track is suppressed.
- **Entrance stagger.** Term first, definition 0.08–0.20 s behind it, both from the same direction. Simultaneous arrival is a template tell.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `term_words` | 2 | 1–4 | The label only. "THE MATCH CUT", not "the match cut is a cut that…". |
| `definition_words` | 7 | 5–9 | Compressed clause, not the spoken sentence. Above 9 it becomes a subtitle. |
| `definition_line` | on | on / off | Off when the demonstration is under 4 s or self-evident. |
| `term_size` | 6 % of frame height | 5–9 % | 65–97 px at 1080p. In-feed headline floor ≥90 px. |
| `definition_size` | 3 % of frame height | 2.5–4 % | 32 px at 1080p is the in-feed body floor — do not go under it for in-feed. |
| `size_ratio` | 2.0× | 1.6–2.6× | Term to definition. |
| `in_offset_vs_term_onset` | −0.10 s (−3 f) | −0.25 to 0 s | The type is up as the presenter says the word. |
| `hold` | 3.5 s | 2.0–5.0 s | Must survive into the demonstration; exit before the next item marker. |
| `definition_lag` | 0.12 s | 0.08–0.20 s | Stagger behind the term. Total arrival under 0.5 s. |
| `entrance` | y 18 px → 0 | 12–24 px | 0.30 s `power3.out`. Opacity on its own 0.20 s `power2.out` tween. |
| `exit` | opacity → 0 | — | 0.20 s `power2.in`; exits shorter than entrances. |
| `alignment` | left | left / centre | Left-aligned reads as reference material; centred reads as a title. |
| `zone` | upper-left, 62 % of frame height | 55–75 % | Out of the caption band, inside the 5 % graphics safe inset. |
| `case` | term UPPER, definition sentence | — | All-caps stops working past ~4 words. |
| `terms_per_video` | one per item | — | If two terms are named in one beat, lock up the one the section is named after. |

## Reproduction prompt

```
Build term lockups for this explainer. One per named term.

1. FIND THE TERMS. In the transcript, locate every definition pattern ("X is
   a", "X is when", "this is called X") within 3s of an item marker. Record
   term_onset (onset of the term's first word) and the term verbatim, trimmed
   to <= 4 words.
2. COMPRESS THE DEFINITION. Write a clause of 5-9 words using only vocabulary
   the presenter actually speaks in that beat. Do NOT transcribe the spoken
   definition sentence and do NOT invent terminology. If you cannot get under
   10 words without adding a word the presenter did not say, ship the term
   alone with no definition line.
3. SET IT. Term uppercase at 0.06 * frame_height, weight 800, tracking
   -0.03em. Definition sentence-case at 0.03 * frame_height, weight 400-500,
   one line or two balanced lines, never three. Left-aligned, block anchored at
   0.62 * frame_height from the bottom, inside a 5% inset on every edge.
4. TIME IT. in = term_onset - 0.10s. Term enters y 18px -> 0 over 0.30s ease
   power3.out with opacity 0 -> 1 over 0.20s ease power2.out on a separate
   tween. Definition repeats both tweens 0.12s later. Hold 3.5s from in, then
   both exit on opacity over 0.20s ease power2.in.
5. PROTECT THE DEMONSTRATION. The lockup must still be on screen when the
   demonstration clip starts, and must be gone before the next item marker.
   If the demonstration clip carries its own burned-in text, exit at the cut.

ACCEPTANCE TEST: no on-screen string appears verbatim in the spoken definition
sentence beyond the term itself. Every named term in the transcript has
exactly one lockup. Freeze during each demonstration clip: the term is
readable and the definition, if present, is <= 2 lines. Read the definition
aloud - it must take under 2.5 seconds.
```

## Execution spec

**HyperFrames.** One `div` clip per term (`data-start` and `data-duration` are both required on a `div`), with the term and definition as inner non-clip elements so they can be staggered.

```html
<div id="term-03" class="clip" data-start="77.10" data-duration="3.90"
     data-track-index="5">
  <div class="term-lockup">
    <div class="term">THE MATCH CUT</div>
    <div class="def">matches action, shape or sound across two shots</div>
  </div>
</div>
```

```js
const T = 77.10;                       // term onset − 0.10s
tl.fromTo("#term-03 .term", { y: 18 }, { y: 0, duration: 0.30, ease: "power3.out" }, T);
tl.fromTo("#term-03 .term", { autoAlpha: 0 }, { autoAlpha: 1, duration: 0.20, ease: "power2.out" }, T);
tl.fromTo("#term-03 .def",  { y: 18 }, { y: 0, duration: 0.30, ease: "power3.out" }, T + 0.12);
tl.fromTo("#term-03 .def",  { autoAlpha: 0 }, { autoAlpha: 1, duration: 0.20, ease: "power2.out" }, T + 0.12);
tl.to("#term-03 .term-lockup", { autoAlpha: 0, duration: 0.20, ease: "power2.in" }, T + 3.50);
```

Contract points:
- **Prefer `stagger` over hand-delayed tweens** where the lockup has three or more parts; the rules contract caps an arrival at `items × stagger ≤ ~0.5 s` so it reads as one beat, and stagger order follows importance, not DOM order.
- **Transform and opacity on separate tweens** — a settling curve belongs on transforms only.
- **`fromTo`, never `from`.** `from()` writes its start state at construction with `immediateRender: true`, before the clip's `data-start` is active.
- **`y`, not `top`.** `width`/`height`/`top`/`left` tweens are forbidden. No CSS `transform` on the same elements, or lint raises `gsap_css_transform_conflict`.
- **`autoAlpha` on inner elements only**, never on the `.clip`.
- **Exit lands before `data-duration`** — half-open window: `3.50 + 0.20 = 3.70 < 3.90`.
- **Two balanced lines:** `text-wrap: balance` balances a short block (Chromium ≤6 lines, Firefox ≤10) and is the cheapest way to avoid an orphan word on line two. Give the definition an explicit `max-width` in `ch` as well — the reference caption file's `white-space: nowrap` + `overflow: hidden` pattern would silently clip a definition line, so do not inherit it here.
- **Structure the lockup as a `<div>` per line, never a `<br>`** — `<br>` in body text is banned.
- **`studio_missing_editable_id`** is a warning on any non-media timed element without an `id`; give every lockup one, and keep ids unique across the **assembled** page (prefix with the composition id).
- **Fonts:** two weights of one bundled family is the right register here (term 800, definition 400–500). On dark plates drop the body weight to 350 and add 0.05–0.1 to line-height. Google Fonts is unavailable under the egress allowlist; use bundled families or a local `@font-face`. `Inter` is bundled but on the banned-monoculture list.
- **GSAP local, not CDN.**
- Where the video is planned as a storyboard, each item is a `## Frame N` with the term in the `scene` key and the hold in `duration` — the natural place for the design pass to write these.

**ffmpeg.** Not appropriate: a two-part staggered lockup cannot be expressed in `drawtext` without two filters and manual `enable` windows, and it would then be baked. Keep it in the composition.

**Epidemic Sound.** Optional, and quieter than the item marker's hit — a soft appearance transient: `SearchSoundEffects { query: { term: "soft ui appear whoosh short" }, filter: { duration: { max: 600 } } }` at −15 to −18 dB. If the lockup shares a beat with a numbered marker, only the marker gets a sound.

**Remotion.** A `<Sequence>` per term with two `interpolate()` pairs offset by the stagger in frames. Concept only.

## Pairs with
[[struct-name-define-demonstrate]] · [[sub-list-marker-caption-lockup]] · [[sub-single-word-topic-card]] · [[sub-safe-area-and-caption-zone]] · [[sub-caption-role-decision]] · [[struct-demo-before-label]] · [[struct-recognisable-clip-evidence]] · [[motion-progressive-information-build]]

## Failure modes
- **The whole definition sentence set as type.** Duplicates the audio, competes with the demonstration clip, and forces a three-line block. Correction: 5–9 word compressed clause, or the term alone.
- **Inventing vocabulary in the compression.** A definition line using words the presenter never says creates a second, conflicting terminology. Correction: compress using only spoken words.
- **Lockup exits before the demonstration.** The viewer sees the clip with no label, which is the exact confusion the cadence exists to prevent. Correction: hold into the clip, exit before the next marker.
- **Term and definition at the same size.** Two headlines, no hierarchy. Correction: 2:1 ratio.
- **Simultaneous arrival.** Reads mechanical. Correction: 0.12 s stagger, term first.
- **Lockup in the caption band with the track running.** Three text objects in one band. Correction: place at 62 % of frame height per [[sub-safe-area-and-caption-zone]].
- **A lockup for every noun.** Once every term is labelled, none of them is marked. Correction: one per item, and only for terms the video reuses.
- **Known gap.** Nothing in the stack detects definition patterns; the term list is produced by the analysis pass from the transcript. Compressing a definition is a judgement call an unattended agent gets wrong more often than it gets the timing wrong — when in doubt, ship the term alone.
