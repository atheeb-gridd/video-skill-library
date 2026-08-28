---
id: sub-active-word-treatment-palette
title: Choose which property carries "active" in a karaoke track — and change exactly one
skill: subtitles
type: caption-style
family: karaoke
tags: [skill/subtitles, type/caption-style, family/karaoke, engine/hyperframes, source/hyperframes, source/research, difficulty/high]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "For per-word rather than per-line captions, the mechanism is the per-word kinetic typography technique with timings taken from the same transcript array, plus the asr-keyword-glow rule for keyword emphasis synced to ASR timestamps."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "the typography guardrail that caption fades belong to the gentle eases (power1.out / power2.out, \"NOT the entrance default\")."
research_refs:
  - https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
  - https://en.wikipedia.org/wiki/Color_blindness
  - https://developer.mozilla.org/en-US/docs/Web/CSS/text-shadow
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
difficulty: high
detectable_from: video
---

# Choose which property carries "active" in a karaoke track — and change exactly one

## What it is

In a karaoke caption a phrase is held and one word is marked as currently-spoken. [[sub-karaoke-active-word-highlight]] covers the mechanic and the timing. This note covers the **style question underneath it**: which visual property carries the active state.

There are six candidates, and they are emphatically not equivalent — they differ in how much they disturb the line, how well they survive encoding, and whether they work for colour-deficient viewers.

| Treatment | What changes | Disturbs the line? | Greyscale-safe? | Encode-safe? |
|---|---|---|---|---|
| **Colour swap** | `color` on the active word | No | **No** | Yes |
| **Fill sweep** | A gradient wipes through the word | No | Yes | Marginal — a moving gradient edge is expensive to encode |
| **Highlighter box** | A filled rect behind the active word | No, if sized in `em` | Yes | Yes |
| **Scale step** | `transform: scale()` on the word | **Yes** — reflows unless `inline-block` | Yes | Yes |
| **Weight step** | `font-weight` jumps a cut | **Yes** — advance widths change, the whole line reflows | Yes | Yes |
| **Dim the rest** | Non-active words drop to `--cap-dim` | No | Yes | Yes |

Three rules follow from that table.

**Change exactly one property.** A design that swaps colour *and* scales *and* boxes is not three times as clear; it is a distracting object that pulls the eye off the words either side, which defeats the read-ahead advantage that is the whole reason for the form.

**Never let the active state change the line's layout.** Weight step is the classic mistake: bolding a word changes its advance width, so every word after it shifts left or right on every syllable. The line visibly crawls. Scale has the same problem unless the word is `display: inline-block` with a `transform`, which changes its painted size without changing its layout box. This is why weight step should essentially never be the karaoke carrier despite being the obvious choice.

**Colour alone is not enough.** About 8 % of male viewers have a red-green deficiency; a pure hue swap is invisible to them and the track degrades to a plain held phrase. The cheapest fix is that the karaoke form already provides a redundant cue for free — **position**. The active word is always the leftmost undimmed one. Dimming the already-spoken words makes position carry the state, which is why "dim the rest" is a stronger default than most people expect.

## When to use it

- Once, at identity time, as part of `--cap-active` and `--cap-dim` in the token set.
- Driven by the backing: a **highlighter box** is unavailable on a plated track (a box on a box), and **colour swap** is weak on a stroke-backed track over bright footage because both states can wash out.
- Driven by the speech rate: at 200+ wpm the active word changes every ~0.3 s, so anything with a transition — fill sweep, scale — is either imperceptible or lagging. Fast speech wants an instant, binary treatment.
- Driven by the accent budget: if `--cap-accent` is already carrying emphasis ([[sub-emphasis-selection-rule]]), the karaoke active state must not use the same hue, or two codes collide. Use dim-the-rest instead and keep the accent free.

## How to recognise it in a reference video

Karaoke treatments are readable by sampling **consecutive frames** across one word transition, not by sampling cue midpoints.

```bash
# every frame across a 0.5s window at the word boundary — the motion-timing idiom
ffmpeg -ss <t-0.25> -i in.mp4 -t 0.5 -vf fps=<native> -q:v 2 f_%03d.png
```

