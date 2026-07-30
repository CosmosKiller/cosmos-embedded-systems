# cosmos-embedded-systems

Reusable harness for Cosmos embedded product development: English doc templates, Cursor **subagents** (roles), and **skills** (playbooks) covering idea → architecture → hardware → firmware → Home Assistant → manufacturing → release.

## Subagents vs skills

Per [Cursor Subagents](https://cursor.com/docs/subagents):

| Layer | What it is | Where |
|-------|------------|--------|
| **Subagents** | Specialist roles the parent Agent **delegates** to (own context) | `agents/*.md` → `~/.cursor/agents/` |
| **Skills** | Detailed playbooks each subagent reads first | `skills/*/SKILL.md` → `~/.cursor/skills/` |

Keep both: subagents for isolation/delegation; skills for procedures and template pointers.

## Install locally (once per machine)

```bash
./tools/install-skills.sh    # playbooks -> ~/.cursor/skills/
./tools/install-agents.sh    # roles     -> ~/.cursor/agents/
```

Then in Agent chat:

```text
/cosmos-architect …
/cosmos-orchestrator …
```

Or ask naturally: “Use the cosmos-architect subagent to lock the platform.”

| Subagent | Skill playbook | Role |
|----------|----------------|------|
| `cosmos-orchestrator` | `cosmos-embedded` | Pipeline / hand-offs |
| `cosmos-architect` | `cosmos-architect` | `ARCHITECTURE.md`, platform agreement |
| `cosmos-hardware` | `cosmos-hardware` | `HARDWARE.md` |
| `cosmos-firmware` | `cosmos-firmware` | Code, layout/style, `BUILD.md` |
| `cosmos-home-assistant` | `cosmos-home-assistant` | HA packages, Lovelace, cards |
| `cosmos-manufacturing` | `cosmos-manufacturing` | `MANUFACTURING.md`, factory flow |
| `cosmos-release` | `cosmos-release` | SemVer, tags, release QA |

## Cloud / per-product (opt-in)

Personal `~/.cursor/agents` and `~/.cursor/skills` do **not** sync to Cloud Agents. When you want a product to carry them:

```bash
./tools/install-agents-to-project.sh /path/to/product-repo
./tools/install-skills-to-project.sh /path/to/product-repo
# refresh copies:
./tools/install-agents-to-project.sh /path/to/product-repo --force
./tools/install-skills-to-project.sh /path/to/product-repo --force
```

**Commit** `.cursor/agents/` and `.cursor/skills/` in that product. `new-project.sh` does **not** do this automatically.

## Start a new product project

Creates `~/myProjects/<name>` (or another parent), `git init` on `main`, a minimal `README.md`, and copies English doc templates (fills `{{PROJECT_NAME}}` / `{{REPO_NAME}}`):

```bash
./tools/new-project.sh my-sensor
./tools/new-project.sh my-sensor ~/myProjects   # optional parent dir
```

Then open **that product repo** in Cursor and run `/cosmos-architect` to lock the platform in `docs/ARCHITECTURE.md`.

Legacy repos already in production (e.g. FivePieceBasis) stay outside this flow.

### Bootstrap docs into an existing empty repo

```bash
./tools/bootstrap-docs.sh /path/to/product-repo
# overwrite existing files only if intentional:
./tools/bootstrap-docs.sh /path/to/product-repo --force
```

### Doc map

| File | Scope |
|------|--------|
| `ARCHITECTURE.md` | Per project — human ↔ architect agreement + action plan |
| `HARDWARE.md` | Per project — HW source of truth (design rules + per-device sections) |
| `BUILD.md` | Per project — platform build system |
| `MANUFACTURING.md` | Per project — factory / flash / ship |
| `HOME_ASSISTANT.md` | Per project — HA packages / Lovelace / adoption |
| `CODE_STYLE.md` | Shared C/C++ style (ESP-IDF-shaped, portable) |
| `REPO_LAYOUT.md` | Shared repo / app / components layout |
| `RELEASING.md` | Shared versioning and tag rules |

**Language:** English only for harness docs and role outputs.

**Platform:** never assumed. Lock MCU/SDK in `ARCHITECTURE.md` with the Architect before filling definitive build/manufacturing commands.

## Layout

```
cosmos-embedded-systems/
├── README.md
├── agents/             # Cursor subagents (thin role prompts)
├── skills/             # playbooks each subagent reads
├── templates/docs/     # English templates for product repos
└── tools/
    ├── new-project.sh
    ├── bootstrap-docs.sh
    ├── install-skills.sh
    ├── install-agents.sh
    ├── install-skills-to-project.sh   # opt-in cloud
    └── install-agents-to-project.sh   # opt-in cloud
```
