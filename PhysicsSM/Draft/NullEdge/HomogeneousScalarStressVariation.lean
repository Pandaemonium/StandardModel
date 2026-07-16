import PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls

/-!
# Homogeneous scalar stress-energy from coframe variation

This draft module supplies a first constructed G6 matter-action variation.  A
single homogeneous cell has diagonal coframe parameters
`(lapse,a1,a2,a3)`, signature `(+---)`, scalar time derivative `velocity`, and
potential-energy density `potential`.  Its reduced matter action is

```text
S = a1*a2*a3 * (velocity^2/(2*lapse) - lapse*potential).
```

For nonzero lapse this is exactly the oriented coframe determinant times
`(1/2) g^{00} velocity^2 - potential`, with `g^{00}=lapse^-2`.
It equals the usual `sqrt(-g)` action density only on the orientation sector
`lapse*a1*a2*a3 > 0`; without that condition `sqrt(-g)` is the absolute value
of the determinant.  Varying the lapse gives minus the oriented
spatial-volume factor times the homogeneous scalar energy density, while
varying each spatial scale gives lapse times the oriented opposite-face factor
times the isotropic pressure.

With `delta S = -(1/2) sqrt(-g) T^{mu nu} delta g_{mu nu}` and diagonal
coframe variation, the normalized coframe coefficient is `-T^mu_mu` (no sum).
Consequently the lapse coefficient is `-rho`, while a spatial coefficient is
`+p` because the mixed orthonormal components are
`diag(rho,-p,-p,-p)`.  The matrix assembled below instead records covariant
orthonormal components `diag(rho,p,p,p)`; the derivative theorems do not
themselves formalize this interface.

## Scope boundary

This is a one-cell homogeneous diagonal-coframe theorem. It includes the
volume variation but has no spatial gradients, momentum flux, off-diagonal
coframe variation, graph localization, matter equation of motion, Noether
identity, or covariant conservation theorem. It therefore constructs the
perfect-fluid component shape in this sector, not a general null-edge stress
tensor or Einstein equation.

Provenance: clean-room minisuperspace scalar-field calculation in the project
`(+---)` convention. Claim grade: `M [comp]`.
-/

open Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation

open PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls

/-- Oriented product of the three diagonal spatial coframe scales. -/
def spatialVolume (a1 a2 a3 : Real) : Real := a1 * a2 * a3

/-- Oriented diagonal coframe volume in the positive-orientation chart. -/
def coframeVolume (lapse a1 a2 a3 : Real) : Real :=
  lapse * spatialVolume a1 a2 a3

/-- Time-time component of the inverse diagonal metric. -/
def inverseTimeMetric (lapse : Real) : Real := 1 / lapse ^ 2

/-- Reduced homogeneous scalar Lagrangian density. -/
def scalarLagrangian (velocity potential lapse : Real) : Real :=
  (1 / 2) * inverseTimeMetric lapse * velocity ^ 2 - potential

/-- One-cell homogeneous scalar matter action. -/
def homogeneousScalarAction
    (velocity potential lapse a1 a2 a3 : Real) : Real :=
  spatialVolume a1 a2 a3 *
    (velocity ^ 2 / (2 * lapse) - lapse * potential)

/-- Homogeneous scalar energy density in the diagonal frame. -/
def scalarRho (velocity potential lapse : Real) : Real :=
  velocity ^ 2 / (2 * lapse ^ 2) + potential

/-- Homogeneous scalar isotropic pressure in the diagonal frame. -/
def scalarPressure (velocity potential lapse : Real) : Real :=
  velocity ^ 2 / (2 * lapse ^ 2) - potential

/-- The reduced action is exactly coframe volume times the scalar Lagrangian. -/
theorem homogeneousScalarAction_eq_volume_lagrangian
    (velocity potential lapse a1 a2 a3 : Real) (hlapse : lapse ≠ 0) :
    homogeneousScalarAction velocity potential lapse a1 a2 a3 =
      coframeVolume lapse a1 a2 a3 *
        scalarLagrangian velocity potential lapse := by
  unfold homogeneousScalarAction coframeVolume scalarLagrangian
    inverseTimeMetric spatialVolume
  field_simp [hlapse]

/-- Lapse variation gives minus the oriented spatial-volume factor times the
energy density. -/
theorem hasDerivAt_lapse
    (velocity potential lapse a1 a2 a3 : Real) (hlapse : lapse ≠ 0) :
    HasDerivAt
      (fun N => homogeneousScalarAction velocity potential N a1 a2 a3)
      (-spatialVolume a1 a2 a3 * scalarRho velocity potential lapse)
      lapse := by
  have hquot : HasDerivAt
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
  have hinside := hquot.sub ((hasDerivAt_id lapse).mul_const potential)
  have h := hinside.const_mul (spatialVolume a1 a2 a3)
  convert h using 1
  · unfold scalarRho
    ring

/-- First spatial-scale variation gives lapse times the oriented
opposite-face factor times the pressure. -/
theorem hasDerivAt_scale1
    (velocity potential lapse a1 a2 a3 : Real) (hlapse : lapse ≠ 0) :
    HasDerivAt
      (fun a => homogeneousScalarAction velocity potential lapse a a2 a3)
      (lapse * (a2 * a3) * scalarPressure velocity potential lapse) a1 := by
  have h := (hasDerivAt_id a1).mul_const
    ((a2 * a3) * (velocity ^ 2 / (2 * lapse) - lapse * potential))
  convert h using 1
  · funext a
    simp only [homogeneousScalarAction, spatialVolume, id_eq]
    ring
  · unfold scalarPressure
    field_simp [hlapse]

