---
id: cut-fade-bookend
title: Fades belong at structural boundaries, not inside scenes
skill: editing
type: transition
family: fade-dissolve
tags: [skill/editing, type/transition, family/fade-dissolve, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:31"
    quote: "Fades are commonly at the start or the end of the film, and they symbolize the beginning or the end of a story."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:03:16"
    quote: "The fade is a classic, and it's when a shot dissolves or fades to or from a solid colour."
research_refs:
  - https://www.filmeditingpro.com/fades-to-black-and-dissolves-what-you-need-to-know/
  - https://grokipedia.com/page/Dissolve_(filmmaking)
  - https://en.wikipedia.org/wiki/Dissolve_(filmmaking)
difficulty: low
detectable_from: video
---

# Fades belong at structural boundaries, not inside scenes

## What it is
A fade takes the picture to or from a **solid colour** — usually black — and it is punctuation, not connective tissue. Because it empties the frame completely, it reads to the viewer as "something ended". That makes it the correct mark for the head of a piece, the tail of a piece, and hard act breaks, and the wrong mark for anything smaller. Its sibling, the dissolve, fades one shot into another with no solid colour in between and means "time passed" — a much weaker claim, usable mid-scene. Confusing the two is the single most common transition error in amateur long-form.

## When to use it
Use a fade at exactly four places: (1) the head of the piece, coming up from black; (2) the tail, going down to black; (3) a genuine act break — the point where the video's argument changes register, not merely its topic; (4) a deliberate emptying for emphasis, where you want the viewer to sit in nothing for a beat before the next thing. Everywhere else, use a straight cut, a dissolve, or one of the registry transitions. In short-form and YouTube long-form, act-break fades are rare because act breaks are rare; the equivalent structural punctuation is a hard cut to a chapter/title card, a colour dip to the brand colour, or — most powerfully — killing the music.

## How to recognise it in a reference video
- **Luma floor.** Sample mean luma across the boundary. A true fade reaches **near zero** (or near max for a fade to white) for at least one frame. A dissolve never does; a "dip to black" that only reaches 15–20% luma is a *colour dip*, a different and much lighter device.
- **Solid-colour frames present.** Extract frames across the boundary; count how many are a flat single colour. **1–24 frames of held black** at an act break is the signature. Zero held frames = dissolve. More than ~60 held frames = the viewer believes the video has ended.
- **Position in the runtime.** Plot every fade against normalised runtime. A correctly used set clusters at **0%**, **100%**, and at most **2–4** interior points that coincide with a stated section change in the transcript. Fades scattered evenly through the runtime is the failure signature.
- **Duration.** Head fade-in **20–30 f (0.67–1.0 s)**. Tail fade-out **30–60 f (1.0–2.0 s)**. Act-break fade-out **18–36 f**, hold, then fade-in **18–30 f**. A fade under 12 f is a flash, not a fade.
- **Asymmetry.** Out is almost always longer than in. If in and out are the same length the boundary reads mechanical.
- **Audio track corroboration — the strongest single signal.** A structural fade is nearly always accompanied by the music **stopping or changing**, and by ambience dropping out. A picture fade over a bed that keeps playing unchanged is a decorative fade, i.e. a misuse.
- **Transcript corroboration.** The line before an act-break fade completes a thought; the line after starts a new one. If the sentence continues across the fade, it is not an act break.
- **Fade to white.** Read it as a specific semantic — dream, memory, death, or a hard tonal lift — not as an alternative black.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `head_fade_in` | 0.8 s (24 f) | 0.67–1.0 s | From solid colour up to picture |
| `head_black_hold` | 0.15 s (4.5 f) | 0.1–0.4 s | Sit on black briefly before lifting; also satisfies "don't start at t=0" |
| `tail_fade_out` | 1.2 s (36 f) | 1.0–2.0 s | Registry hard cap is 2.0 s |
| `act_fade_out` | 0.8 s (24 f) | 0.6–1.2 s | |
| `act_black_hold` | 0.4 s (12 f) | 0.2–0.8 s | The hold is what makes it a boundary rather than a dip |
| `act_fade_in` | 0.7 s (21 f) | 0.6–1.0 s | Shorter than the out, always |
| `fade_colour` | `#000000` | black, white, brand | White = dream/death/tonal lift; brand colour = a dip, not a fade |
| `fades_per_video` | 2 | 2–6 | Head + tail, plus 0–4 act breaks |
| `ease` | `sine.inOut` | `sine.inOut`, `power1.inOut` | Calm family. Never `back`/`elastic` on a fade |
| `music_action` | `stop` | `stop` \| `change` \| `continue` | `continue` is only valid on the head fade |
| `dissolve_length` | 1.0 s (30 f) | 0.8–2.0 s | For the *dissolve* alternative; 24–48 frames at 24fps is the film convention |
| `colour_dip_luma_floor` | 0.18 | 0.10–0.25 | Below this it stops being a dip and becomes a fade |

## Reproduction prompt

```
Place fades only at structural boundaries. Work from the beat map.

1. Classify every boundary:
   HEAD (t=0) -> fade in from black. TAIL (end) -> fade out to black.
   ACT BREAK -> only where the argument changes register, not merely topic. Verify: the sentence
     before completes; the sentence after starts fresh.
   EVERYTHING ELSE -> not a fade. Use a straight cut, a 30-frame dissolve, or a registry
     transition (crossfade / blur-crossfade / push-slide / zoom-through / squeeze).
   Cap total fades at 6. More than 4 act breaks means you have topic changes, not acts.

2. Author each fade as a full-bleed solid-colour veil above everything, never as an opacity tween
   on the footage:
   HEAD: hold {{COLOUR}} (default #000) for 4 f from t=0, then
     tl.to("#veil", { autoAlpha: 0, duration: 0.8, ease: "sine.inOut" }, 0.15);
   ACT:  tl.to("#veil", { autoAlpha: 1, duration: 0.8, ease: "sine.inOut" }, {{IN}});
         hold 12 f;
         tl.to("#veil", { autoAlpha: 0, duration: 0.7, ease: "sine.inOut" }, {{IN}} + 1.2);
   TAIL: tl.to("#veil", { autoAlpha: 1, duration: 1.2, ease: "sine.inOut" }, {{OUT}} - 1.3);
   Out is always longer than in. Nothing shorter than 12 f - that is a flash.

3. Match sound to picture: at every ACT and TAIL fade the music STOPS or CHANGES and ambience
   drops out; land the stop on a waveform peak. Only the HEAD fade may run over continuing music.

4. Never fade mid-sentence, and never to cover a bad cut.

Acceptance test: mean luma at each fade's midpoint reaches <=2% (or >=98% for white); plotted
against normalised runtime, fades sit at 0%, 100%, and only at points a transcript reader would
independently call section breaks. Anything else downgrades to a cut or a dissolve.
```

## Execution spec

**HyperFrames** — a fade is a veil, not a footage opacity tween, because the framework owns clip visibility and because a root-level full-screen fill is dropped on the layered-composite path (shader/HDR). Put the fill on a full-bleed **child**:

```html
<!-- above everything; NOT a clip: no data-start, so it is untimed and needs its own box -->
<div id="veil" style="position:absolute; inset:0; background-color:#000; opacity:1;
                      z-index:999; pointer-events:none;"></div>
```

```js
const tl = gsap.timeline({ paused: true, defaults: { ease: "sine.inOut" } });
tl.to("#veil", { autoAlpha: 0, duration: 0.8 }, 0.15);                 // head, up from black
tl.to("#veil", { autoAlpha: 1, duration: 0.8 }, 182.0);                // act break out
tl.to("#veil", { autoAlpha: 0, duration: 0.7 }, 183.2);                // ...and back in
tl.to("#veil", { autoAlpha: 1, duration: 1.2 }, ROOT_DURATION - 1.3);  // tail
window.__timelines["main"] = tl;
```

Contract points:
- `#veil` carries **no `data-start`**, so it is not a clip and `autoAlpha` on it is legal. Never tween `display`/`visibility` on a `.clip` element — lint rejects it.
- Do not set a CSS `transform` on `#veil` if you also tween one (`gsap_css_transform_conflict`, error). A plain `opacity: 1` initial value is fine because `autoAlpha` writes both `opacity` and `visibility`.
- Land the tail fade's end **before** the root `data-duration`, per the half-open window, or its last frame never renders.
- The root `data-duration` is compile-time-locked; compute `ROOT_DURATION - 1.3` at authoring time as a literal.
- The transition registry's `crossfade` / `blur-crossfade` are **shot-to-shot dissolves**, not fades to colour. Use `blur-crossfade` when the two scenes' `#root` backgrounds differ a lot. Registry `max_duration_s` is **2.0** — the same ceiling applies to your fades. Registry guidance for narrative position: opening 0.4–0.6 s, wind-down 0.5–0.7 s, outro 0.6–1.0 s (slowest and simplest).
- The four multi-scene rules still bind: exit animations are banned except on the final scene. A tail fade is the sanctioned final-scene exception. An act-break fade is a veil over both scenes, not an exit animation on the outgoing one.

**ffmpeg** — only for baking a fade into an asset that leaves the pipeline:

```bash
# 0.8s fade in from black at the head, 1.2s to black at the tail of a 92.4s clip
ffmpeg -i in.mp4 -vf "fade=t=in:st=0:d=0.8,fade=t=out:st=91.2:d=1.2" \
       -af "afade=t=in:st=0:d=0.8,afade=t=out:st=91.2:d=1.2" out.mp4
# fade to white instead
ffmpeg -i in.mp4 -vf "fade=t=out:st=91.2:d=1.2:color=white" out.mp4
```

**Epidemic Sound** — the fade's real payload is usually the music decision:
`SearchRecordings({ query:{ term:"<next section vibe>" }, filter:{ bpm:{ min:100, max:120 }, vocals:false } })` for the post-break track, and `SearchSimilarToRecording` when you want a smooth track-to-track change across the break. Stop the outgoing bed on a waveform peak with a `volume` automation lane rather than a hard end.

**Remotion**: an `<AbsoluteFill>` veil with an `interpolate`d opacity over the same frame ranges; concept only.

## Pairs with
[[cut-fade-to-white]] · [[cut-dissolve-time-passage]] · [[struct-music-arc-to-narrative-arc]] · [[struct-outcome-first-cold-open]] · [[struct-stimulation-budget]] · [[sfx-music-audition-against-picture]] · [[struct-name-define-demonstrate]] · [[cut-fade-to-black]]

## Failure modes
- **Fades used as scene glue.** A fade every thirty seconds makes the piece feel like it keeps ending, and the viewer takes one of those endings as permission to leave. Correction: downgrade all but 2–4 to hard cuts.
- **Fade with the music still running.** The picture says "ended", the bed says "continuing", and the viewer reads it as an error. Correction: stop or change the bed at every act and tail fade.
- **A "dip" mistaken for a fade.** Reaching 15% luma and coming straight back is a colour dip; if you needed a boundary it is too weak, and if you needed glue it is too heavy. Correction: decide which, then either go to true black with a hold, or use a registry transition.
- **Symmetrical in/out.** Reads mechanical. Correction: out longer than in, by roughly 1.3–1.5×.
- **No black hold at an act break.** Without the hold it reads as a dissolve through black. Correction: hold 12 frames.
- **Fade over a continuing sentence.** Correction: move the fade to the sentence boundary, or use a cut.
- **Fade longer than 2 s mid-video.** Beyond about 60 frames the viewer starts closing the tab. Correction: cap interior fades at 1.2 s; reserve the long fade for the tail.
- **Tweening the footage element's opacity instead of a veil.** The framework owns clip visibility and a shader/HDR composite drops a root-level fill. Correction: a full-bleed non-clip child with `position:absolute; inset:0`.
