# Aristotle task: moving-sector leakage

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: integrated with necessary statement repair

## Objective

Prove that a contractive time-ordered evolution through a moving family of
normalized projectors accumulates at most the sum of its one-step band
transport defects.

## Literature motivation

Sun et al., arXiv:1806.09296, isolate a chiral low-energy Floquet block in an
adiabatic limit while retaining the compensating high-energy block. Hastings
and Wen (2005) and Nachtergaele, Sims, and Young, arXiv:1810.02428, motivate a
gapped quasi-local spectral-flow interpretation. The full pass is recorded in
`AutonomousLab/work/NE-3PLUS1/CODEX_LITERATURE_QUASILOCAL_PHYSICAL_SECTOR_2026-07-21.md`.

Mathlib semantic search found `Finset.norm_prod_le` and
`norm_prod_le_of_le` as nearby finite-product norm APIs. The recursive target
keeps the time ordering explicit.

## Claim boundary

This theorem consumes a moving projector and one-step defect estimates. It does
not derive spectral projectors, a gap, quasi-locality, an HNU interaction
bound, or continuum QFT.

Semantic context:
`AgentTasks/context-packs/moving-sector-leakage-20260721-20260721-054716.md`.

```yaml
aristotle:
  project_id: 4f8edbcc-b25b-48df-ba57-9613c016e8bb
  task_id: e66d42b7-1d2d-4017-a283-526a9966774a
  target_file: MovingSectorLeakage.lean
  expected_module: Mathlib-only moving-projector norm theorem
  submission_project: AgentTasks/aristotle-submit/moving-sector-leakage-20260721-project
  output_dir: AgentTasks/aristotle-output/4f8edbcc-b25b-48df-ba57-9613c016e8bb
  status: integrated
```

## Result and semantic review

Aristotle completed all six targets. Local review confirmed two necessary
repairs rather than accepting the original statements by force:

- `norm_walkProduct_le_one` needs `norm (1 : A) <= 1` in a generic
  `NormedRing`; and
- every bound whose base case is selected-to-complement leakage needs
  idempotence `P k * P k = P k`.

The second repair is mathematically substantive. Without idempotence, over the
reals the assignment `P k = 1 / 2`, `U k = 0` satisfies the displayed norm and
exact-step conditions but has initial leakage `1 / 4`. The integrated theorem
therefore speaks about actual projectors and does not retain the false broader
statement.

Integrated files:

- `PhysicsSM/Draft/NullEdge/MovingSectorLeakage.lean`
- `PhysicsSM/Draft/NullEdge/MovingSectorLeakageAxiomGuard.lean`
- root import in `PhysicsSM.lean`

Local verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/MovingSectorLeakage.lean
lake build PhysicsSM.Draft.NullEdge.MovingSectorLeakage
lake env lean PhysicsSM/Draft/NullEdge/MovingSectorLeakageAxiomGuard.lean
```

All passed. The guard pins the three capstone theorems to the standard axiom
footprint `[propext, Classical.choice, Quot.sound]`.
