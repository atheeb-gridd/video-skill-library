---
id: motion-type-treatment-matches-content
title: Let the typeface do the semantic work — clean type for a clean cut, eroded chalk for SMASH CUT
skill: motion
type: type-motion
family: teaching-visual
tags: [skill/motion, type/type-motion, family/teaching-visual, layer/design, engine/hyperframes, source/editing-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "visual — contact sheet, title cards"
    quote: "[NOT SPOKEN — observed on screen] Title cards whose type treatment matches the content: 'Movement Match Cut', 'J Cut', 'L Cut', 'IN POINT' in clean type; 'SMASH CUT' in a rough eroded chalk face. The typeface is doing semantic work."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "visual — contact sheet, concept cards"
    quote: "[NOT SPOKEN — observed on screen] Title cards in a handwritten/script face — 'Instruments' — with a small orange sub-label 'Suspense/Tension' beneath."
research_refs:
  - https://legibility.info/rules-for-text-in-videos
  - https://en.wikipedia.org/wiki/Typeface
  - https://en.wikipedia.org/wiki/Stroop_effect
  - https://www.w3.org/TR/WCAG21/#contrast-minimum
  - _meta/visual-kt-delta.md
difficulty: medium
detectable_from: video
---

# Let the typeface do the semantic work — clean type for a clean cut, eroded chalk for SMASH CUT

## What it is
In `editing kt 2` the title cards are not set in one house face. `Movement Match Cut`, `J Cut`, `L Cut` and `IN POINT` are clean and neutral; **`SMASH CUT` is set in a rough, eroded chalk face**. The typeface is carrying part of the definition. A smash cut is abrupt, violent and deliberately ugly at the seam, and the card *looks like that* before the presenter has said a word.

This is a cheap, high-leverage device because the viewer decodes type character faster than they decode a sentence — and because a mismatch is actively costly. A `SMASH CUT` card set in the same tidy face as `J Cut` says "these are two items of the same kind, differing in some detail", which is exactly the wrong frame: one is a refinement of continuity, the other is a rupture of it. The type is either doing work or it is undoing work; it is never neutral.

The Hinglish house style applies the same principle differently: a **script/handwritten face** for concept titles marks them as *the presenter talking*, as against the clean face used for on-screen labels and data ([[motion-abstract-concept-card]]). Both videos are using the same rule — **one face per register, and register mapped to meaning** — and that is what generalises.

The discipline that keeps it from becoming a font salad is a **small closed set**: one clean face for the default, one expressive face reserved for ruptures, one metadata face (the italic serif of [[motion-attribution-label-inset-clip]]), and no fourth. Three faces, each with a job you can state in a sentence.

## When to use it
- **On a title card naming a technique whose character is the point** — smash cut, jump cut, glitch, hard stop, silence.
- **To separate registers**: presenter voice (script), on-screen data and labels (clean), attribution (italic serif).
- **When two cards must not read as siblings.** If the video pairs opposites, let the pair differ in weight or case and keep the face constant — differ the *face* only when the kind of thing differs ([[struct-inverse-pair-teaching]]).
- **On a single-word topic card**, where there is nothing but type to carry the tone ([[motion-single-word-topic-card]]).
- **Not on body text, captions or labels.** Expressive faces fail at small sizes and on phone screens ([[sub-emphasis-caption-three-words]]).
- **Not more than one expressive face per video.** Two competing personalities read as inconsistency, not as range.
- **Not when the content has no character.** `IN POINT` is a neutral term; setting it in chalk would assert something false.

## How to recognise it in a reference video
- **Collect every full-frame type card** in the video and sort by face. A system shows two or three clusters with clear jobs; a mess shows one-off faces.
- **Ask what the outlier asserts.** Where one card breaks the house face, name the property it is claiming — rough, loud, broken, handwritten, official. If you cannot name it, it is decoration.
- **Check case and weight discipline.** In the reference the rupture card is also all-caps; case is a second, cheaper lever that often carries the same meaning without a second font file.
- **Legibility is not sacrificed.** Even the eroded face is large, high-contrast and held long enough to read — expressive faces need *more* dwell, not less.
- **Metadata type is consistently different** from content type ([[motion-attribution-label-inset-clip]]).
- **The face does not animate differently.** In a coherent system a rough face still uses the house entrance; the character is in the letterforms, not in a new animation.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `face_count` | 3 | 2–4 | Clean (default) · expressive (rupture) · metadata italic serif. A fourth needs a stated job. |
| `expressive_share` | ≤15% of cards | 0–25% | Beyond this the exception becomes the rule and stops signalling. |
| `title_px` | 96 px @1080p | 72–160 px | Titles ≥1.5× body. Expressive faces usually need the upper half of the range. |
| `dwell_clean` | chars ÷ 13 s | ≥2.3 s | Published reading-budget minimum. |
| `dwell_expressive` | chars ÷ 10 s | ≥2.8 s | Rough, eroded and script faces read **20–30% slower**; budget for it. |
| `contrast_ratio` | ≥4.5:1 | ≥4.5:1 | Eroded faces lose effective stroke weight — measure, do not eyeball. |
| `tracking_clean` | −0.03 em | −0.05 to 0 | Tight for clean display type. |
| `tracking_expressive` | 0 em | 0 to +0.04 | Rough faces need air or the erosion fuses adjacent letters. |
| `case_rupture` | all caps | — | The cheap second lever: caps + house face often replaces a second font. |
| `entry` | house entrance, 0.4 s `power3.out` | — | Same animation for every face; the letterforms carry the difference. |
| `max_line_chars` | 30 | ≤30 | Per line, all faces. |

## Reproduction prompt

```
Set the title card for {{TERM}} so the type carries part of the meaning.

1. NAME THE CHARACTER of the technique in one adjective: neutral, abrupt,
   broken, handwritten, official, playful. If the honest answer is "neutral",
   use the house clean face and STOP - that is the correct outcome for most
   cards.
2. MAP the adjective to the video's small closed face set:
     neutral / structural      -> clean face
     abrupt, violent, broken   -> the ONE expressive face (eroded, rough)
     presenter's own voice     -> script / handwritten face
     attribution / metadata    -> italic serif, small, never full-frame
   Do not introduce a face that is not already in the set.
3. TRY CASE FIRST. All-caps in the house face carries "abrupt" surprisingly
   well and costs no extra font file or legibility. Reach for the expressive
   face only if case is not enough.
4. SET IT: >=96 px, <=30 characters per line, contrast >=4.5:1 measured
   against the actual background, tracking 0 em for the expressive face.
5. DWELL: characters / 10 seconds for expressive faces, characters / 13 for
   clean ones, with a 2.8 s / 2.3 s floor.
6. USE THE HOUSE ENTRANCE regardless of face. The letterforms are the
   variable; the motion is not.
7. AUDIT AT THE END: list every card and its face. If the expressive face is
   on more than about one card in seven, demote the weakest ones.

ACCEPTANCE TEST: show the cards muted to someone who does not know the
material and ask which technique is the violent one. If they cannot tell, the
type is not working; if they say two of them are, the expressive face is
over-used.
```

## Execution spec

**HyperFrames — type is CSS, motion is GSAP, faces are local files.**

```html
<div class="clip" id="card-smash" data-start="312.00" data-duration="3.20" data-track-index="2">
  <h2 class="title title--rupture" id="smash-t">SMASH CUT</h2>
</div>
```
```css
@font-face { font-family: "HouseChalk"; src: url("assets/fonts/house-chalk.woff2") format("woff2"); font-display: block; }
.title            { font-family: "HouseClean", system-ui, sans-serif; letter-spacing: -0.03em; }
.title--rupture   { font-family: "HouseChalk", "HouseClean", sans-serif; letter-spacing: 0; text-transform: uppercase; }
```
```js
tl.fromTo("#smash-t", { autoAlpha: 0, y: 20 },
  { autoAlpha: 1, y: 0, duration: 0.40, ease: "power3.out" }, 312.0);
```
The constraints that matter: **fonts must be vendored locally** — the egress allowlist blocks font CDNs, and a missing expressive face silently falls back to the clean one, which looks *fine* and destroys the technique, so verify the rendered frame rather than trusting the CSS. `font-display: block` is the right choice here for the same reason: a flash of fallback type in a 3-second card is the whole card. **`fromTo`, never `from`**; transform aliases only (`y`, `scale`), never `top`/`left`; `autoAlpha` never on the clip element itself; land the last tween before `data-duration`.

**Per-letter animation is a different technique.** If letters must animate individually, split the text into spans and `stagger` them — but keep the same entrance across faces, or the type system starts asserting things through motion as well and the two signals compete ([[motion-entrance-vocabulary]]).

**Verification.**
```bash
# render one frame of the card and check the face actually resolved
ffmpeg -ss 312.5 -i out.mp4 -frames:v 1 /tmp/card.png
```
Compare it against a frame of a clean card: if the letterforms are identical, the font never loaded.

**Remotion.** Same CSS; `loadFont()` from a local file, with the same fallback caveat.

## Pairs with
[[motion-single-word-topic-card]] · [[motion-abstract-concept-card]] · [[motion-attribution-label-inset-clip]] · [[motion-closing-thesis-title-card]] · [[motion-list-item-marker-card]] · [[motion-entrance-vocabulary]] · [[sub-emphasis-caption-three-words]] · [[struct-name-define-demonstrate]] · [[cut-smash-cut]] · [[sfx-smash-cut-audio-contrast]]

## Failure modes
- **A face per card.** Ten faces is not range, it is noise, and no card signals anything.
- **Expressive faces at small sizes.** Eroded and script faces collapse below about 60 px and are unreadable on a phone.
- **Forgetting the reading tax.** Rough and handwritten faces read 20–30% slower; the same dwell that works for a clean card leaves an expressive one half-read.
- **Contrast lost to erosion.** A chalk face has thinner effective strokes than its nominal weight; measure contrast on the rendered frame.
- **Font not vendored.** The silent, most common failure: the fallback renders, everything looks acceptable, and the semantic signal is simply gone.
- **Type character contradicting the sound.** A rough SMASH CUT card over a soft crossfade of a whoosh is two signals disagreeing ([[sfx-smash-cut-audio-contrast]]).
- **Setting neutral terms expressively.** `IN POINT` in chalk asserts a drama the term does not have.
- **Animating expressive faces differently.** Character belongs in the letterforms; changing the entrance too makes the system unlearnable.
- **Known gap:** the reference's actual typefaces are not identifiable from a contact sheet — what is observed is that the *treatment changes with the content*. Match the principle, choose your own faces, and record them in the style profile.
