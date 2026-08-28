---
name: timebase
description: The two-clock problem in subtractive talking-head edits. Defines SOURCE vs OUTPUT timecode, the keep-list data model, the exact src/out mapping functions, frame-integer storage rules, the design-cuts.md EDL contract, transcript re-timing, and pre-render verification. Read before designing any cut, sound cue, caption, or motion beat.
type: reference
---

# Timebase: SOURCE vs OUTPUT timecode

## 0. The one rule

A talking-head edit is **subtractive**: you remove dead space, filler, retakes and pauses. Every removal
shifts every downstream timestamp earlier. Therefore:

> **Cuts are designed in SOURCE timecode. Sound, captions and motion are designed in OUTPUT
> timecode, and only after the cut list is locked.**

Violating this produces a misalignment that reads as *bad taste* rather than as a *bug*, so it survives
review and ships. There is no error message. That is why this file exists.

Precedent in this vault: a prior project warns "use `vo_*`, never the raw transcript numbers," because a TTS
narration was speed-boosted — one global time warp. Talking head is strictly worse: many *local* warps, one
per removal, and they accumulate.

## 1. The two clocks

| Clock | Definition | What is stamped against it |
|---|---|---|
| **SOURCE** | Position in the original camera file. `0` = first frame recorded. | Transcript / ASR output, cut decisions, keyframe positions, retake notes |
| **OUTPUT** | Position in the finished cut. `0` = first frame the viewer sees. | Sound effects, music hits, caption cues, punch-ins, overlays, render duration |

Equal only at output frame 0, and only if nothing was removed from the head. They diverge monotonically:
OUTPUT time is always ≤ SOURCE time.

### 1.1 Worked example — drift accumulating across three removals

Source: 10:00.000 @ 30 fps = 18000 frames. Three removals:

| # | What | src in | src out | removed |
|---|---|---|---|---|
| R1 | dead air before first word | 00:00.000 | 00:01.400 | 1.400 s (42 f) |
| R2 | filler "um, so basically" | 01:37.200 | 01:38.100 | 0.900 s (27 f) |
| R3 | retake of the same line | 03:05.000 | 03:05.900 | 0.900 s (27 f) |
| | | | **total** | **3.200 s (96 f)** |

The surviving keep list with its cumulative offset:

| keep | src_in (f) | src_out (f) | len (f) | out_in (f) | **offset = src_in − out_in** |
|---|---|---|---|---|---|
| K1 | 42 | 2916 | 2874 | 0 | 42 |
| K2 | 2943 | 5550 | 2607 | 2874 | 69 |
| K3 | 5577 | 18000 | 12423 | 5481 | 96 |

Output = 2874 + 2607 + 12423 = **17904 f = 596.800 s = 09:56.800**; and 600.000 − 3.200 = 596.800 ✔.
`offset` is exactly the footage removed before that keep.

Now place three sound cues, each designed *while watching the source* and written into the sound doc as a
source timestamp. "Naive" = the assembler treats that number as output time:

| cue | designed at SOURCE | correct OUTPUT | naive placement | **error** |
|---|---|---|---|---|
| A — whoosh on the head turn | 00:20.000 (f600) | 00:18.600 (f558) | 00:20.000 | **1.400 s late** |
| B — impact on the key point | 02:30.000 (f4500) | 02:27.700 (f4431) | 02:30.000 | **2.300 s late** |
| C — riser under the CTA | 04:12.000 (f7560) | 04:08.800 (f7464) | 04:12.000 | **3.200 s late** |

The error grows with each removal crossed (1.4 → 2.3 → 3.2 s). **Diagnostic signature: if early cues look
nearly right and late cues look badly out, this is a two-clock bug, not a taste problem.** A *constant*
offset is a different bug (§9). At 30 fps, 1.4 s is 42 frames — a sound effect 42 frames off a visual accent
reads as "the designer chose a weird spot."

## 2. The invariant, and why cuts are stage one