| Signal | Measure | Reading |
|---|---|---|
| Which property changed | Diff two frames either side of the transition | Colour only / geometry only / both |
| Layout stability | Measure the x position of the last word in the line before and after | Moves = weight or non-`inline-block` scale. This is a defect. |
| Transition duration | Count frames from first change to settled | 0 f = binary `set`. 3–6 f = a tween. >8 f = too slow for word-level. |
| Trailing-word state | Sample luminance of a word already spoken vs an unspoken one | Different = dim-the-rest is in play. Same = only the active word is marked. |
| Dim depth | Spoken luminance / resting luminance | Below 0.6 destroys read-back. 0.7–0.85 is the useful band. |
| Leading-word state | Are unspoken words fully legible? | They must be — reading ahead is the point of the form. |
| Both-state contrast | Compute active-vs-plate and resting-vs-plate | **Both** must clear 4.5:1. Designs usually check only the active one. |
| Fill sweep | Look for a gradient edge mid-glyph | A sweep, not a swap |
| Simultaneous count | How many words carry the active state | Exactly 1, always |
| Greyscale | `ffmpeg -vf format=gray` | If the active word becomes indistinguishable, the treatment is hue-only |

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `carrier` | dim-the-rest | dim / colour / box / sweep / scale | Exactly one. `weight` is effectively banned — it reflows the line. |
| `properties_changed` | 1 | 1–2 | Two only if the second is `--cap-dim` on the others, which is the same code. |
| `active_colour` | `--cap-active` | — | Must differ from `--cap-accent` if an emphasis layer exists, or two codes collide. |
| `dim_level` | 0.75 of resting luminance | 0.60–0.85 | Below 0.60 read-back is destroyed. |
| `dim_method` | colour, not opacity | colour | Opacity thins a stroke too, costing contrast twice. |
| `leading_state` | full resting | full | Unspoken words stay fully legible; read-ahead is the entire point. |
| `active_vs_plate_ratio` | ≥4.5:1 | ≥4.5:1 | Check it. |
| `resting_vs_plate_ratio` | ≥4.5:1 | ≥4.5:1 | Also check this one — it is the one people skip. |
| `dim_vs_plate_ratio` | ≥3:1 | ≥3:1 | The dim state still has to be readable. |
| `swap_type` | binary `set` | set | Never crossfade between two active words — it reads as lag. |
| `transition_duration` | 0 f | 0–4 f | Above 4 f at 200 wpm the transition is still running when the next word starts. |
| `scale_step` | 1.06 | 1.00–1.12 | Only with `display: inline-block`. Above 1.12 the line visibly reflows anyway. |
| `box_padding` | 0.12 em / 0.2 em | — | Highlighter box. In `em` so it scales. |
| `box_on_plate` | forbidden | — | A box on a plate is two backings. |
| `redundant_cue` | position | required | Dimming makes the active word the leftmost undimmed one — free redundancy. |
| `simultaneous_active` | 1 | 1 | Always exactly one. |

## Reproduction prompt

```
Specify the active-word treatment for the karaoke caption track in {{PROJECT}},
where the backing is {{plate|stroke}}, speech runs at {{WPM}} wpm, and the accent
hue {{is|is not}} already committed to an emphasis layer.

Choose exactly ONE property to carry the active state: dim-the-rest, colour swap,
highlighter box, fill sweep, or scale step. Do not use a weight step — changing
font-weight changes advance widths, so the whole line shifts on every syllable
and visibly crawls. Do not combine two carriers.

Rule out by constraint first. A highlighter box is unavailable on a plated track
(a box on a box is two backings). A colour swap is unavailable if --cap-accent
already carries emphasis. A fill sweep or scale step is unavailable above ~200
wpm, because the transition is still running when the next word starts.

The active state must not be carried by hue alone: about 8% of male viewers have
a red-green deficiency. Dimming spoken words gives redundancy free — the active
word becomes the leftmost undimmed one.

Emit: the carrier; exact values for active, resting and dim; the transition type
(binary set is the default — never crossfade between two active words, it reads
as lag); and three contrast ratios against the plate — active, resting AND dim.

Acceptance test: extract every frame across a 0.5s window spanning one word
transition at native fps. The x position of the LAST word in the line must not
move more than 1px. Exactly one word carries the active state in every frame.
Greyscale must still identify it. Dim must be >=0.60 of resting luminance.
```

