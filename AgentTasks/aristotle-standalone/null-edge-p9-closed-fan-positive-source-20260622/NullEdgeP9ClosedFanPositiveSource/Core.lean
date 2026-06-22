import Mathlib.Tactic

/-!
# Closed visible fans have positive rest source when energy is nonzero

This focused Aristotle target strengthens the P9 guardrail:

```text
visible closure = rest frame, not source invisibility.
```

For a finite visible fan, `momentMassSq = (E^2 - |C|^2) / 4`. If the closure
vector `C` vanishes and the total energy `E` is nonzero, then the moment mass
square is strictly positive. The induced one-face source is therefore visible to
the unit test.
-/

noncomputable section

namespace NullEdgeP9ClosedFanPositiveSource

open BigOperators

abbrev Cochain (n : Nat) := Fin n -> Real

/-- Finite source/test pairing. -/
def sourcePairing {n : Nat} (source test : Cochain n) : Real :=
  Finset.univ.sum fun i => source i * test i

abbrev Vec3 := Fin 3 -> Real

/-- Euclidean dot product on coordinate three-vectors. -/
def vdot (a b : Vec3) : Real :=
  Finset.univ.sum fun k => a k * b k

/-- Squared Euclidean norm for three-vectors. -/
def normSq (a : Vec3) : Real :=
  vdot a a

/-- Weighted celestial closure vector. -/
def closureVector {n : Nat} (weight : Fin n -> Real)
    (dir : Fin n -> Vec3) : Vec3 :=
  fun k => Finset.univ.sum fun i => weight i * dir i k

/-- Total energy of a weighted finite fan. -/
def totalEnergy {n : Nat} (weight : Fin n -> Real) : Real :=
  Finset.univ.sum weight

/-- Celestial moment mass square `(E^2 - |C|^2) / 4`. -/
def momentMassSq {n : Nat} (weight : Fin n -> Real)
    (dir : Fin n -> Vec3) : Real :=
  (totalEnergy weight ^ 2 - normSq (closureVector weight dir)) / 4

/-- One-face source equal to the visible fan's moment mass square. -/
def massSource {n : Nat} (weight : Fin n -> Real)
    (dir : Fin n -> Vec3) : Cochain 1 :=
  fun _ => momentMassSq weight dir

/-- Unit test on the one-face toy diamond. -/
def unitTest : Cochain 1 :=
  fun _ => 1

/-- A closed visible fan has moment mass square equal to rest-energy square. -/
theorem closed_visibleFan_mass_eq_restEnergy
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hclosure : closureVector weight dir = 0) :
    momentMassSq weight dir = totalEnergy weight ^ 2 / 4 := by
  sorry

/-- A visibly closed fan with nonzero energy has positive moment mass square. -/
theorem closed_visibleFan_mass_pos_of_nonzero_energy
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hclosure : closureVector weight dir = 0)
    (hE : Not (totalEnergy weight = 0)) :
    0 < momentMassSq weight dir := by
  sorry

/-- The corresponding one-face source is visible to the unit test. -/
theorem closed_visibleFan_massSource_visible_of_nonzero_energy
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hclosure : closureVector weight dir = 0)
    (hE : Not (totalEnergy weight = 0)) :
    0 < sourcePairing (massSource weight dir) unitTest := by
  sorry

end NullEdgeP9ClosedFanPositiveSource