```
STAGE 1  cut design                -> SOURCE timecode -> produces the keep list
         [LOCK] build the map from the keep list
STAGE 2  transcript re-time        -> OUTPUT timecode
STAGE 3  sound / captions / motion -> OUTPUT timecode
STAGE 4  assemble + verify
```

**Structural, not stylistic.** The SOURCE→OUTPUT map is *defined by* the keep list. Before the keep list
exists, OUTPUT timecode does not exist, so no sound cue, caption or motion beat can even be expressed.
Designing sound first does not merely risk rework — it produces numbers with no referent.

**Corollary: changing the cut list invalidates every downstream timestamp.** If a cut is added, removed or
nudged after stage 3, push each downstream timestamp through `out_to_src` against the *old* map, then
`src_to_out` against the *new* map. Never hand-patch "everything after here moved 0.9 s" — cues straddling
the changed region need different treatment from cues after it, and the hand-patch silently gets that wrong.

## 3. The keep list is the single source of truth

Model an edit as an **ordered list of kept SOURCE ranges**, half-open, in integer frames: `keeps = [(src_in,
src_out), ...]`.

Invariants — assert on load, because a violated invariant is a silent wrong map: `src_out > src_in`; sorted
and non-overlapping (`keeps[i].src_in >= keeps[i-1].src_out`); all `int` at one declared fps.

- `output_duration = sum(b - a for a, b in keeps)` — exactly, no rounding.
- The map is a **piecewise offset**: within keep `i`, `out = src - offset[i]`, where `offset[i] =
  src_in[i] - out_in[i]` and `out_in[i] = sum of lengths of keeps 0..i-1`. `offset` is non-decreasing.
- **"Cut at 01:37.2" is not a keep list.** Cut points alone do not say which side survives, how
  long the removal is, or whether head and tail are kept. See §5.

### 3.1 Reference implementation

Precompute `out_ins` once (the cumulative-offset table) and `bisect` both directions: O(log n) per lookup,
which matters because a 10-minute talking head has 100–200 keeps and caption generation calls the map
thousands of times.

```python
from bisect import bisect_right

class TimeBase:
    """Maps SOURCE frames <-> OUTPUT frames for a subtractive edit.
    keeps: ordered, non-overlapping, half-open [src_in, src_out) integer frame ranges."""

    def __init__(self, keeps, fps_num=30, fps_den=1):
        ks = [(int(a), int(b)) for a, b in keeps]
        for i, (a, b) in enumerate(ks):
            if b <= a:
                raise ValueError(f"keep {i} empty or inverted: {(a, b)}")
            if i and a < ks[i - 1][1]:
                raise ValueError(f"keep {i} overlaps or is out of order: {(a, b)}")
        self.keeps, self.fps_num, self.fps_den = ks, fps_num, fps_den
        self.src_ins = [a for a, _ in ks]
        self.out_ins, acc = [], 0
        for a, b in ks:                          # cumulative-offset table
            self.out_ins.append(acc)
            acc += b - a
        self.total = acc                         # total OUTPUT frames

    # unit conversion: always round(), never int()/floor -- see §4
    def f2s(self, f):  return f * self.fps_den / self.fps_num
    def s2f(self, s):  return round(s * self.fps_num / self.fps_den)

    def src_to_out(self, tf, at_cut="strict"):
        """SOURCE frame -> OUTPUT frame, or None if tf was removed.
        at_cut='strict': frame in a removed gap -> None
        at_cut='next'  : frame in a removed gap -> where the NEXT kept frame lands"""
        i = bisect_right(self.src_ins, tf) - 1
        if i < 0:
            return None                          # before the first kept frame
        a, b = self.keeps[i]
        if tf < b:
            return self.out_ins[i] + (tf - a)    # inside keep i
        if at_cut == "next":
            return self.out_ins[i] + (b - a)     # == out_in of the next keep
        return None                              # inside a removed gap

    def out_to_src(self, of):
        """OUTPUT frame -> SOURCE frame. Always defined on [0, total]."""
        if not (0 <= of <= self.total):
            raise ValueError(f"out frame {of} outside [0,{self.total}]")
        if of == self.total:
            return self.keeps[-1][1]             # exclusive end of the edit
        i = bisect_right(self.out_ins, of) - 1
        a, _ = self.keeps[i]
        return a + (of - self.out_ins[i])
```

