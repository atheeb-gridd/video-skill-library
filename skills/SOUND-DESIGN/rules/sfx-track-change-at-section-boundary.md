---
id: sfx-track-change-at-section-boundary
title: Change the track when the section changes — choose the handover, land the first beat on the boundary
skill: sound-design
type: music
family: music-arc
tags: [skill/sound-design, type/music, family/music-arc, layer/music, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:09
    quote: "I usually change the music whenever the section changes, and moving from one track to another is a bit tricky."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:15"
    quote: "On Epidemic Sound you can use \"find similar\" to find a track with a similar beat or vibe and drop that in. That makes the music transition feel really smooth."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:24
    quote: "then stop the first track, put in a riser sound, and start the second track at the end of the riser."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:32
    quote: "Whenever you're starting a new section, try to make the opening beat of your music line up with that section."
  - video: assets/videos/editing kt 3.mp4
    timestamp: 00:06:38
    quote: "Every track has a little warm-up at the start — ignore that and start straight from the main beat."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:06:28"
    quote: "If there's already a riser at the start of the music, well, that's where beat sync comes in."
research_refs:
  - https://en.wikipedia.org/wiki/Fade_(audio_engineering)
  - https://en.wikipedia.org/wiki/Audio_to_video_synchronization
  - https://librosa.org/doc/latest/generated/librosa.beat.beat_track.html
  - https://support.epidemicsound.com/s/article/how-can-i-find-the-right-music-on-epidemic-sound
  - https://www.artofcomposing.com/how-to-spot-a-film
  - https://www.heather-fenoughty.com/composing-music/how-i-spot-cues-in-a-film-works-for-any-media-a-quick-and-dirty-guide/
  - https://www.epidemicsound.com/music/moods/
  - https://www.epidemicsound.com/tools/customize/
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects + SearchRecordings (designed--riser shelf and similarity search probed live, 2026-08-28)
difficulty: medium
detectable_from: audio
---

# Change the track when the section changes — choose the handover, land the first beat on the boundary

## What it is
A structural rule with a craft problem attached. **The rule:** music is used as structural signage — one bed per section, and the bed changes where the video's sections change, so the audience feels a chapter turn without being told about it. Music is the cheapest structural signal available — it needs no title card, no "moving on", no on-screen chapter marker — and it is the cheapest retention device available at a boundary, because a boundary is exactly where people leave.

**The craft problem is the handover.** The source is candid: *"moving from one track to another is a bit tricky."* Two beds butted together can sound like a mistake, because the tail of one and the head of the other have different tempo, key, instrumentation and loudness.

Two rules make the difference between a track change that lands and one that sounds like a fault, and they are independent of which handover you choose:

1. **The new track's first main beat sits on the boundary frame** — not its file head. *"Every track has a little warm-up at the start — ignore that and start straight from the main beat."* Almost every library track opens with 1–12 seconds of atmosphere before the groove; starting at 0 gives the new section an ambiguous swell instead of a downbeat, exactly where you need the section to feel like it has begun. Skip it with a media offset; do not cut the file.
2. **The change must be motivated by something visible.** A track change with no picture change reads as a technical fault. Land it on a section's first shot, a title card, or a location change.

**The joins.** There are three families, and choosing between them is a decision the design document should make explicitly:

| Route | Shape | Reads as | Use when |
|---|---|---|---|
| **A. Similar-track handover** | Track 2 is close enough in beat and vibe (Find Similar) that the join is invisible. Two variants — see below. | Continuity with a lift — the video moved on but the world did not change | The section changes but the *emotion* does not. The source's first answer. |
| **B. Silence gap** | Track 1 ends, a deliberate window of no music, Track 2 enters cold on its downbeat. Two variants — hard stop, or fade. | A chapter ending and a new one beginning | A genuine subject change; the strongest structural signal, and it also buys a moment of emphasis for the voice. Detailed in [[sfx-music-fade-out-section-signal]]. |
| **C. Riser bridge** | Track 1 stops dead on a waveform peak, a 1.5–3 s riser fills the gap, Track 2 enters on the riser's last frame | Escalation into the new section | The new section is a payoff, a reveal, or a step up in energy. *"Stop the first track, put in a riser sound, and start the second track at the end of the riser."* |

**Route A comes in two variants, and this is the one point where the library's two traditions genuinely disagree. Read the condition before you pick.**

- **A1 — butt join, no overlap at all.** Track 1 out on the boundary frame, Track 2 in on the same frame, both hard. Requires a **tight** match: BPM delta **≤8** and a shared lead-instrument family. The argument for it is strong: two beds with different tempos and keys overlapping for a second is the single most common way this move gets ruined, and it reads as a **radio mis-cue**, not as a boundary. On this view, a pair that *needs* a crossfade was never similar enough, and the fix is a better search, not a longer fade.
- **A2 — short equal-power crossfade.** A 0.6–0.8 s overlap in which both beds are audible. Tolerates a **looser** match: BPM delta up to **12**. The crossfade is precisely what buys the extra tolerance — it papers over the residual tempo and key difference that a butt join would expose.

**Prefer A1.** Tighten the Find Similar result until a butt join works; it is cleaner, it cannot beat against itself, and it costs nothing. Reach for A2 only when the catalogue will not yield a ≤8 BPM sibling in the right mood and the alternative is a jarring butt join — and then keep the overlap under 1.5 s (hard ceiling 2.0 s, the transition registry's own `max_duration_s`) and use an **equal-power** shape, because an equal-gain/linear fade dips about 3 dB in the middle and the join sags. Anything longer than ~1.5 s and the viewer hears two songs, which is worse than either.

Route B also comes in two variants: **B1 — hard stop** on a transient, then the gap (crisper, and the better partner for a strong chapter break); **B2 — a 2.5–3 s logarithmic fade** down, then the gap (gentler, and the right choice when the outgoing bed has no clean transient to land on).

### The handover as a three-rung ladder, and the one thing that stops it
The improved transcript pass makes the handover a **ranked procedure** rather than two alternatives, and adds the caveat that governs it:

1. **Find similar.** Epidemic's similarity search on the outgoing track's id gives a matching beat and vibe, and the change becomes nearly invisible. Always attempt this first.
2. **Stop + riser + start on the riser's end.** *"Then stop the first track, put in a riser sound, and start the second track at the end of it."* The fallback when the vibe has genuinely changed and no similar track fits.
3. **Beat sync**, which is where rung 2 hands over: *"if there's already a riser at the start of the music, well, that's where beat sync comes in."*

**The caveat is the load-bearing part: never stack a riser on a track that already opens with one.** Most library tracks with a build already say "wait for it"; adding a second riser on top produces two overlapping crescendos and reads as mud rather than as anticipation. When the incoming track builds by itself, the work moves from *bridging* to *aligning* — trim to its first main beat and land that beat on the section boundary ([[sfx-riser-to-music-drop-backtiming]], [[sfx-beat-aligned-handover]]).

Diagnosing which rung a reference used takes one listen: an inaudible change is rung 1, an audible riser at the seam is rung 2, and a bare butt-join with neither is the failure the ladder exists to prevent. The whole method this sits inside is [[sfx-music-ten-point-framework]].

## When to use it
On every video with more than one section and any music at all. It is a companion to the mood map ([[sfx-mood-map-per-topic]]): the map decides *what* each section's bed should be, this note decides *how* it arrives.

Change the track at a section boundary when **any** of these is true: the topic changes; the emotional register changes; the format changes (talking head → demo, list item → list item, story → lesson); a new chapter title appears on screen; or the mood map assigns a different mood on either side. Derive the boundary list from the script or transcript, not by ear.

- **When the emotion of the content changes**, even mid-section: that is the strongest case for route B or C, and for a different `moodSlugs` filter rather than Find Similar.
- Do **not** change the track for its own sake mid-section — a bed change with no structural reason reads as restlessness and trains the audience to stop reading music as a signal. **Not on every B-roll change or every 30 seconds:** one bed per section, roughly **3–6 changes per 10 minutes**. More than that and the signal stops carrying information — the same habituation problem as effect overload.
- Do not change on **every** boundary in a fast list format: in a ten-item video, changing ten times is noise; change at the act boundaries and mark the individual items with an SFX or a graphic ([[motion-list-item-marker-card]]).
- **Not where the music should simply stop.** A serious line wants the bed gone, not replaced; a rest at the boundary is stronger than either bed ([[sfx-music-rest-windows]], [[sfx-music-hard-stop]]).
- **Not as a substitute for a dynamic change inside one track.** If the same bed can drop into its own chorus at the turn, that is stronger and cheaper ([[sfx-music-drop-on-structure-turn]], [[sfx-music-stem-layering]]).

## How to recognise it in a reference video
- **Derive candidate boundaries from the transcript first, independently of the audio.** Log every enumerator ("second thing", "point three", "next"), contrast marker ("but here's the problem", "so what actually works"), meta-marker ("before we get into that"), explicit chapter language ("now let's talk about"), and every on-screen title card or chapter graphic. This gives an expected boundary list to test against.
- **Then locate the actual cue changes.** A frame-aligned RMS trace finds the level steps; a spectrogram or mel-band comparison distinguishes a genuine *track* change (instrumentation and tempo change together) from a level move or a drop within one track. Bed-only energy is easiest to track in the low band:
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
  ffmpeg -i ref.wav -af "lowpass=f=250,astats=metadata=1:reset=2,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null -
  ffmpeg -i ref.wav -af "silencedetect=n=-45dB:d=0.5" -f null -
  ```
  `n=1600` at 48 kHz is exactly one frame at 30 fps, so `pts_time` values are frame-aligned. A track change shows as either a step change in bed character (route A), a decay followed by a gap (route B), or a rising sweep terminating in a new downbeat (route C).
- **Measure two different offsets, and do not conflate them — this is the diagnostic pair.**
  - **`downbeat_alignment`** — distance from the new bed's **first main beat** to the section boundary. This should be **0 to ±2 frames**, essentially always, well inside the ±22 ms band film practice treats as synchronous. A downbeat consistently landing 6–20 frames off the cut means the editor dropped the bed in by hand and did not nudge it.
  - **`change_start_offset`** — distance from where the *handover begins* to the boundary. This is a style choice and has three signatures: **−6 to −24 f (music leads)**, the bed arriving before the picture and *motivating* the transition, the audio equivalent of a J cut; **0 ± 2 f (locked)**, chapter-marker intent, everything on one frame; **+6 to +30 f (music trails)**, the section starting dry and the bed joining it. In a butt join the two offsets coincide; in a crossfade they do not. Log which the reference uses, and whether it is consistent.
- **Classify the handover type.** Overlap present and both beds audible for ≥0.4 s → route A2. Both beds changing on one frame with no overlap → A1. A rising broadband sweep filling a gap → C. A measurable window of no music (>0.5 s) → B. Anything else — two dissimilar beds hard-butted with no overlap, no riser and no gap — is the amateur version, and worth logging as such.
- **Check the incoming bed's entry point.** Does the new track enter with a beat and full instrumentation, or with an atmospheric swell that resolves into a beat 2–8 s later? The latter means the file head was used — the most common tell of an unedited needle-drop.
- **Check the outgoing bed's exit point.** Landing on a transient or a bar line (the source's "stop it on a peak in the waveform") versus stopping mid-phrase. A mid-phrase stop with no gap is audible as a truncation.
- **Tempo and instrumentation delta across the join.** Extract both BPMs. A butt join (A1) normally sits within **±8 BPM** and shares its lead instrument family; a crossfade (A2) within **±12 BPM**. Beyond 12 the overlap beats against itself and the handover should have been a riser or a gap.
- **Count the changes** and compare with the video's section count from the transcript. **3–6 per 10 minutes** is structural; equal counts to sections means structural use. More than ~8 and the music is following novelty, not structure. Fewer than 2 in a long-form video means the bed is doing no structural work at all.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `handover` | A1 (similar, butt join) | A1 \| A2 \| B1 \| B2 \| C | Chosen by BPM/mood delta — see the prompt's decision rule. |
| `downbeat_alignment` | 0f | 0 to ±2f | **The hard rule.** The new bed's first main beat lands on the section's first frame. Film sync practice: ±22 ms. |
| `change_start_offset` | −12f (−0.40 s) | −24 to +30f | Style, not correctness. Negative = the handover begins before the picture boundary so the bed motivates it. Use `0 ± 2f` for a deliberate chapter marker. **Contested:** one tradition treats the whole change as a unit and leads it by at most 6f, beyond which it reads as a mistimed cut. That reading is right for a butt join, where the two offsets are the same number; the wider window applies to crossfade and fade handovers, where the downbeat can still land on the boundary. |
| `entry_style` | main beat, not file head | — | Trim the warm-up with `data-media-start`. |
| `warmup_trim` (`b_media_start`) | measured per track | 1–16 s | Offset from file head to the first main beat. **Always measured, never zero.** |
| `A1_overlap` | 0f | 0f only | Butt join. Requires the tight similarity below. |
| `A1_bpm_delta` | ≤8 BPM | 0–8 BPM | Beyond this, Find Similar has not actually found a similar track. |
| `A2_overlap` | 0.7 s (21f) | 0.4–1.5 s | Both beds audible. Hard ceiling 2.0 s — the transition registry's own `max_duration_s`. |
| `A2_bpm_delta` | ≤12 BPM | 8–12 BPM | The band where a crossfade earns its place. Beyond 12, use B or C. |
| `xfade_shape` | equal-power | equal-power only | Equal-power (≈`sine.inOut`) avoids the ~3 dB dip in the middle of a linear crossfade. |
| `outgoing_out_point` | on a transient | transient \| bar line | Never mid-sustain. The source's "stop it on a peak in the waveform". |
| `B1_declick` | 4f (0.13 s) | 2–6f | A de-click ramp at a hard stop, not a fade-out. |
| `B2_fade` | 3.0 s | 2.0–6.0 s | Logarithmic, equal-dB steps. |
| `gap_len` | 1.2 s (36f) | 0.5–2.5 s | Real silence in the music layer, with the ambience bed still running. Under 0.5 s reads as a dropout, over ~2.5 s as an act break. |
| `C_riser_len` | 2.0 s | 1.5–3.0 s | The riser's **end** lands on the boundary frame, not after it. |
| `C_riser_gain` | −12 dB (`0.251`) | −15 to −9 dB | Effect level, not music level. |
| `mood_change` | — | same \| adjacent \| opposite | Same/adjacent mood → route A. Opposite → B or C. |
| `changes_per_10min` | 4 | 3–6 (tolerable to 8) | Track changes across the video. Above 6 the signal stops meaning anything. |
| `bed_level` | −22 dB (`data-volume` 0.079) | −25 to −20 dB | **Both beds at the same authored level**, or the change reads as a volume error. −30 dB for loud guitar-led tracks. |
| `entry_fade_in` | 6f (0.2 s) | 0–12f | On the incoming bed for route A2. `0` (5 ms declick only) when it enters hard on a downbeat after a gap or a butt join. |
| `level_match` | ≤1 LU | 0–2 LU | Integrated-loudness difference between the two beds across the join. Loudness-match **before** placing, not after. |
| `carve_strength` | 0.25 | 0.15–0.35 | Each bed carries its own carve against the voiceover group. |

## Reproduction prompt

```
Build the music handover at the section boundary {{BOUNDARY}} (composition
seconds, 30fps) from bed {{A}} to bed {{B}}.

1. CONFIRM THE BOUNDARY IS REAL AND VISIBLE. It must coincide with a topic
   change, a format change, a register change or an on-screen chapter marker in
   the transcript, AND there must be a picture event within 1 frame of
   {{BOUNDARY}}: a cut to the section's first shot, a title card, or a location
   change. If either is missing, do not change the track here - find the real
   boundary, or make the picture change.

2. MEASURE B's FIRST MAIN BEAT. Open B's waveform, find where the full groove
   starts (not the intro wash, not a riser), and record that offset as
   {{WARMUP}} in seconds. If it is 0, check again - almost no library track
   starts on the beat.

3. CHOOSE THE ROUTE. Compute |BPM(A) - BPM(B)| and compare the two moods.
   - delta <= 8 AND same/adjacent mood AND shared lead instrument family
     -> ROUTE A1: butt join. No overlap, no crossfade. PREFERRED.
   - delta 9-12 AND same/adjacent mood, and no closer sibling exists
     -> ROUTE A2: 0.7s equal-power crossfade. Use only because A1 would be
        jarring; a pair needing more than 1.5s was not similar enough - go back
        and search again rather than lengthening the fade.
   - moods opposite, or delta > 12, or the boundary should be FELT as a chapter,
     or the first line of the new section deserves emphasis
     -> ROUTE B: gap. B1 (hard stop on a transient) if A has a clean transient
        to land on; B2 (3.0s log fade) if it does not.
   - section B is a payoff, a reveal, or a step up in energy
     -> ROUTE C: hard stop + riser bridge.

4. PLACE THE CHANGE. Set B's data-media-start = {{WARMUP}} so that B's DOWNBEAT
   lands within 2 frames of {{BOUNDARY}}. That is the non-negotiable number.
   Then choose where the handover BEGINS: default -12 frames (the bed motivates
   the picture) for A2/B/C; for A1 the two are the same frame, so keep the whole
   change within 6 frames of the boundary. Never place the change more than
   30 frames after the visual boundary.

5. BUILD THE JOIN. Verify the arithmetic by printing the four numbers:
   A.start + A.duration, B.start, riser.start + riser.duration, {{BOUNDARY}}.
   They must agree.
   ROUTE A1: A's data-duration ends exactly at B's data-start. No overlap. Add a
     5 ms declick ramp at the end of A and the start of B via volume lanes.
   ROUTE A2: overlap 0.7s with equal-power lanes on both beds. A's out-ramp and
     B's in-ramp are mirror curves, not linear.
   ROUTE B1: A ends dead on a waveform peak at {{BOUNDARY}} - gap_len, with a
     4-frame declick. B data-start = {{BOUNDARY}}, hard in.
   ROUTE B2: A fades over 3.0s ending at {{BOUNDARY}} - 1.2s using equal-dB
     breakpoints (1.0, 0.178, 0.0316, 0.0056, 0). B data-start = {{BOUNDARY}}.
   ROUTE B (either): the gap must be REAL silence in the music layer, with the
     ambience bed still running underneath.
   ROUTE C: A ends dead on a waveform peak at {{BOUNDARY}} - riser_length; fetch
     a 1.5-3.0s riser and place it so its LAST frame is {{BOUNDARY}} - 0.033s
     (data-start = {{BOUNDARY}} - riser_length); B data-start = {{BOUNDARY}}.
     Do not also crossfade.

6. LOUDNESS-MATCH A and B to within 1 LU BEFORE placing them, so the join needs
   no gain correction. Set both beds to the same data-volume (0.079 = -22 dB).

7. RE-CARVE. Give EACH bed its own data-fx-carve against the voiceover group at
   strength 0.25 - do not carry A's settings forward. Two beds, two carves.

8. COUNT the track changes in the whole video. If there are more than 6 per
   10 minutes, merge two adjacent sections onto one bed.

ACCEPTANCE TEST.
(a) Play from 6s before to 6s after {{BOUNDARY}} once, watching picture. The
    change must feel CAUSED by the picture, not noticed on its own.
(b) Play the same window with your eyes closed: you should hear a change of
    chapter, not a change of file.
(c) B's first two seconds must be a BEAT, not a swell - full instrumentation on
    bar one.
(d) Solo the music and listen for any moment where two different beds are
    clearly audible. For A1/B/C there must be none. For A2 it must not exceed
    1.5s - if it does, re-cut to a butt join.
(e) The level does not dip or jump across the join.
(f) Count changes across the whole video: 3-6 per 10 minutes.
```

## Execution spec

**HyperFrames — two bed clips, each carved, both trimmed past the warm-up.** The half-open window `[start, start + duration)` gives the butt join for free: *"Two clips can therefore be authored back to back (`b.start === a.start + a.duration`) with no overlapping frame."*

```html
<!-- ROUTE A1: butt join at 214.80s. Same track index is correct and self-documenting,
     because these clips do not overlap. -->
<audio id="bgm-sec-3" src=".media/audio/bgm/bed-c.wav" data-audio-group="music"
       data-start="160.00" data-duration="54.80" data-media-start="6.40"
       data-track-index="12" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.005,&quot;v&quot;:1},{&quot;t&quot;:54.795,&quot;v&quot;:1},{&quot;t&quot;:54.8,&quot;v&quot;:0}]}]}"></audio>

