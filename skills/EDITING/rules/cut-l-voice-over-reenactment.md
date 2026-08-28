---
id: cut-l-voice-over-reenactment
title: Hold the voice over an illustrative cutaway — treating the held speech as narration
skill: editing
type: cut
family: audio-led
tags: [skill/editing, type/cut, family/audio-led, layer/dialogue, layer/ambience, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:34"
    quote: "This L cut from Ant-Man continues the character's dialogue while we're visually seeing a reenactment scene, bridging the two together."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:29"
    quote: "You're still hearing a line of dialogue or ambient sound as you're already seeing the new shot."
research_refs:
  - https://en.wikipedia.org/wiki/Split_edit
  - https://www.studiobinder.com/blog/what-is-room-tone/
  - https://www.documentary.org/feature/its-all-mix-secret-sound-design-part-2
  - https://captions.ai/blog/practical-guide-b-roll-video
  - https://www.clevercast.com/bbc-subtitling-guidelines/
  - https://www.provideocoalition.com/room-tone-28-weeks-post-audio-week-2/
difficulty: medium
detectable_from: transcript+video
---

# Hold the voice over an illustrative cutaway — treating the held speech as narration

## What it is
A specialisation of the L cut with its own problem set. The picture leaves the speaker and goes to a **dramatisation of what they are describing** — a re-enactment, a demonstration, a stock illustration, an animated diagram — while their speech continues unbroken. What makes it a distinct move rather than a long L cut is that the voice **changes role at the cut**: a second ago it was in-scene dialogue coming out of a visible mouth; now it is narration laid over a scene it does not belong to. Two things have to be handled that a short L cut never raises: the cutaway has **production sound of its own** that is now competing with a voice that is no longer in that space, and the held voice needs to *sound* like narration rather than like someone shouting from off-screen. The source's framing is exactly right — the voice is what *"bridg[es] the two together"* — and the whole craft is in making that bridge inaudible. This is the same mechanic as B-roll under a talking head; the difference is that a re-enactment has diegetic sound and a wall of B-roll usually does not. Alias: the long form of [[cut-l-audio-trails-picture]]; the pure timing question belongs to that note, the treatment question belongs here.

## When to use it
Trigger: a line of speech **describes an event, a process or a place** that can be shown, and showing it is faster or clearer than saying it. Concretely — a story beat being recounted ("so I opened the laptop and…"), a process being narrated, a claim that needs evidence on screen, an objection whose scenario needs staging, a memory or hypothetical. It is also the correct handling whenever a **cutaway has its own sound** you cannot simply mute (a demonstration where the click, the pour, the keystroke matters). Do **not** use it when the speaker's *face* is the content — a reaction, an emotional beat, a direct challenge to the viewer — or when the cutaway would show something the words do not claim (an illustration that outruns the narration is a credibility problem, not a style one). And do not use it as a synonym for "put B-roll here": if the picture merely decorates, the note you want is [[pace-a-roll-burst-rationing]], where the insert is chosen for variety rather than for illustration.

## How to recognise it in a reference video
- **The transcript test comes first and is nearly decisive.** Align word-level timings against picture cuts. A **sentence that begins on the speaker and ends over different footage, with no change of speaker**, is this move. If the sentence *also* describes what the new footage shows, it is the illustrative case rather than a plain trail.
- **Measure the cutaway's length, not the trail.** In a plain L cut you measure how far the audio outlives the picture; here the audio outlives it for the whole insert, so the number that matters is **insert length**: how long before the picture returns to the speaker or moves on. Bands from creator practice: illustrative cutaway **60–150 f (2–5 s)**, a staged re-enactment beat **90–300 f (3–10 s)**, a narrated process run **300–900 f (10–30 s)**. Past ~900 f the section has become a narrated montage and should be logged as a structural block, not a cut.
- **Return-to-face interval.** In talking-head work the presenter's face typically returns within **240–600 f (8–20 s)**. A reference that never returns has moved to a voiceover format.
- **Listen for the cutaway's own sound and measure how much survives.** Take the RMS of the insert's production sound in the reference against the same material where it plays alone (if available), or judge relatively: illustrative production sound under narration sits **12–20 dB below** the voice. Fully muted inserts are common in creator work and are a legitimate, if flatter, choice; a re-enactment with *no* sound at all under a narrated line is the tell.
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ```
- **Is the held voice dry or in the room?** This is the signal that separates a finished mix from a rough one. A voice functioning as narration is **drier and more present** than in-scene dialogue: no added reverb, high-passed, a small presence lift. Detect it by comparing the reverb tail after a word-final plosive **before** the cut and **during** the insert — if the tail lengthens when the picture changes, the editor left the voice in the cutaway's space by accident. If it *shortens* or stays identical, the voice was treated.
- **Spectral consistency across the boundary.** The held voice should measure the same either side of the picture cut. A step in the 250 Hz–5 kHz band at the cut means two different audio sources are being used for one sentence.
- **Ambience continuity.** Check whether the *speaker's* room tone continues under the insert, the *insert's* ambience takes over, or both are present. The professional arrangement is usually: speaker's bed fades out over 12–24 f, insert's own ambience fades in over 12–24 f, voice unchanged throughout.
- **Density.** Illustrative cutaways as a share of all cuts in an explainer: **0.15–0.40**. In a documentary re-enactment sequence it can exceed 0.6.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `insert_len` | 120 f (4.0 s) | 60–900 f (2–30 s) | Illustrative 60–150 f · re-enactment beat 90–300 f · narrated process 300–900 f. Published cutaway band is 2–5 s. |
| `return_interval` | 360 f (12 s) | 240–600 f (8–20 s) | Max time before the speaker's face returns to picture. |
| `prod_sound_duck` | −15 dB | −12 to −20 dB | The insert's own sound relative to the held voice. `0` = fully muted (acceptable, flatter). |
| `prod_sound_in` | 12 f (0.40 s) | 6–24 f | Fade-up of the insert's ambience/production sound at the cut. |
| `speaker_bed_out` | 18 f (0.60 s) | 12–24 f | Fade-out of the speaker's own room tone under the insert. |
| `voice_level` | 0 to −3 dB | — | Dialogue band. Unchanged across the boundary — this is the invariant. |
| `voice_hpf` | 120 Hz | 90–150 Hz | `highpass`, `q` 0.707, `poles` 2. Removes rumble; the "Remove Rumble" stage. |
| `voice_clarity` | +2.5 dB @3 kHz | +1.5 to +3 dB, Q 1 | The "Add Clarity" job. What makes the held voice read as narration rather than as room sound. |
| `voice_reverb_wet` | 0.0 | 0.0–0.08 | Narration is **dry**. Any wet above ~0.1 puts the voice inside the cutaway's space. |
| `carve_strength` | 0.25 | 0.15–0.35 | Voiceover carve on the music bed. 0.25 = a 6 dB dip in three bands; 0.5 reaches 10 dB and starts being heard as an effect. |
| `music_level` | −22 dB | −20 to −25 dB | Bed under narration. |
| `word_boundary_guard` | 4 f (0.13 s) | 2–8 f | Minimum gap between a word end and any fade start, so no word is clipped. |

## Reproduction prompt

```
Hold the speaker's voice over an illustrative cutaway. Inputs: the A-roll
clip {{A}}, its word-level transcript, the cutaway clip {{B}}, the picture
cut time {{CUT}} (seconds, 30fps), and the sentence being illustrated.

1. THE VOICE IS ONE CLIP. Do not cut the speaker's audio at {{CUT}}. Author
   the narration as a SINGLE continuous audio clip spanning the whole
   sentence, from before {{CUT}} to after the picture returns. Its
   media-start is untouched; only the picture cuts.
2. CUT THE PICTURE at {{CUT}}, chosen from the transcript: {{CUT}} must land
   after the word that names the thing being shown, never before it. The
   viewer hears the noun, then sees it.
3. SET {{LEN}} from the job: illustrative image or clip 120 frames (4.0s);
   staged re-enactment beat 180 frames (6.0s); narrated process run up to
   900 frames (30s). Return to the speaker's face within 360 frames (12s) of
   leaving it unless this section is a declared narrated montage.
4. TREAT THE HELD VOICE AS NARRATION. On the voice clip: highpass at 120 Hz
   (q 0.707, 2 poles), a peaking lift of +2.5 dB at 3 kHz with Q 1, and NO
   reverb at all. Level 0 to -3 dB, identical either side of {{CUT}}. If the
   voice currently carries the speaker's room, it is the wrong source - use
   the same take throughout, not a mix of two.
5. HANDLE THE CUTAWAY'S OWN SOUND. Keep it, do not mute it by reflex: fade
   the insert's production sound / ambience in over 12 frames from {{CUT}},
   held 15 dB under the voice for the whole insert. Simultaneously fade the
   speaker's own room tone out over 18 frames. Where the insert has no sound
   of its own, fetch an ambience that matches its location - silence under a
   narrated re-enactment is the amateur tell.
6. PROTECT INTELLIGIBILITY. Put the narration in an audio group named
   "voiceover" and carve the music bed against that GROUP at strength 0.25.
   Do not duck the bed wholesale; do not put any SFX or bed inside the
   voiceover group.
7. NEVER CLIP A WORD. Every fade start must be at least 4 frames after the
   nearest word-end in the transcript.

ACCEPTANCE TEST: (a) eyes closed, the sentence is one continuous unbroken
delivery with no level step, no tonal step and no reverb change at {{CUT}};
(b) watching, the picture change feels like an illustration arriving, not
like the sound lagging; (c) the insert's own sound is audible but never
competes - a listener asked what they heard should name the voice first;
(d) the speaker returns to picture within 12 seconds; (e) if the bed sounds
notched rather than simply quieter under the voice, lower carve strength.
```

## Execution spec

**HyperFrames (primary).** The whole move is: one long narration `<audio>` at the root, picture clips cut underneath it, and a treated FX chain on the voice. Times are **seconds**.

```html
<!-- ONE narration clip spanning the whole sentence. Treated as narration: HPF + clarity, no reverb. -->
<audio id="vo-story-3" src=".media/audio/voice/story-3.wav"
       data-audio-group="voiceover"
       data-start="88.00" data-duration="14.00" data-track-index="10"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Remove Rumble&quot;,&quot;params&quot;:{&quot;frequency&quot;:120,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
         {&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Add Clarity&quot;,&quot;params&quot;:{&quot;frequency&quot;:3000,&quot;gain&quot;:2.5,&quot;q&quot;:1}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;label&quot;:&quot;Peak Ceiling&quot;,&quot;params&quot;:{&quot;limit&quot;:-1,&quot;attack&quot;:5,&quot;release&quot;:50}}]}"></audio>

