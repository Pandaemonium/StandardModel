import Mathlib

/-!
# C107b polynomial projector idempotence

This standalone Aristotle target is the immediate finite-algebra successor to
C107.

C107 proved that polynomial evaluation by `Polynomial.aeval` is compatible with
matrix conjugation by an inverse pair. Before claiming a physical or spectral
projector, we need the finite algebra fact that a polynomial which is
idempotent on a matrix under `aeval` produces an idempotent matrix.

This file does not construct a branch observable, does not prove gauge
covariance, and does not claim a physical C1 release.
-/

namespace C107bPolynomialProjector

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/--
If `p * p - p` evaluates to zero at `B`, then `p(B)` is an idempotent matrix.

This is the finite algebra form of the spectral-island condition:
`p` is equal to `0` or `1` on the finite spectral data seen by `B`.
-/
theorem polynomial_projector_idempotent
    (B : Matrix n n Complex) (p : Polynomial Complex)
    (h : Polynomial.aeval B (p * p - p) = 0) :
    (Polynomial.aeval B p) * (Polynomial.aeval B p) = Polynomial.aeval B p := by
  rw [map_sub, map_mul] at h
  exact sub_eq_zero.mp h

/--
Variant with the polynomial relation written as equality of evaluations.
-/
theorem polynomial_projector_idempotent_of_aeval_mul_eq
    (B : Matrix n n Complex) (p : Polynomial Complex)
    (h : Polynomial.aeval B (p * p) = Polynomial.aeval B p) :
    (Polynomial.aeval B p) * (Polynomial.aeval B p) = Polynomial.aeval B p := by
  rw [map_mul] at h
  exact h

end C107bPolynomialProjector
