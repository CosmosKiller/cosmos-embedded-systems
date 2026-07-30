# Home Assistant adoption — {{PROJECT_NAME}}

How this product is commissioned and used inside Home Assistant: packages, Lovelace, and any custom cards or integrations.

**Language:** English only.  
**Owner role:** `cosmos-home-assistant`

Canonical HA assets live under `home-assistant/` in this repo unless Architecture points at a field repo for deploy copies only.

---

## Status

| Field | Value |
|-------|--------|
| Status | `draft` / `mvp` / `gift-ready` / `production` |
| Connectivity path | Matter / MQTT / ESPHome / other — *from ARCHITECTURE.md* |
| Adoption rung | native → package → lovelace → custom card → panel → custom integration |
| Last updated | YYYY-MM-DD |

---

## 1. User journey

### Commission / add device

1. …
2. …

### Daily use (happy path)

- …

### Explicit non-goals (HA side)

- …

---

## 2. Entity role map

After commissioning, rename devices/entities to the targets below (or update packages/Lovelace to match).

| Role | Domain | Target entity / device name | Notes |
|------|--------|-------------------------------|-------|
| | | | |

---

## 3. Decision record

| Rung chosen | Why lighter rungs were not enough |
|-------------|-----------------------------------|
| | |

---

## 4. Packages

| File | Purpose |
|------|---------|
| `home-assistant/packages/…` | |

### Install

1. Copy package file(s) → HA `/config/packages/`
2. Ensure:

```yaml
homeassistant:
  packages: !include_dir_named packages
```

3. Developer tools → Check configuration → restart HA.
4. Resolve every `# TODO` entity id.

---

## 5. Lovelace

| File | Dashboard path | Notes |
|------|----------------|-------|
| `home-assistant/lovelace/…` | `/lovelace/…` | Stock cards unless noted |

### Install

1. Edit dashboard → Raw configuration editor (or YAML mode).
2. Under `views:`, paste the view as one list item.
3. Align entity ids with the package checklist.
4. Save and open the documented path.

---

## 6. Custom cards / web UI (optional)

| Asset | Install | Required for MVP? |
|-------|---------|-------------------|
| | HACS / `www/` / other | yes / no |

---

## 7. Custom integration (optional)

| Component | Config flow | Firmware dependency |
|-----------|-------------|---------------------|
| | | |

---

## 8. UI-only HA steps

Document integrations that cannot be YAML (example: some camera platforms):

1. …

---

## 9. Field / fleet sync (optional)

| Canonical (this repo) | Deploy copy |
|-----------------------|-------------|
| `home-assistant/packages/` | |
| `home-assistant/lovelace/` | |

---

## 10. Verification checklist

- [ ] Package loads without config errors
- [ ] Helpers / automations appear as documented
- [ ] Lovelace view usable on phone and desktop
- [ ] Notify / safety paths tested (if any)
- [ ] Gift walkthrough reviewed by a non-author

---

## Related

- [ARCHITECTURE.md](ARCHITECTURE.md)
- [RELEASING.md](RELEASING.md) — firmware versions packages assume
- `home-assistant/README.md` — short install mirror for operators
