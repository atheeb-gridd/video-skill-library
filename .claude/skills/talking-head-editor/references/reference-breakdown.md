---
name: reference-breakdown
description: Stage 1-3 for vertical talking-head video. Turn 2-3 reference videos into one reusable style profile of defaults and tolerances — probe, parallel observe, merge, measure, mark confidence. Consumes the `How to recognise it in a reference video` section of every rule note.
type: reference
---

# Reference breakdown — building a style profile from 2-3 references

Covers **stages 1-3** of `_meta/pipeline.md` (INGEST → ANALYSE → PROFILE) for the vertical talking-head case. This is the analysis half of each skill router's **Mode A** and contradicts none of them; where a router says "probe first" or "measure, don't characterise", this file says how, with commands.

Stages 1-3 run **once per reference set**; stages 4-5 run once per new video. Do not start stage 4 until `PROFILE.md` exists and a human has read its evidence gaps.

## 1. The opening principle: a profile is defaults and tolerances, not techniques

**A list of techniques is not a profile.** A profile is a set of numbers a new video must satisfy, each with a central value, an observed range, and a confidence marker.

| Not a profile | A profile |
|---|---|
| "Uses fast cuts" | median shot length 1.8s (54f @30), p90 4.2s, max 7.0s, 22 cuts/min |
| "Punches in a lot" | punch-in 1.22x median (1.14-1.31 observed), hard (0f ramp), 2.4 events/min |
| "Big bold captions" | cap height 5.4% of frame height, baseline 21% from bottom, max 2 words/cue |
| "Snappy motion" | entrance 9f, `power3.out`, no overshoot in 31 observed events |
| "Good sound design" | 7.1 sfx/min, 62% motion / 24% aesthetic / 14% diegetic, music -17 LU under dialogue |

Three consequences govern everything below. **(a) Every row carries a range, not just a centre** — the range is the tolerance; stage 4 may move inside it and must justify leaving it. **(b) A row with no number is a defect** — if an observation could not be quantified, the row states *what could not be measured and why*, never a qualitative adjective. **(c) Negatives are rows too** — "never rotates", "never dissolves", "never puts a caption above centre" constrain stage 4 as hard as the positives and are cheaper to check.

The rule library is the vocabulary, not the profile. A profile names rule ids (`[[cut-punch-in-emphasis]]`) so parameters are reachable, then **overrides those notes' defaults with the measured numbers**. The note's default is a prior; the reference is the evidence.

## 2. Probe before anything

Nothing — not one frame extraction, not one duration claim — happens before every reference **and the target format** have been probed. Probe the target first: the punch-in headroom cap, the caption percentages and the safe-area bands all resolve against it. Vertical talking-head default is `1080x1920`, 30fps, `-14 LUFS`.

```bash
ffprobe -v error -select_streams v:0 \
  -show_entries stream=r_frame_rate,avg_frame_rate,width,height,nb_frames,duration \
  -show_entries format=duration,bit_rate -of default=noprint_wrappers=1 "<video>"
```

Write the results into `00-ingest.md` as a table before anything else. Generate it mechanically:

```bash
for f in ref-a.mp4 ref-b.mp4 ref-c.mp4; do
  ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate,width,height,nb_frames \
    -show_entries format=duration -of json "$f" | python3 -c "
import json,sys
d=json.load(sys.stdin); s=d['streams'][0]; n,q=s['r_frame_rate'].split('/')
print(f\"| \`$f\` | {s['width']}x{s['height']} | {s['width']/s['height']:.4f} | \"
      f\"**{int(n)/int(q):g}** | {float(d['format']['duration']):.2f}s | {s.get('nb_frames','?')} |\")"
done
```

Probe audio in the same pass — `codec_type=audio`, `sample_rate`, `channels`. A mono reference tells you nothing about the stereo placement of its effects; that is an evidence gap, not an absence. If the references are 1280x720 or 854x480 teaching downloads, note it — their resolution-headroom numbers do not transfer (§6.4).

### 2.1 The fps trap

`_meta/source-media.md` is the authority: this user's own reference set runs at **60, 25 and 29.97 fps**, and rule notes state timings in frames at 30fps. The failure is silent and total. **Measuring a 60fps reference as 30fps halves every duration you observe** — a 14-frame entrance reads as 7. The error runs the other way on the 25fps file: a 12-frame entrance reads as 14.4. Nothing looks wrong; the profile is just quietly false.

