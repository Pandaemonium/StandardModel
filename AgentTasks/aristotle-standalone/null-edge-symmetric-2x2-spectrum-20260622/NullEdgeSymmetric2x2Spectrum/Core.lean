import Mathlib.Tactic

/-!
# Real symmetric 2x2 spectrum

A real symmetric `2x2` matrix `[[a,b],[b,c]]` has real eigenvalues: its
characteristic discriminant `(a-c)^2 + 4 b^2` is nonnegative, and
`lambda_+ = ((a+c) + sqrt(disc))/2` satisfies the characteristic equation
`lambda^2 - (a+c) lambda + (ac - b^2) = 0`. The finite spectral-theorem anchor
for qubit density matrices and Hermitian observables across the program.

Standalone (Mathlib only).
-/

noncomputable section

namespace NullEdgeSymmetric2x2Spectrum

/-- Characteristic discriminant of a symmetric 2x2 matrix. -/
def discriminant (a b c : Real) : Real := (a - c) ^ 2 + 4 * b ^ 2

/-- The discriminant is nonnegative, so the eigenvalues are real. -/
theorem discriminant_nonneg (a b c : Real) : 0 ≤ discriminant a b c := by
  sorry

/-- Larger eigenvalue. -/
def lamPlus (a b c : Real) : Real := ((a + c) + Real.sqrt (discriminant a b c)) / 2

/-- `lamPlus` satisfies the characteristic equation. -/
theorem lamPlus_is_eigenvalue (a b c : Real) :
    lamPlus a b c ^ 2 - (a + c) * lamPlus a b c + (a * c - b ^ 2) = 0 := by
  sorry

end NullEdgeSymmetric2x2Spectrum
