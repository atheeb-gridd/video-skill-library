---
id: sfx-reverb-size-and-tail
title: Reverb as size — the tail that makes a hit land bigger
skill: sound-design
type: mix
family: sfx-treatment
tags: [skill/sound-design, type/mix, family/sfx-treatment, sfx/aesthetic, layer/sfx, layer/design, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-2, source/sfx-kt-1, source/research, difficulty/high]
source:
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:07:31"
    quote: "You can also add reverb in between to give it more impact."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:10:04"
    quote: "Then use the techniques I told you about: reverb, changing the pitch, or changing the duration — change all of these and you can make a unique number of variations out of one single sound effect."
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:08:28"
    quote: "There's a really easy way to mix them in: add reverb."
research_refs:
  - https://en.wikipedia.org/wiki/Reverberation
  - https://en.wikipedia.org/wiki/Precedence_effect
  - https://en.wikipedia.org/wiki/Gated_reverb
  - https://en.wikipedia.org/wiki/Inverse-square_law
difficulty: high
detectable_from: audio
---

# Reverb as size — the tail that makes a hit land bigger

## What it is
Reverb does two different jobs and the library keeps them in separate notes because they want opposite settings. [[sfx-reverb-glue]] is **realism**: a small, matched amount that stops a dry library file sounding pasted onto a real room. This note is **scale**: reverb used deliberately as an effect, to make one moment sound larger than the space it happens in. The source names it in the middle of building an impact — *"you can also add reverb in between to give it more impact"* — and that placement is exactly right, because the tail is what turns a click into an event.

The mechanism is that a listener reads the **size of a space from its decay**. RT60 is *"the time it takes for the sound pressure level to reduce by 60 dB"*, and it is *"proportional to room dimensions"*. So a 0.4 s decay says *room*, a 1.5 s decay says *hall*, and a 3 s decay says *cathedral* — regardless of what the picture shows. Using a decay longer than the shot's room is a deliberate lie, and it is the same lie a film uses when a punch rings out in a kitchen.

Three moves live here, in order of usefulness:

1. **The tail on the hit.** Reverb applied so the dry transient stays intact at full level and only its decay is enlarged. The **pre-delay** is what preserves the transient: the precedence-effect windows say sounds fuse into one event up to about **40 ms for complex material**, and *"for time delays above 50 ms (for speech) or some 100 ms (for music) the delayed sound is perceived as an echo"*. So a pre-delay of **20–40 ms** keeps the tail fused to the hit while letting the attack be heard clean; past ~60 ms it separates into a slap.
2. **Reverb *between* the whoosh and the hit** — the source's own phrase. The approach sound's tail is reverberated so the gap between travel and arrival is not dead air, and the two layers read as one gesture rather than two files. This is where the compound gains its size.
3. **The pre-swell (reverse reverb).** Reverse the hit, reverberate it, reverse the result: a 0.4–0.8 s swell that grows into the impact frame and stops dead on it. It is the cheapest way to make a cut feel inevitable, and it must be **baked offline** — see the execution spec.

The fourth variant is worth knowing by name: **gated reverb**, *"strong reverb and a noise gate that cuts the tail"*, which buys size without a long tail and is the correct answer when a big hit must not smear into the next line of dialogue.

The transcript's other framing — reverb as one of the three cheap variation knobs alongside pitch and duration — is the same control used for a different purpose, and lives in [[sfx-repetition-variant-rotation]].

**Style.** Filed `sfx/aesthetic`: the tail is a deliberate lie about scale, told for feel. Tails that agree with the room on screen are diegetic glue instead ([[sfx-reverb-glue]]), and a hit sitting on a movement still takes its timing from [[sfx-peak-on-impact-frame]].

## When to use it
- **On a hit that is supposed to be a structural beat** — a section title landing, a thesis line, a smash cut ([[sfx-cinematic-hit-emphasis]], [[sfx-riser-hit-pair]]).
- **In the gap of a whoosh→hit compound**, when the two layers sound like two files instead of one gesture.
- **Before a reveal**, as a reverse-reverb pre-swell into the cut frame.
- **When a hit is loud enough but still feels small.** Size is decay, not level: raising the fader makes it louder and no bigger.
- **Not on the whole SFX bus.** A shared reverb across every effect smears transients and turns the mix to mud; this is a per-moment treatment.
- **Not on a dry, close talking-head edit** where nothing else has a tail — a big hit in a dead room is the mismatch [[sfx-reverb-glue]] exists to prevent. Use gated reverb there instead.

