---
name: projects
description: One folder per video edit. Mostly local — only the design documents are versioned.
type: readme
---

# Projects

One folder per video edit. This is where you actually work.

```
_projects/<video-name>/
├── design/
│   ├── design-cuts.md        ← versioned
│   ├── design-motion.md      ← versioned
│   ├── design-sound.md       ← versioned
│   └── design-subtitles.md   ← versioned
├── BUILD.md                  ← versioned
├── footage/                  ← local only
├── renders/                  ← local only
└── anything else             ← local only
```

## What git keeps, and why

Only `design/*.md` and `BUILD.md`. Everything else stays on your disk.

The design documents are the highest-signal thing this vault produces. A rule note claims *"a punch-in reads as emphasis at 1.25× over 14 frames"*; a design document is that claim **applied to a real video at a real timecode**. Together they are the only way to answer the question that actually matters — *did the rule work?*

They also close the loop. When an edit comes out wrong, the design document shows which decision was wrong and which rule it cited. When the same deviation shows up in three projects, that is not three mistakes — that is a rule note that needs changing.

Footage and renders are gitignored by extension, not just by path, so a stray `.mp4` anywhere in the tree can never be committed. Back those up somewhere built for large files.

## Starting a project

Copy the templates and fill them in, in order — cuts first, because everything else attaches to the timeline they define:

```bash
mkdir -p _projects/<name>/design
cp _templates/design-cuts.md      _projects/<name>/design/
cp _templates/design-motion.md    _projects/<name>/design/
cp _templates/design-sound.md     _projects/<name>/design/
cp _templates/design-subtitles.md _projects/<name>/design/
cp _templates/build-manifest.md   _projects/<name>/BUILD.md
```

The contract these implement is `_meta/pipeline.md`. Read it before filling anything in.
