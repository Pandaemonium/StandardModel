# Null-edge Higgs strict-past measured resolvent

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: implemented

## Objective

Close the finite causal-order bridge between the nonuniform diagonal Higgs
mass insertion and the existing strict-past nilpotence theorem. Prove that
both `K M` and `M K` remain weighted strict-past kernels, are nilpotent at the
event-cardinality power, and remove both terminal remainders from the measured
retarded series.

## Result

`PhysicsSM/Draft/NullEdge/HiggsStrictPastMeasuredResolvent.lean` proves:

- right multiplication by the diagonal mass matrix rescales source weights;
- left multiplication rescales target weights;
- both insertion orders are nilpotent at power `Fintype.card V`; and
- the measured series satisfies exact left and right finite resolvent
  identities on every nonempty finite strict order.

Claim grade: `M [comp]`.

## Scope boundary

The strict order, primitive weights, vertex measure, and mass squared are
supplied. The result does not construct a continuum Green function, establish
a Lorentzian scalar equation, derive the measure or Higgs potential, or predict
an observed pole mass.

## Provenance

Project-internal composition of
`PhysicsSM/Draft/NullEdge/FiniteStrictPastKernelMatrix.lean` and
`PhysicsSM/Draft/NullEdge/HiggsMeasuredMassRetardedSeries.lean`. No external
proof text or implementation was copied.

## Verification

- Production SHA-256:
  `8291A21094E53497F44E8462C174A092A4D1A088F0E58C5112CAEA82FC8A5BC4`
- `lake env lean PhysicsSM/Draft/NullEdge/HiggsStrictPastMeasuredResolvent.lean`
- `lake build PhysicsSM.Draft.NullEdge.HiggsStrictPastMeasuredResolvent`
  (8,030 jobs)
- Lean LSP error diagnostics: empty
- `lean_verify` on `kernel_mul_localMassMatrix_pow_card_eq_zero` and
  `strictPast_measuredSeries_two_sided_resolvent`: standard three axioms, no
  source warnings

There are no proof holes or linter warnings in this module. The targeted build
replayed inherited nonfatal linter suggestions from
`HiggsEdgeEulerOperator.lean`.
