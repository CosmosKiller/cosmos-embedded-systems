#!/usr/bin/env bash
# Copy harness role skills into a product repo's .cursor/skills/ (for Cloud Agents).
# Personal ~/.cursor/skills/ do NOT sync to cloud; project skills in git do.
#
# Usage:
#   install-skills-to-project.sh /path/to/product-repo
#   install-skills-to-project.sh /path/to/product-repo --force
#   install-skills-to-project.sh /path/to/product-repo cosmos-architect cosmos-embedded
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${ROOT}/skills"

if [[ $# -lt 1 ]]; then
  echo "usage: $0 /path/to/product-repo [--force] [skill-name ...]" >&2
  echo "  With no skill names, copies all skills under skills/." >&2
  echo "  --force overwrites existing skill directories in the product." >&2
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
    *) NAMES+=("${arg}") ;;
  esac
done

if [[ ! -d "${SRC}" ]]; then
  echo "error: skills directory not found at ${SRC}" >&2
  exit 1
fi

DST="${TARGET_REPO}/.cursor/skills"
mkdir -p "${DST}"

if [[ ${#NAMES[@]} -eq 0 ]]; then
  for skill_dir in "${SRC}"/*/; do
    [[ -d "${skill_dir}" ]] || continue
    NAMES+=("$(basename "${skill_dir}")")
  done
fi

if [[ ${#NAMES[@]} -eq 0 ]]; then
  echo "error: no skills found to install" >&2
  exit 1
fi

copied=0
skipped=0
for name in "${NAMES[@]}"; do
  src_dir="${SRC}/${name}"
  if [[ ! -d "${src_dir}" ]]; then
    echo "error: skill not found: ${name} (expected ${src_dir})" >&2
    exit 1
  fi
  if [[ ! -f "${src_dir}/SKILL.md" ]]; then
    echo "error: missing SKILL.md in ${src_dir}" >&2
    exit 1
  fi

  dest_dir="${DST}/${name}"
  if [[ -e "${dest_dir}" && "${FORCE}" -ne 1 ]]; then
    echo "skip (exists): ${dest_dir}  (pass --force to overwrite)"
    skipped=$((skipped + 1))
    continue
  fi

  rm -rf "${dest_dir}"
  cp -a "${src_dir}" "${dest_dir}"
  echo "installed ${name} -> ${dest_dir}"
  copied=$((copied + 1))
done

echo "done: copied=${copied} skipped=${skipped} -> ${DST}"
echo "commit .cursor/skills/ in the product repo so Cloud Agents can use /${NAMES[0]} (etc.)."
