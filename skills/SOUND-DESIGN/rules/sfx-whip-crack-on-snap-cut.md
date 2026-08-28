---
id: sfx-whip-crack-on-snap-cut
aliases: [sfx-whip-vs-whoosh]
title: The whip crack — the sound for a cut, not for a glide
skill: sound-design
type: sfx
family: whip
tags: [skill/sound-design, type/sfx, family/whip, sfx/motion, layer/sfx, engine/epidemic, engine/hyperframes, engine/ffmpeg, source/sfx-kt-1, source/research, difficulty/medium]
source:
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:06:41"
    quote: "9th is the whip sound effect."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:06:49"
    quote: "On fast cuts or fast moments, this works really well."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:06:52"
    quote: "You can also use it on a punchline or a sudden reaction to give it a humorous touch."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:07:00"
    quote: "And when you layer it with a whoosh, you'll end up with all kinds of unique sounds."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:06:56"
    quote: "In old-school action scenes, this same sound effect used to be used as well."
  - video: "assets/videos/sfx kt 1.mp4"
    timestamp: "00:07:23"
    quote: "Footsteps, clothes, or a door creak — this creates realism in the scene"
research_refs:
  - https://en.wikipedia.org/wiki/Whip_(implement)
  - https://en.wikipedia.org/wiki/Whip
  - https://www.epidemicsound.com/sound-effects/
  - https://pixflow.net/blog/cinematic-whoosh-sound-effects/
  - https://blog.prosoundeffects.com/sound-editing-in-sync-tutorial
  - https://blog.prosoundeffects.com/sound-layering
  - https://en.wikipedia.org/wiki/Auditory_masking
  - https://morphic.com/ai-glossary/Whip-Pan
  - https://www.premiumbeat.com/blog/create-seamless-transitons-whip-pan/
  - https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.1359-1-199811-I!!PDF-E.pdf
  - mcp://Epidemic_sounds/SearchSoundEffects (weapons--whip and swooshes--swish shelves probed live, 2026-08-27)
difficulty: medium
detectable_from: audio
---

# The whip crack — the sound for a cut, not for a glide

## What it is
A whip is a **transient-dominated** effect: near-silence, then a crack with an attack under about 15 ms, then a short decaying tail. That shape is what distinguishes it from a whoosh, which is a **sustain-dominated** broadband sweep that rises, peaks and falls. The distinction is not cosmetic — it determines where the sound goes on the timeline:

- A **whoosh** has a peak in the middle of its own body, so it is anchored to the *middle of a movement*: its peak sits at the fastest moment of the pan, zoom or slide, and its body fills the move.
- A **whip crack** has its energy at the front, so it is anchored to *an instant*: the frame of the cut, the frame the graphic snaps into place, the frame the reaction lands. It punctuates rather than carries.

The physical difference is the whole selection rule, and it is extreme. A crack is literally a small sonic boom — a ripple travels down the lash *"rapidly escalating in speed until it breaches the speed of sound, more than 30 times the speed of the initial movement in the handle"* — so the attack is about as short as an acoustic event gets. A whoosh is filtered noise **swept** through a rise and a fall; it has duration, direction and a body. Put the crack on a slow slide and it fires while the picture is still moving; put the sweep on a two-frame cut and its body has nowhere to live, so it smears across the seam.

The source's guidance follows exactly this: whips are for **fast cuts and fast moments**, and for **a punchline or a sudden reaction**, where they add a humorous, old-school-action edge. On a punchline nothing physically moves fast at all — there the crack is punctuation borrowed from cartoon grammar, and it belongs to the aesthetic style rather than the motion style. And the layered form — *"when you layer it with a whoosh, you'll end up with all kinds of unique sounds"* — is the standard professional build for a whip pan: the whoosh carries the travel, the crack marks the arrival.

**The period convention, and where the "realism" claim actually belongs.** The source adds that *"in old-school action scenes, this same sound effect used to be used as well"*, and this is genre memory rather than physics: the whip carries the 1930s-serial and 1970s-action register, which is precisely why it reads as comic when dropped on a modern talking-head cut. A correction worth recording: the "this creates a realism in the scene" line that is often attached to the whip is, in the transcript, spoken about **Foley** (`00:07:23`, over footsteps, cloth and a door creak), not about the whip. **A whip crack does not create realism** — it creates a genre reference. Realism in a physical action beat comes from Foley and from diegetic layering, and a whip used in pursuit of realism will do the opposite: it will make the moment read as a pastiche. Modern practice reflects this: the literal whip sample survives mostly in comedic and retro contexts, while the transition workhorse is a **designed whoosh-plus-crack hybrid** — the whoosh carrying the travel and a short bright transient marking the arrival, which is exactly the layered build the source recommends.