### 3.2 Direction asymmetry and the boundary case

`out_to_src` is **total** — every output frame came from exactly one source frame. `src_to_out` is
**partial** — removed frames have no output position, so it returns `None`. Callers must handle `None`;
never coerce it to `0` or to the previous value.

The boundary case is `tf == src_out` of some keep: the first *removed* frame, and exactly where a human
writes a cut point. Ranges are half-open, so it is **not** in the output. Choose per call site:

| caller | mode | result |
|---|---|---|
| "is this source frame visible?" | `strict` → `None` | truthful; the frame was cut |
| "a design mark fell in a gap — where does it go?" | `next` → start of next keep | snaps forward to surviving material |

With the §1.1 list, `src_to_out(2916)` is `None` under `strict` and `2874` under `next`. Round-tripping is
exact in the always-defined direction: `src_to_out(out_to_src(o)) == o` for every `o` in `[0, total)`.

## 4. Store integer frames, not float seconds

### 4.1 Truncation is the real killer, not float64 precision

Summing 140 float-second durations accumulates ~`2e-13 s` (~6e-12 frames) over a 10-minute edit. **Float64
magnitude error is not the problem** — do not justify the frame rule with it. The problem is that `f/fps`
often lands one ULP *below* an integer on the way back, so `int()` / `floor()` drops a whole frame. Measured
over frames 0–17999:

| fps | `int(f/fps*fps) != f` | `round(f/fps*fps) != f` |
|---|---|---|
| 30 | **404 of 18000 (2.2 %)** | 0 |
| 30000/1001 | **622 of 18000 (3.5 %)** | 0 |

Each mismatch is a full frame, and truncation is **one-directional** — it only ever loses time, so it
accumulates: truncating instead of rounding at 140 keep boundaries lost **4 frames (0.133 s)** in a measured
run. **Rule: `round()` at every seconds↔frames conversion; never `int()`, `floor()` or `//`.**

### 4.2 29.97 (30000/1001), honestly

Use `fps_num=30000, fps_den=1001`. A frame duration of `1001/30000 s` is not exactly representable in
binary, so exact equality on seconds never holds. Measured:

- **Safe — `round(seconds * 30000/1001)` recovers the exact frame index.** Zero failures over the
  first 5,000,000 frames (≈46 h). A vertical video is nowhere near a boundary.
- **Safe — millisecond-precision transcript timestamps.** Rounding a 3-decimal second to a frame
  gave 0 mismatches over 18000 frames. ASR at ms precision is fine for cuts *and* cues.
- **Not safe — 0.1 s-precision timestamps.** 12000 of 18000 exact frame times round to the wrong
  frame (max error 1 frame, 33 ms). Fine for a caption; **not** for a cut boundary, since the keep
  list then no longer describes the file you will assemble.
- **Where it genuinely accumulates — assuming 30 when the file is 30000/1001.** A 0.1 % rate error
  on *absolute* position, so it grows without bound:

| elapsed | true (30000/1001) | assumed 30 | drift |
|---|---|---|---|
| 1 min | 59.993 s | 59.933 s | 0.060 s (1.8 f) |
| 5 min | 300.000 s | 299.700 s | 0.300 s (9.0 f) |
| 10 min | 599.999 s | 599.400 s | **0.599 s (18 f)** |

Indistinguishable at a glance from two-clock drift, and the most common way a "correct" map is still wrong.
**Never assume fps — probe it and store the exact rational:**

