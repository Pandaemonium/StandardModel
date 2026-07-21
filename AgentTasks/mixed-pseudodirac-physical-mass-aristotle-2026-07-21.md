# Aristotle task: physical mixed pseudo-Dirac masses

Date: 2026-07-21
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: integrated and guarded

## Objective

Replace ordinary complex-eigenvalue language in the mixed pseudo-Dirac branch
with the correct singular/Takagi squared-mass object, including a nilpotent
complex-symmetric counterexample that separates the two notions.

## Claim boundary

This is a finite two-state operator theorem. It does not derive neutrino
couplings, scales, mixing data, a propagator pole, or an arbitrary-generation
Takagi theorem unless the returned source explicitly proves the latter.

Source anchor: Borisov and Isaev, arXiv:2312.17714, Appendix C; Zotero key
`I9NUBC9A`. Semantic context:
`AgentTasks/context-packs/mixed-pseudodirac-physical-mass-20260721-20260721-030149.md`.

```yaml
aristotle:
  project_id: b54d5226-12a2-42cd-b85d-bb0697880d99
  task_id: bf8919e3-8eba-426a-a79f-59d2d8c7d53c
  target_file: PhysicsSM/Draft/NullEdge/MixedPseudoDiracPhysicalMass.lean
  expected_module: PhysicsSM.Draft.NullEdge.MixedPseudoDiracPhysicalMass
  submission_project: AgentTasks/aristotle-standalone/mixed-pseudodirac-physical-mass-20260721
  output_dir: AgentTasks/aristotle-output/b54d5226-12a2-42cd-b85d-bb0697880d99
  status: integrated
```

## Integration result

The returned `RequestProject/Main.lean` was adapted to reuse the existing
`MixedPseudoDirac.massMatrix` declaration and landed as
`PhysicsSM/Draft/NullEdge/MixedPseudoDiracPhysicalMass.lean`.

It proves:

- Hermiticity and positive-semidefiniteness of `M^H M`;
- exact trace, determinant, discriminant, and both squared singular masses;
- exhaustiveness of the two real eigenvalues of `M^H M`;
- the pure-Dirac degeneracy and the real-symmetric absolute-value rule;
- a nonzero symmetric nilpotent control with only zero ordinary eigenvalues but
  nonzero `M^H M` and trace four.

It does not prove arbitrary-dimensional Autonne-Takagi factorization, choose
neutrino parameters, or reconstruct a physical pole.

Verification:

- `lake env lean PhysicsSM/Draft/NullEdge/MixedPseudoDiracPhysicalMass.lean`
- `lake build PhysicsSM.Draft.NullEdge.OriginMassAxiomGuard`

Both passed under the pinned toolchain. The axiom guard pins the standard
`propext`, `Classical.choice`, and `Quot.sound` footprint.
