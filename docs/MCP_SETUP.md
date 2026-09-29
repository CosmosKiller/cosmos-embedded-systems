# MCP setup (Cosmos harness)

How to install the **local** MCP stack used by Cosmos agents/skills on a new
machine. Remote HTTP MCPs need only Cursor entries; local stdio servers need
clones, builds, and runtime deps.

All paths below assume Linux. Adjust for macOS/Windows as noted in vendor docs.

## After clone of this repo

```bash
cd ~/myProjects/cosmos-embedded-systems   # or your clone path
chmod +x tools/*.sh
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

## 3. KiCad MCP (mixelpixx/KiCAD-MCP-Server)

### Prerequisites

- **KiCad 9.0+** with Python `pcbnew` (`python3 -c "import pcbnew"`).
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

## 5. New PC checklist

1. Install KiCad 9 or 10, Node 20+, git, curl.
2. Clone `cosmos-embedded-systems`; run `install-skills.sh`, `install-agents.sh`,
   `install-mcps.sh`.
3. Clone/build `mcp-docs` if you need electronics-docs.
4. Confirm `~/.cursor/mcp.json` paths exist (`test -f …/dist/index.js`).
5. Reload Cursor → MCP panel shows servers Connected.
6. Ask the agent: “List KiCad tool categories” and “check_freerouting”.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `spawn node ENOENT` | Do not override `PATH` in MCP env; keep nvm node visible |
| `cannot import name '_imaging' from PIL` | Force-reinstall Pillow into the KiCad MCP `.venv` |
| `Error al cargar el esquema` on KiCad 9 | Strip KiCad 10-only tokens or upgrade KiCad |
| Freerouting `ready: false` | Java 21+ via `JAVA_HOME`; JAR at `FREEROUTING_JAR` |
| Empty PCB after schematic | Assign footprints + `sync_schematic_to_board` |
| Auto-save refused | `open_board` / `save_board` with `force=true` after external edits |
