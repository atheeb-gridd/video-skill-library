---
id: sfx-beat-forward-bed-under-voice
title: Beat-forward beds sit under a voice — pads, leads and vocals fight it
skill: sound-design
type: music
family: bed-selection
tags: [skill/sound-design, type/music, family/bed-selection, engine/epidemic, engine/hyperframes, engine/ffmpeg, layer/music, layer/dialogue, source/editing-kt-3, source/research, difficulty/medium]
source:
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:02:51"
    quote: "Music that has beats in it sits really well underneath the voice."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:02:54"
    quote: "So you can search for music by instrument too. I just go into Epidemic Sound, apply the instrument filter, and pick the music right from there."
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:05:13"
    quote: "After that, the next problem that comes up is audio levels. In some places the music is so loud that your voice gets lost in the middle of it."
research_refs:
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://en.wikipedia.org/wiki/Voice_frequency
  - https://en.wikipedia.org/wiki/Cocktail_party_effect
  - https://blog.prosoundeffects.com/sound-layering
  - mcp://Epidemic_sounds/SearchRecordings (instrument / vocals / BPM filters and stem availability verified live, 2026-08-27)
difficulty: medium
detectable_from: audio
---

# Beat-forward beds sit under a voice — pads, leads and vocals fight it

## What it is
When choosing a bed for voice-led content, the track's **identity** matters more than its mood: a track whose character lives in drums and bass supports narration, while a track whose character lives in a sustained pad, a lead melody or a vocal competes with it. The reason is masking. Speech intelligibility is carried by the **300 Hz–3.4 kHz** band — the band telephony was designed around — and anything with continuous energy there is a steady masker sitting on the words. Percussion is temporally sparse: its energy arrives in short transients with audible gaps between them, and the listener hears the voice through those gaps. Sustained material offers no gaps.

Two further mechanisms make the difference bigger than it looks on a meter. Masking spreads **upward in frequency as the masker gets louder**, so a bed pushed a couple of dB hot does disproportionate damage to consonants — the high-frequency detail that makes words distinguishable. And a bed with vocals in it adds informational masking on top of energetic masking: two voices in the same band, both centred in the mix, and the ear has no spatial or spectral cue to separate them.

The practical form of the rule: pick beat-forward tracks, and when a track is right except for its melodic content, **fetch only its drum and bass stems.**

## When to use it
- **Every bed under narration.** This is the default selection filter, applied before mood and before BPM auditioning.
- **Especially at high speech density** — fast delivery, dense information, numbers and names. The more the viewer has to catch, the less sustained mid-band content the bed may carry.
- **Relax it where there is no voice:** montages, transformation sequences, cold opens, end cards. There a pad or a vocal track is not just allowed but usually better — see [[sfx-vocal-vs-instrumental-bed]] and [[sfx-vocal-track-for-narration-free-montage]].
- **Override it for a deliberate emotional beat** — a slow, serious 6–10 s stretch where the pad is the point and the voice is sparse. Then drop the bed 3 dB further and keep it short.

## How to recognise it in a reference video
- **Crest factor is the measurable proxy.** Beat-forward material has a high peak-to-RMS ratio; sustained material has a low one. On the isolated bed (or on a music-only stretch between lines):
  `ffmpeg -i bed.wav -af astats=metadata=1:reset=0 -f null - 2>&1 | grep -E "Peak level|RMS level"`
  Peak minus RMS of **≥ 12 dB** reads as percussive/beat-forward; **≤ 8 dB** reads as pad- or lead-forward; 8–12 dB is mixed.
- **Look at the mid-band over time.** Band-pass the bed to the voice band and check whether it is continuous or gapped:
  `ffmpeg -i bed.wav -af "highpass=f=300,lowpass=f=3400,astats=metadata=1:reset=0.25" -f null -`
  Per-quarter-second RMS that swings ≥6 dB is gapped (good under voice); a flat line is a steady masker.
