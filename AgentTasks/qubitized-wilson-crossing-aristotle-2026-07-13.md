# Aristotle task: qubitized Wilson 3+1 crossing classification

- Work item: `NE-3PLUS1-QW01`
- Role: Builder / Assassin
- Priority: strict 3+1 spatial-doubler escape
- Target: `QubitizedWilsonCrossing.lean`
- Source root:
  `AgentTasks/aristotle-standalone/qubitized-wilson-crossing-20260713/`

## Objective

Fill every proof hole without changing definitions or theorem statements.
Prove the exact two-by-two qubitization determinant identities and compose them
with the three-axis massless Wilson energy to classify all `+1` and `-1`
crossings.

The required honest verdict is:

- both crossing sets have exactly one spatial support, characterized by
  `cos qx = cos qy = cos qz = 1`;
- the zero signal carries both signs, so this closes spatial doubling but does
  not yet remove the colocated Floquet zero/pi pair.

## Semantic constraints

- Do not weaken either crossing equivalence to a one-way implication.
- Do not identify `cos q = 1` with a literal real equality `q=0`; it is the
  origin modulo the momentum torus.
- Do not hide the minus crossing or call the result a single-quasienergy cone.
- Do not add assumptions, trust-expanding declarations, or evaluator shortcuts.
- Preserve the normalization `9`, which comes from the proposed seven-label
  LCU weights `(1,1,1,1,1,1,3)`.

## Proof route

1. Expand the `Fin 2` matrices and use `hnorm` for exact unitarity and the two
   determinant formulas.
2. Prove the crossing iff statements from the fact that `2*i` is nonzero.
3. Bound each `sin^2` by one and the Wilson sum by six, giving the coarse but
   sufficient global bound `E^2 <= 39 < 81`.
4. Use nonnegativity term by term to prove the zero classification.
5. Apply `Real.sq_sqrt` and the bound to prove the signal/complement identity.
6. Compose the scalar crossing iff with `signal_eq_zero_iff`.

## Verification

```text
lake env lean QubitizedWilsonCrossing.lean
```

Return the completed file plus a concise report of any theorem statement that
is false or requires a missing hypothesis.

## Submission metadata

```yaml
aristotle:
  project_id: null
  task_id: null
  target_file: QubitizedWilsonCrossing.lean
  expected_module: QubitizedWilsonCrossing
  submission_project: null
  output_dir: null
  status: ready
```
