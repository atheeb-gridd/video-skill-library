---
id: struct-intercut-beat-ledger
title: The beat ledger — what each cross-cut block must deliver before you cut away
skill: editing
type: structure
family: parallel-action
tags: [skill/editing, type/structure, family/parallel-action, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/editing-kt-2, source/research, difficulty/high]
source:
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:54"
    quote: "What cross cutting allows you to do is to easily tell your two stories that are happening at the same time."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:37"
    quote: "Cross cutting is when the editor is cutting back and forth between multiple scenes, usually at the same time."
  - video: "assets/videos/editing kt 2.mp4"
    timestamp: "00:04:44"
    quote: "This is a common technique used in thriller style movies."
research_refs:
  - https://www.studiobinder.com/blog/cross-cutting-parallel-editing-definition/
  - https://www.studiobinder.com/blog/what-is-parallel-editing-in-film/
  - https://www.filmeditingpro.com/film-editing-techniques-cross-cutting-101/
  - https://www.studiobinder.com/blog/walter-murch-rule-of-six/
  - https://www.filmmakersacademy.com/glossary/average-shot-length-asl/
difficulty: high
detectable_from: transcript+video
---

# The beat ledger — what each cross-cut block must deliver before you cut away

## What it is
Cross cutting is usually taught as a rhythm — alternate between strands, cut faster as it builds. That half is measured in [[struct-cross-cutting-parallel-action]]. This note is the other half, and it is the half that decides whether the sequence is comprehensible: **the information contract of each block.** Before any of it is cut, you write a ledger — one row per block — naming, for that strand, *the single beat this block delivers* and *the question it leaves open when you cut away from it.*

Two rules make the ledger work, and both come out of the structural claim in the source: cross cutting exists so two things that are happening at the same time can both advance, instead of telling one and rewinding the clock. If a block advances nothing, the clock did not move and the alternation is decoration. And if a block resolves everything it opened, there is no reason to come back to it, so the return feels like an obligation instead of a payoff.

- **One beat per block.** Exactly one thing changes in that strand — a discovery, a decision, a step completed, a threat closing. Not two; two is a block that should have been two blocks.
- **Leave on the open question.** The out-point of every block except the last sits *before* that beat's consequence is revealed. The viewer carries a question across the other strand's block, and that carried question is the entire tension mechanism.

The screenwriting formulation of the same discipline is "enter late, leave early": start each block after the setup and exit before the resolution. At block scale that means the first frame of a return-to-strand-A should not re-establish A — the audience already knows where A is; it should show A's *next* state.

## When to use it
Whenever two threads must both advance inside the same window of story time and one of them cannot simply be told afterwards. In creator and explainer work the real triggers are:

- A **process running while you talk** — a render, a bake, a build, a download, a timer — where the process's stages and the commentary must interleave.
- A **wrong-way / right-way pair** demonstrated in alternation, where the comparison itself is the argument.
- A **two-party exchange in two places** — a call, a message thread, a hand-off ([[sfx-phone-call-cross-cut-treatment]]).
- A **countdown or deadline** against work being done, where the tension is whether they meet.
- Two **competing options** being tried in parallel so the viewer can judge them against each other.

Do **not** build a ledger for a montage: a montage's fragments are variations on one idea and have no independent continuity, so they have no beats to owe each other. Do not cross-cut two threads when one of them can be summarised in a sentence — the cheaper edit is the sentence. And do not cross-cut when the two threads are not simultaneous; alternating non-simultaneous material is parallel editing in the loose sense and needs its own signposting, otherwise the audience will assume simultaneity and be wrong.

