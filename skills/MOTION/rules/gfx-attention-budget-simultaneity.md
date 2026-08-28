---
id: gfx-attention-budget-simultaneity
title: The attention budget — face, caption and graphic in one vertical frame, and what has to take turns
skill: motion
type: graphic
family: channel-discipline
tags: [skill/motion, type/graphic, family/channel-discipline, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:48"
    quote: "Next, layer a bunch of visual elements over your footage."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:02"
    quote: "Using captions to fill more space can get ugly fast and waste a great opportunity to put something more engaging on screen."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, timeline overlay"
    quote: "[NOT SPOKEN — observed on screen] A film clip, a stylised NLE timeline across the bottom, an attribution label top-left and a title card — never all four at once; the timeline runs while the clip plays and the labels take turns."
research_refs:
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
  - https://www.nature.com/articles/s41598-022-25268-1
  - https://www.cambridge.org/core/journals/behavioral-and-brain-sciences/article/magical-number-4-in-shortterm-memory-a-reconsideration-of-mental-storage-capacity/44023F1147D4A1D44BDC0AD226838496
  - https://edtechuvic.ca/wp-content/uploads/sites/11/2022/09/principles-for-reducing-extraneous-processing-in-multimedia-learning-coherence-signaling-redundancy-spatial-contiguity-and-temporal-contiguity-principles.pdf
  - https://en.wikipedia.org/wiki/Split_attention_effect
difficulty: high
detectable_from: transcript+video
---

# The attention budget — face, caption and graphic in one vertical frame, and what has to take turns

## What it is

In a 9:16 explainer there are usually four things competing for one pair of eyes: **the presenter's face**, **the caption track**, **the graphic**, and **whatever the footage is doing**. There is exactly one fovea. The budget is not a metaphor.

**The number that makes this concrete.** Szarkowska & Gerber-Morón (2018), eye-tracking 60 participants across three language groups, measured **proportional reading time** — the share of a subtitle's on-screen duration during which gaze is inside the subtitle area:

| Subtitle speed | Share of the cue's duration spent in the caption band |
|---|---|
| 12 cps | ~55 % |
| 16 cps | ~60 % |
| 20 cps | ~68 % |

At the house caption rate of 17 cps that is roughly **60 %**. **While a caption is on screen, about 60 % of the viewer's looking time is spent on the caption**, leaving about 40 % for the face, the footage and the graphic *combined*.

The operational consequence is arithmetic, and it is the most useful thing in this note:

> **A graphic that must be READ, while a caption track is live, gets about 40 % of its nominal dwell. Its screen time therefore has to be multiplied by roughly 2.5.**

A stat card that needs 2.5 s of looking needs **6 s** on screen if a caption is running under it. That is usually unaffordable — which is the real argument for turn-taking, and it is a budget argument rather than an aesthetic one.

### Read objects and recognise objects

The budget is not spent equally by everything on screen. Split every element into two classes:

| Class | What it demands | Examples | Cost |
|---|---|---|---|
| **READ** | Foveal fixation and serial processing | Any text over 3 words, a number with a unit, a list row, a node label, a quote, an axis label | High. Competes directly with the caption. |
| **RECOGNISE** | Parafoveal or peripheral pickup, one glance | A mark (arrow, circle, underline), an icon in a known slot, a bar's length, a colour state, a position on a track, a face | Low. Can coexist with a caption. |

**The rule:** at any instant, the frame may carry the caption track **plus at most one READ object**. Two READ objects and a caption is three serial processes for one fovea; neither graphic is read and the caption's reading time goes up as the eye ping-pongs. RECOGNISE objects are nearly free and may be stacked to the overlay-stack ceiling of **three concurrent non-caption elements** ([[motion-overlay-stack-choreography]]).

### The face

Faces are strong attractors *in the contexts that resemble a talking-head video*. The best naturalistic data available splits sharply by context: during free navigation in public, only **14 % of fixations** went to the faces of passers-by, but **during face-to-face conversation, 89.5 % of fixations went to faces** (White et al., 2023, n = 33). A direct-address piece to camera is the second condition, not the first — flagged honestly as an analogy, since the study is naturalistic behaviour rather than screen viewing.

Take it as a working assumption rather than a measurement: **while the presenter is in shot, speaking to camera, the face has first claim on the fovea.** That gives three practical consequences.

- A READ object competing with a talking face is competing with the strongest attractor in the frame, and it loses.
- The classic resolutions are to **remove the face** (cut to the graphic full-frame), **shrink it** (a corner PiP — the observed house style puts a circular webcam PiP bottom-left over screen recordings), or **stop it talking** (place the graphic in a pause; the reference material's silent demonstration window, [[pace-silent-demonstration-window]]).
- A graphic placed over a talking face in the **subject band** is not a budget problem, it is a geometry problem, and the grid already forbids it ([[gfx-vertical-grid-and-margins]]).

### Working memory, which is the other ceiling

The fovea is the bandwidth limit; working memory is the storage limit. Cowan's reconsideration puts the pure capacity limit near **four chunks**, not seven. This library has independently converged on the same number from the other direction: [[motion-explainer-beat-animation]] specifies an element census of **4 ± 1** distinct informational objects at a build's final frame, and *"8+ means the graphic is a poster, not an explanation."* So the budget has two ceilings that must both hold:

- **Concurrent:** caption + 1 READ + up to 2 RECOGNISE, and never a READ object over a talking face.
- **Cumulative:** ≤ 5 distinct informational objects alive at the end of any build.

### What takes turns, and in what order

When a beat wants more than the budget allows, the resolution order is fixed and asymmetric, and it does **not** start with the graphic:

1. **Shorten the caption for the window.** A three-word cue is a RECOGNISE object, not a READ object. This is the cheapest fix and it is invisible.
2. **Move the graphic in time.** Land it in the pause after the clause instead of under it. Speech has gaps; use them.
3. **Convert the graphic from READ to RECOGNISE.** A labelled bar becomes a bar with the label pre-established. A three-row list becomes a list with two rows dimmed. A stat card becomes a number with the unit already on screen.
4. **Suppress the caption** — legitimate **only** when the graphic contains the words, which is the full-frame single-word or statement-card case.
5. **Remove the face** — cut to full-frame graphic.
6. **Cut the graphic.**

Note what is *not* on the list: moving the caption band. That is the collision resolution, which is a geometry problem with its own note and its own asymmetry — there, **the caption moves and the graphic does not** ([[sub-caption-graphic-collision]]). Here the conflict is temporal, and the caption's *content* is the cheap thing to change while its *position* is the expensive one.

## When to use it

- **Per beat, wherever a graphic and a caption are both live.** Which, on a full-track deliverable, is nearly every beat.
- **Before the collision check, not after.** Geometry cannot fix a temporal overload: two READ objects 6 % of frame height apart are still two READ objects.
- **When the caption role is chosen.** An emphasis-only layer frees almost the whole budget; a full track spends most of it ([[sub-caption-role-decision]]).
- **When a beat feels crowded but nothing overlaps.** That is exactly this note: everything is legal, everything is legible, and nothing is being read.
- **When deciding whether a beat needs the presenter at all.** A dense graphic beat often wants the face gone, and that is a cut decision made in the motion design.
- **Not** for a full-frame card beat, where the card owns the frame and the caption is either suppressed or is the only other object.

## How to recognise it in a reference video

- **Build the simultaneity table.** For every second of the video, record: is a face in shot? is a caption live? how many READ objects? how many RECOGNISE objects? Then find every second where `face && caption && READ ≥ 1` and every second where `READ ≥ 2`. Those are the overloaded seconds; report them as a percentage of runtime. **Under 5 %** is disciplined; **over 20 %** means the budget was never considered.
- **Measure caption occupancy.** What fraction of runtime has a caption on screen? A full track is 85–100 %; an emphasis layer is 5–15 %. That fraction is the fraction of runtime where the graphic budget is already 60 % spent.
- **Measure graphic dwell against its class.** For each READ graphic, compute `chars ÷ 13` (the published minimum dwell of 1 s per 13 characters) and compare with its actual on-screen time. Then compare with `2.5 ×` that figure if a caption was live. A card at exactly the un-multiplied floor, under a live caption, was not read.
- **Look for turn-taking.** In competent work the caption **shortens or stops** around a dense graphic. Check the cue lengths in the 3 s before and during each graphic: a drop from 5-word cues to 2-word cues is the tell that the editor budgeted deliberately.
- **Look for the face leaving.** Count the graphic beats where the presenter is cut away from entirely. A channel that never cuts away and always overlays is spending the face's attention on every graphic.
- **Count concurrent non-caption elements.** 1–3 is the working band; 4+ live at once is a dashboard beat, not an overlay stack.
- **Element census at each build's final frame.** 4 ± 1 distinct informational objects. 8+ is a poster.
- **Transcript signal for the pause.** Look for graphic entrances landing inside speech gaps. Word-level timings make this mechanical: `graphic.start` falling inside a gap of ≥0.4 s between words is a deliberate placement, and it is the strongest single indicator that someone thought about the budget.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `caption_reading_share` | 0.60 | 0.55–0.68 | Measured proportional reading time at 12/16/20 cps. Use the value for the project's own caption rate. |
| `dwell_multiplier_under_caption` | ×2.5 | ×2.2–2.9 | `1 ÷ (1 − caption_reading_share)`. A READ graphic under a live caption needs this much more screen time. |
| `read_objects_concurrent` | 1 | 0–1 | Plus the caption track. Two READ objects means neither is read. |
| `recognise_objects_concurrent` | 2 | 0–3 | Total non-caption elements capped at 3 ([[motion-overlay-stack-choreography]]). |
| `read_over_talking_face` | forbidden | — | Remove the face, shrink it, or place the graphic in a pause. |
| `element_census_final_frame` | 4 | 3–5 | Working-memory ceiling; matches the library's existing 4 ± 1. |
| `dwell_floor` | chars ÷ 13 per second | ≥13 cps | Published minimum dwell for stationary on-screen text. |
| `overloaded_runtime_share` | ≤5 % | 0–10 % | Seconds where `READ ≥ 2` or `face && caption && READ ≥ 1`. |
| `resolution_order` | shorten caption → move graphic → convert to RECOGNISE → suppress caption → remove face → cut graphic | — | Asymmetric and fixed. Moving the caption *band* is a geometry fix, not a budget fix. |
| `caption_shorten_target` | ≤3 words | 1–3 | A 3-word cue is a RECOGNISE object. |
| `pause_landing_gap` | ≥0.4 s | 0.35–1.2 s | Speech gap a graphic entrance can land inside. |
| `face_first_claim` | assumed true when speaking to camera | — | Working assumption from naturalistic conversation data (89.5 % of fixations to faces), flagged as an analogy. |
| `pip_size` | ≤18 % of frame width | 12–22 % | The corner-PiP resolution for keeping a presence without the claim. |
| `suppress_caption_allowed` | only if the graphic carries the words | — | Otherwise a suppression is a missing caption ([[sub-caption-graphic-collision]]). |
| `budget_checked_before_geometry` | required | — | A collision check on an overloaded beat fixes the wrong problem. |

## Reproduction prompt

```
Run the attention-budget pass for {{PROJECT}} before the caption/graphic
collision check. Inputs: the word-level transcript, design-subtitles.md,
design-motion.md, and the shot list.

1. CLASSIFY EVERY ELEMENT as READ or RECOGNISE.
     READ      = any text over 3 words, a number with a unit, a list row, a node
                 label, a quote, an axis label. Demands foveal fixation.
     RECOGNISE = a mark (arrow, circle, underline), an icon in a known slot, a
                 bar's length, a colour state, a position on a track, a face.
                 Picked up in one glance.

2. BUILD THE SIMULTANEITY TABLE, one row per second of runtime:
     face_in_shot | caption_live | n_READ | n_RECOGNISE
   Flag every second where n_READ >= 2, and every second where
   face_in_shot AND caption_live AND n_READ >= 1. Those are overloaded. Target:
   under 5% of runtime.

3. APPLY THE DWELL MULTIPLIER. For every READ graphic that overlaps a live
   caption, required screen time is
     max(2.5s, chars/13) x 2.5
   because eye-tracking puts roughly 60% of a caption's on-screen duration inside
   the caption band, leaving ~40% for everything else. If the beat cannot afford
   that, the graphic does not fit and must be changed, not shrunk.

4. RESOLVE EACH OVERLOAD IN THIS ORDER, taking the first that works:
     (a) shorten the caption to <=3 words for the graphic's window - a 3-word cue
         is a RECOGNISE object and this fix is invisible;
     (b) move the graphic into a speech gap of >= 0.4s;
     (c) convert the graphic from READ to RECOGNISE - pre-establish the label,
         dim the rows that are not current, put the unit up before the number;
     (d) suppress the caption, ONLY if the graphic contains the words;
     (e) remove the face - cut to the graphic full-frame;
     (f) cut the graphic.
   Do NOT resolve it by moving the caption band. That is the geometry fix for a
   spatial collision; this is a temporal problem and moving the band does not
   change how many things must be read.

5. CHECK THE CUMULATIVE CEILING as well as the concurrent one: at the final frame
   of any progressive build, count distinct informational objects. 4 +/- 1.
   Eight is a poster.

6. NEVER place a READ object over a talking face. Cut away, shrink the presenter
   to a corner PiP under 18% of frame width, or wait for a pause.

ACCEPTANCE TEST:
(a) overloaded seconds are under 5% of runtime;
(b) every READ graphic overlapping a live caption has screen time >= its
    multiplied dwell;
(c) no frame contains two READ objects;
(d) no frame contains a READ object over a full-size talking face;
(e) every build's final frame has <= 5 distinct informational objects;
(f) at least half the graphic entrances land inside a speech gap of >= 0.4s,
    verified against the word-level transcript.
```

## Execution spec

**The budget is enforced by timing, and timing in this stack is `data-start` in seconds on the host slots.** There is nothing clever to build; there are four contract facts that make the enforcement real and one that makes a common workaround illegal.

```html
<!-- caption track: a sub-comp spanning the video -->
<div id="el-captions" data-composition-id="captions"
     data-composition-src="compositions/captions.html"
     data-start="0" data-duration="180" data-track-index="4"></div>

<!-- a READ graphic, landed in a measured speech gap (words end 92.31, resume 92.86) -->
<div id="el-stat" data-composition-id="stat-card"
     data-composition-src="compositions/stat-card.html"
     data-start="92.45" data-duration="6.0" data-track-index="3"
     data-variable-values='{"value":"41,000","unit":"views","qualifier":"in 30 days"}'></div>
```

- **The caption's words at any timestamp are computable at author time.** Caption timing is driven entirely by the inlined word array — *"There is no external transcript read at runtime, no audio analysis, no `audio.currentTime`."* So "is a caption live, and how long is it" is a lookup, not an observation, and the simultaneity table can be generated rather than watched.
- **Speech gaps come from the same array**, and from `silencedetect` if the transcript is coarse. Landing a graphic in a gap is arithmetic on `word[i].end` and `word[i+1].start`.
- **Shortening a caption for one window is a cue-sheet edit, not a style change.** It belongs in `design-subtitles.md` and it is the cheapest of the six resolutions — see [[sub-cue-segmentation-three-word]] and [[sub-emphasis-caption-three-words]] for the forms a 3-word cue can take.
- **Converting READ to RECOGNISE is usually a *build* decision**: pre-establish the label in an earlier stage, dim non-current rows to 40–70 % opacity, put the unit on screen before the number lands. That is the progressive information build, and it is the main structural tool this note leans on ([[motion-progressive-information-build]]).
- **Do not solve an overload by speeding the caption up.** It is the obvious move and it makes the problem worse in exactly the measured way: at 20 cps proportional reading time rises to ~68 %, so a faster caption takes a *larger* share of looking time, not a smaller one. The house cap of 17 cps stands ([[sub-reading-speed-hard-cap]]).
- **`data-hidden` hides an element in both preview and render, overriding its time window** — non-destructive and reversible, and it is the right tool for auditioning a beat with the graphic removed rather than deleting the slot. Remember the vault cannot delete files, so `data-hidden` plus a note is the sanctioned way to retire an element.
- **Relative timing is the wrong tool for budget-critical placement.** `data-start="prev + 0.4"` has four silent failure modes and each resolves to `0`. Author the absolute second, computed from the transcript.
- **`data-track-index` constrains nothing** and two clips on one track may overlap in time; the budget is not enforced by the track model. It is enforced by the numbers you write.

**ffmpeg — building the occupancy signal for a reference**, where you do not have the transcript-driven answer:

```bash
# speech gaps: where can a graphic land?
ffmpeg -i ref.mp4 -af "silencedetect=noise=-32dB:d=0.35" -f null - 2> /tmp/b/gaps.txt
# caption occupancy: crop the caption band and look for text-shaped activity
ffmpeg -i ref.mp4 -vf "crop=iw:ih*0.10:0:ih*0.76,signalstats,\
metadata=print:key=lavfi.signalstats.YDIF" -f null - 2> /tmp/b/capband.txt
```

**Remotion.** Sequences with computed `from` values off the same transcript; the budget arithmetic is framework-independent.

## Pairs with
[[gfx-three-channel-division-of-labour]] · [[gfx-channel-decision-procedure]] · [[gfx-structure-duplicates-prose-does-not]] · [[gfx-vertical-grid-and-margins]] · [[sub-caption-graphic-collision]] · [[sub-caption-role-decision]] · [[sub-reading-speed-hard-cap]] · [[sub-cue-segmentation-three-word]] · [[motion-overlay-stack-choreography]] · [[motion-attention-transient]] · [[motion-progressive-information-build]] · [[motion-explainer-beat-animation]] · [[pace-silent-demonstration-window]] · [[pace-visual-mush-ceiling]] · [[struct-stimulation-budget]]

## Failure modes
- **Two READ objects at once.** Both are legible, neither is read, and the beat feels crowded although nothing overlaps or fails a check.
- **A READ graphic at its un-multiplied dwell under a live caption.** It was on screen for the right length of time and looked at for 40 % of it.
- **Speeding the caption up to make room.** Raises the caption's share of looking time from ~55 % to ~68 %. The opposite of the intended effect, and it is measured.
- **A stat card over a talking presenter.** Competing with the strongest attractor in the frame.
- **Resolving a temporal overload by moving the caption band.** Geometry does not reduce the number of things that must be read.
- **Suppressing the caption to make room.** A missing caption is an accessibility failure, not a design choice — unless the graphic carries the words.
- **Never cutting away.** A channel that overlays every graphic onto the presenter has decided that no graphic is worth the face, which is a decision worth making deliberately at least once.
- **Eight objects at the final frame of a build.** A poster. Nobody holds eight chunks.
- **Landing graphics mid-clause by default.** Speech has gaps; a graphic that never uses one was placed on the timeline rather than in the argument.
- **Known gap:** the 60 % figure comes from eye-tracking of *subtitled film with dialogue*, not from vertical short-form with a presenter and overlay graphics, and the face figure comes from naturalistic conversation rather than screen viewing. Both are used here as the best available anchors and both are flagged. If a channel has its own eye-tracking or heatmap data, that data beats these numbers; nothing else does.
