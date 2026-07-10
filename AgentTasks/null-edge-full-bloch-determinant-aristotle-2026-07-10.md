# Aristotle proof task: full Bloch determinant criterion

## Objective

Prove the five unchanged targets in
`NullEdgeFullBloch/DeterminantCriterion.lean`.  The primary result is an exact
all-momentum algebraic criterion for the ordered `3+1` split walk to have
Floquet eigenvalue `+1` or `-1`.

The candidate determinant polynomials were derived by an independent symbolic
expansion and reduced using the four trigonometric unit-circle identities.
They are oracle candidates, not trusted until Lean proves them.  First prove
the determinant formulas by finite matrix expansion.  Then use standard finite
matrix singularity/kernel results to prove the two nonzero-eigenmode
equivalences.  The body-center theorem is the mandatory nondegenerate control.

If a determinant formula is false, do not alter it silently.  Return the exact
counterexample or corrected formula and explain the discrepancy.  If the full
eigenmode equivalence blocks on Mathlib API, land both determinant identities
and the body-center specialization unchanged, then report the smallest missing
kernel lemma.

Oracle cross-check: a NumPy complex-matrix evaluation at 100 seeded random
momenta/mass angles found maximum absolute formula error `7.112e-15`.  This is
only floating-point triage and carries no theorem status.

Reproducible exact-CAS check:
`Scripts/oracle/derive_split4_floquet_polynomial.py` (SymPy 1.14.0) constructs
the project matrices and reduces both determinant differences to zero modulo
the four sine/cosine unit-circle relations.  This is stronger oracle evidence
but remains external to the Lean trusted base.

## Scientific use

- A success upgrades the paper from selected high-symmetry identities to an
  exact full-Bloch algebraic zero-set criterion.
- The already landed project theorem gives explicit nonzero body-center `+1`
  and `-1` modes for every mass angle.
- A successor regulator must make both criterion polynomials nonzero away from
  its intended physical cone while retaining exact unitarity, locality, and the
  Dirac tangent.

## Acceptance

- The two determinant statements remain unchanged or are explicitly refuted.
- Eigenmode results quantify a genuinely nonzero vector.
- No finite sampling, floating-point replacement, or hidden assumptions.
- Run `lake env lean NullEdgeFullBloch/DeterminantCriterion.lean` first.
- No proof placeholders remain in the returned file.

```yaml
aristotle:
  project_id: c6cdee4d-e883-4122-b57e-b6672ded7b71
  task_id: 8dfd9b6e-7019-4d75-af29-317e01f7388d
  target_file: NullEdgeFullBloch/DeterminantCriterion.lean
  expected_module: NullEdgeFullBloch.DeterminantCriterion
  submission_project: AgentTasks/aristotle-submit/null-edge-full-bloch-determinant-20260710-project
  output_dir: AgentTasks/aristotle-output/c6cdee4d-e883-4122-b57e-b6672ded7b71
  status: canceled-after-two-hour-stall
```

## 2026-07-10 13:20 PDT status query

Sent a non-redirecting `continue --mode ask --wait` request for the exact solved
targets and current determinant-expansion blocker.  The local shell timed out
after two minutes without a response; the project and original task both remain
running.  No statement change or new downloadable proof was inferred from the
timeout.  Keep the task running until the two-hour stall threshold, then split
the determinant identities from the kernel/eigenvector equivalences if the
downloadable file still has all five handoff markers.

## 2026-07-10 14:24 PDT stall disposition

The two-hour threshold was reached.  A final preservation snapshot was saved
under the canonical output directory and still contained all five original
handoff markers.  Task `8dfd9b6e-7019-4d75-af29-317e01f7388d` was canceled.
The body-center polynomial theorem was closed locally with a direct
trigonometric simplification.  The generic determinant-to-nonzero-eigenmode
equivalence was landed independently as `FloquetDeterminantCriterion`.  Only
the two symbolic determinant expansions were resubmitted in focused project
`569e66ec-6de1-421a-8b8b-7a7ce548e53c`.