Verified, same 6.03s content encoded twice:

| File | fps | `nb_frames` | Cut boundaries (`pts_time`) |
|---|---|---|---|
| `ref.mp4` | 30 | 181 | 2.03333, 4.03333 |
| `r60.mp4` | 60 | 362 | 2.03333, 4.03333 |

**Frame counts differ by 2x. Seconds are identical.** That is the whole normalisation rule:

1. **Read fps per file.** Never inherit it from a sibling, never assume 30.
2. **Measure in seconds.** Every ffmpeg/ffprobe measurement is already in seconds — keep it there through all arithmetic.
3. **Express in frames at the TARGET fps** only when writing the profile row: `frames = round(seconds * target_fps)`.
4. **Record the source fps beside every observation.** Every row in every `01-observed-*.md` carries `src_fps`. A row without it is unusable at merge time.
5. Treat `29.97` as `30000/1001`, not 30. Over a 10-minute reference that is ~1.1s of drift — irrelevant for one entrance, fatal for a music-bed alignment.

Write frames as `54f @30` — the value and its rate, always together.

## 3. Parallelisation

**One subagent per reference video.** This is the only meaningful speedup in stages 1-3: the work is per-file, independent and I/O-heavy, so three references finish in roughly the time of the slowest.

**The failure mode is the merge, not the analysis.** An agent returning prose ("the cuts feel quite fast, mostly on the beat") cannot be merged with two other agents' prose into numbers. So: **each agent returns structured observations and only structured observations.** Prose goes in one `notes` string per section and is never load-bearing.

Each agent is given exactly one reference path plus its `00-ingest.md` row (so `src_fps` is a given, not a discovery), the target format facts, the four rule libraries, and the instruction to use each note's **How to recognise it in a reference video** section as the test. That section is the machine-checkable detector this stage consumes — it is the test, not the agent's intuition.

### 3.1 The return schema — exact

```json
{
  "reference": "ref-b.mp4", "src_fps": 25, "duration_s": 343.6,
  "resolution": "1280x720", "coverage_s": 343.6,
  "quality": {"tier": "B", "reason": "720p re-encode, mono audio"},
  "observations": [
    { "tc": "00:01:14.320", "frame": 1858, "src_fps": 25,
      "rule_id": "cut-punch-in-emphasis", "confidence": "confirmed",
      "params": {"scale_ratio": 1.24, "ramp_frames": 0, "transform_origin_y_pct": 37,
                 "hold_s": 2.16, "measured_by": "interpupillary px 41 -> 51"},
      "evidence": "frames n=1857,1858 extracted; background scales with subject, no parallax; 'ninety' onset 74.28s (+1f)" }
  ],
  "distributions": {
    "shot_lengths_s": [1.44, 0.92, 3.10, "..."],
    "inter_word_gaps_s": [0.08, 0.31, "..."],
    "sfx_offsets_frames": [-3, -4, -2, "..."]
  },
  "negatives": [
    {"claim": "no dissolve anywhere", "method": "per-frame scene_score dump, no 0.02-0.15 plateau", "confidence": "confirmed"}
  ],
  "gaps": [{"what": "stereo placement of sfx", "why": "source is mono", "affects": "sound profile"}]
}
```

Field rules, all mandatory. `tc` is `HH:MM:SS.mmm` in the reference's own timebase; `frame` is the index at `src_fps`, for re-extraction. `confidence` is exactly one of **`confirmed`** (frames or a spectrogram were extracted and looked at), **`probable`** (a detector fired and parameters are measured, but the classification was not visually checked), **`hypothesis`** (inferred from transcript, audio or pattern alone) — the pipeline invariant made a field: *a technique not visually confirmed is a hypothesis and is labelled one.* `params` uses SI seconds and unitless ratios; frame counts appear only where the source is inherently frame-quantised, and never without `src_fps`. `evidence` names the artifact — which frames, which window, which spectrogram — so a reviewer can re-run it; "looks like a punch-in" is not evidence. `distributions` returns **raw arrays, not summaries** — medians do not merge, samples do; this is the most important field in the schema. `negatives` requires a `method`: an absence claimed without a search method is not an observation, it is silence.

### 3.2 The merge

Run the merge yourself, serially, after all agents return. Never delegate the merge.

**Step 1 — pool the distributions.** Concatenate the raw arrays across references, tagging each sample with its source. Compute median, p90 and max on the **pooled** sample *and* per reference, so disagreement is visible. Convert to target-fps frames only at the end.

