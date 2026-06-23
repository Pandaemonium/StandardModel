import Mathlib.Tactic

/-!
# P9 closed-test witness lemmas

This draft module records the finite witness direction of the P9
source-visibility API: a closed bulk test with nonzero pairing certifies that a
source is not invisible, and therefore cannot be boundary-exact in the finite
boundary-source model.

Proven by Aristotle project `24bc10a1-69f5-4402-aca1-7d703ea6c0ae` on
2026-06-23 from the focused package `null-edge-p9-closed-witness-20260623`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9ClosedWitness

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
  zify [sourcePairing, dot, boundarySource, codiff]
  simpa only [Finset.mul_sum _ _ _, Finset.sum_mul, mul_assoc, mul_comm,
    mul_left_comm] using Finset.sum_comm

theorem boundaryExact_invisible_to_closed_tests
    {b f : Nat} (D : Fin b -> Fin f -> Real) (source : Cochain f)
    (hsource : BoundaryExact D source) :
    InvisibleToClosedBulkTests D source := by
  intro test htest
  cases hsource with
  | intro a ha =>
  rw [ha, boundarySource_pairing_eq_boundary_potential_pairing]
  rw [show codiff D test = 0 from htest]
  unfold dot
  simp +decide

theorem not_invisible_of_closed_witness
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source test : Cochain f)
    (hclosed : BulkClosed D test)
    (hpair : sourcePairing source test != 0) :
    Not (InvisibleToClosedBulkTests D source) := by
  exact fun h => by
    have := h test hclosed
    aesop

theorem not_boundaryExact_of_closed_witness
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source test : Cochain f)
    (hclosed : BulkClosed D test)
    (hpair : sourcePairing source test != 0) :
    Not (BoundaryExact D source) := fun h =>
  not_invisible_of_closed_witness D source test hclosed hpair
    (boundaryExact_invisible_to_closed_tests D source h)

end PhysicsSM.Draft.NullEdgeP9ClosedWitness
