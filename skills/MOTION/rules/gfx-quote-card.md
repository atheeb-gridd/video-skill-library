---
id: gfx-quote-card
title: The quote card — the measure, the hanging mark, and the attribution that is not part of the quote
skill: motion
type: type-motion
family: graphic-components
tags: [skill/motion, type/type-motion, family/graphic-components, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt-3, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "visual — contact sheet, cold open"
    quote: "[NOT SPOKEN — observed on screen] The video opens on a YouTube comment screenshot — the request that motivated the video, shown as somebody else's words."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, attribution"
    quote: "[NOT SPOKEN — observed on screen] Every film clip labelled top-left in small italic serif — The Departed, Forrest Gump — a separate metadata register from the body type."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:02"
    quote: "Using captions to fill more space can get ugly fast and waste a great opportunity to put something more engaging on screen."
research_refs:
  - https://legibility.info/rules-for-text-in-videos
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://uxdesign.cc/legibility-how-to-make-text-convenient-to-read-7f96b84bd8af
  - https://edtechuvic.ca/wp-content/uploads/sites/11/2022/09/principles-for-reducing-extraneous-processing-in-multimedia-learning-coherence-signaling-redundancy-spatial-contiguity-and-temporal-contiguity-principles.pdf
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
difficulty: medium
detectable_from: transcript+video
---

# The quote card — the measure, the hanging mark, and the attribution that is not part of the quote

## What it is

The one component where **prose on screen is the content**, so the redundancy prohibition does not apply — but only because the words belong to **somebody who is not the narrator**. That is the whole licence, and it is narrow.

A quote card carries the REFERENT payload: the referent is *a person's actual words*. It is evidence, and its value is that the viewer sees the wording rather than being told about it. A narrator's own sentence set large is not a quote card; it is a statement card, and it has a different note, a different word ceiling and a different frequency limit ([[gfx-full-frame-statement-card]]).

**Three objects, and the third one is the one people get wrong:**

| Object | Content | Type step | Rule |
|---|---|---|---|
| **The quote** | The words, verbatim | `s0`–`s1` at 9:16, `s2`–`s3` at 16:9 | Never edited without a marked ellipsis |
| **The mark** | A hanging `“`, or nothing | 2.5× the quote's size, or absent | Optically hung outside the measure |
| **The attribution** | Who said it, and where | `s-1`, in `--ink-dim` | **Not in quotes. Not the same weight. Not on the same line.** |

**The measure is the constraint, and at 9:16 it is brutal.** Published video-text guidance caps a line at **30 characters** and a block at **3 lines**, which is a hard ceiling of about **90 characters**. Then the frame arithmetic bites: at 1080 wide with 6 % margins the content is `950 px`, and a grotesque's average character advance is about `0.5 em`, so

| Step | Font px @1920 tall | Characters per line |
|---|---|---|
| `s3` (8.79 %) | 169 | **11** — unusable for a quote |
| `s2` (7.03 %) | 135 | 14 |
| `s1` (5.63 %) | 108 | 17 |
| `s0` (4.50 %) | 86 | **22** |

So a 9:16 quote is set at `s0` or `s1`, three to four lines, **90 characters maximum**. A 16:9 quote at `s2` gets 25 characters a line and can run to five lines comfortably. **A quote card is not a place for big type**, which is counter-intuitive and is the reason most of them fail: the designer reaches for the display step, gets eleven characters a line, and the quote turns into a column of fragments.

**The dwell is the other reason quotes are expensive.** At the published minimum dwell of **1 second per 13 characters**, a 90-character quote needs **6.9 seconds** stationary — and ×2.5 if a caption is live, which is 17 seconds and unaffordable. **A quote card almost always requires the caption to be suppressed or shortened for its window** ([[gfx-attention-budget-simultaneity]]), and that suppression is legitimate precisely because the graphic contains the words ([[sub-caption-graphic-collision]]).

**The attribution is not part of the quote and must not look like it.** Same size as the quote and it reads as the last line of the quote. In quotes and it reads as somebody quoting somebody. The house form is `s-1` in `--ink-dim`, on its own line, offset by an em dash or by nothing, at the **0.64 secondary ratio** — the same ratio the lower third uses, for the same reason. When the source is a film, a video or another creator, the metadata register already exists in this library: **small italic serif**, which is the third face in the closed set ([[motion-type-treatment-matches-content]], [[motion-attribution-label-inset-clip]]).

**The hanging mark, if used, hangs.** A `“` set inline pushes the first line's left edge right by the width of the mark, and the quote's left margin no longer aligns with anything else in the video. Hang it outside the measure — `text-indent: -0.55em` on the block, or a positioned glyph — or leave it out. A decorative 66 at display size sitting *above* the quote is a third object competing with the two that matter; if it is bigger than 2.5× the quote it has become the graphic.

**Verbatim, or marked.** A quote edited silently is a fabrication. Cuts are marked with `…`, insertions with `[brackets]`, and if the quote is a screenshot of a real comment or post, prefer the screenshot with an annotation mark — the observed cold-open device — because the credibility comes from it being real ([[gfx-annotation-mark-set]], [[struct-comment-screenshot-cold-open]]).

## When to use it

- **Somebody else's words are the evidence**: a comment, a review, a post, a line from a film, a source's sentence.
- **The wording matters** — a claim whose exact phrasing is the point, or a line whose tone is the point.
- **A cold open on a real request**, the observed device: the video opens on the comment that motivated it.
- **Not** for the narrator's own thesis. That is a statement card.
- **Not** for a paraphrase. If it is not verbatim it is not a quote, and setting a paraphrase in quotation marks is a fabrication.
- **Not** more than **once or twice per video**. It is a full-frame, high-dwell object.
- **Not** when the real artefact is available and would be better. A screenshot of the actual comment beats a retyped quotation, and the difference is credibility.

## How to recognise it in a reference video

- **Count characters per line.** Measure the text block's width and the cap height, derive font size, and compute. **12–25** is designed; under 12 means the type is too large for the measure and the quote is fragmenting.
- **Count total characters.** ≤90 at 9:16, ≤160 at 16:9. Beyond that, check the dwell — it will not have been paid.
- **Measure the dwell against `chars ÷ 13`.** A 90-character quote held for 3 seconds was not read. This is the commonest quote-card failure and it is arithmetic, not opinion.
- **Check whether the caption stops.** In competent work the caption track shortens or is suppressed across a quote card. If a full caption runs under a quote, two READ objects are live and neither is read.
- **Check the attribution's size ratio.** `attribution ÷ quote` around **0.64** (0.55–0.75). Equal sizes means the attribution reads as the quote's last line.
- **Check the attribution's colour and weight.** Dimmed and same-weight is house; bold and same-size is a mistake; italic serif is the metadata register and is a deliberate, logged choice.
- **Check the mark.** Hanging outside the measure ⇒ designed. Inline ⇒ the first line's left edge is out by half an em and every other left-aligned object in the video disagrees with it.
- **Check for ellipses and brackets.** Their presence is a sign of editorial honesty; their absence in a long quote from a spoken source is suspicious.
- **Check line breaking.** Breaks at syntactic boundaries, not at the box edge. A quote broken mid-phrase reads as a text box rather than as a composition ([[sub-syntactic-line-breaking]]).
- **Check the entrance.** A quote is read, not performed: a whole-block fade-and-rise over 0.5–0.8 s, or a per-line stagger at 0.12 s. Per-word kinetic typography on somebody else's sentence is a genre signal for a different, louder channel — log which you saw.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `quote_step_9x16` | `s0` (4.5 % of frame height) | `s0`–`s1` | 22 characters a line at `s0`, 17 at `s1`. |
| `quote_step_16x9` | `s2` (7.03 %) | `s2`–`s3` | ~25 characters a line. |
| `chars_per_line` | 22 | 12–30 | Published ceiling 30. Under 12 the quote fragments. |
| `lines` | 3 | 2–4 | Published ceiling 3 for on-screen text; 4 is the outside limit for a quote. |
| `total_chars` | ≤90 (9:16) / ≤160 (16:9) | — | Derived from lines × chars-per-line. |
| `dwell` | `chars ÷ 13` s | ≥3.0 s | Published minimum dwell: 1 s per 13 characters, **stationary**. |
| `dwell_under_caption` | ×2.5 | — | Usually unaffordable, which is why the caption is suppressed instead. |
| `caption_policy` | suppress or shorten to ≤3 words | — | Legitimate because the graphic carries the words. |
| `line_height` | 1.25 | 1.15–1.35 | Add 0.05–0.10 on a dark ground. |
| `tracking` | −0.02 em | −0.01 to −0.03 em | Lighter than display tracking; a quote is read, not glanced. |
| `alignment` | left, ragged right | left | Never justified — video has no hyphenation control worth using. |
| `line_breaking` | syntactic | — | At phrase boundaries, not at the box edge. |
| `widow` | ≥2 words on the last line | ≥2 | A one-word last line reads as a mistake. |
| `mark` | hanging `“` or none | — | Hung outside the measure via `text-indent: -0.55em`. |
| `mark_size` | 2.5× the quote | 2–3× | Above 3× it has become the graphic. |
| `attribution_step` | `s-1` (3.60 %) | `s-2`–`s-1` | The 0.64 secondary ratio at `s0`. |
| `attribution_ratio` | 0.64 | 0.55–0.75 | Equal size reads as the quote's last line. |
| `attribution_colour` | `--ink-dim` | — | Must still clear 4.5:1. |
| `attribution_quotes` | forbidden | — | The attribution is not part of the quote. |
| `attribution_face` | body, or italic serif for media sources | — | The metadata register from the closed three-face set. |
| `verbatim` | required | — | Cuts marked `…`, insertions `[bracketed]`. |
| `prefer_artefact` | yes | — | A screenshot of the real comment beats a retyped quotation. |
| `instances_per_video` | 1 | 1–2 | Full-frame, high-dwell. |
| `entrance` | 0.60 s whole-block, or 0.12 s per line | 0.5–0.8 s | `power3.out`, `autoAlpha` + 1.5 u rise. |
| `exit` | hard cut | 0–0.35 s | The cut is the punctuation. |

## Reproduction prompt

```
Build a quote card for {{QUOTE}} attributed to {{SOURCE}}, at {{ASPECT}}.

1. CHECK THE LICENCE FIRST. A quote card is the ONE component where prose on
   screen is the content, and the licence is that the words belong to SOMEONE
   OTHER THAN THE NARRATOR. If these are the narrator's own words, stop - that is
   a statement card, with a different word ceiling and a different frequency
   limit. If the quote is a paraphrase, stop - a paraphrase in quotation marks is
   a fabrication.

2. PREFER THE ARTEFACT. If the source is a real comment, review or post, use a
   screenshot of it with an annotation mark rather than retyping it. The
   credibility comes from it being real, and retyping throws that away.

3. SIZE FOR THE MEASURE, NOT FOR IMPACT. Compute characters per line:
     chars = (frame_width x 0.88) / (0.5 x font_px)
   At 9:16 1080x1920 that is 22 characters at step s0 and only 11 at s3. A quote
   card is NOT a place for display type: reach for s3 and the quote becomes a
   column of fragments. Set 9:16 quotes at s0 or s1, 16:9 quotes at s2.
   Ceilings: 30 characters per line, 3-4 lines, 90 characters total at 9:16.

4. PAY THE DWELL. chars / 13 seconds, stationary. A 90-character quote needs 6.9s.
   Multiply by 2.5 if a caption is live - which is 17s and unaffordable, so
   SUPPRESS OR SHORTEN THE CAPTION across the quote's window instead. That
   suppression is legitimate here and only here, because the graphic contains the
   words.

5. BREAK THE LINES SYNTACTICALLY, at phrase boundaries, not at the box edge. Left
   aligned, ragged right, never justified. No one-word last line.

6. THE ATTRIBUTION IS NOT PART OF THE QUOTE:
     its own line, step s-1 (0.64 of the quote's size), in --ink-dim, still
     clearing 4.5:1, NO quotation marks, not bold, not the same size. Use the
     project's italic-serif metadata face if the source is a film, a video or
     another creator.

7. THE MARK HANGS OR IS ABSENT. If you use an opening quotation mark, hang it
   outside the measure (text-indent: -0.55em on the block) so the quote's left
   edge aligns with every other left-aligned object in the video. Maximum 2.5x
   the quote's size. An inline mark pushes the first line right and breaks the
   grid.

8. VERBATIM. Mark cuts with an ellipsis and insertions with brackets. A silently
   edited quote is a fabrication.

9. ANIMATE ONCE: whole block fades and rises 1.5u over 0.60s power3.out, or lines
   stagger 0.12s. Then completely still for the dwell. Leave on a hard cut. No
   per-word kinetic typography on somebody else's sentence.

ACCEPTANCE TEST:
(a) characters per line between 12 and 30, computed and recorded;
(b) total characters <= 90 at 9:16, <= 160 at 16:9;
(c) on-screen stationary time >= chars/13 seconds;
(d) the caption is suppressed or <= 3 words across the whole window;
(e) attribution size / quote size is between 0.55 and 0.75, with no quotation
    marks around it;
(f) the quote's left edge aligns with the project's margin to the pixel,
    including the first line;
(g) no line breaks mid-phrase and no one-word last line;
(h) the quote text matches the source exactly, or every deviation is marked.
```

## Execution spec

**HyperFrames.** One block, `text-indent` for the hanging mark, and a per-line stagger only if the lines are authored as elements.

```html
<div id="quote" class="clip" data-start="6.20" data-duration="9.40" data-track-index="3">
  <div class="q-wrap">
    <blockquote class="q-text" id="q-text">
      <span class="q-mark" aria-hidden="true">&ldquo;</span>can you make a video on
      how to actually use sound effects
    </blockquote>
    <div class="q-attr" id="q-attr">&mdash; a comment on the last video</div>
  </div>
</div>
```

```css
[data-composition-id="gfx"] .q-wrap{
  position:absolute; left:calc(6 * var(--w)); right:calc(6 * var(--w));
  bottom:calc(34 * var(--u));
}
[data-composition-id="gfx"] .q-text{
  margin:0;
  font-size: var(--s0);                     /* 22 chars/line at 1080 wide */
  font-weight: var(--w-body);
  line-height: 1.3;                         /* 1.25 + the dark-ground bump */
  letter-spacing: -0.02em;
  color: var(--ink);
  text-indent: -0.55em;                     /* hang the opening mark */
  text-wrap: balance;                       /* Chrome: evens the ragged edge */
}
[data-composition-id="gfx"] .q-mark{ font-size: 2.5em; line-height: 0; vertical-align: -0.15em; }
[data-composition-id="gfx"] .q-attr{
  margin-top: calc(2.2 * var(--u));
  font-size: var(--s-1);                    /* 0.64 of the quote */
  color: var(--ink-dim);                    /* verify >= 4.5:1 */
}
```

```js
// 18 frames @30fps = 0.6s. One build, then completely still for the dwell.
tl.fromTo("#q-text", { y: 28, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.60, ease: "power3.out" }, 6.35);
tl.fromTo("#q-attr", { y: 20, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.50, ease: "power3.out" }, 6.55);
```

Contract points:

- **No `<br>` in body text.** The determinism rules ban it outright, so authored line breaks are not available: either let the block wrap and control it with `max-inline-size`, `text-wrap: balance` and the character-count arithmetic, or author each line as its own block-level element and stagger them. There is no third option, and this is the constraint that makes the syntactic-line-breaking rule hard to satisfy exactly.
- **`text-wrap: balance` is a Chrome feature and Chrome is the render engine**, so it is available — but it is a *balancer*, not a syntactic breaker. For a quote where the break points matter, author the lines as elements.
- **Per-line staggering requires per-line elements**, and the stagger cap is `items × stagger ≤ ~0.5 s` — four lines at 0.12 s is 0.48 s, right at the limit.
- **`fromTo`, never `from`**; `autoAlpha` on inner elements only, never on the clip; land the last tween before `data-duration` (6.55 + 0.50 = 7.05, well inside 15.60).
- **Do not tween `font-size`.** If the quote must grow, tween `scale` on a block-level, explicitly-sized wrapper.
- **`text-indent` is layout, not transform**, so it is safe alongside a `y` tween. A CSS `transform` on the same element would raise `gsap_css_transform_conflict` (error), and a lint error switches off the layout and contrast audits, after which `check` reports `0 sample(s)` / `0/0 text checks`.
- **The caption suppression is a cue-sheet edit in `design-subtitles.md`**, not a graphic-side hack, and it must be recorded there or the caption composition will happily run underneath. Suppression is legitimate only because the graphic carries the words ([[sub-caption-graphic-collision]]).
- **An italic attribution needs a real italic cut.** A synthesised oblique shears the outline. Verify the face ships one; the metadata register in this library is a small italic serif, which is a third font file and must be bundled or local — the Google Fonts path is blocked.
- **If the quote is a screenshot**, it is an `<img>` clip with `data-start` and `data-duration` (both required for `img`), plus an annotation mark on top in the annotation z-band, and the credibility argument says prefer it.

**ffmpeg — the fit and dwell audit:**

```bash
# how long is it actually stationary? sample the block region for change.
ffmpeg -ss 6.2 -t 9.4 -i out.mp4 -vf "crop=iw*0.88:ih*0.26:iw*0.06:ih*0.40,\
select='gt(scene,0.02)',metadata=print" -f null - 2> /tmp/q/motion.txt
# read the built frame and count characters per line by eye
ffmpeg -ss 8.0 -i out.mp4 -frames:v 1 -q:v 2 /tmp/q/built.png
```

**Remotion.** The same block; lines as an array when the break points matter, with `delay = index * 4` frames.

## Pairs with
[[gfx-full-frame-statement-card]] · [[gfx-modular-type-scale]] · [[gfx-attention-budget-simultaneity]] · [[gfx-annotation-mark-set]] · [[gfx-three-channel-division-of-labour]] · [[motion-attribution-label-inset-clip]] · [[motion-type-treatment-matches-content]] · [[motion-closing-thesis-title-card]] · [[sub-caption-graphic-collision]] · [[sub-syntactic-line-breaking]] · [[sub-line-length-and-line-count]] · [[struct-comment-screenshot-cold-open]] · [[struct-credibility-anchor]] · [[gfx-channel-decision-procedure]]

## Failure modes
- **Display type on a quote.** `s3` gives eleven characters a line at 9:16 and the quote becomes a column of fragments. Quotes are set small.
- **Not paying the dwell.** 90 characters needs 6.9 s stationary. Held for 3 s, it was decoration.
- **A full caption running under it.** Two READ objects, neither read, and the quote's whole purpose defeated.
- **The attribution at quote size.** Reads as the quote's last line, so the quote appears to say something its author did not.
- **Quotation marks around the attribution.** Somebody quoting somebody.
- **An inline opening mark.** Pushes the first line right by half an em and breaks alignment with every other object in the video.
- **A decorative 66 at 5× the type.** It has become the graphic and the quote is now its caption.
- **A silently edited quote.** A fabrication. Mark the cuts.
- **Retyping a real comment.** Throws away the credibility that was the reason to show it.
- **Justified text.** Video has no usable hyphenation control; justification produces rivers and stranded words.
- **A one-word last line.** Reads as a mistake, and it is one.
- **Per-word kinetic typography on somebody else's sentence.** Performs a quote that should be read.
- **Two quote cards in a minute.** Two full-frame high-dwell objects back to back stalls the video.
- **Known gap:** the reference set contains one quotation device — the comment-screenshot cold open — and no built quote card, so the type sizes, ratios and hanging-mark treatment here are derived from the type scale and the published line-length and dwell rules rather than measured from a creator. The `0.5 em` average character advance varies by ±15 % across families; measure the real advance for the chosen face before trusting a borderline character count.
