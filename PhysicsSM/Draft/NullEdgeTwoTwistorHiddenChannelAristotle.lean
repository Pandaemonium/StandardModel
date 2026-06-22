import Mathlib
import PhysicsSM.Spinor.TwistorPluckerMass
import PhysicsSM.Draft.NullEdgeDecoherenceChannelAristotle

/-!
# Draft.NullEdgeTwoTwistorHiddenChannelAristotle

This Aristotle handoff connects the completed hidden-channel determinant
theorems to the trusted finite twistor chart.

The local wrapper theorems say that the two-twistor mass invariant is exactly
the determinant mass created by forgetting a hidden label.  The ambitious
target is the finite hidden-isometry theorem: a column-isometric hidden mixing
matrix preserves the visible reduced density of any finite family of visible
spinors.  This is the finite partial-trace invariance statement needed before
we promote the hidden-channel interpretation beyond the two-state toy model.

Claim boundary:

* all objects are finite matrices and finite spinor families;
* no continuum twistor cohomology, scattering amplitude, or Hilbert-space
  completion is asserted;
* the hidden-isometry theorem models only orthogonal/decohered hidden labels.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeTwoTwistorHiddenChannel

open BigOperators
open Matrix Complex
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Spinor.TwistorPluckerMass
open PhysicsSM.Draft.NullEdgeCelestialMixedness
open PhysicsSM.Draft.NullEdgeDecoherenceChannel

/-! ## 1. Two-twistor hidden-channel wrappers -/

/-- Coherent two-twistor visible momentum before the hidden label is forgotten. -/
def twoTwistorCoherentMomentum
    (Z W : SpinorChartTwistor) : QubitDensity :=
  coherentSpinorPairMomentum Z.pi W.pi

/-- Decohered two-twistor visible momentum after forgetting a hidden label. -/
def twoTwistorDecoheredMomentum
    (Z W : SpinorChartTwistor) : QubitDensity :=
  decoheredSpinorPairMomentum Z.pi W.pi

/-- The two-twistor decohered momentum is the trusted twistor momentum. -/
theorem twoTwistorDecoheredMomentum_eq_twoTwistorMomentum
    (Z W : SpinorChartTwistor) :
    twoTwistorDecoheredMomentum Z W = twoTwistorMomentum Z W := by
  rfl

/-- The two-twistor coherent momentum remains determinant-massless. -/
theorem twoTwistorCoherentMomentum_det_eq_zero
    (Z W : SpinorChartTwistor) :
    (twoTwistorCoherentMomentum Z W).det = 0 := by
  exact coherentSpinorPairMomentum_det_eq_zero Z.pi W.pi

/-- The two-twistor decohered determinant equals the twistor mass invariant. -/
theorem twoTwistorDecoheredMomentum_det_eq_massInvariant
    (Z W : SpinorChartTwistor) :
    (twoTwistorDecoheredMomentum Z W).det =
      twoTwistorMassInvariant Z W := by
  rw [twoTwistorDecoheredMomentum_eq_twoTwistorMomentum]
  exact two_twistor_momentum_det_eq_massInvariant Z W

/-- The hidden-coherence mass gap in a two-twistor chart. -/
def twoTwistorHiddenCoherenceMassGap
    (Z W : SpinorChartTwistor) : Complex :=
  hiddenCoherenceMassGap Z.pi W.pi

/--
For two chart twistors, the determinant mass gained by hidden decoherence is
exactly the squared infinity-twistor spinor pairing.
-/
theorem twoTwistorHiddenCoherenceMassGap_eq_massInvariant
    (Z W : SpinorChartTwistor) :
    twoTwistorHiddenCoherenceMassGap Z W =
      twoTwistorMassInvariant Z W := by
  unfold twoTwistorHiddenCoherenceMassGap twoTwistorMassInvariant
  unfold infinityTwistorPairing
  exact hiddenCoherenceMassGap_eq_plucker Z.pi W.pi

/-- Two-twistor partial hidden coherence. -/
def twoTwistorPartialCoherenceMomentum
    (k : Complex) (Z W : SpinorChartTwistor) : QubitDensity :=
  partialCoherenceMomentum k Z.pi W.pi

