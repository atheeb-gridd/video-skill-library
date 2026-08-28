---
name: subtitle-spec
description: The SUBTITLE pass for vertical talking-head video. Spec-before-implement contract — identity block, timing model, cue sheet, emphasis map, collision check — then the HyperFrames caption implementation with everything inlined (no CDN), romanised-Hinglish handling, and frame-level verification before any render. Stage 5, runs last, in OUTPUT timecode.
type: reference
---

# Subtitle spec — vertical talking-head

Caption pass for 9:16 Instagram talking-head Reels. Executes `skills/SUBTITLES/SKILL.md` Mode B, fills `_templates/design-subtitles.md`, runs against `_meta/execution-contract.md` §6. Read `timebase.md` first — **every number here is OUTPUT timecode.**

Provenance markers, used inline and load-bearing:

| Marker | Means |
|---|---|
| **[C]** | Verified in `_meta/execution-contract.md` against staged HyperFrames files. It runs. |
| **[V]** | A default from a `skills/SUBTITLES/rules/` note, research- or reference-backed. A prior; a measured profile overrides it. |
| **[A]** | Asserted from general knowledge, or a platform figure that moves. Verify before it becomes a constraint. |

**Do not invent HyperFrames styling hooks.** The entire caption-adjacent framework surface is the layout audit's `--caption-zone` / `caption_zone_collision` finding, its opt-out `data-layout-allow-caption-zone`, and the guardrail that caption fades use `power1.out`/`power2.out` **[C]**. Everything else is your CSS and your GSAP.

## 1. Where this stage sits: last

Order is cuts → motion → sound → **subtitles**. Structural, not scheduling:

1. **Cues are stamped in OUTPUT time, which does not exist until the keep list locks.** A talking-head edit is subtractive; each removal shifts everything downstream earlier. Before `design-cuts.md` has a keep list a caption timestamp has no referent — not a wrong value, *no* value. Generate cues only from `transcript.out.json` (`timebase.md` §6).
2. **Emphasis keys off the cuts.** Snapping (±12 f **[V]**), break-vs-ride and the fast-cut-burst exception all take the cut list as input. Run earlier, they resolve against cuts the edit deleted.
3. **Position keys off the motion.** The caption band is the real estate lower thirds and markers want. The collision check (§6.4) is a join against `design-motion.md`.

Corollary: **any change to the cut list invalidates every cue here.** Do not hand-patch — push each cue through `out_to_src` on the old map, `src_to_out` on the new (`timebase.md` §2).

## 2. Spec before implement

Renders are the cost centre and cannot run on the device VM at all (§7.1), so every defect caught on paper saves a cloud round-trip and every defect missed costs a render + review + re-render.

| # | Artefact | Cheaper on paper because |
|---|---|---|
| 1 | **Identity block** (§3) | ~15 numbers applied to every cue. Changing one afterwards re-renders everything and voids every contrast and fit measurement taken against the old value. |
| 2 | **Timing model** (§5.2) | Word/phrase/hybrid changes the *shape of the data*, not a style value. Switching later means regenerating the cue sheet, discarding all emphasis and collision work. `model_changes_per_video: 0` **[V]**. |
| 3 | **Cue sheet** (§5.6) | Every hard gate — CPS, duration, gap, line fit — is arithmetic over `{text,start,end}`. Fully checkable with zero browser and zero render. |
| 4 | **Emphasis map** (§6) | Density is invisible in one frame and obvious in a column. Counting on paper is the only way the audit ever runs. |
| 5 | **Collision check** (§6.4) | A table join between two documents, one pass. Found in a render it means looking at the right frame at the right time — which nobody does. |

### 2.1 Definition of done for the spec

Complete when an agent could implement it with **no further questions**. Any box unchecked → no render is authorised.

- **Identity** — [ ] typeface named, confirmed bundled or local `@font-face`, never a Google Fonts import **[C: blocked network path]** · [ ] every weight is a real shipped cut (no synthetic bold) · [ ] size, position, box width, every offset as a **fraction of frame height/width**, with the px value at 1080×1920 shown · [ ] **exactly one** backing, with its measured worst-frame contrast ratio · [ ] colour tokens fixed, ≤3 hues, no pure `#ffffff`, no colour carrying meaning alone · [ ] active-word carrier named, and it is **one** property.
- **Timing** — [ ] model chosen with a one-line justification and the measured speech rate in wpm · [ ] which CPS cap binds (muted-first vs sound-on) recorded once · [ ] min/max duration, chain gap, sentence gap, in seconds with frame counts annotated · [ ] cut-boundary policy per role, with the snap window · [ ] source named: `transcript.out.json`, OUTPUT seconds, word-level.
- **Cue sheet** — [ ] every cue has `#`, in, out, text, lines, chars, CPS, treatment · [ ] zero over cap, zero under floor, zero over ceiling · [ ] zero gaps in the forbidden band (>0 and <2 f) **[V]** · [ ] longest cue checked for an orphan word · [ ] text byte-identical to the transcript, every deviation in the correction log.
- **Emphasis** — [ ] the **rule** is written, not the list, scannable, with a structural gate · [ ] counted: share, events/min, max run · [ ] share ≤15 %, rate ≤8/min, ≤1 mark per frame **[V]** · [ ] hand-overrides = 0.
- **Collision** — [ ] a row for every motion element whose window overlaps a cue window · [ ] every row resolved by moving the caption, never by `z-index` · [ ] platform UI bands reserved first.
- **Execution** — [ ] markup written with **no CDN reference anywhere** · [ ] snapshot timestamps chosen (≥8 spread, plus worst cue and every collision window) · [ ] render host named, and it is not the device VM.

## 3. The identity block

One block, fully specified, applied to every cue. Expressed as CSS custom properties — a token set, not a pile of rules **[V]**.

