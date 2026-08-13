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
2. Use the connected server that matches the domain (names vary by install; match by purpose).
3. If a call fails (auth, missing server), report that once and fall back.

## Preferred servers (when connected)

| Domain | Typical MCP | Use for |
|--------|-------------|---------|
| ESP-IDF / Espressif APIs, Kconfig, Matter-on-Espressif | Espressif documentation | Datasheets/guides, API behavior, recommended configs |
| Reusable ESP-IDF modules | ESP Component Registry | Find/add components (`idf.py add-dependency`), versions |
| Schematic / PCB / BOM / nets | Flux | Read or change the board via the Flux agent (message for edits; table reads for inventory) |

Role-specific defaults:

- **Architect** — Espressif docs for MCU/SDK trade-offs *after* the human is considering Espressif; Flux only for feasibility of an existing board, not to pick a platform silently.
- **Firmware** — Espressif docs + Component Registry before guessing APIs or vendoring drivers.
- **Hardware** — Flux for schematic/PCB/BOM/net questions and design changes; keep `docs/HARDWARE.md` as GPIO SoT.
- **Manufacturing / Release** — Espressif docs when factory/OTA/partition guidance is Espressif-specific.
- **Home Assistant** — no Cosmos-standard HA MCP yet; use product `home-assistant/` + HA docs. Use Espressif/Matter MCP only for entity/cluster contracts.

## Flux notes (hardware)

- One design objective per message; wait for the Flux run to finish before sending the next.
- Read components/nets/BOM from the project; ask the wiki for holistic questions; message the agent to change the design.
- Do not claim a layout/schematic change landed unless a Flux response confirms it.
