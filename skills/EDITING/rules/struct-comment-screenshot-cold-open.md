---
id: struct-comment-screenshot-cold-open
title: Open on the comment that asked for the video
skill: editing
type: structure
family: hook
tags: [skill/editing, type/structure, family/hook, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "visual — contact sheet, opening frames"
    quote: "[NOT SPOKEN — observed on screen] The video cold-opens on a YouTube comment screenshot: the request that motivated the video."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:07"
    quote: "YouTubers and editors struggle to find the perfect music."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:14"
    quote: "In this video I'm going to give you 10 points that nobody will tell you even in a paid course."
research_refs:
  - https://en.wikipedia.org/wiki/Social_proof
  - https://en.wikipedia.org/wiki/Reciprocity_(social_psychology)
  - https://prepublish.ai/guides/youtube-retention-guide
  - https://legibility.info/rules-for-text-in-videos
  - _meta/visual-kt-delta.md
difficulty: low
detectable_from: video
---

# Open on the comment that asked for the video

## What it is
`editing kt 3` does not open on the presenter, on a hook line, or on a result. It opens on a **screenshot of a YouTube comment** — the request that motivated the video — held on screen while the narration begins. The device is small and does four things at once, which is why it is worth codifying rather than treating as a flourish:

1. **It states the demand instead of asserting it.** *"A lot of people struggle with music"* is a claim; a real comment from a real viewer is evidence. This is the demand hook with its evidence attached ([[struct-demand-hook-competence-gap]]).
2. **It transfers the question to the viewer.** The comment is written in the audience's own words, so a viewer with the same problem recognises themselves in it faster than in any line the creator could write.
3. **It pays a debt in public.** Answering a request on camera is visible reciprocity, and it is the strongest possible argument for leaving a comment on *this* video — which is the mechanism [[struct-comment-prompt-curiosity-gap]] exploits at the other end of the runtime. The two devices are a loop: comments produce videos, videos produce comments.
4. **It is cheap and specific.** One screenshot, 2–4 seconds, no script, no shoot.

The failure case is worth stating up front because it is common: **a comment cold open is not a hook.** It supplies the *reason the video exists*, not the reason to keep watching. It has to be followed within a few seconds by the promise — the countable payload, the outcome, the competence gap — or the video has opened on someone else's question and left it unanswered ([[struct-enumerated-promise-and-counter]], [[struct-outcome-first-cold-open]]).

## When to use it
- **When a real request exists.** The device is worthless faked, and audiences are good at spotting a fabricated comment.
- **On a video whose whole premise is answering one question** — a follow-up, a "you asked for this", a part 2.
- **When the topic sounds too basic to deserve a video.** A visible request pre-empts *"why are you covering this?"* better than any justification.
- **In series formats**, where the loop between comments and videos is the format's engine.
- **Stacked with a credibility beat.** Comment → promise → credibility is a strong 20 seconds ([[struct-credibility-anchor]]).
- **Not on a cold-audience video.** New viewers have no relationship with your comment section; open on the outcome instead.
- **Not for more than one comment.** Two screenshots is a montage of other people talking while the viewer waits.
- **Not as the answer to the hook.** It is the setup; the payload still has to arrive.

## How to recognise it in a reference video
- **A UI screenshot in the first 0–5 seconds**, before the presenter appears, usually held static or with a slow push-in.
- **The comment is legible** — cropped to the comment itself, scaled up, often with the avatar and name visible for authenticity.
- **The narration paraphrases it** rather than reading it aloud word for word, so the screenshot and the voice are not redundant.
- **It leaves the frame quickly**, typically within 2–4 s, and the promise follows immediately.
- **Check the first 30 seconds for the promise.** If the video moves from the comment straight into teaching with no stated payload, this is a cold open without a hook — log it as a defect, not a pattern.
- **Look for the matching close.** A creator running the loop deliberately will also ask for the next request near the end.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `position` | frame 0 | 0–2 s in | Before the presenter, before any title. |
| `dwell` | 3.0 s | 2.0–4.5 s | Long enough to read a short comment: characters ÷ 13 s, floor 2 s. |
| `comment_length` | ≤90 characters | ≤120 | Longer comments must be cropped or they cannot be read in the time available. |
| `crop` | comment + avatar + name | — | Crop out the rest of the UI; a full-page screenshot is unreadable at 1080p. |
| `scale` | 1.6× to fill 70–85% of frame width | 1.3–2.0× | Text must clear ~34 px effective height. |
| `motion` | slow push-in, 1.02 → 1.06 over the dwell | ≤1.08 | Enough to stop it reading as a freeze ([[motion-still-image-drift]]). |
| `highlight` | 1 underline or circle on the key phrase | 0–1 | Optional; drawn on, not a static overlay ([[motion-annotation-draw-on]]). |
| `time_to_promise` | ≤8 s from frame 0 | ≤12 s | The hard constraint. After this the opening is costing retention. |
| `redaction` | avatar blurred if the account is small | — | Courtesy, and it avoids sending an audience at a private individual. |
| `sound` | bed starts under the comment | — | The first cue starts here, not at the presenter's first word ([[sfx-j-cut-hook-sound]]). |

## Reproduction prompt

```
Open {{VIDEO}} on the comment that motivated it.

1. FIND A REAL COMMENT. Screenshot it with the avatar and username visible.
   If no real request exists, do NOT fabricate one - use an outcome-first
   cold open instead.
2. CROP to the comment itself plus the avatar and name. Scale so the comment
   text is at least 34 px tall at 1080p and fills 70-85% of frame width.
   Redact the avatar if the account looks like a private individual.
3. HOLD for max(2.0 s, characters / 13). Apply a 1.02 -> 1.06 push-in over
   the hold so the still is not a freeze.
4. NARRATE THE PROBLEM, do not read the comment aloud. The screenshot says
   who asked; the voice says why it matters.
5. CUT TO THE PROMISE WITHIN 8 SECONDS of frame 0: the countable payload,
   the outcome, or the competence gap. This is not optional - the comment is
   the setup, not the hook.
6. CLOSE THE LOOP at the end of the video by asking for the next request, so
   the device has a supply of material.

ACCEPTANCE TEST: watch the first 15 seconds with fresh eyes. You should be
able to say (a) whose question this is, (b) what you are going to get, and
(c) why it is worth the runtime. If (b) is missing, the open is decoration.
```

## Execution spec

**HyperFrames.** A still with a slow push-in, plus the bed starting under it:

```html
<div class="clip" id="cold-comment" data-start="0.00" data-duration="3.00" data-track-index="1">
  <img id="cc-shot" src="assets/img/comment.png" alt="">
</div>
<audio id="bed-open" src="assets/audio/bgm/open.wav" data-audio-group="music"
       data-start="0.00" data-duration="24.00" data-media-start="6.40"
       data-track-index="11" data-volume="0.079"></audio>
```
```js
tl.fromTo("#cc-shot", { scale: 1.02, autoAlpha: 0 },
  { scale: 1.06, autoAlpha: 1, duration: 3.0, ease: "none" }, 0.0);
```
`data-media-start` on the bed skips the track's warm-up so the video opens on the main beat rather than on a pad ([[sfx-music-ten-point-framework]]). **`fromTo`, never `from`** — a `from()` at composition time 0 is exactly where the flash-on-seek bug shows up. Transform aliases only (`scale`), never `width`/`top`. `autoAlpha`, never on the clip element itself. Every `<audio>` needs an `id` or the render is silent.

**ffmpeg — preparing the screenshot.** Crop and upscale with a sharp scaler so small UI text survives:
```bash
ffmpeg -i comment_raw.png -vf "crop=980:220:60:340,scale=1512:-1:flags=lanczos" assets/img/comment.png
# blur an avatar in place if needed
ffmpeg -i assets/img/comment.png -vf "boxblur=12:2:enable='between(X,20,110)'" assets/img/comment_redacted.png
```

**Sound.** Give the cold open its own cue rather than starting the bed at the presenter's first word — the audio arriving before the picture settles is the J-cut hook, and it is what stops a static screenshot feeling like dead air.

## Pairs with
[[struct-comment-prompt-curiosity-gap]] · [[struct-demand-hook-competence-gap]] · [[struct-outcome-first-cold-open]] · [[struct-enumerated-promise-and-counter]] · [[struct-credibility-anchor]] · [[struct-analytics-screenshot-proof]] · [[motion-still-image-drift]] · [[motion-annotation-draw-on]] · [[sfx-j-cut-hook-sound]] · [[struct-cta-after-payoff]]

## Failure modes
- **Treating the comment as the hook.** It explains why the video exists; it does not promise the viewer anything. Get to the promise inside 8 seconds.
- **An unreadable screenshot.** Full-page captures at 1080p are illegible; crop and scale.
- **Reading the comment aloud.** The screen and the voice say the same thing for four seconds and neither adds anything.
- **Fabricating the comment.** Audiences check. The credibility loss is far larger than the device's gain.
- **Two or more comments.** A montage of other people's questions while the viewer waits for the video to start.
- **Holding it too long.** Past ~4.5 s a static screenshot is dead air even with a push-in.
- **Exposing a private individual.** Redact avatars and handles for small accounts.
- **Opening on silence.** A still with no bed and no cue reads as a technical fault in the first two seconds, which is the worst possible place for one.
- **Known gap:** the exact dwell and framing in the reference are not measurable from a contact sheet; the numbers here come from the reading budget and this library's cold-open notes.