## How to recognise it in a reference video
- **Rebuild the ledger from the finished cut.** Label every shot with its strand, group consecutive same-strand shots into blocks, and for each block write in one sentence *what changed in that strand*. That table is the ledger, recovered. It is the single most useful artefact to extract from a reference cross cut.
- **Score the information density.** Count blocks that deliver a stateable change ÷ total blocks. A well-built sequence scores **≥ 0.85**. Blocks that deliver nothing new are stalls; a sequence full of stalls is alternating for texture and will feel long even when it is short.
- **Test the out-points for open questions.** For each block, ask: *at the frame we cut away, is the consequence of this beat already known?* In a strong sequence the answer is "no" for every block but the last. Count the ratio — `open_exit_ratio` — and expect **≥ 0.8**.
- **Test the in-points for re-establishment.** Does the return to a strand start with a wide shot or a shot that repeats information already given? Re-establishment on return means the sequence does not trust its own orientation cues and is spending runtime on maintenance. Expect **≤ 20%** of returns to re-establish.
- **Count strands and check they stay legible.** **2 strands** is the creator default; **3** appears in long-form with a full set-up; 4+ is a feature-film climax device. The legibility test is mechanical: pause at any point and ask whether you can state what each strand is currently doing. If not, either there are too many strands or the orientation cues are too weak.
- **Look for the causal link.** The strongest cross cuts make each cut *imply* a relationship — B's block is a consequence of, a threat to, or a comment on A's. Log for each boundary whether the juxtaposition asserts something the words never say. A sequence where the order of blocks could be shuffled without loss is a list, not a cross cut.
- **Find the convergence.** Log whether and when the strands meet, and check that the last block before convergence is the one with the shortest open question. Most cross cuts resolve; one that does not needs a reason.
- **Transcript signals.** "Meanwhile", "at the same time", "while that's running", "over here", "back to", "and remember, all of this is happening while…". Also look for a narration that keeps one continuous thread while the picture alternates — that continuous voice is often the spine holding a creator cross cut together.
- **Rhythm cross-check.** Pull the run lengths and the acceleration ratio too; a ledger-correct sequence with flat rhythm is informational, and that is a legitimate but different thing. Numbers in [[struct-cross-cutting-parallel-action]].

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `strands` | 2 | 2–3 | 3 only with a full set-up and 2+ orientation cues each. 4+ is out of scope for creator work. |
| `beats_per_block` | 1 | 1 | Not a range. Two changes in one block means split the block. |
| `stall_blocks` | 0 | 0–1 | Blocks that deliver no stateable change. One is survivable at the very start; more is a rewrite. |
| `info_density` | 0.90 | 0.85–1.0 | Blocks with a stateable change ÷ total blocks. |
| `open_exit_ratio` | 0.85 | 0.8–1.0 | Blocks cut before their consequence is revealed ÷ total blocks (last block exempt). |
| `reestablish_ratio` | 0.10 | 0.0–0.20 | Returns to a strand that re-show known information. |
| `blocks_total` | 8 | 6–20 | Strand switches across the sequence. Below 6 it reads as two scenes. |
| `beats_per_strand` | 4 | 3–10 | Ledger rows per strand. Write them before cutting. |
| `question_lifetime` | 1 block | 1–2 blocks | How long a planted question stays open. Past 2 blocks the viewer has stopped holding it. |
| `orientation_cues` | 2 | 2–4 | Independent separators per strand: framing size, grade, location + ambience, a graphic label, a distinct sound signature. |
| `spine_element` | required | — | One continuous audio element across the whole sequence — narration, bed, clock, machine tone. Without it the sequence fragments audibly. |
| `convergence` | yes | yes \| no | Whether the strands meet. If `no`, name what replaces the payoff. |
| `shuffle_test` | must fail | — | If the block order can be shuffled with no loss of meaning, it is a list, not a cross cut. |

## Reproduction prompt

