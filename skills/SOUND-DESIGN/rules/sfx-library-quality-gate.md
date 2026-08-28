---
id: sfx-library-quality-gate
title: Four deficits of a scraped sound — the quality gate a source must pass
skill: sound-design
type: sfx
family: library
tags: [skill/sound-design, type/sfx, family/library, layer/sfx, engine/epidemic, engine/ffmpeg, engine/hyperframes, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:04:25
    quote: "but on YouTube you mostly get low quality sound effects, you don't get many variants of one sound effect, you don't get a lot of sound effects with a similar texture, and you don't get proper categories either."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:09:47
    quote: "One more very important thing: if you have to use a sound effect repeatedly — say you need a whoosh three or four times in a row — don't use the same whoosh sound there. It sounds really odd, people pick up on it."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:09:42
    quote: "freesound.org or Pixabay, where you'll get free sound effects."
research_refs:
  - https://universalcategorysystem.com/
  - https://www.epidemicsound.com/sound-effects/
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Advanced_Audio_Coding
difficulty: medium
detectable_from: audio
---

# Four deficits of a scraped sound — the quality gate a source must pass

## What it is
The source's case against ripping effects off YouTube is notably **not** about copyright. It is four specific, testable deficits: low audio quality, no variants of a single sound, no families of similarly-textured sounds, and no proper category structure. Each one is a workflow failure with a measurable symptom, and each one shows up in the finished video rather than in a takedown notice.

This note turns those four complaints into a gate a source must pass before it is allowed into a project's sound library, with a check for each. Clearance — whether you may legally use a sound in a monetised or client delivery — is a separate gate and lives in [[sfx-source-licensing-and-clearance]]; passing this one says nothing about that one.

**Style.** No `sfx/` style tag: the four deficits apply to any source file whatever style it ends up serving — variants matter most for motion whooshes, families for aesthetic design sounds, fidelity for diegetic Foley — but the gate is the same one.

## When to use it
- **Once per source, not once per file.** The gate qualifies a *library* — Epidemic, freesound.org, Pixabay, a purchased pack, a YouTube rip — and everything from a passing source is then trusted.
- **At project setup**, before the first sound is placed, so the sound pass is not interrupted by sourcing decisions ([[sfx-library-build-and-taxonomy]]).
- **When a video sounds cheap and nobody can say why.** Two of the four deficits (repetition and texture mismatch) present exactly as "cheap" without ever presenting as a specific defect.
- **When an effect will be used more than twice.** Variant depth is the deficit that only bites on repetition, and repetition is the source's third named sound-design mistake.
- **Not as a reason to reject a single perfect file.** A one-off from a failing source can be used; it just cannot be the library. Ingest it, treat it, and note its provenance.

## How to recognise it in a reference video
The four checks, each with its measurement:

**1. Format quality — is this a first-generation asset?**
- The fingerprint of a lossy re-encode is a hard spectral shelf. YouTube audio is delivered as AAC (typically 128–192 kbps), and its encoder low-passes: content simply stops, usually somewhere between **15 and 16 kHz**, with a cliff rather than a slope.
  ```bash
  ffmpeg -i suspect.wav -lavfi "showspectrumpic=s=1024x512:legend=1" spectrum.png
  ffprobe -v error -show_entries stream=codec_name,sample_rate,channels,bits_per_raw_sample suspect.wav
  ```
- Gate: **48 kHz or higher, 16-bit minimum and 24-bit preferred, delivered as WAV**, with no shelf below 18 kHz. A file that arrives as MP3 or AAC has already spent a generation; a second encode at delivery compounds it.
- Practical tell in a reference: pitch a suspect effect **down** by 0.6 and listen. Codec artefacts that were masked at pitch become obvious swirl in the top end. This is also why pitched-down scraped effects sound worse than pitched-down library ones ([[sfx-pitch-ratio-point-six]]).

**2. Variant depth — can the same action happen three times?**
- Gate: **at least 3 interchangeable files** per sound the project will repeat, or a source large enough to supply them on demand.
- Measurement in a reference: two occurrences with identical duration *and* identical peak offset are the same file. Three uses of one file is audible as a template.
- Scale check: `swooshes--whoosh` in the Epidemic catalogue holds **975** effects; `designed--riser` holds **478**. A YouTube "whoosh pack" typically offers 5–20, which is under the gate the moment a video has more than a handful of transitions.

**3. Texture families — do neighbours exist?**
- Gate: the source can return sounds that are *near* a chosen one, not merely sounds that share a keyword. This is the deficit that produces the "each effect sounds like it came from a different video" problem.
- Measurement: pick one effect and ask the source for five siblings. A real library answers with a similarity query; a folder of rips answers with a filename sort.

**4. Categories — is it machine-filterable?**
- Gate: a structured taxonomy with stable identifiers, not filenames. Epidemic's slugs take the form `<category>--<name>` (`designed--riser`, `swooshes--whoosh`, `ambience--room-tone`, `fight--impact`) and combine with `ALL` / `ANY` / `NOT_ANY`.
- The cross-library standard is the **Universal Category System** — a public-domain initiative by Tim Nielsen, Justin Drury, Kai Paquin and others, currently v8.2.1, structuring names as `CatID` plus Category, SubCategory and FXName. A source with no taxonomy at all cannot be queried by an agent, only browsed by a human.
- Measurement in a reference: not observable in the video, but observable in how the video's effects cluster. Sounds drawn from a taxonomy sit in consistent families; sounds drawn from a downloads folder do not.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Sample rate | 48 kHz | ≥ 44.1 kHz | 48 kHz is the video standard; resampling a 44.1 file is fine, upsampling a lossy one recovers nothing. |
| Bit depth | 24-bit | ≥ 16-bit | Matters most for quiet effects that will be gained up. |
| Delivery format | WAV | WAV preferred, MP3 tolerated | `DownloadSoundEffect` accepts `{"fileType":"WAV"}` or `"MP3"`; always take WAV. |
| Lossy-shelf threshold | none below 18 kHz | — | A cliff at 15–16 kHz means an AAC/MP3 generation already happened. |
| Variants required | 3 | ≥ 3 for any repeated action | Or 1 file plus pitch/length/reverb variation. |
| Family size for a repeated family | ≥ 100 | ≥ 30 | Below ~30 the source runs out on a busy edit. |
| Similarity query | required | — | `SearchSimilarToSoundEffect` by id, or an equivalent. |
| Taxonomy | stable slugs | — | Filenames are not a taxonomy. |
| Duration filter semantics | file length | — | Verified: it filters the delivered file, not the audible event. |
| Padding ratio (measured) | ~1.4% | — | Only **14 of 975** whoosh files fall in a 200–1200 ms window; most ship with silence and tail. |

## Reproduction prompt
```
Qualify a sound source before adopting it as this project's library.

INPUT: {{SOURCE}} - a library, a pack, or a folder of downloads.

1. FORMAT CHECK. Take three representative files.
     ffprobe -v error -show_entries stream=codec_name,sample_rate,channels,\
       bits_per_raw_sample -of default=nw=1 <file>
     ffmpeg -i <file> -lavfi "showspectrumpic=s=1024x512:legend=1" spec.png
   PASS if: >= 44.1 kHz (48 preferred), >= 16-bit, PCM/WAV, and no hard spectral
   shelf below 18 kHz. A cliff at 15-16 kHz means the file already went through a
   lossy encoder - FAIL for library use, tolerable for a single one-off.
2. VARIANT CHECK. Pick the one sound this project will use most (usually a whoosh
   or a transition hit). Ask the source for its family size. PASS if >= 30 files,
   comfortably if >= 100. FAIL if the answer is a folder with under 10.
3. TEXTURE CHECK. Choose one file and ask the source for five sounds that are
   NEAR it, not five that share its keyword. PASS if it can answer at all -
   Epidemic answers with SearchSimilarToSoundEffect on the id. FAIL if the only
   available operation is a filename sort.
4. TAXONOMY CHECK. Confirm the source exposes stable identifiers you can filter
   on. Run one query by identifier and one by free text and compare. PASS if the
   identifier query is repeatable and returns a coherent family; note that free
   text alone degrades - a vague multi-word term returns thousands of unrelated
   results.
5. RECORD THE VERDICT in the project's library ledger, append-only, with the four
   results, the date, and one line on what the source is allowed to be used for.
   Do not delete a previous verdict; supersede it.
6. SEPARATELY run the clearance gate. This gate is about usability, not rights.
   A source can pass all four checks and still be unusable in a monetised or
   client delivery.
7. ACCEPTANCE TEST: all four checks recorded with a pass/fail and a number, not a
   judgement; and any FAIL is accompanied by the mitigation you will use (e.g.
   "variants: FAIL, mitigate by generating 3 pitch/length variants per use").
```

## Execution spec

**Epidemic Sound.** How the MCP surface answers each of the four deficits:

| Deficit | The capability that answers it |
|---|---|
| Quality | `DownloadSoundEffect` with `{"fileType":"WAV"}` — first-generation PCM rather than a re-encode. `bundle: true` where a related set is offered. |
| Variants | Family sizes are queryable: `SearchSoundEffects` with `tagSlugs` returns `meta.total` (975 for `swooshes--whoosh`, 478 for `designed--riser`). |
| Texture families | `SearchSimilarToSoundEffect { id }` returns `similarSoundEffects` — neighbours by sound, not by name. |
| Categories | `tagSlugs` with `matchType` `ALL` / `ANY` / `NOT_ANY`, slugs in `<category>--<name>` form, and a verified fail-closed behaviour: an unknown slug returns `meta.total: 0`. |

```json
// family size probe
{ "filter": { "tagSlugs": { "matchType": "ALL", "values": ["swooshes--whoosh"] } }, "first": 1 }
// neighbours of a chosen file
{ "id": "<uuid from a prior search>", "first": 6 }
```
**Known environment gap, verified:** `audiocdn.epidemicsound.com` is blocked by this project's egress allowlist (403 on CONNECT). `DownloadSoundEffect` returns a signed `assetUrl` successfully, but fetching the bytes has to happen from a host where that domain is permitted. Plan the sourcing leg accordingly — the search and selection work here, the download does not.

**ffmpeg — ingest and normalise whatever passes.**
```bash
# normalise an ingested file to the project's working format
ffmpeg -i in.mp3 -ar 48000 -ac 2 -c:a pcm_s24le sfx/whoosh_01.wav
# spectrum check for the lossy shelf
ffmpeg -i sfx/whoosh_01.wav -lavfi "showspectrumpic=s=1024x512:legend=1" spec.png
# generate the three variants the source demands, from one file
ffmpeg -i sfx/whoosh_01.wav -af "rubberband=pitch=0.85" sfx/whoosh_01_lo.wav
ffmpeg -i sfx/whoosh_01.wav -af "rubberband=pitch=1.15" sfx/whoosh_01_hi.wav
```
Register anything ingested so it lands in the ledger like any other asset: `node <SKILL_DIR>/scripts/resolve.mjs --from <file> --type sfx --project .`

**Hyperframes.** Placement is unaffected by provenance, but two constraints bear on library management. Assets must live **inside the project** so the compiler and render can reach them (`.media/audio/sfx/` or `assets/sfx/`). And the mounted vault **cannot delete files**, so a library is append-only: a rejected source's files are superseded by a note in the ledger, never removed. Never set `crossorigin` on a media element to reach a remote asset — it is a lint error with no suppression.

**Remotion.** No difference; sourcing is upstream of any renderer.

## Pairs with
[[sfx-source-licensing-and-clearance]] · [[sfx-library-build-and-taxonomy]] · [[sfx-vocabulary-llm-expansion]] · [[sfx-name-before-search]] · [[sfx-density-fatigue-audit]] · [[sfx-pitch-ratio-point-six]] · [[sfx-reverb-glue]] · [[sfx-substitute-material-foley]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-intensify-without-referent]]

## Failure modes
- **Treating this as the copyright question.** It is not. A source can pass all four checks and still be uncleared; run [[sfx-source-licensing-and-clearance]] separately.
- **Judging quality by ear at low level.** Codec artefacts hide under a mix and emerge the moment an effect is pitched down or gained up. Check the spectrum, and check it before treatment.
- **Re-encoding on ingest.** Converting an MP3 rip to WAV does not restore anything; it just hides the evidence from `ffprobe`'s codec field while leaving the 15–16 kHz shelf in place.
- **Assuming a large catalogue means a large family.** Total catalogue size is irrelevant; the number that matters is the size of the *family you will repeat*. Probe it.
- **Over-narrowing with the duration filter.** It filters delivered file length, not the audible event — 14 of 975 whooshes fall inside 200–1200 ms. Leave it wide and trim with `data-media-start`.
- **Building a library with no taxonomy because "I'll remember".** An agent cannot browse a folder by memory. Without stable identifiers, every future fetch is a fresh guess.
- **One file, three uses.** The deficit that survives every other precaution. Either three files or three variants — never the same asset twice inside 90 s.
