import Mathlib

namespace SixFour

abbrev DirectionSpace := Fin 6 -> ℂ
abbrev DiracSpace := Fin 4 -> ℂ

theorem direction_finrank : Module.finrank ℂ DirectionSpace = 6 := by
  sorry

theorem dirac_finrank : Module.finrank ℂ DiracSpace = 4 := by
  sorry

/-- Six independent direction channels cannot be identified with four Dirac
components by an invertible complex-linear change of basis. -/
theorem no_direct_six_to_four_equivalence :
    ¬ Nonempty (DirectionSpace ≃ₗ[ℂ] DiracSpace) := by
  sorry

/-- The obstruction is exactly two complex dimensions. -/
theorem exact_rank_gap :
    Module.finrank ℂ DirectionSpace =
      Module.finrank ℂ DiracSpace + 2 := by
  sorry

end SixFour
