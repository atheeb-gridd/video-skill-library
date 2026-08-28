---
id: cut-fade-to-white
title: Fade to white for death, dreams and altered states
skill: editing
type: transition
family: fade
tags: [skill/editing, type/transition, family/fade, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:03:23
    quote: "And that colour is most commonly black, whereas a fade to white might be used to show the character dying or in a dream."
  - video: assets/videos/editing kt 2.mp4
    timestamp: 00:03:31
    quote: "Fades are commonly at the start or the end of the film, and they symbolize the beginning or the end of a story."
research_refs:
  - https://www.vice.com/en/article/death-or-glory-what-does-it-mean-when-a-film-fades-to-white/
  - https://www.mediacollege.com/video/editing/transition/fade.html
  - https://tvtropes.org/pmwiki/pmwiki.php/Main/FadeToWhite
  - https://www.premiumbeat.com/blog/the-hidden-meaning-behind-popular-video-transitions/
difficulty: low
detectable_from: video
---

# Fade to white for death, dreams and altered states

## What it is
The same operation as a fade to black with the terminal colour swapped, and the swap changes the meaning. Black reads as **closure and finality**; white reads as **ambiguity** — dying, dreaming, remembering, transcending, or waking into something new. The distinction is a documented convention rather than a rule of physics: a filmmaker-analyst supercut of the device concludes that fading to white leaves the audience asking "is it death, or a new beginning?", where black asserts the answer. Because it costs nothing but a colour choice, it is the cheapest available way to add meaning to a boundary — and the easiest to get wrong, because a badly executed white fade is indistinguishable from a blown-out exposure error.

## When to use it
At a boundary where the story leaves the concrete world: into or out of a memory, a dream, an imagined scenario, a hypothetical the narrator is describing, a death, or a deliberate loss of consciousness. In non-fiction editing the useful analogues are: entering a hypothetical ("imagine your editing was so good that…"), a reconstruction of a past event, or a final beat that is meant to feel open rather than finished. Use black instead when the boundary means *this section is over*, and use a dissolve when it merely means *time passed*.

## How to recognise it in a reference video
- **Luminance profile.** Frame-average luma rises monotonically to ≥98% of peak (Y′ ≈ 250+/255), holds, then falls. A blown highlight rolls off unevenly and never flattens across the whole frame; a fade-to-white flattens completely.
  `ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.YAVG" -f null - 2>&1 | grep YAVG`
- **Saturation collapses with the luma rise.** In a real fade to white, chroma goes to zero as luma peaks. If colour survives at peak brightness, it is an exposure blow-out, not a fade.
- **There is a hold.** Count the frames at full white: 6–20 frames is deliberate. Zero frames of hold means it is a flash, not a fade.
- **Symmetry.** Fade-out and fade-in-from-white are usually within 30% of each other in length. Wildly asymmetric = something else (a light leak, a whip pan, a camera flash).
- **Duration bands.** 8–15 frames (0.27–0.5s) reads as a *flash* or impact. 30–45 frames (1–1.5s) is a scene-boundary fade. 60–90 frames (2–3s) is a full act boundary or a death. Measure and log which band.
- **Audio is the confirmation.** Check whether the mix goes with it: bed reverb-tail into near-silence, a low-passed sustained tone, or a held note. A picture fade to white over an unchanged music bed almost always reads as an accident.
- **Transcript correlation.** Look for hypothetical or memory language ("imagine", "back then", "picture this") at the boundary.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `fade_out_frames` | 36f (1.2s) | flash 8–15f · scene 30–45f · act/death 60–90f | Frames at 30fps; author as seconds. |
| `fade_out_ease` | `power2.in` | `power2.in` \| `power3.in` | Accelerating into white; a linear ramp reads mechanical. |
| `hold_frames` | 9f (0.3s) | 6–20f | Pure white. Below 6f the boundary reads as a glitch. |
| `fade_in_frames` | 18f (0.6s) | 12–30f | Shorter than the fade out — coming back should be quicker than leaving. |
| `fade_in_ease` | `power2.out` | `power2.out` \| `sine.out` | Long-tail settle out of white. |
| `white_value` | `#FFFFFF` | `#F7F7F5`–`#FFFFFF` | A hair off pure white (`#FAFAF8`) reads warmer and less like a broadcast error on OLED. |
| `bloom_push` | 1.0 (off) | 1.0–1.6 | Optional `filter: brightness()` ramp on the outgoing clip so it blooms *into* white instead of being covered by it. |
| `desaturate_push` | 1.0 (off) | 0.4–1.0 | Optional `filter: saturate()` ramp; pairing bloom with desaturation is what makes it read as dream rather than error. |
| `audio_treatment` | duck bed to 0 across the fade | see Execution spec | Non-negotiable in practice — picture-only fades read as mistakes. |
| `sfx` | sustained tone or reverse cymbal | — | Tones create the mystery register; a hit would assert finality, which is black's job. |

## Reproduction prompt

```
Author a fade to white at {{OUT}} and a fade in from white at {{IN}}.

1. Confirm the meaning first. Fade to white ONLY for: dream, memory,
   hypothetical, death, altered state, or a deliberately open ending. If the
   boundary means "this section is finished", use black instead. Write the
   chosen meaning in the design doc.
2. Add a full-bleed white overlay layer above all picture layers. It must be
   absolutely positioned, inset 0, background #FAFAF8, opacity 0, and sit
   above every video layer by z-index (NOT by track index, which is display
   only).
3. Ramp the overlay opacity 0 -> 1 over 36 frames (1.2s) ending exactly at
   {{OUT}}, ease power2.in. Hold opacity 1 for 9 frames (0.3s). Ramp 1 -> 0
   over 18 frames (0.6s) starting at {{IN}}, ease power2.out.
4. Optional but recommended: over the same 36 frames, ramp the OUTGOING
   clip's filter from brightness(1) saturate(1) to brightness(1.45)
   saturate(0.55) so the image blooms into white rather than being covered.
5. Audio: ramp the music bed to silence over the same 36 frames using a
   volume automation lane, and hold silence through the white. Bring it back
   over the fade in. Optionally lay a sustained tone or reverse cymbal whose
   peak sits on {{OUT}}, at -18 dB relative to dialogue. Never a hit.
6. ACCEPTANCE TEST: sample frames at {{OUT}}-1, {{OUT}}, {{OUT}}+5. Frame
   average luma must exceed 250/255 with chroma at zero at {{OUT}}, and stay
   there for the hold. Watch with sound: if it reads as an exposure error,
   the bloom ramp or the audio treatment is missing. Confirm the fade in is
   shorter than the fade out.
```

## Execution spec

**HyperFrames (primary).** There is no fade-to-colour transition in the registry — the five machine transitions are `crossfade`, `blur-crossfade`, `push-slide`, `zoom-through`, `squeeze`, all of which animate scene wrappers. A colour fade is authored as an overlay plus GSAP:

```html
<!-- UNTIMED overlay: no data-start, so it is skipped by root-level auto-layout
     and needs its own positioning. High z-index, not track index. -->
<div id="white-flash"
     style="position:absolute; inset:0; background:#FAFAF8; opacity:0; z-index:900; pointer-events:none;"></div>
```
```js
// fade to white ending at 62.0s; hold 0.3s; back by 62.9s
tl.fromTo("#white-flash", { opacity: 0 },
  { opacity: 1, duration: 1.2, ease: "power2.in" }, 60.8);   // 36f
tl.to("#white-flash", { opacity: 0, duration: 0.6, ease: "power2.out" }, 62.3); // 18f
// optional bloom on the outgoing clip
tl.fromTo("#scene-a", { filter: "brightness(1) saturate(1)" },
  { filter: "brightness(1.45) saturate(0.55)", duration: 1.2, ease: "power2.in" }, 60.8);
```
Contract points: `filter` tweens are lint-clean on the master timeline. Keep the overlay **untimed** so it is not a clip — that avoids `timed_element_missing_clip_class` and keeps you clear of the ban on tweening `display`/`visibility` on a clip element (plain `opacity` is fine either way; `autoAlpha` is not, on a clip). Use `fromTo`, not `from`. Land the final tween before the root `data-duration`, since the window is half-open. If the fade must span a sub-composition boundary, the overlay belongs at the **host root** — a sub-comp timeline cannot animate host-root elements.

**Audio under the fade.** Bed ramp via a `volume` automation lane on the bed clip, `t` in clip-local seconds, with an explicit `t:0` point because the lane holds its first value backwards:
```html
data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
  {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:28.8,&quot;v&quot;:1},{&quot;t&quot;:30.0,&quot;v&quot;:0},
  {&quot;t&quot;:30.3,&quot;v&quot;:0},{&quot;t&quot;:30.9,&quot;v&quot;:1}]}]}"
```
Do not add a GSAP `volume` tween on the same track — the lane wins and the tween is silently ignored (`audio_volume_double_automation`).

**ffmpeg (only for a baked deliverable).**
```bash
# 1.2s fade to white ending at 62.0s, then 0.6s fade in from white at 62.3s
ffmpeg -i in.mp4 -vf "fade=t=out:st=60.8:d=1.2:c=white,fade=t=in:st=62.3:d=0.6:c=white" \
       -af "afade=t=out:st=60.8:d=1.2,afade=t=in:st=62.3:d=0.6" out.mp4
```
Note ffmpeg's `fade` has no hold — the two filters back to back leave a gap of pure white only if you offset the start times as above.

**Epidemic Sound:** `SearchSoundEffects { query.term: "cinematic tone sustained ambient swell", filter.duration {min: 2000} }` or `"reverse cymbal"`. Place per [[sfx-whoosh-transition-movement-reveal]]; peak on `{{OUT}}`.

**Remotion:** an interpolated overlay opacity; concept only.

## Pairs with
[[cut-graphic-match]] · [[pace-silent-demonstration-window]] · [[struct-music-arc-to-narrative-arc]] · [[sfx-whoosh-transition-movement-reveal]] · [[pace-cut-density-from-viewer-intent]] · [[cut-fade-bookend]] · [[cut-fade-to-black]]

## Failure modes
- **White with no audio move.** Reads as a rendering or exposure fault every time. Fix: the bed must go with the picture; silence in the hold is the strongest version.
- **Pure `#FFFFFF` on a bright grade.** On an OLED or an HDR-ish delivery it clips visibly and looks like a signal error. Fix: `#FAFAF8`, and check on a real display.
- **No hold.** The boundary reads as a one-frame flash and the meaning is lost. Fix: 6–20 frames of full white.
- **Using white where black belongs.** A white fade on a "that's the end of point three" boundary confuses the viewer, who is waiting for a dream that never arrives. Fix: black for closure, white for ambiguity, dissolve for elapsed time.
- **Symmetric long fades in fast content.** A 90-frame fade in a 14 CPM edit stalls the video dead. Fix: match the fade band to the pacing budget from [[pace-cut-density-from-viewer-intent]] — in a fast edit use the 8–15 frame flash variant and carry the meaning with the audio instead.
- **Known gap:** the connotation itself is convention, not measurement; the cited sources agree on ambiguity-vs-finality but give no durations. The frame bands here are craft defaults, and a human should approve the meaning claim before the fade is authored.
