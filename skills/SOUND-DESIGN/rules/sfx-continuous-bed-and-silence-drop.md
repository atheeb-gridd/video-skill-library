---
id: sfx-continuous-bed-and-silence-drop
title: The bed never stops — and the one sanctioned exception, the measured drop before a hit
skill: sound-design
type: mix
family: ambience
tags: [skill/sound-design, type/mix, family/ambience, sfx/diegetic, layer/ambience, layer/music, layer/sfx, layer/dialogue, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-1, source/research, difficulty/high]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:02:36"
    quote: "Even in Hollywood movies, the sounds of nearby things keep playing."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:02:16"
    quote: "In life, if anything is too perfect, it feels off — it doesn't feel natural. Same with your video: if there's no noise in it at all, then it feels too perfect."
research_refs:
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: high
detectable_from: audio
---

# The bed never stops — and the one sanctioned exception, the measured drop before a hit

## What it is
A professional reference point stated as a law: in a feature film the audio bed under a location **never fully drops out**. Something is always running — traffic two streets away, air handling, a room's own hiss — and its continuity is what makes a cut sequence read as one continuous place rather than a series of separate recordings. The default state of a mix is therefore *not silence*. It is a low-level, unnameable, always-present floor.

The interesting part is the exception, because films break this rule deliberately and in exactly one shape: a **measured drop-out immediately before an impact**. Everything falls away — bed, music, effects — for a short, chosen window, and the hit lands into the hole. This is not the same move as killing the music to emphasise a line ([[sfx-silence-as-pattern-interrupt]] owns that, and it drops one layer). This is the *whole mix* stepping down for a fraction of a second so the transient that follows reads as enormous without being any louder.

Two measured facts make the exception work and set its boundaries. **Backward masking lasts about 20 ms**: a loud sound masks quieter sound occurring roughly 20 ms *before* it, so a gap shorter than one frame is eaten by the hit and buys nothing. And loudness is judged over a window — EBU R 128's **momentary window is 400 ms** — so the perceived size of the hit is set by contrast against roughly the preceding four-tenths of a second. Lower those 400 ms and the hit reads louder at the same true peak. That is the whole mechanism: **a drop is cheaper than a boost, and it costs no headroom.**

The one thing the drop must never be is *digital zero*. A track going dead is not perceived as quiet; it is perceived as the sound system failing ([[sfx-noise-floor-target]]). The hole keeps a floor.

**Style.** Filed `sfx/diegetic` — the bed is the location's own sound, and its continuity is the whole reason a cut sequence reads as one place. The sanctioned drop is the aesthetic use of the same layer, and the transient it clears room for is [[sfx-cinematic-hit-emphasis]].

## When to use it
- **The always-on half applies to every video, always.** Every frame of the programme has something under it. This is the baseline the exception is measured against.
- **Use the drop before a genuine impact:** the reveal, the payoff hit, the smash cut, the frame where a claim lands. It is a punctuation mark for the single largest moment in a section, not for accents.
- **Use it where a riser has already been running.** Riser → drop → hit is the strongest three-part shape available, and the drop is what stops the riser and the hit smearing into one loud blur ([[sfx-riser-hit-pair]], [[sfx-riser-to-music-drop-backtiming]]).
- **Use it on a smash cut** where the incoming scene is loud; the pre-cut hole makes the arrival violent without touching the level ([[sfx-smash-cut-audio-contrast]]).
- **Do not use it more than once or twice per video.** The effect is a change-detection reflex and it habituates: the third identical drop is not heard.
- **Do not use it under dialogue.** If a word falls inside the window it is thrown away — the drop pulls the voice with it or, worse, leaves the voice alone in a hole and exposes every mouth noise in it.
- **Do not use it when there is nothing to drop.** A mix with no bed and no music has no hole to make; the "drop" is just silence that was already there, and it reads as a fault.
- **Do not use it before a soft event.** A drop that resolves into a quiet moment reads as a mistake, not as design; the resolution must be a transient.

## How to recognise it in a reference video
Both halves are measurable from the audio alone. Work from an RMS trace, not from the waveform's visual envelope.

