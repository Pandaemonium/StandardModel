import Mathlib

/-!
# C107c polynomial projector covariance assembly

This standalone Aristotle target fuses the two finite algebra seeds:

* C107: polynomial evaluation is compatible with inverse-pair conjugation.
* C107b: if `p` is idempotent on `B` under `Polynomial.aeval`, then `p(B)` is
  an idempotent matrix.

The result is still purely finite algebra. It does not construct a physical
branch observable, prove a spectral-island theorem, or claim Gate C1 release.
-/

namespace C107cPolynomialProjector

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/--
Finite polynomial-projector covariance assembly.

If `B' = S * B * T` with `S*T = 1` and `T*S = 1`, and if `p` is idempotent on
`B` under polynomial evaluation, then:

1. the conjugated polynomial projector `S * p(B) * T` is idempotent;
2. it is equal to `p(B')`.
-/
theorem polynomial_projector_covariance
    (S T B : Matrix n n Complex) (p : Polynomial Complex)
    (hST : S * T = 1)
    (hTS : T * S = 1)
    (hIdemOnB : Polynomial.aeval B (p * p - p) = 0) :
    ((S * Polynomial.aeval B p * T) * (S * Polynomial.aeval B p * T)
      = S * Polynomial.aeval B p * T)
    ∧
    Polynomial.aeval (S * B * T) p = S * Polynomial.aeval B p * T := by
  have h1 : S * (Polynomial.aeval B p) * T * (S * (Polynomial.aeval B p) * T) = S * (Polynomial.aeval B p) * T := by
    grind +splitImp;
  refine' ⟨ h1, _ ⟩;
  have h_aeval : ∀ (k : ℕ), (S * B * T)^k = S * B^k * T := by
    intro k; induction k <;> simp_all +decide [ pow_succ', mul_assoc ] ;
    simp +decide [ ← mul_assoc, hTS ];
  simp +decide [ Polynomial.aeval_eq_sum_range, h_aeval ];
  simp +decide [ Finset.mul_sum _ _ _, Finset.sum_mul, mul_assoc ]

end C107cPolynomialProjector
