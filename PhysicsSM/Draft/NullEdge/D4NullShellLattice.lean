import Mathlib

/-!
# A Lorentzian null shell selected from the D4 root lattice

The 24 roots of `D4` are represented explicitly as the integer vectors with
two nonzero coordinates, each equal to plus or minus one. After coordinate zero
is selected as time, exactly twelve roots are Minkowski-null. Every selected root has unit time
magnitude and unit spatial squared displacement, so it is a primitive axial
luminal step in units where `c=1`.

The Lorentzian time-coordinate selection is supplied, not derived from the
Euclidean D4 lattice. The remaining twelve roots are spacelike; a concrete one
is retained as a required control. This module does not construct a BCC or
tetrahedral walk, spinor projectors, dynamics, or a continuum limit.

Provenance: D4 route proposed during the 2026-07-09 discussion; finite
classification completed without compiled-evaluator trust by Aristotle project
`1b9a9cad-67b2-46ef-a56c-c6f46b4c6ea0`.
-/

namespace PhysicsSM.Draft.NullEdge.D4NullShellLattice

abbrev Vec4 := Fin 4 -> ℤ

def rootsList : List Vec4 := [
  ![1, 1, 0, 0], ![1, -1, 0, 0], ![-1, 1, 0, 0], ![-1, -1, 0, 0],
  ![1, 0, 1, 0], ![1, 0, -1, 0], ![-1, 0, 1, 0], ![-1, 0, -1, 0],
  ![1, 0, 0, 1], ![1, 0, 0, -1], ![-1, 0, 0, 1], ![-1, 0, 0, -1],
  ![0, 1, 1, 0], ![0, 1, -1, 0], ![0, -1, 1, 0], ![0, -1, -1, 0],
  ![0, 1, 0, 1], ![0, 1, 0, -1], ![0, -1, 0, 1], ![0, -1, 0, -1],
  ![0, 0, 1, 1], ![0, 0, 1, -1], ![0, 0, -1, 1], ![0, 0, -1, -1]]

def roots : Finset Vec4 := rootsList.toFinset

def euclideanNormSq (v : Vec4) : ℤ := ∑ i, (v i) ^ 2

/-- Signature `(+---)`, with coordinate zero selected as time. -/
def minkowskiSq (v : Vec4) : ℤ :=
  (v 0) ^ 2 - (v 1) ^ 2 - (v 2) ^ 2 - (v 3) ^ 2

def nullRoots : Finset Vec4 := roots.filter (fun v => minkowskiSq v = 0)

theorem d4_root_count : roots.card = 24 := by decide

theorem every_root_has_norm_two :
    ∀ v ∈ roots, euclideanNormSq v = 2 := by decide

/-- Exactly the twelve D4 roots involving the distinguished time coordinate
are Minkowski-null. -/
theorem null_root_count : nullRoots.card = 12 := by decide

/-- Every selected root is a primitive luminal step: unit time magnitude and
unit spatial squared displacement. -/
theorem every_null_root_is_unit_luminal :
    ∀ v ∈ nullRoots,
      |v 0| = 1 ∧ (v 1) ^ 2 + (v 2) ^ 2 + (v 3) ^ 2 = 1 := by decide

theorem null_shell_antipodal :
    ∀ v ∈ nullRoots, (-v) ∈ nullRoots := by decide

/-- Selection is essential: the D4 shell also contains purely spatial roots,
which are spacelike in the displayed Lorentz convention. -/
theorem spacelike_root_control :
    (![0, 1, 1, 0] : Vec4) ∈ roots ∧
      (![0, 1, 1, 0] : Vec4) ∉ nullRoots ∧
      minkowskiSq ![0, 1, 1, 0] = -2 := by decide

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.D4NullShellLattice.null_root_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms null_root_count

/-- info: 'PhysicsSM.Draft.NullEdge.D4NullShellLattice.every_null_root_is_unit_luminal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms every_null_root_is_unit_luminal

/-- info: 'PhysicsSM.Draft.NullEdge.D4NullShellLattice.spacelike_root_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spacelike_root_control

end PhysicsSM.Draft.NullEdge.D4NullShellLattice
