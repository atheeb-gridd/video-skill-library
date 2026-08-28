---
id: cut-dissolve
title: The dissolve — cross-fade straight from one shot to the next
skill: editing
type: transition
family: dissolve
tags: [skill/editing, type/transition, family/dissolve, engine/hyperframes, engine/ffmpeg, engine/remotion, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:03:37
    quote: "Now, similar to the fade is the next transition we have, and this is the dissolve."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:03:43
    quote: "This — instead of fading from a colour, we just fade to a new shot."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:03:47
    quote: "The dissolve is commonly used to show a passing of time, either within a scene or from one scene to the next."
research_refs:
  - https://www.adobe.com/creativecloud/video/post-production/transitions/dissolve.html
  - https://www.studiobinder.com/blog/what-is-a-dissolve-in-film-definition/
  - https://ottverse.com/crossfade-between-videos-ffmpeg-xfade-filter/
  - https://www.ffmpeglab.com/articles/ffmpeg-xfade-transitions-guide.html
  - https://community.adobe.com/questions-729/is-there-a-workaround-to-get-smooth-dissolves-when-working-in-linear-color-1419574
difficulty: low
detectable_from: video
---

# The dissolve — cross-fade straight from one shot to the next

## What it is
The fade's sibling, and the source defines it by that difference: a fade goes to or from a solid colour, a dissolve goes straight to another shot, with no colour in between. Outgoing and incoming images overlap and trade opacity, so for the length of the overlap both pictures are visible at once. Its default meaning in film grammar is **the passage of time** — within a scene or between scenes — and its structural role is to **join** rather than to punctuate: where a cut asserts "next", a dissolve asserts "later, and related". It is the softest join in the vocabulary and the one most often used badly, because it is the only transition that requires no decision to apply. This note is the dissolve as a **primitive** — its definition, its duration bands and the mechanics of building one correctly; [[cut-dissolve-time-passage]] covers the specific narrative job of elapsed time and the montage built around it.

## When to use it
Three legitimate triggers. **(1) Time has passed** and you want the viewer to feel it rather than be told: a montage, a build, a before/after, a "three weeks later". **(2) The two shots are the same subject in a different state** — the same product, the same chart, the same room — where a hard cut would read as an error and a graphic match is unavailable. **(3) You want a lower-energy join in a calm section**, deliberately dropping the video's stimulation for a beat. Do **not** use a dissolve as the default join between narrative points: that is the single most reliable amateur signature in editing, and the reason is that a dissolve on unrelated shots asserts a relationship that is not there. And never dissolve on top of a match cut — the match's entire point is that the cut is invisible without help.

## How to recognise it in a reference video
- **Find the overlap frames.** Step the boundary: a dissolve has **N frames in which both images are visible simultaneously**. Count them; that count is the whole parameter.
  `ffmpeg -ss <t-0.6> -t 1.2 -i ref.mp4 -vf "fps=30" frame_%03d.png`
- **Duration bands and what they mean:**
  - **8–15 f (0.27–0.50 s)** — a "soft cut". Reads as a cut with the edge taken off; used inside a montage or between two takes of the same subject.
  - **24–48 f at 24fps = 30–60 f at 30fps (1–2 s)** — the traditional cross dissolve, and the published convention: *"most dissolves occur over 24–48 frames"*, *"shorter dissolves are more like hard cuts, and longer dissolves have a dreamlike quality."* Premiere's default transition duration is **1 second**.
  - **60–120 f (2–4 s)** — dreamlike, montage, emotional; needs a musical reason.
  - **>120 f** — a statement, essentially a superimposition.
- **Check the midpoint for a density anomaly.** Sample mean luma at the boundary's centre frame and compare with the mean of the two source frames. Three outcomes, and they identify the implementation:
  - Midpoint luma ≈ the average of both → a correct cross-dissolve.
  - Midpoint **darker** than both, or the background colour showing through → a stacked-opacity crossfade (both layers faded), which leaks the backdrop. This is a bug, and it is extremely common in web/HTML-rendered video.
  - Midpoint **brighter** than both → an additive/screen dissolve. Legitimate, but a different look.
- **Look for what is *not* there.** No scale change, no translation, no blur ramp. Any of those means you are looking at a `blur-crossfade`, `zoom-through` or a shader transition, not a dissolve.
- **Audio at the join.** A dissolve is nearly always accompanied by an audio crossfade of similar or slightly shorter length, and often by a music-section boundary. A dissolve with a hard audio cut underneath reads as broken.
- **Count them.** Dissolves per minute is a strong style fingerprint. Long-form explainer practice runs **0–2/min**; a video where most joins are dissolves is either a slideshow or an amateur edit.
- **Transcript correlation.** A meaningful dissolve sits on a sentence or section boundary and usually on a time-marking phrase ("a few weeks later", "eventually", "by then"). Mid-clause dissolves are decoration.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `dissolve_dur` | 0.50 s (15 f) | 0.27–4.0 s | Registry `crossfade` default is **0.5 s** and the registry hard cap is **`max_duration_s: 2.0`**; go longer only by hand-authoring. |
| `dur_soft_cut` | 0.33 s (10 f) | 0.27–0.50 s | Same-subject / montage joins. |
| `dur_classic` | 1.0 s (30 f) | 0.80–2.0 s | Time passing. The published 24–48-frame convention. |
| `dur_dream` | 2.5 s (75 f) | 2.0–4.0 s | Needs a musical reason. Exceeds the registry cap — author it manually. |
| `curve` | `power2.inOut` | `none` \| `sine.inOut` \| `power2.inOut` | `none` (linear) is the film-accurate ramp. `power2.inOut` (what the registry template uses) lingers at both ends and crosses fast, which shortens the perceived double-exposure — usually the better choice for busy footage. `sine.inOut` for long calm dissolves. |
| `composite_mode` | over (single-layer fade) | over \| screen | **Fade the incoming layer only**; see Execution spec. `screen` gives the additive/optical look on dark material. |
| `audio_xfade` | 0.35 s (10.5 f) | 0.20–1.0 s | Slightly shorter than the picture dissolve so the sound resolves first. Equal-power curves. |
| `pre_hold` | 0.40 s (12 f) | 0.27–1.0 s | Frames of settled picture before the dissolve begins — no camera move, no overlay animating. |
| `post_hold` | 0.50 s (15 f) | 0.33–1.0 s | Frames after it completes, before new motion starts. |
| `dissolves_per_min` | 0.5 | 0–2 | Style fingerprint. Above 2/min the video reads as a slideshow. |
| `background_behind` | opaque, matched | — | If both layers fade, the root background shows at the midpoint. Match it to the darker shot as a safety net even when using the single-layer method. |

## Reproduction prompt

```
Build a dissolve between shot A and shot B centred on {{CUT}} (composition
seconds, 30fps).

1. Justify it in one clause in the design doc: "time has passed", "same
   subject, new state", or "deliberate low-energy join". If none applies, use a
   hard cut instead - a dissolve with no reason is the clearest amateur tell in
   editing.

2. Choose DUR from the reason:
     same-subject / montage      0.33s (10 frames)
     time has passed             1.00s (30 frames)
     dreamlike / emotional       2.50s (75 frames)

3. Create the overlap by pulling shot B EARLIER by DUR, not by extending A
   past its out point:
     B.start = {{CUT}} - DUR
     A.duration is extended by DUR so A still has picture to show through the
     whole overlap.
   Shot B must be layered ABOVE shot A.

4. ANIMATE ONE LAYER ONLY. Fade shot B from opacity 0 to 1 over DUR while shot
   A stays fully opaque. Do NOT fade A out at the same time: two stacked
   half-opacity layers let the background show through at the crossover, which
   reads as a dip to black in the middle of the dissolve. Ease power2.inOut
   (or none for the film-accurate linear ramp).

5. HOLD EITHER SIDE. 12 frames of settled picture before the dissolve starts
   and 15 frames after it ends: no camera move, no punch-in, no overlay
   animating. A dissolve into or out of motion is unreadable.

6. CROSSFADE THE SOUND over 0.35s (shorter than the picture), using
   equal-power curves - both sides at 0.707, not 0.5, at the midpoint.

7. Once the dissolve is authored, remove any other transition at this boundary.
   Never stack a dissolve on a match cut or a cut on action.

ACCEPTANCE TEST: (a) render and sample mean luma on the middle frame of the
overlap - it must sit between the two source frames' means, not below both; if
it is below both, you faded two layers and leaked the background; (b) count
the overlap frames in the render and confirm they equal DUR * 30 (+/-1);
(c) watch at speed - if the join draws attention to itself as an effect, DUR is
too long; (d) count dissolves across the whole video: 2 per minute maximum.
```

## Execution spec

**HyperFrames — this is the important part, and the registry template needs a correction.** The registry's `crossfade` is:

```js
// registry template, verbatim
tl.to(__OLD__, { opacity: 0, duration: __DUR__, ease: "power2.inOut" }, __T__);
tl.fromTo(__NEW__, { opacity: 0 }, { opacity: 1, duration: __DUR__, ease: "power2.inOut" }, __T__);
```

With two absolutely-positioned stacked layers, at the midpoint the top sits at 0.5 over a bottom at 0.5, so the composite is `0.5·NEW + 0.25·OLD + 0.25·BACKGROUND` — the root background leaks 25% through the middle of every dissolve. On a dark root that is a visible dip to black. The mathematically correct cross-dissolve is `(1−t)·OLD + t·NEW`, and alpha-compositing an opaque OLD under a NEW fading 0→1 produces exactly that. So for a **dissolve** (as opposed to a scene wrapper crossfade where both wrappers are opaque-backed), fade the incoming layer only:

```html
<video id="shot-a" src="assets/a.mp4" muted playsinline class="clip"
       data-start="60.0" data-duration="12.0" data-media-start="4.0"
       data-track-index="0" style="z-index:1"></video>
<!-- B is pulled 1.0s earlier than the intended cut at 71.0 and sits ABOVE A -->
<video id="shot-b" src="assets/b.mp4" muted playsinline class="clip"
       data-start="70.0" data-duration="8.0" data-media-start="0.0"
       data-track-index="1" style="z-index:2"></video>
```

```js
const T = 70.0, DUR = 1.0;                     // 30 frames @30fps
tl.fromTo("#shot-b", { opacity: 0 },
                     { opacity: 1, duration: DUR, ease: "power2.inOut" }, T);
// #shot-a is NOT faded. Its data-duration (12.0 -> ends 72.0) covers the whole overlap.
```

Contract points that bind this:
- **Layering is CSS `z-index`, not `data-track-index`** — the track index is display-only and constrains nothing. Two clips on one track may overlap and both render, painted in CSS order. Set `z-index` explicitly.
- Shot A's `data-duration` must extend **through** the overlap; the injector pattern for registry transitions does exactly this (extend the outgoing by `duration_s`, pull the incoming earlier by `duration_s`).
- The visibility window is `[start, start+duration)`: land the opacity tween's end state slightly before A's `data-duration` or the resolved frame is never rendered.
- `fromTo`, never `from` — `from()` writes its start state at construction, before the clip is active, and flashes under the render's non-linear seek.
- The exit-animation ban ("the transition IS the exit") is about scene transitions, and this satisfies its real requirement: outgoing and incoming are handled at the same position `T`.
- If you want the registry's two-sided template anyway (legitimate when both scene wrappers carry opaque `background-color`), give both wrappers an explicit opaque background — a `.scene` div with no `background-color` is precisely what leaks.
- **`blur-crossfade` is the better registry pick when the two shots' backgrounds differ a lot** — the registry says so explicitly: *"the blur masks the background-color clash a plain crossfade would expose."* Its default duration is 0.6 s.
- Registry `max_duration_s` is **2.0**; a 2.5 s dream dissolve is hand-authored, not injected.
- **Known limitation:** browser alpha compositing happens in gamma-encoded sRGB, so a mid-dissolve is slightly duller than an optical film dissolve, which blends in linear light. This is the same difference as Premiere's Cross Dissolve vs Film Dissolve. If a specific bright-on-bright dissolve looks flat, either shorten it, or use `mix-blend-mode: screen` on the incoming layer for an additive look — accepting that additive brightens the midpoint instead.
- Do not put a CSS `transition` on either element; CSS transitions interpolate independently of seek and flicker.

**Audio.** Two `<audio>` clips overlapping by 0.35 s on **different track indices** (same index + overlap raises `duplicate_audio_track`), with mirrored `volume` lanes crossing at **0.707**, and explicit `t:0` points because a lane holds its first value backwards:

```html
<audio id="shot-a-au" src="assets/a.mp4" data-start="60.0" data-duration="11.15" data-media-start="4.0"
       data-track-index="10"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:10.80,&quot;v&quot;:1},{&quot;t&quot;:10.975,&quot;v&quot;:0.707},{&quot;t&quot;:11.15,&quot;v&quot;:0}]}]}"></audio>
<audio id="shot-b-au" src="assets/b.mp4" data-start="70.80" data-duration="7.2" data-media-start="0.0"
       data-track-index="11"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.175,&quot;v&quot;:0.707},{&quot;t&quot;:0.35,&quot;v&quot;:1}]}]}"></audio>
```

**ffmpeg — when the dissolve must be baked into a file** (export, or an asset leaving the pipeline). `xfade` for picture, `acrossfade` for sound; `offset` is measured **from the start of the first input**:

```bash
# 1.0s dissolve starting 11.0s into a.mp4
ffmpeg -i a.mp4 -i b.mp4 \
  -filter_complex "[0:v][1:v]xfade=transition=dissolve:duration=1.0:offset=11.0[v];\
                   [0:a][1:a]acrossfade=d=0.7:c1=qsin:c2=qsin[a]" \
  -map "[v]" -map "[a]" -c:v libx264 -preset veryfast -crf 18 -c:a aac out.mp4
```
Note `xfade=transition=fade` and `transition=dissolve` are different filters in ffmpeg: `fade` is the smooth cross-fade, `dissolve` is a noise-thresholded grain dissolve. For a classic cross dissolve use `transition=fade`. Re-encode is unavoidable here — `-c copy` cannot cross-fade.

**Epidemic Sound:** a dissolve usually coincides with a music section change. `SearchSimilarToRecording` on the outgoing track is the smooth route; landing the new track's first main beat on the dissolve's end frame is the stronger one. See [[struct-music-arc-to-narrative-arc]] and [[pace-cut-on-the-beat]].

**Remotion:** two overlapping `<Sequence>`s with `interpolate(frame, [0, DUR*fps], [0,1])` driving the incoming layer's opacity only; concept only.

## Pairs with
[[cut-dissolve-time-passage]] · [[cut-fade-bookend]] · [[cut-fade-to-white]] · [[cut-graphic-match]] · [[cut-audio-match]] · [[pace-cut-on-the-beat]] · [[struct-music-arc-to-narrative-arc]] · [[pace-partial-pause-removal]] · [[struct-stimulation-budget]]

## Failure modes
- **Both layers faded.** Leaks the root background at the midpoint — a dip to black inside every dissolve. Correction: fade the incoming layer only, over an opaque outgoing; or give both scene wrappers explicit opaque backgrounds.
- **Dissolve as the default join.** Reads as a slideshow and asserts relationships between unrelated shots. Correction: require a one-clause justification; cap at 2/min.
- **Dissolve into or out of motion.** The overlap becomes unreadable mush because the eye is tracking movement in two directions. Correction: 12 frames of stillness before, 15 after.
- **Picture dissolves, audio hard-cuts.** The join is heard as an error even though it is seen as smooth. Correction: audio crossfade 0.20–1.0 s, equal-power, slightly shorter than the picture.
- **Linear audio crossfade.** Dips ~3 dB at the crossover. Correction: `0.707` at the midpoint, or `acrossfade=c1=qsin:c2=qsin`.
- **Stacked on a match cut or a cut on action.** Destroys the very effect those cuts exist for. Correction: one device per boundary.
- **Too long for the section's energy.** A 2.5 s dissolve inside a fast section stalls the video dead. Correction: match the duration band to the section (`dur_soft_cut` in fast sections).
- **`xfade=transition=dissolve` used for a cross dissolve.** That ffmpeg transition is a grain/noise dissolve, not a cross-fade. Correction: `transition=fade`.
- **Known gap:** the registry's shipped `crossfade` template produces the background-leak described above whenever the scene wrappers are not opaque-backed. That is a real defect in the reproduction path and is documented here rather than worked around silently; the single-layer method in this note is the fix, and it must be recorded in the design document so a later pass does not "restore" the two-sided template.
