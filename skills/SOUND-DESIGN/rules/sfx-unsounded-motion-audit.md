---
id: sfx-unsounded-motion-audit
aliases: [sfx-sound-every-motion]
title: Unsounded motion audit — find every move with no sound on it
skill: sound-design
type: sfx
family: motion-coverage
tags: [skill/sound-design, type/sfx, family/motion-coverage, engine/ffmpeg, engine/hyperframes, engine/epidemic, sfx/motion, layer/sfx, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:03:16"
    quote: "So if there's motion happening anywhere in your video but no sound effect on it, then the video feels very empty."
  - video: assets/videos/sfx kt 1.mp4
    timestamp: 00:03:31
    quote: "In short, every motion should have a sound effect."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:03:47"
    quote: "Motion sound effects — the second most important; for a transition, an animation in motion graphics, or some text effect. The brain expects a sound when there is motion; without it the video feels hollow and fake."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:04:10
    quote: "Now when there's motion happening, our brain expects that a sound is going to come. But when that sound doesn't come, the video feels really hollow, really fake."
  - video: assets/videos/sfx kt 2.mp4
    timestamp: 00:04:17
    quote: "\"So should I slap a whoosh on every single motion?\" You don't put a whoosh on everything."
research_refs:
  - https://en.wikipedia.org/wiki/Audio_sync
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://ffmpeg.org/ffmpeg-filters.html
  - https://auto-editor.com/ref/edit
  - https://auto-editor.com/ref/options
  - https://www.scenedetect.com/docs/latest/cli.html
  - https://krotos.studio/blog/post-production-sound-design
  - https://www.boomboxpost.com/blog/2022/4/26/step-by-step-audio-post-production-workflow
difficulty: medium
detectable_from: transcript+video
---

# Unsounded motion audit — find every move with no sound on it

## What it is
The diagnostic behind the whole `sfx/motion` style, and a mechanical audit rather than a creative choice. Walk the timeline, list every moment where something visibly moves, and check whether each one has an audible counterpart. Unsounded motion is the specific, findable cause of a video feeling flat, hollow, empty or fake — the brain predicts a sound whenever it sees a fast change, and the prediction failing is what registers as wrongness the viewer cannot localise.

The scope is wider than transitions: text entrances, graphic builds, scale changes, a punch-in, a swipe, a counter ticking, a bar filling, a subject's arm crossing frame.

**The audit produces candidates, not placements.** The same two source videos that say *"every motion should have a sound effect"* also say *"you don't put a whoosh on everything"*, and both are true. This note finds the moves and tiers them; **[[sfx-motion-sound-selection]] decides which candidates actually get sounded, which sound family each takes, and where the peak lands.** Keep the two jobs separate — running them together is how a recall-oriented detector turns into a blanket pass.

The audit runs two different ways depending on where the video comes from, and confusing them wastes hours. For a **reference video** you have pixels and must detect motion from them. For a **video you are building** every motion event is already declared in the composition, and the audit is a read of your own timeline — faster, exact, and not browser-dependent.

## When to use it
- **Once per project, after picture and motion are locked and before any sound is fetched.** Its output is the fetch list for the motion layer.
- **When a cut "feels flat" but you cannot say why** and the visuals are good. Run the audit; the answer is almost always a run of unsounded moves.
- **When analysing a reference** to build a style profile. The reference's motion-to-sound coverage ratio is one of the most portable numbers you can extract from it.
- **After a motion revision.** New animations arrive unsounded by default; re-run the audit rather than remembering.
- **Highest value on motion-graphics-heavy explainer content**, where nearly all the movement is authored and therefore has no production sound at all. Lower value on live-action-only footage, where camera and subject motion mostly carries its own recorded sound and the audit degrades into a foley job ([[sfx-diegetic-action-inventory]]).
- **Not on continuously drifting material.** A slow Ken Burns push on a still, ongoing parallax, a subtle floating overlay — these are motion, and sounding them produces a constant noise floor of effects. They belong to Tier 0 below.
- **Not as a licence to sound everything.** The overload failure — a tick every other second — loses a viewer inside two or three minutes ([[sfx-density-fatigue-audit]]).

## How to recognise it in a reference video
This section is the audit itself when the input is someone else's video.

**Step 1 — build the motion curve.** Use a frame-difference metric, not your eyes. There are two routes; **the ffmpeg route needs no install and is the one to specify**, because `auto-editor` and `scenedetect` are pip installs listed as unverified in this environment.

*Route A — ffmpeg only (no dependencies).* Inter-frame difference, averaged over the frame, gives a per-frame motion magnitude on a **0–255 YAVG** scale:
```bash
ffmpeg -i ref.mp4 -vf "tblend=all_mode=difference,signalstats,\
metadata=print:key=lavfi.signalstats.YAVG:file=motion.txt" -f null -
# frame:N pts_time:T / lavfi.signalstats.YAVG=<magnitude>
```
**Calibrate per video, then threshold** — absolute values depend on grain, grade and codec, so take percentiles of the trace rather than trusting fixed numbers. House bands for typical 1080p creator footage: **YAVG < 0.6** = effectively static, ignore; **0.6–2.0** = slow drift (Ken Burns, ambient float) → Tier 0; **2.0–12** = a real move that needs a decision; **> 12** = a cut or full-frame transition, which needs a *transition* sound rather than a motion sound.

*Route B — purpose-built detectors, if present.* auto-editor's motion method documents its own defaults — **width 400, blur 9, threshold 0.02** on a **0–1** scale:
```bash
auto-editor ref.mp4 --edit motion:threshold=0.06 --export json -o motion.json
```
PySceneDetect's content detector scores frame-to-frame difference **0–255** from hue, saturation, luminance and edge deltas, default cut threshold **27.0**; its adaptive detector defaults to threshold **3.0**, frame-window **2**, min-scene-len **0.6 s**.

**The two routes use different scales — 0–1 for auto-editor, 0–255 for YAVG and PySceneDetect. Never carry a threshold from one to the other.**

**Step 2 — detect the shot changes separately** so you do not classify cuts as motion, then subtract those timecodes:
```bash
ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd
scenedetect -i ref.mp4 detect-adaptive list-scenes     # if available
```
Use the cut detector for the *cut* list and the motion curve for movement *inside* shots — they answer different questions.

**Step 3 — segment the curve into motion runs.** A run is a span above the sounding threshold for at least **3–4 consecutive frames**. Runs of 1–3 frames are flicker, compression noise or a single-frame graphic pop; do not log them. **Merge runs separated by fewer than 4 frames** — otherwise one move generates three events. Discard runs where nothing travels more than **5 % of frame width**, and runs starting within 2 frames of a detected cut.

**Step 4 — check the audio under each run.** Look for a transient in the effects band within ±3 frames of the run's peak:
```bash
ffmpeg -i ref.wav -af "highpass=f=1200,astats=metadata=1:reset=0.05" -f null -
# or a per-frame RMS trace; n=1600 @48kHz is exactly one frame @30fps
ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null
```
A sounded move shows a **≥4 dB** RMS step within **−1 to +4 frames** of the motion onset. Log every run as **sounded** or **unsounded**.

**Step 5 — compute the numbers that go in the profile.**
- **Motion coverage.** Report it against a stated denominator, because the two in circulation differ by roughly 25 points: against **all detected runs including Tier 0 drift**, a well-sounded reference runs **35–70 %**; against the **pruned candidate pool** (Tier 1–3 only, with flicker, drift and cut-adjacent runs already discarded) it runs **60–95 %**. Never 100 %, and rarely under 20 %. **Say which denominator you used.**
- **Coverage by tier is more useful than either aggregate** — a strong reference is near 100 % on Tier 1 and near 0 % on Tier 0.
- **Effects per minute**, which is the density budget you will inherit.
- **The run-length histogram of sounded versus unsounded runs** — sounded runs are consistently the shorter, sharper ones.
- **The offset distribution.** Where does the transient sit relative to the visual onset? Professionally it clusters at **0 to +2 frames**. A consistent negative offset is a deliberate anticipation device and belongs to the whoosh/riser family, not to this audit.
- **The level.** Motion SFX sit around **−12 to −15 dB** relative to dialogue at 0 to −3 dB. Anything louder is a hit, not a motion sound.
- **Distinct files ÷ sounded events.** Healthy is above ~0.3, with variation supplied by pitch, reverb and duration rather than by 40 different files. The same file on every text entrance is audible within a minute.

**Other observable signals:**
- **Full-frame movement with silence** is the single loudest tell of a video with no motion pass — a whip pan or a push transition playing with only the music under it.
- **Element entrances with silence** while other elements in the same video *are* sounded means an incomplete pass, not a style.
- **Transcript signal:** none directly, but a spoken enumeration ("first… second… third…") almost always coincides with graphic entrances, which is where Tier 2 candidates cluster.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `detect_metric` | YAVG (ffmpeg, 0–255) | YAVG · auto-editor (0–1) · PySceneDetect (0–255) | **State which.** Thresholds do not transfer between scales. |
| `sounding_threshold` (YAVG) | 2.0 | 1.2–3.5 | Calibrate to the 75th percentile of the video's own trace. |
| `sounding_threshold` (auto-editor) | 0.06 | 0.02–0.12 | auto-editor's own default of **0.02** is a *presence* threshold; sounding needs a higher bar or every breath of camera noise becomes a candidate. |
| `ignore_below` (YAVG) | 0.6 | 0.4–1.0 | Slow-drift floor: do not sound ambient Ken Burns motion. |
| `cut_threshold` | scdet 12 | 8–25 | Above this it is a shot change; route to [[sfx-whoosh-transition-movement-reveal]] instead. |
| `detect_width` | 400 px | 320–640 | Analysis downscale. Documented default is 400; larger is slower with no benefit. |
| `detect_blur` | 9 | 5–15 | Gaussian blur before differencing; suppresses grain and compression noise. Documented default is 9. |
| `min_run_frames` | 3–4 f (100–133 ms) | 2–6 f | Shorter runs are flicker. Below 2 frames nothing can usefully be sounded anyway. |
| `merge_gap` | 4 f | 2–8 f | Runs separated by less than this are one event, not two. |
| `min_travel` | 5 % of frame width | 3–10 % | An element moving less than this is not felt as travel and does not want a whoosh. |
| `tier_1_coverage` | 100 % | 90–100 % | Transitions, full-frame moves, entrances/exits, impacts. Non-negotiable. |
| `tier_2_coverage` | 50 % | 30–70 % | Text and graphic reveals, punch-ins, scale steps. Selected, not blanket. |
| `tier_3_coverage` | 20 % | 0–40 % | Body movement, camera drift, eye roll. Aesthetic accents, felt not noticed. |
| `tier_0_coverage` | 0 % | 0 % | Continuous drift, parallax, ambient float. Never sounded individually. |
| `coverage_ratio` (all detected runs) | 0.50 | 0.35–0.70 | Denominator includes Tier 0. |
| `coverage_ratio` (pruned candidate pool) | 0.80 | 0.60–0.95 | Denominator excludes flicker, drift and cut-adjacent runs. **Do not target 1.0** on either. |
| `density_sustained` | 8 effects/min | 4–12 /min | The average the whole video must hold. Over budget, cut from Tier 3 upward. |
| `density_local_ceiling` | 6 per any 10 s window | 3–8 per 10 s | A short burst is allowed; a sustained 36/min is not. Both gates apply. |
| `effects_gap_min` | 0.5 s | 0.35–1.0 s | Closer than this reads as the tick-tick-tick fatigue failure. |
| `sfx_offset` | +1 f (33 ms) | −1 f to +3 f | The perceptual asymmetry is the constraint: audio **leading** picture is detectable at **45 ms** (≈1.35 f) while audio **lagging** is tolerated to **125 ms** (≈3.75 f). Late is safe; early is not. |
| `sfx_level` | −13 dB rel. dialogue | −12 to −15 dB | Tiered: `data-volume` ≈ 0.211 (T1), 0.178 (T2), 0.126 (T3). |
| `sfx_duration_match` | 1.0× motion duration | 0.8–1.5× | A 10-frame slide wants a ~10-frame sound, not a 40-frame swoosh. |
| `distinct_ratio` | 0.35 | 0.25–0.60 | Distinct source files ÷ sounded events. |
| `variation_axes` | pitch, reverb, duration | — | The three parameters that turn one file into many usable variants. |
| `pitch_shift` | ±2 semitones | ±1 to ±5 | Lower = heavier/cinematic; higher = lighter/faster. Must be pre-baked. |
| `group` | `sfx` | — | Never place motion SFX in the `voiceover` carve group. |

## Reproduction prompt

```
Run the unsounded-motion audit for {{PROJECT}} and emit a fetch list.

IF THE INPUT IS A REFERENCE VIDEO (pixels only):
1. Build the motion curve and the cut list. Prefer the ffmpeg route - it needs
   no install:
     ffmpeg -i {{REF}} -vf "tblend=all_mode=difference,signalstats,\
       metadata=print:key=lavfi.signalstats.YAVG:file=motion.txt" -f null -
     ffmpeg -i {{REF}} -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd
   (If auto-editor is present: auto-editor {{REF}} --edit motion:threshold=0.06
    --export json -o motion.json, defaults width 400 / blur 9. Its scale is 0-1,
    NOT the 0-255 YAVG scale - do not carry thresholds across.)
2. Calibrate: sort the YAVG values, take the 75th percentile as {{THRESHOLD}}
   (fall back to 2.0). Group consecutive frames above {{THRESHOLD}} into runs.
   Merge runs separated by < 4 frames. Discard runs shorter than 3-4 frames,
   runs where nothing travels more than 5% of frame width, and runs starting
   within 2 frames of a detected cut.
3. For each run, test for a transient above 1200 Hz within +/-3 frames of the
   run's peak, or an RMS step >= 4 dB within -1 to +4 frames of its onset.
   Mark SOUNDED or UNSOUNDED.
4. Emit a table: start, end, peak frame, magnitude, tier, sounded?

IF THE INPUT IS A COMPOSITION YOU ARE BUILDING:
1. Do NOT use computer vision. Read the composition instead. Every motion event
   already exists as a GSAP tween with a timeline position and a duration, and
   every clip boundary exists as data-start/data-duration. Enumerate them
   directly from the markup and from design-motion.md.
2. Every tween whose duration is <= 0.6 s and which moves, scales or reveals an
   element is a candidate. Every clip boundary is a candidate.
3. Cross-check either way: authored motion on a dark or low-contrast element
   often falls below any pixel threshold and must be added by hand. The
   composition's tween list overrides the trace.

THEN, FOR EITHER PATH:
4. TIER each candidate:
   Tier 1 - transitions, full-frame moves, entrances, exits, impacts -> sound all
   Tier 2 - text/graphic reveals, punch-ins, scale steps -> sound about half
   Tier 3 - body movement, camera drift, eye roll -> sound about a fifth,
            quietly, as aesthetic accents
   Tier 0 - continuous drift, parallax, ambient float -> never
   Also classify by kind - TRANSFORM (slide, scale, punch-in), BUILD (element
   arriving), STATE (counter, bar, toggle), SUBJECT (a person or object moving)
   - and write it into the design document; it decides the sound family.
5. APPLY BOTH DENSITY GATES: 8 effects per minute sustained, AND no more than
   6 in any 10-second window, AND 0.5 s minimum spacing. If over budget, drop
   Tier 3 first, then the weakest Tier 2. Cut events; do not lower the level of
   all of them.
6. ENFORCE VARIETY: no source file used more than 3 times without a pitch,
   reverb or duration change; at least one distinct file per three sounded
   events.
7. EMIT THE FETCH LIST: one row per surviving candidate carrying event time in
   seconds, motion duration in ms, tier, kind, the sound family to search, and
   the exact Epidemic query with its duration filter. Placement rules - which
   family, where the peak lands - are handed to the selection note; this list is
   its input.

ACCEPTANCE TEST: no Tier 1 event is left unsounded; no two effects are closer
than 0.5 s; the sustained per-minute count is at or under 8 and no 10-second
window holds more than 6; every row names a query, not a vibe; and the stated
coverage ratio names its denominator. Then watch the section
muted-except-effects: the effect track alone should read as a rhythm that
matches the picture, not as a random scatter. Then play with sound off and list
any move that now feels expected-and-absent.
```

## Execution spec

**HyperFrames — for a video you are building, the audit is a static read, not computer vision.** This is the most useful thing in the note. Every motion event in this stack is authored: motion is JS on one paused GSAP timeline per composition, and every clip is a `data-start` / `data-duration` pair in seconds. So the candidate list comes from the markup:

```bash
# every timed element and its window
grep -o 'data-start="[^"]*"[^>]*data-duration="[^"]*"' index.html compositions/*.html
# every tween that could be a motion event
grep -nE 'tl\.(from|to|fromTo|set)\(' index.html compositions/*.html
```
`animation-map.mjs` reads live timelines and would give this exactly, but it needs a browser — and per the project constraints, browser-dependent tooling (`render`, `snapshot`, `preview`, the layout audits, `animation-map.mjs`) **cannot run on this linux ARM64 VM without sudo**. Plan that leg elsewhere, and use the static grep here.

Two structural facts shape the audit's output. **A sub-composition timeline cannot animate host-root elements**, so a motion event inside a sub-comp is scene-local: the audio placed at the root needs `data-start = scene-local t + the slot's data-start`. And **there is no audio-follows-animation attribute** — the coupling is the author writing the same number twice. That is precisely why the audit exists as a document: **it is the ledger of numbers that must be written twice.**

Emit the audit as rows in `design-sound.md`, one per event:

| t (s) | motion dur (ms) | tier | kind | family | Epidemic query | duration filter | level |
|---|---|---|---|---|---|---|---|
| 41.20 | 500 | 1 | TRANSFORM | whoosh | `whoosh transition fast` | 400–625 ms | 0.211 |
| 58.90 | 260 | 2 | BUILD | swoosh | `swoosh light text` | 200–330 ms | 0.178 |
| 63.10 | 180 | 3 | SUBJECT | air | `air movement subtle` | 150–400 ms | 0.126 |

Placement, once the list exists:
```html
<!-- text entrance at 62.40s; transient 1 frame later -->
<audio id="sfx-txt-01" src="assets/sfx/swipe-soft.wav" data-audio-group="sfx"
       data-start="62.433" data-duration="0.45" data-media-start="0.02"
       data-track-index="14" data-volume="0.178"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.34,&quot;v&quot;:1},{&quot;t&quot;:0.45,&quot;v&quot;:0}]}]}"></audio>
