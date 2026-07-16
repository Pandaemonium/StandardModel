import PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation

/-!
# Diagonal scalar-gradient stress from coframe variation

This draft module extends the homogeneous scalar control by one coordinate
gradient along spatial direction 1.  The coordinate derivatives `velocity`
and `gradient` are held fixed in every coframe variation below.  In the same
diagonal `(+---)` chart, the oriented reduced action is

```text
S = a1*a2*a3 *
  (velocity^2/(2*lapse) - lapse*gradient^2/(2*a1^2) - lapse*potential).
```

For nonzero lapse and `a1`, this is the oriented coframe determinant times

```text
(1/2) g^00 velocity^2 + (1/2) g^11 gradient^2 - potential,
```

where `g^00=lapse^-2` and `g^11=-a1^-2`.  The four diagonal coordinate
variations yield the standard density and anisotropic pressures

```text
rho = Kt + Kx + V,
p1  = Kt + Kx - V,
p2 = p3 = Kt - Kx - V.
```

Here all volume and face factors are oriented.  For the diagonal coframe,
`det(e) = lapse*a1*a2*a3`, whereas `sqrt(-g) = |det(e)|`; identifying them
requires the positive-orientation sector.  A Lorentzian geometric reading
also requires `lapse`, `a1`, `a2`, and `a3` all to be nonzero.

With `delta S = -(1/2) sqrt(-g) T^{mu nu} delta g_{mu nu}`, a normalized
diagonal coframe response couples to `-T^mu_mu` (no sum).  Thus its orthonormal
mixed entries are `(rho,-p1,-p2,-p3)`, while the assembled matrix below records
covariant orthonormal entries `(rho,p1,p2,p3)`.

## Scope boundary

This remains a one-cell diagonal response.  It adds anisotropic stress but no
time-space off-diagonal variation, momentum flux, general spatial gradient,
graph localization, scalar equation of motion, Noether identity, or
conservation theorem.  The displayed component matrix is assembled from the
derived diagonal coefficients; it is not a full tensor variation theorem.

Provenance: clean-room reduction of the minimally coupled real scalar action
in the project `(+---)` convention, following the stress-index interface
audited for `HomogeneousScalarStressVariation`. Claim grade: `M [comp]`.
-/

open Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DiagonalScalarGradientStressVariation

open PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls
open PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation

/-- Scalar Lagrangian with one coordinate gradient along spatial direction 1. -/
def gradientScalarLagrangian
    (velocity gradient potential lapse a1 : Real) : Real :=
  velocity ^ 2 / (2 * lapse ^ 2) -
    gradient ^ 2 / (2 * a1 ^ 2) - potential

/-- Oriented one-cell action with one spatial-gradient channel. -/
def diagonalScalarGradientAction
    (velocity gradient potential lapse a1 a2 a3 : Real) : Real :=
  spatialVolume a1 a2 a3 *
    (velocity ^ 2 / (2 * lapse) -
      lapse * (gradient ^ 2 / (2 * a1 ^ 2)) - lapse * potential)

/-- Energy density with one spatial-gradient contribution. -/
def gradientRho
    (velocity gradient potential lapse a1 : Real) : Real :=
  velocity ^ 2 / (2 * lapse ^ 2) +
    gradient ^ 2 / (2 * a1 ^ 2) + potential

/-- Pressure parallel to the displayed spatial gradient. -/
def longitudinalPressure
    (velocity gradient potential lapse a1 : Real) : Real :=
  velocity ^ 2 / (2 * lapse ^ 2) +
    gradient ^ 2 / (2 * a1 ^ 2) - potential

/-- Pressure transverse to the displayed spatial gradient. -/
def transversePressure
    (velocity gradient potential lapse a1 : Real) : Real :=
  velocity ^ 2 / (2 * lapse ^ 2) -
    gradient ^ 2 / (2 * a1 ^ 2) - potential

/-- The reduced action is the oriented coframe determinant times the scalar
Lagrangian with one spatial-gradient channel. -/
theorem diagonalScalarGradientAction_eq_volume_lagrangian
    (velocity gradient potential lapse a1 a2 a3 : Real)
    (hlapse : lapse ≠ 0) (ha1 : a1 ≠ 0) :
    diagonalScalarGradientAction velocity gradient potential lapse a1 a2 a3 =
      coframeVolume lapse a1 a2 a3 *
        gradientScalarLagrangian velocity gradient potential lapse a1 := by
  unfold diagonalScalarGradientAction coframeVolume gradientScalarLagrangian
    spatialVolume
  field_simp [hlapse, ha1]

