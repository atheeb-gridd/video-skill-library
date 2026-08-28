---
id: struct-recognisable-clip-evidence
title: Anchor every abstract term to a film clip the audience already remembers
skill: editing
type: structure
family: proof
tags: [skill/editing, type/structure, family/proof, engine/hyperframes, engine/ffmpeg, source/editing-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:02:03"
    quote: "Here is a popular J cut from the Wolf of Wall Street where we begin to hear Matthew McConaughey beating on his chest."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:00:18"
    quote: "10 important editing cuts every filmmaker should know"
research_refs:
  - https://legalclarity.org/can-i-use-movie-clips-in-my-youtube-video/
  - https://ccnmtl.columbia.edu/enhanced/noted/best_practices_in_fair_use_for_online_video.html
  - https://www.eff.org/wp/unfiltered-how-youtubes-content-id-discourages-fair-use-and-dictates-what-we-see-online
  - https://cyberlaw.stanford.edu/blog/2008/07/center-social-media-releases-code-best-practices-fair-use-online-video
  - https://www.scoredetect.com/blog/posts/fair-use-of-film-clips-in-online-reviews
difficulty: medium
detectable_from: transcript+video
---

# Anchor every abstract term to a film clip the audience already remembers

## What it is
Each abstract term in a list-of-techniques video is immediately followed by a **named, recognisable moment** from a widely-seen film — not a generic illustration, and not the creator's own footage. The teaching work is done by recognition: the viewer already holds the memory, so the new label snaps onto an existing mental object instead of having to be built from scratch. Structurally it is a three-part module — *name the term, define it in one sentence, then cut to the recognised clip while narrating what to watch for* — and it is the reason a ten-item list video can teach ten things in eight minutes. The cost is a legal and platform exposure that has to be designed for, not discovered after upload.

## When to use it
Use it for any **taxonomy video**: a list of named techniques, a glossary, a "types of X" explainer, or any moment where you introduce a term the audience has felt but never named. It is strongest where the audience's shared reference set is dense and the term is otherwise abstract — film editing, camera moves, story structure, music theory. Use your own footage instead when the term is trivially demonstrable and recognition adds nothing, or when the video's whole premise is that the creator produces the examples ([[struct-demo-before-label]]). Do **not** use it where the clip would carry the entertainment value rather than the explanation — that is the point at which a Content ID claim also becomes a fair-use problem, and the two failures arrive together for the same reason.

## How to recognise it in a reference video
- **Transcript pattern.** A term, then a naming construction: "here is a popular X from *Film*", "this scene from *Film*", "you'll recognise this from *Film*". The film's title spoken aloud is the reliable marker — a generic illustrative clip is almost never named.
- **Order.** Term → one-sentence definition → clip. Log the order; a reference that shows the clip *first* and names it after is running a different module ([[struct-demo-before-label]]) and reads very differently.
- **Clip duration.** Measure each excerpt. In craft-explainer channels these cluster tightly at **3–12 s**, with the median near **6 s**. Excerpts over ~20 s are the ones that draw claims and read as filler.
- **Narration over the clip.** Check whether the creator speaks *during* the excerpt. A clip that plays silent for its full length is a red flag on both axes — weaker teaching and a weaker fair-use posture. Log the fraction of the excerpt covered by narration; strong practice is **> 60%**.
- **Which moment was chosen.** Iconic, climactic or "the moment people watch the film for" excerpts are both the most legally exposed and, usually, the most distracting. Log whether the excerpt is the *technically illustrative* moment or the *famous* moment.
- **On-screen attribution.** Look for a title/year card or a corner caption during the excerpt. It is near-universal in the craft-channel norm even though it confers no legal protection by itself — it is a signal to the audience and a courtesy, not a defence.
- **Original audio handling.** Note whether the film's music bed is audible under the excerpt. Muting or heavily reducing the excerpt's music is standard practice specifically to avoid a *separate* music-side claim on top of the film-side one.
- **Ratio.** Total excerpt seconds ÷ runtime. Craft explainers using this device typically sit at **8–20%**. Past ~30% the video is substantially made of someone else's footage and both the legal and the editorial arguments weaken sharply.
- **Excerpt count per term.** One per term is the norm. Two clips for one term is a comparison ([[struct-inverse-pair-teaching]]), which is a different device.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `clip_duration` | 6 s (180 f) | 3–12 s | Long enough to recognise and see the technique; no longer. |
| `clip_max` | 12 s (360 f) | — | Above this, justify it in the design document. |
| `narration_coverage` | 0.7 | 0.6–1.0 | Fraction of the excerpt with the creator's own commentary over it. |
| `excerpt_ratio` | 0.15 | 0.08–0.20 | Total excerpt seconds ÷ runtime. Hard ceiling 0.30. |
| `clips_per_term` | 1 | 1–2 | Two only for a deliberate contrast pair. |
| `original_music` | muted or −18 dB | mute to −12 dB | Reduces a second, music-side claim. |
| `attribution_card` | on | on/off | Title + year, first 90 f of the excerpt, corner or lower third. |
| `iconic_moment` | avoid | — | Prefer the technically illustrative moment over the famous one. |
| `pre_clip_definition` | 1 sentence | 1–2 | The term is defined before the clip, never after. |
| `watch_for_instruction` | required | — | One clause naming what to notice, spoken before or in the first second of the clip. |
| `lead_in` | 12 f (0.4 s) | 0–24 f | Optional J-cut lead into the excerpt's own sound. |

## Reproduction prompt

```
Build a term-and-evidence module at 30fps for term {{TERM}}.

1. WRITE THE MODULE in this fixed order:
   a) NAME: state {{TERM}} plainly, on camera or over a title card. 1-4 words.
   b) DEFINE: exactly one sentence, under 20 words, saying what it is mechanically.
   c) INSTRUCT: one clause naming what the viewer should watch or listen for in the clip.
   d) SHOW: the excerpt.
   Never invert (c) and (d). An un-instructed clip is entertainment, not evidence.

2. CHOOSE THE EXCERPT. It must (i) come from a film the target audience is likely to have seen,
   (ii) demonstrate {{TERM}} unambiguously in isolation, and (iii) NOT be the film's most famous
   or climactic moment. Where the illustrative moment and the famous moment differ, take the
   illustrative one - it teaches better and is far less exposed. Name the film aloud in the
   narration.

3. CUT IT to 180 f (6.0 s); hard ceiling 360 f (12.0 s). Start the excerpt 12-24 f before the
   technique occurs so the viewer has context, and end it within 30 f of the technique resolving.
   Do not let it run on.

4. TREAT THE AUDIO. Mute or reduce the film's music bed to about -18 dB. Keep the diegetic sound
   that the technique itself depends on (for an audio-based technique, that IS the evidence).
   Speak over at least 70% of the excerpt's duration; a silent excerpt is not commentary.

5. ATTRIBUTE on screen: film title and year, appearing within the first 90 f of the excerpt,
   sized to be legible at in-feed viewing (>=24px equivalent for a data label at 1080p, larger
   for social crops).

6. BUDGET. Sum all excerpt durations across the video and divide by runtime. Keep the ratio at or
   under 0.20. If it exceeds 0.30, remove clips - not shorten them - until it does not.

7. ACCEPTANCE TEST: (a) muted and un-narrated, a viewer who knows {{TERM}} can still point at
   the frame where it happens; (b) the transcript names the film; (c) excerpt under 360 f and over
   60% narrated; (d) removing it leaves the definition standing but noticeably weaker - if removing
   it changes nothing it was decoration; (e) whole-video excerpt ratio <= 0.20.

LEGAL NOTE, craft guidance and not legal advice: there is no safe clip length. What controls is
whether the use is transformative (commentary ABOUT the clip, not merely showing it), whether you
took more than needed, and whether it substitutes for watching the original. The "heart of the
work" weighs against you even when short. Attribution is not permission. Expect an automated
Content ID claim regardless of fair use; it affects the one video, not the channel, and is
disputable. Where stakes are real, get advice.
```

## Execution spec

**HyperFrames (primary).** An excerpt is an ordinary video clip; the module is a small sub-composition so the term card, the attribution and the clip stay together and can be repeated ten times.

```html
<!-- host: one module slot per term -->
<div id="el-term-04" class="clip"
     data-composition-id="term-04" data-composition-src="compositions/term-module.html"
     data-start="186.00" data-duration="14.00" data-track-index="1"
     data-variable-values='{"term":"The J cut","film":"The Wolf of Wall Street (2013)"}'></div>
```

Inside the module composition:
```html
<video id="ex-04" class="clip" src="assets/clips/wolf-lunch.mp4" muted playsinline
       data-start="6.00" data-duration="6.00" data-media-start="0.00" data-track-index="0"></video>
<audio id="ex-04-aud" src="assets/clips/wolf-lunch.wav" data-audio-group="ambience"
       data-start="5.60" data-duration="6.40" data-media-start="0.00"
       data-track-index="12" data-volume="0.35"></audio>
```
Contract details:
- The module is a **sub-composition**, so its root **is** wrapped in `<template>`; a standalone root inside a template is the error `standalone_composition_wrapped_in_template`, and the inverse is equally fatal. The assembler drops the file's own `<head>` `<style>`/`<script>`, so scoped CSS goes **inside** the template, every rule prefixed `[data-composition-id="term-04"]`.
- Clip `data-start` values inside the module are **scene-local**; the host slot's `data-start` is what places them globally. Sub-comp timelines **cannot** animate host-root elements — keep the attribution card inside the module.
- `data-variable-values` on the host is the per-instance override for declared composition variables; `data-var-text` binds an element's own text to a scalar variable id. That is how ten modules share one file.
- Repeated modules mean repeated ids on the assembled page. **Prefix every id with the composition id** (`#term-04-title`) — the compiler stamps `data-hf-render-id` on `video[src]`/`audio[src]`/`img[src]`, but media declared with `<source>` children is **not** stamped, so unique ids still matter.
- **Trim in the composition, not on disk.** `data-media-start` + `data-duration` windows the excerpt without cutting a file. Cut a physical file only if the excerpt has to leave the pipeline.
- **Attribution typography.** At full-screen viewing, data labels want ≥16px and body ≥20px; **in-feed viewing** raises those to ≥24px and ≥32px. Track −0.03 to −0.05em at display sizes because video encoding compresses letter detail. `Inter` is bundled but on the banned-monoculture list — Montserrat, Oswald, Archivo Black, IBM Plex Mono are safe bundled picks. Google Fonts is a **network path and unavailable here**; use a bundled family or a local `@font-face`.
- Do not load GSAP or any library from a CDN — `cdn.jsdelivr.net` is blocked by the egress allowlist. Vendor GSAP locally and reference it with a relative path.

**ffmpeg — preparing excerpts.** Extract each excerpt once, frame-accurately, and keep the source outside the vault mount (the mount cannot delete files, so scratch work must not live there):
```bash
ffmpeg -i source.mkv -ss 00:41:12.4 -to 00:41:18.4 -c:v libx264 -preset veryfast -crf 18 \
  -c:a aac -movflags +faststart clips/wolf-lunch.mp4
```
Do **not** add `-c copy`: stream copy snaps to keyframes and can silently swallow a six-second cut. To strip or reduce the film's music while keeping dialogue you have no clean tool here — there is **no stem separation in this stack** — so either mute the excerpt's audio entirely and narrate over it, or accept the original mix at a reduced level:
```bash
ffmpeg -i clips/wolf-lunch.mp4 -vn -ar 48000 -ac 2 -af "volume=-18dB" clips/wolf-lunch.wav
```

**Epidemic Sound.** Not the source of excerpts, and cannot be. Its role here is the **module's own** bed and the small marker sound on each term card — `SearchSoundEffects({ query: { term: "soft ui pop marker" }, filter: { duration: { max: 800 } } })` — and varying it per term via `SearchSimilarToSoundEffect` so ten identical pops do not become the third named sound-design mistake.

**Remotion:** a parameterised `<TermModule>` component rendered ten times with different props; concept only.

## Pairs with
[[struct-name-define-demonstrate]] · [[struct-demo-before-label]] · [[struct-enumerated-promise-and-counter]] · [[struct-inverse-pair-teaching]] · [[motion-list-item-marker-card]] · [[cut-j-audio-leads-picture]] · [[cut-j-curiosity-lead]] · [[struct-credibility-anchor]]

## Failure modes
- **The clip before the definition.** The viewer watches six seconds of a film with no idea what to look at, and recognition becomes distraction. Correction: name, define, instruct, *then* show.
- **The famous moment instead of the illustrative one.** It is the most exposed excerpt legally and the most distracting editorially, because the audience stops learning and starts watching the film. Correction: pick the technically clearest moment, even if it is obscure.
- **Silent excerpts.** A clip left to play with no commentary is neither teaching nor transformative. Correction: narrate over ≥70% of it.
- **Excerpt creep.** Six-second clips become twelve become twenty, and the video becomes a compilation. Correction: enforce the whole-video ratio, and cut clips rather than trimming them.
- **Unrecognisable references.** A clip from a film the audience has not seen does none of the work the device depends on and is just stock footage with extra risk. Correction: if you cannot assume recognition, use your own footage.
- **Attribution mistaken for permission.** A title card is a courtesy; it does not license anything. Correction: keep the card *and* the fair-use discipline; they are independent.
- **Copying a film's audio wholesale.** The excerpt's music triggers a separate claim from the film's own. Correction: mute or heavily reduce the music bed and keep only the diegetic sound the technique needs.
- **Known gap:** this stack has no rights management, no Content ID pre-check, and no stem separation to isolate dialogue from score. Excerpt clearance, claim risk and any decision to publish are outside the pipeline; the design document should carry the excerpt list, durations and ratio so a human can review them before publish. This note is craft guidance and is not legal advice.
