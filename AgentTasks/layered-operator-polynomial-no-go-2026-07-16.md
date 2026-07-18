# Finite layered-operator polynomial-projector no-go

Date: 2026-07-16  
Work item: `GRAV-ORDER-OPERATOR-001`  
Claim grade: `M [orig/comp]` for finite causal-order algebra only  
Status: integrated, built, and independently approved

## Objective

Compose finite weighted strict-past nilpotence with the abstract
scalar-plus-nilpotent polynomial-idempotent theorem, and connect that
composition exactly to the existing
`FiniteCausalOrder.layeredOperator` definition.

## Production modules

- `PhysicsSM/Draft/NullEdge/FiniteStrictPastNilpotence.lean`, SHA-256
  `c698f35060fa9b8dee3f8b0943af6052957119b6b0cdb1c7e8888c45b66f2dac`;
- `PhysicsSM/Draft/NullEdge/RetardedPolynomialProjectorNoGo.lean`, SHA-256
  `b02e3de4f83c9f19a3b44323335527f285b30c74d38b28024c2fdcd5990d3a15`;
- `PhysicsSM/Draft/NullEdge/LayeredOperatorPolynomialNoGo.lean`, SHA-256
  `8e2f6bdc5128eab8f2b6c5a40576dab326b91c308444a0ca0eb1513e50a0c8e4`.

## Landed finite results

- `weightedPastOperator_pow_card_eq_zero`: every arbitrarily weighted
  strict-past operator on a nonempty finite transitive irreflexive relation is
  nilpotent at power `Fintype.card V`.
- `twoChain_weightedPast_nonzero_and_square_zero`: a nonzero two-event
  square-zero witness prevents vacuous reading of nilpotence.
- `idempotent_eq_zero_or_id_of_sub_scalar_nilpotent`: an idempotent in one
  scalar generalized eigenspace is zero or identity.
- `polynomial_idempotent_of_scalar_add_nilpotent_trivial`: every idempotent
  polynomial filter of `a I + N`, with nilpotent `N`, is zero or identity.
- `layeredOperatorLinear_apply`: the bundled operator is exactly the existing
  pointwise `FiniteCausalOrder.layeredOperator`.
- `layeredPastLinear_pow_card_eq_zero`: its off-diagonal strict-past part is
  nilpotent.
- `layeredOperatorLinear_polynomial_idempotent_trivial`: the generic finite
  diagonal-plus-layered-past operator has no nonzero proper idempotent
  polynomial filter.
- `sourceLocal4DOperatorLinear_polynomial_idempotent_trivial`: the concrete
  source-sign local four-dimensional Benincasa-Dowker specialization inherits
  the no-go.
- `projectSmeared4DOperatorLinear_polynomial_idempotent_trivial`: the active
  project-sign smeared operator, including both scale branches, inherits the
  same no-go.

## Scope boundary

This kills only direct polynomial filtering of the one-spectrum finite
retarded operator. It does not rule out normal or Hermitian operators built
from retarded/advanced data, non-polynomial functional calculus, constraint
kernels, edge/cochain/spin probe modules, or a graph-derived operator with
multiple separated spectral sectors. It derives no rank-four sector,
Lorentzian inertia, continuum limit, stress-energy, or Einstein dynamics.

## Verification

- Direct Lean passed for all three production modules.
- Combined targeted build passed 8037 jobs:
  `lake build PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence PhysicsSM.Draft.NullEdge.RetardedPolynomialProjectorNoGo PhysicsSM.Draft.NullEdge.LayeredOperatorPolynomialNoGo`.
- Every headline theorem has a build-enforced axiom guard reporting only
  `propext`, `Classical.choice`, and `Quot.sound`.
- The only new-module build message is a nonblocking `ring_nf` suggestion in
  the returned abstract proof.

## Remaining gates

1. Select a genuinely richer order-native operator candidate and preregister
   four-mode isolation, spectral gap, corrected-pairing inertia, and overlap
   transport before any numerical scan.
2. Prove or kill that successor on a nonvacuous graph family; no rank-four,
   continuum, stress-energy, or Einstein-dynamics claim follows from this
   no-go alone.

## Independent semantic review

Claude verified both Aristotle pairs verbatim against their live production
statements, rebuilt all three modules, checked all ten axiom guards, and
approved the finite-order adapter and active project-sign smearing bridge
without revision. Review artifact:
`AutonomousLab/reviews/CLAUDE_REVIEW_LAYERED_OPERATOR_NOGO_2026-07-16.md`.
