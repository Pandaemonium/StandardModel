import Mathlib

open Matrix Complex

namespace GeneralGramTurn

abbrev CSpinor := Fin 2 → ℂ
abbrev CM2 := Matrix (Fin 2) (Fin 2) ℂ
abbrev RM2 := Matrix (Fin 2) (Fin 2) ℝ

def wedge (psi phi : CSpinor) : ℂ :=
  psi 0 * phi 1 - psi 1 * phi 0

def rankOne (psi : CSpinor) : CM2 := Matrix.vecMulVec psi (star psi)

def momentum (psi phi : CSpinor) : CM2 := rankOne psi + rankOne phi

def complexify (A : RM2) : CM2 := fun i j => (A i j : ℂ)

def turnChannel (m : ℝ) : RM2 := (m ^ 2) • (1 : RM2)

noncomputable def turnScale (psi phi : CSpinor) : ℝ :=
  Real.sqrt (Complex.normSq (wedge psi phi))

theorem normSq_wedge_nonneg (psi phi : CSpinor) :
    0 ≤ Complex.normSq (wedge psi phi) := by
  sorry

theorem turnScale_sq (psi phi : CSpinor) :
    turnScale psi phi ^ 2 = Complex.normSq (wedge psi phi) := by
  sorry

theorem momentum_det_eq_normSq_wedge (psi phi : CSpinor) :
    (momentum psi phi).det = ((Complex.normSq (wedge psi phi) : ℝ) : ℂ) := by
  sorry

/-- **General Gram-to-turn scale theorem.** For every pair of complex null
spinors, the free mass operator is the complexified turn channel at the
nonnegative scale derived from their Pluecker disagreement. -/
theorem free_mass_operator_eq_derived_turn (psi phi : CSpinor) :
    momentum psi phi * (momentum psi phi).adjugate =
      complexify (turnChannel (turnScale psi phi)) := by
  sorry

def e0 : CSpinor := ![(1 : ℂ), 0]
noncomputable def e1scaled : CSpinor := ![0, ((2 / 5 : ℝ) : ℂ)]
def ecollinear : CSpinor := ![(3 : ℂ), 0]

theorem derived_scale_controls :
    turnScale e0 e1scaled = 2 / 5 ∧
      turnScale e0 ecollinear = 0 ∧
      momentum e0 e1scaled * (momentum e0 e1scaled).adjugate ≠ 0 := by
  sorry

end GeneralGramTurn
