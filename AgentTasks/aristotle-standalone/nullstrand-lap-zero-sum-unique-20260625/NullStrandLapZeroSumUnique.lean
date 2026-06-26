import Mathlib

/-!
# NullStrand zero-sum Poisson uniqueness target

Focused LA-003 algebra: if the finite Laplacian kernel consists of constants,
then a zero-sum gauge fixes Poisson solutions uniquely.
-/

noncomputable section

namespace NullStrandLapZeroSumUnique

open scoped BigOperators

/-- Coordinate sum zero for a finite real field. -/
def SumZero {Omega : Type*} [Fintype Omega] (f : Omega -> Real) : Prop :=
  ∑ omega, f omega = 0

/-- Same Poisson source plus zero-sum gauge gives equality of potentials. -/
theorem poisson_solution_unique_of_zeroSum
    {Omega : Type*} [Fintype Omega]
    (L : Matrix Omega Omega Real) (f g : Omega -> Real)
    (hker : ∀ h : Omega -> Real, Matrix.mulVec L h = 0 -> ∃ c : Real, ∀ omega, h omega = c)
    (hEq : Matrix.mulVec L f = Matrix.mulVec L g)
    (hf : SumZero f) (hg : SumZero g) :
    f = g := by
  have hzero : Matrix.mulVec L (f - g) = 0 := by
    simp only [Matrix.mulVec_sub, hEq, sub_self]
  obtain ⟨c, hc⟩ := hker (f - g) hzero
  have hsum : ∑ omega, (f - g) omega = 0 := by
    simp only [Pi.sub_apply]
    rw [Finset.sum_sub_distrib, hf, hg, sub_zero]
  have hcard : (Fintype.card Omega : Real) * c = 0 := by
    have : ∑ omega, (f - g) omega = ∑ _omega : Omega, c := by
      exact Finset.sum_congr rfl (fun omega _ => hc omega)
    rw [this] at hsum
    simpa [Finset.sum_const, Finset.card_univ, nsmul_eq_mul] using hsum
  funext omega
  have hfg : f omega - g omega = c := by
    have := hc omega
    simpa [Pi.sub_apply] using this
  have hcardpos : (0 : Real) < (Fintype.card Omega : Real) := by
    have : 0 < Fintype.card Omega := Fintype.card_pos_iff.mpr ⟨omega⟩
    exact_mod_cast this
  have hc0 : c = 0 := by
    rcases mul_eq_zero.mp hcard with h | h
    · exact absurd h (ne_of_gt hcardpos)
    · exact h
  have : f omega - g omega = 0 := by rw [hfg, hc0]
  linarith [this]

end NullStrandLapZeroSumUnique
