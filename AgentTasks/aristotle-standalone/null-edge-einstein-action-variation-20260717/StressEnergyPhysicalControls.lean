import Mathlib

/-!
# Stress-energy boundary and weak-field/cosmological controls

This module isolates three G6-G8 facts.

First, neither of the two displayed scalar summaries determines a spacetime
stress tensor. Explicit pairs of distinct symmetric four-dimensional tensors
have either the same rest-frame energy density or the same ordinary matrix
trace. These witnesses do not rule out an artificial scalar encoding of every
component. A physical matter construction must instead specify a metric or
coframe convention and provide the corresponding full variation of the actual
matter action, including its index and measure normalization, stresses, and
fluxes, rather than identify a single channel sum with `T_mu_nu`. The symmetric
matrix argument below applies to metric variations; a coframe variation has a
different index interface.

Second, with the convention

```text
G_mu_nu = (8 pi G / c^4) T_mu_nu,
```

the standard weak-field identifications

```text
G_00 = (2 / c^2) Laplacian(Phi),   T_00 = rho c^2
```

are exactly equivalent to `Laplacian(Phi) = 4 pi G rho`. This checks the
physical constant normalization; it does not derive either weak-field
identification from null edges.

Third, for a homogeneous perfect fluid in the natural-unit continuity
convention

```text
a * d rho/da + 3 * (rho + pressure) = 0,
```

the standard dust and radiation density laws satisfy the equation exactly.
This is a cosmological conservation control, not a derivation of FLRW geometry
or the Friedmann equations.
-/

open Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls

/-! ## Scalar source budgets do not determine stress-energy -/

/-- Real covariant stress-tensor components in a fixed four-frame. -/
abbrev Stress4 := Matrix (Fin 4) (Fin 4) ℝ

/-- Rest-frame pressureless component matrix with `00` entry `rho`.
Here `rho` has energy-density units; this definition does not choose a metric. -/
def restDustStress (rho : ℝ) : Stress4 :=
  Matrix.diagonal ![rho, 0, 0, 0]

/-- Rest-frame isotropic component matrix with energy density `rho` and
pressure `p`. Positive spatial entries match covariant components in a
mostly-minus orthonormal frame; `Stress4` itself encodes no metric or
signature. -/
def restPressuredStress (rho pressure : ℝ) : Stress4 :=
  Matrix.diagonal ![rho, pressure, pressure, pressure]

/-- A spatial unit-diagonal tensor used in the trace witness. -/
def spatialTraceWitness : Stress4 :=
  Matrix.diagonal ![0, 1, 0, 0]

/-- Rest-frame `00` energy-density component. -/
def energyDensity (T : Stress4) : ℝ := T 0 0

/-- Ordinary matrix trace of a component matrix, not the metric contraction
`g^{mu nu} T_{mu nu}`. -/
def traceBudget (T : Stress4) : ℝ := T.trace

/-- Both displayed rest-frame tensors are symmetric. -/
theorem restStress_symmetric (rho pressure : ℝ) :
    (restDustStress rho).IsSymm ∧
      (restPressuredStress rho pressure).IsSymm :=
  ⟨Matrix.isSymm_diagonal _, Matrix.isSymm_diagonal _⟩

/-- Equal rest-frame energy density does not determine spatial pressure. -/
theorem energyDensity_not_stressTensor_witness :
    ∃ T1 T2 : Stress4,
      T1.IsSymm ∧ T2.IsSymm ∧
      energyDensity T1 = energyDensity T2 ∧ T1 ≠ T2 := by
  refine ⟨restDustStress 1, restPressuredStress 1 1,
    (restStress_symmetric 1 1).1, (restStress_symmetric 1 1).2, ?_, ?_⟩
  · simp [energyDensity, restDustStress, restPressuredStress]
  · intro h
    have h11 := congrFun (congrFun h 1) 1
    norm_num [restDustStress, restPressuredStress] at h11

/-- Equal values of the displayed ordinary trace do not determine the
symmetric tensor. This does not concern every possible scalar encoding. -/
theorem traceBudget_not_stressTensor_witness :
    ∃ T1 T2 : Stress4,
      T1.IsSymm ∧ T2.IsSymm ∧
      traceBudget T1 = traceBudget T2 ∧ T1 ≠ T2 := by
  refine ⟨restDustStress 1, spatialTraceWitness,
    (restStress_symmetric 1 0).1, Matrix.isSymm_diagonal _, ?_, ?_⟩
  · simp [traceBudget, restDustStress, spatialTraceWitness,
      Matrix.trace_diagonal, Fin.sum_univ_four]
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    norm_num [restDustStress, spatialTraceWitness] at h00

