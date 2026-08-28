---
id: sfx-two-taxonomies-of-sound
title: Two competing "three types of sound" — one classifies why, the other classifies what
skill: sound-design
type: sfx
family: sfx-taxonomy
tags: [skill/sound-design, type/sfx, family/sfx-taxonomy, sfx/diegetic, sfx/motion, sfx/aesthetic, layer/sfx, engine/epidemic, source/editing-kt, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:11:17"
    quote: "These next three types of sound effects literally hijack your viewers' emotions and pull them into the video."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:11:23"
    quote: "First, risers. They build tension and anticipation, because they tell the audience that something really important is about to happen. But only use them when something important actually is about to happen. Otherwise they lose their credibility and stop working."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:11:36"
    quote: "Next up are hits. These release tension and punctuate moments so they feel important. You can use them on their own or put a riser in front of them."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:11:48"
    quote: "Last but not least, tones. These create a feeling of mystery and intrigue. They're more for darker moods and they build a lot of underlying tension."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:03:47"
    quote: "Diegetic, motion and aesthetic sound effects."
research_refs:
  - https://en.wikipedia.org/wiki/Diegetic_music
  - https://universalcategorysystem.com/
  - https://en.wikipedia.org/wiki/Envelope_(music)
difficulty: low
detectable_from: transcript
---

# Two competing "three types of sound" — one classifies why, the other classifies what

## What it is
Two different reference videos each teach *"three types of sound effects"*, and they are **not the same three**. A reader who meets them in the wrong order will think one of them is wrong. Neither is.

| | **Taxonomy A — the three styles** | **Taxonomy B — the three emotional devices** |
|---|---|---|
| Source | `assets/videos/sfx kt 2.mp4` 00:03:47 | `assets/videos/editing kt.mp4` 00:11:17 |
| The three | **diegetic · motion · aesthetic** | **risers · hits · tones** |
| Classifies | **Why the sound is there** — its job in the scene | **What the sound is** — its acoustic shape |
| Question it answers | *Does this moment need realism, movement, or feeling?* | *Which of the three emotion devices do I reach for?* |
| Membership | Every sound effect is exactly one | Only a subset of sounds are members at all |
| Used for | Choosing a family, setting the mix strategy, tagging the library | Choosing a specific device at a specific beat |
| In this library | The closed `sfx/` tag vocabulary | Three family notes, plus one compound |

**They stack; they do not compete.** Taxonomy B is a **sub-taxonomy of one cell of Taxonomy A**: risers, hits and tones are all `sfx/aesthetic` — sounds with no real-world referent, whose only job is amplification. A door, a footstep or a whoosh is not a riser, a hit or a tone at all, and Taxonomy B has nothing to say about them. So:

```
diegetic  ── ambience, foley, intimate sounds        (B says nothing)
motion    ── whooshes, swooshes, whips, motion SFX   (B says nothing)
aesthetic ── risers · hits · tones                   ← Taxonomy B lives here
```

**Taxonomy B's own internal logic is a tension curve**, which is what makes it useful rather than merely a list: a **riser builds** tension, a **hit releases** it, and a **tone sustains** it underneath everything else. That is a complete grammar for one emotional line — build, release, hold — and it is why the video calls them the sounds that *"hijack your viewers' emotions"*. The compound form is named in the source itself: *"you can use them on their own or put a riser in front of them"* — the riser-into-hit pair ([[sfx-riser-hit-pair]]).

Each member also carries its own constraint from the same passage: risers **lose credibility** if used when nothing important follows ([[sfx-riser-credibility-budget]]); hits should not be overdone; tones are for **darker moods** and work by *underlying* tension rather than by an event ([[sfx-tone-bed-mystery]]).

## When to use it
- **Use Taxonomy A when deciding what a moment needs** and how it will be mixed. It is the one the library is organised by, it is the closed tag vocabulary, and every sound-design note carries exactly one of its tags ([[sfx-three-types-classification]]).
- **Use Taxonomy B when the moment is already known to be an emotional beat** and the question is which device: build (riser), punctuate (hit), or colour (tone).
- **Use both together on a reveal.** A build-release beat is a Taxonomy-B compound placed by Taxonomy-A rules: the riser is aesthetic so it sits *around* the picture, the hit lands on the impact frame, and neither one may inform the viewer of anything ([[sfx-intensify-without-referent]]).
- **When reading any KT or profile that says "the three types".** Check which three. This note exists so that check takes ten seconds.
- **Not as a reason to add a second tag namespace.** The tag vocabulary is closed and Taxonomy B is expressed with `family/riser` and note links, not with new `sfx/` tags.

## How to recognise it in a reference video
- **Taxonomy A is recognised by ratio.** Log every effect as diegetic / motion / aesthetic and take the shares. A video that is nearly all motion is flat; nearly all aesthetic is a trailer; nearly all diegetic is a documentary ([[sfx-ten-family-catalogue]] carries the family-level tally).
- **Taxonomy B is recognised by envelope shape.** A **rising** envelope over 1–8 s that resolves into silence or an impact is a riser. A **transient front** with a decaying tail is a hit. A **flat sustained** bed with no transient and no obvious start is a tone.
- **Check what follows a riser.** If nothing happens on the frame it resolves, the reference is spending credibility for nothing — log it as a negative, not a pattern to copy.
- **Tones are the easiest to miss and the best tell.** Mute the dialogue and listen for a low sustained bed that is not the music. Its presence usually means a designed, rather than assembled, sound pass.
- **A riser immediately followed by a hit** is the compound; measure the gap. Anything over about 200 ms of silence between them and the release has separated from the build.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `taxonomy_a_tag` | one per note | — | `sfx/diegetic` · `sfx/motion` · `sfx/aesthetic`. Closed vocabulary; exactly one per sound note. |
| `taxonomy_b_membership` | aesthetic only | — | Risers, hits and tones are all `sfx/aesthetic`. Never tag a footstep as a "hit". |
| `riser_body` | 2.0 s | 1.0–8.0 s | 1 s micro · 2 s standard · 4 s section change · 8 s act break. |
| `hit_attack` | <10 ms | — | Transient front is what makes it a hit rather than a swell. |
| `tone_length` | 15 s | 6–60 s | A tone is a bed, not an event; under ~6 s it reads as a swell. |
| `riser_to_hit_gap` | 0 ms | 0–200 ms | The release lands on the riser's end. Longer and the pair breaks in two. |
| `risers_per_video` | 3 | 1–6 | The credibility budget: each unpaid riser devalues the next. |
| `tone_level` | −26 dB | −30 to −22 dB | Felt, not noticed ([[sfx-felt-not-noticed]]). |

## Reproduction prompt

```
Classify the sounds in {{SECTION}} against both taxonomies before fetching.

1. FOR EVERY MOMENT, answer Taxonomy A first: is this sound here to sell
   REALISM (diegetic), MOVEMENT (motion), or FEELING (aesthetic)? Write the
   tag. This decides the family, the level and the mix strategy.
2. ONLY FOR THE AESTHETIC ONES, answer Taxonomy B: does this beat BUILD
   tension (riser), RELEASE it (hit), or HOLD it (tone)?
3. CHECK THE BUILD-RELEASE LINE. Every riser must resolve on something the
   viewer can see or hear. If it does not, delete it - do not shorten it.
4. PLACE per Taxonomy A's rules: aesthetic sounds sit around the picture and
   may amplify but never inform; motion sounds lead the picture by a few
   frames; diegetic sounds sit under it at a believable level.
5. RECORD BOTH ANSWERS in the cue sheet. "Riser" alone is not a spec; "riser,
   aesthetic, 2.0 s, resolves on the card at 04:12" is.

ACCEPTANCE TEST: someone reading the cue sheet can tell, for every row, both
why the sound is there and what shape it has - and no row calls a footstep a
hit.
```

## Execution spec

**Epidemic Sound.** Taxonomy B maps onto three distinct search shelves, all on the sound-effects surface:
```
riser  SearchSoundEffects { query:{term:"riser tension"},      filter:{duration:{min:2000,max:8000}} }
hit    SearchSoundEffects { query:{term:"cinematic impact"},   filter:{duration:{min:300,max:4000}} }
tone   SearchSoundEffects { query:{term:"dark drone tone"},    filter:{duration:{min:15000}} }
```
A tone that must sit in the mix as a musical cue rather than an effect is fetched from the **recordings** surface instead, where the six facets apply (`vocals:false`, `moodSlugs` ANY of the dark/suspense family) — the two surfaces are genuinely different tools ([[sfx-epidemic-facet-query]]).

**HyperFrames.** The taxonomy decides the anchor frame, which is the only thing that differs mechanically:
- **riser** — anchored by its **end**: `data-start = T_RESOLVE − body`, so its peak lands on the reveal frame.
- **hit** — anchored by its **peak**: measure the transient offset and set `data-start = T_IMPACT − offset` ([[sfx-peak-offset-measurement]]).
- **tone** — anchored by the **passage**: long `data-duration`, low `data-volume`, `data-fx-carve` against the voiceover group if narration runs over it.

All three sit in the `sfx` group, above the music track index, and none of them belongs in a carve `sources` list.

**Tagging.** Use `family/riser` for the riser cluster; there is no `family/hit` or `family/tone` yet and coining one is only justified when three or more notes will share it. Taxonomy B never becomes an `sfx/` tag — that namespace is closed and belongs to Taxonomy A.

## Pairs with
[[sfx-three-types-classification]] · [[sfx-ten-family-catalogue]] · [[sfx-synthetic-family-catalogue]] · [[sfx-riser-anticipation-build]] · [[sfx-riser-credibility-budget]] · [[sfx-riser-hit-pair]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-tone-bed-mystery]] · [[sfx-intensify-without-referent]] · [[sfx-felt-not-noticed]]

## Failure modes
- **Assuming the two lists are the same list.** They share no members by name, and a profile that merges them produces categories that classify nothing.
- **Tagging a riser as a fourth style.** The `sfx/` namespace is closed at three. Risers are aesthetic.
- **Applying Taxonomy B to diegetic or motion sounds.** A whoosh is not a hit, and calling it one leads to anchoring it on its first frame instead of its velocity peak.
- **Using Taxonomy B as a coverage checklist.** A video does not need one of each; a tone in a cheerful explainer is simply wrong.
- **Spending risers.** The source is explicit that an unpaid riser costs the next one its power. Budget them.
- **Losing the tone under the bed.** Tones and music beds occupy similar space; if both run, the tone needs its own band or the bed needs a rest ([[sfx-music-rest-windows]]).
- **Known gap:** the `editing kt` passage names the three devices and their emotional jobs but gives no durations, levels or counts — every number here comes from the family notes and from research.
