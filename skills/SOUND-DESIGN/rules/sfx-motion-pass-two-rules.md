---
id: sfx-motion-pass-two-rules
title: The sound-effect pass — a whoosh on everything that moves, a highlight sound on everything highlighted
skill: sound-design
type: sfx
family: sfx-pass
tags: [skill/sound-design, type/sfx, family/sfx-pass, sfx/motion, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:11:06"
    quote: "Next, go through your video and just add sound effects everywhere it makes sense. If something moves, you should add a whoosh. And if something gets highlighted, a highlight sound."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:04"
    quote: "And if you're putting a sound effect on a motion, then match the peak of the sound effect to the middle of the motion. And match the length of the sound effect with the motion."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:10"
    quote: "Either by changing the speed, or by layering multiple sound effects."
research_refs:
  - https://en.wikipedia.org/wiki/Mickey_Mousing
  - https://ffmpeg.org/ffmpeg-filters.html#astats-1
  - https://en.wikipedia.org/wiki/Habituation
  - mcp://Epidemic_sounds/SearchSoundEffects — taxonomy probed live 2026-08-28 (slugs swooshes--whoosh, swooshes--swish, magic--shimmer, user-interface--click, designed--riser)
difficulty: medium
detectable_from: transcript+video
---

# The sound-effect pass — a whoosh on everything that moves, a highlight sound on everything highlighted

## What it is
A discrete production pass, run once over locked picture, that applies **two mechanical rules** and nothing else: anything that *moves* gets an air sound, anything that gets *highlighted* gets a highlight sound. It is not a creative pass — the creativity happened when the motion was designed. It is a sweep whose output is a **manifest**: one row per event, with a time, a kind, a length, an Epidemic query, a measured peak offset and a gain. The design work in the pass is entirely in the classification (which of the two rules, or neither) and in the arithmetic (length match, alignment frame).

The reason to run it as a pass rather than sound each animation as you build it: the two rules produce a *candidate* list, and the list has to be budgeted as a whole. Sounding every candidate is the "sound effect overload" failure the second source names — a tick every other second tires the viewer inside two or three minutes. Habituation research is blunt about the mechanism: a shorter interval between repeats *accelerates* the loss of response. So the pass has two halves — enumerate, then ration.

In this stack the enumeration is largely mechanical, because motion is declared in the composition source: clips carry `data-start` / `data-duration` in seconds, and each animation is a GSAP tween positioned in seconds on one paused timeline. Both are greppable text. You do not have to watch the video to find the moves; you have to watch it to confirm which ones matter.

**Style.** Filed `sfx/motion` after its first rule, which generates most of the manifest. The second rule's output is an aesthetic cue — a highlight has nothing moving in it — and is specified in [[sfx-highlight-sound-on-emphasis]].

## When to use it
- **Once, after motion is locked and before the mix**, as the fourth of the five layers ([[sfx-five-layers-build-order]]). Re-run it after any motion revision, because a new animation is a new unsounded move.
- **Highest value on motion-graphics-heavy content** — explainers, list videos, anything where most movement is authored and therefore carries no production sound at all.
- **Lowest value on pure live action**, where camera and subject motion already have recorded sound; there the pass degenerates into a foley job ([[sfx-foley-three-element-checklist]]).
- **Rule 1 (move → air sound)** applies when something *travels or scales*: a graphic entering, text sliding, a card flying out, a punch-in, a whip pan, a full-frame transition, a bar filling, a counter rolling.
- **Rule 2 (highlight → highlight sound)** applies when something is *marked without travelling*: a surround darkens or blurs, a circle or underline draws on, a glow rises, a colour shifts, a keyword caption pops ([[sfx-highlight-sound-on-emphasis]]).
- **Neither rule** applies to an element that simply *appears* with no travel and no marking — that wants a short transient, not a whoosh ([[sfx-appearance-transient]]) — and to slow ambient drift on a still, which wants nothing at all. A whoosh over a 3-second Ken Burns move announces the edit and sounds like a mistake.

## How to recognise it in a reference video
You are detecting whether a reference *ran this pass*, and at what density.

- **Build the motion trace and the shot-change list, then subtract.**
  ```bash
  ffmpeg -i ref.mp4 -vf "tblend=all_mode=difference,signalstats,\
  metadata=print:key=lavfi.signalstats.YAVG:file=motion.txt" -f null -
  ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null -   # cuts, to exclude
  ```
  Calibrate per video with percentiles rather than absolutes. Working bands for 1080p creator footage: **YAVG < 0.6** static; **0.6–2.0** slow drift (expect no sound); **2.0–12** a real move (expect a sound); **> 12** a cut or full-frame transition (expect a transition sound). A run above 2.0 lasting **≥ 4 frames** is one event.
- **Scan the audio at frame resolution** and mark transients (`asetnsamples=n=1600` + `astats`, a **≥ 6 dB** step inside one frame). Join the two lists on time.
- **Compute two numbers and put them in the profile.** `motion_coverage` = sounded moves ÷ total moves — motion-graphic references run **0.75–0.95**, unsounded amateur edits **0.1–0.3**, and a flat **1.0** across hundreds of events is overload rather than diligence. `sfx_per_minute` — comfortable is **8–18** across all families; above ~25 the reference is relying on density instead of design.
- **Read the alignment, not just the presence.** For each sounded move, record `transient_frame − motion_onset_frame`. Air sounds on *ease-out entrances* cluster at **−2 to +1 frames**; sounds on *linear or ease-in-out travels* cluster near the travel **midpoint**. Both patterns are correct; which one a reference uses tells you how it thinks about motion.
- **Check the length match.** Extract each air sound and compare its duration to the on-screen move duration. Competent work sits at **0.8–1.25 ×** the move; a reference using one 900 ms whoosh for every move regardless of length is using a single file and will also fail the repetition test.
- **Count the highlight events separately** from the moves. A reference that sounds every keyword pop is at the overload end even if its `sfx_per_minute` looks normal, because highlight sounds are bright and stack badly.
- **Transcript signal:** a reference whose narration is dense with deictic emphasis ("*this* number", "look *here*") is highlight-heavy by construction; expect rule 2 to dominate.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `event_min_length` | 4 frames (0.133 s) | 3–6 frames | Shorter runs are noise or a single-frame flash; do not sound them. |
| `sfx_length_ratio` | 1.0 × move duration | 0.8–1.25 × | The source's rule. Achieve it by choosing a file of the right length, not by stretching. |
| `travel_anchor_ease_out` | onset + 1 frame | onset to onset + 2 | For `power2/3/4.out`, `back.out`, `expo.out` and the baked spring — velocity is **maximum at the first frame**, so the transient belongs at the start. |
| `travel_anchor_inout` | midpoint | 45–55% of travel | For `sine.inOut`, `power2.inOut`, `expo.inOut` — velocity peaks mid-travel. This is the case the source's "middle of the motion" rule describes. |
| `travel_anchor_linear` | midpoint | 40–60% | `none` (linear) has constant velocity; the midpoint (or the frame the element crosses frame centre) is the readable anchor. |
| `travel_anchor_ease_in` | end − 1 frame | end − 2 to end | For `power3.in` exits and `zoom-through` outs — velocity peaks at the end. |
| `gain_motion_sfx` | 0.211 (≈ −13.5 dB) | −15 to −12 dB rel. dialogue | The source's SFX band. Dialogue sits at 0 to −3 dB. |
| `gain_highlight` | 0.150 (≈ −16.5 dB) | −18 to −15 dB | Highlights are decorative and frequent; they sit below the motion band. |
| `coverage_target` | 0.8 | 0.6–0.95 | Fraction of candidate moves that actually get sound after rationing. |
| `sfx_per_minute_ceiling` | 18 | 8–25 | Hard stop. Count air, highlight, impact and cartoon families together for this number. |
| `rotation_window` | 3 uses | 2–5 | No file may repeat inside this many consecutive uses of its family ([[sfx-repetition-variant-rotation]]). |
| `whoosh_area_threshold` | 0.33 frame area | 0.2–0.5 | Above → whoosh family; below → swish family ([[sfx-swoosh-vs-whoosh]]). |

## Reproduction prompt

```
Run the sound-effect pass over the locked composition at {{COMP}} and produce
assets/sfx/MANIFEST.tsv, then place every approved row.

1. ENUMERATE EVENTS from the source, not from memory.
   a) Clip windows:  grep -oE 'id="[^"]+"[^>]*data-start="[^"]+"[^>]*data-duration="[^"]+"' {{COMP}}
   b) Tween events:  grep -nE 'tl\.(to|fromTo|set)\(' {{COMP}}
      For each tween read the trailing position argument (composition seconds),
      the duration, the ease name, and which properties move.
   c) For a sub-composition, add the host slot's data-start to every scene-local
      position before writing it down.
   Emit one TSV row per event: id, t_event, kind, dur_s, ease, anchor, family.
2. CLASSIFY each event into exactly one kind:
   TRAVEL   - x/y/xPercent/yPercent/scale/rotation changes, camera pushes,
              full-frame transitions            -> air family (rule 1)
   HIGHLIGHT- opacity/filter/colour/glow/mask/draw-on with no travel,
              caption keyword pops              -> highlight family (rule 2)
   APPEAR   - element becomes visible, no travel, no marking -> short transient
   NONE     - drift under 2 px/frame, ambient float, anything under 4 frames
   Write NONE rows into the manifest too, marked skip, so the next pass does not
   re-litigate them.
3. SET THE ANCHOR FRAME from the ease, not from the file:
   *.out / back.out / spring  -> anchor = t_event + 0.033
   *.inOut / none (linear)    -> anchor = t_event + dur_s/2
   *.in                       -> anchor = t_event + dur_s - 0.033
   Reason: the transient must land on maximum velocity, and ease-out curves are
   fastest at their first frame.
4. RATION BEFORE FETCHING. Sort by narrative importance. Keep sounding events
   until either coverage hits 0.8 or the running rate hits 18 sfx/minute,
   whichever comes first; mark the rest skip-budget. Never sound two events
   inside 0.25 s of each other - merge them into one sound.
5. FETCH per row, 3 candidates each, filtered by duration to
   0.8*dur_s .. 1.25*dur_s. Use the family's tested query from its own note.
6. MEASURE peak_offset for every downloaded file (see sfx-peak-offset-measurement)
   and write it into the manifest. data-start = anchor - peak_offset.
7. PLACE as <audio> clips, data-audio-group="sfx", track-index 12+, gain 0.211
   for TRAVEL, 0.150 for HIGHLIGHT/APPEAR. One id per clip, always.
8. AUDIT: re-count sfx/minute from the manifest, check no file repeats inside 3
   uses of its family, and confirm every TRAVEL row's sound length is within
   0.8-1.25x its move.

ACCEPTANCE TEST: play the finished pass at full speed once. You should not be
able to name any individual sound effect afterwards, but muting the SFX bus
should make the video feel visibly cheaper. If you can name a sound, it is too
loud or too repeated; if muting changes nothing, the pass did not land.
```

## Execution spec

**HyperFrames — the enumeration is text, because timing is declared.** `data-start` is *"what makes an element a clip"*, all authored time is in **seconds**, and motion lives as GSAP tweens positioned in seconds on one paused timeline per composition. That makes a grep-driven pass viable on this device:

```bash
# every timed element with its window
grep -oE '<[a-z]+[^>]*data-start="[^"]*"[^>]*>' index.html \
  | grep -oE 'id="[^"]*"|data-start="[^"]*"|data-duration="[^"]*"|data-track-index="[^"]*"'

# every tween with its position, duration and ease
grep -nE 'tl\.(to|fromTo|set)\(' index.html \
  | sed -E 's/.*(tl\.[a-zA-Z]+\()/\1/' | cut -c1-200
```
`animation-map.mjs` (`node skills/hyperframes-animation/scripts/animation-map.mjs <dir> --out <dir>/.hyperframes/anim-map`) enumerates tweens *and* samples bounding boxes, which is strictly better input for this pass — it gives real travel distances and therefore real screen-area fractions. It reads live timelines, so it needs a browser and must run on the render host, not the ARM64 device VM (constraint 3). Treat it as the enrichment step, not the required one.

Placement, one row per event, with the two gains:
```html
<!-- TRAVEL: card slides in at 8.400 s, power3.out, 0.40 s; whoosh peak_offset 0.062 -->
<audio id="sfx-whoosh-08" src="assets/sfx/motion/whoosh_short_02.wav"
       data-audio-group="sfx" data-start="8.371" data-duration="0.48"
       data-track-index="12" data-volume="0.211"></audio>

<!-- HIGHLIGHT: circle draws on, resolves 14.900 s; shimmer trimmed to its useful 0.6 s -->
<audio id="sfx-hl-03" src="assets/sfx/highlight/magic_shimmer_twinkle_04.wav"
       data-audio-group="sfx" data-start="14.820" data-duration="0.60"
       data-media-start="0.35" data-track-index="13" data-volume="0.150"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.45,&quot;v&quot;:1},{&quot;t&quot;:0.6,&quot;v&quot;:0}]}]}"></audio>
```
Contract points that bite in this pass: two overlapping `<audio>` on the same `data-track-index` raise `duplicate_audio_track`, so alternate 12/13 for adjacent events; a `volume` automation lane **holds its first value backwards** to the clip start, so a fade-in needs an explicit `t: 0` point; never also GSAP-tween `volume` on a clip that has a lane (`audio_volume_double_automation` — the lane wins); and **there is no rate envelope**, so "match the length by changing the speed" must be baked with ffmpeg, not authored.

**ffmpeg — the length match, when no candidate is the right length.** `data-playback-rate` is a constant in 0.1–5 and is *pitch-preserved*, which is the wrong tool for an air sound (it keeps the brightness while changing the length, and the ear reads brightness as mass). Bake instead:
```bash
# stretch a 380 ms whoosh to 500 ms, keeping pitch:  atempo = 380/500 = 0.76
ffmpeg -i whoosh.wav -af "atempo=0.76" whoosh_500ms.wav
# or change pitch and length together (heavier, slower feel): asetrate route
ffmpeg -i whoosh.wav -af "asetrate=48000*0.76,aresample=48000" whoosh_heavy.wav
```
`atempo` is valid 0.5–2.0; chain instances beyond that. Prefer **layering** over stretching when the move is much longer than the file — the source's own second option — one long air bed plus a short swish on the arrival frame.

**Epidemic Sound — the two queries this pass leans on.** Taxonomy probed live 2026-08-28; the catalogue's tag slugs are `<category>--<subcategory>` and titles are comma-separated descriptor chains.
```
# rule 1, small/light movers (text, icons, UI, lines)
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["swooshes--swish"]},
                              duration:{min:150,max:500} },
                     sort:{by:POPULARITY,order:DESCENDING}, first:24 }
# rule 1, full-frame movers, camera moves, transitions
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["swooshes--whoosh"]},
                              duration:{min:400,max:1200} }, first:24 }
# rule 2, highlight / emphasis
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["magic--shimmer"]} }, first:24 }
SearchSoundEffects { filter:{ tagSlugs:{matchType:ALL, values:["user-interface--click"]},
                              duration:{min:200,max:900} }, first:24 }
SearchSimilarToSoundEffect { id:<the one that worked>, first:12 }   # build the rotation set
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Read `audioFile.durationInMilliseconds` before downloading — it is the length match. Note from the probe that `magic--shimmer` assets run **3.8–5.2 s**, far longer than any highlight event, so rule-2 assets are almost always trimmed with `data-media-start` plus a volume lane rather than used whole.

**Remotion:** one `<Audio>` per manifest row inside a `<Sequence>` whose `from` is the anchor frame minus the peak offset in frames. Concept only; Remotion is not part of this stack.

## Pairs with
[[sfx-highlight-sound-on-emphasis]] · [[sfx-peak-offset-measurement]] · [[sfx-unsounded-motion-audit]] · [[sfx-swoosh-vs-whoosh]] · [[sfx-appearance-transient]] · [[sfx-motion-sound-selection]] · [[sfx-density-fatigue-audit]] · [[sfx-repetition-variant-rotation]] · [[sfx-sound-pass-order]] · [[sfx-layer-volume-targets]] · [[motion-sfx-pass-manifest]] · [[motion-sound-bound-motion-event]] · [[sfx-envelope-matched-to-easing-curve]]

## Failure modes
- **Sounding the candidate list instead of rationing it.** The mechanical rules over-generate on purpose; shipping all of them is the overload mistake. Fix: the 18-per-minute ceiling and the 0.25 s merge rule.
- **One whoosh file for every move.** Fails both the length match and the repetition test, and is audible within a minute. Fix: three lengths minimum, rotated.
- **Anchoring every travel at its midpoint.** Correct for linear and in-out moves, wrong for the house-default `power3.out` entrance, whose velocity peak is its first frame — the sound then arrives a beat late on every single entrance. Fix: read the ease and pick the anchor from it.
- **A whoosh on a scale change that is not travel.** A slow punch-in is not a move in the air-sound sense; it wants a low swell or nothing. Fix: check screen-area change per frame, not just "did a transform property animate".
- **Whooshes on drift.** Ken Burns motion under 2 px/frame is not an event. Fix: the `event_min_length` and YAVG floor.
- **Highlight sounds used whole.** A 4.5 s shimmer under a 0.4 s circle draw leaves sparkle ringing over the next line. Fix: trim with `data-media-start` and end it with a volume lane.
- **Stretching with `data-playback-rate` to match length.** It preserves pitch, so the sound keeps its brightness while its envelope changes — it stops matching the move's weight. Fix: bake with `atempo`, or layer.
- **Known gap:** nothing in the toolchain gates the manifest against the composition. If a motion revision lands after the pass, no lint rule notices the orphaned or missing sound — and the vault mount cannot delete files, so a superseded manifest must be superseded by writing a new one and updating the index, never by removal.
