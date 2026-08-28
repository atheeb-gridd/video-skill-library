---
id: struct-scope-refusal-deflection
title: Raise the obvious question, point elsewhere, close the scope
skill: editing
type: structure
family: hook
tags: [skill/editing, type/structure, family/hook, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:00:30
    quote: "So the first question in your head will be: where do I get the music? For that, I've already covered paid, free and copyright-free resources in a whole separate video."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:00:36
    quote: "So in this video we're not doing resources — we're going to understand the concept of music."
research_refs:
  - https://www.retentionrabbit.com/blog/2025-youtube-audience-retention-benchmark-report
  - https://www.tubeanalytics.net/blog/youtube-cards-end-screens-checklist-for-retention
  - https://www.creativeadvisor.com/youtube/youtube-info-cards-how-to-use
  - https://backlinko.com/hub/youtube/retention
difficulty: low
detectable_from: transcript
---

# Raise the obvious question, point elsewhere, close the scope

## What it is
A three-beat intro move that protects a video's scope from the shallow version of its own topic. Beat one **states the question the audience is already forming** ("where do I get the music?"). Beat two **answers it by pointing at an existing asset** ("I've already covered paid, free and copyright-free resources in a separate video"). Beat three **closes the door** ("so in this video we're not doing resources — we're going to understand the concept"). It does three jobs at once: it demonstrates that you know what they want, it removes the reason to leave and search, and it converts the shallow question from an unmet expectation into an already-solved one. In the source it runs **00:00:30 → 00:00:38 — eight seconds** — at 6.3% of a 7:57 runtime, between the counted promise (00:00:14) and the first content beat (00:00:47).

## When to use it
When your topic has an obvious surface question that is *not* what the video is about, and that question is what most of the audience thinks they came for. The classic shapes: "where do I get X" in front of a video about how to use X; "what gear" in front of a video about technique; "what tool" in front of a video about process; "what's the prompt" in front of a video about method. Use it once, in the intro, after the hook and the promise and before the first content section. Do **not** use it as an excuse for a gap the video should have filled — if the audience needs the resource list to act on the concept, the deflection reads as a dodge and the comments will say so. And do not stack two deflections; a video that refuses two questions in its intro sounds defensive.

## How to recognise it in a reference video
- **Transcript-only detection, and it is highly regular.** Look for a self-posed question followed by a deflection:
  `grep -nEi "(first|obvious) question|you('| a)?re probably (wondering|thinking)|(i'?ve|i have) already (covered|made|done).{0,40}(separate|another|other) video|(in this video )?we('| a)?re not (doing|covering)|this (video )?is ?n'?t about" transcript.md`
- **All three beats present, in order.** The degraded versions are common and identifiable: question + deflection with no scope statement (the viewer does not learn what they *are* getting), or scope statement with no question raised (reads as arbitrary).
- **Duration.** 6–12 seconds, 20–40 words. Over ~15 s it becomes a housekeeping segment and starts costing more retention than it saves.
- **Position.** Between **20 and 60 seconds**, after the promise, before the first content beat. Measure the gap to the first content beat: **under 15 s** in good examples.
- **Check for a clickable element.** Frame-pull the window: a real deflection in the first minute is usually **verbal only**, with a card or link deferred to the end screen, the description or a pinned comment. If a clickable card appears at 30 seconds, log it — that is the risky variant, because **about 55% of viewers are already lost by 60 seconds** and a mid-intro link invites the remainder to leave for a different video.
- **Look for a visual receipt, not a link.** A thumbnail of the other video, or a title card naming it, held **1.5–2.5 s** and *not* clickable, is the strong form: it proves the asset exists without offering an exit.
- **Listen for a music/level change.** The scope statement is usually the driest line in the intro — bed thinned or briefly stopped so the sentence lands.
- **Corroborate the promise.** The scope statement's positive half ("we're going to understand the concept") should match what the body actually does. If the body then lists resources anyway, the beat was decoration.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `position` | 30 s | 20–60 s | After the promise, before the first content section. |
| `gap_to_first_content` | 9 s | 0–15 s | Do not let it float in the middle of the intro. |
| `duration` | 8 s | 6–12 s | 20–40 spoken words. Hard ceiling 15 s. |
| `beat_count` | 3 | 3 | Question / pointer / scope. All three, in order. |
| `clickable` | `false` | false \| true | **Default false in the first 90 s.** Defer the link to end screen, description and pinned comment. |
| `receipt_form` | title card | none \| title card \| thumbnail | Non-clickable visual proof the other asset exists. |
| `receipt_hold` | 2.0 s | 1.5–2.5 s | |
| `receipt_in` | 0.35 s (10 f) | 0.30–0.50 s | `power3.out`. |
| `bed_dip` | −6 dB | −4 to −10 dB | Under the scope statement; restore on the first content word. |
| `deflections_per_video` | 1 | 0–1 | Two reads as defensive. |
| `link_slots` | end screen + description | — | End screen at the final 5–20 s; description line 1–2; pinned comment. |

## Reproduction prompt

```
Write and place a scope-refusal deflection in the intro.

1. Name the SHALLOW QUESTION in the audience's own words - the thing they think
   they came for that this video is not about. One sentence, phrased as they
   would phrase it ("where do I get the music?"). If you cannot name it, skip
   this technique; you are inventing an objection.

2. Name the POINTER: an asset that actually answers it - a previous video, a
   doc, a description link. It must exist. Do not promise a future video.

3. Write the three beats, 20-40 words total, in this order:
     RAISE:  "The first question in your head will be: <SHALLOW QUESTION>"
     POINT:  "I've already covered <SHALLOW ANSWER> in <POINTER>"
     CLOSE:  "So in this video we're not doing <SHALLOW TOPIC> - we're doing
             <ACTUAL TOPIC>"
   The CLOSE beat must contain BOTH halves: what is excluded and what replaces
   it. A close with only the exclusion loses the viewer you were keeping.

4. Place it so it starts between 20s and 60s and its last word is within 15s of
   the first content beat.

5. Show a NON-CLICKABLE receipt over the POINT beat: a title card or a
   thumbnail of the other video, in over 0.35s (power3.out), hold 2.0s. Do NOT
   place a clickable card here. Put every clickable link in the end screen, the
   description's first two lines, and a pinned comment.

6. Dip the music bed 6 dB across the CLOSE beat with a 0.2s ramp and restore it
   on the first word of the first content section, so the scope statement is
   the driest line in the intro.

ACCEPTANCE TEST: (a) the whole beat is under 12 seconds, timed on the render;
(b) read the CLOSE beat alone - it must state what the video IS, not only what
it is not; (c) no clickable element appears before 90s; (d) search the body's
transcript for the excluded topic - if the body covers it anyway, delete the
deflection or cut the body; (e) mute the audio and watch the intro: the receipt
card must be legible inside 90% title safe and must not look like a button.
```

## Execution spec

**Hyperframes.** Two things to author: a receipt card as an overlay clip, and a bed dip. The receipt is deliberately styled *not* to look interactive — no rounded button, no arrow, no "click here".

```html
<div id="card-pointer" class="clip" data-start="34.0" data-duration="2.6" data-track-index="2"
     style="position:absolute; inset:0; display:flex; align-items:flex-start; justify-content:flex-end; padding:120px 192px 0 0;">
  <div id="card-pointer-inner"
       style="display:flex; align-items:center; gap:22px; background:rgba(12,12,14,.82);
              padding:18px 26px; border-radius:10px;">
    <img src="assets/img/prev-video-thumb.jpg" alt="" style="width:280px; height:158px; object-fit:cover; border-radius:6px;">
    <div style="font-family:'Oswald',sans-serif; font-size:38px; letter-spacing:-.03em; color:#fff; max-width:420px;">
      Covered already:<br>music resources
    </div>
  </div>
</div>
```

```js
const T = 34.0;
tl.fromTo("#card-pointer-inner", { x: 40, autoAlpha: 0 },
  { x: 0, autoAlpha: 1, duration: 0.35, ease: "power3.out" }, T);
tl.to("#card-pointer-inner", { autoAlpha: 0, duration: 0.25, ease: "power2.in" }, T + 2.25);
```

Contract points that bind this:
- `data-duration` is **required** on a `div` clip; without a resolvable duration the element never ends.
- The exit lands at 2.25 + 0.25 = 2.50 < 2.60 — **before** `data-duration`, because the visibility window is `[start, start+duration)` and the final frame is never rendered.
- `fromTo`, never `from`; `autoAlpha` on the inner element, never `display`/`visibility` on the clip.
- Use `x`/`y`/`scale`, never `left`/`top`/`width`/`height`.
- No CSS `transform` on `#card-pointer-inner` alongside the GSAP `x` tween — that is `gsap_css_transform_conflict` (error).
- Keep the card inside 90% title safe (192 px inset at 1080p) and out of the caption band; `data-layout-allow-caption-zone` is the narrow opt-out if a lower placement is deliberate.
- Fonts: bundled or local `@font-face` only — no Google Fonts fetch, no CDN `<script>` for GSAP (`cdn.jsdelivr.net` is blocked). Avoid `Inter`.
- The thumbnail `<img>` here is **not** a timed clip (no `data-start`), so it is a child of the timed wrapper and inherits its window — fine. An untimed full-bleed element, by contrast, needs its own `position:absolute; inset:0` or it collapses to zero height.

**The bed dip** — a `volume` lane on the bed, `t` in clip-local seconds, explicit `t:0` point because a lane holds its first value backwards:

```html
data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:36.0,&quot;v&quot;:1},{&quot;t&quot;:36.2,&quot;v&quot;:0.5},{&quot;t&quot;:38.4,&quot;v&quot;:0.5},{&quot;t&quot;:38.6,&quot;v&quot;:1}]}]}"
```
`0.5` ≈ −6 dB. Do not also GSAP-tween `volume` on that clip (`audio_volume_double_automation` — the lane wins).

**ffmpeg** — only for locating the beat in a reference (extract the intro's audio, or pull the receipt frames):
```bash
ffmpeg -ss 20 -t 45 -i ref.mp4 -vn -c:a pcm_s16le intro.wav
ffmpeg -ss 34 -t 3 -i ref.mp4 -vf fps=8 recv_%02d.png
```

**Epidemic Sound:** nothing new. The receipt card's entrance can carry the same small motion tick used elsewhere in the video (`SearchSoundEffects { query: { term: "soft ui pop short" }, filter: { duration: { max: 600 } } }`) — but if the intro already has an accent within two seconds, use nothing. See [[struct-stimulation-budget]].

**Remotion:** a `<Sequence>` with an interpolated `translateX`/opacity on a card component; concept only.

## Pairs with
[[struct-handbook-reframe]] · [[struct-enumerated-promise-and-counter]] · [[struct-outcome-first-cold-open]] · [[struct-demand-hook-competence-gap]] · [[struct-comment-prompt-curiosity-gap]] · [[struct-numbered-list-mid-roll-sponsor]] · [[sfx-vibe-brief]]

## Failure modes
- **A clickable card at 30 seconds.** You have built an exit at the exact moment the audience is deciding whether to stay. Correction: verbal + non-clickable receipt in the first 90 s; every link in the end screen, description and pinned comment.
- **Close beat with only the exclusion.** "We're not doing resources" and nothing else leaves the viewer with an unmet need and no replacement. Correction: always both halves.
- **The pointer does not exist.** Promising "I'll cover that in another video" converts a solved problem into an unfulfilled promise. Correction: point only at published assets.
- **The body covers the excluded topic anyway.** Destroys the credibility of the intro retroactively. Correction: cut one or the other.
- **Two deflections.** Reads as an editor defending scope rather than a teacher setting it. Correction: one, maximum.
- **Too long.** Past ~15 s it is housekeeping, and housekeeping in the first minute is expensive. Correction: 6–12 s, 40 words.
- **Receipt styled like a button.** Viewers will try to click it, fail, and be annoyed; some will go looking for the link instead. Correction: no rounded CTA shape, no arrow, no "click".
- **Known gap:** there is no published measurement of how a mid-intro cross-promotion affects retention specifically. The "no clickable element before 90 s" rule is a synthesis of first-minute drop-off benchmarks and the qualitative card-placement guidance in the cited sources, and should be treated as a house policy that a channel with its own analytics can override with data.
