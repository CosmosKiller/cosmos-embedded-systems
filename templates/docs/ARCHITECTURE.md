# Architecture — {{PROJECT_NAME}}

Human ↔ Architect agreement. This file is the first project artifact: initial definitions, platform choice, and the action plan. Update it when goals, constraints, or platform decisions change.

**Language:** English only.

---

## Status

| Field | Value |
|-------|--------|
| Status | `draft` / `agreed` / `in-progress` / `frozen-for-rev` |
| Last updated | YYYY-MM-DD |
| Architect | |
| Human owner | |

---

## 1. Problem and product intent

### One-sentence product

<!-- What is being built and for whom? -->

### Success criteria

- [ ] …
- [ ] …

### Explicit non-goals

- …

---

## 2. Constraints

| Area | Constraint | Notes |
|------|------------|-------|
| Cost | | |
| Power / battery | | |
| Size / enclosure | | |
| Connectivity | | |
| Certifications / protocol | | |
| Schedule | | |
| Supply chain | | |

---

## 3. Platform agreement (required)

Platform is **not assumed**. It is locked here after discussion between the human and the Architect.

| Decision | Choice | Rationale |
|----------|--------|-----------|
| MCU / module family | *TBD — agree with human* | |
| Framework / SDK | *TBD* (e.g. ESP-IDF, Zephyr, Pico SDK, bare-metal) | |
| Connectivity stack | *TBD* (e.g. Matter, bare Wi-Fi/BLE, none) | |
| Language | C / C++ (default for this harness) | |
| Host OS / tooling assumptions | | |

**Agreement checklist**

- [ ] Human and Architect agree on MCU / module
- [ ] Framework / SDK chosen and version pin strategy defined
- [ ] Connectivity / protocol scope agreed
- [ ] Implications for `BUILD.md` and `MANUFACTURING.md` understood

Once agreed, fill [BUILD.md](BUILD.md) and [MANUFACTURING.md](MANUFACTURING.md) for that platform. Keep [HARDWARE.md](HARDWARE.md) aligned with firmware GPIO as source of truth.

---

## 4. System context

### Actors and interfaces

| Actor / system | Interface | Direction | Notes |
|----------------|-----------|-----------|-------|
| | | | |

### High-level block diagram

```text
[ sensors / UI ] ---- [ MCU / module ] ---- [ radio / wired ]
                            |
                      [ power domain ]
```

### HW / SW partition

| Responsibility | Hardware | Firmware | Notes |
|----------------|----------|----------|-------|
| | | | |

---

## 5. Architecture decisions (ADRs lite)

Record only decisions that are hard to reverse.

| ID | Decision | Status | Consequences |
|----|----------|--------|--------------|
| ADR-001 | | proposed / accepted / superseded | |

---

## 6. Risks and open questions

| Risk / question | Impact | Mitigation / owner | Status |
|-----------------|--------|--------------------|--------|
| | | | open / closed |

---

## 7. Action plan

Phased plan from idea → bring-up → manufacture → test. Adjust phases to the project; keep one owner per workstream.

### Phase 0 — Align

- [ ] Lock platform agreement (section 3)
- [ ] Draft this file to `agreed`
- [ ] Scaffold repo from cosmos-embedded-systems templates

### Phase 1 — Hardware definition

- [ ] Populate [HARDWARE.md](HARDWARE.md) (design rules + first device section)
- [ ] GPIO map draft; firmware owns final numbers
- [ ] Power topology and anti-leakage rules

### Phase 2 — Firmware skeleton

- [ ] Apply [REPO_LAYOUT.md](REPO_LAYOUT.md) and [CODE_STYLE.md](CODE_STYLE.md)
- [ ] Fill [BUILD.md](BUILD.md) for the chosen platform
- [ ] Hello-world / blink / bus bring-up on target hardware

### Phase 3 — Product features

- [ ] …
- [ ] …

### Phase 4 — Home Assistant adoption (when HA is in scope)

- [ ] Fill [HOME_ASSISTANT.md](HOME_ASSISTANT.md); choose adoption rung
- [ ] Ship `home-assistant/packages/` (+ Lovelace view)
- [ ] Commission walkthrough + entity rename checklist

### Phase 5 — Manufacturing readiness

- [ ] Fill [MANUFACTURING.md](MANUFACTURING.md)
- [ ] Factory flash / identity / labeling flow
- [ ] DFM pass (see HARDWARE PCB fabrication defaults)

### Phase 6 — Test and release

- [ ] Bring-up and factory test checklist
- [ ] Versioning per [RELEASING.md](RELEASING.md)
- [ ] First tagged release candidate
- [ ] HA gift / field path verified if applicable

---

## 8. Doc ownership

| Doc | Owner role | When to update |
|-----|------------|----------------|
| [ARCHITECTURE.md](ARCHITECTURE.md) | Architect (+ human for platform lock) | Goals, platform, plan change |
| [HARDWARE.md](HARDWARE.md) | Architect / HW | Pinout, BOM, power, PCB rules |
| [BUILD.md](BUILD.md) | Firmware | Toolchain, targets, artifacts |
| [MANUFACTURING.md](MANUFACTURING.md) | Manufacturing / FW | Factory data, flash, ship kits |
| [HOME_ASSISTANT.md](HOME_ASSISTANT.md) | Home Assistant | Packages, Lovelace, adoption UX |
| [CODE_STYLE.md](CODE_STYLE.md) | System (shared) | Style policy changes |
| [REPO_LAYOUT.md](REPO_LAYOUT.md) | System (shared) | Layout policy changes |
| [RELEASING.md](RELEASING.md) | System (shared) | Release policy changes |

---

## 9. Change log

| Date | Change | Author |
|------|--------|--------|
| YYYY-MM-DD | Initial draft | |
