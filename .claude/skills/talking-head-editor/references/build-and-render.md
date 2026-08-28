---
name: build-and-render
description: Stage 5 execution — turning four approved design documents into a finished 1080x1920 MP4. Order of operations and what each step costs, frame-accurate assembly from the keep list, the stream-copy trap, render-silent-then-mux, the Instagram delivery encode, HyperFrames layer rendering and alpha compositing, single-frame verification instead of watching renders, a failure diagnosis table, and the definition of done.
type: reference
---

# Build and render — vertical talking head

Executes `_templates/build-manifest.md` against the four locked design docs. Read `timebase.md` first: **every output timecode here
is OUTPUT time**, and every command must produce exactly the kept ranges the `src_to_out` map assumes. If assembly and map disagree,
nothing downstream lands right and there is no error message.

Provenance markers, load-bearing. **[V]** = run in this container on real 1080x1920 media, `ffmpeg 6.1.1-3ubuntu5`, x86_64, 2 cores;
the quoted number is what it printed. **[C]** = from `_meta/execution-contract.md` (§7, §7A, §7B, §8, §9) or a sibling reference;
verified there, not re-run here. **[A]** = asserted, or a platform figure that moves — a hypothesis. **HyperFrames is not installed
in this container**, so every `npx hyperframes` form below is **[C]**; every `ffmpeg`, `ffprobe` and browser-binary form is **[V]**.

## 1. Order of operations, and what each step costs

Preflight first: all four docs `status: approved`, no `{{placeholder}}` anywhere, fps probed **per file**, every fetch-list row
resolved to a local path **[C]**. Then the order below, dictated by cost — and the cost asymmetry is structural, not incidental.
Timings are wall clock for 14 s of 1080x1920 on 2 cores **[V]**.

| Step | Produces | Cost | Redo? | Why it sits here |
|---|---|---|---|---|
| 1 fetch | local files for every Epidemic asset | seconds | yes | *Fetch before building* — a missing asset found at step 5 wastes steps 2–4 **[C]** |
| 2 assemble | `picture.mp4`, **silent**, frame-exact | **7.84 s** | no | Defines OUTPUT time; everything later is placed against this frame count |
| 3 layers | alpha caption + graphic layers | Chrome render, minutes to tens of minutes **[A]** | **no — the cost centre** | Needs the locked cue sheet, which needs step 2's timebase |
| 4 composite | `composited.mp4`, still silent | **16.5 s** (2 layers) | no | Pure ffmpeg, but re-encodes step 3's output |
| 5 mix | `mix_stage1.wav` | seconds | **yes** | Audio only; costs nothing to iterate |
| 6 master | `master.wav`, two-pass `loudnorm` | seconds | **yes** | `loudnorm` normalises what it is handed, so it must be last **[C]** |
| 7 mux | `deliver.mp4` | **0.43 s** | **yes — 18x cheaper than step 2** | Stream-copies the picture. This is *why* picture and sound are separate |
| 8 verify | the §8 gates | **0.54 s**/frame, **3.06 s**/8-frame sheet | yes | Cheap enough to run continuously |

Extrapolate honestly: assembly ran at ~0.56x realtime, the two-layer composite at ~1.18x realtime, **on 2 cores [V]** — so a
10-minute talking head is ~6 min to assemble and ~12 min to composite *before* the HyperFrames Chrome render, which is slower still.
The contact sheet stays ~3 s regardless of length. So:

- **Sound is cheap, picture is expensive.** Never re-render picture to change a level, a duck, a cue position or the loudness target
  — step 7 replaces the audio in under a second (§4).
- **Layers are the cost centre.** Every defect caught by `check`, by arithmetic on the cue sheet, or by a `snapshot` is a Chrome
  render you did not pay for (`subtitle-spec.md` §2).
- **Changing the cut list invalidates steps 3–7.** Push every downstream timestamp through `out_to_src` on the old map then
  `src_to_out` on the new one (`timebase.md` §2). Never hand-patch an offset.

## 2. The render is not the inner loop

A render teaches almost nothing a frame would not, at 100–1000x the cost. **Verify picture on single frames extracted at specific
OUTPUT timecodes.** Watching a render is not verification — nobody looks at the right frame at the right time.

**Input-seek is frame-exact in ffmpeg 6.1.1 — verified again here.** Output frame 251 of a 30 fps cut, extracted by `-ss 8.366667
-i` and by `select='eq(n,251)'`, gave **byte-identical PNGs** (same md5, PSNR `inf`) **[V]**.

