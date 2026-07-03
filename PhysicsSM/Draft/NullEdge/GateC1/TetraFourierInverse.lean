import PhysicsSM.Draft.NullEdge.GateC1.TetraCharactersEqual

/-!
# Gate C1: inverse of the equal-side tetrahedral Fourier transform

This Draft module builds the inverse of the normalized finite Fourier transform
`TetraCharactersEqual.fourierUnitary` and proves the round-trip identity
`fourierUnitaryInv (fourierUnitary Psi) = Psi`.

It is reusable infrastructure toward the OPERATOR-level overlap / Ginsparg-Wilson
release: the symbol-level release (`TetraSymbolOverlapGW.lean`) is per-momentum,
and packaging it to a real-space operator `sign(Hfree)` needs the inverse
transform to pull the blockwise sign symbols back to real space.

The round-trip is exactly the finite character column orthogonality
`TetraCharactersEqual.fourierChar_column_orthogonality`
(`sum_m conj(chi m x) chi m y = card . delta_xy`) together with the
normalization `fourierNormFactor^2 . card = 1`.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraFourierInverse

open scoped BigOperators
open TetraFiniteTorusEqual
open TetraCharactersEqual

variable {Spin : Type*} [Fintype Spin]

/-- The inverse normalized finite Fourier transform: the adjoint kernel
`conj(chi)` with the same normalization factor. -/
def fourierUnitaryInv (N : ℕ) [NeZero N]
    (Phi : MomN N → Spin → ℂ) : SiteN N → Spin → ℂ :=
  fun x s => (fourierNormFactor N : ℂ) *
    ∑ m : MomN N, star (fourierChar N m x) * Phi m s

/-- **Round-trip identity.** The inverse transform undoes the forward transform:
`fourierUnitaryInv (fourierUnitary Psi) = Psi`. -/
theorem fourierUnitaryInv_fourierUnitary (N : ℕ) [NeZero N]
    (Psi : SiteN N → Spin → ℂ) :
    fourierUnitaryInv N (fourierUnitary N Psi) = Psi := by
  funext x s
  have hnf : (fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ) *
      (Fintype.card (SiteN N) : ℂ) = 1 := by
    exact_mod_cast fourierNormFactor_sq_mul_card N
  unfold fourierUnitaryInv fourierUnitary rawFourier
  -- Flatten `nf * ∑ m, ...` into a double sum, then swap m and y.
  rw [Finset.mul_sum]
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  -- For each y, factor the constants out of the m-sum.
  have factored : ∀ y : SiteN N,
      (∑ m : MomN N, (fourierNormFactor N : ℂ) *
        (star (fourierChar N m x) * ((fourierNormFactor N : ℂ) *
          (fourierChar N m y * Psi y s))))
      = ((fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ) * Psi y s) *
          ∑ m : MomN N, star (fourierChar N m x) * fourierChar N m y := by
    intro y
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro m _
    ring
  rw [Finset.sum_congr rfl (fun y _ => factored y)]
  -- Apply column orthogonality; the `if x = y` collapses the y-sum.
  simp_rw [fourierChar_column_orthogonality, mul_ite, mul_zero]
  rw [Finset.sum_ite_eq Finset.univ x
    (fun y => (fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ) * Psi y s *
      (Fintype.card (SiteN N) : ℂ))]
  simp only [Finset.mem_univ, if_true]
  calc
    (fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ) * Psi x s *
        (Fintype.card (SiteN N) : ℂ)
        = ((fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ) *
            (Fintype.card (SiteN N) : ℂ)) * Psi x s := by ring
    _ = Psi x s := by rw [hnf, one_mul]

/-- The Fourier-convention character at zero momentum is the trivial character.
-/
theorem fourierChar_zero (N : ℕ) [NeZero N] :
    fourierChar N (0 : MomN N) = 0 := by
  have hsite : siteAddChar N (0 : MomN N) = 0 := by
    ext x
    rw [siteAddChar_apply]
    simp [map_zero, AddChar.zero_apply]
  rw [fourierChar, hsite, neg_zero]

