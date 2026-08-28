---
id: sfx-music-ten-point-framework
title: The ten-point music method — the whole framework, in the order it is taught
skill: sound-design
type: music
family: music-arc
tags: [skill/sound-design, type/music, family/music-arc, layer/music, layer/dialogue, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:14"
    quote: "In this video I'm going to give you 10 points that nobody will tell you even in a paid course."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:38"
    quote: "Every track has a little warm-up at the start, ignore that and start straight from the main beat."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:24"
    quote: "Then stop the first track, put in a riser sound, and start the second track at the end of it."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:28"
    quote: "If there's already a riser at the start of the music, well, that's where beat sync comes in."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:54"
    quote: "You liked a track, downloaded it, put it under the video, but it isn't going with the video, so you go back again."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:07:04"
    quote: "Everything I've told you so far is just my six years of hit and trial experience."
research_refs:
  - https://en.wikipedia.org/wiki/Tempo
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://librosa.org/doc/latest/generated/librosa.beat.beat_track.html
  - skills/SOUND-DESIGN/_kt/editing-kt-3-delta.md
  - _meta/visual-kt-delta.md
difficulty: medium
detectable_from: audio
---

# The ten-point music method — the whole framework, in the order it is taught

## What it is
`editing kt 3` announces a framework at 00:00:14 — *"10 points that nobody will tell you even in a paid course"* — and then delivers it as a sequence rather than as a numbered list. This note is the **reconstructed framework**, in the order the video presents it, with each point pointing at the note that owns it. It exists because the individual craft notes are spread across the library and nothing carried the spine that connects them; and because the improved transcript pass recovered the video's entire back third, which is where the mechanical parts live.

| # | Point | Where it is taught | The note that owns it |
|---|---|---|---|
| 1 | **Your video's emotion and pace** — decide these before opening the library | 00:00:54 | [[sfx-emotion-and-pace-diagnosis]] · [[sfx-emotion-music-lookup-table]] |
| 2 | **BPM** — higher = faster and more energetic; fast talking wants high BPM, slow wants low, *"don't flip the two around"*. Personal default **100–120** | 00:01:07 | [[sfx-bpm-filter-first]] · [[sfx-bpm-perceptual-bands]] · [[pace-speech-rate-to-bpm-map]] |
| 3 | **Instruments** — violin for suspense/tension; beat-led tracks sit best under a voice | 00:02:31 | [[sfx-instrument-filter-search]] · [[sfx-beat-forward-bed-under-voice]] |
| 4 | **Mood and vibe** — *"You don't figure out the vibe, you create the vibe"*. The only point explicitly numbered on screen | 00:03:00 | [[sfx-mood-vibe-filter]] · [[sfx-vibe-brief]] |
| 5 | **Vocals versus instrumental** — vocals where your own voice is absent; instrumental where it is present, because vocals behind a voice *"create a bit of a conflict"* | 00:03:22 | [[sfx-vocal-vs-instrumental-bed]] · [[sfx-vocal-track-for-narration-free-montage]] |
| 6 | **[UNRECOVERABLE]** — 00:04:08–00:04:36, no transcript pass has speech here. The fragment *"I'll have to do SFX"* at 00:04:06 suggests an SFX point | — | — |
| 7 | **Save and like tracks for reuse** — the shortlist is future work already paid for | 00:04:36 | [[sfx-track-shortlist-library]] |
| 8 | **Audio levels** — vocals **−3 to 0 dB**, music **−22 to −25 dB**, loud rock down to **−30 dB**; numbers because *"every device's drivers are different"* | 00:05:13 | [[sfx-layer-volume-targets]] · [[sfx-loud-guitar-minus-30]] · [[sfx-translation-check-devices]] |
| 9 | **Know when to stop the music** — give it rest; kill it for a serious point; always stop on a waveform peak | 00:05:42 | [[sfx-music-rest-windows]] · [[sfx-music-hard-stop]] · [[sfx-silence-as-pattern-interrupt]] |
| 10 | **Transitioning between tracks** — the ladder below | 00:06:09 | [[sfx-track-change-at-section-boundary]] · [[sfx-find-similar-track-handover]] |
| 11 | **Beat sync** — opening beat on the section start, warm-up trimmed, B-rolls cut to the beat | 00:06:28 | [[sfx-beat-aligned-handover]] · [[sfx-cut-on-the-beat]] · [[pace-cut-on-the-beat]] |

**Eleven items are visible, and only item 4 is verifiably numbered on screen.** Either the saved-library step is part of another point, or the list as delivered does not land on exactly ten. Use it as a method, not as a count, and do not quote "the ten points" as if each were labelled.

**Three parts of the framework are new to the library with this pass and deserve stating in full.**

**The track-to-track transition ladder.** Three rungs, taken in order:
1. **Find similar.** Epidemic's own similarity search finds a track with a matching beat or vibe, and the change becomes nearly invisible. Always try this first.
2. **Stop + riser + start on the riser's end.** When the vibe has genuinely changed and no similar track fits: hard-stop track A, bridge the seam with a riser, and start track B at the riser's tail.
3. **Beat sync** takes over **if the incoming track already opens with a riser** — *"if there's already a riser at the start of the music, that's where beat sync comes in."* The caveat is a real rule: **never stack a riser on a track that already builds.** Two things saying "wait for it" reads as mud, and the fix is to use the track's own build and spend your effort on the alignment instead ([[sfx-riser-to-music-drop-backtiming]]).

**The track warm-up rule.** *"Every track has a little warm-up at the start, ignore that and start straight from the main beat."* Library tracks routinely open with 2–8 seconds of pad or ambience before the real downbeat; starting a section on that wastes the boundary. This is the single most actionable item in the video and it is a one-attribute fix — `data-media-start` at the first main beat.

**The audition anti-pattern.** *"You liked a track, downloaded it, put it under the video, but it isn't going with the video, so you go back again."* The download-place-reject-repeat loop is the video's named time sink, and the earlier pass had written the whole window off as banter. Shortlist against the picture first, commit once ([[sfx-music-audition-against-picture]], [[sfx-ab-audition-candidates]]).

## When to use it
- **As the spine for a music pass.** Walk 1 → 11 once per project; the individual notes carry the numbers.
- **As a review checklist on someone else's cut.** Most music problems in real videos are a missing point 8, 9 or 11.
- **When teaching or profiling.** The framework is also the video's structure and a compact description of one creator's method ([[struct-enumerated-promise-and-counter]]).
- **Not as authority.** The creator is explicit: *"just my six years of hit and trial experience."* These are strong heuristics, not broadcast standards, and where they collide with a measured loudness target the measurement wins ([[sfx-translation-check-devices]]).

## How to recognise it in a reference video
- **One bed per section, changing at section boundaries** rather than one track for the whole video — points 9, 10 and 11 working together.
- **The bed's first audible moment is already at full groove.** That is the warm-up trim, and it is a genuine competence tell ([[sfx-beat-aligned-handover]]).
- **Music rest windows exist.** At least one deliberate silence per few minutes, landing on a serious line or an emphasis beat.
- **Track changes are either invisible or bridged.** An invisible change means "find similar"; an audible riser at the seam means rung 2. A raw butt-join with neither is the failure the ladder exists to prevent.
- **Levels:** measure a narrated stretch and a music-only stretch. Voice peaking near −3 to 0 dBFS with the bed 19–25 dB below it is this method, executed.
- **BPM against speech rate.** Words per minute and the bed's BPM should move together; the inversion — fast talk over a slow bed — is diagnosable and specifically warned against.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `bpm_default_band` | 100–120 | 60–160 | The creator's own default, *"because I talk a little fast"*. Single-source: both improved passes lose the number. |
| `voice_level` | −3 to 0 dB | — | **Confirmed twice on screen**, in two different videos — treat as established, not provisional. |
| `music_level` | −22 dB | −25 to −20 dB | Under narration. |
| `rock_level` | −30 dB | −32 to −27 dB | Dense/distorted guitar exception. |
| `warmup_trim` | measured | 0–8 s | `data-media-start` at the incoming track's first main beat. |
| `boundary_tolerance` | ±1 frame | ≤2 f | Track B's downbeat against the section's first frame. Past ~100 ms it reads as a mistake. |
| `riser_bridge_len` | 2.0 s | 1.0–4.0 s | Rung 2 of the ladder. Skip entirely if track B already builds. |
| `rest_windows` | 1 per 2–3 min | — | Deliberate no-bed passages. |
| `stop_on_peak` | yes | — | End the bed on a waveform peak so the stop reads smooth ([[motion-waveform-teaching-overlay]] is the teaching form of the same idea). |
| `shortlist_size` | 5 | 3–8 | Candidates auditioned against picture before one is downloaded. |

## Reproduction prompt

```
Run the music pass for {{PROJECT}} against the eleven-point method.

1. DIAGNOSE emotion and pace per section. Write them down before searching.
2. MEASURE speech rate (words / minute) per section; map to a BPM target.
   Default band 100-120 if unmeasurable.
3. BUILD THE QUERY from the six Epidemic facets - term + bpm + vocals:false
   + duration. Instrument filter where the brief names an emotion an
   instrument carries (violin -> suspense).
4. SHORTLIST 5 candidates and audition them AGAINST THE LOCKED CUT at final
   level. Do not download-place-reject one at a time.
5. PLACE: one bed per section. Set data-media-start to the track's first main
   beat so the warm-up never plays. Land that beat on the section's first
   frame within 1 frame.
6. HANDOVER, in order: (a) try find-similar for the next section's track;
   (b) if the vibe has changed, stop A, bridge with a riser, start B on the
   riser's end; (c) if B already opens with a riser, DO NOT ADD ONE - beat
   sync it instead.
7. REST: plan at least one window with no bed, on a serious line. Stop the
   bed on a waveform peak, not mid-phrase.
8. LEVELS: voice -3 to 0 dB, bed -22 dB, dense-guitar bed -30 dB. Carve the
   bed against the voiceover group rather than lowering the voice.
9. BEAT SYNC the B-roll changes, and as many other cuts as the material
   allows.

ACCEPTANCE TEST: play the whole video once without stopping. You should be
able to say where every section boundary is with your eyes closed, never lose
a word under the bed, and never hear a track start on a wash of pad.
```

## Execution spec

**Epidemic Sound.** Points 2–5 are one facet tree, not four searches ([[sfx-epidemic-facet-query]]): `term` + `bpm{min,max}` + `vocals:false` + `duration{min}` + optional `moodSlugs` / `featuredInstrumentSlugs`. Point 7 is `SearchSimilarToRecording` on saved UUIDs. Rung 1 of the ladder is that same call. Store **UUIDs**, not URLs.

**HyperFrames.** The framework's mechanics are four attributes and one lane:
```html
<!-- section 2's bed: warm-up trimmed, downbeat on the boundary, carved under the voice -->
<audio id="bed-s2" src="assets/audio/bgm/s2.wav" data-audio-group="music"
       data-start="184.00" data-duration="96.00" data-media-start="6.80"
       data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
<!-- rung 2 only: the riser bridging a vibe change. Omit if s2 already builds. -->
<audio id="riser-s2" src="assets/sfx/riser.wav" data-audio-group="sfx"
       data-start="182.00" data-duration="2.00" data-track-index="12" data-volume="0.35"></audio>
```
Two overlapping `<audio>` on one track index raise `duplicate_audio_track`, so a handover with overlap needs separate indices (11/13). Keep the riser in the `sfx` group — a non-voice member inside the carve group poisons the next re-analysis. The dip on the bed under the voice is [[sfx-ducking-keyframed-dip]]; the static floor alone is what the narration teaches.

**ffmpeg — the measurements the framework depends on.**
```bash
# find the incoming track's first main beat (the warm-up to trim)
python -c "import librosa;y,sr=librosa.load('s2.wav');print(librosa.beat.beat_track(y=y,sr=sr,units='time')[1][:8])"
# confirm the bed's level under narration
ffmpeg -i mix.wav -af astats=metadata=1:reset=1 -f null - 2>&1 | grep RMS
# find the peak to stop the bed on
ffmpeg -i s2.wav -af "asetnsamples=n=1600,astats=metadata=1:reset=1" -f null -
```
`Recording.bpm` from the catalogue is ground truth for a librosa tempo estimate, not the other way round.

## Pairs with
[[sfx-track-change-at-section-boundary]] · [[sfx-beat-aligned-handover]] · [[sfx-find-similar-track-handover]] · [[sfx-music-rest-windows]] · [[sfx-layer-volume-targets]] · [[sfx-ducking-keyframed-dip]] · [[sfx-epidemic-facet-query]] · [[sfx-music-audition-against-picture]] · [[sfx-music-primacy-doctrine]] · [[struct-music-arc-to-narrative-arc]] · [[sfx-ten-family-catalogue]]

## Failure modes
- **Quoting it as ten numbered points.** Only point 4 is numbered on screen; one slot is unrecoverable and eleven items are visible. Say "the method", not "point 7".
- **Starting a track on its warm-up.** The section opens on a thin pad and the boundary lands on nothing. One attribute fixes it.
- **Stacking a riser on a track that already builds.** Rung 3 exists precisely to stop this.
- **Running the ladder in the wrong order.** Reaching for the riser first produces an audible seam where find-similar would have produced none.
- **The download-place-reject loop.** The named time sink. Shortlist against picture, commit once.
- **Inverting BPM and speech rate.** Fast talk over a slow bed *"feels really odd"* and is the most common diagnosable music defect.
- **One track for the whole video.** The named mistake behind point 9.
- **Treating the dB numbers as programme loudness.** They are clip-gain peak figures; −3 dB peak on vocals is hot by broadcast norms, so verify against a loudness meter before delivery ([[sfx-translation-check-devices]]).
- **Known gap:** point 6 is genuinely lost — no transcript pass reaches 00:04:08–00:04:36. If a future pass recovers it, this note is where it lands.
