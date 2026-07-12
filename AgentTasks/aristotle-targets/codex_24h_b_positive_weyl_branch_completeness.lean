import PhysicsSM.Draft.NullEdge.LiveWeylJacobian
import PhysicsSM.Draft.NullEdge.MasslessBlochCrossingClassification
import PhysicsSM.Draft.NullEdge.LiveMasslessWeylCensusBridge

/-!
# Aristotle target: branch-resolved completeness of the live positive Weyl step

The full `4 x 4` massless determinant-root set is already classified, but each
body center carries both zero and pi quasienergies across the two Weyl blocks.
This target classifies the positive `2 x 2` block itself.  The sign of `u0`
must separate the branches rather than being inferred from the full determinant.

Do not weaken the biconditionals to one-way implications or to a finite list of
sampled points.  Do not claim a Chern theorem.  The local charge remains the
repository's exact sign of the real crossing-Jacobian determinant.
-/

namespace PhysicsSM.Draft.NullEdge.PositiveWeylBranchCompleteness

open Matrix
open SU2LocalCrossingCharge
open LiveWeylJacobian

abbrev V3 := LiveWeylJacobian.V3

/-- Exact positive-Weyl zero-quasienergy branch data in trigonometric
coordinates: even-parity corners or body centers with negative sine product. -/
def ZeroBranchData (q : V3) : Prop :=
  ((Real.cos (q 0)) ^ 2 = 1 ∧
      (Real.cos (q 1)) ^ 2 = 1 ∧
      (Real.cos (q 2)) ^ 2 = 1 ∧
      Real.cos (q 0) * Real.cos (q 1) * Real.cos (q 2) = 1) ∨
    (Real.cos (q 0) = 0 ∧ Real.cos (q 1) = 0 ∧ Real.cos (q 2) = 0 ∧
      Real.sin (q 0) * Real.sin (q 1) * Real.sin (q 2) = -1)

/-- Exact positive-Weyl pi-quasienergy branch data in trigonometric
coordinates: odd-parity corners or body centers with positive sine product. -/
def PiBranchData (q : V3) : Prop :=
  ((Real.cos (q 0)) ^ 2 = 1 ∧
      (Real.cos (q 1)) ^ 2 = 1 ∧
      (Real.cos (q 2)) ^ 2 = 1 ∧
      Real.cos (q 0) * Real.cos (q 1) * Real.cos (q 2) = -1) ∨
    (Real.cos (q 0) = 0 ∧ Real.cos (q 1) = 0 ∧ Real.cos (q 2) = 0 ∧
      Real.sin (q 0) * Real.sin (q 1) * Real.sin (q 2) = 1)

/-- The live positive Weyl block equals `+I` exactly on its zero branch. -/
theorem weylStep_eq_one_iff (q : V3) :
    LiveWeylJacobian.weylStep q = 1 ↔ ZeroBranchData q := by
  sorry

/-- The live positive Weyl block equals `-I` exactly on its pi branch. -/
theorem weylStep_eq_neg_one_iff (q : V3) :
    LiveWeylJacobian.weylStep q = -(1 : LiveWeylJacobian.M2) ↔ PiBranchData q := by
  sorry

/-- Zero- and pi-branch data are disjoint for the positive Weyl block. -/
theorem zeroBranchData_disjoint_piBranchData (q : V3) :
    ¬ (ZeroBranchData q ∧ PiBranchData q) := by
  sorry

/-- Every positive-Weyl zero crossing has a nondegenerate actual Frechet
Jacobian. -/
theorem zeroBranch_jacobian_det_ne_zero (q : V3)
    (hq : LiveWeylJacobian.weylStep q = 1) :
    (LiveWeylJacobian.weylJacobian q).det ≠ 0 := by
  sorry

/-- Every positive-Weyl pi crossing has a nondegenerate actual Frechet
Jacobian. -/
theorem piBranch_jacobian_det_ne_zero (q : V3)
    (hq : LiveWeylJacobian.weylStep q = -(1 : LiveWeylJacobian.M2)) :
    (LiveWeylJacobian.weylJacobian q).det ≠ 0 := by
  sorry

/-- Negative control: rank deficiency at the quarter-axis point is not a
crossing of either quasienergy branch. -/
theorem rankDeficientControl_not_crossing :
    LiveWeylJacobian.weylStep LiveWeylJacobian.rankDeficientControl ≠ 1 ∧
      LiveWeylJacobian.weylStep LiveWeylJacobian.rankDeficientControl ≠
        -(1 : LiveWeylJacobian.M2) := by
  sorry

end PhysicsSM.Draft.NullEdge.PositiveWeylBranchCompleteness