## Execution spec

Karaoke requires the **per-word element model** — one `<span>` per word, built once, with the timeline toggling classes. The staged single-span `textContent` design cannot do it at all, and the per-word model is separately the seek-robust fix for that design's known fragility (text set in `onStart` is not restored by a backwards seek).

```css
[data-composition-id="captions"] .w        { color: var(--cap-colour); display: inline-block; }
[data-composition-id="captions"] .w.spent  { color: var(--cap-dim); }
[data-composition-id="captions"] .w.active { color: var(--cap-active); }
```

```js
// Binary state swaps. `set`, positioned at the word's transcript onset.
words.forEach((w, i) => {
  tl.set(`#w${i}`, { className: "w active" }, w.start);
  tl.set(`#w${i}`, { className: "w spent"  }, w.end);
});
```

Stack constraints that decide the design:

- **`display: inline-block` is mandatory if the carrier is scale.** A `transform` on an inline element does not apply reliably, and a scale on a non-`inline-block` word changes the layout box and reflows the line.
- **Never tween `color` between two active words.** A crossfade reads as lag against speech. Discrete states use `set`.
- **Caption motion belongs to the gentle eases.** If the carrier does animate — a fill sweep, a scale settle — the project's typography guardrail puts caption fades on `power1.out` / `power2.out` and states these are *"NOT the entrance default."* Do not reach for `power3.out` here.
- **A fill sweep is a `background-clip: text` gradient with an animated `background-position`.** That is a paint-property tween, not a transform, and it repaints the whole word every frame. At 200 wpm across a 5-word line that is a lot of repaint per rendered frame. Prefer a two-layer approach: a duplicated word clipped by a `clip-path: inset()` that GSAP animates — still not a transform, but far cheaper.
- **`asr-keyword-glow`** is the named animation rule for keyword emphasis synced to ASR timestamps, and **per-word kinetic typography** is the named technique. Cite them; the `rules/` directory is not staged, so do not quote code. The staged `techniques.md` example uses a decaying slide distance (80→12 px), described as mimicking a camera settling — that is an *entrance* pattern, not an active-word pattern, and should not be borrowed here.
- Verify with dense frame extraction at the transition, not with `snapshot --at <midpoints>`; a midpoint sample cannot show a reflow.

## Pairs with

- [[sub-karaoke-active-word-highlight]] — the mechanic and the timing this note styles
- [[sub-caption-colour-token-system]] — where `--cap-active` and `--cap-dim` live
- [[sub-semantic-colour-assignment]] — the three-state case and its redundancy
- [[sub-emphasis-selection-rule]] — the accent budget this must not collide with
- [[sub-legibility-backing-ladder]] — a box carrier is unavailable on a plate
- [[sub-weight-case-and-optical-size]] — why the weight step reflows
- [[motion-emphasis-scale-step]] — the scale carrier, generalised
- [[motion-key-region-animate-in]] — one active region at a time

## Failure modes

- **Weight step as the carrier.** Advance widths change, the line crawls sideways on every syllable, and it is maddening to watch without being obviously wrong.
- **Scale on an inline element.** Either the transform is ignored or the line reflows.
- **Two carriers at once.** Colour plus scale plus box. The active word becomes an object rather than a word, and the eye stops reading the phrase.
- **Checking only the active state's contrast.** The resting state is on screen far more of the time.
- **Dimming below 60 %.** Read-back is destroyed and the viewer loses the sentence they are half way through.
- **Dimming the unspoken words.** Kills read-ahead, which is the only reason to hold a phrase instead of showing one word.
- **Crossfading between active words.** Reads as lag against the audio, which is the one thing a karaoke track must never do.
- **Hue-only active state.** Invisible to about 8 % of male viewers, at which point the track is a plain held phrase.
- **Using `--cap-accent` for the active state when an emphasis layer exists.** Two meanings, one hue.
- **Fill sweep at high speech rates.** The sweep is still running when the next word starts, so the line always looks one word behind.
