# Lab bench — {{PROJECT_NAME}}

Prototype bring-up and measurement station for this product. Distinct from
[MANUFACTURING.md](MANUFACTURING.md) (factory flash / identity / ship).

**Language:** English only.

---

## Status

| Field | Value |
|-------|--------|
| Status | `draft` / `ready` / `in-use` |
| Last updated | YYYY-MM-DD |
| Bench owner | |
| Linked HW rev | |
| Linked FW / PCB | |

---

## 1. Intent

### What this bench proves

<!-- Power-on, UART heartbeat, radio ping, LED period vs sim, … -->

### Pass / fail bar

- [ ] …
- [ ] …

---

## 2. Bench kit

| Item | Spec / model | Notes |
|------|----------------|-------|
| PSU / supply | | Current limit |
| Meter / scope | | |
| Logic / UART | | Baud, adapter |
| Programmer / debugger | | N/A if discrete |
| Loads / fixtures | | Enclosure, antenna |
| Safety | | ESD, polarity |

### Station layout (optional)

```text
[ PSU ] -- [ DUT ] -- [ meter / scope ]
              |
         [ UART / SWD ]
```

---

## 3. Preconditions

- [ ] PCB rev matches [HARDWARE.md](HARDWARE.md) / ECAD
- [ ] Sim expectations recorded (if any) — link `sim/` or notes
- [ ] Firmware image / tag known (if MCU) — [BUILD.md](BUILD.md)
- [ ] Enclosure dry-fit OK or open-frame accepted — [MECHANICAL.md](MECHANICAL.md)
- [ ] Tools on PATH / drivers installed

---

## 4. Bring-up procedure

Numbered steps the human (or agent guiding the human) follows. Keep commands copy-pasteable.

### 4.1 Power

1. Set supply to ___ V, current limit ___ mA.
2. Confirm polarity / connector.
3. Apply power; expect quiescent ≈ ___ mA.

### 4.2 Firmware / identity (MCU products)

```bash
# Flash / monitor — fill from BUILD.md
```

- [ ] Boot banner / version string seen
- [ ] Identity / MAC / serial as expected

### 4.3 Functional smoke

| Check | Method | Expected | Result |
|-------|--------|----------|--------|
| | | | |

### 4.4 Measure vs design / sim

| Signal / metric | Expected | Measured | Pass? |
|-----------------|----------|----------|-------|
| | | | |

---

## 5. Log capture

Where to put logs, scope shots, serial dumps:

```text
lab/
├── notes/           # dated markdown
├── captures/        # csv, png, saleae, …
└── RESULTS.md       # latest summary (optional)
```

Serial example:

```bash
# e.g. idf.py monitor / picocom / minicom
```

---

## 6. Failure triage

| Symptom | Likely cause | Next action |
|---------|--------------|-------------|
| No power draw | Open / polarity / fuse | Recheck supply and HARDWARE power |
| | | |

Escalate: Hardware (schematic/BOM) · Firmware (app) · Mechanical (fit) · Architect (scope change).

---

## 7. Handoff

- Factory-ready flow → [MANUFACTURING.md](MANUFACTURING.md)
- Field / HA adoption → [HOME_ASSISTANT.md](HOME_ASSISTANT.md)
- Release candidate → [RELEASING.md](RELEASING.md)

---

## Related docs

- [ARCHITECTURE.md](ARCHITECTURE.md)
- [HARDWARE.md](HARDWARE.md)
- [BUILD.md](BUILD.md)
- [MECHANICAL.md](MECHANICAL.md)
