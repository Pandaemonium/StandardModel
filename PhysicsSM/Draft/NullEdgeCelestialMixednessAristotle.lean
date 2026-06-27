import Mathlib
import PhysicsSM.Spinor.PluckerMass
import PhysicsSM.Spinor.TwistorPluckerMass
import PhysicsSM.Draft.SpinCoherentCollapseAristotle
import PhysicsSM.Draft.NullEdgePhysicsBridgeAristotle

/-!
# Draft.NullEdgeCelestialMixednessAristotle

Large Aristotle handoff for the next finite physics bridge in the null-edge
causal graph program.

This file targets the most important "real physics" sharpening suggested by
the recent research notes: visible mass should be read as a finite reduced
state mixedness / Pluecker-spread invariant, not merely as a graph slogan.

Mathematical intent:

* `blochDensity r = (1 + sigma.r) / 2` packages a visible two-state density.
  Its determinant is `(1 - |r|^2) / 4`, and its normalized linear entropy is
  `4 det`.
* A pair of unit celestial directions has determinant mass
  `(1 - a.b) / 2`, so finite two-edge mass is exactly angular separation.
* A finite internal or generation label contributes to the visible mass only
  through the visible spinor family after labels are traced out / forgotten.
  The Pluecker sum is therefore the finite, decohered reduced-density
  mixedness.
* The twistor-chart version is the same statement through the already trusted
  multi-twistor Pluecker wrappers.

Claim boundary:

* this is a finite density-matrix reformulation of the trusted P1 Pluecker-mass
  core (`PhysicsSM.Spinor.PluckerMass`), recasting `det(sum_i psi_i psi_i^dagger)`
  as visible reduced-state mixedness.  It is a finite identity / finite
  reconstruction, **not** a mass-spectrum prediction and not a QCD, Higgs,
  Yukawa, or Standard Model mass claim;
* no continuum limit, scattering amplitude, or Penrose transform is asserted;
* no nonorthogonal partial trace theorem is asserted here;
* the reduced-density statements model the orthogonal/decohered internal-label
  case where visible alternatives add as `sum_i psi_i psi_i^dagger`;
* this is draft code for Aristotle proof search.

Aristotle handoff:

* Fill the proof holes without weakening statements.
* Helper lemmas in this file are welcome.
* Prefer entrywise `Fin 2` computations and existing imported theorems:
  `det_spinProjector`, `trace_spinProjector`, `trace_spinProjector_pair`,
  `spinProjector_add_antipodal`,
  `fin_bundle_det_eq_ofReal_pluckerMassReal`,
  `fin_bundle_mass_zero_iff_common_direction`,
  `multi_twistor_momentum_det_eq_pairwiseMass`, and
  `multiTwistorMassSqDetConvention_eq_zero_iff_common_pi_direction`.
* Do not add forbidden placeholder declarations or hidden assumptions.
* Do not use kernel-bypassing evaluators.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeCelestialMixedness

open BigOperators
open Matrix Complex
open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Spinor.TwistorPluckerMass
open PhysicsSM.Draft.SpinCoherentProjector
open PhysicsSM.Draft.SpinCoherentCollapse
open PhysicsSM.Draft.NullEdgePhysicsBridge

/-! ## 1. Bloch-density determinant and mixedness -/

/-- A real Bloch vector.  Unit vectors represent pure celestial directions. -/
abbrev BlochVector := Fin 3 -> Real

/-- A visible `2 x 2` complex density/momentum matrix. -/
abbrev QubitDensity := Matrix (Fin 2) (Fin 2) Complex

/--
The finite visible density carried by a Bloch vector:
`rho(r) = (1 + sigma.r) / 2`.
-/
def blochDensity (r : BlochVector) : QubitDensity :=
  spinProjector r

/-- The real purity proxy `Re tr(rho^2)`. -/
def blochPurity (r : BlochVector) : Real :=
  (Matrix.trace (blochDensity r * blochDensity r)).re

