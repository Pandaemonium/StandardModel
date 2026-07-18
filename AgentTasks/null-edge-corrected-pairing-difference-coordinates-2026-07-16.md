# Corrected-pairing intrinsic difference coordinates

Date: 2026-07-16
Work item: `GRAV-ORDER-OPERATOR-001`
Claim grade: `M [orig/comp]`, finite algebra only
Status: integrated, built, and independently approved

## Objective

Diagonalize the corrected weighted-difference form in graph-native based
difference coordinates and determine whether the actual local causal
coefficients can realize a strict mostly-minus sign pattern.

## Production module

`PhysicsSM/Draft/NullEdge/CorrectedPairingDifferenceCoordinates.lean`

SHA-256:
`e72afb6d4cc0c174b15c69d1fa4894a03f30010d65a643651b546da9f1c44813`

## Landed results

- `weightedDifferenceForm_eq_differenceCoordinates` proves that the corrected
  form is diagonal in the coordinates `f(y) - f(x)`.
- `differenceCoordinates_injective` proves those coordinates are faithful on
  the zero-sum probe space.
- `fiveEventDifferenceProbe_linearIndependent` and
  `fiveEventDifferenceBasis` construct an explicit basis of the rank-four
  five-event zero-sum space.
- `fiveEventDifferenceBasis_gram_eq_eta` gives an exact abstract signed-star
  control with Gram matrix `diag(1,-1,-1,-1)`.
- `fiveEventLorentzOrder_intervalCounts` proves that the concrete order
  `0 < {1,2,3} < 4` is a five-event three-arm diamond with top-row interval
  counts `(3,0,0,0)`.
- `fiveEventLorentzDiamond_inClosed_all`, `fiveEventClosedCarrierEquiv`, and
  `fiveEventInducedOrderIso` prove that all five events lie in one marked
  bottom-top Alexandrov carrier and that its induced order is exactly the
  concrete order up to relabeling.
- `fiveEventProjectLocalWeight_values` evaluates the actual project-sign local
  row as `(8s,-s,-s,-s,0)`.
- `fiveEventProjectLocal_differenceProbe_gram` bridges the result back to
  `correctedPairingAt (projectLocal4DOperator ...)` and proves the exact
  diagonal Gram formula.
- `fiveEventProjectLocal_differenceProbe_signs` proves one strictly positive
  and three strictly negative diagonal entries whenever `ell != 0`.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/CorrectedPairingDifferenceCoordinates.lean`
  passed cleanly after the final instance-scope edit.
- `lake build PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates`
  passed all 8036 jobs cleanly after the final carrier-bridge edit.
- Headline results have build-enforced standard-three axiom guards.

## Scope boundary

This is a nonvacuous finite signature witness, not a reconstruction theorem.
It does not canonically select the five-event order from a refinement family,
construct overlap transitions, prove a four-mode spectral gap, formalize the
normalizing rescaling into the existing `HasLorentzianInertia` predicate, or
prove continuum convergence.

## Independent semantic review

Claude rebuilt and approved the final module at Lean SHA-256
`e72afb6d4cc0c174b15c69d1fa4894a03f30010d65a643651b546da9f1c44813`.
The audit verified the coordinate injection, explicit basis, abstract eta
control, transitive three-arm order, counts `(3,0,0,0)`, production coefficient
and sign bridge, strict mostly-minus theorem, all-events-in-one-carrier result,
closed-carrier equivalence, and definitionally exact induced-order isomorphism.
It found no stale `(1,0,0,0)` or `9s` claims and approved the scope exclusions.
Review artifact:
`AutonomousLab/reviews/CLAUDE_REVIEW_DIFFERENCE_COORDINATES_LORENTZ_WITNESS_2026-07-16.md`.
