---
name: visual-kt-delta
description: Findings from actually looking at all five reference videos — additive to, and in two places corrective of, the transcript-derived KT.
type: reference
method: "6x5 contact sheets, 30 frames sampled evenly across full duration, all five read directly"
observed: 2026-08-27
coverage: complete
---

# Visual KT delta

Everything before this file came from transcripts. Transcripts cannot see on-screen text, teaching graphics, tool UI or shot grammar. All five contact sheets have now been read, and the result **corrects two transcript-derived conclusions** and adds a large amount of directly actionable detail.

## Provenance — the set is three creators, not five

| Video | Creator | Evidence |
|---|---|---|
| `sfx kt 1`, `sfx kt 2`, `editing kt 3` | **Creator A** (Hinglish) | Identical set: brown jacket over black tee, teal/cyan practicals, monitor with mountain wallpaper, boom mic. Same two-hander skit device with a sunglasses-and-plaid "wrong way" character under red light. |
| `editing kt` | Creator B (English) | HURLEY tee, dark room, warm practicals, different graphic language entirely. |
| `editing kt 2` | Creator C (English) | Green tee, clean bright room, film-clip-and-timeline teaching format. |

This matters: **the Hinglish trio is one coherent house style** and can be profiled as a single target. The two English videos are craft references, not style references.

---

## Corrections to earlier conclusions

### 1. Ducking *is* demonstrated — it is just never named

The `editing-kt-3` delta pass concluded "ducking is never taught… no automation, keyframing or sidechain anywhere." The screen recording contradicts this: a Premiere audio clip is visible with a **keyframed volume ramp** — the rubber-band line with a keyframe diamond at the playhead — and a separate frame shows a **red-highlighted region on the music track** where the level is pulled down. So the technique is *shown* while the narration only describes a static floor plus full drop-outs.

Treat it as **demonstrated but unnamed**. The library should carry a proper ducking note, credited to visual observation rather than to a quote.

### 2. Captions are romanised Hinglish, not Devanagari

`sfx kt 1` burns in captions like `parr naam kya search karu??` — **Latin script**, not Devanagari. The subtitles library was briefed to solve script fallback and Devanagari line-height. The real requirement is romanised Hindi set in a Latin face: no script fallback needed, but nothing may "autocorrect" the romanisation, and word-boundary logic must tolerate non-dictionary tokens.

---

## Epidemic Sound — the actual filter taxonomy, read off screen

`editing kt 3` shows the Epidemic UI with its filter bar legible:

```
Moods | Genres | Duration | BPM | Vocals | Key
```

and the Vocals facet expanded showing real counts — **`Vocals 291` / `Instrumentals 2529`**. `editing kt` independently shows the music search with `anticipation` typed into the query box and a results list carrying a **BPM column** (91, 114, 90, 120, 80) alongside genre tags (Chill, Dance, Electronic, Ambient).

This is directly actionable for every fetch recipe in `skills/SOUND-DESIGN/rules/`: the queries should be expressed against these six facets rather than as free text alone, and the vocals/instrumental decision is a *filter*, not a judgement call. The creator's own workflow is: mood or term in the query box, then narrow by BPM and Vocals.

## Confirmed hard numbers

**Dialogue level `−3 to 0 dB` is now confirmed twice, visually, in two different videos:**

- `sfx kt 2` — full-frame title card `DIALOGUES / 0 to -3dB` cut against a Premiere audio meter showing green levels.
- `editing kt 3` — title card `Vocals Vol / −3 to 0dB` with a waveform glyph, again beside a meter.

The earlier delta pass had flagged this number as single-source and approximately placed, because the improved transcripts dropped it. It is not approximate. It is the creator's stated standard, put on screen twice.

## Tools demonstrated but never named in narration

| Tool | Where | What it is used for |
|---|---|---|
| **Premiere Essential Sound panel** | `sfx kt 1` | Reverb/space presets, dropdown legible: `Default`, `Explosion`, `From Outside`, `From the Left`, `In a Large Room`, `Make Close Up`, `Make Distant`, `Make Medium Shot`. This sharpens the vague "reverb" modifier into a named preset list for placing an effect in a space. |
| **Epidemic Sound panel inside Premiere** | `sfx kt 1` | The creator fetches from Epidemic without leaving the NLE. |
| **ChatGPT** | `sfx kt 1` | Prompt visible: *"Give me the names of funny sound effects to use in videos."* The video's premise is "I don't know the names of any sound effects" — and this is the creator's own answer. The naming problem is a retrieval problem. |
| **ElevenLabs-style TTS** | `editing kt 3` | Panel with voice `Benjamin`, language, speed, and a Create button. AI voiceover is in the workflow. |
| **Premiere Hue/Saturation Curves** | `editing kt 3` | Grading, off-topic for the music segment but part of the creator's toolkit. |

---

## Graphic vocabulary, per creator

### Creator A (the Hinglish house style) — abstract diagram cards on dark ground

The strongest reusable pattern in the set. Each concept gets a full-frame card on a dark teal/navy ground with a muted cyan accent:

