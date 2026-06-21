# Aristotle task: null-edge spinor geometry and covariance

Date: 2026-06-21

## Goal

Prove the spinor-geometric strengthening theorems for the null-edge Pluecker
mass program.

Target file:

```text
PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean
```

This builds on:

```text
PhysicsSM/Draft/NullEdgeCoreAristotle.lean
PhysicsSM/Draft/NullEdgePluckerGeneralAristotle.lean
```

## Why this target

The finite Pluecker identity says determinant mass is the sum of squared
pairwise spinor wedges.  The next physics-facing layer is to prove that this
quantity is the projective spinor angular spread and is invariant under the
proper spinor frame changes.

The key upgrades are:

- the two-spinor Lagrange identity;
- covariance of the spinor wedge under `GL(2,C)`;
- invariance of the finite Pluecker mass under determinant-one spinor changes;
- chart-level matching with the two-twistor/massive spinor-helicity mass.

## Target declarations

```lean
spinorInner
spinorNormSq
spinor_inner_wedge_lagrange_identity
spinorAction
spinorWedge_spinorAction
finPairwisePluckerMass_sl2_invariant
SpinorChartTwoTwistor
twoTwistorChartMomentum
two_twistor_chart_mass_eq_plucker
```

The last theorem is already proved in the draft file; the first three theorem
targets are intentional `sorry` handoff markers.

## Proof guidance

For `spinor_inner_wedge_lagrange_identity`, expand

```text
psi = (a,b), phi = (c,d)
```

and prove:

```text
|conj(a)c + conj(b)d|^2 + |ad - bc|^2
  =
(|a|^2 + |b|^2)(|c|^2 + |d|^2).
```

For `spinorWedge_spinorAction`, expand

```text
A = [[alpha,beta],[gamma,delta]]
```

and prove:

```text
(A psi) wedge (A phi) = det(A) * (psi wedge phi).
```

For `finPairwisePluckerMass_sl2_invariant`, combine the wedge covariance with
`A.det = 1` and the definition of `finPairwisePluckerMass`.

## Constraints

- Keep the module in `PhysicsSM.Draft`.
- Do not introduce `axiom`, `opaque`, `unsafe`, `admit`,
  proof-command `sorry`, or `native_decide` in the final result.
- Helper lemmas are welcome in the same file.
- If the `finPairwisePluckerMass_sl2_invariant` theorem needs an intermediate
  lemma about `complexAbsSq (c * z)`, prove it cleanly rather than weakening
  the theorem.
- This job must be SPL-free.  The target imports only Mathlib-derived
  null-edge files.

## Literature/proof route

Source note:

```text
Sources/Null_Edge_Causal_Graph_Proof_Advances_2026-06-21.md
```

Theorems are finite-dimensional spinor algebra.  No continuum twistor
incidence theorem is being claimed here.

## Verification

Run:

```text
lake env lean PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean
lake build PhysicsSM.Draft.NullEdgeSpinorGeometryTargets
```

Then scan the target file for proof-command placeholders and forbidden
constructs.

## Submission

```yaml
aristotle:
  project_id: 6fe6a877-4ad1-4b70-91f0-ace14eb90a13
  task_id: d9eae352-7516-4c0f-beee-2887e4664f1e
  target_file: PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean
  expected_module: PhysicsSM.Draft.NullEdgeSpinorGeometryTargets
  submission_project: AgentTasks/aristotle-submit/null-edge-spinor-geometry-splfree-20260621-project
  output_dir: AgentTasks/aristotle-output/6fe6a877-4ad1-4b70-91f0-ace14eb90a13
  status: integrated
  last_checked: COMPLETE
```

## Result and integration

Aristotle completed the SPL-free project and filled all three proof-command
`sorry`s in `PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean`.

Integrated result:

- `spinor_inner_wedge_lagrange_identity`
- `spinorWedge_spinorAction`
- `finPairwisePluckerMass_sl2_invariant`

Helper lemmas added by Aristotle:

- `complexAbsSq_mul`
- `complexAbsSq_one`

Additional local corollaries added after integration:

- `finBundleMomentum_det_sl2_invariant`
- `SpinorChartMultiTwistor`
- `multiTwistorChartMomentum`
- `multiTwistorChartPairwiseMass`
- `multi_twistor_chart_mass_eq_plucker`
- `spinorActionMultiTwistor`
- `multi_twistor_chart_mass_sl2_invariant`

Verification during integration:

```text
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-spinor-geometry-aristotle-2026-06-21.md 6fe6a877-4ad1-4b70-91f0-ace14eb90a13
lake env lean PhysicsSM/Draft/NullEdgeSpinorGeometryTargets.lean
```
