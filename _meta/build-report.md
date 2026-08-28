---
name: build-report
description: Integrity report for the rule-note library. Second full pass, run after the index layer was built. Supersedes the 2026-08-28 report.
type: report
supersedes: "build-report (first pass, 298 notes)"
generated: 2026-08-28
---

# Build report — library integrity check (pass 2)

Re-run against `skills/EDITING/rules/`, `skills/MOTION/rules/`, `skills/SOUND-DESIGN/rules/`, `skills/SUBTITLES/rules/`, plus the new index layer.

**This report supersedes the previous one.** That pass found **298 notes** and ten issues, seven of which are now closed. The library has grown to **327 notes**, the filing and identity problems that dominated the first report are gone, and the routing problem that motivated this pass — ISSUE-9, "no router links a single rule note; a wrong tag makes a note unreachable" — has been fixed by adding a browsable `INDEX.md` per library plus a vault map.

**Headline: every hard invariant now holds.** Counts agree, ids are unique, every wikilink resolves, every note is structurally complete, every tag is in the taxonomy. What remains is a documentation gap in the execution contract and a set of editorial judgement calls.

---

## What changed since the last report

| Previous | Status | Detail |
|---|---|---|
| ISSUE-1 — 6 colliding note ids (12 notes) | **CLOSED** | 327 unique ids, and every id equals its filename. |
| ISSUE-2 — 48 notes filed against their `skill:` key | **CLOSED** | 47 were resolved before this pass; the last one, `sub-emphasis-caption-three-words`, was found in `skills/MOTION/rules/` during this pass and **moved to `skills/SUBTITLES/rules/`**. See "Changes made by this pass". |
| ISSUE-3 — 42 `sfx-*` notes shadowing the sound library | **CLOSED** | No `sfx-*` note sits outside `skills/SOUND-DESIGN/`. |
| ISSUE-4 — `EditRecording` / `PollEditRecordingJob` / `DownloadRecordingEdit` undocumented | **CLOSED** | `execution-contract.md` §5A now documents all sixteen Epidemic MCP tools, read off the live schemas. All 16 are cited by notes; all 16 are in the contract. |
| ISSUE-5 — 51 sound notes with 2–3 style tags | **MOSTLY CLOSED** | Down to **2**, and both are the classification notes themselves. Now ISSUE-B below. |
| ISSUE-6 — analysis toolchain undocumented | **PARTLY CLOSED** | §7A now documents `scdet`, `silencedetect`, `astats`, `aspectralstats`, `ebur128`, `loudnorm`, `showspectrumpic`, `showwavespic` and `librosa`. The **media-manipulation** filters are still undocumented. Now ISSUE-A below — the largest remaining issue. |
| ISSUE-7 — SUBTITLES holds only 9 notes | **CLOSED** | 52 notes across 21 families. No longer the outlier. |
| ISSUE-8 — 3 dangling wikilink targets | **CLOSED** | 5,708 wikilinks scanned across notes, indexes and routers. Zero unresolved. |
| ISSUE-9 — routing is entirely tag-driven | **CLOSED** | Five index documents added; each router now points at its index in the opening lines and in the Routing table. See "The index layer". |
| ISSUE-10 — regex fragments rendering as wikilinks | **CLOSED** | No unresolved link targets remain, so no code-fence fragment is resolving as a broken link. |

### Changes made by this pass

Three, all recorded here rather than assumed:

1. **`skills/SOUND-DESIGN/rules/sfx-ducking-keyframed-dip.md` — frontmatter would not parse.** Its `title:` contained an unquoted `": "`, which is a YAML mapping delimiter. The whole frontmatter block therefore failed to load, meaning the note had **no tags, no id and no skill as far as any tool was concerned** — invisible to every Dataview query in every router. Fixed by quoting the title. No other character changed. This is worth noting because it is exactly the ISSUE-9 failure mode in its most extreme form, and it was not detectable by any check the previous report ran.
2. **`sub-emphasis-caption-three-words` moved** from `skills/MOTION/rules/` to `skills/SUBTITLES/rules/`. Its `skill:` key, its `skill/subtitles` tag, its `sub-` id prefix and its `caption-style` type all said subtitles; only the directory disagreed. Wikilinks are id-based, so nothing broke.
3. **The index layer added** — `skills/EDITING/INDEX.md`, `skills/MOTION/INDEX.md`, `skills/SOUND-DESIGN/INDEX.md`, `skills/SUBTITLES/INDEX.md`, `INDEX.md` — and one line plus one Routing row added to each of the four `SKILL.md` routers. The routers were not otherwise edited.