**Why % of frame height, never points.** A point size is a claim about physical output, which video does not have. `font-size: 48px` is 4.5 % of a 1080-tall frame and 2.5 % of a 1920-tall one — one number, two designs, no warning. **[C]** `--resolution` supersamples via Chrome's `deviceScaleFactor` and needs an integer scale and matching aspect; it is not a reframe. Author fractions of `--fh`, let `calc()` resolve at build. One absolute floor survives: **in-feed body type never below 32 px [C]**.

| Field | Token | Default (9:16 Reels) | Range | Note |
|---|---|---|---|---|
| Typeface | `--cap-font-family` | Montserrat | one bundled family or local `@font-face` | Inter is bundled and on the project's **banned monoculture list** **[C]** |
| Track weight | `--cap-weight` | 700 | 600–800 | Must be a shipped cut; drop one step on a dark ground **[V]** |
| Emphasis weight | `--cap-weight-em` | 900 | 800–900 | Exactly one cut above the track; 2 cuts total, max |
| Size | `--cap-size` | **5.0 % of H** = 96 px @1920 | 4.5–8 % in-feed | Floor 32 px absolute **[C]** |
| Case | `--cap-case` | sentence | sentence / upper | All-caps degrades past ~4 words **[V]** |
| Tracking | `--cap-tracking` | −0.04 em | −0.03 to −0.05 em | Encoding compresses letter detail **[C]**; floor −0.06 em, past it `rn` reads as `m` |
| Line height | `--cap-leading` | 1.22 | 1.15–1.30 | Latin band; +0.05–0.1 on dark grounds **[C]** |
| Resting colour | `--cap-text` | `#f5f0e0` | L\* 92–97 | Never pure white — clips SDR headroom, blooms **[V]** |
| Accent | `--cap-accent` | one hue, from the video's own grade | 1 (2 max) | Two accents is no accent |
| Negate | `--cap-negate` | red at L\* 45–55 | — | §6.3; ≥3:1 against the text it crosses |
| Dim | `--cap-dim` | 0.75 × resting **luminance** | 0.60–0.85 | Dim by colour, never opacity — opacity thins the backing too |
| Backing | `--cap-backing` | **shadow halo** | exactly one of plate/stroke/shadow/blur | Stacking two is a hard violation **[V]** |
| Stroke | — | 0, unused | 0.04–0.09 em if chosen | Honest floor: inside a counter there is no stroke, so stroke guarantees nothing **[V]** |
| Shadow | `--cap-shadow` | 3 layers, offset 0, blur 0.22 em, `rgba(0,0,0,.85)` | blur 0.15–0.5 em | At offset 0 it behaves as a soft stroke, beating an offset shadow |
| Plate | `--cap-plate` | `transparent` | `#0d0c0b` α0.85 if escalated | Pad 0.25/0.67 em, radius 0.5 em — **em, so it scales with the type** |
| Active word | `--cap-active` | dim-the-rest, one property | dim/colour/box/sweep/scale | Never `weight` — it reflows the line |
| Position | `--cap-bottom` | **0.22 × H** = 422 px @1920, box **bottom edge** | 0.16–0.26 H | §4 |
| Box width | `--cap-max-width` | 80 % of W | 70–86 % | Also clears the right action rail on a centred box |
| Chars/line | — | **24** English / **20** Hinglish | 20–28 | Romanisation inflates counts ≈0.85× **[V]**; validate the **rendered box**, not the string |
| Lines | — | **1** preferred, **2** ceiling | 1–2 | Three lines cannot be read inside a legal cue duration |

Worked identity — talking-head Reel, 1080×1920:

```
family      Montserrat 700 track / 900 emphasis, local @font-face woff2, unicode-range U+0000-00FF
size        0.050 x 1920 = 96px      case sentence, terminal '.' omitted, '?' '!' kept
tracking    -0.04em (-3.84px)        line-height 1.22
colour      #f5f0e0 resting | accent #ffc94a | negate #e2453b | dim #b9b3a2
backing     text-shadow x3, offset 0, blur 0.22em (21px), rgba(0,0,0,.85)
            -> measured 5.1:1 worst frame vs the darkest shirt tone in the grade
            -> any sampled frame under 4.5:1 -> escalate to plate #0d0c0b @0.85, re-measure
active word dim-the-rest: current+unspoken #f5f0e0, already-spoken #b9b3a2
            redundancy: the active word is the leftmost undimmed one
position    box bottom edge 0.22 x 1920 = 422px from frame bottom; box max-width 80% = 864px
line budget 24 chars EN / 20 HI, 1 line preferred, 2 max, balance ratio <= 1.6
```

Two deliberate departures from the vault priors: **no plate**, because the track is chained 3-word cards and a plate resizing on every swap is a jumping rectangle; **0.22 H** rather than the 0.20 H prior, because the *box bottom edge* must clear the band — measuring the baseline under-reports by the descender plus the padding **[V]**.

## 4. Vertical safe areas

Three stacked, non-identical constraints **[V]**: **broadcast safe area** (EBU R 95 — 5 % graphics, 3.5 % action inset; an overscan tolerance, weak and far smaller than any platform band); **platform UI** (an *occlusion* — the app paints opaque chrome over your video); **composition collision** (§6.4).

**A caption behind platform UI does not exist.** It renders, passes `check`, burns into the MP4, and no viewer reads it. There is no error message. It is the commonest avoidable caption defect.

| Destination | Bottom | Top | Right rail | Confidence |
|---|---|---|---|---|
| **Instagram Reels** | **~20 % of H** (≈340 px of 1920) | **~14 %** (≈250 px) | ~16 % of W | **[V]** — Instagram's own published guidance; the only platform with a published figure |
| TikTok | ~18–22 % | ~12 % | ~18 % of W | **[A]** — deeper description block, runs to 2–3 lines |
| YouTube Shorts | ~15–18 % | ~10 % | ~14 % of W | **[A]** — shallower chrome, but the title expands on tap |
| YouTube 16:9 in-player | ~12 % (≈22 % with viewer CC on) | ~0 | ~0 | **[A]** — the player's own CC stacks on a burned-in track |

