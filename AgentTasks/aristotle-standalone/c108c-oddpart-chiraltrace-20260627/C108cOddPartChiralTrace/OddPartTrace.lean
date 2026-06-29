import Mathlib

/-!
# C108c odd-part chiral trace identity

This standalone Aristotle target is a quantitative complement to C108/C108b.

If `J` flips chirality, the chiral trace against `Gamma` only sees the
`J`-odd component of a finite matrix.  Applied to `P = p(B)`, this says the
origin chiral trace of a polynomial selector is entirely controlled by the
balance-odd part of that selector.

This is finite matrix algebra only. It does not construct a branch observable or
prove Gate C1 release.
-/

namespace C108cOddPartChiralTrace

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Finite chiral trace/index proxy used in the origin-fiber test. -/
noncomputable def ChiralTrace (Gamma P : Matrix n n Complex) : Complex :=
  trace (Gamma * P)

/-- The `J`-even part of a matrix. -/
noncomputable def EvenPart (J P : Matrix n n Complex) : Matrix n n Complex :=
  ((1 / 2 : Complex) • (P + J * P * J))

/-- The `J`-odd part of a matrix. -/
noncomputable def OddPart (J P : Matrix n n Complex) : Matrix n n Complex :=
  ((1 / 2 : Complex) • (P - J * P * J))

omit [DecidableEq n] in
/-- The even and odd parts add back to the original matrix. -/
theorem evenPart_add_oddPart
    (J P : Matrix n n Complex) :
    EvenPart J P + OddPart J P = P := by
  unfold EvenPart OddPart
  ext
  norm_num
  ring

/--
If `J` is an involution and anti-commutes with `Gamma`, then the even part has
zero chiral trace.
-/
theorem chiralTrace_evenPart_zero
    (Gamma J P : Matrix n n Complex)
    (hJ2 : J * J = 1)
    (hAnti : J * Gamma = -(Gamma * J)) :
    ChiralTrace Gamma (EvenPart J P) = 0 := by
  unfold ChiralTrace EvenPart
  norm_num [mul_add, add_mul, ← mul_assoc, hJ2, hAnti]
  simp +decide [← mul_assoc, ← Matrix.trace_mul_comm J, hAnti]
  simp +decide [mul_assoc, hJ2]

/--
The chiral trace of any finite matrix equals the chiral trace of its `J`-odd
part.
-/
theorem chiralTrace_eq_chiralTrace_oddPart
    (Gamma J P : Matrix n n Complex)
    (hJ2 : J * J = 1)
    (hAnti : J * Gamma = -(Gamma * J)) :
    ChiralTrace Gamma P = ChiralTrace Gamma (OddPart J P) := by
  convert congr_arg₂ (· + ·) rfl
    (chiralTrace_evenPart_zero Gamma J P hJ2 hAnti) using 1
  rotate_right
  exact ChiralTrace Gamma P - ChiralTrace Gamma (EvenPart J P)
  · ring
  · unfold ChiralTrace OddPart EvenPart
    simp +decide [mul_add, mul_assoc]
    simp +decide [mul_sub]
    ring

/--
Polynomial-selector version: the chiral trace of `p(B)` is controlled by the
`J`-odd part of `p(B)`.
-/
theorem chiralTrace_polynomial_aeval_eq_chiralTrace_oddPart
    (Gamma J B : Matrix n n Complex) (p : Polynomial Complex)
    (hJ2 : J * J = 1)
    (hAnti : J * Gamma = -(Gamma * J)) :
    ChiralTrace Gamma (Polynomial.aeval B p) =
      ChiralTrace Gamma (OddPart J (Polynomial.aeval B p)) :=
  chiralTrace_eq_chiralTrace_oddPart Gamma J (Polynomial.aeval B p) hJ2 hAnti

end C108cOddPartChiralTrace
