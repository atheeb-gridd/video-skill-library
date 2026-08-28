---
id: sfx-diegetic-action-inventory
aliases: [sfx-diegetic-action-pass]
title: Every physical action on screen has a file — the diegetic action inventory
skill: sound-design
type: sfx
family: diegetic-sfx
tags: [skill/sound-design, type/sfx, family/diegetic-sfx, engine/epidemic, engine/hyperframes, engine/ffmpeg, sfx/diegetic, layer/sfx, layer/ambience, source/sfx-kt-1, source/sfx-kt-2, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:03:33"
    quote: "For example, if you've animated some motion graphics, or you've opened a door, or you're flipping a page in the video — for every one of those, you'll find sound effects on the internet, so download them and put them on."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:03:39"
    quote: "Are you applying them in the right place, or just slapping them on everywhere?"
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:03:57"
    quote: "Diegetic sound effects — which are the sound effects that exist pretty prominently in the real world. Like a phone ringing, a gunshot. Without these your video just can't feel real."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:06:58"
    quote: "So first of all, if you're putting a sound effect on a cut, place the highest peak of the sound effect on the cut."
research_refs:
  - https://en.wikipedia.org/wiki/Foley_(filmmaking)
  - https://en.wikipedia.org/wiki/Diegetic_music
  - https://en.wikipedia.org/wiki/Transient_(acoustics)
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - https://tech.ebu.ch/docs/r/r037.pdf
  - https://blog.prosoundeffects.com/sound-layering
  - https://blog.prosoundeffects.com/sound-editing-in-sync-tutorial
  - https://ffmpeg.org/ffmpeg-filters.html
  - mcp://Epidemic_sounds/SearchSoundEffects (paper / keyboard / camera families probed live; catalogue title schema derived from results, 2026-08-27)
difficulty: medium
detectable_from: video
---

# Every physical action on screen has a file — the diegetic action inventory

## What it is
A dedicated pass over the cut whose only job is to find **physical events** — a page flip, a door, a mug set down, a button press, a snap, a zip, a camera shutter, a laptop closing, a switch thrown — and give each one the sound it would actually make. The source's framing is deliberately unglamorous: the sound exists on the internet, so identify the action, search the action's name, download, place it. The workflow is literal: **inventory, name, search, place on the contact frame.** No taste is required for any step except naming.

The craft is entirely in the last word. Two things separate an action pass from *"just slapping them on everywhere"*: it is driven by an **inventory** rather than by feel, and every placement is aligned by **transient to contact frame**, not by dragging the file's head to the cut.

This is the diegetic layer — the first and most important of the three styles, because it is the one that makes the video feel real rather than merely produced. **It is the layer whose absence is felt but not identified.** A video with no diegetic effects does not sound quiet; it sounds *fake*. Location audio rarely supplies them usably — the sounds are "obstructed by noise or are not convincing enough", and props made of cheap material do not sound like what they represent — which is precisely why Foley exists as a discipline and why re-adding sounds afterwards gives control over which is loud and which is soft. It is invisible when right and unmistakable when wrong.

## When to use it
Run it once, after the picture is locked, on **any footage containing hands, objects or bodies**: product handling, demos, unboxings, desk shots, cooking, walking, doors, drawers, tools, devices, paper. Run it **before** the motion and aesthetic passes ([[sfx-sound-pass-order]]) — an edit that already sounds real needs far fewer designed effects to feel finished.

Two triggers make it mandatory rather than optional:
- **The shot is about the object.** If the viewer is watching the thing being done, the sound of it being done is not decoration; it is the content.
- **A cut lands on the action.** A cut on action with no sound on the action is the most exposed possible omission ([[cut-on-action]]).

The inventory decides what gets a sound. Three rules bound it:
- **Sound it if the viewer can see the contact** — a hand meeting a table, a page turning, a lid closing.
- **Sound it if the action is the point of the shot** — the click that starts the demo, the shutter on the photo, the phone that rings and interrupts.
- **Do not double what production audio already carries.** If the on-camera mic recorded the click clearly, adding a library click produces a **flam** — two attacks a few milliseconds apart — which sounds worse than either alone. Either mute the production audio for that moment, or skip the effect.

Skip an item only when it is off-screen and unimplied; the ambience bed already covers it (footsteps in a busy street); or the action happens under an important word with no gap to move it into. **Off-screen actions still count** when they carry meaning: a door closing out of frame tells the viewer someone left. Sound it, 6 dB down and low-passed, so it sits behind the frame rather than in it.

## How to recognise it in a reference video
- **Step the picture and list contact frames.** Scrub at quarter speed and mark every frame where two things touch, separate, start or stop. That list *is* the diegetic inventory; then check each entry against the audio. **Coverage above ~80 % of visible contacts** is a deliberate action pass; below ~30 % the video is running on production audio alone.
- **Measure the offset in frames.** For each event, `sfx_peak_frame − contact_frame` should be **0 to +1 frame**. The detection threshold for sound *leading* picture is about **45 ms (1.4 frames at 30 fps)**; for sound *lagging* it is about **125 ms (3.7 frames)** — so diegetic effects should err a frame late, never early. An effect landing 2+ frames early is the tell of a file dropped on a marker without measuring its attack.
- **Zoom the waveform to sample level at each contact.** A placed effect shows a transient whose onset sits **within a half to a quarter of a frame** of the picture event (±8–17 ms at 30 fps). Production audio shows the same transient plus room tone that starts before and continues after.
- **Look for the flam.** Two attacks **10–60 ms apart** on the same visual event means library-over-production doubling. One of the most common amateur tells, and it is visible in the waveform, not just audible.
- **Check for the layered impact.** A convincing single action is usually 2–3 files: the approach (cloth, air), the contact transient, and the settle/release. One thin file on a heavy object reads as cheap. Pro practice caps this at **3–5 layers** before it becomes clutter.
- **Level relationships tell you what the shot is about.** Background action sits **−18 to −24 dB** under dialogue; the hero action of the shot sits **−12 to −15 dB**. If everything is at one level, no pass was made — a plugin or a template did it. Anything at dialogue level is a mix error, not emphasis.
- **Off-screen events sit lower and duller.** Measure spectral centroid: an off-frame action should be **6 dB down** and visibly low-passed relative to an equivalent on-frame one. If they match, the mix has no depth.
- **Look for room.** A diegetic effect with no reverb sits in front of the picture rather than inside it ([[sfx-reverb-glue]]).
- **Check the spectrum against the material.** A wooden table hit with no low-mid body, or a paper sound with a 4 kHz metallic ring, means the effect was chosen by keyword and not auditioned against the picture.
- **Repetition check on multi-take actions.** Three page turns in a row should be three different files — library shelves ship numbered takes 01…07 for exactly this. Identical waveform shapes at different timecodes are visible by eye and are the named mistake.
- **Negative signal:** hands moving objects in total silence, while whooshes and hits are present elsewhere. That is a video with a motion pass and no diegetic pass — the "feels cheap" diagnosis.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `inventory_coverage` | 100 % of hero actions, ~60 % of background actions | 80–100 % of visible contacts after pruning | Full coverage of everything is the density mistake. Prune for production-audio doubling and merge events under 0.25 s apart. |
| `peak_vs_contact` | 0 f | 0 to +1 f (0 to +33 ms) | **Never early.** Measure the file's peak; do not assume it is at the head. |
| `sync_tolerance` | ±0.5 f (±17 ms) | ±0.25 to ±1 f | The post convention is "within half to quarter frame to avoid flam". EBU's in-production tolerance is tighter still: audio 5 ms early to 15 ms late. |
| `alignment_anchor` | the effect's **transient**, not its file head | — | For a file with 120 ms of pre-roll, `data-start = contact_time − 0.120`. |
| `level_hero` | −13 dB (`data-volume="0.224"`) | −12 to −15 dB (0.251–0.178) | The action the shot is about. |
| `level_background` | −20 dB (`0.1`) | −18 to −24 dB (0.126–0.063) | Present, unnameable. An **importance** tier. |
| `level_off_frame` | −6 dB below the equivalent on-frame level | — | Plus a low-pass at 3–5 kHz. A **spatial** adjustment — it stacks with the tier above, it does not replace it. |
| `layers_per_action` | 2 | 1–3 (max 5) | Approach + contact, plus a settle for heavy objects. |
| `approach_lead` | −4 f (−133 ms) | −2 to −8 f | The approach layer starts early; only the **contact transient** is frame-locked. |
| `settle_offset` | +3 to +6 f | — | Heavy objects only. |
| `hard_contact_classes` | page flip, button, latch, snap, set-down, slap | — | Transient on the contact frame, tolerance ±0.5 f. |
| `soft_contact_classes` | cloth, carpet footstep, paper slide, hand on fabric | — | Tolerance ±1 f; slow attacks, no single peak. |
| `continuous_classes` | walking, dragging, writing, typing, pouring | — | Start on motion start, end on motion end, tolerance ±2 f; match **length**, not just the peak. |
| `reverb_glue` | `wet` 0.10, interior | 0.05–0.18 interior · 0.02–0.05 exterior plus ambience | On the **bus**, not per clip. Without it, library effects sound studio-recorded and sit outside the picture. |
| `variants_for_repeats` | 3 | 2–5 | Use numbered takes from the same shelf. |
| `max_repeats_of_one_file` | 2 | 1–3 | Third use needs a **different file**, not a different pitch. |
| `variation_params` | pitch, duration, reverb | — | The three knobs that turn one file into many. Never reuse a file without moving at least one. |
| `pitch_for_variation` | ±2 semitones | ±1 to ±4 st | Anti-repetition. |
| `pitch_for_size` | ±0 | −4 to +4 st | Down = bigger/heavier object; up = smaller/lighter. A different job from the row above. |
| `ducking` | none | none | Too short to duck. If it collides with a stressed syllable, move it into the nearest word gap or drop 4 dB. Dialogue wins. |
| `density_ceiling` | 6 events / 10 s | 3–8 | Above this the diegetic layer becomes the tick-tick-tick fatigue failure ([[sfx-density-fatigue-audit]]). |

## Reproduction prompt

```
Run the diegetic action pass over the footage between {{T_IN}} and {{T_OUT}}.

STEP 1 - BUILD THE INVENTORY. Scrub at quarter speed. For every physical event
write one row:
  contact_time (s, 3 dp) | object | action | material | on/off-frame |
  tier (hero | background) | production audio already carries it? (y/n)
Extract stills to make this reliable:
  ffmpeg -ss {{T_IN}} -to {{T_OUT}} -i shot.mp4 -vf fps=30 frames/%05d.png
A frame number N maps to time = {{T_IN}} + (N-1)/30. Do not fetch anything yet.

STEP 2 - PRUNE. Delete rows where production audio already carries the event
clearly - adding a library layer there causes a flam. Merge rows closer than
0.25 s. Cap the surviving list at 6 events per 10 seconds; if the picture has
more, keep the ones the viewer's eye lands on.

STEP 3 - NAME EACH ROW THE WAY THE CATALOGUE NAMES IT. Epidemic titles read
"Category, Subcategory, Object, Descriptors, Variant NN" - so search in that
order: material/category first, action last. Search the NOUN CHAIN, never an
adjective ("nice paper sound" returns nothing useful).
    page flip  -> "paper handle notepad page turn"
    key press  -> "keyboard mouse keyboard key press"
    mug down   -> "kitchen ceramic mug set down table"
    button     -> "plastic button click mechanical"
    zipper     -> "metal zipper fast"
Include the PERSPECTIVE (close / distant / interior) where it matters.

STEP 4 - FETCH 3 TAKES PER ROW.
    SearchSoundEffects { query:{term:"<noun chain>"},
      filter:{ tagSlugs:{matchType:ALL,values:["<family slug>"]},
               duration:{min:200,max:3000} }, first:8 }
Prefer titles ending in a number (01, 02, 03...) - those are alternate takes of
the same object and are how you avoid repeating a file. Audition at least 2
candidates against the picture before choosing. DownloadSoundEffect, fileType
WAV.

STEP 5 - MEASURE EACH FILE'S PEAK:
    ffmpeg -i sfx.wav -af "astats=metadata=1:reset=0.01,ametadata=print:\
    key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
  peak_offset = (index of loudest 10 ms window) * 0.01

STEP 6 - PLACE BY TRANSIENT. Per row:
    data-start       = contact_time - peak_offset
    data-duration    = peak_offset + tail (0.25 s light, 0.8 s heavy)
    data-volume      = "0.224" hero | "0.1" background
    data-audio-group = "sfx"   (NEVER the voiceover group)
    data-track-index = 12, 13, 14... one per simultaneous effect
Unique id on every <audio> or it is dropped from the mix silently.
Target 0 offset; if you must err, err LATE by up to 1 frame (33 ms) and NEVER
early - sound leading picture is detected from about 45 ms, sound lagging only
from about 125 ms. Keep every transient within half a frame (17 ms) of its
contact. For continuous actions, match the effect LENGTH to the motion length as
well as its start.

STEP 7 - LAYER THE HERO ACTIONS. Add an approach layer (cloth, air, whoosh)
starting 4 frames (0.133 s) before contact at 6 dB below the contact layer, and
for heavy objects a settle layer 3-6 frames after. Two or three layers; never
more than five.

STEP 8 - TREAT. Off-frame events go 6 dB lower than their tier with a low-pass
at 3-5 kHz. Put ONE reverb on the "sfx" group, not on each clip - one room for
all of them, wet 0.10 interior. If a file appears more than once in the video,
change at least one of pitch (+/-2 st), duration, or reverb between uses; after
two uses, use a different file.

STEP 9 - CHECK COLLISIONS. Any effect whose peak lands inside a stressed
syllable: move it to the nearest word gap or drop 4 dB.

ACCEPTANCE TEST: watch muted, then unmuted. Unmuted, no hand touches anything in
silence, and you cannot point to a sound that is "too loud" without being
prompted - if you NOTICE any of them as a sound effect, it is too loud, too
late, or the wrong material. Then zoom each placement to sample level: every
hero action's transient is within half a frame of its contact frame, with no
second attack 10-60 ms away from it. No two consecutive same-family effects are
the same file. With the SFX group muted the shot feels flat but nothing sounds
broken - that is the signature of a diegetic pass rather than a design pass.
Finally, listen with picture off: the pass should sound like a room, not like a
drum machine.
```

## Execution spec

**Epidemic Sound.** The single most useful finding from probing the catalogue live: **titles are structured `Category, Subcategory, Object, Descriptors, Variant NN`**, and search hits that structure far better than adjectives. Verified (2026-08-27):

| Action | Query | Filter | Real results |
|---|---|---|---|
| Page flip | `page turn paper flip` | `tagSlugs ALL ["paper--handle"]`, `duration 200–3000 ms` | *Paper, Handle, Notepad, Page Turn 01 / 04 / 05 / 06 / 07* — **828 / 1184 / 859 / 1193 / 821 ms** (five alternate takes = five non-repeating uses) · *Paper, Handle, Thick, Turn Page* — 1640 ms |
| Key press | `keyboard typing computer` | `tagSlugs ALL ["computers--keyboard-mouse"]`, `duration 150–600 ms` | *Computers, Keyboard & Mouse, Keyboard, Small, Bluetooth, Type, Key Press, Spacebar 01* — **225 ms** |
| Typing run | `keyboard fast typing` | same slug, `duration 2000–6000 ms` | *PC, Fast Typing, Click, Input, Desk 01 / 02 / 06* — 4019 / 3245 / 3168 ms |
| Camera / shutter | `camera shutter click` | `tagSlugs ALL ["communications--camera"]` | see [[sfx-appearance-transient]] |

The pattern generalises: **find one correct hit, read its `tags[].slug`, then re-search filtered to that slug** with a narrower duration window. That two-step is what makes fetches reliable rather than lucky. `SearchSimilarToSoundEffect` on a winning take returns the rest of the shelf, and is the fastest route to the second and third variant of a sound you will use repeatedly — better than pitching one file three times.

```
SearchSoundEffects { query: { term: "paper page turn book close" },
                     filter: { duration: { max: 1500 } } }
SearchSoundEffects { query: { term: "ceramic mug set down wooden table" },
                     filter: { duration: { max: 1200 } } }
```
`DownloadSoundEffect` writes a local file and **stops there**; place it under `.media/audio/sfx/` (or `assets/sfx/`) so the compiler and render can reach it, and optionally ledger it with `node <SKILL_DIR>/scripts/resolve.mjs --from <file> --type sfx --project .`.

**HyperFrames.** Each effect is an `<audio>` clip. Sound and picture are coupled by writing the same number twice; there is **no audio-follows-animation attribute**, and *"HyperFrames does not provide automatic waveform sync or drift correction."* All time is **seconds** — convert frames at authoring time (1 frame = 0.0333 s at 30 fps).

```html
<!-- hero action: page turn, contact frame at t = 12.400 s, file peak at 0.084 s -->
<audio id="sfx-page-01" src="assets/audio/sfx/paper-page-turn-03.wav"
       data-audio-group="sfx" data-start="12.316" data-media-start="0"
       data-duration="0.53" data-track-index="12" data-volume="0.224"></audio>

<!-- its approach layer: cloth/air, 4 frames early, 6 dB down -->
<audio id="sfx-page-01-air" src="assets/audio/sfx/cloth-move-soft.wav"
       data-audio-group="sfx" data-start="12.183" data-duration="0.35"
       data-track-index="13" data-volume="0.112"></audio>

<!-- one room for every diegetic effect: reverb on the bus, not per clip -->
<hf-audio-group id="sfx" data-label="Diegetic + design"
  data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;g1&quot;,&quot;label&quot;:&quot;Clear Sub&quot;,&quot;params&quot;:{&quot;frequency&quot;:60}},{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;g2&quot;,&quot;label&quot;:&quot;Room Glue&quot;,&quot;params&quot;:{&quot;size&quot;:0.3,&quot;damping&quot;:0.6,&quot;wet&quot;:0.1,&quot;dry&quot;:1}},{&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;g3&quot;,&quot;params&quot;:{&quot;limit&quot;:-1}}]}"></hf-audio-group>
```

Contract points that bind this:
- **`data-media-start` is how you align the transient.** Trimming into the file moves the attack to the clip's start without cutting a physical file. Either trim the pre-roll with `data-media-start` and place the clip on the contact second, or place the clip early by the pre-roll length — **not both**. Never cut a file for a trim.
- **Every `<audio>` needs an `id`.** An id-less audio element is never mixed: a **silent render**, with no error beyond `media_missing_id`.
- **Seconds, not frames.** 12.316 s is a frame index at authoring time only. `--fps` can override `data-fps`, so keep the source of truth in the design document as a timecode, not a frame index.
- **Put SFX in their own group** (`data-audio-group="sfx"`), never in the voice group — a bed or an SFX clip inside the carve group silently poisons the next carve re-analysis.
- **`data-volume` is linear.** Default `1` = 0 dB, max `3.98` = +12 dB. A −13 dB effect is roughly `0.224`.
- **Do not both automate and tween `volume`** on one track: the lane wins and the tween is ignored (`audio_volume_double_automation`); a `data-volume` on a tweened track is replaced, not scaled.
- **Two `<audio>` sharing a `data-track-index` and overlapping in time raises `duplicate_audio_track`** — spread a dense action pass across track indices 12, 13, 14.
- **`reverb` and `delay` add `chainTailSeconds`**, so a treated effect renders longer than its `data-duration`. Expected, not a bug.
- **`compressor`, `limiter`, `gate` and `bitcrush` have no automatable parameters**, and `reverb.size`/`damping` are not automatable either — automate a `gain` stage around them instead.
- **Chain order is signal order**: subtract before you add, level after you filter, **limiter last**.
- **Nothing validates the chain.** Lint reads `data-automation` for exactly two conflicts; render refuses an unparseable chain outright while preview plays it dry. Verification is by listening ([[sfx-playback-verification-loop]]).
- **Escaping is load-bearing:** write these JSON attributes **double-quoted with `&quot;`**. `carve.mjs` finds them with a `name="..."` regex and a single-quoted attribute is invisible to it — it will silently overwrite work it could not see.
- If the video's own audio track is being used, the project convention is `<video muted>` plus a separate `<audio>` for its sound — the pattern to reach for when picture and sound are cut independently.

**ffmpeg — frame extraction for the inventory, and the transient measurement the whole pass depends on.**

```bash
# stills for the inventory
ffmpeg -ss 12.0 -to 20.0 -i shot.mp4 -vf fps=30 frames/%05d.png

# where is the loudest attack inside the file?
ffmpeg -i page-turn-a.wav -af "astats=metadata=1:reset=0.01,ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
# or detect onsets by silence boundaries
ffmpeg -i page-turn-a.wav -af "silencedetect=noise=-45dB:d=0.02" -f null - 2>&1 | grep silence_end

# trim the pre-roll off physically, if you prefer a head-aligned file
ffmpeg -i page-turn-a.wav -ss 0.104 -c:a pcm_s16le page-turn-a.trim.wav

# change an object's apparent size without a second file (pitch and length together)
ffmpeg -i mug.wav -af "asetrate=48000*0.92,aresample=48000" mug.heavy.wav

# check the level you actually placed
ffmpeg -i page-turn-a.wav -af "volumedetect" -f null - 2>&1 | grep max_volume
```
Note `.wav` output must use `pcm_s16le` — the video-centric aac/x264 set inside a `.wav` breaks timing entirely. For the size change you can also set `data-playback-rate="0.92"` in-composition and skip the file.

**Remotion.** `<Sequence from={contactFrame - Math.round(peakOffset*fps)}><Audio src={sfx} volume={0.224} /></Sequence>` — a `startFrom` prop is the conceptual analogue of `data-media-start`, and frame-native placement makes contact-frame alignment literal. Not a runtime in this project.

## Pairs with
[[sfx-real-vs-invented-sound-rule]] · [[sfx-reverb-glue]] · [[sfx-peak-on-impact-frame]] · [[sfx-layered-approach-and-impact]] · [[sfx-name-before-search]] · [[sfx-five-layers-build-order]] · [[sfx-ambience-search-formula]] · [[sfx-layer-volume-targets]] · [[cut-on-action]] · [[sfx-motion-sound-selection]] · [[sfx-envelope-matched-to-easing-curve]] · [[sfx-av-sync-binding-window]] · [[sfx-search-vocabulary]] · [[sfx-density-fatigue-audit]] · [[sfx-ambience-bridge-across-cut]] · [[sfx-placement-discipline]] · [[sfx-playback-verification-loop]] · [[sfx-sound-pass-order]] · [[sfx-three-types-classification]] · [[sfx-appearance-transient]]

## Failure modes
- **Placed by file head.** The most common error: the file's silent pre-roll pushes the attack 40–120 ms late — past the lag-detection threshold — and the whole pass feels loose. Fix: measure the transient offset and align that.
- **Placed early.** Sound leading picture is detected from about 45 ms — a single frame at 30 fps is already 33 ms, so a 2-frame early placement is over the detectability threshold and reads as a mistake in a way the same error late does not. Fix: target 0, err late.
- **Flam against production audio.** Two attacks 10–60 ms apart. Fix: mute the production moment or drop the library layer; never crossfade two attacks.
- **Sounding everything.** Full coverage of every background micro-event is the overload mistake and tires the viewer in two to three minutes. Fix: hero actions get full treatment; background actions get about 60 % coverage and sit 8 dB lower; 6 events per 10 s ceiling, pruned *before* fetching.
- **Keyword-chosen material.** A plastic click on a metal latch; a page-turn sound on a page that does not turn. Diegetic effects are constrained by plausibility — the wrong sound on a real object "just feels weird" ([[sfx-real-vs-invented-sound-rule]]). Fix: search material + action + perspective, and audition two candidates against picture.
- **One thin file on a heavy object.** No approach and no settle reads as a stock drop-in. Fix: two or three layers, capped at five.
- **Dry effects on an interior shot.** They sit on top of the picture instead of inside it. Fix: one reverb on the SFX bus fixes the whole pass at once.
- **Off-frame events mixed like on-frame ones.** Flattens the space. Fix: −6 dB and a low-pass at 3–5 kHz.
- **The same take repeated.** The most-named sound-design mistake in the source material, and numbered takes exist precisely to prevent it — there is no excuse when the shelf ships seven. Fix: two uses maximum per file, varied by pitch/duration/reverb, then a different file.
- **Known gap.** There is **no automatic waveform sync, no onset detection, and no drift correction** anywhere in this stack, and nothing builds the inventory or verifies sync. Alignment is authored by writing the same number on the picture and the sound. The transient offset must be measured with ffmpeg (which the contract lists as *assumed present but unverified* in this environment) or by eye, and the resulting seconds hand-entered. Budget the inventory as human/agent frame-stepping work, and record every row's contact timecode in the design document so the numbers survive a re-cut.
