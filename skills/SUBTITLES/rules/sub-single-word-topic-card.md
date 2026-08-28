---
id: sub-single-word-topic-card
title: Land the topic as one word, full frame, and clear the caption zone for it
skill: subtitles
type: caption-motion
family: kinetic-type
tags: [skill/subtitles, type/caption-motion, family/kinetic-type, engine/hyperframes, engine/epidemic, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:02"
    quote: "And why wouldn't it be — in this video we're talking about the one thing that 90% of people can't get right."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:06"
    quote: "Music."
research_refs:
  - https://tech.ebu.ch/docs/r/r095.pdf
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://sproutsocial.com/insights/social-media-video-specs-guide/
  - https://developer.mozilla.org/en-US/docs/Web/CSS/text-wrap-style
difficulty: medium
detectable_from: transcript+video
---

# Land the topic as one word, full frame, and clear the caption zone for it

## What it is
The hook builds tension about "the one thing", and the answer arrives as a single spoken word — "Music." — with that word alone on screen at display size. It is the smallest possible kinetic-type object: one word, full frame, held for under a second and a half, entering on the word's own onset. Its whole effect comes from **exclusivity**. Nothing else is on screen, the running caption track is off, and the word occupies the optical centre rather than the caption band.

That makes it a subtitles problem as much as a motion one. The word is a transcript word, its in-point is a transcript onset, and the object that most often ruins it is the caption track underneath rendering the same word in small type at the same instant. The motion of the card is owned by [[motion-single-word-topic-card]]; this note owns the type spec, the transcript binding, the caption interaction, and the acceptance test.

## When to use it
- **The topic reveal after a curiosity hook.** The hook names a mystery ("the one thing 90 % of people can't get right"), the reveal answers it in one word. If the answer needs two words, use two words at the same size; if it needs five, this is not the form — build a title card.
- **A hard chapter turn** where a section's subject can be compressed to a noun.
- **A one-word answer to a question the presenter just asked**, especially where a beat of silence precedes it.
- **Once or twice per video, maximum.** It is a hard structural punctuation mark; the third one is a template.
- **Do not** use it for a word the voice does not isolate. The form depends on the audio having a gap around the word; without that gap the card lands mid-sentence and reads as an errant caption.
- **Do not** use it while the caption track is running unless the track is suppressed for the hold.

## How to recognise it in a reference video
- **One word, alone, at display size.** Measure the cap height: **9–18 % of frame height** (95–195 px at 1080p). Anything under 7 % is a caption, not a topic card.
- **Vertical position near the optical centre** — roughly **45–58 % of frame height** from the bottom, not in the caption band. If the word sits at the caption baseline it is an emphasis caption, not this.
- **Hold length.** In-point to out-point **0.6–1.4 s (18–42 frames)**. Under 0.5 s it reads as a flash frame; over 1.6 s the edit stalls.
- **In-point against the transcript.** The card appears within **±2 frames** of the spoken word's onset. If the word is spoken and the card arrives 6+ frames later, the reference is cutting to a card rather than revealing type over the frame — a different move.
- **Entry signature.** Look for one of three: scale-down settle (1.10 → 1.00 over 8–12 frames), a blur-to-sharp (6–10 px → 0), or a mask/wipe reveal. A pure opacity fade is rare here because the beat wants weight.
- **Silence around it.** Check the waveform: a **0.3–0.8 s** gap in speech before the word is the norm, and the music often drops or a hit lands exactly on the in-frame.
- **Caption track state.** Freeze mid-hold. If any other text is visible, the reference is not using this form cleanly — log it as a collision.
- **Background treatment.** Most references darken, blur or freeze the plate under the word by 20–50 % for the hold. Log which.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `word_count` | 1 | 1–2 | Two words only if they are one lexical unit ("sound design"). |
| `in_offset_vs_onset` | 0 f | −2 to +1 f | Land on the transcript onset of the word. Early is a spoiler; late is a mistake. |
| `hold` | 1.0 s (30 f) | 0.6–1.4 s | Measured in-point to start of exit. |
| `cap_height` | 12 % of frame height | 9–18 % | 130 px at 1080p; ≥18 % only for very short words. |
| `position_y` | 52 % of frame height | 45–58 % | Optical centre sits slightly above geometric centre. |
| `case` | UPPER | upper / sentence | One word takes all-caps well; keep the full stop off. |
| `tracking` | −0.04 em | −0.03 to −0.06 em | Display sizes; encoding compresses letter detail. |
| `weight` | 800 | 700–900 | One cut above anything else in the video. |
| `entry` | scale 1.10 → 1.00 | 1.06–1.16 | 0.30 s, `power3.out` (house entrance default). Overshoot families are banned here. |
| `entry_opacity` | 0 → 1 | — | 0.18 s `power2.out`, on its own tween so a settling curve never touches opacity. |
| `blur_entry` | 0 px | 0–10 px | Optional; if used, 8 px → 0 over 0.30 s and drop the scale to 1.06. |
| `exit` | opacity 1 → 0 | — | 0.18 s `power2.in`. Exits are shorter than entrances (0.4 s in / 0.25 s out doctrine). |
| `plate_darken` | 35 % | 0–50 % | Scrim under the word for the hold, ramping in over 0.2 s. |
| `caption_suppression` | hold + 0.3 s each side | 0.2–0.5 s pad | Track hidden, not restyled. |
| `sfx` | one hit | hit / riser+hit | Peak on the in-frame, −12 to −15 dB. |
| `uses_per_video` | 1 | 1–2 | Third use makes it a template. |

## Reproduction prompt

```
Build a single-word topic reveal at the transcript word {{WORD}}, onset
{{IN}} seconds.

1. VERIFY THE BEAT. Confirm the word is isolated in the audio - at least 0.25s
   of no speech before it. If it is not, this form does not apply; stop.
2. TYPE. One word, uppercase, no full stop, weight 800, tracking -0.04em, cap
   height 0.12 * frame_height, centred horizontally, baseline set so the word's
   optical centre sits at 0.52 * frame_height from the bottom. One legibility
   treatment only.
3. PLATE. Ramp a black scrim over the underlying footage to 35% opacity from
   {{IN}}-0.20s over 0.20s, ease power2.out; ramp it back out with the word.
4. ENTRY at {{IN}} exactly: scale 1.10 -> 1.00 over 0.30s ease power3.out, and
   on a SEPARATE tween opacity 0 -> 1 over 0.18s ease power2.out. Use fromTo,
   never from. Do not add rotation, overshoot or per-letter animation.
5. HOLD 1.00s from {{IN}}, then EXIT: opacity 1 -> 0 over 0.18s ease power2.in.
6. SUPPRESS the running caption track from {{IN}}-0.30s to {{IN}}+1.30s. Hide
   it; do not restyle or move it.
7. SOUND. One impact on the in-frame at -12 to -15 dB, under 900ms. If a riser
   precedes it, the riser's peak must land on {{IN}}, not after.

ACCEPTANCE TEST: step frame by frame across {{IN}}. The word's first visible
frame is the same frame the voice starts the word, +/-2. During the hold no
other text is on screen. The word is fully legible at 25% zoom (the in-feed
test). Total elapsed from first frame to fully gone is between 0.95s and 1.6s.
```

## Execution spec

**HyperFrames.** A `div` clip with `data-start` and `data-duration` (both required on a `div`), containing a non-clip inner wrapper that carries the motion.

```html
<div id="topic-music" class="clip" data-start="6.42" data-duration="1.60"
     data-track-index="8" data-layout-ignore>
  <div class="scrim"></div>
  <div class="topic-word">MUSIC</div>
</div>
```

```js
const T = 6.42;                                  // transcript onset of "Music"
tl.fromTo("#topic-music .scrim", { autoAlpha: 0 },
  { autoAlpha: 0.35, duration: 0.20, ease: "power2.out" }, T - 0.20);
tl.fromTo("#topic-music .topic-word", { scale: 1.10 },
  { scale: 1.00, duration: 0.30, ease: "power3.out" }, T);
tl.fromTo("#topic-music .topic-word", { autoAlpha: 0 },
  { autoAlpha: 1, duration: 0.18, ease: "power2.out" }, T);
tl.to("#topic-music .topic-word", { autoAlpha: 0, duration: 0.18, ease: "power2.in" }, T + 1.00);
tl.to("#topic-music .scrim", { autoAlpha: 0, duration: 0.18, ease: "power2.in" }, T + 1.00);
```

Contract points:
- **Scale and opacity on separate tweens.** A settling curve belongs on transforms only; opacity gets its own `power2.out` at the same position. At ζ<1 (any spring or overshoot) this is a hard rule, and it is good practice regardless.
- **`fromTo`, never `from`.** `from()` sets `immediateRender: true` and writes its start state at construction, before the clip's `data-start` is active — under non-linear seek the word flashes or starts at the wrong scale.
- **`scale`, not `font-size`.** `width`/`height`/`top`/`left` tweens are forbidden; use transform aliases only. The word element must be block-level and sized for the transform to behave.
- **No CSS `transform` on `.topic-word`** in the stylesheet alongside the GSAP tween — that is lint error `gsap_css_transform_conflict`.
- **`autoAlpha` on inner elements only**, never on the `.clip`; the framework owns clip visibility.
- **Exit lands before `data-duration`** — the visibility window is half-open, so `1.00 + 0.18 = 1.18 < 1.60`.
- **Caption suppression must be planned architecturally.** A sub-comp timeline cannot animate host-root elements, so either put the topic card and the caption stack in the same composition, or drive the suppression on the main timeline at global time = scene-local time + the host's `data-start`.
- **`data-layout-ignore`** is appropriate here because the card deliberately covers the frame; it excludes the element from layout audits entirely. Do not use `data-layout-allow-overflow` — its blast radius silences `text-clipping` for the whole subtree.
- **Type sizes as a fraction of the root height**, resolved at author time: 12 % of 1080 = 130 px, of 1920 = 230 px. In-feed headline floor is ≥90 px.
- **Fonts:** bundled families only (Google Fonts is a network path, unavailable under the egress allowlist). Archivo Black, League Gothic, Oswald and Montserrat all carry this register; `Inter` is bundled but on the banned-monoculture list.
- **GSAP from a local path** — `cdn.jsdelivr.net` is blocked.
- Named animation rules in the neighbourhood: `kinetic-beat-slam`, `discrete-text-sequence`, `gradient-text-sweep`. **Their recipe files are not staged**, so cite by name only.

**Epidemic Sound.** One impact on the in-frame: `SearchSoundEffects { query: { term: "cinematic impact hit deep" }, filter: { duration: { max: 1500 } } }`. If a riser precedes it, back-time the riser so its peak lands on `T` — see [[sfx-riser-to-drop-alignment]]. Place at −12 to −15 dB per the SFX layer target, and duck the music with `data-fx-carve` rather than baking the level.

**ffmpeg.** Not the right tool. A `drawtext` with `enable='between(t,6.42,7.6)'` can prove the timing but cannot do the scale settle.

**Remotion.** A `<Sequence>` with `spring()`-driven scale and an `interpolate()` opacity over the same frame range. Concept only; not a runtime in this project.

## Pairs with
[[motion-single-word-topic-card]] · [[sub-safe-area-and-caption-zone]] · [[sub-caption-role-decision]] · [[sub-term-definition-lockup]] · [[sfx-cinematic-hit]] · [[sfx-riser-to-drop-alignment]] · [[struct-outcome-first-cold-open]] · [[motion-anticipation-build-to-reveal]]

## Failure modes
- **The caption track renders the same word underneath.** The reveal's exclusivity is the whole effect, and this destroys it while looking like a bug. Correction: suppress the track across the hold plus 0.3 s.
- **Card arrives after the word.** The voice has already answered; the type is now redundant. Correction: in-point = transcript onset, ±2 frames.
- **Bouncy entry.** `back.out(1.7)` or `elastic` on a structural reveal reads cheap; overshoot is a rare explicitly-playful register, never the house style. Correction: `power3.out`, scale 1.10 → 1.00.
- **Two or three words creeping in.** "Music" becomes "It's the music" and the form collapses into a title card with no weight. Correction: one word, or one lexical unit at most.
- **Silent card.** A hard full-frame text event with no transient reads as a rendering glitch — the brain expects a sound when something appears. Correction: one hit at −12 to −15 dB on the in-frame.
- **Used four times.** It stops being punctuation and becomes the video's transition style. Correction: once, twice at the outside.
- **Held too long.** Past ~1.6 s the viewer has read it three times and the edit is waiting. Correction: 1.0 s default.
- **Known gap.** There is no automatic beat or onset detection in the stack; the in-point comes from the word-level transcript and any music-hit alignment is authored by writing the same number on both elements. After any recut, re-derive the onset — nothing corrects drift.
