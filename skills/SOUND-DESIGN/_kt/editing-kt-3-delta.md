---
source_video: assets/videos/editing kt 3.mp4
transcript: assets/transcripts-en/editing-kt-3.md
baseline_compared: earlier ASR pass (MOTION__editing_kt_3.srt)
new_sources: MOTION__editing_kt_3.en.srt, MOTION__editing_kt_3.v2.srt
primary_skill: sound-design
secondary_skill: editing
coverage: ~86% of timeline (was ~80%)
counts: 12 New, 6 Changed
---

# editing kt 3 — delta after better transcripts

## What materially improved

The two new passes rescue the video's entire back third, which is where the real music craft
lives. The baseline ended with three vague fragments after 00:06:15; we now have a complete,
mechanical account of **how to get from one track to the next** (find similar → else riser →
else beat sync), **where a track should start** (on the main beat, with the track's warm-up
trimmed off, aligned to the section boundary), and **what else gets cut to the beat**
(B-rolls, and ideally every cut). The 00:01:48-00:02:21 window turns out to hold the video's
main anti-pattern — the download-place-reject-repeat audition loop — which the baseline had
written off as "garbled banter". 00:02:31 resolves to a concrete instrument recommendation
(violin for suspense/tension) where the baseline had `[unclear]`. And 00:05:13 recovers the
*reason* the levels rule exists (music so loud the voice gets lost), which the baseline
skipped straight past to the numbers.

Two cautions in the other direction: the new passes merge 00:01:24-00:01:48 and
00:05:06-00:05:36 into long cues and **lose** detail the earlier pass had — the 100-120 BPM
personal default and the minus-3-to-0 dB / minus-22-to-minus-25 dB numbers. Those are
retained in the rebuilt transcript, marked as single-source. The 00:04:08-00:04:36 window
that the baseline flagged as a likely gap is now confirmed unrecoverable: no pass has speech
there. Given the fragment "I'll have to do SFX" at 00:04:06, one point of the ten is probably
lost in that hole.

## Delta table