**These do not agree and none is stable** — they move with app releases. Treat the table as a prior with a shelf life. **Union-safe single master:** max of each band → bottom **22 %**, top **14 %**, right **18 %**, one 9:16 master safe everywhere at a cost of ~4 % of caption real estate **[V]**. Reels-only → 0.22 H box bottom edge; multi-destination → 0.24 H.

**Verify rather than trust.** The chrome is invisible in a raw export. Screen-record playback on a real device, then measure:

```bash
ffmpeg -nostdin -y -ss 3.0 -i reels_screenrec.mp4 -frames:v 1 -update 1 ui.png
# bottom band = (H - y_top_of_highest_bottom_UI) / H ; top band = y_bottom_of_lowest_top_UI / H
# right rail  = (W - x_left_of_action_rail) / W
```

Re-measure whenever the destination list changes — a video cut for YouTube and reposted to Reels is the commonest way a caption lands behind a username.

**Placement.** (1) `H = data-height`, `W = data-width`; all offsets are fractions. (2) Mark forbidden: top 0.14 H, bottom 0.20 H (Reels) or 0.22 H (union), right 0.16–0.18 W. (3) Track box bottom edge at 0.22 H, `max-width: 80%`, centred, clearing the band by ≥0.02 H — measure the **box**, not the baseline. (4) Emphasis layer at 0.28–0.30 H with ≥0.04 H of air between boxes wherever both are visible. (5) Every glyph also inside the 5 % EBU inset — meeting title-safe while failing the Reels band is the common outcome. (6) Dodges (§6.4) move the whole track +0.10 H, 0.30 s, `power2.out`, **on a cue boundary, never mid-cue**, once per graphic window.

`caption_zone_collision` is the framework telling you this section was skipped — fix the position. `data-layout-allow-caption-zone` is a narrow opt-out for a *deliberate* lower third; it covers descendants via `closest` and suppresses nothing else **[C]**. Never use `data-layout-allow-overflow` — its blast radius is the whole subtree and it also silences `text-clipping` and `content-cramped-container` **[C]**.

## 5. Timing model

**5.1 Source.** Word-level timestamps from `transcript.out.json` — re-timed to OUTPUT seconds, split at cut boundaries, bisected words already dropped at the <50 %-survival rule (`timebase.md` §6). Nothing else drives timing **[C]**: *"The word timestamps in the inlined `script` array — nothing else. There is no external transcript read at runtime, no audio analysis, no `audio.currentTime`."* Prefer forced alignment over raw ASR decoder timestamps, and QC before cutting cues: monotonic (`start[i] < end[i] <= start[i+1]`), word duration 0.05–1.20 s, global offset within ±0.045 s, drift <0.001 s/s, outliers ≤2 % of words **[V]**.

**5.2 The three models.**

| Model | Generated from word timestamps by | Words/cue | Changes /10 s | Read-ahead |
|---|---|---|---|---|
| **Word-level** | one cue per word or ≤3-word card; start = word onset, **end = next onset** (chained, gap exactly 0); sentence-final cards take a tail hold | 1–3, mean 2.4 | 18–40 | none |
| **Phrase-level** | group on clause boundaries, then hand timing back to members: start = first word's start, end = last word's end + tail hold. Split on measured width, never a fixed word count | 5–14 | 3–7 | 0.8–1.5 s |
| **Hybrid** | phrase card held, active word marked inside it from the same onsets | 5–14 held | 3–7 | 0.8 s |

**[C]** The staged reference groups with *a fixed `for` loop, 5 words per line* — a placeholder, not a rule **[V]**. Group by measured rendered width. **Default for talking head: chained 3-word cards** (word-level family) — one continuous speaker at conversational rate, so the chain buys per-word sync at no read-ahead cost. **Switch to hybrid above 200 wpm** measured speech rate **[V]**: above that, cards swap faster than they can be read and the phrase must sit still while the highlight moves.

**5.3 Reading speed — the hard cap.** On-screen characters (including spaces, punctuation, speaker prefixes, bracketed annotations) over display seconds. The only caption constraint that is a *comprehension* limit. **Enforce per cue and fail the build; never ship a track mean.**

Published: Netflix English Timed Text **20 CPS adult / 17 CPS children's**; DCMP 130/140/160 wpm by reading level **[V, research-backed]**. Szarkowska & Gerber-Morón tested 12/16/20 CPS with eye tracking and found **no significant comprehension effect at any tested speed**; what changed was behaviour — viewers re-read about two of every three subtitles at 12 CPS versus about one in five at the faster speeds. So **the cap is a ceiling, not a target**: no benefit to sitting far under it, and spare display time is spent re-reading instead of watching the picture.

| Deliverable mode | Cap | Binding because |
|---|---|---|
| **muted-first** (silent autoplay) | **17 CPS** | the caption is the sole carrier of meaning |
| **sound-on** chained word-level | **30 CPS** | the caption is a redundant channel reinforcing audio the viewer hears |

Record the mode once in the identity block. Chained short-form routinely measures 25–35 CPS — above every published cap and not automatically wrong, until the deliverable is muted-first. **Over cap: (a) split at the best syntactic point so both halves clear; (b) extend the hold only if there is room before the next cue.** Never shrink the type. Never rewrite the words — verbatim is correctness, not style.

**5.4 Duration, gaps, chaining [V].**

