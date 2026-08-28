---
id: sub-platform-ui-overlap-map
title: Map the platform UI band per destination — TikTok, Reels, Shorts and YouTube do not agree
skill: subtitles
type: caption-style
family: safe-area
tags: [skill/subtitles, type/caption-style, family/safe-area, engine/hyperframes, source/research, source/hyperframes, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "the layout audit's --caption-zone / caption_zone_collision check, and its opt-out data-layout-allow-caption-zone (element + descendants, via closest)."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: ".captions-container — padding-bottom: 230px (comment: \"Position at y: 850 (1080 - 230 = 850)\")."
research_refs:
  - https://sproutsocial.com/insights/social-media-video-specs-guide/
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://en.wikipedia.org/wiki/Safe_area_(television)
  - https://www.w3.org/TR/ttml-imsc1.1/
difficulty: medium
detectable_from: video
---

# Map the platform UI band per destination — TikTok, Reels, Shorts and YouTube do not agree

## What it is

Every vertical short-form platform paints its own chrome over the video: a caption/description block and a username at the bottom left, a vertical action rail on the right, a header and profile row at the top. A caption placed under that chrome does not exist — it is not merely hard to read, it is occluded by an opaque or near-opaque UI element.

[[sub-safe-area-and-caption-zone]] establishes the discipline of expressing position as a percentage of frame height and gives generic bands. This note is the **destination-specific map**, because the generic band is a compromise that is wrong for every platform individually:

| Destination | Aspect | Bottom band | Top band | Right rail | Notes |
|---|---|---|---|---|---|
| **Instagram Reels** | 9:16 | **~20 % (340 px of 1920)** | **~14 % (250 px of 1920)** | ~16 % of width | The only platform with a published figure; Instagram's own guidance. |
| **TikTok** | 9:16 | ~18–22 % | ~12 % | ~18 % of width | Deeper caption text block than Reels; the description can run to two or three lines. |
| **YouTube Shorts** | 9:16 | ~15–18 % | ~10 % | ~14 % of width | Shallower bottom chrome, but the title sits inside it and expands on tap. |
| **YouTube (16:9, in-player)** | 16:9 | **~12 %** | ~0 % | ~0 % | The scrubber and control bar. They auto-hide, but they reappear on any touch and cover the bottom ~12 %. |
| **YouTube (16:9, closed captions on)** | 16:9 | **~22 %** | ~0 % | ~0 % | The player's own CC track renders in the bottom band and will sit *on top of* a burned-in caption. |

Three consequences that are easy to miss:

**A single 9:16 master cannot be optimal for all three vertical platforms**, but it can be *safe* for all three: take the maximum of each band. That gives a bottom band of ~22 %, a top band of ~14 %, and a right rail of ~18 %. Design to the union and the same master ships everywhere. This costs about 4 % of vertical caption real estate versus tuning per platform, and it is almost always the right trade.

**The 16:9 YouTube case has a distinct hazard**: the platform's own closed-caption track. If the viewer has CC on, YouTube renders subtitles in the bottom ~22 %. A burned-in caption in that band gets a second caption stacked on it. This is the strongest single argument for lifting a 16:9 burned-in track higher than the broadcast convention would put it, and it is a decision that belongs in [[sub-open-vs-closed-captions]].

**Broadcast safe areas are a different, weaker constraint.** EBU R 95 gives a 5 % graphics-safe inset and a 3.5 % action-safe inset. Those protect against overscan on television, which is essentially extinct, and they are far smaller than any platform UI band. Meeting title-safe and failing the Reels bottom band is the common outcome.

## When to use it

- At identity time, as the constraint on `--cap-bottom`.
- **Whenever the destination list changes.** A video cut for YouTube and then reposted to Reels needs its caption band re-checked, and this is the single most common way a caption ends up behind a username.
- When a lower third, a list marker or a term lockup shares the frame — those objects and the caption track are competing for the same shrinking usable area ([[sub-list-marker-caption-lockup]], [[sub-term-definition-lockup]]).
- Not needed for a 16:9 deliverable that will only ever be embedded, where the only chrome is the player's own controls.

## How to recognise it in a reference video

You cannot see the chrome in a raw export, so this is measured from a **screen recording of the video actually playing on the platform**, not from the master.

1. Record playback on a real device, or use the platform's own preview.
2. Extract one frame with the chrome visible: `ffmpeg -ss <t> -i recording.mp4 -frames:v 1 ui.png`.
3. Measure from the bottom edge of the frame to the top of the highest UI element in the bottom cluster. Divide by frame height.
4. Do the same for the top cluster and for the left edge of the action rail.

| Signal | Measure | Reading |
|---|---|---|
| Caption baseline vs bottom band | Baseline as % from bottom, compared to the band | Baseline inside the band = occluded. This is a hard fail, not a warning. |
| **Box bottom edge** vs band | The plate's lower edge, not the baseline | The plate is what overlaps. Measuring the baseline under-reports by the descender plus the padding. |
| Caption right edge vs action rail | Box right edge as % of width | On a centred caption, the box's `max-width` must leave the rail clear on both sides. |
| Consistency across sections | Sample 10 cues | A caption that lifts for one section is dodging a graphic; note the dodge distance. |
| 16:9 vs 9:16 versions | Compare the same content in both cuts | Identical % from bottom in both = a percentage token. Identical px = a bug. |
| Platform CC collision | Play the 16:9 cut with the platform's CC enabled | Two caption tracks stacked = the open/closed decision was never made. |

The reference implementation's own value is instructive: `padding-bottom: 230px` on a 1080-tall composition puts the box at roughly **21 % from the bottom**. That is a *vertical-format* placement sitting in a landscape frame — safe everywhere, and noticeably high for 16:9.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `destinations` | declared list | — | Named before the caption band is set. This is an input, not an afterthought. |
| `band_bottom_reels` | 20 % of frame height | 18–22 % | 340 px of 1920. Instagram's published guidance. |
| `band_top_reels` | 14 % of frame height | 12–16 % | 250 px of 1920. |
| `band_bottom_tiktok` | 20 % | 18–22 % | Description block can run to three lines. |
| `band_bottom_shorts` | 17 % | 15–19 % | Shallower, but title expands on tap. |
| `band_bottom_yt_16x9` | 12 % | 10–14 % | Scrubber and controls; auto-hide but return on touch. |
| `band_bottom_yt_cc_on` | 22 % | 20–25 % | The platform's own CC track renders here. |
| `band_right_rail` | 18 % of frame **width** | 14–20 % | Width, not height — the only band measured against width. |
| `union_bottom` | 22 % | — | Max across the declared destinations. The safe single-master value. |
| `union_top` | 14 % | — | Max across destinations. |
| `caption_baseline_9x16` | 24 % of frame height | 22–30 % | Union bottom band plus clearance. |
| `caption_baseline_16x9` | 14 % of frame height | 12–20 % | Above the control bar; 22 %+ if platform CC is expected. |
| `clearance_above_band` | 2 % of frame height | ≥1.5 % | Between the box's bottom edge and the top of the band. |
| `measure_from` | box outer edge | box, not baseline | The plate overlaps, not the baseline. |
| `graphics_safe_inset` | 5 % | 5 % | EBU R 95. A weaker constraint than any platform band. |
| `action_safe_inset` | 3.5 % | 3.5 % | EBU R 95. |
| `layout_opt_out` | `data-layout-allow-caption-zone` | — | For an intentional lower third only. Does not suppress overflow, overlap or occlusion audits. |

## Reproduction prompt

```
Set the caption band position for {{PROJECT}}, published to {{EVERY
DESTINATION}} at {{ASPECT}}.

For each destination, state its bottom UI band, top band and right rail as
percentages of frame height (width, for the rail). Use this map as the start and
adjust only with a measurement you have actually taken:
  Instagram Reels 9:16    bottom 20%  top 14%  rail 16%w
  TikTok 9:16             bottom 20%  top 12%  rail 18%w
  YouTube Shorts 9:16     bottom 17%  top 10%  rail 14%w
  YouTube 16:9 in-player  bottom 12%  top  0%  rail  0%
  YouTube 16:9 + CC on    bottom 22%  top  0%  rail  0%

Take the UNION — the maximum of each band across the declared destinations — so
one master is safe everywhere. Set the caption baseline at least 2% of frame
height above the union bottom band.

Measure clearance from the caption BOX's outer bottom edge, not the baseline. The
plate extends below the baseline by the descender plus the padding, and that is
what the chrome overlaps.

Express every value as a percentage of frame height and emit the calc() against
composition height, never a raw px offset — a px offset is right in one aspect
ratio and wrong in the other.

If any destination is 16:9 YouTube watched with platform captions on, flag it:
the platform's own CC track renders in the bottom ~22% and will stack on yours.

Acceptance test: for every destination, overlay that platform's UI band rectangle
on a rendered frame and confirm the caption box's bounding rectangle does not
intersect it, at the widest cue in the script.
```

## Execution spec

Position is flex anchoring plus a token, exactly as the reference implementation does it — `align-items: flex-end` with a `padding-bottom`, not absolute coordinates. That is why the reference file can annotate a target y in a comment rather than setting one.

```css
[data-composition-id="captions"] {
  --cap-h: 1920;
  --unit: calc(var(--cap-h) / 100 * 1px);
  --ui-band: calc(22 * var(--unit));       /* union of declared destinations */
  --cap-clear: calc(2 * var(--unit));
  --cap-bottom: calc(var(--ui-band) + var(--cap-clear));   /* 24% */
}
[data-composition-id="captions"] .captions-container {
  display: flex;
  justify-content: center;
  align-items: flex-end;
  padding-bottom: var(--cap-bottom);
  pointer-events: none;
}
```

Stack notes:

- **`--caption-zone` / `caption_zone_collision`** is the layout audit's own check for this class of problem, and `data-layout-allow-caption-zone` is its narrow opt-out — it applies to the element and its descendants via `closest`, and it does **not** suppress overflow, overlap or occlusion audits. Use it for a deliberate lower third; never use `data-layout-allow-overflow` for this, whose blast radius also silences `text-clipping`, `content-cramped-container` and `foreground-over-panel` across the whole subtree.
- **The layout audit's caption zone is a framework constant, not the platform's band.** It will not know that Reels takes 20 % of a 1920-tall frame. The platform map is a design-time constraint you enforce; the audit is a backstop against a different problem.
- **The right rail constrains `max-width`, not position.** A centred caption at `max-width: 80%` leaves 10 % on each side, which is not enough against an 18 % rail. Either narrow `max-width` to about 62 % for a rail-bearing destination, or shift the caption's horizontal anchor left. Narrowing is safer: shifting breaks the centred read.
- **`--resolution` requires the aspect to match the composition**, so a 9:16 master and a 16:9 master are genuinely two compositions, not two renders. Share the token block between them and change `--cap-h` and `--ui-band`.
- Verify with `snapshot --at <cue midpoints>` and composite the platform band rectangle over the frames. The browser-backed audits do not run on the device VM, so this check is a static image operation and can be done anywhere.

## Pairs with

- [[sub-safe-area-and-caption-zone]] — the general discipline this note specialises
- [[sub-size-as-frame-height-percentage]] — the same percentage argument for size
- [[sub-caption-plate-geometry]] — the box edge is the thing being measured
- [[sub-open-vs-closed-captions]] — the platform-CC stacking hazard
- [[sub-caption-identity-token-set]] — where `--cap-bottom` lives
- [[sub-list-marker-caption-lockup]] — a competing object in the same shrinking area
- [[sub-term-definition-lockup]] — another one
- [[motion-overlay-stack-choreography]] — resolving the competition
- [[motion-format-promise-motion-budget]] — format-driven constraints generally

## Failure modes

- **Designing in a bare 9:16 frame with no chrome overlay.** The caption looks perfectly placed and sits under the username.
- **Measuring the baseline instead of the box.** Under-reports the overlap by the descender plus the padding — typically 3–4 % of frame height, which is exactly the margin you thought you had.
- **A px `padding-bottom`.** Correct in the format you authored, wrong in the other.
- **Reposting a YouTube cut to Reels without re-checking.** The 12 % band becomes a 20 % band and the caption is now inside it.
- **Meeting EBU title-safe and calling it done.** 5 % is a fraction of any platform band.
- **Forgetting the right rail on a centred caption.** `max-width: 80%` puts the caption's edge under the action buttons on a long cue.
- **Ignoring platform CC on 16:9.** Two caption tracks stacked, one of which you did not author.
- **Using `data-layout-allow-overflow` to silence the zone finding.** It silences three unrelated checks for every descendant and the caption is still occluded.
- **Tuning per platform and shipping the wrong master.** The union is 4 % worse and immune to this.
