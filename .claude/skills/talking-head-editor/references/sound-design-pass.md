---
name: sound-design-pass
description: The sound design pass for vertical talking-head video. Runs after cuts AND motion are locked, entirely in OUTPUT timecode. Covers the dialogue gate, the talking-head layer subset, the three-style parallelisation and its merge collision checks, Epidemic six-facet query construction, fetch-before-build, the verified ffmpeg mix graph, and pre-render verification.
type: reference
---

# Sound design pass — vertical talking head

Implements **Mode B** of `skills/SOUND-DESIGN/SKILL.md` for the 9:16 talking-head case and fills `_templates/design-sound.md`. The router owns the frameworks (three styles, five layers); this file owns the procedure for one format and does not restate them.

**[verified]** means the command was run in this container on real media, ffmpeg 6.1.1-3ubuntu5. Everything else is quoted from a rule note's Parameters table or marked unconfirmed.

## 1. Where this stage sits

```
STAGE 1 cuts   -> design-cuts.md   [LOCK]  SOURCE timecode
STAGE 2 motion -> design-motion.md [LOCK]  OUTPUT timecode
STAGE 3 SOUND  -> design-sound.md          OUTPUT timecode   <- here
STAGE 4 fetch -> assemble -> mix -> verify
```

**Cuts must be locked** because OUTPUT timecode does not exist until the keep list does (`timebase.md` §2). Every timecode in `design-sound.md` is an OUTPUT frame. A cue written against a source timestamp is not slightly off — it is a number with no referent, and the error grows toward the tail (measured: 1.4 s at 00:20, 3.2 s at 04:12 on a three-removal edit). If the EDL changes after this pass, push each cue through `out_to_src` on the old map then `src_to_out` on the new one; never hand-patch an offset.

**Motion must be locked** because `sfx/motion` rows are timed off motion events. In this format the motion spec *is* the effect spotting list — caption entrances, graphic reveals, punch-ins and transitions are nearly all the on-screen movement there is.

Read: `design-cuts.md` (EDL + `fps` header), `design-motion.md` (every event and its `Paired sound` field), `PROFILE.md` (style balance, density, levels, palette anchor UUIDs). Write only `design/design-sound.md`.

Frame arithmetic uses the EDL's `fps` header exactly as written — `30000/1001` is not 30. Figures below are at 30 fps with milliseconds beside them. Convert with `round(s * fps_num / fps_den)`; never `int()`.

## 2. The talking-head layer subset

Do not build five layers. `sfx-layer-subset-by-format` gives this format's configuration: **layers 1, 4 and 5 plus an ambience floor.** Foley is absent — nothing on screen touches anything.

| Layer | Present | What it is here | Rel. dialogue | linear |
|---|---|---|---|---|
| 1 `dialogue` | always | the recorded voice, already on the timeline | `0` | 1.0 |
| 2 `ambience` | floor only | one continuous bed hiding jump-cut seams (§4.2) | −28 dB | 0.04 |
| 3 `foley` | **no** | drop it; the condition is absent | — | — |
| 4 `sfx` | always | caption entrances, graphic reveals, transitions | −13 dB | 0.224 |
| 5 `music` | usually | one instrumental bed, ducked | −22 dB | 0.079 |

Hierarchy per `sfx-layer-volume-targets`: dialogue **0 to −3 dB**, SFX **−12 to −15**, music **−20 to −25**. The dialogue figure is on screen twice in this user's reference set — `DIALOGUES / 0 to -3dB` in `sfx kt 2` and `Vocals Vol / −3 to 0dB` in `editing kt 3` — plus the spoken line. It is established; stop hedging it. `data-volume` is a **linear multiplier** `10^(dB/20)`; never author dB into it.

## 3. Start with dialogue, not with effects

Layer 1 is a **gate**, not a step. Run it once per voice source before writing one effect row. If it fails, the correct output of this pass is a re-record recommendation.

```bash
ffmpeg -hide_banner -i vox_raw.wav -af silencedetect=noise=-35dB:d=0.4 -f null -      # gap windows
ffmpeg -hide_banner -ss <t> -t 0.4 -i vox_raw.wav -af astats -f null - 2>&1 | grep "RMS level dB"
```

Pass: noise floor ≤ −60 dBFS in ≥400 ms gaps (fail above −45); SNR ≥ 45 dB (fail below 30); peak headroom −9 dBFS before treatment; **zero** clipped samples on a load-bearing syllable.

Then normalise the voice stem to the anchor, or no relative level means anything — a raw Epidemic download and a raw voice recording do not arrive at the same reference level.

```bash
ffmpeg -hide_banner -i vox_raw.wav -af loudnorm=I=-16:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -v error -y -i vox_raw.wav -af "highpass=f=80:poles=2,loudnorm=I=-16:TP=-1.5:LRA=11:\
measured_I=<input_i>:measured_TP=<input_tp>:measured_LRA=<input_lra>:\
measured_thresh=<input_thresh>:offset=<target_offset>:linear=true" -ar 48000 vox.wav
```

