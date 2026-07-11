import PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge

/-!
# Exact product-character DFT core for the finite 3+1 walk

This module proves the row/column orthogonality and exact normalization of the
positive-exponential product characters used by `Finite3Plus1FourierBridge`.
The one-dimensional input is Mathlib's `AddChar.sum_mulShift`, instantiated at
the primitive standard additive character of `ZMod L`; no sign conversion is
needed for the live walk's plane-wave convention.
-/

noncomputable section

open Matrix Complex
open scoped BigOperators ZMod

namespace PhysicsSM.Draft.NullEdge.Finite3Plus1ProductDFTCore

open Finite3Plus1FourierBridge

abbrev Axis := Finite3Plus1FourierBridge.Axis
abbrev Position (L : Nat) := Finite3Plus1FourierBridge.Position L

/-- Number of sites on the finite cubic three-torus. -/
def siteCard (L : Nat) [NeZero L] : Nat := Fintype.card (Position L)

/-- Normalization used by the exact DFT round trips.

Parseval and unitarity are separate successor theorems. -/
def fourierNormFactor (L : Nat) [NeZero L] : Real :=
  1 / Real.sqrt (siteCard L : Real)

/-- Complex conjugation reverses the standard additive character. -/
theorem star_stdAddChar {L : Nat} [NeZero L] (x : ZMod L) :
    star (ZMod.stdAddChar x) = ZMod.stdAddChar (-x) := by
  rw [AddChar.map_neg_eq_inv]
  simp only [ZMod.stdAddChar_apply]
  rw [← Circle.coe_inv, Circle.coe_inv_eq_conj, starRingEnd_apply]

/-- Every product plane wave has unit norm. -/
theorem planeWave_norm {L : Nat} [NeZero L] (k p : Position L) :
    ‖planeWave k p‖ = 1 := by
  unfold planeWave
  rw [norm_prod]
  apply Finset.prod_eq_one
  intro j _
  exact AddChar.norm_apply _ _

/-- Every product plane wave is nonzero. -/
theorem planeWave_ne_zero {L : Nat} [NeZero L] (k p : Position L) :
    planeWave k p ≠ 0 := by
  intro h
  have hn := planeWave_norm k p
  rw [h, norm_zero] at hn
  exact zero_ne_one hn

/-- Factorized product-character orthogonality on the cubic torus. -/
theorem sum_prod_stdAddChar {L : Nat} [NeZero L] (b : Position L) :
    ∑ x : Position L, ∏ j : Axis, ZMod.stdAddChar (x j * b j) =
      if b = 0 then (siteCard L : Complex) else 0 := by
  have key :
      (∑ x : Position L, ∏ j : Axis, ZMod.stdAddChar (x j * b j)) =
        ∏ j : Axis, ∑ xj : ZMod L, ZMod.stdAddChar (xj * b j) := by
    rw [Finset.prod_univ_sum]
    rfl
  rw [key]
  have hf : ∀ j : Axis,
      (∑ xj : ZMod L, ZMod.stdAddChar (xj * b j)) =
        ((if b j = 0 then Fintype.card (ZMod L) else 0 : Nat) : Complex) := by
    intro j
    exact AddChar.sum_mulShift (b j) (ZMod.isPrimitive_stdAddChar L)
  simp_rw [hf]
  by_cases h : b = 0
  · subst h
    simp [siteCard, Fintype.card_pi]
  · have hex : ∃ j, b j ≠ 0 := by
      by_contra hc
      push_neg at hc
      exact h (funext hc)
    obtain ⟨j, hj⟩ := hex
    rw [if_neg h]
    apply Finset.prod_eq_zero (Finset.mem_univ j)
    simp [hj]

/-- Conjugate-times-wave collapses to a shifted product character. -/
theorem star_planeWave_mul_prod {L : Nat} [NeZero L] (k p q : Position L) :
    star (planeWave k p) * planeWave k q =
      ∏ j : Axis, ZMod.stdAddChar (k j * (q j - p j)) := by
  unfold planeWave
  rw [star_prod, ← Finset.prod_mul_distrib]
  apply Finset.prod_congr rfl
  intro j _
  rw [star_stdAddChar, ← AddChar.map_add_eq_mul]
  congr 1
  ring

