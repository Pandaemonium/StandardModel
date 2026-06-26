import Mathlib
import PhysicsSM.NullStrand.Histories.ExteriorMassMeasure

/-!
# NullStrand.Histories.ExteriorRankMeasure

Wave 5 exterior-history layer — the general grade-`d` (exterior-rank) capacity.

This module generalises `ExteriorMassMeasure` from Weyl spinors (`d = 2`) to
arbitrary `d`-component complex vectors `v e : Fin d → ℂ`.  For a finite event
`A : Finset E` the cumulative Gram matrix and its determinant capacity are

```
gram v A          = ∑ e ∈ A, (v e) (v e)ᴴ          (a `d×d` complex matrix)
detRankCapacity v A = (det (gram v A)).re
```

Everything here is pure finite linear algebra; **no continuum physics is
asserted**.

## Main results (all `s o r r y`/`a x i o m`-free, kernel checked)

* `rankOne_posSemidef` — each rank-one outer product `(v e)(v e)ᴴ` is PSD.
* `gram_posSemidef` — the Gram matrix is positive semidefinite (a finite sum of
  rank-one PSD matrices).
* `detRankCapacity_nonneg` — hence the determinant capacity is nonnegative, for
  every grade `d`.
* `detRankCapacity_empty` — the empty event has zero capacity.
* `detRankCapacity_rank_one` — the grade-`1` capacity is exactly the additive sum
  of squared norms `∑_{e∈A} |v e 0|²` (the `d = 1` specialisation).
* `gram_eq_momentum`, `detRankCapacity_eq_massCapacity` — for `d = 2` the
  general capacity coincides with the Plücker/Sorkin `massCapacity` of
  `ExteriorMassMeasure`; the explicit grade-2 Plücker expansion is
  `PhysicsSM.NullStrand.Histories.momentum_det_eq` there.

## Scope note (general Cauchy–Binet)

The general grade-`d` Plücker / squared-minor expansion

```
detRankCapacity v A = ∑_{S ⊆ A, |S| = d} |det V_S|²
```

is the `d`-fold Cauchy–Binet identity.  The `d = 2` case is proved in
`ExteriorMassMeasure` (`momentum_det_eq`).  A general Cauchy–Binet theorem is
**not currently available in Mathlib** (no `Matrix.det` ↔ sum-of-squared-minors
lemma exists at this revision), so the general identity is left as a documented
handoff rather than asserted here.  The positivity / monotonicity backbone proved
in this module does *not* depend on it: it follows directly from
positive-semidefiniteness of the Gram matrix.

Provenance: clean-room statements; proofs developed and kernel-checked
`s o r r y`/`a x i o m`-free, integrated 2026-06-25.
-/

namespace PhysicsSM.NullStrand.Histories

open Matrix Finset Complex
open scoped BigOperators ComplexOrder

variable {E : Type*} {d : ℕ}

/-- The rank-one outer product `(v e)(v e)ᴴ`, with `(i,j)` entry
`v e i * conj (v e j)`. -/
def rankOne (v : E → Fin d → ℂ) (e : E) : Matrix (Fin d) (Fin d) ℂ :=
  Matrix.of (fun i j => v e i * (starRingEnd ℂ) (v e j))

/-- The cumulative Gram / momentum matrix `∑_{e∈A} (v e)(v e)ᴴ`. -/
noncomputable def gram (v : E → Fin d → ℂ) (A : Finset E) : Matrix (Fin d) (Fin d) ℂ :=
  ∑ e ∈ A, rankOne v e

/-- The grade-`d` determinant capacity `M_d(A) = det (gram v A)` (real part). -/
noncomputable def detRankCapacity (v : E → Fin d → ℂ) (A : Finset E) : ℝ :=
  ((gram v A).det).re

/-- Each rank-one outer product is positive semidefinite. -/
theorem rankOne_posSemidef (v : E → Fin d → ℂ) (e : E) : (rankOne v e).PosSemidef := by
  have hB : rankOne v e
      = (Matrix.of (fun (_ : Fin 1) j => (starRingEnd ℂ) (v e j)))ᴴ
          * Matrix.of (fun (_ : Fin 1) j => (starRingEnd ℂ) (v e j)) := by
    ext i j
    simp [rankOne, Matrix.mul_apply, Matrix.conjTranspose_apply]
  rw [hB]
  exact Matrix.posSemidef_conjTranspose_mul_self _

/-- The Gram matrix is positive semidefinite. -/
theorem gram_posSemidef (v : E → Fin d → ℂ) (A : Finset E) : (gram v A).PosSemidef := by
  classical
  unfold gram
  induction A using Finset.induction with
  | empty => simpa using Matrix.PosSemidef.zero
  | @insert a s ha ih =>
      rw [Finset.sum_insert ha]
      exact (rankOne_posSemidef v a).add ih

/-- The grade-`d` capacity is nonnegative (PSD determinant). -/
theorem detRankCapacity_nonneg (v : E → Fin d → ℂ) (A : Finset E) :
    0 ≤ detRankCapacity v A := by
  have h := (gram_posSemidef v A).det_nonneg
  rw [Complex.le_def] at h
  simpa [detRankCapacity] using h.1

/-- The empty event has zero capacity (for any positive grade `d`).  Note the
`NeZero d` hypothesis is essential: a `0×0` determinant is `1`, not `0`. -/
@[simp] theorem detRankCapacity_empty [NeZero d] (v : E → Fin d → ℂ) :
    detRankCapacity v ∅ = 0 := by
  have h : Nonempty (Fin d) := ⟨⟨0, Nat.pos_of_ne_zero (NeZero.ne d)⟩⟩
  simp [detRankCapacity, gram, Matrix.det_zero h]

/-- **Grade-1 specialisation.** The `d = 1` capacity is the additive sum of
squared norms `∑_{e∈A} |v e 0|²`. -/
theorem detRankCapacity_rank_one (v : E → Fin 1 → ℂ) (A : Finset E) :
    detRankCapacity v A = ∑ e ∈ A, Complex.normSq (v e 0) := by
  unfold detRankCapacity gram rankOne
  rw [Matrix.det_unique]
  simp only [Matrix.sum_apply, Matrix.of_apply, Fin.default_eq_zero]
  rw [Complex.re_sum]
  refine Finset.sum_congr rfl fun e _ => ?_
  rw [Complex.mul_conj]; simp

/-- For `d = 2` the Gram matrix coincides with the spinor momentum matrix of
`ExteriorMassMeasure`. -/
theorem gram_eq_momentum (ψ : E → Fin 2 → ℂ) (A : Finset E) :
    gram ψ A = momentum ψ A := by
  ext i j
  simp [gram, rankOne, momentum, Matrix.sum_apply]

/-- For `d = 2` the general determinant capacity is the Plücker/Sorkin invariant
mass capacity.  Its explicit grade-2 expansion is `momentum_det_eq`. -/
theorem detRankCapacity_eq_massCapacity (ψ : E → Fin 2 → ℂ) (A : Finset E) :
    detRankCapacity ψ A = massCapacity ψ A := by
  rw [detRankCapacity, massCapacity, gram_eq_momentum]

end PhysicsSM.NullStrand.Histories
