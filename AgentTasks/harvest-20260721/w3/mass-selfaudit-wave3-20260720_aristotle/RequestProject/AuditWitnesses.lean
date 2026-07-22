import Mathlib

open Matrix

/-! # Wave-3 semantic audit witnesses

Small Mathlib-only models used by `AUDIT.md`.  They test the logical shapes of the
claims without importing any external landing.
-/

namespace AuditWitnesses

section Yukawa

/-- A one-dimensional coupling space with a weak phase convention (`0 ≤ x`). -/
def WeakPhaseFixed (x : ℝ) : Prop := 0 ≤ x

/-
Phase fixing alone includes both the zero coupling and a nonzero coupling.
-/
theorem weak_phase_does_not_give_uniqueness :
    WeakPhaseFixed 0 ∧ WeakPhaseFixed 1 ∧ (0 : ℝ) ≠ 1 := by
  exact ⟨ by exact le_rfl, by exact zero_le_one, by norm_num ⟩

/-
A fixed magnitude repairs the real one-dimensional model.
-/
theorem phase_and_magnitude_unique {x y r : ℝ}
    (hx : WeakPhaseFixed x) (hy : WeakPhaseFixed y)
    (hxr : |x| = r) (hyr : |y| = r) : x = y := by
  linarith [ abs_of_nonneg hx, abs_of_nonneg hy ]

end Yukawa

section Mechanism

variable {V : Type*} [AddCommGroup V] [Module ℚ V]

/-- `M` preserves the grading. -/
def GammaEven (Γ M : V →ₗ[ℚ] V) : Prop := Γ.comp M = M.comp Γ

/-- `M` reverses the grading. -/
def GammaOdd (Γ M : V →ₗ[ℚ] V) : Prop := Γ.comp M = -(M.comp Γ)

/-
For the degenerate grading `Γ = 1`, every map is even.
-/
theorem trivial_grading_every_map_even (M : V →ₗ[ℚ] V) :
    GammaEven LinearMap.id M := by
  ext
  simp

/-
For the degenerate grading `Γ = 1`, an odd map is zero.
-/
theorem trivial_grading_odd_iff_zero (M : V →ₗ[ℚ] V) :
    GammaOdd LinearMap.id M ↔ M = 0 := by
  constructor;
  · intro h
    ext x
    simp [GammaOdd] at h;
    replace h := congr_arg ( fun f => f x ) h; norm_num at h;
    rw [ eq_neg_iff_add_eq_zero ] at h;
    simpa [ ← two_smul ℚ ] using h;
  · unfold GammaOdd; aesop;

/-
Surjectivity of the grading map suffices; an involution and a
`no-fixed-vector` assumption are stronger than necessary.
-/
theorem odd_even_intersection_of_surjective (Γ M : V →ₗ[ℚ] V)
    (hΓ : Function.Surjective Γ) (he : GammaEven Γ M) (ho : GammaOdd Γ M) :
    M = 0 := by
  ext x;
  obtain ⟨ y, hy ⟩ := hΓ x;
  replace he := congr_arg (fun f => f y) he
  replace ho := congr_arg (fun f => f y) ho
  simp_all
  rw [ neg_eq_iff_add_eq_zero ] at he;
  simpa [ ← two_smul ℚ ] using he

end Mechanism

section Resolvent

/-- A two-by-two response with prescribed `(0,0)` entry and arbitrary `(1,1)` entry. -/
def responseWithTail (head tail : ℚ) : Matrix (Fin 2) (Fin 2) ℚ :=
  !![head, 0; 0, tail]

/-
Knowing the displayed pole in one matrix entry does not determine the full response.
-/
theorem same_zero_zero_entry_different_full_response (z : ℚ) :
    (responseWithTail (z + 1)⁻¹ 0) 0 0 = (z + 1)⁻¹ ∧
    (responseWithTail (z + 1)⁻¹ 1) 0 0 = (z + 1)⁻¹ ∧
    responseWithTail (z + 1)⁻¹ 0 ≠ responseWithTail (z + 1)⁻¹ 1 := by
  unfold responseWithTail; aesop;

end Resolvent

section UniformGap

/-
On an empty parameter space, a positive uniform margin exists for every gap
function, solely because the pointwise condition has no instances.
-/
theorem empty_parameter_uniform_margin (gap : Empty → ℝ) :
    ∃ δ : ℝ, 0 < δ ∧ ∀ k, δ ≤ gap k := by
  exact ⟨ 1, by norm_num, by rintro ⟨ ⟩ ⟩

/-
With a nonempty parameter space, a positive uniform lower bound has an actual
pointwise witness.
-/
theorem uniform_margin_has_pointwise_content {K : Type*} [Nonempty K]
    (gap : K → ℝ) (δ : ℝ) (hδ : 0 < δ) (hgap : ∀ k, δ ≤ gap k) :
    ∃ k, 0 < gap k := by
  exact ⟨ Classical.arbitrary K, lt_of_lt_of_le hδ ( hgap _ ) ⟩

end UniformGap

section Seesaw

abbrev M2 := Matrix (Fin 2) (Fin 2) ℚ

def nonsymmetricMR : M2 := !![1, 1; 0, 1]

def nonsymmetricMRInv : M2 := !![1, -1; 0, 1]

/-
A concrete nonsymmetric right-handed block is nevertheless invertible.
-/
theorem nonsymmetricMR_inverse :
    nonsymmetricMR * nonsymmetricMRInv = 1 ∧
    nonsymmetricMRInv * nonsymmetricMR = 1 := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;>
    norm_num [nonsymmetricMR, nonsymmetricMRInv, Matrix.mul_apply, Fin.sum_univ_two]

/-
With `mD = 1`, the advertised light block is nonsymmetric when `MR` is
nonsymmetric.  Thus it is not automatically a symmetric Majorana mass matrix.
-/
theorem general_invertible_MR_can_give_nonsymmetric_light_block :
    (-nonsymmetricMRInv)ᵀ ≠ -nonsymmetricMRInv := by
  intro h
  have h01 := congrFun (congrFun h (0 : Fin 2)) (1 : Fin 2)
  norm_num [nonsymmetricMRInv] at h01

/-
Symmetry of `MR` (expressed here directly for its inverse) repairs the shape:
the Schur-complement light block is symmetric.
-/
theorem light_block_symmetric_of_inverse_symmetric
    (mD MRinv : M2) (h : MRinvᵀ = MRinv) :
    (-mD * MRinv * mDᵀ)ᵀ = -mD * MRinv * mDᵀ := by
  simp_all
  rw [Matrix.mul_assoc]

end Seesaw

end AuditWitnesses
