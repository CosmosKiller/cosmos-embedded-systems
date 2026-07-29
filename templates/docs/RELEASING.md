# Releasing firmware apps

Versioning rules for Cosmos firmware products. Adapt variable names to the platform (ESP-IDF example below); keep the SemVer meaning and monotonic build number rules.

**Language:** English only.

## Version fields

Each app sets version in its build entrypoint (e.g. root `CMakeLists.txt`):

| Variable | Role |
|----------|------|
| `PROJECT_VER` | Human string **`MAJOR.MINOR.PATCH`** (e.g. `0.1.0`, `1.1.0`) — product / OTA software version string |
| `PROJECT_VER_NUMBER` | Monotonic integer — must stay in sync with any Kconfig / config mirror (e.g. `CONFIG_DEVICE_SOFTWARE_VERSION_NUMBER`) |

Always keep three numeric components. Do **not** use `1.0` or `1.1`; use `1.0.0` / `1.1.0`.

## Current app versions

| App | `PROJECT_VER` | `PROJECT_VER_NUMBER` |
|-----|---------------|----------------------|
| | | |

## When to bump what

Treat `PROJECT_VER` like [SemVer](https://semver.org/) for **product behavior**. On **every** tagged release that ships to devices, also increment `PROJECT_VER_NUMBER` by at least 1 when the platform requires a higher software version for OTA.

### `PATCH` — `x.y.Z` → `x.y.(Z+1)`

Ship when the change is a fix or small internal tweak with **no intentional behavior / API / hardware contract change**:

- Bug fixes
- Performance / logging without new user-visible contracts
- Docs-only does **not** need a firmware version bump

### `MINOR` — `x.Y.z` → `x.(Y+1).0`

Ship when you add **backward-compatible** capability:

- New optional attribute / helper that old clients can ignore
- New non-breaking feature
- Carrier-compatible GPIO still matches [HARDWARE.md](HARDWARE.md) for that revision

Reset `PATCH` to `0` when bumping `MINOR`.

### `MAJOR` — `X.y.z` → `(X+1).0.0`

Ship when something **breaks or redefines** the product contract:

- GPIO / pinout change that needs a new PCB revision
- Protocol endpoint / device-type change that requires re-commission or client remapping
- Removing or renaming user-visible behavior
- First production cut from a `0.x` line → **`1.0.0`**

Reset `MINOR` and `PATCH` to `0` when bumping `MAJOR`.

### Pre-`1.0.0` (`0.x.y`)

`0.MINOR.PATCH` means **still evolving**. Prefer frequent bumps while iterating; jump to **`1.0.0`** when the SKU is ready for external installs with a frozen pinout + protocol model for that hardware rev.

Breaking changes **are allowed** in `0.x` without a major bump, but still document them and always increment `PROJECT_VER_NUMBER` when required for OTA.

### `PROJECT_VER_NUMBER` (always)

| Rule | Detail |
|------|--------|
| Monotonic | Every OTA-able build that may reach a device must have a **higher** number than the last flashed build |
| Sync | Keep the integer in lockstep with any config mirror |
| Independent of SemVer math | Never reuse a number |

## Tag naming

One tag per app release (not a single monorepo version), unless the repo is single-app:

```text
{{app-dir}}-v{{PROJECT_VER}}
```

Example: `iotDoorSensor-v1.1.0`

## Checklist before tagging

1. Decide PATCH / MINOR / MAJOR using the rules above.
2. Bump version fields and any config mirrors.
3. Update the version table in this file.
4. Clean build succeeds; produce OTA / factory artifacts per [BUILD.md](BUILD.md) and [MANUFACTURING.md](MANUFACTURING.md).
5. Update [HARDWARE.md](HARDWARE.md) / [MANUFACTURING.md](MANUFACTURING.md) if pins or factory steps changed.
6. Create an annotated tag from the release branch and push it.
7. Do **not** force-push tags that were already used for flashed units.
