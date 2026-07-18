# Null-edge corrected pairing as a weighted-difference operator

Date: 2026-07-16
Work item: `GRAV-ORDER-OPERATOR-001`
Claim grade: `M [orig/comp]`, finite algebra only
Status: integrated, built, and independently approved

## Objective

Separate the corrected principal-symbol pairing from the one-spectrum direct
retarded operator and represent the corrected pairing by a canonical operator
on the intrinsic zero-sum probe space.

## Production module

`PhysicsSM/Draft/NullEdge/CorrectedPairingDifferenceOperator.lean`

SHA-256:
`9529f5634b4f2a05dcb3063ef124e741f6fbc0f4d1db3e9fc65785a4c9e15433`

## Landed results

- `correctedPairingAt_layeredOperator_eq_weightedDifferenceForm` proves exact
  cancellation of the scalar diagonal and rewrites the pairing as a symmetric
  weighted sum of finite differences.
- `weightedDifferenceOperator_mem_zeroSum` proves that the representing
  operator has zero-sum range.
- `weightedDifferenceOperator_selfAdjoint` proves self-adjointness with respect
  to the finite-field Euclidean dot product.
- `correctedPairingAt_layeredOperator_eq_fieldDot` restricts the representing
  operator canonically to the zero-sum probe space without choosing a basis or
  projection.
- `correctedPairingAt_projectSmeared4D_eq_fieldDot` specializes the identity to
  the active project-sign smeared operator, including both scale branches.
- `twoEvent_weightedDifferenceOperator_witness` proves the operator need not be
  zero.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/CorrectedPairingDifferenceOperator.lean`
  passed cleanly after the final style edit.
- `lake build PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo` passed
  8037 jobs and replayed only an upstream proof-style information message.
- Representative statements have build-enforced standard-three axiom guards.

## Scope boundary

The module proves neither positivity nor Lorentzian inertia, rank four, a
four-mode gap, nor continuum convergence. Its value is architectural: the raw
retarded polynomial-selector route is now killed, while the corrected
symmetric difference operator remains an admissible object for G2b spectral
analysis.

## Independent semantic review

Claude approved the exact diagonal cancellation against the production
`correctedPairingAt` and `layeredOperator` definitions, the canonical
self-adjoint zero-sum representation, the two-event nonvacuity control, and
the active smeared two-branch bridge without revision. Review artifact:
`AutonomousLab/reviews/CLAUDE_REVIEW_CORRECTED_PAIRING_ESCAPE_2026-07-16.md`.
