import Mathlib
import SpherePacking.Dim8.E8.Basic
import SpherePacking.Dim8.E8.Packing
import CodeLatticeE8.E8.Span
import CodeLatticeE8.E8.Gram

/-!
# Basis bridge from Hamming Construction A to SPL's E8 lattice

This module contains the explicit coordinate bridge needed by the SPL-facing
theta-series theorem.  It keeps the analytic theorem separate from the finite
linear algebra used to compare lattice models.

The Hamming Construction A package uses the integer model

```text
{ z : Z^8 | z mod 2 belongs to H_8 }.
```

The SPL analytic theorem uses `E8Lattice`, built from the half-integer
`Submodule.E8 R` model.  The bridge is an explicit unimodular matrix `T`:

```text
Construction A basis coefficients --T--> SPL E8Matrix row coefficients.
```

The main geometric statement is `sqNorm_eq_two_mul_norm_sq`: if a Construction A
vector `z` is transported to the SPL Euclidean model, then the unscaled integer
norm of `z` is twice the Euclidean squared norm.  Thus the shell
`sqNorm z = 4 n` corresponds exactly to the SPL shell `||w||^2 = 2 n`.

## Provenance

The SPL basis matrix is the `E8Matrix` basis from `math-inc/Sphere-Packing-Lean`
(Apache-2.0).  The transition matrix is the previously checked
Construction-A/SPL change-of-basis matrix used in the project; this module
repackages only the pieces needed for shell transport.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.style.maxHeartbeats false
set_option linter.unusedSimpArgs false
set_option linter.flexible false

open scoped RealInnerProductSpace
open Finset Matrix

local notation "R8" => EuclideanSpace Real (Fin 8)

namespace CodeLatticeE8.SPL

open CodeLatticeE8.E8
open CodeLatticeE8.ConstructionA

/-! ## SPL basis data -/

/-- The SPL `E8Matrix`, reproduced over `Q` for small exact matrix checks. -/
def splE8BasisQ : Matrix (Fin 8) (Fin 8) ℚ := !![
     2,   0,   0,   0,   0,   0,   0,   0;
    -1,   1,   0,   0,   0,   0,   0,   0;
     0,  -1,   1,   0,   0,   0,   0,   0;
     0,   0,  -1,   1,   0,   0,   0,   0;
     0,   0,   0,  -1,   1,   0,   0,   0;
     0,   0,   0,   0,  -1,   1,   0,   0;
     0,   0,   0,   0,   0,  -1,   1,   0;
   1/2, 1/2, 1/2, 1/2, 1/2, 1/2, 1/2, 1/2]

/-- The Gram matrix of the SPL row basis, over `Q`. -/
def splE8GramQ : Matrix (Fin 8) (Fin 8) ℚ := !![
   4, -2,  0,  0,  0,  0,  0,  1;
  -2,  2, -1,  0,  0,  0,  0,  0;
   0, -1,  2, -1,  0,  0,  0,  0;
   0,  0, -1,  2, -1,  0,  0,  0;
   0,  0,  0, -1,  2, -1,  0,  0;
   0,  0,  0,  0, -1,  2, -1,  0;
   0,  0,  0,  0,  0, -1,  2,  0;
   1,  0,  0,  0,  0,  0,  0,  2]

set_option maxHeartbeats 8000000 in
/-- The declared SPL Gram matrix is the row Gram matrix of `splE8BasisQ`. -/
theorem splE8GramQ_eq :
    splE8GramQ = splE8BasisQ * splE8BasisQ.transpose := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [splE8GramQ, splE8BasisQ, Matrix.mul_apply,
      Matrix.transpose_apply, Fin.sum_univ_eight] <;>
    norm_num

set_option maxHeartbeats 400000 in
/-- SPL's real `E8Matrix` is the real cast of the reproduced rational matrix. -/
theorem E8Matrix_R_eq_splE8BasisQ_map :
    E8Matrix Real = splE8BasisQ.map (algebraMap ℚ Real) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [E8Matrix, splE8BasisQ, Matrix.map_apply]

