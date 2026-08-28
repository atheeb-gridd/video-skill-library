---
id: sfx-whip-on-punchline
title: The whip on a punchline — a supersonic crack on a small human movement
skill: sound-design
type: sfx
family: comedy-sfx
tags: [skill/sound-design, type/sfx, family/comedy-sfx, sfx/aesthetic, layer/sfx, engine/hyperframes, engine/epidemic, engine/ffmpeg, source/sfx-kt-1, source/research, difficulty/low]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:06:41"
    quote: "On a punchline or a sudden reaction you can also use it to give a humorous touch."
research_refs:
  - https://en.wikipedia.org/wiki/Whip
  - https://en.wikipedia.org/wiki/Comic_timing
  - https://en.wikipedia.org/wiki/Audio_to_video_synchronization
  - https://en.wikipedia.org/wiki/Orienting_response
difficulty: low
detectable_from: audio
---

# The whip on a punchline — a supersonic crack on a small human movement

## What it is
A whip-crack sound effect landed on the frame where a person snaps into a reaction, or on the beat immediately after a punchline lands. The comedy comes from **scale mismatch**: a whip crack is a genuine **sonic boom** — a ripple travels down the whip, accelerating to more than thirty times the speed of the handle until it *"breaches the speed of sound"* — so the file carries an extremely fast, violent transient. Putting that much violence on an eyebrow raise, a head turn, or a slow blink is absurd, and the absurdity is the joke. The same effect used on an actual fast movement is not comedy at all, it is [[sfx-air-on-micro-movement]] doing its normal job.

Two properties of the sound drive every timing decision. First, its **peak is essentially its first sample** — unlike a cinematic hit, whose peak sits 100–300 ms into the file, a whip has almost no pre-transient, so `PEAK_T ≈ 0.00–0.02 s` and placement is nearly literal. Second, it is **almost entirely high-frequency** and very short, so it cuts through a mix at a level far below where a bass-heavy impact would need to sit, and it masks nothing. It belongs to the *aesthetic* class of the source's three-way taxonomy — the viewer will not consciously notice it but will feel the tone it sets.

## When to use it
Use it on a **sudden reaction shot**: the frame where the head snaps, the eyes widen, the double-take begins, or the cutaway to a deadpan face begins. Use it immediately after a punchline where a beat of silence has already been left and the reaction is what pays it off. Use it on a rapid-fire whip pan or a snap zoom into a face — the movement supplies the alibi and the sound supplies the exaggeration.

Do not put it **on the punchline's last word.** The comic beat — the pause the audience needs *"to recognize the joke and react"* — belongs between the line and the reaction; a crack on the word steps on the delivery. Do not use it in a video whose register is serious: it is a **tonal commitment**, exactly like the rest of [[sfx-cartoon-comedy-family]], and once one crack has been heard a later attempt at gravity is fighting it. Do not use the same file twice in one video — repeating an identical effect is named explicitly as sound-design mistake number three in the source.

## How to recognise it in a reference video
- **A sub-200 ms burst with almost no body**, its energy concentrated above about 2 kHz, sitting alone on a frame where nothing else in the mix changes.
- **The transient is the file's first sample.** Zoom in: attack under 5 ms, no ramp-in, decay under 150 ms unless reverb has been added.
- **It lands on a reaction, not on a word.** Check the word-level transcript: the crack falls **after** the last syllable of the joke, in the gap, on the frame the reaction shot begins.
- **The gap between the line's end and the crack is 8–20 frames** (0.27–0.67 s). That gap is the comic beat and it is the technique's real parameter.
- **Sync is tight.** The crack is within roughly −1 to +2 frames of the visible movement. Past about +3 frames it stops reading as *caused by* the movement; the published detectability threshold for AV asynchrony is **45 ms audio lead / 125 ms lag**, and comedy needs tighter than that.
- **The movement it accompanies is small.** A whip on an actual fast whip-pan is functional sound design; a whip on a raised eyebrow is this note.
- **Level:** noticeably present but not dominant — the SFX layer sits around **−12 to −15 dB** relative to dialogue in the source's own mix numbers.
- **Frequency across the video:** at most 2–3 whips in five minutes, and never the identical file twice.
- **Register check:** if you find a whip, you will almost always also find pops, boings, or a record scratch. It never appears alone in a serious edit.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| Comic beat — punchline end → reaction cut | 14 f (0.47 s) | 8–20 f | The pause is the joke. Under 8 f the line has no room; over 20 f the joke dies. |
| Crack alignment vs the visible movement | 0 f | −1 to +2 f | Negative = sound slightly early, which reads as anticipation. Beyond +3 f the causal link breaks. |
| `PEAK_T` of the file | 0.01 s | 0.00–0.03 s | Measure it; a whip's peak is at or near the first sample, unlike a cinematic hit. |
| Clip duration | 0.35 s | 0.15–0.60 s | Longer only if reverb tail is wanted. |
| Level | −13 dB rel. dialogue | −12 to −15 dB | Source's own SFX-layer number. |
| True peak headroom vs dialogue peak | −6 dB | −4 to −8 dB | A whip is transient-dense; peak-match rather than RMS-match. |
| Reverb wet | 0.12 | 0.00–0.20 | Dry reads pure cartoon; a touch of room places it in the scene. Over 0.25 turns it into a Western. |
| Pitch variation between uses | −2 to +2 semitones | ±3 st | The cheap way to avoid repeating an identical file. |
| High-pass | 300 Hz | 200–500 Hz | Removes the low thump some libraries bake in, which is not part of a real crack. |
| Uses per 5 minutes | 2 | 1–3 | Beyond 3 it becomes the video's personality. |
| Identical file reuse | never | — | Named as a mistake in the source; rotate 3+ variants. |

