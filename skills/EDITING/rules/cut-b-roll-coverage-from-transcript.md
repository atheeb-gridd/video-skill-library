---
id: cut-b-roll-coverage-from-transcript
title: B-roll is the visual of your words — map coverage off the transcript, not off vibes
skill: editing
type: cut
family: b-roll
tags: [skill/editing, type/cut, family/b-roll, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:36"
    quote: "It's more interesting than A-roll, so use it as often as you possibly can."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:40"
    quote: "It creates a visual representation of your words, so the viewer can actually see what you're talking about instead of just staring at your face."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:03:53"
    quote: "A few variations of B-roll are stock footage, which is basically the easy version, and motion graphics."
research_refs:
  - https://dl.acm.org/doi/10.1145/3290605.3300311
  - https://arxiv.org/abs/1902.11216
  - https://prepublish.ai/blog/visual-pattern-interrupts-editing
  - https://support.shoutout.social/en/blog/how-long-should-b-roll-clips-be
  - https://arxiv.org/html/2507.17080v1
  - https://www.shotai.io/en/guides/semantic-video-search
  - https://link.springer.com/article/10.3758/s13414-013-0605-z
  - https://air.io/en/youtube-hacks/advanced-retention-editing-cutting-patterns-that-keep-viewers-past-minute-8
difficulty: medium
detectable_from: transcript+video
---

# B-roll is the visual of your words — map coverage off the transcript, not off vibes

## What it is
B-roll is footage shot separately from the audio whose only job is to **show the noun the narration just said**. The creator's ranking is strict and worth taking literally: B-roll is *more interesting* than A-roll, so A-roll becomes the exception — short bursts on the lines that need a face — and B-roll becomes the default picture. The taxonomy has four rungs of the same ladder: **A-roll** (see and hear the subject at once), **B-roll** (shot footage of the subject matter), **stock footage** ("basically the easy version" of B-roll), and **motion graphics** (for the important-but-boring beat that needs to be crystal clear and fast). The professional form of the technique is not "grab some cutaways" — it is a **coverage map**: every sentence of the transcript is assigned a visual, and gaps in that map are the shot list.

## When to use it
Default-on for any narration-driven video: explainer, tutorial, video essay, vlog voiceover. The trigger for an individual insert is **a concrete referent in the transcript** — a named object, place, person, tool, number, action, or a stated comparison. A sentence with a concrete referent and no visual is a coverage hole. Stay on A-roll deliberately, not by default, in three cases: the line carries the presenter's authority or emotion, the line is a direct address to the viewer, and the punchline of a joke where the face *is* the payoff (see [[cut-punch-in-emphasis]] for what to do with those lines instead). Prefer motion graphics over footage when the referent is abstract — a process, a ratio, a hierarchy — because footage of an abstraction is decoration and reads as filler.

## How to recognise it in a reference video
- **Build the cut list first, then classify each shot.** Get boundaries mechanically, then sample one frame per shot and label it `A-roll | B-roll | stock | motion-graphic | screen-recording`:
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=10,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ffmpeg -i ref.mp4 -vf "select='gt(scene,0.1)',showinfo" -vsync vfr shot_%04d.png
  ```
- **The headline number is `broll_coverage` = seconds of non-A-roll picture ÷ runtime.** Creator-explainer references that feel "fast and clear" typically land **0.45–0.70**; a face-dominated reference lands under 0.25. Log it — it is the single most transferable parameter in this note.
- **A-roll burst length.** In a B-roll-forward reference, continuous A-roll runs come in **1.5–6 s** bursts. Any A-roll run over **12 s** without an insert, an overlay or a punch-in is a coverage hole, and you will usually see the retention curve confirm it.
- **Insert length distribution.** Measure every B-roll shot. Expect a tight cluster: **45–150 f (1.5–5.0 s)** for shot footage, with a floor around **15 f (0.5 s)** for a re-shown object and **24–30 f (0.8–1.0 s)** for a new location. Published guidance for creator B-roll is 2–5 s per clip; retention-editing guidance describes the "B-roll breath" as 3–5 s inserted every 60–90 s of explanation-heavy talking.
- **Word-to-picture lag.** Align the transcript to the cut list and measure, for each insert, `insert_start − first frame of the word it illustrates`. Well-cut references sit **−6 to +12 f** (the picture may slightly precede the word, and rarely trails it by more than 12 f). A lag over ~20 f reads as the editor catching up.
- **Referent test, per insert.** For each B-roll shot write the noun it shows and find that noun in the transcript within ±2 s. Inserts with no matching referent are **filler B-roll** — count them; the ratio of referent-matched to filler inserts separates a designed edit from a padded one.
- **Sound continuity across the insert.** In almost every case the narration runs unbroken under the insert and the insert's own audio is either absent or ducked to a bed. If narration *stops* for the insert, that is a different technique ([[pace-silent-demonstration-window]]).
- **Escalation to graphics.** Note where the reference switches from footage to a motion graphic. It is nearly always at a beat the presenter flags as important-but-dry (a number, a mechanism, a comparison). Log those timestamps — they are the graphics brief.
- **Transcript-only detection.** You can predict where the reference *should* have B-roll without watching it: run entity extraction over the transcript and mark every sentence containing a concrete noun. Comparing that prediction to the actual cut list is the fastest coverage audit there is.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `broll_coverage` | 0.55 | 0.40–0.70 | Non-A-roll picture ÷ runtime. Below 0.30 the video is a talking head with cutaways; above 0.80 the presenter disappears and the video loses its author. |
| `a_roll_burst` | 4 s (120 f) | 1.5–6 s | Continuous A-roll before something else takes the screen. |
| `a_roll_max_run` | 12 s (360 f) | 8–15 s | Hard ceiling without an insert, overlay or punch-in. |
| `insert_len` | 75 f (2.5 s) | 45–150 f (1.5–5.0 s) | Shot/stock footage. |
| `insert_len_min` | 15 f (0.5 s) | 12–24 f | Only for an object the viewer has already seen. Conceptual detection of a picture is possible at 13 ms, but 12 f is the practical floor for a *new* image to be read inside a moving edit. |
| `insert_len_new_location` | 30 f (1.0 s) | 24–45 f | A previously unseen place or wide shot needs the longer floor. |
| `insert_len_with_text` | 60 f (2.0 s) | 45–90 f | Anything with words on screen: read-time governs, not picture-time. |
| `breath_interval` | 75 s | 60–90 s | Maximum gap between B-roll breaths in explanation-heavy stretches. |
| `word_to_picture_lag` | +4 f | −6 to +12 f | Negative = picture slightly ahead of the word, which is the safe direction. |
| `referent_match_rate` | 0.85 | 0.70–1.00 | Inserts whose subject appears in the transcript within ±2 s. |
| `graphic_share` | 0.15 | 0.05–0.30 | Fraction of non-A-roll time that is motion graphics rather than footage. |
| `insert_audio` | narration continues | — | The insert is picture-only by default; its own sound arrives as a bed or an accent, never as a competing voice. |

## Reproduction prompt

```
Build the B-roll coverage map for this video, then cut it.

INPUTS: the locked A-roll edit, its word-level transcript (text, start, end
in seconds), and the footage library with per-clip tags.

1. SEGMENT THE SCRIPT. Split the transcript into sentences. For each
   sentence record: start, end, and every concrete referent in it (object,
   place, person, tool, number, on-screen action, comparison). A sentence
   with zero concrete referents is an A-roll sentence; mark it.
2. CLASSIFY EACH SENTENCE into exactly one of:
   A-ROLL (authority, emotion, direct address, joke payoff)
   B-ROLL (a concrete referent that exists as footage)
   GRAPHIC (referent is abstract: a process, ratio, hierarchy, or a number
            the viewer must hold on to)
3. RETRIEVE. For each B-ROLL sentence, query the footage library with the
   referent noun plus one modifier from the sentence. Take the top 3
   candidates and pick on framing continuity with the neighbouring shots,
   not on prettiness. If nothing scores, promote the sentence to GRAPHIC or
   demote it to A-ROLL - do NOT insert unrelated pretty footage.
4. TIME EACH INSERT. Set insert_start = (start of the illustrated word)
   - 4 frames (0.13s). Set duration from the type: re-shown object 15f
   (0.5s); shot/stock footage 75f (2.5s); unseen location 30f (1.0s)
   minimum; anything with on-screen text 60f (2.0s) minimum. Trim inside
   the source rather than trimming the narration.
5. ENFORCE THE CLOCKS. (a) No continuous A-roll run over 360f (12s):
   if one exists, add an insert, an overlay, or a punch-in. (b) No
   explanation-heavy stretch over 75s without a B-roll breath of 90-150f.
   (c) Total non-A-roll picture must land between 40% and 70% of runtime.
6. KEEP THE NARRATION UNBROKEN. Inserts are picture-only. The A-roll audio
   track runs continuously underneath; the insert's own sound, if any,
   enters as a bed or a single accent, never as a second voice.
7. ACCEPTANCE TEST: (a) every insert's subject appears in the transcript
   within +/-2s of the insert, for at least 85% of inserts; (b) no insert
   is shorter than 12 frames; (c) broll_coverage is 0.40-0.70; (d) longest
   A-roll run <= 360f; (e) with the picture muted, the narration is
   continuous and unedited; (f) watched at 2x speed, no insert reads as
   unrelated to the words underneath it.
```

## Execution spec

**HyperFrames (primary).** The A-roll is a base clip on track `0` with its own separate `<audio>` at the root; each B-roll insert is a **muted picture clip layered above it**, which is why the narration is never touched. Layering is CSS `z-index`, *not* `data-track-index` (that attribute is display-only and constrains nothing).

```html
<!-- A-roll picture + its audio, cut independently. Times are SECONDS; frames are comments. -->
<video id="aroll"  src="footage/aroll.mp4" muted playsinline class="clip"
       data-start="0" data-duration="212.0" data-track-index="0" style="z-index:0"></video>
<audio id="aroll-a" src="footage/aroll.mp4" data-audio-group="voiceover"
       data-start="0" data-duration="212.0" data-track-index="10"></audio>

<!-- insert: the word "keyboard" starts at 41.60s -> picture 4f (0.13s) early, 2.5s long -->
<video id="br-keyboard" src="footage/keyboard-macro.mp4" muted playsinline class="clip"
       data-start="41.47" data-duration="2.50" data-media-start="6.20"
       data-track-index="1" style="z-index:2"></video>
```

Contract details that bite here:
- **Trim in the composition, not on disk** — `data-media-start` + `data-duration` play a sub-window; the contract only sanctions cutting a physical file when the asset leaves the pipeline.
- `data-duration` on a `<video>` may be omitted (it defaults to media duration) — **always author it for an insert**, or the clip has no end and stays on screen for the rest of the composition.
- `video_nested_in_timed_element` is an **error**: time the wrapper *or* the video, never both. Insert clips are therefore direct children of the root, not children of a timed scene div.
- Root-level clips are force-positioned `absolute; top:0; left:0` at 100% — a full-bleed insert needs nothing extra; an insert that should sit inside a frame needs its own inner wrapper.
- Relative timing (`data-start="aroll + 41.47"`) works but has four silent-zero failure modes, the nastiest being that **spaces around the operator are mandatory**. Author literal seconds for inserts.

Where the insert should not cut the A-roll away at all, spend an overlay instead — see [[pace-overlay-instead-of-cut]]. Where the insert is a graphic rather than footage, build it as a sub-composition (`data-composition-src`) once the project passes ~3 scene cuts, and remember a sub-comp timeline **cannot** animate host-root elements.

**ffmpeg / media-use.** Transcript first, because the map is built on word timings:
```bash
npx hyperframes transcribe aroll.mp4            # word-level {text,start,end}
ffmpeg -i ref.mp4 -vf "scdet=t=10,metadata=print" -f null - 2>&1 | grep lavfi.scd   # cut list of a reference
ffprobe -v error -show_entries format=duration -of csv=p=0 footage/keyboard-macro.mp4
```
Trim a physical insert only for export; for tightening the *narration* (which changes every downstream timestamp) use the transcript compiler and re-transcribe afterwards:
```bash
node <SKILL_DIR>/scripts/transcript-cut.mjs --input aroll.mp4 --transcript aroll.transcribe.json \
  --remove-fillers "um,uh" --cut-silence 0.8 --out aroll.cut.mp4
```
Note `--copy` snaps to keyframes and can swallow a short cut entirely; the script warns on >1 s drift. Drop `--copy` for frame-accurate work.

**Epidemic Sound.** Epidemic supplies the *sound* of an insert, never the picture: `SearchSoundEffects { query.term: "mechanical keyboard typing close" }` for the diegetic layer, plus a transition accent if the insert enters on a movement ([[sfx-whoosh-transition-movement-reveal]]). Place it in an `sfx` group — never in the `voiceover` carve group, which must contain voices only.

**Known capability gap:** this stack has **no stock-footage or video-search provider**. `media-use resolve` covers `image`, `icon`, `logo`, `grade`, `lut` and audio types; its catalog paths are network-dependent and the HeyGen catalog is not assumed reachable. So the "retrieve" step of the map must run against a **local, pre-tagged footage library** that the project supplies. Production pipelines build that index by captioning each clip with a VLM and searching text-to-clip embeddings (the VL-CLIP line of work; commercial NLE plugins now ship the same thing) — and the CHI paper *B-Script* validated the transcript-first interface directly, with 110 participants finding transcript-based B-roll insertion faster and producing more engaging videos when recommendations were offered. Build the index once, per project; do not expect the tool layer to hand you one.

**Remotion:** conceptually each insert is a `<Sequence from={} durationInFrames={}>` layered over the A-roll `<Video>`; no Remotion runtime exists in this project.

## Pairs with
[[pace-visual-variety-density-audit]] · [[pace-visual-change-clock]] · [[pace-overlay-instead-of-cut]] · [[cut-punch-in-emphasis]] · [[pace-silent-demonstration-window]] · [[cut-j-audio-leads-picture]] · [[sfx-ambience-bridge-across-cut]] · [[motion-image-focal-point-direction]] · [[struct-demo-before-label]] · [[cut-screen-recording-proof-insert]]

## Failure modes
- **Filler B-roll.** Drone shots and coffee pours under a line about pricing. The insert must name the noun the narration named. Fix: enforce `referent_match_rate ≥ 0.85`; a sentence with no matching footage becomes a graphic or stays on A-roll.
- **Inserts too short to read.** A 6-frame flash of an unfamiliar object costs a cut and delivers nothing. Fix: 12 f floor for a re-shown object, 24–30 f for anything new, 45–60 f if there is text on it.
- **Inserts too long.** Past ~5 s a B-roll shot stops illustrating and starts being the video; the viewer wonders where the presenter went. Fix: cap at 150 f, or give the shot its own beat with sound and treat it as a demonstration window.
- **Cutting the narration to fit the picture.** The audio is the spine. Fix: trim inside the insert's source; never shorten a sentence to accommodate a shot.
- **Insert audio fighting the voice.** Full-level location sound under narration turns both to mush. Fix: insert sound as a bed at bed level, carved against the `voiceover` group; a diegetic accent may peak briefly at the insert's first frames.
- **All B-roll, no face.** Coverage above ~0.80 removes the presenter and with them the reason anyone subscribed. Fix: hold A-roll on authority, emotion and direct address.
- **Graphics used where footage belongs, and vice versa.** Footage of an abstraction is decoration; a graphic of a physical object is a cartoon. Fix: classify by referent type at step 2 and do not renegotiate later.
- **Known gap:** published B-roll duration guidance is creator-blog grade (2–5 s clips; 3–5 s breaths every 60–90 s) and there is no controlled study on insert length versus comprehension. The 12 f / 24 f / 45 f floors here are house calibration anchored to RSVP evidence that a picture's meaning can be extracted from very short exposures, plus the practical need for a *narrative* read rather than a detection. Prefer the measured distribution from a matched reference video whenever one exists.
