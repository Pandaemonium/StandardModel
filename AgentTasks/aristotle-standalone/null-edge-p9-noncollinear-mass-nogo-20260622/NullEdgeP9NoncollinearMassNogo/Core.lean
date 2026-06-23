import Mathlib.Tactic

/-!
# Non-collinear visible fans carry positive mass and a visible source

This focused Aristotle target proves the P9 no-go theorem ranked by the
post-suppression source-visibility audit:

```text
visible non-collinearity gives nonzero mass/source.
```

For a finite visible fan, `momentMassSq = (E^2 - |C|^2) / 4`, with `E` the total
energy `sum_i weight i` and `C` the weighted closure vector
`sum_i weight i * dir i`. When the directions are unit vectors and the weights
are nonnegative, the gap expands as

```text
E^2 - |C|^2 = sum_{i,j} weight i * weight j * (1 - <dir i, dir j>),
```

every term of which is nonnegative by Cauchy-Schwarz, so the moment mass square
is nonnegative. If two cells with positive weight point in different unit
directions, their off-diagonal term is strictly positive
(`|dir i - dir j|^2 = 2 (1 - <dir i, dir j>) > 0`), so the whole moment mass
square is strictly positive. Visible non-collinear excitations therefore carry
positive rest mass and a source that is visible to the unit test; they cannot be
hidden by closure.

Conventions follow the existing P9 draft core
`PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore`: the same `Vec3`,
`vdot`, `normSq`, `closureVector`, `totalEnergy`, `momentMassSq`, `massSource`,
and `unitTest` definitions, copied here so the package is standalone (Mathlib
only, no `PhysicsSM` import).
-/

noncomputable section

namespace NullEdgeP9NoncollinearMassNogo

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

/--
A visible fan of unit directions with nonnegative weights has nonnegative
moment mass square. This is the finite Cauchy-Schwarz bound `|C| <= E`.
-/
theorem visibleFan_mass_nonneg
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hw : forall i, 0 <= weight i)
    (hu : forall i, normSq (dir i) = 1) :
    0 <= momentMassSq weight dir := by
  sorry

/--
The P9 no-go: a visible fan with two positively-weighted cells pointing in
different unit directions has strictly positive moment mass square. Visible
non-collinearity carries positive rest mass; closure cannot hide it.
-/
theorem visiblePluckerMass_nonzero_of_noncollinear
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hw : forall i, 0 <= weight i)
    (hu : forall i, normSq (dir i) = 1)
    {i j : Fin n} (hwi : 0 < weight i) (hwj : 0 < weight j)
    (hij : Not (dir i = dir j)) :
    0 < momentMassSq weight dir := by
  sorry

/--
The induced one-face mass source of a non-collinear visible fan is visible to
the unit test.
-/
theorem visiblePluckerMass_source_visible_of_noncollinear
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hw : forall i, 0 <= weight i)
    (hu : forall i, normSq (dir i) = 1)
    {i j : Fin n} (hwi : 0 < weight i) (hwj : 0 < weight j)
    (hij : Not (dir i = dir j)) :
    0 < sourcePairing (massSource weight dir) unitTest := by
  sorry

end NullEdgeP9NoncollinearMassNogo
