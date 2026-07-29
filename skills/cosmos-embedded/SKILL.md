---
name: cosmos-embedded
description: >-
  Orchestrates the Cosmos embedded-systems harness from idea through
  architecture, hardware, firmware, manufacturing, test, and release.
  Use when starting or running an embedded product workflow, scaffolding
  docs from cosmos-embedded-systems templates, coordinating subagents /
  role skills, or when the user mentions ARCHITECTURE.md, HARDWARE.md,
  BUILD.md, MANUFACTURING.md, or cosmos-embedded-systems.
---

# Cosmos embedded harness

All harness output is **English**. Platform is never assumed: the human and the Architect lock it in `docs/ARCHITECTURE.md`.

## Doc map

| Doc | Scope | Owner role skill |
|-----|-------|------------------|
| `docs/ARCHITECTURE.md` | Per project — agreement + action plan | `cosmos-architect` |
| `docs/HARDWARE.md` | Per project — HW source of truth | `cosmos-hardware` |
| `docs/BUILD.md` | Per project — platform build | `cosmos-firmware` |
| `docs/MANUFACTURING.md` | Per project — factory flow | `cosmos-manufacturing` |
| `docs/CODE_STYLE.md` | Shared template | `cosmos-firmware` |
| `docs/REPO_LAYOUT.md` | Shared template | `cosmos-firmware` |
| `docs/RELEASING.md` | Shared template | `cosmos-release` |

Canonical templates live in the harness repo:

`~/myProjects/cosmos-embedded-systems/templates/docs/`

Create a new product repo (preferred):

```bash
~/myProjects/cosmos-embedded-systems/tools/new-project.sh <project-name>
# optional parent: .../new-project.sh <project-name> ~/myProjects
```

Or bootstrap docs into an existing repo:

```bash
~/myProjects/cosmos-embedded-systems/tools/bootstrap-docs.sh /path/to/product-repo
```

## Role skills (subagents)

Read and follow the matching skill before doing that role's work:

| Role | Skill | Primary outputs |
|------|-------|-----------------|
| Architect | `cosmos-architect` | `ARCHITECTURE.md`, platform lock, phased plan |
| Firmware | `cosmos-firmware` | code, `BUILD.md`, layout/style compliance |
| Hardware | `cosmos-hardware` | `HARDWARE.md` (schema + device sections) |
| Manufacturing | `cosmos-manufacturing` | `MANUFACTURING.md`, factory steps |
| Release / QA | `cosmos-release` | version bumps, tags, release checklist |

When using Cursor Task/subagents, give each the same role brief: English only, read the skill file, touch only that role's docs/code unless asked.

## Pipeline

1. **Idea / intake** → Architect drafts `ARCHITECTURE.md` (status `draft`).
2. **Platform agreement** → Human + Architect lock MCU/SDK in section 3; status `agreed`.
3. **Scaffold** → bootstrap templates; customize shared docs only if policy changes.
4. **Hardware definition** → `HARDWARE.md` design rules + first device section.
5. **Firmware skeleton** → layout + style + `BUILD.md` + bring-up.
6. **Features** → product work with GPIO SoT in HARDWARE.
7. **Manufacturing** → `MANUFACTURING.md` + dry-run factory flow.
8. **Test / release** → checklists + `RELEASING.md`.

Do not skip the platform agreement. Do not invent SKU pinouts that disagree with firmware.

## Orchestrator rules

- Prefer editing existing project docs over inventing parallel notes.
- Keep system templates generic; put product facts only in per-project docs.
- If the product repo lacks `docs/ARCHITECTURE.md`, create it from the template first.
- Escalate open platform choices to the human; do not silently pick ESP-IDF or any MCU.
