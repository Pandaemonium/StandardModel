import Mathlib

open Matrix Complex

namespace PluckerOscillator

abbrev Spinor := Fin 2 -> ℂ
abbrev State := ℝ × ℝ

def wedge (psi phi : Spinor) : ℂ :=
  psi 0 * phi 1 - psi 1 * phi 0

def massSq (psi phi : Spinor) : ℝ :=
  Complex.normSq (wedge psi phi)

def energy (m : ℝ) (x : State) : ℝ :=
  x.2 ^ 2 + m ^ 2 * x.1 ^ 2

/-- Exact oscillator rotation in `(q,p)` coordinates. -/
noncomputable def step (m c s : ℝ) (x : State) : State :=
  (c * x.1 + s / m * x.2, -m * s * x.1 + c * x.2)

/-- The displayed finite EOM step preserves oscillator energy exactly. -/
theorem energy_conserved (m c s : ℝ) (hm : m ≠ 0)
    (hcs : c ^ 2 + s ^ 2 = 1) (x : State) :
    energy m (step m c s x) = energy m x := by
  sorry

/-- If the oscillator frequency is the supplied spinor pair's Pluecker scale,
the conserved potential coefficient is exactly its mass invariant. -/
theorem conserved_plucker_energy (psi phi : Spinor) (m c s : ℝ)
    (hm : m ≠ 0) (hms : m ^ 2 = massSq psi phi)
    (hcs : c ^ 2 + s ^ 2 = 1) (x : State) :
    energy m (step m c s x) = energy m x ∧
      m ^ 2 = Complex.normSq (wedge psi phi) := by
  sorry

def canonical0 : Spinor := ![1, 0]
noncomputable def canonical1 : Spinor := ![0, ((2 / 5 : ℝ) : ℂ)]

theorem rational_massive_conservation_control :
    energy (2 / 5) (step (2 / 5) (3 / 5) (4 / 5)
      ((1, 2) : State)) = energy (2 / 5) ((1, 2) : State) ∧
      (2 / 5 : ℝ) ^ 2 = massSq canonical0 canonical1 := by
  sorry

end PluckerOscillator
