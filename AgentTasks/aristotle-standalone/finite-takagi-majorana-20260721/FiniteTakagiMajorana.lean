import Mathlib

/-!
# Finite Autonne-Takagi target

The theorem deliberately includes zero and repeated singular values.  Do not
replace unitary congruence by ordinary similarity diagonalization.
-/

open scoped Matrix ComplexConjugate

set_option autoImplicit false
set_option maxHeartbeats 8000000
set_option maxRecDepth 8000

namespace FiniteTakagiMajorana

/-- Every finite complex symmetric matrix admits an Autonne-Takagi
factorization with a nonnegative real diagonal. -/
theorem exists_autonneTakagi (n : Nat) (A : Matrix (Fin n) (Fin n) Complex)
    (hA : A.transpose = A) :
    ∃ (U : Matrix.unitaryGroup (Fin n) Complex) (sigma : Fin n → Real),
      (∀ i, 0 ≤ sigma i) ∧
        A = U.1 * Matrix.diagonal (fun i => (sigma i : Complex)) * U.1.transpose := by
  sorry

/-- A factorization witness determines `Aᴴ A` by the same nonnegative diagonal.
This companion target should be proved from the displayed factorization and
unitarity, without assuming a simple spectrum. -/
theorem takagi_squared_mass_identity (n : Nat)
    (A U : Matrix (Fin n) (Fin n) Complex) (sigma : Fin n → Real)
    (hU : U ∈ Matrix.unitaryGroup (Fin n) Complex)
    (hA : A = U * Matrix.diagonal (fun i => (sigma i : Complex)) * U.transpose) :
    Aᴴ * A =
      star U * Matrix.diagonal (fun i => ((sigma i) ^ 2 : Complex)) * U.transpose := by
  sorry

end FiniteTakagiMajorana
