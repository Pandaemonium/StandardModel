import PhysicsSM.Coding.E8SpherePackingMatrixBridge

/-!
# SPL-free coordinate bridge: Construction A <-> SPL E8 basis

This module defines an explicit integer transition matrix from Construction A
basis coefficients to the local SPL-shaped E8 basis coefficients, and proves
it is unimodular (det = 1) and Gram-preserving.

## Mathematical content

We have two Z-bases for the E8 lattice:
- **Construction A basis** (`e8CodeBasisInt`), with scaled Gram matrix
  `e8ScaledGramQ = e8CodeBasisGram / 2`.
- **SPL basis** (`splE8BasisQ`), with Gram matrix `splE8GramQ`.

Both are related to the E8 Cartan matrix by unimodular transitions:
- `splToCartanTransition * splE8GramQ * splToCartanTransition^T = e8Cartan`
  (det = -1).
- `e8BasisChangeMatrix^T * e8ScaledGramQ * e8BasisChangeMatrix = e8Cartan`
  (det = -1).

The direct transition `T = constructionAToSPLTransition` from Construction A
coefficients to SPL coefficients satisfies:
- `T * e8BasisChangeMatrix = splToCartanTransition.transpose`.
- `T.transpose * splE8GramQ * T = e8ScaledGramQ`.
- `det T = 1`.

## Finite-computation trust boundary

All matrix identities are verified by `native_decide` over explicit 8 by 8
integer or rational matrices. `#print axioms` will report
`Lean.trustCompiler` for these declarations.

## No SPL imports

This module imports only project-local files and Mathlib; no external
Sphere-Packing-Lean dependency.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

open PhysicsSM.Lie.Exceptional.E8

/-! ## 1. The transition matrix -/

/-- The integer transition matrix from Construction A basis coefficients
to SPL basis coefficients.

Given a vector `c : Fin 8 -> Z` of Construction A basis coefficients
(i.e. `v = sum_i c_i * e8CodeBasisInt i`), the vector
`constructionAToSPLTransition *ᵥ c` gives the coefficients in the SPL
basis (i.e. `v = sum_j (T *ᵥ c)_j * splE8BasisQ.row j` in `Q^8`).

The matrix was computed as `D^T * P^-1` where:
- `D = splToCartanTransition` (SPL-to-Cartan, det = -1)
- `P = e8BasisChangeMatrix` (Construction A-to-Cartan, det = -1)
Both have integer inverses since `|det| = 1`. -/
def constructionAToSPLTransition : Matrix (Fin 8) (Fin 8) ℤ := !![
  -4, -2, -1, -2,  0, -1, -2, -2;
  -7, -3, -1, -3,  0, -1, -3, -3;
  -6, -3, -1, -2, -1, -1, -2, -3;
  -5, -3, -1, -2, -1,  0, -2, -3;
  -4, -2, -1, -1,  0,  0, -1, -3;
  -3, -1, -1, -1,  0,  0, -1, -2;
  -2, -1, -1, -1,  0,  0,  0, -1;
   2,  1,  0,  1,  0,  0,  1,  1]

/-! ## 2. Determinant (unimodularity) -/

