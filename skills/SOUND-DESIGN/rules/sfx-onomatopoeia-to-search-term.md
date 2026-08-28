---
id: sfx-onomatopoeia-to-search-term
title: Say it out loud — turning a mouth-imitation into a catalogue search term
skill: sound-design
type: sfx
family: search-vocabulary
tags: [skill/sound-design, type/sfx, family/search-vocabulary, layer/sfx, engine/epidemic, source/sfx-kt-1, source/research, difficulty/low]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:01:01"
    quote: "And here's a fun thing — saying \"whoosh\" out loud actually sounds like the effect itself."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:00:09"
    quote: "But what name do I search? I don't know the name of a single sound effect."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:05:26"
    quote: "And second, just use ChatGPT, bro. Type in \"funny name sound effects\" and you'll get them."
research_refs:
  - https://en.wikipedia.org/wiki/Onomatopoeia
  - https://en.wikipedia.org/wiki/Spectral_centroid
  - mcp://Epidemic_sounds/SearchSoundEffects — slug grammar and title grammar confirmed live 2026-08-28 across eight families
difficulty: low
detectable_from: transcript
---

# Say it out loud — turning a mouth-imitation into a catalogue search term

## What it is
The bottleneck in sound design is almost never taste; it is vocabulary. You know what the moment needs, you can make the noise with your mouth, and you cannot type it. The source's observation is the way in: **most sound-effect family names are onomatopoeic**, so saying the imagined sound out loud usually produces the search term, or something close enough to it that the catalogue's relevance ranking does the rest. *Whoosh* sounds like a whoosh. So do *swish*, *boing*, *pop*, *click*, *thud*, *clank*, *buzz*, *hiss*, *zap*, *ding*, *crunch*, *snap*, *screech*, *whir*, *drip*, *splat*, *rumble*, *crack*.

The other half of the vocabulary is **jargon that must be learned**, because it names a *function* rather than a sound: *riser*, *hit*, *impact*, *stinger*, *braam*, *sub drop*, *drone*, *texture*, *sweetener*, *reverse*, *transition*, *foley*, *ambience*, *bed*. No amount of mouth-imitation produces the word "riser". These are the terms worth memorising, and they are a short list — perhaps fifteen words that unlock the aesthetic half of the library.

There is a third layer that is specific to this stack, and it is the part that makes searches reliable rather than lucky. **The Epidemic catalogue's own vocabulary is structured**, and it was probed live: tags are slugs of the form `<category>--<subcategory>` (`swooshes--whoosh`, `magic--shimmer`, `footsteps--human`, `user-interface--click`, `designed--riser`, `cloth--movement`, `communications--phonograph`, `objects--packaging`), and titles are **comma-separated descriptor chains** that read like a path from general to specific: *"Footsteps, Human, Concrete, Sneakers, Walk, Medium Tempo, Steady 01"*, *"Magic, Shimmer, Spell, Cast, Transform, Shimmer, Sparkle, Twinkle 01"*, *"Communications, Phonograph, Vinyl, Record Scratch 11"*. Once you know that grammar, the search stops being a guess: **imitate → name → guess the slug → verify by reading the tags on what comes back**.

**Style.** No `sfx/` style tag: the onomatopoeic half of the vocabulary mostly names diegetic and motion sounds, while the learned-jargon half — riser, braam, drone, texture — is almost entirely the aesthetic group ([[sfx-synthetic-family-catalogue]]). The method covers both.

## When to use it
- **Whenever you can hear the sound and cannot name it.** That is the trigger; the technique costs ten seconds.
- **When a first search returns junk.** Junk usually means you searched a *function* word where the catalogue wants an *object* word, or vice versa. Re-enter from the other side of the table below.
- **When building a project palette**, to write down the terms that worked so the next project starts from a vocabulary instead of a blank field ([[sfx-library-build-and-taxonomy]]).
- **When briefing an LLM for names**, which is the source's second method. It works, and it works much better with a shaped prompt (see the reproduction prompt) than with "funny name sound effects".
- **Not** a substitute for classification. Knowing the word "whoosh" does not tell you whether this moment wants one ([[sfx-motion-sound-selection]], [[sfx-real-vs-invented-sound-rule]]).

