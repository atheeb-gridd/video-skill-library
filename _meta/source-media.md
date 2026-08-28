---
name: source-media
description: Measured format facts for the KT reference videos, and the fps normalisation rule that depends on them.
type: reference
probed: 2026-08-27
---

# Source media facts

Measured with `ffprobe`, not assumed. Every frame count in this vault is meaningless without the fps it was measured at.

| Video | Resolution | fps | Duration | Feeds | Transcript |
|---|---|---|---|---|---|
| `assets/videos/editing kt.mp4` | 1280×720 | **60** | 14:32 (871.9s) | editing, motion | `assets/transcripts-en/editing-kt.md` |
| `assets/videos/editing kt 2.mp4` | 1280×720 | **25** | 5:44 (343.6s) | editing | `assets/transcripts-en/editing-kt-2.md` |
| `assets/videos/editing kt 3.mp4` | 854×480 | 29.97 | 8:08 (488.1s) | sound-design (music), editing | `assets/transcripts-en/editing-kt-3.md` |
| `assets/videos/sfx kt 1.mp4` | 1280×720 | 29.97 | 10:46 (646.0s) | sound-design | `assets/transcripts-en/sfx-kt-1.md` |
| `assets/videos/sfx kt 2.mp4` | 1920×1080 | 29.97 | 10:55 (655.4s) | sound-design | `assets/transcripts-en/sfx-kt-2.md` |

## The fps trap

**Three different frame rates across five references.** Rule notes in this vault state timings in frames at 30fps. If an analysis pass assumes 30fps while measuring `editing kt.mp4`, which is 60fps, **every measured duration comes out at half its true length** — a 14-frame entrance reads as 7. The same error runs the other way on the 25fps file.

So the ANALYSE stage must, without exception:

1. Read fps per file from `ffprobe` — never inherit it from another file, never assume.
2. Convert every measurement to **seconds** first, then re-express in frames at the *target* project fps, stating both.
3. Record the source fps alongside every observed parameter in the observation log.

`29.97` here is `30000/1001`, i.e. NTSC drop-frame. Over a 10-minute video that is a ~1.1s drift against a naive 30fps assumption — irrelevant for a single entrance, material when you are aligning a whole music bed. Treat 29.97 as 29.97 for timeline maths and round only at the point of authoring a frame value.

## Provenance caveat

These are 480p–1080p downloads, not camera masters. Consequences:

- **They are teaching references, not source footage.** Do not plan to cut them into a deliverable.
- **Compression artifacts read as grade.** Banding and blocking here are the encoder's, not the creator's. Do not profile "grain" or "texture" from these files.
- **Resolution-headroom rules do not transfer.** A punch-in that looks fine at 854×480 will not survive the same scale factor in a 1080 delivery. The headroom caps in the rule notes are stated against delivery resolution, which is the number that matters.
- `editing kt 3` at 854×480 is the weakest file, and it is also the one whose transcript has unrecoverable windows. Weight its evidence accordingly.

## Visual reference

`assets/frames/*-sheet.png` — a 6×5 contact sheet per video, 30 frames sampled evenly across the full duration. Generated on the device with:

```bash
ffmpeg -i "<video>" -vf "fps=1/<duration/30>,scale=300:-1,tile=6x5" -frames:v 1 "<name>-sheet.png"
```

Use these before making any claim about a reference's visual style. A claim about how something looks that was derived from a transcript alone is a hypothesis, and this vault labels hypotheses as such.

## Audio

`assets/transcripts/*.wav` holds extracted audio per video, so audio analysis does not require the mp4s. The **visuals exist only in the mp4s** — keep them until a verification pass has confirmed the recognition thresholds in the rule notes against real frames.
