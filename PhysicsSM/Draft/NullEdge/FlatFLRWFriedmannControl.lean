import PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation

/-!
# Flat-FLRW lapse variation and the Friedmann constraint

This draft module supplies a conditional G7-G8 cosmological control.  Assume
the continuum metric has already been reconstructed in the spatially flat,
homogeneous, isotropic form

```text
ds^2 = lapse(t)^2 dt^2 - scale(t)^2 d x^2
```

with signature `(+---)`, coordinate cell volume one, and Einstein-Hilbert
normalization `(R - 2 Lambda) / (16 pi G)`.  Use the curvature-sign convention
in which this ansatz has

```text
R = 6 * (scaleAcceleration / (scale * lapse^2)
  + scaleVelocity^2 / (scale^2 * lapse^2)
  - scaleVelocity * lapseVelocity / (scale * lapse^3)).
```

The unreduced Einstein-Hilbert integrand is then the expression below plus
`d/dt (3 * scale^2 * scaleVelocity / (8 * pi * G * lapse))`.  Here
"boundary-term removal" specifically means adding the endpoint term that
cancels that total derivative, equivalently the corresponding GHY convention.
The resulting reduced gravitational action density is

```text
-3 scale scaleVelocity^2 / (8 pi G lapse)
  - Lambda lapse scale^3 / (8 pi G).
```

Adding the homogeneous scalar action from
`HomogeneousScalarStressVariation`, variation with respect to the lapse gives
the Hamiltonian constraint.  For nonzero `G`, lapse, and scale, its vanishing
is exactly

```text
H^2 = (8 pi G / 3) rho + Lambda / 3,
H = scaleVelocity / (scale lapse).
```

## Scope boundary

The reduced Einstein-Hilbert action in this file is a continuum input.  The
theorems do not derive it, the FLRW ansatz, a lapse, a scale factor, or the
constants `G` and `Lambda` from a bare graph.  They prove that, once those
inputs are supplied with the displayed conventions, the imported homogeneous
scalar control has the standard lapse response and constant normalization.  No
acceleration equation, graph equation of motion, or inhomogeneous Einstein
equation is claimed.

Provenance: the proper-time-gauge kinetic and homogeneous-scalar
normalization agrees with Eq. (2) of C.-M. Lin, *More solutions for the
Wheeler-DeWitt equation in a flat FLRW minisuperspace*, arXiv:2309.02955v2,
after restoring `M_P^2 = 1/(8 pi G)`.  The lapse and cosmological terms are the
standard time-reparameterization-invariant restoration for the displayed
Einstein-Hilbert convention.  Clean-room formalization; claim grade:
`T|H [comp/import]` for the reduction hypothesis and `M [comp]` for the Lean
identities.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FlatFLRWFriedmannControl

open PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation

/-- Einstein-Hilbert coupling denominator `8 pi G` in natural units. -/
def eightPiG (G : Real) : Real := 8 * Real.pi * G

/-- Spatially flat FLRW Einstein-Hilbert minisuperspace action density after
canceling the total derivative specified in the module documentation.  This is
an imported continuum expression, not a graph-derived result. -/
def flatFLRWGravityAction
    (G cosmological lapse scale scaleVelocity : Real) : Real :=
  (-(3 * scale * scaleVelocity ^ 2) / eightPiG G) / lapse -
    (cosmological * scale ^ 3 / eightPiG G) * lapse

/-- Gravity plus homogeneous-scalar reduced action density. -/
def flatFLRWTotalAction
    (G cosmological velocity potential lapse scale scaleVelocity : Real) : Real :=
  flatFLRWGravityAction G cosmological lapse scale scaleVelocity +
    homogeneousScalarAction velocity potential lapse scale scale scale

/-- Hubble rate with respect to proper time for an arbitrary lapse. -/
def hubbleRate (lapse scale scaleVelocity : Real) : Real :=
  scaleVelocity / (scale * lapse)

/-- The standard spatially flat first Friedmann equation in natural units. -/
def FriedmannEquation
    (G cosmological velocity potential lapse scale scaleVelocity : Real) : Prop :=
  hubbleRate lapse scale scaleVelocity ^ 2 =
    (eightPiG G / 3) * scalarRho velocity potential lapse +
      cosmological / 3

