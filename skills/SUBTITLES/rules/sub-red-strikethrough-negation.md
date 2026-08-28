---
id: sub-red-strikethrough-negation
title: Red strikethrough marks a claim being negated — strike the words the speaker is rejecting
skill: subtitles
type: caption-style
family: caption-colour
tags: [skill/subtitles, type/caption-style, family/caption-colour, engine/hyperframes, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: n/a
    quote: "Red strikethrough as the signature rhetorical device: S̶T̶IMULATING, captions just to ~~jack up the visual variety~~, and BORING stamped in red across a YouTube analytics screenshot. Struck-through or red-overlaid text = a claim being negated. Consistent enough to be a caption rule, not a one-off."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:54"
    quote: "A lot of people make the mistake of adding captions just to bump up the visual variety."
research_refs:
  - https://developer.mozilla.org/en-US/docs/Web/CSS/text-decoration
  - https://en.wikipedia.org/wiki/Color_blindness
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
  - https://www.w3.org/TR/WCAG22/
difficulty: medium
detectable_from: video
---

# Red strikethrough marks a claim being negated — strike the words the speaker is rejecting

## What it is

A caption convention, observed as a consistent device in one of the reference creators, in which **struck-through or red-overlaid text marks a claim the speaker is rejecting**. It is not emphasis. It is the opposite of emphasis: it foregrounds a phrase in order to cancel it.

The visual pass over `editing kt` found three instances that establish the pattern beyond a one-off:

- `S̶T̶IMULATING` — the word partially struck, so the viewer reads both the word and its cancellation.
- `captions just to ~~jack up the visual variety~~` — the struck portion is exactly the clause being argued against, while the framing words stay clean.
- `BORING` stamped in red across a YouTube analytics screenshot — the same code applied to a graphic rather than to text.

What makes it a rule rather than a decoration is that the mark's placement is **syntactically precise**: it lands on the rejected proposition, not on the sentence containing it. In the second example the speaker is not rejecting "captions" — he is rejecting the purpose "to jack up the visual variety". The strike is on the purpose clause. That precision is the device's whole value: it lets a caption disagree with its own text, which no other caption treatment can do.

This is also a textbook case of [[sub-semantic-colour-assignment]] done correctly, because **the strikethrough line is a fully redundant, colour-blind-safe carrier of the meaning.** Red alone would fail for the roughly 8 % of male viewers with a red-green deficiency — the literature is blunt that a red-means-bad code is *"almost always undifferentiable to deutans or protans."* The line survives greyscale, survives a bad phone screen, and survives sunlight. The red makes it faster; the line makes it work.

## When to use it

Fire it on exactly one thing: **a proposition the speaker is explicitly rejecting, at the moment they reject it.** In practice that is four recurring shapes:

- **The myth-and-correction beat.** "People think you need [X]" — strike X — then the correction lands clean.
- **The named mistake.** "The mistake is adding captions to bump up visual variety" — strike the purpose clause.
- **The self-correction.** A word the speaker retracts mid-sentence. Note this overlaps [[sub-verbatim-misspeak-correction]] and the two must not both fire on the same beat; the misspeak gag is comedic, this is rhetorical.
- **The rejected option in a comparison.** Two approaches shown; one struck.

Do **not** use it for:

- **Anything merely unimportant.** Striking a filler word is meaningless and burns the code.
- **Negative sentiment.** "This is hard" is not a rejected claim.
- **Deleted words in an edited transcript.** Captions are verbatim ([[sub-caption-role-decision]]); a strike is a rhetorical mark, never an editorial one.
- **More than about three times per video.** Like every mark, it is defined by scarcity.

A hard sequencing rule: **the strike must land at or after the moment of rejection, never before.** Striking a claim before the speaker has finished asserting it spoils the beat and reads as the edit arguing with the presenter.

## How to recognise it in a reference video

This is one of the more identifiable caption devices, because a horizontal line through text is unambiguous in a single frame.

| Signal | Measure | Reading |
|---|---|---|
| Line presence | A horizontal rule crossing the glyphs at roughly x-height/2 | Present = negation device |
| Line position | Height of the line above the baseline / cap height | 0.30–0.42 = a proper strikethrough. Near 0 = an underline, a different device. |
| Line thickness | Line thickness / cap height | 0.06–0.12. Below 0.05 it disappears after encode; above 0.15 it obliterates the word. |
| Line colour vs text colour | Sample both | Different = the line is a deliberate mark. Same = it may be the font's default decoration. |
| Extent | Does the line cover the whole cue or a sub-clause? | **Sub-clause is the sharp signal.** Whole-cue striking is cruder and often means the rule was not really understood. |
| Partial strike | `S̶T̶IMULATING` — line covers only some letters | A deliberate stylistic variant; the word is legible and cancelled at once |
| Timing vs speech | Compare the frame where the line appears with the transcript | At or just after the rejected phrase completes = correct. Before = spoiler. |
| Draw-on | Sample consecutive frames at the strike's onset | If the line grows left-to-right over 4–8 frames it is animated, not static |
| Frequency | Count instances across the video | 1–3 = a device. 6+ = it has become the caption style. |
| Greyscale survival | `ffmpeg -vf format=gray` | The line must still read. If only colour changed, the device fails 8 % of viewers. |

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `trigger` | an explicitly rejected proposition | — | Not "unimportant", not "negative", not "deleted". |
| `extent` | the rejected clause only | clause / word | Strike the proposition, not the sentence that contains it. |
| `uses_per_video` | 2 | 1–3 | Above 3 it stops being a mark. |
| `in_offset_vs_rejection` | +0.08 s (2–3 f) | 0 to +0.25 s | At or just after the rejected phrase completes. **Never negative** — an early strike spoils the beat. |
| `hold` | 1.2 s | 0.8–2.0 s | Long enough to read the word and register the cancellation. |
| `line_colour` | `--cap-negate`, a red at L* 45–55 | — | Must clear 3:1 against the text it crosses, or it reads as a compression artefact. |
| `text_colour_when_struck` | resting, or `--cap-negate` | — | Two variants: red line over normal text (clearer), or the whole phrase in red (more emphatic). Pick one and hold it. |
| `line_thickness` | 0.08 em | 0.06–0.12 em | ~4 px at 48 px type. Below 0.05 em it dies in the encode. |
| `line_position` | ~0.36 of cap height above baseline | 0.30–0.42 | Browser default is usually fine; specify if the face sits oddly. |
| `redundant_cue` | the line itself | required | The line, not the colour, is what carries the meaning for colour-deficient viewers. |
| `draw_on` | on | on / off | `scaleX` 0 → 1 from `transform-origin: left`, 0.25 s, `power2.out`. A static appear is acceptable but weaker. |
| `draw_duration` | 0.25 s | 0.18–0.35 s | Fast enough not to be a motion event competing with the picture. |
| `sfx` | one short mark | none / one | A short scratch or click at the strike's onset, −12 to −15 dB. See [[sfx-record-scratch-punctuation]]. |
| `collides_with` | misspeak gag, emphasis accent | — | Never fire this and [[sub-verbatim-misspeak-correction]] on the same beat, and never colour a struck word with `--cap-accent`. |
| `graphic_variant` | red stamp over a screenshot | — | The same code applied to a graphic: a red word rotated over an image. Same rule, same budget. |

## Reproduction prompt

```
Apply the red-strikethrough negation device to the caption track for {{PROJECT}},
using {{TRANSCRIPT}}.

Scan for propositions the speaker explicitly REJECTS: myth-and-correction beats,
named mistakes, retracted claims, rejected options in a comparison. Ignore words
merely unimportant or negative in sentiment — this mark means "this claim is
wrong", not "this is bad news".

For each hit, identify the exact span being rejected. Strike the PROPOSITION, not
the sentence containing it: in "adding captions just to bump up visual variety",
the rejected span is "just to bump up visual variety", not "adding captions".
Getting this span wrong is the difference between a rhetorical device and a
smear.

Select at most {{3}} instances for the whole video, taking the clearest
rejections — those where the correction that follows is strongest.

For each, emit: in-point (at or 2-3 frames AFTER the rejected phrase completes —
never before, an early strike spoils the beat), the struck span verbatim, hold
duration, and whether the whole phrase goes red or only the line does. Use one
variant throughout.

The line, not the colour, must carry the meaning: about 8% of male viewers have a
red-green deficiency. Set line thickness to 0.06-0.12em so it survives encoding.

Acceptance test: render each instance and convert to greyscale — the cancellation
must still read from the line alone. Confirm each struck span is a complete
proposition by reading it aloud alone. Confirm no instance starts before its
rejected phrase finishes, and none shares a beat with a misspeak gag or an
accent-coloured emphasis word.
```

## Execution spec

The critical execution fact: **`text-decoration-line` is a discrete, non-animatable property.** GSAP cannot draw it on; it will snap from `none` to `line-through` at 50 % progress. `text-decoration-color` and `text-decoration-thickness` *are* animatable, but the line's existence is not.

So there are two implementations, and the animated one does not use `text-decoration` at all:

```css
/* STATIC — text-decoration is fine when the line just appears. */
[data-composition-id="captions"] .caption-text .negated {
  text-decoration-line: line-through;
  text-decoration-color: var(--cap-negate);
  text-decoration-thickness: 0.08em;
  text-decoration-skip-ink: none;    /* the line must NOT break around descenders */
}

/* ANIMATED — a pseudo-element bar, because the line must be a transform target. */
[data-composition-id="captions"] .caption-text .negated {
  position: relative;
}
[data-composition-id="captions"] .caption-text .negated::after {
  content: "";
  position: absolute;
  left: 0; right: 0;
  top: 54%;
  height: 0.08em;
  background: var(--cap-negate);
  transform: scaleX(0);
  transform-origin: left center;
}
```

```js
// Draw-on. scaleX is a GSAP transform alias — legal. Animating `width` is not.
tl.fromTo(".negated::after-proxy",              // target the element, not the pseudo
  { scaleX: 0 },
  { scaleX: 1, duration: 0.25, ease: "power2.out" },
  strikeAt
);
```

Practical notes:

- **GSAP cannot target a pseudo-element directly.** Use a real child `<span class="strike-bar">` instead of `::after`, or animate a CSS custom property that the pseudo-element reads. A real element is simpler and seek-safe.
- **`text-decoration-skip-ink: none` is required.** The default skips the line around descenders, which on a struck word looks like the line is broken rather than continuous — it reads as a rendering bug.
- **`fromTo`, never `from`.** `gsap.from()` sets `immediateRender: true`, writing the "from" state at construction time before the clip's `data-start` is active; under the render engine's non-linear seek the strike flashes or starts wrong.
- **`power2.out`, not `power3.out`.** Caption fades and caption marks belong to the gentle eases; the project's typography guardrail states this explicitly and notes it is *"NOT the entrance default."*
- **Requires a per-word or per-span element model.** The staged implementation writes `textContent` into a single reused span, which cannot hold a marked-up sub-clause. This device forces the per-span build — which is also the seek-robust alternative to the single-box design.
- **The struck word must still clear its contrast floor.** A red line over red text over a plate is three values to check, not one.

## Pairs with

- [[sub-semantic-colour-assignment]] — this is the worked example of the rules in that note
- [[sub-caption-colour-token-system]] — where `--cap-negate` is defined
- [[sub-emphasis-selection-rule]] — the positive mark; these two must not collide
- [[sub-over-emphasis-audit]] — the shared scarcity budget
- [[sub-verbatim-misspeak-correction]] — a different device that must not share a beat
- [[sub-caption-role-decision]] — a strike is rhetorical, never editorial
- [[motion-annotation-draw-on]] — the draw-on mechanic, generalised
- [[motion-attention-transient]] — the mark as an attention event
- [[sfx-record-scratch-punctuation]] — the sound that can accompany it
- [[struct-enumerated-promise-and-counter]] — the myth-and-correction structure that generates the trigger

## Failure modes

- **Striking the sentence instead of the proposition.** "~~Adding captions just to bump up visual variety~~" reads as rejecting captions. The speaker did not. The span is the meaning.
- **Striking before the rejection lands.** The caption argues with the presenter mid-sentence. The device only works as a response.
- **Red without the line.** Fails for about 8 % of male viewers, and for everyone in bright sunlight. The line is the load-bearing half.
- **Trying to animate `text-decoration-line`.** It is discrete. It snaps at 50 %. Use a real element with `scaleX`.
- **Leaving `text-decoration-skip-ink` at its default.** The line breaks around every `g`, `y` and `p` and reads as a rendering fault.
- **Using it for deleted transcript words.** Captions are verbatim. A strike means "this claim is wrong", not "I cut this".
- **Six instances.** It stops being a mark and becomes the caption style, at which point it means nothing.
- **Colliding with the accent.** A struck word in the accent colour is simultaneously being promoted and cancelled.
- **`gsap.from()` on the bar.** Flashes or starts wrong under non-linear seek.
- **Forgetting the line's own contrast.** A red line at 2:1 against red text vanishes into the letterforms after encode.