**Step 2 — reconcile the per-technique rows.** For each `rule_id` present in any agent's output:

| Situation | Action |
|---|---|
| All references agree within ±15% on a parameter | Pooled median is the default; range = observed min-max |
| References disagree beyond ±15% | **Report the range and mark it `split`.** Name the per-reference values. Do not average |
| Present in 1 of 3, absent in 2 | Mark `idiosyncratic`, record which reference. Do not promote to a default |
| Present in all, measurable in only 1 | Default from the one, confidence `sparse`, note the other two as unmeasured |
| Directly contradictory (A always ramps, B never) | Two named variants plus the trigger that selects between them, if recoverable; otherwise `split` and an evidence gap |

**Never average silently.** A 1.15x and a 1.40x punch-in are not a 1.28x style — they are two styles, or one style and one outlier, and stage 4 needs to know which. A `split` row reads: `punch_scale: SPLIT 1.15 (ref-a, n=12) / 1.38 (ref-c, n=9) — do not interpolate; pick per segment energy`.

**Step 3 — weight the references.** Weighting affects *disagreement resolution and confidence*, never arithmetic on the pooled samples — a shorter reference already contributes fewer samples, so do not double-count that.

| Factor | Effect |
|---|---|
| Duration | A 5:44 reference is not half of a 14:32 one's authority — it is however many samples it produced. Report `n` per row |
| Resolution / bitrate | Below 720p, drop `confirmed` to `probable` on anything scale- or texture-dependent. Compression artifacts read as grade; never profile grain from a low-bitrate download |
| Audio quality | Mono or heavily-limited audio cannot support stereo-placement or duck-depth claims. Those are gaps, not absences |
| Aspect mismatch | A 16:9 reference contributes rhythm, motion and sound rows; its caption geometry and framing rows are **advisory only** (§6.4) |
| Transcript coverage | Unrecoverable transcript windows cannot support emphasis-rule or dead-space rows. Subtract them from `coverage_s` |

State the weighting in `PROFILE.md`'s front matter, one line per reference: `ref-c.mp4 — tier B, 854x480, coverage 401/488s, rhythm+sound authoritative, caption geometry advisory`.

**Step 4 — collect the negatives.** A negative survives into the profile only if **every** reference that could have exhibited it did not, each with a stated method. One reference's silence is a gap; three references' searched absence is a rule.

## 4. Cut detection that actually works

`ffmpeg -vf "select='gt(scene,N)'"` finds **candidates, not answers.** Treat its output as a list of places to look.

### 4.1 Two thresholds, two purposes

Verified here on a 1080x1920 file containing exactly two boundaries — a 1.25x on-axis punch-in at t=2.0 and a hard cut to unrelated content at t=4.0:

| Boundary | `lavfi.scene_score` | at `gt(scene,0.30)` | at `gt(scene,0.12)` |
|---|---|---|---|
| punch-in (1.25x, same content) | **0.161** | **missed** | caught |
| hard cut (all pixels new) | **0.687** | caught | caught |

A hard cut replaces every pixel and saturates the metric. A punch-in re-frames the same content — the subject is still there, the background is merely larger, most of the picture still correlates — so it scores roughly **4x lower on the same file**. Run two passes:

```bash
# PASS 1 — hard cuts only. This list feeds shot-length statistics and nothing else.
ffmpeg -v error -i ref.mp4 \
  -vf "select='gt(scene,0.30)',metadata=print:key=lavfi.scene_score:file=-" -an -f null - | paste - -

# PASS 2 — cuts PLUS punch-ins, same-scene changes, whip-pan boundaries. Expect false
# positives from camera movement, flash frames and hard lighting changes.
ffmpeg -v error -i ref.mp4 \
  -vf "select='gt(scene,0.12)',metadata=print:key=lavfi.scene_score:file=-" -an -f null - | paste - -
```

Sweep per file and **record the threshold beside every logged boundary** — thresholds do not transfer between files, because compression noise raises the score floor on low-bitrate material.

> Use `metadata=print:key=…:file=-`, not `showinfo`, when the shell also passes `-v error`: `showinfo` logs at info level and `-v error` silences it, while `metadata=print` writes to stdout regardless. Both routes were verified to produce identical boundary lists.
>
> `pipeline.md`'s `-vsync vfr` is deprecated in ffmpeg 6.1.1 — write `-fps_mode vfr`, or `-fps_mode passthrough` for frame extraction. Same behaviour, no warning.

