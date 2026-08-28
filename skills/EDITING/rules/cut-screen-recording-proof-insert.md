---
id: cut-screen-recording-proof-insert
title: Prove the advice with a screen recording, and punctuate the result as a moment
skill: editing
type: cut
family: screen-recording
tags: [skill/editing, type/cut, family/screen-recording, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:39"
    quote: "You apply the filter here and boom — music that will fit my video has arrived."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:01:33"
    quote: "So I personally use Epidemic Sound, and there I can search for music by BPM."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:58"
    quote: "So first of all, if you're putting a sound effect on a cut, place the highest peak of the sound effect on the cut."
research_refs:
  - https://www.clueso.io/blog/how-to-make-tasteful-screen-capture-videos
  - https://www.envision.everspringpartners.com/build/best-practices-for-screencast
  - https://www.capcut.com/create/zoom-effects-for-tutorial-videos-guide-attention
  - https://prepublish.ai/blog/visual-pattern-interrupts-editing
  - https://link.springer.com/article/10.3758/s13414-013-0605-z
difficulty: medium
detectable_from: transcript+video
---

# Prove the advice with a screen recording, and punctuate the result as a moment

## What it is
An abstract instruction ("filter the library by BPM") is discharged by **showing the actual software doing it**, and the moment the results appear is edited as an **event** — "and boom" — rather than as a passive scroll. The insert has a fixed four-beat shape: **claim → the control being operated → the payoff appearing → return to the presenter.** The payoff beat is where the craft is: a punch-in on the control before the click, a hard cut or a scale pop on the results frame, and a sound effect whose *peak* lands on that frame. Without the punctuation the same footage is a screen recording; with it, it is proof.

## When to use it
Whenever the video makes a claim about a tool: a setting, a filter, a menu path, a search query, a before/after inside an app. Also for any claim whose evidence is a number on a screen — analytics, a price, a search result count. The trigger phrase in the script is diagnostic: *"you just…", "there's a filter for…", "you apply it here…"*. If the script says "you can just do X" and the video does not show X being done, the claim is unsupported and the viewer knows it. Do **not** use it for abstract processes with no UI (use a motion graphic), for long multi-step workflows where the interesting part is the decision rather than the clicking (narrate over stills), or where the app's UI would date the video badly — in which case show the *result*, not the chrome.

## How to recognise it in a reference video
- **Identify the screen-recording shots** in the cut list — flat lighting, straight edges, a cursor, UI text. Then measure the **insert span**: first frame of UI to first frame back on the presenter. Typical proof inserts run **150–450 f (5–15 s)**; over ~900 f (30 s) it is a tutorial section, not a proof insert.
- **Check for the four beats.** Log the timestamps of: claim (transcript), control operated, payoff visible, return to presenter. If any beat is missing, the insert is incomplete — a payoff with no visible control is unproven; a control with no payoff is a tease.
- **Zoom measurement.** Compare the UI's pixel scale before and after any punch-in — measure a known element's width in each. Restrained work uses **5–10%** (scale 1.05–1.10); published guidance says avoid more than 15% unless the UI is genuinely tiny. Anything above ~1.5× means the source was recorded larger than delivery, or the shot is soft.
- **Zoom timing.** Count frames of the zoom's motion. **4–6 f (120–200 ms)** with an ease at both ends is the documented target; a linear 20-frame crawl reads as a slideshow.
- **Cursor behaviour.** Look for a deliberate pause **before and after** each click — 250–400 ms is the practice. Fast, smooth, trail-decorated cursors are the amateur signature. Note whether the cursor is enlarged and whether there is a click ripple or highlight.
- **Dwell time on the readable value.** For each frame containing a value the viewer must read (a BPM range, a filter setting, a number), measure how long it is on screen, unmoving and unobstructed. **45–60 f (1.5–2.0 s)** for a single short value; **90 f (3 s)** if there are two or more. A picture's meaning can be extracted from very short exposures, but *reading a number* is a different task and needs seconds.
- **Freeze frames.** Look for held still frames on dense screens — **0.5–1.0 s** is the documented device. A freeze is detectable as a run of near-zero inter-frame difference:
  ```bash
  ffmpeg -i ref.mp4 -vf "tblend=all_mode=difference,signalstats,\
  metadata=print:key=lavfi.signalstats.YAVG:file=diff.txt" -f null -
  ```
  Runs of YAVG ≈ 0 lasting 15–30 frames inside a screen recording are freezes.
- **Speed changes.** Compare cursor travel speed between segments, or look for the tell-tale absence of loading time. Boring stretches in a good reference are **cut out entirely** rather than sped up; where they are sped up, expect 2–4×.
- **The payoff sound.** Check that a sound effect's **peak** — not its start — lands on the results frame, within **±1 frame**. Take a per-frame peak trace:
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=1600,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
  ```
- **Transcript punctuation.** The word "boom", "and there it is", "just like that" at the payoff frame is the verbal half of the same device. Its presence within ±10 frames of the results appearing confirms deliberate design.
- **Padding and framing.** Note whether the recording is inset with margin (~6% padding is the tasteful default) or full-bleed. Full-bleed 100% UI on a 1080p delivery is usually unreadable in feed.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `insert_span` | 240 f (8 s) | 150–450 f (5–15 s) | Claim-out to presenter-in. Over 900 f is a tutorial section. |
| `claim_to_ui_gap` | 12 f (0.4 s) | 0–30 f | Cut to the UI while the claim is still landing. |
| `punch_scale` | 1.08 | 1.05–1.15 | 5–10% is the tasteful band; above 15% only for genuinely tiny UI. |
| `punch_dur` | 5 f (0.17 s) | 4–6 f (120–200 ms) | Ease in and out. |
| `punch_ease` | `power3.out` | `power2.out`–`power3.out` | House settle. Never `back`/`elastic` on a UI move. |
| `punch_origin` | the control | — | Transform origin on the element being clicked, not frame centre. |
| `cursor_pause_pre` | 9 f (0.30 s) | 8–12 f (250–400 ms) | Cursor arrives, then stops, then clicks. |
| `cursor_pause_post` | 9 f (0.30 s) | 8–12 f | Hold after the click before any zoom, highlight or overlay. |
| `cursor_scale` | 1.4× | 1.2–1.8× | Enlarged for legibility; no trails, no decorations. |
| `value_dwell` | 60 f (2.0 s) | 45–90 f | Single readable value; 90 f for two or more. |
| `freeze_len` | 24 f (0.8 s) | 15–30 f (0.5–1.0 s) | On information-dense screens only. |
| `boring_handling` | cut out | cut \| 2–4× speed | Prefer removal to speed-up; loading time is never interesting. |
| `payoff_pop` | 0.96 → 1.00 | 0.94–0.98 → 1.00 | Scale pop on the results frame, 8–10 f, `power3.out`. |
| `payoff_sfx_peak` | on the frame | ±1 f | The hit's **peak**, not its onset, sits on the results frame. |
| `payoff_sfx_level` | −13 dB | −12 to −15 dB | The SFX layer's normal level. |
| `ui_zoom_recorded` | 115% | 110–125% | Set the app's own zoom before recording; it beats every post zoom. |
| `padding` | 6% | 0–8% | Inset with margin unless the UI is already sparse. |

## Reproduction prompt

```
Build the screen-recording proof insert for the claim at {{CLAIM}}.

PRE-PRODUCTION (do this before recording, it cannot be fixed later):
  - Set the application's own zoom to 110-125% so text is legible at
    delivery resolution. Record at 2x delivery resolution if any post
    punch-in above 1.15 is planned.
  - Enlarge the system cursor to ~1.4x. Disable cursor trails and effects.
  - Rehearse the cursor: move slower than feels natural, stop for ~0.3s
    before each click, and hold ~0.3s after it.

EDIT:
1. CUT TO THE UI 12 frames (0.4s) after the claim's last stressed
   syllable, while the claim is still resonating. Do not wait for the
   sentence to finish.
2. REMOVE EVERYTHING BORING. Delete loading waits, idle mouse wandering,
   false starts and any navigation the viewer does not need to learn. Do
   not speed these up if you can cut them; if a stretch must be kept for
   continuity, run it at 2-4x constant rate.
3. PUNCH IN ON THE CONTROL. 8 frames before the click, scale the recording
   to 1.08 over 5 frames (0.17s) with power3.out, transform origin ON the
   control being clicked. Hold the punch through the click.
4. HOLD THE VALUE. Any setting, number or field the viewer must read stays
   on screen, unmoving and unobstructed, for at least 60 frames (2.0s) -
   90 frames if there are two or more values. If the recording moves on
   sooner, insert a frozen still of that frame for 24 frames (0.8s). NOTE:
   a mid-source freeze cannot be done in-composition - export the still
   with ffmpeg and place it as an image clip.
5. PUNCTUATE THE PAYOFF. On the frame {{PAYOFF}} where the result first
   appears:
     - hard cut or scale pop the recording from 0.96 to 1.00 over 8 frames
       with power3.out (never back/elastic - this is UI, not a toy);
     - place one impact/hit sound effect with its PEAK on {{PAYOFF}},
       within 1 frame, at -12 to -15 dB;
     - optionally add a short whoosh whose peak sits 2-3 frames earlier, on
       the motion into the reveal;
     - the narration's punctuation word ("boom", "there it is") lands within
       10 frames of {{PAYOFF}}.
6. RETURN TO THE PRESENTER on a hard cut once the value has had its dwell.
   Total insert 150-450 frames (5-15s).
7. ACCEPTANCE TEST: (a) pause on any frame containing a value the script
   references - it is readable at 50% player size; (b) the four beats
   (claim, control, payoff, return) are all present and in order; (c) the
   payoff SFX peak is on the payoff frame, not its onset; (d) no zoom
   exceeds 1.15 unless the source was recorded larger; (e) every click has
   ~0.3s of stillness before and after it; (f) with the sound off, the
   insert still reads as "he did the thing and it worked".
```

## Execution spec

**HyperFrames (primary).** The recording is an ordinary muted `<video>` clip; the punch-in is a GSAP tween on it; the cursor highlight and any callout are overlay elements above it.

```html
<!-- claim ends 78.20s; insert 78.60 -> 86.60; payoff at 83.40 -->
<video id="rec" src="footage/epidemic-bpm-filter.mp4" muted playsinline class="clip"
       data-start="78.60" data-duration="8.00" data-media-start="4.20"
       data-track-index="1" style="z-index:2"></video>
<div id="rec-ring" class="clip" data-start="82.90" data-duration="0.60"
     data-track-index="2" style="z-index:3"></div>
```

```js
// punch-in on the BPM control (click at 83.10), then the payoff pop at 83.40
tl.set("#rec", { transformOrigin: "38% 26%" }, 78.60);              // the control's position in frame
tl.to("#rec", { scale: 1.08, duration: 0.17, ease: "power3.out" }, 82.83);   // 5f, ends 8f before the click
tl.fromTo("#rec", { scale: 1.04 }, { scale: 1.08, duration: 0.27, ease: "power3.out" }, 83.40); // payoff pop
tl.to("#rec", { scale: 1.00, duration: 0.30, ease: "power2.inOut" }, 85.60); // release before the return cut
```

Contract facts this leans on:
- **`transformOrigin`, `filter` and `scaleX` are lint-clean on the master timeline** — the `x/y/scale/rotation/opacity` whitelist is a scene-worker prompt rule only and does not bind `index.html`.
- Use **`fromTo`, never `from`** — `from()` sets `immediateRender: true`, writing its start state at construction time, which flashes or mis-starts under the render's non-linear seek.
- **No CSS `transform` on `#rec`.** A CSS initial transform plus a GSAP tween on the same property is `gsap_css_transform_conflict`, an **error**, and a lint error also silently switches off the layout and contrast audits.
- **No `width`/`height`/`top`/`left` tweens.** Ever. Scale and translate only.
- `data-playback-rate` is a **constant** in `0.1..5`, pitch-preserved and render-safe — fine for a flat 2–4× on a boring stretch. There is **no rate envelope**, so a speed *ramp* must be preprocessed into a derived file.
- **There is no arbitrary mid-source freeze.** Holding a frame requires a preprocessed still placed as an `<img>` clip (see ffmpeg below). Do not plan a freeze you cannot export.
- `video_nested_in_timed_element` is an **error** — time the wrapper or the video, not both. If you need a wrapper for padding, put `data-start` on one of them only.
- Layering is CSS `z-index`; `data-track-index` is display-only.
- Relevant motion rules exist by name in the animation library — `coordinate-target-zoom`, `camera-cursor-tracking`, `cursor-click-ripple`, `multi-phase-camera`, `ai-tracking-box`, `scale-swap-transition` — but the `rules/` recipe files are **not staged in this project**, so cite them by name and author the tween yourself rather than quoting code you cannot verify.
- Callout typography: video sizes, not web sizes — ≥20 px body full-screen, ≥32 px in feed; tracking −0.03 to −0.05em at display sizes.

**ffmpeg.** Three jobs: the freeze still, the trim, and the constant speed change.
```bash
# the frozen frame at 84.10s, to hold a value the recording scrolls past
ffmpeg -ss 84.10 -i footage/epidemic-bpm-filter.mp4 -frames:v 1 -q:v 2 assets/still-bpm.png
# 3x through a boring navigation stretch (constant, so data-playback-rate could do it in-comp instead)
ffmpeg -i rec.mp4 -filter_complex "[0:v]setpts=PTS/3[v]" -map "[v]" -an rec.fast.mp4
# trim the usable region without re-encoding (keyframe snap applies)
ffmpeg -i rec.mp4 -ss 4.2 -to 12.2 -c copy rec.trim.mp4
```
Then place the still as a clip: `<img id="still-bpm" src="assets/still-bpm.png" class="clip" data-start="84.10" data-duration="0.80" style="z-index:2">` — `data-duration` is **required** on an `img`.

**Epidemic Sound.** Two cues, and the peak placement matters more than the choice:
- `SearchSoundEffects { query.term: "UI click soft interface tap" }` — on the click frame, quiet (−18 to −20 dB); this is the motion/diegetic layer.
- `SearchSoundEffects { query.term: "impact hit short punchy transition" }` — the payoff, **peak on the results frame**, −12 to −15 dB.
- Optional lead-in: `SearchSoundEffects { query.term: "whoosh short fast transition" }` with its peak 2–3 frames before the payoff.
Place them in an `sfx` group at track index 12+, never in the `voiceover` carve group. Remember the placement rule from the source material: on a cut, the sound's **highest peak** goes on the cut; on a motion, the peak goes to the middle of the motion and the sound's length is matched to the motion's.

**Remotion:** conceptually a `<Sequence>` holding an `<OffthreadVideo>` with an interpolated scale and a separate `<Audio>` for the hit; no Remotion runtime in this project.

## Pairs with
[[struct-demo-before-label]] · [[pace-silent-demonstration-window]] · [[cut-b-roll-coverage-from-transcript]] · [[cut-punch-in-emphasis]] · [[sfx-unsounded-motion-audit]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-placement-discipline]] · [[motion-image-focal-point-direction]] · [[pace-bpm-matched-music-selection]] · [[sfx-air-on-micro-movement]]

