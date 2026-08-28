---
id: struct-comment-prompt-curiosity-gap
title: Fuse the comment ask to a real teaching question, then answer it on screen
skill: editing
type: retention
family: engagement
tags: [skill/editing, type/retention, family/engagement, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:05:50
    quote: "Let me show you a real example. There's a line animation here. What sound effect are you imagining could go here? A whoosh? Nah, leave it. First, drop in the comments which sound effect you think should go here."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:06:20
    quote: "[...] is the sound effect, and if you put a water sound effect in its place, it'll just feel weird."
research_refs:
  - https://air.io/en/youtube-hacks/what-to-write-in-your-youtube-pinned-comment-to-get-a-reaction-from-your-audience
  - https://www.emerald.com/jrim/article-abstract/20/1/49/1256035/Like-comment-and-subscribe-investigating-the
  - https://www.retentionrabbit.com/blog/2025-youtube-audience-retention-benchmark-report
  - https://backlinko.com/hub/youtube/retention
difficulty: low
detectable_from: transcript+video
---

# Fuse the comment ask to a real teaching question, then answer it on screen

## What it is
An engagement prompt built on top of a genuine teaching question instead of bolted on as a generic ask. The video reaches a point where the viewer is *already* forming an answer — "which sound effect goes on this line animation?" — and at that exact moment the guess is redirected into the comments, and the video's own answer is **withheld and delivered later**. Three things happen at once: the viewer is asked to commit to a prediction (which is a teaching act, not a marketing one), a curiosity gap opens, and the ask costs the viewer nothing because they had the thought anyway. In the source the prompt lands at **00:05:50** and the answer arrives at **00:06:20 — thirty seconds later**, which is the whole retention mechanism.

## When to use it
At the one point in the video where the audience's own guess is both natural and non-obvious: a "what would you put here" beat, a before/after where the fix is not visible yet, a wrong-answer that most people would choose. It requires that the video actually answer the question — an unanswered prompt is a broken promise and reads as a farm. Place it in the **middle third**, not the end: at the end there is no gap left to close and no audience left to close it for (only about 16% of viewers reach the final ten seconds). Use it **once**. A second one in the same video converts the device from a teaching beat back into a generic ask, and the audience can tell the difference. Never place it before 90 seconds — you are asking the audience to leave the player for the comment box at the exact moment they are deciding whether to stay.

## How to recognise it in a reference video
- **Transcript detection is reliable, because the phrasing is formulaic:**
  `grep -nEi "(drop|let me know|tell me|comment) (it |them )?(in |down in )?the comments|what (do you think|would you)|which .{0,30} (do you think|would you) (use|put|pick)" transcript.md`
- **Then check the three-part shape, in order.** (1) A **real question** posed about something on screen. (2) The **ask** ("drop it in the comments"). (3) The **video's own answer**, later. All three, or it is a generic CTA wearing a costume.
- **Measure the answer delay** — the gap between the ask and the answer. This is the diagnostic number. **20–60 s** is the working band; the source runs 30 s. If the answer never arrives, log it as a farm; if it arrives in under ~8 s, there was no gap and the ask was decorative.
- **Measure the position** as a fraction of runtime. Good examples sit at **35–70%**. An ask in the first 90 s or the last 60 s is the weak variant.
- **Measure the ask's own length.** **4–10 s** including the question. Longer and it becomes a housekeeping segment.
- **Check the cognitive load of the question.** The strong form can be answered in under three seconds with one word or one guess. "Which sound effect goes here?" qualifies; "what's your workflow?" does not, and reply-rate data across formats consistently favours the low-load forms — polarising questions, micro-polls, and Q&A tied to a specific video moment all measure in the **+20–38% reply-lift** range against generic asks.
- **Check the on-screen support.** Expect a short text overlay carrying the question (not the ask) for **2.5–4 s**, plus often a small accent sound. A prompt with no on-screen support is easy to miss on muted mobile playback.
- **Check what happens to the picture.** In good examples the picture **holds on the thing being asked about** — the line animation, the before-state — so the question has a visible referent for its whole duration.
- **Check the bed.** Usually thinned 6–8 dB under the ask, restored on the next content beat.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `position_pct` | 50% | 35–70% of runtime | Middle third. Never before 90 s, never in the last 60 s. |
| `ask_duration` | 7 s | 4–10 s | Question + ask, spoken. |
| `answer_delay` | 30 s | 20–60 s | Gap between the ask and the video's own answer. The retention payload. |
| `answer_required` | true | — | Non-negotiable. |
| `question_load` | ≤3 s to answer | — | One word or one guess. Not "what's your process?". |
| `question_form` | prediction | prediction \| micro-poll \| polarising \| timestamp | Prediction tied to something on screen is the strongest for a teaching video. |
| `overlay_text` | the question | — | Print the **question**, not "comment below". 4–8 words. |
| `overlay_hold` | 3.0 s | 2.5–4.0 s | |
| `overlay_in` | 0.40 s (12 f) | 0.30–0.50 s | `power3.out`. |
| `overlay_out` | 0.25 s (7 f) | 0.20–0.35 s | |
| `overlay_size` | 64 px @1080p | 48–90 px | ≥90 px if the deliverable is watched in-feed. Inside 90% title safe. |
| `bed_dip` | −7 dB | −5 to −10 dB | Restored on the next content beat. |
| `sfx_accent` | 1 soft tick | 0–1 | −12 to −15 dB, on the overlay's first frame. |
| `picture` | hold on the referent | — | No cut away from the thing being asked about during the ask. |
| `prompts_per_video` | 1 | 0–1 | Two is one too many. |
| `success_metric` | comment-to-view ratio, 72 h | — | Not raw comment count. |

## Reproduction prompt

```
Build one comment prompt fused to a teaching beat.

1. FIND THE BEAT, do not invent it. Scan the script for the point where the
   viewer will already be forming a guess about something visible on screen -
   "what sound goes here", "which of these is wrong", "what happens next".
   If no such beat exists, do not add a comment prompt; a generic ask is worse
   than none.

2. CHECK THE POSITION: between 35% and 70% of runtime, never before 90s, never
   in the last 60s.

3. WRITE THE THREE PARTS:
     QUESTION  one sentence about the thing on screen, answerable in under
               three seconds with one word or one guess.
     ASK       one clause: "drop in the comments which <X> you think goes
               here." Do NOT bundle like/subscribe into it.
     ANSWER    the video's own answer, delivered 20-60 seconds later. Write it
               now, in the same pass, so it cannot be forgotten.
   Total spoken length of QUESTION + ASK: 4-10 seconds.

4. HOLD THE PICTURE on the referent for the whole ask. Do not cut away to the
   presenter, and do not start any new animation.

5. PRINT THE QUESTION on screen - not the words "comment below". 4-8 words, 64px
   at 1080p (90px+ if the cut is for in-feed viewing), inside 90% title safe,
   in over 0.40s power3.out, hold 3.0s, out over 0.25s.

6. Dip the bed 7 dB across the ask with a 0.2s ramp; restore it on the first
   word after. Optionally one soft tick at -12 to -15 dB on the overlay's first
   frame; nothing on the exit.

7. AT THE ANSWER, close the loop explicitly - refer back to the question in the
   same words before giving the answer, so a viewer who commented sees they
   were answered.

ACCEPTANCE TEST: (a) the answer exists and lands 20-60s after the ask,
frame-checked; (b) read the QUESTION aloud to someone who has not watched the
video - they must be able to attempt an answer in under three seconds; (c) the
picture never cuts away from the referent during the ask; (d) the on-screen
text carries the question, not the CTA; (e) there is exactly one comment prompt
in the whole video; (f) no engagement ask appears before 90s.
```

## Execution spec

**HyperFrames.** One overlay clip carrying the question, a bed dip, and — because it matters for the acceptance test — the *answer* beat authored in the same pass so it cannot be dropped.

```html
<!-- the referent keeps running underneath on track 0/1; this is the question overlay -->
<div id="ask-sfx" class="clip" data-start="350.0" data-duration="3.7" data-track-index="3"
     style="position:absolute; inset:0; display:flex; align-items:flex-end; justify-content:center; padding-bottom:210px;">
  <div id="ask-sfx-inner"
       style="font-family:'Oswald', sans-serif; font-size:64px; letter-spacing:-.03em; color:#fff;
              background:rgba(10,10,12,.72); padding:16px 30px; border-radius:8px; text-align:center;">
    Which sound goes here?
  </div>
</div>
```

```js
const T = 350.0;
tl.fromTo("#ask-sfx-inner", { y: 22, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.40, ease: "power3.out" }, T);
tl.to("#ask-sfx-inner", { autoAlpha: 0, duration: 0.25, ease: "power2.in" }, T + 3.35);
// 3.35 + 0.25 = 3.60 < data-duration 3.70 -> the resolved end state is inside the window
```

Contract points that bind this:
- `data-duration` is **required** on a `div` clip; without a resolvable duration the element stays visible for the rest of the composition.
- The visibility window is `[start, start+duration)` — land the exit **before** `data-duration` or the final frame is never rendered.
- `fromTo`, never `from` (`from()` sets `immediateRender: true`, writing its start state before the clip is active; under the render's non-linear seek it flashes or skips).
- `autoAlpha` on the **inner** element; never tween `display`/`visibility` on a `.clip` — the framework owns clip visibility and lint rejects it.
- Use `x`/`y`/`scale`; `width`/`height`/`top`/`left` tweens are forbidden. No CSS `transform` on `#ask-sfx-inner` alongside the GSAP `y` tween (`gsap_css_transform_conflict`, error).
- The overlay sits in the lower band, so it collides with the caption zone by construction. The narrow opt-out is **`data-layout-allow-caption-zone`** on this element (applies to it and its descendants via `closest`); do **not** reach for `data-layout-allow-overflow`, which also suppresses text-clipping and cramped-container findings across the whole subtree.
- 64 px sits in the full-screen band (body ≥20 px, headlines 60 px+); for in-feed raise to ≥90 px. Tracking −0.03 to −0.05 em at display sizes.
- Fonts must be bundled or local `@font-face` — **no Google Fonts fetch, no CDN script tag** (`cdn.jsdelivr.net` is blocked; GSAP must be vendored locally). Avoid `Inter` (bundled but on the banned monoculture list).
- **Author the answer beat in the same edit.** Nothing in this stack enforces that the loop closes; the only defence is that both beats are written together and both appear in `STORYBOARD.md`. Use the storyboard's per-frame metadata (`scene`, `voiceover`) to record the pairing, since the parser preserves unknown keys under `extra` — e.g. a `loop: ask-sfx` key on both frames.

**The bed dip** — a `volume` lane, `t` in **clip-local** seconds, with an explicit `t:0` point because a lane holds its first value backwards to the clip start:

```html
data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:349.8,&quot;v&quot;:1},{&quot;t&quot;:350.0,&quot;v&quot;:0.45},{&quot;t&quot;:357.0,&quot;v&quot;:0.45},{&quot;t&quot;:357.3,&quot;v&quot;:1}]}]}"
```
`0.45` ≈ −7 dB. Do not also GSAP-tween `volume` on the bed (`audio_volume_double_automation` — the lane wins and the tween is ignored).

**ffmpeg** — for auditing a reference: locate the ask and its answer, and confirm the delay.
```bash
ffmpeg -ss 345 -t 45 -i ref.mp4 -vn -c:a pcm_s16le ask.wav      # listen to the ask + answer window
ffmpeg -ss 350 -t 4 -i ref.mp4 -vf fps=6 ask_%02d.png           # confirm the overlay and the held referent
```

**Epidemic Sound:** one short accent, and not a file already used elsewhere in the video.
```
SearchSoundEffects({ query: { term: "soft ui tick notification short" },
                     filter: { duration: { max: 700 } }, first: 10 })
```
Place with the transient's loudest frame on the overlay's first visible frame, `data-audio-group="sfx"`, `data-volume` ≈ 0.22 (−13 dB). See [[sfx-whoosh-transition-movement-reveal]].

**Remotion:** a `<Sequence>` with an interpolated opacity/`translateY` on a text component; concept only.

## Pairs with
[[struct-cta-after-payoff]] · [[struct-demo-before-label]] · [[struct-scope-refusal-deflection]] · [[struct-enumerated-promise-and-counter]] · [[struct-numbered-list-mid-roll-sponsor]] · [[motion-list-item-marker-card]] · [[pace-silent-demonstration-window]] · [[struct-handbook-reframe]] · [[struct-objection-character-cutaway]] · [[struct-comment-screenshot-cold-open]]

## Failure modes
- **The video never answers.** The prompt becomes a comment farm and the audience learns to ignore every future ask. Correction: write the answer beat in the same pass; refuse to ship the prompt without it.
- **Answer arrives immediately.** No gap, no retention benefit, and the ask reads as a formality. Correction: 20–60 s of delay.
- **Prompt in the first 90 seconds.** Sends the viewer to the comment box during the window in which more than half the audience is already leaving. Correction: middle third only.
- **Prompt at the end.** There is no loop left to close and only a fraction of the audience is still present. Correction: middle third.
- **High-load question.** "What's your editing workflow?" takes thirty seconds to answer and gets no replies. Correction: one word, one guess, under three seconds.
- **Bundled with like-and-subscribe.** Collapses the teaching beat back into a generic CTA and the specificity — the whole reason it works — is lost. Correction: the comment ask stands alone; put the subscribe ask somewhere else entirely.
- **On-screen text carrying the CTA instead of the question.** "COMMENT BELOW" gives a muted viewer no reason to. Correction: print the question.
- **Picture cuts away during the ask.** The question loses its referent and stops being answerable. Correction: hold on the thing being asked about.
- **Two prompts.** Correction: one.
- **Known gap:** the reply-lift figures cited here come from a channel-level industry study, not from controlled research, and the peer-reviewed work on like/comment/subscribe prompts is behind a paywall and was not read in full for this note. Treat the format ranking (low-load, emotionally triggered, narrative-continuing) as directional, and measure the **comment-to-view ratio over the first 72 hours** on your own channel rather than trusting the percentages.