<audio id="bgm-sec-4" src=".media/audio/bgm/bed-d.wav" data-audio-group="music"
       data-start="214.80" data-duration="61.00" data-media-start="9.20"
       data-track-index="12" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.005,&quot;v&quot;:1}]}]}"></audio>

<!-- ROUTE C addition: riser ending one frame before the boundary -->
<audio id="sfx-riser-s4" src=".media/audio/sfx/riser-2s.wav" data-audio-group="sfx"
       data-start="212.80" data-duration="2.00" data-track-index="15" data-volume="0.251"></audio>

<!-- ROUTE A2 variant: 0.7s equal-power overlap. NOTE the different track indices -
     overlapping clips on one index raise duplicate_audio_track. -->
<audio id="bgm-sec-3-x" src=".media/audio/bgm/bed-c.wav" data-audio-group="music"
       data-start="160.00" data-duration="55.50" data-media-start="6.40"
       data-track-index="12" data-volume="0.079"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.005,&quot;v&quot;:1},{&quot;t&quot;:54.80,&quot;v&quot;:1},{&quot;t&quot;:55.15,&quot;v&quot;:0.707},{&quot;t&quot;:55.50,&quot;v&quot;:0}]}]}"></audio>

<audio id="bgm-sec-4-x" src=".media/audio/bgm/bed-d.wav" data-audio-group="music"
       data-start="214.80" data-duration="61.00" data-media-start="9.20"
       data-track-index="13" data-volume="0.079"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.35,&quot;v&quot;:0.707},{&quot;t&quot;:0.70,&quot;v&quot;:1}]}]}"></audio>
