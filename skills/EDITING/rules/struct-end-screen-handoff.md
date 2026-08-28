---
id: struct-end-screen-handoff
title: Close on unfinished business — hand off to the next video instead of summarising
skill: editing
type: retention
family: outro
tags: [skill/editing, type/retention, family/outro, engine/hyperframes, engine/epidemic, source/editing-kt, source/research, difficulty/low]
source:
  - video: "assets/videos/editing kt.mp4"
    timestamp: "00:14:22"
    quote: "There's a lot more that goes into keeping your audience hooked. Click here to watch a video about it."
research_refs:
  - https://support.google.com/youtube/answer/6388789?hl=en
  - https://alanspicer.com/youtube-end-screen-strategy-final-20-seconds-grow-channel/
  - https://gyre.pro/blog/how-to-create-high-converting-youtube-end-screens-tips-and-examples
  - https://www.nexlev.io/youtube-end-screen-tips
difficulty: low
detectable_from: transcript+video
---

# Close on unfinished business — hand off to the next video instead of summarising

## What it is
The outro does two things and neither is a summary. First it **declares the topic unfinished** — "there's a lot more that goes into this" — which reframes the video the viewer just finished as one chapter rather than a completed transaction. Second it **names one specific next watch** and points at it. A summary closes a loop; this opens one, at the exact moment the viewer is deciding whether their session continues. Structurally it is short, it is verbal as well as visual, and it lands on top of a YouTube end-screen window that has fixed, published mechanics: end screens run in **the last 5–20 seconds**, carry at most **four elements**, and require a video at least **25 seconds** long.

## When to use it
On any video that belongs to a body of work — a series, a topic cluster, a channel with a repeatable format. It is highest value where the current video *legitimately* has an adjacent unfinished question: this one covered the edit, the next one covers retention; this one covered the four pillars, the next one covers the ten cuts. Use it also whenever analytics show a healthy retention curve that simply ends — a video that holds 40% to the finish and generates no session continuation is losing its most valuable viewers at the cheapest possible moment to keep them. Do **not** use it on a standalone piece with no honest next step (a manufactured "there's more" that points at an unrelated video is worse than a clean ending), and do not use it in place of the mid-roll CTA — those are different moments with different jobs ([[struct-cta-after-payoff]]).

## How to recognise it in a reference video
- **Transcript, final 30 s.** Look for the two moves in order: an **incompleteness claim** ("there's a lot more", "this is only half of it", "I couldn't fit X in here") followed by a **deictic instruction** ("click here", "watch this next", "that video's right there"). Both present = this technique. Only the second = a generic outro.
- **Absence of a recap.** Check whether the final 30 s restates the video's points. A handoff outro does **not** recap; the incompleteness claim replaces the summary and does the opposite work.
- **Timing, measurable.** Log three timestamps: the last frame of substantive content, the first frame of the end-screen graphic, and the video's final frame. The published window is the last **5–20 s**; strong practice sits at **15–20 s** of end-screen dwell, and reported click volume is materially higher at the long end of that window than at 5–10 s.
- **The three-part shape.** In a well-built 20 s outro: **0–5 s** a final thought from the main content (not a recap — the last real beat); **5–12 s** the verbal CTA naming what to click and why; **12–20 s** end-screen elements visible with music and little or no speech.
- **Element count on screen.** Count clickable end-screen placeholders. Maximum is four; **two or three** is the practice that outperforms, and the highest-performing pair is *one video element plus subscribe*.
- **Verbal + visual, not visual alone.** A silent end screen is half the device. Check whether a spoken instruction accompanies the graphic — its presence is the strongest single signal separating a designed handoff from a default template.
- **Specificity of the pointer.** "Check out my other videos" is a weak handoff; "watch this next to see the thirty-day results" is a strong one. Log which.
- **Music behaviour.** The bed almost always continues under the end screen with no narration over it, often rising slightly as the voice ends. A silent end screen with no bed reads as the video breaking.
- **Layout.** End-screen elements sit inside YouTube's own safe zones and must not be covered by the video's own graphics or captions. If the reference's captions run under the elements, that is a design fault, not a style.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `outro_total` | 20 s (600 f) | 15–20 s | End screens are only permitted in the last 5–20 s. 15–20 s is where click volume concentrates. |
| `final_thought` | 5 s (150 f) | 3–7 s | A last real beat, not a recap. |
| `verbal_cta` | 7 s (210 f) | 5–9 s | Incompleteness claim + specific next watch + reason. |
| `silent_tail` | 8 s (240 f) | 5–10 s | Elements visible, music only, no speech. |
| `element_count` | 2 | 2–3 (max 4) | Video + subscribe is the strongest pair. Four is allowed and underperforms. |
| `element_in_offset` | 0 s from outro start | 0–3 s | Elements appear as the verbal CTA begins, not after it. |
| `recap_words` | 0 | 0 | Hard rule: no restatement of the video's points. |
| `pointer_specificity` | named outcome | — | Name the next video's *result*, not its title. |
| `bed_level_change` | +3 dB at handoff | 0 to +4 dB | Bed lifts as narration ends. |
| `min_video_length` | 25 s | — | Platform requirement for any end screen at all. |
| `ctr_target` | 4% | 2–7% healthy · 8%+ strong | End-screen click-through. Below 1% = wrong pick or no verbal CTA. |
| `reach_target` | 30% | — | Fraction of viewers reaching the end screen. Below 25–30%, fix retention first — the outro cannot help. |