/-- Wave-times-conjugate collapses to a shifted product character. -/
theorem planeWave_mul_star_prod {L : Nat} [NeZero L]
    (k ell p : Position L) :
    planeWave k p * star (planeWave ell p) =
      ∏ j : Axis, ZMod.stdAddChar (p j * (k j - ell j)) := by
  unfold planeWave
  rw [star_prod, ← Finset.prod_mul_distrib]
  apply Finset.prod_congr rfl
  intro j _
  rw [star_stdAddChar, ← AddChar.map_add_eq_mul]
  congr 1
  ring

/-- Product-character column orthogonality. -/
theorem planeWave_column_orthogonality {L : Nat} [NeZero L]
    (p q : Position L) :
    ∑ k : Position L, star (planeWave k p) * planeWave k q =
      if p = q then (siteCard L : Complex) else 0 := by
  simp_rw [star_planeWave_mul_prod]
  rw [sum_prod_stdAddChar (fun j => q j - p j)]
  by_cases hpq : p = q
  · subst hpq
    have hz : (fun j => p j - p j) = (0 : Position L) := by
      funext j
      simp
    rw [if_pos hz, if_pos rfl]
  · rw [if_neg hpq, if_neg]
    intro hc
    apply hpq
    funext j
    have hj := congrFun hc j
    simp only [Pi.zero_apply, sub_eq_zero] at hj
    exact hj.symm

/-- Product-character row orthogonality. -/
theorem planeWave_row_orthogonality {L : Nat} [NeZero L]
    (k ell : Position L) :
    ∑ p : Position L, planeWave k p * star (planeWave ell p) =
      if k = ell then (siteCard L : Complex) else 0 := by
  simp_rw [planeWave_mul_star_prod]
  rw [sum_prod_stdAddChar (fun j => k j - ell j)]
  by_cases hkl : k = ell
  · subst hkl
    have hz : (fun j => k j - k j) = (0 : Position L) := by
      funext j
      simp
    rw [if_pos hz, if_pos rfl]
  · rw [if_neg hkl, if_neg]
    intro hc
    apply hkl
    funext j
    have hj := congrFun hc j
    simp only [Pi.zero_apply, sub_eq_zero] at hj
    exact hj

/-- The finite site register is nonempty. -/
theorem siteCard_pos (L : Nat) [NeZero L] : 0 < siteCard L := by
  unfold siteCard
  exact Fintype.card_pos

/-- The square of the normalization cancels the site count exactly. -/
theorem fourierNormFactor_sq_mul_card (L : Nat) [NeZero L] :
    fourierNormFactor L * fourierNormFactor L * (siteCard L : Real) = 1 := by
  unfold fourierNormFactor
  have hpos : (0 : Real) < (siteCard L : Real) := by
    exact_mod_cast siteCard_pos L
  rw [div_mul_div_comm, one_mul, Real.mul_self_sqrt hpos.le]
  field_simp

/-- Equal-column nondegeneracy control. -/
theorem column_zero_control (L : Nat) [NeZero L] :
    ∑ k : Position L,
        star (planeWave k (0 : Position L)) * planeWave k 0 =
      (siteCard L : Complex) := by
  rw [planeWave_column_orthogonality]
  simp

/-- Explicit distinct-column zero control on the two-site-per-axis torus. -/
theorem distinct_column_control :
    ∑ k : Position 2,
        star (planeWave k (0 : Position 2)) *
          planeWave k (fun j => if j = 0 then 1 else 0) = 0 := by
  rw [planeWave_column_orthogonality]
  rw [if_neg]
  intro hc
  have h := congrFun hc 0
  simp at h

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1ProductDFTCore.planeWave_column_orthogonality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms planeWave_column_orthogonality

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1ProductDFTCore.planeWave_row_orthogonality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms planeWave_row_orthogonality

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1ProductDFTCore.fourierNormFactor_sq_mul_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourierNormFactor_sq_mul_card

/-- info: 'PhysicsSM.Draft.NullEdge.Finite3Plus1ProductDFTCore.distinct_column_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms distinct_column_control

end PhysicsSM.Draft.NullEdge.Finite3Plus1ProductDFTCore