---

## 1. Counts per skill — both measures now agree

| Skill | Notes in its `rules/` directory | Notes that declare `skill:` it | Gap |
|---|---|---|---|
| editing | 81 | 81 | **0** |
| motion | 57 | 57 | **0** |
| sound-design | 137 | 137 | **0** |
| subtitles | 52 | 52 | **0** |
| **total** | **327** | **327** | **0** |

The headline finding of the previous report is closed. Every note is filed in the directory its own frontmatter claims. Each `INDEX.md` declares the same count in its own frontmatter and lists exactly that many rows.

## 2. Identity

| Check | Result |
|---|---|
| Duplicate ids anywhere in the vault | **none** — 327 ids, 327 distinct |
| `id:` disagreeing with its filename | **none** |
| Declared `aliases:` | 22, all distinct, none colliding with an id |

## 3. Link integrity

| Check | Result |
|---|---|
| Wikilinks scanned (notes + 5 indexes + 4 routers + README) | **5,708** |
| Distinct targets | 337 |
| **Unresolved** — no matching id, alias or vault page | **0** |

Every `[[link]]` in the rule library, the indexes and the routers lands on something.

Widening the scan to the **supporting documents** finds two dangling example links, both outside the rule library and both cosmetic but worth a one-line fix: `_templates/design-cuts.md` line 32 cites `[\[cut-hard\]]` in its worked example row (the note is `cut-straight-hard-cut`), and `_meta/pipeline.md` line 53 cites `[\[cut-j-cut\]]` in prose (the note is `cut-j-audio-leads-picture`). Every other unresolved target in the supporting documents is an intentional `{{PLACEHOLDER}}` or an ellipsis stub in a template. Logged as ISSUE-G.

Five notes have **no inbound link from any other note** — they are reachable through the indexes and their tags, but nothing cites them, which usually means either a genuinely isolated technique or a missing *Pairs with* entry: `struct-numeric-like-goal-cta`, `motion-particle-ambient-layer`, `sfx-continuous-bed-and-silence-drop`, `sfx-layer-subset-by-format`, `sfx-music-source-and-search-budget`.

## 4. Note completeness

| Check | Result |
|---|---|
| Notes with all nine sections (H1 + the eight `##` sections) | **327 / 327** |
| Reproduction prompt present, fenced, and ≥ 80 words | **327 / 327** |
| Reproduction prompt carrying an explicit acceptance test | **327 / 327** |
| Reproduction prompt length | min 180 words · median 354 · max 865 |

No note is a stub. The note *quality* finding from the previous report holds: the library's problems have never been in the notes themselves.

## 5. Tag conformance

| Check | Result |
|---|---|
| Tags outside `_meta/tags.md` | **none** |
| Notes with exactly one `skill/` tag, matching the `skill:` key | **327 / 327** |
| `type:` key present in the tag list, exactly once | **327 / 327** |
| `family:` and `difficulty:` keys present in the tag list | **327 / 327** |

The vocabulary is genuinely closed. One structural caveat is discussed as ISSUE-C: `family/` is over-fragmented against its own coining rule.

## 6. Sound-design — styles

| Style tag | Notes carrying it (within `skill: sound-design`) |
|---|---|
| `sfx/diegetic` | 32 |
| `sfx/motion` | 21 |
| `sfx/aesthetic` | 33 |

That is 86 tags on 82 notes. Breaking the 137 sound-design notes down:

| | Notes | Reading |
|---|---|---|
| Exactly one `sfx/` style | **80** | Correct. |
| Two or three `sfx/` styles | **2** | Both are `type/sfx`. See ISSUE-B. |
| No `sfx/` style | 55 | 27 `type/music` and 12 `type/mix` — correct, these are not sound effects. 13 `type/sfx`, 2 `type/structure` and 1 `type/retention` — see ISSUE-B. |

