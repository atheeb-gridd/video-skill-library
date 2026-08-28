---
id: motion-explainer-beat-animation
title: Animate the beat that is necessary but boring — the information build
skill: motion
type: motion
family: explainer-graphics
tags: [skill/motion, type/motion, family/explainer-graphics, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:04:21"
    quote: "That was an important but boring moment in the story of the video."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:04:25"
    quote: "Any attempt to use A-roll or regular B-roll in that moment would have been either too slow or horribly confusing, and either one would have cost viewers."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:04:33"
    quote: "But an animation explained it crystal clear and fast."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:53"
    quote: "A few variations of B-roll are stock footage, which is basically the easy version, and motion graphics."
research_refs:
  - https://www.cambridge.org/core/books/abs/multimedia-learning/segmenting-principle/37240877DDA0362355ADB39936027982
  - https://sites.google.com/site/cognitivetheorymmlearning/segmenting-principle
  - https://educationaltechnology.net/mayers-principles-of-multimedia-learning/
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/360051554394-Timed-Text-Style-Guide-Subtitle-Timing-Guidelines
  - https://en.wikipedia.org/wiki/Words_per_minute
  - https://www.sciencedirect.com/science/article/abs/pii/S2211368121000231
difficulty: high
detectable_from: transcript+video
---

# Animate the beat that is necessary but boring — the information build

## What it is
A triage rule with a production consequence. Some beats in a script are **structurally required and intrinsically dull or complex** — a mechanism, a sequence of causes, a set of numbers, a comparison, a piece of setup that has to be understood before the payoff lands. On those beats A-roll is *too slow* (the presenter has to say all of it) and literal B-roll is *confusing* (there is no single image that means "three things happened in this order"). The answer is a purpose-built **motion-graphic build**: a diagram, list, timeline or number that assembles in stages, one idea per stage, in step with the voiceover. The source names this as the archetypal decision that separates an unlookawayable video from a normal one, and puts motion graphics in the same family as B-roll — a *variation* of it, not a decorative layer.

The pedagogy behind it is well measured. **Segmenting** — delivering the same explanation in learner-paced chunks rather than one continuous flow — produced an effect size of **d ≈ 1.0** in Mayer, Dow and Mayer's electric-motor study, one of the largest in the multimedia-learning literature. **Signalling** (highlighting the one element that matters right now) and the **spatial-contiguity** principle (label sits on the thing it labels, not in a legend) are the other two that do most of the work. A build is those three principles expressed as a timeline.

## When to use it
Run the triage on every beat of the script and pick this move when **all three** are true: (1) the beat is load-bearing — cut it and a later beat stops making sense; (2) it has **more than one part** or a **relationship between parts** (before/after, cause/effect, A vs B, a total split into shares, an ordered sequence); (3) no single piece of real footage says it. Classic triggers in creator work: explaining how a system or algorithm works, walking through a process with steps, comparing two options, showing where a number came from, showing a structure (a funnel, a stack, a hierarchy), and any moment where the presenter would otherwise say "so basically what happens is…" for more than about 12 seconds.

Do **not** reach for it when a single photo, screen recording or piece of stock would carry the beat — those are cheaper and read as more real ([[cut-screen-recording-proof-insert]]). Do not use it as decoration on a beat that is already clear; a build on a simple claim is redundancy, and redundancy is the one multimedia principle that *hurts*. And do not use it to rescue a beat that is boring **and** unnecessary — the correct edit there is to delete the beat ([[pace-subtractive-first-pass]]).

## How to recognise it in a reference video
- **Find the graphics-only stretches.** On the picture track, look for runs where neither A-roll nor real footage is on screen — flat or gradient background, vector shapes, type. Log in/out points. In creator explainers these runs are typically **8–25 s** and there are **2–6 of them** in a 10-minute video.
- **Count the stages, not the seconds.** A build is discrete: elements arrive one at a time, and the previous ones *stay*. Step through and count arrivals. **3–6 stages** is the normal range; a "build" with one arrival is a title card, and more than ~8 is two builds fused.
- **Measure the stage interval.** Time from one element's arrival to the next. Typical **1.2–3.0 s**, and it should track the VO: each stage's arrival lands within **±4 frames** of the word that introduces it in the transcript. That alignment is the single strongest signal that this is a deliberate build rather than a canned template.
- **Check persistence.** In a true information build, earlier stages remain on screen (possibly dimmed) so the final frame contains the whole idea. If each element replaces the last, it is a slideshow, not a build — log it as such, it is a weaker pattern.
- **Look for the signalling pass.** At each stage, is the *current* element visually privileged — full opacity while others sit at 30–60%, a scale bump, a colour accent, a stroke draw, an arrow? Signalling present is the professional tell.
- **Check label placement.** Labels sitting *on* their elements (spatial contiguity) rather than in a legend or a caption bar.
- **Element census at the final frame.** Pause on the last frame of the build and count distinct informational objects. **4 ± 1** is the working-memory-respecting ceiling; 8+ means the graphic is a poster, not an explanation.
- **Transcript signals.** Scan for enumeration and relation language landing on the graphics-only window: "first… then… finally", "which means", "the reason is", "on one side… on the other", "goes from X to Y", "breaks down into", a run of numbers or percentages. Also look for the presenter's own flag — "let me show you", "here's what's actually happening".
- **Audio tell.** Each stage arrival almost always carries a motion SFX (a soft whoosh, a tick, a click) at **−12 to −15 dB** against dialogue. A silent build is the amateur signature ([[sfx-unsounded-motion-audit]]).
- **Read-time audit.** For any on-screen text, compute `characters ÷ visible_seconds`. Above ~20 cps the viewer cannot read it while also listening; log it as a fail.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `stages` | 4 | 3–6 | One new idea per stage. Above 6, split into two builds separated by a return to A-roll. |
| `stage_interval` | 54 f (1.8 s) | 36–90 f (1.2–3.0 s) | Driven by the VO, not by taste — see `vo_lock`. |
| `vo_lock` | ±4 f | ±0–6 f | Stage arrival vs the transcript word that introduces it. Beyond ±8 f the graphic and the voice read as two separate explanations. |
| `entrance_dur` | 12 f (0.4 s) | 9–15 f (0.3–0.5 s) | The medium motion band — "professional, most content". Entrances get longer than exits (0.4 s in, 0.25 s out). |
| `entrance_ease` | `power3.out` | `power3.out` \| `power4.out` \| `sine.inOut` | House settle. Overshoot (`back`/`elastic`) is a playful register only, not the default. |
| `stagger_total` | ≤ 15 f (0.5 s) | 0–15 f | Hard cap from the animation contract: `items × stagger ≤ ~0.5 s` so a group arrival reads as one beat. |
| `hold_supported` | `0.4 + 0.26 × words` s | — | Minimum on-screen time for a label the VO also speaks. 5 words → 1.7 s (51 f). |
| `hold_unsupported` | `0.5 + 0.53 × words` s | — | Label the VO does **not** speak: budget two passes at 228 wpm (3.8 words/s). 5 words → 3.1 s (93 f). |
| `min_readable` | 20 f (0.67 s) | ≥ 20 f | Absolute floor for any legible text, borrowed from Netflix's 20-frame minimum subtitle duration. Nothing readable ever flashes shorter. |
| `max_cps` | 17 cps | 12–20 cps | Characters per second of visible on-screen text. Netflix caps adult reading speed in this region; a viewer who is also listening is slower still. |
| `concurrent_elements` | 4 | 3–5 | Distinct informational objects live at once. Cowan's 4±1 working-memory limit; beyond it, dim or group. |
| `dim_level` | 0.45 | 0.30–0.60 | Opacity of completed stages while the current one is signalled. Never 0 — persistence is the point. |
| `signal_scale` | 1.06 | 1.03–1.12 | Scale bump on the active element. Above 1.15 it reads as a bounce, not a highlight. |
| `build_len` | 12 s | 8–25 s | Total graphics-only run. Past ~25 s cut back to A-roll or B-roll and resume ([[pace-visual-change-clock]]). |
| `builds_per_10min` | 3 | 2–6 | More than ~6 and the video stops feeling shot and starts feeling authored. |
| `sfx_per_stage` | 1 | 0–1 | One motion sound per arrival, −12 to −15 dB. Do not sound sub-elements inside a stagger. |
| `final_hold` | 45 f (1.5 s) | 30–90 f | Whole assembled graphic held before the cut away, so the viewer gets one look at the complete idea. |

## Reproduction prompt

```
Build an information-build motion graphic for the script beat between
{{IN}} and {{OUT}} (seconds, 30fps composition).

1. SEGMENT. Read the VO for this beat. Split it into 3-6 stages, one new
   idea each. Write the stage list with, for each stage, the exact word in
   the transcript where it must arrive. If you cannot name one new idea per
   stage, you have too many stages - merge.
2. CHOOSE THE FORM from the relationship, not from taste:
   ordered process -> horizontal step chain with connecting arrows;
   comparison     -> two columns, both frames present from stage 1, rows
                     filling alternately; parts of a whole -> a single bar
                     or ring segmenting; growth or a number -> one large
                     animated numeral with its unit; structure -> nested
                     boxes built outside-in.
3. LAYOUT ONCE, then only reveal. Compose the FINAL frame first and keep
   every element in its final position for the whole build; stages change
   opacity, scale and clip-path, never layout. Labels sit ON their element,
   never in a legend.
4. ANIMATE. Each stage: fromTo entrance, 0.4s, ease power3.out, arriving
   within +-4 frames of its transcript word. Group arrivals use stagger with
   items x stagger <= 0.5s total. On arrival, set the previous stages to
   opacity 0.45 and scale the arriving element to 1.06 then back to 1.0.
   Never tween width/height/top/left - use x, y, scale, opacity, clip-path.
5. HOLD. Any readable text stays up at least 20 frames, and at least
   0.4 + 0.26 x (its word count) seconds if the VO speaks it, or
   0.5 + 0.53 x (word count) if the VO does not. Never exceed 17 characters
   per second of visible text.
6. LAND. Hold the fully assembled graphic 45 frames before cutting away.
7. SOUND. One motion SFX per stage arrival at -12 to -15 dB against
   dialogue. No sound on sub-elements inside a stagger.
8. ACCEPTANCE TEST: (a) mute the video - the build alone must be followable;
   (b) blank the picture - the VO alone must still be followable; if either
   fails alone, they are not carrying the same explanation. (c) Pause on the
   final frame and count informational objects: 5 or fewer. (d) Read every
   label out loud at the moment it appears; if you cannot finish before it
   changes, extend the hold. (e) Total run 8-25s; if longer, split it and
   return to A-roll in between.
```

## Execution spec

**HyperFrames (primary).** A build is a **sub-composition**, not inline scenes: the pattern reference says to modularise once a project has three or more scene cuts, and a build is by definition a multi-phase single scene — archetype **C, multi-scene merge**: one sub-comp, internal `.phase` divs, one timeline, rather than one slot per stage. Host it from `index.html`:

```html
<div id="el-build" data-composition-id="build-funnel"
     data-composition-src="compositions/build-funnel.html"
     data-start="146.2" data-duration="12.0" data-track-index="1"></div>
```

Inside `compositions/build-funnel.html` (template-wrapped, styles scoped `[data-composition-id="build-funnel"]`, **GSAP loaded from a local path — `cdn.jsdelivr.net` is blocked in this project**), all times are **scene-local seconds**:

```js
const tl = gsap.timeline({ paused: true, defaults: { duration: 0.4, ease: "power3.out" } });
const stages = ["#s1", "#s2", "#s3", "#s4"];
const at = [0.6, 2.4, 4.2, 6.4];               // 18f, 72f, 126f, 192f @30fps
stages.forEach((sel, i) => {
  tl.fromTo(sel, { y: 24, autoAlpha: 0 }, { y: 0, autoAlpha: 1 }, at[i]);
  tl.to(sel, { scale: 1.06, duration: 0.18, ease: "power2.out" }, at[i]);
  tl.to(sel, { scale: 1.0,  duration: 0.22, ease: "power2.inOut" }, at[i] + 0.18);
  if (i > 0) tl.to(stages.slice(0, i), { autoAlpha: 0.45, duration: 0.3 }, at[i]);
});
tl.to(stages, { autoAlpha: 1, duration: 0.3 }, 8.0);   // reveal all for the final hold
window.__timelines["build-funnel"] = tl;
```

Contract details that break this if ignored: use `fromTo`, never `from` (`from()` sets `immediateRender: true` and writes its start state at construction, which flashes under the render engine's non-linear seek); animate `x`/`y`/`scale`/`autoAlpha`/`clip-path` only — `width`/`height`/`top`/`left` tweens are forbidden; never tween `display`/`visibility` on a clip element; land the last tween **before** the root `data-duration`, because the visibility window is half-open `[start, start+duration)` and the final frame at exactly `start+duration` is never rendered — hence the `final_hold`. `data-track-index` is display-only; layering is `z-index`.

Useful named motion rules for the forms above (recipes not staged in this project — cite by name, do not invent their code): `svg-path-draw` for connector arrows, `counting-dynamic-scale` for animated numbers, `stat-bars-and-fills` for share/part-of-whole builds, `center-outward-expansion` and `anchored-layout-expand` for structure builds, and the staged `clip-path reveal masks` technique for wipe-on reveals.

**ffmpeg.** Nothing here is a raw media operation. The one exception: if a build is authored elsewhere and delivered as a movie, bring it in as a clip and trim in the composition with `data-media-start` + `data-duration` — the contract is explicit that you only cut a physical file when exporting outside the composition. For a transparent overlay build rendered separately, `--format webm` or `mov` renders with transparency.

**Epidemic Sound.** One motion sound per stage arrival: `SearchSoundEffects { query.term: "ui element pop in subtle", filter.duration { max: 800 } }`, or `"whoosh short light transition"` for sliding elements. Place each hit as its own `<audio>` clip, `data-audio-group="sfx"`, `data-track-index` 12+, `data-volume` around `0.22` (≈ −13 dB), with `data-start` equal to the stage's **global** time = the slot's `data-start` + the scene-local tween position. There is no audio-follows-animation attribute; you write the same number twice.

**Remotion:** conceptually one `<Sequence>` per stage with `spring()`/`interpolate` entrances; no Remotion runtime exists in this project.

## Pairs with
[[motion-image-focal-point-direction]] · [[motion-list-item-marker-card]] · [[pace-visual-variety-density-audit]] · [[pace-visual-change-clock]] · [[cut-screen-recording-proof-insert]] · [[struct-progressive-layer-demo]] · [[struct-name-define-demonstrate]] · [[sfx-unsounded-motion-audit]] · [[sfx-av-sync-binding-window]] · [[pace-subtractive-first-pass]] · [[motion-look-finishing-pass]]

## Failure modes
- **Building something that was already clear.** A graphic that restates a simple sentence is redundancy and measurably reduces comprehension. Fix: run the three-part trigger test; if the beat has only one part, cut the graphic.
- **All stages arriving at once.** A "build" that assembles in 0.5 s is a title card with extra steps and loses the entire segmenting benefit. Fix: one stage per idea, 1.2–3.0 s apart, locked to the VO word.
- **Stages replacing each other.** The viewer never sees the whole relationship, which is the only thing the graphic was for. Fix: keep earlier stages at `dim_level` 0.45 and reveal all at the end.
- **Text that cannot be read.** Above ~20 cps, or under the 20-frame floor, the text is decoration. Fix: fewer words, longer holds, or move the words into the VO and leave a symbol on screen.
- **Legend layout.** Labels in a key force the eye to shuttle and destroy spatial contiguity. Fix: label on the element.
- **Poster syndrome.** Eight objects live at once because everything felt important. Fix: 4±1, group the rest, or split into two builds.
- **Overshoot easing everywhere.** `back.out`/`elastic` on an explanatory graphic reads as cheap; the contract calls bounce-everywhere the worse of the two failures. Fix: `power3.out`, vary energy within the smooth families.
- **Silent build.** Motion with no sound reads as hollow and fake. Fix: one motion SFX per arrival.
- **Graphics running too long.** Past ~25 s of vector-only picture the video stops feeling made by a person. Fix: split and return to A-roll.
- **Known gap:** the segmenting literature establishes *that* chunked delivery helps and by roughly how much, but publishes **no** recommended stage duration. Every interval number in this note is house calibration derived from the VO-lock rule and the reading-speed floors, not from a cited standard. When a reference video is available, measure its stage interval and prefer that.
