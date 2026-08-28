---
id: sfx-find-similar-track-handover
title: Find Similar for a track handover — what it actually matches, and what you must match yourself
skill: sound-design
type: music
family: music-transition
tags: [skill/sound-design, type/music, family/music-transition, engine/epidemic, engine/hyperframes, engine/ffmpeg, sfx/aesthetic, layer/music, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:09
    quote: "I usually change the music whenever the section changes, and moving from one track to another is a bit tricky."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:15
    quote: "On Epidemic Sound you can use \"find similar\" to find a track with a similar beat or vibe and drop that in."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:19
    quote: "That makes the music transition feel really smooth. But if the vibe has changed, or you can't find a track with a similar vibe,"
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:24
    quote: "then stop the first track, put in a riser sound, and start the second track at the end of the riser."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:38
    quote: "Every track has a little warm-up at the start - ignore that and start straight from the main beat."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Beatmatching
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
  - mcp://Epidemic_sounds/SearchSimilarToRecording (behaviour measured live, 2026-08-28 - see Execution spec)
difficulty: medium
detectable_from: audio
---

# Find Similar for a track handover — what it actually matches, and what you must match yourself

## What it is
Changing tracks at a section boundary is named as the tricky part of music editing, and the source's fix is the library's **Find Similar** function: source the next track from the current one so beat and vibe carry across and the handover is nearly inaudible.

**Measured, the function does half of what the transcript claims.** Seeding `SearchSimilarToRecording` with a 110 BPM instrumental corporate track on 2026-08-28 returned ten results at **125, 103, 101, 136, 89, 148, 140, 127, 120 and 104 BPM** — a spread of 89–148, with only two of ten inside ±10 BPM of the seed. What *did* carry was the mood and genre vocabulary: `hopeful`, `happy`, `restless`, `dreamy`, `corporate`, `pop`. Find Similar matches **vibe, not tempo.**

That single finding is the note. Find Similar is the right tool and it solves the harder half of the problem — the half you cannot express as a filter, because "sounds like this" has no slug. But the tempo continuity that makes a crossfade actually disappear is **yours to enforce**, by re-applying a BPM filter over the similar set. Use it as a candidate generator, then filter.

## When to use it
- **At every section boundary where the music changes** and the *mood is staying the same*. This is the case Find Similar is built for: same feeling, new track, invisible seam.
- **When a track is too short for its section** and you need a continuation rather than a contrast.
- **When building a bed set for a long video** — one seed plus a filtered similar set gives a family of tracks that sound like one score instead of a playlist.
- **When you have a reference track you cannot license** (a temp track, a Spotify song the client loves): `SearchRecordings` accepts a Spotify track id as an external reference, which turns "make it sound like this" into a query.
- **Not when the mood changes.** The source is explicit about the alternative: stop the first track, place a riser, start the second at the end of the riser. A smooth handover across a mood change is the wrong goal — you want the seam to be *heard* as a turn ([[sfx-music-drop-on-structure-turn]]).
- **Not when the BPM difference exceeds about 8%.** Past that, no crossfade length hides the two tempos beating against each other; use the riser bridge or a hard beat change instead.
- **Not as a substitute for the vibe brief.** Find Similar propagates a decision; it does not make one ([[sfx-vibe-brief]]).

## How to recognise it in a reference video
- **Find the boundaries first.** Every point where the bed changes, stops or starts. Then classify each one:
  ```bash
  # measure the tempo either side of the boundary at <t>
  ffmpeg -ss <t-30> -t 25 -i ref.wav -vn -ac 1 -ar 22050 out_a.wav
  ffmpeg -ss <t+2>  -t 25 -i ref.wav -vn -ac 1 -ar 22050 out_b.wav
  # then tap or analyse each; aubio if available: aubiotempo -i out_a.wav
  ```
- **The BPM delta is the classifier.**
  - **Δ ≤ 3%** with a 1–3 s overlap → a matched crossfade. Deliberate, and almost certainly Find-Similar-sourced *and* BPM-filtered.
  - **Δ ≤ 8%** with a short overlap (≤1 s) landing on a beat → a beat-matched handover.
  - **Δ > 8% with an overlap** → the amateur signature. Two tempos audibly fighting for the length of the crossfade. Log it as a defect.
  - **Δ > 8% with no overlap**, separated by a riser or a beat of silence → the correct handling of a real change.
- **Listen for the warm-up.** Most production tracks open with 2–8 seconds of intro before the main beat. If the second track's first audible moment is already at full groove, the editor trimmed the warm-up — a real tell of competence, and one that appears as a non-zero `data-media-start`. If the section opens with a thin pad that grows for four seconds, they did not.
- **Check the boundary against the structure.** A handover on a narrative section boundary is designed; one mid-argument means the track simply ran out.
- **Check for the riser.** A 1–3 s rising sweep with its resolution on the new track's first downbeat is the source's own bridge. Its presence tells you the two tracks were *not* similar and the editor knew it.
- **Instrument continuity.** Name the two or three dominant instruments either side. Find-Similar-sourced pairs share instrumentation; unrelated picks do not. This is often more audible than the BPM.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `handover_type` | crossfade | crossfade · beat-match · riser-bridge · hard-beat · silence | Chosen by the BPM delta and whether the mood changed. |
| `bpm_delta_max_crossfade` | 3% | 0–3% | Above this a long overlap exposes both tempos. |
| `bpm_delta_max_beatmatch` | 8% | 3–8% | Short overlap on a beat only. |
| `crossfade_length` | 1.5 s | 1.0–3.0 s | Long enough to be a blend, short enough not to be a mush. Matched-tempo only. |
| `beatmatch_overlap` | 0.5 s | 0.2–1.0 s | For 3–8% deltas. |
| `riser_length` | 2.0 s | 1.0–3.0 s | The bridge. Its **peak resolves on the new track's first downbeat**, not before it. |
| `gap_before_new_track` | 0 s | 0–0.4 s | A short gap after a riser is legitimate; a gap in a crossfade is a mistake. |
| `warmup_trim` | measured | 0–8 s | `data-media-start` on the incoming track, set to its first main beat. The source's own instruction. |
| `outgoing_stop_point` | on a waveform peak | — | Stop the old track on a transient so forward masking hides the truncation ([[sfx-transient-masked-outpoint]]). |
| `similar_candidates` | 20 | 10–40 | Pull a wide set from Find Similar, then filter — most of it will be the wrong tempo. |
| `bpm_filter_window` | ±6 BPM | ±3 to ±10 BPM | Re-applied over the similar set. **This is the step the transcript omits.** |
| `key_match` | optional | — | `filter.musicalKeys` exists; the API does **not** return a track's key, so key matching is a filter-only operation and cannot be verified from a result. Treat it as a nice-to-have, not a gate. |
| `bed_level` | 0.056 (≈−25 dB) | −25 to −20 dB (−30 for dense guitars) | Both tracks at the same level across the handover, or the seam is a level change as well as a track change. |
| `carve` | yes, on both | — | Both beds carve against the `voiceover` group at strength 0.25. |

## Reproduction prompt

```
Change the music track at the section boundary {{BOUNDARY}} (seconds).

1. DECIDE WHETHER THE MOOD CHANGED. Read the vibe brief for the outgoing and
   incoming sections.
   - SAME MOOD -> continue at step 2 (Find Similar).
   - DIFFERENT MOOD -> stop. Do NOT try to make this seam smooth. Use the
     riser bridge: stop track A on a waveform peak, place a 2 s riser whose
     peak resolves on track B's first downbeat, start track B there.
2. GENERATE CANDIDATES with Find Similar, seeded on the OUTGOING track's id.
   Pull 20. Do not take the first result.
3. FILTER THE CANDIDATES BY BPM YOURSELF. This is the step the technique is
   usually taught without. Find Similar matches mood and instrumentation, NOT
   tempo - a 110 BPM seed returns candidates from 89 to 148 BPM. Keep only
   candidates within +/-6 BPM of the outgoing track. If none survive, either
   re-run Find Similar on a different seed, or fall back to a filtered
   SearchRecordings using the outgoing track's mood slugs plus a BPM range.
4. CHECK THE DELTA and pick the handover:
     delta = |bpm_B - bpm_A| / bpm_A
     delta <= 3%  -> crossfade, 1.5 s overlap
     3% < delta <= 8% -> beat-match, 0.5 s overlap, landing on a beat
     delta > 8%  -> riser bridge or a hard change on a beat. No overlap.
5. TRIM THE WARM-UP off the incoming track. Find its first main beat and set
   data-media-start to that time. Almost every production track opens with
   2-8 s of intro, and starting a section on a warm-up wastes the boundary.
6. STOP THE OUTGOING TRACK ON A PEAK, not in a trough - a transient masks the
   truncation for about 50-200 ms afterwards, which covers a 2-6 frame ramp.
7. AUTHOR BOTH BEDS at the same level (data-volume 0.056), overlapping by the
   chosen crossfade length, on DIFFERENT track indices, each with a volume
   automation lane: A ramps 1->0 across the overlap, B ramps 0->1. Include an
   explicit t:0 point on both.
8. CARVE BOTH against the voiceover group at strength 0.25.

ACCEPTANCE TEST: play from 8 s before {{BOUNDARY}} to 8 s after, with the
dialogue muted. You must not be able to name the frame the track changed. Then
un-mute the dialogue and listen again: the voice must be equally intelligible
either side, which means both beds are carved and at the same level. Finally,
tap along across the boundary - if your tapping has to reset, the BPM delta is
above 8% and this should have been a riser bridge.
```

## Execution spec

**Epidemic Sound — the measured behaviour, and the two-step that fixes it.**
```
# 1. the seed: whatever is playing in the outgoing section
SearchRecordings { query:{term:"uplifting corporate"},
                   filter:{ bpm:{min:100,max:120}, vocals:false },
                   sort:{by:POPULARITY,order:DESCENDING}, first:10 }
#    -> returns id, title, bpm, tags[] {displayName, dimension.name}, stems[], credits[]

# 2. Find Similar - a CANDIDATE GENERATOR, not a matched-tempo source
SearchSimilarToRecording { id:<outgoing uuid>, first:20 }
#    MEASURED 2026-08-28, seed = 110 BPM instrumental corporate:
#    returned 125, 103, 101, 136, 89, 148, 140, 127, 120, 104 BPM.
#    Mood/genre tags DID carry (hopeful, happy, restless, dreamy, corporate, pop).
#    Only 2 of 10 within +/-10 BPM. So: read node.bpm on every candidate and
#    discard anything outside +/-6 BPM of the seed. Do this in your own code -
#    SearchSimilarToRecording takes no filter argument at all.

# 3. the fallback when no candidate survives: rebuild the seed as a filter
SearchRecordings { filter:{ bpm:{min:104,max:116}, vocals:false,
                            moodSlugs:{matchType:ANY, values:["hopeful","happy"]},
                            taxonomySlugs:{matchType:ANY, values:["corporate"]},
                            featuredInstrumentSlugs:{matchType:ANY, values:["electronic-drums"]} },
                   sort:{by:POPULARITY,order:DESCENDING}, first:30 }

# 4. matching a temp track you cannot license
SearchExternalReferences  # resolve the Spotify track to an id
SearchRecordings { query:{ externalID:{ type: SPOTIFY_TRACK, id:"<spotify id>" } }, first:20 }

DownloadRecording { id:<uuid>, options:{ fileType: WAV } }
```
Three further facts from the live schema that change what is possible:
- **`Recording.bpm` is returned on every node**, so the BPM filter step costs nothing — there is no reason to skip it.
- **`filter.musicalKeys` exists** (slugs like `c-minor`) but **no key field is returned**, so you can *constrain* key but never *read* it. Key matching is therefore a blind filter: usable to narrow a candidate set when you already know the outgoing track's key from elsewhere, useless as a verification step. Do not write a spec that checks key against a result.
- **`Recording.stems` returns DRUMS / BASS / MELODY / INSTRUMENTS / VOCALS / CLEAN_VOCALS.** This is the best tool in the whole note for a difficult handover: drop the outgoing track to its `INSTRUMENTS` or `MELODY` stem for the last few seconds so only the tonal layer crosses the seam, and the tempo conflict — which lives almost entirely in the drums — simply stops existing ([[sfx-music-stem-layering]]).
- The transcript's *"go to Create Version and you can pull out an edited track by adding or removing sections"* corresponds to the `EditRecording` → `PollEditRecordingJob` → `DownloadRecordingEdit` tool chain. That is the right route when a track is the right vibe but the wrong length or has the wrong intro. Their exact argument shapes are not documented in this note — load the tool schemas before writing a spec against them rather than guessing.

**HyperFrames — the crossfade, and why relative timing is a trap here.** Two beds, overlapping, on different track indices, each with a `volume` lane:
```html
<!-- Track A: ends at 214.0 s, ramping out across the last 1.5 s -->
<audio id="bed-sec-4" src=".media/audio/bgm/moving-up.wav"
       data-audio-group="music"
       data-start="126.0" data-duration="88.0" data-media-start="4.2"
       data-track-index="11" data-volume="0.056"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.0,&quot;v&quot;:1},{&quot;t&quot;:86.5,&quot;v&quot;:1},{&quot;t&quot;:88.0,&quot;v&quot;:0}]}]}"></audio>

<!-- Track B: starts 1.5 s early to create the overlap; warm-up trimmed -->
<audio id="bed-sec-5" src=".media/audio/bgm/a-step-ahead.wav"
       data-audio-group="music"
       data-start="212.5" data-duration="96.0"
       data-media-start="6.8"          <!-- first main beat; the warm-up is skipped -->
       data-track-index="10" data-volume="0.056"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.5,&quot;v&quot;:1},{&quot;t&quot;:94.5,&quot;v&quot;:1},{&quot;t&quot;:96.0,&quot;v&quot;:0}]}]}"></audio>
```
then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`, which writes the `fromCarve` peaking nodes, the gain stage and its envelope onto both beds.

Contract points that decide whether this runs:
- **The `t: 0` point is mandatory.** A lane *"holds its first value backwards to the start of its clip and its last value forward to the end"* — so a bed without an opening point starts already at its first authored value, and a crossfade authored without it opens at zero and never comes up.
- **`data-media-start` is how the warm-up gets trimmed** — in-composition, no new file. *"Only cut a physical file when exporting/assembling outside the composition."*
- **Never GSAP-tween `volume` alongside a lane**: `audio_volume_double_automation` — the lane wins and the tween is silently ignored. And a `volume` tween is **absolute**, replacing `data-volume` entirely (`audio_volume_tween_overrides_gain`).
- **The two beds must not share a `data-track-index`** while overlapping, or `duplicate_audio_track` fires. Hence 11 and 10.
- **`data-fx-carve` is clip-only** — never on an `<hf-audio-group>` (`audio_group_carve_attr`) — its `sources` must name a **group**, not a list of clip ids (`audio_carve_ungrouped_sources`), and the settings live on the **bed**, never on a voice: *"A voice carved against itself is a bug."* Keep the `voiceover` group voices only.
- **Relative timing is exactly the wrong tool for a crossfade.** `data-start="bed-sec-4 - 1.5"` expresses the overlap, but **spaces around the operator are required**, an unresolved reference silently resolves to `0`, and *"if the target has no resolvable duration, the reference lands on the target's START, not its end."* A bed whose `data-duration` you later change moves the seam invisibly. Author absolute seconds for music boundaries.
- **A carve writes a gain stage with a slow release**, so both beds' effective level moves under speech — which is a reason to keep both beds' `data-volume` identical, or the seam becomes a level change too.

**ffmpeg — measuring the boundary and the warm-up.**
```bash
# find the incoming track's first main beat: low band only, per-frame peaks
ffmpeg -i b.wav -ar 48000 -af "lowpass=f=160,asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null | head -60
# a baked crossfade, only for an asset leaving the pipeline
ffmpeg -i a.wav -i b.wav -filter_complex "[0][1]acrossfade=d=1.5:c1=tri:c2=tri" out.wav
```
`acrossfade` is the bake; inside the composition the two `volume` lanes are the crossfade, and the contract's rule is that gain and ducking are **declared, not baked** — *"Bake only for assets leaving the hyperframes pipeline."*

**Remotion:** two `<Audio>` in overlapping `<Sequence>`s with `volume` as a function of frame. Concept only; no Remotion runtime here.

## Pairs with
[[sfx-track-change-at-section-boundary]] · [[sfx-beat-aligned-handover]] · [[sfx-music-drop-on-structure-turn]] · [[sfx-music-hard-stop]] · [[sfx-transient-masked-outpoint]] · [[sfx-riser-anticipation-build]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-bpm-filter-first]] · [[sfx-vibe-brief]] · [[sfx-instrument-filter-search]] · [[sfx-music-stem-layering]] · [[sfx-music-rest-windows]] · [[sfx-beat-forward-bed-under-voice]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-music-audition-against-picture]] · [[pace-bpm-matched-music-selection]] · [[struct-music-arc-to-narrative-arc]]

## Failure modes
- **Trusting Find Similar to match tempo.** Measured: a 110 BPM seed returns 89–148 BPM. A 1.5 s crossfade between 110 and 148 BPM is two songs at once. Fix: read `node.bpm` on every candidate and filter to ±6 BPM. This is the whole point of the note.
- **Taking the first similar result.** It is ranked by similarity of vibe, and vibe is the half you were already going to get. Fix: pull 20, filter, then choose.
- **Crossfading across a mood change.** Blurs a boundary the video wanted to *feel*. Fix: riser bridge, or a hard change on a beat.
- **A long crossfade on a large BPM delta.** The longer the overlap, the more of the conflict you hear. Fix: if Δ > 8%, no overlap at all.
- **Starting the new track on its warm-up.** The section opens on a thin pad and the boundary lands on nothing. Fix: `data-media-start` at the first main beat.
- **Stopping the outgoing track in a trough.** Heard as sudden. Fix: stop on a transient; forward masking covers a 2–6 frame ramp.
- **Different levels either side.** The seam becomes a volume change as well as a track change, which is more audible than either alone. Fix: identical `data-volume`, both carved at the same strength.
- **Omitting the `t: 0` lane point.** The bed opens at its first authored value with no fade; on a crossfade this means it never fades in at all. Fix: explicit `t: 0`.
- **Relative timing on a music boundary.** One later `data-duration` edit moves the seam silently, and every parse failure resolves to `0`. Fix: absolute seconds.
- **Carving the voice instead of the bed.** *"A voice carved against itself is a bug."* Fix: `data-fx-carve` on the bed, `sources: ["voiceover"]`.
- **Known gap:** the ±3% / ±8% BPM thresholds are DJ beat-matching practice, not measurements from a cited study, and the crossfade lengths are craft conventions. The Find Similar behaviour, by contrast, is **measured here** and is the note's load-bearing fact. Re-measure it if the catalogue's similarity model changes: seed one known-BPM track, read the returned `bpm` values, and check how many land inside your window before trusting the function.
