# cosmos-embedded-systems

Reusable harness for Cosmos embedded product development: English doc templates plus Cursor role skills (subagents) covering idea → architecture → hardware → firmware → manufacturing → test/release.

## Install skills (once per machine)

Skills are installed under `~/.cursor/skills/` so they apply to **all** your **local** repos:

```bash
./tools/install-skills.sh
```

Cloud Agents do **not** see `~/.cursor/skills/`. For cloud (or per-repo pinning), copy skills into the product:

```bash
./tools/install-skills-to-project.sh /path/to/product-repo
./tools/install-skills-to-project.sh /path/to/product-repo --force
./tools/install-skills-to-project.sh /path/to/product-repo cosmos-architect cosmos-embedded
```

That writes `product/.cursor/skills/…`. **Commit that folder** in the product repo so Cloud Agents can use `/cosmos-architect`, etc.

| Skill | Role |
|-------|------|
| `cosmos-embedded` | Orchestrator / pipeline |
| `cosmos-architect` | `ARCHITECTURE.md`, platform agreement |
| `cosmos-hardware` | `HARDWARE.md` schema + device sections |
| `cosmos-firmware` | Code, layout/style, `BUILD.md` |
| `cosmos-manufacturing` | `MANUFACTURING.md`, factory flow |
| `cosmos-release` | SemVer, tags, release QA |

## Start a new product project

Creates `~/myProjects/<name>` (or another parent), `git init` on `main`, a minimal `README.md`, and copies English doc templates (fills `{{PROJECT_NAME}}` / `{{REPO_NAME}}`):

```bash
./tools/new-project.sh my-sensor
./tools/new-project.sh my-sensor ~/myProjects   # optional parent dir
```

Does **not** copy skills into the product. Local work uses `~/.cursor/skills/` via `install-skills.sh`. For Cloud Agents, run `install-skills-to-project.sh` yourself when you want that control.

Then open **that product repo** in Cursor and run the Architect (`cosmos-architect`) to lock the platform in `docs/ARCHITECTURE.md`.

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
| `CODE_STYLE.md` | Shared C/C++ style (ESP-IDF-shaped, portable) |
| `REPO_LAYOUT.md` | Shared repo / app / components layout |
| `RELEASING.md` | Shared versioning and tag rules |

**Language:** English only for harness docs and role outputs.

**Platform:** never assumed. Lock MCU/SDK in `ARCHITECTURE.md` with the Architect before filling definitive build/manufacturing commands.

## Layout

```
cosmos-embedded-systems/
├── README.md
├── templates/docs/     # English templates copied into product repos
├── skills/             # canonical skill sources
└── tools/
    ├── new-project.sh                 # mkdir + git init + docs only
    ├── install-skills.sh              # -> ~/.cursor/skills (local)
    ├── install-skills-to-project.sh   # opt-in -> product/.cursor/skills (cloud)
    └── bootstrap-docs.sh
```