**Record the resulting speech RMS in dBFS in the design doc.** §8.2 needs it to set the ducking threshold and it cannot be guessed.

## 4. What a real person on camera in 9:16 changes

### 4.1 Diegetic sound is mostly already in the footage

The faceless-video reflex is to *add* a diegetic layer. Here the camera already recorded one. The job is usually to **preserve or clean** it. Laying a fetched room tone over real room tone is a beginner error: two uncorrelated floors sum into a wider, noisier, obviously-fake floor with the real one still audible underneath.

**Add** only when: the action is visible and its sound was not captured (an off-mic buzz, a keyboard the lavalier missed); a cutaway has no usable audio of its own; or pause removal cut a real sound in half. **Do not add** when: the take already has usable room tone (the fix for an uneven floor is §4.2, not a second floor); the sound would need pushing to −18 dB to be heard, at which point it is not diegetic; or the picture shows no place at all. A diegetic row saying "add room tone" over footage that has room tone is rejected at merge.

### 4.2 Jump cuts step the noise floor — the ambience bridge

This matters more here than anywhere else in the vault. A subtractive edit removes dead air, filler and retakes, and **every removal cuts the noise floor as well as the words.** Two takes minutes apart do not share a floor. The result is a step at every splice — the pumping that makes a clean edit sound amateur. Measured on two takes with deliberately different floors: **[verified]**

| Mix | floor before splice | after | step |
|---|---|---|---|
| dialogue alone | −50.90 dBFS | −61.87 dBFS | **10.97 dB** |
| + continuous bed at −6 dB rel. the louder floor | −46.50 | −48.61 | **2.11 dB** |

Pass criterion (`sfx-ambience-bridge-across-cut`): inter-word floor either side of every cut differs by **≤ 2 dB**; **≥ 4 dB** means the ambience was cut with the picture. One bed spans the whole cut, never one per shot:

```bash
# a bed long enough that no identifiable event repeats (source 90-180 s)
ffmpeg -v error -y -stream_loop 8 -i roomtone20s.wav \
  -af "afade=t=in:st=0:d=0.5:curve=qsin" -t 180 bed180.wav          # -> 180.000000 s [verified]
# lay it under the assembled dialogue, high-passed, at -28 dB
ffmpeg -v error -y -i cut_dialogue.wav -i bed180.wav -filter_complex \
 "[1]atrim=0:<out_dur>,asetpts=PTS-STARTPTS,highpass=f=40:poles=2,volume=-28dB[b];\
  [0][b]amix=inputs=2:normalize=0:duration=first[o]" -map "[o]" dialogue_bedded.wav
```

Three non-negotiables. **`normalize=0` on every `amix`** — the default divides by input count and silently halves the dialogue. **`atrim` always paired with `asetpts=PTS-STARTPTS`** or the bed starts late. **Never duck the ambience** — it already lives 28 dB down, and ducking makes the room breathe with the speech, which is far more noticeable than the bed.

Where one splice is worse than the bed can hide, mask the join: an out-point **0 to +3 f (0–100 ms) after a transient** sits inside the forward-masking shadow. Crossfade seams within one space at **1 f**, between two genuinely different rooms at **18 f**. A 1.5 s blend between two obviously different rooms sounds like a mistake in slow motion.

### 4.3 Motion effects attach to captions and graphics

The `sfx/motion` candidate list comes almost entirely from `design-motion.md`. Every motion row with a non-empty `Paired sound` **must** produce a row here — a required gate (§9 V4).

Placement follows `sfx-av-sync-binding-window`, and the asymmetry is the point:

| offset (sound onset − visual onset) | reads as | verdict |
|---|---|---|
| ≤ −6 f (−200 ms) | anticipation / build | deliberate — a riser or long whoosh |
| −5 to −2 f | wrong, unlocatable | **never author here** |
| −1 to +2 f | locked | **the target**; default `+1 f` |
| +3 f | slightly loose | acceptable |
| ≥ +6 f | a separate event | broken |

The router's "motion sound leads picture" applies to the *anticipation* device only, leading by ≥12 f. A 2–5 frame lead is the uncanny band. A whole render sitting at +4 f is an encode offset — fix it globally with `itsoffset`, never per event. And check the file, not just the placement: more than **2 f** between a file's start and its peak measures on time and sounds late. Trim it.

### 4.4 Vertical, mobile, sound-off