<!-- 62.433 = 62.40 + 1 frame @30fps. 0.45s = 13.5f -->
```
Contract points that bite here:
- **Every `<audio>` needs an `id`** — an id-less audio element is never mixed and the render is silent with no warning.
- **Overlapping SFX must not share a `data-track-index`** (`duplicate_audio_track`). With six events in ten seconds, rotate across 14/15/16.
- Automation `t` is **clip-local** and the lane **holds its first value backwards** to the clip start, so the tail fade needs the leading `{t:0,v:1}` point shown.
- **Never GSAP-tween `volume`** on a clip that has a `volume` lane — the lane wins silently (`audio_volume_double_automation`).
- **Put SFX in an `sfx` group, never in `voiceover`**: the carve group must contain voices only, or the next carve re-analysis is silently poisoned.

**Variation without new files** — the three axes, as an FX chain on the clip (order is signal order, limiter last, params clamped on read):
```html
data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
 {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Thin It&quot;,&quot;params&quot;:{&quot;frequency&quot;:400}},
 {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Put It In The Room&quot;,&quot;params&quot;:{&quot;wet&quot;:0.15}}]}"
```
Reverb and delay make the rendered track **longer** than its source (`chainTailSeconds`) — expected, not a bug. **Pitch shifting is not an FX-chain node**: `data-playback-rate` (0.1–5, constant) is **pitch-preserved**, so it changes duration, not pitch. For a genuine pitch variant, bake it:
```bash
ffmpeg -i swipe.wav -af "asetrate=48000*0.891,aresample=48000,atempo=1.122" swipe-down2st.wav  # -2 semitones
```

**ffmpeg — turning the motion trace into an event list:**
```bash
python3 - <<'PY'
import re
rows=[]; t=None
for line in open('motion.txt'):
    m=re.search(r'pts_time:([\d.]+)', line)
    if m: t=float(m.group(1))
    v=re.search(r'YAVG=([\d.]+)', line)
    if v and t is not None: rows.append((t,float(v.group(1))))
