import Mathlib

/-!
# Chirality-even and chirality-odd coefficient projections

This focused draft isolates the exact coefficient algebra behind the claim that
a correct Dirac first jet has no chirality-odd constant or linear term. It does
not infer a global no-doubling theorem; that implication requires a separately
verified total-charge theorem.
-/

namespace ChiralityMixingNecessity

abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

noncomputable def parallelPart (Xi U : M4) : M4 :=
  (2 : Complex)⁻¹ • (U + Xi * U * Xi)

noncomputable def perpPart (Xi U : M4) : M4 :=
  (2 : Complex)⁻¹ • (U - Xi * U * Xi)

/-- The even and odd projections reconstruct the original coefficient. -/
theorem parallelPart_add_perpPart (Xi U : M4) :
    parallelPart Xi U + perpPart Xi U = U := by
  sorry

/-- The parallel projection commutes with an involutory chirality. -/
theorem Xi_mul_parallelPart_eq
    (Xi U : M4) (hXi : Xi * Xi = 1) :
    Xi * parallelPart Xi U = parallelPart Xi U * Xi := by
  sorry

/-- The perpendicular projection anticommutes with an involutory chirality. -/
theorem Xi_mul_perpPart_eq_neg
    (Xi U : M4) (hXi : Xi * Xi = 1) :
    Xi * perpPart Xi U = -(perpPart Xi U * Xi) := by
  sorry

/-- A coefficient commuting with chirality has zero odd projection. -/
theorem perpPart_eq_zero_of_commutes
    (Xi U : M4) (hXi : Xi * Xi = 1)
    (hcomm : Xi * U = U * Xi) :
    perpPart Xi U = 0 := by
  sorry

/-- The normalized constant coefficient contributes no chirality mixing. -/
theorem perpPart_one_eq_zero (Xi : M4) (hXi : Xi * Xi = 1) :
    perpPart Xi 1 = 0 := by
  sorry

/-- If all three Dirac tangent coefficients commute with chirality, their
chirality-odd first jet vanishes coefficient by coefficient. -/
theorem diracFirstJet_perp_eq_zero
    (Xi A1 A2 A3 : M4) (hXi : Xi * Xi = 1)
    (h1 : Xi * A1 = A1 * Xi)
    (h2 : Xi * A2 = A2 * Xi)
    (h3 : Xi * A3 = A3 * Xi) :
    perpPart Xi A1 = 0 ∧ perpPart Xi A2 = 0 ∧ perpPart Xi A3 = 0 := by
  sorry

/-- Nonvacuity fixture: an involutory chirality has a genuinely nonzero odd
coefficient. -/
theorem exists_nonzero_perpPart :
    Exists fun Xi : M4 => Exists fun G : M4 =>
      Xi * Xi = 1 ∧ perpPart Xi G ≠ 0 := by
  sorry

end ChiralityMixingNecessity
