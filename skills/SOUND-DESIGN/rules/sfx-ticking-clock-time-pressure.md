---
id: sfx-ticking-clock-time-pressure
title: The ticking clock — a metronome you have to tune to the edit
skill: sound-design
type: sfx
family: intimate-sfx
tags: [skill/sound-design, type/sfx, family/intimate-sfx, sfx/aesthetic, layer/sfx, layer/design, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:05:49"
    quote: "Like heartbeat sounds, a clock ticking sound, or heavy breathing sounds."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:05:41"
    quote: "to elevate this type of emotion we generally use very intimate sounds — meaning the sounds that are only audible when you come very near or close."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:05:34"
    quote: "Whether you want to make the audience feel anxiety, tension or intimacy"
research_refs:
  - https://en.wikipedia.org/wiki/Escapement
  - https://en.wikipedia.org/wiki/Entrainment_(biomusicology)
  - https://en.wikipedia.org/wiki/Precedence_effect
  - https://en.wikipedia.org/wiki/Acousmatic_sound
  - mcp://Epidemic_sounds/SearchSoundEffects (clock / stopwatch / metronome families)
difficulty: medium
detectable_from: audio
---

# The ticking clock — a metronome you have to tune to the edit

## What it is
The third member of the intimate family, and the one that behaves differently from the other two. A heartbeat says *this body is afraid*; breath says *this person is present*; a ticking clock says *time is being spent*. It is the only one of the three that points at something outside the frame — a deadline — which is why it works over material that has no body in it at all: a countdown, a decision, a warning, a "you have about six months before this stops working" line.

The property that makes it powerful is also the one that makes it dangerous: **a tick is exactly periodic and therefore reads as a tempo grid.** Listeners entrain to isochronous pulses — *"beat induction is the process in which a regular isochronous pulse is activated while one listens"* — so a ticking bed does not sit underneath the music, it competes with it for the same job. Two grids at unrelated tempos is the single failure mode of this technique, and it sounds like a mistake rather than like tension.

The real rates are worth knowing because they are the palette:

| Source | Rate | BPM equivalent | Reads as |
|---|---|---|---|
| Pendulum / wall clock, quartz second hand | 1 tick/s | **60 BPM** | Ordinary time, patient dread |
| Kitchen timer / stopwatch | 1–2 ticks/s | 60–120 BPM | Active countdown |
| Mechanical wristwatch | *"3–4 Hz … or 6–8 beats per second (21,600–28,800 beats per hour)"* | — | Close, nervous, intimate |
| Metronome | authored | any | Not a clock — a rhythm device; reads as musical |

So the working rule is arithmetic, not taste: **1 tick per second is 60 BPM, and it must be a simple ratio of the music's tempo.** Under a 120 BPM bed a 1 Hz tick lands on every second beat and disappears into the groove. Under a 100 BPM bed it drifts against every beat and both layers sound wrong within four seconds.

**Style.** Filed `sfx/aesthetic` with the rest of the intimate family ([[sfx-heartbeat-tension-dial]], [[sfx-intimate-proximity-sounds]]): the tick is a tension instrument pointing at a deadline outside the frame. A clock actually visible in the shot is a diegetic prop sound and is spotted as one ([[sfx-diegetic-spotting-list]]).

## When to use it
- **A stated or implied deadline.** "Before the algorithm changes", "you have until Friday", a countdown graphic, a limited offer. This is the diegetic-ish case and it is the strongest.
- **A decision being weighed** — a pause after a question, a cross-cut approaching its convergence ([[sfx-cross-cut-audio-strategy]]).
- **A tension bed where a heartbeat would be too physical.** Heartbeat implies a person in danger; a clock implies a situation running out. Pick by which one the video is actually about.
- **Under a silence.** The tick is at its best where the music has stopped ([[sfx-music-hard-stop]]) — it fills the hole without filling the attention.
- **Not** as a general "tension" default. Ticking under a section with no time dimension reads as a stock horror gesture, and it fatigues fast because a periodic sound is exactly what the brain habituates to.
- **Not** under a music bed whose tempo is not a multiple or simple divisor of the tick rate.

## How to recognise it in a reference video
- **A repeating identical transient at a fixed interval.** Measure the interval between two onsets; `60 ÷ interval_seconds` gives the tick's BPM. Log it.
- **Compare that to the music BPM.** A designed use gives a whole-number ratio (tick 60 under music 120, or tick 120 under music 120). A ratio like 60:100 is either an accident or a defect worth logging.
- **Check for acceleration.** Measure the first and last inter-tick intervals in the passage. A tick that speeds up over 8–15 s is an authored accelerando, not a loop.
- **Check where it stops.** The strongest use ends *before* the payoff frame, not on it — look for 2–6 frames of silence immediately preceding the reveal cut.
- **Bandwidth.** A designed tick bed is usually low-passed: energy concentrated below 4–6 kHz, without the bright 6–10 kHz click of a close-mic'd mechanism. A raw, bright, unfiltered tick is the amateur tell.
- **Level.** Measure against dialogue: a bed sits **−18 to −24 dB** relative to speech. If the tick is audible as an *event* rather than as a texture, it has been mixed as an effect and will fatigue.
- **Source visibility.** Note whether a clock is ever on screen. If not, the sound is acousmatic — *"a sound that one hears without seeing the causes behind it"* — which is the normal and more effective case here: the unseen source is what makes it feel like pressure rather than set dressing.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Tick rate | 60 BPM (1 Hz) | 40–140 BPM | Must be music_BPM ÷ 1, 2 or 4, or the music must be off. |
| Level rel. dialogue | −20 dB | −18 to −24 dB | It is a bed. Above −16 it becomes an event and fatigues. |
| Low-pass | 5 kHz | 4–8 kHz | Takes the studio click off; makes it a clock in a room. |
| High-pass | 250 Hz | 150–400 Hz | Keeps it out of the voice's weight band; costs nothing. |
| Reverb wet | 0.12 | 0.05–0.25 | Small room. Zero wet reads as a clock inside the headphones — use that deliberately for intimacy. |
| Bed length | ≥ 30 s | 20–120 s | Long enough to avoid an audible loop seam. |
| Accelerando | 60 → 90 BPM | 60 → 75–120 | Over 8–15 s. Beyond ~2× the start rate it stops reading as a clock. |
| Stop before payoff | 3 frames | 2–6 f | 30 fps. Silence must precede the reveal, not coincide with it. |
| Fade-in | 1.5 s | 0.8–3.0 s | The viewer should not notice it starting. |
| Max continuous use | 25 s | 10–40 s | Habituation. Past ~40 s it is wallpaper. |

## Reproduction prompt
```
Place a ticking-clock tension bed under {{IN}}..{{OUT}}.

1. DECIDE THE RATE FIRST. If a music bed is playing in this window, read its BPM.
   Set tick_bpm = music_bpm / 2 if that lands in 50-80, else music_bpm / 4, else
   music_bpm. If there is NO music (preferred), use 60 BPM = 1 tick per second.
   Never use a rate that is not a whole-number divisor of the music tempo.
2. FETCH: Epidemic SearchSoundEffects, query "clock ticking" (alternatives:
   "wall clock tick tock", "stopwatch ticking", "pocket watch ticking"), filter
   duration min 30000 ms so it is a bed and not a one-shot. Pull 3 candidates and
   pick the one whose native interval is closest to the target; reject any with an
   audible loop seam or a room that fights the shot.
3. RETIME rather than re-search: play it at rate = target_bpm / native_bpm (allowed
   range 0.1-5, pitch preserved). A 60 BPM file at 1.25 gives 75 BPM.
4. TREAT: high-pass 250 Hz, low-pass 5 kHz, reverb wet ~0.12. Set level to
   {{TICK_DB}} (default -20 dB relative to dialogue).
5. SHAPE: fade in over 1.5 s starting at {{IN}}. Hold. Then STOP the bed 3 frames
   (0.1 s) BEFORE the payoff frame {{PAYOFF}} - a hard stop, no fade - so the
   reveal lands in silence.
6. If the moment calls for an accelerando, do NOT try to automate rate: there is no
   rate envelope. Either pre-render the ramp offline, or place individual one-shot
   ticks with shrinking gaps (e.g. 1.00, 0.96, 0.92 ... 0.66 s) and let the picture
   cut land on the last one.

ACCEPTANCE: the tick's BPM divides the music BPM exactly, or no music is playing;
total continuous run <= 40 s; the bed is inaudible as an individual event when the
dialogue is at level; there is measurable silence between the last tick and the
payoff frame; muting the bed makes the passage feel slack, not broken.
```

## Execution spec

**Epidemic Sound.** `SearchSoundEffects` with these query terms, in descending reliability: `clock ticking` · `wall clock tick tock` · `ticking clock loop` · `stopwatch ticking` · `pocket watch ticking` · `metronome` (only when you want it to read as musical rather than as time). Filters: `duration.min = 30000` (**milliseconds**) for a bed, `duration.max = 2000` for single ticks you intend to place by hand. Audition on the low-quality preview URL before downloading; the two disqualifiers are an audible loop seam and a room tone baked into the file that contradicts the shot. `SearchSimilarToSoundEffect` on a chosen tick gives you the variants needed for the hand-placed accelerando so consecutive ticks are not literally identical ([[sfx-repetition-variant-rotation]]).

**HyperFrames.** Retiming is the important part and the contract supports it directly: `data-playback-rate` is a **constant** in `0.1..5`, render-safe and **pitch-preserved** — which is exactly right here, because a clock sped up should tick faster without turning into a smaller clock.

```html
<audio id="sfx-tick-bed" src="assets/sfx/clock-tick.wav"
       data-audio-group="sfx" data-start="42" data-duration="24"
       data-track-index="12" data-playback-rate="1.25" data-volume="0.1"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;t1&quot;,&quot;params&quot;:{&quot;frequency&quot;:250}},{&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;t2&quot;,&quot;params&quot;:{&quot;frequency&quot;:5000}},{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;t3&quot;,&quot;params&quot;:{&quot;size&quot;:0.35,&quot;damping&quot;:0.6,&quot;wet&quot;:0.12,&quot;dry&quot;:0.9}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[{&quot;t&quot;:0,&quot;v&quot;:0},{&quot;t&quot;:1.5,&quot;v&quot;:1},{&quot;t&quot;:24,&quot;v&quot;:1}]}]}"></audio>
```

Three contract facts drive this markup. **There is no rate envelope** — *"speed ramps must be preprocessed"* — so an accelerando is either a pre-rendered file or a sequence of individually placed one-shots. **`reverb.size` and `reverb.damping` are not automatable** (they regenerate the impulse); `wet`/`dry` are, so fade the tick's space with the `wet` lane if you need it to open up. And the lane **holds its first value backwards**, hence the explicit `{"t":0,"v":0}`. The hard stop is simply the clip's `data-duration` ending 0.1 s before the payoff — the visibility window is half-open, so the last audible frame is before `start + duration`.

**ffmpeg.** For a pre-rendered accelerando, or to retime a bed permanently:

```bash
# constant retime, pitch preserved (atempo accepts 0.5-2.0; chain for larger moves)
ffmpeg -i clock-tick.wav -af "atempo=1.25" clock-tick-75bpm.wav

# measure the native interval: print onset RMS per 10 ms and read the spacing
ffmpeg -i clock-tick.wav -af "asetnsamples=n=480,astats=metadata=1:reset=1,\
ametadata=print:key=lavfi.astats.Overall.RMS_level:file=-" -f null - 2>/dev/null | head -100
```

**Remotion.** Concept only: one `<Audio>` for the bed with `playbackRate`, or a mapped list of one-shot `<Audio>` elements at computed frames for the accelerando.

## Pairs with
[[sfx-intimate-proximity-sounds]] · [[sfx-heartbeat-tension-dial]] · [[sfx-cross-cut-audio-strategy]] · [[sfx-tone-bed-mystery]] · [[sfx-music-hard-stop]] · [[sfx-riser-anticipation-build]] · [[sfx-filter-character-and-distance]] · [[sfx-repetition-variant-rotation]] · [[struct-cross-cutting-parallel-action]]

## Failure modes
- **A tick whose rate fights the music.** The defining failure. Two unrelated grids read as an error within four seconds. Fix by retiming the tick to a divisor of the music BPM, or by stopping the music.
- **Running it too long.** A periodic stimulus is the easiest thing in the mix to habituate to; past ~40 s it stops producing tension and starts producing fatigue ([[sfx-density-fatigue-audit]]).
- **Stopping the tick *on* the reveal.** The silence has to arrive first or the viewer never registers it. 2–6 frames early.
- **A bright, dry, close-mic'd tick at effect level.** Reads as a sound effect sitting on top of the video rather than as pressure inside it. Low-pass it and put it at bed level.
- **Using a metronome sample as a clock.** It reads as musical timing, not as time passing — and it will pull the viewer's attention to the beat grid.
- **Ticking under material with no time dimension.** The most common misuse: generic tension. If nothing in the video is running out, the clock is lying, and the viewer feels the mismatch without being able to name it.
- **Known gap:** there is no beat detection and no tempo analysis in this stack, so the tick-to-music ratio must be established by measuring onsets in ffmpeg or by reading the BPM recorded in the music cue row. Nothing will warn you if the two drift.
