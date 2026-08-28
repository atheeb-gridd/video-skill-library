---
id: pace-overlay-instead-of-cut
title: Spend an overlay instead of a cut
skill: editing
type: pacing
family: visual-variety
tags: [skill/editing, type/pacing, family/visual-variety, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:48"
    quote: "Next, layer a bunch of visual elements over your footage."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:09"
    quote: "Give boring still images movement - slowly change scale or position."
research_refs:
  - https://grokipedia.com/page/Safe_area_(television)
  - https://www.smashingmagazine.com/2023/08/designing-accessible-text-over-images-part1/
  - https://www.opus.pro/research/broll-visual-effects-short-form
  - https://air.io/en/youtube-hacks/advanced-retention-editing-cutting-patterns-that-keep-viewers-past-minute-8
difficulty: medium
detectable_from: video
---

# Spend an overlay instead of a cut

## What it is
Visual novelty is the resource a long-form edit spends to hold attention, and a cut is only one way to buy it. Stacking elements *on top of* a continuing shot — a labelled callout, an inset B-roll window, a stat card, a highlight box, a drifting still — refreshes the frame while the shot, the eyeline and the performance continue unbroken. The cut is preserved for moments that actually need a new vantage point. Alias in the source material: "layer a bunch of visual elements over your footage."

## When to use it
Reach for an overlay rather than a cut when: the A-roll line is important and the speaker's face is carrying it (a cut away would cost you the delivery); the `visual_change_interval` in the profile is about to be exceeded but no new information has arrived; you have a number, a name, a quote or a list that is easier read than heard; there is no B-roll that honestly covers the line; or you have already used two cuts in the last five seconds and a third would read as churn. Do **not** use it when the point is a genuine change of subject — that is a cut's job.

## How to recognise it in a reference video
- **The base shot does not change while the frame does.** Freeze two frames 1–2 s apart: same camera, same framing, same background, but a new element present in the second. That is an overlay, not a cut.
- **Element count.** Count simultaneous non-caption overlay elements. Professional practice sits at **1–3**; four or more at once is the amateur tell.
- **Dwell time.** Overlay elements typically live **2.5–5 s** (75–150 f). Inset B-roll windows under a continuing voice run **3–5 s max** before they start stealing the voice.
- **Entrance signature.** Overlays enter with a short transform+opacity move, **8–15 frames (0.27–0.5 s)**, long-tail ease, and exit faster than they entered (**6–8 f**). No overlay hard-cuts on.
- **Staggering.** When two or three arrive together they are offset by **3–6 f** each, and the whole group lands within **15 f**, so it reads as one arrival.
- **Placement discipline.** Every element sits inside the **title-safe 90%** box; nothing important crosses the lower-caption band.
- **Legibility treatment.** Look for a scrim, a solid strip, a blurred backdrop, or a darkened surround under every text element. If text sits raw on busy footage, the reference is not doing this well — do not copy it.
- **Audio track corroboration.** Each overlay arrival almost always carries a soft motion SFX (a swish or short whoosh, −12 to −15 dB). Overlays with silent entrances are the second-commonest amateur tell.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `simultaneous_elements` | 2 | 1–3 | Excludes captions. 4+ = reject |
| `dwell` | 3.0 s (90 f) | 2.5–5.0 s | Long enough to read twice at normal reading speed |
| `inset_broll_hold` | 3.5 s (105 f) | 2.5–5.0 s | Over ~5 s it pulls focus off the narrator |
| `entrance_duration` | 0.4 s (12 f) | 0.27–0.5 s | `power3.out` (house default) |
| `exit_duration` | 0.25 s (7.5 f) | 0.2–0.3 s | `power2.in`; exits are always shorter than entrances |
| `stagger_each` | 0.15 s (4.5 f) | 0.1–0.2 s | Hard cap: `items × stagger ≤ 0.5 s` |
| `entrance_offset` | 40 px | 24–64 px | Transform distance at 1920×1080; scale to frame height |
| `title_safe_inset` | 5% | 3.5–10% | 1920×1080 → 96 px L/R, 54 px T/B. 1080×1920 → 54 px L/R, 96 px T/B |
| `action_safe_inset` | 3.5% | 3.5–5% | 93% box, SMPTE ST 2046-1 |
| `scrim_opacity` | 0.65 | 0.45–0.80 | Black scrim under text; tune until contrast passes |
| `contrast_ratio` | 4.5:1 | ≥3:1 large, ≥4.5:1 body | WCAG 1.4.3; large = 18 pt+ normal / 14 pt+ bold |
| `backdrop_blur` | 12 px | 8–16 px | Alternative to a scrim when the plate must stay visible |
| `overlays_per_minute` | 2 | 0–6 | Governed by [[struct-stimulation-budget]] |

## Reproduction prompt

```
Add a layered overlay to a continuing shot instead of cutting away.

Target window {{IN}} to {{OUT}} in composition seconds, 30fps. The base clip is NOT trimmed,
split, or re-timed - it plays through untouched.

1. Create the overlay as a `div class="clip"` SIBLING (never a child of the video's timed
   wrapper) with a unique id, `data-start="{{IN}}"`, `data-duration="{{DWELL}}"` (default 3.0),
   and a CSS `z-index` above the base video.
2. `position:absolute`, inside the title-safe box: 5% inset from every edge (96 px L/R, 54 px T/B
   at 1920x1080). Nothing enters the lower caption band.
3. Guarantee legibility before animating: a black scrim at opacity 0.65 or a 12 px backdrop blur
   behind the text; verify >=4.5:1 contrast for body copy, >=3:1 at display sizes. Video type
   sizes: body >=20 px full-screen / >=32 px in-feed, headline 60 px+, tracking -0.03 to -0.05em.
4. Animate on the single paused GSAP timeline with fromTo, never from:
   tl.fromTo("#{{ID}} .item", { y: 40, autoAlpha: 0 },
     { y: 0, autoAlpha: 1, duration: 0.4, ease: "power3.out", stagger: 0.15 }, {{IN}});
   tl.to("#{{ID}} .item", { autoAlpha: 0, duration: 0.25, ease: "power2.in" },
     {{IN}} + {{DWELL}} - 0.3);
   Total stagger <= 0.5 s. The exit must land BEFORE data-duration ends.
5. At most 3 simultaneous overlay elements, captions excluded.
6. One motion SFX on a separate audio clip at exactly {{IN}}, -12 to -15 dB.

Acceptance test: at {{IN}} - 0.1 and {{OUT}} + 0.1 the frame is the untouched base shot; between
them the overlay is legible at 100% zoom, nothing crosses the title-safe box, and the base
video's data-start / data-duration / data-media-start are unchanged.
```

## Execution spec

**HyperFrames** — the overlay is a root-level sibling clip, layered by `z-index` (never by `data-track-index`, which is display-only):

```html
<video id="a-roll" src="assets/aroll.mp4" data-start="0" data-duration="42"
       data-track-index="0" muted playsinline style="z-index:0"></video>
<audio id="a-roll-audio" src="assets/aroll.mp4" data-start="0" data-duration="42"
       data-track-index="10"></audio>

<div id="ov-stat" class="clip" data-start="12.4" data-duration="3.0" data-track-index="3"
     style="z-index:4">
  <div class="scrim"></div>
  <div class="item headline">42.1%</div>
  <div class="item label">average retention, how-to</div>
</div>

<audio id="sfx-ov-stat" src="assets/sfx/swish.wav" data-audio-group="sfx"
       data-start="12.4" data-duration="0.5" data-track-index="12" data-volume="0.28"></audio>
```

Contract points that bind this markup:
- `data-start` is what makes the div a clip; `data-duration` is **required** on a `div`, or it stays visible for the rest of the composition.
- The window is half-open `[start, start+duration)` — land the exit tween before the end or its last frame never renders.
- `video_nested_in_timed_element` is an **error**: never put the overlay inside a timed `<video>` wrapper, and never give the `<video>` a timed ancestor.
- Root-level clips are forced to `position:absolute; top:0; left:0` and sized to 100%. An untimed full-bleed child needs its own `position:absolute; inset:0`.
- No CSS `transform` on an element you GSAP-tween (`gsap_css_transform_conflict`, error). No `width`/`height`/`top`/`left` tweens. Use `x`/`y`/`scale`/`autoAlpha`.
- If the composition uses shader transitions, avoid the `transparent` keyword in the scrim gradient — use the target colour at zero alpha — and give the overlay an explicit `background-color`.
- Sub-comp boundary: a sub-composition timeline **cannot** animate host-root elements. Either put the overlay inside the sub-comp, or keep it at the host root and position its tween at `global = scene-local + slot data-start`.

**ffmpeg** — only needed to prepare the *content* of an inset, never to composite (compositing is HyperFrames):

```bash
# trim a 3.5s inset B-roll window without re-encoding
ffmpeg -i broll.mp4 -ss 00:00:31 -to 00:00:34.5 -c copy inset.mp4
```
Prefer `data-media-start` + `data-duration` in the composition and cut no file at all.

**Epidemic Sound** — fetch the entrance sound:
`SearchSoundEffects({ query: { term: "swish transition short" }, filter: { duration: { min: 200, max: 900 } }, sort: { by: "RELEVANCE", order: "DESCENDING" } })`, then `DownloadSoundEffect` into `assets/sfx/`.

**Remotion**: the same layering as a sibling `<AbsoluteFill>` above the video with a spring-driven entrance; concept only — Remotion is not part of this stack.

## Pairs with
[[struct-stimulation-budget]] · [[pace-cut-density-from-viewer-intent]] · [[cut-punch-in-emphasis]] · [[cut-movement-match]] · [[struct-name-define-demonstrate]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-riser-anticipation-build]]

