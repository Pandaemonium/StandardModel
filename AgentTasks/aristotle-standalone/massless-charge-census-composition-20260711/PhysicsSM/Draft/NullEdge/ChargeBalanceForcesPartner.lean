import PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge

/-!
# Finite charge balance forces a partner crossing

This module isolates the elementary finite implication used by every
conditional doubling argument: if the total integer charge is zero and one
crossing has nonzero charge, a distinct crossing must also have nonzero charge.
The total-charge-zero premise is explicit; this file does not derive it from
topology, Laurent locality, or Floquet theory.
-/

namespace PhysicsSM.Draft.NullEdge.ChargeBalanceForcesPartner

open PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge
open scoped BigOperators

theorem exists_second_nonzero_of_sum_eq_zero
    {ι : Type*} (s : Finset ι) (charge : ι -> Int)
    (i0 : ι) (hi0 : i0 ∈ s) (hne : charge i0 ≠ 0)
    (hsum : ∑ i ∈ s, charge i = 0) :
    ∃ i1 ∈ s, i1 ≠ i0 ∧ charge i1 ≠ 0 := by
  classical
  by_contra h
  have hz : ∀ i ∈ s, i ≠ i0 -> charge i = 0 := by
    intro i hi hne_i
    by_contra hcharge
    exact h ⟨i, hi, hne_i, hcharge⟩
  have hsingle : ∑ i ∈ s, charge i = charge i0 := by
    apply Finset.sum_eq_single i0
    · intro b hb hbi
      exact hz b hb hbi
    · intro hnot
      exact False.elim (hnot hi0)
  rw [hsingle] at hsum
  exact hne hsum

/-- Charge balance phrased through the supplied-Jacobian API. The only
topological-looking input, total charge zero, remains a displayed hypothesis. -/
theorem exists_second_nondegenerate_of_total_charge_zero
    {ι : Type*} (s : Finset ι) (J : ι -> J3)
    (i0 : ι) (hi0 : i0 ∈ s) (hne : (J i0).det ≠ 0)
    (hsum : ∑ i ∈ s, localCrossingCharge (J i) = 0) :
    ∃ i1 ∈ s, i1 ≠ i0 ∧ (J i1).det ≠ 0 := by
  classical
  have hcharge : localCrossingCharge (J i0) ≠ 0 :=
    (localCrossingCharge_ne_zero_iff (J i0)).2 hne
  obtain ⟨i1, hi1, hdiff, hcharge1⟩ :=
    exists_second_nonzero_of_sum_eq_zero s
      (fun i => localCrossingCharge (J i)) i0 hi0 hcharge hsum
  exact ⟨i1, hi1, hdiff,
    (localCrossingCharge_ne_zero_iff (J i1)).1 hcharge1⟩

def oppositeFixture : Fin 2 -> J3
  | 0 => weylPlusJacobian
  | 1 => weylMinusJacobian

theorem oppositeFixture_total_charge_zero :
    ∑ i : Fin 2, localCrossingCharge (oppositeFixture i) = 0 := by
  rw [Fin.sum_univ_two]
  simp [oppositeFixture, weylPlus_charge, weylMinus_charge]

/-- Nonvacuity: the positive fixture's distinct partner is found in the exact
two-sector cancellation example. -/
theorem oppositeFixture_has_distinct_partner :
    ∃ i1 ∈ (Finset.univ : Finset (Fin 2)), i1 ≠ 0 ∧
      (oppositeFixture i1).det ≠ 0 := by
  apply exists_second_nondegenerate_of_total_charge_zero
      (Finset.univ : Finset (Fin 2)) oppositeFixture 0
  · simp
  · simp [oppositeFixture, weylPlusJacobian_det]
  · simpa using oppositeFixture_total_charge_zero

/-- Negative control: a singleton carrying nonzero charge cannot satisfy the
zero-total premise. -/
theorem singleton_nonzero_charge_sum_ne_zero
    {ι : Type*} (charge : ι -> Int) (i0 : ι)
    (hne : charge i0 ≠ 0) :
    ∑ i ∈ ({i0} : Finset ι), charge i ≠ 0 := by
  classical
  simpa using hne

end PhysicsSM.Draft.NullEdge.ChargeBalanceForcesPartner
