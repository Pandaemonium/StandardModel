import PhysicsSM.Draft.NullEdge.DiagonalScalarGradientStressVariation

/-!
# Scalar momentum flux from an ADM-shift variation

This draft module adds one off-diagonal coframe response to the scalar controls.
Use the `(+---)` coframe

```text
theta^0 = lapse dt,
theta^1 = a1 (dx1 + shift dt),
theta^2 = a2 dx2,
theta^3 = a3 dx3.
```

For coordinate derivatives `velocity = partial_t phi` and
`gradient = partial_1 phi`, the derivative along the unit normal is

```text
normalVelocity / lapse = (velocity - shift * gradient) / lapse.
```

Holding all coordinate derivatives and diagonal coframe scales fixed, the
oriented reduced scalar action is

```text
S = a1*a2*a3 *
  (normalVelocity^2/(2*lapse)
    - lapse*gradient^2/(2*a1^2) - lapse*potential).
```

Its shift derivative is minus the sign-defined canonical momentum density

```text
a1*a2*a3 * gradient * normalVelocity / lapse.
```

For nonzero `lapse` and `a1`, this is `a1^2*a2*a3` times the covariant
orthonormal flux

```text
T_(hat 0)(hat 1) = (normalVelocity/lapse) * (gradient/a1).
```

All volume factors remain oriented.  The assembled matrix records covariant
orthonormal components; its diagonal entries reuse the one-gradient response
with `normalVelocity` in place of the unshifted coordinate velocity.

## Scope boundary

This is a one-cell scalar calculation in an already supplied ADM coframe.  It
does not derive the shift, coframe, scalar action, graph localization, a full
arbitrary-coframe stress variation, a matter equation of motion, or stress
conservation from null edges.  It supplies one genuine off-diagonal response
and its exact tensor-component normalization.

Provenance: clean-room ADM reduction of the minimally coupled real scalar
action in the project `(+---)` convention. Claim grade: `M [comp]`.
-/

open Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ADMShiftScalarFluxVariation

open PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls
open PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation
open PhysicsSM.Draft.NullEdge.DiagonalScalarGradientStressVariation

/-- Coordinate scalar velocity corrected by the displayed ADM shift. -/
def normalCoordinateVelocity
    (velocity gradient shift : Real) : Real :=
  velocity - shift * gradient

/-- Oriented one-cell scalar action in the one-direction ADM-shift chart. -/
def shiftedScalarAction
    (velocity gradient potential lapse a1 a2 a3 shift : Real) : Real :=
  spatialVolume a1 a2 a3 *
    (normalCoordinateVelocity velocity gradient shift ^ 2 / (2 * lapse) -
      lapse * (gradient ^ 2 / (2 * a1 ^ 2)) - lapse * potential)

/-- Canonical momentum density conjugate to the displayed shift, defined with
the sign opposite to the action response in the chosen coframe convention.
This terminology does not assert that its numerical value is nonnegative. -/
def canonicalShiftMomentumDensity
    (velocity gradient lapse a1 a2 a3 shift : Real) : Real :=
  spatialVolume a1 a2 a3 * gradient *
    normalCoordinateVelocity velocity gradient shift / lapse

/-- Covariant orthonormal scalar momentum flux in the displayed direction. -/
def orthonormalScalarFlux
    (velocity gradient lapse a1 shift : Real) : Real :=
  (normalCoordinateVelocity velocity gradient shift / lapse) * (gradient / a1)

/-- Varying the ADM shift gives minus the canonical scalar momentum density. -/
theorem hasDerivAt_shift
    (velocity gradient potential lapse a1 a2 a3 shift : Real)
    (hlapse : lapse ≠ 0) :
    HasDerivAt
      (fun beta =>
        shiftedScalarAction velocity gradient potential lapse a1 a2 a3 beta)
      (-canonicalShiftMomentumDensity velocity gradient lapse a1 a2 a3 shift)
      shift := by
  have hnormal : HasDerivAt
      (fun beta : Real => velocity - beta * gradient)
      (-gradient) shift := by
    simpa using (hasDerivAt_const shift velocity).sub
      ((hasDerivAt_id shift).mul_const gradient)
  have hkinetic := (hnormal.pow 2).mul_const (1 / (2 * lapse))
  have hinside := hkinetic.sub_const
    (lapse * (gradient ^ 2 / (2 * a1 ^ 2)) + lapse * potential)
  have h := hinside.const_mul (spatialVolume a1 a2 a3)
  convert h using 1
  · funext beta
    simp only [shiftedScalarAction, normalCoordinateVelocity, Pi.pow_apply]
    ring
  · unfold canonicalShiftMomentumDensity normalCoordinateVelocity
    field_simp [hlapse]
    ring