## How to recognise it in a reference video
This is a search technique, but it has an analysis use: naming a reference's palette is what makes it reproducible.

- **Log every distinct effect you hear with a mouth-name first**, before trying to be technical. "Tss-shk", "thoom", "bidoop". The imitation preserves information a genre label loses.
- **Then convert each to a family term and a measured signature.** Duration, spectral centroid (bright/dark), attack (struck/ramped), and whether it has a tonal centre:
  ```bash
  ffmpeg -v error -ss <t> -t 0.5 -i ref.wav -af "aspectralstats=measure=centroid+flatness,\
  ametadata=print:file=-" -f null - 2>/dev/null | head -12
  ```
  `flatness` near 1 = noise-like (whoosh, hiss, scratch); near 0 = tonal (bell, drone, braam). That one number decides which half of the vocabulary the sound belongs to.
- **Count families, not files.** A reference typically uses **5–9 distinct families** across a whole video. Fewer reads monotonous; many more usually means the editor is spraying a pack rather than designing.
- **Note which are diegetic and which are invented.** Onomatopoeic names cluster in the diegetic and motion styles; jargon names cluster in the aesthetic style. The ratio between them is a fingerprint of the creator's register ([[sfx-three-types-classification]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `candidates_per_query` | 3 | 3–6 | Effects are cheap to audition and expensive to guess at. |
| `term_length` | 4 words | 2–7 | The catalogue's own titles are descriptor chains; a 4-word chain outperforms a 1-word noun. |
| `slug_guess_attempts` | 2 | 1–3 | Guess `<category>--<subcategory>`, verify on the returned `tags[].slug`, then filter by the real one. |
| `fallback_order` | slug → chain → single word | — | Always filter by slug when you have one; fall back to the descriptor chain; a bare noun is the last resort. |
| `palette_size` | 7 families | 5–9 | Per video. Write them into the project palette with the exact query that worked. |
| `llm_names_requested` | 15 | 10–30 | When asking a model for names, ask for a *list with one-line descriptions*, then verify each against the catalogue — models invent plausible-sounding effect names that no library carries. |

## The translation table

**Onomatopoeic — say it, then type it.** These map close to one-for-one; the catalogue term is the one that actually returns results.

| You would say | Type this | Catalogue home (verified where slug is given) | Typical use |
|---|---|---|---|
| whoooosh | whoosh | `swooshes--whoosh` | full-frame move, camera push, heavy transition |
| swish / sss-shk | swish | `swooshes--swish` | text, icon, small element crossing frame |
| pop | pop | `user-interface--click` (also "Pops, Glass") | element appears, bubble, caption |
| click / tk | click | `user-interface--click` | cursor, selection, UI action |
| boing | boing | cartoon family | comedy bounce |
| ding / ting | ding, chime, bell | bell / notification families | correct answer, positive mark |
| tss-tss | shimmer, twinkle, sparkle | `magic--shimmer` | highlight, reveal, magic |
| thud / thump | thud, thump, body fall | impact family | weight landing, heavy arrival |
| clank / clunk | clank, metal impact | objects / metal families | prop contact |
| crunch | crunch, gravel, footstep | `footsteps--human` | footfall, breaking |
| snap / crack | snap, crack, wood break | breaking family | bone-break substitutes, tension release |
| buzz / bzzt | buzz, error, negative | UI negative / electricity | wrong answer, glitch |
| zap | zap, electric, laser | electricity / sci-fi | sci-fi, energy |
| hiss / ssss | hiss, static, white noise | ambience / TV static | texture, dead air |
| whip / thwip | whip crack | whip family | snap-cut, punchline |
| rrrp (vinyl) | record scratch | `communications--phonograph` | stop-everything punctuation |
| rustle | cloth movement, fabric | `cloth--movement` | body/garment foley |
| drip | drip, water drop | water family | tension, emptiness |
| whirr | whir, motor, servo | machines family | mechanism, robot |
| screech | screech, tyre, brakes | vehicles family | abrupt stop |

