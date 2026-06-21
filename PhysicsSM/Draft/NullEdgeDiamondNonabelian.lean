import PhysicsSM.Draft.NullEdgeCoreAristotle

/-!
# Draft.NullEdgeDiamondNonabelian

This draft module strengthens the Abelian causal-diamond holonomy theorem in
`PhysicsSM.Draft.NullEdgeCoreAristotle`.

The Abelian theorem says that the path-comparison defect across a causal
diamond is gauge invariant.  The physically correct non-Abelian statement is
covariance by conjugation at the common endpoint.  Gauge-invariant quantities
are then obtained by applying class functions, such as traces in matrix
representations.

This is a finite group-theoretic theorem.  It does not claim a continuum
Stokes theorem or a full higher-gauge construction.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeDiamondNonabelian

open PhysicsSM.Draft.NullEdgeCore

variable {G : Type*}

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

In a commutative group this reduces to the Abelian gauge-invariance theorem in
`PhysicsSM.Draft.NullEdgeCore`.
-/
theorem diamondDefect_gauge_covariant [Group G]
    (g : DiamondGauge G) (U : DiamondLabels G) :
    diamondDefect (gaugeTransformDiamond g U) =
      g.top⁻¹ * diamondDefect U * g.top := by
  rw [diamondDefect, leftHolonomy_gaugeTransformDiamond,
    rightHolonomy_gaugeTransformDiamond, diamondDefect]
  simp [mul_assoc]

end PhysicsSM.Draft.NullEdgeDiamondNonabelian

end