/-- Coefficient produced by varying the total reduced action with respect to
the lapse.  Its vanishing is the Hamiltonian constraint. -/
def lapseResidual
    (G cosmological velocity potential lapse scale scaleVelocity : Real) : Real :=
  3 * scale * scaleVelocity ^ 2 / (eightPiG G * lapse ^ 2) -
    cosmological * scale ^ 3 / eightPiG G -
      scale ^ 3 * scalarRho velocity potential lapse

/-- Variational stationarity of the total reduced action in the lapse
direction. -/
def LapseStationary
    (G cosmological velocity potential lapse scale scaleVelocity : Real) : Prop :=
  HasDerivAt
    (fun N =>
      flatFLRWTotalAction G cosmological velocity potential N scale scaleVelocity)
    0 lapse

/-- Exact lapse derivative of the reduced gravitational action. -/
theorem hasDerivAt_gravity_lapse
    (G cosmological lapse scale scaleVelocity : Real)
    (hG : G ≠ 0) (hlapse : lapse ≠ 0) :
    HasDerivAt
      (fun N => flatFLRWGravityAction G cosmological N scale scaleVelocity)
      (3 * scale * scaleVelocity ^ 2 / (eightPiG G * lapse ^ 2) -
        cosmological * scale ^ 3 / eightPiG G)
      lapse := by
  have hcoupling : eightPiG G ≠ 0 := by
    exact mul_ne_zero (mul_ne_zero (by norm_num) Real.pi_ne_zero) hG
  have hkinetic :=
    (hasDerivAt_const lapse (-(3 * scale * scaleVelocity ^ 2) / eightPiG G)).div
      (hasDerivAt_id lapse) hlapse
  have hcosmological :=
    (hasDerivAt_id lapse).const_mul
      (cosmological * scale ^ 3 / eightPiG G)
  convert hkinetic.sub hcosmological using 1
  simp only [id_eq, zero_mul, zero_sub]
  field_simp [hcoupling, hlapse]

/-- Exact lapse derivative of gravity plus the homogeneous scalar action,
holding the scale, coordinate-time scale velocity, scalar coordinate-time
velocity, and potential fixed. -/
theorem hasDerivAt_total_lapse
    (G cosmological velocity potential lapse scale scaleVelocity : Real)
    (hG : G ≠ 0) (hlapse : lapse ≠ 0) :
    HasDerivAt
      (fun N =>
        flatFLRWTotalAction G cosmological velocity potential N scale scaleVelocity)
      (lapseResidual G cosmological velocity potential lapse scale scaleVelocity)
      lapse := by
  have hgravity :=
    hasDerivAt_gravity_lapse G cosmological lapse scale scaleVelocity hG hlapse
  have hmatter :=
    hasDerivAt_lapse velocity potential lapse scale scale scale hlapse
  convert hgravity.add hmatter using 1
  unfold lapseResidual spatialVolume
  ring

/-- Lapse stationarity is equivalent to vanishing of the explicitly displayed
Hamiltonian-constraint residual. -/
theorem lapseStationary_iff_residual_zero
    (G cosmological velocity potential lapse scale scaleVelocity : Real)
    (hG : G ≠ 0) (hlapse : lapse ≠ 0) :
    LapseStationary G cosmological velocity potential lapse scale scaleVelocity ↔
      lapseResidual G cosmological velocity potential lapse scale scaleVelocity = 0 := by
  have hderiv := hasDerivAt_total_lapse G cosmological velocity potential lapse
    scale scaleVelocity hG hlapse
  constructor
  · intro hstationary
    exact (hstationary.unique hderiv).symm
  · intro hzero
    simpa [LapseStationary, hzero] using hderiv