## Reproduction prompt

```
Build the closing handoff for a video at 30fps whose total runtime is {{RUNTIME}} seconds.

1. GATE. If {{RUNTIME}} < 25 s, no end screen is possible - stop and write a spoken-only close.
   If the audience-retention curve shows under 25% of viewers reaching {{RUNTIME}} - 20, note in
   the design document that outro optimisation is not the bottleneck and fix retention first.

2. RESERVE THE WINDOW. The outro occupies the final 600 f (20.0 s), i.e. composition seconds
   {{RUNTIME}} - 20.0 to {{RUNTIME}}. Nothing that the viewer must read or hear to understand
   the video may live inside it.

3. WRITE THE THREE BEATS, in this order and these lengths:
   a) 0-150 f (0.0-5.0 s): the FINAL THOUGHT. One or two sentences that land the video's last
      real beat. This is NOT a recap - do not restate the numbered points, do not say "so those
      were the ...". If a recap already exists in the script, delete it.
   b) 150-360 f (5.0-12.0 s): the HANDOFF. Exactly three clauses, in order:
        i.  the incompleteness claim - name a real thing this video did NOT cover;
        ii. the pointer - "click here" / "that one's right there", with a physical gesture or a
            look toward where the element sits;
        iii.the reason - what the viewer GETS from the next video, phrased as an outcome, not a
            title.
      Total 25-45 spoken words. If you cannot name a genuine uncovered thing, do not fake one -
      cut straight to a plain sign-off instead.
   c) 360-600 f (12.0-20.0 s): the TAIL. No speech. Music bed only, lifted 3 dB. End-screen
      elements visible and unobstructed.

4. LAYOUT. Leave the end-screen safe zones empty for the whole 600 f: no captions, no lower
   thirds, no logo bug, no graphics inside the element footprints. Design exactly 2 elements -
   one specific video (the one the handoff names) plus subscribe. Do not use all four slots.

5. SOUND. Music continues unbroken from the body into the outro; do not stop and restart it.
   Lift the bed 3 dB at the first frame of the tail. No whoosh, no sting, no riser anywhere in
   the outro - there is nothing left to anticipate.

6. ACCEPTANCE TEST: (a) read the outro transcript alone - it must contain zero restatements of
   the body's points and exactly one named next watch with a stated benefit; (b) mute the video
   and confirm the element footprints are clear of your own graphics for all 600 f; (c) the last
   240 f contain no speech; (d) the named next video must actually exist and actually cover the
   thing the incompleteness claim named. If it does not, change the claim, not the video.
```

## Execution spec

**HyperFrames (primary).** The outro is a sub-composition hosted at the end of the root timeline. Two things make it different from any other scene: it is the **only** scene permitted an exit animation, and it must keep large regions of frame empty.

```html
<!-- root: outro slot occupying the final 20s of a 754s video -->
<div id="el-outro" class="clip"
     data-composition-id="outro" data-composition-src="compositions/outro.html"
     data-start="734.00" data-duration="20.00" data-track-index="2"></div>
```

