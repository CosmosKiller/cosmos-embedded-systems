# Hardware reference

Per-device GPIO, carrier-board guidance, and ECAD prompts. Update this file when pinouts or the BOM change.

**Firmware is the source of truth for GPIO numbers** — carrier boards must match the tables in each device section.

**Language:** English only.

---

## Carrier / board design rules

Shared defaults for this project's board class. Adjust the values when the Architect and human lock different electrical constraints in [ARCHITECTURE.md](ARCHITECTURE.md).

### Electrical

| Rule | Value / note |
|------|----------------|
| Supply domain | e.g. 1S Li-ion (3.0–4.2 V) and/or regulated 3.3 V |
| Max board voltage | |
| Logic levels | e.g. 3.3 V CMOS only on module GPIO |
| Battery sense (if any) | Divider ratio, resistor values, ADC pin |
| ADC filter (if any) | Capacitance and placement |
| Digital inputs | Pull-up / pull-down must match firmware |
| Factory reset / boot control | Pin, timing, accessibility |
| Decoupling | Per noisy load / LED branch |

### Power architecture

Document the product power roles, USB (or other) port strategy, and allowed OR points. Prefer ASCII topology diagrams.

#### Product power roles

| Product / SKU | Role | External power | Battery |
|---------------|------|----------------|---------|
| | | | |

#### Hard anti-leakage rules

Never create a path that lets one rail back-feed another. List forbidden ties and the only allowed OR points for this design family.

| Forbidden | Why |
|-----------|-----|
| | |

**Allowed OR / power-path points only:**

1. …
2. …

#### Recommended topology

```text
[ external power ] --> [ charger / protect / PMIC ] --> [ cell / SYS ]
                                              |
                                         [ MCU rail ]
                                              |
                                      [ loads / sensors ]
```

### RF / layout (wireless products)

| Rule | Value / note |
|------|----------------|
| Antenna keep-out | No copper, ground fill, or components under module antenna area |
| Ground | Solid GND pour; stitch vias near module ground pads |
| High-speed / USB | Follow module vendor differential and keep-out guidance |

### PCB fabrication

| Parameter | Default |
|-----------|---------|
| Layers | 2 (unless agreed otherwise) |
| Thickness | 1.6 mm |
| Copper | 1 oz |
| Min trace/space | Per chosen fab capability |
| Via | Per fab default |
| Silkscreen | Product name, key nets, revision |
| Test points | Power rails and critical sense nodes for bring-up |

### Design workflow (ECAD)

1. Place module footprint first; lock antenna keep-out.
2. Route power and protection.
3. Route sense / ADC and critical sensor inputs before auto-router.
4. Place actuators / LEDs on designated GPIOs (do not reassign without firmware change).
5. Run DRC; export Gerber + BOM + pick-and-place for prototype order.

### ECAD / schematics tracking

Firmware GPIO + prompts in this file are the **source of truth** until Gerbers land.

| Product / SKU | ECAD status | Link |
|---------------|-------------|------|
| | | |

---

## Device section template

Copy this block once per product / firmware app. Replace placeholders. Do not invent pin numbers that disagree with firmware.

### {{DEVICE_NAME}}

**Firmware app:** `{{APP_DIR}}/`  
**Module:**  
**Protocol / identity (if any):**  
**Role:**  

#### Product decisions (locked for this revision)

| Decision | Choice |
|----------|--------|
| | |

#### GPIO map (must match firmware)

| Function | GPIO / net | Direction | Notes |
|----------|------------|-----------|-------|
| | | | |

#### Power budget (if relevant)

| Load | Typical | Peak | Notes |
|------|---------|------|-------|
| | | | |

#### Bill of materials (prototype)

| Ref | Part | Qty | Notes |
|-----|------|-----|-------|
| | | | |

#### Bring-up checklist

- [ ] Power rails within spec
- [ ] Firmware boots / logs on UART
- [ ] Each GPIO function verified against the map
- [ ] …

#### Firmware modules

| Module / task | Responsibility |
|---------------|----------------|
| | |

#### ECAD / project prompt

<!-- Paste Flux / KiCad / other ECAD prompt or link here -->