/-- Normalized qubit linear entropy: `2 * (1 - tr(rho^2))`. -/
def blochLinearEntropy (r : BlochVector) : Real :=
  2 * (1 - blochPurity r)

/-- Wrapper: the Bloch density is the coherent spin projector. -/
theorem blochDensity_eq_spinProjector (r : BlochVector) :
    blochDensity r = spinProjector r := by
  rfl

/-- Every Bloch density in this convention has trace `1`. -/
theorem blochDensity_trace (r : BlochVector) :
    Matrix.trace (blochDensity r) = 1 := by
  exact trace_spinProjector r

/--
The determinant of a Bloch density is the finite mixedness defect
`(1 - |r|^2) / 4`.
-/
theorem blochDensity_det_eq_one_sub_radius_sq (r : BlochVector) :
    (blochDensity r).det =
      (((1 - dot3 r r) / 4 : Real) : Complex) := by
  unfold blochDensity spinProjector pauliVec;
  norm_num [ Matrix.det_fin_two, pauliX, pauliY, pauliZ, dot3 ];
  ring ; norm_num

/--
The squared trace/purity identity for a Bloch density.
-/
theorem blochDensity_trace_square_eq_radius_sq (r : BlochVector) :
    Matrix.trace (blochDensity r * blochDensity r) =
      (((1 + dot3 r r) / 2 : Real) : Complex) := by
  unfold blochDensity;
  unfold spinProjector pauliVec;
  norm_num [ Matrix.trace, Matrix.mul_apply, pauliX, pauliY, pauliZ ] ; ring;
  unfold dot3; norm_num [ Complex.ext_iff, sq ] ; ring;

/-- Real purity is `(1 + |r|^2) / 2`. -/
theorem blochDensity_purity_eq_radius_sq (r : BlochVector) :
    blochPurity r = (1 + dot3 r r) / 2 := by
  unfold blochPurity
  rw [blochDensity_trace_square_eq_radius_sq, Complex.ofReal_re]

/--
For a qubit Bloch density, normalized linear entropy is exactly `4 det`.
This is the finite "mass as visible mixedness" identity.
-/
theorem blochDensity_linearEntropy_eq_four_det (r : BlochVector) :
    blochLinearEntropy r = 4 * ((blochDensity r).det).re := by
  unfold blochLinearEntropy
  rw [blochDensity_purity_eq_radius_sq, blochDensity_det_eq_one_sub_radius_sq,
    Complex.ofReal_re]
  ring

/-- The Bloch density is determinant-massless exactly on the unit sphere. -/
theorem blochDensity_massless_iff_unit_radius (r : BlochVector) :
    (blochDensity r).det = 0 <-> dot3 r r = 1 := by
  rw [blochDensity_det_eq_one_sub_radius_sq, Complex.ofReal_eq_zero]
  constructor
  · intro h; linarith
  · intro h; rw [h]; ring

/--
The zero Bloch vector is the maximally mixed density.
-/
theorem blochDensity_zero_vector_eq_half_identity :
    blochDensity (fun _ : Fin 3 => 0) =
      ((1 : Complex) / 2) • (1 : QubitDensity) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [blochDensity, spinProjector, pauliVec, pauliX, pauliY, pauliZ]

/-- Averaging antipodal celestial directions gives the maximally mixed density. -/
theorem blochDensity_antipodal_average_eq_half_identity (r : BlochVector) :
    ((1 : Complex) / 2) • (blochDensity r + blochDensity (-r)) =
      ((1 : Complex) / 2) • (1 : QubitDensity) := by
  unfold blochDensity
  rw [spinProjector_add_antipodal]

/-! ## 2. Two celestial directions and angular mass -/

/-- Momentum/density carried by two visible celestial directions. -/
def coherentPairMomentum (a b : BlochVector) : QubitDensity :=
  blochDensity a + blochDensity b

