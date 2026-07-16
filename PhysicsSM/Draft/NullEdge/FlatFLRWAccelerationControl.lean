import PhysicsSM.Draft.NullEdge.FlatFLRWFriedmannControl

/-!
# Flat-FLRW scale variation and acceleration equation

This draft module continues the conditional flat-FLRW control from
`FlatFLRWFriedmannControl`.  It uses the same already reconstructed continuum
ansatz, signature `(+---)`, coordinate cell volume one, curvature convention,
boundary-term convention, and reduced action

```text
L = -3 a adot^2 / (8 pi G N) - Lambda N a^3 / (8 pi G)
  + a^3 (velocity^2/(2 N) - N potential).
```

The coordinate-time Euler--Lagrange convention is

```text
partial L / partial a - d/dt (partial L / partial adot) = 0.
```

Holding `N`, `adot`, the scalar coordinate velocity, and the potential fixed,
the scale partial is

```text
-3 adot^2/(8 pi G N) - 3 Lambda N a^2/(8 pi G) + 3 N a^2 p.
```

The scale momentum is `-6 a adot/(8 pi G N)`.  Their Euler--Lagrange equation
is exactly the spatial flat-FLRW equation

```text
2 D_t H + 3 H^2 = Lambda - 8 pi G p,
```

where `D_t H = (1/N) dH/dt`.  Combining this with the independently derived
lapse equation gives

```text
(1/N^2) (addot/a - adot*Ndot/(a*N))
  = Lambda/3 - (8 pi G/6) (rho + 3 p).
```

## Scope boundary

The reduced Einstein--Hilbert action, FLRW ansatz, lapse, scale factor,
Newton coupling, and cosmological constant remain continuum inputs.  These
theorems check the scale variation, pressure source, second Friedmann equation,
and constant normalization under those hypotheses.  They do not derive
Einstein dynamics or cosmology from a bare graph.

Provenance: clean-room Euler--Lagrange calculation from the reduced action and
conventions recorded in `FlatFLRWFriedmannControl`. Claim grade:
`T|H [comp/import]` for the continuum reduction and `M [comp]` for the Lean
identities.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FlatFLRWAccelerationControl

open PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation
open PhysicsSM.Draft.NullEdge.FlatFLRWFriedmannControl

/-- Partial derivative of the total reduced Lagrangian with respect to the
scale, holding the lapse and coordinate-time velocities fixed. -/
def scalePartial
    (G cosmological velocity potential lapse scale scaleVelocity : Real) : Real :=
  -3 * scaleVelocity ^ 2 / (eightPiG G * lapse) -
    3 * cosmological * lapse * scale ^ 2 / eightPiG G +
      3 * lapse * scale ^ 2 * scalarPressure velocity potential lapse

/-- Momentum conjugate to the FLRW scale in the reduced action. -/
def scaleMomentum
    (G lapse scale scaleVelocity : Real) : Real :=
  -(6 / eightPiG G) * (scale * scaleVelocity / lapse)

/-- Coordinate-time derivative of the scale momentum for displayed values of
`Ndot` and `addot`. -/
def scaleMomentumTimeDerivative
    (G lapse scale scaleVelocity lapseVelocity scaleAcceleration : Real) : Real :=
  -(6 / eightPiG G) *
    ((scaleVelocity ^ 2 + scale * scaleAcceleration) / lapse -
      scale * scaleVelocity * lapseVelocity / lapse ^ 2)

/-- Scale Euler--Lagrange residual in the convention
`partial_a L - d/dt(partial_adot L)`. -/
def scaleEulerLagrangeResidual
    (G cosmological velocity potential lapse scale scaleVelocity
      lapseVelocity scaleAcceleration : Real) : Real :=
  scalePartial G cosmological velocity potential lapse scale scaleVelocity -
    scaleMomentumTimeDerivative G lapse scale scaleVelocity lapseVelocity
      scaleAcceleration

/-- Proper-time derivative `(1/N) dH/dt` written in coordinate-time data. -/
def properHubbleDerivative
    (lapse scale scaleVelocity lapseVelocity scaleAcceleration : Real) : Real :=
  scaleAcceleration / (scale * lapse ^ 2) -
    scaleVelocity ^ 2 / (scale ^ 2 * lapse ^ 2) -
      scaleVelocity * lapseVelocity / (scale * lapse ^ 3)

