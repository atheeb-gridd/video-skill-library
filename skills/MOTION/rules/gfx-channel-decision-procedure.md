---
id: gfx-channel-decision-procedure
title: Does this beat need a graphic? — the decision procedure from transcript beat to named component
skill: motion
type: graphic
family: channel-discipline
tags: [skill/motion, type/graphic, family/channel-discipline, engine/hyperframes, engine/remotion, source/editing-kt, source/editing-kt-2, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:15"
    quote: "But if there's genuinely nothing else you could put on screen, captions are often still better than nothing."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:16"
    quote: "So in this video, we're gonna dive into 10 important editing cuts every filmmaker should know."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:24"
    quote: "Sound is half of your video."
research_refs:
  - https://edtechuvic.ca/wp-content/uploads/sites/11/2022/09/principles-for-reducing-extraneous-processing-in-multimedia-learning-coherence-signaling-redundancy-spatial-contiguity-and-temporal-contiguity-principles.pdf
  - https://journals.sagepub.com/doi/abs/10.1518/hfes.46.3.567.50405
  - https://link.springer.com/content/pdf/10.1007/s10648-018-9435-9.pdf
  - https://www.cambridge.org/core/books/abs/multimedia-learning/segmenting-principle/37240877DDA0362355ADB39936027982
  - https://legibility.info/rules-for-text-in-videos
difficulty: high
detectable_from: transcript+video
---

# Does this beat need a graphic? — the decision procedure from transcript beat to named component

## What it is

A **procedure**, not a heuristic. Input: one beat of the transcript with word-level timings. Output: either `none`, or a named component from the library with its slot and its dwell. It is deterministic enough that two people running it on the same beat should get the same answer, and that is the point — "does this need a graphic" is currently the most-guessed decision in the pipeline and it is guessable in both directions.

It runs **after** the cut design (motion attaches to cuts) and **before** the sound pass (the sound pass is derived from the motion manifest). It is the front half of `design-motion.md`: this note decides *whether and which*, and the component notes decide *how*.

### The procedure

```
STEP 0  SEGMENT. One beat = one clause-or-sentence group with a single payload.
        Use the transcript's own sentence boundaries; split further at "and then",
        "but", "which means", "so". A beat is typically 3-15 s.

STEP 1  CLASSIFY THE PAYLOAD. Exactly one of seven:
          STRUCTURE   how many parts, which order, which is current
          QUANTITY    a magnitude, a share, a change, a comparison of sizes
          RELATION    A causes / contains / feeds / precedes B
          COMPARISON  two named things differing in a named dimension
          REFERENT    "this" - a screenshot, a waveform, a chart, a clip, a face
          NAMING      an abstract concept being introduced by name
          PROSE       an argument, an aside, a transition, a joke, a reassurance
        PROSE  ->  no graphic. STOP. Give the time to the footage or the pause.

STEP 2  IS THERE REAL FOOTAGE THAT SAYS IT?  If a shot, a screen recording or a
        piece of stock carries the payload, use that instead - it is cheaper and
        reads as more real. A motion graphic of a person opening a laptop is
        worse than a shot of a person opening a laptop. STOP.

STEP 3  COVER TEST. Draft the graphic in one line. Cover it. Does the viewer lose
        information? If not, STOP - it is decoration.

STEP 4  REDUNDANCY TEST. Take the graphic's intended words and run the three
        checks: finite verb? >= 4 words? substring of the spoken transcript within
        +/-2s? Two or more YES -> reduce to a <=3-word structural marker, convert
        to structure, or STOP.

STEP 5  ATTENTION BUDGET. Is a caption live? Is a face in shot? Is another READ
        object live? Apply the resolution order (shorten the caption, move into a
        speech gap, convert READ to RECOGNISE, suppress the caption, remove the
        face, cut the graphic). If nothing works, STOP.

STEP 6  ROUTE TO A COMPONENT. Table below.

STEP 7  BUDGET CHECK ACROSS THE VIDEO. Graphics per minute, full-frame cards per
        minute, transients per 10 s, distinct components used. If any ceiling is
        exceeded, cut the weakest surviving graphic - not the newest.

STEP 8  EMIT THE ROW for design-motion.md: beat id, payload class, component,
        slot, in-point, dwell, entrance, exit, sound event, acceptance test.
```

### The routing table

| Payload | Trigger in the transcript | Component | Note |
|---|---|---|---|
| STRUCTURE — position in a counted set | "number two", "first… then", "step three" | Item marker | [[motion-list-item-marker-card]], [[gfx-progress-step-indicator]] |
| STRUCTURE — the whole set at once | "there are five layers", "it breaks down into" | List card | [[gfx-list-card-enumeration]] |
| QUANTITY — one number | a numeral with a unit, spoken | Stat card | [[gfx-stat-card-layout]], [[motion-number-rollup-stat-reveal]] |
| QUANTITY — a share of a whole | "half of", "a third", "most of" | Concept card with a proportion visual | [[motion-abstract-concept-card]] |
| QUANTITY — a change over time | "went from X to Y", "grew" | Stat card with a delta, or a chart | [[gfx-stat-card-layout]] |
| RELATION — a mechanism or chain | "because", "which means", "so then" | Diagram, built in stages | [[gfx-diagram-node-geometry]], [[gfx-diagram-connector-geometry]], [[motion-progressive-information-build]] |
| RELATION — two tracks in time | a J or L cut, an offset, a lead/lag | Two-track diagram | [[motion-two-track-offset-diagram]] |
| COMPARISON — two options, several attributes | "on one hand… on the other", "versus" | Comparison card | [[gfx-comparison-two-column-card]] |
| COMPARISON — two frames of the same shot | a match cut, a before/after of framing | Filmstrip strip | [[motion-filmstrip-comparison-strip]] |
| REFERENT — a UI, a document, a chart | "look at this", "here's the panel" | The asset itself + annotation | [[gfx-annotation-mark-set]], [[motion-annotation-draw-on]] |
| REFERENT — audio | "listen to the waveform" | Waveform overlay | [[motion-waveform-teaching-overlay]] |
| REFERENT — somebody else's clip | a quoted film or video | Inset clip + attribution label | [[motion-attribution-label-inset-clip]] |
| REFERENT — a person's words | "he said", a pull-quote | Quote card | [[gfx-quote-card]] |
| NAMING — an abstract concept | "this is called", a term being defined | Concept card, or a term label | [[motion-abstract-concept-card]], [[gfx-label-callout-over-footage]] |
| NAMING — a person, place, role | an introduction, a location | Lower third | [[gfx-lower-third-anatomy]] |
| NAMING — the one-word topic | an isolated word after a curiosity gap | One-word topic card | [[motion-single-word-topic-card]] |
| PROSE — but it is the thesis | the closing aphorism, a claim to be stated | Statement card | [[gfx-full-frame-statement-card]], [[motion-closing-thesis-title-card]] |
| PROSE — anything else | — | **none** | Give the time back |

**The two escape hatches, both from the reference material.** First: *"if there's genuinely nothing else you could put on screen, captions are often still better than nothing"* — an empty visual slot is worse than a redundant one, so a beat that survives to STEP 6 with no route and no footage may take a caption rather than a graphic, and that is a **subtitles** decision ([[sub-caption-role-decision]], [[motion-broll-slot-tier-selection]]). Second: a card may be a **declared illustration** — recognisability and pacing rather than information — provided the design document says so and pays for the screen time honestly.

**Why the order matters.** Every step is cheaper than the one after it. Classifying a payload costs a sentence; measuring the attention budget costs a table; building a diagram costs hours. A procedure that puts the component choice first is a procedure that builds things and then discovers they were not needed, which is where most of the wasted effort in motion design lives.

## When to use it

- **Once per beat, on the whole transcript, in one pass**, producing the beat table that `design-motion.md` is built from. Not per graphic as it occurs to somebody.
- **After `design-cuts.md` exists**, because STEP 2 asks what footage is available and STEP 5 asks what the frame already contains.
- **Again after any script change.** A beat's payload class can change with one clause.
- **In reverse, during Mode A**, to profile a reference: classify every graphic you find by which payload it carries and see whether the channel has a routing discipline or a habit.
- **Not** as a licence to fill every beat. A healthy pass returns `none` for most beats. If it returns a component for more than about half, the classification is being generous.

## How to recognise it in a reference video

You are looking for evidence that a *procedure* exists, not that graphics exist.

- **Build the payload census.** Classify every graphic in the reference by its payload class and count. A channel with a procedure shows a **concentrated** distribution — mostly REFERENT and STRUCTURE, or mostly RELATION and QUANTITY. A flat distribution across all seven, or a large PROSE bucket, means graphics are being added by feel.
- **Count the `none` beats.** Segment the transcript and count beats with no graphic. **50–80 %** is a healthy channel. Under 30 % means the frame never rests.
- **Check the component inventory.** How many *distinct* component types across the whole video? **3–6** is a system; 10+ is a template library; 1–2 with a long runtime means the channel found one thing that works.
- **Check for the same payload getting the same component.** Find two beats with the same payload class and compare their graphics. Same component ⇒ routing. Different components ⇒ each beat was designed from scratch, which is expensive and reads as inconsistent.
- **Check the footage-first rule.** Find a beat where real footage existed and a graphic was used anyway (a motion graphic of a laptop opening). Those are the beats that expose whether STEP 2 was ever run.
- **Measure graphics per minute** and full-frame cards per minute. The library's own ceilings: **≤1.3 full-frame cards per minute** ([[motion-abstract-concept-card]]), **4–8 attention transients per 10 s** across all sources ([[motion-attention-transient]]), **1–3 concurrent non-caption elements** ([[motion-overlay-stack-choreography]]).
- **Check the dwell arithmetic.** For each graphic, `chars ÷ 13` against actual on-screen time, multiplied by 2.5 where a caption was live. Systematic under-dwelling means the graphics were placed on the timeline rather than budgeted.
- **Check the entrance offsets against the transcript.** In a routed design each graphic's entrance lands within **±0.2 s** of the word that motivates it. Arbitrary offsets mean the graphics were laid in afterwards.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `beat_length` | 3–15 s | 2–25 s | One clause group with a single payload. |
| `payload_classes` | 7 | 7 | Structure, quantity, relation, comparison, referent, naming, prose. |
| `none_rate` | 60 % | 50–80 % | Share of beats returning no graphic. Under 30 % means the frame never rests. |
| `footage_first` | required | — | STEP 2. Real footage beats a built graphic whenever it carries the payload. |
| `cover_test` | required | — | STEP 3. Cover it; the viewer must lose information. |
| `redundancy_test` | 3 checks, ≥2 fails ⇒ reject | — | STEP 4. Finite verb / ≥4 words / substring of concurrent speech. |
| `budget_check` | required | — | STEP 5. Caption live? Face in shot? Another READ object? |
| `graphics_per_minute` | 3 | 1–6 | Components, not marks. |
| `full_frame_cards_per_minute` | ≤1.3 | ≤1.3 | Above this the format flips from punctuated to card-driven. |
| `transients_per_10s` | 4–8 | 2–12 | All sources: cuts, entrances, punch-ins, caption emphasis. |
| `distinct_components` | 4 | 3–6 | Across the whole video. 10+ is a template library, not a style. |
| `entrance_offset_from_word` | +0.2 s | −0.3 to +0.5 s | Graphic slightly after the word that motivates it, never long before. |
| `dwell` | max(2.5 s, chars ÷ 13) | ≥2.5 s | ×2.5 if a caption is live ([[gfx-attention-budget-simultaneity]]). |
| `stage_interval` | 1.2–3.0 s | 0.8–4.0 s | For a multi-stage build; each stage lands on its own word. |
| `declared_illustration` | allowed, must be labelled | — | Recognisability and pacing rather than information. Costs the same screen time. |
| `empty_slot_fallback` | caption | — | An unfilled visual slot is worse than a redundant one; route it to the caption layer. |
| `cut_the_weakest` | required | — | When a ceiling is exceeded, cut the weakest surviving graphic, not the newest. |

## Reproduction prompt

```
Produce the beat table for {{PROJECT}}'s design-motion.md. Inputs: the word-level
transcript, design-cuts.md, design-subtitles.md, and the shot/B-roll list.

For every beat in the transcript, run these eight steps IN ORDER and stop at the
first STOP. Record the step number you stopped at, so a reviewer can see why a
beat has no graphic.

STEP 0  SEGMENT. One beat = one clause group with a single payload. Split at
        sentence boundaries and at "and then", "but", "which means", "so".
        Typically 3-15s.

STEP 1  CLASSIFY THE PAYLOAD as exactly one of:
          STRUCTURE / QUANTITY / RELATION / COMPARISON / REFERENT / NAMING / PROSE
        PROSE -> no graphic. STOP. (Exception: if this beat is the thesis or the
        closing aphorism, route it to a statement card.)

STEP 2  FOOTAGE FIRST. If a real shot, screen recording or stock clip carries the
        payload, use that. It is cheaper and reads as more real. STOP.

STEP 3  COVER TEST. Write the graphic in one line, cover it, and ask whether the
        viewer loses information. If not, STOP - it is decoration.

STEP 4  REDUNDANCY TEST on the graphic's intended words:
          T1 finite verb?  T2 >= 4 words?  T3 substring of spoken text +/-2s?
        Two or more YES -> reduce to a <=3-word structural marker, convert to
        structure (a number, a row, a node), or STOP.

STEP 5  ATTENTION BUDGET. If a caption is live, a face is in shot, or another READ
        object is live, apply the resolution order: shorten the caption to <=3
        words -> move the graphic into a speech gap >= 0.4s -> convert READ to
        RECOGNISE -> suppress the caption (only if the graphic carries the words)
        -> remove the face -> cut the graphic.

STEP 6  ROUTE TO A COMPONENT using the payload:
          position in a counted set      -> item marker / step indicator
          the whole set at once          -> list card
          one number with a unit         -> stat card
          a share of a whole             -> concept card, proportion visual
          a change over time             -> stat card with delta, or a chart
          a mechanism or causal chain    -> diagram, built in stages
          two tracks offset in time      -> two-track diagram
          two options, several attributes-> comparison card
          two frames of one shot         -> filmstrip strip
          a UI / document / chart        -> the asset itself + annotation marks
          audio                          -> waveform overlay
          somebody else's clip           -> inset clip + attribution label
          a person's words               -> quote card
          an abstract concept named      -> concept card, or a label callout
          a person / place / role         -> lower third
          an isolated one-word topic     -> one-word topic card
          the thesis                     -> statement card

STEP 7  BUDGET ACROSS THE VIDEO. Check: <= 1.3 full-frame cards per minute; 4-8
        attention transients per 10s across ALL sources; 1-3 concurrent
        non-caption elements; 3-6 distinct component types total; 50-80% of beats
        returning none. If a ceiling is exceeded, cut the WEAKEST surviving
        graphic, not the newest.

STEP 8  EMIT THE ROW: beat id | in/out | payload class | stop step | component |
        slot | in-point (absolute seconds, computed from the word timing) | dwell |
        entrance | exit | sound event | acceptance test.

For every graphic, the in-point is the motivating word's timestamp + 0.20s, and
the dwell is max(2.5s, chars/13), multiplied by 2.5 if a caption is live.

ACCEPTANCE TEST:
(a) every beat has a row, including the ones with no graphic, with the stop step
    recorded;
(b) the none-rate is between 50% and 80%;
(c) every graphic's payload class appears in the routing table and maps to the
    component chosen;
(d) two beats with the same payload class use the same component;
(e) all four video-level ceilings in STEP 7 hold;
(f) every in-point is within -0.3s to +0.5s of its motivating word, checked
    against the word-level transcript;
(g) every graphic has a sound event named, or is explicitly tiered as
    deliberately silent.
```

## Execution spec

**The output of this note is a table, and the table is what becomes `index.html`.** Each row with a component becomes one host slot; each row without one becomes nothing, which is the point.

```html
<!-- one row of the beat table, realised. data-start comes from the transcript. -->
<div id="el-b17-diagram" data-composition-id="diagram"
     data-composition-src="compositions/diagram.html"
     data-start="128.62" data-duration="9.0" data-track-index="3"
     data-variable-values='{"nodes":"Request|Queue|Worker","focus":"1"}'></div>
```

Contract facts that shape the procedure rather than just its output:

- **All authored time is in seconds; there is no frame-based attribute.** Convert frame counts at authoring time and keep them as comments. `data-fps` is a hint the CLI can override.
- **Author absolute `data-start` values, computed from `transcript.json`.** Relative timing (`data-start="prev + 2"`) has four documented silent failures — spaces around the operator are required, an unresolved reference resolves to `0`, a target without a resolvable duration lands on the target's *start*, and a cycle resolves to `0` — and **nothing in lint checks any of them**. For beat-aligned graphics that means a mistimed graphic with no error.
- **The visibility window is half-open**, `[start, start + duration)`, so two beats can be authored back to back with no overlapping frame, and an animation's resolved end state must land slightly *before* `data-duration`.
- **Modularise once there are three or more scene cuts.** *"If a monolithic project is approaching three or more scene cuts, prefer modularizing before adding the next scene."* A beat table with six components is already a modular project: one sub-composition per component type, instanced per beat with `data-variable-values`.
- **Root `data-duration` is compile-time-locked** and cannot be changed by a script or `--variables`. The beat table therefore has to be complete before the root is written, or the tail gets cut off.
- **The plan layer is real and parsed.** `STORYBOARD.md` is read by `@hyperframes/core/storyboard` into a `StoryboardManifest`, with per-frame keys `status` (`outline` → `built` → `animated`), `src`, `duration`, `transition_in`, `scene`, `voiceover`, `poster`, and unknown keys preserved under `extra`. That is the right home for the beat table before anything is built ([[motion-storyboard-motion-spec]]).
- **Review feedback has a documented shape** — `.hyperframes/frame-comments.json` with `pass` and `comments[].{frame,src,title,text}` — whose contract is *"revise exactly the frames named, delete the file, re-present."* **That delete step cannot be performed in this vault**, which cannot delete files. Use a superseding `pass` marker instead and say so in the design doc.
- **Every graphic needs a sound event or an explicit silent tier.** The sound pass is derived from the motion manifest, so a beat table missing a component invalidates a fetch that has already happened — which is why this procedure runs before the sound pass and not alongside it ([[motion-sfx-pass-manifest]], [[motion-silent-motion-tier]]).

**ffmpeg — the inputs the procedure needs measured:**

```bash
# speech gaps for STEP 5's "move it into a pause"
ffmpeg -i mix.wav -af "silencedetect=noise=-32dB:d=0.35" -f null - 2> /tmp/d/gaps.txt
# shot boundaries, so a graphic can be placed with a cut rather than against one
ffmpeg -i ref.mp4 -vf "scdet=threshold=8" -f null - 2> /tmp/d/cuts.txt
# transient census for STEP 7
ffmpeg -i ref.mp4 -vf "select='gt(scene,0.15)',metadata=print" -f null - 2> /tmp/d/trans.txt
```

**Remotion.** The beat table becomes a list of `<Sequence from={...} durationInFrames={...}>` entries; the procedure is upstream of any framework.

## Pairs with
[[gfx-three-channel-division-of-labour]] · [[gfx-structure-duplicates-prose-does-not]] · [[gfx-attention-budget-simultaneity]] · [[motion-storyboard-motion-spec]] · [[motion-broll-slot-tier-selection]] · [[motion-explainer-beat-animation]] · [[motion-progressive-information-build]] · [[motion-sfx-pass-manifest]] · [[motion-silent-motion-tier]] · [[motion-attention-transient]] · [[sub-caption-role-decision]] · [[pace-visual-variety-density-audit]] · [[pace-subtractive-first-pass]] · [[struct-name-define-demonstrate]] · [[gfx-list-card-enumeration]] · [[gfx-comparison-two-column-card]] · [[gfx-stat-card-layout]]

## Failure modes
- **Choosing the component first.** The expensive decision made before the cheap ones, so the cheap ones are never run and the graphic gets justified after the fact.
- **A generous classifier.** Everything can be argued into RELATION if you try. The test is whether the relation is *between named things the beat actually names*.
- **Skipping STEP 2.** Building a graphic for a beat that has real footage. The most expensive single mistake in the procedure.
- **A `none` rate under 30 %.** The frame never rests, the transient budget blows out, and each graphic means less than the last.
- **Ten distinct components.** A template library rather than a style. The viewer never learns the grammar because there is no grammar.
- **Placing graphics on the timeline instead of on words.** Entrance offsets scattered rather than clustered at ±0.2 s of a motivating word.
- **Under-dwelling.** `chars ÷ 13` is a floor and it doubles-and-a-half under a live caption. A card that cannot afford its dwell is a card that should not exist.
- **Cutting the newest graphic when a ceiling is hit.** Recency is not weakness. Rank them and cut the weakest.
- **Running the procedure before the cut design.** STEP 2 and STEP 5 both need to know what is already on screen.
- **Running it after the sound pass.** The sound pass is derived from the motion manifest; changing the manifest invalidates the fetch.
- **Treating the "captions are better than nothing" escape hatch as a general permission.** It applies to a beat that reached STEP 6 with no route *and* no footage — a genuinely empty slot, not a beat somebody did not want to design for.
- **Known gap:** the procedure has no automated implementation in this project. It is a document pass over `transcript.json` and the design docs, and every ceiling in STEP 7 has to be counted by hand or by a throwaway script. Nothing in `hyperframes check` measures any of it — the audits cover lint, runtime, layout, motion and contrast, and have no concept of payload, redundancy or budget.
