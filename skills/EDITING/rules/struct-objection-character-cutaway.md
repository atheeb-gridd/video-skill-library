---
id: struct-objection-character-cutaway
title: Voice the viewer's objection through a second character, then answer it
skill: editing
type: structure
family: objection-dialogue
tags: [skill/editing, type/structure, family/objection-dialogue, engine/hyperframes, engine/ffmpeg, engine/epidemic, source/sfx-kt-1, source/sfx-kt-2, source/editing-kt-3, source/research, difficulty/high]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:00:00"
    quote: "What happened? You look really confused. — Man, I need a sound effect, something to give suspense. I don't get it, how do I apply it?"
  - video: "assets/videos/sfx kt 2.mp4"
    timestamp: "00:03:36"
    quote: "Motion graphics? Are you crazy?"
  - video: "assets/videos/editing kt 3.mp4"
    timestamp: "00:00:18"
    quote: "(interjection) Come on, music isn't even that important — somebody tell him."
research_refs:
  - https://www.gofilmityourself.com/fiy/multiple-characters
  - https://www.backstage.com/magazine/article/what-is-shot-reverse-shot-film-examples-75550/
  - https://en.wikipedia.org/wiki/30-degree_rule
  - https://unison.audio/pitch-shifting/
difficulty: high
detectable_from: transcript+video
---

# Voice the viewer's objection through a second character, then answer it

## What it is
The doubt the viewer is already having is spoken out loud by a second character — a confused sidekick or a heckling alter ego — and the host answers it. Every objection sets up the next teaching point, so the character is simultaneously the comedy, the transition, and the script's spine. It appears at two doses, and the same craft governs both. **Dose A, the full two-hander:** the entire piece is staged as a dialogue, and each objection is the door into the next section ("But what name do I search? I don't know the names of any sound effects."). **Dose B, the objection cutaway:** an otherwise straight monologue is punctuated every minute or so by a 2-second insert of the heckler ("Just use the real ones. Why add them later?", "Motion graphics? Are you crazy?"). Both are almost always performed by the same person, which is what makes the craft demanding.

## When to use it
Use it when the material is information-dense and the audience has a predictable objection at a predictable place: a lecture that will be doubted ("why bother?"), a step whose obvious shortcut you need to pre-empt ("just use the real ones"), or a name/jargon problem the viewer cannot articulate ("what do I even search for?"). Dose A when the whole video is one dense explanation and you need structure plus comic relief throughout; dose B when the video's shape is already fine and you only need to break the lecture and pre-empt disagreement. Source the objections from real audience comments, DMs and FAQs — invented objections are the reason most attempts feel forced. Do not use it in a companionship/authenticity format, where a staged second character breaks the premise.

## How to recognise it in a reference video
- **Transcript is the primary signal.** Look for second-person challenges in a different register from the narration: "Are you crazy?", "Why add them later?", "Don't you know how to use a computer?", "So they should just use a better mic?" They are shorter, more colloquial, and often ungrammatical relative to the host's lines.
- **Objection → answer adjacency.** Every objection line is immediately followed by an answer that opens the next teaching point. If an objection is not answered within **1–2 sentences**, it is a joke, not this device.
- **Dose measurement.** Count objection lines and divide by runtime. **Dose A** runs **> 1.5/min** and the objections carry the section transitions. **Dose B** runs **0.5–1.0/min** — roughly one every **45–90 s**.
- **Cutaway duration (dose B).** **45–120 f (1.5–4.0 s)**, tightly clustered. If the inserts vary wildly the device has decayed into general goofing.
- **Two fixed setups, consistently used.** The host occupies one framing and screen side for the whole video; the heckler occupies a different framing and the opposite screen side. Check that the two never swap — that consistency is the 180-degree line, and it is what stops the viewer getting lost.
- **Differentiation stack.** Look for at least **two** of: wardrobe change, background/position change, lens or height change, hair/glasses/prop, colour-grade shift. One difference alone reads as a continuity error rather than a second character.
- **Eyeline.** The two look toward each other, i.e. toward opposite edges of frame. If both look down the lens the device reads as one person talking to themselves.
- **Audio marking.** The heckler's voice differs measurably: a small pitch offset (usually **1–3 semitones**), a different room (a touch more reverb or a duller top end), or a different mic distance. Measure the spectral tilt in the pauses.
- **A sting on the cut in, silence on the cut out.** A short cartoon pop or record scratch on the frame you cut *to* the heckler is near-universal; the cut back is usually clean.
- **Music behaviour.** The bed almost always drops or stops for the cutaway and returns on the cut back — that momentary hole is a big part of why the insert reads as an interruption.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `dose` | `B` | `A` \| `B` | A = full two-hander; B = intermittent cutaway |
| `objections_per_minute` | 0.8 | 0.5–1.0 (B) · 1.5–3.0 (A) | |
| `cutaway_duration` | 2.5 s (75 f) | 1.5–4.0 s | Dose B |
| `cutaway_interval` | 60 s (1800 f) | 45–90 s | Never two inside 45 s |
| `objection_line_length` | 8 words | 4–14 words | Short. A long objection stops being an interruption |
| `answer_within` | 2 sentences | 1–2 | Non-negotiable: an unanswered objection is a dead joke |
| `audio_lead` | 8 f (267 ms) | 4–12 f | J-cut: the objection's audio starts before the picture cuts |
| `reaction_tail` | 6 f (200 ms) | 4–10 f | Frames held on the heckler after the last word |
| `pitch_offset` | −2 st | ±1 to ±3 st | Beyond ±4 st it reads as a cartoon, not a character |
| `voice_preset` | `room-tight` @ 0.35 | `room-tight`, `intercom`, `telephone` @ 0.2–0.5 | Presets are costumes — **never stack two** |
| `screen_side_host` | right-of-centre | fixed | Looks screen-left |
| `screen_side_heckler` | left-of-centre | fixed | Looks screen-right. Never swap mid-video |
| `differentiators` | 2 | 2–4 | Wardrobe · position · lens/height · prop/grade |
| `sting_level` | −13 dB | −12 to −15 dB | On the cut *in* only |
| `bed_action` | duck to 0.15 | stop \| duck 0.10–0.25 | Returns on the cut back |