### 4.2 What scene detection cannot see

- **On-axis scale changes below ~1.15x are effectively invisible even at 0.12.** Find them from the transcript — where does the delivery emphasise? — then confirm by extracting frames there. That is a *directed search*, not a detector sweep.
- **Dissolves and crossfades produce no spike at all.** Verified: a 12-frame `xfade` at 30fps peaked at `scene_score` **0.060** — below the punch-in threshold, 11x below a hard cut, and `gt(scene,0.30)` returned nothing. Find them in the per-frame dump as a low plateau, not a peak:
  ```bash
  ffmpeg -v error -i ref.mp4 \
    -vf "select='gte(scene,0)',metadata=print:key=lavfi.scene_score:file=-" -an -f null - | paste - -
  ```
  `select='gte(scene,0)'` is required: the `scene` variable is computed only when the select expression evaluates it, so a `between(t,…)` select produces no `scene_score` at all.
- **Non-cut visual events are in no MP4-derived list.** Overlay entrances, caption line changes, graphic exits: `mafd` finds change energy but cannot say whether the subject moved or the editor punched in. That census is hand-logged from frames, and `PROFILE.md` must say so.

### 4.3 Extract and look — mandatory

Every candidate from either pass gets frames extracted either side and **classified by eye**. Prefer frame indices over times; that removes fps rounding from the extraction step entirely.

```bash
# candidate at pts_time 2.03333 on a 30fps file -> n = 61
ffmpeg -v error -i ref.mp4 -vf "select='between(n,57,65)'" -fps_mode passthrough -an out/n_%03d.png

# the two frames across the boundary, 1:1 pixels, stacked for scale measurement
ffmpeg -v error -y -i ref.mp4 \
  -vf "select='between(n,60,61)',crop=1080:400:0:700,tile=1x2" -frames:v 1 pair.png
```

Never resample during cut or motion measurement — `fps=` in the chain destroys the information being measured, because a 14-frame entrance sampled at 2fps is not an entrance, it is two pictures. Contact sheets (`fps=2,scale=160:-1,tile=4x3`) are a **survey** tool for format and graphic vocabulary, never a measurement tool.

**The rule: a technique not visually confirmed is a hypothesis and is labelled one.** A candidate that fired at 0.12 and was never looked at enters the log as `probable` at best, and a `probable` row may not become a profile default on its own.

## 5. The measurements that constitute a talking-head profile

### 5.1 Shot-length distribution

From the **0.30** cut list only. Boundaries partition the runtime; shot lengths are the gaps between consecutive boundaries plus the head and tail segments.

```bash
cat > shotstats.py <<'PY'
import sys, re, statistics as st
fps = float(sys.argv[1]); dur = float(sys.argv[2])
t = sorted({float(m) for m in re.findall(r'pts_time:([0-9.]+)', sys.stdin.read())})
bounds = [0.0] + t + [dur]
lens = [round(b-a, 4) for a, b in zip(bounds, bounds[1:]) if b > a]
s = sorted(lens); p = lambda q: s[min(len(s)-1, int(round(q*(len(s)-1))))]
print(f"shots={len(lens)} cuts={len(t)} cuts_per_min={len(t)/(dur/60):.1f}")
print(f"median={st.median(lens):.2f}s ({st.median(lens)*fps:.0f}f @{fps:g}) "
      f"p90={p(0.9):.2f}s max={max(lens):.2f}s min={min(lens):.2f}s")
print("shot_lengths_s=" + ",".join(f"{x:.2f}" for x in lens))
PY

ffmpeg -v error -i ref.mp4 \
  -vf "select='gt(scene,0.30)',metadata=print:key=lavfi.scene_score:file=-" -an -f null - \
  | python3 shotstats.py 30 343.6
```

Report **median, p90, max, min, cuts/min** plus the raw `shot_lengths_s` array for the merge. Two rows make the distribution actionable: the **longest static hold** (the max, cross-checked against whether a motion event occupied it — a 9s shot with a punch-in at 4s is not a 9s hold), and the **rhythm rule**, the one sentence governing pacing, e.g. *"no shot survives past 4s without a cut, a punch-in, or a graphic entering."* Derive it from the max-gap analysis, not from taste.

### 5.2 Dead-space policy