| New/Changed | Timecode | Technique | Skill(s) | Verbatim quote | Gist | Research question |
|---|---|---|---|---|---|---|
| New | 00:01:54 | The audition anti-pattern: never commit a track before hearing it against the cut | sound-design, editing | "you liked a track, downloaded it, put it under the video, but it isn't going with the video, so you go back again and [unclear]" | The time sink is the download-place-reject-repeat loop. Audition candidates against the timeline first; only then download and commit. Baseline had this whole window as "30 seconds of garbled banter". | What is the fastest audition workflow — preview-in-browser against a rough cut, or batch-import 5 candidates onto muted stacked tracks and solo through them? |
| New | 00:01:54 | Instrument-hopping shown as wasted effort | sound-design | "How's this instrument? Okay, how about this one? And this one?" | On-screen montage of trying instrument after instrument; the point is that filtering by parameter beats browsing by ear. | Does filter-first (BPM + instrument + mood) measurably cut selection time vs. auditioning a playlist? |
| New | 00:02:31 | Instrument-to-emotion mapping: violin for suspense/tension | sound-design | "if you want a suspense or tension vibe, then a violin" | First concrete instrument recommendation in the video; baseline had only `[unclear]`. Sentence is truncated, so more instruments were likely named. | Full instrument-to-emotion table: what does he pair with hype, sad, funky, corporate, mysterious? Recover from the on-screen list at 00:00:57. |
| New | 00:05:06 | Build a personal saved-track library | sound-design, editing | "Whatever tracks you're liking, you can hit like and save them, so they come in handy later" | Liking/saving is framed as future-proofing, not just bookmarking — a reusable shortlist so the search cost is paid once. | Should the shortlist be organised by BPM band, by mood, or by section role (intro / mid / outro)? |
| New | 00:05:13 | The levels problem stated before the fix | sound-design | "the next problem that comes up is audio levels. In some places the music is so loud that your voice gets lost in the middle of it" | Names intelligibility of the voice as the criterion the dB numbers serve. Baseline jumped straight to the numbers with no framing. | Is a fixed music floor enough, or does this call for sidechain/auto-ducking to hold intelligibility across a varying VO? |
| New | 00:06:24 | Riser transition between tracks whose vibes do not match | sound-design, editing | "then stop the first track, put in a riser sound, and start the second track at the end of it" | The fallback when 'find similar' cannot help: hard-stop track A, bridge the seam with a riser SFX, start track B on the riser's tail. Baseline truncated to "then [unclear]". | Riser length and overlap: does track B start exactly at the riser's peak, or a beat after? |
| New | 00:06:28 | Skip the added riser if the track already has one; that is where beat sync takes over | sound-design | "if there's already a riser at the start of the music, well, that's where beat sync comes in" | Do not stack a riser on a track that already builds. Names "beat sync" as the technique. Connective is garbled in both passes. | How to tell a track's built-in intro riser from a true downbeat when reading the waveform? |
| New | 00:06:32 | Align the track's opening beat to the section boundary | sound-design, editing | "Whenever you're starting a new section, try to make the opening beat of your music line up with that section" | Music entry is placed against structure, not against the timeline ruler: new section = new track, landing on its first beat. | Does the section's first frame land on the beat, or does the beat land a few frames before the visual cut? |
| New | 00:06:38 | Trim the track's warm-up; start on the main beat | sound-design, editing | "Every track has a little warm-up at the start, ignore that and start straight from the main beat" | The single most actionable new item: almost every library track opens with ambience/build before the real downbeat. Cut it off and start from the main beat so the entry has impact. | How much do stock library tracks typically waste on intro warm-up, and does trimming it change perceived energy at the cut? |
| New | 00:06:45 | Cut B-rolls to the music's beat | editing, sound-design | "even when my B-rolls are running, I cut them to my own [music's beat]" | Beat sync is not just for section starts: B-roll changes are placed on beats too. Baseline had the verb with no subject. | Which subdivision — every beat, every 2 beats, or every bar — for B-roll changes at 100-120 BPM? |
| New | 00:07:02 | Why beat sync is worth the time | editing, sound-design | "it creates a vibe, it creates a whole flow" | The stated payoff of beat-synced cutting: perceived flow, not accuracy for its own sake. | Is there a retention effect from beat-synced cutting, or is it purely a felt-quality claim? |
| New | 00:07:04 | Provenance of the whole method | editing, sound-design | "everything I've told you so far is just my six years of hit and trial experience" plus "why do all this for music, why give music so much time?" | Frames the ten points as personal heuristics, not industry standards — useful when deciding what to codify vs. test. | Which of these ten points hold up against standard broadcast/podcast loudness practice? |
| Changed | 00:00:07 | Who struggles with music | sound-design | "YouTubers and editors struggle to find the perfect music" | Baseline had `[unclear]` for the second group. Resolved to "editors" (English pass); the v2 pass hears "writers", an ASR artifact — noted inline in the transcript. | — |
| Changed | 00:01:47 | How to test BPM against the video | sound-design, editing | "You'll only figure it out by doing it, but here's what not to do" | v2 **compresses** the earlier pass's fuller instruction ("you'll find that out by playing the music along with the video"). The fuller version is retained, since it names the actual method: play the music against the cut rather than judging the track solo. | — |
| Changed | 00:02:51 | Beat-led tracks sit best under speech | sound-design | "Music that has beats in it sits really well underneath the voice" | Present in the baseline and confirmed as real, but **absent from both new passes** — now single-source and flagged. Substance unchanged; confidence downgraded. | Why do percussive beds mask speech less than sustained/melodic ones — spectral overlap, or rhythmic gaps? |
| Changed | 00:05:25 | Monitoring caveat, now placed in context | sound-design | "Every device's drivers are different, so it sounds different on everything" | Baseline had this floating at 00:05:06 with no surrounding sense. It belongs inside the audio-levels section and is the argument for trusting numbers over ears. Single-source (earlier pass only); placement approximate. | Which reference target — headphones, phone speaker, or a meter — should the numbers be set against? |
| Changed | 00:05:30 | The dB targets | sound-design | "keep your vocals between minus 3 and 0 decibels, and the music between minus 22 and minus 25 decibels" | Substance unchanged but now **framed** by the problem it solves (00:05:13) and confirmed as single-source: the new passes lose the numbers entirely. Only the rock-guitar exception (minus 30 dB) survives in all three passes. | Are these clip-gain peak values or programme loudness? Minus 3 dB peak on vocals is hot by broadcast norms — worth flagging when codifying. |
| Changed | 00:07:49 | Outro CTA | editing | "It takes real effort to make a video, so please like, share and subscribe. Let's set a goal of two likes." | Baseline had "Do subscribe. Let's keep a goal of [unclear] likes." The number is "two" — a deliberate joke, not a real target. | — |

## Named framework: "10 points" about music

The video announces the frame at **00:00:14**: "in this video I'm going to give you 10 points
that nobody will tell you even in a paid course." Only one item is explicitly numbered on
screen or in speech — **"Then comes the fourth point, mood and vibe" (00:03:00)** — which lets
the earlier items be back-numbered with confidence: emotion/pace = 1, BPM = 2, instruments = 3,
mood and vibe = 4. Items after that are presented in sequence without numbers. The baseline
captured points 1-5 and 7-8 only, with 9 and 10 truncated to `[unclear]`.

Complete reconstruction, in the order the video presents them:

