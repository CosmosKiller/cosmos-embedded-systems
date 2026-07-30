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
| `docs/HOME_ASSISTANT.md` | Per project — HA adoption | `cosmos-home-assistant` |
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

For Cloud Agents, copy **agents and skills** into the product **only when you choose**, then commit them:

```bash
~/myProjects/cosmos-embedded-systems/tools/install-agents-to-project.sh /path/to/product-repo
~/myProjects/cosmos-embedded-systems/tools/install-skills-to-project.sh /path/to/product-repo
# overwrite existing copies only if intentional:
~/myProjects/cosmos-embedded-systems/tools/install-agents-to-project.sh /path/to/product-repo --force
~/myProjects/cosmos-embedded-systems/tools/install-skills-to-project.sh /path/to/product-repo --force
```

(`new-project.sh` does **not** do this automatically.)

## Role skills (subagents)

**Subagents** (`.cursor/agents/` / `~/.cursor/agents/`) are the roles the parent Agent **delegates** to — isolated context per [Cursor Subagents](https://cursor.com/docs/subagents).

**Skills** (`skills/*/SKILL.md`) remain the detailed playbooks each subagent must read first.

| Role | Subagent | Skill playbook | Primary outputs |
|------|----------|----------------|-----------------|
| Orchestrator | `cosmos-orchestrator` | `cosmos-embedded` | pipeline / hand-offs |
| Architect | `cosmos-architect` | `cosmos-architect` | `ARCHITECTURE.md`, platform lock, action plan |
| Firmware | `cosmos-firmware` | `cosmos-firmware` | code, `BUILD.md`, layout/style compliance |
| Hardware | `cosmos-hardware` | `cosmos-hardware` | `HARDWARE.md` (schema + device sections) |
| Home Assistant | `cosmos-home-assistant` | `cosmos-home-assistant` | packages, Lovelace, cards, `HOME_ASSISTANT.md` |
| Manufacturing | `cosmos-manufacturing` | `cosmos-manufacturing` | `MANUFACTURING.md`, factory steps |
| Release / QA | `cosmos-release` | `cosmos-release` | version bumps, tags, release checklist |

When coordinating: invoke `/cosmos-orchestrator` or ask the parent to delegate. Prefer `/cosmos-architect` (etc.) for an explicit specialist. Pass each specialist a self-contained brief — subagents do not see prior chat history.

## Pipeline

1. **Idea / intake** → Architect drafts `ARCHITECTURE.md` (status `draft`).
2. **Platform agreement** → Human + Architect lock MCU/SDK in section 3; status `agreed`.
3. **Scaffold** → bootstrap templates; customize shared docs only if policy changes.
4. **Hardware definition** → `HARDWARE.md` design rules + first device section.
5. **Firmware skeleton** → layout + style + `BUILD.md` + bring-up.
6. **Features** → product work with GPIO SoT in HARDWARE.
7. **Home Assistant adoption** → packages / Lovelace / cards (`cosmos-home-assistant`) when the product targets HA.
8. **Manufacturing** → `MANUFACTURING.md` + dry-run factory flow.
9. **Test / release** → checklists + `RELEASING.md`.

Do not skip the platform agreement. Do not invent SKU pinouts that disagree with firmware.

## Orchestrator rules

- Prefer editing existing project docs over inventing parallel notes.
- Keep system templates generic; put product facts only in per-project docs.
- If the product repo lacks `docs/ARCHITECTURE.md`, create it from the template first.
- Escalate open platform choices to the human; do not silently pick ESP-IDF or any MCU.
