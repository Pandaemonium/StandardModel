import Mathlib.Tactic

/-!
# P9 boundary plus visible-source decomposition

This focused package gives the finite Hodge-style algebra behind the P9
source-visibility program: adding a boundary-exact source changes neither
closed-test pairings nor invisibility. Thus closed bulk tests only see the
residual visible component of a source decomposition.
-/

noncomputable section

namespace NullEdgeP9BoundaryVisibleDecomp

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

def InvisibleToClosedBulkTests {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) : Prop :=
  forall test : Cochain f, BulkClosed D test -> sourcePairing source test = 0

def addCochain {n : Nat} (x y : Cochain n) : Cochain n :=
  fun i => x i + y i

theorem boundarySource_pairing_eq_boundary_potential_pairing
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (a : Cochain b) (test : Cochain f) :
    sourcePairing (boundarySource D a) test = dot a (codiff D test) := by
  sorry

theorem sourcePairing_add_boundarySource_eq_left_of_closed
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) (a : Cochain b) (test : Cochain f)
    (hclosed : BulkClosed D test) :
    sourcePairing (addCochain source (boundarySource D a)) test =
      sourcePairing source test := by
  sorry

theorem sourcePairing_boundarySource_add_eq_right_of_closed
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) (a : Cochain b) (test : Cochain f)
    (hclosed : BulkClosed D test) :
    sourcePairing (addCochain (boundarySource D a) source) test =
      sourcePairing source test := by
  sorry

theorem invisible_iff_after_boundary_perturbation
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) (a : Cochain b) :
    InvisibleToClosedBulkTests D (addCochain source (boundarySource D a)) <->
      InvisibleToClosedBulkTests D source := by
  sorry

end NullEdgeP9BoundaryVisibleDecomp
