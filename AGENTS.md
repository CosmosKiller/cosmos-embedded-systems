# AGENTS.md

## Cursor Cloud specific instructions

This repo (`cosmos-embedded-systems`) is a lightweight harness, not a compiled
application. It contains three Bash tools in `tools/`, English doc templates in
`templates/docs/`, and Cursor role skills in `skills/`.

- **No dependencies / no build system.** Everything runs on `bash` + `git`,
  which are already present. There is no package manager, no lint config, and no
  automated test suite committed. `shellcheck` is not installed by default.
- **Running the tools** (see `README.md` for full docs):
  - `./tools/install-skills.sh` — copies `skills/*` into `~/.cursor/skills/`
    (user-global, affects all repos). Re-running refreshes/overwrites.
  - `./tools/new-project.sh <name> [parent-dir]` — scaffolds a new product repo
    (`git init -b main`, README, `docs/` templates) under `~/myProjects` by
    default. Substitutes `{{PROJECT_NAME}}`/`{{REPO_NAME}}` placeholders.
  - `./tools/bootstrap-docs.sh <repo> [--force]` — copies doc templates into an
    existing repo's `docs/`; skips existing files unless `--force`.
- **Gotcha:** the tool scripts must keep their executable bit. If they lose it
  (e.g. a fresh checkout on some filesystems), run `chmod +x tools/*.sh`. The
  update script handles this on VM startup.
