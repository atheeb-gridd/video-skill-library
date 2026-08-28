---
id: struct-numeric-like-goal-cta
title: The numeric like goal — turn a generic ask into a countable target
skill: editing
type: retention
family: outro
tags: [skill/editing, type/retention, family/outro, engine/hyperframes, engine/epidemic, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:07:45"
    quote: "Do subscribe. Let's keep a goal of [unclear] likes. I'll meet you in the next video."
research_refs:
  - https://en.wikipedia.org/wiki/Goal_setting
  - https://support.google.com/youtube/answer/2801973
difficulty: low
detectable_from: transcript+video
---

# The numeric like goal — turn a generic ask into a countable target

## What it is
An outro CTA that replaces "please like the video" with a **specific shared number**: *let's get this to 2,000 likes.* Structurally it is three things at once — an ask, a target, and an invitation to participate in a collective result — and the reason it outperforms the generic version is the same reason goal-setting works everywhere else. The research base is unusually solid for a YouTube tactic: across more than 400 studies, **specific, difficult goals produce significantly higher performance than vague ones or "do your best"**, with the optimum sitting near the **90th percentile of prior performance**, and with commitment strengthened by three things — the outcome being seen as important, belief that it is achievable, and a **public promise or engagement to others**. A stated number on a public video satisfies all three at once in a way "hit the like button" satisfies none of them.

The device has one binding constraint and one structural requirement. The constraint: YouTube explicitly permits asking viewers to like, comment or subscribe, but bans *"offering rewards in exchange for likes, views, or subscribers"* as incentivization spam. **"Let's hit 2,000 likes" is fine; "hit 2,000 likes and I'll post the project files" is not.** The requirement: goal-setting theory is a closed loop — *"feedback cannot be given without goals in the same way that goals cannot be established without providing feedback."* A target that is never referred to again decays into noise. Whoever sets one owes the next video a sentence saying whether it was hit.

## When to use it
In the outro, on a channel with an established, measurable baseline — you need a median like count from comparable recent videos in order to pick a defensible number. Use it on content whose value has demonstrably landed, i.e. **after** the recap and the takeaway, so the ask is contingent on something delivered. Use it where the channel has a repeat audience that will see the follow-up; a numeric goal on a video whose viewers never return is a promise made to nobody.

Do not use it on a first video, on a channel with wildly variable performance, or in place of the subscribe ask — it composes with a subscribe, it does not replace it. Do not use it mid-roll: it spends attention on a house-keeping request in the middle of the value. And do not use it more than once per video.

## How to recognise it in a reference video
- **On the transcript:** an explicit numeral attached to "likes" in the final 30 seconds — *"let's get to X likes"*, *"goal of X likes"*, *"if we hit X"*. The numeral is the marker; without one it is a generic CTA and belongs to [[struct-closing-recap-single-cta]].
- **Position:** after the value recap, adjacent to the subscribe ask, before the sign-off line. Typically inside the **last 5% of runtime** — for reference, one analysed outro occupies 17 s of a 5:43 video.
- **Duration of the ask itself:** 3–5 s of speech. Anything longer is a pitch, not a goal.
- **A graphic carrying the number.** Competent versions show the numeral on screen for 2–3 s, because a spoken number alone is poorly retained. Look for a counter, a chip, or a like-icon lockup.
- **Music state:** the bed is *up*, not dropped — the outro bed usually returns or continues at full level under the CTA. A silent window spent on a CTA is a misuse of a scarce device ([[sfx-silence-as-pattern-interrupt]]).
- **Reciprocity framing:** the best versions are conditional and modest — *"if this helped, let's…"* — rather than demanding.
- **The tell of a bad one:** a reward attached to the number (files, giveaways, a promised video), which crosses YouTube's incentivization line, or a fantasy number wildly above anything the channel has achieved.
- **Continuity across uploads:** check the channel's previous video. A real goal is closed out — *"we hit it, thank you"* — at the top or tail of the next one.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Target number | 1.6 × median likes of the last 5 comparable videos | 1.3×–2.0× | Difficult but attainable; goal-setting's optimum is around the 90th percentile of prior performance. |
| Rounding | to the nearest round-but-odd figure (2,000; 1,500; 750) | — | Round numbers read as targets; precise ones read as data. |
| Spoken duration | 4 s | 3–5 s | One sentence. |
| Position in the outro | after recap + takeaway, with or just after the subscribe ask | — | Never before the payoff. |
| Outro total budget | 5% of runtime | 3–8% | ~17 s on a 5:43 video. |
| On-screen graphic hold | 75 f (2.5 s) | 60–90 f | Above the 25 f text floor with margin — see [[pace-visual-mush-ceiling]]. |
| Graphic entrance | 12 f (0.4 s), `power3.out` | 9–15 f | House settle; no overshoot. |
| Music state | bed at full outro level | — | Do not drop the bed for a CTA. |
| Frequency | 1 per video | 1 | Two asks with two numbers cancel each other. |
| Follow-up | close the loop in the next video | mandatory | Goals require feedback or they stop working. |
| Reward attached | none | none | Offering anything in exchange is incentivization spam. |

## Reproduction prompt

```
Add a numeric like-goal CTA to the outro of a video whose runtime is
{{DURATION}} seconds. 30fps; HyperFrames authors seconds (frames / 30).

1. GATE. Confirm all four or skip this device entirely: (a) the channel has
   at least 5 comparable recent uploads with known like counts; (b) the
   video has already delivered its payoff and the recap has happened; (c)
   nothing is being OFFERED in exchange for the likes - a reward makes this
   incentivization spam under YouTube's spam policy, which permits asking
   for likes but bans offering rewards for them; (d) you can commit to
   referring back to the result in the next video.
2. PICK THE NUMBER: median likes of the last 5 comparable videos x 1.6,
   rounded to a clean figure (750, 1,500, 2,000, 5,000). Do not invent an
   aspirational number unrelated to the baseline - an unreachable goal
   destroys commitment rather than raising it.
3. PLACE IT. Set CTA_START = {{DURATION}} - 12s, adjusted to fall AFTER the
   recap sentence and the single takeaway, and immediately before the
   sign-off. Speech duration 3-5s, one sentence, conditional framing:
   "if this helped, let's get it to {{N}} likes."
4. KEEP THE SUBSCRIBE ASK SEPARATE and adjacent - one short conditional
   subscribe line, then the like goal, then the sign-off. Do not stack a
   third ask.
5. BUILD THE GRAPHIC: a chip or lockup showing the numeral and a like glyph,
   entering with a 0.4s power3.out fade-and-rise (y: 24 -> 0, opacity
   0 -> 1) and holding for 2.5s. Type at video sizes, not web sizes:
   >= 60px for a headline figure full-screen, >= 90px if the video will be
   viewed in-feed. Land the animation's end state at least 0.05s BEFORE the
   clip's data-duration or its final frame never renders.
6. MUSIC: keep the outro bed at its normal level under the CTA. Do not drop
   the bed here - a silence is a scarce device and a CTA does not earn one.
7. AFTER the CTA, hand off to the next video rather than trailing off.
8. ACCEPTANCE TEST: (a) the numeral is audible in the VO AND legible on
   screen for at least 60 frames; (b) nothing is offered in exchange for the
   likes anywhere in the video or its description; (c) the CTA sits entirely
   inside the final 8% of runtime and after the payoff; (d) exactly one
   numeric goal exists in the video; (e) a note exists in the project
   recording the number, so the next video can close the loop.
```

## Execution spec

**HyperFrames — the graphic is an ordinary timed clip plus one tween.** There is no CTA primitive; this is a `div` with `data-start` and a GSAP `fromTo` on the composition's single paused timeline, positioned in **absolute composition seconds**.

```html
<div id="cta-like-goal" class="clip"
     data-start="331.00" data-duration="3.00" data-track-index="3"
     style="position:absolute; inset:0; display:flex; align-items:flex-end;
            justify-content:center; padding-bottom:180px; pointer-events:none;">
  <div class="chip" style="display:flex; align-items:center; gap:18px;
       background:#151515; color:#F5F0E0; padding:18px 42px; border-radius:28px;
       font-family:'Montserrat', sans-serif; font-weight:700; font-size:64px;
       letter-spacing:-0.03em; opacity:0;">
    <span aria-hidden="true">&#128077;</span><span>2,000</span>
  </div>
</div>
```
```js
// 12 frames @30fps = 0.4s. Tween the inner .chip, never the clip element.
tl.fromTo("#cta-like-goal .chip",
  { y: 24, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.4, ease: "power3.out" },
  331.00
);
tl.to("#cta-like-goal .chip", { autoAlpha: 0, duration: 0.25, ease: "power2.in" }, 333.70);
```
Contract facts that bind this:
- **`fromTo`, never `from`** — `from()` renders its start state at construction, before the clip's `data-start` is active, and flashes under the render engine's non-linear seek.
- **`y`, not `top`** — `width`/`height`/`top`/`left` tweens are forbidden; spatial motion uses GSAP transform aliases (`x`, `y`, `scale`, `rotation`).
- **No CSS initial `transform` on `.chip`** — a CSS transform plus a GSAP transform tween is `gsap_css_transform_conflict`, an error. The `fromTo` owns `y`.
- **No CSS `transition`** on the element; it interpolates independently of seek and flickers.
- **`power3.out` is the house entrance default**; overshoot (`back`, `elastic`) is *"a rare, explicitly-playful register, never the house style."* Exits are shorter than entrances (0.4 s in, 0.25 s out).
- **Land the end state before `data-duration`** — the clip window is half-open `[start, start + duration)`.
- The clip carries an `id`, avoiding `studio_missing_editable_id`, and `class="clip"`, avoiding `timed_element_missing_clip_class`.
- **Fonts:** the implicit Google Fonts fetch is a network path and is unavailable under this project's egress allowlist. Use one of the pre-bundled families — Montserrat, Oswald, League Gothic, Archivo Black are all safe — or embed a local `@font-face`. **`Inter` is bundled but is on the banned monoculture list.**
- **Type sizes are video sizes:** full-screen viewing wants headlines 60px+; in-feed viewing (X / LinkedIn / Instagram) wants **≥90px** headlines and ≥32px body. Tracking −0.03em to −0.05em at display sizes, because video encoding compresses letter detail.
- If the chip sits low in frame it may collide with the layout audit's `--caption-zone`; the narrow opt-out is `data-layout-allow-caption-zone` on the element (it does **not** suppress overflow or occlusion audits).

**Epidemic Sound:** nothing new for the CTA itself. The outro bed is a normal cue — if the outro is a different mood from the body, the handover is [[sfx-beat-aligned-handover]]. A tiny UI-style tick under the chip entrance is optional and cheap:
```
SearchSoundEffects { query.term: "ui pop soft click interface", filter.duration { max: 1500 } }
```
Place it in the `sfx` group, peak aligned to the entrance frame, never in the `voiceover` carve group.

**ffmpeg:** not involved — this is composition-layer work. Only relevant if the outro card is being burned into a flat deliverable, in which case it is an overlay filter, not an edit.

**Remotion:** a `<Sequence>` with a spring or `interpolate`-driven opacity/translate. Not part of this project.

## Pairs with
- [[struct-closing-recap-single-cta]] — the outro this slots into, and the recap that must precede it
- [[struct-cta-after-payoff]] — the general rule: never ask before you have delivered
- [[struct-end-screen-handoff]] — what follows the ask
- [[struct-comment-prompt-curiosity-gap]] — the comment-side sibling; do not run both plus a subscribe ask
- [[motion-list-item-marker-card]] — the graphic vocabulary for the on-screen chip
- [[sfx-silence-as-pattern-interrupt]] — explicitly *not* used here
- [[pace-visual-mush-ceiling]] — the legibility floor the numeral must clear
- [[struct-credibility-anchor]] — the authority framing that makes an ask land at all

## Failure modes
- **Attaching a reward.** "Hit 2,000 likes and I'll release the preset pack" is *offering rewards in exchange for likes* and sits inside YouTube's incentivization-spam prohibition, with monetization suspension and strikes as the enforcement ladder. Ask, never trade.
- **A fantasy number.** A goal far outside the channel's demonstrated range reads as delusional and kills commitment instead of building it — goal-setting only works when the goal is believed attainable.
- **Never closing the loop.** Goals without feedback stop working. If the next video does not mention the result, the audience learns the number was decoration.
- **Stacking asks.** Subscribe + like goal + comment prompt + Patreon in twenty seconds converts none of them. One recap, one takeaway, one or two asks, stop.
- **Putting it before the payoff.** The ask is contingent on delivered value; ahead of the payoff it spends attention that has not been earned ([[struct-cta-after-payoff]]).
- **Spoken number only.** Numerals are poorly retained from speech. Put it on screen for at least 60 frames at a display size.
- **Dropping the music for it.** A silence is a scarce attention device; spending one on housekeeping wastes it and makes the ask feel like the video's climax.
- **Under-sized type.** A 32px numeral is unreadable in-feed. Use ≥60px full-screen, ≥90px if the video will be watched in a feed.
- **Known gap:** nothing in this stack measures CTA performance, and there is no A/B mechanism here. The 1.6× multiplier is derived from goal-setting theory's "difficult but attainable" optimum, not from platform-specific published data on like-goal CTAs, which does not exist in a form worth citing. Treat the number as a starting heuristic and adjust it from your own channel's results.