```bash
ffmpeg -hide_banner -nostats -i ref.mp4 -af "silencedetect=noise=-40dB:d=0.20" -vn -f null - 2>&1 | grep silence_

# dead-air ratio
ffmpeg -hide_banner -nostats -i ref.mp4 -af "silencedetect=noise=-40dB:d=0.20" -vn -f null - 2>&1 \
  | awk -F'silence_duration: ' '/silence_duration/{s+=$2} END{printf "silence_s=%.3f\n", s}'
```

> `silencedetect` logs at info level: `-v error` silences it and the awk returns `0.000`. Use `-hide_banner -nostats` at the default loglevel. Verified both ways. Set `noise=` about 6-10 dB above the measured floor — get it first with `astats … | grep -E "Noise floor dB|RMS level"`. `-40 dB` is a default for clean speech, not a constant.

Start at `d=0.20` to see the whole distribution, then find its **right edge**: a cut-down reference shows almost no gaps above its policy threshold, with a spike just under it. That edge is the number you report.

| Row | How |
|---|---|
| `pause_removal_threshold` | the right edge of the gap histogram, in seconds |
| `dead_air_ratio` | summed silence ÷ runtime. Under 6% = pass run; 6-12% = partial; over 12% = untouched |
| `gap_floor_kept` | minimum surviving gap. Never zero in a good edit — typically 0.08-0.20s |
| `rhetorical_pauses_kept` | count of surviving pauses immediately before a punchline, number or reveal. Their presence is the signature of a hand-reviewed pass |

### 5.3 Punch-in vocabulary

From the **0.12** pass plus the transcript-directed search. Per event:

- **`scale_ratio`** — measure a **fixed feature** across the cut at 1:1 pixels: interpupillary distance, shoulder width, a logo. `scale_ratio = width_after / width_before`. Record the feature used; never estimate from the framing.
- **hard or ramped** — extract the 8 frames after the boundary. No intermediate scales = hard (0f); visible intermediate scales = ramped, count them. This is a signature, not a detail.
- **`transform_origin_y_pct`** — eyes staying put means the origin is above centre (~37%); eyes riding toward the top edge means frame centre.
- **`hold_s`**, **`events_per_minute`**, and **levels** — how many distinct scales recur (2 levels: 1.00/1.25; 3: 1.00/1.15/1.35).
- **transcript alignment** — offset in frames from the stressed word's onset. Within ±6f of a clause or stressed-word onset is emphasis; even intervals unrelated to content is a rhythm device. **Log which** — they reproduce differently.

### 5.4 Motion vocabulary

Extract **every frame** of a window around each event and read them in sequence: `ffmpeg -v error -i ref.mp4 -vf "select='between(n,1855,1900)'" -fps_mode passthrough -an out/m_%03d.png`.

- **Which few moves recur.** A creator's style is 4-8 moves reused, not endless invention. Name them by rule id, count occurrences.
- **Entrance / exit durations in frames** — count frames from first appearance to settled state. Report at `src_fps` *and* target fps.
- **Signature easing** — compare per-frame position deltas: front-loaded = ease-out, back-loaded = ease-in, symmetric = ease-in-out. If the element passes its resting position and settles back, log the **overshoot percentage**; that is the tell for a spring.
- **Stagger** in frames between siblings; **density** as events per minute plus the longest gap without one.
- **Negatives** — no rotation, no 3D flip, no bounce, no blur. Write them down (§5.7).

### 5.5 Caption identity

The one element measurable precisely from a single frame. Extract mid-cue frames across the whole runtime and read them.

```bash
ffmpeg -v error -y -ss 74.5 -i ref.mp4 -frames:v 1 -update 1 cue.png
# crop the caption band and zoom 2x nearest-neighbour so pixel edges stay countable
ffmpeg -v error -y -ss 74.5 -i ref.mp4 -frames:v 1 \
  -vf "crop=iw:ih*0.16:0:ih*0.68,scale=iw*2:ih*2:flags=neighbor" -update 1 capband.png
```

