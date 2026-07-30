# AGENTS.md

## Cursor Cloud specific instructions

This repo (`cosmos-embedded-systems`) is a **Bash + Markdown scaffolding harness**, not a
runtime application. There is no package manager, build system, test suite, server, database,
or port to run. "Running the app" means executing the shell tools in `tools/` and verifying they
scaffold correctly.

### Dependencies
- Only `bash`, `git`, and coreutils (`cp`, `mkdir`, `sed`, `basename`) are required — all preinstalled.
- Nothing to install; the startup update script only re-marks `tools/*.sh` executable.

### Lint / test / build / run
- **Build:** none (nothing compiles).
- **Test:** none defined. Validate by running the tools (below) and checking the scaffold output.
- **Lint:** no linter is configured in-repo. `bash -n tools/*.sh` is a quick syntax check.
  `shellcheck tools/*.sh` is the natural linter but `shellcheck` is **not installed** by default.
- **Run (demo the harness):**
  ```bash
  ./tools/install-skills.sh                 # installs skills into ~/.cursor/skills/ (user-level)
  ./tools/new-project.sh <name> [parent]    # scaffolds a product repo (default parent: ~/myProjects)
  ./tools/bootstrap-docs.sh <repo> [--force] # copies doc templates into an existing repo's docs/
  ```

### Non-obvious gotchas
- `new-project.sh` / `install-skills.sh` write **outside** this repo: new projects go to
  `~/myProjects/<name>` by default and skills go to `~/.cursor/skills/`. These side effects do not
  show up in `git status` for `/workspace`.
- `new-project.sh` fails if the target path already exists (by design). Use a fresh name or a
  different parent dir when re-demoing.
- `bootstrap-docs.sh` skips files that already exist unless `--force` is passed (idempotent by default).
- The `templates/docs/` files contain `{{PROJECT_NAME}}` / `{{REPO_NAME}}` placeholders that
  `new-project.sh` fills via `sed` in `ARCHITECTURE.md` and `REPO_LAYOUT.md`.