/-! ## Full symmetric variation determines the tensor -/

section FullMetricVariation

variable {I : Type*} [Fintype I]

/-- Finite, frame-component Frobenius pairing used as an algebraic model of a
metric first variation. It is not a functional derivative of an action and
contains no spacetime integral, volume density, locality, or covariance data. -/
def metricVariationPairing
    (T variation : Matrix I I ℝ) : ℝ :=
  Matrix.trace (Tᵀ * variation)

/-- Symmetric probe supported on an index pair. Off diagonal it varies both
mirrored components; on diagonal it gives twice the diagonal matrix unit. Thus
these probes are not a uniformly normalized basis of independent symmetric
coordinates, but the nonzero factor `2` is harmless for uniqueness over `ℝ`. -/
def symmetricProbe (i j : I) : Matrix I I ℝ := by
  classical
  exact Matrix.single i j 1 + Matrix.single j i 1

omit [Fintype I] in
/-- Every displayed probe is a symmetric metric variation. -/
theorem symmetricProbe_isSymm (i j : I) :
    (symmetricProbe i j).IsSymm := by
  classical
  unfold Matrix.IsSymm symmetricProbe
  rw [Matrix.transpose_add, Matrix.transpose_single, Matrix.transpose_single]
  abel

/-- Pairing with a symmetric probe extracts the sum of mirrored components.
For `i = j` this is `2 * T i i`, consistently with the doubled diagonal probe. -/
theorem metricVariationPairing_symmetricProbe
    (T : Matrix I I ℝ) (i j : I) :
    metricVariationPairing T (symmetricProbe i j) = T i j + T j i := by
  classical
  unfold metricVariationPairing symmetricProbe
  rw [Matrix.mul_add, Matrix.trace_add,
    Matrix.trace_mul_single, Matrix.trace_mul_single]
  simp

/-- **Full-variation uniqueness.** Two symmetric component tensors with the same
finite Frobenius response against every symmetric matrix variation are equal.
This is the identifying counterpart of the scalar-budget no-go: if an actual
metric first variation is represented by this pairing, its symmetric
coefficient tensor is unique. The theorem does not construct that variation
or establish its density factor, locality, covariance, or conservation. -/
theorem symmetricStress_unique_of_fullMetricVariation
    (T1 T2 : Matrix I I ℝ)
    (hT1 : T1.IsSymm) (hT2 : T2.IsSymm)
    (hvariation : ∀ variation : Matrix I I ℝ, variation.IsSymm ->
      metricVariationPairing T1 variation =
        metricVariationPairing T2 variation) :
    T1 = T2 := by
  classical
  ext i j
  have hprobe := hvariation (symmetricProbe i j) (symmetricProbe_isSymm i j)
  rw [metricVariationPairing_symmetricProbe,
    metricVariationPairing_symmetricProbe] at hprobe
  have hT1ij : T1 j i = T1 i j := congrFun (congrFun hT1 i) j
  have hT2ij : T2 j i = T2 i j := congrFun (congrFun hT2 i) j
  rw [hT1ij, hT2ij] at hprobe
  linarith

end FullMetricVariation

/-! ## Weak-field constant normalization -/

/-- Einstein coupling in SI-style units for the convention
`G_mu_nu = (8 pi G / c^4) T_mu_nu`. -/
def einsteinCoupling (G c : ℝ) : ℝ :=
  8 * Real.pi * G / c ^ 4

/-- Standard weak-field `00` component equation after inserting
`G_00 = 2 Laplacian(Phi) / c^2` and `T_00 = rho c^2`. It assumes a
mostly-minus-compatible reduction, a mass-density source, and zero
cosmological term; it does not derive or encode a metric. -/
def WeakFieldEinstein00 (G c rho laplacianPhi : ℝ) : Prop :=
  (2 / c ^ 2) * laplacianPhi =
    einsteinCoupling G c * (rho * c ^ 2)

/-- Newtonian Poisson equation in the same sign convention. -/
def PoissonEquation (G rho laplacianPhi : ℝ) : Prop :=
  laplacianPhi = 4 * Real.pi * G * rho

/-- **Newtonian normalization control.** For nonzero light speed, the standard
weak-field `00` equation with coupling `8 pi G / c^4` is exactly the Poisson
equation. -/
theorem weakFieldEinstein00_iff_poisson
    (G c rho laplacianPhi : ℝ) (hc : c ≠ 0) :
    WeakFieldEinstein00 G c rho laplacianPhi ↔
      PoissonEquation G rho laplacianPhi := by
  unfold WeakFieldEinstein00 PoissonEquation einsteinCoupling
  field_simp [hc]
  constructor <;> intro h <;> nlinarith

