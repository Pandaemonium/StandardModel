# Aristotle proof task: ordered 3+1 full-Bloch determinant formulas only

## Objective

Prove the two unchanged determinant identities in
`NullEdgeBlochDet/Determinants.lean`.  Do not work on determinant-to-kernel
linear algebra; that bridge is already landed in the live repository.  Do not
run a broad build.  Start with:

`lake env lean NullEdgeBlochDet/Determinants.lean`

The candidate formulas have two independent oracle checks:

- 100 seeded NumPy evaluations, maximum error `7.112e-15`;
- exact SymPy/Groebner reduction modulo the four sine/cosine unit-circle
  relations in `Scripts/oracle/derive_split4_floquet_polynomial.py`.

These checks are not proofs.  Expand the finite matrix determinant and close
the real trigonometric polynomial identities.  Small helper lemmas and local
abbreviations are allowed.  Do not alter either theorem statement silently.
If a formula is false, return the exact corrected polynomial and a symbolic
counterexample.  The body-center theorem is already complete and must remain.

## Acceptance

- Both determinant theorem statements unchanged.
- No proof handoff markers remain.
- No numerical replacement or compiler-trust shortcut.
- Return the target file even if final package verification is slow.

```yaml
aristotle:
  project_id: 569e66ec-6de1-421a-8b8b-7a7ce548e53c
  task_id: 024d4456-0475-4817-8b29-b4f0d2353694
  target_file: NullEdgeBlochDet/Determinants.lean
  expected_module: NullEdgeBlochDet.Determinants
  submission_project: AgentTasks/aristotle-submit/null-edge-full-bloch-determinants-only-20260710-project
  output_dir: AgentTasks/aristotle-output/569e66ec-6de1-421a-8b8b-7a7ce548e53c
  status: canceled-after-two-hour-stall
```

## Live checkpoint

At 2026-07-10 16:07 PDT, after about 57 minutes, both project and task still
reported `RUNNING` / `IN_PROGRESS`. A `continue --mode ask --wait` request for
solved targets and exact remaining goals timed out after two minutes without a
response. The task was left running because it remains below the two-hour
stall limit and is already isolated to the two determinant expansions.

Operational correction: this task was canceled before the formal two-hour
threshold because the inherited run chronology was ahead of the actual Windows
clock.  It had stopped returning progress events, but the cancellation was an
early split decision rather than a valid application of the two-hour rule.  A
snapshot was saved at
`AgentTasks/aristotle-output/569e66ec-6de1-421a-8b8b-7a7ce548e53c/stall-snapshot.zip`
before cancellation.  The snapshot contains proved determinant/factor/
entrywise-expansion helpers but had removed and not yet reintroduced either
target theorem.  It was split into one-theorem successor jobs `Plus.lean` and
`Minus.lean`; the original task was canceled without claiming either formula.
