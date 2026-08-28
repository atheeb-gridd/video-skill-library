---
id: cut-dissolve-time-passage
title: Dissolve to show passage of time — and how to build the montage around it
skill: editing
type: transition
family: dissolve
tags: [skill/editing, type/transition, family/dissolve, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:47"
    quote: "The dissolve is commonly used to show a passing of time, either within a scene or from one scene to the next."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:43"
    quote: "This — instead of fading from a colour, we just fade to a new shot."
research_refs:
  - https://www.toolsforfilm.com/glossary/dissolve
  - https://www.studiobinder.com/blog/what-is-a-dissolve-in-film-definition/
  - https://en.wikipedia.org/wiki/Dissolve_(filmmaking)
  - https://www.masterclass.com/articles/what-is-a-dissolve-in-filmmaking-how-to-know-when-to-use-a-dissolve-transition
  - https://borisfx.com/blog/dissolve-transition-tutorial-2024-what-are-dissolves/
difficulty: medium
detectable_from: video
---

# Dissolve to show passage of time — and how to build the montage around it

## What it is
A dissolve overlaps the tail of one shot with the head of the next so both are briefly visible, with no solid colour in between. Its primary narrative job is **elapsed time**: a task that took an hour, a night becoming morning, a wait, a build-up. It works *between* scenes and equally *within* one — three dissolves across the same tripod framing say "this went on for a while" more economically than any line of narration. The dissolve's length is its meaning: short reads as a soft join, one second reads as time passing, three seconds reads as memory or dream. Note the distinction from its sibling: a **fade** goes to a solid colour and means "something ended" ([[cut-fade-bookend]]); a dissolve makes the much weaker and more usable claim that time moved. [[cut-dissolve]] covers the dissolve as a transition primitive — its definition, its mechanics and when a dissolve is legal at all; this note covers the specific job the source names for it, and how to build the montage that carries it.

## When to use it
Four triggers. (1) **A compressed process** — assembly, cooking, writing, a build, a workout — where the point is that it took time, not how it was done. (2) **A wait or an interval** — night to morning, before to after. (3) **A subjective register** — memory, dream, reflection; here the dissolve runs long and usually pairs with a change in grade or sound. (4) **Inside a scene**, on a locked-off framing, to skip forward without implying a new location. Do **not** use a dissolve to join two shots merely because a hard cut felt rough — that is what a J cut or a matched cut is for ([[cut-j-audio-leads-picture]], [[cut-movement-match]]), and a decorative dissolve is the single most reliable amateur signature in long-form.

## How to recognise it in a reference video
- **Scene detection under-reports dissolves.** A gradual blend produces a broad, low-scoring hump instead of a single spike. Run a second pass at a lower threshold and inspect:
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=4,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ```
  A hard cut is one frame scoring **25+**; a dissolve is a run of **8–40 consecutive frames** each scoring roughly **3–10**. The length of that run *is* the dissolve length in frames.
- **Frame ladder.** Extract every frame across the candidate. Mid-dissolve frames contain **both** shots' structures superimposed — unmistakable once seen, and the way to separate a dissolve from a soft camera move.
- **No solid-colour frame.** If any frame is flat black/white, it is a fade or a dip, not a dissolve. Check mean luma across the run: a dissolve's luma follows a smooth interpolation between the two shots' levels and never bottoms out.
- **Length classification, and it is the whole diagnosis** (at 30 fps): **12–18 f (0.4–0.6 s)** = a soft join, barely noticeable, no time claim; **24–36 f (0.8–1.2 s)** = the standard "time passed"; **60–90 f (2–3 s)** = memory, dream, or a major temporal jump. Film convention states the same range as 12–72 frames at 24 fps.
- **Repetition is the montage tell.** Time-passage dissolves come in **runs of 3–6**, at similar lengths, on similar hold durations. One isolated 1-second dissolve in a hard-cut video is usually a scene change; three in a row is a montage.
- **Hold-to-dissolve ratio.** Measure each shot's fully-opaque hold and divide the dissolve length by it. Rhythmic montages sit near **0.25–0.35**; a ratio above ~0.6 means the montage is more blend than image and will read as mush.
- **Audio behaviour is the confirmation.** In a real time-passage montage the **music runs continuously across every dissolve** and the *ambience* crossfades with the picture, while dialogue is absent. If the music also cuts at each dissolve, the editor was joining scenes, not compressing time.
- **Transcript test.** Narration over a time-passage montage is either absent or summarising ("a few hours later", "by the end of the week"). Narration that describes each shot means it is an illustrative B-roll sequence, not a dissolve montage.
- **Grade drift.** A subjective-register dissolve usually carries a look change across it — warmer, desaturated, softer. Log it; it is a parameter, not an accident.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `dissolve_length` | 30 f (1.00 s) | 12–90 f | 12–18 f soft join · 24–36 f standard time passage · 60–90 f memory/dream. The HyperFrames transition registry caps its own transitions at **2.0 s**, so anything above 60 f must be hand-authored. |
| `shot_hold` | 90 f (3.00 s) | 45–150 f | Fully-opaque time on each shot, excluding the dissolves either side. |
| `hold_to_dissolve_ratio` | 0.33 | 0.20–0.50 | `dissolve_length ÷ shot_hold`. Above 0.6 the montage reads as mush. |
| `shot_count` | 4 | 3–6 | Under 3 it is a scene change, not a montage; over 6 without variation it becomes wallpaper. |
| `length_jitter` | ±10% | 0–20% | Slight variation reads organic; identical lengths read mechanical; more than 20% reads as a mistake. |
| `final_dissolve_length` | 1.4× the others | 1.0–2.0× | The last dissolve out of the montage runs longer, landing the sequence. |
| `ease` | `power2.inOut` | `sine.inOut`, `power1.inOut`, `power2.inOut` | Calm family only. Never `back`/`elastic`/`bounce` on a dissolve. |
| `music_action` | `continue` | `continue` \| `build` | Music must not cut at the internal dissolves. It may build, and should resolve on the exit. |
| `ambience_crossfade` | = `dissolve_length` | 0.8–1.5× | Ambience crossfades with picture; a hard ambience cut under a dissolve is instantly audible. |
| `dialogue` | none | — | Dialogue across a time-passage dissolve fights the time claim. Voice-over summary is fine. |
| `exit_alignment` | on a musical event | — | Land the end of the final dissolve on a downbeat or a section change ([[pace-cut-on-the-beat]]). |
| `grade_drift` | none | none \| warm \| desaturate | Only for the subjective register, and applied consistently across all shots in the run. |
| `background_clash` | check | — | If the two shots' dominant backgrounds differ strongly, use `blur-crossfade` instead of a plain crossfade — the blur masks the clash. |

## Reproduction prompt

```
Build a time-passage dissolve montage covering the interval {{INTERVAL}}
(e.g. "the four hours of the build"), placed at composition time {{IN}}.

1. Select {{N}} shots (default 4, range 3-6) that read as PROGRESS, not as
   variety: each must show a later state of the same process, place or
   subject than the one before. Order them by that progression, never by
   how good the shot is. If you cannot state what changed between shot k
   and shot k+1, drop one of them.
2. Set the rhythm: shot_hold = 90 frames (3.00s) of fully opaque time per
   shot; dissolve_length = 30 frames (1.00s); jitter each dissolve by up to
   +/-10% so it does not read mechanical. Make the FINAL dissolve out of
   the montage 1.4x longer than the internal ones.
3. Author each dissolve as an OVERLAP: pull the incoming clip's start
   earlier by dissolve_length, and extend the outgoing clip so it is still
   playing for the whole overlap. Cross-animate opacity on BOTH clips at
   the SAME timeline position - outgoing to 0 and incoming from 0 to 1,
   duration = dissolve_length, ease power2.inOut. Never dip to black
   between them; if any frame is fully black you have built two fades.
4. Sound: one continuous music bed across the whole montage, never cut at
   an internal dissolve. Crossfade each shot's ambience over exactly
   dissolve_length. No dialogue inside the montage; a single summarising
   voice-over line is allowed and must sit at the montage's start, not
   across a dissolve.
5. Land the end of the final dissolve on a musical downbeat or section
   change, within +/-4 frames.
6. For a memory/dream register instead of plain elapsed time: raise every
   dissolve to 60-90 frames, apply one consistent grade drift across all
   shots, and drop the ambience to a single sustained tone.
7. ACCEPTANCE TEST: (a) step through each dissolve - mid-dissolve frames
   must contain both images and no frame may be solid black; (b) measure
   dissolve_length / shot_hold - it must sit between 0.20 and 0.50;
   (c) play the montage muted - the shots must read as a sequence in time,
   which a viewer can confirm by naming what changed; (d) play it with
   sound - the music must be unbroken; (e) count the dissolves in the whole
   video: if dissolves appear anywhere OUTSIDE a deliberate time claim,
   replace those with hard cuts.
```

## Execution spec

**HyperFrames (primary).** A dissolve is an authored overlap plus a paired opacity animation. The visibility window is half-open, so overlap is created by pulling the incoming clip's `data-start` earlier by the dissolve length and giving the outgoing clip enough `data-duration` to still be playing:

```html
<!-- 4-shot montage: 3.00s holds, 1.00s dissolves, starting at 40.00s -->
<video id="mtg-1" src="s1.mp4" muted playsinline class="clip"
       data-start="40.00" data-duration="4.00" data-media-start="2.0" data-track-index="0"></video>
<video id="mtg-2" src="s2.mp4" muted playsinline class="clip"
       data-start="43.00" data-duration="4.00" data-media-start="1.4" data-track-index="1"></video>
<video id="mtg-3" src="s3.mp4" muted playsinline class="clip"
       data-start="46.00" data-duration="4.00" data-media-start="0.8" data-track-index="0"></video>
<video id="mtg-4" src="s4.mp4" muted playsinline class="clip"
       data-start="49.00" data-duration="5.40" data-media-start="3.2" data-track-index="1"></video>
<!-- 1.00s = 30f @30fps. Each clip overlaps the next by 1.00s.
     Track indices ping-pong 0/1 - display convention only; layering is CSS z-index. -->
```

```js
// one paused timeline per composition; positions are absolute composition seconds
const D = 1.0;                       // 30f
[
  ["#mtg-1","#mtg-2",43.0],
  ["#mtg-2","#mtg-3",46.0],
  ["#mtg-3","#mtg-4",49.0],
].forEach(([out, inc, T]) => {
  tl.to(out,               { opacity: 0, duration: D, ease: "power2.inOut" }, T);
  tl.fromTo(inc, { opacity: 0 }, { opacity: 1, duration: D, ease: "power2.inOut" }, T);
});
// exit dissolve, 1.4x: 42f = 1.4s
tl.to("#mtg-4", { opacity: 0, duration: 1.4, ease: "power2.inOut" }, 53.0);
```

Contract details that decide whether this runs:
- **Outgoing and incoming must animate at the same position `T`.** The banned pattern is fading the old shot out and *then* animating the new one in — that is "a jump cut with a dip, not a transition".
- Use **`fromTo`, never `from`** — `from()` writes its start state at construction time, before the clip's window opens, and flashes under non-linear seek.
- Land each tween **before** the clip's `data-duration`, not on it; the window is `[start, start+duration)` and the final frame of an animation landing exactly on the boundary is never rendered.
- Do **not** put a CSS `opacity` or `transform` initial state on these elements as well — `gsap_css_transform_conflict` is a hard lint error, and a CSS `transition` on an animated element interpolates independently of seek.
- The registry's `crossfade` (0.5 s default) and `blur-crossfade` (0.6 s, the default when the two shots' backgrounds clash) are the machine equivalents, but the registry's `max_duration_s` is **2.0**, so a 60–90 f memory dissolve is hand-authored as above. Registry budget advice still applies: pick 2–3 transition types for the whole video and repeat them.

**ffmpeg (only when the montage must exist as a file).** `xfade` bakes a dissolve between two inputs; `offset` is where the transition begins in the first input's timeline:

```bash
ffmpeg -i s1.mp4 -i s2.mp4 -filter_complex \
 "[0:v][1:v]xfade=transition=fade:duration=1.0:offset=3.0,format=yuv420p[v]" \
 -map "[v]" -an mtg12.mp4
```
Chain it pairwise for a longer montage, or prefer the composition route — the contract is explicit that in-composition trimming and blending needs no new file, and that a physical cut is for assets leaving the pipeline.

**Epidemic Sound.** One bed for the whole montage, plus per-shot ambience:
- Bed: `SearchRecordings { query.term: "steady building instrumental progress", filter { bpm: 90-110, vocals: false } }` — instrumental, because the montage may carry voice-over, and `SearchSimilarToRecording` for the neighbouring sections.
- Ambience: `SearchSoundEffects { query.term: "<location> ambience loop" }` per shot, each crossfaded over the dissolve length with a `volume` automation lane (clip-local `t`, and remember the lane holds its first value backwards to the clip start, so an explicit `{t:0}` point is required).
- Carve the bed against the `voiceover` group rather than ducking it, if there is narration: `data-fx-carve` with `strength: 0.25` on the **bed**, never on a voice.

**Remotion:** two overlapping `<Sequence>`s with interpolated opacity; concept only, no Remotion runtime here.

## Pairs with
[[cut-dissolve]] · [[cut-fade-bookend]] · [[cut-fade-to-white]] · [[cut-j-audio-leads-picture]] · [[pace-cut-on-the-beat]] · [[pace-silent-demonstration-window]] · [[struct-music-arc-to-narrative-arc]] · [[motion-look-finishing-pass]] · [[sfx-music-sets-the-mood]]

## Failure modes
- **Dissolving because the cut felt rough.** The dissolve then asserts elapsed time that did not elapse, and the viewer reads the edit as soft rather than the scene as later. Fix: hard cut, or a J cut, or a matched cut.
- **Cutting the music at each dissolve.** The single most common montage error. Each dissolve becomes a scene change and the sequence stops compressing time. Fix: one unbroken bed; only ambience crossfades.
- **Fading out then fading in.** Two half-fades with black between is not a dissolve — and animating the outgoing element on its own at a scene boundary is the pattern the transition contract explicitly bans. Fix: both tweens at the same `T`.
- **Uniform lengths and holds.** Perfectly regular dissolves read as a slideshow template. Fix: ±10% jitter, and a 1.4× exit dissolve.
- **Dissolve longer than the hold.** At ratios above ~0.6 the montage never resolves into a clean image. Fix: raise the holds before shortening the dissolves — short holds also lose the shot's content.
- **Shots that show variety instead of progress.** Four pretty angles of the same unchanged state say nothing about time. Fix: require a one-clause statement of what changed between consecutive shots.
- **Reaching for a registry transition at 3 seconds.** The registry caps at 2.0 s and a longer value will be clamped or rejected. Fix: hand-author the crossfade pair.
- **Dialogue across the dissolve.** Continuous speech contradicts a time jump. Fix: move the line before the montage, or convert it to summarising voice-over.
- **Known gap:** the 12/24/72-frame ladder is film convention documented at 24 fps; the 30 fps numbers here are the direct conversion (15/30/90) rounded to the values editors actually use (12–18/24–36/60–90). No study ties dissolve length to a measured perception of elapsed time — treat the bands as convention, and let the reference video's measured lengths override them.
