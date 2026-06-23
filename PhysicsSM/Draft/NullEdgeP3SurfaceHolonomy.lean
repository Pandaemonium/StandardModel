import Mathlib.Tactic

/-!
# P3 higher-gauge: abelian surface holonomy, interchange, and fake-flatness

The finite abelian shadow of the trusted non-abelian path-pair interchange law
(`PhysicsSM.Gauge.CausalDiamondHolonomy`). On a grid of 2-cells with `Real`
(abelian 2-group) curvature labels, the surface holonomy is the sum of plaquette
curvatures; it is independent of the composition order (interchange), additive
under 2-cell composition, and trivial for a fake-flat (flat 2-)connection.

Source grounding (Neo4j null-edge collection): Baez, "Higher Yang-Mills theory"
(`hep-th/0206130`); higher-gauge / crossed-module 2-connections.

Standalone (Mathlib only).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP3SurfaceHolonomy

open BigOperators

/-- Abelian 2-curvature on an `m` by `n` grid of 2-cells. -/
abbrev Curv (m n : Nat) := Fin m -> Fin n -> Real

/-- Surface holonomy = sum of plaquette curvatures. -/
def surfaceHolonomy {m n : Nat} (F : Curv m n) : Real :=
  Finset.univ.sum fun i => Finset.univ.sum fun j => F i j

/-- Interchange / order-independence of the abelian surface holonomy. -/
theorem surfaceHolonomy_interchange {m n : Nat} (F : Curv m n) :
    surfaceHolonomy F = Finset.univ.sum fun j => Finset.univ.sum fun i => F i j := by
  simpa [surfaceHolonomy] using Finset.sum_comm

/-- Surface holonomy is additive under composition of 2-connections. -/
theorem surfaceHolonomy_add {m n : Nat} (F G : Curv m n) :
    surfaceHolonomy (fun i j => F i j + G i j)
      = surfaceHolonomy F + surfaceHolonomy G := by
  simp only [surfaceHolonomy, Finset.sum_add_distrib]

/-- Fake-flatness: a flat 2-connection has trivial surface holonomy. -/
theorem surfaceHolonomy_flat {m n : Nat} (F : Curv m n) (h : ∀ i j, F i j = 0) :
    surfaceHolonomy F = 0 := by
  simp [surfaceHolonomy, h]

end PhysicsSM.Draft.NullEdgeP3SurfaceHolonomy
