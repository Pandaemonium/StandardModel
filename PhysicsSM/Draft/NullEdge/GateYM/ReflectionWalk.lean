import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionCore

/-!
# Gate YM3: walk-level reflection and order reversal

This draft module extends `ReflectionCore` from single reflected steps to full
typed walks. The key point is noncommutative order: a reflected walk has to
reverse the order of steps to remain type-correct, so the naive statement
`hol (theta U) w = (hol U (mirrorWalk w))^-1` is not correct for arbitrary
nonabelian groups.

The correct first target records the order reversal in the opposite group:

`op (hol (theta U) w) = hol (op U) (mirrorWalk w)`.

This is the finite holonomy-transport identity needed before any later
plaquette/reflection or RP-LINK statement. It still does not prove Wilson action
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

/-- Step-level compatibility between `reflectLinkField` and the mirrored step.
This packages the forward/reverse lemmas from `ReflectionCore` into one typed
statement, with endpoint casts handled by `Step.castEndpoints`. -/
theorem stepHol_reflectLinkField_reflectStep (U : Λ.LinkField (G := G))
    {x y : Λ.V} (s : GaugeCoreGeneral.OrientedLattice.Step Λ x y) :
    OrientedLattice.stepHol (R.reflectLinkField U) s =
      OrientedLattice.stepHol U (R.reflectStep s) := by
  cases s with
  | fwd e =>
      rw [reflectStep, OrientedLattice.stepHol_castEndpoints]
      exact R.stepHol_reflectLinkField_fwd U e
  | rev e =>
      rw [reflectStep, OrientedLattice.stepHol_castEndpoints]
      exact R.stepHol_reflectLinkField_rev U e

/-- Opposite-group version of reflected-step compatibility. -/
theorem stepHol_opLinkField_reflectStep (U : Λ.LinkField (G := G))
    {x y : Λ.V} (s : GaugeCoreGeneral.OrientedLattice.Step Λ x y) :
    OrientedLattice.stepHol (opLinkField U) (R.reflectStep s) =
      MulOpposite.op (OrientedLattice.stepHol (R.reflectLinkField U) s) := by
  rw [stepHol_opLinkField]
  rw [stepHol_reflectLinkField_reflectStep]

/-- The walk-level mirror: reverse traversal order and reflect each step.
The endpoint reversal in `reflectStep` forces the order reversal if the result
is to remain a typed walk. -/
def mirrorWalk (R : Reflection Λ) :
    {x y : Λ.V} → Walk Λ x y → Walk Λ (R.reflectV y) (R.reflectV x)
  | _, _, Walk.nil x => Walk.nil (R.reflectV x)
  | _, _, Walk.cons s w =>
      Walk.append (mirrorWalk R w)
        (Walk.cons (reflectStep R s) (Walk.nil _))

/-- Walk-level reflection compatibility, stated in the opposite group to record
the order reversal of noncommutative holonomy multiplication. -/
theorem op_hol_reflectLinkField_mirrorWalk (U : Λ.LinkField (G := G))
    {x y : Λ.V} (w : Walk Λ x y) :
    MulOpposite.op (OrientedLattice.hol (R.reflectLinkField U) w) =
      OrientedLattice.hol (opLinkField U) (mirrorWalk R w) := by
  induction w with
  | nil x =>
      simp [mirrorWalk, OrientedLattice.hol]
  | cons s w ih =>
      rw [mirrorWalk, OrientedLattice.hol_append]
      rw [← ih]
      simp [OrientedLattice.hol, stepHol_opLinkField_reflectStep]

end Reflection
end ReflectionCore
end GateYM
end NullEdge
end Draft
end PhysicsSM

#check @Reflection.mirrorWalk