- **`The Composition of a Video`** — a 50/50 pie chart labelled `Sound` / `Visuals` with thin leader lines. The "sound is half the video" claim, visualised.
- **`Music`** — a circular arc with diamond nodes at the cardinal points and a waveform drawn inside it.
- **Isolated waveform** in a rounded rectangle.
- **Title cards in a handwritten/script face** — `Instruments`, with a small orange sub-label `Suspense/Tension` beneath, tying an instrument to an emotion.
- **Left-aligned labels over live action** — `Low Quality SFX`, `Metal Hit` / `Wood Hit` stacked.
- **Full-frame word cards on black** — `Whistle` — as a marker before demonstrating a sound.
- **Location lower-third** — `YAAS Office, Bangalore`.
- **Handwritten signature sign-off** on black.
- **Cold open on a YouTube comment screenshot** — `editing kt 3` opens on the request that motivated the video.
- **Inline video-reference cards** at frame right (`SOUND LIKE A PRO!`, `Use Music Like a PRO`).
- Screen recordings carry a **circular webcam PiP** bottom-left.

Each of the five sound layers plausibly gets its own card in this system — worth a MOTION blueprint: *layer title in script face + abstract audio visual + dark ground + single cyan accent*.

### Creator B (`editing kt`) — red negation and flat doodles

- **Red strikethrough as the signature rhetorical device**: `S̶T̶IMULATING`, `captions just to ~~jack up the visual variety~~`, and `BORING` stamped in red across a YouTube analytics screenshot. Struck-through or red-overlaid text = a claim being negated. Consistent enough to be a caption rule, not a one-off.
- **Hand-drawn white curved arrows** annotating B-roll, with a caps label — `RECORDING B-ROLL`.
- **Flat vector doodle illustrations** — a cartoon face on mint green, a filmstrip-and-scissors icon in outline style on a purple/blue gradient — intercut with dense screen recordings.
- **Analytics-as-proof**: YouTube Studio screenshots with real figures (239,516 views, 14.9K, +6.5K, $916.71).
- **Premiere Effect Controls** open with Position and Scale keyframes visible — the punch-in mechanics shown rather than described.

### Creator C (`editing kt 2`) — the timeline overlay, and the best find in the set

Every film-clip example carries a **stylised NLE timeline overlaid across the bottom of the frame**: coloured clip bars (green picture, blue/purple/cyan audio), real waveforms drawn inside them, and a playhead tracking the clip as it plays. The viewer sees the edit and its timeline at the same time. This is a reusable explainer blueprint, not just a note.

- **J Cut and L Cut are taught with a two-track offset diagram** — a green picture bar and a blue audio bar visibly staggered, waveform showing. Ground truth for the audio-leads-picture mechanic, and it confirms the offset is presented as a *track-level relationship*, not a transition effect.
- **Filmstrip motif** — a sequence rendered as four perforated frames in a row, used for the movement match cut so the matched shape is visible across the cut in one static graphic.
- **Title cards whose type treatment matches the content** — `Movement Match Cut`, `J Cut`, `L Cut`, `IN POINT` in clean type; `SMASH CUT` in a rough eroded chalk face. The typeface is doing semantic work.
- **Attribution convention** — every film clip labelled top-left in small italic serif: *The Departed*, *Forrest Gump*, *The Wolf of Wall Street*, *The Shawshank Redemption*, *Reacher*. Clips are letterboxed and inset on a dark ground rather than filling frame.

---

## What this changes, by library

| Library | Action |
|---|---|
| **Sound design** | Rewrite fetch recipes against the six real Epidemic facets (Moods, Genres, Duration, BPM, Vocals, Key). Add the Premiere Essential Sound **space presets** as a named modification technique. Add a **ducking** note credited to visual observation. Add **LLM-as-SFX-vocabulary** for the naming problem. The `−3 to 0 dB` dialogue target is confirmed, not provisional. |
| **Motion** | Add blueprints for the **timeline-overlay explainer**, the **abstract layer card** system, the **filmstrip comparison** graphic, **hand-drawn arrow annotation**, the **attribution label** convention, and **title cards whose type matches content**. |
| **Subtitles** | Switch the Hinglish requirement from Devanagari fallback to **romanised Hindi in a Latin face**. Add **red strikethrough as negation** as a caption emphasis rule. |
| **Editing** | The J/L two-track diagram confirms the track-offset model the notes assume. Add the **YouTube-comment cold open** and **analytics-as-proof** as structural devices. |

## Method note

Contact sheets were generated on the device, since ffmpeg is available there and the cloud container has only two cores:

```bash
ffmpeg -i "<video>" -vf "fps=1/<duration/30>,scale=300:-1,tile=6x5" -frames:v 1 "<name>-sheet.png"
```

30 frames across a 10-minute video is one frame per 20s — enough to read format, graphic vocabulary and recurring devices, **not** enough to measure cut rhythm or motion timing. Those still require dense sampling around specific events, per the ANALYSE stage in `pipeline.md`.
