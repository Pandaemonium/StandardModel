import Mathlib.Tactic

/-!
# P1 Plucker observer scalar bridge

This draft module integrates Aristotle project
`cf262f46-f04b-42fb-92d6-8ffd9cad9da3`.

Physics context: for a two-null observer-axis block with nonnegative null
energies `a` and `b`, the unnormalized Plucker/mass scalar is `m^2 = 4ab`,
while the trace-normalized visible determinant is `ab / (a+b)^2`. The observer
readout is therefore `2 sqrt(det rho) = m / E`, where `E = a+b`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP1PluckerObserverScalarBridge

/-- Observer energy of the two-null split. -/
def observerEnergy (a b : Real) : Real := a + b

/-- Plucker/mass square for a two-null observer-axis split. -/
def pluckerMassSq (a b : Real) : Real := 4 * a * b

/-- Determinant of the trace-normalized diagonal visible block. -/
def normalizedVisibleDet (a b : Real) : Real :=
  (a * b) / (observerEnergy a b) ^ 2

/--
For nonnegative null energies, the trace-normalized determinant gives the
observer mass ratio.

This is the finite scalar bridge:
`2 sqrt(det rho) = sqrt(m^2) / E`.
-/
theorem two_sqrt_normalizedVisibleDet_eq_pluckerMass_over_energy
    (a b : Real) (ha : 0 <= a) (hb : 0 <= b)
    (hE : 0 < observerEnergy a b) :
    2 * Real.sqrt (normalizedVisibleDet a b) =
      Real.sqrt (pluckerMassSq a b) / observerEnergy a b := by
  unfold normalizedVisibleDet pluckerMassSq observerEnergy
  have hsqrt4 : Real.sqrt (4 * a * b) = 2 * Real.sqrt (a * b) := by
    rw [show (4 : Real) * a * b = 2 ^ 2 * (a * b) by ring,
      Real.sqrt_mul (by positivity), Real.sqrt_sq (by norm_num)]
  have hdiv : Real.sqrt (a * b / (a + b) ^ 2) =
      Real.sqrt (a * b) / (a + b) := by
    rw [Real.sqrt_div' _ (by positivity), Real.sqrt_sq (by linarith),
      Real.sqrt_mul ha]
  rw [hsqrt4, hdiv]
  ring

/--
Squared form of the same bridge, avoiding square roots. This is often the
cleaner theorem to use downstream.
-/
theorem four_mul_normalizedVisibleDet_eq_massSq_over_energySq
    (a b : Real) :
    4 * normalizedVisibleDet a b =
      pluckerMassSq a b / (observerEnergy a b) ^ 2 := by
  unfold normalizedVisibleDet pluckerMassSq observerEnergy
  ring

end PhysicsSM.Draft.NullEdgeP1PluckerObserverScalarBridge
