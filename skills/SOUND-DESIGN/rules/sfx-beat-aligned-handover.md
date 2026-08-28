---
id: sfx-beat-aligned-handover
aliases: [sfx-track-change-on-the-beat]
title: Beat-aligned track handover — land track B's downbeat exactly on the change
skill: sound-design
type: music
family: music-transitions
tags: [skill/sound-design, type/music, family/music-transitions, layer/music, layer/sfx, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:05:41"
    quote: "Change music when the section changes. Use Find Similar for a smooth track-to-track transition, or land the change on a beat."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:24"
    quote: "then stop the first track, put in a riser sound, and start the second track at the end of the riser."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:32"
    quote: "Whenever you're starting a new section, try to make the opening beat of your music line up with that section."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:38"
    quote: "Every track has a little warm-up at the start — ignore that and start straight from the main beat."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:45"
    quote: "One more thing I do is: even when my B-rolls are running, I try to sync them to the beat of my music."
research_refs:
  - https://en.wikipedia.org/wiki/Beatmatching
  - https://en.wikipedia.org/wiki/Phrase_(music)
  - https://en.wikipedia.org/wiki/Tempo
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://aubio.org/manual/latest/cli.html
  - https://ffmpeg.org/ffmpeg-filters.html#astats-1
  - local verification 2026-08-28 — beat-phase estimator (onset envelope folded onto one beat period, BPM known) recovered a 0.3500 s grid offset as 0.3473 s on a synthetic 120 BPM click track, error 2.7 ms
  - mcp://Epidemic_sounds/SearchRecordings — every recording returns an integer `bpm`; `designed--riser` probed live (9.8–15.5 s assets)
difficulty: high
detectable_from: audio
---

# Beat-aligned track handover — land track B's downbeat exactly on the change

## What it is
The mechanics of changing music mid-video without the change sounding like an accident. When the new track's **first strong beat lands exactly on the change point**, the ear reads the handover as intentional — a musical event rather than an edit error. When it lands 100 ms late, the same handover reads as a mistake, even to a listener who could not say why.

The physics is a DJ's, minus the pitch fader. Two beds meeting off-grid produce a **flam** — two onsets a few tens of milliseconds apart — which the ear reads as an error, exactly the way it reads a double-hit drummer as sloppy. Two beds meeting **on** a downbeat, with the incoming track's first bar starting where the outgoing track's bar would have started, read as one continuous musical decision.

Three numbers make it executable. The **BPM of each track**, which Epidemic returns as a field on every recording, so it never has to be estimated. The **beat and bar length** that follow from it: `beat = 60 / BPM` seconds, `bar = 240 / BPM` in 4/4. And the **grid offset** of each file — how far into the audio the first beat of the grid sits, which is the track's "warm-up" the source tells you to skip. Set `data-media-start` to that offset and the track begins on its own downbeat; set `data-start` to the change point and the downbeat lands there.

There are two shapes of handover and they are not the same job. A **matched handover** (similar tempo and vibe, found with similarity search) can be butted or briefly crossfaded on a bar line and is nearly invisible — this is the source's "Find Similar" route and it should always be tried first. A **contrasting handover** (different vibe, different tempo) cannot be smoothed: proper beatmatching is *"pitch shifting or time stretching an upcoming track to match its tempo"*, and beyond about 6 % apart that is audible however it is done. So the contrasting handover is a **cut on the grid** rather than a blend, and the seam gets **covered** — the source's own answer is to stop track A, put a riser in the gap, and start track B at the riser's end.

## When to use it
- **At a structural section boundary** where the video's job changes and the bed must change with it ([[sfx-track-change-at-section-boundary]]) — the calm setup ending and the build starting, the tutorial ending and the results montage starting, the body ending and the outro starting.
- **When [[sfx-mood-map-per-topic]] has assigned different moods to adjacent sections** and `SearchSimilarToRecording` has failed to produce anything that bridges them. If the vibe does *not* change, prefer a similar track and the matched handover.
- **When the tempo band steps.** [[pace-tempo-band-energy-map]] caps adjacent sections at about ±25 BPM apart; a bigger step than that always needs this treatment.
- **When a bed has run long enough to stop being heard** and a change is a re-engagement device in itself.
- **When a music drop must land on a specific visual beat** — the alignment work is the same, with the change point set by picture rather than by structure ([[sfx-riser-to-music-drop-backtiming]], [[sfx-music-drop-on-structure-turn]]).
- **Do not** change mid-section. A bed swap inside a continuous argument reads as a mistake no matter how well it is placed. Move the boundary or keep the bed.
- **Do not** use a beat-aligned handover to hide a bad edit; if the picture cut is wrong, aligning the music to it just makes the wrongness rhythmic.
- **Do not** align on a beat that is not the *downbeat*. Landing on beat 3 of a bar is technically on-grid and still feels like a stumble, because the phrase does not restart there.
- **Do not** attempt tempo-matched beatmatching between tracks more than ~6 % apart — cover the seam instead.
- **Consider silence instead.** A section boundary is also the natural place for a rest, and [[sfx-music-rest-windows]] often beats a handover outright.

## How to recognise it in a reference video
- **Locate the track changes.** Long-window RMS plus a timbre change is the reliable signature: the bed's spectral centroid steps while the voice does not.
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=24000,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null | paste - -
  ```
- **Measure the phase error at each change.** Estimate the outgoing and incoming BPM (or read them from the catalogue if you know the tracks), then measure where the first strong beat of the new bed falls relative to the change frame. **Under 1 frame (33 ms) = deliberate**; 33–80 ms reads as slightly sloppy; over 100 ms reads as a mistake and usually means the editor dropped the file at the cut without trimming its warm-up.
- **Check whether the change sits on a bar line of the outgoing track.** Fold the outgoing bed's onset envelope onto its own bar period and see whether the change point coincides with the peak. Professional handovers land on the bar, not merely on a beat — and ideally on the first bar of a 4-bar phrase, since common-practice phrases run four bars *"culminating in a more or less definite cadence"*, and that cadence is the natural seam.
- **Look at the seam length.** Either the two beds butt (a hard change) or they overlap by **6–12 frames**, sometimes up to half a bar in a matched handover. A 2-second crossfade between two different tracks is a different, weaker move.
- **Check the warm-up.** B should start at its own first downbeat, not at its file's first sample — its media offset will be non-zero, typically 0.1–2.0 s in. If the new bed enters with 1–3 seconds of atmospheric wash before its first beat, the editor did *not* trim the file, and the alignment is accidental at best.
- **Listen for a cover.** A riser ending exactly on the change, a cinematic hit, a whoosh, or a deliberate 2-beat gap means the editor treated it as a contrasting handover. Log which cover — riser is the source's default; a reverse cymbal or a sub drop is the same device in another register. A bare change with no cover is possible but rarer.
- **Check the levels match.** Short-term loudness of A's last 5 s and B's first 5 s should be within about **1 LU**. If B arrives noticeably louder, the change was not level-matched, and that — not the tempo — is what you are hearing.
- **Tempo relationship.** Either the two BPMs are within ~6 % (beatmatched or nudged) or they are frankly different and the change is hard. The uncomfortable middle — 8–15 % apart with a crossfade — is the amateur signature.
- **Check the picture.** In competent work the section's first shot begins on exactly the frame the new bed does.
- **Count handovers.** Two to five per ten minutes is structural, roughly one per section and no more than a bed per two minutes. More than that and the bed is churning; fewer and the video is tonally flat ([[sfx-music-primacy-doctrine]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `beat_s` | 60 / BPM | — | 110 BPM → 0.545 s. Read BPM from the catalogue field, never guess. |
| `bar_s` | 240 / BPM | — | 4/4 assumed. 110 BPM → 2.182 s. |
| `phrase_bars` | 4 | 4–16 | Common-practice phrases run four bars; 8 and 16 are the usual pop groupings. Change on a phrase boundary where you can, not just a bar. |
| `change_position` | beat 1 of a bar | beat 1, or beat 3 at a push | Beat 1 of the first bar of a 4-bar phrase is best. Beat 3 is the only other position that does not stumble, and only in a bar-long phrase. |
| `phase_tolerance` | 20 ms | 0–33 ms | Under one frame. Two percussive onsets read as simultaneous only within roughly 20–30 ms, so this is the whole point of the note. **A looser ±2 f (±66 ms) is defensible only when the seam is covered by a riser or an impact that masks the flam** — never on a bare change. |
| `grid_offset_B` | measured | 0–8 s | The warm-up to skip, expressed as `data-media-start`. Typically 0.1–2.0 s. |
| `tempo_nudge` | ±3 % | 0 to ±6 % | `data-playback-rate = BPM_A / BPM_B`, constant and pitch-preserved. Nudge freely to 3 %; 3–6 % only if the rate stays inside 0.94–1.06. |
| `tempo_match_limit` | 6 % | 0–8 % | Beyond this, retiming B to A's tempo is audible even pitch-preserved, and blending is worse. Cut and cover. |
| `matched_crossfade` | 6–12 f (0.2–0.4 s) | 0 f to 1 bar | **Two conventions, conditioned on what you know.** With tempo ≤6 % apart but the key relationship unknown, keep the overlap short (0–12 f) — a long overlap just holds two possibly-clashing harmonies together for longer. With tempo ≤6 % apart **and** identical or fifth-related keys **and** both beds level-matched, a **half-bar equal-power overlap** (0.707 at the crossover midpoint; 1.09 s at 110 BPM) is the smoothest form and is what a matched handover is for. Never crossfade above 6 % tempo difference at any length. |
| `contrast_gap` | 0 s | 0–0.5 s · or 1–4 beats | Contrasting handover: A stops, riser covers, B starts. A visible gap under the riser is fine and often better; ambience continues underneath, and never true digital silence over 0.5 s. |
| `cover` | riser | riser \| impact \| gap | Exactly one. Riser: its peak lands **on** the change. Impact: its measured peak lands on the change, aligned by `PEAK_T`, not by eye. Gap: 1–4 beats of near-silence with ambience running ([[sfx-silence-as-pattern-interrupt]] is the full form). |
| `riser_length` | 2 bars | 8 f to 4 bars | **Conditioned on the riser's job.** As an *anticipation build* that the audience should feel coming, 1–4 bars (≈2–5 s at 110 BPM). As a bare *seam cover* that only de-emphasises the change, 8–45 f (0.27–1.5 s). Catalogue risers run 9.8–15.5 s, so trim with `data-media-start` from the end either way. |
| `riser_gain` | 0.150 (≈ −16.5 dB) | −18 to −14 dB under a running mix · up to ≈ −7 dB (`0.45`) over a stopped bed | The riser is a cover, not an event — under a continuing mix it must sit below the incoming bed's entry. Where A has fully stopped and the riser is the only content in the gap, it is the section's own event and can carry the higher level. |
| `A_tail_fade` | 0.2 s | 10 ms–0.4 s | Stop A on a peak of its own waveform, then fade the remainder. A 10 ms ramp is a de-click and is the minimum; a hard stop on a non-zero sample clicks, and a hard stop mid-sustain leaves a chord hanging. |
| `level_match_window` | 5 s each side | 3–8 s | Match short-term LUFS to within **1 LU** before judging the change at all. |
| `programme_loudness` | −14 LUFS integrated | −16 to −13 | True peak ≤ −1 dBTP. |
| `handovers_per_10_min` | 3 | 2–5 | Structural, not decorative: roughly one per section, one bed per two minutes. |

## Reproduction prompt

```
Hand over from music track A to music track B at the section change at {{CHANGE}}
seconds in {{COMP}} (30fps; HyperFrames authors seconds, frames = seconds * 30).

1. TRY THE SMOOTH ROUTE FIRST. Run SearchSimilarToRecording on A's id and
   audition the top results against the new section. If one fits the new mood,
   use it - the handover becomes a plain matched cue change. Only continue to
   the contrasting shape if the new section genuinely needs a different
   character.
2. READ BOTH BPMs from the catalogue metadata (SearchRecordings returns an
   integer bpm on every recording; verify by ear, because half-time and
   double-time labelling is common). Compute:
     beat_A = 60/BPM_A   bar_A = 240/BPM_A   (same for B)
     mismatch = |BPM_A - BPM_B| / BPM_A
3. CHOOSE THE SHAPE:
   mismatch <= 6% AND similar vibe  -> MATCHED handover
   otherwise                        -> CONTRASTING handover with a cover
4. MEASURE B'S GRID OFFSET (the warm-up to skip). With BPM known, fold B's
   onset envelope onto one beat period and take the peak:
     ffmpeg -v error -i B.wav -f f32le -ac 1 -ar 48000 - | python3 -c "
     import sys,numpy as np
     x=np.frombuffer(sys.stdin.buffer.read(),dtype=np.float32); sr=48000; bpm={{BPM_B}}
     e=np.abs(x); w=int(0.01*sr); env=np.convolve(e,np.ones(w)/w,mode='same')
     env=np.maximum(0,np.diff(env,prepend=env[0]))
     n=int(round(60/bpm*sr)); f=env[:len(env)//n*n].reshape(-1,n).sum(axis=0)
     print(round(int(np.argmax(f))/sr,4))"
   -> GRID_OFFSET_B. Sanity-check it is under 8 s and that B audibly starts on a
   beat when you skip that much. Cross-check by eye with a waveform image if in
   any doubt: ffmpeg -i B.wav -filter_complex showwavespic=s=1920x240 -frames:v 1 B.png
5. SNAP THE CHANGE POINT TO A'S BAR LINE. Compute A's own grid offset the same
   way, then move {{CHANGE}} to the nearest value of
   grid_offset_A + k * bar_A (k integer) within +/- half a bar, preferring the
   first bar of a 4-bar phrase. Record it to 3 decimal places. Move the PICTURE
   cut to match if it is within 2 frames; otherwise keep picture and accept the
   music landing on the nearest bar.
6. LEVEL MATCH BEFORE JUDGING ANYTHING. Measure short-term loudness of A's last
   5 s and B's first 5 s and adjust B's static gain so they are within 1 LU. A
   change that is really a level jump will be blamed on the edit.
     ffmpeg -ss <A_end-5> -t 5 -i A.wav -af ebur128 -f null - 2>&1 | tail -20
     ffmpeg -ss 0        -t 5 -i B.wav -af ebur128 -f null - 2>&1 | tail -20
7. PLACE:
   A: data-duration ends at CHANGE (matched) or at CHANGE - riser_length*0.5
      (contrasting), with a volume lane fading its last 0.2 s to 0 - or a 10 ms
      ramp if you are butting on a bar line. Never truncate on a live sample.
   B: data-start = CHANGE, data-media-start = GRID_OFFSET_B, data-volume 0.063.
   Matched handover with compatible keys: pull B half a bar earlier and give
   both equal-power lanes (0.707 at the crossover midpoint). Keys unknown:
   keep the overlap to 6-12 frames, or butt.
8. CONTRASTING ONLY - COVER THE SEAM with exactly ONE of:
   (a) a riser whose END lands on CHANGE. Risers peak at their end, so
       data-start = CHANGE - used_length and
       data-media-start = file_duration - used_length. Gain 0.150 under a
       running mix, up to 0.45 if A has stopped and the gap is bare.
   (b) a single impact whose MEASURED peak lands on CHANGE.
   (c) 1-4 beats of near-silence before CHANGE, ambience still running.
   Never two covers at once.
9. OPTIONAL TEMPO MATCH (matched shape, mismatch <= 6%): set B's
   data-playback-rate = BPM_A / BPM_B. It is pitch-preserved and clamped 0.1-5.
   Re-derive beat_B afterwards; the grid offset scales by the same factor.
10. VERIFY by measuring the render: the first strong onset of B must fall within
    0.020 s of CHANGE.

ACCEPTANCE TEST: (a) play 4 seconds either side with your eyes closed - you
should hear the music change and should NOT be able to point at a stumble; if
you can tap along across the seam without breaking stride, it is right;
(b) the interval between A's last beat and B's first beat equals one beat of A
within 1 frame; (c) no click at the seam; (d) short-term loudness either side
is within 1 LU; (e) the picture cut is on the same frame; (f) integrated
loudness is still -14 LUFS +/- 1 with true peak <= -1 dBTP.
```

## Execution spec

**Measuring the grid — verified 2026-08-28.** With the BPM known (and it always is, from the catalogue), the phase of the beat grid is recoverable by folding an onset-strength envelope onto one beat period and taking the argmax. Tested against a synthetic 120 BPM click track whose grid was offset by exactly 0.3500 s: the estimator returned **0.3473 s**, an error of 2.7 ms — an order of magnitude inside the 20 ms tolerance. The script is in the reproduction prompt above; it needs only `ffmpeg` and `numpy`, both present here. `aubiotrack -i B.wav` (defaults: bufsize 512, hopsize 256, output in seconds) is the better general-purpose beat tracker and `aubiotempo` estimates BPM when there is no metadata, but **aubio is not verified present in this environment**, so treat it as an optional upgrade rather than the dependency.

Two coarse cross-checks, both enough to see the first downbeat by eye:
```bash
ffmpeg -v error -i B.wav -t 8 -af "asetnsamples=n=480,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null | paste - - | head -80
ffmpeg -i B.mp3 -filter_complex "showwavespic=s=1920x240:colors=white" -frames:v 1 B_wave.png
```

**Epidemic Sound — BPM is metadata, and similarity is the matched-handover tool.**
```
# the smooth route the source names first
SearchSimilarToRecording { id:<A uuid>, first:12 }
# candidate B at A's tempo, same mood family
SearchRecordings { filter:{ bpm:{min:<BPM_A-6>,max:<BPM_A+6>},
                            moodSlugs:{matchType:ANY,values:[<A's mood tags>]},
                            vocals:false },
                   sort:{by:POPULARITY,order:DESCENDING}, first:12 }
# the cover for a contrasting handover
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["designed--riser"]},
                              duration:{min:4000,max:16000} }, first:24 }
#   real titles: "Designed, Riser, Transition, Long, Intense, Build Up, Eerie" (13.75 s)
#                "Designed, Riser, Cinematic Reverse Impact, Crescendo, Tension Build 01" (9.77 s)
#   term fallback: "designed riser transition build up clean" / "...eerie futuristic"
DownloadRecording { id:<uuid> }
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Read `bpm` off every result and write it into the project's music manifest next to the file — the handover math is unrunnable without it. Place downloads under `.media/audio/bgm/` and `assets/sfx/`, and optionally ledger with `resolve.mjs --from <file> --type bgm|sfx --project .`. `vocals: false` is known to leak; gate on the vocal-type tag as well.

**HyperFrames — three numbers, all in seconds.**
```html
<!-- MATCHED: A is 110 BPM (bar 2.182 s), change at 96.000 on a bar line.
     Half-bar equal-power overlap; B's warm-up 2.35 s is skipped. -->
<audio id="music-a" src=".media/audio/bgm/track_a.wav" data-audio-group="music"
       data-start="0" data-duration="97.091" data-media-start="1.80"
       data-track-index="11" data-volume="0.063"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:96.0,&quot;v&quot;:1},{&quot;t&quot;:96.545,&quot;v&quot;:0.707},{&quot;t&quot;:97.091,&quot;v&quot;:0}]}]}"></audio>
<audio id="music-b" src=".media/audio/bgm/track_b.wav" data-audio-group="music"
       data-start="94.909" data-duration="120" data-media-start="2.35"
       data-track-index="12" data-volume="0.063"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.545,&quot;v&quot;:0.707},{&quot;t&quot;:1.091,&quot;v&quot;:1}]}]}"></audio>

<!-- CONTRASTING: A is 112 BPM and B is 138 BPM (>6% apart), so A stops, a 2-bar
     riser ends on the change, and B starts clean on its own downbeat at 0.640 s. -->
<audio id="sfx-riser-handover" src="assets/sfx/riser/designed_riser_cinematic_01.wav"
       data-audio-group="sfx" data-start="91.636" data-duration="4.364"
       data-media-start="5.402" data-track-index="13" data-volume="0.150"></audio>
<!-- 5.402 = 9.766 (file) - 4.364 (used), so the riser's peak is its own end -->
```
Contract points: `data-media-start` is *"offset into the media source, in seconds"* and trims without touching the file — this is how the warm-up is skipped. A `volume` lane's `t` is **clip-local** and its first value is **held backwards to the clip start**, so the incoming bed needs an explicit `{"t":0,"v":0}` and the outgoing one an explicit `{"t":0,"v":1}`. Do not also GSAP-tween `volume` (`audio_volume_double_automation`, the lane wins silently), and remember a `volume` tween **replaces** `data-volume` rather than scaling it. `data-playback-rate` is a **constant** in 0.1–5, **pitch-preserved**, which makes small tempo matching possible in-composition — but there is **no rate envelope**, so a tempo *ramp* across the seam must be preprocessed. Two overlapping `<audio>` on the same track index raise `duplicate_audio_track`, hence 11/12/13; A ending exactly where B starts is a half-open window with no shared frame, but separate indices remove all doubt and are required for any overlap. Write these JSON attributes **double-quoted with `&quot;`** or `carve.mjs`'s `name="..."` regex cannot see them and a later carve silently overwrites work it could not see. The carve belongs on **both** beds, against the `voiceover` **group** and never a list of clip ids (`audio_carve_ungrouped_sources`); keep the riser in the `sfx` group, since a non-voice member inside the carve group poisons the next re-analysis. Re-run `carve.mjs` after adding B — its nodes are tagged `fromCarve` and replaced wholesale on re-run. Note the transition **registry** (`crossfade`, `blur-crossfade`, …) is for *picture* scenes only; it does not touch audio.

**ffmpeg — when a physical cut is genuinely needed** (an asset leaving the pipeline, or a bed you want to loop cleanly):
```bash
# trim A to end exactly on a bar line and B to start on its downbeat
ffmpeg -i track_a.wav -ss 1.80 -t 95.291 -c:a pcm_s16le a_cut.wav
ffmpeg -i track_b.wav -ss 2.35 b_cut.wav
# hard change with a de-click, then concat
ffmpeg -i bedA.mp3 -af "atrim=0:87.857,afade=t=out:st=87.847:d=0.01:curve=tri" a.wav
ffmpeg -i bedB.mp3 -af "atrim=0.640,asetpts=N/SR/TB,afade=t=in:st=0:d=0.01:curve=tri" b.wav
printf "file '%s'\n" a.wav b.wav > list.txt && ffmpeg -f concat -safe 0 -i list.txt -c copy handover.wav
# or an equal-power crossfade of half a bar (0.545 s at 110 BPM) when tempo and key permit
ffmpeg -i a_cut.wav -i b_cut.wav -filter_complex "acrossfade=d=0.545:c1=tri:c2=tri" ab.wav
# retime B to A's tempo, pitch-preserved, when the mismatch is under 6%
ffmpeg -i b_cut.wav -af "atempo=1.036" b_matched.wav
```
`acrossfade` options are `nb_samples`/`duration`, `overlap`, and `curve1`/`curve2`. Keep scratch outside the mounted vault — it cannot delete files.

**Remotion:** two `<Audio>` elements with `startFrom` set to each track's grid offset in frames, sequenced so B's `from` is the change frame. Concept only.

## Pairs with
[[sfx-track-change-at-section-boundary]] · [[sfx-music-hard-stop]] · [[sfx-music-fade-out-section-signal]] · [[sfx-music-rest-windows]] · [[sfx-music-drop-on-structure-turn]] · [[sfx-riser-anticipation-build]] · [[sfx-riser-to-music-drop-backtiming]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-silence-as-pattern-interrupt]] · [[sfx-music-primacy-doctrine]] · [[sfx-mood-map-per-topic]] · [[sfx-peak-offset-measurement]] · [[sfx-audio-match-bridge]] · [[sfx-playback-verification-loop]] · [[pace-beat-grid-extraction]] · [[pace-cut-on-the-beat]] · [[pace-tempo-band-energy-map]] · [[pace-bpm-matched-music-selection]] · [[motion-beat-quantised-animation]] · [[struct-music-arc-to-narrative-arc]]

