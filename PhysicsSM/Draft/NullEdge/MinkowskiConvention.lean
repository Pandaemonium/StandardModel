import Mathlib

/-!
# Minkowski convention grounded in Mathlib's `indefiniteDiagonal` (PhysLean provenance)

Clean-room port of the PhysLean `minkowskiMatrix` convention
(`Physlib`/`.../Lorentz`, Tooby-Smith), built directly on the Mathlib declaration
`LieAlgebra.Orthogonal.indefiniteDiagonal`.  Mostly-minus signature `(+,-,-,-)`.

No PhysLean import is used: `indefiniteDiagonal` is a Mathlib declaration, so we ground
our hand-rolled `eta = diag(1,-1,-1,-1)` directly against it.
-/

namespace MinkowskiConvention

open Matrix

variable {R : Type*} [CommRing R]

/-- The Minkowski metric `eta = diag(1,-1,-1,-1)` in the mostly-minus convention. -/
def eta : Matrix (Fin 4) (Fin 4) R :=
  !![1, 0, 0, 0; 0, -1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

/-- `eta` written as an explicit `Matrix.diagonal`. -/
theorem eta_diagonal :
    (eta : Matrix (Fin 4) (Fin 4) R) = Matrix.diagonal ![1, -1, -1, -1] := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [eta, Matrix.diagonal]

/-- Provenance: our hand-rolled `eta` is the reindexing of Mathlib's
`LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin 3) R` under the standard
`Fin 1 ⊕ Fin 3 ≃ Fin 4` equivalence (`finSumFinEquiv`), i.e. PhysLean's
`minkowskiMatrix` convention. -/
theorem eta_eq_indefiniteDiagonal :
    (eta : Matrix (Fin 4) (Fin 4) R) =
      Matrix.reindex finSumFinEquiv finSumFinEquiv
        (LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin 3) R) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [eta, LieAlgebra.Orthogonal.indefiniteDiagonal, Matrix.reindex, Matrix.submatrix,
      Matrix.diagonal_apply, finSumFinEquiv, Fin.addCases]

/-- `eta` is symmetric. -/
theorem eta_symm : (eta : Matrix (Fin 4) (Fin 4) R).transpose = eta := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [eta]

/-- `eta` is involutive: `eta * eta = 1`. -/
theorem eta_mul_eta : (eta : Matrix (Fin 4) (Fin 4) R) * eta = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [eta, Matrix.mul_apply, Fin.sum_univ_four]

/-- The determinant of `eta` is `-1`. -/
theorem eta_det : (eta : Matrix (Fin 4) (Fin 4) R).det = -1 := by
  rw [eta_diagonal, Matrix.det_diagonal, Fin.prod_univ_four]; simp

/-- The trace of `eta` is `-2`. -/
theorem eta_trace : (eta : Matrix (Fin 4) (Fin 4) R).trace = -2 := by
  simp [eta, Matrix.trace, Matrix.diag, Fin.sum_univ_four]; ring

/-- Diagonal-entry match with the Mathlib `indefiniteDiagonal`. -/
theorem eta_diag_match :
    (eta 0 0 : R) = (LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin 3) R)
        (finSumFinEquiv.symm 0) (finSumFinEquiv.symm 0) ∧
    (eta 1 1 : R) = (LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin 3) R)
        (finSumFinEquiv.symm 1) (finSumFinEquiv.symm 1) := by
  constructor <;>
    simp [eta, LieAlgebra.Orthogonal.indefiniteDiagonal,
      finSumFinEquiv, Fin.addCases]

/-- The Minkowski inner product `⟨u, v⟩ = uᵀ η v`. -/
def mink (u v : Fin 4 → R) : R := u ⬝ᵥ (eta.mulVec v)

/-- Signature identity: `⟨u,u⟩ = u₀² - u₁² - u₂² - u₃²`. -/
theorem mink_self (u : Fin 4 → R) :
    mink u u = u 0 ^ 2 - u 1 ^ 2 - u 2 ^ 2 - u 3 ^ 2 := by
  simp [mink, eta, Matrix.mulVec, dotProduct, Fin.sum_univ_four]
  ring

