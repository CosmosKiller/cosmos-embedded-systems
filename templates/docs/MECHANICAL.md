# Mechanical / enclosure — {{PROJECT_NAME}}

PCB ↔ enclosure source of truth for this product. Keep board outline, keep-outs,
connectors, and fasteners aligned with the ECAD board and with [HARDWARE.md](HARDWARE.md).

**Language:** English only.

---

## Status

| Field | Value |
|-------|--------|
| Status | `draft` / `fit-check` / `print-ready` / `frozen-for-rev` |
| Last updated | YYYY-MM-DD |
| Mech owner | |
| Linked PCB rev | |

---

## 1. Intent

### Enclosure goal

<!-- Bench open-frame, clip-lid box, gasketed IP box, panel mount, … -->

### Success criteria

- [ ] PCB seats without force; mounting holes align
- [ ] LED / display / antenna / button clearances verified
- [ ] Connectors and cables exit without strain on pads
- [ ] Printable or fab-ready files committed under `mech/`

---

## 2. Board envelope (from ECAD)

| Parameter | Value | Source |
|-----------|--------|--------|
| Outline (L × W) | mm × mm | Edge.Cuts / STEP |
| PCB thickness | mm | HARDWARE / fab |
| Max component height (top) | mm | 3D / datasheet |
| Max component height (bottom) | mm | |
| Mounting holes | dia / pattern | PCB |
| Keep-outs | antenna, heat, … | HARDWARE |

**PCB 3D reference:** `mech/<board>.step` (export from KiCad / Flux).

---

## 3. Enclosure concept

| Decision | Choice | Notes |
|----------|--------|--------|
| Process | FDM / SLA / CNC / off-the-shelf | |
| Tooling | OpenSCAD (agent) → FreeCAD (human); Fusion/… optional | Prefer OSS path in this harness |
| Material | | |
| Lid / access | snap / screws / open | |
| Fasteners | M2 / M2.5 / M3 / heat-set | |
| LED / optic | hole / light-pipe / window | |
| Cable exit | grommet / slot / none | |
| IP / environment | lab only / outdoor / … | |

### ASCII section (optional)

```text
        [ lid ]
   -----------------
  |  clearance top  |
  | ---- PCB ------ |
  |  standoff H     |
  | ---- base ----- |
```

---

## 4. Clearances and fit

| Feature | Spec | Verified |
|---------|------|----------|
| Wall thickness | mm | [ ] |
| PCB pocket / rail | mm oversize | [ ] |
| Standoff height | mm | [ ] |
| Lid ↔ tallest part | mm | [ ] |
| Button / LED aperture | dia / pos | [ ] |
| Antenna keep-out volume | | [ ] |

---

## 5. Files and regeneration

| Artifact | Path | How to regenerate |
|----------|------|-------------------|
| PCB STEP | `mech/*.step` | KiCad MCP `export_3d` / PCB Editor → File → Export → STEP |
| Parametric box | `mech/*.scad` (or FreeCAD) | Edit parameters; render STL |
| Print mesh | `mech/*.stl` | `openscad -o …` or CAD export |
| Fit notes / photos | `mech/notes/` | |

Do not hand-edit exported STEP; change the PCB or the parametric source and re-export.

---

## 6. Lab print checklist

- [ ] Export fresh STEP from current PCB revision
- [ ] Update outline / heights in parametric source
- [ ] Dry-fit PCB (or paper outline) before final print
- [ ] Check LED visibility and connector reach
- [ ] Record filament / material and slicer profile used

---

## Related docs

- [ARCHITECTURE.md](ARCHITECTURE.md) — size / enclosure constraints
- [HARDWARE.md](HARDWARE.md) — connectors, antenna, bring-up access
- [MANUFACTURING.md](MANUFACTURING.md) — if enclosure is part of ship kit
