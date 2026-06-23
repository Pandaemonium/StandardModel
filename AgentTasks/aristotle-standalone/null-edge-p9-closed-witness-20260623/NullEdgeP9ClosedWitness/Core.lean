import Mathlib.Tactic

/-!
# P9 closed-test witness lemmas

This focused package records the finite witness direction of the P9
source-visibility API: a closed bulk test with nonzero pairing certifies that a
source is not invisible, and therefore cannot be boundary-exact in the finite
boundary-source model.
-/

noncomputable section

namespace NullEdgeP9ClosedWitness

open BigOperators

abbrev Cochain (n : Nat) := Fin n -> Real

def dot {n : Nat} (x y : Cochain n) : Real :=
  Finset.univ.sum fun i => x i * y i

def sourcePairing {n : Nat} (source test : Cochain n) : Real :=
  dot source test

def boundarySource {b f : Nat} (D : Fin b -> Fin f -> Real)
    (a : Cochain b) : Cochain f :=
  fun i => Finset.univ.sum fun j => D j i * a j

def codiff {b f : Nat} (D : Fin b -> Fin f -> Real)
    (test : Cochain f) : Cochain b :=
  fun j => Finset.univ.sum fun i => D j i * test i

def BulkClosed {b f : Nat} (D : Fin b -> Fin f -> Real)
    (test : Cochain f) : Prop :=
  codiff D test = 0

def BoundaryExact {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) : Prop :=
  exists a : Cochain b, source = boundarySource D a

def InvisibleToClosedBulkTests {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) : Prop :=
  forall test : Cochain f, BulkClosed D test -> sourcePairing source test = 0

theorem boundarySource_pairing_eq_boundary_potential_pairing
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (a : Cochain b) (test : Cochain f) :
    sourcePairing (boundarySource D a) test = dot a (codiff D test) := by
  sorry

theorem boundaryExact_invisible_to_closed_tests
    {b f : Nat} (D : Fin b -> Fin f -> Real) (source : Cochain f)
    (hsource : BoundaryExact D source) :
    InvisibleToClosedBulkTests D source := by
  sorry

theorem not_invisible_of_closed_witness
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source test : Cochain f)
    (hclosed : BulkClosed D test)
    (hpair : sourcePairing source test != 0) :
    Not (InvisibleToClosedBulkTests D source) := by
  sorry

theorem not_boundaryExact_of_closed_witness
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source test : Cochain f)
    (hclosed : BulkClosed D test)
    (hpair : sourcePairing source test != 0) :
    Not (BoundaryExact D source) := by
  sorry

end NullEdgeP9ClosedWitness
