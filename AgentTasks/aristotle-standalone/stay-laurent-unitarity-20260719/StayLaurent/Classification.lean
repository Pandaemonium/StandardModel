import Mathlib

/-!
# Exact classification target for a range-one stay/shift walk

For a translation-invariant one-axis walk

`U(z) = z Gplus + Gzero + z^-1 Gminus`,

the three matrices are respectively the forward, onsite, and backward
amplitudes.  This file asks for the exact coefficient conditions equivalent to
unitarity for every unit-circle phase.  The forward implication makes onsite
amplitude a derived algebraic resource rather than an ad hoc exception.  The
converse is the ambitious classification rung.

The target is finite matrix algebra over `Complex`.  It makes no continuum,
Lorentz, particle, or three-dimensional claim.
-/

open Matrix Complex

noncomputable section

namespace StayLaurent

variable {n : Type*} [Fintype n] [DecidableEq n]

abbrev Mat (n : Type*) := Matrix n n Complex

def IsUnitary (U : Mat n) : Prop :=
  U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1

def OnCircle (z : Complex) : Prop :=
  z ≠ 0 ∧ starRingEnd Complex z = z⁻¹

def symbol (Gplus Gzero Gminus : Mat n) (z : Complex) : Mat n :=
  z • Gplus + Gzero + z⁻¹ • Gminus

/-- The ten Laurent-coefficient identities obtained from `U^H U = 1` and
`U U^H = 1`.  The explicit positive and negative coefficients make this
certificate convenient for later local-QCA composition. -/
structure Certificate (Gplus Gzero Gminus : Mat n) : Prop where
  left_const :
    Gplus.conjTranspose * Gplus + Gzero.conjTranspose * Gzero +
      Gminus.conjTranspose * Gminus = 1
  left_plus_one :
    Gzero.conjTranspose * Gplus + Gminus.conjTranspose * Gzero = 0
  left_minus_one :
    Gplus.conjTranspose * Gzero + Gzero.conjTranspose * Gminus = 0
  left_plus_two : Gminus.conjTranspose * Gplus = 0
  left_minus_two : Gplus.conjTranspose * Gminus = 0
  right_const :
    Gplus * Gplus.conjTranspose + Gzero * Gzero.conjTranspose +
      Gminus * Gminus.conjTranspose = 1
  right_plus_one :
    Gplus * Gzero.conjTranspose + Gzero * Gminus.conjTranspose = 0
  right_minus_one :
    Gzero * Gplus.conjTranspose + Gminus * Gzero.conjTranspose = 0
  right_plus_two : Gplus * Gminus.conjTranspose = 0
  right_minus_two : Gminus * Gplus.conjTranspose = 0

/-- A coefficient certificate is sufficient for exact unitarity at every
unit-circle phase. -/
theorem unitary_of_certificate (Gplus Gzero Gminus : Mat n)
    (h : Certificate Gplus Gzero Gminus) :
    ∀ z, OnCircle z → IsUnitary (symbol Gplus Gzero Gminus z) := by
  sorry

/-- Ambitious converse: exact unitarity at every unit-circle phase determines
all Laurent coefficients.  Aristotle may introduce a roots-of-unity extraction
lemma, but must not add continuity or analyticity as an assumption. -/
theorem certificate_of_unitary_on_circle (Gplus Gzero Gminus : Mat n)
    (h : ∀ z, OnCircle z → IsUnitary (symbol Gplus Gzero Gminus z)) :
    Certificate Gplus Gzero Gminus := by
  sorry

/-- Classification capstone. -/
theorem certificate_iff_unitary_on_circle (Gplus Gzero Gminus : Mat n) :
    Certificate Gplus Gzero Gminus ↔
      ∀ z, OnCircle z → IsUnitary (symbol Gplus Gzero Gminus z) := by
  sorry

/-- If the onsite amplitude vanishes, the certificate forces the forward and
backward ranges to be orthogonal in both multiplication orders.  This is the
control showing exactly which constraint a genuine stay term relaxes. -/
theorem noStay_forces_shift_orthogonality
    (Gplus Gminus : Mat n) (h : Certificate Gplus 0 Gminus) :
    Gminus.conjTranspose * Gplus = 0 ∧
      Gplus.conjTranspose * Gminus = 0 ∧
      Gplus * Gminus.conjTranspose = 0 ∧
      Gminus * Gplus.conjTranspose = 0 := by
  sorry

end StayLaurent