## Reproduction prompt

```
Insert objection-character cutaways into a monologue edit at 30fps.

1. Harvest 5-10 verbatim doubts from comments, DMs or FAQs and trim each to 4-14 words in
   colloquial register. Do not invent them.

2. For each, find the sentence that ANSWERS it and put the cutaway immediately BEFORE that
   sentence - the objection sets up the next teaching point, it never reacts to the last one. One
   every 1800 f (60 s); never two within 1350 f (45 s); cap 1.0 per minute.

3. Lock the geometry once for the whole video. HOST: right-of-centre, looking screen-left.
   HECKLER: left-of-centre, looking screen-right, on the SAME side of the 180-degree axis, with
   matching lens, camera height and light direction. Give the heckler at least TWO differentiators
   from wardrobe / background-position / lens-height / prop / grade shift - one alone reads as a
   continuity error. Never swap the screen sides.

4. Cut each insert as a J-cut, not a straight cut: the objection's AUDIO begins 8 f (0.27 s) before
   the picture cuts; hold the heckler {{DUR}} f (default 75); hold 6 f of reaction after the last
   word; cut back on the host's first word. One cartoon pop or record scratch at -13 dB on the
   frame you cut TO the heckler. Nothing on the cut back.

5. Mark the voice with a PRE-BAKED pitch shift of -2 semitones, then one character or space preset
   at amount 0.2-0.5. Never stack two presets.
     ffmpeg -i heckler.wav -af "asetrate=48000*0.8909,aresample=48000,atempo=1.1225" heckler.p.wav

6. Duck the bed to 0.15 for the insert and restore it on the cut out.

Acceptance test: in the transcript alone every objection is answered within two sentences, and
removing any objection leaves a visible seam in the argument. Watched muted, the two setups are
distinguishable in a single frame and the eyelines point at each other in every insert.
```

## Execution spec

**Production note that governs everything downstream:** shoot the two characters as two **separate setups**, not composited into one frame. Same-frame compositing needs a genuinely locked-off tripod ("you don't move or bump the tripod or any of the set decor — you need the exact same framing for each character") plus shoulder doubles or rotoscoping, and it is not worth it for a cutaway device. Shot/reverse-shot with fixed screen sides gets 95% of the effect. Keep both setups on one side of the 180-degree axis and match lens, height and light direction; place a mark at the absent character's eye level so the eyeline is repeatable.

**ffmpeg — the pitch shift, which this stack cannot do in-composition.** The HyperFrames FX registry has filters, dynamics, saturate, bitcrush, delay, reverb, chorus and phaser — **no pitch shifter** — and `data-playback-rate` is explicitly *pitch-preserved*. So the offset must be baked:

```bash
# -2 semitones: ratio 2^(-2/12) = 0.8909 ; compensate tempo by 1/0.8909 = 1.1225
ffmpeg -i heckler.wav -af "asetrate=48000*0.8909,aresample=48000,atempo=1.1225" heckler.p2.wav
# +2 semitones: 2^(2/12) = 1.1225 ; atempo=0.8909
```
Then trim each objection line to its own file, or keep one file and window it with `data-media-start`.

**HyperFrames — the J-cut and the insert.** Picture and sound are cut independently, which is exactly the case the project's "videos `muted` + a separate `<audio>`" rule exists for:

