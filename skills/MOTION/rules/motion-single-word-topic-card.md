---
id: motion-single-word-topic-card
title: The one-word topic card — land the subject as a single word on its own beat
skill: motion
type: type-motion
family: title-card
tags: [skill/motion, type/type-motion, family/title-card, engine/hyperframes, engine/epidemic, engine/ffmpeg, engine/remotion, sfx/aesthetic, layer/sfx, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:06"
    quote: "Music."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:02"
    quote: "And why wouldn't it be — in this video we're talking about the one thing that 90% of people can't get right."
research_refs:
  - https://gsap.com/docs/v3/Eases/
  - https://developer.mozilla.org/en-US/docs/Web/CSS/clip-path
  - https://en.wikipedia.org/wiki/Dissolve_(filmmaking)
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
difficulty: medium
detectable_from: transcript+video
---

# The one-word topic card — land the subject as a single word on its own beat

## What it is
The hook builds a gap — *"the one thing that 90% of people can't get right"* — and then the topic arrives as **one isolated word**, spoken alone and printed alone, with a beat of silence on either side. It is a payoff device, not a title: the word carries no information the sentence before it did not promise, and all of its force comes from the withholding. Three things have to happen simultaneously for it to work: the **speech** delivers the word in isolation, the **picture** commits the whole frame to it, and the **sound** punctuates it.

The failure mode is treating it as a lower third. A lower third annotates the speaker; this replaces them. If the presenter is still on screen at the same size, the word is decoration and the beat is spent for nothing.

## When to use it
- **Directly after a curiosity-gap hook** that names a thing without naming it: "the one thing", "the mistake everyone makes", "there's a reason for this". The gap is what the word closes ([[struct-demand-hook-competence-gap]], [[struct-comment-prompt-curiosity-gap]]).
- **At a section boundary in a numbered video** — the topic of section 4 arriving as one word.
- **On a thesis line's payoff** — the single word the whole argument has been circling ([[struct-thesis-line-payoff]]).
- **Once, or at most twice, per video.** It is a maximum-emphasis device; the third one is worth nothing.
- **Only when the script actually delivers the word alone.** If the narration says "…is music, and music is something people underestimate", there is no isolated beat to card. Rewrite the line or drop the device — you cannot card a word that arrives mid-sentence.
- **Not** for a word the audience already expects. If the title of the video is "How to choose music", carding MUSIC is a shrug. It works when the promise is abstract and the word is the resolution.

## How to recognise it in a reference video
- **Transcript first, and it is decisive.** Look for a **one- or two-word utterance isolated by pauses of ≥0.3 s on both sides**, immediately following a sentence that promises a topic without naming it. Word-level timestamps make this a mechanical query: `word.start − previous_word.end ≥ 0.30` and `next_word.start − word.end ≥ 0.30`, with the utterance being a single token.
- **The frame commits.** The word occupies **55–80% of frame width** as a single line, with everything else either gone (a plate) or pushed down to ≤35% brightness. If the presenter is still full-size and unchanged, log it as an emphasis caption, not a topic card ([[sub-emphasis-caption-three-words]]).
- **Entry is fast and settles.** 6–11 frames (0.2–0.35 s) from first appearance to settled, front-loaded deltas (an out-ease), commonly with a scale-down from ~1.06–1.10 and/or a blur resolving from 8–16 px. A slow fade-in is a different, softer device.
- **Hold 24–45 frames** (0.8–1.5 s) at rest. Below ~20 frames the word does not get its beat; above ~60 the video stalls.
- **Exit is shorter than entry** — often a hard cut, sometimes a 5–8 frame fade. Entrances need longer than exits.
- **Audio, three checks:** (1) an **impact or hit transient within ±1 frame of the spoken word's onset**; (2) frequently a **riser** running 0.8–2.0 s *before* it, resolving exactly on that frame; (3) **the music bed drops out or ducks hard** across the beat. Any two of the three is a confident identification.
- **Silence before.** Measure the gap. Professional versions leave 0.3–0.8 s of near-silence before the word — the pause *is* the anticipation.
- **Typography.** Heavy weight (700–900), tight tracking, usually uppercase, usually a single colour with no gradient. Log the family, the case and the weight into the style profile; this is one of the most identity-carrying frames in the whole video.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `word_count` | 1 | 1–2 | Three words is a title, not a card. |
| `case` | uppercase | upper \| title | Uppercase reads as a card; sentence case reads as a caption. |
| `width_fraction` | 0.68 of frame width | 0.55–0.80 | Set the font size to hit this, do not pick a size and hope. |
| `font_size` | ~200 px @1080p | 140–320 px | Derived from `width_fraction` and the word's length. Video type sizes, not web sizes: headlines 60 px+ full-screen, ≥90 px in-feed. |
| `weight` | 800 | 700–900 | |
| `tracking` | −0.04 em | −0.03 … −0.05 em | Display sizes need negative tracking because *video encoding compresses letter detail*. |
| `font_family` | Archivo Black / League Gothic / Oswald | any bundled family | Bundled and distinctive. **Avoid Inter** — bundled, but on the banned monoculture list. No Google Fonts fetch: the egress allowlist makes it fail-closed. |
| `plate` | full-frame, `#000` at 0.82 | 0.6–1.0 | Or cut to a dedicated black scene. A word over unmodified A-roll is the weak version. |
| `entry_duration` | 0.28 s (8–9 f) | 0.2–0.35 s | The "fast — energy, urgency, confidence" band. |
| `entry_scale` | 1.08 → 1.00 | 1.04–1.12 → 1.00 | Scale **down** into rest. Scaling up from small reads as a pop, which is a different register. |
| `entry_blur` | 14 px → 0 | 8–18 px → 0 | Optional but strong; it makes the word feel like it resolves into focus. |
| `entry_ease` | `power4.out` | `power4.out` \| `expo.out` | The punch end of the smooth families. **Never** `back`/`elastic` — overshoot on a single heavy word reads as cheap. |
| `opacity_ease` | `power2.out` | — | On its own tween at the same position; keep aggressive curves off opacity. |
| `hold` | 1.15 s (34 f) | 0.8–1.5 s | At rest, after settle, before exit begins. |
| `word_lead` | 0 f | −1 … +1 f | The card lands **on** the spoken word's onset. AV-sync detectability is about +45 ms early / −125 ms late, so 1 frame either way is safe; early is riskier than late. |
| `pre_silence` | 0.5 s | 0.3–0.8 s | Gap before the word in the narration. |
| `exit` | hard cut | hard cut \| 0.17–0.27 s fade | Exits are shorter than entrances (0.4 in / 0.25 out is the house ratio). |
| `impact_level` | −13 dB | −12 … −15 dB | Against dialogue at 0 to −3 dB. |
| `riser_length` | 1.2 s | 0.8–2.0 s | Optional. Must **resolve on** the impact frame, not near it. |
| `music_action` | duck to 0.15 or stop | — | Kill or drop the bed across the beat so focus goes to the voice. |

## Reproduction prompt

```
Build a one-word topic card for the word {{WORD}}, whose spoken onset in the
transcript is {{WORD_T}} and whose end is {{WORD_END}}.

0. GATE. Confirm from word-level timestamps that {{WORD}} is delivered ALONE:
   at least 0.30s of silence before its onset and 0.30s after its end. If it
   is not isolated in the narration, do not build this - it becomes an
   emphasis caption instead.

1. PLATE. At {{WORD_T}} - 0.28, bring in a full-frame black plate at 0.82
   opacity over the running picture (duration 0.28, ease power2.out), or cut
   to a dedicated black scene. The presenter must not remain at full
   brightness behind the word.

2. TYPE. One text element, uppercase, weight 800, tracking -0.04em, in a
   BUNDLED font family - Archivo Black, League Gothic, Oswald or Montserrat.
   Do not use Inter (banned monoculture) and do not @import from Google Fonts
   (the egress allowlist blocks it). Size the word so its rendered width is
   0.68 of frame width; compute the size from the measured glyph advance at
   authoring time, do not measure at tween time. No <br>.

3. ENTRY, positioned exactly at {{WORD_T}}:
     fromTo(word, { scale: 1.08, filter: "blur(14px)", autoAlpha: 0 },
                  { scale: 1.00, filter: "blur(0px)", autoAlpha: 1,
                    duration: 0.28, ease: "power4.out" })
   Split opacity onto its own power2.out tween at the same position.

4. HOLD 1.15s at rest, then exit: either a hard cut (preferred - the plate and
   the word both end with the clip) or a 0.20s fade out on power2.in.
   Total on-screen = 0.28 + 1.15 + exit.

5. SOUND, three parts:
     a. IMPACT on the frame of {{WORD_T}}. Trim the file so its loudest sample
        - not its first sample - lands there. -13 dB.
     b. Optional RISER of 1.2s ending exactly at {{WORD_T}}, so its peak
        resolves into the impact rather than overlapping it. Only use a riser
        if this really is the video's biggest beat; a riser that precedes
        nothing important spends its credibility.
     c. MUSIC: duck the bed to 0.15 from {{WORD_T}} - 0.5, or stop it at a
        peak in its own waveform just before the pause. Restore after the card
        exits.

6. Do NOT let the card outlast its beat. If the narration has moved on, the
   card is late; cut it.

ACCEPTANCE TEST:
(1) Step {{WORD_T}}-3f .. {{WORD_T}}+6f: the word must be fully legible by
{{WORD_T}}+9f and must not be legible before {{WORD_T}}-1f.
(2) Play the beat with the picture muted: the pause, the word and the impact
must feel like one event.
(3) Play it with the sound muted: the frame must contain nothing but the word
and a darkened field.
(4) Measure the rendered word width - it must fall between 55% and 80% of
frame width, on one line, with no clipping at either edge.
(5) Confirm the impact transient sits within one frame of {{WORD_T}}.
```

## Execution spec

**HyperFrames.** A short sub-composition or an inline clip; either way, the timing lives on one element and the motion on the timeline.

```html
<section id="card-topic" class="clip" data-start="6.10" data-duration="2.00" data-track-index="3">
  <div id="card-plate" style="position:absolute; inset:0; background:#000; opacity:0;"></div>
  <div id="card-word"
       style="position:absolute; inset:0; display:flex; align-items:center; justify-content:center;
              font-family:'Archivo Black', sans-serif; font-weight:800; font-size:200px;
              letter-spacing:-0.04em; color:#F5F0E0; text-transform:uppercase; opacity:0;">MUSIC</div>
</section>
```

```js
const T = 6.38;                                   // the spoken word's onset, from transcript.json
tl.to("#card-plate", { opacity: 0.82, duration: 0.28, ease: "power2.out" }, T - 0.28);
tl.fromTo("#card-word",
  { scale: 1.08, filter: "blur(14px)" },
  { scale: 1.00, filter: "blur(0px)", duration: 0.28, ease: "power4.out" }, T);
tl.to("#card-word", { autoAlpha: 1, duration: 0.20, ease: "power2.out" }, T);
tl.to("#card-word", { autoAlpha: 0, duration: 0.20, ease: "power2.in" }, T + 1.43);
tl.to("#card-plate", { opacity: 0,   duration: 0.20, ease: "power2.in" }, T + 1.43);
```

Contract points that bind this:
- **`fromTo`, never `from`** — `from()` renders its start state at construction, before the clip's `data-start` is live, and the render engine's non-linear seek makes it flash or skip.
- **`autoAlpha` only on non-clip elements.** `#card-word` and `#card-plate` are children of the clip, so this is legal; on `#card-topic` itself it is rejected because the framework owns clip visibility.
- **No CSS `transform` on `#card-word`.** `letter-spacing`, `font-size`, `color` are fine; a `transform` alongside the GSAP `scale` tween is `gsap_css_transform_conflict` (error), and a lint error switches off the layout and contrast audits entirely.
- **`filter` is lint-clean on the master timeline.** The blur resolve is legal there.
- **No `<br>` in body text** — a determinism/typography ban. A one-word card never needs one.
- **Land the end state before `data-duration`.** The window is half-open, so **check your arithmetic against the clip length**: in the example the entry lands at 6.66, the hold runs to 7.81, the exit finishes at 8.01, and the clip is authored `6.10 → 8.10` to leave 0.09s of margin. Off-by-one here means the last frame never renders.
- **Fonts:** 18 families are pre-bundled. `Inter` is bundled but on the banned monoculture list; safe distinctive picks include Montserrat, Oswald, League Gothic, Archivo Black, Space Mono, IBM Plex Mono, JetBrains Mono, Source Code Pro, Noto Sans JP. **Do not `@import` from Google Fonts** — that is a network path and is fail-closed under the egress allowlist. Building inside `document.fonts.ready` is supported and is the right place to register the timeline.
- **Contrast audit.** A `check` run measures text contrast; light type on an 0.82 black plate over unknown footage will pass, type over an un-plated shot may not. Do not silence it with `data-layout-allow-overflow` — that inherits down the whole subtree and also suppresses `text-clipping` and `content-cramped-container`.
- **Type sizing is authored, not measured.** Never derive the font size from `getBoundingClientRect()` at tween time; compute it once at composition setup, or pin it as a constant and verify with `snapshot`.
- **Related rule names** in the animation library: `kinetic-beat-slam`, `discrete-text-sequence`, `chromatic-glitch`. Those recipe files are not staged — cite them, do not quote code.

**Epidemic Sound.** Two fetches, both real tag namespaces:

```
# the impact
SearchSoundEffects { query: { term: "cinematic impact hit deep short" },
                     filter: { tagSlugs: { matchType: "ANY", values: ["designed--boom", "designed--braam"] },
                               duration: { max: 5000 } } }
# the optional riser, resolving into it
SearchSoundEffects { query: { term: "riser build tension short" },
                     filter: { tagSlugs: { matchType: "ANY", values: ["designed--riser"] },
                               duration: { min: 800, max: 3000 } } }
```
Typical returns: braams and booms run 2.8–8.5 s with most of that being tail; risers run 5–15 s and need trimming from the **tail end** so their resolution lands on `T`. Place with `data-media-start` so the transient, not the file head, hits the frame:

```html
<audio id="sfx-card-impact" src="assets/sfx/impact.wav" data-audio-group="sfx"
       data-start="6.30" data-duration="2.4" data-media-start="0.08"
       data-track-index="12" data-volume="0.45"></audio>
<audio id="sfx-card-riser" src="assets/sfx/riser.wav" data-audio-group="sfx"
       data-start="5.18" data-duration="1.20" data-media-start="6.40"
       data-track-index="13" data-volume="0.30"></audio>
```
The riser's `data-media-start` is deep into the file precisely so that its own climax coincides with `data-start + data-duration` = `T`. Give SFX their own group, never the `voiceover` group used for carve.

**ffmpeg.** Measure the file's transient offset so the alignment is not guesswork:
```bash
ffmpeg -i impact.wav -af "silencedetect=noise=-45dB:d=0.02" -f null - 2>&1 | grep silence_end
```

**Remotion.** `spring()`/`interpolate` on `scale`, `opacity` and a `filter: blur()` string, with the card as its own `<Sequence>` — concept only.

## Pairs with
[[motion-anticipation-build-to-reveal]] · [[sfx-riser-anticipation-build]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-music-hard-stop]] · [[sfx-silence-as-pattern-interrupt]] · [[motion-impact-frame-quantisation]] · [[sub-emphasis-caption-three-words]] · [[struct-demand-hook-competence-gap]] · [[struct-thesis-line-payoff]] · [[motion-closing-thesis-title-card]] · [[sfx-synthetic-family-catalogue]] · [[motion-abstract-concept-card]] · [[motion-type-treatment-matches-content]]