| Constraint | Value |
|---|---|
| Min duration, isolated (box fades in/out) | **0.833 s** (5/6 s: 20 f @24, 25 f @30) — Netflix minimum event |
| Min duration, chained (swap only) | **0.20 s** (6 f @30); comfortable 0.30 s (9 f) — below it the swap is a flicker |
| Max duration | **5.0 s** speech; 7.0 s hard ceiling for non-speech |
| Tail hold at sentence end | 0.55 s (0.35–0.90) |
| Chain gap within a sentence | **exactly 0** — `cue[n].end === cue[n+1].start`, full float precision |
| Sentence gap at `.` `?` `!` | 0.20 s (6 f @30); paragraph / pre-card 0.60 s |
| **Forbidden gap band** | **>0 and <2 frames — hard fail.** Snap to 0 or to ≥2 f |
| Fade in / out | 0.10 s `power2.out` / `power2.in`, **only** at the first cue after a gap and the last before one. **Never crossfade a chained handover** — hard `set` |
| Rounding | snap to the frame grid **once, at the end**, then re-test the gaps |

A cue must clear the duration floor **and** the CPS cap simultaneously. Short-cue repair: merge into the neighbour with fewer words, extend only if merging breaks a cap. Long-cue repair: trim the tail, then split — never leave a stale cue up.

**5.5 The cut-boundary rule — the talking-head case.** Two policies, chosen per role and written into the profile **[V]**: **break** (cue clears at the cut, next starts after a 0.20 s gap) or **ride** (cue holds across unchanged).

**For a talking head the default is RIDE, and it matters more here than in any other format.** A talking head is built out of jump cuts that remove filler, breaths and retakes mid-sentence — that is what the subtractive edit *is*. Those are **coverage cuts**: the shot changed, the thought did not. A cue that breaks there reads as a **stutter**, because the viewer sees text blink out and back inside one spoken clause — the visual signature of a mistake, even when the audio is seamless. Break only at **content cuts**, where the thought changes; in a talking head those usually coincide with a sentence boundary, which the sentence gap already handles.

| Situation | Policy | Why |
|---|---|---|
| Filler/breath removal mid-sentence | **ride** | coverage — the clause is continuous |
| Punch-in / reframe | **ride** | same shot; breaking there is almost always wrong |
| B-roll cutaway over continuous VO | **ride** | the speech never stopped |
| Section change / new claim | **break** | the thought changed, so should the cue |
| Fast-cut burst (≥3 cuts in one clause) | **ride, one held cue** | stop snapping — snapping inside a burst strobes the text |
| Emphasis-layer caption | **ride always** | bound to a word, not to a shot |

**Snapping:** a cue boundary within **12 frames (0.40 s @30)** of a cut snaps to it — starts back to the cut so text appears with the new shot, ends to the cut so it clears as the shot changes and never trails into the new one **[V]**. Two vetoes: a snap may not put text up more than 2 f before its first word (voice sync outranks picture sync), and may never push a cue into a duration-floor or CPS violation. With no measured classification, fall back to: median shot length >2.5 s → break, below → ride. Log every deviation.

**5.6 The cue sheet** — the deliverable, in OUTPUT seconds to three decimals. Columns computed, not typed; `chars` counts every rendered glyph including spaces and punctuation; `cut` records ride/break/snap for any cue whose window contains a cut.

```
| #   | in    | out   | text          | lines | chars | cps  | syll/s | treatment     | cut  |
| 001 | 0.000 | 0.480 | parr naam kya | 1     | 13    | 27.1 | 6.2    | -             | -    |
| 002 | 0.480 | 1.020 | search karu?? | 1     | 13    | 24.1 | 3.7    | accent:search | ride |
```

## 6. The emphasis rule

**6.1 Write the rule, not the list.** A list does not transfer to the next video; a rule does, and a rule can be **counted**. Four properties **[V]**: **scannable from the transcript** (parts of speech, semantic category, structural position — "nouns naming a thing the viewer must remember" is scannable, "the important bits" is not); **exclusive**, with a hard **structural gate** — one per sentence — because a per-unit cap bounds the rate regardless of content; **reproducible** (a second independent pass disagreeing by >15 % means it is underspecified); **survives being wrong occasionally** — a rule needing case-by-case override is a list with extra steps.

Default rule, priority order: **1. the named term** (the label the section uses afterwards; one per section, **first mention only**) · **2. the quantity** (a number with a unit the viewer might act on — `−3 dB`, `120 BPM`; number and unit are **one** unit, never split) · **3. the promise/payoff noun** · **4. the negated claim**, which takes a different mark entirely (§6.3). Everything else defaults to no emphasis. Deliberately absent: **verbs, adjectives, intensifiers** ("really", "massively", "huge"), profanity. Intensifiers are the single biggest source of inflation — they *sound* emphatic so the editor reaches for the accent, but they carry nothing the viewer must retain and the audio already delivered the emphasis.

**6.2 The counting discipline.** Density is invisible in a frame and obvious in a column. Count with a script — manual counting under-counts by about a third **[V]**.

| Metric | Target | **Hard fail** |
|---|---|---|
| Emphasised words / total words | 8 % | **>15 %** |
| Events per minute of speech | 5 | **>8** |
| Consecutive marked cues | ≤2 | >4 |
| Gap between marks | ≥2.0 s, ≤45 s | <1.2 s reads as a caption track starting; >90 s and the code has decayed |
| Distinct treatments | 1 | >2 |
| Simultaneous marks in one frame | **1** | >1 |
| Hand overrides | **0** | each is evidence the rule is wrong |

**Above 15 %, the mark has stopped marking.** On a fail, **tighten the rule and re-run** — never hand-prune, which produces an unreproducible list and hides that the rule was wrong. Audit twice: after rule application, and after final review. Colour never carries meaning alone — ~8 % of males have red-green deficiency, so every hue distinction needs a redundant non-colour cue.

**6.3 Red strikethrough as negation.** One of this user's reference creators uses this consistently. It is a **distinct code**: the speaker is rejecting a proposition and the strike cancels it on screen **[V]**.

