import Mathlib

/-!
# Finite P9 visible-closure source guardrail

This focused target formalizes a key P9 guardrail:

```text
visible momentum closure = rest-frame condition, not source invisibility.
```

A two-ray fan with opposite unit celestial directions has zero closure vector,
but its celestial moment mass is positive.  When that mass is used as a
one-face source, it is visible to the unit bulk test.
-/

noncomputable section

namespace NullEdgeP9VisibleClosureSource

abbrev Vec3 := Fin 3 -> Real

/-- Euclidean dot product on coordinate three-vectors. -/
def dot (a b : Vec3) : Real :=
  Finset.univ.sum fun k => a k * b k

/-- Squared Euclidean norm. -/
def normSq (a : Vec3) : Real :=
  dot a a

/-- Positive x-axis celestial direction. -/
def dirPlus : Vec3 :=
  fun k => if k = 0 then 1 else 0

/-- Negative x-axis celestial direction. -/
def dirMinus : Vec3 :=
  fun k => if k = 0 then -1 else 0

/-- Closure vector for the two opposite rays. -/
def twoRayClosure : Vec3 :=
  fun k => dirPlus k + dirMinus k

/-- Total energy for two unit-weight null rays. -/
def twoRayEnergy : Real :=
  2

/-- Celestial moment mass square `(E^2 - |C|^2) / 4`. -/
def twoRayMomentMassSq : Real :=
  (twoRayEnergy ^ 2 - normSq twoRayClosure) / 4

/-- The two opposite rays have zero visible closure vector. -/
theorem twoRayClosure_eq_zero :
    twoRayClosure = 0 := by
  sorry

/-- The same closed visible fan has positive unit mass square. -/
theorem twoRayMomentMassSq_eq_one :
    twoRayMomentMassSq = 1 := by
  sorry

abbrev Cochain (n : Nat) := Fin n -> Real

/-- Finite source/test pairing. -/
def sourcePairing {n : Nat} (source test : Cochain n) : Real :=
  Finset.univ.sum fun i => source i * test i

/-- The two-ray mass square used as a one-face source. -/
def twoRayMassSource : Cochain 1 :=
  fun _ => twoRayMomentMassSq

/-- Unit test on the one-face toy diamond. -/
def unitTest : Cochain 1 :=
  fun _ => 1

/-- The closed two-ray fan is visible as a positive one-face source. -/
theorem twoRayMassSource_visible_to_unitTest :
    sourcePairing twoRayMassSource unitTest = 1 := by
  sorry

/--
There exists a visibly closed two-ray fan whose induced source is bulk-visible.

This separates visible closure from source invisibility in the finite P9 toy
vocabulary.
-/
theorem closed_visibleFan_can_be_bulkVisible :
    And (twoRayClosure = 0)
      (sourcePairing twoRayMassSource unitTest = 1) := by
  sorry

end NullEdgeP9VisibleClosureSource
