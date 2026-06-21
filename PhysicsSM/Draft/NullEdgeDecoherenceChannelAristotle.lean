import Mathlib
import PhysicsSM.Draft.NullEdgeCelestialMixednessAristotle

/-!
# Draft.NullEdgeDecoherenceChannelAristotle

This Aristotle handoff continues the finite null-edge visible-mass program.
The previous batch identified determinant mass with Bloch mixedness and
Pluecker spread.  This file asks for the next sharper bridge:

* coherent visible alternatives remain rank-one and determinant-massless;
* decohered or orthogonally hidden alternatives acquire exactly the Pluecker
  determinant mass;
* splitting a hidden label along the same visible spinor direction creates no
  determinant mass;
* a `2 x 2` hidden-basis isometry leaves the reduced visible density unchanged.

Claim boundary:

* all statements are finite `2 x 2` complex matrix algebra;
* no continuum trace theorem, Hilbert-space completion, or scattering
  amplitude is asserted here;
* the hidden-isometry theorem is a finite algebraic model of basis-invariance
  for the orthogonal/decohered internal-label reduction.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeDecoherenceChannel

open BigOperators
open Matrix Complex
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdgeCelestialMixedness

/-! ## 1. Coherent versus decohered two-alternative mass -/

/-- A coherent visible superposition of two alternatives is still one spinor. -/
def coherentSpinorPairMomentum (psi phi : CSpinor) : QubitDensity :=
  rankOneHermitian (psi + phi)

/-- A decohered two-alternative visible momentum forgets the hidden label. -/
def decoheredSpinorPairMomentum (psi phi : CSpinor) : QubitDensity :=
  rankOneHermitian psi + rankOneHermitian phi

/--
The determinant mass gained by forgetting the hidden label instead of keeping
the two alternatives coherent.
-/
def hiddenCoherenceMassGap (psi phi : CSpinor) : Complex :=
  (decoheredSpinorPairMomentum psi phi).det -
    (coherentSpinorPairMomentum psi phi).det

/-- Coherent two-alternative superposition is determinant-massless. -/
theorem coherentSpinorPairMomentum_det_eq_zero (psi phi : CSpinor) :
    (coherentSpinorPairMomentum psi phi).det = 0 := by
  unfold coherentSpinorPairMomentum
  exact det_rankOneHermitian_eq_zero _

/-- The decohered two-alternative momentum is the trusted two-edge momentum. -/
theorem decoheredSpinorPairMomentum_eq_twoEdgeMomentum
    (psi phi : CSpinor) :
    decoheredSpinorPairMomentum psi phi = twoEdgeMomentum psi phi := by
  rfl

/-- Decohered two-alternative determinant mass is exactly Pluecker spread. -/
theorem decoheredSpinorPairMomentum_det_eq_plucker
    (psi phi : CSpinor) :
    (decoheredSpinorPairMomentum psi phi).det =
      complexAbsSq (spinorWedge psi phi) := by
  rw [decoheredSpinorPairMomentum_eq_twoEdgeMomentum]
  exact two_edge_plucker_mass_identity psi phi

/--
The hidden-coherence mass gap is exactly the Pluecker determinant mass.
This is the finite algebraic form of "mass appears when visible coherence is
discarded by an internal label".
-/
theorem hiddenCoherenceMassGap_eq_plucker (psi phi : CSpinor) :
    hiddenCoherenceMassGap psi phi = complexAbsSq (spinorWedge psi phi) := by
  unfold hiddenCoherenceMassGap
  rw [decoheredSpinorPairMomentum_det_eq_plucker,
    coherentSpinorPairMomentum_det_eq_zero]
  simp

/-- The real part of the hidden-coherence mass gap is nonnegative. -/
theorem hiddenCoherenceMassGap_re_nonneg (psi phi : CSpinor) :
    0 <= (hiddenCoherenceMassGap psi phi).re := by
  rw [hiddenCoherenceMassGap_eq_plucker,
    complexAbsSq_eq_ofReal_normSq, Complex.ofReal_re]
  exact Complex.normSq_nonneg _

/--
With a nonzero reference spinor, the hidden-coherence mass gap vanishes exactly
when the two visible alternatives were already the same projective ray.
-/
theorem hiddenCoherenceMassGap_zero_iff_collinear
    (psi phi : CSpinor) (hpsi : psi 0 ≠ 0 ∨ psi 1 ≠ 0) :
    hiddenCoherenceMassGap psi phi = 0 <->
      exists c : Complex, phi = c • psi := by
  rw [hiddenCoherenceMassGap_eq_plucker, complexAbsSq_eq_zero_iff]
  exact spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero psi phi hpsi