| Parameter | Value |
|---|---|
| Trigger | an **explicitly rejected proposition** — not "unimportant", not "negative", not "deleted" |
| Extent | the rejected clause only, not the sentence containing it |
| Budget | **2 per video** (1–3). Above 3 it stops being a mark |
| Onset | +0.08 s (2–3 f) *after* the rejected phrase completes. **Never negative** — an early strike spoils the beat |
| Hold | 1.2 s (0.8–2.0) |
| Line | `--cap-negate`, thickness 0.08 em (~4 px at 48 px type), ≥3:1 against the text it crosses |
| Draw-on | `scaleX` 0→1, `transform-origin: left`, 0.25 s, `power2.out` |
| Redundancy | **the line, not the colour**, carries the meaning |
| Never | fire with a misspeak gag on the same beat; colour a struck word with `--cap-accent` |

Implementation-deciding fact: **`text-decoration-line` is discrete and non-animatable** — GSAP snaps it from `none` to `line-through` at 50 % progress. `-color` and `-thickness` are animatable; the line's existence is not. Static strike → `text-decoration-line` **with `text-decoration-skip-ink: none`** (the default breaks the line around descenders and reads as a rendering bug). Animated strike → a **real child `<span class="strike-bar">`** scaled on X; GSAP cannot target a pseudo-element, and a real element is seek-safe. Use `fromTo`, never `from` — `from()` sets `immediateRender: true` and writes its start state at construction, before the clip's `data-start` is active **[C]**.

**6.4 The collision check.** A join between the cue sheet and `design-motion.md` on **x, y and t** — time is the dimension people forget. Clearance ≥**4 % of frame height** between simultaneously visible text objects. Resolution order: **move the caption → shorten it → suppress it → change the graphic** (the graphic moves last, and only as a request). **`z-index` is not a resolution** — layering just chooses which element you lose. Check the graphic's **entrance window**, not only its held state. Move **per graphic window, never per cue** (per-cue repositioning is jitter): 0.30 s translate on `y`, `power2.out`, starting on a cue boundary. Suppression is legal only if the graphic itself carries the words; otherwise it is a missing caption. Re-run the whole check on any change to **either** document.

## 7. HyperFrames implementation

**7.1 The three constraints that shape every line. [C] — record verbatim.**

1. **`cdn.jsdelivr.net` is blocked by the egress allowlist.** A composition loading GSAP — or any library — from a CDN renders **BLANK**, with a `sub_timeline_script_failure` warning **[A: the block is verbatim from the contract; the warning name is from the operator, not found in the staged files]**. The staged `compositions/captions.html` ships `<script src="https://cdn.jsdelivr.net/npm/gsap@3.14.2/...">` and **that exact line is broken in this project**. Vendor GSAP locally, load from a relative path. Fonts too: the implicit Google Fonts fetch is a network path — bundled family or local `@font-face` only. **Everything inlined or local. No exceptions.**
2. **The device VM is linux ARM64 without sudo** — no Chrome Headless Shell build. `render`, `snapshot`, `preview`, `play`, and the layout/contrast/motion audits inside `check` are browser-dependent and **cannot run there.** Author, lint statically and plan on the VM; run every browser-backed step in the cloud container. A spec may specify a render but must never assume it happens on the authoring machine.
3. **The mounted vault folder cannot delete files.** Supersede, never delete; keep scratch outside the mount.

**7.2 The caption model. [C]** **There is no caption primitive** — no `data-caption`, no SRT/VTT ingest, no built-in subtitle renderer. A caption is an ordinary composition (usually a sub-composition) whose GSAP timeline writes text and animates a box. Timing chain: `transcript.out.json (word-level, OUTPUT s) → inlined array → grouped into cues → cue.start/end become GSAP timeline positions in SECONDS`. All authored time is seconds; there is no frame attribute — express a frame count as a derived comment and author the seconds (12 f @30 = `0.4`). Everything is stylable, because it is CSS. Two reference values you must **change**: `white-space: nowrap` + `overflow: hidden` silently clips a long line instead of wrapping — use `white-space: normal; overflow: visible` and let segmentation shorten the cue **[V]**.

The single-element pattern's known cost **[C, flagged as an observation on the code]**: one box reused with text set in an `onStart` callback means a **backwards seek**, or a seek landing between cues, does not necessarily restore the correct text — `onStart` fires on forward entry only. **The seek-robust alternative is one element per cue with per-cue opacity envelopes, and that is what this spec uses.** Split into per-scene sub-compositions above ~600 cues **[V]**.

**7.3 Markup skeleton — everything inlined.**

