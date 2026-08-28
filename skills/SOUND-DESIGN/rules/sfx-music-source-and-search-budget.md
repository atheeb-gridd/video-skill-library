---
id: sfx-music-source-and-search-budget
title: Budget the music search — and pick the library whose search is worth the budget
skill: sound-design
type: music
family: music-selection
tags: [skill/sound-design, type/music, family/music-selection, engine/epidemic, engine/ffmpeg, engine/hyperframes, layer/music, sfx/aesthetic, source/editing-kt, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:12:41"
    quote: "By the way, you should put a lot of time into finding the right music, because it really matters that it fits."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:12:47"
    quote: "The YouTube Audio Library has a few good royalty-free songs, and every now and then you'll find real gems from artists like Let Me Know who give their songs away for free. But to be honest, subscribing to a licensed music platform is the best move if you want to take YouTube seriously."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:13:01"
    quote: "I'm not sponsored, but last time it saved me about four hours and I found way better songs."
research_refs:
  - https://en.wikipedia.org/wiki/Content_ID
  - https://support.google.com/youtube/answer/3376882
  - https://en.wikipedia.org/wiki/Epidemic_Sound
  - https://en.wikipedia.org/wiki/EBU_R_128
difficulty: low
detectable_from: transcript
---

# Budget the music search — and pick the library whose search is worth the budget

## What it is
Two claims from one passage, and they are the same claim seen from two ends. The first is editorial: music **fit** matters enough to justify real search time, so do not take the first track that sounds nice. The second is operational: the four hours the presenter says a licensed platform saved him were not spent listening — they were spent *failing to find*, which is a property of the library's search, not of his ears.

That reframes the platform decision. A music source is not chosen on catalogue size or on price. It is chosen on three things an unattended pipeline can actually evaluate: **queryability** (can a mood brief be converted into a filtered candidate set without listening?), **claim risk** (what happens on YouTube when the video goes live?), and **coverage durability** (is the video still cleared next year?). The creator's ranking — YouTube Audio Library has a few usable tracks, individual artists occasionally give tracks away, a subscription library is the serious move — is correct, and the reason is queryability: the free routes have almost none.

The other half of this note is the part the source does not supply: a **budget and a stopping rule**. "Put a lot of time into it" without a ceiling is how a two-hour edit becomes a six-hour edit. The time is worth spending only because the search is structured ([[sfx-three-parameter-music-search]]) and bounded.

## When to use it
- **Once per project, before the first bed is placed**, and again at any point the project gains a section whose mood is more than about 15 BPM or one mood-quadrant away from the existing bed ([[sfx-mood-map-per-topic]]).
- **Whenever a new source is proposed.** A track offered by a client, pulled from a YouTube "no copyright" upload, or found on an artist's own page enters through this gate before it enters the library ([[sfx-source-licensing-and-clearance]]).
- **On any monetised delivery**, where a Content ID claim is a revenue event and not just an annoyance.
- **Not per cue.** Sound effects do not get this treatment; they are found by name ([[sfx-name-before-search]]) and auditioned in a rack ([[sfx-ab-audition-candidates]]). This note is about the music layer only.
- **Not when the video has no music.** A dialogue-only piece, an ASMR-adjacent piece, or anything where the bed would fight the content skips the whole exercise — see the rest windows in [[sfx-music-rest-windows]].

## How to recognise it in a reference video
This is a process, so the observable evidence is a **quality signature in the finished mix** plus **paratext**. Log the evidence, not the vibe.

- **Track count per running time.** Count distinct beds. A video with one bed looping across the whole runtime was searched once; a 10-minute video carrying **3–6 distinct beds that change on section boundaries** is the signature of a budgeted, per-section search ([[sfx-track-change-at-section-boundary]]). More than about one track per 90 s is churn, not care.
- **Tempo agreement with delivery.** Measure the presenter's edited words per minute over a 120 s window and the bed's BPM. A fitted bed sits at roughly `BPM ≈ 0.62 × WPM + 12` (see [[sfx-bpm-perceptual-bands]] and the band table in `pace-speech-rate-to-bpm-map`). A gap of more than ~25 BPM from that band, or a bed at 1.5× the delivery, means the track was chosen by sound alone.
- **Vocal discipline.** Vocals present *only* where the presenter is silent. A vocal bed under narration is the single loudest signal that no search discipline exists ([[sfx-vocal-vs-instrumental-bed]]).
- **The bed has an arc.** Intro cue, teaching bed, a rest, an outro cue. One track fading in at 0:03 and out at the end is a placeholder that shipped.
- **Paratext on the video page:** a "Music from …" credit line, an affiliate or referral link, or a Creative Commons attribution block in the description. A CC attribution block means the free route was used and its obligations were met; **no credit line at all plus obviously-licensed-sounding music** means either a subscription library (no credit required) or an unlicensed rip — resolve that before copying the approach.
- **Claim state.** On YouTube, a video carrying music with a visible copyright notice, or one that is region-blocked, is evidence the source failed the claim-risk test. Content ID's three claim actions are **block, monetize (revenue to the claimant), and track**; a failed dispute can escalate to a strike, and three strikes removes the channel. That is the risk being managed.
- **Transcript tell:** the presenter naming a platform, or saying a track "took forever to find", places the technique explicitly.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `search_budget_per_section` | 12 min | 6–25 min | Wall-clock ceiling for finding one section's bed, filtering included. Past the ceiling, ship the best shortlisted candidate and move on; a bed can be swapped later, a stalled edit cannot. |
| `shortlist_size` | 5 | 3–8 | Candidates downloaded before any auditioning against picture. Below 3 there is no comparison; above 8 the memory of the first is gone. |
| `audition_slice` | 30 s | 20–45 s | One representative slice of locked cut, identical for every candidate ([[sfx-music-audition-against-picture]]). |
| `stop_rule` | first candidate passing all 3 checks | — | Tempo band, mood quadrant, and no vocal conflict. Stop searching on the first pass; do not keep looking for better. |
| `tracks_per_10min` | 4 | 3–6 | Distinct beds. Fewer reads monotonous, more reads restless. |
| `bpm_filter_width` | ±10 BPM | ±5 to ±20 | Applied at query time, before listening ([[sfx-bpm-filter-first]]). |
| `duration_floor` | 90 s | 60–180 s | Filter out anything shorter than the section it must cover; looping a 40 s stinger under a 4-minute section is audible. |
| `claim_propagation_lead` | 3 days | 1–7 days | Connect the publishing channel to the library and let the whitelist propagate **before** publishing. Claims that fire because the channel was linked the same morning are self-inflicted. |
| `subscription_state_at_publish` | recorded | active · lapsed | Written per asset into `library.json`. The clearance question is always "was the subscription active when this video was published" — record the fact rather than trusting memory ([[sfx-source-licensing-and-clearance]]). |
| `post_lapse_policy` | verify-per-platform | verify · re-license · replace | Platforms differ on whether already-published videos stay cleared after cancellation, and terms change. **Do not encode a remembered answer.** Verify at subscribe time, record the clause, and re-verify before cancelling. |
| `credit_line` | as required by source | none · cc-attribution · courtesy | Subscription libraries generally require none; Creative Commons tracks require artist, title, source link and licence name in the description. |

**Source comparison — the fields that decide, not the marketing:**

| Source | Queryability | Claim risk | Cost of a mistake | Use it for |
|---|---|---|---|---|
| **YouTube Audio Library** | Weak — genre/mood/duration/attribution only, no BPM filter, no instrument facets | Lowest. YouTube states its own library's music and effects *"won't be claimed by a rights holder through the Content ID system"*, and that *"only music and sound effects from the Audio Library are known to YouTube to be copyright-safe."* | None on YouTube; **off-YouTube use is not what the library documents**, so treat non-YouTube delivery as uncleared | A YouTube-only video with no tempo requirement; a safety fallback when a licensed track is disputed |
| **Free-from-the-artist** | None — you found one track, there is no second query | Unknown and unverifiable per track. The grant is a message or a page, not a licence file | High: no paper trail years later | One-off hero tracks, only with the permission archived alongside the file |
| **Freesound / CC libraries** | Moderate for effects, poor for beds | Depends entirely on the per-file licence; CC-BY-NC is unusable on anything monetised | Attribution failure is a licence breach, not a courtesy lapse | Effects and textures, under the clearance gate |
| **Subscription library (Epidemic Sound and peers)** | **The reason to pay.** Structured filters — BPM range, mood slugs, featured-instrument slugs, genre/decade/country taxonomy, vocals true/false, musical key, duration — plus stems and similarity search | Low **once the channel is linked and propagated**; the mechanism is a whitelist against Content ID, so an unlinked channel can still be claimed | A lapsed subscription raises a coverage question about past uploads — record the state | Everything else; the default for serious channels, exactly as the source says |

Two facts worth carrying: a subscription library's protection is **operational, not magical** — it works because your channel is on a list, so linking and propagation are part of the workflow, not an afterthought. And the **structured filter set is the four hours**: converting "warm, hopeful, mid-tempo, no vocals, piano-led, at least two minutes" into a query is a single call against a faceted library and an afternoon of scrubbing anywhere else.

## Reproduction prompt

```
Choose the music beds for this video under a time budget.

STEP 1 — BRIEF, before any listening. Segment the locked cut by topic change. For each
section write one line: {section_id, in_s, out_s, emotion, target_BPM_band, vocals_allowed}.
Derive target_BPM_band from the presenter's edited words per minute over a 120 s window:
BPM ~= 0.62 * WPM + 12, rounded to the nearest 5, then +/-10 BPM. Set vocals_allowed = false
for any section where the presenter speaks; true only for a narration-free montage.

STEP 2 — QUERY, not scroll. For each section run ONE faceted search against the licensed
library using every facet the brief supplies: BPM range, mood, featured instrument, genre,
vocals boolean, and a duration minimum equal to the section length. Take the top {{N=5}}
results as the shortlist. Do not audition anything outside the shortlist.

STEP 3 — AUDITION. Download all 5. Loudness-normalise each to a common target so the
comparison is fair. Build one preview per candidate over the SAME {{SLICE=30}}s slice of
locked cut, with the bed at -22 dB relative to the dialogue. Play them back to back.

STEP 4 — STOP. Accept the first candidate that passes all three checks: (a) tempo inside
the band, (b) mood matches the brief line, (c) no vocal conflict. Do not keep searching for
better. Hard ceiling {{BUDGET=12}} minutes per section; at the ceiling, take the best
shortlisted candidate and move on.

STEP 5 — RECORD. For every accepted track write into library.json: id, title, source
platform, licence type, download date, subscription_state_at_publish, and whether a credit
line is required. Emit the credit lines the licence demands into the description block.

ACCEPTANCE TEST: every section has exactly one bed; total distinct beds is 3-6 per 10
minutes of runtime; no bed sits more than 25 BPM outside its section's band; no vocal bed
overlaps narration by even one frame; every entry in library.json has a non-empty licence
field; and the publishing channel was linked to the library at least 3 days before publish.
```

## Execution spec

**Epidemic Sound — the exact queries.** The music side is `SearchRecordings`, and its filter set is what this whole note is about. Real parameter shape (verified against the tool schema — note `filter.vocals` is a **boolean**, mood/instrument/taxonomy filters take `{matchType, values}` slug objects, and `filter.duration` is in **milliseconds**):

```jsonc
// A calm teaching bed for a 170 WPM presenter: band 110-130, instrumental, >= 2 min.
SearchRecordings {
  query:  { term: "warm hopeful piano underscore" },
  filter: {
    bpm:      { min: 110, max: 130 },
    vocals:   false,
    duration: { min: 120000 },
    moodSlugs:              { matchType: "ANY", values: ["hopeful", "laid-back", "sentimental"] },
    featuredInstrumentSlugs:{ matchType: "ANY", values: ["piano", "acoustic-guitar"] },
    taxonomySlugs:          { matchType: "ANY", values: ["ambient", "lo-fi"] }
  },
  sort:  { by: "RELEVANCE", order: "DESCENDING" },
  first: 5
}
```

- **Filter before you sort.** `bpm`, `vocals` and `duration.min` do the elimination; `query.term` only ranks what survives. A term-only search is the unstructured route the four hours were lost to.
- Use `matchType: "ANY"` for moods (a bed rarely carries three moods at once) and `"ALL"` only when two facets genuinely must co-occur.
- `SearchSimilarToRecording` against the accepted track is the cheapest way to fill a second section that must feel related but not identical ([[sfx-find-similar-track-handover]]).
- `Recording.stems` (DRUMS / BASS / MELODY / INSTRUMENTS / CLEAN_VOCALS / VOCALS) is why a licensed library also solves the rest-window problem — drop to the MELODY stem instead of dropping the bed ([[sfx-music-stem-layering]]).
- `DownloadRecording` writes the file; the pipeline stops there. Convention: `.media/audio/bgm/<section>-<slug>.mp3`.

**Placement spec (identical for every candidate, so the audition is fair).** The bed starts on the section's first frame and ends on its last; there is no offset relative to a visual event, because a bed is not an event. Gain **−22 dB relative to dialogue** (`data-volume="0.079"`), range −25 to −20; ducking is a **carve against the voiceover group at strength 0.25**, never a blanket volume duck ([[sfx-layer-volume-targets]], [[sfx-dialogue-gate]]).

**HyperFrames.** All authored time is in seconds. Audio lives at the host root in a modular project so playback survives scene cuts; every `<audio>` needs an `id` or it is never mixed and the render is silently missing it.

```html
<audio id="vo-s2" src=".media/audio/voice/s2.wav" data-audio-group="voiceover"
       data-start="94.0" data-track-index="10"></audio>

<audio id="bed-s2" src=".media/audio/bgm/s2-warm-hopeful-118.mp3"
       data-audio-group="music"
       data-start="92.0" data-duration="181.0" data-media-start="12.4"
       data-track-index="12" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```

Then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`. Write the audio JSON attributes **double-quoted with `&quot;`** — `carve.mjs` finds them with a `name="..."` regex and a single-quoted attribute is invisible to it, so the carve silently overwrites work it could not see. `data-fx-carve` lives on the **bed**, never on a voice, and its `sources` must name a **group**, not a list of clip ids (`audio_carve_ungrouped_sources`).

**ffmpeg — the parity rig for step 3.** Normalise every candidate to a common target before comparing, or the loudest one wins the audition on level rather than on fit:

```bash
SLICE_IN=92.0; SLICE_LEN=30
ffmpeg -ss $SLICE_IN -t $SLICE_LEN -i locked_nobgm.mp4 -c copy slice.mp4
for t in cand1 cand2 cand3 cand4 cand5; do
  ffmpeg -i bgm/$t.mp3 -af "loudnorm=I=-23:TP=-2:LRA=7" -ar 48000 norm-$t.wav
  ffmpeg -i slice.mp4 -i norm-$t.wav -filter_complex \
    "[1:a]atrim=0:$SLICE_LEN,volume=-22dB[b];[0:a][b]amix=inputs=2:normalize=0[a]" \
    -map 0:v -map "[a]" -c:v copy ab-$t.mp4
done
```
Two-pass `loudnorm` (measure with `print_format=json`, then apply the measured values) is the accurate form; the single pass is adequate for candidate parity. Programme target for socials is `I=-14:TP=-1.5:LRA=11`; EBU R 128 broadcast is −23 LUFS with a −1 dBTP ceiling, and its measurement windows — **400 ms momentary, 3 s short-term** — are why a 30 s slice is the shortest honest audition.

**Known gap.** The `media-use` `resolve --type bgm` catalogue path and `--doctor` are network routes behind the HeyGen CLI, which the egress allowlist here does not cover; Epidemic MCP is the sanctioned substitute. `audio-duck.mjs` expects an `audio_meta.json` that an Epidemic-sourced project does not produce, so drive the carve off the composition instead.

**Remotion:** conceptually an `<Audio>` with a `volume` callback for the bed; there is no Remotion runtime in this project.

## Pairs with
- [[sfx-three-parameter-music-search]] — the BPM / instrument / vibe query this budget executes
- [[sfx-bpm-filter-first]] · [[sfx-bpm-perceptual-bands]] — the tempo facet
- [[sfx-mood-vibe-filter]] · [[sfx-mood-map-per-topic]] — the mood facet and the per-section brief
- [[sfx-music-audition-against-picture]] — step 3 in full
- [[sfx-track-shortlist-library]] — where the shortlist is kept between projects
- [[sfx-source-licensing-and-clearance]] — the clearance gate this note feeds
- [[sfx-vocal-vs-instrumental-bed]] · [[sfx-vocal-track-for-narration-free-montage]] — the vocals boolean
- [[sfx-track-change-at-section-boundary]] · [[sfx-find-similar-track-handover]] — the per-section change
- [[sfx-layer-volume-targets]] · [[sfx-dialogue-gate]] — the −22 dB placement and the carve
- [[pace-speech-rate-to-bpm-map]] — the WPM→BPM band table
- [[sfx-music-cue-sheet-per-segment]] — the per-section cue sheet the brief becomes

## Failure modes
- **Unbounded search.** "Put a lot of time into it" taken literally turns into an afternoon. Without `search_budget_per_section` and a stopping rule, the note's own advice is the failure. Ship the best shortlisted candidate at the ceiling.
- **Searching by term only.** Typing "epic inspiring" into a faceted library and scrolling is the exact behaviour a subscription is bought to eliminate. If the query has no `bpm`, no `vocals` and no `duration.min`, it is not a search.
- **Auditioning un-normalised candidates.** The loudest file wins, and the choice is level, not fit. Normalise first.
- **One bed for a whole video.** Passes every check individually and still reads as a placeholder, because the music has no arc. Budget per section, not per project.
- **Linking the channel on publish day.** The whitelist has not propagated, the claim fires, and the licence is blamed. Link and wait.
- **Trusting a remembered licence clause.** Platform terms change, and post-cancellation coverage is exactly the clause most likely to have changed since anyone last read it. `post_lapse_policy` is deliberately `verify-per-platform`; an unattended pipeline must record the clause, not recall it.
- **A free track with no archived grant.** "The artist said it was fine" is not retrievable in two years. Archive the permission next to the file or do not use it.
- **Treating a CC-BY credit as optional.** Attribution is a licence condition; omitting it is a breach, not a discourtesy. It belongs in the description, reachable from the deliverable.
- **Changing beds to solve a mix problem.** If the voice is unintelligible over the bed, the fault is the carve or the level, not the track. Fix the mix before re-opening the search.
