---
id: cut-continuity-pass
title: The visual-continuity pass — no rough edges for a distraction to enter through
skill: editing
type: cut
family: continuity
tags: [skill/editing, type/cut, family/continuity, engine/hyperframes, engine/ffmpeg, source/editing-kt, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:37"
    quote: "If you can create a seamless flow of images, there are no rough edges, no spots where distractions can creep in. There's no point where the viewer loses immersion. The goal of this pillar is for every moment to flow seamlessly into the next. The editing should be invisible, the experience captivating."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:08:31"
    quote: "the pillar that turns your video into a digital morphine drip"
research_refs:
  - https://bop.unibe.ch/JEMR/article/download/2264/3460
  - https://editmentor.com/blog/the-30-degree-rule-in-filmmaking-how-to-maintain-continuity/
  - https://www.premiumbeat.com/blog/continuity-editing-in-film/
  - https://www.masterclass.com/articles/continuity-editing-in-film-explained
  - https://www.storyblocks.com/resources/blog/continuity-editing-in-video
difficulty: high
detectable_from: video
---

# The visual-continuity pass — no rough edges for a distraction to enter through

## What it is
Pillar 3 of the creator's editing formula, and the direct counterweight to visual variety. Variety says "keep giving the eye something new"; continuity says "and make every one of those handoffs invisible". Concretely it is a **boundary audit**: walk every adjacent clip pair in the timeline and check the eight things that make a join announce itself — angle change, screen direction, motion vector, subject scale, luma, colour, framing height, and audio room. Every one that fails is a "rough edge", and the claim in the source is that a rough edge is not merely ugly, it is an *opening*: the moment the viewer notices the edit is the moment their attention is available to leave. The pass is measurable and mostly mechanisable, which is why it belongs in the design document rather than in taste.

## When to use it
Run it as a **discrete gate after cuts are locked and before motion is authored**, then again after any recut. It is highest value where footage comes from several sources — a multicam interview, a talking head intercut with stock, screen recordings dropped between A-roll — because that is where luma and colour mismatch lives. It is the mandatory pass whenever you have two angles of the same action ([[cut-on-action]]), whenever a match cut is claimed ([[cut-graphic-match]], [[cut-movement-match]]), and whenever a reference video reads as "smooth" but you cannot say why. Skip it only where discontinuity is the deliberate register: a smash cut, a jump-cut comedy beat, a glitch-styled section, or the deliberate visual break of a pattern interrupt — in those cases log the boundary as **intentionally discontinuous** so a later pass does not "fix" it.

## How to recognise it in a reference video
Work boundary by boundary. Get the boundary list mechanically, then audit each one.

- **Boundary list:**
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=10,metadata=print:file=-" -f null - 2>/dev/null \
    | grep -B1 "lavfi.scd.score" | grep -A1 -E "score=(1[0-9]|[2-9][0-9])"
  ```
- **Extract the pair of frames either side of each cut and look at them.** This is not optional; every check below is a comparison of two stills.
  ```bash
  ffmpeg -ss <t-0.034> -i ref.mp4 -frames:v 1 out_a.png
  ffmpeg -ss <t>       -i ref.mp4 -frames:v 1 out_b.png
  ```
- **Luma and colour continuity, measured:**
  ```bash
  ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:file=-" -f null - 2>/dev/null \
    | grep -E "pts_time|YAVG|UAVG|VAVG|SATAVG"
  ```
  Compare the last pre-cut frame to the first post-cut frame. **|ΔYAVG| ≤ 12** (8-bit, 0–255) and **|ΔUAVG|, |ΔVAVG| ≤ 6** read as continuous within a scene. A ΔYAVG over ~25 inside one scene is a visible exposure pop and is the single most common rough edge in multi-source YouTube edits.
- **Angle change — the 30-degree rule.** Two shots of the same subject from camera positions **less than 30° apart** read as a mistake rather than a new angle. On the stills: if the subject's perspective is essentially identical and only its size changed, the boundary is a scale jump, not an angle change. Log it.
- **Screen direction / the 180-degree line.** The subject must stay on the same side of frame and keep the same facing across the cut. On the two stills, mark the subject's horizontal centre as a fraction of frame width and its facing direction. A flip of either is a line break.
- **Motion vector continuity.** If the subject or camera is moving, the direction and rough speed must carry. Compare `mafd` on the frames either side: a boundary from `mafd ≈ 8` to `mafd ≈ 0.3` is a motion stop at a cut, which always reads as a rough edge.
- **Subject scale step.** Measure the subject's height as a fraction of frame height in both stills. A step under **~15%** is a scale wobble (reads as an error); **20–40%** reads as an intentional new shot size; over ~60% reads as a punch and needs to be motivated.
- **Framing height / horizon.** Eyeline height as a fraction of frame height should stay within about **±5%** across a within-scene cut. A 12% eyeline jump is what makes multicam talking-head cuts feel amateur even when everything else matches.
- **Audio room continuity.** Cut the picture and listen: if the room tone changes audibly at the boundary, the join is audible even when the picture matches. This is the check that most often explains a "rough" cut with clean pictures ([[cut-j-audio-leads-picture]]).
- **The empirical target.** Continuity editing works by being *unnoticed*, and its success is measurable: in eye-tracking work, cuts with scene continuity went undetected **25.1%** of the time and cuts that additionally matched action went undetected **32.4%** of the time, against **9.4%** for a between-scene cut with no continuity. When detected at all, match-action cuts took longest to notice (**564 ms** vs 507 ms). So the highest-continuity boundary in the literature is the one that both matches scene *and* rides motion — that is the pass's ideal, and the reason [[cut-on-action]] sits at the centre of it.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `d_yavg_max` | 12 | 6–25 | Max \|ΔYAVG\| (8-bit luma mean) across a within-scene boundary. Over 25 = visible exposure pop. |
| `d_chroma_max` | 6 | 3–12 | Max \|ΔUAVG\| and \|ΔVAVG\|. Catches white-balance mismatch between sources. |
| `d_satavg_max` | 10 | 5–20 | Catches a graded clip cut against an ungraded one. |
| `min_angle_change` | 30° | 30–45° | Below 30° between camera positions the cut reads as an error unless shot size also changes ≥20%. |
| `min_scale_step` | 20% | 15–40% | Subject-height change as a fraction of frame height. Under 15% = wobble. |
| `max_scale_step` | 60% | 40–80% | Above this the boundary is a punch and must be motivated. |
| `eyeline_drift_max` | 5% | 3–8% | Eyeline height change as a fraction of frame height, within-scene. |
| `screen_side_flip` | forbidden | — | Within a scene. A flip is a 180-degree break and must be a deliberate act. |
| `mafd_ratio_max` | 4× | 2–6× | Ratio of `mafd` either side of a within-scene cut. A larger ratio is a motion stall at the join. |
| `room_tone_continuity` | required | — | Ambience must be continuous across a within-scene picture cut, by a bed or an L-cut. |
| `intentional_discontinuity` | logged | — | Every deliberately rough boundary gets a flag so later passes do not smooth it. |

## Reproduction prompt

```
Run the visual-continuity pass over the locked cut at 30fps and produce a boundary report.

1. LIST BOUNDARIES.
   ffmpeg -i cut.mp4 -vf "scdet=t=10,metadata=print:file=-" -f null -
   Record each boundary's frame index and pts_time.

2. For each boundary at time T, extract the two frames and measure both:
   ffmpeg -ss {{T_MINUS_ONE_FRAME}} -i cut.mp4 -frames:v 1 -y a.png
   ffmpeg -ss {{T}} -i cut.mp4 -frames:v 1 -y b.png
   and pull YAVG/UAVG/VAVG/SATAVG for those two frames from
   ffmpeg -i cut.mp4 -vf "signalstats,metadata=print:file=-" -f null -

3. CLASSIFY the boundary first: WITHIN-SCENE (same location/subject/continuous time) or
   BETWEEN-SCENE (new location, new subject, or a time jump). Only within-scene boundaries are
   held to the continuity thresholds. Between-scene boundaries are held only to the colour
   thresholds, and only if no transition or fade separates them.

4. For every WITHIN-SCENE boundary, test all eight and record PASS/FAIL with the measurement:
   a) |dYAVG| <= 12 ; b) |dUAVG| <= 6 and |dVAVG| <= 6 ; c) |dSATAVG| <= 10 ;
   d) camera angle change >= 30 degrees, OR subject-height change >= 20% ;
   e) subject stays on the same horizontal half of frame and keeps its facing ;
   f) subject-height step between 20% and 60% ;
   g) eyeline height drift <= 5% of frame height ;
   h) mafd(after)/mafd(before) within 4x in either direction.