Whoosh doctrine in general lives in [[sfx-whoosh-transition-movement-reveal]]; peak-to-frame alignment lives in [[sfx-peak-on-impact-frame]] and [[sfx-peak-on-the-cut]]; Foley's actual realism job lives in [[sfx-air-on-micro-movement]] and [[sfx-ambience-bridge-across-cut]]; and the query terms for finding either family live in [[sfx-search-vocabulary]]. **This note owns the whip specifically**: when it is the correct choice over a whoosh, and where its transient goes.

**Style.** Filed `sfx/motion`: the crack is bound to a snap — a cut or a hard directional change — and with no such event it has nothing to mark. The same asset fired for comic punctuation, with nothing moving, is an aesthetic cue and lives in [[sfx-whip-on-punchline]].

## When to use it
Four situations, and they are narrower than most editors assume:

1. **A rapid-cut sequence** — a run of shots at 6–20 frames each where each cut needs punctuation, or the cut that ends a montage, or the third cut in an accelerating run. One crack per cut, not per shot element.
2. **A snap arrival** — a graphic, a title or a subject that *stops hard*: a card that slams into position, a snap zoom or scale jump completing in ≤4 frames, a punch-in that lands, a freeze. The crack goes on the frame it stops, not the frame it starts.
3. **A punchline or sudden reaction** — the comedic register the source names. Here the whip is a rimshot substitute: a beat of nothing, then the crack on the reaction frame. This use is comedic; check it against the video's register before committing.
4. **The arrival half of a whip pan** — the picture blurs and resolves inside 4–8 frames; the crack is layered under or after a whoosh.

**The frame test that decides it.** Measure the event's visible duration:

| Visible duration | Choice |
|---|---|
| ≤ 4 f (≤133 ms), or a hard cut in a fast run, or a punchline | **Whip crack** |
| 5 f | **Layer both** — whoosh body plus whip transient |
| ≥ 6 f of visible travel | **Whoosh**, owned by [[sfx-whoosh-transition-movement-reveal]] |

Use a **whoosh instead** whenever the thing is *travelling* — a slow push-in, a slide-on lower third, an object crossing frame, a soft dissolve, a camera glide. Use **nothing at all** when there is no visual event and no punchline: a whip on a straight dialogue cut is the single most common misuse, it announces the edit, and that is the opposite of invisible editing. And do not use a whip in a serious or sombre register — its cultural association is comedy and 1970s action, and it will undercut a grave line no matter how quiet you mix it.

**Frequency cap.** A whip crack is a loud, sharp, memorable event. **Two to four per video**, never two inside 3 s, or it becomes the video's most obvious tic.

## How to recognise it in a reference video
- **Look at the envelope, not the name.** Extract the effect's region and look at the waveform. A whip is **asymmetric**: peak inside the first 10–20% of its length, then decay. A whoosh is **symmetric-ish**: a rise of comparable length to its fall, peak near the middle. This is the definitive test and it does not require identifying the file.
  ```bash
  ffmpeg -i ref.mp4 -ar 48000 -af "asetnsamples=n=480,astats=metadata=1:reset=1,\
  ametadata=print:key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
  ```
  `n=480` at 48 kHz is 10 ms — a tenth of a frame at 30 fps — which is the resolution you need to see an attack.
- **Measure attack time.** From −20 dB below peak up to peak. A raw bull-whip crack reaches peak in **under 5 ms**; designed and processed cracks run to **15 ms**; a whoosh takes **60–800 ms** to build. Anything under 20 ms is a transient effect and belongs on an instant.
- **Measure total length.** Whips run **0.20–0.45 s** as placed, including tail; whooshes **0.4–3.0 s**. A "whip" over 0.6 s in the timeline is a whoosh with a bright front. (Library *files* are much longer — see below.)
- **Spectral tell.** A crack is broadband with most energy **2–8 kHz**, strong content above 4 kHz, very little below 200 Hz, and **no swept centre**. A whoosh's spectral centroid *moves* during the event — that movement is the whoosh. A "whip" with a sub-bass component has had an impact layered under it and is really a hit ([[sfx-peak-on-impact-frame]]).
- **Locate the transient relative to the picture event, and log which convention is in use.** The two conventions are different rules:
  - *Whip on a cut*: the crack's peak sits **on the cut frame, ±1 frame**.
  - *Whip pan*: the peak sits on the **blur-maximum frame**, which in a 4–8 frame pan is typically **1–2 frames before the cut**, not on it.