**Jargon — no imitation will produce these.** Learn the list; it is short.

| Term | What it actually is | Catalogue route |
|---|---|---|
| riser | pitch/level build over 2–15 s, peaks at its END | `designed--riser` (verified: 9.8–15.5 s assets) |
| hit / impact | single percussive event, peaks at its START | "designed impact hit cinematic" |
| braam | low, brassy, sustained trailer hit | "brass hit low cinematic braam" — often filed under designed/orchestral |
| sub drop | descending sub-bass under an impact | "sub drop bass fall" ([[sfx-bass-drop-under-impact]]) |
| stinger | short musical phrase punctuating a beat | music side, not SFX |
| drone / texture / bed | sustained, unchanging, atmospheric | "drone texture dark ambience" |
| reverse | any of the above played backwards; makes an *arrival* | add the word "Reversed" to a chain |
| transition | the catalogue's own word for whoosh-class movers | appears in riser and swoosh titles |
| foley | performed everyday sound, re-recorded | `footsteps--*`, `cloth--*`, `objects--*` |
| ambience | location bed | ambience categories by place |
| sweetener | a layer added under another sound to thicken it | no slug; it is a technique ([[sfx-layered-approach-and-impact]]) |
| one-shot | a single non-looping instance | describes the file, not a category |

## Reproduction prompt

```
Find the catalogue asset for a sound you can only imitate.

1. SAY IT OUT LOUD and write the imitation down verbatim ("tss-shk", "thoom").
   Note three things while you say it: is it BRIGHT or DARK, is it STRUCK or
   RAMPED, does it have a PITCH or is it noise.
2. NAME IT from the translation table in this note. Bright + struck + noise ->
   swish/click. Dark + struck -> thud/impact. Bright + ramped -> shimmer/riser.
   Dark + ramped -> drone/riser. Pitched -> bell/chime/braam.
   If the sound is a FUNCTION rather than an object ("something that builds
   tension"), use the jargon table instead - no imitation will get you there.
3. GUESS THE SLUG as <category>--<subcategory>, lowercase, hyphenated:
   swooshes--whoosh, swooshes--swish, magic--shimmer, user-interface--click,
   footsteps--human, cloth--movement, designed--riser, communications--phonograph.
4. SEARCH TWICE:
   a) SearchSoundEffects { query:{ term:"<4-word descriptor chain>" }, first:12 }
      Read the tags[].slug on the results you like - THIS is how you learn the
      real slug rather than guessing it again.
   b) SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL,values:["<slug>"]},
                                    duration:{min:<ms>,max:<ms>} }, first:24 }
5. IF STILL WRONG, flip sides: you searched an object word and the catalogue
   files it by function (or the reverse). "Sound of a bone breaking" is filed as
   wood/vegetable breaking; "sound of tension building" is filed as riser.
6. ASK A MODEL, SHAPED. Prompt: "List 15 sound-effect library search terms for
   <describe the moment>. For each: the term, one line on what it sounds like,
   and whether it is onomatopoeic or industry jargon. Do not invent product
   names." Then VERIFY every term against the catalogue before trusting it.
7. WRITE IT DOWN. Add term, slug, duration filter and the winning asset id to
   the project palette. The library gets more reliable only if queries are
   recorded when they work.

ACCEPTANCE TEST: hand your search term to someone who has not seen the video.
If they can describe roughly the right sound from the term alone, the term is
good enough for the catalogue's relevance ranking too.
```

## Execution spec

**Epidemic Sound — the grammar, verified live 2026-08-28.** Two structures matter and both were confirmed across eight separate probes.

