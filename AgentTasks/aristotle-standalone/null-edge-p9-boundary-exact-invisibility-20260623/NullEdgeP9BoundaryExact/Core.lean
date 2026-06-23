import Mathlib.Tactic

noncomputable section

namespace NullEdgeP9BoundaryExact

open BigOperators

/-- Finite cell pairing. -/
def cellPairing {C : Type*} [Fintype C] (source test : C -> Real) : Real :=
  Finset.univ.sum fun c => source c * test c

/-- A boundary-exact source obtained by applying an incidence transpose. -/
def coboundarySource {E C : Type*} [Fintype E] (inc : E -> C -> Real)
    (edgeBookkeeping : E -> Real) : C -> Real :=
  fun c => Finset.univ.sum fun e => inc e c * edgeBookkeeping e

/-- Boundary of a cell test against the same incidence data. -/
def testBoundary {E C : Type*} [Fintype C] (inc : E -> C -> Real)
    (test : C -> Real) : E -> Real :=
  fun e => Finset.univ.sum fun c => inc e c * test c

/--
Finite summation-by-parts identity for the P9 source-visibility branch.

Boundary-exact bookkeeping pairs with a cell test only through the test's
boundary. This is the finite algebra behind "boundary bookkeeping is invisible
to closed bulk tests."
-/
theorem cellPairing_coboundary_eq_boundaryPairing {E C : Type*}
    [Fintype E] [Fintype C] (inc : E -> C -> Real)
    (edgeBookkeeping : E -> Real) (test : C -> Real) :
    cellPairing (coboundarySource inc edgeBookkeeping) test =
      Finset.univ.sum fun e => edgeBookkeeping e * testBoundary inc test e := by
  sorry

/-- Boundary-exact sources are invisible to tests with zero boundary. -/
theorem boundaryExact_invisible_to_closed_tests {E C : Type*}
    [Fintype E] [Fintype C] (inc : E -> C -> Real)
    (edgeBookkeeping : E -> Real) (test : C -> Real)
    (hclosed : forall e, testBoundary inc test e = 0) :
    cellPairing (coboundarySource inc edgeBookkeeping) test = 0 := by
  sorry

end NullEdgeP9BoundaryExact