/-! ## 2. Collinear hidden splitting creates no mass -/

/-- Scaling a visible spinor scales its rank-one momentum by squared modulus. -/
theorem rankOneHermitian_smul (a : Complex) (psi : CSpinor) :
    rankOneHermitian (a • psi) = complexAbsSq a • rankOneHermitian psi := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rankOneHermitian, Matrix.vecMulVec, complexAbsSq]
  all_goals ring

/-- A hidden split of one visible ray into two collinear alternatives. -/
def collinearSplitMomentum (a b : Complex) (psi : CSpinor) : QubitDensity :=
  rankOneHermitian (a • psi) + rankOneHermitian (b • psi)

/-- Collinear hidden splitting only rescales the original rank-one momentum. -/
theorem collinearSplitMomentum_eq_weighted_rankOne
    (a b : Complex) (psi : CSpinor) :
    collinearSplitMomentum a b psi =
      (complexAbsSq a + complexAbsSq b) • rankOneHermitian psi := by
  unfold collinearSplitMomentum
  rw [rankOneHermitian_smul, rankOneHermitian_smul, add_smul]

/-- A collinear hidden split remains determinant-massless. -/
theorem collinearSplitMomentum_det_eq_zero
    (a b : Complex) (psi : CSpinor) :
    (collinearSplitMomentum a b psi).det = 0 := by
  rw [collinearSplitMomentum_eq_weighted_rankOne, Matrix.det_smul,
    det_rankOneHermitian_eq_zero]
  simp

/--
An isometric split of the hidden label preserves the original visible
rank-one momentum exactly.
-/
theorem collinearSplitMomentum_eq_rankOne_of_isometric_split
    (a b : Complex) (psi : CSpinor)
    (h : complexAbsSq a + complexAbsSq b = 1) :
    collinearSplitMomentum a b psi = rankOneHermitian psi := by
  rw [collinearSplitMomentum_eq_weighted_rankOne, h]
  simp

/-- The two collinear split spinors have zero Pluecker wedge. -/
theorem spinorWedge_collinear_split_eq_zero
    (a b : Complex) (psi : CSpinor) :
    spinorWedge (a • psi) (b • psi) = 0 := by
  simp [spinorWedge]
  ring

/-- The two collinear split spinors have zero two-edge Pluecker mass. -/
theorem two_edge_collinear_split_mass_eq_zero
    (a b : Complex) (psi : CSpinor) :
    (twoEdgeMomentum (a • psi) (b • psi)).det = 0 := by
  rw [two_edge_mass_zero_iff_wedge_zero]
  exact spinorWedge_collinear_split_eq_zero a b psi

/-! ## 3. Two-state hidden-basis isometry invariance -/

/-- Hermitian inner product of two hidden columns in `Complex^2`. -/
def hiddenColumnInner
    (a0 a1 b0 b1 : Complex) : Complex :=
  a0 * (starRingEnd Complex) a1 + b0 * (starRingEnd Complex) b1

/-- Self inner products of hidden columns are sums of squared moduli. -/
theorem hiddenColumnInner_self_eq_abs_sum
    (a b : Complex) :
    hiddenColumnInner a a b b = complexAbsSq a + complexAbsSq b := by
  rfl

/--
Column-isometry conditions for a `2 x 2` hidden mixing matrix.

The coefficients are arranged as

```text
[ U00 U01 ]
[ U10 U11 ].
```

The first two equations normalize the two columns, and the last two equations
annihilate the two off-diagonal column inner products.
-/
def HiddenMix2Isometry
    (U00 U01 U10 U11 : Complex) : Prop :=
  hiddenColumnInner U00 U00 U10 U10 = 1 ∧
  hiddenColumnInner U01 U01 U11 U11 = 1 ∧
  hiddenColumnInner U00 U01 U10 U11 = 0 ∧
  hiddenColumnInner U01 U00 U11 U10 = 0

/-- Two visible alternatives indexed by a two-state hidden label. -/
def pairSpinorFamily (psi phi : CSpinor) : Fin 2 -> CSpinor :=
  fun i => if i = (0 : Fin 2) then psi else phi