vals=sorted(v for _,v in rows); thr=max(2.0, vals[int(len(vals)*0.75)])
ev=[]; run=[]
for t,v in rows:
    if v>=thr: run.append(t)
    else:
        if len(run)>=4: ev.append((run[0], run[-1]-run[0]))
        run=[]
if len(run)>=4: ev.append((run[0], run[-1]-run[0]))
print(f"threshold={thr:.2f} events={len(ev)}")
for s,d in ev: print(f"{s:.3f}\t{d:.3f}\t{round(s*30)}f")
PY
```
Keep all of this outside the mounted vault — that mount **cannot delete files**, so scratch analysis belongs in `/tmp`.

**Epidemic Sound — the audit's output is a batch fetch.** Group the rows by family and duration band so one search serves several events, then use similarity to build the rotation that keeps repeated events from reusing one file:
```
SearchSoundEffects { query:{term:"whoosh transition fast"},
                     filter:{ duration:{min:400,max:625} },
                     sort:{by: POPULARITY, order: DESCENDING}, first: 20 }
SearchSimilarToSoundEffect { id:<the one that fits>, first: 12 }   # -> rotation of 4+
DownloadSoundEffect { id:<uuid>, options:{ fileType: WAV } }
```
Six to ten files plus the three variation axes covers a whole video — fetch a **kit**, not one sound per event.

**Remotion:** the equivalent audit reads `<Sequence>` boundaries and interpolation ranges out of the source. Concept only; Remotion is not part of this stack.

## Pairs with
[[sfx-motion-sound-selection]] · [[sfx-arbitrary-sound-motion-sync]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-five-layers-build-order]] · [[motion-sound-bound-motion-event]] · [[motion-sfx-pass-manifest]] · [[motion-silent-motion-tier]] · [[motion-instant-appearance-sfx-justified]] · [[sfx-density-fatigue-audit]] · [[sfx-sound-pass-order]] · [[sfx-placement-discipline]] · [[struct-stimulation-budget]] · [[sfx-riser-anticipation-build]] · [[cut-punch-in-emphasis]] · [[pace-overlay-instead-of-cut]] · [[motion-look-finishing-pass]] · [[cut-j-audio-leads-picture]] · [[sfx-music-sets-the-mood]] · [[sfx-three-types-classification]] · [[sfx-diegetic-action-inventory]]

## Failure modes
- **Sounding everything the detector finds.** The detector's job is recall; yours is precision. A blanket pass produces the exact tick-tick-tick fatigue the source names, in which the viewer's brain tires within two or three minutes and attention moves from the content to the sound design. Fix: tiers and both density gates, applied before fetching.
- **Using the detection threshold as the sounding threshold.** auto-editor's 0.02 default answers "did anything move", not "is this worth sounding". Fix: 0.06 on that scale (YAVG 2.0 on the ffmpeg one), plus the 5 %-of-frame-width travel test.
- **Carrying a threshold between metrics.** 0–1 and 0–255 scales are not interchangeable and the mistake is silent. Fix: record which metric produced the number.
- **Quoting a coverage ratio with no denominator.** 50 % and 80 % can describe the same edit. Fix: say whether Tier 0 and flicker are in the pool.
- **Reading the local ceiling as the sustained rate.** 6 per 10 s held for a minute is 36/min — four times the budget. Fix: both gates, always.
- **Sounding continuous drift.** A Ken Burns push does not want a whoosh; it wants either nothing or a long low bed. Fix: Tier 0 exists for exactly this.
- **Running computer vision on your own composition.** Slow, browser-dependent, and strictly worse than reading the timeline you authored. Fix: the static read.
- **Missing authored motion the trace could not see.** A dark element sliding on a dark background barely moves any pixel metric. Fix: cross-check the composition's tween list by hand; the trace is a starting point, not the source of truth.
- **Treating one move as three events** because the detector split it. Fix: the 4-frame merge gap.
- **Sounding cuts as if they were motion.** A shot change is a transition, and a motion sound on it makes the cut feel soft. Fix: subtract the `scdet` timecodes before sounding.
- **Placing the sound early.** Editors habitually anticipate, but audio leading picture is detectable at 45 ms while lagging survives to 125 ms — an early transient reads as a sync fault, not as anticipation. Fix: 0 to +3 frames. Deliberate anticipation belongs to the whoosh/riser family with its own note.
- **Duration mismatch.** A 1.2 s swoosh on a 6-frame slide keeps sounding after the move has finished, which is worse than silence. Fix: 0.8–1.5× the event duration, trimmed with `data-media-start` + `data-duration` rather than fading a long file down.
- **One file for everything.** Repetition is named explicitly as a sound-design mistake and is audible fast. Fix: pitch, reverb and duration variation; `distinct_ratio` ≥ 0.25.
- **Auditing before motion is locked.** Every revision invalidates the list. Fix: run after picture and motion lock.
- **An audit with no fetch queries in it.** A list of timecodes and vibes is not actionable and the next agent will improvise. Fix: every row carries a query and a duration filter.
- **SFX in the voice group.** It poisons the carve analysis silently on the next run. Fix: `data-audio-group="sfx"`.
- **Known gap:** there is no motion-detection primitive in this stack and no audio-follows-animation attribute. Both halves of the audit are external tooling plus discipline. `auto-editor` and `scenedetect` are listed as unverified in this environment, and the browser-dependent `animation-map.mjs` cannot run on this VM — so the reference-video path may need to run on another host. The ffmpeg YAVG route is the dependency-free fallback.
- **Known gap:** the coverage bands, the tier percentages and the YAVG thresholds are house calibrations derived from the two source videos' contradictory-sounding advice ("every motion should have a sound" versus "you don't put a whoosh on everything"), not measured values or a published standard — which is why the procedure computes a per-video percentile instead of trusting them. The sync-offset numbers, by contrast, are from ITU-R BT.1359-1 and can be relied on. When a reference profile exists, use the reference's measured coverage instead.