```bash
ffprobe -v error -select_streams v:0 \
  -show_entries stream=r_frame_rate,avg_frame_rate,time_base,nb_frames \
  -of default=nw=1 SOURCE.mp4
# r_frame_rate=30000/1001   <- store numerator/denominator, never 29.97
```

Drop-frame *timecode labels* (`;` separators, skipped labels at minute boundaries) are display convention
only; they never change frame counts or durations. Do arithmetic in frame indices, render a drop-frame label
only for display, and never parse one back into a keep list.

## 5. The EDL contract for `design-cuts.md`

The only artifact stage 2+ may read. It must allow rebuilding the map with **zero inference**: a header,
then one row per **kept** range in output order.

```markdown
source: raw/interview_A.mov
fps: 30000/1001          # exact rational, from ffprobe r_frame_rate
source_frames: 17982     # ffprobe nb_frames (verify with -count_frames)

| # | src_in | src_out | len  | out_in | src_in_tc | src_out_tc | note                    |
|---|--------|---------|------|--------|-----------|------------|-------------------------|
| 1 | 42     | 2916    | 2874 | 0      | 00:01.400 | 01:37.200  | trimmed dead air (head) |
| 2 | 2943   | 5550    | 2607 | 2874   | 01:38.100 | 03:05.000  | cut "um, so basically"  |
| 3 | 5577   | 18000   | 12423| 5481   | 03:05.900 | 10:00.000  | cut retake of same line |

output_frames: 17904      # == sum(len) == last out_in + last len
output_duration: 596.800s
```

| col | unit | rule |
|---|---|---|
| `#` | int | keep index, 1-based, contiguous |
| `src_in` | frames | **inclusive** |
| `src_out` | frames | **exclusive** |
| `len` | frames | `src_out - src_in`; redundant on purpose, as a checksum |
| `out_in` | frames | running total of previous `len`s; row 1 is `0` |
| `*_tc` | `MM:SS.mmm` | human display only; **never parsed** |
| `note` | text | why the *preceding* gap was removed (filler / retake / pause / dead air) |

- **Record kept ranges, not cut points.** A doc that only says "cut at 01:37.2" cannot become a
  map, and everything downstream then rests on a guess that is invisible in the render.
- Write `out_in` explicitly rather than recomputing downstream — it is the redundancy that lets a
  reader detect a dropped or reordered row.
- If `sum(len) != output_frames`, or any `out_in` disagrees with the running total, **stop**.
- Frame columns are authoritative; if `*_tc` disagrees, the frames win and the tc is regenerated.

## 6. Transcript re-timing

The transcript is stamped in SOURCE time; captions need OUTPUT time. Re-stamp once, right after the cut list
locks, into a *separate* file (`transcript.out.json`). Never edit the source transcript in place — you lose
the ability to re-time after a cut change.

1. **Cue wholly inside a removed gap → drop it.** No output position exists.
2. **Cue straddling cut boundaries → split.** Intersect the cue with every keep; each non-empty
   intersection becomes its own output cue (a cue spanning two removals yields up to three
   fragments). Do not "trim to the nearest surviving edge and keep one cue" — that silently
   re-attributes speech to the wrong moment.
3. **Re-base word timings inside each fragment individually** through `src_to_out`. Do not apply
   the cue's offset to its words: a fragment lies within one keep, but a *cue* can span keeps with
   different offsets.
4. **A word bisected by a cut** — decide by surviving fraction:
   - **< 50 % survives → drop the word**, from `words` *and* from the fragment text. A 40 ms stub
     of a 340 ms word is a click, not a word; captioning it shows text with no audible referent.
   - **≥ 50 % survives → keep it**, clamped to the fragment bounds, with its full text.
   - Exactly 50 % → keep. One deterministic rule everywhere, so re-runs are stable.
5. **Drop sliver fragments** below `min_frames` (default 1; for captions prefer ~6 f / 200 ms).
6. Assert: cues sorted, `0 <= start < end <= output_duration`, no overlaps.

