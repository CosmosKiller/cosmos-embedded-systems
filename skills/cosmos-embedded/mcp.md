# MCP usage (Cosmos roles)

Subagents **inherit MCP tools from the parent** ([Cursor FAQ](https://cursor.com/docs/subagents.md)). Prefer those tools over generic web search when they cover the question.

## Local vs cloud

| Session | Which MCP servers |
|---------|-------------------|
| Local Agent / local subagent | Servers enabled in **this** Cursor session |
| Cloud Agent / cloud subagent (`/in-cloud`) | Team/personal servers at [cursor.com/agents](https://cursor.com/agents) — **not** the laptop MCP list |

If a needed server is missing, say so and continue with docs/repo evidence. Do not invent tool results.

## How to call

1. Discover the server/tool schema first, then invoke.
2. Use the connected server that matches the **agreed platform** (names vary by install; match by purpose).
3. If a call fails (auth, missing server), report that once and fall back.

## Preferred servers (when connected)

| Domain | Typical MCP | Use for |
|--------|-------------|---------|
| ESP-IDF / Espressif APIs, Kconfig, Matter-on-Espressif | Espressif documentation | Datasheets/guides, API behavior, recommended configs |
| Reusable ESP-IDF modules | ESP Component Registry | Find/add components (`idf.py add-dependency`), versions |
| Microchip product / inventory / compliance | Microchip (`api.microchip.com/mcp/resources`) | Part pick, stock, datasheet links, RoHS |
| Microchip how-to / code / MPLAB docs | MPLAB-DOCS | Vector search over Microchip technical docs and examples |
| TI / ST / ADI datasheets & TRMs | electronics-docs (`mcp-docs`) | Index and quote official PDFs (local FTS) |
| Schematic / PCB / BOM / nets | Flux | Read or change the board via the Flux agent |
| KiCad local ECAD | KiCad MCP (`kicad`) | Local schematic/PCB + Freerouting when Flux is not the ECAD path |

Install / new-PC notes: harness `docs/MCP_SETUP.md` and `./tools/install-mcps.sh`.

### Platform → MCP map

| Locked platform (ARCHITECTURE.md) | Prefer first |
|-----------------------------------|--------------|
| ESP-IDF / ESP32 family | Espressif docs + Component Registry |
| Microchip (PIC / AVR / SAM / dsPIC) | Microchip + MPLAB-DOCS |
| STM32 / ST | electronics-docs (`vendor=ST`) |
| TI (MSPM0, C2000, Sitara, …) | electronics-docs (`vendor=TI`) |
| Analog Devices | electronics-docs (`vendor=ADI`) |
| Board / pinout / BOM edits | Flux (and/or KiCad) |

Do **not** query Espressif MCP for an STM32 project (or the reverse). Match the locked platform.

## Role-specific defaults

- **Architect** — After the human is considering a vendor, use that vendor’s MCP for trade-offs. Never silently lock a platform. Flux only for feasibility of an existing board.
- **Firmware** — Use the platform MCP before guessing APIs or vendoring drivers (Espressif / MPLAB-DOCS / electronics-docs).
- **Hardware** — Flux (or KiCad) for schematic/PCB/BOM; keep `docs/HARDWARE.md` as GPIO SoT. Use electronics-docs / Microchip for part datasheets when picking passives/ICs.
- **Manufacturing / Release** — Platform MCP when factory/OTA/partition guidance is vendor-specific.
- **Home Assistant** — No Cosmos-standard HA MCP yet; product `home-assistant/` + HA docs. Use platform MCP only for entity/cluster contracts.

## electronics-docs notes (TI / ST / ADI)

Local stdio server; index at `~/.electronics-docs-mcp/docs.db`.

Typical flow:

1. `lookup_doc` / `search_docs` for the part.
2. `read_doc` with a **direct PDF URL** to index it.
3. `query_doc_content` → `read_doc_page` for grounded quotes.

Prefer this over generic web search for register maps and electrical ratings.

## Microchip notes

- **microchip** — which part, stock, compliance, datasheet URLs.
- **mplab-docs** — how to configure peripherals and write code (closer to Espressif docs MCP).

Use both when the platform is Microchip.

## Flux notes (hardware)

- One design objective per message; wait for the Flux run to finish before sending the next.
- Read components/nets/BOM from the project; ask the wiki for holistic questions; message the agent to change the design.
- Do not claim a layout/schematic change landed unless a Flux response confirms it.

## KiCad MCP notes (local ECAD)

- GUI not required for SWIG tools (`create_project`, schematic, `sync_schematic_to_board`, place, `autoroute`).
- After schematic: assign footprints → `sync_schematic_to_board` → place → route.
- Prefer `autoroute` (Freerouting) over naive `route_pad_to_pad` straight lines.
- Needs `JAVA_HOME` (21+) and `FREEROUTING_JAR` (~/.kicad-mcp/freerouting.jar`). Verify with `check_freerouting`.
- Do **not** put a restricted `PATH` in the MCP env (breaks `node` spawn / nvm).
- KiCad 9 may reject schematics written with KiCad 10-only tokens; strip or upgrade (see `docs/MCP_SETUP.md`).