## Reproduction prompt

```
Land a whip crack on a comedic reaction. 30fps; HyperFrames authors seconds
(seconds = frames / 30).

1. GATE. Confirm all three or stop: (a) the video is already in a light or
   comedic register - a whip is a tonal commitment, not a one-off gag; (b)
   there is a visible SUDDEN REACTION on screen - a head snap, a double
   take, widened eyes, or the first frame of a deadpan cutaway; (c) this is
   at most the third whip in five minutes and the file has not been used
   before in this video.
2. FIND THE BEAT. From the word-level transcript, take PUNCH_END = end time
   of the punchline's last word. Set REACT = PUNCH_END + 0.47s (14 frames)
   and move REACT to the exact frame the reaction becomes visible. Leave the
   gap between PUNCH_END and REACT SILENT except for ambience - the pause is
   the joke and a sound inside it kills it.
3. SOURCE the file. It must have an attack under 5ms, a decay under 150ms,
   and its energy above 2kHz. Reject anything with a low thump or a
   pre-transient swell - that is a whoosh, not a crack.
4. MEASURE PEAK_T: the time of the maximum absolute sample from the start of
   the file. For a whip this will be 0.00-0.03s. Do not estimate it.
5. PLACE at data-start = REACT - PEAK_T, media offset 0, clip duration 0.35s.
   Verify the resulting placement is within -1 to +2 frames of the visible
   movement; outside that window the sound stops reading as caused by it.
6. TREAT: high-pass at 300 Hz, then optional reverb at wet 0.12 to place it
   in the room, then a limiter LAST as a ceiling. Set the level to -13 dB
   relative to dialogue and check its true peak sits ~6 dB below the
   dialogue's peak.
7. VARY. If a second whip appears later in the video, use a different file
   or pitch this one by 2-3 semitones in a preprocessed variant. Never place
   the identical file twice.
8. ACCEPTANCE TEST: (a) the rendered audio's local peak is on the reaction
   frame within 1 frame; (b) nothing is audible in the gap between the
   punchline and the reaction except ambience; (c) mute the picture - the
   whip should sound like a crack, not a swish or a thump; (d) play at full
   speed once - if it makes you smile it works, if it makes you wince the
   level is too high; (e) count whips in the video and confirm no file
   repeats.
```

## Execution spec

**Epidemic Sound — the search terms matter, because "whip" returns two different things.**
```
SearchSoundEffects { query.term: "whip crack",              filter.duration { max: 1500 } }
SearchSoundEffects { query.term: "whip crack short snap",   filter.duration { max: 1000 } }
SearchSoundEffects { query.term: "whoosh whip fast swipe",  filter.duration { max: 1500 } }   // NOT this one for comedy
SearchSimilarToSoundEffect { id: "<the chosen crack>" }                                        // build a 3-variant rotation
```
The third query returns *whip-pan whooshes* — air movement, no crack — which is [[sfx-whoosh-transition-movement-reveal]]'s asset, not this note's. `DownloadSoundEffect` into `assets/sfx/`, then optionally ledger with `node <SKILL_DIR>/scripts/resolve.mjs --from <file> --type sfx --project .`. Build the rotation up front; a three-file rotation is what makes the "never repeat" rule cheap.

