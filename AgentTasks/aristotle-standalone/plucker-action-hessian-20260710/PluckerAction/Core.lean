import Mathlib

open Matrix Complex

namespace PluckerAction

abbrev Spinor := Fin 2 -> ℂ
abbrev Quartet := Fin 4 -> ℝ

def wedge (psi phi : Spinor) : ℂ :=
  psi 0 * phi 1 - psi 1 * phi 0

def massSq (psi phi : Spinor) : ℝ :=
  Complex.normSq (wedge psi phi)

/-- Finite action whose curvature in the positive quartet direction is the
Pluecker disagreement of the supplied null spinors. -/
noncomputable def action (psi phi : Spinor) (x : Quartet) : ℝ :=
  (1 / 2 : ℝ) * massSq psi phi * (x 2) ^ 2

def eom (psi phi : Spinor) (x : Quartet) : ℝ :=
  massSq psi phi * x 2

def e2 : Quartet := ![0, 0, 1, 0]

theorem action_nonnegative (psi phi : Spinor) (x : Quartet) :
    0 ≤ action psi phi x := by
  sorry

/-- Exact finite Taylor formula: the linear coefficient is the EOM and the
quadratic coefficient is the Pluecker Hessian. -/
theorem action_exact_taylor (psi phi : Spinor)
    (x v : Quartet) (t : ℝ) :
    action psi phi (x + t • v) =
      action psi phi x +
        t * eom psi phi x * v 2 +
        (1 / 2 : ℝ) * t ^ 2 * massSq psi phi * (v 2) ^ 2 := by
  sorry

/-- The positive-direction second difference is exactly the Pluecker mass. -/
theorem action_e2_hessian (psi phi : Spinor) (x : Quartet) :
    action psi phi (x + e2) + action psi phi (x - e2) -
      2 * action psi phi x = massSq psi phi := by
  sorry

/-- For noncollinear spinors, the EOM selects precisely the zero positive
coordinate; for collinear spinors the action is flat. -/
theorem eom_zero_iff (psi phi : Spinor)
    (hnonzero : massSq psi phi ≠ 0) (x : Quartet) :
    eom psi phi x = 0 ↔ x 2 = 0 := by
  sorry

def canonical0 : Spinor := ![1, 0]
noncomputable def canonical1 (m : ℝ) : Spinor := ![0, (m : ℂ)]
def collinear : Spinor := ![(3 : ℂ), 0]

theorem action_hessian_controls :
    (∀ x : Quartet,
        action canonical0 (canonical1 (2 / 5)) (x + e2) +
          action canonical0 (canonical1 (2 / 5)) (x - e2) -
          2 * action canonical0 (canonical1 (2 / 5)) x = 4 / 25) ∧
      (∀ x : Quartet,
        action canonical0 (canonical1 (3 / 5)) (x + e2) +
          action canonical0 (canonical1 (3 / 5)) (x - e2) -
          2 * action canonical0 (canonical1 (3 / 5)) x = 9 / 25) ∧
      (∀ x : Quartet, action canonical0 collinear x = 0) := by
  sorry

end PluckerAction