```

The `0.707` midpoints are what make the A2 crossfade **equal-power** rather than equal-gain: two lanes each at −3 dB at the midpoint sum to unity, whereas two lanes each at 0.5 sum to a ~3 dB hole. This is the whole reason the shape matters.

Contract points that decide the result:
- **`data-media-start` is the warm-up trim** — in seconds, into the source, no new file needed: *"a clip plays a sub-window via `data-media-start` + `data-duration` … Only cut a physical file when exporting/assembling outside the composition."* `data-media-start="9.20"` on `bgm-sec-4` is the measured offset to its first main beat.
- **Lane `t` is clip-local**, so a bed starting at 160.00 has its out-ramp at `t: 54.795`, not `214.795`. On an `<hf-audio-group>` bus, by contrast, `t` is **composition** time — which is the one reason to make a single-member bus.
- **A lane holds its first value backwards to the clip start** and its last value forward to the end, so bed B's `t:0, v:0` declick pair is a genuine 5 ms fade-in and not a permanent mute, and an incoming lane without an explicit `t:0` point starts at full level.
- **Two `<audio>` elements sharing a `data-track-index` *and* overlapping in time raise `duplicate_audio_track`.** Route A1/B/C do not overlap, so one index is correct; route A2 does, so it needs two.
- **`data-volume="0.079"` ≈ −22 dB** (`10^(-22/20) ≈ 0.079`); the attribute is linear gain with `1` = 0 dB and a ceiling of `3.98` (+12 dB).
- **Do not also GSAP-tween `volume`** on either element — the lane wins and the tween is silently ignored (`audio_volume_double_automation`); and an authored `data-volume` on a tweened track is replaced outright, not scaled (`audio_volume_tween_overrides_gain`).
- **Each bed carries its own `data-fx-carve`**; settings live on the bed, never on a voice; `sources` names a **group** not clip ids (`audio_carve_ungrouped_sources`); `data-fx-carve` is clip-only, never on an `<hf-audio-group>` (`audio_group_carve_attr`); nodes tagged `fromCarve` are carve-owned and must never be written by hand. Then re-run it so the new bed gets its own analysis:
  ```bash
  node <SKILL_DIR>/scripts/carve.mjs --comp index.html
  ```
  If the bed sounds *notched* rather than quieter under the voice, `strength` is too high. The carve group must contain voices only — an SFX or bed clip inside it *"poisons the next re-analysis silently."*
- **Escaping matters:** write these JSON attributes **double-quoted with `&quot;`** — `scripts/carve.mjs` finds them with a `name="..."` regex, and a single-quoted attribute is invisible to it, so the carve silently overwrites work it could not see.
- **Relative timing can express the join** (`data-start="bgm-sec-3"` = "start when that clip ends") but has four silent-zero failure modes: spaces around `+`/`-` are required, an unresolved id resolves to 0, a target with no resolvable duration lands on the target's **start**, and a cycle resolves to 0. For a boundary this important, write the absolute number and check it.
- **If a bed carries `reverb` or `delay`**, `chainTailSeconds` makes it ring past its `data-duration` — which eats route B's silence window. Expected behaviour, not a bug; shorten the fade or widen the gap.

**Epidemic Sound — the routes map to specific tools.**

```
# ROUTE A - the similarity join (the source's own answer)
SearchSimilarToRecording { id: <bed-C recording uuid>, limit: 20 }
# then filter to the new section's mood and to |BPM - BPM(A)| <= 8 for a butt
# join, <= 12 if you are settling for a crossfade.

