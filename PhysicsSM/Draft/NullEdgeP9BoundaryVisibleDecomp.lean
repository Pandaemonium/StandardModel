import Mathlib.Tactic

/-!
# P9 boundary plus visible-source decomposition

This draft module gives the finite Hodge-style algebra behind the P9
source-visibility program: adding a boundary-exact source changes neither
closed-test pairings nor invisibility. Thus closed bulk tests only see the
residual visible component of a source decomposition.

Proven by Aristotle project `3f39ceda-a85a-4c36-bda7-908cf513215d` on
2026-06-23 from the focused package
`null-edge-p9-boundary-visible-decomp-20260623`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9BoundaryVisibleDecomp

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
  unfold sourcePairing boundarySource dot codiff
  simpa only [mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _] using
    Finset.sum_comm

theorem sourcePairing_add_boundarySource_eq_left_of_closed
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) (a : Cochain b) (test : Cochain f)
    (hclosed : BulkClosed D test) :
    sourcePairing (addCochain source (boundarySource D a)) test =
      sourcePairing source test := by
  have h_linear :
      sourcePairing (addCochain source (boundarySource D a)) test =
        sourcePairing source test + sourcePairing (boundarySource D a) test := by
    unfold sourcePairing addCochain
    unfold dot
    simp +decide [Finset.sum_add_distrib, add_mul]
  rw [h_linear, boundarySource_pairing_eq_boundary_potential_pairing, hclosed,
    dot, Finset.sum_eq_zero] <;> aesop

theorem sourcePairing_boundarySource_add_eq_right_of_closed
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) (a : Cochain b) (test : Cochain f)
    (hclosed : BulkClosed D test) :
    sourcePairing (addCochain (boundarySource D a) source) test =
      sourcePairing source test := by
  convert sourcePairing_add_boundarySource_eq_left_of_closed D source a test hclosed using 1
  unfold addCochain sourcePairing
  simp +decide [add_comm]

theorem invisible_iff_after_boundary_perturbation
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) (a : Cochain b) :
    InvisibleToClosedBulkTests D (addCochain source (boundarySource D a)) <->
      InvisibleToClosedBulkTests D source := by
  constructor <;> intro h <;> intro test htest <;> have := htest <;>
    simp_all +decide [InvisibleToClosedBulkTests,
      sourcePairing_add_boundarySource_eq_left_of_closed]

end PhysicsSM.Draft.NullEdgeP9BoundaryVisibleDecomp