/-- The weak-field normalization has a nonzero exact witness. -/
theorem weakField_nonzero_witness :
    WeakFieldEinstein00 1 1 1 (4 * Real.pi) ∧
      PoissonEquation 1 1 (4 * Real.pi) ∧
      (4 * Real.pi : ℝ) ≠ 0 := by
  refine ⟨(weakFieldEinstein00_iff_poisson 1 1 1 (4 * Real.pi) one_ne_zero).2 ?_,
    ?_, ?_⟩
  · simp [PoissonEquation]
  · simp [PoissonEquation]
  · positivity

/-! ## FLRW continuity controls in scale-factor form -/

/-- Scale-factor form of homogeneous perfect-fluid conservation in natural
units: `a rho'(a) + 3 (rho + p) = 0`. Here `rho` is energy density in the same
units as pressure, and the reduced equation is assumed rather than derived. -/
def ScaleFactorContinuity
    (a rho pressure derivative : ℝ) : Prop :=
  a * derivative + 3 * (rho + pressure) = 0

/-- Dust density law `rho = rho0 / a^3`. -/
def dustDensity (rho0 a : ℝ) : ℝ := rho0 / a ^ 3

/-- Exact derivative of the dust density law away from `a = 0`. -/
theorem hasDerivAt_dustDensity (rho0 a : ℝ) (ha : a ≠ 0) :
    HasDerivAt (dustDensity rho0) (-3 * rho0 / a ^ 4) a := by
  unfold dustDensity
  have hq := (hasDerivAt_const a rho0).div (hasDerivAt_pow 3 a)
    (pow_ne_zero 3 ha)
  apply hq.congr_deriv
  field_simp [ha]
  ring

/-- The dust law with zero pressure satisfies homogeneous continuity. -/
theorem dust_continuity_scaleFactor
    (rho0 a derivative : ℝ) (ha : a ≠ 0)
    (hderiv : HasDerivAt (dustDensity rho0) derivative a) :
    ScaleFactorContinuity a (dustDensity rho0 a) 0 derivative := by
  have hu := (hasDerivAt_dustDensity rho0 a ha).unique hderiv
  rw [← hu]
  simp [ScaleFactorContinuity, dustDensity]
  field_simp [ha]
  ring

/-- Radiation density law `rho = rho0 / a^4`. -/
def radiationDensity (rho0 a : ℝ) : ℝ := rho0 / a ^ 4

/-- Radiation equation of state `pressure = rho / 3`. -/
def radiationPressure (rho0 a : ℝ) : ℝ :=
  radiationDensity rho0 a / 3

/-- Exact derivative of the radiation density law away from `a = 0`. -/
theorem hasDerivAt_radiationDensity (rho0 a : ℝ) (ha : a ≠ 0) :
    HasDerivAt (radiationDensity rho0) (-4 * rho0 / a ^ 5) a := by
  unfold radiationDensity
  have hq := (hasDerivAt_const a rho0).div (hasDerivAt_pow 4 a)
    (pow_ne_zero 4 ha)
  apply hq.congr_deriv
  field_simp [ha]
  ring

/-- The radiation law with `pressure = rho / 3` satisfies homogeneous
continuity. -/
theorem radiation_continuity_scaleFactor
    (rho0 a derivative : ℝ) (ha : a ≠ 0)
    (hderiv : HasDerivAt (radiationDensity rho0) derivative a) :
    ScaleFactorContinuity a (radiationDensity rho0 a)
      (radiationPressure rho0 a) derivative := by
  have hu := (hasDerivAt_radiationDensity rho0 a ha).unique hderiv
  rw [← hu]
  simp [ScaleFactorContinuity, radiationDensity, radiationPressure]
  field_simp [ha]
  ring

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.energyDensity_not_stressTensor_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.energyDensity_not_stressTensor_witness

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.traceBudget_not_stressTensor_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.traceBudget_not_stressTensor_witness

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.symmetricStress_unique_of_fullMetricVariation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.symmetricStress_unique_of_fullMetricVariation

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.weakFieldEinstein00_iff_poisson' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.weakFieldEinstein00_iff_poisson

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.dust_continuity_scaleFactor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.dust_continuity_scaleFactor

/-- info: 'PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.radiation_continuity_scaleFactor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls.radiation_continuity_scaleFactor

end PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls
