---
id: sfx-music-stem-layering
title: Run the music as stems, not as one bounce
skill: sound-design
type: music
family: stems
tags: [skill/sound-design, type/music, family/stems, engine/epidemic, engine/hyperframes, engine/ffmpeg, engine/remotion, layer/music, layer/dialogue, source/editing-kt, source/editing-kt-3, source/sfx-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:14:11"
    quote: "And in case you're wondering why I'm playing four music tracks at once, that's because I downloaded the individual stems of the song. That's another Epidemic Sound feature that's really helpful."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:14:00"
    quote: "I arrange things so the music drops in at exactly that moment. That marks a clear topic change from problem to solution and it also makes the solution segment more exciting."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:03:36"
    quote: "So the rule for this is really simple: wherever your own voice isn't there, using music with vocals works better. But where your own voice is there, putting a vocal track behind it can create a bit of a conflict."
research_refs:
  - https://en.wikipedia.org/wiki/Stem_(audio)
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://en.wikipedia.org/wiki/Low-pass_filter
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: high
detectable_from: audio
---

# Run the music as stems, not as one bounce

## What it is
Instead of one stereo bounce of the track, download the song's component submixes and lay them out as separate timeline tracks. A stem is *"a discrete or grouped collection of audio sources mixed together, usually by one person, to be dealt with downstream as one unit"* — the same convention film post uses as D-M-E (dialogue, music, effects), applied one level down inside the music layer. The source's timeline shows four music tracks running at once for exactly this reason.

What that buys is **arrangement control the composer did not give you**: the drums can arrive at a topic change without changing tracks, the melody can drop out under a dense sentence, and a whole section can run on bass and texture alone. It converts "pick a track and hope its build lands where my video builds" into "build the music around the edit." It also solves the vocals-versus-instrumental conflict in one move — mute the vocal component under narration and restore it over the montage, from the same track.

The cost is real: three or four clips per music cue instead of one, every one of which must stay sample-aligned, and a mix that is easy to unbalance. Reach for stems when the music has to do structural work, not for a bed that just needs to be there.

## When to use it
- **The video has clear sections and one track has to cover them.** Stems let one cue read as three arrangements — intro on texture, body on bass + drums, payoff on everything.
- **At a problem→solution pivot.** The source's own use: the drums or the full arrangement arrive on the frame the topic changes, marking the boundary without a track change.
- **Under dense narration.** Drop to bass and texture only. This is a better answer than ducking the full mix, because the elements that fight speech are the melodic mid-band ones, and stems let you remove exactly those.
- **When you want a vocal track under narration.** Download the components without the vocal and you have a legal, on-brand instrumental version of a track chosen for its vocal energy — then restore the vocal over the narration-free montage.
- **On a beat-driven build.** Add drums, then bass, then melody across three shots for a musical build with no crossfade.
- **Not for a two-minute video with one bed.** One bounce, one carve, done. Stems here are three times the clips for no editorial gain.
- **Not when the track's own arrangement already matches the edit.** If the build lands where your build lands, use it.
- **Not as a substitute for a track change.** A genuinely new section wants a new track ([[sfx-track-change-at-section-boundary]]); stems reshape one track, they do not replace it.

## How to recognise it in a reference video
- **The signature is a change in instrumentation with no change in the underlying material.** The same chord progression, tempo and reverb continue while an instrument family appears or disappears. Contrast that with a track change, which changes everything at once.
- **Look for drums entering or leaving on an exact structural frame** — a cut, a title, the first word of a new section — rather than on a musical bar boundary the composer wrote. Composer builds land on bars; stem edits land on picture.
- **Measure band energy over time rather than overall level.** A stem mute shows as one band dropping while the others hold:
  ```bash
  ffmpeg -i ref.mp4 -vn -ar 48000 -af "highpass=f=20,lowpass=f=120,astats=metadata=1:reset=0.5,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=bass.txt" -f null -
  ffmpeg -i ref.mp4 -vn -ar 48000 -af "highpass=f=800,lowpass=f=5000,astats=metadata=1:reset=0.5,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=mid.txt" -f null -
  ```
  A mid-band RMS drop of **6–15 dB** with the 20–120 Hz band unchanged, held for more than 3 seconds, is a melody stem muted — not a duck, which moves every band together.
- **Under narration, check whether the music's low end survives.** A ducked full mix loses its bass along with everything else; a stem arrangement keeps the bass at level and removes the mids. That asymmetry is the tell, and it is also the reason the technique sounds better.
- **The vocal test.** If a track that has vocals elsewhere in the video plays instrumentally under narration at the same tempo, key and timbre, that is the vocal stem muted.
- **Count the simultaneous music elements** at the busiest point. Three or four distinct, independently-entering families is the stem case.
- **Check alignment.** Stems from one master are sample-locked by construction. If you hear phasing, flamming or a doubled transient at any point, the reference has misaligned stems — a fault, and a useful one to log because it proves stems are in use.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `stems_downloaded` | 3 (`BASS`, `DRUMS`, `INSTRUMENTS`) | 1–3 | **Hard API limit** — see Execution spec. `FULL` is the fourth option and is the whole mix, not a component. |
| `bus_level` | 0.075 (≈−22.5 dB) | 0.056–0.100 (−25 to −20 dB) | Set once on the `music` bus, not per stem. The source's music band. |
| `stem_level` | 1.0 each | 0.5–1.0 | Per-stem trim. Leave at 1.0 unless the component balance is genuinely wrong; the bus fader owns the layer level. |
| `mute_depth` | 0.0 | 0.0–0.25 | A stem "mute". Above 0.25 it reads as a duck, not a removal. |
| `mute_ramp` | 0.25 s | 0.12–0.60 s | Ramp in and out of a mute. Instant is legitimate only on a beat. |
| `entry_quantise` | on the beat | ±2f of a beat | At 100 BPM a beat is 0.6 s = 18f. An arriving stem lands on a beat or on a picture cut, never between. |
| `min_hold` | 3.0 s | 2.0–20 s | A stem in or out for under 2 s reads as a glitch, not an arrangement. |
| `narration_arrangement` | bass + drums | bass · bass+drums · bass+texture | The stems that survive under speech. Melodic mid content is what gets removed. |
| `payoff_arrangement` | all stems | — | Everything up, at the structural beat. |
| `programme_loudness` | −14 LUFS | −16 to −14 LUFS | Check after the arrangement is right. The relative balance comes first, the absolute number second. |
| `stems_per_video` | 1 track as stems | 1–2 | Two stemmed cues in one video is usually one too many to keep track of. |

## Reproduction prompt

```
Build the music cue at {{CUE_IN}}-{{CUE_OUT}} as stems instead of one bounce.

1. CHOOSE THE TRACK FIRST, as normal - BPM against speech rate, mood,
   instrument. Do not choose a track because it has stems.
2. CONFIRM STEM AVAILABILITY. SearchRecordings returns a stems[] array per
   recording; it varies per track (2 to 4 entries observed). If the track
   reports fewer than 2 stems, use one bounce and stop here.
3. DOWNLOAD. Call DownloadRecording three times on the same recording id
   with stemType BASS, then DRUMS, then INSTRUMENTS, fileType WAV. Save as
   assets/bgm/<slug>-bass.wav, -drums.wav, -instruments.wav. Also pull
   stemType FULL as a reference bounce for A/B.
4. PLACE ALL STEMS WITH IDENTICAL TIMING. Every stem gets the same
   data-start = {{CUE_IN}}, the same data-duration, the same
   data-media-start, and the same data-playback-rate. They are sample-
   aligned at the source; writing one number differently is the only way to
   break that. Give each a unique id.
5. BUS THEM. Add <hf-audio-group id="music"> and put data-audio-group="music"
   on all three. Set the bus data-volume to 0.075. Leave each stem's own
   data-volume at 1.0.
6. WRITE THE ARRANGEMENT as one volume automation lane per stem. Lane t is
   CLIP-LOCAL seconds and holds its first value backwards to the clip start,
   so every lane MUST start with an explicit t:0 point. Default plan:
     bass        - 1.0 throughout
     drums       - 0.0 until the structural beat, then 1.0 over 0.25s
     instruments - 1.0 in the intro, 0.0 under dense narration, 1.0 at the
                   payoff
   Quantise every change to within 2 frames of a beat.
7. CARVE ONLY THE MID STEM. Put every voice clip in
   data-audio-group="voiceover", then put data-fx-carve with
   sources ["voiceover"] and strength 0.25 on the INSTRUMENTS clip ONLY.
   Leave bass and drums uncarved - they do not occupy the speech band and
   carving them costs the cue its foundation. Run carve.mjs.
8. VERIFY ALIGNMENT. Sum the three stems and null-test against the FULL
   bounce; the difference should be near-silence apart from any muted
   component. Any comb filtering means a timing number diverged.
9. NORMALISE the finished programme to -14 LUFS.

ACCEPTANCE TEST: play the whole cue once with picture. Every stem entry and
exit must be inaudible AS AN EDIT and audible AS AN ARRANGEMENT - you should
notice the music got bigger, not that a track turned on. Then solo the
dialogue plus music and confirm every word is intelligible without touching
the bus fader.
```

## Execution spec

**Epidemic Sound — read this before planning any stem arrangement, because the API is narrower than the web app.**

`SearchRecordings` reports a `stems[]` array per recording, typed by `StemType`, whose full enum is `DRUMS | BASS | MELODY | INSTRUMENTS | CLEAN_VOCALS | VOCALS`. But `DownloadRecording`'s `options.stemType` enum is only:

```
FULL | BASS | DRUMS | INSTRUMENTS
```

**So `MELODY`, `VOCALS` and `CLEAN_VOCALS` can be searched, listed and auditioned — the search result carries an `lqmp3Url` low-quality preview and a `waveformUrl` for each — but they cannot be downloaded through this route.** Plan on **three downloadable component stems plus the full mix**. `INSTRUMENTS` carries the melodic and harmonic content, so it is the stem that stands in for `MELODY` in every recipe here.

Two consequences worth stating plainly:
- The source's *"four music tracks at once"* is achievable as **BASS + DRUMS + INSTRUMENTS + FULL** only if you use `FULL` as a fourth layer, which double-counts the other three. Through this API the honest arrangement is **three tracks**.
- On a track with vocals, `BASS + DRUMS + INSTRUMENTS` sums to the **instrumental version** — which is exactly the tool for the vocals-under-narration conflict ([[sfx-vocal-vs-instrumental-bed]]). The vocal cannot be re-added from stems; use the `FULL` bounce for the vocal section and cross to the stem arrangement at a section boundary.

Live-verified stem availability, six probes: 4 stems (`DRUMS, MELODY, INSTRUMENTS, BASS`), 4, **2** (`INSTRUMENTS, DRUMS` only), 3 (`INSTRUMENTS, BASS, MELODY`), 4, and 4 on a vocal track (`DRUMS, VOCALS, BASS, INSTRUMENTS`). **Stem coverage is per-track and incomplete — check `stems[]` before committing to an arrangement.**

```
SearchRecordings {
  query:  { term: "<mood or topic>" },
  filter: { bpm: { min: 100, max: 120 }, vocals: false },
  first:  20
}
# inspect node.recording.stems[].type before choosing

DownloadRecording { id: <uuid>, options: { fileType: WAV, stemType: BASS } }
DownloadRecording { id: <uuid>, options: { fileType: WAV, stemType: DRUMS } }
DownloadRecording { id: <uuid>, options: { fileType: WAV, stemType: INSTRUMENTS } }
DownloadRecording { id: <uuid>, options: { fileType: WAV, stemType: FULL } }   # A/B reference
```

`options.bundle` exists as a boolean; where it delivers all stems in one archive it saves three calls, but the per-`stemType` calls above are the shape that is certain to work.

**The adjacent tool, and when to prefer it.** `EditRecording` is the "Create Version" feature: `{ targetDurationMs (max 300000), forceDuration, loopable, preferenceRegions [{startMs,endMs,PREFER|AVOID}], requiredRegionsAtOffsets [{startMs,endMs,offsetMsInEdit}], skipStems, maxResults }` → a `RecordingEditJob`, polled with `PollEditRecordingJob`, downloaded with `DownloadRecordingEdit { jobId, editId }`. Use `EditRecording` when the problem is **length and section order** — "I need this track to be exactly 47 s and to have its drop at 22 s" is `requiredRegionsAtOffsets`, not a stem arrangement. Use stems when the problem is **which instruments are playing at a given moment**. `skipStems: true` makes an edit job faster when you only want the bounce; leave it false if you intend to stem the edited version.

**Hyperframes — the arrangement is one lane per stem, on one bus.**

```html
<hf-audio-group id="music" data-label="Music" data-volume="0.075"></hf-audio-group>

<!-- all three stems share start, duration, media-start and rate. -->
<audio id="bgm-bass" src="assets/bgm/dust-bass.wav"
       data-audio-group="music" data-start="12.0" data-duration="48.0"
       data-media-start="0" data-track-index="14" data-volume="1"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:48,&quot;v&quot;:1}]}]}"></audio>

<!-- drums arrive at composition 24.6s = clip-local t 12.6, on a beat -->
<audio id="bgm-drums" src="assets/bgm/dust-drums.wav"
       data-audio-group="music" data-start="12.0" data-duration="48.0"
       data-media-start="0" data-track-index="15" data-volume="1"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:12.6,&quot;v&quot;:0},{&quot;t&quot;:12.85,&quot;v&quot;:1},{&quot;t&quot;:48,&quot;v&quot;:1}]}]}"></audio>

<!-- melodic content out under the dense narration block, back at the payoff -->
<audio id="bgm-instruments" src="assets/bgm/dust-instruments.wav"
       data-audio-group="music" data-start="12.0" data-duration="48.0"
       data-media-start="0" data-track-index="16" data-volume="1"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:6,&quot;v&quot;:1},{&quot;t&quot;:6.3,&quot;v&quot;:0},{&quot;t&quot;:30,&quot;v&quot;:0},{&quot;t&quot;:30.3,&quot;v&quot;:1},{&quot;t&quot;:48,&quot;v&quot;:1}]}]}"></audio>
```
then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`.

Contract points that decide whether this works:
- **Lane `t` on a clip is clip-local seconds; on an `<hf-audio-group>` bus it is composition time.** Mixing the two up is the single most likely bug in a stem arrangement. Every lane above is clip-local because it lives on a clip.
- **A lane holds its first value backwards to the clip start and its last value forward to the clip end.** `bgm-drums` needs its `t: 0, v: 0` point or the drums are audible before their entry.
- **512 points per lane maximum** — ample, but a per-bar arrangement on a 4-minute cue can approach it.
- **`data-track-index` is display only.** Three stems on three lanes is a readability convention; overlap is fine and layering is CSS `z-index`, which does not apply to audio at all. The one real rule: two `<audio>` sharing a track index *and* overlapping raises `duplicate_audio_track`, so give each stem its own index.
- **`data-fx-carve` is clip-only, never on a bus** (`audio_group_carve_attr`), and its `sources` must name a **group**, not clip ids (`audio_carve_ungrouped_sources`). Carve the INSTRUMENTS stem only. Carve doctrine's own reason applies with unusual force here: *"The reflex is to duck the whole bed, which works and costs the bed all of its presence."* With stems you can take the speech band out of the one stem that has it and leave the other two untouched — the best available answer to music-under-voice in this stack.
- **Never GSAP-tween `volume` on a stem that has a volume lane** (`audio_volume_double_automation` — the lane wins silently), and never tween `volume` on a stem whose `data-volume` you meant to keep (`audio_volume_tween_overrides_gain` — the tween is absolute).
- **`data-volume` maxes at 3.98 (+12 dB).** If three stems at 1.0 on a 0.075 bus is too quiet, raise the bus, not the stems.
- **A different FX chain per stem changes their relative timing.** Biquad filters add group delay near their cutoff and `reverb`/`delay` add `chainTailSeconds` to that stem alone. If a treatment must apply to the music, put it on the **bus** so all three stems get identical processing — *"a compressor cannot ride a sequence it only hears a third of."*
- **In a modular project, audio lives at the host root** so the cue survives scene cuts. Three stems at the root, visual scenes as sub-comps.

**ffmpeg — verification, which is not optional with stems.**
```bash
# 1. null test: do the three stems sum to the full bounce?
ffmpeg -i bass.wav -i drums.wav -i instruments.wav -i full.wav \
  -filter_complex "[0][1][2]amix=inputs=3:normalize=0[sum];[sum][3]amerge=inputs=2,\
  pan=1c|c0=c0-c1,volumedetect" -f null - 2>&1 | grep -E 'mean_volume|max_volume'
# a mean_volume well below -40 dB means aligned; near the stems' own level means not

# 2. per-stem loudness, so the bus number is set from data not taste
for s in bass drums instruments; do ffmpeg -i $s.wav -af ebur128=framelog=verbose -f null - 2>&1 | tail -6; done

# 3. band trace to confirm a mute actually removed the mid band, not everything
ffmpeg -i mix.wav -af "highpass=f=800,lowpass=f=5000,astats=metadata=1:reset=0.5,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
```
Loudness is measured against EBU R 128's windows — momentary **400 ms**, short-term **3 s**, integrated over the programme, gated at **−70 LUFS** absolute and **−10 LU** relative. R 128's own broadcast target is **−23 LUFS at −1 dBTP**; this library targets **−14 LUFS** for social delivery per the contract's `loudnorm` recipe, so use R 128 for the *windows and the gate*, not for the target number.

**Remotion:** three `<Audio>` components in one `<Sequence>` sharing `from` and `startFrom`, each with its own `volume` callback. Concept only; Remotion is not part of this stack.

## Pairs with
[[sfx-music-rest-windows]] · [[sfx-music-hard-stop]] · [[sfx-music-fade-out-section-signal]] · [[sfx-track-change-at-section-boundary]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-vocal-track-for-narration-free-montage]] · [[sfx-bpm-filter-first]] · [[sfx-instrument-filter-search]] · [[sfx-layer-volume-targets]] · [[sfx-five-layers-build-order]] · [[sfx-transient-masked-outpoint]] · [[struct-music-arc-to-narrative-arc]] · [[pace-cut-on-the-beat]] · [[pace-beat-grid-extraction]] · [[sfx-music-audition-against-picture]]

## Failure modes
- **Planning a four-stem arrangement the API cannot deliver.** `MELODY` and `VOCALS` are searchable but not downloadable; only `BASS`, `DRUMS`, `INSTRUMENTS` and `FULL` are. Fix: design for three components, with `INSTRUMENTS` standing in for melody.
- **Assuming every track has stems.** One of six probed tracks had only two. Fix: read `stems[]` before committing; fall back to one bounce.
- **Divergent timing numbers.** A `data-media-start` typed on one stem and not the others produces comb filtering that sounds like a bad reverb, not like a sync error, so it goes undiagnosed. Fix: one timing block, copied verbatim to all stems, plus the null test.
- **A missing `t: 0` point on a lane.** The stem's first value is held backwards to the clip start, so a stem meant to arrive at 12.6 s is audible from the beginning. Fix: every lane opens with `t: 0`.
- **Reading lane `t` as composition time.** Correct on a bus, wrong on a clip. Fix: clip lanes are clip-local; subtract the clip's `data-start`.
- **Carving all three stems.** The bass and drums lose their foundation for no intelligibility gain, and the cue sounds notched. Fix: carve `INSTRUMENTS` only, at `strength: 0.25`.
- **Per-stem FX.** Different filters mean different group delay and different tails, which is a re-introduced alignment error. Fix: treat on the bus.
- **Stem changes between beats.** Reads as a mistake rather than an arrangement. Fix: quantise to within 2 frames of the beat grid.
- **Flickering stems.** A stem in and out every couple of seconds is a nervous mix. Fix: 3 s minimum hold, and no more than one arrangement change per section.
- **Using stems to avoid choosing a track.** Three stems of the wrong song is still the wrong song. Fix: [[sfx-music-audition-against-picture]] first.
- **Known gap:** the contract's `audio-duck.mjs` and the `audio_meta.json` bookkeeping expect a single BGM entry. An Epidemic stem cue produces three files and no equivalent meta record, so drive the carve directly off the composition (`carve.mjs --comp index.html`) rather than through the meta path. Note also that **the vault mount cannot delete files**, so a superseded stem download must be left in place and superseded by name, not removed.
