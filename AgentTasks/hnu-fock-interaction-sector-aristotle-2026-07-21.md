# Aristotle task: interacting finite Fock locality and sector audit

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: integrated from the completed Aristotle return

## Objective

Construct a nontrivial even local pair interaction, prove its genuine CAR
support properties, and test both preservation and violation of explicit
selected sectors.

## Claim boundary

This is a finite interaction control. Fermion parity is not a positive-energy
sector, and no continuum interacting QFT conclusion is authorized.

Semantic context:
`AgentTasks/context-packs/hnu-fock-interaction-sector-20260721-024058.md`.

```yaml
aristotle:
  project_id: b24cac42-5b01-4b43-b2e4-9c3317a7d019
  task_id: 671f01b0-a746-43c3-9db6-d25a5f36e3ad
  target_file: PhysicsSM/Draft/NullEdge/FiniteFermionicInteraction.lean
  expected_module: Mathlib-only finite interacting Fock locality module
  submission_project: AgentTasks/aristotle-standalone/hnu-fock-interaction-sector-20260721
  output_dir: AgentTasks/aristotle-output/b24cac42-5b01-4b43-b2e4-9c3317a7d019
  status: integrated
```

## Landed result

The completed return was integrated as
`PhysicsSM/Draft/NullEdge/FiniteFermionicInteraction.lean`, with the
build-enforced footprint pin in
`PhysicsSM/Draft/NullEdge/FiniteFermionicInteractionAxiomGuard.lean`.

For a five-mode occupation register, four declared cell modes support an exact
even quartic pair-transfer Hamiltonian and a nonidentity closed pair update.
At unit complex phase the update has an explicit adjoint inverse, preserves
number and parity, fixes vacuum and every one-particle state, and preserves the
full two-particle sector. It belongs to the simultaneous commutant of the
outside creation and annihilation operators; conjugation fixes both outside
CAR generators and maps the cell CAR algebra to itself. The explicit
one-dimensional `01` pair sector is not invariant, so the sector-preservation
test is nonvacuous.

## Claim boundary

The returned update has the same pair-transfer structure as the displayed
Hermitian quartic Hamiltonian, but this module does not prove that the update is
its time exponential. It also does not prove positive energy, compose the
interaction with the live HNU free schedule, select the lower HNU bands, prove
an interacting light cone or continuum limit, or construct scattering/QFT.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/FiniteFermionicInteraction.lean`
- `lake build PhysicsSM.Draft.NullEdge.FiniteFermionicInteractionAxiomGuard`
  (passed, 8027 jobs)
