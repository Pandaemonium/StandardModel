# Aristotle task: finite action to transfer and pole

Date: 2026-07-21
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: integrated

## Objective

For a finite positive Hermitian Hamiltonian, derive the positive contraction
transfer operator `exp(-a H)`, its visible eigenmode decay, the orbit-Gram
reflected kernel, and the positive resolvent pole. Supply a nondegenerate
two-level control.

## Claim boundary

This is finite quadratic dynamics. It is not an interacting lattice action,
infinite-volume reconstruction, continuum atom persistence, or LSZ.

Semantic context:
`AgentTasks/context-packs/mass-action-transfer-pole-20260721-20260721-002827.md`.

```yaml
aristotle:
  project_id: 7b77c837-737e-4469-869c-760cf7e36ed2
  task_id: 963a61bc-568d-4015-879b-9ec43eaa78ca
  target_file: PhysicsSM/Draft/NullEdge/FiniteHamiltonianTransferPole.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteHamiltonianTransferPole
  submission_project: AgentTasks/aristotle-standalone/mass-action-transfer-pole-20260721
  output_dir: AgentTasks/aristotle-output/7b77c837-737e-4469-869c-760cf7e36ed2
  status: integrated
```

## 2026-07-21 checkpoint

At roughly 02:49 PDT, `aristotle continue --mode ask` reported that the
eigenmode exponential, Hamiltonian-to-transfer mode, transfer Hermiticity,
strict positivity, finite reflected-kernel Gram positivity, exact iterated
decay, energy reconstruction, scalar resolvent pole/residue, visible-mode
chain, and nondegenerate two-level fixture are proved. No semantic weakening
was reported.

The sole uncertified theorem is transport of the already proved contraction
bound through `Matrix.toEuclideanCLM`; the working source still contains one
`exact?` at line 174 and one algebraic normalization failure. Aristotle
recommended continuing rather than splitting. An in-progress snapshot is at
`AgentTasks/aristotle-output/7b77c837-737e-4469-869c-760cf7e36ed2/in-progress-snapshot.zip`.

The scalar pole theorem is algebraic; it is not a use of Mathlib's analytic
residue API. This boundary must be retained during integration.

## 2026-07-21 integration

The completed artifact was reviewed and landed as
`PhysicsSM/Draft/NullEdge/FiniteHamiltonianTransferPole.lean`.  During
integration, the misleading name `reflectedKernel` was changed to
`orbitKernel`: the proved statement is ordinary Gram positivity of transfer
orbit vectors, not Osterwalder-Schrader reflection positivity.  Likewise,
`residue` was renamed to transfer-denominator `weight`, because the analytic
residue in the local coordinate `z - q^-1` differs by sign and scale.

The flagship chain is pinned in `OriginMassAxiomGuard.lean`.