- **Look for the pre-swish.** Bull-whip recordings carry an audible approach before the crack. In matched work that approach occupies the **3–6 frames before** the event, which is what makes the crack feel arrived-at rather than dropped in.
- **Check for layering.** Two onsets within 2 frames — a sustained rise followed by a sharp peak — is the whoosh + whip build. Log the offset between them: typically the whoosh's peak sits **2–6 frames before** the crack, and the whoosh sits **4–9 dB under** it.
- **Level.** Measure the whip's peak against the dialogue reference. Expect **−12 to −15 dB** relative to dialogue at 0 to −3 dB; broader guidance for transition sounds is −18 to −12 dB below the dialogue reference. Judge by short-term loudness, not by peak — a crack *measures* lower than it sounds because it is so short. Anything louder than −10 dB is being used as a feature, not as punctuation.
- **Count them.** Whips are punctuation and obey the SFX density budget: more than **6 distinct effects per 10 s** tires the viewer, and repeating the identical file more than **2–3 times** is one of the three named sound-design mistakes. In a reference, count whip instances, check spacing, and check for pitch or length variation between them.
- **Register check on the transcript.** If cracks land on jokes and reactions, the video is using them as comedy punctuation; if they land on cuts in montages, as motion punctuation. Either is disciplined. A video that mixes both without pattern, or lands them on ordinary explanatory cuts, is over-applying.

## Parameters

| Parameter | Default | Range | Notes |
|---|---|---|---|
| `anchor` | cut frame | cut frame \| snap frame \| reaction frame \| blur-max frame | The **instant**, never the middle of a move. If the event has a middle, you want a whoosh. |
| `event_len_for_crack` | ≤4 f | 2–6 f | The visible duration that earns a crack. 5 f is the layer-both band; ≥6 f is a whoosh. |
| `transient_offset` (cut) | 0 f | −1 to +1 f | Crack peak relative to the cut frame. **The two source conventions disagree and the condition is which risk you are avoiding.** Perceptually, late is safer: sound-lead is detected from ~45 ms (1.4 f), sound-lag only from ~125 ms (3.7 f), so 0 to +1 f is the safer default on any cut you are unsure of. The 0 to −1 f convention applies where the crack is the *only* marker of a fast cut in a rapid run — there a lagging punctuation mark reads as a miss even inside the detection threshold. Never outside ±1 f either way. |
| `transient_offset` (whip pan) | 0 f from blur max | −1 to +1 f | For a 6-frame pan the blur maximum is usually 1–2 f before the cut, so this typically places the crack *before* the cut frame. Anchor to the blur, not to the seam. |
| `sync_tolerance` | ±0.5 f (±17 ms) | ±0.25 to ±1 f | Transients should line up to within a quarter to a half frame or they flam against production audio. |
| `attack` | 8 ms | 3–15 ms | −20 dB below peak up to peak. Raw bull-whip takes come in under 5 ms; above 20 ms it is not a whip. |
| `total_len` | 0.30 s (9 f) | 0.20–0.45 s | As placed, including tail. Over 0.6 s it is a whoosh. |
| `pre_swish_window` | 4 f (0.133 s) before | 3–6 f | How much of the file's approach to keep in front of the crack. Trim so the approach occupies exactly this. |
| `tail_after_crack` | 0.25 s | 0.15–0.50 s | Trim the rest. Whip recordings run **1.3–1.8 s** and most of that is unusable tail. |
| `pre_roll_trim` | measured | 0–0.40 s | The file's own air/approach before the crack. On bull-whip takes the crack sits **0.20–0.40 s** in. **Always measured and removed with a media offset**, never assumed to be zero. |
| `level` | −13 dB (`data-volume="0.224"`) | −10 to −15 dB | Against dialogue at 0 to −3 dB. Transition-sound guidance is −18 to −12 dB below the dialogue reference. Never the loudest thing in the video. |
| `hpf` | 90 Hz | 80–100 Hz | Clears the low end so the crack does not muddy the voice. |
| `presence_boost` | +2 dB @ 3 kHz | 0 to +3 dB, Q 1 | Only if the crack is dull. **Do not** boost 2–5 kHz while the presenter is speaking. |
| `pitch` | 0 st | −4 to +4 st | Down = heavier, harsher, more cinematic; up = lighter, faster, more comedic. The main variation knob. |
| `layer_with_whoosh` | optional | — | Whip-pan build: whoosh peak **2–6 f before** the crack, whoosh body ending on the anchor, at **−6 dB below the crack** (range −4 to −9 dB). Makes the event feel like a movement rather than a click. |
| `whoosh_len` | 0.45 s | 0.30–0.60 s | Match the whoosh's body to the pan's length; its peak sits at the fastest moment of the move. |
| `whoosh_lead` | 0.015 s | 0.010–0.020 s | Start the whoosh 10–20 ms before the camera move begins. |
| `blur_frames` | 5 f each side | 3–8 f | Whip-pan blur-out on A and blur-in on B; direction, speed and colour temperature must match to disguise the cut. |
| `uses_per_video` | 3 | 2–4 | Above four and the whip becomes the video's signature by accident. |
| `min_spacing` | 3 s | 2–8 s | Never two cracks inside 3 s. |
| `repeat_limit` | 2 per file | 1–3 | Then vary by pitch, length or reverb. Repeating one file is a named sound-design mistake. |
| `density_ceiling` | 6 per 10 s | 3–8 | Whips count against the general SFX budget. |
| `ducking` | none | none | Too short to duck. Move the crack off a stressed syllable instead. |
| `register` | comedic/action | — | Do not deploy in a sombre or authoritative register at any level. |