**HyperFrames — placement plus a short chain.**
```html
<!-- reaction visible at 143.20s; measured PEAK_T = 0.012s -->
<audio id="sfx-whip-react-1" src="assets/sfx/whip_crack_a.wav"
       data-audio-group="sfx"
       data-start="143.188"           <!-- 143.20 - 0.012 -->
       data-duration="0.350" data-media-start="0"
       data-track-index="14" data-volume="0.26"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[
         {&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Kill the Thump&quot;,&quot;params&quot;:{&quot;frequency&quot;:300,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}},
         {&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n2&quot;,&quot;label&quot;:&quot;Put It In The Room&quot;,&quot;params&quot;:{&quot;size&quot;:0.35,&quot;damping&quot;:0.6,&quot;wet&quot;:0.12,&quot;dry&quot;:0.95}},
         {&quot;type&quot;:&quot;limiter&quot;,&quot;id&quot;:&quot;n3&quot;,&quot;params&quot;:{&quot;limit&quot;:-1,&quot;attack&quot;:1,&quot;release&quot;:30,&quot;level_out&quot;:0}}]}"
       data-automation="{&quot;version&quot;:1,&quot;lanes&quot;:[{&quot;target&quot;:&quot;volume&quot;,&quot;points&quot;:[
         {&quot;t&quot;:0,&quot;v&quot;:1},{&quot;t&quot;:0.33,&quot;v&quot;:1},{&quot;t&quot;:0.35,&quot;v&quot;:0}]}]}"></audio>
```
Contract facts that bind this:
- **Chain order is signal order**, and the doctrine is *"subtract before you add, level after you filter, character and ceiling last"* — high-pass, then reverb, then **limiter last**.
- **`limiter` is an AudioWorklet configured wholesale: none of its parameters are automatable.** Neither are `compressor`, `gate`, `bitcrush`, nor `reverb`'s `size`/`damping` (they regenerate the impulse; only `wet`/`dry` automate). If you need a moving whip, automate a `gain` stage around the chain.
- **There is no pitch attribute.** A pitched variant is a **preprocessed file**, not a composition setting. `data-playback-rate` changes speed and is **pitch-preserved**, so it will not give you a pitched whip.
- Reverb makes the rendered track **longer** than `data-duration` (`chainTailSeconds`) — expected, not a bug; do not lengthen the clip to compensate.
- **Every `<audio>` needs an `id`** or it is never mixed — a silent render with no error.
- Keep it in the **`sfx` group, never `voiceover`**: a non-voice clip inside the carve group silently poisons the next carve re-analysis.
- **JSON attributes double-quoted with `&quot;`** — `carve.mjs` finds them with a `name="..."` regex and a single-quoted attribute is invisible to it.
- Overlapping `<audio>` on one `data-track-index` warns `duplicate_audio_track`; give whips their own lane (14) away from ambience (13) and beds (11–12).
- **Timing an SFX to a visual event is authored twice.** There is no audio-follows-animation attribute; if the reaction lives in a sub-composition at scene-local `t`, the root-level audio needs `data-start = t + the slot's data-start`.

**ffmpeg — building the variant rotation offline.** This is the cheap way to satisfy "never the same file twice":
```bash
# +2 semitones, tighter
ffmpeg -i whip_crack_a.wav -af "asetrate=48000*1.1225,aresample=48000,atrim=0:0.30" whip_crack_a_up2.wav
# -2 semitones, heavier
ffmpeg -i whip_crack_a.wav -af "asetrate=48000*0.8909,aresample=48000" whip_crack_a_dn2.wav
# measure PEAK_T for each (read the max_level position from the output)
ffmpeg -i whip_crack_a.wav -af "astats=metadata=1:reset=0,ametadata=print:key=lavfi.astats.Overall.Peak_level" -f null -
```
Note `asetrate` changes pitch *and* duration together — for a whip that is fine and is the point. Keep scratch outside the mounted vault, which cannot delete files.

**Remotion:** an `<Audio>` at `startFrom: 0` placed at the reaction frame minus the measured peak offset. Not part of this project.

## Pairs with
- [[sfx-cartoon-comedy-family]] — the register this belongs to; a whip is never alone
- [[sfx-record-scratch-punctuation]] — the other comedic full stop, and a bigger one
- [[sfx-air-on-micro-movement]] — the same asset family used functionally instead of comically
- [[sfx-whoosh-transition-movement-reveal]] — the whoosh that is *not* a crack, and is often what search returns
- [[sfx-av-sync-binding-window]] — the tolerance numbers this note's tight window comes from
- [[sfx-ab-audition-candidates]] — how to pick between three candidate cracks
- [[cut-smash-cut]] — the comedic Gilligan variant a whip often accompanies
- [[struct-misspeak-correction-gag]] — a structural home for the joke
- [[sfx-placement-discipline]] — the gate that stops whips multiplying
- [[sfx-sound-pass-order]] — the census across the whole video

## Failure modes
- **Putting the crack on the punchline's last word.** It steps on the delivery and removes the comic beat, which is the part that actually makes the joke land. The crack goes on the reaction.
- **Using a whoosh and calling it a whip.** A swishing air sound has a slow attack and no crack; it reads as motion, not as comedy. Attack under 5 ms or reject the file.
- **Repeating the identical file.** Named explicitly as a sound-design mistake in the source. Rotate at least three variants, pitched if necessary.
- **Too loud.** A whip is all high frequency and will feel much louder than its meter reading. At −13 dB it is present; at −6 dB it is painful and the joke becomes an assault.
- **Too much reverb.** Past about 0.25 wet, the whip stops being a comedic accent and becomes a spaghetti-Western cue.
- **Late by four frames or more.** The causal link between the movement and the sound breaks and the effect reads as a separate random noise; comedy needs tighter than the standard 45 ms lead / 125 ms lag detectability window.
- **Using it in a serious video.** One crack commits the whole edit to a light register. If the next section needs gravity, do not spend a whip earlier.
- **Adding a whoosh as well.** One approach sound per moment; a whoosh plus a crack on the same frame reads as a mistake, not as layering.
- **Known gap:** there is **no pitch attribute** in the composition layer, so every variant is a preprocessed file; and nothing in this stack measures a file's peak time or validates the FX chain — the contract states plainly that *nothing validates the chain or the effect lanes at all*. Measure `PEAK_T` with ffmpeg and verify by rendering and listening, per [[sfx-playback-verification-loop]].
