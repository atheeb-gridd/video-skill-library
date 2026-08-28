---
id: gfx-structure-duplicates-prose-does-not
title: Structure may be duplicated, prose may not — resolving the on-screen ordinal against the redundancy effect
skill: motion
type: graphic
family: channel-discipline
tags: [skill/motion, type/graphic, family/channel-discipline, engine/hyperframes, engine/remotion, source/editing-kt-2, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:45"
    quote: "Number two, the jump cut."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:35"
    quote: "Number nine is cross cutting."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:16"
    quote: "So in this video, we're gonna dive into 10 important editing cuts every filmmaker should know."
research_refs:
  - https://edtechuvic.ca/wp-content/uploads/sites/11/2022/09/principles-for-reducing-extraneous-processing-in-multimedia-learning-coherence-signaling-redundancy-spatial-contiguity-and-temporal-contiguity-principles.pdf
  - https://bjorklab.psych.ucla.edu/wp-content/uploads/sites/13/2016/07/YueBjorkBjork2013_redundancy.pdf
  - https://journals.sagepub.com/doi/abs/10.1518/hfes.46.3.567.50405
  - https://link.springer.com/content/pdf/10.1007/s10648-018-9435-9.pdf
  - https://en.wikipedia.org/wiki/Dual-coding_theory
difficulty: high
detectable_from: transcript+video
---

# Structure may be duplicated, prose may not — resolving the on-screen ordinal against the redundancy effect

## What it is

This library contains what looks like a direct contradiction, and it has to be resolved explicitly rather than left for an executing agent to trip over.

- **[[motion-list-item-marker-card]]** — *"Mark every list item twice — spoken ordinal plus an identical on-screen card"* — **prescribes** duplication. Its own words: *"The redundancy is the point."*
- **[[gfx-three-channel-division-of-labour]]** — carrying a median effect size of **d = 0.86 across 16 studies, supported 16 of 16** against redundant on-screen text — **prohibits** duplication.

Both are right. They are talking about different things, and the boundary between those things is not a matter of degree; it is a named boundary condition in the same body of research that produced the prohibition.

### The boundary, with the numbers on both sides

The redundancy principle has three documented boundary conditions, and the second one is exactly this case:

> **When only brief words or phrases are added, positioned near the graphic, redundancy aids retention without hurting transfer — effect sizes d = 0.47 to 0.70 for retention.**

The other two, for completeness: high-experience learners have spare capacity and do not suffer; and with **no graphic present**, printed plus spoken words beats spoken alone (`d = 0.24`), because the visual channel is not being overloaded.

So the literature does not say "never duplicate". It says: **a full-length duplicate of the narration, competing with a graphic for the visual channel, costs you `d ≈ 0.86`. A brief word or phrase placed next to the graphic buys you `d ≈ 0.47–0.70`.** Those are opposite signs, and the thing that flips the sign is **length and function**, not intention.

### The two categories, defined so a machine can tell them apart

| | **Structural marker** — duplication licensed | **Prose duplication** — forbidden |
|---|---|---|
| What it is | An ordinal, a count, a name, a label, a quantity, a state | A clause or sentence lifted from the narration |
| Length | ≤3 words | 4+ words, or any finite verb |
| Grammar | No finite verb. A noun phrase, a numeral, or a bare label | Subject + verb; it can be read aloud as a sentence |
| What it does | Answers "where am I / which one / how many" **at any random frame** | Repeats what was just said |
| Timing | Lands **as** the speaker says it — that co-timing is the point | Persists across the sentence it copies |
| Why it helps | Reinforcement plus a scrub-readable progress signal for a viewer who is half-listening | It does not; it splits the visual channel |
| Research | Redundancy boundary condition 2: `d = 0.47–0.70` for retention | Redundancy principle: `d = 0.86` against |

**"Number two, the jump cut" spoken, with `2` and `The jump cut` on a card, is a structural marker.** Two words and a numeral, no verb, co-timed with the speech, and it answers "which item is this" for a viewer who scrubbed in, looked up from their phone, or is listening while cooking.

**"Number two, the jump cut, which cuts out the boring middle of a take" spoken, with *"The jump cut cuts out the boring middle of a take"* on screen, is prose duplication.** Ten words, a finite verb, and it is the sentence.

The marker card note already knew this, and its own parameters enforce it: `label_words` **3**, range 1–5, with the explicit rule *"the item's name, not its definition"*, and a failure mode named **"Label carrying the definition"** — *"Number 3: the match cut, which matches shape, colour or framing" cannot be read in 3.5 s.* The two notes were never in conflict; the boundary was implicit in one and unstated in the other. This note states it.

### Why co-timing matters, and why it is not the same as duplication

The marker arriving **within ±0.5 s of the spoken ordinal** is doing something a delayed marker does not: it binds the visual token to the auditory token as one event. That is the temporal-contiguity principle, which carries the largest median effect in the set — **`d = 1.22` across 9 studies, 9 of 9 supported**. A marker that arrives two seconds after the word is not reinforcement; it is a second, separate event, and it costs a second attention transient for nothing.

And **placement matters as much as brevity.** The boundary condition specifies brief words *positioned near the graphic*. That is the spatial-contiguity principle, meta-analysed at **`g = 0.63` across 58 comparisons (n = 2426)**, and in the same family as the `d = 1.10` figure from the reducing-extraneous-processing review. A structural marker parked in a legend, a corner, or a caption band far from the thing it marks loses most of its benefit. The ordinal belongs **on** the card, the node label **inside** the node, the unit **beside** the number.

## When to use it

- **Every time a graphic contains words that are also spoken.** Which is most of the time, and it is the single most common thing an executing agent has to adjudicate.
- **When writing the item-marker system**, alongside [[motion-list-item-marker-card]] — this note is the licence that makes that note legal, and it should be cited there.
- **When a reviewer asks for "the key point on screen".** That request is almost always a request for prose duplication, and the correct counter-offer is a three-word label or a structural mark.
- **When a caption emphasis mark and a graphic label would carry the same word.** Then it is duplicated *twice* and one of the two has to go — usually the graphic, because the caption layer owns word-level emphasis ([[sub-emphasis-caption-three-words]], [[sub-emphasis-selection-rule]]).
- **Not** as permission to add markers freely. A structural marker is licensed, not free: it still costs an attention transient, it still competes for the graphic band, and the marker-card note's own ceiling of **one marker form per video** applies.

## How to recognise it in a reference video

The test is mechanical and runs on the transcript plus one frame per graphic. **Three questions; two or more "yes" answers means prose duplication.**

1. **Does the on-screen text contain a finite verb?** (`is`, `are`, `was`, `does`, `means`, `causes`, `makes`, `gets`, any `-s` third-person form, any modal.) Structure and quantity do not need verbs.
2. **Is it 4 or more words?**
3. **Is it a substring — or a near-substring, allowing for a dropped article — of the spoken transcript within ±2 s of its window?**

A `yes/yes/yes` is unambiguous. A `no/no/yes` is the licensed case: a short label or ordinal appearing as it is spoken. A `yes/no/no` (a two-word phrase with a verb, like `IT WORKS`) is a statement card or an emphasis mark, judged by its own note.

Then measure the aggregates:

| Measure | Structural | Prose |
|---|---|---|
| Median words per graphic | 1–3 | 6+ |
| Finite verbs across all graphics | 0 (excluding quote/statement cards) | ≥1 per graphic |
| Offset from the co-spoken word | −0.3 to +0.5 s | Arbitrary; often mid-sentence |
| Persistence relative to the sentence | Arrives on the word, holds through the item | Tracks the clause |
| Position relative to the thing it marks | On it, in it, or beside it | In a corner, a legend, or a separate band |
| Template identity across instances | Pixel-identical apart from the number and the label | Each one different, because each sentence is different |

That last row is the cheapest single discriminator and it needs no transcript at all: **difference two instances of the graphic.**

```bash
ffmpeg -i m_item2.png -i m_item7.png -filter_complex "blend=all_mode=difference" -update 1 d.png
```

Everything except the number and the label must cancel. A structural marker is a **template**; prose duplication cannot be a template, because the prose changes every time.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `marker_max_words` | 3 | 1–4 | Above 4 the licence lapses. Matches [[motion-list-item-marker-card]]'s `label_words` of 3. |
| `finite_verb_permitted` | no | — | Except in a quote card or a statement card, where the sentence is the content. |
| `substring_of_speech_permitted` | yes, for markers | — | This is the licensed redundancy. It is *why* the marker works. |
| `substring_of_caption_permitted` | no, beyond 3 words | — | Beyond marker length it is the third copy. |
| `co_timing_window` | −0.3 to +0.5 s | ±0.5 s | Relative to the spoken token. Temporal contiguity: `d = 1.22`, 9/9 studies. |
| `proximity` | on / in / beside the referent | — | Spatial contiguity: `g = 0.63` over 58 comparisons (n = 2426). A marker in a legend loses most of the benefit. |
| `marker_categories` | ordinal, count, name, label, quantity, state | 6 | The closed list of what a structural marker may be. |
| `template_identity` | pixel-identical | required | Only the number and the label differ between instances. |
| `markers_per_item` | 1 | 1 | One marker form per video, applied to every item ([[motion-list-item-marker-card]]). |
| `expected_gain` | `d ≈ 0.47–0.70` retention | — | Redundancy boundary condition 2: brief words positioned near the graphic. |
| `expected_cost_if_prose` | `d ≈ 0.86` against | — | Redundancy principle, median over 16 studies, 16/16 supported. |
| `reject_rule` | ≥2 of 3 tests positive | — | Finite verb / ≥4 words / substring of concurrent speech. |
| `double_duplication_check` | required | — | If the caption emphasis layer already marks the word, the graphic must not. |
| `partial_application` | forbidden | — | If item 3 gets a marker, every item does. A marker on 7 of 10 items is worse than none ([[sub-semantic-colour-assignment]]'s category-coverage rule, applied to structure). |

## Reproduction prompt

```
Adjudicate every graphic in {{PROJECT}} whose words are also spoken. Inputs: the
word-level transcript and design-motion.md.

THE RULE, stated once: STRUCTURE MAY BE DUPLICATED, PROSE MAY NOT.
  A STRUCTURAL MARKER is an ordinal, a count, a name, a label, a quantity or a
  state - three words or fewer, no finite verb - that appears AS the speaker says
  it and answers "which one / where am I / how many" at any random frame. This is
  scaffolding, and the research licenses it: brief words positioned near the
  graphic aid retention, d = 0.47-0.70.
  PROSE DUPLICATION is a clause from the narration set on screen. The research
  measures against it: median d = 0.86 across 16 studies, supported 16 of 16, and
  identical on-screen text scored significantly worse than abridged text
  (d = 0.95 recall) while being PREFERRED by learners.
  They are different things, not two points on a scale.

1. FOR EACH GRAPHIC, run three tests on its on-screen text:
     T1  does it contain a finite verb? (is/are/was/does/means/causes/makes,
         any third-person -s form, any modal)
     T2  is it 4 or more words?
     T3  is it a substring (allowing dropped articles) of the spoken transcript
         within +/-2s of the graphic's window?
   TWO OR MORE YES  -> prose duplication. Reduce it to a 3-word label, convert it
                       to structure (a number, a diagram, a row), or cut it.
   ONLY T3 YES      -> licensed structural marker. Keep it.
   ONLY T1 YES      -> a statement or quote card. Judge it by its own note.

2. FOR EVERY SURVIVING MARKER, enforce the two things that make the licence real:
     CO-TIMING: it lands within -0.3s to +0.5s of the spoken token. Temporal
       contiguity is the largest effect in this literature (d = 1.22, 9/9). A
       marker two seconds late is not reinforcement, it is a second event.
     PROXIMITY: it sits ON, IN or BESIDE the thing it marks - the ordinal on the
       card, the label inside the node, the unit next to the number. Spatial
       contiguity: g = 0.63 over 58 comparisons. A marker in a legend or a far
       band loses most of the benefit.

3. ENFORCE TEMPLATE IDENTITY. Build the marker ONCE as a parameterised
   sub-composition taking NUMBER and LABEL, and instance it. Every instance must
   be pixel-identical apart from those two strings. This is also the sharpest
   audit: difference two instances and only the number and label may differ.
   Prose cannot be a template, because the prose changes every time.

4. ENFORCE FULL COVERAGE. If any item carries a marker, EVERY item does. A marker
   on 7 of 10 items destroys the progress read it exists to provide.

5. CHECK FOR DOUBLE DUPLICATION. If the caption emphasis layer already marks the
   same word, the word is now on screen twice plus spoken. Drop the graphic; the
   caption layer owns word-level emphasis.

6. WRITE THE RESOLUTION into design-motion.md so a later reviewer does not
   "fix" it: cite this note beside the item-marker note, and state that the
   ordinal's redundancy is deliberate and licensed.

ACCEPTANCE TEST:
(a) zero graphics fail two or more of T1/T2/T3;
(b) every marker's offset from its spoken token is within -0.3s to +0.5s,
    measured from the word-level transcript;
(c) differencing any two marker instances leaves only the number and the label;
(d) every item in the enumerated set has a marker - count them against the count
    promised in the intro;
(e) no word appears simultaneously as a caption emphasis mark and as a graphic
    label.
```

## Execution spec

**The marker is a parameterised sub-composition, instanced once per item.** This is the mechanism that makes template identity a property of the build rather than a discipline, and it is already specified in full in [[motion-list-item-marker-card]] — the pieces that matter to *this* note are the two attributes that keep the string in one place and the timing honest.

```html
<!-- compositions/item-marker.html : declarations on <html>, root inside <template> -->
<html data-composition-variables='[
  {"id":"num","type":"string","label":"Number","default":"1"},
  {"id":"label","type":"string","label":"Item name","default":"The cut"}]'>
<template id="item-marker-template">
  <div data-composition-id="item-marker" data-width="1080" data-height="1920"
       data-duration="4.5" style="position:relative;width:1080px;height:1920px;overflow:hidden;">
    <style>
      [data-composition-id="item-marker"] .wrap{position:absolute; inset:0;
        display:flex; align-items:flex-end; justify-content:flex-start;
        padding:0 0 calc(30 * var(--u)) calc(6 * var(--w));}
      [data-composition-id="item-marker"] .num{font-size:var(--s6); line-height:.9;}
      [data-composition-id="item-marker"] .lbl{font-size:var(--s1);}
    </style>
    <div class="wrap">
      <div id="im-num" class="num" data-var-text="num">1</div>
      <div id="im-lbl" class="lbl" data-var-text="label">The cut</div>
    </div>
  </div>
</template>
</html>
```

```html
<!-- index.html : one host per item. data-start is the SPOKEN ordinal's timestamp + 0.20 -->
<div id="el-mk-02" data-composition-id="item-marker"
     data-composition-src="compositions/item-marker.html"
     data-start="45.40" data-duration="4.5" data-track-index="3"
     data-variable-values='{"num":"2","label":"The jump cut"}'></div>
```

Contract points that make this note's rules enforceable rather than aspirational:

- **`data-var-text` binds an element's own text to a scalar variable id** (children preserved), and **`data-variable-values`** overrides it per host instance. So the exact string the audit measured lives in **one** place — the host slot — and cannot drift into prose inside the sub-composition. `data-composition-variables` is a JSON **array of declarations** on `<html>`; render-time `--variables` is a JSON **object keyed by id**.
- **`data-start` in seconds is where co-timing is enforced.** There is no frame attribute; convert at authoring time. The spoken ordinal's word timing comes straight out of `transcript.json`, so `data-start = word.start + 0.20` is a computation, not a judgement. **Do not use relative timing here** — `data-start="prev-item + 30"` has four silent failure modes, every one of which resolves to `0`, and a marker at `t=0` is a marker that never lands on its word.
- **Proximity is a layout fact, so it is enforced by the sub-composition's own geometry**, not by the host. The ordinal and the label are siblings in one flex row inside the marker; nothing can separate them.
- **The three-copy check is computable at author time**, because caption timing is driven entirely by the inlined word array — *"There is no external transcript read at runtime."* The caption's exact words at the marker's `data-start` are known before anything renders.
- **Nothing in `check` compares content across compositions.** The audits cover lint, runtime, layout, motion and contrast. Redundancy has no automated backstop; this gate is a document pass.
- **A sub-comp timeline cannot animate host-root elements**, so everything the marker animates lives inside the marker. Keep ids prefixed (`#im-…`) to stay unique across the assembled page.
- **`fromTo`, never `from`**; `autoAlpha` on inner elements only; land the exit before `data-duration` (the window is half-open). **`snapshot --at <midpoints>` is required for projects with sub-compositions** — and it runs on the render host, not the authoring VM.

**ffmpeg — the template-identity audit**, which is the cheapest test in this note:

```bash
ffmpeg -ss 45.9 -i out.mp4 -frames:v 1 -q:v 2 /tmp/m/item2.png
ffmpeg -ss 276.1 -i out.mp4 -frames:v 1 -q:v 2 /tmp/m/item9.png
ffmpeg -i /tmp/m/item2.png -i /tmp/m/item9.png \
  -filter_complex "blend=all_mode=difference,eq=brightness=0.3" -update 1 /tmp/m/diff.png
```

**Remotion.** `<ItemMarker number label />` instanced inside `<Sequence>`s, with `from` computed from the transcript word timing. Same discipline; the props *are* the variables.

## Pairs with
[[motion-list-item-marker-card]] · [[gfx-three-channel-division-of-labour]] · [[gfx-channel-decision-procedure]] · [[gfx-attention-budget-simultaneity]] · [[gfx-list-card-enumeration]] · [[gfx-progress-step-indicator]] · [[motion-persistent-item-counter]] · [[struct-enumerated-promise-and-counter]] · [[struct-numbered-list-mid-roll-sponsor]] · [[sub-emphasis-caption-three-words]] · [[sub-emphasis-selection-rule]] · [[sub-list-marker-caption-lockup]] · [[motion-progressive-information-build]]

## Failure modes
- **Reading the marker-card note as a general licence to duplicate.** It licenses ordinals and three-word labels. It does not license the definition, and its own failure-mode list says so.
- **Reading the redundancy principle as a general prohibition.** It has three published boundary conditions and the brief-words-near-the-graphic one is precisely the marker case, with a positive effect size.
- **The label carrying the definition.** The single named failure of the marker card, and the exact point where structure becomes prose.
- **A late marker.** Arriving two seconds after the word turns reinforcement into a separate attention event, and temporal contiguity is the largest effect in this literature.
- **A marker in a legend or a far band.** Loses most of the spatial-contiguity benefit while keeping all of the cost.
- **Markers on some items.** Partial application destroys the progress read; the viewer cannot tell whether an unmarked item is item 4 or a digression.
- **Double duplication.** The same word as a caption emphasis mark *and* a graphic label. Spoken once, printed twice.
- **Prose that passes because it is short.** Three words with a finite verb — `IT SCALES BADLY` — is a claim, not a marker. Judge it as a statement card, which has its own ceiling of one or two per video.
- **Hand-built markers.** Placement drifts a few pixels per item and the video reads as sloppy though no single frame looks wrong. Correction: one parameterised sub-comp.
- **Known gap:** the effect sizes cited here come from instructional-media experiments on retention and transfer, with learners who were trying to learn. A short-form viewer is not that population, and the `d = 0.47–0.70` gain for brief adjacent words may be larger or smaller in a feed. What transfers with confidence is the *direction* and the *shape of the boundary* — brief and adjacent helps, long and concurrent hurts — not the exact magnitudes.
