import PhysicsSM.Draft.NullEdge.MC2BlockDiagonalLift

/-!
# Matrix exponential through the live two-plus-two block lift

This module supplies the exponential bookkeeping needed to lift exact
two-component HNU words into the fixed four-component Dirac basis.  It proves
that matrix exponentiation respects the live reindexed `2 + 2` block lift and
a fixed unitary change of basis.

Provenance: clean-room integration of Aristotle job
`da3d3a9a-d760-4161-8289-7a2820128e0e`, task
`a95ee78b-46b7-4aed-a6d3-9ae79b0df7f1`.  The result is generic finite matrix
analysis; it makes no HNU, continuum, or physical-sector claim.
-/

open Matrix
open scoped Matrix.Norms.L2Operator

noncomputable section

namespace MC2Exp

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex
abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

private def blockDiag (A B : M2) : M4 :=
  Matrix.reindex finSumFinEquiv finSumFinEquiv
    (Matrix.fromBlocks A 0 0 B)

private def fromBlocksDiagonalRingHom :
    M2 × M2 →+* Matrix (Fin 2 ⊕ Fin 2) (Fin 2 ⊕ Fin 2) Complex where
  toFun X := Matrix.fromBlocks X.1 0 0 X.2
  map_zero' := by
    ext i j
    fin_cases i <;> fin_cases j <;> simp +decide [Matrix.fromBlocks]
  map_one' := by
    convert Matrix.fromBlocks_one
  map_add' := by
    intro a b
    ext i j
    fin_cases i <;> fin_cases j <;> simp +decide
  map_mul' := by
    norm_num [← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply]

private theorem continuous_fromBlocksDiagonalRingHom :
    Continuous fromBlocksDiagonalRingHom := by
  convert continuous_pi fun i => continuous_pi fun j => ?_ using 1
  fin_cases i <;> fin_cases j <;>
    simp +decide [fromBlocksDiagonalRingHom] <;> fun_prop

private theorem exp_prod_matrices (A B : M2) :
    NormedSpace.exp (A, B) = (NormedSpace.exp A, NormedSpace.exp B) := by
  apply Prod.ext
  · simpa using ((NormedSpace.exp_series_hasSum_exp' (𝕂 := ℝ) (A, B)).map
      (ContinuousAddMonoidHom.fst M2 M2) continuous_fst).unique
      (NormedSpace.exp_series_hasSum_exp' (𝕂 := ℝ) A)
  · simpa using ((NormedSpace.exp_series_hasSum_exp' (𝕂 := ℝ) (A, B)).map
      (ContinuousAddMonoidHom.snd M2 M2) continuous_snd).unique
      (NormedSpace.exp_series_hasSum_exp' (𝕂 := ℝ) B)

private theorem exp_fromBlocks_diagonal (A B : M2) :
    NormedSpace.exp (Matrix.fromBlocks A 0 0 B) =
      Matrix.fromBlocks (NormedSpace.exp A) 0 0 (NormedSpace.exp B) := by
  have hExp := @NormedSpace.exp_series_hasSum_exp' ℝ
  refine HasSum.unique (hExp _) ?_
  convert HasSum.map (hExp (A, B)) fromBlocksDiagonalRingHom
      continuous_fromBlocksDiagonalRingHom using 1
  · ext n i j
    simp +decide [fromBlocksDiagonalRingHom]
    rw [show (Matrix.fromBlocks A 0 0 B ^ n :
        Matrix (Fin 2 ⊕ Fin 2) (Fin 2 ⊕ Fin 2) Complex) =
          Matrix.fromBlocks (A ^ n) 0 0 (B ^ n) by
      induction n <;> simp_all +decide [pow_succ, Matrix.fromBlocks_multiply]]
    fin_cases i <;> fin_cases j <;> simp +decide [Matrix.fromBlocks]
  · rw [exp_prod_matrices]
    rfl

private theorem continuous_reindexAlgEquiv :
    Continuous (Matrix.reindexAlgEquiv ℚ Complex finSumFinEquiv :
      Matrix (Fin 2 ⊕ Fin 2) (Fin 2 ⊕ Fin 2) Complex → M4) := by
  convert continuous_id.matrix_reindex finSumFinEquiv finSumFinEquiv

/-- Exponentiation respects the live reindexed block lift. -/
theorem exp_blockDiag (A B : M2) (eps : Real) :
    NormedSpace.exp (eps • blockDiag A B) =
      blockDiag (NormedSpace.exp (eps • A))
        (NormedSpace.exp (eps • B)) := by
  convert congr_arg _ (exp_fromBlocks_diagonal (eps • A) (eps • B)) using 1
  have hExp := @NormedSpace.exp_series_hasSum_exp' ℝ
  refine HasSum.unique (hExp _) ?_
  convert HasSum.map (hExp (eps • Matrix.fromBlocks A 0 0 B))
      (Matrix.reindexAlgEquiv ℚ Complex finSumFinEquiv)
      continuous_reindexAlgEquiv using 1
  · ext
    simp +decide [blockDiag]
    rename_i n i j
    induction' n with n ih generalizing i j <;>
      simp_all +decide [pow_succ, Matrix.mul_apply]
    · fin_cases i <;> fin_cases j <;> rfl
    · simp_all +decide [Fin.sum_univ_four, Nat.factorial_ne_zero]
      ring!
  · simp_all +decide [Matrix.reindex_apply, Matrix.fromBlocks_smul]

/-- Project-facing form of `exp_blockDiag` for the shared MC2 lift. -/
theorem exp_MC2_blockDiag (A B : M2) (eps : Real) :
    NormedSpace.exp (eps • MC2.blockDiag A B) =
      MC2.blockDiag (NormedSpace.exp (eps • A))
        (NormedSpace.exp (eps • B)) := by
  simpa only [blockDiag, MC2.blockDiag] using exp_blockDiag A B eps

/-- For a unitary matrix, conjugate transpose is its matrix inverse. -/
theorem unitary_inv_eq_conjTranspose (U : M4)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) Complex) :
    U⁻¹ = U.conjTranspose := by
  rw [Matrix.inv_eq_right_inv]
  exact hU.2

/-- Exponentiation commutes with a fixed unitary change of basis. -/
theorem exp_unitary_conjugation (U A : M4) (eps : Real)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) Complex) :
    NormedSpace.exp (eps • (U * A * U.conjTranspose)) =
      U * NormedSpace.exp (eps • A) * U.conjTranspose := by
  have hExp : NormedSpace.exp (eps • (U * A * Uᴴ)) =
      U * NormedSpace.exp (eps • A) * Uᴴ := by
    have hInv : U.conjTranspose = U⁻¹ := by
      exact (unitary_inv_eq_conjTranspose U hU).symm
    convert Matrix.exp_conj U (eps • A) using 1
    simp +decide [Matrix.isUnit_iff_isUnit_det, hInv]
    exact Or.inl (by
      intro h
      simpa [h] using congr_arg Matrix.det hU.2)
  exact hExp

/-- Combined block lift followed by a fixed unitary basis change. -/
theorem exp_conjugated_blockDiag (U : M4) (A B : M2) (eps : Real)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) Complex) :
    NormedSpace.exp
        (eps • (U * blockDiag A B * U.conjTranspose)) =
      U * blockDiag (NormedSpace.exp (eps • A))
        (NormedSpace.exp (eps • B)) * U.conjTranspose := by
  rw [exp_unitary_conjugation U (blockDiag A B) eps hU,
    exp_blockDiag]

end MC2Exp
