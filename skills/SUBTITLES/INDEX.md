---
name: subtitles-index
description: Browsable map of the SUBTITLES rule library — all 52 notes, grouped by family, with a start-here path. The tag-free route into the library.
type: index
count: 52
---

# SUBTITLES — index

The **52 notes** in `skills/SUBTITLES/rules/` cover captions and on-screen text: what they look like, when each cue appears and for how long, which words get lifted, how cues behave at cuts, where they may sit in frame, and the mixed-script cases that break naive pipelines.

This library runs **last**. Emphasis treatments and positioning key off the cuts and the motion, so captions cannot honestly be designed before those exist. It is also the library mined chiefly from the HyperFrames install rather than from the KT videos — its specs are executable rather than theoretical, and `_meta/execution-contract.md` §6 is the authority on what is actually stylable.

**How it is organised.** Every note carries a `type/` and a `family/`. `skills/SUBTITLES/SKILL.md` routes by tag query; this page routes by browsing.

**By `type/`** — `caption-style` 27 · `caption-timing` 18 · `caption-motion` 7  
**By `difficulty/`** — low 1 · medium 26 · high 25  
**Families** — 21

The three `type/` values split cleanly: `caption-style` is what a cue looks like, `caption-timing` is when it exists, `caption-motion` is how it arrives and changes. Note the difficulty skew — half this library is `difficulty/high`, because caption work is where small numeric errors are most visible to a viewer.

---

## Start here

Eight notes, in this order.

1. **[[sub-caption-role-decision]]** — Decide what captions are *for* — emphasis layer, full track, or both — before styling a single one. Everything else branches off this.
2. **[[sub-timing-model-selection]]** — Word, phrase or hybrid. Chosen once, and every downstream cue rule depends on which you chose.
3. **[[sub-reading-speed-hard-cap]]** — The one genuinely hard constraint: 17–20 CPS, computed per cue. Over it, comprehension falls regardless of styling.
4. **[[sub-safe-area-and-caption-zone]]** — Where a caption may sit, in frame-height percentages, inside the platform's safe band. A caption behind the UI does not exist.
5. **[[sub-legibility-backing-ladder]]** — Stroke, shadow, plate or blur — pick one, and know the contrast floor it actually guarantees.
6. **[[sub-cue-segmentation-three-word]]** — The house segmentation: three-word cards off the transcript, then the timing repair pass.
7. **[[sub-emphasis-selection-rule]]** — Write the rule that picks the emphasised word, not the list of words. Rules reproduce; lists do not.
8. **[[sub-orthography-protection-no-autocorrect]]** — The mixed-script landmine. Romanised Hinglish tokens are not misspellings, and nothing in the pipeline may "fix" them.

---

## Notes by family

Families are ordered largest first.

### `family/kinetic-type` — 5 notes

Caption motion — entrances, per-word pops, bounce budget, and syncing to onsets.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-beat-synced-caption-motion]] | Sync caption motion to onsets and to emphasis, not to the beat grid | `caption-motion` | high |
| [[sub-entrance-exit-motion-budget]] | Captions enter in three to six frames on a gentle ease, and leave faster than they arrive | `caption-motion` | medium |
| [[sub-per-word-pop-scale-colour]] | Per-word pop — one property, four frames, and a scale step that does not reflow the line | `caption-motion` | high |
| [[sub-single-word-topic-card]] | Land the topic as one word, full frame, and clear the caption zone for it | `caption-motion` | medium |
| [[sub-spring-and-bounce-budget]] | Bounce is a register, not a default — budget the springy cues and keep overshoot off opacity | `caption-motion` | high |

### `family/caption-type` — 4 notes

The typography itself — face, size, weight, tracking and line height.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-size-as-frame-height-percentage]] | Size captions as a percentage of frame height — point sizes do not survive an aspect change | `caption-style` | medium |
| [[sub-tracking-and-caption-line-height]] | Track negative because the encoder eats letter detail, and lead tighter than a web page | `caption-style` | medium |
| [[sub-typeface-selection-for-captions]] | Choose the caption face on x-height, aperture and counter survival, not on personality | `caption-style` | medium |
| [[sub-weight-case-and-optical-size]] | One weight for the track, one cut above for emphasis — and sentence case by default | `caption-style` | low |

### `family/cue-limits` — 4 notes

