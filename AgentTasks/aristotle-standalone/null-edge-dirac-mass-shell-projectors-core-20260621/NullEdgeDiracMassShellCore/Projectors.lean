import Mathlib

/-!
# Chiral Dirac mass-shell projectors

Standalone finite algebra combining the chiral Dirac slash with the two-sheet
branch projector construction.
-/

noncomputable section

namespace NullEdgeDiracMassShellCore

open Matrix Complex

def minkowskiNorm (p : Fin 4 -> Complex) : Complex :=
  p 0 * p 0 - p 1 * p 1 - p 2 * p 2 - p 3 * p 3

def sigmaMomentum (p : Fin 4 -> Complex) : Matrix (Fin 2) (Fin 2) Complex :=
  fun a b =>
    if a = 0 /\ b = 0 then p 0 + p 3
    else if a = 0 /\ b = 1 then p 1 - Complex.I * p 2
    else if a = 1 /\ b = 0 then p 1 + Complex.I * p 2
    else p 0 - p 3

def barSigmaMomentum (p : Fin 4 -> Complex) : Matrix (Fin 2) (Fin 2) Complex :=
  fun a b =>
    if a = 0 /\ b = 0 then p 0 - p 3
    else if a = 0 /\ b = 1 then -p 1 + Complex.I * p 2
    else if a = 1 /\ b = 0 then -p 1 - Complex.I * p 2
    else p 0 + p 3

def chiralDiracSlash (p : Fin 4 -> Complex) :
    Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex :=
  fun a b =>
    match a, b with
    | Sum.inl _, Sum.inl _ => 0
    | Sum.inl i, Sum.inr j => sigmaMomentum p i j
    | Sum.inr i, Sum.inl j => barSigmaMomentum p i j
    | Sum.inr _, Sum.inr _ => 0

def plusProjector
    (D : Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex)
    (m : Complex) :
    Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex :=
  ((2 : Complex)⁻¹) •
    ((1 : Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex) +
      m⁻¹ • D)

def minusProjector
    (D : Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex)
    (m : Complex) :
    Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex :=
  ((2 : Complex)⁻¹) •
    ((1 : Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex) -
      m⁻¹ • D)

theorem chiralDiracSlash_sq_eq_norm (p : Fin 4 -> Complex) :
    chiralDiracSlash p * chiralDiracSlash p =
      minkowskiNorm p •
        (1 : Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex) := by
  sorry

theorem chiralDiracSlash_sq_eq_massSq_of_massShell
    (p : Fin 4 -> Complex) (m : Complex)
    (h : minkowskiNorm p = m * m) :
    chiralDiracSlash p * chiralDiracSlash p =
      (m * m) •
        (1 : Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex) := by
  sorry

theorem chiralPlusProjector_idempotent
    (p : Fin 4 -> Complex) (m : Complex) (hm : m != 0)
    (h : minkowskiNorm p = m * m) :
    plusProjector (chiralDiracSlash p) m *
      plusProjector (chiralDiracSlash p) m =
        plusProjector (chiralDiracSlash p) m := by
  sorry

theorem chiralMinusProjector_idempotent
    (p : Fin 4 -> Complex) (m : Complex) (hm : m != 0)
    (h : minkowskiNorm p = m * m) :
    minusProjector (chiralDiracSlash p) m *
      minusProjector (chiralDiracSlash p) m =
        minusProjector (chiralDiracSlash p) m := by
  sorry

theorem chiralProjectors_orthogonal
    (p : Fin 4 -> Complex) (m : Complex) (hm : m != 0)
    (h : minkowskiNorm p = m * m) :
    plusProjector (chiralDiracSlash p) m *
      minusProjector (chiralDiracSlash p) m = 0 := by
  sorry

theorem chiralDirac_acts_on_plusProjector
    (p : Fin 4 -> Complex) (m : Complex) (hm : m != 0)
    (h : minkowskiNorm p = m * m) :
    chiralDiracSlash p * plusProjector (chiralDiracSlash p) m =
      m • plusProjector (chiralDiracSlash p) m := by
  sorry

theorem chiralDirac_acts_on_minusProjector
    (p : Fin 4 -> Complex) (m : Complex) (hm : m != 0)
    (h : minkowskiNorm p = m * m) :
    chiralDiracSlash p * minusProjector (chiralDiracSlash p) m =
      (-m) • minusProjector (chiralDiracSlash p) m := by
  sorry

end NullEdgeDiracMassShellCore

end
