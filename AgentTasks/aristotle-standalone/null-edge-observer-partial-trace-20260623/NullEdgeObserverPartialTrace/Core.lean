import Mathlib

/-!
# NullEdgeObserverPartialTrace.Core

Focused Aristotle target for the observer-channel mass conjecture.

The goal is to prove the finite-index version of the resolution/kinematic
observer split:

```text
Tr_int[(A tensor I) rho (A^dagger tensor I)]
  =
A (Tr_int rho) A^dagger.
```

We avoid Mathlib's full tensor-product API and define the relevant finite
matrix action explicitly on indices `Fin 2 x Fin n`.
-/

noncomputable section

namespace NullEdgeObserverPartialTrace

open BigOperators
open Matrix Complex

/-- Hidden partial trace over the second component of `Fin 2 x Fin n`. -/
def partialTraceHidden {n : Nat}
    (rho : Matrix (Fin 2 × Fin n) (Fin 2 × Fin n) Complex) :
    Matrix (Fin 2) (Fin 2) Complex :=
  fun a b => Finset.univ.sum fun h : Fin n => rho (a, h) (b, h)

/-- Visible congruence action by a `2 x 2` matrix on the visible index only. -/
def visibleCongruence {n : Nat}
    (A : Matrix (Fin 2) (Fin 2) Complex)
    (rho : Matrix (Fin 2 × Fin n) (Fin 2 × Fin n) Complex) :
    Matrix (Fin 2 × Fin n) (Fin 2 × Fin n) Complex :=
  fun x y =>
    Finset.univ.sum fun a : Fin 2 =>
      Finset.univ.sum fun b : Fin 2 =>
        A x.1 a * rho (a, x.2) (b, y.2) *
          (starRingEnd Complex) (A y.1 b)

/--
The finite hidden partial trace commutes with visible congruence.

This is the formal backbone of the two-observer split: the resolution observer
can trace hidden labels before or after a visible boost.
-/
theorem partialTraceHidden_visibleCongruence {n : Nat}
    (A : Matrix (Fin 2) (Fin 2) Complex)
    (rho : Matrix (Fin 2 × Fin n) (Fin 2 × Fin n) Complex) :
    partialTraceHidden (visibleCongruence A rho) =
      A * partialTraceHidden rho * A.conjTranspose := by
  sorry

/--
For `SL(2,C)` visible boosts, the determinant of the resolution output is
invariant.
-/
theorem det_partialTraceHidden_visibleCongruence_invariant {n : Nat}
    (A : Matrix (Fin 2) (Fin 2) Complex)
    (rho : Matrix (Fin 2 × Fin n) (Fin 2 × Fin n) Complex)
    (hA : A.det = 1) :
    (partialTraceHidden (visibleCongruence A rho)).det =
      (partialTraceHidden rho).det := by
  sorry

end NullEdgeObserverPartialTrace

end