<!-- picture: speaker, then the re-enactment, then back. 4.0s insert = 120f @30fps -->
<video id="aroll-3" src="aroll.mp4" muted playsinline class="clip"
       data-start="88.00" data-duration="3.20" data-media-start="512.00" data-track-index="0"></video>
<video id="reenact-3" src="reenact.mp4" muted playsinline class="clip"
       data-start="91.20" data-duration="4.00" data-media-start="6.40" data-track-index="0"></video>
<video id="aroll-3b" src="aroll.mp4" muted playsinline class="clip"
       data-start="95.20" data-duration="6.80" data-media-start="515.20" data-track-index="0"></video>

<!-- the re-enactment's OWN sound, 15 dB under the voice, faded in over 12f (0.40s) -->
<audio id="reenact-3-aud" src="reenact.mp4" data-audio-group="ambience"
       data-start="91.20" data-duration="4.00" data-media-start="6.40" data-track-index="12"
       data-volume="0.18"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.40,&quot;v&quot;:1},{&quot;t&quot;:3.70,&quot;v&quot;:1},{&quot;t&quot;:4.00,&quot;v&quot;:0}]}]}"></audio>

<!-- the speaker's room tone, faded out under the insert over 18f (0.60s) -->
<audio id="room-a" src="assets/ambience/studio-tone.wav" data-audio-group="ambience"
       data-start="88.00" data-duration="14.00" data-track-index="13" data-volume="0.10"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:3.20,&quot;v&quot;:1},{&quot;t&quot;:3.80,&quot;v&quot;:0},{&quot;t&quot;:7.20,&quot;v&quot;:0},{&quot;t&quot;:7.80,&quot;v&quot;:1}]}]}"></audio>

