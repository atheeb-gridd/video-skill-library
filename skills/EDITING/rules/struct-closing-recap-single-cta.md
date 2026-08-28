---
id: struct-closing-recap-single-cta
title: Close the count, give one takeaway, make one conditional ask — then stop
skill: editing
type: structure
family: outro
tags: [skill/editing, type/structure, family/outro, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:05:26"
    quote: "There we go. That's 10 common editing cuts you can use to help with your storytelling."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:05:30"
    quote: "To really maximize the impact of your edits and cuts, take the time to plan and storyboard them before you go out shooting."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:05:39"
    quote: "If this video helped you at all, subscribe below and I'll see you in the next one."
research_refs:
  - https://vidiq.com/blog/post/youtube-cta/
  - https://tuberanker.com/blog/how-long-should-a-youtube-outro-be
  - https://support.google.com/youtube/answer/6388789?hl=en
  - https://journals.sagepub.com/doi/full/10.1177/2055207619832767
  - https://www.emerald.com/jrim/article-abstract/20/3/324/1265634/When-online-advertising-backfires-how-imperative
  - https://www.opus.pro/blog/youtube-retention-graphs-explained
difficulty: low
detectable_from: transcript
---

# Close the count, give one takeaway, make one conditional ask — then stop

## What it is
A three-move outro, in a fixed order, occupying about **17 seconds of a 5:43 video — roughly 5% of runtime**. Move one **states the promise as fulfilled** and re-uses the promise's own number: *"That's 10 common editing cuts you can use to help with your storytelling."* Move two gives **one actionable takeaway** that was not in the list — here, plan and storyboard your cuts before the shoot ([[struct-storyboard-the-cuts-pre-shoot]]) — so the last thing the viewer receives is still value. Move three is **one short conditional ask**: *"If this video helped you at all, subscribe below."* No stacked requests, no second pitch, no long tail after the value has been delivered. The conditional framing is what binds the ask to the recap: the subscribe is contingent on the thing the recap just claimed was delivered.

## When to use it
On any video that promised a **countable payload** and delivered it — a numbered list, a set of pillars, N mistakes, N techniques. The recap is what closes the counter that the opening opened ([[struct-enumerated-promise-and-counter]]), and closing it is a real payoff, not filler. Also correct for tutorials with a single completed outcome. Use the *other* outro instead when the topic is genuinely unfinished and there is an honest next watch to hand off to: a summary closes a session, a handoff extends one ([[struct-end-screen-handoff]]). The two are mutually exclusive at the same moment — the handoff outro deliberately refuses to recap, and stacking a recap, a handoff, a subscribe ask, a comment ask and a link is the failure this note exists to prevent.

## How to recognise it in a reference video
- **Transcript, final 45 s, three moves in order.** Look for: (1) a **completion marker** — "that's", "there we go", "so those are" — followed by the payload restated, ideally with the same numeral as the opening promise; (2) an **imperative advice sentence** that was not one of the list items; (3) a **single ask**. All three, in that order, is this technique.
- **Numeral match.** Find the numeral in the first 30 s ("10 important editing cuts") and in the final 45 s ("that's 10 common editing cuts"). A match is the strongest single signal that the video is built on an enumerated promise and closed properly.
- **Count the asks.** Tokenise the final 45 s for ask verbs: subscribe, like, comment, click, download, join, follow, check out, link in the description. **Exactly one** is this pattern. Three or more is the stacked-ask failure. Log the count; it is the most diagnostic number here.
- **Conditional vs imperative framing.** Check whether the ask is prefixed by a condition ("if this helped you at all…", "if you got something out of this…") or is bare imperative ("smash that subscribe button"). Log which — it is a house-voice parameter.
- **Outro share of runtime.** `outro_seconds ÷ runtime`. The reference sits at **0.05** (17 s of 343 s). Anything over ~0.08 in a short video, or over 25 s absolute, is a tail that costs watch time.
- **Where the value stops.** Find the last frame of substantive content. In this pattern the takeaway sentence is *after* it and is still content — that is deliberate. If the final 20 s contain nothing but asks, the pattern is not being used.
- **Absence of a second pitch.** Check whether a mid-roll offer is repeated at the end. In this pattern it is not; the closing ask is the free one.
- **Visual signature.** Expect a return to A-roll or a clean card, the bed continuing or lifting slightly, cut density dropping to near zero, and — if end screens are used — elements appearing inside the platform's last-20-second window.
- **Hard stop.** Measure from the ask's final word to the video's last frame. This pattern ends within a few seconds; a 15-second silent tail after the ask is a different (and worse) shape.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `outro_total` | 17 s (510 f) | 8–20 s | Reference is 17 s. Published outro guidance clusters at 8–12 s with 20 s as the practical maximum. |
| `outro_share` | 0.05 | 0.03–0.08 | Outro ÷ runtime. |
| `recap_len` | 5 s (150 f) | 3–7 s | One sentence. Completion marker + payload + numeral. |
| `recap_numeral_match` | true | — | Re-use the opening promise's number verbatim. This is what makes it a payoff rather than a summary. |
| `takeaway_len` | 8 s (240 f) | 5–10 s | One actionable sentence that is **not** a list item. |
| `takeaway_is_new` | true | — | If it merely repeats item 7, it is padding. |
| `ask_count` | 1 | 1 (2 absolute max) | Published guidance allows 1–3 CTAs across a whole video; **at the close, one**. |
| `ask_len` | 4 s (120 f) | 2–6 s | One sentence, one verb, one destination. |
| `ask_framing` | conditional | conditional \| imperative | "If this helped you at all…" vs "Subscribe now". House choice; see the gap note. |
| `ask_specificity` | benefit-led | — | "Subscribe for weekly editing breakdowns" beats "subscribe to my channel". |
| `tail_after_ask` | 3 s (90 f) | 0–8 s | Music-only. Longer only if end-screen elements need dwell. |
| `end_screen_window` | last 20 s | 5–20 s | Platform rule; requires a video ≥25 s. Only if elements are used at all. |
| `cut_density_outro` | 0.3× body | 0.2–0.5× | The outro is the slowest part of the video. |
| `music_action` | continue, +2 dB | continue \| +0 to +3 dB | The bed carries the tail. A dead-silent outro reads as the file ending badly. |

## Reproduction prompt

```
Write and cut the closing 8-20 seconds.

1. RECAP, ONE SENTENCE, 3-7 SECONDS. Open with a completion marker
   ("that's", "so those are", "there we go") and restate the payload using
   the SAME NUMBER the opening promised. Add the benefit clause the promise
   implied. Template:
     "That's {{N}} {{PAYLOAD}} you can use to {{PROMISED BENEFIT}}."
   Do not list the items again. Do not add a new claim.
2. TAKEAWAY, ONE SENTENCE, 5-10 SECONDS. Give one actionable instruction
   that was NOT one of the {{N}} items - the thing you would tell someone
   who now knows all {{N}}. It must be executable this week. Template:
     "To really {{OUTCOME}}, {{IMPERATIVE ACTION}} before you {{CONTEXT}}."
   If you cannot name something new, cut this move entirely rather than
   restating an item.
3. ASK, ONE SENTENCE, 2-6 SECONDS, EXACTLY ONE ASK. Bind it to the recap
   with a condition, then name one action and one benefit:
     "If this helped you at all, subscribe for {{WHAT THEY GET NEXT}}."
   Banned here: a second ask of any kind (like, comment, click, download,
   join), a repeat of the mid-roll offer, and any ask before the recap.
4. CUT IT SLOW. Drop cut density to 0.3x the body's. Return to A-roll or a
   single clean card. No new B-roll, no new graphics beyond the end card.
5. SOUND IT. The bed continues through all three moves and lifts 0-3 dB as
   the last word lands. Never end on silence unless silence is the
   video's deliberate final gesture.
6. STOP. Hold 3 seconds (90 frames) after the final word, then end. If
   end-screen elements are used, they appear as the ASK begins - inside the
   platform's final-20-second window - and the tail extends only as far as
   they need, never past 20s total.
7. ACCEPTANCE TEST: (a) count ask verbs in the final 45s of transcript -
   exactly 1; (b) the recap's numeral matches the opening promise's
   numeral; (c) the takeaway sentence does not appear anywhere earlier in
   the transcript; (d) outro total is 8-20s and under 8% of runtime;
   (e) read the last three sentences aloud - they are recap, then value,
   then ask, in that order and no other; (f) the video does not continue
   for more than 8s after the final word.
```

## Execution spec

**HyperFrames (assembly).** The outro is a scene boundary, so build it as a sub-composition once the project has three or more scene cuts — the composition-patterns guidance says to modularise before adding the next scene. Keep audio at the **host root** so the bed survives the cut into the outro.

```html
<!-- body ends at 326.00s; 17s outro -->
<div id="el-outro" data-composition-id="outro"
     data-composition-src="compositions/outro.html"
     data-start="326.00" data-duration="17.00" data-track-index="1"></div>

<audio id="bed" src="assets/bgm/bed.mp3" data-audio-group="music"
       data-start="12.00" data-duration="331.00" data-track-index="11" data-volume="0.55"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.5,&quot;v&quot;:1},{&quot;t&quot;:325,&quot;v&quot;:1},{&quot;t&quot;:328,&quot;v&quot;:1.25},{&quot;t&quot;:329.5,&quot;v&quot;:1.25},{&quot;t&quot;:331,&quot;v&quot;:0}]}]}"></audio>
```
Contract points: the lane's `t` is **clip-local seconds** and **holds its first value backwards**, so `{t:0,v:0}` is what creates the opening fade rather than starting at unity; `v` above 1 is legal up to `3.98` (+12 dB) but 1.25 (≈ +2 dB) is the lift this note wants; carve settings live on the **bed** and `sources` must name a **group**, and after placing, run `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`.

Inside `compositions/outro.html` — a `<template>`-wrapped root whose `<style>`/`<script>` live **inside** the template, because the assembler drops a sub-comp's own `<head>` tags — the three moves are three timed elements at scene-local seconds:

```js
// scene-local. Entrances only; exits are banned except on the final scene, which this is.
const tl = gsap.timeline({ paused: true, defaults: { duration: 0.5, ease: "power3.out" } });
tl.fromTo("#recap",    { y: 24, autoAlpha: 0 }, { y: 0, autoAlpha: 1 }, 0.2);
tl.fromTo("#takeaway", { y: 24, autoAlpha: 0 }, { y: 0, autoAlpha: 1 }, 5.2);
tl.fromTo("#cta",      { y: 24, autoAlpha: 0 }, { y: 0, autoAlpha: 1 }, 12.8);
tl.to("#outro-wrap", { autoAlpha: 0, duration: 0.6 }, 16.2);   // final-scene fade is the one allowed exit
window.__timelines["outro"] = tl;
```
Five things that will otherwise bite: use `fromTo`, never `from` (`from()` sets `immediateRender` and flashes under non-linear seek); `autoAlpha` on **non-clip** elements only, never on the `.clip` itself; land the last tween **before** the root `data-duration`, since the window is half-open; the sub-comp timeline **cannot** animate host-root elements; and GSAP must be loaded from a **local** path — `cdn.jsdelivr.net` is blocked by the egress allowlist in this project, so the upstream skeleton's CDN `<script>` line must be replaced with a vendored file.

End-card typography: video sizes, not web sizes — body ≥20 px full-screen, ≥32 px in-feed; headlines 60 px+ / ≥90 px in-feed; tracking −0.03 to −0.05em at display sizes. `Inter` is bundled but on the banned-monoculture list; Montserrat, Archivo Black or League Gothic are safe bundled picks. Keep the card clear of the platform's end-screen safe zones, and if the card sits in the caption band, opt out narrowly with `data-layout-allow-caption-zone` rather than the blast-radius `data-layout-allow-overflow`.

**ffmpeg.** Measurement only:
```bash
ffprobe -v error -show_entries format=duration -of csv=p=0 final.mp4          # runtime, for outro_share
ffmpeg -ss 326 -i final.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep -c lavfi.scd   # outro cut count
```

**Epidemic Sound.** The outro rides the body's bed rather than introducing a new track — a new track at the end reads as a second video starting. If the body bed has no usable ending, use `SearchSimilarToRecording` against it and take an outro-length section, or land the change on a beat. Keep it instrumental: your voice is present through all three moves ([[sfx-vocal-vs-instrumental-bed]]).

**Remotion:** a final `<Sequence>` with three staggered text entrances; no Remotion runtime in this project.

## Pairs with
[[struct-enumerated-promise-and-counter]] · [[struct-storyboard-the-cuts-pre-shoot]] · [[struct-end-screen-handoff]] · [[struct-cta-after-payoff]] · [[struct-numbered-list-mid-roll-sponsor]] · [[struct-comment-prompt-curiosity-gap]] · [[sfx-music-hard-stop]] · [[pace-cut-density-from-viewer-intent]] · [[struct-credibility-anchor]]

## Failure modes
- **Stacked asks.** Subscribe, like, comment, click the link, join the Discord. Each additional ask reduces compliance with all of them; published CTA guidance caps a whole video at 1–3 and this is the *closing* one. Fix: one ask, and put any second ask mid-roll where it has its own payoff.
- **Recap without a numeral.** "So that's basically it" pays off nothing. Fix: restate the promise's number verbatim; if the video had no counted promise, use the handoff outro instead.
- **Takeaway that is really item 11.** A new list item at the close reopens the count you just closed. Fix: the takeaway must be about *how to use* the payload, not another piece of it.
- **Asking before recapping.** The ask then rests on nothing. Fix: fixed order — recap, takeaway, ask.
- **A long tail.** Twenty seconds of music over a card after the final word. Fix: 3 s, extended only as far as end-screen elements genuinely need, never past 20 s total.
- **Ending on silence with no bed.** Reads as the render failing. Fix: bed continues, lifting 0–3 dB.
- **Using this outro on an open topic.** A recap on a video whose subject is obviously unfinished wastes the session-continuation opportunity. Fix: switch to [[struct-end-screen-handoff]].
- **Known gap:** the advantage of *conditional* phrasing ("if this helped you at all") over a bare imperative is **not established**. A controlled study of autonomy-supportive language and choice provision found **no significant effects** on reactance or perceived autonomy support (counterarguing b = .37, p = .411; anger b = −.13, p = .721), while the marketing literature on imperative CTAs triggering reactance exists but is not accessible in full here. Treat `ask_framing` as house voice, and note that its real structural benefit — binding the ask to the recap's delivered value — is an argument about *placement*, which is well supported, rather than about wording, which is not.