1. **Your video's emotion and pace** — 00:00:54. "the first thing you need to understand is what your video's emotion and pace are like", with an on-screen list of which music goes with which emotion (00:00:57).
2. **BPM (beats per minute)** — 00:01:07, explained 00:01:10-00:01:28. Higher BPM = faster, more energetic; fast talking wants high BPM, slow talking wants low BPM; "don't flip the two around". Personal default 100-120 BPM (00:01:35, single-source).
3. **Instruments** — 00:01:07, explained 00:02:31-00:03:00. Violin for suspense/tension; beat-led tracks sit best under the voice; searchable via Epidemic Sound's instrument filter.
4. **Mood and vibe** — 00:03:00, named explicitly as "the fourth point". "You don't figure out the vibe, you create the vibe" — the editor decides it, and the music is what controls it.
5. **Vocals versus instrumental** — 00:03:22. Vocals for epic montage / inspiring journey; the rule at 00:03:36 — vocals where your own voice is absent, instrumental where your voice is present, because vocals behind a voice "can create a bit of a conflict".
6. **[UNRECOVERABLE]** — 00:04:08-00:04:36. No pass has speech here. The fragment at 00:04:06 ("I'll have to do SFX") suggests an SFX-related point, possibly about layering SFX with or instead of music. This is the one slot of the ten that no transcript reaches.
7. **Saving/liking tracks for reuse** — 00:04:36-00:05:13. Like and save tracks so they come in handy later. (Presented as workflow; may be part of point 6 rather than a point of its own.)
8. **Audio levels** — 00:05:13-00:05:42. Named as "the next problem". Music so loud the voice gets lost; device drivers differ so it sounds different everywhere, hence use numbers: vocals minus 3 to 0 dB, music minus 22 to minus 25 dB, rock/loud guitars down to minus 30 dB.
9. **Know when to stop the music** — 00:05:42-00:06:09. Named as "the next mistake people make ... their music just keeps running through the entire video". Give the music rest; kill it for emphasis or for a serious point so all focus goes to the voice; always stop it on a peak point read off the waveform so it feels smooth rather than sudden.
10. **Transitioning between tracks** — 00:06:09-00:06:28. Change music when the section changes; use Epidemic Sound's "find similar" for a matching beat/vibe; if the vibe has changed, stop track A, insert a riser, start track B at the riser's end.
11. **Beat sync** — 00:06:28-00:07:02, named as "beat sync". Align the track's opening beat with the start of the section; ignore the track's warm-up and start from the main beat; cut B-rolls to the beat; ideally sync every cut in the video to some beat. "It creates a vibe, it creates a whole flow."

Closing rationale — 00:07:13: "Where words fail, music speaks."

Note on the count: eleven items are visible above, so either the saved-library step (7) is
part of another point, or the list as delivered does not land exactly on ten. Only item 4 is
verifiably numbered; the numbering of the rest is inferred from order.

## Music craft, consolidated

**Choosing a track.** Filter, don't browse: BPM + instrument + mood/vibe filters on Epidemic
Sound, plus the vocals/instrumental toggle. Start from the video's emotion and pace, not from
what sounds good in isolation.

**Energy matching.** BPM tracks speaking rate: fast VO wants high BPM, slow VO wants low BPM,
and inverting the two makes the video "feel really odd". Personal default 100-120 BPM for a
fast talker.

**Where music starts.** At a section boundary, on the track's main beat, with the track's
intro warm-up trimmed away. If the incoming track has no usable build, a riser carries it in.

**Where music drops out.** Deliberately and often: for emphasis, and under any serious line,
so focus transfers to the voice. Cut on a waveform peak so the stop reads as smooth, not
sudden. The named mistake is letting one track run the whole video.

**Cutting music to structure.** New section = new track. Every cut, and specifically every
B-roll change, aimed at a beat.

**Levels relative to dialogue.** Vocals minus 3 to 0 dB, music minus 22 to minus 25 dB,
minus 30 dB for loud-guitar rock. The stated criterion is that the voice must never get lost;
the stated reason for using numbers at all is that playback devices differ.

**Ducking.** Not taught. The video's answer to voice-versus-music is a static music floor
plus full drop-outs at emphasis points — no automation, keyframing, or sidechain compression
is mentioned anywhere in the recovered 86%. Worth flagging as a genuine gap in this KT rather
than a transcript loss.

**Transitions between tracks.** Preferred: "find similar" for a matching beat/vibe, which
makes the change nearly invisible. Fallback: hard stop + riser + start track B at the riser's
end. Do not add a riser to a track that already opens with one.

**Mistakes the video warns against.**
- Grabbing whatever sounds cool and dropping it under the video (00:00:10).
- Hunting randomly instead of filtering by parameter (00:01:00).
- Inverting the BPM/pace relationship (00:01:28).
- The download-place-reject-repeat audition loop (00:01:54).
- Putting a vocal track behind your own voice (00:03:36).
- Music so loud the voice gets lost (00:05:13).
- Letting music run through the entire video with no rest (00:05:42).
- Stopping the music somewhere other than a peak, so the cut feels sudden (00:06:00).
- Starting a track on its warm-up instead of its main beat (00:06:38).
- Stacking a riser onto a track that already has one (00:06:28).