# ROUTE C - the riser bridge. Live-verified 2026-08-28: the shelf is `designed--riser`
SearchSoundEffects {
  filter: { tagSlugs: { matchType: ALL, values: ["designed--riser"] },
            duration: { min: 1500, max: 3000 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }
# top hits: "Designed, Riser, Transition, Fast, Short 02" (3.59 s),
#           "Designed, Riser, Transition, Fast, Short, Suspense" (4.38 s)
# the term search "riser build tension" returns 4288 files; the tag filter is the reliable route.

# NEW SECTION, NEW EMOTION - a fresh search, not a similar one
SearchRecordings {
  filter: { moodSlugs: { matchType: ANY, values: ["epic"] },
            bpm: { min: 106, max: 126 }, vocals: false,
            duration: { min: 120000 } },
  sort: { by: POPULARITY, order: DESCENDING }, first: 20 }
```

Two catalogue features remove most of the pain here. Every `Recording` exposes `stems: [DRUMS, BASS, MELODY, INSTRUMENTS, …]`, so route A can be softened by entering section B on stems only — a genuinely better answer than a crossfade when A1 is too abrupt. And `EditRecording` (Create Version / customize) will build a version of a track that genuinely *ends* at your section length and *starts* on its main beat — `targetDurationMs`, `forceDuration`, plus `preferenceRegions` with `AVOID` over the warm-up, then `PollEditRecordingJob` and `DownloadRecordingEdit`. A composed ending beats a fade over an arbitrary passage; see [[sfx-music-fade-out-section-signal]] for the full call shape. `DownloadRecording` into `.media/audio/bgm/` or `assets/bgm/`, optionally ledger with `resolve.mjs --from <file> --type bgm --project .`

**ffmpeg — measurement, warm-up detection, loudness matching, and export-only bakes.**
```bash
# find the first main beat (warm-up length): the first sustained low-band transient
ffmpeg -i bed-d.wav -af "lowpass=f=200,astats=metadata=1:reset=0.25,ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null -
# structural gaps in the existing mix
ffmpeg -i ref.wav -af "silencedetect=n=-45dB:d=0.5" -f null -
# loudness-match the two beds before placing them, so the join needs no correction
ffmpeg -i bed_a.mp3 -af loudnorm=I=-16:TP=-1.5:LRA=11:print_format=json -f null -   # measure each
ffmpeg -i bed_b.mp3 -af loudnorm=I=-16:TP=-1.5:LRA=11:measured_I=…:measured_TP=…:\
measured_LRA=…:measured_thresh=…:offset=…:linear=true bed_b.matched.wav              # apply
# baked butt join (export only) - concat, never acrossfade
printf "file '%s'\n" bedC.wav bedD.wav > list.txt && ffmpeg -f concat -safe 0 -i list.txt -c copy beds.wav
```
Do **not** bake a crossfade with `acrossfade` unless the beds are leaving the pipeline — declare it with lanes. If you do bake one, `-filter_complex "[0][1]acrossfade=d=0.7:c1=tri:c2=tri"` (the `tri` curves are the equal-power pair). For a real beat grid rather than a peak hunt, use the beat-tracking route in [[pace-beat-grid-extraction]]; `librosa.beat.beat_track` returns tempo plus beat frames, and the first beat time is exactly the warm-up trim.

**Remotion:** two `<Audio>` elements on adjacent frame ranges with `startFrom` set to the warm-up offset, and `volume` callbacks if a crossfade is genuinely needed. Concept only; no Remotion runtime in this project.

## Pairs with
[[sfx-music-fade-out-section-signal]] · [[sfx-music-hard-stop]] · [[sfx-music-rest-windows]] · [[sfx-music-drop-on-structure-turn]] · [[sfx-music-stem-layering]] · [[sfx-riser-anticipation-build]] · [[sfx-instrument-filter-search]] · [[sfx-bpm-filter-first]] · [[sfx-hard-cut-audio-seam]] · [[pace-beat-grid-extraction]] · [[pace-cut-on-the-beat]] · [[struct-music-arc-to-narrative-arc]] · [[sfx-second-sense-doctrine]] · [[sfx-mood-map-per-topic]] · [[sfx-riser-to-music-drop-backtiming]] · [[pace-bpm-matched-music-selection]] · [[sfx-vibe-brief]] · [[cut-full-screen-transition]] · [[motion-list-item-marker-card]] · [[pace-rough-cut-diagnostic]] · [[sfx-find-similar-track-handover]] · [[sfx-beat-aligned-handover]] · [[sfx-music-ten-point-framework]] · [[sfx-epidemic-facet-query]]

## Failure modes
- **Starting the new track at its file head.** The section's first sentence lands over a 4-second intro wash and the boundary does not read at all. Fix: measure the first main beat and set `data-media-start`.
- **Crossfading two beds that are too far apart.** Two tempos overlapping for a second beat against each other audibly, and it reads as a radio mis-cue rather than a boundary. Fix: butt-join within 8 BPM, crossfade only within 12, and past that use a riser or a gap.
- **A long crossfade.** Past ~1.5 s the viewer hears two songs, which is worse than either. Fix: 0.7 s default, 2.0 s absolute ceiling — and treat the need for a long fade as evidence the search was not tight enough.
- **Linear crossfade.** Equal-gain fades dip about 3 dB in the middle, so the join sags. Fix: equal-power shape — `0.707` at the midpoint of each lane, or `acrossfade` with `tri` curves.
- **Butting two dissimilar beds with no handover.** Different tempo and key collide on one frame; it sounds like a playback error. Fix: pick one of the routes — there is no fourth.
- **Stopping the old bed mid-phrase.** Audible truncation. Fix: land the out-point on a transient or a bar line, plus a 4-frame de-click ramp.
- **A track change with no picture change.** Reads as a technical fault, because nothing motivates it. Fix: move the change to the section's first frame, or give the picture a cut.
- **Changing the track where no section changed**, or every time the B-roll changes. Trains the audience that music changes mean nothing, which destroys the signal for the boundaries that do matter. Fix: every change is justified by a transcript-visible boundary; one bed per section; 3–6 per 10 minutes.
- **Changing on every list item.** Ten beds in ten minutes is noise. Fix: change at act boundaries; mark items with SFX or graphics.
- **Level mismatch across the join.** Different masters land at different loudness and the audience hears "the volume changed", not "the section changed". Fix: loudness-match to within 1 LU before placing; both beds at the same authored gain; let the carve do the rest.
- **Forgetting the second carve.** Bed B enters uncarved, sits at the wrong spectral place under the voice, and intelligibility drops. Fix: every bed clip carries its own `data-fx-carve`; the carve script only writes what it is pointed at.
- **A riser that ends after the boundary.** The new section's downbeat arrives underneath a still-rising sweep, which cancels both. Fix: `riser.start + riser.duration = boundary − 1 frame`.
- **Known gap:** the change-density band (3–6 per 10 min), the BPM similarity tolerances, and `change_start_offset` / `gap_len` are practitioner conventions and house calibration derived from the mechanism, not measured findings. No authoritative source publishes the offset between a music change and its picture boundary, nor a standard crossfade length for library beds. The defensible numbers are the downbeat alignment tolerance (film ±22 ms), the 2.0 s ceiling (taken from the transition registry's own `max_duration_s`), and the arithmetic of the joins. Measure a reference video's offset and prefer it.