## Failure modes
- **Overlay stack instead of overlay budget.** Five elements at once turns the frame into a dashboard. Correction: cap at 3, stagger their arrival, and let the earliest one leave before the fourth arrives.
- **Text with no legibility treatment.** Raw white type over moving footage fails contrast in half the frames. Correction: scrim at 0.65, a solid strip, or a 12 px backdrop blur — verified, not eyeballed.
- **Overlay used as an excuse not to cut.** If the subject genuinely changed, an overlay reads as evasion. Correction: cut, and put the overlay on the new shot if you still need it.
- **Silent arrival.** An element that appears with no motion SFX reads as a glitch. Correction: one short swish at −12 to −15 dB at exactly the entrance frame.
- **Animating the clip element's `display`/`visibility`.** Lint rejects it; the framework owns clip visibility. Correction: `autoAlpha` on an inner non-clip wrapper.
- **Crossing into the caption zone.** The layout audit raises `caption_zone_collision`. Correction: move it, or opt out narrowly with `data-layout-allow-caption-zone` — not with `data-layout-allow-overflow`, whose blast radius suppresses four other audits across the whole subtree.
- **Known gap:** there is no automatic content-aware placement or face tracking in this stack. The safe box is authored geometry; if the speaker moves into it, you must reposition by hand.