**Requested check — does any `type/sfx` note carry more than one style tag?** **Yes, two:** `sfx-ten-family-catalogue` and `sfx-two-taxonomies-of-sound`, each carrying all three. Both are the classification notes themselves — the catalogue that maps ten families onto three styles, and the note that reconciles the two competing taxonomies — so carrying all three is arguably correct and arguably an abuse of a tag that `tags.md` defines as exclusive. It needs a human ruling, not a script. Down from **51** violations in the previous report.

## 7. Execution-spec sampling — 10 notes

Ten Execution specs sampled across all four skills (`struct-cross-cutting-parallel-action`, `struct-numeric-like-goal-cta`, `struct-demand-hook-competence-gap`, `motion-list-item-marker-card`, `motion-particle-ambient-layer`, `sfx-highlight-sound-on-emphasis`, `sfx-heartbeat-tension-dial`, `sfx-vocal-track-for-narration-free-montage`, `sub-per-word-pop-scale-colour`, `sub-single-word-topic-card`), and every cited API checked against `_meta/execution-contract.md`.

| Surface | Result |
|---|---|
| **Epidemic Sound tool names** | **10/10 clean.** Every tool cited in the sample is documented in §5A. Extended vault-wide: all **16** tools are cited by at least one note, and all 16 are in the contract. `EditRecording` (20 notes), `PollEditRecordingJob` (15) and `DownloadRecordingEdit` (13) — the previous ISSUE-4 — are now fully documented. |
| **HyperFrames data attributes** | **10/10 clean.** Vault-wide, 36 distinct `data-*` attributes are cited and **all 36** appear in §3. The only apparent miss, `data-store`, is prose in `sfx-track-shortlist-library` ("this is a data-store pattern"), not an attribute. |
| **Transition names** | clean — only registry names (`crossfade`) appear. |
| **ffmpeg filters** | **6 of 10 sampled notes cite at least one filter absent from the contract**: `drawtext`, `rotate`, `afade`, `acrossfade`, `atempo`, `asetrate`, `amix`, `atrim`. See ISSUE-A. |

## 8. Issues remaining, by severity

| # | Severity | Issue | Scope |
|---|---|---|---|
| ISSUE-A | **HIGH** | 31 ffmpeg filters are cited in Execution specs but appear nowhere in `execution-contract.md` | **152 notes** |
| ISSUE-B | MEDIUM | 15 `type/sfx` notes do not carry exactly one style tag — 2 carry all three, 13 carry none | 15 notes |
| ISSUE-C | MEDIUM | `family/` is fragmented well past its own coining rule: 95 of 141 families hold fewer than three notes | 141 families |
| ISSUE-D | LOW | 13 non-sound-design notes carry `sfx/` style tags, which `tags.md` scopes to "sound notes only" | 13 notes |
| ISSUE-E | LOW | 5 notes have no inbound wikilink from any other note | 5 notes |
| ISSUE-F | LOW | `_profiles/` and `_projects/` are empty — the pipeline has never been run end to end | 2 directories |
| ISSUE-G | LOW | 2 dangling example wikilinks in supporting documents — `[\[cut-hard\]]` in a template, `[\[cut-j-cut\]]` in the pipeline | 2 documents |

### ISSUE-A — the ffmpeg surface is still half-documented (HIGH)

The previous pass fixed the **analysis** half. §7A now documents, and in most cases verifies by execution, the measurement filters: `scdet`, `silencedetect`, `astats`, `aspectralstats`, `ebur128`, `loudnorm`, `showspectrumpic`, `showwavespic`, plus `librosa`. §7 documents the basic media operations: trim, `crop`, `scale`, `concat`.

The **manipulation** half is missing entirely. These filters are cited in Execution specs and appear nowhere in the contract:

| Filter | Notes citing it | Filter | Notes citing it |
|---|---|---|---|
| `asetrate` | 50 | `setpts` | 8 |
| `aresample` | 47 | `subtitles` | 8 |
| `atempo` | 43 | `alimiter` | 7 |
| `afade` | 35 | `xfade` | 5 |
| `acrossfade` | 22 | `boxblur` `pad` `gblur` `drawtext` `rotate` | 4 each |
| `rubberband` | 21 | `tblend` `vignette` | 3 each |
| `amix` | 16 | `equalizer` `afftdn` `acompressor` | 2 each |
| `atrim` | 15 | `zoompan` `agate` `stereotools` `arnndn` `amerge` | 1 each |
| `eq` | 13 | `adelay` 11 · `aecho` 10 · `areverse` 9 | |

