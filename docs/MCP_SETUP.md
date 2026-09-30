# MCP setup (Cosmos harness)

How to install the **local** MCP stack used by Cosmos agents/skills on a new
machine. Remote HTTP MCPs need only Cursor entries; local stdio servers need
clones, builds, and runtime deps.

All paths below assume Linux. Adjust for macOS/Windows as noted in vendor docs.

## After clone of this repo

```bash
cd ~/myProjects/cosmos-embedded-systems   # or your clone path
chmod +x tools/*.sh
# Host CAD first (KiCad + OpenSCAD + FreeCAD): see §2b in this doc
./tools/install-skills.sh
./tools/install-agents.sh
./tools/install-mcps.sh                  # KiCad MCP + Freerouting + mcp.json merge
```

Then **Developer: Reload Window** in Cursor so MCP servers reconnect.

Optional cloud/product copy:

```bash
./tools/install-agents-to-project.sh /path/to/product-repo
./tools/install-skills-to-project.sh /path/to/product-repo
```

## MCP inventory

| Server | Type | Purpose |
|--------|------|---------|
| `espressif-documentation` | HTTP | ESP-IDF / Espressif docs |
| `esp-component-registry` | HTTP | ESP Component Registry |
| `flux` | HTTP | Cloud ECAD agent |
| `microchip` | HTTP | Microchip parts / compliance |
| `mplab-docs` | HTTP | MPLAB / Microchip how-to docs |
| `electronics-docs` | Local stdio | TI / ST / ADI PDF index (`mcp-docs`) |
| `kicad` | Local stdio | Local schematic/PCB (KiCAD-MCP-Server) + Freerouting |
| `kicad-pro` | Local stdio | KiCad MCP Pro — simulation profile (`sim_*`, ngspice CLI) |

Preferred usage by role: `skills/cosmos-embedded/mcp.md`.

Template config: `templates/mcp/mcp.json.example`.  
Live config: `~/.cursor/mcp.json` (not committed; machine-specific paths).

---

## 1. Remote HTTP MCPs

Copy the HTTP entries from `templates/mcp/mcp.json.example` into
`~/.cursor/mcp.json`. No local install. Auth (Flux, etc.) is handled by Cursor
when the server requires it.

---

## 2. electronics-docs (`mcp-docs`)

```bash
mkdir -p ~/MCP
git clone https://github.com/<your-fork-or-upstream>/mcp-docs.git ~/MCP/mcp-docs
# follow that repo's README: npm install && npm run build
```

Point `electronics-docs.args` at `~/MCP/mcp-docs/build/index.js`.

Index database typically lives under `~/.electronics-docs-mcp/`.

---

## 2b. Host CAD applications (install once per machine)

These are **desktop apps**, not MCP servers. Agents use them via CLI/GUI (and
KiCad via the MCP after it is installed). Prefer the recipes below on Linux;
macOS/Windows: use each vendor’s installer, then keep the same roles
(OpenSCAD = agent box, FreeCAD = human refine).

Ensure user binaries are on `PATH` (zsh/bash):

```bash
# once in ~/.zshrc or ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
```

### KiCad 9 or 10 (required for local ECAD MCP)

Needs the GUI **and** the Python `pcbnew` module (`python3 -c "import pcbnew"`).

**Ubuntu / Debian (recommended — KiCad 9 PPA):**

```bash
sudo add-apt-repository -y ppa:kicad/kicad-9.0-releases
sudo apt update
sudo apt install -y kicad
kicad --version
python3 -c "import pcbnew; print(pcbnew.GetBuildVersion())"
```

**Notes**