- **Listen for a lead instrument in the voice's octave.** A melody sitting between roughly **200 Hz and 1 kHz** — piano mid-register, strings, brass pads, sung vocals — is the classic conflict. Above ~5 kHz (shakers, hats, bells) and below ~150 Hz (sub, kick) are effectively free.
- **Check the level relationship.** In competent voice-led work the bed sits **−20 to −25 dB** relative to dialogue at 0 to −3 dB, and the number is *lower* for denser tracks — down to −30 dB for loud guitars ([[sfx-loud-guitar-minus-30]]).
- **Look for carving rather than ducking.** If the bed's low end and top stay full while its 1–4 kHz content dips only while words are present, the mix has been carved, not ducked; that is the mark of the more advanced pass.
- **Vocal check on the transcript.** If the bed has vocals and the presenter is speaking, note it as a defect regardless of how good the track is.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Bed identity | drums + bass forward | — | The filterable proxy is the featured-instrument filter, not the genre. |
| Crest factor target | ≥ 12 dB | 10–18 dB | Peak minus RMS on the bed alone. |
| Vocals | none | — | `vocals: false`. Verify the returned tag list; the filter is not airtight. |
| Bed level vs dialogue | −22 dB (`data-volume="0.079"`) | −20 to −25 dB (`0.1`–`0.056`) | −30 dB (`0.032`) for dense rock/guitar. |
| Carve `strength` | 0.25 | 0.20–0.35 | Default = ~6 dB dip in three bands. At 0.5 the dip reaches 10 dB and is heard as an effect. |
| Corrective cut if needed | peaking 1.6 kHz, −3 dB, Q 1.4 | 1.2–3 kHz, −2 to −5 dB | Only when the carve alone is not enough; the carve already writes bands here. |
| Mud cut on the bed | peaking 250 Hz, −3 dB, Q 1.2 | 200–320 Hz, −2 to −4 dB | The "Reduce Mud" job. Cheap clarity that costs the bed almost nothing. |
| BPM | 100–120 | match speech rate | See [[sfx-bpm-filter-first]] and [[pace-speech-rate-to-bpm-map]]. |
| Stem fallback | DRUMS + BASS only | — | Use when the track is right and the melody is the problem. |

## Reproduction prompt

```
Choose and place the music bed that runs under narration from {{T_IN}} to
{{T_OUT}}. Select on identity first, mood second.

1. FILTER BEFORE YOU LISTEN.
     SearchRecordings {
       query:  { term: "<mood word> underscore" },
       filter: { vocals: false,
                 bpm: { min: {{BPM_MIN}}, max: {{BPM_MAX}} },
                 featuredInstrumentSlugs: { matchType: ANY,
                   values: ["drums","electronic-drums","percussion"] } },
       first: 12 }
   READ THE RETURNED TAGS on each hit. Discard anything tagged "vocal presence"
   even though vocals:false was set - the filter leaks.
2. MEASURE, DO NOT GUESS. For each of the top 3, download the mp3 preview and
   compute crest factor:
     ffmpeg -i cand.mp3 -af astats=metadata=1:reset=0 -f null - 2>&1 \
       | grep -E "Peak level|RMS level"
   Keep candidates with (Peak - RMS) >= 12 dB. Discard <= 8 dB.
3. AUDITION AGAINST THE ACTUAL CUT at final level, never in isolation.
4. IF THE TRACK IS RIGHT BUT THE MELODY FIGHTS: fetch stems instead of the mix.
     DownloadRecording { id:<recordingId>, options:{ fileType: WAV, stemType: DRUMS } }
     DownloadRecording { id:<recordingId>, options:{ fileType: WAV, stemType: BASS } }
   Place them as two clips sharing data-start and the same audio group. This is
   the executable form of "music with beats sits under the voice".
5. PLACE AND RELATE IT TO THE VOICE.
     - every narration clip gets data-audio-group="voiceover"
     - the bed gets data-audio-group="music", data-volume="0.079",
       data-track-index="11"
     - the bed gets data-fx-carve against the GROUP "voiceover", strength 0.25
     - run: node <SKILL_DIR>/scripts/carve.mjs --comp index.html
   Carve settings live on the BED, never on a voice. sources is a list of GROUP
   names, not clip ids.
6. IF WORDS STILL BLUR, in this order: (a) lower the bed 2 dB, (b) add a
   peaking cut at 250 Hz -3 dB Q 1.2 on the bed, (c) raise carve strength by
   0.05 - stop at 0.35, (d) change the track. Do NOT raise the voice.

ACCEPTANCE TEST: play the densest 20 seconds of narration at conversational
level. Every word is intelligible without leaning in, and the bed is still
clearly present between phrases - if the bed disappears under speech you have
ducked it too far, if words blur you have not carved enough. The bed does not
sound notched; if it does, strength is too high.
```

## Execution spec

**Hyperframes.** The intended mechanism for music-under-voice is the **voiceover carve**, not a duck: *"The reflex is to duck the whole bed, which works and costs the bed all of its presence."* The carve cuts only the bands the voice actually occupies and leaves the bed's low end and top intact — which is exactly the same principle as choosing a beat-forward bed in the first place.

