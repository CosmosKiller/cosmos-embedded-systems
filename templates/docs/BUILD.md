# Build system

Platform-specific build, flash, and artifact instructions for this project. Fill after the platform is locked in [ARCHITECTURE.md](ARCHITECTURE.md).

**Language:** English only.

---

## Platform

| Field | Value |
|-------|--------|
| MCU / module | |
| Framework / SDK | |
| Pinned version / container | |
| Host assumptions | |

## Pinned toolchains (tested)

| Tool | Version / image | Notes |
|------|-----------------|-------|
| | | |

## Environment

Document how to open a shell with the SDK on `PATH` (export scripts, container, VS Code / Cursor tasks, etc.).

```bash
# Example — replace with the agreed platform
# . ./export.sh
```

## Per-app targets

| App dir | Target / board | Default config files | Notes |
|---------|----------------|----------------------|-------|
| | | | |

## Build commands

### Single app

```bash
# cd {{app}}
# <configure target>
# <build>
```

### Build all apps

```bash
# ./tools/scripts/build_all.sh
```

## Artifacts

| Artifact | Path | Purpose |
|----------|------|---------|
| App binary | | Factory flash / debug |
| OTA image | | Field update (if applicable) |
| Map / elf | | Debugging |

## Clean rebuild

```bash
# <clean> && <reconfigure> && <build>
```

## Related

- Version bumps: [RELEASING.md](RELEASING.md)
- Factory flash: [MANUFACTURING.md](MANUFACTURING.md)
- Pinout SoT: [HARDWARE.md](HARDWARE.md)
