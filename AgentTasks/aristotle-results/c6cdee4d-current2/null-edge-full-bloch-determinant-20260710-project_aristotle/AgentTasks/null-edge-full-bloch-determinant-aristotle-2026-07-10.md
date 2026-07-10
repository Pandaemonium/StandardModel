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
  project_id: pending
  target_file: NullEdgeFullBloch/DeterminantCriterion.lean
  expected_module: NullEdgeFullBloch.DeterminantCriterion
  submission_project: AgentTasks/aristotle-submit/null-edge-full-bloch-determinant-20260710-project
  output_dir: pending
  status: prepared
```
