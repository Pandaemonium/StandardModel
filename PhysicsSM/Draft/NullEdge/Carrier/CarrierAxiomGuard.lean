import PhysicsSM.Draft.NullEdge.Carrier.NullNilpotentSquare
import PhysicsSM.Draft.NullEdge.Carrier.SolderedSquareGram
import PhysicsSM.Draft.NullEdge.Carrier.ColorCommutantScalar

/-!
# CarrierAxiomGuard: build-enforced axiom-footprint guard for the Weitzenbock-carrier lane

The Claude-lane counterpart of `GateYM/SlabAxiomGuard.lean` (the closure-lane guard).
This module pins the transitive axiom footprint of every flagship in the null-edge
**Weitzenbock-carrier** program (`AgentTasks/overnight-mass-run-2026-07-06/FABLE_STEER.md`;
executed by the two-day carrier run `AgentTasks/twoday-carrier-run-2026-07-07`).

Each `#guard_msgs (whitespace := lax) in #print axioms ...` block FAILS TO BUILD if the
audited theorem's transitive axiom footprint ever drifts from the standard base
`[propext, Classical.choice, Quot.sound]` (or fewer) - i.e. if a `s o r r y`,
`n a t i v e _ d e c i d e`, or new `a x i o m` ever leaks into a carrier flagship.

Ownership: Claude owns this file in the two-day run; Codex owns `SlabAxiomGuard`. The two
guards are edited independently to avoid collision.

## Guarded flagships

* Move-1 brick 1 (`NullNilpotentSquare`): the null Clifford nilpotency keystone
  `c(alpha)^2 = 0` and the zero-edge-diagonal "mass is relational" identity.
* [H2] constraint (`ColorCommutantScalar`): the color commutant on the triplet is the
  scalars (Schur), so only a color-blind scalar mass is color-exact.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.CarrierAxiomGuard

/-! ## Move-1 brick 1: null Clifford nilpotency + zero-edge-diagonal soldered square -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.null_clifford_sq_zero' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.null_clifford_sq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.nullSoldered_square_offDiagonal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.nullSoldered_square_offDiagonal

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.lone_edge_massless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.lone_edge_massless

/-! ## Move-1 brick 2a: the soldered square IS the aperture Gram form Q_A -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.nullSoldered_square_eq_half_gram' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.nullSoldered_square_eq_half_gram

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.nullSoldered_square_isScalar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.nullSoldered_square_isScalar

/-! ## [H2] constraint: color commutant on the triplet = scalars -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.color_commutant_eq_scalars' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.color_commutant_eq_scalars

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.nonscalar_mass_not_color_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.nonscalar_mass_not_color_exact

end PhysicsSM.Draft.NullEdge.Carrier.CarrierAxiomGuard
