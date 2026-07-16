# Aristotle task: transverse-selector plus anomalous-Floquet composition

```yaml
aristotle:
  project_id: d82ea36b-490a-4e78-bc17-29e1aa3c96e9
  task_id: 9c89efe3-5325-494d-9169-72fb8d214718
  target_file: FloquetTransverseComposite/Core.lean
  expected_module: FloquetTransverseComposite.Core
  submission_project: AgentTasks/aristotle-submit/afpl-floquet-transverse-composite-20260713-project
  output_dir: AgentTasks/aristotle-output/d82ea36b-490a-4e78-bc17-29e1aa3c96e9
  status: integrated; project reused by explicit-pi successor
```

## Objective

Formalize the exact finite composition that the lateral 3+1 strategy now needs.
A rank-one transverse projector selects one two-component sector.  A unitary
`U` acts on that sector and an independently chosen unitary `V` acts on the
orthogonal complement.  Prove the combined update is unitary and restricts
exactly to `U` on the selected sector.

This is intended to accept the exact HNU anomalous-Floquet endpoint as `U` in a
successor module, while `V` records the compensating pi-gap, bulk, or mirror
dynamics.  Do not claim that compensation has been constructed merely because
`V` is a parameter.

## Required ladder

1. Prove `selector` is Hermitian, idempotent, sends `w` to `w`, and its
   complement kills `w`.
2. Prove `controlled_isUnitary` for arbitrary unitary `U` and `V`.
3. Prove the exact nonvacuous restriction to `U` on vectors `w tensor e`.
4. Keep the stationary-complement specialization, but identify it explicitly
   as a control that fails the stronger all-moving primitive-null ontology.
5. If useful, add the dual complement restriction and block-orthogonality
   lemmas needed to instantiate `V` with a pi-gap compensator.
6. Add build-enforced standard-axiom guards for the projector, unitarity, and
   restriction theorems.

## Honesty boundary

The result is a finite controlled-unitary composition.  It does not establish
real-space locality, a Weyl winding, a bulk-edge theorem, anomaly inflow,
primitive-null support, or a physical domain wall.  State those boundaries in
the module documentation.  Do not weaken `controlled_isUnitary` to a
componentwise or selected-sector statement.

No proof placeholders, compiled evaluation, new assumptions, or vacuous zero
vectors in the returned file.

Run first:

```text
lake env lean FloquetTransverseComposite/Core.lean
```

## 2026-07-13 harvest

Task `9c89efe3-5325-494d-9169-72fb8d214718` completed. The immutable return is
stored under
`AgentTasks/aristotle-output/d82ea36b-490a-4e78-bc17-29e1aa3c96e9/completed-20260713/`.
It proves the full controlled unitary, exact nonzero selected-sector
restriction to `U`, the dual complement restriction to `V`, projector
orthogonality, and standard-three guards. Independent replay against the
repository's pinned Mathlib passed.

The result is the correct algebraic interface for the next route but not the
compensator itself: `V` remains a free unitary, with no locality, pi-gap,
winding, or anomaly-ledger theorem. Any stronger promotion still requires a
successor that instantiates `V` with explicit local dynamics.

Interactive Claude/Opus approved integration strictly as an algebraic precursor
in
`AutonomousLab/reviews/CLAUDE_REVIEW_NullDilation_NoGo_ControlledSector_2026-07-13.md`.
The module is integrated at
`PhysicsSM/Draft/NullEdge/FloquetTransverseComposite.lean`, imported by
`PhysicsSMDraft.lean`, and pinned in the central overnight guard. Targeted build
and the central 8,487-job guard build pass. The Aristotle project is now reused
by task `29039417-befe-4736-be47-00af35e42c28`, which instantiates the exact HNU
selected update and an explicit pi complement and attacks the full nonzero-
eigenvector census.