/--
Partial hidden coherence scales the two-twistor mass invariant by the hidden
Gram determinant factor.
-/
theorem twoTwistorPartialCoherence_det_eq_factor_mul_massInvariant
    (k : Complex) (Z W : SpinorChartTwistor) :
    (twoTwistorPartialCoherenceMomentum k Z W).det =
      hiddenOverlapDetFactor k * twoTwistorMassInvariant Z W := by
  unfold twoTwistorPartialCoherenceMomentum twoTwistorMassInvariant
  unfold infinityTwistorPairing
  exact partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker k Z.pi W.pi

/-- The full-coherence specialization is determinant-massless. -/
theorem twoTwistorPartialCoherence_one_det_eq_zero
    (Z W : SpinorChartTwistor) :
    (twoTwistorPartialCoherenceMomentum 1 Z W).det = 0 := by
  exact partialCoherenceMomentum_one_det_eq_zero Z.pi W.pi

/-! ## 2. Finite hidden-isometry theorem targets -/

/--
A finite hidden mixing matrix is column-isometric when its columns have the
standard Hermitian inner products.
-/
def FiniteHiddenColumnIsometry {m n : Nat}
    (U : Matrix (Fin m) (Fin n) Complex) : Prop :=
  forall i j : Fin n,
    (Finset.univ.sum fun k : Fin m => U k i * (starRingEnd Complex) (U k j)) =
      if i = j then 1 else 0

/-- Apply a finite hidden mixing matrix to a finite family of visible spinors. -/
def hiddenMixFinite {m n : Nat}
    (U : Matrix (Fin m) (Fin n) Complex)
    (psi : Fin n -> CSpinor) : Fin m -> CSpinor :=
  fun k a => Finset.univ.sum fun i : Fin n => U k i * psi i a

/-- Entrywise form of finite hidden-basis invariance. -/
theorem visibleReducedDensity_hiddenMixFinite_entry_eq
    {m n : Nat} (U : Matrix (Fin m) (Fin n) Complex)
    (psi : Fin n -> CSpinor) (hU : FiniteHiddenColumnIsometry U)
    (a b : Fin 2) :
    visibleReducedDensity (hiddenMixFinite U psi) a b =
      visibleReducedDensity psi a b := by
  have lhs_rewrite :
      visibleReducedDensity (hiddenMixFinite U psi) a b =
        Finset.univ.sum (fun k : Fin m =>
          (Finset.univ.sum fun i : Fin n => U k i * psi i a) *
            (Finset.univ.sum fun j : Fin n =>
              starRingEnd Complex (U k j) * starRingEnd Complex (psi j b))) := by
    unfold visibleReducedDensity finBundleMomentum hiddenMixFinite rankOneHermitian
    simp +decide [Matrix.vecMulVec]
    erw [Finset.sum_apply, Finset.sum_apply]
    rfl
  have lhs_fubini :
      visibleReducedDensity (hiddenMixFinite U psi) a b =
        Finset.univ.sum (fun i : Fin n =>
          Finset.univ.sum (fun j : Fin n =>
            (Finset.univ.sum fun k : Fin m =>
              U k j * starRingEnd Complex (U k i)) *
                (psi j a * starRingEnd Complex (psi i b)))) := by
    rw [lhs_rewrite]
    simp only [Finset.sum_mul, Finset.mul_sum]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro i _
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro j _
    apply Finset.sum_congr rfl
    intro k _
    ring
  simp_all +decide [FiniteHiddenColumnIsometry]
  rw [← lhs_rewrite, visibleReducedDensity, finBundleMomentum, Finset.sum_apply,
    Finset.sum_apply]
  unfold rankOneHermitian
  simp +decide [Matrix.vecMulVec]

/--
Finite hidden basis changes preserve the visible reduced density.

This is the high-value proof target in this batch.  Expanding entries reduces
the statement to the column-isometry equations for `U` and finite sum
reindexing.
-/
theorem visibleReducedDensity_hiddenMixFinite_eq
    {m n : Nat} (U : Matrix (Fin m) (Fin n) Complex)
    (psi : Fin n -> CSpinor) (hU : FiniteHiddenColumnIsometry U) :
    visibleReducedDensity (hiddenMixFinite U psi) =
      visibleReducedDensity psi := by
  ext a b
  exact visibleReducedDensity_hiddenMixFinite_entry_eq U psi hU a b