```python
def retime_cues(cues, tb, min_frames=1, min_word_frames=1):
    """cues: [{'text','start','end','words':[{'w','start','end'}]}] in SOURCE seconds.
    Returns cues in OUTPUT seconds, split at cut boundaries."""
    out = []
    for cue in cues:
        cs, ce = tb.s2f(cue["start"]), tb.s2f(cue["end"])
        words = cue.get("words") or []
        for ka, kb in tb.keeps:                     # intersect cue with each keep
            a, b = max(cs, ka), min(ce, kb)
            if b - a < min_frames:
                continue                            # wholly in a gap, or a sliver
            kept_words, txt = [], []
            for w in words:
                ws, we = tb.s2f(w["start"]), tb.s2f(w["end"])
                wa, wb = max(ws, a), min(we, b)
                if wb <= wa:
                    continue                        # word outside this fragment
                surviving = wb - wa
                if surviving < min_word_frames or surviving * 2 < (we - ws):
                    continue                        # bisected, <50% survives -> drop
                kept_words.append({"w": w["w"],
                                   "start": tb.f2s(tb.src_to_out(wa)),
                                   "end":   tb.f2s(tb.src_to_out(wb - 1) + 1)})
                txt.append(w["w"])
            out.append({
                "text":  " ".join(txt) if words else cue["text"],
                "start": tb.f2s(tb.src_to_out(a)),
                "end":   tb.f2s(tb.src_to_out(b - 1) + 1),
                "words": kept_words,
                "split": not (a == cs and b == ce),
            })
    return out
```

Note the end-frame idiom `src_to_out(b - 1) + 1`: `b` is exclusive and may itself be a cut point (where
`src_to_out` is `None` under `strict`), so map the last *included* frame and add one. Passing an exclusive
end straight to `src_to_out` is a common source of spurious `None`.

## 7. Verification before render

Run all four. They are cheap and catch a broken map while it is still fixable.

**V1 — duration identity.** Assembled video frame count must equal `sum(len)` exactly. `-count_frames`
decodes the whole file (slow but exact); `stream=nb_frames` is the container's claim and may be absent or
wrong — do not trust it here.

```bash
ffprobe -v error -select_streams v:0 -count_frames \
  -show_entries stream=nb_read_frames -of default=nw=1:nk=1 OUT.mp4
# must equal output_frames from design-cuts.md
```

**V2 — round-trip identity.** Pure arithmetic, no render needed:

```python
assert tb.total == sum(b - a for a, b in tb.keeps)
assert all(tb.src_to_out(tb.out_to_src(o)) == o for o in range(tb.total))
```

**V3 — landmark round-trip.** Pick a landmark with an unambiguous single-frame signature: a clap, a hand
entering frame, the first frame of a specific spoken word. Map it, compare pixels.

```bash
# the landmark in SOURCE, at a known source frame
ffmpeg -nostdin -y -i SOURCE.mp4 -vf "select='eq(n\,7560)'" \
  -fps_mode passthrough -frames:v 1 -update 1 land_src.png

# the frame the map predicts in OUTPUT
ffmpeg -nostdin -y -i OUT.mp4 -vf "select='eq(n\,7464)'" \
  -fps_mode passthrough -frames:v 1 -update 1 land_out.png

# compare with PSNR -- OUT.mp4 is re-encoded, so md5 will never match
ffmpeg -nostdin -hide_banner -i land_src.png -i land_out.png -lavfi psnr -f null - 2>&1 \
  | grep -o "average:[0-9.]*"
```

At CRF 18: correct frame **42.1 dB**, off-by-3-frames 15.6 dB, off-by-96 12.9 dB. Absolute PSNR depends on
encode quality, so **do not use a bare threshold** — sweep, and require the predicted frame to be a clear
*peak*. On a deliberately awful encode (CRF 34, `-preset ultrafast`) the correct frame scores only 31.2 dB,
yet the peak is still unmistakable:

