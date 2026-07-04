import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionCore

/-!
# Gate YM3: walk-level reflection and order reversal

This draft module extends `ReflectionCore` from single reflected steps to full
typed walks. The key point is noncommutative order: a reflected walk has to
reverse the order of steps to remain type-correct. After the Route-B
reflection convention in `ReflectionCore.reflectLinkField`, the reflected
link field also carries a group inverse on each reflected edge.

The main target is now the same-group identity

`hol U (mirrorWalk w) = (hol (theta U) w)^-1`.

This is the finite holonomy-transport identity needed before any later
plaquette/reflection or RP-LINK statement. The older opposite-group helper
`opLinkField` is retained only as unused historical scaffolding from the
pre-Route-B migration; downstream Wilson modules use the same-group theorem
`hol_mirrorWalk_eq_inv`. This file still does not prove Wilson action
covariance, cut factorization, or reflection positivity.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity**.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ReflectionCore
namespace Reflection

open GaugeCoreGeneral OrientedLattice

variable {Λ : GaugeCoreGeneral.OrientedLattice}
variable (R : Reflection Λ)
variable {G : Type*} [Group G]

/-- Promote a link field to the opposite group pointwise. This is the
bookkeeping device that records the order reversal introduced by reflecting
typed walks. -/
def opLinkField (U : Λ.LinkField (G := G)) :
    Λ.LinkField (G := MulOpposite G) :=
  fun e => MulOpposite.op (U e)

/-- Step holonomy commutes with pointwise passage to the opposite group. -/
theorem stepHol_opLinkField (U : Λ.LinkField (G := G))
    {x y : Λ.V} (s : GaugeCoreGeneral.OrientedLattice.Step Λ x y) :
    OrientedLattice.stepHol (opLinkField U) s =
      MulOpposite.op (OrientedLattice.stepHol U s) := by
  cases s <;> simp [opLinkField, OrientedLattice.stepHol]

/-- The step-level mirror map: a step `x -> y` reflects to a step
`reflectV y -> reflectV x`. The direction reversal is forced by
`reflect_src`/`reflect_tgt`'s endpoint-swap convention. -/
def reflectStep : {x y : Λ.V} → GaugeCoreGeneral.OrientedLattice.Step Λ x y →
    GaugeCoreGeneral.OrientedLattice.Step Λ (R.reflectV y) (R.reflectV x)
  | _, _, GaugeCoreGeneral.OrientedLattice.Step.fwd e =>
      GaugeCoreGeneral.OrientedLattice.Step.castEndpoints
        (R.reflect_src e) (R.reflect_tgt e)
        (GaugeCoreGeneral.OrientedLattice.Step.fwd (R.reflectE e))
  | _, _, GaugeCoreGeneral.OrientedLattice.Step.rev e =>
      GaugeCoreGeneral.OrientedLattice.Step.castEndpoints
        (R.reflect_tgt e) (R.reflect_src e)
        (GaugeCoreGeneral.OrientedLattice.Step.rev (R.reflectE e))

/-- Step-level compatibility between `reflectLinkField` and the mirrored step
(N3-corrected convention).

Since `reflectLinkField` now carries a group inverse, the reflected step's
holonomy is the INVERSE of the mirrored step's holonomy at the original link
field: `stepHol (theta U) s = (stepHol U (reflectStep s))^{-1}`. This is the
single-step seed of the walk-level `hol_mirrorWalk_eq_inv` below. -/
theorem stepHol_reflectLinkField_reflectStep (U : Λ.LinkField (G := G))
    {x y : Λ.V} (s : GaugeCoreGeneral.OrientedLattice.Step Λ x y) :
    OrientedLattice.stepHol (R.reflectLinkField U) s =
      (OrientedLattice.stepHol U (R.reflectStep s))⁻¹ := by
  cases s with
  | fwd e =>
      rw [reflectStep, OrientedLattice.stepHol_castEndpoints,
        R.stepHol_reflectLinkField_fwd U e]
      simp [OrientedLattice.stepHol]
  | rev e =>
      rw [reflectStep, OrientedLattice.stepHol_castEndpoints,
        R.stepHol_reflectLinkField_rev U e]
      simp [OrientedLattice.stepHol]

/-- The walk-level mirror: reverse traversal order and reflect each step.
The endpoint reversal in `reflectStep` forces the order reversal if the result
is to remain a typed walk. -/
def mirrorWalk :
    {x y : Λ.V} → Walk Λ x y → Walk Λ (R.reflectV y) (R.reflectV x)
  | _, _, Walk.nil x => Walk.nil (R.reflectV x)
  | _, _, Walk.cons s w =>
      Walk.append (mirrorWalk w)
        (Walk.cons (reflectStep R s) (Walk.nil _))

/-- **Walk-level mirror holonomy identity (N3 fix).**

With the corrected inverse-carrying `reflectLinkField`, the mirror walk's
holonomy at an arbitrary link field `U` is the GROUP INVERSE of the original
walk's holonomy at the reflected link field `theta U`:
`hol U (mirrorWalk w) = (hol (theta U) w)^{-1}`.

This is the honest, `MulOpposite`-free replacement for the previous
`op_hol_reflectLinkField_mirrorWalk`. Both the order reversal (from
`mirrorWalk`/`Step.reverse`) and the per-letter inversion (from the inverse
in `reflectLinkField`) are now accounted for in `G` itself, so for a closed
walk the mirror holonomy is literally the group inverse - a conjugacy-class
invariant, unlike the previous pure word reversal (see
`MirrorHolonomyConjugation.lean`). -/
theorem hol_mirrorWalk_eq_inv (U : Λ.LinkField (G := G))
    {x y : Λ.V} (w : Walk Λ x y) :
    OrientedLattice.hol U (R.mirrorWalk w) =
      (OrientedLattice.hol (R.reflectLinkField U) w)⁻¹ := by
  induction w with
  | nil x =>
      simp [mirrorWalk, OrientedLattice.hol]
  | cons s w ih =>
      rw [mirrorWalk, OrientedLattice.hol_append, ih]
      have hs : OrientedLattice.stepHol U (R.reflectStep s)
          = (OrientedLattice.stepHol (R.reflectLinkField U) s)⁻¹ := by
        rw [R.stepHol_reflectLinkField_reflectStep U s, inv_inv]
      simp only [OrientedLattice.hol, mul_one, hs, mul_inv_rev]

end Reflection
end ReflectionCore
end GateYM
end NullEdge
end Draft
end PhysicsSM