## Reproduction prompt

```
Decide between a whip crack and a whoosh for the picture event at {{T_EVENT}}
(seconds, 30fps composition), then place the chosen effect.

1. CLASSIFY THE EVENT. Measure its visible duration in frames from the cut
   list or by stepping frames.
     <= 4 frames, or a hard cut inside a fast run, or a punchline -> WHIP
     >= 6 frames of visible travel  -> WHOOSH; stop here and use the whoosh
        rule instead.
     5 frames -> layer both: whoosh body + whip transient.
   If there is no visual event and no punchline at all, place nothing.
2. CHECK THE REGISTER. If the surrounding tone is sombre, authoritative or
   emotional, do not place a whip; its association is comedic and old-school
   action. No level setting fixes this.
3. FIND THE ANCHOR FRAME.
     hard cut    -> the cut frame
     snap zoom   -> the frame the scale change completes
     whip pan    -> the frame where motion blur is greatest (step frames; it
                    is usually 1-2 frames BEFORE the cut)
     punchline   -> the first frame after the last word of the line
   Call it ANCHOR.
4. FETCH 3 CANDIDATES - a set, not one file, because the repeat limit is 2-3
   uses before a variation is required.
     SearchSoundEffects { query:{term:"whip crack fast"},
       filter:{ tagSlugs:{matchType:ALL,values:["weapons--whip"]},
                duration:{min:200,max:2000} }, first:8 }
   Prefer a title containing "Short" or "Single ... Whip Crack". Avoid
   "Twirl" and "Swish" (those are sweeps with a crack buried in them) - the
   word "whip" in a title does not guarantee a crack. DownloadSoundEffect,
   WAV.
5. MEASURE THE FILE. The crack is NOT at the head:
     ffmpeg -i whip.wav -af "astats=metadata=1:reset=0.005,ametadata=print:\
     key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null
   peak_offset = (index of loudest 5 ms window) * 0.005. On bull-whip takes
   expect 0.2-0.4 s. Confirm the attack is under 15 ms and that the usable
   region is 0.20-0.45 s; if either fails, this file is a whoosh, not a whip.
6. PLACE so the CRACK'S TRANSIENT - not the file's start - lands on ANCHOR,
   keeping 4 frames of approach in front of it:
     data-media-start = max(0, peak_offset - 0.133)
     lead             = peak_offset - data-media-start
     data-start       = ANCHOR - lead
     data-duration    = lead + 0.25
     data-volume      = "0.224"
     data-audio-group = "sfx", data-track-index = 12
   Never place the untrimmed file at ANCHOR.
7. TOLERANCE: the transient must sit within half a frame of ANCHOR and never
   more than 1 frame either side. Where the crack is the only marker of a fast
   cut, bias 0 to -1 f; otherwise bias 0 to +1 f, because lag is detectable
   only from ~125 ms while lead is detectable from ~45 ms.
8. LEVEL to -13 dB against dialogue at 0 to -3 dB. High-pass at 90 Hz. No
   presence boost if the crack overlaps a word; move it off the stressed
   syllable instead.
9. OPTIONAL LAYER. If this is a whip pan or a 5-frame event, add a whoosh
   whose body ends on ANCHOR and whose own peak sits 2-6 frames BEFORE the
   crack, at data-volume "0.112" (6 dB under the crack), on track index 13.
   The whoosh carries the travel; the crack marks the arrival.
10. VARY IT. If this is the third or later use of the same file in the video,
    change the pitch by 2-4 semitones or the length before placing it.
11. AUDIT THE VIDEO. Count all whip cracks. If more than 4, or any two within
    3 s, delete the least important until both hold. Then count ALL effects in
    the surrounding 10 seconds - if more than 6, remove the least justified
    one, and consider that this whip is it.

ACCEPTANCE TEST: (a) play the event at quarter speed - the crack and the
picture change are simultaneous, you cannot order them, and the crack
coincides with the frame the picture changes or stops rather than before the
movement or after it; (b) at full speed the cut feels sharper but you are not
thinking about the sound, and with the picture hidden you can still say where
the cut is from the audio alone; (c) solo the region and confirm no audible
air before the crack; (d) no word is masked; (e) across the whole video the
crack appears no more than four times and never twice in three seconds.
```

