---
id: pace-subtractive-first-pass
title: The subtractive first pass — four removals, coarse to fine, before any visual work
skill: editing
type: pacing
family: subtractive-pass
tags: [skill/editing, type/pacing, family/subtractive-pass, engine/ffmpeg, engine/hyperframes, source/editing-kt, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:02:34"
    quote: "This is the timeline of a typically edited YouTube video. A few cuts took out the unnecessary parts. There was a tangent here that wasn't really relevant to the point of the video. These cuts removed pauses and bad takes. But as it stands, this video is doomed to never reach its potential."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:02:18"
    quote: "This video isn't a pile of tutorials. It's a handbook for addictive editing."
research_refs:
  - https://chatcut.io/blog/remove-silence-filler-words-from-video-2026
  - https://cutback.video/blog/assembly-cut-vs.-rough-cut-what-s-the-difference
  - https://newdocediting.com/power-of-the-assembly-cut/
  - https://reduct.video/blog/paper-edits-for-documentary-filmmakers/
  - https://www.redsharknews.com/how-to-delete-pauses-and-filler-words-with-text-based-editing
  - https://prepublish.ai/guides/youtube-retention-guide
difficulty: low
detectable_from: transcript+video
---

# The subtractive first pass — four removals, coarse to fine, before any visual work

## What it is
The first pass over a long-form talking-head assembly removes exactly four things, in this order: **unnecessary sections** (whole beats that do not advance the thesis), **off-thesis tangents** (relevant-sounding digressions that answer a question nobody asked), **pauses** (inter-word silence beyond the format's tolerance), and **bad takes** (fluffed, restarted or lower-energy readings of a line that exists better elsewhere). It is mechanical, driven off the transcript plus the waveform, and it produces a *tight but flat* timeline. The source's diagnosis is the important half of this note: a timeline that has had **only** this pass is "doomed to never reach its potential" — the pass is table stakes, not the edit.

## When to use it
Always, and always first — before B-roll, before motion, before sound, before any cut you would call creative. Run it the moment a word-level transcript exists. The one thing that must precede it is the thesis sentence: you cannot cull tangents without a written statement of what the video is arguing, so if the design document has no one-line thesis, write it before cutting anything. Re-run the pause sub-pass (and only that sub-pass) after any structural re-order, because a re-order creates new junctions with new dead air at their seams.

## How to recognise it in a reference video
You are detecting *whether the pass was done*, and *how hard*. Both are measurable.

- **Inter-word gap distribution.** Transcribe with word timings, then compute every gap between consecutive words. A video that has had the pause pass shows a hard right edge: almost no gaps above the policy threshold, typically **0.30–0.70 s**, with a spike of gaps sitting just under it. A video that has not shows a long tail out to 2 s+.
  ```bash
  ffmpeg -i ref.mp4 -af "silencedetect=n=-32dB:d=0.35" -f null - 2>&1 | grep silence_
  ```
- **Residual dead air ratio.** Sum detected silence and divide by runtime. **Under 6%** = the pass was run; **6–12%** = partial; **over 12%** = untouched. Raw talking-head footage typically carries **13–23% dead space** (a 30-minute raw recording holds roughly 4–7 minutes of silence, filler and false starts).
- **Filler-word density.** Count `um / uh / like / you know / basically` per 100 words in the transcript. **Under 0.5 per 100** = a filler pass was run; 2+ = it was not.
- **Jump-cut count on a static frame.** Detect cuts and check how many are *same-framing* cuts (the shot does not change, only the content jumps). Those are pause/bad-take removals, and their count is the pass's fingerprint:
  ```bash
  ffmpeg -i ref.mp4 -vf "scdet=t=6,metadata=print" -f null - 2>&1 | grep lavfi.scd
  ```
  A same-framing cut scores low on scene detection (typically **scdet 4–12**) while a genuine shot change scores **25+**.
- **Tangent absence, from the transcript.** Segment the transcript into topical blocks and test each against the video's stated promise. In a culled edit **every block maps to a promised item**; a surviving block that maps to nothing is a tangent the editor kept.
- **Cull depth.** If both a raw and a published version are available, the finished runtime of a well-culled edit is **80–90% of the raw speech duration**, not 60–70%. Below ~75% the delivery reads clipped and breathless.
- **What was deliberately kept.** Look for surviving pauses **immediately before a punchline, a number, or a reveal**. Their presence is a signature of a hand-reviewed pass; their absence signals a blanket automated cull.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `pass_order` | `sections → tangents → bad takes → pauses` | fixed | Coarse to fine. Cutting pauses first wastes work on material about to be deleted, and destroys the audible seams you need to judge takes. |
| `silence_threshold_db` | −32 dB | −40 to −26 dB | Below −40 dB you catch room tone; above −26 dB you clip breath and soft word endings. |
| `min_gap_removed` | 0.50 s (15 f) | explainer 0.30–0.50 s · solo talking-head 0.50–0.70 s · podcast 0.80–1.20 s · social cutdown 0.30 s | The single most format-defining number in this note. How far to push it — and what it costs in authenticity — is [[pace-partial-pause-removal]]'s subject; this note only says where in the order it happens. |
| `gap_floor_kept` | 0.12 s (4 f) | 0.08–0.20 s | Never close a gap to zero — leave a breath or the joins sound spliced. |
| `pre_word_pad` | 0.06 s (2 f) | 0.04–0.10 s | Lead-in kept before the next word so the attack is not shaved. |
| `post_word_pad` | 0.08 s (2–3 f) | 0.04–0.12 s | Tail kept after the previous word so the plosive/sibilant finishes. |
| `filler_list` | `um,uh,like,you know,basically,i mean,sort of` | — | Remove only where the word is not carrying meaning; `like` is often load-bearing. |
| `rhetorical_pause_whitelist` | before punchline · before a number · after a question · at a topic seam | — | These pauses are content. Whitelist them explicitly by timecode before the automated pass runs. |
| `target_retained_ratio` | 0.85 | 0.78–0.92 | Finished speech duration ÷ raw speech duration. |
| `max_dead_air_ratio` | 0.06 | 0.03–0.08 | Acceptance test for the finished pass. |
| `bad_take_selection` | best energy, then best diction | — | When two takes tie, keep the earlier one; energy decays across takes. |
| `tangent_test` | one-clause mapping to a promised item | — | If the block cannot be mapped in one clause, it is a tangent. |

## Reproduction prompt

```
Run the subtractive first pass on {{SOURCE_VIDEO}} using {{TRANSCRIPT_JSON}}
(word-level, {text,start,end}). Do the four removals in this order and do
not skip ahead.

0. Write the thesis in one sentence at the top of the design document, plus
   the numbered promise list the video makes. Nothing below is decidable
   without them.

1. SECTIONS. Segment the transcript into topical blocks at speaker-intent
   boundaries. For each block write one clause mapping it to a promised
   item. Any block with no mapping is cut whole. Log every cut block as
   start-end seconds with the reason.

2. TANGENTS. Inside surviving blocks, find spans that answer a question the
   video did not raise (self-qualification, backstory, caveats, "by the way").
   Cut them at sentence boundaries only. If a tangent carries one useful
   clause, keep the clause and cut its frame.

3. BAD TAKES. Find repeated deliveries of the same line (near-duplicate
   n-grams in the transcript, or restart markers: "sorry", "let me", "again",
   a false start followed by the same opening words). Keep exactly one: best
   energy first, best diction second, earliest on a tie. Cut the rest.

4. PAUSES. Only now cut silence. Remove every inter-word gap longer than
   {{MIN_GAP}} (default 0.50s) down to a floor of 0.12s, keeping 0.06s of
   lead-in and 0.08s of tail around the surviving words. Do NOT cut a gap
   listed in the rhetorical-pause whitelist. Remove filler words from
   {{FILLER_LIST}} only where deleting them leaves a grammatical sentence.

5. Emit the removal list as second ranges and execute it in ONE operation
   (see Execution spec) so cut points stay frame-accurate.

6. ACCEPTANCE TEST, all five must pass:
   - retained speech duration is 78-92% of raw speech duration
   - detected dead air is under 6% of the new runtime
   - filler density under 0.5 per 100 words
   - no gap closed below 0.12s (listen to five random joins for clipped
     word attacks)
   - every whitelisted rhetorical pause is still present
7. Then STOP and hand the timeline on. This pass produces a tight, flat
   video. Do not judge pacing yet - a timeline that has only had this pass
   is capped by definition and the visual-variety pass is what raises the
   ceiling.
```

## Execution spec

**ffmpeg / media-use (the whole pass).** This is a raw-media operation and `transcript-cut.mjs` is the compiler for it — one invocation carries all four removals, because it compiles a kept-segment list and concatenates once:

```bash
# inspect first — never encode blind
node <SKILL_DIR>/scripts/transcript-cut.mjs \
  --input aroll.mp4 --transcript aroll.transcribe.json \
  --remove "142.30-197.85,412.10-448.60" \
  --remove-fillers "um,uh,you know,basically" \
  --cut-silence 0.5 \
  --plan

# then encode
node <SKILL_DIR>/scripts/transcript-cut.mjs --input aroll.mp4 \
  --transcript aroll.transcribe.json --remove "142.30-197.85,412.10-448.60" \
  --remove-fillers "um,uh,you know,basically" --cut-silence 0.5 \
  --out aroll.cut.mp4 --json > cut-report.json
```

`--remove` takes second ranges (sections, tangents, bad takes); `--remove-words` takes word-index ranges; `--cut-silence` removes inter-word gaps longer than N seconds. **Do not pass `--copy`** — stream copy snaps to keyframes and the script's own comment warns the snap "can silently swallow the whole cut"; it reports `copy_drift` when it does. Keep scratch output **outside** the vault mount, which cannot delete files.

Measurement helpers:

```bash
# dead-air ratio
ffmpeg -i aroll.cut.mp4 -af "silencedetect=n=-32dB:d=0.35" -f null - 2>&1 \
  | awk -F'silence_duration: ' '/silence_duration/{s+=$2} END {print "silence_s="s}'
# same-framing jump-cut census
ffmpeg -i aroll.cut.mp4 -vf "scdet=t=6,metadata=print" -f null - 2>&1 | grep -c lavfi.scd
```

**HyperFrames (if you cut in the composition instead of on disk).** Nothing forces a new file: each surviving segment is a clip playing a sub-window of the original via `data-media-start` + `data-duration`, authored in **seconds** (there is no frame attribute). Author picture and sound with the same numbers — there is no auto-sync:

```html
<video id="seg-01" src="aroll.mp4" muted playsinline class="clip"
       data-start="0"    data-duration="7.40" data-media-start="12.06" data-track-index="0"></video>
<audio id="seg-01-a" src="aroll.mp4"
       data-start="0"    data-duration="7.40" data-media-start="12.06" data-track-index="10"
       data-audio-group="voiceover"></audio>
<video id="seg-02" src="aroll.mp4" muted playsinline class="clip"
       data-start="7.40" data-duration="5.10" data-media-start="21.98" data-track-index="0"></video>
<!-- 7.40s = 222f @30fps; the window is half-open so seg-02 starts exactly where seg-01 ends -->
```
Back-to-back authoring (`b.start === a.start + a.duration`) yields a true hard cut with no overlapping frame. Prefer the on-disk `transcript-cut.mjs` route when the segment count passes roughly 40 — a composition with hundreds of micro-clips is unreviewable, and the concatenated file is the better hand-off to the visual pass.

**Practical note on the pass boundary.** The four removals produce jump cuts on a static frame. Do not fix them here. They are fixed by the next pass with B-roll, overlays or a punch-in — see [[pace-overlay-instead-of-cut]] and [[cut-punch-in-emphasis]].

**Epidemic Sound:** nothing to fetch in this pass. Music selection comes after the cut is locked ([[sfx-music-audition-against-picture]]).

**Remotion:** the concept ports (a list of kept ranges rendered as sequences), but there is no Remotion runtime in this project.

## Pairs with
[[pace-partial-pause-removal]] · [[pace-cut-density-from-viewer-intent]] · [[pace-overlay-instead-of-cut]] · [[cut-punch-in-emphasis]] · [[struct-stimulation-budget]] · [[sfx-music-audition-against-picture]] · [[struct-outcome-first-cold-open]] · [[sfx-sound-pass-order]]

## Failure modes
- **Cutting pauses before cutting sections.** You spend the pass polishing joins inside material you then delete, and you lose the audible seams that tell you which take was better. Fix: obey `pass_order`, always.
- **Blanket automated silence removal.** Every rhetorical pause dies with the dead air and the delivery turns breathless — the "over-edited" signature is a retained ratio below ~0.75. Fix: whitelist rhetorical pauses by timecode *before* running the cull, and set `gap_floor_kept` to 0.12 s rather than zero.
- **Shaving word attacks.** A threshold above −26 dB or zero padding eats the start of plosives and the end of sibilants; the result sounds like a bad phone line. Fix: −32 dB, 2 f lead-in, 2–3 f tail; listen to five random joins.
- **Treating tangent removal as trimming.** Cutting a tangent mid-clause leaves a non-sentence. Fix: cut only at sentence boundaries, and keep the useful clause if there is one.
- **Declaring victory after the pass.** This is the exact failure the source names: a tight timeline with no visual variety is capped, not finished. Fix: the pass output is an input, and the design document must show what the visual pass adds on top.
- **Using `--copy` for speed.** Keyframe snapping silently swallows cuts on sparse-keyframe footage. Fix: re-encode; check `copy_drift` in `--json` if you must.
- **Known gap:** the format bands for `min_gap_removed` come from a text-based-editing practitioner guide, not from a controlled study, and the 78–92% retained ratio is that same source's craft rule. Treat them as priors and replace them with the channel's own measured numbers once a reference edit exists.
