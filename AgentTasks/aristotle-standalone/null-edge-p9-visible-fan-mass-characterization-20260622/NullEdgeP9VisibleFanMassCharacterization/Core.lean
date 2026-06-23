import Mathlib.Tactic

/-!
# Visible-fan mass characterization: massive iff non-collinear, with a bound

This focused Aristotle target completes the finite characterization of when a
visible celestial fan carries rest mass, the companion to the non-collinearity
no-go. With `momentMassSq = (E^2 - |C|^2) / 4` and the gap identity

```text
E^2 - |C|^2 = sum_{i,j} weight i * weight j * (1 - <dir i, dir j>),
```

for unit directions and nonnegative weights each summand is nonnegative, so:

- a quantitative lower bound: the moment mass square dominates any single pair
  contribution `weight i * weight j * (1 - <dir i, dir j>) / 4`;
- masslessness is exactly collinearity: the moment mass square vanishes iff every
  pair of positively-weighted cells points in the same unit direction.

Together with `visiblePluckerMass_nonzero_of_noncollinear` this pins down the P9
visibility dichotomy: visible closure is a rest-frame condition, and visible mass
vanishes only in the degenerate collinear (lightlike) case.

Conventions follow `PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore`; the
definitions are copied so the package is standalone (Mathlib only).
-/

noncomputable section

namespace NullEdgeP9VisibleFanMassCharacterization

open BigOperators

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

/--
Quantitative visibility bound: the moment mass square dominates the contribution
of any single pair of cells.
-/
theorem momentMassSq_ge_pair_term
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hw : forall i, 0 <= weight i)
    (hu : forall i, normSq (dir i) = 1)
    (i j : Fin n) :
    weight i * weight j * (1 - vdot (dir i) (dir j)) / 4 <= momentMassSq weight dir := by
  sorry

/--
Collinear visible fans are massless: if every pair of positively-weighted cells
points in the same unit direction, the moment mass square vanishes.
-/
theorem visibleFan_massless_of_collinear
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hw : forall i, 0 <= weight i)
    (hu : forall i, normSq (dir i) = 1)
    (hcol : forall i j, 0 < weight i -> 0 < weight j -> dir i = dir j) :
    momentMassSq weight dir = 0 := by
  sorry

/--
Massless visible fans are collinear: if the moment mass square vanishes, every
pair of positively-weighted cells points in the same unit direction.
-/
theorem visibleFan_massless_imp_collinear
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hw : forall i, 0 <= weight i)
    (hu : forall i, normSq (dir i) = 1)
    (hmass : momentMassSq weight dir = 0) :
    forall i j, 0 < weight i -> 0 < weight j -> dir i = dir j := by
  sorry

end NullEdgeP9VisibleFanMassCharacterization
