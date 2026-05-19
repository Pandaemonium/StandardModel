import PhysicsSM.Coding.E8SpherePackingMatrixBridge
import PhysicsSM.Coding.E8SpherePackingShape

/-!
# No-native transition matrix targets for the Construction A/SPL bridge

All proofs use `decide` or `norm_num` (kernel/simp reduction), not
`native_decide`, so `Lean.trustCompiler` does not appear in axioms.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.style.maxHeartbeats false
set_option linter.unusedSimpArgs false

namespace PhysicsSM.Coding

/-- Local copy of the Construction A to SPL transition matrix. -/
def constructionAToSPLTransitionLocal : Matrix (Fin 8) (Fin 8) ℤ := !![
  -4, -2, -1, -2,  0, -1, -2, -2;
  -7, -3, -1, -3,  0, -1, -3, -3;
  -6, -3, -1, -2, -1, -1, -2, -3;
  -5, -3, -1, -2, -1,  0, -2, -3;
  -4, -2, -1, -1,  0,  0, -1, -3;
  -3, -1, -1, -1,  0,  0, -1, -2;
  -2, -1, -1, -1,  0,  0,  0, -1;
   2,  1,  0,  1,  0,  0,  1,  1]

/-- An explicit integer inverse for `constructionAToSPLTransitionLocal`. -/
def constructionAToSPLTransitionLocalInv : Matrix (Fin 8) (Fin 8) ℤ := !![
   1, -1,  0,  0,  0,  0,  0, -1;
   0, -1,  1, -1, -1,  2,  0, -2;
   0, -1,  1, -1,  0,  0,  0, -3;
  -1,  2, -1,  1,  1, -1, -1,  4;
   0,  1, -1,  0,  1, -1,  0,  1;
  -1,  1, -1,  1,  0,  0,  0,  1;
   0, -1,  1, -1,  0,  0,  1, -2;
  -1,  2, -1,  1,  0, -1,  0,  3]

/-- Left inverse check. -/
theorem constructionAToSPLTransitionLocal_inv_mul :
    constructionAToSPLTransitionLocalInv * constructionAToSPLTransitionLocal = 1 := by
  decide

/-- Right inverse check. -/
theorem constructionAToSPLTransitionLocal_mul_inv :
    constructionAToSPLTransitionLocal * constructionAToSPLTransitionLocalInv = 1 := by
  decide

/-- `constructionAToSPLTransitionLocal` is a unit in the matrix ring. -/
theorem constructionAToSPLTransitionLocal_isUnit :
    IsUnit constructionAToSPLTransitionLocal :=
  IsUnit.of_mul_eq_one constructionAToSPLTransitionLocalInv
    constructionAToSPLTransitionLocal_mul_inv

/-- Factorization identity `T * P = Dᵀ`. -/
theorem constructionAToSPLTransitionLocal_factorization :
    constructionAToSPLTransitionLocal * e8BasisChangeMatrix =
      splToCartanTransition.transpose := by
  decide

-- 8×8 rational matrix triple product: 64 entries checked by simp + norm_num
set_option maxHeartbeats 16000000 in
/-- The Gram congruence for the local transition matrix. -/
theorem constructionAToSPLTransitionLocal_gram :
    (constructionAToSPLTransitionLocal.map (Int.castRingHom ℚ)).transpose *
      splE8GramQ *
      (constructionAToSPLTransitionLocal.map (Int.castRingHom ℚ)) = e8ScaledGramQ := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [constructionAToSPLTransitionLocal, splE8GramQ, e8ScaledGramQ, e8CodeBasisGram,
      Matrix.mul_apply, Matrix.transpose_apply, Matrix.map_apply,
      Matrix.of_apply, Fin.sum_univ_eight] <;>
    norm_num

end PhysicsSM.Coding
