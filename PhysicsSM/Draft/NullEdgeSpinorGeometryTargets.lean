import PhysicsSM.Draft.NullEdgePluckerGeneralAristotle

/-!
# Draft.NullEdgeSpinorGeometryTargets

Aristotle handoff for the spinor-geometric strengthening of the null-edge
Pluecker mass program.

The finite Pluecker identity says that determinant mass is the sum of squared
pairwise spinor wedges.  This file asks for the next geometric layer:

1. the two-spinor Lagrange identity, identifying wedge-squared with
   Fubini-Study angular spread after normalization;
2. covariance of the wedge under `GL(2,C)` and invariance under `SL(2,C)`;
3. a narrow two-twistor/spinor-chart mass theorem.

These are draft targets.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeSpinorGeometryTargets

open Matrix Complex
open PhysicsSM.Draft.NullEdgeCore
open PhysicsSM.Draft.NullEdgePluckerGeneral

/-! ## Basic spinor geometry -/

/-- The standard Hermitian inner product on visible complex two-spinors. -/
def spinorInner (psi phi : CSpinor) : ℂ :=
  (starRingEnd ℂ) (psi 0) * phi 0 + (starRingEnd ℂ) (psi 1) * phi 1

/-- The squared Hermitian norm of a visible complex two-spinor, valued in `ℂ`. -/
def spinorNormSq (psi : CSpinor) : ℂ :=
  complexAbsSq (psi 0) + complexAbsSq (psi 1)

/--
Two-spinor Lagrange identity.

After normalizing `psi` and `phi`, this says that squared wedge is the
Fubini-Study sine-squared angular spread between projective spinor directions.
-/
theorem spinor_inner_wedge_lagrange_identity (psi phi : CSpinor) :
    complexAbsSq (spinorInner psi phi) +
      complexAbsSq (spinorWedge psi phi) =
    spinorNormSq psi * spinorNormSq phi := by
  unfold spinorInner spinorWedge spinorNormSq complexAbsSq
  simp only [map_add, map_mul, map_sub, Complex.conj_conj]
  ring

/--
For unit spinors, the squared Pluecker wedge is the complement of squared
Hermitian overlap.  This is the finite algebraic form of Fubini-Study angular
spread for the null-edge mass contribution.
-/
theorem complexAbsSq_wedge_eq_one_sub_inner_of_normSq_eq_one
    (psi phi : CSpinor)
    (hpsi : spinorNormSq psi = 1) (hphi : spinorNormSq phi = 1) :
    complexAbsSq (spinorWedge psi phi) =
      1 - complexAbsSq (spinorInner psi phi) := by
  have h := spinor_inner_wedge_lagrange_identity psi phi
  rw [hpsi, hphi, one_mul] at h
  linear_combination h

/-! ## Projective rescaling of spinor columns -/

/-- Scaling the first spinor column scales the Pluecker wedge. -/
theorem spinorWedge_smul_left (a : ℂ) (psi phi : CSpinor) :
    spinorWedge (a • psi) phi = a * spinorWedge psi phi := by
  unfold spinorWedge
  simp
  ring

/-- Scaling the second spinor column scales the Pluecker wedge. -/
theorem spinorWedge_smul_right (a : ℂ) (psi phi : CSpinor) :
    spinorWedge psi (a • phi) = a * spinorWedge psi phi := by
  unfold spinorWedge
  simp
  ring

/-- Independent projective rescalings scale the Pluecker wedge by the product. -/
theorem spinorWedge_smul_smul (a b : ℂ) (psi phi : CSpinor) :
    spinorWedge (a • psi) (b • phi) =
      (a * b) * spinorWedge psi phi := by
  rw [spinorWedge_smul_left, spinorWedge_smul_right]
  ring

/-- Scaling a spinor scales its Hermitian norm square by squared modulus. -/
theorem spinorNormSq_smul (a : ℂ) (psi : CSpinor) :
    spinorNormSq (a • psi) = complexAbsSq a * spinorNormSq psi := by
  unfold spinorNormSq complexAbsSq
  simp [smul_eq_mul]
  ring_nf