*Tag slugs* are `<category>--<subcategory>`: `swooshes--whoosh`, `swooshes--swish`, `magic--shimmer`, `user-interface--click`, `footsteps--human`, `cloth--movement`, `designed--riser`, `communications--phonograph`, `objects--packaging`, `food-drink--cooking`. A result's `tags[]` array carries `slug` and `displayName` — **read them off results rather than guessing twice**.

*Titles* are comma-separated descriptor chains, general → specific, often ending in a two-digit take number. Real examples pulled in the probe:
```
Footsteps, Human, Concrete, Sneakers, Walk, Medium Tempo, Steady 01
Magic, Shimmer, Spell, Cast, Dispel Magic, Cleanse, Twinkle, Glimmer, Short 02
Communications, Phonograph, Vinyl, Record Scratch 11
User Interface, Click, Accept, Select, Digital, Short, Synthetic
Designed, Riser, Cinematic Reverse Impact, Crescendo, Tension Build 01
Cloth, Movement, Clothing, Hoodie, Fast
```
So the highest-yield free-text query is **a chain in the same shape**, not a single noun: `"footsteps human concrete sneakers walk"` beats `"footsteps"`.

The three-call pattern that turns a guess into a repeatable query:
```
SearchSoundEffects { query:{ term:"<chain>" }, first:12 }              # learn the slug
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL,values:["<slug>"]},
                              duration:{min:<a>,max:<b>} },
                     sort:{by:POPULARITY,order:DESCENDING}, first:24 } # narrow it
SearchSimilarToSoundEffect { id:<winner>, first:12 }                   # rotation set
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
`matchType` accepts `ALL | ANY | NOT_ANY` — `NOT_ANY` is the underused one, e.g. air sounds excluding the cartoon register. `sort.by` accepts `RELEVANCE | POPULARITY | DATE | DURATION | TITLE`. Duration filters are in **milliseconds**.

**HyperFrames / ffmpeg:** nothing to execute here — this note ends at a file path. The next steps are measuring the peak ([[sfx-peak-offset-measurement]]) and placing the clip. Do record the winning query string in the asset manifest beside the file: the query is metadata about the asset and is the only part of this process that is expensive to reconstruct.

**Remotion:** not applicable — sourcing is engine-independent.

## Pairs with
[[sfx-name-before-search]] · [[sfx-search-vocabulary]] · [[sfx-library-build-and-taxonomy]] · [[sfx-swoosh-vs-whoosh]] · [[sfx-synthetic-family-catalogue]] · [[sfx-cartoon-comedy-family]] · [[sfx-three-types-classification]] · [[sfx-real-vs-invented-sound-rule]] · [[sfx-substitute-material-foley]] · [[sfx-mouth-foley-record-and-process]] · [[sfx-ab-audition-candidates]] · [[sfx-record-scratch-punctuation]] · [[sfx-highlight-sound-on-emphasis]]

## Failure modes
- **Searching one noun.** "Whoosh" returns the whole air category, half of which is the wrong member of the family. Fix: a four-word descriptor chain, then a slug filter.
- **Guessing the slug twice.** If the first guess misses, do not guess again — run a text search and read the real slug off the results.
- **Expecting an imitation to produce a function word.** You cannot mouth "riser". Fix: learn the fifteen jargon terms; they are the whole aesthetic vocabulary.
- **Taking an LLM's names on faith.** Models produce plausible library terms that no catalogue uses. Fix: verify each against a real search before putting it in a brief.
- **Naming the object instead of the material.** The catalogue files a bone break under breaking wood or snapping vegetables, because that is what was recorded ([[sfx-substitute-material-foley]]). Fix: search the *material*, not the fiction.
- **Not writing the query down.** The single reason sound design stays slow across projects. Fix: term, slug, duration filter and asset id into the palette, every time.
- **Known gap:** these slugs were observed on 2026-08-28 and the catalogue's taxonomy is not versioned or published. Treat every slug in this note as a **starting guess that must be re-verified** by reading `tags[].slug` on live results; the *grammar* (`category--subcategory`, comma-chain titles) is the durable finding, not the individual strings.
