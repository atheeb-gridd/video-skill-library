---
id: struct-handbook-reframe
title: The category reframe — "this isn't X, it's the layer above X"
skill: editing
type: retention
family: hook
tags: [skill/editing, type/retention, family/hook, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:02:18
    quote: "This video isn't a pile of tutorials."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:02:20
    quote: "It's a handbook for addictive editing."
  - video: assets/videos/editing kt.mp4
    timestamp: 00:02:23
    quote: "Think of it as the foundation that tells you which tutorials are even worth watching."
research_refs:
  - https://www.retentionrabbit.com/blog/2025-youtube-audience-retention-benchmark-report
  - https://backlinko.com/hub/youtube/retention
  - https://georgeblackman.substack.com/p/retention-review-4-second-payoff
  - https://prepublish.ai/guides/first-30-seconds
difficulty: low
detectable_from: transcript
---

# The category reframe — "this isn't X, it's the layer above X"

## What it is
A three-clause beat placed at the end of the intro that changes what category the viewer thinks they are watching. Clause one **denies the obvious category** ("this video isn't a pile of tutorials"), clause two **asserts a higher one** ("it's a handbook for addictive editing"), clause three **states the relationship** ("the foundation that tells you which tutorials are even worth watching"). It is not a hook and it is not a roadmap — it is a *price justification*. It answers the exit thought "I could just search for a tutorial on the specific thing I want" before the viewer has it, by asserting that the specific thing is downstream of this video. In the source it runs **00:02:18 → 00:02:29, eleven seconds**, and the first content section starts one second later at 00:02:30, at 15.8% of a 14:32 runtime.

## When to use it
On long-form (8 minutes plus) where the runtime itself is the objection, and specifically where a cheaper substitute for your video obviously exists — a tutorial, a doc page, a shorter video, a thread. It is also the correct beat when the video is *conceptual* and the audience arrived expecting *procedural*: the reframe is what stops them bouncing at minute two when no steps have appeared. Do not use it on a video that genuinely is the tutorial; the denial then reads as a dodge, and the audience will notice by the halfway mark. Do not use it as the opening line either — it lands only after a hook has earned the right to make a claim about the category.

## How to recognise it in a reference video
- **Transcript pattern, and it is nearly always literal:** a negation of a category noun followed by an assertion of another. Regex over the cleaned transcript:
  `grep -nEi "(this|it) (video )?(is ?n'?t|is not|won'?t be) (a |just |another )?[a-z ]+\.? (it'?s|this is) " transcript.md`
  Also catch the softer form: "think of it as…", "this is less a … than a …", "we're not doing X, we're doing Y".
- **Position.** In matched examples the beat sits **at the end of the intro, immediately before the first content section** — measure the gap between the reframe's last word and the first content beat; it should be **under 20 seconds**. In the source it is 1 second.
- **Absolute timing.** Between **60 and 180 seconds** in, or roughly **10–20% of runtime**, whichever is earlier. Later than 20% and it is arriving after the audience it was meant to keep has already gone: **about 55% of viewers are lost by the 60-second mark**, and fewer than 45% pass one minute regardless of length.
- **Length.** 8–15 seconds, 25–45 words. Longer means it has turned into a table of contents, which is a different (weaker) device.
- **Three clauses, in order.** Deny → assert → relate. A version with only the first two clauses is common and measurably weaker, because the viewer is told what the video is *not* without being told what to do with the thing it replaced.
- **Visual support.** Expect a full-frame type card or a two-state graphic on the assertion clause, holding **1.5–3 s**, and often the music dropping out or thinning underneath so the line lands dry. Check the audio track for a level dip at the reframe's first word.
- **Distinguish from a roadmap.** A roadmap enumerates sections ("first we'll cover…"); a reframe makes no promises about content at all. They can co-occur, with the reframe first.
- **Corroboration downstream.** A real reframe is *cashed*: later in the video the higher category is referenced again ("this is why pillar three matters more than any tutorial"). If it is never referenced again, it was a line, not a structure.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `position_abs` | 110 s | 60–180 s | Absolute placement from video start. |
| `position_pct` | 15% | 8–20% of runtime | Use whichever of the two comes first. |
| `gap_to_first_content` | 1.5 s | 0–20 s | The reframe must butt against the body, not float in the intro. |
| `duration` | 11 s | 8–15 s | 25–45 spoken words. |
| `clause_count` | 3 | 2–3 | Deny / assert / relate. Two is the degraded form. |
| `card_hold` | 2.2 s | 1.5–3.0 s | On-screen type card under the assertion clause. |
| `card_in` | 0.40 s (12 f) | 0.30–0.50 s | `power3.out`. |
| `card_out` | 0.25 s (7 f) | 0.20–0.35 s | Exits are shorter than entrances. |
| `music_dip` | −8 dB | −6 to −12 dB | Under the assertion clause; back up on the relate clause. |
| `music_dip_ramp` | 0.20 s | 0.15–0.35 s | Fast enough to feel deliberate. |
| `callback_count` | 1 | 1–3 | Times the higher category is re-invoked later in the body. |

## Reproduction prompt

```
Write and place a category reframe at the end of the intro.

1. Identify the CHEAP SUBSTITUTE the viewer could leave for: the tutorial, the
   doc, the shorter video, the thread. Name it in one noun phrase. If no cheap
   substitute exists, skip this technique entirely - the reframe has nothing to
   push against and will read as filler.

2. Write exactly three clauses, 25-45 words total:
     DENY:   "This isn't <CHEAP SUBSTITUTE, plural or dismissive>."
     ASSERT: "It's <HIGHER CATEGORY: a handbook / a system / the reasoning>."
     RELATE: "<How the higher category governs the cheap one>" - e.g. "the
             foundation that tells you which <substitutes> are even worth
             <consuming>."
   The RELATE clause is not optional. Without it the viewer knows what they
   are not getting and does not know what to do with what they wanted.

3. Place it so its last word ends 0-20 seconds before the first content beat,
   and so it starts between 60s and 180s (or 8-20% of runtime, whichever is
   sooner). If your intro cannot reach the first content beat by 20% of
   runtime, cut the intro, not the reframe.

4. Support the ASSERT clause on screen: one full-frame or lower-third type
   card carrying the HIGHER CATEGORY as 3-6 words, in at {{IN}} with a 0.40s
   power3.out, hold 2.2s, out over 0.25s. Nothing else animates during the
   card. Keep it inside 90% title safe.

5. Duck the music bed by 8 dB across the ASSERT clause with a 0.20s ramp, and
   restore it on the first word of RELATE. Do not stop the music entirely -
   that is reserved for a heavier beat.

6. Cash it later: at least once in the body, refer back to the higher category
   by the same words used in ASSERT.

ACCEPTANCE TEST: (a) read only the three clauses aloud, cold - a stranger must
be able to say what the video is instead of what it is not; (b) the last word
of RELATE is within 20 seconds of the first content beat, frame-checked;
(c) the ASSERT card holds >=1.5s and lands inside title safe; (d) search the
transcript for the HIGHER CATEGORY noun - it must appear at least twice more
after the reframe, or the reframe was decoration.
```

## Execution spec

**Hyperframes.** The reframe is a two-track moment: an A-roll clip that keeps running, one type card above it, and a dip in the bed. Author the card as its own timed clip on track 1+ and the dip as a `volume` automation lane on the bed.

```html
<!-- A-roll continues underneath; the card is an overlay clip -->
<div id="card-reframe" class="clip" data-start="110.2" data-duration="2.9" data-track-index="2"
     style="position:absolute; inset:0; display:flex; align-items:flex-end; justify-content:center; padding-bottom:210px;">
  <div id="card-reframe-inner"
       style="font-family:'Archivo Black', sans-serif; font-size:72px; letter-spacing:-0.04em;
              color:#fff; text-shadow:0 6px 28px rgba(0,0,0,.55); text-align:center; max-width:1500px;">
    A handbook for addictive editing
  </div>
</div>
```

```js
const T = 110.2;
tl.fromTo("#card-reframe-inner",
  { y: 26, autoAlpha: 0 },
  { y: 0, autoAlpha: 1, duration: 0.40, ease: "power3.out" }, T);
tl.to("#card-reframe-inner",
  { autoAlpha: 0, duration: 0.25, ease: "power2.in" }, T + 2.55);   // lands before data-duration
```

Contract points that bind this:
- `fromTo`, never `from` — `gsap.from()` sets `immediateRender: true` and writes its start state at construction time, before the clip is active; under the render's non-linear seek the card flashes or skips its entrance.
- `autoAlpha` goes on the **inner** element, not on the `.clip` — the framework owns clip visibility and tweening `display`/`visibility` on a clip is rejected.
- Land the exit **before** `data-duration`: the window is `[start, start+duration)` and the final frame is never rendered.
- `data-duration` is **required** on a `div` clip.
- Type size: 72 px sits in the full-screen headline band (headlines 60 px+); for an in-feed cut push to ≥90 px. Tracking −0.03 to −0.05 em at display sizes, because video encoding compresses letter detail.
- **Do not use `Inter`** — it is bundled but on the banned monoculture list. Safe bundled picks: Archivo Black, Oswald, League Gothic, Montserrat.
- Fonts must come from the bundled set or a local `@font-face`; the implicit Google Fonts build-time fetch is a network path and the egress allowlist blocks CDNs. Any `<script>` for GSAP must be a **local** relative path, never `cdn.jsdelivr.net`.
- Padding-bottom flex anchoring (as in the staged captions composition) is the house way to place lower-frame type; keep it inside 90% title safe.

**The music dip** — a `volume` lane on the bed, `t` in **clip-local** seconds, with an explicit `t:0` point because a lane holds its first value backwards to the clip start:

```html
<audio id="music-bed" src="assets/bgm/bed.mp3" data-audio-group="music"
       data-start="0" data-duration="880" data-track-index="11" data-volume="0.6"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:110.0,&quot;v&quot;:1},{&quot;t&quot;:110.2,&quot;v&quot;:0.4},{&quot;t&quot;:113.0,&quot;v&quot;:0.4},{&quot;t&quot;:113.3,&quot;v&quot;:1}]}]}"></audio>
```
`0.4` ≈ −8 dB. Do not also GSAP-tween `volume` on this element — the lane wins and the tween is silently ignored. If narration runs under the bed for the whole video, the *general* answer is a carve against the `voiceover` group rather than a duck; this dip is a **design gesture** on top of it, which is exactly the case the contract says a volume lane is for.

**ffmpeg.** Only relevant if you are locating the beat in a reference: extract the intro's audio and find the dip.
```bash
ffmpeg -ss 90 -t 60 -i ref.mp4 -af "astats=metadata=1:reset=15,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
```

**Epidemic Sound:** nothing new is fetched for this beat — it reuses the bed. If the card wants an accent, one soft aesthetic riser is wrong here (nothing is being revealed); use a low-level texture or nothing at all.

**Remotion:** a `<Sequence>` with an interpolated opacity/`translateY` on a text layer; concept only.

## Pairs with
[[struct-enumerated-promise-and-counter]] · [[struct-outcome-first-cold-open]] · [[struct-demand-hook-competence-gap]] · [[struct-scope-refusal-deflection]] · [[pace-cut-density-from-viewer-intent]] · [[struct-stimulation-budget]] · [[motion-list-item-marker-card]]

## Failure modes
- **Reframe without a body that earns it.** If the video then delivers exactly the tutorials it denied, the audience registers the reframe as a lie and the channel pays for it beyond this video. Correction: only claim the higher category if the body is structured around principles rather than steps.
- **Placed too late.** At minute five it is addressed to an audience that already left. Correction: 8–20% of runtime, hard ceiling 180 s.
- **Two clauses only.** "This isn't a tutorial video" with no relate clause leaves the viewer's original need unaddressed. Correction: always state how the higher category governs the thing they came for.
- **Reframe expanded into a roadmap.** Once it lists sections it stops being a reframe and starts being a table of contents, which viewers skip. Correction: 45 words maximum, no enumeration.
- **Card over-animated.** A reframe is a claim, not a spectacle; a bouncing card undercuts the authority. Correction: `power3.out`, one property pair (`y` + `autoAlpha`), nothing else moving.
- **Never cashed.** Correction: at least one callback in the body, using the same noun.
- **Known gap:** no controlled study isolates the effect of a *category reframe* specifically. The supporting numbers here are platform retention benchmarks (first-minute loss, value-proposition retention lift) and are directional evidence for the placement rule, not a measurement of this device.
