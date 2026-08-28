---
id: sfx-vocabulary-llm-expansion
title: From intent to searchable name — expanding SFX vocabulary and validating it against the library
skill: sound-design
type: sfx
family: sfx-taxonomy
tags: [skill/sound-design, type/sfx, family/sfx-taxonomy, layer/sfx, engine/epidemic, engine/hyperframes, source/sfx-kt-1, source/research, difficulty/low]
source:
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:19
    quote: "How am I supposed to learn all these names? Tell me that. — Okay, let me tell you. Look, there are two ways. The first one is practice. The more you explore, the more things you keep learning."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:05:26
    quote: "And second, just use ChatGPT, bro. Type in \"funny name sound effects\" and you'll get them."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "visual — contact sheet, ChatGPT window"
    quote: "[NOT SPOKEN — read off screen] Prompt visible: \"Give me the names of funny sound effects to use in videos.\""
research_refs:
  - https://universalcategorysystem.com/
  - https://www.epidemicsound.com/sound-effects/
  - https://en.wikipedia.org/wiki/Onomatopoeia
difficulty: low
detectable_from: transcript
---

# From intent to searchable name — expanding SFX vocabulary and validating it against the library

## What it is
Everything in sound design is gated on knowing what a sound is *called*. You cannot fetch a boing, a record scratch, a sub drop or a Foley cloth rustle if the only description you have is "something funny here". The source gives two routes to closing that gap: practice — browsing the library constantly until the names accumulate — and asking a language model to turn an intent into a list of concrete effect names.

The half the source leaves out is the part that makes the LLM route safe: **an LLM returns plausible English, and a library indexes tag slugs.** "Sad trombone" is a real sound and a real search; "descending comedic brass fail" is a real description and returns nothing useful. So the method is three steps, not one: generate candidate names, probe each against the catalogue, and keep the *slugs* — never the words — as the durable handle. Words are for thinking; slugs are for fetching.

**Style.** No `sfx/` style tag: expansion runs across the whole catalogue vocabulary and the slugs it returns land in all three groups. Which group the moment actually needs is decided earlier, in [[sfx-real-vs-invented-sound-rule]].

**The visual pass confirms the route and sharpens the framing.** The contact sheet of `sfx kt 1` shows ChatGPT open with a prompt typed in full: *"Give me the names of funny sound effects to use in videos."* That matters for two reasons. It is the creator's **own on-screen answer to the video's premise** — the whole video opens on *"I don't know the name of a single sound effect"* — so the LLM is not an aside, it is the resolution of the problem the video is about. And it reframes what kind of problem this is: **the naming problem is a retrieval problem.** The library is not missing the sound; the query is missing the word that indexes it. An LLM is useful here specifically as a *vocabulary generator between an intent and an index* — the same role a thesaurus plays for a search engine — and it should be judged on whether its output is retrievable, not on whether it sounds right.

That is also the boundary of its usefulness. An LLM knows what sounds are *called*; it does not know what your catalogue *contains*, what any of them sound like, or which one fits the frame. So the loop is always three steps — **generate names → probe the catalogue → keep the slugs that return results** — and the third step is the one that turns a plausible list into a fetch. Prompt for names, never for judgement: *"give me 20 names of comedic one-shot sound effects used in YouTube edits"* is answerable; *"which sound should I use at 4:12"* is not.

## When to use it
- **Whenever the design document says what a moment should feel like but not what it should sound like.** "This should feel like a mistake" → `sad trombone`, `record scratch`, `error buzzer`, `cartoon slide whistle down`.
- **When you have used the same three effects for everything** and the video is starting to sound like a template. Vocabulary expansion is the cure for the source's third named mistake, repetition ([[sfx-density-fatigue-audit]]).
- **Before a comedy or cartoon pass**, where the whole register is built out of named one-shots ([[sfx-cartoon-comedy-family]]).
- **When a search returns nothing.** Usually the name is wrong, not the library ([[sfx-name-before-search]] is the discipline; this note is the recovery procedure).
- **Once per project, as a ledger.** The slugs you validate are reusable forever; the point of writing them down is that the next project starts with vocabulary instead of guesses.
- **Not as a substitute for listening.** A validated slug gets you the right family; only auditioning gets you the right file.

