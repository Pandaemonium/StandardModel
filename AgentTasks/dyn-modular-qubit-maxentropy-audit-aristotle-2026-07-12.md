# Aristotle audit: full-Bloch qubit maximum entropy target

## Role

Adversarial formal auditor, not builder. Inspect the ten theorem statements in
`QubitFixedEnergyMaxEntropy.lean` and try to falsify or expose hidden
assumptions before the proof return is integrated.

## Required checks

1. Is `pairBloch_surjective` true for every complex Hermitian trace-one `2 x 2`
   matrix under the exact basis and sign conventions?
2. Does Mathlib's `Matrix.PosSemidef` with `ComplexOrder` make
   `pairBloch_posSemidef_iff` the intended physical PSD statement, or is there a
   convention mismatch?
3. Does the ball inequality exactly characterize PSD, including the sphere and
   negative longitudinal energies?
4. Is `pairEntropy_eq_fixedEnergy_iff` valid at every boundary (`|e| = 1`,
   zero radius, pure transverse states), or can binary-entropy symmetry create
   an extra equality case?
5. Is `transverse_strict_control` oriented correctly?
6. Do the matrix expectation and entropy definitions carry the intended signs
   for the live `Bz 1 = sigmaX` bridge?

## Output contract

Return one of:

- a concrete counterexample with the failed theorem named;
- a precise missing hypothesis or convention mismatch;
- or an audit pass with a theorem-by-theorem proof architecture and the most
  fragile Mathlib API points.

Do not weaken or silently rewrite the statements. You may close easy holes
incidentally, but proof completion is handled by the separate builder project
`4ef06d09`.

## Source

`AgentTasks/aristotle-standalone/qubit-fixed-energy-maxentropy-20260712/QubitFixedEnergyMaxEntropy.lean`

```yaml
aristotle:
  project_id: 8fd19c81-d95a-45d4-8ad6-8a46c5fbbcbb
  task_id: 99d6f9f2-b26d-4839-a1a7-e37d9072bf46
  target_file: QubitFixedEnergyMaxEntropy.lean
  expected_module: QubitFixedEnergyMaxEntropy
  submission_project: AgentTasks/aristotle-submit/qubit-fixed-energy-maxentropy-audit-20260712-project
  output_dir: AgentTasks/aristotle-output/8fd19c81-d95a-45d4-8ad6-8a46c5fbbcbb
  status: submitted
```
