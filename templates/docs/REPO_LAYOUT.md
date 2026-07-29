# Repository layout

Target professional baseline for Cosmos embedded firmware repos. Shaped by ESP-IDF conventions (`main/`, `components/`, `sdkconfig.defaults`) but adaptable to other C/C++ frameworks: keep the **separation of apps, shared libraries, docs, and tools**.

**Language:** English only.

## Top-level

```
{{REPO_NAME}}/
├── README.md
├── LICENSE
├── docs/
│   ├── ARCHITECTURE.md      # human ↔ architect agreement + plan
│   ├── HARDWARE.md          # HW source of truth
│   ├── BUILD.md             # platform build system
│   ├── MANUFACTURING.md     # factory / flash / ship
│   ├── CODE_STYLE.md        # shared style (this harness)
│   ├── REPO_LAYOUT.md       # this file
│   └── RELEASING.md         # versioning / tags
├── components/              # shared libraries (framework-native layout)
├── {{app_one}}/             # thin product apps
├── {{app_two}}/
├── tools/
│   ├── mfg/                 # manufacturing helpers
│   └── scripts/
└── .github/workflows/       # optional CI matrix builds
```

## Per-app layout (preferred)

**Option B — public headers in `tasks/`, implementations in `main/`**

```
{{app}}/
├── main/          # .c / .cpp implementations, entrypoint, app CMake/build files
├── tasks/         # public headers (*.h) only
└── CMakeLists.txt # or framework equivalent
```

Rules:

- **1:1 basename** between `tasks/foo.h` and `main/foo.cpp` (or `.c`) for app-local modules
- Register include paths so `main/` can see `../tasks`
- Keep device-specific GPIO maps and endpoints in the app; move only identical logic to `components/`

**Option A — headers co-located** (acceptable for tiny apps):

```
{{app}}/
├── main/
│   ├── main.cpp
│   ├── matter_task.cpp
│   └── matter_task.h
└── CMakeLists.txt
```

Pick **one** convention per repo and apply it everywhere. Default recommendation: **Option B**.

## Shared components

Shared modules use a **role-based** layout (not forced 1:1 header/source names):

```
components/{{name}}/
├── include/           # public headers
├── *.c / *.cpp        # role-named sources (*_task, *_adc, …)
├── CMakeLists.txt     # or framework equivalent
└── optional manifest  # e.g. idf_component.yml
```

Extract only what is **identical** across apps. Keep endpoint creation, pin maps, and product behavior in each app.

## Config and generated files

| Track in git | Do not track |
|--------------|--------------|
| Framework defaults (`sdkconfig.defaults*`, `prj.conf`, …) | Local generated config (`sdkconfig`, build trees) |
| Partition / linker / board overlay files you own | `build/`, `managed_components/`, `out/`, local logs |
| `docs/`, sources, CI | Secrets, factory private keys (use secure storage) |

## CI

Prefer a matrix build: each firmware app × target, using only tracked defaults (no hand-edited local config). Document exact commands in [BUILD.md](BUILD.md).
