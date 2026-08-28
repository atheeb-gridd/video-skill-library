---
id: sub-spring-and-bounce-budget
title: Bounce is a register, not a default — budget the springy cues and keep overshoot off opacity
skill: subtitles
type: caption-motion
family: kinetic-type
tags: [skill/subtitles, type/caption-motion, family/kinetic-type, engine/hyperframes, source/hyperframes, source/research, difficulty/high]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "\"Smooth beats bouncy\" — entrances default to power3.out or the baked critically-damped spring; overshoot (back/elastic/bounce) is \"a rare, explicitly-playful register, never the house style.\""
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "At ζ<1, overshooting curves go on transforms only — never opacity or color; split opacity onto its own power2.out tween at the same position."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html
  - https://www.nngroup.com/articles/animation-duration/
  - https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0199331
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
difficulty: high
detectable_from: video
---

# Bounce is a register, not a default — budget the springy cues and keep overshoot off opacity

## What it is

Springy captions — a word that overshoots and settles, a card that pops past its size and comes back — are the most-copied treatment in short-form and the fastest way to make a track exhausting. The framework's doctrine is unambiguous: **"Smooth beats bouncy."** Entrances default to `power3.out` or a baked critically-damped spring, and overshoot (`back`, `elastic`, `bounce`) is *"a rare, explicitly-playful register, never the house style."* And on captions specifically the default is gentler still — `power1.out` / `power2.out`, explicitly not the entrance default.

Three things make bounce expensive on a caption in particular:

**1. It costs reading time twice.** An overshooting entrance is longer than a settled one by construction, and during the overshoot the glyphs are the wrong size and moving, so the reading clock has not started. On a 0.6-second cue, a 0.35-second spring entrance consumes more than half the display window.

**2. It accumulates.** One bouncy card is a flourish. Forty of them in a minute — which is what a word-level track with a spring on every cue produces — is a strobe, and this is precisely the non-essential motion that reduced-motion guidance exists for. Vestibular symptoms are triggered by repeated, unnecessary movement, and a caption's motion is by definition non-essential: the text is the content.

**3. Springs are stateful, and the render engine seeks.** An interactive spring is a stateful integrator and cannot be seeked deterministically. The framework's answer is `springEase({ response, dampingFraction })` — a **baked, pure function of progress**, seek-safe by construction. Take **both** the ease and the `duration` from the helper; using the ease with your own duration produces the wrong curve.

So: a budget, not a ban. **At most 2–3 springy events per 30 seconds**, reserved for structural moments — a topic card, a number landing, a punchline — and never as the per-cue default.

**Damping is the actual dial.** `dampingFraction` 1.0 is the house settle with no overshoot; 0.80–0.85 is the iOS register; 0.60–0.70 is explicitly playful; below 0.55, don't. `response` 0.25–0.35 is a tight snap, 0.35–0.50 a standard entrance, 0.50–0.70 a weighted hero landing. For captions, the only defensible band is **ζ ≥ 0.85 with response ≤ 0.35** — a settle that is barely a bounce — and full ζ = 1.0 for anything that repeats.

**The one hard technical rule:** at ζ<1 the overshooting curve goes **on transforms only, never on opacity or colour**. An opacity tween that overshoots either clips at 1.0 (so the bounce is invisible and you paid for nothing) or overshoots past 1.0 and produces a visible flash. Split opacity onto its own `power2.out` tween at the same position.

## When to use it

- On a **single-word topic card**, a landed number, or a punchline beat — structural moments the edit has already marked ([[motion-single-word-topic-card]], [[motion-number-rollup-stat-reveal]]).
- On the **first cue of the video**, if the format's register is explicitly playful.
- Where a **sound** lands with it — a spring with no accompanying transient reads as a glitch; see [[sfx-envelope-matched-to-easing-curve]].
- **Never** as the per-cue entrance of a full caption track.
- **Never** inside a fast-cut burst.
- **Never** on the active-word treatment of a karaoke track, which fires 3–5 times a second.

## How to recognise it in a reference video

- **Overshoot magnitude.** Extract every frame of the entrance and measure the element's width or cap height per frame. A spring shows a peak **above** the settled value; measure the ratio. **1.00–1.03** is a settle, **1.03–1.08** is a visible bounce, above **1.12** is cartoon register.
- **Settle count.** Count direction reversals after the peak. Critically damped: 0. iOS register: 1. Playful: 2. Three or more reversals is `elastic` and reads as cheap.
- **Total entrance length.** Springs are long: **8–18 frames** against 3–6 for a fade. If the measured entrance is over 10 frames on a caption, it is almost certainly a spring.
- **Budget count.** Count springy events per 30 seconds across the whole video. **2–3** is a considered budget; above 8 the treatment has become the default and no longer marks anything.
- **Opacity behaviour during the bounce.** If the element flashes brighter than its settled state at the peak, opacity was put on the overshooting curve — a defect, and a visible one.
- **Correlation with sound.** Check whether each spring lands with a transient. Unaccompanied springs in an otherwise sound-designed video usually mean the caption pass ran after the SFX pass and nobody reconciled them.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `spring_budget` | 2 per 30 s | 0–3 | Structural moments only. |
| `default_caption_ease` | `power2.out` | `power1.out`–`power2.out` | The caption band. Not `power3.out`. |
| `damping_fraction` | 1.0 | 0.85–1.0 | ζ = 1.0 is the house settle. Below 0.85 is out of register for captions. |
| `response` | 0.30 s | 0.25–0.35 s | Tight snap. Take the duration from `springEase`, not by hand. |
| `overshoot_ratio` | 1.00 | 1.00–1.06 | Peak ÷ settled. Above 1.08 is cartoon. |
| `reversals` | 0 | 0–1 | Two or more reads as elastic. |
| `entrance_length_spring` | 0.30 s | 0.25–0.45 s | Against 0.10 s for a plain fade. |
| `overshoot_properties` | transforms only | — | Never opacity, never colour. |
| `opacity_companion` | `power2.out`, same position | — | Split it onto its own tween. |
| `easing_characters` | ~3 per composition | 2–4 | One ease everywhere reads flat; bounce everywhere reads cheap. |
| `sound_pairing` | required | — | A spring without a transient reads as a glitch. |
| `reduced_motion` | drop to fade | — | The spring is decoration; the fallback is the default spec. |