<!-- music bed, carved against the voice GROUP -->
<audio id="bed" src=".media/audio/bgm/bed.mp3" data-audio-group="music"
       data-start="80.00" data-duration="60.00" data-track-index="11" data-volume="0.6"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"></audio>
```
then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`.

Eight contract facts this leans on:
- **The voice is never split**, so the boundary cannot introduce a step — this is the whole trick, and it needs no split-edit machinery at all.
- **`data-automation` `t` is clip-local seconds**, and **a lane holds its first value backwards to the clip start and forwards to the clip end** — hence the explicit `{t:0,v:0}` on the insert's sound and the explicit "no cut" points on the room tone.
- **JSON attributes must be double-quoted with `&quot;`** or `carve.mjs`'s `name="..."` regex cannot see them and *"the carve silently overwrites work it could not see."*
- **Carve against a group, never a list of clip ids** (`audio_carve_ungrouped_sources`), settings live on the **bed** (*"A voice carved against itself is a bug"*), and the carve group must contain **voices only** — an ambience or SFX clip inside `voiceover` poisons the next re-analysis silently.
- **There is no de-esser and no noise removal.** If the held voice has audible hiss, *"a source with audible hiss needs a better source, and saying so is the whole answer."*
- **`reverb` must stay out of the voice chain** for this move; note also that `reverb`/`delay` lengthen the rendered track (`chainTailSeconds`) so a bed with reverb no longer ends exactly at its `data-duration` — expected, not a bug.
- **Overlapping `<audio>` must not share `data-track-index`** (`duplicate_audio_track`), and every `<audio>` needs an `id` or it is never mixed → silent render.
- **`compressor` / `limiter` / `gate` parameters are not automatable at all** (AudioWorklets configured wholesale). To move a limiter's behaviour, automate a `gain` stage around it.

