# Manufacturing

Factory data, flashing, identity (QR / serial), and ship kits for this project. Depends on the platform locked in [ARCHITECTURE.md](ARCHITECTURE.md) and build artifacts from [BUILD.md](BUILD.md).

**Language:** English only.

---

## Scope

| Field | Value |
|-------|--------|
| Products / SKUs covered | |
| Identity scheme | (e.g. Matter DAC, custom serial, none) |
| Factory station assumptions | |

## Prerequisites

- Firmware build succeeds per [BUILD.md](BUILD.md)
- Manufacturing tools installed / paths exported
- Access to credentials store (test vs production)

```bash
# Export / activate manufacturing tooling
```

## SKU / product map

| Product | App dir | PID / identity | Notes |
|---------|---------|----------------|-------|
| | | | |

## Workflow overview

1. Build release firmware (once per release)
2. Generate per-unit factory data / identity
3. Flash each unit (app + factory partition / NVS as required)
4. Run factory test / bring-up smoke
5. Label, pack, and ship

## Step 1 — Build firmware (once per release)

```bash
# Per-SKU build commands
```

## Step 2 — Generate factory data

```bash
# Generate N units of identity / QR / certs into out/
```

Document output layout:

```text
out/{{batch}}/
├── {{sku}}/
│   ├── unit-0001/
│   └── …
```

## Step 3 — Flash each unit

```bash
# Flash app + factory data; record serial ↔ port mapping
```

## Step 4 — Factory test

- [ ] Power / current within limits
- [ ] Radio / protocol smoke (if applicable)
- [ ] Sensors / actuators against [HARDWARE.md](HARDWARE.md) GPIO map
- [ ] Identity readable (QR / serial / commissioner)

## Step 5 — Ship kit

| Item | Qty | Notes |
|------|-----|-------|
| Device | 1 | |
| Label / QR | 1 | |
| Quick start | optional | |

## Test credentials vs production

| Environment | Credentials | Allowed use |
|-------------|-------------|-------------|
| Lab / beta | Test vendor / test PAAs | Internal and limited beta only |
| Production | Production PKI | Shipping SKUs |

Never mix production private material into public repos.

## Troubleshooting

| Symptom | Likely cause | Action |
|---------|--------------|--------|
| | | |

## Related

- [BUILD.md](BUILD.md)
- [HARDWARE.md](HARDWARE.md)
- [RELEASING.md](RELEASING.md)
- [ARCHITECTURE.md](ARCHITECTURE.md)