```
Plan and cut a cross-cut sequence for the two strands {{A}} and {{B}}
covering the same window of story time.

1. WRITE THE LEDGER FIRST, before touching the timeline. One row per block:
   strand | beat_no | the ONE thing that changes | the question left open at
   the out-point | rough duration. Write 3-10 rows per strand.
   Reject any row that names two changes: split it into two rows.
   Reject any row whose "question left open" column is empty: that block
   either needs a later out-point or should not exist.
2. ORDER THE BLOCKS by alternation, and check each junction: the question
   planted by the block you are leaving must still be open when you return.
   A question that stays open across more than 2 blocks has been forgotten -
   move the return earlier.
3. ESTABLISH BEFORE ALTERNATING. Give each strand one contiguous run of at
   least 90 frames (3.0s) on its own, wider than the rest of the sequence,
   before the first switch.
4. SET IN-POINTS LATE. On every return to a strand, the first frame shows
   that strand's NEXT state - never a re-establishing wide, never a repeat of
   what we already know. Enter late, leave early.
5. SET OUT-POINTS EARLY. Cut away BEFORE the beat's consequence is shown.
   The frame you cut on should make the viewer want the answer.
6. SEPARATE THE STRANDS with at least 2 independent orientation cues: shot
   size, grade/colour, location ambience, a graphic label, or a distinct
   sound signature. Keep them consistent for the whole sequence.
7. RUN ONE CONTINUOUS AUDIO SPINE across the whole sequence - narration, a
   music bed, a clock, a machine - and crossfade the location ambiences
   under it rather than cutting them.
8. CONVERGE. The final block resolves the shortest-lived open question, and
   the strands meet or one enters the other's space.
9. ACCEPTANCE TEST: (a) read the ledger aloud with the video muted - it must
   be a coherent double story; (b) pause at five random frames and state what
   each strand is currently doing - if you cannot, add an orientation cue;
   (c) shuffle the block order on paper - meaning must break, or this is a
   list not a cross cut; (d) count blocks delivering no change: target zero;
   (e) count blocks cut before their consequence: target all but the last.
```

## Execution spec

**The ledger is a `STORYBOARD.md`, and that is a real, parsed artefact in this stack.** Do not keep it in a scratch note — write it as the plan layer, where the CLI and Studio can read it back (`@hyperframes/core/storyboard` → `StoryboardManifest`; `GET /api/projects/<id>/storyboard`; Studio contact sheet at `?view=storyboard` ahead of the hash). One frame per block:

```markdown
---
format: 1920x1080
duration: 32
message: Two threads, one window of time
arc: escalating
mode: cross-cut
---

## Frame 3 — A: the build fails
- status: outline
- duration: 3.5
- scene: A discovers the error in the log; cut before we see what it says
- extra_strand: A
- extra_beat: 2
- extra_open_question: what did the log say?

## Frame 4 — B: the deadline moves
- status: outline
- duration: 3.0
- scene: B is told the review is in ten minutes; cut before B reacts
- extra_strand: B
- extra_beat: 2
- extra_open_question: does B know about the failure?
```

Known keys are `status` (`outline` → `built` → `animated`), `src`, `duration`, `transition_in`, `scene`, `voiceover`, `poster`; **unknown keys are preserved under `extra`** and the parser *never throws*, recording surprises as `warnings` — which is exactly why `extra_strand` / `extra_beat` / `extra_open_question` are safe to carry the ledger's own columns. **Caveat from this project's constraints:** the documented review loop for `.hyperframes/frame-comments.json` ends in "delete the file", and the mounted vault **cannot delete files** — supersede with a new `pass` marker instead.

**HyperFrames assembly.** Blocks are ordinary clips on the root timeline, all times in **seconds**. Use `data-track-index` as a readability convention only — it is display-only and constrains nothing; layering is CSS `z-index`. A useful convention borrowed from the transition injector is a **0/1 ping-pong** so alternating strands never share a lane:

```html
<video id="a3" src="a.mp4" muted playsinline class="clip"
       data-start="12.00" data-duration="3.50" data-media-start="41.2" data-track-index="0"></video>
<video id="b3" src="b.mp4" muted playsinline class="clip"
       data-start="15.50" data-duration="3.00" data-media-start="18.9" data-track-index="1"></video>
```

The **spine** is an `<audio>` at the **host root** (so it survives scene cuts in a modular project) with an `id`, a high track index, and a carve against the voice group if it is music. The location ambiences are two more `<audio>` clips with overlapping `data-start`s on **different** track indices (overlapping audio on one index raises `duplicate_audio_track`) and a `data-automation` `volume` lane crossfading them 6–15 f at each boundary — remembering the lane's `t` is **clip-local** and holds its first value backwards to the clip start.

