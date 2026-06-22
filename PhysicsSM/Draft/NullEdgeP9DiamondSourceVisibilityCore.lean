import Mathlib.Tactic

/-!
# Finite diamond-source visibility core

This draft module consolidates the first P9 source-visibility toy modules into
one small API. The important new result is the general visible-fan theorem:

```text
visible closure C = 0 -> momentMassSq = E^2 / 4
```

This upgrades the hardcoded two-ray guardrail to a weighted finite fan
statement. It remains finite algebra, not a cosmology theorem: the point is to
separate boundary-exact bookkeeping, mean-zero fluctuations, and visibly closed
mass sources before making any continuum claim about the cosmological constant.

Proven by Aristotle project `dcd2f8b7-1e42-4bb6-9a18-0940cebfeed6` on
2026-06-22 from the focused standalone package
`null-edge-p9-diamond-source-visibility-core-v2-20260622`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore

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
  unfold sourcePairing boundarySource codiff dot
  simpa only [mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _,
    Finset.sum_mul] using Finset.sum_comm

/-- Boundary-exact source terms are invisible to closed bulk tests. -/
theorem boundaryExact_invisible_to_closed_tests
    {b f : Nat} (D : Fin b -> Fin f -> Real) (source : Cochain f)
    (hsource : BoundaryExact D source) :
    InvisibleToClosedBulkTests D source := by
  obtain ⟨a, ha⟩ := hsource
  intro test hclosed
  simp [ha, boundarySource_pairing_eq_boundary_potential_pairing]
  convert congr_arg (fun x => dot a x) hclosed using 1
  unfold dot
  norm_num

/-- Applying two successive boundary maps is zero under the chain-complex law. -/
theorem boundarySource_comp_eq_zero_of_chainComplex
    {v e f : Nat}
    (D0 : Fin v -> Fin e -> Real) (D1 : Fin e -> Fin f -> Real)
    (hcomplex : ChainComplex D0 D1) (a : Cochain v) :
    boundarySource D1 (boundarySource D0 a) = 0 := by
  unfold boundarySource
  ext i
  simp +decide [Finset.mul_sum _ _ _, mul_left_comm]
  rw [Finset.sum_comm]
  simp_all +decide [← mul_assoc, ← Finset.sum_mul, ChainComplex]

/-- Antisymmetry under a finite bijective relabeling forces zero total source. -/
theorem meanZero_of_equiv_antisymm
    {omega : Type*} [Fintype omega]
    (tau : Equiv omega omega) (source : omega -> Real)
    (hanti : forall x, source (tau x) = -source x) :
    MeanZero source := by
  unfold MeanZero
  let S : Real := Finset.univ.sum source
  have hperm : (Finset.univ.sum fun x => source (tau x)) = S := by
    simpa [S] using Equiv.sum_comp tau source
  have hanti_sum : (Finset.univ.sum fun x => source (tau x)) = -S := by
    calc
      (Finset.univ.sum fun x => source (tau x)) = Finset.univ.sum (fun x => -source x) := by
        simp [hanti]
      _ = -S := by
        simp [S]
  have h : -S = S := by
    rw [hanti_sum] at hperm
    exact hperm
  change S = 0
  linarith

/-- A closed visible fan has moment mass square equal to rest-energy square. -/
theorem closed_visibleFan_mass_eq_restEnergy
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hclosure : closureVector weight dir = 0) :
    momentMassSq weight dir = totalEnergy weight ^ 2 / 4 := by
  unfold momentMassSq normSq vdot closureVector at *
  simp_all +decide [funext_iff]

/-- The corresponding one-face mass source pairs to the rest-energy square. -/
theorem closed_visibleFan_massSource_pairing_eq_restEnergy
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hclosure : closureVector weight dir = 0) :
    sourcePairing (massSource weight dir) unitTest = totalEnergy weight ^ 2 / 4 := by
  convert closed_visibleFan_mass_eq_restEnergy weight dir hclosure using 1
  unfold sourcePairing massSource unitTest
  unfold dot
  norm_num

/--
A closed visible fan with nonzero total energy has strictly positive moment
mass square.

This is the finite no-go form of the P9 guardrail: visible closure is a
rest-frame condition, not source invisibility.
-/
theorem closed_visibleFan_mass_pos_of_nonzero_energy
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hclosure : closureVector weight dir = 0)
    (hE : Not (totalEnergy weight = 0)) :
    0 < momentMassSq weight dir := by
  rw [closed_visibleFan_mass_eq_restEnergy weight dir hclosure]
  positivity

/--
The corresponding one-face mass source is visible to the unit test whenever the
closed fan has nonzero total energy.
-/
theorem closed_visibleFan_massSource_visible_of_nonzero_energy
    {n : Nat} (weight : Fin n -> Real) (dir : Fin n -> Vec3)
    (hclosure : closureVector weight dir = 0)
    (hE : Not (totalEnergy weight = 0)) :
    0 < sourcePairing (massSource weight dir) unitTest := by
  rw [closed_visibleFan_massSource_pairing_eq_restEnergy weight dir hclosure]
  positivity

end PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore
