import PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates
import PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge

/-!
# Five-event carrier Lorentz-inertia normalization target

`CorrectedPairingDifferenceCoordinates.lean` constructs a genuine five-event
marked Alexandrov diamond and proves that the production project-local
corrected pairing has one positive and three negative diagonal entries in an
explicit basis.  This module isolates the remaining normalization statement
against the production carrier API.

The intended proof transports the explicit basis along
`fiveEventInducedOrderIso`, rescales its four vectors by nonzero real units,
uses equal nonzero scales to reduce the smeared operator to the local one, and
checks that the resulting carrier Gram matrix is exactly
`MinkowskiConvention.eta`.

This target does not derive a canonical carrier-selection rule, a spectral
gap, overlap compatibility, refinement persistence, or continuum convergence.

Claim grade: `M [orig]` finite witness.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CorrectedPairingCarrierInertiaWitness

open PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator
open PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates
open PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator
open PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace
open PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge

/-- Transport the explicit five-event difference basis into the production
closed-carrier probe space. -/
def fiveEventCarrierProbeBasis : CarrierProbeFrame fiveEventLorentzDiamond :=
  fiveEventDifferenceBasis.map
    (zeroSumProbeSector.spaceLinearEquiv fiveEventInducedOrderIso)

/-- The transported carrier basis has the same strict mostly-minus diagonal
Gram matrix at equal nonzero scales. -/
theorem fiveEventCarrierProbeBasis_gram
    (ell : Real) (hell : ell ≠ 0) (i j : Fin 4) :
    carrierProbePairing fiveEventLorentzDiamond ell ell
        (carrierTop fiveEventLorentzDiamond)
        (fiveEventCarrierProbeBasis i) (fiveEventCarrierProbeBasis j) =
      if i = j then
        if i = 0 then (4 : Real) * sourceLocal4DPrefactor ell
        else -(1 / 2 : Real) * sourceLocal4DPrefactor ell
      else 0 := by
  have hsmeared :
      projectSmeared4DOperator
          (inducedOrder fiveEventLorentzDiamond) ell ell =
        projectLocal4DOperator
          (inducedOrder fiveEventLorentzDiamond) ell := by
    funext phi x
    unfold projectSmeared4DOperator projectLocal4DOperator
    rw [sourceSmeared4DOperator_same_scale _ _ hell]
  unfold carrierProbePairing
  rw [hsmeared]
  change correctedPairingAt
      (projectLocal4DOperator
        (inducedOrder fiveEventLorentzDiamond) ell)
      (fiveEventInducedOrderIso.toEquiv 4)
      (fiveEventInducedOrderIso.relabelField
        (fiveEventDifferenceBasis i).1)
      (fiveEventInducedOrderIso.relabelField
        (fiveEventDifferenceBasis j).1) = _
  rw [fiveEventInducedOrderIso.correctedPairingAt_projectLocal4D_equivariant]
  simpa [fiveEventDifferenceBasis] using
    fiveEventProjectLocal_differenceProbe_gram ell i j

/-- **Normalization target.** The concrete five-event marked carrier realizes
the production mostly-minus inertia predicate at equal nonzero scales. -/
theorem fiveEventLorentzDiamond_hasLorentzianInertia
    (ell : Real) (hell : ell ≠ 0) :
    HasLorentzianInertia fiveEventLorentzDiamond ell ell
      (carrierTop fiveEventLorentzDiamond) := by
  let s := sourceLocal4DPrefactor ell
  have hs : 0 < s := by
    dsimp [s, sourceLocal4DPrefactor]
    positivity
  let d : Fin 4 -> Real := fun i =>
    if i = 0 then Real.sqrt (4 * s) else Real.sqrt ((1 / 2 : Real) * s)
  have hd : forall i, d i ≠ 0 := by
    intro i
    dsimp [d]
    split_ifs
    · exact ne_of_gt (Real.sqrt_pos.2 (by nlinarith [hs]))
    · exact ne_of_gt (Real.sqrt_pos.2 (by nlinarith [hs]))
  let u : Fin 4 -> Units Real := fun i => (Units.mk0 (d i) (hd i))⁻¹
  refine ⟨fiveEventCarrierProbeBasis.unitsSMul u, ?_⟩
  unfold IsLorentzNormalized
  ext i j
  rw [carrierProbeGram_apply]
  simp only [Module.Basis.unitsSMul_apply, Units.smul_def]
  rw [← carrierProbeBilinForm_apply]
  rw [map_smul, map_smul, LinearMap.smul_apply]
  simp only [smul_eq_mul, carrierProbeBilinForm_apply]
  rw [fiveEventCarrierProbeBasis_gram ell hell i j]
  fin_cases i <;> fin_cases j <;>
    simp [u, d, s, MinkowskiConvention.eta]
  all_goals
    have hsqrt_s_ne : Real.sqrt (sourceLocal4DPrefactor ell) ≠ 0 :=
      ne_of_gt (Real.sqrt_pos.2 hs)
    have hsqrt_s_sq :
        Real.sqrt (sourceLocal4DPrefactor ell) *
            Real.sqrt (sourceLocal4DPrefactor ell) =
          sourceLocal4DPrefactor ell :=
      Real.mul_self_sqrt hs.le
    have hsqrt_two_sq : Real.sqrt (2 : Real) * Real.sqrt 2 = 2 :=
      Real.mul_self_sqrt (by norm_num)
    have hsqrt_four : Real.sqrt (4 : Real) = 2 := by norm_num
    try rw [hsqrt_four]
    field_simp [hsqrt_s_ne]
    nlinarith

end PhysicsSM.Draft.NullEdge.CorrectedPairingCarrierInertiaWitness

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingCarrierInertiaWitness.fiveEventLorentzDiamond_hasLorentzianInertia' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingCarrierInertiaWitness.fiveEventLorentzDiamond_hasLorentzianInertia
