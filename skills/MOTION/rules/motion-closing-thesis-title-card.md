---
id: motion-closing-thesis-title-card
title: Stage the closing thesis as a full-screen type card — one line, one swell, then air
skill: motion
type: type-motion
family: outro
tags: [skill/motion, type/type-motion, family/outro, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:07:13"
    quote: "So I read a quote somewhere: \"Where words fail, music speaks.\""
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:07:09"
    quote: "And if you still have the question — why do all this for music, why give music so much time?"
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:07:49"
    quote: "It takes real effort to make a video, so please like, share and subscribe."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://en.wikipedia.org/wiki/Words_per_minute
  - https://en.wikipedia.org/wiki/Music_and_emotion
difficulty: medium
detectable_from: transcript+video
---

# Stage the closing thesis as a full-screen type card — one line, one swell, then air

## What it is
After a video of mechanical points, the last content beat is a single aphoristic line that restates why any of it mattered — the emotional out before the ask ([[struct-thesis-line-payoff]]). This note is the **staging**: what the frame does while that line is delivered. Three stagings exist and only one of them is right for an aphorism. Over B-roll, the line competes with pictures and lands as a caption. On a clean A-roll single, it lands as one more thing the presenter said. As **full-screen type on a near-empty frame, with the music arriving underneath it**, the line stops being speech and becomes the video's title card in the wrong place — which is exactly the effect, because a title card is the one graphic form the viewer already reads as *statement*.

The whole move is three elements on one clock: the **line** (spoken and set), the **swell** (music arriving at its peak under the line), and the **air** (1.5–3 s of nothing before the CTA). Removing any one of them collapses it.

## When to use it
Only at the last content beat, and only when there is a real thesis to state. Triggers:

- The video has delivered a numbered or mechanical list and needs one sentence that says why the list exists.
- The script contains a quotation, an aphorism, or a one-line reframe of the premise.
- The channel's outro is otherwise a hard jump from the last point to "like and subscribe" — this is the beat that stops that jump feeling abrupt.

Do **not** use it for a summary (a recap is a different structure, and it wants a list layout, not a card), for a line longer than about 12 words, or anywhere but the end — a full-screen type card mid-video reads as a chapter heading and resets the viewer's sense of where they are. And do not stack it with a recap *and* an end screen *and* a CTA; the card needs the air after it more than it needs company.

## How to recognise it in a reference video
- **Cut density collapses.** Measure shots per 10 s across the last 90 s: the card sits in a stretch where density falls to **0–1 cuts per 10 s** after a body averaging 4–10. A sustained low-density tail is the single most reliable signal.
- **The frame goes empty.** Type occupying **20–60 % of frame width**, centred or optically centred, on a plate, a heavy blur, a black, or a slow-drifting single. Measure edge density (a Sobel or `signalstats` proxy) — it drops sharply at the card.
- **Word count.** 4–12 words, one or two lines, often with a smaller attribution line at 35–45 % of the main size.
- **The music peaks under it.** Extract the music-only stem or measure short-term loudness: a swell arriving **1.5–2.5 s before** the line and peaking **within ±0.5 s of the line's final word** is the tell. If the music is flat under the card, the staging is incomplete.
- **Reading time is respected.** The card holds at least **1.5× the time needed to read it at 20 characters/second**, and typically 2.5–4.5 s total. A card that cuts before you finish reading is a mistake, not a style.
- **Air after.** Between the card clearing and the first CTA word there are **1.5–3 s** with no speech. Measure the speech gap in the transcript; a CTA that starts under 1 s after the thesis is the common failure.
- **Motion is minimal.** Per-word or per-phrase fade-and-rise, 0.5–0.8 s, gentle ease, plus at most one ambient drift. Kinetic-typography pyrotechnics on a closing aphorism are a genre signal for a different (louder) channel — log which you saw.
- **This is the one place an exit fade is legitimate.** If the card fades out at the end, that is correct; a fade-out anywhere else in the video is not.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `line_length` | 6 words | 4–12 words | Above 12 it is a paragraph and wants a different treatment. |
| `lines` | 1 | 1–2 | Break before a conjunction or preposition, never between an article and its noun. |
| `type_size` | 96 px @1080p | 72–140 px (6.5–13 % of frame height) | Full-screen headline floor is 60 px; **in-feed viewing needs ≥90 px**. |
| `type_weight` | 500–700 | 400–800 | Lighter than an emphasis caption. A thesis is quiet, not loud. |
| `tracking` | −0.03 em | −0.03 to −0.05 em | Video encoding compresses letter detail at display sizes. |
| `line_height` | 1.20 | 1.15–1.35 | Add 0.05–0.1 on dark plates. |
| `attribution_size` | 40 % of main | 35–45 % | Optional. Same colour at 60 % opacity, never a second accent colour. |
| `entrance_per_group` | 0.60 s (18 f) | 0.50–0.80 s (15–24 f) | `power2.out` or `power3.out`. This is the slow band — the closing scene should be the slowest in the video. |
| `group_stagger` | 0.35 s | 0.25–0.50 s | Between phrase groups, not between words. Total stagger across all groups ≤0.5 s if you stagger words instead. |
| `rise_distance` | 16 px | 10–24 px | On `y`. Small: the card should settle, not travel. |
| `hold_duration` | 2.6 s | 1.5× read time, floor 1.6 s, ceiling 5 s | Read time = characters ÷ 20 per second. A 38-character line needs ≥1.9 s of reading, so hold ≥2.9 s. |
| `exit` | fade 0.60 s | 0.40–1.00 s | The **final-scene exception** to the exit-animation ban. `power2.in`. |
| `air_before_cta` | 2.0 s | 1.5–3.0 s | Measured from the card clearing to the first CTA word. Under 1.5 s the ask eats the payoff. |
| `swell_lead` | 2.0 s | 1.5–2.5 s | Music build starts before the line, peaks on its last word. |
| `swell_peak_offset` | 0 s | −0.5 to +0.5 s | Against the final spoken word of the thesis. |
| `bed_level_under_card` | −16 dB | −18 to −12 dB | Louder than the body's −22 dB, because there is no narration left to protect. |
| `ambient_motion` | 1 | 0–1 | Exactly one: a slow plate drift or a 2–4 % scale push over the whole card. |

## Reproduction prompt

```
Stage the closing thesis line {{LINE}} as a full-screen type card at {{T}}
(the composition second where the line's first word is spoken).

LAYOUT: full-frame plate - flat colour, a heavily blurred still from the video
(blur >= 40px), or black. Set {{LINE}} centred, 96px at 1080p (>=90px if the
deliverable is in-feed), weight 500-700, tracking -0.03em, line-height 1.20,
one or two lines, split into 2-3 PHRASE groups. Optional attribution line
below at 40% size, 60% opacity. Nothing else is on screen: no logo, no
subscribe button, no lower third, no captions.

TIMING:
  {{T}} - 2.0s : music swell begins; picture is already on the plate or
                 crossfading to it over 0.8s (blur-crossfade if the outgoing
                 background differs a lot from the plate).
  {{T}}        : phrase group 1 - fromTo({y:16, autoAlpha:0}) ->
                 {y:0, autoAlpha:1}, 0.60s, power2.out.
  {{T}} + 0.35 : phrase group 2, identical tween.
  {{T}} + 0.70 : phrase group 3 if present. Attribution 0.4s later at 0.6
                 opacity.
  peak         : music peaks within +/-0.5s of the LAST SPOKEN WORD of the
                 line. Bed at -16dB - there is no narration left to protect.
  hold         : max(1.6s, 1.5 x (characters / 20 per second)) after the last
                 group has settled. Nothing moves except ONE ambient drift:
                 a 2-4% scale push across the whole card, sine.inOut.
  exit         : fade the card 0.60s, power2.in. This is the final-scene
                 exception - an exit animation is legal here and only here.
  air          : 2.0s (1.5-3.0s) with NO speech before the first CTA word.
                 Let the music resolve or stop cleanly at a waveform peak.

CONSTRAINTS: 4-12 words. No per-letter animation, no bounce, no overshoot
eases, no rotation, no counters. One accent at most. Do not put the CTA, the
end screen, or a subscribe animation on the same frame as the thesis.

ACCEPTANCE TEST: play the last 20 seconds. (1) Read the line aloud at a normal
pace - it must still be on screen when you finish, with margin. (2) Measure
the gap between the card clearing and the first CTA word: 1.5-3.0s of no
speech. (3) Mute it: the card alone must state the video's point to someone
who did not watch it. (4) Watch it with sound only: the music peak must land
on the line, not after it.
```

## Execution spec

**HyperFrames.** The card is a scene — in a modular project, its own sub-composition; in a monolithic one, a `section.clip` at the root.

```html
<section id="thesis" class="clip" data-start="428.0" data-duration="6.4" data-track-index="2">
  <div id="thesis-plate" style="position:absolute; inset:0; background:#0B0B0C;"></div>
  <div id="thesis-type" style="position:absolute; inset:0; display:flex; flex-direction:column;
       justify-content:center; align-items:center; gap:8px;">
    <div class="tg" style="font-size:96px; font-weight:600; letter-spacing:-0.03em; line-height:1.2; color:#F2EFE9;">Where words fail,</div>
    <div class="tg" style="font-size:96px; font-weight:600; letter-spacing:-0.03em; line-height:1.2; color:#F2EFE9;">music speaks.</div>
    <div id="thesis-attr" style="font-size:38px; font-weight:400; color:#F2EFE9; opacity:0;">— attributed to Hans Christian Andersen</div>
  </div>
</section>
```

```js
const T = 428.0;
tl.fromTo("#thesis .tg", { y: 16, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.60, ease: "power2.out", stagger: 0.35 }, T);
tl.to("#thesis-attr", { autoAlpha: 0.6, duration: 0.5, ease: "power2.out" }, T + 1.15);
// exactly one ambient motion, finite, attached to the timeline
tl.to("#thesis-type", { scale: 1.03, duration: 3.6, ease: "sine.inOut" }, T + 1.2);
// final-scene exception: this fade-out is legal
tl.to("#thesis", { autoAlpha: 0, duration: 0.60, ease: "power2.in" }, T + 5.6);
```

Contract points that bind this:
- **Exit animations are banned except on the final scene.** The transition *is* the exit everywhere else; here the fade is explicitly permitted.
- **`autoAlpha` on `#thesis` works only because a scene wrapper carrying `data-start` is the clip** — never tween `display` or raw `visibility` on a clip element. Safer and lint-clean: fade `#thesis-type` and `#thesis-plate` instead of the clip itself, and let the clip window end normally.
- **`fromTo`, never `from`.** `from()` writes its start state at construction, before the clip's `data-start` is active.
- **`stagger: 0.35` on two groups is 0.35 s total** — within the ≤0.5 s arrival budget. Stagger by **importance**, not DOM order, if the groups are not sequential.
- **Land the last tween before `data-duration`.** The window is half-open and the frame at `start + duration` is never rendered.
- **Root `data-duration` is compile-time-locked** and cannot be changed by `--variables` or a script — if the card's length is parameterised, it must live inside a clip's duration, not the root's.
- **Text as a variable:** `data-var-text` binds an element's own text to a declared scalar variable id (children preserved), with the schema declared as `data-composition-variables` on `<html>` — the clean way to make the thesis line swappable per render.
- **Fonts.** Google Fonts is a network path and unavailable under the egress allowlist; use a bundled family (Montserrat, Oswald, League Gothic, Archivo Black are safe, distinctive picks — `Inter` is bundled but on the monoculture list) or a local `@font-face`. **No CDN scripts**: GSAP must load from a local path.
- **No `<br>` in body text**, and transformed elements must be block-level and sized.
- **Contrast is audited.** `check` runs a contrast pass; light type on a blurred still is the case that fails it. Use a plate or a scrim, and if the crop is intentional use `data-layout-bleed`/`data-layout-allow-overflow` knowingly — a lint **error** anywhere in the file switches the layout and contrast audits off entirely and `check` will report `0 sample(s)`, which looks clean and means nothing ran.
- Named rules that may be cited, not quoted: `kinetic-beat-slam` (wrong register here), `gradient-text-sweep`, `discrete-text-sequence`, `3d-text-depth-layers`.

**Epidemic Sound.** The swell is a *recording*, not an SFX: `SearchRecordings { query: { term: "emotional piano strings swell resolve" }, filter: { moods: { matchType: "ANY", values: ["Sentimental", "Hopeful", "Epic"] }, bpm: { min: 60, max: 90 }, vocals: false } }`. Place it so its own arrival lands 2.0 s before `T`, and use `data-media-start` to trim into the track so the swell — not the intro — is what plays. Volume automation, clip-local `t`, with an explicit point at `t: 0` so the lane does not hold a wrong value backwards:

```html
<audio id="thesis-swell" src=".media/audio/bgm/swell.mp3" data-audio-group="music"
  data-start="426.0" data-duration="10" data-media-start="42.5" data-track-index="11"
  data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.35},{&quot;t&quot;:2.0,&quot;v&quot;:0.85},{&quot;t&quot;:6.0,&quot;v&quot;:0.85},{&quot;t&quot;:9.0,&quot;v&quot;:0}]}]}"></audio>
```
Stop the music on a peak in its own waveform rather than mid-phrase ([[sfx-music-rest-windows]]).

**ffmpeg.** Only for the blurred plate, if you want it baked: `ffmpeg -ss <t> -i main.mp4 -frames:v 1 -vf "gblur=sigma=45,eq=brightness=-0.12" plate.png`. And for the final master, the two-pass `loudnorm` measure/apply at `I=-14:TP=-1.5:LRA=11` for socials.

**Remotion.** A `<Composition>` whose `durationInFrames` is the card, with `interpolate()` per phrase group over an 18-frame range and a 10-frame stagger. Frame-native, so these numbers port literally. Not a runtime in this project.

## Pairs with
[[struct-thesis-line-payoff]] · [[struct-cta-after-payoff]] · [[struct-closing-recap-single-cta]] · [[struct-end-screen-handoff]] · [[sfx-music-rest-windows]] · [[sfx-emotion-music-lookup-table]] · [[sub-emphasis-caption-three-words]] · [[motion-white-bloom-through]] · [[struct-credibility-anchor]] · [[cut-fade-bookend]]

## Failure modes
- **CTA on the same breath.** The ask lands inside the payoff and cancels it. Correction: 1.5–3 s of speech-free air, and never put subscribe artwork on the thesis frame.
- **Card too short.** The viewer is still reading when it cuts. Correction: hold ≥1.5× read time at 20 characters/second, floor 1.6 s.
- **Card too long.** Past about 5 s with nothing moving, the viewer leaves before the CTA. Correction: cap at 5 s and let the exit fade start the outro.
- **Too many words.** A 20-word paragraph in 96 px type either shrinks below the readable floor or overflows. Correction: 4–12 words; if the idea will not compress, it is not a thesis line.
- **Over-animated type.** Per-letter kinetic effects, bounce, rotation — the wrong register for a quiet statement, and overshoot families are a rare, explicitly-playful choice, never the house style. Correction: fade and 16 px rise, gentle ease, phrase groups.
- **Music arriving late.** A swell that peaks after the line has finished makes the line sound like a setup for nothing. Correction: peak within ±0.5 s of the last spoken word.
- **Music continuing flat under the card.** No arrival means no payoff. Correction: build 2 s ahead, or drop the bed entirely and let the line land in silence — but choose one.
- **Card over busy B-roll.** The eye goes to the picture and the line becomes a caption. Correction: plate, black, or blur ≥40 px.
- **Thesis card used mid-video.** Reads as a chapter break and resets the viewer's sense of position. Correction: last content beat only.
- **Known gap.** Nothing in this stack measures whether the line *is* a thesis. The selection is editorial and belongs in the design document; this note only guarantees that whatever line you choose is staged so it can land.
