---
id: motion-persistent-item-counter
title: The persistent item counter, and the digit swap that advances it
skill: motion
type: graphic
family: list-spine
tags: [skill/motion, type/graphic, family/list-spine, engine/hyperframes, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:18"
    quote: "So in this video, we're gonna dive into 10 important editing cuts every filmmaker should know."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:45"
    quote: "Number two, the jump cut."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:35"
    quote: "Number nine is cross cutting."
research_refs:
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/4406208331923-Title-Safe-and-Safe-Action-Best-Practices
  - https://www.clueso.io/blog/how-to-make-tasteful-screen-capture-videos
  - https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
difficulty: medium
detectable_from: transcript+video
---

# The persistent item counter, and the digit swap that advances it

## What it is
A small, always-on marker — `3/10`, or a ten-segment progress rail — parked in a corner for the entire body of a counted-list video, which **advances with a visible motion** each time the narration announces a new item. It answers "how much is left?" at any random frame, which is the one question a title card cannot answer because the card is gone two seconds later. The counter is the *spine* of the format; the per-item card or lower third is the *marker*. [[motion-list-item-marker-card]] owns choosing between those forms and designing the card; this note owns the counter itself: where it sits, how big it is, how the number changes, and how it survives scene cuts.

## When to use it
- **N ≤ 12 and items are short** (under ~45 s each). With more items or longer ones, the fraction stops being a useful progress read and the permanent pixel cost is not repaid.
- **When the promise was a count.** "10 cuts", "7 mistakes", "5 tools". If the video never promised a number, a counter invents an obligation.
- **When viewers scrub.** Tutorials and reference videos get scrubbed; the counter is the only marker that is legible mid-scrub.
- **Alongside, not instead of, spoken ordinals.** The spoken "number two" is the primary marker for listening-while-doing viewers; the counter is redundancy for looking viewers. Both, always.
- **Not during the intro, the sponsor read, or the outro.** The counter is the body's spine; showing it over the hook implies the list has started.

## How to recognise it in a reference video
- **Sample one frame per 10 s across the whole video** and look at the four corners. A persistent counter appears in the *same* position on most body frames and is absent in the intro/outro.
  `ffmpeg -i ref.mp4 -vf fps=1/10 -frames:v 60 /tmp/c/%03d.png`
- **Measure its box.** Typical: **4–8% of frame width** from the nearest edges, occupying **3–8% of frame width**. Netflix/SMPTE title safe is 90% of the frame and action safe 93%; a counter outside title safe is a defect, and on a phone it will collide with platform UI.
- **Measure the type size.** At 1080p full-screen viewing, data labels want **≥16 px** and body **≥20 px**; for in-feed viewing (X, LinkedIn, Instagram) those floors rise to **≥24 px** and **≥32 px**. A counter under 24 px in a video destined for a feed is unreadable.
- **Frame-step the advance.** This is the diagnostic moment. Look for one of three shapes:
  - **Vertical ticker** — old digit leaves upward, new digit arrives from below, both translating by ~100% of line height over **8–12 frames**.
  - **Cross-swap** — old fades/scales out, new fades/scales in, overlapping by 2–4 frames.
  - **Hard swap** — one frame, no motion, justified by a click. That is [[motion-instant-appearance-sfx-justified]] applied to a counter.
  A counter that changes with no motion *and* no sound is a defect.
- **Correlate the advance with the transcript.** The digit should change within **±6 frames** of the spoken ordinal's first syllable. If the counter runs ahead of the narration, the design is driving off cut boundaries instead of words — log it.
- **Check the denominator never moves.** In competent work only the numerator animates; a whole-string re-render makes the `/10` jitter.
- **Look for a progress rail instead of a fraction.** A segmented bar filling left-to-right is the same device; measure the fill width as a fraction and confirm it matches item index / N.
- **Check contrast and a scrim.** A counter over live footage needs a shadow, a plate or a scrim; if it disappears over bright B-roll, log it as a defect rather than copying it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `form` | fraction `n/N` | fraction · rail · dots | Fraction reads exactly; rail reads faster; dots only for N ≤ 7. |
| `position` | top-right | any corner | Avoid the lower third if captions live there; the layout audit flags `caption_zone_collision` and the narrow opt-out is `data-layout-allow-caption-zone`. |
| `margin` | 6% of frame width | 4–8% | Must sit inside 90% title safe. |
| `numerator_size` | 44 px @1080p | 32–72 px | In-feed delivery: 44 px floor. Full-screen only: 32 px floor. |
| `denominator_size` | 0.62 × numerator | 0.5–0.75 × | Smaller and dimmer; it is context, not information. |
| `denominator_opacity` | 0.55 | 0.4–0.7 | |
| `swap_style` | vertical ticker | ticker · cross-swap · hard | |
| `swap_duration` | 0.33 s (10 f) | 0.27–0.40 s (8–12 f) | `power3.out` — the house entrance ease. |
| `swap_overlap` | 0.07 s (2 f) | 2–4 f | Outgoing and incoming move together; a gap reads as a glitch. |
| `travel` | 100% of line height | 90–120% | Ticker only. Under 90% the old digit is still visible when the new one lands. |
| `swap_offset_vs_word` | 0 f | −3 to +6 f | Relative to the spoken ordinal's first syllable. Slightly late is safer than early. |
| `emphasis_scale` | 1.08 for 4 f | 1.00–1.12 | Optional pop on the new numerator, released over 6 f. |
| `sfx` | soft UI click | click · tick · none | −15 dB region; the counter is a quiet event. |
| `scrim` | `0 2px 8px rgba(0,0,0,.45)` shadow | shadow · plate · none | Required over live footage. |
| `visible_range` | body only | — | Off during intro, sponsor and outro. |

## Reproduction prompt

```
Build a persistent item counter for a list of {{N}} items and advance it at
each of the ordinal timecodes {{ORDINALS}}.

STRUCTURE. Place it at the composition ROOT, not inside any scene sub-
composition - a sub-composition timeline cannot animate host-root elements,
and a counter that lives inside scene 3 dies at the cut into scene 4. Give the
container data-start = first item's start and data-duration = last item's end
minus that start, so it is absent over intro and outro.

MARKUP. One column per state, stacked: render all {{N}} numerators as sibling
divs inside a fixed-height, overflow-hidden window sized to one line. The
denominator "/{{N}}" is a separate static element and never animates.

MOTION. At each ordinal T, translate the numerator stack by exactly one line
height: tl.to(stack, { yPercent: -100 * index, duration: 0.33, ease:
"power3.out" }, T). This is seek-robust: position is a pure function of
timeline time, with no text written in a callback. Optionally scale the newly
arrived numerator to 1.08 at T and back to 1 over 0.20s, power2.out.

TYPE. Numerator 44px at 1080p, denominator 62% of that at 0.55 opacity, both
inside 90% title safe with a 6% margin, with a drop shadow so it survives
bright footage.

SOUND. One soft UI click at each T, -15 dB, on the sfx group.

ACCEPTANCE TEST: sample a frame at the midpoint of every item. The counter
must read the correct index in all {{N}} of them. Seek backwards to an earlier
item and re-sample - the number must still be correct. Step frames around one
advance: the swap must complete in 8-12 frames with no frame showing two
digits fully overlapping.
```

## Execution spec

**HyperFrames.** Two decisions in this note are forced by the contract rather than by taste.

**1. The counter lives at the host root.** *"A sub-comp timeline cannot animate host-root elements"*, and equally a sub-comp's own elements die with the sub-comp. A spine that spans scene cuts must be a root-level element driven by the **main** timeline at global time. This is archetype B in the composition patterns: put the element as a host-root sibling and drive it at *global time = scene-local time + the slot's `data-start`*.

**2. Author one element per state, not one element whose text you rewrite.** The staged captions reference implementation swaps text inside a tween's `onStart`, and the contract records the cost: *"a backwards seek or a seek that lands between lines does not necessarily restore the correct text — `onStart` fires on forward entry."* A render engine seeks non-linearly. A translated stack of pre-rendered digits has no such failure: its state is a pure function of `tl.time()`.

```html
<!-- root-level spine; NOT inside a scene sub-composition -->
<div id="counter" class="clip" data-start="21.0" data-duration="304.0" data-track-index="3"
     style="position:absolute; right:6%; top:6%; display:flex; align-items:baseline;
            gap:4px; font-family:'Archivo Black', sans-serif;
            text-shadow:0 2px 8px rgba(0,0,0,.45);">
  <div id="counter-window" style="height:52px; overflow:hidden; position:relative;">
    <div id="counter-stack" style="position:absolute; top:0; left:0;">
      <div style="height:52px; font-size:44px; line-height:52px; color:#fff;">1</div>
      <div style="height:52px; font-size:44px; line-height:52px; color:#fff;">2</div>
      <!-- … one per item … -->
    </div>
  </div>
  <div style="font-size:27px; opacity:.55; color:#fff;">/10</div>
</div>
```

```js
// ordinals in composition seconds, from the word-level transcript
const ORDINALS = [21.0, 51.4, 88.2, 121.9, 155.0, 190.6, 224.1, 258.8, 289.3, 316.2];
ORDINALS.forEach((t, i) => {
  tl.to("#counter-stack", { yPercent: -100 * i, duration: 0.33, ease: "power3.out" }, t);
});
```

Contract points that bind this:
- **`yPercent`, not `top`.** `width`/`height`/`top`/`left` tweens are forbidden; spatial motion uses GSAP transform aliases only.
- **No CSS `transform` on `#counter-stack`.** A CSS initial transform plus a GSAP tween on the same property is lint error `gsap_css_transform_conflict`. Its resting position is `top: 0` with no transform, and the first tween to `yPercent: 0` is a no-op that keeps the property owned by GSAP.
- **`data-duration` is required** on this `div` clip; without a resolvable duration it stays visible to the end of the composition — which would leak the counter over the outro.
- **`class="clip"` is a convention but keep it** — the shared `.clip { position:absolute; inset:0 }` rule and the `timed_element_missing_clip_class` warning both assume it. Here the element is positioned explicitly, so if `inset: 0` fights the corner placement, wrap: an `inset:0` clip containing an absolutely-positioned inner badge.
- **Layering is CSS `z-index`**, not `data-track-index` (display only). Put the counter above scene content.
- **Caption zone.** If the design puts the counter low, the layout audit's `caption_zone_collision` will fire; the narrow opt-out is `data-layout-allow-caption-zone` (element + descendants). Prefer moving it to a top corner.
- **Fonts:** `Inter` is bundled but on the *banned monoculture list*; safe, distinctive bundled picks include Montserrat, Oswald, League Gothic, Archivo Black, Space Mono, IBM Plex Mono. Google Fonts fetching is a network path and is unavailable here — use a bundled family or a local `@font-face`.
- Named rules that may be cited but not quoted: `vertical-spring-ticker`, `counting-dynamic-scale`, `discrete-text-sequence`, `dynamic-content-sequencing`.
- For a **count-up** rather than a swap (a stat rolling 0 → 47), the mechanical register is `steps(N)` — *"Discrete jumps. Typing, cursor blink, counter ticks."*

**Progress-rail variant** — the same event on a different property:

```js
tl.to("#rail-fill", { scaleX: (i + 1) / N, duration: 0.33, ease: "power3.out",
                      transformOrigin: "left center" }, t);
```
`scaleX` and `transformOrigin` are lint-clean on the master timeline.

**Epidemic Sound.** One quiet tick per advance:
```
SearchSoundEffects { query: { term: "ui click select menu" },
  filter: { tagSlugs: { matchType: "ANY", values: ["user-interface--click"] },
            duration: { max: 500 } } }
```
Real assets in that tag run **197–663 ms**. Place at each ordinal `t`, `data-volume` ≈ 0.25, `data-audio-group="sfx"`, alternating `data-track-index` 12/13 so consecutive clips never share a track and overlap (`duplicate_audio_track`).

**ffmpeg.** Only to derive the ordinal timecodes from the transcript:
```bash
npx hyperframes transcribe ref.mp4 --engine auto      # word-level { text, start, end }
# then take the start of each "number|first|second|…" token as the ordinal timecode
```

**Remotion:** a `<Sequence>`-less absolute component reading `useCurrentFrame()` and mapping it to an index — conceptually identical, and equally seek-robust. Remotion is not a runtime here.

## Pairs with
[[motion-list-item-marker-card]] · [[struct-enumerated-promise-and-counter]] · [[struct-numbered-list-mid-roll-sponsor]] · [[motion-instant-appearance-sfx-justified]] · [[motion-sound-bound-motion-event]] · [[motion-image-focal-point-direction]] · [[motion-format-promise-motion-budget]]

## Failure modes
- **Text rewritten in a callback.** The counter shows the wrong number after a backwards seek or a non-linear render pass, and the bug is invisible in a forward preview. Correction: one element per state, position driven by timeline time.
- **Counter inside a scene sub-composition.** It vanishes at the first scene cut, or worse, only some scenes have it. Correction: root-level element on the main timeline.
- **Counter runs on cut boundaries instead of words.** The number advances while the narration is still finishing the previous item. Correction: drive off the word-level transcript, ±6 frames of the spoken ordinal.
- **Denominator jitters.** Re-rendering the whole `n/N` string re-lays out the slash. Correction: animate the numerator only; the denominator is a separate static element.
- **Too small for the feed.** A 24 px counter is invisible on a phone in-feed. Correction: 44 px floor at 1080p when the deliverable will be watched in a feed.
- **No scrim.** The counter disappears over bright B-roll for ten seconds at a time. Correction: drop shadow or plate; verify against the brightest frame in the body.
- **Left visible over the outro or sponsor.** Implies the list is still running. Correction: `data-duration` ends at the last item.
- **Silent advance with no motion.** Reads as a rendering glitch when a viewer happens to be looking at it. Correction: a swap of 8–12 frames, or a hard swap with a click.
- **Known gap:** no published standard specifies counter type sizes; the floors above come from this project's own video-typography guardrails (full-screen body ≥20 px, in-feed body ≥32 px, data labels ≥16/≥24 px) scaled up for a glanceable badge. Title-safe 90% / action-safe 93% is standards-based and should be treated as the harder constraint.