/-- Lapse variation yields minus the oriented spatial-volume factor times the
gradient-corrected energy density. -/
theorem hasDerivAt_lapse
    (velocity gradient potential lapse a1 a2 a3 : Real)
    (hlapse : lapse ≠ 0) :
    HasDerivAt
      (fun N =>
        diagonalScalarGradientAction velocity gradient potential N a1 a2 a3)
      (-spatialVolume a1 a2 a3 *
        gradientRho velocity gradient potential lapse a1)
      lapse := by
  have hkinetic : HasDerivAt
      (fun N : Real => velocity ^ 2 / (2 * N))
      (-velocity ^ 2 / (2 * lapse ^ 2)) lapse := by
    have h := (hasDerivAt_const lapse (velocity ^ 2 / 2)).div
      (hasDerivAt_id lapse) hlapse
    convert h using 1
    · funext N
      simp [div_eq_mul_inv]
      ring
    · simp [div_eq_mul_inv]
      ring
  have hgradient := (hasDerivAt_id lapse).mul_const
    (gradient ^ 2 / (2 * a1 ^ 2))
  have hpotential := (hasDerivAt_id lapse).mul_const potential
  have hinside := (hkinetic.sub hgradient).sub hpotential
  have h := hinside.const_mul (spatialVolume a1 a2 a3)
  convert h using 1
  unfold gradientRho
  ring

/-- Variation of the scale parallel to the gradient yields the longitudinal
pressure coefficient. -/
theorem hasDerivAt_scale1
    (velocity gradient potential lapse a1 a2 a3 : Real)
    (hlapse : lapse ≠ 0) (ha1 : a1 ≠ 0) :
    HasDerivAt
      (fun a =>
        diagonalScalarGradientAction velocity gradient potential lapse a a2 a3)
      (lapse * (a2 * a3) *
        longitudinalPressure velocity gradient potential lapse a1)
      a1 := by
  let constantPart : Real := velocity ^ 2 / (2 * lapse) - lapse * potential
  have hlinear := (hasDerivAt_id a1).mul_const constantPart
  have hquot : HasDerivAt
      (fun a : Real => lapse * gradient ^ 2 / (2 * a))
      (-lapse * gradient ^ 2 / (2 * a1 ^ 2)) a1 := by
    have h := (hasDerivAt_const a1 (lapse * gradient ^ 2 / 2)).div
      (hasDerivAt_id a1) ha1
    convert h using 1
    · funext a
      simp [div_eq_mul_inv]
      ring
    · simp [div_eq_mul_inv]
      ring
  have h := (hlinear.sub hquot).const_mul (a2 * a3)
  convert h using 1
  · funext a
    by_cases ha : a = 0
    · simp [ha, diagonalScalarGradientAction, spatialVolume, constantPart]
    · unfold diagonalScalarGradientAction spatialVolume
      dsimp [constantPart]
      field_simp [ha, hlapse]
      ring
  · unfold longitudinalPressure
    dsimp [constantPart]
    field_simp [ha1, hlapse]
    ring

/-- Variation of the second scale yields the first transverse-pressure
coefficient. -/
theorem hasDerivAt_scale2
    (velocity gradient potential lapse a1 a2 a3 : Real)
    (hlapse : lapse ≠ 0) (ha1 : a1 ≠ 0) :
    HasDerivAt
      (fun a =>
        diagonalScalarGradientAction velocity gradient potential lapse a1 a a3)
      (lapse * (a1 * a3) *
        transversePressure velocity gradient potential lapse a1)
      a2 := by
  have h := (hasDerivAt_id a2).mul_const
    (a1 * a3 *
      (velocity ^ 2 / (2 * lapse) -
        lapse * (gradient ^ 2 / (2 * a1 ^ 2)) - lapse * potential))
  convert h using 1
  · funext a
    simp only [diagonalScalarGradientAction, spatialVolume, id_eq]
    ring
  · unfold transversePressure
    field_simp [ha1, hlapse]

/-- Variation of the third scale yields the second transverse-pressure
coefficient. -/
theorem hasDerivAt_scale3
    (velocity gradient potential lapse a1 a2 a3 : Real)
    (hlapse : lapse ≠ 0) (ha1 : a1 ≠ 0) :
    HasDerivAt
      (fun a =>
        diagonalScalarGradientAction velocity gradient potential lapse a1 a2 a)
      (lapse * (a1 * a2) *
        transversePressure velocity gradient potential lapse a1)
      a3 := by
  have h := (hasDerivAt_id a3).mul_const
    (a1 * a2 *
      (velocity ^ 2 / (2 * lapse) -
        lapse * (gradient ^ 2 / (2 * a1 ^ 2)) - lapse * potential))
  convert h using 1
  · funext a
    simp only [diagonalScalarGradientAction, spatialVolume, id_eq]
    ring
  · unfold transversePressure
    field_simp [ha1, hlapse]

