---
id: sfx-music-audition-against-picture
aliases: [sfx-audition-music-against-picture]
title: Judge a track only against the locked cut, at final level
skill: sound-design
type: music
family: music-selection
tags: [skill/sound-design, type/music, family/music-selection, engine/epidemic, engine/ffmpeg, engine/hyperframes, layer/music, source/editing-kt-3, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:05
    quote: "Instead, you should focus on these three parameters: BPM, instruments and vibe."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:18"
    quote: "The higher the BPM, the faster and more energetic your music will feel. So if you've spoken fast in the video, high BPM will feel good, and if you've spoken slowly, low BPM music will suit more."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:49
    quote: "Well, that you'll find out by playing the music together with the video."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:01:54
    quote: "What you should not do is this: you liked a track, you downloaded it, you put it under the video, but it isn't going with the video - so you go back again and start hunting all over again."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://en.wikipedia.org/wiki/Speech_tempo
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
  - https://www.mux.com/articles/merge-audio-and-video-files-with-ffmpeg
  - https://help.epidemicsound.com/hc/en-us/articles/25436460909202-Find-the-right-music
  - https://www.epidemicsound.com/music/themes/songs-by-bpm/
  - https://krotos.studio/blog/sound-to-picture
difficulty: low
detectable_from: transcript+video
---

# Judge a track only against the locked cut, at final level

## What it is
Music fit is a property of the *pair*, not of the track. A track that sounds great alone can fight the delivery, land its downbeats between cuts, and disappear or bully the voice at mix level. So the selection test is mechanical: mux each candidate under the actual cut, at the level it will actually sit at, and judge only that. Auditioning a track in a browser player at full volume is explicitly not the test — it answers a question nobody asked.

The failure this replaces is named in the source: like a track, download it, drop it under the video, discover it does not work, and start the whole hunt again — a serial loop that burns an hour on four candidates. The fix is to make the audition **parallel and cheap**: filter to a shortlist with the three search parameters (BPM, instruments, vibe), then run every shortlisted track against the *same* slice of locked cut, back to back, and choose by comparison rather than by memory.

Three conditions do most of the work. The picture must be **locked** (the cut rhythm is half of what you are testing). The level must be **final** (a track that only works loud is the wrong track). And the audition is **scoped to a representative slice**, never the whole video — that is what makes it fast enough to actually happen.

## When to use it
- **Every time a bed is chosen.** This is the selection workflow, not an optional verification. Run it once per section, immediately after the cut is locked and before any motion work — the music decision constrains where beats and pattern interrupts can land.
- **When two candidates both "sound right"** and the choice has stalled. The comparison against picture resolves it in one pass; listening to them again in isolation never will.
- **When a track that seemed perfect feels wrong once placed.** That is this note's diagnosis, and the fix is to go back and audition a shortlist properly rather than replacing one guess with another.
- **When the section's delivery speed changes** enough that the previous section's bed no longer fits — a new section with faster narration needs its own audition, even if the same track "could" continue.
- Not needed when the design document already names a track that was auditioned for this exact section. Skip it entirely only where there is no bed at all, which is a legitimate choice for a companionship format ([[struct-stimulation-budget]]).

## How to recognise it in a reference video
This is a workflow, so what you detect is its **residue** — a bed locked to the picture rather than laid under it.

- **Downbeat-to-cut alignment.** Detect the cuts, detect the beat grid, and measure the offset. A track chosen by audition shows a meaningful fraction of cuts landing within **±4 frames (±133 ms)** of a beat, especially at section boundaries. A track laid on blind shows a uniform random distribution of offsets.
- **Beat period versus cut density.** Compute the average shot length in the scored section and the track's beat period (`60 / bpm`). In an auditioned edit these are related by a small integer ratio — shot lengths clustering near 1, 2 or 4 beats. Random ratios mean the track was chosen in isolation.
- **BPM against speaking rate.** Measure words per minute from the transcript and estimate the bed's BPM. The two move together in a matched edit; the source's rule is direct — fast talking → high BPM, slow talking → low BPM, and inverting it *"will feel really odd"*. Anchors: ~130–150 wpm → **80–100 BPM**; ~150–170 wpm → **100–120 BPM**; 170+ wpm → **120–140 BPM**. Broadcast delivery runs roughly 168–210 wpm, and the creator's own default is 100–120 BPM for a fast talker. A 190 wpm delivery over a 70 BPM bed is the signature of a track picked from a playlist.
- **Energy alignment.** Plot the track's RMS envelope against the section's structural beats. In an auditioned edit the track's build lands on the section's build, and energy changes coincide with section boundaries. In an un-auditioned one the chorus arrives in the middle of an explanation or a drop lands mid-sentence.
- **Vocals.** Where the host's voice is present, the bed is **instrumental**. Vocal beds appear only in voice-free montage sections — a lead vocal under narration is instantly obvious the moment they play together, so its presence means no audition happened.
- **Level.** Measure the bed's level in the pauses between phrases. A matched mix sits at roughly **−20 to −25 dB** relative to dialogue at **0 to −3 dB**; sound effects at **−12 to −15 dB**.
- **Beat-forward instrumentation under speech.** Percussive/rhythmic beds sit under a voice better than sustained melodic ones. If the bed is melody-forward under dialogue, expect a masking problem.
- **Carve rather than a blanket duck.** Under the voice, a carved bed keeps its low end and its air and only loses the speech bands; a blanket-ducked bed loses everything and audibly pumps.
- **Track changes at section boundaries** rather than at arbitrary times is a secondary tell that the music was designed against the cut.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `shortlist_size` | 6 | 4–10 | Candidates surviving the BPM/instrument/vibe filter. Below 4 you are choosing, not comparing; above ~10 the reel is longer than the video and the decision degrades — pre-filter harder instead. |
| `audition_mode` | one hard slice | one slice \| three windows | **Default: one 30 s slice** at the section's densest passage — a track that survives the hardest 30 seconds survives the rest. Use **three 25 s windows** (hook 0–25 s, densest body, outro) instead when the bed must serve a whole video or the section's character changes across it. |
| `audition_slice` | 30 s | 20–45 s | Single-slice mode. Long enough to hear a phrase, short enough that six candidates is three minutes. |
| `audition_window` | 25 s (750 f) | 20–30 s | Three-window mode, per window per candidate. |
| `windows_per_round` | 3 | 2–4 | Three-window mode only. |
| `slice_selection` | the section's densest passage | — | Fastest delivery, busiest cutting. Pick for difficulty, not for prettiness. |
| `round_budget` | 3 min | 2–5 min | `candidates × windows × window` of actual listening, max. |
| `time_box` | 12 min | 8–20 min | Total wall-clock for one section's music decision. Past this, take the best of the reel and move on. |
| `audition_music_level` | −22 dB (linear 0.079) | −25 to −20 dB | The level it will ship at. **Never audition louder.** |
| `audition_dialogue_level` | −1 dB | 0 to −3 dB | |
| `audition_sfx_level` | −13 dB | −12 to −15 dB | Include the SFX if they already exist. |
| `amix_music_weight` | 0.079 | 0.056–0.100 | Linear equivalent of −22 dB (`10^(−22/20)`). |
| `carve_during_audition` | **off** | off \| tie-break only | Audition **dry** — a carve applied during the audition hides exactly the collision you are testing for. Carve-fixability is a **tie-breaker between two candidates that already passed dry**, never a rescue for one that failed. If a track needs a carve to be intelligible at −22 dB, it is too dense or too vocal: change the instrument filter, do not fix it in the mix. |
| `bpm_window` | ±10 BPM of target | ±5 to ±20 | Around the target derived from speaking rate. |
| `beat_offset_tolerance` | ±4 f (±133 ms) | ±2–6 f | Cut-to-downbeat offset that reads as "locked". |
| `vocals` | `false` | `false` \| `true` | `true` only for voice-free montage. |
| `carve_strength` | 0.25 | 0.15–0.40 | Applied **after** selection. 0.25 ≈ a 6 dB dip in three bands. Past 0.5 it is heard as an effect. |
| `rounds_before_widening` | 2 | 1–3 | If two rounds all fail, change the BPM/instrument filter — never loosen a tolerance and never raise the audition level to flatter a track. |
| `decision_record` | required | — | Write the chosen track id, its BPM, the measured wpm, and the one-line reason into the design document. This is what stops the loop repeating next project. |

## Reproduction prompt

```
Choose the bed for the section {{SEC_IN}}..{{SEC_OUT}} by auditioning against
picture. Never judge a track alone, and do not choose from previews alone.

PRECONDITION: picture is locked. If cuts may still move, STOP - the cut rhythm
is half the test.

1. SCOPE THE SLICE. Inside {{SEC_IN}}..{{SEC_OUT}}, find the 30 seconds with the
   fastest narration and the most cuts. Call it {{AUD_IN}}..{{AUD_OUT}}. Export
   it once and reuse it:
     ffmpeg -ss {{AUD_IN}} -to {{AUD_OUT}} -i {{CUT}} -c copy /tmp/aud/slice.mp4
   Export with dialogue at -1 dB and any existing SFX at -13 dB.
   (If this bed must serve the whole video rather than one section, export three
   25 s windows instead - the hook, the densest body passage, and the outro -
   and run every step below against all three.)

2. FILTER, DON'T BROWSE. Compute the section's speech rate in wpm from the
   transcript. Map it to a BPM target: 130-150 wpm -> 80-100 BPM;
   150-170 -> 100-120; 170+ -> 120-140. Set vocals=false wherever the host's
   voice is present. Name the emotion in one word and prefer a beat-forward
   instrument family (percussion, plucked, arpeggiated) over melody-forward,
   because beats sit under a voice better.

3. FETCH 6 CANDIDATES on those filters and take their low-quality preview URLs.
   Download nothing yet.

4. BUILD ONE REEL, not six sessions. For each candidate, mux the SAME slice
   against it at exactly -22 dB (linear 0.079, `amix` with `normalize=0`), then
   concatenate all six into one file with a 1 s black gap between them,
   labelled.

5. WATCH THE REEL ONCE, START TO FINISH, WITHOUT PAUSING. Score each candidate
   1-5 on, and answer in this order:
   (a) do section boundaries and hard cuts land within +/-4 f of a beat?
   (b) does the track's energy change where the video's section changes, rather
       than mid-sentence?
   (c) at -22 dB is it still doing anything at all?
   (d) is every word still intelligible at -22 dB WITH NO CARVE APPLIED, and
       does it fight the voice's pitch range?
   A candidate must pass (a)-(d) dry. Reject on first failure.

6. WATCH IT A SECOND TIME for the top two only. If they are still tied, and only
   then, ask which one a carve at strength 0.25 serves better. Choose.

7. IF ALL 6 FAIL, change the BPM window or the instrument filter and fetch 6
   more. Never loosen a tolerance and never raise the audition level.

8. RECORD the winner's id, BPM, the measured wpm, and the one-line reason in the
   design document before doing anything else. Then download the winner only.

ACCEPTANCE TEST: at -22 dB under real dialogue the winner is audible in the
pauses and not a competitor during speech, with no ducking applied; and
section-boundary cuts fall within +/-4 f of a beat. Total elapsed time under
12 minutes.
```

## Execution spec

**Epidemic Sound — audition from the previews, not from downloads.** This is the single biggest speed-up available, and it comes straight off the schema: every `Recording` returns an `audioFile` carrying `durationInMilliseconds`, a `waveformUrl`, and **`lqmp3Url` — a low-quality mp3 preview URL**. You never need `DownloadRecording` to build an audition reel; download only the winner, so a rejected candidate costs nothing.

```
SearchRecordings {
  query:  { term: "driving confident tutorial underscore" },
  filter: { bpm: { min: 100, max: 120 },
            vocals: false,
            duration: { min: 90000, max: 300000 },
            moodSlugs: { matchType: ANY, values: ["determined","hopeful"] },
            featuredInstrumentSlugs: { matchType: ANY, values: ["electronic-drums","synthesizer"] } },
  sort:   { by: POPULARITY, order: DESCENDING },
  first:  20
}
# -> for each node: recording.bpm, recording.audioFile.lqmp3Url, recording.title, recording.id
DownloadRecording { id: <winner>, options: { fileType: WAV, stemType: FULL } }
```
Three filter facts worth designing the shortlist around: `vocals` is a plain boolean (the instrumental rule is one flag, not a search term); `bpm` is a real range filter, which is what turns the source's BPM parameter into a query instead of a hope; and `taxonomySlugs` covers genre, decade and world-country. `stems` (drums / bass / melody / instruments) are available on the chosen track and are the honest fix for a bed that masks the voice: drop the melody stem instead of ducking harder. `SearchSimilarToRecording { id }` expands around a near-miss faster than re-searching, and is also the right call for a smooth track-to-track change across a section boundary.

**ffmpeg — the audition rig.** Export the slice once, then batch-mux into one reel:

```bash
mkdir -p /tmp/aud && cd /tmp/aud
ffmpeg -ss 142.0 -to 172.0 -i cut.mp4 -c copy slice.mp4     # export once, reuse

i=0; for url in "${PREVIEWS[@]}"; do
  i=$((i+1)); curl -sL "$url" -o "cand_$i.mp3"
  ffmpeg -y -i slice.mp4 -i "cand_$i.mp3" \
    -filter_complex "[1:a]atrim=0:30,asetpts=N/SR/TB,volume=-22dB,afade=t=in:d=0.5,afade=t=out:st=29:d=1[m];[0:a][m]amix=inputs=2:duration=first:normalize=0:dropout_transition=0[a]" \
    -map 0:v -map "[a]" -c:v copy -shortest "aud_$i.mp4"
done
printf "file '%s'\n" aud_*.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy reel.mp4
```

Two load-bearing details: **`normalize=0`** — `amix` normalises by default, which would pull the dialogue down and invalidate the level you are testing; and **`-c:v copy`**, which keeps each pass to a second or two, which is what makes six candidates cheap. `volume=-22dB` is the same thing as `volume=0.079`. Scratch work goes in `/tmp`, **not** in the mounted vault, which cannot delete files.

**HyperFrames — the audition is not a composition.** Do not build six compositions. Rendering is browser-dependent and, per the environment constraints, cannot happen on this VM at all; an audition that requires a render is an audition that will not happen. Keep the loop in ffmpeg, and touch the composition only once, with the winner. The bed is a clip; the relationship to the voice is a carve, not a duck:

```html
<audio id="vo-1" src=".media/audio/voice/line-01.wav" data-audio-group="voiceover"
       data-start="0.5" data-track-index="10"></audio>
<audio id="music-sec-3" src=".media/audio/bgm/winner.wav"
       data-audio-group="music" data-start="120" data-duration="96"
       data-media-start="4.8" data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```
then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html` (needs `ffmpeg` on PATH and `@hyperframes/core` installed). Carve settings live on the **bed**, never on a voice; `sources` names a **group**, not a list of clip ids (`audio_carve_ungrouped_sources`); `data-fx-carve` is clip-only, never on an `<hf-audio-group>` (`audio_group_carve_attr`). Write the JSON attributes **double-quoted with `&quot;`** or `carve.mjs`'s regex cannot see them and will silently overwrite work.

To stop a bed cleanly at a section boundary, use a `volume` automation lane, not a hard end — and give it an explicit `{"t":0,"v":1}` point, because a lane holds its first value backwards to the clip start:

```
data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:172,&quot;v&quot;:1},{&quot;t&quot;:175,&quot;v&quot;:0}]}]}"
```

Do not also GSAP-tween `volume` on the same clip — the lane wins and the tween is ignored (`audio_volume_double_automation`). If you do want to compare inside a composition, the honest way is two beds on **different track indices** with one at `data-volume="0"` — but note that a `volume` lane beats a static `data-volume`, and a GSAP tween beats both, so keep it to the static attribute while switching.

**Remotion:** swap the `src` on one `<Audio>` over a locked `<Sequence>` set and re-preview. Concept only; not part of this stack.

## Pairs with
[[sfx-ab-audition-candidates]] · [[pace-bpm-matched-music-selection]] · [[pace-speech-rate-to-bpm-map]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-vibe-brief]] · [[sfx-mood-map-per-topic]] · [[sfx-music-rest-windows]] · [[sfx-playback-verification-loop]] · [[sfx-bpm-filter-first]] · [[sfx-name-before-search]] · [[sfx-loud-guitar-minus-30]] · [[pace-cut-on-the-beat]] · [[struct-music-arc-to-narrative-arc]] · [[struct-stimulation-budget]] · [[cut-fade-bookend]] · [[sfx-riser-anticipation-build]] · [[struct-outcome-first-cold-open]] · [[sfx-track-change-at-section-boundary]] · [[sfx-music-ten-point-framework]]

## Failure modes
- **Serial auditioning.** One track at a time, each a full download-place-listen cycle. This is the exact loop the source calls out. Fix: shortlist first, then one reel, then one decision.
- **Auditioning loud.** Everything sounds good at −6 dB. Fix: audition at −22 dB, the level it ships at.
- **Auditioning on an unlocked cut.** You choose a track for a rhythm you are about to change. Fix: lock picture first.
- **Auditioning against the whole video.** Turns a 12-minute decision into an afternoon, and you stop after two candidates. Fix: one 30-second representative slice chosen for difficulty, or three 25-second windows for a whole-video bed.
- **Auditioning with ducking or carve already applied.** Hides exactly the collision you are testing for. Fix: audition dry; carve is a finishing move and at most a tie-breaker, never a rescue.
- **Choosing from the preview alone because it is faster.** The preview is for building the reel, not for making the decision. Fix: the preview goes under picture before anything is chosen.
- **Downloading all six.** Wasteful and slow. Fix: `lqmp3Url` for the reel, `DownloadRecording` for the winner only.
- **Vocal bed under a voice.** Two voices compete and both lose. Fix: `vocals: false`, or use the instrumental/stem version.
- **Inverted BPM.** Slow speech over a fast bed. Fix: compute wpm and pick inside the mapped window; do not trust "it has a nice vibe".
- **Fixing masking with a deeper duck.** A blanket duck costs the bed all of its presence and pumps. Fix: carve at 0.25, or drop the melody stem. If the bed sounds *notched* rather than quieter, the strength is too high.
- **A track chosen for the hook, used for the whole video.** Fix: audition per section; change the bed at section changes and land the change on a beat.
- **Not writing down why.** Guarantees the same hunt next time and next project. Fix: the decision record is part of the move.
- **Known gap:** nothing in this stack validates the mix, and nothing detects a beat grid for you. The downbeat-to-cut offset and the beat-period-versus-shot-length check are arithmetic done by hand from the track's `bpm` field and the cut list (Epidemic returns a `waveformUrl`), or by listening. Reverb/delay tails also make a rendered bed longer than its `data-duration` — expected, not a bug.