**152 of 327 notes** (86 sound-design, 31 editing, 24 motion, 11 subtitles) depend on at least one of them. This matters more than a documentation tidy-up: `rubberband` is **not** in a default ffmpeg build, and 21 notes assume it. `subtitles` needs libass. The contract's own stated purpose is that "anything not in here is not known to run" — so by the vault's own house rule, 46% of Execution specs currently cite something not known to run. The fix is a §7B written the way §7A was: run each filter in this container, mark it verified or unverified, and state the build flags it needs.

### ISSUE-B — the sound-effect style rule still has 15 exceptions (MEDIUM)

`tags.md` says: *"Every sound-effect note is exactly one of these."* Fifteen `type/sfx` notes are not.

- **Two carry all three:** `sfx-ten-family-catalogue`, `sfx-two-taxonomies-of-sound`. These are the classification notes. Either grant them a documented exemption in `tags.md`, or re-type them (`type/structure` would be defensible) so the rule stays absolute.
- **Thirteen carry none:** `sfx-library-build-and-taxonomy`, `sfx-library-quality-gate`, `sfx-name-before-search`, `sfx-onomatopoeia-to-search-term`, `sfx-peak-offset-measurement`, `sfx-placement-discipline`, `sfx-real-vs-invented-sound-rule`, `sfx-repetition-variant-rotation`, `sfx-search-vocabulary`, `sfx-source-licensing-and-clearance`, `sfx-three-types-classification`, `sfx-variation-set-generator`, `sfx-vocabulary-llm-expansion`. Every one is a **process** note — how to name, search, source, license, vary or place a sound — rather than a note about a sound. They are genuinely style-independent, and `skills/SOUND-DESIGN/INDEX.md` files them under **Craft and workflow**. The clean fix is a taxonomy amendment, not a tagging pass: say that `type/sfx` notes about *process* carry no style, or introduce `type/sfx-workflow`.

Either way the current state is that the rule as written is false, and the exceptions are all sensible. Fix the rule, not the notes.

### ISSUE-C — family fragmentation (MEDIUM)

`tags.md`: *"Coin a new family only when three or more notes will share it."* **95 of 141 families hold fewer than three notes; 65 hold exactly one.**

| Skill | Notes | Families | Singletons |
|---|---|---|---|
| editing | 81 | 42 | 25 |
| motion | 57 | 31 | 18 |
| sound-design | 137 | 70 | 44 |
| subtitles | 52 | 21 | 6 |

Subtitles, the newest library, is the only one close to the rule — which suggests the fragmentation is accumulated drift rather than a deliberate choice. There are also near-duplicate slugs that should almost certainly merge:

| Probable duplicates | Where |
|---|---|
| `music-transition` / `music-transitions` | sound-design |
| `placement` / `sfx-placement` | sound-design |
| `sync` / `sync-placement` / `motion-sync` | sound-design and motion |
| `intimate-sounds` / `intimate-sfx` / `intimacy` | sound-design |
| `hit-impact` / `impact` | sound-design |
| `comedy-sfx` / `cartoon` | sound-design |
| `fade` / `fade-dissolve` | editing |
| `diegetic-sfx` / `diegetic-convention` | sound-design |

This is not a correctness bug — the indexes render fine and every note is reachable — but it makes family a weak grouping in exactly the library where grouping matters most. A merge pass on sound-design alone would take 70 families to roughly 45.

### ISSUE-D — `sfx/` tags outside the sound library (LOW)

`tags.md` scopes `sfx/` to "sound notes only". Thirteen notes in `skills/EDITING/` and `skills/MOTION/` carry style tags anyway — `motion-sfx-pass-manifest`, `motion-silent-motion-tier`, `motion-snap-zoom-punch` and `motion-abstract-object-sound-contract` carry two each. This is defensible cross-referencing: these are precisely the notes that hand a motion event to the sound pass, and the tag makes them findable from the sound side. But it contradicts the taxonomy as written, and five of them carry two styles, which no note is supposed to. Decide whether the scoping line means "sound-design notes only" or "notes about a sound", and write down which.

### ISSUE-E — five uncited notes (LOW)

