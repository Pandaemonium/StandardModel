import Mathlib

/-!
# C107 finite spectral-projector covariance seed

Standalone finite theorem target for Aristotle.

The non-ultralocal Gate C1_NU plan selects a physical branch by a canonical
branch observable `B(U)` and a finite spectral or polynomial projector `p(B)`.
Before formalizing full spectral islands or Riesz projectors, the essential
finite algebra fact is that polynomial functions of a gauge-covariant branch
observable are themselves gauge-covariant.

This file isolates the matrix core:

```text
B' = S B T,   S T = 1,   T S = 1
```

then:

```text
(B')^k = S B^k T.
```

Polynomial covariance follows by linear combination of these power identities,
and is recorded below as `conjugate_aeval`.

## Claim boundary

This does **not** prove `C1_NU` and does **not** construct `B(U)`. It is only the
finite matrix covariance seed needed before polynomial spectral projectors and
Riesz projectors: it shows conjugation by an inverse pair `S, T` (with
`S * T = 1` and `T * S = 1`) preserves matrix powers, idempotence, and (more
generally) the value of any polynomial applied via `Polynomial.aeval`.
-/

namespace C107FiniteSpectralProjector

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/--
Conjugation respects matrix powers.

This is the finite algebra seed for the later statement:

```text
p(S B S^{-1}) = S p(B) S^{-1}.
```
-/
theorem conjugate_pow
    (S T B : Matrix n n Complex)
    (hST : S * T = 1)
    (hTS : T * S = 1)
    (k : Nat) :
    (S * B * T) ^ k = S * (B ^ k) * T := by
  induction k with
  | zero => simp [hST]
  | succ k ih =>
      rw [pow_succ, ih, pow_succ]
      -- (S * B^k * T) * (S * B * T) = S * (B^k * B) * T
      calc
        (S * B ^ k * T) * (S * B * T)
            = S * B ^ k * (T * S) * B * T := by
              simp only [Matrix.mul_assoc]
        _ = S * (B ^ k * B) * T := by
              rw [hTS]; simp only [Matrix.mul_assoc, Matrix.mul_one]

/--
If a branch observable is idempotent after conjugation, its conjugate projector
is also idempotent.

This is a deliberately small projector sanity theorem. It is not yet a full
spectral-projector theorem; it only says that gauge conjugation preserves the
projector equation.
-/
theorem conjugate_preserves_idempotent
    (S T P : Matrix n n Complex)
    (hST : S * T = 1)
    (hTS : T * S = 1)
    (hP : P * P = P) :
    (S * P * T) * (S * P * T) = S * P * T := by
  calc
    (S * P * T) * (S * P * T)
        = S * P * (T * S) * P * T := by simp only [Matrix.mul_assoc]
    _ = S * (P * P) * T := by rw [hTS]; simp only [Matrix.mul_assoc, Matrix.mul_one]
    _ = S * P * T := by rw [hP]

/--
Polynomial covariance (finite algebra seed).

For any polynomial `p` over `Complex`, evaluating `p` at the conjugate
`S * B * T` is the conjugate of evaluating `p` at `B`:

```text
p(S B T) = S p(B) T,   when S T = 1 and T S = 1.
```

This is the immediate successor of `conjugate_pow`: it follows by linearity of
`Polynomial.aeval` together with the power identity. It is only a finite-algebra
fact about matrices; it does **not** by itself establish spectral projection or
gauge covariance of any physical branch observable.
-/
theorem conjugate_aeval
    (S T B : Matrix n n Complex)
    (hST : S * T = 1)
    (hTS : T * S = 1)
    (p : Polynomial Complex) :
    Polynomial.aeval (S * B * T) p = S * (Polynomial.aeval B p) * T := by
  induction p using Polynomial.induction_on with
  | C a =>
      simp only [Polynomial.aeval_C]
      rw [Algebra.algebraMap_eq_smul_one]
      rw [mul_smul_comm, smul_mul_assoc, Matrix.mul_one, hST]
  | add p q hp hq =>
      simp only [map_add, hp, hq, Matrix.mul_add, Matrix.add_mul]
  | monomial k a _ =>
      simp only [map_mul, Polynomial.aeval_C, Polynomial.aeval_X_pow,
        Algebra.algebraMap_eq_smul_one]
      rw [conjugate_pow S T B hST hTS]
      simp only [smul_mul_assoc, mul_smul_comm, Matrix.one_mul]

end C107FiniteSpectralProjector
