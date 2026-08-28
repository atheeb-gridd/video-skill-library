---
id: sfx-track-reversion-to-edit-length
title: Re-cut the track to the edit — Create Version, not a fade-out
skill: sound-design
type: music
family: music-selection
tags: [skill/sound-design, type/music, family/music-selection, layer/music, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:05:10
    quote: "Here you can search music by speed, emotion, instrument. And if you like a track, there's a \"find similar\" option to get more music like it."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:05:15
    quote: "And the craziest thing — go to Create Version and you can pull out an edited track by adding or removing sections however you want."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:02:49
    quote: "Now music is the layer that drives the emotion. It's the layer that makes the video feel complete. And it's the one single layer that can carry an entire video on its own."
research_refs:
  - https://en.wikipedia.org/wiki/Drop_(music)
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/EditRecording (full input contract read from the live schema, 2026-08-28)
  - mcp://Epidemic_sounds/SearchRecordings (stems, tags and filters probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Re-cut the track to the edit — Create Version, not a fade-out

## What it is
A three-minute library track under a 47-second section leaves you three bad options: fade it out arbitrarily, cut it dead, or let it run past the section. All three announce that the music was fitted to the video rather than written for it. The fourth option is to **re-version the track** — have the library rebuild it at the length you need, keeping its own structure so it still has an intro, a build and an ending, just a shorter one.

In this stack that is not a UI feature, it is an API: `EditRecording` takes a `targetDurationMs` and returns a job that produces bar-accurate alternate arrangements. It also takes `requiredRegionsAtOffsets` — a guarantee that a named region of the source appears at a chosen offset in the output — which is what turns "the chorus is at 1:08 and my reveal is at 0:34" into a solvable problem rather than a compromise.

This note is the end of the music workflow that the three filter notes begin. Search narrows by BPM, mood and instrument ([[sfx-bpm-filter-first]], [[sfx-mood-vibe-filter]], [[sfx-instrument-filter-search]]); Find Similar expands from the one track that worked ([[sfx-find-similar-track-handover]]); re-versioning is what makes the chosen track fit. And it matters more than any of the effect work, because music is the layer that carries the video — if only one layer is ever going to get attention, it is this one ([[sfx-music-primacy-doctrine]]).

## When to use it
- **The section's length is fixed and the track's is not** — the usual case. Give the API the section length plus a couple of seconds of handle.
- **A structural moment must land on a specific frame.** A drop, a chorus entry, or a build has to arrive at your reveal. `requiredRegionsAtOffsets` places it; see [[sfx-riser-to-music-drop-backtiming]] for the timing arithmetic.
- **The track's intro is too long.** Almost every library track opens with 8–16 s of atmosphere. `preferenceRegions` with `AVOID` on the intro is cleaner than trimming into the middle of a phrase.
- **You need a real ending.** A re-version ends *musically*. A fade-out ends *administratively*, and the viewer can tell.
- **You need a seamless loop** under an indeterminate-length section — `loopable: true`.
- **Not for a plain shortening you could do in the composition.** `data-media-start` + `data-duration` trims with no re-encode, no job, no wait. Re-version only when you need the *arrangement* changed, not just the window.
- **Not when the section is over 300 seconds.** `targetDurationMs` is hard-capped at 300000. Longer sections take the full track plus in-composition trimming, or two edits.
- **Not as a substitute for choosing the right track.** A re-version of the wrong track is the wrong track, at the right length.

## How to recognise it in a reference video
- **A library track ending on a resolved cadence at a non-standard length.** Measure it: a stock track runs 1:45–3:30 and lands on a round-ish structure. A section whose music runs 0:47 and ends on a proper final chord has been re-versioned or hand-edited — an unedited track would have been faded.
- **No fade-out at a section boundary.** The single strongest signal. Trace the last two seconds:
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
   ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
  A fade shows a smooth 20–40 dB decline over 1–3 s. A musical ending shows level held to within ~0.3 s of the end, then a decay that is the *instrument's* decay, not a gain ramp.
- **Structural events landing on picture events.** If the chorus enters exactly on the reveal and the build starts exactly on the section's first frame, either the editor got extremely lucky or the track was re-versioned.
- **Bar-accurate joins.** Compute bar length from BPM (`bar = 240 / BPM` in 4/4) and check whether the section boundaries fall on bar multiples from the track's first downbeat. Re-versioned edits do; hand-trimmed ones usually do not.
- **The same track at two different lengths in one video** — a strong tell, and a good practice to copy: one track, two versions, gives coherence without repetition.
- **Count distinct tracks against sections.** Two to four tracks across a ten-minute video, each appearing at a section-appropriate length, is the signature of a re-versioning workflow.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `targetDurationMs` | section length + 3000 | ≤ **300000** | Hard API ceiling. Add 2–4 s of handle so the composition can trim rather than the edit landing short. |
| `forceDuration` | `true` | bool | `true` guarantees the exact length; `false` lets the engine land on the nearest musically sensible one. Use `false` when the section can flex by a second, `true` when it cannot. |
| `loopable` | `false` | bool | `true` for beds under indeterminate-length material. A loopable edit ends where it begins. |
| `maxResults` | 3 | 1–5 | The job returns alternates. Audition them; they differ meaningfully in which sections survived. |
| `skipStems` | `true` | bool | `true` is faster and is right when you only need the mix. Set `false` when you also want the `INSTRUMENTS` stem ([[sfx-vocal-vs-instrumental-bed]]). |
| `downloadAudioFormat` | `WAV` | `MP3` \| `WAV` | WAV for anything that will be processed further. |
| `requiredRegionsAtOffsets[].startMs` / `endMs` | drop − 8 s to drop + 12 s | — | Include the run-up, not just the moment; a region that starts on the downbeat can join mid-phrase. |
| `requiredRegionsAtOffsets[].offsetMsInEdit` | `(T_EVENT − bed_start) × 1000 − 8000` | — | Where that region begins **in the output**, so subtract the same run-up you included. |
| `preferenceRegions` on the intro | `AVOID` 0–12000 ms | 8000–20000 | Library intros are long. |
| Poll interval | 3 s | 2–10 s | Statuses: `PENDING`, `IN_PROGRESS`, `COMPLETED`, `FAILED`. |
| Bed level under narration | −22 dB (`data-volume` 0.079) | −25 … −20 dB | ([[sfx-layer-volume-targets]]) |
| Handle for in-composition trim | 2 s each end | 1–4 s | So `data-media-start` and `data-duration` have room to move. |
| Distinct tracks per 10 min | 3 | 2–4 | Versions of one track do not count against this. |

## Reproduction prompt
```
Fit the chosen track to section {{SECTION}} ({{S_IN}}..{{S_OUT}} composition seconds).

1. ASK WHETHER YOU NEED A JOB AT ALL. If the track is already close to the right
   length, or you only need a window of it, DO NOT re-version: set
   data-media-start and data-duration on the clip. That is free, instant, needs no
   re-encode, and is the documented in-composition trim. Re-version only when you
   need the ARRANGEMENT changed - a real ending, a shorter build, a chorus moved.

2. COMPUTE THE INPUTS.
     SECTION_MS   = ({{S_OUT}} - {{S_IN}}) * 1000
     TARGET_MS    = SECTION_MS + 3000        # handle; must be <= 300000
   If SECTION_MS > 297000, stop: use the full track with in-composition trimming,
   or split the section into two edits.

3. IF A MUSICAL MOMENT MUST LAND ON A FRAME, measure it in the SOURCE file first
   (largest positive RMS step for a drop; the chorus entry by ear otherwise) and
   express it as a required region:
     startMs        = (T_MOMENT_FILE - 8) * 1000     # include the run-up
     endMs          = (T_MOMENT_FILE + 12) * 1000
     offsetMsInEdit = (T_EVENT_COMP - {{S_IN}} - 8) * 1000
   Both offsets subtract the same 8 s run-up, so the MOMENT lands on T_EVENT_COMP.

4. SUBMIT.
     EditRecording { id: <recordingId>, input: {
        targetDurationMs: TARGET_MS,
        downloadAudioFormat: "WAV",
        forceDuration: true,
        loopable: false,
        skipStems: true,
        maxResults: 3,
        requiredRegionsAtOffsets: [ ...from step 3, or omit ],
        preferenceRegions: [ { startMs: 0, endMs: 12000, preferenceType: "AVOID" } ]
     } }
   Then poll PollEditRecordingJob with the returned job id every 3 s until status
   is COMPLETED. FAILED means the constraints are unsatisfiable - the usual cause
   is a required region longer than the target duration, or a target under about
   15 s. Relax forceDuration first, then widen the region.

5. DOWNLOAD AND RE-MEASURE. DownloadRecordingEdit { jobId, editId } for each
   returned edit. The edit is a NEW ARRANGEMENT: every timestamp you measured in
   the source is now wrong. Re-run the RMS trace on the downloaded file and
   re-locate the drop / chorus before placing anything against it.

6. AUDITION ALL THREE against picture, not against silence. They differ in which
   sections survived, and the difference is usually obvious the moment it plays
   over the cut.

7. PLACE. data-start = {{S_IN}}, data-media-start trims the 1.5 s of handle at the
   head, data-duration = {{S_OUT}} - {{S_IN}}, data-volume = 0.079,
   data-audio-group="music", and carve against the voiceover group at strength
   0.25. Give the clip a head fade and, if you are cutting into its ending, a
   600 ms tail fade.

ACCEPTANCE TEST: (a) the music ends musically at {{S_OUT}}, with no gain ramp in
the last 2 s unless you authored one; (b) any required moment lands within 1 frame
of its picture event; (c) played end to end the edit has a beginning, a middle and
an end - if it sounds like a loop, set loopable false and re-run.
```

## Execution spec

**Placement spec.** A bed is structural: its first downbeat lands on the section's **first frame (0 frames offset, never late)**, it sits at **−20 to −25 dB relative to dialogue** (`data-volume` 0.056–0.1; default 0.079 = −22 dB; −30 dB / 0.032 for dense-guitar rock), and it is **carved** against the `voiceover` group at strength 0.25 rather than level-ducked. A required musical moment inside the edit lands on its picture event at **0 to −1 frames** — audio may lead, never lag.

**Epidemic Sound.** The full workflow, in the order the API supports it.

```jsonc
// 1. search — the three axes the source video names, as filters
{ "filter": { "bpm": { "min": 100, "max": 120 },              // speed
              "moodSlugs": { "matchType": "ALL", "values": ["hopeful"] },  // emotion
              "featuredInstrumentSlugs": { "matchType": "ANY",
                                           "values": ["acoustic-guitar"] }, // instrument
              "vocals": false,
              "duration": { "min": 90000 } },
  "sort": { "by": "POPULARITY", "order": "DESCENDING" }, "first": 12 }

// 2. expand from the one that worked
// SearchSimilarToRecording { id: <recordingId>, first: 10 }

// 3. re-version to the edit
{ "id": "<recordingId>",
  "input": {
    "targetDurationMs": 50000,
    "downloadAudioFormat": "WAV",
    "forceDuration": true,
    "loopable": false,
    "skipStems": true,
    "maxResults": 3,
    "requiredRegionsAtOffsets": [
      { "startMs": 60400, "endMs": 80400, "offsetMsInEdit": 18000 } ],
    "preferenceRegions": [
      { "startMs": 0, "endMs": 12000, "preferenceType": "AVOID" } ] } }

// 4. PollEditRecordingJob { id: <jobId> }  until status COMPLETED
// 5. DownloadRecordingEdit { input: { jobId, editId } } -> assetUrl
```

Contract details worth holding onto, read from the live schema: `targetDurationMs` and `downloadAudioFormat` are the only **required** inputs and the duration ceiling is **300000 ms**. `preferenceType` is `PREFER` or `AVOID`. Job status is one of `PENDING`, `IN_PROGRESS`, `COMPLETED`, `FAILED` — it is asynchronous and there is no synchronous shortcut. `skipStems: true` is *"useful for creating edits faster"*; set it `false` only when you also want the stem set. Every `Recording` also exposes `bpm`, `stems[]` (`DRUMS`, `BASS`, `MELODY`, `INSTRUMENTS`, `CLEAN_VOCALS`, `VOCALS`) and dimensioned `tags[]` — those are what the search notes consume. The `vocals` boolean **leaks** and must be gated on the returned `vocal type` tag ([[sfx-vocal-vs-instrumental-bed]]).

Out of scope for this stack: the source video also demonstrates the Premiere and DaVinci plugins that place library results straight onto an NLE timeline. There is no NLE here — the deliverable is composition HTML plus assets, so the equivalent step is downloading to a project-local path and authoring a clip.

**HyperFrames.** The edit re-enters as an ordinary `src`. Sourcing stops at the file; everything after is placement.

```html
<audio id="vo-4" src=".media/audio/voice/line-04.wav" data-audio-group="voiceover"
       data-start="61.0" data-track-index="10"></audio>

<audio id="bed-section-4" src="assets/audio/bgm/hopeful-110-edit-50s.wav"
       data-audio-group="music" data-track-index="11"
       data-start="60.0" data-duration="47.0" data-media-start="1.5"
       data-volume="0.079"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.4,&quot;v&quot;:1},{&quot;t&quot;:46.4,&quot;v&quot;:1},{&quot;t&quot;:47,&quot;v&quot;:0}]}]}"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```

Then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`, which needs `ffmpeg` on PATH and `@hyperframes/core` installed in the project. Carve settings live on the **bed**, `sources` names a **group** not a list of clip ids, and `data-fx-carve` is clip-only — never on an `<hf-audio-group>`. Keep the carve group voices only; an SFX clip inside it silently poisons the next re-analysis. Write JSON attributes **double-quoted with `&quot;`** or `carve.mjs` cannot see them. In a modular project, keep audio at the **host root** so playback survives scene cuts. Every `<audio>` needs an `id`. Optionally ledger the download: `node <SKILL_DIR>/scripts/resolve.mjs --from <file> --type bgm --project .`.

Note that `audio-duck.mjs` expects an `audio_meta.json`; an Epidemic-sourced project either produces an equivalent meta file or drives the carve directly off the composition — the carve route needs no meta file and is the one to prefer here.

**ffmpeg.** Verify the edit before trusting it, and normalise for delivery:
```bash
# where did the arrangement's turns end up? per-frame RMS on the DOWNLOADED edit
ffmpeg -i edit.wav -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null

# exact length and sample rate
ffprobe -v error -show_entries format=duration -show_streams edit.wav | head -20

# delivery loudness, two-pass (YouTube/Tidal −14 LUFS, podcast −16, TP ≤ −1 dBTP)
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null -
ffmpeg -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=…:linear=true mix.social.wav
```

**Remotion.** Same asset, an `<Audio>` in a `<Sequence>`. The re-versioning is a sourcing step and is framework-independent. Portability note only — Remotion is not part of this stack.

## Pairs with
[[sfx-bpm-filter-first]] · [[sfx-mood-vibe-filter]] · [[sfx-instrument-filter-search]] · [[sfx-find-similar-track-handover]] · [[sfx-emotion-music-lookup-table]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-music-stem-layering]] · [[sfx-music-fade-out-section-signal]] · [[sfx-music-hard-stop]] · [[sfx-track-change-at-section-boundary]] · [[sfx-beat-aligned-handover]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-music-primacy-doctrine]] · [[sfx-music-audition-against-picture]] · [[sfx-layer-volume-targets]] · [[struct-music-arc-to-narrative-arc]]

## Failure modes
- **Re-versioning when a trim would do.** A job costs a wait and a download; `data-media-start` + `data-duration` costs nothing and needs no re-encode. Re-version for arrangement, trim for window.
- **Reusing source timestamps after the edit.** The output is a different arrangement. Every measured offset is invalid; re-measure on the downloaded file. This is the single most common mistake with `requiredRegionsAtOffsets`.
- **A required region with no run-up.** Naming only the drop's downbeat lets the engine join into it mid-phrase. Include ~8 s before and ~12 s after, and subtract the same run-up from `offsetMsInEdit`.
- **Exceeding 300 s.** The ceiling is hard. Long sections take the full track plus in-composition trimming, or two edits joined on a boundary.
- **Taking the first result.** `maxResults: 3` exists because the alternates differ in which sections survived. Audition all of them against picture.
- **`forceDuration: true` on a very short target.** Under about 15 s the engine has little to work with and the result can sound spliced. Try `false` first and let it land musically.
- **Fading a re-versioned ending.** You paid for a musical ending; a fade on top of it throws it away.
- **Ignoring the vocals gate.** A re-version inherits the source's vocal type. If the section has narration, take the `INSTRUMENTS` stem (`skipStems: false`) rather than the mix.
- **Known gap:** the API exposes **no bar grid, no section labels and no energy curve** on either the source or the edit — you can constrain a region and a duration, but you cannot ask *where the chorus is*. Locating structure is still a measurement step (RMS trace plus `240 / bpm` arithmetic), and it fails on tracks with tempo changes or a reported `bpm: 0`.
