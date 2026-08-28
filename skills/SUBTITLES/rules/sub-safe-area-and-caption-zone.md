---
id: sub-safe-area-and-caption-zone
title: Place captions by frame-height percentage inside the platform's safe band
skill: subtitles
type: caption-style
family: safe-area
tags: [skill/subtitles, type/caption-style, family/safe-area, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:18"
    quote: "So in this video, we're gonna dive into 10 important editing cuts every filmmaker should know."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:02"
    quote: "Using captions to fill more space can get ugly fast and waste a great opportunity to put something more engaging on screen."
research_refs:
  - https://tech.ebu.ch/docs/r/r095.pdf
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://sproutsocial.com/insights/social-media-video-specs-guide/
  - https://www.w3.org/WAI/WCAG22/Understanding/captions-prerecorded.html
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: video
---

# Place captions by frame-height percentage inside the platform's safe band

## What it is
Caption position is three constraints stacked, and they are not the same constraint. **Broadcast safe area** is a manufacturing tolerance: EBU R 95 puts the graphics safe area at a 5 % inset and the action safe area at 3.5 %, which at 1920×1080 are the pixel boxes 96…1823 × 54…1026 and 67…1852 × 38…1042. **Platform UI** is an occlusion: the host app draws its own chrome over the video, and a caption behind it does not exist — Instagram's own guidance is to keep the top ~250 px and the bottom ~340 px of a 1080×1920 creative free of text, i.e. 13 % and 18 % of frame height. **Composition collision** is an internal problem: lower thirds, item markers, logos and the emphasis layer all want the same band.

The resolution is to author every caption offset as a **percentage of frame height**, never in points and never in absolute pixels, and to resolve those percentages to px per output size at build time. A caption designed at 1920×1080 and dropped into 1080×1920 without re-resolving is the single most common positioning defect, because the same pixel offset is a different fraction of the frame.

## When to use it
Every caption design, always, as the first geometry decision — before type size, before motion. Specifically:

- Whenever the same edit ships in more than one aspect. Resolve the zone per aspect; do not scale a landscape design.
- Whenever the deliverable goes in-feed on TikTok, Reels or Shorts. The bottom band is occupied by the caption/handle/CTA stack and the right edge by the action rail.
- Whenever a lower third, a numbered item marker or a persistent counter is on screen at the same time as a caption — see [[sub-list-marker-caption-lockup]].
- Whenever `hyperframes check` reports `caption_zone_collision`. That finding is the framework telling you this note was skipped.
- Not needed for a full-screen kinetic title card that deliberately occupies the whole frame ([[sub-single-word-topic-card]]) — that is a different object with its own centring.

## How to recognise it in a reference video
- **Measure the caption baseline as a percentage from the bottom of the frame**, not in pixels. Take the bottom of the lowest glyph (not the plate). Typical bands: **8–12 %** for a 16:9 sound-on edit, **16–24 %** for a vertical in-feed edit, **28–40 %** for an emphasis layer sitting above a track.
- **Measure the left/right extents.** A caption whose box exceeds ~80 % of frame width is running to the edges; the reference `captions.html` caps its box at `max-width: 80%`. Check the margin as a percentage — under 5 % it is outside the EBU graphics safe area.
- **Overlay the platform chrome.** Composite the app's UI over the frame at the reference's target platform. If any glyph falls under the handle/caption stack or under the action rail, the reference was cut for a different surface.
- **Watch for a position shift.** A caption that moves up for part of the video is dodging something — a lower third, burned-in platform text, a graph. Log the trigger, not just the two positions.
- **Check consistency across the video.** A well-designed track never varies its baseline except at a logged dodge. A track whose baseline drifts by 1–2 % between cues was positioned by eye per cue.
- **Check the same edit's other aspect if you can find it.** If the vertical cut has captions at the same *pixel* offset as the landscape cut, the design was not re-resolved.
- **Look for a plate.** On unpredictable footage a plate or scrim is the tell that the designer solved contrast structurally rather than with a stroke.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `caption_baseline_16x9` | 11 % of frame height | 8–14 % | 119 px up from the bottom at 1080p. The reference file's `padding-bottom: 230px` on a 1080-tall frame puts its box near 21 %, which is a vertical-style placement in a landscape frame. |
| `caption_baseline_9x16` | 20 % of frame height | 16–26 % | 384 px up from the bottom at 1920 tall — clear of Instagram's ~340 px bottom band. |
| `platform_bottom_band` | 18 % | 14–22 % | Instagram guidance: ~340 px of 1920. Treat TikTok and Shorts the same unless measured otherwise. |
| `platform_top_band` | 13 % | 10–16 % | ~250 px of 1920 for the profile/header row. |
| `platform_right_band` | 16 % of frame width | 12–20 % | The vertical action rail. Keep centred captions narrower than the remaining width. |
| `graphics_safe_inset` | 5 % | 5 % | EBU R 95. At 1080p: x 96…1823, y 54…1026. |
| `action_safe_inset` | 3.5 % | 3.5 % | EBU R 95. At 1080p: x 67…1852, y 38…1042. |
| `box_max_width` | 80 % of frame width | 70–86 % | Matches the reference file's `max-width: 80%`. |
| `text_max_width` | 84 % of box | 70–90 % | The reference caps `.caption-text` at 1600 px inside a 1920 frame. |
| `zone_separation` | 6 % of frame height | ≥4 % | Between any two simultaneously visible text objects. |
| `dodge_offset` | +10 % of frame height | 6–16 % | How far the track lifts when a lower third occupies its band. |
| `dodge_ramp` | 0.3 s | 0.25–0.5 s | `power2.out`. Move on a cue boundary, never mid-cue. |
| `type_size_full_screen` | 4.5 % of frame height | 3.5–6 % | Video type floors: body ≥20 px, headlines 60 px+, data labels 16 px. |
| `type_size_in_feed` | 5.5 % of frame height | 4.5–8 % | In-feed floors are higher: body ≥32 px, headlines ≥90 px, labels ≥24 px. |

## Reproduction prompt

```
Position the caption objects for this composition. Author every offset as a
percentage of frame height and resolve to pixels per output size.

1. READ THE FRAME. Take data-width and data-height from the composition root.
   H = data-height. All offsets below are fractions of H.
2. RESERVE THE PLATFORM BANDS. For a 9:16 in-feed deliverable, mark the top
   0.13H and the bottom 0.18H as forbidden, plus the right 0.16 of frame width.
   For 16:9, mark only the EBU graphics safe inset of 5% on every edge.
3. PLACE THE TRACK. Baseline of the lowest glyph at 0.20H from the bottom for
   9:16, 0.11H for 16:9. Box max-width 80% of frame width, centred. Verify the
   box's own bottom edge still clears the forbidden band by >= 0.02H.
4. PLACE THE EMPHASIS LAYER, if one exists, at 0.28H from the bottom, and
   confirm >= 0.04H of clear air between its box and the track's box at every
   timestamp where both are visible.
5. DODGE. For every interval where a lower third, item marker or graphic
   occupies the caption band, lift the track by 0.10H. Start the move on a cue
   boundary, 0.30s, ease power2.out, and return the same way.
6. SIZE THE TYPE. 0.045H for full-screen delivery, 0.055H for in-feed, never
   below 32px absolute for in-feed body text. Tracking -0.03em.

ACCEPTANCE TEST: snapshot at 8 timestamps spread across the video. In every
one, no glyph falls inside a reserved band, no two text objects are closer
than 0.04H, and every glyph is inside the 5% graphics safe inset. Then
re-render the same composition at the other aspect and repeat - the
percentages must still hold without any pixel value being edited.
```

## Execution spec

**HyperFrames.** Positioning is CSS, and the reference implementation anchors by flex rather than absolute coordinates — `.captions-container` is `display: flex; justify-content: center; align-items: flex-end` with `padding-bottom: 230px`, which is why the file can annotate its target y in a comment. Keep that shape but express the offset as a fraction of the root height:

```html
<template id="captions-template">
  <div data-composition-id="captions-track" data-width="1080" data-height="1920"
       data-duration="{{DURATION}}" style="--fh: 1920px;">
    <div class="captions-container"><div class="caption-box">…</div></div>
  </div>
  <style>
    [data-composition-id="captions-track"] .captions-container{
      position:absolute; inset:0; display:flex;
      justify-content:center; align-items:flex-end;
      padding-bottom: calc(0.20 * var(--fh));   /* 384px at 1920 */
      pointer-events:none;
    }
    [data-composition-id="captions-track"] .caption-box{
      max-width:80%; padding:12px 32px; border-radius:24px;
    }
    [data-composition-id="captions-track"] .caption-text{
      font-size: calc(0.045 * var(--fh)); font-weight:700;
      letter-spacing:-0.03em; line-height:1.2; text-align:center;
    }
  </style>
</template>
```

Contract points:
- **Scope every rule to `[data-composition-id="…"]` inside the `<template>`.** The assembler drops a sub-comp file's own `<head>` `<style>`/`<script>`; only `<link>` is hoisted.
- **The root needs an explicit sized box in px** and every ancestor down to a `height:100%` element needs a resolved height, or a flex child collapses to ~0 and everything piles into the top-left. This is a silent bug — inspect a snapshot, do not trust the gates.
- **Untimed full-bleed children need their own `position:absolute; inset:0`.** Root-level automatic layout only applies to elements carrying `data-start`.
- **Layout audits:** the `--caption-zone` check raises `caption_zone_collision`. Opt out with `data-layout-allow-caption-zone` on the intentional lower-third element only — it covers descendants via `closest` and does **not** suppress overflow, overlap or occlusion findings. Do **not** reach for `data-layout-allow-overflow`; its blast radius covers the whole subtree and also silences `text-clipping` and `content-cramped-container`.
- **A lint error switches off the layout and contrast audits entirely** — `check` then reports `0 sample(s)` and `0/0 text checks`, which looks clean and means nothing ran. Fix lint errors before trusting any positioning result.
- **The dodge is a tween on the container**, `y` only (`top`/`left`/`width`/`height` tweens are forbidden), on the seekable timeline, landing before the clip's `data-duration` because the visibility window is half-open.
- **Verify with `snapshot`**, which is required for projects with sub-compositions and is the only real defence against the silent root-sizing bug. On this linux ARM64 host the browser-backed steps — `snapshot`, `preview`, the layout/contrast audits, `render` — must run on another machine; author here, verify there.
- **Per-aspect delivery:** give each aspect its own root `index.html` with its own `data-width`/`data-height`, hosting the same caption sub-comp and passing the offsets via `data-variable-values`. Root `data-duration` is compile-time-locked and cannot be varied by `--variables`.
- `--resolution` on `render` supersamples via Chrome's `deviceScaleFactor`; the aspect must match the composition and the scale must be an integer. It is not a reframe.

**ffmpeg.** For a baked track, vertical placement is `MarginV` in ASS units: `-vf "subtitles=track.srt:force_style='MarginV=384,Alignment=2'"` (Alignment 2 = bottom-centre). Reframing a landscape master to vertical is a crop, not a caption operation, and must happen before captions are burned: `crop=ih*9/16:ih` then re-derive the offsets against the new height.

**Epidemic Sound.** Not applicable.

**Remotion.** Same idea with `useVideoConfig()` supplying width/height and every offset written as a fraction of `height`.

## Pairs with
[[sub-caption-role-decision]] · [[sub-list-marker-caption-lockup]] · [[sub-cue-segmentation-three-word]] · [[sub-karaoke-active-word-highlight]] · [[sub-single-word-topic-card]] · [[motion-overlay-stack-choreography]] · [[motion-closing-thesis-title-card]]

## Failure modes
- **Pixel offsets carried between aspects.** A 230 px bottom pad is 21 % of a 1080-tall frame and 12 % of a 1920-tall one. Correction: fractions of frame height, resolved at build.
- **Caption under the platform UI.** It renders, it passes every check, and no viewer ever reads it. Correction: reserve the top 13 % and bottom 18 % on vertical deliverables before placing anything.
- **Points or "font size 48" as the spec.** Meaningless across resolutions. Correction: percentage of frame height with an absolute in-feed floor of 32 px for body text.
- **Suppressing `caption_zone_collision` instead of fixing it.** Especially with `data-layout-allow-overflow`, which also hides real clipping. Correction: move the object, or use the narrow caption-zone opt-out on the lower third only.
- **Dodging mid-cue.** The line jumps while it is being read. Correction: move only on a cue boundary, 0.3 s `power2.out`.
- **Box wider than 80 % of frame.** Reads as edge-to-edge and collides with the action rail on vertical. Correction: cap the box and let the segmentation shorten the line.
- **Trusting `check` after a lint error.** The audits silently did not run. Correction: clear lint errors first, then read the layout findings.
- **Known gap.** The stack has no automatic content-aware reframe and no face tracking — pan and Ken Burns are authored geometry. A caption cannot be auto-placed away from a face; the dodge intervals have to be logged by the analysis pass.
