The strategic frontier of the null-edge mass thesis: attempt a THIRD cross-mode
binding - relate the CLOSURE obstruction (C) to the APERTURE/TURN scalar on a
SHARED carrier, so "all mass from null edges" moves from "T=A bound, C bolted on
by analogy" toward all three modes sharing a quantity. This is SPECULATIVE and
carries a hard KILL CONDITION (see below).

Create a NEW module `PhysicsSM/Draft/NullEdge/GateI1/ObstructionScalar.lean`.
Check with `lake env lean`. If broader `lake build` stalls, SKIP.

## Context (all proved, in the tree)

- (A) `CompositeApertureMass.compositeMassSq_eq_zero_iff_collinear`,
  `ApertureEqualsTurn.apertureEqualsTurn_onShell`: the aperture mass
  `2*minkDot k+ k- = m^2` = the chirality-even turn coefficient, on one on-shell
  `Momentum4`.
- (C) `MassWithoutMass.z2GlueballMass beta = log coth beta`,
  `SlabTransferGap.neU4_closure_gap_pos`: the closure gap `-log tanh beta > 0`,
  a Z2 transfer-eigenvalue-ratio with NO `Momentum4`.
- The strategy (97a015dd) and the kill-test note: (C) and (A) currently share
  NO model - `z2GlueballMass` has no `Momentum4` - so the honest verdict is
  "shared SHAPE, not shared quantity."

## The target (choose the strongest honest form you can PROVE)

Define an ABSTRACT `ObstructionScalar` - a common structure that BOTH the closure
gap and the aperture mass genuinely INSTANTIATE - such that the "mass = relational
obstruction" reading becomes a single definition both rows satisfy, NOT a prose
analogy. Candidate shapes (pick the most defensible):

1. **A common monotone functional of a "return ratio".** Both masses have the
   form `f(lambda_vacuum, lambda_excited)` for a positive spectral/kinematic pair:
   closure = `fluxGap = log(lambda0/lambdaFlux)`; aperture: exhibit `m^2` (or
   `2 minkDot`) as the same `f` of a suitable positive pair built from `k+, k-`.
   Prove both are instances of ONE `def obstructionScalar (a b) := ...` with a
   shared positivity/monotonicity lemma.
2. **A shared "massless iff degenerate" characterization.** Both vanish exactly
   when a degeneracy holds (closure: sectors coincide / beta -> infinity;
   aperture: collinear). State `obstruction = 0 <-> degenerate` as ONE theorem
   schema both instantiate.

Deliver: the `ObstructionScalar` definition + BOTH instantiation theorems
(`closure_isObstructionScalar`, `aperture_isObstructionScalar`) + the shared
property (positivity, or zero-iff-degenerate).

## KILL CONDITION (mandatory - put in the docstring, and enforce)

The identification MUST be NON-VACUOUS and NON-DEFINITIONAL. It is FORBIDDEN to:
- define `obstructionScalar` so trivially (e.g. "any real number") that the
  instantiation carries no content;
- assert the closure gap and aperture mass are the SAME NUMBER (they are not -
  different models, no shared carrier);
- hide a `Momentum4 -> Z2` or `Z2 -> Momentum4` map that does not exist.
Include a NON-VACUITY WITNESS (in the style of
`ChargeGradingMassCompatible.coupling_would_distinguish`): exhibit that a generic
functional does NOT satisfy the shared property, so the shared structure is a
real constraint. If you cannot find a non-vacuous shared structure, REPORT THAT
as the result (a documented negative: "no non-vacuous common obstruction scalar
found; C and A share shape not quantity") - that is a valuable honest outcome,
NOT a failure.

## Constraints

- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. Reuse
  `z2GlueballMass`, `fluxGap`, `minkDot`, `minkowskiSq`, the aperture/closure
  API. Claim label: reconstruction / speculative binding (draft-trust); be
  scrupulously honest about vacuity.
- If `lake build` stalls, SKIP; return source + a clear proved-vs-vacuous verdict.