/-- Bilinearity: additive in the first argument. -/
theorem mink_add_left (u₁ u₂ v : Fin 4 → R) :
    mink (u₁ + u₂) v = mink u₁ v + mink u₂ v := by
  simp [mink, add_dotProduct]

/-- Bilinearity: additive in the second argument. -/
theorem mink_add_right (u v₁ v₂ : Fin 4 → R) :
    mink u (v₁ + v₂) = mink u v₁ + mink u v₂ := by
  simp [mink, Matrix.mulVec_add, dotProduct_add]

/-- Bilinearity: homogeneous in the first argument. -/
theorem mink_smul_left (c : R) (u v : Fin 4 → R) :
    mink (c • u) v = c * mink u v := by
  simp [mink, smul_dotProduct, smul_eq_mul]

/-- Bilinearity: homogeneous in the second argument. -/
theorem mink_smul_right (c : R) (u v : Fin 4 → R) :
    mink u (c • v) = c * mink u v := by
  simp [mink, Matrix.mulVec_smul, dotProduct_smul, smul_eq_mul]

/-- Null-cone condition: `⟨u,u⟩ = 0 ↔ u₀² = u₁² + u₂² + u₃²`. -/
theorem null_iff (u : Fin 4 → R) :
    mink u u = 0 ↔ u 0 ^ 2 = u 1 ^ 2 + u 2 ^ 2 + u 3 ^ 2 := by
  rw [mink_self]; constructor <;> intro h <;> linear_combination h

/-- Null witness `u = (1,1,0,0)` lies on the null cone: `⟨u,u⟩ = 0`. -/
theorem mink_null_witness :
    mink (![1, 1, 0, 0] : Fin 4 → ℚ) ![1, 1, 0, 0] = 0 := by
  simp [mink_self]

/-- Timelike witness `u = (5,3,0,0)` has `⟨u,u⟩ = 16`. -/
theorem mink_timelike_witness :
    mink (![5, 3, 0, 0] : Fin 4 → ℚ) ![5, 3, 0, 0] = 16 := by
  simp [mink_self]; norm_num

/-- Convention note (provenance anchor): the mostly-minus signature `(+,-,-,-)`
matching PhysLean `minkowskiMatrix` and Mathlib `indefiniteDiagonal`:
`eta 0 0 = 1` and `eta 1 1 = -1`. -/
theorem convention_note : (eta 0 0 : ℚ) = 1 ∧ (eta 1 1 : ℚ) = -1 := by
  constructor <;> simp [eta]

end MinkowskiConvention

-- Axiom footprint checks (headline theorems).
/-- info: 'MinkowskiConvention.eta_eq_indefiniteDiagonal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MinkowskiConvention.eta_eq_indefiniteDiagonal
/-- info: 'MinkowskiConvention.eta_symm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MinkowskiConvention.eta_symm
/-- info: 'MinkowskiConvention.eta_mul_eta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MinkowskiConvention.eta_mul_eta
/-- info: 'MinkowskiConvention.eta_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MinkowskiConvention.eta_det
/-- info: 'MinkowskiConvention.eta_trace' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MinkowskiConvention.eta_trace
/-- info: 'MinkowskiConvention.eta_diag_match' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MinkowskiConvention.eta_diag_match
/-- info: 'MinkowskiConvention.mink_self' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MinkowskiConvention.mink_self
/-- info: 'MinkowskiConvention.null_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MinkowskiConvention.null_iff
/-- info: 'MinkowskiConvention.mink_null_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MinkowskiConvention.mink_null_witness
/-- info: 'MinkowskiConvention.mink_timelike_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MinkowskiConvention.mink_timelike_witness
/-- info: 'MinkowskiConvention.convention_note' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MinkowskiConvention.convention_note
