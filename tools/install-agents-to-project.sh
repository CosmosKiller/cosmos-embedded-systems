#!/usr/bin/env bash
# Copy harness role subagents into a product repo's .cursor/agents/ (opt-in, Cloud Agents).
# Personal ~/.cursor/agents/ do NOT sync to cloud; project agents in git do.
# See https://cursor.com/docs/subagents
#
# Usage:
#   install-agents-to-project.sh /path/to/product-repo
#   install-agents-to-project.sh /path/to/product-repo --force
#   install-agents-to-project.sh /path/to/product-repo cosmos-architect cosmos-firmware
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${ROOT}/agents"

if [[ $# -lt 1 ]]; then
  echo "usage: $0 /path/to/product-repo [--force] [agent-name ...]" >&2
  echo "  With no agent names, copies all agents under agents/." >&2
  echo "  Agent names are without .md (e.g. cosmos-architect)." >&2
  echo "  --force overwrites existing agent files in the product." >&2
  exit 1
fi

TARGET_REPO="$(cd "$1" && pwd)"
shift

FORCE=0
NAMES=()
for arg in "$@"; do
  case "${arg}" in
    --force) FORCE=1 ;;
    -*)
      echo "error: unknown option: ${arg}" >&2
      exit 1
      ;;
    *) NAMES+=("${arg%.md}") ;;
  esac
done

if [[ ! -d "${SRC}" ]]; then
  echo "error: agents directory not found at ${SRC}" >&2
  exit 1
fi

DST="${TARGET_REPO}/.cursor/agents"
mkdir -p "${DST}"

if [[ ${#NAMES[@]} -eq 0 ]]; then
  for agent_file in "${SRC}"/*.md; do
    [[ -f "${agent_file}" ]] || continue
    NAMES+=("$(basename "${agent_file}" .md)")
  done
fi

if [[ ${#NAMES[@]} -eq 0 ]]; then
  echo "error: no agents found to install" >&2
  exit 1
fi

copied=0
skipped=0
for name in "${NAMES[@]}"; do
  src_file="${SRC}/${name}.md"
  if [[ ! -f "${src_file}" ]]; then
    echo "error: agent not found: ${name} (expected ${src_file})" >&2
    exit 1
  fi

  dest_file="${DST}/${name}.md"
  if [[ -e "${dest_file}" && "${FORCE}" -ne 1 ]]; then
    echo "skip (exists): ${dest_file}  (pass --force to overwrite)"
    skipped=$((skipped + 1))
    continue
  fi

  cp -a "${src_file}" "${dest_file}"
  echo "installed ${name} -> ${dest_file}"
  copied=$((copied + 1))
done

echo "done: copied=${copied} skipped=${skipped} -> ${DST}"
echo "commit .cursor/agents/ (and usually .cursor/skills/) for Cloud Agents."
echo "local tip: skills playbooks should also be present so subagents can read them."