```html
<!-- compositions/captions.html — sub-composition form: root IS wrapped in <template>.
     The assembler drops this file's own <head> <style>/<script>, so both live INSIDE the template. -->
<template id="captions-template">
  <div data-composition-id="captions" data-width="1080" data-height="1920" data-duration="42.5"
       style="--fh:1920px; --fw:1080px;">
    <div class="captions-container">
      <!-- one element per cue: seek-robust. ids prefixed with the composition id. -->
      <div class="cap-cue" id="captions-c001" lang="hi-Latn" spellcheck="false" translate="no">parr naam kya</div>
      <div class="cap-cue" id="captions-c002" lang="hi-Latn" spellcheck="false" translate="no">search <span class="em">karu</span>??</div>
    </div>
  </div>

  <style>
    /* EVERY rule scoped to the composition id, or it leaks across the assembled page. */
    @font-face{ font-family:"Montserrat"; font-weight:700; font-display:block; unicode-range:U+0000-00FF;
      src:url("../assets/fonts/Montserrat-Bold.woff2") format("woff2"); }  /* LOCAL. never Google Fonts. */
    @font-face{ font-family:"Montserrat"; font-weight:900; font-display:block; unicode-range:U+0000-00FF;
      src:url("../assets/fonts/Montserrat-Black.woff2") format("woff2"); }
    [data-composition-id="captions"]{
      --cap-text:#f5f0e0; --cap-accent:#ffc94a; --cap-negate:#e2453b; --cap-dim:#b9b3a2;
      --cap-size:calc(0.050 * var(--fh));    /* 96px @1920 */
      --cap-bottom:calc(0.22 * var(--fh));   /* 422px @1920 — clears the Reels 20% band */
      position:absolute; inset:0;            /* untimed full-bleed needs its own box */
    }
    [data-composition-id="captions"] .captions-container{
      position:absolute; inset:0; display:flex; justify-content:center; align-items:flex-end;
      padding-bottom:var(--cap-bottom); pointer-events:none; }
    [data-composition-id="captions"] .cap-cue{
      position:absolute; bottom:var(--cap-bottom); max-width:80%;
      font-family:"Montserrat", sans-serif; font-weight:700;
      font-size:var(--cap-size); line-height:1.22; letter-spacing:-0.04em;
      color:var(--cap-text); text-align:center;
      white-space:normal; overflow:visible;  /* CHANGED from the reference's nowrap/hidden */
      hyphens:none; -webkit-hyphens:none;
      text-shadow:0 0 .22em rgba(0,0,0,.85), 0 0 .22em rgba(0,0,0,.85), 0 0 .22em rgba(0,0,0,.85);
      opacity:0; visibility:hidden; }
    [data-composition-id="captions"] .cap-cue .em{ font-weight:900; color:var(--cap-accent); }
    [data-composition-id="captions"] .cap-cue .dim{ color:var(--cap-dim); }
    [data-composition-id="captions"] .cap-cue .negated{ position:relative; }
    [data-composition-id="captions"] .cap-cue .strike-bar{
      position:absolute; left:0; right:0; top:54%; height:.08em;
      background:var(--cap-negate); transform:scaleX(0); transform-origin:left center; }
  </style>

  <!-- GSAP VENDORED LOCALLY. A CDN src here renders the whole composition BLANK. -->
  <script src="../vendor/gsap/gsap.min.js"></script>

  <script>
  (function () {
    // Cue sheet inlined, OUTPUT seconds to three decimals, generated from transcript.out.json.
    const cues = [
      { id:"captions-c001", start:0.000, end:0.480, chain:true  },
      { id:"captions-c002", start:0.480, end:1.020, chain:false }
    ];
    const FADE = 0.10;  // 3f @30. power2.out in / power2.in out — the gentle caption eases.
    const tl = gsap.timeline({ paused: true });
    for (const c of cues) {
      const el = "#" + c.id;
      if (c.chain) {                                  // chained handover: hard set, never a crossfade
        tl.set(el, { autoAlpha: 1 }, c.start);
        tl.set(el, { autoAlpha: 0 }, c.end);
      } else {
        tl.set(el, { visibility: "visible" }, c.start);
        tl.to (el, { opacity: 1, duration: FADE, ease: "power2.out" }, c.start);
        tl.to (el, { opacity: 0, duration: FADE, ease: "power2.in"  }, c.end - FADE);
        tl.set(el, { opacity: 0, visibility: "hidden" }, c.end);  // legal: .cap-cue is NOT the clip element
      }
    }
    window.__timelines["captions"] = tl;  // exactly one paused timeline, keyed by the root id
  })();
  </script>
</template>
```

Binding contract points, each a guaranteed failure if ignored **[C]**: exactly **one** `gsap.timeline({paused:true})` per composition keyed by the root's `data-composition-id`, registered only after the build completes (building inside `document.fonts.ready` is supported and is the right hook for a webfont caption face) and **never inside `async`/`setTimeout`/`Promise`** · **do not manually nest sub-timelines** — the runtime auto-nests registered children · **never tween `display` or raw `visibility` on a clip element**; the `tl.set(...,{visibility})` above is legal only because `.cap-cue` is not the clip (the clip is the sub-comp host) — use `autoAlpha` otherwise · **the visibility window is half-open** `[start, start+duration)`, so land the final state slightly *before* the root `data-duration` or its last frame never renders · **root `data-duration` is compile-time-locked** (compute from the last cue's end plus its fade; scripts and `--variables` cannot change render length) · **no CSS `transform` on an element GSAP also transforms** → `gsap_css_transform_conflict` · no `<br>` in body text, no render-time clocks, no unseeded randomness, no `repeat:-1`, and ambient motion attaches to `tl`, never a bare `gsap.to()` · **ids unique across the assembled page** — prefix with the composition id · host from `index.html` via `data-composition-src` + `data-start` + `data-duration` + `data-track-index="1"` (layering is CSS `z-index`; track index is display-only), and cue times inside the sub-comp are **scene-local**: global time = scene-local + the host's `data-start`.

**7.4 Verify on single frames, not full renders.** A full render is the expensive operation and teaches almost nothing a frame would not.

```bash
npx hyperframes lint --verbose      # static rules only — runs anywhere, incl. the device VM
npm run check                       # lint + runtime + layout + motion + contrast. Target: 0 findings
npx hyperframes snapshot --at 1.2,4.8,9.6,14.1,19.3,24.7,31.0,38.4   # then LOOK at each frame
npx hyperframes preview --background  # review surface; --status to confirm, --stop when done
npx hyperframes render              # ONLY after the user has reviewed and approved
```

