# Furey/Baez source ingest - 2026-06-27

Purpose: record the literature additions prompted by the Furey/Baez follow-up
analysis in attachment `81a90b3d-0fff-4d16-9783-12ccb41c01e3/pasted-text.txt`.

## Dry-run result

Already present in Neo4j:

- `2210.10126` -> `CZJ5T2J3`, `Division algebraic symmetry breaking`.
- `2206.06912` -> `EPT6PUTC`, `Octonion Internal Space Algebra for the Standard Model`.
- `2505.07923` -> `PTX3AUIS`, `A Superalgebra Within`.

Rejected from this ingest:

- `1810.10465`, because the ingestion dry run resolved it to an unrelated
deep-learning paper, not a Furey/division-algebra Standard Model source.

## Added papers

Command:

```powershell
$PY='C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe'
& $PY Scripts/lit/lit_ingest.py 2606.15235 2209.13016 1806.00612 0904.1556 math/0105155 --tag null-edge --tag gate-h --tag furey-baez --tag internal-spectrum --tag standard-model-gauge-group
```

Result:

| arXiv ID | Zotero key | Title |
| --- | --- | --- |
| `2606.15235` | `DJRMU4CB` | The Standard Model Gauge Group from the Exceptional Jordan Algebra |
| `2209.13016` | `6VI58VGH` | One generation of standard model Weyl representations as a single copy of `R tensor C tensor H tensor O` |
| `1806.00612` | `Z232K7IU` | `SU(3)_C x SU(2)_L x U(1)_Y (x U(1)_X)` as a symmetry of division algebraic ladder operators |
| `0904.1556` | `MZZEZUWA` | The Algebra of Grand Unified Theories |
| `math/0105155` | `WRIM6ZI7` | The Octonions |

The ingest completed Zotero creation, Neo4j paper upsert, and embeddings for all
five added papers.

## Project interpretation

These sources support Gate H and Gate F:

- internal Standard Model spectrum and gauge group docking;
- electromagnetic stabilizer comparison;
- legal `Phi_H`/Yukawa-map classification;
- possible intertwiner codimension audit.

They do not solve Gate C, Gate D, ghost safety, Krein positivity, QCD
confinement, or numerical mass prediction.