/-- Squared wedge spread under independent column rescalings. -/
theorem complexAbsSq_spinorWedge_smul_smul
    (a b : ℂ) (psi phi : CSpinor) :
    complexAbsSq (spinorWedge (a • psi) (b • phi)) =
      complexAbsSq a * complexAbsSq b *
        complexAbsSq (spinorWedge psi phi) := by
  rw [spinorWedge_smul_smul]
  unfold complexAbsSq
  simp only [map_mul]
  ring

/--
The normalized projective wedge spread of two nonzero spinor columns.

It is algebraically defined for all columns, but its projective interpretation
requires nonzero Hermitian norm squares.
-/
def projectiveWedgeSpread (psi phi : CSpinor) : ℂ :=
  complexAbsSq (spinorWedge psi phi) / (spinorNormSq psi * spinorNormSq phi)

/--
The normalized wedge spread is invariant under nonzero independent rescaling
of both spinor columns, assuming the original columns have nonzero norm square.
-/
theorem projectiveWedgeSpread_smul_smul
    (a b : ℂ) (psi phi : CSpinor)
    (ha : a ≠ 0) (hb : b ≠ 0)
    (hpsi : spinorNormSq psi ≠ 0) (hphi : spinorNormSq phi ≠ 0) :
    projectiveWedgeSpread (a • psi) (b • phi) =
      projectiveWedgeSpread psi phi := by
  have haAbs : complexAbsSq a ≠ 0 := by
    intro h
    exact ha ((complexAbsSq_eq_zero_iff a).1 h)
  have hbAbs : complexAbsSq b ≠ 0 := by
    intro h
    exact hb ((complexAbsSq_eq_zero_iff b).1 h)
  unfold projectiveWedgeSpread
  rw [complexAbsSq_spinorWedge_smul_smul, spinorNormSq_smul,
    spinorNormSq_smul]
  field_simp [haAbs, hbAbs, hpsi, hphi]

/-- Rescale every column of a finite spinor family independently. -/
def rescaleSpinorFamily {n : Nat} (c : Fin n -> ℂ)
    (psi : Fin n -> CSpinor) : Fin n -> CSpinor :=
  fun i => c i • psi i

/--
Pairwise Pluecker mass after independent column rescalings.  Each pair term is
weighted by the squared moduli of the two column scales.
-/
theorem finPairwisePluckerMass_rescale
    {n : Nat} (c : Fin n -> ℂ) (psi : Fin n -> CSpinor) :
    finPairwisePluckerMass (rescaleSpinorFamily c psi)
      =
        ∑ p ∈ finPairIndexSet n,
          complexAbsSq (c p.1) * complexAbsSq (c p.2) *
            complexAbsSq (spinorWedge (psi p.1) (psi p.2)) := by
  unfold finPairwisePluckerMass rescaleSpinorFamily
  refine Finset.sum_congr rfl fun p _ => ?_
  exact complexAbsSq_spinorWedge_smul_smul (c p.1) (c p.2)
    (psi p.1) (psi p.2)

/-! ## `GL(2,C)` covariance and `SL(2,C)` invariance -/

/-- The defining matrix action on visible complex two-spinors. -/
def spinorAction (A : Matrix (Fin 2) (Fin 2) ℂ) (psi : CSpinor) : CSpinor :=
  A.mulVec psi

/--
The spinor wedge is a determinant-relative invariant for the defining
`GL(2,C)` action.
-/
theorem spinorWedge_spinorAction
    (A : Matrix (Fin 2) (Fin 2) ℂ) (psi phi : CSpinor) :
    spinorWedge (spinorAction A psi) (spinorAction A phi) =
      A.det * spinorWedge psi phi := by
  unfold spinorWedge spinorAction
  simpa [Matrix.mulVec, Matrix.det_fin_two] using by ring

/-- `complexAbsSq` is multiplicative. -/
lemma complexAbsSq_mul (z w : ℂ) :
    complexAbsSq (z * w) = complexAbsSq z * complexAbsSq w := by
  simp only [complexAbsSq, map_mul]
  ring

/-- `complexAbsSq 1 = 1`. -/
lemma complexAbsSq_one : complexAbsSq (1 : ℂ) = 1 := by
  simp [complexAbsSq]