/-- Apply a `2 x 2` hidden mixing matrix to a two-state hidden family. -/
def hiddenMix2
    (U00 U01 U10 U11 : Complex) (psi phi : CSpinor) :
    Fin 2 -> CSpinor :=
  fun i =>
    if i = (0 : Fin 2) then
      U00 • psi + U01 • phi
    else
      U10 • psi + U11 • phi

/-- The pair-family reduced density is the decohered two-alternative momentum. -/
theorem visibleReducedDensity_pairSpinorFamily_eq_decohered
    (psi phi : CSpinor) :
    visibleReducedDensity (pairSpinorFamily psi phi) =
      decoheredSpinorPairMomentum psi phi := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [visibleReducedDensity, finBundleMomentum, pairSpinorFamily,
      decoheredSpinorPairMomentum, rankOneHermitian, Matrix.vecMulVec]

/-- The pair-family reduced determinant is the two-edge Pluecker mass. -/
theorem visibleReducedDensity_pairSpinorFamily_det_eq_plucker
    (psi phi : CSpinor) :
    (visibleReducedDensity (pairSpinorFamily psi phi)).det =
      complexAbsSq (spinorWedge psi phi) := by
  rw [visibleReducedDensity_pairSpinorFamily_eq_decohered,
    decoheredSpinorPairMomentum_det_eq_plucker]

/--
Changing the hidden basis by a finite column-isometry leaves the reduced
visible density unchanged.
-/
theorem visibleReducedDensity_hiddenMix2_eq_pairSpinorFamily
    (U00 U01 U10 U11 : Complex) (psi phi : CSpinor)
    (hU : HiddenMix2Isometry U00 U01 U10 U11) :
    visibleReducedDensity (hiddenMix2 U00 U01 U10 U11 psi phi) =
      visibleReducedDensity (pairSpinorFamily psi phi) := by
  obtain ⟨h00, h11, h01, h10⟩ := hU;
  ext i j; simp +decide [ *, visibleReducedDensity, finBundleMomentum, rankOneHermitian, Matrix.vecMulVec ] ; ring;
  simp_all +decide [ hiddenMix2, pairSpinorFamily ];
  simp_all +decide [ hiddenColumnInner ];
  grind

/-- Hidden-basis isometry leaves the visible determinant mass unchanged. -/
theorem visibleReducedDensity_hiddenMix2_det_eq_plucker
    (U00 U01 U10 U11 : Complex) (psi phi : CSpinor)
    (hU : HiddenMix2Isometry U00 U01 U10 U11) :
    (visibleReducedDensity (hiddenMix2 U00 U01 U10 U11 psi phi)).det =
      complexAbsSq (spinorWedge psi phi) := by
  rw [visibleReducedDensity_hiddenMix2_eq_pairSpinorFamily U00 U01 U10 U11 psi phi hU,
    visibleReducedDensity_pairSpinorFamily_det_eq_plucker]

/-- Hidden-basis isometry preserves nonnegativity of the visible determinant. -/
theorem visibleReducedDensity_hiddenMix2_det_re_nonneg
    (U00 U01 U10 U11 : Complex) (psi phi : CSpinor)
    (hU : HiddenMix2Isometry U00 U01 U10 U11) :
    0 <=
      ((visibleReducedDensity (hiddenMix2 U00 U01 U10 U11 psi phi)).det).re := by
  rw [visibleReducedDensity_hiddenMix2_det_eq_plucker U00 U01 U10 U11 psi phi hU,
    complexAbsSq_eq_ofReal_normSq, Complex.ofReal_re]
  exact Complex.normSq_nonneg _

/--
After hidden-basis isometry, determinant mass still vanishes exactly when the
original visible alternatives were collinear.
-/
theorem visibleReducedDensity_hiddenMix2_mass_zero_iff_original_collinear
    (U00 U01 U10 U11 : Complex) (psi phi : CSpinor)
    (hU : HiddenMix2Isometry U00 U01 U10 U11)
    (hpsi : psi 0 ≠ 0 ∨ psi 1 ≠ 0) :
    (visibleReducedDensity (hiddenMix2 U00 U01 U10 U11 psi phi)).det = 0 <->
      exists c : Complex, phi = c • psi := by
  rw [visibleReducedDensity_hiddenMix2_det_eq_plucker U00 U01 U10 U11 psi phi hU,
    complexAbsSq_eq_zero_iff]
  exact spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero psi phi hpsi

