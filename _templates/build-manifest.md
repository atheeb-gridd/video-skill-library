---
name: "{{PROJECT}} — build"
description: Compiled build manifest, handed to the engines
type: build-manifest
profile: "[[{{PROFILE_NAME}}]]"
design_docs:
  - "[[{{PROJECT}} — cuts]]"
  - "[[{{PROJECT}} — motion]]"
  - "[[{{PROJECT}} — sound]]"
  - "[[{{PROJECT}} — subtitles]]"
fps: {{30}}
aspect: "{{1920x1080}}"
status: not-started
---

# Build — {{PROJECT}}

## Preflight

- [ ] All four design documents are `status: approved`
- [ ] No `{{placeholder}}` survives anywhere in them
- [ ] Every design row cites a rule note that exists
- [ ] Source media probed; fps and resolution match this manifest
- [ ] Every fetch-list row has a resolved local file

## 1 — Fetch

| # | Asset | Query | Local path | Status |
|---|---|---|---|---|

## 2 — Cut

The assembly commands, derived from `design-cuts.md`. Written out rather than improvised, so the assembly is reproducible.

```bash
{{ffmpeg commands}}
```

Output: `{{path}}`

## 3 — Compose

| Composition | Source design rows | File | Status |
|---|---|---|---|

## 4 — Mix

| Track | Contents | Gain | Ducking | Status |
|---|---|---|---|---|

## 5 — Check and render

```bash
npm run check
npm run dev      # preview
npm run render
```

- [ ] `check` clean
- [ ] Preview reviewed against the acceptance tests in `design-motion.md`
- [ ] Loudness verified
- [ ] Human approved render

> Render is user-gated. Do not render on your own initiative.

## Deviations

Anything the build did differently from the design, and why. This is the feedback loop — a deviation that recurs belongs back in a rule note or in the profile.