- **Root `data-duration` is compile-time-locked** and cannot be changed by `--variables` or by a script. So the outro's placement is derived from a runtime you must already know — build the outro last, after the body length is final, and re-author `data-start` if the body changes.
- **The final scene is the one exception to the exit-animation ban.** Everywhere else *"the transition IS the exit"* and exits are banned; the last scene may fade out. Use it sparingly: a fade under the end screen makes the elements harder to read.
- **The tail must hold a still frame.** The half-open window means a clip is hidden at exactly `start + duration`; land every tween's end state **before** the sub-comp's `data-duration` or its last frame never renders. A tween that resolves exactly on the boundary produces a black final frame — extremely visible here.
- **Keep the element footprints empty with real geometry, not by hope.** Author the end-screen safe zones as absolutely-positioned empty boxes in the outro composition and check nothing overlaps them. If captions are running, the caption sub-comp must be excluded from this window entirely (drop it, or give the caption host a `data-duration` that ends before the outro starts). `data-layout-allow-caption-zone` opts a lower-third out of the caption-zone audit — it does **not** make the region safe for end-screen elements; that is a YouTube-side overlay this project cannot see.
- **Music continuity.** Keep the bed at the **host root** so it survives the scene cut into the outro — that is the documented reason for the "audio at root" rule in modular projects. The +3 dB lift is a `volume` automation lane on the bed, `t` in **clip-local seconds**:
  ```
  {"target":"volume","points":[{"t":0,"v":0.6},{"t":746,"v":0.6},{"t":746.5,"v":0.85},{"t":754,"v":0.85}]}
  ```
  +3 dB from 0.6 is ×1.41 ≈ 0.85. Remember the lane holds its first value backwards to the clip start, so the explicit `t:0` point is required.
- **Voiceover carve stays on.** The bed keeps its `data-fx-carve` against the `voiceover` group through the handoff beat and simply has nothing to carve against in the tail, where the voice track is empty. Do not remove the carve for the outro.
- **`data-composition-variables`** on `<html>` is the clean way to make the named next video swappable across renders (`{id:"next_title", type:"string", ...}` read via `window.__hyperframes.getVariables()`, overridden with `--variables '{"next_title":"…"}'`). The root duration is **not** variable this way.

**ffmpeg.** Only if the outro is assembled outside the composition: `ffmpeg -f concat -safe 0 -i list.txt -c copy out.mp4`. Do not use `-c copy` to trim the body to a new length for the outro — keyframe snapping can silently swallow the cut.

**Epidemic Sound.** The outro rarely needs a new track; continuing the body's bed is stronger. Where the outro genuinely needs its own bed, `EditRecording` produces a length-exact version: `EditRecording({ id: "<uuid>", input: { targetDurationMs: 20000, forceDuration: true, loopable: false, downloadAudioFormat: "WAV" } })`, then poll with `PollEditRecordingJob`. That is the sanctioned way to get a track that ends *on* the last frame instead of being faded out mid-phrase.

**Remotion:** a final `<Sequence>` of `20 * fps` frames with the elements laid out inside safe-zone constants; concept only.

## Pairs with
[[struct-cta-after-payoff]] · [[struct-comment-prompt-curiosity-gap]] · [[struct-demand-hook-competence-gap]] · [[struct-enumerated-promise-and-counter]] · [[struct-music-arc-to-narrative-arc]] · [[sfx-music-sets-the-mood]] · [[struct-scope-refusal-deflection]] · [[struct-stimulation-budget]]

## Failure modes
- **Recapping first.** A summary tells the viewer the transaction is complete, which is the exact opposite of the handoff's job, and it eats the 20 s the elements need. Correction: delete the recap; the incompleteness claim is the summary's replacement.
- **A fake incompleteness claim.** "There's so much more" pointing at an unrelated video trains the audience to distrust the close. Correction: name a real uncovered thing, and point at the video that covers it.
- **Naming a title instead of an outcome.** "Watch my video on sound design" converts far worse than "watch this to hear what those five layers sound like stacked". Correction: state the benefit.
- **Elements under your own graphics.** A logo bug or a caption line sitting on top of an end-screen element makes it unclickable and invisible. Correction: reserve the footprints as empty geometry for the whole 600 f.
- **Silent end screen.** The graphic appears with no spoken instruction and click-through collapses. Correction: the verbal CTA is the device; the graphic is its target.
- **All four elements.** More choices, fewer clicks. Correction: two, occasionally three.
- **Music stopping when the voice stops.** An 8-second silent tail reads as a technical fault and viewers close the tab. Correction: bed continues and lifts.
- **Optimising the outro when nobody reaches it.** Below ~25–30% reach the outro is not the constraint. Correction: fix the body's retention shape first ([[pace-visual-change-clock]], [[struct-stimulation-budget]]).
- **Known gap:** end-screen elements are rendered by YouTube, not by this stack. HyperFrames can only reserve the space and can neither verify the footprints nor preview the overlay. The safe-zone geometry must be taken from the platform's current spec at build time and checked on the published video, off this VM.