## Failure modes
- **Dropping track B at the cut without trimming its warm-up.** The bed enters with 2 seconds of wash and the "beat-aligned" handover is aligned to nothing. Fix: measure the grid offset, set `data-media-start`.
- **Landing between beats.** Even 3 frames off produces a flam and the whole change reads as sloppy. Fix: quantise to A's grid, not to the video's section marker.
- **Landing on a beat that is not a downbeat.** On-grid and still wrong: the phrase does not restart, so the ear hears a stumble. Fix: fold onto the *bar* period, and prefer a 4- or 8-bar phrase boundary.
- **Beatmatching or crossfading tracks more than 6 % apart.** Even pitch-preserved, the retimed track's transients smear and its groove flattens; an overlap contains two conflicting grids and sounds like a mistake for its whole length. Fix: contrasting shape, hard cut on the grid, one cover.
- **Not level-matching.** A change that jumps 4 LU is heard as a volume error, and no amount of beat accuracy fixes that impression. Fix: match short-term loudness across a 5 s window each side to within 1 LU before you judge anything.
- **A riser used as the cover but placed by its file start.** Risers peak at their end; placed by start, the build resolves seconds after the change. Fix: `data-start = change − used_length` and trim from the head.
- **Riser too loud for its job.** Under a running mix it stops being a cover and becomes the event, which then needs its own payoff. Fix: −18 to −14 dB under a continuing bed; the louder setting is only for a bare gap where the riser is the only content.
- **Stacking covers.** Riser *and* impact *and* a gap is three attention devices on one frame; the seam becomes the loudest thing in the section. Fix: exactly one.
- **Hard-stopping A mid-sustain, or truncating instead of ramping.** Clicks, or leaves a chord hanging. Fix: stop on a peak of A's own waveform and fade the last 0.2 s — or at minimum two lane points 10 ms apart as a de-click.
- **Changing tracks mid-section.** A handover inside a continuous argument always reads as an error, however well placed. Fix: move the boundary or keep the bed.
- **Aligning the music to a picture cut that is itself wrong.** Rhythmic wrongness. Fix: fix the cut first; the music follows structure, not vice versa.
- **Forgetting the picture entirely.** A perfectly placed music change with the picture cutting 20 frames later feels broken in a way viewers attribute to the music.
- **Known gap:** the estimator above assumes **4/4 and a steady tempo**, which covers nearly all catalogue production music but fails on rubato, 3/4, and tracks with a tempo change. There is no meter detection and **no key detection** anywhere in the verified toolset, and nothing validates that the change landed on a beat — check by ear that four beats fill one bar before trusting the bar math, treat key compatibility as an assumption you must audition, and verify the seam by listening, per [[sfx-playback-verification-loop]].