/-! ## 4. Partial hidden coherence and the Gram determinant factor -/

/-- The off-diagonal outer product `psi phi^dagger`. -/
def spinorOuter (psi phi : CSpinor) : QubitDensity :=
  Matrix.vecMulVec psi (star phi)

/-- The diagonal outer product is the rank-one Hermitian momentum. -/
theorem spinorOuter_self_eq_rankOneHermitian (psi : CSpinor) :
    spinorOuter psi psi = rankOneHermitian psi := by
  rfl

/--
Visible momentum with hidden overlap `k`.

`k = 0` is the orthogonal/decohered hidden-label reduction, while `k = 1`
is the fully coherent visible superposition.  Intermediate values represent
finite partial coherence in the hidden label.
-/
def partialCoherenceMomentum
    (k : Complex) (psi phi : CSpinor) : QubitDensity :=
  rankOneHermitian psi + rankOneHermitian phi +
    k • spinorOuter psi phi +
    ((starRingEnd Complex) k) • spinorOuter phi psi

/-- The hidden Gram determinant factor attached to an overlap `k`. -/
def hiddenOverlapDetFactor (k : Complex) : Complex :=
  1 - complexAbsSq k

/-- Zero hidden overlap recovers the decohered two-alternative momentum. -/
theorem partialCoherenceMomentum_zero_eq_decohered
    (psi phi : CSpinor) :
    partialCoherenceMomentum 0 psi phi =
      decoheredSpinorPairMomentum psi phi := by
  simp [partialCoherenceMomentum, decoheredSpinorPairMomentum]

/--
Unit hidden overlap recovers the coherent visible superposition.
-/
theorem partialCoherenceMomentum_one_eq_coherent
    (psi phi : CSpinor) :
    partialCoherenceMomentum 1 psi phi =
      coherentSpinorPairMomentum psi phi := by
  ext i j; simp +decide [ *, Matrix.vecMulVec, Matrix.add_apply, Matrix.smul_apply, partialCoherenceMomentum, coherentSpinorPairMomentum, spinorOuter, rankOneHermitian ] ; ring;

/--
Partial hidden coherence scales the Pluecker determinant mass by the hidden
Gram determinant factor `1 - |k|^2`.
-/
theorem partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker
    (k : Complex) (psi phi : CSpinor) :
    (partialCoherenceMomentum k psi phi).det =
      hiddenOverlapDetFactor k * complexAbsSq (spinorWedge psi phi) := by
  unfold partialCoherenceMomentum hiddenOverlapDetFactor complexAbsSq spinorWedge;
  unfold rankOneHermitian spinorOuter; norm_num [ Matrix.det_fin_two ] ; ring;
  simp +decide [ vecMulVec ] ; ring

/-- The partial-coherence formula specializes to Pluecker mass at `k = 0`. -/
theorem partialCoherenceMomentum_zero_det_eq_plucker
    (psi phi : CSpinor) :
    (partialCoherenceMomentum 0 psi phi).det =
      complexAbsSq (spinorWedge psi phi) := by
  rw [partialCoherenceMomentum_zero_eq_decohered,
    decoheredSpinorPairMomentum_det_eq_plucker]

/-- The partial-coherence formula specializes to zero mass at `k = 1`. -/
theorem partialCoherenceMomentum_one_det_eq_zero
    (psi phi : CSpinor) :
    (partialCoherenceMomentum 1 psi phi).det = 0 := by
  rw [partialCoherenceMomentum_one_eq_coherent,
    coherentSpinorPairMomentum_det_eq_zero]

/--
If the hidden overlap is a contraction, the partial-coherence determinant has
nonnegative real part.
-/
theorem partialCoherenceMomentum_det_re_nonneg_of_normSq_le_one
    (k : Complex) (psi phi : CSpinor)
    (hk : Complex.normSq k <= 1) :
    0 <= ((partialCoherenceMomentum k psi phi).det).re := by
  rw [partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker,
    hiddenOverlapDetFactor, complexAbsSq_eq_ofReal_normSq,
    complexAbsSq_eq_ofReal_normSq, ← Complex.ofReal_one, ← Complex.ofReal_sub,
    ← Complex.ofReal_mul, Complex.ofReal_re]
  have h1 : 0 ≤ 1 - Complex.normSq k := by linarith
  exact mul_nonneg h1 (Complex.normSq_nonneg _)

end PhysicsSM.Draft.NullEdgeDecoherenceChannel

end