```html
<audio id="vo-01" src=".media/audio/voice/line-01.wav" data-audio-group="voiceover"
       data-start="0.5" data-track-index="10"></audio>
<audio id="vo-02" src=".media/audio/voice/line-02.wav" data-audio-group="voiceover"
       data-start="6.2" data-track-index="10"></audio>

<audio id="music-bed" src=".media/audio/bgm/bed-drums.wav"
       data-audio-group="music" data-start="0" data-duration="90"
       data-track-index="11" data-volume="0.079"
       data-fx-carve="{&quot;enabled&quot;:true,&quot;sources&quot;:[&quot;voiceover&quot;],&quot;strength&quot;:0.25}"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;peaking&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Reduce Mud&quot;,&quot;params&quot;:{&quot;frequency&quot;:250,&quot;gain&quot;:-3,&quot;q&quot;:1.2}}]}"></audio>
```

Then `node <SKILL_DIR>/scripts/carve.mjs --comp index.html`. Invariants: the carve lives on the **bed**; `sources` names a **group**, not clip ids (`audio_carve_ungrouped_sources`); keep the voice group voices-only or the next re-analysis is silently poisoned; `data-fx-carve` is clip-only, never on a bus (`audio_group_carve_attr`). Carve-written nodes are tagged `fromCarve` — never set that by hand, and hand-built nodes like the Reduce Mud filter above survive a re-run. Watch the **double-application trap**: `voice-clean` on the voice already contains a Reduce Mud stage, so do not add a second one there.

Two stems placed as two clips share one group and one carve target — put the carve on whichever clip is the louder of the two, or bus them and carve the bus's members individually (the carve cannot go on the bus itself).

**Epidemic Sound.** Verified live (2026-08-27):

- `SearchRecordings` filters that matter here: `vocals: false` · `bpm {min,max}` · `featuredInstrumentSlugs {matchType, values}` (`drums`, `electronic-drums`, `percussion` all resolve) · `moodSlugs` · `taxonomySlugs` (genre / decade / world country) · `musicalKeys`.
- Every recording returns `bpm` and a `stems` list. Real hits from `term: "instrumental beat driven underscore"`, `vocals:false`, `bpm 100–120`: *Open Roads* — 106 BPM, stems MELODY/INSTRUMENTS/DRUMS/BASS, tagged `beats` · *Maximum Profit (Instrumental Version)* — 100 BPM, DRUMS/BASS/INSTRUMENTS · *SOS* — 115 BPM, DRUMS/MELODY/BASS/INSTRUMENTS.
- `DownloadRecording` accepts `stemType: FULL | BASS | DRUMS | INSTRUMENTS`. **There is no MELODY stem in the download enum** even though search reports one — plan around `INSTRUMENTS` when you need everything-but-drums.
- **Known leak:** a search with `vocals: false` returned a track tagged `vocal presence` (*Sirens*). Always read `tags` on the node before committing.

**ffmpeg.** Crest-factor measurement and band-limited RMS are the two commands above. For a final intelligibility check on the mixdown, compare loudness of a speech-only stretch against a speech-plus-bed stretch: `ffmpeg -i mix.wav -af ebur128 -f null -` and confirm the bed adds no more than ~2 LU to the programme.

**Remotion.** `<Audio src={drums} volume={0.079} />` plus `<Audio src={bass} volume={0.079} />` under the narration `<Audio>`; ducking would be a `volume={f => ...}` function, but the carve has no Remotion equivalent — port it as a static EQ plus a modest duck.

## Pairs with
[[sfx-vocal-vs-instrumental-bed]] · [[sfx-bpm-filter-first]] · [[sfx-layer-volume-targets]] · [[sfx-loud-guitar-minus-30]] · [[sfx-music-audition-against-picture]] · [[sfx-music-drop-on-structure-turn]] · [[sfx-vibe-brief]] · [[pace-speech-rate-to-bpm-map]] · [[sfx-five-layers-build-order]]

## Failure modes
- **Choosing by mood alone.** A perfect-mood pad under narration is the single most common bed mistake; it measures fine and blurs every word.
- **Fixing masking with the fader.** Pulling the bed to −30 dB to rescue a pad-forward track leaves you with an inaudible bed and a still-mushy voice. Change the track or take the stems.
- **Raising the voice instead of treating the bed.** Costs headroom and pushes the mix hot without improving the signal-to-masker ratio in the bands that matter.
- **Carve strength over 0.35.** The bed sounds notched — audibly hollowed at the moments speech is present. That is the documented symptom of too much strength.
- **A bed with vocals under narration.** Two voices in the same band with no spatial separation. No amount of EQ fixes it.
- **Putting an SFX clip or the bed inside the `voiceover` carve group.** Poisons the next re-analysis silently. The group is voices only.
- **Known gap:** nothing in the stack measures intelligibility. The crest-factor and band-RMS checks are external ffmpeg steps and must be written into the build manifest as explicit tasks.
