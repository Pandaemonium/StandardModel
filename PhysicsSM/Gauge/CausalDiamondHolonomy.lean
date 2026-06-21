import Mathlib

/-!
# Gauge.CausalDiamondHolonomy

Trusted finite causal-diamond holonomy algebra for the null-edge causal graph
program.

A causal directed acyclic graph does not have ordinary plaquette loops.  The
finite replacement used here is a causal diamond: two directed paths from a
bottom vertex to a top vertex.  Edge labels live in a group and the
path-comparison defect compares the two branch holonomies.

This module proves two finite gauge facts:

1. In an Abelian gauge group, the diamond defect is invariant under arbitrary
   vertex gauge transformations.
2. In a non-Abelian gauge group, the defect is covariant by conjugation at the
   top endpoint, so every class function of the defect is gauge invariant.

These are finite group-theoretic statements only.  They do not assert a
continuum Stokes theorem, a continuum field strength, or a higher-gauge
2-connection.

Sources and provenance:
- `Sources/Null_Edge_Causal_Graph_Research_Plan.md`, Pillar 5.
- First developed in no-sorry draft modules
  `PhysicsSM.Draft.NullEdgeCoreAristotle`,
  `PhysicsSM.Draft.NullEdgeDiamondNonabelian`, and
  `PhysicsSM.Draft.NullEdgeCochainDiamond`.
- Literature context: causal-set gauge fields and higher-gauge theory as
  recorded in the null-edge source notes.

Status: trusted, no `sorry`.
-/

noncomputable section

namespace PhysicsSM.Gauge.CausalDiamondHolonomy

/-! ## Finite diamond labels and gauge transformations -/

/--
The four edge labels of a finite causal diamond:

```text
      top
     /   \
   left right
     \   /
    bottom
```

The two directed paths from `bottom` to `top` are
`bottomLeft * leftTop` and `bottomRight * rightTop`.
-/
structure DiamondLabels (G : Type*) where
  bottomLeft : G
  leftTop : G
  bottomRight : G
  rightTop : G

/-- Vertex gauge parameters for the same finite diamond. -/
structure DiamondGauge (G : Type*) where
  bottom : G
  left : G
  right : G
  top : G

variable {G A : Type*}

/-- Holonomy along the left branch of the diamond. -/
def leftHolonomy [Mul G] (U : DiamondLabels G) : G :=
  U.bottomLeft * U.leftTop

/-- Holonomy along the right branch of the diamond. -/
def rightHolonomy [Mul G] (U : DiamondLabels G) : G :=
  U.bottomRight * U.rightTop

/-- The path-comparison defect across the diamond. -/
def diamondDefect [Group G] (U : DiamondLabels G) : G :=
  (leftHolonomy U)⁻¹ * rightHolonomy U

/-- Vertex gauge transformation of edge transports. -/
def gaugeTransformDiamond [Group G] (g : DiamondGauge G)
    (U : DiamondLabels G) : DiamondLabels G where
  bottomLeft := g.bottom⁻¹ * U.bottomLeft * g.left
  leftTop := g.left⁻¹ * U.leftTop * g.top
  bottomRight := g.bottom⁻¹ * U.bottomRight * g.right
  rightTop := g.right⁻¹ * U.rightTop * g.top

/-! ## Non-Abelian covariance and class-function invariants -/

/--
Under a vertex gauge transformation, the left branch holonomy is conjugated by
the bottom and top endpoint gauges.
-/
theorem leftHolonomy_gaugeTransformDiamond [Group G]
    (g : DiamondGauge G) (U : DiamondLabels G) :
    leftHolonomy (gaugeTransformDiamond g U) =
      g.bottom⁻¹ * leftHolonomy U * g.top := by
  simp [leftHolonomy, gaugeTransformDiamond, mul_assoc]

/--
Under a vertex gauge transformation, the right branch holonomy is conjugated
by the same bottom and top endpoint gauges.
-/
theorem rightHolonomy_gaugeTransformDiamond [Group G]
    (g : DiamondGauge G) (U : DiamondLabels G) :
    rightHolonomy (gaugeTransformDiamond g U) =
      g.bottom⁻¹ * rightHolonomy U * g.top := by
  simp [rightHolonomy, gaugeTransformDiamond, mul_assoc]

/--
Non-Abelian causal-diamond curvature carrier: the raw path-comparison defect
is gauge covariant by conjugation at the common top endpoint.
-/
theorem diamondDefect_gauge_covariant [Group G]
    (g : DiamondGauge G) (U : DiamondLabels G) :
    diamondDefect (gaugeTransformDiamond g U) =
      g.top⁻¹ * diamondDefect U * g.top := by
  rw [diamondDefect, leftHolonomy_gaugeTransformDiamond,
    rightHolonomy_gaugeTransformDiamond, diamondDefect]
  simp [mul_assoc]

/-! ## Abelian gauge invariance -/

/--
Finite Abelian causal-diamond curvature carrier: the path-comparison defect
is invariant under arbitrary vertex gauge transformations.

This is the commutative specialization of non-Abelian endpoint covariance.
-/
theorem diamondDefect_gauge_invariant [CommGroup G]
    (g : DiamondGauge G) (U : DiamondLabels G) :
    diamondDefect (gaugeTransformDiamond g U) = diamondDefect U := by
  rw [diamondDefect_gauge_covariant]
  simp [mul_comm]

/-- A class function is constant on conjugacy classes. -/
def IsClassFunction [Group G] (F : G -> A) : Prop :=
  ∀ g x : G, F (g⁻¹ * x * g) = F x

/--
Any class function of the non-Abelian diamond defect is gauge invariant.

This is the finite graph version of taking a trace of a plaquette holonomy in
a non-Abelian lattice gauge theory.
-/
theorem diamondDefect_classFunction_gauge_invariant [Group G]
    (F : G -> A) (hF : IsClassFunction F)
    (g : DiamondGauge G) (U : DiamondLabels G) :
    F (diamondDefect (gaugeTransformDiamond g U)) = F (diamondDefect U) := by
  rw [diamondDefect_gauge_covariant]
  exact hF g.top (diamondDefect U)

end PhysicsSM.Gauge.CausalDiamondHolonomy

end