## Execution spec

**HyperFrames (primary).** A whip is one `<audio>` clip. The whole craft is in `data-media-start` — it is what makes the *transient*, rather than the file, land on the frame. All authored time is in **seconds**; frames are a comment (1 frame at 30 fps = 0.0333 s).

```html
<!-- cut at 44.60s (frame 1338 @30fps). File carries 0.085s of air before the crack. -->
<audio id="sfx-whip-01"
       src="assets/sfx/whip-crack-01.wav"
       data-audio-group="sfx"
       data-start="44.60"
       data-duration="0.32"
       data-media-start="0.085"
       data-track-index="12"
       data-volume="0.224"
       data-fx-chain="{&quot;version&quot;:1,&quot;nodes&quot;:[{&quot;type&quot;:&quot;highpass&quot;,&quot;id&quot;:&quot;n1&quot;,&quot;label&quot;:&quot;Clear Low End&quot;,&quot;params&quot;:{&quot;frequency&quot;:90,&quot;q&quot;:0.707,&quot;poles&quot;:&quot;2&quot;}}]}"></audio>
```

A bull-whip take, where the crack is buried a third of a second into the file, and its optional sweep:

```html
<!-- whip pan at 21.5 s; blur max measured 2 frames before the cut = 21.433 s -->
<!-- file peak (the crack) measured at 0.310 s; keep 4 f (0.133 s) of approach -->
<audio id="sfx-whip-02" src="assets/audio/sfx/bullwhip-short-crack.wav"
       data-audio-group="sfx"
       data-media-start="0.177"
       data-start="21.30"
       data-duration="0.383"
       data-track-index="12" data-volume="0.224"></audio>

<!-- optional sweep under it, body landing on the same frame -->
<audio id="sfx-whip-02-air" src="assets/audio/sfx/whoosh-short-dry.wav"
       data-audio-group="sfx" data-start="21.13" data-duration="0.35"
       data-track-index="13" data-volume="0.112"></audio>
```

Contract details: every `<audio>` needs an **`id`** — an id-less audio element is never mixed and the render is silent with no warning. `data-volume` is linear gain with `1` = 0 dB; `0.224` ≈ −13 dB, `0.251` ≈ −12 dB, `0.112` ≈ −19 dB. Put the whip in an `sfx` group, **never** in the `voiceover` group — a non-voice clip inside the carve group silently poisons the next carve re-analysis. Give the crack and its sweep **different** track indices in the 12+ band (`duplicate_audio_track` is a real failure when two overlapping clips share one). FX chain order is signal order and out-of-range params are clamped on read; a `limiter`, if you add one, goes last.

**Pitch is not an in-composition operation.** There is no pitch attribute, and `data-playback-rate` is *pitch-preserved* — it changes duration without changing pitch, which is the opposite of what the "lower the pitch for weight" advice wants. Bake pitch variants with ffmpeg (below) and place them as separate files.