/-- **Dual (row) character sum**: summing a single Fourier character over the
site torus gives `card` at zero momentum and `0` otherwise. This is the dual of
`fourierChar_sum_apply_eq_ite` and is the ingredient for the forward-inverse
Fourier round trip. -/
theorem fourierChar_site_sum_eq_ite (N : ℕ) [NeZero N] (m : MomN N) :
    ∑ x : SiteN N, fourierChar N m x =
      if m = 0 then (Fintype.card (SiteN N) : ℂ) else 0 := by
  by_cases hm : m = 0
  · subst hm
    rw [if_pos rfl, fourierChar_zero]
    simp [AddChar.zero_apply]
  · rw [if_neg hm]
    apply AddChar.sum_eq_zero_iff_ne_zero.mpr
    intro h
    exact hm ((fourierChar_bijective N).1 (h.trans (fourierChar_zero N).symm))

/-- **Row orthogonality** of the Fourier-convention character table: summing the
product `chi_m(x) . conj(chi_{m'}(x))` over sites `x` gives `card . delta_{m m'}`.
Reduces to the `siteAddChar` pair orthogonality via the character identities. -/
theorem fourierChar_row_orthogonality (N : ℕ) [NeZero N] (m m' : MomN N) :
    ∑ x : SiteN N, fourierChar N m x * star (fourierChar N m' x) =
      if m = m' then (Fintype.card (SiteN N) : ℂ) else 0 := by
  rw [← siteAddChar_pair_orthogonality_mom_eq_ite N m m']
  apply Finset.sum_congr rfl
  intro x _
  unfold fourierChar
  rw [AddChar.add_apply]
  congr 1
  rw [AddChar.neg_apply, AddChar.map_neg_eq_conj, starRingEnd_apply, star_star]

/-- **Forward-inverse round trip**: the forward transform undoes the inverse
transform, `fourierUnitary (fourierUnitaryInv Phi) = Phi`.  Together with
`fourierUnitaryInv_fourierUnitary` this makes `fourierUnitary` a genuine finite
isometric isomorphism, the two-sided inverse needed to package the per-momentum
sign symbols into a real-space `sign(Hfree)` operator. -/
theorem fourierUnitary_fourierUnitaryInv (N : ℕ) [NeZero N]
    (Phi : MomN N → Spin → ℂ) :
    fourierUnitary N (fourierUnitaryInv N Phi) = Phi := by
  funext m s
  have hnf : (fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ) *
      (Fintype.card (SiteN N) : ℂ) = 1 := by
    exact_mod_cast fourierNormFactor_sq_mul_card N
  unfold fourierUnitary fourierUnitaryInv rawFourier
  rw [Finset.mul_sum]
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  have factored : ∀ m' : MomN N,
      (∑ x : SiteN N, (fourierNormFactor N : ℂ) *
        (fourierChar N m x * ((fourierNormFactor N : ℂ) *
          (star (fourierChar N m' x) * Phi m' s))))
      = ((fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ) * Phi m' s) *
          ∑ x : SiteN N, fourierChar N m x * star (fourierChar N m' x) := by
    intro m'
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro x _
    ring
  rw [Finset.sum_congr rfl (fun m' _ => factored m')]
  simp_rw [fourierChar_row_orthogonality, mul_ite, mul_zero]
  rw [Finset.sum_ite_eq Finset.univ m
    (fun m' => (fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ) * Phi m' s *
      (Fintype.card (SiteN N) : ℂ))]
  simp only [Finset.mem_univ, if_true]
  calc
    (fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ) * Phi m s *
        (Fintype.card (SiteN N) : ℂ)
        = ((fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ) *
            (Fintype.card (SiteN N) : ℂ)) * Phi m s := by ring
    _ = Phi m s := by rw [hnf, one_mul]

end TetraFourierInverse
end GateC1
end NullEdge
end Draft
end PhysicsSM