/--
The finite Pluecker mass functional is invariant under determinant-one spinor
changes of frame.  This is the finite algebraic shadow of Lorentz invariance.
-/
theorem finPairwisePluckerMass_sl2_invariant
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) ℂ)
    (hA : A.det = 1) (psi : Fin n -> CSpinor) :
    finPairwisePluckerMass (fun i => spinorAction A (psi i)) =
      finPairwisePluckerMass psi := by
  refine Finset.sum_congr rfl fun p _ => ?_
  rw [spinorWedge_spinorAction, hA, one_mul]

/--
The determinant mass of a finite visible null-spinor bundle is invariant under
determinant-one spinor changes of frame.
-/
theorem finBundleMomentum_det_sl2_invariant
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) ℂ)
    (hA : A.det = 1) (psi : Fin n -> CSpinor) :
    (finBundleMomentum (fun i => spinorAction A (psi i))).det =
      (finBundleMomentum psi).det := by
  calc
    (finBundleMomentum (fun i => spinorAction A (psi i))).det
        = finPairwisePluckerMass (fun i => spinorAction A (psi i)) :=
          fin_bundle_plucker_mass_identity _
    _ = finPairwisePluckerMass psi :=
          finPairwisePluckerMass_sl2_invariant A hA psi
    _ = (finBundleMomentum psi).det :=
          (fin_bundle_plucker_mass_identity psi).symm

/-! ## Narrow two-twistor chart matching -/

/--
The spinor-momentum part of a two-twistor chart.  Incidence data is
intentionally omitted here; the target is only the mass identity in the spinor
chart.
-/
structure SpinorChartTwoTwistor where
  left : CSpinor
  right : CSpinor

/-- The visible momentum carried by the two spinor columns of the chart. -/
def twoTwistorChartMomentum (Z : SpinorChartTwoTwistor) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  twoEdgeMomentum Z.left Z.right

/--
Chart-level two-twistor mass matching.

This theorem is intentionally narrow: it does not claim a full twistor
incidence formalization, only that the spinor chart of a two-twistor massive
momentum is exactly the already-proved two-edge Pluecker mass.
-/
theorem two_twistor_chart_mass_eq_plucker
    (Z : SpinorChartTwoTwistor) :
    (twoTwistorChartMomentum Z).det =
      complexAbsSq (spinorWedge Z.left Z.right) := by
  exact two_edge_plucker_mass_identity Z.left Z.right

/-! ## Multi-twistor chart wrapper -/

/--
The spinor-momentum part of a finite multi-twistor chart.  As above, this
keeps only the spinor columns needed for the mass identity.
-/
structure SpinorChartMultiTwistor (n : Nat) where
  column : Fin n -> CSpinor

/-- The visible momentum carried by all spinor columns of the chart. -/
def multiTwistorChartMomentum {n : Nat} (Z : SpinorChartMultiTwistor n) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  finBundleMomentum Z.column

/-- The pairwise Pluecker spread of the spinor columns of the chart. -/
def multiTwistorChartPairwiseMass {n : Nat}
    (Z : SpinorChartMultiTwistor n) : ℂ :=
  finPairwisePluckerMass Z.column

/--
Chart-level multi-twistor mass matching: the determinant mass of the visible
momentum chart is exactly its total pairwise Pluecker spread.
-/
theorem multi_twistor_chart_mass_eq_plucker
    {n : Nat} (Z : SpinorChartMultiTwistor n) :
    (multiTwistorChartMomentum Z).det =
      multiTwistorChartPairwiseMass Z := by
  exact fin_bundle_plucker_mass_identity Z.column

/-- Apply a spinor change of frame to every spinor column in a multi-twistor chart. -/
def spinorActionMultiTwistor {n : Nat}
    (A : Matrix (Fin 2) (Fin 2) ℂ) (Z : SpinorChartMultiTwistor n) :
    SpinorChartMultiTwistor n where
  column := fun i => spinorAction A (Z.column i)

/--
The multi-twistor chart determinant mass is invariant under determinant-one
spinor changes of frame.
-/
theorem multi_twistor_chart_mass_sl2_invariant
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) ℂ)
    (hA : A.det = 1) (Z : SpinorChartMultiTwistor n) :
    (multiTwistorChartMomentum (spinorActionMultiTwistor A Z)).det =
      (multiTwistorChartMomentum Z).det := by
  exact finBundleMomentum_det_sl2_invariant A hA Z.column

end PhysicsSM.Draft.NullEdgeSpinorGeometryTargets

end
