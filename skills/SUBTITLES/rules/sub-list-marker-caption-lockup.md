---
id: sub-list-marker-caption-lockup
title: Set the numbered item marker as a typographic lockup, and mute the caption under it
skill: subtitles
type: caption-style
family: list-marker
tags: [skill/subtitles, type/caption-style, family/list-marker, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:18"
    quote: "So in this video, we're gonna dive into 10 important editing cuts every filmmaker should know."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:45"
    quote: "Number two, the jump cut."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:01:17"
    quote: "Number three is the match cut."
research_refs:
  - https://tech.ebu.ch/docs/r/r095.pdf
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://sproutsocial.com/insights/social-media-video-specs-guide/
  - https://developer.mozilla.org/en-US/docs/Web/CSS/text-wrap-style
difficulty: medium
detectable_from: transcript+video
---

# Set the numbered item marker as a typographic lockup, and mute the caption under it

## What it is
A numbered list video marks every item verbally — "Number two, the jump cut", "Number nine is cross cutting" — and the on-screen text layer has to answer that marker exactly once, in one object. The object is a **lockup**: the numeral and the item name set as a single typographic unit with a fixed internal relationship (numeral one to three sizes larger than the name, or a fixed baseline offset, or a rule between them), placed in a reserved band and held for a fixed count. It is not a caption cue, and the caption track must get out of its way while it is up.

The caption-side rule that makes this work is the second half: **suppress the running caption track under the marker's hold**. The spoken words "Number two, the jump cut" are already on screen in bigger type. Captioning them underneath produces the same six words twice in one frame at two sizes, which is the most common list-video text defect and reads as a template that nobody looked at.

The motion of the lockup is owned elsewhere ([[motion-list-item-marker-card]], [[motion-persistent-item-counter]]); this note owns the type, the zone, the hold, and the caption suppression.

## When to use it
- Any video whose structure promises a count ("10 important editing cuts", "5 layers of sound") and marks the items verbally. Detect it from the transcript: an ordinal or "number N" pattern recurring at roughly regular intervals.
- Any listicle where the viewer's sense of progress is doing retention work — the count is a progress bar, and progress bars need to be visible, not only audible.
- **Full-frame card** when the item is a hard chapter break with a cut to a clean plate. **Lower-third lockup** when the item starts over live footage and the flow must not stop. **Persistent counter** (a small `3/10` in a corner) when items are short and frequent, ≥8 items under ~40 s each; it can coexist with either of the other two.
- **Do not** fire a lockup for a sub-item or an aside. If the numeral appears more than once per item, the count stops being trustworthy.
- **Do not** run one at all if the count is not spoken. An on-screen number the voice never confirms reads as a design element, not as structure.

## How to recognise it in a reference video
- **On the transcript**, regex the ordinal markers (`number \w+`, `first|second|third`, `\d+\.`). Note the timestamp of each. The intervals between them are the item lengths, and their regularity is the profile's rhythm.
- **Match each spoken marker to an on-screen object within ±0.5 s.** A marker with no visual is an unreinforced item; a visual with no spoken marker is decoration.
- **Classify the object.** Full-frame card = the picture is a dedicated plate, item name centred, nothing else on screen. Lower-third = footage continues behind, object occupies 15–30 % of frame height in the lower or left band. Persistent counter = small, corner-anchored, present between markers as well as at them.
- **Measure the hold.** Full-frame cards typically hold **1.2–2.5 s** (36–75 frames). Lower thirds hold **2.0–4.0 s**. A persistent counter holds for the whole item.
- **Measure the size ratio inside the lockup.** Numeral to item name is usually **1.6×–3×**; below 1.4× the numeral stops reading as a marker and the lockup reads as a headline.
- **Check the caption zone during the hold.** If the running track is visible and repeating the item name, log it as a defect. If the track is absent for the hold plus ~0.3 s either side, the suppression rule is in force.
- **Check the numeral's position stability** across items. A numeral that shifts horizontally between items (because the item name changed length) means the lockup is centred as a whole rather than anchored on the numeral.
- **Audio:** a marker card almost always carries a transient or a short whoosh at its in-point, and often a music-bar boundary.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `marker_form` | lower-third | full-frame / lower-third / counter | Choose once per video; mixing forms mid-list breaks the pattern. |
| `hold_full_frame` | 1.6 s (48 f) | 1.2–2.5 s | Long enough to read a numeral and 2–4 words; longer stalls the edit. |
| `hold_lower_third` | 3.0 s (90 f) | 2.0–4.0 s | Covers the spoken marker plus the first clause of the definition. |
| `in_offset_vs_marker` | −0.10 s (−3 f) | −0.20 to 0 s | Land just before the numeral is spoken so the voice confirms the visual. |
| `numeral_size` | 9 % of frame height | 7–14 % | 97–150 px at 1080p. In-feed headline floor is ≥90 px. |
| `name_size` | 4.5 % of frame height | 3.5–6 % | Item name. In-feed floor ≥32 px for anything body-weight. |
| `numeral_to_name_ratio` | 2.0× | 1.6–3.0× | Below 1.4× the numeral reads as part of the sentence. |
| `numeral_anchor` | fixed left/x | fixed | Anchor the numeral, let the name flow from it; do not centre the pair. |
| `lockup_zone_bottom` | 30 % of frame height | 24–42 % | Above the caption band, inside the 5 % graphics safe inset. |
| `caption_suppression_window` | hold + 0.3 s each side | 0.2–0.6 s pad | The track is hidden, not restyled. |
| `counter_size` | 2.2 % of frame height | 1.8–3 % | `3/10`, corner-anchored, inside action safe (3.5 %). |
| `counter_position` | top-left | top-left / top-right | On vertical, avoid the right action rail — top-left only. |
| `case` | UPPER for the name | upper / title | All-caps holds up to about 4 words at this size. |
| `tracking` | −0.03 em | −0.03 to −0.05 em | Display sizes; video encoding compresses letter detail. |
| `legibility_backing` | one treatment | plate / stroke / shadow | Exactly one, per the house rule. |

## Reproduction prompt

```
Build the numbered-item text layer for this list video.

1. EXTRACT THE MARKERS. Scan the transcript for ordinal markers ("number
   two", "third", "9."). For each, record marker_time (onset of the numeral
   word) and item_name (the noun phrase spoken immediately after it, verbatim,
   trimmed to <= 4 words).
2. BUILD ONE LOCKUP PER MARKER. Numeral at 0.09 * frame_height, item name at
   0.045 * frame_height, name UPPERCASE, tracking -0.03em, numeral anchored at
   a fixed x for every item so it never shifts between items. One legibility
   treatment only - a plate, OR a 2px stroke, OR a soft shadow.
3. TIME IT. in = marker_time - 0.10s. hold = 3.0s for a lower third, 1.6s for
   a full-frame card. Enter opacity 0->1 over 0.25s with an 18px y-rise, ease
   power3.out, numeral leading the name by 0.06s. Exit over 0.18s power2.in.
4. PLACE IT. Baseline at 0.30 * frame_height from the bottom, inside a 5%
   inset on every edge. On 9:16 keep clear of the right 16% action rail.
5. SUPPRESS THE CAPTION. Hide the running caption track from in-0.30s to
   out+0.30s. Do not restyle it, do not move it - hide it. Resume on the first
   cue boundary after the window.
6. OPTIONAL COUNTER. If the list has >= 8 items, add a persistent "N/TOTAL" at
   0.022 * frame_height, top-left, inside the 3.5% action safe inset, updating
   on each marker.

ACCEPTANCE TEST: every spoken marker has exactly one lockup within 0.5s, and
no lockup exists without a spoken marker. Snapshot mid-hold on three different
items: the numeral occupies the same x in all three, no caption cue is
visible, and no text crosses the 5% inset. Count the lockups - the total must
equal the number promised in the intro.
```

## Execution spec

**HyperFrames.** One clip per item, each a `div` with `data-start` and `data-duration` (both **required** on a `div` — without a resolvable duration the element stays visible for the rest of the composition). The lockup's internal motion is GSAP on the composition's single paused timeline.

```html
<div id="mark-02" class="clip" data-start="45.30" data-duration="3.00"
     data-track-index="5" data-layout-allow-caption-zone>
  <div class="lockup">
    <span class="num">02</span><span class="name">THE JUMP CUT</span>
  </div>
</div>
```

```js
const T = 45.30;                                   // marker onset − 0.10s
tl.fromTo("#mark-02 .num",  { autoAlpha: 0, y: 18 },
  { autoAlpha: 1, y: 0, duration: 0.25, ease: "power3.out" }, T);
tl.fromTo("#mark-02 .name", { autoAlpha: 0, y: 18 },
  { autoAlpha: 1, y: 0, duration: 0.25, ease: "power3.out" }, T + 0.06);
tl.to("#mark-02 .lockup", { autoAlpha: 0, duration: 0.18, ease: "power2.in" }, T + 2.75);
// caption track suppression for the same window
tl.set("#cap-stack", { autoAlpha: 0 }, T - 0.30);
tl.set("#cap-stack", { autoAlpha: 1 }, T + 3.30);
```

Contract points:
- **Animate the inner elements, not the clip.** `autoAlpha` and any `visibility`/`display` write on a `.clip` is rejected by lint; the framework owns clip visibility.
- **`fromTo`, never `from`** — `from()` writes its start state at construction with `immediateRender: true`, before the clip's `data-start` is active, so it flashes under the render's non-linear seek.
- **0.06 s stagger, not two hand-delayed tweens.** The rules contract caps an arrival at `items × stagger ≤ ~0.5 s` so it reads as one beat; two items at 0.06 s is well inside it. Entrances get `power3.out` (the house default); the caption fades that surround it stay on the gentle `power2` family.
- **Land the exit before `data-duration`** — the window is half-open (`2.75 + 0.18 = 2.93 < 3.00`).
- **Suppressing the caption track across a sub-comp boundary is not possible from inside the marker's sub-comp** — a sub-comp timeline cannot animate host-root elements and selectors do not cross the boundary. Either put the markers and the caption stack in the **same** composition, or drive the suppression from the **main** timeline at global time, or give the caption host its own `data-hidden` interval by splitting it into two hosts around the marker.
- **`data-track-index` is display only.** Stacking is CSS `z-index`; put the lockup above the caption track.
- **`data-layout-allow-caption-zone`** on the lockup is the right opt-out if it deliberately reaches into the caption band. It applies to descendants via `closest` and does not suppress overflow or occlusion audits.
- **Anchoring the numeral:** give `.num` a fixed `min-width` in `ch` or a fixed grid column so a one-digit and a two-digit numeral occupy the same box. A tabular-figures font feature (`font-variant-numeric: tabular-nums`) is the cheaper fix where the face supports it.
- **Fonts:** bundled families only under the egress allowlist (`Inter` is bundled but on the banned-monoculture list; Archivo Black, Oswald, League Gothic and Montserrat suit this register). Google Fonts is a network path and unavailable.
- **GSAP local, not CDN** — `cdn.jsdelivr.net` is blocked.
- If the list runs to a **storyboard**, `STORYBOARD.md` frames carry a `scene` and a `duration` key per item, which is the natural place to hold the item names and their hold lengths.

**ffmpeg.** A burned-in variant is `drawtext` with `enable='between(t,45.3,48.3)'`, `fontfile`, `fontsize`, `borderw` and `x`/`y` expressions — usable for a quick proof, but it cannot do the two-element stagger, so keep the real lockup in the composition.

**Epidemic Sound.** One transient per marker, and the same sound every time so the count is audible as a pattern: `SearchSoundEffects { query: { term: "impact hit ui confirm" }, filter: { duration: { max: 900 } } }`, placed at −12 to −15 dB on the lockup's in-frame. See [[sfx-cinematic-hit-emphasis]].

**Remotion.** A `<Sequence from={frame} durationInFrames={hold}>` per item wrapping a lockup component; the suppression is a prop on the caption component. Concept only.

## Pairs with
[[motion-list-item-marker-card]] · [[motion-persistent-item-counter]] · [[sub-safe-area-and-caption-zone]] · [[sub-term-definition-lockup]] · [[sub-caption-role-decision]] · [[struct-enumerated-promise-and-counter]] · [[struct-numbered-list-mid-roll-sponsor]] · [[sfx-cinematic-hit-emphasis]]

## Failure modes
- **The caption track repeats the item name under the lockup.** Same words twice in one frame at two sizes. Correction: hide the track for the hold plus 0.3 s either side.
- **Numeral drifts between items.** Centring the whole lockup makes the numeral move as names change length. Correction: anchor the numeral at a fixed x, tabular figures, fixed-width box.
- **Marker without a spoken cue.** The viewer's count and the screen's count diverge, and the promise made in the intro stops being trustworthy. Correction: one lockup per spoken marker, no more, no fewer, and count them against the promised total.
- **Hold too long.** A 5 s lower third over a 20 s item occupies a quarter of the beat and the eye stops seeing it. Correction: 2–4 s, out before the definition ends.
- **Numeral too small.** Below ~1.4× the name it is not a marker. Correction: 2× default.
- **Bouncy entry.** `back.out` / `elastic` on a structural marker reads cheap; overshoot is a rare explicitly-playful register, never the house style. Correction: `power3.out`, 0.25 s, 18 px rise.
- **Lockup in the right action rail on vertical.** Half the item name lives under the like button. Correction: place by frame-height percentage per [[sub-safe-area-and-caption-zone]] and keep clear of the right 16 %.
- **Known gap.** Nothing in the stack extracts ordinal markers automatically; the marker list is produced by the analysis pass from the transcript and written into the design document. There is also no cross-composition selector, so caption suppression must be planned into the composition architecture rather than bolted on.
