---
id: sub-speaker-and-non-speech-annotation
title: Identify the speaker with a dash and a name, annotate sound in brackets — and know which text is not transcript
skill: subtitles
type: caption-style
family: accessibility
tags: [skill/subtitles, type/caption-style, family/accessibility, engine/hyperframes, source/research, source/sfx-kt-1, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: n/a
    quote: "Same two-hander skit device with a sunglasses-and-plaid \"wrong way\" character under red light."
  - video: "HyperFrames repo"
    timestamp: n/a
    quote: "compositions/captions.html — One box, one span, reused for every line. Nothing is created or destroyed."
research_refs:
  - https://en.wikipedia.org/wiki/Closed_captioning
  - https://www.w3.org/WAI/media/av/captions/
  - https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-Timed-Text-Style-Guide
  - https://dcmp.org/learn/601-captioning-key---presentation-rate
difficulty: medium
detectable_from: transcript+video
---

# Identify the speaker with a dash and a name, annotate sound in brackets — and know which text is not transcript

## What it is

Two conventions that together are the difference between a **subtitle track** and a **caption track**. In North American usage, subtitles transcribe dialogue for a viewer who can hear; captions describe *all* significant audio — who is speaking, what non-speech sound is present, what the music is doing — for a viewer who cannot. A WCAG 1.2.2 obligation is for the second, and it is why an accessibility deliverable cannot just be the dialogue.

**Speaker identification.** The convention set that has survived across broadcast and streaming:

- A **hyphen or en-dash prefix** on each line when two speakers appear in one cue: `-What are you--` / `-Be quiet!`
- A **name prefix** when the speaker is off screen, newly introduced, or otherwise not visually obvious: `ROHIT: ...` or `-Rohit: ...`
- **No identification at all** when a single visible speaker is talking, which is the majority case in a talking-head video. Adding a name to every cue is noise.
- In WebVTT, the machine-readable form is the voice tag: `<v Rohit>...</v>`.

The rule for when to identify is positional rather than stylistic: **identify when the viewer cannot tell from the picture.** Off-screen speech, a cut away from the speaker, a new voice, and overlapping dialogue are the four triggers.

This matters concretely for this user's reference material, because Creator A's format is a **two-hander skit**: a presenter and a "wrong way" character in sunglasses under red light. That is exactly the case where speaker identification earns its place — two voices, sometimes off screen, deliberately contrasted — and where the visual contrast (the red light, the costume) already does half the job, so a dash is usually enough and a name is usually too much.

**Non-speech annotation.** Sound that carries meaning gets bracketed: `[keyboard clatter]`, `[record scratch]`, `[music swells]`. The judgement of which sounds qualify is, in W3C's own framing, *"more art than science"* — but the test that works is **narrative relevance**: annotate a sound if a hearing viewer's understanding would change without it. A door closing that reveals someone left: annotate. Ambient room tone: do not.

**The critical structural point for this library:** annotations are the **only caption text that is not transcript**. Everything else in this skill is governed by the verbatim non-negotiable and by [[sub-orthography-protection-no-autocorrect]]. An annotation is authored. It therefore needs its own visual treatment so the viewer can tell the difference, and it needs to be excluded from any verbatim byte-diff verification — otherwise the diff fails on every annotation and gets disabled, taking the real protection with it.

## When to use it

- **Speaker ID:** on any deliverable with more than one speaking voice, and specifically on the two-hander skit format. Skip it entirely for a single-presenter video.
- **Non-speech annotation:** on any deliverable with an accessibility obligation. Also worth doing on a muted-first feed video where a sound effect is doing narrative work the muted viewer would otherwise miss — this is the one case where an annotation earns its place in a burned-in emphasis track rather than only in a closed one.
- Both belong primarily in the **closed** track ([[sub-open-vs-closed-captions]]). A burned-in emphasis layer of three words at a time cannot carry them, and should not try.

## How to recognise it in a reference video

| Signal | Method | Reading |
|---|---|---|
| Dash prefix | Look for `-` at line start | Two speakers in one cue |
| Name prefix | `NAME:` or `-Name:` | Off-screen or newly introduced speaker |
| ID frequency | % of cues carrying an ID | 100 % on a single-speaker video = noise. 0 % on a two-hander with off-screen lines = a gap. |
| Brackets | `[...]` or `(...)` | Non-speech annotation present. Square brackets are the dominant convention. |
| Annotation styling | Compare an annotation's treatment to a speech cue | Italic or a distinct colour = the author distinguished authored text from transcript. Identical = they did not. |
| Annotation density | Annotations per minute | 1–4 in a sound-designed piece. 10+ and it is describing the ambience. |
| Music annotation | `[music swells]` vs a lyric transcription | Both are valid; a lyric transcription is a much heavier commitment. |
| Two-hander marking | Is the second character distinguished by anything other than a dash? | Position, colour or the picture itself may already carry it |
| Off-screen lines | Play with the picture hidden | Any line whose speaker is ambiguous needed an ID |

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `speaker_id_trigger` | viewer cannot tell from picture | — | Off screen, a cut away, a new voice, overlapping dialogue. |
| `single_speaker_visible` | no ID | no ID | Naming every cue in a talking head is noise. |
| `two_speaker_one_cue` | dash prefix per line | `-` | `-What are you--` / `-Be quiet!` |
| `off_screen_speaker` | name prefix | `NAME:` / `-Name:` | Once on introduction, then dash only. |
| `name_case` | as written | upper / as-written | Pick one and hold it. Caps names are a broadcast habit; sentence case reads lighter. |
| `vtt_form` | `<v Name>` | — | The machine-readable voice tag in WebVTT. |
| `id_frequency_ceiling` | 30 % of cues | ≤40 % | Above this the IDs are the track. |
| `annotation_brackets` | `[ ]` | `[ ]` | Square brackets are the dominant convention; parentheses are a distant second. |
| `annotation_trigger` | narrative relevance | — | Would a hearing viewer understand differently without it? |
| `annotation_density` | 2 / min | 1–4 | Above ~6 it is describing the room, not the story. |
| `annotation_styling` | italic, or `--cap-dim` | distinct | It is authored text, not transcript. Mark it visually. |
| `annotation_case` | sentence | sentence / upper | `[keyboard clatter]` reads better than `[KEYBOARD CLATTER]`. |
| `music_convention` | `[music: tense]` | descriptive / lyric | Lyric transcription is a much larger commitment; decide once. |
| `excluded_from_verbatim_diff` | yes | yes | Annotations are authored. Exclude them from the byte-diff or the diff gets disabled. |
| `annotation_in_open_track` | rarely | rare | Only when a sound effect does narrative work a muted viewer would miss. |
| `annotation_own_cue` | yes | yes / inline | An annotation on its own cue is clearer than one prefixed to speech. |
| `reading_rate_includes_annotations` | yes | — | They are characters the viewer must read; count them against the cap. |

## Reproduction prompt

```
Specify speaker identification and non-speech annotation for the caption tracks
in {{PROJECT}}, which has {{N}} speaking voices and {{sound design}}.

SPEAKER IDENTIFICATION. Identify a speaker only when the viewer cannot tell from
the picture. The four triggers: the speaker is off screen; the picture has cut
away; a new voice appears; two people speak inside one cue. A single visible
speaker gets NO identification — naming every cue in a talking-head video is pure
noise.

Use a dash prefix per line when two speakers share a cue ("-What are you--" /
"-Be quiet!"). Use a name prefix on first introduction and for off-screen lines,
then drop back to dashes. In WebVTT use the voice tag <v Name>. Cap
identification at about 30% of cues.

NON-SPEECH ANNOTATION. Bracket a sound if a hearing viewer's understanding would
CHANGE without it. Annotate a door closing that reveals someone left; do not
annotate room tone. Target 2 per minute, ceiling 6.

Give each annotation its own cue and style it distinctly from speech — italic, or
the dim token. This is the ONLY caption text that is not transcript: it is
authored, and the viewer should be able to tell. Because it is authored, exclude
annotations from the verbatim byte-diff — otherwise the diff fails on every one
and somebody disables it, taking the orthography protection with it. Count
annotation characters against the rate cap.

Acceptance test: play with the picture hidden — every line's speaker must be
unambiguous and every plot-relevant sound present. Then confirm the verbatim diff
excludes bracketed annotations and still passes on everything else.
```

## Execution spec

Annotations and speaker IDs are authored text, so they enter the pipeline at a different point from the transcript and must stay distinguishable from it.

```js
// Two kinds of cue, tagged at build time.
const cues = [
  { kind: "speech",     speaker: "rohit", text: "parr naam kya search karu??", start: 12.34, end: 14.02 },
  { kind: "annotation", text: "[keyboard clatter]",                             start: 14.10, end: 15.60 },
];
```

```css
[data-composition-id="captions"] .caption-text--annotation {
  font-style: italic;
  color: var(--cap-dim);
}
[data-composition-id="captions"] .caption-text--speaker::before {
  content: "-";               /* the dash is presentation, not transcript */
}
```

Putting the dash in `::before` rather than in the string is deliberate: it keeps the stored string byte-identical to the transcript, so the verbatim diff has a clean reference. The same argument applies to `text-transform` for case ([[sub-weight-case-and-optical-size]]).

Further stack notes:

- **The staged single-span model cannot style two cue kinds differently**, because it reuses one element and writes `textContent`. Annotations therefore force either a class toggle on the shared span — workable — or the per-cue element model, which is also the seek-robust fix for the known fragility that a backwards seek does not restore text set in `onStart`.
- **`npx hyperframes transcribe` emits speech only.** It does not diarise and it does not detect non-speech audio. Speaker labels and annotations are authored by hand and merged into the cue list. Any diarisation is a separate step outside this stack.
- **The sound-design pass is where annotations come from.** The SFX manifest ([[motion-sfx-pass-manifest]]) already lists every placed effect with a timestamp; that list is the candidate set for annotation, filtered by narrative relevance. Deriving annotations from the manifest rather than by re-listening is both cheaper and more complete.
- **Annotations count against the reading rate** and against the line budget, so a cue carrying one is subject to the same caps as a speech cue.
- **The closed track is where these mostly live.** In a burned-in emphasis layer of three words at a time, an annotation is usually the wrong object — a sound-effect graphic or the sound itself does the job better.

## Pairs with

- [[sub-open-vs-closed-captions]] — the track these mostly belong to
- [[sub-caption-contrast-accessibility]] — the other half of caption accessibility
- [[sub-orthography-protection-no-autocorrect]] — annotations are the exception to verbatim
- [[sub-caption-role-decision]] — a WCAG-A role pulls these into scope
- [[sub-verbatim-misspeak-correction]] — speaker marking for the corrector character
- [[sub-hinglish-reading-rate]] — annotations count against the cap
- [[motion-sfx-pass-manifest]] — the source list for annotation candidates
- [[sfx-alter-ego-objection-cutaway]] — the two-hander device that needs speaker ID
- [[sfx-three-types-classification]] — which sounds are narratively relevant

## Failure modes

- **Naming the speaker on every cue.** In a single-presenter video this is pure noise and it eats a third of the line budget.
- **No identification on a two-hander with off-screen lines.** The viewer cannot tell who is objecting, which is the entire joke in the alter-ego format.
- **Annotating ambience.** `[room tone]`, `[breathing]`, `[music continues]` on every cue. It describes the room and buries the sounds that matter.
- **Styling annotations identically to speech.** The viewer cannot tell authored text from transcript, and neither can the verbatim diff.
- **Including annotations in the verbatim byte-diff.** It fails on every one, somebody disables the diff, and the real orthography protection goes with it.
- **The dash in the string.** Breaks the verbatim reference. Put it in `::before`.
- **Forgetting annotations count against the reading rate.** `[keyboard clatter]` is 18 characters the viewer has to read.
- **Expecting the ASR to diarise.** `transcribe` emits speech only. Speaker labels are authored.
- **Annotations in a three-word burned-in emphasis layer.** Wrong object for the job; the sound itself or a graphic does it better.
- **Transcribing lyrics without deciding to.** It is a much larger commitment than `[music: tense]` and it changes the reading-rate profile of the whole track.