- **Below ~200 Hz is not reproduced on a phone speaker.** Sub layers, bass drops and 40–80 Hz weight are simply absent for most of the audience. Measured: a finished master through a 200 Hz 2-pole high-pass, 12 kHz low-pass and mono sum lost **3.0 dB RMS** on bass-heavy material. **[verified]** Put the audible part of every effect in **600 Hz–5 kHz**; treat sub content as a headphone bonus, never the carrier.
- **Phone speakers are mono.** A wide stereo bed can partially cancel. Tolerance: mono-sum RMS drop **≤ 3 dB**.
- **2–5 kHz is reserved for speech.** Count effects in the presence band *while the presenter speaks*; in a competent mix that count is near zero. Move effects to Weight (80–250 Hz) or Air (10–20 kHz) with a filter rather than lowering them.
- **Sound must not be load-bearing for comprehension.** Many viewers watch muted. No information may exist only in audio; every sound amplifies something already visible or already said — the aesthetic layer's licence stated as a constraint: *invented sound may amplify, never inform*. The budget buys retention and feel, not exposition, and captions are the fallback the design assumes.
- **Platform loudness re-levels the whole upload**, so mixing hot wins nothing and what survives normalisation is the **ratio between layers** (§2, §8.3).

## 5. Parallelisation: three style agents, one serial merge

Diegetic, motion and aesthetic are **independent layers** — they share no state, read the same locked inputs, and write disjoint row sets. Run them as three concurrent subagents. Music is **not** a fourth agent: it is one global decision (bed, arc, edit points, rest windows) that constrains all three, so choose it serially first and hand it to each as a given.

**Voiceover generation does not belong in this pass.** The dialogue is recorded and is the floor. `GenerateVoiceover` has no role in a talking-head edit; a pass reaching for it has misread the format.

### 5.1 What each agent receives

