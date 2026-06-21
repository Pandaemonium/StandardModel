import PhysicsSM.Gauge.CausalDiamondHolonomy

/-!
# Gauge.CausalDiamondStack

Trusted finite stack and endpoint-gauge wrappers for causal-diamond path
pairs.

This module extends `PhysicsSM.Gauge.CausalDiamondHolonomy` with the small
amount of group algebra needed to speak about finite vertical stacks of path
pairs.  A stack is ordered bottom-to-top: `P :: Ps` traverses `P` first and
then the already-stacked upper part `Ps`.

The main statements are finite algebraic Stokes-style identities:

* non-Abelian stack defects are ordered products of transported cell defects;
* Abelian stack defects are ordinary products of cell defects;
* stacks of flat path pairs have trivial total defect;
* endpoint gauge transformations conjugate the path-pair defect by the top
  endpoint gauge, and are invariant in commutative groups.

These are finite group-theoretic facts only.  They do not assert a continuum
Stokes theorem, a smooth connection, or a non-Abelian gerbe holonomy.

Sources and provenance:
* `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
* `AgentTasks/null-edge-overnight-synthesis-aristotle-2026-06-21.md`
* Promoted from the no-sorry draft
  `PhysicsSM.Draft.NullEdgeOvernightSynthesisAristotle` after semantic review.

Status: trusted, no `sorry`.
-/

noncomputable section

namespace PhysicsSM.Gauge.CausalDiamondHolonomy

variable {G : Type*}

/-! ## Endpoint transport -/

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
  unfold transportDefect
  group

/--
Transport along a composite path is iterated transport.  With the convention
`transportDefect h x = h^-1 * x * h`, transport along `h * k` is transport by
`h` followed by transport by `k`.
-/
theorem transportDefect_comp [Group G] (h k x : G) :
    transportDefect (h * k) x =
      transportDefect k (transportDefect h x) := by
  unfold transportDefect
  group

/-- Vertical gluing of path-pair defects, restated in transport notation. -/
theorem pathPairDefect_verticalCompose_transport [Group G]
    (P Q : PathPair G) :
    pathPairDefect (verticalComposePathPair P Q) =
      transportDefect Q.left (pathPairDefect P) * pathPairDefect Q := by
  rw [pathPairDefect_verticalCompose]
  simp [transportDefect, mul_assoc]

/-! ## Finite vertical stacks -/

/-- A flat path pair with identical left and right branch holonomies. -/
def flatPathPair [One G] (h : G) : PathPair G where
  left := h
  right := h

/-- The identity path pair used as the empty vertical stack. -/
def identityPathPair [One G] : PathPair G :=
  flatPathPair (1 : G)

/--
Vertical stack of path pairs.  The list order is bottom to top: `P :: Ps`
means traverse `P` first, then the already-stacked upper part `Ps`.
-/
def verticalStack [Monoid G] : List (PathPair G) -> PathPair G
  | [] => identityPathPair
  | P :: Ps => verticalComposePathPair P (verticalStack Ps)

/--
The ordered non-Abelian product of transported cell defects for a vertical
stack.  The defect of a lower cell is transported through the total left
branch above it.
-/
def transportedDefectProduct [Group G] : List (PathPair G) -> G
  | [] => 1
  | P :: Ps =>
      transportDefect (verticalStack Ps).left (pathPairDefect P)
        * transportedDefectProduct Ps

/-- A flat path pair has trivial defect. -/
theorem pathPairDefect_flatPathPair [Group G] (h : G) :
    pathPairDefect (flatPathPair h) = 1 := by
  simp [pathPairDefect, flatPathPair]

/--
Finite non-Abelian vertical Stokes theorem for stacked causal diamonds: the
boundary defect of the stack is the ordered product of transported cell
defects.
-/
theorem pathPairDefect_verticalStack_transport [Group G]
    (Ps : List (PathPair G)) :
    pathPairDefect (verticalStack Ps) = transportedDefectProduct Ps := by
  induction Ps with
  | nil =>
      simp [verticalStack, transportedDefectProduct, identityPathPair,
        pathPairDefect_flatPathPair]
  | cons P Ps ih =>
      rw [verticalStack, transportedDefectProduct,
        pathPairDefect_verticalCompose_transport, ih]

/--
Finite Abelian vertical Stokes theorem: in a commutative gauge group, all
transport corrections disappear and the stack defect is the product of the
individual cell defects.
-/
theorem pathPairDefect_verticalStack_comm [CommGroup G]
    (Ps : List (PathPair G)) :
    pathPairDefect (verticalStack Ps) =
      (Ps.map fun P => pathPairDefect P).prod := by
  induction Ps with
  | nil =>
      simp [verticalStack, identityPathPair, pathPairDefect_flatPathPair]
  | cons P Ps ih =>
      rw [verticalStack, pathPairDefect_verticalCompose_comm, ih]
      rfl

/-- A stack of flat path pairs has trivial total defect. -/
theorem pathPairDefect_verticalStack_eq_one_of_all_flat [Group G]
    (Ps : List (PathPair G))
    (hPs : ∀ P ∈ Ps, pathPairDefect P = 1) :
    pathPairDefect (verticalStack Ps) = 1 := by
  rw [pathPairDefect_verticalStack_transport]
  induction Ps with
  | nil =>
      simp [transportedDefectProduct]
  | cons P Ps ih =>
      simp only [transportedDefectProduct] at ih ⊢
      rw [hPs P (by simp)]
      simp [transportDefect, ih (fun Q hQ => hPs Q (by simp [hQ]))]

/-! ## Endpoint gauge transformations of path pairs -/

/-- Endpoint gauge transformation of an abstract path pair. -/
def gaugeTransformPathPair [Group G] (bottom top : G)
    (P : PathPair G) : PathPair G where
  left := bottom⁻¹ * P.left * top
  right := bottom⁻¹ * P.right * top

/--
The path-pair defect is covariant under endpoint gauge transformation; only
the top endpoint gauge survives.
-/
theorem pathPairDefect_gaugeTransformPathPair [Group G]
    (bottom top : G) (P : PathPair G) :
    pathPairDefect (gaugeTransformPathPair bottom top P) =
      top⁻¹ * pathPairDefect P * top := by
  unfold gaugeTransformPathPair pathPairDefect
  group

/-- In an Abelian gauge group, the endpoint-transformed path-pair defect is invariant. -/
theorem pathPairDefect_gaugeTransformPathPair_comm [CommGroup G]
    (bottom top : G) (P : PathPair G) :
    pathPairDefect (gaugeTransformPathPair bottom top P) =
      pathPairDefect P := by
  rw [pathPairDefect_gaugeTransformPathPair]
  simp [mul_comm]

end PhysicsSM.Gauge.CausalDiamondHolonomy

end
