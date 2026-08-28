---
id: sub-tracking-and-caption-line-height
title: Track negative because the encoder eats letter detail, and lead tighter than a web page
skill: subtitles
type: caption-style
family: caption-type
tags: [skill/subtitles, type/caption-style, family/caption-type, engine/hyperframes, source/hyperframes, source/research, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "tracking −0.03em to −0.05em at display sizes, because \"Video encoding compresses letter detail.\""
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: ".caption-text — line-height: 1.2. On dark backgrounds, drop body weight (350 not 400) and add 0.05–0.1 line-height."
research_refs:
  - https://www.w3.org/TR/WCAG22/
  - https://en.wikipedia.org/wiki/X-height
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
difficulty: medium
detectable_from: video
---

# Track negative because the encoder eats letter detail, and lead tighter than a web page

## What it is

Two spacing values that behave in video the opposite way to how they behave on the web, and that carry the compensation for the optical-size axis this stack does not have.

**Tracking goes negative as size goes up.** Type is drawn with sidebearings tuned for text size. At display size those sidebearings are proportionally too large and the word falls apart into letters. The project's own guardrail is **−0.03 em to −0.05 em at display sizes**, with a stated reason that is specific to video rather than to print: *video encoding compresses letter detail*. That is a real mechanism, not a taste claim. H.264/H.265 at typical social bitrates quantises high-frequency detail hardest, and the highest-frequency thing in a caption is the alternating stem-gap-stem pattern of the letters. Closing the gaps slightly makes the word a single connected shape that survives quantisation, rather than a row of thin features that each get smeared independently.

**Leading goes tighter than a web page, then loosens on dark grounds.** The reference implementation uses `line-height: 1.2`. WCAG 1.4.12 asks that content survive a user setting line height to at least **1.5** — that is a requirement about *reflowable web text not breaking*, and it does not apply to a burned-in caption, which no user can restyle. Applying 1.5 to a two-line caption instead pushes the second line into the platform UI band and wastes a fifth of the caption zone. The correct band for burned-in captions is **1.15–1.35**. The exception is grounds: on a dark ground the light letterforms bloom, the lines visually close up, and the project's rule is to add 0.05–0.1 to line-height. So a caption on a dark plate wants 1.25–1.3, not 1.2.

The two values are coupled. Tighter tracking makes a line read as a longer unbroken shape, which tolerates tighter leading. Loose tracking with tight leading produces the specific ugliness where the eye cannot tell whether it is reading across or down.

## When to use it

- **Tracking:** on every type object above roughly 3 % of frame height. Below that — a corner counter, an attribution label — leave tracking at 0 or slightly positive, because small type needs *more* space, not less. This is the whole reason the number is a function of size.
- **Leading:** only matters on multi-line objects. A one-line caption's `line-height` still sets the box height, which is why it belongs in the token set even when it is invisible.
- **Recompute both** when the size token changes, when the case changes to all-caps (caps need ~0.02 em back), and when the backing changes from a plate to a stroke (a stroke adds apparent width and wants a little more tracking, not less).

## How to recognise it in a reference video

Both are measurable from one mid-cue frame, at 2× or better.

| Measurement | Method | Expected |
|---|---|---|
| Tracking | Measure the advance width of a repeated letter pair (e.g. the two `t`s in "matter") and compare to the face's default advance at the same size | −0.03 to −0.05 em on a designed caption; 0 on a default |
| Optical gap check | Look at `rn` and `cl` pairs | If they read as `m` and `d`, tracking has gone past −0.06 em |
| Leading | Measure baseline to baseline on a two-line cue, divide by font-size | 1.15–1.35 designed; 1.5+ is web-default carryover; 1.0 or below is a collision |
| Descender/ascender clearance | Look at a `g` on line 1 above an `h` on line 2 | They must not touch. At 1.2 with a 0.74 x-height face they will not. |
| Ground compensation | Compare leading on a light-plate cue vs a dark-plate cue | Identical is normal; +0.05–0.1 on the dark one means somebody tuned it |
| Post-encode integrity | Compare the source frame to the delivered stream at the same timestamp | If letters that were separate have merged, tracking is too tight for the bitrate |

The `rn`/`cl` test is the one that catches over-tracking, and it catches it in a way a designer looking at a specimen will not: those pairs collapse before anything else does, and once they collapse the caption produces misreadings rather than illegibility, which is worse.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `tracking_caption` | −0.04 em | −0.03 to −0.05 em | The project's display-size band. −0.04 em at 48 px is −1.92 px. |
| `tracking_caps` | −0.02 em | −0.01 to −0.03 em | Caps carry more sidebearing; give roughly 0.02 em back relative to the lowercase value. |
| `tracking_small_type` | 0 em | 0 to +0.02 em | Anything under ~3 % of frame height (counters, attribution labels). Small type needs more space, not less. |
| `tracking_floor` | −0.06 em | — | Hard floor. Past this `rn` reads as `m` and the caption starts producing misreadings. |
| `tracking_condensed_penalty` | +0.01 em | 0 to +0.02 em | Condensed faces are already tight; give some back. |
| `line_height_light_ground` | 1.20 | 1.15–1.30 | The reference file's value. |
| `line_height_dark_ground` | 1.28 | 1.20–1.35 | The project's rule: add 0.05–0.1 on dark backgrounds. |
| `line_height_ceiling` | 1.35 | — | Above this a two-line caption starts eating the safe band for no legibility gain. |
| `line_height_floor` | 1.10 | — | Below this descenders and ascenders collide on a 0.74 x-height face. |
| `wcag_1_4_12_applies` | no | — | 1.4.12's 1.5 line-height is about reflowable web text surviving user restyling. A burned-in caption cannot be restyled; the criterion is not the target. |
| `word_spacing` | 0 | −0.02 to 0 em | Negative tracking already tightens word gaps. Do not tighten again. |
| `plate_pad_compensation` | +0.05 em top | 0 to 0.1 em | Negative tracking pulls the text visually left inside the box; add a hair of right padding or set `text-align: center` and stop worrying. |
| `recompute_trigger` | size, case or backing change | — | All three change the correct tracking value. |

## Reproduction prompt

```
Set tracking and line-height for the caption objects in {{PROJECT}}, set in
{{FAMILY}} at {{SIZE_PERCENT}}% of frame height, over a predominantly
{{light|dark}} ground, delivered at {{BITRATE}}.

Apply negative tracking in the -0.03em to -0.05em band to every type object at
or above 3% of frame height, because video encoding compresses letter detail and
closing the letter gaps makes each word survive quantisation as one connected
shape. Give roughly 0.02em back on any object set in caps. Set tracking to 0 or
slightly positive on anything below 3% of frame height — small type needs more
space, not less. Never go past -0.06em.

Set line-height in the 1.15-1.35 band: 1.20 on a light ground, plus 0.05-0.1 on a
dark one, because light letterforms on dark bloom and the lines close up. Do not
apply WCAG 1.4.12's 1.5 figure — that criterion is about reflowable web text
surviving a user restyle, and a burned-in caption cannot be restyled. Applying it
pushes the second line into the platform UI band.

Express both as tokens in em, never in px, so they scale with a size change.

Acceptance test: render a two-line cue containing the letter pairs "rn", "cl",
"gh" and a descender above an ascender, over three sampled frames of the real
footage. Encode at the delivery bitrate, then view the decoded frame at 100%.
"rn" must not read as "m", "cl" must not read as "d", and no descender may touch
the line below. Then measure baseline-to-baseline over font-size and confirm it
lands in 1.15-1.35.
```

## Execution spec

Both values are tokens, consumed by the text rule and adjusted by variant class only:

```css
[data-composition-id="captions"] {
  --cap-tracking: -0.04em;
  --cap-leading: 1.28;          /* dark plate: 1.20 base + 0.08 */
}
[data-composition-id="captions"] .caption-text {
  letter-spacing: var(--cap-tracking);
  line-height: var(--cap-leading);
  word-spacing: 0;
}
[data-composition-id="captions"] .caption-text--caps {
  text-transform: uppercase;
  letter-spacing: calc(var(--cap-tracking) + 0.02em);
}
```

Three execution notes specific to this stack:

- **`em`, not `px`, for both.** `letter-spacing: -1.92px` is correct at 48 px and wrong at every other size. Because caption size is a percentage of frame height ([[sub-size-as-frame-height-percentage]]), a px tracking value silently becomes a different design at portrait.
- **`letter-spacing` is animatable but should not be animated.** GSAP will tween it, and every tween step forces a text re-layout, which reflows the box, which moves the plate, which is visible as a shimmer. If a caption needs a "settle" feel, animate `scale` or `y` on the box — transforms only, per the project's spatial-motion rule — never `letter-spacing` or `width`.
- **`white-space: nowrap` interacts badly with tracking.** The reference file sets `white-space: nowrap` with `overflow: hidden` and a 5-word grouping. Tightening tracking makes lines fit that would otherwise have overflowed, so tracking changes silently change which cues clip. The layout audit measures `getBoundingClientRect` and **`overflow: hidden` clips the visual without suppressing the finding** — so the audit will tell you, but only if lint is clean enough for it to run. See [[sub-line-length-and-line-count]].

## Pairs with

- [[sub-typeface-selection-for-captions]] — letterfit determines how much negative tracking the face absorbs
- [[sub-weight-case-and-optical-size]] — the caps adjustment, and why this note carries the optical-size compensation
- [[sub-size-as-frame-height-percentage]] — why both values must be in `em`
- [[sub-line-length-and-line-count]] — tracking changes which lines fit
- [[sub-caption-plate-geometry]] — negative tracking shifts the text inside the plate
- [[sub-caption-identity-token-set]] — where both are recorded
- [[motion-emphasis-scale-step]] — the legal way to animate emphasis instead of tracking

## Failure modes

- **Tracking in px.** Correct at one resolution, wrong at every other. The single most common tokenisation slip.
- **Over-tracking into misreadings.** Past −0.06 em `rn` becomes `m` and `cl` becomes `d`. The caption is still perfectly legible; it just says a different word. This is worse than illegible because nobody notices.
- **Applying WCAG 1.4.12's 1.5 to a burned-in caption.** Well-intentioned, wrong criterion, and it costs a fifth of the caption zone on a two-line cue.
- **Tracking small type negatively.** Counters, timecodes and attribution labels at 2 % of frame height need positive tracking. Applying the display value to them makes them the least legible thing in the frame.
- **Animating `letter-spacing`.** Reflows on every frame, shimmers, and moves the plate under the text.
- **Forgetting the caps adjustment.** All-caps at the lowercase track value collides, and it collides worst on exactly the wide letters (`M`, `W`) that carry the most weight.
- **Tuning tracking on a source frame and never checking the encode.** The whole justification for negative tracking is what the encoder does. Check the encode.
- **Changing tracking after line breaks are fixed.** Tighter tracking makes a two-line cue fit on one line, or the reverse. Re-run the fit check after any tracking change.
