import Mathlib.Tactic
import PhysicsSM.Draft.NullEdgeP1SL2Frame
import PhysicsSM.Draft.NullEdgeGramWeightedMassAristotle
import PhysicsSM.Draft.NullEdgeP1ObserverConditioned

/-!
# Observer-channel core for the null-edge mass conjecture

This draft module packages the finite algebra behind the sharpened
observer-channel mass conjecture.

The conjecture now separates two operations.

* A **resolution observer** traces out internal labels and produces an
  unnormalized visible block `Pvis`.  This is the object whose determinant is
  invariant mass.
* A **kinematic observer** then chooses a timelike normalization and turns
  `Pvis` into a normalized celestial qubit.  This normalized mixedness is a
  frame-relative `m / E` quantity, not a Lorentz scalar.

This file is intentionally finite and modest.  It does not formalize a full
Hilbert-space partial trace.  Instead it records the matrix-level interface
needed by the publication plan:

* boosted resolution output is congruence by `A * Pvis * A.conjTranspose`;
* determinant invariance holds for `SL(2,C)`;
* kinematic normalization is scalar filtering;
* the two-label Gram channel factors as a Plucker wedge times an internal Gram
  determinant factor;
* unital visible contractions increase the scalar mass-ratio-square, while a
  coherence-building hidden process can decrease it.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeObserverChannelCore

open Matrix Complex
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdgeP1SL2Frame
open PhysicsSM.Draft.NullEdgeGramWeightedMass
open PhysicsSM.Draft.NullEdgeDecoherenceChannel
open PhysicsSM.Draft.NullEdgeP1ObserverConditioned

/-! ## Resolution observer and boost congruence -/

/-- Visible boost action on an unnormalized resolution-observer output. -/
def boostedResolutionOutput
    (A Pvis : Matrix (Fin 2) (Fin 2) Complex) :
    Matrix (Fin 2) (Fin 2) Complex :=
  A * Pvis * A.conjTranspose

/--
The resolution output transforms by congruence.  This theorem is definitional,
but naming it prevents the normalized density from being confused with the
covariant unnormalized block.
-/
theorem visibleReduced_boost_eq_congruence
    (A Pvis : Matrix (Fin 2) (Fin 2) Complex) :
    boostedResolutionOutput A Pvis = A * Pvis * A.conjTranspose := rfl

/-- `SL(2,C)` boosts preserve the determinant of the unnormalized visible block. -/
theorem det_visibleReduced_boost_invariant
    (A Pvis : Matrix (Fin 2) (Fin 2) Complex) (hA : A.det = 1) :
    (boostedResolutionOutput A Pvis).det = Pvis.det := by
  exact sl2_congruence_det_invariant A Pvis hA

/-! ## Kinematic normalization as filtering -/

/-- Scalar kinematic normalization of a visible block by an observer energy. -/
def normalizedVisibleByEnergy
    (tau : Complex) (Pvis : Matrix (Fin 2) (Fin 2) Complex) :
    Matrix (Fin 2) (Fin 2) Complex :=
  tau⁻¹ • Pvis

/--
After a boost, normalized visible data are obtained by filtering the boosted
resolution output and then renormalizing by the chosen observer scale.
-/
theorem normalizedVisible_boost_is_filtering
    (A Pvis : Matrix (Fin 2) (Fin 2) Complex) (tau : Complex) :
    normalizedVisibleByEnergy tau (boostedResolutionOutput A Pvis) =
      tau⁻¹ • (A * Pvis * A.conjTranspose) := rfl

/--
For a `2 x 2` visible block, scalar kinematic normalization divides the
determinant by the square of the observer scale.
-/
theorem normalizedVisible_det_eq_filter_sq_mul_det
    (tau : Complex) (Pvis : Matrix (Fin 2) (Fin 2) Complex) :
    (normalizedVisibleByEnergy tau Pvis).det = (tau⁻¹) ^ 2 * Pvis.det := by
  unfold normalizedVisibleByEnergy
  simp [Matrix.det_fin_two]