**The `npm run check` gate and its trap. [C]** `check` is the composite gate — lint + runtime + layout + motion + contrast — target *0 findings*: fix all errors before presenting a result, review warnings before rendering. The trap: **a lint *error* switches off the layout and contrast audits**, and `check` then reports `0 sample(s)` and `0/0 text checks` — which reads like a clean file and means nothing ran. Clear lint errors first, then trust the layout findings, never the reverse. `snapshot` is **required** for projects with sub-compositions and is the only real defence against the silent root-sizing bug (a flex child collapsing to ~0, content piling into the top-left) and the silent relative-timing zeros. Choose timestamps deliberately: ≥8 spread, **plus** the worst cue by CPS, the longest cue, every collision window, one frame inside every dodge. **Do not auto-render when checks pass.**

## 8. Romanised Hinglish

This user's references burn in **romanised Hinglish in Latin script** — `parr naam kya search karu??` — not Devanagari. That removes one problem and creates three.

**8.1 One face, not a fallback stack.** The script is Latin, so **no script fallback is needed, and a stack is a liability** — it can only introduce a silent mid-line face swap. Specify **exactly one family plus a generic**, `unicode-range: U+0000-00FF` (Basic Latin + Latin-1) **[V]**. The range is a **guard, not an optimisation**: if Devanagari slips into a string, restricting the range renders it as tofu — visible and fixable — instead of silently falling back to a system face at a different weight. Do not load a Devanagari face for a romanised deliverable. Set `lang="hi-Latn"` (BCP 47 for Hindi in Latin script): no rendering effect on a Latin-only face, but it documents intent and is the correct hook for any future locale-sensitive pass.

**8.2 Nothing may correct the spelling.** Romanised Hindi has **no standard orthography**. `parr`, `par` and `pr` are all legitimate spellings of one word; so are `karu`, `karoon`, `karun`. The absence is structural — the convention grew from Roman-keyboard typing practice, not a spelling authority — and it will not be resolved. To any English-language tool each of those is a misspelling, so **every text-touching layer will try to fix it**: ASR post-processing, editor/CMS/browser spell-check, OS autocorrect, an LLM asked to "tidy the transcript", a localisation step that detects English and normalises, smart quotes rewriting `??`, title-casing heuristics that have never seen `naam`. Each is individually reasonable and collectively catastrophic, because **the failure is silent and plausible**: `parr` → `part` yields a real English word in a grammatical position. Nobody reviewing notices, and the caption now says something the speaker did not say — compare a missing glyph, which is obvious. This is a **correctness bug**, not a style preference: the skill's non-negotiable is verbatim text, and a romanised spelling is *never* a clear ASR error. It is the transcript.

Enumerate every stage between microphone and rendered frame, name what each does to text, then set:

| Control | Value |
|---|---|
| `spellcheck` / `translate` | `false` / `no` on the caption element, explicitly — blocks browser and extension rewriting |
| `hyphens` | `none` — the hyphenation dictionary has no model of these tokens |
| ASR post-processing | **raw word-level output only.** A "cleaned" transcript is already corrupted |
| LLM transcript pass | **forbidden.** If unavoidable, diff every token and log every change |
| Smart punctuation / title-casing | off. `??` must survive; `--` must not become an em dash; no capitalisation heuristic touches the string |
| `text-transform` | CSS only. Uppercasing in JS destroys the record |
| Unicode normalisation | NFC, **once**, at ingest, never again |
| Protected token list | maintained: proper nouns, product names, technical tokens, deliberate misspeaks |
| Correction log | required in `design-subtitles.md`, every deviation with a reason |
| Verification | **byte diff** of rendered `textContent` vs transcript source — not a visual check |

**Variation is signal, not error.** Two spellings of one word across cues is probably authentic. Do not reconcile them.

**8.3 Word-boundary and spell logic must tolerate non-dictionary tokens.** Anything that segments, hyphenates, capitalises or line-breaks by consulting a dictionary behaves badly on tokens that are not in it — **and it looks like a layout bug**, which sends the fix in the wrong direction. Concretely: **never use an English syllabifier** (it fails on exactly these tokens) — count syllables as **vowel groups**, a run of one or more `[aeiou]` = one, with a small correction for word-final `a` used as an inherent-vowel marker; crude and good enough **[V]**. Line breaking is **syntactic**, width only as a cap, no dictionary hyphenation ever. **Never split an English technical token from its Hindi governing word** — `search karu` breaks the sense across a line. **Do not style English tokens differently**: `search` inside a Hindi clause is not a foreign word, no italic and no accent; 1–3 English words per clause is typical, not a problem to solve.

**8.4 Reading rate — derive it, do not transplant it.** The published caps came from English orthography and **fail in both directions at once** on romanised Hindi **[V]**. *Characters over-count*: romanisation is phonetic and needs more Latin letters per syllable — aspirates take two (`bh`, `dh`, `kh`), long vowels two (`aa`, `ee`, `oo`), retroflexes double. `karoon` is six characters for two syllables; `search`, in the same sentence, is six for one. A Hinglish line at 17 CPS therefore carries materially **less** content than an English line at 17 CPS, so a transplanted cap **over-holds every cue** and makes the track feel sluggish. *Words under-count*: DCMP's wpm assumes English word lengths, while Hindi function words are short (`ke`, `ko`, `se`, `hai`) and content words long. **Syllables are the stable unit.** Derive once per channel, then apply mechanically per cue:

```
1. syllables := vowel groups over the whole transcript
2. chars_per_syllable := total chars / total syllables       (English ~3.0, romanised Hindi ~3.6)
3. syllable_cap := english_cps_cap / 3.0                     (17 / 3.0 = 5.7 syll/s, muted)
4. derived_cps_cap := syllable_cap * measured_chars_per_syllable   (5.7 * 3.6 ~= 20.5 CPS muted)
   sound-on chained equivalent: ~9.0 syll/s -> ~32 CPS
5. report all three numbers in the design doc
```

**Code-switching costs a switch.** Each language switch imposes a small comprehension cost; `parr naam kya search karu??` switches twice. **0–2 per cue is free; add 0.08 s to the cue's minimum duration for each switch beyond the second.** If English tokens exceed ~60 % of the transcript, note it and use the English caps directly. Character budget per line drops to **English × 0.85** — budget *fewer words per line*, not more characters: 24 chars English → **20 Hinglish**.