| Row | Measurement |
|---|---|
| **Mode** | word-level (1-2 words) / phrase-level (full clause held) / hybrid. Check whether one word is highlighted inside a held phrase — that active-word treatment is the most common signature |
| **Cap height** | measured on a flat-topped capital (`H`, `T`, `E` — never `O` or `A`), reported as `cap_height / frame_height` %. Also report x-height %, which governs legibility. Never points; there is no inch in this pipeline |
| **Position** | bottom of the lowest glyph as % from frame bottom — not the plate. A baseline drifting 1-2% between cues was positioned by eye per cue; a logged jump is a **dodge**, and the trigger must be recorded, not just the two positions |
| **Box extents** | max box width as % of frame width, side margins as % |
| **Active-word treatment** | colour swap / scale pop / underline / box; duration in frames; whether it leads or trails the word's audio onset |
| **Emphasis rule** | *which words* get lifted — nouns, numbers, promise words, negations. Recover the **rule**: a rule reproduces, a word list does not. Then count — if more than a small fraction of words are emphasised, the emphasis means nothing |
| **Timing model** | min/max cue duration, inter-cue gap, chars per line, lines, reading speed in cps, and crucially **whether cues break at cuts or ride through them** |
| **Plate / stroke / shadow** | a plate is the tell that contrast was solved structurally rather than with a stroke |

### 5.6 Sound

```bash
ffmpeg -v error -y -i ref.mp4 -vn -ac 2 -ar 48000 ref.wav
ffmpeg -v error -y -i ref.wav -lavfi "showwavespic=s=1600x300:colors=white" wave.png   # survey
ffmpeg -v error -y -ss 74.0 -t 1.2 -i ref.wav \
  -lavfi "showspectrumpic=s=1024x512:legend=1:mode=combined:color=intensity:scale=log" spec.png
ffmpeg -hide_banner -nostats -i ref.wav -af ebur128=peak=true -f null - 2>&1 | tail -12
ffmpeg -v error -i ref.wav \
  -af "astats=metadata=1:reset=24,ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" \
  -f null - | paste - -      # level curve over time — the ducking measurement
```

An agent cannot listen but it can look. Survey with `showwavespic` across the whole file, then `showspectrumpic` one window per event: a whoosh sweeps, a riser climbs, an impact is a vertical broadband stripe with a decaying tail, a tonal sting is a horizontal line. `legend=1` is what makes the picture measurable; windows rather than whole files are what make it precise. **Pair every audio timecode with the frame extracted at the same timecode** — an effect on the cut and one 4 frames after it are different techniques.

| Row | How |
|---|---|
| `sfx_per_minute` | count of audible effects ÷ runtime |
| Style balance | share of `sfx/diegetic` / `sfx/motion` / `sfx/aesthetic`. **This ratio is the sonic identity** — reproduce the ratio, not just the individual sounds. Diagnostic: motion-only and no aesthetic reads flat; aesthetic-only and no diegetic reads cheap; motion effects on things that are not moving reads cluttered |
| `sfx_offset_frames` | lead / on / trail per effect relative to picture. A consistent slip is a signature — report the distribution, not the mean |
| Music under dialogue | windowed RMS of the bed during speech vs between speech, differenced. That is the duck depth in dB. "The music gets quieter" is not a spec |
| Ducking | present/absent, plus attack and release in frames if a ramp is visible in the level curve |
| Programme loudness | integrated LUFS, LRA, true peak from `ebur128` |
| Palette | the recurring sounds, each with a tested Epidemic query, so the identity is reachable next time |

Spectral numbers (`aspectralstats` centroid, flatness) are usable **only comparatively** — this effect against that one, within one file. An absolute spectral target is a spec that cannot be checked.

### 5.7 The negatives

As diagnostic as the positives, and cheaper to verify. Each needs a **stated search method** and must survive across all references (§3.2 step 4).

| Negative row | Method that supports it |
|---|---|
| No dissolves / crossfades | per-frame `scene_score` dump; no 0.02-0.15 plateau found anywhere |
| No rotation / 3D / bounce | every motion event read frame-by-frame; no non-monotonic position track, no overshoot |
| No music, or none under dialogue | `showspectrumpic` over speech windows shows no steady bed |
| No captions above frame centre | every mid-cue still measured; baseline range recorded |
| No punch-in past 1.30x | pooled `scale_ratio` max |
| No hold longer than Ns without an event | max-gap analysis (§5.1) plus the hand-logged non-cut event list |

Write them as constraints stage 4 can be checked against, not as prose observations.

## 6. Vertical-specific measurements

The deliverable is 9:16 Instagram. Three constraints stack and they are **not the same constraint**: broadcast safe area is a manufacturing tolerance, platform UI is an occlusion, composition collision is internal.

### 6.1 The bands

