import Mathlib

open Matrix Complex
open scoped ComplexOrder

namespace SU2Spin

abbrev Spinor := Fin 2 -> ℂ
abbrev Mat2 := Matrix (Fin 2) (Fin 2) ℂ

def IsSU2 (U : Mat2) : Prop := Uᴴ * U = 1 ∧ U.det = 1

noncomputable def spinAction (U : Mat2) (psi : Spinor) : Spinor := U *ᵥ psi

noncomputable def spinInner (psi phi : Spinor) : ℂ := dotProduct (star psi) phi

theorem isSU2_one : IsSU2 (1 : Mat2) := by
  sorry

theorem isSU2_mul {U V : Mat2} (hU : IsSU2 U) (hV : IsSU2 V) :
    IsSU2 (U * V) := by
  sorry

/-- Matrix multiplication gives the defining two-dimensional representation. -/
theorem spinAction_mul (U V : Mat2) (psi : Spinor) :
    spinAction (U * V) psi = spinAction U (spinAction V psi) := by
  sorry

/-- The defining spin-half action preserves the Hermitian inner product. -/
theorem spinInner_preserved {U : Mat2} (hU : IsSU2 U) (psi phi : Spinor) :
    spinInner (spinAction U psi) (spinAction U phi) = spinInner psi phi := by
  sorry

def quarterTurn : Mat2 := !![0, 1; -1, 0]
def up : Spinor := ![1, 0]

/-- Nontrivial spin-half control: the SU(2) quarter-turn is unitary with
determinant one, acts nontrivially, squares to minus identity, and only its
fourth power returns to identity. -/
theorem spin_half_quarter_turn_witness :
    IsSU2 quarterTurn ∧ spinAction quarterTurn up ≠ up ∧
      quarterTurn ^ 2 = -(1 : Mat2) ∧ quarterTurn ^ 4 = 1 := by
  sorry

end SU2Spin
