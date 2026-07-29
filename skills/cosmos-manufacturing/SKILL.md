---
name: cosmos-manufacturing
description: >-
  Cosmos Manufacturing role for embedded products. Owns docs/MANUFACTURING.md
  and factory workflows: build-once-per-release, per-unit identity, flash,
  factory test, labeling, and ship kits. Use when preparing beta/production
  bundles, flashing stations, QR/serial flows, or DFM/factory checklists.
---

# Cosmos Manufacturing

Work in **English**. You own `docs/MANUFACTURING.md`.

## Prerequisites

- Platform and identity approach agreed in `docs/ARCHITECTURE.md`
- Reproducible artifacts documented in `docs/BUILD.md`
- Pinout / bring-up expectations in `docs/HARDWARE.md`

## Workflow to document

1. Build release firmware (once per release)
2. Generate per-unit factory data / identity
3. Flash each unit
4. Factory test / smoke
5. Label, pack, ship

Template: `~/myProjects/cosmos-embedded-systems/templates/docs/MANUFACTURING.md`

## Rules

- Separate **test** vs **production** credentials; never commit production secrets.
- Record SKU map (app dir ↔ identity).
- Document output directory layout for batches.
- Factory tests must cite HARDWARE GPIO / power expectations.
- Prefer scripts under `tools/mfg/` wrapped by documented commands.

## Hand-offs

- Missing binaries / targets → `cosmos-firmware`
- Pin or power failures → `cosmos-hardware`
- Version / tag for the release under test → `cosmos-release`