```html
<!-- host A-roll: picture continues to 61.53, audio stops at 61.26 (the J-cut) -->
<video id="host-03" src="assets/host.mp4" data-start="52.00" data-duration="9.53"
       data-media-start="140.00" data-track-index="0" muted playsinline style="z-index:0"></video>
<audio id="host-03-a" src="assets/host.wav" data-audio-group="voiceover"
       data-start="52.00" data-duration="9.26" data-media-start="140.00"
       data-track-index="10"></audio>

<!-- objection: audio leads picture by 8 frames (0.267s) -->
<audio id="obj-03-a" src="assets/heckler.p2.wav" data-audio-group="voiceover"
       data-start="61.26" data-duration="2.30" data-media-start="18.40"
       data-track-index="10"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;reverb&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Heckler Room&quot;,&quot;params&quot;:{&quot;size&quot;:0.30,&quot;damping&quot;:0.5,&quot;wet&quot;:0.18,&quot;dry&quot;:0.85}}]}"></audio>
<video id="obj-03" src="assets/heckler.mp4" data-start="61.53" data-duration="2.50"
       data-media-start="18.67" data-track-index="1" muted playsinline style="z-index:1"></video>

<audio id="sfx-obj-03" src="assets/sfx/scratch.wav" data-audio-group="sfx"
       data-start="61.53" data-duration="0.60" data-track-index="12" data-volume="0.22"></audio>
```

Contract points:
- Both heckler and host voice clips go in the **`voiceover`** group so the bed's carve follows both. Keep the group **voices only** — an SFX or a bed inside it poisons the next carve re-analysis silently.
- The sting goes in the `sfx` group, never `voiceover`.
- Every `<audio>` needs an `id`; an id-less audio element is never mixed → silent render.
- `video_nested_in_timed_element` is an error: time the wrapper **or** the video, never both.
- Duck the bed for the insert with a `volume` automation lane on the **bed** (clip-local `t`, explicit `{"t":0,"v":1}` first point), or better, rely on the voiceover carve plus a shallow lane dip.
- The character/space presets (`room-tight`, `intercom`, `telephone`, `radio-am`, `megaphone`, `doofus-worble`) write `fromPreset` nodes and are wrapped in a wet/dry blend: `presetAmount` 0..1, automatable as `fx.preset.<id>` — the only way to automate a preset as a unit. *"These are costumes… Do not stack two."*
- Beware the double-application trap: a preset that already contains a Reduce Mud job plus your own −3 dB at 250 Hz gives −6 dB where −3 was meant.
- Frame→seconds: use `(frame + 0.5) / fps` with four decimals. 8 frames = 0.2667 s.

**Epidemic Sound** — the sting:
`SearchSoundEffects({ query: { term: "record scratch cartoon stop" }, filter: { duration: { min: 200, max: 900 } }, first: 8 })`. Vary it across the video with `SearchSimilarToSoundEffect` rather than repeating one file — repeated identical SFX is one of the three named sound-design mistakes. A cartoon pop or a "boing" works equally well for a lighter heckle.

**Remotion**: two `<Sequence>`s with the audio sequence starting 8 frames before the video sequence; concept only.

## Pairs with
[[cut-j-audio-leads-picture]] · [[struct-name-define-demonstrate]] · [[pace-silent-demonstration-window]] · [[struct-enumerated-promise-and-counter]] · [[struct-stimulation-budget]] · [[sfx-whoosh-transition-movement-reveal]] · [[sfx-music-audition-against-picture]]

## Failure modes
- **The objection is not answered.** It becomes a random joke and the viewer learns the character is noise. Correction: every objection is answered within two sentences, and the answer opens the next section.
- **The cutaway placed *after* the point instead of before it.** Then it is a reaction, not a set-up, and it carries no structure. Correction: move it in front of the answering sentence.
- **One differentiator only.** Same clothes, same background, slightly different position reads as a continuity error and the audience thinks the edit is broken. Correction: at least two differentiators, one of which is wardrobe or background.
- **Screen sides swapping.** The 180-degree line breaks and the two characters stop feeling co-present. Correction: fix the geometry once in the design document and never vary it.
- **Both characters looking down the lens.** Kills the illusion instantly. Correction: eyelines toward each other, using a physical mark at the absent character's eye height.
- **Pitch pushed too far.** Beyond about ±4 semitones the heckler becomes a cartoon and the comedy goes cheap. Correction: ±1 to ±3 semitones, plus a room change to carry the rest of the difference.
- **Stacked character presets.** `telephone` over `megaphone` sounds broken rather than characterful. Correction: one preset, amount 0.2–0.5.
- **Straight cut instead of a J-cut.** The insert lands as a hard interruption of the picture too, which makes it feel like an editing error. Correction: audio leads picture by 4–12 frames.
- **Too frequent.** Three heckles a minute and the video is a sketch, not a tutorial. Correction: cap at 1.0/min for dose B.
- **Known gap:** there is no in-composition pitch shifter and `data-playback-rate` preserves pitch, so the voice offset must be a pre-baked file. There is also no automatic waveform sync — the J-cut offset is authored by writing the numbers on both elements by hand.
