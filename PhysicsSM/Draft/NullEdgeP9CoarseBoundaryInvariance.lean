import Mathlib.Tactic

/-!
# P9 coarse-grained boundary-invariance core

This module integrates Aristotle project
`e9a2ef62-0ab6-4db5-97a8-b2c904585fae`.

Scientific role: a coarse-grained P9 statistic is not useful if it changes
under boundary-exact bookkeeping. This file proves the finite algebraic
guardrail: when the coarse-graining map annihilates the boundary perturbation,
both the coarse source and any quadratic coarse response are unchanged.

This supports the discrete-first P9 gate: the model does not need pointwise
continuum behavior at the microscopic graph scale, but it does need stable
observer-scale readouts under the declared coarse-graining map.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9CoarseBoundaryInvariance

abbrev Vec (n : Nat) := Fin n -> Real

/-- Add two finite source vectors. -/
def addVec {n : Nat} (x y : Vec n) : Vec n :=
  fun i => x i + y i

/-- Push a fine source to a coarse source using `R`. -/
def pushforward {m n : Nat} (R : Fin m -> Fin n -> Real) (x : Vec n) : Vec m :=
  fun a => Finset.univ.sum fun i => R a i * x i

/-- Quadratic response of a finite kernel. -/
def response {n : Nat} (K : Fin n -> Fin n -> Real) (x : Vec n) : Real :=
  Finset.univ.sum fun i => Finset.univ.sum fun j => x i * K i j * x j

/-- If `R` annihilates a perturbation, pushforward is invariant under it. -/
theorem pushforward_boundary_invariant {m n : Nat}
    (R : Fin m -> Fin n -> Real) (source boundary : Vec n)
    (hboundary : pushforward R boundary = 0) :
    pushforward R (addVec source boundary) = pushforward R source := by
  funext a
  have hb : (Finset.univ.sum fun i => R a i * boundary i) = 0 := congrFun hboundary a
  simp only [pushforward, addVec, mul_add, Finset.sum_add_distrib, hb, add_zero]

/-- Quadratic coarse response is invariant under perturbations killed by `R`. -/
theorem response_boundary_invariant {m n : Nat}
    (R : Fin m -> Fin n -> Real) (K : Fin m -> Fin m -> Real)
    (source boundary : Vec n)
    (hboundary : pushforward R boundary = 0) :
    response K (pushforward R (addVec source boundary)) =
      response K (pushforward R source) := by
  rw [pushforward_boundary_invariant R source boundary hboundary]

/--
Equivalent pointwise form of the boundary-annihilation hypothesis, useful for
finite block-map pilots.
-/
theorem pushforward_boundary_invariant_pointwise {m n : Nat}
    (R : Fin m -> Fin n -> Real) (source boundary : Vec n)
    (hboundary : forall a, (Finset.univ.sum fun i => R a i * boundary i) = 0) :
    pushforward R (addVec source boundary) = pushforward R source := by
  funext a
  simp only [pushforward, addVec, mul_add, Finset.sum_add_distrib, hboundary a, add_zero]

end PhysicsSM.Draft.NullEdgeP9CoarseBoundaryInvariance

end