/-- A two-direction visible momentum has trace `2`. -/
theorem coherentPairMomentum_trace (a b : BlochVector) :
    Matrix.trace (coherentPairMomentum a b) = 2 := by
  unfold coherentPairMomentum
  rw [Matrix.trace_add, blochDensity_trace, blochDensity_trace]
  norm_num

/--
For unit celestial directions, the two-edge determinant mass is exactly
half the angular separation invariant `1 - a.b`.
-/
theorem coherentPairMomentum_det_eq_angular_separation
    (a b : BlochVector) (ha : dot3 a a = 1) (hb : dot3 b b = 1) :
    (coherentPairMomentum a b).det =
      (((1 - dot3 a b) / 2 : Real) : Complex) := by
  unfold coherentPairMomentum;
  unfold blochDensity;
  unfold spinProjector pauliVec;
  unfold pauliX pauliY pauliZ dot3 at *;
  norm_num [ Complex.ext_iff, Matrix.det_fin_two ] ; ring;
  grind

/-- The two-direction massless locus is the parallel celestial locus. -/
theorem coherentPairMomentum_massless_iff_parallel
    (a b : BlochVector) (ha : dot3 a a = 1) (hb : dot3 b b = 1) :
    (coherentPairMomentum a b).det = 0 <-> dot3 a b = 1 := by
  rw [coherentPairMomentum_det_eq_angular_separation a b ha hb,
    Complex.ofReal_eq_zero]
  constructor
  · intro h; linarith
  · intro h; rw [h]; ring

/-- Antipodal visible directions sum to the identity momentum. -/
theorem coherentPairMomentum_antipodal_identity (a : BlochVector) :
    coherentPairMomentum a (-a) = 1 := by
  unfold coherentPairMomentum blochDensity
  exact spinProjector_add_antipodal a

/-- Antipodal unit directions give unit determinant: the finite rest-frame pair.

The unit hypothesis `ha` is retained to document the physical rest-frame
setting, but it is not needed: antipodal projectors resolve the identity for
any `a`, so the determinant is `1` unconditionally. -/
theorem coherentPairMomentum_antipodal_rest_det
    (a : BlochVector) (_ha : dot3 a a = 1) :
    (coherentPairMomentum a (-a)).det = 1 := by
  rw [coherentPairMomentum_antipodal_identity]
  exact Matrix.det_one

/-- A unit coherent projector is a visible rank-one Hermitian momentum. -/
theorem unit_blochDensity_is_rankOneHermitian
    (a : BlochVector) (ha : dot3 a a = 1) :
    exists psi : CSpinor, blochDensity a = rankOneHermitian psi := by
  obtain ⟨v, hv⟩ := exists_rankOne_spinProjector a ha
  exact ⟨v, hv⟩

/-! ## 3. Visible reduced density from internal alternatives -/

/--
The reduced visible density in the orthogonal/decohered internal-label case:
trace out the internal label, leaving the sum of visible rank-one momenta.
-/
def visibleReducedDensity {n : Nat} (psi : Fin n -> CSpinor) : QubitDensity :=
  finBundleMomentum psi

/-- Trace of the unnormalized reduced visible density. -/
def visibleTrace {n : Nat} (psi : Fin n -> CSpinor) : Complex :=
  Matrix.trace (visibleReducedDensity psi)

/-- Projective normalization of the reduced visible density. -/
def normalizedVisibleDensity {n : Nat} (psi : Fin n -> CSpinor) : QubitDensity :=
  (visibleTrace psi)⁻¹ • visibleReducedDensity psi

/-- Wrapper identifying the reduced density with the trusted bundle momentum. -/
theorem visibleReducedDensity_eq_finBundleMomentum
    {n : Nat} (psi : Fin n -> CSpinor) :
    visibleReducedDensity psi = finBundleMomentum psi := by
  rfl

