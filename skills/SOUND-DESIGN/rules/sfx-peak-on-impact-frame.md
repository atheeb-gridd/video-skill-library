---
id: sfx-peak-on-impact-frame
aliases: [sfx-impact-frame-sync-window]
title: Align the peak, not the file — find the impact frame and land the hit on it
skill: sound-design
type: sfx
family: sync-placement
tags: [skill/sound-design, type/sfx, family/sync-placement, sfx/motion, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:58"
    quote: "So first of all, if you're putting a sound effect on a cut, place the highest peak of the sound effect on the cut."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:07:02
    quote: "And you can find the peak just by looking at the waveform."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:04"
    quote: "And if you're putting a sound effect on a motion, then match the peak of the sound effect to the middle of the motion. And match the length of the sound effect with the motion. Either by changing the speed, or by layering multiple sound effects."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:14"
    quote: "Now the peak of my hit sound effect should land exactly on the impact frame of my hand."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:26"
    quote: "So to show the movement while the hand is coming down, we can add a whoosh."
research_refs:
  - https://en.wikipedia.org/wiki/Audio-to-video_synchronization
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://tech.ebu.ch/docs/techreview/trev_2009-Q1_HD-Audio-Delays.pdf
  - https://en.wikipedia.org/wiki/Speed_of_sound
  - https://blog.prosoundeffects.com/sound-editing-in-sync-tutorial
  - https://sfxengine.com/blog/how-to-sync-sound-effects-with-video
  - https://pixflow.net/blog/cinematic-whoosh-sound-effects/
  - https://ffmpeg.org/ffmpeg-filters.html
difficulty: medium
detectable_from: video
---

# Align the peak, not the file — find the impact frame and land the hit on it

## What it is
The single most consequential placement rule in sound design, and the one most often got wrong by people who think they got it right: **what you align is the sound's loudest point, not the beginning of its file.** A library hit routinely carries anywhere from 20 ms to 300 ms of air, room tone, a wind-up or a fade before its transient. Drop that file so its *start* sits on the impact frame and the hit lands two to nine frames late — audibly wrong, with nothing in the timeline looking wrong.

The source states the rule three ways, and together they form a complete placement doctrine:

- **On a cut** → the sound's highest peak goes on the cut frame ([[sfx-peak-on-the-cut]]).
- **On a motion** → the sound's peak goes at the **middle** of the motion, and the sound's *length* is matched to the motion's length, either by changing its speed or by layering several sounds ([[sfx-peak-at-motion-midpoint]]).
- **On an impact** → the peak lands **exactly** on the frame of contact. *"The peak of my hit sound effect should land exactly on the impact frame of my hand."* Not the frame before, not the file's start, not the middle of the swing.

And the layered form: a whoosh under the descent to carry the movement, the hit on the contact frame, optionally reverb between them to give the impact size. **One event, two sounds, two different anchors** — the whoosh anchored across the travel, the hit anchored to the instant.

That doctrine leaves two problems the transcript does not solve, and this note solves both.

**Problem one: which frame is the impact frame?** Eyeballing a scrubber gets you within three or four frames, which at 30 fps is up to 133 ms — outside even the loosest detectability threshold. The impact frame is the frame on which the moving object **stops moving**, and because it stops, it is also the frame on which **motion blur collapses**. Every approach frame carries a blur streak proportional to velocity; the contact frame carries almost none. That makes it findable by measurement rather than by eye: inter-frame luminance difference climbs through the approach, **peaks on the frame that contains the contact**, and drops sharply on the next frame.

**Problem two: how wrong can you be, and in which direction?** The published sync tolerances are the reference, and every one of them permits more lag than lead:

| Standard | Window |
|---|---|
| ITU-R BT.1359-1 (detectability) | 45 ms lead → 125 ms lag |
| ITU-R BT.1359-1 (acceptability) | 90 ms lead → 185 ms lag |
| EBU R37 (end-to-end) | +40 / −60 ms |
| ATSC IS-191 | audio ≤15 ms early, ≤45 ms late |
| Film convention | ±22 ms either direction |

There is a physical reason, and it is the one to reason from for impacts specifically: **sound from a real impact always arrives after the light.** At 3 m that is about 9 ms; at 10 m, 29 ms. A hit that lands a frame *late* is a hit heard from across a room. A hit that lands a frame *early* is an effect with no cause, and the ear catches it every time. The window around the impact frame is therefore **not symmetric: 0 to +1 frame is natural, −1 frame is the edge, and −2 frames is broken.**

The perceptual justification and the general binding window are [[sfx-av-sync-binding-window]]; measuring a *file's* peak in isolation is [[sfx-peak-offset-measurement]]. **This note is the procedure**: find the impact frame in the footage, find the file's peak, make them coincide, and know how much error you have.

One distinction the library's general "motion sound leads picture" rule must not be applied through: **the whoosh leads, the hit does not.** They are two effects doing two jobs. The whoosh sounds the *travel* and its energy sits across the approach frames; the hit sounds the *contact* and its peak sits on the contact frame.

**Style.** Filed `sfx/motion`: an impact frame is a movement arriving at its end, and the hit is there because of that arrival. Where the impact is a real object the viewer can point at, the layer selling the object is diegetic and is spotted in [[sfx-diegetic-spotting-list]].

## When to use it
On every sound effect that has a **single identifiable loudest moment** and a **single identifiable picture moment** to attach it to:

- **Any visible contact.** A hand hitting a table, a door closing, a laptop lid shutting, an object landing, a foot planting.
- **Any animation that stops hard.** A card that slams into place, a counter that snaps to its value, a title that lands. The synthetic case is identical to the physical one and takes the same measurement ([[motion-impact-frame-quantisation]]).
- **Any transition that arrives** rather than passes — a punch-in, a whip that lands, a match cut on a movement's end.
- **Any cut being punctuated**, any reveal, any bar or counter that finishes.
- **Whenever a hit "feels off" but nobody can say why.** It is almost always one to three frames early.

Run the **length-matching** half whenever the picture event has duration — a swipe, a pan, a slide, a scale — because a sound shorter than its move leaves the tail of the move silent, and a sound longer than its move keeps ringing over a static frame.

Do **not**:
- **Force peak alignment on effects with no meaningful peak** — ambience beds, room tone, sustained textures, drones. The post convention is explicit that whooshes and reverb tails are *"felt out until they fit"* rather than hit to a marker.
- **Apply it to a motion that eases out.** An entrance with `power3.out` has its velocity maximum at the start and no contact frame at all.
- **Apply it to a continuous action.** A rub, a slide, a scroll has no impact frame; it wants a sustained sound matched in length ([[sfx-arbitrary-sound-motion-sync]]).
- **Align to a picture moment that is itself ambiguous.** If you cannot name the impact frame, the problem is the footage or the animation, not the placement.

## How to recognise it in a reference video
**Measure the sync error, do not judge it.** For every visible impact, find the picture's contact frame and the audio's peak, and log the difference in frames. That distribution *is* the creator's sync discipline.

**Find the contact frame by luminance difference.** `signalstats` prints a per-frame mean Y difference; the contact frame is the frame with the **maximum YDIF in the approach window**, followed by a sharp drop:
```bash
ffmpeg -i shot.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YDIF:file=-" \
  -f null - 2>/dev/null | head -80
```
Read `frame:N pts_time:T` alongside each value. A clean impact shows a rise across 3–6 frames, one maximum, then a fall of **40 % or more** on the next frame. `YDIF` is the mean absolute difference between this frame's luma plane and the previous one — it rises with visible motion and collapses when motion stops, which is exactly the deceleration signature an impact produces. It is not a physics measurement and **it will mislead on a shot with a camera move or a cut inside the window**, which is why the next step exists.

**Confirm with motion blur.** Extract the five frames around the candidate and look at them:
```bash
ffmpeg -i shot.mp4 -vf "select='between(n,142,147)'" -vsync 0 f_%03d.png
```
The approach frames show a directional streak; **in live footage the contact frame is the first frame where the streak has collapsed and the objects touch** — the first sharp or first deformed frame. If blur persists through your candidate, the impact is one or two frames later. **In animation the impact frame is the first frame of the squash/recoil, not the last frame of the approach** — using the approach frame makes every hit one frame early, which is the direction the ear catches fastest.

A scene-score trace is a cruder alternative where YDIF is unavailable:
```bash
ffmpeg -i ref.mp4 -vf "select='gt(scene,0)',metadata=print:key=lavfi.scene_score" -f null - 2>&1 | head -50
```

**Find the sound's peak** at sub-frame resolution — 10 ms buckets are a third of a frame at 30 fps:
```bash
ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=480,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
```

**Subtract, and log the error signed, in milliseconds and frames.** `peak_time − impact_time`. Positive = sound late, negative = sound early. This one number is the whole audit. In a well-cut reference the distribution clusters at **0 to +1 frame** with essentially nothing below −1. A distribution centred at −2 or worse means the creator placed by file start rather than by peak, which is worth knowing before you copy their approach.

**Interpret against the tolerances, converted per frame rate:**

| fps | 1 frame | Max **early** (detectability, 45 ms) | Max **late** (detectability, 125 ms) | Max late (acceptability, 185 ms) | Film ±22 ms |
|---|---|---|---|---|---|
| 24 | 41.7 ms | 1 f | 3 f | 4 f | ±0.5 f |
| 25 | 40.0 ms | 1 f | 3 f | 4 f | ±0.55 f |
| 30 | 33.3 ms | 1.35 f | 3.75 f | 5 f | ±0.66 f |
| 60 | 16.7 ms | 2.7 f | 7.5 f | 11 f | ±1.3 f |

For a **sharp transient against a hard visual event** the working target is much tighter than the broadcast numbers: transients should line up to within a **quarter to a half frame** or they flam against production audio. Use the table as the failure boundary and half a frame as the target.

**Other signals to log:**
- **Check the anchor choice.** Is the peak on an instant or in the middle of a move? A sustained whoosh whose loudest point sits at the *start* of a pan is a misplacement even though it "starts on the cut".
- **Check length matching.** A matched pair is within about **±20 %**. A 15-frame swipe carrying a 45-frame whoosh is the commonest mismatch and reads as smeary.
- **Look for the layered build.** A hit alone shows a single transient; a hit with a travel sound shows 6–15 frames of rising broadband energy leading into it, with the whoosh peak typically **2–6 frames** before the hit. Log them as two effects, because they have two different placements.
- **Listen for a low-end tell.** An impact with no energy below 150 Hz reads as small regardless of level. Presence of a sub layer is a deliberate weight choice worth logging.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `anchor_type` | instant | instant \| motion-middle | Cut, impact, snap → instant. Pan, slide, scale, swipe → motion-middle. |
| `impact_frame` | measured | — | YDIF maximum followed by a ≥40 % drop, confirmed by blur collapse. In animation it is the **first frame of recoil**, not the last frame of approach. |
| `peak_offset` | measured | 0.02–0.30 s | Time from the file's start to its loudest sample. **Always measured.** This is the number the whole note exists for. |
| `placement_error` — target | 0 f | −0.5 to +0.5 f | `peak_time − event_time`. Half a frame is the aim. |
| `placement_error` — review accept band | 0 f | ±1 f @ ≤30 fps · ±2 f @ 60 fps | What to pass in a review pass. Derived from the film ±22 ms convention rounded to whole frames. |
| `max_early` | −1 f | 1 f (24/25/30) · 2 f (60) | **Hard limit.** A sound preceding its visible cause by 2 frames reads as an error at any frame rate. |
| `max_late` | +3 f @30 fps | 3 f (24/25/30) · 7 f (60) | Tolerable, not the target. The ear is far more tolerant here. |
| `keep_lead` | 0.05 s | 0–`peak_offset` | How much of the file's pre-transient material to retain. Some wind-up sells the impact; keeping it delays nothing if you compensate `data-start`. Use 0 for a clean crack. |
| `length_match` | ±20 % | ±10–30 % | Effect duration vs picture-move duration, for motion-anchored sounds. |
| `rate_adjust` | 1.0 | 0.5–2.0 | Speed change used to match length. Render-safe and **pitch-preserved**, normalised `0.1..5`. |
| `whoosh_peak_lead` (`layer_lead`) | 4 f (0.133 s) before the hit's peak | 2–6 f | The travel sound, not the contact sound. Its *tail* should reach the contact frame. |
| `whoosh_length` | 12 f (0.4 s) | 8–20 f | Matched to the **visible approach**, not chosen from the file. |
| `hit_level` | −13 dB rel. dialogue (`data-volume` 0.211–0.22) | −12 to −15 dB | The source's SFX window. |
| `whoosh_level` | −16 dB (`data-volume` 0.158–0.18) | −15 to −18 dB | 2–3 dB under the hit. The travel must not outweigh the arrival. |
| `sub_layer` | optional | 40–120 Hz | Added weight. Aligned to the **same frame**, not offset. |
| `reverb_wet` | 0.15–0.25 | 0.10–0.40 | The source's own note — *"You can also add reverb in between to give it more impact."* **Identical node on both clips** so they read as one event in one room ([[sfx-reverb-glue]]). |
| `repeat_limit` | 2 per file | 1–3 | Then vary by pitch, length or reverb. |
| `no_peak_class` | ambience, drone, texture | — | Effects exempt from this rule entirely; place by feel. |

## Reproduction prompt

```
Place sound effect {{SFX}} so its peak lands on the picture event at {{EVENT}}
(seconds, in a 30fps composition).

1. FIND THE EVENT FRAME BY MEASUREMENT, not by scrubbing.
   ffmpeg -i {{SHOT}} -vf "signalstats,metadata=print:key=lavfi.signalstats.YDIF:file=-" \
     -f null - 2>/dev/null
   In the window where the objects approach, take the frame with the MAXIMUM
   YDIF that is followed by a drop of 40% or more. Record its pts_time.
2. CONFIRM WITH MOTION BLUR. Export the 5 frames around it:
   ffmpeg -i {{SHOT}} -vf "select='between(n,N-2,N+2)'" -vsync 0 f_%03d.png
   LIVE FOOTAGE: the contact frame is the FIRST frame where the blur streak has
   collapsed and the objects touch. If blur is still visible on your candidate,
   move one or two frames later.
   ANIMATION: the contact frame is the FIRST frame of the recoil/squash, NOT the
   last frame of the approach.
   The picture is the authority; the measurement is the shortcut. A camera move
   or a cut inside the window will produce a larger YDIF than the impact.
3. CLASSIFY THE ANCHOR:
   - a cut, an impact, a snap-to-stop  -> INSTANT
   - a pan, slide, swipe, scale, wipe  -> MOTION-MIDDLE (anchor at the move's
     midpoint, and match length in step 7)
   - ambience, drone, texture          -> this rule does not apply. Stop.
4. FIND THE FILE'S PEAK. Analyse {{SFX}} in 10ms buckets and record
   {{PEAK_OFFSET}} = seconds from file start to the loudest sample. Do not
   assume it is zero; library files carry 20-300 ms of air.
5. PLACE IT. Choose {{KEEP_LEAD}} = how much pre-transient material to keep
   (default 0.05 s; 0 for a clean crack, more when the wind-up sells the
   impact), then set:
       data-media-start = {{PEAK_OFFSET}} - {{KEEP_LEAD}}
       data-start       = {{EVENT}} - {{KEEP_LEAD}}
   so the peak lands exactly at {{EVENT}}. Never place the untrimmed file at
   {{EVENT}}. Verify the arithmetic - this single line is the whole technique.
6. VERIFY NUMERICALLY. Re-measure the mixed timeline and compute
   peak_time - {{EVENT}}. Target within half a frame; accept within one. NEVER
   more than 1 frame EARLY. Up to 3 frames late is tolerable at 30fps but is
   not the target.
7. IF MOTION-MIDDLE: measure the move's duration and match the effect to within
   20%, either by setting a constant playback rate (pitch-preserved, 0.1-5) or
   by layering a second sound to fill the remainder. Do NOT stretch a transient
   effect to fill a long move - layer instead.
8. ADD THE TRAVEL SOUND, SEPARATELY, if this is an impact with a visible
   approach. A whoosh covering the approach:
       length         = the visible approach duration (typically 8-20 frames)
       start_whoosh   = {{EVENT}} - length, so its TAIL reaches the contact frame
       its own peak sits 3-6 frames BEFORE {{EVENT}}
   The whoosh leads; the hit does not. Do not merge these two placements.
9. LEVEL: hit at -13 dB relative to dialogue, whoosh 2-3 dB under it. The
   arrival must outweigh the travel. Optionally add a 40-120 Hz sub layer on the
   SAME frame as the hit, not offset.
10. GLUE with a small shared reverb - wet 0.15-0.25, an IDENTICAL node on both -
    so they read as one event in one room rather than as two files.
11. CHECK THE SIGN OF ANY ERROR. If you must be off, be LATE. Real impact sound
    arrives after the light - about 9 ms at 3 m, 29 ms at 10 m. Early sound has
    no cause and the ear catches it every time.

ACCEPTANCE TEST: (a) play at quarter speed - the loudest moment of the sound and
the contact frame must coincide; (b) step frame by frame from {{EVENT}}-3 to
{{EVENT}}+3 with audio scrubbing - the transient fires on the contact frame or
the one after it, never before; (c) recompute peak_time - event_time and confirm
|error| <= 0.5 frame, and that it is not early by even 2 frames; (d) play at full
speed with your eyes closed - you should be able to say when the impact happens,
and it must feel like it comes from the object rather than like it was added;
(e) mute the whoosh - the hit alone must still land correctly. If it does not,
the whoosh was covering a misplaced hit.
```

## Execution spec

**ffmpeg — where the numbers come from.**
```bash
# 1. per-frame luminance difference: the contact frame is the max before the drop
ffmpeg -i shot.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YDIF:file=-" \
  -f null - 2>/dev/null

# 2. eyeball the blur collapse across the candidate
ffmpeg -i shot.mp4 -vf "select='between(n,142,147)'" -vsync 0 -frame_pts 1 f_%d.png
#    or stills at the composition frame rate around an estimate
ffmpeg -i shot.mp4 -ss 12.20 -t 0.40 -vf "fps=30" -start_number 366 frames/f_%04d.png

# 3. exact frame time from a frame index, without guessing the fps
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate,nb_frames \
  -of default=nw=1 shot.mp4

# 4. the file's peak offset, 10ms resolution (a third of a frame at 30fps)
ffmpeg -i impact-wood-01.wav -af "asetnsamples=n=480,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
#    exact, if soundfile is available
python3 -c "import numpy as np, soundfile as sf; y,sr=sf.read('hit.wav',always_2d=True); \
 y=y.mean(axis=1); print('peak_offset_s =', int(np.argmax(np.abs(y)))/sr)"

# 5. a physically trimmed variant, if you would rather not carry a media offset
ffmpeg -i impact-wood-01.wav -ss 0.135 -c copy impact-wood-01.trimmed.wav

# 6. a pitched-down variant for weight (-3 semitones, length restored)
ffmpeg -i impact-wood-01.wav -af "asetrate=48000*0.8409,aresample=48000,atempo=1.1892" impact.low.wav
```
Keep scratch outside the vault mount, which cannot delete files. Ledger anything kept: `node <SKILL_DIR>/scripts/resolve.mjs --from impact.low.wav --type sfx --project .`

**HyperFrames — two clips, one number each.** The alignment is entirely `data-start` + `data-media-start`, both in **seconds**. Contact measured at 12.400 s; hit peaks 0.185 s into its file; keep 0.05 s of wind-up; approach runs 10 frames (0.333 s):

```html
<!-- the contact: peak ON the frame.
     data-media-start = 0.185 - 0.05 = 0.135 ; data-start = 12.400 - 0.05 = 12.350 -->
<audio id="sfx-hit-hand" src="assets/sfx/impact-wood-01.wav"
       data-audio-group="sfx"
       data-start="12.350" data-duration="0.90" data-media-start="0.135"
       data-track-index="13" data-volume="0.211"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Shared room&quot;,&quot;params&quot;:{&quot;size&quot;:0.5,&quot;damping&quot;:0.5,&quot;wet&quot;:0.20,&quot;dry&quot;:0.9}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></audio>

<!-- the travel: leads, tail reaches the contact frame.
     whoosh peak measured at 0.240s; its peak sits 4f (0.133s) before the hit's -->
<audio id="sfx-swing-whoosh" src="assets/sfx/whoosh-med-03.wav"
       data-audio-group="sfx"
       data-start="12.067" data-duration="0.55" data-media-start="0.040"
       data-track-index="14" data-volume="0.158"
       data-fx-chain="… the SAME reverb / limiter nodes as #sfx-hit-hand …"></audio>
```

Contract details that decide whether this runs:
- **`data-start` is the clip's start, not its peak.** The `− peak_offset` term is the entire technique and there is no attribute that does it for you.
- **There is no frame unit and no frame attribute.** *"No `data-frame`, no `data-start-frame`. Everything is seconds"*, and *"frame counts must be converted at authoring time."* Frames survive only as comments — which usefully makes the placement **fps-proof**: `data-fps` is an optional hint the CLI can override (`--fps 24|30|60`, default 30), and a second is a second regardless. Convert once, against the frame rate you measured the contact frame at; the number stays right if the delivery fps changes, though your **tolerance table** does not.
- **Every `<audio>` needs an `id`** or it is never mixed → **silent render**, no warning.
- **Two overlapping clips must not share a `data-track-index`** (`duplicate_audio_track`) — hence 13 and 14. The index is otherwise *"display only"*.
- **Put SFX in an `sfx` group, never `voiceover`** — a non-voice clip in the carve group *"poisons the next re-analysis silently."*
- **`data-volume` is linear gain**, `1` = 0 dB, ceiling `3.98` (+12 dB). `0.211` ≈ −13.5 dB, `0.22` ≈ −13 dB.
- **The reverb node must be identical on both** so they read as one event in one room. `reverb` convolves a **generated** impulse, so preview and render produce the same room without shipping a file — but its `size`/`damping` are **not automatable**; only `wet`/`dry` are. Effects with a tail make the rendered track **longer** than its source: *"a bed with reverb no longer ends exactly at its `data-duration`; that is expected, not a bug."*
- **Write JSON attributes double-quoted with `&quot;`** — `scripts/carve.mjs` finds them with a `name="..."` regex and a single-quoted attribute is invisible to it. Chain order is signal order; a limiter goes last.
- **Length matching uses `data-playback-rate`**, normalised `0.1..5`, render-safe and **pitch-preserved**. There is **no rate envelope**: a sound that must accelerate with the picture has to be preprocessed.
- **There is no audio-follows-animation attribute.** When the visual event is a GSAP tween, its timeline position and this `data-start` are the same number written twice. If the tween lives in a **sub-composition**, the root-level audio needs `data-start = scene_local_t + the slot's data-start`.
- **Relative timing** can express the second clip (`data-start="sfx-swing-whoosh + 0.283"`) but is subject to four silent-zero failure modes — a typo'd reference resolves to 0 rather than erroring. For a placement this precise, write the absolute number.

**Epidemic Sound.** Two fetches, and the file property that matters is different for each: for the **hit**, a short pre-peak (you want the transient near the file head so `peak_offset` is small and any error is small); for the **whoosh**, a length matched to the approach.
```
# the contact
SearchSoundEffects { query:{term:"impact hit wood hand punch dry"},
                     filter:{ duration:{min:300,max:2500} },
                     sort:{by:POPULARITY, order:DESCENDING}, first:24 }
#   verified live tags in this space: designed--impact, designed--boom,
#   designed--rumble, designed--stinger, fight--impact

# the travel
SearchSoundEffects { query:{term:"whoosh air movement short fast"},
                     filter:{ duration:{min:200,max:1500} }, first:24 }

SearchSimilarToSoundEffect { id:<uuid>, first:12 }        # build 3 variants
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
**WAV, never mp3.** You are aligning a transient to a single frame, and mp3 encoding smears pre-echo across tens of milliseconds — exactly the error budget you are trying to protect. Read `audioFile.waveformUrl` to see roughly where the transient sits before committing to a download. Fetch a **set**, since the repeat limit is 2–3 uses per file. Download into `assets/sfx/`.

**Remotion:** an `<Audio startFrom={peakOffsetFrames - keepLead}>` inside a `<Sequence from={eventFrame - keepLead}>` — the one place a frame-native model is genuinely more convenient than seconds. Concept only; no Remotion runtime exists in this project.

## Pairs with
[[sfx-av-sync-binding-window]] · [[sfx-peak-offset-measurement]] · [[sfx-peak-at-motion-midpoint]] · [[sfx-peak-on-the-cut]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-bass-drop-under-impact]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-motion-sound-selection]] · [[sfx-motion-pass-two-rules]] · [[sfx-arbitrary-sound-motion-sync]] · [[sfx-reverb-glue]] · [[sfx-layer-volume-targets]] · [[sfx-substitute-material-foley]] · [[sfx-performed-foley-substitution]] · [[motion-impact-frame-quantisation]] · [[motion-sound-bound-motion-event]] · [[cut-on-action]] · [[sfx-unsounded-motion-audit]] · [[sfx-whip-crack-on-snap-cut]] · [[sfx-placement-discipline]] · [[sfx-air-on-micro-movement]] · [[sfx-riser-to-music-drop-backtiming]] · [[cut-movement-match]] · [[motion-explainer-beat-animation]] · [[sfx-cartoon-comedy-family]] · [[sfx-layered-approach-and-impact]]

## Failure modes
- **Aligning the file start.** The commonest error in the whole discipline: the clip starts exactly on the impact frame and the hit lands 2–9 frames late, with nothing in the timeline looking wrong. Fix: `start = event − peak_offset`, always.
- **Eyeballing the contact frame.** Gets you within three or four frames, which at 30 fps is up to 133 ms — outside even the loosest detectability threshold. Fix: YDIF maximum, then the blur check.
- **Taking the wrong YDIF peak.** A camera move or a cut inside the measurement window produces a larger difference than the impact. Fix: always confirm with the exported frames; the picture is the authority.
- **Aligning to the last frame of the approach.** In animation the contact frame is the first frame of the recoil; using the previous frame makes every hit one frame early — the direction the ear catches fastest.
- **Being early.** A hit that precedes its visible cause has no cause, and every published standard permits more lag than lead. An effect one frame early at 30 fps is already at the boundary; two frames early is broken. Fix: if in doubt, be late. Hard limit −1 frame.
- **Trusting "it looks right on the timeline".** The waveform's visual start is not its peak, and the timeline gives no feedback about which you aligned. Fix: verify numerically.
- **Merging the whoosh and the hit into one placement.** They sound two different things — travel and contact — and share no timing rule. Fix: two clips, two offsets.
- **Applying the "motion sound leads picture" rule to an impact.** That rule is about travel sounds. Fix: whoosh leads, hit lands.
- **A whoosh louder than its hit.** The travel outweighs the arrival and the moment deflates. Fix: whoosh 2–3 dB under.
- **Different reverb on the pair.** They read as two files rather than one event. Fix: identical reverb node on both.
- **Stretching a transient to fill a move.** Slowing a hit to cover a 30-frame swipe smears the attack and destroys the very thing that was being aligned. Fix: layer — a whoosh for the body, the hit for the instant.
- **Peak at the start of a motion.** A whoosh whose loudest point is at the beginning of a pan makes the pan feel like it decelerates. Fix: peak at the midpoint of the move.
- **No low end on a big impact.** It reads as small no matter how loud. Fix: layer a 40–120 Hz element on the **same frame**, not offset.
- **mp3 sources.** Pre-echo blurs the transient by tens of milliseconds and no placement precision survives it. Fix: WAV.
- **One file everywhere.** The same impact five times is one of the three named sound-design mistakes. Fix: three variants, or pitch/length variation.
- **Trying to pitch in the composition.** `data-playback-rate` is pitch-preserved and there is no pitch parameter; "lower it for weight" cannot be executed in-composition. Fix: bake the variant with ffmpeg.
- **Known gap:** the published sync tolerances (ITU-R BT.1359, EBU R37, ATSC IS-191) are for *general* AV material, not for isolated transient effects, and the tighter quarter-to-half-frame convention comes from post-production practice rather than a standard. Treat the fps table as the failure boundary and half a frame as the target; where a reference video exists, measure its own placement error and match it.
- **Known gap:** nothing in this stack couples a sound to a visual event — *"the two are coupled by the author writing the same number twice"* — and nothing validates that the two numbers still agree after a re-edit. Any change to a shot's `data-start` or `data-media-start` silently invalidates every impact sound on it. Re-run the measurement after any picture change; there is no lint rule that will tell you.