| offset from predicted | −6 | −3 | −1 | **0** | +1 | +3 | +6 | +96 |
|---|---|---|---|---|---|---|---|---|
| PSNR (dB) | 15.0 | 15.8 | 20.2 | **31.2** | 20.5 | 15.9 | 15.2 | 13.6 |

Pass criteria: sweep maximum is **at offset 0** and beats its nearest neighbour by **≥ 5 dB**. If the peak
sits at a non-zero offset, that offset *is* your drift in frames — read the bug straight off the table. No
peak at all means the landmark is not single-frame-distinctive (a static head between gestures); pick
another. Never `md5sum` a source frame against a re-encoded output frame — it always differs; `md5sum` is
valid only between two frames of the *same* file, or under stream copy.

**V4 — spot-check three sound cues.** Take the first, a middle, and the **last** cue from the sound doc (in
OUTPUT time) and confirm the visual event is there. Check the last one especially: a two-clock bug is
smallest at the head and largest at the tail, so a head-only check passes on a broken map.

```bash
ffmpeg -nostdin -y -ss 00:04:08.800 -i OUT.mp4 -frames:v 1 -q:v 2 -update 1 cue_C.jpg
```

Input-seek (`-ss` before `-i`) is frame-accurate in ffmpeg 6.1 — verified byte-identical to
`select='eq(n,N)'` on the same file. `-noaccurate_seek` disables that and snaps to a keyframe; never use it
for verification. `ffprobe -read_intervals` is *not* frame-accurate (it seeks to the preceding keyframe —
observed `pts_time=2.023` for a request at `00:00:03`), so extract with `ffmpeg -ss`.

## 8. ffmpeg assembly must produce exactly the kept ranges

The map is a prediction; it is true only if the assembler cuts where the map says.

> `-ss` / `-to` with `-c copy` **cannot** cut mid-GOP. It snaps the in-point back to the preceding
> keyframe and lengthens the segment. **No warning is printed.**

Measured on a 30 fps H.264 file with a keyframe every 1.6 s, requesting src 7.500 → 9.500 (exactly 2.000 s /
60 frames):

| method | frames | duration | error |
|---|---|---|---|
| `-ss 7.5 -to 9.5 -c copy` | **95** | **3.251 s** | **+1.1 s of extra head** |
| `-ss 7.5 -to 9.5 -c:v libx264` | 60 | 2.000 s | none |

1.1 s per keep across 140 keeps is not rounding — it is a different edit. Pick a strategy explicitly.

### 8.1 Re-encode (default — use this)

Frame-exact and single-pass. Build the filter from the keep list with **half-open frame ranges**,
`between(n, src_in, src_out - 1)`:

```bash
ffmpeg -nostdin -y -i SOURCE.mp4 \
  -vf "select='between(n,42,2915)+between(n,2943,5549)+between(n,5577,17999)',setpts=N/FRAME_RATE/TB" \
  -af "aselect='between(t,1.400000,97.199999)+between(t,98.100000,184.999999)+between(t,185.900000,599.999999)',asetpts=N/SR/TB" \
  -c:v libx264 -crf 18 -preset medium -pix_fmt yuv420p \
  -c:a aac -b:a 192k -fps_mode passthrough OUT.mp4
```

Generate the expressions, never hand-type them:

```python
vsel = "+".join(f"between(n,{a},{b-1})" for a, b in tb.keeps)
asel = "+".join(f"between(t,{tb.f2s(a):.6f},{tb.f2s(b)-1e-6:.6f})" for a, b in tb.keeps)
```

**Trap — `between()` is inclusive on both bounds.** `between(t, src_in_s, src_out_s)` on seconds yields one
extra frame *per range*: a measured 3-range cut produced 168 frames where the map said
165. Use `between(n, a, b-1)` on frame numbers for video, and subtract `1e-6` from the upper bound
for the seconds-based `aselect`. Verified: the frame form gave exactly 165, and the §1.1 keep list run
against a real 18000-frame source gave exactly **17904 frames / 596.800 s**.

