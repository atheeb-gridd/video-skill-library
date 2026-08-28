---
id: sfx-audio-demo-insert
title: Play the sound before you name it — the demo insert and the level it needs
skill: sound-design
type: mix
family: audio-demo
tags: [skill/sound-design, type/mix, family/audio-demo, layer/dialogue, layer/sfx, layer/music, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:01:03"
    quote: "Whoosh."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:01:08"
    quote: "This sound effect is perfect for fast transitions, movements and dynamic reveals."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:01:16"
    quote: "You can tweak this by changing the pitch. If you push the pitch high, the sound effect will feel a bit lighter, but if you take the pitch low, it'll sound like a really heavy, weighty whoosh."
research_refs:
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: audio
---

# Play the sound before you name it — the demo insert and the level it needs

## What it is
In an audio-first teaching segment the sound is played **alone, first**, and the narration only labels it afterwards. The source video does this for every family in its catalogue: the whoosh plays, then *"this sound effect is perfect for fast transitions, movements and dynamic reveals."* The audio demo does the teaching; the words are a caption on an experience the viewer already has. The editorial reason to structure a segment this way is [[struct-demo-before-label]]. **This note is the sound problem that structure creates**, which is a different problem and the one that actually decides whether the segment works.

The problem is a level-tier problem. For the length of the demo, that sound effect is not an effect — it is **the content**. Everywhere else in the mix it belongs on the SFX tier at roughly −12 dB under dialogue ([[sfx-layer-volume-targets]]). Inside a demo window it must be **promoted to the dialogue tier**, because the viewer is being asked to evaluate it, not to feel it. A demo played at accent level is the exact failure the segment was built to avoid: the viewer reaches for the volume, and by the time they have found it the demo is over.

Two measured facts bound the window. Loudness is not judged instantaneously — EBU R 128's **momentary window is 400 ms** — so a demo shorter than about 0.4 s cannot be assessed for level or character at all; it is only a transient. And **forward masking runs roughly 100 ms**, so narration resuming within about three frames of the demo's tail is partly masked by it and the label lands muddy.

**Style.** No `sfx/` style tag: the sound being demonstrated can be any of the three — a diegetic door, a motion whoosh, an aesthetic riser — and what this note governs is the level tier the demo window needs, not the class of sound inside it.

## When to use it
- **Whenever the subject of the video is itself a sound**: an SFX family, a mix move, a filter, a music mood, a voice treatment. The test is blunt — if a one-sentence description tells the viewer nothing that two seconds of listening would, invert the module and demo first.
- **Whenever a claim about sound is being made.** "A low pitch makes it heavier" is unverifiable prose until both versions play back to back ([[sfx-pitch-shift-weight-energy]]).
- **On a before/after mix demonstration**, where the demo is a pair and the level parity between the two halves is the entire argument ([[sfx-layer-stem-demo]]).
- **Not for a sound the viewer is meant to feel rather than notice.** An aesthetic accent demonstrated in isolation sounds silly out of context; demonstrate it *in* a shot instead ([[sfx-felt-not-noticed]], [[sfx-ab-audition-candidates]]).
- **Not under music.** If the bed cannot be cleared for the window, do not run the demo — a sound effect auditioned over a bed is being judged against a variable you did not control.
- **Not more than about four variations in a row.** Past four the viewer has lost the baseline and is comparing candidate three to candidate two rather than to the original.

## How to recognise it in a reference video
- **Transcript ordering.** The label follows the sound. Look for a narration gap immediately preceding a naming clause: *"this sound effect is…"*, *"that's a …"*, *"this is called…"*, *"listen to this"*. In a word-level transcript this is a gap of **0.5–2.5 s** with no words, followed within one second by a definite-article naming phrase.
- **An isolated transient in a narration gap.** On the audio track: speech stops, one non-speech event occupies the gap, speech resumes. Detect it directly:
  ```bash
  ffmpeg -i ref.mp4 -af "silencedetect=noise=-35dB:d=0.35" -f null - 2>&1 | grep silence_
  ffmpeg -ss <gap_start> -t 3 -i ref.mp4 -lavfi showspectrumpic=s=1200x600 demo.png
  ```
  A demo window shows broadband non-harmonic content where speech's formant stack should be.
- **Level parity with the narration around it.** This is the diagnostic that separates a designed demo from a dropped-in file. Measure short-term loudness over the demo window and over the 3 s of narration before it:
  ```bash
  ffmpeg -ss <t0> -t <len> -i ref.mp4 -af ebur128=peak=true -f null - 2>&1 | tail -8
  ```
  A demo within **±3 LU** of the surrounding speech was levelled. A demo 8–15 LU *under* the speech is the SFX tier left un-promoted — the most common fault. A demo 6+ LU *over* is a raw library file dropped in untouched, and it is the reason viewers reach for the volume.
- **The bed is out.** Check the music level inside the window. A properly built demo shows the bed **absent or ≥ 18 dB down**; a bed running at normal level under a sound demo means the segment was not designed, only assembled.
- **Count the repeats and check they match.** Variations played back to back should sit within **1 LU** of each other. If one variation is louder, the "difference" the narration claims is partly a level difference, and the demonstration is rigged — usually unintentionally.
- **Gap discipline.** Measure the silence between the last word and the demo onset, and between the demo tail and the next word. Designed segments show **6–18 frames** on the lead-in and **4–12 frames** on the lead-out. Zero on either side means the demo was butted against speech and the label is masked.
- **Picture behaviour.** Very often the picture holds still or shows a waveform/label card for the window, because there is nothing to look at ([[motion-waveform-teaching-overlay]], [[motion-single-word-topic-card]]). A cut inside a demo window is a strong counter-signal that the sound is incidental, not the subject.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `demo_length` | 1.2 s | 0.4–3.0 s | Below 0.4 s the ear has not reached a momentary loudness judgement. Above 3 s it stops being a demo and becomes a bed. One-shots play whole; loops get 2–3 s. |
| `demo_gain` | 0 dB rel. dialogue (`data-volume="1"`) | −3 to +2 dB | **Promoted to the dialogue tier for this window only.** Not the −12 dB SFX tier. Match by measured loudness, not by fader position. |
| `match_target` | narration short-term LUFS | ±3 LU | Measure the 3 s of narration before the window and normalise the demo file to it. |
| `lead_in_gap` | 12 f (0.40 s) | 6–18 f | Clear air between the last word and the demo onset. Long enough that the demo is not heard as part of the sentence. |
| `lead_out_gap` | 9 f (0.30 s) | 4–12 f | Forward masking runs ~100 ms (3 f), so 4 f is the hard floor. Give the tail room. |
| `variation_count` | 2 | 1–4 | One for a family introduction; two for a contrast pair (fast/long, high/low pitch); three or four only when the axis genuinely has that many stops. |
| `inter_variation_gap` | 12 f (0.40 s) | 9–18 f | Identical between every pair, or the rhythm itself becomes a variable. |
| `variation_level_tolerance` | ±1 LU | ±0.5–±1.5 LU | Across variations. Tighter than the match tolerance, because this is a comparison. |
| `bed_state` | out | out · −18 dB | Prefer out. If the bed must continue for continuity, drop it 18 dB over 6 frames before the lead-in gap. |
| `ambience_state` | keep | keep | The room floor stays ([[sfx-noise-floor-target]]). Only music leaves. |
| `demo_track_index` | 10 (dialogue lane) | 10–11 | The demo is dialogue-tier content for its window; keeping it on the dialogue lane makes that explicit in the timeline. Give it its own index if it overlaps a voice clip. |

## Reproduction prompt

```
Build an audio demo insert for the sound named at {{LABEL_START}}.

1. FIND THE WINDOW. From the word-level transcript, take the last word that ends before the
   naming clause. Call its end {{W_END}}. Take the first word of the naming clause and call
   its start {{W_NEXT}}. If W_NEXT - W_END is less than 0.9 s, open the gap: move the naming
   clause later (or trim narration) until there is room for lead_in + demo + lead_out.

2. PLACE THE DEMO.
      demo_in  = W_END + 12 frames (0.40 s)
      demo_out = demo_in + {{DEMO_LEN=1.2}} s
      W_NEXT  >= demo_out + 9 frames (0.30 s)
   The demo file plays from its own first sample - do NOT peak-align it to a picture event.
   This is the one placement in the library that is aligned to SPEECH, not to a visual frame.

3. LEVEL IT. Measure integrated loudness of the 3 s of narration immediately before W_END.
   Normalise the demo file to that same value. Target is parity, not prominence: the demo
   should sit within 3 LU of the speech around it. Set the clip gain to 0 dB relative to
   dialogue - NOT the -12 dB sound-effects tier.

4. CLEAR THE BED. Write a volume envelope on the music: hold normal until W_END, fall to
   silence over 6 frames, stay out through demo_out + 12 frames, recover over 24 frames.
   Leave the ambience bed running at its normal level throughout.

5. VARIATIONS. For a contrast pair, repeat step 2 with the same demo_in offset arithmetic and
   an identical {{GAP=12}}-frame space between them. Level-match every variation to within
   1 LU of the first. If the point being made is pitch, duration or reverb, derive every
   variation from the SAME source file so the only difference is the parameter under test.

6. PICTURE. Hold the frame, or show a label card, for the whole window. Do not cut inside a
   demo - a cut tells the viewer the sound is incidental.

ACCEPTANCE TEST: play at full speed on laptop speakers with the system volume set for
comfortable narration. The demo must be clearly audible without any volume change, and must
not startle. Short-term loudness inside the demo window must be within 3 LU of the preceding
narration; across variations, within 1 LU of each other. No word is masked at either edge.
```

## Execution spec

**HyperFrames (primary).** The demo is an ordinary `<audio>` clip whose only unusual property is its **tier**: it sits on the dialogue lane at dialogue gain, and the music bed carries an envelope that gets out of its way. All authored time is in seconds; frames are a derived comment.

```html
<!-- narration ends 18.62; demo window 19.02 - 20.22; label resumes 20.52 -->
<audio id="vo-line-07" src=".media/audio/voice/line-07.wav" data-audio-group="voiceover"
       data-start="16.10" data-duration="2.52" data-track-index="10"></audio>

<!-- DEMO: dialogue tier, not SFX tier. Loudness-matched to vo-line-07 offline. -->
<audio id="demo-whoosh-fast" src=".media/audio/sfx/whoosh-fast.demo.wav"
       data-audio-group="voiceover"
       data-start="19.02" data-duration="1.20"
       data-track-index="11" data-volume="1"></audio>

<audio id="vo-line-08" src=".media/audio/voice/line-08.wav" data-audio-group="voiceover"
       data-start="20.52" data-duration="3.40" data-track-index="10"></audio>

<!-- bed out for the window. Bed starts at 4.00, so clip-local t = comp time - 4.00 -->
<audio id="bed" src=".media/audio/bgm/teaching-112.mp3" data-audio-group="music"
       data-start="4.00" data-duration="180.00" data-track-index="12" data-volume="0.079"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},
         {&quot;t&quot;:14.62,&quot;v&quot;:1},
         {&quot;t&quot;:14.82,&quot;v&quot;:0},
         {&quot;t&quot;:16.62,&quot;v&quot;:0},
         {&quot;t&quot;:17.42,&quot;v&quot;:1}]}]}"></audio>
```

Contract facts this depends on, each of which breaks it silently if ignored:
- **Automation `t` is clip-local seconds** — seconds from the bed's own `data-start` — and **a lane holds its first value backwards to the clip start**, so the `{"t":0,"v":1}` point is mandatory or the bed plays the whole video already silenced.
- `v` is 0..1 volume, and it multiplies the clip's `data-volume` baseline. Do not additionally GSAP-tween `volume`: the lane wins and the tween is silently ignored (`audio_volume_double_automation`).
- Write the JSON attributes **double-quoted with `&quot;`**, so `carve.mjs`'s `name="..."` regex can see them.
- **Every `<audio>` needs an `id`** or it is never mixed — an unlabelled demo clip renders as silence with no warning, which in a teaching segment reads as a broken video.
- Putting the demo in `data-audio-group="voiceover"` is deliberate: it is dialogue-tier content, so it should be carved **against**, not carved. Never put a music bed or a genuine SFX accent inside that group — one bed inside the voice group poisons the next carve re-analysis silently.
- **Do not** place a demo with `data-media-start` peak alignment. Every other SFX note in this library aligns a file's loudest sample to a picture frame; a demo is aligned to a **speech gap** and plays from its own head, because its attack is part of what is being taught.
- Two demo clips must not share a `data-track-index` while overlapping (`duplicate_audio_track`); with a 12-frame gap they do not overlap, so one lane is fine.

**Placement spec, in one line.** Demo onset = last word's end **+ 12 frames**; next word's start ≥ demo end **+ 9 frames**; demo gain **0 dB relative to dialogue** (loudness-matched, not fader-matched); music **fully out** from 6 frames before the lead-in gap until 12 frames after the demo tail, recovering over 24 frames; ambience unchanged. No ducking is applied to the demo itself.

**Epidemic Sound.** The demo file is the same asset you would place in a real edit — fetch it once and use the same file for the demonstration and for the eventual placement, so the video teaches the thing it actually uses. `SearchSoundEffects` has **no mood or BPM facet**: only `query.term`, `filter.tagSlugs {matchType, values}`, `filter.duration {min,max}` in **milliseconds**, and `sort`.

```jsonc
// A demo-length whoosh. duration.max keeps one-shots out of the loop/texture results.
SearchSoundEffects {
  query:  { term: "whoosh transition fast short" },
  filter: { duration: { min: 400, max: 2000 },
            tagSlugs: { matchType: "ANY", values: ["whoosh", "transition"] } },
  sort:   { by: "RELEVANCE", order: "DESCENDING" },
  first:  5
}
```
`duration.min: 400` is not cosmetic — it is the 400 ms momentary-loudness window, below which a demo cannot be judged. For a contrast pair, fetch **one** file and derive the second from it (pitch, duration or reverb) rather than fetching two: deriving keeps every variable but the one under test constant ([[sfx-variation-set-generator]], [[sfx-pitch-shift-weight-energy]]). `SearchSimilarToSoundEffect` is for finding a genuinely different candidate, which is a different job ([[sfx-ab-audition-candidates]]).

**ffmpeg — the loudness match, which is the whole technique.**
```bash
# 1. measure the narration immediately before the window
ffmpeg -ss 16.10 -t 2.52 -i .media/audio/voice/line-07.wav -af ebur128 -f null - 2>&1 | tail -8
#    -> read "I: -16.4 LUFS"

# 2. normalise the demo file to that value (two-pass loudnorm is the accurate form)
ffmpeg -i whoosh-fast.wav -af loudnorm=I=-16.4:TP=-1.5:LRA=7:print_format=json -f null -
ffmpeg -i whoosh-fast.wav -af \
  "loudnorm=I=-16.4:TP=-1.5:LRA=7:measured_I=<i>:measured_TP=<tp>:measured_LRA=<lra>:measured_thresh=<th>:offset=<off>:linear=true" \
  whoosh-fast.demo.wav

# 3. derive the contrast pair from the SAME file
ffmpeg -i whoosh-fast.demo.wav -af "asetrate=48000*0.84,aresample=48000,atempo=1.19" whoosh-low.demo.wav   # ~-3 semitones, same length
ffmpeg -i whoosh-fast.demo.wav -af "asetrate=48000*1.19,aresample=48000,atempo=0.84" whoosh-high.demo.wav  # ~+3 semitones

# 4. re-match the derived files - pitch shifting changes loudness
for f in whoosh-low whoosh-high; do ffmpeg -i $f.demo.wav -af ebur128 -f null - 2>&1 | tail -4; done
```
Note `data-playback-rate` in-composition is **pitch-preserved** and normalised to `0.1..5`, so it changes duration only — it is **not** a pitch shifter. Pitch variations must be preprocessed as above.

**Known gap.** Nothing in the stack measures loudness — `lint` reads `data-automation` for exactly two conflicts and nothing validates levels, and `check`'s audits are layout/contrast only. The parity that makes this technique work has no automated gate; it is an ffmpeg measurement the author must run. The device VM here is linux ARM64 without sudo, so the confirmation listen on the rendered mix has to happen on another host.

**Remotion:** conceptually a `<Sequence>` holding an `<Audio>` at full volume with the bed's `volume` callback zeroed across the same range; no Remotion runtime exists in this project.

## Pairs with
- [[struct-demo-before-label]] — the editorial module this note supplies the sound spec for
- [[struct-name-define-demonstrate]] — the ordering this one inverts
- [[sfx-layer-stem-demo]] · [[struct-progressive-layer-demo]] — the cumulative-layer version of the same insert
- [[sfx-demo-clip-loudness-handover]] — the neighbouring case: a third-party clip carrying its own dialogue
- [[sfx-layer-volume-targets]] — the tier the demo is temporarily promoted out of
- [[sfx-ab-audition-candidates]] — the private version of this move, used to choose rather than to teach
- [[sfx-variation-set-generator]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-reverb-size-and-tail]] — the three axes a variation demo runs on
- [[sfx-name-before-search]] · [[sfx-onomatopoeia-to-search-term]] — the naming half of the module
- [[sfx-noise-floor-target]] — why the ambience stays while the music leaves
- [[sfx-music-rest-windows]] — the bed clearance, generalised
- [[motion-waveform-teaching-overlay]] · [[motion-single-word-topic-card]] — what the picture does during the window