## How to recognise it in a reference video
This is a workflow rather than an on-screen technique, but it is detectable in a reference as **vocabulary breadth**, and that is worth logging:

- **Count distinct effect families across the video.** A reference using 3–4 families for a 10-minute video has a vocabulary problem; 8–15 distinct families is normal for a well-designed one.
- **Look for named one-shots you would not have thought of** — a disc scratch, a boing, a pop, a slide whistle, a bell ding, a camera shutter, a coin, a typewriter return. Each one you cannot name is a gap in your own vocabulary and belongs in the ledger.
- **Check for repetition of a single file.** Identical duration and identical peak offset on two occurrences means the same asset, which usually means the editor had one name and used it twice.
- **Log intent alongside name.** The useful record is a pair: *what the moment was doing* → *what the sound was called*. That mapping is what an LLM prompt can later be seeded with.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Candidates generated per intent | 10 | 6–15 | Below six the list is too narrow to contain a hit; above fifteen the probe cost outweighs the value. |
| Probe depth | `first: 3` | 1–5 | You are reading tags, not choosing a file. Keep it cheap. |
| Accept threshold | `meta.total ≥ 20` | 10–50 | Fewer than ~10 results means the term found an edge case, not a family. |
| Reject signal | `meta.total == 0` | — | Verified: an unrecognised tag slug returns 0. The filter fails closed. |
| Over-broad signal | `meta.total ≥ 5000` | — | Verified: a vague multi-word term ("drone texture tension atmosphere") returned the 10000 cap with fire and forest ambiences on top. Free text degrades badly. |
| Slugs kept per intent | 2–3 | 1–5 | Enough for variation without turning the ledger into the catalogue. |
| Slug form | `<category>--<name>` | — | Verified live: `designed--riser`, `swooshes--whoosh`, `ambience--room-tone`, `designed--boom`, `fight--impact`. |
| Ledger file | `sfx-vocabulary.json` | — | Append-only. The vault cannot delete files, so revisions are new entries, not edits in place. |

## Reproduction prompt
```
Turn an emotional or functional intent into validated, fetchable library terms.

INPUT: one intent, stated as a clause - e.g. "this should feel like a mistake",
"this should feel like something is powering up", "this needs to feel expensive".

1. GENERATE CANDIDATES. Ask for concrete, conventional sound-effect NAMES, not
   descriptions, using this prompt shape:

     "List 10 standard sound-effect library names for: <INTENT>.
      Rules: each item is 1-3 words; use the name an SFX library would file it
      under, not a description; include onomatopoeia where that is the standard
      name (boing, whoosh, thud); include the physical source where that is how
      libraries file it (record scratch, cloth rustle, camera shutter); no brand
      names; no invented compounds. Output as a plain list."

   Keep the raw list. It is throwaway - only the survivors matter.

2. PROBE EACH CANDIDATE against the catalogue, one call each, cheap:
     SearchSoundEffects { query:{term:"<candidate>"}, first:3,
                          sort:{by:"POPULARITY", order:"DESCENDING"} }
   Record three things: meta.total, the titles returned, and every distinct
   tags[].slug on those results.

3. TRIAGE.
   - meta.total == 0 or the titles are unrelated -> discard the word.
   - meta.total >= 5000 with unrelated top hits -> the term is too vague; discard
     it and keep only the slugs it surfaced, if any are on-topic.
   - meta.total between ~20 and ~2000 with on-topic titles -> ACCEPT, and take the
     SLUG, not the word.

4. RE-QUERY BY SLUG to confirm the family is real and sized:
     SearchSoundEffects { filter:{ tagSlugs:{matchType:"ALL", values:["<slug>"]} },
                          first:1 }
   A zero here means the slug is wrong; a healthy family returns hundreds.

5. WRITE THE LEDGER. Append one object per intent:
   { "intent": "<clause>", "accepted": [{"term":"...","slug":"...","total":N}],
     "rejected": ["..."], "date": "<iso>" }
   Never rewrite an old entry; append a new one.

6. ACCEPTANCE TEST: at least two accepted slugs per intent; every accepted slug
   returns > 0 when queried alone by tagSlugs; and the rejected list is preserved,
   because knowing that a word does NOT work is half the value of the ledger.
```

