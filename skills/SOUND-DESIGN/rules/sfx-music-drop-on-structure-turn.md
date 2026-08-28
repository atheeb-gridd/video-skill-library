---
id: sfx-music-drop-on-structure-turn
title: Land the music's drop on the structural turn, not just its mood on the segment
skill: sound-design
type: music
family: music-arc
tags: [skill/sound-design, type/music, family/music-arc, engine/hyperframes, engine/epidemic, engine/ffmpeg, layer/music, source/editing-kt, source/editing-kt-3, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:13:43"
    quote: "Don't just match the mood of the song to the tone of the segment, level up your music by syncing the highs and lows of the song to the video."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:13:54"
    quote: "In this segment, for example, I introduced the problem right here and started explaining the solution here. I arrange things so the music drops in at exactly that moment."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:14:05"
    quote: "That marks a clear topic change from problem to solution and it also makes the solution segment more exciting."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:32"
    quote: "Whenever you're starting a new section, try to make the opening beat of your music line up with that section. Every track has a little warm-up at the start — ignore that and start straight from the main beat."
research_refs:
  - https://en.wikipedia.org/wiki/Click_track
  - https://librosa.org/doc/latest/generated/librosa.beat.beat_track.html
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://en.wikipedia.org/wiki/Auditory_masking
  - mcp://Epidemic_sounds/SearchRecordings + EditRecording (BPM, stems and requiredRegionsAtOffsets verified live, 2026-08-27)
difficulty: high
detectable_from: audio
---

# Land the music's drop on the structural turn, not just its mood on the segment

## What it is
Mood-matching is the entry-level use of a bed: pick a track whose feeling fits the segment. This is the next level: treat the track's **dynamic arc** as a second narrative line and make its biggest energy change coincide with the script's biggest structural change — canonically the problem-to-solution turn. The drop then does two jobs at once. It marks the topic change, so the viewer feels a new section beginning without being told, and it injects energy exactly where the content becomes the payoff.

The craft problem is that songs and scripts do not naturally line up. Three levers exist, and they should be tried in this order: **re-cut the music** so its drop falls on the turn, **slip the music** by whole bars, or **move the picture** so the turn falls on the drop. This note is about doing that arithmetic accurately rather than nudging by ear.

## When to use it
- **Any two-part structure with a hinge:** problem → solution, before → after, wrong way → right way, question → answer, setup → reveal. The hinge is the drop point.
- **Once or twice per video.** A drop on every section boundary spends the device; then a section change wants a track change ([[sfx-track-change-at-section-boundary]]) or a riser bridge ([[sfx-riser-to-music-drop-backtiming]]) instead.
- **When the segment after the turn is 20 s or longer.** A drop needs somewhere to go; dropping into an eight-second segment wastes the arc.
- **Not under the video's single most important sentence.** Energy arriving on a line competes with it — use [[sfx-music-hard-stop]] there instead. The two moves are opposites and must not be adjacent.

## How to recognise it in a reference video
- **Find the music's own energy steps.** Split the audio, window the loudness, and look for step changes of **≥4 LU** between consecutive 1 s windows that are *not* explained by the voice:
  `ffmpeg -i ref.wav -af "ebur128=framelog=verbose" -f null - 2>&1 | grep "M:"`
  A drop shows as a sustained step up in momentary loudness with new low-frequency energy appearing (kick/bass entering).
- **Compare each step to the transcript.** Mark topic boundaries from the transcript (the first word of the new claim). A deliberate drop sits within **±0.25 s (±7 frames)** of that word — usually in the breath *before* it.
- **Check the bar grid.** Estimate BPM (`librosa.beat.beat_track(y=y, sr=sr, units='time')`); a bar at 4/4 is `240 / BPM` seconds. In edited work the drop lands on a bar line, and the cuts around it also land on beats. If the drop is on the turn but off the grid, the track was slipped rather than edited — log which.
- **Check the head of the bed.** The source video's other rule shows up here: a bed that begins at a section start usually has its **intro warm-up trimmed off** so the section opens on the main beat. Look for a bed that starts already at full energy.
- **Look for the riser.** A drop landed deliberately is very often preceded by a 1.5–3 s riser whose peak lands on the same frame.
- **Negative check:** a track whose drop falls mid-sentence, or 2 s after the turn, is a bed dropped in unedited. That is the common amateur pattern and should be logged as absent, not as present.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Drop vs turn word | −0.10 s (in the breath before) | −0.35 to +0.07 s | Slightly early reads as "the music knew"; late reads as a mistake. This is the one place a small audio lead is right, because the drop is not bound to a visual event. |
| Grid tolerance | ±2 frames (±67 ms) of a bar line | ±0 to ±4 f | The turn wins over the grid if they conflict by more than 0.15 s. |
| Bar length | `240 / BPM` s | 2.0–2.4 s at 100–120 BPM | Slip the bed in whole bars so existing beat-synced cuts survive. |
| Pre-drop bed level | −25 dB (`0.056`) | −22 to −28 dB | Under narration. |
| Post-drop bed level | −22 dB (`0.079`) | −20 to −25 dB | A drop is +2 to +4 dB, not +8. The arrangement does the work, not the fader. |
| Level ramp at the drop | 0 s (hard) | 0–0.15 s | A drop is an arrangement event; do not fade into it. |
| Ducking | carve, `strength` 0.25 | 0.2–0.35 | Keep the carve running through the drop; raise strength by 0.05 for the louder post-drop section rather than pulling the fader. |
| Riser in front | 2.0 s | 1.5–3.0 s | Peak on the same frame as the drop. |
| Uses per video | 1 | 1–2 | |
| Minimum post-drop segment | 20 s | 12–90 s | |

## Reproduction prompt

```
Make the music drop land on the problem-to-solution turn at {{T_TURN}} seconds,
where {{T_TURN}} is the start time of the first word of the solution segment.

1. FIND THE TARGET FRAME. From the word-level transcript take the onset of the
   first word after the turn. Set DROP_TARGET = that onset - 0.10 s, so the drop
   arrives in the breath before the line rather than on top of it.
2. GET THE TRACK AND ITS BPM.
     SearchRecordings { query:{term:"<mood> <genre>"},
                        filter:{ vocals:false, bpm:{min:100,max:120} }, first:10 }
   The response carries bpm per recording. bar_seconds = 240 / bpm.
3. FIND THE TRACK'S OWN DROP. Download the FULL mp3 preview, then:
     python -c "import librosa,numpy as np; y,sr=librosa.load('t.mp3');
     rms=librosa.feature.rms(y=y)[0]; t=librosa.times_like(rms,sr=sr);
     d=np.diff(rms); print(t[int(np.argmax(d))])"
   Call that DROP_SRC (seconds into the file). Sanity-check it by ear.
4. ALIGN, trying the levers in this order:
   a. RE-CUT THE MUSIC (best). Ask Epidemic for an edit that puts the drop at
      the offset you need:
        EditRecording { id:<recordingId>, input:{
          targetDurationMs: <segment length in ms>,
          requiredRegionsAtOffsets: [{ startMs:<DROP_SRC*1000>,
                                       endMs:<DROP_SRC*1000 + 20000>,
                                       offsetMsInEdit:<(DROP_TARGET - BED_START)*1000> }],
          downloadAudioFormat: WAV } }
      then PollEditRecordingJob until COMPLETED and DownloadRecordingEdit.
   b. SLIP THE BED. Set data-media-start = DROP_SRC - (DROP_TARGET - BED_START).
      If that is negative, move BED_START later by whole bars until it is
      positive. Only slip in multiples of bar_seconds.
   c. MOVE THE PICTURE. Extend or trim the B-roll immediately before the turn so
      {{T_TURN}} moves onto the drop. Never move it by more than 0.5 s - the
      script's pacing outranks the music.
5. TRIM THE INTRO. If the bed starts a section, cut its warm-up: set
   data-media-start to the track's first main downbeat, not 0.
6. STEP THE LEVEL. On the bed's volume lane (clip-local t):
     {t:0,v:0.056} {t:DROP_TARGET-BED_START, v:0.056}
     {t:DROP_TARGET-BED_START+0.001, v:0.079} ... hold to the end
   The lane holds its FIRST value backwards to clip start, so t:0 is mandatory.
7. OPTIONAL RISER. Place a 2 s riser whose PEAK sits on DROP_TARGET; back-time
   its data-start by (peak_offset_in_file).
8. RE-RUN THE CARVE so the louder section still leaves the voice intact:
     node <SKILL_DIR>/scripts/carve.mjs --comp index.html

ACCEPTANCE TEST: play from 6 s before the turn to 6 s after with picture. The
new section feels like it starts on the drop, not on the cut. Every word of the
first solution sentence is intelligible with the bed at level. Muted, the edit
still reads; with sound, the turn reads as bigger. Snap the timeline to the
beat grid: the drop is within 2 frames of a bar line.
```

## Execution spec

**Hyperframes.** The bed is one `<audio>` at the host root (audio at root survives scene cuts), with a `volume` automation lane for the step. Lane `t` is **clip-local seconds** — subtract the bed's `data-start` from every composition timecode. Do not also GSAP-tween `volume`: `audio_volume_double_automation` — the lane wins and the tween is silently ignored.

```html
<audio id="music-bed" src="assets/audio/bgm/bed-edit.wav"
       data-audio-group="music"
       data-start="0" data-duration="96" data-media-start="1.85"
       data-track-index="11"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0.056},{&quot;t&quot;:41.9,&quot;v&quot;:0.056},{&quot;t&quot;:41.95,&quot;v&quot;:0.079}]}]}"></audio>
```

Write these JSON attributes **double-quoted with `&quot;`** — `carve.mjs` finds them with a `name="..."` regex and a single-quoted attribute is invisible to it. `data-media-start="1.85"` is the trimmed intro warm-up; no file is cut for that.

**Epidemic Sound.**
- `SearchRecordings` returns `bpm` per recording, plus `stems` (`DRUMS`, `BASS`, `MELODY`, `INSTRUMENTS`, `VOCALS`). Filters verified live: `vocals: false`, `bpm {min,max}`, `moodSlugs`, `featuredInstrumentSlugs` (e.g. `drums`, `electronic-drums`, `percussion`), `taxonomySlugs` (genre/decade/country), `musicalKeys`.
- **`EditRecording` is the precision tool** and is the reason this technique is executable at all: `targetDurationMs` (max 300 000), `requiredRegionsAtOffsets[{startMs,endMs,offsetMsInEdit}]` — a source region forced to land at a chosen offset in the output — plus `preferenceRegions` (PREFER/AVOID), `loopable`, `forceDuration`, `maxResults`. Poll with `PollEditRecordingJob`, fetch with `DownloadRecordingEdit`.
- **Stem trick for a drop that does not exist.** `DownloadRecording` takes `stemType: FULL | BASS | DRUMS | INSTRUMENTS`. Run `INSTRUMENTS` alone before the turn and add `DRUMS` + `BASS` from the turn onwards as two extra clips — a manufactured drop, frame-exact by construction, on any track. Verified live on tracks such as *Open Roads* (106 BPM) and *Maximum Profit (Instrumental Version)* (100 BPM), both of which expose DRUMS/BASS/INSTRUMENTS stems.

**ffmpeg.** Measuring the drop and checking the result: `ffmpeg -i bed.wav -af ebur128=framelog=verbose -f null -` for momentary loudness; `ffmpeg -i bed.wav -af "atrim=0:30,astats=metadata=1:reset=1" -f null -` for per-second RMS. Physical trims are unnecessary — `data-media-start` does the slip in-composition.

**Remotion.** `<Audio src={bed} startFrom={Math.round(mediaStart*fps)} volume={f => f < dropFrame ? 0.056 : 0.079} />` — the frame-conditional volume is the direct equivalent of the two-point lane.

## Pairs with
[[struct-music-arc-to-narrative-arc]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-music-hard-stop]] · [[sfx-music-rest-windows]] · [[sfx-bpm-filter-first]] · [[sfx-track-change-at-section-boundary]] · [[sfx-beat-forward-bed-under-voice]] · [[pace-cut-on-the-beat]] · [[pace-beat-grid-extraction]] · [[struct-emotional-arc-drives-retention]]

## Failure modes
- **Drop lands on the first word.** The energy step masks the syllable and the line loses. Put it in the breath before, at −0.10 s.
- **Slipping by a non-bar amount.** Every beat-synced cut in that section goes out of phase with the bed. Slip only in multiples of `240 / BPM`.
- **Faking the drop with the fader.** +8 dB on the same arrangement reads as a volume mistake, not as a drop. The bass and drums must actually arrive — use the stems if the track will not oblige.
- **Two drops close together.** The second is inaudible as an event; the section just gets loud. One per structural hinge, one or two per video.
- **Forgetting to re-carve.** The post-drop bed is denser and louder; the carve settings that worked before it will not hold. Re-run `carve.mjs` and listen to the first sentence after the drop specifically.
- **Trusting `vocals: false`.** Live results sometimes carry a `vocal presence` tag despite the filter. Read the returned tag list before committing, or a vocal will start fighting the narration exactly where the energy rises.
- **Known gap:** nothing in the stack detects drops or bar lines. BPM comes from the Epidemic response; the drop offset and the bar arithmetic are computed outside the composition and written in by hand.