Relative timing (`data-start="a3 + 0"`) can express "B starts when A ends", and is attractive for a ledger because block durations churn during the edit. It has four silent-zero failure modes: **spaces around the operator are mandatory** (`a3-0.5` parses as an id), an unresolved id resolves to `0` rather than erroring, a target with no resolvable duration lands on the target's **start**, and a cycle resolves to `0`. Nothing in lint checks any of them. If you use it, `npx hyperframes snapshot --at <midpoints>` and verify the block actually starts where you meant.

**ffmpeg.** Only for measurement and for assembling material that leaves the pipeline:
```bash
ffmpeg -i ref.mp4 -vf "scdet=t=12,metadata=print" -f null - 2>&1 | grep lavfi.scd   # block boundaries
ffmpeg -i ref.mp4 -vf "signalstats,metadata=print:key=lavfi.signalstats.SATAVG:file=sat.txt" -f null -   # grade separation per strand
```

**Epidemic Sound.** The spine, when it is music: `SearchRecordings { query.term: "driving pulse tension building instrumental", filter.moods: ["Suspense","Restless"], filter.hasVocals: false, filter.duration: { min: 40000 } }`. Location ambiences: `SearchSoundEffects { query.term: "<location> room tone ambience loop", filter.duration { min: 8000 } }` — placed in an `ambience` group, never in the `voiceover` group.

**Remotion:** conceptually one `<Sequence>` per block over a shared `<Audio>` spine; no Remotion runtime exists in this project.

## Pairs with
[[struct-cross-cutting-parallel-action]] · [[sfx-phone-call-cross-cut-treatment]] · [[struct-storyboard-the-cuts-pre-shoot]] · [[struct-comment-prompt-curiosity-gap]] · [[cut-hard-cut-for-new-information]] · [[cut-split-edit-attention-steering]] · [[sfx-ambience-bridge-across-cut]] · [[struct-progressive-layer-demo]] · [[pace-silent-demonstration-window]] · [[struct-inverse-pair-teaching]]

## Failure modes
- **Blocks that deliver nothing.** Alternation without advancement — the audience notices the pattern, gets no reward, and disengages faster than they would from a single long shot. Fix: every row of the ledger names one change, or the block is cut.
- **Two beats in one block.** The second beat is under-served and the viewer loses one of them. Fix: split the block; the sequence gets one more alternation, which is usually an improvement anyway.
- **Resolving before you cut away.** The strand is closed, so the return has no pull and reads as an obligation. Fix: move the out-point earlier, before the consequence is shown.
- **Re-establishing on every return.** Runtime spent on orientation the audience already has; the sequence feels slow despite short shots. Fix: enter on the next state, and invest in orientation cues instead.
- **Too many strands.** Three threads with one orientation cue each is unreadable; the viewer stops tracking and just watches images. Fix: two strands, or three with two cues each.
- **No audio spine.** Sound cuts at every picture cut and the sequence fragments audibly, losing all the tension the ledger built. Fix: one continuous element across the whole sequence, ambiences crossfaded under it.
- **Shuffleable order.** If the blocks can be reordered freely the juxtaposition is asserting nothing. Fix: build causality into the ledger — each block should be readable as a consequence of, or a threat to, the previous one.
- **Simultaneity assumed but not true.** Audiences read alternation as "at the same time" by default; if it is not, they will be actively misled. Fix: signpost with a title, a time reference in the VO, or do not cross-cut.
- **Known gap:** the published literature on cross cutting is almost entirely about *effect* (suspense multiplication, narrative causality) and almost never about per-block information rules; the two studiobinder references explicitly provide no guidance on cliffhanger out-points, per-block information, or strand counts. `info_density`, `open_exit_ratio`, `reestablish_ratio` and `question_lifetime` are house metrics defined here so the property can at least be measured consistently. Treat them as review flags, not standards, and recalibrate from any reference sequence you have.
