import PhysicsSM.Draft.NullEdge.CarrierRigidity

/-!
# The live Krein form is not a positive channel metric

The shortest proposed positive selector for Paper F was to derive a quadratic
metric directly from the live carrier adjoint:

`kreinGram A B = trace (A# * B)`.

This module gives an exact negative result. The live `4 x 4` rational carrier
has a nonzero matrix that is both chirality-even and Krein-self-adjoint, but
whose self-pairing is `-2`. Therefore the adjoint-induced form is not even
positive semidefinite on the complete retained even self-adjoint operator
sector. Restricting it to the span of the desired channels may become positive,
but that restriction would need a noncircular derivation.

Provenance: direct finite audit of the positivity axiom proposed by Aristotle
grand strategy project `b2d0edea-18e2-4575-8fce-738a5c2c71d2`. Lean 4.28.0.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelKreinMetricNoGo

open Matrix
open CarrierRigidity.Concrete

/-- Adjoint-induced bilinear trace form on represented operators. -/
def kreinGram (A B : N) : ℚ := Matrix.trace (kadj A * B)

/-- Exact even, self-adjoint negative direction. -/
def negativeEvenDirection : N :=
  !![0,1,0,0; -1,0,0,0; 0,0,0,0; 0,0,0,0]

theorem negativeEvenDirection_nonzero : negativeEvenDirection ≠ 0 := by
  intro h
  have h01 := congrFun (congrFun h 0) 1
  norm_num [negativeEvenDirection] at h01

theorem negativeEvenDirection_selfadjoint :
    kadj negativeEvenDirection = negativeEvenDirection := by
  have hT : negativeEvenDirectionᵀ =
      (!![0,-1,0,0; 1,0,0,0; 0,0,0,0; 0,0,0,0] : N) := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [negativeEvenDirection, Matrix.transpose_apply]
  unfold kadj
  rw [hT]
  unfold eta negativeEvenDirection
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem negativeEvenDirection_even :
    Gam * negativeEvenDirection = negativeEvenDirection * Gam := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Gam, negativeEvenDirection, Matrix.mul_apply, Fin.sum_univ_four]

theorem negativeEvenDirection_gram :
    kreinGram negativeEvenDirection negativeEvenDirection = -2 := by
  rw [kreinGram, negativeEvenDirection_selfadjoint]
  have hsq : negativeEvenDirection * negativeEvenDirection =
      (!![-1,0,0,0; 0,-1,0,0; 0,0,0,0; 0,0,0,0] : N) := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [negativeEvenDirection, Matrix.mul_apply, Fin.sum_univ_four]
  rw [hsq]
  simp +decide [Matrix.trace, Fin.sum_univ_four]
  norm_num

/-- The adjoint-induced trace form is not positive semidefinite even after
restricting to chirality-even, Krein-self-adjoint operators. -/
theorem no_kreinGram_nonnegative_on_even_selfadjoint :
    ¬ (∀ X : N,
      kadj X = X → Gam * X = X * Gam → 0 ≤ kreinGram X X) := by
  intro h
  have hneg := h negativeEvenDirection
    negativeEvenDirection_selfadjoint negativeEvenDirection_even
  rw [negativeEvenDirection_gram] at hneg
  norm_num at hneg

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelKreinMetricNoGo.negativeEvenDirection_gram' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms negativeEvenDirection_gram

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelKreinMetricNoGo.no_kreinGram_nonnegative_on_even_selfadjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_kreinGram_nonnegative_on_even_selfadjoint

end PhysicsSM.Draft.NullEdge.ChannelKreinMetricNoGo
