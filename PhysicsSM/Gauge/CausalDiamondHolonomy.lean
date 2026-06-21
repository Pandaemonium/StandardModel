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
3. Path-comparison defects compose under vertical and horizontal gluing of
   causal diamonds, with the expected non-Abelian conjugation correction.

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

/-! ## Path-pair abstraction and diamond composition -/

/--
The two branch holonomies of any pair of directed paths with common endpoints.

Unlike `DiamondLabels`, this structure does not remember the individual edges.
It is the right finite abstraction for gluing diamonds into larger causal
rectangles: after gluing, each branch may itself be a composite path.
-/
structure PathPair (G : Type*) where
  left : G
  right : G

/-- The path-comparison defect of a pair of parallel branch holonomies. -/
def pathPairDefect [Group G] (P : PathPair G) : G :=
  P.left⁻¹ * P.right

/-- Forget a four-edge diamond down to its two branch holonomies. -/
def pathPairOfDiamond [Mul G] (U : DiamondLabels G) : PathPair G where
  left := leftHolonomy U
  right := rightHolonomy U

/-- The path-pair defect of a four-edge diamond is its diamond defect. -/
theorem pathPairDefect_pathPairOfDiamond [Group G] (U : DiamondLabels G) :
    pathPairDefect (pathPairOfDiamond U) = diamondDefect U := rfl

/--
Vertical gluing of two path pairs: first traverse `P`, then traverse `Q`.

This models stacked causal diamonds.  The two composite branches are the
products of the corresponding branch holonomies.
-/
def verticalComposePathPair [Mul G] (P Q : PathPair G) : PathPair G where
  left := P.left * Q.left
  right := P.right * Q.right

/--
Non-Abelian vertical composition law for causal-diamond defects.

For stacked diamonds, the lower defect must be transported through the left
branch of the upper diamond before it multiplies the upper defect.
-/
theorem pathPairDefect_verticalCompose [Group G]
    (P Q : PathPair G) :
    pathPairDefect (verticalComposePathPair P Q) =
      Q.left⁻¹ * pathPairDefect P * Q.left * pathPairDefect Q := by
  simp [pathPairDefect, verticalComposePathPair, mul_assoc]

/--
In an Abelian gauge group, vertically glued causal-diamond defects multiply
with no conjugation correction.
-/
theorem pathPairDefect_verticalCompose_comm [CommGroup G]
    (P Q : PathPair G) :
    pathPairDefect (verticalComposePathPair P Q) =
      pathPairDefect P * pathPairDefect Q := by
  rw [pathPairDefect_verticalCompose]
  simp [mul_comm]

/--
Horizontal gluing of two path pairs, keeping the outside left branch of `P`
and the outside right branch of `Q`.

The theorem below supplies the compatibility hypothesis saying that the inner
branches match.
-/
def horizontalComposePathPair [Mul G] (P Q : PathPair G) : PathPair G where
  left := P.left
  right := Q.right

/--
Horizontal composition law for compatible causal-diamond defects.

If the right branch of the left diamond is the same path holonomy as the left
branch of the right diamond, the shared branch cancels.
-/
theorem pathPairDefect_horizontalCompose [Group G]
    (P Q : PathPair G) (h : P.right = Q.left) :
    pathPairDefect (horizontalComposePathPair P Q) =
      pathPairDefect P * pathPairDefect Q := by
  simp [pathPairDefect, horizontalComposePathPair, h, mul_assoc]

/-- A path-pair defect is trivial exactly when the two branch holonomies agree. -/
theorem pathPairDefect_eq_one_iff [Group G] (P : PathPair G) :
    pathPairDefect P = 1 ↔ P.left = P.right := by
  constructor
  · intro h
    change P.left⁻¹ * P.right = 1 at h
    exact inv_mul_eq_one.mp h
  · intro h
    change P.left⁻¹ * P.right = 1
    exact inv_mul_eq_one.mpr h

/-- Vertical composition with a flat lower pair leaves the upper defect. -/
theorem pathPairDefect_verticalCompose_of_left_flat [Group G]
    (P Q : PathPair G) (hP : pathPairDefect P = 1) :
    pathPairDefect (verticalComposePathPair P Q) = pathPairDefect Q := by
  rw [pathPairDefect_verticalCompose, hP]
  simp

/--
Vertical composition with a flat upper pair conjugates the lower defect to the
new top endpoint.
-/
theorem pathPairDefect_verticalCompose_of_right_flat [Group G]
    (P Q : PathPair G) (hQ : pathPairDefect Q = 1) :
    pathPairDefect (verticalComposePathPair P Q) =
      Q.left⁻¹ * pathPairDefect P * Q.left := by
  rw [pathPairDefect_verticalCompose, hQ]
  simp [mul_assoc]

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
