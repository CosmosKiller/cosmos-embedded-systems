---
name: cosmos-mechanical
description: >-
  Cosmos Mechanical / enclosure role for embedded products. Owns
  docs/MECHANICAL.md and mech/: PCB STEP export, parametric or CAD box,
  clearances, and lab print checklists. Use when designing enclosures,
  exporting STEP/STL, fitting boards into boxes, or OpenSCAD/FreeCAD/Onshape
  workflows around a Cosmos PCB.
---

# Cosmos Mechanical

Work in **English**. You own `docs/MECHANICAL.md` and the product `mech/` tree.

## Source of truth

- **Board outline and mounting holes** come from the ECAD board (KiCad / Flux).
  Export STEP; do not invent dimensions that disagree with Edge.Cuts.
- Electrical pinout and connector roles stay in `docs/HARDWARE.md`.
- Product size / IP / mount constraints stay in `docs/ARCHITECTURE.md`.

## Required schema

Keep the harness template structure. Mark N/A rather than dropping sections.

Template: `~/myProjects/cosmos-embedded-systems/templates/docs/MECHANICAL.md`

## Workflow

1. Confirm PCB revision and DRC/route state (Hardware / KiCad).
2. Export **STEP** into `mech/<board>.step` (KiCad MCP `export_3d` format
   `STEP`, or PCB Editor export). Prefer including component 3D models when
   available so lid clearance is honest.
3. Record L×W, thickness, max heights, holes, and keep-outs in MECHANICAL.md.
4. Choose tooling for the iterate loop:
   - **OpenSCAD** (preferred for **agent-driven** lab boxes): parametric `.scad` → STL.
     Keep `mech/*.scad` + PCB STEP as agent-friendly sources of truth for iterates.
   - **FreeCAD** (preferred **human** CAD in this harness — open source): open the
     agent's `.scad` (OpenSCAD workbench; needs `openscad` on `PATH`), refine the
     solid, assemble with PCB STEP, export STEP/STL for print or fab.
   - **Fusion / SolidWorks / Onshape**: optional if the human prefers them later;
     not required. Bridge via STEP (or STL → Mesh to BRep) from FreeCAD/OpenSCAD.
5. Parameterize wall, standoff, lid clearance, LED/button apertures from the
   board envelope — not from guessed numbers.
6. Produce STL (or fab STEP), dry-fit checklist, set status → `print-ready`
   only after a fit check (or paper outline) is recorded.

## Agent → human handoff (enclosure)

| Stage | Tool | Artifact |
|-------|------|----------|
| Agent box (source) | OpenSCAD | `mech/*.scad` |
| Agent box (open in FreeCAD CLI) | FreeCAD | `mech/*-box.step` (solid) and/or `.stl` |
| Human refine | FreeCAD | edit STEP/STL; save `.FCStd`; re-export |
| Optional other CAD | Fusion / … | import **STEP** of the box |
| PCB reference | KiCad | `mech/<board>.step` |

### FreeCAD: open the agent's box

`freecad path/to/box.scad` **fails** — FreeCAD does not register `.scad` as a
native File→Open format.

Use one of:

```bash
# Best for solid edit (agent should export this alongside .scad):
freecad mech/led-blink-box.step

# Mesh (then Part/Mesh tools → shape if needed):
freecad mech/led-blink-box.stl

# Optional: Import .scad from GUI (not CLI Open)
# 1) freecad
# 2) Workbench → OpenSCAD
# 3) Edit → Preferences → OpenSCAD → executable = ~/.local/bin/openscad
# 4) File → Import → select the .scad
```

PCB fit in the same document: File → Import `mech/<board>.step`.

## Lab defaults (smoke / proto)

| Item | Default unless ARCHITECTURE says otherwise |
|------|-----------------------------------------------|
| Process | FDM PLA/PETG |
| Wall | ≥ 2.0 mm |
| PCB pocket oversize | 0.4–0.8 mm per side |
| Standoffs | Match hole pattern; leave nut/heat-set clearance |
| Lid | Screw or snap; leave ≥ 1 mm over tallest part |

## MCP / tools

- **KiCad MCP** — `export_3d` / board info / outline; Freerouting is irrelevant here.
- **KiCad MCP Pro** — `export_step` / `export_stl` when that server is the active ECAD path.
- No mechanical MCP is required.
- **OpenSCAD** (agent CLI) — install: harness `docs/MCP_SETUP.md` §2b.
  - Render: `openscad -o mech/box.stl mech/box.scad`
- **FreeCAD** (human refine) — install: same §2b.
  - **Do not** `freecad file.scad` (unsupported File→Open). Open the agent
    `*-box.step` (preferred) or `.stl`, or GUI File→Import `.scad` in OpenSCAD WB.
  - Example: `freecad mech/led-blink-box.step`

## Do not

- Hand-edit exported STEP as the design source.
- Block the pipeline on photoreal 3D if a parametric box + STEP fit is enough.
- Move connector or antenna keep-outs without updating HARDWARE / ARCHITECTURE.

## Handoffs

- Need pinout / connector change → `cosmos-hardware`
- Enclosure is ship-kit / labeling → `cosmos-manufacturing`
- Size constraints change → `cosmos-architect` + human