5. FIX, in this order, cheapest first:
   - colour/luma FAIL -> match the two clips with a per-clip CSS filter correction on the
     incoming clip (brightness/contrast/saturate), NOT a re-grade of the whole video;
   - eyeline or scale-wobble FAIL -> reframe the incoming clip with scale + y offset until the
     measurement passes, or replace the boundary with a dissolve;
   - angle FAIL -> either drop one of the two shots, or add a >=20% shot-size change;
   - screen-side FAIL -> mirror is NOT a fix (text and asymmetry give it away); replace the shot;
   - motion-stall FAIL -> move the cut into the motion per cut-on-action, or accept it and mark
     the boundary INTENTIONAL;
   - room-tone FAIL -> lay a continuous ambience bed across the boundary, or build an L cut.

6. Any boundary you decide to leave rough gets an explicit INTENTIONAL flag with a one-clause
   reason (smash cut / jump-cut register / pattern interrupt / act break).

ACCEPTANCE TEST: every within-scene boundary either PASSES all eight or carries an INTENTIONAL
flag. Then watch the video once at full speed and write down every boundary you NOTICED. Any
boundary you noticed that is not flagged INTENTIONAL is still a rough edge and the measurements
missed it - log it and fix it by eye. The measurements are the floor, not the ceiling.
```

## Execution spec

**HyperFrames (primary).** Continuity correction is per-clip and non-destructive, which is exactly what the composition layer is for.

- **Luma/colour match on the incoming clip.** `filter` is lint-clean on the master timeline (the `x/y/scale/rotation/opacity` whitelist is a scene-worker prompt rule, not a binding constraint on `index.html`). Apply it as a static CSS filter on the clip, not a tween, so it holds for the clip's whole life:
  ```html
  <video id="shot-b" src="b.mp4" class="clip" muted playsinline
         data-start="21.40" data-duration="6.00" data-media-start="8.00" data-track-index="0"
         style="filter: brightness(0.94) saturate(1.06) contrast(1.02)"></video>
  ```
  Derive the numbers from the measurement: `brightness ≈ YAVG_target / YAVG_source`. Re-measure after rendering; a filter set by eye is a guess.
- **Reframe for eyeline/scale.** Crop and scale are composition-level: `clip-path` for the crop (render-time, source untouched) and a static `transform` for the offset — but a static CSS `transform` on an element you also tween is `gsap_css_transform_conflict` (an **error**). Put the static reframe on an inner wrapper and tween the outer, or set the reframe with a zero-duration `tl.set()` at the clip's start on a non-clip inner element.
- **Ambience across a boundary** is one `<audio>` clip spanning both picture clips at the root, on a high track index, in its own group:
  ```html
  <audio id="amb-room" src="assets/sfx/room-tone.wav" data-audio-group="ambience"
         data-start="16.00" data-duration="11.40" data-track-index="13" data-volume="0.28"></audio>
  ```
  Never put ambience in the `voiceover` group — a non-voice clip in the carve group silently poisons the next carve re-analysis.
- **Dissolve as the fallback fix.** The registry's `blur-crossfade` (0.6 s default, tier b) carries the note that it is *"default when the two scenes' `#root` backgrounds differ a lot — the blur masks the background-color clash a plain crossfade would expose."* That is literally a luma/colour-mismatch rescue, and it is the sanctioned one. `crossfade` at 0.5 s is the neutral choice; registry `max_duration_s` is **2.0**.
- **Transitions are mandatory and exits are banned.** Every composition uses transitions; every scene uses `gsap.fromTo()` entrances; exit animations are banned except on the final scene, because *"the transition IS the exit."* Outgoing and incoming animate at the same timeline position `T`.
- **This VM cannot verify.** `check`'s layout/contrast audits, `snapshot`, `preview` and `render` are all browser-backed and must run off this machine. So the ffmpeg measurements above are the only continuity evidence obtainable here, and the note's own acceptance test ends with "watch it" — which happens downstream.

