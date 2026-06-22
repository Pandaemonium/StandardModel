import Mathlib

/-!
# Finite boundary-source visibility toy model

This focused file isolates the first P9 source-visibility theorem target.
It models a finite source field on faces, a finite boundary potential on
boundary cells, and an arbitrary incidence matrix `D` between them.

The key theorem is a discrete integration-by-parts statement: a source that is
exactly generated from boundary data pairs trivially with every bulk test whose
adjoint divergence vanishes. This is the finite algebraic prototype of the
claim that boundary bookkeeping can be invisible to bulk diamond observables.
-/

noncomputable section

namespace NullEdgeP9BoundarySource

open BigOperators

abbrev Cochain (n : Nat) := Fin n -> Real

/-- Finite Euclidean pairing on `Fin n` cochains. -/
def dot {n : Nat} (x y : Cochain n) : Real :=
  ∑ i, x i * y i

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
  fun i => ∑ j, D j i * a j

/--
Adjoint divergence of a face test against the same incidence matrix.

The signs and geometric orientation are intentionally abstract here; the point
of this toy theorem is the algebraic adjointness relation that any later
oriented diamond/source API must specialize.
-/
def codiff {b f : Nat} (D : Fin b -> Fin f -> Real)
    (test : Cochain f) : Cochain b :=
  fun j => ∑ i, D j i * test i

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
  sorry

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
  sorry

/-- Boundary-source invisibility is invariant under adding boundary bookkeeping. -/
theorem sourcePairing_eq_of_boundary_difference
    {b f : Nat} (D : Fin b -> Fin f -> Real)
    (source : Cochain f) (a : Cochain b) (test : Cochain f)
    (hclosed : BulkClosed D test) :
    sourcePairing (fun i => source i + boundarySource D a i) test =
      sourcePairing source test := by
  sorry

/-- The source pairing is additive in the source slot. -/
theorem sourcePairing_add_left {n : Nat}
    (source₁ source₂ test : Cochain n) :
    sourcePairing (fun i => source₁ i + source₂ i) test =
      sourcePairing source₁ test + sourcePairing source₂ test := by
  sorry

/-- The source pairing is additive in the test slot. -/
theorem sourcePairing_add_right {n : Nat}
    (source test₁ test₂ : Cochain n) :
    sourcePairing source (fun i => test₁ i + test₂ i) =
      sourcePairing source test₁ + sourcePairing source test₂ := by
  sorry

end NullEdgeP9BoundarySource