## How to recognise it in a reference video
- **Isolate the tail.** Find the hit, then measure how long its energy takes to fall 60 dB (or 20 dB and extrapolate). A hit with **RT ≥ 0.8 s** in a shot showing a small room has an added tail; a hit that stops within ~0.25 s does not.
- **Compare the hit's tail to the dialogue's room.** If the effect rings and the voice does not, the reverb belongs to the effect, not the location. That asymmetry *is* the technique.
- **Listen for the pre-delay.** The attack should be audible as a distinct, dry crack before the space opens. If the whole event blooms at once, the pre-delay is 0 and the transient is being softened.
- **Check the gap in a compound.** In a whoosh→hit pair, is there audible energy between the whoosh's end and the hit's attack? Continuous energy through the join = reverb in between; a hole = two files butted together.
- **Look for a swell with no source.** A 0.4–0.8 s rise with no visible cause, ending exactly on a cut frame, is a reverse-reverb pre-swell. On a spectrogram it is the distinctive shape: broadband energy increasing to a hard vertical edge.
- **Check for ducking of the tail.** If the tail is present but stops abruptly where the next line of dialogue begins, the return was ducked or gated — a deliberate, professional move.
- **Low-end check.** A well-treated tail is high-passed; if the reverb's low frequencies are audible as a rumble under the next shot, it was not.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `size` (HyperFrames reverb) | 0.7 | 0.3–1.0 | 0.3–0.45 room · 0.5–0.7 hall · 0.8–1.0 cathedral/trailer. Not automatable. |
| `damping` | 0.5 | 0.3–0.8 | Higher = darker, shorter-sounding tail. Not automatable. |
| `wet` on a shared node | 0.20 | 0.15–0.35 | Size treatment. Glue is 0.05–0.10; above 0.5 it stops being a sound and becomes an effect. |
| `dry` | 0.9 | 0.7–1.0 | Keep near 1 on an insert so the transient is not diluted. |
| Pre-delay | 30 ms | 20–40 ms | Preserves the attack; fusion holds to ~40 ms, ≥50 ms becomes a slap. |
| Tail length (RT-ish) | 1.4 s | 0.8–2.5 s | Match to the size the moment claims, not the room. |
| Return level | −10 dB rel. the dry hit | −6 to −16 dB | The tail supports; it does not compete. |
| High-pass on the return | 250 Hz | 180–400 Hz | Stops the tail muddying the next line. |
| Low-pass on the return | 8 kHz | 6–12 kHz | Takes the fizz off a bright hit's tail. |
| Reverse pre-swell length | 0.6 s | 0.4–0.8 s | Ends **on** the impact frame, never after it. |
| Gate hold (gated reverb) | 0.4 s | 0.3–0.6 s | Then a fast release — *"cuts the tail of the reverb."* |

## Reproduction prompt
```
Enlarge the impact at {{CONTACT}} using reverb as a size control, not as glue.

1. KEEP THE TRANSIENT DRY. Do not put a wet reverb insert on the hit clip itself.
   Instead build a WET-ONLY RETURN: duplicate the hit as a second audio clip at the
   same data-start, and on the duplicate set the reverb node to dry:0, wet:1. The
   original stays fully dry at full level; the duplicate contributes only the tail.
2. SET THE SPACE on the duplicate: size {{SIZE}} (default 0.7), damping 0.5,
   wet 1, dry 0. Chain order on the duplicate: highpass 250 Hz -> reverb ->
   lowpass 8 kHz. Set the duplicate's level to -10 dB relative to the dry hit.
3. PRE-DELAY. Offset the duplicate's data-start by +0.03 s (30 ms) so the dry
   attack is heard clean before the space opens. Do not exceed 0.05 s.
4. FILL THE GAP (the "reverb in between"). If a whoosh precedes the hit, extend the
   whoosh's own tail into the contact frame: give the whoosh clip a reverb node at
   wet 0.25 and let its data-duration run 0.1-0.2 s PAST {{CONTACT}}, fading out
   over that overlap with a volume lane. The join must have no silent gap.
5. OPTIONAL PRE-SWELL. Bake it offline (there is no reverse in the composition):
     ffmpeg -i hit.wav -af "areverse,aecho=0.8:0.9:60|120|180:0.4|0.3|0.2,areverse" swell.wav
   Place swell.wav so its END lands exactly on {{CONTACT}}: data-start =
   {{CONTACT}} - swell_duration. Level -12 dB relative to the dry hit.
6. PROTECT THE NEXT LINE. If dialogue resumes within 1.5 s, either shorten the tail
   or add a gate after the reverb (hold 0.4 s, fast release) on the wet clip.

ACCEPTANCE: muting the wet duplicate must make the hit smaller but NOT quieter -
if it gets quieter, the dry clip lost level and the routing is wrong. The attack
must still read as a sharp transient. No reverb tail may overlap the first
syllable of the next spoken line.
```

## Execution spec

**HyperFrames — and one important architectural fact.** The audio model has **no aux send/return architecture**: `data-fx-chain` on a clip is an insert, and an `<hf-audio-group>` is a bus that processes every member with one chain. A true wet-only send is therefore emulated by **duplicating the clip** and setting the copy's reverb to `dry: 0, wet: 1`. The reverb node's parameters (`size` 0.05–1, `damping` 0–1, `wet` 0–1, `dry` 0–1) support this directly, and `wet`/`dry` are **automatable** while `size`/`damping` are not — they regenerate the impulse.