/-- Away from degenerate coupling, lapse, and scale, the lapse residual
vanishes exactly when the standard first Friedmann equation holds.  Positivity
is not needed for this algebraic equivalence; it is needed only for the usual
positive-orientation and positive-Newton-coupling interpretation. -/
theorem residual_zero_iff_friedmann
    (G cosmological velocity potential lapse scale scaleVelocity : Real)
    (hG : G ≠ 0) (hlapse : lapse ≠ 0) (hscale : scale ≠ 0) :
    lapseResidual G cosmological velocity potential lapse scale scaleVelocity = 0 ↔
      FriedmannEquation G cosmological velocity potential lapse scale scaleVelocity := by
  unfold lapseResidual FriedmannEquation hubbleRate scalarRho eightPiG
  constructor <;> intro h
  · field_simp [Real.pi_ne_zero, hG, hlapse, hscale] at h
    simp only [mul_zero] at h
    have hconstraint := (mul_eq_zero.mp h).resolve_left hscale
    field_simp [Real.pi_ne_zero, hG, hlapse, hscale]
    nlinarith [hconstraint]
  · field_simp [Real.pi_ne_zero, hG, hlapse, hscale] at h
    field_simp [Real.pi_ne_zero, hG, hlapse, hscale]
    simp only [mul_zero]
    apply mul_eq_zero.mpr
    right
    nlinarith [h]

/-- **Conditional cosmological control.** Under the displayed FLRW
minisuperspace hypothesis, lapse stationarity of gravity plus the constructed
homogeneous scalar action is exactly the first Friedmann equation, including
`8 pi G` and `Lambda / 3`. -/
theorem lapseStationary_iff_friedmann
    (G cosmological velocity potential lapse scale scaleVelocity : Real)
    (hG : G ≠ 0) (hlapse : lapse ≠ 0) (hscale : scale ≠ 0) :
    LapseStationary G cosmological velocity potential lapse scale scaleVelocity ↔
      FriedmannEquation G cosmological velocity potential lapse scale scaleVelocity := by
  rw [lapseStationary_iff_residual_zero G cosmological velocity potential lapse
    scale scaleVelocity hG hlapse]
  exact residual_zero_iff_friedmann G cosmological velocity potential lapse
    scale scaleVelocity hG hlapse hscale

/-- Exact nondegenerate witness with positive scalar energy density and zero
cosmological term. -/
theorem positive_matter_friedmann_witness :
    let G : Real := 3 / (8 * Real.pi)
    G ≠ 0 ∧
      scalarRho 0 1 1 = 1 ∧
      FriedmannEquation G 0 0 1 1 1 1 ∧
      LapseStationary G 0 0 1 1 1 1 := by
  dsimp
  have hG : (3 / (8 * Real.pi) : Real) ≠ 0 := by
    exact div_ne_zero (by norm_num) (mul_ne_zero (by norm_num) Real.pi_ne_zero)
  have hF : FriedmannEquation (3 / (8 * Real.pi)) 0 0 1 1 1 1 := by
    unfold FriedmannEquation hubbleRate eightPiG scalarRho
    field_simp [Real.pi_ne_zero]
    ring
  refine ⟨hG, by norm_num [scalarRho], hF, ?_⟩
  exact (lapseStationary_iff_friedmann (3 / (8 * Real.pi)) 0 0 1 1 1 1
    hG one_ne_zero one_ne_zero).2 hF

/-! ## Degeneracy falsification controls -/

/-- If the nonzero-scale hypothesis is dropped, residual zero need not imply
the Friedmann equation under Lean's totalized division. -/
theorem zero_scale_breaks_residual_to_friedmann :
    lapseResidual 1 3 0 0 1 0 0 = 0 ∧
      ¬ FriedmannEquation 1 3 0 0 1 0 0 := by
  unfold lapseResidual FriedmannEquation
  norm_num
  unfold hubbleRate eightPiG scalarRho
  norm_num

/-- If the nonzero-coupling hypothesis is dropped, residual zero need not imply
the Friedmann equation under Lean's totalized division. -/
theorem zero_coupling_breaks_residual_to_friedmann :
    lapseResidual 0 3 0 0 1 1 0 = 0 ∧
      ¬ FriedmannEquation 0 3 0 0 1 1 0 := by
  unfold lapseResidual FriedmannEquation
  norm_num
  unfold eightPiG scalarRho hubbleRate
  norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FlatFLRWFriedmannControl.lapseStationary_iff_friedmann' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FlatFLRWFriedmannControl.lapseStationary_iff_friedmann

/-- info: 'PhysicsSM.Draft.NullEdge.FlatFLRWFriedmannControl.positive_matter_friedmann_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FlatFLRWFriedmannControl.positive_matter_friedmann_witness

end PhysicsSM.Draft.NullEdge.FlatFLRWFriedmannControl