**Timing to a visual event.** There is no audio-follows-animation attribute: the tween's timeline position and the `<audio data-start>` are the same number written twice. If the visual snap lives inside a **sub-composition**, the root-level audio needs `data-start = scene_local_t + the slot's data-start`. Relative timing (`data-start="el-card + 0.1"`) can express that, but has four silent-zero failure modes — **spaces around the operator are mandatory**, an unresolved id resolves to `0`, a target with no resolvable duration lands on its *start*, and a cycle resolves to `0`; nothing in lint checks any of them. Author literal seconds unless you have a reason not to, and `snapshot` to verify if you do.

**If the whip is sounding a shader or CSS transition**, remember the transition's own timing: the registry's `zoom-through` defaults to `0.4 s` and `squeeze` to `0.4 s`, and the injector pulls the incoming clip's `data-start` earlier by the transition duration to create the overlap. The anchor frame for the crack is the **midpoint of that overlap**, not the original cut point — read the post-injection numbers, not the pre-injection ones.

**ffmpeg.** Four real operations here.

```bash
# 1. find the transient at crack resolution: 5ms windows (finer than for a whoosh,
#    because a crack's peak is genuinely only a few milliseconds wide)
ffmpeg -i whip.wav -af "astats=metadata=1:reset=0.005,ametadata=print:\
key=lavfi.astats.Overall.Peak_level:file=-" -f null - 2>/dev/null

# 2. bake a pitched variant (asetrate+atempo is the cheap way; rubberband keeps length)
ffmpeg -i whip.wav -af "asetrate=48000*0.891,aresample=48000,atempo=1.1225" whip.down2st.wav
ffmpeg -i whip.wav -af "asetrate=48000*1.18,aresample=48000" whip.up3.wav   # comedic

# 3. sharpen a soft take
ffmpeg -i whip.wav -af "highpass=f=250,acompressor=threshold=-18dB:ratio=6:attack=0.5:release=60" whip.sharp.wav

