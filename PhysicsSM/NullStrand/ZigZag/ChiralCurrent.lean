import Mathlib
import PhysicsSM.NullStrand.Conventions
import PhysicsSM.Draft.SpinorHelicityRankOneAristotle

/-!
# NullStrand.ZigZag.ChiralCurrent

Finite one-spinor chiral current map and elementary causal/normalization lemmas.

Conventions:
- Minkowski metric `(+---)`.
- Weyl spinors use the same `Fin 2 -> ℂ` alias as `Conventions.WeylSpinor`.
- This file records the finite algebraic layer used by the roadmap Stage 5.

Provenance:
- uses `PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf` and its null/future
  lemmas; these are finite algebraic statements in the same metric convention.
-/

noncomputable section

namespace PhysicsSM.NullStrand.ZigZag

open scoped BigOperators

open Matrix Complex

/-- Right-chiral current from a 2-spinor in `(+---)` conventions. -/
def rightCurrent (ψ : WeylSpinor) : Minkowski4 :=
  PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf ψ

/-- Left-chiral current from a 2-spinor in `(+---)` conventions.

    Note:
    The same `momentumOf` formula is used for both chiralities here as a finite
    algebraic proxy. If you want strict left/right sign conventions separated,
    this is the next target for an Aristotle-assisted refinement.
-/
def leftCurrent (χ : WeylSpinor) : Minkowski4 :=
  PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf χ

/-- Right current is future-pointing in the weak (causal) sense. -/
theorem rightCurrent_isNonnegFuture (ψ : WeylSpinor) : 0 ≤ rightCurrent ψ 0 := by
  exact PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf_nonneg ψ

/-- Left current is future-pointing in the weak (causal) sense. -/
theorem leftCurrent_isNonnegFuture (χ : WeylSpinor) : 0 ≤ leftCurrent χ 0 := by
  exact PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf_nonneg χ

/-- Right current from a nonzero spinor is null and future-pointing. -/
theorem rightCurrent_futureNull_of_ne_zero
    (ψ : WeylSpinor) (hψ : ψ 0 ≠ 0 ∨ ψ 1 ≠ 0) :
    IsFuture (rightCurrent ψ) ∧ IsNull (rightCurrent ψ) := by
  constructor
  · dsimp [IsFuture, rightCurrent]
    have hsq : 0 < (Complex.normSq (ψ 0) + Complex.normSq (ψ 1)) := by
      rcases hψ with h0 | h1
      · have h0pos : 0 < Complex.normSq (ψ 0) := Complex.normSq_pos.mpr h0
        exact add_pos_of_pos_of_nonneg h0pos (Complex.normSq_nonneg (ψ 1))
      · have h1pos : 0 < Complex.normSq (ψ 1) := Complex.normSq_pos.mpr h1
        exact add_pos_of_nonneg_of_pos (Complex.normSq_nonneg (ψ 0)) h1pos
    have : 0 < (Complex.normSq (ψ 0) + Complex.normSq (ψ 1)) / 2 := by
      nlinarith
    simpa [PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf, div_eq_mul_inv, mul_comm, mul_left_comm,
      mul_assoc] using this
  · dsimp [IsNull, rightCurrent, minkowskiSq, minkowskiInner]
    have hnull : (PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf ψ) 0 ^ 2
        = (PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf ψ) 1 ^ 2
          + (PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf ψ) 2 ^ 2
          + (PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf ψ) 3 ^ 2 :=
      PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf_null ψ
    nlinarith [hnull]

/-- Left current from a nonzero spinor is null and future-pointing. -/
theorem leftCurrent_futureNull_of_ne_zero
    (χ : WeylSpinor) (hχ : χ 0 ≠ 0 ∨ χ 1 ≠ 0) :
    IsFuture (leftCurrent χ) ∧ IsNull (leftCurrent χ) := by
  simpa [leftCurrent] using rightCurrent_futureNull_of_ne_zero χ hχ

/-- Strict future-direction part from nonzero spinor. -/
theorem rightCurrent_futureCausal_of_ne_zero
    (ψ : WeylSpinor) (hψ : ψ 0 ≠ 0 ∨ ψ 1 ≠ 0) : IsFuture (rightCurrent ψ) :=
  (rightCurrent_futureNull_of_ne_zero ψ hψ).1

/-- Strict future-direction part from nonzero spinor. -/
theorem leftCurrent_futureCausal_of_ne_zero
    (χ : WeylSpinor) (hχ : χ 0 ≠ 0 ∨ χ 1 ≠ 0) : IsFuture (leftCurrent χ) :=
  (leftCurrent_futureNull_of_ne_zero χ hχ).1

/-- Right-current is a null 4-vector in the chosen convention. -/
theorem rightCurrent_null (ψ : WeylSpinor) : IsNull (rightCurrent ψ) := by
  dsimp [IsNull, rightCurrent, minkowskiSq, minkowskiInner]
  have hnull : (PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf ψ) 0 ^ 2
      = (PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf ψ) 1 ^ 2
        + (PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf ψ) 2 ^ 2
        + (PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf ψ) 3 ^ 2 :=
    PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf_null ψ
  nlinarith [hnull]

/-- Left-current is a null 4-vector in the chosen convention. -/
theorem leftCurrent_null (χ : WeylSpinor) : IsNull (leftCurrent χ) := by
  simpa [leftCurrent] using (rightCurrent_null χ)

/-- Future causal right current (non-strict) restatement for the roadmap shape. -/
theorem rightCurrent_futureCausal (ψ : WeylSpinor) :
    0 ≤ rightCurrent ψ 0 := rightCurrent_isNonnegFuture ψ

/-- Future causal left current (non-strict) restatement for the roadmap shape. -/
theorem leftCurrent_futureCausal (χ : WeylSpinor) :
    0 ≤ leftCurrent χ 0 := leftCurrent_isNonnegFuture χ

end PhysicsSM.NullStrand.ZigZag