Preset shortcut: `voice-clean` (Remove Rumble → Reduce Mud → Even Out Loudness → Add Clarity → Peak Ceiling) is *"the default answer to 'fix this voiceover'"* and already contains an Add Clarity stage — **do not also add the job**, or you get +5 dB at 3 kHz where +2.5 was meant.

**ffmpeg.** Only for producing assets. Two real uses: extracting the re-enactment's production sound as its own file when the video must be muted for other reasons, and recording/looping matching room tone.
```bash
ffmpeg -i reenact.mp4 -vn -ss 6.4 -t 4.0 -c:a pcm_s16le reenact_prod.wav
# loudness-match the narration before it goes in (two-pass loudnorm, measure then apply)
ffmpeg -i story-3.wav -af loudnorm=I=-16:TP=-1.5:LRA=11:print_format=json -f null -
```
There is **no automatic waveform sync** in this stack: picture and its own sound are aligned by writing the same `data-start` / `data-duration` / `data-media-start` / `data-playback-rate` on both elements.

**Epidemic Sound.** Two fetches this note usually needs:
- The insert's ambience, when the plate is silent: `SearchSoundEffects { query.term: "<location> ambience room tone loop", filter.duration { min: 10000 } }` → `data-audio-group="ambience"`.
- Diegetic detail for the re-enactment so it reads as a place: `SearchSoundEffects { query.term: "keyboard typing close" }` / `"door open close interior"` / `"paper handling foley"` at −12 to −15 dB.
Never place either in the `voiceover` group.

**Remotion:** conceptually one `<Audio>` spanning several picture `<Sequence>`s, with the voice's filter chain applied once; no Remotion runtime exists in this project.

## Pairs with
[[cut-l-audio-trails-picture]] · [[cut-j-audio-leads-picture]] · [[pace-a-roll-burst-rationing]] · [[struct-objection-character-cutaway]] · [[struct-recognisable-clip-evidence]] · [[cut-continuity-pass]] · [[pace-overlay-instead-of-cut]] · [[sfx-vocal-vs-instrumental-bed]] · [[sfx-placement-discipline]] · [[struct-demo-before-label]]

## Failure modes
- **Cutting the voice at the picture cut.** Produces a tonal and level step mid-sentence, which the ear reads as an error even when it cannot name it. Fix: one continuous narration clip, picture cut underneath.
- **Muting the cutaway by reflex.** A staged scene with no sound under a narrated line feels like a slideshow. Fix: keep its production sound 12–20 dB under the voice, or fetch matching ambience.
- **Leaving the cutaway's sound at full level.** Two competing foregrounds; the narration loses. Fix: the voice is the only foreground for the whole insert.
- **Reverb on the held voice.** Puts the narrator inside a room they are not in and the bridge becomes audible. Fix: dry, high-passed, +2.5 dB at 3 kHz.
- **Cutting to the illustration before the word that names it.** The viewer sees the thing, then hears its name, and spends half a second confused. Fix: take the cut point from the transcript, after the noun.
- **The illustration outruns the words.** The re-enactment shows a detail the narration never claims and the video quietly asserts something untrue. Fix: cut the insert to the span of the claim.
- **Insert too long.** Past ~30 s with no return the format has silently changed. Fix: return the face inside 12 s, or declare the section a narrated montage with its own design row.
- **Ducking the whole bed instead of carving it.** *"The reflex is to duck the whole bed, which works and costs the bed all of its presence."* Fix: carve at 0.25 against the voiceover group.
- **Bed sounds notched.** Carve strength too high. Fix: reduce toward 0.15–0.25.
- **Double-applied EQ.** `voice-clean` plus a separate Add Clarity job stacks the same 3 kHz lift twice. Fix: inspect what the preset already contains.
- **Known gap:** the contract provides **no de-essing** and **no noise removal**, and `room-gate` leaves room tone under speech untouched. A held voice with sibilance or hiss cannot be fixed here; the honest fallback for sibilance is a narrow `peaking` cut swept 5–9 kHz, Q 3–4, −3 to −5 dB, always on, at the cost of a little air on every word.
