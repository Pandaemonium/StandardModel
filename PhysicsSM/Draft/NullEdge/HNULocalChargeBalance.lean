import PhysicsSM.Draft.NullEdge.ChargeBalanceForcesPartner
import PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge

/-!
# Conditional global partner theorem for the HNU infrared node

This module composes the exact HNU infrared Jacobian with the elementary finite
charge-balance theorem. It proves a deliberately conditional statement: if a
finite global crossing ledger contains the HNU node and its supplied local
Jacobian charges sum to zero, then a distinct nondegenerate crossing exists.

The zero-total premise is displayed and is not derived here from Brillouin-zone
topology, Floquet micromotion, locality, or a bulk-boundary theorem. Thus the
result is a precise local-to-global implication, not an unconditional doubling
theorem for the HNU regulator.
-/

namespace PhysicsSM.Draft.NullEdge.HNULocalChargeBalance

open scoped BigOperators
open PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge
open PhysicsSM.Draft.NullEdge.ChargeBalanceForcesPartner
open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge

/-- The exact HNU infrared Jacobian has local crossing charge `+1` in the
finite Jacobian-sign charge API. -/
theorem hnuLocalCrossingCharge_eq_one :
    localCrossingCharge weylJacobian = 1 := by
  apply localCrossingCharge_eq_one
  rw [weylJacobian_det]
  norm_num

/-- **Conditional global partner theorem.** Any finite zero-total charge ledger
that contains the exact HNU infrared node also contains a distinct
nondegenerate crossing. The theorem does not derive the zero-total premise. -/
theorem exists_distinct_partner_of_total_charge_zero
    {ι : Type*} (s : Finset ι) (J : ι -> J3)
    (i0 : ι) (hi0 : i0 ∈ s) (hHNU : J i0 = weylJacobian)
    (hsum : ∑ i ∈ s, localCrossingCharge (J i) = 0) :
    ∃ i1 ∈ s, i1 ≠ i0 ∧ (J i1).det ≠ 0 := by
  apply exists_second_nondegenerate_of_total_charge_zero s J i0 hi0
  · rw [hHNU]
    exact weylJacobian_det_ne_zero
  · exact hsum

/-- Negative control: the HNU node alone cannot satisfy the displayed
zero-total charge premise. -/
theorem hnuSingleton_charge_sum_ne_zero :
    ∑ J ∈ ({weylJacobian} : Finset J3), localCrossingCharge J ≠ 0 := by
  simp [hnuLocalCrossingCharge_eq_one]

end PhysicsSM.Draft.NullEdge.HNULocalChargeBalance

/-! ## Build-enforced assumption-footprint guards -/

open PhysicsSM.Draft.NullEdge.HNULocalChargeBalance in
/-- info: 'PhysicsSM.Draft.NullEdge.HNULocalChargeBalance.hnuLocalCrossingCharge_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hnuLocalCrossingCharge_eq_one

open PhysicsSM.Draft.NullEdge.HNULocalChargeBalance in
/-- info: 'PhysicsSM.Draft.NullEdge.HNULocalChargeBalance.exists_distinct_partner_of_total_charge_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms exists_distinct_partner_of_total_charge_zero

open PhysicsSM.Draft.NullEdge.HNULocalChargeBalance in
/-- info: 'PhysicsSM.Draft.NullEdge.HNULocalChargeBalance.hnuSingleton_charge_sum_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hnuSingleton_charge_sum_ne_zero
