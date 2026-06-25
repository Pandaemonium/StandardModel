import Mathlib.Tactic

/-!
# P4 mass from normalized observer readout

This draft module integrates Aristotle project
`2bc30578-fc7c-4b5c-afda-96bbcf3cdcc1`.

Physics context: P1 proves that a two-null observer block has normalized
determinant `det rho = ab/(a+b)^2`, while the unnormalized Plucker/kinetic mass
square is `m^2 = 4ab`. P4 needs the inverse readout: once the observer energy
`E = a+b` and normalized determinant are known, the unnormalized kinetic symbol
is recovered as `m^2 = E^2 * 4 det rho`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP4MassFromNormalizedReadout

/-- Observer energy of the two-null split. -/
def observerEnergy (a b : Real) : Real := a + b

/-- Unnormalized Plucker/kinetic mass square. -/
def kineticMassSq (a b : Real) : Real := 4 * a * b

/-- Normalized visible determinant read by the observer. -/
def normalizedVisibleDet (a b : Real) : Real :=
  (a * b) / (observerEnergy a b) ^ 2

/--
Recover the unnormalized kinetic mass square from observer energy and
trace-normalized determinant.

This is the P4-facing version of the P1 scalar bridge.
-/
theorem kineticMassSq_eq_energySq_mul_four_normalizedVisibleDet
    (a b : Real) (hE : observerEnergy a b != 0) :
    kineticMassSq a b =
      (observerEnergy a b) ^ 2 * (4 * normalizedVisibleDet a b) := by
  unfold kineticMassSq normalizedVisibleDet observerEnergy
  rw [mul_left_comm,
    mul_div_cancel₀ _ (by contrapose! hE; unfold observerEnergy at *; aesop)]
  ring

/--
Equivalent ratio form: normalized determinant is one quarter of the squared
mass/energy ratio.
-/
theorem four_normalizedVisibleDet_eq_massSq_div_energySq
    (a b : Real) :
    4 * normalizedVisibleDet a b =
      kineticMassSq a b / (observerEnergy a b) ^ 2 := by
  unfold normalizedVisibleDet kineticMassSq observerEnergy
  ring

end PhysicsSM.Draft.NullEdgeP4MassFromNormalizedReadout
