import Mathlib

/-!
# C106a origin-polarization escape hatch

Standalone finite-matrix target for Aristotle.

Project reading:

* `Gamma0` is the chirality operator on the balanced origin kernel.
* `J` is a balance symmetry with `J * Gamma0 * J = -Gamma0`.
* `P0` is a candidate origin projector or selector.

The key theorem should show that any `P0` commuting with `J` has zero chiral
index. Consequently a C1 physical projector with nonzero target index must
escape the balance commutant.

This standalone file intentionally uses matrices over `Complex`; it is a finite
linear-algebra proxy for the null-edge origin fiber.
-/

namespace C106aOriginPolarization

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Finite origin chiral index proxy: `Tr(Gamma0 * P0)`. -/
noncomputable def ChiralIndex (Gamma0 P0 : Matrix n n Complex) : Complex :=
  Matrix.trace (Gamma0 * P0)

/--
Balanced-commutant zero-index theorem.

If the balance symmetry `J` is an involution, flips origin chirality, and `P0`
commutes with `J`, then `P0` has zero chiral index.

Informal proof:

```text
Tr(Gamma0 P0)
= Tr(J Gamma0 P0 J)
= Tr((J Gamma0 J) (J P0 J))
= Tr((-Gamma0) P0)
= - Tr(Gamma0 P0).
```

Over `Complex`, this implies the trace is zero.
-/
theorem balance_commutant_zero_chiralIndex
    (Gamma0 J P0 : Matrix n n Complex)
    (hJ2 : J * J = 1)
    (hflip : J * Gamma0 * J = -Gamma0)
    (hcomm : P0 * J = J * P0) :
    ChiralIndex Gamma0 P0 = 0 := by
  have e1 : Gamma0 = -(J * Gamma0 * J) := by
    rw [hflip, neg_neg]
  have r2 : Gamma0 * J * P0 * J = Gamma0 * P0 := by
    rw [mul_assoc, mul_assoc, hcomm, ← mul_assoc J J P0, hJ2, one_mul]
  have step :
      Matrix.trace (J * Gamma0 * J * P0) =
        Matrix.trace (Gamma0 * P0) := by
    have r1 : J * Gamma0 * J * P0 = J * (Gamma0 * J * P0) := by
      rw [mul_assoc, mul_assoc, mul_assoc]
    rw [r1, Matrix.trace_mul_comm, r2]
  have key :
      Matrix.trace (Gamma0 * P0) = -Matrix.trace (Gamma0 * P0) := by
    calc
      Matrix.trace (Gamma0 * P0)
          = Matrix.trace (-(J * Gamma0 * J) * P0) := by rw [← e1]
      _ = -Matrix.trace (J * Gamma0 * J * P0) := by
            rw [Matrix.neg_mul, Matrix.trace_neg]
      _ = -Matrix.trace (Gamma0 * P0) := by rw [step]
  have h2 : (2 : Complex) * Matrix.trace (Gamma0 * P0) = 0 := by
    linear_combination key
  simpa [ChiralIndex] using h2

/--
Escape-hatch corollary.

If a candidate origin selector has nonzero target chiral index, it cannot
commute with the chirality-flipping balance symmetry.
-/
theorem nonzero_index_requires_balance_escape
    (Gamma0 J P0 : Matrix n n Complex)
    (targetIndex : Complex)
    (hJ2 : J * J = 1)
    (hflip : J * Gamma0 * J = -Gamma0)
    (hindex : ChiralIndex Gamma0 P0 = targetIndex)
    (htarget : targetIndex ≠ 0) :
    P0 * J ≠ J * P0 := by
  intro hcomm
  have hzero :=
    balance_commutant_zero_chiralIndex
      (Gamma0 := Gamma0) (J := J) (P0 := P0) hJ2 hflip hcomm
  have htarget_zero : targetIndex = 0 := by
    simpa [hindex] using hzero
  exact htarget htarget_zero

end C106aOriginPolarization
