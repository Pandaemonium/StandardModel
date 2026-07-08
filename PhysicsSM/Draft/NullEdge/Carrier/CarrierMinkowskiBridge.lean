import PhysicsSM.Draft.NullEdge.Carrier.CarrierApertureIdentification
import PhysicsSM.Draft.NullEdge.GateI1.NBodyAperture

/-!
# Carrier aperture block in the concrete Minkowski setting

This module specializes the abstract carrier aperture identity
`Q_A = Q(sum alpha)` to the trusted Minkowski aperture layer.

The bridge is concrete: we instantiate the abstract carrier `QuadraticForm`
with the genuine Minkowski quadratic form `minkQF` on
`Momentum4 = Fin 4 -> Real`, prove that `minkQF` coincides with the trusted
`minkowskiSq`, and compose the carrier vanishing identity with the existing
`NBodyAperture` collinearity theorem.

Claim discipline: pure algebraic/kinematic identity.  No new assumptions, no
weakening, and no physical dynamics are asserted here.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier

open PhysicsSM.Draft.NullEdge.GateI1
open PhysicsSM.Draft.NullEdge.GateI1.CompositeApertureMass
open PhysicsSM.Draft.NullEdge.GateI1.NBodyAperture

/-- The Minkowski quadratic form as a Mathlib `QuadraticForm`, with signature
`(+,-,-,-)` as a weighted sum of squares. -/
noncomputable def minkQF : QuadraticForm ℝ Momentum4 :=
  QuadraticMap.weightedSumSquares ℝ (![1, -1, -1, -1] : Fin 4 → ℝ)

/-- The carrier quadratic form agrees pointwise with the trusted
`minkowskiSq` API. -/
theorem minkQF_apply (p : Momentum4) : minkQF p = minkowskiSq p := by
  simp only [minkQF, QuadraticMap.weightedSumSquares_apply, minkowskiSq]
  simp [Fin.sum_univ_four]
  ring

/-- The carrier aperture block vanishes iff the trusted composite Minkowski
square vanishes. -/
theorem carrier_QA_zero_iff_minkowskiSq_zero {E : Type*} [Fintype E] (p : E → Momentum4) :
    nullSoldered minkQF p (fun _ => 1) ^ 2 = 0 ↔ minkowskiSq (∑ e, p e) = 0 := by
  rw [Q_A_zero_iff_totalSq_zero minkQF p (by norm_num), minkQF_apply]

/-- For a finite family of future-null momenta, the carrier aperture block
vanishes iff the whole bundle points along a single null direction. -/
theorem carrier_QA_zero_iff_collinear {E : Type*} [Fintype E] (p : E → Momentum4)
    (hnull : ∀ e, IsFutureNull (p e)) :
    nullSoldered minkQF p (fun _ => 1) ^ 2 = 0 ↔
      ∀ i j, p i ≠ 0 → ∃ c : ℝ, 0 ≤ c ∧ p j = c • p i := by
  rw [carrier_QA_zero_iff_minkowskiSq_zero,
    NBodyAperture.nbody_aperture_massless_iff_collinear Finset.univ p
      (fun i _ => hnull i)]
  simp only [Finset.mem_univ, forall_true_left]

end PhysicsSM.Draft.NullEdge.Carrier
