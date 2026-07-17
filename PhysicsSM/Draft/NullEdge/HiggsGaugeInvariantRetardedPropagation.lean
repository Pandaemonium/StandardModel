import PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable
import PhysicsSM.Draft.NullEdge.HiggsMassiveRetardedPropagation

/-!
# Gauge-invariant finite Higgs radial propagation

This capstone composes two independently checked finite bridges:

1. a radial Higgs excitation has a terminating massive retarded response on a
   finite strict causal order; and
2. the gauge-invariant FMS radial observable has a positive leading coefficient
   for a nonzero vacuum and scales finite response kernels without moving their
   support or resolvent equation.

For the one-component control vacuum used by the current radial-potential
normalization, the leading gauge-invariant response therefore obeys the same
left and right finite resolvent identities as the elementary radial kernel.
The three-event witness is nonvacuous: there is no direct endpoint hop, but the
massive two-link response is nonzero and its leading FMS value is `-4`.

This remains finite leading-response algebra. It does not prove suppression of
higher FMS terms, a continuum scalar pole, LSZ normalization, or the observed
Higgs mass. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantRetardedPropagation

open PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence
open PhysicsSM.Draft.NullEdge.FiniteStrictPastKernelMatrix
open PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable
open PhysicsSM.Draft.NullEdge.HiggsMassiveRetardedPropagation
open PhysicsSM.Draft.NullEdge.HiggsRadialCurvature
open PhysicsSM.Draft.NullEdge.MassiveRetardedLinkSeries

variable {V : Type*} [Fintype V] [DecidableEq V] [Nonempty V]

/-- One-component complex vacuum associated with the real control value. -/
def oneComponentVacuum (vacuum : Real) : Fin 1 -> Complex :=
  fun _ => vacuum

/-- A nonzero real vacuum gives a propositionally nonzero one-component
complex vacuum. -/
theorem oneComponentVacuum_ne_zero
    {vacuum : Real} (hVacuum : vacuum ≠ 0) :
    oneComponentVacuum vacuum ≠ 0 := by
  intro hZero
  have hEntry := congrFun hZero 0
  simp [oneComponentVacuum] at hEntry
  exact hVacuum hEntry

/-- In the supplied unnormalized radial coordinate, the one-component leading
FMS coefficient squared is `4 * vacuum^4`. -/
theorem oneComponent_fmsRadialResidue_eq (vacuum : Real) :
    fmsRadialResidue (oneComponentVacuum vacuum) = 4 * vacuum ^ 4 := by
  simp [fmsRadialResidue, vectorNormSq, realHermitianBilinear,
    oneComponentVacuum]
  ring

/-- The gauge-invariant leading radial response obeys the same exact left and
right finite resolvent equations as the elementary radial Higgs response. -/
theorem strictPast_fmsLeading_radialHiggs_resolvent
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (lam vacuum : Real) :
    let K := weightedPastKernelMatrix C weight
    let G := massiveRetardedSeries K (radialMassSquared lam vacuum)
      (Fintype.card V)
    let A := 1 + radialMassSquared lam vacuum • K
    A * fmsLeadingKernel (oneComponentVacuum vacuum) G =
        fmsLeadingKernel (oneComponentVacuum vacuum) K ∧
      fmsLeadingKernel (oneComponentVacuum vacuum) G * A =
        fmsLeadingKernel (oneComponentVacuum vacuum) K := by
  dsimp
  obtain ⟨hLeft, hRight⟩ :=
    strictPast_radialHiggs_resolvent C weight lam vacuum
  constructor
  · exact fmsLeadingKernel_resolvent
      (oneComponentVacuum vacuum) _ _ _ hLeft
  · unfold fmsLeadingKernel
    rw [Matrix.smul_mul, hRight]

omit [Nonempty V] in
/-- For a nonzero control vacuum, the leading gauge-invariant kernel has
exactly the same entrywise support as the elementary massive response. -/
theorem strictPast_fmsLeading_entry_eq_zero_iff
    (C : FiniteStrictRelation V) (weight : V -> V -> Real)
    (lam vacuum : Real) (hVacuum : vacuum ≠ 0) (i j : V) :
    fmsLeadingKernel (oneComponentVacuum vacuum)
        (massiveRetardedSeries (weightedPastKernelMatrix C weight)
          (radialMassSquared lam vacuum) (Fintype.card V)) i j = 0 <->
      massiveRetardedSeries (weightedPastKernelMatrix C weight)
        (radialMassSquared lam vacuum) (Fintype.card V) i j = 0 := by
  exact fmsLeadingKernel_entry_eq_zero_iff
    (oneComponentVacuum vacuum) _ (oneComponentVacuum_ne_zero hVacuum) i j

/-- Exact three-event gauge-invariant control. The primitive endpoint entry is
zero, while at unit radial mass the elementary two-link endpoint response is
`-1` and its leading FMS response is `-4`. -/
theorem unitRadialMass_threeLink_fms_multiedge_witness :
    fmsRadialResidue (oneComponentVacuum 1) = 4 ∧
      fmsLeadingKernel (oneComponentVacuum 1) threeLinkKernel 2 0 = 0 ∧
      massiveRetardedSeries threeLinkKernel
          (radialMassSquared (1 / 8) 1) 3 2 0 = -1 ∧
      fmsLeadingKernel (oneComponentVacuum 1)
          (massiveRetardedSeries threeLinkKernel
            (radialMassSquared (1 / 8) 1) 3) 2 0 = -4 := by
  obtain ⟨_, hPrimitive, _, _, hMassive, _⟩ :=
    unitRadialMass_threeLink_multiedge_witness
  refine ⟨by norm_num [oneComponent_fmsRadialResidue_eq], ?_, hMassive, ?_⟩
  · simp [fmsLeadingKernel, hPrimitive]
  · change fmsRadialResidue (oneComponentVacuum 1) *
      massiveRetardedSeries threeLinkKernel
        (radialMassSquared (1 / 8) 1) 3 2 0 = -4
    rw [oneComponent_fmsRadialResidue_eq, hMassive]
    norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantRetardedPropagation.strictPast_fmsLeading_radialHiggs_resolvent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms strictPast_fmsLeading_radialHiggs_resolvent

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantRetardedPropagation.unitRadialMass_threeLink_fms_multiedge_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms unitRadialMass_threeLink_fms_multiedge_witness

end PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantRetardedPropagation

end