`struct-numeric-like-goal-cta`, `motion-particle-ambient-layer`, `sfx-continuous-bed-and-silence-drop`, `sfx-layer-subset-by-format`, `sfx-music-source-and-search-budget`. All five are reachable from their index and their tags, so this is not a routing failure any more. It is a signal that their neighbours' *Pairs with* sections are incomplete, and each is worth one look.

### ISSUE-G — two dangling example links outside the rule library (LOW)

`_templates/design-cuts.md` line 32 → `[\[cut-hard\]]`, should be `[[cut-straight-hard-cut]]`. `_meta/pipeline.md` line 53 → `[\[cut-j-cut\]]`, should be `[[cut-j-audio-leads-picture]]`. Left unfixed deliberately: both sit in documents this pass was not asked to edit, and the template one may have been written before the id settled. Two-minute fix, and worth doing because the template's broken link is copied into every design document made from it.

### ISSUE-F — the pipeline has never been run (LOW)

`_profiles/` and `_projects/` are empty. Every stage-1-to-5 claim in `_meta/pipeline.md`, and every design-document template, is untested against a real reference set. This is the single biggest unknown about the vault, and no static check can close it.

---

## The index layer

Added by this pass, and the reason ISSUE-9 is closed.

| Document | What it does |
|---|---|
| `INDEX.md` | The whole-vault map: four libraries with counts and links, the six `_meta` documents with a line each, the seven templates, the five pipeline stages, the stack, and a "where to go next" table. |
| `skills/EDITING/INDEX.md` | 81 notes, 42 families, 8-note start-here path. |
| `skills/MOTION/INDEX.md` | 57 notes, 31 families, 8-note start-here path. |
| `skills/SOUND-DESIGN/INDEX.md` | 137 notes grouped by the three styles then by family, with music, mix and craft in their own sections, the complete ten-family catalogue, and an 8-note start-here path. |
| `skills/SUBTITLES/INDEX.md` | 52 notes, 21 families, 8-note start-here path. |

Each router now carries a **Browse instead of query** line under its H1 and an INDEX row at the top of its Routing table. Nothing else in the routers was changed.

The indexes are generated from the notes' own frontmatter, so they are only as correct as the frontmatter — which is the point of running the integrity check over both. Regenerate them whenever notes are added, and re-check that each `INDEX.md` frontmatter `count` still matches its directory.

---

## What a human should review first

1. **Write §7B of the execution contract — the ffmpeg manipulation filters (ISSUE-A).** 152 notes depend on 31 filters the contract does not mention, and at least two of them (`rubberband`, `subtitles`) need build flags an ordinary ffmpeg does not have. Do it the way §7A was done: execute each in this container, mark verified or unverified, state what breaks. This is the only remaining issue that can make a spec fail at build time.
2. **Rule on the sound-effect style tag (ISSUE-B).** Fifteen `type/sfx` notes break a rule that `tags.md` states absolutely, and all fifteen look right as they are. Amend the taxonomy — carve out process notes, and decide whether the two classification notes get an exemption — rather than re-tagging good notes to fit a rule that was written before they existed.
3. **Run the pipeline once, end to end (ISSUE-F).** Profile one reference set and design one video. `_profiles/` and `_projects/` are empty, so nothing downstream of the rule notes has ever been exercised: not the templates, not the stage handoffs, not the build manifest. Every other item in this report is a static-analysis finding; this is the one that would find the things static analysis cannot.
4. **Merge the duplicate family slugs in sound-design (ISSUE-C).** Eight obvious pairs, 70 families for 137 notes. Cheap, and it makes the largest index materially easier to scan.
5. **Check the five uncited notes' neighbours (ISSUE-E)** and add the missing *Pairs with* entries.
6. **Fix the two dangling example links (ISSUE-G)** — one of them is in a template and gets copied into every design document made from it.
7. **Decide what `sfx/` scoping means (ISSUE-D)** and write the answer into `tags.md`, so the next integrity pass can check it mechanically instead of reporting it as ambiguous.

## Method

Every number in this report was computed by parsing all 327 notes' YAML frontmatter and bodies, not sampled. Wikilink resolution ran over notes, both index layers, the four routers and the README against the set of ids, declared aliases and vault page names. Tag conformance was checked against the enumerated vocabularies in `_meta/tags.md`. API coverage was checked by extracting every Epidemic tool name, `data-*` attribute, transition name and ffmpeg filter token from each note's *Execution spec* section and testing membership in `_meta/execution-contract.md`.