The hard numbers a cue must satisfy — duration, reading speed, gaps, and what to do on overflow.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-cue-duration-floor-and-ceiling]] | Five-sixths of a second minimum, seven seconds maximum — and both ends are perceptual, not arbitrary | `caption-timing` | medium |
| [[sub-cue-splitting-on-overflow]] | Split the cue that breaks a cap — never shrink the type and never rewrite the words | `caption-timing` | high |
| [[sub-inter-cue-gap-and-chaining]] | Either chain the cues or leave two clear frames — one frame of gap is a defect | `caption-timing` | medium |
| [[sub-reading-speed-hard-cap]] | Reading speed is a hard cap — 17–20 CPS, computed per cue, and the research says why | `caption-timing` | medium |

### `family/mixed-script` — 4 notes

Romanised Hinglish and Devanagari — the branch most caption pipelines get wrong.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-hinglish-reading-rate]] | Romanised Hinglish reads slower per character — derive the rate cap from syllables, not from CPS | `caption-timing` | high |
| [[sub-mixed-script-hinglish-stack]] | Devanagari captioning is the exception branch — build the two-script stack only when the script is the requirement | `caption-style` | high |
| [[sub-orthography-protection-no-autocorrect]] | Nothing in the pipeline may correct the spelling — romanised tokens are not misspellings | `caption-style` | high |
| [[sub-romanised-hinglish-latin-face]] | Romanised Hinglish is a Latin-script problem — set it in one Latin face, not a fallback stack | `caption-style` | high |

### `family/accessibility` — 3 notes

Contrast floors, open versus closed captions, speaker and non-speech annotation.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-caption-contrast-accessibility]] | Hold 4.5:1 against the worst frame — WCAG does not cover burned-in captions, so you are the standard | `caption-style` | high |
| [[sub-open-vs-closed-captions]] | Burn in for the feed, ship a caption file for accessibility — the answer is usually both | `caption-style` | medium |
| [[sub-speaker-and-non-speech-annotation]] | Identify the speaker with a dash and a name, annotate sound in brackets — and know which text is not transcript | `caption-style` | medium |

### `family/alignment` — 3 notes

Getting word timings you can trust — forced alignment, offset correction, machine QC.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-alignment-qc-pass]] | Sanity-check the word timings before they become cues — five machine checks that fail the build | `caption-timing` | medium |
| [[sub-forced-alignment-word-timings]] | Forced alignment is what produces trustworthy word timings — ASR decoder timestamps are not | `caption-timing` | high |
| [[sub-latency-and-offset-correction]] | Measure the offset, correct it once globally, and only then go looking for drift | `caption-timing` | high |

### `family/caption-colour` — 3 notes

The colour system — six tokens, one meaning each, and the negation strikethrough.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-caption-colour-token-system]] | Six colour tokens, one accent, and never pure white | `caption-style` | medium |
| [[sub-red-strikethrough-negation]] | Red strikethrough marks a claim being negated — strike the words the speaker is rejecting | `caption-style` | medium |
| [[sub-semantic-colour-assignment]] | One colour, one meaning, held for the whole video — and never carried by colour alone | `caption-style` | high |

### `family/emphasis-caption` — 3 notes

Which words get lifted, how few of them, and the audit that catches over-emphasis.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-emphasis-caption-three-words]] | Captions are not visual variety — three words or fewer, only to make a word land | `caption-style` | medium |
| [[sub-emphasis-selection-rule]] | Write the rule that picks the emphasised word, not the list of words | `caption-style` | high |
| [[sub-over-emphasis-audit]] | Count the emphasis before you ship — over 15 % and the mark has stopped marking | `caption-style` | medium |

### `family/safe-area` — 3 notes

Where a caption may sit — platform UI bands, and collisions with the motion design.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-caption-graphic-collision]] | Cross-check the cue sheet against the motion design, and resolve every collision by moving the caption | `caption-motion` | high |
| [[sub-platform-ui-overlap-map]] | Map the platform UI band per destination — TikTok, Reels, Shorts and YouTube do not agree | `caption-style` | medium |
| [[sub-safe-area-and-caption-zone]] | Place captions by frame-height percentage inside the platform's safe band | `caption-style` | medium |

### `family/shot-change` — 3 notes