## Failure modes
- **Unreadable UI.** Recorded at 100% zoom, delivered at 1080p, watched on a phone. No amount of post-zoom fixes it. Fix: set the application's zoom to 110–125% *before* recording, and record at 2× delivery if punching in.
- **Over-zooming.** A 2× post punch-in on 1080p source is visibly soft, and the viewer loses their place in the interface. Fix: 1.05–1.15, or a bigger source.
- **Cursor chaos.** Fast, tiny, trailing cursor darting to controls. Fix: enlarge, slow down, stop before and after each click, kill trails.
- **No dwell on the value.** The video shows the filter for 12 frames and moves on; the viewer never read the number the whole insert existed to show. Fix: 60 f minimum, or a frozen still.
- **Speeding up instead of cutting.** A 4× ramp through loading time still spends the viewer's attention on loading. Fix: delete it.
- **An unpunctuated payoff.** Results appearing over a continuous scroll, no cut, no pop, no sound — the proof lands as nothing. Fix: cut or pop on the results frame plus a hit with its peak on that frame.
- **SFX onset on the frame instead of its peak.** The accent then feels 3–5 frames late even though the file starts on time. Fix: slide the clip so the waveform's peak is on the frame.
- **Bouncy easing on UI.** `back.out` on a software zoom reads as a toy. The house doctrine is explicit: overshoot is a rare, explicitly-playful register, never the default. Fix: `power3.out`.
- **Insert overstays.** Thirty seconds inside the app and the video has become a tutorial. Fix: cap at 450 f, or split it into its own labelled section.
- **Known gap:** the zoom, cursor and dwell numbers come from a single well-specified screencast-craft guide plus retention-editing blogs, not from controlled reading-time studies. RSVP research shows a *picture's* meaning is available from very brief exposures, but reading a UI value is a different task with no published minimum. Treat `value_dwell` as house calibration and raise it whenever a viewer would need to hold two numbers at once.
