import Mathlib

/-!
# Finite boundary-source visibility toy model

This module records the first small theorem island for the P9
source-visibility campaign. It models a finite source field on faces, a finite
boundary potential on boundary cells, and an arbitrary incidence matrix `D`
between them.

The key result is a discrete integration-by-parts statement: a source generated
from boundary data pairs trivially with every bulk test whose adjoint divergence
vanishes. This is only a finite toy theorem, but it is the algebraic prototype
needed before making a sharper cosmological-constant/source-invisibility claim.

Proven by Aristotle project `ea84d10d-e796-4393-8a9d-7d252007fd27`
on 2026-06-22 from the focused standalone package
`null-edge-p9-boundary-source-zero-20260622`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9BoundarySource

abbrev Cochain (n : Nat) := Fin n -> Real

/-- Finite Euclidean pairing on `Fin n` cochains. -/
def dot {n : Nat} (x y : Cochain n) : Real :=
  Finset.univ.sum fun i => x i * y i

/-- Pair a finite source with a finite bulk test observable. -/
def sourcePairing {n : Nat} (source test : Cochain n) : Real :=
  dot source test

/--
Boundary-generated source on faces.

The matrix `D : Fin b -> Fin f -> Real` should be read as the finite incidence
operator from boundary cells to face/source cells.
-/
def boundarySource {b f : Nat} (D : Fin b -> Fin f -> Real)
    (a : Cochain b) : Cochain f :=
  fun i => Finset.univ.sum fun j => D j i * a j

/--
Adjoint divergence of a face test against the same incidence matrix.

The signs and geometric orientation are intentionally abstract here; the point
of this toy theorem is the algebraic adjointness relation that any later
oriented diamond/source API must specialize.
-/
def codiff {b f : Nat} (D : Fin b -> Fin f -> Real)
    (test : Cochain f) : Cochain b :=
  fun j => Finset.univ.sum fun i => D j i * test i

/-- A bulk test is closed when its adjoint divergence vanishes. -/
def BulkClosed {b f : Nat} (D : Fin b -> Fin f -> Real)
    (test : Cochain f) : Prop :=
  codiff D test = 0

/--
Discrete integration by parts for a finite boundary-generated source.

This is the algebraic theorem behind `boundaryExact_source_eq_zero`.
-/
theorem boundarySource_pairing_eq_boundary_potential_pairing
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (a : Cochain b) (test : Cochain f) :
    sourcePairing (boundarySource D a) test = dot a (codiff D test) := by
  unfold sourcePairing dot boundarySource codiff
  simp only [Finset.sum_mul, Finset.mul_sum]
  rw [Finset.sum_comm]
  congr 1
  ext j
  congr 1
  ext i
  ring

/--
Boundary-exact source terms vanish against closed bulk tests.

This is the first finite P9 visibility target: a source that is purely boundary
bookkeeping cannot be seen by a bulk observable whose adjoint divergence is zero.
-/
theorem boundaryExact_source_eq_zero
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (a : Cochain b) (test : Cochain f)
    (hclosed : BulkClosed D test) :
    sourcePairing (boundarySource D a) test = 0 := by
  rw [boundarySource_pairing_eq_boundary_potential_pairing]
  unfold BulkClosed at hclosed
  rw [hclosed]
  simp [dot]

/-- Boundary-source invisibility is invariant under adding boundary bookkeeping. -/
theorem sourcePairing_eq_of_boundary_difference
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) (a : Cochain b) (test : Cochain f)
    (hclosed : BulkClosed D test) :
    sourcePairing (fun i => source i + boundarySource D a i) test =
      sourcePairing source test := by
  unfold sourcePairing dot
  simp only [add_mul]
  rw [Finset.sum_add_distrib]
  have hz : Finset.univ.sum (fun i => boundarySource D a i * test i) = 0 := by
    have hzero := boundaryExact_source_eq_zero D a test hclosed
    unfold sourcePairing dot at hzero
    exact hzero
  rw [hz, add_zero]

/-- The source pairing is additive in the source slot. -/
theorem sourcePairing_add_left {n : Nat}
    (source1 source2 test : Cochain n) :
    sourcePairing (fun i => source1 i + source2 i) test =
      sourcePairing source1 test + sourcePairing source2 test := by
  unfold sourcePairing dot
  simp only [add_mul]
  rw [Finset.sum_add_distrib]

/-- The source pairing is additive in the test slot. -/
theorem sourcePairing_add_right {n : Nat}
    (source test1 test2 : Cochain n) :
    sourcePairing source (fun i => test1 i + test2 i) =
      sourcePairing source test1 + sourcePairing source test2 := by
  unfold sourcePairing dot
  simp only [mul_add]
  rw [Finset.sum_add_distrib]

end PhysicsSM.Draft.NullEdgeP9BoundarySource
