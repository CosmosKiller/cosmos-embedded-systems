#!/usr/bin/env bash
# Install (or refresh) Cosmos embedded role skills into ~/.cursor/skills/
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${ROOT}/skills"
DST="${HOME}/.cursor/skills"

if [[ ! -d "${SRC}" ]]; then
  echo "error: skills directory not found at ${SRC}" >&2
  exit 1
fi

mkdir -p "${DST}"

count=0
for skill_dir in "${SRC}"/*/; do
  [[ -d "${skill_dir}" ]] || continue
  name="$(basename "${skill_dir}")"
  rm -rf "${DST}/${name}"
  cp -a "${skill_dir}" "${DST}/${name}"
  echo "installed ${name} -> ${DST}/${name}"
  count=$((count + 1))
done

echo "done: ${count} skill(s) installed for this user (all repos)."
