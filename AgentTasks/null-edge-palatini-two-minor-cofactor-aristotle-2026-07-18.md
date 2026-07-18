# Aristotle job: four-dimensional Palatini two-minor cofactor identity

Date: 2026-07-18
Work item: `GR-PALATINI-COFRAME-005`

```yaml
aristotle:
  project_id: 3e802ea4-9a1a-4f14-ba74-f1d6a3d93b51
  task_id: dd3cf51d-73bf-46ec-8e6b-d987295cc1f0
  target_file: PalatiniTwoMinor/Target.lean
  expected_module: PalatiniTwoMinor.Target
  submission_project: AgentTasks/aristotle-submit/null-edge-palatini-two-minor-cofactor-20260718-project
  output_dir: AgentTasks/aristotle-output/3e802ea4-9a1a-4f14-ba74-f1d6a3d93b51
  status: complete_reviewed
```

## Target

Prove the fixed four-dimensional complementary two-minor identity isolated by
the in-progress density job. This package removes every unrelated Palatini,
Krein, curvature, and variation definition so Aristotle can spend its budget
only on the determinant lemma.

## Convention lock

- coframe and inverse indices use order `(0,1,2,3)`;
- spacetime orientation is `0123`;
- the left side carries the explicit factor `1/2`;
- the right side carries the oriented determinant with positive sign;
- both supplied inverse equations remain hypotheses.

## Related jobs

- density project `269e0a3d-92bd-43ed-a035-114f52732c82`;
- first-response project `40d89d02-7dc7-4a7d-97e5-aa053adc4112`.

The density task has already proved its headline theorem conditional on this
helper. A status question sent after more than one hour timed out without a
response, so this minimal split is being submitted in parallel rather than
canceling either existing task.

## Submission

The focused target passed under the pinned toolchain with exactly one intended
proof-hole warning. The focused-package scanner reported one proof-hole line
and no assumption or unsafe escape hatches. Submitted as project
`3e802ea4-9a1a-4f14-ba74-f1d6a3d93b51`, task
`dd3cf51d-73bf-46ec-8e6b-d987295cc1f0`; initial status `QUEUED`.

After the task entered `IN_PROGRESS`, an instruction supplied a determinant-
multiplication construction: retain inverse rows `a,b`, replace the
complementary rows by oriented standard basis rows `i,j`, and compare
`det(A * coframe)` with `det(A) det(coframe)`. Equal-index cases vanish by
antisymmetry; explicit `Fin 4` cases are permitted. The theorem statement and
conventions were left unchanged.

The task completed on 2026-07-18 with no proof holes or forbidden escape
hatches. Its returned proof uses the requested auxiliary-matrix determinant
construction and kernel-checks directly in 20.4 seconds. Review also showed
that the right-inverse hypothesis is redundant. The live Einstein bridge now
contains the stronger left-inverse-only cofactor theorem, proved by an
equivalent row-selector/matrix-cancellation argument, together with the exact
determinant-weighted density and nonlinear-action identities.
