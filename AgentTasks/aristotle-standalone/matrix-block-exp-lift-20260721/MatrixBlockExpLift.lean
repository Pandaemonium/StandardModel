import Mathlib

/-!
# Matrix exponential through the live two-plus-two block lift

This focused target isolates the bookkeeping lemmas blocking the polynomial
cost theorem for the massive HNU walk. It uses the same reindexed `2 + 2`
block diagonal construction as the live project and proves that matrix
exponentiation respects both that lift and conjugation by a unitary basis
change.

The target is generic finite matrix analysis. It does not mention HNU
eigenvalues, a continuum limit, or a physical-sector interpretation.
-/

open Matrix
open scoped Matrix.Norms.L2Operator

noncomputable section

namespace MatrixBlockExpLift

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex
abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

/-- The live `4 x 4` block diagonal convention. -/
def blockDiag (A B : M2) : M4 :=
  Matrix.reindex finSumFinEquiv finSumFinEquiv
    (Matrix.fromBlocks A 0 0 B)

/-- Exponentiation respects the live reindexed block lift. -/
theorem exp_blockDiag (A B : M2) (eps : Real) :
    NormedSpace.exp (eps • blockDiag A B) =
      blockDiag (NormedSpace.exp (eps • A))
        (NormedSpace.exp (eps • B)) := by
  sorry

/-- For a unitary matrix, conjugate transpose is its matrix inverse. -/
theorem unitary_inv_eq_conjTranspose (U : M4)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) Complex) :
    U⁻¹ = U.conjTranspose := by
  sorry

/-- Exponentiation commutes with a fixed unitary change of basis. -/
theorem exp_unitary_conjugation (U A : M4) (eps : Real)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) Complex) :
    NormedSpace.exp (eps • (U * A * U.conjTranspose)) =
      U * NormedSpace.exp (eps • A) * U.conjTranspose := by
  sorry

/-- Combined form needed for a Dirac-basis lift of paired chiral generators. -/
theorem exp_conjugated_blockDiag (U : M4) (A B : M2) (eps : Real)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) Complex) :
    NormedSpace.exp
        (eps • (U * blockDiag A B * U.conjTranspose)) =
      U * blockDiag (NormedSpace.exp (eps • A))
        (NormedSpace.exp (eps • B)) * U.conjTranspose := by
  sorry

end MatrixBlockExpLift