```bash
# 25 ms RMS trace of the whole programme -> a step-detectable level curve
ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1200,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=rms.txt" -f null -
```

**Signals for the always-on bed (the law):**
- **No frame is below about −60 dBFS RMS.** Sample the whole file at 25 ms and take the minimum. A well-bedded programme's floor sits around **−50 to −60 dBFS** and never touches −90.
- **The floor does not step at picture cuts.** Compare the 200 ms either side of each cut from `scenedetect -i ref.mp4 detect-adaptive list-scenes`. A step larger than **6 dB** across a cut means the bed is per-clip rather than continuous — the fault [[sfx-hard-cut-audio-seam]] fixes.
- **Between phrases, something is audible.** Take a 500 ms window in the middle of a narration pause and look at its spectrum (`showspectrumpic`). Broadband low-level energy = bed present. A clean line at the noise floor with no content = the bed was gated or removed.

**Signals for the drop (the exception):**
- **A step down in RMS of 12–24 dB that begins 4–45 frames before a transient**, holds, and is terminated by that transient. That triple — step down, hold, transient — is the whole signature. A step down with no transient after it is a music rest, not a drop.
- **Measure and report three numbers**, which are what a design document needs: `gap_frames` (drop start → transient), `drop_depth_dB` (bed level before minus bed level inside), `residual_floor_dBFS` (the level inside the hole).
- **Bands observed in practice:**
  | `gap_frames` @30 | Seconds | Reads as |
  |---|---|---|
  | 0–1 | < 0.033 | Nothing. Inside the ~20 ms backward-masking span, so the hit swallows it. A wasted drop. |
  | 2–5 | 0.07–0.17 | A tightening. Felt, not noticed. Good under fast cutting. |
  | 6–18 | 0.2–0.6 | **The standard drop.** Long enough to cross the 400 ms momentary window, short enough not to read as a fault. |
  | 19–45 | 0.63–1.5 | Cinematic. Needs a strong residual floor or it reads as a dropout. |
  | > 60 | > 2.0 | No longer a drop — it is a rest window, and belongs to [[sfx-music-rest-windows]]. |
- **The transient lands on a picture event.** Cross-check the transient's timestamp against the impact frame; a drop whose hit is not on a visual event is decoration ([[sfx-peak-on-impact-frame]]).
- **Counter-check — is it a fault?** A true dropout has no transient terminating it, and its residual floor is at or below −85 dBFS. Design keeps a floor; a bug does not.
- **On the transcript:** the words immediately before the drop are usually the setup line, and the drop begins *after* the last word ends. A word inside the window means it is a fault.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `programme_floor` | −55 dBFS RMS | −60 to −50 | The always-on bed level. Present, unnameable. Below −65 it stops doing its job; above −45 it is heard as noise. |
| `bed_gain` (ambience) | −28 dB rel. dialogue (`data-volume="0.04"`) | −32 to −24 | Ambience sits under music, which sits under SFX, which sits under dialogue ([[sfx-layer-volume-targets]]). |
| `gap_frames` | 12 f (0.40 s) | 4–45 f (0.13–1.5 s) | Drop start to impact frame. 12 f is chosen to exceed the 400 ms momentary-loudness window by a frame. |
| `drop_depth` | −18 dB | −12 to −24 dB | Applied to music and ambience together. Beyond −24 dB you are at the floor and gaining nothing but risk. |
| `residual_floor` | −50 dBFS | −55 to −45 | What stays inside the hole. **Never −∞.** Room tone only, no music, no ambience events. |
| `drop_ramp_in` | 3 f (0.10 s) | 1–6 f | The fall. Faster than 1 frame clicks; slower than 6 frames is heard as a fade and stops being a drop. |
| `recovery_ramp` | 24 f (0.80 s) | 12–45 f | The beds come back **after** the hit, slowly, under its tail. A fast recovery fights the hit's decay. |
| `recovery_delay` | 9 f (0.30 s) | 0–24 f | How long after the impact frame the recovery starts. Let the hit own the first third of a second alone. |
| `hit_gain` | −12 dB rel. dialogue (`data-volume="0.25"`) | −15 to −9 dB | The hit is an SFX-layer event; the drop is what makes it feel bigger, not the fader ([[sfx-cinematic-hit-emphasis]]). |
| `uses_per_video` | 1 | 1–2 per 10 min | Habituation. The third one is invisible. |
| `dialogue_clearance` | 6 f | ≥ 4 f | Minimum gap between the last word and the drop start, and between the hit and the next word. Forward masking runs ~100 ms (3 f), so 4 f is the floor and 6 f is comfortable. |

