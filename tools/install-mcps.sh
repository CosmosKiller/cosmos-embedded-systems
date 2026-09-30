#!/usr/bin/env bash
# Install / refresh local Cosmos MCP dependencies (KiCad MCP + Freerouting + Java 21)
# and merge entries into ~/.cursor/mcp.json from templates/mcp/mcp.json.example.
#
# Does not require sudo. Safe to re-run (idempotent where possible).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOME_DIR="${HOME}"
MCP_ROOT="${MCP_ROOT:-${HOME_DIR}/MCP}"
KICAD_MCP="${MCP_ROOT}/KiCAD-MCP-Server"
JDK_ROOT="${HOME_DIR}/.local/jdk"
JAR_DIR="${HOME_DIR}/.kicad-mcp"
MCP_JSON="${HOME_DIR}/.cursor/mcp.json"
EXAMPLE="${ROOT}/templates/mcp/mcp.json.example"
FREEROUTING_URL="https://github.com/freerouting/freerouting/releases/download/v2.0.1/freerouting-2.0.1.jar"
KICAD_REPO_URL="${KICAD_REPO_URL:-https://github.com/mixelpixx/KiCAD-MCP-Server.git}"
KICAD_BRANCH="${KICAD_BRANCH:-stable}"

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "missing command: $1"
}

need_cmd git
need_cmd curl
need_cmd node
need_cmd npm
need_cmd python3

mkdir -p "${MCP_ROOT}" "${JAR_DIR}" "${JDK_ROOT}" "${HOME_DIR}/.cursor"

# --- KiCad global library tables (once) ---
if [[ -d /usr/share/kicad/template ]]; then
  mkdir -p "${HOME_DIR}/.config/kicad/9.0"
  if [[ ! -f "${HOME_DIR}/.config/kicad/9.0/sym-lib-table" ]]; then
    log "Installing KiCad 9 global sym-lib-table / fp-lib-table"
    cp -n /usr/share/kicad/template/sym-lib-table "${HOME_DIR}/.config/kicad/9.0/" || true
    cp -n /usr/share/kicad/template/fp-lib-table "${HOME_DIR}/.config/kicad/9.0/" || true
  fi
fi

# --- Temurin 21 JRE (user-local) ---
java_ok=0
if [[ -x "${JDK_ROOT}/current/bin/java" ]]; then
  if "${JDK_ROOT}/current/bin/java" -version 2>&1 | grep -qE '"2[1-9]\.|\"[3-9][0-9]\.'; then
    java_ok=1
  fi
fi
if [[ "${java_ok}" -eq 0 ]]; then
  log "Downloading Eclipse Temurin 21 JRE to ${JDK_ROOT}"
  tmp="$(mktemp /tmp/temurin21.XXXXXX.tar.gz)"
  curl -fL --retry 3 -o "${tmp}" \
    "https://api.adoptium.net/v3/binary/latest/21/ga/linux/x64/jre/hotspot/normal/eclipse?project=jdk"
  tar -xzf "${tmp}" -C "${JDK_ROOT}"
  rm -f "${tmp}"
  # Point current at the extracted jdk-21* directory
  latest="$(find "${JDK_ROOT}" -maxdepth 1 -type d -name 'jdk-21*' | sort | tail -1)"
  [[ -n "${latest}" ]] || die "Temurin extract failed"
  ln -sfn "${latest}" "${JDK_ROOT}/current"
fi
log "JAVA_HOME -> ${JDK_ROOT}/current ($("${JDK_ROOT}/current/bin/java" -version 2>&1 | head -1))"

# --- Freerouting JAR ---
if [[ ! -s "${JAR_DIR}/freerouting.jar" ]]; then
  log "Downloading Freerouting 2.0.1 -> ${JAR_DIR}/freerouting.jar"
  curl -fL --retry 3 -o "${JAR_DIR}/freerouting.jar" "${FREEROUTING_URL}"
else
  log "Freerouting JAR already present"
fi

# --- KiCAD-MCP-Server ---
if [[ ! -d "${KICAD_MCP}/.git" ]]; then
  log "Cloning KiCAD-MCP-Server (${KICAD_BRANCH}) -> ${KICAD_MCP}"
  git clone --branch "${KICAD_BRANCH}" "${KICAD_REPO_URL}" "${KICAD_MCP}"
else
  log "KiCAD-MCP-Server already cloned"
fi

log "Building KiCAD-MCP-Server"
(
  cd "${KICAD_MCP}"
  npm install
  if [[ ! -d .venv ]]; then
    python3 -m venv --system-site-packages .venv
  fi
  .venv/bin/pip install -U pip
  .venv/bin/pip install -r requirements.txt
  .venv/bin/pip install --force-reinstall --no-cache-dir 'Pillow>=10'
  npm run build
  test -f dist/index.js
  .venv/bin/python -c "import pcbnew; from PIL import Image; print('pcbnew', pcbnew.GetBuildVersion(), 'PIL', Image.__version__)"
)