/--
The determinant of the reduced visible density is the real Pluecker spread.
This is the clean finite replacement for "mass is hidden-label mixedness".
-/
theorem visibleReducedDensity_det_eq_plucker
    {n : Nat} (psi : Fin n -> CSpinor) :
    (visibleReducedDensity psi).det =
      (finPairwisePluckerMassReal psi : Complex) := by
  exact fin_bundle_det_eq_ofReal_pluckerMassReal psi

/-- The visible reduced determinant has nonnegative real part. -/
theorem visibleReducedDensity_det_re_nonneg
    {n : Nat} (psi : Fin n -> CSpinor) :
    0 <= ((visibleReducedDensity psi).det).re := by
  exact fin_bundle_det_re_nonneg psi

/-- Reduced visible masslessness is common visible projective direction. -/
theorem visibleReducedDensity_mass_zero_iff_common_direction
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (hbase : psi base 0 != 0 \/ psi base 1 != 0) :
    (visibleReducedDensity psi).det = 0 <->
      exists c : Fin n -> Complex,
        forall i : Fin n, psi i = c i • psi base := by
  have hbase' : psi base 0 ≠ 0 ∨ psi base 1 ≠ 0 := by
    rcases hbase with h | h
    · exact Or.inl (by simpa using h)
    · exact Or.inr (by simpa using h)
  exact fin_bundle_mass_zero_iff_common_direction psi base hbase'

/-- Determinant of the normalized visible density scales by trace squared. -/
theorem normalizedVisibleDensity_det_eq_det_div_trace_sq
    {n : Nat} (psi : Fin n -> CSpinor) :
    (normalizedVisibleDensity psi).det =
      (visibleReducedDensity psi).det / (visibleTrace psi) ^ 2 := by
  unfold normalizedVisibleDensity
  rw [Matrix.det_smul, Fintype.card_fin]
  ring

/-- Normalized visible determinant as Pluecker spread divided by trace squared. -/
theorem normalizedVisibleDensity_det_eq_plucker_over_trace_sq
    {n : Nat} (psi : Fin n -> CSpinor) :
    (normalizedVisibleDensity psi).det =
      (finPairwisePluckerMassReal psi : Complex) / (visibleTrace psi) ^ 2 := by
  rw [normalizedVisibleDensity_det_eq_det_div_trace_sq,
    visibleReducedDensity_det_eq_plucker]

/--
The normalized reduced visible density `rho = P / tr(P)` is a genuine
trace-one density matrix, provided the visible trace is nonzero.  This is the
finite normalization that turns the unnormalized Pluecker momentum `P` into a
bona fide visible celestial state.
-/
theorem normalizedVisibleDensity_trace
    {n : Nat} (psi : Fin n -> CSpinor) (h : visibleTrace psi != 0) :
    Matrix.trace (normalizedVisibleDensity psi) = 1 := by
  have h' : visibleTrace psi ≠ 0 := by simpa using h
  unfold normalizedVisibleDensity
  rw [Matrix.trace_smul, smul_eq_mul]
  change (visibleTrace psi)⁻¹ * visibleTrace psi = 1
  exact inv_mul_cancel₀ h'

/-! ## 4. Generation/internal-label blindness -/

/-- A visible alternative decorated by an internal or generation label. -/
structure LabeledVisibleAlternative (Label : Type*) where
  visible : CSpinor
  label : Label

/-- Reduced visible density after forgetting internal labels. -/
def labeledVisibleReducedDensity {Label : Type*} {n : Nat}
    (x : Fin n -> LabeledVisibleAlternative Label) : QubitDensity :=
  visibleReducedDensity fun i => (x i).visible

/-- Visible determinant mass after forgetting internal labels. -/
def labeledVisibleMass {Label : Type*} {n : Nat}
    (x : Fin n -> LabeledVisibleAlternative Label) : Complex :=
  (labeledVisibleReducedDensity x).det

