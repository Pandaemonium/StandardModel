# Finite strict-past kernel matrix bridge

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Claim grade: `M [comp]`

## Objective

Connect the existing nilpotence theorem for weighted strict-past linear maps
to the matrix interface used by finite retarded Green-series algebra.

## Result

`weightedPastKernelMatrix` is the standard-basis matrix of
`weightedPastOperator`. The module proves:

- its matrix-vector action is exactly the original weighted causal-past
  action;
- on every nonempty finite strict order, its power at the event cardinality
  is zero; and
- the next power is zero as well, matching the terminal exponent of a series
  truncated at the event cardinality.

This removes an avoidable representation gap. It does not select weights or
identify the matrix with a continuum propagator.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/FiniteStrictPastKernelMatrix.lean`
- `lake build PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix` (8,027 jobs)
- Lean LSP diagnostics: empty.
- `lean_verify` on `weightedPastKernelMatrix_pow_card_eq_zero`: only
  `propext`, `Classical.choice`, and `Quot.sound`; no source-scan warnings.
- Build-enforced assumption footprints are pinned on the action identity and
  cardinality-nilpotence theorem.

## Provenance

Project-internal composition of
`FiniteStrictPastNilpotence.weightedPastOperator_pow_card_eq_zero` with
Mathlib's standard-basis `LinearMap.toMatrix` API.