| Band | Default | Range | Note |
|---|---|---|---|
| `platform_bottom_band` | 18% of frame height (~340px of 1920) | 14-22% | Caption/handle/CTA stack. Treat TikTok and Shorts the same unless measured |
| `platform_top_band` | 13% (~250px of 1920) | 10-16% | Profile/header row |
| `platform_right_band` | 16% of frame **width** | 12-20% | The vertical action rail |
| `graphics_safe_inset` | 5% every edge | 5% | EBU R 95 |
| `action_safe_inset` | 3.5% every edge | 3.5% | EBU R 95 |

**Author every offset as a percentage of frame HEIGHT** — not width (correct at 16:9, ~78% too large at 9:16), not the diagonal (wrong at both), never points, never absolute pixels. Height is the right denominator because on a phone in portrait the frame's height is what fills the screen.

### 6.2 Verify the bands against the reference, visually

```bash
ffmpeg -v error -y -ss 74.5 -i ref.mp4 -frames:v 1 -vf "\
drawbox=x=0:y=0:w=iw:h=ih*0.13:color=red@0.35:t=fill,\
drawbox=x=0:y=ih*0.82:w=iw:h=ih*0.18:color=red@0.35:t=fill,\
drawbox=x=iw*0.84:y=0:w=iw*0.16:h=ih:color=orange@0.30:t=fill,\
drawbox=x=iw*0.05:y=ih*0.05:w=iw*0.90:h=ih*0.90:color=lime@1.0:t=4" -update 1 safe.png
```

If any glyph falls under a red or orange band, the reference was cut for a different surface — record that, and do **not** copy its caption position.

### 6.3 Captions and face framing in 9:16

- **Caption baseline, 9:16 in-feed:** 20% of frame height from the bottom (384px at 1920), range 16-26% — clears the ~18% platform band with margin. The 16:9 equivalent is 8-14%: **different numbers, not a scaled version of each other.**
- **In-feed type floors run ~60% higher than full-screen floors** — body ≥32px, headlines ≥90px, labels ≥24px at 1080 wide. State which viewing context a measurement was taken for.
- **Zone separation** ≥4-6% of frame height between any two simultaneously visible text objects; check the caption band against the motion design's lower thirds. A caption under a lower third is the most common avoidable defect.
- **Face framing.** Record eyeline as % from the top (usually 30-38%, the upper third), head-to-frame-height ratio, and headroom above the crown. The 9:16 frame is tall, so a face shot for 16:9 leaves large dead zones above and below — log what the reference puts there (captions, B-roll insert, graphic, nothing). Those dead zones are a **compositional decision** in this format and belong in the profile.
- **Right-rail avoidance.** Centred captions must be narrower than `1 - platform_right_band`; an element that would land in the right 16% is displaced, not scaled.

### 6.4 A 16:9-borrowed technique may not survive the crop

If any reference is 16:9 — the KT set is 1280x720 and 854x480 — its rows split in two:

| Transfers from 16:9 | Does **not** transfer |
|---|---|
| Shot-length distribution, cuts/min, rhythm rule | Caption position and box extents |
| Dead-space policy, pause thresholds | Face framing, eyeline, headroom |
| Motion durations, easing, stagger, overshoot | Anything horizontal: whip pans, side-entrances, split screens |
| Sound density, style balance, offsets, duck depth | Punch-in **headroom caps** — a 1.4x that survives at 854x480 does not survive a 1080x1920 delivery |
| Emphasis rule (which words) | Cap height %, which must be re-derived for the target height |

Mark every non-transferring row `advisory (16:9 source)` in `PROFILE.md`. Resolution-headroom caps are stated against **delivery** resolution — that is the number that matters. And these are teaching downloads, not camera masters: banding and blocking belong to the encoder, so **never profile grain or texture from them.**

## 7. Confidence and evidence gaps

A section built on two observations is not the same as one built on forty, and a profile that hides the difference fails in a render rather than in review. **Every profile section carries a confidence marker**, computed, not felt:

| Marker | Test |
|---|---|
| `high` | ≥15 `confirmed` observations, present in ≥2 references, pooled range within ±15% |
| `medium` | 5-14 `confirmed` observations, or ≥15 with a `split` range |
| `sparse` | <5 observations, or present in only 1 reference, or all rows `probable` |
| `hypothesis` | no visually confirmed observation. **May not become a stage-4 default** — stage 4 must ask, or use the rule note's own default and mark the row `ad-hoc` |

