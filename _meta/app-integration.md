---
name: app-integration
description: How an external app (the Electron Claude Video Editor) must mount this library so the skills' own paths resolve. Read before wiring cwd or settingSources.
type: reference
---

# Mounting this library from an app

Verified 2026-08-28 against SDK 0.3.247. Two findings: one confirmed good, one a trap.

## Confirmed: skill discovery needs `settingSources: ['project']`

`settingSources: []` hides every skill in this vault. With `['project']` and a `.claude`
directory reachable from `cwd`, all five appear in `system`/`init`:

| `settingSources` | Skills visible |
|---|---|
| `[]` | none of ours |
| `['project']` | `talking-head-editor`, `video-editing`, `video-motion`, `video-sound-design`, `video-subtitles` |

`Options.skills` is only a **filter over discovered skills** — it cannot substitute for
discovery. Discovery comes from `settingSources`.

## The trap: discovery is not resolution

**Every path inside these skills is vault-root-relative.** The loaders and
`talking-head-editor` reference:

```
_meta/pipeline.md          _meta/execution-contract.md      _meta/tags.md
_templates/design-cuts.md  _templates/style-profile.md
skills/EDITING/rules/      skills/MOTION/SKILL.md           ...
skills/EDITING/rules/      skills/MOTION/SKILL.md           ...
```

So symlinking only `.claude` into a project folder and setting `cwd` to that project makes
the skill **load and then fail**: it is told to read `_meta/execution-contract.md`, which
does not exist relative to the project.

`additionalDirectories: [libraryPath]` does **not** fix this. It grants read *permission*;
it does not change how a relative path resolves.

This fails silently and the output still looks plausible — a spec written against a contract
the model never read. That is the worst shape of bug this vault can produce.

## The fix: symlink the resolvable roots, not just `.claude`

Per project, alongside `.claude`:

```
<project>/
├── .claude      -> <library>/.claude        # discovery
├── _meta        -> <library>/_meta          # resolution
├── _templates   -> <library>/_templates     # resolution
├── skills       -> <library>/skills         # resolution
├── rules/                                   # REAL — this project's derived rules
├── _profiles/                               # REAL — not the library's
├── _projects/                               # REAL — not the library's
└── edits/
```

**`references/…` and `scripts/…` are the exception — do NOT symlink those.** Paths a
SKILL.md uses for its own bundled files resolve relative to the **skill directory**, which
the symlinked `.claude` already provides. Creating `references` or `scripts` at the project
root is unnecessary and risks shadowing. Only the *vault-root*-relative paths above need
mounting.

`cwd` stays the project folder, so design documents keep writing relative paths that land
in the project. Symlinks are read-only in practice; nothing writes through them.

**Do not** symlink `_profiles/` or `_projects/` — the library has its own and they would
collide with the project's.

## A correct mount is necessary, not sufficient

Found by the app build, 2026-08-28, and it is the more important half of this document.

With the mount correct and **both files readable**, the model invoked the skill, `cd`'d into
the skill directory, searched only there, and reported `_meta/execution-contract.md` as
nonexistent.

| Path | Resolves via |
|---|---|
| `<project>/_meta/execution-contract.md` | the `_meta` mount |
| `<skill>/../../../_meta/…` | the skill physically lives inside the vault |

Both worked the whole time. The failure was **search strategy, not wiring** — but from the
output it is indistinguishable from a broken mount, which puts it in the same silent class
as PIT-V1. Wiring the mount correctly and stopping there leaves the bug intact.

Adding this to the stage prompt, and changing nothing else, returned both headings:

> Vault-root paths (`_meta/`, `_templates/`, `skills/`) resolve from your cwd. Paths the
> skill uses for its own bundled files (`references/`, `scripts/`) resolve inside the skill
> directory. **Do not `cd`.**

`Do not cd` is the load-bearing clause. The same contract is now stated inside each skill's
own SKILL.md so it travels with the skill rather than depending on every consumer to inject
it — but a consumer that also puts it in the stage prompt is belt and braces, and worth it
given the failure is silent.

## Path mismatch to resolve explicitly

`talking-head-editor` writes its profile to `_profiles/<name>/PROFILE.md`. The app's PRD
puts it at `rules/PROFILE.md`. Both are defensible; pick one **in the stage prompt** and
state it, because the orchestrator supplies that prompt and can override the skill's
default. Silence here means two profile locations and neither authoritative.

## Reuse rather than re-derive

Two things the app is likely to rewrite from scratch that already exist, verified by
execution:

- **`references/timebase.md`** (skill-relative) — the keep-list model, `src_to_out` / `out_to_src`, and the
  invariants a `timeline.json` validator needs. Carries measured findings: stream copy
  returned **3.251 s for a requested 2.000 s**; `select`'s `between()` is inclusive on both
  ends so the frame-accurate form is `between(n, a, b-1)`; omitting `setpts` does not drift
  a cut, it **cancels** it (420 frames became 600).
- **`scripts/ingest.sh`** (skill-relative) — ffprobe of real fps, audio extraction at both 16k mono and 48k
  stereo, loudness, and silence detection for the subtractive pass. Note the trap it
  documents: `-v error` silences `silencedetect`, so the dead-air check returns `0.000`
  with no error at all.

## fps is a rational, never a decimal

`timeline.json` and every design document store **`fps_num` / `fps_den`**, not a scalar
`fps`. A parser may accept a bare integer as shorthand for `n/1`; it must never accept
`29.97`.

Reason, measured in `references/timebase.md` §4: `round(s * 29.97)` does not round-trip —
**622 of 18000** frame times at 29.97 land on the wrong frame. `round(s * 30000/1001)`
round-trips cleanly across 5,000,000 frames. Assuming 30 for a 30000/1001 file drifts
**0.599 s / 18 frames over ten minutes**, which is more than enough to put a sound cue on
the wrong word.

`timebase.md`'s reference implementation already took `fps_num`/`fps_den`; the templates
lagged behind with a scalar and were corrected on 2026-08-28. The app caught this.

## The profile stage needs a schema, not a sentence

Its exit condition — *every section has numbers, not adjectives* — is not checkable as
prose. `profile-schema.md` states it field by field: classes, blocking vs warning,
ten cross-field invariants, and the exact violation strings, with a JSON block a validator
consumes directly.

## Counts

**349 rule notes** — EDITING 81 · MOTION 79 · SOUND-DESIGN 137 · SUBTITLES 52. A
`find`-based count of `*.md` returns 359 because each library also holds `SKILL.md`,
`INDEX.md` and `_kt/` extraction notes. Only `skills/*/rules/*.md` are rule notes.
- **`scripts/transcribe.sh`** (skill-relative) — whisper.cpp wrapper for when no transcript
  is supplied. Its `--hinglish` flags are load-bearing on code-mixed sources: `-l hi` stops
  mid-file language drift, `-mc 0` kills repetition loops, `-bs 5` beats greedy decoding on
  code-mixed speech, and `-ml 140` prevents 30-second monolith cues. Re-running with these
  recovered ~12% more speech on this project's own sources. Output is **cue-level**, not
  word-level — force-align before the subtitle pass.