## Reproduction prompt

```
Install the always-on bed, then cut one measured drop before the impact at {{IMPACT}}.

PART A - THE LAW (do this first, for the whole programme).
1. Lay a continuous ambience bed from the first frame to the last, at -28 dB relative to
   dialogue. It must not break at picture cuts: one bed spanning many shots, not one bed
   per shot. Where the location genuinely changes, crossfade the two beds over 12-18 frames
   across the cut rather than butting them.
2. Verify: sample RMS at 25 ms across the whole file. The minimum must sit between -60 and
   -50 dBFS and must never fall below -70. Any frame below -70 is a hole; find it and fill it.
3. Verify: at every picture cut, the bed level either side must agree within 6 dB.

PART B - THE EXCEPTION (once, maybe twice, per video).
4. Locate the impact frame {{IMPACT}} - the single frame of contact, arrival or reveal, not
   the frame the motion starts. Confirm no spoken word ends within 6 frames before it and
   none begins within 6 frames after it. If one does, move the drop or abandon it.
5. On EVERY bed - music and ambience - write a volume envelope, times relative to {{IMPACT}}:
      IMPACT - 15f : hold at normal level
      IMPACT - 12f : fall to -18 dB below normal, reached over 3 frames
      IMPACT - 12f .. IMPACT : hold. Residual floor about -50 dBFS. NEVER zero.
      IMPACT + 9f  : begin recovery
      IMPACT + 33f : back at normal level
6. Place the hit so its LOUDEST SAMPLE - not the file's first sample - sits on {{IMPACT}}.
   Trim into the file to find the peak; do not guess from the filename. Gain -12 dB relative
   to dialogue.
7. If a riser precedes this, its peak must land on IMPACT - 12f, i.e. exactly where the drop
   begins, so the riser stops and the hole opens on the same frame.

ACCEPTANCE TEST: play at full speed. The hit must feel larger than its meter reading. The
programme minimum RMS must still be above -70 dBFS INSIDE the hole. No word is clipped or
exposed. Removing the drop and playing again must make the hit feel measurably smaller - if
it does not, the drop is doing nothing and should be deleted rather than kept.
```

## Execution spec

**HyperFrames (primary).** There is no "duck everything" primitive, and there is no sidechain in-composition. The drop is a `volume` **automation lane written onto each bed**, and the single most dangerous fact about those lanes is that `t` is in **clip-local seconds** — seconds from that clip's own `data-start`, not composition time — and **a lane holds its first value backwards to the start of its clip**. A bed that begins before the drop therefore needs an explicit `{"t":0,...}` point at its normal level, or it starts out already dropped.

Impact at composition time **41.20 s**; ambience bed started at 8.00 s, so clip-local `t` for the impact is `41.20 − 8.00 = 33.20`.

```html
<!-- always-on ambience, one bed across many shots. -18 dB drop opening 12f before impact. -->
<audio id="amb-room" src="assets/sfx/amb/office-tone.wav"
       data-audio-group="ambience"
       data-start="8.00" data-duration="120.00" data-track-index="14" data-volume="0.04"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},
         {&quot;t&quot;:32.80,&quot;v&quot;:1},
         {&quot;t&quot;:33.10,&quot;v&quot;:0.126},
         {&quot;t&quot;:33.20,&quot;v&quot;:0.126},
         {&quot;t&quot;:33.50,&quot;v&quot;:0.126},
         {&quot;t&quot;:34.30,&quot;v&quot;:1}]}]}"></audio>

<!-- the hit: peak on the impact frame, not the file's first sample -->
<audio id="sfx-hit-reveal" src="assets/sfx/hits/cinematic-impact-deep.wav"
       data-audio-group="sfx"
       data-start="41.13" data-duration="2.40" data-media-start="0.07"
       data-track-index="20" data-volume="0.25"></audio>
```

