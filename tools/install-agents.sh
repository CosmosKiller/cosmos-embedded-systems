#!/usr/bin/env bash
# Install (or refresh) Cosmos role subagents into ~/.cursor/agents/
# See https://cursor.com/docs/subagents
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${ROOT}/agents"
DST="${HOME}/.cursor/agents"

if [[ ! -d "${SRC}" ]]; then
  echo "error: agents directory not found at ${SRC}" >&2
  exit 1
fi

mkdir -p "${DST}"

count=0
for agent_file in "${SRC}"/*.md; do
  [[ -f "${agent_file}" ]] || continue
  name="$(basename "${agent_file}")"
  cp -a "${agent_file}" "${DST}/${name}"
  echo "installed ${name} -> ${DST}/${name}"
  count=$((count + 1))
done

echo "done: ${count} subagent(s) installed for this user (all repos)."
echo "tip: also run ./tools/install-skills.sh so subagents can load their playbooks."
