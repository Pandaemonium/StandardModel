# Aristotle task: Plucker/Bargmann phase core

Date: 2026-06-21

## Objective

Prove the finite complex phase companion to the Plucker mass theorem.

Target file:

```text
NullEdgePluckerBargmannPhaseCore/Finite.lean
```

Expected module:

```text
NullEdgePluckerBargmannPhaseCore.Finite
```

## Theorem targets

```lean
plucker_lagrange_identity
trace_rankOneKetBra
rankOneKetBra_mul
rankOneProjector_mul
bargmannTripleTrace_rankOne
normalized_plucker_eq_one_sub_overlap
```

## Why this matters

The trusted Plucker mass theorem keeps the squared modulus of the wedge.  The
Dirac/operator critique says that squared invariants lose first-order data.
This target formalizes the nearby complex phase algebra: the Lagrange identity
relates Plucker spread to Hermitian overlap, while the Bargmann triple trace is
the finite Pancharatnam/Berry phase carrier for three spinor directions.

## Constraints

- Keep this package standalone: no `PhysicsSM` imports.
- Do not weaken theorem statements silently.
- Final target file should contain no proof holes or escape-hatch declarations.
- Preserve the Hermitian-inner-product orientation in the theorem statements.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-plucker-bargmann-phase-core-20260621/NullEdgePluckerBargmannPhaseCore/Finite.lean
```

Result before submission: passed with exactly six intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: c2d1da9c-4616-4120-99bc-55ca1b8d1c1e
  task_id: 5fcbcb70-8264-47f6-937d-f1cdf5d92c9d
  target_file: NullEdgePluckerBargmannPhaseCore/Finite.lean
  expected_module: NullEdgePluckerBargmannPhaseCore.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-plucker-bargmann-phase-core-20260621-project
  output_dir: AgentTasks/aristotle-output/c2d1da9c-4616-4120-99bc-55ca1b8d1c1e
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`c2d1da9c-4616-4120-99bc-55ca1b8d1c1e`; `aristotle tasks` reported task
`5fcbcb70-8264-47f6-937d-f1cdf5d92c9d` as `QUEUED`.

## Integration

Integrated 2026-06-21 as:

```text
PhysicsSM/Draft/NullEdgePluckerBargmannPhaseCore.lean
```

The module proves the two-spinor Lagrange identity, ket-bra trace and product
laws, rank-one projector multiplication, the Bargmann/Pancharatnam triple
trace, and the normalized Plucker/overlap complement identity.

Verification:

```text
lake env lean PhysicsSM\Draft\NullEdgePluckerBargmannPhaseCore.lean
lake build PhysicsSM.Draft.NullEdgePluckerBargmannPhaseCore
lake env lean PhysicsSMDraft.lean
python Scripts\check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM\Draft\NullEdgePluckerBargmannPhaseCore.lean
git diff --check -- PhysicsSM\Draft\NullEdgePluckerBargmannPhaseCore.lean PhysicsSMDraft.lean
```