/-- The real row Gram matrix of `E8Matrix` is the cast of `splE8GramQ`. -/
theorem E8Matrix_gram_R_eq_splE8GramQ_cast :
    (E8Matrix Real) * (E8Matrix Real).transpose =
      splE8GramQ.map (algebraMap ℚ Real) := by
  rw [E8Matrix_R_eq_splE8BasisQ_map, ← Matrix.transpose_map, ← Matrix.map_mul,
    ← splE8GramQ_eq]

/-! ## Construction A to SPL transition -/

/--
The integer transition from Hamming Construction A basis coefficients to SPL
`E8Matrix` row coefficients.
-/
def constructionAToSPLTransition : Matrix (Fin 8) (Fin 8) ℤ := !![
  -4, -2, -1, -2,  0, -1, -2, -2;
  -7, -3, -1, -3,  0, -1, -3, -3;
  -6, -3, -1, -2, -1, -1, -2, -3;
  -5, -3, -1, -2, -1,  0, -2, -3;
  -4, -2, -1, -1,  0,  0, -1, -3;
  -3, -1, -1, -1,  0,  0, -1, -2;
  -2, -1, -1, -1,  0,  0,  0, -1;
   2,  1,  0,  1,  0,  0,  1,  1]

/-- An explicit integer inverse for `constructionAToSPLTransition`. -/
def splToConstructionATransition : Matrix (Fin 8) (Fin 8) ℤ := !![
   1, -1,  0,  0,  0,  0,  0, -1;
   0, -1,  1, -1, -1,  2,  0, -2;
   0, -1,  1, -1,  0,  0,  0, -3;
  -1,  2, -1,  1,  1, -1, -1,  4;
   0,  1, -1,  0,  1, -1,  0,  1;
  -1,  1, -1,  1,  0,  0,  0,  1;
   0, -1,  1, -1,  0,  0,  1, -2;
  -1,  2, -1,  1,  0, -1,  0,  3]

/-- The displayed inverse is a left inverse. -/
theorem splToConstructionATransition_mul :
    splToConstructionATransition * constructionAToSPLTransition = 1 := by
  decide

/-- The displayed inverse is a right inverse. -/
theorem constructionAToSPLTransition_mul_inv :
    constructionAToSPLTransition * splToConstructionATransition = 1 := by
  decide

/-- The transition matrix is invertible over the integers. -/
theorem constructionAToSPLTransition_isUnit :
    IsUnit constructionAToSPLTransition :=
  IsUnit.of_mul_eq_one splToConstructionATransition constructionAToSPLTransition_mul_inv

set_option maxHeartbeats 16000000 in
/-- The transition preserves the scaled Gram form. -/
theorem constructionAToSPLTransition_gram :
    (constructionAToSPLTransition.map (Int.castRingHom ℚ)).transpose *
      splE8GramQ *
      (constructionAToSPLTransition.map (Int.castRingHom ℚ)) =
    hammingConstructionScaledGram := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [constructionAToSPLTransition, splE8GramQ, hammingConstructionScaledGram,
      hammingConstructionGram, Matrix.mul_apply, Matrix.transpose_apply,
      Matrix.map_apply, Matrix.of_apply, Fin.sum_univ_eight] <;>
    norm_num

/-! ## Bilinear algebra helpers -/

private theorem dotProduct_sum_smul_eq_gram {n : ℕ}
    (r : Fin n → (Fin n → ℝ)) (a b : Fin n → ℤ) :
    (∑ i, (a i) • r i) ⬝ᵥ (∑ j, (b j) • r j) =
      ∑ i : Fin n, ∑ j : Fin n,
        (a i : ℝ) * (r i ⬝ᵥ r j) * (b j : ℝ) := by
  have h_expand :
      (∑ i, (a i • r i)) ⬝ᵥ (∑ j, (b j • r j)) =
        ∑ i, (a i • r i) ⬝ᵥ (∑ j, (b j • r j)) := by
    exact sum_dotProduct univ (fun i => a i • r i) (∑ j, b j • r j)
  simp_all +decide [mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _,
    Finset.sum_mul, dotProduct]
  exact Finset.sum_congr rfl fun _ _ =>
    Finset.sum_comm.trans
      (Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring)