**ffmpeg.** `scdet` for boundaries (`lavfi.scd.score`, `lavfi.scd.mafd`), `signalstats` for `YAVG/UAVG/VAVG/SATAVG` — both verified. For a baked correction on an asset leaving the pipeline: `-vf "eq=brightness=-0.03:saturation=1.06:contrast=1.02"`. Prefer the in-composition filter; the contract is explicit that a physical re-encode is only for assets leaving the pipeline.

**Epidemic Sound.** The room-tone bed: `SearchSoundEffects({ query: { term: "<location> room tone ambience loop" }, filter: { duration: { min: 15000 } }, sort: { by: "RELEVANCE", order: "DESCENDING" } })`. Take a long file and window it with `data-media-start` rather than looping a short one — a looping ambience with an audible seam is itself a rough edge.

**Remotion:** the same audit over adjacent `<Sequence>`s with a per-clip CSS filter; concept only, no Remotion runtime here.

## Pairs with
[[cut-on-action]] · [[cut-graphic-match]] · [[cut-movement-match]] · [[cut-audio-match]] · [[cut-dissolve]] · [[cut-j-audio-leads-picture]] · [[motion-look-finishing-pass]] · [[pace-visual-change-clock]] · [[struct-objection-character-cutaway]]

## Failure modes
- **Grading the whole video to fix one boundary.** A global grade moves every clip and breaks the pairs that were already matching. Correction: correct the *incoming* clip of the failing pair only, then re-measure both its boundaries.
- **Mirroring a shot to fix screen direction.** Text, watch hands, hair partings and asymmetric backgrounds all give it away, and once noticed it is worse than the original break. Correction: replace the shot or restructure the sequence.
- **Applying within-scene thresholds to a between-scene cut.** A new location is *supposed* to look different; forcing ΔYAVG ≤ 12 across an act break flattens the video. Correction: classify the boundary first; the classification is step 3 for a reason.
- **A dissolve on every mismatch.** Dissolves read as time passing ([[cut-dissolve-time-passage]]); using them as colour-mismatch putty makes a video that feels like it is constantly drifting. Correction: fix colour with a filter; reserve dissolves for the boundaries where softness is meant.
- **Smoothing a deliberate rough edge.** A smash cut that has been colour-matched, motion-matched and cross-faded is no longer a smash cut. Correction: the INTENTIONAL flag, set in the design document, before the pass runs.
- **Chasing continuity into invisibility with nothing left.** Perfect continuity with no variety is a smooth, forgettable video. Correction: this pillar is a counterweight to pillar 1, not a replacement — run it against [[pace-visual-change-clock]], not instead of it.
- **Known gap:** nothing in this stack measures camera angle, screen direction, eyeline height or subject scale. Those four are hand-measured from the extracted still pairs, and the design document should mark them as human-verified. `signalstats` and `scdet` cover only colour, luma and change energy. There is also no automatic face tracking or content-aware reframe in HyperFrames — Ken Burns and reframes are *"authored geometry"*, so an eyeline fix is a hand-authored number.
