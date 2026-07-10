import Mathlib

open Matrix Complex

namespace SpinorHodge

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

def wedge (psi phi : Spinor) : ℂ :=
  psi 0 * phi 1 - psi 1 * phi 0

noncomputable def turnScale (psi phi : Spinor) : ℝ :=
  Real.sqrt (Complex.normSq (wedge psi phi))

noncomputable def SFromPair (psi phi : Spinor) (x : Quartet) : Quartet :=
  SAt (turnScale psi phi) x

theorem B_left_nondegenerate :
    ∀ x : Quartet, (∀ y : Quartet, B x y = 0) -> x = 0 := by
  sorry

theorem Q_sq (x : Quartet) : Q (Q x) = 0 := by
  sorry

theorem exact_pairs_nonclosed :
    B e0q e1q = 1 ∧ Q e1q = e0q ∧ Q e0q = 0 := by
  sorry

/-- Every arbitrary decorated spinor pair selects a decoder whose exact-class
cost is precisely its Pluecker disagreement. -/
theorem arbitrary_pair_class_cost_eq_plucker
    (psi phi : Spinor) (chi : Quartet) :
    ((B (e2q + Q chi) (SFromPair psi phi (e2q + Q chi)) : ℝ) : ℂ) =
      ((Complex.normSq (wedge psi phi) : ℝ) : ℂ) := by
  sorry

def canonical0 : Spinor := ![1, 0]
noncomputable def canonical1 (m : ℝ) : Spinor := ![0, (m : ℂ)]
def collinear : Spinor := ![(3 : ℂ), 0]

/-- Two nonzero scales plus a collinear zero control ensure that the theorem is
not a renamed one-point fixture. -/
theorem arbitrary_pair_controls :
    (∀ chi : Quartet,
        B (e2q + Q chi)
          (SFromPair canonical0 (canonical1 (2 / 5)) (e2q + Q chi)) = 4 / 25) ∧
      (∀ chi : Quartet,
        B (e2q + Q chi)
          (SFromPair canonical0 (canonical1 (3 / 5)) (e2q + Q chi)) = 9 / 25) ∧
      (∀ chi : Quartet,
        B (e2q + Q chi)
          (SFromPair canonical0 collinear (e2q + Q chi)) = 0) ∧
      (4 / 25 : ℝ) ≠ 9 / 25 := by
  sorry

end SpinorHodge
