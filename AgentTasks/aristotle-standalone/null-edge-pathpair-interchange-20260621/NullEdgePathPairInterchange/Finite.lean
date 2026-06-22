import PhysicsSM.Gauge.CausalDiamondHolonomy

noncomputable section

namespace NullEdgePathPairInterchange

open PhysicsSM.Gauge.CausalDiamondHolonomy

variable {G : Type*}

/--
The path-pair API satisfies the vertical/horizontal interchange law at the
level of composed path-pair data.
-/
theorem pathPair_vertical_horizontal_interchange [Mul G]
    (P Q R S : PathPair G) :
    verticalComposePathPair
        (horizontalComposePathPair P Q)
        (horizontalComposePathPair R S) =
      horizontalComposePathPair
        (verticalComposePathPair P R)
        (verticalComposePathPair Q S) := by
  sorry

/--
The path-pair defect sees the same result on both sides of the interchange
law.
-/
theorem pathPairDefect_interchange [Group G]
    (P Q R S : PathPair G) :
    pathPairDefect
        (verticalComposePathPair
          (horizontalComposePathPair P Q)
          (horizontalComposePathPair R S)) =
      pathPairDefect
        (horizontalComposePathPair
          (verticalComposePathPair P R)
          (verticalComposePathPair Q S)) := by
  sorry

/--
For an Abelian structure group, a compatible `2 x 2` grid has defect equal to
the product of the four cell defects.
-/
theorem pathPairDefect_grid_comm [CommGroup G]
    (P Q R S : PathPair G)
    (hPQ : P.right = Q.left)
    (hRS : R.right = S.left) :
    pathPairDefect
        (verticalComposePathPair
          (horizontalComposePathPair P Q)
          (horizontalComposePathPair R S)) =
      pathPairDefect P * pathPairDefect Q *
        (pathPairDefect R * pathPairDefect S) := by
  sorry

end NullEdgePathPairInterchange

end
