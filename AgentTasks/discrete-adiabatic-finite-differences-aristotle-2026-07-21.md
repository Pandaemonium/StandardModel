# Aristotle task: discrete adiabatic finite differences

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: integrated

## Objective

Prove that bounded first and second derivatives of a normed-space-valued walk
path imply the exact `O(1/T)` and `O(1/T^2)` finite-difference hypotheses used
by quantitative discrete adiabatic theorems.

## Scientific role

This is the first reusable analytic brick in the literature-guided moving-band
route. The live HNU application will still owe concrete derivative bounds and
neighboring-step quasienergy separation.

Source and theorem design:
`AutonomousLab/work/NE-3PLUS1/CODEX_LITERATURE_DISCRETE_ADIABATIC_BAND_2026-07-21.md`.

```yaml
aristotle:
  project_id: 2624a3d5-4d7f-472c-9e36-82bc3896f5f8
  task_id: 9de07986-91e3-4c34-8ea3-e8b11ba901dd
  target_file: PhysicsSM/Draft/NullEdge/DiscreteAdiabaticFiniteDifferences.lean
  expected_module: PhysicsSM.Draft.NullEdge.DiscreteAdiabaticFiniteDifferences
  submission_project: AgentTasks/aristotle-submit/discrete-adiabatic-finite-differences-20260721-project
  output_dir: AgentTasks/aristotle-output/2624a3d5-4d7f-472c-9e36-82bc3896f5f8
  status: integrated
```

## Close-out

- Aristotle returned all four requested proofs without executable placeholders.
- Windows path-length handling in the generic integration helper failed during
  nested archive extraction; the short-path review copy was inspected instead.
- The returned theorem signatures were preserved. The source was placed in the
  project namespace and given a build-enforced axiom guard.
- Semantic boundary: these results derive finite-difference bounds from smooth
  schedules only. They do not supply an HNU spectral projector, quasienergy
  gap, or adiabatic transport theorem.
- Verified locally:
  - `lake env lean PhysicsSM/Draft/NullEdge/DiscreteAdiabaticFiniteDifferences.lean`
  - `lake build PhysicsSM.Draft.NullEdge.DiscreteAdiabaticFiniteDifferences`
  - `lake env lean PhysicsSM/Draft/NullEdge/DiscreteAdiabaticFiniteDifferencesAxiomGuard.lean`
  - `lake build PhysicsSM.Draft.NullEdge.DiscreteAdiabaticFiniteDifferencesAxiomGuard`

The flagship guard pins only `propext`, `Classical.choice`, and `Quot.sound`.
