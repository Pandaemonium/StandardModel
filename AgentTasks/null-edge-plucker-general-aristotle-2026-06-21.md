# Aristotle task: general finite Pluecker mass

Date: 2026-06-21

## Goal

Prove the general finite Pluecker mass theorem for the null-edge causal graph
program.

Target file:

```text
PhysicsSM/Draft/NullEdgePluckerGeneralAristotle.lean
```

This builds on the completed core:

```text
PhysicsSM/Draft/NullEdgeCoreAristotle.lean
```

## Why this target

The core Aristotle jobs proved:

- a single rank-one Hermitian spinor momentum has determinant zero;
- the two-edge Pluecker mass identity;
- the three-edge Pluecker mass identity;
- zero two-edge mass iff zero spinor wedge;
- finite Abelian diamond gauge invariance;
- formal chain boundary squared zero.

The highest-value next theorem is the full finite bundle identity:

```text
det(sum_i psi_i psi_i^dagger)
  =
sum_{i<j} |psi_i wedge psi_j|^2.
```

This is the precise finite theorem behind the program's central claim:
mass is the total pairwise Pluecker spread of a bundle of null edges.

## Target declarations

```lean
finBundleMomentum
finPairIndexSet
finPairwisePluckerMass
fin_bundle_plucker_mass_identity
PairwiseWedgeZero
wedges_against_base_zero_iff_all_smul
all_smul_implies_pairwise_wedge_zero
pairwise_wedge_zero_iff_common_direction
finPairwisePluckerMass_eq_zero_iff_pair_terms_zero
fin_bundle_mass_zero_iff_common_direction
```

## Constraints

- Keep the module in `PhysicsSM.Draft`.
- Do not introduce `axiom`, `opaque`, `unsafe`, `admit`,
  proof-command `sorry`, or `native_decide` in the final result.
- Helper lemmas are welcome in the same file.
- Do not weaken theorem statements silently.  If a theorem is false or needs a
  sharper hypothesis, explain the issue and prove the corrected form.
- This job must be SPL-free.  The target imports only Mathlib and the
  null-edge core file.

## Literature/proof route

Use Cauchy-Binet for the main identity.  If `A` is the `2 x n` matrix whose
columns are the spinors, then:

```text
det(A A^dagger)
  =
sum over two-column minors det(A_ij) det(A_ij)^dagger.
```

The two-column minors are exactly the spinor wedges.

Useful source note:

```text
Sources/Null_Edge_Causal_Graph_Theorem_Roadmap_2026-06-21.md
```

## Verification

Run:

```text
lake env lean PhysicsSM/Draft/NullEdgePluckerGeneralAristotle.lean
lake build PhysicsSM.Draft.NullEdgePluckerGeneralAristotle
```

Then scan the target file for proof-command placeholders and forbidden
constructs.

## Submission

```yaml
aristotle:
  project_id: 9df58363-44c2-46b5-8349-cfdbbd2fc113
  task_id: 16146014-3b07-41dd-b56b-ec17a4fc0a08
  target_file: PhysicsSM/Draft/NullEdgePluckerGeneralAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgePluckerGeneralAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-plucker-general-splfree-20260621-project
  output_dir: AgentTasks/aristotle-output/9df58363-44c2-46b5-8349-cfdbbd2fc113
  status: integrated
```

## Result and integration

Aristotle completed the SPL-free project and filled all six proof-command
`sorry`s in `PhysicsSM/Draft/NullEdgePluckerGeneralAristotle.lean`.

Integrated result:

- `fin_bundle_plucker_mass_identity`
- `wedges_against_base_zero_iff_all_smul`
- `all_smul_implies_pairwise_wedge_zero`
- `pairwise_wedge_zero_iff_common_direction`
- `finPairwisePluckerMass_eq_zero_iff_pair_terms_zero`
- `fin_bundle_mass_zero_iff_common_direction`

Helper lemmas added by Aristotle:

- `sum_pairs_offdiag`
- `pair_terms_zero_iff_pairwise`

Verification during integration:

```text
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-plucker-general-aristotle-2026-06-21.md 9df58363-44c2-46b5-8349-cfdbbd2fc113
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-plucker-general-aristotle-2026-06-21.md --apply --build 9df58363-44c2-46b5-8349-cfdbbd2fc113
```
