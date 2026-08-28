---
id: struct-credibility-anchor
title: One short credibility beat, placed between the promise and the first lesson
skill: editing
type: structure
family: hook
tags: [skill/editing, type/structure, family/hook, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:42"
    quote: "I'll tell you things you probably won't find anywhere else, because I discovered them myself over six years of video editing experience."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:36"
    quote: "So in this video we're not doing resources — we're going to understand the concept of music."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:47"
    quote: "So let's start with how to select the music."
research_refs:
  - https://www.jamescmccroskey.com/measures/source_credibility.htm
  - https://eric.ed.gov/?id=EJ581437
  - https://www.sciencedirect.com/science/article/pii/S0001691825012090
  - https://prepublish.ai/guides/youtube-retention-guide
  - https://edtecharchives.org/journal/165/3014
difficulty: low
detectable_from: transcript
---

# One short credibility beat, placed between the promise and the first lesson

## What it is
A single sentence — five to ten seconds — that answers "why should I take instruction from you?", placed *after* the video has stated what it will teach and *before* the first lesson begins. The source's version does three jobs in one line: it claims **differentiation** ("things you probably won't find anywhere else"), it names a **quantity of practice** ("six years"), and it asserts **first-hand origin** ("I discovered them myself"). It is not an introduction, not a channel history, and not a résumé; it is a load-bearing structural beat whose only purpose is to license the rules that follow. The communication literature's standard decomposition of credibility — **competence, trustworthiness, goodwill** — is the checklist: the beat should touch at least two of the three, and the goodwill dimension is the one creators most often skip.

## When to use it
Any video whose value depends on the viewer accepting *rules* rather than *facts* — an opinionated method, a set of heuristics, "do it this way". Place it exactly once, immediately before the first teaching beat, in the window **0:25–1:00** of runtime. Skip it when the video's payoff is self-evidencing (a build, a before/after, a demonstration whose result the viewer can see) — there, the demonstration is the credibility and a spoken claim only costs time. Never open with it: the first 15 seconds belong to the promise, because the largest single drop-off in almost every video sits inside the first 30 seconds and an unearned biography is the fastest way to trigger it.

## How to recognise it in a reference video
This is detectable from the transcript alone, which makes it cheap to log across a whole reference channel.

- **Locate the boundary.** Mark two timecodes: the last sentence of the promise (what the video will cover), and the first sentence of teaching. A credibility beat sits between them; anything credibility-shaped *outside* that window is either a cold-open flex or a mid-roll proof block ([[struct-cta-after-payoff]]).
- **Length.** Measure it in seconds and as a share of runtime. The functional band is **5–12 s**, or **under 3% of runtime**. Past ~20 s it stops being an anchor and becomes an introduction.
- **Score the three dimensions** against the sentence: *competence* (years, volume, outcomes, credentials), *trustworthiness* (first-hand origin, admitted limits, "not a resources video"), *goodwill* (an explicit statement that this is for the viewer's benefit). Log which are present. One dimension alone reads as a boast; two reads as an anchor.
- **Falsifiable quantity.** Count numerals. A real anchor carries **at least one** checkable quantity — years, uploads, views, projects, clients. "I've been doing this a long time" is not an anchor.
- **Differentiation claim.** Look for an explicit contrast against the alternatives the viewer could watch instead ("won't find anywhere else", "not even in a paid course", "this isn't a resources video"). Present in almost every strong version.
- **Position relative to the first "how".** The beat should be the last thing before an imperative or a numbered item. If teaching has already started, the anchor arrived late and is doing nothing.
- **Visual and audio signature.** Usually one shot, static or a slight punch-in, often the tightest framing in the opening minute, frequently the only line in the opening with no B-roll over it — the claim is delivered to camera on purpose. Music often dips or drops out under it and returns on the first lesson.
- **Repetition count across the video.** More than one credibility beat, or one that re-states the same claim later, is a signature of a weak middle rather than a strong opening.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `position` | after promise, before lesson 1 | 0:25–1:00 | Structural, not clock-based: the promise must be complete first. |
| `duration` | 8 s (240 f) | 5–12 s | Under 3% of runtime. Above 20 s it becomes an introduction. |
| `dimensions_hit` | 2 | 2–3 | From competence / trustworthiness / goodwill. Three is best; one is a boast. |
| `falsifiable_quantities` | 1 | 1–3 | Years, volume, outcomes. Zero means it is not an anchor. |
| `differentiation_clause` | present | present \| absent | An explicit contrast with what else the viewer could watch. |
| `first_person_origin` | true | — | "I found this myself" is the trustworthiness half; second-hand rules need a citation instead. |
| `occurrences` | 1 | 1 | Once per video. |
| `shot_treatment` | single A-roll shot, punch-in optional | — | No B-roll over the claim; the viewer should be looking at the person making it. |
| `punch_in_scale` | 1.06 | 1.00–1.12 | If used, a static scale for the whole beat, not an animated zoom. |
| `music_action` | dip or stop | dip \| stop \| continue | Dip 4–6 dB under the line and return at the first lesson. |
| `captions` | on the quantity only | — | Burn the number, not the sentence ([[struct-name-define-demonstrate]] for the teaching beats' caption policy). |
| `pct_of_runtime` | 0.015 | ≤0.03 | Acceptance ceiling. |

## Reproduction prompt

```
Insert the credibility anchor.

1. Find the boundary in the transcript: the last sentence that states what
   the video will cover, and the first sentence that teaches something. The
   anchor goes between them. If teaching starts before 0:25, move it later
   rather than compressing the promise.
2. Write ONE sentence, 5-12 seconds when spoken (roughly 18-35 words at a
   normal 165 wpm delivery). It must contain:
   - one falsifiable quantity (years of practice, number of projects,
     measurable outcome). No adjectives standing in for numbers.
   - a first-hand origin claim, OR a named source if the rules are not
     yours.
   - a differentiation clause naming what this is NOT ("not a resources
     video", "not what the tutorials say").
   Optionally add goodwill in the same sentence ("so you don't waste the
   six years I did"). Two of competence / trustworthiness / goodwill is the
   minimum; three is the target.
3. Cut it as a single A-roll shot with no B-roll over it. Optionally apply a
   STATIC punch-in of scale 1.06 for the whole beat - do not animate a zoom
   during the line.
4. Dip the music bed 4-6 dB across the beat and return it to level on the
   first frame of the first lesson.
5. Cut hard out of the beat straight into lesson one. No transition, no
   whoosh - the anchor should feel like the video getting on with it.
6. ACCEPTANCE TEST: (a) duration 5-12s and under 3% of runtime; (b) at least
   one numeral present; (c) at least two of the three credibility dimensions
   scored present by reading the sentence back; (d) removing the beat leaves
   the promise and lesson one still adjacent and coherent - if removing it
   breaks the video, it is carrying content and is not an anchor; (e) the
   beat appears exactly once in the whole video.
```

## Execution spec

**HyperFrames (assembly).** A single clip, a static transform, and one automation lane. All times in **seconds**; frames are a comment.

```html
<!-- credibility anchor: 42.00-50.00s (8.00s = 240f @30fps) -->
<video id="cred-anchor" src="aroll.mp4" muted playsinline class="clip"
       style="transform: scale(1.06); transform-origin: 50% 42%;"
       data-start="42.00" data-duration="8.00" data-media-start="611.40" data-track-index="0"></video>
<audio id="cred-anchor-aud" src="aroll.mp4" data-audio-group="voiceover"
       data-start="42.00" data-duration="8.00" data-media-start="611.40" data-track-index="10"></audio>
```
The punch-in is **static**, so it belongs in inline CSS — and because it does, there must be no GSAP tween on `scale` for this element or lint raises `gsap_css_transform_conflict` (a hard error, which also switches off the layout and contrast audits so `check` reports a meaningless clean pass). If the shot needs to move at all, drop the CSS and do everything in GSAP with `tl.set(...)` using `scale` / `x` / `y`, never `width`/`top`/`left`.

The music dip is a `volume` automation lane on the **bed**, in **clip-local** seconds — for a bed starting at 6.00 s, the 42.00–50.00 s dip is `t` 36.0–44.0, and the lane needs an explicit `{t:0}` point because a lane holds its first value backwards to the clip start:

```html
<audio id="bed" src="assets/bgm/bed.mp3" data-audio-group="music"
       data-start="6" data-duration="600" data-track-index="11" data-volume="0.55"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:35.7,&quot;v&quot;:1},{&quot;t&quot;:36.0,&quot;v&quot;:0.55},{&quot;t&quot;:43.7,&quot;v&quot;:0.55},{&quot;t&quot;:44.0,&quot;v&quot;:1}]}]}"></audio>
```
`v` is 0..1 volume, so 0.55 of the baseline is roughly −5 dB. Do not also GSAP-tween `volume` on this track — the lane wins and the tween is silently ignored (`audio_volume_double_automation`). If the bed is carved against the voice group, the carve writes its own gain stage; check what is already there before adding a second level move.

If the falsifiable number is burned on screen, animate the number only — a `counting-dynamic-scale`-style count-up on the digits, entrance `power3.out`, 0.4 s, landing **before** the clip's `data-duration` (the window is half-open, so an animation resolving exactly on the boundary never renders its final frame). Keep the total arrival inside the stagger cap (`items × stagger ≤ ~0.5 s`).

**ffmpeg (locating the beat in the raw take).** Find the sentence in the transcript, then verify the take:
```bash
node <SKILL_DIR>/scripts/transcript-cut.mjs --input aroll.mp4 \
  --transcript aroll.transcribe.json --keep "611.4-619.4" --out anchor.mp4
ffprobe -v error -show_entries format=duration -of csv=p=0 anchor.mp4
```

**Epidemic Sound:** nothing to fetch — this beat is a level move on an existing bed.

**Remotion:** a `<Sequence>` with a static transform; concept only, no Remotion runtime in this project.

## Pairs with
[[struct-demand-hook-competence-gap]] · [[struct-enumerated-promise-and-counter]] · [[struct-outcome-first-cold-open]] · [[struct-cta-after-payoff]] · [[cut-punch-in-emphasis]] · [[struct-name-define-demonstrate]] · [[struct-inverse-pair-teaching]] · [[struct-analytics-screenshot-proof]] · [[struct-comment-screenshot-cold-open]]

## Failure modes
- **Opening with it.** Credibility before a promise is a biography, and the first 30 seconds is where the largest single drop-off already lives. Fix: promise first, anchor second, never the reverse.
- **Running long.** A 45-second origin story is the most common version of this failure and it costs the video its opening minute. Fix: 12-second hard ceiling; move anything else into the mid-roll proof block, where numbers actually convert.
- **No falsifiable quantity.** "Years of experience" without a number is indistinguishable from every other channel's claim. Fix: state the number, even if it is small; a specific two years beats a vague decade.
- **Competence only.** Three impressive facts and no goodwill reads as a flex, and the viewer's reaction to a flex is to test the first rule rather than apply it. Fix: add a clause about what the viewer gets from it.
- **B-roll over the claim.** Cutting away during the anchor undercuts it — the viewer needs the face. Fix: single A-roll shot, no overlay.
- **Repeating it.** A second anchor later reads as insecurity about the middle. Fix: fix the middle.
- **Animating the punch-in during the line.** A zoom mid-sentence pulls attention to the edit at the moment attention should be on the claim. Fix: static scale for the whole beat.
- **Known gap:** the three-dimension model (competence, trustworthiness, goodwill) is well established as a *measurement* instrument for perceived source credibility, and instructor-credibility research links it to student engagement — but no study places a credibility statement at a timecode in a video and measures retention. The 5–12 s window and the "after the promise" position are craft rules derived from the source video and from general first-30-seconds retention guidance. Treat them as priors, and if the channel has retention graphs, check the curve across this beat before defending the number.