/-- Covariant acceleration of the FLRW scale divided by the scale. -/
def covariantScaleAcceleration
    (lapse scale scaleVelocity lapseVelocity scaleAcceleration : Real) : Real :=
  scaleAcceleration / (scale * lapse ^ 2) -
    scaleVelocity * lapseVelocity / (scale * lapse ^ 3)

/-- The spatial flat-FLRW Einstein equation in the displayed conventions. -/
def SpatialFriedmannEquation
    (G cosmological velocity potential lapse scale scaleVelocity
      lapseVelocity scaleAcceleration : Real) : Prop :=
  2 * properHubbleDerivative lapse scale scaleVelocity lapseVelocity
        scaleAcceleration +
      3 * hubbleRate lapse scale scaleVelocity ^ 2 =
    cosmological - eightPiG G * scalarPressure velocity potential lapse

/-- The flat-FLRW acceleration equation in the displayed conventions. -/
def AccelerationEquation
    (G cosmological velocity potential lapse scale scaleVelocity
      lapseVelocity scaleAcceleration : Real) : Prop :=
  covariantScaleAcceleration lapse scale scaleVelocity lapseVelocity
      scaleAcceleration =
    cosmological / 3 -
      (eightPiG G / 6) *
        (scalarRho velocity potential lapse +
          3 * scalarPressure velocity potential lapse)

/-- Exact scale partial of gravity plus homogeneous scalar matter. -/
theorem hasDerivAt_total_scale
    (G cosmological velocity potential lapse scale scaleVelocity : Real)
    (hG : G ≠ 0) (hlapse : lapse ≠ 0) :
    HasDerivAt
      (fun a =>
        flatFLRWTotalAction G cosmological velocity potential lapse a
          scaleVelocity)
      (scalePartial G cosmological velocity potential lapse scale scaleVelocity)
      scale := by
  have hcoupling : eightPiG G ≠ 0 := by
    exact mul_ne_zero (mul_ne_zero (by norm_num) Real.pi_ne_zero) hG
  have hkinetic := (hasDerivAt_id scale).mul_const
    (-3 * scaleVelocity ^ 2 / (eightPiG G * lapse))
  have hcosmological := ((hasDerivAt_id scale).pow 3).mul_const
    (-(cosmological * lapse / eightPiG G))
  have hmatter := ((hasDerivAt_id scale).pow 3).mul_const
    (velocity ^ 2 / (2 * lapse) - lapse * potential)
  convert (hkinetic.add hcosmological).add hmatter using 1
  · funext a
    unfold flatFLRWTotalAction flatFLRWGravityAction homogeneousScalarAction
      spatialVolume
    simp only [Pi.add_apply, Pi.pow_apply, id_eq]
    field_simp [hcoupling, hlapse]
    ring
  · unfold scalePartial scalarPressure
    simp only [id_eq]
    field_simp [hcoupling, hlapse]
    ring

/-- Exact derivative of the reduced action with respect to the coordinate-time
scale velocity. -/
theorem hasDerivAt_total_scaleVelocity
    (G cosmological velocity potential lapse scale scaleVelocity : Real)
    (hG : G ≠ 0) :
    HasDerivAt
      (fun adot =>
        flatFLRWTotalAction G cosmological velocity potential lapse scale adot)
      (scaleMomentum G lapse scale scaleVelocity)
      scaleVelocity := by
  have hcoupling : eightPiG G ≠ 0 := by
    exact mul_ne_zero (mul_ne_zero (by norm_num) Real.pi_ne_zero) hG
  have h := ((hasDerivAt_id scaleVelocity).pow 2).mul_const
    (-(3 * scale / eightPiG G) / lapse)
  have htotal := h.add_const
    (-(cosmological * scale ^ 3 / eightPiG G) * lapse +
      homogeneousScalarAction velocity potential lapse scale scale scale)
  convert htotal using 1
  · funext adot
    unfold flatFLRWTotalAction flatFLRWGravityAction homogeneousScalarAction
      spatialVolume
    simp only [Pi.pow_apply, id_eq]
    ring
  · unfold scaleMomentum
    simp only [id_eq]
    field_simp [hcoupling]
    ring