/-- Relabel internal/generation data without changing visible spinors. -/
def relabelVisibleAlternatives {Label Label' : Type*} {n : Nat}
    (f : Label -> Label')
    (x : Fin n -> LabeledVisibleAlternative Label) :
    Fin n -> LabeledVisibleAlternative Label' :=
  fun i => { visible := (x i).visible, label := f (x i).label }

/-- The reduced visible density depends only on visible spinors, not labels. -/
theorem labeledVisibleReducedDensity_eq_of_same_visible
    {Label Label' : Type*} {n : Nat}
    (x : Fin n -> LabeledVisibleAlternative Label)
    (y : Fin n -> LabeledVisibleAlternative Label')
    (h : forall i : Fin n, (x i).visible = (y i).visible) :
    labeledVisibleReducedDensity x = labeledVisibleReducedDensity y := by
  unfold labeledVisibleReducedDensity
  exact congrArg visibleReducedDensity (funext h)

/-- Relabeling internal data leaves the reduced visible density unchanged. -/
theorem labeledVisibleReducedDensity_relabel
    {Label Label' : Type*} {n : Nat} (f : Label -> Label')
    (x : Fin n -> LabeledVisibleAlternative Label) :
    labeledVisibleReducedDensity (relabelVisibleAlternatives f x) =
      labeledVisibleReducedDensity x := by
  rfl

/-- Relabeling internal data leaves the determinant mass unchanged. -/
theorem labeledVisibleMass_relabel
    {Label Label' : Type*} {n : Nat} (f : Label -> Label')
    (x : Fin n -> LabeledVisibleAlternative Label) :
    labeledVisibleMass (relabelVisibleAlternatives f x) =
      labeledVisibleMass x := by
  unfold labeledVisibleMass
  rw [labeledVisibleReducedDensity_relabel]

/-- Labeled visible mass is exactly the Pluecker mass of the visible family. -/
theorem labeledVisibleMass_eq_plucker
    {Label : Type*} {n : Nat}
    (x : Fin n -> LabeledVisibleAlternative Label) :
    labeledVisibleMass x =
      (finPairwisePluckerMassReal (fun i => (x i).visible) : Complex) := by
  unfold labeledVisibleMass
  exact visibleReducedDensity_det_eq_plucker _

/-! ## 5. Twistor-chart reduced-density wrappers -/

/-- Visible reduced density carried by a finite twistor chart. -/
def twistorVisibleReducedDensity {n : Nat}
    (Z : MultiTwistorChart n) : QubitDensity :=
  multiTwistorMomentum Z

/-- Twistor reduced determinant equals pairwise infinity-twistor mass. -/
theorem twistorVisibleReducedDensity_det_eq_pairwiseMass
    {n : Nat} (Z : MultiTwistorChart n) :
    (twistorVisibleReducedDensity Z).det =
      multiTwistorPairwiseMass Z := by
  exact multi_twistor_momentum_det_eq_pairwiseMass Z

/-- Twistor reduced masslessness is common visible pi-spinor direction. -/
theorem twistorVisibleReducedDensity_mass_zero_iff_common_pi_direction
    {n : Nat} (Z : MultiTwistorChart n) (base : Fin n)
    (hbase : (Z.twistor base).pi 0 != 0 \/
      (Z.twistor base).pi 1 != 0) :
    (twistorVisibleReducedDensity Z).det = 0 <->
      exists c : Fin n -> Complex,
        forall i : Fin n,
          (Z.twistor i).pi = c i • (Z.twistor base).pi := by
  have hbase' : (Z.twistor base).pi 0 ≠ 0 ∨ (Z.twistor base).pi 1 ≠ 0 := by
    rcases hbase with h | h
    · exact Or.inl (by simpa using h)
    · exact Or.inr (by simpa using h)
  exact multiTwistorMassSqDetConvention_eq_zero_iff_common_pi_direction Z base hbase'

end PhysicsSM.Draft.NullEdgeCelestialMixedness

end
