---
id: sub-emphasis-caption-three-words
title: Captions are not visual variety — three words or fewer, only to make a word land
skill: subtitles
type: caption-style
family: emphasis-caption
tags: [skill/subtitles, type/caption-style, family/emphasis-caption, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:06:54"
    quote: "A lot of people make the mistake of adding captions just to bump up the visual variety."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:02"
    quote: "Using captions to fill more space can get ugly fast and waste a great opportunity to put something more engaging on screen. So I only use captions when I want the viewer to catch specific words and pay extra attention to them."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:15"
    quote: "But if there's genuinely nothing else you could put on screen, captions are often still better than nothing."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:20"
    quote: "Also keep it to three words or fewer, since that makes them easier to read."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements
  - https://en.wikipedia.org/wiki/Words_per_minute
  - https://developer.mozilla.org/en-US/docs/Web/CSS/filter
difficulty: medium
detectable_from: transcript+video
---

# Captions are not visual variety — three words or fewer, only to make a word land

## What it is
Two different objects share the word "captions" and this note is about the second one. A **subtitle track** is an accessibility and comprehension surface: it carries all of the speech, obeys reading-speed limits, and lives in a fixed zone. An **emphasis caption** is a *graphic* — one to three words, on screen for about a second, whose only job is to make a specific phrase land harder than the voice can land it alone. The source rejects using the second as a substitute for real visual content on two grounds, and both are worth keeping separate: it "can get ugly fast" (a craft claim) and it "waste[s] a great opportunity to put something more engaging on screen" (an opportunity-cost claim). The opportunity cost is the real argument — the lower third is prime screen area and a redundant transcription of a sentence the viewer just heard is the lowest-value thing that can occupy it.

The stated fallback matters and should not be dropped: if there is genuinely nothing else to put on screen, captions still beat nothing.

## When to use it
Fire an emphasis caption on exactly four kinds of word, and nowhere else:

- **A term being named or defined** — the label the rest of the section will use ([[struct-name-define-demonstrate]]).
- **A number or unit** the viewer must retain: a price, a percentage, a count, a dB level, a BPM.
- **A proper noun or a piece of jargon** that is hard to hear or easy to misspell.
- **The load-bearing word of a claim** — the "never", the "free", the "twice as fast", the punchline. This is the "catch specific words" case.

Do **not** fire one to fill a gap in visual variety (that gap is a B-roll routing decision — see [[motion-broll-slot-tier-selection]]), to transcribe a sentence the viewer just heard, or on more than one phrase at a time. And keep the two objects apart: if the deliverable needs a **full** caption track for accessibility or for silent in-feed viewing, that is a separate track with its own reading-speed rules — do not let it also try to be the emphasis layer, or every word will look emphasised and none will be.

## How to recognise it in a reference video
- **Measure captioned share of speech.** Pull the transcript, count the words that appear on screen as type, divide by total spoken words. **Under ~15 %** is an emphasis-caption channel. **Over ~80 %** is a burned-in full caption track. Anything in the 30–70 % band is usually the failure mode this note names: captions running because the editor had nothing else, in the middle of a sentence, cut off mid-phrase.
- **Count words per caption event.** Emphasis captions run **1–3 words**; full subtitle events run 5–9 words per line and up to 42 characters. A reference showing 3-word chunks that nevertheless cover every sentence is a *karaoke* track, not emphasis — log it as such, because the two need different specs.
- **Check duration and the trigger frame.** An emphasis caption appears within **±3 frames of the word's own onset** in the transcript and holds **0.6–1.6 s**. A full track's events obey a minimum of about **5/6 s** and a maximum of **7 s** and are continuous. A caption that appears before its word, or persists past the sentence, is filler.
- **Check size.** Emphasis captions are set far larger than a subtitle: typically **5–9 % of frame height** (60–100 px at 1080p; 90 px+ for in-feed viewing), heavy weight, often all-caps. A subtitle track sits nearer 3–4.5 % of frame height.
- **Look for a colour or weight break inside the phrase.** The classic emphasis form is 2–3 words with one word in an accent colour or a heavier cut — that is the tell that a human chose the word.
- **Audio correlation.** An emphasis caption almost always carries a small transient at its in-point, and the spoken word underneath is usually louder or slower than its neighbours. If the type lands with no sound and no vocal stress, it is decoration.
- **Look at what else is on screen at the same time.** If the frame under the caption is a static A-roll single, the caption is doing the work a cutaway should have done. Log the *slot*, not the caption.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `words_per_event` | 3 | 1–3 | Source rule, verbatim: "keep it to three words or fewer". A fourth word makes it a sentence fragment and it stops reading as a mark. |
| `captioned_share_of_speech` | 10 % | 5–15 % | Above 15 % the device inflates and each event carries less. |
| `events_per_minute` | 5 | 3–8 | Hard ceiling 8. One visible at a time, always. |
| `min_gap_between_events` | 2.0 s | 1.2–4.0 s | Two emphasis captions inside 1.2 s read as a caption track starting. |
| `in_offset_vs_word` | 0 f | −2 to +2 f (−67 to +67 ms) | Land on the word's transcript onset. Early reads as a spoiler; more than 2 frames late reads as a mistake. |
| `hold_duration` | 1.0 s (30 f) | 0.6–1.6 s | Long enough to read 3 words at ~20 characters/second, short enough not to outlive the phrase. |
| `fade_in` | 0.10 s (3 f) | 0.08–0.17 s | `power2.out`. Caption fades belong to the **gentle** eases, not the entrance default. |
| `fade_out` | 0.10 s (3 f) | 0.08–0.17 s | `power2.in`. Exits are shorter than entrances. |
| `slide_distance` | 0 or 12 px | 0–16 px | Optional micro-rise on `y`. Above ~16 px it becomes a motion event competing with the picture. |
| `font_size` | 84 px @1080p | 60–100 px (5.5–9 % of frame height) | Full-screen viewing floor for a headline-register element is 60 px; **in-feed viewing needs ≥90 px**. |
| `font_weight` | 700–900 | 600–900 | One cut heavier than the body face. Drop 50 units on very dark plates. |
| `tracking` | −0.03 em | −0.03 to −0.05 em | Display sizes need negative tracking because video encoding compresses letter detail. |
| `case` | UPPER for 1–2 words | upper / sentence | All-caps stops reading well past 3 words. |
| `legibility_backing` | 2 px stroke + soft shadow | stroke 0–4 px; shadow blur 8–24 px | Use one, not three. A plate/box is the safest on unpredictable footage. |
| `accent_word` | 1 | 0–1 | At most one word in the accent colour. Two accents is no accent. |
| `safe_margin` | 6 % of frame | 5–10 % | Keep clear of platform UI: bottom ~12 % on vertical feeds. |

## Reproduction prompt

```
Place emphasis captions for the section {{IN}}-{{OUT}} using the word-level
transcript.

1. SELECT. Choose caption words ONLY from these four classes: (a) a term being
   named or defined, (b) a number or unit the viewer must retain, (c) a proper
   noun or hard-to-hear piece of jargon, (d) the single load-bearing word of a
   claim. Reject every other candidate. Cap the selection so that captioned
   words are <= 15% of spoken words in the section, at most 8 events per
   minute, with at least 2.0s of clear air between events, and never two
   visible at once.
2. CHUNK. 1-3 words per event, taken verbatim from the transcript and never
   split across events. If the phrase you want needs 4+ words, it is not an
   emphasis caption - drop it or turn it into a graphic.
3. TIME. Event in-point = the transcript onset of the FIRST word of the chunk,
   +/- 2 frames (+/-67ms at 30fps). Hold 1.0s (0.6-1.6s). Out-point must be
   before the end of the spoken sentence.
4. ANIMATE. In: opacity 0 -> 1 over 0.10s, ease power2.out, optional y +12px
   -> 0 on the same tween. Out: opacity 1 -> 0 over 0.10s, ease power2.in.
   Nothing else moves. No scale bounce, no per-letter animation, no rotation.
5. STYLE. 84px at 1080p (>=90px if the deliverable is in-feed), weight 700-900,
   tracking -0.03em, one legibility treatment only (2px stroke OR a soft
   shadow OR a plate). At most ONE word in the accent colour. Keep 6% clear of
   every frame edge and clear of the platform UI band.
6. SOUND. One short transient at the in-point, -12 to -15 dB, under 250ms.
   A caption that appears silently reads as an overlay glitch.

ACCEPTANCE TEST: play the section muted. Every caption on screen must be
readable in under 1 second and must be a word you would want a viewer to
remember tomorrow. Then count: captioned words / spoken words <= 0.15. Then
check each in-point against the transcript onset - no caption may appear
before its word is spoken. Finally, for every event, ask what else could have
occupied that screen area; if a cutaway or a graphic was available and unused,
delete the caption and build that instead.
```

## Execution spec

**HyperFrames.** There is **no caption primitive** in this stack — no `data-caption`, no SRT/VTT ingest, no built-in subtitle renderer. A caption is an ordinary composition whose GSAP timeline writes `textContent` and animates a box; `compositions/captions.html` is the reference implementation and it is entirely hand-authored. For emphasis captions the seek-robust shape is **one element per event**, not the reference file's single reused box.

```html
<!-- inside a sub-composition; scope every rule to the composition id -->
<div id="emph-01" class="clip" data-start="12.42" data-duration="1.20" data-track-index="3">
  <div class="emph-inner"><span class="emph-word">TWENTY</span> <span class="emph-word accent">PERCENT</span></div>
</div>
```

```js
const T = 12.42;                       // = the transcript onset of "twenty"
tl.fromTo("#emph-01 .emph-inner",
  { autoAlpha: 0, y: 12 },
  { autoAlpha: 1, y: 0, duration: 0.10, ease: "power2.out" }, T);
tl.to("#emph-01 .emph-inner",
  { autoAlpha: 0, duration: 0.10, ease: "power2.in" }, T + 1.05);
```

Contract points that bind this:
- **Animate the inner wrapper, not the clip.** `autoAlpha` (and any `visibility`/`display` write) is forbidden on a clip element — the framework owns clip visibility and lint rejects it. The reference file's hard-kill `tl.set(box, { visibility: "hidden" })` is legal only because the box is not the clip.
- **`fromTo`, never `from`.** `from()` sets `immediateRender: true` and writes its start state at construction — before the clip's `data-start` is active — so under the render's non-linear seek the caption flashes or skips.
- **Land the fade-out before `data-duration`.** The window is half-open; here the out-tween ends at `T + 1.15` inside a `1.20` clip.
- **`data-duration` is required** on a `div` clip. Without a resolvable duration the element stays visible for the rest of the composition.
- **No CSS `transform` on the animated element** alongside a GSAP transform tween — that is lint error `gsap_css_transform_conflict`. Position with flex/inset, animate with `x`/`y`.
- **`x`/`y`, never `top`/`left`.** `width`/`height`/`top`/`left` tweens are forbidden.
- **Caption-zone audit.** The layout audit has a `--caption-zone` check and `caption_zone_collision` finding; an intentional lower-third opts out with `data-layout-allow-caption-zone` on the element (it applies to descendants via `closest`, and does **not** suppress the overflow/overlap audits).
- **Text fit.** The reference file's `white-space: nowrap` + `overflow: hidden` silently clips a long line. For 1–3 words that is acceptable and even desirable; never inherit that pattern into a full caption track.
- **Fonts.** `Inter` is bundled but on the banned-monoculture list. Safe, distinctive bundled picks for this register: Archivo Black, Oswald, League Gothic, Montserrat. Google Fonts is a network path and is unavailable under the egress allowlist — use a bundled family or a local `@font-face`.
- **No CDN.** `cdn.jsdelivr.net` is blocked; GSAP must be loaded from a local path, and the reference `captions.html` line must be substituted.
- Named rules that may be cited but not quoted: `asr-keyword-glow` (keyword emphasis synced to ASR timestamps) and the per-word kinetic typography technique in `techniques.md`.

**Word timing source.** `npx hyperframes transcribe <file>` produces the word-level transcript (`{text, words:[{text,start,end}]}`); Parakeet is the documented default but is an Apple-silicon MLX path, so on this linux ARM64 host expect the whisper.cpp fallback. Emphasis-caption in-points are read directly off `words[].start` — no audio analysis at render time, ever.

**ffmpeg.** Only relevant for a *baked* full track, which is the object this note tells you not to conflate: `-vf "subtitles=track.srt:force_style='Fontsize=28,Outline=2'"`. Emphasis captions should stay in the composition, where they can be restyled without a re-encode.

**Epidemic Sound.** One short transient per event: `SearchSoundEffects { query: { term: "text pop ui tick" }, filter: { duration: { max: 400 } } }`. Keep it at −12 to −15 dB and pitch it up slightly if it competes with the voice.

**Remotion.** The same pattern is a component rendered per event with `interpolate()` on opacity across a frame range — frame-native, so the 3-frame fades port as literal frame counts.

## Pairs with
[[motion-broll-slot-tier-selection]] · [[motion-image-focal-point-direction]] · [[struct-name-define-demonstrate]] · [[motion-attention-transient]] · [[motion-overlay-stack-choreography]] · [[sfx-unsounded-motion-audit]] · [[motion-closing-thesis-title-card]] · [[pace-visual-mush-ceiling]]

## Failure modes
- **Captions as filler.** The exact move the source rejects: a full or near-full transcription running because the editor had no B-roll. It occupies the highest-value screen area with the lowest-value content. Correction: treat every caption event as a competing bid against a cutaway, and route the beat with [[motion-broll-slot-tier-selection]] first.
- **Four or more words.** Stops being a mark and becomes a subtitle, at which point it must obey reading-speed and line-break rules it was not designed for. Correction: 3 words maximum, or promote it to a graphic.
- **Caption arrives before the word.** Kills the line's own timing and spoils the punchline. Correction: in-point = transcript onset, ±2 frames.
- **Everything emphasised.** Once past ~15 % of speech, the accent colour and the heavy weight stop meaning anything. Correction: enforce the per-minute cap and the 2 s gap.
- **Three legibility treatments at once.** Stroke plus shadow plus plate plus glow is the look the source calls "ugly fast". Correction: exactly one.
- **Over-animated type.** Per-letter bounces, scale pops, rotation. Caption motion belongs to the gentle eases; overshoot families (`back`, `elastic`, `bounce`) are a rare, explicitly-playful register and never the house style. Correction: 0.10 s opacity, optional 12 px rise, nothing else.
- **Reused single box under seek.** The reference implementation sets text inside `onStart`, which fires on forward entry only — a backwards seek can leave the wrong text on screen. Correction: one element per event with its own opacity envelope.
- **Accessibility conflated with emphasis.** Emphasis captions are not a caption track and do not satisfy an accessibility requirement. Correction: if the deliverable needs a real track, author it separately and keep the emphasis layer sparse on top of it.
