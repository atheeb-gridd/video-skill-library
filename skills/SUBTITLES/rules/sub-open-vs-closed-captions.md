---
id: sub-open-vs-closed-captions
title: Burn in for the feed, ship a caption file for accessibility — the answer is usually both
skill: subtitles
type: caption-style
family: accessibility
tags: [skill/subtitles, type/caption-style, family/accessibility, engine/hyperframes, source/research, source/hyperframes, difficulty/medium]
source:
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "Caption authoring pipelines live outside core: the /embedded-captions workflow (footage + captions, footage untouched), media-use → audio/references/captions/ (not staged), and npx hyperframes transcribe."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "There is no data-caption, no SRT/VTT ingest attribute, and no built-in subtitle renderer."
research_refs:
  - https://en.wikipedia.org/wiki/Closed_captioning
  - https://www.w3.org/WAI/media/av/captions/
  - https://www.w3.org/TR/WCAG22/
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
difficulty: medium
detectable_from: video
---

# Burn in for the feed, ship a caption file for accessibility — the answer is usually both

## What it is

**Open captions** are rendered into the pixels: everyone sees them, nobody can turn them off, and the creator controls every aspect of how they look. **Closed captions** are a separate timed-text track the player renders on demand: the viewer can toggle them, restyle them, and — critically — the platform, not the creator, decides how they look.

These are not competing options, they are different jobs, and the decision is usually not either/or:

| | Open (burned in) | Closed (VTT/SRT track) |
|---|---|---|
| Visible by default | Yes | No — viewer must enable |
| Creator controls appearance | Completely | Not at all |
| Survives re-upload / download / repost | Yes | No — the track is usually lost |
| Selectable, searchable, indexable text | No | Yes |
| Screen-reader / braille accessible | No | Yes |
| Viewer can resize or restyle | No | Yes — this is an accessibility feature |
| Translatable | No | Yes |
| Occludes the picture | Always | Only when enabled |
| Can be the accessible alternative for audio | Only in a limited sense | Yes |

The decisive point is the **restyle** row. Closed captions exist as an accessibility mechanism partly *because* the viewer can change them — CEA-708 introduced viewer-adjustable text size and colour precisely to replace the fixed presentation of earlier systems. A low-vision viewer who needs 200 % caption size can get it from a closed track and cannot get it from burned-in pixels. Burned-in captions are therefore not a complete accessibility answer no matter how well designed, and claiming otherwise is the common mistake.

Equally decisive in the other direction: the audience for captions is overwhelmingly **not** deaf. In the UK, of roughly **7.5 million people using TV subtitles, about 6 million have no hearing impairment**. In feed-based short-form, the majority of views begin muted. That audience will never enable a closed track — they need the words in the pixels or they get nothing.

Hence: **burn in for the feed, ship a file for accessibility, and design the burned-in track so the two do not collide.** That collision is real and specific: on 16:9 YouTube the platform renders its own CC track in the bottom ~22 % of frame, so a burned-in caption in that band gets a second caption stacked on top of it ([[sub-platform-ui-overlap-map]]).

There is also a terminological point worth holding, because it changes what the file must contain. In North American usage, **subtitles** transcribe dialogue for a viewer who can hear; **captions** describe *all* significant audio — speaker identity, sound effects, music — for a viewer who cannot. A WCAG 1.2.2 obligation is for captions, not subtitles, and that pulls in [[sub-speaker-and-non-speech-annotation]].

## When to use it

Decide at project start, because it changes the burned-in design:

- **Burned-in only** — a feed-native short with no accessibility obligation and no platform that accepts a sidecar track. Common and defensible; say so explicitly rather than by omission.
- **Closed only** — a long-form landscape piece where burned-in captions would occlude the content and the audience watches with sound.
- **Both** — the default for anything shipping to YouTube. The burned-in track serves the muted feed and the sidecar serves accessibility, search and translation.

When shipping both, two design consequences follow immediately:

1. **Lift the burned-in track out of the platform's CC band** — above ~22 % of frame height on 16:9.
2. **The two tracks may legitimately differ.** The burned-in track can be an emphasis layer of a few words; the closed track must be complete, with speaker IDs and non-speech annotation. They are not required to be the same text, and pretending they are usually degrades both.

## How to recognise it in a reference video

| Signal | Method | Reading |
|---|---|---|
| Captions present with player CC off | Play with CC disabled | Visible = open/burned in |
| Text selectable or searchable | Try the platform's transcript view | Present = a closed track exists |
| Restyling has an effect | Change caption size in player settings | Burned-in text does not change; closed does |
| Two caption tracks visible | Enable platform CC on a burned-in video | Stacked captions = the collision was not designed for |
| Style consistency with the platform default | Compare to the platform's own CC rendering | Platform-default look = closed; bespoke = open |
| Non-speech annotation | Look for `[MUSIC]`, `[LAUGHS]` | Common in closed tracks, rare in burned-in emphasis layers |
| Speaker IDs | Look for `- ` prefixes or name tags | Same |
| Position stability | Does the caption ever move to avoid on-screen text? | Closed tracks reposition automatically; burned-in ones only if authored to |

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `delivery` | both | open / closed / both | Declared at project start; it changes the burned-in design. |
| `open_track_role` | emphasis or full, per profile | — | See [[sub-caption-role-decision]]. |
| `closed_track_completeness` | 100 % of speech | 100 % | A closed track is the accessible alternative; partial is not an alternative. |
| `closed_track_includes` | speaker IDs + non-speech audio | — | This is what makes it a *caption* rather than a *subtitle*. |
| `closed_format` | WebVTT | WebVTT / SRT / TTML | W3C WAI recommends WebVTT for web media; SRT and TTML are also accepted. |
| `burned_in_band_when_both` | ≥24 % from bottom on 16:9 | ≥22 % | Clears the platform's own CC band. |
| `tracks_must_match` | no | no | The burned-in emphasis layer and the closed track are different objects. |
| `closed_track_reading_rate` | ≤17 CPS | 15–20 | The closed track serves readers who may need more time; use the conservative cap. |
| `closed_track_lines` | ≤2 | 1–2 | Player-rendered; more will overflow small players. |
| `translatable` | closed only | — | Burned-in pixels cannot be translated without a re-render. |
| `survives_repost` | open only | — | Sidecar tracks are lost on download-and-repost. |
| `wcag_1_2_2` | Level A | — | Captions for prerecorded synchronised media. |
| `open_alone_satisfies_wcag` | no | — | Burned-in text cannot be resized or restyled by the viewer. |
| `hearing_audience_share` | ~80 % of caption users | — | ~6 of 7.5 M UK subtitle users have no hearing impairment. |
| `authoring_route` | `/embedded-captions`, `transcribe` | — | Caption authoring pipelines live outside HyperFrames core. |

