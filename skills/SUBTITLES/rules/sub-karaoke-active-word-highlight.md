---
id: sub-karaoke-active-word-highlight
title: Hold a phrase, highlight the active word
skill: subtitles
type: caption-motion
family: karaoke
tags: [skill/subtitles, type/caption-motion, family/karaoke, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:09"
    quote: "So I only use captions when I want the viewer to catch specific words and pay extra attention to them."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:07:20"
    quote: "Also keep it to three words or fewer, since that makes them easier to read."
research_refs:
  - https://aegisub.org/docs/latest/ass_tags/
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: high
detectable_from: video
---

# Hold a phrase, highlight the active word

## What it is
The karaoke form: a card of three to seven words is held still while a per-word treatment — colour, weight, a small scale step, a plate behind one word — advances across it in sync with the speech. It is the hybrid of the two timing models. The **card** obeys phrase-level timing so the eye can read ahead and see where the sentence is going; the **highlight** obeys word-level timing so the viewer always knows exactly where the voice is. It is the single most recognisable caption signature in short-form video and the one that most reliably identifies a reference edit's caption system.

Mechanically it is two independent timing streams over the same transcript: card boundaries (a phrase-level segmentation) and word onsets (raw ASR timings). Everything that makes it look good or bad is in the second stream — the highlight must land on the word's **onset**, and it must move by a hard swap, not a crossfade, or the "which word is live" signal smears.

The named prior art is ASS/SSA karaoke (`\k`, `\kf`, `\ko`, each taking a per-syllable duration in centiseconds), which is exactly this construct at subtitle-format level and is worth reading as a specification of the behaviour even though this stack renders it in HTML.

## When to use it
- **Sustained speech above ~180–200 wpm**, where chained three-word cards swap faster than a viewer can finish reading them. The held phrase gives the reader slack; the highlight keeps sync. This is the documented switch-away point in [[sub-cue-segmentation-three-word]].
- **Muted-first delivery** where the reading-rate cap (17 CPS) binds. A held phrase lets a slow reader take the whole card at their own pace.
- **When the profile's emphasis rule is dense** — if more than about one word in six deserves a lift, an emphasis layer will not hold it; make emphasis a *property of the highlight* instead (a different accent colour on keyword words) rather than a separate layer.
- **Do not** use it on a sound-on, large-screen, heavy-B-roll edit where the source's own doctrine applies: there, captions exist to make three words land, not to run continuously. Route with [[sub-caption-role-decision]] first.
- **Do not** use it under a busy graphic. A moving highlight in the caption zone plus motion above it is two competing attention signals.

## How to recognise it in a reference video
- **The card is static while something inside it changes.** Freeze two frames 200 ms apart: the words are in identical positions, but one word's colour, weight, plate or scale differs. That is the definitive tell and it separates karaoke from a per-word chained track, where the whole card changes.
- **Highlight advance rate** equals the speech rate — typically **2.5–3.5 words per second** for fast delivery. Count highlighted words in a 5 s window and compare with the transcript's word count in the same window; they must match exactly.
- **Highlight transition length.** Step frame by frame at a word boundary. A hard swap shows **0–1 intermediate frame**; a scale pop shows 3–5 frames of growth on the incoming word only. Anything showing 8+ frames of crossfade between two highlighted words is a mistimed implementation and reads as smeared.
- **Card length.** 3–7 words, **1.2–3.0 s** on screen. Under 1.2 s the read-ahead benefit disappears and it is really a chained track.
- **Highlight style inventory** — log exactly which channels change: colour (most common), weight, scale (1.0 → 1.06–1.12), a rounded plate behind the word, a vertical offset (−2 to −6 px), a glow. Two channels is normal; four is a tell-tale template.
- **Look for a second accent** used only on keyword words. If two different highlight colours appear, the emphasis rule is folded into the highlight and should be logged separately with the word classes it hits.
- **Baseline stability.** If the card's words shift horizontally as the highlight moves, the implementation is animating a property that affects layout — an amateur signature worth logging.
- **Audio:** there is usually **no** sound on the highlight advance. A tick per word at 3 words/s is a density failure and is rare in good references.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `words_per_card` | 5 | 3–7 | Above 7 the card needs two lines and the read-ahead advantage inverts. |
| `card_duration` | 1.8 s | 1.2–3.0 s | Derived from the phrase, not set. Cards under 1.2 s should merge. |
| `card_gap` | 0.10 s (3 f) | 0–0.20 s | Chain within a sentence; open a 0.20 s gap at terminal punctuation. |
| `highlight_in_offset` | 0 f | −2 to +1 f | Land on the word's transcript onset. Late reads as lag; more than 2 frames early reads as a spoiler. |
| `highlight_swap` | hard `set` | set only | Never crossfade between two highlighted words. |
| `highlight_scale` | 1.06 | 1.00–1.12 | Applied to the incoming word only, 0.12 s `power2.out`. Above 1.12 the line visibly reflows. |
| `highlight_colour_delta` | accent vs. body | — | Contrast ratio ≥4.5:1 against the plate for both states, not just the active one. |
| `highlight_y_lift` | 0 px | 0 to −6 px | Optional. Transform only, never `top`. |
| `keyword_second_accent` | off | off / on | If on, cap keyword words at 15 % of the track or it stops meaning anything. |
| `trailing_state` | dim, not hidden | dim / same | Already-spoken words stay legible; dimming below 60 % opacity destroys read-back. |
| `leading_state` | same as trailing | — | Keep unspoken words fully legible — reading ahead is the entire point of the form. |
| `font_size` | 4.5 % of frame height | 3.5–6 % | 48–65 px at 1080p; ≥5 % for in-feed. |
| `line_count` | 1 | 1–2 | Two lines only if the card exceeds 5 words at the chosen size. |
| `speech_rate_floor` | 180 wpm | 150–220 wpm | Below this, chained three-word cards are the better form. |

## Reproduction prompt

```
Build a karaoke caption track for {{IN}}-{{OUT}} from the word-level
transcript. Two timing streams over the same words.

1. CARDS. Group words into cards of 3-7 words, closing a card after terminal
   punctuation and preferring boundaries before conjunctions. Never split a
   number from its unit, a name pair, or an article from its noun. card.start
   = first word's start; card.end = next card's start within a sentence, or
   last word's end + 0.20s at a sentence end. Merge any card under 1.2s into
   its neighbour.
2. WORDS. Inside each card, emit one element per word in reading order. Word
   w[i] becomes active at w[i].start (transcript onset, no offset) and
   inactive at w[i+1].start. The last word of the card stays active until
   card.end.
3. HIGHLIGHT. Activate with a zero-duration hard swap of the active class -
   colour to the accent, weight up one cut. Optionally scale the active word
   1.00 -> 1.06 over 0.12s ease power2.out, transform only. NEVER crossfade
   between two active words, and never animate any property that changes
   layout. Unspoken and already-spoken words stay fully legible.
4. CARD ENTRY/EXIT. First card of a sentence fades in over 0.10s power2.out;
   last card fades out over 0.10s power2.in. Cards inside a sentence hand over
   with a hard swap, no fade.

ACCEPTANCE TEST: highlighted-word count in any 5s window equals the spoken
word count in that window. Freeze at any word onset +/-1 frame: exactly one
word is in the active state. Freeze mid-card: every word on the card is
readable, including the ones not yet spoken. Word x-positions must be
identical in every frame of a card's life.
```

## Execution spec

**HyperFrames.** No caption primitive exists, so this is hand-authored. The card is a flex row of per-word `<span>`s inside a non-clip wrapper; the highlight is a class swap driven by zero-duration `tl.set()` calls at word onsets.

```html
<div class="clip" data-start="0" data-duration="{{DURATION}}" data-track-index="6">
  <div class="kar-stack">
    <div class="kar-card" id="kar-012">
      <span class="w" id="kar-012-w0">only</span>
      <span class="w" id="kar-012-w1">three</span>
      <span class="w" id="kar-012-w2">words</span>
    </div>
  </div>
</div>
```

```js
// card 012: start 12.40, end 14.05. Word onsets from the transcript.
tl.set("#kar-012", { autoAlpha: 1 }, 12.40);
tl.set("#kar-012-w0", { className: "w active" }, 12.40);
tl.set("#kar-012-w0", { className: "w" },        12.86);
tl.set("#kar-012-w1", { className: "w active" }, 12.86);
tl.to ("#kar-012-w1", { scale: 1.06, duration: 0.12, ease: "power2.out" }, 12.86);
tl.to ("#kar-012-w1", { scale: 1.00, duration: 0.10, ease: "power2.in"  }, 13.28);
tl.set("#kar-012-w1", { className: "w" },        13.38);
tl.set("#kar-012-w2", { className: "w active" }, 13.38);
tl.set("#kar-012", { autoAlpha: 0 }, 14.05);
```

Contract points that bind this:
- **Every state change is a `tl.set` on the seekable timeline.** No `gsap.to()` outside `tl`, no CSS `transition` on the spans, no CSS keyframe loop — anything not on `tl` runs on wall-clock and is absent from the render.
- **`scale`, never `font-size` / `width` / `height`.** Those tweens are forbidden; scale is a transform and does not reflow. Give each `.w` `display: inline-block` so the transform applies (transformed elements must be block-level and sized).
- **No CSS `transform` on `.w` in the stylesheet** alongside a GSAP transform tween — that is lint error `gsap_css_transform_conflict`. Set the resting state via GSAP or leave it untransformed.
- **`fromTo`, never `from`** for any entry tween: `from()` sets `immediateRender: true` and writes its start state at construction, before the clip's `data-start` is active, so under the render's non-linear seek it flashes.
- **`autoAlpha` on the wrapper, not on the clip.** The framework owns clip visibility and lint rejects `visibility`/`display` writes on a `.clip`.
- **Zero-duration sets are seek-safe**; `onStart` callbacks are not — they fire on forward entry only. Do not write `textContent` from a callback in this pattern; the words are already in the DOM.
- Reserve the active state's extra weight in layout, or a weight change reflows the row. Either set the resting spans in the heavy weight with a lighter colour, or use a variable font where the axis change is metric-compatible, or add `letter-spacing` compensation.
- **Sizes as a percentage of frame height**, resolved to px at author time: 4.5 % of 1080 = 48 px, of 1920 = 86 px. Video type floors: full-screen body ≥20 px, in-feed body ≥32 px, in-feed headline ≥90 px. Tracking −0.03 to −0.05 em at display sizes.
- **Fonts:** `Inter` is bundled but on the banned-monoculture list; prefer Montserrat, Oswald, Archivo Black or League Gothic from the bundled set. Google Fonts is a network path and unavailable under the egress allowlist — bundled family or a local `@font-face` only.
- **GSAP must be local** — `cdn.jsdelivr.net` is blocked; substitute the reference `captions.html` CDN line.
- The named animation rule `asr-keyword-glow` (keyword emphasis synced to ASR timestamps) and the `per-word kinetic typography` technique in `techniques.md` are the in-repo relatives. **The `rules/` recipe files are not staged**, so cite the rule by name and do not quote code from it.

**ffmpeg.** The equivalent in a burned-in deliverable is ASS karaoke: one dialogue event per card with `{\k<cs>}` before each word, durations in centiseconds (`\kf` for a sweep fill, `\ko` for an outline swap), then `-vf "subtitles=cards.ass"`. `force_style` can override `FontName`, `FontSize`, `PrimaryColour`, `SecondaryColour` and `Outline` at encode time. Use this only for assets leaving the pipeline — inside the composition the CSS version stays restylable.

**Epidemic Sound.** None. A per-word transient at 3 words/s is the density-fatigue failure; if the profile calls for sound, put one soft transient on the **card** entry only: `SearchSoundEffects { query: { term: "soft ui text tick" }, filter: { duration: { max: 300 } } }` at −18 dB.

**Remotion.** Per-word `interpolate()` over frame ranges derived from the same word onsets, with the active state selected by a frame comparison rather than a class swap. Portable concept only.

## Pairs with
[[sub-cue-segmentation-three-word]] · [[sub-caption-role-decision]] · [[sub-emphasis-caption-three-words]] · [[sub-safe-area-and-caption-zone]] · [[sub-mixed-script-hinglish-stack]] · [[motion-emphasis-scale-step]] · [[sfx-highlight-sound-on-emphasis]] · [[sfx-density-fatigue-audit]]

## Failure modes
- **Crossfading between highlighted words.** Two words half-lit for 4 frames destroys the sync signal, which is the only reason the form exists. Correction: zero-duration class swap.
- **Highlight lags the voice.** Usually caused by applying a positive offset "so it feels right", or by using card-relative interpolation instead of raw word onsets. Correction: onset exactly, verified by freezing on a word boundary.
- **Layout reflow on activation.** Animating `font-size`, `padding` or a non-metric-compatible weight makes the whole row shuffle each word. Correction: transform-only scale, and reserve the heavy metrics at rest.
- **Dimming unspoken words.** Kills read-ahead and turns the form back into a chained track with extra steps. Correction: full legibility for the entire card, and let the accent carry the position.
- **Two accent colours plus scale plus glow plus a plate.** Reads as a template preset. Correction: two changed channels maximum.
- **Karaoke used on a sound-on B-roll-heavy edit.** Contradicts the source doctrine and occupies screen area a cutaway wanted. Correction: run [[sub-caption-role-decision]] first.
- **One giant card list in one file.** At 3 words/s a 10-minute video is ~1800 word spans and the DOM cost shows in preview. Correction: one caption sub-comp per scene.
- **Known gap.** Nothing in the stack verifies highlight-to-audio sync; there is no waveform alignment and no drift correction — picture/sound alignment is authored by writing the same numbers on both elements. Verify by snapshot at word onsets, and re-derive from the transcript after any recut.