```html
<!-- dry transient, untouched -->
<audio id="sfx-hit-dry" src="assets/sfx/cinematic-hit.wav" data-audio-group="sfx"
       data-start="12.40" data-duration="1.0" data-media-start="0.06"
       data-track-index="12" data-volume="0.25"></audio>

<!-- wet-only "return": same file, 30 ms later, reverb at dry 0 / wet 1 -->
<audio id="sfx-hit-tail" src="assets/sfx/cinematic-hit.wav" data-audio-group="sfx"
       data-start="12.43" data-duration="2.6" data-media-start="0.06"
       data-track-index="13" data-volume="0.08"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;r1&quot;,&quot;label&quot;:&quot;Keep the tail out of the mud&quot;,&quot;params&quot;:{&quot;frequency&quot;:250}},{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;r2&quot;,&quot;params&quot;:{&quot;size&quot;:0.7,&quot;damping&quot;:0.5,&quot;wet&quot;:1,&quot;dry&quot;:0}},{&quot;type&quot;:&quot;lowpass&quot;,&quot;id&quot;:&quot;r3&quot;,&quot;params&quot;:{&quot;frequency&quot;:8000}}]}"></audio>
```

Four contract facts this depends on. **Chain order is signal order** and the doctrine is *"subtract before you add… character and ceiling last"* — hence high-pass before the reverb. **Reverb and delay extend the rendered track past its `data-duration`** via `chainTailSeconds`: *"a bed with reverb no longer ends exactly at its `data-duration`; that is expected, not a bug."* **Two overlapping `<audio>` on the same `data-track-index` raise `duplicate_audio_track`**, so the dry and wet clips go on 12 and 13. And **nothing validates the chain** — lint reads `data-automation` for two conflicts only; render refuses an unparseable chain outright while preview plays it dry, so a tail that "disappeared" in preview is usually a JSON escaping error (write the attributes double-quoted with `&quot;`, or `carve.mjs` cannot see them either).

For gated reverb, append a `gate` node after the reverb on the wet clip (`threshold` −35, `range` −24, `release` ~100 ms). Note the gate, like the compressor and limiter, is an AudioWorklet with **zero automatable parameters** — if the gating needs to move, automate a `gain` stage around it instead.

**ffmpeg (for the two things the composition cannot do).** Reverse reverb and any convolution with a real impulse response are offline operations producing a new `src`:

```bash
# reverse-reverb pre-swell
ffmpeg -i hit.wav -af "areverse,aecho=0.8:0.9:60|120|180:0.4|0.3|0.2,areverse" swell.wav

# convolution with a captured impulse response, when a specific real space is wanted
ffmpeg -i hit.wav -i hall-ir.wav -filter_complex "[0][1]afir=dry=0:wet=10" hit-hall.wav
```

Keep both the original and the derivative — the vault mount cannot delete files, so treat every bake as an additional asset, and ledger it with `resolve.mjs --from <file> --type sfx`.

**Epidemic Sound.** Often the cheapest "reverb" is a file that already has one. `SearchSoundEffects` terms that return pre-tailed material: `cinematic hit reverb tail` · `impact big room` · `boom trailer hit` · `reverse riser swell` (this last one removes the need to bake a pre-swell at all) · `sub drop tail`. `SearchSimilarToSoundEffect` on a chosen hit keeps every enlarged moment in a video sounding like the same room.

**Remotion.** Concept only: same two-clip arrangement (dry `<Audio>` plus an offset wet `<Audio>`); Web Audio effects are not part of the composition model, so treat the wet copy as a pre-rendered file.

## Pairs with
[[sfx-reverb-glue]] · [[sfx-riser-hit-pair]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-bass-drop-under-impact]] · [[sfx-peak-on-impact-frame]] · [[sfx-repetition-variant-rotation]] · [[sfx-pitch-shift-weight-energy]] · [[sfx-filter-character-and-distance]] · [[motion-impact-frame-quantisation]] · [[cut-smash-cut-loud-to-quiet]]

## Failure modes
- **Wet reverb as an insert on the hit itself.** Dilutes the transient and the impact gets *softer* while getting bigger. Keep the dry clip untouched; add the tail as a separate wet-only clip.
- **Zero pre-delay.** The space opens on the same sample as the attack, and the crack is swallowed. 20–40 ms.
- **Pre-delay over ~60 ms.** Now it is a slap echo, heard as a second event.
- **A tail that runs into the next line.** The most common real-world cost of this move. Shorten the decay, gate it, or duck the wet clip — do not leave dialogue fighting a reverb.
- **No high-pass on the return.** Low frequencies in a long tail turn to mud under the following shot and eat the sub layer's job.
- **Using it everywhere.** If every hit rings, none of them is big. Two or three enlarged moments in a ten-minute video is the budget ([[struct-stimulation-budget]]).
- **Expecting a send.** There is no send/return in this stack. If a note or a plan says "put the hit on a reverb send", it means the duplicate-clip arrangement above; anything else will process the dry signal too.
- **Known gap:** there is no reverse, no convolution-with-your-own-IR, and no automatable decay inside the composition. `size`/`damping` are fixed per node, so a tail that has to grow or shrink over time must be baked offline in ffmpeg — and ffmpeg's availability in this environment is unverified.