/--
Scalar form of the observer-conditioned mass-ratio identity.  This reuses the
existing real theorem and keeps the frame-relative status explicit.
-/
theorem normalizedVisible_det_eq_massRatio_sq
    (m Eu : Real) (hm : 0 <= m) (hEu : 0 < Eu) :
    2 * Real.sqrt (observerConditionedDet m Eu) = m / Eu :=
  two_sqrt_observerConditionedDet_eq_mass_over_energy m Eu hm hEu

/-! ## Internal Gram channel -/

/-- The two-label Gram determinant factor is the determinant of the Gram matrix. -/
theorem twoStatePartialGram_det_eq_hiddenOverlapDetFactor (k : Complex) :
    (twoStatePartialGram k).det = hiddenOverlapDetFactor k := by
  unfold twoStatePartialGram hiddenOverlapDetFactor complexAbsSq
  simp [Matrix.det_fin_two]

/--
For two hidden labels, the resolution-observer determinant is the visible
Plucker wedge times the internal Gram determinant factor.
-/
theorem det_visibleReduced_twoLabel_eq_wedge_times_detGram
    (k : Complex) (psi phi : CSpinor) :
    (gramWeightedVisibleMomentum (twoStatePartialGram k)
        (twoStateVisibleFamily psi phi)).det =
      (twoStatePartialGram k).det * complexAbsSq (spinorWedge psi phi) := by
  rw [twoStatePartialGram_det_eq_hiddenOverlapDetFactor,
    twoStatePartialGram_det_eq_factor_mul_plucker]

/-! ## Dephasing and channel monotonicity boundaries -/

/-- Real scalar version of the internal-overlap determinant factor. -/
def internalOverlapMassFactor (r : Real) : Real :=
  1 - r ^ 2

/-- Scalar normalized visible mass-ratio-square as a function of Bloch radius. -/
def visibleMassRatioSqFromBlochRadius (r : Real) : Real :=
  1 - r ^ 2

/--
Reducing the magnitude of an internal overlap increases the visible determinant
factor.  This is the scalar dephasing direction in the two-label Gram model.
-/
theorem dephasing_internalGram_mass_monotone
    (r r' : Real) (hr0 : 0 <= r) (hr'0 : 0 <= r') (hr' : r' <= r) :
    internalOverlapMassFactor r <= internalOverlapMassFactor r' := by
  unfold internalOverlapMassFactor
  have hs : r' ^ 2 <= r ^ 2 := by
    simpa [sq] using mul_le_mul hr' hr' hr'0 hr0
  nlinarith

/--
A unital visible contraction is the safe positive monotonicity class for the
normalized mass-ratio-square.
-/
theorem unital_visibleChannel_massRatioSq_monotone
    (a r : Real) (ha0 : 0 <= a) (ha1 : a <= 1) :
    visibleMassRatioSqFromBlochRadius r <=
      visibleMassRatioSqFromBlochRadius (a * r) := by
  unfold visibleMassRatioSqFromBlochRadius
  nlinarith [mul_le_mul_of_nonneg_left ha1 (sq_nonneg r)]

/--
Strict contractions of a nonzero Bloch radius strictly increase the
mass-ratio-square.
-/
theorem strict_unital_visibleChannel_massRatioSq_increases
    (a r : Real) (_ha0 : 0 <= a) (ha1 : a < 1) (hr : r = 0 -> False) :
    visibleMassRatioSqFromBlochRadius r <
      visibleMassRatioSqFromBlochRadius (a * r) := by
  unfold visibleMassRatioSqFromBlochRadius
  exact sub_lt_sub_left
    (by nlinarith [mul_pos (sub_pos.mpr ha1) (mul_self_pos.mpr hr)]) _

/--
Toy counterexample to overbroad monotonicity claims: a coherence-building hidden
process can move a maximally mixed visible qubit to a pure visible qubit.  That
decreases the normalized mass-ratio-square from `1` to `0`, so monotonicity
cannot be advertised without naming the channel class.
-/
theorem entangling_hiddenChannel_massRatioSq_can_decrease :
    internalOverlapMassFactor 1 < internalOverlapMassFactor 0 := by
  norm_num [internalOverlapMassFactor]

end PhysicsSM.Draft.NullEdgeObserverChannelCore

end