Identical except the last row: `design-cuts.md` (locked, with `fps`); `design-motion.md` (locked, every event with its `Paired sound` field — the motion agent's candidate list, and what the other two must avoid colliding with); `PROFILE.md` (style balance, density, levels, palette anchor UUIDs); the chosen bed (id, BPM, energy arc, edit points, rest windows) so nothing lands on the bed's own kick or inside a rest window; the dialogue speech RMS from §3; and **only its own style's rule notes**, which is what keeps it inside its classification instead of spraying whooshes.

### 5.2 What each agent returns — rows, never prose

The failure mode is the merge, not the analysis; prose cannot be merged. Each agent returns a JSON row list plus one `notes` string that is never load-bearing.

```json
{ "style": "sfx/motion", "fps": "30000/1001",
  "rows": [
    { "id": "M3", "out_frame": 1673, "out_tc": "00:00:55.786",
      "event_ref": "design-motion.md#M7", "rule_id": "sfx-appearance-transient",
      "sound": "short whoosh, upward, light", "layer": "layer/sfx",
      "offset_frames": 1, "gain_db": -13, "duration_ms": 420,
      "dominant_band": "air", "duck": false, "anchor_uuid": null,
      "query": { "tool": "SearchSoundEffects",
                 "query": {"term": "whoosh transition light short"},
                 "filter": {"duration": {"max": 700}} },
      "justification": "caption line 4 entrance, 9f slide-up" } ],
  "notes": "" }
```

All fields mandatory. `out_frame` is an integer OUTPUT frame and the only authoritative timing field; `out_tc` is display and never parsed. `offset_frames` is signed and must sit inside §4.3's window. `gain_db` is relative to dialogue at 0. `dominant_band` is one of `rumble weight mud middle presence edge air` — the merge needs it. `justification` names what the sound is sounding; **a row that cannot name it is rejected.** A row with `anchor_uuid` set is a similarity fetch (§6.3) and does not re-litigate the palette.

### 5.3 The merge — run it yourself, serially, never delegate it

Concatenate, sort by `out_frame`, assign final ids, then run four checks **no single agent could have run**, because each needs the other styles' rows.

**C1 — Collision: two effects closer than 6 frames (200 ms @30).** The threshold is psychoacoustic. Forward masking is strongest under ~50 ms and still measurable to ~200 ms; backward masking is gone by ~100 ms. So two onsets inside **2 f (67 ms)** largely mask each other and *are* one event whether you designed them that way or not, and **6 f (200 ms)** is where two effects become cleanly separable. Below 6 f you pay for two files and hear one. (`sfx-placement-discipline`: `min_spacing = 6 f`, range 6–15 f.) At other rates: 200 ms @30 · 240 ms @25 · 100 ms @60 · 200.2 ms @29.97 — compute in milliseconds from the EDL's fps, compare in frames. A reverbed effect occupies its tail: a 0.4 s effect with a 0.6 s tail is a 1.0 s occupancy.

Resolve in order: (a) if the rows describe one moment, **merge** them into a single layered event with one `out_frame`; (b) **move** the less-justified one and re-check §4.3's window on it; (c) if neither can move, **split the bands** — `highpass` one to Air, `lowpass` the other to Weight. Two overlapping effects sharing a dominant band is forbidden regardless of spacing.

**C2 — Density against the profile**, pooled across styles:

| Gate | Default | Source |
|---|---|---|
| effects per minute | profile target; 6/min if absent, ceiling 15/min | `sfx-density-fatigue-audit` |
| max distinct effects in any 1.0 s window | 3 | `sfx-placement-discipline` |
| median inter-onset gap | ≥ 4 s | density audit |
| share of gaps under 1 s | ≤ 10 % | density audit |
| effect-free rest window | ≥ 1 of 8 s per minute | density audit |
| same file reused | ≤ 3 times per video | density audit |

Diegetic rows do **not** count against the census — a sound that exists in the world of the shot is a requirement, not an accent. Prune motion first, aesthetic second, never diegetic.

**C3 — Style balance.** Count rows per style, compute shares, compare to `PROFILE.md`. Tolerance: **each share within ±8 percentage points of target, and the rank order of the three shares identical to the profile's.** Eight points is 3–5 effects on a 40-row design — slack enough for rounding on a short video, tight enough that the identity survives. Diagnostics: motion-heavy with no aesthetic reads flat; aesthetic-heavy with no diegetic reads cheap; motion effects on things that are not moving read cluttered. **Fix by adding to the starved style, not deleting from the dominant one**, unless C2 also fails.

**C4 — Motion coverage.** Every `design-motion.md` row with a non-empty `Paired sound` has a row here. Report `coverage_ratio` = sounded ÷ total motion events; the band is 0.75–0.95. 1.0 across hundreds of events is overload, not diligence.

**Epidemic fetches parallelise freely** once the merged fetch list exists — independent, network-bound, idempotent. Design does not parallelise past the merge; fetching does.

## 6. Epidemic query construction

### 6.1 Two catalogues, two filter surfaces

Picking the wrong one is the commonest way a fetch recipe fails.

|  | Sound effects | Recordings (music) |
|---|---|---|
| search / download | `SearchSoundEffects` / `DownloadSoundEffect` | `SearchRecordings` / `DownloadRecording` |
| query forms | `query.term` only | exactly one of `term`, `topic`, `externalID` |
| filters | `tagSlugs`, `duration` (ms), `soundEffectIDs` | `bpm`, `duration`, `moodSlugs`, `taxonomySlugs`, `musicalKeys`, `vocals`, `featuredInstrumentSlugs`, `artistSlugs`, `tagSlugs`, `recordingIDs` |
| download options | `fileType` **required** | `fileType` **and** `stemType` **both required** |

**The six UI facets — `Moods | Genres | Duration | BPM | Vocals | Key` — are the recordings surface only.** Sound effects have no mood, BPM, vocals or key; `duration` in milliseconds carries all the filtering there. A row filtering a whoosh by mood is a spec that cannot execute. Facet → parameter: Moods `moodSlugs`, Genres `taxonomySlugs`, Duration `duration` (**ms** — `60000`, not `60`), BPM `bpm` (ints), Vocals `vocals` (**boolean**), Key `musicalKeys` (**plain array**, not a matchType object). `matchType` is `ALL | ANY | NOT_ANY`; `NOT_ANY` is the honest way to write "not that". A query is finished when `meta.total` lands between about **20 and 300** — above that you are browsing, below ~10 you have over-constrained (loosen Key or Genres first).

### 6.2 Five worked queries

**1 — transition whoosh.** Sound-effects surface; no facets apply.
```
SearchSoundEffects { query:{term:"whoosh transition light short"}, filter:{duration:{max:1500}},
                     sort:{by:RELEVANCE,order:DESCENDING}, first:20 }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
`duration.max` does the work a mood filter cannot: it strips the long ambience beds a bare "whoosh" returns. WAV whenever the file will be pitched, trimmed or filtered.

**2 — tension riser.** On both surfaces, and they are different tools.
```
SearchSoundEffects { query:{term:"riser tension build"}, filter:{duration:{min:2000,max:8000}} }
SearchRecordings   { query:{term:"tension"},
                     filter:{ moodSlugs:{matchType:ANY,values:["suspense","dark","tense"]},
                              vocals:false, duration:{min:10000,max:60000} } }
```
A riser is anchored by its **end**: back-time it so the peak lands on the reveal frame, leading ≥12 f to clear the uncanny band.

**3 — soft UI pop for a caption entrance.**
```
SearchSoundEffects { query:{term:"ui pop soft click subtle"}, filter:{duration:{max:400}},
                     sort:{by:POPULARITY,order:DESCENDING}, first:20 }
```
Under 400 ms because a caption entrance is 8–14 f. Put the band in the term — "soft", "subtle", "high" — rather than fetching full-range and filtering down. This is the highest-count row in a talking-head design and the one most at risk of C2 and of the 3-uses-per-file limit.

**4 — instrumental bed at a target BPM.** The canonical recordings fetch.
```
SearchRecordings { query:{term:"chill lo-fi"},
                   filter:{ bpm:{min:86,max:96},        # target 91, +-5
                            vocals:false,               # ALWAYS false under narration
                            duration:{min:60000},
                            taxonomySlugs:{matchType:ANY,values:["lo-fi","chill"]} },
                   sort:{by:POPULARITY,order:DESCENDING}, first:20 }
DownloadRecording { id:<uuid>, options:{ fileType: WAV, stemType: FULL } }   # stemType REQUIRED
```
`vocals:false` is not a preference under a talking head — a vocal bed fights the presenter's own voice in the same band. Derive BPM from delivery pace; creator default band 100–120. Read `bpm` off each node: it is an integer on the recording and is ground truth for any beat grid.

**5 — room-tone bridge bed.**
```
SearchSoundEffects { query:{term:"room tone quiet interior neutral"}, filter:{duration:{min:60000}} }
```
`duration.min` is the whole filter: a 3-second one-shot is useless for §4.2 and a loop under 90 s repeats audibly under a 3-minute cut. If nothing long enough exists, build it with `-stream_loop`.

### 6.3 The identity tool, and the async edit pipeline

**`SearchSimilarToSoundEffect(id, first?, after?)` is how a palette stays coherent.** Two free-text searches for "whoosh transition" twenty minutes apart return two different neighbourhoods of a very large catalogue, and a video assembled from them sounds assembled. Similarity returns the same neighbourhood deliberately. Workflow: `PROFILE.md` stores **one anchor UUID** per palette family; design rows say *"whoosh, similar-to `<anchor>`"*; the fetch step makes **one** call with `first` large enough to cover the video and assigns from that pool. Limit: it takes a catalogue UUID, so there is no "similar to this local file". `SearchSimilarToRecording` does the same for beds.

**`EditRecording` returns a job, not audio.** Three calls; the download needs *both* ids.
```
1. EditRecording(id:<recordingId>, input:{targetDurationMs, downloadAudioFormat, ...})
        -> RecordingEditJob { id:<jobId>, status: PENDING }
2. PollEditRecordingJob(id:<jobId>)          # the JOB id, not the recording id
        -> { status: PENDING|IN_PROGRESS|COMPLETED|FAILED, edit:{ id, durationMs, fullMixPreviewUrl } }
3. DownloadRecordingEdit(input:{ jobId, editId })   -> { assetUrl }
```
`targetDurationMs` and `downloadAudioFormat` are the only required input fields; `targetDurationMs` caps at **300000 ms**. `forceDuration:true` when the bed sits under a locked section; `loopable:true` when it repeats; `skipStems:true` for speed. `requiredRegionsAtOffsets:[{startMs,endMs,offsetMsInEdit}]` pins a region of the source to an exact offset in the output — how a musical drop is aligned to a picture event without recutting picture. **Check whether you need an edit at all:** in-composition trimming is free; use `EditRecording` when the bed must *end musically*, not merely be shorter.

### 6.4 What is not confirmed — do not guess past this line

- **Slug vocabularies are not enumerable on this surface.** `moodSlugs`, `taxonomySlugs`, `tagSlugs`, `musicalKeys`, `featuredInstrumentSlugs`, `artistSlugs` all take slugs and there is no listing endpoint; the schema gives examples only. **Discover then record:** run the query with `term` alone, read back `tags[].displayName` and `tags[].dimension.name`, build the filter from that, and write the working slugs into the rule note. Every slug in §6.2 is illustrative.
- **Recording tags carry no `slug`** — only `displayName` and `dimension.name`. Lower-casing and hyphenating is a guess. Sound-effect tags *do* carry `slug`, so `tagSlugs` round-trips there only.
- **`query.topic`** exists on `SearchRecordings` with no description beyond "specify exactly one", and **`first` has no stated default or maximum.**
- **Whether `assetUrl` expires is not stated**, and a sibling field elsewhere on this API is named `signedUrl`. **Store UUIDs in the design document, never URLs**; re-resolve at fetch time.
- **`PollEditRecordingJob`'s completed payload.** `RecordingEditJob.edit` is present but deprecated in favour of an `edits` field that is **not exposed** here. Inspect the response before parsing it.
- **Poll cadence and latency** are undocumented for both async pipelines. Any interval is a chosen value, and the loop must handle `FAILED`.
- **Egress.** `audiocdn.epidemicsound.com` is recorded as blocked by this project's allowlist (403 on CONNECT). A tool returning a URL is not proof the URL is retrievable from here. **Test the fetch leg once before a build depends on it**; treat failure as an allowlist question, not a bad id.
- **Whether `EditRecording` preserves source BPM** is not stated — relevant if cuts are beat-locked.

## 7. Fetch before build

**Every asset resolves to a local file before any mix work starts.** A missing asset found mid-render is a wasted render. The gate runs after the merge, so the list is already pruned — rejecting a candidate is free, un-fetching one is not.

| # | Role | Tool | Query / anchor | Filters | Cand. | Chosen id | Local path | dur ms | ☐ |
|---|---|---|---|---|---|---|---|---|---|
| S1 | caption pop | `SearchSoundEffects` | `ui pop soft click subtle` | `duration.max 400` | 3 | `<uuid>` | `assets/sfx/pop-a.wav` | 180 | ☐ |
| S7 | transition whoosh | `SearchSimilarToSoundEffect` | anchor `<uuid>` | — | 3 | `<uuid>` | `assets/sfx/whoosh-c.wav` | 620 | ☐ |
| B1 | bed | `SearchRecordings` | `chill lo-fi` | `bpm 86-96, vocals false, dur≥60000` | 3 | `<uuid>` | `assets/music/bed.wav` | 184000 | ☐ |
| A1 | room tone | `SearchSoundEffects` | `room tone quiet interior neutral` | `duration.min 60000` | 3 | `<uuid>` | `assets/amb/tone.wav` | 96000 | ☐ |

- **Candidates is 3, not 1.** Effects are cheap to audition and expensive to guess at. Pull three, hold the picture, swap the sound, and commit only after A/B **against the locked cut at final level** — never in isolation, never at a comfortable monitoring volume.
- **`dur ms` is read back from the returned asset**, not from what you asked for. Without `forceDuration:true`, `targetDurationMs` is a target.
- **Status flips to ☑ only when the file exists and probes clean:**

```bash
while read -r p; do ffprobe -v error -show_entries format=duration -of default=nk=1:nw=1 "$p" \
  >/dev/null && echo "OK   $p" || echo "MISS $p"; done < fetchlist.txt
```

## 8. The mix

### 8.1 The filter graph

Ran end to end in this container. **[verified]**

```bash
ffmpeg -hide_banner -y \
 -i vox.wav -i bed.wav -i roomtone.wav -i whoosh.wav -i pop.wav -i whoosh.wav \
 -filter_complex "\
[0:a]highpass=f=80:poles=2,volume=0dB,asplit=2[vox][key];\
[2:a]highpass=f=40:poles=2,volume=-28dB,atrim=0:12,asetpts=PTS-STARTPTS[amb];\
[3:a]adelay=1567|1567:all=1,volume=-13dB[e1];\
[4:a]adelay=4300|4300:all=1,volume=-15dB[e2];\
[5:a]adelay=7833|7833:all=1,volume=-13dB[e3];\
[e1][e2][e3]amix=inputs=3:normalize=0:duration=longest[sfxbus];\
[1:a]volume=-22dB[bed];\
[bed][key]sidechaincompress=threshold=0.05:ratio=8:attack=20:release=300:\
makeup=1:detection=rms:link=average[bedduck];\
[vox][bedduck][amb][sfxbus]amix=inputs=4:normalize=0:duration=first[premix];\
[premix]alimiter=limit=0.891:attack=5:release=50:level=disabled[out]" \
 -map "[out]" -c:a pcm_s24le mix_stage1.wav
```

- **`asplit` on the voice** yields the mix path *and* the sidechain key. The key is only listened to.
- **`sidechaincompress` input order is a silent trap.** Input 0 is compressed (the bed); input 1 is the key (the voice). Reversed, it ducks the voice under the music and nothing errors.
- **`adelay=<ms>|<ms>:all=1` places an effect at an OUTPUT timecode.** Verified: `adelay=1567` put the onset at **1.56702 s**. Compute as `round(out_frame * 1000 * fps_den / fps_num)`. Without `all=1` only the channels you enumerate are delayed.
- **`normalize=0` on both `amix` calls** or the mix silently attenuates by the input count.
- **`alimiter` `limit` is linear**: `0.891` = −1 dBFS, `0.944` = −0.5, `0.794` = −2. `level=disabled` or the filter auto-gains up to the ceiling.
- **`loudnorm` goes last** (§8.3) — it normalises what it is handed.

### 8.2 Ducking depth is measured, never assumed

`threshold` is **linear** and gates on the **key**. Copying a threshold from a note without knowing the voice's level produces either no duck or a 20 dB hole, both silently. Measured with the key's speech RMS at **−22.4 dBFS**, bed at −22 dB, `ratio=8:attack=20:release=300`, comparing bed RMS during speech against bed RMS in a gap: **[verified]**

| `threshold` | ≈ dBFS | achieved duck |
|---|---|---|
| 0.5 | −6 | 0 dB (no duck) |
| 0.2 | −14 | 0 dB |
| 0.1 | −20 | 1.3 dB |
| **0.05** | **−26** | **6.3 dB** |
| 0.02 | −34 | 13.3 dB |
| 0.01 | −40 | 18.4 dB |

**Rule: set `threshold` ≈ 4 dB below the measured dialogue speech RMS** — `threshold = 10^((rms_dB − 4)/20)` — which lands near the −4 to −6 dB duck this library wants; then verify and iterate. `attack=20` catches the first syllable, `release=300` returns between phrases without pumping (stay in 200–500 ms), `detection=rms` follows speech energy rather than consonants.

> **`astats` `reset` is a frame count, not seconds.** **[verified]** `-h filter=astats`: *"the number of
> frames over which cumulative stats are calculated before being reset"*, an int. `reset=0.4` truncates
> to `0` = never reset, giving a running cumulative figure that looks like a trace and is not one. Force
> the frame size instead — `n=1600` at 48 kHz is exactly one frame at 30 fps (`n=1920` @25, `n=800` @60):
> ```bash
> ffmpeg -v error -i mix.wav -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
> ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
> ```

### 8.3 Fades, joins, programme loudness

**Write the curve explicitly; the default is a trap.** `afade` and `acrossfade` default to `curve=tri` (linear), which dips at the join on uncorrelated material. Measured on two uncorrelated pink-noise sources at `d=0.4`: **[verified]**

| curve | steady RMS | midpoint | dip |
|---|---|---|---|
| `tri` (default) | −22.86 | −26.83 | **3.97 dB** |
| `qsin` | −22.86 | −23.93 | **1.07 dB** |

Use `qsin` for every join between two unrelated sounds. `acrossfade` overlaps by default so the join **shortens the total**: two 3.0 s files at `d=0.4` gave 5.600 s. **[verified]**

```bash
# click-free edges on every fetched effect: 20 ms head, 50 ms tail, equal-power
ffmpeg -v error -y -i whoosh.wav \
  -af "afade=t=in:st=0:d=0.02:curve=qsin,afade=t=out:st=0.35:d=0.05:curve=qsin" whoosh_f.wav
# ambience seam inside one space: 1 frame at 30 fps
ffmpeg -v error -y -i a.wav -i b.wav \
  -filter_complex "[0][1]acrossfade=d=0.0333:c1=qsin:c2=qsin[o]" -map "[o]" seam.wav
```

**Two-pass `loudnorm`, last in the chain.** Measured: pass 1 reported `input_i -27.17`; pass 2 with those values produced an `ebur128` reading of exactly **I: −14.0 LUFS**. **[verified]**

```bash
ffmpeg -hide_banner -i mix_stage1.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -v error -y -i mix_stage1.wav -af "loudnorm=I=-14:TP=-1.5:LRA=11:\
measured_I=<input_i>:measured_TP=<input_tp>:measured_LRA=<input_lra>:\
measured_thresh=<input_thresh>:offset=<target_offset>:linear=true" -ar 48000 master.wav
ffmpeg -hide_banner -nostats -i master.wav -af ebur128=peak=true -f null - 2>&1 | tail -12
```

**The Instagram target, honestly.** Meta does not publish a loudness figure for Reels and **I could not confirm one.** What is established in this vault and across the sibling platforms — Spotify, YouTube, YouTube Shorts, TikTok — is **−14 LUFS integrated with a −1.5 dBTP ceiling**, and that is the working target. Two things make the uncertainty survivable: normalisation applies one gain change to the whole programme, so the **ratios between layers** (§2) survive whatever number the platform actually uses; and mixing hot to game it wins nothing and costs headroom. Keep `LRA ≤ 9 LU` for talking head. A stated delivery spec wins over this paragraph.

## 9. Verification before render

**V1 — Loudness and true peak.** `ffmpeg -hide_banner -nostats -i master.wav -af ebur128=peak=true -f null - 2>&1 | tail -12`. Pass: `I` −16 to −13 LUFS, `LRA ≤ 9 LU`, true peak ≤ −1.5 dBTP.

**V2 — Dialogue intelligible with every layer at level.** Measure, then confirm at the two places the meter cannot see: quiet listening level, and through the phone simulation.
```bash
ffmpeg -v error -y -i master.wav \
  -af "highpass=f=200:poles=2,lowpass=f=12000:poles=2,pan=mono|c0=0.5*c0+0.5*c1" phone.wav
ffmpeg -v error -y -i master.wav -af "pan=mono|c0=0.5*c0+0.5*c1" monosum.wav
```
Pass: mono-sum RMS drop ≤ 3 dB vs the stereo master; every word intelligible in `phone.wav`. If a word is masked, **lower the music 2 dB and re-measure — never raise the dialogue.**

**V3 — No two motion effects colliding.** Verified here: effects placed at 1567 ms and 1700 ms were flagged at 4 f apart; effects at f129 and f234 correctly passed. **[verified]**
```bash
ffmpeg -v error -i sfxbus.wav -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>&1 \
 | paste - - | sed 's/.*pts_time:\([0-9.]*\).*RMS_level=\(-*[0-9.inf]*\)/\1 \2/' > onsets.txt
```
```python
FPS = 30.0; STEP_DB = 6.0; MIN_GAP_F = 6
rows = []
for ln in open('onsets.txt'):
    p = ln.split()
    if len(p) != 2: continue
    try: rows.append((float(p[0]), float(p[1])))
    except ValueError: rows.append((float(p[0]), -120.0))       # -inf frames
ons = []
for i in range(1, len(rows)):
    if rows[i][1] - rows[i-1][1] >= STEP_DB:                     # a >=6 dB step is an onset
        f = round(rows[i][0] * FPS)
        if not ons or f - ons[-1] > 1: ons.append(f)
bad = [(a, b, b - a) for a, b in zip(ons, ons[1:]) if b - a < MIN_GAP_F]
assert not bad, f"collisions: {bad}"
```

**V4 — Every paired motion event has a sound row.** Set arithmetic against `design-motion.md`; no render needed. A motion row with a non-empty `Paired sound` and no matching `event_ref` here is a failure, not a judgement call. Report `coverage_ratio` alongside.

**V5 — Style balance and density.** Recount from the **final merged** row list, not the agents' returns — the merge deletes and merges rows. Each share within ±8 points, rank order preserved, every C2 gate satisfied.

**V6 — Ambience continuity across the cuts.** Sample the inter-word floor either side of every EDL cut; require ≤ 2 dB, and treat ≥ 4 dB as the bed having been cut with the picture.
```bash
for t in <cut_times>; do
  a=$(ffmpeg -hide_banner -ss $(python3 -c "print($t-0.45)") -t 0.4 -i master.wav -af astats \
      -f null - 2>&1 | grep -m1 "RMS level dB" | grep -oE -- "-?[0-9.]+$")
  b=$(ffmpeg -hide_banner -ss $(python3 -c "print($t+0.05)") -t 0.4 -i master.wav -af astats \
      -f null - 2>&1 | grep -m1 "RMS level dB" | grep -oE -- "-?[0-9.]+$")
  python3 -c "print('$t', abs($a-($b)))"
done
```

Finally, spot-check three cues against picture — first, middle, and **last** (`timebase.md` V4). A two-clock bug is smallest at the head and largest at the tail, so a head-only check passes on a broken map.

## 10. Failure signatures

| Symptom | Cause |
|---|---|
| Cues progressively later toward the end | designed in SOURCE timecode (`timebase.md` §1) |
| Every cue off by the same amount | head trim missing from the keep list, or a baked A/V offset |
| Whole render 4 f late | encode offset — fix globally with `itsoffset`, not per event |
| Effect measures on time, sounds late | >2 f of lead-in before the file's transient |
| Mix quietly halved when a bed was added | `amix` default `normalize=1` |
| Music present but never ducks | `sidechaincompress` threshold above the key's speech RMS (§8.2) |
| Voice ducks under the music | `sidechaincompress` inputs reversed |
| Audible dip at every join | fade left on the default `tri` curve |
| Floor steps and pumps at every jump cut | ambience cut with the picture instead of bridged (§4.2) |
| Room sounds wide and fake | a fetched room tone laid over real room tone (§4.1) |
| Two effects paid for, one heard | onsets under 6 f apart (§5.3 C1) |
| Reads flat / cheap / cluttered | no aesthetic layer / no diegetic layer / motion sound on static things |
| Nothing survives on a phone | design carried by sub-bass, nothing in 600 Hz–5 kHz (§4.4) |
| Level trace looks smooth and wrong | `astats reset` given seconds; it takes frames (§8.2) |

## 11. Verified in this container

ffmpeg 6.1.1-3ubuntu5, on synthesised media. `sidechaincompress` (the §8.2 threshold sweep, and that the threshold gates on the key, not the bed) · `asplit` · `adelay` (onset at 1.56702 s for `adelay=1567`) · `amix normalize=0` · `volume` · `alimiter` linear `limit` + `level=disabled` · `highpass` / `lowpass` / `pan=mono` · `atrim`+`asetpts` · `afade` / `acrossfade` `qsin` vs `tri` (1.07 vs 3.97 dB dip; 5.600 s for two 3.0 s files at `d=0.4`) · `-stream_loop` to 180.000000 s · `silencedetect` · `astats` (incl. `reset`-is-frames) · `asetnsamples` frame-locked RMS trace · `ametadata=print` · two-pass `loudnorm` hitting exactly −14.0 LUFS · `ebur128=peak=true` · `concat` filter · the full §8.1 graph and the §9 V3/V6 checks.

Epidemic MCP tool schemas were read live here and match §6: `SearchSoundEffects`, `SearchRecordings`, `SearchSimilarToSoundEffect`, `DownloadSoundEffect`, `DownloadRecording`, `EditRecording`, `PollEditRecordingJob`, `DownloadRecordingEdit`. **No `assetUrl` was fetched** — §6.4's egress question is open.