/-- Along differentiable lapse, scale, and scale-velocity histories, the time
derivative of the scale momentum has the displayed explicit form. -/
theorem hasDerivAt_scaleMomentum_along
    (G : Real) (lapse scale scaleVelocity : Real → Real) (t : Real)
    (lapseVelocity scaleAcceleration : Real)
    (hG : G ≠ 0) (hlapse : lapse t ≠ 0)
    (hN : HasDerivAt lapse lapseVelocity t)
    (ha : HasDerivAt scale (scaleVelocity t) t)
    (hadot : HasDerivAt scaleVelocity scaleAcceleration t) :
    HasDerivAt
      (fun s => scaleMomentum G (lapse s) (scale s) (scaleVelocity s))
      (scaleMomentumTimeDerivative G (lapse t) (scale t) (scaleVelocity t)
        lapseVelocity scaleAcceleration)
      t := by
  have hcoupling : eightPiG G ≠ 0 := by
    exact mul_ne_zero (mul_ne_zero (by norm_num) Real.pi_ne_zero) hG
  have hquot := (ha.mul hadot).div hN hlapse
  have h := hquot.const_mul (-(6 / eightPiG G))
  convert h using 1
  unfold scaleMomentumTimeDerivative
  simp only [Pi.mul_apply]
  field_simp [hcoupling, hlapse]

/-- The proper Hubble derivative plus `H^2` is exactly the covariant scale
acceleration. -/
theorem properHubbleDerivative_add_sq
    (lapse scale scaleVelocity lapseVelocity scaleAcceleration : Real)
    (hlapse : lapse ≠ 0) (hscale : scale ≠ 0) :
    properHubbleDerivative lapse scale scaleVelocity lapseVelocity
        scaleAcceleration +
      hubbleRate lapse scale scaleVelocity ^ 2 =
    covariantScaleAcceleration lapse scale scaleVelocity lapseVelocity
      scaleAcceleration := by
  unfold properHubbleDerivative hubbleRate covariantScaleAcceleration
  field_simp [hlapse, hscale]
  ring

/-- Away from degenerate coupling, lapse, and scale, the scale
Euler--Lagrange residual vanishes exactly when the spatial Friedmann equation
holds. -/
theorem scaleResidual_zero_iff_spatialFriedmann
    (G cosmological velocity potential lapse scale scaleVelocity
      lapseVelocity scaleAcceleration : Real)
    (hG : G ≠ 0) (hlapse : lapse ≠ 0) (hscale : scale ≠ 0) :
    scaleEulerLagrangeResidual G cosmological velocity potential lapse scale
        scaleVelocity lapseVelocity scaleAcceleration = 0 ↔
      SpatialFriedmannEquation G cosmological velocity potential lapse scale
        scaleVelocity lapseVelocity scaleAcceleration := by
  unfold scaleEulerLagrangeResidual scalePartial scaleMomentumTimeDerivative
    SpatialFriedmannEquation properHubbleDerivative hubbleRate
  have hcoupling : eightPiG G ≠ 0 := by
    exact mul_ne_zero (mul_ne_zero (by norm_num) Real.pi_ne_zero) hG
  constructor <;> intro h
  · field_simp [hcoupling, hlapse, hscale] at h ⊢
    nlinarith [h]
  · field_simp [hcoupling, hlapse, hscale] at h ⊢
    nlinarith [h]

/-- The independently supplied lapse and scale equations imply the standard
flat-FLRW acceleration equation with the exact `8 pi G` normalization. -/
theorem friedmann_and_spatial_imply_acceleration
    (G cosmological velocity potential lapse scale scaleVelocity
      lapseVelocity scaleAcceleration : Real)
    (hlapse : lapse ≠ 0) (hscale : scale ≠ 0)
    (hfirst :
      FriedmannEquation G cosmological velocity potential lapse scale
        scaleVelocity)
    (hspatial :
      SpatialFriedmannEquation G cosmological velocity potential lapse scale
        scaleVelocity lapseVelocity scaleAcceleration) :
    AccelerationEquation G cosmological velocity potential lapse scale
      scaleVelocity lapseVelocity scaleAcceleration := by
  unfold AccelerationEquation
  rw [← properHubbleDerivative_add_sq lapse scale scaleVelocity lapseVelocity
    scaleAcceleration hlapse hscale]
  unfold FriedmannEquation at hfirst
  unfold SpatialFriedmannEquation at hspatial
  nlinarith [hfirst, hspatial]

