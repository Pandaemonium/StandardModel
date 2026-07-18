import PhysicsSM.Draft.NullEdge.NullEdgeSolderingPluckerBridge

/-!
# Schaden centered-plaquette proper-time bridge

This module isolates the finite kinematic identity behind the proper-time
construction in Martin Schaden, *Causal Space-Times on a Null Lattice*,
arXiv:1509.03095v2, Sec. III. In the project's `(+,-,-,-)` soldering
convention, one spinor-soldered edge is null, while the sum of two null edges
has Minkowski square equal to the squared norm of their Pluecker wedge.

The resulting square root is Schaden's centered-plaquette proper-time
increment. Its square also equals the project's landed two-edge Pluecker mass
scalar. That equality is a shared finite invariant, not a derivation of
inertial mass from elapsed time: this module contains no action, equation of
motion, Dirac gap, Higgs coupling, path maximization, or curved-spacetime
geodesic theorem.

Claim grades:

* `T [import]`: the centered-plaquette interpretation and source provenance;
* `M [comp]`: the exact bridge to the project's soldering and mass APIs.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.SchadenProperTimeBridge

open NullEdgeSpinorSoldering

/-- Nonnegative proper-time magnitude assigned to a causal displacement.

Only null and future-timelike inputs are used below. For a spacelike input,
Mathlib's real square root returns zero rather than a signed or imaginary
interval, so this definition is not a general replacement for the metric. -/
def causalProperTime (x : Vec4) : ℝ := Real.sqrt (minkowskiSq x)

/-- Proper-time increment of one spinor-soldered null edge. -/
def nullEdgeProperTime (psi : Spinor) : ℝ := causalProperTime (nullEdgeVector psi)

/-- Proper-time increment across the plaquette centered between two null
directions. -/
def centeredPlaquetteProperTime (psi chi : Spinor) : ℝ :=
  causalProperTime (nullEdgeVector psi + nullEdgeVector chi)

/-- A single spinor-soldered null edge contributes zero proper time. -/
theorem nullEdgeProperTime_eq_zero (psi : Spinor) :
    nullEdgeProperTime psi = 0 := by
  simp [nullEdgeProperTime, causalProperTime, nullEdgeVector_minkowskiSq]

/-- Schaden's centered-plaquette increment is the norm of the spinor
Pluecker wedge. -/
theorem centeredPlaquetteProperTime_eq_norm_wedge (psi chi : Spinor) :
    centeredPlaquetteProperTime psi chi = ‖spinorWedge psi chi‖ := by
  simp [centeredPlaquetteProperTime, causalProperTime,
    twoEdge_minkowskiSq_eq_wedge, Complex.norm_def]

/-- The centered-plaquette increment is positive exactly when the two null
directions have nonzero Pluecker area. -/
theorem centeredPlaquetteProperTime_pos_iff (psi chi : Spinor) :
    0 < centeredPlaquetteProperTime psi chi ↔ spinorWedge psi chi ≠ 0 := by
  rw [centeredPlaquetteProperTime_eq_norm_wedge, norm_pos_iff]

/-- Squaring the proper-time increment recovers the timelike Minkowski square
of the aggregate displacement. -/
theorem centeredPlaquetteProperTime_sq (psi chi : Spinor) :
    centeredPlaquetteProperTime psi chi ^ 2 =
      minkowskiSq (nullEdgeVector psi + nullEdgeVector chi) := by
  rw [centeredPlaquetteProperTime_eq_norm_wedge,
    twoEdge_minkowskiSq_eq_wedge]
  exact Complex.sq_norm _

/-- The centered-plaquette proper-time increment is invariant under the
project's determinant-one spinor action. -/
theorem centeredPlaquetteProperTime_sl2_invariant
    (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1) (psi chi : Spinor) :
    centeredPlaquetteProperTime (A.mulVec psi) (A.mulVec chi) =
      centeredPlaquetteProperTime psi chi := by
  unfold centeredPlaquetteProperTime causalProperTime
  rw [twoEdge_minkowskiSq_sl2_invariant A hA psi chi]

/-- The squared proper-time increment and the landed Pluecker mass scalar are
the same finite invariant. This is a dictionary theorem, not a mass-generation
mechanism. -/
theorem centeredPlaquetteProperTime_sq_eq_plucker_mass (psi chi : Spinor) :
    ((centeredPlaquetteProperTime psi chi ^ 2 : ℝ) : ℂ) =
      (PhysicsSM.Spinor.PluckerMass.twoEdgeMomentum psi chi).det := by
  rw [centeredPlaquetteProperTime_sq]
  exact NullEdgeSolderingPluckerBridge.soldering_mass_eq_plucker_det psi chi

/-- The coordinate spinors give a nonvacuous unit proper-time increment. -/
theorem rest_frame_centeredPlaquetteProperTime :
    centeredPlaquetteProperTime ![1, 0] ![0, 1] = 1 := by
  rw [centeredPlaquetteProperTime_eq_norm_wedge]
  norm_num [spinorWedge]

end PhysicsSM.Draft.NullEdge.SchadenProperTimeBridge

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SchadenProperTimeBridge.nullEdgeProperTime_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SchadenProperTimeBridge.nullEdgeProperTime_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.SchadenProperTimeBridge.centeredPlaquetteProperTime_eq_norm_wedge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SchadenProperTimeBridge.centeredPlaquetteProperTime_eq_norm_wedge

/-- info: 'PhysicsSM.Draft.NullEdge.SchadenProperTimeBridge.centeredPlaquetteProperTime_sl2_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SchadenProperTimeBridge.centeredPlaquetteProperTime_sl2_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.SchadenProperTimeBridge.centeredPlaquetteProperTime_sq_eq_plucker_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SchadenProperTimeBridge.centeredPlaquetteProperTime_sq_eq_plucker_mass

end