# 4. physically trim the pre-roll if you would rather not carry a media offset
ffmpeg -i whip.wav -ss 0.085 -c copy whip.trimmed.wav
```
`asetrate=48000*0.891` is −2 semitones (`2^(-2/12)`), with `atempo` restoring the original length. Keep scratch files **outside** the vault mount, which cannot delete files. Ledger anything you keep: `node <SKILL_DIR>/scripts/resolve.mjs --from whip.down2st.wav --type sfx --project .`

**Epidemic Sound (MCP).** Verified live (2026-08-27):

| Want | Query | Filter | Real results |
|---|---|---|---|
| The crack | `whip crack fast` | `tagSlugs ALL ["weapons--whip"]`, `duration 200–2000 ms` | *Weapons, Whip, Bull Whip, **Short**, Classic Whip Crack* — **1384 ms** (best) · *Bull Whip, Overhead, **Single** Classic Whip Crack* — 1509 ms · *Bull Whip, Close Distance, **Whoosh, Twirl*** — 1827 ms (this one is a sweep, not a crack — avoid) |
| Swish-with-whip character | `swish stick swing through air whip fast` | `tagSlugs ALL ["swooshes--swish"]`, `duration 300–2000 ms` | *Swooshes, Swish, Stick, Plastic, Swipe, Swing Through Air, Whip, Fast* — 1711 ms · *Swish, Cane, Whip, Swish Through Air* — 1812 ms |
| Layer partner | `designed transition whoosh short` | `tagSlugs ANY ["swooshes--whoosh","designed--whoosh"]`, `duration 200–1500 ms` | *Designed, Whoosh, Noise Classic, Harsh, Dry* — 996 ms · *Swooshes, Whoosh, Short, Low, Dry* — 1464 ms |
| Comedic register | `cartoon whip swish comedy` | — | Cartoon shelf rather than weapons; pitch up rather than down. |
| Build a variant set | `SearchSimilarToSoundEffect { soundEffectId: "<the one that worked>" }` | — | Three related cracks are cheaper and better than pitching one three times. |

Two things to carry: **whip files are long and mostly tail** (1.3–1.8 s), so always trim with `data-media-start` rather than expecting the file to fit; and the word "whip" in a title does **not** guarantee a crack — `Twirl` and `Swish` variants are sweeps. Read the descriptors. `DownloadSoundEffect` into `assets/sfx/` or `.media/audio/sfx/`.

**Remotion:** conceptually `<Sequence from={anchorFrame - Math.round((peakOffset - mediaStart)*fps)}><Audio src={whip} startFrom={Math.round(mediaStart*fps)} volume={0.224} /></Sequence>`; no Remotion runtime exists in this project.

## Pairs with
[[sfx-whoosh-transition-movement-reveal]] · [[sfx-whip-on-punchline]] · [[sfx-peak-on-impact-frame]] · [[sfx-peak-on-the-cut]] · [[sfx-av-sync-binding-window]] · [[sfx-placement-discipline]] · [[sfx-unsounded-motion-audit]] · [[sfx-motion-sound-selection]] · [[motion-snap-zoom-punch]] · [[motion-whip-pan-transition]] · [[cut-full-screen-transition]] · [[cut-movement-match]] · [[cut-jump-cut-take-repair]] · [[cut-smash-cut]] · [[cut-punch-in-emphasis]] · [[sfx-cartoon-comedy-family]] · [[sfx-cinematic-hit-emphasis]] · [[sfx-record-scratch-punctuation]] · [[struct-presenter-aside-pattern-interrupt]] · [[sfx-ten-family-catalogue]]

## Failure modes
- **Placing the file, not the transient.** Library files carry 40–400 ms of air, and bull-whip takes hide the crack 200–400 ms in. Without measuring, the crack lands a third of a second late — well past the detection threshold — even though the clip starts exactly on the frame. Fix: measure the peak offset and remove it with `data-media-start`.
- **Whip on a glide.** A crack on a slow push-in has nothing to mark; the sound is over while the picture is still travelling, so it reads as early even though it is on the right frame. Fix: whoosh above 6 frames, whip for arrival.
- **A whoosh on a two-frame cut.** The sweep's body straddles the seam and blurs it. Fix: use a crack.
- **Keeping the whole file.** 1.5 s of whip tail over the next shot is the single most recognisable stock-drop-in in short-form editing. Fix: trim to peak + 0.25 s.
- **Whip on every cut.** Punctuation on every sentence stops being punctuation; the source's own named mistake is a tick every other second tiring the viewer within two or three minutes. Fix: two to four per video, never two inside 3 s, and a density ceiling of ~6 effects per 10 s.
- **The same file five times.** Repeating one sound is one of the three named sound-design mistakes and is instantly noticeable. Fix: three variants, or pitch/length variation.
- **Whip in a serious register.** Its cultural association is comedy and old-school action; on a sombre line it reads as a mistake at any level. Fix: use a soft hit, a tone, or nothing.
- **Reaching for a whip to make an action beat feel *real*.** The whip is a genre reference, not a realism tool — the "creates realism" claim in the source belongs to Foley (footsteps, cloth, a door creak), not to the whip. A whip on a real physical impact makes it read as pastiche. Fix: build realism from Foley and diegetic layers; if the beat also needs punctuation, layer a designed whoosh-plus-transient hybrid rather than a literal whip sample.
- **Whip-pan anchored to the cut instead of the blur peak.** Reads a frame or two late in exactly the way that is hardest to diagnose by ear. Fix: step frames, find the blur maximum, and anchor there — in a 6-frame pan that is 1–2 frames before the seam.
- **Low end left in.** An unfiltered whip has energy under 200 Hz that muddies the voice on the same frame. Fix: high-pass at 80–100 Hz.
- **Boosting presence under speech.** A +3 dB lift at 3 kHz on a whip that overlaps a word competes directly with consonant intelligibility. Fix: no presence boost while the presenter speaks; move the crack off the stressed syllable instead.
- **Trying to pitch it in the composition.** `data-playback-rate` is pitch-preserved; there is no pitch parameter. Fix: bake the variant with ffmpeg and place it as its own file.
- **Known gap:** no standards body publishes attack-time or placement figures for whip effects specifically. The attack, length and spectral numbers here are house calibration consistent with the published whoosh guidance (400–500 ms bodies, 10–20 ms lead, −18 to −12 dB against dialogue) and with the transient-alignment convention of a quarter to a half frame. Measure a reference and prefer its numbers.
- **Known gap:** the transition catalogue's whip-pan implementation (`css-*.md` / shader `whip pan`) is **not staged in this project** — only the name is known. Do not emit code for it; name it, and take the actual overlap timing from the composition after the transition is applied.
