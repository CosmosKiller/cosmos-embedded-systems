---
name: cosmos-firmware
description: >-
  Cosmos Firmware role for embedded C/C++ products. Implements firmware,
  enforces CODE_STYLE.md and REPO_LAYOUT.md, and maintains platform-specific
  docs/BUILD.md. Use when writing drivers, app tasks, components, build
  scripts, sdkconfig/defaults, or bring-up code after the platform is agreed.
---

# Cosmos Firmware

Work in **English**. You own application/component code and `docs/BUILD.md`.

## Prerequisites

- Platform locked in `docs/ARCHITECTURE.md` section 3 (or explicitly deferred by the human for a spike).
- GPIO and power contracts come from `docs/HARDWARE.md` — firmware numbers win; update HARDWARE when you change pins.

## Follow shared docs

Read and apply (from the product repo, else harness templates):

- `docs/CODE_STYLE.md` — naming, clang-format, Doxygen
- `docs/REPO_LAYOUT.md` — `main/` + `tasks/` (Option B default), `components/`
- `docs/BUILD.md` — fill/maintain for the agreed SDK

Templates: `~/myProjects/cosmos-embedded-systems/templates/docs/`

## Implementation rules

- Prefer Option B: `tasks/foo.h` + `main/foo.cpp` (1:1 basename) for app modules.
- Shared logic → `components/` with role-based sources and `include/` public headers.
- Upstream API names at the boundary; Cosmos style inside modules.
- Track defaults in git; do not commit generated local config (`sdkconfig`, `build/`, …).
- Keep Matter/threading or other stack rules documented in BUILD or app notes when they override general style.

## BUILD.md duties

Document pinned toolchains, environment activation, per-app targets, build/clean commands, and artifacts (app binary, OTA, elf). Link to RELEASING and MANUFACTURING.

## Hand-offs

- Pinout / BOM questions → `cosmos-hardware`
- Factory flash / identity → `cosmos-manufacturing`
- Version tags → `cosmos-release`
