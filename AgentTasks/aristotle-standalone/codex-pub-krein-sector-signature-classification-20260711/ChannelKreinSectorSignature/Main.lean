import Mathlib

/-!
# Exact normal form and signature coordinates for the live even Krein sector

Focused Paper F target. The theorem classifies every chirality-even,
Krein-self-adjoint `4 x 4` rational matrix and computes the adjoint-induced
quadratic form in exact coordinates.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace ChannelKreinSectorSignature

abbrev N := Matrix (Fin 4) (Fin 4) ℚ

def eta : N := !![1,0,0,0; 0,-1,0,0; 0,0,1,0; 0,0,0,-1]

def Gam : N := !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]

def kadj (A : N) : N := eta * A.transpose * eta

def kreinGram (A B : N) : ℚ := Matrix.trace (kadj A * B)

def normalForm (a d e g b f : ℚ) : N :=
  !![a,b,0,0; -b,d,0,0; 0,0,e,f; 0,0,-f,g]

theorem normalForm_selfadjoint (a d e g b f : ℚ) :
    kadj (normalForm a d e g b f) = normalForm a d e g b f := by
  sorry

theorem normalForm_even (a d e g b f : ℚ) :
    Gam * normalForm a d e g b f = normalForm a d e g b f * Gam := by
  sorry

/-- Every even Krein-self-adjoint represented matrix has the six-coordinate
normal form, so the displayed coordinates are exhaustive rather than a family
of examples. -/
theorem even_selfadjoint_exists_normalForm (X : N)
    (hself : kadj X = X) (heven : Gam * X = X * Gam) :
    ∃ a d e g b f : ℚ, X = normalForm a d e g b f := by
  sorry

theorem normalForm_coordinates_unique
    {a d e g b f a' d' e' g' b' f' : ℚ}
    (h : normalForm a d e g b f = normalForm a' d' e' g' b' f') :
    a = a' ∧ d = d' ∧ e = e' ∧ g = g' ∧ b = b' ∧ f = f' := by
  sorry

/-- Exact diagonalization of the adjoint-induced quadratic form into four
positive and two negative rational squares. -/
theorem normalForm_gram (a d e g b f : ℚ) :
    kreinGram (normalForm a d e g b f) (normalForm a d e g b f)
      = a ^ 2 + d ^ 2 + e ^ 2 + g ^ 2 - 2 * b ^ 2 - 2 * f ^ 2 := by
  sorry

theorem diagonal_sector_nonnegative (a d e g : ℚ) :
    0 ≤ kreinGram (normalForm a d e g 0 0) (normalForm a d e g 0 0) := by
  sorry

theorem diagonal_sector_zero_iff (a d e g : ℚ) :
    kreinGram (normalForm a d e g 0 0) (normalForm a d e g 0 0) = 0
      ↔ a = 0 ∧ d = 0 ∧ e = 0 ∧ g = 0 := by
  sorry

theorem negative_plane_gram (b f : ℚ) :
    kreinGram (normalForm 0 0 0 0 b f) (normalForm 0 0 0 0 b f)
      = -2 * (b ^ 2 + f ^ 2) := by
  sorry

theorem negative_plane_strict {b f : ℚ} (h : b ≠ 0 ∨ f ≠ 0) :
    kreinGram (normalForm 0 0 0 0 b f) (normalForm 0 0 0 0 b f) < 0 := by
  sorry

end ChannelKreinSectorSignature