## Reproduction prompt

```
Apply and budget spring/bounce treatments on the caption track of
{{PROJECT}}.

1. BUDGET FIRST. List every candidate springy moment with a timestamp and a
   one-line reason (topic card, number landing, punchline, opening title).
   Keep at most {{BUDGET}} = 2 per 30 seconds of runtime. If the list is
   longer, cut it before authoring - do not author and prune later.
2. AUTHOR each one with the baked spring helper, taking BOTH the ease and
   the duration from it:
     const s = springEase({ response: {{RESP}} = 0.30,
                            dampingFraction: {{ZETA}} = 0.90 });
     tl.fromTo(el, { scale: 0.92 },
       { scale: 1, duration: s.duration, ease: s.ease }, T);
   Never use an interactive/stateful spring - it cannot be seeked
   deterministically.
3. SPLIT OPACITY. At the SAME position T, tween opacity on its own
   power2.out over 0.12s. Overshooting curves go on transforms only; never
   put opacity or colour on the spring ease.
4. EVERY OTHER CUE in the track uses the plain fade spec: 0.10s power2.out
   in, 0.08s power2.in out, opacity only.
5. PAIR each spring with an audio transient, or remove the spring.

ACCEPTANCE TEST: springy events per 30 seconds is at or under the budget and
each is listed with its reason; measured overshoot ratio is between 1.00 and
1.06 with at most one direction reversal; no opacity or colour value exceeds
its settled value on any frame; every spring lands within 2 frames of an
audio transient; and no spring appears inside a fast-cut burst or on a
per-word highlight.
```

## Execution spec

`springEase({ response, dampingFraction })` is a **pure function of progress** and is therefore seek-safe — that is the whole reason it exists, because an interactive spring is a stateful integrator that cannot be seeked deterministically. Take both the ease and the duration from the helper.

The built-in overshooting eases are `back.out(1.7)` (overshoot then settle — **RARE**, explicitly-playful register only) and `elastic.out(1, 0.3)` (springy bounce, same rule). `bounce` is in the same family. Vary **within** the smooth families by energy instead: `sine`/`power1` calm → `power3` standard → `power4`/`expo` punch, aiming for roughly **three easing characters per composition**, because *"one ease everywhere reads flat; bounce everywhere reads cheap — the second failure is worse."*

Speed bands for reference: fast 0.15–0.3 s (energy, urgency), medium 0.3–0.5 s (professional, most content), slow 0.5–0.8 s (gravity), very slow 0.8–2.0 s (cinematic). A caption spring belongs in the fast band; anything slower is a title card, not a caption.

Other binding points:

- Transformed elements must be **block-level and sized**, and the overshoot must not be expressed as a CSS initial transform (`gsap_css_transform_conflict`, a lint error that also silences the layout and contrast audits).
- **`repeat: -1` is banned** — an infinite bounce is not authorable; use a finite count, and on a caption the finite count is 1.
- An ambient pulse must attach to the seekable `tl`; a bare `gsap.to()` runs on wallclock and is absent from the render, which is how a "bouncing" caption ends up static in the final MP4.
- If the spring is on a scale, it needs a fixed layout box for the same reflow reason as [[sub-per-word-pop-scale-colour]] — a springing word inside a line pushes its neighbours twice per event.

## Pairs with
[[sub-entrance-exit-motion-budget]] · [[sub-per-word-pop-scale-colour]] · [[sub-fast-cut-sequence-captions]] · [[sub-single-word-topic-card]] · [[sub-beat-synced-caption-motion]] · [[motion-emphasis-scale-step]] · [[motion-single-word-topic-card]] · [[motion-number-rollup-stat-reveal]] · [[sfx-envelope-matched-to-easing-curve]] · [[sfx-density-fatigue-audit]]

## Failure modes
- **A spring on every cue.** Forty bounces a minute; the treatment marks nothing and the track is fatiguing. Correction: budget of 2–3 per 30 s.
- **Opacity on the overshoot curve.** Either invisible (clipped at 1.0) or a visible flash past it. Correction: split opacity onto `power2.out`.
- **An interactive spring.** Cannot be seeked, so preview and render disagree. Correction: the baked `springEase`.
- **The helper's ease with a hand-picked duration.** Produces a curve that never settles where it should. Correction: take both.
- **`elastic.out` on caption text.** Three reversals; reads cheap and costs half the cue's display window. Correction: ζ ≥ 0.85, one reversal at most.
- **A spring inside a fast-cut burst.** Motion on top of cutting. Correction: strip motion in bursts.
- **A springing word without a fixed layout box.** The line reflows twice per event. Correction: transform on an inner element.
- **A spring with no sound.** Reads as a glitch rather than as a beat. Correction: pair with a transient or drop the spring.
