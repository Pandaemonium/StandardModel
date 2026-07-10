import PhysicsSM.Draft.NullEdge.SixFourRankObstruction

/-!
# Six direction channels as four candidate Dirac plus two auxiliary channels

The six-dimensional direction space is complex-linearly equivalent to a
four-dimensional candidate Dirac factor plus an exactly two-dimensional
auxiliary factor. This is the constructive complement to the no-go against a
direct six-to-four equivalence.

Dimension alone does not make the four-dimensional factor dynamically
invariant or identify the auxiliaries as gauge, constraint, heavy, or ancilla
modes. Those require a coin-intertwining and decoupling theorem.

Provenance: proof completed by Aristotle project
`96c2c965-563f-4615-b4e4-fe3611e598d5` after the D4 rank-obstruction audit.
-/

namespace PhysicsSM.Draft.NullEdge.SixFourAuxiliaryDecomposition

abbrev DirectionSpace := Fin 6 -> ℂ
abbrev DiracSpace := Fin 4 -> ℂ
abbrev AuxiliarySpace := Fin 2 -> ℂ

theorem direction_finrank : Module.finrank ℂ DirectionSpace = 6 := by
  simp [DirectionSpace]

theorem dirac_aux_finrank :
    Module.finrank ℂ (DiracSpace × AuxiliarySpace) = 6 := by
  simp [DiracSpace, AuxiliarySpace, Module.finrank_prod]

/-- The six direction channels can be organized as four candidate Dirac
channels plus exactly two auxiliary channels. -/
theorem four_plus_two_decomposition :
    Nonempty (DirectionSpace ≃ₗ[ℂ] (DiracSpace × AuxiliarySpace)) := by
  rw [FiniteDimensional.nonempty_linearEquiv_iff_finrank_eq]
  rw [direction_finrank, dirac_aux_finrank]

/-- The auxiliary factor is genuinely nonzero. -/
theorem auxiliary_rank_control :
    Module.finrank ℂ AuxiliarySpace = 2 ∧
      Module.finrank ℂ AuxiliarySpace ≠ 0 := by
  refine ⟨by simp [AuxiliarySpace], by simp [AuxiliarySpace]⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SixFourAuxiliaryDecomposition.four_plus_two_decomposition' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms four_plus_two_decomposition

/-- info: 'PhysicsSM.Draft.NullEdge.SixFourAuxiliaryDecomposition.auxiliary_rank_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms auxiliary_rank_control

end PhysicsSM.Draft.NullEdge.SixFourAuxiliaryDecomposition
