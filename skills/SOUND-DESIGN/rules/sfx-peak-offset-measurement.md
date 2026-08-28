---
id: sfx-peak-offset-measurement
title: Find the peak — measure an effect's transient offset instead of eyeballing it
skill: sound-design
type: sfx
family: placement
tags: [skill/sound-design, type/sfx, family/placement, engine/ffmpeg, engine/hyperframes, engine/epidemic, layer/sfx, source/sfx-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:02"
    quote: "And you can find the peak just by looking at the waveform."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:58"
    quote: "So first of all, if you're putting a sound effect on a cut, place the highest peak of the sound effect on the cut."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:04"
    quote: "And if you're putting a sound effect on a motion, then match the peak of the sound effect to the middle of the motion."
research_refs:
  - https://ffmpeg.org/ffmpeg-filters.html#astats-1
  - https://aubio.org/manual/latest/cli.html
  - https://en.wikipedia.org/wiki/Spectral_centroid
  - local verification 2026-08-28 — ffmpeg 6.1.1, synthetic 1 kHz transient injected at 0.370 s, recovered at pts_time 0.37 (10 ms scan) and 0.376 s (1 ms scan); numpy envelope peak 0.3745 s, sample peak 0.3767 s
difficulty: low
detectable_from: audio
---

# Find the peak — measure an effect's transient offset instead of eyeballing it

## What it is
Every placement rule in this library is written as "put the peak of the sound on the frame of the event". That instruction is only executable if you know **how far into the file the peak sits** — the file's `peak_offset`. The source's method is visual: enlarge the audio track and look at the waveform. The programmatic equivalent is a windowed scan of the file with `ffmpeg`'s `astats` filter, which prints a peak level per window with a timestamp, so the loudest window *is* the offset. Measure it once per asset, store it in the library manifest next to the file, and every later placement becomes arithmetic: `data-start = event_time − peak_offset`.

Two different "peaks" exist and confusing them costs a frame or two. The **sample peak** is the single loudest sample. The **envelope peak** is the loudest point of a short moving average — what the ear actually locks onto. On a measured test transient they landed 2.2 ms apart (0.3767 s vs 0.3745 s), which is inside a frame and therefore irrelevant; on a noisy or clipped file they can diverge by 20 ms or more, and the envelope value is the one to trust.

**Style.** No `sfx/` style tag: `peak_offset` is a property of a *file*, measured once at ingest, and every placement rule in the library consumes it regardless of style — a door close, a whoosh and a braam are all placed by the same arithmetic.

## When to use it
- **Once per asset, at ingest.** Every file that enters the library gets a measured `peak_offset` before it is ever placed. This is the single highest-leverage habit in the whole fetch pipeline: it turns "nudge it until it feels right" into a computed number.
- **Before placing any hit, impact, whoosh, clank, footstep or transition sound** on a specific frame ([[sfx-peak-on-impact-frame]], [[sfx-peak-on-the-cut]]).
- **After any processing** that changes the envelope — pitch shift, time stretch, added fades, reverb — because the peak moves. Re-measure the derived file, not the original.
- **When auditioning candidates**: the peak position is a selection criterion, not just a placement number. A whoosh whose peak sits at 85% of its length is an *arrival* sound; one peaking at 15% is a *departure* sound. Same word in the title, opposite jobs.
- Skip it for **beds** — ambience, music, drones, textures. A bed has no transient to align and its `data-start` is a structural decision, not a sync one.

## How to recognise it in a reference video
This note is mostly a measurement tool, but the measurement also tells you what a reference did.

- **Scan the reference's audio at frame resolution and list its transients.** 1600 samples at 48 kHz is exactly one frame at 30 fps:
  ```bash
  ffmpeg -v error -i ref.wav -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null | paste - -
  ```
  Each output line carries `pts_time` and a `Peak_level` in dBFS. A rise of **≥ 6 dB inside one frame** is a transient; the frame it lands on is the reference's chosen sync frame.
- **Compare that list to the picture events** (cuts from `scdet`, motion onsets from `tblend=all_mode=difference`). Tabulate `transient_frame − event_frame`. Competent work clusters at **0 to +2 frames** for impacts and diegetic contacts, and at **−2 to −6 frames** for anticipatory motion sounds. A cluster at **+4 frames or later** reads as late and is a defect worth logging, not a style.
- **Look at where the peak sits inside each effect**, not just where the effect starts. Extract the effect and measure. `peak_offset / duration` under 0.25 = onset-weighted (hits, clicks, impacts); 0.25–0.6 = centre-weighted (whooshes, swishes); over 0.75 = end-weighted (risers, reverse swells, "Stop" scratches). The distribution of these ratios across a reference is a compact fingerprint of its sound palette.
- **Watch for a systematically early or late whole mix.** If *every* transient sits at the same non-zero offset from picture, that is A/V drift or a delivery offset, not sound design. Fix it globally before auditing anything else.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `scan_window` | 480 samples (10 ms) | 240–1600 samples | First pass. 1600 = one frame at 30 fps; 480 gives sub-frame resolution cheaply. |
| `refine_window` | 48 samples (1 ms) | 24–96 samples | Second pass, run only across ±30 ms around the coarse winner. |
| `envelope_window` | 5 ms | 3–20 ms | Moving-average width for the envelope peak. Below 3 ms it tracks the sample peak; above 20 ms it smears a real transient. |
| `env_vs_sample_tolerance` | 3 ms | — | If the two peaks differ by more than this, use the envelope value and flag the file as noisy or clipped. |
| `transient_threshold` | 6 dB per frame | 4–10 dB | Rise that counts as a transient when scanning a mixed reference track. |
| `multi_peak_rule` | first peak within 3 dB of max | 2–4 dB | Files with several hits: take the **earliest** peak within this window of the maximum, not the loudest. That is the one the ear syncs to. |
| `riser_anchor` | 0.92 × duration | 0.85–1.0 | Risers and reverse swells peak at the end; treat the *end* as the anchor and place `data-start = event − duration × riser_anchor`. |
| `format_for_measurement` | WAV | — | Measure WAV, not mp3. mp3 pre-echo smears a transient by up to ~20 ms and shifts the measured peak. |
| `store_as` | seconds, 4 dp | — | Store `peak_offset` in seconds — the engine's unit. Frames are a comment. |

## Reproduction prompt

```
Measure and record the peak offset of the sound file at {{FILE}}, then place it
so its peak lands on the visual event at {{EVENT}} seconds (composition time).

1. COARSE SCAN at 10 ms resolution and take the loudest window:
   ffmpeg -v error -i {{FILE}} -af "asetnsamples=n=480,astats=metadata=1:reset=1,\
   ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null \
   | paste - - | sort -t= -k2 -g | tail -3
   Read pts_time from the last line -> COARSE_T.
2. REFINE at 1 ms resolution, same command with n=48, and keep only rows whose
   pts_time is within 0.03 s of COARSE_T. Take the maximum -> SAMPLE_PEAK.
3. ENVELOPE CHECK (authoritative when they disagree by more than 0.003 s):
   ffmpeg -v error -i {{FILE}} -f f32le -ac 1 -ar 48000 - | python3 -c "
   import sys,numpy as np; x=np.frombuffer(sys.stdin.buffer.read(),dtype=np.float32)
   sr=48000; e=np.abs(x); w=int(0.005*sr)
   env=np.convolve(e,np.ones(w)/w,mode='same'); i=int(np.argmax(env))
   print(round(i/sr,4))"
   -> PEAK_OFFSET.
4. CLASSIFY the file: ratio = PEAK_OFFSET / duration. <0.25 onset-weighted,
   0.25-0.6 centre-weighted, >0.75 end-weighted. If the ratio is >0.75 the file
   is a riser/reverse - confirm that is what this moment wants before placing it.
5. WRITE IT DOWN in the asset manifest as peak_offset_s, next to the file path,
   duration and the query that found it. Never measure the same file twice.
6. PLACE: data-start = {{EVENT}} - PEAK_OFFSET, rounded to 3 decimals, clamped
   to >= 0. If the result is negative, the file is too long-tailed for this
   event: trim it with data-media-start = (PEAK_OFFSET - {{EVENT}}) and set
   data-start = 0.
7. RE-MEASURE if you afterwards pitch-shift, stretch, fade or reverb the file.
   Processing moves the peak; a stale offset is worse than no offset.

ACCEPTANCE TEST: render 1 second either side of {{EVENT}} and scan the render
with the same 10 ms command. The loudest window inside that second must fall
within 1 frame (0.033 s) of {{EVENT}}. If it does not, the offset is wrong or
another sound is louder there - do not adjust by ear until the measurement agrees.
```

## Execution spec

**ffmpeg — verified locally on 2026-08-28 (ffmpeg 6.1.1).** A 1 kHz 20 ms burst was mixed into pink noise at exactly 0.370 s. The 10 ms scan returned `pts_time:0.37 → Peak_level=-16.246`; the 1 ms scan returned `0.376`; the numpy envelope returned `0.3745`, sample peak `0.3767`. The commands below are the tested ones, not paraphrases.

```bash
# 1. coarse: 10 ms windows, sorted, loudest last
ffmpeg -v error -i sfx.wav -af "asetnsamples=n=480,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null \
  | paste - - | sort -t= -k2 -g | tail -3

# 2. duration, for the ratio
ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 sfx.wav

# 3. envelope peak (authoritative) + frame number at 30 fps
ffmpeg -v error -i sfx.wav -f f32le -ac 1 -ar 48000 - | python3 -c "
import sys,numpy as np
x=np.frombuffer(sys.stdin.buffer.read(),dtype=np.float32); sr=48000
e=np.abs(x); w=int(0.005*sr); env=np.convolve(e,np.ones(w)/w,mode='same')
i=int(np.argmax(env)); j=int(np.argmax(e))
print(f'env={i/sr:.4f}s sample={j/sr:.4f}s dbfs={20*np.log10(e[j]+1e-12):.2f} frame30={i/sr*30:.2f}')"
```
Other filters worth knowing and their limits: `volumedetect` gives one `max_volume` for the whole file and **no position** — useless here. `silencedetect=n=-40dB:d=0.02` brackets where sound exists but not where it peaks. `aspectralstats=measure=centroid` (verified present; keys print as `lavfi.aspectralstats.1.centroid`) tells you *what* the peak is made of, which is how you separate a bright click from a low thud when two effects overlap. `aubioonset -i sfx.wav -O hfc -t 0.3 -M 0.02` is the better tool for **onset** (attack start) rather than peak, and its defaults are threshold 0.3 and minimum inter-onset interval 0.020 s — but `aubio` is **not verified present in this environment** (§10 of the execution contract lists it among unverified optional tools), so the ffmpeg route above is the one to depend on.

**Epidemic Sound — read the peak before you download.** Search results carry `audioFile.durationInMilliseconds` and `audioFile.waveformUrl` (a JSON peak envelope on `audiocdn.epidemicsound.com`). Use `durationInMilliseconds` as the length filter and the waveform URL as a *coarse* eyeball of where the energy sits when choosing between candidates; it is not a substitute for measuring the downloaded WAV, and the CDN is not fetchable from every host (it refused a direct fetch here). Always download WAV — `DownloadSoundEffect { id, options: { fileType: WAV } }` — because mp3 pre-echo moves the measured peak on exactly the short transients this note exists to place.

**HyperFrames — the arithmetic, in seconds.** There is no frame attribute and no auto-sync: *"HyperFrames does not provide automatic waveform sync or drift correction"*, so picture and sound are coupled by writing the same number twice.
```html
<!-- impact frame at 12.400 s; measured peak_offset 0.0740 s -> data-start 12.326 -->
<audio id="sfx-impact-07" src="assets/sfx/impact/hit_low_03.wav"
       data-audio-group="sfx" data-start="12.326" data-duration="1.10"
       data-track-index="12" data-volume="0.211"></audio>

<!-- riser peaking at 0.92 x 9.766 s = 8.985 s, resolving on the same frame -->
<audio id="sfx-riser-02" src="assets/sfx/riser/designed_riser_cinematic_01.wav"
       data-audio-group="sfx" data-start="3.415" data-duration="8.985"
       data-track-index="13" data-volume="0.150"></audio>
```
If the visual event lives inside a sub-composition at scene-local `t`, the root-level audio needs `data-start = t + slot data-start`. Every `<audio>` needs an `id` — an id-less audio element is never mixed and the render is silently missing the sound. Keep SFX in `data-audio-group="sfx"`, never in the voice group used by `data-fx-carve`.

**Verification is a render, not a preview.** The audio render path runs in an `OfflineAudioContext` in a headless browser, and per constraint 3 the browser legs (`render`, `snapshot`, `preview`) must run off the ARM64 device VM. Measure the *rendered* MP4's audio with the same 10 ms command on the host that rendered it.

**Remotion:** the same offset arithmetic, expressed as a negative `startFrom` on an `<Audio>` inside a `<Sequence>`. Concept only — Remotion is not part of this stack.

## Pairs with
[[sfx-peak-on-impact-frame]] · [[sfx-peak-on-the-cut]] · [[sfx-motion-pass-two-rules]] · [[sfx-appearance-transient]] · [[sfx-split-edit-lead-lag]] · [[sfx-av-sync-binding-window]] · [[sfx-library-build-and-taxonomy]] · [[sfx-repetition-variant-rotation]] · [[sfx-beat-aligned-handover]] · [[sfx-riser-to-music-drop-backtiming]] · [[motion-impact-frame-quantisation]] · [[cut-outpoint-inpoint-alignment]]

## Failure modes
- **Placing by file start.** The commonest sync error in creator work: `data-start` set to the event time, so the sound arrives however late its own attack is — typically 40–120 ms, which is 1–4 frames of visible lateness. Fix: subtract the measured offset.
- **Trusting the sample peak on a noisy file.** One stray clipped sample can sit 100 ms from the audible attack. Fix: use the envelope peak, and flag any file where the two disagree by more than 3 ms.
- **Measuring the mp3 preview and placing the WAV.** Different envelopes, different peak. Fix: measure the file you will actually ship.
- **Forgetting to re-measure after processing.** A pitch shift with `asetrate` rescales the whole timebase, so a 0.074 s offset at +4 semitones becomes 0.059 s. Fix: re-measure derived files as new assets.
- **Aligning a riser by its peak without checking length.** The peak is at the end, so `data-start` goes strongly negative and the riser gets clamped to 0 and lands early. Fix: use the `riser_anchor` route and trim with `data-media-start`.
- **Multi-hit files aligned to the loudest hit.** A "Impact, Debris, Tail" file's second crash may be louder than its first. The ear syncs to the first. Fix: earliest peak within 3 dB of the maximum.
- **Known gap:** nothing in `hyperframes check` validates sync at all — the linter reads audio JSON for exactly two conflicts and never compares audio to picture. Peak alignment is unguarded by construction, which is why the acceptance test in this note is a measurement of the render rather than a gate.
