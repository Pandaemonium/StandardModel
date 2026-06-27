import Mathlib

/-!
# Draft.NullEdgeKreinOverlapSignTrap

Aristotle task C81 (Wave 19): a finite `2×2` Krein-space counterexample showing
that **`J`-self-adjointness alone is not enough** to infer the ordinary
Hermitian / real-spectrum (gapped sign-function) data that an overlap /
Ginsparg–Wilson spectral-flow argument needs.

## Setup

We work over `ℝ` with the indefinite metric

```text
J = diag(1, -1)
A = [[0, 1], [-1, 0]].
```

`A` is `J`-self-adjoint: with the indefinite inner product
`⟨x, y⟩ = xᵀ J y`, self-adjointness `⟨A x, y⟩ = ⟨x, A y⟩` is the matrix identity
`Aᵀ J = J A`.  Yet `A² = -I`, so `A` has **no real eigenvalue**: any real
eigenpair would force `μ² = -1`.  Hence Krein (`J`-) self-adjointness does not
imply the Hermitian/gapped hypotheses required by a real spectral-flow sign
argument.

## Theorem package

* `kreinTrap_J_self_adjoint`       — `Aᵀ * J = J * A`.
* `kreinTrap_sq_eq_neg_one`        — `A ^ 2 = -1`.
* `kreinTrap_not_real_spectrum_proxy` — `A` has no nonzero real eigenvector.
* `krein_self_adjoint_not_overlap_sign_legal` — the packaged guardrail:
  there is a `J`-self-adjoint matrix (w.r.t. an invertible `J`) with no real
  eigenvector.

## Scope

This is the finite algebraic guardrail only.  We do **not** formalize the
analytic matrix sign function; the point is purely that `J`-self-adjointness is
strictly weaker than the Hermitian/gapped spectral input of overlap/GW.
-/

namespace PhysicsSM.Draft.NullEdgeKreinOverlapSignTrap

open Matrix

/-- The indefinite Krein metric `J = diag(1, -1)`. -/
def kreinJ : Matrix (Fin 2) (Fin 2) ℝ := !![1, 0; 0, -1]

/-- The `J`-self-adjoint generator `A = [[0, 1], [-1, 0]]`. -/
def kreinA : Matrix (Fin 2) (Fin 2) ℝ := !![0, 1; -1, 0]

/-
`A` is `J`-self-adjoint: `Aᵀ J = J A`.
-/
theorem kreinTrap_J_self_adjoint : kreinAᵀ * kreinJ = kreinJ * kreinA := by
  ext i j;
  fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, kreinA, kreinJ ]

/-
`A² = -I`.
-/
theorem kreinTrap_sq_eq_neg_one : kreinA ^ 2 = -1 := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ sq, Matrix.mul_apply ]; all_goals norm_num [ kreinA ]

/-
`A` has no nonzero real eigenvector: real spectral data cannot be inferred.
If `A *ᵥ v = μ • v` for a real scalar `μ`, then `v = 0`.
-/
theorem kreinTrap_not_real_spectrum_proxy
    (μ : ℝ) (v : Fin 2 → ℝ) (h : kreinA *ᵥ v = μ • v) : v = 0 := by
  simp_all +decide [ funext_iff, Fin.forall_fin_two, Matrix.mulVec, kreinA ];
  constructor <;> cases le_or_gt 0 ( v 0 ) <;> cases le_or_gt 0 ( v 1 ) <;> nlinarith! [ sq_nonneg μ ]

/-
Packaged guardrail: there exists an invertible Krein metric `J` and a
`J`-self-adjoint matrix `A` (`Aᵀ J = J A`) that nonetheless has **no** real
eigenvector.  Thus `J`-self-adjointness does not supply the Hermitian/gapped
real-spectrum hypotheses required by an overlap / GW spectral-flow sign
argument.
-/
theorem krein_self_adjoint_not_overlap_sign_legal :
    ∃ J A : Matrix (Fin 2) (Fin 2) ℝ,
      IsUnit J ∧ Aᵀ * J = J * A ∧
        (∀ (μ : ℝ) (v : Fin 2 → ℝ), A *ᵥ v = μ • v → v = 0) := by
  use kreinJ;
  simp +decide [ Matrix.isUnit_iff_isUnit_det ];
  refine' ⟨ _, _ ⟩;
  · norm_num [ kreinJ ];
  · refine' ⟨ kreinA, kreinTrap_J_self_adjoint, kreinTrap_not_real_spectrum_proxy ⟩

end PhysicsSM.Draft.NullEdgeKreinOverlapSignTrap
