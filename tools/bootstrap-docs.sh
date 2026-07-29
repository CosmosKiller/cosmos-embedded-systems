#!/usr/bin/env bash
# Copy English doc templates into a product repo's docs/ directory.
# Usage: bootstrap-docs.sh /path/to/product-repo [--force]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${ROOT}/templates/docs"

if [[ $# -lt 1 ]]; then
  echo "usage: $0 /path/to/product-repo [--force]" >&2
  exit 1
fi

TARGET_REPO="$(cd "$1" && pwd)"
FORCE="${2:-}"
DEST="${TARGET_REPO}/docs"

if [[ ! -d "${SRC}" ]]; then
  echo "error: templates not found at ${SRC}" >&2
  exit 1
fi

mkdir -p "${DEST}"

copied=0
skipped=0
for file in "${SRC}"/*; do
  [[ -f "${file}" ]] || continue
  base="$(basename "${file}")"
  dest_file="${DEST}/${base}"
  if [[ -e "${dest_file}" && "${FORCE}" != "--force" ]]; then
    echo "skip (exists): ${dest_file}"
    skipped=$((skipped + 1))
    continue
  fi
  cp "${file}" "${dest_file}"
  echo "wrote ${dest_file}"
  copied=$((copied + 1))
done

echo "done: copied=${copied} skipped=${skipped} -> ${DEST}"
echo "next: fill docs/ARCHITECTURE.md and lock the platform with the Architect."
