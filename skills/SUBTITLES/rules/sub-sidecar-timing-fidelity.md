---
id: sub-sidecar-timing-fidelity
title: Burn-in or sidecar — what each carrier can actually express, and what each costs
skill: subtitles
type: caption-timing
family: caption-pipeline
tags: [skill/subtitles, type/caption-timing, family/caption-pipeline, engine/ffmpeg, engine/hyperframes, source/research, source/hyperframes, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "HyperFrames has no `data-caption`, no SRT/VTT ingest attribute, and no built-in subtitle renderer."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "`render` is the only thing that produces an MP4."
research_refs:
  - https://www.w3.org/TR/webvtt1/
  - https://aegisub.org/docs/latest/ass_tags/
  - https://support.google.com/youtube/answer/2734698
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: video
---

# Burn-in or sidecar — what each carrier can actually express, and what each costs

## What it is

[[sub-open-vs-closed-captions]] answers *whether* to ship both. This note answers the mechanical question underneath it: **what timing and motion can each carrier actually represent, and what does producing it cost?** The choice constrains the timing model, so it has to be made before the cue sheet is generated, not at export.

**SRT.** Millisecond timestamps, plain text, no positioning, no styling, no fades. Cues are sequential and players generally assume no overlap. It cannot express a chained word-level track in any meaningful way — 2,400 cues in an SRT is a valid file and an unusable one. Cost: free. Ubiquity: total.

**WebVTT.** Millisecond precision (`[hh:]mm:ss.mmm`, three digits of thousandths), plus cue settings for `line`, `position`, `size`, `align` and `region`, and `::cue` CSS for limited styling. **Cues are explicitly permitted to overlap** and players stack them — which is a hazard, not a feature, for a caption track. It can express per-cue positioning; it cannot express per-word timing, fades, transforms or motion. YouTube accepts it and honours positioning while limiting styling to bold/italic/underline.

**TTML/DFXP.** Full styling and positioning, accepted by YouTube with both honoured. It is the right sidecar when the track's *position* carries meaning. Still no motion, still no per-word timing in any way a player will animate.

**ASS.** The only text carrier that expresses the things this library cares about: **karaoke timing** (`\k`, `\K`/`\kf`, `\ko` in centiseconds; `\kt` in milliseconds to set the next syllable's start), **per-event fades** (`\fad(in,out)` in milliseconds), positioning (`\pos`, `\move`) and per-run colour. That makes ASS the natural intermediate representation for a burned-in track, even when the final deliverable is pixels. Cost: it is not a distribution format — platforms do not accept it as a caption file.

**Burn-in.** Pixels. Expresses anything you can render, expresses nothing to a screen reader, cannot be turned off, cannot be translated, and is baked at the resolution you rendered. In this stack the burn-in path is `hyperframes render`, which is the only thing that produces an MP4; the ffmpeg `subtitles`/`ass` filter is the alternative path for a track that was authored as ASS.

**The timing-fidelity ladder, stated once:** SRT expresses cue in/out. VTT adds position. TTML adds style. ASS adds fades and per-word karaoke. Burn-in adds motion, per-word transforms, and anything else — at the cost of being unremovable.

## When to use it

- Decide at profile time, because **the carrier constrains the timing model**: any sidecar deliverable forces phrase-level cues ([[sub-timing-model-selection]]).
- **Both** is the normal answer for a published video: burn-in for the muted feed, a sidecar for accessibility, search and translation.
- **ASS as an intermediate** whenever a burned-in track needs per-word treatment and you want the cue sheet reviewable as text before it becomes pixels.
- **Sidecar only** for long-form horizontal content on a platform with a good caption renderer.
- **Burn-in only** when the platform has no caption support at all — and log it as an accessibility debt.

## How to recognise it in a reference video

- **Burned-in vs. player captions.** Turn the platform's caption toggle off. Text that remains is burned in. Text that disappears came from a sidecar.
- **Motion is the giveaway.** Any per-word scale, colour advance, slide or bounce means burn-in — no sidecar carrier animates.
- **Resolution artefacts.** Burned-in text is re-encoded with the picture: at low bitrate the glyph edges show mosquito noise and the stroke thins. Player-rendered captions stay crisp. Compare a still of the caption against a still of on-screen graphics at the same size.
- **Position stability.** Burned-in captions sit exactly where authored. Player captions move with the platform's own layout and can land under UI chrome.
- **Two tracks at once.** A burned-in track plus an enabled sidecar produces double captions — visible, common, and worth checking in any reference that has both.
- **Timing granularity.** Sidecar cues change on the player's own schedule and can be a frame or two off the master; a burned-in change is frame-exact by construction.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `carrier` | burn-in + VTT | burn / srt / vtt / ttml / ass | Recorded once, at profile time. |
| `sidecar_timing_precision` | 1 ms | — | SRT and VTT both carry milliseconds; frames must be converted. |
| `ass_karaoke_unit` | centiseconds | — | `\k` durations; `\kt` is milliseconds. Rounding here shows as a 1-frame highlight error at 60 fps. |
| `ass_fade_unit` | milliseconds | — | `\fad(100,100)` for the standard 0.1 s caption fade. |
| `sidecar_model` | phrase | phrase | Word-level in a sidecar is unusable. |
| `sidecar_cue_count` | ≤ 12 / min | 6–20 | A rough sanity bound for a phrase track. |
| `overlap_in_vtt` | forbidden | — | Legal in the spec, stacked by players, never wanted. |
| `burn_in_path` | `hyperframes render` | — | The only MP4 producer in this stack. |
| `ffmpeg_burn_path` | `-vf "subtitles=f.ass"` | — | libass; `force_style`, `fontsdir`, `charenc`, `alpha`, `wrap_unicode`. |
| `burn_in_requires_reencode` | true | — | Every burn-in is a full re-encode; budget the time and the quality loss. |
| `double_caption_check` | required | — | Verify the burned-in track and the sidecar are not both visible. |
| `translation_ready` | sidecar only | — | Burned-in text cannot be translated without re-rendering. |

## Reproduction prompt

```
Produce the caption deliverables for {{PROJECT}} and verify each carrier can
express what the design requires.

1. READ the design's timing model and motion spec. Per-word highlighting,
   per-word transforms and any motion CANNOT be carried by SRT, VTT or TTML -
   they exist only in the burn-in. Write that into the handoff so nobody
   expects parity.
2. BURN-IN: author the cue array in the composition and render with
   hyperframes render --fps {{FPS}}; this is the only MP4 producer. If the
   track was authored as ASS, burn with
   ffmpeg -i {{IN}} -vf "subtitles={{CUES}}.ass:fontsdir={{FONTS}}"
   -c:a copy {{OUT}}.mp4 - a full video re-encode.
3. SIDECAR: emit the PHRASE-level cue sheet, never the word-level one, as
   WebVTT with millisecond timestamps and cue settings for line, position and
   align only. Guarantee no two cues overlap even though the spec allows it.
   Add SRT if the platform needs it, accepting no positioning.
4. VERIFY: play the render with the sidecar enabled and confirm they do not
   both display, and that their cue in-times agree within {{TOL}} = 2 frames
   at the same three sample points used for offset checking.

ACCEPTANCE TEST: the sidecar holds only phrase cues, none overlapping, none
over {{CPS}} = 17 characters per second; burn-in and sidecar agree within 2
frames at start, middle and end; the handoff lists which features exist only
in the burn-in; and enabling the sidecar does not double-caption.
```

## Execution spec

**HyperFrames side.** There is no caption primitive, no SRT/VTT ingest attribute and no subtitle renderer — the burn-in is simply a composition that draws text, and `render` bakes it. `render` flags carry the fps (`--fps 24|30|60`, default 30), and the render fps overrides the root's `data-fps` hint, so a cue sheet authored in seconds survives an fps change while any frame-count annotation does not.

**ffmpeg side**, verified locally in this container:

```
Filter subtitles — Render text subtitles onto input video using the libass library.
  filename / f, original_size, fontsdir, alpha, charenc, stream_index / si,
  force_style, wrap_unicode
Filter ass — same, plus: shaping (auto | simple | complex)
```

Notes that matter in practice: `subtitles` handles SRT/VTT/ASS and rasterises through libass; `ass` takes ASS only and exposes `shaping`, which is the option to reach for with complex scripts. `force_style` can override `FontName`, `FontSize`, `Outline`, `Shadow` and colours at encode time, which makes an ASS intermediate re-styleable without regenerating the cue sheet. `original_size` is required when the subtitle file was authored against a different resolution than the video being filtered, otherwise the type scales wrongly. Any burn-in is a **full re-encode** — there is no `-c copy` path — so it costs render time and a generation of quality.

**The cost table, plainly.** Burn-in costs: render time, a re-encode generation, no translation, no user control, and a per-aspect re-render. Sidecar costs: no motion, no per-word timing, platform-dependent styling, and a real risk of the player putting the caption under its own UI. That last one is why a sidecar-only short-form deliverable is usually wrong, and why the caption zone rules in [[sub-platform-ui-overlap-map]] apply to the burn-in even when a sidecar also exists.

## Pairs with
[[sub-open-vs-closed-captions]] · [[sub-timing-model-selection]] · [[sub-phrase-cue-assembly]] · [[sub-batch-generation-and-qc]] · [[sub-platform-ui-overlap-map]] · [[sub-safe-area-and-caption-zone]] · [[sub-inter-cue-gap-and-chaining]] · [[sub-latency-and-offset-correction]]

## Failure modes
- **Exporting the word-level sheet as the sidecar.** Thousands of sub-second cues; most players stutter and some reject the file. Correction: generate a separate phrase sheet.
- **Assuming feature parity between burn-in and sidecar.** The per-word highlight simply does not exist in VTT, and someone will ask why. Correction: state it in the handoff.
- **Overlapping VTT cues.** Legal in the spec, stacked by players, moves the caption baseline. Correction: forbid overlap in the emitter.
- **Double captions.** Burned-in track plus an enabled sidecar. Correction: verify with the toggle on.
- **Burning in at the wrong `original_size`.** Type scales wrongly and the size percentage no longer holds. Correction: pass `original_size` when the ASS was authored at another resolution.
- **Forgetting the re-encode cost.** A burn-in pass on a long master is not free and it costs a quality generation. Correction: burn once, from the graded master, at final resolution.
- **Shipping a burn-in as the accessibility deliverable.** It is not one — no screen reader, no user control, no translation. Correction: ship both.
- **Rounding karaoke timings into centiseconds without checking.** At 60 fps a centisecond is over half a frame; accumulated rounding shows as a visibly early or late highlight. Correction: round once, against the frame grid, and re-check.