private theorem gram_form_change_of_basis {n : ℕ}
    (G : Matrix (Fin n) (Fin n) ℝ)
    (T : Matrix (Fin n) (Fin n) ℤ)
    (c₁ c₂ : Fin n → ℤ) :
    ∑ i : Fin n, ∑ j : Fin n,
      (T.mulVec c₁ i : ℝ) * G i j * (T.mulVec c₂ j : ℝ) =
    ∑ i : Fin n, ∑ j : Fin n,
      (c₁ i : ℝ) *
      ((T.map (Int.castRingHom ℝ)).transpose * G * T.map (Int.castRingHom ℝ)) i j *
      (c₂ j : ℝ) := by
  simp +decide [Matrix.mul_apply, mul_assoc, mul_comm, mul_left_comm,
    Finset.mul_sum _ _ _, Finset.sum_mul]
  simp +decide [Matrix.mulVec, dotProduct, mul_assoc, mul_comm, mul_left_comm,
    Finset.mul_sum _ _ _, Finset.sum_mul]
  simp +decide only [← sum_product']
  apply Finset.sum_bij (fun x _ => (x.2.2.2, x.2.2.1, x.2.1, x.1))
  · simp +decide
  · grind
  · simp +decide
  · grind

private theorem inner_intLinComb_eq_gram_form {n : ℕ}
    (M : Matrix (Fin n) (Fin n) ℝ)
    (T : Matrix (Fin n) (Fin n) ℤ)
    (c₁ c₂ : Fin n → ℤ) :
    (∑ i, (T.mulVec c₁ i) • M.row i) ⬝ᵥ
      (∑ j, (T.mulVec c₂ j) • M.row j) =
    ∑ i : Fin n, ∑ j : Fin n,
      (c₁ i : ℝ) *
      ((T.map (Int.castRingHom ℝ)).transpose *
       (M * M.transpose) *
       T.map (Int.castRingHom ℝ)) i j *
      (c₂ j : ℝ) := by
  rw [dotProduct_sum_smul_eq_gram M.row (T.mulVec c₁) (T.mulVec c₂)]
  have hGram : ∀ i j : Fin n, M.row i ⬝ᵥ M.row j = (M * M.transpose) i j := by
    intro i j
    simp [dotProduct, Matrix.mul_apply, Matrix.transpose_apply]
  simp_rw [hGram]
  exact gram_form_change_of_basis (M * M.transpose) T c₁ c₂

private theorem gram_congruence_Q_to_R {n : ℕ}
    (T : Matrix (Fin n) (Fin n) ℤ)
    (G H : Matrix (Fin n) (Fin n) ℚ)
    (hGram : (T.map (Int.castRingHom ℚ)).transpose * G *
        (T.map (Int.castRingHom ℚ)) = H) :
    (T.map (Int.castRingHom ℝ)).transpose *
      (G.map (algebraMap ℚ ℝ)) *
      (T.map (Int.castRingHom ℝ)) =
    H.map (algebraMap ℚ ℝ) := by
  convert congr_arg (fun x : Matrix (Fin n) (Fin n) ℚ => x.map (algebraMap ℚ ℝ)) hGram
    using 1
  ext i j
  simp +decide [Matrix.mul_apply]

/-- Real-valued Gram congruence for the transition matrix. -/
theorem constructionAToSPLTransition_gram_R :
    (constructionAToSPLTransition.map (Int.castRingHom ℝ)).transpose *
      (splE8GramQ.map (algebraMap ℚ ℝ)) *
      (constructionAToSPLTransition.map (Int.castRingHom ℝ)) =
    hammingConstructionScaledGram.map (algebraMap ℚ ℝ) :=
  gram_congruence_Q_to_R constructionAToSPLTransition splE8GramQ
    hammingConstructionScaledGram constructionAToSPLTransition_gram

/-! ## Linear map into the SPL E8 lattice -/

/-- The real vector represented by Construction A basis coefficients in the SPL model. -/
noncomputable def constructionAToE8 : (Fin 8 → ℤ) →ₗ[ℤ] (Fin 8 → ℝ) where
  toFun c := ∑ i : Fin 8,
    (constructionAToSPLTransition.mulVec c i) • (E8Matrix ℝ).row i
  map_add' x y := by
    simp only [Matrix.mulVec_add, Pi.add_apply, ← Finset.sum_add_distrib, add_smul]
  map_smul' r x := by
    ext k
    simp [Matrix.mulVec, dotProduct, Finset.mul_sum, Finset.sum_mul,
      mul_assoc, mul_comm, mul_left_comm]

/-- The image of `constructionAToE8` lies in SPL's `Submodule.E8`. -/
theorem constructionAToE8_mem_E8 (c : Fin 8 → ℤ) :
    constructionAToE8 c ∈ Submodule.E8 ℝ := by
  rw [← span_E8Matrix ℝ]
  change ∑ i : Fin 8,
      (constructionAToSPLTransition.mulVec c i) • (E8Matrix ℝ).row i ∈
    Submodule.span ℤ (Set.range (E8Matrix ℝ).row)
  exact Submodule.sum_mem _ fun i _ =>
    Submodule.smul_mem (Submodule.span ℤ (Set.range (E8Matrix ℝ).row))
      (constructionAToSPLTransition.mulVec c i)
      (Submodule.subset_span (Set.mem_range_self i))

/-- The map to SPL coordinates is injective. -/
theorem constructionAToE8_injective :
    Function.Injective constructionAToE8 := by
  intro a b hab
  have h0 : constructionAToE8 (a - b) = 0 := by
    rw [map_sub, sub_eq_zero]
    exact hab
  have hunitT : IsUnit constructionAToSPLTransition :=
    constructionAToSPLTransition_isUnit
  have hunitST : IsUnit (E8Matrix ℝ).transpose := by
    rw [Matrix.isUnit_iff_isUnit_det, Matrix.det_transpose, E8Matrix_unimodular]
    exact isUnit_one
  set c := a - b with hc
  set d : Fin 8 → ℝ := fun i => (constructionAToSPLTransition.mulVec c i : ℝ) with hd_def
  have h1 : (E8Matrix ℝ).transpose.mulVec d = 0 := by
    ext k
    simp only [Matrix.mulVec, dotProduct, Pi.zero_apply, hd_def, Matrix.transpose_apply]
    have := congr_fun h0 k
    simp only [constructionAToE8, LinearMap.coe_mk, AddHom.coe_mk, Finset.sum_apply,
      Pi.smul_apply, zsmul_eq_mul, Pi.zero_apply, Matrix.row_apply] at this
    convert this using 1
    congr 1
    ext i
    simp [Matrix.mulVec, dotProduct, Matrix.row_apply]
    ring
  have h2 : d = 0 :=
    (Matrix.mulVec_injective_of_isUnit hunitST) (by rw [h1, Matrix.mulVec_zero])
  have h3 : constructionAToSPLTransition.mulVec c = 0 := by
    ext i
    have := congr_fun h2 i
    simp only [Pi.zero_apply, hd_def] at this
    exact_mod_cast this
  have h4 : c = 0 :=
    (Matrix.mulVec_injective_of_isUnit hunitT) (by rw [h3, Matrix.mulVec_zero])
  exact sub_eq_zero.mp h4

/-- `T^{-1} * (T * c) = c`. -/
theorem splToConstructionATransition_mulVec_mulVec (c : Fin 8 → ℤ) :
    splToConstructionATransition.mulVec
      (constructionAToSPLTransition.mulVec c) = c := by
  simp [Matrix.mulVec_mulVec, splToConstructionATransition_mul]

/-- `T * (T^{-1} * d) = d`. -/
theorem constructionAToSPLTransition_mulVec_inv_mulVec (d : Fin 8 → ℤ) :
    constructionAToSPLTransition.mulVec
      (splToConstructionATransition.mulVec d) = d := by
  simp [Matrix.mulVec_mulVec, constructionAToSPLTransition_mul_inv]

/-- The map to SPL coordinates is surjective onto `Submodule.E8 ℝ`. -/
theorem constructionAToE8_surj_E8 (v : Fin 8 → ℝ) (hv : v ∈ Submodule.E8 ℝ) :
    ∃ c : Fin 8 → ℤ, constructionAToE8 c = v := by
  rw [← span_E8Matrix ℝ] at hv
  rw [Submodule.mem_span_range_iff_exists_fun] at hv
  obtain ⟨d, hd⟩ := hv
  refine ⟨splToConstructionATransition.mulVec d, ?_⟩
  change ∑ i : Fin 8,
    (constructionAToSPLTransition.mulVec
      (splToConstructionATransition.mulVec d) i) •
    (E8Matrix ℝ).row i = v
  rw [constructionAToSPLTransition_mulVec_inv_mulVec]
  exact hd

/-- Inner products of transported vectors are computed by the scaled Construction A Gram form. -/
theorem constructionAToE8_inner (c₁ c₂ : Fin 8 → ℤ) :
    constructionAToE8 c₁ ⬝ᵥ constructionAToE8 c₂ =
    ∑ i : Fin 8, ∑ j : Fin 8,
      (c₁ i : ℝ) * (hammingConstructionScaledGram i j : ℝ) * (c₂ j : ℝ) := by
  have h1 := inner_intLinComb_eq_gram_form
    (E8Matrix ℝ) constructionAToSPLTransition c₁ c₂
  rw [E8Matrix_gram_R_eq_splE8GramQ_cast] at h1
  rw [constructionAToSPLTransition_gram_R] at h1
  simp only [Matrix.map_apply] at h1
  exact h1

/-- Squared norm form for transported vectors. -/
theorem constructionAToE8_norm_sq (c : Fin 8 → ℤ) :
    constructionAToE8 c ⬝ᵥ constructionAToE8 c =
    ∑ i : Fin 8, ∑ j : Fin 8,
      (c i : ℝ) * (hammingConstructionScaledGram i j : ℝ) * (c j : ℝ) :=
  constructionAToE8_inner c c

/-! ## Basis-coefficient helpers for the Hamming model -/

/-- Rebuild an integer Construction A vector from coefficients in the displayed basis. -/
noncomputable def fromBasisCoeffs (c : Fin 8 → ℤ) : Fin 8 → ℤ :=
  fun j => ∑ i : Fin 8, c i * hammingConstructionBasis i j

/-- Rebuilt basis-coefficient vectors lie in the Hamming Construction A lattice. -/
theorem fromBasisCoeffs_mem (c : Fin 8 → ℤ) :
    fromBasisCoeffs c ∈ hammingConstructionA := by
  rw [← mem_hammingConstructionASubmodule, hammingConstructionASubmodule_eq_span]
  have h : fromBasisCoeffs c = ∑ i : Fin 8, c i • hammingConstructionBasis i := by
    ext j
    simp [fromBasisCoeffs, Finset.sum_apply]
  rw [h]
  exact Submodule.sum_mem _ fun i _ =>
    Submodule.smul_mem _ _ (Submodule.subset_span (Set.mem_range_self i))

/-- The explicit coefficient formula is a left inverse to rebuilding. -/
theorem hammingConstructionBasisCoeffs_fromBasisCoeffs (c : Fin 8 → ℤ) :
    hammingConstructionBasisCoeffs (fromBasisCoeffs c) = c := by
  ext i
  fin_cases i <;>
    simp [hammingConstructionBasisCoeffs, fromBasisCoeffs, hammingConstructionBasis,
      Matrix.cons_val_zero, Matrix.cons_val_one, Fin.sum_univ_eight] <;>
    omega

/-- Rebuilding from the explicit coefficients returns the original lattice vector. -/
theorem fromBasisCoeffs_hammingConstructionBasisCoeffs
    (z : Fin 8 → ℤ) (hz : z ∈ hammingConstructionA) :
    fromBasisCoeffs (hammingConstructionBasisCoeffs z) = z := by
  ext j
  simpa [fromBasisCoeffs] using
    (hammingConstructionBasis_reconstruction z hz j).symm

/-! ## Norm compatibility and shell transport helpers -/

/-- Norm in `WithLp` agrees with the ordinary coordinate dot product. -/
theorem withLp_norm_sq_eq_dot (v : Fin 8 → Real) :
    ‖(WithLp.linearEquiv 2 Real (Fin 8 → Real)).symm v‖ ^ 2 = v ⬝ᵥ v := by
  rw [EuclideanSpace.norm_eq]
  rw [Real.sq_sqrt (Finset.sum_nonneg (fun i _ => sq_nonneg _))]
  simp only [dotProduct, WithLp.linearEquiv]
  congr 1
  ext i
  simp [sq, Real.norm_eq_abs]

/-- The scaled Gram entry is one half of the integer Gram entry. -/
theorem hammingConstructionScaledGram_eq_half_gram (i j : Fin 8) :
    (hammingConstructionScaledGram i j : Real) =
      (hammingConstructionGram i j : Real) / 2 := by
  simp [hammingConstructionScaledGram, Matrix.of_apply]

set_option maxRecDepth 10000
set_option maxHeartbeats 16000000

/--
Norm compatibility for the model bridge.

For `z` in the Hamming Construction A integer lattice, transport the displayed
basis coefficients of `z` into the SPL Euclidean model.  The unscaled integer
norm of `z` is twice the Euclidean squared norm of the transported vector.
-/
theorem sqNorm_eq_two_mul_norm_sq (z : Fin 8 → ℤ) (hz : z ∈ hammingConstructionA) :
    let c := hammingConstructionBasisCoeffs z
    let v := constructionAToE8 c
    let w : R8 := (WithLp.linearEquiv 2 Real (Fin 8 → Real)).symm v
    (sqNorm z : Real) = 2 * ‖w‖ ^ 2 := by
  simp only
  rw [withLp_norm_sq_eq_dot, constructionAToE8_norm_sq]
  have hrec : z = fromBasisCoeffs (hammingConstructionBasisCoeffs z) :=
    (fromBasisCoeffs_hammingConstructionBasisCoeffs z hz).symm
  have hsq :
      (sqNorm z : Real) =
        (sqNorm (fromBasisCoeffs (hammingConstructionBasisCoeffs z)) : Real) := by
    exact congrArg (fun u : Fin 8 → ℤ => (sqNorm u : Real)) hrec
  rw [hsq]
  simp only [sqNorm, fromBasisCoeffs]
  simp_rw [hammingConstructionScaledGram_eq_half_gram]
  simp only [hammingConstructionGram_eq]
  push_cast
  simp [Fin.sum_univ_eight, hammingConstructionBasis]
  ring_nf

/-- Transport basis coefficients to the `E8Lattice` Euclidean subtype. -/
noncomputable def toE8LatticeVec (c : Fin 8 → ℤ) : R8 :=
  (WithLp.linearEquiv 2 Real (Fin 8 → Real)).symm (constructionAToE8 c)

/-- The transported vector belongs to `E8Lattice`. -/
theorem toE8LatticeVec_mem (c : Fin 8 → ℤ) :
    toE8LatticeVec c ∈ E8Lattice := by
  unfold E8Lattice
  rw [Submodule.mem_map]
  exact ⟨constructionAToE8 c, constructionAToE8_mem_E8 c, rfl⟩

/-- The coefficient-to-lattice map is injective. -/
theorem toE8LatticeVec_injective : Function.Injective toE8LatticeVec := by
  intro a b hab
  have : constructionAToE8 a = constructionAToE8 b := by
    have h := congr_arg (WithLp.linearEquiv 2 Real (Fin 8 → Real)) hab
    simp [toE8LatticeVec] at h
    exact h
  exact constructionAToE8_injective this

/-- Every vector of `E8Lattice` is represented by some coefficient vector. -/
theorem toE8LatticeVec_surj (w : R8) (hw : w ∈ E8Lattice) :
    ∃ c : Fin 8 → ℤ, toE8LatticeVec c = w := by
  unfold E8Lattice at hw
  rw [Submodule.mem_map] at hw
  obtain ⟨v, hv, hvw⟩ := hw
  obtain ⟨c, hc⟩ := constructionAToE8_surj_E8 v hv
  exact ⟨c, by unfold toE8LatticeVec; rw [hc]; exact hvw⟩

end CodeLatticeE8.SPL