/-- At zero shift, the response is the expected velocity-gradient product. -/
theorem hasDerivAt_shift_zero
    (velocity gradient potential lapse a1 a2 a3 : Real)
    (hlapse : lapse ≠ 0) :
    HasDerivAt
      (fun beta =>
        shiftedScalarAction velocity gradient potential lapse a1 a2 a3 beta)
      (-(spatialVolume a1 a2 a3 * gradient * velocity / lapse))
      0 := by
  simpa [canonicalShiftMomentumDensity, normalCoordinateVelocity] using
    hasDerivAt_shift velocity gradient potential lapse a1 a2 a3 0 hlapse

/-- The canonical shift momentum and covariant orthonormal flux differ by
exactly the oriented coframe conversion factor `a1^2*a2*a3`. -/
theorem canonicalShiftMomentumDensity_eq_flux
    (velocity gradient lapse a1 a2 a3 shift : Real)
    (hlapse : lapse ≠ 0) (ha1 : a1 ≠ 0) :
    canonicalShiftMomentumDensity velocity gradient lapse a1 a2 a3 shift =
      a1 ^ 2 * a2 * a3 *
        orthonormalScalarFlux velocity gradient lapse a1 shift := by
  unfold canonicalShiftMomentumDensity orthonormalScalarFlux spatialVolume
  field_simp [hlapse, ha1]

/-- Covariant orthonormal scalar components in the shifted one-gradient
frame.  This matrix packages the separately derived diagonal and shift
responses; it is not a full arbitrary-coframe variation theorem. -/
def shiftedGradientStress
    (velocity gradient potential lapse a1 shift : Real) : Stress4 :=
  diagonalGradientStress
      (normalCoordinateVelocity velocity gradient shift)
      gradient potential lapse a1 +
    orthonormalScalarFlux velocity gradient lapse a1 shift •
      symmetricProbe (0 : Fin 4) (1 : Fin 4)

/-- The assembled shifted scalar matrix is symmetric and has the derived
time-space flux in both mirrored entries. -/
theorem shiftedGradientStress_components
    (velocity gradient potential lapse a1 shift : Real) :
    (shiftedGradientStress velocity gradient potential lapse a1 shift).IsSymm ∧
      shiftedGradientStress velocity gradient potential lapse a1 shift 0 1 =
        orthonormalScalarFlux velocity gradient lapse a1 shift ∧
      shiftedGradientStress velocity gradient potential lapse a1 shift 1 0 =
        orthonormalScalarFlux velocity gradient lapse a1 shift ∧
      shiftedGradientStress velocity gradient potential lapse a1 shift 0 0 =
        gradientRho (normalCoordinateVelocity velocity gradient shift)
          gradient potential lapse a1 := by
  refine
    ⟨(Matrix.isSymm_diagonal _).add
        ((symmetricProbe_isSymm (0 : Fin 4) (1 : Fin 4)).smul _), ?_, ?_, ?_⟩
  all_goals
    simp [shiftedGradientStress, diagonalGradientStress, symmetricProbe]

/-- Exact positive-chart witness with nonzero scalar momentum flux and a
nontrivial shift derivative. -/
theorem nonzero_shift_flux_witness :
    orthonormalScalarFlux 1 1 1 1 0 = 1 ∧
      canonicalShiftMomentumDensity 1 1 1 1 1 1 0 = 1 ∧
      HasDerivAt
        (fun beta => shiftedScalarAction 1 1 0 1 1 1 1 beta)
        (-1) 0 ∧
      shiftedGradientStress 1 1 0 1 1 0 0 1 = 1 := by
  refine ⟨by norm_num [orthonormalScalarFlux, normalCoordinateVelocity],
    by norm_num [canonicalShiftMomentumDensity, normalCoordinateVelocity,
      spatialVolume], ?_, ?_⟩
  · simpa [spatialVolume] using
      hasDerivAt_shift_zero 1 1 0 1 1 1 1 one_ne_zero
  · norm_num [shiftedGradientStress, diagonalGradientStress,
      orthonormalScalarFlux, normalCoordinateVelocity, symmetricProbe]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ADMShiftScalarFluxVariation.hasDerivAt_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ADMShiftScalarFluxVariation.hasDerivAt_shift

/-- info: 'PhysicsSM.Draft.NullEdge.ADMShiftScalarFluxVariation.nonzero_shift_flux_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ADMShiftScalarFluxVariation.nonzero_shift_flux_witness

end PhysicsSM.Draft.NullEdge.ADMShiftScalarFluxVariation
