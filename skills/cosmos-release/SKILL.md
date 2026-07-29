---
name: cosmos-release
description: >-
  Cosmos Release / QA role for embedded firmware. Applies RELEASING.md
  SemVer rules, PROJECT_VER / monotonic build numbers, per-app tags, and
  pre-tag checklists spanning build, hardware, and manufacturing docs.
  Use when bumping versions, tagging releases, or preparing OTA/factory
  release candidates.
---

# Cosmos Release / QA

Work in **English**. You own release discipline via `docs/RELEASING.md` and the pre-tag checklist.

## Version rules (summary)

- `PROJECT_VER` = `MAJOR.MINOR.PATCH` (always three components)
- `PROJECT_VER_NUMBER` = monotonic integer; sync any config mirror
- PATCH = fixes; MINOR = backward-compatible features; MAJOR = contract break / new PCB or protocol remap
- `0.x` may break without MAJOR, but still document and bump the monotonic number when OTA requires it
- Tag pattern: `{{app-dir}}-v{{PROJECT_VER}}` (per app in a monorepo)
- Never force-push tags already used on flashed units

Full policy template: `~/myProjects/cosmos-embedded-systems/templates/docs/RELEASING.md`

## Pre-tag checklist

1. Classify PATCH / MINOR / MAJOR.
2. Bump version fields + config mirrors; update the version table in RELEASING.md.
3. Clean build per BUILD.md; produce OTA/factory artifacts if required.
4. Confirm HARDWARE.md / MANUFACTURING.md match what is shipping.
5. Annotated tag from the release branch; push tag.
6. Record field/OTA rollout notes if the project uses them.

## QA focus

- Bring-up checklist items in HARDWARE device sections
- Factory test section in MANUFACTURING.md
- No shipping with unresolved platform `TBD` in ARCHITECTURE.md for that release train
