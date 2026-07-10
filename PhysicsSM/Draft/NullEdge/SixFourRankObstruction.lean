import Mathlib

/-!
# Six D4 direction channels are not four Dirac components

The full complex space of six axial direction channels has rank six, while a
Dirac spinor has rank four. Therefore no invertible complex-linear map directly
identifies the two spaces; the rank gap is exactly two.

This does not rule out a four-dimensional invariant subspace, two auxiliary or
gauge channels, a partial isometry, or a successive-axis construction. It is the
required no-go against silently identifying the full spaces.

Provenance: proof completed by Aristotle project
`c02c2e61-2300-4dae-a072-98db92940a67` after the 2026-07-10 D4-walk audit.
-/

namespace PhysicsSM.Draft.NullEdge.SixFourRankObstruction

abbrev DirectionSpace := Fin 6 -> ℂ
abbrev DiracSpace := Fin 4 -> ℂ

theorem direction_finrank : Module.finrank ℂ DirectionSpace = 6 := by
  simp

theorem dirac_finrank : Module.finrank ℂ DiracSpace = 4 := by
  simp

/-- Six independent direction channels cannot be identified with four Dirac
components by an invertible complex-linear change of basis. -/
theorem no_direct_six_to_four_equivalence :
    ¬ Nonempty (DirectionSpace ≃ₗ[ℂ] DiracSpace) := by
  rintro ⟨e⟩
  have h := LinearEquiv.finrank_eq e
  rw [direction_finrank, dirac_finrank] at h
  exact absurd h (by norm_num)

/-- The obstruction is exactly two complex dimensions. -/
theorem exact_rank_gap :
    Module.finrank ℂ DirectionSpace =
      Module.finrank ℂ DiracSpace + 2 := by
  rw [direction_finrank, dirac_finrank]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SixFourRankObstruction.no_direct_six_to_four_equivalence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_direct_six_to_four_equivalence

/-- info: 'PhysicsSM.Draft.NullEdge.SixFourRankObstruction.exact_rank_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exact_rank_gap

end PhysicsSM.Draft.NullEdge.SixFourRankObstruction