# Detect python minor for site-packages path
PY_VER="$("${KICAD_MCP}/.venv/bin/python" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
VENV_SITE="${KICAD_MCP}/.venv/lib/python${PY_VER}/site-packages"

# --- Optional: patch kicad-mcp-pro ngspice wrdata quoting (ngspice-36) ---
# Upstream quotes absolute paths; Ubuntu ngspice-36 rejects that and leaves no .data.
KICAD_PRO_NGSPICE="${MCP_ROOT}/kicad-mcp-pro-venv/lib/python3.13/site-packages/kicad_mcp/utils/ngspice.py"
if [[ -f "${KICAD_PRO_NGSPICE}" ]]; then
  log "Patching kicad-mcp-pro ngspice.py wrdata/write paths (unquoted for ngspice-36)"
  python3 - "${KICAD_PRO_NGSPICE}" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
text = p.read_text()
orig = text
text = text.replace(
    "wrdata_line = f'wrdata \"{data_path}\" {\" \".join(header_exprs)}'",
    "wrdata_line = f'wrdata {data_path} {\" \".join(header_exprs)}'  # unquoted: ngspice-36",
)
text = text.replace("f'write \"{raw_path}\" all\\n'", "f'write {raw_path} all\\n'")
text = text.replace('f\'write "{raw_path}" all\\n\'', "f'write {raw_path} all\\n'")
if text == orig:
    if 'wrdata {data_path}' in text or "wrdata {data_path}" in text:
        print("already patched")
    else:
        print("warn: expected wrdata pattern not found; leave file unchanged")
else:
    p.write_text(text)
    print(f"patched {p}")
PY
else
  log "Skip kicad-pro wrdata patch (no ${KICAD_PRO_NGSPICE})"
fi

# --- Merge mcp.json ---
[[ -f "${EXAMPLE}" ]] || die "missing ${EXAMPLE}"
python3 - "${EXAMPLE}" "${MCP_JSON}" "${HOME_DIR}" "${KICAD_MCP}" "${VENV_SITE}" "${JDK_ROOT}/current" "${JAR_DIR}/freerouting.jar" <<'PY'
import json, sys, shutil
from pathlib import Path
from datetime import datetime

example_path, mcp_path, home, kicad_mcp, venv_site, java_home, jar = sys.argv[1:8]
example = json.loads(Path(example_path).read_text())
mcp_file = Path(mcp_path)
if mcp_file.exists():
    backup = mcp_file.with_suffix(mcp_file.suffix + f".bak.{datetime.now():%Y%m%d%H%M%S}")
    shutil.copy2(mcp_file, backup)
    print(f"backed up existing mcp.json -> {backup}")
    data = json.loads(mcp_file.read_text())
else:
    data = {"mcpServers": {}}

servers = data.setdefault("mcpServers", {})

def abs_replace(obj):
    if isinstance(obj, str):
        return obj.replace("REPLACE_HOME", home)
    if isinstance(obj, list):
        return [abs_replace(x) for x in obj]
    if isinstance(obj, dict):
        return {k: abs_replace(v) for k, v in obj.items()}
    return obj

# Merge HTTP / remote servers from example if missing
for name, cfg in example.get("mcpServers", {}).items():
    if name == "kicad":
        continue
    if name == "electronics-docs":
        # only merge if build exists
        built = Path(home) / "MCP" / "mcp-docs" / "build" / "index.js"
        if not built.is_file():
            print(f"skip electronics-docs (missing {built})")
            continue
    if name not in servers:
        servers[name] = abs_replace(cfg)
        print(f"added mcp server: {name}")
    else:
        print(f"keep existing mcp server: {name}")

# Always refresh kicad entry paths for this machine
kicad_cfg = abs_replace(example["mcpServers"]["kicad"])
kicad_cfg["args"] = [f"{kicad_mcp}/dist/index.js"]
env = kicad_cfg.setdefault("env", {})
env["KICAD_PYTHON"] = f"{kicad_mcp}/.venv/bin/python"
env["PYTHONPATH"] = f"{venv_site}:/usr/lib/python3/dist-packages:/usr/share/kicad/scripting/plugins"
env["JAVA_HOME"] = java_home
env["FREEROUTING_JAR"] = jar
# Never set PATH here — Cursor must still find nvm node
env.pop("PATH", None)
servers["kicad"] = kicad_cfg
print("updated mcp server: kicad")

mcp_file.write_text(json.dumps(data, indent=4) + "\n")
print(f"wrote {mcp_file}")
PY

log "Done."
echo
echo "Next:"
echo "  1. Cursor → Developer: Reload Window"
echo "  2. Settings → MCP → confirm kicad Connected"
echo "  3. Ask agent: check_freerouting / list_tool_categories"
echo
echo "Full docs: ${ROOT}/docs/MCP_SETUP.md"
