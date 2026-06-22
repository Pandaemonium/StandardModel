import Mathlib.Tactic

/-!
# Finite diamond-source visibility core

This focused target consolidates the P9 source-visibility toy modules into one
small API.  The important new target is the general visible-fan theorem:

```text
visible closure C = 0 -> momentMassSq = E^2 / 4.
```

This upgrades the hardcoded two-ray example to a weighted finite fan statement.
The module still remains finite algebra, not a cosmology theorem.
-/

noncomputable section

namespace NullEdgeP9DiamondSourceVisibility

open BigOperators

abbrev Cochain (n : Nat) := Fin n -> Real

/-- Finite Euclidean pairing on `Fin n` cochains. -/
def dot {n : Nat} (x y : Cochain n) : Real :=
  Finset.univ.sum fun i => x i * y i

/-- Pair a finite source with a finite bulk test observable. -/
def sourcePairing {n : Nat} (source test : Cochain n) : Real :=
  dot source test

/-- Boundary-generated source or cochain induced by an incidence matrix. -/
def boundarySource {b f : Nat} (D : Fin b -> Fin f -> Real)
    (a : Cochain b) : Cochain f :=
  fun i => Finset.univ.sum fun j => D j i * a j

/--
Adjoint divergence of a face test against the same incidence matrix.

The same coefficient matrix `D j i` defines the transpose/adjoint map with
respect to the finite dot pairing above.
-/
def codiff {b f : Nat} (D : Fin b -> Fin f -> Real)
    (test : Cochain f) : Cochain b :=
  fun j => Finset.univ.sum fun i => D j i * test i

/-- A bulk test is closed when its adjoint divergence vanishes. -/
def BulkClosed {b f : Nat} (D : Fin b -> Fin f -> Real)
    (test : Cochain f) : Prop :=
  codiff D test = 0

/-- A source is boundary-exact when it is generated from boundary data. -/
def BoundaryExact {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) : Prop :=
  exists a : Cochain b, source = boundarySource D a

/-- A source is invisible to all closed bulk tests. -/
def InvisibleToClosedBulkTests {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) : Prop :=
  forall test : Cochain f, BulkClosed D test -> sourcePairing source test = 0

/-- Matrix-composition condition for two finite incidence maps. -/
def ChainComplex {v e f : Nat}
    (D0 : Fin v -> Fin e -> Real) (D1 : Fin e -> Fin f -> Real) : Prop :=
  forall x z, Finset.univ.sum (fun y => D0 x y * D1 y z) = 0

/-- A finite source observable has zero total source. -/
def MeanZero {omega : Type*} [Fintype omega] (source : omega -> Real) : Prop :=
  Finset.univ.sum source = 0

/-- Unnormalized second moment of a finite source observable. -/
def secondMoment {omega : Type*} [Fintype omega] (source : omega -> Real) : Real :=
  Finset.univ.sum fun x => source x ^ 2

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

/-- Discrete integration by parts for a finite boundary-generated source. -/
theorem boundarySource_pairing_eq_boundary_potential_pairing
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (a : Cochain b) (test : Cochain f) :
    sourcePairing (boundarySource D a) test = dot a (codiff D test) := by
  sorry

/-- Boundary-exact source terms are invisible to closed bulk tests. -/
theorem boundaryExact_invisible_to_closed_tests
    {b f : Nat} (D : Fin b -> Fin f -> Real) (source : Cochain f)
    (hsource : BoundaryExact D source) :
    InvisibleToClosedBulkTests D source := by
  sorry

/-- Applying two successive boundary maps is zero under the chain-complex law. -/
theorem boundarySource_comp_eq_zero_of_chainComplex
    {v e f : Nat}
    (D0 : Fin v -> Fin e -> Real) (D1 : Fin e -> Fin f -> Real)
    (hcomplex : ChainComplex D0 D1) (a : Cochain v) :
    boundarySource D1 (boundarySource D0 a) = 0 := by
  sorry

/-- Antisymmetry under a finite bijective relabeling forces zero total source. -/
theorem meanZero_of_equiv_antisymm
    {omega : Type*} [Fintype omega]
    (tau : omega ≃ omega) (source : omega -> Real)
    (hanti : forall x, source (tau x) = - source x) :
    MeanZero source := by
  sorry

/-- A closed visible fan has moment mass square equal to rest-energy square. -/
theorem closed_visibleFan_mass_eq_restEnergy
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hclosure : closureVector weight dir = 0) :
    momentMassSq weight dir = totalEnergy weight ^ 2 / 4 := by
  sorry

/-- The corresponding one-face mass source pairs to the rest-energy square. -/
theorem closed_visibleFan_massSource_pairing_eq_restEnergy
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hclosure : closureVector weight dir = 0) :
    sourcePairing (massSource weight dir) unitTest = totalEnergy weight ^ 2 / 4 := by
  sorry

end NullEdgeP9DiamondSourceVisibility