Every row also carries `n`, the observation count. A default with `n=2` and one with `n=41` are different objects; the profile must not present them identically.

**`PROFILE.md` ends with a mandatory `Evidence gaps` section** — not optional, not omitted when it looks short. One line each for: every `sparse` or `hypothesis` row and what would resolve it (which measurement, on which reference, in which window); every `split` row with both values and their sources; every capability the source material cannot support (mono audio → no stereo placement; missing transcript windows → no emphasis rule over them; 16:9 source → no caption geometry; low bitrate → no texture claims); and every technique searched for and neither confirmed nor ruled out. Review starts here rather than discovering it in a render. A profile with an empty evidence-gaps section is not complete, it is unaudited.

## 8. Where the profile is written, and what happens next

```
_profiles/<name>/
├── 00-ingest.md            # probe table, target format, transcripts, fps per file, weighting
├── 01-observed-cuts.md     # timecode | rule id | confidence | params | evidence | src_fps
├── 01-observed-motion.md
├── 01-observed-sound.md
├── 01-observed-subtitles.md
└── PROFILE.md              # from _templates/style-profile.md
```

`00-ingest.md` carries the probe table (§2), the target format facts, the normalised transcripts as `[HH:MM:SS.mmm] text`, and the per-reference quality tier and weighting from §3.2 step 3. If a transcript is mixed-language, keep the original **and** an English translation side by side: the original carries the delivery rhythm, the translation carries the meaning. The `01-observed-*.md` files hold the merged logs, one per skill, split exactly as the routers' Mode A specifies so each skill can be re-run independently — keep every row, and put the distribution arrays here too; this is the audit trail, so nothing gets summarised away. `PROFILE.md` is filled from `_templates/style-profile.md`: every cell gets a value, a range and a confidence, the `Never does` and `Evidence gaps` sections are mandatory rather than decorative, and the vertical rows from §6 are added to the caption identity block.

**Handoff into stage 4 (DESIGN).** Hand over `PROFILE.md` and nothing else — the observation logs stay available, but stage 4 reads the profile or the condensing was wasted.

1. **Stop and get a human read of the evidence gaps** before any design document is written. A `sparse` caption row is cheap to fix now and expensive after a render.
2. Stage 4 runs the four design documents in fixed order: **cuts → motion → sound → subtitles.** Cuts define the timeline everything attaches to; motion needs cut boundaries; sound needs both, since motion effects are timed off motion events; subtitles last, because emphasis treatments key off the cuts and the motion.
3. Every design row cites a rule note and resolves its parameters **from the profile, not from the note's defaults.** Where the profile is `split`, the row states which branch it took and why; where it is `hypothesis`, the row is marked `ad-hoc` so review catches it.
4. Re-express every profile seconds value as frames at the project fps **once**, at the top of the design document, and use those frames throughout.

## Commands verified in this container

ffmpeg/ffprobe **6.1.1-3ubuntu5**, against a synthetic 1080x1920 30fps asset carrying a 1.25x on-axis punch-in at t=2.0, a hard cut at t=4.0, a 12-frame `xfade`, tone/silence audio, and a 60fps re-encode of the same content.

**Executed here, output as quoted:** the `ffprobe` probe (default and JSON forms) and the ingest-table loop · `gt(scene,0.30)` and `gt(scene,0.12)` with `metadata=print` (0.687 / 0.161) · `gte(scene,0)` per-frame dump (dissolve peak 0.060, missed entirely at 0.30) · `scdet=threshold=0` dump · `showinfo` vs `metadata=print` loglevel behaviour (identical boundary lists) · `between(n,…)` extraction, inclusive both ends · `crop`+`tile` frame pairs · `crop`+`scale=flags=neighbor` caption-band zoom · the `drawbox` safe-area overlay (composited and read back visually) · `silencedetect` plus the dead-air `awk` one-liner, **including its `-v error` failure** · `astats` summary and windowed `reset=24` RMS curve · `ebur128=peak=true` · `showwavespic` · wav extraction · `shotstats.py` against both cut-list routes · fps-invariance of `pts_time` across the 30/60fps pair.

**Not executed here, carried from `_meta/execution-contract.md` §7A:** `showspectrumpic` (verified there, with visual read-back) · `aspectralstats` · `blackdetect` / `freezedetect` / `thumbnail` (present in `-filters`, not swept) · `librosa` (not installed; installable).
