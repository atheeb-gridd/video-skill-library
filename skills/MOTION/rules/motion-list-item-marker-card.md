---
id: motion-list-item-marker-card
title: Mark every list item twice — spoken ordinal plus an identical on-screen card
skill: motion
type: graphic
family: list-spine
tags: [skill/motion, type/graphic, family/list-spine, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:00:16
    quote: "So in this video, we're gonna dive into 10 important editing cuts every filmmaker should know."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:00:45
    quote: "Number two, the jump cut."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:04:35
    quote: "Number nine is cross cutting."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/4406208331923-Title-Safe-and-Safe-Action-Best-Practices
  - https://infinitecreation.io/tutorial-lower-thirds
  - https://eks.tv/title-safe-still-matters/
  - https://www.retentionrabbit.com/blog/2025-youtube-audience-retention-benchmark-report
difficulty: low
detectable_from: transcript+video
---

# Mark every list item twice — spoken ordinal plus an identical on-screen card

## What it is
Every item in a counted list is announced **verbally with its ordinal** ("Number two, the jump cut", "Number nine is cross cutting") **and** marked on screen with a card that is pixel-identical from item to item. The redundancy is the point: the spoken ordinal is a progress read for a viewer who is listening while doing something else, the card is a progress read for a viewer who is scrubbing, and the identical template means neither costs attention after the second item. In the source, ten items run 00:00:21 → 00:05:26, roughly **30 seconds per item**, each opened by a spoken ordinal. This note covers the *marker mechanics*; the structural side — how many items, where the sponsor goes, how the promise is made — lives in [[struct-numbered-list-mid-roll-sponsor]] and [[struct-enumerated-promise-and-counter]].

## When to use it
On any enumerated payload: N cut types, N mistakes, N tools, N steps. Choose the marker *form* from the item's weight and the item's length:
- **Full-frame title card** — items ≥45 s, or a video with ≤7 items where each is a chapter. It stops the picture, which is a real cost; it buys a hard reset of attention.
- **Lower third / corner badge** — items 20–45 s, and any item where the picture must keep running (a demo is already on screen).
- **Persistent counter** ("3/10" in a corner for the item's whole duration) — only when N ≤ 10 and items are short; it is the only form that answers "how much is left" at any random frame, which is why it is worth the permanent pixel cost on a fast list.
Do not mix forms arbitrarily. Pick one primary form and use it for every item; a second form may be added *on top* consistently (e.g. persistent counter plus a lower third at each boundary).

## How to recognise it in a reference video
- **Extract the spoken markers first; they are the ground truth for the structure.**
  `grep -nEi "\[([0-9:]+)\].*\b(number|point|no\.?) ?(one|two|three|four|five|six|seven|eight|nine|ten|[0-9]+)\b|\b(first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth)\b (is|comes|we)" transcript.md`
- **For each marker timestamp, pull the frames and classify the on-screen form:**
  `ffmpeg -ss <t> -t 3 -i ref.mp4 -vf fps=10 m_%02d.png`
  - Picture fully replaced → full-frame card.
  - Picture continues, graphic occupies the lower or corner band → lower third / badge.
  - Same graphic present in frames sampled *between* markers → persistent counter.
- **Test template identity.** This is the strongest quality signal available and it is cheap: overlay two different items' marker frames and difference them. Everything except the number and the label must cancel.
  `ffmpeg -i m_item2.png -i m_item7.png -filter_complex "blend=all_mode=difference" -update 1 d.png`
  Pixel-identical placement is the tell that it is a template rather than hand-built cards.
- **Measure the hold.** Full-frame cards hold **1.5–3.0 s**; lower thirds **2.5–5.0 s**. Under 1.2 s nothing longer than three words can be read.
- **Measure the entrance.** **0.5–1.0 s** (15–30 f at 30fps); published lower-third practice is 15–25 frames at 25fps with the exit mirroring the reveal. Exits in good work are shorter than entrances.
- **Measure the offset from the spoken ordinal.** The card should arrive within **±0.5 s** of the word "number", and published practice places a lower third about **0.5 s after** the speaker begins. A card arriving two seconds late is a defect.
- **Check safe areas.** Netflix/SMPTE: **title safe = 90%** of the 16:9 frame, **safe action = 93%**. At 1920×1080 a 10%-inset title-safe box starts **192 px from the left and 108 px from the bottom**. Measure the graphic's bounding box against that.
- **Check legibility at feed size.** Downscale a marker frame to 480 px wide and read it. If the number survives and the label does not, the label is too small for mobile.
- **Audio at the marker.** Nearly always one short accent — a soft whoosh or tick on the card's entrance — plus, often, a music section change. A silent marker card reads as hollow because the brain expects a sound with motion.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `marker_form` | lower-third | full-card \| lower-third \| persistent | Pick one primary and never vary it. |
| `card_hold` (full) | 2.2 s | 1.5–3.0 s | Full-frame card blocks picture; keep it short. |
| `card_hold` (lower third) | 3.5 s | 2.5–5.0 s | Long enough to read twice. |
| `in_dur` | 0.60 s (18 f) | 0.50–1.00 s | Published range 15–25 f @25fps. House ease `power3.out`. |
| `out_dur` | 0.35 s (10 f) | 0.25–0.50 s | Entrances need longer than exits (0.4 in / 0.25 out is the house ratio). |
| `offset_from_word` | +0.20 s (6 f) | −0.30 to +0.50 s | Relative to the spoken ordinal. Card slightly after the word, never before. |
| `number_size` | 180 px | 120–260 px @1080p | The number is the hierarchy; make it 2.5–3.5× the label. |
| `label_size` | 64 px | 48–90 px @1080p | Full-screen viewing. **In-feed** (X / LinkedIn / IG): headlines ≥90 px, body ≥32 px, labels ≥24 px. |
| `secondary_ratio` | 0.65 | 0.60–0.75 | Secondary line as a fraction of primary — published lower-third practice. |
| `tracking` | −0.04 em | −0.03 to −0.05 em | At display sizes; video encoding compresses letter detail. |
| `title_safe` | 90% | 90–93% | 192 px / 108 px inset at 1080p. Marker must sit fully inside. |
| `bottom_inset` | 210 px | 150–260 px @1080p | Keeps the marker clear of the caption zone. |
| `label_words` | 3 | 1–5 | The item's name, not its definition. |
| `sfx` | soft tick / whoosh | — | −12 to −15 dB. One transient on the entrance only. |
| `interval_cv` | <0.30 | 0–0.35 | Coefficient of variation of the gaps between markers; a real cadence is regular. |

## Reproduction prompt

```
Build the item-marker system for a numbered list video of N items.

1. From the transcript, extract every spoken ordinal and its timestamp. That
   list is the structure. If the count does not equal the N promised in the
   intro, stop and fix the script - a mismatched count is the most detectable
   failure of a list video.

2. Pick ONE marker form for the whole video:
     items >= 45s, or N <= 7   -> full-frame card
     items 20-45s              -> lower third
     N <= 10 and items short   -> persistent counter (optionally + lower third)

3. Build it ONCE as a parameterised template taking two values: NUMBER and
   LABEL (3 words maximum - the item's name, not its definition). Every
   instance must be pixel-identical apart from those two strings. Do not
   hand-place cards per item.

4. Geometry at 1920x1080: NUMBER at 180px, LABEL at 64px (0.65 x is the
   secondary ratio if you have a second line), tracking -0.04em, whole graphic
   inside the 90% title-safe box (>=192px from left/right, >=108px from
   top/bottom), bottom inset 210px for a lower third. If the deliverable is
   in-feed, raise LABEL to >=90px.

5. Timing per instance, where W = the timestamp of the spoken ordinal:
     card in   at W + 0.20s, over 0.60s, ease power3.out
     hold      3.5s (lower third) or 2.2s (full card)
     card out  over 0.35s, ease power2.in
   Nothing else on screen animates during the entrance.

6. Add exactly one sound on the entrance frame: a soft tick or short whoosh at
   -12 to -15 dB, its loudest frame on the card's first visible frame. Nothing
   on the exit.

7. Verify the cadence: compute the gaps between consecutive markers; the
   coefficient of variation must be under 0.30. If one item is three times
   longer than the others, split it or cut it.

ACCEPTANCE TEST: (a) difference two different items' marker frames - only the
number and label may differ; (b) downscale one marker frame to 480px wide -
both number and label must still be readable; (c) every marker's bounding box
is inside 90% title safe, checked on a snapshot, not assumed; (d) each card
arrives within 0.5s of its spoken ordinal; (e) all N items have a marker and
the count matches the promise.
```

## Execution spec

**HyperFrames — build the marker as ONE parameterised sub-composition and instance it N times.** This is exactly what composition variables exist for, and it is the only way to guarantee template identity.

`compositions/item-marker.html` (sub-comp form — the root **is** wrapped in `<template>`, and its `<style>` must live **inside** the template because the assembler drops the file's own `<head>` styles):

```html
<html data-composition-variables='[
  {"id":"num","type":"string","label":"Number","default":"1"},
  {"id":"label","type":"string","label":"Item name","default":"The cut"}]'>
<template id="item-marker-template">
  <div data-composition-id="item-marker" data-width="1920" data-height="1080" data-duration="4.5"
       style="position:relative; width:1920px; height:1080px; overflow:hidden;">
    <style>
      [data-composition-id="item-marker"] .wrap{position:absolute; inset:0; display:flex;
        align-items:flex-end; justify-content:flex-start; padding:0 0 210px 192px;}
      [data-composition-id="item-marker"] .num{font-family:"Archivo Black",sans-serif;
        font-size:180px; line-height:.9; letter-spacing:-.04em; color:#ffd24a;}
      [data-composition-id="item-marker"] .lbl{font-family:"Oswald",sans-serif;
        font-size:64px; letter-spacing:-.03em; color:#fff; margin-left:28px; padding-bottom:18px;}
    </style>
    <div class="wrap">
      <div id="im-num"  class="num" data-var-text="num">1</div>
      <div id="im-lbl"  class="lbl" data-var-text="label">The cut</div>
    </div>
  </div>
</template>
<script src="./vendor/gsap.min.js"></script>
<script>
  const tl = gsap.timeline({ paused: true, defaults: { ease: "power3.out" } });
  tl.fromTo("#im-num", { y: 34, autoAlpha: 0 }, { y: 0, autoAlpha: 1, duration: 0.60 }, 0.0);
  tl.fromTo("#im-lbl", { y: 34, autoAlpha: 0 }, { y: 0, autoAlpha: 1, duration: 0.60 }, 0.08);
  tl.to("#im-num", { autoAlpha: 0, duration: 0.35, ease: "power2.in" }, 4.05);
  tl.to("#im-lbl", { autoAlpha: 0, duration: 0.35, ease: "power2.in" }, 4.05);
  window.__timelines["item-marker"] = tl;
</script>
</html>
```

Host slots in `index.html`, one per item, each overriding the two variables:

```html
<div id="el-mk-02" data-composition-id="item-marker" data-composition-src="compositions/item-marker.html"
     data-start="45.2" data-duration="4.5" data-track-index="3"
     data-variable-values='{"num":"2","label":"The jump cut"}'></div>
<div id="el-mk-09" data-composition-id="item-marker" data-composition-src="compositions/item-marker.html"
     data-start="275.4" data-duration="4.5" data-track-index="3"
     data-variable-values='{"num":"9","label":"Cross cutting"}'></div>
```

Contract points that bind this:
- **`data-var-text`** binds an element's own text to a scalar variable id (children preserved); **`data-variable-values`** overrides them per host instance. `data-composition-variables` is a JSON **array of declarations** on `<html>`; render-time `--variables` is a JSON **object keyed by id**.
- Exactly **one** `gsap.timeline({paused:true})` per composition, keyed by the root's `data-composition-id`. Do **not** manually nest it into the host — the runtime auto-nests registered child timelines.
- Sub-comp time is **scene-local**: the tween at `0.0` fires at the host's `data-start`. Do not add the host offset inside the sub-comp.
- **A sub-comp timeline cannot animate host-root elements.** Everything the marker animates must live inside the marker.
- Keep every `id` unique across the **assembled** page — prefix sub-comp ids (`#im-…`) as done here.
- `fromTo`, never `from` (`from()` sets `immediateRender:true` and flashes under non-linear seek).
- `autoAlpha` on inner elements, never `display`/`visibility` on the clip.
- Land the exits **before** `data-duration` (4.05 + 0.35 = 4.40 < 4.50): the window is half-open and the final frame is never rendered.
- The root needs an explicit **sized px box** and every ancestor a resolved height, or a `100%` child collapses to zero and the content piles into the top-left. **`snapshot --at <midpoints>` is required for projects with sub-compositions** — it is the only real defence against this and against the silent relative-timing zeros.
- **No CDN scripts.** `cdn.jsdelivr.net` is blocked by the egress allowlist; GSAP must be vendored locally (`./vendor/gsap.min.js` above). Fonts must be bundled or local `@font-face` — the implicit Google Fonts fetch is a network path. **Do not use `Inter`**: bundled, but on the banned monoculture list. Archivo Black / Oswald / Montserrat / League Gothic are safe bundled picks.
- Keep the marker out of the caption band, or the layout audit fires `caption_zone_collision`; the narrow opt-out is `data-layout-allow-caption-zone` (element + descendants). Prefer moving the graphic.
- **Persistent-counter variant:** one clip spanning the whole list with a `steps(1)` text update per item, or N one-frame `tl.set()` text swaps on a non-clip element. Note the known fragility of the staged captions pattern: text set in `onStart` does **not** restore correctly on a backwards seek. For a counter that must be right at every frame, prefer **one element per state with per-state opacity envelopes** over one reused element.

**ffmpeg** — only for auditing a reference (frame pulls and the difference test shown in the recognition section), or for burning a marker into a deliverable that leaves the pipeline:

```bash
ffmpeg -i in.mp4 -vf "drawtext=fontfile=./vendor/ArchivoBlack.ttf:text='2':fontsize=180:\
fontcolor=0xffd24a:x=192:y=h-210-180:enable='between(t,45.2,49.7)'" out.mp4
```

**Epidemic Sound:** one short transient per marker, and **not the same file every time** — the third named sound-design mistake is the same effect repeated. Fetch one, then vary:

```
SearchSoundEffects({ query: { term: "ui tick short transition whoosh" },
                     filter: { duration: { max: 900 } }, first: 12,
                     sort: { by: "POPULARITY", order: "DESCENDING" } })
```
Reuse at ±2 semitones and slightly different lengths across the ten instances, or pull three files and rotate. Place with the transient's loudest frame on the card's first visible frame, `data-audio-group="sfx"`, −12 to −15 dB. See [[sfx-whoosh-transition-movement-reveal]].

**Remotion:** a single `<ItemMarker number label />` component instanced N times inside `<Sequence>`s; conceptually the same parameterised-template approach.

## Pairs with
[[struct-numbered-list-mid-roll-sponsor]] · [[struct-enumerated-promise-and-counter]] · [[struct-name-define-demonstrate]] · [[sfx-whoosh-transition-movement-reveal]] · [[motion-image-focal-point-direction]] · [[pace-silent-demonstration-window]] · [[struct-demo-before-label]]

## Failure modes
- **Hand-built cards.** Placement drifts a few pixels per item and the video reads as sloppy even though no single frame looks wrong. Correction: one parameterised sub-comp, instanced with `data-variable-values`.
- **Card without the spoken ordinal, or ordinal without the card.** Half the audience loses the progress read. Correction: both, every item.
- **Label carrying the definition.** "Number 3: the match cut, which matches shape, colour or framing" cannot be read in 3.5 s. Correction: three words maximum; the definition is spoken, not printed.
- **Marker outside title safe.** Cropped on some players and in some feed embeds. Correction: 90% box, verified on a snapshot.
- **Too small for feed.** Correction: label ≥90 px if the deliverable will be watched in-feed.
- **Bouncy entrance.** `back.out`/`elastic` on a marker undercuts the authority of a teaching video; the house doctrine is *smooth beats bouncy*, with overshoot reserved for an explicitly playful register. Correction: `power3.out`.
- **Silent card.** The brain expects a sound with motion; without one the marker feels hollow. Correction: one transient, −12 to −15 dB.
- **Identical SFX ten times.** Correction: rotate three files or vary pitch ±2 semitones.
- **Uniform item lengths at uniform energy.** Not a marker fault, but markers make it visible: a list where every item runs exactly 30 s at the same intensity loses viewers mid-list. Correction: vary item length deliberately (strong items 90–120 s, simple items 40–60 s).
- **Known gap:** the browser-dependent layout/contrast audits and `snapshot` cannot run on the authoring VM (linux ARM64, no sudo). The safe-area and legibility checks in the acceptance test therefore have to be performed on the render host, and the note-driven pipeline must not assume they ran locally.