**8.5 Transcription path.** `npx hyperframes transcribe` defaults to Parakeet, an **Apple-silicon MLX stack, unavailable on linux ARM64 [C]** — so the whisper fallback is what runs. Whisper's Hindi handling emits Devanagari for some audio and romanised Latin for other. **Pin the transcription language and script explicitly and inspect the output; never assume it.** Devanagari returned in a romanised deliverable is a transcription artefact to be transliterated **deliberately and logged**, never silently accepted.

## 9. Verification before render

Six gates. V1–V4 are pure arithmetic over the cue sheet — no browser, no render, runnable on the device VM.

**V1 — reading speed, per cue.** `chars = len(rendered text)` including spaces, punctuation and bracketed annotations; `cps = chars / (end - start)`. Report mean, median, **p90**, max, and the five worst cues with text and index; for Hinglish also syllables and syll/s against the derived cap (§8.4). **Zero cues over the cap.** Over-cap: split at the best syntactic point, extend only if there is room.

**V2 — duration, gap, fit.** Zero cues under the floor (0.833 s isolated / 0.20 s chained), zero over the ceiling (5.0 s speech), **zero gaps in the forbidden band (>0 and <2 frames)**, zero cues over 2 lines, line balance ratio ≤1.6, longest line within the measured character budget. Snap to the frame grid once at the end, then **re-test the gaps** — rounding creates one-frame gaps.

**V3 — orphan check on the longest cue.** Take the cue with the most characters and the one with the most words; confirm neither leaves a single word alone on line 2. An orphan is invisible in a character count — it appears only in the **rendered box**. Prefer the longer line on top; a long bottom line drags the eye down and away from the picture.

**V4 — verbatim byte diff.** Compare each cue's rendered `textContent` against the concatenated words from `transcript.out.json`, byte for byte. **Not a visual check.** Every difference is either a logged ASR correction or a bug; a romanised spelling variant is never a valid correction.

**V5 — safe area and collision, on frames** (browser step, cloud container only): `npx hyperframes snapshot --at 1.2,4.8,9.6,14.1,19.3,24.7,31.0,38.4`. In every frame: no glyph inside a reserved platform band, ≥0.04 H between any two text objects, every glyph inside the 5 % EBU inset. Then re-render at the other aspect — **the percentages must still hold with no pixel value edited.**

**V6 — extract caption frames and LOOK at them.** Mixed-script rendering is confirmed by eye, never by assumption: tofu, a mid-line face swap, or a descender clipped under the shadow halo is invisible to every automated gate. Extract at **cue midpoints in OUTPUT timecode**, straight from the cue sheet:

```bash
mkdir -p qc
# cues.tsv: idx <TAB> start <TAB> end   (OUTPUT seconds, from the cue sheet)
while IFS=$'\t' read -r idx s e; do
  mid=$(awk -v a="$s" -v b="$e" 'BEGIN{printf "%.3f", (a+b)/2}')
  ffmpeg -nostdin -y -ss "$mid" -i OUT.mp4 -frames:v 1 -q:v 2 -update 1 "qc/cue_${idx}.png"
done < cues.tsv

# exact frame, when a cue boundary must be checked to the frame: N = round(t * fps_num / fps_den)
ffmpeg -nostdin -y -i OUT.mp4 -vf "select='eq(n\,7464)'" -fps_mode passthrough -frames:v 1 -update 1 qc/frame_7464.png

# contact sheet — SURVEY ONLY, never measurement
ffmpeg -nostdin -y -i OUT.mp4 -vf "fps=1/2,scale=270:-1,tile=6x8" -frames:v 1 qc/sheet.png
```

Input-seek (`-ss` **before** `-i`) is frame-accurate in ffmpeg 6.1 — verified byte-identical to `select='eq(n,N)'` on the same file **[C, §7A]**. Never add `-noaccurate_seek` (it snaps to a keyframe); `ffprobe -read_intervals` is **not** frame-accurate, so extract with `ffmpeg -ss`. Look at every Hinglish cue, the worst-CPS cue, every collision window, every strike-through, and the first **and last** cue — a two-clock bug is smallest at the head and largest at the tail, so a head-only check passes on a broken map (`timebase.md` §7 V4).

## 10. Failure signatures

| Symptom | Cause |
|---|---|
| Renders blank, `sub_timeline_script_failure` | a CDN `<script>` survived — vendor GSAP locally (§7.1) |
| `check` reports `0 sample(s)` / `0/0 text checks` | a lint **error** disabled the layout and contrast audits; nothing ran |
| Content piled into the top-left | root sizing: an ancestor has no resolved height, flex child collapsed to ~0 |
| Caption text missing after a backwards seek | the `onStart` text-writing pattern — use one element per cue |
| Cues progressively later toward the end | authored in SOURCE time (`timebase.md` §1) |
| Every cue off by the same amount | head trim missing from the keep list, or a container start offset |
| Reads fine in preview, invisible in the app | behind the platform UI band (§4) |
| Text blinks out and back mid-clause | a cue broke at a coverage cut — ride, don't break (§5.5) |
| A caption says a real English word never spoken | autocorrect / LLM normalisation of a romanised token (§8.2) |
| Track feels sluggish, all caps satisfied | English CPS cap transplanted onto Hinglish — derive it (§8.4) |
| Emphasis reads as noise | share above 15 % — tighten the rule and re-run, never hand-prune (§6.2) |
| Strike snaps in at 50 % progress | `text-decoration-line` is not animatable — use `<span class="strike-bar">` (§6.3) |
| A line silently clipped instead of wrapping | the reference's `white-space:nowrap; overflow:hidden` survived (§7.2) |