/-- Second spatial-scale variation gives lapse times the oriented
opposite-face factor times the pressure. -/
theorem hasDerivAt_scale2
    (velocity potential lapse a1 a2 a3 : Real) (hlapse : lapse ≠ 0) :
    HasDerivAt
      (fun a => homogeneousScalarAction velocity potential lapse a1 a a3)
      (lapse * (a1 * a3) * scalarPressure velocity potential lapse) a2 := by
  have h := (hasDerivAt_id a2).mul_const
    ((a1 * a3) * (velocity ^ 2 / (2 * lapse) - lapse * potential))
  convert h using 1
  · funext a
    simp only [homogeneousScalarAction, spatialVolume, id_eq]
    ring
  · unfold scalarPressure
    field_simp [hlapse]

/-- Third spatial-scale variation gives lapse times the oriented
opposite-face factor times the pressure. -/
theorem hasDerivAt_scale3
    (velocity potential lapse a1 a2 a3 : Real) (hlapse : lapse ≠ 0) :
    HasDerivAt
      (fun a => homogeneousScalarAction velocity potential lapse a1 a2 a)
      (lapse * (a1 * a2) * scalarPressure velocity potential lapse) a3 := by
  have h := (hasDerivAt_id a3).mul_const
    ((a1 * a2) * (velocity ^ 2 / (2 * lapse) - lapse * potential))
  convert h using 1
  · funext a
    simp only [homogeneousScalarAction, spatialVolume, id_eq]
    ring
  · unfold scalarPressure
    field_simp [hlapse]

/-- Covariant orthonormal perfect-fluid component matrix assembled from the
density and pressure found in the diagonal response.  This definition is not
a theorem deriving a full tensor from arbitrary coframe variations. -/
def homogeneousScalarStress
    (velocity potential lapse : Real) : Stress4 :=
  restPressuredStress (scalarRho velocity potential lapse)
    (scalarPressure velocity potential lapse)

/-- The assembled component matrix has the stated density, equal spatial
pressures, symmetry, and zero displayed time-space entries.  These are
component facts about the definition, not a derivation from off-diagonal
variations. -/
theorem homogeneousScalarStress_components
    (velocity potential lapse : Real) :
    (homogeneousScalarStress velocity potential lapse).IsSymm ∧
      energyDensity (homogeneousScalarStress velocity potential lapse) =
        scalarRho velocity potential lapse ∧
      (∀ i : Fin 3,
        homogeneousScalarStress velocity potential lapse i.succ i.succ =
          scalarPressure velocity potential lapse) ∧
      (∀ i : Fin 3,
        homogeneousScalarStress velocity potential lapse 0 i.succ = 0) := by
  refine ⟨(restStress_symmetric _ _).2, ?_, ?_, ?_⟩
  · simp [homogeneousScalarStress, energyDensity, restPressuredStress]
  · intro i
    fin_cases i <;>
      simp [homogeneousScalarStress, restPressuredStress]
  · intro i
    fin_cases i <;>
      simp [homogeneousScalarStress, restPressuredStress]

/-- The four derivative conditions defining the diagonal-coframe response of
the homogeneous action. -/
def DiagonalCoframeResponse
    (velocity potential lapse a1 a2 a3 : Real) : Prop :=
    HasDerivAt
        (fun N => homogeneousScalarAction velocity potential N a1 a2 a3)
        (-spatialVolume a1 a2 a3 * scalarRho velocity potential lapse)
        lapse ∧
      HasDerivAt
        (fun a => homogeneousScalarAction velocity potential lapse a a2 a3)
        (lapse * (a2 * a3) * scalarPressure velocity potential lapse) a1 ∧
      HasDerivAt
        (fun a => homogeneousScalarAction velocity potential lapse a1 a a3)
        (lapse * (a1 * a3) * scalarPressure velocity potential lapse) a2 ∧
      HasDerivAt
        (fun a => homogeneousScalarAction velocity potential lapse a1 a2 a)
        (lapse * (a1 * a2) * scalarPressure velocity potential lapse) a3

/-- All four diagonal coordinate variations of the same reduced matter action
yield the stated density/pressure response coefficients. -/
theorem coframeVariations_recover_density_pressure
    (velocity potential lapse a1 a2 a3 : Real) (hlapse : lapse ≠ 0) :
    DiagonalCoframeResponse velocity potential lapse a1 a2 a3 :=
  ⟨hasDerivAt_lapse velocity potential lapse a1 a2 a3 hlapse,
    hasDerivAt_scale1 velocity potential lapse a1 a2 a3 hlapse,
    hasDerivAt_scale2 velocity potential lapse a1 a2 a3 hlapse,
    hasDerivAt_scale3 velocity potential lapse a1 a2 a3 hlapse⟩

/-- Nonzero positive-lapse witness with distinct density and pressure. -/
theorem nonzero_density_pressure_variation_witness :
    scalarRho 2 1 1 = 3 ∧
      scalarPressure 2 1 1 = 1 ∧
      homogeneousScalarStress 2 1 1 ≠ 0 ∧
      DiagonalCoframeResponse 2 1 1 1 1 1 := by
  refine ⟨by norm_num [scalarRho], by norm_num [scalarPressure], ?_,
    coframeVariations_recover_density_pressure 2 1 1 1 1 1 one_ne_zero⟩
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num [homogeneousScalarStress, restPressuredStress, scalarRho] at h00

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation.coframeVariations_recover_density_pressure' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation.coframeVariations_recover_density_pressure

/-- info: 'PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation.nonzero_density_pressure_variation_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation.nonzero_density_pressure_variation_witness

end PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation
