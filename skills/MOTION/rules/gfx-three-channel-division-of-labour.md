---
id: gfx-three-channel-division-of-labour
title: Three channels — speech carries the argument, the caption transcribes it, the graphic carries what words cannot
skill: motion
type: graphic
family: channel-discipline
tags: [skill/motion, type/graphic, family/channel-discipline, engine/hyperframes, engine/remotion, source/editing-kt, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:02"
    quote: "Using captions to fill more space can get ugly fast and waste a great opportunity to put something more engaging on screen. So I only use captions when I want the viewer to catch specific words and pay extra attention to them."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:54"
    quote: "A lot of people make the mistake of adding captions just to bump up the visual variety."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:24"
    quote: "Sound is half of your video."
research_refs:
  - https://journals.sagepub.com/doi/abs/10.1518/hfes.46.3.567.50405
  - https://bjorklab.psych.ucla.edu/wp-content/uploads/sites/13/2016/07/YueBjorkBjork2013_redundancy.pdf
  - https://edtechuvic.ca/wp-content/uploads/sites/11/2022/09/principles-for-reducing-extraneous-processing-in-multimedia-learning-coherence-signaling-redundancy-spatial-contiguity-and-temporal-contiguity-principles.pdf
  - https://en.wikipedia.org/wiki/Dual-coding_theory
  - https://www.w3.org/WAI/WCAG22/Understanding/captions-prerecorded.html
difficulty: high
detectable_from: transcript+video
---

# Three channels — speech carries the argument, the caption transcribes it, the graphic carries what words cannot

## What it is

A video has three simultaneous verbal-or-visual channels, and they have **non-overlapping jobs**. Almost every bad graphic in the medium is a graphic that took a job belonging to another channel.

| Channel | Its job | What it is allowed to be redundant with |
|---|---|---|
| **Spoken** | Carry the argument. The sentences, the reasoning, the transitions between ideas. | Nothing — it is the source. |
| **Caption** | Verbatim transcription of the spoken channel. Its purpose is **sound-off access**: a viewer in a feed, on a train, in a shared room, or with a hearing impairment. | **The audio, entirely and by design.** Redundancy with speech is the caption's whole function, not a flaw in it. |
| **Graphic** | Carry what words cannot: **structure, quantity, relation, comparison, or the referent itself.** | Almost nothing. |

The caption's redundancy is licensed because its audience is a viewer who is not receiving the audio at all. For that viewer the caption is not a second copy; it is the only copy. The graphic has no such licence, because there is no viewer for whom the graphic is the only route to a sentence.

**So a graphic that restates the caption is a third copy of the same sentence.** The viewer receives it three times — heard, read at the bottom, read in the middle — and pays attention three times for one piece of information. That is not emphasis. It is a tax.

### The evidence, and it is unusually strong

This is one of the best-measured findings in instructional media. **The redundancy principle** — that adding on-screen text duplicating a narration *hurts* learning when a graphic is present — carries a **median effect size of d = 0.86 across 16 studies, supported in 16 of 16.** Kalyuga, Chandler & Sweller (2004) ran three experiments and found that *"a concurrent presentation of identical auditory and visual technical text … was significantly less efficient in comparison with an auditory-only text"*, and that non-concurrent presentation beat concurrent presentation on both mental-load ratings and test scores when instruction time was constrained.

Yue, Bjork & Bjork (2013) sharpened it in the direction that matters most for editing: **identical** on-screen text was *worse* than **abridged** text (recall `d = 0.95`, `p = .002`) and worse than lightly-reworded text (`d = 0.5`). And the finding that should worry any editor: learners **preferred** the identical text and judged it best for learning, while performing worse with it. The redundant graphic feels good and measures badly. You cannot trust a review that says "it feels clearer with the text on screen".

**The five things a graphic can carry that words cannot** — this is the positive half of the doctrine and it is what a component library is *for*:

1. **Structure.** How many parts there are, which order they come in, which is current. A word can say "third of five"; only a graphic can make "third of five" true at a glance at any random frame.
2. **Quantity.** A magnitude, a share, a change. "It went from 400 to 41,000" is a sentence about numbers; a bar or a counted roll-up is the quantity itself ([[motion-number-rollup-stat-reveal]]).
3. **Relation.** This causes that, this contains that, this feeds that. Prose serialises a relation into a chain of clauses; a diagram shows it in one glance ([[gfx-diagram-connector-geometry]]).
4. **Comparison.** Two things side by side, differing in a named dimension. Speech can only present them one after the other, so the viewer has to hold the first in working memory ([[gfx-comparison-two-column-card]], [[motion-filmstrip-comparison-strip]]).
5. **The referent itself.** The actual screenshot, the actual waveform, the actual chart, the actual clip being discussed. "This" needs a *this*.

**Prose is not on that list, and neither is emphasis-by-repetition.**

### The test

> **Cover the graphic. Does the viewer lose information?**
>
> If not, cut it.

And the mirror test, which catches the opposite failure:

> **Mute the video and hide the caption. Does the graphic still say something?**
>
> If not, it is an illustration of speech rather than a channel — which is legitimate for a concept card ([[motion-abstract-concept-card]]) and not legitimate for anything claiming to carry information.

Both tests are cheap, both are mechanical, and neither depends on taste. Run them on every graphic in the design document before anything is built.

**The opportunity-cost argument is the same argument.** The reference material makes it about captions — *"a great opportunity to put something more engaging on screen"* — and it generalises exactly: the graphic band is about 32 % of a 9:16 frame ([[gfx-vertical-grid-and-margins]]), it is the most valuable real estate in the video, and a restatement of the sentence is the lowest-value thing that can occupy it.

## When to use it

- **Once per project, as a doctrine paragraph in `design-motion.md`**, and then per beat as a gate in [[gfx-channel-decision-procedure]].
- **Before choosing a component.** The channel question comes first: does this beat need a graphic *at all*? Most beats do not.
- **At every review.** The redundant graphic is the one that survives review, because it *feels* clearer. Run the cover test rather than asking whether it looks good.
- **When the caption role is being decided.** The three channels interact: an emphasis-only caption layer leaves the middle of the frame free and changes what the graphic must carry ([[sub-caption-role-decision]]).
- **Not** as an argument against captions. The caption's redundancy is its function; WCAG 2.2 SC 1.2.2 is Level A and covers the whole audio programme. Nothing in this note reduces a caption obligation.
- **Not** as an argument against a concept card. A card that names an abstract concept is an illustration of speech, and it earns its place through recognisability and pacing, not through information. Say which it is.

## How to recognise it in a reference video

This is a transcript-plus-frames measurement and it produces one number that characterises a whole channel.

- **Compute the graphic's prose share.** Pull the word-level transcript. For each graphic, take the words it displays; count how many of them appear in the spoken transcript within ±2 s of the graphic's window. Divide by the graphic's total word count.

  | Prose share | Reading |
  |---|---|
  | **0–20 %** | The graphic carries its own content. A designed channel. |
  | 20–50 % | A label or an ordinal is shared. Normal and healthy — that is structural scaffolding ([[gfx-structure-duplicates-prose-does-not]]). |
  | **50–85 %** | Prose duplication. The graphic is repeating the sentence. |
  | **85–100 %** | The graphic *is* the caption, at a different size, in a different band. |

- **Run the cover test on the reference.** Mask the graphic region and watch the beat. Note whether you lost anything. Do it for every graphic and report the **pass rate** — in good work it is near 100 %; a channel with a 50 % pass rate is decorated.
- **Run the mute test.** Play the beat muted with captions off. A graphic carrying structure, quantity, relation, comparison or a referent still communicates. One carrying prose says nothing, because its content was the sentence you just removed.
- **Classify each graphic by which of the five it carries**, and count. A well-built explainer's graphic inventory skews to relation, quantity and referent. An inventory that is mostly "a phrase, set large" is not an inventory.
- **Check for the three-copy frame.** Sample frames where a caption and a text graphic are both live. If the graphic's words are a substring of the caption's words, you have found the failure directly, in one frame, with no interpretation needed.
- **Count words per graphic.** A graphic carrying structure or quantity is short — an ordinal, a label, a number, three words on a node. A graphic carrying prose is long. **Median words per graphic above about 8** is a strong signal of prose duplication before you check anything else.
- **Check the finite-verb signal.** On-screen text containing a finite verb ("is", "does", "means", "causes") is almost always a clause lifted from the narration. Structure and quantity do not need verbs.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `channels` | 3 | 3 | Spoken, caption, graphic. Music and SFX are a fourth channel with its own library. |
| `caption_redundancy` | by design | — | 100 % redundant with audio is correct. Its audience is not receiving the audio. |
| `graphic_prose_share` | ≤20 % | 0–50 % | Words on the graphic that are also spoken within ±2 s, as a share of the graphic's words. |
| `graphic_carries` | one of five | 1 | Structure / quantity / relation / comparison / referent. Named per graphic in the design doc. |
| `cover_test` | required, 100 % pass | 100 % | Cover the graphic; the viewer must lose information. |
| `mute_test` | required for information graphics | — | Muted with captions off, the graphic must still say something. Exempt: concept cards, declared as illustrations. |
| `words_per_graphic` | ≤6 | 1–12 | Median across the video. Above 8 signals prose duplication. |
| `finite_verb_on_graphic` | forbidden | — | Except in a quote card or a statement card, where the sentence *is* the content. |
| `substring_of_caption` | forbidden | — | If the graphic's text is a substring of the concurrent caption, it is the third copy. |
| `graphics_per_minute` | 3 | 1–6 | Counts full-frame cards and overlay components; not marks. |
| `full_frame_cards_per_minute` | ≤1.3 | ≤1.3 | From [[motion-abstract-concept-card]]. Above this the format becomes card-driven. |
| `declared_illustration` | allowed | — | A card that illustrates rather than informs is legal **if labelled as such** in the design doc, and it costs the same screen time. |
| `review_method` | cover test, not opinion | — | Redundant text is *preferred* by viewers and measures worse. Do not take a feel-based review. |
| `accessibility_floor` | unchanged | — | WCAG 2.2 SC 1.2.2 is Level A and covers the whole audio programme. Nothing here reduces it. |

## Reproduction prompt

```
Audit and fix the channel division for {{PROJECT}}. Inputs: the word-level
transcript, design-subtitles.md, and design-motion.md.

1. WRITE THE THREE JOBS at the top of design-motion.md, verbatim:
     SPOKEN  carries the argument.
     CAPTION is verbatim transcription. It is redundant with the audio BY
             DESIGN; its job is sound-off access, and for a muted viewer it is
             not a second copy, it is the only copy.
     GRAPHIC carries what words cannot: structure, quantity, relation,
             comparison, or the referent itself.

2. FOR EVERY GRAPHIC in design-motion.md, name which ONE of the five it carries.
   If you cannot name one, the graphic is prose or decoration.

3. RUN THE COVER TEST on each: cover the graphic and re-read the beat's
   transcript. If the viewer loses nothing, CUT IT. Do not shrink it, do not
   move it, do not soften it - cut it, and give the screen time back to the
   footage or to the pause.

4. RUN THE MUTE TEST on each information graphic: with audio off and captions
   hidden, does it still say something? If not, it is an illustration of speech.
   That is legal for a concept card, but it must be DECLARED as an illustration
   in the design doc so its cost is visible.

5. MEASURE THE PROSE SHARE mechanically. For each graphic, take its words, count
   how many also appear in the spoken transcript within +/-2s of its window, and
   divide. Target <= 20%. Between 20% and 50% is normal when the shared words are
   an ordinal, a label or a number - that is structural scaffolding and it is
   allowed (see the structure-versus-prose rule). Above 50% is prose duplication.

6. APPLY THE THREE MECHANICAL REJECTS:
     - the graphic's text is a SUBSTRING of the concurrent caption  -> cut;
     - the graphic's text contains a FINITE VERB and is not a quote card or a
       statement card                                              -> rewrite as
       a label, a number or a diagram, or cut;
     - the graphic carries more than 8 words and is not a quote card -> it is a
       paragraph on screen. Cut or convert to structure.

7. REVIEW BY TEST, NOT BY FEEL. Redundant on-screen text is PREFERRED by viewers
   and measures worse: identical text scored significantly below abridged text
   (d = 0.95 for recall) while being judged "best for learning". A reviewer
   saying "it's clearer with the text up" is reporting the illusion, not the
   effect. Run the cover test in front of them instead.

ACCEPTANCE TEST:
(a) every surviving graphic has exactly one of the five jobs named in the design
    doc;
(b) cover-test pass rate is 100%;
(c) median words per graphic <= 6;
(d) zero graphics whose text is a substring of the concurrent caption;
(e) prose share <= 20% for every graphic, or 20-50% with the shared words
    identified as an ordinal, label or number;
(f) the count of declared illustrations is stated explicitly, with their total
    screen time as a percentage of runtime.
```

## Execution spec

There is nothing to build here — this is the gate that decides what gets built — but three stack facts make the audit runnable and one makes it enforceable.

**The transcript is already in the project and already word-level.** `transcript.json` carries `{text, start, end}` per word, and the caption composition inlines the same array. So the prose-share measurement is a script, not a review:

```js
// prose share for one graphic. Runs offline; no framework needed.
function proseShare(graphicWords, transcript, t0, t1, pad = 2.0) {
  const spoken = new Set(
    transcript
      .filter(w => w.end >= t0 - pad && w.start <= t1 + pad)
      .map(w => w.text.toLowerCase().replace(/[^\p{L}\p{N}]/gu, ""))
  );
  const words = graphicWords.toLowerCase().split(/\s+/)
    .map(w => w.replace(/[^\p{L}\p{N}]/gu, "")).filter(Boolean);
  const shared = words.filter(w => spoken.has(w)).length;
  return { share: shared / words.length, count: words.length };
}
```

Facts that bind it:

- **Caption timing is driven entirely by the inlined word array** — *"There is no external transcript read at runtime, no audio analysis, no `audio.currentTime`."* So the caption's exact on-screen words at any timestamp are computable at author time, which is what makes the substring check mechanical rather than visual.
- **There is no caption primitive**, so the caption composition and the graphic composition are both hand-authored HTML in the same assembled page. Nothing in `hyperframes check` compares them. The audits check legibility and layout, never *content redundancy* — this gate has no automated backstop and must be run deliberately.
- **The graphic's own text can be bound to a variable** (`data-var-text` on the element, overridden per host with `data-variable-values`), which means the design document can hold the exact string the audit measured, and the composition reads it rather than re-typing it. That is the cheapest way to stop a graphic drifting into prose after the audit passed.
- **Sub-compositions cannot reach across the boundary** — a sub-comp timeline cannot animate host-root elements and selectors do not resolve across it. So the caption sub-comp and a graphic sub-comp genuinely cannot coordinate at runtime; the coordination is entirely at design time, in the two design documents. That is a reason to run the cross-check as a document-level pass, exactly as [[sub-caption-graphic-collision]] does for geometry.
- **Cutting a graphic is free; the vault cannot delete files.** The mounted vault folder cannot remove files, so "cut it" means removing the host slot from `index.html` and marking the sub-composition superseded — not deleting the file. Note it in the design doc rather than expecting a clean tree.

**Remotion.** The same audit; the transcript and the design documents are the artefacts, and neither is framework-specific.

## Pairs with
[[gfx-structure-duplicates-prose-does-not]] · [[gfx-attention-budget-simultaneity]] · [[gfx-channel-decision-procedure]] · [[sub-caption-role-decision]] · [[sub-caption-graphic-collision]] · [[motion-explainer-beat-animation]] · [[motion-graphics-broll-slot]] · [[motion-abstract-concept-card]] · [[motion-progressive-information-build]] · [[struct-name-define-demonstrate]] · [[pace-visual-variety-density-audit]] · [[sfx-second-sense-doctrine]] · [[gfx-vertical-grid-and-margins]]

## Failure modes
- **The graphic restates the caption.** Three copies of one sentence, and the graphic band — the most valuable third of a vertical frame — spent on the least valuable content available.
- **Cutting the caption instead of the graphic.** The caption's redundancy is licensed; the graphic's is not. If something has to go, it is the graphic. And if there is an accessibility obligation, the caption is not negotiable at all.
- **Reviewing by feel.** Redundant text is preferred and measures worse. This is the one place where "it feels clearer" is positive evidence of a problem.
- **A graphic with no named job.** If nobody can say which of structure, quantity, relation, comparison or referent it carries, it carries none of them.
- **Emphasis by repetition.** Putting the sentence on screen to stress it. Stress belongs to the voice, to a punch-in, to a caption emphasis mark, or to silence — all of which are cheaper and none of which is a third copy.
- **A paragraph on screen.** More than about eight words in a non-quote graphic is a paragraph, and a paragraph cannot be read at 13 characters per second while somebody is talking.
- **Treating a concept card as information.** It is recognisability and pacing. Declare it and pay for it honestly.
- **Assuming the tool will catch it.** `check` measures legibility, layout, motion and contrast. It has no concept of content redundancy and never will.
- **Known gap:** the redundancy research is on *learning* outcomes in instructional contexts, measured on retention and transfer tests. Short-form retention editing optimises a different objective — watch time — and it is genuinely possible that a redundant graphic that costs comprehension buys attention. The library's position is that the cost is measured and the benefit is not, so the burden of proof sits with the redundant graphic. Where a channel has real retention data showing otherwise, that data beats this note.