## Reproduction prompt

```
Decide and specify the caption delivery for {{PROJECT}}, shipping to
{{DESTINATIONS}}, with {{no|WCAG-A}} accessibility obligation, watched
{{muted-first|sound-on}}.

Choose burned-in only, closed only, or both. Default to BOTH for any platform
accepting a sidecar track, and state the reason explicitly rather than leaving it
implied.

If burned-in only: state plainly that this alone does not satisfy a WCAG 1.2.2
obligation, because burned-in pixels cannot be resized, restyled or read by a
screen reader. That may be acceptable for a feed-native short — but make it a
call, not an oversight.

If both, specify two DIFFERENT artefacts and do not force them to match: the
burned-in track per this project's caption identity, which may legally be a
partial emphasis layer; and the closed track, which must be COMPLETE — 100% of
speech plus speaker identification and non-speech annotation. That completeness
is what makes it a caption rather than a subtitle.

If both and any destination is 16:9 YouTube, lift the burned-in band to at least
24% of frame height. The platform renders its own CC track in the bottom ~22% and
a burned-in caption there gets a second caption stacked on it.

Emit the closed track as WebVTT, capped at 2 lines and 17 CPS.

Acceptance test: play with platform captions ON — the two tracks must not overlap
at any timestamp. Play muted with them OFF — the burned-in track alone must carry
what the muted viewer needs. Confirm the VTT covers every second of speech with
speaker identification wherever more than one person speaks.
```

## Execution spec

HyperFrames renders the **open** track. It has no closed-caption surface at all: no `data-caption`, no SRT/VTT ingest attribute, no subtitle renderer. The burned-in track is an ordinary composition whose timeline writes `textContent`.

The closed track is produced alongside, from the same word-level transcript:

```bash
# one transcript, two outputs
npx hyperframes transcribe <video> --out transcript.json
# -> inlined as the `script` array in captions.html   (open track)
# -> grouped and serialised to WebVTT                  (closed track)
```

```
WEBVTT

00:00:12.340 --> 00:00:14.020
-Rohit: parr naam kya search karu??

00:00:14.100 --> 00:00:15.600
[keyboard clatter]
```

Stack notes:

- **Caption authoring pipelines live outside HyperFrames core.** The relevant surfaces are the `/embedded-captions` workflow (footage plus captions, footage untouched), `media-use` → `audio/references/captions/` (**not staged** in this project), and `npx hyperframes transcribe`. Do not write a spec that assumes core will emit a VTT.
- **One transcript, two derivations.** Both tracks come from the same word-level array, so a correction propagates to both. Deriving them independently guarantees they drift.
- **The closed track is not styled by you.** Do not specify colours or positions for it; the player owns that, and viewer restyling is the point. What you control is grouping, line count, reading rate and content.
- **The render is not the deliverable here.** The composition HTML plus assets is the deliverable and the MP4 is a downstream step with its own host — the browser-dependent render cannot run on this project's device VM. The VTT ships beside the MP4, not inside it.
- **The vault cannot delete files**, so caption-track versions accumulate as superseding files with an updated index rather than as overwrites.

## Pairs with

- [[sub-caption-role-decision]] — the role decision this delivery decision depends on
- [[sub-speaker-and-non-speech-annotation]] — what makes a closed track a caption
- [[sub-platform-ui-overlap-map]] — the platform CC band the burned-in track must clear
- [[sub-caption-contrast-accessibility]] — the other half of caption accessibility
- [[sub-cue-segmentation-three-word]] — the open track's timing model
- [[sub-hinglish-reading-rate]] — the closed track's rate cap
- [[sub-caption-identity-token-set]] — applies to the open track only
- [[sub-orthography-protection-no-autocorrect]] — both tracks derive from one protected transcript

## Failure modes

- **Claiming burned-in captions satisfy an accessibility obligation.** They cannot be resized, restyled or read by a screen reader. This is the most common wrong answer.
- **Not shipping a closed track because the video already has burned-in captions.** Loses search, translation, indexing and every viewer who needs a different size.
- **Burned-in captions in the platform's own CC band.** Two caption tracks stacked, one of which you did not author and cannot move.
- **Forcing the two tracks to be identical.** Either the burned-in track inflates into a full transcript, or the closed track is truncated into an emphasis layer. Both are worse.
- **A closed track that is only dialogue.** That is a subtitle track. A caption track carries speaker identity and non-speech audio.
- **Deriving the two tracks separately.** They drift, and the drift is invisible until someone reads both.
- **Styling the closed track.** You do not own it, and overriding viewer restyling defeats the accessibility mechanism it exists for.
- **Assuming the sidecar survives.** Downloaded, reposted or embedded elsewhere, the track is gone and only the burned-in pixels remain.
