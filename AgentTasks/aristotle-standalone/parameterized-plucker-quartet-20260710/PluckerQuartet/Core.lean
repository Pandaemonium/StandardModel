import Mathlib

open Matrix Complex

namespace PluckerQuartet

abbrev Quartet := Fin 4 -> ℝ
abbrev Spinor := Fin 2 -> ℂ

def B (x y : Quartet) : ℝ :=
  x 0 * y 1 + x 1 * y 0 + x 2 * y 2 - x 3 * y 3

def Q (x : Quartet) : Quartet := ![x 1, 0, 0, 0]

noncomputable def SAt (m : ℝ) (x : Quartet) : Quartet :=
  ![0, 0, m ^ 2 * x 2, 0]

def e0q : Quartet := ![1, 0, 0, 0]
def e1q : Quartet := ![0, 1, 0, 0]
def e2q : Quartet := ![0, 0, 1, 0]
def e3q : Quartet := ![0, 0, 0, 1]

def edge0 : Spinor := ![1, 0]
noncomputable def edge1 (m : ℝ) : Spinor := ![0, (m : ℂ)]

def wedge (psi phi : Spinor) : ℂ :=
  psi 0 * phi 1 - psi 1 * phi 0

theorem B_left_nondegenerate :
    ∀ x : Quartet, (∀ y : Quartet, B x y = 0) -> x = 0 := by
  sorry

theorem Q_sq (x : Quartet) : Q (Q x) = 0 := by
  sorry

theorem exact_pairs_nonclosed :
    B e0q e1q = 1 ∧ Q e1q = e0q ∧ Q e0q = 0 := by
  sorry

theorem parameterized_decoder_pairing_formula (m : ℝ) (x : Quartet) :
    B x (SAt m x) = m ^ 2 * (x 2) ^ 2 := by
  sorry

/-- **Parameterized Pluecker quartet.** Every exact shift of the positive
physical representative has class cost equal to the canonical Pluecker mass,
with no separate `mu2=m^2` hypothesis. -/
theorem parameterized_class_cost_eq_plucker (m : ℝ) (chi : Quartet) :
    ((B (e2q + Q chi) (SAt m (e2q + Q chi)) : ℝ) : ℂ) =
      ((Complex.normSq (wedge edge0 (edge1 m)) : ℝ) : ℂ) := by
  sorry

theorem two_scale_nondegenerate_control :
    B e2q e2q = 1 ∧ B e3q e3q = -1 ∧ B e0q e1q = 1 ∧
      (∀ chi, B (e2q + Q chi) (SAt (2 / 5) (e2q + Q chi)) = 4 / 25) ∧
      (∀ chi, B (e2q + Q chi) (SAt (3 / 5) (e2q + Q chi)) = 9 / 25) ∧
      (4 / 25 : ℝ) ≠ 9 / 25 := by
  sorry

end PluckerQuartet
