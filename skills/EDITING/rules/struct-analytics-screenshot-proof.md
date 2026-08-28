---
id: struct-analytics-screenshot-proof
title: Analytics as proof — put the real numbers on screen instead of claiming them
skill: editing
type: structure
family: hook
tags: [skill/editing, type/structure, family/hook, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "visual — contact sheet, analytics segments"
    quote: "[NOT SPOKEN — observed on screen] YouTube Studio screenshots with real figures: 239,516 views · 14.9K · +6.5K · $916.71."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "visual — contact sheet, retention segment"
    quote: "[NOT SPOKEN — observed on screen] 'BORING' stamped in red across a YouTube analytics screenshot — the red-overlay-as-negation device applied to a real retention graph."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:12:01"
    quote: "The more emotionally invested viewers are, the more engaged they are."
research_refs:
  - https://en.wikipedia.org/wiki/Argument_from_authority
  - https://en.wikipedia.org/wiki/Social_proof
  - https://prepublish.ai/guides/youtube-retention-guide
  - https://legibility.info/rules-for-text-in-videos
  - _meta/visual-kt-delta.md
difficulty: low
detectable_from: video
---

# Analytics as proof — put the real numbers on screen instead of claiming them

## What it is
`editing kt` repeatedly cuts to **YouTube Studio screenshots carrying real figures** — 239,516 views, 14.9K, +6.5K, $916.71 — and in one case stamps **`BORING` in red across a retention graph**. The device is evidence substitution: instead of *"this works"*, the screen shows the artefact that would exist if it worked.

Two distinct jobs, and they should not be confused:

- **Credibility (the numbers).** A revenue or views figure is a claim about the creator's standing. It licenses the advice that follows and is spent once, near the top ([[struct-credibility-anchor]]).
- **Diagnosis (the retention graph).** A retention curve with a marked dip is a claim about *the viewer's own experience* — here is where people left, and here is why. That is not authority, it is a shared observation, and it can be used repeatedly through a video without wearing out.

The retention-graph form is the more valuable of the two, because it turns an abstract craft rule into a measurable consequence: "this section was boring" is an opinion until the curve drops at exactly the moment being discussed. The red annotation is the same negation device the creator uses on text throughout — struck-through or red-overlaid means *this is the thing being rejected* — applied to a chart ([[motion-annotation-draw-on]] for the annotation mechanics; the red-as-negation caption rule belongs to the subtitles library).

**The honesty constraint is the whole technique.** A screenshot presented as evidence must be evidence: unedited numbers, a visible time range, and the same account throughout. Cropping a graph to hide its axis, or showing the one video that worked, converts proof into a survivorship claim — and a viewer who catches it discounts everything else in the video. Where a figure cannot be shown honestly, do not show a figure ([[struct-recognisable-clip-evidence]] is the same discipline applied to film clips).

## When to use it
- **Immediately after the promise, once**, as the credibility beat that licenses the rest ([[struct-demand-hook-competence-gap]]).
- **On any claim about retention, watch time or audience behaviour** — the one class of claim where the evidence is a chart the audience already knows how to read.
- **When diagnosing a mistake**, with the dip marked: the graph shows the cost of the thing you are telling people not to do ([[struct-stimulation-budget]], [[pace-visual-mush-ceiling]]).
- **Before and after a change**, as a pair of screenshots from the same account with the same axes — the strongest form of the device.
- **Not as the hook.** Numbers are proof of standing, not a reason to watch.
- **Not repeatedly for credibility.** Three revenue screenshots in a video is a flex, and audiences read it as one.
- **Not with numbers you cannot show.** A quoted figure with no artefact behind it is weaker than no figure at all, because it invites the question.

## How to recognise it in a reference video
- **A real UI is visible** — Studio chrome, date ranges, axis labels — rather than a recreated graphic. Recreated charts are a different (weaker) device.
- **The figure is legible**: cropped to the number, scaled up, on screen for at least 2 seconds.
- **The annotation marks one thing.** One dip, one circle, one stamped word. Two annotations on one chart is two arguments.
- **Check whether the axis survives the crop.** A retention curve with no y-axis and no time range is decoration wearing evidence's clothes — log it as such.
- **Check the frequency.** Once or twice per video is credibility; five times is a channel-growth video wearing a craft video's title.
- **The narration names the number.** If the voice does not say what the figure is, the screenshot is being used as texture.
- **Look for the counter-example.** Creators using this well show a bad graph too; only-good-numbers is a survivorship tell.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `instances_credibility` | 1 | 1–2 | Per video. Spend it just after the promise. |
| `instances_diagnostic` | as needed | 0–5 | Retention graphs tied to a specific claim do not wear out the way revenue figures do. |
| `dwell` | 2.5 s | 2.0–4.0 s | Long enough to read a number and its label. Reading budget: characters ÷ 13 s. |
| `crop` | figure + its label + the date range | — | The label and range are what make it evidence rather than a number. |
| `scale` | figure ≥60 px tall @1080p | 48–120 px | Studio's own type is far too small at full-frame scale. |
| `annotation` | 1 per screenshot | 0–1 | Circle, arrow, or a stamped word in the negation colour. |
| `annotation_colour` | red | — | Reserved for negation across the whole video, or it stops meaning anything. |
| `annotation_draw` | 0.35 s draw-on | 0.25–0.5 s | Hand-drawn feel; arrives after the chart has been seen, not with it. |
| `push_in` | 1.00 → 1.04 over the dwell | ≤1.06 | Stops a still reading as a freeze. |
| `redaction` | hide unrelated video titles / private data | — | Crop rather than blur where possible; blur reads as something to hide. |
| `pairing` | before + after from one account | — | The strongest form. Same axes, same range, stated. |

## Reproduction prompt

```
Support {{CLAIM}} with an analytics screenshot instead of an assertion.

1. DECIDE WHICH JOB. Credibility (a standing figure - views, subs, revenue)
   or diagnosis (a retention curve tied to a specific editing decision)?
   Credibility: once, right after the promise. Diagnosis: wherever the claim
   is made.
2. CAPTURE THE REAL UI at the largest window size available, including the
   metric label and the date range. Do not recreate the chart as a graphic.
3. CROP to the figure plus its label plus the range; scale so the number is
   at least 60 px tall at 1080p. Redact unrelated private data by cropping.
4. ANNOTATE ONE THING, arriving 0.4-0.8 s after the screenshot so the viewer
   has seen the chart first: a hand-drawn circle on the dip, an arrow, or a
   single word stamped in the video's negation colour.
5. HOLD 2.5 s with a 1.00 -> 1.04 push-in, and NAME THE NUMBER in the
   narration. If the voice does not say it, cut the screenshot.
6. HONESTY CHECK before shipping: is the axis visible, is the range stated,
   is it the same account as every other figure in the video, and would the
   claim survive if you also showed the video that failed? If any answer is
   no, fix the screenshot or drop the claim.

ACCEPTANCE TEST: a sceptical viewer pausing on the frame can verify what the
number is a number OF. If they cannot, it is texture, not proof.
```

## Execution spec

**HyperFrames.** A still, a push-in, and a drawn annotation that arrives late:

```html
<div class="clip" id="proof-retention" data-start="146.00" data-duration="2.80" data-track-index="2">
  <img id="pr-shot" src="assets/img/retention.png" alt="">
  <svg id="pr-mark" viewBox="0 0 1920 1080" aria-hidden="true"><path id="pr-circle" d="…"/></svg>
  <span id="pr-stamp">BORING</span>
</div>
```
```js
const IN = 146.0;
tl.fromTo("#pr-shot", { scale: 1.00, autoAlpha: 0 },
  { scale: 1.04, autoAlpha: 1, duration: 2.8, ease: "none" }, IN);
tl.fromTo("#pr-circle", { strokeDashoffset: 900 },
  { strokeDashoffset: 0, duration: 0.35, ease: "power2.out" }, IN + 0.6);
tl.fromTo("#pr-stamp", { autoAlpha: 0, scale: 1.15, rotation: -6 },
  { autoAlpha: 1, scale: 1, rotation: -6, duration: 0.18, ease: "power4.out" }, IN + 0.85);
```
`strokeDashoffset` is the right primitive for a draw-on and is legitimate because it is not a layout property; everything else stays on transform aliases (`scale`, `rotation`) — `width`/`top`/`left` tweens are forbidden. **`fromTo`, never `from`.** `autoAlpha`, never on the clip element itself. Land the last tween before `data-duration`. Give the stamp a hard, fast ease — it is a punctuation mark, and it wants an impact sound on the same frame ([[sfx-cinematic-hit-emphasis]], [[motion-instant-appearance-sfx-justified]]).

**ffmpeg — capture prep.**
```bash
# crop to the figure + label + range, upscale with a sharp scaler
ffmpeg -i studio_raw.png -vf "crop=1180:520:120:210,scale=1720:-1:flags=lanczos" assets/img/retention.png
# quick legibility check: render the composed frame and read it at 50%
ffmpeg -ss 147.0 -i out.mp4 -frames:v 1 /tmp/proof.png
```

**Sound.** The stamp lands on a hit; the screenshot itself usually wants nothing. A whoosh on a static chart is motion sound with no motion ([[sfx-placement-discipline]]).

## Pairs with
[[struct-credibility-anchor]] · [[struct-demand-hook-competence-gap]] · [[struct-comment-screenshot-cold-open]] · [[struct-recognisable-clip-evidence]] · [[struct-stimulation-budget]] · [[pace-visual-mush-ceiling]] · [[motion-annotation-draw-on]] · [[motion-still-image-drift]] · [[motion-instant-appearance-sfx-justified]] · [[cut-screen-recording-proof-insert]]

## Failure modes
- **Cropping away the axis or the date range.** The number stops being checkable and the device becomes decoration.
- **Recreating the chart as a graphic.** A designed chart is a claim; a screenshot is an artefact. Use the real UI.
- **Using it as the hook.** Numbers prove standing; they do not promise the viewer anything.
- **Repeating the credibility figure.** Once is evidence, three times is a flex, and the audience keeps score.
- **Only good numbers.** Showing exclusively successful videos is a survivorship claim; one honest bad graph buys more trust than five good ones.
- **Two annotations on one chart.** Two arguments, neither landing. One mark per screenshot.
- **Annotation arriving with the chart.** The viewer has not read the graph yet, so the mark points at nothing. Delay it 0.4–0.8 s.
- **Red used for anything else in the video.** The negation colour has to be reserved or the stamp stops signalling.
- **Unreadable at phone size.** Most viewing is small; if the number is not ~60 px at 1080p it does not exist.
- **Known gap:** the reference's dwell times and annotation timings are not measurable from a contact sheet — the figures, the red stamp and the recurrence are observed; the numbers here come from the reading budget and this library's still-image notes.