Reading the numbers against the contract:
- `v` is **0..1 volume**, not dB. −18 dB is `10^(−18/20) ≈ 0.126`, applied on top of the clip's `data-volume` baseline. `data-volume` default is `1` (0 dB), maximum `3.98` (+12 dB).
- The `{"t":0,"v":1}` point is **mandatory**, per the backwards-hold rule.
- `data-media-start="0.07"` is the measured offset from the file's start to its loudest sample, so `data-start` + that offset lands the peak on 41.20 s. Measure it, never guess ([[sfx-peak-offset-measurement]]).
- Do **not** also GSAP-tween `volume` on these elements: with a lane present the lane wins and the tween is silently ignored (`audio_volume_double_automation`). And an authored `data-volume` on a tweened track is replaced outright, not scaled (`audio_volume_tween_overrides_gain`).
- Write these attributes **double-quoted with `&quot;`**; `carve.mjs` locates them with a `name="..."` regex and cannot see single-quoted ones.
- Every `<audio>` needs an `id` — an id-less audio element is never mixed, and the render is silently missing it.
- Put the music bed's identical envelope on its own lane. If several beds must move together, make them an `<hf-audio-group>` and write **one** lane on the bus — remembering that a bus's automation `t` is **composition time**, not clip-local, which is usually what you want here.
- `data-fx-carve` is **clip-only** and must name a group; it is the voice-under-music mechanism and is unrelated to this drop. Leave the carve in place — the drop rides on top of it.

**Placement spec, in one line.** Drop starts at `IMPACT − 12 frames` (−0.40 s), depth −18 dB on all beds, residual floor ≈ −50 dBFS, hit peak exactly on `IMPACT` at −12 dB relative to dialogue, recovery begins `IMPACT + 9 f` and completes by `IMPACT + 33 f`. No ducking of dialogue at any point; dialogue must be clear of the window by ≥ 6 frames on both sides.

**Epidemic Sound.** Two fetches, and their search surfaces are **not the same**. `SearchSoundEffects` has **no mood, key or BPM filter** — only `query.term`, `filter.tagSlugs {matchType, values}`, `filter.duration {min,max}` in **milliseconds**, and `sort`. That makes the term and the duration window carry all the specificity:

```jsonc
// The hit. Short, deep, with a tail to recover under.
SearchSoundEffects {
  query:  { term: "cinematic impact hit deep boom" },
  filter: { duration: { min: 1200, max: 4000 },
            tagSlugs: { matchType: "ANY", values: ["impact", "cinematic", "boom"] } },
  sort:   { by: "RELEVANCE", order: "DESCENDING" },
  first:  5
}

// The always-on bed. Long, eventless, loopable.
SearchSoundEffects {
  query:  { term: "room tone ambience quiet interior" },
  filter: { duration: { min: 60000 },
            tagSlugs: { matchType: "ANY", values: ["ambience", "room-tone"] } },
  sort:   { by: "DURATION", order: "DESCENDING" },
  first:  5
}
```
`duration.min: 60000` is the load-bearing filter for a bed — a 6-second "ambience" file looped under a two-minute scene has an audible period and is the commonest way this layer fails ([[sfx-ambience-search-formula]]). For the hit, `SearchSimilarToSoundEffect` against the chosen file finds its siblings for a second use later, which is how you avoid the repeated-effect mistake ([[sfx-repetition-variant-rotation]]). `DownloadSoundEffect` writes the file to `.media/audio/sfx/` and the pipeline stops there.

