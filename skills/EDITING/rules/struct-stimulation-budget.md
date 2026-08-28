---
id: struct-stimulation-budget
aliases: [sfx-stimulation-budget]
title: Match the stimulation budget to the format's promise
skill: editing
type: retention
family: retention-contract
tags: [skill/editing, type/retention, family/retention-contract, engine/hyperframes, engine/epidemic, engine/ffmpeg, layer/sfx, layer/music, layer/design, source/editing-kt, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:01:22"
    quote: "A bunch of fast cuts and flashy animations would kill the authentic experience the viewer came for. And guess what, interrupting what the viewer actually came for is the fastest way to get them to click off."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:01:30"
    quote: "While Sam averages 90 seconds between cuts, Mr. Beast does the exact opposite."
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:01:39"
    quote: "Start by thinking about the experience your viewers want. Every single one of your editing decisions feeds into that experience."
research_refs:
  - https://en.wikipedia.org/wiki/Parasocial_interaction
  - https://en.wikipedia.org/wiki/Habituation
  - https://en.wikipedia.org/wiki/Orienting_response
  - https://en.wikipedia.org/wiki/Diegesis
  - https://air.io/en/youtube-hacks/advanced-retention-editing-cutting-patterns-that-keep-viewers-past-minute-8
  - https://www.retentionrabbit.com/blog/2025-youtube-audience-retention-benchmark-report
  - https://prepublish.ai/guides/first-30-seconds
  - https://www.opus.pro/research/broll-visual-effects-short-form
difficulty: medium
detectable_from: transcript+video
---

# Match the stimulation budget to the format's promise

## What it is
Every format sells the viewer a specific experience, and every edit decision either delivers that experience or interrupts it. **Stimulation — cut density, punch-ins, motion graphics, whooshes, risers, hits, music — is not a universal good that can be added freely; it is a budget set by the promise.**

Stimulation is not free: every element spends attention as well as buying it, and in a format whose value *is* intimacy, the spend is a net loss. The source's example is a 26-minute video with 17 cuts and no other editing that performs extremely well — because its promise is *"they just want to feel like they're hanging out with someone"*. Research on parasocial interaction agrees: the bond is built by direct address, conversational manner and self-disclosure, none of which sound design or motion graphics improve. A hangout video and an entertainment montage sit at opposite ends of the budget, and applying one's budget to the other destroys the thing the viewer arrived for.

The corollary is that the budget is **subtractive**: for an intimacy-led format the correct action is to *remove* stimulation the footage already invites. Adding is the easy half; subtracting is the skill.

This note owns the **whole** budget. Every downstream pass — cuts, motion, sound, subtitles — draws from it and may not exceed it. The sound-design share is a set of rows in the table below, not a separate budget.

## When to use it
Run this as the **very first gate**, before any cut is designed, and before the spotting pass in [[sfx-sound-pass-order]] — it is the gate that decides whether the motion and aesthetic sound styles apply at all. In Mode A it is the framing question.

Use it specifically when: the reference video's cut density is far outside the "YouTube default" band and you are tempted to normalise it; the client footage is a single-camera talking head or vlog; the retention curve shows a cliff in a stylistically busy section; or a design row proposes a graphic, whoosh or riser whose only justification is "it had been a while".

**Three format archetypes, three budgets.** (The editing library calls them companionship / explainer / entertainment; the sound library calls the first two intimacy / teaching. Same three things.)

- **Companionship / intimacy** (vlog, hang-out, podcast, car talk, sincere-to-camera, interview): diegetic layer and ambience only. Almost no motion effects, no risers, no hits, no graphics. Music optional and often absent. Sound design here means making the room feel real, not making the edit feel exciting.
- **Explainer / teaching** (this creator's own format): full diegetic + ambience, motion effects on graphics only, aesthetic effects reserved for 2–5 structural beats, music per section, a visual change every 15–40 s.
- **Entertainment / retention-max** (challenge, listicle, high-energy short): all three sound styles at high density, effects on nearly every graphic event, music always present.

**The trap is applying entertainment-format technique to an intimacy format because the techniques are available and impressive.**

## How to recognise it in a reference video
Measure the format archetype from observables, then check every stimulation element against it.

- **Classify from the first 30 seconds.** Direct address, sustained single shots, unedited pauses, first-person disclosure → companionship. Rapid B-roll, on-screen graphics, a hook promising a payoff → explainer or entertainment. **Transcript signal:** "feel like you're hanging out", "let's just talk" → low budget; "10 things", "you won't believe" → high budget.
- **Cut density, measured not felt.** Compute median shot length, p90, and cuts/minute:
  - Companionship: median shot **20–90 s** (8–90 s at the low end), **0.7–3 cuts/min**, cuts almost all subtractive (removals), no reframe on the cut.
  - Explainer: median shot **2.5–8 s**, **8–20 cuts/min**, a visual change every **15–40 s** even when the A-roll continues.
  - Entertainment: median shot **0.8–2.5 s**, **24–50 cuts/min**.
- **Motion-graphic count per minute.** Count distinct animated overlays. Zero per minute across a 20-minute runtime is an explicit authenticity signal, not an omission.
- **SFX census — and count the two classes separately, because they differ by an order of magnitude.** Non-diegetic accents (whooshes, hits, risers, ticks) are rare; diegetic effects (the action inventory — hands, doors, keys, paper) are numerous, and a single busy shot can carry six in ten seconds. A count that lumps them together is meaningless. See the two parameter rows below.
- **Music under speech.** Present at a carve/duck, absent, or absent-by-design? A companionship edit frequently has **no bed at all** under dialogue. Measure music presence as a percentage of runtime.
- **Punch-in / scale changes on A-roll.** Present = the budget is open; wholly absent across a long runtime = deliberately closed.
- **The violation signature:** a video with 60–90 s average shot length *and* a whoosh on every graphic. **The mismatch between visual pace and audio density is the diagnostic** — the two must be drawn from the same archetype.
- **Pause treatment is the cleanest single tell.** If pauses and breaths survive, the format is trading entertainment for authenticity, and every other decision must respect that trade — *"if you cut out every pause so you're talking non-stop, that's by far the biggest thing you can do for entertainment. But it comes at the cost of authenticity."*
- **Cross-check the transcript:** sincere or vulnerable content under high-density editing or sound design is the specific failure this note guards against.
- **The cliff test.** If retention data is available, a drop coinciding with the *start* of a stylistically busier section (rather than a content boundary) is the signature of a violated budget.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `format_archetype` | `explainer` | `companionship` \| `explainer` \| `entertainment` | Set once per project, recorded in the profile; every other parameter derives from it. |
| `median_shot_length` | 5.0 s (150 f) | 0.8–90 s | Companionship 20–90 s (8 s at the low end); explainer 2.5–8 s; entertainment 0.8–2.5 s. |
| `cuts_per_minute` | 12 | 0.7–50 | Inverse of the above; log it as a measured number, never as an adjective. |
| `visual_change_interval` | 25 s (750 f) | 10–90 s | Interval at which *something* on the video track changes. Age-skewed: 13–24 → 15–25 s; 25+ → 20–40 s. |
| `motion_graphics_per_minute` | 1.0 | 0–6 | Companionship: 0. |
| `non_diegetic_sfx_per_minute` | 4 | 0–20 | **Accents only** — whooshes, hits, risers, ticks, transition sounds. Companionship 0–1; explainer 3–6; entertainment 6–20. This is the number the aesthetic budget guards. |
| `all_sfx_per_minute` | 12 | 0–50 | **Including the diegetic layer.** Companionship 0–2; explainer 6–18; entertainment 20–50. A busy diegetic shot legitimately carries 6 events per 10 s ([[sfx-diegetic-action-inventory]]), which is why this number dwarfs the row above. **Never compare a count from one row against the other's band.** |
| `aesthetic_effects_allowance` | 3 for the whole video | 0–15 | Risers, hits, drones. Companionship 0–1; explainer 2–5; entertainment 5–15. |
| `motion_effects_on_a_roll` | 0 | 0–1 per minute | Effects belong on graphics and on cuts, not on a talking face. |
| `diegetic_plus_ambience` | always on | — | The one layer no archetype removes. |
| `music_bed` | `carved` | `none` \| `carved` \| `full` | `none` is a legitimate choice for companionship. |
| `music_coverage` | 75 % of runtime | 0–100 % | Companionship 0–40 %; explainer 60–90 %; entertainment 85–100 %. |
| `broll_max_hold` | 4.0 s (120 f) | 2.5–5 s | Beyond ~5 s B-roll pulls focus off the voice. |
| `breathing_beat` | 1.0 s (30 f) | 0.7–1.5 s | Near-silent hold after a high-energy burst, so the burst reads. |
| `dry_beat_allowance` | at least one 2 s+ dry beat per 3 min | — | Dialogue and ambience only — no music, no effects. Somewhere for the ear to rest. |
| `promise_stated_by` | 15 s | 8–15 s | The payoff claim must land by second 15 regardless of archetype. |

## Reproduction prompt

```
Gate a video edit against its format promise. Do this BEFORE designing any cut
and BEFORE any sound is spotted.

1. CLASSIFY. Read the first 30 s of transcript and picture and name the
   archetype in one word: companionship, explainer, or entertainment. Write it
   as `format_archetype:` at the top of design-cuts.md, quote the transcript
   line that proves it, and state the format's promise in one sentence.

2. SANITY-CHECK AGAINST THE PICTURE. Compute average shot length from the cut
   list. If it is > 8 s, the format is companionship-leaning regardless of what
   step 1 said - re-check before proceeding.

3. SET THE BUDGET from the archetype, at 30fps. Write it into design-cuts.md as
   hard numbers, and cite it from design-sound.md and design-motion.md:
   companionship  -> median shot 600-2700 f, 0.7-3 cuts/min, 0 graphics/min,
                     0-1 non-diegetic SFX/min (0-2 all-in), 0-1 aesthetic
                     effects total, music_bed = none (0-40% coverage).
   explainer      -> median shot 75-240 f, 8-20 cuts/min, <=1 graphic/min,
                     3-6 non-diegetic SFX/min (6-18 all-in), 2-5 aesthetic
                     effects total, music_bed = carved (60-90%), a visual
                     change every 450-1200 f.
   entertainment  -> median shot 24-75 f, 24-50 cuts/min, <=6 graphics/min,
                     6-20 non-diegetic SFX/min (20-50 all-in), 5-15 aesthetic
                     effects total, music_bed = full (85-100%).
   Keep the two SFX counts on separate lines. They are not the same number.

4. RUN THE VETO on EVERY proposed stimulation element (cut, punch-in, overlay,
   whoosh, riser, hit, music change). Keep it only if all four are YES:
   (a) it carries needed information or marks a real structural boundary;
   (b) it fits the per-minute budget, counted over the whole runtime;
   (c) the moment still reads without it (if not, it is load-bearing - keep);
   (d) it leaves the promise intact - it does not make an intimate moment feel
       produced.
   Delete every failure and log the failing letter as the reason. When the
   budget is spent, further rows are REJECTED, not squeezed in at lower volume -
   lowering the level does not reduce the count.

5. TWO RULES REGARDLESS OF ARCHETYPE: the payoff claim lands by 15 s, and after
   any burst of 5+ quick cuts insert a 30-frame near-silent hold. Reserve one
   dry beat per 3 minutes: 2+ seconds of dialogue and ambience only.

6. AUDIT AFTER EACH PASS. Recompute median shot length, cuts/min, graphics/min
   and both SFX counts from the finished design - over the whole runtime AND in
   the busiest single minute. If the busiest minute exceeds a ceiling by more
   than 50%, delete elements from it until it does not.

ACCEPTANCE TEST: every measured number falls inside its band, in a sliding 60 s
window and not just globally. If any is out, SUBTRACT; do not re-band. Then
state the format's promise again and name every element that does not serve it -
that list must be empty. A viewer who came for the promise in step 1 should not
be able to point at any moment where the editing pulled them out of it.
```

## Execution spec

**Measurement (ffmpeg) — do this first, on the reference:**

```bash
# real fps and duration; every frame count below depends on it
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate,nb_frames \
  -show_entries format=duration -of default=nw=1 "<ref.mp4>"

# cut candidates -> shot-length distribution
ffmpeg -i "<ref.mp4>" -vf "select='gt(scene,0.3)',showinfo" -vsync vfr -f null - 2>&1 \
  | grep showinfo | sed -n 's/.*pts_time:\([0-9.]*\).*/\1/p' > cuts.txt
# median / p90 / cuts-per-minute from consecutive differences in cuts.txt

# SFX density cross-check: count transients above a threshold outside the voice band
ffmpeg -i ref.mp4 -vn -af "highpass=f=800,astats=metadata=1:reset=0.5,\
ametadata=print:key=lavfi.astats.Overall.Peak_level" -f null - 2>&1 | grep -c "Peak_level"
```
Treat the transient count as a cross-check on the hand log, not as ground truth — it cannot tell a diegetic click from a designed tick, which is exactly the distinction the two SFX rows depend on.

**Enforcement in HyperFrames.** There is no stimulation primitive in the contract; the budget is enforced as a **count over the composition**, so make it countable:
- One `<audio data-audio-group="sfx">` element per SFX event — count them and divide by root `data-duration` for SFX/min. Route diegetic and non-diegetic effects to **separate groups** (`sfx-diegetic` / `sfx-motion` / `sfx-aesthetic`, per [[sfx-three-types-classification]]) so the two counts are a `grep` apart rather than a judgement call.
- Motion graphics as sub-composition hosts (`data-composition-src`) rather than inline, so `grep -c data-composition-src index.html` is the graphics census.
- `music_bed: none` means literally no bed clip. `carved` means one bed with `data-fx-carve` against a `voiceover` group at `strength` 0.25 ([[sfx-music-audition-against-picture]]).
- The `breathing_beat` and the dry beat are real windows in which no `<audio>` in the `sfx` or `music` group is active and no tween fires. Verify with `npx hyperframes snapshot --at <t>` plus a read of the timeline positions.

Two mechanisms make density decisions reversible, which matters because the vault cannot delete files:
- **`data-hidden` on a clip** drops it from both preview and render, non-destructively. This is the right way to A/B a density decision: hide the marginal elements, snapshot, compare — rather than deleting and re-authoring.
- **`data-hidden` on an `<hf-audio-group>`** drops every member of a layer at once. Hiding the whole `sfx` group and listening to dialogue + ambience + music alone is the fastest way to hear whether the effects pass is carrying the video or cluttering it.

**Subtractive pass (the only edit a companionship format usually needs):**
```bash
node <SKILL_DIR>/scripts/transcript-cut.mjs --input talk.mp4 --transcript talk.transcribe.json \
  --cut-silence 1.2 --out talk.cut.mp4      # companionship: generous threshold, keep the pauses
# explainer/entertainment: --cut-silence 0.35 --remove-fillers "um,uh,like"
```

**Epidemic Sound.** The budget changes **what you fetch**, not just what you place. For a companionship format the fetch list is dominated by ambience and foley queries (`ambience--room-tone`, `cloth--movement`) and may contain **no** `designed--*` assets at all. For an entertainment format, the reverse. If a fetch list for an intimacy-format video is full of risers and impacts, the budget was set and then ignored.

Nothing in `hyperframes check` counts effects or measures density; this note's audit is a manual step and belongs in the build manifest as its own checklist row. Note also the known gap: the browser-dependent legs (`check` audits, `snapshot`, `render`) do not run on the authoring VM per §9 of the execution contract — treat the composition as the deliverable and verify counts statically.

**Remotion:** same concept, enforced as a lint over the composition tree rather than a data-attribute census. Not present in this project.

## Pairs with
[[pace-cut-density-from-viewer-intent]] — this note sets the *veto policy* and the per-minute element budget; that note owns the numeric cut-density targets. Use them together, not interchangeably. · [[sfx-density-fatigue-audit]] — that note audits the finished mix against these ceilings.

[[struct-outcome-first-cold-open]] · [[struct-demand-hook-competence-gap]] · [[struct-enumerated-promise-and-counter]] · [[pace-overlay-instead-of-cut]] · [[pace-silent-demonstration-window]] · [[sfx-riser-anticipation-build]] · [[struct-objection-character-cutaway]] · [[sfx-sound-pass-order]] · [[sfx-motion-sound-selection]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-ambience-search-formula]] · [[sfx-music-rest-windows]] · [[sfx-pause-removal-breath-and-room-tone]] · [[motion-format-promise-motion-budget]] · [[sfx-three-types-classification]] · [[sfx-diegetic-action-inventory]] · [[sfx-music-hard-stop]]

## Failure modes
- **Importing a style instead of choosing one.** Copying an entertainment creator's editing or sound design onto an intimacy format destroys exactly the thing that format sells.
- **Normalising an outlier reference.** You measure 90 s between cuts, assume the measurement is wrong, and design at 5 s. Correction: trust the measurement; a 0.7 cuts/min reference is a style, not an error.
- **Treating stimulation as monotonic.** More is not better; the source's whole argument is that added stimulation can subtract value. The budget exists so "add one more" is a decision with a cost.
- **Adding stimulation to fix a boring section.** A whoosh does not make a weak line strong. Correction: the fix for a boring section is a cut that removes it, not an overlay that decorates it.
- **Comparing the two SFX counts.** "18 effects a minute" is a normal explainer with a diegetic layer, and a gross violation if they are all whooshes. Correction: count accents and diegetic events separately, and say which you measured.
- **Lowering levels instead of cutting count.** Twenty quiet effects still cost twenty attention events. Density is a count, not a level.
- **Sound design on A-roll faces.** Whooshes on a talking head are the clearest symptom of a mis-set budget. Effects belong on graphics and on cuts.
- **Budgeting per scene instead of per runtime.** Six graphics in one 90-second stretch and none for the next eight minutes still averages inside the band but reads as a different video for 90 seconds. Correction: check the per-minute count in a sliding 60 s window, not just the global mean, and include the busiest minute.
- **No dry beats anywhere.** A video with wall-to-wall music and effects has no dynamic range left for a moment to feel important; [[sfx-music-hard-stop]] and [[sfx-cinematic-hit-emphasis]] both stop working.
- **Treating "no music" as an unfinished mix.** Correction: `music_bed: none` must be written explicitly in the design document so a later pass does not "fix" it.
- **Setting the budget and never auditing it.** The count creeps up event by event. Audit after every pass, per minute, including the busiest minute.
- **Silent stimulation creep.** Each pass (motion, then sound, then subtitles) adds inside its own budget, and the total blows out. Correction: **this document owns the totals**; downstream passes cite it and may not exceed it.
- **Known gap:** no public retention dataset was reachable during this research to quantify drop-off from over-editing in intimacy formats. The mechanism (parasocial bond built by direct address and disclosure; habituation to repeated stimuli) is well documented; the effect size is not. Treat the archetype table as a calibrated heuristic derived from the source video plus measured reference profiles, not as a published finding.