`setpts=N/FRAME_RATE/TB` and `asetpts=N/SR/TB` are **mandatory** — `select` drops frames but leaves the
original timestamps, so without them the output carries source PTS and every downstream tool re-derives the
wrong duration.

Expect audio duration to differ from video by up to one AAC frame (~21 ms at 48 kHz; measured 14.280 s audio
vs 14.300 s video). That is codec granularity, not drift — judge V1 against the **video** stream's frame
count, never the audio duration.

### 8.2 Snap the keep list to keyframes *before* building the map

Only if stream copy is genuinely required (huge files, no time to re-encode). The order is not negotiable:
snap first, rebuild the map from the snapped list, then design. Snapping *after* designing reintroduces the
exact bug this file is about.

```bash
# keyframe positions in SOURCE seconds
ffprobe -v error -select_streams v:0 -skip_frame nokey \
  -show_entries frame=pts_time -of csv=p=0 SOURCE.mp4
```

```python
kf = sorted(tb.s2f(float(x)) for x in kf_seconds)   # keyframes as SOURCE frames
def snap(keeps, kf):
    from bisect import bisect_right, bisect_left
    out = []
    for a, b in keeps:
        a2 = kf[bisect_right(kf, a) - 1]            # in-point: back to prev keyframe
        j  = bisect_left(kf, b)
        b2 = kf[j] if j < len(kf) else b            # out-point: forward to next keyframe
        out.append((a2, b2))
    return out                                     # then merge overlaps, rebuild TimeBase
```

Snapped keeps are longer than designed, so re-run cut review — the snap can drag filler or a retake back
into the edit. Merge now-overlapping ranges before constructing `TimeBase`, or its overlap invariant will
(correctly) reject the list.

### 8.3 Per-segment + concat demuxer

Frame-exact **only if each segment is re-encoded**. Verified: a three-range list assembled this way produced
exactly 165 frames / 5.500 s of video.

```bash
ffmpeg -nostdin -y -ss 1.0 -i SOURCE.mp4 -t 2.0 \
  -c:v libx264 -c:a aac -video_track_timescale 30000 seg_0.mp4
# ...one per keep, then:
printf "file 'seg_0.mp4'\nfile 'seg_1.mp4'\nfile 'seg_2.mp4'\n" > list.txt
ffmpeg -nostdin -y -f concat -safe 0 -i list.txt -c copy OUT.mp4
```

Set `-video_track_timescale` to the fps numerator (30000 for 29.97, 30 for 30) so segments share a timebase
and concat does not resample timestamps. (`-video_track_timebase` does **not** exist and fails with "Option
not found".) The concat demuxer can leave a small non-zero first PTS (measured `pts_time=0.023`) — a
container start offset, not map drift, but it can put V4's `-ss` extraction off by a frame at the head.
Prefer §8.1 whenever CPU budget allows.

## 9. Failure signature quick reference

| Symptom | Cause |
|---|---|
| Cues progressively later toward the end | Cues authored in SOURCE time (§1) |
| Every cue off by the same amount | Head trim missing from the keep list, or container start offset (§8.3) |
| ~0.6 s off at 10 min, ~0.3 s at 5 min | fps assumed 30, file is 30000/1001 (§4.2) |
| Off by 1–4 frames, no pattern | `int()`/`floor()` instead of `round()` (§4.1) |
| Output ~1 s longer per keep than `sum(len)` | Stream copy snapped to keyframes (§8) |
| Output exactly `len(keeps)` frames longer than `sum(len)` | `between()` inclusive upper bound (§8.1) |
| Caption word with no audible referent | Bisected word not dropped (§6 rule 4) |
| Speech attributed to the wrong moment | Straddling cue trimmed instead of split (§6 rule 2) |
| Duration correct but everything drifts | `setpts`/`asetpts` omitted after `select` (§8.1) |