```bash
# ONE FRAME at an OUTPUT frame index. t = n * fps_den / fps_num, computed, never eyeballed.
N=251; FPS_NUM=30; FPS_DEN=1
T=$(python3 -c "print(f'{$N*$FPS_DEN/$FPS_NUM:.6f}')")
ffmpeg -nostdin -y -v error -ss "$T" -i composited.mp4 -frames:v 1 -update 1 qc/f${N}.png
```
Never `-noaccurate_seek` (snaps to a keyframe), never `ffprobe -read_intervals` (seeks to the preceding keyframe — observed
`pts_time=2.023` for a request at `00:00:03`) **[C]**.

**Contact sheet of N deliberately chosen checkpoints.** Not `fps=1/2` — a regular interval misses every moment that matters. Take
the list from the design docs: first/middle/**last** sound cue, worst cue by CPS, longest cue, every collision window, one frame
inside every dodge, the first frame of every keep you are unsure of. Minimum 8 **[C]**.

```bash
IN=composited.mp4; FPS_NUM=30; FPS_DEN=1
CKPTS="0 60 137 209 251 300 361 419"        # OUTPUT frame indices
rm -rf qc && mkdir -p qc; i=0
for n in $CKPTS; do
  t=$(python3 -c "print(f'{$n*$FPS_DEN/$FPS_NUM:.6f}')")
  ffmpeg -nostdin -y -v error -ss "$t" -i "$IN" -frames:v 1 \
    -vf "scale=270:-2,drawtext=text='f${n} / ${t}s':fontcolor=yellow:fontsize=18:x=6:y=6:box=1:boxcolor=black@0.7" \
    -update 1 "$(printf 'qc/ck_%02d.png' $i)"
  i=$((i+1))
done
ffmpeg -nostdin -y -v error -framerate 1 -i "qc/ck_%02d.png" \
  -vf "tile=4x2:margin=8:padding=6:color=0x202020" -frames:v 1 -update 1 qc/sheet.png
```
**[V]** 8 checkpoints, labelled, tiled 4x2 → one 1114x982 PNG in 3.06 s. `drawtext` needs `--enable-libfreetype`, present here; on a
build without fontconfig add `fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf` **[C]**.

**What to look at, per frame, in this order.** (1) **Picture identity** — is this the source frame the map predicted? Burn a frame
counter into a source proxy once (`drawtext=text='%{n}'`) and the sheet reads the map back to you for free: in the verified run, out
frames 0/60/137/209/251 showed src 30/90/217/289/431, exactly `out_in`+offset for keeps `[(30,150),(200,300),(400,600)]` **[V]**.
(2) **Layer registration** — does the caption on this frame belong to this frame? §6's one-frame lag shows on *some* frames only.
(3) **Occlusion** — any glyph inside a platform UI band? Draw the bands on and look (§7). (4) **Backing legibility** against the
actual grade at this frame, not a mid-grey. (5) **Levels**, via `signalstats` on the same frame, not by eye (§5). Only after the
sheet is clean do you render, and only after the user approves **[C]**.

## 3. Assembly — build exactly the ranges the map assumes

### 3.1 The stream-copy trap, re-measured

`-ss`/`-to` with `-c copy` cannot cut mid-GOP. Requested src 7.500 → 9.500 (60 frames / 2.000 s) on a 1080x1920 H.264 file with a
keyframe every 1.6 s (`-g 48`), **[V]**:

| method | packets in file | decoded frames | duration | error |
|---|---|---|---|---|
| `-ss 7.5 -to 9.5 -c copy` | **95**, pts −1.100 → 1.967 | **62** | **2.067 s** | +1.1 s hidden head, +2 frames visible |
| `-ss 7.5 -to 9.5 -c:v libx264` | 60 | 60 | 2.000 s | none |

Worse than "the in-point snaps back", in two ways. **The MP4 muxer wrote an edit list that hides the snap**: the file carries 33
frames of pre-roll at negative timestamps and ffmpeg's own decode honours it, so decoded frame 0 was **bit-identical** (PSNR `inf`)
to source frame 225 = exactly 7.500 s **[V]** — the in-point *looks correct*, while any edit-list-blind consumer (a raw packet
reader, some concat paths, some players) gets 1.1 s of extra head. And **the duration is wrong regardless: 62 frames for a requested
60** **[V]**; across 140 keeps that is a different edit. `timebase.md` §8 recorded the same defect as **3.251 s / 95 frames** on a
file whose muxer wrote no edit list. **The magnitude is host- and muxer-dependent; the defect is not.** Never stream-copy a cut.

### 3.2 Re-encode with `select`/`aselect` — the default

Frame-exact, single pass. **`between()` is inclusive on both bounds**, so use `between(n, src_in, src_out-1)` on frame numbers for
video and subtract `1e-6` from the seconds upper bound for `aselect` **[C]**.

```bash
python3 - <<'PY' > sel.txt
keeps=[(30,150),(200,300),(400,600)]; fn,fd=30,1      # from design-cuts.md, integer frames
f2s=lambda f: f*fd/fn
print('+'.join(f'between(n,{a},{b-1})' for a,b in keeps))
print('+'.join(f'between(t,{f2s(a):.6f},{f2s(b)-1e-6:.6f})' for a,b in keeps))
print(sum(b-a for a,b in keeps))                      # output_frames
PY
VS=$(sed -n 1p sel.txt); AS=$(sed -n 2p sel.txt); OUTF=$(sed -n 3p sel.txt)
ffmpeg -nostdin -y -v error -i SOURCE.mp4 \
  -vf "select='$VS',setpts=N/FRAME_RATE/TB" -af "aselect='$AS',asetpts=N/SR/TB" \
  -c:v libx264 -crf 18 -preset medium -pix_fmt yuv420p \
  -c:a aac -b:a 192k -ar 48000 -fps_mode passthrough cut.mp4
```
**[V] Exactly 420 frames / 14.000000 s of video**, matching `sum(len)`. Audio came back **14.016 s** — one AAC frame long: codec
granularity, not drift. Judge duration against the **video** stream **[C]**. Generate the expressions; never hand-type them. Three
verified traps:

| Mistake | Measured result **[V]** | Confirm with |
|---|---|---|
| `between(n,a,b)` — inclusive upper bound | **422** frames for an expected 420: +1 per range whose upper bound is inside the source | `-count_frames` vs `sum(len)` |
| `setpts` omitted, default `-fps_mode` | **600 frames / 20.000 s** — the cut changed nothing; removed ranges filled with duplicated frames | `-vf mpdecimate` collapsed it 600 → **420** |
| `setpts` omitted, `-fps_mode passthrough` | **420 frames but duration 19.000 s** — right count, source timestamps, so every downstream tool re-derives 19 s | `ffprobe stream=duration` vs `sum(len)/fps` |

`setpts=N/FRAME_RATE/TB` and `asetpts=N/SR/TB` are **mandatory**, not stylistic.

### 3.3 Per-segment + concat demuxer

Frame-exact **only if each segment is re-encoded** **[C]**. Right when segments need different treatment (a punch-in on one keep, a
speed ramp on another), or when the edit will not fit one filtergraph.

```bash
rm -f list.txt
for i in 0 1 2; do          # $SS/$T in SOURCE seconds, from the keep list
  ffmpeg -nostdin -y -v error -ss "$SS" -i SOURCE.mp4 -t "$T" \
    -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p -c:a aac -b:a 192k \
    -video_track_timescale 30 seg_$i.mp4          # = fps numerator (30000 for 29.97)
  printf "file 'seg_%d.mp4'\n" $i >> list.txt
done
ffmpeg -nostdin -y -v error -f concat -safe 0 -i list.txt -c copy concat.mp4
```
**[V] 420 frames / 14.000000 s — exact.** But the first video packet came back at `pts_time=0.033008`, not 0: a container start
offset, not map drift, though it can put a `-ss` extraction off by a frame at the head **[C]**. Prefer §3.2 when the CPU budget
allows. `-video_track_timebase` does not exist ("Option not found") **[C]**.

### 3.4 Keyframe snapping — only if stream copy is truly required

Snap the keep list to keyframes **before** building the map, never after: snap → merge overlaps → rebuild `TimeBase` → re-run cut
review (the snap can drag filler or a retake back in) → *then* design sound, motion, captions. Snapping after designing reintroduces
the exact bug `timebase.md` exists to prevent **[C]**.

```bash
ffprobe -v error -select_streams v:0 -skip_frame nokey -show_entries frame=pts_time -of csv=p=0 SOURCE.mp4
```
**[V]** on the test asset: `0.000000, 1.600000, 3.200000, 4.800000, 6.400000, …` — 1.6 s spacing, so the average in-point snap is
~0.8 s. Weigh that against re-encode time before choosing this path.

### 3.5 Keeping A/V in sync through the cut

**One graph, both streams** — `select` + `aselect` in the same command against the same keep list; never cut picture and sound in
separate invocations from separate range lists. **`asetpts=N/SR/TB`, not `asetpts=PTS-STARTPTS`**, which is the wrong idiom after
`aselect`. **Judge duration on the video stream**: expect audio within one AAC frame (~21 ms), measured 14.016 vs 14.000 **[V]**.
And **a clean mux has a small *negative* audio start_time** — the verified first audio packet sat at **`pts_time = -0.021333`**, AAC
priming, 1024 samples at 48 kHz **[V]**. Sync tolerance is **±1 AAC frame (±0.0214 s)**, not zero; past that is real offset.

## 4. Render silent, mux audio separately

The single highest-leverage habit here. **Assemble and composite with `-an`; attach audio in one final stream-copy mux.** Every
audio change — a level, a duck, a cue nudge, a new loudness target — then costs a second, not a re-render.

```bash
# step 2/4: picture only. -an everywhere.
ffmpeg -nostdin -y -v error -i SOURCE.mp4 \
  -vf "select='$VS',setpts=N/FRAME_RATE/TB" -an \
  -c:v libx264 -crf 18 -preset medium -pix_fmt yuv420p -fps_mode passthrough picture.mp4

# step 7: mux. Video is COPIED; only the audio is encoded.
ffmpeg -nostdin -y -v error -i composited.mp4 -i master.wav \
  -map 0:v:0 -map 1:a:0 -c:v copy \
  -c:a aac -b:a 192k -ar 48000 -ac 2 \
  -af "apad=whole_dur=14.0" -frames:v "$OUTF" \
  -movflags +faststart deliver.mp4
```
**[V] The load-bearing measurement.** Three different muxes of the same `picture.mp4` — different masters, different audio bitrates,
`apad` on one — all produced the **identical video-stream MD5** `5651672276315862fb16152e2c29aec7`, equal to `picture.mp4`'s own: the
picture is untouched, bit for bit, at **0.43 s vs 7.84 s** to rebuild it. Two verified mux traps:

- **`-shortest` truncates the picture.** A 13 s master against a 14 s picture gave **390 frames / 13.000 s** — a full second of
  video silently gone **[V]**. Never use `-shortest` on a delivery mux.
- **Pad the audio, cap the video.** `-af "apad=whole_dur=<output_seconds>"` gave audio exactly 14.000000 s; bare `apad` gave 13.994
  **[V]**. `-frames:v $OUTF` from `design-cuts.md` makes the frame count unfalsifiable.

## 5. Vertical output spec

```bash
ffmpeg -nostdin -y -v error -i composited.mp4 -i master.wav -map 0:v:0 -map 1:a:0 \
  -c:v libx264 -crf 18 -preset slow -profile:v high -level 4.0 -pix_fmt yuv420p \
  -x264-params "keyint=60:min-keyint=60:scenecut=0:ref=3:bframes=2" \
  -maxrate 14M -bufsize 28M \
  -color_primaries bt709 -color_trc bt709 -colorspace bt709 -color_range tv \
  -c:a aac -b:a 192k -ar 48000 -ac 2 \
  -movflags +faststart deliver.mp4
```
**[V] Verified to land**: `1080x1920`, `profile=High`, `level=40`, `pix_fmt=yuv420p`,
`color_primaries=color_transfer=color_space=bt709`, `color_range=tv`, `r_frame_rate=30/1`, achieved video bitrate 8.58 Mbit/s on
hard synthetic content, audio `aac` at 191.6 kbit/s. `+faststart` confirmed by byte offset: **`moov` at 36, `mdat` at 15644** — the
index precedes the payload.

| Field | Value | Why |
|---|---|---|
| Resolution | **1080x1920** | Native 9:16. Never upscale a smaller master to hit it. |
| fps | the EDL's `fps` header, unchanged | Retiming here silently invalidates every OUTPUT timecode. |
| Codec | H.264 High, level 4.0 | 1080x1920@30 is inside level 4.0; widest decode compatibility **[A]** |
| Rate control | **CRF 18 + `-maxrate 14M -bufsize 28M`** | CRF for consistent quality; the cap stops a hard passage spiking past what the platform accepts |
| Preset / GOP | `slow` for delivery (`veryfast` while iterating); `keyint=60:min-keyint=60:scenecut=0` | Only the final encode pays for `slow`; a fixed 2 s GOP with scenecut off is seekable and reproducible |
| Pixel format | **`yuv420p`** | The only universally decodable 8-bit format; `yuv444p`/10-bit gets transcoded **[A]** |
| Colour | bt709/bt709/bt709/tv, **tagged explicitly** | Untagged probes as `color_primaries=unknown` **[V]** and the platform guesses |
| Audio | **AAC-LC, 192 kbit/s, 48 kHz, stereo** | Matches the mix rate; no resample at the last step |
| Loudness | **−14 LUFS integrated, −1.5 dBTP** | Working target from `sound-design-pass.md` §8.3 |
| Container | MP4, `+faststart` | moov must precede mdat for progressive playback |

**Honest about the platform numbers.** Meta publishes no loudness figure for Reels and no bitrate ceiling I could confirm; −14 LUFS
/ −1.5 dBTP is the vault's cross-platform working figure **[C]**, and the 14 Mbit/s cap and level 4.0 are **[A]** — chosen
comfortably above what the platform keeps and inside what every decoder accepts. A stated client spec wins over both.

**Why a marginal master is unrecoverable — measured.** 3 s of 1080x1920 noisy detail, reference at CRF 12, each master then pushed
through a simulated platform re-encode at a fixed 3500 kbit/s **[V]**:

| master | master PSNR | master size | after platform pass | platform output size |
|---|---|---|---|---|
| **CRF 18** | **44.34 dB** | 5.20 MB | **39.87 dB** | 1.36 MB |
| 2500 kbit/s | 38.17 dB | 0.91 MB | 38.01 dB | **1.43 MB** |

The surprise is the last column: **the marginal master's platform output is both worse (−1.9 dB) and larger (+5 %)** — the platform
spends bits carrying artefacts the marginal encode baked in. A second pass cannot add back what the first threw away; 38 dB is a
hard ceiling. Give the platform a clean, generous master.

## 6. HyperFrames layer rendering and compositing

### 6.1 Two hard environment facts

- **`cdn.jsdelivr.net` is blocked by the egress allowlist in both environments.** A composition loading GSAP — or any library, or a
  Google Fonts stylesheet — from a CDN renders **BLANK** **[C]**. Vendor GSAP locally and load from a relative path; bundled family
  or local `@font-face` for type. **Everything inlined or local. No exceptions.**
- **HyperFrames cannot render on the user's device VM**: linux ARM64, no sudo, no Chrome Headless Shell build **[C]**. Author, lint
  statically and plan there; run every browser-backed step in the cloud container:

```bash
export HYPERFRAMES_BROWSER_PATH=/opt/pw-browsers/chromium_headless_shell-1194/chrome-linux/headless_shell
"$HYPERFRAMES_BROWSER_PATH" --version     # -> Chromium 141.0.7390.37   [V]
```
The binary exists, is executable and reports its version here **[V]**; that the CLI reads that env var is the operator's
instruction, **[A]** to me — confirm with `npx hyperframes snapshot` on a trivial composition before a long render.

### 6.2 The `npm run check` gate, before any render

```bash
npx hyperframes lint --verbose        # static rules only; runs anywhere, incl. the device VM        [C]
npm run check                         # lint + runtime + layout + motion + contrast; target 0 findings [C]
npx hyperframes snapshot --at 1.2,4.8,9.6,14.1,19.3,24.7,31.0,38.4   # then LOOK at each frame       [C]
npx hyperframes preview --background  # review surface; --status to confirm, --stop when done        [C]
npx hyperframes render --composition compositions/captions.html --format webm   # after approval only [C]
```
**The trap: a lint *error* switches off the layout and contrast audits.** `check` then reports `0 sample(s)` and `0/0 text checks` —
reads clean, means nothing ran. **Clear lint errors first, then trust the layout findings, never the reverse.** `snapshot` is
required for any project with sub-compositions and is the only real defence against the silent root-sizing bug and the silent
relative-timing zeros **[C]**. Do not auto-render when checks pass **[C]**.

### 6.3 Layer format — alpha, and the two verified booby traps

Render each caption/graphic composition as its own transparent layer at 1080x1920 and the project fps. `--format` `webm` and `mov`
render with transparency; `png-sequence` writes RGBA frames **[C]**. Two booby traps, both silent.

**Trap 1 — a VP9 WebM's alpha is dropped by the default decoder.** Overlaying each layer onto a mid-grey (Y=126) plate and reading
`signalstats` YAVG **[V]**:

| layer input | how decoded | plate YAVG after overlay | alpha honoured? |
|---|---|---|---|
| `layer.webm` (VP9 `yuva420p`) | default (native `vp9`) | **17.76** | **no — composited as opaque black, picture erased** |
| `layer.webm`, same file | **`-c:v libvpx-vp9 -i`** | **124.11** | yes |
| `layer.mov` (ProRes 4444) | default | 126.30 | yes |
| `pngs/%05d.png` | default | 126.28 | yes |

**Put `-c:v libvpx-vp9` immediately before every `-i layer.webm`**, or prefer a PNG sequence / ProRes 4444, which need no flag.
`ffprobe` is no help — the WebM's main stream reports `pix_fmt=yuv420p` whether or not the alpha side-channel is there **[V]**.
`prores_ks -profile:v 4444 -alpha_bits 16` came back as `yuva444p12le` **[V]**.

**Trap 2 — a WebM layer sits one frame late on some frames.** WebM's timebase is **1/1000**, so layer frame 137 is stamped
**4.567000 s** while the MP4 base's frame 137 is at **4.566667 s** **[V]**; `overlay` pairs by timestamp, so the base gets layer
frame 136. Verified with frame numbers burned into both: output frames 0/60/300/361 correct, output frames **137/209/251/419 each
one frame behind** **[V]**. Invisible unless you look at the right frame — a regular-interval sheet misses it. **Fix: re-clock every
layer onto the base's frame clock before overlay**, which corrected all four failing checkpoints **[V]**.

### 6.4 The composite

```bash
FPS=30; OUTF=420
ffmpeg -nostdin -y -v error \
  -i picture.mp4 \
  -c:v libvpx-vp9 -i layer_graphics.webm \
  -c:v libvpx-vp9 -i layer_captions.webm \
  -filter_complex "\
[1:v]fps=$FPS,setpts=N/FRAME_RATE/TB[g];\
[2:v]fps=$FPS,setpts=N/FRAME_RATE/TB[c];\
[0:v]format=rgba[base];\
[base][g]overlay=0:0:format=auto:shortest=1[t1];\
[t1][c]overlay=0:0:format=auto:shortest=1,format=yuv420p[v]" \
  -map "[v]" -an -frames:v $OUTF \
  -c:v libx264 -crf 18 -preset medium -pix_fmt yuv420p -fps_mode passthrough composited.mp4
```
`format=rgba` on the base before the first overlay keeps alpha edges from being chroma-subsampled mid-chain; `format=yuv420p` at the
end returns to a deliverable pixel format. **Layer order is filter order** — the last overlay is on top, so captions last.
**`shortest=1` on every overlay, *and* `-frames:v $OUTF`**: without them the same 420-frame inputs produced **422 frames**; either
fix alone gave exactly **420** **[V]**. Still `-an` — audio arrives at §4.

### 6.5 What a blank render means, and how to diagnose it

A blank composition is the signature failure of the CDN block. Diagnose in this order.

**1. Is there any opaque pixel in the layer at all?** `alphaextract` answers it in one frame.

```bash
ffmpeg -nostdin -v error -c:v libvpx-vp9 -i layer_captions.webm \
  -vf "alphaextract,signalstats,metadata=print:file=-" -frames:v 1 -f null - 2>&1 | grep -E "YMAX|YAVG"
```
**[V]** fully transparent layer → `YAVG=0 YMAX=0`; real caption layer → `YAVG=1.178 YMAX=255`; real graphic layer → `YAVG=0.296
YMAX=255`. **A low YAVG is normal** (captions cover little area). **`YMAX=0` is the blank verdict.**

2. `grep -rn "https://" compositions/ index.html` — any remote `<script>`, `<link>`, `@import` or `url()` is the cause. Vendor it.
   **[C]**
3. `npm run check`, read correctly: `0 sample(s)` / `0/0 text checks` means a lint error disabled the audits, not a clean file.
   **[C]**
4. `npx hyperframes snapshot --at <one early time>` — blank snapshot means the composition; a good snapshot with a blank layer means
   the export leg.
5. Content piled into the top-left at ~0 size is the flex-child root-sizing collapse. **[C]**
6. Exactly one `gsap.timeline({paused:true})` per composition, keyed by the root's `data-composition-id`, registered after the build
   completes and **never** inside `async`/`setTimeout`/`Promise` — an unregistered timeline renders a static first frame. **[C]**

## 7. Failure diagnosis

| Symptom | Likely cause | Command that confirms it |
|---|---|---|
| Composition renders **blank** | CDN load blocked; or lint error disabled the audits; or timeline never registered | `ffmpeg -c:v libvpx-vp9 -i L.webm -vf "alphaextract,signalstats,metadata=print:file=-" -frames:v 1 -f null -` → `YMAX=0`; then `grep -rn "https://" compositions/` |
| Layer composites as **opaque black**, picture gone | VP9 alpha dropped by the default decoder | overlay onto `color=c=0x808080` and read `signalstats` YAVG: **17.76 = alpha lost, ~126 = alpha honoured** **[V]** |
| Caption is **one frame behind** on some frames only | WebM 1/1000 timebase vs MP4 1/15360 | `ffprobe -select_streams v:0 -show_entries packet=pts_time L.webm` → `4.567000` where the base has `4.566667` **[V]** |
| Composite is **longer than the EDL** | `overlay` ran to the longest input | `-count_frames` vs `sum(len)`; **422 vs 420** in the verified run **[V]**. Add `shortest=1` + `-frames:v` |
| **A/V drift**, growing | picture and sound cut from different range lists, or a retime applied to one stream | `ffprobe -show_entries stream=codec_type,start_time,duration -of csv=p=0 OUT.mp4`; a clean mux reads audio `start_time` within **±0.0214 s** of video **[V]** |
| **A/V offset**, constant | mux offset, or a container start offset from the concat demuxer | first-packet pts per stream: `ffprobe -select_streams a:0 -show_entries packet=pts_time -of csv=p=0`. Verified clean = **−0.021333**; a 200 ms slip read **+0.178** **[V]** |
| Sound lands **progressively later** toward the end | cues authored in SOURCE time — the two-clock bug | `timebase.md` §1/§9. Check the **last** cue first: the error is largest at the tail. Extract the frame at that cue's OUTPUT time and look |
| Sound lands **early/late by a constant** | head trim missing from the keep list, or a concat container start offset | `timebase.md` §9; `ffprobe -show_entries packet=pts_time` — first video packet ≠ 0 |
| Output longer than `sum(len)`: ~1 s per keep, or +1 per keep, or 600 for an expected 420 | keyframe snap (§3.1) / `between()` inclusive bound / `setpts` omitted | `-count_frames` vs `sum(len)`, then `ffmpeg -i OUT.mp4 -vf mpdecimate -f null -` — it collapsed **600 → 420**, proving duplicates **[V]** |
| Frame count right, **duration 19 s not 14 s** | `setpts` omitted with `-fps_mode passthrough` | `ffprobe stream=duration` vs `sum(len)/fps` **[V]** |
| Picture **one second short** after muxing | `-shortest` with a short master | `-count_frames`: **390 vs 420** **[V]**. Use `apad=whole_dur=` + `-frames:v` |
| **Captions behind platform UI** — renders fine, nobody reads them | caption box inside the reserved band | draw the bands onto a QC frame and look (below) |
| Render **dies on the device VM** | linux ARM64, no sudo, no Chrome Headless Shell | `uname -m` → `aarch64`; there is no fix on that host. Move the render to the cloud container and set `HYPERFRAMES_BROWSER_PATH` **[C]** |
| **Audio clipping** | mix hot, or `alimiter` auto-gained (`level` not disabled) | `ffmpeg -i master.wav -af astats -f null -` → **`Flat factor: 26.96`** and `Peak level dB: 0.000265` when clipped vs **`Flat factor: 0.000000`** clean **[V]**. Note: this ffmpeg has **no** "Number of clipped samples" key — `Flat factor` is the discriminator. Cross-check `ebur128=peak=true` → `True peak: 0.0 dBFS` **[V]** |
| Output **too dark / washed out** after the platform re-encode | illegal levels in a `tv`-range file, or missing colour tags so the platform guessed | `ffprobe -select_streams v:0 -show_entries stream=color_primaries,color_transfer,color_space,color_range` — `unknown` on any of the four is the bug **[V]**; then `ffmpeg -i OUT.mp4 -vf "select='eq(n\,N)',signalstats,metadata=print:file=-" -frames:v 1 -f null -` → verified keys `YMIN=9 YLOW=41 YAVG=126.378 YHIGH=210 YMAX=255 SATAVG=113.187` **[V]**. `YMIN<16` or `YMAX>235` on a `tv`-range file means values outside legal range |
| Quality collapses only **after** upload | marginal master; the platform re-encode cannot recover it | re-encode your own master at 3500 kbit/s and PSNR both against the pre-master: **44.34 → 39.87** for CRF 18 vs **38.17 → 38.01** for 2500 kbit/s **[V]** |

**Confirming caption occlusion.** Draw the reserved bands onto a real QC frame. Reels bottom ~20 %, top ~14 %, right rail ~16 % of
W; union-safe single master bottom 22 %, top 14 %, right 18 % **[C]** — a prior with a shelf life, not a spec; the bands move with
app releases.

```bash
ffmpeg -nostdin -y -v error -ss "$T" -i composited.mp4 -frames:v 1 -vf \
"drawbox=x=0:y=0:w=1080:h=269:color=red@0.35:t=fill,\
drawbox=x=0:y=1498:w=1080:h=422:color=red@0.35:t=fill,\
drawbox=x=886:y=0:w=194:h=1920:color=blue@0.30:t=fill,scale=360:-2" -update 1 qc/uibands.png
```
**[V]** Ran clean and immediately showed the test caption sitting inside the bottom band. Any glyph under a tinted box is unreadable
in the app; fix by **moving the caption**, never by `z-index` **[C]**.

## 8. Definition of done

Every check must pass, with its command, before the file is handed over. Gates 1–7 and 11 are seconds of `ffprobe` — run them after
every build, not once at the end.

| # | Gate | Command | Pass |
|---|---|---|---|
| 1 | **Frame count + duration identity** | `ffprobe -v error -select_streams v:0 -count_frames -show_entries stream=nb_read_frames,duration -of default=nw=1 deliver.mp4` | `nb_read_frames` **exactly** `output_frames` from `design-cuts.md`; `duration` = `output_frames*fps_den/fps_num`. **[V]** 420 / 14.000000 |
| 2 | **No duplicated frames** | `ffmpeg -nostdin -hide_banner -i deliver.mp4 -an -vf mpdecimate -f null - 2>&1 \| grep -o "frame= *[0-9]*" \| tail -1` | **≥ 0.80 × gate 1** — not "within a few frames"; see §8.1. A drop past 0.80 means an omitted `setpts` **[V]** |
| 3 | **Container spec** | `ffprobe -v error -select_streams v:0 -show_entries stream=width,height,pix_fmt,profile,level,r_frame_rate,color_primaries,color_transfer,color_space,color_range -of default=nw=1 deliver.mp4` | `1080/1920/yuv420p/High/40/<edl fps>/bt709/bt709/bt709/tv`, no `unknown` **[V]** |
| 4 | **faststart** | `python3 -c "d=open('deliver.mp4','rb').read(200000);print(d.find(b'moov'),d.find(b'mdat'))"` | moov offset **<** mdat offset. **[V]** 36 < 15644 |
| 5 | **A/V alignment** | `ffprobe -v error -show_entries stream=codec_type,start_time,duration -of csv=p=0 deliver.mp4` | audio `start_time` within **±0.0214 s** of video's; audio duration within one AAC frame **[V]** |
| 6 | **Loudness and true peak** | `ffmpeg -hide_banner -nostats -i deliver.mp4 -af ebur128=peak=true -f null - 2>&1 \| tail -12` | `I` −16…−13 LUFS, `LRA ≤ 9 LU`, true peak ≤ −1.5 dBTP **[C]** |
| 7 | **No clipping** | `ffmpeg -nostdin -hide_banner -i deliver.mp4 -af astats -f null - 2>&1 \| grep -E "Flat factor\|Peak level"` | `Flat factor` ≈ 0; `Peak level dB` ≤ −1.5 **[V]** |
| 8 | **Landmark round-trip** (map is real) | `timebase.md` §7 V3 — PSNR sweep around the predicted frame | peak **at offset 0**, ≥5 dB above its nearest neighbour **[C]** |
| 9 | **Checkpoint contact sheet, looked at** | §2 sheet over ≥8 checkpoints incl. the **last** sound cue, worst-CPS cue, every collision window | picture identity, layer registration, occlusion, backing legibility all correct on every frame |
| 10 | **Caption occlusion** | §7 `drawbox` frame at every caption cue in the reserved bands | no glyph under a tinted box **[C]** |
| 11 | **Levels legal** | `ffmpeg -i deliver.mp4 -vf "select='eq(n\,N)',signalstats,metadata=print:file=-" -frames:v 1 -f null -` at 3 checkpoints | `YMIN ≥ 16`, `YMAX ≤ 235` on a `tv`-range file **[V]** |
| 12 | **Composition gates** | `npm run check`; `npx hyperframes snapshot --at <midpoints>` | 0 findings, and a non-zero `sample(s)` count — `0 sample(s)` means the audits never ran **[C]** |
| 13 | **Human approval** | — | *Render is user-gated. Do not render on your own initiative.* **[C]** |
| 14 | **Deviations logged** | `BUILD.md` § Deviations | every difference between design and build, with the reason. A recurring deviation belongs in a rule note or the profile **[C]** |

### 8.1 Gate 2 is calibrated on real footage, not on synthetic content

`mpdecimate` counts the frames it considers *not* near-duplicates of their predecessor. On a synthetic test pattern
almost every frame differs, so the count lands within a frame or two of gate 1, and "within a few frames" reads like a
safe criterion. It is not, and an earlier version of this document was wrong to state it.

A talking head holding still produces **legitimate** near-duplicates. Two measurements on real media bracket the
threshold:

| Case | Gate 1 | After `mpdecimate` | Ratio |
|---|---|---|---|
| Clean build, real talking-head footage | 700 | 636 | **0.91** |
| The defect the gate exists for — omitted `setpts`, frames lost through the concat | 600 | 420 | **0.70** |

**0.80 × gate 1** separates the two with room on both sides. Tightening it back toward 1.0 fails correct output;
loosening it past 0.70 passes the defect the gate was written to catch.

If a build lands in 0.75–0.85, do not move the threshold — the content is the variable, and a gate that is retuned until
it passes is a gate tolerating its own failure. Instead run the same command on the **source** keep-ranges concatenated
with no filter and compare ratios: a source that is itself ~0.85 tells you the footage is unusually static, and gate 8's
landmark round-trip is then the check that actually proves the frame map.

### 8.2 True peak is a property of the deliverable, not of the master WAV

Gate 6 measures `deliver.mp4`, and that is not a formality. Two overshoots stack after the audio master is written, and
neither is visible to a measurement taken on the WAV:

1. `alimiter`'s `limit` is a **sample-peak** limit. A signal held at sample peak −1.5 dBFS can already exceed −1.5 dBTP,
   because true peak is measured on the 4×-oversampled reconstruction between samples.
2. The **AAC encode adds its own overshoot** on top of that.

So guarding the master WAV cannot hit a true-peak target: the number moves after the guard runs. The order that works is
**guard → mux → measure on the deliverable → correct → re-mux**, and the re-mux is cheap because the picture is
stream-copied (§4) — only the audio is re-encoded. On real media this lands about **−1.6 dBTP** against a −1.5 dBTP
target.

Gate 6 carries **no tolerance** above −1.5. A gate written as "≤ −1.5 dBTP, +0.1 allowed" passes a file measuring −1.4,
which is the failure the gate exists to catch.
