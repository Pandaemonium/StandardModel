import Mathlib

open Matrix Complex

namespace CliffordStep

abbrev Mat4 := Matrix (Fin 4) (Fin 4) ℂ

def step (a : ℝ) (H : Mat4) : Mat4 :=
  (a : ℂ) • (1 : Mat4) - I • H

def IsUnitary (U : Mat4) : Prop := Uᴴ * U = 1 ∧ U * Uᴴ = 1

/-- A Hermitian Clifford symbol with scalar square gives an exact unitary step
when the stay coefficient and symbol norm lie on the unit sphere. -/
theorem step_unitary (a q : ℝ) (H : Mat4)
    (hHermitian : Hᴴ = H)
    (hSq : H * H = (q : ℂ) • (1 : Mat4))
    (hnorm : a ^ 2 + q = 1) :
    IsUnitary (step a H) := by
  sorry

def alpha1 : Mat4 :=
  !![0, 0, 0, 1;
     0, 0, 1, 0;
     0, 1, 0, 0;
     1, 0, 0, 0]

def alpha2 : Mat4 :=
  !![0, 0, 0, -I;
     0, 0, I, 0;
     0, -I, 0, 0;
     I, 0, 0, 0]

def beta : Mat4 :=
  !![1, 0, 0, 0;
     0, 1, 0, 0;
     0, 0, -1, 0;
     0, 0, 0, -1]

noncomputable def witnessH : Mat4 :=
  ((1 / 2 : ℝ) : ℂ) • alpha1 + ((1 / 2 : ℝ) : ℂ) • alpha2 +
    ((1 / 2 : ℝ) : ℂ) • beta

theorem witnessH_hermitian : witnessHᴴ = witnessH := by
  sorry

theorem witnessH_sq :
    witnessH * witnessH = (((3 / 4 : ℝ) : ℂ) • (1 : Mat4)) := by
  sorry

/-- Massive rational control: three nonzero half-coefficients, including the
mass turn, give `q=3/4`; with `a=1/2` the exact step is unitary and nontrivial. -/
theorem massive_rational_unitary_witness :
    IsUnitary (step (1 / 2) witnessH) ∧
      step (1 / 2) witnessH ≠ 1 := by
  sorry

end CliffordStep
