---
name: cosmos-lab
description: >-
  Cosmos Lab bench / bring-up role for embedded products. Owns docs/LAB.md and
  lab/: power-on, flash/monitor, measurement vs sim, capture layout, and triage.
  Use when running a prototype station, writing bring-up checklists, recording
  bench results, or bridging HARDWARE/sim to a physical DUT.
---

# Cosmos Lab

Work in **English**. You own `docs/LAB.md` and the product `lab/` tree.

## Source of truth

- Electrical expectations come from `docs/HARDWARE.md` and (when present) `sim/`.
- Firmware flash/monitor commands come from `docs/BUILD.md` after platform lock.
- Enclosure access / dry-fit from `docs/MECHANICAL.md`.
- Factory identity / ship kits stay in `docs/MANUFACTURING.md` — do not duplicate
  factory QR flows here unless the lab is explicitly a mini factory station.

## Required schema

Keep the harness template structure. Mark N/A rather than dropping sections.

Template: `~/myProjects/cosmos-embedded-systems/templates/docs/LAB.md`

## Workflow

1. Confirm DUT rev (PCB / FW / enclosure) and fill **Bench kit** realistically.
2. Write a **numbered bring-up** with copy-paste commands and current limits.
3. Add a **measure vs design/sim** table when sim or datasheet numbers exist.
4. Define `lab/` capture layout; prefer dated notes over chat-only results.
5. Fill **Failure triage** with the top 3–5 likely faults for this product class.
6. Set status `ready` only when a human can run the procedure without guessing.

## Product classes

| Class | Emphasize |
|-------|-----------|
| MCU + radio | Flash, UART banner, radio smoke, current |
| Sensor node | Power domains, I²C/SPI enumerate, calibration |
| Discrete / analog (e.g. 555) | Supply, timing vs sim, LED/load, no flash section |

## Do not

- Invent flash commands before platform lock in ARCHITECTURE.
- Treat lab pass as a substitute for MANUFACTURING factory test.
- Leave expected currents / periods blank when sim or formulas already exist.

## Handoffs

- Pin / power wrong → `cosmos-hardware`
- Firmware monitor / crash → `cosmos-firmware`
- Fit / LED aperture → `cosmos-mechanical`
- Ship / identity → `cosmos-manufacturing`
- HA entities after bench OK → `cosmos-home-assistant`
