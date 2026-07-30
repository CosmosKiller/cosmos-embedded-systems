#!/usr/bin/env bash
# Create a new Cosmos product repo: directory + git init + doc templates.
# Usage:
#   new-project.sh <project-name> [parent-dir]
# Examples:
#   new-project.sh my-sensor
#   new-project.sh my-sensor ~/myProjects
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BOOTSTRAP="${ROOT}/tools/bootstrap-docs.sh"

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "usage: $0 <project-name> [parent-dir]" >&2
  echo "  default parent-dir: ~/myProjects" >&2
  exit 1
fi

NAME="$1"
PARENT="${2:-${HOME}/myProjects}"

if [[ ! "${NAME}" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
  echo "error: invalid project name '${NAME}' (use letters, numbers, . _ -)" >&2
  exit 1
fi

if [[ ! -x "${BOOTSTRAP}" ]]; then
  echo "error: bootstrap script missing or not executable: ${BOOTSTRAP}" >&2
  exit 1
fi

mkdir -p "${PARENT}"
PARENT="$(cd "${PARENT}" && pwd)"
TARGET="${PARENT}/${NAME}"

if [[ -e "${TARGET}" ]]; then
  echo "error: path already exists: ${TARGET}" >&2
  exit 1
fi

mkdir -p "${TARGET}"
git -C "${TARGET}" init -b main >/dev/null

# Minimal product README (English); architecture owns the plan.
cat > "${TARGET}/README.md" <<EOF
# ${NAME}

Cosmos embedded product repository.

## Start here

1. Open this repo in Cursor (skills: \`cosmos-embedded\`, \`cosmos-architect\`).
2. Fill [\`docs/ARCHITECTURE.md\`](docs/ARCHITECTURE.md) and **lock the platform** with the Architect.
3. Then proceed to \`HARDWARE.md\`, firmware/\`BUILD.md\`, \`MANUFACTURING.md\`, and \`RELEASING.md\`.

Scaffolded from [cosmos-embedded-systems](${ROOT}).
EOF

"${BOOTSTRAP}" "${TARGET}"

# Fill project name placeholder in ARCHITECTURE.md when present.
ARCH="${TARGET}/docs/ARCHITECTURE.md"
if [[ -f "${ARCH}" ]]; then
  sed -i "s/{{PROJECT_NAME}}/${NAME}/g" "${ARCH}"
fi

# Seed REPO_LAYOUT placeholder if present.
LAYOUT="${TARGET}/docs/REPO_LAYOUT.md"
if [[ -f "${LAYOUT}" ]]; then
  sed -i "s/{{REPO_NAME}}/${NAME}/g" "${LAYOUT}"
fi

echo
echo "project ready: ${TARGET}"
echo "next:"
echo "  1. Open ${TARGET} in Cursor (move agent / open folder)."
echo "  2. Use /cosmos-architect (subagent) to complete docs/ARCHITECTURE.md and lock the platform."
echo "  3. Optional: git -C ${TARGET} add docs README.md && git commit"
echo "  4. Optional (Cloud Agents only):"
echo "       ${ROOT}/tools/install-agents-to-project.sh ${TARGET}"
echo "       ${ROOT}/tools/install-skills-to-project.sh ${TARGET}"