## Execution spec

**Epidemic Sound.** Two calls with two different jobs, and conflating them is the whole failure mode.

*Discovery* — free text, tolerant, unreliable:
```json
{ "query": { "term": "record scratch" }, "first": 3,
  "sort": { "by": "POPULARITY", "order": "DESCENDING" } }
```
Every returned `soundEffect` carries `tags[]` with `id`, `displayName` and `slug`. The slug is the prize.

*Fetch* — by slug, exact, reproducible:
```json
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["swooshes--whoosh"] },
              "duration": { "min": 200, "max": 4000 } },
  "sort": { "by": "POPULARITY", "order": "DESCENDING" }, "first": 12 }
```
Three behaviours verified against the live catalogue and worth relying on:
1. **Slugs are `<category>--<name>`** — `designed--riser` (478 effects), `swooshes--whoosh` (975), `ambience--room-tone`, `designed--boom`, `fight--impact`.
2. **Unknown slugs fail closed** (`meta.total: 0`), so a zero result is a spelling problem, never proof of absence.
3. **Free-text terms degrade badly.** "drone texture tension atmosphere" returned the 10000-result cap with fire and forest ambiences ranked top. Multi-word emotional phrases are not queries; they are prompts for step 1.

Also note the catalogue has no tag for some names an LLM will confidently produce — there is no `braam` tag, for instance; the nearest real family is `designed--boom` with a term refinement. That is exactly what the probe step catches.

**Hyperframes.** Nothing in the composition holds vocabulary. Keep the ledger as a project file (`sfx-vocabulary.json`) next to `meta.json`, and reference chosen slugs in `STORYBOARD.md` frame bullets (`- sfx: designed--boom, low hit on the reveal`). **Known constraint:** the mounted vault cannot delete files, so the ledger must be append-only and any correction is a new entry that supersedes the old, never an in-place removal.

**Cross-library portability.** The Universal Category System (UCS) is the public-domain standard for naming and filing effects — a `CatID` plus Category, SubCategory and FXName, maintained by Tim Nielsen, Justin Drury, Kai Paquin and others, currently v8.2.1. Epidemic's `<category>--<name>` slugs are not UCS, but recording the UCS CatID alongside a slug in the ledger makes the vocabulary portable to any other library the project later uses.

**Remotion.** Not applicable — vocabulary is upstream of any renderer.

## Pairs with
[[sfx-name-before-search]] · [[sfx-library-build-and-taxonomy]] · [[sfx-library-quality-gate]] · [[sfx-cartoon-comedy-family]] · [[sfx-density-fatigue-audit]] · [[sfx-mood-vibe-filter]] · [[sfx-diegetic-action-inventory]] · [[sfx-intensify-without-referent]] · [[sfx-substitute-material-foley]] · [[sfx-synthetic-family-catalogue]] · [[sfx-ten-family-catalogue]] · [[sfx-epidemic-facet-query]] · [[sfx-foley-family]]

## Failure modes
- **Searching with the LLM's sentence.** "A comedic descending sound signalling failure" is a description; libraries index names. Convert to a name first, then search.
- **Trusting a name that was never probed.** LLMs produce confident, plausible, non-existent library terms (`braam` being the standard example). One cheap probe per candidate eliminates them.
- **Keeping the word instead of the slug.** Free-text ranking changes; a tag slug is a stable handle that returns the same family every time.
- **Reading a zero result as "the library doesn't have this".** It fails closed on unknown slugs. Check the spelling and the dimension before concluding anything.
- **Expanding vocabulary without expanding usage.** A ledger of forty slugs and a video that still uses three of them has fixed nothing. The ledger's purpose is to be consulted at the sound pass.
- **Letting the ledger drift out of the project.** Vocabulary kept only in a chat window is lost. Write it to a file, append-only.
- **Using an obscure name for its own sake.** A slide whistle where a whoosh belonged is vocabulary showing off. The right name is the conventional one for that beat ([[sfx-convention-over-accuracy]]).
