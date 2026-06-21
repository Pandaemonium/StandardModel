import PhysicsSM.Gauge.CausalDiamondHolonomy

/-!
# Draft.CausalDiamondHigherGaugeAristotle

Focused Aristotle handoff for the next finite higher-gauge wrapper around
trusted causal-diamond holonomy.

`PhysicsSM.Gauge.CausalDiamondHolonomy` now proves the core path-pair
composition laws for glued causal diamonds. This draft asks Aristotle to fill
the small but useful coherence layer:

1. named endpoint transport / whiskering for non-Abelian defects;
2. transport functoriality;
3. vertical composition restated in transport notation;
4. associativity and interchange for finite path-pair composition.

This is still finite group algebra. It does not assert a continuum
non-Abelian Stokes theorem, a smooth gerbe, or a full 2-category of surfaces.
-/

noncomputable section

namespace PhysicsSM.Draft.CausalDiamondHigherGauge

open PhysicsSM.Gauge.CausalDiamondHolonomy

variable {G : Type*}

/-!
## Endpoint transport of non-Abelian defects

The trusted vertical-composition theorem says that the lower defect is
conjugated by the left branch of the upper diamond before multiplying the
upper defect. The following definition names that operation.
-/

/-- Transport a basepointed non-Abelian defect along a path holonomy. -/
def transportDefect [Group G] (h x : G) : G :=
  h⁻¹ * x * h

/-- Transport by the identity path is trivial. -/
theorem transportDefect_one [Group G] (x : G) :
    transportDefect (1 : G) x = x := by
  simp [transportDefect]

/-- Transport preserves products of defects. -/
theorem transportDefect_mul [Group G] (h x y : G) :
    transportDefect h (x * y) =
      transportDefect h x * transportDefect h y := by
  unfold transportDefect; group

/--
Transport along a composite path is iterated transport. With the convention
`transportDefect h x = h^-1 * x * h`, transport along `h * k` is transport by
`h` followed by transport by `k`.
-/
theorem transportDefect_comp [Group G] (h k x : G) :
    transportDefect (h * k) x =
      transportDefect k (transportDefect h x) := by
  unfold transportDefect; group

/-!
## Composition laws in transport notation
-/

/--
Vertical gluing of path-pair defects, restated with the named transport
operation.
-/
theorem pathPairDefect_verticalCompose_transport [Group G]
    (P Q : PathPair G) :
    pathPairDefect (verticalComposePathPair P Q) =
      transportDefect Q.left (pathPairDefect P) * pathPairDefect Q := by
  rw [pathPairDefect_verticalCompose]
  simp [transportDefect, mul_assoc]

/-- Vertical path-pair composition is associative. -/
theorem verticalComposePathPair_assoc [Semigroup G]
    (P Q R : PathPair G) :
    verticalComposePathPair (verticalComposePathPair P Q) R =
      verticalComposePathPair P (verticalComposePathPair Q R) := by
  simp [verticalComposePathPair, mul_assoc]

/-- Horizontal path-pair composition is associative at the outside-boundary level. -/
theorem horizontalComposePathPair_assoc [Mul G]
    (P Q R : PathPair G) :
    horizontalComposePathPair (horizontalComposePathPair P Q) R =
      horizontalComposePathPair P (horizontalComposePathPair Q R) := rfl

/--
Finite interchange law: vertical and horizontal gluing of a 2-by-2 array of
path pairs have the same outside branch holonomies.
-/
theorem pathPair_interchange [Mul G]
    (A B C D : PathPair G) :
    horizontalComposePathPair
        (verticalComposePathPair A C)
        (verticalComposePathPair B D) =
      verticalComposePathPair
        (horizontalComposePathPair A B)
        (horizontalComposePathPair C D) := rfl

end PhysicsSM.Draft.CausalDiamondHigherGauge

end