- Distro packages without the PPA are often too old for this harness.
- KiCad **10** is fine if you install it from the project’s packages; see
  [KiCad downloads](https://www.kicad.org/download/).
- After install, copy global lib tables (see §3) if `~/.config/kicad/9.0/` is empty.

Then run `./tools/install-mcps.sh` (or §3) for the KiCad **MCP** + Freerouting.

### OpenSCAD (agent enclosure iterates)

Preferred for agent-editable lab boxes (`.scad` → STL).

**Option A — AppImage (no root; matches this harness machine):**

```bash
mkdir -p ~/.local/opt/openscad ~/.local/bin
curl -fL --retry 3 \
  -o ~/.local/opt/openscad/OpenSCAD.AppImage \
  https://files.openscad.org/OpenSCAD-2021.01-x86_64.AppImage
chmod +x ~/.local/opt/openscad/OpenSCAD.AppImage

cat > ~/.local/bin/openscad << 'EOF'
#!/usr/bin/env bash
APP="$HOME/.local/opt/openscad/OpenSCAD.AppImage"
# If FUSE is missing, uncomment the next line:
# exec "$APP" --appimage-extract-and-run "$@"
exec "$APP" "$@"
EOF
chmod +x ~/.local/bin/openscad

openscad --version
# openscad -o mech/box.stl mech/box.scad
```

If the AppImage fails with a FUSE error, switch the wrapper to
`--appimage-extract-and-run` (same pattern as FreeCAD below).

**Option B — apt:**

```bash
sudo apt install -y openscad
openscad --version
```

### FreeCAD (human enclosure refine)

Preferred open-source CAD to open the agent’s box STEP/STL (and optionally
Import `.scad` via the OpenSCAD workbench). Fusion / SolidWorks remain optional.

**AppImage (no root; FreeCAD 1.1.x):**

```bash
mkdir -p ~/.local/opt/freecad ~/.local/bin
curl -fL --retry 3 \
  -o ~/.local/opt/freecad/FreeCAD.AppImage \
  https://github.com/FreeCAD/FreeCAD/releases/download/1.1.4/FreeCAD_1.1.4-Linux-x86_64-py311.AppImage
chmod +x ~/.local/opt/freecad/FreeCAD.AppImage

cat > ~/.local/bin/freecad << 'EOF'
#!/usr/bin/env bash
APP="$HOME/.local/opt/freecad/FreeCAD.AppImage"
export PATH="$HOME/.local/bin:$PATH"   # so OpenSCAD WB finds openscad
exec "$APP" --appimage-extract-and-run "$@"
EOF
chmod +x ~/.local/bin/freecad
ln -sfn freecad ~/.local/bin/FreeCAD

freecad --version
# Prefer opening the agent box solid:
#   freecad /path/to/product/mech/*-box.step
# File→Open does NOT support .scad; use GUI OpenSCAD WB → File → Import, or STEP/STL.
```

Check [FreeCAD releases](https://github.com/FreeCAD/FreeCAD/releases) for newer
`Linux-x86_64` AppImages and bump the URL when you upgrade.

---

## 3. KiCad MCP (mixelpixx/KiCAD-MCP-Server)

### Prerequisites

- **KiCad 9.0+** installed (§2b) with Python `pcbnew` (`python3 -c "import pcbnew"`).
- **Node.js 20+** (nvm is fine).
- Global symbol/footprint tables (once per user):

```bash
mkdir -p ~/.config/kicad/9.0
cp -n /usr/share/kicad/template/sym-lib-table ~/.config/kicad/9.0/
cp -n /usr/share/kicad/template/fp-lib-table ~/.config/kicad/9.0/
```

### Install / build

`./tools/install-mcps.sh` does this; manual equivalent:

```bash
mkdir -p ~/MCP
git clone --branch stable https://github.com/mixelpixx/KiCAD-MCP-Server.git ~/MCP/KiCAD-MCP-Server
cd ~/MCP/KiCAD-MCP-Server
npm install
python3 -m venv --system-site-packages .venv
.venv/bin/pip install -U pip
.venv/bin/pip install -r requirements.txt
# Ubuntu often ships python3-pil for 3.10 while python3 is 3.11 — force a venv Pillow:
.venv/bin/pip install --force-reinstall --no-cache-dir 'Pillow>=10'
npm run build
test -f dist/index.js
```

### mcp.json `kicad` entry

Use the venv Python and put the **venv site-packages before** system
`dist-packages` in `PYTHONPATH` so Pillow wins over a broken system PIL.

**Do not** set a custom `PATH` that drops nvm/`node` — Cursor spawns
`command: "node"` with the server env.

```json
"kicad": {
  "command": "node",
  "args": ["$HOME/MCP/KiCAD-MCP-Server/dist/index.js"],
  "env": {
    "NODE_ENV": "production",
    "KICAD_PYTHON": "$HOME/MCP/KiCAD-MCP-Server/.venv/bin/python",
    "PYTHONPATH": "$HOME/MCP/KiCAD-MCP-Server/.venv/lib/python3.11/site-packages:/usr/lib/python3/dist-packages:/usr/share/kicad/scripting/plugins",
    "LOG_LEVEL": "info",
    "KICAD_AUTO_LAUNCH": "false",
    "JAVA_HOME": "$HOME/.local/jdk/current",
    "FREEROUTING_JAR": "$HOME/.kicad-mcp/freerouting.jar"
  }
}
```

Expand `$HOME` to absolute paths in the real file (Cursor does not expand them).

### KiCad 9 vs MCP schematic format

Current KiCAD-MCP-Server stable may write **KiCad 10** schematic tokens
(`body_style`, `in_pos_files`, …). KiCad **9.0.9** then fails to open the
`.kicad_sch` until those tokens are stripped or you upgrade KiCad.

PCB / `pcbnew` SWIG workflows on KiCad 9 still work. Prefer upgrading to KiCad
10 when you want MCP-written schematics to open natively.

### GUI not required

The MCP uses `pcbnew` (SWIG) headless. Open the KiCad GUI only to inspect or for
optional IPC / gui-driver features.

Typical flow: create schematic → assign footprints →
`sync_schematic_to_board` → place → `autoroute` / route → DRC / Gerbers.

---

## 4. Freerouting (autorouter)

Used by KiCad MCP tool `autoroute` / `check_freerouting`.

### Java 21+ (no sudo)

System OpenJDK 11 is **not** enough. User-local Temurin 21:

```bash
mkdir -p ~/.local/jdk ~/.kicad-mcp
curl -fL -o /tmp/temurin21.tar.gz \
  "https://api.adoptium.net/v3/binary/latest/21/ga/linux/x64/jre/hotspot/normal/eclipse?project=jdk"
tar -xzf /tmp/temurin21.tar.gz -C ~/.local/jdk
ln -sfn ~/.local/jdk/jdk-21* ~/.local/jdk/current   # adjust if multiple
export JAVA_HOME="$HOME/.local/jdk/current"
"$JAVA_HOME/bin/java" -version
```

Or: `sudo apt install openjdk-21-jre-headless` and set `JAVA_HOME` to that JRE.

### Freerouting JAR

Prefer **2.0.1** with Java 21 (2.4.x wants Java 25):

```bash
curl -fL -o ~/.kicad-mcp/freerouting.jar \
  https://github.com/freerouting/freerouting/releases/download/v2.0.1/freerouting-2.0.1.jar
```

Set `JAVA_HOME` and `FREEROUTING_JAR` in the `kicad` MCP env (see above), then
Reload Window. Verify with the `check_freerouting` tool.

### Smoke test (CLI, without Cursor)

```bash
export JAVA_HOME="$HOME/.local/jdk/current"
export PATH="$JAVA_HOME/bin:$PATH"
export PYTHONPATH="$HOME/MCP/KiCAD-MCP-Server/.venv/lib/python3.11/site-packages:/usr/lib/python3/dist-packages:$HOME/MCP/KiCAD-MCP-Server/python"
# clear tracks + autoroute via the MCP Python helper (example board path):
"$HOME/MCP/KiCAD-MCP-Server/.venv/bin/python" -c "..."  # or ask the agent to autoroute
```

---

## 5. KiCad MCP Pro + ngspice (optional simulation)

Use a **separate** Cursor MCP entry (`kicad-pro`) so it does not collide with
mixelpixx `kicad`. Needs Python ≥ 3.13 (e.g. `uv` venv) and an ngspice CLI.

Typical layout on this machine:

```text
~/MCP/kicad-mcp-pro/              # clone of LNayak07/kicad-mcp-pro
~/MCP/kicad-mcp-pro-venv/         # uv/python3.13 venv with the package
~/.local/bin/ngspice              # ngspice-36+ user install
```

Example `~/.cursor/mcp.json` entry (adjust project dir per product):

```json
"kicad-pro": {
  "command": "REPLACE_HOME/MCP/kicad-mcp-pro-venv/bin/kicad-mcp-pro",
  "args": [],
  "env": {
    "KICAD_MCP_PROJECT_DIR": "REPLACE_HOME/myProjects/led-blink-kicad",
    "KICAD_MCP_PROFILE": "simulation",
    "KICAD_MCP_OPERATING_MODE": "write",
    "KICAD_MCP_NGSPICE_CLI": "REPLACE_HOME/.local/bin/ngspice"
  }
}
```

Smoke test after reload: `sim_run_transient` on a tiny `.cir` under the project
(e.g. `sim/timing_hi_for_pro.cir`) with `probe_nets` matching net names in the
netlist. Outputs land under `<project>/output/simulation/`.

### ngspice-36 `wrdata` / `write` path quoting

Ubuntu/deb ngspice-36 rejects **quoted absolute paths** in `wrdata` / `write`
(control deck). Upstream `kicad-mcp-pro` emits quotes; patch the installed
module (re-run after `pip`/`uv` upgrades of the package):

```bash
PY="$HOME/MCP/kicad-mcp-pro-venv/lib/python3.13/site-packages/kicad_mcp/utils/ngspice.py"
# Replace: wrdata "{data_path}"  →  wrdata {data_path}
# Replace: write "{raw_path}"    →  write {raw_path}
# Then reload the kicad-pro MCP (or kill its process) so Python reloads the file.
```

`./tools/install-mcps.sh` applies this patch when the venv file exists.

---

## 5b. OpenSCAD / FreeCAD usage (after §2b install)

Install steps: **§2b**. Quick checks:

```bash
openscad --version
openscad -o mech/box.stl mech/box.scad

freecad --version
freecad /path/to/product/mech/*-box.step    # agent box solid
# GUI: OpenSCAD workbench → File → Import → *.scad (optional)
# PCB fit: File → Import mech/<board>.step
```

---

## 6. New PC checklist

1. Install **KiCad 9/10**, **OpenSCAD**, **FreeCAD** per §2b; put `~/.local/bin` on `PATH`.
2. Install Node 20+, git, curl.
3. Clone `cosmos-embedded-systems`; run `install-skills.sh`, `install-agents.sh`,
   `install-mcps.sh`.
4. Clone/build `mcp-docs` if you need electronics-docs.
5. Confirm `~/.cursor/mcp.json` paths exist (`test -f …/dist/index.js`).
6. Reload Cursor → MCP panel shows servers Connected.
7. Ask the agent: “List KiCad tool categories” and “check_freerouting”.
8. Optional: install kicad-pro + ngspice (§5); reload; run `sim_run_transient`.
9. Optional: `openscad -o …stl …scad` and open the box STEP in FreeCAD.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `spawn node ENOENT` | Do not override `PATH` in MCP env; keep nvm node visible |
| `cannot import name '_imaging' from PIL` | Force-reinstall Pillow into the KiCad MCP `.venv` |
| `Error al cargar el esquema` on KiCad 9 | Strip KiCad 10-only tokens or upgrade KiCad |
| Freerouting `ready: false` | Java 21+ via `JAVA_HOME`; JAR at `FREEROUTING_JAR` |
| Empty PCB after schematic | Assign footprints + `sync_schematic_to_board` |
| Auto-save refused | `open_board` / `save_board` with `force=true` after external edits |
| `sim_run_transient` missing `.data` / quoted path in log | Unquote `wrdata`/`write` in `ngspice.py` (see §5); restart `kicad-pro` |
| `openscad` / `freecad` not found | Install §2b; ensure `~/.local/bin` is on `PATH` |
| AppImage FUSE error | Use `--appimage-extract-and-run` in the wrapper (FreeCAD recipe) |
| `File format not supported: *.scad` in FreeCAD | Open `*-box.step` / `.stl`, or GUI Import in OpenSCAD WB |
