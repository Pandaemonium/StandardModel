import PhysicsSM.Gauge.CausalDiamondHolonomy

/-!
# Null-edge path-pair interchange

This draft module integrates Aristotle project
`3d595909-e7bb-4c44-a4a3-fc86f305774e`.

The trusted causal-diamond API already has vertical and horizontal composition
laws for path pairs and their defects.  The purpose of this module is to bank
the next structural sanity check: those two compositions satisfy the
interchange law expected of a double-category-style path-pair layer.

Claim boundary:

* this proves only the finite path-pair interchange and an Abelian grid product;
* it does not define crossed modules, fake-flatness, or surface transport;
* those higher-gauge notions should now be built on top of this checked finite
  interchange result rather than assumed in prose.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgePathPairInterchange

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
  rfl

/--
The path-pair defect sees the same result on both sides of the interchange law.
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
  rw [pathPair_vertical_horizontal_interchange]

/--
For an Abelian structure group, a compatible `2 x 2` grid has total defect
equal to the product of the four cell defects.
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
  rw [pathPairDefect_verticalCompose_comm,
    pathPairDefect_horizontalCompose P Q hPQ,
    pathPairDefect_horizontalCompose R S hRS]

end PhysicsSM.Draft.NullEdgePathPairInterchange

end
