# AGENTS.md

## Cursor Cloud specific instructions

This repo (`cosmos-embedded-systems`) is a lightweight harness, not a compiled
application. It contains Bash tools in `tools/`, English doc templates in
`templates/docs/`, MCP install docs/templates, and Cursor role skills/agents.

- **No package manager / no automated test suite** in-repo. Harness scripts use
  `bash` + `git`. Local MCP installs (KiCad, Freerouting) need Node, Python,
  KiCad/`pcbnew`, and Java 21 — see `docs/MCP_SETUP.md`.
- **Running the tools** (see `README.md` for full docs):
  - `./tools/install-skills.sh` — copies `skills/*` into `~/.cursor/skills/`
  - `./tools/install-agents.sh` — copies `agents/*` into `~/.cursor/agents/`
  - `./tools/install-mcps.sh` — KiCad MCP + Freerouting + merge `~/.cursor/mcp.json`
  - `./tools/new-project.sh <name> [parent-dir]` — scaffolds a product repo
  - `./tools/bootstrap-docs.sh <repo> [--force]` — copies doc templates
- **Gotcha:** keep `tools/*.sh` executable (`chmod +x tools/*.sh`).