## Failure modes
- **Demoing at the SFX tier.** −12 dB under narration is correct for an accent and wrong for content. The viewer hears something happen, cannot evaluate it, and the segment teaches nothing. Promote to dialogue level and measure it.
- **Demoing at raw file level.** The opposite failure and the more expensive one: library files are often mastered hot, the demo blasts, and the viewer's next action is the volume slider — after which every following demo is too quiet.
- **Butting the demo against speech.** With no lead-in gap the sound is heard as part of the sentence; with no lead-out gap forward masking (~100 ms) muddies the label. 12 frames in, 9 frames out.
- **Leaving the bed running.** The demo is now being judged against an uncontrolled variable, and half of what the viewer hears is the music. Clear it.
- **Killing the ambience along with the music.** The window goes dead and reads as a fault. Music leaves; the floor stays.
- **Unmatched variations.** One variation 3 LU louder and the viewer hears "louder", not "heavier" or "lighter". Match to ±1 LU before claiming a difference.
- **Fetching two files for a contrast pair.** Two different files differ in a dozen ways; the demonstration proves nothing about the parameter you named. Derive both from one source.
- **A demo under 0.4 s.** Too short for a loudness judgement, so it registers as a click. Extend it or demo it twice.
- **Cutting inside the window.** A picture cut tells the viewer the sound is background. Hold the frame.
- **Peak-aligning the demo to a visual event.** A reflex carried over from every other placement in this library, and wrong here — the demo's own attack is part of the content, so it plays from its head, in a speech gap.
