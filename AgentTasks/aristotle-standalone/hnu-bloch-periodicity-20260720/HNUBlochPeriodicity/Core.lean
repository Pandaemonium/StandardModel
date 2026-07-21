import Mathlib

/-!
# Bloch-character periodicity and the discrete-time homotopy obstruction

This standalone target isolates a precise reason that a local lattice
translation cannot generally be contracted to the identity by replacing its
integer displacement with a fractional displacement.  The interpolation is
continuous as a function on the covering momentum line, but at intermediate
times it is not a well-defined function on the Brillouin circle.

The target is deliberately scalar before it is applied to conditioned HNU
shifts.  It uses the convention

`character s k = exp (-i s k)`.

The requested classification is exact: this character is `2*pi` periodic if
and only if `s` is an integer.  The half-character is antiperiodic, and two
half-characters compose to the ordinary unit translation character.
-/

open Complex

namespace HNUBlochPeriodicity

noncomputable section

/-- Bloch character of a displacement `s` on the covering momentum line. -/
def character (s k : Real) : Complex :=
  Complex.exp (-(Complex.I * (s * k)))

/-- The character descends to the Brillouin circle exactly when this holds. -/
def DescendsToCircle (s : Real) : Prop :=
  Function.Periodic (character s) (2 * Real.pi)

/-- Exact shift law before imposing periodicity. -/
theorem character_add_two_pi (s k : Real) :
    character s (k + 2 * Real.pi) =
      character s k * character s (2 * Real.pi) := by
  sorry

/-- Integer displacements define honest characters of the Brillouin circle. -/
theorem integer_character_descends (n : Int) :
    DescendsToCircle (n : Real) := by
  sorry

/--
**Classification theorem.** A real displacement character is `2*pi`
periodic if and only if its displacement is integral.
-/
theorem character_descends_iff_integer (s : Real) :
    DescendsToCircle s <-> exists n : Int, s = n := by
  sorry

/-- The half-translation character changes sign under one reciprocal period. -/
theorem half_character_antiperiodic (k : Real) :
    character (1 / 2) (k + 2 * Real.pi) = -character (1 / 2) k := by
  sorry

/-- A half translation does not descend to the Brillouin circle. -/
theorem half_character_does_not_descend :
    Not (DescendsToCircle (1 / 2)) := by
  sorry

/-- Two half-translation phases compose to one full translation phase. -/
theorem paired_half_characters (k : Real) :
    character (1 / 2) k * character (1 / 2) k = character 1 k := by
  sorry

/-- The paired endpoint is periodic even though either half factor is not. -/
theorem paired_half_endpoint_descends :
    Function.Periodic
      (fun k => character (1 / 2) k * character (1 / 2) k)
      (2 * Real.pi) := by
  sorry

/-- No strictly intermediate linear displacement interpolation is periodic. -/
theorem no_fractional_linear_homotopy
    {t : Real} (ht0 : 0 < t) (ht1 : t < 1) :
    Not (DescendsToCircle t) := by
  sorry

/-! ## Explicit conditioned-shift control -/

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

/-- The nonzero rank-one projector selecting the first internal component. -/
def selected : M2 := !![1, 0; 0, 0]

/-- A selected component moves while its complement stays. -/
def conditionedSymbol (s k : Real) : M2 :=
  character s k • selected + (1 - selected)

/-- The conditioned half-shift is not a periodic Bloch symbol. -/
theorem conditioned_half_shift_does_not_descend :
    Not (Function.Periodic (conditionedSymbol (1 / 2)) (2 * Real.pi)) := by
  sorry

/-- At integral displacement the same conditioned shift is periodic. -/
theorem conditioned_integer_shift_descends (n : Int) :
    Function.Periodic (conditionedSymbol (n : Real)) (2 * Real.pi) := by
  sorry

end

end HNUBlochPeriodicity
