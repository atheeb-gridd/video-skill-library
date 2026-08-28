---
id: sfx-layer-stem-demo
title: Prove the layers — build a cumulative stem demo of one clip
skill: sound-design
type: mix
family: layers
tags: [skill/sound-design, type/mix, family/layers, engine/hyperframes, engine/ffmpeg, engine/epidemic, layer/dialogue, layer/ambience, layer/music, layer/sfx, layer/design, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:32"
    quote: "To make you feel the importance of each sound layer, I'll play each layer along with the video. So here it is with just voiceover."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:03:13"
    quote: "So here's our video with all 5 layers combined."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:00:44"
    quote: "Not much fun, right? So to add some, here comes layer number two: ambient sounds. These are the sounds that build your scene."
research_refs:
  - https://blog.prosoundeffects.com/sound-layering
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - mcp://Epidemic_sounds/SearchRecordings (per-recording stems DRUMS/BASS/INSTRUMENTS verified live, 2026-08-27)
difficulty: medium
detectable_from: transcript+video
---

# Prove the layers — build a cumulative stem demo of one clip

## What it is
A structural device with a sound-design build: hold **one** short picture clip constant and replay it N times, adding exactly one audio layer per replay, ending with all layers together. Pass 1 is dialogue only. Pass 2 adds ambience. Pass 3 adds foley. Pass 4 adds effects. Pass 5 is the finished mix. The viewer does not have to accept that each layer matters — they hear the difference, which is the only argument that works on a subject people habitually skip.

It also solves a teaching problem the assertion cannot: each layer's contribution is only audible **in context with the layers below it**. Ambience alone is nothing; ambience under a dry voiceover is the moment a room appears. The cumulative order is what makes each addition legible, and it is the same order as the build order the library uses for real work, so the demo doubles as a rehearsal of the pipeline.

This note is the *build* half. The editorial framing — where the device sits in a script and why it earns its screen time — is [[struct-progressive-layer-demo]].

## When to use it
- **Teaching or explainer content about sound.** This is its native use.
- **Before/after proof in a portfolio or a client deliverable.** Two passes (dry vs finished) rather than five.
- **As an internal QA pass on any real video.** Building the demo forces every layer onto its own bus, which is exactly the arrangement that makes the mix diagnosable. Even if the demo never ships, the grouping should stay.
- **Not for a video whose subject is not sound.** Five replays of one clip is 15 seconds of screen time spent on a single idea; only a video about audio can afford that.

## How to recognise it in a reference video
- **The picture repeats verbatim.** Compare frames between passes: identical framing, identical action, identical duration. If the picture varies, it is a montage, not this device.
- **Count the passes and check monotone accumulation.** Pass k must contain every layer of pass k−1 plus exactly one more. A pass that swaps a layer instead of adding one breaks the argument and should be logged as a defect.
- **Measure the loudness ladder.** Programme loudness rises with each pass, typically **1–3 LU per pass**, and levels of the already-present layers must not change:
  `ffmpeg -ss <pass_start> -t <pass_len> -i ref.wav -af ebur128 -f null -`
  If an earlier layer's level moves between passes, the demo was re-balanced per pass — honest work does not.
- **Listen for what enters.** Pass 2's addition shows as a continuous low-level broadband floor (ambience). Pass 3's shows as discrete transients tied to on-screen movement (foley). Pass 4's shows as non-real-world sweeps and hits. Pass 5's shows as a harmonic bed.
- **Look for the label.** Almost every instance carries an on-screen label per pass ("just voiceover", "+ ambience"). Absent labels make the device much harder to follow.
- **Check the clip length.** Working instances use **2.5–4 s** of picture; longer and the repetition becomes tedious, shorter and there is not enough material for a layer to register.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Passes | 5 | 2–5 | Two-pass (dry vs mix) is the portfolio form. |
| Picture length per pass | 3.0 s | 2.5–4.0 s | Identical every pass. |
| Gap between passes | 0.2 s | 0–0.4 s | A short beat so the restart is legible; 0 if the clip loops cleanly. |
| Total device length | 16 s | 6–20 s | 5 × 3.0 + 4 × 0.2 = 15.8 s. |
| Level of layers already present | unchanged | unchanged | Non-negotiable — re-balancing per pass invalidates the demo. |
| Dialogue | 0 to −3 dB (`data-volume` 1.0–0.708) | — | Layer 1. |
| Ambience | −26 dB (`0.05`) | −30 to −24 dB | Layer 2. |
| Foley | −18 dB (`0.126`) | −20 to −15 dB | Layer 3. |
| Sound effects | −13 dB (`0.224`) | −12 to −15 dB | Layer 4. |
| Music | −22 dB (`0.079`) | −20 to −25 dB | Layer 5. |
| Label | one per pass, top-left | — | Enters with the pass, not before it. |
| Carve | on from pass 5 only | — | The bed is the only layer that needs it; earlier passes have no bed. |

## Reproduction prompt

```
Build a 5-pass cumulative stem demo from the source clip {{SRC}} between
{{CLIP_IN}} and {{CLIP_OUT}} (target length 3.0 s).

LAYER MAP (fixed order, do not reorder):
  L1 dialogue/voiceover  L2 ambience  L3 foley  L4 sound effects  L5 music

1. PREPARE THE LAYERS FIRST, at final level, for the 3 s window only:
   L1 the clip's own voiceover; L2 one ambience bed matching the location
   (query "<place> ambience" or the room-tone shelf); L3 the foley for every
   physical action in the window, placed on contact frames; L4 the designed
   effects for every motion in the window; L5 the music bed, intro trimmed.
   These are the same assets the real mix uses - build them once.

2. LAY OUT THE PASSES. For pass k (k = 1..5) at
     P_k = (k-1) * 3.2
   place ONE picture clip:
     <video data-start="P_k" data-duration="3.0" data-media-start="{{CLIP_IN}}"
            muted playsinline>
   and copies of layers L1..Lk, each with:
     data-start = P_k + (layer's offset inside the window)
     data-duration, data-media-start, data-volume IDENTICAL across all passes
     a UNIQUE id per copy (e.g. amb-p2, amb-p3, amb-p4, amb-p5)
     data-audio-group = "dialogue" | "ambience" | "foley" | "sfx" | "music"
   That is 1+2+3+4+5 = 15 audio placements plus 5 picture clips. Do not try to
   reuse one audio element across passes - a clip has one data-start.

3. LABEL EACH PASS. One text clip per pass, data-start = P_k, duration 3.0:
   "just voiceover" / "+ ambience" / "+ foley" / "+ sound effects" / "+ music".
   Fade in over 0.25 s with power2.out; do not animate it on the clip element
   itself - use an inner wrapper with autoAlpha.

4. DO NOT RE-BALANCE. Every layer's data-volume must be byte-identical in every
   pass it appears in. If pass 5 is too loud, fix it by lowering L5 in ALL
   passes it appears in (i.e. just pass 5) - never by touching L1-L4.

5. CARVE ONLY WHERE THE BED EXISTS. Put every dialogue copy in the "voiceover"
   group; add data-fx-carve (sources ["voiceover"], strength 0.25) to the pass-5
   music clip only. Then run:
     node <SKILL_DIR>/scripts/carve.mjs --comp index.html

6. VERIFY EACH PASS with a loudness read:
     ffmpeg -ss P_k -t 3.0 -i mix.wav -af ebur128 -f null -
   Expect a monotone rise of roughly 1-3 LU per pass.

ACCEPTANCE TEST: play the whole device. The picture is identical every pass. On
each replay you can name the layer that just arrived without being told. No
already-present layer changes level. The final pass is the actual mix used
elsewhere in the video - not a special mix built for the demo. Total runtime is
under 20 s.
```

## Execution spec

**Hyperframes.** Two routes exist; the first is strongly preferred here.

**Route A — one composition, duplicated clips (recommended).** A clip has exactly one `data-start`, so a layer appearing in four passes is four `<audio>` elements with four ids. That is verbose but it is one render, fully deterministic, and it keeps the whole device seekable in Studio. Group by layer so each layer has one fader:

```html
<hf-audio-group id="dialogue"  data-label="L1 Dialogue"  data-volume="1"></hf-audio-group>
<hf-audio-group id="ambience"  data-label="L2 Ambience"  data-volume="1"></hf-audio-group>
<hf-audio-group id="foley"     data-label="L3 Foley"     data-volume="1"></hf-audio-group>
<hf-audio-group id="sfx"       data-label="L4 Effects"   data-volume="1"></hf-audio-group>
<hf-audio-group id="music"     data-label="L5 Music"     data-volume="1"></hf-audio-group>

<!-- pass 2 = L1 + L2, starting at 3.2 s -->
<video id="pic-p2" src="assets/video/clip.mp4" class="clip"
       data-start="3.2" data-duration="3" data-media-start="41.2"
       data-track-index="0" muted playsinline></video>
<audio id="vo-p2"  src="assets/audio/voice/line.wav" data-audio-group="dialogue"
       data-start="3.2" data-duration="3" data-track-index="10" data-volume="1"></audio>
<audio id="amb-p2" src="assets/audio/amb/office-roomtone.wav" data-audio-group="ambience"
       data-start="3.2" data-duration="3" data-track-index="11" data-volume="0.05"></audio>
```

Note the project convention in force: `<video muted>` plus a separate `<audio>` for its sound — *"the pattern to reach for when picture and sound are cut independently"*, which is precisely this case. Give each layer its own `data-track-index` so overlapping clips never share one (`duplicate_audio_track`). Every `<audio>` needs an `id` or it is never mixed → silent render.

**Route B — one composition per pass, rendered and concatenated.** `data-hidden` on an `<hf-audio-group>` *"drops every member from the mix"*, so a pass is one attribute toggle per layer. Render five times, then concat. Two hard costs make it the fallback: rendering is browser-dependent and **must happen off the authoring VM** (linux ARM64, no sudo), and **the mounted vault cannot delete files**, so every intermediate render must get a distinct name and nothing can be cleaned up. If you take this route:

```bash
# five renders, distinct names (nothing can be deleted afterwards)
npx hyperframes render . -o renders/demo_pass1.mp4   # after setting data-hidden on L2..L5
# ...repeat per pass...
printf "file '%s'\n" renders/demo_pass1.mp4 renders/demo_pass2.mp4 \
  renders/demo_pass3.mp4 renders/demo_pass4.mp4 renders/demo_pass5.mp4 > /tmp/list.txt
ffmpeg -f concat -safe 0 -i /tmp/list.txt -c copy renders/demo_concat.mp4
```
Keep `list.txt` and any scratch **outside** the mount. `-c copy` only works if all five renders share codec settings — they will, from one project.

**ffmpeg.** Per-pass loudness verification (`ebur128`) is the check that the demo is honest. To build a two-pass portfolio version from an existing mix and an existing voice stem without re-rendering: cut the same picture window twice with `transcript-cut.mjs --keep`, mux stem A onto the first and the full mix onto the second, then concat as above.

**Epidemic Sound.** The music layer is where the stems matter: `SearchRecordings` returns a `stems` list per recording and `DownloadRecording` takes `stemType: FULL | BASS | DRUMS | INSTRUMENTS`. For a **six-pass** variant that splits music into rhythm and melody, download `DRUMS` for pass 5 and `INSTRUMENTS` for pass 6 — verified available on live results such as *Open Roads* (106 BPM) and *SOS* (115 BPM). Ambience for L2 comes from the `ambience--room-tone` shelf (uniform 120 s beds) or the `<place> + ambience` formula; foley for L3 from the object shelves (`paper--handle`, `computers--keyboard-mouse`).

**Remotion.** `{[1,2,3,4,5].map(k => <Sequence key={k} from={(k-1)*96} durationInFrames={90}>{layers.slice(0,k).map(L => <Audio src={L.src} volume={L.vol} />)}<Video src={clip} muted /></Sequence>)}` — the cumulative slice is the whole device in one expression, which is the one place Remotion expresses this more cleanly than a declarative clip list.

## Pairs with
[[struct-progressive-layer-demo]] · [[sfx-five-layers-build-order]] · [[sfx-layer-volume-targets]] · [[sfx-sound-pass-order]] · [[sfx-ambience-search-formula]] · [[sfx-diegetic-action-inventory]] · [[sfx-beat-forward-bed-under-voice]] · [[sfx-playback-verification-loop]] · [[struct-name-define-demonstrate]] · [[struct-inverse-pair-teaching]]

## Failure modes
- **Re-balancing per pass.** The commonest and most damaging error: making each pass "sound good" hides the very contribution the demo exists to show. Levels are fixed across passes.
- **Swapping instead of adding.** Pass 3 with foley but no ambience is a different demo and proves nothing about accumulation.
- **A different picture per pass.** The viewer then attributes the change to the picture. Same frames, same duration, every time.
- **No labels.** Viewers can hear that something changed and cannot say what. One label per pass.
- **Too long.** Five passes of a 6 s clip is 30 s spent on one point. Cap the clip at 4 s.
- **Reusing one `<audio>` element across passes.** Impossible — a clip has one `data-start`. Duplicate with unique ids.
- **Route B on the authoring VM.** Render, snapshot and preview are browser-dependent and cannot run there; and nothing can be deleted from the mount afterwards. Plan the render host and the file names up front.
- **Known gap:** there is no mute/solo automation and no stem-render flag in the CLI, so a per-pass stem render means either duplicated clips (Route A) or repeated whole-composition renders with `data-hidden` toggled by hand (Route B). Neither is automated; whichever you choose belongs in the build manifest as explicit steps.
