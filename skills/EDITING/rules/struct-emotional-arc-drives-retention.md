---
id: struct-emotional-arc-drives-retention
title: Emotional investment is the engine of engagement — plan the arc, and buy it with music first
skill: editing
type: retention
family: emotional-arc
tags: [skill/editing, type/retention, family/emotional-arc, layer/music, layer/sfx, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/editing-kt, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:11:56"
    quote: "These sound effects work so well because they play on the viewer's emotions. And that's powerful, because the more emotionally invested viewers are, the more engaged they are."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:20"
    quote: "even in some normal editing, if you put good music on it, the video will become engaging. But even after very strong editing, if the music isn't good, it still doesn't work."
research_refs:
  - https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1460-2466.2000.tb02833.x
  - https://communication.iresearchnet.com/information-processing/limited-capacity-model/
  - https://bryantanner.wordpress.com/2014/01/22/the-science-of-orienting-response-what-is-it-about-media-that-engages-learners/
  - https://psu.pb.unizin.org/psych425/chapter/circumplex-models/
  - https://prepublish.ai/guides/youtube-retention-guide
difficulty: medium
detectable_from: transcript+video
---

# Emotional investment is the engine of engagement — plan the arc, and buy it with music first

## What it is
The stated mechanism behind risers, hits and tones is that they act on emotion, and emotion is what converts a viewer into an engaged viewer. The research literature says the same thing in its own vocabulary: the **limited-capacity model of motivated mediated message processing** holds that arousing content increases the resources a viewer allocates to a message, and that structural features — "cuts, edits, video graphics, sound effects" — elicit **orienting responses**, automatic attention that allocates resources to encoding. Two consequences follow, and this note is about both. First, an edit should be planned as an **emotional arc**, a curve of arousal and valence over time, rather than as a list of information. Second, the cheapest and strongest lever on that curve is **music**, which is why the source's blunt claim holds up: ordinary cutting plus the right track reads as engaging, virtuoso cutting plus the wrong track reads as flat. Music selection is therefore a **structural decision made early**, not a polish step made last.

## When to use it
Do this once per video, at plan time, before the first cut is locked, and revisit it once after the rough assembly. It is the layer above every pacing decision: cut density, silence, punch-ins, hits and music changes all become derivable from a curve instead of guessed one at a time. It is also the right diagnostic when a video is technically clean and still "feels flat" — a flat arousal curve is a measurable, fixable defect. Two limits. **This is a budget, not a maximum:** the model also says over-arousing content degrades encoding, so the arc has to include troughs. And **it does not override the format's contract** — a companionship or long-form-authentic format is *supposed* to have a shallow curve, and imposing a thriller arc on it is a different failure ([[struct-stimulation-budget]]).

## How to recognise it in a reference video
- **Build the arousal proxy curve.** You cannot measure emotion, but you can measure its four carriers, in 30-second bins across the whole runtime, and the composite is a usable proxy:
  1. **cuts per 30 s** — `ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd`
  2. **short-term loudness** — `ffmpeg -i ref.mp4 -af "ebur128=peak=true:framelog=verbose" -f null - 2>&1 | grep "S:"`
  3. **discrete SFX events per 30 s** (hits, whooshes, risers), counted from a per-frame peak trace
  4. **music presence and level** per bin
  Normalise each to 0–1, average, and plot. That curve is the video's arousal shape.
- **The flat-curve test.** If the composite varies by less than **±0.15** for stretches longer than **90 s**, the video has no arc in that region. This is the most actionable finding the analysis pass can produce.
- **Peaks and troughs.** Count local maxima. Well-shaped long-form runs **3–5 peaks per 10 minutes**, each with a trough before it — a peak with no preceding trough does not read as a peak.
- **Valence, from the transcript.** Label each section positive / neutral / negative from the words alone. Then check the music and grade agree with the label. A negative-valence section carried by an upbeat major-key bed is a mismatch you can hear and now name.
- **Map onto the circumplex.** Russell's model gives four quadrants — high-arousal/positive (excited), high-arousal/negative (tense), low-arousal/positive (calm, content), low-arousal/negative (sad, flat). Plot each section. A video that never leaves one quadrant is the flat case; one that visits three or four in ten minutes has an arc.
- **Structural-feature rate.** Count formal features (cuts, graphics arrivals, SFX, zooms) per minute. Classic television research found recognition improving with added cuts only up to a point and then falling sharply — the practical reading is that feature *rate* is a resource, and that a rate high enough to feel like a music video buys attention at the cost of retention.
- **Retention corroboration, where you have the curve.** Benchmarks to compare against: under 5 min → 65–75% average retention is strong; 5–10 min → 50–60%; 10–15 min → 40–50%; 15+ min → 35–45%. A drop of **40% or more in the first 30 seconds** indicates the opening does not deliver on the title. Published practice puts deliberate re-engagement beats near the **25% and 65% marks** and reports 4–8 percentage-point lifts, with a **30–60 s** stimulus-change interval as the working cadence.
- **The mute test for music.** Play a section with the dialogue muted. If the remaining audio still communicates a register, the bed was chosen; if it is wallpaper, it was scrolled to ([[sfx-vibe-brief]]).

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `arousal_delta_per_60s` | 0.20 | 0.15–0.35 | Minimum movement of the normalised composite curve per minute. Below 0.15 for >90 s is a flat region. |
| `peaks_per_10min` | 4 | 3–5 | Each needs a trough before it. |
| `trough_len` | 20 s (600 f) | 12–45 s | Long enough to reset; short enough not to lose the viewer. |
| `valence_flips` | 3 | 2–4 per 10 min | Positive↔negative section changes. Zero flips is a monotone video. |
| `stimulus_change_interval` | 45 s | 30–60 s | Change *something*: register, visual mode, camera, music, pace. |
| `reengagement_marks` | 25% and 65% | — | Deliberate beats placed at these fractions of runtime. |
| `first_30s_drop_ceiling` | 40% | — | Above this the opening is the problem, not the body. |
| `music_lever_order` | 1st | — | When the curve is wrong, change the music before re-cutting. Cheapest per unit of effect. |
| `bpm_to_delivery` | 100–120 | 80–140 | Fast delivery → higher BPM; slow delivery → lower. Inverting it makes the video feel off. |
| `music_coverage` | 0.75 | 0.4–0.9 | Fraction of runtime with a bed. 1.0 is a failure mode — the bed stops being heard. |
| `sfx_emotional_trio` | riser / hit / tone | — | Riser builds, hit releases and punctuates, tone creates unease. One per peak, not three. |
| `feature_rate` | 12 /min | 6–25 /min | Formal features (cuts, graphic arrivals, SFX, zooms). At the top of the band you are buying attention with retention. |

## Reproduction prompt

```
Design and verify the emotional arc for {{VIDEO}} (30fps) before locking
the edit.

1. SECTION the transcript into 6-12 blocks at topic boundaries. For each,
   write two numbers and one word: AROUSAL 0-1, VALENCE +1/0/-1, and the
   single emotion word you want the viewer to have (e.g. "curious",
   "uneasy", "relieved", "impressed").
2. DRAW THE CURVE. Plot arousal against time. Enforce three rules:
   - arousal must move by at least 0.20 every 60 seconds;
   - there are 3-5 peaks per 10 minutes, and every peak is preceded by a
     trough of at least 12 seconds;
   - valence changes sign 2-4 times per 10 minutes.
   If the plan violates any of these, change the SECTION ORDER or the
   section content - do not try to fix a flat script with effects.
3. ASSIGN LEVERS per section, in this order of leverage:
   (a) MUSIC: pick vibe from the emotion word, BPM from the delivery speed
       of that section (fast talking -> 110-130, slow -> 80-100), and
       instrumental wherever your own voice is present. Change track at
       section boundaries, not inside them.
   (b) SILENCE: mark 1-3 sections where the bed stops entirely, on the
       most serious line.
   (c) PACE: set a target cut density per section, derived from arousal.
   (d) SFX: one riser into each peak, one hit ON the peak frame, tones
       only in negative-valence sections.
   (e) PICTURE: punch-ins and graphics on the peaks.
4. PLACE re-engagement beats at 25% and 65% of runtime: a pattern
   interrupt, a new visual mode, or a promised payoff.
5. VERIFY AFTER ASSEMBLY: measure cuts per 30s, short-term loudness, SFX
   events per 30s and music level per 30s; normalise each to 0-1 and
   average. Compare the measured curve with the planned one.
6. IF THE MEASURED CURVE IS FLAT in a region, fix it in this order:
   change the music for that section; then add or remove a silence; then
   change cut density; then add SFX. Adding effects to a flat section
   without changing its music is the least effective repair available.
7. ACCEPTANCE TEST: (a) the measured composite curve moves >= 0.20 per
   60 seconds everywhere; (b) every peak has a trough before it; (c)
   muting the dialogue in any section still communicates that section's
   emotion word; (d) no stretch longer than 60 seconds passes without a
   change of stimulus.
```

## Execution spec

**The plan lives in `STORYBOARD.md`** — this is the real, parsed plan layer in this stack, and it is where an emotional arc belongs. Its frontmatter already carries `format`, `duration`, `message`, `arc`, `audience`, `mode`; per-frame headings are `## Frame N — Title` with `- key: value` metadata bullets, and **unknown keys are preserved under `extra`**, which is exactly what an arousal/valence annotation needs. The parser never throws and records surprises as `warnings`.

```markdown
---
format: youtube-longform
duration: 600
message: "Sound design is what makes an edit feel expensive"
arc: "curious -> overwhelmed -> shown the system -> relieved -> equipped"
mode: teach
---

## Frame 3 — The five layers
- status: outline
- duration: 74
- arousal: 0.35
- valence: 0
- emotion: orderly
- music: instrumental, 100 bpm, warm keys
- levers: graphic build, no SFX, bed present
```
Read it back with `GET /api/projects/<id>/storyboard`, or view it as a contact sheet at `http://localhost:<port>/?view=storyboard#project/<project-name>`.

**Caution on the review loop:** the storyboard contract says to revise the named frames, **delete `.hyperframes/frame-comments.json`, and re-present** — but the vault mount **cannot delete files**. Supersede it with a new `pass` marker or a status field instead, and say so in the handover.

**HyperFrames — the levers.** Each of the four levers is an existing primitive: music level is a `volume` automation lane on the bed (clip-local `t`, holds its first value backwards); a silence is that lane going to 0 over 2–6 frames on a musical accent ([[sfx-music-hard-stop]]); cut density is the clip schedule; SFX are `<audio>` clips in an `sfx` group. Motion-side arousal comes from the speed bands — fast 0.15–0.3 s reads as energy, medium 0.3–0.5 s as professional, slow 0.5–0.8 s as gravity, very slow 0.8–2.0 s as cinematic — with the standing instruction that *the slowest scene should be 3× slower than the fastest*, which is the motion layer's version of this note's whole argument.

**ffmpeg — the measurement pass.** The four traces above (`scdet`, `ebur128`, per-frame `astats` peak, band-limited RMS) are the entire instrumentation. Bin to 30 s, normalise, average, plot. Programme loudness for delivery: two-pass `loudnorm` at `I=-14:TP=-1.5:LRA=11` for socials, `I=-16` for podcast.

**Epidemic Sound — the highest-leverage lever, searched by parameter not by scrolling.** `SearchRecordings { query.term: "<emotion word> <instrument>", filter: { bpm: { min: <lo>, max: <hi> }, vocals: false } }` — BPM matched to that section's delivery speed ([[pace-bpm-matched-music-selection]]), instrumental wherever your voice is present ([[sfx-vocal-vs-instrumental-bed]]). Use `SearchSimilarToRecording` on the outgoing track for an inaudible section-to-section handoff. For the peaks: `SearchSoundEffects { query.term: "riser build tension" }` and `{ query.term: "cinematic hit impact" }`.

**Remotion:** not present in this project; there is no equivalent plan layer to port.

## Pairs with
[[struct-stimulation-budget]] · [[sfx-music-primacy-doctrine]] · [[sfx-music-audition-against-picture]] · [[sfx-vibe-brief]] · [[pace-bpm-matched-music-selection]] · [[struct-music-arc-to-narrative-arc]] · [[sfx-music-hard-stop]] · [[sfx-riser-anticipation-build]] · [[sfx-cinematic-hit-emphasis]] · [[pace-cut-density-from-viewer-intent]] · [[struct-presenter-aside-pattern-interrupt]] · [[pace-visual-change-clock]]

## Failure modes
- **Confusing arousal with volume.** Raising levels and adding whooshes produces a loud flat video, not an arc. Fix: the curve needs troughs; build them first and the peaks appear for free.
- **A monotone bed across a video with a real arc.** The commonest reason a well-cut video feels flat. Fix: change the track at section boundaries — 2–4 tracks per 10 minutes — before touching the cut.
- **Fixing flatness with effects.** Adding SFX to a section whose music is wrong is the least effective repair in the list. Fix: music, then silence, then pace, then SFX.
- **No troughs.** Continuous high arousal overloads encoding — the research's own finding — and the audience remembers nothing while reporting the video as "intense". Fix: 12–45 s troughs before each peak.
- **Imposing the wrong arc on the format.** A thriller curve on a companionship video destroys the thing the audience came for. Fix: read the format's promise first ([[struct-stimulation-budget]]).
- **Planning the arc after the cut is locked.** Music selection constrains where beats and interrupts can land, so a late music decision either wastes the cut or forces a re-cut. Fix: decide music at plan time; audition against the locked cut to confirm, not to discover ([[sfx-music-audition-against-picture]]).
- **Treating the proxy curve as the emotion.** Cuts, loudness and SFX are carriers, not feelings; a section can score high and mean nothing. Fix: the emotion word per section is the check, and the mute test is how you audit it.
- **Known gap:** there is no published dataset isolating music choice from cut density on retention — the platform-side guidance is explicitly "run your own A/B". The benchmark numbers above are industry aggregates, and the causal claim in the source quote is craft consensus, not measured effect. Log measured retention curves per video and prefer them over these defaults.