/--
Finite hidden basis changes therefore preserve the Pluecker determinant mass.
-/
theorem visibleReducedDensity_hiddenMixFinite_det_eq_plucker
    {m n : Nat} (U : Matrix (Fin m) (Fin n) Complex)
    (psi : Fin n -> CSpinor) (hU : FiniteHiddenColumnIsometry U) :
    (visibleReducedDensity (hiddenMixFinite U psi)).det =
      (finPairwisePluckerMassReal psi : Complex) := by
  rw [visibleReducedDensity_hiddenMixFinite_eq U psi hU]
  exact visibleReducedDensity_det_eq_plucker psi

/--
Finite hidden basis changes do not change the common-direction massless locus.
-/
theorem visibleReducedDensity_hiddenMixFinite_mass_zero_iff_common_direction
    {m n : Nat} (U : Matrix (Fin m) (Fin n) Complex)
    (psi : Fin n -> CSpinor) (base : Fin n)
    (hU : FiniteHiddenColumnIsometry U)
    (hbase : psi base 0 != 0 \/ psi base 1 != 0) :
    (visibleReducedDensity (hiddenMixFinite U psi)).det = 0 <->
      exists c : Fin n -> Complex,
        forall i : Fin n, psi i = c i • psi base := by
  rw [visibleReducedDensity_hiddenMixFinite_eq U psi hU]
  exact visibleReducedDensity_mass_zero_iff_common_direction psi base hbase

/-! ## 3. Multi-twistor hidden-isometry corollaries -/

/--
Apply a finite hidden mixing matrix to the `pi` spinor family of a multi-twistor
chart.
-/
def hiddenMixMultiTwistorPi {m n : Nat}
    (U : Matrix (Fin m) (Fin n) Complex) (Z : MultiTwistorChart n) :
    Fin m -> CSpinor :=
  hiddenMixFinite U fun i => (Z.twistor i).pi

/--
The hidden-isometry theorem preserves the multi-twistor pairwise mass after
hidden mixing of the visible `pi` spinors.
-/
theorem visibleReducedDensity_hiddenMixMultiTwistorPi_det_eq_pairwiseMass
    {m n : Nat} (U : Matrix (Fin m) (Fin n) Complex)
    (Z : MultiTwistorChart n) (hU : FiniteHiddenColumnIsometry U) :
    (visibleReducedDensity (hiddenMixMultiTwistorPi U Z)).det =
      multiTwistorPairwiseMass Z := by
  unfold hiddenMixMultiTwistorPi
  rw [visibleReducedDensity_hiddenMixFinite_eq U (fun i => (Z.twistor i).pi) hU]
  exact multi_twistor_momentum_det_eq_pairwiseMass Z

/--
Hidden mixing preserves the multi-twistor massless/common-direction criterion.
-/
theorem visibleReducedDensity_hiddenMixMultiTwistorPi_mass_zero_iff_common_pi_direction
    {m n : Nat} (U : Matrix (Fin m) (Fin n) Complex)
    (Z : MultiTwistorChart n) (base : Fin n)
    (hU : FiniteHiddenColumnIsometry U)
    (hbase : (Z.twistor base).pi 0 != 0 \/
      (Z.twistor base).pi 1 != 0) :
    (visibleReducedDensity (hiddenMixMultiTwistorPi U Z)).det = 0 <->
      exists c : Fin n -> Complex,
        forall i : Fin n,
          (Z.twistor i).pi = c i • (Z.twistor base).pi := by
  unfold hiddenMixMultiTwistorPi
  rw [visibleReducedDensity_hiddenMixFinite_eq U (fun i => (Z.twistor i).pi) hU]
  exact visibleReducedDensity_mass_zero_iff_common_direction
    (fun i => (Z.twistor i).pi) base hbase

end PhysicsSM.Draft.NullEdgeTwoTwistorHiddenChannel

end