/-- Exact nondegenerate de Sitter-like scalar-potential witness satisfying the
first Friedmann, spatial Friedmann, Euler--Lagrange, and acceleration equations. -/
theorem accelerating_scalar_potential_witness :
    let G : Real := 3 / (8 * Real.pi)
    G ≠ 0 ∧
      FriedmannEquation G 0 0 1 1 1 1 ∧
      SpatialFriedmannEquation G 0 0 1 1 1 1 0 1 ∧
      scaleEulerLagrangeResidual G 0 0 1 1 1 1 0 1 = 0 ∧
      AccelerationEquation G 0 0 1 1 1 1 0 1 := by
  dsimp
  have hG : (3 / (8 * Real.pi) : Real) ≠ 0 := by
    exact div_ne_zero (by norm_num) (mul_ne_zero (by norm_num) Real.pi_ne_zero)
  refine ⟨hG, ?_, ?_, ?_, ?_⟩
  · unfold FriedmannEquation hubbleRate eightPiG scalarRho
    field_simp [Real.pi_ne_zero]
    ring
  · unfold SpatialFriedmannEquation properHubbleDerivative hubbleRate
      eightPiG scalarPressure
    field_simp [Real.pi_ne_zero]
    ring
  · unfold scaleEulerLagrangeResidual scalePartial scaleMomentumTimeDerivative
      eightPiG scalarPressure
    field_simp [Real.pi_ne_zero]
    ring
  · exact friedmann_and_spatial_imply_acceleration
      (3 / (8 * Real.pi)) 0 0 1 1 1 1 0 1 one_ne_zero one_ne_zero
      (by
        unfold FriedmannEquation hubbleRate eightPiG scalarRho
        field_simp [Real.pi_ne_zero]
        ring)
      (by
        unfold SpatialFriedmannEquation properHubbleDerivative hubbleRate
          eightPiG scalarPressure
        field_simp [Real.pi_ne_zero]
        ring)

/-! ## Degeneracy falsification controls -/

/-- If the nonzero-lapse hypothesis is dropped, a zero scale residual need not
imply the spatial Friedmann equation under Lean's totalized division. -/
theorem zero_lapse_breaks_scaleResidual_to_spatial :
    scaleEulerLagrangeResidual 1 1 0 0 0 1 0 0 0 = 0 ∧
      ¬ SpatialFriedmannEquation 1 1 0 0 0 1 0 0 0 := by
  unfold scaleEulerLagrangeResidual scalePartial scaleMomentumTimeDerivative
    SpatialFriedmannEquation properHubbleDerivative hubbleRate scalarPressure
  norm_num

/-- If the nonzero-scale hypothesis is dropped, a zero scale residual need not
imply the spatial Friedmann equation under Lean's totalized division. -/
theorem zero_scale_breaks_scaleResidual_to_spatial :
    scaleEulerLagrangeResidual 1 1 0 0 1 0 0 0 0 = 0 ∧
      ¬ SpatialFriedmannEquation 1 1 0 0 1 0 0 0 0 := by
  unfold scaleEulerLagrangeResidual scalePartial scaleMomentumTimeDerivative
    SpatialFriedmannEquation properHubbleDerivative hubbleRate scalarPressure
  norm_num

/-- If the nonzero-coupling hypothesis is dropped, a zero scale residual need
not imply the spatial Friedmann equation under Lean's totalized division. -/
theorem zero_coupling_breaks_scaleResidual_to_spatial :
    scaleEulerLagrangeResidual 0 1 0 0 1 1 0 0 0 = 0 ∧
      ¬ SpatialFriedmannEquation 0 1 0 0 1 1 0 0 0 := by
  unfold scaleEulerLagrangeResidual scalePartial scaleMomentumTimeDerivative
    SpatialFriedmannEquation properHubbleDerivative hubbleRate scalarPressure
    eightPiG
  norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FlatFLRWAccelerationControl.scaleResidual_zero_iff_spatialFriedmann' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FlatFLRWAccelerationControl.scaleResidual_zero_iff_spatialFriedmann

/-- info: 'PhysicsSM.Draft.NullEdge.FlatFLRWAccelerationControl.friedmann_and_spatial_imply_acceleration' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FlatFLRWAccelerationControl.friedmann_and_spatial_imply_acceleration

/-- info: 'PhysicsSM.Draft.NullEdge.FlatFLRWAccelerationControl.accelerating_scalar_potential_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FlatFLRWAccelerationControl.accelerating_scalar_potential_witness

end PhysicsSM.Draft.NullEdge.FlatFLRWAccelerationControl