/-- Packet of all four diagonal response identities in the one-gradient
sector. -/
def DiagonalGradientCoframeResponse
    (velocity gradient potential lapse a1 a2 a3 : Real) : Prop :=
  HasDerivAt
      (fun N =>
        diagonalScalarGradientAction velocity gradient potential N a1 a2 a3)
      (-spatialVolume a1 a2 a3 *
        gradientRho velocity gradient potential lapse a1)
      lapse ∧
    HasDerivAt
      (fun a =>
        diagonalScalarGradientAction velocity gradient potential lapse a a2 a3)
      (lapse * (a2 * a3) *
        longitudinalPressure velocity gradient potential lapse a1)
      a1 ∧
    HasDerivAt
      (fun a =>
        diagonalScalarGradientAction velocity gradient potential lapse a1 a a3)
      (lapse * (a1 * a3) *
        transversePressure velocity gradient potential lapse a1)
      a2 ∧
    HasDerivAt
      (fun a =>
        diagonalScalarGradientAction velocity gradient potential lapse a1 a2 a)
      (lapse * (a1 * a2) *
        transversePressure velocity gradient potential lapse a1)
      a3

/-- All four diagonal variations of the one-gradient action yield the stated
energy and anisotropic-pressure coefficients. -/
theorem diagonalVariations_recover_gradient_stress
    (velocity gradient potential lapse a1 a2 a3 : Real)
    (hlapse : lapse ≠ 0) (ha1 : a1 ≠ 0) :
    DiagonalGradientCoframeResponse velocity gradient potential lapse a1 a2 a3 :=
  ⟨hasDerivAt_lapse velocity gradient potential lapse a1 a2 a3 hlapse,
    hasDerivAt_scale1 velocity gradient potential lapse a1 a2 a3 hlapse ha1,
    hasDerivAt_scale2 velocity gradient potential lapse a1 a2 a3 hlapse ha1,
    hasDerivAt_scale3 velocity gradient potential lapse a1 a2 a3 hlapse ha1⟩

/-- Assembled covariant orthonormal components in the one-gradient frame. -/
def diagonalGradientStress
    (velocity gradient potential lapse a1 : Real) : Stress4 :=
  Matrix.diagonal ![
    gradientRho velocity gradient potential lapse a1,
    longitudinalPressure velocity gradient potential lapse a1,
    transversePressure velocity gradient potential lapse a1,
    transversePressure velocity gradient potential lapse a1]

/-- The assembled component matrix is symmetric and carries the derived
longitudinal/transverse split. -/
theorem diagonalGradientStress_components
    (velocity gradient potential lapse a1 : Real) :
    (diagonalGradientStress velocity gradient potential lapse a1).IsSymm ∧
      diagonalGradientStress velocity gradient potential lapse a1 0 0 =
        gradientRho velocity gradient potential lapse a1 ∧
      diagonalGradientStress velocity gradient potential lapse a1 1 1 =
        longitudinalPressure velocity gradient potential lapse a1 ∧
      diagonalGradientStress velocity gradient potential lapse a1 2 2 =
        transversePressure velocity gradient potential lapse a1 ∧
      diagonalGradientStress velocity gradient potential lapse a1 3 3 =
        transversePressure velocity gradient potential lapse a1 := by
  simp [diagonalGradientStress, Matrix.isSymm_diagonal]

/-- Nonzero positive-chart witness with genuinely anisotropic pressure:
`rho=5`, `p1=3`, and `p2=p3=-1`. -/
theorem anisotropic_gradient_variation_witness :
    gradientRho 2 2 1 1 1 = 5 ∧
      longitudinalPressure 2 2 1 1 1 = 3 ∧
      transversePressure 2 2 1 1 1 = -1 ∧
      diagonalGradientStress 2 2 1 1 1 ≠ 0 ∧
      DiagonalGradientCoframeResponse 2 2 1 1 1 1 1 := by
  refine ⟨by norm_num [gradientRho],
    by norm_num [longitudinalPressure],
    by norm_num [transversePressure], ?_,
    diagonalVariations_recover_gradient_stress 2 2 1 1 1 1 1
      one_ne_zero one_ne_zero⟩
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num [diagonalGradientStress, gradientRho] at h00

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.DiagonalScalarGradientStressVariation.diagonalVariations_recover_gradient_stress' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DiagonalScalarGradientStressVariation.diagonalVariations_recover_gradient_stress

/-- info: 'PhysicsSM.Draft.NullEdge.DiagonalScalarGradientStressVariation.anisotropic_gradient_variation_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DiagonalScalarGradientStressVariation.anisotropic_gradient_variation_witness

end PhysicsSM.Draft.NullEdge.DiagonalScalarGradientStressVariation