## Failure modes
- **No isolation in the narration.** Carding a word that arrives mid-sentence gives the picture a beat the audio does not have, and the card looks pasted on. Correction: check the word-level timestamps for ≥0.3 s of silence either side before building.
- **Presenter left at full brightness.** The word becomes an overlay on a talking head and the beat evaporates. Correction: plate to ≥0.6 opacity, or cut to a dedicated frame.
- **Overshoot ease.** `back.out` on a 200 px word wobbles like a toy. Correction: `power4.out` or `expo.out`, and no overshoot on opacity ever.
- **Riser without a payoff.** A riser that precedes something ordinary teaches the viewer to ignore risers for the rest of the video. Correction: use one only on the video's genuinely biggest beat.
- **Impact aligned to the file head.** Most impacts have 20–120 ms of pre-transient. Aligning `data-start` to the frame puts the hit late. Correction: measure the transient and offset with `data-media-start`.
- **Held too long.** Four seconds of one word and the video visibly waits. Correction: 0.8–1.5 s.
- **Used three times.** The device is spent on its second use and actively cheap on its third. Correction: once per video, twice at most.
- **Text clipped at the frame edge.** A long word at `width_fraction` 0.8 with negative tracking can still overflow at 1080p. Correction: compute the size from the actual glyph advance, and snapshot the frame — `overflow: hidden` clips the visual but does **not** suppress the layout finding.
- **Known gap:** there is **no caption or title primitive** in this stack — no `data-caption`, no SRT/VTT ingest, no built-in subtitle renderer. A topic card is an ordinary hand-authored composition, and its text, size and timing are all authored constants fed from the transcript. Nothing validates that the printed word matches the spoken one.