set_option maxHeartbeats 800000 in
-- Expanding the 8 by 8 integer determinant through `Matrix.det_apply'` is
-- large but finite; the extra heartbeats keep the certificate local.
/-- The transition matrix has determinant 1 (unimodular, orientation-preserving). -/
theorem constructionAToSPLTransition_det : constructionAToSPLTransition.det = 1 := by
  simp only [constructionAToSPLTransition]
  norm_num [Matrix.det_apply'] at *
  native_decide +revert

/-! ## 3. Factorization through Cartan -/

/-- **Factorization identity.**

The transition matrix factors through the Cartan basis:
`T * P = D^T`, where `P = e8BasisChangeMatrix` and
`D = splToCartanTransition`. -/
theorem constructionAToSPLTransition_factorization :
    constructionAToSPLTransition * e8BasisChangeMatrix =
      splToCartanTransition.transpose := by
  native_decide

/-! ## 4. Gram preservation -/

/-- **Gram-preserving property.**

The transition matrix preserves the Gram structure:
`T^T * splE8GramQ * T = e8ScaledGramQ`. -/
theorem constructionAToSPLTransition_gram :
    (constructionAToSPLTransition.map (Int.castRingHom ℚ)).transpose *
      splE8GramQ *
      (constructionAToSPLTransition.map (Int.castRingHom ℚ)) =
    e8ScaledGramQ := by
  native_decide

/-! ## 5. Inverse transition -/

/-- The inverse transition matrix (SPL to Construction A), also integer-valued.

Since `det T = 1`, the inverse equals the adjugate. -/
def splToConstructionATransition : Matrix (Fin 8) (Fin 8) ℤ :=
  constructionAToSPLTransition.adjugate

/-- The inverse transition is a left inverse. -/
theorem splToConstructionA_left_inv :
    splToConstructionATransition * constructionAToSPLTransition = 1 := by
  unfold splToConstructionATransition
  rw [Matrix.adjugate_mul, constructionAToSPLTransition_det, one_smul]

/-- The inverse transition is a right inverse. -/
theorem splToConstructionA_right_inv :
    constructionAToSPLTransition * splToConstructionATransition = 1 := by
  unfold splToConstructionATransition
  rw [Matrix.mul_adjugate, constructionAToSPLTransition_det, one_smul]

/-! ## 6. Linear map from Construction A coefficients to SPL coordinates -/

/-- Z-linear map sending Construction A integer coefficient vectors to
SPL basis coefficient vectors over `Q`.

Given `c : Fin 8 -> Z`, this computes `T *ᵥ c` and casts to `Q`.
The output `(constructionACoeffToSPLQ c) j` is the `j`-th SPL basis
coefficient of the lattice vector represented by `c`. -/
def constructionACoeffToSPLQ : (Fin 8 → ℤ) →ₗ[ℤ] (Fin 8 → ℚ) where
  toFun c j := ↑(constructionAToSPLTransition.mulVec c j)
  map_add' x y := by
    ext j
    simp only [Matrix.mulVec, dotProduct, mul_add, Finset.sum_add_distrib, Int.cast_add,
      Pi.add_apply]
  map_smul' r x := by
    ext j
    simp only [Matrix.mulVec, dotProduct, Pi.smul_apply, smul_eq_mul,
      zsmul_eq_mul, eq_intCast]
    push_cast
    rw [Finset.mul_sum]
    congr 1
    ext i
    ring

/-- The linear map agrees with matrix-vector multiplication over `Q`. -/
theorem constructionACoeffToSPLQ_eq_mulVec (c : Fin 8 → ℤ) :
    constructionACoeffToSPLQ c =
      (constructionAToSPLTransition.map (Int.castRingHom ℚ)).mulVec
        (fun i => (c i : ℚ)) := by
  ext j
  simp [constructionACoeffToSPLQ, Matrix.mulVec, dotProduct, Matrix.map_apply]

/-! ## 7. Inner-product theorem -/

/-- **Inner product of images agrees with the scaled Gram form.**

For any two Construction A coefficient vectors `c1`, `c2`, the bilinear form
defined by `splE8GramQ` applied to their SPL images equals the
`e8ScaledGramQ` bilinear form on the original coefficients. -/
theorem constructionACoeffToSPLQ_inner (c₁ c₂ : Fin 8 → ℤ) :
    (constructionACoeffToSPLQ c₁) ⬝ᵥ
      (splE8GramQ.mulVec (constructionACoeffToSPLQ c₂)) =
    (fun i => (c₁ i : ℚ)) ⬝ᵥ
      (e8ScaledGramQ.mulVec (fun i => (c₂ i : ℚ))) := by
  simp only [constructionACoeffToSPLQ_eq_mulVec]
  rw [Matrix.mulVec_mulVec, Matrix.dotProduct_mulVec, Matrix.vecMul_mulVec,
      ← Matrix.mul_assoc, constructionAToSPLTransition_gram,
      ← Matrix.dotProduct_mulVec]

/-! ## 8. Integer-valuedness of the output -/

/-- The output of the linear map has integer-valued components.

Since `constructionAToSPLTransition` is an integer matrix and `c` is an
integer vector, `T *ᵥ c` has integer entries cast to `Q`. -/
theorem constructionACoeffToSPLQ_int_valued (c : Fin 8 → ℤ) (j : Fin 8) :
    ∃ n : ℤ, constructionACoeffToSPLQ c j = (n : ℚ) :=
  ⟨constructionAToSPLTransition.mulVec c j, rfl⟩

end PhysicsSM.Coding
