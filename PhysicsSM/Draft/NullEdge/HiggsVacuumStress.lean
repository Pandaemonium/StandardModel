import PhysicsSM.Draft.NullEdge.HiggsHilbertStress

/-!
# Covariantly constant Higgs vacuum stress

This module specializes the finite complex-multiplet Hilbert-stress algebra to
a covariantly constant Higgs vacuum. Vanishing derivative components remove
the kinetic sector, but a supplied constant potential density `V0` remains:

```text
T_ab = V0 * g_ab.
```

In a supplied `(+---)` orthonormal frame this gives energy density `rho = V0`
and isotropic pressure `p = -V0`, hence `p = -rho`. Thus zero link variation
does not imply zero gravitational source.

The metric, inverse metric, volume response, and potential density are
supplied. This is a finite stress-response identity, not a derivation or
suppression of vacuum energy, a cosmological constant prediction, or a
continuum Einstein equation. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsVacuumStress

open scoped BigOperators
open PhysicsSM.Draft.NullEdge.HiggsHilbertStress

variable {N I : Type*} [Fintype N] [Fintype I]

/-- A derivative-free Higgs configuration with potential density `V0` has
Hilbert stress exactly proportional to the supplied covariant metric. -/
theorem constantVacuum_hilbertStress_eq_metric_smul
    (gCov gInv : Matrix I I Real) (V0 : Real) :
    hilbertStress gCov gInv (0 : I -> N -> Complex) V0 = V0 • gCov := by
  ext a b
  simp [hilbertStress, derivativeBilinear, realHermitianBilinear,
    metricLagrangian, metricKinetic]
  ring

/-- Supplied orthonormal covariant metric with project signature `(+---)`. -/
def mostlyMinusMetric : Matrix (Fin 4) (Fin 4) Real :=
  Matrix.diagonal ![1, -1, -1, -1]

/-- Rest-frame energy density read from the covariant `00` component. -/
def restEnergyDensity (stress : Matrix (Fin 4) (Fin 4) Real) : Real :=
  stress 0 0

/-- Rest-frame principal pressure read from one covariant spatial diagonal
component. -/
def spatialPressure
    (stress : Matrix (Fin 4) (Fin 4) Real) (axis : Fin 3) : Real :=
  stress axis.succ axis.succ

/-- In the supplied mostly-minus orthonormal frame, the vacuum energy density
is `V0` and all three principal pressures are `-V0`. -/
theorem constantVacuum_mostlyMinus_density_pressure (V0 : Real) :
    let stress := hilbertStress mostlyMinusMetric mostlyMinusMetric
      (0 : Fin 4 -> Fin 1 -> Complex) V0
    restEnergyDensity stress = V0 ∧
      ∀ axis : Fin 3, spatialPressure stress axis = -V0 := by
  dsimp
  rw [constantVacuum_hilbertStress_eq_metric_smul]
  constructor
  · simp [restEnergyDensity, mostlyMinusMetric]
  · intro axis
    fin_cases axis <;> simp [spatialPressure, mostlyMinusMetric]

/-- The finite derivative-free Higgs vacuum has exact equation of state
`p = -rho` in every supplied spatial axis. -/
theorem constantVacuum_mostlyMinus_equationOfState (V0 : Real) :
    let stress := hilbertStress mostlyMinusMetric mostlyMinusMetric
      (0 : Fin 4 -> Fin 1 -> Complex) V0
    ∀ axis : Fin 3,
      spatialPressure stress axis = -restEnergyDensity stress := by
  obtain ⟨hDensity, hPressure⟩ :=
    constantVacuum_mostlyMinus_density_pressure V0
  simpa [hDensity] using hPressure

/-- Under the determinant-compatible inverse-metric measure law, the vacuum
action response is exactly one half of the measure-weighted metric stress
pairing. -/
theorem constantVacuum_volumeCompatible_response
    (measure measureResponse V0 : Real)
    (gCov gInv variation : Matrix I I Real)
    (hMeasure : measureResponse =
      -(1 / 2) * measure * (∑ a, ∑ b, gCov a b * variation a b)) :
    inverseMetricMeasureResponse measure measureResponse gInv variation
        (0 : I -> N -> Complex) V0 =
      (1 / 2) * measure *
        (∑ a, ∑ b, V0 * gCov a b * variation a b) := by
  rw [volumeCompatible_response_eq_hilbert_pairing
    measure measureResponse gCov gInv variation
    (0 : I -> N -> Complex) V0 hMeasure]
  rw [constantVacuum_hilbertStress_eq_metric_smul]
  simp [mul_assoc]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsVacuumStress.constantVacuum_hilbertStress_eq_metric_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms constantVacuum_hilbertStress_eq_metric_smul

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsVacuumStress.constantVacuum_mostlyMinus_equationOfState' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms constantVacuum_mostlyMinus_equationOfState

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsVacuumStress.constantVacuum_volumeCompatible_response' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms constantVacuum_volumeCompatible_response

end PhysicsSM.Draft.NullEdge.HiggsVacuumStress

end