**ffmpeg — measure, then verify.**
```bash
# 1. find the hit file's peak offset (the number that becomes data-media-start)
ffmpeg -i hit.wav -af "astats=metadata=1:reset=0" -f null - 2>&1 | grep -i "peak_count\|Peak level"
ffmpeg -i hit.wav -af "silencedetect=noise=-30dB:d=0.01" -f null - 2>&1 | head

# 2. verify the hole never goes dead: minimum RMS across the whole programme
ffmpeg -i mix.wav -af "asetnsamples=n=1200,astats=metadata=1:reset=1,\
 ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null | sort -t= -k2 -n | head -3

# 3. confirm the contrast actually exists: momentary loudness either side of the impact
ffmpeg -ss 40.4 -t 1.6 -i mix.wav -af ebur128=peak=true -f null - 2>&1 | tail -12
```
Never bake the drop into the delivered mix while it is still inside the pipeline — declare it in the composition. Bake only for assets leaving HyperFrames, where the equivalent is `sidechaincompress` or an `afade`/`volume` expression.

**Known gap.** The contract has **no true silence detector and no automatic bed continuity check**; nothing in `lint` reads levels at all, and `check`'s browser-backed audits do not cover audio. The floor verification above is the only gate, and it must be run by hand after every pause-removal or gate pass. Also note the device VM here is linux ARM64 without sudo, so `render` and `preview` (and therefore any listening test on the real mix) must happen on another host.

**Remotion:** conceptually an `<Audio volume={f => ...}>` callback shaping the same envelope; no Remotion runtime exists in this project.

## Pairs with
- [[sfx-noise-floor-target]] — the floor this note must never destroy
- [[sfx-missing-ambience-audit]] · [[sfx-ambience-layer-stack]] · [[sfx-ambience-establishes-location]] — laying the bed in the first place
- [[sfx-ambience-search-formula]] — the "just tack ambience on" query
- [[sfx-cinematic-hit-emphasis]] · [[sfx-riser-hit-pair]] · [[sfx-riser-to-music-drop-backtiming]] — what lands in the hole
- [[sfx-peak-on-impact-frame]] · [[sfx-peak-offset-measurement]] · [[sfx-peak-at-motion-midpoint]] — finding and hitting the frame
- [[sfx-silence-as-pattern-interrupt]] — the music-only stop, its nearest neighbour
- [[sfx-music-rest-windows]] · [[sfx-music-hard-stop]] — where a long hole belongs instead
- [[sfx-hard-cut-audio-seam]] · [[sfx-smash-cut-audio-contrast]] — the cut cases
- [[sfx-layer-volume-targets]] · [[sfx-density-fatigue-audit]] — levels and how often this may fire
- [[cut-smash-cut-loud-to-quiet]] · [[motion-pattern-interrupt-jolt]] — the picture-side partners

## Failure modes
- **Dropping to digital zero.** The most common version of this mistake, and it does not read as drama — it reads as the audio having broken, and the viewer checks their volume. Keep the residual floor at −50 dBFS.
- **A gap shorter than a frame.** Inside the ~20 ms backward-masking span, the hit masks it entirely. You have written an envelope nobody will ever hear. Minimum 4 frames.
- **A gap longer than about two seconds.** Stops reading as a drop and starts reading as a rest — or as a fault. If you want two seconds of quiet, design it as a rest window with its own floor and pacing.
- **Dropping under a word.** The voice either goes with the beds (unintelligible) or stays behind alone in a hole (every breath and lip noise suddenly audible). Clear 6 frames on both sides.
- **No transient at the end.** A drop that resolves into nothing is a hole. The exception is only sanctioned because something lands in it.
- **Forgetting the `{"t":0}` point.** The lane holds its first value backwards to the clip start, so an envelope beginning at the drop makes the bed play the whole scene already ducked. Silent, total, and invisible on inspection.
- **Clip-local versus composition time.** Writing composition seconds into a clip lane puts the drop somewhere else entirely — usually before the clip's own start, where the backwards-hold then flattens it. Subtract the clip's `data-start`, or move the lane to an `<hf-audio-group>` bus where `t` is composition time.
- **Using it three times.** Change detection habituates. Two per ten minutes is the ceiling; one is usually right.
- **Recovering too fast.** The beds swelling back within a few frames fights the hit's own decay and makes the moment feel small. Delay 9 frames, recover over 24.
- **Treating it as a substitute for a good hit.** The drop makes a good transient feel enormous; it makes a weak transient feel like a mistake with silence in front of it.
