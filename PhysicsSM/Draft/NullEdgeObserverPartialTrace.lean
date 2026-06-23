import Mathlib

/-!
# Draft.NullEdgeObserverPartialTrace

Finite hidden-partial-trace algebra for the observer-channel mass program.

This module proves the finite-index version of the resolution/kinematic
observer split:

```text
Tr_int[(A tensor I) rho (A^dagger tensor I)] =
  A (Tr_int rho) A^dagger.
```

The file deliberately avoids the full tensor-product API.  The visible system
is indexed by `Fin 2`, the hidden label by `Fin n`, and the visible congruence
action is defined explicitly on the product index.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeObserverPartialTrace

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
  ext a b
  unfold partialTraceHidden visibleCongruence
  simp only [Matrix.mul_apply, Matrix.conjTranspose_apply, RCLike.star_def,
    Finset.mul_sum, Finset.sum_mul]
  -- Both sides are the same finite triple sum, with only the nesting order changed.
  have step1 : ∀ h : Fin n,
      (∑ a' : Fin 2, ∑ b' : Fin 2,
          A a a' * rho (a', h) (b', h) * (starRingEnd ℂ) (A b b')) =
      ∑ b' : Fin 2, ∑ a' : Fin 2,
          A a a' * rho (a', h) (b', h) * (starRingEnd ℂ) (A b b') :=
    fun _ => Finset.sum_comm
  simp only [step1]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun _ _ => ?_
  rw [Finset.sum_comm]

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
  rw [partialTraceHidden_visibleCongruence]
  norm_num [hA]

end PhysicsSM.Draft.NullEdgeObserverPartialTrace

end