How cues behave at cuts — snapping, riding through, and fast-cut bursts.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-cut-boundary-policy]] | Break at the cut or ride through it — decide once, per role, and write it into the profile | `caption-timing` | high |
| [[sub-fast-cut-sequence-captions]] | In a fast-cut burst, stop snapping and let one held cue ride the whole sequence | `caption-timing` | high |
| [[sub-shot-change-snapping]] | Snap the cue to the cut when it lands within twelve frames of one | `caption-timing` | high |

### `family/timing-model` — 3 notes

Choosing word, phrase or hybrid, and assembling cues under the model you chose.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-phrase-cue-assembly]] | Assemble phrase cues on clause boundaries, then hand the timing back to the first and last word | `caption-timing` | high |
| [[sub-timing-model-selection]] | Pick the timing model — word, phrase or hybrid — before a single cue is cut | `caption-timing` | medium |
| [[sub-word-level-cue-generation]] | Build word-level cues from word onsets, and let the next onset end the cue | `caption-timing` | high |

### `family/caption-contrast` — 2 notes

Making captions legible against the worst frame — the backing ladder and plate geometry.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-caption-plate-geometry]] | Give the plate em-relative padding and radius so it scales with the type, and never let it clip | `caption-style` | medium |
| [[sub-legibility-backing-ladder]] | Pick one backing — stroke, shadow, plate or blur — and know the contrast floor each actually guarantees | `caption-style` | high |

### `family/caption-pipeline` — 2 notes

Producing and gating cues at volume — deterministic batches, burn-in versus sidecar.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-batch-generation-and-qc]] | Generate a long video's cues in one deterministic pass, then gate the build on a machine QC | `caption-timing` | high |
| [[sub-sidecar-timing-fidelity]] | Burn-in or sidecar — what each carrier can actually express, and what each costs | `caption-timing` | medium |

### `family/karaoke` — 2 notes

Holding a phrase and marking the active word inside it.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-active-word-treatment-palette]] | Choose which property carries "active" in a karaoke track — and change exactly one | `caption-style` | high |
| [[sub-karaoke-active-word-highlight]] | Hold a phrase, highlight the active word | `caption-motion` | high |

### `family/line-breaking` — 2 notes

Where the line breaks — syntax first, width only as a cap.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-line-length-and-line-count]] | Two lines maximum, 42 characters each — and validate the rendered box, not the string | `caption-style` | medium |
| [[sub-syntactic-line-breaking]] | Break the line on syntax, not on width — the break is a comprehension decision | `caption-style` | high |

### `family/caption-identity` — 1 note

The caption design expressed as a token set rather than a pile of CSS.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-caption-identity-token-set]] | Specify the caption identity as a token set, not as a pile of CSS | `caption-style` | medium |

### `family/caption-role` — 1 note

Deciding what captions are *for* before styling a single one.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-caption-role-decision]] | Decide the caption role before styling — emphasis layer, full track, or both | `caption-style` | medium |

### `family/cue-segmentation` — 1 note

Cutting the transcript into three-word cards, then repairing the timing.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-cue-segmentation-three-word]] | Segment the transcript into three-word cards, then repair the timing | `caption-timing` | high |

### `family/list-marker` — 1 note

The numbered-item marker as a typographic lockup.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-list-marker-caption-lockup]] | Set the numbered item marker as a typographic lockup, and mute the caption under it | `caption-style` | medium |

### `family/teaching-type` — 1 note

Putting the term on screen, not the definition.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-term-definition-lockup]] | Put the term on screen, not the definition | `caption-style` | medium |

### `family/verbatim-fidelity` — 1 note

Captioning the misspoken word verbatim so the correction can land.

| id | title | type | difficulty |
|---|---|---|---|
| [[sub-verbatim-misspeak-correction]] | Caption the wrong word verbatim, then let the correction land | `caption-timing` | medium |

---

## Also see

- `skills/SUBTITLES/SKILL.md` — the router: the two modes, the non-negotiables, and the tag queries.
- `INDEX.md` — the whole-vault map.
- `_meta/execution-contract.md` §6 — there is no caption primitive; this is what the engine actually gives you.
- `_meta/visual-kt-delta.md` — why the mixed-script requirement is *romanised* Hinglish and not Devanagari.
- Cross-skill: `skills/MOTION/INDEX.md` for the collision check against overlays and lower thirds.
