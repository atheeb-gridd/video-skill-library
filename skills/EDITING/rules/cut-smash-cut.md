---
id: cut-smash-cut
title: The smash cut — maximise the contrast across the join so the cut is felt
skill: editing
type: cut
family: smash-cut
tags: [skill/editing, type/cut, family/smash-cut, layer/music, layer/sfx, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:05:03"
    quote: "It's a harsh, abrupt cut from one scene to the next, with contrasting visuals and audio."
research_refs:
  - https://en.wikipedia.org/wiki/Smash_cut
  - https://en.wikipedia.org/wiki/EBU_R_128
  - https://en.wikipedia.org/wiki/Orienting_response
  - https://en.wikipedia.org/wiki/Diegesis
difficulty: medium
detectable_from: transcript+video
---

# The smash cut — maximise the contrast across the join so the cut is felt

## What it is
A hard cut placed where the viewer does not expect one, joining two scenes chosen because they are **as unlike each other as possible** — in brightness, in shot scale, in motion energy, and above all in loudness. It is the deliberate inverse of the invisible cut: everything the continuity toolkit does to smooth a join is removed, and the resulting jolt becomes punctuation in its own right. The standard description is a cut that goes *"from a fast-paced frenzied scene to a tranquil one, or going from a pleasant scene to a tense one"*, and it lands *"at unexpected moments during a scene"* — the unexpectedness is half the payload.

Its mechanism is the **orienting response**: a large, sudden environmental change captures attention involuntarily. That also sets its economics. The response **habituates**, so the third smash cut in a video costs the same to build and returns almost nothing. It is a scarce resource, and the whole craft of the technique is choosing the two shots so that the contrast is large enough to be *measurably* large, not merely different.

Two named comedic variants share the same mechanics: the **Gilligan cut** (US) / **bicycle cut** (UK), where a character declares something and the film cuts immediately to them doing the exact opposite; and the shock variant, where a violent action cuts to a mundane analogue (the knife descending, then vegetables being chopped).

## When to use it
Use it at a **structural surprise**: the reveal that inverts the premise, the punchline that contradicts the claim just made, the wake-from-nightmare, the "and then reality happened" beat, the hard entry into a new act after a build. Use it when the two sides are already maximally different and you want the difference itself to carry meaning — a smash cut between two similar shots is just a cut.

Use it at most **twice per ten minutes**, and never adjacent to another attention device: a smash cut immediately after a riser-and-drop, a full-screen transition or a hard music drop competes with itself. Do not use it inside an explanation the viewer is trying to follow — it is a comprehension cost, and [[pace-visual-mush-ceiling]] governs the frames either side. Do not use it as a general scene change; that is [[cut-hard-cut-for-new-information]].

## How to recognise it in a reference video
Measure the **15 frames before** and **15 frames after** the join and compare:
- **Loudness delta ≥ 8 LU** short-term, in either direction. A true smash cut usually shows **10–15 LU**. This is the single strongest signal and it is measurable with `ebur128`.
- **Mean-luminance delta ≥ 25% of range** — e.g. Y going from ~0.15 to ~0.55 normalised, or the reverse. Anything under 10% is not a smash cut.
- **Shot-scale jump of two steps or more** on the standard scale (ECU → MS → WS): a close-up cutting to a wide, or a wide cutting to a macro.
- **Motion-energy inversion:** one side under ~2 px/frame mean displacement, the other over ~10. A frozen frame cutting to chaos, or chaos cutting to stillness.
- **Cut placed mid-gesture or mid-word.** The outgoing shot is severed, not completed. On the transcript, the last word before the join is often clipped or the sentence is unfinished.
- **No transition of any kind.** No dissolve, no dip, no crossfade — the presence of even a 4-frame dissolve disqualifies it.
- **Audio hard-cuts with the picture** on the same frame, with **no crossfade** and no L/J overlap. Sometimes there is a deliberate **1–3 frame gap of silence** immediately before the incoming, which sharpens the entry.
- **A diegetic/non-diegetic flip** is common at the join: score on one side, only location sound on the other. A score that continues unbroken across the cut means it is not a smash cut, it is a match cut with a shock image.
- **Frequency:** if you find more than two in ten minutes, the edit is using them as commas and the effect is already dead.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Short-term loudness delta across the join | 12 LU | 8–18 LU | Measure over 15 f each side with `ebur128`. Under 8 LU it is not felt. |
| Mean-luminance delta | 30% of range | 25–60% | Either direction; dark→bright and bright→dark both work. |
| Shot-scale jump | 2 steps | 2–4 steps | ECU/CU/MS/WS/EWS. |
| Motion-energy ratio | 5:1 | 3:1–20:1 | Mean inter-frame displacement, quiet side vs busy side. |
| Transition length | 0 f | 0 f | Non-negotiable. Any dissolve destroys it. |
| Audio crossfade | 0 f | 0 f | Hard cut. De-click ramps of ≤10 ms are allowed and are not a fade. |
| Pre-cut silence gap | 0 f | 0–3 f | 2 f of silence before the incoming sharpens a quiet→loud smash. Never over 3 f. |
| Impact on the incoming frame | optional | 0–1 hit | Only for the loud side. A hit on a quiet incoming shot contradicts it. |
| Riser before the join | none | 0 or 20–45 f | Only for the **loud→louder** variant. A riser telegraphs, which fights the surprise — never use one for the comedic variant. |
| Incoming shot hold | 45 f (1.5 s) | 30–90 f | The new scene must be readable; do not cut again immediately. |
| Comedic (Gilligan) cut offset | +2 f after the last syllable | 0 to +5 f | Cut on or just after the claim's final consonant. |
| Budget | 2 per 10 min | 1–3 | Habituation. |

## Reproduction prompt

```
Place a smash cut at {{T}} seconds between the outgoing scene A and the
incoming scene B. 30fps; HyperFrames authors seconds (seconds = frames / 30).

1. QUALIFY THE PAIR before building anything. Measure both sides over the
   15 frames adjacent to {{T}}: short-term loudness of A and of B, mean
   luminance of A and of B, shot scale of each, and mean inter-frame motion
   of each. The pair QUALIFIES only if loudness differs by >= 8 LU AND
   luminance differs by >= 25% of range AND shot scale differs by >= 2
   steps. If it does not qualify, either choose a different incoming shot or
   use a plain hard cut and stop here.
2. CHOOSE THE FRAME. Cut A mid-action or mid-word - the outgoing shot must
   feel severed, never completed. For the comedic (Gilligan) variant, place
   {{T}} 2 frames after the final consonant of the claim being contradicted.
3. CUT PICTURE AND SOUND ON THE SAME FRAME. No dissolve, no dip, no
   crossfade, no L-cut, no J-cut. Handles are zero.
4. HANDLE THE AUDIO SEAM. Apply a 10ms ramp to zero on the outgoing track
   and a 10ms ramp from zero on the incoming, purely to prevent clicks -
   this is a de-click, not a fade, and must never exceed 0.01s. For a
   loud-to-quiet smash, optionally insert 2 frames of near-silence (ambience
   only) immediately before B.
5. STOP THE SCORE. If non-diegetic music is playing on A, it ends AT {{T}}
   with the same 10ms ramp. Do not carry a bed across a smash cut - a
   continuous bed converts the jolt into an ordinary scene change.
6. OPTIONAL ACCENT, at most one: if B is the loud side, land a single impact
   with its measured peak exactly on frame {{T}}; if B is the quiet side,
   add nothing at all. Never add a whoosh AND an impact.
7. PROTECT COMPREHENSION. Hold B for at least 45 frames before the next cut,
   and do not put burned-in text on B's first 25 frames - the viewer is
   still reorienting.
8. ACCEPTANCE TEST: (a) re-measure - loudness delta >= 8 LU, luminance delta
   >= 25%, both confirmed on the rendered file; (b) step through frames
   {{T}}-1 and {{T}} - there must be no blended frame anywhere; (c) no click
   at the audio seam; (d) play at full speed - the cut should make you
   flinch slightly on first viewing; (e) count smash cuts in the whole
   video - if there are more than 2 per 10 minutes, demote the weakest to a
   plain hard cut.
```

## Execution spec

**Measuring the qualification (ffmpeg).** This is the part that turns "contrasting" into a number:
```bash
# short-term loudness either side of the join (read the S: values around 92.0s)
ffmpeg -i scene_a.wav -af ebur128=peak=true -f null - 2>&1 | grep -E "S:"
ffmpeg -i scene_b.wav -af ebur128=peak=true -f null - 2>&1 | grep -E "S:"

# mean luminance of the frames either side
ffmpeg -ss 91.5 -t 0.5 -i scene_a.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG" -f null - 2>&1 | tail -20
ffmpeg -ss 0    -t 0.5 -i scene_b.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG" -f null - 2>&1 | tail -20

# motion energy proxy: scene-change score / frame difference
ffmpeg -i scene_b.mp4 -vf "select='gt(scene,0)',metadata=print" -f null - 2>&1 | head -40
```

**HyperFrames — the cut is just two clips butted together.** The half-open visibility window is what makes a true hard cut possible with no shared frame: *"Two clips can therefore be authored back to back (`b.start === a.start + a.duration`) with no overlapping frame."*

```html
<!-- picture: zero handles, zero overlap -->
<video id="sc-a" src="footage/chase.mp4" muted playsinline class="clip"
       data-start="86.00" data-duration="6.00" data-media-start="12.40" data-track-index="0"></video>
<video id="sc-b" src="footage/kitchen.mp4" muted playsinline class="clip"
       data-start="92.00" data-duration="4.50" data-media-start="0.00"  data-track-index="0"></video>

<!-- sound cuts on the same frame; 10ms de-click ramps only -->
<audio id="sc-a-au" src="footage/chase.mp4" data-audio-group="production"
       data-start="86.00" data-duration="6.00" data-media-start="12.40" data-track-index="10"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:5.99,&quot;v&quot;:1},{&quot;t&quot;:6.00,&quot;v&quot;:0}]}]}"></audio>
<audio id="sc-b-au" src="footage/kitchen.mp4" data-audio-group="production"
       data-start="92.00" data-duration="4.50" data-media-start="0.00" data-track-index="11"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:0.01,&quot;v&quot;:1}]}]}"></audio>

<!-- the score ends AT the cut, with the same 10ms ramp -->
<audio id="bed" src=".media/audio/bgm/chase_bed.mp3" data-audio-group="music"
       data-start="70.00" data-duration="22.00" data-track-index="12" data-volume="0.55"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:21.99,&quot;v&quot;:1},{&quot;t&quot;:22.00,&quot;v&quot;:0}]}]}"></audio>
```
Contract facts that bind this:
- **Do not use the transition registry here.** Every entry (`crossfade`, `blur-crossfade`, `push-slide`, `zoom-through`, `squeeze`) creates an overlap by pulling the incoming clip's `data-start` earlier. A smash cut is defined by the absence of that overlap.
- The multi-scene doctrine states *"Every composition uses transitions"* and *"Exit animations are BANNED"*. A smash cut is the sanctioned exception at **one** boundary — note it in `STORYBOARD.md` as `**Transition:** none (smash cut)` so a later pass does not "fix" it by injecting one.
- Two `<audio>` clips **sharing a `data-track-index` and overlapping in time** warns `duplicate_audio_track`; these do not overlap, but keeping them on 10 and 11 costs nothing.
- Lane `t` is **clip-local seconds**, and a lane **holds its first value backwards to the clip start** — hence the explicit `{t:0}` point on every lane above.
- JSON attributes **double-quoted with `&quot;`**, or `carve.mjs` cannot see them.
- Every `<audio>` needs an `id`, or it is never mixed (silent render, no error).

**The optional impact (Epidemic Sound).**
```
SearchSoundEffects { query.term: "impact hit hard slam",        filter.duration { max: 4000 } }
SearchSoundEffects { query.term: "cinematic braam sub impact",  filter.duration { max: 6000 } }
```
`DownloadSoundEffect` to `assets/sfx/`. Measure the file's peak time `PEAK_T` and place at `data-start = {{T}} − PEAK_T`, exactly as in [[sfx-cinematic-hit-emphasis]] — do not eyeball it. Put it in the `sfx` group, never the `voiceover` carve group.

**ffmpeg — assembling a flattened smash cut.** Zero-handle concatenation with a re-encode (do **not** use `-c copy`: stream copy snaps to keyframes and can swallow the cut):
```bash
ffmpeg -i chase.mp4  -ss 12.40 -t 6.0 -c:v libx264 -preset veryfast -crf 18 -c:a aac a.mp4
ffmpeg -i kitchen.mp4 -ss 0     -t 4.5 -c:v libx264 -preset veryfast -crf 18 -c:a aac b.mp4
printf "file '%s'\n" a.mp4 b.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy smash.mp4
```
Keep scratch files outside the mounted vault — the mount cannot delete files.

**Remotion:** two `<Sequence>`s with adjacent `from` values and no transition component. Not part of this project.

## Pairs with
- [[cut-hard-cut-for-new-information]] — the ordinary cut this one is an extreme case of
- [[cut-straight-hard-cut]] — the baseline mechanics of a zero-handle join
- [[sfx-silence-as-pattern-interrupt]] — the audio-only sibling; do not fire both at once
- [[sfx-cinematic-hit-emphasis]] — the optional impact, and how to align its peak
- [[sfx-riser-anticipation-build]] — only for the loud→louder variant, never for comedy
- [[struct-misspeak-correction-gag]] — a comedic home for the Gilligan variant
- [[pace-deliberate-continuity-break]] — the broader family of intentional discontinuity
- [[pace-visual-mush-ceiling]] — the hold the incoming shot owes the viewer
- [[struct-stimulation-budget]] — the census that keeps smash cuts scarce

## Failure modes
- **Contrast that is merely "different".** Two medium shots of two rooms at similar brightness is a scene change, not a smash cut, and the build effort is wasted. Measure before you commit.
- **Carrying the score across the join.** A continuous bed smooths exactly what you were trying to break. The music ends at the cut or it is not a smash cut.
- **Adding a transition later.** A pass that injects the house `blur-crossfade` at every scene break will silently destroy this one. Mark the boundary in `STORYBOARD.md`.
- **Using it more than twice.** Habituation is fast and total; the third is decorative.
- **Cutting on a completed action.** A shot allowed to finish does not feel severed. Cut mid-gesture.
- **Piling on effects.** Riser + whoosh + impact + smash cut is four attention devices on one frame, and the result is noise. Pick one accent, or none.
- **Putting text on the incoming frame.** The viewer spends the first ~15 frames reorienting and cannot read. Delay any title by 20–25 frames.
- **Clicking at the seam.** A hard cut on a non-zero sample clicks. The 10 ms de-click ramp is mandatory and is not a fade.
- **Known gap:** nothing in this stack measures loudness delta, luminance delta or motion energy across a cut — the qualification step is ffmpeg analysis you run yourself, and `check` will not catch an under-contrasted "smash cut". Neither does anything protect the boundary from a later transition-injection pass.
