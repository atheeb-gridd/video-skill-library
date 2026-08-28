---
id: sfx-source-licensing-and-clearance
title: Clearance gate — which source a sound may come from, per delivery
skill: sound-design
type: sfx
family: library
tags: [skill/sound-design, type/sfx, family/library, engine/epidemic, engine/ffmpeg, layer/sfx, layer/music, source/editing-kt, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt.mp4
    timestamp: 00:11:02
    quote: "If you need more, check out freesound.org or grab Epidemic Sound."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:09:36
    quote: "[context: you might have] a copyright claim coming in for a sound effect. I mean, look, besides YouTube there are other platforms too, like freesound.org or Pixabay, where you'll get free sound effects."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:04:25
    quote: "Look, you can just grab sound effects from YouTube, and mostly you don't run into any copyright issues, because what's really going to happen over a sound effect, but on YouTube you mostly get low quality sound effects, you don't get many variants of one sound effect."
research_refs:
  - https://freesound.org/help/faq/
  - https://universalcategorysystem.com/
  - mcp://Epidemic_sounds/DownloadSoundEffect (the sanctioned sourcing route in this project, per _meta/execution-contract.md)
difficulty: low
detectable_from: transcript
---

# Clearance gate — which source a sound may come from, per delivery

## What it is
Both source videos name three routes to a sound file — rip it off YouTube, take it from a free CC library (freesound.org, Pixabay), or subscribe to Epidemic Sound — and both are casual about the difference. That casualness is exactly what an unattended pipeline cannot afford. This note is the **gate**: a decision table that says, for a given delivery (monetised YouTube, client work, a paid course, a broadcast spot), which sources are permitted and what obligation each carries. It is deliberately a short, hard rule rather than a discussion, because the failure it prevents is the only failure in this whole library that survives publication and costs money.

The one substantive correction to the transcript: "mostly you don't run into any copyright issues, because what's really going to happen over a sound effect" is a statement about *enforcement probability*, not about rights. It is not a licence.

**Style.** No `sfx/` style tag: clearance is a property of a file's provenance, not of the job it does in the timeline — the same gate stands in front of a Foley recording, a whoosh pack and a designed riser alike.

## When to use it
- **Before any file enters the library** ([[sfx-library-build-and-taxonomy]]). Licence is a required ingest field.
- **Before any unattended run** that will fetch new assets. An agent must not be free to pick a source; it must be told which sources are permitted for this delivery.
- **When a delivery changes** — the same edit going from "internal review" to "client's monetised channel" re-runs this gate over every asset, and a CC-BY-NC bed becomes a blocker.
- **When a claim arrives.** The `library.json` licence field plus the query record *is* the dispute evidence.

## How to recognise it in a reference video
This is not a technique you detect by watching. What you *can* detect is the tier a creator is on, which tells you what your reproduction will cost:
- **Sponsor read or on-screen mention** of a subscription library ("all of them are from Epidemic") — the creator is on a subscription tier, so their variant depth and their ambience coverage are reproducible only with the same kind of access.
- **Variant depth as a proxy.** 5+ distinct whooshes and location-matched ambience for every scene is a subscription-library signature; free libraries have the files but rarely the matched sets, which is exactly the complaint the source makes about YouTube rips.
- **Recognisable meme sounds** (a specific TV sting, a game sound, a chart-charting song fragment) are a different clearance class entirely and are **not** reproducible from any of the three routes — flag them in the analysis as unreproducible rather than logging a query for them.
- **A credits block or description crediting sound authors** indicates CC-BY material in the mix, which tells you the deliverable carries an attribution obligation.

## Parameters

| Parameter | Default | Range / vocabulary | Notes |
|---|---|---|---|
| `delivery` | monetised-youtube | internal · monetised-youtube · client-work · paid-product · broadcast | The gate's input. Everything else is derived from it. |
| `permitted_sources` | `[epidemic]` | epidemic · freesound-cc0 · freesound-cc-by · pixabay · own-recording | Default is deliberately the narrowest that works. |
| `blocked_sources` | `[youtube-rip, freesound-cc-by-nc, sampling-plus]` | — | `youtube-rip` is blocked for every delivery: there is no licence, only low enforcement. CC-BY-NC is blocked for anything monetised — the licence text bars work you "earn any money with". Sampling+ is retired by Creative Commons and survives only on legacy Freesound uploads; treat it as blocked because its terms are no longer maintained. |
| `attribution_required` | true when any `freesound-cc-by` asset is used | — | Credit format: sound title, uploader username, link to the sound page, licence name. A long list may be a summary line plus a link to full credits. |
| `attribution_location` | video description | description · end card · linked credits page | Must be reachable from the deliverable, not only from your notes. |
| `licence_field` | required | cc0 · cc-by · cc-by-nc · sampling-plus · epidemic-subscription · own | Stored per file in `library.json`. No file without one. |
| `subscription_state_at_publish` | recorded | active · lapsed | Record the date the asset was downloaded and whether the subscription was active. Subscription libraries clear the *publication*, and the state at publication is the fact that matters. |
| `ai_training_flag` | respect | — | Freesound uploaders can set a generative-AI-training preference **independently of the CC licence**, so a CC0 sound may still be marked no-AI-training. Irrelevant to editing it into a video; relevant the moment a pipeline feeds the library to a model. |
| `client_redistribution` | check | — | The asset is cleared for *your* delivery, not handed to the client as raw media. Deliver the mix, not the library. |
| `unreproducible_flag` | — | — | Recognisable commercial music/TV/game audio: mark it unreproducible in the design document and substitute. |

## Reproduction prompt

```
Run the clearance gate over the asset list for {{PROJECT}} before the sound
pass fetches anything.

1. READ THE DELIVERY from the project brief: internal, monetised-youtube,
   client-work, paid-product or broadcast. If it is not stated, assume
   monetised-youtube - it is the strictest of the common cases.
2. SET permitted_sources:
   - monetised-youtube / client-work / paid-product / broadcast
     -> [epidemic, freesound-cc0, own-recording]; add freesound-cc-by ONLY
        if you can also write the attribution block into the deliverable.
   - internal -> the above plus freesound-cc-by-nc.
   - NEVER any delivery -> youtube-rip. There is no licence, only low
     enforcement, and the source video's remark about this is about
     enforcement, not rights.
3. AUDIT EVERY EXISTING ASSET in library.json. Any record with no licence
   field, or a licence outside permitted_sources, is a BLOCKER. List the
   blockers with their timeline positions before doing anything else.
4. SUBSTITUTE each blocker: run the family's Epidemic query, fetch a
   replacement of the same length band, and re-place it using the family
   note's placement rule. Do not simply lower a blocker's volume.
5. BUILD THE ATTRIBUTION BLOCK if any cc-by asset survives: one line per
   asset - title, uploader, sound-page URL, licence - written into the
   deliverable's description text, not just into project notes.
6. RECORD, per asset: source, licence, download date, subscription state at
   download, and the query that found it.
7. FLAG UNREPRODUCIBLE AUDIO separately: any recognisable commercial song,
   TV sting or game sound in the reference. It is not a query, it is a
   substitution task for the design document.

ACCEPTANCE TEST: every asset placed in the composition resolves to a
library.json record whose licence is inside permitted_sources for this
delivery, and the attribution block - if required - exists as text in the
deliverable. Zero records with an empty licence field. If any check fails,
the sound pass is not finished regardless of how it sounds.
```

## Execution spec

**Epidemic Sound is the sanctioned route in this project** — the execution contract states plainly that HeyGen catalogue retrieval and the `media-use` `resolve --type bgm|sfx|voice` network paths are unavailable here and *"Epidemic Sound MCP is the sanctioned audio-sourcing route."* So the practical default is: `permitted_sources = [epidemic, own-recording]`, and anything else is an exception you argue for.

```
SearchSoundEffects { query:{term:"<family term>"}, filter:{duration:{min:<ms>,max:<ms>}} }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }   # returns assetUrl
```
Record the returned `id` (a UUID) in `library.json` as the asset's canonical identity — it is stable, unlike a filename, and it is what makes a later "where did this come from" answerable. `SearchRecordings` / `DownloadRecording` are the same story for music, and music is the higher-risk half: a music claim is enforced by automated content-ID in a way a 400 ms whoosh is not.

**Freesound, when it is permitted.** The three live licences are **CC0** (do essentially anything), **CC-BY** (commercial use fine, attribution mandatory) and **CC-BY-NC** (attribution mandatory *and* no commercial use — which includes monetised video). **Sampling+** persists only on legacy uploads and is being phased out because Creative Commons retired it. There is no API access configured in this stack, so a Freesound asset arrives as a manual ingest: `node <SKILL_DIR>/scripts/resolve.mjs --from <file> --type sfx --project .` puts it in the ledger like any other asset — then the licence field is written by hand, because nothing derives it for you.

**ffmpeg — the only technical clearance step.** Ripped audio is often identifiable by its encode history, and re-encoding does not clear anything, so there is no ffmpeg command that makes an unlicensed file usable. The one genuinely useful command is provenance-adjacent: strip or set metadata on an ingested file so the library's own bookkeeping is the single source of truth rather than a vendor tag.
```bash
ffmpeg -i in.wav -map_metadata -1 -metadata comment="lic=cc0 src=freesound:123456 dl=2026-08-28" \
  -ar 48000 -c:a pcm_s24le out.wav
```

**HyperFrames.** Nothing in the composition layer knows about licences, and that is the risk: a blocked asset renders exactly as happily as a cleared one. The gate must therefore run against `library.json` *before* render, as a project step. Note also the vault constraint — **files cannot be deleted from the mount** — so a blocked asset cannot be removed; it must be marked `blocked: true` in `library.json` and superseded, and the gate must read that flag rather than assuming absence means clearance.

**Remotion:** identical concern, no difference in handling. Concept only.

## Pairs with
[[sfx-library-build-and-taxonomy]] · [[sfx-name-before-search]] · [[sfx-mouth-foley-record-and-process]] · [[sfx-substitute-material-foley]] · [[sfx-ambience-search-formula]] · [[sfx-music-audition-against-picture]] · [[sfx-find-similar-track-handover]] · [[sfx-music-stem-layering]] · [[struct-numbered-list-mid-roll-sponsor]]

## Failure modes
- **Treating low enforcement as a licence.** The source's own framing ("what's really going to happen over a sound effect") is the trap. Fix: `youtube-rip` is blocked for every delivery, full stop.
- **A CC-BY-NC bed under a monetised video.** The single most expensive mistake available here, because music is content-ID'd and a bed runs for minutes. Fix: the gate runs on music first.
- **Using CC-BY and forgetting the attribution.** A licence breach, not a courtesy lapse. Fix: the attribution block is a deliverable artefact and part of the acceptance test.
- **Handing the client the raw SFX folder.** Redistribution, which almost no subscription licence covers. Fix: deliver the mix and the stems you own; asset lists, not asset files.
- **Assuming a lapsed subscription retroactively breaks published videos.** Usually the opposite is true for subscription libraries — publication is what is cleared — but the recorded fact must be the state *at download and publication*. Fix: record the date and state; do not reason from memory.
- **Silently swapping a blocked asset for a different-length replacement.** Breaks the length match the placement note enforced. Fix: substitute inside the same duration band and re-check the placement.
- **Known gap:** the exact wording of the Epidemic Sound subscription licence could not be retrieved during this research pass (both the terms and the help-centre URLs 404'd / redirected). The note therefore states the *procedure* — record source, id, date and subscription state, deliver the mix not the library — and deliberately does **not** assert what the licence permits. Read the current subscription terms once per project and record the answer next to the profile; do not infer it from this note.
